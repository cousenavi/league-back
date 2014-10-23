(function() {
  $(function() {
    var user;
    templates.users = function(players) {
      var pl;
      return "<button class=\"btn btn-block btn-success\" id=\"addBtn\" autofocus><span class=\"glyphicon glyphicon-plus\"></span></button>\n<table class=\"table table-hover\">\n" + (((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = players.length; _i < _len; _i++) {
          pl = players[_i];
          _results.push("<tr>" + (templates.hiddenModel(pl)) + "<td>" + pl.name + "</td><td>" + pl.number + "</td><td>" + pl.position + "</td></tr>");
        }
        return _results;
      })()).join('')) + "\n</table>";
    };
    templates.popupHeader = function(player) {
      return (player != null ? 'Редактирование' : 'Добавление') + ' игрока';
    };
    templates.popupContent = function(player) {
      var pos;
      player = player || {
        teamId: localStorageRead('user').teamId
      };
      return "" + (player._id != null ? "<input type='hidden' data-value='_id' value='" + player._id + "'>" : "") + "\n<input type='hidden' data-value='teamId' value='" + player.teamId + "'>\n<div class=\"row\">\n   <div class=\"col-xs-12 col-md-12 col-lg-12\">\n      <input type=\"text\" class=\"form-control\" data-value='name' value=\"" + (player.name != null ? player.name : '') + "\" tabindex=1 style=\"text-transform:uppercase;\"  tabindex=1 placeholder='NAME'>\n   </div>\n</div><br>\n<div class=\"row\">\n   <div class=\"col-xs-6 col-md-6 col-lg-6\" >\n      <select class=\"form-control\" id=\"positions\" data-value=\"position\" tabindex=\"2\">\n           " + ((function() {
        var _i, _len, _ref, _results;
        _ref = ['GK', 'CB', 'RB', 'LB', 'CM', 'LM', 'RM', 'ST'];
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          pos = _ref[_i];
          _results.push("<option " + (pos === player.position ? 'selected' : '') + ">" + pos + "</option> ");
        }
        return _results;
      })()) + "\n      </select>\n   </div>\n   <div class=\"col-xs-6 col-md-6 col-lg-6\" >\n      <input type=\"number\" min=\"0\" max=\"1000\" class=\"form-control\" data-value='number'  style='text-align: center' tabindex='3' value=\"" + (player.number != null ? player.number : '') + "\" placeholder='№'>\n   </div>\n</div>";
    };
    templates.popupFooter = function(player) {
      return "<div class=\"row\">\n  <div class=\"col-xs-6  col-md-6 col-lg-6\">\n        " + (player != null ? "<button id='" + player._id + "' class='btn btn-danger delBtn' style='float: left'>delete</button>" : '') + "\n  </div>\n  <div class=\"col-xs-6 col-md-6 col-lg-6\">\n        <button class=\"btn btn-success addBtn\" tabindex=4>save</button>\n  </div>\n</div>";
    };
    user = localStorageRead('user');
    if (user == null) {
      location.href = '/admin';
    }
    if (user.role === 'root') {
      'show league selector';
    }
    if (user.role === 'Head') {
      'show team selector';
    }
    if (user.role === 'Captain') {
      request({
        url: "/players?teamId=" + user.teamId,
        success: function(players) {
          return $('#container').html(templates.users(players));
        },
        error: function(err) {
          return sessionExpired();
        }
      });
    }
    $('#container').on('click', '#addBtn', function() {
      var body, footer, head;
      head = templates.popupHeader();
      body = templates.popupContent();
      footer = templates.popupFooter();
      $(templates.popup(head, body, footer)).modal({
        show: true
      });
      return $('.modal [data-value=name]').focus();
    });
    $('body').on('click', '.addBtn', function() {
      var model;
      console.log(model = extractData($('.modal')));
      $('.modal').hide();
      return request({
        method: 'POST',
        url: '/players/add',
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
        url: '/players/del',
        params: {
          _id: id
        },
        success: function(data) {
          return location.reload();
        }
      });
    });
    return $('body').on('click', 'table tr', function() {
      var body, footer, head, player;
      player = extractData($(this));
      head = templates.popupHeader(player);
      body = templates.popupContent(player);
      footer = templates.popupFooter(player);
      return $(templates.popup(head, body, footer)).modal({
        show: true
      });
    });
  });

}).call(this);
