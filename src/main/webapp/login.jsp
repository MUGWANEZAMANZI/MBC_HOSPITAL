<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MBC Hospital - Patient Portal</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <style>
        .login-card {
            animation: fadeIn 0.6s ease-in-out;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
        }
        
        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(20px); }
            100% { opacity: 1; transform: translateY(0); }
        }
        
        .btn-pulse {
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(59, 130, 246, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(59, 130, 246, 0); }
            100% { box-shadow: 0 0 0 0 rgba(59, 130, 246, 0); }
        }
        
        .input-focus:focus {
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.5);
            transition: all 0.2s ease;
        }
        
        .bg-gradient {
            background: linear-gradient(135deg, #3b82f6 0%, #1e40af 100%);
        }
    </style>
</head>
<body class="bg-blue-50 min-h-screen flex flex-col">
    <!-- Header -->
    <header class="bg-gradient py-4 px-6 shadow-lg">
        <div class="container mx-auto flex justify-between items-center">
            <div class="flex items-center space-x-2">
                <i class="fas fa-hospital text-white text-2xl"></i>
                <h1 class="text-white text-2xl font-bold">MBC Hospital</h1>
            </div>
            <div class="hidden md:flex items-center space-x-4 text-sm text-white">
                <a href="#" class="hover:text-blue-200 transition">About Us</a>
                <a href="#" class="hover:text-blue-200 transition">Services</a>
                <a href="#" class="hover:text-blue-200 transition">Contact</a>
                <a href="#" class="border border-white px-4 py-1 rounded-full hover:bg-white hover:text-blue-600 transition">Emergency</a>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="flex-grow flex justify-center items-center p-4 md:p-8 bg-[url('/api/placeholder/1600/900')] bg-cover bg-center">
        <div class="login-card w-full max-w-md rounded-2xl shadow-2xl overflow-hidden">
           
            <!-- Card Body -->
            <div class="p-8">
                <% if (request.getParameter("error") != null) { %>
                    <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-6 rounded">
                        <div class="flex items-center">
                            <i class="fas fa-exclamation-circle text-red-500 mr-2"></i>
                            <p class="text-red-700 text-sm font-medium">Login failed. Please check your credentials and try again.</p>
                        </div>
                    </div>
                <% } %>
                
                <form method="post" action="login" class="space-y-6">
                    <div class="space-y-2">
                        <label for="username" class="block text-sm font-medium text-gray-700">Username</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-user text-gray-400"></i>
                            </div>
                            <input type="text" name="username" id="username" 
                                   class="input-focus block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg 
                                          focus:outline-none focus:ring-2 focus:ring-blue-500"
                                   placeholder="Enter your username" required>
                        </div>
                    </div>
                    
                    <div class="space-y-2">
                        <div class="flex justify-between">
                            <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
                            <a href="#" class="text-xs text-blue-600 hover:text-blue-800">Forgot password?</a>
                        </div>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-lock text-gray-400"></i>
                            </div>
                            <input type="password" name="password" id="password" 
                                   class="input-focus block w-full pl-10 pr-3 py-3 border border-gray-300 rounded-lg 
                                          focus:outline-none focus:ring-2 focus:ring-blue-500"
                                   placeholder="Enter your password" required>
                        </div>
                    </div>
                    
                    <div class="flex items-center">
                        <input id="remember-me" name="remember-me" type="checkbox" 
                               class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                        <label for="remember-me" class="ml-2 block text-sm text-gray-700">
                            Remember me on this device
                        </label>
                    </div>
                    
                    <div>
                        <button type="submit" 
                                class="btn-pulse group relative w-full flex justify-center py-3 px-4 border border-transparent 
                                       text-base font-medium rounded-lg text-white bg-blue-600 hover:bg-blue-700 
                                       focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-all duration-200">
                            <span class="absolute left-0 inset-y-0 flex items-center pl-3">
                                <i class="fas fa-sign-in-alt text-blue-300 group-hover:text-blue-200"></i>
                            </span>
                            Sign in to your account
                        </button>
                    </div>
                </form>
                
                <div class="mt-6 text-center">
                    <p class="text-sm text-gray-600">
                        Don't have an account? 
                        <a href="registration.jsp" class="font-medium text-blue-600 hover:text-blue-500 transition">
                            Register now <i class="fas fa-arrow-right ml-1 text-xs"></i>
                        </a>
                    </p>
                </div>
                
                <div class="mt-8 pt-6 border-t border-gray-200">
                    <div class="flex justify-center space-x-4">
                        <button class="p-2 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200 transition">
                            <i class="fab fa-google"></i>
                        </button>
                        <button class="p-2 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200 transition">
                            <i class="fab fa-facebook-f"></i>
                        </button>
                        <button class="p-2 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200 transition">
                            <i class="fab fa-apple"></i>
                        </button>
                    </div>
                    <p class="mt-2 text-xs text-center text-gray-500">Or continue with these social profiles</p>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-gray-800 text-white py-8">
        <div class="container mx-auto px-6">
            <div class="flex flex-col md:flex-row justify-between items-center">
                <div class="mb-4 md:mb-0">
                    <div class="flex items-center space-x-2">
                        <i class="fas fa-hospital"></i>
                        <span class="font-bold">MBC Hospital</span>
                    </div>
                    <p class="text-gray-400 text-sm mt-1">Providing quality healthcare since 1995</p>
                </div>
                
                <div class="flex space-x-6 mb-4 md:mb-0">
                    <a href="#" class="text-gray-400 hover:text-white transition">
                        <i class="fab fa-facebook-f"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-white transition">
                        <i class="fab fa-twitter"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-white transition">
                        <i class="fab fa-instagram"></i>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-white transition">
                        <i class="fab fa-linkedin-in"></i>
                    </a>
                </div>
                
                <div class="text-xs text-gray-400">
                    <p>&copy; 2025 Team 1. All rights reserved.</p>
                    <div class="flex justify-center md:justify-end space-x-4 mt-2">
                        <a href="#" class="hover:text-white transition">Privacy Policy</a>
                        <a href="#" class="hover:text-white transition">Terms of Service</a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <script>
        // Add simple validation and interaction
        document.addEventListener('DOMContentLoaded', function() {
            // Smooth focus effect
            const inputs = document.querySelectorAll('input[type="text"], input[type="password"]');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentElement.classList.add('ring-2', 'ring-blue-200');
                });
                input.addEventListener('blur', function() {
                    this.parentElement.classList.remove('ring-2', 'ring-blue-200');
                });
            });
        });
    </script>
</body>
</html>