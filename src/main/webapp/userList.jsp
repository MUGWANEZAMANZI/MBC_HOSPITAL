<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.User" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userType = (String) session.getAttribute("usertype");
    if (userType == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if ("doctor".equalsIgnoreCase(userType)) {
        response.sendRedirect("doctor.jsp");
        return;
    } else if ("nurse".equalsIgnoreCase(userType)) {
        response.sendRedirect("nurse.jsp");
        return;
    } else if ("patient".equalsIgnoreCase(userType)) {
        response.sendRedirect("patient.jsp");
        return;
    }

%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MBC Hospital - User Directory</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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

        .glass-effect {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }
        
        .table-row-hover:hover {
            transform: scale(1.005);
            transition: all 0.2s ease;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .animate-fade-in {
            animation: fadeIn 0.6s ease forwards;
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
                <a href="users-directory" class="sidebar-link active flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                    <i class="fas fa-users w-6"></i>
                    <span>User directory</span>
                </a>
                <a href="patients" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
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
                <h1 class="text-xl font-bold text-gray-800 ml-4">User Directory</h1>
            </div>
            
            <div class="hidden lg:block">
                <h1 class="text-xl font-bold text-gray-800">User Directory</h1>
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
            <!-- Page Title -->
            <div class="bg-white rounded-xl shadow-md p-6 mb-6 animate-fade-in">
                <div class="flex items-center">
                    <div class="bg-blue-500 rounded-full p-3 text-white mr-4">
                        <i class="fas fa-users text-xl"></i>
                    </div>
                    <div>
                        <h2 class="text-xl font-bold text-gray-800">User Directory</h2>
                        <p class="text-gray-600 mt-1">Manage and view all users in the system</p>
                    </div>
                </div>
            </div>
                
            <!-- Stats Card -->
            <%
                List<User> users = (List<User>) request.getAttribute("userList");
            %>
            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                <div class="bg-white rounded-xl shadow-md p-6 border border-gray-100 transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                    <div class="flex justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Total Users</p>
                            <h3 class="text-3xl font-bold text-gray-800 mt-1"><%= (users != null) ? users.size() : 0 %></h3>
                        </div>
                        <div class="h-12 w-12 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                            <i class="fas fa-users text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <div class="w-full h-1 bg-gray-200 rounded-full mt-2">
                            <div class="h-1 bg-blue-500 rounded-full" style="width: 100%"></div>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-xl shadow-md p-6 border border-gray-100 transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                    <div class="flex justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Doctors</p>
                            <h3 class="text-3xl font-bold text-blue-600 mt-1">
                                <%
                                    int doctorCount = 0;
                                    if (users != null) {
                                        for (User user : users) {
                                            if (user.getUserType().equalsIgnoreCase("doctor")) {
                                                doctorCount++;
                                            }
                                        }
                                    }
                                %>
                                <%= doctorCount %>
                            </h3>
                        </div>
                        <div class="h-12 w-12 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                            <i class="fas fa-user-md text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <div class="w-full h-1 bg-gray-200 rounded-full mt-2">
                            <div class="h-1 bg-blue-500 rounded-full" style="width: <%= users != null && users.size() > 0 ? (doctorCount * 100 / users.size()) : 0 %>%"></div>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-xl shadow-md p-6 border border-gray-100 transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                    <div class="flex justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Nurses</p>
                            <h3 class="text-3xl font-bold text-purple-600 mt-1">
                                <%
                                    int nurseCount = 0;
                                    if (users != null) {
                                        for (User user : users) {
                                            if (user.getUserType().equalsIgnoreCase("nurse")) {
                                                nurseCount++;
                                            }
                                        }
                                    }
                                %>
                                <%= nurseCount %>
                            </h3>
                        </div>
                        <div class="h-12 w-12 rounded-full bg-purple-100 flex items-center justify-center text-purple-600">
                            <i class="fas fa-user-nurse text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <div class="w-full h-1 bg-gray-200 rounded-full mt-2">
                            <div class="h-1 bg-purple-500 rounded-full" style="width: <%= users != null && users.size() > 0 ? (nurseCount * 100 / users.size()) : 0 %>%"></div>
                        </div>
                    </div>
                </div>
                
                <div class="bg-white rounded-xl shadow-md p-6 border border-gray-100 transition-all duration-300 hover:shadow-lg hover:-translate-y-1">
                    <div class="flex justify-between">
                        <div>
                            <p class="text-sm font-medium text-gray-500">Patients</p>
                            <h3 class="text-3xl font-bold text-green-600 mt-1">
                                <%
                                    int patientCount = 0;
                                    if (users != null) {
                                        for (User user : users) {
                                            if (user.getUserType().equalsIgnoreCase("patient")) {
                                                patientCount++;
                                            }
                                        }
                                    }
                                %>
                                <%= patientCount %>
                            </h3>
                        </div>
                        <div class="h-12 w-12 rounded-full bg-green-100 flex items-center justify-center text-green-600">
                            <i class="fas fa-procedures text-xl"></i>
                        </div>
                    </div>
                    <div class="mt-4">
                        <div class="w-full h-1 bg-gray-200 rounded-full mt-2">
                            <div class="h-1 bg-green-500 rounded-full" style="width: <%= users != null && users.size() > 0 ? (patientCount * 100 / users.size()) : 0 %>%"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Search & Filter -->
            <div class="bg-white p-4 rounded-xl shadow-md mb-6">
                <div class="flex flex-col md:flex-row md:items-center md:justify-between space-y-4 md:space-y-0">
                    <div class="relative w-full md:w-64">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-search text-gray-400"></i>
                        </div>
                        <input type="text" id="search" class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm" placeholder="Search users...">
                    </div>
                </div>
            </div>
            
            <!-- User Table -->
            <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
                    <h3 class="text-lg font-semibold text-gray-800">Users List</h3>
                    <p class="mt-1 text-sm text-gray-500">View and manage user accounts and access permissions</p>
                </div>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    User ID
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Username
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    User Type
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Status
                                </th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                    Actions
                                </th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <%
                                if (users != null) {
                                    for (User user : users) {
                                        String badgeClass = "bg-gray-100 text-gray-800";
                                        if (user.getUserType().equalsIgnoreCase("doctor")) {
                                            badgeClass = "bg-blue-100 text-blue-800";
                                        } else if (user.getUserType().equalsIgnoreCase("nurse")) {
                                            badgeClass = "bg-purple-100 text-purple-800";
                                        } else if (user.getUserType().equalsIgnoreCase("patient")) {
                                            badgeClass = "bg-green-100 text-green-800";
                                        }
                            %>
                            <tr class="hover:bg-gray-50 transition-all duration-150">
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"><%= user.getUserID() %></td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700"><%= user.getUsername() %></td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full <%= badgeClass %>">
                                        <%= user.getUserType() %>
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                   <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full <%= user.isVerified() ? "bg-green-100 text-green-800" : "bg-yellow-100 text-yellow-800" %>">
                                       <%= user.isVerified() ? "Verified" : "Pending" %>
                                   </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                    <div class="flex space-x-2">
                                    <button
                                      onclick="updateStatus(<%= user.getUserID() %>, <%= user.isVerified() %>)"
                                      class="<%= user.isVerified() ? "bg-red-500 hover:bg-red-600" : "bg-green-500 hover:bg-green-600" %> text-white px-3 py-1 rounded text-sm transition duration-150"
                                      >
                                       <%= user.isVerified() ? "Revoke Access" : "Grant Access" %>
                                     </button>
                                     <button
                                       onclick="showUserDetails(<%= user.getUserID() %>, '<%= user.getUsername() %>', '<%= user.getUserType() %>', '<%= user.isVerified() %>', '<%= user.getFirstName() != null ? user.getFirstName() : "" %>', '<%= user.getLastName() != null ? user.getLastName() : "" %>', '<%= user.getTelephone() != null ? user.getTelephone() : "" %>', '<%= user.getEmail() != null ? user.getEmail() : "" %>', '<%= user.getAddress() != null ? user.getAddress() : "" %>', '<%= user.getHospitalName() != null ? user.getHospitalName() : "" %>')"
                                       class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-1 rounded text-sm transition duration-150"
                                      >
                                       View Details
                                     </button>
                                     </div>
                                </td>
                            </tr>
                            <% 
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Empty state for when no users are found -->
                <% if (users == null || users.isEmpty()) { %>
                <div class="py-12 text-center">
                    <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                    </svg>
                    <h3 class="mt-2 text-lg font-medium text-gray-900">No users found</h3>
                    <p class="mt-1 text-sm text-gray-500">There are no users in the system that match your criteria.</p>
                </div>
                <% } %>
                
                <!-- Pagination -->
                <% if (users != null && !users.isEmpty()) { %>
                <div class="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6">
                    <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                        <div>
                            <p class="text-sm text-gray-700">
                                Showing <span class="font-medium">1</span> to <span class="font-medium"><%= users.size() %></span> of <span class="font-medium"><%= users.size() %></span> results
                            </p>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </main>
    </div>
    
    <!-- Mobile Sidebar Menu (hidden by default) -->
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
                    <a href="users-directory" class="sidebar-link active flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
                        <i class="fas fa-users w-6"></i>
                        <span>User directory</span>
                    </a>
                    <a href="patients" class="sidebar-link flex items-center space-x-3 text-white/90 hover:text-white p-3 rounded-lg mb-2">
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

    <!-- User Details Modal -->
    <div id="userDetailsModal" class="fixed inset-0 z-50 overflow-auto bg-black bg-opacity-50 flex items-center justify-center hidden">
        <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4 animate-fade-in">
            <div class="border-b px-6 py-4 flex justify-between items-center">
                <h3 class="text-lg font-semibold text-gray-900">User Details</h3>
                <button onclick="hideUserDetails()" class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="p-6">
                <div class="mb-6 flex justify-center">
                    <div class="w-24 h-24 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                        <i class="fas fa-user text-4xl"></i>
                    </div>
                </div>
                <div class="space-y-4">
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <p class="text-sm font-medium text-gray-500">User ID</p>
                            <p id="modal-userid" class="text-sm text-gray-900"></p>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-500">Username</p>
                            <p id="modal-username" class="text-sm text-gray-900"></p>
                        </div>
                    </div>
                    
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <p class="text-sm font-medium text-gray-500">First Name</p>
                            <p id="modal-firstname" class="text-sm text-gray-900"></p>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-500">Last Name</p>
                            <p id="modal-lastname" class="text-sm text-gray-900"></p>
                        </div>
                    </div>
                    
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <p class="text-sm font-medium text-gray-500">User Type</p>
                            <p id="modal-usertype" class="text-sm text-gray-900"></p>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-500">Status</p>
                            <p id="modal-status" class="text-sm text-gray-900"></p>
                        </div>
                    </div>
                    
                    <div>
                        <p class="text-sm font-medium text-gray-500">Email</p>
                        <p id="modal-email" class="text-sm text-gray-900"></p>
                    </div>
                    
                    <div>
                        <p class="text-sm font-medium text-gray-500">Telephone</p>
                        <p id="modal-telephone" class="text-sm text-gray-900"></p>
                    </div>
                    
                    <div>
                        <p class="text-sm font-medium text-gray-500">Address</p>
                        <p id="modal-address" class="text-sm text-gray-900"></p>
                    </div>
                    
                    <div id="hospital-container">
                        <p class="text-sm font-medium text-gray-500">Hospital Name</p>
                        <p id="modal-hospital" class="text-sm text-gray-900"></p>
                    </div>
                </div>
            </div>
            <div class="bg-gray-50 px-6 py-4 border-t text-right">
                <button onclick="hideUserDetails()" class="bg-gray-300 hover:bg-gray-400 text-gray-800 font-semibold px-4 py-2 rounded text-sm">
                    Close
                </button>
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
            const searchInput = document.getElementById('search');
            if (searchInput) {
                searchInput.addEventListener('input', function(e) {
                    const searchTerm = e.target.value.toLowerCase();
                    const rows = document.querySelectorAll('tbody tr');

                    rows.forEach(row => {
                        const username = row.children[1].textContent.toLowerCase();
                        const userType = row.children[2].textContent.toLowerCase();

                        if (username.includes(searchTerm) || userType.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            }
        });
        
        function updateStatus(userId, isCurrentlyVerified) {
            const action = isCurrentlyVerified ? "reject" : "verify";
            console.log("Sending userId:", userId, "Action:", action);

            fetch("update-verification", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: "userId=" + encodeURIComponent(userId) + "&action=" + encodeURIComponent(action)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert("Status updated successfully.");
                    location.reload(); // Reload page to reflect change
                } else {
                    alert("Failed to update: " + (data.message || data.error));
                }
            })
            .catch(err => {
                alert("Error updating status.");
                console.error(err);
            });
        }
        
        function showUserDetails(userId, username, userType, isVerified, firstName, lastName, telephone, email, address, hospitalName) {
            // Helper function to handle potentially null or empty values
            function displayValue(value) {
                if (value === null || value === undefined || value === 'null' || value === 'undefined' || value === '') {
                    return 'N/A';
                }
                return value;
            }
            
            // Populate modal with user information
            document.getElementById('modal-userid').textContent = displayValue(userId);
            document.getElementById('modal-username').textContent = displayValue(username);
            document.getElementById('modal-usertype').textContent = displayValue(userType);
            document.getElementById('modal-status').textContent = isVerified === 'true' ? 'Verified' : 'Pending';
            document.getElementById('modal-firstname').textContent = displayValue(firstName);
            document.getElementById('modal-lastname').textContent = displayValue(lastName);
            document.getElementById('modal-telephone').textContent = displayValue(telephone);
            document.getElementById('modal-email').textContent = displayValue(email);
            document.getElementById('modal-address').textContent = displayValue(address);
            
            // Show/hide hospital name based on user type
            const hospitalContainer = document.getElementById('hospital-container');
            if (userType === 'Doctor' || userType === 'Nurse') {
                hospitalContainer.style.display = 'block';
                document.getElementById('modal-hospital').textContent = displayValue(hospitalName);
            } else {
                hospitalContainer.style.display = 'none';
            }
            
            // Show the modal
            document.getElementById('userDetailsModal').classList.remove('hidden');
        }
        
        function hideUserDetails() {
            // Hide the modal
            document.getElementById('userDetailsModal').classList.add('hidden');
        }
    </script>
</body>
</html>
