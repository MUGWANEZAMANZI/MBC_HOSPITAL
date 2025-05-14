package com.mbc_hospital.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Diagnosis;

public class DiagnosisDAO{
public boolean transferDiagnosis(int diagnosisId) {
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("UPDATE Diagnosis SET DiagnoStatus = 'Referred' WHERE DiagnosisID = ?")) {
        ps.setInt(1, diagnosisId);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

public boolean solveDiagnosis(int diagnosisId) {
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("UPDATE Diagnosis SET Result = 'Confirmed' WHERE DiagnosisID = ?")) {
        ps.setInt(1, diagnosisId);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}

public List<Diagnosis> getConfirmedDiagnoses() throws SQLException {
    List<Diagnosis> confirmedDiagnoses = new ArrayList<>();
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT * FROM Diagnosis WHERE Result = 'Confirmed'")) {
        
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Diagnosis diagnosis = new Diagnosis(
                rs.getInt("DiagnosisID"),
                rs.getInt("PatientID"),
                rs.getInt("NurseID"),
                rs.getInt("DoctorID"),
                rs.getString("DiagnoStatus"),
                rs.getString("Result"),
                rs.getString("MedicationsPrescribed"),
                rs.getDate("FollowUpDate"),
                rs.getTimestamp("DiagnosisDate"),
                rs.getString("NurseAssessment")
            );
            
            confirmedDiagnoses.add(diagnosis);
        }
    }
    
    return confirmedDiagnoses;
}

public List<Diagnosis> getDiagnosesByStatus() throws SQLException {
    List<Diagnosis> diagnosisList = new ArrayList<>();
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT * FROM Diagnosis WHERE DiagnoStatus IN ('Positive', 'Negative')")) {
        
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Diagnosis diagnosis = new Diagnosis(
                rs.getInt("DiagnosisID"),
                rs.getInt("PatientID"),
                rs.getInt("NurseID"),
                rs.getInt("DoctorID"),
                rs.getString("DiagnoStatus"),
                rs.getString("Result"),
                rs.getString("MedicationsPrescribed"),
                rs.getDate("FollowUpDate"),
                rs.getTimestamp("DiagnosisDate"),
                rs.getString("NurseAssessment")
            );
            
            diagnosisList.add(diagnosis);
        }
    }
    
    return diagnosisList;
}

public List<Diagnosis> getReferrableDiagnoses() throws SQLException {
    List<Diagnosis> referrableDiagnoses = new ArrayList<>();
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT * FROM Diagnosis WHERE DiagnoStatus = 'Referrable'")) {
        
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Diagnosis diagnosis = new Diagnosis(
                rs.getInt("DiagnosisID"),
                rs.getInt("PatientID"),
                rs.getInt("NurseID"),
                rs.getInt("DoctorID"),
                rs.getString("DiagnoStatus"),
                rs.getString("Result"),
                rs.getString("MedicationsPrescribed"),
                rs.getDate("FollowUpDate"),
                rs.getTimestamp("DiagnosisDate"),
                rs.getString("NurseAssessment")
            );
            
            referrableDiagnoses.add(diagnosis);
        }
    }
    
    return referrableDiagnoses;
}

public Diagnosis getDiagnosisById(int diagnosisId) throws SQLException {
    Diagnosis diagnosis = null;
    
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT * FROM Diagnosis WHERE DiagnosisID = ?")) {
        
        ps.setInt(1, diagnosisId);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            diagnosis = new Diagnosis(
                rs.getInt("DiagnosisID"),
                rs.getInt("PatientID"),
                rs.getInt("NurseID"),
                rs.getInt("DoctorID"),
                rs.getString("DiagnoStatus"),
                rs.getString("Result"),
                rs.getString("MedicationsPrescribed"),
                rs.getDate("FollowUpDate"),
                rs.getTimestamp("DiagnosisDate"),
                rs.getString("NurseAssessment")
            );
        }
    }
    
    return diagnosis;
}
}
