package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Diagnosis;
import com.mbc_hospital.model.DiagnosisPatientView;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/DiagnosisViewServlet")
public class DiagnosisViewServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Diagnosis> diagnosisList = new ArrayList<>();
        Map<Integer, String> patientNames = new HashMap<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            // First, fetch all diagnoses
            String sql = "SELECT d.*, " +
                         "p.FirstName, p.LastName " + 
                         "FROM Diagnosis d " +
                         "LEFT JOIN Patients p ON d.PatientID = p.PatientID";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int diagnosisId = rs.getInt("DiagnosisID");
                int patientId = rs.getInt("PatientID");
                int nurseId = rs.getInt("NurseID");
                int doctorId = rs.getInt("DoctorID");
                String status = rs.getString("DiagnoStatus");
                String result = rs.getString("Result");
                
                // New fields
                String medicationsPrescribed = rs.getString("MedicationsPrescribed");
                Date followUpDate = rs.getDate("FollowUpDate");
                Timestamp diagnosisDate = rs.getTimestamp("DiagnosisDate");
                String nurseAssessment = rs.getString("NurseAssessment");

                // Create a diagnosis object with all fields
                Diagnosis diagnosis = new Diagnosis(
                    diagnosisId, patientId, nurseId, doctorId, status, result,
                    medicationsPrescribed, followUpDate, diagnosisDate, nurseAssessment
                );
                
                diagnosisList.add(diagnosis);
                
                // Store patient name
                String firstName = rs.getString("FirstName");
                String lastName = rs.getString("LastName");
                if (firstName != null && lastName != null) {
                    patientNames.put(patientId, firstName + " " + lastName);
                } else {
                    patientNames.put(patientId, "Unknown Patient");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("diagnosisList", diagnosisList);
        request.setAttribute("patientNames", patientNames);
        request.getRequestDispatcher("diagnosis_view.jsp").forward(request, response);
    }
}
