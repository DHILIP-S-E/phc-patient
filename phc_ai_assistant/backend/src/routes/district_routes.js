const express = require('express');
const router = express.Router();
const { Pool } = require('pg');
const authGuard = require('../middleware/auth_guard');
const requireRole = require('../middleware/rbac_middleware');

// Real DB Connection (Expects DB_URL in .env)
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgres://postgres:postgres@localhost:5432/nhm_platform'
});

// Enforce RLS explicitly at the API layer for queries (Setting session variables)
const executeWithRLS = async (user, query, params = []) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    // Set the Postgres session variable for RLS enforcement
    await client.query(`SET LOCAL app.current_district_id = '${user.district_id}'`);
    
    const result = await client.query(query, params);
    
    await client.query('COMMIT');
    return result;
  } catch (e) {
    await client.query('ROLLBACK');
    throw e;
  } finally {
    client.release();
  }
};

// ==========================================
// API Routes (District Administrator ONLY)
// ==========================================
router.use(authGuard);
router.use(requireRole(['DISTRICT_ADMIN']));

// 1. Dashboard KPIs (Subject to RLS)
router.get('/dashboard', async (req, res) => {
  try {
    // These queries hit tables protected by Row-Level Security.
    // The DB will silently filter out any facility not matching app.current_district_id.
    const footfallResult = await executeWithRLS(req.user, `
      SELECT COUNT(*) as total_footfall 
      FROM clinical_encounters ce
      JOIN facilities f ON ce.facility_id = f.id
      WHERE DATE(ce.created_at) = CURRENT_DATE
    `);

    const stockoutsResult = await executeWithRLS(req.user, `
      SELECT COUNT(*) as stockouts 
      FROM inventory_ledgers
      WHERE current_stock < reorder_level
    `);

    res.json({
      district_id: req.user.district_id,
      kpis: {
        total_footfall: footfallResult.rows[0]?.total_footfall || 0,
        critical_stockouts: stockoutsResult.rows[0]?.stockouts || 0,
      }
    });
  } catch (error) {
    console.error("DB Error:", error);
    res.status(500).json({ error: 'Database connection failed. Ensure PostgreSQL is running.' });
  }
});

// 2. Fetch Indents
router.get('/indents', async (req, res) => {
  try {
    const result = await executeWithRLS(req.user, `
      SELECT id, facility_name, requested_qty, current_stock, ai_recommendation, status
      FROM pending_indents_view
    `);
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 3. Approve Indent
router.post('/indents/:id/approve', async (req, res) => {
  const { id } = req.params;
  const { approved_qty, remarks } = req.body;
  
  try {
    // Must execute within an RLS context so Admin can't approve an indent for another district
    await executeWithRLS(req.user, `
      UPDATE district_indents 
      SET status = 'APPROVED', approved_qty = $1, remarks = $2
      WHERE id = $3
    `, [approved_qty, remarks, id]);
    
    // Log to audit table
    await executeWithRLS(req.user, `
      INSERT INTO audit_logs (actor_id, action, resource_id, details)
      VALUES ($1, 'APPROVE_INDENT', $2, $3)
    `, [req.user.id, id, JSON.stringify({ approved_qty, remarks })]);

    res.json({ success: true, message: 'Indent approved and audited.' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
