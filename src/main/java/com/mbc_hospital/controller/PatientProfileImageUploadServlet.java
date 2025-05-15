package com.mbc_hospital.controller;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

import com.mbc_hospital.model.DBConnection;
import com.mbc_hospital.model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/upload-profile-image")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 5 * 1024 * 1024,   // 5 MB
    maxRequestSize = 10 * 1024 * 1024 // 10 MB
)
public class PatientProfileImageUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Directory where uploaded files will be saved
    private static final String UPLOAD_DIRECTORY = "patient_images";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Verify user is logged in as a patient
        String userType = (String) session.getAttribute("usertype");
        if (userType == null || !"patient".equalsIgnoreCase(userType)) {
            response.sendRedirect("patient_login.jsp");
            return;
        }
        
        // Get patient data from session
        Patient patient = (Patient) session.getAttribute("patient");
        if (patient == null) {
            response.sendRedirect("patient_login.jsp");
            return;
        }
        
        // Create uploads directory if it doesn't exist
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIRECTORY;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        try {
            // Get the file part from the request
            Part filePart = request.getPart("profileImage");
            if (filePart == null || filePart.getSize() == 0) {
                request.setAttribute("message", "Please select a file to upload");
                request.getRequestDispatcher("patient_dashboard.jsp").forward(request, response);
                return;
            }
            
            // Check file type (allow only image files)
            String fileName = filePart.getSubmittedFileName();
            String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            if (!fileExtension.equals(".jpg") && !fileExtension.equals(".jpeg") && 
                !fileExtension.equals(".png") && !fileExtension.equals(".gif")) {
                request.setAttribute("message", "Only image files (JPG, JPEG, PNG, GIF) are allowed");
                request.getRequestDispatcher("patient_dashboard.jsp").forward(request, response);
                return;
            }
            
            // Generate a unique file name to prevent duplicates
            String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
            
            // Write the file to disk
            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);
            
            // Update patient record in database
            String imageLink = UPLOAD_DIRECTORY + "/" + uniqueFileName;
            updatePatientProfileImage(patient.getPatientID(), imageLink);
            
            // Update the patient object in session
            patient.setImageLink(imageLink);
            session.setAttribute("patient", patient);
            
            // Redirect back to dashboard with success message
            request.setAttribute("message", "Profile image uploaded successfully");
            request.getRequestDispatcher("patient_dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("patient_dashboard.jsp").forward(request, response);
        }
    }
    
    private void updatePatientProfileImage(int patientId, String imageLink) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("UPDATE Patients SET PImageLink = ? WHERE PatientID = ?")) {
            stmt.setString(1, imageLink);
            stmt.setInt(2, patientId);
            stmt.executeUpdate();
        }
    }
} 