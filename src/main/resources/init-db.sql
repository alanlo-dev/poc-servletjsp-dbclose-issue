-- Staff Attendance Database Initialization Script for SQL Server
-- Run this script against your SQL Server instance to create the database and tables

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'StaffAttendance')
BEGIN
    CREATE DATABASE StaffAttendance;
END
GO

USE StaffAttendance;
GO

-- Staff table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'staff')
BEGIN
    CREATE TABLE staff (
        id INT PRIMARY KEY IDENTITY(1,1),
        name NVARCHAR(100) NOT NULL,
        department NVARCHAR(100),
        email NVARCHAR(100)
    );
END
GO

-- Attendance records table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'attendance_records')
BEGIN
    CREATE TABLE attendance_records (
        id INT PRIMARY KEY IDENTITY(1,1),
        staff_id INT NOT NULL,
        staff_name NVARCHAR(100),
        check_in_time DATETIME,
        check_out_time DATETIME,
        status NVARCHAR(20) DEFAULT 'CHECKED_OUT',
        FOREIGN KEY (staff_id) REFERENCES staff(id)
    );
END
GO

-- Insert sample staff data
IF NOT EXISTS (SELECT * FROM staff)
BEGIN
    INSERT INTO staff (name, department, email) VALUES
        ('John Smith', 'Engineering', 'john.smith@company.com'),
        ('Jane Doe', 'Marketing', 'jane.doe@company.com'),
        ('Bob Johnson', 'Sales', 'bob.johnson@company.com'),
        ('Alice Williams', 'Human Resources', 'alice.williams@company.com'),
        ('Charlie Brown', 'Finance', 'charlie.brown@company.com');
END
GO