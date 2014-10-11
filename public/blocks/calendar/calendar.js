// Generated by CoffeeScript 1.8.0
(function() {
  (function($) {
    var templates;
    templates = {
      table: function(rows) {
        return "" + (rows.join(''));
      },
      stats: function(stats) {
        var pl, tm;
        return "<table class=\"table table-striped summary\">\n  <thead>\n  <th><img src=\"/" + stats.leagueLogo + "\"></th>\n  <th>Tour# " + stats.tourNumber + "</th>\n  </thead>\n  <tbody>\n    <tr><td><b>Сыграно матчей</b></td><td>" + stats.played + "</td></tr>\n    <tr><td><b>Забито голов</b></td><td>" + stats.scored + "</td></tr>\n    <tr><td><b>Показано жёлтых</b></td><td>" + stats.yellow + "</td></tr>\n    <tr><td><b>Показано красных</b></td><td>" + stats.red + "</td></tr>\n    <tr><td><b>Забили больше всех</b></td><td>" + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.topScoredTeams;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tm = _ref[_i];
            _results.push("<img src='/" + tm.logo + "'> " + tm.name + " (" + tm.goals + ")");
          }
          return _results;
        })()).join(', ')) + "</td></tr>\n    <tr><td><b>Пропустили меньше всех</b></td><td>" + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.lessConceededTeams;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tm = _ref[_i];
            _results.push("<img src='/" + tm.logo + "' > " + tm.name + " (" + tm.goals + ")");
          }
          return _results;
        })()).join(', ')) + "</td></tr>\n    <tr><td><b>Самая грубая команда</b></td><td>" + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.mostRudeTeams;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tm = _ref[_i];
            _results.push("<img src='/" + tm.logo + "' > " + tm.name + " (" + tm.yellow + " + " + tm.red + ")");
          }
          return _results;
        })()).join(', ')) + "</td></tr>\n    <tr><td><b>Голеодор тура</b></td><td>" + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.topGoalscorers;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            pl = _ref[_i];
            _results.push("<img src='/" + pl.teamLogo + "'> " + pl.name + " (" + pl.goals + ")");
          }
          return _results;
        })()).join(', ')) + "</td></tr>\n    <tr><td><b>Ассистент тура</b></td><td>" + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.topAssistants;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            pl = _ref[_i];
            _results.push("<img src='/" + pl.teamLogo + "'> " + pl.name + " (" + pl.assists + ")");
          }
          return _results;
        })()).join(', ')) + "</td></tr>\n  </tbody>\n</table>";
      },
      row: function(game) {
        var computePlayers;
        computePlayers = function(protocol) {
          var formattedPlayers, key, pl, players, _i, _j, _len, _len1;
          players = [];
          for (_i = 0, _len = protocol.length; _i < _len; _i++) {
            pl = protocol[_i];
            if (pl.goals > 0) {
              players.push({
                name: pl.name,
                goals: pl.goals
              });
            }
          }
          players.sort(function(a, b) {
            if (a.goals < b.goals) {
              return 1;
            } else {
              return -1;
            }
          });
          formattedPlayers = "";
          for (key = _j = 0, _len1 = players.length; _j < _len1; key = ++_j) {
            pl = players[key];
            pl.name = pl.name.split(' ')[0].toLowerCase();
            pl.name = pl.name.charAt(0).toUpperCase() + pl.name.slice(1);
            formattedPlayers += ' ' + pl.name;
            if (pl.goals > 1) {
              formattedPlayers += "(" + pl.goals + ")";
            }
            if (key < players.length - 1) {
              formattedPlayers += ',';
            }
          }
          return "<div class='players'>" + formattedPlayers + "</div>";
        };
        return "<div class=\"row match\">\n  <div class=\"col-xs-2 col-md-2 col-lg-2\"><img src =\"/" + game.homeTeamLogo + "\"></div>\n  <div class=\"col-xs-3 col-md-3 col-lg-3 teamName\">" + game.homeTeamName + " " + (game.homeTeamPlayers != null ? computePlayers(game.homeTeamPlayers) : '') + "</div>\n  <div class=\"col-xs-2 col-md-2 col-lg-2 score\">\n    " + (game.homeTeamScore != null ? "" + game.homeTeamScore + " - " + game.awayTeamScore : (game.time != null ? game.date + " " + game.time : game.date)) + "\n  </div>\n  <div class=\"col-xs-3 col-md-3 col-lg-3 teamName\" >" + game.awayTeamName + " " + (game.awayTeamPlayers != null ? computePlayers(game.awayTeamPlayers) : '') + "</div>\n  <div class=\"col-xs-2 col-md-2 col-lg-2\"><img src =\"/" + game.awayTeamLogo + "\"></div>\n</div><";
      }
    };
    $('body').on('click', '.summary tr', function() {
      return $(this).hide();
    });
    $.fn.calendar = function(leagueId, tourNumber) {
      return $.getJSON("/games/?leagueId=" + leagueId + "&showPlayers=1&tourNumber=" + tourNumber, (function(_this) {
        return function(games) {
          var gm;
          return _this.html((function() {
            var _i, _len, _results;
            _results = [];
            for (_i = 0, _len = games.length; _i < _len; _i++) {
              gm = games[_i];
              _results.push(templates.row(gm));
            }
            return _results;
          })());
        };
      })(this));
    };
    return $.fn.stats = function(leagueId, tourNumber) {
      return $.getJSON("/tables/tour_summary/?leagueId=" + leagueId + "&tourNumber=" + tourNumber, (function(_this) {
        return function(stats) {
          return _this.html(templates.stats(stats));
        };
      })(this));
    };
  })(jQuery);

}).call(this);
