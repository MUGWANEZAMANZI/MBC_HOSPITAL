package com.mbc_hospital.controller;

import com.mbc_hospital.dao.DiagnosisDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/SolveDiagnosisServlet")
public class SolveDiagnosisServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int diagnosisId = Integer.parseInt(request.getParameter("diagnosisId"));
        
        DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
        boolean success = diagnosisDAO.solveDiagnosis(diagnosisId); // implement this method in DAO

        if (success) {
            request.getSession().setAttribute("message", "Case Solved Successfully.");
        } else {
            request.getSession().setAttribute("error", "Failed to solve case.");
        }
        //response.sendRedirect("diagnosis_view.jsp");
        response.sendRedirect("DiagnosisViewServlet");
    }
}
