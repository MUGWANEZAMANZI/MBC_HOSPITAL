package com.mbc_hospital.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;


import com.mbc_hospital.model.DBConnection;

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
}
