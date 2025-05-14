package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.mbc_hospital.dao.DiagnosisDAO;
import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Diagnosis;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/referrable-cases")
public class ReferrableCasesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Diagnosis> referrableDiagnoses = new ArrayList<>();
        Map<Integer, String> patientNames = new HashMap<>();
        
        try {
            DiagnosisDAO diagnosisDAO = new DiagnosisDAO();
            referrableDiagnoses = diagnosisDAO.getReferrableDiagnoses();
            
            // Get patient names for each diagnosis
            try (Connection conn = DBConnection.getConnection()) {
                for (Diagnosis diagnosis : referrableDiagnoses) {
                    int patientId = diagnosis.getPatientId();
                    
                    PreparedStatement ps = conn.prepareStatement("SELECT FirstName, LastName FROM Patients WHERE PatientID = ?");
                    ps.setInt(1, patientId);
                    ResultSet rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        String firstName = rs.getString("FirstName");
                        String lastName = rs.getString("LastName");
                        patientNames.put(patientId, firstName + " " + lastName);
                    } else {
                        patientNames.put(patientId, "Unknown Patient");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to retrieve referrable cases: " + e.getMessage());
        }
        
        request.setAttribute("referrableDiagnoses", referrableDiagnoses);
        request.setAttribute("patientNames", patientNames);
        request.getRequestDispatcher("pending.jsp").forward(request, response);
    }
} 