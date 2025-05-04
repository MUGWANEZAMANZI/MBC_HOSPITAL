<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register New Nurse</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
<header class="bg-blue-600 text-white py-2 shadow-md">
    <div class="container mx-auto flex justify-between items-center">
        <h1 class="text-2xl font-bold">Doctor Dashboard</h1>
        <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
        
    </div>
</header>
<div class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
        <h1 class="text-2xl font-bold text-blue-600 mb-6">Register New Nurse</h1>
        <form action="RegisterNurse" method="post">
            <div class="mb-4">
                <label for="firstName" class="block text-gray-700 font-semibold">First Name</label>
                <input type="text" id="firstName" name="firstName" class="w-full p-2 border rounded" required>
            </div>
            <div class="mb-4">
                <label for="lastName" class="block text-gray-700 font-semibold">Last Name</label>
                <input type="text" id="lastName" name="lastName" class="w-full p-2 border rounded" required>
            </div>
            <div class="mb-4">
                <label for="telephone" class="block text-gray-700 font-semibold">Telephone</label>
                <input type="text" id="telephone" name="telephone" class="w-full p-2 border rounded" required>
            </div>
            <div class="mb-4">
                <label for="email" class="block text-gray-700 font-semibold">Email</label>
                <input type="email" id="email" name="email" class="w-full p-2 border rounded" required>
            </div>
            <div class="mb-4">
                <label for="address" class="block text-gray-700 font-semibold">Address</label>
                <input type="text" id="address" name="address" class="w-full p-2 border rounded" required>
            </div>
            <div class="mb-4">
                <label for="hospitalName" class="block text-gray-700 font-semibold">Hospital Name</label>
                <input type="text" id="hospitalName" name="hospitalName" class="w-full p-2 border rounded" required>
            </div>
     
            <button type="submit" class="bg-blue-600 text-white py-1 px-4 rounded hover:bg-blue-700">Register</button>
        </form>
    </div>
</div>
 <footer class="bg-gray-800 text-white py-4 mt-8">
        <div class="container mx-auto text-center">
            <p>&copy; 2023 Patient Management System. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
