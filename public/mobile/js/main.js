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
        console.log(game);
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
    $('#container').html(templates.login());
    $('#container').on('click', '#loginBtn', function() {
      var data;
      $(this).html('...').attr('disabled', 'true');
      data = extractData($(this).parent());
      return $.ajax({
        url: '/login',
        method: 'POST',
        data: data,
        success: function(matches) {
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
      return registry.sync();
    });
    registry = {
      currentGame: void 0
    };
    registry.save = function() {
      return console.log('здесь мы должны сохранить регистр в локал сторедж');
    };
    registry.sync = function() {
      return console.log('здесь мы синхронизируем регстр с сервером');
    };
    registry.setCurrentGame = function(game) {
      this.currentGame = game;
      return this.save();
    };
    return registry.setPlayerActivity = function(id, isActive) {
      if (this.currentGame.homeTeam.players[id] != null) {
        this.currentGame.homeTeam.players[id][2] = isActive;
      } else {
        this.currentGame.awayTeam.players[id][2] = isActive;
      }
      return this.save();
    };
  });

}).call(this);
