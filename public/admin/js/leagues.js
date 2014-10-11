(function() {
  $(function() {
    var user;
    templates.leagues = function(leagues) {
      var lg;
      return "<button class=\"btn btn-block btn-success\" id=\"addBtn\" autofocus><span class=\"glyphicon glyphicon-plus\"></span></button>\n<table class=\"table table-hover\">\n" + (((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = leagues.length; _i < _len; _i++) {
          lg = leagues[_i];
          _results.push("<tr>" + (templates.hiddenModel(lg)) + "<td>" + lg.name + "</td><td>" + lg.logo + "</td></tr>");
        }
        return _results;
      })()).join('')) + "\n</table>";
    };
    templates.modalBody = function() {
      return "<input type='text' class=\"form-control\" data-value='name' placeholder=\"name\" tabindex=1><br>\n<input type='text' class=\"form-control\" data-value='logo' placeholder=\"logo\" tabindex=2>";
    };
    templates.modal = function(league) {
      return "<div class=\"modal active\" role=\"dialog\" aria-labelledby=\"myModalLabel\" aria-hidden=\"true\">\n  <div class=\"modal-dialog\">\n    <div class=\"modal-content\">\n      <div class=\"modal-header\">\n        " + (templates.hiddenModel(league)) + "\n        <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">X</button>\n        <h4 class=\"modal-title\">" + (league._id == null ? 'Добавление лиги' : 'Редактирование лиги') + "</h4>\n      </div>\n      <div class=\"modal-body\">" + (templates.modalBody()) + "</div>\n      <div class=\"modal-footer\">\n        <div class=\"row\">\n          <div class=\"col-xs-6  col-md-6 col-lg-6\">\n                " + (league._id != null ? "<button id='" + league._id + "' class='btn btn-danger delBtn' style='float: left'>delete</button>" : '') + "\n          </div>\n          <div class=\"col-xs-6 col-md-6 col-lg-6\">\n                <button class=\"btn btn-success addBtn\" tabindex=4>save</button>\n          </div>\n        </div>\n      </div>\n    </div>\n  </div>\n</div>";
    };
    user = localStorageRead('user');
    if ((user == null) || user.role !== 'root') {
      location.href = '/admin';
    }
    request({
      url: "/leagues",
      success: function(leagues) {
        return $('#container').html(templates.leagues(leagues));
      },
      error: function(err) {
        return sessionExpired();
      }
    });
    $('#container').on('click', '#addBtn', function() {
      var $modal;
      $modal = $(templates.modal({}));
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
        url: '/leagues/add',
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
      if (confirm('Удалить лигу?')) {
        console.log(id = $(this).attr('id'));
        return request({
          method: 'POST',
          url: '/leagues/del',
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
    return $('body').on('click', 'table tr', function() {
      var $modal, league;
      league = extractData($(this));
      $modal = $(templates.modal(league));
      fillData($modal, league);
      $modal.modal({
        show: true
      });
      return $modal.find('[data-value=name]').focus();
    });
  });

}).call(this);
