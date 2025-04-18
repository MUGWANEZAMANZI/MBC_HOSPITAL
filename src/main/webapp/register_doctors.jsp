<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register New Doctor</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
        <h1 class="text-2xl font-bold text-blue-600 mb-6">Register New Doctor</h1>
        <form action="RegisterDoctorServlet" method="post">
            <div class="mb-4">
                <label for="doctorId" class="block text-gray-700 font-semibold">Doctor ID</label>
                <input type="text" id="doctorId" name="doctorId" class="w-full p-2 border rounded" required>
            </div>
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
     
            <button type="submit" class="bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700">Register</button>
        </form>
    </div>
</body>
</html>
