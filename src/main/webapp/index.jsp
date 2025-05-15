<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MBC Hospital Diagnosis Portal</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="assets/js/diagnosis.js"></script>
</head>
<body class="bg-gray-100 min-h-screen">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="mb-10 text-center">
            <h1 class="text-3xl font-bold text-gray-900 mb-2">MBC Hospital Diagnosis Portal</h1>
            <p class="text-gray-600">Easy navigation to all diagnosis-related services</p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <!-- Doctor Portal -->
            <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">
                <div class="bg-gradient-to-r from-blue-500 to-blue-700 p-6">
                    <div class="flex items-center justify-center h-16 w-16 bg-white rounded-full mx-auto mb-4">
                        <i class="fas fa-user-md text-3xl text-blue-600"></i>
                    </div>
                    <h2 class="text-xl font-bold text-white text-center">Doctor Portal</h2>
                </div>
                <div class="p-6">
                    <p class="text-gray-600 mb-6 text-center">Access the doctor dashboard to manage patient diagnoses and treatments.</p>
                    <div class="flex justify-center">
                        <a href="login.jsp?type=doctor" class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors duration-300">
                            <i class="fas fa-sign-in-alt mr-2"></i> Login as Doctor
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Nurse Portal -->
            <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">
                <div class="bg-gradient-to-r from-green-500 to-green-700 p-6">
                    <div class="flex items-center justify-center h-16 w-16 bg-white rounded-full mx-auto mb-4">
                        <i class="fas fa-user-nurse text-3xl text-green-600"></i>
                    </div>
                    <h2 class="text-xl font-bold text-white text-center">Nurse Portal</h2>
                </div>
                <div class="p-6">
                    <p class="text-gray-600 mb-6 text-center">Access the nurse dashboard to manage patient assessments and care.</p>
                    <div class="flex justify-center">
                        <a href="login.jsp?type=nurse" class="inline-flex items-center px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition-colors duration-300">
                            <i class="fas fa-sign-in-alt mr-2"></i> Login as Nurse
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Admin Portal -->
            <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">
                <div class="bg-gradient-to-r from-purple-500 to-purple-700 p-6">
                    <div class="flex items-center justify-center h-16 w-16 bg-white rounded-full mx-auto mb-4">
                        <i class="fas fa-user-shield text-3xl text-purple-600"></i>
                    </div>
                    <h2 class="text-xl font-bold text-white text-center">Admin Portal</h2>
                </div>
                <div class="p-6">
                    <p class="text-gray-600 mb-6 text-center">Access the admin dashboard to manage users, reports, and system settings.</p>
                    <div class="flex justify-center">
                        <a href="login.jsp?type=admin" class="inline-flex items-center px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700 transition-colors duration-300">
                            <i class="fas fa-sign-in-alt mr-2"></i> Login as Admin
                        </a>
                    </div>
                </div>
            </div>
            
            <!-- Patient Portal -->
            <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">
                <div class="bg-gradient-to-r from-amber-500 to-amber-700 p-6">
                    <div class="flex items-center justify-center h-16 w-16 bg-white rounded-full mx-auto mb-4">
                        <i class="fas fa-user text-3xl text-amber-600"></i>
                    </div>
                    <h2 class="text-xl font-bold text-white text-center">Patient Portal</h2>
                </div>
                <div class="p-6">
                    <p class="text-gray-600 mb-6 text-center">Access your medical records, diagnosis results, and personal information.</p>
                    <div class="flex justify-center">
                        <a href="patient_login.jsp" class="inline-flex items-center px-4 py-2 bg-amber-600 text-white rounded-md hover:bg-amber-700 transition-colors duration-300">
                            <i class="fas fa-sign-in-alt mr-2"></i> Patient Login
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html> 