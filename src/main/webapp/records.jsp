<%@ page import="java.sql.*, com.staffattendance.db.DBUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Attendance Records</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f4f6f9; color: #333; }
        .container { max-width: 1100px; margin: 0 auto; padding: 20px; }
        .header { background: #2c3e50; color: white; padding: 20px 0; margin-bottom: 30px; }
        .header h1 { text-align: center; }
        .nav { display: flex; justify-content: center; gap: 15px; margin-bottom: 30px; }
        .nav a { text-decoration: none; color: white; background: #3498db; padding: 10px 20px; border-radius: 5px; font-size: 14px; }
        .nav a:hover { background: #2980b9; }
        .filter-card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-bottom: 20px; display: flex; gap: 15px; align-items: flex-end; flex-wrap: wrap; }
        .filter-group { display: flex; flex-direction: column; }
        .filter-group label { font-size: 12px; font-weight: bold; color: #555; margin-bottom: 3px; }
        .filter-group select, .filter-group input { padding: 8px; border: 1px solid #ddd; border-radius: 5px; font-size: 13px; }
        .btn-filter { background: #3498db; color: white; padding: 8px 20px; border: none; border-radius: 5px; font-size: 13px; cursor: pointer; }
        .btn-filter:hover { background: #2980b9; }
        .btn-clear { background: #95a5a6; color: white; padding: 8px 20px; text-decoration: none; border-radius: 5px; font-size: 13px; }
        .btn-clear:hover { background: #7f8c8d; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #8e44ad; color: white; }
        tr:hover { background: #f5f5f5; }
        .badge { padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .badge.checked-in { background: #d4edda; color: #155724; }
        .badge.checked-out { background: #f8d7da; color: #721c24; }
        .summary { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 15px; margin-bottom: 20px; }
        .summary-card { background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center; }
        .summary-card h4 { color: #7f8c8d; font-size: 12px; margin-bottom: 5px; }
        .summary-card .num { font-size: 24px; font-weight: bold; color: #2c3e50; }
        .pagination { margin-top: 20px; text-align: center; }
        .pagination a { display: inline-block; padding: 8px 12px; margin: 0 3px; background: white; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #3498db; }
        .pagination a:hover { background: #3498db; color: white; }
        .pagination .active { background: #3498db; color: white; border-color: #3498db; }
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
            // Get filter parameters
            String filterStaffId = request.getParameter("staffId");
            String filterDate = request.getParameter("date");
            String pageParam = request.getParameter("page");
            int currentPage = 1;
            int recordsPerPage = 20;
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {}
            }
        %>

        <%
            // Summary stats
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            int totalRecords = 0;
            int todayRecords = 0;
            int checkedInRecords = 0;

            try {
                conn = DBUtil.getConnection(application);
                stmt = conn.createStatement();

                StringBuilder countSql = new StringBuilder("SELECT COUNT(*) FROM attendance_records WHERE 1=1");
                if (filterStaffId != null && !filterStaffId.isEmpty()) {
                    countSql.append(" AND staff_id = ").append(filterStaffId);
                }
                if (filterDate != null && !filterDate.isEmpty()) {
                    countSql.append(" AND CONVERT(date, check_in_time) = '").append(filterDate).append("'");
                }
                rs = stmt.executeQuery(countSql.toString());
                if (rs.next()) totalRecords = rs.getInt(1);
                rs.close();

                rs = stmt.executeQuery("SELECT COUNT(*) FROM attendance_records WHERE CONVERT(date, check_in_time) = CONVERT(date, GETDATE())");
                if (rs.next()) todayRecords = rs.getInt(1);
                rs.close();

                rs = stmt.executeQuery("SELECT COUNT(*) FROM attendance_records WHERE status = 'CHECKED_IN'");
                if (rs.next()) checkedInRecords = rs.getInt(1);
                rs.close();
            } catch (SQLException e) {
                out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
            } finally {
                DBUtil.closeQuietly(rs);
                DBUtil.closeQuietly(stmt);
                DBUtil.closeQuietly(conn);
            }
        %>

        <div class="summary">
            <div class="summary-card">
                <h4>Total Records</h4>
                <div class="num"><%= totalRecords %></div>
            </div>
            <div class="summary-card">
                <h4>Today's Records</h4>
                <div class="num"><%= todayRecords %></div>
            </div>
            <div class="summary-card">
                <h4>Currently Checked In</h4>
                <div class="num" style="color:#27ae60;"><%= checkedInRecords %></div>
            </div>
        </div>

        <div class="filter-card">
            <form action="records.jsp" method="get" style="display:flex; gap:15px; align-items:flex-end; flex-wrap:wrap; width:100%;">
                <div class="filter-group">
                    <label for="staffId">Staff Member</label>
                    <select id="staffId" name="staffId">
                        <option value="">All Staff</option>
                        <%
                            try {
                                conn = DBUtil.getConnection(application);
                                stmt = conn.createStatement();
                                rs = stmt.executeQuery("SELECT * FROM staff ORDER BY name");
                                while (rs.next()) {
                                    String selected = (filterStaffId != null && filterStaffId.equals(String.valueOf(rs.getInt("id")))) ? "selected" : "";
                        %>
                        <option value="<%= rs.getInt("id") %>" <%= selected %>><%= rs.getString("name") %></option>
                        <%
                                }
                            } catch (SQLException e) {
                                out.println("<option value=''>Error: " + e.getMessage() + "</option>");
                            } finally {
                                DBUtil.closeQuietly(rs);
                                DBUtil.closeQuietly(stmt);
                                DBUtil.closeQuietly(conn);
                            }
                        %>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="date">Date</label>
                    <input type="date" id="date" name="date" value="<%= filterDate != null ? filterDate : "" %>">
                </div>
                <button type="submit" class="btn-filter">Filter</button>
                <a href="records.jsp" class="btn-clear">Clear</a>
            </form>
        </div>

        <h2 style="margin-bottom:15px;">Attendance Records</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Staff Name</th>
                    <th>Check In</th>
                    <th>Check Out</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    conn = null;
                    stmt = null;
                    rs = null;

                    try {
                        conn = DBUtil.getConnection(application);
                        stmt = conn.createStatement();

                        StringBuilder sql = new StringBuilder(
                            "SELECT a.id, a.staff_name, a.check_in_time, a.check_out_time, a.status " +
                            "FROM attendance_records a WHERE 1=1"
                        );
                        if (filterStaffId != null && !filterStaffId.isEmpty()) {
                            sql.append(" AND a.staff_id = ").append(filterStaffId);
                        }
                        if (filterDate != null && !filterDate.isEmpty()) {
                            sql.append(" AND CONVERT(date, a.check_in_time) = '").append(filterDate).append("'");
                        }
                        sql.append(" ORDER BY a.check_in_time DESC");

                        // Apply pagination
                        int offset = (currentPage - 1) * recordsPerPage;
                        sql.append(" OFFSET ").append(offset).append(" ROWS FETCH NEXT ").append(recordsPerPage).append(" ROWS ONLY");

                        rs = stmt.executeQuery(sql.toString());
                        boolean hasData = false;
                        while (rs.next()) {
                            hasData = true;
                            String status = rs.getString("status");
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("staff_name") %></td>
                    <td><%= rs.getTimestamp("check_in_time") != null ? rs.getTimestamp("check_in_time") : "-" %></td>
                    <td><%= rs.getTimestamp("check_out_time") != null ? rs.getTimestamp("check_out_time") : "-" %></td>
                    <td><span class="badge <%= "CHECKED_IN".equals(status) ? "checked-in" : "checked-out" %>"><%= status %></span></td>
                </tr>
                <%
                        }
                        if (!hasData) {
                            out.println("<tr><td colspan='5' style='text-align:center;'>No records found.</td></tr>");
                        }
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='5' style='color:red;'>Database error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>

        <%
            // Pagination links
            if (totalRecords > recordsPerPage) {
                int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
        %>
        <div class="pagination">
            <% if (currentPage > 1) { %>
                <a href="records.jsp?page=<%= currentPage - 1 %><%= filterStaffId != null ? "&staffId=" + filterStaffId : "" %><%= filterDate != null ? "&date=" + filterDate : "" %>">&laquo; Prev</a>
            <% } %>
            <% for (int i = 1; i <= totalPages; i++) { %>
                <a href="records.jsp?page=<%= i %><%= filterStaffId != null ? "&staffId=" + filterStaffId : "" %><%= filterDate != null ? "&date=" + filterDate : "" %>" class="<%= i == currentPage ? "active" : "" %>"><%= i %></a>
            <% } %>
            <% if (currentPage < totalPages) { %>
                <a href="records.jsp?page=<%= currentPage + 1 %><%= filterStaffId != null ? "&staffId=" + filterStaffId : "" %><%= filterDate != null ? "&date=" + filterDate : "" %>">Next &raquo;</a>
            <% } %>
        </div>
        <%
            }
        %>
    </div>
</body>
</html>