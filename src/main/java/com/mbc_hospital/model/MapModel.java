package com.mbc_hospital.model;

public class MapModel {

    private String name;
    private String address;
    private String embedUrl;
    private String mapLink;

    // Constructor to initialize the MapModel
    public MapModel(String name, String address, String embedUrl, String mapLink) {
        this.name = name;
        this.address = address;
        this.embedUrl = embedUrl;
        this.mapLink = mapLink;
    }

    // Getters for each attribute
    public String getName() {
        return name;
    }

    public String getAddress() {
        return address;
    }

    public String getEmbedUrl() {
        return embedUrl;
    }

    public String getMapLink() {
        return mapLink;
    }
}
