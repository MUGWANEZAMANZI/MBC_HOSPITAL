package com.mbc_hospital.controller;

import com.mbc_hospital.model.MapModel;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/MapController")  // Make sure this is the correct URL pattern
public class MapController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Create the MapModel with hospital information
        MapModel hospital = new MapModel(
            "MBC Hospital",  // Hospital Name
            "Kigali, Rwanda",  // Address
            "https://www.google.com/maps/embed?pb=...yourMapEmbedUrl...",  // Embed URL
            "https://www.google.com/maps/place/...yourMapLink..."  // Google Maps Link
        );

        // Set the hospital object as an attribute in the request
        request.setAttribute("hospital", hospital);

        // Forward the request to map.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/map.jsp");
        dispatcher.forward(request, response);
    }
}
