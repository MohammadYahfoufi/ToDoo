<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;


require 'C:\xampp\htdocs\MEfinal\finalME\PHPMailer-master\src\Exception.php';
require 'C:\xampp\htdocs\MEfinal\finalME\PHPMailer-master\src\PHPMailer.php';
require 'C:\xampp\htdocs\MEfinal\finalME\PHPMailer-master\src\SMTP.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = $_POST['name'];
    $phone = $_POST['phone'];
    $email = $_POST['email'];
    $subject = $_POST['subject'];
    $message = $_POST['message'];


    $mail = new PHPMailer(true);

   
        $mail->isSMTP();
        $mail->Host = 'smtp.gmail.com';
        $mail->SMTPAuth = true;
        $mail->Username = 'medo246mmy@gmail.com';
        $mail->Password = 'wrxf ofgk rqle afow';
        $mail->SMTPSecure = 'ssl';
        $mail->Port = 465;

        $mail->setFrom($_POST["email"]);
        $mail->addAddress('medo246mmy@gmail.com'); 

        $mail->isHTML(true);
        $mail->Subject = $POST["subject"];
        $mail->Body = "Name: $name<br>Phone: $phone<br>Email: $email<br>Subject: $subject<br>Message: $message";

        $mail->send();
     echo 
     "
     <script>
     alert('Sent Successfully');
     document.location.href = 'contact.html';
     </script>
     ";   
}
?>
