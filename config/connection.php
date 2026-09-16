<?php
$servername = "serverless-europe-west3.sysp0000.db2.skysql.com";
$port = 4060;
$username = "dbpgf27378294";
$password = "DaZXV7AIox2.fIJ7tk9vuYYD3";
$dbname = "gdps";

$db = mysqli_init();

// Set a strict connection timeout so PHP fails fast instead of hanging Railway
$db->options(MYSQLI_OPT_CONNECT_TIMEOUT, 5);

// Enable SSL for SkySQL
if (getenv('DB_SSL') === 'true' || $servername) {
    $db->ssl_set(NULL, NULL, NULL, NULL, NULL);
    $db->options(MYSQLI_OPT_SSL_VERIFY_SERVER_CERT, false);
}

if (!@$db->real_connect($servername, $username, $password, $dbname, (int)$port, NULL, MYSQLI_CLIENT_SSL)) {
    header('HTTP/1.1 500 Internal Server Error');
    die("SkySQL Connection Error: " . mysqli_connect_error());
}
?>
