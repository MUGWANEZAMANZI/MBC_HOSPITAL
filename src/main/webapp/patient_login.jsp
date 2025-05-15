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
            background-image: linear-gradient(135deg, #f5f7fa 0%, #e4ecfb 100%);
        }
        
        .login-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            width: 400px;
            padding: 40px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }
        
        .form-input {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #e5e7eb;
            border-radius: 6px;
            background-color: #f9fafb;
            font-size: 16px;
            transition: all 0.2s;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #3b82f6;
            background-color: #fff;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .btn-primary {
            background-color: #3b82f6;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 12px 16px;
            font-size: 16px;
            width: 100%;
            cursor: pointer;
            transition: background-color 0.2s;
            font-weight: 500;
        }
        
        .btn-primary:hover {
            background-color: #2563eb;
        }
        
        .text-center {
            text-align: center;
        }
        
        .hospital-logo {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 24px;
        }
        
        .hospital-logo i {
            font-size: 36px;
            color: #3b82f6;
            margin-right: 12px;
        }
        
        .hospital-logo h1 {
            font-size: 24px;
            font-weight: 700;
            color: #1e3a8a;
        }
        
        .toggle-link {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 500;
        }
        
        .toggle-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="hospital-logo">
            <i class="fas fa-hospital"></i>
            <h1>MBC Hospital</h1>
        </div>
        
        <h2 class="text-center" style="font-size: 22px; margin-bottom: 24px;">Patient Portal Login</h2>
        
        <% if (request.getParameter("error") != null) { %>
            <div style="background-color: #fee2e2; border-left: 4px solid #ef4444; padding: 12px; margin-bottom: 20px; border-radius: 6px;">
                <div style="display: flex; align-items: center;">
                    <i class="fas fa-exclamation-circle" style="color: #ef4444; margin-right: 8px;"></i>
                    <p style="color: #b91c1c; font-size: 14px; margin: 0;">Login failed. Please check your information and try again.</p>
                </div>
            </div>
        <% } %>
        
        <form method="post" action="patient-login">
            <div class="form-group">
                <label for="telephone" class="form-label">Phone Number</label>
                <div style="position: relative;">
                    <i class="fas fa-phone" style="position: absolute; left: 12px; top: 12px; color: #6b7280;"></i>
                    <input type="tel" name="telephone" id="telephone" 
                           class="form-input" style="padding-left: 36px;"
                           placeholder="Enter your phone number" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="patientID" class="form-label">Patient ID</label>
                <div style="position: relative;">
                    <i class="fas fa-id-card" style="position: absolute; left: 12px; top: 12px; color: #6b7280;"></i>
                    <input type="text" name="patientID" id="patientID" 
                           class="form-input" style="padding-left: 36px;"
                           placeholder="Enter your patient ID" required>
                </div>
            </div>
            
            <button type="submit" class="btn-primary">
                <i class="fas fa-sign-in-alt" style="margin-right: 8px;"></i>
                Access My Records
            </button>
        </form>
        
        <div style="margin-top: 24px; text-align: center;">
            <p style="font-size: 14px; color: #6b7280;">
                Staff member? 
                <a href="login.jsp" class="toggle-link">
                    Login here <i class="fas fa-arrow-right" style="font-size: 12px; margin-left: 4px;"></i>
                </a>
            </p>
        </div>
        
        <div style="margin-top: 24px; padding-top: 20px; border-top: 1px solid #e5e7eb;">
            <p style="font-size: 13px; text-align: center; color: #9ca3af;">
                Need help? Contact our support team at <span style="color: #4b5563;">support@mbchospital.com</span>
            </p>
        </div>
    </div>
</body>
</html> 