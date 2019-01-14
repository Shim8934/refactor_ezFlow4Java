<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezCommunity.i1', 'msg')}" type="text/css">
		<style>
		.idSpan select {vertical-align: middle; height: 22px; margin-left: 2px;}
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
			var pSearchType   = "";
			
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
				pSearchType = document.getElementById("searchType").value;
				pCurPage    = 1;
				applicationCommuList();
			}
			
			$(document).ready(function() {
				applicationCommuList();
			});
			
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
				
				pSearchType = "";
				pCurPage = 1;
				applicationCommuList();
			}
			
			// (신청승인 / 폐쇄승인 ) 리스트 호출
			function applicationCommuList() {
				
				pSearchType = (pSearchType != "" ? pSearchType + lang : pSearchType); 
				var url = (selectedTabId == "admitCommu" ? "/admin/ezCommunity/admitCom.do" : "/admin/ezCommunity/closeCom.do");
				
				$.ajax({
					type : "POST",
					dataType: "json",
					url : url,
					async : false,
					data : 
					{
						pageNum     : pCurPage,
						searchType  : pSearchType,
						searchValue : make_searchstring(document.getElementById("searchValue").value)
					},
					success : function (data) {
						pCurPage   = data.pageNum;
						pTotalPage = data.totalPage;
						pTotalCnt  = data.totalCount;
						
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
								html += "<td width='35px;'>" + itemNum +"</td>";
								html += "<td width='50%;'>" + item.c_ClubName +"</td>";
								html += "<td width='10%;'>" + item.userName +"</td>";
								
								if (selectedTabId == "admitCommu") {
									html += "<td width='10%;'>" + item.c_RegDate.substring(0, 10) +"</td>";
								}
								else {
									html += "<td width='10%;'>" + item.applicationDate.substring(0, 10) +"</td>";
								}
								
								html += "</tr>";
							
								itemNum++;
							});
						}
						
						$("#mainListBody").empty().append(html);
						makePageSelPage();
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
				document.getElementById("TitleInfo").innerHTML = "&nbsp;&nbsp;<span style='color:#017BEC;font-weight:bold;'>" + pTotalCnt + "</span>";
				
				var strtext = "<div class='pagenavi'>";
				var PagingHTML = "";
				
				PagingHTML += strtext;
				var pageNum = pCurPage;
				
				if (pTotalPage > 1 && pageNum != 1) {
					strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' ></span>";
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif'></span>";
					PagingHTML += strtext;
				}
				
				if (pTotalPage > pBlockSize) {
					if (pageNum > pBlockSize) {
						strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif'></span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif'></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif'></span>";
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
						strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif'></span>";
						PagingHTML += strtext;
					} else {
						strtext = "";
						strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "";
					strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif'></span>";
					PagingHTML += strtext;
				}
				
				if (pTotalPage > 1 && pTotalPage != 1 && (pTotalPage != pageNum)) {
					strtext = "<span class='btnimg' onclick='return goToPageByNum(" + pTotalPage + ")'><img src='/images/sub/btn_n_next.gif'></span>";
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif'></span>";
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
			
			function windowResize() {
			var height = document.documentElement.clientHeight - 172;
			if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
				height = height - 30;
			}
				document.getElementById("contentlist").style.height = height + "px";
				document.getElementById("contentlist").style.overflow = "auto";
			}
			
			$(function(){
				windowResize();
			});
			
			// 커뮤니티 정보 팝업 메소드
			function open_info(code) {
				if (CrossYN() && new RegExp(/Chrome/).test(navigator.userAgent)) {
					var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=auto,resizable=0,width=510,height=395";
					feature = feature + GetOpenPosition(510, 395);
				} else {
					var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=auto,resizable=0,width=490,height=375";
					feature = feature + GetOpenPosition(490, 375);
				}
				
				if (selectedTabId == "admitCommu") {
					comm = window.open("/admin/ezCommunity/commInfo.do?code=" + code + "&type=New&title=" + encodeURI("<spring:message code = 'ezCommunity.t24' />") + "", "", feature);
				}
				else {
					comm = window.open("/admin/ezCommunity/commInfo.do?code=" + code + "&type=Del&title=" + encodeURI("<spring:message code = 'ezCommunity.t38' />") + "", "", feature);
				}
			}
		</script>
	</head>
<body class="mainbody">
	<h1>커뮤니티 신청관리<span id="TitleInfo"></span></h1>
	<table class="content">
		<tr>
			<th>검색조건</th>
			<td>
				<span id="idSpan" class="idSpan">${idSpanValue}</span>
				<select id="searchType" name="QuerySelect" style="vertical-align: middle; height: 22px;">
					<option selected value="C_ClubName"><spring:message code = 'ezCommunity.t9991' /></option>
				</select>
						
				<input name="text" type="text" style="WIDTH:200px; vertical-align:middle; height: 22px;" id="searchValue" onkeydown="return keyword_onkeydown()"> 
				<a class="imgbtn" style="vertical-align: middle; margin-bottom:0px;"><span onClick="search()"><spring:message code = 'ezCommunity.t31' /></span></a>
			</td>
		</tr>
	</table>
	<div class="portlet_tabpart01">
		<div class="portlet_tabpart01_top" id="tab1">
			<p><span id="admitCommu">신청승인</span></p>
			<p><span id="closeCommu">폐쇄승인</span></p>
		</div>
	</div>
	
	<script type="text/javascript">
		Tab1_NewTabIni("tab1");
	</script>
	
	<div id="contentlist" style="width: 100%; overflow: auto; margin-top: 5px;">
		<div id="ListHeader">
			<table id="mainListHeader" class="mainlist" style="width: 100%">
				<tr id="mainListHeaderTr">
					<th style="width: 35px;"><spring:message code = 'ezCommunity.t32' /></th>
					<th style="width: 50%;"><spring:message code = 'ezCommunity.t9991' /></th>
					<th style="width: 10%;"><spring:message code = 'ezCommunity.t33' /></th>
					<th style="width: 10%;">신청일</th>
				</tr>
			</table>
		</div>
		<div id="ListBody">
			<table id="mainListBody" class="mainlist" style="width: 100%"></table>
		</div>
	</div>
	
	<div id="tblPageRayer"></div>
</body>
</html>