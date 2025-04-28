package com.mbc_hospital.dao;

import java.sql.*;
import java.util.*;

import com.mbc_hospital.model.User;

public class UserDAO {
 private Connection conn;

 public UserDAO(Connection conn) {
     this.conn = conn;
 }

 public List<User> getAllUsers() throws SQLException {
     List<User> users = new ArrayList<>();
     String query = "SELECT * FROM Users";
     try (PreparedStatement stmt = conn.prepareStatement(query);
          ResultSet rs = stmt.executeQuery()) {
         while (rs.next()) {
             User user = new User();
             user.setUserID(rs.getInt("UserID"));
             user.setUsername(rs.getString("Username"));
             user.setPassword(rs.getString("Password"));
             user.setUserType(rs.getString("UserType"));
             users.add(user);
         }
     }
     return users;
 }

 public void deleteUser(int userID) throws SQLException {
     String query = "DELETE FROM Users WHERE UserID = ?";
     try (PreparedStatement stmt = conn.prepareStatement(query)) {
         stmt.setInt(1, userID);
         stmt.executeUpdate();
     }
 }
}
