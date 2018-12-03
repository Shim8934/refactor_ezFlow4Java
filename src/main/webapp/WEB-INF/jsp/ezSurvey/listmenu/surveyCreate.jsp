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
						var tabElmt      = listTabElmt[i];
						var spanElmt     = tabElmt.querySelector("span[class='arrow']");
						tabElmt.onclick  = (function(idx, elmt) {return function() {selectStep(idx, elmt);}; })(i + 1, tabElmt);
						spanElmt.onclick = (function(idx, elmt) {return function() {selectStep(idx, elmt);}; })(i + 1, tabElmt);
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
			createQuestionDiv();
			
			addQstnEvent();
			// question selectBox 생성
			createQuestionSelectBox();
			
			addOptEvent();
			
			// question input 및 img 생성
			function createQuestionDiv(qstnWrapper, question) {
				
				var html       = "";
				var qstId      = "";
				var qstContent = "";
				var qstAtt     = "";
				
				if (question) {
					qstId      = question.id;
					qstContent = question.qstnContents;

					if (question.questionAttach) {
						qstAtt     = mkImgTag(question.questionAttach);
					}
					
				}
				
				html += "<div class='qstnWrapper' id='" + qstId + "'>";
				html += "<div class='quesDiv'>";
				html += "<div class='qstnRow'>";
				html += "<input class='questnTitle' value='" + qstContent + "'>";
				html += "<img alt='' src='/images/ezSurvey/attach.png' class='atchImg'>";
				html += "<div class='selectBox'></div>";
				html += "</div>";
				html += "<div class='qstnAtt'>";
				html += "<div class='qstnFileInfo'>";
				html += "<div class='fileList'>";
				html += "<ul>" + qstAtt + "</ul>";
				html += "</div></div>";
				html += "<div class='qstnAtt'>";
				html += "<input type='file' class='qstnFile' style='display:none;'/>";
				html += "</div></div></div></div>";
				
				if (qstnWrapper) {
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
					fileUpload($(this), $(this)[0].files);
				});
			}
			
			// question selectBox 생성
			function createQuestionSelectBox(question) {
				// set selectbox default value
				var selectText = question ? getSelectedOpt(question) : SurveyMessages.strQselect;
				
				$(".selectBox").ddslick({
					data :optionData,
					imagePosition: "left",
					selectText: selectText,
					onSelected: function(data) {
						var selectedEl   = data.selectedItem;
						var grandParent  = selectedEl.parents(".qstnWrapper");
						var questionType = data.selectedData.value;
						
						switch (questionType) {
							case 1: makeSelectQuestion(grandParent, questionType); break;
							case 2: makeSelectQuestion(grandParent, questionType); break;
							case 3: break;
							case 4: break;
							case 5: break;
							case 6: break;
							case 7: break;
							case 8: break;
							case 9: break;
						}
					}
				});
			}
			
			// selectBox에 선택된 값 가져옴
			function getSelectedOpt(question) {
				var qstnType = parseInt(question.qstnType);
				var selectText;
				
				switch (qstnType) {
					case   1: selectText = SurveyMessages.strSlOne   ; break;
					case   2: selectText = SurveyMessages.strSlMtp   ; break;
					case   3: selectText = SurveyMessages.strTblOne  ; break;
					case   4: selectText = SurveyMessages.strTblMtp  ; break;
					case   5: selectText = SurveyMessages.strShortQs ; break;
					case   6: selectText = SurveyMessages.strLongQs  ; break;
					case   7: selectText = SurveyMessages.strSlider  ; break;
					case   8: selectText = SurveyMessages.strRanking ; break;
					case   9: selectText = SurveyMessages.strDropdown; break;
					default : selectText = SurveyMessages.strQselect ; break;
				}
				
				return selectText;
			}
			
			// 생성된 질문을 붙일 부분과 질문 유형을 파라미터로 받아 질문 영역 생성
			function makeSelectQuestion(grandParent, questionType) {
				var html = "";
					html += "<div class='qstnForm' questionType='" + questionType + "'>";
					
					if (questionType == 1 || questionType == 2) {
						html += "<div class='optPart'>" + mkOpt() + "</div>";
					} 
					html += ""+ mkAddtionalPart() + "";
					
				grandParent.append(html);
			}
			
			function addOptEvent() {
				// 보기 추가
				$(".quesBacgr").on("click", ".addOpt", function() {
					var type = "opt";
					
					var thisEl = $(this).parents(".qstnForm");
					var html   = "<div class='optPart'>" + mkOpt(type) + "</div>";
					
					thisEl.find(".optPart").last().after(html);
				});
				
				// 기타 추가
				$(".quesBacgr").on("click", ".addOther", function() {
					var type = "other";
					
					var thisEl = $(this).parents(".qstnForm");
					var other  = thisEl.find(".other");
					
					if (other.length == 0) {
						var html = "<div class='other'>" + mkOpt(type) + "</div>";
						
						thisEl.find(".optPart").last().after(html);
					}
					else {
						alert("기타는 하나만 추가 가능합니다.");
					}
				});
				
				// 보기, 기타 삭제
				$(".quesBacgr").on("click", ".delImg", function() {
					var thisEl    = $(this);
					var optAreaLength = thisEl.parents(".qstnForm").find(".optArea").length;
					// 보기와 기타의 합계가 2개 이상일 때만 삭제
					if (optAreaLength > 2) {
						// 삭제할 요소가 option인지 other인지 확인
						if (thisEl.parents(".optPart").length == 1) {
							thisEl.parents(".optPart").remove();
						}
						else {
							thisEl.parents(".other").remove();
						}
					}
					else {
						alert("최소 2개 이상의 보기가 필요합니다.");
					}
				});
				
				// option 첨부파일 트리거
				$(".quesBacgr").on("click", ".attImg", function() {
					$(this).parents(".optArea").next().find(".optionFile").click();
				});
				
				// option 첨부파일 추가
				$(".quesBacgr").on("change", ".optionFile", function (e) {
					fileUpload($(this), $(this)[0].files);
				});
				
				// 질문 생성 폼의 취소 버튼 클릭
				$(".quesBacgr").on("click", ".cancel", function() {
					$(this).parents(".qstnForm").remove();
				});
				
				// 질문 생성 폼의 내용 임시 저장
				$(".quesBacgr").on("click", ".save", function() {
					mkQstnObj("save", $(this));
				});
				
				// 질문 수정
				// 생성된 질문의 오른쪽 위에 뜬 수정 버튼 클릭시
				$(".quesBacgr").on("click", ".crtBtn", function() {
					var tmpQstnWpr  = $(this).parents(".usrQstnWrapper");
					var qstnWrapper = $(this).parents(".qstnWrapper");
					// 수정할 질문 id
					var qstnId      = parseInt(tmpQstnWpr.attr("id"));
					var arrNum      = qstnId - 1; 
					// 넘길 질문 객체
					var qstnList    = SurveyCreate.getQs();
					var qstn        = qstnList[arrNum];
					
					createQuestionDiv(qstnWrapper, qstn);
					createQuestionSelectBox(qstn);
					mdfSelectQuestion(qstnWrapper, qstn);
					
					//수정을 취소할 경우를 고려해 임시로 숨김
					qstnWrapper.css("display", "none");
				});
				
				// 수정 폼 저장
				$(".quesBacgr").on("click", ".modify", function (e) {
					mkQstnObj("modify", $(this));
				});
				
				// 수정 폼 삭제
				$(".quesBacgr").on("click", ".mdfCancel", function() {
					var thisWrapper = $(this).parents(".qstnWrapper");
					// 숨김 처리했던 사용자 폼 다시 보임 처리
					thisWrapper.prev().css("display", "");
					// 수정 폼 삭제
					thisWrapper.remove();
				});
			}
			
			// 생성된 질문을 붙일 부분과 질문 유형을 파라미터로 받아 질문 영역 생성
			function mdfSelectQuestion(qstnWrapper, question) {
				var action = 'modify';
				
				var html    = "";
					html   += "<div class='qstnForm' questionType='" + question.qstnType + "'>";
					
				var options = question.option;

				if (options) {
					for (var i = 0; i < options.length; i++) {
						var type = "opt";
						html += "<div class='optPart'>" + mkOpt(type, options[i], action) + "</div>";
						
					}
				}
				
				var other = question.other;
				
				if (other) {
					var type = "other";
					html += "<div class='other'>" + mkOpt(type, other, action) + "</div>";
				}
				
				html += "" + mkAddtionalPart(question.required, action) + "";
				
				qstnWrapper.next().append(html);
			}
			
			// 첨부파일 있을 시 태그 생성
			function mkImgTag(qstnAtt) {
				if (!qstnAtt) {return "";}
				return questionFile.mkImgTag(qstnAtt);
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
				wrapper.find(".qstnForm").remove();
			}
			// 단일선택 질문 생성 
			function mkSelectQstn(status, thisEl, question) {
				
				var qstId        = question.id;
				var qstnContents = question.qstnContents;
				var qstnAtt      = question.questionAttach;
				var qstnType     = question.qstnType;
				var option       = question.option;
				var required     = question.required;
				var other        = question.other
				
				var html = "";
					html += "<div class='usrQstnWrapper' id='" + qstId + "' qstnType='" + qstnType + "'>";
					html += "<div class='mvBtnDiv'>";
					html += "<img class='mvBtn' alt='' src='/images/ezSurvey/move.png'>";
					html += "</div>";
					html += "<div class='fiCoDelBtns'>";
					html += "<img alt='' src='/images/ezSurvey/correct.png' class='crtBtn'>";
					html += "<img alt='' src='/images/ezSurvey/copy.png' class='cpBtn'>";
					html += "<img alt='' src='/images/ezSurvey/trash.png' class='dltBtn'>";
					html += "</div>";
			  		
					if (qstnContents) {
						html += "<strong class='qstnCtts' id='" + qstId + "'>" + qstnContents + "</strong>";
						
						if (required == 'Y') {
							html += "<strong class='imptt'>*</strong>";
						}
						if (qstnAtt) {
							html += "<div class='qstnAtt'>"
							html += "<img alt='' src='" + qstnAtt.fpath + "' class='qstnImg'>";
							html += "</div>"
						}
					}
			  		
					html += "<div class='opts'>";
					// 보기
					if (option) {
						for (var i = 0; i < option.length; i++) {
							html += "<div class='opt' level='" + option[i].level + "'>";
							
							if (qstnType == 2) {
								html += "<input class='optChb' type='checkbox' value='" + option[i].level + "'/>";

							} else {
								html += "<input class='optRdo' type='radio' value='" + option[i].level + "'/>";
							}
							// 첨부파일이 있는지 확인
							html += option[i].optionAttach ? "<img alt='' src='" + option[i].optionAttach.fpath + "' class='optImg'>" : "";
							html += "<span class='optSpan'>" + option[i].contents + "</span>";
							html += "</div>";
						}
					}
					// 기타
					if (other) {
						html += "<div class='opt'>";
						html += "<input class='optRdo' type='radio' value='" + other + "'/>";
						html += other.otherAttach ? "<img alt='' src='" + other.otherAttach.fpath + "' class='optImg'>" : ""; // 첨부파일이 있는지 확인
						html += "<span class='optSpan'>" + other.contents + "</span>";
						html += "<input class='othInput' type='text'/>";
						html += "</div></div>";
					}
					html += "</div>";
					thisEl.parents(".qstnWrapper").prepend(html);
					
					if (status == 'save') {
						createQuestionDiv();
						createQuestionSelectBox();
					}
					else {
						return;
					}
			}
			
			function rmPrevEl(thisEl) {
				// 질문을 수정하면 숨겨뒀던 userInterface를 지움 
				thisEl.parents(".qstnWrapper").prev().remove();
			}
			
			// 질문 객체 생성
			function mkQstnObj(status, thisEl) {
				if (status == 'modify') {rmPrevEl(thisEl);}
				
				var question    = {};
				var qstnWrapper = thisEl.parents(".qstnWrapper");
				var qstnArea    = qstnWrapper.find(".quesDiv");
				var qstnVal     = qstnArea.find(".questnTitle").val();
				// 질문의 내용이 있는지 확인
				if (qstnVal) {question['qstnContents'] = qstnVal;}
				// 질문에 첨부파일이 있는지 확인
				var qstnFObj = qstnArea.find(".qstnFileInfo")[0].childNodes[0].childNodes[0].childNodes[0];
				// 첨부파일이 있는 경우만 파일 내용 추가
				if (qstnFObj) {
					var qstnAttach             = {};
					var fName                  = qstnFObj.getAttribute("fname");
					var fPath                  = qstnFObj.getAttribute("path");
					var fSize                  = qstnFObj.getAttribute("fsize");
					qstnAttach['fname']        = fName;
					qstnAttach['fpath']        = fPath;
					qstnAttach['fsize']        = fSize;
					question['questionAttach'] = qstnAttach;
				}
				
				// 질문 타입을 질문 객체에 저장
				var optArea          = thisEl.parents(".qstnWrapper").find(".quesDiv").next();
				var qstnType         = optArea.attr("questiontype");
				question['qstnType'] = qstnType;
				
				if (qstnType == 1 || qstnType == 2) {
					var opt = optArea.find(".optPart");
					
					// 보기의 개수 확인
					if (opt.length > 0) {
						var option = [];
						
						for (var i = 0; i < opt.length; i++) {
							var optObj = {};
							// 보기가 비어있는지 확인
							var optVal      = opt[i].childNodes[0].childNodes[0].childNodes[0].value;
							optObj['level'] = i;
							
							if (optVal) {optObj['contents'] = optVal; }
							
							// 첨부 파일이 있는지 확인
							var fObj      = opt[i].childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[0];
							var optAttach = {};
							
							// 첨부파일이 있는 경우만 파일 내용 추가
							if (fObj) {
								var fName              = fObj.getAttribute("fname");
								var fPath              = fObj.getAttribute("path");
								var fSize              = fObj.getAttribute("fsize");
								optAttach['fname']     = fName;
								optAttach['fpath']     = fPath;
								optAttach['fsize']     = fSize;
								optObj['optionAttach'] = optAttach;
							}
							
							option.push(optObj);
						}
						
						question['option'] = option; 
					}
					
					// 기타
					var oth   = optArea.find(".other");
					var other = {};
					// 기타의 유무 확인
					if (oth.length != 0) {
						var othVal = oth[0].childNodes[0].childNodes[0].childNodes[0].value;
						var othObj = oth[0].childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[0];
						
						if (othVal) {other['contents'] = othVal;}
						
						if (othObj) {
							var otherAttach = {};
							var othFName         = othObj.getAttribute("fname");
							var othFPath         = othObj.getAttribute("path");
							var othFSize         = othObj.getAttribute("fsize");
							otherAttach['fname'] = othFName;
							otherAttach['fpath'] = othFPath;
							otherAttach['fsize'] = othFSize;
							other['otherAttach'] = otherAttach;
						}
						// 질문 객체에 기타 객체 추가
						question['other'] = other;
					}
				}
				
				// 필수 확인
				var rqrd             = optArea.find(".additionalPart").find("input[name='checkbox']");
				var isChecked        = rqrd.is(":checked");
				question['required'] = isChecked == true ? 'Y' : 'N';
				
				// 처음 저장할 때
				if (status == 'save') {
					// 질문 array에 들어있는 질문의 개수를 가져옴
					var qstnList   = SurveyCreate.getQs();
					var qstnCnt    = qstnList.length;
					question['id'] = qstnCnt + 1;
					SurveyCreate.setQs(question);
					
					//console.log("저장");
					//console.log(SurveyCreate.getQs());
				}
				else if (status == 'modify') {
					var qstId        = qstnWrapper.attr("id");
					question['id']   = qstId;
					var questionList = SurveyCreate.getQs();
					
					questionList.splice(qstId - 1, 1);           // 질문 배열에서 해당 순번의 객체 삭제
					questionList.splice(qstId - 1, 0, question); // 질문 배열에 해당 순번에 추가
					
					//console.log("수정");
					//console.log(SurveyCreate.getQs());
				}
				mkSelectQstn(status, thisEl, question); // 질문 폼 생성
				rmQstnForm(thisEl);                     // 설문 생성 폼 삭제
			}
			
			function mkOpt(type, options, action) {
				var html = "";
					html += "<div class='optArea'>";
					html += "<div class='option'>";
					
					if (type == 'other') {
						if (options) {
							html += "<input class='textInput' type='text' value='" + options.contents + "'>";
							
						} else {
							html += "<input class='textInput' type='text' placeholder='기타'>";
						}
					} else {
						if (options) {
							html += "<input class='textInput' type='text' value='" + options.contents + "'>";
							
						} else {
							html += "<input class='textInput' type='text'>";
						}
					}
					html += "<img src='/images/ezSurvey/attach.png' class='attImg'>";
					html += "<img src='/images/ezSurvey/minus.jpg' class='delImg'>";
					html += "</div>";
					html += "<div class='optFileInfo'>";
					html += "<div>";
					
					if (options) {
						var optAtt;
						
						if (type == 'other') {
							optAtt = options.otherAttach;
							
						} else {
							optAtt = options.optionAttach;
						}
						if (optAtt) {
							var optAtt = mkImgTag(optAtt);
							html += "<ul>" + optAtt + "</ul>";
							
						} else {
							html += "<ul></ul>";
						}
					} else {
						html += "<ul></ul>";
					}
					html += "</div></div></div>";
					html += "<div class='optAtt'>";
					html += "<input type='file' class='optionFile' style='display:none;'/>";
					html += "</div>";
				
				return html;
			}
			
			function mkAddtionalPart(required, action) {
				var html = "";
					html += "<div class='additionalPart'>";
					html += "<div class='addBtns'>";
					html += "<button class='addOpt'>추가</button>";
					html += "<button class='addOther'>기타추가</button>";
					html += "</div>";
					html += "<div class='required'>";
					html += required == 'Y' ? "<input type='checkbox' name='checkbox' checked='checked'>" : "<input type='checkbox' name='checkbox'>";
					html += "<strong>필수 답변</strong>";
					html += "</div>";
					html += "<div class='btns'>";
					
					if (action == 'modify') {
						html += "<button class='modify'>수정</button>";
						html += "<button class='mdfCancel'>취소</button>";

					} else {
						html += "<button class='save'>저장</button>";
						html += "<button class='cancel'>취소</button>";
					}
					html += "</div>";
				
				return html;
			}
		}());
		
		</script>
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/questionFile.js')}"></script>
	</body>
</html>