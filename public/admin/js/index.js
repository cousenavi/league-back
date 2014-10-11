(function() {
  $(function() {
    var user;
    templates.sections = function(user) {
      var html;
      if (user.role === 'root') {
        html = "<a class='btn btn-block btn-info btn-list' href=\"leagues\" tabindex='1'>Leagues</a>\n<a class='btn btn-block btn-info btn-list' href=\"heads\" tabindex='2'>Heads</a>";
      }
      if (user.role === 'Head') {
        html = "<a class='btn btn-block btn-info btn-list' href=\"games\" tabindex='1'>Games</a>\n<a class='btn btn-block btn-info btn-list' href=\"teams\" tabindex='2'>Teams</a>\n<a class='btn btn-block btn-info btn-list' href=\"referees\" tabindex='3'>Referees</a>";
      }
      if (user.role === 'Capitan') {
        html = "";
      }
      html += '<a class="btn btn-block btn-success btn-list" id="logoutBtn" tabindex="3">Logout</a>';
      return html;
    };
    templates.login = function() {
      var login;
      return "<div id=\"loginForm\">\n<input type=\"text\" data-value=\"login\" class=\"form-control\"\nplaceholder='login' autocomplete='true' autofocus\n" + ((login = getCookie('login')) ? "value=\"" + login + "\"" : '') + "><br>\n<input type=\"password\" data-value=\"password\" class=\"form-control\" placeholder='password' autocomplete='true'><br>\n<button id=\"loginBtn\" class=\"btn btn-success btn-block\">Go!</button>\n </div>";
    };
    $('body').on('login', function(event, user) {
      if (user.role === 'Captain') {
        return location.href = 'players';
      } else {
        return $('#container').html(templates.sections(user));
      }
    });
    $('#container').on('click', '#logoutBtn', function() {
      return sessionExpired();
    });
    $('#container').on('click', '#loginBtn', function() {
      var model;
      $(this).html('...');
      model = extractData($(this).parent());
      return request({
        url: '/adminapi/login',
        method: 'POST',
        params: model,
        success: function(user) {
          localStorage.setItem('user', JSON.stringify(user));
          return $('body').trigger('login', [user]);
        },
        error: function(error) {
          $('#loginBtn').html('Go!');
          $('#container .alert-danger').remove();
          return $('#container').prepend(window.templates.error(error.responseText));
        }
      });
    });
    $('#container').on('keyup', '[data-value=login]', function() {
      return setCookie('login', $(this).val());
    });
    if (user = localStorageRead('user')) {
      return request({
        url: '/adminapi/info',
        success: function() {
          return $('body').trigger('login', [user]);
        },
        error: function() {
          return $('#container').html(templates.login());
        }
      });
    } else {
      return $('#container').html(templates.login());
    }
  });

}).call(this);
