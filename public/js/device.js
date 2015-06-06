/*a
 Copyright © 2015. All rights reserved.
 @file device.js
 @author baiqiang
 @version 1-0-0
 */

(function () {
    var conatiner = $('#container');
    var position = new AMap.LngLat(108.91079853869292, 34.243326913620415);
    var map = new AMap.Map("container", {
        view: new AMap.View2D({
            center: position,
            zoom: 14,
            rotation: 0
        }),
        lang: "zh_cn"//设置语言类型，中文简体
    });
    conatiner.css('opacity', 1);
    function addMarker() {
        marker = new AMap.Marker({
            icon: "http://webapi.amap.com/images/marker_sprite.png",
            position: position,
        });
        //标记内容
        var markerContent = document.createElement("div");

        //点标记图标
        var markerImg = document.createElement("img");
        markerImg.src = "http://webapi.amap.com/images/3.png";
        markerContent.appendChild(markerImg);

        //点标记文本
        var markerSpan = document.createElement("span");
        markerSpan.innerHTML = "mx4Pro";
        markerSpan.className = "marker-text";
        markerContent.appendChild(markerSpan);

        marker.setContent(markerContent);
        marker.setMap(map);  //在地图上添加点
    }

    addMarker();
}).call(this);

