package com.staffattendance.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.staffattendance.db.DBUtil;

public class CheckInServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/checkin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String staffId = request.getParameter("staffId");

        if (staffId == null || staffId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/checkin.jsp?error=Please select a staff member");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection(getServletContext());

            // Get staff name first
            String nameSql = "SELECT name FROM staff WHERE id = ?";
            stmt = conn.prepareStatement(nameSql);
            stmt.setInt(1, Integer.parseInt(staffId));
            rs = stmt.executeQuery();
            String staffName = "";
            if (rs.next()) {
                staffName = rs.getString("name");
            }
            rs.close();
            stmt.close();

            // Check if already checked in
            String checkSql = "SELECT id FROM attendance_records WHERE staff_id = ? AND status = 'CHECKED_IN'";
            stmt = conn.prepareStatement(checkSql);
            stmt.setInt(1, Integer.parseInt(staffId));
            rs = stmt.executeQuery();
            if (rs.next()) {
                response.sendRedirect(request.getContextPath() + "/checkin.jsp?error=" +
                        java.net.URLEncoder.encode(staffName + " is already checked in", "UTF-8"));
                return;
            }
            rs.close();
            stmt.close();

            // Insert check-in record
            String sql = "INSERT INTO attendance_records (staff_id, staff_name, check_in_time, status) VALUES (?, ?, GETDATE(), 'CHECKED_IN')";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(staffId));
            stmt.setString(2, staffName);
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/checkin.jsp?success=" +
                    java.net.URLEncoder.encode(staffName + " checked in successfully", "UTF-8"));

        } catch (SQLException e) {
            throw new ServletException("Database error processing check-in", e);
        } finally {
            DBUtil.closeQuietly(rs);
            DBUtil.closeQuietly(stmt);
            DBUtil.closeQuietly(conn);
        }
    }
}