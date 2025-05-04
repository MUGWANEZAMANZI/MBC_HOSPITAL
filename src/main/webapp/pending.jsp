<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Pending Verification</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .container {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 600px;
            padding: 40px;
            text-align: center;
        }
        h1 {
            color: #2c3e50;
            margin-bottom: 20px;
        }
        p {
            color: #555;
            line-height: 1.6;
            margin-bottom: 20px;
        }
        .icon {
            font-size: 60px;
            color: #f39c12;
            margin-bottom: 20px;
        }
        .email {
            font-weight: bold;
            color: #3498db;
        }
        .btn {
            display: inline-block;
            background-color: #3498db;
            color: white;
            padding: 12px 24px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
            margin-top: 20px;
        }
        .btn:hover {
            background-color: #2980b9;
        }
        .status-badge {
            display: inline-block;
            background-color: #f39c12;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            margin-bottom: 30px;
        }
        .contact-info {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon">⏳</div>
        <span class="status-badge">Pending Verification</span>
        <h1>Your Account is under review</h1>
        
        <p>Thank you for submitting a request. Your account is being review by admin.</p>
        
        <p>to prevent illegal registrations the account registration request must be reviewed by system administrator.</p>
        
        <div class="contact-info">
            <p>If it's taking longer than expected or you have any questions, please system administrator at:</p>
            <p class="email">support@mbchospital.com</p>
        </div>
        
        <a href="login.jsp" class="btn">Return to Login Page</a>
    </div>
</body>
</html>