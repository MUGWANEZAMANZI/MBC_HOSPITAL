<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/header.jsp">
        <jsp:param name="title" value="Registration" />
    </jsp:include>
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
        
        .register-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
            width: 450px;
            padding: 40px;
            margin: 40px 0;
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
        
        .form-input, .form-select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #e5e7eb;
            border-radius: 4px;
            background-color: #f3f4f6;
            font-size: 16px;
        }
        
        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: #3b82f6;
            background-color: #fff;
        }
        
        .form-checkbox {
            border-radius: 4px;
            width: 16px;
            height: 16px;
            accent-color: #3b82f6;
        }
        
        .btn-primary {
            background-color: #3b82f6;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 12px 16px;
            font-size: 16px;
            width: 100%;
            cursor: pointer;
            transition: background-color 0.2s;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-primary:hover {
            background-color: #2563eb;
        }
        
        .text-center {
            text-align: center;
        }
        
        .login-link {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 500;
        }
        
        .login-link:hover {
            text-decoration: underline;
        }
        
        .form-row {
            display: flex;
            gap: 16px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .error-message {
            background-color: #fee2e2;
            color: #b91c1c;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 16px;
            font-size: 14px;
            border-left: 4px solid #ef4444;
        }
    </style>
</head>
<body>
    <div class="register-card">
        <h2 class="text-center" style="font-size: 24px; margin-bottom: 8px;">Create Account</h2>
        <p style="text-align: center; color: #6b7280; margin-bottom: 24px; font-size: 14px;">Join MBC Hospital's digital healthcare platform</p>
        
        <% 
        String error = request.getParameter("error");
        if (error != null) {
            String errorMessage = "";
            if (error.equals("first_name_required")) {
                errorMessage = "First name is required";
            } else if (error.equals("last_name_required")) {
                errorMessage = "Last name is required";
            } else if (error.equals("server")) {
                errorMessage = "Server error occurred. Please try again.";
            } else if (error.equals("validation")) {
                errorMessage = "Username and password should be at least 3 characters long";
            } else if (error.equals("profile_creation_failed")) {
                errorMessage = "Failed to create user profile. Please try again.";
            } else if (error.equals("missing_required_fields")) {
                errorMessage = "Please fill all required fields";
            } else if (error.equals("failed")) {
                errorMessage = "Registration failed. Please try again.";
            }
            
            if (!errorMessage.isEmpty()) {
        %>
            <div class="error-message">
                <%= errorMessage %>
            </div>
        <% 
            }
        }
        %>
        
        <form method="post" action="registration">
            <div class="form-group">
                <label for="userType" class="form-label">I am a:</label>
                <div style="position: relative;">
                    <i class="fas fa-user-md" style="position: absolute; left: 12px; top: 12px; color: #6b7280;"></i>
                    <select id="userType" name="userType" class="form-select" style="padding-left: 36px;" required>
                        <option value="">Select User Type</option>
                        <option value="Doctor">Doctor</option>
                        <option value="Nurse">Nurse</option>
                        <option value="Patient">Patient</option>
                    </select>
                </div>
            </div>
            
            <!-- New form row for First and Last name -->
            <div class="form-row">
                <div class="form-group">
                    <label for="firstName" class="form-label">First Name</label>
                    <div style="position: relative;">
                        <i class="fas fa-user" style="position: absolute; left: 12px; top: 12px; color: #6b7280;"></i>
                        <input type="text" id="firstName" name="firstName" class="form-input" style="padding-left: 36px;" placeholder="First name" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="lastName" class="form-label">Last Name</label>
                    <div style="position: relative;">
                        <i class="fas fa-user" style="position: absolute; left: 12px; top: 12px; color: #6b7280;"></i>
                        <input type="text" id="lastName" name="lastName" class="form-input" style="padding-left: 36px;" placeholder="Last name" required>
                    </div>
                </div>
            </div>
            
            <div class="form-group">
                <label for="email" class="form-label">Email</label>
                <div style="position: relative;">
                    <i class="fas fa-envelope" style="position: absolute; left: 12px; top: 12px; color: #6b7280;"></i>
                    <input type="email" id="email" name="email" class="form-input" style="padding-left: 36px;" placeholder="your.email@example.com">
                </div>
            </div>
            
            <div class="form-group">
                <label for="telephone" class="form-label">Telephone</label>
                <div style="position: relative;">
                    <i class="fas fa-phone" style="position: absolute; left: 12px; top: 12px; color: #6b7280;"></i>
                    <input type="tel" id="telephone" name="telephone" class="form-input" style="padding-left: 36px;" placeholder="Phone number">
                </div>
            </div>
            
            <div class="form-group">
                <label for="address" class="form-label">Address</label>
                <div style="position: relative;">
                    <i class="fas fa-home" style="position: absolute; left: 12px; top: 12px; color: #6b7280;"></i>
                    <input type="text" id="address" name="address" class="form-input" style="padding-left: 36px;" placeholder="Your address">
                </div>
            </div>
            
            <div id="hospitalNameGroup" class="form-group" style="display: none;">
                <label for="hospitalName" class="form-label">Hospital Name</label>
                <div style="position: relative;">
                    <i class="fas fa-hospital" style="position: absolute; left: 12px; top: 12px; color: #6b7280;"></i>
                    <input type="text" id="hospitalName" name="hospitalName" class="form-input" style="padding-left: 36px;" placeholder="Hospital name">
                </div>
            </div>
            
            <div class="form-group">
                <label for="username" class="form-label">Username</label>
                <div style="position: relative;">
                    <i class="fas fa-user" style="position: absolute; left: 12px; top: 12px; color: #6b7280;"></i>
                    <input type="text" id="username" name="uname" class="form-input" style="padding-left: 36px;" placeholder="Enter your username" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="password" class="form-label">Password</label>
                <div style="position: relative;">
                    <i class="fas fa-lock" style="position: absolute; left: 12px; top: 12px; color: #6b7280;"></i>
                    <input type="password" id="password" name="pass" class="form-input" style="padding-left: 36px;" placeholder="Create a strong password" required>
                </div>
            </div>
            
            <div style="display: flex; align-items: center; margin-bottom: 24px;">
                <input id="terms" name="terms" type="checkbox" class="form-checkbox" required>
                <label for="terms" style="margin-left: 8px; font-size: 14px; color: #4b5563;">
                    I agree to the <a href="#" style="color: #3b82f6; text-decoration: none;">Terms and Conditions</a>
                </label>
            </div>
            
            <button type="submit" class="btn-primary">
                Register Now
                <i class="fas fa-arrow-right" style="margin-left: 8px;"></i>
            </button>
            
            <div style="margin-top: 24px; text-align: center;">
                <p style="font-size: 14px; color: #6b7280;">
                    Already have an account? 
                    <a href="login.jsp" class="login-link">
                        Sign in
                    </a>
                </p>
            </div>
        </form>
    </div>
    
    <script>
        // Toggle hospital name field visibility based on user type
        document.getElementById('userType').addEventListener('change', function() {
            const userType = this.value;
            const hospitalNameGroup = document.getElementById('hospitalNameGroup');
            
            if (userType === 'Doctor' || userType === 'Nurse') {
                hospitalNameGroup.style.display = 'block';
                if (userType === 'Doctor') {
                    document.querySelector('label[for="hospitalName"]').textContent = 'Hospital Name';
                } else {
                    document.querySelector('label[for="hospitalName"]').textContent = 'Health Center';
                }
            } else {
                hospitalNameGroup.style.display = 'none';
            }
        });
    </script>
</body>
</html>