(function() {
  (function($) {
    var templates;
    templates = {
      body: function(sortOrder, players) {
        var filteredPlayers, html, pl, sort, sortByFields, _i, _len;
        sortByFields = function(fieldNames) {
          return function(a, b) {
            var fieldName, order;
            for (fieldName in fieldNames) {
              order = fieldNames[fieldName];
              if (a[fieldName] < b[fieldName]) {
                return 1 * order;
              }
              if (a[fieldName] > b[fieldName]) {
                return -1 * order;
              }
            }
            return 0;
          };
        };
        sort = {};
        sort[sortOrder] = 1;
        sort['played'] = -1;
        filteredPlayers = players.sort(sortByFields(sort)).filter(function(pl) {
          return pl[sortOrder] > 0;
        });
        html = '';
        for (_i = 0, _len = filteredPlayers.length; _i < _len; _i++) {
          pl = filteredPlayers[_i];
          html += "                <tr>\n                  <td>\n" + (pl.teamLogo ? "<img style='width: 20px; height: 20px' src='/" + pl.teamLogo + "'>&nbsp;" : "") + pl.name + "</td>\n                  <td " + (sortOrder === 'goals' ? "class='active'" : '') + "> " + pl.goals + "</td>\n                  <td " + (sortOrder === 'assists' ? "class='active'" : '') + ">" + pl.assists + "</td>\n                  <td " + (sortOrder === 'points' ? "class='active'" : '') + ">" + pl.points + "</td>\n                  <td " + (sortOrder === 'yellow' ? "class='active'" : '') + ">" + pl.yellow + "</td>\n                  <td " + (sortOrder === 'red' ? "class='active'" : '') + ">" + pl.red + "</td>\n                  <td " + (sortOrder === 'played' ? "class='active'" : '') + ">" + pl.played + "</td>\n                </tr>";
        }
        return html;
      },
      table: function(sortOrder, body) {
        var arrow, html;
        arrow = "&nbsp;<span class='glyphicon glyphicon-arrow-down arrow' style='color: green'></span>";
        html = "<table id=\"topplayers\" class=\"table table-striped\">\n<thead>\n  <th>Name</th>\n  <th data-sort=\"goals\">G" + (sortOrder === 'goals' ? arrow : '') + "</th>\n  <th data-sort=\"assists\">A" + (sortOrder === 'assists' ? arrow : '') + "</th>\n  <th data-sort=\"points\">G+A" + (sortOrder === 'points' ? arrow : '') + "</th>\n\n  <th data-sort=\"yellow\"><span class='glyphicon glyphicon-book' style=\"color:yellow\"></span>\n    " + (sortOrder === 'yellow' ? arrow : '') + "</th>\n  <th data-sort=\"red\"><span class='glyphicon glyphicon-book' style=\"color:red\"></span>\n    " + (sortOrder === 'red' ? arrow : '') + "</th>\n  <th data-sort=\"played\">GP" + (sortOrder === 'played' ? arrow : '') + "</th>\n</thead><tbody>";
        html += body;
        html += '</tbody></table>';
        return html;
      }
    };
    return $.fn.listplayers = function(leagueId, field) {
      return $.getJSON("/tables/top_players?field=" + field, {
        leagueId: leagueId
      }, (function(_this) {
        return function(table) {
          var body;
          body = templates.body(field, table.players);
          return _this.html(templates.table(field, body));
        };
      })(this));
    };
  })(jQuery);

}).call(this);
