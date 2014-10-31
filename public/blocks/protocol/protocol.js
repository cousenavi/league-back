(function() {
  (function($) {
    var templates;
    templates = {
      protocol: function(gm, homePl, awayPl) {
        var i;
        gm.leagueName = gm.leagueName || 'Amateurs Portugal League';
        return "<div class=\"page\">\n<div class='statsWrap'>\n  <div id='head'>\n      <div id='leagueName'>Amateur Portugal League</div><div id='tourNumber'>тур №9</div>\n  </div>\n  <h1>" + gm.homeTeamName + " - " + gm.awayTeamName + "</h1>\n  <div>Счёт матча:  ___ : ___  (после первого тайма: ___ : ___)</div><br>\n  <table class=\"table\">\n  <thead>\n    <th>#</th><th>имя</th><th>Г + П</th><th>Ж + К</th><th>З + З</th>\n    <th>#</th><th>имя</th><th>Г + П</th><th>Ж + К</th><th>З + З</th>\n  </thead>\n  <tbody>\n    " + (((function() {
          var _i, _ref, _ref1, _ref2, _ref3, _results;
          _results = [];
          for (i = _i = 0; _i <= 24; i = ++_i) {
            _results.push("<tr " + ((homePl[i] == null) && (awayPl[i] == null) ? 'style="height: 0;border: 0;"' : '') + "><td>" + (((_ref = homePl[i]) != null ? _ref.number : void 0) || '') + "</td><td>" + (((_ref1 = homePl[i]) != null ? _ref1.name : void 0) || '') + "</td><td></td><td></td><td></td><td>" + (((_ref2 = awayPl[i]) != null ? _ref2.number : void 0) || '') + "</td><td>" + (((_ref3 = awayPl[i]) != null ? _ref3.name : void 0) || '') + "</td><td></td><td></td><td></td></tr>");
          }
          return _results;
        })()).join('')) + "\n  </tbody>\n  </table>\n<span class=\"help\">Г+П: гол + пас, Ж+К: карточки, И+И: игрок матча (выбор своих) + (выбор соперника)<br>\nПримеры заполнения: 2+3; 1+0; 0+1</span>\n<br><br><br><br>\n<table id=\"signs\">\n<tr><td>__________________________</td><td>__________________________</td><td>____________________________</td></tr>\n<tr><td>главный судья</td><td>капитан " + gm.homeTeamName + "</td><td>капитан " + gm.awayTeamName + "</td></tr>\n</table>\n  <div id='foot'>\n            <div id='date'>" + gm.date + "</div>\n            <div id='time'>" + gm.time + "</div>\n            <div id='place'>стадион \"" + gm.placeName + "\"</div>\n  </div>\n  </div></div>";
      }
    };
    return $.fn.protocol = function(leagueId) {
      var formatPlayersNames;
      formatPlayersNames = function(players) {
        var firstName, lastName, pl, _i, _len;
        for (_i = 0, _len = players.length; _i < _len; _i++) {
          pl = players[_i];
          pl.name = pl.name.toLowerCase();
          firstName = pl.name.split(' ')[0];
          firstName = firstName.charAt(0).toUpperCase() + firstName.slice(1);
          lastName = pl.name.split(' ')[1];
          lastName = lastName.charAt(0).toUpperCase() + lastName.slice(1);
          pl.name = firstName + ' ' + lastName;
        }
        return players.sort(function(a, b) {
          if (a.number > b.number) {
            return 1;
          } else {
            return -1;
          }
        });
      };
      return $.getJSON('/games?leagueId=54009eb17336983c24342ed9&ended=false', (function(_this) {
        return function(games) {
          var loadGames;
          loadGames = function(i) {
            return $.when($.getJSON("/players?teamId=" + games[i].homeTeamId), $.getJSON("/players?teamId=" + games[i].awayTeamId)).then(function(homePlayers, awayPlayers) {
              formatPlayersNames(homePlayers[0]);
              formatPlayersNames(awayPlayers[0]);
              _this.append(templates.protocol(games[i], homePlayers[0], awayPlayers[0]));
              if (games[i] != null) {
                return loadGames(i + 1);
              }
            });
          };
          if (games[0] != null) {
            return loadGames(0);
          }
        };
      })(this));
    };
  })(jQuery);

}).call(this);
