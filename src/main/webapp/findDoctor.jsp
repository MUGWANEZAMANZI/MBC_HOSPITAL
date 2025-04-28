<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Find Doctor</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-6">
    <div class="max-w-4xl mx-auto">
        <h1 class="text-3xl font-bold text-blue-700 mb-6">Find a Doctor</h1>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="bg-white shadow-lg rounded-lg p-4">
                <h2 class="text-xl font-bold text-gray-800 mb-2">Dr. Smith</h2>
                <p class="text-gray-600">Cardiology, Main Hospital</p>
                <a href="appointment.jsp?doctor=Dr. Smith" 
   class="mt-4 inline-block bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition">
   Schedule Appointment
</a>

            </div>
            <div class="bg-white shadow-lg rounded-lg p-4">
                <h2 class="text-xl font-bold text-gray-800 mb-2">Dr. Johnson</h2>
                <p class="text-gray-600">Pediatrics, Downtown Clinic</p>
               <a href="appointment.jsp?doctor=Dr. Smith" 
   class="mt-4 inline-block bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition">
   Schedule Appointment
</a>

            </div>
            <div class="bg-white shadow-lg rounded-lg p-4">
                <h2 class="text-xl font-bold text-gray-800 mb-2">Dr. Williams</h2>
                <p class="text-gray-600">Neurology, Westside Medical</p>
                <a href="appointment.jsp?doctor=Dr. Smith" 
   class="mt-4 inline-block bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition">
   Schedule Appointment
</a>

            </div>
        </div>
    </div>
</body>
</html>
