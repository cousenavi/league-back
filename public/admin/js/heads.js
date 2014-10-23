(function() {
  $(function() {
    return $.getJSON('/leagues', function(lg) {
      var user;
      window.leagues = lg;
      templates.users = function(users) {
        var us;
        return "<button class=\"btn btn-block btn-success\" id=\"addBtn\"><span class=\"glyphicon glyphicon-plus\"></span></button>\n<table class=\"table table-hover\">\n" + (((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = users.length; _i < _len; _i++) {
            us = users[_i];
            _results.push("<tr>" + (templates.hiddenModel(us)) + "<td>" + us.login + "</td><td>" + us.role + "</td></tr>");
          }
          return _results;
        })()).join('')) + "\n</table>";
      };
      templates.modalBody = function(user) {
        return "<input type='text' class=\"form-control\" data-value='login' placeholder=\"login\" tabindex=1><br>\n<input type='text' class=\"form-control\" data-value='password' placeholder=\"password\" tabindex=2><br>\n<select data-value=\"leagueId\" id=\"league\" class=\"form-control\" tabindex=2>\n    <option></option>\n  " + ((function() {
          var _i, _len, _ref, _results;
          _ref = window.leagues;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            lg = _ref[_i];
            _results.push("<option value='" + lg._id + "' " + ((user != null) && user.leagueId === lg._id ? "selected" : "") + ">" + lg.name + "</option>");
          }
          return _results;
        })()) + "\n</select>";
      };
      templates.modal = function(user) {
        return "<div class=\"modal active\" role=\"dialog\" aria-labelledby=\"myModalLabel\" aria-hidden=\"true\">\n  <div class=\"modal-dialog\">\n    <div class=\"modal-content\">\n      <div class=\"modal-header\">\n        " + (templates.hiddenModel(user)) + "\n        <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">X</button>\n        <h4 class=\"modal-title\">" + (user._id == null ? 'Добавление главы лиги' : 'Редактирование главы лиги') + "</h4>\n      </div>\n      <div class=\"modal-body\">" + (templates.modalBody()) + "</div>\n      <div class=\"modal-footer\">\n        <div class=\"row\">\n          <div class=\"col-xs-4  col-md-4 col-lg-4\">\n                " + (user._id != null ? "<button id='" + user._id + "' class='btn btn-danger delBtn' style='width: 100%'>delete</button>" : '') + "\n          </div>\n          <div class=\"col-xs-4  col-md-4 col-lg-4\">\n                " + (user._id != null ? "<button id='" + user._id + "' class='btn btn-info loginAsBtn' style='width: 100%'>login as</button>" : '') + "\n          </div>\n          <div class=\"col-xs-4 col-md-4 col-lg-4\">\n                <button class=\"btn btn-success addBtn\" tabindex=4 style='width: 100%'>save</button>\n          </div>\n        </div>\n      </div>\n    </div>\n  </div>\n</div>";
      };
      user = localStorageRead('user');
      if ((user == null) || user.role !== 'root') {
        location.href = '/admin';
      }
      request({
        url: "/adminapi/heads",
        success: function(users) {
          return $('#container').html(templates.users(users));
        },
        error: function(err) {
          return sessionExpired();
        }
      });
      $('#container').on('click', '#addBtn', function() {
        var $modal;
        $modal = $(templates.modal({
          role: 'Head'
        }));
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
          url: '/adminapi/add_user',
          params: model,
          success: function() {
            return location.reload();
          },
          error: function() {
            return sessionExpired();
          }
        });
      });
      $('body').on('click', '.delBtn', function() {
        var id;
        if (confirm('Удалить главу лиги?')) {
          console.log(id = $(this).attr('id'));
          return request({
            method: 'POST',
            url: '/adminapi/del_user',
            params: {
              _id: id
            },
            success: function() {
              return location.reload();
            },
            error: function() {
              return sessionExpired();
            }
          });
        }
      });
      $('body').on('click', '.loginAsBtn', function() {
        var id;
        console.log(id = $(this).attr('id'));
        return request({
          method: 'POST',
          url: '/adminapi/sublogin',
          params: {
            _id: id
          },
          success: function(user) {
            localStorageWrite('user', user);
            return location.href = '/admin';
          }
        });
      });
      return $('body').on('click', 'table tr', function() {
        var $modal;
        user = extractData($(this));
        $modal = $(templates.modal(user));
        fillData($modal, user);
        $modal.modal({
          show: true
        });
        return $modal.find('[data-value=name]').focus();
      });
    });
  });

}).call(this);
