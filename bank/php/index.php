<?php
$host = 'postgres';
$dbname = 'banking_db';
$user = 'user';
$password = 'password';

try {
    $pdo = new PDO("pgsql:host=$host;dbname=$dbname", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $accountId = $_POST['account_id'];
        $stmt = $pdo->prepare("SELECT balance FROM accounts WHERE id = :account_id");
        $stmt->bindParam(':account_id', $accountId);
        $stmt->execute();
        $account = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($account) {
            echo "Account balance: $" . $account['balance'];
        } else {
            echo "Account not found!";
        }
    }
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}
?>

<form method="POST">
    <input type="number" name="account_id" placeholder="Enter Account ID" required>
    <button type="submit">View Balance</button>
</form>
