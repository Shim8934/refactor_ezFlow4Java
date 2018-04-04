<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="<spring:message code='ezLadder.e2' />" type="text/css">
	<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css" type="text/css">
	<link rel="stylesheet" href="/css/ezPoll/vote.css" type="text/css">
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
	<script type="text/javascript" src="/js/ezPoll/stomp.min.js"></script>
	<script type="text/javascript" src="/js/ezPoll/sockjs.min.js"></script>
	<script type="text/javascript" src="/js/ezLadder/ladder.js"></script>
	
	<script type="text/javascript">
	
		var _ladder = {};
		var _ladderLine = [];
		var id = "${id}";
		var writerId = "${vo.writerId}";
		var status = "${vo.status}";
		var searchSelect = "${searchSelect}";
		var searchInput =  "${searchInput}";
		var mode = "${mode}";
		var currPage = "${currPage}";
		var back = "back";
		var allData = [];
		var size = "${fn:length(list)}";
		var lineCnt = "${vo.lineCnt}"
		var ladderId = "${vo.ladderId}";
		var dragloc = {};
		var droploc = {};
		var stompClient = null;
		var servername = null;
		var attendants = { "id": [], "name": [], "name2": [], "pic": [], "order": [] };
		var items = []; 
		/* var lad = "${vo.lineArray}"; */
		/* var ladArr = lad.split(''); */
		var height = 10;
		var resultUser = new Array;
		var seeAllcnt = 0;
		var pathColor = new Array;
		/* window.onload = function() {
			draw();
		} */
		$(window).unload(function() {
			if (stompClient !== null) {
		        stompClient.disconnect();
		    }
		});
	
		
		function ladder_window_resize() {
			var win_width = $(window).width() - 70;
			var line_width = $("#attendantList").css("width").replace(/[^0-9]/g,'') * 1;
			
			$(".setTable").css("width", win_width + "px");
			$("#ladderLineBox").css("width", win_width + "px");
			
			if(line_width > win_width) {
				$("#blackBox").css("width", (line_width + 100) + "px");
			} else {
				$("#blackBox").css("width", (win_width + 50) + "px");
			}
		}
		
		function initValues() {
			_ladder = ${vo};
			_ladderLine = ${list};
		}
		
		function afterDrag() {
			$("#" + dragloc.id).css("z-index", "10").animate({"left": originalPosition_left + dragloc.left * 150, "top": dragloc.top}, 400);
			$("#" + droploc.id).css("z-index", "10").animate({"left": originalPosition_left + droploc.left * 150}, 400);
		}
		
		/** 참여자 위치 바꾸기 */
		function changeListOrder() {
			var ladId1 = dragloc["id"].substring(4);
			var ladId2 = droploc["id"].substring(4);
			var ladorder1 = _ladderLine[ladId1].ladderOrder;
			var ladorder2 = _ladderLine[ladId2].ladderOrder;
			
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
					_ladderLine[ladId1].ladderOrder = ladorder2;
					_ladderLine[ladId2].ladderOrder = ladorder1;
				}
			});
		}
		
		var dragcnt = 0;
		var originalPosition_left = 0;
		$(function() {
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
				clickUserLadderAnimation();
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
					aniAllUser();
				})
				.on("click", "#immediatelyDirection", function() {
					// 사다리 바로 보기
					popAllUser();
				});
			
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
					addCommentView["type"] = "prepend";
					addCommentView["contents"] = cmtjson;
					
					showCommentList(addCommentView);
				});
				stompClient.subscribe("/lad/cmt/modifyCmt/" + ladderId, function(result) { // modify comment
					var cmtjson = JSON.parse(result.body);
					
					if(cmtjson["userId"] === id) {
						modifyComt(cmtjson["id"]);
					}
					$("#cmtArea" + cmtjson["id"]).text(cmtjson["comment"]);
				});
				stompClient.subscribe("/lad/cmt/deleteCmt/" + ladderId, function(result) { // delete comment
					var cmtjson = JSON.parse(result.body);
					
					$("tr[_comtIndex='" + cmtjson["id"] + "']").remove();
				});
				//stompClient.subscribe("/lad/userOrder/change/" + ladderId, function(result) {	// 참여자 위치 바꾸기 subscribe
					/* var lines = JSON.parse(result.body);
				
					var copyLadLi1 = $("#attendantList li:eq(" + changeLadId1 + ")").html();
					var copyLadLi2 = $("#attendantList li:eq(" + changeLadId2 + ")").html();
					
					$("#attendantList li:eq(" + changeLadId1 + ")").html(copyLadLi2);
					$("#attendantList li:eq(" + changeLadId2 + ")").html(copyLadLi1);
					
					$("#attendantList li:eq(" + changeLadId1 + ") > div").attr("id", "drag" + changeLadId1);
					$("#attendantList li:eq(" + changeLadId2 + ") > div").attr("id", "drag" + changeLadId2); */
				 	/* $("#attendantList").html("");
					$("#itemList").html("");
					for(var i = 0; i < lines.length; i++) {
						html = "";
						picsrc = "/images/OrganTree/porson_noimg.gif";
						html += "<li class='attendant'>";
						if(attendants["id"][i].substring(0, 14) === "anonyAttendant") {
						} else {
							picsrc = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + attendants["pic"][i];
						}
						html += "<div class='ladderDrag' id='drag" + i + "'><img src='" 
									+ picsrc + "' width='90px' height='90px' />";
						html += "<div>" + lines[i]["userName"] + "</div>";
						 
						$("#attendantList").append(html);
						$("#itemList").append("<li class='item'>" + lines[i]["item"] + "</li>");
					} 
					add_user_change_ulsize(attendants["id"].length); 
				
					if("${vo.status}" == 0) {
						drag();
					} */
					
				//});
				stompClient.subscribe("/lad/start/" + ladderId, function(ladderInfo) {	
					var cmtjson = JSON.parse(ladderInfo.body);
					
					console.log("dddddddddddd머ㅗ아ㅑ내앨");
					
					_ladder = cmtjson["ladder"];
					_ladderLine = cmtjson["ladderline"];
					canvasSetting();
					$("#blackBox").remove();
				});
			});
		}
		function canvasSetting() {
			wInfo = _ladderLine.length;
			lad = _ladder["lineArray"];
			ladArr = lad.split('');
			ladderlinecnt = _ladder["lineCnt"];
			
			if(status == 0) {
				clickUserLadderAnimation();
				if(id == lad.writerId) {
					$(".ladderDrag").draggable("destroy");
				}
				$("#lineDiv").html(
					"<canvas id='ladderCanvasLine' width='0' height='800'></canvas>" +
					"<canvas id='ladderCanvas' width='0' height='800'></canvas>"
				).css("z-index", "-1");
				$("#directionBtn").html(
					'<div id="immediatelyDirection" align="center">바로 보기</div>' + 
					'<div id="autoDirection" align="center">자동 진행</div>'
				);
			}
			
			$("canvas").attr("width", (wInfo * wSize));
			
			setDefaultLad();
			setLadInfo();
			printLadLine();
			setUserPath();
		}
		function clickUserLadderAnimation() {
			$(document)
			.on("click", "[id^=drag]", function() {
				var usernum = $(this).attr("id").slice(4);
				if(userStatus[usernum] == 0) {
					aniOneUser(usernum);
				} else {
					popOneUser(usernum);
				}
			});
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
			allData = [idx, searchSelect, searchInput, mode, currPage, size, lineCnt ];	
			if (confirm('시작하시겠습니까?')) {
				jQuery.ajaxSettings.traditional = true;
				$.ajax({
					type: "POST",
					url: "/ezLadder/setLadderStart.do",
					dataType: "json",
					async: false,
					data: {
						"allData": allData
					},
					success: function() {
						loadLadder();
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
				}/* ,
				success: function(ladderInfo) {
					_ladder = ladderInfo["vo"];
					_ladderLine = ladderInfo["list"];
					canvasSetting();
					$("#blackBox").remove();
				} */
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
					"id": cmtId,
					"ladderId": ladderId,
					"comment": comment
				}
			});
		}
		function showCommentList(addCommentView) {
			var cmt = addCommentView["contents"];
			var html = "";
			
			html += '<tr style="border-bottom: 1px dotted #ddd;" _comtIndex="' + cmt["id"] + '">';
			html += '<td style="padding: 0px 0px 0px 10px; width: 24px; height: 24px; vertical-align:top; "><img src="' + cmt["pic"] + '" style="padding-top: 10px; height: 38px; width:38px; cursor: pointer; " onclick="menuQst_DetailUserInfo(' + cmt["userId"] + ');"></td>';
			html += '<td><div class="userName">' + cmt["userName"] + '</div>';
			html += '<div id="div2Cmt' + cmt["id"] + '" style="display: inline-block; height: auto; padding:10px 0px 10px 20px; max-width: 1300px;" >';
			html += '<p id="cmtArea' + cmt["id"] + '" style="word-break: break-all; margin-top: 0px;margin-bottom: 0px;">' + cmt["comment"] + '</p></div>';
			html += '<div id="editCmtDiv' + cmt["id"] + '" style="display: none;"></div></td>';
			html += '<td style="width: 145px; position:relative;">';
			html += '<div style="position: absolute; top:10px; right:18px; color:#a3a3a3; white-space:nowrap;">' + cmt["writeDate"] + '</div>';
			html += '<img src="/images/option3.png" style="margin:30px 10px 0px 0px; position:absolute;top:0;right:0; padding:0px; cursor: pointer;" height=25 width=25 vertical-align="middle" name="editComtButton" _comtIndex="editComt' + cmt["id"] + '" />';
			html += '<div id="editComt' + cmt["id"] + '" style="float:right; display: none; position: absolute; top:30px; right:28px; z-index: 10 ; border: 1px solid #ddd; background-color: #576652; color: white; width: 120px;" tabindex=0>';
			html += '<div id="_eCmt' + cmt["id"] + '" _comtIndex="editComt' + cmt["id"] + '" style="border-bottom: 1px solid #ddd; text-align: center; padding:6px 0px; color:#333; background:#eaeaea; cursor: pointer;">댓글 수정</div>';
			html += '<div id="_dCmt' + cmt["id"] + '" _comtIndex="' + cmt["id"] + '" style="text-align: center; padding:6px 0px; background:#eaeaea; color:#333; cursor: pointer;">댓글 삭제</div></div></td></tr>';
			
			$("#commentArea table").prepend(html);
			var comtInputTop = $("#sendComment").offset().top;
			$(document).scrollTop(comtInputTop); 
			
			addCommentView = [];
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
				html += '<button id="clA1cmt' + editComtFlag + '" class="voteCancelBttn" _comtindex="' + editComtFlag + '">취소</button>';
				html += '<button id="clA2cmt' + editComtFlag + '" class="voteSaveBttn" _comtindex="' + editComtFlag + '" style="background-color: rgb(0, 72, 150);">저장</button></div>';
			} 
			
			$("#div2Cmt" + comtIndex).toggle();
			$("#_eCmt" + comtIndex).toggle();
			$("#editCmtDiv" + comtIndex).html(html).toggle();
			
		}
		/** 댓글 삭제 */
		function deleteComt(comtIndex) {
			var result = confirm("이 댓글을 삭제하시겠습니까?");
			
			if(result) {
				setComment("delete", comtIndex, "");
			}

		}
		function auto_grow(element) {
			if (element.value == "" && document.getElementById("uploadedFile").style.display == "none") {
				document.getElementById("sendBttn").style.backgroundColor = "#d0d0d0";
				document.getElementById("sendBttn").disabled = true;
			}
			else {
				document.getElementById("sendBttn").style.backgroundColor = "#004896";
		    	document.getElementById("sendBttn").disabled = false;
			        element.style.height = "1px"; 			        
			        var value = element.scrollHeight;
		        element.style.height = (element.scrollHeight - 32) + "px";			        
		        document.getElementById("sendComment").style.height = value + 18 + "px";
			}
	    }
		
	</script>
	<style type="text/css">
		#autoDirection {
			background: #fff;
			border: 6px solid #ded;
			width: 100px;
			height: 50px;
			float: right;
			margin-right: 5px;
			line-height:30px;
		}
		
		#immediatelyDirection {
			background: #fff;
			border: 6px solid #def;
			width: 100px;
			height: 50px;
			float:right;
			margin-right: 20px;
			line-height:30px;
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
		
		.cmtdelete, .cmtmodify {
			cursor: pointer;
		}
		.cmtdelete:HOVER, .cmtmodify:HOVER {
			background: beige;
		}
		
		.directionBtn {
			position: relative; top:70px; right:10px;
			vertical-align: middle;
			
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
	</style>
</head>
	<body class="mainbody">
		<div id="ladderInfo" style="margin-top: 50px; margin-left: 50px; margin-right: 50px;">
			<h2>${vo.title }
				<span style="float: right; font-weight:normal;color:black;">
					종류 : ${vo.type }, 상태 : ${vo.status }, 공개 : ${vo.secretFlag } | 작성자 ${vo.writerName }, 부서 ${vo.deptName }, 
					<div id="usePreladder" style="display: inline-block; cursor: pointer;">
						<img src ='/images/ezLadder/reuse.png' width='30' height ='30'/>
					</div>,
					<c:choose>
						<c:when test="${id eq vo.writerId }">
							<a href="#" onclick="deleteLadder(${vo.ladderId})"><img src ='/images/ezLadder/trash.png' width='30' height ='30'/></a><br>
						</c:when>
						<c:otherwise>
							<img src ='/images/ezLadder/trash.png' width='30' height ='30'/><br>
						</c:otherwise>
					</c:choose>
				</span> 
			</h2>
		</div>
		<br>
		<div class="directionBtn">
			<c:if test="${vo.status eq 1 }">
					<div id="immediatelyDirection" align="center">바로 보기</div>
					<div id="autoDirection" align="center">자동 진행</div>
			</c:if>
		</div>
		
		<div class="fullwidth" style="margin-top: 100px;" >
			<table class="setTable" style="position: relative;">
				<tr>
					<td>
						<div id="ladderLineBox" style="border: 1px solid #ddd;">
							<c:if test="${vo.status eq 0}">
							<div style="height: 140px;">
								<ul id="attendantList" style="width: ${fn:length(list) * 150}px;">
									<c:forEach var="line" items="${list}" varStatus="status">
										<li _attendantIndex="${status.index}">
											<div class="ladderDrag" id="drag${status.index}">
												<div>
													<img src="${line.pic}" width="90px" height="90px" />
													<div style="line-height: 30px; outline: 1px solid #ddd; margin-top: 10px;"><span>${line.userName}</span></div>
												</div>
											</div>
										</li>
									</c:forEach>
								</ul>
							</div>
							<div id="lineDiv" style="position: relative; height: 800px;">
								<div id="blackBox" style="height: 800px;background: gray;position: absolute;left: -50px;right: 0;">
									<div id="startButton">
										<c:choose>
											<c:when test="${id eq vo.writerId }">
												<a href="#" onclick="start(${vo.ladderId})"><img src ='/images/ezLadder/start.png' width='50' height ='50'/></a>
											</c:when>
											<c:otherwise>
												<span>누를수없음...</span>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>
							<ul id="itemList" style="margin-top: 10px; width: ${fn:length(list) * 150}px;">
								<c:forEach var="line" items="${list}">
									<li style="line-height: 30px; outline: 1px solid #ddd;"><span>${line.item}</span></li>
								</c:forEach>
							</ul>
							</c:if>
							
							<c:if test="${vo.status eq 1}">
							<div style="height: 140px;">
								<ul id="attendantList" style="width: ${fn:length(list) * 150}px;">
									<c:forEach var="line" items="${list}" varStatus="status">
										<li>
											<div id="drag${status.index}">
												<img src="${line.pic}" width="90px" height="90px" />
												<div style="line-height: 30px; outline: 1px solid #ddd; margin-top: 10px;"><span>${line.userName}</span></div>
											</div>
										</li>
									</c:forEach>
								</ul>
							</div>
							<div id="lineDiv" style="position: relative; z-index: -1;">
								<canvas id='ladderCanvasLine' width='0' height='800'></canvas>
								<canvas id='ladderCanvas' width='0' height='800'></canvas>
							</div>
							<ul id="itemList" style="margin-top: 10px; width: ${fn:length(list) * 150}px;">
								<c:forEach var="line" items="${list}">
									<li style="line-height: 30px; outline: 1px solid #ddd;"><span>${line.item}</span></li>
								</c:forEach>
							</ul>
							</c:if>
						</div>
					</td>
				</tr>
			</table>
			
			
		</div>
		<c:if test="${mode != 'preview' }">
			<div id="commentArea" style="border:1px solid #DDD; margin:20px 0px 0px 0px; width:100%; min-width:800px; border-bottom: none;">
				<div id="sendComment" class="voteComment" style="width:100%;">
	            	<div class="sendComment_layout">
	            		<div class="comment_input_layout">
							<textarea cols="20" rows="1" id="comment_input" oninput="auto_grow(this)" maxlength="500"></textarea>
						</div>
						<div class="commentBtn">
							<button id="sendBttn" disabled="disabled" style="display:inline-block; width: 96px; cursor:pointer; height:45px; border:none; border-radius:5px; background:#d0d0d0; color:#FFF; margin:0px; padding:0px; text-align: center; vertical-align: middle;">등록</button>						
						</div>
	            	</div>
	            </div>
				<table style="width: 100%;" id="commentListView">
					<c:forEach var="_comt" items="${cmtlist}">
						<tr style="border-bottom: 1px dotted #ddd;" _comtIndex="<c:out value ="${_comt.id}" />">
							<td style="padding: 0px 0px 0px 10px; width: 24px; height: 24px; vertical-align:top; ">
								<img src="${_comt.pic}" style="padding-top: 10px; height: 38px; width:38px; cursor: pointer; " onclick="menuQst_DetailUserInfo('${_comt.userId}');">
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
										<div id="_eCmt<c:out value ="${_comt.id}" />" _comtIndex="editComt<c:out value ="${_comt.id}" />" style="border-bottom: 1px solid #ddd; text-align: center; padding:6px 0px; color:#333; background:#eaeaea; cursor: pointer;">댓글 수정</div>
										<div id="_dCmt<c:out value ="${_comt.id}" />"_comtIndex="<c:out value ="${_comt.id}" />" style="text-align: center; padding:6px 0px; background:#eaeaea; color:#333; cursor: pointer;">댓글 삭제</div>
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