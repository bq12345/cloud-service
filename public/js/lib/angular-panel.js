angular.module("panel-directive", [])
    .directive('panel',
    function () {
        //把指令定义的对象返回
        return {
            //type 指令类型
            restrict: "A",
            /*
             这里的参数分析
             定义这样的一个指令它自己也有相应的作用域
             @是将指令范围(作用域)属性和DOM属性的值绑定。如果DOM属性的名字没有被指定，那么就和本地属性名一样。
             = 将指令范围(作用域)属性绑定到一个父范围属性。在本地作用域属性和父作用域属性间建立一个双向的绑定。如果没有指定父作用域属性名称，那就和本地名称一样。
             所以p-open是应该由父作用域控制改变的
             */
            scope: {
                pOpen: "=",
                pSpeed: "@",
                pClass: "@"
            },
            link: function ($scope, el, attrs) {
                //看看三个参数是什么 $scope当前元素关联的作用域。 el当前元素。 attrs 当前元素的属性对象。
                var param = {};
                //默认值
                param.speed = $scope.pSpeed || 0;
                param.className = $scope.pClass || 'ng-panel';

                // 添加类
                el.addClass(param.className);

                var slider = null;
                var body = document.body;
                //当前DOM节点
                slider = el[0];

                // Check for div tag
                if (slider.tagName.toLowerCase() !== 'div')
                    throw new Error('Please applied to <div> elements');


                var mask = angular.element(slider);


                body.appendChild(slider);

                /*一个全屏的遮罩样式，然后panel是在遮罩上面的*/

                slider.style.zIndex = 2;
                slider.style.position = 'fixed';
                slider.style.display = 'flex';
                slider.style.justifyContent = 'center';
                slider.style.alignTtems = 'center';
                slider.style.width = '100%';
                slider.style.height = '100%';
                slider.style.overflow = 'hidden';
                slider.style.top = '0';
                slider.style.left = '0';
                slider.style.opacity = 0.9;
                slider.style.background = '#fff';

                /* Closed */
                function pClose(slider, param) {
                    if (slider && slider.style.width !== 0 && slider.style.width !== 0) {
                        mask.css('display', 'none');
                    }
                    $scope.pOpen = false;
                }

                /* Open */
                function pOpen(slider, param) {
                    if (slider.style.width !== 0 && slider.style.width !== 0) {
                        if (param.speed === 0)
                            mask.css('display', 'flex');
                        else
                            setTimeout(function () {
                                mask.css('display', 'flex');
                            }, (param.speed * 1000));
                    }
                }

                /*
                 * 监听p-open的状态
                 * */

                $scope.$watch("pOpen", function (value) {
                    if (value) {
                        pOpen(slider, param);
                    } else {
                        pClose(slider, param);
                    }
                });
                $scope.$on('$destroy', function () {
                    document.body.removeChild(slider);
                });
            }
        };
    }
);

