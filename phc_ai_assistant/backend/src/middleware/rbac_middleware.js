const requireRole = (allowedRoles) => {
  return (req, res, next) => {
    if (!req.user || !req.user.role) {
      return res.status(403).json({ error: 'Role not identified' });
    }
    
    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({ 
        error: `Access Denied: Requires one of [${allowedRoles.join(', ')}]` 
      });
    }
    
    next();
  };
};

module.exports = requireRole;
