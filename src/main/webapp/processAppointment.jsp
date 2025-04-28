<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // Process form data
    String patientName = request.getParameter("patientName");
    String email = request.getParameter("email");
    String appointmentType = request.getParameter("appointmentType");
    String doctor = request.getParameter("doctor");
    String date = request.getParameter("date");
    String time = request.getParameter("time");
    String reason = request.getParameter("reason");
    
    // In a real application, you would:
    // 1. Validate the data
    // 2. Store in database
    // 3. Send confirmation email
    
    // For now, just display confirmation
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Appointment Confirmation</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="assets/css/all.min.css">
</head>
<body class="bg-gray-100 min-h-screen flex flex-col items-center p-6">
    <div class="bg-white rounded-xl shadow-md p-6 max-w-2xl w-full">
        <div class="text-center mb-6">
            <i class="fas fa-check-circle fa-5x text-green-500 mb-4"></i>
            <h1 class="text-2xl font-bold text-gray-800">Appointment Scheduled Successfully!</h1>
        </div>
        
        <div class="space-y-4 mb-6">
            <div class="flex justify-between border-b pb-2">
                <span class="font-medium">Patient Name:</span>
                <span><%= patientName %></span>
            </div>
            <div class="flex justify-between border-b pb-2">
                <span class="font-medium">Appointment Date:</span>
                <span><%= date %> at <%= time %></span>
            </div>
            <div class="flex justify-between border-b pb-2">
                <span class="font-medium">Doctor:</span>
                <span><%= doctor.isEmpty() ? "Any Available Doctor" : doctor %></span>
            </div>
            <div class="flex justify-between border-b pb-2">
                <span class="font-medium">Appointment Type:</span>
                <span><%= appointmentType %></span>
            </div>
        </div>
        
        <div class="text-center">
            <p class="mb-4">A confirmation has been sent to <%= email %></p>
            <a href="patientDashboard.jsp" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
                Return to Dashboard
            </a>
        </div>
    </div>
</body>
</html>