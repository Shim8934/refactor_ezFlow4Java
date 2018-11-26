<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezSurvey.t34"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezSurvey.css', 'msg')}"       type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezSurvey/survey.css')}"  type="text/css">
	</head>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<!-- <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
	<script type="text/javascript" src="https://cdn.rawgit.com/prashantchaudhary/ddslick/master/jquery.ddslick.min.js" ></script> -->
	<script type="text/javascript" src="${util.addVer('/js/ezSurvey/jquery.ddslick.min.js')}"></script>
	
	
	<body class="surveyBody">
		<div class="surveyCrtTtl">
			<div class="sryFirst"></div>
			<div class="sryTxt"><spring:message code='ezSurvey.t34'/></div>
		</div>
		
		<div class="headpanel">
			<span class="crust selected">
				<a class="crumb"><span><spring:message code='ezSurvey.t35'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
			<span class="crust">
				<a class="crumb"><span><spring:message code='ezSurvey.t36'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
			<span class="crust">
				<a class="crumb"><span><spring:message code='ezSurvey.t37'/></span></a>
				<span class="arrow"><span></span></span>
			</span>
		</div>
		
		<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/questionCreate.jsp"></jsp:include>
		<script type="text/javascript">
	$(function() {
		
		var question = {};
		
		$(".atchImg").click(function(e) {
			
			var clickObj = $(this).next();
			clickObj.click();
		});
		
		$(".sryTxt").click(function() {
			window.open("/ezSurvey/statisticsPage.do", "", GetOpenWindowfeature(500, 500));
		});

		createQuesDiv();
	});
	
	// 셀렉트 박스에 들어갈 질문 유형 데이터 
	var optionData = 
		[ { text : "--질문 유형 선택--",	value: 0, selected: true, 	description:"--질문 유형 선택--"},
	      { text : "단일선택", 		value: 1, selected: false, 	description:"단일선택", 		imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "다중선택", 		value: 2, selected: false, 	description:"다중선택", 		imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "행렬(단일선택)", 	value: 3, selected: false, 	description:"행렬(단일선택)", 	imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "행렬(다중선택)",	value: 4, selected: false, 	description:"행렬(다중선택)", 	imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "단답형", 			value: 5, selected: false, 	description:"단답형", 		imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "문장형", 			value: 6, selected: false, 	description:"문장형", 		imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "슬라이드", 		value: 7, selected: false, 	description:"슬라이드", 		imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "순위", 			value: 8, selected: false, 	description:"순위", 			imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "드롭다운", 		value: 9, selected: false, 	description:"드롭다운", 		imageSrc: "/images/ezSurvey/radio.png" },];
	
	// 질문 유형을 선택하는 셀렉트 박스 생성
	function createQuestionSelectBox() {
		
		$("#selectBox").ddslick({
			data :optionData,
			imagePosition: "left",
			selectText: "--질문 유형 선택--",
			onSelected: function(data) {

				var selectedEl = data.selectedItem;
				var grandParent = selectedEl.parent().parent().parent().parent();

				var questionType = data.selectedIndex;
				
				switch (questionType) {
					case 1:
						makeSelectQuestion(grandParent, questionType);
						break;
					case 2:
						
						break;
					case 3:
						
						break;
					case 4:
						
						break;
					case 5:
						
						break;
					case 6:
						
						break;
					case 7:
						
						break;
					case 8:
						
						break;
					case 9:
						
						break;
					
				}
				
					
				
			}
		});
	}
	
	// 질문 및 질문 유형 선택하는 부분 생성
	function createQuesDiv() {
		
		var html = "";
		
		html += "<div class='quesDiv'>";
		html += "<input class='questnTitle'>";
		html += "<img alt='파일첨부' src='/images/ezSurvey/attach.png' class='atchImg'>";
		html += "<input type='file' class='attachFile' multiple='multiple'>";
		html += "<div id='selectBox'></div>";
		html += "</div>";
		
		$(".quesBacgr").html(html);
		
		createQuestionSelectBox();
	}
	// 생성된 질문을 붙일 부분과 
	// 질문 유형을 파라미터로 받아 질문 영역 생성
	function makeSelectQuestion(grandParent, questionType) {
		
		var html = "";
		
			html += "<div class='selection' questionType='" + questionType + "'>";
		
			html += "<div class='optionPart'>";
			html += "<div class='option'>";
			html += "<input class='textInput' type='text'>";
			html += "<img src='/images/ezSurvey/attach.png' class='attachImg'>";
			html += "<input class='fileInput type=file' multiple='multiple'>";
			html += "<img src='/images/ezSurvey/minus.jpg' class='deleteOption' onclick='deleteEvent();'>";
			html += "</div>";
			html += "</div>";
		
			html += "<div class='additionalPart'>";
		
			html += "<div class='addBtns'>";
			html += "<button class='addRow'>추가</button>";
			html += "<button class='addOther'>기타추가</button>";
			html += "</div>";
			
			html += "<div class='required'>";
			html += "<input type='checkbox'>";
			html += "<strong>필수 답변</strong>";
			html += "</div>";
			
			html += "<div class='btns'>";
			html += "<button class='save'>저장</button>";
			html += "<button class='cancel'>취소</button>";
			html += "</div>";
			
			html += "</div>";
		
			html += "</div>";
			
		grandParent.append(html);
		
		addEvent();
	}
	
	
	function addEvent() {
		
		// 추가 버튼 클릭시 옵션 추가 이벤트
		$(".addRow").click(function(event) {
			
			var element = $(this).parent().parent().parent();
			
			var html = "";
			html += "<div class='option'>";
			html += "<input class='textInput' type='text'>";
			html += "<img src='/images/ezSurvey/attach.png' class='attachImg'> ";
			html += "<input class='fileInput type=file' multiple='multiple'>";
			html += "<img src='/images/ezSurvey/minus.jpg' class='deleteOption' onclick='deleteEvent();'>";
			html += "</div>";
			
			element.find(".option").last().after(html);
			
		});
		
		// 삭제 버튼 클릭시 옵션 삭제 이벤트
		/* $(".deleteOption").click(function() {
			var element = $(this).parent().parent().parent();

			var option = element.find(".optionPart").find(".option");
			console.log("옵션 개수: " + option.length );
			
			if (option.length > 2) {
				var option = $(this).parent();
				option.remove();
			
			} else {
				alert("보기는 2개 이상 필요합니다.");
			}
		}); */
		
		// 기타 버튼 클릭시 기타 추가 이벤트
		$(".addOther").click(function() {
			
			var element = $(this).parent().parent().parent();

			var other = element.find(".optionPart").find(".other");
			
			if (other.length == 0) {
				
				var html = "";
				html += "<div class='other'>";
				html += "<input class='textInput' type='text' placeholder='기타'>";
				html += "<img src='/images/ezSurvey/attach.png' class='attachImg'>";
				html += "<input class='fileInput type=file' multiple='multiple'>";
				html += "<img src='/images/ezSurvey/minus.jpg' class='deleteOption' onclick='deleteEvent();'>";
				html += "</div>";
				
				element.find(".optionPart").append(html);
			} else {
				alert("기타는 하나만 추가 가능합니다.");
			}
		});
		
	}
	
	function deleteEvent(e) {
		
		e.stopPropagation();
		
		// 삭제 버튼 클릭시 옵션 삭제 이벤트
		$(".deleteOption").click(function() {
			var element = $(this).parent().parent().parent();

			var option = element.find(".optionPart").find(".option");
			console.log("옵션 개수: " + option.length );
			
			if (option.length > 2) {
				var option = $(this).parent();
				option.remove();
			
			} else {
				alert("보기는 2개 이상 필요합니다.");
			}
		});
		
	}
	</script>

<%-- 		<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/surveyInfomation.jsp"></jsp:include> --%>
		<script type="text/javascript">
			(function() {
				var selectPopup = null;
				
				initEvents();
				
				function initEvents() {
					window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
					document.getElementById("selectTarget").addEventListener("change", toggleSelectTargetBttn, false);
					document.getElementById("targetBttn"  ).addEventListener("click" , showSelectPopUp       , false);
				}
				
				function toggleSelectTargetBttn() {
					var sltBoxElmt       = document.getElementById("selectTarget");
					var targetBttn       = document.getElementById("targetBttn");
					var sltedIdx         = sltBoxElmt.selectedIndex;
					targetBttn.className = sltedIdx == 0 ? "target-select" : "target-select on";
				}
				
				function showSelectPopUp() {
					selectPopup = window.open("/ezSurvey/selectUsers.do", "selectUser", getOpenWindowfeature(1125, 700));
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
				
				function closeAllPopups() {if(selectPopup) {selectPopup.close();}}
			})();
		</script>
		
	</body>
</html>