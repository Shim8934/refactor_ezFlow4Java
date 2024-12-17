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
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/css/ezLadder/ladder_CSS.css')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/css/ezPoll/vote.css')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/css/ezLadder/ladderPreList.css')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/css/font-awesome-5.0.10/css/fontawesome-all.css')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('ezLadder.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezPoll/stomp.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezPoll/sockjs.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezLadder/ladder.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript">
	
		var _ladderLine;
		
		var ladderId;
		var writerId;
		var status;
		var lineCnt;
		var deleteFlag;
		var searchSelect;
		var searchInput;
		var mode;
		var currPage;
		var back;
		var sort;
		var sortFlag;
		var allData = [];
		var stompClient = null;
		var servername = null;
		var loginId;
		var id = "${id}";
		var dragloc = {};
		var droploc = {};
		var marginChangeAttendantNum;
		
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
			initSetting();
			
			if(status == 0) { 
				if(writerId == loginId) {
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
									dragloc.beforeLeft = Math.round(ui.position.left/wSize);
								} else {
									dragloc.beforeLeft = Math.round(Math.abs(ui.position.left/wSize)) * -1;
								}
							}
						})
						.droppable({ // 드랍 리스트
							accept: ".ladderDrag",
							addClasses: false,
							drop: function(event, ui) {
								droploc = {"id": $(this).attr("id"), "left": 0};
								
								var _thisleft = Math.round($(this).css("left").split("px")[0]/wSize);
								
								if(ui.position.left >= 0) {
									dragloc.left = Math.round(ui.position.left/wSize);
								} else {
									dragloc.left = Math.round(Math.abs(ui.position.left/wSize)) * -1;
								}
								
								var moveValue = dragloc.left - dragloc.beforeLeft;
								droploc.left = _thisleft - moveValue;
								
								afterDrag();
								changeListOrder();
							},
							
						});
						/* .on("mousedown", function() {
							userSwitchFlag = true;
						}) */
						/* .on("mouseup", function() {
							userSwitchFlag = false;
						}); */
				} else {
					$(".ladderDrag").on("dragstart", function() {
						return false;
					});
				}
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
					var $span = $(this).find("span");
					$span.css("border-color", "#2568b3");
					if($span.hasClass("userPicWraper_d")) {
						$span.find("img").attr("src", "/images/ezLadder/icon_defaultAttendant_hover.png");
					}
				})
				.on("mouseleave", "[id^='drag']", function() {
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
			/* $("#ladderContents")
				.on("mouseleave", function() {
					if(!!moFlag) {
						scrollMouseUpEvent();
					}
				}); */
		});
		
		function ladder_window_resize() {
			var $setTable = $(".setTable");
			var $lineBox = $("#ladderLineBox");
			var $startButton = $setTable.find("#startButton");
			var attendantsLen = _ladderLine.length;
			
			var line_width;
			if(attendantsLen <= marginChangeAttendantNum) {
				wSize = 150;
				ladLeftPadding = 0;
				line_width = _ladderLine.length * wSize;
				$lineBox.find("ul").css("width", attendantsLen * wSize + "px");
				$lineBox.find("li").css("margin-right", wSize - userDiv + "px");
			} else {
				wSize = 110;
				ladLeftPadding = 40;
				line_width = _ladderLine.length * wSize + 40;
				$lineBox.find("ul").css("width", attendantsLen * wSize + "px");
				$lineBox.find("li").css("margin-right", wSize - userDiv + "px");
			}
			
			var doc_widthPadding = Number($lineBox.css("padding-left").replace("px", ""));
			var doc_width = document.body.clientWidth - doc_widthPadding;
			
			$lineBox.css("width", doc_width);
			$setTable.find("#blackBox").css("width", ((line_width > doc_width ? line_width : doc_width) + doc_widthPadding) + "px");
			
			$startButton
				.css("left", $setTable.width() / 2 - $startButton.width() / 2)
				.css("top", ($setTable.height() - $lineBox.height()) + ($lineBox.height() / 2 - $startButton.height() / 2));
		}
		
		function initSetting() {
			_ladderLine = ${list};
			
			loginId = "<c:out value='${id}' />";
			
			ladderId = "<c:out value='${vo.ladderId}' />";
			writerId = "<c:out value='${vo.writerId}' />";
			status = "<c:out value='${vo.status}' />";
			lineCnt = "<c:out value='${vo.lineCnt}' />";
			deleteFlag = "<c:out value='${vo.deleteFlag}' />";
			if(status == 1) {
				lad = "<c:out value='${vo.lineArray}' />";
			}
			
			searchSelect = "<c:out value='${searchSelect}' />";
			searchInput = "<c:out value='${searchInput}' />";
			mode = "<c:out value='${mode}' />";
			currPage = "<c:out value='${currPage}' />";
			back = "<c:out value='${back}' />";
			sort = "<c:out value='${sort}' />";
			sortFlag = "<c:out value='${sortFlag}' />";
			companyID = "<c:out value='${companyID}' />";
			companyName = "<c:out value='${vo.companyName}' />";
			writerCompanyID = "<c:out value='${vo.companyID}' />";
			marginChangeAttendantNum = 50;
			
			// 사다리가 삭제 되었을 경우
			if(deleteFlag == "0") {
				ladder_window_resize();
				canvasSetting();
			} else {
				alert("<spring:message code='ezLadder.hyh01' />");
				window.location.href = "/ezLadder/ladderMain.do?brdID=7";
				return;
			}
			
			// 사간겸직시
			if(companyID != writerCompanyID) {
				/** 메세지 수정 필요 */
				alert(companyName + "에서 조회 가능합니다.");	// 수정 필요
				window.location.href = "/ezLadder/ladderMain.do?brdID=7";
				return;
			}
			
		}
		
		function afterDrag() {
			$("#" + dragloc.id).css("z-index", "10").animate({"left": originalPosition_left + dragloc.left * wSize, "top": dragloc.top}, 400);
			$("#" + droploc.id).css("z-index", "10").animate({"left": originalPosition_left + droploc.left * wSize}, 400);
		}
		
		/** 참여자 위치 바꾸기 */
		function changeListOrder() {
			var ladId1 = dragloc["id"].substring(4); //5
			var ladId2 = droploc["id"].substring(4); //0
			var ladorder1 = _ladderLine[ladId1].ladderOrder; //5
			var ladorder2 = _ladderLine[ladId2].ladderOrder; //0
			var laditem1 = _ladderLine[ladId1].item;
			var laditem2 = _ladderLine[ladId2].item;
			
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
					_ladderLine[ladId1].item = laditem2;
					_ladderLine[ladId2].item = laditem1;
				}
			});
		}
		
		/* function add_user_change_ulsize(usernum) {
			$("#ladderLineBox ul").css("width", (usernum * 150) + "px");
			$("#ladderCanvas").attr("width", (usernum * 150) + "px");
		} */
		
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
					
					if(result.body == loginId) {
						$(".ladderDrag").draggable("destroy");
					}
				});
			});
		}
		function canvasSetting() {
			changeUser(_ladderLine.length);
			
			if(status == 1) {
				$("#ladderLineBox").css("padding-bottom", "50px");
				
				ladArr = lad.split('');
				
				clickUserLadderAnimation();
				ladderDrawInitSettingVar();
				setLadInfo();
				setDefaultLad();
				printLadLine();
				setUserPath();
			}
		}
		
		function clickUserLadderAnimation() {
			var $ladLineBox = $("#ladderLineBox");
			var $body = $("html, body");
			var ladLineTop = $ladLineBox.offset().top + Number($ladLineBox.css("padding-top").slice(0,-2));
			
			$(document)
			.on("click", "[id^=drag]", function() {
				clickUserOrder = Number($(this).attr("id").slice(4));
				
				if($body.scrollTop() != ladLineTop) {
					$body.animate({"scrollTop": ladLineTop}, 200);
				}
				if(userStatus[clickUserOrder] == 0) {
					aniOneUser();
				} else {
					popOneUser();
				}
				/* if(userClickFlag) {
					clickUserOrder = Number($(this).attr("id").slice(4));
					
					if($body.scrollTop() != ladLineTop) {
						$body.animate({"scrollTop": ladLineTop}, 200);
					}
					if(userStatus[clickUserOrder] == 0) {
						aniOneUser();
					} else {
						popOneUser();
					}
				} */
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
			
			var $ladLineBox = $("#ladderLineBox");
			if(type.substring(0, 3) == "ani" || type.substring(3, 6) == "one") {
				var scrollval = (resultOrder * wSize - $ladLineBox.width()/2) + wSize/2;
				$ladLineBox.animate({"scrollLeft": scrollval}, 300);
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
					"currPage": currPage,
					"back": back
				},
				success: function(ladderInfo) {
					status = ladderInfo["vo"]["status"];
					lad = ladderInfo["vo"]["lineArray"];
					_ladderLine = ladderInfo["list"];
					
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
						html += '<li style="margin-right: ' + (wSize - userDiv) + 'px"><div id="drag' + index + '" class="userInfo" ondragstart="return false;" style="cursor: pointer;">';
						if(!line.pic) {
							html += '<span class="userPicWraper_d"><img src="/images/ezLadder/icon_defaultAttendant.png" class="userInfo" width="48px" height="48px" style="display: block;" /></span>';
						} else {
							html += '<span class="userPicWraper"><img src="' + picsrc + '" class="userInfo" width="48px" height="48px" /></span>';
						}
						html += '<div title="' + line.userName + '" class="userInfo" style="line-height: 30px; background: white; height: 30px; margin-top: 10px; overflow: hidden; text-overflow: ellipsis;"><span style="white-space: nowrap">' + line.userName + '</span></div></div></li>';
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
					var picsrc = cmt["pic"] != "" ? "/admin/ezOrgan/getPersonalInfo.do?fileName=" + cmt["pic"] : "/images/ezLadder/icon_defaultAttendant.png";
					if(flag == "add") { 
						// add
						var html = '<tr _comtIndex="' + cmt["id"] + '">';
						html += '<td style="padding: 0px 0px 0px 10px; width: 24px; height: 24px; vertical-align:top; "><div style="width: 38px; height: 38px; overflow: hidden; border: 1px solid #DDD; border-radius: 20px; margin-top: 10px; cursor: pointer;" onclick="menuQst_DetailUserInfo(\'' +  cmt["userId"] + '\', \'' +  cmt["deptID"] + '\',  ' + cmt["setRetireFlag"] + ')"><img src="' + picsrc + '" style="height: 38px; width:38px;"></div></td>';
						html += '<td><div class="userName">' + cmt["userName"] + '</div>';
						html += '<div id="div2Cmt' + cmt["id"] + '" style="display: inline-block; height: auto; padding:10px 0px 10px 20px; max-width: 1300px;" >';
						html += '<p id="cmtArea' + cmt["id"] + '" style="word-break: break-all; margin-top: 0px;margin-bottom: 0px;"></p></div>';
						html += '<div id="editCmtDiv' + cmt["id"] + '" style="display: none;"></div></td>';
						html += '<td style="width: 145px; position:relative;">';
						html += '<div style="position: absolute; top:10px; right:18px; color:#a3a3a3; white-space:nowrap;">' + cmt["writeDate"] + '</div></td></tr>';
					
						$("#commentArea table").prepend(html);
						$("#cmtArea" + cmt["id"]).text(cmt["comment"]);
						
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
						$("#cmtArea" + cmt["id"]).text(cmt["comment"]);
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
		function cmtKeyEvent() {
			if(event.keyCode == 13) {
				addComt($("#comment_input").val());
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
				var editTemp= $("#cmtArea" + editComtFlag).text();
				//editTemp = editTemp.replace(/(<br>|<br\/>|<br \/>)/g, '\r\n');
				
				html += '<div style="display: inline-block; width: 100%; margin-top: 5px;">';
				html += '<div style="display: block; float:left; border:1px solid #ddd;padding: 0 5px;;margin-left: 20px; border-radius: 3px; width: 95%; height: 30px; overflow: hidden;">';
				html += '<input id="editCmtArea' + editComtFlag + '" type="text" style="display: inline-block; overflow-y: auto; outline: none; border: none; resize: none; padding: 0; margin: 5px 0; height: 20px; width: 100%; line-height: 20px;" maxlength="500">';
				html += '</input></div></div>';
				html += '<div style="padding: 5px 0px 5px 20px; clear: both;">';
				html += '<button id="clA2cmt' + editComtFlag + '" class="voteSaveBttn" _comtindex="' + editComtFlag + '" style="margin-right: 4px;"><spring:message code="ezLadder.t072" /></button>';
				html += '<button id="clA1cmt' + editComtFlag + '" class="voteCancelBttn" _comtindex="' + editComtFlag + '" style="width: 46px;"><spring:message code="ezLadder.t087" /></button></div>';
			} 
			
			$("#div2Cmt" + comtIndex).toggle();
			$("#_eCmt" + comtIndex).toggle();
			$("#editCmtDiv" + comtIndex).html(html).toggle();
			$("#editCmtArea" + editComtFlag).val(editTemp);
			
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
		
		function menuQst_DetailUserInfo(pUserID, pDeptID, reFlag) {
			if(!reFlag) {
				var feature = GetOpenPosition(420, 450);
				window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
			}
		}
		
		/* var moFlag = false;
		var userSwitchFlag = false;
		var userClickFlag = false;
		var $linebox;
		var moveX;
		var scrollSpeedX;
		function scrollMouseDownEvent(obj, event) {
			userClickFlag = event.target.classList.contains("userInfo");
			
			if(!moFlag && !userSwitchFlag) {
				$linebox = $("#ladderLineBox");
				moveX = event.screenX;
				moFlag = !moFlag;
			}
		}
		function scrollMouseDragEvent(obj, event) {
			if(moFlag) {
				var movementX = moveX - event.screenX;
				$linebox.scrollLeft($linebox.scrollLeft() + movementX);
				scrollSpeedX = movementX;
				moveX = event.screenX; 
				userClickFlag = false;
			}
		}
		function scrollMouseUpEvent(obj, event) {
			if(moFlag) {
				moFlag = !moFlag;
			}
		} */
	</script>
	<style type="text/css">
		input[type=text]::-ms-clear {
			display:none;
		}
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
			margin-top: 5px;
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
			font-size: 13px;
			padding-top: 4px;
		}
		.team {
			color : #000;
			padding-top: 5px;
		}
		.date {
			color: #aaa9a9;
			padding-top: 4px;
		}
		a, a:hover {
			color: transparent;
		}
		
		table#commentListView tr {
			border-bottom-color: #DDD;
			border-bottom-width: 1px;
			border-bottom-style: dotted;
		}
		
		table#commentListView tr:last-child {
			border-bottom-style: solid;
		}
	</style>
</head>
	<body class="mainbody">
		<h1><spring:message code='ezLadder.t001' /></h1>
		<div class="fullwidth">
			<div style="height:50px">
				<div style="float:left;margin-top:3px;margin-bottom:5px">
					<p class="pic" style="float:left;margin:5px 10px; cursor: pointer;" onclick="menuQst_DetailUserInfo('<c:out value="${vo.writerId}" />', '<c:out value="${vo.deptID}" />')" > 
						<c:choose>
							<c:when test="${empty vo.pic}">
								<img src="/images/poll/default_pic_vote.gif" width="48px" height="48px" style="position: relative;">
							</c:when>
							<c:otherwise>
								<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=<c:out value="${vo.pic}" />" width="48px" height="48px" style="position: relative; border-radius: 25px;">
							</c:otherwise>
						</c:choose>
					</p>
					<div style="float:left;margin:1px 8px">
						<span class="name" style="display:block;"><c:out value="${vo.writerName}" /></span>
						<span class="team" style="display:block;"><c:out value="${vo.deptName}" /></span>
						<span class="date" style="display:block;"><c:out value="${vo.writeDate}" /></span>
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
						<c:if test="${vo.writerId == id}"><li style="cursor: pointer;"><img src="/images/ezLadder/icon_posDelete.png" onmouseover="this.src='/images/ezLadder/icon_posDelete_hover.png'" onmouseout="this.src='/images/ezLadder/icon_posDelete.png'" title="<spring:message code='ezLadder.t053'/>" width="45px;" height="45px;" onclick="deleteLadder(<c:out value="${vo.ladderId}" />)"></li></c:if>
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
						</div>
					</td>
				</tr>
				<!-- <tr id="ladderContents" onmousedown="scrollMouseDownEvent(this, event);" onmousemove="scrollMouseDragEvent(this, event);" onmouseup="scrollMouseUpEvent(this, event);" onselectstart="return false;"> -->
					<tr id="ladderContents">
					<td>
						<c:if test="${vo.status eq 0}">
							<div id="startButton" style="position: absolute; z-index: 100; top: 0; left: 0; margin-top:-10px">
								<c:choose>
									<c:when test="${id eq vo.writerId }">
										<div style="width: 500px; height: 150px; text-align: center;">
											<a onclick="start(<c:out value="${vo.ladderId}" />); return false;"><img src ='/images/ezLadder/btn_play.png' style="margin-top:40px" /></a>
										</div>
									</c:when>
									<c:otherwise>
										<div style="width: 500px; height: 140px; background: white; text-align: center;border:1px solid palevioletred">
											<span style="font-size: large; color: palevioletred; font-weight: bold; display: inline-block; margin-top: 45px; margin-bottom: 20px;"><spring:message code="ezLadder.t049" /></span>
											<span style="display: inline-block;"><spring:message code="ezLadder.t049" /></span>
										</div>
									</c:otherwise>
								</c:choose>
							</div>
							<div id="ladderLineBox" style="border: 1px solid #ddd; background: #FFF; min-width: 750px; padding-top: 30px; padding-bottom: 20px; border-top:0px">
								<div style="height: 100px;">
									<ul id="attendantList">
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
													<div title="${line.userName}" style="line-height: 30px; background: white; height: 30px; margin-top: 10px; overflow: hidden; text-overflow: ellipsis;"><span style="white-space: nowrap;"><c:out value="${line.userName}" /></span></div>
													<c:if test="${id eq vo.writerId }">
														<img src="/images/ezLadder/icon_switchAttendant.png" style="width: 20px;height: 20px;position: absolute;top: 0;right: 15px;" />
													</c:if>
												</div>
											</li>
										</c:forEach>
									</ul>
								</div>
								<div id="lineDiv" style="position: relative; height: 400px; z-index: 1;">
									<div id="blackBox" style="height: 398px;background: whiteSmoke; position: absolute;left: -50px;right: 0;border-top:1px solid #333;border-bottom:1px solid #333">
										<div id="changeOrderPop" style="height: 150px; width: 500px; position: relative;"></div>
									</div>
									<span></span>
									<canvas id='ladderCanvasLine' width='0' height='400'></canvas>
									<canvas id='ladderCanvas' width='0' height='400'></canvas>
								</div>
								<ul id="itemList" style="margin-top: 16px; height: 50px;">
									<c:forEach var="line" items="${list}">
										<li>
											<div title="${line.item}" class="resultItem" style="line-height: 30px; height:30px; outline: 1px solid #ddd; overflow: hidden; text-overflow: ellipsis;">
												<span style="white-space: nowrap;"><c:out value="${line.item}" /></span>
											</div>
										</li>
									</c:forEach>
								</ul>
							</div>
						</c:if>
							
						<c:if test="${vo.status eq 1}">
							<div id="ladderLineBox" style="border: 1px solid #ddd; background: #FFF; min-width: 750px; padding-top: 20px; border-top:0px">
								<div style="height: 100px; margin-top:10px; margin-bottom: 20px;">
									<ul id="attendantList">
										<c:forEach var="line" items="${list}" varStatus="status">
											<li>
												<div id="drag${status.index}" class="userInfo" ondragstart="return false;" style="cursor: pointer;position: relative;">
														<c:choose>
															<c:when test="${empty line.pic}">
																<span class="userPicWraper_d">
																	<img src="/images/ezLadder/icon_defaultAttendant.png" width="48px" height="48px" style="display: block;" class="userInfo" />
																</span>
															</c:when>
															<c:otherwise>
																<span class="userPicWraper">
																	<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${line.pic}" width="48px" height="48px" class="userInfo" />
																</span>
															</c:otherwise>
														</c:choose>
													<div title="${line.userName}" class="userInfo" style="line-height: 30px; background: white; height: 30px; margin-top: 10px; overflow: hidden; text-overflow: ellipsis;"><span style="white-space: nowrap;"><c:out value='${line.userName}' /></span></div>
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
								<ul id="itemList" style="margin-top: 14px; height: 50px;">
									<c:forEach var="line" items="${list}">
										<li>
											<div title="${line.item}" class="resultItem" style="line-height: 30px; height:30px; outline: 1px solid #ddd; overflow: hidden; text-overflow: ellipsis;">
												<span style="white-space: nowrap;"><c:out value="${line.item}" /></span>
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
							<input id="comment_input" type="text" oninput="auto_grow(this)" maxlength="500" onkeydown="cmtKeyEvent()" style="width: 100%;"></input>
						</div>
						<div class="commentBtn">
							<button id="sendBttn" disabled="disabled" style="display:inline-block; width: 96px; cursor:pointer; height:45px; border:none; border-radius:5px; background:#d0d0d0; color:#FFF; margin:0px; padding:0px; text-align: center; vertical-align: middle;"><spring:message code="ezLadder.t054" /></button>						
						</div>
					</div>
				</div>
				<table style="width: 100%;" id="commentListView">
					<c:forEach var="_comt" items="${cmtlist}">
						<tr _comtIndex="<c:out value ="${_comt.id}" />">
							<td style="padding: 0px 0px 0px 10px; width: 24px; height: 24px; vertical-align:top; ">
								<div style="width: 38px; height: 38px; overflow: hidden; border: 1px solid #DDD; border-radius: 20px; margin-top: 10px; cursor: pointer;" onclick="menuQst_DetailUserInfo('<c:out value='${_comt.userId}' />', '<c:out value='${_comt.deptID}' />', '<c:out value='${_comt.setRetireFlag}' />')" >
								<c:choose>
									<c:when test="${_comt.pic eq ''}">
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
								<div id="div2Cmt<c:out value ="${_comt.id}" />" style="display: inline-block; height: auto; padding:10px 0px 10px 20px; max-width: 1300px;" >
									<p id="cmtArea<c:out value ="${_comt.id}" />" style="word-break: break-all; margin-top: 0px;margin-bottom: 0px;"><c:out value="${_comt.comment}" /></p>
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