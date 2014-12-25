var page = require('webpage').create();

ids = [
    '545ce6e7767982ec2bd3d646',
    '545ce680767982ec2bd3d619',
    '545ce6ae767982ec2bd3d62f',
    '545ce650767982ec2bd3d604',
    '545ce59b767982ec2bd3d5dd',
    '545ce624767982ec2bd3d5f0',
    '545ce460767982ec2bd3d5cb'
];


    page.open('http://localhost:3000/leagues/portugal/protocol/?54797b41f57ac5773962b838', function() {
        page.render('public/protocols/54797b41f57ac5773962b838.png');
        console.log('ok');
        page.open('http://localhost:3000/leagues/portugal/protocol/?54797b8ff57ac5773962b892', function() {
            page.render('public/protocols/54797b8ff57ac5773962b892.png');
            page.open('http://localhost:3000/leagues/portugal/protocol/?54797b27f57ac5773962b81c', function() {
                page.render('public/protocols/54797b27f57ac5773962b81c.png');
                page.open('http://localhost:3000/leagues/portugal/protocol/?54797bc4f57ac5773962b8d2', function() {
                    page.render('public/protocols/54797bc4f57ac5773962b8d2.png');
                    page.open('http://localhost:3000/leagues/portugal/protocol/?54797b79f57ac5773962b873', function() {
                        page.render('public/protocols/54797b79f57ac5773962b873.png');
                        page.open('http://localhost:3000/leagues/portugal/protocol/?54797afaf57ac5773962b801', function() {
                            page.render('public/protocols/54797afaf57ac5773962b801.png');
                            page.open('http://localhost:3000/leagues/portugal/protocol/?54797b5bf57ac5773962b855', function() {
                                page.render('public/protocols/54797b5bf57ac5773962b855.png');
                                    page.open('http://localhost:3000/leagues/portugal/protocol/?54797a8df57ac5773962b7b6', function() {
                                        page.render('public/protocols/54797a8df57ac5773962b7b6.png');
                                        phantom.exit();
                                });
                            });
                        });
                    });
                });
            });
        });
    });








//page.open('http://localhost:3000/leagues/portugal/table/', function() {
//    page.render('public/leagues/portugal/table.png');
//    page.open('http://localhost:3000/leagues/portugal/chess/', function() {
//        page.render('public/leagues/portugal/chess.png');
//        page.open('http://localhost:3000/leagues/portugal/calendar/', function() {
//            page.render('public/leagues/portugal/calendar.png');
//            page.open('http://localhost:3000/leagues/portugal/best/', function() {
//                page.render('public/leagues/portugal/best.png');
//                page.open('http://localhost:3000/leagues/portugal/summary/', function() {
//                    page.render('public/leagues/portugal/summary.png');
//                    page.open('http://localhost:3000/leagues/portugal/listplayers/?goals', function() {
//                        page.render('public/leagues/portugal/lp_goals.png');
//                        page.open('http://localhost:3000/leagues/portugal/listplayers/?assists', function() {
//                            page.render('public/leagues/portugal/lp_assists.png');
//                            page.open('http://localhost:3000/leagues/portugal/listplayers/?points', function() {
//                                page.render('public/leagues/portugal/lp_pointsy.png');
//                                page.open('http://localhost:3000/leagues/portugal/listplayers/?yellow', function() {
//                                    page.render('public/leagues/portugal/lp_yellow.png');
//                                    phantom.exit();
//                                });
//                            });
//                        });
//                    });
//                });
//            });
//        });
//    });
//});
//
