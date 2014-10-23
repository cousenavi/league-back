(function() {
  (function($) {
    var templates;
    templates = {
      table: function(rows, compareDt) {
        return "<table class=\"table\"><thead>" + (templates.head()) + "</thead><tbody>" + (rows.join('')) + "</tbody></table>\n* - изменения позиций по сравнению с таблицей от " + compareDt;
      },
      head: function() {
        return "<th>Pos</th> <th>Team</th> <th>GP</th> <th>W</th> <th>D</th> <th>L</th> <th>F</th> <th>A</th> <th>GD</th> <th>PTS</th> <th>LAST 5</th>";
      },
      arrow: function(team) {
        var arrowClass, d;
        if (team.diff == null) {
          return '';
        } else {
          d = team.diff;
          arrowClass = (d > 2 ? 'gv' : d > 0 ? 'gd' : d === 0 ? 'yh' : d > -2 ? 'rd' : 'rv');
          return "(<i class='arrow " + arrowClass + "'></i>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + (d > 0 ? '+' : '') + d + ")";
        }
      },
      row: function(team) {
        var formHtml, html, res, _i, _len, _ref;
        formHtml = '';
        _ref = team.form.slice(-5);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          res = _ref[_i];
          formHtml += "<img src='/img/circle/";
          formHtml += (res === 'w' ? 'green.png' : res === 'd' ? 'yellow.png' : 'red.png');
          formHtml += "' height='16px' width='16px'>";
        }
        return html = "  <tr>\n    <td><span class=\"position\">" + team.position + "</span>\n    " + (this.arrow(team)) + "\n    </td>\n    <td>" + ((team.logo != null) && team.logo !== '' ? "<img class='logo' src='/" + team.logo + "'>&nbsp;" : '') + "\n\n      <span class=\"name\">" + team.name + "</span></td>\n    <td>" + team.played + "</td>\n    <td>" + team.won + "</td>\n    <td>" + team.draw + "</td>\n    <td>" + team.lost + "</td>\n    <td>" + team.scored + "</td>\n    <td>" + team.conceded + "</td>\n    <td>" + (team.scored - team.conceded) + "</td>\n    <td>" + team.score + "</td>\n    <td>" + formHtml + "</td>\n</tr>";
      }
    };
    return $.fn.table = function(leagueId, dt, compareWithDt) {
      var buildQuery;
      buildQuery = function() {
        var query;
        query = '?leagueId=' + leagueId;
        if (dt != null) {
          query += '&dt=' + dt;
        }
        if (compareWithDt != null) {
          query += '&compare_with_dt=' + compareWithDt;
        }
        return query;
      };
      return $.getJSON("/tables/simple_table" + buildQuery(), (function(_this) {
        return function(table) {
          var rows, team;
          rows = (function() {
            var _i, _len, _ref, _results;
            _ref = table.teams;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              team = _ref[_i];
              _results.push(templates.row(team));
            }
            return _results;
          })();
          return _this.html(templates.table(rows, compareWithDt));
        };
      })(this));
    };
  })(jQuery);

}).call(this);
