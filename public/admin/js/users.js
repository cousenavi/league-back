(function() {
  $(function() {
    return $.getJSON('/leagues', function(lg) {
      var loadTeams;
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
      templates.popupHeader = function(user) {
        return (user != null ? 'Редактирование' : 'Добавление') + ' юзера';
      };
      templates.popupContent = function(user) {
        return "" + (user != null ? "<input type='hidden' data-value='_id' value='" + user._id + "'>" : "") + "\n<input type=\"text\" class=\"form-control\" data-value='login' placeholder='login' " + (user != null ? "value='" + user.login + "'" : "") + "><br>\n<input type=\"text\" class=\"form-control\" data-value='password' placeholder='password' " + (user != null ? "value='" + user.password + "'" : "") + "><br>\n<select data-value=\"role\" id=\"role\" class=\"form-control\">\n  <option " + ((user != null) && user.role === 'root' ? "selected" : "") + ">root</option>\n  <option " + ((user != null) && user.role === 'Head' ? "selected" : "") + ">Head</option>\n  <option " + ((user != null) && user.role === 'Captain' ? "selected" : "") + ">Captain</option>\n</select><br>\n\n<select data-value=\"leagueId\" id=\"league\" class=\"form-control\">\n    <option></option>\n  " + ((function() {
          var _i, _len, _ref, _results;
          _ref = window.leagues;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            lg = _ref[_i];
            _results.push("<option value='" + lg._id + "' " + ((user != null) && user.leagueId === lg._id ? "selected" : "") + ">" + lg.name + "</option>");
          }
          return _results;
        })()) + "\n</select><br>\n<span id=\"team\"></span>";
      };
      templates.teamSelect = function(teams, user) {
        var html, team;
        html = "<select class='form-control' data-value='teamId'>";
        html += ((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = teams.length; _i < _len; _i++) {
            team = teams[_i];
            _results.push("<option value='" + team._id + "' " + ((user != null) && user.teamId === team._id ? "selected" : "") + ">" + team.name + "</option>");
          }
          return _results;
        })()).join('');
        return html += "</select>";
      };
      templates.popupFooter = function(user) {
        return "<div class=\"row\">\n  <div class=\"col-xs-6  col-md-6 col-lg-6\">\n        " + (user != null ? "<button id='" + user._id + "' class='btn btn-danger delBtn' style='float: left'>delete</button>" : '') + "\n  </div>\n  <div class=\"col-xs-6 col-md-6 col-lg-6\">\n        <button class=\"btn btn-success addBtn\" tabindex=4>save</button>\n  </div>\n</div>";
      };
      loadTeams = function(leagueId) {
        if (this.cache == null) {
          this.cache = {};
        }
        return new Promise((function(_this) {
          return function(resolve, reject) {
            if (_this.cache[leagueId]) {
              return resolve(_this.cache[leagueId]);
            } else {
              return $.getJSON("/teams?leagueId=" + leagueId, function(teams) {
                _this.cache[leagueId] = teams;
                return resolve(_this.cache[leagueId]);
              });
            }
          };
        })(this));
      };
      request({
        url: '/adminapi/users',
        success: function(users) {
          return $('#container').html(templates.users(users));
        },
        error: function(err) {
          return location.href = '/admin';
        }
      });
      $('#container').on('click', '#addBtn', function() {
        var body, footer, head;
        head = templates.popupHeader();
        body = templates.popupContent();
        footer = templates.popupFooter();
        return $(templates.popup(head, body, footer)).modal({
          show: true
        });
      });
      $('body').on('change', '#role', function() {
        if (this.value === 'Head') {
          return $('#team select').remove();
        }
      });
      $('body').on('change', '#league', function() {
        var teams;
        if ($('#role').val() === 'Captain') {
          $('#team').html(templates.teamSelect([
            {
              name: 'test',
              _id: '1'
            }
          ]));
          return teams = loadTeams(this.value).then(function(teams) {
            return $('#team').html(templates.teamSelect(teams));
          });
        }
      });
      $('body').on('click', '.addBtn', function() {
        var model;
        model = extractData($('.modal'));
        return request({
          method: 'POST',
          url: '/adminapi/add_user',
          params: model,
          success: function(data) {
            return location.reload();
          }
        });
      });
      $('body').on('click', '.delBtn', function() {
        var id;
        id = $(this).attr('id');
        return request({
          method: 'POST',
          url: '/adminapi/del_user',
          params: {
            _id: id
          },
          success: function(data) {
            return location.reload();
          }
        });
      });
      return $('body').on('click', 'table tr', function() {
        var body, footer, head, user;
        user = extractData($(this));
        head = templates.popupHeader(user);
        body = templates.popupContent(user);
        footer = templates.popupFooter(user);
        $(templates.popup(head, body, footer)).modal({
          show: true
        });
        return $('#league').change();
      });
    });
  });

}).call(this);
