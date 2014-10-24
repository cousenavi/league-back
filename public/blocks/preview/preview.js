(function() {
  (function($) {
    var templates;
    templates = {
      form: function(form) {
        var color, formHtml, res, _i, _len, _ref;
        formHtml = '';
        _ref = form.slice(-5);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          res = _ref[_i];
          color = (res === 'w' ? 'green' : res === 'd' ? 'yellow' : 'red');
          formHtml += "<i class='circle " + color + "'></i>";
        }
        return formHtml;
      },
      preview: function(pr) {
        return "<div id='prv'>\n    <div id='head'>\n        <div id='leagueName'>Amateur Portugal League</div><div id='tourNumber'>тур №" + pr.tourNumber + "</div>\n    </div>\n\n    <table>\n\n    <tbody><tr class='logo'>\n        <td><img src=\"/" + pr.teams[0].logo + "\" ><br>" + pr.teams[0].name + "</td>\n        <td>\n        </td>\n        <td><img src=\"/" + pr.teams[0].logo + "\" ><br>" + pr.teams[1].name + "</td>\n    </tr>\n    <tr><td></td><td>&nbsp;</td><td></td></tr>\n    <tr class='position'>\n        <td><div>" + pr.teams[0].position + "</div></td>\n        <td>позиция</td>\n        <td><div>" + pr.teams[1].position + "</div></td>\n    </tr>\n    <tr>\n        <td><progress max=\"" + pr.teams[0].played + "\" value=\"" + pr.teams[0].won + "\" class=\"r green\"></progress></td>\n        <td>победы</td>\n        <td><progress max=\"" + pr.teams[1].played + "\" value=\"" + pr.teams[1].won + "\" class=\"l green\"></progress></td>\n    </tr>\n    <tr>\n        <td><progress max=\"" + pr.teams[0].played + "\" value=\"" + pr.teams[0].draw + "\" class=\"r yellow\"></progress></td>\n        <td>ничьи</td>\n        <td><progress max=\"" + pr.teams[1].played + "\" value=\"" + pr.teams[1].draw + "\" class=\"l yellow\"></progress></td>\n    </tr>\n    <tr>\n        <td><progress max=\"" + pr.teams[0].played + "\" value=\"" + pr.teams[0].lost + "\" class=\"r red\"></progress></td>\n        <td>поражения</td>\n        <td><progress max=\"" + pr.teams[1].played + "\" value=\"" + pr.teams[0].lost + "\" class=\"l red\"></progress></td>\n    </tr>\n\n    <tr>\n        <td>\n            " + (templates.form(pr.teams[0].form)) + "\n        </td>\n        <td>форма</td>\n        <td>\n           " + (templates.form(pr.teams[1].form)) + "\n        </td>\n    </tr>\n\n    <tr><td></td><td>&nbsp;</td><td></td></tr>\n\n    <tr>\n        <td><progress max=\"" + pr.maxScored + "\" value=\"" + pr.teams[0].scored + "\" class=\"r green\"></progress></td>\n        <!-- максимум забитых - лучший показатель команд в чемпе -->\n        <td>забито</td>\n        <td><progress max=\"" + pr.maxScored + "\" value=\"" + pr.teams[1].scored + "\" class=\"l green\"></progress></td>\n    </tr>\n\n    <tr>\n        <td><progress max=\"" + pr.maxConceded + "\" value=\"" + pr.teams[0].conceded + "\" class=\"r red\"></progress></td>\n        <td>пропущено</td>\n        <td><progress max=\"" + pr.maxConceded + "\" value=\"" + pr.teams[1].conceded + "\" class=\"l red\"></progress></td>\n    </tr>\n    <tr><td></td><td>&nbsp;</td><td></td></tr>\n    <tr>\n        <td>\n            <div class=\"canvas-holder half\">\n                <canvas id=\"" + pr.gameId + "_homeTeamChart\" height=\"75\" style=\" height: 75px;\"></canvas>\n            </div>\n        </td>\n        <td>голеадоры</td>\n        <td>\n            <div class=\"canvas-holder half\">\n                <canvas id=\"" + pr.gameId + "_awayTeamChart\" height=\"75\" style=\" height: 75px;\"></canvas>\n            </div>\n        </td>\n    </tr>\n</tbody></table>\n        <div id='footer'>\n            <div id='date'>" + pr.date + "</div>\n            <div id='time'>" + pr.time + "</div>\n            стадион \"" + pr.placeName + "\"\n        </div></div>";
      }
    };
    return $.fn.preview = function(leagueId) {
      var drawChart;
      drawChart = function(preview) {
        var c1, c2, chart1, chart2, data, data1, data2, key, options, pl, _i, _j, _len, _len1, _ref, _ref1;
        options = {
          legendTemplate: "<% %><br><i class=\"circle small red\"></i> <%=segments[0].label%><br><i class=\"circle small yellow\"></i> <%=segments[1].label%><br><i class=\"circle small green\"></i> <%=segments[2].label%>",
          animation: false
        };
        data = function() {
          return [
            {
              color: '#cf0404'
            }, {
              color: '#febf04'
            }, {
              color: '#83c783'
            }, {
              color: '#ddd'
            }
          ];
        };
        data1 = new data();
        _ref = preview.teams[0].players;
        for (key = _i = 0, _len = _ref.length; _i < _len; key = ++_i) {
          pl = _ref[key];
          data1[key].label = pl.name + (" (" + pl.goals + ")");
          data1[key].value = pl.goals;
        }
        data2 = new data();
        _ref1 = preview.teams[1].players;
        for (key = _j = 0, _len1 = _ref1.length; _j < _len1; key = ++_j) {
          pl = _ref1[key];
          data2[key].label = pl.name + (" (" + pl.goals + ")");
          data2[key].value = pl.goals;
        }
        console.log(data1);
        c1 = $('#' + preview.gameId + '_homeTeamChart').get(0).getContext('2d');
        chart1 = new Chart(c1).Pie(data1, options);
        $('#' + preview.gameId + '_homeTeamChart').parent().append(chart1.generateLegend());
        c2 = $('#' + preview.gameId + '_awayTeamChart').get(0).getContext('2d');
        chart2 = new Chart(c2).Pie(data2, options);
        return $('#' + preview.gameId + '_awayTeamChart').parent().append(chart2.generateLegend());
      };
      return $.getJSON('/games?leagueId=54009eb17336983c24342ed9&ended=false', (function(_this) {
        return function(games) {
          var gm, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = games.length; _i < _len; _i++) {
            gm = games[_i];
            _results.push($.getJSON('/tables/game_preview?gameId=' + gm._id, function(preview) {
              _this.append(templates.preview(preview));
              return drawChart(preview);
            }));
          }
          return _results;
        };
      })(this));
    };
  })(jQuery);

}).call(this);
