(function() {
  (function($) {
    var templates;
    templates = {
      stats: function(stats) {
        var pl, tm;
        return " <table class=\"table table-striped summary\">\n   <thead>\n   <th></th>\n   <th>в туре</th>\n   <th>рекорд</th>\n   </thead>\n   <tbody>\n     <tr><td><b>Сыграно матчей</b></td><td>" + stats.played + "</td><td></td></tr>\n     <tr><td><b>Забито голов</b></td><td>" + stats.scored + "</td><td>" + stats.records.scored.val + " <span class=\"recordTour\">(" + stats.records.scored.tour + " тур)</span></td></tr>\n     <tr><td><b>Показано жёлтых</b></td><td>" + stats.yellow + "</td><td></td></tr>\n     <tr><td><b>Показано красных</b></td><td>" + stats.red + "</td><td></td></tr>\n     <tr><td><b>Забили больше всех</b></td>\n         <td>" + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.topScoredTeams;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tm = _ref[_i];
            _results.push("<img src='/" + tm.logo + "'> " + tm.name + " (" + tm.goals + ")");
          }
          return _results;
        })()).join(', ')) + "</td>\n         <td>" + stats.records.topScoredTeams.goals + ": " + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.records.topScoredTeams.teams;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tm = _ref[_i];
            _results.push("<img src='/" + tm.logo + "'> " + tm.name + " <span class='recordTour'>(" + tm.tour + " тур)</span>");
          }
          return _results;
        })()).join(', ')) + "</td>\n     </tr>\n     <tr><td><b>Пропустили меньше всех</b></td>\n         <td>" + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.lessConceededTeams;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tm = _ref[_i];
            _results.push("<img src='/" + tm.logo + "' > " + tm.name + " (" + tm.goals + ")");
          }
          return _results;
        })()).join(', ')) + "</td>\n         <td>" + stats.records.lessConceededTeams.goals + ": " + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.records.lessConceededTeams.teams;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tm = _ref[_i];
            _results.push("<img src='/" + tm.logo + "'> " + tm.name + " <span class='recordTour'>(" + tm.tour + " тур)</span>");
          }
          return _results;
        })()).join(', ')) + "</td></tr>\n     <tr><td><b>Самая грубая команда</b></td><td>" + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.mostRudeTeams;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tm = _ref[_i];
            _results.push("<img src='/" + tm.logo + "' > " + tm.name + " (" + tm.yellow + " + " + tm.red + ")");
          }
          return _results;
        })()).join(', ')) + "</td><td></td></tr>\n     <tr><td><b>Голеодор тура</b></td>\n         <td>" + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.topGoalscorers;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            pl = _ref[_i];
            _results.push("<img src='/" + pl.teamLogo + "'> " + pl.name + " (" + pl.goals + ")");
          }
          return _results;
        })()).join(', ')) + "</td>\n         <td>" + stats.records.goalscorers.goals + ": " + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.records.goalscorers.players;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            pl = _ref[_i];
            _results.push("<img src='/" + pl.logo + "'> " + pl.name + " <span class='recordTour'>(" + pl.tour + " тур)</span>");
          }
          return _results;
        })()).join(', ')) + "</td></tr>\n     </tr>\n     <tr><td><b>Ассистент тура</b></td>\n         <td>" + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.topAssistants;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            pl = _ref[_i];
            _results.push("<img src='/" + pl.teamLogo + "'> " + pl.name + " (" + pl.assists + ")");
          }
          return _results;
        })()).join(', ')) + "</td>\n         <td>" + stats.records.assistants.assists + ": " + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.records.assistants.players;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            pl = _ref[_i];
            _results.push("<img src='/" + pl.logo + "'> " + pl.name + " <span class='recordTour'>(" + pl.tour + " тур)</span>");
          }
          return _results;
        })()).join(', ')) + "</td></tr>\n</tr>\n     <tr><td><b>Серия без поражений</b></td>\n       <td>" + stats.records.formsRecords.withoutLoses.games + ": " + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.records.formsRecords.withoutLoses.teams;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tm = _ref[_i];
            _results.push("<img src='/" + tm.logo + "'> " + tm.name);
          }
          return _results;
        })()).join(', ')) + "</td>\n       <td>" + stats.records.formsRecords.withoutLosesBest.games + ": " + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.records.formsRecords.withoutLosesBest.teams;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tm = _ref[_i];
            _results.push("<img src='/" + tm.logo + "'> " + tm.name);
          }
          return _results;
        })()).join(', ')) + "</td>\n     </tr>\n     <tr><td><b>Серия без побед</b></td>\n<td>" + stats.records.formsRecords.withoutWins.games + ": " + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.records.formsRecords.withoutWins.teams;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tm = _ref[_i];
            _results.push("<img src='/" + tm.logo + "'> " + tm.name);
          }
          return _results;
        })()).join(', ')) + "</td>\n       <td>" + stats.records.formsRecords.withoutWinsBest.games + ": " + (((function() {
          var _i, _len, _ref, _results;
          _ref = stats.records.formsRecords.withoutWinsBest.teams;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            tm = _ref[_i];
            _results.push("<img src='/" + tm.logo + "'> " + tm.name);
          }
          return _results;
        })()).join(', ')) + "</td>\n\n</tr>\n   </tbody>\n </table>";
      },
      table: function(rows, tourNumber) {
        return "<div id=\"prv\">\n  <div id='head'>\n      <div id='leagueName'>Amateur Portugal League</div><div id='tourNumber'>тур " + tourNumber + "</div>\n  </div>\n  " + (rows.join('')) + "\n</div>";
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
        return "<div class=\"row match\">\n  <div class=\"col-xs-2 col-md-2 col-lg-2\"><img src =\"/" + game.homeTeamLogo + "\"></div>\n  <div class=\"col-xs-3 col-md-3 col-lg-3 teamName\">" + game.homeTeamName + " " + (game.homeTeamPlayers != null ? computePlayers(game.homeTeamPlayers) : '') + "</div>\n  <div class=\"col-xs-2 col-md-2 col-lg-2 score\">\n    " + (game.homeTeamScore != null ? "" + game.homeTeamScore + " - " + game.awayTeamScore : (game.time != null ? game.date + " " + game.time : game.date)) + "\n  </div>\n  <div class=\"col-xs-3 col-md-3 col-lg-3 teamName\" >" + game.awayTeamName + " " + (game.awayTeamPlayers != null ? computePlayers(game.awayTeamPlayers) : '') + "</div>\n  <div class=\"col-xs-2 col-md-2 col-lg-2\"><img src =\"/" + game.awayTeamLogo + "\"></div>\n</div>";
      }
    };
    $('body').on('click', '.summary tr', function() {
      return $(this).hide();
    });
    $.fn.calendar = function(leagueId, tourNumber) {
      return $.getJSON("/games/?leagueId=" + leagueId + "&showPlayers=1&tourNumber=" + tourNumber, (function(_this) {
        return function(games) {
          var gm;
          return _this.html(templates.table((function() {
            var _i, _len, _results;
            _results = [];
            for (_i = 0, _len = games.length; _i < _len; _i++) {
              gm = games[_i];
              _results.push(templates.row(gm));
            }
            return _results;
          })(), tourNumber));
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
