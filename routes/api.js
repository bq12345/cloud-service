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
module.exports = router;
