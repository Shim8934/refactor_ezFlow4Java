<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezResource.t343" /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
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
			var selectedResourceId = "${selectedResourceId}";

		   function MemberInfo_onDblclick(pSelUserID, pDeptID) {
			  var feature = GetOpenPosition(420, 450);
			  window.open("/ezCommon/showPersonInfo.do?id=" + pSelUserID + "&dept=" + pDeptID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
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
		            alert(strMsg + "<spring:message code='ezResource.t350' />");
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

	    	/* 2019-02-21 홍승비 - CSRF 수정 > 단순 호출 동작이므로 get으로 수정 */
	    	function RefreshPageDoc() {
		        window.parent.left.location.href = "/ezResource/leftResource.do?flag=SELECT_NO";
		        window.location.href  = "/ezResource/viewResList.do?brdID=" + pBrdid + "&brdNm=" + encodeURI(pBrdnm) + "&accessCode=" + pAccessCode + "&goToPage=" + pcurpage;
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
	        	document.getElementById("TitleInfo").innerHTML = " - [" + strLang1002 + "<span class='txt_color' style='font-weight:bold;'> " + TotalCnt + " </span>" + strLang1003 + "]";
	        	strtext = "<div class='pagenavi'>";
	        	PagingHTML += strtext;
	        	var pageNum = pcurpage;
	        	if (ptotalPage > 1 && pageNum != 1) {
					strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
		            PagingHTML += strtext;
	    	    } else {
					strtext = "<span class='btnimg first disabled'></span>";
		            PagingHTML += strtext;
	    	    }
	        	if (ptotalPage > BlockSize) {
		            if (pageNum > BlockSize) {
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
		                strtext = "<span class='btnimg next' onclick='return selafterBlock()'></span>";
		                PagingHTML += strtext;
	    	        } else {
	                	strtext = "<span class='btnimg next disabled'></span>";
	                	PagingHTML += strtext;
	            	}
	        	} else {
	            	strtext = "<span class='btnimg next disabled'></span>";
	            	PagingHTML += strtext;
	        	}
	        	if (ptotalPage > 1 && ptotalPage != 1 && (ptotalPage != pageNum)) {
	            	strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + ptotalPage + ")'></span>";
	            	PagingHTML += strtext;
	        	} else {
	            	strtext = "<span class='btnimg last disabled'></span>";
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
		        	 window.location.href  = "/ezResource/viewResList.do?brdID=" + pBrdid + "&brdNm=" + pBrdnm + "&accessCode=" + pAccessCode + "&goToPage=" + newPage;
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
		            window.location.href  = "/ezResource/viewResList.do?brdID=" + pBrdid + "&brdNm=" + pBrdnm + "&accessCode=" + pAccessCode + "&goToPage=" + pGoToPage;
		        }
		    }
	
		    function btnCcalendar_Click() {
		        var strUrl = "/ezResource/viewResList2.do?brdID=" + pBrdid + "&accessCode=" + pAccessCode;
		        strUrl = strUrl + "&brdNm=" + encodeURIComponent(pBrdnm);
                parent.document.querySelector("iframe[name=right]").src = strUrl;
		    }
		    
		    //2018-09-03 김보미 - 페이징 하단에 나타나도록 조정
		    window.onload = function() {
		    	makePageSelPage();
	    		windowResize();
	    		if(selectedResourceId != "") {
	    			$("input[name=chk][value="+selectedResourceId+"]").trigger("click");
	    		}
		    }
		    
		    window.onresize = function() {
	    		windowResize();
		    }
		    
		    function windowResize() {
	        	var height = document.documentElement.clientHeight - 155 - document.getElementById("mainmenu").clientHeight;

	        	document.getElementById("contentlist").style.height = height + "px";
	        	document.getElementById("contentlist").style.overflow = "auto";
	        }
		    
		    function resourceOrderUp() {
		    	var checkId = $("input:checkbox[id='chk']:checked");
		    	//$("input:checkbox[id='chk']").is(":checked")

		    	if (checkId.length < 1) {
		    		alert("<spring:message code="ezResource.gha04" />");
		    		return;
		    	} else if (checkId.length > 1) {
		    		alert("<spring:message code="ezResource.gha03" />");
		    		return;
		    	}
		    	
		    	var resPlusCheckId = 'res' + checkId.attr('value');
		    	var previousCheckId = $(checkId[0]).closest("tr").prev().children().eq(0).find('input').attr("value");
		    	var resPluspreviousCheckId = 'res' + previousCheckId;
		    	
		    	if ($(checkId[0]).closest("tr").prev().children().eq(0).find('input').attr("value") == undefined && pcurpage == "1") {
		    		return;
		    	}
		    	
		    	$.ajax({
		    		type : "POST",
		    		async : false,
		    		data : {
		    			selectedResourceId : $(checkId[0]).attr("value"),
		    			targetResourceId : "up",
		    			upperResourceId : pBrdid
		    		},
		    		url : "/ezResource/changeResourceOrder.do",
		    		success: function(text){
		    			//window.RefreshPageDoc();
		    			location.href = "/ezResource/viewResList.do?brdID=" + pBrdid + "&brdNm=" + encodeURI(pBrdnm) + "&accessCode=" + pAccessCode + "&goToPage=" + pcurpage + "&selectedResourceId=" + $(checkId[0]).attr("value");
		    			/* var $tr = $(checkId[0]).closest("tr"); // 클릭한 버튼이 속한 tr 요소
		    			$tr.prev().before($tr); // 현재 tr 의 이전 tr 앞에 선택한 tr 넣기
		    			
		    			var $label = $(parent.frames["left"].document.querySelectorAll("[id='res"+$(checkId[0]).attr("value")+"']"));
		    			if ($label) {
			    			$label.prev().before($label);
		    			} */
		    		},
		    		error: function(err){
		    		}
		    	});
		    }
		    
		    function resourceOrderDown() {
		    	var checkId = $("input:checkbox[id='chk']:checked");

		    	if (checkId.length < 1) {
		    		alert("<spring:message code="ezResource.gha04" />");
		    		return;
		    	} else if (checkId.length > 1) {
		    		alert("<spring:message code="ezResource.gha03" />");
		    		return;
		    	}
		    	
		    	var resPlusCheckId = 'res' + checkId.attr('value');
		    	var nextCheckId = $(checkId[0]).closest("tr").prev().children().eq(0).find('input').attr("value");
		    	var resPlusnextCheckId = 'res' + nextCheckId;
		    	
		    	if ($(checkId[0]).closest("tr").next().children().eq(0).find('input').attr("value") == undefined && pcurpage == ptotalPage) {
		    		return;
		    	}
		    	
		    	$.ajax({
		    		type : "POST",
		    		async : false,
		    		data : {
		    			selectedResourceId : $(checkId[0]).attr("value"),
		    			targetResourceId : "down",
		    			upperResourceId : pBrdid
		    		},
		    		url : "/ezResource/changeResourceOrder.do",
		    		success: function(text){
		    			//window.RefreshPageDoc();
		    			location.href = "/ezResource/viewResList.do?brdID=" + pBrdid + "&brdNm=" + encodeURI(pBrdnm) + "&accessCode=" + pAccessCode + "&goToPage=" + pcurpage + "&selectedResourceId=" + $(checkId[0]).attr("value");
		    			/* var $tr = $(checkId[0]).closest("tr"); // 클릭한 버튼이 속한 tr 요소
		    			$tr.next().after($tr); // 현재 tr 의 이전 tr 앞에 선택한 tr 넣기
		    			
		    			var $label = $(parent.frames["left"].document.querySelectorAll("[id='res"+$(checkId[0]).attr("value")+"']"));
		    			if ($label) {
			    			$label.next().after($label);
		    			} */
		    		},
		    		error: function(err){
		    		}
		    	});
		    }
		    
		    var organ_cross_dialogArguments = new Array();
		    
		    function moveResourceToOtherResourceGroup() {
		    	var checkId = $("input:checkbox[id='chk']:checked");
	    		
		    	if (checkId.length < 1) {
		    		alert("<spring:message code="ezResource.gha04" />");
		    		return;
		    	} else if (checkId.length > 1) {
		    		alert("<spring:message code="ezResource.gha03" />");
		    		return;
		    	}
		    	
		    	var para = new Array();
				var retVal = new Array();
				var url = "/ezResource/resOrganToMoveResource.do";
				para[1] = pCompanyID;
				para[2] = pBrdid;
				para[3] = $(checkId[0]).attr("value");
				para[4] = $(checkId[0]).attr("ownerId");
				
				if (CrossYN()) {
				    organ_cross_dialogArguments[0] = para;

				    var OpenWin = window.open(url, "organ", GetOpenWindowfeature(460, 440));
			        try { OpenWin.focus(); } catch (e) { }
				} else {
				    retVal = window.showModalDialog(url, para, "dialogWidth:480px;dialogHeight:440px;status:no;help:no;scroll:no");
				}
		    }
		</script>
	</head>
	<body class="mainbody">
		<h1 style="text-overflow:ellipsis;overflow:hidden;"><c:out value='${brdNm}' /><span id="TitleInfo" style="color:#666;font-weight:normal;"></span></h1>

		<div id="mainmenu">
  			<ul>
    			<c:if test="${adminFg eq 'Y'}">
    				<li class="important"><span onClick="btnAdd_Click();"><spring:message code='ezResource.t363' /></span></li>
    			</c:if>
    			<li><span onClick="btnModify_Click();"><spring:message code='ezResource.t364' /></span></li>
    			<li><span class="icon16 icon16_delete" onClick="btnDelete_Click();"></span></li>
    			<li><span onClick="btnCcalendar_Click();"><spring:message code='ezResource.t400' /></span></li>
    			<li><span onClick="moveResourceToOtherResourceGroup();"><spring:message code='ezResource.gha06' /></span></li>
    			<li>
            		<span onclick="resourceOrderUp()"><img src="/images/ImgIcon/prev.gif" style="margin-top: -4px;" alt="up"></span>
		        </li>
	            <li>
            		<span onclick="resourceOrderDown()"><img src="/images/ImgIcon/next.gif" style="margin-top: -4px;" alt="down"></span>
		        </li>
  			</ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<div id="contentlist" style="width:100%;">
			<table class="mainlist" style="width:100%; min-width:700px;">
	  			<tr>
	    			<th style="padding:0px; width:30px"><input type="checkbox" name="checkbox" onClick="reverse(this.checked)" id="Checkbox1"></th>
	    			<th> <spring:message code='ezResource.t39' /></th>
	    			<%-- <th style="width:120px"> <spring:message code='ezResource.t366' /></th> --%>
	    			<th style="width:100px"> <spring:message code='ezResource.t106' /></th>
	    			<%-- <th style="width:100px"> <spring:message code='ezResource.t37' /></th> --%>
	    			<th style="width:120px" title="<spring:message code="ezResource.max.ygs01" />"> <spring:message code="ezResource.max.ygs01" /></th>
	    			<th style="width:120px"> <spring:message code="ezResource.max.ygs02" /></th>
	    			<th style="width:120px"> <spring:message code='ezResource.t367' /></th>
	    			<th style="width:120px"> <spring:message code='ezPersonal.t1024' /></th>
	    			<th style="width:150px;"> <spring:message code='ezResource.t148' /></th>	    			
	  			</tr>
				<c:if test="${!empty resBrdList}" >
					<c:forEach var="list"  items="${resBrdList}" begin="${start}" varStatus="value">
	  					<tr>
	    					<td style="padding:0;"><input type="checkbox" name="chk" id="chk" value="${list.brdID}" ownerid="${list.ownerID}"></td>
							<td ondblclick="Item_View('${list.brdID}');"	style="cursor: pointer; word-wrap:break-word;" align="left">
								<c:choose>
									<c:when test="${list.approveFlag eq 0}">
										<span class="sub_iconLNB tree_resource_standard" style="margin-top: 0px;"></span>
									</c:when>
									<c:when test="${list.approveFlag eq 1}">
										<span class="sub_iconLNB tree_resource_ok" style="margin-top: 0px;"></span>
									</c:when>
									<c:otherwise>
										<span class="sub_iconLNB tree_resource_unused" style="margin-top: 0px;"></span>
									</c:otherwise>
								</c:choose>
								<%-- <c:if test="${list.approveFlag eq 0}">
									<span class="sub_iconLNB tree_resource_standard" style="margin-top: 0px;"></span>
								</c:if>
								<c:if test="${list.approveFlag eq 1}">
									<span class="sub_iconLNB tree_resource_ok" style="margin-top: 0px;"></span>
								</c:if> --%>
								<c:out value='${list.brdNm}' />
							</td>
							<%-- <td id="OwnDeptID" value="${list.ownDeptNm}" style="word-wrap:break-word;"><nobr>${list.ownDeptNm}</nobr> </td> --%>
							<td id="OwnerID"  style="word-wrap:break-word;" value="${list.ownerID}" nowrap>${list.ownerNm}
								<c:set var="ownerList" value="${fn:split(list.ownerID, ',') }"/>
								<c:if test="${fn:length(ownerList) > 1 }">
									<spring:message code='ezCircular.t50'/> <c:out value="${fn:length(ownerList)-1}"/><spring:message code='ezCircular.t51'/>
								</c:if>
							</td>
							<%-- <td id="OwnerPosition" style="word-wrap:break-word;">${list.ownerPosition}</td> --%>
							<td id="ResMaxDate" style="word-wrap:break-word;"><c:out value="${list.resMaxDate}"/><c:if test="${not empty list.resMaxDate}"><spring:message code="ezResource.max.ygs04" /></c:if></td> <!-- 2024-09-02 최대 예약 가능 기간 추가 -->
							<td id="ResMaxUserCnt" style="word-wrap:break-word;"><c:out value="${list.resMaxUserCnt}"/><spring:message code="ezResource.max.ygs03" /></td> <!-- 2024-09-02 정원 추가 -->	
							<td id="OwnerCall" style="word-wrap:break-word;">${list.ownerCall} </td>			
							<td id="makeDate" style="word-wrap:break-word;">${list.makeDate} </td>		
							<td id="ResLocation" style="word-wrap:break-word;"><c:out value='${list.resLocation}'/></td>				<!-- 2018-07-13 김민성 - 테이블 형식에서는 정보 모두 출력하도록 변경 -->
						</tr> 
					</c:forEach>
				</c:if>
				<c:if test="${empty resBrdList}">
					<tr>
	    				<td colspan="8" style="text-align: center"><spring:message code='main.t00026' /></td>
	    			</tr>
				</c:if>
			</table>
		</div>
		<br/>
    	<div id="tblPageRayer"></div>
	</body>
</html>