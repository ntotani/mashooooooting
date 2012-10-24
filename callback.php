<?php
session_start();
require_once('../../libs/twitteroauth/twitteroauth.php');
require_once('../../config.php');

if (isset($_REQUEST['oauth_token']) && $_SESSION['oauth_token'] !== $_REQUEST['oauth_token']) {
  $_SESSION['oauth_status'] = 'oldtoken';
  header('Location: ./login.html');
}

$connection = new TwitterOAuth(CONSUMER_KEY, CONSUMER_SECRET, $_SESSION['oauth_token'], $_SESSION['oauth_token_secret']);
$connection->getAccessToken($_REQUEST['oauth_verifier']);
$connection->decode_json = false;
$_SESSION['twitter_info'] = $connection->get('account/verify_credentials');
$_SESSION['home_timeline'] = $connection->get('statuses/home_timeline');

unset($_SESSION['oauth_token']);
unset($_SESSION['oauth_token_secret']);

if (200 == $connection->http_code) {
  $_SESSION['status'] = 'verified';
  header('Location: ./index.php');
} else {
  header('Location: ./login.html');
}
