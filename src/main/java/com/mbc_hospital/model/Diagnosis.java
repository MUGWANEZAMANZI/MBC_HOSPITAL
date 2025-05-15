package com.mbc_hospital.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Diagnosis {
    private int diagnosisId;
    private int patientId;
    private int nurseId;
    private int doctorId;
    private String status;
    private String result;
    private String medicationsPrescribed;
    private Date followUpDate;
    private Timestamp diagnosisDate;
    private String nurseAssessment;
    private String doctorDiagnosis;
    private String doctorName;

    // Default constructor
    public Diagnosis() {
    }

    // Constructor for existing fields (backwards compatibility)
    public Diagnosis(int diagnosisId, int patientId, int nurseId, int doctorId, String status, String result) {
        this.diagnosisId = diagnosisId;
        this.patientId = patientId;
        this.nurseId = nurseId;
        this.doctorId = doctorId;
        this.status = status;
        this.result = result;
    }

    // Full constructor with all fields
    public Diagnosis(int diagnosisId, int patientId, int nurseId, int doctorId, String status, String result,
                    String medicationsPrescribed, Date followUpDate, Timestamp diagnosisDate, String nurseAssessment) {
        this.diagnosisId = diagnosisId;
        this.patientId = patientId;
        this.nurseId = nurseId;
        this.doctorId = doctorId;
        this.status = status;
        this.result = result;
        this.medicationsPrescribed = medicationsPrescribed;
        this.followUpDate = followUpDate;
        this.diagnosisDate = diagnosisDate;
        this.nurseAssessment = nurseAssessment;
    }
    
    // Full constructor with doctorDiagnosis
    public Diagnosis(int diagnosisId, int patientId, int nurseId, int doctorId, String status, String result,
                    String medicationsPrescribed, Date followUpDate, Timestamp diagnosisDate, 
                    String nurseAssessment, String doctorDiagnosis) {
        this.diagnosisId = diagnosisId;
        this.patientId = patientId;
        this.nurseId = nurseId;
        this.doctorId = doctorId;
        this.status = status;
        this.result = result;
        this.medicationsPrescribed = medicationsPrescribed;
        this.followUpDate = followUpDate;
        this.diagnosisDate = diagnosisDate;
        this.nurseAssessment = nurseAssessment;
        this.doctorDiagnosis = doctorDiagnosis;
    }

    public int getDiagnosisId() {
        return diagnosisId;
    }
    
    public void setDiagnosisId(int diagnosisId) {
        this.diagnosisId = diagnosisId;
    }

    public int getPatientId() {
        return patientId;
    }
    
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getNurseId() {
        return nurseId;
    }
    
    public void setNurseId(int nurseId) {
        this.nurseId = nurseId;
    }

    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }

    public String getResult() {
        return result;
    }
    
    public void setResult(String result) {
        this.result = result;
    }
    
    public String getMedicationsPrescribed() {
        return medicationsPrescribed;
    }
    
    public void setMedicationsPrescribed(String medicationsPrescribed) {
        this.medicationsPrescribed = medicationsPrescribed;
    }
    
    public Date getFollowUpDate() {
        return followUpDate;
    }
    
    public void setFollowUpDate(Date followUpDate) {
        this.followUpDate = followUpDate;
    }
    
    public Timestamp getDiagnosisDate() {
        return diagnosisDate;
    }
    
    public void setDiagnosisDate(Timestamp diagnosisDate) {
        this.diagnosisDate = diagnosisDate;
    }
    
    public String getNurseAssessment() {
        return nurseAssessment;
    }
    
    public void setNurseAssessment(String nurseAssessment) {
        this.nurseAssessment = nurseAssessment;
    }
    
    public String getDoctorDiagnosis() {
        return doctorDiagnosis;
    }
    
    public void setDoctorDiagnosis(String doctorDiagnosis) {
        this.doctorDiagnosis = doctorDiagnosis;
    }
    
    public String getDoctorName() {
        return doctorName;
    }
    
    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
}
