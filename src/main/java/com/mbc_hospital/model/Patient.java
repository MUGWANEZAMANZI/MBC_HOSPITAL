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
    private String pImageLink;
    private int registeredBy;
    private int diagnosisId;
    private String diagnoStatus;
    private String result;

    // Getters and Setters
    public int getPatientID() { return patientID; }
    public void setPatientID(int patientID) { this.patientID = patientID; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPImageLink() { return pImageLink; }
    public void setPImageLink(String pImageLink) { this.pImageLink = pImageLink; }

    public int getRegisteredBy() { return registeredBy; }
    public void setRegisteredBy(int registeredBy) { this.registeredBy = registeredBy; }
    
    public int getDiagnosisId() {
        return diagnosisId;
    }

    public void setDiagnosisId(int diagnosisId) {
        this.diagnosisId = diagnosisId;
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
