<%@ page import="java.util.*, java.net.*, java.io.*, com.mbc_hospital.model.User" %>
<%
// Ensure only authorized users can access
if (session.getAttribute("id") == null) {
    response.sendRedirect("login.jsp");
    return;
}

String userType = (String) session.getAttribute("usertype");
String username = (String) session.getAttribute("username");

// Check if user is authorized to verify nurses
if (!("Doctor".equalsIgnoreCase(userType) || "Admin".equalsIgnoreCase(userType))) {
    response.sendRedirect("view_nurses.jsp");
    return;
}

int userID = (Integer) session.getAttribute("id");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <title>Verify Nurses - MBC Hospital</title>
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
            <a href="view_nurses.jsp" class="sidebar-link">
                <i class="fas fa-clipboard-list w-6"></i>
                <span>Registered Nurses</span>
            </a>
            <a href="unverified_nurses.jsp" class="sidebar-link active">
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
                <h1 class="text-2xl font-bold text-gray-800 mb-2 md:mb-0">Pending Nurse Verifications</h1>
                <a href="view_nurses.jsp" class="text-blue-600 hover:text-blue-800 flex items-center">
                    <i class="fas fa-arrow-left mr-2"></i> Back to Nurses List
                </a>
            </div>
            <p class="text-gray-600 text-sm">
                <a href="reffered" class="text-blue-600 hover:underline">Dashboard</a> / 
                <a href="view_nurses.jsp" class="text-blue-600 hover:underline">Nurses</a> / 
                Verify Nurses
            </p>
        </div>
        
        <!-- Notification area -->
        <div id="notification-area"></div>
        
        <!-- Main content area -->
        <div class="bg-white rounded-xl shadow-sm overflow-hidden mb-8">
            <div class="bg-gradient-to-r from-blue-600 to-indigo-700 px-6 py-4 border-b border-gray-200 flex justify-between items-center">
                <div class="flex items-center">
                    <i class="fas fa-user-check text-white text-xl mr-3"></i>
                    <h2 class="text-lg font-semibold text-white">Unverified Nurses</h2>
                    <span class="ml-2 text-xs bg-yellow-100 text-yellow-800 px-2 py-1 rounded-full">
                        Awaiting Verification
                    </span>
                </div>
                <div class="text-xs text-blue-100">
                    <span><i class="fas fa-info-circle mr-1"></i> Verify nurses to allow them access to the system</span>
                </div>
            </div>
            
            <%
            List<User> unverifiedNurses = new ArrayList<>();
            
            try {
                URL url = new URL("http://localhost:8080/MBC_HOSPITAL/unverified-nurse-list");
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setConnectTimeout(5000);
                connection.setReadTimeout(5000);
                
                int responseCode = connection.getResponseCode();
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    ObjectInputStream in = new ObjectInputStream(connection.getInputStream());
                    unverifiedNurses = (List<User>) in.readObject();
                    in.close();
                    
                    if (unverifiedNurses != null && !unverifiedNurses.isEmpty()) {
            %>
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                            <tr>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nurse Name</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                        <% 
                            for (User nurse : unverifiedNurses) {
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
                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                        <i class="fas fa-clock text-yellow-600 mr-1"></i>
                                        Pending
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                    <div class="flex space-x-2">
                                        <button 
                                            onclick="verifyNurse(<%= nurse.getUserID() %>)" 
                                            class="group relative inline-flex items-center justify-center px-4 py-2 overflow-hidden rounded-md bg-green-50 text-green-600 hover:bg-green-100 transition-all duration-300">
                                            <span class="absolute left-0 top-0 h-full w-0 bg-green-600 opacity-20 transition-all duration-300 group-hover:w-full"></span>
                                            <i class="fas fa-check-circle mr-1.5"></i>
                                            <span class="relative">Verify</span>
                                        </button>
                                        <button 
                                            onclick="rejectNurse(<%= nurse.getUserID() %>)" 
                                            class="group relative inline-flex items-center justify-center px-4 py-2 overflow-hidden rounded-md bg-red-50 text-red-600 hover:bg-red-100 transition-all duration-300">
                                            <span class="absolute left-0 top-0 h-full w-0 bg-red-600 opacity-20 transition-all duration-300 group-hover:w-full"></span>
                                            <i class="fas fa-times-circle mr-1.5"></i>
                                            <span class="relative">Reject</span>
                                        </button>
                                        <button 
                                            onclick="showUserDetails('<%= nurse.getUserID() %>', '<%= nurse.getUsername() %>', '<%= nurse.getUserType() %>', '<%= nurse.isVerified() %>', '<%= nurse.getFirstName() != null ? nurse.getFirstName() : "" %>', '<%= nurse.getLastName() != null ? nurse.getLastName() : "" %>', '<%= nurse.getTelephone() != null ? nurse.getTelephone() : "" %>', '<%= nurse.getEmail() != null ? nurse.getEmail() : "" %>', '<%= nurse.getAddress() != null ? nurse.getAddress() : "" %>', '<%= nurse.getHospitalName() != null ? nurse.getHospitalName() : "" %>')" 
                                            class="group relative inline-flex items-center justify-center px-4 py-2 overflow-hidden rounded-md bg-blue-50 text-blue-600 hover:bg-blue-100 transition-all duration-300">
                                            <span class="absolute left-0 top-0 h-full w-0 bg-blue-600 opacity-20 transition-all duration-300 group-hover:w-full"></span>
                                            <i class="fas fa-eye mr-1.5"></i>
                                            <span class="relative">Details</span>
                                        </button>
                                    </div>
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
                        <i class="fas fa-clipboard-check text-5xl"></i>
                    </div>
                    <h3 class="text-lg font-medium text-gray-900 mb-2">No Nurses Pending Verification</h3>
                    <p class="text-gray-500 mb-6">All nurses have been verified. Great job!</p>
                    <div class="mt-6">
                        <a href="view_nurses.jsp" class="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-all duration-300">
                            <i class="fas fa-arrow-left mr-2"></i> Return to Nurses List
                        </a>
                    </div>
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
        // Show notification function with improved styling
        function showNotification(message, type) {
            const notificationArea = document.getElementById('notification-area');
            const notification = document.createElement('div');
            notification.className = 'fixed top-4 right-4 max-w-sm w-full shadow-lg rounded-lg overflow-hidden transform transition-all duration-300 opacity-0 translate-y-[-20px]';
            
            let icon, color, bgColor;
            if (type === 'success') {
                icon = 'check-circle';
                color = 'green';
                bgColor = 'bg-gradient-to-r from-green-50 to-green-100';
            } else {
                icon = 'exclamation-circle';
                color = 'red';
                bgColor = 'bg-gradient-to-r from-red-50 to-red-100';
            }
            
            notification.innerHTML = 
                '<div class="' + bgColor + ' border-l-4 border-' + color + '-500 p-4">' +
                    '<div class="flex items-start">' +
                        '<div class="flex-shrink-0">' +
                            '<i class="fas fa-' + icon + ' text-' + color + '-600 text-lg"></i>' +
                        '</div>' +
                        '<div class="ml-3 w-0 flex-1 pt-0.5">' +
                            '<p class="text-sm font-medium text-' + color + '-800">' + message + '</p>' +
                        '</div>' +
                        '<div class="ml-4 flex-shrink-0 flex">' +
                            '<button type="button" class="inline-flex text-gray-400 hover:text-gray-500 focus:outline-none" onclick="this.closest(\'.fixed\').remove()">' +
                                '<i class="fas fa-times text-' + color + '-500 hover:text-' + color + '-700"></i>' +
                            '</button>' +
                        '</div>' +
                    '</div>' +
                '</div>';
            
            notificationArea.appendChild(notification);
            
            // Animate in
            setTimeout(() => {
                notification.classList.add('opacity-100', 'translate-y-0');
            }, 10);
            
            // Auto dismiss
            setTimeout(() => {
                notification.classList.remove('opacity-100', 'translate-y-0');
                notification.classList.add('opacity-0', 'translate-y-[-20px]');
                setTimeout(() => notification.remove(), 300);
            }, 5000);
        }
        
        // Update loader overlay with better design
        function createLoadingOverlay(message) {
            if (!message) message = 'Processing...';
            const overlay = document.createElement('div');
            overlay.className = 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50';
            overlay.innerHTML = 
                '<div class="bg-white p-6 rounded-lg shadow-xl flex flex-col items-center max-w-sm mx-auto">' +
                    '<div class="w-16 h-16 border-t-4 border-b-4 border-blue-600 rounded-full animate-spin mb-4"></div>' +
                    '<p class="text-gray-700 font-medium">' + message + '</p>' +
                    '<p class="text-gray-500 text-sm mt-2">Please wait while we process your request</p>' +
                '</div>';
            document.body.appendChild(overlay);
            return overlay;
        }
        
        // Update verification function to use new loader
        function updateNurseVerification(userId, action) {
            // Show a confirmation dialog with better styling
            const actionText = action === "verify" ? "verify" : "reject";
            const actionColor = action === "verify" ? "green" : "red";
            const actionIcon = action === "verify" ? "check-circle" : "exclamation-triangle";
            
            // Custom confirmation dialog
            const dialogOverlay = document.createElement('div');
            dialogOverlay.className = 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50';
            dialogOverlay.innerHTML = 
                '<div class="bg-white rounded-lg shadow-xl overflow-hidden max-w-md w-full mx-4 transform transition-all">' +
                    '<div class="bg-' + actionColor + '-50 p-4 border-b border-' + actionColor + '-100">' +
                        '<h3 class="text-lg font-medium text-' + actionColor + '-800 flex items-center">' +
                            '<i class="fas fa-' + actionIcon + ' mr-2"></i>' +
                            'Confirm ' + (action === "verify" ? "Verification" : "Rejection") +
                        '</h3>' +
                    '</div>' +
                    '<div class="p-6">' +
                        '<p class="text-gray-700">' +
                            'Are you sure you want to ' + actionText + ' this nurse?' +
                            (action === "reject" ? '<br><span class="text-red-600 text-sm font-medium mt-2 block">Warning: This action cannot be undone. The account will be deleted.</span>' : '') +
                        '</p>' +
                        '<div class="mt-6 flex justify-end space-x-3">' +
                            '<button id="cancel-btn" class="px-4 py-2 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200 transition focus:outline-none focus:ring-2 focus:ring-gray-400">' +
                                'Cancel' +
                            '</button>' +
                            '<button id="confirm-btn" class="px-4 py-2 bg-' + actionColor + '-600 text-white rounded-md hover:bg-' + actionColor + '-700 transition focus:outline-none focus:ring-2 focus:ring-' + actionColor + '-500">' +
                                (action === "verify" ? "Verify" : "Reject") +
                            '</button>' +
                        '</div>' +
                    '</div>' +
                '</div>';
            
            document.body.appendChild(dialogOverlay);
            
            // Handle dialog buttons
            return new Promise((resolve) => {
                document.getElementById('cancel-btn').addEventListener('click', () => {
                    dialogOverlay.remove();
                    resolve(false);
                });
                
                document.getElementById('confirm-btn').addEventListener('click', () => {
                    dialogOverlay.remove();
                    resolve(true);
                });
            }).then(confirmed => {
                if (!confirmed) return;
                
                // Create an improved loading overlay
                const loadingOverlay = createLoadingOverlay(action === "verify" ? "Verifying nurse..." : "Rejecting nurse...");
                
                fetch("verify-nurse", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: "nurseid=" + encodeURIComponent(userId) + "&action=" + encodeURIComponent(action)
                })
                .then(res => res.json())
                .then(data => {
                    // Remove loading overlay
                    loadingOverlay.remove();
                    
                    if (data.success) {
                        showNotification(data.message, 'success');
                        // Reload the page after a short delay to reflect changes
                        setTimeout(() => {
                            location.reload();
                        }, 1500);
                    } else {
                        showNotification("Failed to update nurse verification status: " + data.message, 'error');
                    }
                })
                .catch(err => {
                    // Remove loading overlay
                    loadingOverlay.remove();
                    
                    console.error("Error updating nurse verification:", err);
                    showNotification("Error updating nurse verification status. Please try again.", 'error');
                });
            });
        }
        
        // Verify nurse function
        function verifyNurse(userId) {
            updateNurseVerification(userId, "verify");
        }
        
        // Reject nurse function
        function rejectNurse(userId) {
            updateNurseVerification(userId, "reject");
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
        
        // User Details Modal Functions
        function showUserDetails(userId, username, userType, isVerified, firstName, lastName, telephone, email, address, hospitalName) {
            // Create modal if it doesn't exist
            if (!document.getElementById('userDetailsModal')) {
                const modal = document.createElement('div');
                modal.id = 'userDetailsModal';
                modal.className = 'fixed inset-0 z-50 overflow-auto bg-black bg-opacity-50 flex items-center justify-center hidden';
                modal.innerHTML = `
                    <div class="bg-white rounded-lg shadow-xl max-w-md w-full mx-4 animate-fade-in">
                        <div class="border-b px-6 py-4 flex justify-between items-center">
                            <h3 class="text-lg font-semibold text-gray-900">Nurse Details</h3>
                            <button onclick="hideUserDetails()" class="text-gray-400 hover:text-gray-600">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="p-6">
                            <div class="mb-6 flex justify-center">
                                <div class="w-24 h-24 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
                                    <i class="fas fa-user-nurse text-4xl"></i>
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
                                    <p class="text-sm font-medium text-gray-500">Hospital/Health Center</p>
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
                `;
                document.body.appendChild(modal);
            }
            
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