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
	<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg')}                 "></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}      "></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/statistic/raphael-min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/statistic/g.raphael.js')}  "></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/statistic/g.pie.js')}      "></script>
	<script type="text/javascript">
		(function() {
			var colors = ["#e04343", "#f79f3f", "#a9cd40", "#00b4c8", "#898cff", "#ff89b5", "#ffdc89", "#90d4f7", "#71e096", "#f5a26f",
						  "#668de5", "#ed6d79", "#5ad0e5", "#da97e0", "#cff381", "#ff96e3", "#bb96ff", "#67eebd", "#fa9928", "#ef3924",
						  "#d41e47", "#4c64ae", "#01539c", "#f05f7c", "#00b3ca", "#bd8139", "#d9c622", "#4a2431", "#d41e47", "#eb148d"];
			var surveyStatistic = ${data};
			window.onload       = function() {test();};
			
			function test() {
				var values      = [];
				var lables      = [];
				var totalUsers  = parseInt(surveyStatistic["usersCnt"]);
				var respondents = parseInt(surveyStatistic["respondentCnt"]);
				values.push(totalUsers - respondents);
				values.push(respondents);
				lables.push(createChartStr(totalUsers - respondents, SurveyMessages.strUser3));
				lables.push(createChartStr(respondents, SurveyMessages.strUser3));
				
				document.getElementById("totalUserCnt").innerHTML     = totalUsers;
				document.getElementById("totalRespondents").innerHTML = SurveyMessages.strTotal + " " + totalUsers + SurveyMessages.strUser3;
				createPieChart(values, lables, "respondentPie", 1);
			}
			
			function createPieChart(values, lables, elmtId, moreValues) {
				var config = {legend: lables, legendpos: "east"};
				if (values.length <= 30) {config["colors"] = colors;}
				
				var r   = Raphael(elmtId);
				var pie = r.piechart(180, 120, 100, values, config);
				
				pie.hover(function () {
					this.sector.stop();
					if (this.sector.matrix.a < 1.05) {
						this.sector.scale(1.1, 1.1, this.cx, this.cy);
					}
					
					if (this.label) {
						this.label[0].stop();
						this.label[0].attr({ r: 10});
						this.label[1].attr({ "font-weight": 800 });
					}
				}, function () {
					this.sector.animate({ transform: 's1 1 ' + this.cx + ' ' + this.cy }, 500, "bounce");
					if (this.label) {
						this.label[0].animate({ r: 6}, 500, "bounce");
						this.label[1].attr({ "font-weight": 400 });
					}
				});
				
				if (moreValues) {
					for (var i = 0; i < values.length; i++) {
						pie.series.items[i]["value"]["test"] = {test1 : "aaa", test2 : "bbb"};
						console.log(pie.series.items[i]["value"]);
					}
					
					pie.click(function(){
						console.log(this.value);
						//showMoreDetail();
					});
				}
			}
			
			function showMoreDetail() {
				alert("Show more detail");
			}
			
			function createChartStr(value, string) {return value + " - %%.%% [" + value + string + "]";}
		})();
	</script>
	<body class="statBody">
		<div class="surveyCrtTt3">
			<div class="sryFirst2"></div>
			<div class="sryTxt"><spring:message code='ezSurvey.t34'/></div>
			<img src="/images/ezSurvey/partiCount.png">
			<span id="totalUserCnt">15</span>
		</div>
		
		<div id="contentsBox">
			<div id="surveyRespondents" style="height: 240px; position: relative; box-shadow: rgba(0, 0, 0, 0.69) 0px 1px 5px 0px; margin-bottom: 10px;">
				<div style="position: absolute; top: 0px; right: 0px; padding: 8px; font-size: 14px;" id="totalRespondents"></div>
				<div id="respondentPie" style="height: 100%;"></div>
			</div>
		</div>
	</body>
		<script type="text/javascript">
				/* function getSurveyStatistic() {
				$.ajax({
					type: "POST",
					url: "/ezSurvey/getSurveyStatistic.do",
					data: {},
					contentType: "application/json; charset=utf-8",
					dataType: "JSON",
					async: false,
					success : function(data) {
						afterGetSuccessfully(data);
					},
					error : function(error) {
						alert(SurveyMessages.strError);
					}
				});
			}
			
			function afterGetSuccessfully(data) {
				var code = data.code;
				switch(code) {
					case 0 : alert(SurveyMessages.strSaveDraft);
							 window.parent.frames["right"].location.href = "/ezSurvey/surveyList.do?mode=draft";
							 break;
					case 1 : alert(SurveyMessages.strParamErr) ; break;
					case 2 : alert(SurveyMessages.strError)    ; break;
					default: alert(SurveyMessages.strError)    ; return;
				}
			} */
	</script>
</html>