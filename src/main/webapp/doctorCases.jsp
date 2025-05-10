<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Patient" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Session validation
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userType = (String) session.getAttribute("usertype");
    if (userType == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Redirect based on user type
    String[] roles = {"doctor", "nurse", "patient"};
    if (userType.toLowerCase().equals(roles[0])) {
        response.sendRedirect("doctor.jsp");
        return;
    } else if (userType.toLowerCase().equals(roles[1])) {
        response.sendRedirect("nurse.jsp");
        return;
    } else if (userType.toLowerCase().equals(roles[2])) {
        response.sendRedirect("patient.jsp");
        return;
    }
    
    // Get patients data
    List<Patient> patients = (List<Patient>) request.getAttribute("patients-doc") ;
    int patientCount = (patients != null) ? patients.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registered Patients</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
</head>
<body class="bg-gray-50 min-h-screen">
    <header class="bg-blue-700 text-white py-4 px-6 shadow-lg">
        <div class="container mx-auto flex justify-between items-center">
            <div class="flex items-center space-x-2">
                <i class="fas fa-hospital text-2xl"></i>
                <h1 class="text-2xl font-bold">MBC HOSPITAL</h1>
            </div>
            <div class="flex items-center space-x-3">
                <a class="flex items-center px-4 py-2 bg-blue-800 hover:bg-blue-900 rounded-md transition" 
                   href="dashboard.jsp">
                    <i class="fas fa-home mr-2"></i>Home
                </a>
                <div class="flex items-center space-x-2">
                    <i class="fas fa-user-circle"></i>
                    <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
                </div>
            </div>
        </div>
    </header>

    <main class="container mx-auto p-6">
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
            <div class="flex flex-col md:flex-row md:justify-between md:items-center mb-6">
                <h2 class="text-2xl font-bold text-gray-800 mb-4 md:mb-0">
                    <i class="fas fa-user-injured text-blue-600 mr-2"></i>
                    Patients Registered by Doctors
                </h2>
                
                <div class="bg-blue-50 border border-blue-200 rounded-lg p-4 flex items-center">
                    <div class="bg-blue-100 p-3 rounded-full mr-4">
                        <i class="fas fa-users text-blue-600 text-xl"></i>
                    </div>
                    <div>
                        <h5 class="text-sm font-medium text-gray-500">TOTAL PATIENTS</h5>
                        <p class="text-2xl font-bold text-blue-700"><%= patientCount %></p>
                    </div>
                </div>
            </div>

            <div class="overflow-x-auto rounded-lg border border-gray-200">
                <table class="w-full border-collapse">
                    <thead>
                        <tr class="bg-gray-100">
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">ID</th>
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Full Name</th>
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Telephone</th>
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Email</th>
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Address</th>
                            <th class="border-b border-gray-200 px-4 py-3 text-left text-sm font-medium text-gray-700">Registered By</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (patients != null && !patients.isEmpty()) { 
                            for (Patient p : patients) { %>
                                <tr class="hover:bg-gray-50 transition">
                                    <td class="border-b border-gray-200 px-4 py-3 text-sm"><%= p.getPatientID() %></td>
                                    <td class="border-b border-gray-200 px-4 py-3 text-sm font-medium">
                                        <div class="flex items-center">
                                            <div class="h-8 w-8 bg-blue-100 rounded-full flex items-center justify-center mr-3">
                                                <i class="fas fa-user text-blue-500"></i>
                                            </div>
                                            <%= p.getFirstName() + " " + p.getLastName() %>
                                        </div>
                                    </td>
                                    <td class="border-b border-gray-200 px-4 py-3 text-sm">
                                        <div class="flex items-center">
                                            <i class="fas fa-phone text-gray-400 mr-2"></i>
                                            <%= p.getTelephone() %>
                                        </div>
                                    </td>
                                    <td class="border-b border-gray-200 px-4 py-3 text-sm">
                                        <div class="flex items-center">
                                            <i class="fas fa-envelope text-gray-400 mr-2"></i>
                                            <%= p.getEmail() %>
                                        </div>
                                    </td>
                                    <td class="border-b border-gray-200 px-4 py-3 text-sm">
                                        <div class="flex items-center">
                                            <i class="fas fa-map-marker-alt text-gray-400 mr-2"></i>
                                            <%= p.getAddress() %>
                                        </div>
                                    </td>
                                    <td class="border-b border-gray-200 px-4 py-3 text-sm">
                                        <div class="flex items-center">
                                            <div class="h-7 w-7 bg-green-100 rounded-full flex items-center justify-center mr-2">
                                                <i class="fas fa-user-nurse text-green-600"></i>
                                            </div>
                                            <%= p.getRegisteredByName() %>
                                        </div>
                                    </td>
                                </tr>
                        <% } 
                        } else { %>
                            <tr>
                                <td colspan="6" class="border-b border-gray-200 px-4 py-8 text-sm text-center text-gray-500">
                                    <div class="flex flex-col items-center justify-center">
                                        <i class="fas fa-folder-open text-gray-300 text-5xl mb-3"></i>
                                        <p>No patients found or failed to load data.</p>
                                        <a href="dashboard.jsp" class="mt-3 text-blue-600 hover:text-blue-800">
                                            <i class="fas fa-arrow-left mr-1"></i> Return to Dashboard
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <div class="mt-6 flex justify-between items-center">
                <a href="dashboard.jsp" class="bg-gray-200 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-300 transition flex items-center">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
                </a>
                
                <% if (patients != null && !patients.isEmpty()) { %>
                    <button class="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700 transition flex items-center" 
                            onclick="exportToCSV()">
                        <i class="fas fa-file-export mr-2"></i> Export Data
                    </button>
                <% } %>
            </div>
        </div>
    </main>
    
    <footer class="bg-white py-4 mt-auto border-t">
        <div class="container mx-auto text-center text-gray-500 text-sm">
            &copy; <%= new java.util.Date().getYear() + 1900 %> MBC Hospital Management System
        </div>
    </footer>

    <script>
        function exportToCSV() {
            // Create CSV content
            let csv = 'ID,Full Name,Telephone,Email,Address,Registered By\n';
            
            <% if (patients != null && !patients.isEmpty()) { 
                for (Patient p : patients) { %>
                    csv += '<%= p.getPatientID() %>,';
                    csv += '"<%= p.getFirstName() + " " + p.getLastName() %>",';
                    csv += '"<%= p.getTelephone() %>",';
                    csv += '"<%= p.getEmail() %>",';
                    csv += '"<%= p.getAddress() %>",';
                    csv += '"<%= p.getRegisteredByName() %>"\n';
            <% } } %>
            
            // Create download link
            const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const link = document.createElement('a');
            link.setAttribute('href', url);
            link.setAttribute('download', 'patients_data_<%= new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date()) %>.csv');
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            
            showNotification('Data exported successfully!');
        }
        
        function showNotification(message) {
            // Create notification element
            const notification = document.createElement('div');
            notification.className = 'fixed bottom-4 right-4 bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded shadow-lg z-50 transition transform duration-300 opacity-0 translate-y-2';
            notification.innerHTML = `<div class="flex items-center"><i class="fas fa-check-circle mr-2"></i>${message}</div>`;
            
            document.body.appendChild(notification);            
            // Show notification with animation
            setTimeout(() => {
                notification.className = notification.className.replace('opacity-0 translate-y-2', 'opacity-100 translate-y-0');
            }, 10);
            
            // Hide after 3 seconds
            setTimeout(() => {
                notification.className = notification.className.replace('opacity-100 translate-y-0', 'opacity-0 translate-y-2');
                setTimeout(() => {
                    notification.remove();
                }, 300);
            }, 3000);
        }
    </script>
</body>
</html>