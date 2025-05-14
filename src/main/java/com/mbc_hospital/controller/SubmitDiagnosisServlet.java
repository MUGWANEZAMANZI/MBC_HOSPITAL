package com.mbc_hospital.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.mbc_hospital.model.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/submitDiagnosis")
public class SubmitDiagnosisServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Read form parameters
        String patientID = request.getParameter("patientID");
        String diagnosisStatus = request.getParameter("diagnosisStatus");
        String result = request.getParameter("result");
        String nurseIDStr = request.getParameter("nurseID");

        // Print debug statements
        System.out.println("Received parameters:");
        System.out.println("patientID: " + patientID);
        System.out.println("diagnosisStatus: " + diagnosisStatus);
        System.out.println("result: " + result);
        System.out.println("nurseID (raw): " + nurseIDStr);
        int nurseID = 0;

        try {
            nurseID = Integer.parseInt(nurseIDStr);
            System.out.println("nurseID (parsed): " + nurseID);
        } catch (NumberFormatException e) {
            System.err.println("Invalid nurseID value: " + nurseIDStr);
            e.printStackTrace();
        }

        // Assume doctor hasn't been assigned yet
        Integer doctorID = null;
        
        // Set result based on diagnosis status as per requirements
        if ("Referrable".equals(diagnosisStatus)) {
            // If the diagnosis is referrable, the result should be "Pending" until a doctor reviews it
            result = "Pending";
        } else if ("Not Referable".equals(diagnosisStatus)) {
            // If the diagnosis is not referrable, the result should be "Negative"
            result = "Negative";
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection(); // Your custom DB connection method
            String sql = "INSERT INTO Diagnosis (PatientID, NurseID, DoctorID, DiagnoStatus, Result) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);

            stmt.setInt(1, Integer.parseInt(patientID));
            stmt.setInt(2, nurseID); // assumes nurseID is stored in session
            if (doctorID != null) {
                stmt.setInt(3, doctorID);
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }
            stmt.setString(4, diagnosisStatus);
            stmt.setString(5, result);

            int rows = stmt.executeUpdate();

            response.setContentType("text/plain");
            if (rows > 0) {
                response.getWriter().write("Diagnosis submitted successfully.");
            } else {
                response.getWriter().write("Failed to submit diagnosis.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Error: " + e.getMessage());
        } finally {
            try { if (stmt != null) stmt.close(); } catch (Exception e) { }
            try { if (conn != null) conn.close(); } catch (Exception e) { }
        }
    }
}
