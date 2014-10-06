(function() {
  $(function() {
    var user;
    templates.teams = function(teams) {
      var tm;
      return "<button class=\"btn btn-block btn-success\" id=\"addBtn\" autofocus><span class=\"glyphicon glyphicon-plus\"></span></button>\n<table class=\"table table-hover\">\n" + (((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = teams.length; _i < _len; _i++) {
          tm = teams[_i];
          _results.push("<tr>" + (templates.hiddenModel(tm)) + "<td><img src='/" + tm.logo + "' style='height: 25px;'> " + tm.name + "</td></tr>");
        }
        return _results;
      })()).join('')) + "\n</table>";
    };
    templates.modal = function(team) {
      return "<div class=\"modal active\" role=\"dialog\" aria-labelledby=\"myModalLabel\" aria-hidden=\"true\">\n  <div class=\"modal-dialog\">\n    <div class=\"modal-content\">\n      <div class=\"modal-header\">\n        " + (templates.hiddenModel(team)) + "\n        <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">×</button>\n        <h4 class=\"modal-title\">" + (team._id == null ? 'Добавление команды' : 'Редактирование команды') + "</h4>\n      </div>\n      <div class=\"modal-body\">" + (templates.modalBody(team)) + "</div>\n      <div class=\"modal-footer\">\n        <div class=\"row\">\n          <div class=\"col-xs-6  col-md-6 col-lg-6\">\n                " + (team._id != null ? "<button id='" + team._id + "' class='btn btn-danger delBtn' style='float: left'>delete</button>" : '') + "\n          </div>\n          <div class=\"col-xs-6 col-md-6 col-lg-6\">\n                <button class=\"btn btn-success addBtn\" tabindex=4>save</button>\n          </div>\n        </div>\n      </div>\n    </div>\n  </div>\n</div>";
    };
    templates.modalBody = function(team) {
      return "<input type='text' class=\"form-control\" data-value='name' placeholder=\"name\" tabindex=1><br>\n<input type='text' class=\"form-control\" data-value='logo' placeholder=\"logo\" tabindex=2><br>";
    };
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
      request({
        url: "/teams?leagueId=" + user.leagueId,
        success: function(teams) {
          return $('#container').html(templates.teams(teams));
        },
        error: function(err) {
          return sessionExpired();
        }
      });
    }
    $('#container').on('click', '#addBtn', function() {
      var $modal, team;
      team = {
        leagueId: user.leagueId
      };
      $modal = $(templates.modal(team));
      fillData($modal, team);
      $modal.modal({
        show: true
      });
      return $modal.find('[data-value=name]').focus();
    });
    $('body').on('click', '.addBtn', function() {
      var model;
      console.log(model = extractData($('.modal')));
      $('.modal').hide();
      return request({
        method: 'POST',
        url: '/teams/add',
        params: model,
        success: function(data) {
          return location.reload();
        },
        error: function() {
          return sessionExpired();
        }
      });
    });
    $('body').on('click', '.delBtn', function() {
      var id;
      console.log(id = $(this).attr('id'));
      return request({
        method: 'POST',
        url: '/teams/del',
        params: {
          _id: id
        },
        success: function(data) {
          return location.reload();
        },
        error: function() {
          return sessionExpired();
        }
      });
    });
    return $('body').on('click', 'table tr', function() {
      var $modal, team;
      team = extractData($(this));
      $modal = $(templates.modal(team));
      fillData($modal, team);
      $modal.modal({
        show: true
      });
      return $modal.find('[data-value=name]').focus();
    });
  });

}).call(this);
