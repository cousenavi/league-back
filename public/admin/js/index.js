(function() {
  $(function() {
    var user;
    templates.sections = function(user) {
      var html;
      html = '';
      if (user.role === 'Head' || user.role === 'root') {
        html += "<a class='btn btn-block btn-info match' href=\"teams\" disabled>Teams</a><br>";
      }
      if (user.role === 'Head' || user.role === 'root') {
        html += "<a class='btn btn-block btn-info match' href=\"players\" disabled>Players</a><br>";
      }
      if (user.role === 'Head' || user.role === 'root') {
        html += "<a class='btn btn-block btn-info match' href=\"games\">Games</a><br>";
      }
      if (user.role === 'Head' || user.role === 'root') {
        html += "<a class='btn btn-block btn-info match' href=\"referees\">Referrees</a><br>";
      }
      if (user.role === 'Head' || user.role === 'root') {
        html += "<a class='btn btn-block btn-info match' href=\"places\" disabled>Places</a><br>";
      }
      if (user.role === 'root') {
        html += "<a class='btn btn-block btn-info match' href=\"users\">Users</a><br>";
      }
      return html;
    };
    templates.login = function() {
      var login;
      return "<div id=\"loginForm\">\n<input type=\"text\" data-value=\"login\" class=\"form-control\"\nplaceholder='login' autocomplete='true'\n" + ((login = getCookie('login')) ? "value=\"" + login + "\"" : '') + "><br>\n<input type=\"password\" data-value=\"password\" class=\"form-control\" placeholder='password' autocomplete='true'><br>\n<button id=\"loginBtn\" class=\"btn btn-success btn-block\">Go!</button>\n </div>";
    };
    $('body').on('login', function(event, user) {
      if (user.role === 'Captain') {
        return location.href = 'players';
      } else {
        return $('#container').html(templates.sections(user));
      }
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
