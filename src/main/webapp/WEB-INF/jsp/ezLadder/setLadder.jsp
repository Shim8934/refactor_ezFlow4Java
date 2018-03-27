<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezLadder.t009" /></title>
		<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css">
		<link rel="stylesheet" href="<spring:message code='ezLadder.e2' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
		<script type="text/javascript" src="/js/ezLadder/string_component.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladderSetting.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladder.js"></script>
		<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
		
		<script type="text/javascript">
			$(function() {
				$(window).resize(function() {
					ladder_window_resize();
				});
				
				$("#makeLad").on("click", function() {
					makeLadder();
				});
				$("#ladderPreList").on("click", function() {
					preLadderList();
				});
				$("#addAttendant").on("click", function() {
					_manage_attendant();
				});
				$("#inputAttendant").on("keyup", function(e) {
					var inputNames = $("#inputAttendant").val();
					if(e.keyCode == "13" && inputNames !== "") {
						checkAttendant(inputNames);
					}
				});
				$(".ladderType").on("click", function() {
					$(".ladderType").removeClass("active");
					$(this).addClass("active");
				});
				$("#ladderSecret").on("click", function() {
					$("#ladderSecret").toggleClass("active");
				});
				$(document).on("click", "span.remove", function() {
					attendant_remove($(this).closest("li").index());
				});
				$("#slider-range-min").slider({ 
					range: "min",
					value: 0,
					min: 0,
					max: 0,
					slide: function( event, ui ) {
						$("#amount").text(ui.value);
					}
				});
				$("#amount").val($("#slider-range-min").slider("value"));
				$("#bmtest").on("click", function() { /* 즐겨찾기 테스트 버튼 */
					
					var flag = "add";
					var ladderbmid = flag === "add" ? "0" : "106";
					var bmname = "이름이름";
					var bmuserid = ["dd","dd","dd"];
					var bmusername = ["nn","nn","nn"];
					var bmusername2 = ["nn","nn","nn"];
					
					/* 즐겨찾기 조회 */
					$.ajax({
						type: "GET",
						url: "/ezLadder/getLadderBM.do",
						traditional: true,
						dataType: "json",
						async : false,
						data: { 
							ladderBmId: ""
						},
						success: function(result) {
							console.log(result);
						}
					});
					/* 즐겨찾기 추가,수정,삭제 */
					$.ajax({
						type: "POST",
						url: "/ezLadder/setLadderBM.do",
						traditional: true,
						dataType: "json",
						data: { 
							flag: flag,
							ladderBmId: ladderbmid,
							bmName: bmname,
							userIds: bmuserid,
							userNames: bmusername,
							userName2s: bmusername2
						},
						success: function(result) {
							console.log(result);
						}
					}); 
				});
				
				ladder_set_init();
			});
			
			function ladder_set_init() {
				var retladinfo = [];
				
				ladder_window_resize();
				if("${ladderId}" !== "") {
					retladinfo = getPreLadder("${ladderId}");
					preLadderListComplete(retladinfo["lad"], retladinfo["ladline"]);
				} else {
					$(".ladderType:eq(<c:out value='${ladType}' />)").addClass("active");
				}
			}
			
			/** 이전사다리 가져오기 */
			var ladder_pre_set_dialogArguments = [];
			function preLadderList() {
				ladder_pre_set_dialogArguments[0] = "";
				ladder_pre_set_dialogArguments[1] = preLadderListComplete;
				
				GetOpenWindow("/ezLadder/ladderMain.do?mode=pre&currPage=1&searchSelect=&searchInput=", "ladder_pre_set", 970, 680);
			}			
			function preLadderListComplete(ladderInfo, lineInfo) {
				$("#title").val(ladderInfo["title"]);
				$(".icondiv").removeClass("active");
				$(".ladderType:eq(" + ladderInfo["type"] + ")").addClass("active");
				if(ladderInfo["secretFlag"] === 1) {
					$("#ladderSecret").addClass("active");
				} 
				
				checkAttendant(lineInfo);
			}
			
			/** 참여자, 아이템 배열을 현재 input box 정보로 셋팅 */
			function setInputValue() {
				var userlen = 0;
				var name = "";
				var i = 0;
				
				if(attendants !== null) {
					userlen = attendants["id"].length;
				}
				
				for(; i < userlen; i++) {
					if(attendants["id"][i].substring(0, 14) === "anonyAttendant") {
						name = $(".attendant:eq(" + i + ") input").val();
						attendants["name"][i] = name;
						attendants["name2"][i] = name;						
					}
					items[i] = $("#itemList li:eq(" + i + ") input").val();
				}
			}

			function _manage_attendant() {
				manage_attendant_after();
			}

			/** 조직도 호출 */
			var ladder_select_attendant_dialogArguments = [];
			function manage_attendant_after() {
				setInputValue();
				
				ladder_select_attendant_dialogArguments[0] = attendants;
			    ladder_select_attendant_dialogArguments[1] = checkAttendant;

			    GetOpenWindow("/ezLadder/setLadderAttendant.do", "ladder_select_attendant", 970, 680);
			}

			/** 참여자 변경될때 슬라이더 바 조절 */
			var maxLine = 5;
			function changeSliderValue() { 
				var len = attendants["id"].length;
				if(len >= 2) {
					$("#slider-range-min").slider("option", "min", len);
					$("#slider-range-min").slider("option", "max", len * maxLine);
					$("#slider-range-min").slider("option", "value", Math.round(len * maxLine / 2));
				} else {
					$("#slider-range-min").slider("option", "max", 0);
					$("#slider-range-min").slider("option", "value", 0);
				}
				$("#amount").text($("#slider-range-min").slider("value"));
			}

			/** 참여자 삭제 */
			function attendant_remove(index) {
				attendants["id"].splice(index, 1);
				attendants["name"].splice(index, 1);
				attendants["name2"].splice(index, 1);
				attendants["pic"].splice(index, 1);
				items.splice(index, 1);
				
				$(".attendant:eq(" + index + ")").remove();
				$(".item:eq(" + index + ")").remove();
				add_user_change_ulsize(attendants["id"].length);
				
				changeSliderValue()
				changeUser(attendants["id"].length);
			}

			/** 아이디+이름 검사 (익명인지 아닌지) */
			var attendants = null;
			var items = null;
			function checkAttendant(data) {
				var overlapXML = [];
				var noOverlapXML = [];
				var anonyJson = {};
				var len = 0;
				var i = 0;
				var returnXML;
				
				if(attendants === null) {
					attendants = { "id": [], "name": [], "name2": [], "pic": [], "order": [] };
					items = [];
				}
				
				var addIndex = 0;
				if(typeof data === "string") {
					console.log("string 이름으로검색시");
					
					data = ReplaceText(data, ",", ";");
					
					var names = data.split(";");
					len = names.length;
					
					addIndex = attendants["id"].length;
					for (; i < len; i++) {
						names[i] = TrimText(names[i]);
						
						if(names[i] == "") {
							continue;
						}
						
						getAttendantAJAX(names[i]);
						
						if(adCount === 0) { // 검색결과 없음 (완전 익명)
							anonyJson = { "name": names[i], "name2": names[i] };
							setAllUser(anonyJson, "anony-json");
						
						} else if(adCount === 1) { // 검색결과 하나
							var checkOverlap1 = attendants["id"].findIndex(function(id) {
								return id == getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]);
							});
							
							if(checkOverlap1 !== -1) { // 중복 유저
								overlapXML.push(xmlDOM);
							
							} else { // 중복 아닌 유저
								setAllUser(xmlDOM, "real-xml");
							}
						} else { // 검색결과 여럿
							console.log("-----**");
						}
						
					}
					
					$("#inputAttendant").val("");
					
					if(overlapXML.length !== 0) {
						popSelectUsertype(overlapXML, function(overlapXML, attendantType) {
							for(i = 0; i < overlapXML.length; i++) {
								setAllUser(overlapXML[i], attendantType);
							}
						});
					}
					
				} else {
					console.log("arr 이전 사다리 불러올시 + 조직도에서 불러올시");
					
					attendants = { "id": [], "name": [], "name2": [], "pic": [], "order": [] };
					
					len = data.length;
					
					for(; i < len; i++) {
						if(data[i]["id"].substring(0, 14) !== "anonyAttendant") {
							getAttendantAJAX(data[i]["name"]);
							setAllUser(xmlDOM, "real-xml", data[i]["item"]);
						} else {
							setAllUser(data[i], "anony-json", data[i]["item"]);
						}
					}
				}
			}
			
			/** 참여자 셋팅 */
			function setAllUser(userdata, flag, item) {
				var totallen = attendants["id"].length;
				var flagarr = flag.split("-");
				
				if(flagarr[0] === "real") { // 일반 유저
					if(flagarr[1] === "xml") { // xml
						attendants["id"][totallen] = getNodeText(userdata.getElementsByTagName("DATA2")[0]);
						attendants["name"][totallen] = getNodeText(userdata.getElementsByTagName("DATA6")[0]);
						attendants["name2"][totallen] = getNodeText(userdata.getElementsByTagName("DATA7")[0]);
						attendants["pic"][totallen] = getNodeText(userdata.getElementsByTagName("DATA5")[0]);
					} else { // json
						attendants["id"][totallen] = userdata["id"];
						attendants["name"][totallen] = userdata["name"];
						attendants["name2"][totallen] = userdata["name2"];
						attendants["pic"][totallen] = userdata["pic"];
					}
				} else { // 익명 유저
					attendants["id"][totallen] = "anonyAttendant_" + totallen;
					attendants["pic"][totallen] = "";
					if(flagarr[1] === "xml") { // xml
						attendants["name"][totallen] = getNodeText(userdata.getElementsByTagName("DATA3")[0]);
						attendants["name2"][totallen] = getNodeText(userdata.getElementsByTagName("DATA3")[0]);
					} else { // json
						attendants["name"][totallen] = userdata["name"];
						attendants["name2"][totallen] = userdata["name2"];
					}
				}
				
				if(typeof item !== "undefined") {
					items[totallen] = item;
				} else {
					if(items.length < attendants["id"].length) {
						items[totallen] = "";
					}
				} 
				attendants["order"][totallen] = totallen;
				
				setAttendantsView();
			}
			
			/** 화면에 참여자 나타내기 */
			function setAttendantsView() {
				var len = attendants["id"].length;
				var picsrc = "";
				var html = "";
				
				if(attendants !== null) {
					$("#attendantList").html("");
					$("#itemList").html("");
					
					for(var i = 0; i < len; i++) {
						html = "";
						picsrc = "/images/OrganTree/porson_noimg.gif";
						
						if(attendants["id"][i].substring(0, 14) === "anonyAttendant") {
							html += "<li class='attendant'>";
							html += "<div><img src='" + picsrc + "' width='90px' height='90px' />";
							html += "<input type='text' class='input' value='" + attendants["name"][i] + "' />";
							html += "<span class='remove'>X</span></div></li>";							
						} else {
							if(attendants["pic"][i] !== "") {
								picsrc = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + attendants["pic"][i];
							}
							html += "<li class='attendant'>";
							html += "<div><img src='" + picsrc + "' width='90px' height='90px' />";
							html += "<input type='text' class='input' disabled='disabled' value='" + attendants["name"][i] + "' />";
							html += "<span class='remove'>X</span></div></li>";	
						}
						
						$("#attendantList").append(html);
						$("#itemList").append("<li class='item'><input type='text' class='input' value='" + items[i] + "' /></li>");
						
					}
					changeSliderValue();
					add_user_change_ulsize(attendants["id"].length);
					changeUser(len);
				}
				
				console.log(attendants);
			}
			
			/** 유저 정보 xml로 가져오기 */
			var adCount;        
	        var xmlDOM;
			function getAttendantAJAX(attendantName) {
				adCount = 0;
				xmlDOM = createXmlDom();
		        
		        $.ajax({
		    		url : "/ezOrgan/getSearchList.do",
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		data : {
		    			search : "displayName::" + attendantName,
		    			cell   : "company;description;title;displayName;mail",
		    			prop   : "displayName;description;extensionAttribute2",
		    			type   : "user"
		    		},
		    		success: function(xml){
		    			xmlDOM = loadXMLString(xml);
		                adCount = xmlDOM.getElementsByTagName("ROW").length;
		    		}    		
		    	});
			}
			
			/** 사다리 만들기 */
			function makeLadder() {
				var title = $("#title").val();
				var type = $(".ladderType.active").attr("num");
				var secretFlag = $("#ladderSecret.active").length;
				var lineCnt = $("#slider-range-min").slider("option", "value");
				
				setInputValue()
				
				var userId = attendants["id"];
				var userName = attendants["name"];
				var userName2 = attendants["name2"];
				var item = items;
				var ladderOrder = attendants["order"];
				
				console.log(userId);
				console.log(userName);
				console.log(userName2);
				console.log(item);
				console.log(ladderOrder);
				
				$.ajax({ 
					type: "POST",
					url: "/ezLadder/setLadder.do",
					traditional: true,
					dataType: "json",
					async : false,
					data: { 
						'title': title,
						'type': type,
						'secretFlag': secretFlag,
						'lineCnt': lineCnt,
						'userId': userId,
						'userName': userName,
						'userName2': userName2,
						'item': item,
						'ladderOrder': ladderOrder
					},
					success: function(result) {
						console.log('make ladder success');
					}
				});
			} 
			
			

		</script>
	</head>
	<body class="mainbody">
		<h1>사다리 게임</h1>
		<div class="fullwidth">
			<table class="setTable">
				<tr>
					<td></td><td style="width: 5000px;"></td><td></td>
				</tr>
				<tr>
					<td colspan="2" style="width: 98%;">
						<div class="wrap left">
							<div class="title floatL">
								<div class="icondiv" id="ladderPreList">이전사다리</div>
								<input type="text" class="input" id="title" style="height: 100%; width: 100%;" placeholder="제목" />
							</div>
						</div>
					</td>
					<td>
						<div class="wrap right">
							<div class="icondiv floatR fullwidth" id="ladderSecret">비밀글</div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="wrap left">
							<input type="text" class="input" id="inputAttendant" style="height: 100%; width: 200px;" placeholder="참여자추가" />
						</div>
					</td>
					<td colspan="2">
						<div class="wrap right">
							<div class="floatR" style="width: 212px;">
								<div class="icondiv ladderType" num="0">꽝</div>
								<div class="icondiv ladderType" num="1">돈</div>
								<div class="icondiv ladderType" num="2">순서</div>
								<div class="icondiv ladderType" num="3">직접</div>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<div class="wrap left">
							<div class="floatL icondiv" id="amount">0</div>
							<div id="slider-range-min" style="width: 300px;"></div>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4" style="height: 700px; padding: 10px 0px;">
						<div class="wrap center" style="height: 100%; width: 100%;">
							<div id="addAttendant" class="icondiv">add</div>
							<div id="ladderLineBox" style="height: 100%; width: 100%; border: 1px solid gray">
								<canvas id='ladderCanvas' width="0" height="650"></canvas>
								<ul id="attendantList"></ul>
								<ul id="itemList"></ul>
							</div>
						</div>
					</td>
				</tr>
			</table>
			<div class="wrap center">
				<div class="ladderBtn" id="makeLad" style="float: right;">사다리 게임 만들기</div>
			</div>
			<table>
				
				<tr>
					<td>
						<button id="bmtest">bmtest</button>
					</td>
				</tr>
			</table>
		</div>
		<%-- <canvas id='ladderCanvas' width="500px" height="500px" style="border: 1px solid black"></canvas> --%>
		
		<span id="tetetest"><h3>만들기</h3></span>
		
		<!-- popup start -->
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	    <div id="dialog" title="Dialog Title">I'm a dialog</div>
	    <!-- end -->
	</body>
</html>