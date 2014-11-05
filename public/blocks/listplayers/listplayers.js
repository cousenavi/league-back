(function() {
  (function($) {
    var sortByField, templates;
    sortByField = function(fieldName) {
      return function(a, b) {
        if (a[fieldName] < b[fieldName]) {
          return 1;
        }
        if (a[fieldName] > b[fieldName]) {
          return -1;
        }
        return 0;
      };
    };
    templates = {
      player: function(pl, field) {
        return "<tr>\n  <td><img src=\"/" + pl.teamLogo + "\"> " + pl.name + "</td>\n  <td>" + pl[field] + "</td>\n</tr>";
      },
      table: function(players, fieldName, leagueName) {
        var html, pl, pls;
        pls = ((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = players.length; _i < _len; _i++) {
            pl = players[_i];
            _results.push(templates.player(pl, fieldName));
          }
          return _results;
        })()).join('');
        return html = "<div id=\"prv\">\n  <div id='head'>\n      <div id='leagueName'>" + leagueName + "</div><div id='tourNumber'>" + fieldName + "</div>\n  </div>\n  <table>\n    " + pls + "\n  </table>\n</div>";
      }
    };
    return $.fn.listplayers = function(leagueId, field) {
      return $.getJSON("/tables/top_players?field=" + field, {
        leagueId: leagueId
      }, (function(_this) {
        return function(table) {
          var LIMIT, filteredPlayers;
          LIMIT = 15;
          filteredPlayers = table.players.sort(sortByField(field)).filter(function(pl) {
            return pl[field] > 0 && pl[field] >= table.players[LIMIT][field];
          });
          return _this.html(templates.table(filteredPlayers, field, 'Amateur Portugal League'));
        };
      })(this));
    };
  })(jQuery);

}).call(this);
