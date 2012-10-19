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
    center = new google.maps.LatLng start_lat, start_lng
    map = new google.maps.Map back._element,
      zoom:18,
      center:center,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
    game.rootScene.addEventListener Event.ENTER_FRAME, ->
      center = new google.maps.LatLng center.lat() + 0.000003, center.lng()
      map.setCenter center
  game.start()
  navigator.geolocation.getCurrentPosition (pos) ->
    $.post './updatelatlng',
      lat: pos.coords.latitude
      lng: pos.coords.longitude
