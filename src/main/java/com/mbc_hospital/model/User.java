package com.mbc_hospital.model;

import java.io.Serializable;

public class User implements Serializable {
    private static final long serialVersionUID = 1L; // optional but recommended

    private int userID;
    private String username;
    private String password;
    private String userType; // Admin, Nurse, Patient, Doctor
    private boolean is_verified;
    private String firstName;
    private String lastName;
    private String telephone;
    private String email;
    private String address;
    private String hospitalName;

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

    // Full constructor with all fields
    public User(int userID, String username, String password, String userType, boolean is_verified,
                String firstName, String lastName, String telephone, String email, String address, String hospitalName) {
        this.userID = userID;
        this.username = username;
        this.password = password;
        this.userType = userType;
        this.is_verified = is_verified;
        this.firstName = firstName;
        this.lastName = lastName;
        this.telephone = telephone;
        this.email = email;
        this.address = address;
        this.hospitalName = hospitalName;
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

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getHospitalName() {
        return hospitalName;
    }

    public void setHospitalName(String hospitalName) {
        this.hospitalName = hospitalName;
    }

    @Override
    public String toString() {
        return "User{" +
                "userID=" + userID +
                ", username='" + username + '\'' +
                ", userType='" + userType + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}
