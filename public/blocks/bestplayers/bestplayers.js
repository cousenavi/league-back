(function() {
  (function($) {
    var templates;
    templates = {
      playerAchievement: function(pl) {
        var html;
        html = '';
        if (pl.goals) {
          html += "&nbsp;<i class='ev goal'></i>" + pl.goals;
        }
        if (pl.assists) {
          html += "&nbsp;<i class='ev assist'></i>" + pl.assists;
        }
        if (pl.star) {
          html += "&nbsp;<i class='ev star'></i>";
        }
        return html;
      },
      player: function(pl) {
        return "<tr>\n    <td style='width: 25px'><i class='logo'><img  src=\"/" + pl.teamLogo + "\"/></i></td>\n    <td>" + pl.firstName + "</td>\n    <td><i class='position'>" + pl.position + "</i>" + (templates.playerAchievement(pl)) + "</td>\n</tr>";
      },
      field: function(players, tourNumber) {
        var pl, _i, _len;
        for (_i = 0, _len = players.length; _i < _len; _i++) {
          pl = players[_i];
          pl.name = pl.name.toLowerCase();
          pl.firstName = pl.name.split(' ')[0];
          pl.firstName = pl.firstName.charAt(0).toUpperCase() + pl.firstName.slice(1);
          pl.lastName = pl.name.split(' ')[1];
          pl.fullName = pl.firstName + ' ' + pl.lastName.charAt(0).toUpperCase() + pl.lastName.slice(1);
        }
        return "<div id=\"prv\">\n  <div id='head'>\n      <div id='leagueName'>Amateur Portugal League</div><div id='tourNumber'>Тур №" + tourNumber + "</div>\n  </div>\n\n  <div id='field'>\n      " + (((function() {
          var _j, _len1, _results;
          _results = [];
          for (_j = 0, _len1 = players.length; _j < _len1; _j++) {
            pl = players[_j];
            _results.push("<div class='chip " + pl.position + "'><img src='/" + pl.teamLogo + "'/></div>");
          }
          return _results;
        })()).join('')) + "\n  </div>\n\n  <div id='players'>\n      <table>\n      " + (((function() {
          var _j, _len1, _results;
          _results = [];
          for (_j = 0, _len1 = players.length; _j < _len1; _j++) {
            pl = players[_j];
            _results.push(templates.player(pl));
          }
          return _results;
        })()).join('')) + "\n      </table>\n      <div id='legend'>\n         <i class='ev goal'></i> - гол <i class='ev assist'></i>- пас <i class='ev star'></i> - игрок матча\n\n      </div>\n\n  </div>\n\n  <div style='clear:both'></div>\n\n\n</div>";
      }
    };
    return $.fn.bestplayers = function(leagueId, tourNumber) {
      return $.getJSON("/tables/best_players?leagueId=" + leagueId + "&tourNumber=" + tourNumber, (function(_this) {
        return function(bp) {
          return _this.html(templates.field(bp[0].players, tourNumber));
        };
      })(this));
    };
  })(jQuery);

}).call(this);
