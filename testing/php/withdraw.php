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
        $amount = $_POST['amount'];

        // Check if the account has enough balance
        $stmt = $pdo->prepare("SELECT balance FROM accounts WHERE id = :account_id");
        $stmt->bindParam(':account_id', $accountId);
        $stmt->execute();
        $account = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($account['balance'] >= $amount) {
            // Perform the withdrawal
            $stmt = $pdo->prepare("UPDATE accounts SET balance = balance - :amount WHERE id = :account_id");
            $stmt->bindParam(':amount', $amount);
            $stmt->bindParam(':account_id', $accountId);
            $stmt->execute();
            
            // Record the transaction
            $stmt = $pdo->prepare("INSERT INTO transactions (account_id, amount, transaction_type) VALUES (:account_id, :amount, 'withdrawal')");
            $stmt->bindParam(':account_id', $accountId);
            $stmt->bindParam(':amount', $amount);
            $stmt->execute();

            echo "Withdrawal successful!";
        } else {
            echo "Insufficient funds!";
        }
    }
} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}
?>

<form method="POST">
    <input type="number" name="account_id" placeholder="Enter Account ID" required>
    <input type="number" name="amount" placeholder="Enter Amount" required>
    <button type="submit">Withdraw</button>
</form>
