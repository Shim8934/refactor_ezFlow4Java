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
		
		<script type="text/javascript" src="${util.addVer('/js/ezSurvey/questionFile.js')}"></script>
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
				html += "<input class='questnTitle' value='" + qstContent + "' placeholder='내용을 입력해주세요'/>";
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
			
			// selectBox 생성
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
						
						rmQstnFormBfSave(grandParent);
						
						switch (parseInt(questionType)) {
							case 1: makeSelectQuestion(grandParent, questionType)   ; break;
							case 2: makeSelectQuestion(grandParent, questionType)   ; break;
							case 3: makeMatrixQuestion(grandParent, questionType)   ; break;
							case 4: break;
							case 5: break;
							case 6: makeParagraphQuestion(grandParent, questionType); break;
							case 7: makeSliderQuestion(grandParent, questionType)   ; break;
							case 8: makeRankingQuestion(grandParent, questionType)  ; break;
							case 9: makeDropdownQuestion(grandParent, questionType) ; break;
						}
					}
				});
			}
			
			// 셀렉트 박스 선택시
			// 셀렉트 박스에 나타낼 문구
			function getSelectedOpt(question) {
				var qstnType = parseInt(question.type);
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
			
			// 셀렉트 박스 선택시
			// 셀렉트 박스 아래의 질문 폼 삭제
			function rmQstnFormBfSave(grandParent) {
				var qstnForm = grandParent.find(".qstnForm");
				if (qstnForm.length != 0) {qstnForm.remove();}
			}
			
			// 셀렉트 박스 선택시 만들어지는 질문 폼
			// 선택 질문 생성
			function makeSelectQuestion(grandParent, questionType) {
				var html = makeQuestionForm(questionType);
					
				if (questionType == 1 || questionType == 2) {
					for (var i = 0; i < 2; i++) {
						html += "<div class='optPart'>" + mkOpt() + "</div>";
					}
				}
				
				html += "<div class='addBtns'>";
				html += "<button class='addOpt'>추가</button>";
				html += "<button class='addOther'>기타추가</button>";
				html += "</div>";
				html += mkAddtionalPart();
				grandParent.append(html);
			}
			// 셀렉트 박스 선택시 만들어지는 질문 폼
			// 행렬 질문 생성
			function makeMatrixQuestion(grandParent, questionType) {
				var html  = makeQuestionForm(questionType);
					html += "<div class='mtrPart'>";
					html += "<div class='rowArea'>";
					html += "<div class='rName' style='float: left; width: 10%;'>";
					html += "<span>행</span>";
					html += "</div>";
					html += "<div class='rows' style='float: left; width: 90%;'>";
					
					for (var i = 0; i < 2; i++) {
						html += mkRow();
					}
					
					html += "</div>";
					html += "<div class='rowBtn'>";
					html += "<button class='addRow'>추가</button>";
					html += "</div></div>";
					html += "<div class='colArea'>";
					html += "<div class='cName' style='float: left; width: 10%;'>";
					html += "<span>열</span>";
					html += "</div>";
					html += "<div class='cols' style='float: left; width: 90%;'>";
					for (var i = 0; i < 2; i++) {
						html += "" + mkCol() + "";
					}
					html += "</div>";
					html += "<div class='colBtn'>";
					html += "<button class='addCol'>추가</button>";
					html += "</div></div></div>";
					html += mkAddtionalPart();
					
				grandParent.append(html);
			}
			
			// 버튼 이벤트
			function addOptEvent() {
				/* selection 버튼 이벤트 */
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
				
				/* matrix 버튼 이벤트 */
				// matrix 행 추가
				$(".quesBacgr").on("click", ".addRow", function() {
					var html = mkRow();
					$(this).parents(".rowArea").find(".rows").append(html);
				});
				// matrix 열 추가
				$(".quesBacgr").on("click", ".addCol", function() {
					var html = mkCol();
					$(this).parents(".colArea").find(".cols").append(html);
				});
				// matrix 행 삭제
				$(".quesBacgr").on("click", ".delRow", function(e) {
					var lowLength = $(this).closest(".rows").find(".row").length;
					
					if (lowLength > 1) {
						$(this).closest(".row").remove();
						
					} else {
						alert("최소 1개 이상의 행이 필요합니다.");
					}
				});
				// matrix 열 삭제
				$(".quesBacgr").on("click", ".delCol", function() {
					var colLength = $(this).closest(".cols").find(".col").length;
					
					if (colLength > 1) {
						$(this).closest(".col").remove();
					} else {
						alert("최소 1개 이상의 열이 필요합니다.");
					}
				});
				
				/* 공통 버튼 이벤트 */
				// 첨부파일 버튼 클릭 이벤트
				$(".quesBacgr").on("click", ".attImg", function() {
					$(this).parents(".optArea").next().find(".optionFile").click();
				});
				// 첨부파일 버튼 이벤트
				$(".quesBacgr").on("change", ".optionFile", function (e) {
					fileUpload($(this), $(this)[0].files);
				});
				// 질문 생성 폼의 취소 버튼 클릭
				$(".quesBacgr").on("click", ".cancel", function() {
					$(this).parents(".qstnForm").remove();
					createQuestionSelectBox();
				});
				// 저장 버튼 클릭 이벤트
				$(".quesBacgr").on("click", ".save", function() {
					// 해당 질문의 객체 생성
					mkQstnObj("save", $(this));
				});
				// 수정 버튼 클릭 이벤트
				// 생성된 질문의 오른쪽 위에 뜬 수정 버튼 클릭시
				$(".quesBacgr").on("click", ".modifyBtn", function() {
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
					handleModifyQuestion(qstnWrapper, qstn);
					
					//수정을 취소할 경우를 고려해 숨김 처리
					qstnWrapper.css("display", "none");
				});
				// 수정 버튼 클릭 이벤트
				// 질문 객체 수정
				$(".quesBacgr").on("click", ".modify", function (e) {
					mkQstnObj("modify", $(this));
				});
				// 수정 취소 버튼 클릭 이벤트
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
			function handleModifyQuestion(qstnWrapper, question) {
				var qstType = question.type;
				var html    = makeQuestionForm(qstType);
				
				switch(parseInt(qstType)) {
					case 1  :
					case 2  : html += handleModifySelectQuestion(question); break;
					case 3  : 
					case 4  : html += handleModifyMatrixQuestion(question);break;
					case 5  : break;
					case 6  : html += handleModifyParagraphQuesion()      ; break;
					case 7  : break;
					case 8  : break;
					case 9  : break;
					default : alert(SurveyMessages.strError); return;
				}
				
				html += mkAddtionalPart(question.required, "modify");
				
				qstnWrapper.next().append(html);
			}
			
			function handleModifySelectQuestion(question) {
				var htmlTxt = "";
				var options = question.option;
				var other   = question.other;
				
				if (options) {
					for (var i = 0, len = options.length; i < len; i++) {
						htmlTxt += "<div class='optPart'>" + mkOpt("opt", options[i]) + "</div>";
					}
				}
				
				if (other) {htmlTxt += "<div class='other'>" + mkOpt("other", other) + "</div>";}
				htmlTxt += "<div class='addBtns'>";
				htmlTxt += "<button class='addOpt'>추가</button>";
				htmlTxt += "<button class='addOther'>기타추가</button>";
				htmlTxt += "</div>";
				
				return htmlTxt;
			}
//////////////////////////////////////////////////////////////////////////////			
			function handleModifyMatrixQuestion(question) {
				var html = "";
				var row = question.row;
				var col = question.col;

				html += "<div class='mtrPart'>";
				html += "<div class='rowArea'>";
				html += "<div class='rName' style='float: left; width: 10%;'>";
				html += "<span>행</span>";
				html += "</div>";
				html += "<div class='rows' style='float: left; width: 90%;'>";
				
				if (row) {
					for (var i = 0; i < row.length; i++) {
						html += mkRow(row[i]);
					}
				}
				html += "</div>";
				html += "<div class='rowBtn'>";
				html += "<button class='addRow'>추가</button>";
				html += "</div></div>";
				html += "<div class='colArea'>";
				html += "<div class='cName' style='float: left; width: 10%;'>";
				html += "<span>열</span>";
				html += "</div>";
				html += "<div class='cols' style='float: left; width: 90%;'>";
				
				if (col) {
					for (var i = 0; i < col.length; i++) {
						html += mkCol(col[i]);
					}
				}
				html += "</div>";
				html += "<div class='colBtn'>";
				html += "<button class='addCol'>추가</button>";
				html += "</div></div></div>";
				
				return html;
			}
//////////////////////////////////////////////////////////////////////////////			
			function handleModifyParagraphQuesion() {
				var htmlTxt = "<div class='paragraph-wrap'>";
				htmlTxt    += "<textarea class='paragraph' maxlength='500' placeholder='내용을 입력해주세요'></textarea>";
				htmlTxt    += "</div>";
				return htmlTxt;
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
			function rmQstnForm(wrapper) {
				//question input 및 selectBox 제거
				wrapper.find(".quesDiv").remove();
				wrapper.find(".qstnForm").remove();
			}

			// 단일선택 질문 생성 
			function mkSelectQstn(status, wrapperElmt, question) {
				var qstId       = question.id;
				var qstnContent = question.content;
				var qstnAtt     = question.attach;
				var qstnType    = question.type;
				var option      = question.option;
				var required    = question.required;
				var other       = question.other;
				
				var html = "";
				html += makeQuestionHeaderPanel(qstId, option, qstnContent, qstnContent, qstnAtt);

				html += "<div class='question-opts'>";
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
				
				wrapperElmt.prepend(html);
				
				if (status == 'save') {
					createQuestionDiv();
					createQuestionSelectBox();
				}
			}
			
			function mkMatrixQstn(status, wrapperElmt, question) {
				var qstId       = question.id;
				var qstnContent = question.content;
				var qstnAtt     = question.attach;
				var qstnType    = question.type;
				var option      = question.option;
				var required    = question.required;
				var other       = question.other
				var col 		= question.col;
				var row 		= question.row;

				var html = "";
					html += makeQuestionHeaderPanel(qstId, qstnType, qstnContent, required, qstnAtt);
					
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
					
					if (status == 'save') {
						createQuestionDiv();
						createQuestionSelectBox();
					}
			}
			
			function rmPrevEl(wrapperElmt) {wrapperElmt.prev().remove();}
			
			// 질문 객체 생성
			function mkQstnObj(status, thisEl) {
				var question     = {};
				var qstnWrapper  = thisEl.parents(".qstnWrapper");
				var qstnArea     = qstnWrapper.find(".quesDiv");
				var qstnContent  = qstnArea.find(".questnTitle").val();
				
				//Save common question information
				if (!qstnContent) {alert(SurveyMessages.strQsContent); return;}
				
				question['content']  = qstnContent;
				var qstnForm         = qstnWrapper.find(".quesDiv").next();
				var qstnType         = qstnForm.attr("questiontype");
				question['type']     = qstnType;
				var rqrd             = qstnForm.find(".additionalPart").find("input[name='checkbox']");
				question['required'] = rqrd.is(":checked") == true ? 'Y' : 'N';
				
				//Check question attach files
				var qstnFObj = qstnArea.find(".qstnFileInfo")[0].childNodes[0].childNodes[0].childNodes[0];
				
				if (qstnFObj) {question['attach']  = getAttachFileInfo(qstnFObj);}
				
				//Question order
				if (status == 'save') {
					// 질문 array에 들어있는 질문의 개수를 가져옴
					var qstnList   = SurveyCreate.getQs();
					question['id'] = qstnList.length + 1;
					SurveyCreate.setQs(question);
				}
				else if (status == 'modify') {
					rmPrevEl(qstnWrapper);
					var qstId        = qstnWrapper.attr("id");
					question['id']   = qstId;
					var questionList = SurveyCreate.getQs();
					
					questionList.splice(qstId - 1, 1);           // 질문 배열에서 해당 순번의 객체 삭제
					questionList.splice(qstId - 1, 0, question); // 질문 배열에 해당 순번에 추가
				}
				switch(parseInt(qstnType)) {
					case 1  :
					case 2  : var sltObj = mkSltObj(qstnForm);
							  if (sltObj.option) {question['option'] = sltObj.option;}
							  if (sltObj.other)  {question['other']  = sltObj.other ;}
							  mkSelectQstn(status, qstnWrapper, question); break;
					case 3  : 
					case 4  : var mtrObj = mkMtrObj(qstnForm);
							  if (mtrObj.row) {question['row'] = mtrObj.row;}
							  if (mtrObj.col) {question['col'] = mtrObj.col;}
							  mkMatrixQstn(status, qstnWrapper, question); break;
					case 5  : break;
					case 6  : mkParagraphQstn(status, qstnWrapper, question); break;
					case 7  : break;
					case 8  : break;
					case 9  : break;
					default : alert(SurveyMessages.strError); return;
				}
				
				rmQstnForm(qstnWrapper);
			}
			
			function mkParagraphQstn(status, wrapperElmt, question) {
				var qstId       = question.id;
				var qstnContent = question.content;
				var qstnType    = question.type;
				var required    = question.required;
				var html        = "";
				html           += makeQuestionHeaderPanel(qstId, qstnType, qstnContent, required, null);
				html           += "<div class='question-paragraph'>";
				html           += "<textarea class='paragraph' maxlength='500' placeholder='내용을 입력해주세요'></textarea>";
				html           += "</div></div>";
				
				wrapperElmt.prepend(html);
				
				if (status == 'save') {createQuestionDiv(); createQuestionSelectBox();}
			}
			
			function makeQuestionHeaderPanel(qstId, qstnType, qstnContent, required, qstnAtt) {
				var htmlTxt = "";
				htmlTxt    += "<div class='usrQstnWrapper' id='" + qstId + "' qstnType='" + qstnType + "'>";
				htmlTxt    += "<div class='question-panel'>";
				htmlTxt    += "<div class='mvBtn'></div>";
				htmlTxt    += "<div class='question-header'>";
				htmlTxt    += "<div class='question-content'>" + qstId + ". " + qstnContent;
				htmlTxt    += required == 'Y' ? "<strong class='imptt'>*</strong></div>" : "</div>";
				htmlTxt    += "<div class='tooltip-bttns'>";
				htmlTxt    += "<span class='modifyBtn'></span>";
				htmlTxt    += "<span class='copyBtn'></span>";
				htmlTxt    += "<span class='deleteBtn'></span>";
				htmlTxt    += "</div></div>";
				
				if (qstnAtt) {
					htmlTxt += "<div class='question-attach'>"
					htmlTxt += "<img alt='' src='" + qstnAtt.fpath + "' class='qstnImg'>";
					htmlTxt += "</div>"
				}
				
				return htmlTxt;
			}
			
			// select 질문 객체 생성
			function mkSltObj(qstnForm) {
				var sltObj = {};
				var opt    = qstnForm.find(".optPart");
				var oth    = qstnForm.find(".other");
				var optCnt = opt.length;
				
				// 보기의 개수 확인
				if (optCnt > 0) {
					var option = [];
					
					for (var i = 0; i < optCnt; i++) {
						var optObj      = {};
						var optVal      = opt[i].childNodes[0].childNodes[0].childNodes[0].value; // 보기가 비어있는지 확인
						optObj['level'] = i;
						
						if (optVal) {optObj['contents'] = optVal;}
						
						// 첨부 파일이 있는지 확인
						var fObj = opt[i].childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[0];
						if (fObj) {optObj['optionAttach'] = getAttachFileInfo(fObj);}
						
						option.push(optObj);
					}
					
					sltObj['option'] = option;
				}
				
				// 기타의 유무 확인
				if (oth.length != 0) {
					var other  = {};
					var othVal = oth[0].childNodes[0].childNodes[0].childNodes[0].value;
					var othObj = oth[0].childNodes[0].childNodes[1].childNodes[0].childNodes[0].childNodes[0];
					
					if (othVal) {other['contents']    = othVal;}
					if (othObj) {other['otherAttach'] = getAttachFileInfo(othObj);}
					
					sltObj['other'] = other;
				}
				
				return sltObj;
			}
			
			// matrix 질문 객체 생성
			function mkMtrObj(qstnForm) {
				var rows   = qstnForm.find(".row");
				var cols   = qstnForm.find(".col");
				var mtrObj = {};
				
				if (rows) {
					var row = [];
					
					for(var i = 0, len = rows.length; i < len; i++) {
						var rowObj         = {};
						var rowVal         = rows[i].childNodes[0].value;
						rowObj['level']    = i;
						rowObj['contents'] = rowVal;
						
						row.push(rowObj);
					}
					mtrObj['row'] = row;
				}
				
				if (cols) {
					var col = [];
					
					for(var i = 0; i < cols.length; i++) {
						var colObj         = {};
						var colVal         = cols[i].childNodes[0].value;
						colObj['level']    = i;
						colObj['contents'] = colVal;
						
						col.push(colObj);
					}
					mtrObj['col'] = col;
				}
				
				return mtrObj;
			}
			
			// option 생성
			function mkOpt(type, options) {
				var optAtt = "";
				var attEl  = "";
				var html   = "";
					html  += "<div class='optArea'>";
					html  += "<div class='option'>";
					
				if (type == 'other') {
					if (options) {
						html += "<input class='textInput' type='text' value='" + options.contents + "'/>";
						
						optAtt = options.otherAttach;
					} else {
						html += "<input class='textInput' type='text' placeholder='기타'>";
					}
				}
				else {
					if (options) {
						html += "<input class='textInput' type='text' value='" + options.contents + "'/>";
						
						optAtt = options.optionAttach;
					} else {
						html += "<input class='textInput' type='text' placeholder='내용을 입력해주세요'/>";
					}
				}
				
				html += "<img src='/images/ezSurvey/attach.png' class='attImg'>";
				html += "<img src='/images/ezSurvey/minus.jpg' class='delImg'>";
				html += "</div>";
				html += "<div class='optFileInfo'>";
				html += "<div>";
				
				if (optAtt) {
					attEl = mkImgTag(optAtt);
				}
				
				html += "<ul>" + attEl + "</ul>";
				html += "</div></div></div>";
				html += "<div class='optAtt'>";
				html += "<input type='file' class='optionFile' style='display:none;'/>";
				html += "</div>";
				
				return html;
			}
			
			function mkRow(row) {
				var contents = "";
				var level = "";

				if (row) {
					level = row.level;
					contents = row.contents;
				}
				
				var html = "";
					html += "<div class='row' level='" + level + "'>";
					html += "<input class='rowInput' value='" + contents + "'>";
					html += "<img alt='' src='/images/ezSurvey/minus.jpg' class='delRow' style='width: 30px;height: 30px; cursor: pointer;'>";
					html += "</div>";
				
				return html;
			}
			
			// 열 생성
			function mkCol(col) {
				var contents = "";
				var level = "";

				if (col) {
					level = col.level;
					contents = col.contents;
				}
				
				var html = "";
					html += "<div class='col' level='" + level + "'>";
					html += "<input class='colInput' value='" + contents + "'>";
					html += "<img alt='' src='/images/ezSurvey/minus.jpg' class='delCol' style='width: 30px;height: 30px; cursor: pointer;'>";
					html += "</div>";
				
				return html;
			}
			
			// 필수, 저장, 수정, 취소 버튼 생성
			function mkAddtionalPart(required, action) {
				var html = "";
					html += "<div class='additionalPart'>";
					html += "<div class='required'>";
					html += required == 'Y' ? "<input type='checkbox' name='checkbox' checked='checked'>" : "<input type='checkbox' name='checkbox'>";
					html += "<strong>필수 답변</strong>";
					html += "</div>";
					html += "<div class='btns'>";
					
				if (action == 'modify') {
					html += "<button class='modify'>수정</button>";
					html += "<button class='mdfCancel'>취소</button>";
				}
				else {
					html += "<button class='save'>저장</button>";
					html += "<button class='cancel'>취소</button>";
				}
				
				html += "</div>";
				
				return html;
			}
			
			function makeQuestionForm(questionType) {return "<div class='qstnForm' questionType='" + questionType + "'>";}
			
			function makeParagraphQuestion(mainDivElmt, questionType) {
				var html = makeQuestionForm(questionType);
				html    += handleModifyParagraphQuesion();
				html    += mkAddtionalPart();
				
				mainDivElmt.append(html);
			}
			
			function makeSliderQuestion(mainDivElmt, questionType) {
				var html = makeQuestionForm(questionType);
				html += "<div class='silder-wrap'>";
				html += "<input type='input' class='slider-input'/>";
				html += "<input type='range' class='slider-main' />";
				html += "<input type='input' class='slider-input'/>";
				html += "</div>";
				html += "<div class='additionalPart'>";
				html += "<div class='required'>";
				html += "<input type='checkbox' name='checkbox'>";
				html += "<strong>필수 답변</strong>";
				html += "</div>";
				html += "<div class='btns'>";
				html += "<button class='save'>저장</button>";
				html += "<button class='cancel'>취소</button>";
				html += "</div></div>";
				
				mainDivElmt.append(html);
			}
			
			function makeRankingQuestion(mainDivElmt, questionType) {
				var html = makeQuestionForm(questionType);
				html += "<div class='ranking-wrap'>";
				html += "<div class='ranking-select'>";
				html += "<span class='ranking-order'>1</span>";
				html += "<input class='textInput' type='text' placeholder='내용을 입력해주세요'/>";
				html += "<span class='ranking-del'></span>";
				html += "</div>";
				html += "<div class='ranking-select'>";
				html += "<span class='ranking-order'>2</span>";
				html += "<input class='textInput' type='text' placeholder='내용을 입력해주세요'/>";
				html += "<span class='ranking-del'></span>";
				html += "</div>";
				html += "<div class='ranking-select'>";
				html += "<span class='ranking-order'>3</span>";
				html += "<input class='textInput' type='text' placeholder='내용을 입력해주세요'/>";
				html += "<span class='ranking-del'></span>";
				html += "</div>";
				html += "<div class='addBtns'>";
				html += "<button class='addOpt'>추가</button>";
				html += "</div>";
				html += "<div class='additionalPart'>";
				html += "<div class='required'>";
				html += "<input type='checkbox' name='checkbox'>";
				html += "<strong>필수 답변</strong>";
				html += "</div>";
				html += "<div class='btns'>";
				html += "<button class='save'>저장</button>";
				html += "<button class='cancel'>취소</button>";
				html += "</div></div>";
				
				mainDivElmt.append(html);
			}
			
			function makeDropdownQuestion(mainDivElmt, questionType) {
				var html = makeQuestionForm(questionType);
				html += "<div class='dropdown-wrap'>";
				html += "<div class='dropdown-select'>";
				html += "<span class='dropdown-order'>1</span>";
				html += "<input class='textInput' type='text' placeholder='내용을 입력해주세요'/>";
				html += "<span class='dropdown-del'></span>";
				html += "</div>";
				html += "<div class='dropdown-select'>";
				html += "<span class='dropdown-order'>2</span>";
				html += "<input class='textInput' type='text' placeholder='내용을 입력해주세요'/>";
				html += "<span class='dropdown-del'></span>";
				html += "</div>";
				html += "<div class='dropdown-select'>";
				html += "<span class='dropdown-order'>3</span>";
				html += "<input class='textInput' type='text' placeholder='내용을 입력해주세요'/>";
				html += "<span class='dropdown-del'></span>";
				html += "</div>";
				html += "<div class='addBtns'>";
				html += "<button class='addOpt'>추가</button>";
				html += "</div>";
				html += "<div class='additionalPart'>";
				html += "<div class='required'>";
				html += "<input type='checkbox' name='checkbox'>";
				html += "<strong>필수 답변</strong>";
				html += "</div>";
				html += "<div class='btns'>";
				html += "<button class='save'>저장</button>";
				html += "<button class='cancel'>취소</button>";
				html += "</div></div>";
				
				mainDivElmt.append(html);
			}
			
			function getAttachFileInfo(elmtObj) {
				var attchObj      = {};
				attchObj['fname'] = elmtObj.getAttribute("fname");
				attchObj['fpath'] = elmtObj.getAttribute("path");
				attchObj['fsize'] = elmtObj.getAttribute("fsize");
				return attchObj;
			}
		}());
		
		</script>
	</body>
</html>