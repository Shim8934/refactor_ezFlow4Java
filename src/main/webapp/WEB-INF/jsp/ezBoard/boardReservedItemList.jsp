<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<script>
			var pOrgBoardParameters = "${orgBoardParameters}";
			var SSUserID = "${userInfo.id}";
			var SSUserName = "${userInfo.displayName}";
			var CurPage = "${page}";
			var totalPage = "${totalPage}";
			var strListInfo = "";
			var pSortBy = "${sortBy}";
		    var pTotalCnt = "${totalCount}";
		    var pUse_Editor = "${seEditor}";
		    var pAdminType = "${adminType}";
		    window.onload = function ()
		    {
		    	makePageSelPageBrd();
		    };
		
		    function ItemRead_onclick(pItemBoardID, pItemBoardName, pItemID) {
		        var feature = GetOpenWindowfeature(765, 820);
	            window.open("/ezBoard/boardNewItem.do?boardID=" + pItemBoardID + "&itemID=" + pItemID + "&mode=modify" + "&reservedItem=true", "", feature, "");
		    }
		
		    function checkBox_checked(pItemID, evt) {
		        if (CrossYN()) {
		            if (evt.currentTarget.checked)
		                strListInfo += pItemID + "," + SSUserID + ";";
		            else
		                strListInfo = ReplaceText(strListInfo, pItemID + "," + SSUserID + ";", "");
		        }
		        else {
		            if (window.event.srcElement.checked) {
		                strListInfo += pItemID + "," + SSUserID + ";";
		            } else {
		                strListInfo = ReplaceText(strListInfo, pItemID + "," + SSUserID + ";", "");
		            }
		        }
		    }
		    function checkBox_checkAll() {
		        var i = 0;
		        for (i = 1; i < document.frmOutbox.length; i++) {
		            if (document.frmOutbox[i].type == 'checkbox') {
		                if (document.frmOutbox.checkbox.checked) {
		                    document.frmOutbox[i].checked = true;
		                    strListInfo = document.getElementById("ListInfo").innerHTML;
		                } else {
		                    document.frmOutbox[i].checked = false;
		                    strListInfo = "";
		                }
		            }
		        }
		    }
		    function DeleteItem_onclick() {
		        if (strListInfo == "") {
		            alert("<spring:message code='ezBoard.t195'/>");
		            return;
		        }
		        var ret = confirm("<spring:message code='ezBoard.t197'/>");
		        if (ret) DeleteItem();
		    }
		    function DeleteItem() {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezBoard/deleteItem.do?itemList=" + strListInfo, false);
		        xmlhttp.send();
		
		        if (xmlhttp.responseText == "NO") {
		            alert("<spring:message code='ezBoard.t265'/>");
		            return;
		        }
		
		        xmlhttp = null;
		        window.location.reload();
		    }
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		    function refresh_onclick() {
		        window.location.reload(false);
		    }
		    function prevPage_onclick() {
		        newPage = parseInt(CurPage) - 1;
		        if (newPage > 0) {
		            window.location.href = "/ezBoard/boardReservedItemList.do?page=" + newPage.toString() + "&sortBy=" + pSortBy + "&orgBoardParameters=" + ReplaceString(pOrgBoardParameters);
		        }
		    }
		    function nextPage_onclick() {
		        newPage = parseInt(CurPage) + 1;
		        if (newPage <= parseInt(totalPage)) {
		            window.location.href = "/ezBoard/boardReservedItemList.do?page=" + newPage.toString() + "&sortBy=" + pSortBy + "&orgBoardParameters=" + ReplaceString(pOrgBoardParameters);
		        }
		    }
		    function moveToPage(evt) {
		        if (CrossYN()) {
		            if (evt.which == 13) {
		                var newPage = txt_PageInputNum.value;
		                if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		                    window.location.href = "/ezBoard/boardReservedItemList.do?page=" + parseInt(newPage.toString()) + "&sortBy=" + pSortBy + "&orgBoardParameters=" + ReplaceString(pOrgBoardParameters);
		                }
		            }
		        }
		        else {
		            if (window.event.keyCode == 13) {
		                var newPage = txt_PageInputNum.value;
		                if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		                    window.location.href = "/ezBoard/boardReservedItemList.do?page=" + parseInt(newPage.toString()) + "&sortBy=" + pSortBy + "&orgBoardParameters=" + ReplaceString(pOrgBoardParameters);
		                }
		            }
		        }
		    }
		    function SortPage(SortBy) {
		        window.location.href = "/ezBoard/boardReservedItemList.do?page=" + CurPage + "&sortBy=" + SortBy + "&boardType=" + "${boardType}" + "&orgBoardParameters=" + ReplaceString(pOrgBoardParameters);
		    }
		    function BoardItemList() {
		        if ("${boardType}" == "0" || "${boardType}" == "1" || "${boardType}" == "2") {
		            window.location.href = "/ezBoard/boardItemList.do?" + ReplaceString(pOrgBoardParameters) + "&adminType=" + pAdminType;
		        } else if ("${boardType}" == "3") {
		            window.location.href = "/ezBoard/BoardItemListPhoto.do?" + ReplaceString(pOrgBoardParameters) + "&adminType=" + pAdminType;
		        } else if ("${boardType}" == "4") {
		              window.location.href = "/ezBoard/boardItemListThumbnail.do?" + ReplaceString(pOrgBoardParameters) + "&adminType=" + pAdminType;
		        } else if ("${boardType}" == "N") {
		            window.location.href = "/ezBoard/boardItemList_new.do?" + ReplaceString(pOrgBoardParameters) + "&adminType=" + pAdminType;
		        } else {
		            window.location.href = "/ezBoard/boardItemList.do?" + ReplaceString(pOrgBoardParameters) + "&adminType=" + pAdminType;
		        }
		    }
		
		    var BlockSize = 10;
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		
		    function goToPageByNum(Value) {
		        CurPage = Value;
		        makePageSelPageBrd();
		        movePage(CurPage);
		    }
		    function selbeforeBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    function selbeforeBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum - 1) > 0)
		            goToPageByNum(parseInt(pageNum - 1));
		        else
		            return;
		    }
		    function selafterBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum + 1) <= totalPage)
		            goToPageByNum(parseInt(pageNum + 1));
		        else
		            return;
		    }
		
		    function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		            CurPage = newPage;
		            getBoardList();
		        }
		    }
		
		    function prevPage_onclick() {
		        newPage = parseInt(CurPage) - 1;
		        if (newPage > 0) {
		            CurPage = newPage;
		            getBoardList();
		        }
		    }
		
		    function nextPage_onclick() {
		        newPage = parseInt(CurPage) + 1;
		        if (newPage <= parseInt(totalPage)) {
		            CurPage = newPage;
		            getBoardList();
		        }
		    }
		
		    function getBoardList() {
		        window.location.href = "/ezBoard/boardReservedItemList.do?orgBoardParameters=" + ReplaceString(pOrgBoardParameters) + "&page=" + CurPage + "&sortBy=" + pSortBy;
		    }
		
		    function ReplaceString(pOrgString) {
		        return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&amp;", "&"), "&lt;", "<"), "&gt;", ">");
		    }
		</script>
	</head>
	<c:choose>
		<c:when test="${adminType != 'y'}">
			<body class="mainbody">
			<h1>${boardName}<span id="mailBoxInfo"></span></h1>
		</c:when>
		<c:otherwise>
		    <script type="text/javascript">
		        parent.document.getElementsByTagName("h1")[0].innerHTML = "<h1>" + "${boardName}" + "<span id='mailBoxInfo'></span></h1>";
		    </script>
		    <br />
		</c:otherwise>
	</c:choose>
	<c:choose>
		<c:when test="${isVpn != 1}">
			<div id="mainmenu">
			  <ul>
			    <li><span onClick="DeleteItem_onclick()"><spring:message code='ezBoard.t89'/></span></li>
			    <li><span onClick="refresh_onclick()"><spring:message code='ezBoard.t205'/></span></li>
			    	<c:if test="${orgBoardParameters != ''}">
					    <li><span onClick="BoardItemList()"><spring:message code='ezBoard.t206'/></span></li>
			    	</c:if>
			  </ul>
			</div>
			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
		</c:when>
		<c:otherwise>
			<table border="0" cellspacing="0" cellpadding="0" class="micon">
			  <tr>
			    <td><span onClick="DeleteItem_onclick()" style="cursor:pointer" class="ic"><spring:message code='ezBoard.t89'/></span></td>
			    <td><span  onclick="refresh_onclick()" style="cursor:pointer" class="ic"><spring:message code='ezBoard.t205'/></span></td>
			    <td><span style="cursor:pointer" onClick="BoardItemList()" class="ic"><spring:message code='ezBoard.t206'/></span></td>
			    <td>&nbsp;</td>
			  </tr>
			</table>
		</c:otherwise>
	</c:choose>
	<table class="mainlist" style ="width:100%">
	  <form name="frmOutbox" action="/ezBoard/boardReservedItemList.do" method="post">
	    <tr>
	      <th width="20" align="center" style="padding:0"><input type='checkbox' name="checkbox" onclick='checkBox_checkAll()'></th>
	      <c:choose>
	      	<c:when test="${sortBy == 'B.BoardName'}">
		      <th style="cursor:pointer" width="160" onClick="SortPage('B.BoardName desc')"><spring:message code='ezBoard.t185'/><img src="/images/etc/view-sortup.gif" ></th>
	      	</c:when>
	      	<c:when test="${sortBy == 'B.BoardName desc'}">
		      <th style="cursor:pointer" width="160" onClick="SortPage('B.BoardName')"><spring:message code='ezBoard.t185'/><img src="/images/etc/view-sortdown.gif" ></th>
	      	</c:when>
	      	<c:otherwise>
		      <th style="cursor:pointer" width="160" onClick="SortPage('B.BoardName')"><spring:message code='ezBoard.t185'/></th>
	      	</c:otherwise>
	      </c:choose>    
	      <c:choose>
	      	<c:when test="${sortBy == 'A.Title'}">
		      <th style="cursor:pointer" onClick="SortPage('A.Title desc')"><spring:message code='ezBoard.t208'/><img src="/images/etc/view-sortup.gif" ></th>
	      	</c:when>
	      	<c:when test="${sortBy == 'A.Title desc'}">
		      <th style="cursor:pointer" onClick="SortPage('A.Title')"><spring:message code='ezBoard.t208'/><img src="/images/etc/view-sortdown.gif" ></th>
	      	</c:when>
	      	<c:otherwise>
		      <th style="cursor:pointer" onClick="SortPage('A.Title')"><spring:message code='ezBoard.t208'/></th>
	      	</c:otherwise>
	      </c:choose>    
	      <c:choose>
	      	<c:when test="${sortBy == 'A.StartDate'}">
		      <th style="cursor:pointer" width="120" onClick="SortPage('A.StartDate desc')"><spring:message code='ezBoard.t342'/>
		        <spring:message code='ezBoard.t343'/><img src="/images/etc/view-sortup.gif" ></th>
	      	</c:when>
	      	<c:when test="${sortBy == 'A.StartDate desc'}">
		      <th style="cursor:pointer" width="120" onClick="SortPage('A.StartDate')"><spring:message code='ezBoard.t344'/><img src="/images/etc/view-sortdown.gif" ></th>
	      	</c:when>
	      	<c:otherwise>
		      <th style="cursor:pointer" width="120" onClick="SortPage('A.StartDate')"><spring:message code='ezBoard.t344'/></th>
	      	</c:otherwise>
	      </c:choose>    
	      <c:choose>
	      	<c:when test="${sortBy == 'A.EndDate'}">
		      <th style="cursor:pointer" width="80" onClick="SortPage('A.EndDate desc')"><spring:message code='ezBoard.t342'/>
		        <spring:message code='ezBoard.t345'/><img src="/images/etc/view-sortup.gif" ></th>
	      	</c:when>
	      	<c:when test="${sortBy == 'A.EndDate desc'}">
		      <th style="cursor:pointer" width="80" onClick="SortPage('A.EndDate')"><spring:message code='ezBoard.t346'/><img src="/images/etc/view-sortdown.gif" ></th>
	      	</c:when>
	      	<c:otherwise>
		      <th style="cursor:pointer" width="80" onClick="SortPage('A.EndDate')"><spring:message code='ezBoard.t346'/></th>
	      	</c:otherwise>
	      </c:choose>    
	      <c:choose>
	      	<c:when test="${sortBy == 'A.Attachments'}">
		      <th style="cursor:pointer" width="80" onClick="SortPage('A.Attachments desc')"><spring:message code='ezBoard.t225'/><img src="/images/etc/view-sortup.gif" ></th>
	      	</c:when>
	      	<c:when test="${sortBy == 'A.Attachments desc'}">
		      <th style="cursor:pointer" width="80" onClick="SortPage('A.Attachments')"><spring:message code='ezBoard.t225'/><img src="/images/etc/view-sortdown.gif" ></th>
	      	</c:when>
	      	<c:otherwise>
		      <th style="cursor:pointer" width="80" onClick="SortPage('A.Attachments')"><spring:message code='ezBoard.t225'/></th>
	      	</c:otherwise>
	      </c:choose>    
	    </tr>
	    <c:set var="ListInfo"/>
	    <c:forEach var="reservedList" items="${reservedList}">
	    	<tr>
		    	<td align=center style='padding:0'><input type='checkbox' name='chk' id='chk' onclick='checkBox_checked("${reservedList.itemID}", event)'></td>
		    	<td>${reservedList.boardName}</td>
		    	<td title="${fn:replace(reservedList.ABSTRACT, '\'', '`') }" style='cursor:pointer; text-overflow:ellipsis; overflow:hidden' onclick="ItemRead_onclick('${reservedList.boardID}', '${reservedList.boardName}', '${reservedList.itemID}')"><nobr>${reservedList.title}</nobr></td>
		    	<td>${fn:substring(reservedList.startDate, 0, 16)}</td>
		    	<c:choose> 
		    		<c:when test="${fn:substring(reservedList.endDate, 0, 4) == '9999'}">
		    			<td><spring:message code='ezBoard.t287'/></td>
		    		</c:when>
		    		<c:otherwise>
		    			<td>${fn:split(reservedList.endDate , ' ')[0]}</td>
		    		</c:otherwise>
		    	</c:choose>
		    	<c:choose>
	    		<c:when test="${reservedList.attachments != '0'}">
	    			<td align=center><img src='/images/i_save01.gif'></td>
	    		</c:when>
	    		<c:otherwise>
	    			<td></td>
	    		</c:otherwise>
		    	</c:choose>
	    	</tr>
	    	<tr>
<%-- 	    	<c:set target="${ListInfo}">${ListInfo} + ${reservedList.itemID} + "," + ${userInfo.id} + ";"}</c:set> --%>
	    </c:forEach>
	  </form>
	</table>
	<br />
	<div id="tblPageRayer" style="text-align:center"></div>
	<div id="ListInfo" style="DISPLAY:none">${ListInfo}</div>
	</body>
</html>