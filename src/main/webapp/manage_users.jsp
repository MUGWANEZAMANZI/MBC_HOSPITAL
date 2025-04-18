<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<header class="bg-blue-600 text-white py-4 shadow-md">
    <div class="container mx-auto flex justify-between items-center">
        <h1 class="text-2xl font-bold">Admin Dashboard</h1>
        <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
    </div>
</header>

<div class="container mx-auto p-4">
    <h1 class="text-2xl font-bold mb-4">Manage Users</h1>
    <div class="overflow-x-auto">
        <table class="table-auto w-full border-collapse border border-gray-300">
            <thead>
                <tr class="bg-gray-200">
                    <th class="border border-gray-300 px-4 py-2">Username</th>
                    <th class="border border-gray-300 px-4 py-2">Password</th>
                </tr>
            </thead>
            <tbody>
                <%
                    java.util.List<com.mbc_hospital.model.User> usersList = 
                        (java.util.List<com.mbc_hospital.model.User>) request.getAttribute("usersList");
                    if (usersList != null && !usersList.isEmpty()) {
                        for (com.mbc_hospital.model.User user : usersList) {
                %>
                <tr class="bg-white">
                    <td class="border border-gray-300 px-4 py-2"><%= user.getUsername() %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= user.getPassword() %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="2" class="border border-gray-300 px-4 py-2 text-center">No users found.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
    <div class="mt-4">
        <a href="dashboard.jsp" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">Back to Dashboard</a>
    </div>
</div>
</body>
</html>
