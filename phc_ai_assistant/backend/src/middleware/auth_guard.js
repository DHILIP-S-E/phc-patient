const jwt = require('jsonwebtoken');

const authGuard = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  
  if (!token) {
    // For demo purposes, if no token, simulate a mocked payload
    req.user = {
      id: 'usr-101',
      role: 'DISTRICT_ADMIN',
      district_id: 'DIST-555',
      name: 'Dr. Rahul Sharma'
    };
    return next();
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'secret');
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid token' });
  }
};

module.exports = authGuard;
