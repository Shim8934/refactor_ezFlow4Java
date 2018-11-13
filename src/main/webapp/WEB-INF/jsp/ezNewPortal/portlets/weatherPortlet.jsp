<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.orbit-1.2.3.min.js')}"></script>
<link href="css/default_kr.css" rel="stylesheet" type="text/css">
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
	$("#currentIcon").attr("src", "/images/ezNewPortal/weather/" + "weatherIcon" +  currentIcon.substring(0,2) + ".png");
	$("#mainWeather").text(currentMain);
	
	$("#humidity").text("습도 ");
	$("#clouds").text("구름 ");
	$("#wind").text("바람 ");
	
	$(".weatherPerLi").show();
	$(".weather_mini").show();
	
	$("#humidityPer").text("%");
	$("#cloudsPer").text("%");
	$("#windPer").text("m/s");
	
	//온도가 소수점단위로 들어오므로 소수점 아래는 잘라줌
	if (currentTemp.indexOf(".") == -1) {
		$("#currentTemp").text(currentTemp + "℃");
	} else {
		$("#currentTemp").text(currentTemp.substring(0,currentTemp.indexOf(".") + 2) + "℃");
	}
	$("#currentHumidity").text(currentHumidity);
	$("#currentClouds").text(currentClouds);
	$("#currentWind").text(currentWind);
	
	$("#icon1").attr("src", "/images/ezNewPortal/weather/" + "weatherIcon_mini" +  today1Icon.substring(0,2) + ".png");
	$("#icon2").attr("src", "/images/ezNewPortal/weather/" + "weatherIcon_mini" +  today2Icon.substring(0,2) + ".png");
	$("#icon3").attr("src", "/images/ezNewPortal/weather/" + "weatherIcon_mini" +  today3Icon.substring(0,2) + ".png");
	$("#icon4").attr("src", "/images/ezNewPortal/weather/" + "weatherIcon_mini" +  today4Icon.substring(0,2) + ".png");
	$("#icon5").attr("src", "/images/ezNewPortal/weather/" + "weatherIcon_mini" +  today5Icon.substring(0,2) + ".png");
	
	if (today1Temp.indexOf(".") == -1) {
		$("#temp1").text(today1Temp + "℃");
	} else {
		$("#temp1").text(today1Temp.substring(0,today1Temp.indexOf(".") + 2) + "℃");
	}
	
	if (today2Temp.indexOf(".") == -1) {
		$("#temp2").text(today2Temp + "℃");
	} else {
		$("#temp2").text(today2Temp.substring(0,today2Temp.indexOf(".") + 2) + "℃");
	}
	
	if (today3Temp.indexOf(".") == -1) {
		$("#temp3").text(today3Temp + "℃");
	} else {
		$("#temp3").text(today3Temp.substring(0,today3Temp.indexOf(".") + 2) + "℃");
	}
	
	if (today4Temp.indexOf(".") == -1) {
		$("#temp4").text(today4Temp + "℃");
	} else {
		$("#temp4").text(today4Temp.substring(0,today4Temp.indexOf(".") + 2) + "℃");
	}
	
	if (today5Temp.indexOf(".") == -1) {
		$("#temp5").text(today5Temp + "℃");
	} else {
		$("#temp5").text(today5Temp.substring(0,today5Temp.indexOf(".") + 2) + "℃");
	}
	
	$("#date1").text(today1Time + "시");
	$("#date2").text(today2Time + "시");
	$("#date3").text(today3Time + "시");
	$("#date4").text(today4Time + "시");
	$("#date5").text(today5Time + "시");
	
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
    			
    			$("#currentIcon").attr("src", "/images/ezNewPortal/weather/" + "weatherIcon" +  currentIcon.substring(0,2) + ".png");
    			$("#mainWeather").text(currentMain);
    			if (currentTemp.indexOf(".") == -1) {
    				$("#currentTemp").text(currentTemp + "℃");
    			} else {
    				$("#currentTemp").text(currentTemp.substring(0,currentTemp.indexOf(".") + 2) + "℃");
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
    			
    			$("#icon1").attr("src", "/images/ezNewPortal/weather/" + "weatherIcon_mini" +  today1Icon.substring(0,2) + ".png");
    			$("#icon2").attr("src", "/images/ezNewPortal/weather/" + "weatherIcon_mini" +  today2Icon.substring(0,2) + ".png");
    			$("#icon3").attr("src", "/images/ezNewPortal/weather/" + "weatherIcon_mini" +  today3Icon.substring(0,2) + ".png");
    			$("#icon4").attr("src", "/images/ezNewPortal/weather/" + "weatherIcon_mini" +  today4Icon.substring(0,2) + ".png");
    			$("#icon5").attr("src", "/images/ezNewPortal/weather/" + "weatherIcon_mini" +  today5Icon.substring(0,2) + ".png");
    			
    			if (today1Temp.indexOf(".") == -1) {
    				$("#temp1").text(today1Temp + "℃");
    			} else {
    				
    				$("#temp1").text(today1Temp.substring(0,today1Temp.indexOf(".") + 2) + "℃");
    			}
    			
    			if (today2Temp.indexOf(".") == -1) {
    				$("#temp2").text(today2Temp + "℃");
    			} else {
    				$("#temp2").text(today2Temp.substring(0,today2Temp.indexOf(".") + 2) + "℃");
    			}
    			
    			if (today3Temp.indexOf(".") == -1) {
    				$("#temp3").text(today3Temp + "℃");
    			} else {
    				$("#temp3").text(today3Temp.substring(0,today3Temp.indexOf(".") + 2) + "℃");
    			}
    			
    			if (today4Temp.indexOf(".") == -1) {
    				$("#temp4").text(today4Temp + "℃");
    			} else {
    				$("#temp4").text(today4Temp.substring(0,today4Temp.indexOf(".") + 2) + "℃");
    			}
    			
    			if (today5Temp.indexOf(".") == -1) {
    				$("#temp5").text(today5Temp + "℃");
    			} else {
    				$("#temp5").text(today5Temp.substring(0,today5Temp.indexOf(".") + 2) + "℃");
    			}
    			
    			$("#date1").text(today1Time + "시");
    			$("#date2").text(today2Time + "시");
    			$("#date3").text(today3Time + "시");
    			$("#date4").text(today4Time + "시");
    			$("#date5").text(today5Time + "시");
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
<article class="weather box_shadow" style="background-color:#ffffff">
	<div class="layDiv">
    	<dl class="portlet_title sortablePortlet">
        	<dt class="portletText">오늘의날씨</dt>
            <dd class="portletPlus">
            	<select id="cityList" class="weatherSelect">
                </select>
            </dd>
        </dl>
        <div class="weather_content">
        	<div class="weather_title">
            	<dl class="weatherPresent">
                	<dt><img id="currentIcon" src=""></dt>
                    <dd><span id="mainWeather"></span> <span id="currentTemp"></span></dd>
                </dl>
                <ul class="weatherPer">
                	<li class="weatherPerLi"><span class="icon iconbg01"><img src="/images/ezNewPortal/weather/weatherIcon_add01.png"></span>
                	<span class="text"><span class="text" id="humidity"></span><span id="currentHumidity"></span><span class="text" id="humidityPer"></span></span></li>
                    <li class="weatherPerLi"><span class="icon iconbg02"><img src="/images/ezNewPortal/weather/weatherIcon_add02.png"></span>
                    <span class="text"><span class="text" id="clouds"></span><span id="currentClouds"></span><span class="text" id="cloudsPer"></span></span></li>
                    <li class="weatherPerLi"><span class="icon iconbg03"><img src="/images/ezNewPortal/weather/weatherIcon_add03.png"></span>
                    <span class="text"><span class="text" id="wind"></span><span id="currentWind"></span><span class="text" id="windPer"></span></span></li>
                </ul>
            </div>
            <div class="weather_mini" style="display:none">
            	<dl>
                	<dt><img id="icon1" src=""></dt>
                    <dd><span id="date1"></span><span id="temp1"></span></dd>
                </dl>
                <dl>
                	<dt><img id="icon2" src=""></dt>
                    <dd><span id="date2"></span><span id="temp2"></span></dd>
                </dl>
                <dl>
                	<dt><img id="icon3" src=""></dt>
                    <dd><span id="date3"></span><span id="temp3"></span></dd>
                </dl>
                <dl>
                	<dt><img id="icon4" src=""></dt>
                    <dd><span id="date4"></span><span id="temp4"></span></dd>
                </dl>
                <dl>
                	<dt><img id="icon5" src=""></dt>
                    <dd><span id="date5"></span><span id="temp5"></span></dd>
                </dl>
            </div>
        </div>
    </div>
</article>
</body>
</html>
