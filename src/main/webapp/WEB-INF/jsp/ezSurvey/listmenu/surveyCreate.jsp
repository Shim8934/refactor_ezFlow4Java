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
		
		<script type="text/javascript">
			var SurveyCreate    = function() {
				var selectPopup = null;
				var surveyObj   = {
					info : {},
					questions : []
				};
				
				initEvents();
				
				function initEvents() {
					document.onselectstart = function() {return false;};
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
					focusonQuestionTitle();
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
					
					switch(parseInt(tabIdx)) {
						case 1: focusonQuestionTitleStep1(); break;
						case 2: focusonQuestionTitleStep2(); break;
					}
				}
				
				function focusonQuestionTitleStep1() {document.querySelector("input[class='info-input-ttl']").focus();}
				function focusonQuestionTitleStep2() {document.querySelector("div[class='quesDiv']").querySelector("input[class='questnTitle']").focus();}
				
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
				var questionFile = new SurveyFile("images");
				var config       = {modify : "modify", required : "required", action : "action",}
					
				// 셀렉트 박스에 들어갈 질문 유형 데이터 
				var optionData = 
					[{ text : SurveyMessages.strSlOne   , value: 1, selected: false, imageSrc: "/images/ezSurvey/oneselect.png"  },
					 { text : SurveyMessages.strSlMtp   , value: 2, selected: false, imageSrc: "/images/ezSurvey/multiplesl.png" },
					 { text : SurveyMessages.strTblOne  , value: 3, selected: false, imageSrc: "/images/ezSurvey/tblone.png"     },
					 { text : SurveyMessages.strTblMtp  , value: 4, selected: false, imageSrc: "/images/ezSurvey/tblmultiple.png"},
					 { text : SurveyMessages.strShortQs , value: 5, selected: false, imageSrc: "/images/ezSurvey/shorttext.png"  },
					 { text : SurveyMessages.strLongQs  , value: 6, selected: false, imageSrc: "/images/ezSurvey/paragraph.png"  },
					 { text : SurveyMessages.strSlider  , value: 7, selected: false, imageSrc: "/images/ezSurvey/slider.png"     },
					 { text : SurveyMessages.strRanking , value: 8, selected: false, imageSrc: "/images/ezSurvey/ranking.png"    },
					 { text : SurveyMessages.strDropdown, value: 9, selected: false, imageSrc: "/images/ezSurvey/dropdown.png"   }];
				
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
						qstContent = question.content;
						qstAtt     = mkImgTag(question.attach);
					}
					
					html += "<div class='qstnWrapper' id='" + qstId + "'>";
					html += "<div class='quesDiv'>";
					html += "<div class='qstnRow'>";
					html += "<input class='questnTitle' value='" + qstContent + "' placeholder='" + SurveyMessages.strContent + "'/>";
					html += "<img alt='' src='/images/ezSurvey/attach.png' class='atchImg'>";
					html += "<div class='selectBox'></div>";
					html += "</div>";
					html += "<div class='qstnFileInfo'>";
					html += "<div class='fileList'>";
					html += "<ul class='qstUl'>" + qstAtt + "</ul>";
					html += "<input type='file' class='qstnFile' accept='image/*'/>";
					html += "</div></div></div></div>";
					
					if (qstnWrapper) {
						qstnWrapper.after(html);
						qstnWrapper.next().find(".questnTitle")[0].focus();
					}
					else {
						$(".quesBacgr").append(html);
						$(".quesBacgr").find(".qstnWrapper").find(".questnTitle")[0].focus();
					}
				}
				
				// question event 추가
				function addQstnEvent() {
					// question 첨부파일 트리거
					$(".quesBacgr").on("click", ".atchImg", function() {
						var li = $(this).closest(".quesDiv").find(".fileList").find("li");
						if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
						$(this).parent().next().find(".qstnFile").click();
					});
					
					// question 첨부파일 추가
					$(".quesBacgr").on("change", ".qstnFile", function(e) {fileUpload(this);});
				}
				// selectBox 생성
				function createQuestionSelectBox(question) {
					$(".selectBox").ddslick({
						data :optionData,
						imagePosition: "left",
						selectText: SurveyMessages.strQselect,
						onSelected: function(data) {
							var selectedEl   = data.selectedItem;
							var grandParent  = selectedEl.parents(".qstnWrapper");
							var questionType = data.selectedData.value;
							
							rmQstnFormBfSave(grandParent);
							var checkResult = checkPrevWrapper(grandParent);
							
							switch (parseInt(questionType)) {
								case 1: 
								case 2: makeSelectQuestion(grandParent, questionType, checkResult)              ; break;
								case 3: 
								case 4: makeMatrixQuestion(grandParent, questionType, checkResult)              ; break;
								case 5: makeTextQuestion(grandParent, questionType, "shortanswer", checkResult) ; break;
								case 6: makeTextQuestion(grandParent, questionType, "paragraph"  , checkResult) ; break;
								case 7: makeSliderQuestion(grandParent, questionType, checkResult)              ; break;
								case 8: makeRankingQuestion(grandParent, questionType, checkResult)             ; break;
								case 9: makeDropdownQuestion(grandParent, questionType, checkResult)            ; break;
							}
						}
					});
				}
				// 현재 상태(최초 저장인지 수정 중인지) 체크
				function checkPrevWrapper(grandParent) {
					var checkResult = {};
					var thisId      = parseInt(grandParent.attr("id"));
					
					if (thisId) {
						var qstnObj = SurveyCreate.getQs();
						checkResult[config["action"]]   = config["modify"];
						checkResult[config["required"]] = qstnObj[thisId - 1].required;
					}
					
					return checkResult;
				}
				// 셀렉트 박스 선택시
				// 셀렉트 박스 아래의 질문 폼 삭제
				function rmQstnFormBfSave(grandParent) {
					var qstnForm = grandParent.find(".qstnForm");
					if (qstnForm.length != 0) {qstnForm.remove();}
				}
				
				// 셀렉트 박스 선택시 만들어지는 질문 폼 선택 질문 생성
				function makeSelectQuestion(grandParent, questionType, checkResult) {
					var html = makeQuestionForm(questionType);
					html    += handleModifySelectQuestion();
					html    += mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
					grandParent.append(html);
				}
				
				// 셀렉트 박스 선택시 만들어지는 질문 폼 행렬 질문 생성
				function makeMatrixQuestion(grandParent, questionType, checkResult) {
					var html = makeQuestionForm(questionType);
					html    += handleModifyMatrixQuestion();
					html    += mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
					grandParent.append(html);
				}
				
				// 버튼 이벤트
				function addOptEvent() {
					$(".quesBacgr").on("click", ".addOpttions", function() {
						var thisEl    = $(this).parents(".qstnForm");
						var classType = parseInt(thisEl.attr("questiontype")) == 8 ? "ranking" : "dropdown";
						var optCnt    = thisEl.find(".textInput").length;
						thisEl.find("." + classType + "-select").last().after(mkOptions(classType, optCnt + 1, ""));
					});
					
					$(".quesBacgr").on("click", ".delOption", function() {
						var thisElmt  = $(this);
						var qstForm   = thisElmt.parents(".qstnForm");
						var classType = parseInt(qstForm.attr("questiontype")) == 8 ? "ranking" : "dropdown";
						var optCnt    = qstForm.find(".textInput").length;
						
						if (optCnt <= 2) {alert(SurveyMessages.strOptErr); return;}
						thisElmt.parents("." + classType + "-select").remove();
					});
					
					// 보기 추가
					$(".quesBacgr").on("click", ".addOpt", function() {
						var thisEl = $(this).parents(".qstnForm");
						thisEl.find(".optPart").last().after(mkOpt("opt"));
					});
					
					// 기타 추가
					$(".quesBacgr").on("click", ".addOther", function() {
						var thisEl = $(this).parents(".qstnForm");
						if (thisEl.find(".other").length > 0) {alert(SurveyMessages.strOneOther); return;}
						thisEl.find(".optPart").last().after(mkOpt("other"));
					});
					
					// 보기, 기타 삭제
					$(".quesBacgr").on("click", ".delImg", function() {
						var thisEl        = $(this);
						var optAreaLength = thisEl.parents(".qstnForm").find(".optArea").length;
						
						if (optAreaLength <= 2) {alert(SurveyMessages.strOptErr); return}
						
						// 삭제할 요소가 option인지 other인지 확인
						if (thisEl.parents(".optPart").length == 1) {
							thisEl.parents(".optPart").remove();
						}
						else {
							thisEl.parents(".other").remove();
						}
					});
					
					// matrix 행 추가
					$(".quesBacgr").on("click", ".addRow", function() {
						$(this).parents(".rowArea").find(".rows").append(mkRowCol("row"));
					});
					// matrix 열 추가
					$(".quesBacgr").on("click", ".addCol", function() {
						var cols = $(this).parents(".colArea").find(".cols");
						var colLength = cols.find(".col").length;
						
						if (colLength > 10) {alert(SurveyMessages.strColumnLm); return;}
						cols.append(mkRowCol("col"));
					});
					// matrix 행 삭제
					$(".quesBacgr").on("click", ".delRow", function(e) {
						var lowLength = $(this).closest(".rows").find(".row").length;
						if (lowLength <= 1) {alert(SurveyMessages.strMaxtrix1); return;}
						$(this).closest(".row").remove();
					});
					// matrix 열 삭제
					$(".quesBacgr").on("click", ".delCol", function() {
						var colLength = $(this).closest(".cols").find(".col").length;
						if (colLength <= 1) {alert(SurveyMessages.strMaxtrix2); return;}
						$(this).closest(".col").remove();
					});
					
					// 첨부파일 버튼 클릭 이벤트
					$(".quesBacgr").on("click", ".attImg", function() {
						var optArea = $(this).closest(".optArea");
						var li      = optArea.find(".fileList").find("li");
						if (li.length > 0) {alert(SurveyMessages.strOnlyOne); return;}
						optArea.find(".optionFile").click();
					});
					
					$(".quesBacgr").on("change", ".optionFile", function (e) {fileUpload(this);}); // 첨부파일 버튼 이벤트
					
					// 질문 생성 폼의 취소 버튼 클릭
					$(".quesBacgr").on("click", ".cancel", function() {
						var thisWrapper = $(this).closest(".qstnWrapper");
						thisWrapper.find(".quesDiv").find(".questnTitle").val(""); // 질문 내용 삭제
						clickXButton(thisWrapper);                                 // 첨부 파일 삭제
						setSelectBox(thisWrapper);                                 // 셀렉트 박스  내용 변경
						thisWrapper.find(".qstnForm").remove();                    // 질문 폼 삭제
					});
					
					// 저장 버튼 클릭 이벤트
					$(".quesBacgr").on("click", ".save", function() {mkQstnObj("save", $(this));});// 해당 질문의 객체 생성
					
					// 우상단 수정 버튼 클릭 이벤트
					$(".quesBacgr").on("click", ".modifyBtn", function() {
						var tmpQstnWpr  = $(this).parents(".usrQstnWrapper");
						var qstnWrapper = $(this).parents(".qstnWrapper");
						// 수정할 질문 id와 타입
						var qstnId      = parseInt(qstnWrapper.attr("id"));
						var arrNum      = qstnId - 1;
						var qstnType    = tmpQstnWpr.attr("qstntype");
						// 넘길 질문 객체
						var qstnList    = SurveyCreate.getQs();
						var qstn        = qstnList[arrNum];
						
						createQuestionDiv(qstnWrapper, qstn);
						createQuestionSelectBox(qstn);
						setSelectBox(qstnWrapper, config["modify"], qstnType);
						handleModifyQuestion(qstnWrapper, qstn, config["modify"]);
						
						//수정을 취소할 경우를 고려해 숨김 처리
						qstnWrapper.css("display", "none");
					});
					// 우상단 복사 버튼 클릭 이벤트
					$(".quesBacgr").on("click", ".copyBtn", function() {
						var tmpQstnWpr  = $(this).parents(".usrQstnWrapper");
						var qstnWrapper = $(this).parents(".qstnWrapper");
						// 수정할 질문 id와 타입
						var qstnId      = parseInt(qstnWrapper.attr("id"));
						var arrNum      = qstnId - 1;
						var qstnType    = tmpQstnWpr.attr("qstntype");
						// 넘길 질문 객체
						var qstnList    = SurveyCreate.getQs();
						var qstn        = qstnList[arrNum];
						
						//var deep = Array.prototype.slice.call(qstn);
						var nextId = qstnId + 1;
						var deep = Object.assign({}, qstn, {'id': nextId}); 
						
						// 복사한 질문 객체를 배열에 추가
						qstnList.splice(qstnId, 0, deep);
						
						// 복사한 질문 객체 이후의 객체들 아이디값 +1
						setNewId(nextId, qstnList);
						
						// 복사한 객체로 사용자용 질문폼 생성
						var copyHtml = "<div class='qstnWrapper' id='" + nextId + "'></div>";
						qstnWrapper.after(copyHtml);
						
						var copyQstnWrapper = qstnWrapper.next();
						mkQstnsByType(copyQstnWrapper, qstnType, deep);
						
					});
					// 우상단 삭제 버튼 클릭 이벤트
					$(".quesBacgr").on("click", ".deleteBtn", function() {
						var thisWrapper = $(this).closest(".qstnWrapper");
						var qstnId      = thisWrapper.attr("id");
						var qstnList    = SurveyCreate.getQs();
						
						qstnList.splice(qstnId - 1, 1); // 질문 배열에서 해당 순번의 질문객체 삭제
						thisWrapper.remove();           // 질문 폼 삭제
					});
					
					// 수정 버튼 클릭 이벤트 질문 객체 수정
					$(".quesBacgr").on("click", ".modify", function (e) {
						mkQstnObj(config["modify"], $(this));
					});
					
					// 수정 취소 버튼 클릭 이벤트 수정 폼 삭제
					$(".quesBacgr").on("click", ".mdfCancel", function() {
						var thisWrapper = $(this).parents(".qstnWrapper");
						thisWrapper.prev().css("display", ""); // 숨김 처리했던 사용자 폼 다시 보임 처리
						thisWrapper.remove();                  // 수정 폼 삭제
					});
					
					$(".quesBacgr").on("input", ".slider-range", function() {
						var outputElmt         = this.parentElement.parentElement.querySelector("output[class='slider-output']");
						outputElmt.textContent = this.value;
					}).trigger("change");
					
					$(".quesBacgr").sortable({
						handle: '.mvBtn',
						cursor: 'move',
						containment: 'parent',
						tolerance: 'pointer',
						axis: "y",
						update: function(event, ui) {
							/* var i = 0;
							$(this).find('.ranking-order').each(function() {
								$(this).text(i + 1);
								i++;
							}); */
						}
					});
					
					$(".quesBacgr").on("click", ".delImage", function() {questionFile.deleteFile(this);});
				}
				
				function setNewId(nextId, qstnList) {
					for (var i = nextId; i < qstnList.length; i++) {
						// 해당 아이디 값을 가진 태그 캐치
						var qstn = qstnList[i];
						var oldId = qstn.id;
						var type = qstn.type;
						
						var newId = oldId + 1;
						qstnList[i].id = newId;
						
						var thisWrapper = $("#" + oldId);
						thisWrapper.html("");
						
						mkQstnsByType(thisWrapper, type, qstn);	
					}
				}
				
				function mkQstnsByType(qstnWrapper, qstnType, question) {
					
					switch(parseInt(qstnType)) {
						case 1  :
						case 2  : mkSelectQstn(qstnWrapper, question); break;
						case 3  : 
						case 4  : mkMatrixQstn(qstnWrapper, question); break;
						case 5  : mkShortAnswerQstn(qstnWrapper, question); break;
						case 6  : mkParagraphQstn(qstnWrapper, question); break;
						case 7  : mkSliderQstn(qstnWrapper, question); break;
						case 8  : mkRankingQstn(qstnWrapper, question); break;
						case 9  : mkDropDownQstn(qstnWrapper, question); break;
						default : alert(SurveyMessages.strError); return;
					}
				}
				// 첨부파일의 x버튼 클릭
				function clickXButton(thisWrapper) {
					var li = thisWrapper.find(".fileList").find("li");
					
					if (li) {
						for (var i = 0, len = li.length; i < len; i++) {
							li[i].childNodes[0].childNodes[0].click();
						}
					}
				}
				
				// 설문 작성 취소, 수정시 셀렉트 박스 내용 변경
				function setSelectBox(thisWrapper, modify, qstnType) {
					var ddSelected = ""; // dd-selected 태그의 html 제거 후 내용 변경 
					
					if (modify) {
						ddSelected  = thisWrapper.next().find(".dd-selected").html("");
						var optData = optionData[parseInt(qstnType - 1)];
						var text    = optData.text;
						var img     = optData.imageSrc;
						var html    = "<img class='dd-selected-image' src='" + img + "'>";
						html       += "<label class='dd-selected-text'>" + text + "</label>";
						ddSelected.append(html);
					}
					else {
						ddSelected = thisWrapper.find(".dd-selected").html("");
						ddSelected[0].innerText = SurveyMessages.strQselect;
					}
				}
				// 생성된 질문을 붙일 부분과 질문 유형을 파라미터로 받아 질문 영역 생성
				function handleModifyQuestion(qstnWrapper, question, mode) {
					var qstType = question.type;
					var html    = makeQuestionForm(qstType);
					
					switch(parseInt(qstType)) {
						case 1  :
						case 2  : html += handleModifySelectQuestion(question)                 ; break;
						case 3  : 
						case 4  : html += handleModifyMatrixQuestion(question)                 ; break;
						case 5  : html += handleModifyTextQuesion("shortanswer", "make")       ; break;
						case 6  : html += handleModifyTextQuesion("paragraph"  , "make")       ; break;
						case 7  : html += handleModifySliderQuesion(question)                  ; break;
						case 8  : html += handleModifyRankDropDownQuesion("ranking" , question); break;
						case 9  : html += handleModifyRankDropDownQuesion("dropdown", question); break;
						default : alert(SurveyMessages.strError)                               ; return;
					}
					
					html += mkAddtionalPart(mode, question.required);
					
					qstnWrapper.next().append(html);
				}
				// 수정시 새로 생성하는 선택질문
				function handleModifySelectQuestion(question) {
					var htmlTxt = "";
					
					if (question) {
						var options = question.option;
						var other   = question.other;
						
						if (options) {
							for (var i = 0, len = options.length; i < len; i++) {
								htmlTxt += mkOpt("opt", options[i]);
							}
						}
						
						if (other) {htmlTxt += mkOpt("other", other);}
					}
					else {
						for (var i = 0; i < 2; i++) {
							html += mkOpt("opt");
						}
					}
					
					htmlTxt += "<div class='addBtns'>";
					htmlTxt += "<button class='addOpt'>" + SurveyMessages.strAdd + "</button>";
					htmlTxt += "<button class='addOther'>" + SurveyMessages.strAddOther + "</button>";
					htmlTxt += "</div>";
					
					return htmlTxt;
				}
				
				// 수정시 새로 생성하는 행렬질문 
				function handleModifyMatrixQuestion(question) {
					var html = "";
					var row  = question ? question.row : "";
					var col  = question ? question.col : "";
					
					html += "<div class='mtrPart'>";
					html += "<div class='rowArea'>";
					html += "<div class='rName' style='float: left; width: 10%;'>";
					html += "<span>" + SurveyMessages.strRow + "</span>";
					html += "</div>";
					html += "<div class='rows' style='float: left; width: 90%;'>";
					
					if (row) {
						for (var i = 0; i < row.length; i++) {
							html += mkRowCol("row", row[i]);
						}
					}
					else {
						for (var i = 0; i < 2; i++) {
							html += mkRowCol("row");
						}
					}
					
					html += "</div>";
					html += "<div class='rowBtn'>";
					html += "<button class='addRow'>" + SurveyMessages.strAdd + "</button>";
					html += "</div></div>";
					html += "<div class='colArea'>";
					html += "<div class='cName' style='float: left; width: 10%;'>";
					html += "<span>" + SurveyMessages.strColumn + "</span>";
					html += "</div>";
					html += "<div class='cols' style='float: left; width: 90%;'>";
					
					if (col) {
						for (var i = 0; i < col.length; i++) {
							html += mkRowCol("col", col[i]);
						}
					}
					else {
						for (var i = 0; i < 2; i++) {
							html += mkRowCol("col");
						}
					}
					
					html += "</div>";
					html += "<div class='colBtn'>";
					html += "<button class='addCol'>" + SurveyMessages.strAdd + "</button>";
					html += "</div></div></div>";
					
					return html;
				}
				
				function handleModifyTextQuesion(type, mode) {
					var className = mode == "make" ? type + "-wrap" : "question-" + type;
					var htmlTxt   = "<div class='" + className + "'>";
					
					if (type == "paragraph") {
						htmlTxt  += "<textarea class='" + type +"' maxlength='500' placeholder='" + SurveyMessages.strContent + "'></textarea>";
					}
					else {
						htmlTxt  += "<input class='" + type +"' maxlength='80' placeholder='" + SurveyMessages.strContent + "'/>";
					}
					
					htmlTxt += "</div>";
					return htmlTxt;
				}
				
				function handleModifySliderQuesion(question) {
					var htmlTxt = "";
					var lowest  = question ? question["lowest"]  : "";
					var highest = question ? question["highest"] : "";
					htmlTxt    += "<div class='silder-wrap'>";
					htmlTxt    += "<input type='input' class='slider-lw' value='" + lowest  + "'/>";
					htmlTxt    += "<input type='range' class='slider-main'/>";
					htmlTxt    += "<input type='input' class='slider-up' value='" + highest + "'/>";
					htmlTxt    += "</div>";
					return htmlTxt;
				}
				
				function handleModifyRankDropDownQuesion(type, question) {
					var htmlTxt = "<div class='" + type + "-wrap'>";
					
					if (question) {
						var optionList = question["option"];
						
						for (var i = 0, len = optionList.length; i < len; i++) {
							htmlTxt += mkOptions(type, i + 1, optionList[i]["contents"]);
						}
					}
					else {
						for (var i = 0; i < 3; i++) {
							htmlTxt += mkOptions(type, i + 1, "");
						}
					}
					
					htmlTxt += "<div class='addBtns'>";
					htmlTxt += "<button class='addOpttions'>" + SurveyMessages.strAdd + "</button>";
					htmlTxt += "</div></div>";
					return htmlTxt;
				}
				
				// 첨부파일 있을 시 태그 생성
				function mkImgTag(qstnAtt) {
					if (!qstnAtt) {return "";}
					return questionFile.mkImgTag(qstnAtt);
				}
				
				// option 첨부파일 업로드
				function fileUpload(thisEl) {
					questionFile.upload(thisEl);
				}
				
				// 설문 생성 폼 삭제
				function rmQstnForm(wrapper) {
					//question input 및 selectBox 제거
					wrapper.find(".quesDiv").remove();
					wrapper.find(".qstnForm").remove();
				}
				
				// 단일선택 질문 생성 
				function mkSelectQstn(wrapperElmt, question) {
					var option   = question.option;
					var other    = question.other;
					var qstnType = question.type;
					var html     = makeQuestionHeaderPanel(question);
					html        += "<div class='question-opts'>";
					
					// 보기
					if (option) {
						for (var i = 0; i < option.length; i++) {
							html += "<div class='opt' level='" + option[i].level + "'>";
							
							if (qstnType == 2) {
								html += "<input class='optChb' type='checkbox' value='" + option[i].level + "'/>";
							}
							else {
								html += "<input class='optRdo' type='radio' value='" + option[i].level + "'/>";
							}
							
							// 첨부파일이 있는지 확인
							html          += option[i].optionAttach ? "<img alt='' src='" + option[i].optionAttach.fpath + "' class='optImg'>" : "";
							var optContent = option[i].contents ? option[i].contents : "";
							html          += "<span class='optSpan'>" + optContent + "</span>";
							html          += "</div>";
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
					wrapperElmt.prepend(html);
				}
				
				function mkMatrixQstn(wrapperElmt, question) {
					var col   = question.col;
					var row   = question.row;
					var html  = makeQuestionHeaderPanel(question);
						html += "<div class='question-opts'>";
						html += "<table class='matrix'>";
						html += "<thead>";
						html += "<tr>";
						html += "<td></td>";
						
					for (var i = 0; i < col.length; i++) {
						html += "<td>" + col[i].contents + "</td>";
					}
					
					html += "</tr>";
					html += "</thead>";
					html += "<tbody>";
					
					for (var i = 0; i < row.length; i++) {
						html += "<tr>";
						html += "<td>" + row[i].contents + "</td>";
						
						for (var j = 0; j < col.length; j++) {
							html += "<td><input type='radio' value='(" + row[i].level + ", " + col[j].level + ")'></td>";
						}
						
						html += "</tr>";
					}
					
					html += "</tbody>";
					html += "</table>";
					html += "</div>";
					
					wrapperElmt.prepend(html);
				}
				
				function rmPrevEl(wrapperElmt) {wrapperElmt.prev().remove();}
				
				// 질문 객체 생성
				function mkQstnObj(status, thisEl) {
					var question     = {};
					var qstnWrapper  = thisEl.parents(".qstnWrapper");
					var qstnArea     = qstnWrapper.find(".quesDiv");
					var qstnContent  = qstnArea.find(".questnTitle").val();
					var questionList = SurveyCreate.getQs();
					
					//Save common question information
					if (!qstnContent) {alert(SurveyMessages.strQsContent); return;}
					
					question['content']  = qstnContent;
					var qstnForm         = qstnWrapper.find(".quesDiv").next();
					var qstnType         = qstnForm.attr("questiontype");
					question['type']     = qstnType;
					var rqrd             = qstnForm.find(".additionalPart").find("input[name='checkbox']");
					question[config["required"]] = rqrd.is(":checked") == true ? 'Y' : 'N';
					
					//Check question attach files
					var qstnFObj = qstnArea.find(".qstnFileInfo")[0].childNodes[0].childNodes[0].childNodes[0];
					if (qstnFObj) {question['attach']  = getAttachFileInfo(qstnFObj);}
					
					//Question order
					var qstId      = qstnWrapper.attr("id") ? parseInt(qstnWrapper.attr("id")) : questionList.length + 1;
					question['id'] = qstId;
					//Set id
					qstnWrapper.attr("id", qstId);
					
					switch(parseInt(qstnType)) {
						case 1  :
						case 2  : var sltObj = mkSltObj(qstnForm);
								  if (sltObj.error)  {alert(SurveyMessages[sltObj.error]); return;}
								  if (sltObj.option) {question["option"] = sltObj.option;}
								  if (sltObj.other)  {question["other"]  = sltObj.other ;}
								  mkSelectQstn(qstnWrapper, question); break;
						case 3  : 
						case 4  : var mtrObj = mkMtrObj(qstnForm);
								  if (mtrObj.error) {alert(SurveyMessages[mtrObj.error]); return;}
								  if (mtrObj.row)   {question["row"] = mtrObj.row;}
								  if (mtrObj.col)   {question["col"] = mtrObj.col;}
								  mkMatrixQstn(qstnWrapper, question); break;
						case 5  : mkTextQstn(qstnWrapper, question, "shortanswer"); break;
						case 6  : mkTextQstn(qstnWrapper, question, "paragraph"  ); break;
						case 7  : var sliderObj = mkSliderObj(qstnForm[0]);
								  if (sliderObj.error) {alert(SurveyMessages[sliderObj.error]); return;}
								  question["lowest"]  = sliderObj["lowest"];
								  question["highest"] = sliderObj["highest"];
								  mkSliderQstn(qstnWrapper, question); break;
						case 8  : var rankingObj = mkRankingDropDownObj("ranking", qstnForm);
								  if (rankingObj.error) {alert(SurveyMessages[rankingObj.error]); return;}
								  question["option"] = rankingObj.option;
								  mkRankingQstn(qstnWrapper, question); break;
						case 9  : var dropDownObj = mkRankingDropDownObj("dropdown", qstnForm);
								  if (dropDownObj.error) {alert(SurveyMessages[rankingObj.error]); return;}
								  question["option"] = dropDownObj.option;
								  mkDropDownQstn(qstnWrapper, question); break;
						default : alert(SurveyMessages.strError); return;
					}
					
					rmQstnForm(qstnWrapper);
					
					if (status == 'save') {
						createQuestionDiv();
						createQuestionSelectBox();
						SurveyCreate.setQs(question);
					}
					else if (status == config["modify"]) {
						rmPrevEl(qstnWrapper);
						questionList.splice(qstId - 1, 1);           // 질문 배열에서 해당 순번의 객체 삭제
						questionList.splice(qstId - 1, 0, question); // 질문 배열에 해당 순번에 추가
					}
				}
				
				function mkTextQstn(wrapperElmt, question, type) {
					var html = makeQuestionHeaderPanel(question);
					html    += handleModifyTextQuesion(type, config["modify"]);
					wrapperElmt.prepend(html);
				}
				
				function mkSliderQstn(wrapperElmt, question) {
					var html = makeQuestionHeaderPanel(question);
					html    += "<div class='question-silder'>";
					html    += "<div class='silder-wrap'>";
					html    += "<span>" + question["lowest"] + "</span>";
					html    += "<input type='range' class='slider-range' name='slider" + question.id + "' min='" + question["lowest"] + "' max='" + question["highest"] + "'/>";
					html    += "<span>" + question["highest"] + "</span>";
					html    += "</div>";
					html    += "<output for='slider" + question.id + "' class='slider-output'></output>";
					html    += "</div>";
					
					wrapperElmt.prepend(html);
				}
				
				function mkRankingQstn(wrapperElmt, question) {
					var options = question["option"];
					var html    = makeQuestionHeaderPanel(question);
					html       += "<div class='question-ranking'>";
					html       += "<div class='ranking-wrap'>";
					var strSlct = "<select>";
					strSlct    += "<option selected>" + SurveyMessages.strSelect + "</option>";
					
					for (var j = 0, len = options.length; j < len; j++) {
						strSlct += "<option>" + options[j]["contents"] + "</option>";
					}
					
					strSlct += "</select>";
					
					for (var i = 0, len = options.length; i < len; i++) {
						html += "<div class='ranking-select'>";
						html += "<span class='rank-order'>" + (i + 1) + ".</span>";
						html += strSlct;
						html += "</div>";
					}
					
					html += "</div></div>";
					wrapperElmt.prepend(html);
				}
				
				function mkDropDownQstn(wrapperElmt, question) {
					var options = question["option"];
					var html    = makeQuestionHeaderPanel(question);
					html       += "<div class='question-dropdown'>";
					html       += "<div class='dropdown-wrap'>";
					html       += "<select>";
					html       += "<option selected>" + SurveyMessages.strSelect + "</option>";
					
					for (var j = 0, len = options.length; j < len; j++) {
						html += "<option>" + options[j]["contents"] + "</option>";
					}
					
					html += "</select>";
					html += "</div></div>";
					wrapperElmt.prepend(html);
				}
				
				function makeQuestionHeaderPanel(question) {
					var qstId    = question.id;
					var content  = question.content;
					var qstnType = question.type;
					var required = question.required;
					var qstnAtt  = question.attach;
					var htmlTxt  = "<div class='usrQstnWrapper' qstnType='" + qstnType + "'>";
					htmlTxt     += "<div class='question-panel'>";
					htmlTxt     += "<div class='mvBtn'></div>";
					htmlTxt     += "<div class='question-header'>";
					htmlTxt     += "<div class='question-content'>" + qstId + ". " + content;
					htmlTxt     += required == 'Y' ? "<strong class='imptt'>*</strong></div>" : "</div>";
					htmlTxt     += "<div class='tooltip-bttns'>";
					htmlTxt     += "<span class='modifyBtn'></span>";
					htmlTxt     += "<span class='copyBtn'></span>";
					htmlTxt     += "<span class='deleteBtn'></span>";
					htmlTxt     += "</div></div>";
					
					if (qstnAtt) {
						htmlTxt += "<div class='question-attach'>"
						htmlTxt += "<img alt='' src='" + qstnAtt.fpath + "' class='qstnImg'>";
						htmlTxt += "</div>"
					}
					
					return htmlTxt;
				}
				
				function mkRankingDropDownObj(type, qstnForm) {
					var returnObj = {};
					var optList   = qstnForm.find("." + type + "-select");
					var optCnt    = optList.length;
					var option    = [];
					
					for (var i = 0; i < optCnt; i++) {
						var optObj   = {};
						var optValue = optList[i].querySelector("input[class='textInput']").value;
						
						if (optValue) {
							optObj['contents'] = optValue;
							optObj['level']    = i;
							option.push(optObj);
						}
					}
					
					if (option.length < 2) {returnObj['error'] = "strOptErr"; return returnObj;}
					
					returnObj['option'] = option;
					return returnObj;
				}
				
				function mkSliderObj(qstnForm) {
					var sliderObj    = {};
					var lowestInput  = qstnForm.querySelector("input[class='slider-lw']");
					var highestInput = qstnForm.querySelector("input[class='slider-up']");
					var lowestValue  = lowestInput  ? lowestInput.value  : "";
					var highestValue = highestInput ? highestInput.value : "";
					
					//Check slider requirements
					if (!isValid(lowestValue))       {sliderObj.error = "strSlider1"; return sliderObj;}
					if (!isValid(highestValue))      {sliderObj.error = "strSlider2"; return sliderObj;}
					if (lowestValue >= highestValue) {sliderObj.error = "strSlider3"; return sliderObj;}
					
					sliderObj["lowest"]  = lowestValue;
					sliderObj["highest"] = highestValue;
					
					return sliderObj;
				}
				
				// select 질문 객체 생성
				function mkSltObj(qstnForm) {
					var sltObj   = {};
					var opt      = qstnForm.find(".optPart");
					var oth      = qstnForm.find(".other");
					var optCnt   = opt.length;
					var checkCnt = 0;
					
					// 보기의 개수 확인
					if (optCnt > 0) {
						var option = [];
						
						for (var i = 0; i < optCnt; i++) {
							var optVal = opt[i].childNodes[0].childNodes[0].childNodes[0].value; // 보기가 비어있는지 확인
							var fObj   = opt[i].childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[0];
							
							if (optVal || fObj) {
								var optObj      = {};
								optObj['level'] = option.length;
								
								if (optVal) {optObj['contents']     = optVal                 ;}
								if (fObj)   {optObj['optionAttach'] = getAttachFileInfo(fObj);}
								
								option.push(optObj);
								checkCnt ++;
							}
						}
						
						sltObj['option'] = option;
					}
					
					// 기타의 유무 확인
					if (oth.length != 0) {
						var other         = {};
						var othVal        = oth[0].childNodes[0].childNodes[0].childNodes[0].value;
						var othObj        = oth[0].childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[0];
						other['contents'] = othVal ? othVal : SurveyMessages.strOther;
						
						if (othObj) {other['otherAttach'] = getAttachFileInfo(othObj);}
						
						sltObj['other'] = other;
						checkCnt ++;
					}
					
					if (checkCnt < 2) {sltObj["error"] = "strOptErr";}
					
					return sltObj;
				}
				
				// matrix 질문 객체 생성
				function mkMtrObj(qstnForm) {
					var rows   = qstnForm.find(".row");
					var cols   = qstnForm.find(".col");
					var mtrObj = {};
					
					if (rows) {
						var row = [];
						
						for (var i = 0, len = rows.length; i < len; i++) {
							var rowObj = {};
							var rowVal = rows[i].childNodes[0].value;
							
							if (rowVal) {
								rowObj['level']    = row.length;
								rowObj['contents'] = rowVal;
								row.push(rowObj);
							}
						}
						
						if (row.length == 0) {mtrObj["error"] = "strMaxtrix1"; return mtrObj;}
						
						mtrObj['row'] = row;
					}
					
					if (cols) {
						var col = [];
						
						for (var i = 0; i < cols.length; i++) {
							var colObj = {};
							var colVal = cols[i].childNodes[0].value;
							
							if (colVal) {
								colObj['level']    = col.length;
								colObj['contents'] = colVal;
								col.push(colObj);
							}
						}
						
						if (col.length == 0) {mtrObj["error"] = "strMaxtrix2"; return mtrObj;}
						mtrObj['col'] = col;
					}
					
					return mtrObj;
				}
				
				// make ranking/dropdown options
				function mkOptions(type, order, content) {
					var html  = "<div class='" + type + "-select'>";
					html     += "<span class='" + type + "-order'>" + order + "</span>";
					html     += "<input class='textInput' type='text' value='" + content + "' placeholder='" + SurveyMessages.strContent + "'/>";
					html     += "<span class='delOption'></span>";
					html     += "</div>";
					return html;
				}
				
				// option 생성
				function mkOpt(type, options) {
					var optAtt = "";
					var attEl  = "";
					var html   = "<div class='optArea'>";
						html  += "<div class='option'>";
						
					if (type == 'other') {
						html = "<div class='other'>" + html;
						
						if (options) {
							html  += "<input class='textInput' type='text' value='" + options.contents + "' placeholder='" + SurveyMessages.strOther + "'/>";
							optAtt = options.otherAttach;
						}
						else {
							html += "<input class='textInput' type='text' placeholder='" + SurveyMessages.strOther + "'>";
						}
					}
					else {
						html = "<div class='optPart'>" + html;
						
						if (options) {
							html  += "<input class='textInput' type='text' value='" + options.contents + "' placeholder='" + SurveyMessages.strContent + "' />";
							optAtt = options.optionAttach;
						}
						else {
							html += "<input class='textInput' type='text' placeholder='" + SurveyMessages.strContent + "'/>";
						}
					}
					
					html += "<img src='/images/ezSurvey/attach.png' class='attImg'>";
					html += "<img src='/images/ezSurvey/minus.jpg' class='delImg'>";
					html += "</div>";
					html += "<div class='optFileInfo'>";
					html += "<div class='fileList'>";
					
					if (optAtt) {attEl = mkImgTag(optAtt);}
					
					html += "<ul class='optUl'>" + attEl + "</ul>";
					html += "<input type='file' class='optionFile' accept='image/*'/>";
					html += "</div></div></div></div>";
					
					return html;
				}
				
				function mkRowCol(type, elment) {
					var contents = "";
					var level    = "";
					var elClass  = type == "row" ? "delRow" : "delCol";
					
					if (elment) {
						level    = elment.level;
						contents = elment.contents;
					}
					
					var html = "";
						html += "<div class='" + type + "' level='" + level + "'>";
						html += "<input class='" + type + "Input' value='" + contents + "'>";
						html += "<img alt='' src='/images/ezSurvey/minus.jpg' class='" + elClass + "' style='width: 30px;height: 30px; cursor: pointer;'>";
						html += "</div>";
						
					return html;
				}
				
				// 필수, 저장, 수정, 취소 버튼 생성
				function mkAddtionalPart(action, required) {
					var html = "";
						html += "<div class='additionalPart'>";
						html += "<div class='required'>";
						html += required == 'Y' ? "<input type='checkbox' name='checkbox' checked='checked'>" : "<input type='checkbox' name='checkbox'>";
						html += "<strong>" + SurveyMessages.strRequired + "</strong>";
						html += "</div>";
						html += "<div class='btns'>";
						
					if (action == config["modify"]) {
						html += "<button class='modify'>" + SurveyMessages.strModify + "</button>";
						html += "<button class='mdfCancel'>" + SurveyMessages.strCancel + "</button>";
					}
					else {
						html += "<button class='save'>" + SurveyMessages.strSaveTxt + "</button>";
						html += "<button class='cancel'>" + SurveyMessages.strCancel + "</button>";
					}
					
					html += "</div>";
					return html;
				}
				
				function makeQuestionForm(questionType) {return "<div class='qstnForm' questionType='" + questionType + "'>";}
				
				function makeTextQuestion(mainDivElmt, questionType, type, checkResult) {
					var html = makeQuestionForm(questionType);
					html    += handleModifyTextQuesion(type, "make");
					html    += mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
					
					mainDivElmt.append(html);
				}
				
				function makeSliderQuestion(mainDivElmt, questionType, checkResult) {
					var html = makeQuestionForm(questionType);
					html    += handleModifySliderQuesion();
					html    += mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
					
					mainDivElmt.append(html);
				}
				
				function makeRankingQuestion(mainDivElmt, questionType, checkResult) {
					var html = makeQuestionForm(questionType);
					html    += handleModifyRankDropDownQuesion("ranking");
					html    += mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
					
					mainDivElmt.append(html);
				}
				
				function makeDropdownQuestion(mainDivElmt, questionType, checkResult) {
					var html = makeQuestionForm(questionType);
					html    += handleModifyRankDropDownQuesion("dropdown");
					html    += mkAddtionalPart(checkResult[config["action"]], checkResult[config["required"]]);
					
					mainDivElmt.append(html);
				}
				
				function getAttachFileInfo(elmtObj) {
					var attchObj      = {};
					attchObj['fname'] = elmtObj.getAttribute("fname");
					attchObj['fpath'] = elmtObj.getAttribute("path");
					attchObj['fsize'] = elmtObj.getAttribute("fsize");
					return attchObj;
				}
				
				function isValid(value) {if (!isNaN(value) && parseFloat(value) > 0 && value % 1 === 0) {return true;} else {return false;}}
			}());
		</script>
	</body>
</html>