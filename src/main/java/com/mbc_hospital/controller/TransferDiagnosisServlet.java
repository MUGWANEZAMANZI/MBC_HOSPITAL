package com.mbc_hospital.controller;

import com.mbc_hospital.dao.DiagnosisDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/TransferDiagnosisServlet")
public class TransferDiagnosisServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int diagnosisId = Integer.parseInt(request.getParameter("diagnosisId"));
        
        DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
        boolean success = diagnosisDAO.transferDiagnosis(diagnosisId); // implement this method in DAO

        if (success) {
            request.getSession().setAttribute("message", "Case Transferred Successfully.");
        } else {
            request.getSession().setAttribute("error", "Failed to transfer case.");
        }
        response.sendRedirect("diagnosis_view.jsp");
    }
}
