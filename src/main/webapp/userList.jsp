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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#eef2ff',
                            100: '#e0e7ff',
                            200: '#c7d2fe',
                            300: '#a5b4fc',
                            400: '#818cf8',
                            500: '#6366f1',
                            600: '#4f46e5',
                            700: '#4338ca',
                            800: '#3730a3',
                            900: '#312e81',
                        }
                    },
                    fontFamily: {
                        sans: ['Inter', 'sans-serif']
                    },
                    boxShadow: {
                        'card': '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
                        'card-hover': '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)',
                    }
                }
            }
        }
    </script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        
        .glass-effect {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(4px);
            -webkit-backdrop-filter: blur(4px);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }
        
        .gradient-bg {
            background: linear-gradient(135deg, #4f46e5 0%, #2563eb 100%);
        }
        
        .table-row-hover:hover {
            transform: scale(1.005);
            transition: all 0.2s ease;
        }
        
        .pulse-animation {
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(99, 102, 241, 0.7);
            }
            70% {
                box-shadow: 0 0 0 10px rgba(99, 102, 241, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(99, 102, 241, 0);
            }
        }
    </style>
</head>
<body class="min-h-screen bg-gray-50 font-sans text-gray-800">
    <!-- Background pattern -->
    <div class="fixed inset-0 z-0 opacity-5">
        <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">
            <defs>
                <pattern id="pattern" width="40" height="40" patternUnits="userSpaceOnUse">
                    <path d="M0 20 L40 20 M20 0 L20 40" stroke="#4338ca" stroke-width="0.5" />
                </pattern>
            </defs>
            <rect width="100%" height="100%" fill="url(#pattern)" />
        </svg>
    </div>

    <!-- Header -->      
    
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
    
    
    
    
    
<script>
    function updateStatus(userId, isCurrentlyVerified) {
    	console.log(userId,isCurrentlyVerified)
        const action = isCurrentlyVerified ? "reject" : "verify";
    	console.log("Sending userId:", userId, "Action:", action);

        fetch("update-verification", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: `userId=\${encodeURIComponent(userId)}&action=\${encodeURIComponent(action)}`
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                alert("Status updated.");
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

    // Search logic inside DOMContentLoaded (this is fine)
    document.addEventListener('DOMContentLoaded', function() {
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
</script>

</body>
</html>
    <!-- Main Content -->
    <div class="container mx-auto p-6 relative z-10">
        <!-- Page Title -->
        <div class="flex items-center mb-8 pb-4">
            <div class="bg-primary-100 p-3 rounded-full mr-4">
                <svg class="h-6 w-6 text-primary-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
            </div>
            <div>
                <h2 class="text-3xl font-bold text-gray-800 mb-1">User Directory</h2>
                <p class="text-gray-500">Manage and view all users in the system</p>
            </div>
        </div>
                
        <!-- Stats Card -->
        <%
            List<User> users = (List<User>) request.getAttribute("userList");
        %>
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
            <div class="bg-white rounded-xl shadow-card p-6 border border-gray-100 transition-all duration-300 hover:shadow-card-hover transform hover:-translate-y-1">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-500 mb-1">Total Users</p>
                        <h3 class="text-3xl font-bold text-gray-800"><%= (users != null) ? users.size() : 0 %></h3>
                    </div>
                    <div class="bg-primary-100 p-3 rounded-full pulse-animation">
                        <svg class="h-6 w-6 text-primary-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                        </svg>
                    </div>
                </div>
                <div class="mt-4 flex items-center text-xs text-gray-500">
                    <svg class="h-4 w-4 mr-1 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                    </svg>
                    <span>Active accounts</span>
                </div>
            </div>
            
            <div class="bg-white rounded-xl shadow-card p-6 border border-gray-100 transition-all duration-300 hover:shadow-card-hover transform hover:-translate-y-1">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-500 mb-1">Doctors</p>
                        <h3 class="text-3xl font-bold text-blue-600">
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
                    <div class="bg-blue-100 p-3 rounded-full">
                        <svg class="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                    </div>
                </div>
            </div>
            
            <div class="bg-white rounded-xl shadow-card p-6 border border-gray-100 transition-all duration-300 hover:shadow-card-hover transform hover:-translate-y-1">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-500 mb-1">Nurses</p>
                        <h3 class="text-3xl font-bold text-pink-600">
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
                    <div class="bg-pink-100 p-3 rounded-full">
                        <svg class="h-6 w-6 text-pink-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                    </div>
                </div>
            </div>
            
            <div class="bg-white rounded-xl shadow-card p-6 border border-gray-100 transition-all duration-300 hover:shadow-card-hover transform hover:-translate-y-1">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-500 mb-1">Patients</p>
                        <h3 class="text-3xl font-bold text-emerald-600">
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
                    <div class="bg-emerald-100 p-3 rounded-full">
                        <svg class="h-6 w-6 text-emerald-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Search & Filter -->
        <div class="bg-white p-4 rounded-xl shadow-md mb-6">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between space-y-4 md:space-y-0">
                <div class="relative w-full md:w-64">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                        <svg class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                        </svg>
                    </div>
                    <input type="text" id="search" class="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm" placeholder="Search users...">
                </div>
            </div>
        </div>
        
        <!-- User Table -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
                <h3 class="text-lg font-medium text-gray-900">Users List</h3>
                <p class="mt-1 text-sm text-gray-500">View and manage all users in the system</p>
            </div>
            <div class="">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                <div class="flex items-center space-x-1">
                                    <span>User ID</span>
                                    <svg class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 9l4-4 4 4m0 6l-4 4-4-4" />
                                    </svg>
                                </div>
                            </th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                <div class="flex items-center space-x-1">
                                    <span>Username</span>
                                    <svg class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 9l4-4 4 4m0 6l-4 4-4-4" />
                                    </svg>
                                </div>
                            </th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                <div class="flex items-center space-x-1">
                                    <span>User Type</span>
                                    <svg class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 9l4-4 4 4m0 6l-4 4-4-4" />
                                    </svg>
                                </div>
                            </th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                <div class="flex items-center space-x-1">
                                    <span>access-status</span>
                                    <svg class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 9l4-4 4 4m0 6l-4 4-4-4" />
                                    </svg>
                                </div>
                            </th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                <div class="flex items-center space-x-1">
                                    <span>access request</span>
                                    <svg class="h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 9l4-4 4 4m0 6l-4 4-4-4" />
                                    </svg>
                                </div>
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
                                        badgeClass = "bg-pink-100 text-pink-800";
                                    } else if (user.getUserType().equalsIgnoreCase("patient")) {
                                        badgeClass = "bg-emerald-100 text-emerald-800";
                                    }
                        %>
                        <tr class="table-row-hover transition-all duration-150">
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"><%= user.getUserID() %></td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700"><%= user.getUsername() %></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full <%= badgeClass %>">
                                    <%= user.getUserType() %>
                                </span>
                            </td>
                          <td>
                             <button 
                                  onclick="updateStatus(<%= user.getUserID() %>, <%= user.isVerified() %>)"
                                  class="cursor-pointer px-3 py-1 rounded-md text-sm font-medium 
                                  <%= user.isVerified() ? "bg-green-100 text-green-800 hover:bg-green-200" : "bg-yellow-100 text-yellow-800 hover:bg-yellow-200" %>">
                                  <%= user.isVerified() ? "Verified" : "Pending" %>
                              </button>
                          </td>

                           <td>
                           <!-- Assuming user.getUserID() is the user ID and user.isVerified() is the current verification status -->
                          <button
                            onclick="updateStatus(<%= user.getUserID() %>, <%= user.isVerified() %>)"
                            class="<%= user.isVerified() ? "bg-red-500 hover:bg-red-600" : "bg-green-500 hover:bg-green-600" %> text-white px-4 py-2 rounded transition duration-150"
                            >
                             <%= user.isVerified() ? "Reject" : "Grant" %>
                           </button>

                           
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
            <div class="py-12">
                <div class="text-center">
                    <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
                    </svg>
                    <h3 class="mt-2 text-lg font-medium text-gray-900">No users found</h3>
                    <p class="mt-1 text-sm text-gray-500">There are no users in the system that match your criteria.</p>
                </div>
            </div>
            <% } %>
            
            <!-- Pagination -->
            <div class="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6">
                <div class="flex-1 flex justify-between sm:hidden">
                    <a href="#" class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                        Previous
                    </a>
                    <a href="#" class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">
                        Next
                    </a>
                </div>
                <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                    <div>
                        <p class="text-sm text-gray-700">
                            Showing <span class="font-medium">1</span> to <span class="font-medium"><%= (users != null) ? users.size() : 0 %></span> of <span class="font-medium"><%= (users != null) ? users.size() : 0 %></span> results
                        </p>
                    </div>
                    <div>
                        <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                            <a href="#" class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                <span class="sr-only">Previous</span>
                                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                                </svg>
                            </a>
                            <a href="#" aria-current="page" class="z-10 bg-primary-50 border-primary-500 text-primary-600 relative inline-flex items-center px-4 py-2 border text-sm font-medium">
                                1
                            </a>
                            <span class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700">
                                ...
                            </span>
                            <a href="#" class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50">
                                <span class="sr-only">Next</span>
                                <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                                </svg>
                            </a>
                        </nav>
                        </div>
                     </div>
                    