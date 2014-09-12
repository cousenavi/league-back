(function() {
  $(function() {
    var extractData, registry, templates;
    templates = {
      login: function() {
        return "<div id=\"loginForm\">\n<input type=\"text\" data-value=\"login\" class=\"form-control\" placeholder='login'><br>\n<input type=\"password\" data-value=\"password\" class=\"form-control\" placeholder='password'><br>\n<button id=\"loginBtn\" class=\"btn btn-success btn-block\">Go!</button>\n</div>";
      },
      matches: function(matches) {
        var html, m;
        html = "<nav class=\"navbar navbar-default\" role=\"navigation\">\n    <div class=\"navbar-header\">\n        <a class=\"navbar-brand\">Выберите матч</a>\n    </div>\n</nav>";
        return html += ((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = matches.length; _i < _len; _i++) {
            m = matches[_i];
            _results.push("<button class='btn btn-block btn-info match' id='" + m._id + "'class='match'>" + m.homeTeamName + " <br> " + m.awayTeamName + "<br><span class='smallText'>" + m.date + " " + m.time + " " + m.placeName + "</span></button><br>");
          }
          return _results;
        })()).join('');
      },
      game: function(game) {
        var id, p;
        return "<div id=\"homeTeam\" class=\"protocol\">\n    <nav class=\"navbar navbar-default\" role=\"navigation\">\n            <div class=\"navbar-header\">\n                <a class=\"navbar-brand\">" + game.homeTeam.name + ": состав</a>\n            </div>\n      </nav>\n  " + (((function() {
          var _ref, _results;
          _ref = game.homeTeam.players;
          _results = [];
          for (id in _ref) {
            p = _ref[id];
            _results.push("<button class='btn btn-block btn-default player homePlayer' id='" + id + "' >" + p.number + " " + p.name + "</button>");
          }
          return _results;
        })()).join('')) + "\n  <button class='btn btn-block btn-success'  id=\"saveHomeTeamBtn\">OK</button>\n</div>\n\n<div id=\"awayTeam\" style='display: none' class=\"protocol\">\n      <nav class=\"navbar navbar-default\" role=\"navigation\">\n            <div class=\"navbar-header\">\n                <a class=\"navbar-brand\">" + game.awayTeam.name + ": состав</a>\n            </div>\n      </nav>\n  " + (((function() {
          var _ref, _results;
          _ref = game.awayTeam.players;
          _results = [];
          for (id in _ref) {
            p = _ref[id];
            _results.push("<button class='btn btn-block btn-default player awayPlayer'  id='" + id + "'>" + p.number + " " + p.name + "</button>");
          }
          return _results;
        })()).join('')) + "\n  <button class='btn btn-block btn-success' id=\"saveAwayTeamBtn\">OK</button>\n</div>";
      },
      events: function() {
        return "    <nav class=\"navbar navbar-default\" role=\"navigation\">\n          <div class=\"navbar-header\">\n              <a class=\"navbar-brand\"> " + registry.currentGame.homeTeam.name + " " + registry.currentGame.homeTeam.score + "-" + registry.currentGame.awayTeam.score + " " + registry.currentGame.awayTeam.name + "</a>\n          </div>\n    </nav>\n<button class=\"btn btn-block btn-info event\" id=\"goalEvent\">Гол</button><br>\n<button class=\"btn btn-block btn-info event\" id=\"yellowEvent\">Жёлтая карточка</button><br>\n<button class=\"btn btn-block btn-info event\" id=\"redEvent\">Прямая красная</button><br>\n<button class=\"btn btn-block btn-success event\" id=\"endEvent\">Конец матча</button><br>";
      },
      goalEvent: function() {
        var id, pl;
        return "  <span id='goal'>\n    <nav class=\"navbar navbar-default\" role=\"navigation\">\n      <div class=\"navbar-header\">\n        <a class=\"navbar-brand\">Гол</a>\n      </div>\n    </nav>\n      <div class=\"btn-group btn-group-justified\">\n  <a class=\"btn btn-default active goalEventType\" role=\"button\" id=\"G+\">Гол+ </a>\n  <a class=\"btn btn-default goalEventType\" role=\"button\" id=\"A+\">Пас+ </a>\n  <a class=\"btn btn-default goalEventType\" role=\"button\" id=\"G-\">Гол-</a>\n  <a class=\"btn btn-default goalEventType\" role=\"button\" id=\"A-\">Пас-</a>\n</div>\n      <h2>" + registry.currentGame.homeTeam.name + "</h2>\n      " + (((function() {
          var _ref, _results;
          _ref = registry.currentGame.homeTeam.players;
          _results = [];
          for (id in _ref) {
            pl = _ref[id];
            _results.push("<button id='" + id + "' class='btn btn-default playerEvent'>" + pl.number + " <span class='goals'>" + (pl.goals != null ? pl.goals : 0) + "</span> <span class='assists'>" + (pl.assists != null ? pl.assists : 0) + "</span> </button> ");
          }
          return _results;
        })()).join('')) + "\n      <h2>" + registry.currentGame.awayTeam.name + "</h2>\n      " + (((function() {
          var _ref, _results;
          _ref = registry.currentGame.awayTeam.players;
          _results = [];
          for (id in _ref) {
            pl = _ref[id];
            _results.push("<button id='" + id + "' class='btn btn-default playerEvent'>" + pl.number + " <span class='goals'>" + (pl.goals != null ? pl.goals : 0) + "</span> <span class='assists'>" + (pl.assists != null ? pl.assists : 0) + "</span> </button> ");
          }
          return _results;
        })()).join('')) + "\n<br><br>\n    <button class=\"btn btn-block btn-success\" id=\"saveEvent\">OK</button>\n  </span>";
      },
      yellowEvent: function() {
        var id, pl;
        return "<span id='yellow'>\n<nav class=\"navbar navbar-default\" role=\"navigation\">\n  <div class=\"navbar-header\">\n    <a class=\"navbar-brand\">Жёлтая карточка</a>\n  </div>\n</nav>\n  <h4>Millwall</h4>\n  " + (((function() {
          var _ref, _results;
          _ref = registry.currentGame.homeTeam.players;
          _results = [];
          for (id in _ref) {
            pl = _ref[id];
            _results.push("<button id='" + id + "' class='btn btn-default playerEvent " + (pl.yellow === 2 ? "btn-selected-red" : pl.yellow === 1 ? "btn-selected-yellow" : "") + "'>" + pl.number + "</button> ");
          }
          return _results;
        })()).join('')) + "\n  <h4>Wimbledon</h4>\n  " + (((function() {
          var _ref, _results;
          _ref = registry.currentGame.awayTeam.players;
          _results = [];
          for (id in _ref) {
            pl = _ref[id];
            _results.push("<button id='" + id + "' class='btn btn-default playerEvent " + (pl.yellow === 2 ? "btn-selected-red" : pl.yellow === 1 ? "btn-selected-yellow" : "") + "'>" + pl.number + "</button> ");
          }
          return _results;
        })()).join('')) + "\n\n<br><br><button class=\"btn btn-block btn-success\" id=\"saveEvent\">OK</button>\n</span>";
      },
      redEvent: function() {
        var id, pl;
        console.log(registry.currentGame.homeTeam.players);
        return "<span id='red'>\n<nav class=\"navbar navbar-default\" role=\"navigation\">\n  <div class=\"navbar-header\">\n    <a class=\"navbar-brand\">Прямая красная</a>\n  </div>\n</nav>\n  <h4>Millwall</h4>\n  " + (((function() {
          var _ref, _results;
          _ref = registry.currentGame.homeTeam.players;
          _results = [];
          for (id in _ref) {
            pl = _ref[id];
            _results.push("<button id='" + id + "' class='btn btn-default playerEvent " + (pl.red === 1 ? "btn-selected-red" : "") + "'>" + pl.number + "</button> ");
          }
          return _results;
        })()).join('')) + "\n  <h4>Wimbledon</h4>\n  " + (((function() {
          var _ref, _results;
          _ref = registry.currentGame.awayTeam.players;
          _results = [];
          for (id in _ref) {
            pl = _ref[id];
            _results.push("<button id='" + id + "' class='btn btn-default playerEvent " + (pl.red === 1 ? "btn-selected-red" : "") + "' >" + pl.number + "</button> ");
          }
          return _results;
        })()).join('')) + "\n\n<br><br><button class=\"btn btn-block btn-success\" id=\"saveEvent\">OK</button>\n</span>";
      },
      endEvent: function() {
        return "<button class=\"btn btn-block btn-info\" id=\"homeTeamChoise\">выбор<br>" + registry.currentGame.homeTeam.name + "</button> <br>\n<button class=\"btn btn-block btn-info\"  type=\"button\" id=\"awayTeamChoise\">выбор<br>" + registry.currentGame.awayTeam.name + "</button> <br>\n<button class=\"btn btn-block btn-success\" id=\"saveChoises\">OK</button>";
      },
      choise: function(side) {
        var html, id, mark, pl, players, team, _i;
        players = [];
        if (side === 'Home') {
          players = registry.currentGame.awayTeam.players;
          team = registry.currentGame.homeTeam;
        } else {
          players = registry.currentGame.homeTeam.players;
          team = registry.currentGame.awayTeam;
        }
        html = "    <nav class=\"navbar navbar-default\" role=\"navigation\">\n        <div class=\"navbar-header\">\n            <a class=\"navbar-brand\">" + team.name + ": оценка судье</a>\n        </div>\n    </nav>\n<div>\n    <div class=\"row\">";
        for (mark = _i = 2; _i <= 5; mark = ++_i) {
          html += "<div class=\"col-xs-3 col-md-3 col-lg-3\">\n  <button type=\"button\" class='btn btn-default btn-block refereeMark mark" + side + " " + (mark === team.refereeMark ? ":active" : "") + "'>" + mark + "</button>\n</div>";
        }
        return html += "</div><br>\n  <nav class=\"navbar navbar-default\" role=\"navigation\">\n    <div class=\"navbar-header\">\n        <a class=\"navbar-brand\">лучшие игроки соперника</a>\n    </div>\n  </nav>\n<div>\n" + (((function() {
          var _results;
          _results = [];
          for (id in players) {
            pl = players[id];
            _results.push("<button class='btn btn-default playerEvent bestPlayer " + (pl.star != null ? ":active" : "") + "'  id='" + id + "' class='playerEvent bestPlayer }'>" + pl.number + "</button>");
          }
          return _results;
        })()).join('')) + "\n</div><br><button class=\"btn btn-block btn-success\" id=\"save" + side + "TeamChoise\">OK</button>";
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
    registry = {
      currentEvent: 'G+'
    };
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
      if (game) {
        this.currentGame.homeTeam.score = this.currentGame.awayTeam.score = 0;
      }
      return this.save();
    };
    registry.setUser = function(user) {
      this.currentUser = user;
      return this.save();
    };
    registry.setHomeRefereeMark = function(mark) {
      this.currentGame.homeTeam.refereeMark = parseInt(mark);
      return this.save();
    };
    registry.setAwayRefereeMark = function(mark) {
      this.currentGame.awayTeam.refereeMark = parseInt(mark);
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
        this.currentGame.homeTeam.players[id].played = isActive;
      } else {
        this.currentGame.awayTeam.players[id].played = isActive;
      }
      return this.save();
    };
    registry.setPlayerGoals = function(id, goals) {
      var pl, _ref, _ref1;
      if (this.currentGame.homeTeam.players[id] != null) {
        this.currentGame.homeTeam.players[id].goals = goals;
      } else {
        this.currentGame.awayTeam.players[id].goals = goals;
      }
      this.currentGame.homeTeam.score = this.currentGame.awayTeam.score = 0;
      _ref = this.currentGame.homeTeam.players;
      for (id in _ref) {
        pl = _ref[id];
        if (pl.goals != null) {
          this.currentGame.homeTeam.score += parseInt(pl.goals);
        }
      }
      _ref1 = this.currentGame.awayTeam.players;
      for (id in _ref1) {
        pl = _ref1[id];
        if (pl.goals != null) {
          this.currentGame.awayTeam.score += parseInt(pl.goals);
        }
      }
      return this.save();
    };
    registry.setPlayerAssists = function(id, assists) {
      if (this.currentGame.homeTeam.players[id] != null) {
        this.currentGame.homeTeam.players[id].assists = assists;
      } else {
        this.currentGame.awayTeam.players[id].assists = assists;
      }
      return this.save();
    };
    registry.setPlayerYellow = function(id, yellow) {
      if (this.currentGame.homeTeam.players[id] != null) {
        this.currentGame.homeTeam.players[id].yellow = yellow;
      } else {
        this.currentGame.awayTeam.players[id].yellow = yellow;
      }
      return this.save();
    };
    registry.setPlayerRed = function(id, red) {
      if (this.currentGame.homeTeam.players[id] != null) {
        this.currentGame.homeTeam.players[id].red = red;
      } else {
        this.currentGame.awayTeam.players[id].red = red;
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
    $('#container').on('click', '.protocol .player', function() {
      $(this).toggleClass('btn-selected');
      return registry.setPlayerActivity($(this).attr('id'), $(this).hasClass('btn-selected'));
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
    $('#container').on('click', '.goalEventType', function() {
      $(this).parent().find('.goalEventType').each(function() {
        return $(this).removeClass('active');
      });
      $(this).addClass('active');
      return registry.currentEvent = $(this).attr('id');
    });
    $('#container').on('click', '#goal .playerEvent', function() {
      if (registry.currentEvent === 'G+') {
        $(this).find('.goals').html(parseInt($(this).find('.goals').html()) + 1);
      }
      if (registry.currentEvent === 'G-') {
        $(this).find('.goals').html(parseInt($(this).find('.goals').html()) - 1);
      }
      if (registry.currentEvent === 'A+') {
        $(this).find('.assists').html(parseInt($(this).find('.assists').html()) + 1);
      }
      if (registry.currentEvent === 'A-') {
        $(this).find('.assists').html(parseInt($(this).find('.assists').html()) - 1);
      }
      registry.setPlayerGoals($(this).attr('id'), $(this).find('.goals').html());
      return registry.setPlayerAssists($(this).attr('id'), $(this).find('.assists').html());
    });
    $('#container').on('click', '#yellow .playerEvent', function() {
      if ($(this).hasClass('btn-selected-yellow')) {
        $(this).removeClass('btn-selected-yellow').addClass('btn-selected-red');
        return registry.setPlayerYellow($(this).attr('id'), 2);
      } else if ($(this).hasClass('btn-selected-red')) {
        $(this).removeClass('btn-selected-red');
        return registry.setPlayerYellow($(this).attr('id'), 0);
      } else {
        $(this).addClass('btn-selected-yellow');
        return registry.setPlayerYellow($(this).attr('id'), 1);
      }
    });
    $('#container').on('click', '#red .playerEvent', function() {
      if ($(this).hasClass('btn-selected-red')) {
        $(this).removeClass('btn-selected-red');
        return registry.setPlayerRed($(this).attr('id'), 0);
      } else {
        $(this).addClass('btn-selected-red');
        return registry.setPlayerRed($(this).attr('id'), 1);
      }
    });
    $('#container').on('click', '.refereeMark', function() {
      if ($(this).hasClass('markHome')) {
        registry.setHomeRefereeMark($(this).html());
      } else {
        registry.setAwayRefereeMark($(this).html());
      }
      $(this).parent().parent().find('.btn-selected').each(function() {
        return $(this).removeClass('btn-selected');
      });
      return $(this).addClass('btn-selected');
    });
    $('#container').on('click', '.bestPlayer', function() {
      if ($(this).hasClass('btn-selected')) {
        $(this).removeClass('btn-selected');
        return registry.removeBestPlayer($(this).attr('id'));
      } else if ($(this).parent('.btn-selected').length < 3) {
        $(this).addClass('btn-selected');
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
        registry.setCurrentGame(null);
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
      return $('#container').html(templates.events());
    });
  });

}).call(this);
