document.getElementById('contactForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const submitBtn = document.getElementById('submitBtn');
    const originalText = submitBtn.innerHTML;
    const messageArea = document.getElementById('messageArea');
    
    submitBtn.innerHTML = 'Sending...';
    submitBtn.disabled = true;
    messageArea.innerHTML = '';
    
    const formData = {
        name: document.getElementById('name').value,
        email: document.getElementById('email').value,
        message: document.getElementById('message').value
    };
    
    try {

        const apiUrl = '<api-gateway-invoke url removed for security (public repo)>';
        
        const response = await fetch(apiUrl, {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(formData)
        });
        
        const result = await response.json();
        
        if (response.ok) {
            messageArea.innerHTML = `<div class="message success">✅ ${result.message}</div>`;
            document.getElementById('contactForm').reset();
        } else {
            messageArea.innerHTML = `<div class="message error">❌ Error: ${result.error}</div>`;
        }
        
    } catch (error) {
        messageArea.innerHTML = `<div class="message error">❌ Network error. Please try again.</div>`;
    } finally {
        submitBtn.innerHTML = originalText;
        submitBtn.disabled = false;
    }
});