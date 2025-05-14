package com.mbc_hospital.controller;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Patient;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/doctorCases")
public class DoctorCaseController extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Patient> patients = new ArrayList<>();
        
        try {
            Connection conn = DBConnection.getConnection();
            String query = "SELECT p.*, u.Username AS RegisteredByName " +
                          "FROM Patients p " +
                          "LEFT JOIN Users u ON p.RegisteredBy = u.UserID " +
                          "LEFT JOIN Diagnosis d ON p.PatientID = d.PatientID " +
                          "WHERE d.DiagnoStatus = 'Referrable' " +
                          "ORDER BY p.PatientID DESC";
            
            PreparedStatement pstmt = conn.prepareStatement(query);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientID(rs.getInt("PatientID"));
                patient.setFirstName(rs.getString("FirstName"));
                patient.setLastName(rs.getString("LastName"));
                patient.setTelephone(rs.getString("Telephone"));
                patient.setEmail(rs.getString("Email"));
                patient.setAddress(rs.getString("Address"));
                patient.setImageLink(rs.getString("PImageLink"));
                patient.setRegisteredBy(rs.getInt("RegisteredBy"));
                patient.setRegisteredByName(rs.getString("RegisteredByName"));
                
                patients.add(patient);
            }
            
            rs.close();
            pstmt.close();
            conn.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("doctorCases.jsp").forward(request, response);
    }
}
