<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register new Doctor</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        .blue-gradient {
            background: linear-gradient(90deg, #2563eb, #3b82f6);
        }
        .input-focus:focus {
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.5);
        }
        .hover-scale {
            transition: transform 0.3s ease;
        }
        .hover-scale:hover {
            transform: scale(1.02);
        }
    </style>
</head>
<body class="bg-white">
    <!-- Top Navigation Bar -->
    <nav class="blue-gradient shadow-lg text-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <span class="text-xl font-bold"></span>
                </div>
                <div class="flex items-center space-x-4">
                    <a href="dashboard.jsp" class="flex items-center space-x-2 px-4 py-2 rounded-lg bg-white bg-opacity-20 hover:bg-opacity-30 transition duration-300">
                        <i class="fas fa-th-large"></i>
                        <span>Dashboard</span>
                    </a>
                    <div class="w-10 h-10 rounded-full bg-white bg-opacity-20 flex items-center justify-center">
                        <i class="fas fa-user-md text-lg"></i>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <div class="max-w-6xl mx-auto p-6 sm:p-10">
        <!-- Page Header with Back Button -->
        <div class="flex items-center justify-between mb-8">
            <a href="dashboard" class="flex items-center text-blue-600 hover:text-blue-800 transition duration-300">
                <i class="fas fa-arrow-left mr-2"></i>
                <span class="font-medium">Back to Dashboard</span>
            </a>
        </div>
        
        <!-- Main Form Card -->
        <div class="bg-blue-50 p-5 rounded-lg shadow-sm border border-blue-100">
             
            
            <!-- Form Content -->
            <div class="p-6 sm:p-8">
                <form method="post" action="new-doctor" class="space-y-8">
                    <!-- Personal Information Section -->
                    <div>
                        <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                            <i class="fas fa-id-card text-blue-500 mr-2"></i>
                            Doctor Personal Information
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-gray-700 font-medium mb-2">First Name</label>
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i class="fas fa-user text-gray-400"></i>
                                    </div>
                                    <input type="text" name="firstName" class="w-full pl-10 pr-4 py-3 rounded-lg border border-gray-300 input-focus focus:outline-none focus:border-blue-500 transition duration-300" required />
                                </div>
                            </div>
                            
                            <div>
                                <label class="block text-gray-700 font-medium mb-2">Last Name</label>
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i class="fas fa-user text-gray-400"></i>
                                    </div>
                                    <input type="text" name="lastName" class="w-full pl-10 pr-4 py-3 rounded-lg border border-gray-300 input-focus focus:outline-none focus:border-blue-500 transition duration-300" required />
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Contact Information Section -->
                    <div>
                        <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                            <i class="fas fa-address-book text-blue-500 mr-2"></i>
                            Contact Information
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-gray-700 font-medium mb-2">Telephone</label>
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i class="fas fa-phone text-gray-400"></i>
                                    </div>
                                    <input type="text" name="telephone" class="w-full pl-10 pr-4 py-3 rounded-lg border border-gray-300 input-focus focus:outline-none focus:border-blue-500 transition duration-300" />
                                </div>
                            </div>
                            
                            <div>
                                <label class="block text-gray-700 font-medium mb-2">Email</label>
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i class="fas fa-envelope text-gray-400"></i>
                                    </div>
                                    <input type="email" name="email" class="w-full pl-10 pr-4 py-3 rounded-lg border border-gray-300 input-focus focus:outline-none focus:border-blue-500 transition duration-300" />
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Address & Workplace Section -->
                    <div>
                        <h3 class="text-lg font-semibold text-gray-800 mb-4 flex items-center">
                            <i class="fas fa-hospital text-blue-500 mr-2"></i>
                            Address & Workplace
                        </h3>
                        <div class="space-y-6">
                            <div>
                                <label class="block text-gray-700 font-medium mb-2">Address</label>
                                <div class="relative">
                                    <div class="absolute top-3 left-3 flex items-start pointer-events-none">
                                        <i class="fas fa-map-marker-alt text-gray-400"></i>
                                    </div>
                                    <textarea name="address" class="w-full pl-10 pr-4 py-3 rounded-lg border border-gray-300 input-focus focus:outline-none focus:border-blue-500 transition duration-300 h-24"></textarea>
                                </div>
                            </div>
                            
                            <div>
                                <label class="block text-gray-700 font-medium mb-2">Hospital name</label>
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                        <i class="fas fa-hospital-alt text-gray-400"></i>
                                    </div>
                                    <input type="text" name="healthCenter" class="w-full pl-10 pr-4 py-3 rounded-lg border border-gray-300 input-focus focus:outline-none focus:border-blue-500 transition duration-300" />
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Submit Button Section -->
                    <div class="pt-4 flex flex-col sm:flex-row justify-end space-y-4 sm:space-y-0 sm:space-x-4">
                        <button type="button" onclick="window.location.href='dashboard'" class="px-6 py-3 bg-gray-200 text-gray-700 font-medium rounded-lg hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-gray-400 focus:ring-offset-2 transition duration-300">
                            Cancel
                        </button>
                        <button type="submit" class="px-8 py-3 blue-gradient text-white font-medium rounded-lg hover:shadow-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition duration-300">
                            <i class="fas fa-save mr-2"></i>
                            Register Doctor
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        
        <!-- Footer -->
        <div class="mt-10 pt-6 border-t border-gray-200">
            <div class="flex flex-col md:flex-row justify-between items-center text-gray-500 text-sm">
                <p>Medical Staff Management System © 2025</p>
                <div class="flex space-x-6 mt-4 md:mt-0">
                    <a href="#" class="text-blue-500 hover:text-blue-700">Privacy Policy</a>
                    <a href="#" class="text-blue-500 hover:text-blue-700">Terms of Service</a>
                    <a href="#" class="text-blue-500 hover:text-blue-700">Support</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>