(function() {
  $(function() {
    var gameId, user;
    templates.game = function(game) {
      var formatPlname, html, pl, _i, _j, _len, _len1, _ref, _ref1;
      formatPlname = function(pl) {
        pl.name = pl.name.split(' ')[0].toLowerCase();
        return pl.name = pl.name.charAt(0).toUpperCase() + pl.name.slice(1);
      };
      _ref = game.homeTeamPlayers;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        pl = _ref[_i];
        formatPlname(pl);
      }
      _ref1 = game.awayTeamPlayers;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        pl = _ref1[_j];
        formatPlname(pl);
      }
      html = "<h3>" + game.homeTeamName + " - " + game.awayTeamName + " " + game.homeTeamScore + ":" + game.awayTeamScore + "</h3>";
      html += "<b>" + game.homeTeamName + ": </b>";
      html += "<br><b>Голы: </b>";
      html += ((function() {
        var _k, _len2, _ref2, _results;
        _ref2 = game.homeTeamPlayers;
        _results = [];
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          pl = _ref2[_k];
          if (pl.goals > 0) {
            _results.push("#" + pl.number + " " + pl.name + " " + (pl.goals > 1 ? "(x" + pl.goals + ")" : '') + " ");
          }
        }
        return _results;
      })()).join(', ');
      html += "<br><b>Передачи: </b>";
      html += ((function() {
        var _k, _len2, _ref2, _results;
        _ref2 = game.homeTeamPlayers;
        _results = [];
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          pl = _ref2[_k];
          if (pl.assists > 0) {
            _results.push("#" + pl.number + " " + pl.name + " " + (pl.assists > 1 ? "(x" + pl.assists + ")" : '') + " ");
          }
        }
        return _results;
      })()).join(', ');
      html += "<br><b>Карточки: </b>";
      html += ((function() {
        var _k, _len2, _ref2, _results;
        _ref2 = game.homeTeamPlayers;
        _results = [];
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          pl = _ref2[_k];
          if (pl.yellow > 0 || pl.red > 0) {
            _results.push("#" + pl.number + " " + pl.name + " (" + (pl.yellow === '1' ? 'жк' : pl.yellow === '2' ? '2жк' : '') + " " + (pl.red ? 'кк' : '') + ")  ");
          }
        }
        return _results;
      })()).join(', ');
      html += "<br><b>Игравшие: </b>";
      html += ((function() {
        var _k, _len2, _ref2, _results;
        _ref2 = game.homeTeamPlayers;
        _results = [];
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          pl = _ref2[_k];
          _results.push("#" + pl.number + " " + pl.name);
        }
        return _results;
      })()).join(', ');
      html += "<br><br><b>" + game.awayTeamName + ": </b>";
      html += "<br><b>Голы: </b>";
      html += ((function() {
        var _k, _len2, _ref2, _results;
        _ref2 = game.awayTeamPlayers;
        _results = [];
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          pl = _ref2[_k];
          if (pl.goals > 0) {
            _results.push("#" + pl.number + " " + pl.name + " " + (pl.goals > 1 ? "(x" + pl.goals + ")" : '') + " ");
          }
        }
        return _results;
      })()).join(', ');
      html += "<br><b>Передачи: </b>";
      html += ((function() {
        var _k, _len2, _ref2, _results;
        _ref2 = game.awayTeamPlayers;
        _results = [];
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          pl = _ref2[_k];
          if (pl.assists > 0) {
            _results.push("#" + pl.number + " " + pl.name + " " + (pl.assists > 1 ? "(x" + pl.assists + ")" : '') + " ");
          }
        }
        return _results;
      })()).join(', ');
      html += "<br><b>Карточки: </b>";
      html += ((function() {
        var _k, _len2, _ref2, _results;
        _ref2 = game.awayTeamPlayers;
        _results = [];
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          pl = _ref2[_k];
          if (pl.yellow > 0 || pl.red > 0) {
            _results.push("#" + pl.number + " " + pl.name + " (" + (pl.yellow === '1' ? 'жк' : pl.yellow === '2' ? '2жк' : '') + " " + (pl.red ? 'кк' : '') + ")  ");
          }
        }
        return _results;
      })()).join(', ');
      html += "<br><b>Игравшие: </b>";
      return html += ((function() {
        var _k, _len2, _ref2, _results;
        _ref2 = game.awayTeamPlayers;
        _results = [];
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          pl = _ref2[_k];
          _results.push("#" + pl.number + " " + pl.name);
        }
        return _results;
      })()).join(', ');
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
      gameId = location.search.substr(1);
      return $.getJSON("/games/" + gameId, function(game) {
        console.log(game);
        return $('#container').html(templates.game(game));
      });
    }
  });

}).call(this);
