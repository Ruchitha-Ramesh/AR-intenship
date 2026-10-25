
-- Mobile Attendance Tracker
-- Tested database queries
-- Database: attendance_db

-- 1. View all users (admin and students)
SELECT user_id, name, email, role
FROM users
ORDER BY user_id;


-- 2. View attendance records for a particular student
-- Example: student_id = 2
SELECT attendance_date, check_in_time, status
FROM attendance
WHERE student_id = 2
ORDER BY attendance_date DESC;


-- 3. Admin attendance report
-- Displays student details and their attendance records
SELECT
    u.user_id,
    u.name,
    u.email,
    a.attendance_date,
    a.check_in_time,
    a.status
FROM users u
JOIN attendance a
    ON u.user_id = a.student_id
WHERE u.role = 'student'
ORDER BY a.attendance_date DESC;


-- 4. Attendance summary
-- Counts attendance records by status
SELECT status, COUNT(*) AS total
FROM attendance
GROUP BY status;


-- 5. Insert an attendance record
-- Example only: run only when a new record is needed.
-- Do not rerun for a student who already has a record
-- for the current date.
-- INSERT INTO attendance (student_id, status)
-- VALUES (2, 'present');
