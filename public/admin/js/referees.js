(function() {
  $(function() {
    var user;
    templates.users = function(referees) {
      var ref;
      return "<button class=\"btn btn-block btn-success\" id=\"addBtn\" autofocus><span class=\"glyphicon glyphicon-plus\"></span></button>\n<table class=\"table table-hover\">\n" + (((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = referees.length; _i < _len; _i++) {
          ref = referees[_i];
          _results.push("<tr>" + (templates.hiddenModel(ref)) + "<td>" + ref.name + "</td></tr>");
        }
        return _results;
      })()).join('')) + "\n</table>";
    };
    templates.modal = function(referee) {
      return "<div class=\"modal active\" role=\"dialog\" aria-labelledby=\"myModalLabel\" aria-hidden=\"true\">\n  <div class=\"modal-dialog\">\n    <div class=\"modal-content\">\n      <div class=\"modal-header\">\n        " + (templates.hiddenModel(referee)) + "\n        <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">×</button>\n        <h4 class=\"modal-title\">" + (referee._id == null ? 'Добавление судьи' : 'Редактирование судьи') + "</h4>\n      </div>\n      <div class=\"modal-body\">" + (templates.modalBody(referee)) + "</div>\n      <div class=\"modal-footer\">\n        <div class=\"row\">\n          <div class=\"col-xs-6  col-md-6 col-lg-6\">\n                " + (referee._id != null ? "<button id='" + referee._id + "' class='btn btn-danger delBtn' style='float: left'>delete</button>" : '') + "\n          </div>\n          <div class=\"col-xs-6 col-md-6 col-lg-6\">\n                <button class=\"btn btn-success addBtn\" tabindex=4>save</button>\n          </div>\n        </div>\n      </div>\n    </div>\n  </div>\n</div>";
    };
    templates.modalBody = function(game, teams) {
      return "<input type='text' class=\"form-control\" data-value='name' style=\"text-transform:uppercase;\" placeholder=\"name\" tabindex=1><br>\n<input type='text' class=\"form-control\" data-value='login' placeholder=\"login\" tabindex=2><br>\n<input type='text' class=\"form-control\" data-value='password' placeholder=\"password\" tabindex=3>";
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
        url: "/referees",
        success: function(refs) {
          return $('#container').html(templates.users(refs));
        },
        error: function(err) {
          return sessionExpired();
        }
      });
    }
    $('#container').on('click', '#addBtn', function() {
      var $modal, ref;
      ref = {
        leagueId: user.leagueId
      };
      $modal = $(templates.modal(ref));
      fillData($modal, ref);
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
        url: '/referees/add',
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
        url: '/referees/del',
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
      var $modal, ref;
      ref = extractData($(this));
      $modal = $(templates.modal(ref));
      fillData($modal, ref);
      $modal.modal({
        show: true
      });
      return $modal.find('[data-value=name]').focus();
    });
  });

}).call(this);
