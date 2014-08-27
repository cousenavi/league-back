(function() {
  $(function() {
    var extractData, registry, templates;
    templates = {
      login: function() {
        return "<div id=\"loginForm\">\n<input type=\"text\" data-value=\"login\" placeholder='login' autofocus='true'><br><br>\n<input type=\"password\" data-value=\"password\" placeholder='password'><br><br>\n<button id=\"loginBtn\">Go!</button>\n</div>";
      },
      matches: function(matches) {
        var m;
        return ((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = matches.length; _i < _len; _i++) {
            m = matches[_i];
            _results.push("<button id='" + m._id + "'class='match'>" + m.homeTeamName + " - " + m.awayTeamName + "<br><span class='littleText'>" + m.date + " " + m.time + " " + m.placeName + "</span></button><br>");
          }
          return _results;
        })()).join('');
      },
      game: function(game) {
        var id, p;
        return "<div id=\"homeTeam\">\n  <b>" + game.homeTeam.name + "</b>\n  " + (((function() {
          var _ref, _results;
          _ref = game.homeTeam.players;
          _results = [];
          for (id in _ref) {
            p = _ref[id];
            _results.push("<button id='" + id + "' class='player homePlayer'>" + p[0] + " " + p[1] + "</button>");
          }
          return _results;
        })()).join('')) + "\n  <button id=\"saveHomeTeamBtn\">OK</button>\n</div>\n\n<div id=\"awayTeam\" style='display: none'>\n  " + (((function() {
          var _ref, _results;
          _ref = game.awayTeam.players;
          _results = [];
          for (id in _ref) {
            p = _ref[id];
            _results.push("<button id='" + id + "' class='player awayPlayer'>" + p[0] + " " + p[1] + "</button>");
          }
          return _results;
        })()).join('')) + "\n  <button id=\"saveAwayTeamBtn\">OK</button>\n</div>";
      },
      events: function() {
        return "<button class=\"event\" id=\"goalEvent\">Гол</button><br>\n<button class=\"event\" id=\"yellowEvent\">Жк</button><br>\n<button class=\"event\" id=\"redEvent\">Кк</button><br>\n<button class=\"event\" id=\"endEvent\">Конец матча</button><br>";
      },
      goalEvent: function() {
        return "";
      },
      yellowEvent: function() {
        return "";
      },
      redEvent: function() {
        return "";
      },
      playerEvent: function(eventName) {
        var id, p;
        return "<table class=\"playerEventTable\" id=\"" + eventName + "\"><thead><th>" + registry.currentGame.homeTeam.name + "</th><th>" + registry.currentGame.awayTeam.name + "</th></thead><tr><td>\n" + (eventName === 'event-goal' ? "<input type='button' value='автогол' class='playerEvent'/>" : void 0) + "\n" + (((function() {
          var _ref, _results;
          _ref = registry.currentGame.homeTeam.players;
          _results = [];
          for (id in _ref) {
            p = _ref[id];
            _results.push("<input type='button' id='" + id + "' class='playerEvent' value='" + p[0] + "'>");
          }
          return _results;
        })()).join('')) + "\n</td><td>\n" + (eventName === 'event-goal' ? "<input type='button' value='автогол' class='playerEvent'/>" : void 0) + "\n" + (((function() {
          var _ref, _results;
          _ref = registry.currentGame.awayTeam.players;
          _results = [];
          for (id in _ref) {
            p = _ref[id];
            _results.push("<input type='button' id='" + id + "' class='playerEvent' value='" + p[0] + "'>");
          }
          return _results;
        })()).join('')) + "\n</td>\n</tr></table>\n<button id=\"saveEventBtn\">OK</button>";
      },
      endEvent: function() {
        return "<button id=\"homeTeamChoise\">выбор " + registry.currentGame.homeTeam.name + "</button> <br>\n<button type=\"button\" id=\"awayTeamChoise\">выбор " + registry.currentGame.awayTeam.name + "</button> <br>\n<button id=\"saveChoises\">OK</button>";
      },
      choise: function(side) {
        var id, mark, pl, players, team;
        players = [];
        if (side === 'Home') {
          players = registry.currentGame.awayTeam.players;
          team = registry.currentGame.homeTeam;
        } else {
          players = registry.currentGame.homeTeam.players;
          team = registry.currentGame.awayTeam;
        }
        return "  <div class=\"strip\">оценка судье:</div>\n<div>\n  " + (((function() {
          var _i, _results;
          _results = [];
          for (mark = _i = 2; _i <= 5; mark = ++_i) {
            _results.push("<input type='button' class='playerEvent refereeMark mark" + side + " " + (mark === team.refereeMark ? "activeBtn" : "") + "' value='" + mark + "'>");
          }
          return _results;
        })()).join('')) + "\n</div>\n  <br><div class=\"strip\">лучшие игроки соперника:</div>\n  <div>\n  " + (((function() {
          var _results;
          _results = [];
          for (id in players) {
            pl = players[id];
            _results.push("<input type='button' id='" + id + "' class='playerEvent bestPlayer " + (pl.star != null ? "activeBtn" : "") + "' value='" + pl[0] + "'>");
          }
          return _results;
        })()).join('')) + "\n  </div><br><button id=\"save" + side + "TeamChoise\">OK</button>";
      },
      error: function() {
        return 'error';
      }
    };
    extractData = function($el) {
      var data;
      data = {};
      $el.find('[data-value]').each(function() {
        return data[$(this).attr('data-value')] = $(this).val();
      });
      $el.find('[data-collection]').each(function() {
        var key;
        key = $(this).attr('data-collection');
        data[key] = [];
        return $(this).find('[data-element]').each(function() {
          var obj;
          obj = {};
          $(this).find('[data-atom]').each(function() {
            return obj[$(this).attr('data-atom')] = $(this).val();
          });
          return data[key].push(obj);
        });
      });
      return data;
    };
    registry = {};
    registry.load = function() {
      var key, prop, _ref, _results;
      _ref = JSON.parse(localStorage.getItem('registry'));
      _results = [];
      for (key in _ref) {
        prop = _ref[key];
        _results.push(registry[key] = prop);
      }
      return _results;
    };
    registry.save = function() {
      return localStorage.setItem('registry', JSON.stringify(registry));
    };
    registry.sync = function(callback) {
      console.log('здесь мы синхронизируем регистр с сервером');
      return typeof callback === "function" ? callback() : void 0;
    };
    registry.endGame = function() {
      this.currentGame.ended = true;
      this.sync();
      return this.save();
    };
    registry.setCurrentGame = function(game) {
      this.currentGame = game;
      return this.save();
    };
    registry.setUser = function(user) {
      this.currentUser = user;
      return this.save();
    };
    registry.setHomeRefereeMark = function(mark) {
      this.currentGame.homeTeam.refereeMark = parseInt(mark);
      console.log('home', mark, this.currentGame.homeTeam);
      return this.save();
    };
    registry.setAwayRefereeMark = function(mark) {
      this.currentGame.awayTeam.refereeMark = parseInt(mark);
      console.log('away', mark, this.currentGame.awayTeam);
      return this.save();
    };
    registry.removeBestPlayer = function(id) {
      if (this.currentGame.homeTeam.players[id] != null) {
        delete this.currentGame.homeTeam.players[id].star;
      } else {
        delete this.currentGame.awayTeam.players[id].star;
      }
      return this.save();
    };
    registry.setBestPlayer = function(id) {
      if (this.currentGame.homeTeam.players[id] != null) {
        this.currentGame.homeTeam.players[id].star = true;
      } else {
        this.currentGame.awayTeam.players[id].star = true;
      }
      return this.save();
    };
    registry.setPlayerActivity = function(id, isActive) {
      if (this.currentGame.homeTeam.players[id] != null) {
        this.currentGame.homeTeam.players[id][2] = isActive;
      } else {
        this.currentGame.awayTeam.players[id][2] = isActive;
      }
      return this.save();
    };
    registry.load();
    if (registry.currentUser == null) {
      $('#container').html(templates.login());
    } else if (registry.currentGame == null) {
      $.ajax({
        url: '/matches',
        method: 'GET',
        success: function(matches) {
          return $('#container').html(templates.matches(matches));
        },
        error: function() {
          return $('#container').html(templates.error);
        }
      });
    } else if (registry.currentGame.ended == null) {
      $('#container').html(templates.events());
    } else {
      $('#container').html(templates.endEvent());
    }
    $('#container').on('click', '#loginBtn', function() {
      var data;
      $(this).html('...').attr('disabled', 'true');
      data = extractData($(this).parent());
      return $.ajax({
        url: '/login',
        method: 'POST',
        data: data,
        success: function(matches) {
          registry.setUser(true);
          return $('#container').html(templates.matches(matches));
        },
        error: function() {
          return $(this).html('Go!');
        }
      });
    });
    $('#container').on('click', '.match', function() {
      $(this).parent().find('.match').each(function() {
        return $(this).attr('disabled', true);
      });
      $(this).html('...');
      return $.ajax({
        url: "/game?_id=" + ($(this).attr('id')),
        success: function(game) {
          registry.setCurrentGame(game);
          return $('#container').html(templates.game(game));
        },
        error: function() {
          return $('#container').html(templates.error());
        }
      });
    });
    $('#container').on('click', '.player', function() {
      $(this).toggleClass('activePlayer');
      return registry.setPlayerActivity($(this).attr('id'), $(this).hasClass('activePlayer'));
    });
    $('#container').on('click', '#saveHomeTeamBtn', function() {
      $('#homeTeam').hide();
      return $('#awayTeam').show();
    });
    $('#container').on('click', '#saveAwayTeamBtn', function() {
      registry.sync();
      return $('#container').html(templates.events());
    });
    $('#container').on('click', '#goalEvent', function() {
      return $('#container').html(templates.goalEvent());
    });
    $('#container').on('click', '#yellowEvent', function() {
      return $('#container').html(templates.yellowEvent());
    });
    $('#container').on('click', '#redEvent', function() {
      return $('#container').html(templates.redEvent());
    });
    $('#container').on('click', '#endEvent', function() {
      if (confirm('Закончить матч? Это действие нельзя будет отменить')) {
        registry.endGame();
        return $('#container').html(templates.endEvent());
      }
    });
    $('#container').on('click', '#homeTeamChoise', function() {
      return $('#container').html(templates.choise('Home'));
    });
    $('#container').on('click', '#awayTeamChoise', function() {
      return $('#container').html(templates.choise('Away'));
    });
    $('#container').on('click', '.refereeMark', function() {
      if ($(this).hasClass('markHome')) {
        registry.setHomeRefereeMark($(this).val());
      } else {
        registry.setAwayRefereeMark($(this).val());
      }
      $(this).parent().find('.activeBtn').each(function() {
        return $(this).removeClass('activeBtn');
      });
      return $(this).addClass('activeBtn');
    });
    $('#container').on('click', '.bestPlayer', function() {
      if ($(this).hasClass('activeBtn')) {
        $(this).removeClass('activeBtn');
        return registry.removeBestPlayer($(this).attr('id'));
      } else if ($(this).parent().find('.activeBtn').length < 3) {
        $(this).addClass('activeBtn');
        return registry.setBestPlayer($(this).attr('id'));
      }
    });
    $('#container').on('click', '#saveHomeTeamChoise', function() {
      return $('#container').html(templates.endEvent());
    });
    $('#container').on('click', '#saveAwayTeamChoise', function() {
      return $('#container').html(templates.endEvent());
    });
    $('#container').on('click', '#saveChoises', function() {
      $(this).html('...');
      return registry.sync(function() {
        return location.reload();
      });
    });
    $('#container').on('click', '#event-goal input', function() {
      if ($('.playerEventTable .goal').length === 0) {
        return $(this).addClass('goal');
      } else if ($(this).hasClass('goal')) {
        return $(this).removeClass('goal');
      } else if ($(this).hasClass('assist')) {
        return $(this).removeClass('assist');
      } else {
        return $(this).addClass('assist');
      }
    });
    return $('#container').on('click', '#saveEvent', function() {
      return console.log('ok');
    });
  });

}).call(this);
