<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
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
    
    // Get patients with diagnoses data
    @SuppressWarnings("unchecked")
    List<Map<String, Object>> patientsWithDiagnoses = 
        (List<Map<String, Object>>) request.getAttribute("patientsWithDiagnoses");
    
    // Date formatter
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
    
    // Status colors
    Map<String, String> statusColors = new HashMap<>();
    statusColors.put("Positive", "bg-green-100 text-green-800 border-green-200");
    statusColors.put("Negative", "bg-red-100 text-red-800 border-red-200");
    statusColors.put("Action Required", "bg-yellow-100 text-yellow-800 border-yellow-200");
    statusColors.put("Referrable", "bg-blue-100 text-blue-800 border-blue-200");
    statusColors.put("Not Referable", "bg-purple-100 text-purple-800 border-purple-200");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Results | MBC Hospital</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .gradient-bg {
            background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 100%);
        }
        .sidebar-link {
            transition: all 0.2s ease;
        }
        .sidebar-link:hover {
            padding-left: 1.5rem;
        }
        .sidebar-link.active {
            background-color: rgba(255, 255, 255, 0.1);
            border-right: 3px solid white;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in {
            animation: fadeIn 0.6s ease forwards;
        }
        .patient-card {
            transition: all 0.3s ease;
        }
        .patient-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen flex">
    <!-- Sidebar -->
    <aside class="fixed h-screen w-64 gradient-bg text-white hidden lg:block shadow-xl">
        <div class="p-6">
            <div class="flex items-center space-x-2">
                <i class="fas fa-hospital text-3xl"></i>
                <h1 class="text-2xl font-bold">MBC Hospital</h1>
            </div>
            <p class="text-blue-200 text-sm mt-1">Administration Portal</p>
        </div>
        
        <div class="mt-2">
            <div class="px-6 py-4 border-t border-b border-blue-900/30">
                <div class="flex items-center space-x-4">
                    <div class="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center">
                        <i class="fas fa-user-shield text-xl"></i>
                    </div>
                    <div>
                        <p class="text-sm text-blue-100">Welcome,</p>
                        <p class="font-semibold"><%= session.getAttribute("username") %></p>
                    </div>
                </div>
            </div>
            
            <nav class="mt-6 px-4">
                <a href="dashboard.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-tachometer-alt w-6"></i>
                    <span>Dashboard</span>
                </a>
                <a href="users-directory" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-users w-6"></i>
                    <span>User directory</span>
                </a>
                <a href="patients" class="sidebar-link active flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-clipboard-list w-6"></i>
                    <span>Patient Results</span>
                </a>
                <a href="logout.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mt-8 bg-red-500/20 hover:bg-red-500/30">
                    <i class="fas fa-sign-out-alt w-6"></i>
                    <span>Logout</span>
                </a>
            </nav>
        </div>
    </aside>

    <!-- Main Content -->
    <div class="flex-1 lg:ml-64">
        <!-- Top Navigation -->
        <header class="bg-white shadow-md py-4 px-6 flex justify-between items-center sticky top-0 z-10">
            <div class="flex items-center lg:hidden">
                <button id="menu-toggle" class="text-gray-600 hover:text-gray-800">
                    <i class="fas fa-bars text-xl"></i>
                </button>
                <h1 class="text-xl font-bold text-gray-800 ml-4">Patient Results</h1>
            </div>
            
            <div class="hidden lg:block">
                <h1 class="text-xl font-bold text-gray-800">Patient Results</h1>
            </div>
            
            <div class="flex items-center space-x-4">
                <div class="relative">
                    <a href="dashboard.jsp" class="text-blue-600 hover:text-blue-800">
                        <i class="fas fa-arrow-left mr-2"></i>Back to Dashboard
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content Area -->
        <main class="p-6 pb-16">
            <!-- Header Section -->
            <div class="bg-white rounded-xl shadow-md p-6 mb-6 animate-fade-in">
                <h2 class="text-xl font-bold text-gray-800">Patient Results Dashboard</h2>
                <p class="text-gray-600 mt-1">View all patients and their diagnosis results (read-only)</p>
                
                <div class="mt-4 bg-blue-50 p-4 rounded-lg border border-blue-100">
                    <div class="flex flex-col md:flex-row items-center">
                        <div class="bg-blue-500 rounded-full p-3 text-white mb-3 md:mb-0 md:mr-4">
                            <i class="fas fa-info-circle text-xl"></i>
                        </div>
                        <div>
                            <h4 class="font-medium text-blue-800">Information</h4>
                            <p class="text-blue-600 text-sm">This dashboard provides a read-only view of all patient diagnosis results. You can expand each patient card to see their full diagnosis history.</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Filter Section -->
            <div class="bg-white rounded-xl shadow-md p-4 mb-6 animate-fade-in">
                <div class="flex flex-wrap items-center gap-4">
                    <div class="flex-1">
                        <label for="search" class="block text-sm font-medium text-gray-700 mb-1">Search Patients</label>
                        <div class="relative">
                            <input type="text" id="search" placeholder="Search by name, email or ID..." 
                                   class="w-full px-4 py-2 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none text-gray-400">
                                <i class="fas fa-search"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="w-full md:w-auto">
                        <label for="status-filter" class="block text-sm font-medium text-gray-700 mb-1">Filter by Status</label>
                        <select id="status-filter" 
                                class="w-full md:w-48 px-4 py-2 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                            <option value="all">All Statuses</option>
                            <option value="Positive">Positive</option>
                            <option value="Negative">Negative</option>
                            <option value="Action Required">Action Required</option>
                            <option value="Referrable">Referrable</option>
                            <option value="Not Referable">Not Referable</option>
                        </select>
                    </div>
                    
                    <div class="w-full md:w-auto">
                        <label for="provider-filter" class="block text-sm font-medium text-gray-700 mb-1">Filter by Provider</label>
                        <select id="provider-filter" 
                                class="w-full md:w-48 px-4 py-2 rounded-lg border border-gray-300 focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                            <option value="all">All Providers</option>
                            <option value="doctor">Doctor</option>
                            <option value="nurse">Nurse</option>
                        </select>
                    </div>
                </div>
            </div>
            
            <!-- Patients List -->
            <div id="patients-container" class="space-y-6 animate-fade-in" style="animation-delay: 0.2s">
                <% if (patientsWithDiagnoses != null && !patientsWithDiagnoses.isEmpty()) { 
                    for (Map<String, Object> patient : patientsWithDiagnoses) { 
                        // Get diagnoses for this patient
                        @SuppressWarnings("unchecked")
                        List<Map<String, Object>> diagnoses = (List<Map<String, Object>>) patient.get("diagnoses");
                %>
                    <div class="patient-card" data-patient-id="<%= patient.get("patientId") %>">
                        <div class="bg-white rounded-xl shadow-md overflow-hidden">
                            <!-- Patient Header (always visible) -->
                            <div class="p-6 flex flex-col md:flex-row md:items-center md:justify-between cursor-pointer" onclick="toggleDiagnoses('<%= patient.get("patientId") %>')">
                                <div class="flex items-center">
                                    <div class="h-12 w-12 rounded-full bg-blue-100 flex items-center justify-center mr-4">
                                        <i class="fas fa-user text-blue-500 text-xl"></i>
                                    </div>
                                    <div>
                                        <h3 class="text-lg font-semibold text-gray-800"><%= patient.get("firstName") %> <%= patient.get("lastName") %></h3>
                                        <div class="flex flex-col sm:flex-row sm:space-x-4 text-sm text-gray-500 mt-1">
                                            <span class="flex items-center"><i class="fas fa-id-card mr-1 text-gray-400"></i> ID: <%= patient.get("patientId") %></span>
                                            <span class="flex items-center"><i class="fas fa-envelope mr-1 text-gray-400"></i> <%= patient.get("email") %></span>
                                            <span class="flex items-center"><i class="fas fa-phone mr-1 text-gray-400"></i> <%= patient.get("telephone") %></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="flex items-center mt-4 md:mt-0">
                                    <% if (diagnoses != null && !diagnoses.isEmpty()) { %>
                                        <div class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm font-medium">
                                            <%= diagnoses.size() %> diagnosis<%= diagnoses.size() > 1 ? "es" : "" %>
                                        </div>
                                    <% } else { %>
                                        <div class="bg-gray-100 text-gray-600 px-3 py-1 rounded-full text-sm font-medium">
                                            No diagnoses
                                        </div>
                                    <% } %>
                                    <i class="fas fa-chevron-down ml-4 text-gray-400 transition-transform duration-300" id="icon-<%= patient.get("patientId") %>"></i>
                                </div>
                            </div>
                            
                            <!-- Diagnoses Section (expandable) -->
                            <div class="diagnoses-section hidden bg-gray-50 border-t border-gray-200" id="diagnoses-<%= patient.get("patientId") %>">
                                <% if (diagnoses != null && !diagnoses.isEmpty()) { %>
                                    <div class="p-5 space-y-4">
                                        <h4 class="text-lg font-semibold text-gray-700 mb-2">Diagnosis History</h4>
                                        
                                        <% for (Map<String, Object> diagnosis : diagnoses) { 
                                            String status = (String) diagnosis.get("status");
                                            String statusClass = statusColors.getOrDefault(status, "bg-gray-100 text-gray-800 border-gray-200");
                                        %>
                                            <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
                                                <div class="p-4 border-b border-gray-100">
                                                    <div class="flex flex-wrap justify-between items-center">
                                                        <div>
                                                            <span class="px-3 py-1 rounded-full text-xs font-medium <%= statusClass %>">
                                                                <%= status %>
                                                            </span>
                                                            <span class="ml-2 text-sm text-gray-500">
                                                                <i class="far fa-clock mr-1"></i>
                                                                <%= diagnosis.get("date") != null ? dateFormat.format(diagnosis.get("date")) : "N/A" %>
                                                            </span>
                                                        </div>
                                                        <div class="mt-2 sm:mt-0">
                                                            <span class="text-sm text-gray-500">
                                                                <% if (diagnosis.get("doctorName") != null) { %>
                                                                    <i class="fas fa-user-md mr-1 text-blue-500"></i> Dr. <%= diagnosis.get("doctorName") %>
                                                                <% } %>
                                                                <% if (diagnosis.get("nurseName") != null) { %>
                                                                    <i class="fas fa-user-nurse mx-1 text-purple-500"></i> <%= diagnosis.get("nurseName") %>
                                                                <% } %>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <div class="p-4 grid grid-cols-1 md:grid-cols-2 gap-4">
                                                    <div>
                                                        <h5 class="text-sm font-semibold text-gray-700 mb-1">Result</h5>
                                                        <p class="text-sm bg-gray-50 p-3 rounded-lg border border-gray-100"><%= diagnosis.get("result") != null ? diagnosis.get("result") : "Pending" %></p>
                                                    </div>
                                                    
                                                    <div>
                                                        <h5 class="text-sm font-semibold text-gray-700 mb-1">Medications</h5>
                                                        <p class="text-sm bg-gray-50 p-3 rounded-lg border border-gray-100"><%= diagnosis.get("medications") != null ? diagnosis.get("medications") : "None prescribed" %></p>
                                                    </div>
                                                    
                                                    <div class="md:col-span-2">
                                                        <h5 class="text-sm font-semibold text-gray-700 mb-1">Nurse Assessment</h5>
                                                        <p class="text-sm bg-gray-50 p-3 rounded-lg border border-gray-100"><%= diagnosis.get("nurseAssessment") != null ? diagnosis.get("nurseAssessment") : "No assessment provided" %></p>
                                                    </div>
                                                </div>
                                            </div>
                                        <% } %>
                                    </div>
                                <% } else { %>
                                    <div class="p-8 text-center">
                                        <div class="inline-block bg-gray-100 rounded-full p-3 mb-4">
                                            <i class="fas fa-file-medical text-gray-400 text-xl"></i>
                                        </div>
                                        <p class="text-gray-500">No diagnosis records found for this patient.</p>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } 
                } else { %>
                    <div class="bg-white rounded-xl shadow-md p-12 text-center animate-fade-in">
                        <div class="inline-block bg-blue-100 rounded-full p-5 mb-4">
                            <i class="fas fa-file-medical-alt text-blue-500 text-3xl"></i>
                        </div>
                        <h3 class="text-xl font-semibold text-gray-800 mb-2">No Patient Records Found</h3>
                        <p class="text-gray-600 max-w-md mx-auto">There are no patient records in the system or an error occurred while retrieving the data.</p>
                        <a href="dashboard.jsp" class="mt-6 inline-block px-5 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
                            Return to Dashboard
                        </a>
                    </div>
                <% } %>
            </div>
        </main>
    </div>
    
    <!-- Mobile Menu (hidden by default) -->
    <div id="mobile-menu" class="fixed inset-0 z-20 transform -translate-x-full transition-transform duration-300 ease-in-out bg-gray-900 bg-opacity-50">
        <div class="bg-gradient-to-b from-blue-800 to-blue-900 text-white h-full w-64 shadow-lg">
            <div class="p-6 flex justify-between items-center">
                <div class="flex items-center space-x-2">
                    <i class="fas fa-hospital text-2xl"></i>
                    <span class="text-xl font-bold">MBC Hospital</span>
                </div>
                <button id="close-menu" class="text-white">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>
            
            <div class="mt-2">
                <div class="px-6 py-4 border-t border-b border-blue-900/30">
                    <div class="flex items-center space-x-4">
                        <div class="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center">
                            <i class="fas fa-user-shield text-xl"></i>
                        </div>
                        <div>
                            <p class="text-sm text-blue-100">Welcome,</p>
                            <p class="font-semibold"><%= session.getAttribute("username") %></p>
                        </div>
                    </div>
                </div>
                
                <nav class="mt-6 px-4">
                    <a href="dashboard.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                        <i class="fas fa-tachometer-alt w-6"></i>
                        <span>Dashboard</span>
                    </a>
                    <a href="users-directory" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                        <i class="fas fa-users w-6"></i>
                        <span>User directory</span>
                    </a>
                    <a href="patients" class="sidebar-link active flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                        <i class="fas fa-clipboard-list w-6"></i>
                        <span>Patient Results</span>
                    </a>
                    <a href="logout.jsp" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mt-8 bg-red-500/20 hover:bg-red-500/30">
                        <i class="fas fa-sign-out-alt w-6"></i>
                        <span>Logout</span>
                    </a>
                </nav>
            </div>
        </div>
    </div>

    <script>
        // Mobile menu toggle
        document.addEventListener('DOMContentLoaded', function() {
            const menuToggle = document.getElementById('menu-toggle');
            const closeMenu = document.getElementById('close-menu');
            const mobileMenu = document.getElementById('mobile-menu');
            
            if (menuToggle && mobileMenu && closeMenu) {
                menuToggle.addEventListener('click', function() {
                    mobileMenu.classList.remove('-translate-x-full');
                });
                
                closeMenu.addEventListener('click', function() {
                    mobileMenu.classList.add('-translate-x-full');
                });
            }
            
            // Setup search functionality
            setupSearch();
            
            // Setup status filter
            setupStatusFilter();
            
            // Setup provider filter
            setupProviderFilter();
        });
        
        // Toggle diagnoses section
        function toggleDiagnoses(patientId) {
            const diagnosesSection = document.getElementById('diagnoses-' + patientId);
            const icon = document.getElementById('icon-' + patientId);
            
            if (diagnosesSection.classList.contains('hidden')) {
                diagnosesSection.classList.remove('hidden');
                icon.classList.add('transform', 'rotate-180');
            } else {
                diagnosesSection.classList.add('hidden');
                icon.classList.remove('transform', 'rotate-180');
            }
        }
        
        // Setup search functionality
        function setupSearch() {
            const searchInput = document.getElementById('search');
            if (!searchInput) return;
            
            searchInput.addEventListener('input', function() {
                applyFilters();
            });
        }
        
        // Setup status filter
        function setupStatusFilter() {
            const statusFilter = document.getElementById('status-filter');
            if (!statusFilter) return;
            
            statusFilter.addEventListener('change', function() {
                applyFilters();
            });
        }
        
        // Setup provider filter
        function setupProviderFilter() {
            const providerFilter = document.getElementById('provider-filter');
            if (!providerFilter) return;
            
            providerFilter.addEventListener('change', function() {
                applyFilters();
            });
        }
        
        // Apply all filters together
        function applyFilters() {
            const statusFilter = document.getElementById('status-filter');
            const providerFilter = document.getElementById('provider-filter');
            const searchInput = document.getElementById('search');
            
            const selectedStatus = statusFilter.value;
            const selectedProvider = providerFilter.value;
            const searchQuery = searchInput.value.toLowerCase();
            
            const patientCards = document.querySelectorAll('.patient-card');
            
            // If all filters are set to default, show all cards and return
            if (selectedStatus === 'all' && selectedProvider === 'all' && searchQuery === '') {
                patientCards.forEach(card => {
                    card.style.display = '';
                    // Collapse all diagnosis sections
                    const patientId = card.dataset.patientId;
                    const diagnosesSection = document.getElementById('diagnoses-' + patientId);
                    const icon = document.getElementById('icon-' + patientId);
                    
                    if (diagnosesSection && !diagnosesSection.classList.contains('hidden')) {
                        diagnosesSection.classList.add('hidden');
                        icon.classList.remove('transform', 'rotate-180');
                    }
                });
                return;
            }
            
            // Open all diagnosis sections when filtering for better visibility
            if (selectedStatus !== 'all' || selectedProvider !== 'all') {
                patientCards.forEach(card => {
                    const patientId = card.dataset.patientId;
                    const diagnosesSection = document.getElementById('diagnoses-' + patientId);
                    const icon = document.getElementById('icon-' + patientId);
                    
                    if (diagnosesSection && diagnosesSection.classList.contains('hidden')) {
                        diagnosesSection.classList.remove('hidden');
                        icon.classList.add('transform', 'rotate-180');
                    }
                });
            }
            
            // Apply all filters
            patientCards.forEach(card => {
                const patientId = card.dataset.patientId;
                const diagnosesSection = document.getElementById('diagnoses-' + patientId);
                const patientInfo = card.textContent.toLowerCase();
                
                let shouldShow = true;
                
                // Apply search filter
                if (searchQuery !== '' && !patientInfo.includes(searchQuery)) {
                    shouldShow = false;
                }
                
                // Apply status filter
                if (selectedStatus !== 'all' && diagnosesSection) {
                    const hasMatchingStatus = diagnosesSection.textContent.includes(selectedStatus);
                    if (!hasMatchingStatus) {
                        shouldShow = false;
                    }
                }
                
                // Apply provider filter
                if (selectedProvider !== 'all' && diagnosesSection) {
                    let hasMatchingProvider = false;
                    
                    // Check for doctor or nurse in diagnoses
                    if (selectedProvider === 'doctor') {
                        hasMatchingProvider = diagnosesSection.querySelector('.fa-user-md') !== null;
                    } else if (selectedProvider === 'nurse') {
                        hasMatchingProvider = diagnosesSection.querySelector('.fa-user-nurse') !== null;
                    }
                    
                    if (!hasMatchingProvider) {
                        shouldShow = false;
                    }
                }
                
                card.style.display = shouldShow ? '' : 'none';
            });
        }
    </script>
</body>
</html> 