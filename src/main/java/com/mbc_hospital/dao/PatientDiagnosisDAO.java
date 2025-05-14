package com.mbc_hospital.dao;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Patient;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDiagnosisDAO {
    public List<Patient> getAllPatientDiagnoses() throws SQLException {
        System.out.println("DAO method called..."); // Confirm call
        List<Patient> list = new ArrayList<>();

        String sql = "SELECT p.*, u.Username AS registeredByName, " +
                "d.DiagnosisID, d.NurseID, d.DoctorID, " +
                "IFNULL(d.DiagnoStatus, 'Action Required') AS DiagnoStatus, " +
                "d.Result " +
                "FROM Patients p " +
                "LEFT JOIN Users u ON p.RegisteredBy = u.UserID " +
                "LEFT JOIN Diagnosis d ON p.PatientID = d.PatientID";

        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
        	
        	boolean foundData = false;
            while (rs.next()) {
                Patient p = new Patient();
                foundData = true;
                System.out.println("Row found: " + rs.getString("DiagnoStatus")); // or any column that always has value

                p.setPatientID(rs.getInt("PatientID"));
                p.setFirstName(rs.getString("FirstName"));
                p.setLastName(rs.getString("LastName"));
                p.setTelephone(rs.getString("Telephone"));
                p.setEmail(rs.getString("Email"));
                p.setAddress(rs.getString("Address"));
                p.setImageLink(rs.getString("PImageLink"));
                p.setRegisteredBy(rs.getInt("RegisteredBy"));
                p.setRegisteredByName(rs.getString("registeredByName"));
                p.setDiagnosisID(rs.getInt("DiagnosisID"));
                p.setDiagnosisStatus(rs.getString("DiagnoStatus"));
                p.setDiagnosisResult(rs.getString("Result"));

                list.add(p);
            }
            if (!foundData) {
                System.out.println("No rows returned by the query.");
            }
        }
        

        return list;
    }

    public List<Patient> getCompletedDiagnoses() throws SQLException {
        List<Patient> list = new ArrayList<>();

        String sql = "SELECT p.*, u.Username AS registeredByName, " +
                "d.DiagnosisID, d.NurseID, d.DoctorID, " +
                "d.DiagnoStatus, d.Result, d.MedicationsPrescribed, d.FollowUpDate, d.NurseAssessment " +
                "FROM Patients p " +
                "JOIN Diagnosis d ON p.PatientID = d.PatientID " +
                "LEFT JOIN Users u ON p.RegisteredBy = u.UserID " +
                "WHERE d.DiagnoStatus IN ('Positive', 'Negative') " + 
                "AND d.DoctorID IS NOT NULL";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Patient p = new Patient();
                
                p.setPatientID(rs.getInt("PatientID"));
                p.setFirstName(rs.getString("FirstName"));
                p.setLastName(rs.getString("LastName"));
                p.setTelephone(rs.getString("Telephone"));
                p.setEmail(rs.getString("Email"));
                p.setAddress(rs.getString("Address"));
                p.setImageLink(rs.getString("PImageLink"));
                p.setRegisteredBy(rs.getInt("RegisteredBy"));
                p.setRegisteredByName(rs.getString("registeredByName"));
                p.setDiagnosisID(rs.getInt("DiagnosisID"));
                p.setDiagnosisStatus(rs.getString("DiagnoStatus"));
                p.setDiagnosisResult(rs.getString("Result"));
                p.setMedicationsPrescribed(rs.getString("MedicationsPrescribed"));
                p.setFollowUpDate(rs.getString("FollowUpDate"));
                p.setNurseAssessment(rs.getString("NurseAssessment"));

                list.add(p);
            }
        }

        return list;
    }
}
