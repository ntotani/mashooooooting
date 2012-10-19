<?php
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
<script type="text/javascript">
enchant();
window.onload = function() {
    var latlng = new google.maps.LatLng(-34.397, 150.644);
    var myOptions = {
        zoom: 8,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var game = new Game(640, 480);
    game.preload('chara1.png');
    game.onload = function() {
        var back = new Sprite(game.width, game.height);
        var bear = new Sprite(32, 32);
        bear.image = game.assets['chara1.png'];
        game.rootScene.addEventListener(Event.TOUCH_START, function(e) {
            bear.x = e.x;
            bear.y = e.y;
        });
        game.rootScene.addChild(back);
        game.rootScene.addChild(bear);
        var map = new google.maps.Map(back._element, myOptions);
    }
    game.start();
}

</script>
</head>
<body>
  <div id="enchant-stage"></div>
</body>
</html>
