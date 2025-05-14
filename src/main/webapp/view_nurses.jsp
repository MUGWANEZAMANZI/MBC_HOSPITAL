<%@ page import="java.util.*, java.net.*, java.io.*, com.mbc_hospital.model.User" %>
<%
// Optional: Ensure only logged-in users can access
if (session.getAttribute("id") == null) {
    response.sendRedirect("login.jsp");
    return;
}

int userID = (Integer) session.getAttribute("id");
String username = (String) session.getAttribute("username");
String userType = (String) session.getAttribute("usertype");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <title>Registered Nurses - MBC Hospital</title>
    <style>
        .sidebar {
            background: linear-gradient(135deg, #1e40af 0%, #3b82f6 100%);
            width: 280px;
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            color: white;
            padding: 1.5rem 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 0 25px rgba(0, 0, 0, 0.15);
            z-index: 50;
            overflow-y: auto;
        }
        
        .sidebar-header {
            padding-bottom: 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 1.5rem;
        }
        
        .sidebar-user {
            padding: 1.25rem;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.05);
        }
        
        .sidebar-link {
            display: flex;
            align-items: center;
            padding: 0.85rem 1.25rem;
            color: rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            transition: all 0.2s ease;
            margin-bottom: 0.5rem;
            font-weight: 500;
            position: relative;
            overflow: hidden;
            text-decoration: none;
        }
        
        .sidebar-link:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            transform: translateX(5px);
        }
        
        .sidebar-link.active {
            background: white;
            color: #2563eb;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
        }
        
        .sidebar-link.active::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 4px;
            background: #1e40af;
        }
        
        .main-content {
            margin-left: 280px;
            padding: 2rem;
            min-height: 100vh;
            background-color: #f1f5f9;
        }
        
        @media (max-width: 1024px) {
            .main-content {
                margin-left: 0;
                padding: 1rem;
            }
            
            .sidebar {
                transform: translateX(-100%);
            }
            
            .sidebar.active {
                transform: translateX(0);
            }
            
            .mobile-menu-btn {
                display: block;
            }
        }
    </style>
</head>
<body class="bg-gray-50">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <a href="reffered" class="flex items-center">
                <i class="fas fa-hospital text-white text-3xl mr-3"></i>
                <h1 class="text-2xl font-bold">MBC Hospital</h1>
            </a>
            <p class="text-sm text-blue-200 mt-1">Healthcare Management System</p>
        </div>

        <div class="sidebar-user">
            <div class="flex items-center space-x-3">
                <div class="w-12 h-12 rounded-full bg-white/20 flex items-center justify-center">
                    <i class="fas fa-user-md text-xl"></i>
                </div>
                <div>
                    <p class="text-sm text-blue-100">Welcome,</p>
                    <p class="font-semibold"><%= username %></p>
                    <span class="inline-block mt-1 text-xs bg-blue-800/40 rounded-full px-2 py-0.5"><%= userType %></span>
                </div>
            </div>
        </div>

        <nav class="space-y-1">
            <p class="text-xs uppercase text-blue-300/70 font-semibold px-3 py-2">Main Navigation</p>
            <a href="reffered" class="sidebar-link">
                <i class="fas fa-tachometer-alt w-6"></i>
                <span>Dashboard</span>
            </a>
            
            <% if ("Doctor".equalsIgnoreCase(userType)) { %>
            <p class="text-xs uppercase text-blue-300/70 font-semibold px-3 py-2 mt-4">Staff Management</p>
            <a href="create-nurse" class="sidebar-link">
                <i class="fas fa-user-nurse w-6"></i>
                <span>Register a Nurse</span>
            </a>
            <a href="view_nurses.jsp" class="sidebar-link active">
                <i class="fas fa-clipboard-list w-6"></i>
                <span>Registered Nurses</span>
            </a>
            <a href="unverified_nurses.jsp" class="sidebar-link">
                <i class="fas fa-user-check w-6"></i>
                <span>Verify Nurses</span>
            </a>
            
            <p class="text-xs uppercase text-blue-300/70 font-semibold px-3 py-2 mt-4">Patient Care</p>
            <a href="referred-diagnoses" class="sidebar-link">
                <i class="fas fa-clipboard-check w-6"></i>
                <span>Awaiting Diagnosis</span>
            </a>
            <a href="confirmed-cases" class="sidebar-link">
                <i class="fas fa-check-circle w-6"></i>
                <span>Confirmed Cases</span>
            </a>
            <a href="all-patients" class="sidebar-link">
                <i class="fas fa-hospital-user w-6"></i>
                <span>All Patients</span>
            </a>
            <a href="DiagnosisViewServlet" class="sidebar-link">
                <i class="fas fa-stethoscope w-6"></i>
                <span>Diagnosis Records</span>
            </a>
            <% } %>
            
            <div class="pt-4 mt-6 border-t border-blue-700/30">
                <a href="logout.jsp" class="sidebar-link bg-red-500/20 hover:bg-red-500/30">
                    <i class="fas fa-sign-out-alt w-6"></i>
                    <span>Logout</span>
                </a>
            </div>
        </nav>
    </aside>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Page Header -->
        <div class="mb-6">
            <div class="flex flex-col md:flex-row md:justify-between md:items-center mb-2">
                <h1 class="text-2xl font-bold text-gray-800 mb-2 md:mb-0">Registered Nurses</h1>
                <div class="flex space-x-4">
                    <a href="reffered" class="text-blue-600 hover:text-blue-800 flex items-center">
                        <i class="fas fa-arrow-left mr-2"></i> Back to Dashboard
                    </a>
                    <% if ("Doctor".equalsIgnoreCase(userType) || "Admin".equalsIgnoreCase(userType)) { %>
                    <a href="unverified_nurses.jsp" class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition flex items-center text-sm">
                        <i class="fas fa-user-check mr-2"></i> Verify Nurses
                    </a>
                    <% } %>
                </div>
            </div>
            <p class="text-gray-600 text-sm">
                <a href="reffered" class="text-blue-600 hover:underline">Dashboard</a> / Registered Nurses
            </p>
        </div>
        
        <!-- Notification area -->
        <div id="notification-area"></div>
        
        <!-- Main content area -->
        <div class="bg-white rounded-xl shadow-sm overflow-hidden mb-8">
            <div class="bg-gradient-to-r from-blue-50 to-white px-6 py-4 border-b border-gray-200 flex justify-between items-center">
                <h2 class="text-lg font-semibold text-gray-800 flex items-center">
                    <i class="fas fa-user-nurse text-blue-600 mr-2"></i>
                    Verified Nurses
                    <span class="ml-2 text-xs bg-blue-100 text-blue-800 px-2 py-1 rounded-full">
                        Nurse Registry
                    </span>
                </h2>
                <div>
                    <button onclick="printPage()" class="px-3 py-1 bg-blue-100 text-blue-700 rounded-md hover:bg-blue-200 transition flex items-center text-sm">
                        <i class="fas fa-print mr-1.5"></i> Print List
                    </button>
                </div>
            </div>
            
            <%
            List<User> nurseList = new ArrayList<>();
            try {
                URL url = new URL("http://localhost:8080/MBC_HOSPITAL/nurse-list-raw");
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setConnectTimeout(5000);
                connection.setReadTimeout(5000);
                
                int responseCode = connection.getResponseCode();
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    ObjectInputStream in = new ObjectInputStream(connection.getInputStream());
                    nurseList = (List<User>) in.readObject();
                    in.close();
                    
                    if (nurseList != null && !nurseList.isEmpty()) {
            %>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nurse Name</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Verification Status</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <% 
                            for (User nurse : nurseList) {
                                boolean isVerified = nurse.isVerified();
                                String statusClass = isVerified ? "bg-green-100 text-green-800" : "bg-yellow-100 text-yellow-800";
                                String statusIcon = isVerified ? "fa-check-circle text-green-600" : "fa-clock text-yellow-600";
                        %>
                            <tr class="hover:bg-gray-50 transition">
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><%= nurse.getUserID() %></td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10 bg-blue-100 rounded-full flex items-center justify-center text-blue-600">
                                            <i class="fas fa-user-nurse"></i>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900"><%= nurse.getUsername() %></div>
                                            <div class="text-xs text-gray-500">ID: <%= nurse.getUserID() %></div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700"><%= nurse.getUserType() %></td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full <%= statusClass %>">
                                        <i class="fas <%= statusIcon %> mr-1"></i>
                                        <%= isVerified ? "Verified" : "Pending" %>
                                    </span>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <%
                } else {
            %>
                <div class="p-8 text-center">
                    <div class="inline-flex h-24 w-24 rounded-full bg-blue-100 text-blue-600 items-center justify-center mb-4">
                        <i class="fas fa-user-nurse text-5xl"></i>
                    </div>
                    <h3 class="text-lg font-medium text-gray-900 mb-2">No verified nurses found</h3>
                    <p class="text-gray-500">There are currently no verified nurses in the system.</p>
                </div>
            <%
                }
            } else {
                throw new IOException("HTTP error code: " + responseCode);
            }
        } catch (Exception e) {
        %>
            <div class="p-4 border-l-4 border-red-500 bg-red-50 text-red-700 mb-6 rounded-md">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <i class="fas fa-exclamation-circle"></i>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm font-medium">Unable to load nurse data: <%= e.getMessage() %></p>
                        <p class="text-sm mt-1">Please check the server connection and try again later.</p>
                    </div>
                </div>
            </div>
        <%
        }
        %>
        </div>
        
        <!-- Footer -->
        <footer class="mt-8 pt-6 border-t border-gray-200 text-center text-gray-500 text-sm">
            <div class="flex items-center justify-center mb-2">
                <i class="fas fa-hospital-alt text-blue-500 mr-2"></i>
                <span class="font-semibold text-gray-600">MBC Hospital</span>
            </div>
            <p>&copy; <%= new java.util.Date().getYear() + 1900 %> MBC Hospital Healthcare Management System. All rights reserved.</p>
        </footer>
    </div>
    
    <script>
        // Print functionality
        function printPage() {
            window.print();
        }
        
        // Mobile sidebar toggle
        document.addEventListener('DOMContentLoaded', function() {
            const mobileMenuBtn = document.getElementById('mobile-menu-btn');
            if (mobileMenuBtn) {
                mobileMenuBtn.addEventListener('click', function() {
                    const sidebar = document.querySelector('.sidebar');
                    sidebar.classList.toggle('active');
                    
                    // Add overlay when sidebar is open
                    let overlay = document.querySelector('.sidebar-overlay');
                    if (!overlay && sidebar.classList.contains('active')) {
                        overlay = document.createElement('div');
                        overlay.className = 'sidebar-overlay fixed inset-0 bg-gray-800/50 z-40 lg:hidden';
                        document.body.appendChild(overlay);
                        
                        overlay.addEventListener('click', function() {
                            sidebar.classList.remove('active');
                            overlay.remove();
                        });
                    } else if (overlay && !sidebar.classList.contains('active')) {
                        overlay.remove();
                    }
                });
            }
        });
        
        function showNotification(message, type) {
            const notificationArea = document.getElementById('notification-area');
            const notification = document.createElement('div');
            notification.className = 'mb-4 rounded-md p-4 flex items-center justify-between transition-all duration-300 transform translate-y-0 opacity-100';
            
            if (type === 'success') {
                notification.className += ' bg-green-50 border-l-4 border-green-500 text-green-700';
                notification.innerHTML = `
                    <div class="flex items-center">
                        <i class="fas fa-check-circle mr-2"></i>
                        <span>${message}</span>
                    </div>
                    <button class="text-green-600 hover:text-green-800" onclick="this.parentNode.remove()">
                        <i class="fas fa-times"></i>
                    </button>
                `;
            } else {
                notification.className += ' bg-red-50 border-l-4 border-red-500 text-red-700';
                notification.innerHTML = `
                    <div class="flex items-center">
                        <i class="fas fa-exclamation-circle mr-2"></i>
                        <span>${message}</span>
                    </div>
                    <button class="text-red-600 hover:text-red-800" onclick="this.parentNode.remove()">
                        <i class="fas fa-times"></i>
                    </button>
                `;
            }
            
            notificationArea.appendChild(notification);
            
            setTimeout(() => {
                notification.style.transform = 'translateY(-10px)';
                notification.style.opacity = '0';
                setTimeout(() => notification.remove(), 300);
            }, 5000);
        }
    </script>
</body>
</html>