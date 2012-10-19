enchant()

window.onload = ->
  game = new Game 640, 480
  game.preload 'icon0.png'
  game.onload = ->
    back = new Sprite game.width, game.height
    bear = new Sprite 32, 32
    bear.image = Surface.load twitter_info['profile_image_url']
    bear.addEventListener Event.ENTER_FRAME, ->
      voltNum = parseInt volt.text
      if bear.age % 10 is 0 and voltNum > 0
        volt.text = voltNum - 1
        bullet = new Sprite 16, 16
        bullet.image = game.assets['icon0.png']
        bullet.frame = 48
        bullet.x = bear.x + (bear.width - bullet.width) / 2
        bullet.y = bear.y
        bullet.addEventListener Event.ENTER_FRAME, ->
          this.y -= 10
          this.parentNode.removeChild this if this.y < -this.height
        game.rootScene.addChild bullet
    boss = new Sprite 124, 124
    boss.image = Surface.load daily_ranking.rankings[0].icon
    boss.x = (game.width - boss.width) / 2
    volt = new Label electric
    game.rootScene.addEventListener Event.TOUCH_START, (e)->
      bear.x = e.x
      bear.y = e.y
    game.rootScene.addChild back
    game.rootScene.addChild bear
    game.rootScene.addChild boss
    game.rootScene.addChild volt
    center = new google.maps.LatLng start_lat, start_lng
    map = new google.maps.Map back._element,
      zoom:18,
      center:center,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      disableDefaultUI:true,
    game.rootScene.addEventListener Event.ENTER_FRAME, ->
      center = new google.maps.LatLng center.lat() + 0.000003, center.lng()
      map.setCenter center
  game.start()
  navigator.geolocation.getCurrentPosition (pos) ->
    $.post './updatelatlng',
      lat: pos.coords.latitude
      lng: pos.coords.longitude
