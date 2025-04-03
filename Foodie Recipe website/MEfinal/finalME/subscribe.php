<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;


require 'C:\xampp\htdocs\MEfinal\finalME\PHPMailer-master\src\Exception.php';
require 'C:\xampp\htdocs\MEfinal\finalME\PHPMailer-master\src\PHPMailer.php';
require 'C:\xampp\htdocs\MEfinal\finalME\PHPMailer-master\src\SMTP.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'];
    $subject = "Foodie";
    $message = "
    <p>Dear New Foodie User,</p>
    <p>Thank you for subscribing to Foodie's newsletter! We're excited to have you on board.</p>
    <p>Stay tuned for the latest recipes, cooking tips, and delicious updates delivered right to your inbox.</p>
    <p>Best regards,<br>Your Foodie Team</p>
";


    $mail = new PHPMailer(true);

   
        $mail->isSMTP();
        $mail->Host = 'smtp.gmail.com'; 
        $mail->SMTPAuth = true;
        $mail->Username = 'medo246mmy@gmail.com';
        $mail->Password = 'wrxf ofgk rqle afow';
        $mail->SMTPSecure = 'ssl';
        $mail->Port = 465; 

        $mail->setFrom('medo246mmy@gmail.com');
        $mail->addAddress($_POST["email"]);

        $mail->isHTML(true);
        $mail->Subject = "$subject";
        $mail->Body = "$message";

        $mail->send();
     echo 
     "
     <script>
     alert('Sent Successfully');
     document.location.href = 'index.html';
     </script>
     ";   
}
?>
