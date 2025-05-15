<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Login - MBC Hospital</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-color: #f9fafb;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .login-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 1rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            overflow: hidden;
            width: 100%;
            max-width: 28rem;
        }
        .input-group {
            position: relative;
            margin-bottom: 1.5rem;
        }
        .input-group i {
            position: absolute;
            left: 1rem;
            top: 0.85rem;
            color: #a0aec0;
        }
        .form-input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.5rem;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            background-color: white;
            color: #4a5568;
            transition: all 0.3s ease;
        }
        .form-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.25);
        }
        .btn-login {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            border: none;
            border-radius: 0.5rem;
            padding: 0.75rem 1rem;
            width: 100%;
            font-weight: 600;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .btn-login:hover {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            transform: translateY(-1px);
        }
        .error-message {
            background-color: #fed7d7;
            border-left: 4px solid #f56565;
            color: #c53030;
            padding: 1rem;
            margin-bottom: 1.5rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
    <div class="login-container p-8">
        <div class="text-center mb-8">
            <h1 class="text-white text-2xl font-bold mb-2">MBC Hospital</h1>
            <p class="text-white opacity-80">Patient Portal Login</p>
        </div>
        
        <% 
        // Check if there's an error parameter
        String error = request.getParameter("error");
        if (error != null) {
            String errorMessage = "";
            if (error.equals("missing")) {
                errorMessage = "Please enter both your Patient ID and Phone Number.";
            } else if (error.equals("invalid")) {
                errorMessage = "Invalid Patient ID or Phone Number. Please try again.";
            } else if (error.equals("database")) {
                errorMessage = "Database error. Please try again later.";
            }
            if (!errorMessage.isEmpty()) {
        %>
        <div class="error-message">
            <p><i class="fas fa-exclamation-circle mr-2"></i> <%= errorMessage %></p>
        </div>
        <% 
            }
        }
        %>
        
        <form action="patient-login" method="post">
            <div class="input-group">
                <i class="fas fa-id-card"></i>
                <input type="text" name="patientID" class="form-input" placeholder="Patient ID" required>
            </div>
            <div class="input-group">
                <i class="fas fa-phone"></i>
                <input type="tel" name="telephone" class="form-input" placeholder="Phone Number" required>
            </div>
            <button type="submit" class="btn-login">
                <i class="fas fa-sign-in-alt mr-2"></i> Login
            </button>
        </form>
        
        <div class="mt-6 text-center">
            <a href="index.jsp" class="text-white hover:underline text-sm">
                <i class="fas fa-arrow-left mr-1"></i> Back to Home
            </a>
        </div>
    </div>
</body>
</html> 