<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nurse Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col">

    <!-- Navbar -->
    <nav class="bg-blue-700 text-white p-4 shadow-md">
        <div class="container mx-auto flex justify-between items-center">
            <h1 class="text-3xl font-bold">Nurse Dashboard</h1>
            <a href="logout.jsp" class="bg-red-600 hover:bg-red-700 text-white font-semibold px-4 py-2 rounded shadow">Logout</a>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="container mx-auto mt-10 flex-grow">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-8">
            <!-- Registered Patients -->
            <div class="bg-white p-6 rounded-xl shadow-lg border-l-8 border-blue-500">
                <h2 class="text-xl font-semibold text-gray-700 mb-2">Registered Patients</h2>
                <p class="text-5xl font-bold text-blue-600">${registeredPatients}</p>
                <p class="text-gray-500 mt-1">Total patients registered in the system</p>
            </div>

            <!-- Referrable Cases -->
            <div class="bg-white p-6 rounded-xl shadow-lg border-l-8 border-yellow-500">
                <h2 class="text-xl font-semibold text-gray-700 mb-2">Referrable Cases</h2>
                <p class="text-5xl font-bold text-yellow-500">${referrableCases}</p>
                <p class="text-gray-500 mt-1">Cases needing external referrals</p>
            </div>

            <!-- Non-Referrable Cases -->
            <div class="bg-white p-6 rounded-xl shadow-lg border-l-8 border-green-500">
                <h2 class="text-xl font-semibold text-gray-700 mb-2">Non-Referrable Cases</h2>
                <p class="text-5xl font-bold text-green-600">${nonReferrableCases}</p>
                <p class="text-gray-500 mt-1">Cases handled internally</p>
            </div>

            <!-- Patient Results -->
            <div class="bg-white p-6 rounded-xl shadow-lg border-l-8 border-purple-500">
                <h2 class="text-xl font-semibold text-gray-700 mb-2">Patient Results</h2>
                <p class="text-5xl font-bold text-purple-600">${patientResults}</p>
                <p class="text-gray-500 mt-1">Patients with finalized test results</p>
            </div>
        </div>

        <!-- Action -->
        <div class="text-center mt-10">
            <a href="register_patient.jsp" 
               class="inline-block bg-blue-600 hover:bg-blue-700 text-white font-medium px-6 py-3 rounded-lg shadow">
                Register New Patient
            </a>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-blue-700 text-white text-center py-4 mt-10 shadow-inner">
        <p>&copy; 2023 Hospital Management System. All rights reserved.</p>
    </footer>

</body>
</html>
