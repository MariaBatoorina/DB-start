-- =====================================================
-- 1. FUNCTIONS
-- =====================================================

-- ----------------------------------------------------------------------
-- Purpose: Returns the full name (first + last) of a trainer by ID.
-- Parameters: p_trainer_id - the trainer's ID
-- Returns: TEXT (full name) or NULL if not found
-- ----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION get_trainer_full_name(p_trainer_id INTEGER)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    full_name TEXT;
BEGIN
    SELECT CONCAT(first_name, ' ', last_name) INTO full_name
    FROM trainers
    WHERE id = p_trainer_id;
    
    RETURN full_name;
END;
$$;

SELECT get_trainer_full_name(1) AS trainer_name;

-- ----------------------------------------------------------------------
-- Purpose: Counts how many availability slots a trainer has on a specific day.
-- Parameters: p_trainer_id - trainer ID, p_day_of_week (0=Sunday..6=Saturday)
-- Returns: INTEGER (number of slots)
-- ----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION count_trainer_slots(p_trainer_id INTEGER, p_day_of_week INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    slot_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO slot_count
    FROM trainer_availability
    WHERE trainer_id = p_trainer_id AND day_of_week = p_day_of_week;
    
    RETURN slot_count;
END;
$$;

SELECT count_trainer_slots(1, 1) AS monday_slots;

-- ----------------------------------------------------------------------
-- Purpose: Checks if a trainer is available at a given day and time.
-- Parameters: p_trainer_id, p_day_of_week, p_time (TIME)
-- Returns: BOOLEAN - TRUE if available (time falls within any slot), else FALSE
-- ----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION is_trainer_available(
    p_trainer_id INTEGER,
    p_day_of_week INTEGER,
    p_time TIME
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    available BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM trainer_availability
        WHERE trainer_id = p_trainer_id
          AND day_of_week = p_day_of_week
          AND p_time BETWEEN start_time AND end_time
    ) INTO available;
    
    RETURN available;
END;
$$;

SELECT is_trainer_available(1, 1, '10:30'::TIME) AS available;

-- =====================================================
-- 2. STORED PROCEDURES (SELECT + INSERT)
-- =====================================================

-- ----------------------------------------------------------------------
-- Purpose: Shows all active trainers (SELECT)
-- Parameters: none
-- Behavior: Creates a temporary table with active trainers
-- ----------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE show_active_trainers()
LANGUAGE plpgsql
AS $$
BEGIN
    DROP TABLE IF EXISTS temp_active_trainers;
    CREATE TEMP TABLE temp_active_trainers AS
    SELECT 
        id,
        first_name,
        last_name,
        email,
        status
    FROM trainers
    WHERE status = 'active'
    ORDER BY last_name, first_name;
    RAISE NOTICE 'Found % active trainers', (SELECT COUNT(*) FROM temp_active_trainers);
END;
$$;

CALL show_active_trainers();
SELECT * FROM temp_active_trainers;

-- ----------------------------------------------------------------------
-- Purpose: Adds a new trainer to the database (INSERT)
-- Parameters: first_name, last_name, email, phone, status
-- Behavior: Inserts a new trainer with current date
-- ----------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE add_new_trainer(
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_email VARCHAR,
    p_phone VARCHAR,
    p_status VARCHAR DEFAULT 'active'
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO trainers (first_name, last_name, email, phone, status, hired_at)
    VALUES (p_first_name, p_last_name, p_email, p_phone, p_status, CURRENT_TIMESTAMP);
    RAISE NOTICE 'Trainer % % has been added successfully!', p_first_name, p_last_name;
END;
$$;

CALL add_new_trainer('Anna', 'Shevchenko', 'anna.shevchenko@example.com', '+380501234567', 'active');

-- =====================================================
-- 3. STORED PROCEDURES (UPDATE)
-- =====================================================

-- ----------------------------------------------------------------------
-- Purpose: Updates a trainer's status 
-- Parameters: p_trainer_id, p_new_status
-- Behavior: Checks if trainer exists, validates status, then updates
-- ----------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE update_trainer_status(
    p_trainer_id INTEGER,
    p_new_status VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_trainer_exists BOOLEAN;
    v_old_status VARCHAR;
    v_trainer_name TEXT;
BEGIN
    SELECT 
        EXISTS (SELECT 1 FROM trainers WHERE id = p_trainer_id),
        status,
        CONCAT(first_name, ' ', last_name)
    INTO v_trainer_exists, v_old_status, v_trainer_name
    FROM trainers
    WHERE id = p_trainer_id;
    IF NOT v_trainer_exists THEN
        RAISE EXCEPTION 'Trainer with ID % does not exist', p_trainer_id;
    END IF;
    IF p_new_status NOT IN ('active', 'inactive', 'on_leave') THEN
        RAISE EXCEPTION 'Invalid status: %. Allowed values: active, inactive, on_leave', p_new_status;
    END IF;
    UPDATE trainers
    SET status = p_new_status
    WHERE id = p_trainer_id;
    RAISE NOTICE 'Trainer "%" (ID: %) status changed from "%" to "%"', 
                  v_trainer_name, p_trainer_id, v_old_status, p_new_status;
END;
$$;

CALL update_trainer_status(2, 'inactive');
CALL update_trainer_status(3, 'on_leave');

-- ----------------------------------------------------------------------
-- Purpose: Updates a trainer's phone number
-- Parameters: p_trainer_id, p_new_phone
-- Behavior: Checks if trainer exists, then updates phone number
-- ----------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE update_trainer_phone(
    p_trainer_id INTEGER,
    p_new_phone VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_trainer_exists BOOLEAN;
    v_old_phone VARCHAR;
BEGIN
    SELECT EXISTS (SELECT 1 FROM trainers WHERE id = p_trainer_id),
           phone INTO v_trainer_exists, v_old_phone
    FROM trainers
    WHERE id = p_trainer_id;
    IF NOT v_trainer_exists THEN
        RAISE EXCEPTION 'Trainer with ID % does not exist', p_trainer_id;
    END IF;
    UPDATE trainers
    SET phone = p_new_phone
    WHERE id = p_trainer_id;
    RAISE NOTICE 'Phone for trainer ID % changed from "%" to "%"', 
                  p_trainer_id, v_old_phone, p_new_phone;
END;
$$;

CALL update_trainer_phone(1, '+380679999999');
