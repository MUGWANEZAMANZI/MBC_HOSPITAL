<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.mbc_hospital.model.Patient" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    Integer userID = null;

    if (session != null && session.getAttribute("id") != null) {
        try {
            userID = (Integer) session.getAttribute("id");
        } catch (ClassCastException e) {
        	
        }
    }

    if (userID != null) {
    } else {
    	response.sendRedirect("login.jsp");
        return;
    }
%>
 

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Diagnosis Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <!-- Alpine.js for modal functionality -->
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <style>
        [x-cloak] { display: none !important; }
    </style>
</head>
<body class="bg-gray-50 min-h-screen" x-data="{ 
    showModal: false, 
    selectedPatient: null,
    diagnosisStatus: 'Referrable',
    result: 'Pending'
}">

    <!-- Header -->
    <header class="bg-gradient-to-r from-blue-700 to-blue-900 text-white shadow-xl">
        <div class="container mx-auto py-4 px-6">
            <div class="flex justify-between items-center">
                <div class="flex items-center space-x-3">
                    <i class="fas fa-hospital text-3xl text-blue-200"></i>
                    <h1 class="text-3xl font-bold tracking-tight">MBC HOSPITAL</h1>
                </div>
                <div class="flex items-center space-x-6">
                    <a class="flex items-center px-4 py-2 bg-blue-800 hover:bg-blue-600 rounded-lg transition duration-300 shadow-md" href="nurse.jsp">
                        <i class="fas fa-home mr-2"></i>Home
                    </a>
                    <div class="flex items-center bg-blue-800/50 px-4 py-2 rounded-lg">
                        <i class="fas fa-user-circle text-xl mr-2 text-blue-200"></i>
                        <p>Welcome, <span class="font-semibold"><%= session.getAttribute("username") %></span></p>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="container mx-auto px-4 py-10">
        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <!-- Page Header -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 py-4 px-6">
                <h2 class="text-2xl font-bold text-white flex items-center">
                    <i class="fas fa-stethoscope mr-3"></i>
                    Patient Diagnosis Management
                </h2>
                <p class="text-blue-100 mt-1">Click on a Patient ID to submit or update diagnosis</p>
            </div>

            <!-- Patients Table -->
            <div class="p-6 overflow-x-auto">
                <table class="min-w-full bg-white rounded-lg overflow-hidden">
                    <thead class="bg-gray-100 text-gray-700">
                        <tr>
                            <th class="py-3 px-4 text-left font-semibold">Patient ID</th>
                            <th class="py-3 px-4 text-left font-semibold">Name</th>
                            <th class="py-3 px-4 text-left font-semibold">Telephone</th>
                            <th class="py-3 px-4 text-left font-semibold">Diagnosis Status</th>
                            <th class="py-3 px-4 text-left font-semibold">Result</th>
                            <th class="py-3 px-4 text-left font-semibold">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                     <%
            List<Patient> patients = (List<Patient>) request.getAttribute("patients");
            if (patients != null) {
                for (Patient p : patients) {
        %>
                        <tr class="hover:bg-gray-50 transition duration-150">
                            <td class="py-3 px-4">
                                <button 
                                    @click="showModal = true; selectedPatient = 1001" 
                                    class="text-blue-600 hover:text-blue-800 font-medium hover:underline transition"
                                >
                                    <%= p.getPatientID() %>
                                </button>
                            </td>
                            <td class="py-3 px-4 font-medium"><%= p.getFirstName()%></td>
                            <td class="py-3 px-4"><%= p.getTelephone() %></td>
                            <td class="py-3 px-4">
                                <span class="px-2 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs font-medium">
                                    <%=p.getDiagnosisStatus() %>
                                </span>
                            </td>
                            <td class="py-3 px-4">
                                <span class="text-gray-500">
                                 <%= p.getDiagnosisResult() %>
                                </span>
                            </td>
                            <td class="py-3 px-4">
                                <button 
                                    @click="showModal = true; selectedPatient = <%= p.getPatientID() %>" 
                                    class="px-3 py-1 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition flex items-center text-sm"
                                >
                                    <i class="fas fa-edit mr-1"></i> Diagnose
                                </button>
                            </td>
                        </tr>                        
                        
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="7">No patients found.</td>
        </tr>
        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Diagnosis Modal -->
    <div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" 
         x-show="showModal" 
         x-transition:enter="transition ease-out duration-300"
         x-transition:enter-start="opacity-0"
         x-transition:enter-end="opacity-100"
         x-transition:leave="transition ease-in duration-200"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0"
         x-cloak>
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-md mx-4 overflow-hidden" 
             @click.away="showModal = false"
             x-transition:enter="transition ease-out duration-300"
             x-transition:enter-start="opacity-0 transform scale-95"
             x-transition:enter-end="opacity-100 transform scale-100"
             x-transition:leave="transition ease-in duration-200"
             x-transition:leave-start="opacity-100 transform scale-100"
             x-transition:leave-end="opacity-0 transform scale-95">
            
            <!-- Modal Header -->
            <div class="bg-gradient-to-r from-blue-600 to-blue-800 py-4 px-6">
                <div class="flex justify-between items-center">
                    <h3 class="text-xl font-bold text-white">Submit Diagnosis</h3>
                    <button @click="showModal = false" class="text-white hover:text-blue-200 transition">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <p class="text-blue-100 text-sm mt-1">Patient ID: <span x-text="selectedPatient"></span></p>
            </div>
            
            <!-- Modal Body -->
            <div class="p-6">
                <form id="diagnosisForm" class="space-y-4">
                    <input type="hidden" name="patientID" id="patientID"  x-bind:value='selectedPatient'>
                    <input type="hidden" name="nurse_id" id="nurse_id"  value="<%=userID %>"'>
                    
                    
                    <div class="mb-4">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Diagnosis Status</label>
                        <div class="flex space-x-4">
                            <label class="inline-flex items-center">
                                <input type="radio" name="diagnosisStatus" id="diagnosisStatus" value="Referrable" class="form-radio h-5 w-5 text-blue-600" x-model="diagnosisStatus">
                                <span class="ml-2 text-gray-700">Referrable</span>
                            </label>
                            <label class="inline-flex items-center">
                                <input type="radio" name="diagnosisStatus" id="diagnosisStatus" value="Not Referable" class="form-radio h-5 w-5 text-blue-600" x-model="diagnosisStatus">
                                <span class="ml-2 text-gray-700">Not Referable</span>
                            </label>
                        </div>
                    </div>
                    
                    <div class="mb-6">
                        <label for="result" class="block text-sm font-medium text-gray-700 mb-1">Diagnosis Result</label>
                        <textarea id="result" name="result" rows="3" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200"
                                  placeholder="Enter diagnosis details here..." x-model="result"></textarea>
                    </div>
                    
                    <div class="flex justify-end space-x-3">
                        <button type="button" @click="showModal = false" 
                                class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition duration-300">
                            Cancel
                        </button>
                        <button type="button" @click="showModal = false" 
                                class="px-4 py-2 bg-gradient-to-r from-blue-600 to-blue-700 text-white rounded-lg hover:from-blue-700 hover:to-blue-800 transition duration-300 shadow-md">
                            Submit Diagnosis
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer -->
    
    <script>
    document.addEventListener('DOMContentLoaded', () => {
        const form = document.getElementById('diagnosisForm');
        const nurse_id=document.getElementById("nurse_id").value;
        console.log("jjjjjj",nurse_id)
        const submitBtn = form.querySelector('button[type="button"]:last-of-type');
        
        submitBtn.addEventListener('click', async () => {
            const patientID = document.getElementById('patientID').value;
            const diagnosisStatus = document.querySelector('input[name="diagnosisStatus"]:checked').value; 
            const result = document.getElementById('result').value;

            // Build URL-encoded form data
            const formData = new URLSearchParams();
            formData.append("patientID", patientID);
            formData.append("diagnosisStatus", diagnosisStatus);
            formData.append("result", result);

            try {
                const contextPath = '<%= request.getContextPath() %>'; // resolves to /MBC_HOSPITAL
                const response = await fetch('submitDiagnosis', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: new URLSearchParams({
                        patientID: patientID,
                        diagnosisStatus: diagnosisStatus,
                        result: result,
                        nurseID: nurse_id
                    }).toString()
                });


                if (response.ok) {
                    const result = await response.text();
                    window.location.href = "/MBC_HOSPITAL/patients-dir"
                    alert('Diagnosis submitted successfully!');
                    console.log(result);
                } else {
                    const error = await response.text();
                    alert('Error: ' + error);
                }
            } catch (error) {
                console.error('Submission failed:', error);
                alert('An error occurred while submitting the diagnosis.');
            }
        });
    });

</script>
    
   
</body>
</html>