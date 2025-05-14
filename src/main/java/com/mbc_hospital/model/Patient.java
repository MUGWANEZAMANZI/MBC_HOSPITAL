package com.mbc_hospital.model;

public class Patient {
	private String registeredByName;

	public String getRegisteredByName() {
	    return registeredByName;
	}

	public void setRegisteredByName(String registeredByName) {
	    this.registeredByName = registeredByName;
	}
    private int patientID;
    private String firstName;
    private String lastName;
    private String telephone;
    private String email;
    private String address;
    private String imageLink;
    private int registeredBy;
    private String registrationDate;
    
    // Diagnosis-related fields
    private int diagnosisID;
    private String diagnosisStatus;
    private String diagnosisResult;
    private String medicationsPrescribed;
    private String followUpDate;
    private String nurseAssessment;
    private String diagnosisDate;
    private String nurseName;

    // Constructors, getters, and setters
    public Patient() {
    }

    // Getters and setters for basic patient information
    public int getPatientID() {
        return patientID;
    }

    public void setPatientID(int patientID) {
        this.patientID = patientID;
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

    public String getImageLink() {
        return imageLink;
    }

    public void setImageLink(String imageLink) {
        this.imageLink = imageLink;
    }

    public int getRegisteredBy() {
        return registeredBy;
    }

    public void setRegisteredBy(int registeredBy) {
        this.registeredBy = registeredBy;
    }
    
    public String getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(String registrationDate) {
        this.registrationDate = registrationDate;
    }

    // Getters and setters for diagnosis-related fields
    public int getDiagnosisID() {
        return diagnosisID;
    }

    public void setDiagnosisID(int diagnosisID) {
        this.diagnosisID = diagnosisID;
    }

    public String getDiagnosisStatus() {
        return diagnosisStatus;
    }

    public void setDiagnosisStatus(String diagnosisStatus) {
        this.diagnosisStatus = diagnosisStatus;
    }

    public String getDiagnosisResult() {
        return diagnosisResult;
    }

    public void setDiagnosisResult(String diagnosisResult) {
        this.diagnosisResult = diagnosisResult;
    }

    public String getMedicationsPrescribed() {
        return medicationsPrescribed;
    }

    public void setMedicationsPrescribed(String medicationsPrescribed) {
        this.medicationsPrescribed = medicationsPrescribed;
    }

    public String getFollowUpDate() {
        return followUpDate;
    }

    public void setFollowUpDate(String followUpDate) {
        this.followUpDate = followUpDate;
    }

    public String getNurseAssessment() {
        return nurseAssessment;
    }

    public void setNurseAssessment(String nurseAssessment) {
        this.nurseAssessment = nurseAssessment;
    }
    
    public String getDiagnosisDate() {
        return diagnosisDate;
    }

    public void setDiagnosisDate(String diagnosisDate) {
        this.diagnosisDate = diagnosisDate;
    }
    
    public String getNurseName() {
        return nurseName;
    }

    public void setNurseName(String nurseName) {
        this.nurseName = nurseName;
    }
}
