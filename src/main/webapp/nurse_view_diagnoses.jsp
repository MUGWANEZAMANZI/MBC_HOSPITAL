<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Patient" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    Integer userID = null;
    String userType = null;

    if (session != null) {
        if (session.getAttribute("id") != null) {
            try {
                userID = (Integer) session.getAttribute("id");
            } catch (ClassCastException e) {
                // Handle exception
            }
        }
        
        if (session.getAttribute("usertype") != null) {
            userType = (String) session.getAttribute("usertype");
        }
    }

    if (userID == null || !"Nurse".equalsIgnoreCase(userType)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Completed Diagnoses - MBC Hospital</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <style>
        [x-cloak] { display: none !important; }
        .animate-fade-in {
            animation: fadeIn 0.5s ease-in-out forwards;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen" x-data="{ showModal: false, selectedPatient: null }">

    <!-- Header -->
    <header class="bg-gradient-to-r from-blue-700 to-blue-900 text-white shadow-xl">
        <div class="container mx-auto py-4 px-6">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-3">
                    <i class="fas fa-hospital text-3xl text-blue-200"></i>
                    <h1 class="text-3xl font-bold tracking-tight">MBC HOSPITAL</h1>
                </div>
                <div class="flex items-center space-x-6">
                    <a class="flex items-center px-4 py-2 bg-blue-800 hover:bg-blue-600 rounded-lg transition duration-300 shadow-md" href="nurse.jsp">
                        <i class="fas fa-home mr-2"></i>Home
                    </a>
                    <div class="flex items-center bg-blue-800/50 px-4 py-2 rounded-lg">
                        <i class="fas fa-user-circle text-xl mr-2 text-blue-200"></i>
                        <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Sidebar -->
    <div class="flex">
        <aside class="w-64 h-screen bg-gradient-to-b from-blue-800 to-blue-900 text-white fixed left-0 top-0 pt-24 transform transition-transform duration-300 ease-in-out">
            <div class="px-6 py-4 border-t border-blue-700">
                <div class="flex items-center space-x-3">
                    <div class="h-10 w-10 rounded-full bg-blue-600 flex items-center justify-center">
                        <i class="fas fa-user-nurse"></i>
                    </div>
                    <div>
                        <p class="text-xs text-blue-300">Logged in as</p>
                        <p class="font-medium"><%= session.getAttribute("username") %></p>
                    </div>
                </div>
            </div>
            
            <nav class="mt-8 px-6">
                <a href="nurse.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:bg-blue-700/50 p-3 rounded-lg mb-2">
                    <i class="fas fa-tachometer-alt w-6"></i>
                    <span>Dashboard</span>
                </a>
                <a href="create_patient.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:bg-blue-700/50 p-3 rounded-lg mb-2">
                    <i class="fas fa-user-plus w-6"></i>
                    <span>Register Patient</span>
                </a>
                <a href="patients-dir" class="sidebar-link flex items-center space-x-3 text-white/90 hover:bg-blue-700/50 p-3 rounded-lg mb-2">
                    <i class="fas fa-stethoscope w-6"></i>
                    <span>Make Diagnosis</span>
                </a>
                <a href="nurse-view-diagnoses" class="sidebar-link active flex items-center space-x-3 bg-blue-700/50 text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-clipboard-check w-6"></i>
                    <span>View Diagnosed Cases</span>
                </a>
                <a href="logout.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:bg-red-700/30 p-3 rounded-lg mt-8 bg-red-500/20">
                    <i class="fas fa-sign-out-alt w-6"></i>
                    <span>Logout</span>
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="ml-64 flex-grow p-6">
            <div class="mb-6 animate-fade-in">
                <h1 class="text-2xl font-bold text-gray-800 flex items-center">
                    <i class="fas fa-clipboard-check mr-3 text-blue-600"></i>
                    Completed Diagnoses
                </h1>
                <p class="text-gray-600 mt-1">View diagnoses that have been completed by doctors</p>
            </div>

            <!-- Diagnoses Table -->
            <div class="bg-white rounded-xl shadow-lg overflow-hidden mt-6 animate-fade-in" style="animation-delay: 0.1s">
                <div class="p-6">
                    <table class="min-w-full bg-white">
                        <thead class="bg-gray-100 text-gray-700">
                            <tr>
                                <th class="py-3 px-4 text-left font-semibold">Patient ID</th>
                                <th class="py-3 px-4 text-left font-semibold">Patient Name</th>
                                <th class="py-3 px-4 text-left font-semibold">Diagnosis Status</th>
                                <th class="py-3 px-4 text-left font-semibold">Result</th>
                                <th class="py-3 px-4 text-left font-semibold">Medications</th>
                                <th class="py-3 px-4 text-left font-semibold">Follow-up Date</th>
                                <th class="py-3 px-4 text-left font-semibold">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            <%
                            List<Patient> completedDiagnoses = (List<Patient>) request.getAttribute("completedDiagnoses");
                            if (completedDiagnoses != null && !completedDiagnoses.isEmpty()) {
                                for (Patient patient : completedDiagnoses) {
                            %>
                            <tr class="hover:bg-gray-50 transition duration-150">
                                <td class="py-3 px-4"><%= patient.getPatientID() %></td>
                                <td class="py-3 px-4 font-medium"><%= patient.getFirstName() + " " + patient.getLastName() %></td>
                                <td class="py-3 px-4">
                                    <% if ("Positive".equals(patient.getDiagnosisStatus())) { %>
                                        <span class="px-2 py-1 bg-red-100 text-red-800 rounded-full text-xs font-medium">
                                            Positive
                                        </span>
                                    <% } else { %>
                                        <span class="px-2 py-1 bg-green-100 text-green-800 rounded-full text-xs font-medium">
                                            Negative
                                        </span>
                                    <% } %>
                                </td>
                                <td class="py-3 px-4"><%= patient.getDiagnosisResult() %></td>
                                <td class="py-3 px-4"><%= patient.getMedicationsPrescribed() != null ? patient.getMedicationsPrescribed() : "None" %></td>
                                <td class="py-3 px-4"><%= patient.getFollowUpDate() != null ? patient.getFollowUpDate() : "Not scheduled" %></td>
                                <td class="py-3 px-4">
                                    <a href="nurse-view-diagnoses?id=<%= patient.getDiagnosisID() %>" 
                                        class="px-3 py-1 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition flex items-center text-sm"
                                    >
                                        <i class="fas fa-eye mr-1"></i> View Details
                                    </a>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="7" class="py-4 px-4 text-center text-gray-500">
                                    <div class="flex flex-col items-center justify-center py-8">
                                        <div class="inline-flex h-20 w-20 rounded-full bg-blue-100 text-blue-600 items-center justify-center mb-4">
                                            <i class="fas fa-clipboard-check text-4xl"></i>
                                        </div>
                                        <h3 class="text-lg font-medium text-gray-900 mb-2">No completed diagnoses found</h3>
                                        <p class="text-gray-500">There are currently no diagnoses that have been completed by doctors.</p>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- View Diagnosis Modal -->
    <div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" 
         x-show="showModal" 
         x-transition:enter="transition ease-out duration-300"
         x-transition:enter-start="opacity-0"
         x-transition:enter-end="opacity-100"
         x-transition:leave="transition ease-in duration-200"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0"
         x-cloak>
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-2xl mx-4 overflow-hidden" 
             @click.away="showModal = false"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0 transform scale-95"
             x-transition:enter-end="opacity-100 transform scale-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100 transform scale-100"
             x-transition:leave-end="opacity-0 transform scale-95">
            
            <!-- Modal Header -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 py-4 px-6">
                <div class="flex justify-between items-center">
                    <h3 class="text-xl font-bold text-white">Diagnosis Details</h3>
                    <button @click="showModal = false" class="text-white hover:text-blue-200 transition">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <p class="text-blue-100 text-sm mt-1">Patient ID: <span x-text="selectedPatient"></span></p>
            </div>
            
            <!-- Modal Body - This would be populated with AJAX in a real app -->
            <div class="p-6">
                <div id="diagnosisDetails" class="space-y-4">
                    <p class="text-gray-500">Loading diagnosis details...</p>
                </div>
                
                <div class="flex justify-end mt-6">
                    <button type="button" @click="showModal = false" 
                            class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition duration-300">
                        Close
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-white border-t border-gray-200 ml-64">
        <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
            <div class="md:flex md:items-center md:justify-between">
                <div class="flex justify-center space-x-6 md:order-2">
                    <a href="#" class="text-gray-400 hover:text-gray-500">
                        <i class="fab fa-facebook"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-gray-500">
                        <i class="fab fa-instagram"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-gray-500">
                        <i class="fab fa-twitter"></i>
                    </a>
                </div>
                <div class="mt-8 md:mt-0 md:order-1">
                    <p class="text-center text-gray-500">&copy; 2025 MBC Hospital System. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // In a real application, this would be an AJAX request to get the diagnosis details
            // For now, just a simple mock-up that would show diagnosis details when modal opens
            Alpine.effect(() => {
                const showModal = Alpine.store('showModal');
                const selectedPatient = Alpine.store('selectedPatient');
                
                if (showModal && selectedPatient) {
                    // This would be replaced with an actual AJAX call
                    console.log("Fetching details for patient ID:", selectedPatient);
                    
                    // Mock diagnosis details
                    const mockDetails = `
                        <% if (completedDiagnoses != null && !completedDiagnoses.isEmpty()) { %>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                            <div>
                                <h4 class="text-sm font-medium text-gray-500">Patient Details</h4>
                                <p class="text-gray-900 font-medium">
                                    ID: <span x-text="selectedPatient"></span>
                                </p>
                                <p class="text-gray-700">
                                    Name: <span id="patientName"></span>
                                </p>
                                <p class="text-gray-700">
                                    Contact: <span id="patientContact"></span>
                                </p>
                            </div>
                            <div>
                                <h4 class="text-sm font-medium text-gray-500">Diagnosis Status</h4>
                                <p>
                                    <span id="diagnosisStatus" class="px-2 py-1 rounded-full text-xs font-medium"></span>
                                </p>
                            </div>
                        </div>
                        
                        <div class="border-t border-gray-200 pt-4 mt-4">
                            <h4 class="text-sm font-medium text-gray-500 mb-2">Diagnosis Result</h4>
                            <p class="text-gray-700" id="diagnosisResult"></p>
                        </div>
                        
                        <div class="border-t border-gray-200 pt-4 mt-4">
                            <h4 class="text-sm font-medium text-gray-500 mb-2">Medications Prescribed</h4>
                            <p class="text-gray-700" id="medications"></p>
                        </div>
                        
                        <div class="border-t border-gray-200 pt-4 mt-4">
                            <h4 class="text-sm font-medium text-gray-500 mb-2">Follow-up Instructions</h4>
                            <p class="text-gray-700" id="followUp"></p>
                        </div>
                        
                        <div class="border-t border-gray-200 pt-4 mt-4">
                            <h4 class="text-sm font-medium text-gray-500 mb-2">Nurse Assessment</h4>
                            <p class="text-gray-700" id="nurseAssessment"></p>
                        </div>
                        <% } else { %>
                        <div class="text-center py-4">
                            <p class="text-gray-500">No diagnosis details available.</p>
                        </div>
                        <% } %>
                    `;
                    
                    document.getElementById('diagnosisDetails').innerHTML = mockDetails;
                    
                    // In a real app, these would be populated with actual data from an AJAX call
                    // For now, just set some placeholder text
                    document.getElementById('patientName').textContent = "Patient Name";
                    document.getElementById('patientContact').textContent = "Patient Contact";
                    document.getElementById('diagnosisStatus').textContent = "Diagnosed";
                    document.getElementById('diagnosisStatus').classList.add("bg-green-100", "text-green-800");
                    document.getElementById('diagnosisResult').textContent = "Diagnosis result would appear here...";
                    document.getElementById('medications').textContent = "Prescribed medications would appear here...";
                    document.getElementById('followUp').textContent = "Follow-up instructions would appear here...";
                    document.getElementById('nurseAssessment').textContent = "Nurse assessment would appear here...";
                }
            });
        });
    </script>
</body>
</html> 