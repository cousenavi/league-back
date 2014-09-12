(function(){$(function(){var e,n,t;return t={login:function(){return'<div id="loginForm">\n<input type="text" data-value="login" class="form-control" placeholder=\'login\'><br>\n<input type="password" data-value="password" class="form-control" placeholder=\'password\'><br>\n<button id="loginBtn" class="btn btn-success btn-block">Go!</button>\n</div>'},matches:function(e){var n,t;return n='<nav class="navbar navbar-default" role="navigation">\n    <div class="navbar-header">\n        <a class="navbar-brand">Выберите матч</a>\n    </div>\n</nav>',n+=function(){var n,a,r;for(r=[],n=0,a=e.length;a>n;n++)t=e[n],r.push("<button class='btn btn-block btn-info match' id='"+t._id+"'class='match'>"+t.homeTeamName+" <br> "+t.awayTeamName+"<br><span class='smallText'>"+t.date+" "+t.time+" "+t.placeName+"</span></button><br>");return r}().join("")},game:function(e){var n,t;return'<div id="homeTeam" class="protocol">\n    <nav class="navbar navbar-default" role="navigation">\n            <div class="navbar-header">\n                <a class="navbar-brand">'+e.homeTeam.name+": состав</a>\n            </div>\n      </nav>\n  "+function(){var a,r;a=e.homeTeam.players,r=[];for(n in a)t=a[n],r.push("<button class='btn btn-block btn-default player homePlayer' id='"+n+"' >"+t.number+" "+t.name+"</button>");return r}().join("")+'\n  <button class=\'btn btn-block btn-success\'  id="saveHomeTeamBtn">OK</button>\n</div>\n\n<div id="awayTeam" style=\'display: none\' class="protocol">\n      <nav class="navbar navbar-default" role="navigation">\n            <div class="navbar-header">\n                <a class="navbar-brand">'+e.awayTeam.name+": состав</a>\n            </div>\n      </nav>\n  "+function(){var a,r;a=e.awayTeam.players,r=[];for(n in a)t=a[n],r.push("<button class='btn btn-block btn-default player awayPlayer'  id='"+n+"'>"+t.number+" "+t.name+"</button>");return r}().join("")+"\n  <button class='btn btn-block btn-success' id=\"saveAwayTeamBtn\">OK</button>\n</div>"},events:function(){return'    <nav class="navbar navbar-default" role="navigation">\n          <div class="navbar-header">\n              <a class="navbar-brand"> '+n.currentGame.homeTeam.name+" "+n.currentGame.homeTeam.score+"-"+n.currentGame.awayTeam.score+" "+n.currentGame.awayTeam.name+'</a>\n          </div>\n    </nav>\n<button class="btn btn-block btn-info event" id="goalEvent">Гол</button><br>\n<button class="btn btn-block btn-info event" id="yellowEvent">Жёлтая карточка</button><br>\n<button class="btn btn-block btn-info event" id="redEvent">Прямая красная</button><br>\n<button class="btn btn-block btn-success event" id="endEvent">Конец матча</button><br>'},goalEvent:function(){var e,t;return'  <span id=\'goal\'>\n    <nav class="navbar navbar-default" role="navigation">\n      <div class="navbar-header">\n        <a class="navbar-brand">Гол</a>\n      </div>\n    </nav>\n      <div class="btn-group btn-group-justified">\n  <a class="btn btn-default active goalEventType" role="button" id="G+">Гол+ </a>\n  <a class="btn btn-default goalEventType" role="button" id="A+">Пас+ </a>\n  <a class="btn btn-default goalEventType" role="button" id="G-">Гол-</a>\n  <a class="btn btn-default goalEventType" role="button" id="A-">Пас-</a>\n</div>\n      <h2>'+n.currentGame.homeTeam.name+"</h2>\n      "+function(){var a,r;a=n.currentGame.homeTeam.players,r=[];for(e in a)t=a[e],r.push("<button id='"+e+"' class='btn btn-default playerEvent'>"+t.number+" <span class='goals'>"+(null!=t.goals?t.goals:0)+"</span> <span class='assists'>"+(null!=t.assists?t.assists:0)+"</span> </button> ");return r}().join("")+"\n      <h2>"+n.currentGame.awayTeam.name+"</h2>\n      "+function(){var a,r;a=n.currentGame.awayTeam.players,r=[];for(e in a)t=a[e],r.push("<button id='"+e+"' class='btn btn-default playerEvent'>"+t.number+" <span class='goals'>"+(null!=t.goals?t.goals:0)+"</span> <span class='assists'>"+(null!=t.assists?t.assists:0)+"</span> </button> ");return r}().join("")+'\n<br><br>\n    <button class="btn btn-block btn-success" id="saveEvent">OK</button>\n  </span>'},yellowEvent:function(){var e,t;return'<span id=\'yellow\'>\n<nav class="navbar navbar-default" role="navigation">\n  <div class="navbar-header">\n    <a class="navbar-brand">Жёлтая карточка</a>\n  </div>\n</nav>\n  <h4>Millwall</h4>\n  '+function(){var a,r;a=n.currentGame.homeTeam.players,r=[];for(e in a)t=a[e],r.push("<button id='"+e+"' class='btn btn-default playerEvent "+(2===t.yellow?"btn-selected-red":1===t.yellow?"btn-selected-yellow":"")+"'>"+t.number+"</button> ");return r}().join("")+"\n  <h4>Wimbledon</h4>\n  "+function(){var a,r;a=n.currentGame.awayTeam.players,r=[];for(e in a)t=a[e],r.push("<button id='"+e+"' class='btn btn-default playerEvent "+(2===t.yellow?"btn-selected-red":1===t.yellow?"btn-selected-yellow":"")+"'>"+t.number+"</button> ");return r}().join("")+'\n\n<br><br><button class="btn btn-block btn-success" id="saveEvent">OK</button>\n</span>'},redEvent:function(){var e,t;return console.log(n.currentGame.homeTeam.players),'<span id=\'red\'>\n<nav class="navbar navbar-default" role="navigation">\n  <div class="navbar-header">\n    <a class="navbar-brand">Прямая красная</a>\n  </div>\n</nav>\n  <h4>Millwall</h4>\n  '+function(){var a,r;a=n.currentGame.homeTeam.players,r=[];for(e in a)t=a[e],r.push("<button id='"+e+"' class='btn btn-default playerEvent "+(1===t.red?"btn-selected-red":"")+"'>"+t.number+"</button> ");return r}().join("")+"\n  <h4>Wimbledon</h4>\n  "+function(){var a,r;a=n.currentGame.awayTeam.players,r=[];for(e in a)t=a[e],r.push("<button id='"+e+"' class='btn btn-default playerEvent "+(1===t.red?"btn-selected-red":"")+"' >"+t.number+"</button> ");return r}().join("")+'\n\n<br><br><button class="btn btn-block btn-success" id="saveEvent">OK</button>\n</span>'},endEvent:function(){return'<button class="btn btn-block btn-info" id="homeTeamChoise">выбор<br>'+n.currentGame.homeTeam.name+'</button> <br>\n<button class="btn btn-block btn-info"  type="button" id="awayTeamChoise">выбор<br>'+n.currentGame.awayTeam.name+'</button> <br>\n<button class="btn btn-block btn-success" id="saveChoises">OK</button>'},choise:function(e){var t,a,r,s,l,o,i;for(l=[],"Home"===e?(l=n.currentGame.awayTeam.players,o=n.currentGame.homeTeam):(l=n.currentGame.homeTeam.players,o=n.currentGame.awayTeam),t='    <nav class="navbar navbar-default" role="navigation">\n        <div class="navbar-header">\n            <a class="navbar-brand">'+o.name+': оценка судье</a>\n        </div>\n    </nav>\n<div>\n    <div class="row">',r=i=2;5>=i;r=++i)t+='<div class="col-xs-3 col-md-3 col-lg-3">\n  <button type="button" class=\'btn btn-default btn-block refereeMark mark'+e+" "+(r===o.refereeMark?":active":"")+"'>"+r+"</button>\n</div>";return t+='</div><br>\n  <nav class="navbar navbar-default" role="navigation">\n    <div class="navbar-header">\n        <a class="navbar-brand">лучшие игроки соперника</a>\n    </div>\n  </nav>\n<div>\n'+function(){var e;e=[];for(a in l)s=l[a],e.push("<button class='btn btn-default playerEvent bestPlayer "+(null!=s.star?":active":"")+"'  id='"+a+"' class='playerEvent bestPlayer }'>"+s.number+"</button>");return e}().join("")+'\n</div><br><button class="btn btn-block btn-success" id="save'+e+'TeamChoise">OK</button>'},error:function(){return"error"}},e=function(e){var n;return n={},e.find("[data-value]").each(function(){return n[$(this).attr("data-value")]=$(this).val()}),e.find("[data-collection]").each(function(){var e;return e=$(this).attr("data-collection"),n[e]=[],$(this).find("[data-element]").each(function(){var t;return t={},$(this).find("[data-atom]").each(function(){return t[$(this).attr("data-atom")]=$(this).val()}),n[e].push(t)})}),n},n={currentEvent:"G+"},n.load=function(){var e,t,a,r;a=JSON.parse(localStorage.getItem("registry")),r=[];for(e in a)t=a[e],r.push(n[e]=t);return r},n.save=function(){return localStorage.setItem("registry",JSON.stringify(n))},n.sync=function(e){return console.log("здесь мы синхронизируем регистр с сервером"),"function"==typeof e?e():void 0},n.endGame=function(){return this.currentGame.ended=!0,this.sync(),this.save()},n.setCurrentGame=function(e){return this.currentGame=e,e&&(this.currentGame.homeTeam.score=this.currentGame.awayTeam.score=0),this.save()},n.setUser=function(e){return this.currentUser=e,this.save()},n.setHomeRefereeMark=function(e){return this.currentGame.homeTeam.refereeMark=parseInt(e),this.save()},n.setAwayRefereeMark=function(e){return this.currentGame.awayTeam.refereeMark=parseInt(e),this.save()},n.removeBestPlayer=function(e){return null!=this.currentGame.homeTeam.players[e]?delete this.currentGame.homeTeam.players[e].star:delete this.currentGame.awayTeam.players[e].star,this.save()},n.setBestPlayer=function(e){return null!=this.currentGame.homeTeam.players[e]?this.currentGame.homeTeam.players[e].star=!0:this.currentGame.awayTeam.players[e].star=!0,this.save()},n.setPlayerActivity=function(e,n){return null!=this.currentGame.homeTeam.players[e]?this.currentGame.homeTeam.players[e].played=n:this.currentGame.awayTeam.players[e].played=n,this.save()},n.setPlayerGoals=function(e,n){var t,a,r;null!=this.currentGame.homeTeam.players[e]?this.currentGame.homeTeam.players[e].goals=n:this.currentGame.awayTeam.players[e].goals=n,this.currentGame.homeTeam.score=this.currentGame.awayTeam.score=0,a=this.currentGame.homeTeam.players;for(e in a)t=a[e],null!=t.goals&&(this.currentGame.homeTeam.score+=parseInt(t.goals));r=this.currentGame.awayTeam.players;for(e in r)t=r[e],null!=t.goals&&(this.currentGame.awayTeam.score+=parseInt(t.goals));return this.save()},n.setPlayerAssists=function(e,n){return null!=this.currentGame.homeTeam.players[e]?this.currentGame.homeTeam.players[e].assists=n:this.currentGame.awayTeam.players[e].assists=n,this.save()},n.setPlayerYellow=function(e,n){return null!=this.currentGame.homeTeam.players[e]?this.currentGame.homeTeam.players[e].yellow=n:this.currentGame.awayTeam.players[e].yellow=n,this.save()},n.setPlayerRed=function(e,n){return null!=this.currentGame.homeTeam.players[e]?this.currentGame.homeTeam.players[e].red=n:this.currentGame.awayTeam.players[e].red=n,this.save()},n.load(),null==n.currentUser?$("#container").html(t.login()):null==n.currentGame?$.ajax({url:"/matches",method:"GET",success:function(e){return $("#container").html(t.matches(e))},error:function(){return $("#container").html(t.error)}}):$("#container").html(null==n.currentGame.ended?t.events():t.endEvent()),$("#container").on("click","#loginBtn",function(){var a;return $(this).html("...").attr("disabled","true"),a=e($(this).parent()),$.ajax({url:"/login",method:"POST",data:a,success:function(e){return n.setUser(!0),$("#container").html(t.matches(e))},error:function(){return $(this).html("Go!")}})}),$("#container").on("click",".match",function(){return $(this).parent().find(".match").each(function(){return $(this).attr("disabled",!0)}),$(this).html("..."),$.ajax({url:"/game?_id="+$(this).attr("id"),success:function(e){return n.setCurrentGame(e),$("#container").html(t.game(e))},error:function(){return $("#container").html(t.error())}})}),$("#container").on("click",".protocol .player",function(){return $(this).toggleClass("btn-selected"),n.setPlayerActivity($(this).attr("id"),$(this).hasClass("btn-selected"))}),$("#container").on("click","#saveHomeTeamBtn",function(){return $("#homeTeam").hide(),$("#awayTeam").show()}),$("#container").on("click","#saveAwayTeamBtn",function(){return n.sync(),$("#container").html(t.events())}),$("#container").on("click","#goalEvent",function(){return $("#container").html(t.goalEvent())}),$("#container").on("click","#yellowEvent",function(){return $("#container").html(t.yellowEvent())}),$("#container").on("click","#redEvent",function(){return $("#container").html(t.redEvent())}),$("#container").on("click","#endEvent",function(){return confirm("Закончить матч? Это действие нельзя будет отменить")?(n.endGame(),$("#container").html(t.endEvent())):void 0}),$("#container").on("click","#homeTeamChoise",function(){return $("#container").html(t.choise("Home"))}),$("#container").on("click","#awayTeamChoise",function(){return $("#container").html(t.choise("Away"))}),$("#container").on("click",".goalEventType",function(){return $(this).parent().find(".goalEventType").each(function(){return $(this).removeClass("active")}),$(this).addClass("active"),n.currentEvent=$(this).attr("id")}),$("#container").on("click","#goal .playerEvent",function(){return"G+"===n.currentEvent&&$(this).find(".goals").html(parseInt($(this).find(".goals").html())+1),"G-"===n.currentEvent&&$(this).find(".goals").html(parseInt($(this).find(".goals").html())-1),"A+"===n.currentEvent&&$(this).find(".assists").html(parseInt($(this).find(".assists").html())+1),"A-"===n.currentEvent&&$(this).find(".assists").html(parseInt($(this).find(".assists").html())-1),n.setPlayerGoals($(this).attr("id"),$(this).find(".goals").html()),n.setPlayerAssists($(this).attr("id"),$(this).find(".assists").html())}),$("#container").on("click","#yellow .playerEvent",function(){return $(this).hasClass("btn-selected-yellow")?($(this).removeClass("btn-selected-yellow").addClass("btn-selected-red"),n.setPlayerYellow($(this).attr("id"),2)):$(this).hasClass("btn-selected-red")?($(this).removeClass("btn-selected-red"),n.setPlayerYellow($(this).attr("id"),0)):($(this).addClass("btn-selected-yellow"),n.setPlayerYellow($(this).attr("id"),1))}),$("#container").on("click","#red .playerEvent",function(){return $(this).hasClass("btn-selected-red")?($(this).removeClass("btn-selected-red"),n.setPlayerRed($(this).attr("id"),0)):($(this).addClass("btn-selected-red"),n.setPlayerRed($(this).attr("id"),1))}),$("#container").on("click",".refereeMark",function(){return $(this).hasClass("markHome")?n.setHomeRefereeMark($(this).html()):n.setAwayRefereeMark($(this).html()),$(this).parent().parent().find(".btn-selected").each(function(){return $(this).removeClass("btn-selected")}),$(this).addClass("btn-selected")}),$("#container").on("click",".bestPlayer",function(){return $(this).hasClass("btn-selected")?($(this).removeClass("btn-selected"),n.removeBestPlayer($(this).attr("id"))):$(this).parent(".btn-selected").length<3?($(this).addClass("btn-selected"),n.setBestPlayer($(this).attr("id"))):void 0}),$("#container").on("click","#saveHomeTeamChoise",function(){return $("#container").html(t.endEvent())}),$("#container").on("click","#saveAwayTeamChoise",function(){return $("#container").html(t.endEvent())}),$("#container").on("click","#saveChoises",function(){return $(this).html("..."),n.sync(function(){return n.setCurrentGame(null),location.reload()})}),$("#container").on("click","#event-goal input",function(){return 0===$(".playerEventTable .goal").length?$(this).addClass("goal"):$(this).hasClass("goal")?$(this).removeClass("goal"):$(this).hasClass("assist")?$(this).removeClass("assist"):$(this).addClass("assist")}),$("#container").on("click","#saveEvent",function(){return $("#container").html(t.events())})})}).call(this);