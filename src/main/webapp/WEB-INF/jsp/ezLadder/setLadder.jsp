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
						lineCnt = ui.value;
					}
				});
				
				ladderId = "${ladderId}";
				ladderSetInitVar(ladderId);
				ladderSetInitView();
				
				
				$("#makeLad").on("click", function(e) {
					makeLadder();
					return false;
				});
				$("#title").on("input", function() {
					if($("#title").val() == "") {
						$("#makeLad").attr("disabled", "disabled");
					} else {
						$("#makeLad").removeAttr("disabled");
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
						$("#inputAttendant").val("");
						checkAttendant(inputNames);
					}
				});
				
				$(".ladderType")
					.on("click", function() {
						var imgs = $(".ladderType[_num='" + ladderType + "']").find("img");
						
						imgs.removeClass("active");
						imgs.eq(0).addClass("active");
						
						ladderType = $(this).attr("_num");
						imgs = $(this).find("img");
						
						imgs.removeClass("active");
						imgs.eq(2).addClass("active").css("border", "2px solid #0470e4");
						
						setInputValue(false);
						setLadderTypeDiv();
					})
					.on("mouseenter", function() {
						var imgs = $(this).find("img");
						
						imgs.removeClass("active");
						imgs.eq(2).addClass("active");
						if($(this).attr("_num") != ladderType) {
							imgs.eq(2).css("border", "2px solid #dddddd");
						} else {
							imgs.eq(2).css("border", "2px solid #0470e4");
						}
					})
					.on("mouseleave", function() {
						var imgs = $(this).find("img");
						
						imgs.removeClass("active");
						if($(this).attr("_num") != ladderType) {
							imgs.eq(0).addClass("active");
						} else {
							imgs.eq(1).addClass("active");
						}
					});
				$("#ladderSecret").on("click", function() {
					$("#ladderSecret img").toggleClass("active");
				});
				// 목록으로 버튼
				$("#backToList").on("click", function() {
					window.location.href= '/ezLadder/ladderMain.do?brdID=7';
				});
				
				var timer;
				var scrollCnt = 0;
				$(document)
					.on("dragstart", ".mainbody img", function() {
						return false;
					})
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
			
			function add_user_change_ulsize(usernum) {
				$("#ladderLineBox ul").css("width", (usernum * 150) + "px");
				$("#ladderCanvas").attr("width", (usernum * 150) + "px");
				
			}
			
			function setLadderTypeDiv() {
				var html = "";
				var len = $("#itemList li").length;
				if(ladderType == "0") {
					if(len > 0 && bombnum > len) {
						bombnum = len;
					}
					html += "<div style='float: right; padding-top: 7px;'><div id='addBomb' class='typeOpbtn' style='margin-right: 10px;' onselectstart='return false'>" + strLang51 + "</div>";	
					html += "<div id='cutBomb' class='typeOpbtn' style='margin-right: 30px;' onselectstart='return false'>" + strLang52 + "</div>";
					html += "<div id='bombnum' style='display: inline-block;'>" + strLang53 + "<span style='margin: 0px 5px 0px 15px;'>" + bombnum + "</span>" + strLang54 + "</div></div>";
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
						html += "<div id='totalmoney' style='float: right; line-height: 50px;'>$<span style='margin: 0px 5px 0px 15px;'>" + totalmoney + "</span>" + strLang55 + "</div>";
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
			
			/** 재사용 사다리 정보 가져오기 */
			function getPreLadder(ladderID) {
				var templist = [];
				var ladinfo = [];
				
				$.ajax({
					type: "GET",
					url: "/ezLadder/getLadderGame.do",
					traditional: true,
					dataType: "json",
					async : false,
					data: {
						"ladderId": ladderID,
						"mode": "pre"
					},
					success: function(result) {
						ladinfo["lad"] = result.vo;
						ladinfo["ladline"] = result.list;
					}
				});
				
				return ladinfo;
			}
			
			function ladderSetInitVar(ladderId) {
				if(!!ladderId) {
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
				
				var imgs = $(".ladderType[_num='" + ladderType + "'] img");
				$(".ladderType .select").removeClass("active");
				$(".ladderType .default").addClass("active");
				imgs.eq(0).removeClass("active");
				imgs.eq(1).addClass("active");
				setLadderTypeDiv();
			}
			
			/** 이전사다리 가져오기 */
			var ladder_pre_set_dialogArguments = [];
			function preLadderList() {
				ladder_pre_set_dialogArguments[0] = "";
				ladder_pre_set_dialogArguments[1] = ladderSetInitVar;
				
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
						if(line["item"] == strLang48) {
							bombnum++;
						}
					});
				}
				
				ladderSetInitView();
				
				/* var userdata = {"userId": [], "userName": [], "userName2": [], "pic": [], "item": []};
				lineInfo.forEach(function(line, index) {
					userdata["userId"][index] = line.userId;
					userdata["userName"][index] = line.userName;
					userdata["userName2"][index] = line.userName2;
					userdata["pic"][index] = line.pic;
					userdata["item"][index] = line.item;
				}); */
				
				setAllUser_(lineInfo, "preladder");
				
				$("#makeLad").removeAttr("disabled");
			}
			
			/** 참여자, 아이템 배열을 현재 input box 정보로 셋팅 */
			function setInputValue(allsetting) {
				var userlen = 0;
				var name = "";
				var i = 0;
				
				if(attendants !== null) {
					userlen = attendants["name"].length;
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
				
				ladder_select_attendant_dialogArguments[0] = attendants;
				ladder_select_attendant_dialogArguments[1] = manage_attendant_complete;

				GetOpenWindow("/ezLadder/setLadderAttendantPopUp.do", "ladder_select_attendant", 970, 680);
			}
			
			function manage_attendant_complete(rtn) {
				setAllUser_(rtn);
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
				setInputValue(false);
				
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
			var alluser;
			var overlapuser;
			var searchOLNameSet;
			function checkAttendant(data) {
				alluser = {"userId": [], "userName": [], "userName2": [], "deptName": [], "pic": [], "temporder": []};
				overlapuser = {"userId": [], "userName": [], "userName2": [], "deptName": [], "pic": [], "temporder": [], "usertype": []};
				
				if(attendants === null) {
					attendants = { "id": [], "name": [], "name2": [], "pic": [], "order": [] };
					items = [];
				}
				
				if(typeof data === "string") {
					setInputValue(true);
					
					data = ReplaceText(data, ",", ";");
					
					var names = data.split(";");
					names.forEach(function(name, index) {
						names[index] = name.trim();
					});
					
					getUserArray(names);
					
					if(!!nameSearchResult) {
						searchUser = {"userId": [], "userName": [], "userName2": [], "deptName": [], "pic": []};
						nameSearchResult.forEach(function(val, i) {
							searchUser["userId"][i] = val.userId;
							searchUser["userName"][i] = val.userName;
							searchUser["userName2"][i] = val.userName2;
							searchUser["deptName"][i] = val.deptName;
							searchUser["pic"][i] = val.pic;
						});
						
						var searchUserLen = searchUser["userId"].length;
						var serchNameOverlapUser = {"userId": [], "userName": [], "deptName": []};
						var alluserCnt = 0;
						var overlapuserCnt = 0;
						for(var i = 0; i < searchUserLen; i++) {
							if(!!searchUser["userId"][i]) {
								var chkOL0 = false; // 검색 이름 중 이름 중복 검사
								var chkOL1 = attendants["id"].indexOf(searchUser["userId"][i]); // 전에 등록한 참여자중 아이디 중복 검사
								var chkOL2 = alluser["userId"].indexOf(searchUser["userId"][i]); // 지금 등록한 참여자중 아이디 중복 검사
								
								for(var j = 0; j < searchUserLen; j++) {
									if(searchUser["userId"][i] != searchUser["userId"][j] && searchUser["userName"][i] == searchUser["userName"][j] && i != j) {
										chkOL0 = true;
										break;
									}
								}
								
								if(chkOL0) {
									// 이름 검색이 중복 (팝업확인)
									if(serchNameOverlapUser["userId"].indexOf(searchUser["userId"][i]) == -1) {
										var idx = serchNameOverlapUser["userId"].length;
										serchNameOverlapUser["userId"][idx] = searchUser["userId"][i];
										serchNameOverlapUser["userName"][idx] = searchUser["userName"][i];
										serchNameOverlapUser["deptName"][idx] = searchUser["deptName"][i];
									}
									/* searchOLNameSet.add(searchUser["userId"][i]); */
								}
								if(chkOL1 == -1 && chkOL2 == -1) {
									// 참여자 노중복
									alluser["userId"][alluserCnt] = searchUser["userId"][i];
									alluser["userName"][alluserCnt] = searchUser["userName"][i];
									alluser["userName2"][alluserCnt] = searchUser["userName2"][i];
									alluser["deptName"][alluserCnt] = searchUser["deptName"][i];
									alluser["pic"][alluserCnt] = searchUser["pic"][i];
									alluser["temporder"][alluserCnt] = i;
									alluserCnt++;
								} else {
									// 참여자 중복 (팝업확인)
									overlapuser["userId"][overlapuserCnt] = searchUser["userId"][i];
									overlapuser["userName"][overlapuserCnt] = searchUser["userName"][i];
									overlapuser["userName2"][overlapuserCnt] = searchUser["userName2"][i];
									overlapuser["deptName"][overlapuserCnt] = searchUser["deptName"][i];
									overlapuser["pic"][overlapuserCnt] = searchUser["pic"][i];
									overlapuser["temporder"][overlapuserCnt] = i;
									overlapuser["usertype"][overlapuserCnt] = "";
									overlapuserCnt++;
								}
							} else {
								// 익명
								alluser["userId"][alluserCnt] = "";
								alluser["userName"][alluserCnt] = searchUser["userName"][i];
								alluser["userName2"][alluserCnt] = searchUser["userName"][i];
								alluser["deptName"][alluserCnt] = "";
								alluser["pic"][alluserCnt] = "";
								alluser["temporder"][alluserCnt] = i;
								alluserCnt++;
							}
						}
						
						var onlyNameOLLen = serchNameOverlapUser["userId"].length;
						if(onlyNameOLLen > 0) {
							var idIndex;
							
							retAttendantPopInfo[0] = serchNameOverlapUser;
							retAttendantPopInfo[1] = firstPopupComp;
							
							DivPopUpShow(360, 258, "/ezLadder/ladderPopup.do?popupType=overlapOnlyName");
						} else {
							showSecondOverlapPopup();
						}
						
						function firstPopupComp(retAttendants) {
							DivPopUpHidden();
							
							var retLen = retAttendants["userId"].length;
							var i = 0;
							var removeIdx1;
							var removeIdx2;
							
							while(true) {
								removeIdx1 = alluser["userId"].indexOf(retAttendants["userId"][i]);
								if(removeIdx1 != -1) {
									alluser["userId"].splice(removeIdx1, 1);
									alluser["userName"].splice(removeIdx1, 1);
									alluser["userName2"].splice(removeIdx1, 1);
									alluser["deptName"].splice(removeIdx1, 1);
									alluser["pic"].splice(removeIdx1, 1);
									alluser["temporder"].splice(removeIdx1, 1);
								} else {
									i++;
									if(!retAttendants["userId"][i]) {
										break;
									}
								}
							}
							if(!!overlapuser["userId"].length) {
								i = 0;
								while(true) {
									removeIdx2 = overlapuser["userId"].indexOf(retAttendants["userId"][i]);
									if(removeIdx2 != -1) {
										overlapuser["userId"].splice(removeIdx2, 1);
										overlapuser["userName"].splice(removeIdx2, 1);
										overlapuser["userName2"].splice(removeIdx2, 1);
										overlapuser["deptName"].splice(removeIdx2, 1);
										overlapuser["pic"].splice(removeIdx2, 1);
										overlapuser["temporder"].splice(removeIdx2, 1);
										overlapuser["usertype"].splice(removeIdx2, 1);
									} else {
										i++;
										if(!retAttendants["userId"][i]) {
											break;
										}
									}
								}
							}
							
							showSecondOverlapPopup();
						}
						
						function showSecondOverlapPopup() {
							if(!!overlapuser["userId"].length) {
								retAttendantPopInfo[0] = overlapuser;
								retAttendantPopInfo[1] = bindAllUser;
								
								DivPopUpShow(360, 185, "/ezLadder/ladderPopup.do?popupType=overlap");
							} else {
								bindAllUser(false);
							}
						}
					}
				} 
				
				/** 이름 검색으로 중복 처리한 유저 포함하여 추가 */
				var bindAllUser;
				function bindAllUser(value, type) {
					DivPopUpHidden();
					
					var totalLen = attendants["id"].length;
					var allUserLen = (function() {
						var totalOrder = alluser["temporder"][alluser["userId"].length - 1];
						var overlapOrder;
						if(!!overlapuser["userId"].length) {
							overlapOrder = overlapuser["temporder"][overlapuser["userId"].length - 1];
							totalOrder = totalOrder > overlapOrder ? totalOrder : overlapOrder;
						}
						return totalOrder;
					});
					
					for(var i = 0, j = 0, k = 0; i < allUserLen() + 1; i++) {
						if(alluser["temporder"].indexOf(i) != -1) {
							if(!alluser["userId"][j]) {
								attendants["id"][totalLen] = "anonyAttendant_" + totalLen;
								alluser["userName2"][j] = alluser["userName"][j]
							} else {
								attendants["id"][totalLen] = alluser["userId"][j];
							}
							attendants["name"][totalLen] = alluser["userName"][j];
							attendants["name2"][totalLen] = alluser["userName2"][j];
							attendants["pic"][totalLen] = alluser["pic"][j];
							attendants["order"][totalLen] = totalLen;
							j++;
						} else if(overlapuser["temporder"].indexOf(i) != -1) {
							if(!overlapuser["userId"][k] || type == "anony") {
								attendants["id"][totalLen] = "anonyAttendant_" + totalLen;
								overlapuser["userName2"][k] = overlapuser["userName"][k]
							} else {
								attendants["id"][totalLen] = overlapuser["userId"][k];
							}
							attendants["name"][totalLen] = overlapuser["userName"][k];
							attendants["name2"][totalLen] = overlapuser["userName2"][k];
							attendants["pic"][totalLen] = overlapuser["pic"][k];
							attendants["order"][totalLen] = totalLen;
							k++;
						}
						items[totalLen] = "";
						totalLen++;
					}
					
					setAttendantsView();
				}
			}
			
			/** 조직도, 이전 사다리에서 불러온 유저 추가 */
			function setAllUser_(userdata, addtype) {
				DivPopUpHidden();
				
				attendants = { "id": [], "name": [], "name2": [], "pic": [], "order": [] };
				
				if(addtype == "preladder") {
					items = [];
					userdata.forEach(function(line, idx) {
						attendants["id"][idx] = line["userId"];
						attendants["name"][idx] = line["userName"];
						attendants["name2"][idx] = line["userName2"];
						attendants["pic"][idx] = line["pic"];
						attendants["order"][idx] = idx;
						items[idx] = line["item"];
					});
				} else {
					var order = 0;
					var userdataLen = userdata["userId"].length;
					
					if(items == null) {
						items = [];
					}
					
					for(; order < userdataLen; order++) {
						attendants["id"][order] = userdata["userId"][order];
						attendants["name"][order] = userdata["userName"][order];
						attendants["name2"][order] = userdata["userName2"][order];
						attendants["pic"][order] = userdata["pic"][order];
						attendants["order"][order] = order; 
						if(items.length - 1 < order) {
							items[order] = "";
						}
					}
				}
				/* 사람 수 제한시 */
				/* if(attendantlen + userdata.length > maxAttendant) {
					alert(maxAttendant + "<spring:message code='ezLadder.t048' />");
					userdata.splice(maxAttendant - attendantlen);
				} */
				
				setAttendantsView();
			}
			
			/** 화면에 참여자 나타내기 */
			function setAttendantsView() {
				var len = attendants["id"].length;
				var html = "";
				
				if(attendants !== null) {
					$("#attendantList").html("");
					$("#itemList").html("");
					
					for(var i = 0; i < len; i++) {
						var picsrc = "/images/ezLadder/icon_defaultAttendant.png";
						html = "";
						
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
								picsrc = attendants["pic"][i];
								/* if(attendants["pic"][i].substring(0, 10) == "/ezCommon/") {
								} else {
									picsrc = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + attendants["pic"][i];
								} */
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
			
			var nameSearchResult;
			function getUserArray(names) {
				$.ajax({
					type: "POST",
					url: "/ezLadder/setLadderAttendant.do",
					dataType: "json",
					traditional: true,
					async : false,
					data: {
						"searchUserName": names
					},
					success: function(resultName) {
						nameSearchResult = resultName.JSONObjectList;
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
				var userNamesLen = $("[name='userNames']").length;
				for(var i = 0; i < userNamesLen; i++) {
					if($("#userNames" + i).val() == "") {
						alert("<spring:message code='ezLadder.t055'/>");
						return;
					}
				}
				
				$("#makeLad").attr("disabled", "disabled");
				
				$("input[name='secretFlag']").val($("#ladderSecret .active").attr("_flag"));
				$("input[name='type']").val(ladderType);
				$("input[name='lineCnt']").val($("#amount").text());
				
				items.forEach(function(item, index) {
					if(ladderType == "0") {
						items[index] = index < bombnum ? strLang48 : strLang49;
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
			input[type=text]::-ms-clear {
				display:none;
			}
			.ui-widget-header {
				background: #ddeeff;
			}
			.ui-widget-content {
				border: 1px solid #dddddd;
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
			.typehover {
				background: #ddeeff;
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
			#addBomb:hover, #cutBomb:hover {
				border: 1px solid #0470e4;
				color: #0470e4;
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
								<div id="ladderPreList" style="top: 7px; right: 11px;"><img  title="<spring:message code='ezLadder.t079'/>" src="/images/ezLadder/icon_preLadder.png"/></div>
							</div>
							<div id="ladderSecret" style="position: absolute; right: 0;">
								<img src="/images/ezLadder/icon_public.png" title="<spring:message code='ezLadder.t0070'/>" class="default icon" _flag="0"/>
								<img src="/images/ezLadder/icon_private.png" title="<spring:message code='ezLadder.t076'/>" class="select icon" _flag="1"/>
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
									<c:forEach begin="0" end="3" var="typenum">
										<div class="ladderType" _num="${typenum}">
											<img title="<spring:message code='ezLadder.t10${typenum + 1}'/>" src="/images/ezLadder/icon_game0${typenum}_no.png" class="default icon"/>
											<img title="<spring:message code='ezLadder.t10${typenum + 1}'/>" src="/images/ezLadder/icon_game0${typenum}.png" class="select icon"/>
											<img title="<spring:message code='ezLadder.t10${typenum + 1}'/>" src="/images/ezLadder/icon_game0${typenum}_hover.png" class="typehover icon"/>
										</div>
									</c:forEach>
									<%-- <div class="ladderType" _num="0">
										<img title="<spring:message code='ezLadder.t101'/>" src="/images/ezLadder/icon_game00_no.png" class="default icon"/>
										<img title="<spring:message code='ezLadder.t101'/>" src="/images/ezLadder/icon_game00.png" class="select icon"/>
									</div>
									<div class="ladderType" _num="1">
										<img title="<spring:message code='ezLadder.t102'/>" src="/images/ezLadder/icon_game01_no.png" class="default icon"/>
										<img title="<spring:message code='ezLadder.t102'/>" src="/images/ezLadder/icon_game01.png" class="select icon"/>
									</div>
									<div class="ladderType" _num="2">
										<img title="<spring:message code='ezLadder.t103'/>" src="/images/ezLadder/icon_game02_no.png" class="default icon"/>
										<img title="<spring:message code='ezLadder.t103'/>" src="/images/ezLadder/icon_game02.png" class="select icon"/>
									</div>
									<div class="ladderType" _num="3">
										<img title="<spring:message code='ezLadder.t104'/>" src="/images/ezLadder/icon_game03_no.png" class="default icon"/>
										<img title="<spring:message code='ezLadder.t104'/>" src="/images/ezLadder/icon_game03.png" class="select icon"/>
									</div> --%>
								<input name="type" style="display: none;" />
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div style="height:50px; margin-bottom: 25px; line-height: 50px;">
							<div style="height: 50px; width: 50px; border: 1px solid #dddddd; text-align: center; border-radius: 25px; float: left; margin-left: 5px;" title="<spring:message code='ezLadder.t081'/>">
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
							<img src="/images/ezLadder/icon_addAttendant.png" style="padding-left: 2px; padding-top: 2px; display: block" title="<spring:message code='ezLadder.t080'/>"/>
							<img src="/images/ezLadder/icon_addAttendant_hover.png" style="padding-left: 2px; padding-top: 2px; display: none" title="<spring:message code='ezLadder.t080'/>"/>
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
				<input type="button" id="backToList" style="background: #efefef; color: #000000;" value="<spring:message code="ezLadder.t083"/>" />
			</div>
		</form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>