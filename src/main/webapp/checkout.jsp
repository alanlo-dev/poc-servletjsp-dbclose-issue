<%@ page import="java.sql.*, com.staffattendance.db.DBUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Check Out</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f6f9; color: #333; }
        .container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .header { background: #2c3e50; color: white; padding: 20px 0; margin-bottom: 30px; }
        .header h1 { text-align: center; }
        .nav { display: flex; justify-content: center; gap: 15px; margin-bottom: 30px; }
        .nav a { text-decoration: none; color: white; background: #3498db; padding: 10px 20px; border-radius: 5px; font-size: 14px; }
        .nav a:hover { background: #2980b9; }
        .form-card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); max-width: 600px; margin: 0 auto; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
        .form-group select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px; background: white; }
        .form-group select:focus { outline: none; border-color: #e67e22; }
        .btn-checkout { background: #e67e22; color: white; padding: 12px 30px; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; width: 100%; }
        .btn-checkout:hover { background: #d35400; }
        .msg { padding: 10px; margin-bottom: 15px; border-radius: 5px; text-align: center; }
        .msg.success { background: #d4edda; color: #155724; }
        .msg.error { background: #f8d7da; color: #721c24; }
        .current-time { text-align: center; font-size: 24px; color: #555; margin-bottom: 30px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-bottom: 30px; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #e67e22; color: white; }
        tr:hover { background: #f5f5f5; }
        .badge { padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .badge.checked-in { background: #d4edda; color: #155724; }
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

        <div class="current-time" id="currentTime"></div>

        <h2 style="margin-bottom:15px;">Currently Checked In Staff</h2>
        <table>
            <thead>
                <tr>
                    <th>Record ID</th>
                    <th>Staff Name</th>
                    <th>Check In Time</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;
                    boolean hasCheckedIn = false;

                    try {
                        conn = DBUtil.getConnection(application);
                        stmt = conn.createStatement();
                        rs = stmt.executeQuery(
                            "SELECT a.id, a.staff_name, a.check_in_time FROM attendance_records a " +
                            "WHERE a.status = 'CHECKED_IN' ORDER BY a.check_in_time DESC"
                        );
                        while (rs.next()) {
                            hasCheckedIn = true;
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("staff_name") %></td>
                    <td><%= rs.getTimestamp("check_in_time") %></td>
                    <td>
                        <form action="checkout" method="post" style="margin:0;">
                            <input type="hidden" name="recordId" value="<%= rs.getInt("id") %>">
                            <button type="submit" class="btn-checkout" style="padding:5px 15px; font-size:13px;">Check Out</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                        if (!hasCheckedIn) {
                            out.println("<tr><td colspan='4' style='text-align:center;'>No staff currently checked in.</td></tr>");
                        }
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='4' style='color:red;'>Database error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>

        <div class="form-card">
            <h2 style="margin-bottom:20px; text-align:center; color:#e67e22;">Quick Check Out by Record ID</h2>

            <% 
                String error = request.getParameter("error");
                String success = request.getParameter("success");
                if (error != null) {
            %>
            <div class="msg error"><%= error %></div>
            <% } %>
            <% if (success != null) { %>
            <div class="msg success"><%= success %></div>
            <% } %>

            <form action="checkout" method="post">
                <div class="form-group">
                    <label for="recordId">Enter Record ID</label>
                    <input type="number" id="recordId" name="recordId" placeholder="Enter record ID to check out" required style="width:100%; padding:10px; border:1px solid #ddd; border-radius:5px; font-size:14px;">
                </div>
                <button type="submit" class="btn-checkout">Check Out</button>
            </form>
        </div>
    </div>

    <script>
        function updateTime() {
            const now = new Date();
            const options = { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: false };
            document.getElementById('currentTime').textContent = now.toLocaleDateString('en-US', options);
        }
        updateTime();
        setInterval(updateTime, 1000);
    </script>
</body>
</html>