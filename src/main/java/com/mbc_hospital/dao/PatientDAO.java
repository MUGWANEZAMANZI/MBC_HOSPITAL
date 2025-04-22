package com.mbc_hospital.dao;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Patient;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class PatientDAO {

    // Fetch patient profile by ID
    public static Patient getPatientById(int patientId) {
        Patient patient = null;
        String query = "SELECT * FROM Patients WHERE PatientID = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            preparedStatement.setInt(1, patientId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                patient = new Patient();
                patient.setPatientID(resultSet.getInt("PatientID"));
                patient.setFirstName(resultSet.getString("FirstName"));
                patient.setLastName(resultSet.getString("LastName"));
                patient.setTelephone(resultSet.getString("Telephone"));
                patient.setEmail(resultSet.getString("Email"));
                patient.setAddress(resultSet.getString("Address"));
                patient.setPImageLink(resultSet.getString("PImageLink"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return patient;
    }

    // Fetch case information by patient ID
  public static Map<String, Object> getCaseByPatientId(int patientId) {
    Map<String, Object> caseInfo = new HashMap<>();
    String query = "SELECT DiagnoStatus, Result, RegisteredBy FROM Diagnosis WHERE PatientID = ?";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement preparedStatement = connection.prepareStatement(query)) {

        preparedStatement.setInt(1, patientId);
        ResultSet resultSet = preparedStatement.executeQuery();

        if (resultSet.next()) {
            caseInfo.put("status", resultSet.getString("DiagnoStatus"));
            caseInfo.put("result", resultSet.getString("Result"));
            caseInfo.put("registeredBy", resultSet.getInt("RegisteredBy"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return caseInfo;
}

    
}

