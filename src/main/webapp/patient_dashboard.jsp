<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Patient, com.mbc_hospital.model.Diagnosis" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // Validate user session
    String usertype = (String) session.getAttribute("usertype");
    if (usertype == null || !"patient".equalsIgnoreCase(usertype)) {
        response.sendRedirect("patient_login.jsp");
        return;
    }
    
    // Get patient information from session
    Patient patient = (Patient) session.getAttribute("patient");
    List<Diagnosis> patientDiagnoses = (List<Diagnosis>) request.getAttribute("patientDiagnoses");
    
    if (patient == null) {
        response.sendRedirect("patient_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard - MBC Hospital</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#eff6ff',
                            100: '#dbeafe',
                            200: '#bfdbfe',
                            300: '#93c5fd',
                            400: '#60a5fa',
                            500: '#3b82f6',
                            600: '#2563eb',
                            700: '#1d4ed8',
                            800: '#1e40af',
                            900: '#1e3a8a',
                        }
                    },
                    animation: {
                        'fade-in': 'fadeIn 0.5s ease-out forwards',
                        'slide-up': 'slideUp 0.5s ease-out forwards',
                    },
                    keyframes: {
                        fadeIn: {
                            '0%': { opacity: '0' },
                            '100%': { opacity: '1' },
                        },
                        slideUp: {
                            '0%': { transform: 'translateY(20px)', opacity: '0' },
                            '100%': { transform: 'translateY(0)', opacity: '1' },
                        }
                    }
                },
            },
        }
    </script>
    <style>
        [x-cloak] { display: none !important; }
        .header {
            background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
            color: white;
            padding: 1rem 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .card {
            background-color: white;
            border-radius: 0.5rem;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.12);
        }
        
        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .table th {
            background-color: #f8fafc;
            padding: 0.85rem 1.25rem;
            text-align: left;
            font-weight: 600;
            color: #475569;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .table td {
            padding: 0.85rem 1.25rem;
            border-bottom: 1px solid #e2e8f0;
            color: #1e293b;
            vertical-align: middle;
        }
        
        .table tr:last-child td {
            border-bottom: none;
        }
        
        .table tr:hover {
            background-color: #f1f5f9;
        }
        
        @media print {
            .no-print {
                display: none !important;
            }
            .print-break {
                page-break-before: always;
            }
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen" x-data="{ showModal: false, selectedDiagnosis: null }">
    <!-- Header -->
    <header class="header no-print">
        <div class="container mx-auto flex justify-between items-center">
            <div class="flex items-center">
                <i class="fas fa-hospital text-3xl mr-3"></i>
                <div>
                    <h1 class="text-2xl font-bold">MBC Hospital</h1>
                    <p class="text-sm text-blue-100">Patient Portal</p>
                </div>
            </div>
            <div class="flex items-center space-x-4">
                <div class="flex items-center">
                    <div class="h-10 w-10 rounded-full bg-white/20 flex items-center justify-center mr-2">
                        <i class="fas fa-user text-xl"></i>
                    </div>
                    <span class="font-medium"><%= patient.getFirstName() + " " + patient.getLastName() %></span>
                </div>
                <a href="patient-logout" class="px-4 py-2 bg-red-600/20 text-white rounded hover:bg-red-700/30 transition">
                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                </a>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="container mx-auto py-8 px-4">
        <!-- Patient Information Card -->
        <div class="card mb-8 animate-fade-in">
            <div class="flex justify-between items-start">
                <div>
                    <h2 class="text-xl font-bold text-gray-800 mb-2">
                        <i class="fas fa-user-circle text-blue-600 mr-2"></i>
                        Patient Information
                    </h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
                        <div>
                            <p class="text-sm text-gray-500">Patient ID</p>
                            <p class="font-medium"><%= patient.getPatientID() %></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Full Name</p>
                            <p class="font-medium"><%= patient.getFirstName() + " " + patient.getLastName() %></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Phone Number</p>
                            <p class="font-medium"><%= patient.getTelephone() %></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Email Address</p>
                            <p class="font-medium"><%= patient.getEmail() != null ? patient.getEmail() : "Not provided" %></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Address</p>
                            <p class="font-medium"><%= patient.getAddress() != null ? patient.getAddress() : "Not provided" %></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Registration Date</p>
                            <p class="font-medium"><%= patient.getRegistrationDate() != null ? patient.getRegistrationDate() : "Unknown" %></p>
                        </div>
                    </div>
                </div>
                <button onclick="window.print()" class="btn no-print bg-blue-100 text-blue-700 px-4 py-2 rounded-lg hover:bg-blue-200 transition flex items-center">
                    <i class="fas fa-print mr-2"></i>
                    Print Information
                </button>
            </div>
        </div>

        <!-- Diagnoses Section -->
        <h2 class="text-xl font-bold text-gray-800 mb-4 flex items-center">
            <i class="fas fa-clipboard-check text-blue-600 mr-2"></i>
            My Diagnosis Results
        </h2>

        <div class="card animate-fade-in" style="animation-delay: 0.1s">
            <% if (patientDiagnoses != null && !patientDiagnoses.isEmpty()) { %>
                <div class="overflow-x-auto">
                    <table class="table min-w-full">
                        <thead>
                            <tr>
                                <th>Diagnosis Date</th>
                                <th>Status</th>
                                <th>Result</th>
                                <th>Medications</th>
                                <th>Follow-up Date</th>
                                <th class="no-print">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Diagnosis diagnosis : patientDiagnoses) { %>
                            <tr>
                                <td><%= diagnosis.getDiagnosisDate() != null ? diagnosis.getDiagnosisDate().toString() : "N/A" %></td>
                                <td>
                                    <% if ("Positive".equals(diagnosis.getResult())) { %>
                                        <span class="status-badge bg-red-100 text-red-800">
                                            <i class="fas fa-exclamation-circle mr-1"></i> Positive
                                        </span>
                                    <% } else if ("Negative".equals(diagnosis.getResult())) { %>
                                        <span class="status-badge bg-green-100 text-green-800">
                                            <i class="fas fa-check-circle mr-1"></i> Negative
                                        </span>
                                    <% } else { %>
                                        <span class="status-badge bg-gray-100 text-gray-800">
                                            <i class="fas fa-question-circle mr-1"></i> <%= diagnosis.getStatus() %>
                                        </span>
                                    <% } %>
                                </td>
                                <td class="max-w-xs truncate"><%= diagnosis.getResult() != null ? diagnosis.getResult() : "No result provided" %></td>
                                <td><%= diagnosis.getMedicationsPrescribed() != null ? diagnosis.getMedicationsPrescribed() : "None" %></td>
                                <td><%= diagnosis.getFollowUpDate() != null ? diagnosis.getFollowUpDate().toString() : "Not scheduled" %></td>
                                <td class="no-print">
                                    <button @click="showModal = true; selectedDiagnosis = <%= diagnosis.getDiagnosisId() %>" 
                                            class="px-3 py-1 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition flex items-center text-sm">
                                        <i class="fas fa-eye mr-1"></i> View Details
                                    </button>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="flex flex-col items-center justify-center py-8 text-center">
                    <div class="inline-flex h-20 w-20 rounded-full bg-blue-100 text-blue-600 items-center justify-center mb-4">
                        <i class="fas fa-clipboard-check text-4xl"></i>
                    </div>
                    <h3 class="text-lg font-medium text-gray-900 mb-2">No diagnosis results found</h3>
                    <p class="text-gray-500">You don't have any diagnosis records in our system yet.</p>
                </div>
            <% } %>
        </div>

        <!-- Upcoming Appointments Section -->
        <h2 class="text-xl font-bold text-gray-800 mb-4 mt-8 flex items-center">
            <i class="fas fa-calendar-check text-blue-600 mr-2"></i>
            Upcoming Appointments
        </h2>

        <div class="card animate-fade-in" style="animation-delay: 0.2s">
            <div class="flex flex-col items-center justify-center py-8 text-center">
                <div class="inline-flex h-20 w-20 rounded-full bg-blue-100 text-blue-600 items-center justify-center mb-4">
                    <i class="fas fa-calendar-plus text-4xl"></i>
                </div>
                <h3 class="text-lg font-medium text-gray-900 mb-2">No upcoming appointments</h3>
                <p class="text-gray-500 mb-4">You don't have any scheduled appointments.</p>
                <a href="appointment.jsp" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition flex items-center">
                    <i class="fas fa-plus mr-2"></i> Schedule an Appointment
                </a>
            </div>
        </div>
        
        <!-- Footer -->
        <footer class="mt-12 text-center text-gray-500 text-sm">
            <p>&copy; 2025 MBC Hospital System. All rights reserved.</p>
        </footer>
    </main>

    <!-- Diagnosis Detail Modal -->
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
                <p class="text-blue-100 text-sm mt-1">Diagnosis ID: <span x-text="selectedDiagnosis"></span></p>
            </div>
            
            <!-- Modal Body - This would be populated with AJAX in a real app -->
            <div class="p-6">
                <div id="diagnosisDetails" class="space-y-4">
                    <p class="text-gray-500">Loading diagnosis details...</p>
                </div>
                
                <div class="flex justify-between mt-6">
                    <button type="button" @click="showModal = false" 
                            class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition">
                        Close
                    </button>
                    <button onclick="window.print()" 
                            class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition flex items-center">
                        <i class="fas fa-print mr-2"></i> Print Details
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // In a real application, this would be an AJAX request to get the diagnosis details
            // For now, just a simple mock-up that would show diagnosis details when modal opens
            Alpine.effect(() => {
                const showModal = Alpine.store('showModal');
                const selectedDiagnosis = Alpine.store('selectedDiagnosis');
                
                if (showModal && selectedDiagnosis) {
                    // This would be replaced with an actual AJAX call
                    console.log("Fetching details for diagnosis ID:", selectedDiagnosis);
                    
                    // Mock diagnosis details
                    document.getElementById('diagnosisDetails').innerHTML = `
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                            <div>
                                <h4 class="text-sm font-medium text-gray-500">Diagnosis Date</h4>
                                <p class="text-gray-900 font-medium">
                                    <i class="fas fa-calendar-alt text-blue-500 mr-1"></i>
                                    January 15, 2025
                                </p>
                            </div>
                            <div>
                                <h4 class="text-sm font-medium text-gray-500">Status</h4>
                                <p>
                                    <span class="status-badge bg-green-100 text-green-800">
                                        <i class="fas fa-check-circle mr-1"></i> Negative
                                    </span>
                                </p>
                            </div>
                        </div>
                        
                        <div class="border-t border-gray-200 pt-4 mt-4">
                            <h4 class="text-sm font-medium text-gray-500 mb-2">Diagnosis Result</h4>
                            <p class="text-gray-700 bg-gray-50 p-3 rounded border border-gray-200">
                                Patient shows no signs of infection. All tests came back negative.
                            </p>
                        </div>
                        
                        <div class="border-t border-gray-200 pt-4 mt-4">
                            <h4 class="text-sm font-medium text-gray-500 mb-2">Medications Prescribed</h4>
                            <p class="text-gray-700 bg-gray-50 p-3 rounded border border-gray-200">
                                None required at this time.
                            </p>
                        </div>
                        
                        <div class="border-t border-gray-200 pt-4 mt-4">
                            <h4 class="text-sm font-medium text-gray-500 mb-2">Follow-up Instructions</h4>
                            <p class="text-gray-700 bg-gray-50 p-3 rounded border border-gray-200">
                                No follow-up required. Return if symptoms reappear.
                            </p>
                        </div>
                        
                        <div class="border-t border-gray-200 pt-4 mt-4">
                            <h4 class="text-sm font-medium text-gray-500 mb-2">Healthcare Provider</h4>
                            <div class="flex items-center">
                                <div class="h-8 w-8 bg-blue-100 rounded-full flex items-center justify-center mr-2">
                                    <i class="fas fa-user-md text-blue-600"></i>
                                </div>
                                <p class="text-gray-700">Dr. Sarah Johnson</p>
                            </div>
                        </div>
                    `;
                }
            });
        });
    </script>
</body>
</html> 