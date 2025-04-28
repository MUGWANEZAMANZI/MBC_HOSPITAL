package com.mbc_hospital.model;

public class Doc {
    private int id;
    private String name;
    private String specialty;
    private String location;

    public Doc(int id, String name, String specialty, String location) {
        this.id = id;
        this.name = name;
        this.specialty = specialty;
        this.location = location;
    }

    // Getters
    public int getId() { return id; }
    public String getName() { return name; }
    public String getSpecialty() { return specialty; }
    public String getLocation() { return location; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setSpecialty(String specialty) { this.specialty = specialty; }
    public void setLocation(String location) { this.location = location; }
}
