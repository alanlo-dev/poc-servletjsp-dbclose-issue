<%@ page import="java.sql.*, com.staffattendance.db.DBUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Attendance Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f6f9; color: #333; }
        .container { max-width: 1100px; margin: 0 auto; padding: 20px; }
        .header { background: #2c3e50; color: white; padding: 20px 0; margin-bottom: 30px; }
        .header h1 { text-align: center; }
        .nav { display: flex; justify-content: center; gap: 15px; margin-bottom: 30px; }
        .nav a { text-decoration: none; color: white; background: #3498db; padding: 10px 20px; border-radius: 5px; font-size: 14px; }
        .nav a:hover { background: #2980b9; }
        .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center; }
        .stat-card h3 { color: #7f8c8d; font-size: 14px; margin-bottom: 10px; }
        .stat-card .number { font-size: 36px; font-weight: bold; color: #2c3e50; }
        .stat-card .number.green { color: #27ae60; }
        .stat-card .number.orange { color: #e67e22; }
        .stat-card .number.blue { color: #3498db; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #3498db; color: white; }
        tr:hover { background: #f5f5f5; }
        .badge { padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .badge.checked-in { background: #d4edda; color: #155724; }
        .badge.checked-out { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Staff Attendance System</h1>
    </div>
    <div class="container">
        <div class="nav">
            <a href="index.jsp">Dashboard</a>
            <a href="staff-list.jsp">Staff Management</a>
            <a href="checkin.jsp">Check In</a>
            <a href="checkout.jsp">Check Out</a>
            <a href="records.jsp">Records</a>
        </div>

        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            int totalStaff = 0;
            int checkedIn = 0;
            int checkedOut = 0;
            int todayRecords = 0;

            try {
                conn = DBUtil.getConnection(application);
                stmt = conn.createStatement();

                rs = stmt.executeQuery("SELECT COUNT(*) FROM staff");
                if (rs.next()) totalStaff = rs.getInt(1);
                rs.close();

                rs = stmt.executeQuery("SELECT COUNT(*) FROM attendance_records WHERE status = 'CHECKED_IN'");
                if (rs.next()) checkedIn = rs.getInt(1);
                rs.close();

                rs = stmt.executeQuery("SELECT COUNT(*) FROM attendance_records WHERE status = 'CHECKED_OUT'");
                if (rs.next()) checkedOut = rs.getInt(1);
                rs.close();

                rs = stmt.executeQuery("SELECT COUNT(*) FROM attendance_records WHERE CONVERT(date, check_in_time) = CONVERT(date, GETDATE())");
                if (rs.next()) todayRecords = rs.getInt(1);
                rs.close();
            } catch (SQLException e) {
                out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
            } finally {
                DBUtil.closeQuietly(rs);
                DBUtil.closeQuietly(stmt);
                DBUtil.closeQuietly(conn);
            }
        %>

        <div class="stats">
            <div class="stat-card">
                <h3>Total Staff</h3>
                <div class="number blue"><%= totalStaff %></div>
            </div>
            <div class="stat-card">
                <h3>Currently Checked In</h3>
                <div class="number green"><%= checkedIn %></div>
            </div>
            <div class="stat-card">
                <h3>Total Check Outs</h3>
                <div class="number orange"><%= checkedOut %></div>
            </div>
            <div class="stat-card">
                <h3>Today's Records</h3>
                <div class="number"><%= todayRecords %></div>
            </div>
        </div>

        <h2 style="margin-bottom:15px;">Currently Checked In Staff</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Staff Name</th>
                    <th>Check In Time</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        conn = DBUtil.getConnection(application);
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery(
                            "SELECT a.id, a.staff_name, a.check_in_time, a.status " +
                            "FROM attendance_records a WHERE a.status = 'CHECKED_IN' " +
                            "ORDER BY a.check_in_time DESC"
                        );
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("staff_name") %></td>
                    <td><%= rs.getTimestamp("check_in_time") %></td>
                    <td><span class="badge checked-in">CHECKED IN</span></td>
                </tr>
                <%
                        }
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='4' style='color:red;'>Database error: " + e.getMessage() + "</td></tr>");
                    } finally {
                        DBUtil.closeQuietly(rs);
                        DBUtil.closeQuietly(stmt);
                        DBUtil.closeQuietly(conn);
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>