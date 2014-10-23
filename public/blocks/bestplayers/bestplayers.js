(function() {
  (function($) {
    var templates;
    templates = {
      field: function(players) {
        var pl, _i, _len;
        for (_i = 0, _len = players.length; _i < _len; _i++) {
          pl = players[_i];
          pl.name = pl.name.toLowerCase();
          pl.firstName = pl.name.split(' ')[0];
          pl.firstName = pl.firstName.charAt(0).toUpperCase() + pl.firstName.slice(1);
          pl.lastName = pl.name.split(' ')[1];
          pl.fullName = pl.firstName + ' ' + pl.lastName.charAt(0).toUpperCase() + pl.lastName.slice(1);
        }
        return "    <div id='field'>\n" + (((function() {
          var _j, _len1, _results;
          _results = [];
          for (_j = 0, _len1 = players.length; _j < _len1; _j++) {
            pl = players[_j];
            _results.push("<div class='player " + pl.position + "'><img src='/" + pl.teamLogo + "'><br>" + pl.firstName + "</div>");
          }
          return _results;
        })()).join('')) + "\n    </div>\n\n    <table class=\"table table-striped\" id=\"statsTable\">\n    <thead><th>Name</th><th>Pos</th><th>G</th><th>A</th></thead>\n    " + (((function() {
          var _j, _len1, _results;
          _results = [];
          for (_j = 0, _len1 = players.length; _j < _len1; _j++) {
            pl = players[_j];
            _results.push("<tr><td><img src='/" + pl.teamLogo + "'> " + pl.fullName + "</td><td>" + pl.position + "</td><td>" + pl.goals + "</td><td>" + pl.assists + "</td></tr>");
          }
          return _results;
        })()).join('')) + "\n    </table>";
      }
    };
    return $.fn.bestplayers = function(leagueId, tourNumber) {
      return $.getJSON("/tables/best_players?leagueId=" + leagueId + "&tourNumber=" + tourNumber, (function(_this) {
        return function(bp) {
          return _this.html(templates.field(bp[0].players));
        };
      })(this));
    };
  })(jQuery);

}).call(this);
