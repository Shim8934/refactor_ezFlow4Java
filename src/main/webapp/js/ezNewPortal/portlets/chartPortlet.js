/*The MIT License (MIT)

Copyright (c) 2018 Chart.js Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/
// 2021-02-22 박기범 - 차트 포틀릿 추가

var barThick = 0.5; //bar굵기. 0~1
var scaleNum = 20000;
var xAxes = lastMonths();

var labels0 = messages.strLang36;
var labels1 = messages.strLang37;
var labels2 = messages.strLang38;
var data0 = [];
var data1 = [];
var data2 = [];
var sumData0, sumData1, sumData2, sumData;
var insend = [];
var outsend = [];
var outreceive = [];
var barData, doughnutData;

// 언어 - 1~12월
var monthStrArr = [messages.strLang586, messages.strLang587, messages.strLang588, messages.strLang589, messages.strLang590, messages.strLang591, 
	messages.strLang592, messages.strLang593, messages.strLang594, messages.strLang595, messages.strLang596, messages.strLang597];

// 막대그래프 옵션
var barOptions = {
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
var doughnutOptions = {
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
	}
};

function getYearlyDocCount() {
	var request = new XMLHttpRequest();
    request.open('GET', '/ezStatistics/getYearlyDocCount.do', true);
    request.setRequestHeader('Content-Type', 'application/json');

	request.onload = function () {
        if (request.status >= 200 && request.status < 400) {
            var jsonCounts = JSON.parse(request.responseText);

            if (jsonCounts.result == "true") {
            	var data = jsonCounts.data;

				// 불러온 데이터값이 없을경우
				if (typeof data == "undefined") {
					initFail();
					return;
				}

				for (var tempKey in data) {
					switch (tempKey.split(":")[0]) {
						case "INSEND" :
							insend[Number(tempKey.split(":")[1])] = data[tempKey];
							break;
						case "OUTSEND" :
							outsend[Number(tempKey.split(":")[1])] = data[tempKey];
							break;
						case "OUTRECEIVE" :
							outreceive[Number(tempKey.split(":")[1])] = data[tempKey];
							break;
					}
				}

				xAxes.forEach (function (item, index) {
					// 매년 1월 1일 해당달의 데이터 값이 없을경우 or 해당 달의 데이터값이 존재하지 않을경우 대비
					data0[index] = (typeof insend != "undefined" && typeof insend[item] != "undefined") ? insend[item] : 0;
					data1[index] = (typeof outsend != "undefined" && typeof outsend[item] != "undefined") ? outsend[item] : 0;
					data2[index] = (typeof outreceive != "undefined" && typeof outreceive[item] != "undefined") ? outreceive[item] : 0;
					
				});
				
				sumData0 = sumArray(data0);
				sumData1 = sumArray(data1);
				sumData2 = sumArray(data2);
				sumData  = sumData0 + sumData1 + sumData2;
				xAxes = fixMonths(xAxes);
				setChartData();

				// 프레임 가로폭이 길 경우 도넛 그래프도 생성
				if (frameId === "Frame3" || frameId === "Frame4" || frameId === "Frame7"){
					doughnutOn();
				}

				initChart();
            } else if (jsonCounts.result == "false") {
				initFail();
			}

        } else {
			initFail();
            // We reached our target server, but it returned an error
        }
    };

    request.onerror = function () {
        // There was a connection error of some sort
    };
    request.send();
}

function initChart() {
	var ctx = document.getElementById("canvas").getContext("2d");
	var myBar = new Chart(ctx, {
		type: 'bar',
		data: barData,
		options: barOptions
	});

	var dctx = document.getElementById("canvas2").getContext("2d");
	var myDoughnut = new Chart(dctx, {
		type: 'doughnut',
		data: doughnutData,
		options: doughnutOptions
	});
	doughnutCountModification();
}

// 도넛그래프 가운데 숫자길이에 따른 폰트 지정
function doughnutCountModification() {
	// 0이상~10억 미만까지 범위, 각 숫자 자릿수일 경우의 폰트 사이즈 크기 배열(px) 
	var modificationSize = new Array(30, 30, 23, 21, 18, 15, 12, 11, 10, 10);
	var sumDataStr = sumData.toString();

	if (sumDataStr.length < 11) {
		var fontSize = modificationSize[sumDataStr.length - 1];
	} else {
		var fontSize = 10;
	}
	
	var countSpan = document.getElementById("yearProduceCountsSpan");
	// 총합 쉼표 처리
	sumDataStr = sumDataStr.split(/(?=(?:...)*$)/).join(',');
	countSpan.innerText = sumDataStr;
	countSpan.setAttribute("style", "font-size:" + fontSize + "px;");
	document.getElementById("countsDiv").style.width = "190px"
	// 영어일 경우 폰트 위치 조절
	if (typeof portletLang != "undefined" && portletLang != null && portletLang == 2) {
		document.getElementById("countsDiv").style.width = "178px";
	}
}

function randomScaling() {
	return Math.floor(Math.random() * scaleNum);
}

function initFail() {
	var failSpace = document.getElementById("chartPortletList");
	var failStr = "<dl class='nodata'>";
	failStr += "<dt><img src='/images/kr/main/noData_sIcon.png'></dt>";
	failStr += "<dd>" + messages.strLang1 + "</dd>";
	failStr += "</dl>";

	failSpace.innerHTML = failStr;
	failSpace.firstChild.style.margin = "0 auto";
}

function lastMonths() {
	var today = new Date();
	var arr = new Array();
	var thisMonth = today.getMonth() + 1;

	for (var i = thisMonth - 11 ; i <= thisMonth; i++) {
		arr.push(i);
	}

	return arr;
}

// 달에 해당하는 값을 message string 값으로 교체
function fixMonths(arr) {
	var returnArr = new Array();
		
	arr.forEach(function (item, index) {
		var fixIndex = item > 0 ? item - 1 : item + 11;
		returnArr[index] = monthStrArr[fixIndex];
	});
	
	return returnArr;
}

function setChartData() {
	barData = {
	labels: xAxes,
	datasets: [{
		barPercentage: barThick,
		label: labels0,
		backgroundColor: 'rgba(255, 99, 132, 0.2)',
		data: data0
		}, {
		barPercentage: barThick,
		label: labels1,
		backgroundColor: 'rgba(200, 228, 243, 0.8)',
		data: data1
		}, {
		barPercentage: barThick,
		label: labels2,
		backgroundColor: 'rgba(59, 158, 152, 0.5)',
		data: data2
		}]
	};
	
	doughnutData = {
	labels: [labels0, labels1, labels2],
	datasets: [{
		barPercentage: 0.8,
		backgroundColor: ['rgba(255, 99, 132, 0.2)', 'rgba(200, 228, 243, 0.8)', 'rgba(59, 158, 152, 0.5)'],
		data: [sumData0, sumData1, sumData2]
		}]
	};
}

function initData() {
	var dataArr = new Array();
	var dataNums = 12;	// 데이터 갯수

	for (var i = 0 ; i < dataNums; i++) {
		dataArr[i] = randomScaling();
	}

	return dataArr;
}

function is2021Year() {
	var thisYear = (new Date()).getFullYear();
	return thisYear == 2021 ? true : false;
}

function sumArray(arr) {
	var arrSum = 0;

	for (var i = 0; i < arr.length; i++) {
		arrSum += arr[i];
	}

	return arrSum;
}

function doughnutOn() {
	document.querySelector("#chartLeft").style.display = "";
	document.querySelector("#chartRight").style.width = "75%";
	barOptions.legend.display = false;
}