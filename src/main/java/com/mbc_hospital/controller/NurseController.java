 package com.mbc_hospital.controller;

import com.mbc_hospital.dao.NurseDAO;
import com.mbc_hospital.model.Nurse;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/nurse-dashboard")
public class NurseController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Nurse> nurses = NurseDAO.getAllNurses();
        request.setAttribute("nurses", nurses);
        RequestDispatcher dispatcher = request.getRequestDispatcher("nurseDashboard.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int nurseId = Integer.parseInt(request.getParameter("nurseId"));
        String newStatus = request.getParameter("status");

        NurseDAO.updateStatus(nurseId, newStatus);
        response.sendRedirect("nurse-dashboard");
    }
}
