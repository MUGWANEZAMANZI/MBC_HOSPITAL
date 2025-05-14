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

import com.mbc_hospital.model.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/nurse-referred-cases")
public class NurseReferredCasesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> referredCases = new ArrayList<>();
        
        try {
            Connection conn = DBConnection.getConnection();
            
            // Simplified query to get all referrable cases
            String sql = "SELECT d.DiagnosisID, d.PatientID, d.NurseID, d.DoctorID, " +
                         "d.DiagnoStatus, d.Result, IFNULL(d.NurseAssessment, 'No assessment provided') as NurseAssessment, " +
                         "DATE_FORMAT(d.DiagnosisDate, '%Y-%m-%d') as FormattedDate, " +
                         "CONCAT(p.FirstName, ' ', p.LastName) as PatientName " +
                         "FROM Diagnosis d " +
                         "JOIN Patients p ON d.PatientID = p.PatientID " +
                         "WHERE d.DiagnoStatus = 'Referrable'";
            
            System.out.println("Executing SQL query: " + sql);
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            System.out.println("Query executed, processing results...");
            
            while (rs.next()) {
                Map<String, Object> caseInfo = new HashMap<>();
                
                int diagnosisId = rs.getInt("DiagnosisID");
                String patientName = rs.getString("PatientName");
                
                caseInfo.put("diagnosisId", diagnosisId);
                caseInfo.put("patientId", rs.getInt("PatientID"));
                caseInfo.put("patientName", patientName);
                caseInfo.put("diagnosisDate", rs.getString("FormattedDate"));
                caseInfo.put("nurseAssessment", rs.getString("NurseAssessment"));
                
                System.out.println("Found referred case - ID: " + diagnosisId + ", Patient: " + patientName);
                
                // Determine status based on fields
                if (rs.getObject("DoctorID") == null) {
                    caseInfo.put("status", "Awaiting Doctor");
                } else if (rs.getString("Result") == null || rs.getString("Result").isEmpty() || "Pending".equals(rs.getString("Result"))) {
                    caseInfo.put("status", "In Progress");
                } else {
                    caseInfo.put("status", "Completed");
                }
                
                referredCases.add(caseInfo);
            }
            
            System.out.println("Total referrable cases found: " + referredCases.size());
            
            rs.close();
            ps.close();
            conn.close();
            
        } catch (SQLException e) {
            System.err.println("Database error in NurseReferredCasesServlet: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("General error in NurseReferredCasesServlet: " + e.getMessage());
            e.printStackTrace();
        }
        
        request.setAttribute("referredCases", referredCases);
        request.getRequestDispatcher("nurse_referred_cases.jsp").forward(request, response);
    }
} 