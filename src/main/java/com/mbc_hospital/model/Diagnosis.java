package com.mbc_hospital.model;

public class Diagnosis {
    private int diagnosisId;
    private int patientId;
    private int nurseId;
    private int doctorId;
    private String status;
    private String result;

    public Diagnosis(int diagnosisId, int patientId, int nurseId, int doctorId, String status, String result) {
        this.diagnosisId = diagnosisId;
        this.patientId = patientId;
        this.nurseId = nurseId;
        this.doctorId = doctorId;
        this.status = status;
        this.result = result;
    }

    public int getDiagnosisId() {
        return diagnosisId;
    }

    public int getPatientId() {
        return patientId;
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
}
