var page = require('webpage').create();

page.open('http://localhost:3000/leagues/portugal/table/', function() {
    page.render('public/leagues/portugal/table.png');
    page.open('http://localhost:3000/leagues/portugal/chess/', function() {
        page.render('public/leagues/portugal/chess.png');
        page.open('http://localhost:3000/leagues/portugal/calendar/', function() {
            page.render('public/leagues/portugal/calendar.png');
            page.open('http://localhost:3000/leagues/portugal/best/', function() {
                page.render('public/leagues/portugal/best.png');
                page.open('http://localhost:3000/leagues/portugal/summary/', function() {
                    page.render('public/leagues/portugal/summary.png');
                    page.open('http://localhost:3000/leagues/portugal/listplayers/?goals', function() {
                        page.render('public/leagues/portugal/lp_goals.png');
                        page.open('http://localhost:3000/leagues/portugal/listplayers/?assists', function() {
                            page.render('public/leagues/portugal/lp_assists.png');
                            page.open('http://localhost:3000/leagues/portugal/listplayers/?points', function() {
                                page.render('public/leagues/portugal/lp_pointsy.png');
                                page.open('http://localhost:3000/leagues/portugal/listplayers/?yellow', function() {
                                    page.render('public/leagues/portugal/lp_yellow.png');
                                    phantom.exit();
                                });
                            });
                        });
                    });
                });
            });
        });
    });
});

