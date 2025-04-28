package com.mbc_hospital.model;

public class DoctorCase {
    private int doctorID;
    private String firstName;
    private String lastName;
    private String hospitalName;
    private int diagnosisID;
    private String diagnoStatus;
    private String result;

    // Getters and Setters
    public int getDoctorID() {
        return doctorID;
    }

    public void setDoctorID(int doctorID) {
        this.doctorID = doctorID;
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

    public String getHospitalName() {
        return hospitalName;
    }

    public void setHospitalName(String hospitalName) {
        this.hospitalName = hospitalName;
    }

    public int getDiagnosisID() {
        return diagnosisID;
    }

    public void setDiagnosisID(int diagnosisID) {
        this.diagnosisID = diagnosisID;
    }

    public String getDiagnoStatus() {
        return diagnoStatus;
    }

    public void setDiagnoStatus(String diagnoStatus) {
        this.diagnoStatus = diagnoStatus;
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }
}
