package com.mbc_hospital.model;

import java.io.Serializable;

public class User implements Serializable {
    private static final long serialVersionUID = 1L; // optional but recommended

    private int userID;
    private String username;
    private String password;
    private String userType; // Admin, Nurse, Patient, Doctor
    private boolean is_verified;

    public User() {
    }

    public boolean isVerified() {
        return is_verified;
    }

    public void setVerified(boolean is_verified) {
        this.is_verified = is_verified;
    }

    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public User(int userID, String username, String password, String userType) {
        this.userID = userID;
        this.username = username;
        this.password = password;
        this.userType = userType;
    }

    public User(String username, String password, String userType) {
        this.username = username;
        this.password = password;
        this.userType = userType;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    @Override
    public String toString() {
        return "User{" +
                "userID=" + userID +
                ", username='" + username + '\'' +
                ", userType='" + userType + '\'' +
                '}';
    }
}
