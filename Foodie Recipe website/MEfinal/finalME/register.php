<?php
include("dbconfig.php");

$pass = password_hash($_POST['pass'], PASSWORD_DEFAULT);

$stmt = $conn->prepare("INSERT INTO users (username, password, email) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $_POST['uname'], $pass, $_POST['email']);
if($stmt->execute()) {
header("location: index.html");
}else{
  echo "Error: ".$stmt->error;
}
?>