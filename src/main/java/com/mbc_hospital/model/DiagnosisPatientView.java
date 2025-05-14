package com.mbc_hospital.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Model class to represent diagnosis data joined with patient information
 */
public class DiagnosisPatientView {
    private int diagnosisId;
    private int patientId;
    private String patientName;
    private int nurseId;
    private int doctorId;
    private String status;
    private String result;
    private String medicationsPrescribed;
    private Date followUpDate;
    private Timestamp diagnosisDate;
    private String nurseAssessment;
    
    public DiagnosisPatientView(int diagnosisId, int patientId, String patientName, int nurseId, int doctorId, 
                           String status, String result, String medicationsPrescribed, 
                           Date followUpDate, Timestamp diagnosisDate, String nurseAssessment) {
        this.diagnosisId = diagnosisId;
        this.patientId = patientId;
        this.patientName = patientName;
        this.nurseId = nurseId;
        this.doctorId = doctorId;
        this.status = status;
        this.result = result;
        this.medicationsPrescribed = medicationsPrescribed;
        this.followUpDate = followUpDate;
        this.diagnosisDate = diagnosisDate;
        this.nurseAssessment = nurseAssessment;
    }

    public int getDiagnosisId() {
        return diagnosisId;
    }

    public int getPatientId() {
        return patientId;
    }
    
    public String getPatientName() {
        return patientName;
    }

    public int getNurseId() {
        return nurseId;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public String getStatus() {
        return status;
    }

    public String getResult() {
        return result;
    }
    
    public String getMedicationsPrescribed() {
        return medicationsPrescribed;
    }
    
    public Date getFollowUpDate() {
        return followUpDate;
    }
    
    public Timestamp getDiagnosisDate() {
        return diagnosisDate;
    }
    
    public String getNurseAssessment() {
        return nurseAssessment;
    }
} 