// Generated by CoffeeScript 1.3.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  enchant();

  window.onload = function() {
    var game;
    game = new Game(640, 480);
    game.preload('img/icon0.png');
    game.onload = function() {
      var Enemy, Friend, HitawayEnemy, Ship, back, blueBulletLayer, boss, center, currentIndex, enemyLayer, f1, f2, friendLayer, mainState, map, redBulletLayer, ship, shipLayer, volt;
      Ship = (function(_super) {

        __extends(Ship, _super);

        function Ship(url) {
          var _this = this;
          if (url == null) {
            url = twitter_info['profile_image_url'];
          }
          Ship.__super__.constructor.call(this, 32, 32);
          Surface.load(url).onload = function(e) {
            var icon;
            icon = new Surface(_this.width, _this.height);
            icon.draw(e.target, 0, 0, _this.width, _this.height);
            return _this.image = icon;
          };
          this.x = (game.width - this.width) / 2;
          this.y = (game.height - this.height) / 2;
        }

        Ship.prototype.onenterframe = function() {
          if (this.age % 10 === 0) {
            return this.shoot();
          }
        };

        Ship.prototype.shoot = function() {
          var bullet, voltNum;
          voltNum = parseInt(volt.text);
          if (voltNum <= 0) {
            return;
          }
          volt.text = '' + (voltNum - 1);
          bullet = new Sprite(16, 16);
          bullet.image = game.assets['img/icon0.png'];
          bullet.frame = 48;
          bullet.x = this.x + (this.width - bullet.width) / 2;
          bullet.y = this.y;
          bullet.onenterframe = function() {
            var e, _i, _len, _ref;
            this.y -= 10;
            _ref = enemyLayer.childNodes;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              e = _ref[_i];
              if (this.intersect(e)) {
                this.parentNode.removeChild(this);
                enemyLayer.removeChild(e);
                return;
              }
            }
            if (this.y < -this.height) {
              return this.parentNode.removeChild(this);
            }
          };
          return blueBulletLayer.addChild(bullet);
        };

        Ship.prototype.updateTarget = function(x, y) {
          var dist, from;
          from = {
            x: this.x + this.width / 2,
            y: this.y + this.height / 2
          };
          dist = Math.sqrt(Math.pow(x - from.x, 2) + Math.pow(y - from.y, 2));
          this.tl.clear();
          return this.tl.moveTo(x - this.width / 2, y - this.height / 2, dist / 10, enchant.Easing.SIN_EASEINOUT);
        };

        Ship.prototype.addFriend = function(friend) {
          friend.dy = this.height;
          if (shipLayer.childNodes.length === 1) {
            friend.dx = -friend.width;
          } else if (shipLayer.childNodes.length === 2) {
            friend.dx = this.width;
          }
          friendLayer.removeChild(friend);
          return shipLayer.addChild(friend);
        };

        Ship.prototype.damage = function() {
          var len;
          len = shipLayer.childNodes.length;
          if (len === 1) {

          } else {
            return shipLayer.removeChild(shipLayer.childNodes[len - 1]);
          }
        };

        return Ship;

      })(Sprite);
      Friend = (function(_super) {

        __extends(Friend, _super);

        function Friend(url) {
          var _this = this;
          Friend.__super__.constructor.call(this, url);
          this.tl.rotateTo(360, 30).then(function() {
            return _this.rotation = 0;
          });
          this.tl.loop();
          this.x = 100;
          this.y = 0;
          this.help = new MutableText(this.x - 16, this.y - 16);
          this.help.text = 'HELP';
          friendLayer.addChild(this.help);
          this.onenterframe = this.initState;
        }

        Friend.prototype.initState = function() {
          this.y += 1;
          this.help.x = this.x;
          this.help.y = this.y - 16;
          if (this.y > game.height) {
            this.help.parentNode.removeChild(this.help);
            return this.parentNode.removeChild(this);
          } else if (this.intersect(ship)) {
            this.tl.clear();
            this.rotation = 0;
            this.help.parentNode.removeChild(this.help);
            ship.addFriend(this);
            return this.onenterframe = this.joinState;
          }
        };

        Friend.prototype.joinState = function() {
          this.x = ship.x + this.dx;
          this.y = ship.y + this.dy;
          if (ship.age % 10 === 0) {
            return this.shoot();
          }
        };

        return Friend;

      })(Ship);
      Enemy = (function(_super) {

        __extends(Enemy, _super);

        function Enemy(url) {
          var _this = this;
          Enemy.__super__.constructor.call(this, 64, 64);
          Surface.load(url).onload = function(e) {
            var icon;
            icon = new Surface(_this.width, _this.height);
            icon.draw(e.target, 0, 0, _this.width, _this.height);
            return _this.image = icon;
          };
        }

        Enemy.prototype.onenterframe = function() {
          var bullet;
          this.y += 1;
          if (this.age % 5 === 0) {
            bullet = new Sprite(16, 16);
            bullet.image = game.assets['img/icon0.png'];
            bullet.frame = 60;
            bullet.x = this.x + (this.width - bullet.width) / 2;
            bullet.y = this.y + this.height;
            bullet.onenterframe = function() {
              var e, _i, _len, _ref;
              this.y += 10;
              _ref = shipLayer.childNodes;
              for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                e = _ref[_i];
                if (this.intersect(e)) {
                  this.parentNode.removeChild(this);
                  ship.damage();
                  return;
                }
              }
              if (this.y > game.height) {
                return this.parentNode.removeChild(this);
              }
            };
            return redBulletLayer.addChild(bullet);
          }
        };

        return Enemy;

      })(Sprite);
      HitawayEnemy = (function(_super) {

        __extends(HitawayEnemy, _super);

        function HitawayEnemy(url) {
          HitawayEnemy.__super__.constructor.call(this, url);
          this.onenterframe = this.comeState;
        }

        HitawayEnemy.prototype.comeState = function() {};

        HitawayEnemy.prototype.backState = function() {};

        return HitawayEnemy;

      })(Enemy);
      shipLayer = new Group;
      friendLayer = new Group;
      enemyLayer = new Group;
      blueBulletLayer = new Group;
      redBulletLayer = new Group;
      back = new Sprite(game.width, game.height);
      ship = new Ship;
      boss = new Sprite(124, 124);
      boss.image = Surface.load(daily_ranking.rankings[0].icon);
      boss.x = (game.width - boss.width) / 2;
      volt = new MutableText(0, 0);
      volt.text = '' + electric;
      game.rootScene.addEventListener(Event.TOUCH_START, function(e) {
        return ship.updateTarget(e.x, e.y);
      });
      shipLayer.addChild(ship);
      f1 = new Friend(home_timeline[0].user.profile_image_url);
      f2 = new Friend(home_timeline[1].user.profile_image_url);
      f2.x = 400;
      friendLayer.addChild(f1);
      friendLayer.addChild(f2);
      currentIndex = 0;
      mainState = function() {
        var event;
        if (this.age >= level[currentIndex].time) {
          event = level[currentIndex];
          if (event.type === 'enemy') {
            enemyLayer.addChild(new Enemy(daily_ranking.rankings[9].icon));
          }
          currentIndex++;
          if (currentIndex >= level.length) {
            return game.rootScene.onenterframe = (function() {});
          }
        }
      };
      game.rootScene.onenterframe = mainState;
      game.rootScene.addChild(back);
      game.rootScene.addChild(shipLayer);
      game.rootScene.addChild(friendLayer);
      game.rootScene.addChild(enemyLayer);
      game.rootScene.addChild(blueBulletLayer);
      game.rootScene.addChild(redBulletLayer);
      game.rootScene.addChild(boss);
      game.rootScene.addChild(volt);
      center = new google.maps.LatLng(start_lat, start_lng);
      map = new google.maps.Map(back._element, {
        zoom: 18,
        center: center,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        disableDefaultUI: true
      });
      return game.rootScene.addEventListener(Event.ENTER_FRAME, function() {
        center = new google.maps.LatLng(center.lat() + 0.000003, center.lng());
        return map.setCenter(center);
      });
    };
    game.start();
    return navigator.geolocation.getCurrentPosition(function(pos) {
      return $.post('./updatelatlng', {
        lat: pos.coords.latitude,
        lng: pos.coords.longitude
      });
    });
  };

}).call(this);
