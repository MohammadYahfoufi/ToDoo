function sendMessage() {
    var userInput = document.getElementById('userInput');
    var message = userInput.value.trim();
    if (message !== '') {
        appendMessage(message, 'user');
        userInput.value = '';
        getBotResponse(message);
    }
}

function getBotResponse(message) {
    var botMessage = "Bot response: I'm just a demo bot. How can I assist you?";
    appendMessage(botMessage, 'bot');
}

function appendMessage(message, sender) {
    var chatLog = document.getElementById('chatLog');
    var messageContainer = document.createElement('div');
    messageContainer.classList.add('message', sender);
    var messageText = document.createElement('p');
    messageText.textContent = message;
    messageContainer.appendChild(messageText);
    chatLog.appendChild(messageContainer);
    chatLog.scrollTop = chatLog.scrollHeight;
}

document.getElementById('userInput').addEventListener('keydown', function(event) {
    if (event.keyCode === 13) {
        sendMessage();
    }
});
function openChat() {
    document.getElementById('chatContainer').style.display = 'block';
}

function closeChat() {
    document.getElementById('chatContainer').style.display = 'none';
}

document.getElementById('userInput').addEventListener('keydown', function(event) {
    if (event.keyCode === 13 && !event.shiftKey) {
        event.preventDefault();
        sendMessage();
    }
});
