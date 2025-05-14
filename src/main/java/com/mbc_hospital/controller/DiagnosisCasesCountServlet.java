package com.mbc_hospital.controller;

import com.mbc_hospital.dao.DiagnosisDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/diagnosis-cases-count")
public class DiagnosisCasesCountServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        int count = 0;
        
        try {
            DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
            
            if ("confirmed".equals(type)) {
                count = diagnosisDAO.getDiagnosesByStatus().size();
            } else if ("referrable".equals(type)) {
                count = diagnosisDAO.getReferrableDiagnoses().size();
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error: " + e.getMessage());
            return;
        }
        
        response.setContentType("text/plain");
        response.getWriter().write(String.valueOf(count));
    }
} 