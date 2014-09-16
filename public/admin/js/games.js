(function() {
  $(function() {
    var gm, user;
    templates.games = function(games) {};
    console.log(games);
    "<button class=\"btn btn-block btn-success\" id=\"addBtn\" autofocus><span class=\"glyphicon glyphicon-plus\"></span></button>\n<table class=\"table table-hover\">\n" + (((function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = games.length; _i < _len; _i++) {
        gm = games[_i];
        _results.push("<tr>" + (templates.hiddenModel(gm)) + "<td>" + gm.homeTeamName + "</td><td>" + gm.awayTeamName + "</td><td>" + pl.position + "</td></tr>");
      }
      return _results;
    })()).join('')) + "\n</table>";
    templates.modal = function(game) {
      return "<div class=\"modal active\" role=\"dialog\" aria-labelledby=\"myModalLabel\" aria-hidden=\"true\">\n  <div class=\"modal-dialog\">\n    <div class=\"modal-content\">\n      <div class=\"modal-header\">\n        <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">×</button>\n        <h4 class=\"modal-title\">" + (game == null ? 'Добавление матча' : 'Редактирование матча') + "</h4>\n      </div>\n      <div class=\"modal-body\">" + (templates.modalBody(game)) + "</div>\n      <div class=\"modal-footer\">\n        <div class=\"row\">\n          <div class=\"col-xs-6  col-md-6 col-lg-6\">\n                " + (game != null ? "<button id='" + player._id + "' class='btn btn-danger delBtn' style='float: left'>delete</button>" : '') + "\n          </div>\n          <div class=\"col-xs-6 col-md-6 col-lg-6\">\n                <button class=\"btn btn-success addBtn\" tabindex=4>save</button>\n          </div>\n        </div>\n      </div>\n    </div>\n  </div>\n</div>";
    };
    templates.modalBody = function(game, teams) {
      return "<div class=\"row\">\n      <div class=\"col-xs-6  col-md-6 col-lg-6\">\n          " + templates.modal + "\n      </div>\n      <div class=\"col-xs-6 col-md-6 col-lg-6\">\n        " + (templates.teamSelect(teamSelect(teams))) + "\n      </div>\n</div><br>\n\n<div class=\"row\">\n      <div class=\"col-xs-2  col-md-2 col-lg-2\">\n            <input type=\"text\" class=\"form-control\" placeholder='тур'>\n      </div>\n      <div class=\"col-xs-6 col-md-6 col-lg-6\">\n            <input type=\"text\" class=\"form-control\" placeholder='дата'>\n      </div>\n      <div class=\"col-xs-4 col-md-4 col-lg-4\">\n            <input type=\"text\" class=\"form-control\" placeholder='время'>\n      </div>\n</div><br>\n\n<div class=\"row\">\n      <div class=\"col-xs-6  col-md-6 col-lg-6\">\n        <select></select>\n      </div>\n      <div class=\"col-xs-6 col-md-6 col-lg-6\">\n        <select></select>\n      </div>\n</div>";
    };
    templates.teamSelect = function(teams) {
      var html, tm;
      html = "<select class='form-control'>";
      html += (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = teams.length; _i < _len; _i++) {
          tm = teams[_i];
          _results.push("<option value='" + tm._id + "'>" + tm.name + "</option>");
        }
        return _results;
      })();
      return html += "</select>";
    };
    $('#container').on('click', '#addBtn', function() {
      $(templates.modal()).modal({
        show: true
      });
      return $('.modal [data-value=name]').focus();
    });
    user = localStorageRead('user');
    if (user == null) {
      location.href = '/admin';
    }
    if (user.role === 'root') {
      location.href = '/admin';
    }
    if (user.role === 'Captain') {
      location.href = '/admin';
    }
    if (user.role === 'Head') {
      return $.when($.getJSON("/teams?leagueId=" + user.leagueId), $.getJSON('/places'), $.getJSON('/referees'), $.getJSON("/games?leagueId=" + user.leagueId)).then(function(teams, places, referees, games) {
        return $('#container').html(templates.games(games[0]));
      });
    }
  });

}).call(this);
