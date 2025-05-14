package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.mbc_hospital.dao.PatientDiagnosisDAO;
import com.mbc_hospital.model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/nurse-completed-cases")
public class NurseCompletedCasesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("NurseCompletedCasesServlet: doGet method called");
        
        // Validate user session
        HttpSession session = request.getSession(false);
        String userType = session != null ? (String) session.getAttribute("usertype") : null;
        
        if (userType == null || !"nurse".equalsIgnoreCase(userType)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            PatientDiagnosisDAO dao = new PatientDiagnosisDAO();
            List<Patient> nurseCompletedCases = dao.getNurseCompletedCases();
            
            System.out.println("Found " + nurseCompletedCases.size() + " nurse-completed cases");
            
            request.setAttribute("nurseCompletedCases", nurseCompletedCases);
            request.getRequestDispatcher("/nurse_completed_cases.jsp").forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("Database error in NurseCompletedCasesServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/nurse.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("General error in NurseCompletedCasesServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Unexpected error: " + e.getMessage());
            request.getRequestDispatcher("/nurse.jsp").forward(request, response);
        }
    }
} 