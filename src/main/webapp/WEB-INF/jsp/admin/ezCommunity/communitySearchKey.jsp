<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezCommunity.i1', 'msg')}" type="text/css">
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
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			var selectedTabId = "";
			
			var pCurPage     = 1;
			var pTotalPage   = 0;
			var pTotalCnt    = 0;
			var pBlockSize   = 10;
			
			var categoryColor  = "";
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
			
			$(document).ready(function() {
				communityList();
			});
			
			function view_CommunityInfo(pcode) {
 				var pheight = window.screen.availHeight;
				var pwidth = window.screen.availWidth;
				var pTop = (pheight - 430) / 2;
				var pLeft = (pwidth - 500) / 2; 
				window.open("/admin/ezCommunity/admCommunityInfoEdit.do?code=" + pcode, "", "location=1,toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=390,width=480,top=" + pTop + ",left=" + pLeft, "");
			}
			
			/* function prevPage_onclick() {
				newPage = parseInt(pCurPage) - 1;
				
				if(newPage > 0) {
					window.location.href = "/admin/ezCommunity/searchKey.do?select=${select}&query=" + encodeURIComponent('${query}') + "&page=" + newPage.toString();
				}
			}
	
			function nextPage_onclick() {
				newPage = parseInt(pCurPage) + 1;
				
				if(newPage <= parseInt(pTotalPage)) {
					window.location.href = "/admin/ezCommunity/searchKey.do?select=${select}&query=" + encodeURIComponent('${query}') + "&page=" + newPage.toString();
				}
			} 
	
			function moveToPage(pCurPage) {
	            if(parseInt(pCurPage) > 0 && parseInt(pCurPage) <= parseInt(pTotalPage)) {
					window.location.href = "/admin/ezCommunity/searchKey.do?select=${select}&query=" + encodeURIComponent('${query}') + "&page=" + pCurPage;
				}
			} */
			
			function get_search_CommunityInfo(e) {
			    var kecode = e.keyCode;
			    
			    if (kecode == 13) {
			        search_CommunityInfo();
	
			        return false;
			    }
			    return true;
			}
			
			function search_CommunityInfo() {
				var strSelect = document.getElementById("QuerySelect").value;
				var strQuery = document.getElementById("txt_SearchQuery").value;
				
				if(strQuery == "") {
					//2016-07-13 이효진 OpenAlertUI화면 alert로 대체
 					//OpenAlertUI("<spring:message code = 'ezCommunity.t75' />");
					alert("<spring:message code = 'ezCommunity.t75' />");
					return;
				}
				
				//window.location.href = "/admin/ezCommunity/searchKey.do?select=" + encodeURIComponent(strSelect) + "&query=" + encodeURIComponent(strQuery);
				communityList();
			}
			
			/* 2018-07-18 홍승비 - 관리자단 커뮤니티 마스터 사원정보 겸직에 대응 가능하도록 수정, 스크립트 오류 수정(.js import) */
			function openinfo_userinfo(pCN, pDept) {
			    var feature = "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,width=420,height=438";
			    feature = feature + GetOpenPosition(420, 438);
			    window.open("/ezCommon/showPersonInfo.do?id=" + pCN + "&dept=" + pDept, "", feature);
			}
			
			// (개설된 커뮤니티 / 폐쇄한 커뮤니티 ) 탭 이동 관련 이벤트
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
				document.getElementById("txt_SearchQuery").value = "";
				pCurPage = 1;
				communityList();
			}
			
			// (개설된 커뮤니티 / 폐쇄한 커뮤니티 ) 리스트 호출
			function communityList() {
				$.ajax({
					type : "POST",
					dataType: "json",
					url : "/admin/ezCommunity/communityList.do",
					async : false,
					data : 
					{
						type        : selectedTabId,
						pageNum     : pCurPage,
						searchType  : document.getElementById("QuerySelect").value,
						searchValue : document.getElementById("txt_SearchQuery").value 
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
							var itemNum = ((pCurPage - 1) * 10) + 1 ;
							
							data.clubList.forEach(function(item, index){
								html += "<tr ondblclick=view_CommunityInfo('" + item.c_ClubNo  + "');>";
								html += "<td style='width: 35px;'>" + itemNum + "</td>";
								html += "<td style='width: 35px;'>" + item.c_MemberCnt +"</td>";
								html += "<td style='width: 65px;'>" + item.itemCnt + "</td>";
								html += "<td style='width: 90px;'>" + getCategoryName(item.c_name) + "</td>";
								html += "<td style='width: 25%;'>" + item.c_ClubName + "</td>";
								
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
								
								html += "<td style='width: 10%;'>" + item.userName + "</td>"; //마스터이름
								html += "<td style='width: 10%;'>"  + item.c_RegDate.substring(0, 10) + "</td>"; //생성일
								html += "<td style='width: 60px;'><a class='imgbtn imgbck'><span onclick=''>폐쇄</span></a></td>";
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
				communityList();
				//makePageSelPage();
				//moveToPage(pCurPage);
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
			
			// 카테고리 요소 생성
			function getCategoryName(cateName) {
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
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[0] + "'><spring:message code = 'ezCommunity.t1518' />";
						break;
					case "t1519":
						retVal = "<span class='categorySpan' style='background-color:" + categoryColors[0] + "'><spring:message code = 'ezCommunity.t1519' />";
						break;
				}
				
				retVal += "</span>";
				
				return retVal;
			}
			
		</script>
	</head>
	<body class="mainbody" onload = "makePageSelPage()">
		<h1>커뮤니티 관리<span id="TitleInfo"></span></h1>
		<form name="adm_search_key" method="post" ID="Form1">
	    	<table class="content">
				<tr>
					<th>검색조건</th>
					<td>
						<span id="idSpan" class="idSpan">${idSpanValue}</span>
						
						<select id="QuerySelect" name="QuerySelect" style="vertical-align: middle; height: 22px;">
							<option selected value="pCommunityName"><spring:message code = 'ezCommunity.t9991' /></option>
							<%-- <option value="pCommuintyDesc" ><spring:message code = 'ezCommunity.t1529' /> <spring:message code = 'ezCommunity.t18' /></option> --%>
						</select>
						
						<input name="text" type="text" style="WIDTH:200px; vertical-align:middle; height: 22px;" id="txt_SearchQuery" onKeyPress="return get_search_CommunityInfo(event)"> 
						<a class="imgbtn" style="vertical-align: middle; margin-bottom:0px;"><span onClick="search_CommunityInfo()"><spring:message code = 'ezCommunity.t31' /></span></a>
			  		</td>
				</tr>
			</table>
		
			<%--<div class="page">
			<img src="/images/page_previous.gif" width="15" height="16" align="absmiddle" id="td_Previous"  onClick="prevPage_onclick()">
			<spring:message code = 'ezCommunity.t76' /><span>${ iTotalPage }</span>&nbsp;&nbsp;<spring:message code = 'ezCommunity.t77' />
			<input type="text" id="txt_inputPageNum" style="WIDTH:35px" value='${ iPage }' onKeyDown="moveToPage()">
			<img src="/images/page_next.gif" width="15" height="16" align="absmiddle" id="Img1"  onClick="nextPage_onclick()"></div>--%>
			
			<div class="portlet_tabpart01">
				<div class="portlet_tabpart01_top" id="tab1">
					<p><span id="tagsub1">개설된 커뮤니티</span></p>
					<p><span id="tagsub2">폐쇄한 커뮤니티</span></p>
				</div>
			</div>
			<script type="text/javascript">
				Tab1_NewTabIni("tab1");
			</script>
			
			<%-- <div id="contentlist" style="width:100%; overflow: auto; margin-top:5px;">
				<div>
					<table id="mainlist" class="mainlist" style="width:100%">
						<tr>
							<th style="width:70px; height:23px"><spring:message code = 'ezCommunity.t32' /></th>
							<th style="width:250px;"><spring:message code = 'ezCommunity.t9991' /></th>
							<th><spring:message code = 'ezCommunity.t1529' /> <spring:message code = 'ezCommunity.t18' /></th>
							<th style="width:100px;"><spring:message code = 'ezCommunity.t33' /></th>
							<th style="width:80px;"><spring:message code = 'ezCommunity.t78' /></th>
						</tr>
						<c:if test="${clubList ne null && clubList ne ''}">
							<c:forEach var = "club" items = "${clubList }" varStatus="status">
								<tr>
									<td style="width:50px; height:23px"><c:out value='${totalCount - ((curPage -1) * 10) - status.index }' /></td>
									<!--// 20100108 : 보안 처리, 관련 추가작업(XSS)-->
									<td style="cursor:pointer; text-overflow:ellipsis; white-space:nowrap; overflow:hidden" onClick="view_CommunityInfo('${club.c_ClubNo}')"><nobr ><c:out value = '${club.c_ClubName }' /></nobr></td>
									<td style="cursor:pointer; width:300px; text-overflow:ellipsis; white-space:nowrap; overflow:hidden" onClick="view_CommunityInfo('${club.c_ClubNo}')"><c:out value = '${club.c_ClubDesc}' /></td>
									<td style="cursor:pointer; width:80px" onClick="openinfo_userinfo('${club.c_SysopID}',  '${club.deptID}')"><c:out value = '${club.userName}' /></td>
									<td style="width:80px"><c:out value = '${fn:substring(club.c_RegDate, 0, 10) }' /></td>
								</tr>
							</c:forEach>
						</c:if>
						<c:if test="${clubList eq null || clubList eq ''}">
							<tr>
								<td colspan="5" style="text-align:center;"><spring:message code = 'main.t00026' /></td>
							</tr>
						</c:if>
					</table>
				</div>
			</div> --%>
			
			<div id="contentlist" style="width: 100%; overflow: auto; margin-top: 5px;">
				<div id="ListHeader">
					<table id="mainListHeader" class="mainlist" style="width: 100%">
						<tr id="mainListHeaderTr">
							<th style="width: 35px; height:23px"><spring:message code = 'ezCommunity.t32' /></th>
							<th style="width: 35px;">인원</th>
							<th style="width: 65px;">게시갯수</th>
							<th style="width: 90px;">카테고리</th>
							<th style="width: 25%;"><spring:message code = 'ezCommunity.t9991' /></th>
							<th style="width: 10%;">유형</th>
							<th style="width: 10%;">공개여부</th>
							<th style="width: 10%;"><spring:message code = 'ezCommunity.t33' /></th>
							<th style="width: 10%;"><spring:message code = 'ezCommunity.t78' /></th>
							<th style="width: 60px;">폐쇄</th>
						</tr>
					</table>
				</div>
				<div id="ListBody">
					<table id="mainListBody" class="mainlist" style="width: 100%"></table>
				</div>
			</div>
			
			<div id="tblPageRayer"></div>
		</form>
	</body>
</html>