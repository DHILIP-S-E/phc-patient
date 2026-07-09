-- ==========================================
-- NHM Platform PostgreSQL Schema
-- ==========================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Facilities
CREATE TABLE facilities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('PHC', 'CHC', 'DH', 'SC', 'HWC')),
    district_id UUID NOT NULL
);

-- 2. Inventory Ledgers
CREATE TABLE inventory_ledgers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    facility_id UUID REFERENCES facilities(id),
    item_name VARCHAR(255) NOT NULL,
    current_stock INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 100
);

-- 3. Clinical Encounters (OPD Footfall)
CREATE TABLE clinical_encounters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    facility_id UUID REFERENCES facilities(id),
    patient_id UUID NOT NULL,
    diagnosis VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. District Indents (Requests from PHCs)
CREATE TABLE district_indents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    facility_id UUID REFERENCES facilities(id),
    requested_qty INT NOT NULL,
    approved_qty INT,
    status VARCHAR(50) DEFAULT 'PENDING',
    remarks TEXT
);

-- 5. Audit Logs
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    actor_id VARCHAR(255) NOT NULL,
    action VARCHAR(255) NOT NULL,
    resource_id UUID NOT NULL,
    details JSONB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- ROW-LEVEL SECURITY (RLS) POLICIES
-- ==========================================

-- Enable RLS on all tables
ALTER TABLE facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory_ledgers ENABLE ROW LEVEL SECURITY;
ALTER TABLE clinical_encounters ENABLE ROW LEVEL SECURITY;
ALTER TABLE district_indents ENABLE ROW LEVEL SECURITY;

-- The magic happens here: We read the session variable 'app.current_district_id'
-- which is securely injected by our Node.js backend middleware on every request.

CREATE POLICY district_admin_facility_policy ON facilities
FOR SELECT
USING (district_id = current_setting('app.current_district_id')::UUID);

CREATE POLICY district_admin_inventory_policy ON inventory_ledgers
FOR SELECT
USING (facility_id IN (
    SELECT id FROM facilities WHERE district_id = current_setting('app.current_district_id')::UUID
));

CREATE POLICY district_admin_encounter_policy ON clinical_encounters
FOR SELECT
USING (facility_id IN (
    SELECT id FROM facilities WHERE district_id = current_setting('app.current_district_id')::UUID
));

-- District Admins can SELECT and UPDATE indents, but only for their district
CREATE POLICY district_admin_indent_select ON district_indents
FOR SELECT
USING (facility_id IN (
    SELECT id FROM facilities WHERE district_id = current_setting('app.current_district_id')::UUID
));

CREATE POLICY district_admin_indent_update ON district_indents
FOR UPDATE
USING (facility_id IN (
    SELECT id FROM facilities WHERE district_id = current_setting('app.current_district_id')::UUID
));
