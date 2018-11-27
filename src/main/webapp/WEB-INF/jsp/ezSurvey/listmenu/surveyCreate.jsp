<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezSurvey.t34"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="${util.addVer('ezSurvey.css', 'msg')                      }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezSurvey/survey.css')                 }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')                       }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/demos.css')        }">
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}   "></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.js')     }   "></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/jquery.ddslick.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezSurvey.lang', 'msg')}              "></script>
	</head>
	
	<body class="mainbody srvey">
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
		
		<div id="bodyPanel">
			<div id="tab1" class="select-tab">
				<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/surveyInfomation.jsp"></jsp:include>
			</div>
			<div id="tab2" class="hidden-tab">
				<jsp:include page="/WEB-INF/jsp/ezSurvey/listmenu/questionCreate.jsp"></jsp:include>
			</div>
			<div id="tab3" class="hidden-tab">
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
				
				initEvents();
				
				function initEvents() {
					window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
					document.getElementById("selectTarget" ).addEventListener("change", toggleSelectTargetBttn, false);
					document.getElementById("targetBttn"   ).addEventListener("click" , showSelectPopUp       , false);
					document.getElementById("gotoSecondTab").addEventListener("click" , gotoSecondStep        , false);
					document.getElementById("cancelSurvey1").addEventListener("click" , cancleThisSurvey      , false);
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
					
					var listTabElmt = document.getElementsByClassName("headpanel")[0].children;
					for (var i = 0, len = listTabElmt.length; i < len; i++) {
						var tabElmt            = listTabElmt[i];
						var spanElmt           = tabElmt.querySelector("span[class='arrow']");
						tabElmt.onclick        = (function(idx, elmt) {return function() {selectStep(idx, elmt);}; })(i + 1, tabElmt);
						spanElmt.onclick       = (function(idx, elmt) {return function() {selectStep(idx, elmt);}; })(i + 1, tabElmt);
					}
				}
				
				function cancleThisSurvey() {/* Add function later */}
				
				function gotoSecondStep() {
					var listTabElmt          = document.getElementsByClassName("headpanel")[0].children;
					listTabElmt[0].className = "crust";
					listTabElmt[1].className = "crust selected";
					document.getElementById("tab1").className = "hidden-tab";
					document.getElementById("tab2").className = "select-tab";
				}
				
				function selectStep(tabIdx, spanElemt) {
					var crrSpan = document.querySelector("span[class='crust selected']");
					if (crrSpan == spanElemt) {return;}
					
					spanElemt.className = "crust selected";
					crrSpan.className   = "crust";
					var tabElmt         = document.getElementById("tab" + tabIdx);
					var selectTab       = document.querySelector("div[class='select-tab']");
					tabElmt.className   = "select-tab";
					selectTab.className = "hidden-tab";
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
			
		$(function() {
				
			var questionFile = new QuestionFile();
				
			// 셀렉트 박스에 들어갈 질문 유형 데이터 
			var optionData = 
				[ { text : "질문 유형 선택",		value: 0, selected: true, 	description:"질문 유형 선택"											   },
			      { text : "단일선택", 		value: 1, selected: false, 	description:"단일선택", 		imageSrc: "/images/ezSurvey/radio.png" },
			      { text : "다중선택", 		value: 2, selected: false, 	description:"다중선택", 		imageSrc: "/images/ezSurvey/radio.png" },
			      { text : "행렬(단일선택)", 	value: 3, selected: false, 	description:"행렬(단일선택)", 	imageSrc: "/images/ezSurvey/radio.png" },
			      { text : "행렬(다중선택)",	value: 4, selected: false, 	description:"행렬(다중선택)", 	imageSrc: "/images/ezSurvey/radio.png" },
			      { text : "단답형", 			value: 5, selected: false, 	description:"단답형", 		imageSrc: "/images/ezSurvey/radio.png" },
			      { text : "문장형", 			value: 6, selected: false, 	description:"문장형", 		imageSrc: "/images/ezSurvey/radio.png" },
			      { text : "슬라이드", 		value: 7, selected: false, 	description:"슬라이드", 		imageSrc: "/images/ezSurvey/radio.png" },
			      { text : "순위", 			value: 8, selected: false, 	description:"순위", 			imageSrc: "/images/ezSurvey/radio.png" },
			      { text : "드롭다운", 		value: 9, selected: false, 	description:"드롭다운", 		imageSrc: "/images/ezSurvey/radio.png" }];
			
			// make question form
			createQuestiobDiv();
			
			// 질문 및 질문 유형 선택하는 부분 생성
			function createQuestiobDiv() {
				
				var html = "";
				
				html += "<div class='quesDiv'>";
				html += "<input class='questnTitle'>";
				html += "<img alt='파일첨부' src='/images/ezSurvey/attach.png' class='atchImg'>";
				html += "<input type='file' class='attachFile' multiple='multiple' >";
				html += "<div id='selectBox'></div>";
				
				$(".quesBacgr").html(html);
				
				createQuestionSelectBox();
			}
			
			// 질문 유형을 선택하는 셀렉트 박스 생성
			function createQuestionSelectBox() {
				
				$("#selectBox").ddslick({
					data :optionData,
					imagePosition: "left",
					selectText: "질문 유형 선택",
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
			
			// 생성된 질문을 붙일 부분과 
			// 질문 유형을 파라미터로 받아 질문 영역 생성
			function makeSelectQuestion(grandParent, questionType) {
				
				var html = "";
				
					html += "<div class='selection' questionType='" + questionType + "'>";
				
					html += "<div class='optPart'>";
					
					html += "<div class='optRow'>";
					
					html += "<div class='option'>";
					html += "<input class='textInput' type='text'>";
					html += "<img src='/images/ezSurvey/attach.png' class='attImg'>"; 
					html += "<input class='fileInput' type='file'>";
					html += "<img src='/images/ezSurvey/minus.jpg' class='delImg'>";
					html += "</div>";
						
					html += "<div class='optFileInfo'>";
					html += "<div>";
					html += "<ul></ul>";
					html += "</div>";
					html += "</div>";
					
					html += "</div>";
					
					html += "<div class='optAtt'>";
					html += "<input type='file' class='optionFile' style='display:none;'/>";
					html += "</div>";
					
					html += "</div>";
				
					html += "<div class='additionalPart'>";
				
					html += "<div class='addBtns'>";
					html += "<button class='addRow'>추가</button>";
					html += "<button class='addOther'>기타추가</button>";
					html += "</div>";
					
					html += "<div class='required'>";
					html += "<input type='checkbox' name='checkbox'>";
					html += "<strong>필수 답변</strong>";
					html += "</div>";
					
					html += "<div class='btns'>";
					html += "<button class='save'>저장</button>";
					html += "<button class='cancel'>취소</button>";
					html += "</div>";
					
				// 셀렉트 박스에 들어갈 질문 유형 데이터 
				var optionData = 
					[{ text : SurveyMessages.strQselect , value: 0, selected: true , description: SurveyMessages.strQselect                                         },
					 { text : SurveyMessages.strSlOne   , value: 1, selected: false, description: SurveyMessages.strSlOne   , imageSrc: "/images/ezSurvey/radio.png"},
					 { text : SurveyMessages.strSlMtp   , value: 2, selected: false, description: SurveyMessages.strSlMtp   , imageSrc: "/images/ezSurvey/radio.png"},
					 { text : SurveyMessages.strTblOne  , value: 3, selected: false, description: SurveyMessages.strTblOne  , imageSrc: "/images/ezSurvey/radio.png"},
					 { text : SurveyMessages.strTblMtp  , value: 4, selected: false, description: SurveyMessages.strTblMtp  , imageSrc: "/images/ezSurvey/radio.png"},
					 { text : SurveyMessages.strShortQs , value: 5, selected: false, description: SurveyMessages.strShortQs , imageSrc: "/images/ezSurvey/radio.png"},
					 { text : SurveyMessages.strLongQs  , value: 6, selected: false, description: SurveyMessages.strLongQs  , imageSrc: "/images/ezSurvey/radio.png"},
					 { text : SurveyMessages.strSlider  , value: 7, selected: false, description: SurveyMessages.strSlider  , imageSrc: "/images/ezSurvey/radio.png"},
					 { text : SurveyMessages.strRanking , value: 8, selected: false, description: SurveyMessages.strRanking , imageSrc: "/images/ezSurvey/radio.png"},
					 { text : SurveyMessages.strDropdown, value: 9, selected: false, description: SurveyMessages.strDropdown, imageSrc: "/images/ezSurvey/radio.png"}];
				
				// make question form
				createQuestiobDiv();
				
				// 질문 및 질문 유형 선택하는 부분 생성
				function createQuestiobDiv() {
					var html  = "";
						html += "<div class='quesDiv'>";
						html += "<input class='questnTitle'>";
						html += "<img alt='파일첨부' src='/images/ezSurvey/attach.png' class='atchImg'>";
						html += "<input type='file' class='attachFile' multiple='multiple' >";
						html += "<div id='selectBox'></div>";
					
					$(".quesBacgr").html(html);
					createQuestionSelectBox();
				}
				
				// 질문 유형을 선택하는 셀렉트 박스 생성
				function createQuestionSelectBox() {
					$("#selectBox").ddslick({
						data :optionData,
						imagePosition: "left",
						selectText: "질문 유형 선택",
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
				
				// 보기 추가
				$(".addRow").click(function() {
					
					var thisEl = $(this).parents(".selection");
					
					var html = "";
						html += "<div class='optPart'>";
						
						html += "<div class='optRow'>";
						
						html += "<div class='option'>";
						html += "<input class='textInput' type='text'>";
						html += "<img src='/images/ezSurvey/attach.png' class='attImg'>"; 
						html += "<input class='fileInput' type='file'>";
						html += "<img src='/images/ezSurvey/minus.jpg' class='delImg'>";
						html += "</div>";
							
						html += "<div class='optFileInfo'>";
						html += "<div>";
						html += "<ul></ul>";
						html += "</div>";
						html += "</div>";
						
						html += "</div>";
						
						html += "<div class='optAtt'>";
						html += "<input type='file' class='optionFile' style='display:none;'/>";
						html += "</div>";
						
						html += "</div>";
					
						thisEl.find(".optPart").last().after(html);
					
				});
				
				// 기타 추가
				$(".addOther").click(function() {
					
					var thisEl = $(this).parents(".selection");

					var other = thisEl.find(".other")
					
					if (other.length == 0) {
						var html = "";
							
							html += "<div class='other'>";
							
							html += "<div class='optRow'>";
							
							html += "<div class='option'>";
							html += "<input class='textInput' type='text' placeholder='기타'>";
							html += "<img src='/images/ezSurvey/attach.png' class='attImg'>"; 
							html += "<input class='fileInput' type='file'>";
							html += "<img src='/images/ezSurvey/minus.jpg' class='delImg'>";
							html += "</div>";
								
							html += "<div class='optFileInfo'>";
							html += "<div>";
							html += "<ul></ul>";
							html += "</div>";
							html += "</div>";
							
							html += "</div>";
							
							html += "<div class='optAtt'>";
							html += "<input type='file' class='optionFile' style='display:none;'/>";
							html += "</div>";
							
							html += "</div>";
						
						thisEl.find(".optPart").last().after(html);
						
					} else {
						alert("기타는 하나만 추가 가능합니다.");
					}
				});
				
				// 보기, 기타 삭제
				$(".quesBacgr").on("click", ".delImg", function() {
					
					var thisEl = $(this);
					
					var optLength = thisEl.parents(".selection").find(".optPart").length;
					var othLength = thisEl.parents(".selection").find(".other").length;
					
					var totLength = optLength + othLength;
					// 보기와 기타의 합계가 2개 이상일 때만 삭제
					if (totLength > 2) {
						if (thisEl.parents(".optPart").length == 1) {
							thisEl.parents(".optPart").remove();
							
						} else {
							thisEl.parents(".other").remove();
						}
					} else {
						alert("최소 2개 이상의 보기가 필요합니다.");
					}
				});
				
				// option 첨부파일 트리거
				$(".quesBacgr").on("click", ".attImg", function() {
					$(this).parents(".optRow").next().find(".optionFile").click();
				});
				
				// option 첨부파일 추가
				$(".quesBacgr").on("change", ".optionFile", function (e) {
					var thisEl = $(this);
					var thisFile = $(this)[0].files;
					fileUpload(thisEl, thisFile);
				});
				
				// 질문과 보기의 모든 내용 임시 저장
				$(".save").click(function(event) {
					var questionType = parseInt($(this).parents(".selection").attr("questiontype"));
					
					// 기타 버튼 클릭시 기타 추가 이벤트
					$(".addOther").click(function() {
						
						var element = $(this).parent().parent().parent();
	
						var other = element.find(".optionPart").find(".other");
						
						if (other.length == 0) {
							
							var html = "";
							html += "<div class='other'>";
							html += "<input class='textInput' type='text' placeholder='기타'>";
							html += "<img src='/images/ezSurvey/attach.png' class='attachImg' onclick='optTrigger();'>";
							html += "<img src='/images/ezSurvey/minus.jpg' class='deleteOption' onclick='deleteEvent(this);'>";
							html += "</div>";
							
							element.find(".optionPart").append(html);
						} else {
							alert("기타는 하나만 추가 가능합니다.");
						}
					});
					
					// 질문과 보기의 모든 내용 임시 저장
					$(".save").click(function(event) {
						var questionType = parseInt($(this).parents(".selection").attr("questiontype"));
						
						if (questionType == 1) {
							var optionPart = $(this).parents(".optionPart").find(".option");
							console.log("콘솔");
							var additional = $(this).parents(".additionalPart");
							
							var requiedVal = additional.find("input[name=checkbox]").is(":checked")
							
							console.log(optionPart);
							var question = {};
							
							for (var i = 0; i < optionPart.length; i++) {
								var option = {};
								// 보기의 내용
								var contents = optionPart[i].childNodes[0].value;
								
								option['content'] = contents;
								
								question['option' + i] = option;
								question['questionType'] = questionType;
								
								if (requiedVal == true) {
									question['requied'] = "1";
									
								} else {
									question['requied'] = "0";
								}
							}
							console.log(question);
						}
					});
					
					var optionList = document.getElementsByClassName("optionAttach");
					for (var i = 0, len = optionList.length; i < len; i++) {
						optionList[i].onchange = function(e) {fileUpload();};
					}
				});
				
			}
			
			// option 첨부파일
			function fileUpload(thisEl, thisFile) {
				questionFile.upload(thisEl, thisFile);
			}
		}());
		
		</script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/questionFile.js')}"></script>
	</body>
</html>