package com.staffattendance.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.staffattendance.db.DBUtil;

public class StaffServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String id = request.getParameter("id");
            Connection conn = null;
            PreparedStatement stmt = null;
            try {
                conn = DBUtil.getConnection(getServletContext());
                String sql = "DELETE FROM staff WHERE id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, Integer.parseInt(id));
                stmt.executeUpdate();
            } catch (SQLException e) {
                throw new ServletException("Database error deleting staff", e);
            } finally {
                DBUtil.closeQuietly(stmt);
                DBUtil.closeQuietly(conn);
            }
            response.sendRedirect(request.getContextPath() + "/staff-list.jsp");
        } else if ("edit".equals(action)) {
            String id = request.getParameter("id");
            request.setAttribute("staffId", id);
            request.getRequestDispatcher("/staff-form.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/staff-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String department = request.getParameter("department");
        String email = request.getParameter("email");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBUtil.getConnection(getServletContext());

            if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String sql = "UPDATE staff SET name = ?, department = ?, email = ? WHERE id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, department);
                stmt.setString(3, email);
                stmt.setInt(4, id);
                stmt.executeUpdate();
            } else {
                String sql = "INSERT INTO staff (name, department, email) VALUES (?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, department);
                stmt.setString(3, email);
                stmt.executeUpdate();
            }
        } catch (SQLException e) {
            throw new ServletException("Database error processing staff", e);
        } finally {
            DBUtil.closeQuietly(stmt);
            DBUtil.closeQuietly(conn);
        }

        response.sendRedirect(request.getContextPath() + "/staff-list.jsp");
    }
}