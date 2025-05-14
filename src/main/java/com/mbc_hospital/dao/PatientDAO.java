package com.mbc_hospital.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Patient;

public class PatientDAO {

    public long getTotalPatients() {
        long count = 0;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("SELECT count(*) FROM Patients")) {
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getLong(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("SELECT PatientId, FirstName, LastName, Telephone, Email, Address, PImageLink, RegisteredBy FROM Patients");
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                Patient patient = new Patient();
                patient.setPatientID(resultSet.getInt("PatientId"));
                patient.setFirstName(resultSet.getString("FirstName"));
                patient.setLastName(resultSet.getString("LastName"));
                patient.setTelephone(resultSet.getString("Telephone"));
                patient.setEmail(resultSet.getString("Email"));
                patient.setAddress(resultSet.getString("Address"));
                patient.setImageLink(resultSet.getString("PImageLink"));
                patient.setRegisteredBy(resultSet.getInt("RegisteredBy"));
                patients.add(patient);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }
    
    public String getPatientNameById(int patientId) {
        String patientName = "Unknown";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("SELECT FirstName, LastName FROM Patients WHERE PatientId = ?")) {
            
            preparedStatement.setInt(1, patientId);
            ResultSet resultSet = preparedStatement.executeQuery();
            
            if (resultSet.next()) {
                String firstName = resultSet.getString("FirstName");
                String lastName = resultSet.getString("LastName");
                patientName = firstName + " " + lastName;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patientName;
    }
}

