<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezSurvey.t34"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<<<<<<< HEAD
		<link rel="stylesheet" href="${util.addVer('ezSurvey.css', 'msg')}"       type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezSurvey/survey.css')}"  type="text/css">
	</head>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/jquery.ddslick.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	
	
	<body class="surveyBody">
=======
		<link rel="stylesheet" type="text/css" href="${util.addVer('ezSurvey.css', 'msg')                      }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezSurvey/survey.css')                 }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')                       }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/demos.css')        }">
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.js')     }"></script>
		<script type="text/javascript">
			$(function() {
				
				$(".quesTypeSelect").click(function() {
					$(".option_wrap").show().animate({height: "300px"});
				});
				
				$(".select_op").mouseleave(function() {
					$(".option_wrap").hide();
					$(".option_wrap").css("height", "0");
				});
				
				$(".atchImg").click(function(e) {
					var clickObj = $(this).next();
					clickObj.click();
				});
				
				$(".sryTxt").click(function() {
					window.open("/ezSurvey/statisticsPage.do", "", GetOpenWindowfeature(500, 500));
				});
				 
			});
		</script>
	</head>
	
	<body class="mainbody srvey">
>>>>>>> 0fa95b5ad9e4c0681b32c07855be7b70f2f28419
		<div class="surveyCrtTtl">
			<div class="sryFirst"></div>
			<div class="sryTxt"><spring:message code='ezSurvey.t34'/></div>
		</div>
		
		<div class="headpanel">
			<span class="crust selected">
				<a class="crumb" id="survTab1"><span><spring:message code='ezSurvey.t35'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
			<span class="crust">
				<a class="crumb" id="survTab2"><span><spring:message code='ezSurvey.t36'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
			<span class="crust">
				<a class="crumb" id="survTab3"><span><spring:message code='ezSurvey.t37'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
		</div>
		
		<div id="bodyPanel">
			<div id="tab1">
				<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/surveyInfomation.jsp"></jsp:include>
			</div>
			<div id="tab2">
				<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/questionCreate.jsp"></jsp:include>
			</div>
			<div id="tab3">
			</div>
		</div>

<%-- 		<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/surveyInfomation.jsp"></jsp:include> --%>
		<script type="text/javascript">
			var SurveyCreate    = function() {
				var selectPopup = null;
				var surveyObj   = {
					info : {},
					questions : []
				};
				
				// 클릭한 tab 열기
				$("#survTab1, #survTab2, #survTab3").click(function() {
					
					$(this).parent().siblings().removeClass("selected")
					$(this).parent().addClass("selected");
					
					var tabNum = $(this).attr("id").replace("survTab", "");
					$("#tab" + tabNum).siblings().css("display", "none");
					$("#tab" + tabNum).css("display", "");
					
				});
				
				// make question form
				createQuesDiv();
				
				initEvents();
				
				function initEvents() {
					window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
					document.getElementById("selectTarget").addEventListener("change", toggleSelectTargetBttn, false);
					document.getElementById("targetBttn"  ).addEventListener("click" , showSelectPopUp       , false);
					var today = new Date();
					
					$("#startDate").datepicker({
						changeMonth: true,
						changeYear: true,
						autoSize: true,
						showOn: "both",
						buttonImage: "/images/ImgIcon/calendar-month.gif",
						buttonImageOnly: true,
						dateFormat: "yy-mm-dd"
					});
					
					$("#endDate").datepicker({
						changeMonth: true,
						changeYear: true,
						autoSize: true,
						showOn: "both",
						buttonImage: "/images/ImgIcon/calendar-month.gif",
						buttonImageOnly: true,
						dateFormat: "yy-mm-dd"
					});
					
					$("#startDate").datepicker("setDate", today);
					$("#endDate").datepicker("setDate", today);
				}
				
				function toggleSelectTargetBttn() {
					var sltBoxElmt       = document.getElementById("selectTarget");
					var targetBttn       = document.getElementById("targetBttn");
					var sltedIdx         = sltBoxElmt.selectedIndex;
					targetBttn.className = sltedIdx == 0 ? "target-select" : "target-select on";
				}
				
				function getOpenWindowfeature(popUpW, popUpH) {
					var heigth   = window.screen.availHeight;
					var width    = window.screen.availWidth;
					var left     = 0;
					var top      = 0;
					var pleftpos = parseInt(width) - popUpW;
					heigth       = parseInt(heigth) - popUpH;
					left         = pleftpos / 2;
					top          = heigth / 2;
					var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=1, scrollbars=yes";
					return feature;
				}
				
				function showSelectPopUp() {selectPopup = window.open("/ezSurvey/selectUsers.do", "selectUser", getOpenWindowfeature(1125, 700));}
				function closeAllPopups() {if(selectPopup) {selectPopup.close();}}
				function getSurveyUsers() {return surveyObj["info"]["users"];}
				function setSurveyUsers(userList) {surveyObj["info"]["users"] = userList;}
				
				return {
					getUsers : getSurveyUsers,
					setUsers : setSurveyUsers,
				};
			}();
		</script>
		
	</body>
</html>