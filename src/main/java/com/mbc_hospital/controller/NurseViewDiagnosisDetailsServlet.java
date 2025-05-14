package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import com.mbc_hospital.dao.DiagnosisDAO;
import com.mbc_hospital.dao.PatientDAO;
import com.mbc_hospital.model.Diagnosis;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/nurse-view-diagnosis")
public class NurseViewDiagnosisDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        
        // Validate user session
        HttpSession session = request.getSession(false);
        String usertype = session != null ? (String) session.getAttribute("usertype") : null;
        
        if (usertype == null || !"nurse".equalsIgnoreCase(usertype)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("error", "Diagnosis ID is required");
            request.getRequestDispatcher("/nurse-referred-cases").forward(request, response);
            return;
        }
        
        try {
            int diagnosisId = Integer.parseInt(idParam);
            
            // Get diagnosis details
            DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
            Diagnosis diagnosis = diagnosisDAO.getDiagnosisById(diagnosisId);
            
            if (diagnosis == null) {
                request.setAttribute("error", "Diagnosis not found with ID: " + diagnosisId);
                request.getRequestDispatcher("/nurse-referred-cases").forward(request, response);
                return;
            }
            
            // Get patient information
            PatientDAO patientDAO = new PatientDAO();
            String patientName = patientDAO.getPatientNameById(diagnosis.getPatientId());
            
            // Store patient info in a map
            Map<String, Object> patientInfo = new HashMap<>();
            patientInfo.put("patientName", patientName);
            
            // Set attributes for the view
            request.setAttribute("diagnosis", diagnosis);
            request.setAttribute("patientInfo", patientInfo);
            
            // Forward to the nurse-specific diagnosis view
            request.getRequestDispatcher("/nurse_diagnosis_details.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid diagnosis ID format");
            request.getRequestDispatcher("/nurse-referred-cases").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/nurse-referred-cases").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
} 