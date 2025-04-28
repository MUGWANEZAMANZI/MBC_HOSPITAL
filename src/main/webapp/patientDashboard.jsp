<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="assets/css/all.min.css">
    
</head>
<body class="bg-gray-100 min-h-screen flex flex-col items-center p-6">
    <h1 class="text-3xl font-bold text-blue-700 mb-6">Welcome, ${patient.name}</h1>
    
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 w-full max-w-6xl">
        <div class="bg-white rounded-xl shadow-md p-6">
           <i class="fas fa-user-md fa-2x text-blue-600"></i> <!-- Doctor -->
            <h2 class="text-xl font-semibold text-blue-800">Our Doctors</h2>
            <p class="text-gray-600">Search by name, specialty, location and more.</p>
            <a href="findDoctor.jsp" class="mt-3 inline-block bg-blue-600 text-white px-4 py-2 rounded">Find a Doctor</a>
        </div>

        <div class="bg-white rounded-xl shadow-md p-6">
            <i class="fas fa-map-marker-alt fa-2x text-blue-600"></i> <!-- Location -->
            <h2 class="text-xl font-semibold text-blue-800">Location & Directions</h2>
            <p class="text-gray-600">Find any of our locations.</p>
            <a href="map.jsp" class="mt-3 inline-block bg-blue-600 text-white px-4 py-2 rounded">Get Directions</a>
        </div>

        <div class="bg-white rounded-xl shadow-md p-6">
            <i class="fas fa-calendar-check fa-2x text-blue-600"></i> <!-- Appointment -->
            <h2 class="text-xl font-semibold text-blue-800">Appointments</h2>
            <p class="text-gray-600">Schedule in-person or virtual care.</p>
            <a href="appointment.jsp" class="mt-3 inline-block bg-blue-600 text-white px-4 py-2 rounded" href="ProcessAppointment.jsp" class="mt-3 inline-block bg-blue-600 text-white px-4 py-2 rounded">Schedule Now</a>
        </div>
    </div>
    <i class="fas fa-user"></i> Welcome, To our Hospital
    
</body>
</html>
