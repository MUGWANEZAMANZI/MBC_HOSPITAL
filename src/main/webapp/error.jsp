<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - MBC Hospital</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-white rounded-lg shadow-lg p-8 max-w-md w-full">
        <div class="text-center mb-6">
            <div class="inline-flex h-20 w-20 rounded-full bg-red-100 text-red-500 items-center justify-center mb-4">
                <i class="fas fa-exclamation-triangle text-4xl"></i>
            </div>
            <h1 class="text-2xl font-bold text-gray-800 mb-2">Error Occurred</h1>
            <p class="text-gray-600">
                <%= exception != null ? exception.getMessage() : "An unexpected error occurred" %>
            </p>
        </div>
        
        <div class="border-t border-gray-200 pt-4">
            <p class="text-gray-600 mb-4">
                Please try again later or contact the system administrator if the problem persists.
            </p>
            
            <div class="flex flex-col space-y-3">
                <a href="index.jsp" class="bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700 transition flex items-center justify-center">
                    <i class="fas fa-home mr-2"></i> Return to Home
                </a>
                
                <a href="javascript:history.back()" class="bg-gray-200 text-gray-700 py-2 px-4 rounded hover:bg-gray-300 transition flex items-center justify-center">
                    <i class="fas fa-arrow-left mr-2"></i> Go Back
                </a>
            </div>
        </div>
    </div>
</body>
</html> 