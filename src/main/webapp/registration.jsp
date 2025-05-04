<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MBC - Registration</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .bg-gradient {
            background: linear-gradient(135deg, #3b82f6, #1e40af);
        }
        .card-shadow {
            box-shadow: 0 10px 25px -5px rgba(59, 130, 246, 0.5);
        }
        .form-input:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.3);
            outline: none;
        }
    </style>
</head>
<body class="bg-blue-50 min-h-screen flex flex-col">
    <header class="bg-gradient text-white py-6 shadow-lg">
        <div class="container mx-auto px-4 flex items-center justify-between">
            <div class="flex items-center">
                <i class="fas fa-hospital-alt text-3xl mr-4"></i>
                <h1 class="text-2xl font-bold">MBC Hospital</h1>
            </div>
            <% //<nav class="hidden md:block">
                //<ul class="flex space-x-6">
                    // <li><a href="#" class="hover:text-blue-200 transition">Home</a></li>
                   // <li><a href="#" class="hover:text-blue-200 transition">Services</a></li>
                   // <li><a href="#" class="hover:text-blue-200 transition">Contact</a></li>
                //</ul>
            //</nav>
            %>
        </div>
    </header>

    <main class="flex-grow flex justify-center items-center p-4">
        <div class="flex flex-col md:flex-row bg-white rounded-2xl overflow-hidden my-10  max-w-4xl w-full">
            <!-- Left side - Form -->
            <div class="p-8 md:p-12 md:w-1/2">
                <h1 class="text-2xl md:text-3xl font-bold text-blue-700 mb-6">Create Account</h1>
                <p class="text-gray-600 mb-8">Join MBC Hospital's digital healthcare platform</p>
                
                <form method="post" action="registration" class="space-y-6">
                    <div>
                        <label for="userType" class="block text-sm font-medium text-gray-700 mb-1">I am a:</label>
                        <select id="userType" name="userType" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:border-blue-500 form-input bg-gray-50">
                            <option value="">Select User Type</option>
                            <option value="Doctor">Admin</option>
                            <option value="Doctor">Doctor</option>
                            <option value="Nurse">Nurse</option>
                            <option value="Patient">Patient</option>
                        </select>
                    </div>
                    
                    <div>
                        <label for="username" class="block text-sm font-medium text-gray-700 mb-1">Username</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-user text-gray-400"></i>
                            </div>
                            <input type="text" id="username" name="uname" class="w-full pl-10 pr-4 py-3 rounded-lg border border-gray-300 focus:border-blue-500 form-input" placeholder="Enter your username" required>
                        </div>
                    </div>
                    
                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-lock text-gray-400"></i>
                            </div>
                            <input type="password" id="password" name="pass" class="w-full pl-10 pr-4 py-3 rounded-lg border border-gray-300 focus:border-blue-500 form-input" placeholder="Create a strong password" required>
                        </div>
                    </div>
                    
                    <div class="flex items-center">
                        <input id="terms" name="terms" type="checkbox" class="h-4 w-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500" required>
                        <label for="terms" class="ml-2 block text-sm text-gray-700">
                            I agree to the <a href="#" class="text-blue-600 hover:underline">Terms and Conditions</a>
                        </label>
                    </div>
                    
                    <div>
                        <button type="submit" class="w-full bg-blue-600 hover:bg-blue-700 focus:bg-blue-700 text-white font-medium py-3 px-4 rounded-lg transition flex items-center justify-center">
                            <span>Register Now</span>
                            <i class="fas fa-arrow-right ml-2"></i>
                        </button>
                    </div>
                    
                    <div class="text-center text-gray-500 text-sm">
                        Already have an account? <a href="#" class="text-blue-600 hover:underline">Sign in</a>
                    </div>
                </form>
            </div>
            
            <!-- Right side - Image -->
            <div class="hidden md:block md:w-1/2 bg-blue-700 relative">
                <div class="absolute inset-0 bg-gradient-to-br from-blue-600/70 to-blue-900/90 flex flex-col justify-center items-center text-white p-12">
                    <img src="images/hospital.jpg" alt="Hospital" class="w-64 mb-8 rounded-lg shadow-lg">
                    <h2 class="text-2xl font-bold mb-4">Healthcare Excellence</h2>
                    <p class="text-center mb-6">Join our digital platform for seamless healthcare services and management.</p>
                    <div class="flex space-x-3">
                        <span class="h-2 w-2 rounded-full bg-white opacity-50"></span>
                        <span class="h-2 w-6 rounded-full bg-white"></span>
                        <span class="h-2 w-2 rounded-full bg-white opacity-50"></span>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <footer class="bg-gray-800 mt-20 text-white py-8">
        <div class="container mx-auto px-4">
            <div class="flex flex-col md:flex-row justify-between items-center">
                <div class="mb-4 md:mb-0">
                    <h3 class="font-bold text-lg mb-2">MBC Hospital</h3>
                    <p class="text-gray-400">Providing quality healthcare since 1995</p>
                </div>
                <div class="flex space-x-4">
                    <a href="#" class="hover:text-blue-400 transition"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="hover:text-blue-400 transition"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="hover:text-blue-400 transition"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="hover:text-blue-400 transition"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
            <div class="border-t border-gray-700 mt-6 pt-6 text-center text-gray-400">
                <p>Team 1 &copy; 2025 All rights reserved</p>
            </div>
        </div>
    </footer>
</body>
</html>