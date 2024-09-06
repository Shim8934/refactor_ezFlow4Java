/*The MIT License (MIT)

Copyright (c) 2018 Chart.js Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/

// Ez차트 모듈 정의. chart.js 의 사용할 기능을 정리해 놓음.
// 구현된 차트들 예제 json (jsonArr)
// label은 항상 val 에 대응
// ex) 스택바 형 -  groupTitle 사용(여러데이터 용). order by groupTitle, label.
// [
// 	{
// 		"color": "",
// 		"label": "1월",
// 		"groupTitle": "대내문서",
// 		"val": 738
// 	},
// 	{
// 		"color": "",
// 		"label": "2월",
// 		"groupTitle": "대내문서",
// 		"val": 9500
// 	},
// 	...
//  {
// 		"color": "",
// 		"label": "11월",
// 		"groupTitle": "대외문서",
// 		"val": 10900
// 	},
// 	{
// 		"color": "",
// 		"label": "12월",
// 		"groupTitle": "대외문서",
// 		"val": 6691
// 	}
// ]

// ex) 도넛 형
// [
//         {
//             "label": "0번",
//             "val": 2673,
//             "title": "",
//             "color": ""
//         },
//         {
//             "label": "1번",
//             "val": 1991,
//             "title": "",
//             "color": ""
//         },
//         {
//             "label": "2번",
//             "val": 2434,
//             "title": "",
//             "color": ""
//         }
//     ]




// 새로운 차트 유형을 추가하거나 수정이 필요한 경우 여기 수정
function EzChartPortlet() {
    var _barThick = 0.5; //bar굵기. 0~1
    // 막대그래프 옵션
    var _doughnutThick = 0.8; // 도넛굵기
    var _realType;
    var _chart;
    var _json;
    var _canvas;
    var _data = {};
    var _option = {};
    var _defaultColor = (function () {
        var arr = new Uint32Array(1);
        var crypto = window.crypto || window.msCrypto;
        crypto.getRandomValues(arr);
        return (arr[0]%72)*5;
    })();
    var _defaultColorHis = [];

    var _stackBarOptions = {
        maintainAspectRatio: false,
        legend: {
            display: true,
            position: 'right'
        },
        scales: {
            yAxes: [{
                stacked: true,
                ticks: {
                    min: 0,
                    fontSize: 14,
                    callback: function (value, index, values) {
                        value = value.toString();
                        value = value.split(/(?=(?:...)*$)/);
                        value = value.join(',');
                        return value;
                    }
                }
            }],
            xAxes: [{
                stacked: true,
                ticks: {
                    fontSize: 14
                }
            }]
        },
        tooltips: {
            enabled: true,
            mode: 'single',
            callbacks: {
                label: function (tooltipItem, data) {
                    let value = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
                    value = value.toString();
                    value = value.split(/(?=(?:...)*$)/);
                    value = value.join(',');
                    return value;
                }
            }
        }
    };
    // 도넛 그래프 옵션
    var _doughnutOptions = {
        maintainAspectRatio: false,
        legend: {
            display: true,
            position: 'top'
        },
        scales: {
            yAxes: [{
                display: false,
            }]
        },
        tooltips: {
            enabled: true,
            mode: 'single',
            callbacks: {
                label: function (tooltipItem, data) {
                    let value = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index];
                    value = value.toString();
                    value = value.split(/(?=(?:...)*$)/);
                    value = value.join(',');
                    return value;
                }
            }
        },
        legendCallback: function (chart) {
        }
    };

    var _initStackBar = function () {
        _realType = "bar"
        var barData = {};
        var barLabel = [];
        var beforeTitle = _json[0].groupTitle;
        var datasets = [];
        var dataset = {
            barPercentage: _barThick,
            label: beforeTitle,
            backgroundColor: !!_json[0].color ? _json[0].color: _genRotateColor(),
            data: []
        };
        for (var i = 0; i < _json.length; i++){
            var item = _json[i];
            var title = item.groupTitle;
            if (beforeTitle !== title) {
                datasets.push(dataset);
                dataset = {
                    barPercentage: _barThick,
                    label: title,
                    backgroundColor: !!item.color ? item.color : _genRotateColor(),
                    data: []
                };
                beforeTitle = title;
            }
            barLabel.push(item.label);
            dataset.data.push(item.val);
        }
        datasets.push(dataset);
        barLabel.length = barLabel.length / datasets.length
        _data.labels = barLabel;
        _data.datasets = datasets;
        _option = _stackBarOptions;
        /* 2024-04-30 position 속성 추가 */
        var parentElement = _canvas.parentElement;
        if (!parentElement.style.position) parentElement.style.position = 'relative';
    }

    var _initDoughnut = function () {
        _realType = "doughnut"
        _data.labels = [];
        _data.datasets = [];
        var dataset = {};
        _data.datasets.push(dataset);
        dataset.data = [];
        dataset.backgroundColor = [];
        for (var i = 0; i < _json.length; i++){
            var item = _json[i];
            _data.labels.push(item.label);
            dataset.barPercentage = _doughnutThick;
            dataset.data.push(item.val);
            if(!!item.color) {
                dataset.backgroundColor.push(item.color);
            } else {
                dataset.backgroundColor.push(_genRotateColor());
            }
        }
        _option = _doughnutOptions;
    }

    var _init = function () {
        var ctx = _canvas.getContext("2d");
        _chart = new Chart(ctx, {
            type: _realType,
            data: _data,
            options: _option
        });
        return true;
    }

    // 도넛그래프 가운데 숫자 공간 만들기
    var _makeCount = function () {
        var chartArea = _chart.chartArea;
        var radius = _chart.innerRadius;
        var width = chartArea.right - chartArea.left;
        var height = chartArea.bottom - chartArea.top;
        var size = radius * 2 - 2;
        if (size === 0) return;

        var countDiv = document.createElement('div');
        countDiv.className = 'div-counts';
        var countSpan = document.createElement('span');
        countSpan.className = 'span-counts';
        var parentElement = _canvas.parentElement;
        if (!parentElement.style.position) parentElement.style.position = 'relative';
        var before = parentElement.querySelector('.div-counts');
        if(!!before) parentElement.removeChild(before);
        parentElement.appendChild(countDiv);
        countDiv.appendChild(countSpan);
        countDiv.style.position = "absolute";
        countDiv.style.display = "flex";
        countDiv.style.justifyContent = "center";
        countDiv.style.alignItems = "center";
        countDiv.style.width = size + "px";
        countDiv.style.height = size + "px";
        countDiv.style.left = ((width - size) / 2) + "px";
        countDiv.style.top = ((height - size) / 2 + chartArea.top) + "px";
        countSpan.style.fontWeight = 'bold';

        // 0이상~10억 미만까지 범위, 각 숫자 자릿수일 경우의 폰트 사이즈 크기 배열(px)
        var sumDataStr = _chart.getDatasetMeta(0).total;
        // 총합 쉼표 처리
        $({val: parseInt(countSpan.innerText.replaceAll(',', ''))}).animate({val: sumDataStr}, {
            duration: 1000,
            step: function () {
                countSpan.innerText = Math.floor(this.val).toString().split(/(?=(?:...)*$)/).join(',');
                adjustFontSizeToFitWidth(countSpan, size, size);
            },
            complete: function () {
                countSpan.innerText = Math.floor(this.val).toString().split(/(?=(?:...)*$)/).join(',');
                adjustFontSizeToFitWidth(countSpan, size, size);
            }
        });
    }

    var _initDouCount = function () {
        var saveVal = _chart.getDatasetMeta(0).total;
        Object.defineProperty(_chart.getDatasetMeta(0), 'total', {
            get: function () {
                return this._value;
            },
            set: function (newValue) {
                this._value = newValue;
                _makeCount();
            },
        });
        _chart.getDatasetMeta(0).total = saveVal;
        _makeCount();
    }

    var _genRotateColor = function () {
        var colorSet = ",50%,50%,0.7";
        var rotate = 120;
        var twist = 195;
        _defaultColor += rotate;
        _defaultColor = _defaultColor % 360;

        // 중복체크를 너무 길면 주기를 돌아 무한루프 하므로 제거.
        if (_defaultColorHis > 70) _defaultColorHis = [];

        if (_defaultColorHis.indexOf(_defaultColor) > -1) {
            _defaultColor += twist;
            return _genRotateColor();
        } else {
            _defaultColorHis.push(_defaultColor);
            return "hsla(" + _defaultColor + colorSet + ")";
        }
    }


    return {
        // canvas = 차트를 생성할 canvas 태그 dom 객체
        draw: function (canvas) {
            if (!canvas || !canvas.getContext) return null;
            _canvas = canvas;
            return {
                initStackBar: function (json) {
                    _json = json;
                    _initStackBar();
                    _init();
                },
                initDou: function (json) {
                    _json = json;
                    _initDoughnut();
                    _init()
                    return {
                        count: function () {
                            _initDouCount();
                        }
                    };
                }
            }
        },
    };
}
// 모듈 끝

