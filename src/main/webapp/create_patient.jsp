<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
// Optional: Ensure only logged-in users can access
if (session.getAttribute("id") == null) {
    response.sendRedirect("login.jsp");
    return;
}

int userID = (Integer) session.getAttribute("id");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register New Patient | MBC Hospital</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
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
        
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.02);
        }
        
        .btn {
            padding: 0.6rem 1.2rem;
            border-radius: 0.5rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        .btn-primary {
            background-color: #3b82f6;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #2563eb;
            box-shadow: 0 4px 6px rgba(37, 99, 235, 0.2);
        }
        
        .btn-outline {
            border: 1px solid #d1d5db;
            color: #4b5563;
        }
        
        .btn-outline:hover {
            background-color: #f3f4f6;
            color: #1f2937;
        }
        
        /* Additional responsive styles */
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
<body class="antialiased bg-gray-50">
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <a href="nurse.jsp" class="flex items-center">
                <i class="fas fa-hospital text-white text-3xl mr-3"></i>
                <h1 class="text-2xl font-bold">MBC Hospital</h1>
            </a>
            <p class="text-sm text-blue-200 mt-1">Healthcare Management System</p>
        </div>
        
        <div class="sidebar-user">
            <div class="flex items-center space-x-3">
                <div class="h-12 w-12 rounded-full bg-white/20 flex items-center justify-center">
                    <i class="fas fa-user-nurse text-2xl"></i>
                </div>
                <div>
                    <p class="text-sm text-blue-200">Logged in as</p>
                    <p class="font-semibold"><%= session.getAttribute("username") %></p>
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-200 text-blue-800 mt-1">
                        Nurse
                    </span>
                </div>
            </div>
        </div>
        
        <nav class="space-y-1">
            <a href="nurse.jsp" class="sidebar-link">
                <i class="fas fa-tachometer-alt w-5 h-5 mr-3"></i>
                <span>Dashboard</span>
            </a>
            <a href="create_patient.jsp" class="sidebar-link active">
                <i class="fas fa-user-plus w-5 h-5 mr-3"></i>
                <span>Register Patient</span>
            </a>
            <a href="nurse-action-cases" class="sidebar-link">
                <i class="fas fa-clipboard-list w-5 h-5 mr-3"></i>
                <span>Cases Requiring Action</span>
            </a>
            <a href="nurse-referred-cases" class="sidebar-link">
                <i class="fas fa-share w-5 h-5 mr-3"></i>
                <span>Referred Cases</span>
            </a>
            <a href="nurse-completed-cases" class="sidebar-link">
                <i class="fas fa-check-circle w-5 h-5 mr-3"></i>
                <span>Nurse-Completed Cases</span>
            </a>
            <a href="nurse-view-diagnoses" class="sidebar-link">
                <i class="fas fa-clipboard-check w-5 h-5 mr-3"></i>
                <span>View Diagnosed Cases</span>
            </a>
            <div class="pt-4 mt-4 border-t border-blue-800/30">
                <a href="logout.jsp" class="sidebar-link text-red-100 bg-red-500/20 hover:bg-red-500/30">
                    <i class="fas fa-sign-out-alt w-5 h-5 mr-3"></i>
                    <span>Logout</span>
                </a>
            </div>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Header -->
        <div class="flex justify-between items-center mb-6">
            <div>
                <h1 class="text-2xl font-bold text-gray-800">Register New Patient</h1>
                <p class="text-gray-600">Enter patient information to add them to the system.</p>
            </div>
            <div>
                <a href="nurse.jsp" class="btn btn-outline">
                    <i class="fas fa-arrow-left mr-2"></i>
                    Back to Dashboard
                </a>
            </div>
        </div>
        
        <!-- Form Card -->
        <div class="card animate-fade-in">
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 py-4 px-6 rounded-t-lg">
                <h2 class="text-xl font-bold text-white flex items-center">
                    <i class="fas fa-user-plus mr-3"></i>
                    Patient Registration Form
                </h2>
                <p class="text-blue-100 text-sm mt-1">All fields marked with * are required</p>
            </div>
            
            <form action="CreatePatientServlet" method="post" enctype="multipart/form-data" class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label for="firstName" class="block text-sm font-medium text-gray-700 mb-1">First Name *</label>
                        <input type="text" name="firstName" id="firstName" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200" required>
                    </div>
                    <div>
                        <label for="lastName" class="block text-sm font-medium text-gray-700 mb-1">Last Name *</label>
                        <input type="text" name="lastName" id="lastName" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200" required>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div>
                        <label for="telephone" class="block text-sm font-medium text-gray-700 mb-1">
                            <i class="fas fa-phone mr-1 text-blue-600"></i> Telephone *
                        </label>
                        <input type="text" name="telephone" id="telephone" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200" required>
                    </div>
                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-1">
                            <i class="fas fa-envelope mr-1 text-blue-600"></i> Email
                        </label>
                        <input type="email" name="email" id="email" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200">
                    </div>
                </div>

                <div class="mb-6">
                    <label for="address" class="block text-sm font-medium text-gray-700 mb-1">
                        <i class="fas fa-map-marker-alt mr-1 text-blue-600"></i> Address *
                    </label>
                    <textarea name="address" id="address" rows="2" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200" required></textarea>
                </div>

                <div class="mb-8">
                    <label for="pImageLink" class="block text-sm font-medium text-gray-700 mb-1">
                        <i class="fas fa-camera mr-1 text-blue-600"></i> Patient Image
                    </label>
                    <div class="flex items-center">
                        <div class="w-full">
                            <div class="flex items-center justify-center w-full">
                                <label class="flex flex-col w-full h-32 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer hover:bg-gray-50 transition duration-200">
                                    <div class="flex flex-col items-center justify-center pt-5">
                                        <i class="fas fa-cloud-upload-alt text-3xl text-blue-600 mb-2"></i>
                                        <p class="text-sm text-gray-500">Click to upload image</p>
                                        <p class="text-xs text-gray-400 mt-1">PNG, JPG, GIF up to 10MB</p>
                                    </div>
                                    <input type="file" name="pImageLink" id="pImageLink" class="opacity-0">
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <input type="hidden" name="registeredBy" value="<%= userID %>">

                <div class="flex justify-between items-center gap-4 border-t pt-6">
                    <a href="nurse.jsp" class="btn btn-outline">
                        <i class="fas fa-times mr-2"></i> Cancel
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save mr-2"></i> Register Patient
                    </button>
                </div>
            </form>

            <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if ("patient_created".equals(success)) {
            %>
            <div class="mx-6 mb-6 bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded" role="alert">
                <div class="flex items-center">
                    <i class="fas fa-check-circle text-green-500 mr-2"></i>
                    <p>Patient registered successfully!</p>
                </div>
            </div>
            <%
            } else if ("creation_failed".equals(error)) {
            %>
            <div class="mx-6 mb-6 bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded" role="alert">
                <div class="flex items-center">
                    <i class="fas fa-exclamation-circle text-red-500 mr-2"></i>
                    <p>Failed to register patient. Please try again.</p>
                </div>
            </div>
            <%
            }
            %>
        </div>
        
        <!-- Tips Card -->
        <div class="card p-6 mt-6 animate-fade-in" style="animation-delay: 0.2s">
            <h3 class="text-lg font-semibold text-gray-800 mb-3 flex items-center">
                <i class="fas fa-lightbulb text-yellow-500 mr-2"></i>
                Registration Tips
            </h3>
            <ul class="space-y-2 text-gray-600">
                <li class="flex items-start">
                    <i class="fas fa-check-circle text-green-500 mt-1 mr-2"></i>
                    <span>Ensure all required fields are filled correctly</span>
                </li>
                <li class="flex items-start">
                    <i class="fas fa-check-circle text-green-500 mt-1 mr-2"></i>
                    <span>Verify patient contact information for accuracy</span>
                </li>
                <li class="flex items-start">
                    <i class="fas fa-check-circle text-green-500 mt-1 mr-2"></i>
                    <span>Upload a clear photo of the patient for identification</span>
                </li>
            </ul>
        </div>
        
        <!-- Footer -->
        <footer class="mt-12 text-center text-gray-500 text-sm">
            <p>&copy; 2025 MBC Hospital System. All rights reserved.</p>
        </footer>
    </main>
    
    <!-- Mobile Menu Overlay (hidden by default) -->
    <div id="mobile-menu-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-40 hidden lg:hidden"></div>
    
    <script>
        // Mobile menu toggle
        document.addEventListener('DOMContentLoaded', function() {
            const menuToggle = document.getElementById('menu-toggle');
            const sidebar = document.querySelector('.sidebar');
            const overlay = document.getElementById('mobile-menu-overlay');
            
            if (menuToggle) {
                menuToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('active');
                    overlay.classList.toggle('hidden');
                });
            }
            
            if (overlay) {
                overlay.addEventListener('click', function() {
                    sidebar.classList.remove('active');
                    overlay.classList.add('hidden');
                });
            }
            
            // Image preview functionality
            const imageInput = document.getElementById('pImageLink');
            if (imageInput) {
                imageInput.addEventListener('change', function(e) {
                    const parent = this.parentElement;
                    const preview = parent.querySelector('div');
                    
                    if (this.files && this.files[0]) {
                        const reader = new FileReader();
                        
                        reader.onload = function(e) {
                            preview.innerHTML = `
                                <div class="flex flex-col items-center justify-center pt-5">
                                    <img src="${e.target.result}" class="h-20 object-cover mb-2" />
                                    <p class="text-sm text-gray-500">Image selected</p>
                                </div>
                            `;
                        }
                        
                        reader.readAsDataURL(this.files[0]);
                    }
                });
            }
        });
    </script>
</body>
</html>