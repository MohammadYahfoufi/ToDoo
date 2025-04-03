
<?php
include("dbconfig.php");
session_start();

if (!isset($_SESSION['username'])) {
    header("location: login.html");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['new_username'])) {
    $newUsername = $_POST['new_username'];

    $stmt = $conn->prepare("UPDATE users SET username = ? WHERE username = ?");
    $stmt->bind_param("ss", $newUsername, $_SESSION['username']);

    if ($stmt->execute()) {
        $_SESSION['username'] = $newUsername;
    } else {
        echo "Error: " . $stmt->error;
    }

    $stmt->close();
}

function loadMessages($conn)
{
    $result = $conn->query("SELECT * FROM messages ORDER BY timestamp ASC");
    $messages = [];

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $messages[] = $row;
        }
    }

    return $messages;
}

$messages = loadMessages($conn);
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <style>
        body {
            color: #fff;
            background: #111;
            font-family: 'Open Sans', sans-serif;
            padding: 20px;
            margin: 0;
            font-size: 14px;
            text-rendering: optimizeLegibility;
            -webkit-font-smoothing: antialiased;
            -moz-font-smoothing: antialiased;
        }

        .profile-card {
            max-width: 400px;
            margin: 0 auto;
            background: #333;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
        }

        .profile-picture {
            text-align: center;
            margin-bottom: 20px;
        }

        .profile-picture img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
        }

        .change-pic-btn {
            display: block;
            margin: 10px auto;
            background-color: #ff8c00;
            color: #fff;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .change-pic-btn:hover {
            background-color: #d27d00;
        }

        .discussion-board {
            margin-top: 20px;
            background: #444;
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
        }

        .message-form {
            margin-top: 20px;
        }

        .message-form textarea {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            margin-bottom: 10px;
            color: #fff;
            background-color: #222;
            border: none;
            border-radius: 4px;
        }

        .btn-primary {
            background-color: #ff8c00;
            color: #fff;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn-primary:hover {
            background-color: #d27d00;
        }

        .btn-warning {
            background-color: #dc3545;
            color: #fff;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn-warning:hover {
            background-color: #c82333;
        }

        .btn-info {
            background-color: #17a2b8;
            color: #fff;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn-info:hover {
            background-color: #138496;
        }

        .message {
            background-color: #007bff;
            color: #fff;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 8px;
        }

        .message:nth-child(even) {
            background-color: #007bff;
        }

        .message:nth-child(odd) {
            background-color: #ff8c00;
        }

        .message-user {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .message-time {
            font-size: 12px;
            color: #aaa;
        }

        .username-display {
            font-size: 20px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
        }

        .edit-profile-section {
            display: none;
            margin-top: 20px;
            background: #444;
            padding: 10px;
            border-radius: 8px;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
        }

        .edit-profile-section label {
            display: block;
            margin-bottom: 10px;
        }

        .edit-profile-section input {
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            margin-bottom: 10px;
            color: #fff;
            background-color: #222;
            border: none;
            border-radius: 4px;
        }
    </style>
</head>

<body>
    <div class="profile-card">
        <div class="profile-picture">
            <img id="profile-pic" src="https://bootdey.com/img/Content/avatar/avatar3.png" alt="Profile Picture">
            <input type="file" id="profile-pic-input" style="display: none;">
        </div>
        <button class="change-pic-btn" onclick="changeProfilePicture()">Change Picture</button>

        <div class="username-display">
            Welcome, <?php echo $_SESSION['username']; ?>!
        </div>

        <div class="edit-profile-section">
            <h3>Edit Username</h3>
            <form method="post" action="">
                <label for="new-username">New Username:</label>
                <input type="text" id="new-username" name="new_username" required>
                <button type="submit" class="btn btn-info">Save</button>
            </form>
        </div>

        <div class="discussion-board">
            <h3>Discussion Board</h3>
            <div id="messages">
                <?php
                foreach ($messages as $message) {
                    echo '<div class="message">';
                    echo '<p class="message-user">' . $message['username'] . ':</p>';
                    echo $message['message'];
                    echo '<p class="message-time">' . $message['timestamp'] . '</p>';
                    echo '</div>';
                }
                ?>
            </div>

            <form class="message-form" onsubmit="sendMessage(event)">
                <textarea id="message-input" placeholder="Type your message..."></textarea>
                <button type="submit" class="btn btn-primary">Send</button>
            </form>
        </div>

        <form method="" action="logout.php">
        <button class="btn btn-warning logout-btn" id="logout">Logout</button>
        </form>

<a href="#">
        <button class="btn btn-info edit-profile-btn" onclick="toggleEditProfile()">Edit Username</button>
        </a>
        <a href="index.html"><button class="btn btn-info edit-profile-btn">Return Home!</button></a>
    </div>

    <script>
        function changeProfilePicture() {
            var input = document.getElementById('profile-pic-input');
            input.click();

            input.addEventListener('change', function () {
                var file = input.files[0];
                if (file) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        document.getElementById('profile-pic').src = e.target.result;
                    };
                    reader.readAsDataURL(file);
                }
            });
        }

        function sendMessage(event) {
    event.preventDefault();

    var messageInput = document.getElementById('message-input');
    var message = messageInput.value.trim();

    if (message !== '') {
        var now = new Date();
        var time = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

        var messagesContainer = document.getElementById('messages');
        var messageElement = document.createElement('div');
        messageElement.classList.add('message');
        messageElement.innerHTML = `<p class="message-user"><?php echo $_SESSION['username']; ?>:</p>${message}<p class="message-time">${time}</p>`;
        messagesContainer.appendChild(messageElement);

        fetch('profile.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams({
                'message': message,
                'timestamp': time,
            }),
        });

        messageInput.value = '';
    }
}


        function logout() {
            window.location.href = "index.html";
        }

        function toggleEditProfile() {
            var editProfileSection = document.querySelector('.edit-profile-section');
            editProfileSection.style.display = (editProfileSection.style.display === 'none' || editProfileSection.style.display === '') ? 'block' : 'none';
        }
    </script>
    <?php
    if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['message'])) {
        $message = $_POST['message'];
        $timestamp = date("Y-m-d H:i:s");
    
        $stmt = $conn->prepare("INSERT INTO messages (username, message, timestamp) VALUES (?, ?, ?)");
        $stmt->bind_param("sss", $_SESSION['username'], $message, $timestamp);
    
        if ($stmt->execute()) {
        } else {
            echo "Error: " . $stmt->error;
        }
    
        $stmt->close();
    }
?>    
</body>

</html>
