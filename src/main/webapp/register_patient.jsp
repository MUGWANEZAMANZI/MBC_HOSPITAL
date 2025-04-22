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
<body class="bg-gray-100">

    <!-- Navbar -->
    <nav class="bg-blue-600 text-white p-4">
        <div class="container mx-auto flex justify-between items-center">
            <h1 class="text-2xl font-bold">Register Patient</h1>
            <div>
                <button class="bg-blue-800 px-4 py-2 rounded hover:bg-blue-700"><a href="logout.jsp">Logout</a></button>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mx-auto mt-8">
        <form action="PatientController" method="post" enctype="multipart/form-data" class="bg-white shadow-md rounded-lg p-6">
            <h2 class="text-xl font-bold text-blue-600 mb-4">Patient Registration</h2>
            <input type="hidden" name="action" value="registerPatient">
            <div class="mb-4">
                <label class="block text-blue-600 mb-2">First Name:</label>
                <input type="text" name="firstName" class="w-full p-2 border border-gray-300 rounded" required>
            </div>
            <div class="mb-4">
                <label class="block text-blue-600 mb-2">Last Name:</label>
                <input type="text" name="lastName" class="w-full p-2 border border-gray-300 rounded" required>
            </div>
            <div class="mb-4">
                <label class="block text-blue-600 mb-2">Telephone:</label>
                <input type="text" name="telephone" class="w-full p-2 border border-gray-300 rounded" required>
            </div>
            <div class="mb-4">
                <label class="block text-blue-600 mb-2">Email:</label>
                <input type="email" name="email" class="w-full p-2 border border-gray-300 rounded" required>
            </div>
            <div class="mb-4">
                <label class="block text-blue-600 mb-2">Address:</label>
                <input type="text" name="address" class="w-full p-2 border border-gray-300 rounded" required>
            </div>
            <div class="mb-4">
                <label class="block text-blue-600 mb-2">Profile Image:</label>
                <input type="file" name="pImage" class="w-full p-2 border border-gray-300 rounded" required>
            </div>
            <div class="text-center">
                <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Register</button>
            </div>
        </form>
    </div>

    <!-- Footer -->
    <footer class="bg-blue-600 text-white text-center p-4 mt-8">
        <p>&copy; 2023 Hospital Management System</p>
    </footer>

</body>
</html>
