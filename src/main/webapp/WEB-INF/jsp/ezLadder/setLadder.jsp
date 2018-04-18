<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezLadder.t060" /></title>
		<link rel="stylesheet" href="<spring:message code='ezLadder.e2' />" type="text/css">
		<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css">
		<link rel="stylesheet" href="/js/jquery/jquery-ui.css">
		<script type="text/javascript" src="<spring:message code='ezLadder.e1'/>"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-ui.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladderSetting.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladder.js"></script>
		
		<script type="text/javascript">
			var ladderId;
			var title;
			var secretFlag;
			var ladderType;
			var lineCnt;
			var maxAttendant = 50;
			var maxname = 30;
			var maxitem = 50;
		
			function ladder_window_resize() {
				var win_width = $(window).width();
				
				$(".setTable").css("width", win_width - 20 + "px");
				$("#ladderLineBox").css("width", win_width - 70 + "px");
			}
			$(function() {
				$(window).resize(function (){
					ladder_window_resize();
				});
				
				$("#slider-range-min").slider({ 
					range: "min",
					value: 0,
					min: 0,
					max: 0,
					slide: function( event, ui ) {
						$("#amount").text(ui.value);
					},
					stop: function(event, ui) {
						console.log(ui.value);
						lineCnt = ui.value;
					}
				});
				
				ladderSetInitVar();
				ladderSetInitView();
				
				
				$("#makeLad").on("click", function(e) {
					makeLadder();
					return false;
				});
				$("#title").on("input", function() {
					if($("#title").val() == "") {
						$("#makeLad").attr("disabled", "disabled").css({"background": "#dddddd", "cursor": "default"});
					} else {
						$("#makeLad").removeAttr("disabled").css({"background": "#0470e4", "cursor": "pointer"});
					}
				});
				$("#ladderPreList")
					.on("click", function() {
						preLadderList();
					})
					.on("mouseenter", function() {
						$(this).children("img").attr("src", "/images/ezLadder/icon_preLadder_hover.png");
					})
					.on("mouseleave", function() {
						$(this).children("img").attr("src", "/images/ezLadder/icon_preLadder.png");
					});
				$("#addAttendant")
					.on("click", function() {
						_manage_attendant();
					})
					.on("mouseenter", function() {
						$("#addAttendant").css("background", "#ddeeff");
						$("#addAttendant img").toggle();
					})
					.on("mouseleave", function() {
						$("#addAttendant").css("background", "white");
						$("#addAttendant img").toggle();
					});
				$("#inputAttendant").on("keyup", function(e) {
					var inputNames = $("#inputAttendant").val();
					if(e.keyCode == "13" && inputNames !== "") {
						checkAttendant(inputNames);
					}
				});
				$(".ladderType").on("click", function() {
					$(".ladderType[_num='" + ladderType + "'] img").toggleClass("active");
					
					ladderType = $(this).attr("_num");
					$(".ladderType[_num='" + ladderType + "'] img").toggleClass("active");
					
					setInputValue(false);
					setLadderTypeDiv();
				});
				$("#ladderSecret").on("click", function() {
					$("#ladderSecret img").toggleClass("active");
				});
				
				var timer;
				var scrollCnt = 0;
				$(document)
					.on("click", function() {
						
					})
					/* .on("scroll", function() {
						scrollCnt++;
						if(scrollCnt == 1) {
							console.log("시작해따");
						}
						timer = setTimeout(function() {
							
						}, 150);
						clearTimeout(timer);
						timer = setTimeout(function() {
							var focusClass = document.activeElement.getAttribute("class");
							var focusId = document.activeElement.getAttribute("id");
							if(focusClass == "input") {
								$("#" + focusId).blur();
							}
						}, 150);
					}) */
					.on("click", "#removeIcon", function() {
						attendant_remove($(this).closest("li").index());
					})
					.on("click", "#addBomb", function() {
						setBomb(true);
					})
					.on("click", "#cutBomb", function() {
						setBomb(false);
					})
					.on("blur", ".item input", function() {
						if(ladderType == "1") {
							getMoney();
							$("#totalmoney span").text(totalmoney);
						}
					});
				
			});
			
			function setLadderTypeDiv() {
				var html = "";
				var len = $("#itemList li").length;
				if(ladderType == "0") {
					html += "<div style='float: right; padding-top: 7px;'><div id='addBomb' class='typeOpbtn' style='margin-right: 10px;' onselectstart='return false'>" + strLang101 + "</div>";	
					html += "<div id='cutBomb' class='typeOpbtn' style='margin-right: 30px;' onselectstart='return false'>" + strLang102 + "</div>";
					html += "<div id='bombnum' style='display: inline-block;'>" + strLang103 + "<span style='margin: 0px 5px 0px 15px;'>" + bombnum + "</span>" + strLang104 + "</div></div>";
					$("#itemList").empty();
					for(var i = 0; i < len; i++) {
						$("#itemList").append("<li class='item'><input type='text' class='input tempItem' readonly='readonly' style='background: rgb(244, 245, 245)' /><input name='items' style='display: none;' _itemindex='" + i + "' ></li>");
						$(".tempItem:eq(" + i + ")").val("?");
					}
				} else if(ladderType == "2") {
					$("#itemList").empty();
					for(var i = 0; i < len; i++) {
						$("#itemList").append("<li class='item'><input type='text' class='input tempItem' readonly='readonly' style='background: rgb(244, 245, 245)' /><input name='items' style='display: none;' _itemindex='" + i + "' ></li>");
						$(".tempItem:eq(" + i + ")").val("?");
					}
				} else {
					if(ladderType == "1") {
						getMoney();
						html += "<div id='totalmoney' style='float: right; line-height: 50px;'>$<span style='margin: 0px 5px 0px 15px;'>" + totalmoney + "</span>" + strLang105 + "</div>";
					}
					$("#itemList").empty();
					for(var i = 0; i < len; i++) {
						$("#itemList").append("<li class='item'><input type='text' class='input' name='items' maxlength='" + maxitem + "' /></li>");
						$("input[name='items']:eq(" + i + ")").val(items[i]);
					}
				}
				$("#ladderTypeOption").html(html);
			}
			
			var bombnum = 1;
			function setBomb(bombadd) {
				bombnum = Number($("#bombnum span").text());
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
			
			function ladderSetInitVar() {
				if("${ladderId}" !== "") {
					ladderId = "${ladderId}";
					
					var retladinfo = getPreLadder(ladderId);
					preLadderListComplete(retladinfo["lad"], retladinfo["ladline"]);
				} else {
					ladderId = "";
					title = "";
					secretFlag = "0";
					ladderType = "<c:out value='${ladType}' />";
					lineCnt = "";
				}
			}
			
			function ladderSetInitView() {
				ladder_window_resize();
				
				$("#title").val(title);
				
				$("#ladderSecret img").removeClass("active");
				$("#ladderSecret [_flag='" + secretFlag + "']").addClass("active");
				
				$(".ladderType .select").removeClass("active");
				$(".ladderType .default").addClass("active");
				$(".ladderType[_num='" + ladderType + "'] img").toggleClass("active");
				setLadderTypeDiv();
			}
			
			/** 이전사다리 가져오기 */
			var ladder_pre_set_dialogArguments = [];
			function preLadderList() {
				ladder_pre_set_dialogArguments[0] = "";
				ladder_pre_set_dialogArguments[1] = preLadderListComplete;
				
				GetOpenWindow("/ezLadder/ladderMain.do?mode=pre&currPage=1&searchSelect=&searchInput=", "ladder_pre_set", 1238, 813);
			}			
			function preLadderListComplete(ladderInfo, lineInfo) {
				title = ladderInfo["title"];
				secretFlag = ladderInfo["secretFlag"];
				ladderType = ladderInfo["type"];
				lineCnt = ladderInfo["lineCnt"];
				if(ladderType == "0") {
					bombnum = 0;
					lineInfo.forEach(function(line, index) {
						if(line["item"] == "<spring:message code='ezLadder.t056' />") {
							bombnum++;
						}
					});
				}
				
				ladderSetInitView();
				checkAttendant(lineInfo);
				$("#makeLad").removeAttr("disabled").css({"background": "#0470e4", "cursor": "pointer"});
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
				}
			}

			function _manage_attendant() {
				manage_attendant_after();
			}

			/** 조직도 호출 */
			var ladder_select_attendant_dialogArguments = [];
			function manage_attendant_after() {
				setInputValue(true);
				
				/* ladder_select_attendant_dialogArguments[0] = {"attendants": attendants, "maxAttendant": maxAttendant}; */
				ladder_select_attendant_dialogArguments[0] = {"attendants": attendants};
				ladder_select_attendant_dialogArguments[1] = checkAttendant;

			    GetOpenWindow("/ezLadder/setLadderAttendant.do", "ladder_select_attendant", 970, 680);
			}

			/** 참여자 변경될때 슬라이더 바 조절 */
			function changeSliderValue(value) { 
				var maxLine = 10;
				var len = attendants["id"].length;
				if(len >= 2) {
					$("#slider-range-min").slider("option", "min", len);
					$("#slider-range-min").slider("option", "max", len * maxLine);
					if(!lineCnt) {
						$("#slider-range-min").slider("option", "value", Math.round(len * maxLine / 2));
					} else {
						$("#slider-range-min").slider("option", "value", lineCnt);
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
				setLadderTypeDiv();
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
					setInputValue(true);
					
					data = ReplaceText(data, ",", ";");
					
					var names = data.split(";");
					len = names.length;
					
					addIndex = attendants["id"].length;
					for (; i < len; i++) {
						names[i] = names[i].trim();
						
						if(names[i] == "") {
							continue;
						}
						
						getAttendantAJAX(names[i]);
						
						if(adCount === 0) { // 검색결과 없음 (완전 익명)
							alluser[i] = { "data": { "name": names[i], "name2": names[i] }, "datatype": "anony-json" };
						
						} else if(adCount === 1) { // 검색결과 하나
							var checkOverlap1 = attendants["id"].indexOf(getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]));
							/* var checkOverlap1 = attendants["id"].findIndex(function(id) {
								return id == getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]);
							}); */
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
					
					console.log(overlapuser.length);
					if(!!overlapuser.length) { // 중복유저 팝업
						retAttendantPopInfo[0] = true;
						retAttendantPopInfo[1] = bindAllUser;
						
						DivPopUpShow(360, 185, "/ezLadder/ladderPopup.do?popupType=overlap");
					} else {
						bindAllUser(false);
					}
					
				} else {
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
				
				/* 사람 수 제한시 */
				/* if(attendantlen + userdata.length > maxAttendant) {
					alert(maxAttendant + "<spring:message code='ezLadder.t048' />");
					userdata.splice(maxAttendant - attendantlen);
				} */
				
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
							attendants["name"][totallen] = getNodeText(user.getElementsByTagName("DATA3")[0]).substring(0, maxname);
							attendants["name2"][totallen] = getNodeText(user.getElementsByTagName("DATA3")[0]).substring(0, maxname);
						} else { // json
							attendants["name"][totallen] = user["name"].substring(0, maxname);
							attendants["name2"][totallen] = user["name2"].substring(0, maxname);
						}
					}
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
						picsrc = "/images/ezLadder/icon_defaultAttendant.png";
						
						if(attendants["id"][i].substring(0, 14) === "anonyAttendant") {
							html += '<li class="attendant"><div style="height: 140px; padding-top:  20px;">';
							html += '<div class="userPicWraper"><img src="' + picsrc + '" width="60px" height="60px" /></div>';
							html += '<div style="margin-top: 10px;"><span>'
							html += '<input type="text" class="input" name="userNames" style="line-height: 30px;" id="userNames' + i + '" maxlength="' + maxname + '" /></span></div>';
							html += '<input type="text" name="userName2s" style="display: none;" />';
							html += '<input type="text" name="userIds" style="display: none;" />';
							html += '<span><img id="removeIcon" src="/images/ezLadder/icon_removeAttendant.png" style="position: absolute; top: 22px; right: 10px; cursor: pointer;"></span></div></li>';
						} else {
							if(attendants["pic"][i] !== "") {
								picsrc = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + attendants["pic"][i];
							}
							
							html += '<li class="attendant"><div style="height: 140px; padding-top:  20px;">';
							html += '<div class="userPicWraper"><img src="' + picsrc + '" width="60px" height="60px" /></div>';
							html += '<div style="margin-top: 10px;"><span>'
							html += '<input type="text" class="input" readonly="readonly" name="userNames" style="line-height: 30px; background: rgb(244, 245, 245)" /></span></div>';
							html += '<input type="text" name="userName2s" style="display: none;" />';
							html += '<input type="text" name="userIds" style="display: none;" />';
							html += '<span><img id="removeIcon" src="/images/ezLadder/icon_removeAttendant.png" style="position: absolute; top: 22px; right: 10px; cursor: pointer;"></span></div></li>';
						}
						
						$("#attendantList").append(html);
						
						var thisLi = "#attendantList li:eq(" + i + ")";
						$(thisLi + " input[name='userNames']").val(attendants["name"][i]);
						$(thisLi + " input[name='userName2s']").val(attendants["name2"][i]);
						$(thisLi + " input[name='userIds']").val(attendants["id"][i]);
						
						if(ladderType == "0" || ladderType == "2") {
							$("#itemList").append("<li class='item'><input type='text' class='input tempItem' readonly='readonly' style='background: rgb(244, 245, 245)' /><input style='display: none;' name='items' _itemindex='" + i + "' /></li>");
							$(".tempItem:eq(" + i + ")").val("?");
						} else {
							$("#itemList").append("<li class='item'><input type='text' class='input' name='items' id='items" + i + "' maxlength='" + maxitem + "' /></li>");
							$("#itemList li:eq(" + i + ") input").val(items[i]);
						}
						
					}
					changeSliderValue();
					add_user_change_ulsize(attendants["id"].length);
					changeUser(len);
				}
				
				$("#ladderLineBox").scrollLeft(len * 150);
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
				if(!$("#title").val()) {
					alert("<spring:message code='ezLadder.t019'/>");
					return;
				}
				if(!attendants || attendants["id"].length < 2) {
					alert("<spring:message code='ezLadder.t020'/>");
					return;
				}
				$("[name='userNames']").each(function(){
					if(this.value == "") {
						alert("<spring:message code='ezLadder.t055'/>");
						return;
					}
				});
				
				$("#makeLad").attr("disabled", "disabled");
				
				$("input[name='secretFlag']").val($("#ladderSecret .active").attr("_flag"));
				$("input[name='type']").val(ladderType);
				$("input[name='lineCnt']").val($("#amount").text());
				
				items.forEach(function(item, index) {
					if(ladderType == "0") {
						items[index] = index < bombnum ? "<spring:message code='ezLadder.t056'/>" : "<spring:message code='ezLadder.t057'/>";
					} else if(ladderType == "2") {
						items[index] = index + 1;
					}
				});
				
				var temp;
				var randomIdx;
				items.forEach(function(item, index) {
					randomIdx = Math.floor(Math.random() * (items.length - 1));
					temp = item;
					items[index] = items[randomIdx]; 
					items[randomIdx] = temp;
				});
				
				items.forEach(function(item, index) {
					$("[_itemindex='" + index + "']").val(item);
				});
				
				setInputValue(true);
				
				$("#ladMakeForm").submit();
			} 

		</script>
		<style type="text/css">
			.ui-widget-header {
				background: #ddeeff;
			}
			.ladderType, .ladderSecret {
				width: 50px;
				height: 50px;
				display: inline-block;
			}
			.icon {
				border-radius: 15px;
				cursor: pointer;
				display: none;
			}
			.default {
				border: 2px solid #dddddd; 
			}
			.select {
				border: 2px solid #0470e4; 
			}
			.typeOpbtn {
				display: inline-block;
				border: 1px solid #dddddd;
				padding: 10px 15px;
				border-radius: 5px;
				cursor: pointer;
				user-select: none;
			}
			.active {
				display: inline;
			}
		</style>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezLadder.t018" /></h1>
		<form id="ladMakeForm" method="post" action="/ezLadder/setLadder.do" name="ladMakeForm">
			<table class="setTable" style="min-width: 750px;">
				<tr>
					<td>
						<div style="height: 50px; line-height: 50px; margin-bottom: 10px; position: relative;">
							<div style="height: 40px; position: absolute; left: 0; right: 65px;">
								<input type="text" class="input" name="title" id="title" style="height: 100%; width: 100%;" placeholder="<spring:message code="ezLadder.t019"/>" maxlength="166"/>
								<div id="ladderPreList" style="top: 7px; right: 11px;"><img src="/images/ezLadder/icon_preLadder.png"/></div>
							</div>
							<div id="ladderSecret" style="position: absolute; right: 0;">
								<img src="/images/ezLadder/icon_public.png" class="default icon" _flag="0"/>
								<img src="/images/ezLadder/icon_private.png" class="select icon" _flag="1"/>
							</div>
							<input name="secretFlag" style="display: none;" />
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div style="height: 50px; margin-bottom: 10px;">
							<div style="float: left; height: 40px; line-height: 50px;">
								<input type="text" class="input" id="inputAttendant" style="height: 100%; width: 200px;" placeholder="<spring:message code='ezLadder.t071' />"/>
							</div>
							<div style="float: right;">
									<div id="ladderTypeOption" style='display: inline-block; margin-right: 30px; height: 50px;'></div>
									<div class="ladderType" _num="0">
										<img src="/images/ezLadder/icon_game00_no.png" class="default icon"/>
										<img src="/images/ezLadder/icon_game00.png" class="select icon"/>
									</div>
									<div class="ladderType" _num="1">
										<img src="/images/ezLadder/icon_game01_no.png" class="default icon"/>
										<img src="/images/ezLadder/icon_game01.png" class="select icon"/>
									</div>
									<div class="ladderType" _num="2">
										<img src="/images/ezLadder/icon_game02_no.png" class="default icon"/>
										<img src="/images/ezLadder/icon_game02.png" class="select icon"/>
									</div>
									<div class="ladderType" _num="3">
										<img src="/images/ezLadder/icon_game03_no.png" class="default icon"/>
										<img src="/images/ezLadder/icon_game03.png" class="select icon"/>
									</div>
								<input name="type" style="display: none;" />
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div style="height:50px; margin-bottom: 25px; line-height: 50px;">
							<div style="height: 50px; width: 50px; border: 1px solid #dddddd; text-align: center; border-radius: 25px; float: left; margin-left: 5px;">
								<span id="amount">0</span>
							</div>
							<div id="slider-range-min" style="width: 300px; top: 19px; left: 70px; margin: 0;"></div>
							<input name="lineCnt" style="display: none;" />
						</div>
					</td>
				</tr>
				<tr>
					<td style="position: relative; margin-top: 20px;">
						<div id="addAttendant" class="icondiv" style="width: 50px; height: 50px; overflow: hidden; border: 2px solid #0470e4; border-radius: 15px; cursor: pointer;">
							<img src="/images/ezLadder/icon_addAttendant.png" style="padding-left: 2px; padding-top: 2px; display: block"/>
							<img src="/images/ezLadder/icon_addAttendant_hover.png" style="padding-left: 2px; padding-top: 2px; display: none"/>
						</div>
						<div id="ladderLineBox" style="border: 1px solid #ddd; height: 450px; overflow-y: hidden; overflow-x: auto; min-width: 750px;">
							<div style="height: 140px;">
								<ul id="attendantList"></ul>
							</div>
							<div id="lineDiv" style="position: relative; z-index: -1;">
								<canvas id='ladderCanvasLine' width='0' height='250'></canvas>
								<canvas id='ladderCanvas' width='0' height='250'></canvas>
							</div>
							<ul id="itemList" style="margin-top: 10px; height: 50px;"></ul>
						</div>
					</td>
				</tr>
			</table>
			<div class="wrap" style="min-width: 800px;">
				<input type="button" class="ladderBtn" id="makeLad" disabled="disabled" value="<spring:message code="ezLadder.t018"/>">
			</div>
		</form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>