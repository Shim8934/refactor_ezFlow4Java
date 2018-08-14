<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t330" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('ezResource.e2', 'msg')}" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/css/style.css" />
		<link type="text/css" rel="stylesheet" href="${util.addVer('main.lhm01', 'msg')}" />
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/organtreeview.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/ResTreeInfo_cross.js')}"></script>
		<script type="text/javascript" id="clientEventHandlersJS" >
		    var brdId		= "${brdID}";			
    		var Brd_Nm		= "<c:out value='${brdNm}' />";			
    		var brdGubun	= "${brdGubun}";		
    		var g_UserID	= "${userID}";
    		var g_DeptID	= "${deptID}";
    		var g_DeptPath	= "${deptPathCode}";
    		var pCompanyID	 = "${companyID}";
    		var g_AccessCode = "${strAccessCode}";
    		var g_ServerName = "${serverName}";
    		var selectNo = "${selectNo}";

		    function TreeView_onNodeDblClick() {
        		TreeView.toggle(TreeView.selectedIndex());
    		}

		    window.onresize = function () {
        		document.getElementById("TreeView").style.height = document.documentElement.clientHeight - 125 + "px";
    		}

    		window.onload = function () {
        		document.getElementById("TreeView").style.height = document.documentElement.clientHeight - 125 + "px";
        		var TreeView = new organtreeview('TreeView', 'TreeView');
        		TreeView.attachEvent('requestdata', TreeView_onNodeExpanded);
        		TreeView.attachEvent('nodeselect', TreeView_onNodeClick);
        		TreeView.attachEvent('nodedblclick', TreeView_onNodeDblClick);

        		var xmlHTTP = createXMLHttpRequest();
        		xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
        		xmlHTTP.send();

		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
        		    TreeView.server("${serverName}");
            		TreeView.config(xmlHTTP.responseXML);
            		TreeView.update();
        		}
        		TreeLoad();
    		}

    		function locationInfo(pBrdNm) {
        		var idx = "7";
        		navigation_info = "<a href='/ezResource/resMain.do' target='main' class='n'><spring:message code='ezResource.t334' /></a>"
        		if (pBrdNm != "")
            		navigation_info += " > " + pBrdNm + "</a>";
    		}

    		/* 2018-05-21 홍승비 - 등록된 상위자원 없는 경우 메세지 출력 수정 */
    		function TreeLoad() {
        		initTreeInfo("", g_UserID, g_DeptID);
        		
        		if(document.getElementById("TreeView").innerText == "") {
        			var msg = "<spring:message code='ezResource.t368' />";
        			var strUrl = "/ezResource/nonResList.do?msg="+msg;
            		locationInfo("");
            		Navigate(strUrl);
        		}
    		}

    		function TreeView_onNodeExpanded(event) {
        		displayBrdTree.call(this, g_UserID, g_DeptID, event);
    		}

		    function TreeView_onNodeClick() {		    	
		        var i = "";
		        var arrName = "";
		        var RealPath = "";
		        var brdID = "";
		        var chkVal = false;
		        g_SelTree = TreeView;
		        var selNode = TreeView.selectedIndex();
		        if (selNode == null) {
            		var strUrl = "/ezResource/nonResList.do";
            		locationInfo(RealPath);
            		Navigate(strUrl);
        		} else {
            		nodeIdx = selNode;
            		var OriginNode = selNode;
            		if (g_AccessCode != "0") g_AccessCode = TreeView.getvalue(nodeIdx, "DATA14");
            		var number = parseInt(TreeView.getvalue(nodeIdx, "DATA3"))
            		for (i = 2; i <= number; i++) {
                		var brdID = TreeView.getvalue(nodeIdx, "DATA1");
                		var brdNm = TreeView.getvalue(nodeIdx, "DATA2");
                		var boardGubun = TreeView.getvalue(nodeIdx, "DATA7");
		
        		        if (boardGubun == "1") {
                    		if ((!chkVal && i == 2) || (chkVal && i == 3)) {
                        		RealPath = "&nbsp;<a href=" + "listResource.do?brdID=" + brdID + "&brdNm=" + encodeURIComponent(brdNm) + "&AccessCode=" + g_AccessCode + " target='right' class='n'>" + brdNm + "</a>" + RealPath;
                    		} else {
                        		RealPath = "&nbsp;<a href=" + "listResource.do?brdID=" + brdID + "&brdNm=" + encodeURIComponent(brdNm) + "&AccessCode=" + g_AccessCode + " target='right' class='n'>" + brdNm + "&nbsp;></a>" + RealPath;
                    		}
                		} else {
                    		chkVal = true;
                		}
            		}
            		locationInfo(RealPath);
            		GetTreeBrdsInfo();
        		}
    		}
	</script>
	</head>
	<body class="leftbody" style="background-color:#ffffff;">
		<div id="left">
	        <div class="left_resource" title="<spring:message code="main.t28" />"><span><spring:message code="main.t28" /></span></div>
	        <h2 style="background-color:#FFFFFF;"><span id="menu01" ><spring:message code="ezResource.t342" /></span></h2>
	        <ul style="overflow-x:hidden ;overflow-y:auto;">
	            <div class="tree" id="TreeView" style="height:auto;border:#ddd 0px solid; background-color:#ffffff; vertical-align:top;padding-left:20px;background-color:#ffffff;" ></div>
	        </ul>
	    </div>
	</body>
</html>