var express = require('express');
var router = express.Router();
var Mock = require('mockjs');
/* GET users listing. */
router.get('/persons', function (req, res) {
    var tlp = {
        'count|1-100': 1,
        'list|1-100': [{
            'id|+1': 1,
            'isdel': '@BOOLEAN',
            'dn': '@name',
            'mobile|1': [13512345678, 18600000000],
            'phone|1': ["029-88888888", "10086"],
            'email|1': ["18740414439@139.com", "1075707996@qq.com"],
            'date': "@DATE"
        }]
    };
    var data = Mock.mock(tlp);
    res.send(data);
});
router.get('/calls', function (req, res) {
    var tlp = {
        'count|1-100': 1,
        'list|1-100': [{
            'id|+1': 1,
            'duration|55-7200': 1,
            'name': '@name',
            'number|1': [13512345678, 18600000000],
            'time': "@DATETIME",
            'type|1-4': 1
        }]
    };
    var data = Mock.mock(tlp);
    res.send(data);
});

router.get('/photos', function (req, res) {
    var tlp = {
        'count|1-100': 1,
        'list|2-5': [{
            'value|2011-2015': 2011,
            'date|1-10': [{
                'value': "@DATE",
                'data|3-13': [{
                    'id': '@guid',
                    'src': '@image(200x100)',
                    'name': '@first' + '.jpg',
                    'size|10-200': 1
                }]
            }]
        }]
    };
    var data = Mock.mock(tlp);
    res.send(data);
});

router.get('/messages', function (req, res) {
    var tlp = {
        'count|1-100': 1,
        'persons|1-50': [{
            'count|1-10': 1,
            'name': '@first',
            'phone|1': [13512345678, 18600000000],
            'id|+1': 1
        }]
    };
    var data = Mock.mock(tlp);
    res.send(data);
});

router.get('/messages/detail', function (req, res) {
    var tlp = {
        'count|1-100': 1,
        'sms|1-20': [{
            'id|+1': 1,
            'name': '@first',
            'number|1': [13488880000, 18822221111, 10086],
            'content': '@sentence',
            'date|+1': 1419834099609,
            'type|1-2': 1
        }]
    };
    var data = Mock.mock(tlp);
    res.send(data);
});


router.get('/notes', function (req, res) {
    var tlp = {
        'count|20-100': 20,
        'list|20-50': [{
            'id|+1': 1,
            'content': '@paragraph',
            'date': '@DATE'
        }]
    };
    var data = Mock.mock(tlp);
    setTimeout(function () {
        res.send(data);
    }, 1000);

});

module.exports = router;
