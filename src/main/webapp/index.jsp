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
            <p class="text-gray-600">Easy navigation to all diagnosis-related pages</p>
        </div>
        
        <div class="bg-white rounded-lg shadow-md overflow-hidden">
            <div class="px-6 py-4 bg-blue-600 text-white">
                <h2 class="font-bold text-xl flex items-center">
                    <i class="fas fa-stethoscope mr-2"></i> Diagnosis Navigation
                </h2>
            </div>
            
            <div class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <!-- Doctor Dashboard -->
                    <div class="bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-md transition overflow-hidden">
                        <div class="p-5 bg-blue-50 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-800 flex items-center">
                                <i class="fas fa-user-md text-blue-600 mr-2"></i> Doctor Dashboard
                            </h3>
                        </div>
                        <div class="p-5">
                            <p class="text-gray-600 mb-4">Main doctor dashboard with patient diagnosis functionality</p>
                            <a href="doctor.jsp" class="inline-flex items-center px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition">
                                Go to Page <i class="fas fa-arrow-right ml-2"></i>
                            </a>
                        </div>
                    </div>
                    
                    <!-- Awaiting Diagnosis -->
                    <div class="bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-md transition overflow-hidden">
                        <div class="p-5 bg-amber-50 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-800 flex items-center">
                                <i class="fas fa-clipboard-check text-amber-600 mr-2"></i> Awaiting Diagnosis
                            </h3>
                        </div>
                        <div class="p-5">
                            <p class="text-gray-600 mb-4">Cases referred for diagnosis by doctors</p>
                            <a href="referred-diagnoses" class="inline-flex items-center px-4 py-2 bg-amber-600 text-white rounded-md hover:bg-amber-700 transition">
                                Go to Page <i class="fas fa-arrow-right ml-2"></i>
                            </a>
                        </div>
                    </div>
                    
                    <!-- All Patients -->
                    <div class="bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-md transition overflow-hidden">
                        <div class="p-5 bg-green-50 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-800 flex items-center">
                                <i class="fas fa-hospital-user text-green-600 mr-2"></i> All Patients
                            </h3>
                        </div>
                        <div class="p-5">
                            <p class="text-gray-600 mb-4">Complete patient list with diagnosis options</p>
                            <a href="all-patients" class="inline-flex items-center px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 transition">
                                Go to Page <i class="fas fa-arrow-right ml-2"></i>
                            </a>
                        </div>
                    </div>
                    
                    <!-- Diagnosis Records -->
                    <div class="bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-md transition overflow-hidden">
                        <div class="p-5 bg-indigo-50 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-800 flex items-center">
                                <i class="fas fa-notes-medical text-indigo-600 mr-2"></i> Diagnosis Records
                            </h3>
                        </div>
                        <div class="p-5">
                            <p class="text-gray-600 mb-4">View all diagnosis records in the system</p>
                            <a href="DiagnosisViewServlet" class="inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 transition">
                                Go to Page <i class="fas fa-arrow-right ml-2"></i>
                            </a>
                        </div>
                    </div>
                    
                    <!-- Confirmed Cases -->
                    <div class="bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-md transition overflow-hidden">
                        <div class="p-5 bg-purple-50 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-800 flex items-center">
                                <i class="fas fa-check-circle text-purple-600 mr-2"></i> Confirmed Cases
                            </h3>
                        </div>
                        <div class="p-5">
                            <p class="text-gray-600 mb-4">View all confirmed diagnosis cases</p>
                            <a href="confirmed-cases" class="inline-flex items-center px-4 py-2 bg-purple-600 text-white rounded-md hover:bg-purple-700 transition">
                                Go to Page <i class="fas fa-arrow-right ml-2"></i>
                            </a>
                        </div>
                    </div>
                    
                    <!-- Patient Portal -->
                    <div class="bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-md transition overflow-hidden">
                        <div class="p-5 bg-teal-50 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-800 flex items-center">
                                <i class="fas fa-user-injured text-teal-600 mr-2"></i> Patient Portal
                            </h3>
                        </div>
                        <div class="p-5">
                            <p class="text-gray-600 mb-4">Access your diagnosis results and medical records</p>
                            <a href="patient_login.jsp" class="inline-flex items-center px-4 py-2 bg-teal-600 text-white rounded-md hover:bg-teal-700 transition">
                                Go to Page <i class="fas fa-arrow-right ml-2"></i>
                            </a>
                        </div>
                    </div>
                    
                    <!-- Login Page -->
                    <div class="bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-md transition overflow-hidden">
                        <div class="p-5 bg-red-50 border-b border-gray-200">
                            <h3 class="text-lg font-semibold text-gray-800 flex items-center">
                                <i class="fas fa-sign-in-alt text-red-600 mr-2"></i> Staff Login
                            </h3>
                        </div>
                        <div class="p-5">
                            <p class="text-gray-600 mb-4">Login to the MBC Hospital system</p>
                            <a href="login.jsp" class="inline-flex items-center px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 transition">
                                Go to Page <i class="fas fa-arrow-right ml-2"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="mt-8 text-center text-gray-500 text-sm">
            <p>&copy; <%= java.time.Year.now().getValue() %> MBC Hospital. All rights reserved.</p>
        </div>
    </div>
</body>
</html> 