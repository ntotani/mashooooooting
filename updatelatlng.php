<?php
if(empty($_POST['lat']) || empty($_POST['lng'])) {
    exit;
}

session_start();
if(empty($_SESSION['access_token']) || empty($_SESSION['access_token']['oauth_token']) || empty($_SESSION['access_token']['oauth_token_secret'])) {
   exit;
}
require_once('../../libs/twitteroauth/twitteroauth.php');
require_once('../../config.php');

$access_token = $_SESSION['access_token'];
$connection = new TwitterOAuth(CONSUMER_KEY, CONSUMER_SECRET, $access_token['oauth_token'], $access_token['oauth_token_secret']);
$connection->decode_json = false;
$twitter_info = $connection->get('account/verify_credentials');
$twitter_info_array = json_decode($twitter_info, true);
$twitter_id = $twitter_info_array['id'];

$db = new PDO(DB_DSN, DB_USER, DB_PASSWD);
$sql = 'update mashooooooting set lat = ?, lng = ? where twitter_id = ?';
$stmt = $db->prepare($sql);
$stmt->execute(array($_POST['lat'], $_POST['lng'], $twitter_id));
echo 'ok';
