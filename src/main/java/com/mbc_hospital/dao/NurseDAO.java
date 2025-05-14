package com.mbc_hospital.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Nurse;

public class NurseDAO {

    public static boolean updateStatus(int nurseId, String newStatus) {
        boolean rowUpdated = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("UPDATE Nurses SET Status = ? WHERE NurseId = ?")) {

            stmt.setString(1, newStatus);
            stmt.setInt(2, nurseId);
            rowUpdated = stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }

    public static List<Nurse> getAllNurses() {
        List<Nurse> nurses = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM Nurses");
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Nurse nurse = new Nurse();
                nurse.setNurseId(rs.getInt("NurseId"));
                nurse.setFirstName(rs.getString("FirstName"));
                nurse.setLastName(rs.getString("LastName"));
                nurse.setTelephone(rs.getString("Telephone"));
                nurse.setEmail(rs.getString("Email"));
                nurse.setAddress(rs.getString("Address"));
                nurse.setHealthCenter(rs.getString("HealthCenter"));
                nurse.setRegisteredBy(rs.getString("RegisteredBy"));
                nurse.setStatus(rs.getString("Status"));
                nurses.add(nurse);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return nurses;
    }

    public static Nurse getNurseById(int nurseId) {
        Nurse nurse = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM Nurses WHERE NurseId = ?")) {

            stmt.setInt(1, nurseId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                nurse = new Nurse();
                nurse.setNurseId(rs.getInt("NurseId"));
                nurse.setFirstName(rs.getString("FirstName"));
                nurse.setLastName(rs.getString("LastName"));
                nurse.setTelephone(rs.getString("Telephone"));
                nurse.setEmail(rs.getString("Email"));
                nurse.setAddress(rs.getString("Address"));
                nurse.setHealthCenter(rs.getString("HealthCenter"));
                nurse.setRegisteredBy(rs.getString("RegisteredBy"));
                nurse.setStatus(rs.getString("Status"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return nurse;
    }

    public static boolean deleteNurse(int nurseId) {
        boolean deleted = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM Nurses WHERE NurseId = ?")) {

            stmt.setInt(1, nurseId);
            deleted = stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return deleted;
    }
    public long getTotalNurses() {
        long count = 0;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement("SELECT count(*) FROM Nurses")) { //  adjust
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                count = resultSet.getLong(1);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Handle exceptions
        }
        return count;
    }
}
