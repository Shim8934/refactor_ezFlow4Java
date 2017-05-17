<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	<script type="text/javascript" src="/js/ezResource/organtreeview.htc.js"></script>
	<script type="text/javascript" src="/js/TreeView.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript" src="/js/ezCircular/ResTreeInfo_cross.js"></script>
	<link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css">
	<script type="text/javascript">
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
		
		function TreeLoad() {
    		initTreeInfo("", g_UserID, g_DeptID);
    		
    		if(document.getElementById("TreeView").innerText == "") {
    			var msg = "<div style='margin-top:10px;margin-bottom:10px'><img width='183' height='27' src='/images/notify/warning01.gif'></div>";
    			msg += "<div><spring:message code='ezResource.t368' /></div>";
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
		
	    function boardConfig() {
	        window.parent.frames["right"].location.href = "/ezBoard/boardConfig.do";
	    }
	</script>
</head>
<body class="leftbody" style="overflow: auto;">
	<div id="left" style="overflow:auto">
	<div class="left_resource" title="CIRCULAR"></div>
        <h2 style="background-color:#FFFFFF;"><spring:message code="ezCircular.t1" /></span></h2>
        <ul style="overflow-x:auto;overflow-y:auto;">
            <div class="tree" id="TreeView" style="height:auto;border:#b6b6b6 0px solid; background-color:#ffffff; vertical-align:top;padding-left:20px;background-color:#ffffff;" ></div>
        </ul>
    <h3>
        <span onclick="boardConfig()" style="width:100%; display:inline-block;"><spring:message code="ezBoard.t0005" /></span>
    </h3>
	</div>
	<script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
	</script>
</body>
</html>