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
			function ladder_window_resize() {
				var win_width = $(window).width() - 70;
				
				$(".setTable").css("width", win_width + "px");
				$("#ladderLineBox").css("width", win_width + "px");
			}
			$(function() {
				ladder_set_init();
				
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
					setInputValue(false);
					setLadderTypeDiv($(this).attr("num"));
				});
				$("#ladderSecret").on("click", function() {
					$("#ladderSecret").toggleClass("active");
				});
				$(document)
					.on("click", "span.remove", function() {
						attendant_remove($(this).closest("li").index());
					})
					.on("click", "#addBomb", function() {
						setBomb(true);
					})
					.on("click", "#cutBomb", function() {
						setBomb(false);
					})
					.on("blur", ".item input", function() {
						if($(".ladderType.active").attr("num") == "1") {
							setInputValue(false);
							setLadderTypeDiv("1");
						}
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
					var arr1 = ["0", "1", "2", "3", "4", "5"];
					var arr2 = [];
					
					arr2[2] = "re2";
					arr2[5] = "re5";
					
					arr2.forEach(function(val, idx) {
						if(!!val) {
							console.log("enter");
							console.log(val);
							arr1[idx] = val;
						}
					});
					
					console.log(arr1);
					
				});
				
				
			});
			
			function setLadderTypeDiv(ladderType) {
				var html = "";
				var len = $("#itemList li").length;
				if(ladderType == "0") {
					html += "<div id='addBomb' class='floatL'>꽝 더하기</div>";	
					html += "<div id='cutBomb' class='floatL'>꽝 빼기</div>";
					html += "<div id='bombnum' class='floatL'>꽝 X <span>" + bombnum + "</span></div>";
					$("#itemList").empty();
					for(var i = 0; i < len; i++) {
						$("#itemList").append("<li class='item'><input type='text' class='input' name='items' readonly='readonly' style='background: rgb(244, 245, 245)' /></li>");
						$("input[name='items']:eq(" + i + ")").val("?");
					}
				} else if(ladderType == "2") {
					$("#itemList").empty();
					for(var i = 0; i < len; i++) {
						$("#itemList").append("<li class='item'><input type='text' class='input' name='items' readonly='readonly' style='background: rgb(244, 245, 245)' /></li>");
						$("input[name='items']:eq(" + i + ")").val("?");
					}
				} else {
					if(ladderType == "1") {
						getMoney();
						html += "<div id='bombnum' class='floatL'>$ <span>" + totalmoney + "</span> 원</div>";
					}
					$("#itemList").empty();
					for(var i = 0; i < len; i++) {
						$("#itemList").append("<li class='item'><input type='text' class='input' name='items' /></li>");
						$("input[name='items']:eq(" + i + ")").val(items[i]);
					}
				}
				$("#ladderTypeOption").html(html);
			}
			
			var bombnum = 1;
			function setBomb(bombadd) {
				bombnum = $("#bombnum span").text() * 1;
				if(bombadd && bombnum < $("#attendantList li").length) {
					$("#bombnum span").html(++bombnum);
				} else if(!bombadd && bombnum > 1) {
					$("#bombnum span").html(--bombnum);
				}
			}
			
			var totalmoney = 0;
			var regNumber = /^[0-9]*$/;
			var regexp = /\B(?=(\d{3})+(?!\d))/g;
			function getMoney() {
				var len = $("#attendantList li").length;
				var inputval = "";
				totalmoney = 0;
				for(var i = 0; i < len; i++) {
					inputval = $(".item:eq(" + i + ") input").val().replace(",", "");
					if(regNumber.test(inputval)) {
						totalmoney += inputval * 1;
					}
				}
				totalmoney = totalmoney.toString().replace(regexp, ',');
			}
			
			function ladder_set_init() {
				var retladinfo = [];
				
				ladder_window_resize();
				if("${ladderId}" !== "") {
					retladinfo = getPreLadder("${ladderId}");
					preLadderListComplete(retladinfo["lad"], retladinfo["ladline"]);
				} else {
					$(".ladderType:eq(<c:out value='${ladType}' />)").addClass("active");
					setLadderTypeDiv("${ladType}");
				}
			}
			
			/** 이전사다리 가져오기 */
			var ladder_pre_set_dialogArguments = [];
			function preLadderList() {
				ladder_pre_set_dialogArguments[0] = "";
				ladder_pre_set_dialogArguments[1] = preLadderListComplete;
				
				GetOpenWindow("/ezLadder/ladderMain.do?mode=pre&currPage=1&searchSelect=&searchInput=", "ladder_pre_set", 1342, 822);
			}			
			function preLadderListComplete(ladderInfo, lineInfo) {
				$("#title").val(ladderInfo["title"]);
				$(".icondiv").removeClass("active");
				$(".ladderType:eq(" + ladderInfo["type"] + ")").addClass("active");
				setLadderTypeDiv(ladderInfo["type"]);
				if(ladderInfo["secretFlag"] === 1) {
					$("#ladderSecret").addClass("active");
				} 
				checkAttendant(lineInfo);
				changeSliderValue(ladderInfo["lineCnt"]);
			}
			
			/** 참여자, 아이템 배열을 현재 input box 정보로 셋팅 */
			function setInputValue(allsetting) {
				var userlen = 0;
				var name = "";
				var i = 0;
				
				if(attendants !== null) {
					userlen = attendants["id"].length;
				}
				
				for(; i < userlen; i++) {
					if(allsetting) {
						if(attendants["id"][i].substring(0, 14) === "anonyAttendant") {
							name = $(".attendant:eq(" + i + ") input").val();
							attendants["name"][i] = name;
							attendants["name2"][i] = name;						
						}
					}
					if($("#itemList li").length != 0 && $("#itemList li input").attr("readonly") != "readonly") {
						items[i] = $("#itemList li:eq(" + i + ") input").val();
					}
					/* if($(".ladderType.active").attr("num") == "0") {
						var bomb = $("#bombnum span").text(); //임시
						items.forEach(function(item, index) {
							if(index < bomb) { //임시
								items[index] = "꽝";
							} else {
								items[index] = "통과"
							}
						});
					} else {
						if($("#itemList li").length != 0 && $("#itemList li:eq(0)").attr("disabled") != "disabled") {
							items[i] = $("#itemList li:eq(" + i + ") input").val();
						}
					} */
				}
			}

			function _manage_attendant() {
				manage_attendant_after();
			}

			/** 조직도 호출 */
			var ladder_select_attendant_dialogArguments = [];
			function manage_attendant_after() {
				setInputValue(true);
				
				ladder_select_attendant_dialogArguments[0] = attendants;
			    ladder_select_attendant_dialogArguments[1] = checkAttendant;

			    GetOpenWindow("/ezLadder/setLadderAttendant.do", "ladder_select_attendant", 970, 680);
			}

			/** 참여자 변경될때 슬라이더 바 조절 */
			var maxLine = 10;
			function changeSliderValue(value) { 
				var len = attendants["id"].length;
				if(len >= 2) {
					$("#slider-range-min").slider("option", "min", len);
					$("#slider-range-min").slider("option", "max", len * maxLine);
					if(!value) {
						$("#slider-range-min").slider("option", "value", Math.round(len * maxLine / 2));
					} else {
						$("#slider-range-min").slider("option", "value", value);
					}
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
				
				changeSliderValue();
				changeUser(attendants["id"].length);
				setLadderTypeDiv($(".ladderType.active").attr("num"));
			}

			/** 아이디+이름 검사 (익명인지 아닌지) */
			var attendants = null;
			var items = null;
			var retAttendantPopInfo = [];
			function checkAttendant(data) {
				var alluser = [];
				var overlapuser = [];
				var len = 0;
				var i = 0;
				
				if(attendants === null) {
					attendants = { "id": [], "name": [], "name2": [], "pic": [], "order": [] };
					items = [];
				}
				
				var addIndex = 0;
				if(typeof data === "string") {
					console.log("string 이름으로검색시");
					setInputValue(true);
					
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
							alluser[i] = { "data": { "name": names[i], "name2": names[i] }, "datatype": "anony-json" };
						
						} else if(adCount === 1) { // 검색결과 하나
							var checkOverlap1 = attendants["id"].findIndex(function(id) {
								return id == getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]);
							});
							var checkOverlap2 = function() {
								var overlapretvalue = -1;
								alluser.forEach(function(user, index) {
									if(user["datatype"].substring(0, 5) !== "anony" && user["data"].getElementsByTagName("DATA6")[0].innerHTML === names[i]) {
										overlapretvalue = 1;
									}
								});
								return overlapretvalue;
							}; 
							
							if(checkOverlap1 !== -1 || checkOverlap2() !== -1) { // 중복 유저
								overlapuser[i] = xmlDOM;
							
							} else { // 중복 아닌 유저
								alluser[i] = { "data": xmlDOM, "datatype": "real-xml" };
							}
							
						} else { // 검색결과 여럿
							alluser[i] = { "data": { "name": names[i], "name2": names[i] }, "datatype": "anony-json" };
						}
					}
					
					$("#inputAttendant").val("");
					
					if(!!overlapuser.length) { // 중복유저 팝업
						retAttendantPopInfo[0] = true;
						retAttendantPopInfo[1] = bindAllUser;
						
						DivPopUpShow(360, 185, "/ezLadder/ladderPopup.do?popupType=overlap");
					} else {
						bindAllUser(false);
					}
					
				} else {
					console.log("arr 이전 사다리 불러올시 + 조직도에서 불러올시");
					
					attendants = { "id": [], "name": [], "name2": [], "pic": [], "order": [] };
					
					len = data.length;
					
					for(; i < len; i++) {
						if(data[i]["id"].substring(0, 14) !== "anonyAttendant") {
							getAttendantAJAX(data[i]["name"]);
							alluser[i] = { "data": xmlDOM, "datatype": "real-xml" };
						} else {
							overlapuser[i] = data[i];
						}
						if(!!data[i]["item"]) {
							items[i] = data[i]["item"];
						}
					}
					
					if(!!overlapuser.length) {
						bindAllUser(true, "anony-json");
					} else {
						bindAllUser(false);
					}
				}
				
				function bindAllUser(value, type) {
					if(value) {
						overlapuser.forEach(function(user, index) {
							alluser[index] = { "data": user, "datatype": type };
						});
					}
					setAllUser_(alluser);
				}
			}
			
			function setAllUser_(userdata) {
				DivPopUpHidden();
				
				var flag = [];
				var attendantlen = attendants["id"].length;
				var totallen = 0;
				var user = {};
				
				userdata.forEach(function(_user, index) {
					totallen = attendantlen + index;
					flag = _user["datatype"].split("-");
					
					user = _user["data"];
					if(flag[0] === "real") {
						if(flag[1] === "xml"){
							attendants["id"][totallen] = getNodeText(user.getElementsByTagName("DATA2")[0]);
							attendants["name"][totallen] = getNodeText(user.getElementsByTagName("DATA6")[0]);
							attendants["name2"][totallen] = getNodeText(user.getElementsByTagName("DATA7")[0]);
							attendants["pic"][totallen] = getNodeText(user.getElementsByTagName("DATA5")[0]);	
							attendants["order"][totallen] = totallen;
						} else {
							attendants["id"][totallen] = user["id"];
							attendants["name"][totallen] = user["name"];
							attendants["name2"][totallen] = user["name2"];
							attendants["pic"][totallen] = user["pic"];
							attendants["order"][totallen] = totallen;
						}
					} else {
						attendants["id"][totallen] = "anonyAttendant_" + totallen;
						attendants["pic"][totallen] = "";
						attendants["order"][totallen] = totallen;
						if(flag[1] === "xml") { // xml
							attendants["name"][totallen] = getNodeText(user.getElementsByTagName("DATA3")[0]);
							attendants["name2"][totallen] = getNodeText(user.getElementsByTagName("DATA3")[0]);
						} else { // json
							attendants["name"][totallen] = user["name"];
							attendants["name2"][totallen] = user["name2"];
						}
					}
					console.log(!items[totallen]);
					if(items[totallen] == null) {
						items[totallen] = "";
					}
				});
				
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
							html += '<li class="attendant"><div>';
							html += '<img src="' + picsrc + '" width="90px" height="90px" />';
							html += '<div style="line-height: 30px; outline: 1px solid #ddd; margin-top: 10px;"><span>';
							html += '<input type="text" class="input" name="userNames" /></span></div>';
							html += '<input type="text" name="userName2s" style="display: none;" />';
							html += '<input type="text" name="userIds" style="display: none;" />';
							html += '<span class="remove">X</span></div></li>';
							
							
							/* html += "<div><img src='" + picsrc + "' width='90px' height='90px' />";
							html += "<input type='text' class='input' name='userNames' />";
							html += "<input type='text' name='userName2s' style='display: none;' />";
							html += "<input type='text' name='userIds' style='display: none;' />";
							html += "<span class='remove'>X</span></div></li>";	 */						
						} else {
							if(attendants["pic"][i] !== "") {
								picsrc = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + attendants["pic"][i];
							}
							
							html += '<li class="attendant"><div>';
							html += '<img src="' + picsrc + '" width="90px" height="90px" />';
							html += '<div style="line-height: 30px; outline: 1px solid #ddd; margin-top: 10px;"><span>';
							html += '<input type="text" class="input" readonly="readonly" style="background: rgb(244, 245, 245)" name="userNames" /></span></div>';
							html += '<input type="text" name="userName2s" style="display: none;" />';
							html += '<input type="text" name="userIds" style="display: none;" />';
							html += '<span class="remove">X</span></div></li>';
							
							
							/* html += "<li class='attendant'><div>";
							html += "<div><img src='" + picsrc + "' width='90px' height='90px' />";
							html += "<input type='text' class='input' readonly='readonly' style='background: rgb(244, 245, 245)' name='userNames' />";
							html += "<input type='text' name='userName2s' style='display: none;' />";
							html += "<input type='text' name='userIds' style='display: none;' />";
							html += "<span class='remove'>X</span></div></li>"; */
						}
						
						$("#attendantList").append(html);
						
						var thisLi = "#attendantList li:eq(" + i + ")";
						$(thisLi + " input[name='userNames']").val(attendants["name"][i]);
						$(thisLi + " input[name='userName2s']").val(attendants["name2"][i]);
						$(thisLi + " input[name='userIds']").val(attendants["id"][i]);
						
						if($(".ladderType.active").attr("num") == "0" || $(".ladderType.active").attr("num") == "2") {
							$("#itemList").append("<li class='item'><input type='text' class='input' name='items' readonly='readonly' style='background: rgb(244, 245, 245)' /></li>");
							$("#itemList li:eq(" + i + ") input").val("?");
						} else {
							$("#itemList").append("<li class='item'><input type='text' class='input' name='items' /></li>");
							$("#itemList li:eq(" + i + ") input").val(items[i]);
						}
						
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
				if ($("#title").val().trim() === "") {
					alert("제목을 입력하세요.");
					return;
				}
				var title = $("#title").val();
				var type = $(".ladderType.active").attr("num");
				var secretFlag = $("#ladderSecret.active").length;
				var lineCnt = $("#slider-range-min").slider("option", "value");
				
				$("input[name='type']").val(type);
				$("input[name='secretFlag']").val(secretFlag);
				$("input[name='lineCnt']").val(lineCnt);
				$("form").append("<input name='bombnum' />");
				
				if(type == "0") {
					$("input[name='bombnum']").val(bombnum);
				} else {
					$("input[name='bombnum']").val(0);
				}
				
				/* if(type == "0") {
					var bombItem = 0;
					var temp;
					items.fill("꽝", 0, bombnum);
					items.fill("통과", bombnum);
					items.forEach(function(item_, index) {
						bombItem = Math.floor(Math.random() * items.length);
						temp = item_;
						items[index] = items[bombItem];
						items[bombItem] = temp;
						$("input[name='items']:eq(" + index + ")").val(items[bombItem]);
						$("input[name='items']:eq(" + bombItem + ")").val(items[bombItem]);
					});
				} */
				
				setInputValue(true);
				
				$("#ladMakeForm").submit();
				
				
				
				/* $.ajax({ 
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
						window.location.href = "/ezLadder/ladderMain.do?mode=all&currPage=1&searchSelect=&searchInput=";
					}
				}); */
			} 
			
			

		</script>
	</head>
	<body class="mainbody">
		<h1>사다리 게임</h1>
		<form id="ladMakeForm" method="post" action="/ezLadder/setLadder.do" name="ladMakeForm">
			<div class="fullwidth">
				<table class="setTable">
					<tr>
						<td></td><td style="width: 5000px;"></td><td></td>
					</tr>
					<tr>
						<td colspan="2" style="width: 98%;">
							<div class="wrap left">
								<div class="title floatL">
									<div class="icondiv" id="ladderPreList"><img src ='/images/ezLadder/icon_preLadder.png' /></div>
									<input type="text" class="input" name="title" id="title" style="height: 100%; width: 100%;" placeholder="제목" />
								</div>
							</div>
						</td>
						<td>
							<div class="wrap right">
								<div class="icondiv floatR fullwidth" id="ladderSecret">비밀글</div>
								<input name="secretFlag" style="display: none;" />
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
								<div id="ladderTypeOption" style='display:  inline-block; right: 230px; position:  absolute;'>
								</div>
								<div class="floatR" style="width: 212px;">
									<div class="icondiv ladderType" num="0">꽝</div>
									<div class="icondiv ladderType" num="1">돈</div>
									<div class="icondiv ladderType" num="2">순서</div>
									<div class="icondiv ladderType" num="3">직접</div>
									<input name="type" style="display: none;" />
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="3">
							<div class="wrap left">
								<div class="floatL icondiv" id="amount">0</div>
								<div id="slider-range-min" style="width: 300px;"></div>
								<input name="lineCnt" style="display: none;" />
							</div>
						</td>
					</tr>
					<%-- <tr>
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
					</tr> --%>
				</table>
				<table class="setTable" style="position: relative;">
					<tr>
						<td>
							<div id="ladderLineBox" style="border: 1px solid #ddd;">
								<div id="addAttendant" class="icondiv">add</div>
								<div style="height: 140px;">
									<ul id="attendantList"></ul>
								</div>
								<div id="lineDiv" style="position: relative; z-index: -1;">
									<canvas id='ladderCanvasLine' width='0' height='800'></canvas>
									<canvas id='ladderCanvas' width='0' height='800'></canvas>
								</div>
								<ul id="itemList" style="margin-top: 10px;"></ul>
							</div>
						</td>
					</tr>
				</table>
				<div class="wrap center">
					<div class="ladderBtn" id="makeLad" style="float: right;">사다리 게임 만들기</div>
				</div>
				<!-- <table>
					
					<tr>
						<td>
							<button id="bmtest">bmtest</button>
						</td>
					</tr>
				</table> -->
			</div>
		</form>
		<%-- <canvas id='ladderCanvas' width="500px" height="500px" style="border: 1px solid black"></canvas> --%>
		
		<span id="tetetest"><h3>만들기</h3></span>
		
		<!-- popup start -->
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	    <!-- end -->
	</body>
</html>