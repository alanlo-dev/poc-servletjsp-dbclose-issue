<%@ page import="java.sql.*, com.staffattendance.db.DBUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Management</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f6f9; color: #333; }
        .container { max-width: 1100px; margin: 0 auto; padding: 20px; }
        .header { background: #2c3e50; color: white; padding: 20px 0; margin-bottom: 30px; }
        .header h1 { text-align: center; }
        .nav { display: flex; justify-content: center; gap: 15px; margin-bottom: 30px; }
        .nav a { text-decoration: none; color: white; background: #3498db; padding: 10px 20px; border-radius: 5px; font-size: 14px; }
        .nav a:hover { background: #2980b9; }
        .actions { margin-bottom: 20px; }
        .actions a { text-decoration: none; color: white; background: #27ae60; padding: 10px 20px; border-radius: 5px; font-size: 14px; }
        .actions a:hover { background: #219a52; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #3498db; color: white; }
        tr:hover { background: #f5f5f5; }
        .btn { padding: 5px 10px; border-radius: 4px; text-decoration: none; font-size: 13px; color: white; }
        .btn-edit { background: #f39c12; }
        .btn-edit:hover { background: #e67e22; }
        .btn-delete { background: #e74c3c; }
        .btn-delete:hover { background: #c0392b; }
        .msg { padding: 10px; margin-bottom: 15px; border-radius: 5px; }
        .msg.success { background: #d4edda; color: #155724; }
        .msg.error { background: #f8d7da; color: #721c24; }
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

        <div class="actions">
            <a href="staff-form.jsp">+ Add New Staff</a>
        </div>

        <h2 style="margin-bottom:15px;">All Staff Members</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Department</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        conn = DBUtil.getConnection(application);
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery("SELECT * FROM staff ORDER BY name");
                        boolean hasData = false;
                        while (rs.next()) {
                            hasData = true;
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("department") != null ? rs.getString("department") : "-" %></td>
                    <td><%= rs.getString("email") != null ? rs.getString("email") : "-" %></td>
                    <td>
                        <a href="staff-form.jsp?id=<%= rs.getInt("id") %>" class="btn btn-edit">Edit</a>
                        <a href="staff?action=delete&id=<%= rs.getInt("id") %>" class="btn btn-delete" onclick="return confirm('Are you sure you want to delete this staff member?')">Delete</a>
                    </td>
                </tr>
                <%
                        }
                        if (!hasData) {
                            out.println("<tr><td colspan='5' style='text-align:center;'>No staff members found.</td></tr>");
                        }
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='5' style='color:red;'>Database error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>