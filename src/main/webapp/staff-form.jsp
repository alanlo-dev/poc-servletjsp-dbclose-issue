<%@ page import="java.sql.*, com.staffattendance.db.DBUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= request.getParameter("id") != null ? "Edit Staff" : "Add Staff" %></title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f6f9; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #2c3e50; color: white; padding: 20px 0; margin-bottom: 30px; }
        .header h1 { text-align: center; }
        .nav { display: flex; justify-content: center; gap: 15px; margin-bottom: 30px; }
        .nav a { text-decoration: none; color: white; background: #3498db; padding: 10px 20px; border-radius: 5px; font-size: 14px; }
        .nav a:hover { background: #2980b9; }
        .form-card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px; }
        .form-group input:focus { outline: none; border-color: #3498db; }
        .btn-submit { background: #3498db; color: white; padding: 10px 20px; border: none; border-radius: 5px; font-size: 16px; cursor: pointer; }
        .btn-submit:hover { background: #2980b9; }
        .btn-cancel { background: #95a5a6; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-size: 14px; margin-left: 10px; }
        .btn-cancel:hover { background: #7f8c8d; }
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

        <div class="form-card">
            <%
                String idParam = request.getParameter("id");
                boolean isEdit = idParam != null && !idParam.isEmpty();
                String name = "";
                String department = "";
                String email = "";
                String actionType = isEdit ? "update" : "add";

                if (isEdit) {
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    try {
                        conn = DBUtil.getConnection(application);
                        String sql = "SELECT * FROM staff WHERE id = ?";
                        stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, Integer.parseInt(idParam));
                        rs = stmt.executeQuery();
                        if (rs.next()) {
                            name = rs.getString("name") != null ? rs.getString("name") : "";
                            department = rs.getString("department") != null ? rs.getString("department") : "";
                            email = rs.getString("email") != null ? rs.getString("email") : "";
                        }
                    } catch (SQLException e) {
                        out.println("<p style='color:red;'>Error loading staff: " + e.getMessage() + "</p>");
                    } finally {
                        DBUtil.closeQuietly(rs);
                        DBUtil.closeQuietly(stmt);
                        DBUtil.closeQuietly(conn);
                    }
                }
            %>
            <h2 style="margin-bottom:20px;"><%= isEdit ? "Edit Staff Member" : "Add New Staff Member" %></h2>
            <form action="staff" method="post">
                <% if (isEdit) { %>
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= idParam %>">
                <% } else { %>
                <input type="hidden" name="action" value="add">
                <% } %>

                <div class="form-group">
                    <label for="name">Name *</label>
                    <input type="text" id="name" name="name" value="<%= name %>" required>
                </div>
                <div class="form-group">
                    <label for="department">Department</label>
                    <input type="text" id="department" name="department" value="<%= department %>">
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="<%= email %>">
                </div>
                <div>
                    <button type="submit" class="btn-submit"><%= isEdit ? "Update" : "Save" %></button>
                    <a href="staff-list.jsp" class="btn-cancel">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>