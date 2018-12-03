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
		<!-- 
		<ul>
			<li fname='' fsize='' path=''>
				<div class='attDivFile'>
					<img alt='' src='/images/survey/file_del.gif'>
					<div class='attImgAva'>
						<img alt='' src='파일경로'>
					</div>
					<div class='attFileInf'>
						<span title='파일이름'>파일이름</span>
						<span>사이즈</span>
					</div>
				</div>
			</li>
		</ul>
		 -->
		
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
				function getSurveyQuestions() {return surveyObj["questions"];}
				function setSurveyQuestions(question) {surveyObj["questions"].push(question);}
				function getSurveyUsers() {return surveyObj["info"]["users"];}
				function setSurveyUsers(userList) {surveyObj["info"]["users"] = userList;}
				
				return {
					getUsers : getSurveyUsers,
					setUsers : setSurveyUsers,
					getQs    : getSurveyQuestions,
					setQs    : setSurveyQuestions,
				};
			}();
			
		$(function() {
			// 원래 여기서 객체 생성해서 잘 됬었는데
			// 갑자기 배열에 푸시했던 기존 값도 변경된다.
			// 왜그럴까?
//			var question = {};

			var questionFile = new QuestionFile();
				
			// 셀렉트 박스에 들어갈 질문 유형 데이터 
			var optionData = 
				[{ text : SurveyMessages.strSlOne   , value: 1, selected: false, imageSrc: "/images/ezSurvey/radio.png"},
				 { text : SurveyMessages.strSlMtp   , value: 2, selected: false, imageSrc: "/images/ezSurvey/radio.png"},
				 { text : SurveyMessages.strTblOne  , value: 3, selected: false, imageSrc: "/images/ezSurvey/radio.png"},
				 { text : SurveyMessages.strTblMtp  , value: 4, selected: false, imageSrc: "/images/ezSurvey/radio.png"},
				 { text : SurveyMessages.strShortQs , value: 5, selected: false, imageSrc: "/images/ezSurvey/radio.png"},
				 { text : SurveyMessages.strLongQs  , value: 6, selected: false, imageSrc: "/images/ezSurvey/radio.png"},
				 { text : SurveyMessages.strSlider  , value: 7, selected: false, imageSrc: "/images/ezSurvey/radio.png"},
				 { text : SurveyMessages.strRanking , value: 8, selected: false, imageSrc: "/images/ezSurvey/radio.png"},
				 { text : SurveyMessages.strDropdown, value: 9, selected: false, imageSrc: "/images/ezSurvey/radio.png"}];
			
			// question input 및 img 생성
			createQuestiobDiv();
			
			addQstnEvent();
			// question selectBox 생성
			createQuestionSelectBox();
			
			addOptEvent();
			
			// question input 및 img 생성
			function createQuestiobDiv(qstnWrapper, question) {
				console.log(question);
				var html = "";
				
				if (question != undefined) {
					html += "<div class='qstnWrapper' id='" + question.id + "'>";
					
				} else {
					html += "<div class='qstnWrapper'>";
					
				}
				
				html += "<div class='quesDiv'>";
				
				html += "<div class='qstnRow'>";
				
				if (question != undefined) {
					html += "<input class='questnTitle' value='" + question.qstnContents + "'>";
					
				} else {
					html += "<input class='questnTitle'>";
					
				}
				html += "<img alt='' src='/images/ezSurvey/attach.png' class='atchImg'>";
				html += "<div class='selectBox'></div>";
				html += "</div>";
					
				html += "<div class='qstnAtt'>";
				html += "<div class='qstnFileInfo'>";
				html += "<div class='fileList'>";
				
				if (question != undefined) {
					html += "<ul>";
					
					var qstnAtt = question.questionAttach;
					
					if (qstnAtt != null && qstnAtt != '' && qstnAtt != undefined) {
						var liEl = mkImgTag(qstnAtt);
						html += "" + liEl + "";
						
					}
					html += "</ul>";
					
				} else {
					html += "<ul></ul>";
					
				}
				html += "</div>";
				html += "</div>";
						
				html += "<div class='qstnAtt'>";
				html += "<input type='file' class='qstnFile' style='display:none;'/>";
				html += "</div>";
				html += "</div>";
				html += "</div>";
			
				html += "</div>";
				
				if (qstnWrapper != undefined) {
					qstnWrapper.after(html);
					
				} else {
					$(".quesBacgr").append(html);
					
				}
			
			}
			
			// question event 추가
			function addQstnEvent() {
				
				// question 첨부파일 트리거
				$(".quesBacgr").on("click", ".atchImg", function() {
					$(this).parent().next().find(".qstnFile").click();
				});
				
				// question 첨부파일 추가
				$(".quesBacgr").on("change", ".qstnFile", function (e) {
					
					//console.log("question 첨부파일 추가");
					var thisEl = $(this);
					var thisFile = $(this)[0].files;
					//console.log(thisEl.parent().prev()[0]);
					
					fileUpload(thisEl, thisFile);
				});
				
			}
			
			// question selectBox 생성
			function createQuestionSelectBox(question) {
				// selectbox default value
				var selectText = SurveyMessages.strQselect;
				// question 객체가 있을 경우
				if (question != undefined) {
					// 셀렉트 박스에 선택될 내용을 가져옴
					selectText = getSelectedOpt(question);
				}
				
				$(".selectBox").ddslick({
					data :optionData,
					imagePosition: "left",
					selectText: selectText,
					// defaultSelectedIndex -> selected 되어 밑에 함수까지 실행 됨
					//defaultSelectedIndex: typeNum,
					onSelected: function(data) {
						
						var selectedEl = data.selectedItem;
						var grandParent = selectedEl.parents(".qstnWrapper");
						//var questionType = data.selectedIndex;
						var questionType = data.selectedData.value;

						switch (questionType) {
							case 1:
								makeSelectQuestion(grandParent, questionType);
								break;
							case 2:
								makeSelectQuestion(grandParent, questionType);
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
			
			// selectBox에 선택된 값 가져옴
			function getSelectedOpt(question) {
				
				var qstnType = parseInt(question.qstnType);
				var selectText;

				switch (qstnType) {
					case 1:
						selectText = SurveyMessages.strSlOne;
						break;
					case 2:
						selectText = SurveyMessages.strSlMtp;
						break;
					case 3:
						selectText = SurveyMessages.strTblOne;
						break;
					case 4:
						selectText = SurveyMessages.strTblMtp;
						break;
					case 5:
						selectText = SurveyMessages.strShortQs;
						break;
					case 6:
						selectText = SurveyMessages.strLongQs;
						break;
					case 7:
						selectText = SurveyMessages.strSlider;
						break;
					case 8:
						selectText = SurveyMessages.strRanking;
						break;
					case 9:
						selectText = SurveyMessages.strDropdown;
						break;
					default :
						selectText = SurveyMessages.strQselect;
						break;
				}
				
				return selectText;
			}
			
			// 생성된 질문을 붙일 부분과 
			// 질문 유형을 파라미터로 받아 질문 영역 생성
			function makeSelectQuestion(grandParent, questionType) {
				var html = "";
				
					html += "<div class='selection' questionType='" + questionType + "'>";
				
					html += "<div class='optPart'>";
					
					html += "<div class='optArea'>";
					
					html += "<div class='option'>";
					html += "<input class='textInput' type='text'>";
					html += "<img src='/images/ezSurvey/attach.png' class='attImg'>"; 
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
					html += "<button class='addOpt'>추가</button>";
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
					
					
				grandParent.append(html);
				
			}
			
			function addOptEvent() {
				// 보기 추가
				$(".quesBacgr").on("click", ".addOpt", function() {
					var thisEl = $(this).parents(".selection");
					
					var html = "";
						html += "<div class='optPart'>";
						
						html += "<div class='optArea'>";
						
						html += "<div class='option'>";
						html += "<input class='textInput' type='text'>";
						html += "<img src='/images/ezSurvey/attach.png' class='attImg'>"; 
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
				$(".quesBacgr").on("click", ".addOther", function() {
					var thisEl = $(this).parents(".selection");

					var other = thisEl.find(".other")
					
					if (other.length == 0) {
						var html = "";
							
							html += "<div class='other'>";
							
							html += "<div class='optArea'>";
							
							html += "<div class='option'>";
							html += "<input class='textInput' type='text' placeholder='기타'>";
							html += "<img src='/images/ezSurvey/attach.png' class='attImg'>"; 
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
					$(this).parents(".optArea").next().find(".optionFile").click();
				});
				
				// option 첨부파일 추가
				$(".quesBacgr").on("change", ".optionFile", function (e) {
					var thisEl = $(this);
					var thisFile = $(this)[0].files;
					fileUpload(thisEl, thisFile);
				});
				
				// 질문 생성 폼의 내용 임시 저장
				$(".quesBacgr").on("click", ".save", function() {
					var thisEl = $(this);
					var status = "save";
					
					// 질문 객체 생성
					mkQstnObj(status, thisEl);
					
				});
				
				// 질문 수정
				// 생성된 질문의 오른쪽 위에 뜬 수정 버튼 클릭시
				$(".quesBacgr").on("click", ".crtBtn", function() {
					var tmpQstnWpr = $(this).parents(".usrQstnWrapper");
					var qstnWrapper = $(this).parents(".qstnWrapper");
					// 수정할 질문 id
					var qstnId = parseInt(tmpQstnWpr.attr("id"));
					var arrNum = qstnId - 1; 
					// 넘길 질문 객체
					var qstnList = SurveyCreate.getQs();
					var qstn = qstnList[arrNum];
					
					createQuestiobDiv(qstnWrapper, qstn);
					createQuestionSelectBox(qstn);
					
					mdfSelectQuestion(qstnWrapper, qstn);
					
					//수정을 취소할 경우를 고려해 임시로 숨김
					tmpQstnWpr.css("display", "none");
					
				});
				
				// 수정 폼의 내용 임시 저장
				$(".quesBacgr").on("click", ".modify", function (e) {
					
					var thisEl = $(this);
					var status = "modify";
					
					// 질문 객체 생성
					mkQstnObj(status, thisEl);
					
				});
				
			}
			
			// 생성된 질문을 붙일 부분과 
			// 질문 유형을 파라미터로 받아 질문 영역 생성
			function mdfSelectQuestion(qstnWrapper, question) {
				
				var html = "";
					
					html += "<div class='selection' questionType='" + question.qstnType + "'>";
					
					var options = question.option;
					
					for (var i = 0; i < options.length; i++) {
					
						html += "<div class='optPart'>";
						
						html += "<div class='optArea'>";
						
						html += "<div class='option'>";
						html += "<input class='textInput' type='text' value='" + options[i].contents + "'>";
						html += "<img src='/images/ezSurvey/attach.png' class='attImg'>"; 
						html += "<img src='/images/ezSurvey/minus.jpg' class='delImg'>";
						html += "</div>";
							
						html += "<div class='optFileInfo'>";
						html += "<div>";
						
						html += "<ul>";

						var optAtt = options[i].optionAttach;

						if (optAtt != null && optAtt != '' && optAtt != undefined) {
							html += "<li fname='" + optAtt.fname + "' fsize='" + optAtt.fsize + "' path='" + optAtt.fpath + "'>";
							html += "<div class='attDivFile'>";
							html += "<img alt='' src='/images/survey/file_del.gif' style='height: 50%;'>";
							html += "<div class='attImgAva'>";
							html += "<img alt='' src='" + optAtt.fpath + "'>";
							html += "</div>";
							html += "<div class='attFileInf'>";
							html += "<span title='" + optAtt.fname + "'>" + optAtt.fname + "</span>";
							html += "<span>" + optAtt.fsize + "</span>";
							html += "</div>";
							html += "</div>";
							html += "</li>";
						}
						
						html += "</ul>";
						
						html += "</div>";
						html += "</div>";
						
						html += "</div>";
						
						html += "<div class='optAtt'>";
						html += "<input type='file' class='optionFile' style='display:none;'/>";
						html += "</div>";
						
						html += "</div>";
					
					}
					var other = question.other;
					if (other != null && other != '' && other != undefined) {
						
						html += "<div class='other'>";
						
						html += "<div class='optArea'>";
						
						html += "<div class='option'>";
						html += "<input class='textInput' type='text' value='" + other.contents + "'>";
						html += "<img src='/images/ezSurvey/attach.png' class='attImg'>"; 
						html += "<img src='/images/ezSurvey/minus.jpg' class='delImg'>";
						html += "</div>";
							
						html += "<div class='optFileInfo'>";
						html += "<div>";
						
						html += "<ul>";
						
						var othAtt = other.otherAttach;
						
						if (othAtt != null && othAtt != '' && othAtt != undefined) {
							html += "<li fname='" + othAtt.fname + "' fsize='" + othAtt.fsize + "' path='" + othAtt.fpath + "'>";
							html += "<div class='attDivFile'>";
							html += "<img alt='' src='/images/survey/file_del.gif' style='height: 50%;'>";
							html += "<div class='attImgAva'>";
							html += "<img alt='' src='" + othAtt.fpath + "'>";
							html += "</div>";
							html += "<div class='attFileInf'>";
							html += "<span title='" + othAtt.fname + "'>" + othAtt.fname + "</span>";
							html += "<span>" + othAtt.fsize + "</span>";
							html += "</div>";
							html += "</div>";
							html += "</li>";
						}
						
						html += "</ul>";
						
						html += "</div>";
						html += "</div>";
						
						html += "</div>";
						
						html += "<div class='optAtt'>";
						html += "<input type='file' class='optionFile' style='display:none;'/>";
						html += "</div>";
						
						html += "</div>";
						
					}
				
					html += "<div class='additionalPart'>";
				
					html += "<div class='addBtns'>";
					html += "<button class='addOpt'>추가</button>";
					html += "<button class='addOther'>기타추가</button>";
					html += "</div>";
					
					html += "<div class='required'>";
					
					var required = question.required;
					
					if (required == 'Y') {
						html += "<input type='checkbox' name='checkbox' checked='checked'>";
						
					} else if(required == 'N') {
						html += "<input type='checkbox' name='checkbox'>";
					}
					
					html += "<strong>필수 답변</strong>";
					html += "</div>";
					
					html += "<div class='btns'>";
					html += "<button class='modify'>수정</button>";
					html += "<button class='mdfCancel'>취소</button>";
					html += "</div>";
				
				qstnWrapper.next().append(html);
				
			}
			
			// 수정시 x버튼에 이벤트 생성
			function mkImgTag(qstnAtt) {
				var imgTag = questionFile.mkImgTag(qstnAtt);
				
				return imgTag; 
			}
			
			
			// option 첨부파일 업로드
			function fileUpload(thisEl, thisFile) {
				questionFile.upload(thisEl, thisFile);
			}
			
			// 설문 생성 폼 삭제
			function rmQstnForm(thisEl) {
				var wrapper = thisEl.parents(".qstnWrapper");
				
				//question input 및 selectBox 제거
				wrapper.find(".quesDiv").remove();
				wrapper.find(".selection").remove();
			}
			// 단일선택 질문 생성 
			function mkSelectQstn(status, thisEl, question) {
				
				var id = question.id;
				var qstnContents = question.qstnContents;
				var qstnAtt = question.questionAttach;
				var qstnType = question.qstnType;
				var option = question.option;
				var required = question.required;
				var other = question.other
				
				var html = "";
					html += "<div class='usrQstnWrapper' id='" + id + "' qstnType='" + qstnType + "'>";
			  		
					html += "<div class='mvBtnDiv'>";
					html += "<img class='mvBtn' alt='' src='/images/ezSurvey/move.png'>";
					html += "</div>";
			  		
					html += "<div class='fiCoDelBtns'>";
					html += "<img alt='' src='/images/ezSurvey/correct.png' class='crtBtn'>";
					html += "<img alt='' src='/images/ezSurvey/copy.png' class='cpBtn'>";
					html += "<img alt='' src='/images/ezSurvey/trash.png' class='dltBtn'>";
					html += "</div>";
			  		
					if (qstnContents != null && qstnContents != '' && qstnContents != undefined) {
						html += "<strong class='qstnCtts' id='" + id + "'>" + qstnContents + "</strong>";
						
						if (required == 'Y') {
							html += "<strong class='imptt'>*</strong>";
						}
						if (qstnAtt != null && qstnAtt != '' && qstnAtt != undefined) {
							html += "<div class='qstnAtt'>"
							html += "<img alt='' src='" + qstnAtt.fpath + "' class='qstnImg'>";
							html += "</div>"
						}
					}
			  		
					html += "<div class='opts'>";
					// 보기
					if (option != null && option != '' && option != undefined) {
						for (var i = 0; i < option.length; i++) {
							html += "<div class='opt' level='" + option[i].level + "'>";
							html += "<input class='optRdo' type='radio' value=''/>";
							// 첨부파일이 있는지 확인
							if (option[i].optionAttach != null && option[i].optionAttach != '' && option[i].optionAttach != undefined) {
								html += "<img alt='' src='" + option[i].optionAttach.fpath + "' class='optImg'>";
							}
							html += "<span class='optSpan'>" + option[i].contents + "</span>";
							html += "</div>";
						}
					}
					
					// 기타
					if (other != null && other != '' && other != undefined) {
						html += "<div class='opt'>";
						html += "<input class='optRdo' type='radio' value=''/>";
						// 첨부파일이 있는지 확인
						if (other.otherAttach != null && other.otherAttach != '' && other.otherAttach != undefined) {
							html += "<img alt='' src='" + other.otherAttach.fpath + "' class='optImg'>";
						}
						html += "<span class='optSpan'>" + other.contents + "</span>";
						html += "<input class='othInput' type='text'/>";
						html += "</div>";
						html += "</div>";
					}
					
					html += "</div>";
					
					thisEl.parents(".qstnWrapper").prepend(html);

					if (status == 'save') {
						// 질문 폼 생성
						createQuestiobDiv();
						// 질문 폼의 셀렉트 박스 생성
						createQuestionSelectBox();
						
					} else {
						return;
					}
			}
			
			function rmPrevEl(thisEl) {
				// 질문을 수정하면 숨겨뒀던 userInterface를 지움 
				thisEl.parents(".qstnWrapper").prev().remove();
			}
			
			// 질문 객체 생성
			function mkQstnObj(status, thisEl) {
				
				if (status == 'modify') {
					rmPrevEl(thisEl);
				}
				
				var question = {};
				
				var qstnWrapper = thisEl.parents(".qstnWrapper");

				var qstnArea = qstnWrapper.find(".quesDiv");
				var qstnVal = qstnArea.find(".questnTitle").val();
				// 질문의 내용이 있는지 확인
				if (qstnVal != null && qstnVal != '' && qstnVal != undefined) {
					// 질문의 내용을 질문 객체에 추가
					question['qstnContents'] = qstnVal;
				}
				// 질문에 첨부파일이 있는지 확인
				var qstnFObj = qstnArea.find(".qstnFileInfo")[0].childNodes[0].childNodes[0].childNodes[0];
				// 첨부파일이 있는 경우만 파일 내용 추가
				if (qstnFObj != undefined) {
					var qstnAttach = {};
					
					var fName = qstnFObj.getAttribute("fname");
					qstnAttach['fname'] = fName;
					
					var fPath = qstnFObj.getAttribute("path");
					qstnAttach['fpath'] = fPath;
					
					var fSize = qstnFObj.getAttribute("fsize");
					qstnAttach['fsize'] = fSize;
					
					question['questionAttach'] = qstnAttach;
				}
				
				// 질문 타입을 질문 객체에 저장
				var optArea = thisEl.parents(".qstnWrapper").find(".quesDiv").next();
				// optArea -> .selection
				var qstnType = optArea.attr("questiontype");
				question['qstnType'] = qstnType;

				if (qstnType == 1) {
					
					// 보기
					var opt = optArea.find(".optPart");
					
					// 보기의 개수 확인
					if (opt.length > 0) {
						
						var option = [];
						
						for (var i = 0; i < opt.length; i++) {
							var optObj = {};
							
							// 보기가 비어있는지 확인
							var optVal = opt[i].childNodes[0].childNodes[0].childNodes[0].value;
							
							var level = i;
							optObj['level'] = i;
							
							if (optVal != null && optVal != '') {
								// 보기 객체에 내용 추가
								optObj['contents'] = optVal; 
							}
							
							// 첨부 파일이 있는지 확인
							var fObj = opt[i].childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[0];
							var optAttach = {};
							
							// 첨부파일이 있는 경우만 파일 내용 추가
							if (fObj != undefined) {
								var fName = fObj.getAttribute("fname");
								optAttach['fname'] = fName;
								
								var fPath = fObj.getAttribute("path");
								optAttach['fpath'] = fPath;
								
								var fSize = fObj.getAttribute("fsize");
								optAttach['fsize'] = fSize;
								
								optObj['optionAttach'] = optAttach;
							}
							option.push(optObj);
						}
						question['option'] = option; 
					}
					// 기타
					var oth = optArea.find(".other");
					var other = {};
					// 기타의 유무 확인
					if (oth.length != 0) {
						
						var othVal = oth[0].childNodes[0].childNodes[0].childNodes[0].value;
						if (othVal != null && othVal != '') {
							// 기타 객체에 내용 추가
							other['contents'] = othVal; 
						}
						
						var othObj = oth[0].childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[0];
						//console.log(othObj);
						if (othObj != undefined) {
							// 첨부파일 객체 생성
							var otherAttach = {};
							
							var othFName = othObj.getAttribute("fname");
							var othFPath = othObj.getAttribute("path");
							var othFSize = othObj.getAttribute("fsize");
							
							otherAttach['fname'] = othFName;
							otherAttach['fpath'] = othFPath;
							otherAttach['fsize'] = othFSize;
							// 기타 객체에 첨부파일 객체 추가
							other['otherAttach'] = otherAttach;
						}
						// 질문 객체에 기타 객체 추가
						question['other'] = other;
					}
					
				}
				// 필수 확인
				var rqrd = optArea.find(".additionalPart").find("input[name='checkbox']");
				var isChecked = rqrd.is(":checked");
				//console.log(isChecked);
				if (isChecked == true) {
					question['required'] = 'Y';
					
				} else {
					question['required'] = 'N';
				}
				
				// 처음 저장할 때
				if (status == 'save') {
					// 질문 array에 들어있는 질문의 개수를 가져옴
					var qstnList = SurveyCreate.getQs();
					var qstnCnt = qstnList.length;
					// 들어있는 개수보다 1 높여서 임시 id 부여
					question['id'] = qstnCnt + 1;
					
					// 질문  array에 질문 추가
					SurveyCreate.setQs(question);

					console.log("question 객체");
					console.log(question);
					
					console.log("리스트");
					console.log(qstnList);
					
				// 수정할 때					
				} else if (status == 'modify') {
					// 질문의 id 획득
					var id = qstnWrapper.attr("id");
					question['id'] = id;

					// 전체 배열 가져오기
					var questionList = SurveyCreate.getQs();
					// 질문 배열에서 해당 순번의 객체 삭제
					questionList.splice(id-1, 1);
					// 질문 배열에 해당 순번에 추가
					questionList.splice(id-1, 0, question);
					
					console.log("question 객체");
					console.log(question);
					
					console.log("리스트");
					console.log(questionList);

				}
				
				// selection 질문 생성
				mkSelectQstn(status, thisEl, question);
				
				// 설문 생성 폼 삭제
				rmQstnForm(thisEl);
				
			}
			
		}());
		
		</script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/questionFile.js')}"></script>
	</body>
</html>