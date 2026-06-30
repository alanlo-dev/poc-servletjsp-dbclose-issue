package com.staffattendance.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RecordsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward filter parameters if any
        String filterStaff = request.getParameter("staffId");
        String filterDate = request.getParameter("date");
        if (filterStaff != null && !filterStaff.isEmpty()) {
            request.setAttribute("filterStaffId", filterStaff);
        }
        if (filterDate != null && !filterDate.isEmpty()) {
            request.setAttribute("filterDate", filterDate);
        }
        request.getRequestDispatcher("/records.jsp").forward(request, response);
    }
}