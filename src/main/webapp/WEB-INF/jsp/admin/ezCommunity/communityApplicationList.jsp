<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
		.idSpan select {vertical-align: middle; height: 22px; margin-left: 2px;}
		.categorySpan {
			height: 18px; margin: 0px; padding: 0px 6px; line-height: 18px;
			text-align: center; background: #999; color: #ffffff; font-size: 12px;
			border-radius: 2px; -webkit-border-radius: 2px; -moz-border-radius: 2px; display: inline-block;
		}
		#mainListBody tr:hover {background-color: #f4f5f5;}
		#mainListBody tr td {overflow: hidden; white-space: nowrap; text-overflow: ellipsis; cursor:pointer;}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var lang = "<c:out value = '${lang}' />";
			var selectedTabId = "";
			var pCurPage      = 1;
			var pTotalPage    = 0;
			var pTotalCnt     = 0;
			var pBlockSize    = 10;
			var categoryColors = ["#ff6868", "#ff68c4", "#d668ff", "#a868ff", "#6f68ff", 
								"#3d78ff", "#4d8fcc", "#0dbeff", "#6dabad", "#4dc689", 
								"#81bc3d", "#ffc71e", "#ff8f1e", "#bd6438"];
			
			document.onselectstart = function () {
				if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
					return false;
				} else {
					return true;
				}
			};
			
			function keyword_onkeydown() {
				if (event.keyCode==13) {
					search();
					return false;
				}
				return true;
			}
			
			function search() {
				pCurPage    = 1;
				applicationCommuList();
			}
			
			window.onload = function () {
				applicationCommuList();
			};
			
			// (신청승인 / 폐쇄승인 ) 탭 이동 관련 이벤트
			function Tab1_NewTabIni(pTabNodeID) {
				var mainTabNode = document.getElementById(pTabNodeID);
				var nodeList    = mainTabNode.children;
				
				var length = nodeList.length;
				for (var i = 0; i < length; i++) {
					var pTagElmt    = nodeList[i];
					var spanTagElmt = pTagElmt.firstElementChild;
					
					spanTagElmt.onmouseover = function() {tab1_MouserOver(this);};
					spanTagElmt.onmouseout  = function() {tab1_MouserOut(this); };
					spanTagElmt.onclick     = function() {tab1_MouseClick(this);};
					
					if (i == 0) {spanTagElmt.className = "tabon"; selectedTabId = spanTagElmt.id;}
				}
			}
			
			function tab1_MouserOver(obj) {
				obj.className = "tabover";
			}
			
			function tab1_MouserOut(obj) {
				if (selectedTabId != obj.id) {
					obj.className = "";
				}
			}
			
			function tab1_MouseClick(obj) {
				obj.className = "tabon";
				var selectedTabElmt = document.getElementById(selectedTabId);
				
				if (obj.id != selectedTabId) {
					if (selectedTabId != "" && selectedTabElmt != null) {
						selectedTabElmt.className = "";
					}
					
					obj.className = "tabon";
					selectedTabId  = obj.id;
					ChangeTab(obj);
				}
			}
			
			function ChangeTab(obj) {
				document.getElementById("searchValue").value = "";
				document.getElementsByName("cCateA")[0].value = "0";
				
				/* 2020-01-03 홍승비 - 폐쇄신청 커뮤니티의 경우, 검색옵션으로 커뮤니티이름과 폐쇄사유를 사용 */
				var commuName = $("#searchType").find("option[value='C_ClubName']");
				var commuDesc = $("#searchType").find("option[value='C_ClubDesc']");
				var commuCR = $("#searchType").find("option[value='C_CloseReason']");
				
				/* 2020-05-25 홍승비 - IE 브라우저 대응 옵션값 추가, 제거로 변경 */
				if (selectedTabId == "closeCommu") { // 폐쇄승인

					 // 커뮤니티소개 제거
					if (commuDesc.length > 0) {
						commuDesc.remove();
					}
					 // 폐쇄사유 추가
					$("#searchType").append("<option value='C_CloseReason'><spring:message code = 'ezCommunity.t71' /></option>");
					
					commuName.attr("selected", true); // 커뮤니티이름 (default)
				} else { // 신청승인
					
					 // 폐쇄사유 제거
					if (commuCR.length > 0) {
						commuCR.remove();
					}
					 // 커뮤니티소개 추가
					$("#searchType").append("<option value='C_ClubDesc'><spring:message code = 'ezCommunity.t2008' /></option>");
					
					commuName.attr("selected", true); // 커뮤니티 이름 (default)
				}
				
				pCurPage = 1;
				applicationCommuList();
			}
			
			/* 2020-01-06 홍승비 - 커뮤니티소개 검색옵션 추가 */
			// (신청승인 / 폐쇄승인 ) 리스트 호출
			function applicationCommuList() {
				var url = (selectedTabId == "admitCommu" ? "/admin/ezCommunity/admitCom.do" : "/admin/ezCommunity/closeCom.do");
				var searchType2 = document.getElementById("searchType");
				
				$.ajax({
					type : "POST",
					dataType: "json",
					url : url,
					async : false,
					data : 
					{
						pageNum     : pCurPage,
						searchType  : document.getElementsByName("cCateA")[0].value, // 카테고리 종류
						searchType2  : searchType2.options[searchType2.selectedIndex].value, // 커뮤니티 검색옵션
						searchValue : make_searchstring(document.getElementById("searchValue").value), // 검색값
						companyID : encodeURIComponent(companySelectID)
					},
					success : function (data) {
						pCurPage   = data.pageNum;
						pTotalPage = data.totalPage;
						pTotalCnt  = data.totalCount;
						
						if (selectedTabId == "admitCommu") {
							document.getElementById("admitCommu").innerHTML = "<spring:message code = 'ezCommunity.t25' />&nbsp;&nbsp;" + "<span class='txt_color' style='border: 0px; margin: 0px; padding: 0px; font-weight: bold; float: right;'>" + pTotalCnt + "</span>";
							document.getElementById("closeCommu").innerHTML = "<spring:message code = 'ezCommunity.t39' />&nbsp;&nbsp;" + "<span class='txt_color' style='border: 0px; margin: 0px; padding: 0px; font-weight: bold; float: right;'>" + data.tabCount + "</span>";
						}
						else {
							document.getElementById("admitCommu").innerHTML = "<spring:message code = 'ezCommunity.t25' />&nbsp;&nbsp;" + "<span class='txt_color' style='border: 0px; margin: 0px; padding: 0px; font-weight: bold; float: right;'>" + data.tabCount + "</span>";
							document.getElementById("closeCommu").innerHTML = "<spring:message code = 'ezCommunity.t39' />&nbsp;&nbsp;" + "<span class='txt_color' style='border: 0px; margin: 0px; padding: 0px; font-weight: bold; float: right;'>" + pTotalCnt + "</span>";
						}
						
						var html = "";
						
						if (pTotalCnt < 1) {
							html += "<tr>";
							html += "    <td colspan='5' style='text-align:center;'><spring:message code = 'main.t00026' /></td>"
							html += "</tr>";
						}
						else {
							var itemNum = ((pCurPage - 1) * 10) + 1;
							
							data.clubList.forEach(function(item, index){
								html += "<tr ondblclick=open_info('" + item.c_ClubNo + "')>";
								html += "<td style='width: 35px;'>" + itemNum +"</td>";
								html += "<td style='width: 105px;'>" + getCategorySpan(item.c_name) + "</td>";
								html += "<td style='width: 21%;'>" + MakeXMLString(item.c_ClubName) +"</td>";
								
								if (item.c_ClubConfirmType == "2") { //유형
									html += "<td style='width: 10%;'><spring:message code = 'ezCommunity.t13' /></td>";
								} else {
									html += "<td style='width: 10%;'><spring:message code = 'ezCommunity.t14' /></td>";
								}

								if (item.c_ClubGubun == "2") { //공개여부
									html += "<td style='width: 10%;'><spring:message code = 'ezCommunity.t66' /></td>";
								} else {
									html += "<td style='width: 10%;'><spring:message code = 'ezCommunity.t67' /></td>";
								}
								
								html += "<td style='width: 10%;'>" + item.userName + "(" + item.c_SysopID + ")" +"</td>";
								
								if (selectedTabId == "admitCommu") {
									html += "<td style='width: 7%;'>" + item.c_RegDate.substring(0, 10) +"</td>";
									html += "<td style='width: 100px;'>";
									html +=     "<a class='imgbtn imgbck' style='margin-right: 3px;'><span onclick=admitBtnClick('" + item.c_ClubNo + "')><spring:message code = 'ezCommunity.t46' /></span></a>";
									html +=     "<a class='imgbtn imgbck'><span onclick=admitRefusalBtnClick('" + item.c_ClubNo + "')><spring:message code = 'ezCommunity.t44' /></span></a>";
									html += "</td>";
								}
								else {
									html += "<td style='width: 7%;'>" + item.applicationDate.substring(0, 10) +"</td>";
									html += "<td style='width: 100px;'><a class='imgbtn imgbck'><span onclick=closeBtnClick('" + item.c_ClubNo + "')><spring:message code = 'ezCommunity.t46' /></span></a></td>";
								}
								
								html += "</tr>";
							
								itemNum++;
							});
						}
						
						$("#mainListBody").empty().append(html);
						
						makePageSelPage();
						scroll();
					},
					error : function(e) {
						console.log("error");
					}
				});
			}
			
			// 페이지네이션 
			function td_Create1(strtext) {
				document.getElementById("tblPageRayer").innerHTML = strtext;
			}
			
			function makePageSelPage() {
				document.getElementById("tblPageRayer").innerHTML = "";
				
				var strtext = "<div class='pagenavi'>";
				var PagingHTML = "";
				
				PagingHTML += strtext;
				var pageNum = pCurPage;
				
				if (pTotalPage > 1 && pageNum != 1) {
					strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg first disabled'></span>";
					PagingHTML += strtext;
				}
				
				if (pTotalPage > pBlockSize) {
					if (pageNum > pBlockSize) {
						strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span class='btnimg prev disabled'></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "<span class='btnimg prev disabled'></span>";
					PagingHTML += strtext;
				}
				
				var MaxNum;
				var i;
				var startNum = (parseInt((pageNum - 1) / pBlockSize) * pBlockSize) + 1;
				
				if (pTotalPage >= (startNum + parseInt(pBlockSize))) {
					MaxNum = (startNum + parseInt(pBlockSize)) - 1;
				} else {
					MaxNum = pTotalPage;
				}
				
				for (i = startNum; i <= MaxNum; i++) {
					if (i == pageNum) {
						strtext = "<span class='on'>" + i + "</span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
						PagingHTML += strtext;
					}
				}
				
				if (MaxNum == 0) {
					PagingHTML += "<span class=\"on\">" + 1 + "</span>";
				}
				
				if (pTotalPage > pBlockSize) {
					if (pTotalPage >= parseInt(((parseInt((pageNum - 1) / pBlockSize) + 1) * pBlockSize) + 1)) {
						strtext = "";
						strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
						PagingHTML += strtext;
					} else {
						strtext = "";
						strtext = strtext + "<span class='btnimg next disabled'></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "";
					strtext = strtext + "<span class='btnimg next disabled'></span>";
					PagingHTML += strtext;
				}
				
				if (pTotalPage > 1 && pTotalPage != 1 && (pTotalPage != pageNum)) {
					strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + pTotalPage + ")'></span>";
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg last disabled'></span>";
					PagingHTML += strtext;
				}
				
				PagingHTML += "</div>";
				td_Create1(PagingHTML);
			}
			
			function goToPageByNum(Value) {
				pCurPage = Value;
				applicationCommuList();
			}
			
			function selbeforeBlock() {
				var pageNum = parseInt(pCurPage);
				pageNum = ((parseInt(pageNum / pBlockSize) - 1) * pBlockSize) + 1;
				goToPageByNum(pageNum);
			}
			
			function selbeforeBlock_one() {
				var pageNum = parseInt(pCurPage);
				
				if (parseInt(pageNum - 1) > 0) {
					goToPageByNum(parseInt(pageNum - 1));
				} else {
					return;
				}
			}
			
			function selafterBlock() {
				var pageNum = parseInt(pCurPage);
				pageNum = ((parseInt((pageNum - 1) / pBlockSize) + 1) * pBlockSize) + 1;
				goToPageByNum(pageNum);
			}
			
			function selafterBlock_one() {
				var pageNum = parseInt(pCurPage);
				
				if( parseInt(pageNum + 1) <= pTotalPage) {
					goToPageByNum(parseInt(pageNum + 1));
				} else {
					return;
				}
			}
			
			//2018-08-06 김보미 - 페이지 위치 고정
			$(window).on("resize", function(){
				windowResize();
			});
			
			// 페이지 스크롤 메소드
			function scroll() {
				var headerWidth = document.getElementById("mainListHeader").clientWidth;
				var bodyWidth   = document.getElementById("mainListBody").clientWidth;
				var scrollWidth = headerWidth - bodyWidth;
				
				var scrollElmt = document.getElementById("forScroll");
				if (scrollElmt) {
					scrollElmt.parentNode.removeChild(scrollElmt);
				}
				
				if (scrollWidth > 0) {
					var headerTr = document.getElementById("mainListHeaderTr");
					var thElmt   = document.createElement("th");
					thElmt.setAttribute("id", "forScroll");
					thElmt.style.width = "8px";
					
					headerTr.appendChild(thElmt);
				}
			}
			
			function windowResize() {
				/* var height = document.documentElement.clientHeight - 202;
				if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
					height = height - 30;
				}
					document.getElementById("contentlist").style.height = height + "px";
					document.getElementById("contentlist").style.overflow = "auto"; */
				
				document.getElementById("ListBody").style.height = (document.documentElement.clientHeight - 250) + "px"; 
				scroll();
			}
			
			$(function(){
				windowResize();
			});
			
			// 커뮤니티 정보 팝업 메소드
			var infoPopup;
			function open_info(code) {
				closeInfoPopup();
				
				if (CrossYN() && new RegExp(/Chrome/).test(navigator.userAgent)) {
					var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=auto,resizable=0,width=550,height=395";
					feature = feature + GetOpenPosition(550, 395);
				} else {
					var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=auto,resizable=0,width=550,height=390";
					feature = feature + GetOpenPosition(550, 390);
				}
				
				if (selectedTabId == "admitCommu") {
					infoPopup = window.open("/admin/ezCommunity/commInfo.do?code=" + code + "&type=New&title=" + encodeURI("<spring:message code = 'ezCommunity.t24' />") + "", "", feature);
				}
				else {
					infoPopup = window.open("/admin/ezCommunity/commInfo.do?code=" + code + "&type=Del&title=" + encodeURI("<spring:message code = 'ezCommunity.t38' />") + "", "", feature);
				}
			}
			
			// 커뮤니티 정보 팝업 닫기 메소드
			function closeInfoPopup() {
				if (infoPopup) { infoPopup.close(); }
			}
			
			// 신청승인 리스트 승인버튼 이벤트 메소드
			function admitBtnClick(code) {
				closeInfoPopup();
				
				setTimeout(function() {
					if (confirm("<spring:message code = 'ezCommunity.t61' />")) {
						$.ajax({
							type : "GET",
							dataType : "json",
							url : "/admin/ezCommunity/commAdmitOk.do",
							async : false,
							data : 
								{
									type : "listBtn",
									code : code,
									pDivi: "AdmitOK",
								},
							success : function(result) {
								alert(result.diviTitle);
								
								var rowCount = document.getElementById("mainListBody").rows.length;
								if (((rowCount - 1 ) == 0) && pCurPage > 1) {
									pCurPage = pCurPage - 1;
								}
								
								applicationCommuList();
								window.parent.parent.frames[0].getApplicationListCount();
							},
							error : function(e) {
								console.log("error");
							}
						});
					}
				}, 100);
			}
			
			// 신청승인 리스트 거부버튼 이벤트 메소드
			function admitRefusalBtnClick(code) {
				closeInfoPopup();
				
				setTimeout(function() {
					if (confirm("<spring:message code = 'ezCommunity.t63' />")) {
						$.ajax({
							type : "GET",
							dataType : "json",
							url : "/admin/ezCommunity/commAdmitOk.do",
							async : false,
							data : 
								{
									type : "listBtn",
									code : code,
									pDivi: "AdmitCancel",
								},
							success : function(result) {
								alert(result.diviTitle);
								
								var rowCount = document.getElementById("mainListBody").rows.length;
								if (((rowCount - 1 ) == 0) && pCurPage > 1) {
									pCurPage = pCurPage - 1;
								}
								
								applicationCommuList();
								window.parent.parent.frames[0].getApplicationListCount();
							},
							error : function(e) {
								console.log("error");
							}
						});
					}
				}, 100);
			}
			
			// 폐쇄승인 리스트 승인 버튼 이벤트 메소드
			function closeBtnClick(code) {
				
				/* 2020-05-22 홍승비 - 관리자의 커뮤니티 폐쇄와 폐쇄 승인 시 메세지를 분리 */
				if (confirm("<spring:message code = 'ezCommunity.hsbAd01' />")) {
					$.ajax({
						type : "GET",
						dataType : "json",
						url : "/admin/ezCommunity/commCloseAll.do",
						async : false,
						data : 
							{
								type : "listBtn",
								code : code
							},
						success : function(result) {
							alert("<spring:message code = 'ezCommunity.t56' />");
							
							var rowCount = document.getElementById("mainListBody").rows.length;
							if (((rowCount - 1 ) == 0) && pCurPage > 1) {
								pCurPage = pCurPage - 1;
							}
							
							applicationCommuList();
							window.parent.parent.frames[0].getApplicationListCount();
						},
						error : function(e) {
							console.log("error");
						}
					});
				}
			}
			
			// 카테고리 요소 생성
			function getCategorySpan(cateName) {
				var retVal = "";
				
				switch(cateName){
					case "t1496":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[0] + "'><spring:message code = 'ezCommunity.t1496' />";
						break;
					case "t1497":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[1] + "'><spring:message code = 'ezCommunity.t1497' />";
						break;
					case "t1498":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[2] + "'><spring:message code = 'ezCommunity.t1498' />";
						break;
					case "t1499":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[3] + "'><spring:message code = 'ezCommunity.t1499' />";
						break;
					case "t1500":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[4] + "'><spring:message code = 'ezCommunity.t1500' />";
						break;
					case "t1501":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[5] + "'><spring:message code = 'ezCommunity.t1501' />";
						break;
					case "t1502":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[6]  + "'><spring:message code = 'ezCommunity.t1502' />";
						break;
					case "t1503":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[7]  + "'><spring:message code = 'ezCommunity.t1503' />";
						break;
					case "t1504":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[8] + "'><spring:message code = 'ezCommunity.t1504' />";
						break;
					case "t1505":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[9] + "'><spring:message code = 'ezCommunity.t1505' />";
						break;
					case "t1506":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[10] + "'><spring:message code = 'ezCommunity.t1506' />";
						break;
					case "t1507":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[11] + "'><spring:message code = 'ezCommunity.t1507' />";
						break;
					case "t1508":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[12] + "'><spring:message code = 'ezCommunity.t1508' />";
						break;
					case "t1509":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[0] + "'><spring:message code = 'ezCommunity.t1509' />";
						break;
					case "t1510":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[0] + "'><spring:message code = 'ezCommunity.t1510' />";
						break;
					case "t1511":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[0] + "'><spring:message code = 'ezCommunity.t1511' />";
						break;
					case "t1512":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[0] + "'><spring:message code = 'ezCommunity.t1512' />";
						break;
					case "t1513":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[0] + "'><spring:message code = 'ezCommunity.t1513' />";
						break;
					case "t1514":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[0] + "'><spring:message code = 'ezCommunity.t1514' />";
						break;
					case "t1515":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[0] + "'><spring:message code = 'ezCommunity.t1515' />";
						break;
					case "t1516":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[0] + "'><spring:message code = 'ezCommunity.t1516' />";
						break;
					case "t1517":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[0] + "'><spring:message code = 'ezCommunity.t1517' />";
						break;
					case "t1518":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[13] + "'><spring:message code = 'ezCommunity.t1518' />";
						break;
					case "t1519":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[0] + "'><spring:message code = 'ezCommunity.t1519' />";
						break;
				}
				
				retVal += "</span>";
				
				return retVal;
			}

			function changeCompany() {
				document.getElementById("searchValue").value = "";
				applicationCommuList();
			}

		</script>
	</head>
<body class="mainbody">
	<h1><spring:message code = 'ezCommunity.khj06' />
		<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp"/>
	</h1>
	
	<div class="portlet_tabpart01">
		<div class="portlet_tabpart01_top" id="tab1">
			<p><span id="admitCommu"><spring:message code = 'ezCommunity.t25' /></span></p>
			<p><span id="closeCommu"><spring:message code = 'ezCommunity.t39' /></span></p>
		</div>
	</div>
	<script type="text/javascript">
		Tab1_NewTabIni("tab1");
	</script>
	
	<table class="content" style="margin: 10px 0px;">
		<tr>
			<th style="background-color: #f1f3f5; border: 1px solid #e2e3e6;"><spring:message code = 'ezCommunity.t1431' /></th>
			<td style="border: 1px solid #e2e3e6;">
				<span id="idSpan" class="idSpan">${idSpanValue}</span>
				<select id="searchType" name="QuerySelect" style="vertical-align: middle; height: 22px;">
					<option selected value="C_ClubName"><spring:message code = 'ezCommunity.t9991' /></option>
					<%-- 2020-01-06 홍승비 - 커뮤니티소개, 폐쇄사유 검색옵션 추가 (2020-05-25 홍승비 - 폐쇄사유 옵션 동적 추가/제거 형식으로 변경) --%>
					<option value="C_ClubDesc"><spring:message code = 'ezCommunity.t2008' /></option>
				</select>
						
				<input name="text" type="text" style="WIDTH:200px; vertical-align:middle; height: 25px;" id="searchValue" onkeydown="return keyword_onkeydown()"> 
				<a class="imgbtn imgbck" style="vertical-align: middle; margin-bottom:0px;"><span onClick="search()"><spring:message code = 'ezCommunity.t31' /></span></a>
			</td>
		</tr>
	</table>
	
	<div id="contentlist" style="width: 100%; overflow: hidden; margin-top: 5px;">
		<div id="ListHeader">
			<table id="mainListHeader" class="mainlist" style="width: 100%">
				<tr id="mainListHeaderTr">
					<th style="width: 35px;"><spring:message code = 'ezCommunity.t32' /></th>
					<th style="width: 105px;"><spring:message code = 'ezCommunity.t11' /></th>
					<th style="width: 21%;"><spring:message code = 'ezCommunity.t9991' /></th>
					<th style="width: 10%;"><spring:message code = 'ezCommunity.t65' /></th>
					<th style="width: 10%;"><spring:message code = 'ezCommunity.t15' /></th>
					<th style="width: 10%;"><spring:message code = 'ezCommunity.t33' /></th>
					<th style="width: 7%;"><spring:message code = 'ezCommunity.t550' /></th>
					<th style="width: 100px;"></th>
				</tr>
			</table>
		</div>
		<div id="ListBody" style="height: 341px; overflow-y: auto;">
			<table id="mainListBody" class="mainlist" style="width: 100%"></table>
		</div>
	</div>
	
	<div id="tblPageRayer"></div>
</body>
</html>