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
             user.setVerified(rs.getBoolean("is_verified"));
             
             // Set additional profile fields
             user.setFirstName(rs.getString("FirstName"));
             user.setLastName(rs.getString("LastName"));
             user.setTelephone(rs.getString("Telephone"));
             user.setEmail(rs.getString("Email"));
             user.setAddress(rs.getString("Address"));
             user.setHospitalName(rs.getString("HospitalName"));
             
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
 
 public User getUserById(int userID) throws SQLException {
     String query = "SELECT * FROM Users WHERE UserID = ?";
     try (PreparedStatement stmt = conn.prepareStatement(query)) {
         stmt.setInt(1, userID);
         try (ResultSet rs = stmt.executeQuery()) {
             if (rs.next()) {
                 User user = new User();
                 user.setUserID(rs.getInt("UserID"));
                 user.setUsername(rs.getString("Username"));
                 user.setPassword(rs.getString("Password"));
                 user.setUserType(rs.getString("UserType"));
                 user.setVerified(rs.getBoolean("is_verified"));
                 
                 // Set additional profile fields
                 user.setFirstName(rs.getString("FirstName"));
                 user.setLastName(rs.getString("LastName"));
                 user.setTelephone(rs.getString("Telephone"));
                 user.setEmail(rs.getString("Email"));
                 user.setAddress(rs.getString("Address"));
                 user.setHospitalName(rs.getString("HospitalName"));
                 
                 return user;
             }
         }
     }
     return null;
 }
 
 public User getUserByUsername(String username) throws SQLException {
     String query = "SELECT * FROM Users WHERE Username = ?";
     try (PreparedStatement stmt = conn.prepareStatement(query)) {
         stmt.setString(1, username);
         try (ResultSet rs = stmt.executeQuery()) {
             if (rs.next()) {
                 User user = new User();
                 user.setUserID(rs.getInt("UserID"));
                 user.setUsername(rs.getString("Username"));
                 user.setPassword(rs.getString("Password"));
                 user.setUserType(rs.getString("UserType"));
                 user.setVerified(rs.getBoolean("is_verified"));
                 
                 // Set additional profile fields
                 user.setFirstName(rs.getString("FirstName"));
                 user.setLastName(rs.getString("LastName"));
                 user.setTelephone(rs.getString("Telephone"));
                 user.setEmail(rs.getString("Email"));
                 user.setAddress(rs.getString("Address"));
                 user.setHospitalName(rs.getString("HospitalName"));
                 
                 return user;
             }
         }
     }
     return null;
 }
}
