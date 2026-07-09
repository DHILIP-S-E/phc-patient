require('dotenv').config();
const express = require('express');
const cors = require('cors');
const districtRoutes = require('./src/routes/district_routes');

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Routes
app.use('/api/v1/district', districtRoutes);

app.get('/health', (req, res) => {
  res.json({ status: 'UP' });
});

app.listen(port, () => {
  console.log(`Backend server running on port ${port}`);
});
