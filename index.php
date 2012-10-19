<?php
session_start();
if(empty($_SESSION['access_token']) || empty($_SESSION['access_token']['oauth_token']) || empty($_SESSION['access_token']['oauth_token_secret'])) {
   header('Location: ./login.html');
   exit;
}
require_once('../../libs/twitteroauth/twitteroauth.php');
require_once('../../config.php');

$access_token = $_SESSION['access_token'];
$connection = new TwitterOAuth(CONSUMER_KEY, CONSUMER_SECRET, $access_token['oauth_token'], $access_token['oauth_token_secret']);
$connection->decode_json = false;
$twitter_info = $connection->get('account/verify_credentials');

$daily_ranking = file_get_contents('daily_ranking.json');
$file = new SplFileObject("electric.csv");
$electric = 3000;
$hour = (date('H') - 1) . ':00';
while (!$file->eof()) {
    $row = $file->fgetcsv();
    if(isset($row[1]) && $row[1] == $hour) {
        $electric = $row[2];
        break;
    }
}
?>

<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
        <style type="text/css">
            html { height: 100% }
            body { height: 100%; margin: 0px; padding: 0px }
        </style>
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
        <script type="text/javascript" src="enchant.min.js"></script>
        <script type="text/javascript" src="main.js"></script>
        <script type="text/javascript">
            var daily_ranking = <?php echo $daily_ranking; ?>;
            var electric = <?php echo $electric; ?>;
            var twitter_info = <?php echo $twitter_info; ?>;
        </script>
    </head>
    <body>
        <div id="enchant-stage"></div>
    </body>
</html>
