var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function (req, res) {
    res.render('index.html', {title: '通讯录', items: [1, 2, 3]});
});
router.get('/call.html', function (req, res) {
    res.render('call.html', {title: '通话记录', token: 123456});
});
router.partials = function (req, res) {
    var name = req.params.name;
    res.render('partials/' + name, {});
};
module.exports = router;
