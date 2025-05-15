<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Patient, com.mbc_hospital.model.Diagnosis" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // Validate user session
    String usertype = (String) session.getAttribute("usertype");
    if (usertype == null || !usertype.equalsIgnoreCase("patient")) {
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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .sidebar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .content-area {
            background-color: #f9fafb;
        }
        .card {
            background-color: white;
            border-radius: 0.5rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .diagnosis-card {
            cursor: pointer;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 50;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.5);
        }
        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 20px;
            border-radius: 0.5rem;
            width: 80%;
            max-width: 700px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .close-modal {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close-modal:hover {
            color: black;
        }
        .status-pending {
            background-color: #fef3c7;
            color: #92400e;
        }
        .status-in-progress {
            background-color: #e0f2fe;
            color: #0369a1;
        }
        .status-completed {
            background-color: #dcfce7;
            color: #166534;
        }
        .status-referred {
            background-color: #f3e8ff;
            color: #6b21a8;
        }
    </style>
</head>
<body class="flex h-screen bg-gray-100">
    <!-- Sidebar -->
    <div class="sidebar w-64 h-full text-white flex flex-col">
        <div class="p-4 flex items-center justify-center border-b border-blue-800">
            <i class="fas fa-hospital text-3xl mr-2"></i>
            <h1 class="text-xl font-bold">MBC Hospital</h1>
        </div>
        
        <!-- User Profile -->
        <div class="p-4 flex flex-col items-center border-b border-blue-800">
            <div class="w-20 h-20 rounded-full bg-white flex items-center justify-center mb-2">
                <i class="fas fa-user text-4xl text-blue-600"></i>
            </div>
            <h2 class="text-lg font-semibold"><%= patient.getFirstName() + " " + patient.getLastName() %></h2>
            <p class="text-sm opacity-75">Patient ID: <%= patient.getPatientID() %></p>
        </div>
        
        <!-- Navigation -->
        <nav class="flex-1 p-4">
            <ul>
                <li class="mb-2">
                    <a href="#" class="flex items-center p-2 rounded bg-white bg-opacity-20">
                        <i class="fas fa-home w-5 h-5 mr-3"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="mb-2">
                    <a href="#diagnoses" class="flex items-center p-2 rounded hover:bg-white hover:bg-opacity-10">
                        <i class="fas fa-file-medical w-5 h-5 mr-3"></i>
                        <span>My Diagnoses</span>
                    </a>
                </li>
                <li class="mb-2">
                    <a href="#profile" class="flex items-center p-2 rounded hover:bg-white hover:bg-opacity-10">
                        <i class="fas fa-user-circle w-5 h-5 mr-3"></i>
                        <span>My Profile</span>
                    </a>
                </li>
            </ul>
        </nav>
        
        <!-- Logout Button -->
        <div class="p-4 border-t border-blue-800">
            <a href="patient-logout" class="flex items-center p-2 rounded hover:bg-white hover:bg-opacity-10">
                <i class="fas fa-sign-out-alt w-5 h-5 mr-3"></i>
                <span>Logout</span>
            </a>
        </div>
    </div>

    <!-- Main Content Area -->
    <div class="content-area flex-1 overflow-y-auto">
        <header class="bg-white shadow">
            <div class="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8 flex justify-between items-center">
                <h1 class="text-2xl font-bold text-gray-900">Patient Dashboard</h1>
                <div class="flex items-center">
                    <span class="mr-2 text-gray-600"><%= new java.text.SimpleDateFormat("EEEE, MMMM d, yyyy").format(new java.util.Date()) %></span>
                </div>
            </div>
        </header>
        
        <main class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
            <!-- Welcome Card -->
            <div class="card p-6 mb-6">
                <h2 class="text-xl font-semibold text-gray-800 mb-2">Welcome, <%= patient.getFirstName() %>!</h2>
                <p class="text-gray-600">Here you can view your diagnosis history and personal information.</p>
            </div>
            
            <!-- Dashboard Summary -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                <div class="card p-6">
                    <div class="flex items-center">
                        <div class="p-3 rounded-full bg-blue-100 text-blue-600 mr-4">
                            <i class="fas fa-file-medical text-xl"></i>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Total Diagnoses</p>
                            <h3 class="text-xl font-bold text-gray-800"><%= patientDiagnoses != null ? patientDiagnoses.size() : 0 %></h3>
                        </div>
                    </div>
                </div>
                
                <div class="card p-6">
                    <div class="flex items-center">
                        <div class="p-3 rounded-full bg-green-100 text-green-600 mr-4">
                            <i class="fas fa-calendar-check text-xl"></i>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Last Visit</p>
                            <h3 class="text-xl font-bold text-gray-800">
                                <%= patientDiagnoses != null && !patientDiagnoses.isEmpty() ? 
                                    new java.text.SimpleDateFormat("MMM d, yyyy").format(patientDiagnoses.get(0).getDiagnosisDate()) : 
                                    "No visits" %>
                            </h3>
                        </div>
                    </div>
                </div>
                
                <div class="card p-6">
                    <div class="flex items-center">
                        <div class="p-3 rounded-full bg-purple-100 text-purple-600 mr-4">
                            <i class="fas fa-user-md text-xl"></i>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Registration Date</p>
                            <h3 class="text-xl font-bold text-gray-800"><%= patient.getRegistrationDate() != null ? patient.getRegistrationDate().substring(0, 10) : "N/A" %></h3>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Diagnoses Section -->
            <div id="diagnoses" class="mb-6">
                <h2 class="text-xl font-semibold text-gray-800 mb-4">My Diagnoses</h2>
                
                <% if (patientDiagnoses == null || patientDiagnoses.isEmpty()) { %>
                    <div class="card p-6 text-center">
                        <i class="fas fa-file-medical text-4xl text-gray-300 mb-2"></i>
                        <p class="text-gray-500">No diagnoses found in your record.</p>
                    </div>
                <% } else { %>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <% for (Diagnosis diagnosis : patientDiagnoses) { %>
                            <div class="card diagnosis-card p-4" onclick="viewDiagnosis(<%= diagnosis.getDiagnosisId() %>)">
                                <div class="flex justify-between items-start mb-2">
                                    <div>
                                        <h3 class="font-semibold text-gray-800">Diagnosis #<%= diagnosis.getDiagnosisId() %></h3>
                                        <p class="text-sm text-gray-500"><%= new java.text.SimpleDateFormat("MMM d, yyyy").format(diagnosis.getDiagnosisDate()) %></p>
                                    </div>
                                    <span class="px-2 py-1 text-xs rounded-full <%= 
                                        diagnosis.getStatus().equalsIgnoreCase("pending") ? "status-pending" : 
                                        diagnosis.getStatus().equalsIgnoreCase("in progress") ? "status-in-progress" : 
                                        diagnosis.getStatus().equalsIgnoreCase("completed") ? "status-completed" : 
                                        diagnosis.getStatus().equalsIgnoreCase("referred") ? "status-referred" : "" 
                                    %>">
                                        <%= diagnosis.getStatus() %>
                                    </span>
                                </div>
                                <div class="text-gray-600 text-sm line-clamp-2">
                                    <%= diagnosis.getResult() != null && !diagnosis.getResult().isEmpty() ? diagnosis.getResult() : "No result available yet" %>
                                </div>
                                <div class="mt-2 text-right">
                                    <span class="text-blue-600 text-sm">View Details <i class="fas fa-chevron-right ml-1"></i></span>
                                </div>
                            </div>
                        <% } %>
                    </div>
                <% } %>
            </div>
            
            <!-- Profile Section -->
            <div id="profile" class="mb-6">
                <h2 class="text-xl font-semibold text-gray-800 mb-4">My Profile</h2>
                <div class="card p-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <h3 class="text-sm font-medium text-gray-500">Full Name</h3>
                            <p class="text-gray-800"><%= patient.getFirstName() + " " + patient.getLastName() %></p>
                        </div>
                        <div>
                            <h3 class="text-sm font-medium text-gray-500">Patient ID</h3>
                            <p class="text-gray-800"><%= patient.getPatientID() %></p>
                        </div>
                        <div>
                            <h3 class="text-sm font-medium text-gray-500">Phone Number</h3>
                            <p class="text-gray-800"><%= patient.getTelephone() != null ? patient.getTelephone() : "Not provided" %></p>
                        </div>
                        <div>
                            <h3 class="text-sm font-medium text-gray-500">Email</h3>
                            <p class="text-gray-800"><%= patient.getEmail() != null ? patient.getEmail() : "Not provided" %></p>
                        </div>
                        <div>
                            <h3 class="text-sm font-medium text-gray-500">Address</h3>
                            <p class="text-gray-800"><%= patient.getAddress() != null ? patient.getAddress() : "Not provided" %></p>
                        </div>
                        <div>
                            <h3 class="text-sm font-medium text-gray-500">Registration Date</h3>
                            <p class="text-gray-800"><%= patient.getRegistrationDate() != null ? patient.getRegistrationDate().substring(0, 10) : "N/A" %></p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <!-- Diagnosis Details Modal -->
    <div id="diagnosisModal" class="modal">
        <div class="modal-content">
            <span class="close-modal">&times;</span>
            <h2 class="text-2xl font-bold text-gray-800 mb-4">Diagnosis Details</h2>
            <div id="diagnosisDetails" class="space-y-4">
                <div class="text-center p-8">
                    <i class="fas fa-spinner fa-spin text-blue-600 text-3xl"></i>
                    <p class="mt-2 text-gray-600">Loading diagnosis details...</p>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Function to view diagnosis details
        function viewDiagnosis(diagnosisId) {
            // Show the modal
            document.getElementById('diagnosisModal').style.display = 'block';
            
            // Fetch diagnosis details
            fetch('patient-view-diagnosis?diagnosisId=' + diagnosisId)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    // Format the diagnosis date
                    const diagnosisDate = new Date(data.diagnosisDate);
                    const formattedDate = diagnosisDate.toLocaleDateString('en-US', {
                        year: 'numeric',
                        month: 'long',
                        day: 'numeric'
                    });
                    
                    // Format follow-up date if available
                    let followUpText = 'No follow-up scheduled';
                    if (data.followUpDate) {
                        const followUpDate = new Date(data.followUpDate);
                        followUpText = followUpDate.toLocaleDateString('en-US', {
                            year: 'numeric',
                            month: 'long',
                            day: 'numeric'
                        });
                    }
                    
                    // Build the HTML for diagnosis details
                    let html = `
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                            <div>
                                <h3 class="text-sm font-medium text-gray-500">Diagnosis ID</h3>
                                <p class="text-gray-800">${data.diagnosisId}</p>
                            </div>
                            <div>
                                <h3 class="text-sm font-medium text-gray-500">Date</h3>
                                <p class="text-gray-800">${formattedDate}</p>
                            </div>
                            <div>
                                <h3 class="text-sm font-medium text-gray-500">Status</h3>
                                <p class="text-gray-800">${data.status}</p>
                            </div>
                            <div>
                                <h3 class="text-sm font-medium text-gray-500">Follow-up Date</h3>
                                <p class="text-gray-800">${followUpText}</p>
                            </div>
                        </div>
                        
                        <div class="mb-4">
                            <h3 class="text-sm font-medium text-gray-500">Nurse Assessment</h3>
                            <p class="text-gray-800 p-3 bg-gray-50 rounded">${data.nurseAssessment || 'No assessment provided'}</p>
                        </div>
                        
                        <div class="mb-4">
                            <h3 class="text-sm font-medium text-gray-500">Diagnosis Result</h3>
                            <p class="text-gray-800 p-3 bg-gray-50 rounded">${data.result || 'No result available yet'}</p>
                        </div>
                        
                        <div class="mb-4">
                            <h3 class="text-sm font-medium text-gray-500">Medications Prescribed</h3>
                            <p class="text-gray-800 p-3 bg-gray-50 rounded">${data.medicationsPrescribed || 'No medications prescribed'}</p>
                        </div>
                        
                        <div class="mt-6 text-right">
                            <button onclick="printDiagnosis()" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
                                <i class="fas fa-print mr-2"></i> Print
                            </button>
                        </div>
                    `;
                    
                    document.getElementById('diagnosisDetails').innerHTML = html;
                })
                .catch(error => {
                    document.getElementById('diagnosisDetails').innerHTML = `
                        <div class="text-center p-8">
                            <i class="fas fa-exclamation-circle text-red-600 text-3xl"></i>
                            <p class="mt-2 text-gray-600">Error loading diagnosis details. Please try again.</p>
                        </div>
                    `;
                    console.error('Error fetching diagnosis details:', error);
                });
        }
        
        // Close the modal when clicking the X
        document.querySelector('.close-modal').addEventListener('click', function() {
            document.getElementById('diagnosisModal').style.display = 'none';
        });
        
        // Close the modal when clicking outside of it
        window.addEventListener('click', function(event) {
            if (event.target == document.getElementById('diagnosisModal')) {
                document.getElementById('diagnosisModal').style.display = 'none';
            }
        });
        
        // Function to print diagnosis
        function printDiagnosis() {
            const printContents = document.getElementById('diagnosisDetails').innerHTML;
            const originalContents = document.body.innerHTML;
            
            document.body.innerHTML = `
                <div style="padding: 20px;">
                    <h1 style="text-align: center; margin-bottom: 20px;">MBC Hospital - Diagnosis Report</h1>
                    ${printContents}
                </div>
            `;
            
            window.print();
            document.body.innerHTML = originalContents;
            
            // Reattach event listeners after restoring content
            document.querySelector('.close-modal').addEventListener('click', function() {
                document.getElementById('diagnosisModal').style.display = 'none';
            });
        }
    </script>
</body>
</html> 