<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Schedule Appointment</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-6">
    <div class="max-w-xl mx-auto bg-white p-6 rounded-lg shadow-md">
        <h1 class="text-2xl font-bold text-center text-blue-700 mb-4">Schedule Appointment</h1>

        <form action="schedule" method="post" onsubmit="return validateForm()">
            <div class="mb-4">
                <label class="block text-gray-700 font-medium mb-1">Patient Name</label>
                <input type="text" name="patientName" required class="w-full px-3 py-2 border rounded">
            </div>

            <div class="mb-4">
                <label class="block text-gray-700 font-medium mb-1">Email</label>
                <input type="email" name="email" required class="w-full px-3 py-2 border rounded">
            </div>

            <div class="mb-4">
                <label class="block text-gray-700 font-medium mb-1">Appointment Type</label>
                <select name="appointmentType" required class="w-full px-3 py-2 border rounded">
                    <option value="General Checkup">General Checkup</option>
                    <option value="Specialist Consultation">Specialist Consultation</option>
                </select>
            </div>

            <div class="mb-4">
                <label class="block text-gray-700 font-medium mb-1">Doctor</label>
                <select name="doctor" required class="w-full px-3 py-2 border rounded">
                    <option value="${param.doctor}">${param.doctor}</option>
                    <option value="Dr. Smith">Dr. Smith</option>
                    <option value="Dr. Johnson">Dr. Johnson</option>
                    <option value="Dr. Williams">Dr. Williams</option>
                </select>
            </div>

            <div class="mb-4">
                <label class="block text-gray-700 font-medium mb-1">Date</label>
                <input type="date" name="date" required class="w-full px-3 py-2 border rounded">
            </div>

            <div class="mb-4">
                <label class="block text-gray-700 font-medium mb-1">Time</label>
                <input type="time" name="time" required class="w-full px-3 py-2 border rounded">
            </div>

            <div class="mb-6">
                <label class="block text-gray-700 font-medium mb-1">Reason</label>
                <textarea name="reason" rows="3" required class="w-full px-3 py-2 border rounded"></textarea>
            </div>

            <div class="text-center">
                <button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 transition">
                    Submit
                </button>
            </div>
        </form>
    </div>

    <script>
        function validateForm() {
            // Optionally add form validation here
            return true;
        }
    </script>
</body>
</html>
