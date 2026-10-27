-- Mobile Attendance Tracker database
-- Ordered master script based on the tables and sample records provided.
-- Run while connected to the intended database, e.g. attendance_db.
-- Sample password_hash values are placeholders, not valid login password hashes.

BEGIN;

-- 1. USERS: create this first because other tables reference it.
CREATE TABLE IF NOT EXISTS public.users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) NOT NULL,
    CONSTRAINT users_email_key UNIQUE (email),
    CONSTRAINT users_role_check CHECK (role IN ('admin', 'student'))
);

-- 2. ATTENDANCE: references users(user_id).
CREATE TABLE IF NOT EXISTS public.attendance (
    attendance_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    attendance_date DATE NOT NULL DEFAULT CURRENT_DATE,
    check_in_time TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL,
    CONSTRAINT attendance_status_check CHECK (status IN ('present', 'absent', 'late')),
    CONSTRAINT unique_student_attendance_date UNIQUE (student_id, attendance_date),
    CONSTRAINT attendance_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(user_id)
);

-- 3. STUDENT DETAILS: references users(user_id).
CREATE TABLE IF NOT EXISTS public.student_details (
    student_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    contact VARCHAR(15),
    course VARCHAR(100) NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    duration INTEGER NOT NULL,
    CONSTRAINT fk_student_user FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);

-- 4. ADMIN DETAILS: references users(user_id).
CREATE TABLE IF NOT EXISTS public.admin_details (
    admin_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    contact VARCHAR(15),
    designation VARCHAR(100) NOT NULL,
    date_of_join DATE NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT fk_admin_user FOREIGN KEY (user_id) REFERENCES public.users(user_id)
);

-- 5. PUBLIC HOLIDAYS.
CREATE TABLE IF NOT EXISTS public.public_holidays (
    holiday_id SERIAL PRIMARY KEY,
    holiday_name VARCHAR(100) NOT NULL,
    holiday_date DATE NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Insert the two test users.
INSERT INTO public.users (name, email, password_hash, role)
VALUES
    ('Test Admin', 'admin@example.com', 'temporary_hash', 'admin'),
    ('Test Student', 'student@example.com', 'temporary_hash', 'student')
ON CONFLICT (email) DO NOTHING;

-- 7. Insert the attendance records shown in the current database.
INSERT INTO public.attendance (student_id, attendance_date, check_in_time, status)
VALUES
    (2, '2026-10-24', '2026-10-24 18:16:20.076466', 'present'),
    (2, '2026-10-25', '2026-10-25 10:07:38.234881', 'present')
ON CONFLICT (student_id, attendance_date) DO NOTHING;

-- 8. Insert the student details shown in the current database.
INSERT INTO public.student_details
    (user_id, first_name, last_name, contact, course, enrollment_date, duration)
VALUES
    (1, 'Rahul', 'Kumar', '9876543210', 'BCA', '2026-06-15', 3),
    (2, 'Priya', 'Sharma', '9876543211', 'BCA', '2026-06-20', 3)
ON CONFLICT (user_id) DO NOTHING;

-- 9. Insert the admin details shown in the current database.
INSERT INTO public.admin_details
    (user_id, first_name, last_name, contact, designation, date_of_join)
VALUES
    (1, 'Arun', 'Kumar', '9876543212', 'System Administrator', '2025-01-10'),
    (2, 'Meena', 'Devi', '9876543213', 'HR Administrator', '2025-03-15')
ON CONFLICT (user_id) DO NOTHING;

-- 10. Insert the public holiday records from the earlier SQL file.
-- Dates are preserved as supplied and have not been independently verified.
INSERT INTO public.public_holidays (holiday_name, holiday_date, description)
VALUES
    ('New Year', '2026-01-01', 'New Year''s Day'),
    ('Pongal', '2026-01-15', 'Pongal festival'),
    ('Thiruvalluvar Day', '2026-01-16', 'Thiruvalluvar Day'),
    ('Uzhavar Thirunal', '2026-01-17', 'Farmers'' festival'),
    ('Republic Day', '2026-01-26', 'Indian Republic Day'),
    ('Maha Shivaratri', '2026-02-15', 'Maha Shivaratri'),
    ('Holi', '2026-03-04', 'Holi festival'),
    ('Ugadi', '2026-03-19', 'Ugadi / Telugu and Kannada New Year'),
    ('Eid al-Fitr', '2026-03-20', 'Date may vary by local moon sighting'),
    ('Good Friday', '2026-04-03', 'Good Friday'),
    ('Tamil New Year', '2026-04-14', 'Tamil New Year'),
    ('May Day', '2026-05-01', 'Labour Day'),
    ('Eid al-Adha', '2026-05-27', 'Date may vary by local moon sighting'),
    ('Muharram', '2026-06-26', 'Date may vary by local moon sighting'),
    ('Independence Day', '2026-08-15', 'Indian Independence Day'),
    ('Milad-un-Nabi', '2026-08-26', 'Date may vary by local moon sighting'),
    ('Krishna Janmashtami', '2026-09-04', 'Krishna Janmashtami'),
    ('Ganesh Chaturthi', '2026-09-14', 'Ganesh Chaturthi'),
    ('Gandhi Jayanti', '2026-10-02', 'Gandhi Jayanti'),
    ('Navaratri', '2026-10-11', 'Navaratri'),
    ('Ayudha Pooja', '2026-10-20', 'Ayudha Pooja'),
    ('Vijayadashami', '2026-10-21', 'Vijayadashami'),
    ('Deepavali', '2026-11-08', 'Deepavali'),
    ('Chhath Puja', '2026-11-15', 'Chhath Puja'),
    ('Christmas', '2026-12-25', 'Christmas Day')
ON CONFLICT (holiday_date) DO NOTHING;

COMMIT;

-- Verification queries
SELECT * FROM public.users ORDER BY user_id;
SELECT * FROM public.attendance ORDER BY attendance_date, attendance_id;
SELECT * FROM public.student_details ORDER BY student_id;
SELECT * FROM public.admin_details ORDER BY admin_id;
SELECT * FROM public.public_holidays ORDER BY holiday_date;
