<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nurse Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

    <!-- Navbar -->
    <nav class="bg-blue-600 text-white p-4">
        <div class="container mx-auto flex justify-between items-center">
            <h1 class="text-2xl font-bold">Nurse Dashboard</h1>
            <div>
                <button class="bg-blue-800 px-4 py-2 rounded hover:bg-blue-700"><a href="logout.jsp">Logout</a></button>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mx-auto mt-8">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">

            <!-- Registered Patients -->
            <div class="bg-white shadow-md rounded-lg p-6">
                <h2 class="text-xl font-bold text-blue-600 mb-4">Registered Patients</h2>
                <ul class="space-y-2">
                    <li class="p-4 bg-gray-100 rounded shadow">Patient 1</li>
                    <li class="p-4 bg-gray-100 rounded shadow">Patient 2</li>
                    <li class="p-4 bg-gray-100 rounded shadow">Patient 3</li>
                </ul>
            </div>

            <!-- Referrable Cases -->
            <div class="bg-white shadow-md rounded-lg p-6">
                <h2 class="text-xl font-bold text-green-600 mb-4">Referrable Cases</h2>
                <ul class="space-y-2">
                    <li class="p-4 bg-gray-100 rounded shadow">Case 1</li>
                    <li class="p-4 bg-gray-100 rounded shadow">Case 2</li>
                </ul>
            </div>

            <!-- Non-Referrable Cases -->
            <div class="bg-white shadow-md rounded-lg p-6">
                <h2 class="text-xl font-bold text-red-600 mb-4">Non-Referrable Cases</h2>
                <ul class="space-y-2">
                    <li class="p-4 bg-gray-100 rounded shadow">Case A</li>
                    <li class="p-4 bg-gray-100 rounded shadow">Case B</li>
                </ul>
            </div>

        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-blue-600 text-white text-center p-4 mt-8">
        <p>&copy; 2023 Hospital Management System</p>
    </footer>

</body>
</html>
    