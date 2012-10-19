enchant()

window.onload = ->
  game = new Game 640, 480
  game.onload = ->
    back = new Sprite game.width, game.height
    bear = new Sprite 32, 32
    bear.image = Surface.load twitter_info['profile_image_url']
    game.rootScene.addEventListener Event.TOUCH_START, (e)->
      bear.x = e.x
      bear.y = e.y
    game.rootScene.addChild back
    game.rootScene.addChild bear
    center = new google.maps.LatLng 35.6614274, 139.7292734
    map = new google.maps.Map back._element,
      zoom:18,
      center:center,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
    game.rootScene.addEventListener Event.ENTER_FRAME, ->
      center = new google.maps.LatLng center.lat() + 0.000003, center.lng()
      map.setCenter center
  game.start()
