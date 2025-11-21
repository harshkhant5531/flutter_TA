<?php
    header("Access-Control-Allow-Origin: *"); // Allows requests from any origin
    header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Authorization");
            // ... your other PHP code
    $servername = "localhost";
    $username = "root"; // Your MySQL username
    $password = "";     // Your MySQL password
    $dbname = "demo";

    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>