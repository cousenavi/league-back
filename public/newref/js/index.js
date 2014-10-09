var GameAdapter;

GameAdapter = (function() {
  function GameAdapter() {}

  GameAdapter.prototype.toLocal = function(serverModel) {
    var localModel;
    localModel = serverModel;
    localModel.teams = [
      {
        _id: serverModel.homeTeamId,
        logo: serverModel.homeTeamLogo,
        name: serverModel.homeTeamName,
        score: serverModel.homeTeamScore || 0,
        players: serverModel.homeTeamPlayers || [],
        refereeMark: serverModel.homeTeamRefereeMark
      }, {
        _id: serverModel.awayTeamId,
        logo: serverModel.awayTeamLogo,
        name: serverModel.awayTeamName,
        score: serverModel.awayTeamScore || 0,
        players: serverModel.awayTeamPlayers || [],
        refereeMark: serverModel.awayTeamRefereeMark
      }
    ];
    delete localModel.homeTeamId;
    delete localModel.homeTeamName;
    delete localModel.homeTeamLogo;
    delete localModel.homeTeamScore;
    delete localModel.homeTeamPlayers;
    delete localModel.homeTeamRefereeMark;
    delete localModel.awayTeamId;
    delete localModel.awayTeamName;
    delete localModel.awayTeamLogo;
    delete localModel.awayTeamScore;
    delete localModel.awayTeamPlayers;
    delete localModel.awayTeamRefereeMark;
    return serverModel;
  };

  GameAdapter.prototype.toServer = function(localModel) {
    var serverModel;
    serverModel = localModel;
    serverModel.homeTeamId = localModel.teams[0]._id;
    serverModel.homeTeamName = localModel.teams[0].name;
    serverModel.homeTeamLogo = localModel.teams[0].logo;
    serverModel.homeTeamScore = localModel.teams[0].score;
    serverModel.homeTeamPlayers = localModel.teams[0].players;
    serverModel.homeTeamRefereeMark = localModel.teams[0].refereeMark;
    serverModel.awayTeamId = localModel.teams[1]._id;
    serverModel.awayTeamName = localModel.teams[1].name;
    serverModel.awayTeamLogo = localModel.teams[1].logo;
    serverModel.awayTeamScore = localModel.teams[1].score;
    serverModel.awayTeamPlayers = localModel.teams[1].players;
    serverModel.awayTeamRefereeMark = localModel.teams[1].refereeMark;
    return serverModel;
  };

  return GameAdapter;

})();

var Registry,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Registry = (function() {
  Registry.prototype.games = null;

  Registry.prototype.user = {
    authorized: false
  };

  Registry.prototype.request = function(options) {
    var prefix, redirectUrl;
    prefix = '/refereeapi/';
    redirectUrl = '/newref';
    return $.ajax({
      url: prefix + options.url,
      data: options.params,
      method: options.method,
      success: options.success,
      error: (function(_this) {
        return function(err) {
          if (err.status === 403) {
            _this.clean();
            return location.href = redirectUrl;
          } else {
            $('#container .alert-danger').remove();
            return $('#container').prepend(window.templates.error(err.responseText));
          }
        };
      })(this)
    });
  };

  function Registry() {
    this.restoreRosterState = __bind(this.restoreRosterState, this);
    this.saveRosterState = __bind(this.saveRosterState, this);
    this.saveGame = __bind(this.saveGame, this);
    this.loadGame = __bind(this.loadGame, this);
    this.loadGames = __bind(this.loadGames, this);
    this.clean = __bind(this.clean, this);
    this.login = __bind(this.login, this);
    this.setUserStatus = __bind(this.setUserStatus, this);
    this.setGameStats = __bind(this.setGameStats, this);
    this.request = __bind(this.request, this);
    var rosterStatesStack, user;
    this.adapter = new GameAdapter();
    if (!(this.games = localStorageRead('ref_games'))) {
      this.games = null;
    }
    if ((user = localStorageRead('ref_user'))) {
      this.user = user;
    }
    if ((rosterStatesStack = localStorageRead('ref_roster_stack'))) {
      this.rosterStatesStack = rosterStatesStack;
    }
  }

  Registry.prototype.save = function() {
    localStorageWrite('ref_games', this.games);
    localStorageWrite('ref_user', this.user);
    return localStorageWrite('ref_roster_stack', this.rosterStatesStack);
  };

  Registry.prototype.setGameStats = function(game) {
    this.games[game._id] = game;
    return this.save();
  };

  Registry.prototype.setUserStatus = function(isAuthenticated) {
    return this.user.authorized = isAuthenticated;
  };

  Registry.prototype.login = function(model, callback) {
    return this.request({
      method: "POST",
      url: 'login',
      params: model,
      success: (function(_this) {
        return function() {
          _this.setUserStatus(true);
          _this.save();
          return callback();
        };
      })(this)
    });
  };

  Registry.prototype.clean = function() {
    this.user.authorized = false;
    this.games = null;
    return this.save();
  };

  Registry.prototype.safeRewriteGame = function(oldGame, newGame) {
    var newPl, oldPl, teamIndex, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
    _ref = [0, 1];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      teamIndex = _ref[_i];
      _ref1 = oldGame.teams[teamIndex].players;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        oldPl = _ref1[_j];
        _ref2 = newGame.teams[teamIndex].players;
        for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
          newPl = _ref2[_k];
          if (newPl._id === oldPl._id) {
            newPl.number = oldPl.number;
            newPl.name = oldPl.name;
          }
        }
      }
      newGame.teams[teamIndex].score = oldGame.teams[teamIndex].score;
      newGame.teams[teamIndex].refereeMark = oldGame.teams[teamIndex].refereeMark;
    }
    newGame.synced = oldGame.synced;
    return newGame;
  };

  Registry.prototype.loadGames = function(callback) {
    return this.request({
      method: 'GET',
      url: 'games',
      success: (function(_this) {
        return function(games) {
          var gm, _i, _len;
          for (_i = 0, _len = games.length; _i < _len; _i++) {
            gm = games[_i];
            gm = _this.adapter.toLocal(gm);
            if (_this.games == null) {
              _this.games = {};
            }
            if (_this.games[gm._id] == null) {
              _this.games[gm._id] = gm;
            } else {
              _this.games[gm._id] = _this.safeRewriteGame(_this.games[gm._id], gm);
            }
          }
          _this.save();
          return callback(_this.games);
        };
      })(this)
    });
  };

  Registry.prototype.loadGame = function(id, callback) {
    return this.request({
      method: 'GET',
      url: "game?_id=" + id,
      success: (function(_this) {
        return function(game) {
          game = _this.adapter.toLocal(game);
          _this.games[id] = _this.safeRewriteGame(_this.games[id], game);
          _this.save();
          return callback(id);
        };
      })(this)
    });
  };

  Registry.prototype.saveGame = function(game, callback) {
    return this.request({
      method: 'POST',
      url: "save_game",
      params: this.adapter.toServer(game),
      success: (function(_this) {
        return function() {
          delete _this.rosterStatesStack[game._id];
          return callback();
        };
      })(this)
    });
  };

  Registry.prototype.rosterStatesStack = {};

  Registry.prototype.saveRosterState = function(gameId, side) {
    var pl, players, teamIndex;
    if (this.rosterStatesStack[gameId] == null) {
      this.rosterStatesStack[gameId] = {
        home: [],
        away: []
      };
    }
    teamIndex = side === 'home' ? 0 : 1;
    players = (function() {
      var _i, _len, _ref, _results;
      _ref = this.games[gameId].teams[teamIndex].players;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        pl = _ref[_i];
        _results.push($.extend(true, {}, pl));
      }
      return _results;
    }).call(this);
    this.rosterStatesStack[gameId][side].push(players);
    return this.save();
  };

  Registry.prototype.restoreRosterState = function(gameId, side) {
    var players, teamIndex;
    teamIndex = side === 'home' ? 0 : 1;
    players = this.rosterStatesStack[gameId][side].pop();
    if (players != null) {
      this.games[gameId].teams[teamIndex].players = players;
    }
    return this.save();
  };

  return Registry;

})();

var View,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

View = (function() {
  function View(registry) {
    this.registry = registry;
    this.actionEndGame = __bind(this.actionEndGame, this);
    this.actionSaveGame = __bind(this.actionSaveGame, this);
    this.actionUndo = __bind(this.actionUndo, this);
    this.actionIncrementScore = __bind(this.actionIncrementScore, this);
    this.actionSetPlayerStats = __bind(this.actionSetPlayerStats, this);
    this.actionSetGameStats = __bind(this.actionSetGameStats, this);
    this.actionLoadGame = __bind(this.actionLoadGame, this);
    this.actionLoadGames = __bind(this.actionLoadGames, this);
    this.actionLogout = __bind(this.actionLogout, this);
    this.actionLogin = __bind(this.actionLogin, this);
    this.viewTeamChoise = __bind(this.viewTeamChoise, this);
    this.actionLoadRoster = __bind(this.actionLoadRoster, this);
    this.viewRoster = __bind(this.viewRoster, this);
    this.viewLoadedGame = __bind(this.viewLoadedGame, this);
    this.viewGame = __bind(this.viewGame, this);
    this.viewLoadedGamesList = __bind(this.viewLoadedGamesList, this);
    this.viewGamesList = __bind(this.viewGamesList, this);
    this.viewLogin = __bind(this.viewLogin, this);
    this.render = __bind(this.render, this);
    this.$container = $('#container');
  }

  View.prototype.render = function() {
    if (!this.registry.user.authorized) {
      return this.viewLogin();
    } else {
      return this.viewGamesList();
    }
  };

  View.prototype.viewLogin = function() {
    if (this.registry.user.authorized) {
      this.registry.setUserStatus(false);
    }
    return this.$container.html(templates.login());
  };

  View.prototype.viewGamesList = function() {
    if (this.registry.games === null) {
      return this.registry.loadGames((function(_this) {
        return function() {
          return _this.viewLoadedGamesList();
        };
      })(this));
    } else {
      return this.viewLoadedGamesList();
    }
  };

  View.prototype.viewLoadedGamesList = function() {
    return this.$container.html(templates.games(this.registry.games));
  };

  View.prototype.viewGame = function(id) {
    if ((this.registry.games[id].teams[0].players == null) || this.registry.games[id].teams[0].players.length === 0) {
      return this.registry.loadGame(id, (function(_this) {
        return function() {
          return _this.viewLoadedGame(id);
        };
      })(this));
    } else {
      return this.viewLoadedGame(id);
    }
  };

  View.prototype.viewLoadedGame = function(id) {
    return this.$container.html(templates.game(this.registry.games[id]));
  };

  View.prototype.viewRoster = function(gameId, side) {
    var team, teamIndex;
    teamIndex = side === 'home' ? 0 : 1;
    team = this.registry.games[gameId].teams[teamIndex];
    team.players.sort(function(a, b) {
      if (a.played == null) {
        a.played = false;
      }
      if (b.played == null) {
        b.played = false;
      }
      if (a.played > b.played) {
        return -1;
      }
      if (a.played < b.played) {
        return 1;
      }
      if (a.number < b.number) {
        return -1;
      }
      if (a.number > b.number) {
        return 1;
      }
    });
    return this.$container.html(templates.roster(gameId, side, team));
  };

  View.prototype.actionLoadRoster = function(gameId, side) {
    return this.registry.loadGame(gameId, (function(_this) {
      return function() {
        return _this.viewRoster(gameId, side);
      };
    })(this));
  };

  View.prototype.viewTeamChoise = function(gameId, side) {
    var opponentPlayers;
    opponentPlayers = side !== 'home' ? this.registry.games[gameId].homeTeamPlayers : this.registry.games[gameId].awayTeamPlayers;
    return this.$container.html(templates.choise(name, players));
  };

  View.prototype.actionLogin = function(model) {
    return this.registry.login(model, (function(_this) {
      return function() {
        return _this.viewGamesList();
      };
    })(this));
  };

  View.prototype.actionLogout = function(model) {
    this.registry.clean();
    return this.viewLogin();
  };

  View.prototype.actionLoadGames = function() {
    return this.registry.loadGames((function(_this) {
      return function() {
        return _this.viewLoadedGamesList();
      };
    })(this));
  };

  View.prototype.actionLoadGame = function(id) {
    return this.registry.loadGame(id, (function(_this) {
      return function() {
        return _this.viewLoadedGame(id);
      };
    })(this));
  };

  View.prototype.actionSetGameStats = function(game) {
    this.registry.setGameStats(game);
    return this.viewLoadedGame(game._id);
  };

  View.prototype.actionSetPlayerStats = function(gameId, side, playerId, field, value) {
    var pl, teamIndex, _i, _len, _ref;
    teamIndex = side === 'home' ? 0 : 1;
    this.registry.saveRosterState(gameId, side);
    _ref = this.registry.games[gameId].teams[teamIndex].players;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      pl = _ref[_i];
      if (pl._id === playerId) {
        if (typeof value === 'object') {
          if (value.$inc != null) {
            if (pl[field] == null) {
              pl[field] = value.$inc;
            } else {
              pl[field] = pl[field] + value.$inc;
            }
          }
        } else {
          pl[field] = value;
        }
      }
    }
    this.registry.save();
    return this.$container.html(templates.roster(gameId, side, this.registry.games[gameId].teams[teamIndex]));
  };

  View.prototype.actionIncrementScore = function(gameId, side) {
    var teamIndex;
    teamIndex = side === 'home' ? 0 : 1;
    this.registry.games[gameId].teams[teamIndex].score++;
    return this.registry.save();
  };

  View.prototype.actionUndo = function(gameId, side) {
    var teamIndex;
    teamIndex = side === 'home' ? 0 : 1;
    this.registry.restoreRosterState(gameId, side);
    return this.$container.html(templates.roster(gameId, side, this.registry.games[gameId].teams[teamIndex]));
  };

  View.prototype.actionSaveGame = function(game) {
    return this.registry.saveGame(game, (function(_this) {
      return function() {
        return _this.viewGamesList();
      };
    })(this));
  };

  View.prototype.actionEndGame = function(id) {
    var game;
    game = this.registry.games[id];
    return this.registry.saveGame(game, (function(_this) {
      return function() {
        return _this.actionLoadGames();
      };
    })(this));
  };

  return View;

})();

$(function() {
  var registry;
  registry = new Registry();
  window.view = new View(registry);
  return window.view.render();
});

var pressButton, setMode, setPlayerStats;

window.templates.menu = function(text, backId, refreshId, subCaption) {
  var html;
  html = '<nav class="navbar navbar-default" role="navigation">';
  if (backId != null) {
    html += "<a id='" + backId + "' class='glyphicon glyphicon-arrow-left navbar-button navbar-left' ></a>";
  }
  html += "<span>" + text + "</span>";
  if (refreshId != null) {
    html += "<a id='" + refreshId + "' class='glyphicon glyphicon-refresh navbar-button navbar-right' ></a>";
  }
  return html += '</nav>';
};

window.templates.ajaxLoader = '<div class="ajaxLoad"><img src="/img/sprite/ajax-loader.gif"></div>';

window.templates.login = function() {
  var login;
  return "  <div id=\"loginForm\">\n  <input type=\"text\" data-value=\"login\" class=\"form-control\" placeholder='login'  " + ((login = getCookie('login')) ? "value=\"" + login + "\"" : '') + "><br>\n  <input type=\"password\" data-value=\"password\" class=\"form-control\" placeholder='password'><br>\n  <button id=\"loginBtn\" class=\"btn btn-success btn-block\">Go!</button>\n</div>";
};

$('#container').on('click', '#loginBtn', function() {
  var model;
  model = extractData($(this).parent());
  setCookie('login', model.login);
  return view.actionLogin(model);
});

window.templates.games = function(games) {
  var html, key, m;
  html = templates.menu('Выберите матч', 'logout', 'refreshGames');
  html += templates.ajaxLoader;
  return html += ((function() {
    var _results;
    _results = [];
    for (key in games) {
      m = games[key];
      _results.push("<button class='btn btn-block btn-info match' id='" + m._id + "'class='match'>" + m.teams[0].name + " <br> " + m.teams[1].name + "<br><span class='smallText'>" + m.date + " " + (m.time != null ? m.time : '') + " " + (m.placeName != null ? m.placeName : '') + "</span></button><br>");
    }
    return _results;
  })()).join('');
};

$('#container').on('click', '.match', function() {
  return view.viewGame($(this).attr('id'));
});

$('#container').on('click', '#logout', function() {
  return view.actionLogout();
});

$('#container').on('click', '#refreshGames', function() {
  $('.ajaxLoad').show();
  return view.actionLoadGames();
});

window.templates.game = function(game) {
  var html, menuCaption;
  menuCaption = game.teams[0].score + ':' + game.teams[1].score;
  html = templates.menu(menuCaption, 'toGamesList', 'refreshGame');
  html += templates.ajaxLoader;
  html += "<input type='hidden' id='gameId' value='" + game._id + "'>";
  return html += "<button class='btn btn-block btn-info' id=\"toProtocol\" data-side=\"home\">" + game.teams[0].name + " - протокол</button>\n<button class='btn btn-block btn-info' id=\"toProtocol\" data-side=\"away\">" + game.teams[1].name + " - протокол</button>\n<button class='btn btn-block btn-info' id=\"homeChoise\">" + game.teams[0].name + " - выбор</button>\n<button class='btn btn-block btn-info' id=\"awayChoise\">" + game.teams[1].name + " - выбор</button>\n<button class='btn btn-block btn-success' id=\"endMatch\">завершить матч</button>";
};

$('#container').on('click', '#toGamesList', function() {
  return view.viewLoadedGamesList();
});

$('#container').on('click', '#refreshGame', function() {
  var id;
  $('.ajaxLoad').show();
  id = $('#gameId').val();
  return view.actionLoadGame(id);
});

$('#container').on('click', '#toProtocol', function() {
  var id, side;
  id = $('#gameId').val();
  side = $(this).attr('data-side');
  return view.viewRoster(id, side);
});

$('#container').on('click', '#endMatch', function() {
  var id;
  if (confirm('Завершить матч? Это действие нельзя отменить')) {
    id = $('#gameId').val();
    return view.actionEndGame(id);
  }
});

window.templates.roster = function(gameId, side, team) {
  var formatPlayerName, html, pl, _i, _len, _ref;
  formatPlayerName = function(name) {
    return name.split(' ')[0];
  };
  html = templates.menu(team.name, 'toGame', 'refreshRoster');
  html += templates.ajaxLoader;
  html += "<input type='hidden' id='gameId' value='" + gameId + "'>";
  html += "<input type='hidden' id='side' value='" + side + "'>";
  html += "<div class=\"control-panel\">\n  <img class='btn btn-logo active' id=\"playedBtn\" src=\"/img/sprite/foot/shirt.png\">\n  <img class='btn btn-logo' id=\"goalBtn\" src=\"/img/sprite/foot/ball.png\">\n  <img class='btn btn-logo' id=\"passBtn\" src=\"/img/sprite/foot/assist.png\">\n  <img class='btn btn-logo' id=\"yellowBtn\" src=\"/img/sprite/foot/yellow_card.png\">\n  <img class='btn btn-logo' id=\"redBtn\" src=\"/img/sprite/foot/red_card.png\">\n  <img class='btn btn-logo' id=\"undoBtn\" src=\"/img/sprite/foot/undo.png\">\n</div><br>";
  html += '<div class="roster">';
  _ref = team.players;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    pl = _ref[_i];
    html += "<button class='btn btn-block btn-default player " + (pl.played ? '' : 'out') + "' id='" + pl._id + "'> <span class='number'>" + pl.number + "</span> <span class='name'>" + (formatPlayerName(pl.name)) + "</span> <div> " + ('<img style="height: 25px" src="/img/sprite/foot/ball.png">'.repeat(pl.goals)) + " " + ('<img style="height: 25px" src="/img/sprite/foot/assist.png">'.repeat(pl.assists)) + " " + (pl.yellow === 1 ? '<img style="height: 25px" src="/img/sprite/foot/yellow_card.png">' : pl.yellow === 2 ? '<img style="height: 25px" src="/img/sprite/foot/red_card_2yellow.png">' : '') + " " + (pl.red === 1 ? '<img style="height: 25px" src="/img/sprite/foot/red_card.png">' : '') + " </div> </button>";
  }
  return html += '</div>';
};

pressButton = function(target) {
  $(target).parent().find('.btn').each(function() {
    return $(this).removeClass('active');
  });
  return $(target).addClass('active');
};

setMode = function(mode) {
  return window.mode = mode;
};

$('#container').on('click', '#playedBtn', function() {
  pressButton(this);
  return setMode('played');
});

$('#container').on('click', '#goalBtn', function() {
  pressButton(this);
  return setMode('goal');
});

$('#container').on('click', '#passBtn', function() {
  pressButton(this);
  return setMode('assist');
});

$('#container').on('click', '#yellowBtn', function() {
  pressButton(this);
  return setMode('yellow');
});

$('#container').on('click', '#redBtn', function() {
  pressButton(this);
  return setMode('red');
});

$('#container').on('click', '#undoBtn', function() {
  var gameId, side;
  gameId = $('#gameId').val();
  side = $('#side').val();
  return view.actionUndo(gameId, side);
});

setPlayerStats = function($pl, key, value) {
  var gameId, id, side;
  id = $pl.attr('id');
  gameId = $('#gameId').val();
  side = $('#side').val();
  return view.actionSetPlayerStats(gameId, side, id, key, value);
};

$('#container').on('click', '.player', function() {
  var played;
  $(this).attr('disabled', true);
  if (mode === 'played') {
    played = $(this).hasClass('out');
    setPlayerStats($(this), 'played', played);
  }
  if (mode === 'goal') {
    setPlayerStats($(this), 'goals', {
      $inc: 1
    });
    view.actionIncrementScore($('#gameId').val(), $('#side').val());
  }
  if (mode === 'assist') {
    setPlayerStats($(this), 'assists', {
      $inc: 1
    });
  }
  if (mode === 'yellow') {
    setPlayerStats($(this), 'yellow', {
      $inc: 1
    });
  }
  if (mode === 'red') {
    return setPlayerStats($(this), 'red', {
      $inc: 1
    });
  }
});

$('#container').on('click', '#refreshRoster', function() {
  var id, side;
  $('.ajaxLoad').show();
  id = $('#gameId').val();
  side = $('#side').val();
  return view.actionLoadRoster(id, side);
});

$('#container').on('click', '#toGame', function() {
  var id;
  id = $('#gameId').val();
  return view.viewGame(id);
});
