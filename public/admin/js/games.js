(function() {
  $(function() {
    var user;
    templates.games = function(games) {
      var currDate, gm;
      currDate = "";
      return "<button class=\"btn btn-block btn-success\" id=\"addBtn\" autofocus><span class=\"glyphicon glyphicon-plus\"></span></button>\n<table class=\"table\">\n" + (((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = games.length; _i < _len; _i++) {
          gm = games[_i];
          _results.push((currDate !== gm.date ? templates.separationRow(currDate = gm.date) : '') + ("<tr " + (gm.homeTeamScore == null ? 'class=\'game-notstarted\'' : '') + ">" + (templates.hiddenModel(gm)) + "<td>" + gm.homeTeamName + " - " + gm.awayTeamName + " " + (gm.homeTeamScore != null ? '<b>' + gm.homeTeamScore + '- ' + gm.awayTeamScore + '</b>' : '') + " </td><td style='text-align: right'>" + gm.tourNumber + "тур</td></tr>"));
        }
        return _results;
      })()).join('')) + "\n</table>";
    };
    templates.separationRow = function(dt) {
      return "<tr><td></td><td></td></tr><tr class='separation-row'><td>" + dt + "</td></tr>";
    };
    templates.modal = function(game, teams, referees) {
      return "<div class=\"modal active\" role=\"dialog\" aria-labelledby=\"myModalLabel\" aria-hidden=\"true\">\n  <div class=\"modal-dialog\">\n    <div class=\"modal-content\">\n      <div class=\"modal-header\">\n        " + (templates.hiddenModel(game)) + "\n        <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">×</button>\n        <h4 class=\"modal-title\">" + (game._id == null ? 'Добавление матча' : 'Редактирование матча') + "</h4>\n      </div>\n      <div class=\"modal-body\">" + (templates.modalBody(game, teams, referees)) + "</div>\n      <div class=\"modal-footer\">\n        <div class=\"row\">\n          <div class=\"col-xs-6  col-md-6 col-lg-6\">\n                " + (game._id != null ? "<button id='" + game._id + "' class='btn btn-danger delBtn' style='float: left'>delete</button>" : '') + "\n          </div>\n          <div class=\"col-xs-6 col-md-6 col-lg-6\">\n                <button class=\"btn btn-success addBtn\" tabindex=4>save</button>\n          </div>\n        </div>\n      </div>\n    </div>\n  </div>\n</div>";
    };
    templates.modalBody = function(game, teams, referees) {
      return "<div class=\"row\">\n      <div class=\"col-xs-6 col-md-6 col-lg-6\" data-select-id=\"homeTeamId\" data-select-value=\"homeTeamName\">\n        " + (templates.teamSelect(teams)) + "\n      </div>\n      <div class=\"col-xs-6 col-md-6 col-lg-6\" data-select-id=\"awayTeamId\" data-select-value=\"awayTeamName\">\n        " + (templates.teamSelect(teams)) + "\n      </div>\n</div><br>\n\n<div class=\"row\">\n      <div class=\"col-xs-5  col-md-5 col-lg-5\">\n            <input type=\"text\" data-value=\"tourNumber\" class=\"form-control\" placeholder='тур'>\n      </div>\n      <div class=\"col-xs-7 col-md-7 col-lg-7\">\n            <input type=\"text\" id=\"date\" data-value=\"date\" class=\"form-control\" placeholder='дата'>\n      </div>\n</div><br>\n<div class=\"row\">\n      <div class=\"col-xs-6  col-md-6 col-lg-6\" data-select-id=\"refereeId\" data-select-value=\"refereeName\">\n        " + (templates.refSelect(referees)) + "\n      </div>\n<!--\n      <div class=\"col-xs-6 col-md-6 col-lg-6\">\n        <select></select>\n      </div>\n-->\n</div>";
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
    templates.refSelect = function(referees) {
      var html, ref;
      html = "<select class='form-control'>";
      html += "<option></option>";
      html += (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = referees.length; _i < _len; _i++) {
          ref = referees[_i];
          _results.push("<option value='" + ref._id + "'>" + ref.name + "</option>");
        }
        return _results;
      })();
      return html += "</select>";
    };
    $('body').on('click', '.addBtn', function() {
      var model;
      console.log(model = extractData($('.modal')));
      $('.modal').hide();
      return request({
        method: 'POST',
        url: '/games/add',
        params: model,
        success: function(data) {
          return location.reload();
        }
      });
    });
    $('body').on('click', '.delBtn', function() {
      var id;
      console.log(id = $(this).attr('id'));
      $('.modal').hide();
      return request({
        method: 'POST',
        url: '/games/del',
        params: {
          _id: id
        },
        success: function(data) {
          return location.reload();
        }
      });
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
        teams = teams[0];
        referees = referees[0];
        $('#container').on('click', '#addBtn', function() {
          var $modal, game;
          game = {
            leagueId: user.leagueId
          };
          $modal = $(templates.modal(game, teams, referees));
          $modal.find('#date').datetimepicker({
            format: 'DD/MM/YY'
          });
          $modal.modal({
            show: true
          });
          return $('.modal select:eq(0)').focus();
        });
        $('body').on('click', 'table .game-notstarted', function() {
          var $modal, game;
          game = extractData($(this));
          $modal = $(templates.modal(game, teams, referees));
          fillData($modal, game);
          $modal.modal({
            show: true
          });
          return $("#date").datetimepicker({
            format: 'DD/MM/YY'
          });
        });
        return $('#container').html(templates.games(games[0]));
      }, function(error) {
        return sessionExpired();
      });
    }
  });

}).call(this);
