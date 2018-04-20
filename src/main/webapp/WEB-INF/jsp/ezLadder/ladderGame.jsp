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
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
	<script type="text/javascript" src="/js/ezPoll/stomp.min.js"></script>
	<script type="text/javascript" src="/js/ezPoll/sockjs.min.js"></script>
	<script type="text/javascript" src="/js/ezLadder/ladder.js"></script>
	
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
		
		$(window).unload(function() {
			if (stompClient !== null) {
		        stompClient.disconnect();
		    }
		});
	
		
		function ladder_window_resize() {
			/* var win_width = $(window).width() - 70; */
			var win_width = $(window).width() - 70;
			var line_width = $("#attendantList").css("width").replace(/[^0-9]/g,'') * 1;
			var title_width = win_width - $(".ladderGame_info").width();
			
			/* $(".setTable").css("width", win_width + "px"); */
			$("#ladderLineBox").css("width", win_width + "px");
			$(".ladderGame_title").css("width", title_width);
			
			if(line_width > win_width) {
				$("#blackBox").css("width", (line_width + 100) + "px");
			} else {
				$("#blackBox").css("width", (win_width + 50) + "px");
			}
			
			$("#startButton").css("left", $(".setTable").width()/2 - 250).css("top", $(".setTable").height()/2 - 75);
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
				data: {
					"ladderId": ladderId,
					"firstUser": _ladderLine[ladId1].userId,
					"firstUserOrder": ladorder1,
					"secondUser": _ladderLine[ladId2].userId,
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
		
		var dragcnt = 0;
		var originalPosition_left = 0;
		$(function() {
			if(deleteFlag == 1) {
				window.location.href = "/ezLadder/ladderMain.do?brdID=7"; 
			}
			initValues();
			ladder_window_resize();
			
			if(status == 0 && writerId == id) {
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
			} else if(status == 1) {
				// 완료상태
				canvasSetting();
			}
			
			if(mode !== "preview") {
				// 프리뷰가 아닐때 댓글 웹소켓 연결
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
					/* var $immediatelyDirection = $("#immediatelyDirection");
					$immediatelyDirection.attr("disabled", "disabled"); */
					clickUserOrder = 0;
					popAllUser();
					/* $immediatelyDirection.removeAttr("disabled"); */
				})
				.on("mouseenter", "[id^='drag']", function() {
					var $this = $(this);
					$this.find("span").css("border-color", "#2568b3");
					if($this.find("span").hasClass("userPicWraper_d")) {
						$this.find("img").attr("src", "/images/ezLadder/icon_defaultAttendant_hover.png");
					}
				})
				.on("mouseleave", "[id^='drag']", function() {
					var $this = $(this);
					$this.find("span").css("border-color", "#9e9e9e");
					if($this.find("span").hasClass("userPicWraper_d")) {
						$(this).find("img").attr("src", "/images/ezLadder/icon_defaultAttendant.png");
					}
				})
			$("#usePreladder").on("click", function() {
				window.location.href = "/ezLadder/setLadder.do?ladderId=" + ${vo.ladderId};
			});
		});
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
			
			ladderDrawInitSettingVar();
			setDefaultLad();
			setLadInfo();
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
			
			if($("#itemList li:eq(" + resultOrder + ") div").length == 1) {
				var html = "<div title='" + _ladderLine[clickUserOrder].userName + "' style='line-height: 30px; height: 30px; background: #ddd; margin-top: 10px; border-radius: 15px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;'>" + _ladderLine[clickUserOrder].userName + "</div>";
				$("#itemList li:eq(" + resultOrder + ")").append(html);
				$moveImgUser = $("#moveImgUser" + clickUserOrder);
			} else {
				$moveImgUser = $("#copyUser");
			}
			
			if(type.substring(0, 3) == "ani" || type.substring(3, 6) == "one") {
				var scrollval = (resultOrder * 150 - $("#ladderLineBox").width()/2) + 75;
				$("#ladderLineBox").animate({"scrollLeft": scrollval}, 400);
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
		
			if (confirm('삭제 하시겠습니까?')) {
				window.location.href= '/ezLadder/deleteLadder.do?allData=' + allData;
			} 
		}
		/** 사다리 시작 (대기->완료) */
		function start(idx) {
			allData = [idx, searchSelect, searchInput, mode, currPage, _ladderLine.length, lineCnt ];	
			if (confirm('시작하시겠습니까?')) {
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
					
					$("#lineDiv").html(
							"<span></span>" +
							"<canvas id='ladderCanvasLine' width='0' height='800'></canvas>" +
							"<canvas id='ladderCanvas' width='0' height='800'></canvas>"
						);
					$(".directionBtn").html(
							'<button id="immediatelyDirection" class="direcDiv" align="center" style="right: 5px; background: darkcyan;"><div class="direcTextDiv"><spring:message code="ezLadder.t106" /></div></button>' +
							'<button id="autoDirection" class="direcDiv" align="center" style="right: 160px; background: salmon;"><div class="direcTextDiv"><spring:message code="ezLadder.t107" /></div></button>'
					);
					var html = '';
					_ladderLine.forEach(function(line, index) {
						html += '<li><div id="drag' + index + '" style="padding-top:  20px; cursor: pointer;">';
						if(!line.pic) {
							html += '<span class="userPicWraper_d"><img src="/images/ezLadder/icon_defaultAttendant.png" width="60px" height="60px" style="display: block;" /></span>';
						} else {
							html += '<span class="userPicWraper"><img src="' + line.pic + '" width="60px" height="60px" /></span>';
						}
						html += '<div title="' + line.userName + '" style="line-height: 30px; background: white; height: 30px; outline: 1px solid #ddd; margin-top: 10px; overflow: hidden; text-overflow: ellipsis;"><span style="white-space: nowrap">' + line.userName + '</span></div></div></li>';
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
					var picsrc = !cmt["pic"] ? "/images/ezLadder/icon_defaultAttendant.png" : cmt["pic"];
					if(flag == "add") { 
						// add
						var html = '<tr style="border-bottom: 1px dotted #ddd;" _comtIndex="' + cmt["id"] + '">';
						html += '<td style="padding: 0px 0px 0px 10px; width: 24px; height: 24px; vertical-align:top; "><div style="width: 38px; height: 38px; overflow: hidden; border: 1px solid #DDD; border-radius: 20px; margin-top: 10px; cursor: pointer;"><img src="' + picsrc + '" style="height: 38px; width:38px;"></div></td>';
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
							html += '<div id="_eCmt' + cmt["id"] + '" _comtIndex="editComt' + cmt["id"] + '" style="border-bottom: 1px solid #ddd; text-align: center; padding:6px 0px; color:#333; background:#eaeaea; cursor: pointer;"><spring:message code="ezLadder.t052" /></div>';
							html += '<div id="_dCmt' + cmt["id"] + '" _comtIndex="' + cmt["id"] + '" style="text-align: center; padding:6px 0px; background:#eaeaea; color:#333; cursor: pointer;"><spring:message code="ezLadder.t053" /></div></div>';
							
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
				
				html += '<div style="display: inline-block;">';
				html += '<div style="display: block; float:left; border:1px solid #ddd;padding-left: 0px;margin-left: 20px; width: 1310px; border-radius: 3px;">';
				html += '<textarea id="editCmtArea' + editComtFlag + '" cols="20" rows="1" style="display: inline-block; overflow: hidden; outline: none; border: none; resize: none; padding: 5px; width: 1300px; height: 14px;">';
				html += $("#cmtArea" + editComtFlag).text() + '</textarea></div></div>';
				html += '<div style="padding: 5px 0px 5px 20px; clear: both;">';
				html += '<button id="clA1cmt' + editComtFlag + '" class="voteCancelBttn" _comtindex="' + editComtFlag + '"><spring:message code="ezLadder.t109" /></button>';
				html += '<button id="clA2cmt' + editComtFlag + '" class="voteSaveBttn" _comtindex="' + editComtFlag + '" style="background-color: rgb(0, 72, 150);"><spring:message code="ezLadder.t072" /></button></div>';
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
				document.getElementById("sendBttn").style.backgroundColor = "#004896";
				document.getElementById("sendBttn").disabled = false;
			}
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
			height: 50px;
			position: relative;
			margin-top: 20px;
		}
		
		.direcDiv {
			height: 80px;
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
			height: 37px;
			top: 13px;
			background: #EEE;
			line-height: 37px;
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
	</style>
</head>
	<body class="mainbody">
		<h1><spring:message code='ezLadder.t001' /></h1>
		<div class="fullwidth">
			<table class="setTable" style="position: relative; width: 100%;">
				<tr>
					<td>
						<div class="ladderPreList_right" style="width: 100%; min-width: 800px; border: 0; height: auto;">
							<h2 style="border: 1px solid #DDD;">
								<p class="ladderGame_title">${vo.title}</p>
								<div class="ladderGame_info">
									<ul class="attribute">
										<li><img src="/images/ezLadder/icon_game0${vo.type}.png" width="45px;" height="45px;"></li>
										<li><img src="/images/ezLadder/icon_status0${vo.status}.png" width="45px;" height="45px;"></li>
										<li><img src="/images/ezLadder/icon_secretflag0${vo.secretFlag}.png" width="45px;" height="45px;"></li>
									</ul>
									<p class="pic"><img src="${empty vo.pic ? '/images/ezLadder/icon_defaultAttendant.png' : vo.pic}" width="60px;" height="60px;" style="position: relative;top: -2px;left: -2px;"></p>
									<div class="txt">
										<span class="name">${vo.writerName}</span>
										<span class="team">${vo.deptName}</span>
										<span class="date">${vo.writeDate}</span>
									</div>
									<ul class="edit">
										<li style="cursor: pointer;"><img src="/images/ezLadder/icon_reuse.png" width="45px;" height="45px;" id="usePreladder"></li>
										<c:choose>
											<c:when test="${vo.writerId == id}"><li style="cursor: pointer;"><img src="/images/ezLadder/icon_posDelete.png" width="45px;" height="45px;" onclick="deleteLadder(${vo.ladderId})"></li></c:when>
											<c:when test="${vo.writerId != id}"><li><img src="/images/ezLadder/icon_imposDelete.png" width="45px;" height="45px;"></li></c:when>
										</c:choose>
									</ul>
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
										<div style="width: 500px; height: 150px;text-align: center;">
											<a href="#" onclick="start(${vo.ladderId}); return false;"><img src ='/images/ezLadder/btn_play.png' width='103' height ='103' style="margin-top: 25px;"/></a>
										</div>
									</c:when>
									<c:otherwise>
										<div style="width: 500px; height: 150px; background: white; opacity: 0.7; text-align: center;">
											<span style="font-size: large; color: maroon; font-weight: bold; display: inline-block; margin-top: 45px; margin-bottom: 20px;"><spring:message code="ezLadder.t049" /></span>
											<span style="display: inline-block;"><spring:message code="ezLadder.t049" /></span>
										</div>
									</c:otherwise>
								</c:choose>
						</div>
							<div class="directionBtn"></div>
							<div id="ladderLineBox" style="border: 1px solid #ddd; background: #FFF; min-width: 750px;">
								<div style="height: 140px;">
									<ul id="attendantList" style="width: ${fn:length(list) * 150}px;">
										<c:forEach var="line" items="${list}" varStatus="status">
											<li _attendantIndex="${status.index}">
												<div class="ladderDrag" id="drag${status.index}" style="padding-top:  20px; cursor: pointer; left: 0px; border-radius: 5px;">
													<c:choose>
														<c:when test="${empty line.pic}">
															<span class="userPicWraper_d">
																<img src="/images/ezLadder/icon_defaultAttendant.png" width="60px" height="60px" style="display: block;" />
															</span>
														</c:when>
														<c:otherwise>
															<span class="userPicWraper">
																<img src="${line.pic}" width="60px" height="60px" />
															</span>
														</c:otherwise>
													</c:choose>
													<div title="${line.userName}" style="line-height: 30px; background: white; height: 30px; outline: 1px solid #ddd; margin-top: 10px; overflow: hidden; text-overflow: ellipsis;"><span style="white-space: nowrap;">${line.userName}</span></div>
												</div>
											</li>
										</c:forEach>
									</ul>
								</div>
								<div id="lineDiv" style="position: relative; height: 800px; z-index: 1;">
									<div id="blackBox" style="height: 800px;background: darkgray;position: absolute;left: -50px;right: 0;">
										<div id="changeOrderPop" style="height: 150px; width: 500px; position: relative;"></div>
									</div>
									<span></span>
									<canvas id='ladderCanvasLine' width='0' height='800'></canvas>
									<canvas id='ladderCanvas' width='0' height='800'></canvas>
								</div>
								<ul id="itemList" style="margin-top: 10px; width: ${fn:length(list) * 150}px; height: 50px;">
									<c:forEach var="line" items="${list}">
										<li>
											<div title="${line.item}" style="line-height: 30px; height:30px; outline: 1px solid #ddd; overflow: hidden; text-overflow: ellipsis;">
												<span style="white-space: nowrap;">${line.item}</span>
											</div>
										</li>
									</c:forEach>
								</ul>
							</div>
						</c:if>
							
						<c:if test="${vo.status eq 1}">
							<div class="directionBtn">
								<button id="immediatelyDirection" class="direcDiv" align="center" style="right: 5px; background: darkcyan;"><div class="direcTextDiv"><spring:message code='ezLadder.t106' /></div></button>
								<button id="autoDirection" class="direcDiv" align="center" style="right: 160px; background: salmon;"><div class="direcTextDiv"><spring:message code='ezLadder.t107' /></div></button>
							</div>
							<div id="ladderLineBox" style="border: 1px solid #ddd; background: #FFF; min-width: 750px;">
								<div style="height: 140px;">
									<ul id="attendantList" style="width: ${fn:length(list) * 150}px;">
										<c:forEach var="line" items="${list}" varStatus="status">
											<li>
												<div id="drag${status.index}" style="padding-top:  20px; cursor: pointer;">
														<c:choose>
															<c:when test="${empty line.pic}">
																<span class="userPicWraper_d">
																	<img src="/images/ezLadder/icon_defaultAttendant.png" width="60px" height="60px" style="display: block;" />
																</span>
															</c:when>
															<c:otherwise>
																<span class="userPicWraper">
																	<img src="${line.pic}" width="60px" height="60px" />
																</span>
															</c:otherwise>
														</c:choose>
													<div title="${line.userName}" style="line-height: 30px; background: white; height: 30px; outline: 1px solid #ddd; margin-top: 10px; overflow: hidden; text-overflow: ellipsis;"><span style="white-space: nowrap;">${line.userName}</span></div>
												</div>
											</li>
										</c:forEach>
									</ul>
								</div>
								<div id="lineDiv" style="position: relative; z-index: 1;">
									<span></span>
									<canvas id='ladderCanvasLine' width='0' height='800'></canvas>
									<canvas id='ladderCanvas' width='0' height='800'></canvas>
								</div>
								<ul id="itemList" style="margin-top: 10px; width: ${fn:length(list) * 150}px; height: 50px;">
									<c:forEach var="line" items="${list}">
										<li>
											<div title="${line.item}" style="line-height: 30px; height:30px; outline: 1px solid #ddd; overflow: hidden; text-overflow: ellipsis;">
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
			<div id="commentArea" style="border:1px solid #DDD; margin:15px 0px 0px 0px; width:100%; min-width:800px; border-bottom: none;">
				<div id="sendComment" class="voteComment" style="width:100%; border-bottom: 1px solid #dddddd; border-left: none; border-right: none;">
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
								<div style="width: 38px; height: 38px; overflow: hidden; border: 1px solid #DDD; border-radius: 20px; margin-top: 10px; cursor: pointer;"><img src="${empty _comt.pic ? '/images/ezLadder/icon_defaultAttendant.png' : _comt.pic}" style="height: 38px; width:38px;"></div>
							</td>
							<td>
								<div class="userName">${_comt.userName}</div>
								<div id="div2Cmt<c:out value ="${_comt.id}" />" style="display: inline-block; height: auto; padding:10px 0px 10px 20px; max-width: 1300px;" >
									<p id="cmtArea<c:out value ="${_comt.id}" />" style="word-break: break-all; margin-top: 0px;margin-bottom: 0px;"><c:out value ="${_comt.comment}" /></p>
								</div>
								<div id="editCmtDiv<c:out value ="${_comt.id}" />" style="display: none;"></div>
							</td>
							<td style="width: 145px; position:relative;">
								<div style="position: absolute; top:10px; right:18px; color:#a3a3a3; white-space:nowrap;"><c:out value ="${_comt.writeDate}" /></div>
								<c:if test="${_comt.userId == id}">								
									<img src="/images/option3.png" style="margin:30px 10px 0px 0px; position:absolute;top:0;right:0; padding:0px; cursor: pointer;" height=25 width=25 vertical-align="middle" name="editComtButton" _comtIndex="editComt<c:out value ="${_comt.id}"/>" />
									<div id="editComt<c:out value ="${_comt.id}"/>" style="float:right; display: none; position: absolute; top:30px; right:28px; z-index: 10 ; border: 1px solid #ddd; background-color: #576652; color: white; width: 120px;" tabindex=0>							
										<div id="_eCmt<c:out value ="${_comt.id}" />" _comtIndex="editComt<c:out value ="${_comt.id}" />" style="border-bottom: 1px solid #ddd; text-align: center; padding:6px 0px; color:#333; background:#eaeaea; cursor: pointer;"><spring:message code="ezLadder.t052" /></div>
										<div id="_dCmt<c:out value ="${_comt.id}" />"_comtIndex="<c:out value ="${_comt.id}" />" style="text-align: center; padding:6px 0px; background:#eaeaea; color:#333; cursor: pointer;"><spring:message code="ezLadder.t053" /></div>
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