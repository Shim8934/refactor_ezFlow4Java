<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.orbit-1.2.3.min.js')}"></script>
<script type="text/javascript">
var currentWeather = "${currentWeather}";
var todayWeather = "${todayWeather}";
var cityList = JSON.parse('${cityList}');
var cityCode = "${cityCode}";
var displayName = "${displayName}";
var todayHours = "${todayHours}"; 
var todayHoursArr = todayHours.split(";");

var currentWeatherArr = currentWeather.split(";");

//현재 날씨를 잘라서 각각 넣어줌
var currentIcon = currentWeatherArr[0];
var currentMain = currentWeatherArr[1];
var currentTemp = currentWeatherArr[2];
var currentHumidity = currentWeatherArr[3];
var currentClouds = currentWeatherArr[4];
var currentWind = currentWeatherArr[5];

//오늘 날씨를 잘라서  너줌 오늘날씨는 시간별 아이콘, 온도 두가지로 되어있음
var TodayWeatherArr = todayWeather.split("!");

var today1Arr = TodayWeatherArr[0].split(";");
var today2Arr = TodayWeatherArr[1].split(";");
var today3Arr = TodayWeatherArr[2].split(";");
var today4Arr = TodayWeatherArr[3].split(";");
var today5Arr = TodayWeatherArr[4].split(";");

var today1Icon = today1Arr[0];
var today1Temp = today1Arr[1];
var today1Time = todayHoursArr[0];

var today2Icon = today2Arr[0];
var today2Temp = today2Arr[1];
var today2Time = todayHoursArr[1];

var today3Icon = today3Arr[0];
var today3Temp = today3Arr[1];
var today3Time = todayHoursArr[2];

var today4Icon = today4Arr[0];
var today4Temp = today4Arr[1];
var today4Time = todayHoursArr[3];

var today5Icon = today5Arr[0];
var today5Temp = today5Arr[1];
var today5Time = todayHoursArr[4];

$(document).ready(function(){
	console.log(todayHoursArr)
	$("#currentIcon").attr("src", "/images/ezNewPortal/weather/" + currentIcon + ".png");
	$("#mainWeather").text(currentMain);
	
	//온도가 소수점단위로 들어오므로 소수점 아래는 잘라줌
	if (currentTemp.indexOf(".") == -1) {
		$("#currentTemp").text(currentTemp);
	} else {
		$("#currentTemp").text(currentTemp.substring(0,currentTemp.indexOf(".")));
	}
	$("#currentHumidity").text(currentHumidity);
	$("#currentClouds").text(currentClouds);
	$("#currentWind").text(currentWind);
	
	$("#icon1").attr("src", "/images/ezNewPortal/weather/" + today1Icon + ".png");
	$("#icon2").attr("src", "/images/ezNewPortal/weather/" + today2Icon + ".png");
	$("#icon3").attr("src", "/images/ezNewPortal/weather/" + today3Icon + ".png");
	$("#icon4").attr("src", "/images/ezNewPortal/weather/" + today4Icon + ".png");
	$("#icon5").attr("src", "/images/ezNewPortal/weather/" + today5Icon + ".png");
	
	if (today1Temp.indexOf(".") == -1) {
		$("#temp1").text(today1Temp);
	} else {
		$("#temp1").text(today1Temp.substring(0,today1Temp.indexOf(".")));
	}
	
	if (today2Temp.indexOf(".") == -1) {
		$("#temp2").text(today2Temp);
	} else {
		$("#temp2").text(today2Temp.substring(0,today2Temp.indexOf(".")));
	}
	
	if (today3Temp.indexOf(".") == -1) {
		$("#temp3").text(today3Temp);
	} else {
		$("#temp3").text(today3Temp.substring(0,today3Temp.indexOf(".")));
	}
	
	if (today4Temp.indexOf(".") == -1) {
		$("#temp4").text(today4Temp);
	} else {
		$("#temp4").text(today4Temp.substring(0,today4Temp.indexOf(".")));
	}
	
	if (today5Temp.indexOf(".") == -1) {
		$("#temp5").text(today5Temp);
	} else {
		$("#temp5").text(today5Temp.substring(0,today5Temp.indexOf(".")));
	}
	
	$("#date1").text(today1Time);
	$("#date2").text(today2Time);
	$("#date3").text(today3Time);
	$("#date4").text(today4Time);
	$("#date5").text(today5Time);
	
	//도시목록을 셀렉트박스로 만들어줌
	for (var i = 0; i < cityList.length; i++) {
		$("#cityList").append("<option value='" + cityList[i].cityCode + "'>" + cityList[i].displayName + "</option>");
	}
	
	$("#cityList").val(cityCode).prop("selected", true);	
});


$(function(){
	//셀렉트박스 onchange
	$("#cityList").change(function(){
    	$.ajax({
    		type : "POST",
    		dataType : "json",
    		async : false,
    		url : "/ezNewPortal/weatherPortletChange.do",
    		data : {
    			cityCode : this.value
    		},
    		success: function(data) {		
    			
    			$("#cityName").text(data.displayName);
    			
    			currentWeatherArr = data.currentWeather.split(";");
    			
    			currentIcon = currentWeatherArr[0];
    			currentMain = currentWeatherArr[1];
    			currentTemp = currentWeatherArr[2];
    			currentHumidity = currentWeatherArr[3];
    			currentClouds = currentWeatherArr[4];
    			currentWind = currentWeatherArr[5];
    			
    			todayHoursArr = data.todayHours.split(";");
    			
    			$("#currentIcon").attr("src", "/images/ezNewPortal/weather/" + currentIcon + ".png");
    			$("#mainWeather").text(currentMain);
    			if (currentTemp.indexOf(".") == -1) {
    				$("#currentTemp").text(currentTemp);
    			} else {
    				$("#currentTemp").text(currentTemp.substring(0,currentTemp.indexOf(".")));
    			}
    			
    			$("#currentHumidity").text(currentHumidity);
    			$("#currentClouds").text(currentClouds);
    			$("#currentWind").text(currentWind);
    			
    			TodayWeatherArr = data.todayWeather.split("!");

    			today1Arr = TodayWeatherArr[0].split(";");
    			today2Arr = TodayWeatherArr[1].split(";");
    			today3Arr = TodayWeatherArr[2].split(";");
    			today4Arr = TodayWeatherArr[3].split(";");
    			today5Arr = TodayWeatherArr[4].split(";");

    			today1Icon = today1Arr[0];
    			today1Temp = today1Arr[1];
    			today1Time = todayHoursArr[0];

    			today2Icon = today2Arr[0];
    			today2Temp = today2Arr[1];
    			today2Time = todayHoursArr[1];

    			today3Icon = today3Arr[0];
    			today3Temp = today3Arr[1];
    			today3Time = todayHoursArr[2];

    			today4Icon = today4Arr[0];
    			today4Temp = today4Arr[1];
    			today4Time = todayHoursArr[3];

    			today5Icon = today5Arr[0];
    			today5Temp = today5Arr[1];
    			today5Time = todayHoursArr[4];
    			
    			$("#icon1").attr("src", "/images/ezNewPortal/weather/" + today1Icon + ".png");
    			$("#icon2").attr("src", "/images/ezNewPortal/weather/" + today2Icon + ".png");
    			$("#icon3").attr("src", "/images/ezNewPortal/weather/" + today3Icon + ".png");
    			$("#icon4").attr("src", "/images/ezNewPortal/weather/" + today4Icon + ".png");
    			$("#icon5").attr("src", "/images/ezNewPortal/weather/" + today5Icon + ".png");
    			
    			if (today1Temp.indexOf(".") == -1) {
    				$("#temp1").text(today1Temp);
    			} else {
    				$("#temp1").text(today1Temp.substring(0,today1Temp.indexOf(".")));
    			}
    			
    			if (today2Temp.indexOf(".") == -1) {
    				$("#temp2").text(today2Temp);
    			} else {
    				$("#temp2").text(today2Temp.substring(0,today2Temp.indexOf(".")));
    			}
    			
    			if (today3Temp.indexOf(".") == -1) {
    				$("#temp3").text(today3Temp);
    			} else {
    				$("#temp3").text(today3Temp.substring(0,today3Temp.indexOf(".")));
    			}
    			
    			if (today4Temp.indexOf(".") == -1) {
    				$("#temp4").text(today4Temp);
    			} else {
    				$("#temp4").text(today4Temp.substring(0,today4Temp.indexOf(".")));
    			}
    			
    			if (today5Temp.indexOf(".") == -1) {
    				$("#temp5").text(today5Temp);
    			} else {
    				$("#temp5").text(today5Temp.substring(0,today5Temp.indexOf(".")));
    			}
    			
    			$("#date1").text(today1Time);
    			$("#date2").text(today2Time);
    			$("#date3").text(today3Time);
    			$("#date4").text(today4Time);
    			$("#date5").text(today5Time);
	        },
	        error: function(error) {
	        	alert(error);
	        }
    	});	
	});
});
</script>
</head>
<body>
<<<<<<< HEAD
<div class="layDiv">
	<dl class="portlet_title sortablePortlet">
		<dt class="portletText">오늘의날씨 </dt> <!-- <span id="cityName">${displayName}</span> -->

		<dd class="portletPlus" style="margin-right:10px">
			<select id="cityList">
			</select>
		</dd>
	</dl>
</div>
<div style="heigth:100%">
	<div style="float:left;width:34%;height:90px;display: inline-block;text-align:center">
		<img id="currentIcon" src="" style="width:80%;height:80%;margin-top:5%"/>
	</div>
	<div style="float:left;width:33%;height:90px;display: inline-block;text-align:center" >
		<span style="display:block;margin-top:15%" id="mainWeather">없음</span>
		<span style="display:block"><span id="currentTemp">0</span><span>˚C</span></span>
	</div>
	<div style="float:left;width:33%;height:90px;display: inline-block;text-align:center">
		<span style="display:block;margin-top:10%">습도 <span id="currentHumidity">0</span><span> %</span></span>
		<span style="display:block">구름 <span id="currentClouds">0</span><span> %</span></span>
		<span style="display:block">바람 <span id="currentWind">0</span><span> m/s</span></span>
	</div>
	<div style="float:left;width:100%;display: inline-block;">
		<div style="float:left;width:20%;height:90px;display: inline-block;">
			<div style="text-align:center"><span id="date1"></span><span>시</span></div>
			<div id="weather1" style="text-align:center">
				<img id="icon1" src="" style="width:60%;height:60%; "/>
			</div>
			<div style="text-align:center">
				<span style="display:block"><span id="temp1">0</span><span>˚C</span></span>
			</div>
		</div>
		<div style="float:left;width:20%;height:90px;display: inline-block;">
			<div style="text-align:center"><span id="date2"></span><span>시</span></div>
			<div id="weather2" style="text-align:center">
				<img id="icon2" src="" style="width:60%;height:60%; "/>
			</div>
			<div style="text-align:center">
				<span style="display:block"><span id="temp2">0</span><span>˚C</span></span>
			</div>
		</div>
		<div style="float:left;width:20%;height:90px;display: inline-block;">
			<div style="text-align:center"><span id="date3"></span><span>시</span></div>
			<div id="weather3" style="text-align:center">
				<img id="icon3" src="" style="width:60%;height:60%; "/>
			</div>
			<div style="text-align:center">
				<span style="display:block"><span id="temp3">0</span><span>˚C</span></span>
			</div>
		</div>
		<div style="float:left;width:20%;height:90px;display: inline-block;">
			<div style="text-align:center"><span id="date4"></span><span>시</span></div>
			<div id="weather4" style="text-align:center">
				<img id="icon4" src="" style="width:60%;height:60%; "/>
			</div>
			<div style="text-align:center">
				<span style="display:block"><span id="temp4">0</span><span>˚C</span></span>
			</div>
		</div>
		<div style="float:left;width:20%;height:90px;display: inline-block;">
			<div style="text-align:center"><span id="date5"></span><span>시</span></div>
			<div id="weather5" style="text-align:center">
				<img id="icon5" src="" style="width:60%;height:60%; "/>
			</div>
			<div style="text-align:center">
				<span style="display:block"><span id="temp5">0</span><span>˚C</span></span>
			</div>
		</div>
	</div>
	<div style="text-align:right;width:100%;height:15px;display:inline-block;margin-top:5px">
		<span style="font-size:9px;margin-right:3px;margin-top:3px;width:100%">Weather from OpenWeatherMap </span>
	</div>
</div>
</body>
</html>
