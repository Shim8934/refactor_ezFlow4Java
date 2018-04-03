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
		var dragloc = {};
		var droploc = {};
		var stompClient = null;
		var servername = null;
		var attendants = { "id": [], "name": [], "name2": [], "pic": [], "order": [] };
		var items = []; 
		var lad = "${vo.lineArray}";
		var ladArr = lad.split('');
		var height = 10;
		var resultUser = new Array;
		var seeAllcnt = 0;
		var pathColor = new Array;
		window.onload = function() {
			draw();
		}
		$(window).unload(function() {
			if (stompClient !== null) {
		        stompClient.disconnect();
		    }
		});
	
		
		function ladder_window_resize() {
			var win_width = $(window).width() - 20;
			
			$(".setTable").css("width", win_width + "px");
			$("#ladderLineBox").css("width", (win_width - 40) + "px");
			$("#autoDirection").css("width", $(window).width()/12 + "px");
			$("#immediatelyDirection").css("width", $(window).width()/12 + "px");
			
		}
		
		/** 180320 추가 : 사다리 재사용 */
		$(function() {
			setAllUser();
			setAttendantsView(); 
			init_comment();
		
			
			
			$("#blackBox").css("width", size*147 + "px");
			$("#startButton").css("left", size*130/2 + "px");
			$(".setTable").css("width",  $(window).width() - 20 + "px");
			$("#ladderLineBox").css("width", $(window).width() - 60 + "px");
			$("#autoDirection").css("width", $(window).width()/12 + "px");
			$("#immediatelyDirection").css("width", $(window).width()/12 + "px");
			$(window).resize(function() {
				ladder_window_resize();
			});
			
			
			$("#usePreladder").on("click", function() {
				window.location.href = "/ezLadder/setLadder.do?ladderId=" + ${vo.ladderId};
			});
			/* $("#saveCmtBtn").on("click", function() {
				if($("#inputCmtBox").val() !== "") {
					setComment("add");
				}
			});
			$("#inputCmtBox").on("keyup", function(e) {
				if(e.keyCode === 13 && $("#inputCmtBox").val() !== "") {
					setComment("add");
				} 
			});
			$(document).on("click", "#modify", function() {
				var cmtId = $(this).attr("cmtid");
				if($(this).attr("data") === "OK") {
					if($("#modifyCmtBox").val() !== "") {
						console.log("모디파이확인");
						setComment("modify", cmtId);
					} else {
						$("#modifyCmtBox").focus();
					}
				} else {
					createModifyInput(cmtId);
				}
			});
			$(document).on("click", "#mod_cancle", function() {
				$(".modiDiv").remove();
				$("#commentDiv div").css("display", "");
			});
			$(document).on("click", "#delete", function() {
				var cmtId = $(this).attr("cmtid");
				setComment("delete", cmtId);
			}) */
			
			$("#autoDirection").on("click", function() {
				alert("자동진행_임시");
				var that = "#72A100";
			
				startLineDrawing("1-0", that);

			});
			
			
			/** 바로 보기 */
			$("#immediatelyDirection").on("click", function() { 	
				if(seeAllcnt == 0) {
					<c:forEach items="${list }" var="ladderLineList">	
						resultUser.push("${ladderLineList.resultUserName}");
					</c:forEach>
					var len = resultUser.length;
					var html = "";
					
					$("#seeAll").html("");
					if(resultUser !== null) {
						for(var i = 0; i < len; i++) {
							html = "<li class='resultUsers'><div id='resultUser" + i + "'>"	+ resultUser[i] + "</div></li>";		
							$("#seeAll").append(html);
						}
					}
					seeAllcnt++;
				}
			});
			setPathColor();
			
		});
		
		function init_comment() {
			if(mode !== "preview") {
				getCmtSockConnect();
			}
		}
		
		/** 참여자 위치 바꾸끼*/
		function changeListOrder() {
			var ladId1 = dragloc["id"].substring(4);
			var ladId2 = droploc["id"].substring(4);
			
			$.ajax({
				type: "POST",
				url: "/ezLadder/serUserOrder.do",
				dataType: "json",
				traditional: true,
				data: {
					"ladderId": ladderId,
					"firstUser": attendants["id"][ladId1],
					"firstUserOrder": ladId1,
					"secondUser": attendants["id"][ladId2],
					"secondUserOrder": ladId2,
					"firstItem": items[ladId1],
					"secondItem": items[ladId2]
				},
				success: function() {			
					var temp = { "id": [], "name": [], "name2": [], "pic": [], "order": []};
					temp["id"][0] = attendants["id"][ladId1];
					temp["name"][0] = attendants["name"][ladId1];
					temp["name2"][0] = attendants["name2"][ladId1];
					temp["pic"][0] = attendants["pic"][ladId1];
					temp["order"][0] = attendants["order"][ladId1];
				
					attendants["id"][ladId1] =  attendants["id"][ladId2];
					attendants["name"][ladId1] = attendants["name"][ladId2];
					attendants["name2"][ladId1] = attendants["name2"][ladId2];
					attendants["pic"][ladId1] = attendants["pic"][ladId2];
					attendants["order"][ladId1] = attendants["order"][ladId2];
					
					attendants["id"][ladId2] =  temp["id"][0];
					attendants["name"][ladId2] = temp["name"][0];
					attendants["name2"][ladId2] = temp["name2"][0];
					attendants["pic"][ladId2] = temp["pic"][0];
					attendants["order"][ladId2] = temp["order"][0];
				
					setAttendantsView(); 
				}
			});
		}
		
		/** 웹소켓 */
		var addCommentView = [];
		function getCmtSockConnect() {
			servername = location.hostname;
			var sock = new SockJS("/hello");
			stompClient = Stomp.over(sock);
			stompClient.connect({}, function() {
				stompClient.subscribe("/lad/cmt/addCmt/" + ladderId, function(result) {
					var cmtjson = JSON.parse(result.body);
					console.log("cmtjson : " + cmtjson);
					addCommentView["type"] = "prepend";
					addCommentView["contents"] = cmtjson;
					
					showCommentList(addCommentView)
				});
				stompClient.subscribe("/lad/cmt/modifyCmt/" + ladderId, function(result) { //수정..
					var cmtjson = JSON.parse(result.body);
					
					$("#cmt_" + cmtjson["id"]).parent(".cmt_wrap").remove();
					
					addCommentView["type"] = "prepend";
					addCommentView["contents"] = cmtjson;
					
					showCommentList(addCommentView)
				});
				stompClient.subscribe("/lad/cmt/deleteCmt/" + ladderId, function(result) {
					var cmtjson = JSON.parse(result.body);
					
					$("#cmt_" + cmtjson["id"]).parent(".cmt_wrap").remove();
				});
				
				stompClient.subscribe("/lad/userOrder/change/" + ladderId, function(result) {	// 참여자 위치 바꾸기 subscribe
					var lines = JSON.parse(result.body);
					
				 	$("#attendantList").html("");
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
					}
					
				});
				
				stompClient.subscribe("/lad/start/" + ladderId, function(result) {		// 시작시 이동 subscribe
					window.location.href = "/ezLadder/getLadderGame.do?ladderId=" + ladderId + "&searchSelect=" + searchSelect +
					"&searchInput=" +  searchInput + "&mode=" + mode + "&currPage=" +  currPage;
				});
			});
		}
		
		function createModifyInput(cmtId) {
			var origCmt = $("#cmt_" + cmtId + " #comment").text();
			var cmtH = $("#cmt_" + cmtId).css("height").substring(0, $("#cmt_" + cmtId).css("height").length-2) - 4;
			
			$(".modiDiv").remove();
			$("#commentDiv div").css("display", "");
			$("#cmt_" + cmtId + " div").not("#name").css("display", "none");
			
			var html = "";
			html += "<div class='modiDiv'><textarea id='modifyCmtBox' style='height: " + cmtH + "px'>" + origCmt + "</textarea></div>"
			html += "<div class='modiDiv icon_wrap'>";
			html += "<div id='modify' cmtid='" + cmtId + "' data='OK' class='icondiv' style='left: 0;'>확인</div>";
			html += "<div id='mod_cancle' class='icondiv' style='right: 0;'>취소</div>";
			html += "</div>";
			
			$("#cmt_" + cmtId).append(html);
			$("#modifyCmtBox").select();
		}
		
		function setComment(flag, cmtId) { // 댓글 추가, 수정, 삭제 (flag: add, modify, delete)
			var comment = "";
			if(flag === "add") {
				comment = $("#comment_input").val();	
				$("#comment_input").val("");
			} else if(flag === "modify") {
				console.log(cmtId);
				comment = $("#cmt_" + cmtId + " #modifyCmtBox").val();
				$("#cmt_" + cmtId + " #modifyCmtBox").text("");
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
				}
			});
		}
		
		function showComments() { // 댓글 조회
			$.ajax({
				type: "GET",
				url: "/ezLadder/getLadderComment.do",
				dataType: "json",
				data: {
					"ladderId": "${vo.ladderId}"
				},
				success: function(result) {
					var cmtlist = result["cmtlist"];
					var addCommentView = [];
					
					addCommentView["type"] = "append";
					cmtlist.forEach(function(cmt) {
						addCommentView["contents"] = cmt;
						
						showCommentList(addCommentView);
					});
					
				}
			});
		}
		
		function showCommentList(addCommentView) {
			var cmt = addCommentView["contents"];
			var type = addCommentView["type"];
			var html = "";
			
			html += '<tr style="border-bottom: 1px dotted #ddd;">';
			html += '<td style="padding: 0px 0px 0px 10px; width: 24px; height: 24px; vertical-align:top; "><img src="' + cmt["pic"] + '" style="padding-top: 10px; height: 38px; width:38px; cursor: pointer; " onclick="menuQst_DetailUserInfo(' + cmt["userId"] + ');"></td>';
			html += '<td><div class="userName">' + cmt["userName"] + '</div>';
			html += '<div id="div2Cmt' + cmt["id"] + '" style="display: inline-block; height: auto; padding:10px 0px 10px 20px; max-width: 1300px;" >';
			html += '<p id="cmtArea' + cmt["id"] + '" style="word-break: break-all; margin-top: 0px;margin-bottom: 0px;">' + cmt["comment"] + '</p></div>';
			html += '<div id="editCmtDiv' + cmt["id"] + '" style="display: none;"></div></td>';
			html += '<td style="width: 145px; position:relative;">';
			html += '<div style="position: absolute; top:10px; right:18px; color:#a3a3a3; white-space:nowrap;">' + cmt["writeDate"] + '</div>';
			html += '<img src="/images/option3.png" style="margin:30px 10px 0px 0px; position:absolute;top:0;right:0; padding:0px; cursor: pointer;" height=25 width=25 vertical-align="middle" id="editComtButton" _comtIndex="editComt' + cmt["id"] + '" onclick="(function(e){e.stopPropagation();})(event); showEditPanel(this);">';
			html += '<div id="editComt' + cmt["id"] + '" style="float:right; display: none; position: absolute; top:30px; right:28px; z-index: 10 ; border: 1px solid #ddd; background-color: #576652; color: white; width: 120px;" tabindex=0>';
			html += '<div id="_eCmt' + cmt["id"] + '" _comtIndex="editComt' + cmt["id"] + '" style="border-bottom: 1px solid #ddd; text-align: center; padding:6px 0px; color:#333; background:#eaeaea; cursor: pointer;" onclick="editComment(this);">댓글 수정</div>';
			html += '<div _comtIndex="' + cmt["id"] + '" style="text-align: center; padding:6px 0px; background:#eaeaea; color:#333; cursor: pointer;" onclick="deleteComment(this);">댓글 삭제</div></div></td></tr>';
			
			$("#commentArea table").prepend(html);
			
			addCommentView = [];
			
			/* var html = "";
			var cmt = addCommentView["contents"];
			var type = addCommentView["type"];
			
			html += "<div class='cmt_wrap'>";
			html += "<div id='cmt_" + cmt["id"] + "' class='cmt'>";
			html += "<div id='name'>" + cmt["userName"] + "</div>";
			html += "<div id='comment'>" + cmt["comment"] + "</div>";
			html += "<div id='date'>" + cmt["writeDate"] + "</div>";
			html += "<div class='icon_wrap'>";
			if(id === cmt["userId"]) {
				html += "<div id='modify' cmtid='" + cmt["id"] + "' class='icondiv' style='left: 0;'>수정</div>";
				html += "<div id='delete' cmtid='" + cmt["id"] + "' class='icondiv' style='right: 0;'>삭제</div>";
			} else {
				html += "<div class='icondiv' style='left: 0; background: beige; cursor: default;'>수정</div>";
				html += "<div class='icondiv' style='right: 0; background: beige; cursor: default;'>삭제</div>";
			}
			html += "</div></div></div>";
			
			
			if(type === "append") {
				$("#commentDiv").append(html);
			} else {
				$("#commentDiv").prepend(html);
			}
			
			addCommentView = []; */
		}
		
		/** 삭제 */
		function deleteLadder(idx) {
			allData = [idx, searchSelect, searchInput, mode, currPage, back ];	
		
			if (confirm('삭제 하시겠습니까?')) {
				window.location.href= '/ezLadder/deleteLadder.do?allData=' + allData;
			} 
		}
		
		
		// 시작
		function start(idx) {
			allData = [idx, searchSelect, searchInput, mode, currPage, size, lineCnt ];	
			if (confirm('시작하시겠습니까?')) {
				jQuery.ajaxSettings.traditional = true;
				$.ajax({
					type: "POST",
					url: "/ezLadder/setLadderStart.do",
					dataType: "json",
					data: {
						"allData": allData
					}
				});
			}
		} 
		

		/** 참여자 초기 셋팅 */
		function setAllUser() {
			attendants = { "id": [], "name": [], "name2": [], "pic": [], "order": [] };
			items = []; 
			var cnt =0;
			<c:forEach items="${list }" var="ladderLineList">	
				attendants["id"][cnt] =  "${ladderLineList.userId}";
				attendants["name"][cnt] = "${ladderLineList.userName}";
				attendants["name2"][cnt] = "${ladderLineList.userName2}";
				attendants["order"][cnt] = "${ladderLineList.ladderOrder}";
				items[cnt] = "${ladderLineList.item}";
				cnt = cnt +1;
				//pic 값 넣어줘야함
			</c:forEach>
		}
		
		
		// 참여자 그려주기
		function setAttendantsView() {
			
			var len = attendants["id"].length;
			var picsrc = "";
			var html = "";
		
			$("#attendantList").html("");
			$("#itemList").html("");
			
			if(attendants !== null) {
				
				for(var i = 0; i < len; i++) {
					html = "";
					picsrc = "/images/OrganTree/porson_noimg.gif";
					html += "<li class='attendant'>";
					if(attendants["id"][i].substring(0, 14) === "anonyAttendant") {
					} else {
						picsrc = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + attendants["pic"][i];
					}
					html += "<div class='ladderDrag' id='drag" + i + "' onclick='individualDirection(" + i + ");event.stopPropagation();'><img src='" 
								+ picsrc + "' width='90px' height='90px'/>";
					html += "<div>" + attendants["name"][i] + "</div>";
					
					$("#attendantList").append(html);
					$("#itemList").append("<li class='item'>" + items[i] + "</li>");
				}
			}
			add_user_change_ulsize(attendants["id"].length);
			
			if("${vo.status}" == 0) {
				drag();
			}
		} 
		
		/** 개별 경로 랜덤 색 지정 */
		function setPathColor() {
			for(var cnt=0; cnt<size; cnt++) {
				var color = '#'+(function lol(m,s,c){return s[m.floor(m.random() * s.length)] + (c && lol(m,s,c-1));})(Math,'0123456789ABCDEF',4);
				pathColor.push(color);
			}
		}
		/** 개별 경로 실행 */
		function individualDirection(nth) {
			if("${vo.status}" == 1) {
				var node = nth + "-0"; 
				startLineDrawing(node, pathColor[nth]);
			}
		}
		// 드래그 앤 드랍
		function drag() {
			$(".ladderDrag").draggable({ // 드래그 리스트
				revert: "invalid",
				revertDuration: 400,
				zIndex: 100,
				addClasses: false,
				start: function(event, ui) {
					var divEl = $(this);
					dragloc = {};
					droploc = {};
					dragloc = {"id": $(this).attr("id"), "left": divEl.offset().left}; 
				}
				
			});
			
			$(".ladderDrag").droppable({ // 드랍 리스트
				accept: ".ladderDrag",
				addClasses: false,
				hoverClass: "nowOver",
				drop: function(event, ui) {
					
					var divEl = $(this);
					droploc = {"id": $(this).attr("id"), "left": divEl.offset().left};
				
				 	$("#" + dragloc["id"]).css("z-index", "10").animate({"left": droploc["left"]}, 2000, function() {
						$("#" + dragloc["id"]).css("left",0);
						$("#" + dragloc["id"]).css("top", 0);
					});
					$("#" + droploc["id"]).css("z-index", "10").animate({"left": dragloc["left"]}, 2000, function() {
						$("#" + droploc["id"]).css("left",0);
						$("#" + dragloc["id"]).css("top", 0);
					});  
					changeListOrder();
				}
			});
		}
		
		function add_user_change_ulsize(usernum) {
			$("#ladderLineBox ul").css("width", (usernum * 150) + "px");
			$("#ladderCanvas").attr("width", (usernum * 150) + "px");
			$("#ladder_canvas").attr("width", (usernum * 150) + "px");
		}
	
		
	// =========================================
		var heightNode = 41;
		var widthNode =  "${ fn:length(list)}";
		var LADDER = {};
		var row =0;
		var ladder = $('#ladder');
		var ladder_canvas = $('#ladder_canvas');
		var GLOBAL_FOOT_PRINT= {};
		var GLOBAL_CHECK_FOOT_PRINT= {};
		var working = false;
		
		function draw() {
			
			if("${vo.status}" == 1) {
				$("#itemList").css("margin-top", -30 + "px");
			}
			
      		var canvas = document.getElementById("ladder_canvas");
      		
      		setDefaultFootPrint();
      		reSetCheckFootPrint();
      		setDefaultRowLine();
      		setRandomNodeData();
      		drawDefaultLine();
      		drawNodeLine();
    	}
		 
		function setDefaultFootPrint(){
		
			for(var r = 0; r < heightNode; r++){
				for(var column =0; column < widthNode; column++){
		            GLOBAL_FOOT_PRINT[column + "-" + r] = false;  // 0-0 부터 9-0 까지, 0-9부터 9-9까지
		        }
		    }
		}
		
		function reSetCheckFootPrint(){
			
	        for(var r = 0; r < heightNode; r++){
	            for(var column =0; column < widthNode; column++){
	                GLOBAL_CHECK_FOOT_PRINT[column + "-" + r] = false; // 0-0 부터 9-0 까지, 0-9부터 9-9까지
	            }
	        }
	    }
		
		function setDefaultRowLine(){
		
		    // row는 0부터 해서
			for(var y =0; y < heightNode; y++){     
				var rowArr = [];
		        for(var x =0; x <widthNode ; x++){  
					var node = x + "-"+ row;      // 0-0  부터 9-0까지
					rowArr .push(node);           // 0-9 부터  9-9 까지
		                
		            var left = x * 150;           // 노드위 위치
		            var top = row * 50;
		            var node = $('<div></div>')
		            .attr('class' ,'node')
		            .attr('id' , node)            // 아이디, 위치, css 정보를 넣어줌
		            .attr('data-left' , left)
		            .attr('data-top' , top)
		            .css({
						'position' : 'absolute',
		                'left' : left,
		                'top' : top
					});
					ladder.append(node);
				}
				LADDER[row] =  rowArr;
		        console.log(LADDER[row]);
		        row++;
		    }
		}
		
		/** 댓글 */
		var flagEvent = -1;
		function showEditPanel(obj) {					    	
	    	if (flagEvent != -1) {					
	    		document.getElementById("editComt" + flagEvent).style.display = "none";
	    	}	
	    	
	    	var id = obj.getAttribute("_comtIndex");
	    	
	    	if (flagEvent == id.slice(8)) {
	    		flagEvent = -1;
				return;
	    	}
	    	
	    	flagEvent = id.slice(8);	    	
	    	document.getElementById(id).style.display = "block";	
	    	
	    	document.addEventListener("click", function handleClick(e) {		    									
		    	if (document.getElementById(id) != null) {
		    		document.getElementById(id).style.display = "none"; 
		    	}		    			
		    	document.removeEventListener("click", handleClick);
		    	flagEvent = -1;
	    	});	   	
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
		function sendComment() {	    	
	        $("#sendBttn").css("background", "#d0d0d0");
	        $("#sendBttn").attr("disabled", true);
	        setComment("add");
	    }
		
		function setRandomNodeData(){
			var cnt=0
			for(var x =0; x <widthNode ; x++){
				var loopNode = x + "-0";       // loopNode는 0-0부터 ~ 9~0, 0-9부터 9-9 까지
               GLOBAL_FOOT_PRINT[loopNode] = {"change" : false , "draw" : false}
            }
	        for(var y =1; y < heightNode; y++){
				for(var x =0; x <widthNode ; x++){
					var loopNode = x + "-" + y;       // loopNode는 0-0부터 ~ 9~0, 0-9부터 9-9 까지
	                if(ladArr[cnt] == 0){                    // 0 직선 일시
	                    GLOBAL_FOOT_PRINT[loopNode] = {"change" : false , "draw" : false}
	                	cnt++;
	                } else {
						if(ladArr[cnt] == (widthNode - 1)){     // 맨 오른쪽일시 직선으로 처리
	                        GLOBAL_FOOT_PRINT[loopNode] = {"change" : false , "draw" : false} ;
	                    	cnt++;
	                    } else {
	                        GLOBAL_FOOT_PRINT[loopNode] =  {"change" : true , "draw" : true} ; // 좌회전
	                        x = x + 1;                // x값 증가 2-0 3-0
	                        loopNode = x + "-" + y;
	                        GLOBAL_FOOT_PRINT[loopNode] =  {"change" : true , "draw" : false} ; // 우회전
	                        cnt = cnt+2;
	                    } 
	                }
	            }
	        }
	    }
		
		function drawDefaultLine(){
	        var html = '';
	        html += '<table>'
	        for(var y =0; y < heightNode-1; y++){
	            html += '<tr>';
	            for(var x =0; x <widthNode-1 ; x++){
	                html += '<td style="width:148px; height:50px; border-left:2px solid #ddd; border-right:2px solid #ddd;"></td>';
	            }
	            html += '</tr>';
	        }
	        html += '</table>'
	        ladder.append(html);
	    }
		
	    function drawNodeLine(){
			for(var y =0; y < heightNode; y++){
	            for(var x =0; x <widthNode ; x++){
	                var node = x + '-' + y;       // 0-0부터 9-0 0-9부터 9-9까지
	                var nodeInfo  = GLOBAL_FOOT_PRINT[node];      //GLOBAL_FOOT_PRINT[loopNode] = {"change" : false , "draw" : false}
	                
	                stokeLine(x, y ,'h' , 'r' , '#ddd' , '5');
	                if(nodeInfo["change"] && nodeInfo["draw"] ){
	                     stokeLine(x, y ,'w' , 'r' , '#ddd' , '5');   
	                }
	            }
	        }
	    }
		
	    function stokeLine(x, y, flag , dir , color , width){
	        var canvas = document.getElementById('ladder_canvas');
	        var ctx = canvas.getContext('2d');
	        var moveToStart =0, moveToEnd =0, lineToStart =0 ,lineToEnd =0;
	        var eachWidth = 150;
	        var eachHeight = 15;
	        if(flag == "w"){ //가로줄
       			 if(dir == "r"){
	                ctx.beginPath();
	                moveToStart = x * eachWidth ;
	                moveToEnd = y * eachHeight ;
	                lineToStart = (x+ 1) * eachWidth;
	                lineToEnd = y * eachHeight;

	            }else{
	                // dir "l"
	                ctx.beginPath();
	                moveToStart = x * eachWidth;
	                moveToEnd = y * eachHeight;
	                lineToStart = (x- 1) * eachWidth;
	                lineToEnd = y * eachHeight;
	            }
	        } else{
	            ctx.beginPath();
				moveToStart = x * eachWidth ;
	            moveToEnd = y * eachHeight;
	            lineToStart = x * eachWidth ;
	            lineToEnd = (y+1) * eachHeight;
	        }
	        ctx.moveTo(moveToStart + 3 ,moveToEnd  + 2);
	        ctx.lineTo(lineToStart  + 3 ,lineToEnd  + 2 );
	        ctx.strokeStyle = color;
	        ctx.lineWidth = width;
	        ctx.stroke();
	        ctx.closePath();
	    }
	    
	    function startLineDrawing(nodLoc , nodColor){
			
	        var node = nodLoc;
	        var color = nodColor;
	        var x = node.split('-')[0]*1;
	        var y = node.split('-')[1]*1;
	        var nodeInfo = GLOBAL_FOOT_PRINT[node];

	        GLOBAL_CHECK_FOOT_PRINT[node] = true;
			
	        var dir = 'r'
	        if(y ==heightNode ){
	            reSetCheckFootPrint();
	            return false;
	        }
	        if(nodeInfo["change"] ){
	            var leftNode = (x-1) + "-" +y;
	            var rightNode = (x+1) + "-" +y;
	            var downNode = x +"-"+ (y + 1);
	            var leftNodeInfo = GLOBAL_FOOT_PRINT[leftNode];
	            var rightNodeInfo = GLOBAL_FOOT_PRINT[rightNode];
	                
	            if(GLOBAL_FOOT_PRINT.hasOwnProperty(leftNode) && GLOBAL_FOOT_PRINT.hasOwnProperty(rightNode)){      
	                var leftNodeInfo = GLOBAL_FOOT_PRINT[leftNode];
	                var rightNodeInfo = GLOBAL_FOOT_PRINT[rightNode];
	                if(  (leftNodeInfo["change"] &&  leftNodeInfo["draw"] && !!!GLOBAL_CHECK_FOOT_PRINT[leftNode] ) && (rightNodeInfo["change"])&&  leftNodeInfo["draw"]  && !!!GLOBAL_CHECK_FOOT_PRINT[rightNode] ){
	                    //Left우선 
	                    stokeLine(x, y, 'w' , 'l' , color ,3)
	                     setTimeout(function(){ 
	                         return startLineDrawing(leftNode, color)
	                     }, 5);
	                }
	                else if(  (leftNodeInfo["change"] &&  !!!leftNodeInfo["draw"] && !!!GLOBAL_CHECK_FOOT_PRINT[leftNode] ) && (rightNodeInfo["change"]) && !!!GLOBAL_CHECK_FOOT_PRINT[rightNode] ){
	                    stokeLine(x, y, 'w' , 'r' , color ,3)
	                    setTimeout(function(){ 
	                        return startLineDrawing(rightNode, color)
	                     }, 5);
	                }
	                else if(  (leftNodeInfo["change"] &&  leftNodeInfo["draw"] && !!!GLOBAL_CHECK_FOOT_PRINT[leftNode] ) && (!!!rightNodeInfo["change"]) ){
	                    //Left우선 
	                    stokeLine(x, y, 'w' , 'l' , color ,3)
	                     setTimeout(function(){ 
	                         return startLineDrawing(leftNode, color)
	                     }, 5);
	                }
	                 else if(  !!!leftNodeInfo["change"]  &&  (rightNodeInfo["change"]) && !!!GLOBAL_CHECK_FOOT_PRINT[rightNode] ){
	                    //Right우선 
	                    stokeLine(x, y, 'w' , 'r' , color ,3)
	                     setTimeout(function(){ 
	                         return startLineDrawing(rightNode, color)
	                     }, 5);
	                }
	                else{
	                    stokeLine(x, y, 'h' , 'd' , color ,3)
	                    setTimeout(function(){ 
	                       return startLineDrawing(downNode, color)
	                    }, 5);
	                }
	            }else{
	               if(!!!GLOBAL_FOOT_PRINT.hasOwnProperty(leftNode) && GLOBAL_FOOT_PRINT.hasOwnProperty(rightNode)){      
	                    /// 좌측라인
	                    if(  (rightNodeInfo["change"] && !!!rightNodeInfo["draw"] ) && !!!GLOBAL_CHECK_FOOT_PRINT[rightNode] ){
	                        //Right우선 
	                        stokeLine(x, y, 'w' , 'r' , color ,3)
	                        setTimeout(function(){ 
	                            return startLineDrawing(rightNode, color)
	                        }, 5);
	                    }else{
	                        stokeLine(x, y, 'h' , 'd' , color ,3)
	                        setTimeout(function(){ 
	                           return startLineDrawing(downNode, color)
	                        }, 5);
	                    }
	                    
	               }else if(GLOBAL_FOOT_PRINT.hasOwnProperty(leftNode) && !!!GLOBAL_FOOT_PRINT.hasOwnProperty(rightNode)){      
	                    /// 우측라인
	                    if(  (leftNodeInfo["change"] && leftNodeInfo["draw"] ) && !!!GLOBAL_CHECK_FOOT_PRINT[leftNode] ){
	                        //Right우선 
	                        stokeLine(x, y, 'w' , 'l' , color ,3)
	                        setTimeout(function(){ 
	                            return startLineDrawing(leftNode, color)
	                        }, 5);
	                    }else{
	                        stokeLine(x, y, 'h' , 'd' , color ,3)
	                        setTimeout(function(){ 
	                           return startLineDrawing(downNode, color)
	                        }, 5);
	                    }
	               }
	            }


	        }else{
	            var downNode = x +"-"+ (y + 1);
	            stokeLine(x, y, 'h' , 'd' , color ,3)
	            setTimeout(function(){ 
	                return startLineDrawing(downNode, color)
	             }, 5);
	        }
	    }
		// =========================================
	</script>
	<style type="text/css">
		
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
		
		#blackBox {
			height:650px;
			border:30px solid transparent; 
			margin-right:50px;
			background: #010;
			border-color:#010;
			position: relative; top: 100px; bottom:100px;
			float: left;
			
		}
		
		.cmtdelete, .cmtmodify {
			cursor: pointer;
		}
		.cmtdelete:HOVER, .cmtmodify:HOVER {
			background: beige;
		}
		
         #startButton {
         	width:50px;
          	position: relative; top: 220px;
         }
         
         #itemList {
			margin-top: 100px;
			margin-bottom: 20px;
		}
		
		.nowOver {
			background: beige;
		}
			
		.nowMove {
			background: beige;
			z-index: 100;
		}
		
		
		.directionBtn {
			position: relative; top:70px; right:10px;
			vertical-align: middle;
			
		}
		
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
		<c:if test="${vo.status eq 1 }">
			<div class="directionBtn">
				<div id="immediatelyDirection" align="center">바로 보기</div>
				<div id="autoDirection" align="center">자동 진행</div>
			</div>
		</c:if>
		
		<div class="fullwidth" style="margin-top: 100px;" >
			<table class="setTable" style="width: 98%;">
				<tr>
					<td colspan="4" style=" padding: 10px 0px;">
						<div class="wrap center" style="height: 100%; width: 100%;">
							<div id="ladderLineBox" style="height: 100%; width: 100%; border: 1px solid gray">
								<ul id="attendantList"></ul><br><br>
									<c:if test="${vo.status eq 0 }">
										<div id="blackBox" >
											<div id="startButton">
												<c:choose>
													<c:when test="${id eq vo.writerId }">
														<a href="#" onclick="start(${vo.ladderId})"><img src ='/images/ezLadder/start.png' width='50' height ='50'/></a><br>
													</c:when>
													<c:otherwise>
														<img src ='/images/ezLadder/start.png' width='50' height ='50'/><br>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
									</c:if>
									<c:if test="${vo.status eq 1}">
										<div id="ladder" class="ladder">
									         <canvas class="ladder_canvas" id="ladder_canvas" width="1550" height="650"></canvas>
									    </div>
									</c:if><br><br><br>						
								<ul id="itemList"></ul>
								<c:if test="${vo.status eq 1}"><br><ul id="seeAll"></ul></c:if>	
							</div>
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
							<button id="sendBttn" disabled="disabled" style="display:inline-block; width: 96px; cursor:pointer; height:45px; border:none; border-radius:5px; background:#d0d0d0; color:#FFF; margin:0px; padding:0px; text-align: center; vertical-align: middle;" onclick="sendComment(); return false;">등록</button>						
						</div>
	            	</div>
	            </div>
				<table style="width: 100%;" id="commentListView">
					<c:forEach var="_comt" items="${cmtlist}">
						<tr style="border-bottom: 1px dotted #ddd;">
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
									<img src="/images/option3.png" style="margin:30px 10px 0px 0px; position:absolute;top:0;right:0; padding:0px; cursor: pointer;" height=25 width=25 vertical-align="middle" id="editComtButton" _comtIndex="editComt<c:out value ="${_comt.id}"/>" onclick="(function(e){e.stopPropagation();})(event); showEditPanel(this);">
									<div id="editComt<c:out value ="${_comt.id}"/>" style="float:right; display: none; position: absolute; top:30px; right:28px; z-index: 10 ; border: 1px solid #ddd; background-color: #576652; color: white; width: 120px;" tabindex=0>							
										<div id="_eCmt<c:out value ="${_comt.id}" />" _comtIndex="editComt<c:out value ="${_comt.id}" />" style="border-bottom: 1px solid #ddd; text-align: center; padding:6px 0px; color:#333; background:#eaeaea; cursor: pointer;" onclick="editComment(this);">댓글 수정</div>
										<div id="_dCmt<c:out value ="${_comt.id}" />"_comtIndex="<c:out value ="${_comt.id}" />" style="text-align: center; padding:6px 0px; background:#eaeaea; color:#333; cursor: pointer;" onclick="deleteComment(this);">댓글 삭제</div>
									</div>
								</c:if>
							</td>
						</tr>
					</c:forEach>
				</table>
			</div>
			<!-- <div style="padding: 0px 50px;">
				<div class="cmtInput_wrap">
					<div class="cmtInputDiv"><input type="text" id="inputCmtBox" style="width: 100%; height: 100%; padding: 0px 30px;"></div>
					<div id="saveCmtBtn">댓글 등록</div>
				</div>
				<div id="commentDiv" style="width: 100%"></div>
			</div> -->
		</c:if>
<%-- 		
			<button onclick="sendTest()">socket test!!</button>
		
		<div id="chat" align="center">
			<%@ include file="include/ladderChat.jsp"%> 
		</div>
		<h3>
		* 프론트 꾸며야 됨 - 프로필 이미지 넣기.<br>
		* 사다리 연동
		</h3> --%>
	</body>
</html>