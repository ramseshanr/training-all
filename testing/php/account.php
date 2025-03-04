<?php
// Database connection details
$host = 'postgres';
$dbname = 'banking_db';
$user = 'user';
$password = 'password';

try {
    // Establishing PDO connection to the PostgreSQL database
    $pdo = new PDO("pgsql:host=$host;dbname=$dbname", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Fetching all accounts
    $accounts = $pdo->query("SELECT * FROM accounts")->fetchAll(PDO::FETCH_ASSOC);

} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>List of Bank Accounts</title>
</head>
<body>
    <h1>List of Available Bank Accounts</h1>

    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Balance</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($accounts as $account): ?>
                <tr>
                    <td><?= htmlspecialchars($account['id']) ?></td>
                    <td><?= htmlspecialchars($account['name']) ?></td>
                    <td><?= number_format($account['balance'], 2) ?></td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</body>
</html>
