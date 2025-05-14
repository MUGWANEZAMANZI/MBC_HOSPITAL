package com.mbc_hospital.controller;

import com.mbc_hospital.dao.PatientDiagnosisDAO;
import com.mbc_hospital.model.Patient;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/nurse-view-diagnoses")
public class NurseViewDiagnosesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("id") == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            PatientDiagnosisDAO dao = new PatientDiagnosisDAO();
            
            // Check if a specific diagnosis ID is requested
            String diagnosisIdParam = request.getParameter("id");
            if (diagnosisIdParam != null && !diagnosisIdParam.isEmpty()) {
                try {
                    int diagnosisId = Integer.parseInt(diagnosisIdParam);
                    Patient diagnosisDetails = dao.getDiagnosisById(diagnosisId);
                    if (diagnosisDetails != null) {
                        request.setAttribute("diagnosisDetails", diagnosisDetails);
                        RequestDispatcher dispatcher = request.getRequestDispatcher("/diagnosis_details.jsp");
                        dispatcher.forward(request, response);
                        return;
                    }
                } catch (NumberFormatException e) {
                    // Invalid ID format, continue to show all diagnoses
                }
            }
            
            // Default: show all completed diagnoses
            List<Patient> completedDiagnoses = dao.getCompletedDiagnoses();
            request.setAttribute("completedDiagnoses", completedDiagnoses);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/nurse_view_diagnoses.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Database error while fetching completed diagnoses", e);
        }
    }
} 