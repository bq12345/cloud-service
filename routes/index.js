var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function (req, res) {
    res.render('index.html', {title: '云服务', toekn: 'k4ss5s4f'});
});
router.get('/contact.html', function (req, res) {
    res.render('contact.html', {title: '通讯录', items: [1, 2, 3]});
});

router.get('/call.html', function (req, res) {
    res.render('call.html', {title: '通话记录', token: 123456});
});

router.get('/sms.html', function (req, res) {
    res.render('sms.html', {title: '短信', token: 123456});
});

router.get('/photo.html', function (req, res) {
    res.render('photo.html', {title: '相册', token: 123456});
});

router.get('/note.html', function (req, res) {
    res.render('note.html', {title: '便签', token: 123456});
});

router.partials = function (req, res) {
    var name = req.params.name;
    res.render('partials/' + name, {});
};
module.exports = router;
