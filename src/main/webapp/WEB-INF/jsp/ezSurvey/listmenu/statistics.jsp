<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="${util.addVer('ezSurvey.css', 'msg')                      }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezSurvey/survey.css')                 }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')                       }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/demos.css')        }">
		<style type="text/css">
		</style>
	</head>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/statistic/raphael-min.js')}"></script>
	<script src="${util.addVer('/js/ezSurvey/statistic/g.raphael.js')}" type="text/javascript" charset="utf-8"></script>
	<script src="${util.addVer('/js/ezSurvey/statistic/g.pie.js')}" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript">
		$(function() {
			var data  = [90, 97, 28, 1];
			var data2 = ["Chrome - %%.%%", "IE - %%.%%", "Other - %%.%%", "Test - %%.%%"];
			
			var r = Raphael("respondentPie"),
			pie = r.piechart(180, 120, 100, data, { legend: data2, legendpos: "east" });
			
			pie.hover(function () {
				this.sector.stop();
				if (this.sector.matrix.a < 1.05)
					this.sector.scale(1.1, 1.1, this.cx, this.cy);
				
				if (this.label) {
					this.label[0].stop();
					this.label[0].attr({ r: 7.5 });
					this.label[1].attr({ "font-weight": 800 });
				}
			}, function () {
				this.sector.animate({ transform: 's1 1 ' + this.cx + ' ' + this.cy }, 500, "bounce");
				if (this.label) {
					this.label[0].animate({ r: 5 }, 500, "bounce");
					this.label[1].attr({ "font-weight": 400 });
				}
			});
		});
	</script>
	<body class="statBody">
		<div class="surveyCrtTt3">
			<div class="sryFirst2"></div>
			<div class="sryTxt"><spring:message code='ezSurvey.t34'/></div>
			<img src="/images/ezSurvey/partiCount.png">
			<span>15</span>
		</div>
		
		<div id="contentsBox">
			<div id="surveyRespondents" style="height: 240px; position: relative;">
				<div style="position: absolute; top: 10px; right: 10px; padding: 8px;">총 44 명</div>
				<div id="respondentPie" style="height: 100%;"></div>
			</div>
		</div>
	</body>
</html>