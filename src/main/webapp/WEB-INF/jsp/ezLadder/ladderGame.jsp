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
	<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css">
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="/js/ezPoll/stomp.min.js"></script>
	<script type="text/javascript" src="/js/ezPoll/sockjs.min.js"></script>
	
	<script type="text/javascript">
	
		var id = "${id}";
		var searchSelect = "${searchSelect}";
		var searchInput =  "${searchInput}";
		var mode = "${mode}";
		var currPage = "${currPage}";
		var back = "back";
		var allData = [];
		var size = "${ fn:length(list)}";
		var lineCnt = "${vo.lineCnt}"
		var ladderId = "${vo.ladderId}";
		
		var stompClient = null;
		var servername = null;
		
		$(window).unload(function() {
			if (stompClient !== null) {
		        stompClient.disconnect();
		    }
		});

		/** 180320 추가 : 사다리 재사용 */
		$(function() {
			showComments();
			getCmtSockConnect();
			
			$("#usePreladder").on("click", function() {
				window.location.href = "/ezLadder/setLadder.do?ladderId=" + ${vo.ladderId};
			});
			$("#saveCmtBtn").on("click", function() {
				setComment("add");
			});
			$(document).on("click", ".cmtmodify", function() {
				var cmtId = $(this).attr("id").substring(4);
				if($(this).attr("data") === "OK") {
					setComment("modify", cmtId);
				} else {
					createModifyInput(cmtId);
				}
			});
			$(document).on("click", "#mod_cancle", function() {
				$(".modiTd").remove();
				$("#cmtTable td").removeClass("hideTd").css("display", "");
			});
			$(document).on("click", ".cmtdelete", function() {
				var cmtId = $(this).attr("id").substring(4);
				setComment("delete", cmtId);
			})
		});
		
		/** 웹소켓 */
		function getCmtSockConnect() {
			servername = location.hostname;
			var sock = new SockJS("/hello");
			stompClient = Stomp.over(sock);
			stompClient.connect({}, function() {
				stompClient.subscribe("/ladcmt/subscribe/test", function(result) {
					console.log(result);
					console.log("ricieve---------");
				});
				stompClient.subscribe("/lad/cmt/" + id + "/addCmt/" + ladderId, function(result) {
					var cmtjson = JSON.parse(result.body);
					var html = "";
					
					html += "<tr id='cmtTr_" + cmtjson["id"] + "'>";
					html += "<td>" + cmtjson["userName"] + "</td>";
					html += "<td>" + cmtjson["comment"] + "</td>";
					html += "<td>" + cmtjson["writeDate"] + "</td>";
					html += "<td><div id='mod_" + cmtjson["id"] + "' class='cmtmodify'>modify</div></td>";
					html += "<td><div id='del_" + cmtjson["id"] + "' class='cmtdelete'>delete</div></td>";
					html += "</tr>";
					
					$("#cmtTable").prepend(html);
				});
				stompClient.subscribe("/lad/cmt/" + id + "/modifyCmt/" + ladderId, function(result) {
					var cmtjson = JSON.parse(result.body);
					var html = "";
					
					$("#cmtTr_" + cmtjson["id"]).remove();
					
					html += "<tr id='cmtTr_" + cmtjson["id"] + "'>";
					html += "<td>" + cmtjson["userName"] + "</td>";
					html += "<td>" + cmtjson["comment"] + "</td>";
					html += "<td>" + cmtjson["writeDate"] + "</td>";
					html += "<td><div id='mod_" + cmtjson["id"] + "' class='cmtmodify'>modify</div></td>";
					html += "<td><div id='del_" + cmtjson["id"] + "' class='cmtdelete'>delete</div></td>";
					html += "</tr>";
					
					$("#cmtTable").prepend(html);					
				});
				stompClient.subscribe("/lad/cmt/" + id + "/deleteCmt/" + ladderId, function(result) {
					var cmtjson = JSON.parse(result.body);
					
					$("#cmtTr_" + cmtjson["id"]).remove();
				});
			});
		}
		
		function createModifyInput(cmtId) {
			var origCmt = $("#cmtTr_" + cmtId + " td:eq(1)").text();
			$(".modiTd").remove();
			$("#cmtTable td").removeClass("hideTd").css("display", "");
			$("#cmtTr_" + cmtId + " td").not("td:eq(0)").addClass("hideTd").css("display", "none");
			
			var html = "";
			html += "<td colspan='2' class='modiTd'><input type='text' id='modifyCmtBox' value='" + origCmt + "' style='width: 100%;' /></td>";
			html += "<td class='modiTd'><div id='mod_" + cmtId + "' data='OK' class='cmtmodify'>확인</div></td>";
			html += "<td class='modiTd'><div id='mod_cancle' class='cmtmodify'>취소</div></td>";
			
			$("#cmtTr_" + cmtId).append(html);
		}
		
		function setComment(flag, cmtId) { // 댓글 추가, 수정, 삭제 (flag: add, modify, delete)
			var comment = "";
			if(flag === "add") {
				comment = $("#inputCmtBox").val();					
			} else if(flag === "modify") {
				comment = $("#cmtTr_" + cmtId + " input").val();
			} 
			
			$.ajax({
				type: "POST",
				url: "/ezLadder/setLadderComment.do",
				dataType: "json",
				data: {
					"flag": flag,
					"id": cmtId,
					"ladderId": ladderId,
					"comment": comment
				},
				success: function(result) {
					console.log(result);
				}
			});
		}
		
		function sendTest() {
			console.log("send---------");
			var msg = "send test? 한글은?";
			var json = {"msg": "send test? 한글은?", "msg2": "json"};
			stompClient.send("/app/ladtest", {}, JSON.stringify(json));
		}
		
		function showComments() { // 댓글 조회
			var html = ""
			
			$.ajax({
				type: "GET",
				url: "/ezLadder/getLadderComment.do",
				dataType: "json",
				data: {
					"ladderId": "${vo.ladderId}"
				},
				success: function(result) {
					var cmtlist = result["cmtlist"];
					
					cmtlist.forEach(function(cmt) {
						html += "<tr id='cmtTr_" + cmt["id"] + "'>";
						html += "<td>" + cmt["userName"] + "</td>";
						html += "<td>" + cmt["comment"] + "</td>";
						html += "<td>" + cmt["writeDate"] + "</td>";
						html += "<td><div id='mod_" + cmt["id"] + "' class='cmtmodify'>modify</div></td>";
						html += "<td><div id='del_" + cmt["id"] + "' class='cmtdelete'>delete</div></td>";
						html += "</tr>";
					});
					
					$("#cmtTable").append(html);
				}
			});
		}
		
		function deleteLadder(idx) {
		
			allData = [idx, searchSelect, searchInput, mode, currPage, back ];	
		
			if (confirm('삭제 하시겠습니까?')) {
				window.location.href= '/ezLadder/deleteLadder.do?allData=' + allData;
			} 
		}
		
		/* 
		function start(idx) {
			allData = [idx, searchSelect, searchInput, mode, currPage, size, lineCnt ];	
			if (confirm('시작하시겠습니까?')) {
				window.location.href= '/ezladder/setLadderStart.do?allData=' + allData;
			}
		} */
	</script>
	<style type="text/css">
		ul {
		    list-style:none;
		    margin:0;
		    padding:0;
		}
		
		li {
		    margin: 0 0 0 0;
		    padding: 0 0 0 0;
		    border : 0;
		    float: left;
		    text-align: center;
		}
		
		.blackBox {
			width:100%;height:500px;
			border:30px solid transparent; 
			color:black;
			background: #010;
			border-color:#010;
		}
		
		.cmtdelete, .cmtmodify {
			cursor: pointer;
		}
		.cmtdelete:HOVER, .cmtmodify:HOVER {
			background: beige;
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
		<div class="fullwidth">
			<table class="setTable">
				<tr>
					<td style="width: 5000px;"></td><td></td>
				</tr>
				
				
				<tr>
					<td colspan="4" style="height: 700px; padding: 10px 0px;">
						<div class="wrap center" style="height: 100%; width: 100%;">
							<div id="ladderLineBox" style="height: 100%; width: 100%; border: 1px solid gray">
								<c:choose>
									<c:when test="${vo.status eq 0 }">
										<%@ include file="include/ladderWait.jsp"%> 
									</c:when>
									<c:otherwise>
										<%@ include file="include/ladderComplete.jsp"%> 
									</c:otherwise>
								</c:choose>
								<br><br><br><br>
							</div>
						</div>
					</td>
				</tr>
			</table>
			
			
		</div>
		
<div>
	<table style="width: 100%;">
		<tr>
			<td>
				<input type="text" id="inputCmtBox" placeholder="댓글작성칸" style="width: 90%;"/>
				<button id="saveCmtBtn">댓글 등록</button>
			</td>
		</tr>
	</table>
	<table id="cmtTable" style="width: 100%;"></table>

	<button onclick="sendTest()">socket test!!</button>
</div>
		<!-- <div id="ladderGame" align="center" >
			<br><br><br><br>
			상태가 대기이면 ladderWait.jsp 호출<br>
			상태가 완료이면 ladderComplete.jsp 호출<br><br><br>
			
			<br><br><br><br><br><br><br><br><br><br><br><br><br>
		</div> -->
		
		
		<div id="chat" align="center">
			<%@ include file="include/ladderChat.jsp"%> 
		</div>
	<h3>
		* 프론트 꾸며야 됨.<br>
		* 웹소켓 - 참여자 바꾸기, 채팅
		</h3>
	
	</body>
</html>