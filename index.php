<?php
session_start();
if(empty($_SESSION['twitter_info']) || empty($_SESSION['home_timeline'])) {
   header('Location: ./login.html');
   exit;
}
require_once('../../config.php');

$twitter_info = $_SESSION['twitter_info'];
$twitter_info_array = json_decode($twitter_info, true);
$home_timeline = $_SESSION['home_timeline'];

$db = new PDO(DB_DSN, DB_USER, DB_PASSWD);
$sql = 'select * from mashooooooting where twitter_id = ?';
$stmt = $db->prepare($sql);
$stmt->execute(array($twitter_info_array['id']));
$user = $stmt->fetch();
if($user) {
    $start_lat = $user['lat'];
    $start_lng = $user['lng'];
} else {
    $start_lat = 35.6614274;
    $start_lng = 139.7292734;
    $db->prepare('insert into mashooooooting values (?, ?, ?)')->execute(array($twitter_info_array['id'], $start_lat, $start_lng));
}

$daily_ranking = file_get_contents('data/daily_ranking.json');
$file = new SplFileObject("data/electric.csv");
$electric = 3000;
$hour = (date('H') - 2) . ':00';
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
        <style type="text/css">
            html { height: 100% }
            body { height: 100%; margin: 0px; padding: 0px }
        </style>
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
        <script type="text/javascript" src="js/enchant.min.js"></script>
        <script type="text/javascript" src="js/util.enchant.js"></script>
        <script type="text/javascript" src="js/nineleap.enchant.js"></script>
        <script type="text/javascript" src="js/tl.enchant.js"></script>
        <script type="text/javascript" src="js/level.js"></script>
        <script type="text/javascript" src="js/main.js"></script>
        <script type="text/javascript">
            var daily_ranking = <?php echo $daily_ranking; ?>;
            var electric = <?php echo $electric; ?>;
            var twitter_info = <?php echo $twitter_info; ?>;
            var start_lat = <?php echo $start_lat; ?>;
            var start_lng = <?php echo $start_lng; ?>;
            var home_timeline = <?php echo $home_timeline; ?>;
        </script>
    </head>
    <body>
        <div id="enchant-stage"></div>
        <p>ゼビウスなど流しながらお楽しみください</p>
        <iframe width="420" height="315" src="http://www.youtube.com/embed/b7dBHaBkwAE?autoplay=1" frameborder="0" allowfullscreen></iframe>
    </body>
</html>
