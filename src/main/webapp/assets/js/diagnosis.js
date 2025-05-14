/**
 * MBC Hospital Diagnosis System - Common Diagnosis Functions
 * This file contains shared JS functions for diagnosis operations across the application
 */

/**
 * Opens a diagnosis modal for a specific patient
 * @param {string|number} patientId - The ID of the patient to diagnose
 * @param {string} patientName - The name of the patient
 * @param {Element} modalElement - The modal element to open (if not provided, redirects to update-diagnosis)
 */
function openDiagnosis(patientId, patientName, modalElement) {
    // If no modal element provided, redirect to the update-diagnosis endpoint
    if (!modalElement) {
        window.location.href = `update-diagnosis?id=${patientId}`;
        return;
    }
    
    // If we have a modal element, display it
    if (typeof modalElement === 'string') {
        modalElement = document.getElementById(modalElement);
    }

    // Set patient information
    const patientIdField = document.getElementById('patientID');
    const patientNameField = document.getElementById('patientName');
    const diagnosisIdField = document.getElementById('diagnosisID');
    
    if (patientIdField) patientIdField.value = patientId;
    if (patientNameField) patientNameField.textContent = patientName;
    if (diagnosisIdField) diagnosisIdField.value = patientId;
    
    // Show the modal
    if (modalElement) {
        modalElement.classList.remove('hidden');
        document.body.style.overflow = 'hidden';
        
        // Load nurse assessment if needed
        const nurseAssessmentField = document.getElementById('nurseAssessment');
        if (nurseAssessmentField) {
            nurseAssessmentField.innerHTML = '<div class="flex justify-center"><div class="animate-pulse text-blue-400"><i class="fas fa-spinner fa-spin mr-2"></i> Loading assessment...</div></div>';
            
            // In a real app, we would fetch the assessment from the server
            // For now, load sample data after a delay
            setTimeout(function() {
                const assessments = [
                    'Patient presented with fever and cough. Initial vital signs: Temp 38.5°C, BP 130/85, HR 92. Oxygen saturation 96%. Auscultation revealed mild wheezing in both lungs. Initial assessment suggests possible respiratory infection. Awaiting doctor\'s diagnosis.',
                    'Patient complains of severe headache and fatigue for past 3 days. No fever present. BP slightly elevated at 140/90. Patient reports sensitivity to light. No history of migraines. Transferred for further evaluation.',
                    'Patient experiencing shortness of breath and chest pain. ECG shows normal sinus rhythm. Oxygen saturation 94%. History of asthma. No signs of cyanosis. Requires medical evaluation to rule out cardiac involvement.',
                    'Patient presenting with nausea, vomiting, and abdominal pain concentrated in lower right quadrant. Temperature 37.8°C. Tenderness on palpation. High suspicion for appendicitis. Immediate doctor review requested.'
                ];
                    
                // Select a random assessment
                const randomAssessment = assessments[Math.floor(Math.random() * assessments.length)];
                
                // Display with a fade-in effect
                nurseAssessmentField.style.opacity = '0';
                nurseAssessmentField.textContent = randomAssessment;
                
                // Fade in
                setTimeout(function() {
                    nurseAssessmentField.style.transition = 'opacity 0.5s ease';
                    nurseAssessmentField.style.opacity = '1';
                }, 50);
            }, 700);
        }
        
        // Focus on the first input field after a short delay
        setTimeout(function() {
            const firstInput = modalElement.querySelector('input[name="diagnoStatus"]');
            if (firstInput) firstInput.focus();
        }, 300);
    }
}

/**
 * Closes a diagnosis modal
 * @param {Element} modalElement - The modal element to close
 */
function closeDiagnosisModal(modalElement) {
    if (typeof modalElement === 'string') {
        modalElement = document.getElementById(modalElement);
    }
    
    if (!modalElement) return;
    
    // Add closing animation
    const modalContent = modalElement.querySelector('.modal-content');
    if (modalContent) {
        modalContent.style.opacity = '0';
        modalContent.style.transform = 'scale(0.95)';
    }
    
    // Delay hiding the modal to allow for animation
    setTimeout(function() {
        modalElement.classList.add('hidden');
        document.body.style.overflow = 'auto';
        
        // Reset form
        const form = modalElement.querySelector('form');
        if (form) form.reset();
        
        // Reset animation properties
        if (modalContent) {
            modalContent.style.opacity = '1';
            modalContent.style.transform = 'scale(1)';
        }
    }, 200);
}

/**
 * Submits a diagnosis form
 * @param {HTMLFormElement} form - The form element to submit
 * @param {string} redirectUrl - URL to redirect to after successful submission
 */
async function submitDiagnosis(form, redirectUrl) {
    if (!form) return;
    
    // Gather form data
    const patientID = form.querySelector('[name="patientID"]').value;
    const diagnosisID = form.querySelector('[name="diagnosisID"]')?.value || patientID;
    const diagnoStatus = form.querySelector('input[name="diagnoStatus"]:checked').value; 
    const result = form.querySelector('[name="result"]').value;
    const nurseID = form.querySelector('[name="nurseID"]')?.value;
    const medicationsPrescribed = form.querySelector('[name="medicationsPrescribed"]')?.value || '';
    const followUpDate = form.querySelector('[name="followUpDate"]')?.value || '';
    
    const formData = new URLSearchParams();
    formData.append("patientID", patientID);
    formData.append("diagnosisID", diagnosisID);
    formData.append("diagnoStatus", diagnoStatus);
    formData.append("result", result);
    
    // Add optional fields if they exist
    if (nurseID) formData.append("nurseID", nurseID);
    if (medicationsPrescribed) formData.append("medicationsPrescribed", medicationsPrescribed);
    if (followUpDate) formData.append("followUpDate", followUpDate);
    
    try {
        // Determine which endpoint to use based on form action
        const endpoint = form.getAttribute('action') || 'update-diagnosis';
        
        const response = await fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
        });

        if (response.ok) {
            if (redirectUrl) {
                window.location.href = redirectUrl;
            } else {
                // Default redirect based on diagnosis status
                if (diagnoStatus === 'Referrable' || diagnoStatus === 'Awaiting Diagnosis') {
                    window.location.href = 'referred-diagnoses';
                } else {
                    window.location.href = 'confirmed-cases';
                }
            }
        } else {
            const errorText = await response.text();
            alert('Error: ' + errorText);
        }
    } catch (error) {
        console.error('Submission failed:', error);
        alert('An error occurred while submitting the diagnosis.');
    }
}

// Initialize diagnosis-related event listeners on document load
document.addEventListener('DOMContentLoaded', function() {
    // Close modal when clicking outside
    const diagnosisModals = document.querySelectorAll('.modal-backdrop, .diagnosis-modal');
    diagnosisModals.forEach(modal => {
        modal.addEventListener('click', function(e) {
            if (e.target === this) {
                closeDiagnosisModal(this);
            }
        });
    });
    
    // Diagnose buttons
    const diagnoseButtons = document.querySelectorAll('[data-diagnose]');
    diagnoseButtons.forEach(button => {
        button.addEventListener('click', function() {
            const patientId = this.getAttribute('data-patient-id');
            const patientName = this.getAttribute('data-patient-name');
            const modalId = this.getAttribute('data-target-modal') || 'diagnosisModal';
            openDiagnosis(patientId, patientName, modalId);
        });
    });
}); 