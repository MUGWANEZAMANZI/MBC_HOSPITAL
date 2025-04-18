<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registered Nurses</title>
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
    <h1 class="text-2xl font-bold mb-4">List of Registered Nurses</h1>
    <div class="overflow-x-auto">
        <table class="table-auto w-full border-collapse border border-gray-300">
            <thead>
                <tr class="bg-gray-200">
                    <th class="border border-gray-300 px-4 py-2">Nurse ID</th>
                    <th class="border border-gray-300 px-4 py-2">First Name</th>
                    <th class="border border-gray-300 px-4 py-2">Last Name</th>
                    <th class="border border-gray-300 px-4 py-2">Telephone</th>
                    <th class="border border-gray-300 px-4 py-2">Email</th>
                    <th class="border border-gray-300 px-4 py-2">Address</th>
                    <th class="border border-gray-300 px-4 py-2">Health Center</th>
                    <th class="border border-gray-300 px-4 py-2">Registered By</th>
                </tr>
            </thead>
            <tbody>
                <%
                    java.util.List<com.mbc_hospital.model.Nurse> nurseList =
                        (java.util.List<com.mbc_hospital.model.Nurse>) request.getAttribute("nurseList");
                    if (nurseList != null && !nurseList.isEmpty()) {
                        for (com.mbc_hospital.model.Nurse nurse : nurseList) {
                %>
                <tr class="bg-white">
                    <td class="border border-gray-300 px-4 py-2"><%= nurse.getNurseId() %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= nurse.getFirstName() %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= nurse.getLastName() %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= nurse.getTelephone() %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= nurse.getEmail() %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= nurse.getAddress() %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= nurse.getHealthCenter() %></td>
                    <td class="border border-gray-300 px-4 py-2"><%= nurse.getRegisteredBy() %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="8" class="border border-gray-300 px-4 py-2 text-center">No nurses registered yet.</td>
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
