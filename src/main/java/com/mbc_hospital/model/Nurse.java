package com.mbc_hospital.model;

public class Nurse {
    private Integer nurseId;
    private String firstName;
    private String lastName;
    private String telephone;
    private String email;
    private String address;
    private String healthCenter;
    private Integer registeredBy;

    // Getters and Setters
    public Integer getNurseId() {
        return nurseId;
    }

    public void setNurseId(Integer nurseId) {
        this.nurseId = nurseId;
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

    public String getHealthCenter() {
        return healthCenter;
    }

    public void setHealthCenter(String healthCenter) {
        this.healthCenter = healthCenter;
    }

    public Integer getRegisteredBy() {
        return registeredBy;
    }

    public void setRegisteredBy(Integer registeredBy) {
        this.registeredBy = registeredBy;
    }
}
