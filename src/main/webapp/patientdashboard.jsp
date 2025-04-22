<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mbc_hospital.model.Patient" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    Patient patient = (Patient) request.getAttribute("patient");
    if (patient == null) {
%>
    <p class="text-center text-red-600 font-semibold mt-6">No patient data available.</p>
<%
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Patient Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex flex-col">

    <!-- Header -->
    <header class="bg-blue-600 text-white py-4 shadow-md">
        <div class="container mx-auto px-6 flex justify-between items-center">
            <h1 class="text-2xl font-bold">Patient Dashboard</h1>
            <div class="flex items-center space-x-4">
                <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
                <a href="logout.jsp">
                    <button class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-md shadow-md font-semibold transition duration-300">
                        Logout
                    </button>
                </a>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="flex-grow container mx-auto px-6 py-8">
        

			<!-- Profile and Case Info -->
            <div class="w-full">
            
                <h2 class="text-3xl font-bold text-center md:text-left mb-6 text-blue-800">Hello, <%= patient.getFirstName() %>!</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                    <!-- Case Status -->
                    <div class="bg-blue-50 p-6 rounded-xl shadow-md">
                        <h3 class="text-xl font-semibold mb-4 text-blue-700">Case Status</h3>
                        <p class="text-gray-700 font-medium">Status:</p>
                        <p class="text-gray-900 font-bold"><%= patient.getStatus() != null ? patient.getStatus() : "N/A" %></p>
                        <p class="text-gray-700 font-medium mt-4">Result:</p>
                        <p class="text-gray-900 font-bold"><%= patient.getResult() != null ? patient.getResult() : "Pending" %></p>
                    </div>
                    <div class="bg-white shadow-xl rounded-2xl p-8 w-full max-w-5xl mx-auto flex flex-col md:flex-row items-center gap-10">

            <!-- Profile Image -->
            <div class="flex-shrink-0">
    <img src="<%= (patient.getPImageLink() != null ? patient.getPImageLink() : "https://via.placeholder.com/150") %>" 
         alt="Profile Image"
         class="w-40 h-40 rounded-full border-4 border-blue-500 shadow-md object-cover">
		</div>

                    <!-- Profile Info -->
                    <div class="bg-green-50 p-6 rounded-xl shadow-md">
                        <h3 class="text-xl font-semibold mb-4 text-green-700">Profile Information</h3>
                        <div class="space-y-3">
                            <div>
                                <p class="text-gray-700 font-medium">Name:</p>
                                <p class="text-gray-900 font-bold"><%= patient.getFirstName() %> <%= patient.getLastName() %></p>
                            </div>
                            <div>
                                <p class="text-gray-700 font-medium">Telephone:</p>
                                <p class="text-gray-900 font-bold"><%= patient.getTelephone() %></p>
                            </div>
                            <div>
                                <p class="text-gray-700 font-medium">Email:</p>
                                <p class="text-gray-900 font-bold"><%= patient.getEmail() %></p>
                            </div>
                            <div>
                                <p class="text-gray-700 font-medium">Address:</p>
                                <p class="text-gray-900 font-bold"><%= patient.getAddress() %></p>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-gray-800 text-white py-4 mt-12">
        <div class="container mx-auto text-center">
            <p>&copy; 2025 Patient Management System. All rights reserved.</p>
        </div>
    </footer>

</body>
</html>
