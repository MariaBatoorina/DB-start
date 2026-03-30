-- ============================================
-- DML: INSERT DATA FOR TRAINERS DOMAIN (DEV2)
-- Maria Batoorina
-- ============================================

-- =========================
-- TRAINERS (10 records)
-- =========================
INSERT INTO trainers (id, first_name, last_name, email, phone) VALUES
(1, 'Ihor', 'Kovalchuk', 'ihor.kovalchuk@gmail.com', '+380501234567'),
(2, 'Olena', 'Shevchenko', 'olena.shevchenko@gmail.com', '+380502345678'),
(3, 'Andrii', 'Melnyk', 'andrii.melnyk@gmail.com', '+380503456789'),
(4, 'Svitlana', 'Bondarenko', 'svitlana.bondarenko@gmail.com', '+380504567890'),
(5, 'Taras', 'Tkachenko', 'taras.tkachenko@gmail.com', '+380505678901'),
(6, 'Nataliia', 'Kravets', 'nataliia.kravets@gmail.com', '+380506789012'),
(7, 'Dmytro', 'Polishchuk', 'dmytro.polishchuk@gmail.com', '+380507890123'),
(8, 'Iryna', 'Mazur', 'iryna.mazur@gmail.com', '+380508901234'),
(9, 'Serhii', 'Hrytsenko', 'serhii.hrytsenko@gmail.com', '+380509012345'),
(10, 'Oksana', 'Lysenko', 'oksana.lysenko@gmail.com', '+380501112233');

-- =========================
-- SPECIALIZATIONS (10 records)
-- =========================
INSERT INTO specializations (id, name, description) VALUES
(1, 'Yoga', 'Flexibility and relaxation training'),
(2, 'Strength Training', 'Muscle building and resistance training'),
(3, 'Cardio', 'Endurance and heart health workouts'),
(4, 'Pilates', 'Core strength and posture improvement'),
(5, 'Crossfit', 'High-intensity functional training'),
(6, 'Stretching', 'Mobility and flexibility exercises'),
(7, 'Rehabilitation', 'Recovery and injury prevention'),
(8, 'HIIT', 'High intensity interval training'),
(9, 'Boxing', 'Combat fitness training'),
(10, 'Functional Training', 'Everyday movement strength');

-- =========================
-- TRAINER SPECIALIZATIONS (M:N)
-- Each trainer has 1–2 specializations
-- =========================
INSERT INTO trainer_specializations (trainer_id, specialization_id) VALUES
(1, 1), (1, 6),
(2, 2), (2, 5),
(3, 3), (3, 8),
(4, 4),
(5, 2), (5, 10),
(6, 1), (6, 4),
(7, 7),
(8, 8), (8, 3),
(9, 9),
(10, 10), (10, 5);

-- =========================
-- TRAINER AVAILABILITY (12 records)
-- Weekly schedule for trainers
-- =========================
INSERT INTO trainer_availability (id, trainer_id, day_of_week, start_time, end_time) VALUES
(1, 1, 1, '09:00', '13:00'),
(2, 1, 3, '14:00', '18:00'),
(3, 2, 2, '10:00', '15:00'),
(4, 3, 4, '08:00', '12:00'),
(5, 4, 5, '16:00', '20:00'),
(6, 5, 1, '12:00', '16:00'),
(7, 6, 2, '09:00', '13:00'),
(8, 7, 3, '15:00', '19:00'),
(9, 8, 4, '10:00', '14:00'),
(10, 9, 5, '11:00', '15:00'),
(11, 10, 6, '09:00', '13:00'),
(12, 10, 0, '14:00', '18:00');

-- ============================================
-- UPDATE EXAMPLE
-- Demonstrates updating trainer status
-- ============================================
UPDATE trainers
SET status = 'on_leave'
WHERE id = 3;

-- ============================================
-- DELETE EXAMPLE
-- Demonstrates removing specialization from trainer
-- ============================================
DELETE FROM trainer_specializations
WHERE trainer_id = 1 AND specialization_id = 6;


-- ============================================
-- DELETE EXAMPLE - 2
-- Demonstrates removing specialization from trainer
-- ============================================
DELETE FROM trainer_specializations
WHERE trainer_id = 1 AND specialization_id = 6;
