<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezResource.t343" /></title>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2"/>" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezResource.e1' />"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<style type="text/css"> 
			.pagetd{ padding-top:6px; }
			.pcol{ padding-top:6px; }
			.Right_Point01 { font:bold; color:#017bec; }
		</style>
		<script type="text/javascript">
			var pBrdid		= "${brdID}";
			var pBrdnm		= "<c:out value='${brdNm}' />";
			var pAccessCode	= "${accessCode}";
			var pCompanyID	= "${companyID}";
			var pUserID		= "${userID}";
			var pDeptID		= "${deptID}";
			var ptotalPage	= "${totalPage}";
			var pcurpage	= "${curPage}";
			var pSortGbn	= "${sortGbn}";
			var pAdminFg = "${adminFg}";
			var TotalCnt = "${totalCnt}";

		    	function MemberInfo_onDblclick(pSelUserID) {
			        var feature = GetOpenPosition(420, 438);
			        window.open("/ezCommon/showPersonInfo.do?ID=" + pSelUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    	}

		    	function btnAdd_Click() {
			        if (CheckAdmin() == false) {
		            	alert("<spring:message code='ezResource.t345' />");
		            	return;
		        	}

		        	var pURL;
		        	pURL = "/ezResource/addClsItem.do?brdID=" + pBrdid
		        	var openLocation = pURL;
		        	openwindow(openLocation, "", 580, 450);
		    	}

		    	function btnModify_Click() {
			        if (CheckAdmin() == false) {
		            	alert("<spring:message code='ezResource.t345' />");
		            	return;
		        	}

		        	var i, intChkCnt = 0;

		        	var objChk = document.getElementsByTagName("INPUT");
		        	for (i = 0; i < objChk.length; i++) {
		            	if (objChk[i].name == "chk" && objChk[i].checked == true) {
		                	intChkCnt = intChkCnt + 1;
		                	var intChkNum = 0;
		                	var strResID = objChk[i].value;
		                	var strOwnerID = objChk[i].getAttribute("OwnerID", "0");
		            	}
		        	}

			        if (intChkCnt == 0) {
			            alert("<spring:message code='ezResource.t346' />");
			        } else if (intChkCnt > 1) {
		    	        alert("<spring:message code='ezResource.t347' />");
		        	} else if (intChkCnt = 1) {
			            if (pUserID == strOwnerID || pAdminFg == "Y") {
			                var pURL;
			                pURL = "/ezResource/modClsItem.do?brdID=" + strResID + "&resID=" + pBrdid;
		    	            var openLocation = pURL;
		        	        openwindow(openLocation, "", 580, 550);
		            	    objChk[intChkNum].checked = false;
		            	} else {
			                alert("<spring:message code='ezResource.t348' />");
			            }
			        }
		    	}

		    	function btnDelete_Click() {

			        if (CheckAdmin() == false) {
			            alert("<spring:message code='ezResource.t345' />");
			            return;
		    	    }

			        var strBrd_IDs = "";
			        var strMsg = "";

			        var i, intChkCnt = 0;
		    	    var objChk = document.getElementsByTagName("INPUT");
		        	for (i = 0; i < objChk.length; i++) {
			            if (objChk[i].name == "chk" && objChk[i].checked == true) {
			                var strOwnerID = objChk[i].getAttribute("OwnerID", "0");
			                if (pUserID != strOwnerID && pAdminFg != "Y") {
		    	                strMsg = "<spring:message code='ezResource.t349' />";
		        	        } else {
		            	        intChkCnt = intChkCnt + 1;
		                	    objChk[i].checked == false;
		                    	strBrd_IDs += "," + objChk[i].value;
		                	}
		            	}
		        	}

		        	if (intChkCnt == 0) {
			            alert(strMsg + "\n" + "<spring:message code='ezResource.t350' />");
			        } else if (intChkCnt > 0) {

			            if (!confirm("<spring:message code='ezResource.t351' />")) {
		    	            return;
		        	    }

			            strBrd_IDs = strBrd_IDs.substr(1)

			            var xmlPara = createXmlDom();
			            var xmlHttp = createXMLHttpRequest();
	
			            var objNode;
			            createNodeInsert(xmlPara, objNode, "PARADATA");
		    	        createNodeAndInsertText(xmlPara, objNode, "DATA", strBrd_IDs);
		        	    createNodeAndInsertText(xmlPara, objNode, "DATA", pCompanyID);
	
			            xmlHttp.open("Post", "/ezResource/callDelClsItem.do?brdID=" + pBrdid, false);
			            xmlHttp.send(xmlPara)
		    	        if (xmlHttp.status != 200) {
		        	        alert("<spring:message code='ezResource.t63' />");
		            	    return;
		            	}

		            	var rtnXML = xmlHttp.responseXML;
		            	var dataNodes = GetChildNodes(xmlHttp.responseXML);
		            	var strRtnVal = getNodeText(dataNodes[0]);

			            if (strRtnVal == "False") {
			                alert("<spring:message code='ezResource.t63' />");
			            } else {
		    	            alert("<spring:message code='ezResource.t64' />");
		        	        RefreshPageDoc();
		            	}
		        	}
		    	}

		    	function CheckAdmin() {
			        if (pAdminFg == "Y") {
			            return true;
			        } else {
			        	return false;
			        }
		    	}

		    	function btnViewInfo_Click() {
		    	}

		    	function Item_View(vBrdid) {
			        pURL = "/ezResource/viewClsItem.do?brdID=" + vBrdid
			        var openLocation = pURL;
			        openwindow(openLocation, "", 880, 550);
		    	}

		    	function RefreshPageDoc() {

			        window.parent.left.location.href = "/ezResource/leftResource.do?flag=SELECT_NO";

			        document.frmRefresh.target = "_self"
			        document.frmRefresh.brdID.value = pBrdid
		    	    document.frmRefresh.accessCode.value = pAccessCode
		        	document.frmRefresh.brdNm.value = pBrdnm
		        	document.frmRefresh.goToPage.value = pcurpage
		        	document.frmRefresh.submit();
		    	}

			    function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
			        try {
			            var heigth = window.screen.availHeight;
		    	        var width = window.screen.availWidth;
		        	    var left = 0;
		            	var top = 0;

			            if (window.screen.width > 800) {
			                var pleftpos;
			                var pheightpos;
		    	            pleftpos = parseInt(width) - 700;
		        	        pheightpos = parseInt(heigth) - 700;
		            	    width = parseInt(width) - pleftpos;
		                	heigth = parseInt(heigth) - pheightpos;
		                	left = pleftpos / 2;
		                	top = pheightpos / 2;
		            	} else {
			                heigth = parseInt(heigth) - 30;
			                width = parseInt(width) - 10;
			            }

		    	        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);

			        } catch (e) {
			            alert("openwindow :: " + e.description);
		        	}
		    	}

		    	function reverse(chkedVal) {
			        var i;
			        var objChk = document.getElementsByTagName("INPUT");
	
		        	if (objChk.length == undefined) {
		            	objChk.checked = chkedVal;
		        	} else {
			            for (i = 0; i < objChk.length; i++) {
			                if (document.getElementsByTagName("INPUT")[i].name == "chk") {
			                    document.getElementsByTagName("INPUT")[i].checked = chkedVal;
		    	            }
		        	    }
		        	}
		    	}

		    	var BlockSize = 10;
		    	function td_Create1(strtext) {
			        document.getElementById("tblPageRayer").innerHTML = strtext;
			    }

			    function makePageSelPage() {
		    	    var strtext;
		        	var PagingHTML = "";
		        	document.getElementById("tblPageRayer").innerHTML = "";
		        	document.getElementById("TitleInfo").innerHTML = " - [" + strLang1002 + "<span style='color:#017BEC;font-weight:bold;'> " + TotalCnt + " </span>" + strLang1003 + "]";
		        	strtext = "<div class='pagenavi'>";
		        	PagingHTML += strtext;
		        	var pageNum = pcurpage;
		        	if (ptotalPage > 1 && pageNum != 1) {
			            strtext = "<span class='btnimg'><a onclick= 'return goToPageByNum(1)'>";
			            strtext = strtext + "<img src='/images/kr/cm/btn_p_prev.gif' width='16' height='16' /></a></span>";
			            PagingHTML += strtext;
		    	    } else {
			            strtext = "<span class='btnimg'><a >";
			            strtext = strtext + "<img src='/images/kr/cm/btn_p_prev01.gif' width='16' height='16' /></a></span>";
			            PagingHTML += strtext;
		    	    }
		        	if (ptotalPage > BlockSize) {
			            if (pageNum > BlockSize) {
			                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'>";
			                strtext = strtext + "<img src='/images/kr/cm/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>&nbsp;" + strLang1000 + "&nbsp;</span>";
		    	            PagingHTML += strtext;
		        	    } else {
		                	strtext = "<span class='btnimg'>";
		                	strtext = strtext + "<img src='/images/kr/cm/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>&nbsp;" + strLang1000 + "&nbsp;</span>";
		                	PagingHTML += strtext;
		            	}
		        	} else {
		            	strtext = "<span class='btnimg'>";
		            	strtext = strtext + "<img src='/images/kr/cm/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>&nbsp;" + strLang1000 + "&nbsp;</span>";
		            	PagingHTML += strtext;
		        	}
		        	var MaxNum;
		        	var i;
		        	var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
		        	if (ptotalPage >= (startNum + parseInt(BlockSize))) {
			            MaxNum = (startNum + parseInt(BlockSize)) - 1;
		        	} else {
		            	MaxNum = ptotalPage;
		        	}
		        	for (i = startNum; i <= MaxNum; i++) {
			            if (i == pageNum) {
			                strtext = "<span class='on'>" + i + "</span>"
			                PagingHTML += strtext;
		    	        } else {
		                	strtext = "<span onclick = 'goToPageByNum(" + i + ")'>" + i + "</span>"
		                	PagingHTML += strtext;
		            	}
		        	}
		        	if (ptotalPage > BlockSize) {
		            	if (ptotalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
			                strtext = "<span onclick='return selafterBlock_one()' class='ptxt'>" + strLang1001 + "</span><span class='btnimg' onclick='return selafterBlock()'>";
			                strtext = strtext + "<img src='/images/kr/cm/btn_next.gif' width='16' height='16'></span>";
			                PagingHTML += strtext;
		    	        } else {
		                	strtext = "<span onclick='return selafterBlock_one()' class='ptxt'>" + strLang1001 + "</span><span class='btnimg'>";
		                	strtext = strtext + "<img src='/images/kr/cm/btn_next01.gif' width='16' height='16'></span>";
		                	PagingHTML += strtext;
		            	}
		        	} else {
		            	strtext = "<span onclick='return selafterBlock_one()' class='ptxt'>" + strLang1001 + "</span><span class='btnimg'>";
		            	strtext = strtext + "<img src='/images/kr/cm/btn_next01.gif' width='16' height='16'></span>";
		            	PagingHTML += strtext;
		        	}
		        	if (ptotalPage > 1 && ptotalPage != 1 && (ptotalPage != pageNum)) {
		            	strtext = "<span class='btnimg' onclick='return goToPageByNum(" + ptotalPage + ")'>";
		            	strtext = strtext + "<img src='/images/kr/cm/btn_n_next.gif' width='16' height='16' /></span>";
		            	PagingHTML += strtext;
		        	} else {
		            	strtext = "<span class='btnimg'>";
		            	strtext = strtext + "<img src='/images/kr/cm/btn_n_next01.gif' width='16' height='16' /></span>";
		            	PagingHTML += strtext;
		        	}
		        	PagingHTML += "</div>";
		        	td_Create1(PagingHTML);
		    	}

		    	function goToPageByNum(Value) {
			        pcurpage = Value;
			        makePageSelPage();
			        movePage(pcurpage);
		    	}

		    	function selbeforeBlock() {
		        	var pageNum = parseInt(pcurpage);
		        	pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
		        	goToPageByNum(pageNum);
		    	}

		    	function selbeforeBlock_one() {
			        var pageNum = parseInt(pcurpage);
			        if (parseInt(pageNum - 1) > 0) {
			        	goToPageByNum(parseInt(pageNum - 1));
			        } else {
			        	return;
			        }
		    	}

			    function selafterBlock() {
			        var pageNum = parseInt(pcurpage);
			        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }

		    function selafterBlock_one() {
		        var pageNum = parseInt(pcurpage);
		        if (parseInt(pageNum + 1) <= ptotalPage)
		            goToPageByNum(parseInt(pageNum + 1));
		        else
		            return;
		    }

		    function movePage(newPage) {
		        var pURL;
		        if (parseInt(newPage) > 0 && parseInt(newPage) != "" && parseInt(newPage) <= parseInt(ptotalPage)) {
		            document.frmRefresh.target = "_self"
		            document.frmRefresh.brdID.value = pBrdid
		            document.frmRefresh.accessCode.value = pAccessCode
		            document.frmRefresh.brdNm.value = pBrdnm
		            document.frmRefresh.goToPage.value = newPage
		            document.frmRefresh.submit();
		        }
		    }

		    function SearchPage_Set() {
		        if (event.keyCode == 13) {
		            var GotoPage = document.getElementById("SearchPage").value;
		            Search_Set(GotoPage);
		            return false;
		        }
		        return true;
		    }

		    function Search_Set(pGoToPage) {
		        var pURL;
		        if (parseInt(pGoToPage) > 0 && parseInt(pGoToPage) != "" && parseInt(pGoToPage) <= parseInt(ptotalPage)) {
		            document.frmRefresh.target = "_self"
		            document.frmRefresh.brdID.value = pBrdid
		            document.frmRefresh.accessCode.value = pAccessCode
		            document.frmRefresh.brdNm.value = pBrdnm
		            document.frmRefresh.goToPage.value = pGoToPage
		            document.frmRefresh.submit();
		        }

		    }

		    function btnCcalendar_Click() {
		        var strUrl = "/ezResource/viewResList2.do?brdID=" + pBrdid + "&accessCode=" + pAccessCode;
		        strUrl = strUrl + "&brdNm=" + encodeURI(pBrdnm);
		        window.open(strUrl, 'right');
		    }
		</script>
	</head>
	<body class="mainbody" onload = "makePageSelPage()">
		<h1><c:out value='${brdNm}' /><span id="TitleInfo" style="color:#666;font-weight:normal;"></span></h1>

		<div id="mainmenu">
  			<ul>
    			<c:if test="${adminFg eq 'Y'}">
    				<li><span onClick="btnAdd_Click();"><spring:message code='ezResource.t363' /></span></li>
    			</c:if>
    			<li><span onClick="btnModify_Click();"><spring:message code='ezResource.t364' /></span></li>
    			<li><span onClick="btnDelete_Click();"><spring:message code='ezResource.t365' /></span></li>
    			<li><span onClick="btnCcalendar_Click();"><spring:message code='ezResource.t400' /></span></li>
  			</ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<table class="mainlist" style="width:100%">
  			<tr>
    			<th style="padding:0px; width:30px"><input type="checkbox" name="checkbox" onClick="reverse(this.checked)" id="Checkbox1"></th>
    			<th> <spring:message code='ezResource.t39' /></th>
    			<th style="width:100px"> <spring:message code='ezResource.t366' /></th>
    			<th style="width:80px"> <spring:message code='ezResource.t106' /></th>
    			<th style="width:60px"> <spring:message code='ezResource.t37' /></th>
    			<th style="width:120px"> <spring:message code='ezResource.t367' /></th>
    			<th style="width:100px;"> <spring:message code='ezResource.t148' /></th>
  			</tr>
			<c:if test="${!empty resBrdList}" >
				<c:forEach var="list"  items="${resBrdList}">
  					<tr>
    					<td style="padding:0;"><input type="checkbox" name="chk" id="chk" value="${list.brdID}" ownerid="${list.ownerID}"></td>
						<td title="<c:out value='${list.brdNm}' />" onClick="Item_View('${list.brdID}');"	style="cursor: pointer; text-overflow: ellipsis; overflow: hidden" align="left"><nobr><c:out value='${list.brdNm}' /></nobr> </td>
						<td id="OwnDeptID" value="${list.ownDeptNm}" style="text-overflow: ellipsis; overflow: hidden"><nobr>${list.ownDeptNm}</nobr> </td>
						<td id="OwnerID"  style="cursor:pointer;" value="${list.ownerID}" onClick="MemberInfo_onDblclick('${list.ownerID}')" nowrap>${list.ownerNm}</td>
						<td id="OwnerPosition">${list.ownerPosition}</td>
						<td id="OwnerCall">${list.ownerCall} </td>			
						<td id="ResLocation" style="text-overflow: ellipsis; overflow: hidden"><nobr>${list.resLocation}</nobr> </td>
					</tr> 
				</c:forEach>
			</c:if>
		</table>
    	<div id="tblPageRayer"></div>
		<form name="frmRefresh" action="/ezResource/viewResList.do" method="post">
  			<input type="hidden" name="brdID">
  			<input type="hidden" name="brdNm">
  			<input type="hidden" name="accessCode">
  			<input type="hidden" name="sortGbn">
  			<input type="hidden" name="goToPage">
		</form>
	</body>
</html>