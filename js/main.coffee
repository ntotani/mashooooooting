enchant()

window.onload = ->
  game = new Game 640, 480
  game.preload 'img/icon0.png'
  game.onload = ->
    class Ship extends Sprite
      constructor:(url=twitter_info['profile_image_url'])->
        super 32, 32
        Surface.load(url).onload = (e) =>
          icon = new Surface @width, @height
          icon.draw e.target, 0, 0, @width, @height
          @image = icon
        @x = (game.width - @width) / 2
        @y = (game.height - @height) / 2
      onenterframe:->
        @shoot() if @age % 10 is 0
      shoot:->
        voltNum = parseInt volt.text
        return if voltNum <= 0
        volt.text = '' + (voltNum - 1)
        bullet = new Sprite 16, 16
        bullet.image = game.assets['img/icon0.png']
        bullet.frame = 48
        bullet.x = @x + (@width - bullet.width) / 2
        bullet.y = @y
        bullet.onenterframe = ->
          @y -= 10
          for e in enemyLayer.childNodes
            if @intersect e
              @parentNode.removeChild this
              enemyLayer.removeChild e
              return
          @parentNode.removeChild this if @y < -@height
        blueBulletLayer.addChild bullet
      updateTarget:(x, y)->
        from =
          x: @x + @width  / 2,
          y: @y + @height / 2
        dist = Math.sqrt(Math.pow(x - from.x, 2) + Math.pow(y - from.y, 2))
        @tl.clear()
        @tl.moveTo x - @width / 2, y - @height / 2, dist / 10, enchant.Easing.SIN_EASEINOUT
      addFriend:(friend)->
        friend.dy = @height
        if shipLayer.childNodes.length is 1
          friend.dx = -friend.width
        else if shipLayer.childNodes.length is 2
          friend.dx = @width
        friendLayer.removeChild friend
        shipLayer.addChild friend
      damage:->
        len = shipLayer.childNodes.length
        if len is 1
          #alert 'game over'
        else
          shipLayer.removeChild shipLayer.childNodes[len - 1]

    class Friend extends Ship
      counter:0
      constructor:(param)->
        super home_timeline[Friend::counter].user.profile_image_url
        Friend::counter++
        @tl.rotateTo(360, 30).then => @rotation = 0
        @tl.loop()
        @x = param.x or (game.width / @width) / 2
        @y = param.y or -@height
        @help = new MutableText @x - 16, @y - 16
        @help.text = 'HELP'
        friendLayer.addChild @help
        @onenterframe = @initState
      initState:->
        @y += 1
        @help.x = @x - 16
        @help.y = @y - 16
        if @y > game.height
          @help.parentNode.removeChild @help
          @parentNode.removeChild this
        else if @intersect ship
          @tl.clear()
          @rotation = 0
          @help.parentNode.removeChild @help
          ship.addFriend this
          @onenterframe = @joinState
      joinState:->
        @x = ship.x + @dx
        @y = ship.y + @dy
        @shoot() if ship.age % 10 is 0

    class Enemy extends Sprite
      constructor:(param)->
        super param.w or 32, param.h or 32
        url = daily_ranking.rankings[if param.icon? then param.icon else 9].icon
        Surface.load(url).onload = (e) =>
          icon = new Surface @width, @height
          icon.draw e.target, 0, 0, @width, @height
          @image = icon
        @x = param.x or (game.width - @width) / 2
        @y = param.y or -@height
      onenterframe:->
        @y += 1
        if @age % 5 is 0
          bullet = new Sprite 16, 16
          bullet.image = game.assets['img/icon0.png']
          bullet.frame = 60
          bullet.x = @x + (@width - bullet.width) / 2
          bullet.y = @y + @height
          bullet.onenterframe = ->
            @y += 10
            for e in shipLayer.childNodes
              if @intersect e
                @parentNode.removeChild this
                ship.damage()
                return
            @parentNode.removeChild this if @y > game.height
          redBulletLayer.addChild bullet

    class HitawayEnemy extends Enemy
      constructor:(url)->
        super(url)
        @onenterframe = @comeState
      comeState:->
      backState:->

    shipLayer = new Group
    friendLayer = new Group
    enemyLayer = new Group
    blueBulletLayer = new Group
    redBulletLayer = new Group

    back = new Sprite game.width, game.height
    ship = new Ship
    shipLayer.addChild ship
    volt = new MutableText 0, 0
    volt.text = '' + electric
    game.rootScene.addEventListener Event.TOUCH_START, (e)->
      ship.updateTarget e.x, e.y

    currentIndex = lastAge = 0
    mainState = ->
      while @age >= lastAge + level[currentIndex].time
        event = level[currentIndex]
        if event.type is 'enemy'
          enemyLayer.addChild new Enemy event
        else if event.type is 'friend'
          friendLayer.addChild new Friend event
        currentIndex++
        lastAge = @age
        if currentIndex >= level.length
          game.rootScene.onenterframe = (->)
          break
    game.rootScene.onenterframe = mainState

    game.rootScene.addChild back
    game.rootScene.addChild shipLayer
    game.rootScene.addChild friendLayer
    game.rootScene.addChild enemyLayer
    game.rootScene.addChild blueBulletLayer
    game.rootScene.addChild redBulletLayer
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
