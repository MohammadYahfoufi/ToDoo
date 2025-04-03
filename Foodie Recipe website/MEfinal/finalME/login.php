<?php
session_start();
include("dbconfig.php");

$stmt = $conn->prepare("SELECT * FROM users WHERE username = ?");
$stmt->bind_param("s", $_POST['uname']);
$stmt->execute();
$result = $stmt->get_result();
if($result->num_rows > 0) {
  while($row = $result->fetch_assoc()) {
    if(password_verify($_POST['pass'], $row['password'])) {
      $_SESSION['username'] = $_POST['uname'];
      echo '<script>alert("Login Successful");</script>';
      header("refresh:1; profile.php");
    }else{
      echo '<script>alert("Incorrect password. Please try again.");</script>';
      header("refresh:1; index.html");
    }
  }
}
?>