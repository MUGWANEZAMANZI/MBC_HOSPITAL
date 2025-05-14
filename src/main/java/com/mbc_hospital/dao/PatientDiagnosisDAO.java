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
    
    public List<Patient> getNurseCompletedCases() throws SQLException {
        List<Patient> list = new ArrayList<>();

        String sql = "SELECT p.*, u.Username AS registeredByName, " +
                "n.Username AS nurseName, " +
                "d.DiagnosisID, d.NurseID, d.DoctorID, " +
                "d.DiagnoStatus, d.Result, d.MedicationsPrescribed, d.FollowUpDate, d.NurseAssessment, " +
                "d.DiagnosisDate " +
                "FROM Patients p " +
                "JOIN Diagnosis d ON p.PatientID = d.PatientID " +
                "LEFT JOIN Users u ON p.RegisteredBy = u.UserID " +
                "LEFT JOIN Users n ON d.NurseID = n.UserID " +
                "WHERE d.DiagnoStatus IN ('Positive', 'Negative') " + 
                "AND (d.DoctorID IS NULL OR d.DoctorID = 0) " +
                "ORDER BY d.DiagnosisDate DESC";

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
                p.setDiagnosisDate(rs.getTimestamp("DiagnosisDate") != null ? 
                    rs.getTimestamp("DiagnosisDate").toString() : null);
                p.setNurseName(rs.getString("nurseName"));

                list.add(p);
            }
        }

        return list;
    }

    public Patient getDiagnosisById(int diagnosisId) throws SQLException {
        Patient patient = null;
        
        String sql = "SELECT p.*, u.Username AS registeredByName, " +
                "d.DiagnosisID, d.NurseID, d.DoctorID, " +
                "d.DiagnoStatus, d.Result, d.MedicationsPrescribed, d.FollowUpDate, d.NurseAssessment " +
                "FROM Patients p " +
                "JOIN Diagnosis d ON p.PatientID = d.PatientID " +
                "LEFT JOIN Users u ON p.RegisteredBy = u.UserID " +
                "WHERE d.DiagnosisID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, diagnosisId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    patient = new Patient();
                    
                    patient.setPatientID(rs.getInt("PatientID"));
                    patient.setFirstName(rs.getString("FirstName"));
                    patient.setLastName(rs.getString("LastName"));
                    patient.setTelephone(rs.getString("Telephone"));
                    patient.setEmail(rs.getString("Email"));
                    patient.setAddress(rs.getString("Address"));
                    patient.setImageLink(rs.getString("PImageLink"));
                    patient.setRegisteredBy(rs.getInt("RegisteredBy"));
                    patient.setRegisteredByName(rs.getString("registeredByName"));
                    patient.setDiagnosisID(rs.getInt("DiagnosisID"));
                    patient.setDiagnosisStatus(rs.getString("DiagnoStatus"));
                    patient.setDiagnosisResult(rs.getString("Result"));
                    patient.setMedicationsPrescribed(rs.getString("MedicationsPrescribed"));
                    patient.setFollowUpDate(rs.getString("FollowUpDate"));
                    patient.setNurseAssessment(rs.getString("NurseAssessment"));
                }
            }
        }
        
        return patient;
    }
}
