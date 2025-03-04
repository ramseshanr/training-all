<?php
$host = 'postgres';
$dbname = 'banking_db';
$user = 'user';
$password = 'password';

try {
    $pdo = new PDO("pgsql:host=$host;dbname=$dbname", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $name = $_POST['name'];
        $stmt = $pdo->prepare("INSERT INTO accounts (name) VALUES (:name)");
        $stmt->bindParam(':name', $name);
        $stmt->execute();
        echo "Account created successfully!";
    }
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}
?>

<form method="POST">
    <input type="text" name="name" placeholder="Enter your name" required>
    <button type="submit">Create Account</button>
</form>
