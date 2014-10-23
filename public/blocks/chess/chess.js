(function() {
  (function($) {
    var templates;
    templates = {
      table: function(heads, rows) {
        return "<div id=\"chesswrapper\"><table class=\"table\"><thead><th></th>" + (heads.join('')) + "</thead><tbody>" + (rows.join('')) + "</tbody></table></div>";
      },
      head: function(teamLogo) {
        return "<th><img src='/" + teamLogo + "'></th>";
      },
      row: function(team, cells) {
        return "<tr><td><img src='/" + team.logo + "'>&nbsp;" + team.name + "</td>" + (cells.join('')) + "</tr>";
      },
      cell: function(team, gm) {
        var color, html, m, _i, _len, _ref;
        if (team._id === gm.opponent) {
          return '<td><img src="/leagues/portugal/logo/league.png"></td>';
        } else {
          html = '';
          _ref = gm.matches;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            m = _ref[_i];
            color = (m.scored > m.conceeded ? 'green' : m.scored < m.conceeded ? 'red' : 'gray');
            html += "<div class='" + color + "'>" + m.scored + ":" + m.conceeded + "</div>";
          }
          return "<td>" + html + "</td>";
        }
      }
    };
    return $.fn.chess = function(leagueId) {
      return $.getJSON('/tables/chess_table', {
        leagueId: leagueId
      }, (function(_this) {
        return function(table) {
          var gm, heads, rows, tm;
          heads = (function() {
            var _i, _len, _ref, _results;
            _ref = table.teams;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              tm = _ref[_i];
              _results.push(templates.head(tm.logo));
            }
            return _results;
          })();
          console.log(table.teams);
          rows = (function() {
            var _i, _len, _ref, _results;
            _ref = table.teams;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              tm = _ref[_i];
              _results.push(templates.row(tm, (function() {
                var _j, _len1, _ref1, _results1;
                _ref1 = tm.games;
                _results1 = [];
                for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
                  gm = _ref1[_j];
                  _results1.push(templates.cell(tm, gm));
                }
                return _results1;
              })()));
            }
            return _results;
          })();
          return _this.html(templates.table(heads, rows));
        };
      })(this));
    };
  })(jQuery);

}).call(this);
