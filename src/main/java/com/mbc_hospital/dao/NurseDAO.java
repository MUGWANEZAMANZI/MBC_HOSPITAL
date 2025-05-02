package com.mbc_hospital.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.mbc_hospital.model.DBConnection;

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
}
