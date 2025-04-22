<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Patient</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col">

    <!-- Navbar -->
    <nav class="bg-blue-600 text-white p-4 shadow-md">
        <div class="container mx-auto flex justify-between items-center">
            <h1 class="text-2xl font-bold">Register Patient</h1>
            <a href="logout.jsp" class="bg-blue-800 px-4 py-2 rounded hover:bg-blue-700">Logout</a>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mx-auto mt-10 flex-grow">
        <form action="PatientController" method="post" enctype="multipart/form-data" class="bg-white shadow-lg rounded-lg p-8">
            <h2 class="text-2xl font-bold text-blue-600 mb-6">Patient Registration</h2>
            <input type="hidden" name="action" value="registerPatient">

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <label class="block text-blue-600 mb-2">First Name:</label>
                    <input type="text" name="firstName" class="w-full p-2 border border-gray-300 rounded" required>
                </div>
                <div>
                    <label class="block text-blue-600 mb-2">Last Name:</label>
                    <input type="text" name="lastName" class="w-full p-2 border border-gray-300 rounded" required>
                </div>
                <div>
                    <label class="block text-blue-600 mb-2">Telephone:</label>
                    <input type="text" name="telephone" class="w-full p-2 border border-gray-300 rounded" required>
                </div>
                <div>
                    <label class="block text-blue-600 mb-2">Email:</label>
                    <input type="email" name="email" class="w-full p-2 border border-gray-300 rounded" required>
                </div>
                <div>
                    <label class="block text-blue-600 mb-2">Address:</label>
                    <input type="text" name="address" class="w-full p-2 border border-gray-300 rounded" required>
                </div>
                <div>
                    <label class="block text-blue-600 mb-2">Profile Image:</label>
                    <input type="file" name="pImage" class="w-full p-2 border border-gray-300 rounded" required>
                </div>
                <div>
                    <label class="block text-blue-600 mb-2">Username:</label>
                    <input type="text" name="username" class="w-full p-2 border border-gray-300 rounded" required>
                </div>
                <div>
                    <label class="block text-blue-600 mb-2">Password:</label>
                    <input type="password" name="password" class="w-full p-2 border border-gray-300 rounded" required>
                </div>
            </div>

            <div class="text-center mt-8">
                <button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 shadow-md">
                    Register Patient
                </button>
            </div>
        </form>
    </div>

    <!-- Footer -->
    <footer class="bg-blue-600 text-white text-center p-4 mt-10 shadow-inner">
        <p>&copy; 2023 Hospital Management System</p>
    </footer>

</body>
</html>
