<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>${vo.title}</title>
	<link rel="stylesheet" href="<spring:message code='ezLadder.e2' />" type="text/css">
	<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css" type="text/css">
	<link rel="stylesheet" href="/css/ezPoll/vote.css" type="text/css">
	<link rel="stylesheet" href="/css/ezLadder/ladderPreList.css" type="text/css">
	<script type="text/javascript" src="<spring:message code='ezLadder.e1'/>"></script>
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
	<script type="text/javascript" src="/js/ezPoll/stomp.min.js"></script>
	<script type="text/javascript" src="/js/ezPoll/sockjs.min.js"></script>
	<script type="text/javascript" src="/js/ezLadder/ladder.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript">
	
		var _ladder;
		var _ladderLine;
		var ladderId;
		var writerId;
		var status;
		var lineCnt;
		var id = "${id}";
		var searchSelect = "${searchSelect}";
		var searchInput =  "${searchInput}";
		var mode = "${mode}";
		var currPage = "${currPage}";
		var back = "back";
		var allData = [];
		var dragloc = {};
		var droploc = {};
		var stompClient = null;
		var servername = null;
		var deleteFlag = "${vo.deleteFlag}";
		var sort = "${sort}";
		var sortFlag = "${sortFlag}";
		
		$(window).unload(function() {
			if (stompClient !== null) {
				stompClient.disconnect();
			}
		});
		
		/** 페이지 들어갔을때 스크롤 사다리 위쪽으로 바로 이동시켜주는 펑션 */
		/* window.onload = function() {
			var firstScrollTop = $("#attendantList").offset().top - 5;
			$("html, body").animate({"scrollTop": firstScrollTop}, 300);
		} */
		
		var dragcnt = 0;
		var originalPosition_left = 0;
		$(function() {
			if(deleteFlag == 1) {
				window.location.href = "/ezLadder/ladderMain.do?brdID=7"; 
			}
			initValues();
			ladder_window_resize();
			
			if(status == 0) {
				var usernum = _ladderLine.length;
				add_user_change_ulsize(usernum);
				changeUser(usernum);
				
				if(writerId == id) {
					// 대기상태
					$(".ladderDrag")
					.draggable({ // 드래그 리스트
						revert: "invalid",
						revertDuration: 400,
						zIndex: 100,
						addClasses: false,
						start: function(event, ui) {
							if(dragcnt == 0) {
								originalPosition_left = ui.originalPosition.left;
								dragcnt++;
							}
							dragloc = {"id": ui.helper[0].id, "beforeLeft": 0, "left": 0, "top": ui.originalPosition.top};
							if(ui.position.left >= 0) {
								dragloc.beforeLeft = Math.round(ui.position.left/150);
							} else {
								dragloc.beforeLeft = Math.round(Math.abs(ui.position.left/150)) * -1;
							}
						}
					})
					.droppable({ // 드랍 리스트
						accept: ".ladderDrag",
						addClasses: false,
						drop: function(event, ui) {
							droploc = {"id": $(this).attr("id"), "left": 0};
							
							var _thisleft = Math.round($(this).css("left").split("px")[0]/150);
							
							if(ui.position.left >= 0) {
								dragloc.left = Math.round(ui.position.left/150);
							} else {
								dragloc.left = Math.round(Math.abs(ui.position.left/150)) * -1;
							}
							
							var moveValue = dragloc.left - dragloc.beforeLeft;
							droploc.left = _thisleft - moveValue;
							
							afterDrag();
							changeListOrder();
						},
						
					});
				}
			} else if(status == 1) {
				// 완료상태
				canvasSetting();
			}
			
			if(mode !== "preview" && (!stompClient || !stompClient.connected)) {
				// 프리뷰가 아닐때, 웹소켓이 끊겼을때 웹소켓 연결
				getCmtSockConnect();
			}
			
			$(window).resize(function() {
				ladder_window_resize();
			});
			
			$(document)
				.on("click", function() {
					showEditPanel();
				})
				.on("click", "img[name='editComtButton']", function(event) {
					event.stopPropagation();
					showEditPanel($(this).attr("_comtIndex"));
				})
				.on("click", "#sendBttn", function() {
					addComt($("#comment_input").val());
				})
				.on("click", "[id^='_eCmt']", function() {
					modifyComt($(this).attr("_comtIndex").slice(8));
				})
				.on("click", "[id^='clA1cmt']", function() {
					modifyComt($(this).attr("_comtIndex"));
				})
				.on("click", "[id^='clA2cmt']", function() {
					modifyComt($(this).attr("_comtIndex"), true);
				})
				.on("click", "[id^='_dCmt']", function() {
					deleteComt($(this).attr("_comtIndex"));
				})
				.on("click", "#autoDirection", function() {
					// 사다리 자동 진행
					clickUserOrder = 0;
					aniAllUser();
				})
				.on("click", "#immediatelyDirection", function() {
					// 사다리 바로 보기
					clickUserOrder = 0;
					popAllUser();
				})
				.on("mouseenter", "[id^='drag']", function() {
					/* var $this = $(this); */
					var $span = $(this).find("span");
					$span.css("border-color", "#2568b3");
					if($span.hasClass("userPicWraper_d")) {
						$span.find("img").attr("src", "/images/ezLadder/icon_defaultAttendant_hover.png");
					}
				})
				.on("mouseleave", "[id^='drag']", function() {
					/* var $this = $(this); */
					var $span = $(this).find("span");
					$span.css("border-color", "#ccc");
					if($span.hasClass("userPicWraper_d")) {
						$span.find("img").attr("src", "/images/ezLadder/icon_defaultAttendant.png");
					}
				})
				$("#toList").on("click", function() {
					window.location.href = '/ezLadder/ladderMain.do?&mode=' + mode + '&currPage=' + currPage + '&searchSelect=' 
							+ searchSelect + '&searchInput=' + searchInput + '&sort=' + sort + '&sortFlag=' + sortFlag;
				});
				
			$("#usePreladder").on("click", function() {
				window.location.href = "/ezLadder/setLadder.do?ladderId=" + ${vo.ladderId};
			});
		});
		
		function ladder_window_resize() {
			var win_width = $(window).width() - 70;
			var line_width = $("#attendantList").css("width").replace(/[^0-9]/g,'') * 1;
			var title_width = win_width - $(".ladderGame_info").width();
			
			var $setTable = $(".setTable");
			var $lineBox = $("#ladderLineBox");
			var $startButton = $("#startButton");
			
			$lineBox.css("width", win_width + "px");
			$(".ladderGame_title").css("width", title_width);
			
			if(line_width > win_width) {
				$("#blackBox").css("width", (line_width + 100) + "px");
			} else {
				$("#blackBox").css("width", (win_width + 50) + "px");
			}
			
			$("#startButton")
				.css("left", $setTable.width() / 2 - $startButton.width() / 2)
				.css("top", ($setTable.height() - $lineBox.height()) + ($lineBox.height() / 2 - $startButton.height() / 2));
		}
		
		function initValues() {
			_ladder = ${vo};
			_ladderLine = ${list};
			
			ladderId = _ladder.ladderId;
			writerId = _ladder.writerId;
			status = _ladder.status;
			lineCnt = _ladder.lineCnt;
		}
		
		function afterDrag() {
			$("#" + dragloc.id).css("z-index", "10").animate({"left": originalPosition_left + dragloc.left * 150, "top": dragloc.top}, 400);
			$("#" + droploc.id).css("z-index", "10").animate({"left": originalPosition_left + droploc.left * 150}, 400);
		}
		
		/** 참여자 위치 바꾸기 */
		function changeListOrder() {
			var ladId1 = dragloc["id"].substring(4); //5
			var ladId2 = droploc["id"].substring(4); //0
			var ladorder1 = _ladderLine[ladId1].ladderOrder; //5
			var ladorder2 = _ladderLine[ladId2].ladderOrder; //0
			
			$.ajax({
				type: "POST",
				url: "/ezLadder/serUserOrder.do",
				dataType: "json",
				traditional: true,
				async : false,
				data: {
					"ladderId": ladderId,
					"firstUser": _ladderLine[ladId1].lineId,
					"firstUserOrder": ladorder1,
					"secondUser": _ladderLine[ladId2].lineId,
					"secondUserOrder": ladorder2,
					"firstItem": _ladderLine[ladId1].item,
					"secondItem": _ladderLine[ladId2].item
				},
				success: function() {
					_ladderLine[ladId1].ladderOrder = ladorder2; // 0
					_ladderLine[ladId2].ladderOrder = ladorder1; // 5
				}
			});
		}
		
		function add_user_change_ulsize(usernum) {
			$("#ladderLineBox ul").css("width", (usernum * 150) + "px");
			$("#ladderCanvas").attr("width", (usernum * 150) + "px");
		}
		
		/** 웹소켓 */
		var addCommentView = [];
		function getCmtSockConnect() {
			servername = location.hostname;
			var sock = new SockJS("/hello");
			stompClient = Stomp.over(sock);
			stompClient.connect({}, function() {
				stompClient.subscribe("/lad/cmt/addCmt/" + ladderId, function(result) { // add comment
					var cmtjson = JSON.parse(result.body);
				
					setCommentComplete(cmtjson["flag"], cmtjson["commentId"]);
				});
				stompClient.subscribe("/lad/cmt/modifyCmt/" + ladderId, function(result) { // modify comment
					var cmtjson = JSON.parse(result.body);
					
					setCommentComplete(cmtjson["flag"], cmtjson["commentId"]);
				});
				stompClient.subscribe("/lad/cmt/deleteCmt/" + ladderId, function(result) { // delete comment
					var cmtjson = JSON.parse(result.body);
					
					$("tr[_comtIndex='" + cmtjson["commentId"] + "']").remove();
				});
				stompClient.subscribe("/lad/userOrder/change/" + ladderId, function(result) {	// 참여자 위치 바꾸기 subscribe
					var cmtjson = JSON.parse(result.body);
				
					if(cmtjson.ladderWriter != id) {
						var dragLiPos = $("[_attendantindex='" + cmtjson.dragOrder + "']").position();
						var dropLiPos = $("[_attendantindex='" + cmtjson.dropOrder + "']").position();
						var moveDragObj = "";
						var moveDropObj = "";
						var moveDragLeft = 0;
						var moveDropLeft = 0;
						
						for(var i = 0; i < $("#attendantList li").length; i++) {
							if($("#drag" + i).position().left == dragLiPos.left) {
								moveDragObj = "#drag" + i;
								moveDragLeft = cmtjson.dropOrder - i;
							}
							if($("#drag" + i).position().left == dropLiPos.left) {
								moveDropObj = "#drag" + i;
								moveDropLeft = cmtjson.dragOrder - i;
							}
						}
						
						$(moveDragObj).css("z-index", "10").css("position", "relative").animate({"left": moveDragLeft * 150}, 400);
						$(moveDropObj).css("z-index", "10").css("position", "relative").animate({"left": moveDropLeft * 150}, 400);
					}
				});
				stompClient.subscribe("/lad/start/" + ladderId, function(result) {	
					loadLadder();
					
					if(result.body == id) {
						$(".ladderDrag").draggable("destroy");
					}
				});
			});
		}
		function canvasSetting() {
			wInfo = _ladderLine.length;
			lad = _ladder["lineArray"];
			lineCnt = _ladder["lineCnt"];
			
			if(!!lad) {
				ladArr = lad.split('');
				clickUserLadderAnimation();
			}
			
			$("canvas").attr("width", (wInfo * wSize));
			$("#ladderLineBox").css("padding-bottom", "50px");
			
			ladderDrawInitSettingVar();
			setLadInfo();
			setDefaultLad();
			printLadLine();
			setUserPath();
		}
		
		function clickUserLadderAnimation() {
			$(document)
			.on("click", "[id^=drag]", function() {
				clickUserOrder = Number($(this).attr("id").slice(4));
				
				if(userStatus[clickUserOrder] == 0) {
					aniOneUser();
				} else {
					popOneUser();
				}
			});
		}
		function ladderAnimationComplete(type) {
			var $moveImgUser;
			var $resultLi = $("#itemList li:eq(" + resultOrder + ")");
			var $resultDiv = $("#itemList li:eq(" + resultOrder + ")").find("div");
			
			$(".resultItem").css({"background": "#ffffff"});
			$(".resultUser").css({"background": "#f2f2f2", "color": "#000000"});
			
			$resultDiv.eq(0).css({"outline": "1px solid #2568b3", "background": "#ffffff", "color" : "#2568b3"});
			if($resultDiv.length == 1) {
				var html = "<div title='" + _ladderLine[clickUserOrder].userName + "' class='resultUser' style='line-height: 30px; height: 30px; background: #0470e4; color: #ffffff; margin-top: 10px; border-radius: 15px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + _ladderLine[clickUserOrder].userName + "</div>";
				$resultLi.append(html);
				$moveImgUser = $("#moveImgUser" + clickUserOrder);
			} else {
				$resultDiv.eq(1).css({"background": "#2568b3", "color": "#ffffff"});
				$moveImgUser = $("#copyUser");
			}
			
			if(type.substring(0, 3) == "ani" || type.substring(3, 6) == "one") {
				var scrollval = (resultOrder * 150 - $("#ladderLineBox").width()/2) + 75;
				$("#ladderLineBox").animate({"scrollLeft": scrollval}, 400);
			} else {
				$(".resultItem").css({"background": "#ffffff"});
				$(".resultUser").css({"background": "#f2f2f2", "color": "#000000"});
			}
			
			if($moveImgUser.attr("_result") == "0") {
				$moveImgUser.animate({top:$moveImgUser.position().top - moveImgHalfHeight}, 400);
			}
			
			$("#copyUser").remove();
			$moveImgUser.attr("_result", userStatus[clickUserOrder]);
		}
		
		/** 삭제 */
		function deleteLadder(idx) {
			allData = [idx, searchSelect, searchInput, mode, currPage, back ];	
		
			if (confirm(strLang16)) {
				window.location.href= '/ezLadder/deleteLadder.do?allData=' + allData;
			} 
		}
		/** 사다리 시작 (대기->완료) */
		function start(idx) {
			allData = [idx, searchSelect, searchInput, mode, currPage, _ladderLine.length, lineCnt ];	
			if (confirm(strLang17)) {
				jQuery.ajaxSettings.traditional = true;
				$.ajax({
					type: "POST",
					url: "/ezLadder/setLadderStart.do",
					dataType: "json",
					async: false,
					data: {
						"allData": allData
					}
				});
			}
		} 
		function loadLadder() {
			$.ajax({
				url: "/ezLadder/getLadderGame.do",
				dataType: "json",
				async: false,
				data: {
					"ladderId": ladderId,
					"searchSelect": searchSelect,
					"searchInput": searchInput,
					"mode": "pre",
					"currPage": currPage
				},
				success: function(ladderInfo) {
					_ladder = ladderInfo["vo"];
					_ladderLine = ladderInfo["list"];
					status = _ladder.status;
					
					$("#lineDiv")
						.css("height" , "675px")
						.html(
							"<span></span>" +
							"<canvas id='ladderCanvasLine' width='0' height='675'></canvas>" +
							"<canvas id='ladderCanvas' width='0' height='675'></canvas>"
						);
					$(".directionBtn").html(
							'<button id="immediatelyDirection" class="direcDiv" align="center" style="right: 5px; background: darkcyan;"><div class="direcTextDiv"><spring:message code="ezLadder.t056" /></div></button>' +
							'<button id="autoDirection" class="direcDiv" align="center" style="right: 160px; background: salmon;"><div class="direcTextDiv"><spring:message code="ezLadder.t057" /></div></button>'
					);
					$("#immediatelyDirection").removeAttr("disabled").css({"background" : "darkcyan", "cursor" : "pointer"});
					$("#autoDirection").removeAttr("disabled").css({"background" : "salmon", "cursor" : "pointer"});
					$("#direcTextDiv").css("color", "#000000")
					
					var html = '';
					_ladderLine.forEach(function(line, index) {
						var picsrc = !line.pic ? "/images/ezLadder/icon_defaultAttendant.png" : "/admin/ezOrgan/getPersonalInfo.do?fileName=" + line.pic;
						html += '<li><div id="drag' + index + '" style="cursor: pointer;">';
						if(!line.pic) {
							html += '<span class="userPicWraper_d"><img src="/images/ezLadder/icon_defaultAttendant.png" width="48px" height="48px" style="display: block;" /></span>';
						} else {
							html += '<span class="userPicWraper"><img src="' + picsrc + '" width="48px" height="48px" /></span>';
						}
						html += '<div title="' + line.userName + '" style="line-height: 30px; background: white; height: 30px; margin-top: 10px; overflow: hidden; text-overflow: ellipsis;"><span style="white-space: nowrap">' + line.userName + '</span></div></div></li>';
					});
					$("#attendantList").html(html);
					canvasSetting();
					$("#blackBox, #startButton").remove();
				}
			});
		}
		/** 댓글 */
		function setComment(flag, cmtId, comment) { // 댓글 추가, 수정, 삭제 (flag: add, modify, delete)
			$.ajax({
				type: "POST",
				url: "/ezLadder/setLadderComment.do",
				dataType: "json",
				data: {
					"flag": flag,
					"commentId": cmtId,
					"ladderId": ladderId,
					"comment": comment
				}
			});
		}
		function setCommentComplete(flag, cmtId) {
			$.ajax({
				type: "GET",
				url: "/ezLadder/getLadderComment.do",
				dataType: "json",
				data: {
					"ladderId": ladderId,
					"commentId": cmtId
				},
				success: function(data) {
					var cmt = data["myComment"];
					var picsrc = !cmt["pic"] ? "/images/ezLadder/icon_defaultAttendant.png" : "/admin/ezOrgan/getPersonalInfo.do?fileName=" + cmt["pic"];
					if(flag == "add") { 
						// add
						var html = '<tr style="border-bottom: 1px dotted #ddd;" _comtIndex="' + cmt["id"] + '">';
						html += '<td style="padding: 0px 0px 0px 10px; width: 24px; height: 24px; vertical-align:top; "><div style="width: 38px; height: 38px; overflow: hidden; border: 1px solid #DDD; border-radius: 20px; margin-top: 10px; cursor: pointer;" onclick="menuQst_DetailUserInfo(\'' +  cmt["userId"] + '\')"><img src="' + picsrc + '" style="height: 38px; width:38px;"></div></td>';
						html += '<td><div class="userName">' + cmt["userName"] + '</div>';
						html += '<div id="div2Cmt' + cmt["id"] + '" style="display: inline-block; height: auto; padding:10px 0px 10px 20px; max-width: 1300px;" >';
						html += '<p id="cmtArea' + cmt["id"] + '" style="word-break: break-all; margin-top: 0px;margin-bottom: 0px;"></p></div>';
						html += '<div id="editCmtDiv' + cmt["id"] + '" style="display: none;"></div></td>';
						html += '<td style="width: 145px; position:relative;">';
						html += '<div style="position: absolute; top:10px; right:18px; color:#a3a3a3; white-space:nowrap;">' + cmt["writeDate"] + '</div></td></tr>';
						cmt["comment"] = cmt["comment"].replace(/(?:\r\n|\r|\n)/g, '<br />');
					
						$("#commentArea table").prepend(html);
						$("#cmtArea" + cmt["id"]).html(cmt["comment"]);
						
						if(id == cmt["userId"]) {
							html = '<img src="/images/option3.png" style="margin:30px 10px 0px 0px; position:absolute;top:0;right:0; padding:0px; cursor: pointer;" height=25 width=25 vertical-align="middle" name="editComtButton" _comtIndex="editComt' + cmt["id"] + '" />';
							html += '<div id="editComt' + cmt["id"] + '" style="float:right; display: none; position: absolute; top:30px; right:28px; z-index: 10 ; border: 1px solid #ddd; background-color: #576652; color: white; width: 120px;" tabindex=0>';
							html += '<div id="_eCmt' + cmt["id"] + '" _comtIndex="editComt' + cmt["id"] + '" style="border-bottom: 1px solid #ddd; text-align: center; padding:6px 0px; color:#333; background:#eaeaea; cursor: pointer;"><spring:message code="ezLadder.t062" /> <spring:message code="ezLadder.t052" /></div>';
							html += '<div id="_dCmt' + cmt["id"] + '" _comtIndex="' + cmt["id"] + '" style="text-align: center; padding:6px 0px; background:#eaeaea; color:#333; cursor: pointer;"><spring:message code="ezLadder.t062" /> <spring:message code="ezLadder.t053" /></div></div>';
							
							$("[_comtindex='" + cmt["id"] + "'] td:last").append(html);
							
							var comtInputTop = $("#sendComment").offset().top;
							$(document).scrollTop(comtInputTop); 
						}
					} else { 
						// modify
						if(id == cmt["userId"]) {
							modifyComt(cmt["id"]);
						}
						cmt["comment"] = cmt["comment"].replace(/(?:\r\n|\r|\n)/g, '<br />');
						$("#cmtArea" + cmt["id"]).html(cmt["comment"]);
					}
				}
			});
		}
		
		/** 댓글 편집 패널 토글 */
		var editComtFlag = -1;
		function showEditPanel(editComtID) {
			if(!!editComtID) {
				var cmtID = editComtID.slice(8);
				
				if(editComtFlag == cmtID) {
					editComtFlag = -1;
				} else {
					$("#editComt" + editComtFlag).hide();
					editComtFlag = cmtID;
				}
				$("#" + editComtID).toggle();
			} else {
				$("div[id^='editComt']").hide();
				editComtFlag = -1;
			}
		}
		/** 댓글 입력 */
		function addComt(comment) {
			if(!!comment) {
				$("#comment_input").val("");
				$("#sendBttn").css("background", "#d0d0d0").attr("disabled", true);
				setComment("add", 0, comment);
			}
		}
		/** 댓글 수정 */
		function modifyComt(comtIndex, submitFlag) {
			if(submitFlag) {
				var comment = $("#editCmtArea" + comtIndex).val();
				$("#editCmtArea" + comtIndex).text("");
				
				setComment("modify", comtIndex, comment);
				return;
			}
			
			var html = '';
			if(editComtFlag == comtIndex) {
				$("[id^=div2Cmt], [id^=_eCmt]").show();
				$("[id^=editCmtDiv]").hide();
				var editTemp= $("#cmtArea" + editComtFlag).html();
				editTemp = editTemp.replace(/(<br>|<br\/>|<br \/>)/g, '\r\n');
				
				html += '<div style="display: inline-block; width: 100%; margin-top: 5px;">';
				html += '<div style="display: block; float:left; border:1px solid #ddd;padding: 0 5px;;margin-left: 20px; border-radius: 3px; width: 95%; height: 30px; overflow: hidden;">';
				html += '<textarea id="editCmtArea' + editComtFlag + '" cols="20" rows="1" style="display: inline-block; overflow-y: auto; outline: none; border: none; resize: none; padding: 0; margin: 5px 0; height: 20px; width: 100%; line-height: 20px;" maxlength="500">';
				html += editTemp + '</textarea></div></div>';
				html += '<div style="padding: 5px 0px 5px 20px; clear: both;">';
				html += '<button id="clA1cmt' + editComtFlag + '" class="voteCancelBttn" _comtindex="' + editComtFlag + '" style="width: 46px;"><spring:message code="ezLadder.t087" /></button>';
				html += '<button id="clA2cmt' + editComtFlag + '" class="voteSaveBttn" _comtindex="' + editComtFlag + '"><spring:message code="ezLadder.t072" /></button></div>';
			} 
			
			$("#div2Cmt" + comtIndex).toggle();
			$("#_eCmt" + comtIndex).toggle();
			$("#editCmtDiv" + comtIndex).html(html).toggle();
			
		}
		/** 댓글 삭제 */
		function deleteComt(comtIndex) {
			var result = confirm("<spring:message code='ezLadder.t051' />");
			
			if(result) {
				setComment("delete", comtIndex, "");
			}

		}
		function auto_grow(element) {
			if (element.value == "") {
				document.getElementById("sendBttn").style.backgroundColor = "#d0d0d0";
				document.getElementById("sendBttn").disabled = true;
			}
			else {
				document.getElementById("sendBttn").style.backgroundColor = "#0470e4";
				document.getElementById("sendBttn").disabled = false;
			}
		}
		
		function menuQst_DetailUserInfo(pUserID) {
			var feature = GetOpenPosition(420, 438);
		    window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		}	
	</script>
	<style type="text/css">
		ul {
		    list-style:none;
		    margin:0;
		    padding:0;
		    float: left;
		}
		
		li {
		    margin: 0 0 0 0;
		    padding: 0 0 0 0;
		    border : 0;
		    float: left;
		    text-align: center;
		}
		.dim{
    		width: 100%;
    		height: 100%;
    		position: absolute;
    		top: 0;
    		left: 0;
		}
		.node{
		    width: 0px;
		    height: 0px;
		    background-color: #000;
		}
		.ladder_canvas{
		    z-index: 999;
		}
		.ladder{
		    position: absoulute;
		    margin-top: 130px;
		    margin-bottom: 20px;
		    margin-left: 50px;
		    z-index: 0;
		}
		.cmtdelete, .cmtmodify {
			cursor: pointer;
		}
		.cmtdelete:HOVER, .cmtmodify:HOVER {
			background: beige;
		}
		
		.directionBtn {			
			position: relative;
			margin-top: 8px;
		}
		
		.direcDiv {
			height: 50px;
			width: 150px;
			position: absolute;
			top: 0;
			border-radius: 15px;
			cursor: pointer; 
			padding: 0;
			border: 0;
		}
		
		.direcTextDiv {
			width: 100%;
			height: 30px;
			top: 12px;
			background: #f2f2f2;
			line-height: 29px;
			position: absolute;
		}
		
		.resultUsers {
			color: white;
			font-style: italic;
			background: #000;
			font-size: 1rem;
			position: relative;
			top: -10px;
			line-height:30px;
			text-align: center;
			float: left;
		}
		.icon {
			border: 1px solid #dddddd;
			border-radius: 15px;
			margin-left: 5px;
		}
		.name {
			color : #000;
			font-size: 14px;
			padding-top: 3px;
		}
		.team {
			color : #000;
			padding-top: 5px;
		}
		.date {
			color: #aaa9a9;
			padding-top: 6px;
		}
	</style>
</head>
	<body class="mainbody">
		<h1><spring:message code='ezLadder.t001' /></h1>
		<div class="fullwidth">
			<div style="height:50px">
				<div style="float:left;margin-top:3px;margin-bottom:10px">
					<p class="pic" style="float:left;margin:5px 10px; cursor: pointer;" onclick="menuQst_DetailUserInfo('${vo.writerId}')" > 
						<c:choose>
							<c:when test="${empty vo.pic}">
								<img src="/images/poll/default_pic_vote.gif" width="48px" height="48px" style="position: relative;">
							</c:when>
							<c:otherwise>
								<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${vo.pic}" width="48px" height="48px" style="position: relative;">
							</c:otherwise>
						</c:choose>
					</p>
					<div style="float:left;margin:1px 8px">
						<span class="name" style="float:left">${vo.writerName}</span>
						<span class="team" style="float:left">${vo.deptName}</span>
						<span class="date" style="float:left">${vo.writeDate}</span>
					</div>
				</div>	
				<div class="ladderGame_info" style="float:right">
					<ul class="attribute">
						<li><img src="/images/ezLadder/icon_game0${vo.type}.png" title="<spring:message code='ezLadder.t10${vo.type+1}'/>" width="45px;" height="45px;"></li>
						<li><img src="/images/ezLadder/icon_status0${vo.status}.png" title="<spring:message code='ezLadder.t07${vo.status+4}'/>" width="45px;" height="45px;"></li>
						<c:choose>
							<c:when test="${vo.secretFlag eq 0}">
								<li><img src="/images/ezLadder/icon_secretflag00.png" title="<spring:message code='ezLadder.t007'/>" width="45px;" height="45px;"></li>
							</c:when>
							<c:otherwise>
								<li><img src="/images/ezLadder/icon_secretflag01.png" title="<spring:message code='ezLadder.t076'/>" width="45px;" height="45px;"></li>
							</c:otherwise>
						</c:choose>
					</ul>
					<ul class="edit">
						<li style="cursor: pointer;"><img src="/images/ezLadder/icon_list.png" width="45px;" height="45px;" id="toList" onmouseover="this.src='/images/ezLadder/icon_list_hover.png'" onmouseout="this.src='/images/ezLadder/icon_list.png'" title="<spring:message code='ezLadder.t083'/>"></li>
						<li style="cursor: pointer;"><img src="/images/ezLadder/icon_reuse.png" width="45px;" height="45px;" id="usePreladder" onmouseover="this.src='/images/ezLadder/icon_reuse_hover.png'" onmouseout="this.src='/images/ezLadder/icon_reuse.png'" title="<spring:message code='ezLadder.t082'/>"></li>
						<c:choose>
							<c:when test="${vo.writerId == id}"><li style="cursor: pointer;"><img src="/images/ezLadder/icon_posDelete.png" onmouseover="this.src='/images/ezLadder/icon_posDelete_hover.png'" onmouseout="this.src='/images/ezLadder/icon_posDelete.png'" title="<spring:message code='ezLadder.t077'/>" width="45px;" height="45px;" onclick="deleteLadder(${vo.ladderId})"></li></c:when>
							<c:when test="${vo.writerId != id}"><li><img src="/images/ezLadder/icon_imposDelete.png" onmouseover="this.src='/images/ezLadder/icon_imposDelete_hover.png'" onmouseout="this.src='/images/ezLadder/icon_imposDelete.png'" title="<spring:message code='ezLadder.t078'/>" width="45px;" height="45px;"></li></c:when>
						</c:choose>
					</ul>
				</div>
			</div>
			<table class="setTable" style="position: relative; width: 100%;">
				<tr>
					<td>
						<div class="ladderPreList_right" style="width: 100%; min-width: 800px; border: 0; height: auto;">
							<h2 style="border: 1px solid #DDD;overflow: hidden">
								<p class="ladderGame_title"><c:out value="${vo.title}" /></p>
								<div class="directionBtn">
									<c:choose>
										<c:when test="${vo.status eq 0}">
											<button id="immediatelyDirection" class="direcDiv" disabled="disabled" align="center" style="right: 5px; background: #dddddd; cursor: default;"><div class="direcTextDiv" style="color: #999999"><spring:message code='ezLadder.t056' /></div></button>
											<button id="autoDirection" class="direcDiv" disabled="disabled" align="center" style="right: 160px; background: #dddddd; cursor: default;"><div class="direcTextDiv" style="color: #999999"><spring:message code='ezLadder.t057' /></div></button>
										</c:when>
										<c:otherwise>
											<button id="immediatelyDirection" class="direcDiv" align="center" style="right: 5px; background: darkcyan;"><div class="direcTextDiv"><spring:message code='ezLadder.t056' /></div></button>
											<button id="autoDirection" class="direcDiv" align="center" style="right: 160px; background: salmon;"><div class="direcTextDiv"><spring:message code='ezLadder.t057' /></div></button>
										</c:otherwise>
									</c:choose>
								</div>
							</h2>
							<!-- <div class="ladderGame_view">
								
							</div> -->
						</div>
						
						
						<%-- <div style="overflow: hidden; margin-bottom: 20px; margin-top: 30px;">
							<div style="float: left; height: 70px; width: 70%; line-height: 70px;">
								<div style="display: inline-block; margin-right: 20px; padding-left: 20px;">${vo.title}</div>
								<div style="float: right; padding-top: 12px; padding-right: 20px; border-right: 1px solid #dddddd; line-height: 0; height: 60px;">
									<img src="/images/ezLadder/icon_game0${vo.type}.png" class="icon"/>
									<img src="/images/ezLadder/icon_status0${vo.status}.png" class="icon"/>
									<img src="/images/ezLadder/icon_secretflag0${vo.secretFlag}.png" class="icon"/>
								</div>
							</div>
							<div style="float: left; width: 30%;">
								<div style="float: left; padding-top: 3px;">
									<div style="float: left; padding-left: 20px;"><img src="${vo.pic}" style="width: 60px; height: 60px; border: 1px solid #ddd; border-radius: 35px; display: inline-block;"/></div>
									<div class="voteTextTest" style="float: left; margin-left: 10px">
										<span class="questionFont">${vo.writerName}</span>
										<span style="padding-top: 5px;">${vo.deptName}</span>
										<span class="questionFontS">${vo.writeDate}</span>
									</div>
								</div>
								<div style="float: right; padding-top: 12px; padding-right: 20px;">
									<img src="/images/ezLadder/icon_reuse.png" id="usePreladder" class="icon" style="cursor: pointer;"/>
									<c:choose>
										<c:when test="${vo.writerId == id}"><img src="/images/ezLadder/icon_posDelete.png" class="icon" onclick="deleteLadder(${vo.ladderId})" style="cursor: pointer;"/></c:when>
										<c:when test="${vo.writerId != id}"><img src="/images/ezLadder/icon_imposDelete.png" class="icon"/></c:when>
									</c:choose>
								</div>
							</div>
						</div> --%>
					</td>
				</tr>
				<tr>
					<td>
						<c:if test="${vo.status eq 0}">
							<div id="startButton" style="position: absolute; z-index: 100; top: 0; left: 0;">
								<c:choose>
									<c:when test="${id eq vo.writerId }">
										<div style="width: 500px; height: 150px; text-align: center;">
											<a href="#" onclick="start(${vo.ladderId}); return false;"><img src ='/images/ezLadder/btn_play.png' width='103' height ='103' style="margin-top: 10px;"/></a>
										</div>
									</c:when>
									<c:otherwise>
										<div style="width: 500px; height: 150px; background: white; text-align: center;">
											<span style="font-size: large; color: maroon; font-weight: bold; display: inline-block; margin-top: 45px; margin-bottom: 20px;"><spring:message code="ezLadder.t049" /></span>
											<span style="display: inline-block;"><spring:message code="ezLadder.t049" /></span>
										</div>
									</c:otherwise>
								</c:choose>
							</div>
							<div id="ladderLineBox" style="border: 1px solid #ddd; background: #FFF; min-width: 750px; padding-top: 30px; padding-bottom: 20px; border-top:0px">
								<div style="height: 100px;">
									<ul id="attendantList" style="width: ${fn:length(list) * 150}px;">
										<c:forEach var="line" items="${list}" varStatus="status">
											<li _attendantIndex="${status.index}">
												<div class="ladderDrag" id="drag${status.index}" style="cursor: pointer; left: 0px; border-radius: 5px;">
													<c:choose>
														<c:when test="${empty line.pic}">
															<span class="userPicWraper_d">
																<img src="/images/ezLadder/icon_defaultAttendant.png" width="48px" height="48px" style="display: block;" />
															</span>
														</c:when>
														<c:otherwise>
															<span class="userPicWraper">
																<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${line.pic}" width="48px" height="48px" />
															</span>
														</c:otherwise>
													</c:choose>
													<div title="${line.userName}" style="line-height: 30px; background: white; height: 30px; margin-top: 10px; overflow: hidden; text-overflow: ellipsis;"><span style="white-space: nowrap;">${line.userName}</span></div>
													<c:if test="${id eq vo.writerId }">
														<img src="/images/ezLadder/icon_switchAttendant.png" style="width: 20px;height: 20px;position: absolute;top: 0;right: 15px;" />
													</c:if>
												</div>
											</li>
										</c:forEach>
									</ul>
								</div>
								<div id="lineDiv" style="position: relative; height: 400px; z-index: 1;">
									<div id="blackBox" style="height: 380px;background: #f5faff; position: absolute;left: -50px;right: 0;border-top:1px solid #dde4ed;border-bottom:1px solid #dde4ed">
										<div id="changeOrderPop" style="height: 150px; width: 500px; position: relative;"></div>
									</div>
									<span></span>
									<canvas id='ladderCanvasLine' width='0' height='400'></canvas>
									<canvas id='ladderCanvas' width='0' height='400'></canvas>
								</div>
								<ul id="itemList" style="margin-top: 16px; width: ${fn:length(list) * 150}px; height: 50px;">
									<c:forEach var="line" items="${list}">
										<li>
											<div title="${line.item}" class="resultItem" style="line-height: 30px; height:30px; outline: 1px solid #ddd; overflow: hidden; text-overflow: ellipsis;">
												<span style="white-space: nowrap;">${line.item}</span>
											</div>
										</li>
									</c:forEach>
								</ul>
							</div>
						</c:if>
							
						<c:if test="${vo.status eq 1}">
							<div id="ladderLineBox" style="border: 1px solid #ddd; background: #FFF; min-width: 750px; padding-top: 20px; border-top:0px">
								<div style="height: 100px; margin-top:10px; margin-bottom: 20px;">
									<ul id="attendantList" style="width: ${fn:length(list) * 150}px;">
										<c:forEach var="line" items="${list}" varStatus="status">
											<li>
												<div id="drag${status.index}" style="cursor: pointer;position: relative;">
														<c:choose>
															<c:when test="${empty line.pic}">
																<span class="userPicWraper_d">
																	<img src="/images/ezLadder/icon_defaultAttendant.png" width="48px" height="48px" style="display: block;" />
																</span>
															</c:when>
															<c:otherwise>
																<span class="userPicWraper">
																	<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${line.pic}" width="48px" height="48px" />
																</span>
															</c:otherwise>
														</c:choose>
													<div title="${line.userName}" style="line-height: 30px; background: white; height: 30px; margin-top: 10px; overflow: hidden; text-overflow: ellipsis;"><span style="white-space: nowrap;">${line.userName}</span></div>
												</div>
											</li>
										</c:forEach>
									</ul>
								</div>
								<div id="lineDiv" style="position: relative; z-index: 1;">
									<span></span>
									<canvas id='ladderCanvasLine' width='0' height='675'></canvas>
									<canvas id='ladderCanvas' width='0' height='675'></canvas>
								</div>
								<ul id="itemList" style="margin-top: 14px; width: ${fn:length(list) * 150}px; height: 50px;">
									<c:forEach var="line" items="${list}">
										<li>
											<div title="${line.item}" class="resultItem" style="line-height: 30px; height:30px; outline: 1px solid #ddd; overflow: hidden; text-overflow: ellipsis;">
												<span style="white-space: nowrap;">${line.item}</span>
											</div>
										</li>
									</c:forEach>
								</ul>
							</div>
						</c:if>
					</td>
				</tr>
			</table>
			
			
		</div>
		
		<c:if test="${mode != 'preview' }">
			<div id="commentArea" style="border:1px solid #DDD; margin:15px 0px 0px 0px; width:100%; min-width:800px; border-top: none; border-bottom: none;">
				<div id="sendComment" class="voteComment" style="width:100%; border-bottom: 1px solid #dddddd; border-left: none; border-right: none; margin: 0px 0px 0px 0px;">
					<div class="sendComment_layout">
						<div class="comment_input_layout" style="border: none; width: 86%;">
							<textarea cols="20" rows="1" id="comment_input" oninput="auto_grow(this)" maxlength="500"></textarea>
						</div>
						<div class="commentBtn">
							<button id="sendBttn" disabled="disabled" style="display:inline-block; width: 96px; cursor:pointer; height:45px; border:none; border-radius:5px; background:#d0d0d0; color:#FFF; margin:0px; padding:0px; text-align: center; vertical-align: middle;"><spring:message code="ezLadder.t054" /></button>						
						</div>
					</div>
				</div>
				<table style="width: 100%;" id="commentListView">
					<c:forEach var="_comt" items="${cmtlist}">
						<tr style="border-bottom: 1px dotted #ddd;" _comtIndex="<c:out value ="${_comt.id}" />">
							<td style="padding: 0px 0px 0px 10px; width: 24px; height: 24px; vertical-align:top; ">
								<div style="width: 38px; height: 38px; overflow: hidden; border: 1px solid #DDD; border-radius: 20px; margin-top: 10px; cursor: pointer;" onclick="menuQst_DetailUserInfo('${_comt.userId}')" >
								<c:choose>
									<c:when test="${empty _comt.pic}">
										<img src="/images/ezLadder/icon_defaultAttendant.png" style="height: 38px; width:38px;">
									</c:when>
									<c:otherwise>
										<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${_comt.pic}" style="height: 38px; width:38px;">
									</c:otherwise>
								</c:choose>
								</div>
							</td>
							<td>
								<div class="userName">${_comt.userName}</div>
								<div id="div2Cmt<c:out value ="${_comt.id}" />" style="display: inline-block; height: auto; padding:10px 0px 10px 20px; max-width: 1300px;" ><% pageContext.setAttribute("br", "\n"); %>
									<p id="cmtArea<c:out value ="${_comt.id}" />" style="word-break: break-all; margin-top: 0px;margin-bottom: 0px;">${fn:replace(_comt.comment, br, '<br/>')}</p>
								</div>
								<div id="editCmtDiv<c:out value ="${_comt.id}" />" style="display: none;"></div>
							</td>
							<td style="width: 145px; position:relative;">
								<div style="position: absolute; top:10px; right:18px; color:#a3a3a3; white-space:nowrap;"><c:out value ="${_comt.writeDate}" /></div>
								<c:if test="${_comt.userId == id}">								
									<img src="/images/option3.png" style="margin:30px 10px 0px 0px; position:absolute;top:0;right:0; padding:0px; cursor: pointer;" height=25 width=25 vertical-align="middle" name="editComtButton" _comtIndex="editComt<c:out value ="${_comt.id}"/>" />
									<div id="editComt<c:out value ="${_comt.id}"/>" style="float:right; display: none; position: absolute; top:30px; right:28px; z-index: 10 ; border: 1px solid #ddd; background-color: #576652; color: white; width: 120px;" tabindex=0>							
										<div id="_eCmt<c:out value ="${_comt.id}" />" _comtIndex="editComt<c:out value ="${_comt.id}" />" style="border-bottom: 1px solid #ddd; text-align: center; padding:6px 0px; color:#333; background:#eaeaea; cursor: pointer;"><spring:message code="ezLadder.t062" /> <spring:message code="ezLadder.t052" /></div>
										<div id="_dCmt<c:out value ="${_comt.id}" />"_comtIndex="<c:out value ="${_comt.id}" />" style="text-align: center; padding:6px 0px; background:#eaeaea; color:#333; cursor: pointer;"><spring:message code="ezLadder.t062" /> <spring:message code="ezLadder.t053" /></div>
									</div>
								</c:if>
							</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</c:if>
	</body>
</html>