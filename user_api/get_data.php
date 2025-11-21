<?php
include 'db_connection.php';

if (isset($_POST['username']) && isset($_POST['password'])) {
    $username = $conn->real_escape_string($_POST['username']);
    $password = $conn->real_escape_string($_POST['password']);

    // First check admin table
    $sql_admin = "SELECT * FROM admin WHERE username = '$username' AND password = '$password' LIMIT 1";
    $result_admin = $conn->query($sql_admin);

    if ($result_admin && $result_admin->num_rows > 0) {
        $user = $result_admin->fetch_assoc();
        $user['user_type'] = 'admin';  // Add user type info
        echo json_encode($user);
    } else {
        // If no admin match, check users table
        $sql_user = "SELECT * FROM users WHERE username = '$username' AND password = '$password' LIMIT 1";
        $result_user = $conn->query($sql_user);

        if ($result_user && $result_user->num_rows > 0) {
            $user = $result_user->fetch_assoc();
            $user['user_type'] = 'user';  // Add user type info
            echo json_encode($user);
        } else {
            echo json_encode(["error" => "Invalid credentials"]);
        }
    }
} else {
    echo json_encode(["error" => "Missing credentials"]);
}

$conn->close();
?>
