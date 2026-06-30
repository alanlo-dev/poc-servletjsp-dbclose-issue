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

public class CheckOutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String recordId = request.getParameter("recordId");

        if (recordId == null || recordId.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=Please select a record");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection(getServletContext());

            // Get the staff name for this record
            String nameSql = "SELECT a.staff_name, a.staff_id FROM attendance_records a WHERE a.id = ? AND a.status = 'CHECKED_IN'";
            stmt = conn.prepareStatement(nameSql);
            stmt.setInt(1, Integer.parseInt(recordId));
            rs = stmt.executeQuery();

            String staffName = "";
            if (rs.next()) {
                staffName = rs.getString("staff_name");
            } else {
                response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=Record not found or already checked out");
                return;
            }
            rs.close();
            stmt.close();

            // Update check-out time and status
            String sql = "UPDATE attendance_records SET check_out_time = GETDATE(), status = 'CHECKED_OUT' WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(recordId));
            stmt.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/checkout.jsp?success=" +
                    java.net.URLEncoder.encode(staffName + " checked out successfully", "UTF-8"));

        } catch (SQLException e) {
            throw new ServletException("Database error processing check-out", e);
        } finally {
            DBUtil.closeQuietly(rs);
            DBUtil.closeQuietly(stmt);
            DBUtil.closeQuietly(conn);
        }
    }
}