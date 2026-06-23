<%@ page import="java.sql.*, com.staffattendance.db.DBUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Check In</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f6f9; color: #333; }
        .container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .header { background: #2c3e50; color: white; padding: 20px 0; margin-bottom: 30px; }
        .header h1 { text-align: center; }
        .nav { display: flex; justify-content: center; gap: 15px; margin-bottom: 30px; }
        .nav a { text-decoration: none; color: white; background: #3498db; padding: 10px 20px; border-radius: 5px; font-size: 14px; }
        .nav a:hover { background: #2980b9; }
        .form-card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); max-width: 500px; margin: 0 auto; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
        .form-group select { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px; background: white; }
        .form-group select:focus { outline: none; border-color: #27ae60; }
        .btn-checkin { background: #27ae60; color: white; padding: 12px 30px; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; width: 100%; }
        .btn-checkin:hover { background: #219a52; }
        .msg { padding: 10px; margin-bottom: 15px; border-radius: 5px; text-align: center; }
        .msg.success { background: #d4edda; color: #155724; }
        .msg.error { background: #f8d7da; color: #721c24; }
        .current-time { text-align: center; font-size: 24px; color: #555; margin-bottom: 30px; }
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

        <div class="form-card">
            <h2 style="margin-bottom:20px; text-align:center; color:#27ae60;">Check In</h2>

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

            <form action="checkin" method="post">
                <div class="form-group">
                    <label for="staffId">Select Staff Member</label>
                    <select id="staffId" name="staffId" required>
                        <option value="">-- Select Staff --</option>
                        <%
                            Connection conn = null;
                            Statement stmt = null;
                            ResultSet rs = null;
                            try {
                                conn = DBUtil.getConnection(application);
                                stmt = conn.createStatement();
                                rs = stmt.executeQuery("SELECT * FROM staff ORDER BY name");
                                while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %> - <%= rs.getString("department") != null ? rs.getString("department") : "" %></option>
                        <%
                                }
                            } catch (SQLException e) {
                                out.println("<option value=''>Error loading staff: " + e.getMessage() + "</option>");
                            }
                        %>
                    </select>
                </div>
                <button type="submit" class="btn-checkin">Check In Now</button>
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