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
    List<Patient> patients = (List<Patient>) request.getAttribute("patients") ;
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
    <style>
        .patient-detail-modal {
            transition: all 0.3s ease;
            transform: scale(0.95);
            opacity: 0;
            visibility: hidden;
        }
        .patient-detail-modal.show {
            transform: scale(1);
            opacity: 1;
            visibility: visible;
        }
        .modal-overlay {
            transition: all 0.3s ease;
            opacity: 0;
            visibility: hidden;
        }
        .modal-overlay.show {
            opacity: 1;
            visibility: visible;
        }
    </style>
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
                <a class="flex items-center px-4 py-2 bg-blue-800 hover:bg-blue-900 rounded-md transition" 
                   href="patients">
                    <i class="fas fa-clipboard-list mr-2"></i>Patient Results
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
                    Patients Registered by Nurses
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
                            <th class="border-b border-gray-200 px-4 py-3 text-center text-sm font-medium text-gray-700">Actions</th>
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
                                    <td class="border-b border-gray-200 px-4 py-3 text-sm text-center">
                                        <button onclick="viewPatientDetails(<%= p.getPatientID() %>, '<%= p.getFirstName() %>', '<%= p.getLastName() %>', '<%= p.getTelephone() %>', '<%= p.getEmail() %>', '<%= p.getAddress() %>', '<%= p.getRegisteredByName() %>')" 
                                                class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded-md text-xs font-medium transition">
                                            <i class="fas fa-eye mr-1"></i> View Details
                                        </button>
                                        <a href="patients?action=view&id=<%= p.getPatientID() %>" 
                                           class="bg-green-600 hover:bg-green-700 text-white px-3 py-1 rounded-md text-xs font-medium transition ml-1">
                                            <i class="fas fa-clipboard-list mr-1"></i> View Diagnoses
                                        </a>
                                    </td>
                                </tr>
                        <% } 
                        } else { %>
                            <tr>
                                <td colspan="7" class="border-b border-gray-200 px-4 py-8 text-sm text-center text-gray-500">
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
    
    <!-- Patient Details Modal -->
    <div id="modalOverlay" class="modal-overlay fixed inset-0 bg-black bg-opacity-50 z-40 flex items-center justify-center">
        <div id="patientDetailModal" class="patient-detail-modal bg-white rounded-lg shadow-xl w-full max-w-2xl z-50">
            <div class="border-b border-gray-200 px-6 py-4 flex justify-between items-center">
                <h3 class="text-lg font-semibold text-gray-800">Patient Details</h3>
                <button onclick="closeModal()" class="text-gray-400 hover:text-gray-500 focus:outline-none">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="p-6">
                <div class="flex flex-col md:flex-row">
                    <div class="md:w-1/3 flex flex-col items-center mb-6 md:mb-0">
                        <div class="h-24 w-24 bg-blue-100 rounded-full flex items-center justify-center text-blue-600 mb-4">
                            <i class="fas fa-user text-4xl"></i>
                        </div>
                        <h4 id="modalPatientName" class="text-lg font-semibold text-gray-800 text-center"></h4>
                        <p id="modalPatientId" class="text-sm text-gray-600 text-center"></p>
                    </div>
                    <div class="md:w-2/3 md:pl-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div class="bg-gray-50 p-4 rounded-lg">
                                <h5 class="text-sm font-medium text-gray-500 mb-2">Contact Information</h5>
                                <div class="mb-2">
                                    <div class="flex items-center">
                                        <i class="fas fa-phone text-gray-400 mr-2"></i>
                                        <span class="text-sm font-medium text-gray-700">Phone Number</span>
                                    </div>
                                    <p id="modalPatientPhone" class="text-sm text-gray-600 ml-6"></p>
                                </div>
                                <div>
                                    <div class="flex items-center">
                                        <i class="fas fa-envelope text-gray-400 mr-2"></i>
                                        <span class="text-sm font-medium text-gray-700">Email Address</span>
                                    </div>
                                    <p id="modalPatientEmail" class="text-sm text-gray-600 ml-6"></p>
                                </div>
                            </div>
                            <div class="bg-gray-50 p-4 rounded-lg">
                                <h5 class="text-sm font-medium text-gray-500 mb-2">Address</h5>
                                <div class="flex items-start">
                                    <i class="fas fa-map-marker-alt text-gray-400 mr-2 mt-1"></i>
                                    <p id="modalPatientAddress" class="text-sm text-gray-600"></p>
                                </div>
                            </div>
                            <div class="bg-gray-50 p-4 rounded-lg md:col-span-2">
                                <h5 class="text-sm font-medium text-gray-500 mb-2">Registration Information</h5>
                                <div class="flex items-center">
                                    <div class="h-6 w-6 bg-green-100 rounded-full flex items-center justify-center mr-2">
                                        <i class="fas fa-user-nurse text-green-600 text-xs"></i>
                                    </div>
                                    <span class="text-sm text-gray-600">Registered by: </span>
                                    <span id="modalPatientRegisteredBy" class="text-sm font-medium text-gray-700 ml-1"></span>
                                </div>
                            </div>
                        </div>
                        <div class="mt-6 flex justify-end">
                            <button class="bg-gray-200 text-gray-700 px-4 py-2 rounded-md hover:bg-gray-300 transition mr-3" onclick="closeModal()">
                                Close
                            </button>
                            <a id="viewDiagnosesLink" href="#" class="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 transition flex items-center">
                                <i class="fas fa-clipboard-list mr-2"></i> View Diagnoses
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
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
        
        // Patient Details Modal Functions
        function viewPatientDetails(id, firstName, lastName, phone, email, address, registeredBy) {
            document.getElementById('modalPatientName').textContent = firstName + ' ' + lastName;
            document.getElementById('modalPatientId').textContent = 'Patient ID: ' + id;
            document.getElementById('modalPatientPhone').textContent = phone;
            document.getElementById('modalPatientEmail').textContent = email;
            document.getElementById('modalPatientAddress').textContent = address;
            document.getElementById('modalPatientRegisteredBy').textContent = registeredBy;
            
            // Set link for View Diagnoses button
            document.getElementById('viewDiagnosesLink').href = 'patients?action=view&id=' + id;
            
            // Show modal with animation
            const overlay = document.getElementById('modalOverlay');
            const modal = document.getElementById('patientDetailModal');
            
            overlay.classList.add('show');
            modal.classList.add('show');
        }
        
        function closeModal() {
            const overlay = document.getElementById('modalOverlay');
            const modal = document.getElementById('patientDetailModal');
            
            overlay.classList.remove('show');
            modal.classList.remove('show');
        }
        
        // Close modal when clicking outside
        document.getElementById('modalOverlay').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });
        
        // Hide modal on page load
        document.addEventListener('DOMContentLoaded', function() {
            const overlay = document.getElementById('modalOverlay');
            const modal = document.getElementById('patientDetailModal');
            
            if (overlay && modal) {
                overlay.classList.remove('show');
                modal.classList.remove('show');
            }
        });
    </script>
</body>
</html>