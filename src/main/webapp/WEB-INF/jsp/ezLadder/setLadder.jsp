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
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezLadder/ladder_CSS.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.css')}">
		<script type="text/javascript" src="${util.addVer('ezLadder.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezLadder/ladder.min.js')}"></script>
		
		<script type="text/javascript">
			var ladderId;
			var title;
			var secretFlag;
			var ladderType;
			var lineCnt;
			var marginChangeAttendantNum = 50;
			var maxAttendant = 70;
			var maxname = 30;
			var maxitem = 50;
		
			function ladder_window_resize() {
				var win_width = document.body.clientWidth;
				var $linebox = $("#ladderLineBox");
				
				$(".setTable").css("width", win_width + "px");
				$linebox.css("width", (win_width - $linebox.css("padding-left").replace("px", "")) + "px");
				
				var $popup = $("#iFramePanel");
				if($popup.css("display") != "none") {
					var position = DivPopUpPosition($popup.width(), $popup.height());
					
					$popup.css({"top": position[0] + "px", "left": position[1] + "px"});
				}
			}
			$(function() {
				$(window).resize(function (){
					ladder_window_resize();
				});
				
				var tooltip = $(".moOverTooltip");
				var handle = $("#custom-handle");
				$("#slider-range-min")
					.slider({ 
						range: "min",
						value: 0,
						min: 0,
						max: 0,
						create: function() {
							handle.text($(this).slider("value"));
						},
						slide: function( event, ui ) {
							/* $("#amount").text(ui.value); */
							handle.text(ui.value);
						},
						stop: function(event, ui) {
							lineCnt = ui.value;
						}
					})
					.on("mouseenter", function() {
						tooltip.html("<p><spring:message code='ezLadder.t081' /></p>").css({"display": "block", "width": tooltip.width() + "px"});
					})
					.on("mousemove", function() {
						tooltip.css({"left": (event.clientX + 2) + "px", "top": (event.clientY + 2) + "px"});
					})
					.on("mouseleave", function() {
						tooltip.css("display", "none");
					});
				
				ladderId = "<c:out value='${ladderId}' />";
				ladderSetInitVar(ladderId);
				ladderSetInitView();
				
				
				$("#makeLad").on("click", function(e) {
					makeLadder();
					return false;
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
						//$("#addAttendant").css("background", "#ddeeff");
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
						imgs.eq(2).addClass("active").css("border", "1px solid #888");
						
						setLadderTypeDiv();
					})
					.on("mouseenter", function() {
						var imgs = $(this).find("img");
						
						imgs.removeClass("active");
						imgs.eq(2).addClass("active");
						if($(this).attr("_num") != ladderType) {
							imgs.eq(2).css("border", "1px solid #dddddd");
						} else {
							imgs.eq(2).css("border", "1px solid #888");
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
					var temp = $("#ladderSecret .active").attr("_flag");
					if(temp == 0) {
						$(this).children("img").attr("src", "/images/ezLadder/icon_public_hover.png");
					} else {
						$(this).children("img").attr("src", "/images/ezLadder/icon_private_hover.png");
					}
				}).on("mouseenter", function(event) {
					var temp = $("#ladderSecret .active").attr("_flag");
					if(temp == 0) {
						$(this).children("img").attr("src", "/images/ezLadder/icon_public_hover.png");
					} else {
						$(this).children("img").attr("src", "/images/ezLadder/icon_private_hover.png");
					}
				}).on("mouseleave", function(event) {
					var temp = $("#ladderSecret .active").attr("_flag");
					if(temp == 0) {
						$(this).children("img").attr("src", "/images/ezLadder/icon_public.png");
					} else {
						$(this).children("img").attr("src", "/images/ezLadder/icon_private.png");
					}
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
					.on("blur", "[name='userNames']", function() {
						if(!$(this).is("[readonly]")) {
							var $userIdx = $("[name='userNames']").index(this);
							var $userVal = $(this).val();
							
							if(attendants["name"][$userIdx] != $userVal) {
								attendants["name"][$userIdx] = $userVal;
								attendants["name2"][$userIdx] = $userVal;
								$("[name='userName2s']").eq($userIdx).val($userVal);
							}
						}
					})
					.on("blur", "[name='items']", function(event) {
						var $itemIdx = $("[name='items']").index(this);
						var $itemVal = $(this).val();
						
						if(items[$itemIdx] != $itemVal) {
							items[$itemIdx] = $itemVal;
							
							if(ladderType == "1") {
								getMoney($(this));
								$("#totalmoney span").text(totalmoneyStr);
							}
						}
					})
					.on("keyup", "[name='items']", function() {
						var $itemIdx = $("[name='items']").index(this);
						var $itemVal = $(this).val();
						
						if($itemVal == "") {
							items[$itemIdx] = $itemVal;
							
							if(ladderType == "1") {
								getMoney($(this));
								$("#totalmoney span").text(totalmoneyStr);
							}
						}
					});
			});
			
			function add_user_change_ulsize(usernum) {
				if(usernum <= marginChangeAttendantNum) {
					wSize = 150;
					ladLeftPadding = 0;
					$("#ladderLineBox li").css("margin-right", "50px");
				} else{
					wSize = 110;
					ladLeftPadding = 40;
					$("#ladderLineBox li").css("margin-right", "10px");
				}
				$("#ladderLineBox ul").css("width", (usernum * wSize) + "px");
				$("#ladderCanvas").attr("width", (usernum * wSize));
			}
			
			function setLadderTypeDiv() {
				var html = "";
				var html2 = "";
				var len = $("#itemList li").length;
				var $itemList = $("#itemList");
				var $tempItemList = $("#tempItemList");
				
				if(ladderType == "0") {
					$itemList.css("display", "none");
					$tempItemList.css("display", "block");
					
					if(len > 0 && bombnum > len) {
						bombnum = len;
					}
					
					html += "<div><div style='float:right;' id='cutBomb' class='typeOpbtn' onselectstart='return false'><div class='typeOpbtnCover'></div><img src='/images/minus_ladder.png' width='35px' /></div>";
					html += "<div style='float:right;' id='addBomb' class='typeOpbtn' onselectstart='return false'><div class='typeOpbtnCover'></div><img src='/images/plus_ladder.png' width='35px' /></div>";
					html += "<div id='bombnum' style='float:right;border:1px solid #ddd;border-radius:10px;padding:0px 15px;height:45px;line-height:45px;margin:1px;margin-right:5px;background:white'>" + strLang23 + "<span style='margin: 0px 5px 0px 15px;'>" + bombnum + "</span>" + strLang9 + "</div></div>";
					
					$("#ladderTypeOption").html(html);
					setBomb();
				} else if(ladderType == "2") {
					$itemList.css("display", "none");
					$tempItemList.css("display", "block");
					$("#ladderTypeOption").html(html);
				} else {
					$itemList.css("display", "block");
					$tempItemList.css("display", "none");
					
					if(ladderType == "1") {
						moneyArr = [];
						totalmoney = 0;
						getMoney($("#itemList").find("input"));
						
						html += "<div id='totalmoney' style='float: right; line-height: 45px;border:1px solid #ddd;padding:0px 15px;margin:1px;border-radius:10px;background:white'><spring:message code='ezLadder.t107' /><span style='margin: 0px 5px 0px 15px;'>" + totalmoneyStr + "</span>" + strLang24 + "</div>";
					}
					$("#ladderTypeOption").html(html);
				}
			}
			
			var bombnum = 1;
			function setBomb(bombadd) {
				bombnum = Number($("#bombnum span").text());
				var liLen = $("#attendantList li").length;
				var coverDiv = $(".typeOpbtnCover");
				
				if(typeof bombadd == "boolean") {
					if(bombadd && bombnum < liLen) {
						$("#bombnum span").html(++bombnum);
					} else if(!bombadd && bombnum > 1) {
						$("#bombnum span").html(--bombnum);
					}
				}
				
				if(liLen > 1 && liLen > bombnum) {
					coverDiv.eq(1).removeClass("colorOpHide");
				} else {
					coverDiv.eq(1).addClass("colorOpHide");
				}
				
				if(1 == bombnum) {
					coverDiv.eq(0).addClass("colorOpHide")
				} else {
					coverDiv.eq(0).removeClass("colorOpHide")
				}
			}
			
			var totalmoney = 0;
			var totalmoneyStr = "0";
			var regNumber = /^[0-9]*$/;
			var regexp = /\B(?=(\d{3})+(?!\d))/g;
			var moneyArr = [];
			function getMoney(itemobj) {
				var moneyUnit = {"unitStr": [strLang25, strLang26, strLang27, strLang28], "unitWon": [10, 100, 1000, 10000]};
				var moneyNum = {"numStr": [strLang29, strLang30, strLang31, strLang32, strLang33, strLang34, strLang35, strLang36, strLang37], "number": [1, 2, 3, 4, 5, 6, 7, 8, 9]};
				var inputval = "";
				var objLen = itemobj.length;
				var i = objLen > 1 ? 0 : itemobj.attr("_itemindex");
				
				for(var i = 0; i < objLen; i++) {
					var obj = itemobj.eq(i);
					var itemindex = objLen == 1 ? obj.attr("_itemindex") : i;
					
					if(!!moneyArr[itemindex]) {
						totalmoney -= moneyArr[itemindex];
					}
					
					moneyArr[itemindex] = 0;
					
					inputval = obj.val().replace(/,/g, "").replace(/ /g, "");
					
					if(!!inputval) {
						if(inputval.slice(-1) == strLang24) {
							inputval = inputval.slice(0, -1);
						}
						
						if(regNumber.test(inputval)) {
							moneyArr[itemindex] = Number(inputval);
							obj.val(moneyArr[itemindex].toString().replace(regexp, ','));
						} else{
							var inputArr = inputval.split("");
							var inputUnit = [];
							
							inputArr.forEach(function(arr, idx) {
								var mUnitFlag = moneyUnit["unitStr"].indexOf(arr);
								var mNumFlag = moneyNum["numStr"].indexOf(arr);
								
								if(mUnitFlag != -1) {
									var mUnitString = moneyUnit["unitWon"][mUnitFlag].toString();
									if(idx == 0) {
										inputArr[idx] = mUnitString.substring(0, 1) + mUnitString.slice(1) + "/";
									} else {
										if(mUnitFlag == 3) {
											inputArr[idx] = "/" + mUnitString.slice(1) + "/";
											inputUnit.push(-1);
										} else {
											inputArr[idx] = mUnitString.slice(1) + "/";
										}
									}
									inputUnit.push(mUnitFlag);
								} else if(mNumFlag != -1) {
									inputArr[idx] = moneyNum["number"][mNumFlag].toString();
								}
							});
							
							if(inputUnit.length > 0) {
								var afterInputArr = inputArr.join("").split("/");
								var tempTotal = afterInputArr.reduce(function(result, currDt, idx) {
									if(inputUnit[idx + 1] != 3 && inputUnit[idx] > inputUnit[idx + 1] || inputUnit[idx + 1] == 3 || !inputUnit[idx + 1]) {
										if(currDt == "0000") {
											result = Number(result.toString().concat(currDt));
										} else {
											result += Number(currDt);
										}
									} else {
										result = undefined;
									}
									
									return result;
								}, 0);
								
								if(!!tempTotal) {
									moneyArr[itemindex] = tempTotal;
									obj.val(moneyArr[itemindex].toString().replace(regexp, ','));
								}
							}
						}
					}
					totalmoney += moneyArr[itemindex];
					totalmoneyStr = totalmoney.toString().replace(regexp, ',') || "0";
				}
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
				setAllUser_(lineInfo, "preladder");
				
				if(ladderType == "0") {
					bombnum = 0;
					lineInfo.forEach(function(line, index) {
						if(line["item"] == strLang18) {
							bombnum++;
						}
					});
				}
				ladderSetInitView();
				
				$("#makeLad").removeAttr("disabled");
			}
			
			function _manage_attendant() {
				manage_attendant_after();
			}

			/** 조직도 호출 */
			var ladder_select_attendant_dialogArguments = [];
			function manage_attendant_after() {
				
				ladder_select_attendant_dialogArguments[0] = {"attend": attendants, "item": items, "maxAttendant": maxAttendant};
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
					$("#custom-handle").text($("#slider-range-min").slider("value"));
					//$("#amount").text($("#slider-range-min").slider("value"));
				} else {
					$("#slider-range-min").slider("option", "max", 0);
					$("#slider-range-min").slider("option", "value", 0);
					$("#custom-handle").text(0);
					//$("#amount").text(0);
				}
			}

			/** 참여자 삭제 */
			function attendant_remove(index) {
				
				attendants["id"].splice(index, 1);
				attendants["name"].splice(index, 1);
				attendants["name2"].splice(index, 1);
				attendants["pic"].splice(index, 1);
				attendants["order"].splice(index, 1)
				items.splice(index, 1);
				
				var idLen = attendants["id"].length;
				$(".attendant:eq(" + index + ")").remove();
				$(".item:eq(" + index + ")").remove();
				$("#tempItemList li:eq(" + index + ")").remove();
				add_user_change_ulsize(idLen);
				changeUser(idLen);
				
				var $userIds = $("[name='userIds']");
				var $itemInput = $("[name='items']");
				for(var i = index; i < idLen; i++) {
					if(attendants["id"][i].substring(0, 14) == "anonyAttendant") {
						attendants["id"][i] = "anonyAttendant_" + i;
						$userIds.eq(i).val("anonyAttendant_" + i);
					}
					attendants["order"][i] = i;
					
					$itemInput.eq(i).attr("_itemindex", i);
				}
				
				changeSliderValue();
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
				alluser = {"userId": [], "userName": [], "userName2": [], "deptName": [], "pic": [], "temporder": [], "description": [], "description2": []};
				overlapuser = {"userId": [], "userName": [], "userName2": [], "deptName": [], "pic": [], "temporder": [], "usertype": [], "description": [], "description2": []};
				
				if(attendants === null) {
					attendants = { "id": [], "name": [], "name2": [], "pic": [], "order": [], "description": [], "description2": [] };
					items = [];
				}
				
				if(typeof data === "string") {
					
					data = ReplaceText(data, ",", ";");
					
					var names = data.split(";");
					names.forEach(function(name, index) {
						names[index] = name.trim();
					});
					
					getUserArray(names);
					
					if(!!nameSearchResult) {
						searchUser = {"userId": [], "userName": [], "userName2": [], "deptName": [], "pic": [], "description": [], "description2": []};
						nameSearchResult.forEach(function(val, i) {
							searchUser["userId"][i] = val.userId;
							searchUser["userName"][i] = val.userName;
							searchUser["userName2"][i] = val.userName2;
							searchUser["deptName"][i] = val.deptName;
							searchUser["description"][i] = val.deptName;
							searchUser["description2"][i] = val.deptName2;
							searchUser["pic"][i] = val.pic;
						});
						
						var searchUserLen = searchUser["userId"].length;
						var serchNameOverlapUser = {"userId": [], "userName": [], "deptName": [], "deptName": [], "description": [], "description2": []};
						var alluserCnt = 0;
						var overlapuserCnt = 0;
						for(var i = 0; i < searchUserLen; i++) {
							if(!!searchUser["userId"][i]) {
								var chkOL0 = false; // 검색 이름 중 이름 중복 검사
								var chkOL1 = attendants["id"].indexOf(searchUser["userId"][i]); // 전에 등록한 참여자중 아이디 중복 검사
								/* var chkOL2 = alluser["userId"].indexOf(searchUser["userId"][i]); // 지금 등록한 참여자중 아이디 중복 검사 */
								
								for(var j = 0; j < searchUserLen; j++) {
									if(searchUser["userName"][i] == searchUser["userName"][j]) {
										chkOL0 = true;
										break;
									}
								}
								
								if(chkOL0) {
									// 이름 검색이 중복 (팝업확인)
									/* if(serchNameOverlapUser["userId"].indexOf(searchUser["userId"][i]) == -1) { */
									var idx = serchNameOverlapUser["userId"].length;
									serchNameOverlapUser["userId"][idx] = searchUser["userId"][i];
									serchNameOverlapUser["userName"][idx] = searchUser["userName"][i];
									serchNameOverlapUser["deptName"][idx] = searchUser["deptName"][i];
									serchNameOverlapUser["description"][idx] = searchUser["description"][i];
									serchNameOverlapUser["description2"][idx] = searchUser["description2"][i];
									/* } */
									/* searchOLNameSet.add(searchUser["userId"][i]); */
								}
								if((chkOL1 == -1 ) || attendants["id"].length == 0) {
									// 참여자 노중복
									alluser["userId"][alluserCnt] = searchUser["userId"][i];
									alluser["userName"][alluserCnt] = searchUser["userName"][i];
									alluser["userName2"][alluserCnt] = searchUser["userName2"][i];
									alluser["deptName"][alluserCnt] = searchUser["deptName"][i];
									alluser["pic"][alluserCnt] = searchUser["pic"][i];
									alluser["description"][alluserCnt] = searchUser["description"][i];
									alluser["description2"][alluserCnt] = searchUser["description2"][i];
									alluser["temporder"][alluserCnt] = i;
									alluserCnt++;
								} else {
									// 참여자 중복 (팝업확인)
									overlapuser["userId"][overlapuserCnt] = searchUser["userId"][i];
									overlapuser["userName"][overlapuserCnt] = searchUser["userName"][i];
									overlapuser["userName2"][overlapuserCnt] = searchUser["userName2"][i];
									overlapuser["deptName"][overlapuserCnt] = searchUser["deptName"][i];
									overlapuser["pic"][overlapuserCnt] = searchUser["pic"][i];
									overlapuser["description"][overlapuserCnt] = searchUser["description"][i];
									overlapuser["description2"][overlapuserCnt] = searchUser["description2"][i];
									overlapuser["temporder"][overlapuserCnt] = i;
									overlapuser["usertype"][overlapuserCnt] = "";
									overlapuserCnt++;
								}
							} else {
								// 익명
								alluser["userId"][alluserCnt] = "";
								alluser["userName"][alluserCnt] = searchUser["userName"][i];
								alluser["userName2"][alluserCnt] = searchUser["userName"][i];
								alluser["description"][alluserCnt] = ""; 
								alluser["description2"][alluserCnt] = "";
								alluser["deptName"][alluserCnt] = "";
								alluser["pic"][alluserCnt] = "";
								alluser["temporder"][alluserCnt] = i;
								alluserCnt++;
							}
						}
						
						var onlyNameOLLen = serchNameOverlapUser["userId"].length;
						if(onlyNameOLLen > 1) {
							var idIndex;
							
							retAttendantPopInfo[0] = serchNameOverlapUser;
							retAttendantPopInfo[1] = firstPopupComp;
							
							$("#inputAttendant").blur();
							
							DivPopUpShow(380, 379, "/ezLadder/ladderPopup.do?popupType=overlapOnlyName");
							setFrameBlock(true);
						} else {
							showSecondOverlapPopup();
						}
						
						function firstPopupComp(retAttendants) {
							DivPopUpHidden();
							
							setFrameBlock(false);
							
							if(!!retAttendants) {
								var retLen = retAttendants["userId"].length;
								var i = 0;
								var removeIdx1;
								var removeIdx2;
								
								while(true) {
									removeIdx1 = alluser["deptName"].indexOf(retAttendants["deptName"][i]);
									if(removeIdx1 != -1) {
										alluser["userId"].splice(removeIdx1, 1);
										alluser["userName"].splice(removeIdx1, 1);
										alluser["userName2"].splice(removeIdx1, 1);
										alluser["deptName"].splice(removeIdx1, 1);
										alluser["pic"].splice(removeIdx1, 1);
										alluser["temporder"].splice(removeIdx1, 1);
										alluser["description"].splice(removeIdx1, 1);
										alluser["description2"].splice(removeIdx1, 1);
									} else {
										i++;
										if(!retAttendants["deptName"][i]) {
											break;
										}
									}
								}
								if(!!overlapuser["userId"].length) {
									i = 0;
									while(true) {
										removeIdx2 = overlapuser["deptName"].indexOf(retAttendants["deptName"][i]);
										if(removeIdx2 != -1) {
											overlapuser["userId"].splice(removeIdx2, 1);
											overlapuser["userName"].splice(removeIdx2, 1);
											overlapuser["userName2"].splice(removeIdx2, 1);
											overlapuser["deptName"].splice(removeIdx2, 1);
											overlapuser["pic"].splice(removeIdx2, 1);
											overlapuser["description"].splice(removeIdx2, 1);
											overlapuser["description2"].splice(removeIdx2, 1);
											overlapuser["temporder"].splice(removeIdx2, 1);
											overlapuser["usertype"].splice(removeIdx2, 1);
										} else {
											i++;
											if(!retAttendants["deptName"][i]) {
												break;
											}
										}
									}
								}
								
								showSecondOverlapPopup();
							}
						}
						
						function showSecondOverlapPopup() {
							if(!!overlapuser["userId"].length) {
								retAttendantPopInfo[0] = overlapuser;
								retAttendantPopInfo[1] = bindAllUser;
								
								DivPopUpShow(360, 185, "/ezLadder/ladderPopup.do?popupType=overlap");
								
								setFrameBlock(true);
							} else {
								bindAllUser(false);
							}
						}
					}
				} 
				
				function setFrameBlock(blockFlag) {
					var leftF = parent.frames["left"];
					var leftFBody = leftF.document.body;
					if(blockFlag) {
						//var leftH = leftF.document.getElementById("left").clientHeight > leftF.innerHeight ? leftF.document.getElementById("left").clientHeight + "px" : "100%";
						$(leftFBody).append("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%;position:absolute;top:" + $(leftF.document).scrollTop() + "px;z-index:10;background: rgba(0,0,0,0.5);'></div>");
						$("#mailPanel").css("top", $("html, body").scrollTop());
						
						// 프레임 스크롤바 제거 (윈도우 리사이즈시 하얀 화면 보이기때문) 
						$("body").css("overflow", "hidden");
						$(leftFBody).css("overflow", "hidden")
					} else {
						$(leftFBody).find("#blockLeft").remove();
						
						$("body").css("overflow", "auto");
						$(leftFBody).css("overflow", "auto")
					}
				}
				
				/** 이름 검색으로 중복 처리한 유저 포함하여 추가 */
				var bindAllUser;
				function bindAllUser(value, type) {
					DivPopUpHidden();
					
					setFrameBlock(false);
					if(value == "cancle") {
						return;
					}
					
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
						if(totalLen >= maxAttendant) {
							alert(maxAttendant + "<spring:message code='ezLadder.t048' />");
							break;
						}
						if(alluser["temporder"].indexOf(i) != -1) {
							if(!alluser["userId"][j]) {
								attendants["id"][totalLen] = "anonyAttendant_" + totalLen;
								alluser["userName2"][j] = alluser["userName"][j]
							} else {
								attendants["id"][totalLen] = alluser["userId"][j];
							}
							attendants["name"][totalLen] = alluser["userName"][j];
							attendants["name2"][totalLen] = alluser["userName2"][j];
							attendants["description"][totalLen] = alluser["description"][j];
							attendants["description2"][totalLen] = alluser["description2"][j];
							attendants["pic"][totalLen] = alluser["pic"][j];
							attendants["order"][totalLen] = totalLen;
							items[totalLen++] = "";
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
							attendants["description"][totalLen] = overlapuser["description"][k];
							attendants["description2"][totalLen] = overlapuser["description2"][k];
							attendants["pic"][totalLen] = overlapuser["pic"][k];
							attendants["order"][totalLen] = totalLen;
							items[totalLen++] = "";
							k++;
						}
					}
					
					setAttendantsView();
					if(ladderType == "0") {
						setBomb(ladderType);
					}
				}
			}
			
			/** 조직도, 이전 사다리에서 불러온 유저 추가 */
			function setAllUser_(userdata, addtype) {
				DivPopUpHidden();
				
				attendants = { "id": [], "name": [], "name2": [], "pic": [], "order": [], "description": [], "description2": [] };
				items = [];
				
				var userdataLen = userdata.length;
				userdata.forEach(function(line, idx) {
					attendants["id"][idx] = line["userId"];
					attendants["name"][idx] = line["userName"];
					attendants["name2"][idx] = line["userName2"];
					attendants["pic"][idx] = line["pic"];
					attendants["description"][idx] = line["description"];
					attendants["description2"][idx] = line["description2"];
					attendants["order"][idx] = idx;
					items[idx] = line["item"];
				});
				
				setAttendantsView();
				setLadderTypeDiv();
			}
			
			/** 화면에 참여자 나타내기 */
			function setAttendantsView() {
				var len = attendants["id"].length;
				var html = "";
				
				if(attendants !== null) {
					$("#attendantList").html("");
					$("#itemList").html("");
					$("#tempItemList").html("");
					
					for(var i = 0; i < len; i++) {
						var picsrc = "/images/ezLadder/icon_defaultAttendant.png";
						html = "";
						
						if(attendants["id"][i].substring(0, 14) === "anonyAttendant") {
							html += '<li class="attendant"><div style="height: 140px; padding-top:  20px;">';
							html += '<div class="userPicWraper"><img src="' + picsrc + '" width="48px" height="48px" /></div>';
							html += '<div style="margin-top: 10px;"><span>'
							html += '<input type="text" class="input" name="userNames" style="line-height: 30px;" id="userNames' + i + '" maxlength="' + maxname + '" /></span></div>';
							html += '<input type="text" name="userName2s" style="display: none;" />';
							html += '<input type="text" name="userIds" style="display: none;" />';
							html += '<input type="text" name="description2" style="display: none;" />';
							html += '<input type="text" name="description" style="display: none;" />';
							html += '<span><img id="removeIcon" src="/images/ezLadder/icon_removeAttendant.png" style="position: absolute; top: 20px; right: 15px; cursor: pointer;"></span></div></li>';
						} else {
							if(attendants["pic"][i] !== "") {
								picsrc = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + attendants["pic"][i];
							}
							
							html += '<li class="attendant"><div style="height: 140px; padding-top:  20px;">';
							html += '<div class="userPicWraper"><img src="' + picsrc + '" width="48px" height="48px" /></div>';
							html += '<div style="margin-top: 10px;"><span>'
							html += '<input type="text" class="input" readonly="readonly" name="userNames" style="line-height: 30px; background: rgb(244, 245, 245)" /></span></div>';
							html += '<input type="text" name="userName2s" style="display: none;" />';
							html += '<input type="text" name="userIds" style="display: none;" />';
							html += '<input type="text" name="description2" style="display: none;" />';
							html += '<input type="text" name="description" style="display: none;" />';
							html += '<span><img id="removeIcon" src="/images/ezLadder/icon_removeAttendant.png" style="position: absolute; top: 21px; right: 10px; cursor: pointer;"></span></div></li>';
						}
						
						$("#attendantList").append(html);
						
						var thisLi = "#attendantList li:eq(" + i + ")";
						$(thisLi + " input[name='userNames']").val(attendants["name"][i]);
						$(thisLi + " input[name='userName2s']").val(attendants["name2"][i]);
						$(thisLi + " input[name='userIds']").val(attendants["id"][i]);
						$(thisLi + " input[name='description2']").val(attendants["description2"][i]);
						$(thisLi + " input[name='description']").val(attendants["description"][i]);
						
						$("#itemList").append("<li class='item'><input type='text' class='input' name='items' id='items" + i + "' _itemindex='" + i + "' maxlength='" + maxitem + "' /></li>");
						$("#tempItemList").append("<li><input type='text' class='input tempItem' readonly='readonly' style='background: rgb(244, 245, 245)' value='?' /></li>");
						
						$("#items" + i).val(items[i]);
						
					}
					changeSliderValue();
					add_user_change_ulsize(len);
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
				if(!$("#title").val().trim()) {
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
				
				$("input[name='secretFlag']").val($("#ladderSecret .active").attr("_flag"));
				$("input[name='type']").val(ladderType);
				$("input[name='lineCnt']").val($("#custom-handle").text());
				//$("input[name='lineCnt']").val($("#amount").text());
				
				if($("#tempItemList").css("display") == "block") {
					var $items = $("input[name='items']");
					
					if(ladderType == "0") {
						items.forEach(function(item, i) {
							items[i] = i < bombnum ? strLang18 : strLang19;;
						});
					} else {
						items.forEach(function(item, i) {
							items[i] = i + 1;
						});
					}
					
					var temp;
					items.forEach(function(item, i) {
						var randomIdx = Math.floor(Math.random() * (items.length - 1));
						temp = item;
						items[i] = items[randomIdx]; 
						items[randomIdx] = temp;
					});
					
					$items.each(function(i, item) {
						item.value = items[i];
					});
				}
				window.parent.frames["left"].resetNodeSelected();
				$("#ladMakeForm").submit();
			} 
	
			function DivPopUpPosition(popUpW, popUpH) {
			    var ReturnValue = new Array();
			    var heigth = document.documentElement.clientHeight;
			    if (heigth == 0)
			        heigth = document.body.clientHeight;

			    var width = document.documentElement.clientWidth;
			    if (width == 0)
			        width = document.body.clientWidth;
				var tWidth = parent.document.documentElement.clientWidth;
				
				tWidth = tWidth - width;
				width = width - tWidth;
			   
			    var pleftpos;
			    pleftpos = parseInt(width) - popUpW;
			    heigth = parseInt(heigth) - popUpH;
			   
			    if (heigth < (popUpH + 50))
			        ReturnValue[0] = (heigth / 2);
			    else
			        ReturnValue[0] = (heigth / 2) - 50;
			    ReturnValue[1] = pleftpos / 2;
			    return ReturnValue
			}
			
			function DivPopUpShow(popUpW, popUpH, URL) {
			    try {
			        var Position = DivPopUpPosition(popUpW, popUpH);
			        document.getElementById("iFrameLayer").src = URL;
			        document.getElementById("iFramePanel").style.top = Position[0] + "px";
			        document.getElementById("iFramePanel").style.left = Position[1] + "px";
			        document.getElementById("iFramePanel").style.height = popUpH + "px";
			        document.getElementById("iFrameLayer").style.width = popUpW + "px";
			        document.getElementById("iFrameLayer").style.height = popUpH + "px";
			        document.getElementById("mailPanel").style.display = "";
			        document.getElementById("iFramePanel").style.display = "";
			    } catch (e) {}
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
			
			.ui-slider-handle {
				background: #ffffff repeat-x;
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
				background: #ffffff;
			}
			.default {
				border: 1px solid #dddddd; 
			}
			.typehover {
				background: #ddeeff;
			}
			.select {
				border: 1px solid #888; 
			}
			.typeOpbtn {
				display: inline-block;
				padding-top:7px;
				margin-left:3px;
				cursor: pointer;
				user-select: none;
			}
			.active {
				display: inline;
			}	
			#custom-handle {
				width: 3em;
				height: 1.6em;
				top: 50%;
				margin-top: -.8em;
				text-align: center;
				line-height: 1.6em;
				cursor: pointer;
			}	
			.ui-state-active, .ui-widget-content .ui-state-active, .ui-widget-header .ui-state-active {
				color: #000000;
				border: 1px solid #d8dcdf;
			}
			.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default {
				font-weight: normal;
			}
			.typeOpbtnCover {
				background: #f8f8f8;
				width: 35px;
				height: 35px;
				position: absolute;
				opacity: 0;
			}
			.colorOpHide {
				opacity: 0.8;
			}
			.moOverTooltip {
				position: absolute;
				background: #fff;
				z-index: 20;
				border: 1px solid #dddddd;
				padding: 0px 20px;
				display: none;
			}
		</style>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezLadder.t018" /></h1>
		<div class='moOverTooltip'></div>
		<form id="ladMakeForm" method="post" action="/ezLadder/setLadder.do" name="ladMakeForm">
			<table class="setTable" style="min-width: 1000px;">
				<tr>
					<td>
						<div style="height: 50px; line-height: 50px; margin-bottom: 10px; position: relative;">
							<div style="height: 50px;">
								<input type="text" class="input" name="title" id="title" style="height: 100%; width: 100%; padding-left:11px" placeholder="<spring:message code="ezLadder.t019"/>" maxlength="166"/>
								<div id="ladderPreList" style="top: 7px; right: 11px;"><img  title="<spring:message code='ezLadder.t079'/>" src="/images/ezLadder/icon_preLadder.png"/></div>
							</div>
							<input name="secretFlag" style="display: none;" />
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div style="height: 50px; margin-bottom: 10px;padding:5px;background-color: #f8f8f8;border:1px solid #e8e8ea;position: relative;">
							<div style="float: left;">
								<c:forEach begin="0" end="3" var="typenum">
									<div class="ladderType" _num="${typenum}">
										<img title="<spring:message code='ezLadder.t10${typenum + 1}'/>" src="/images/ezLadder/icon_game0${typenum}_no.png" class="default icon"/>
										<img title="<spring:message code='ezLadder.t10${typenum + 1}'/>" src="/images/ezLadder/icon_game0${typenum}.png" class="select icon"/>
										<img title="<spring:message code='ezLadder.t10${typenum + 1}'/>" src="/images/ezLadder/icon_game0${typenum}_hover.png" class="typehover icon"/>
									</div>
								</c:forEach>
								<div id="ladderTypeOption" style='float:right; margin-left: 30px; height: 50px;'></div>
								<input name="type" style="display: none;" />
							</div>														
							<div style="float: right;height:40px; line-height: 40px;margin-left:20px;margin-top:5px;">
								<img src="/images/line.png" style="vertical-align: middle;float: left;padding-top:8px" title="<spring:message code='ezLadder.t081'/>"/>								
								<!-- <div style="height: 40px; width: 40px; line-height:40px; border: 1px solid #dddddd; text-align: center; border-radius: 25px; float: left; margin-left: 3px; margin-right:15px; background-color: white">
									<span id="amount">0</span>
								</div> -->
								<div id="slider-range-min" style="width: 200px; top: 13px; float:left; margin-right:70px; margin-left: 15px;">
									<div id="custom-handle" class="ui-slider-handle"></div>
								</div>
								<input name="lineCnt" style="display: none;" />
							</div>
							<div style="float: right; height: 45px;line-height: 45px;margin-top: 2px;position: relative;">
								<input type="text" class="input" id="inputAttendant" style="height: 100%; width: 200px; margin-left:10px; padding-right: 45px;" placeholder="<spring:message code='ezLadder.t071' />"/>
								<div id="addAttendant" title="<spring:message code='ezLadder.t080'/>">
									<img src="/images/ezLadder/icon_addAtt_default.png" style="width: 30px;height: 30px;padding-top: 2px;padding-left: 2px;display: inline;" />
									<img src="/images/ezLadder/icon_addAtt_hover.png" style="width: 30px;height: 30px;padding-top: 2px;padding-left: 2px;display: none;" />
								</div>
							</div>
							<div id="ladderSecret" style="position: absolute; right: 5px;">
								<img src="/images/ezLadder/icon_public.png" title="<spring:message code='ezLadder.t007'/>" class="default icon" _flag="0"/>
								<img src="/images/ezLadder/icon_private.png" title="<spring:message code='ezLadder.t076'/>" class="select icon" _flag="1"/>
							</div>							
						</div>
					</td>
				</tr>
				<%-- <tr>
					<td>
						<div style="height:50px; margin-bottom: 25px; line-height: 50px;">
							<div style="height: 50px; width: 50px; border: 1px solid #dddddd; text-align: center; border-radius: 25px; float: left; margin-left: 5px;" title="<spring:message code='ezLadder.t081'/>">
								<span id="amount">0</span>
							</div>
							<div id="slider-range-min" style="width: 300px; top: 19px; left: 70px; margin: 0;"></div>
							<input name="lineCnt" style="display: none;" />
						</div>
					</td>
				</tr> --%>
				<tr>
					<td style="position: relative; margin-top: 20px;">
						<%-- <div id="addAttendant" class="icondiv" style="width: 50px; height: 50px; overflow: hidden; border: 1px solid #0470e4; border-radius: 15px; cursor: pointer;">
							<img src="/images/ezLadder/icon_addAttendant.png" style="padding-left: 1px; padding-top: 1px; display: block" title="<spring:message code='ezLadder.t080'/>"/>
							<img src="/images/ezLadder/icon_addAttendant_hover.png" style="padding-left: 1px; padding-top: 1px; display: none" title="<spring:message code='ezLadder.t080'/>"/>
						</div> --%>
						<div id="ladderLineBox" style="border: 1px solid #ddd; height: 450px; overflow-y: hidden; overflow-x: auto; min-width: 1000px;">
							<div style="height: 140px;">
								<ul id="attendantList"></ul>
							</div>
							<div id="lineDiv" style="position: relative; z-index: -1;">
								<canvas id='ladderCanvasLine' width='0' height='250'></canvas>
								<canvas id='ladderCanvas' width='0' height='250'></canvas>
							</div>
							<ul id="itemList" style="margin-top: 10px; height: 50px; display: block;"></ul>
							<ul id="tempItemList" style="margin-top: 10px; height: 50px; display: none;"></ul>
						</div>
					</td>
				</tr>
			</table>
			
			<div class="btnpositionJsp">
				<a class="imgbtn" id="makeLad"><span><spring:message code="ezLadder.t018"/></span></a>
				<a class="imgbtn" id="backToList"><span><spring:message code='ezLadder.t083' /></span></a>
			</div>
		</form>
		<div style="width: 100%; height: 100%; overflow: auto; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">
			<div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
				<iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
			</div>
		</div>
	</body>
</html>