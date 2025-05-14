<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="/common/header.jsp">
        <jsp:param name="title" value="Login" />
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
        
        .login-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
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
            border-radius: 4px;
            background-color: #f3f4f6;
            font-size: 16px;
        }
        
        .form-input:focus {
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
            padding: 10px 16px;
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
        
        .social-buttons {
            display: flex;
            justify-content: center;
            gap: 12px;
            margin-top: 24px;
        }
        
        .social-button {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #f3f4f6;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
            cursor: pointer;
        }
        
        .forgot-password {
            color: #3b82f6;
            text-decoration: none;
            font-size: 14px;
        }
        
        .forgot-password:hover {
            text-decoration: underline;
        }
        
        .register-link {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 500;
        }
        
        .register-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <h2 class="text-center" style="font-size: 24px; margin-bottom: 24px;">Sign In to Your Account</h2>
        
        <% if (request.getParameter("error") != null) { %>
            <div style="background-color: #fee2e2; border-left: 4px solid #ef4444; padding: 12px; margin-bottom: 20px; border-radius: 4px;">
                <div style="display: flex; align-items: center;">
                    <i class="fas fa-exclamation-circle" style="color: #ef4444; margin-right: 8px;"></i>
                    <p style="color: #b91c1c; font-size: 14px; margin: 0;">Login failed. Please check your credentials and try again.</p>
                </div>
            </div>
        <% } %>
        
        <form method="post" action="login">
            <div class="form-group">
                <label for="username" class="form-label">Username</label>
                <div style="position: relative;">
                    <i class="fas fa-user" style="position: absolute; left: 12px; top: 12px; color: #6b7280;"></i>
                    <input type="text" name="username" id="username" 
                           class="form-input" style="padding-left: 36px;"
                           placeholder="Enter your username" required>
                </div>
            </div>
            
            <div class="form-group">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                    <label for="password" class="form-label" style="margin-bottom: 0;">Password</label>
                    <a href="#" class="forgot-password">Forgot password?</a>
                </div>
                <div style="position: relative;">
                    <i class="fas fa-lock" style="position: absolute; left: 12px; top: 12px; color: #6b7280;"></i>
                    <input type="password" name="password" id="password" 
                           class="form-input" style="padding-left: 36px;"
                           placeholder="Enter your password" required>
                </div>
            </div>
            
            <div style="display: flex; align-items: center; margin-bottom: 20px;">
                <input id="remember-me" name="remember-me" type="checkbox" 
                       class="form-checkbox">
                <label for="remember-me" style="margin-left: 8px; font-size: 14px; color: #4b5563;">
                    Remember me on this device
                </label>
            </div>
            
            <button type="submit" class="btn-primary">
                <i class="fas fa-sign-in-alt" style="margin-right: 8px;"></i>
                Sign in to your account
            </button>
        </form>
        
        <div style="margin-top: 24px; text-align: center;">
            <p style="font-size: 14px; color: #6b7280;">
                Don't have an account? 
                <a href="registration.jsp" class="register-link">
                    Register now <i class="fas fa-arrow-right" style="font-size: 12px; margin-left: 4px;"></i>
                </a>
            </p>
        </div>
        
        <div style="margin-top: 28px; padding-top: 20px; border-top: 1px solid #e5e7eb;">
            <div class="social-buttons">
                <button class="social-button">
                    <i class="fab fa-google" style="color: #6b7280;"></i>
                </button>
                <button class="social-button">
                    <i class="fab fa-facebook-f" style="color: #6b7280;"></i>
                </button>
                <button class="social-button">
                    <i class="fab fa-apple" style="color: #6b7280;"></i>
                </button>
            </div>
            <p style="margin-top: 12px; font-size: 12px; text-align: center; color: #9ca3af;">Or continue with these social profiles</p>
        </div>
    </div>
</body>
</html>