-- =========================================
-- 1. CREATE ROLES
-- =========================================

CREATE ROLE readonly;
CREATE ROLE readwrite;

-- =========================================
-- 2. CREATE USERS
-- =========================================

-- user for analytics (read-only)
CREATE USER analyst_user WITH PASSWORD 'analyst_password';
-- user for management (read-write)
CREATE USER manager_user WITH PASSWORD 'manager_password';

-- =========================================
-- 3. ASSIGN ROLES TO USERS
-- =========================================

GRANT readonly TO analyst_user;
GRANT readwrite TO manager_user;

-- =========================================
-- 4. GRANT PERMISSIONS TO ROLES
-- =========================================

-- READ-ONLY ROLE
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;

-- Automatically grant SELECT on future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO readonly;

-- READ-WRITE ROLE
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA public
TO readwrite;

-- Allow usage of sequences
GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA public
TO readwrite;

-- Automatically grant privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO readwrite;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT USAGE, SELECT ON SEQUENCES TO readwrite;

-- =========================================
-- 5. OPTIONAL: REVOKE EXAMPLE
-- =========================================

-- Prevent readonly user from accessing a sensitive table
-- REVOKE SELECT ON trainers FROM readonly;

-- =========================================
-- 6. CLEANUP 
-- =========================================

-- DROP USER analyst_user;
-- DROP USER manager_user;
-- DROP ROLE readonly;
-- DROP ROLE readwrite;
