<?php
// Database Status Page
// Replace with your database server's private IP address
$host = '172.31.0.0';
$dbname = 'nexus_db';
$user = 'nexus_admin';
$password = 'your_secure_password';

try {
    $pdo = new PDO("pgsql:host=$host;dbname=$dbname", $user, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "<h1>Database Status - ONLINE</h1>";

    // Get table counts
    $stmt = $pdo->query("SELECT COUNT(*) FROM users");
    $userCount = $stmt->fetchColumn();

    $stmt = $pdo->query("SELECT COUNT(*) FROM servers");
    $serverCount = $stmt->fetchColumn();

    $stmt = $pdo->query("SELECT COUNT(*) FROM server_logs");
    $logCount = $stmt->fetchColumn();

    echo "<p>Users: $userCount</p>";
    echo "<p>Servers: $serverCount</p>";
    echo "<p>Log Entries: $logCount</p>";

    // Show recent logs
    echo "<h2>Recent Logs</h2>";
    $stmt = $pdo->query("SELECT s.name, sl.log_level, sl.message, sl.created_at
                        FROM servers s
                        JOIN server_logs sl ON s.id = sl.server_id
                        ORDER BY sl.created_at DESC LIMIT 10");

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo "<p><strong>{$row['name']}</strong> [{$row['log_level']}]: {$row['message']} <em>({$row['created_at']})</em></p>";
    }

} catch (PDOException $e) {
    echo "<h1>Database Status - ERROR</h1>";
    echo "<p>Error: " . $e->getMessage() . "</p>";
}
?>
