package com.mbc_hospital.model;

public class Schedule {
    private String patientName;
    private String email;
    private String appointmentType;
    private String doctor;
    private String date;
    private String time;
    private String reason;

    public Schedule(String patientName, String email, String appointmentType, String doctor, String date, String time, String reason) {
        this.patientName = patientName;
        this.email = email;
        this.appointmentType = appointmentType;
        this.doctor = doctor;
        this.date = date;
        this.time = time;
        this.reason = reason;
    }

    // Getters
    public String getPatientName() { return patientName; }
    public String getEmail() { return email; }
    public String getAppointmentType() { return appointmentType; }
    public String getDoctor() { return doctor; }
    public String getDate() { return date; }
    public String getTime() { return time; }
    public String getReason() { return reason; }
}

