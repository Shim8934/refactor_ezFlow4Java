<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/email_tree.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/Controls_cross/treeview.htc.js"></script>	    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='main.lhm02' />" type="text/css">
	    <script type="text/javascript">
// 	        var pUse_Editor = "${useEditor}";
// 	        var subCode = "${subCode}";
	        var funcCode = "${funCode}";
// 	        var g_firstOpen = true;
// 	        var lang = "${userinfo.lang}";
// 	        var pNoneActiveX = "${noneActiveX}";
// 	        var reloadRetryCount = 1;
	        
	        document.onselectstart = function () { return false; };
	        window.onresize = function () {
	            if (document.documentElement.clientHeight > 900) {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.58) + "px";	                
	            }
	            else {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.38) + "px";	                
	            }
	        }
	        window.onload = function () {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            if (document.documentElement.clientHeight > 900) {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.58) + "px";	                
	            }
	            else {
	                document.getElementById("PostTreeView").style.maxHeight = parseInt(document.documentElement.clientHeight * 0.38) + "px";	                
	            }	            
	            Function_Flag(funcCode);
	            
	            /* 2017-05-18 장진혁 신규회람판에 클릭이벤트 생성 */ 
	            $("#newCircular").click();
	        }
	        
	        function LoadEmailTree() {
	            var PostTreeView = new TreeView('PostTreeView', 'PostTreeView');
	            PostTreeView.attachEvent('requestdata', requestdata);
	            PostTreeView.attachEvent('nodeselect', selectnode);
	            PostTreeView.attachEvent('nodedblclick', function () { PostTreeView.toggle(PostTreeView.selectedIndex()) });
	            PostTreeView.dragdrop(true);
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
	            xmlHTTP.send();
	            var treeconfig;
	            if (CrossYN()) {
	                treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
	            }
	            else
	                treeconfig = xmlHTTP.responseXML;

	            PostTreeView.config(treeconfig);
	            PostTreeView.source("<tree><nodes>" + document.getElementById("RootFolderXML").innerHTML + "</nodes></tree>");
	            PostTreeView.update();
	        }
	        
	        function requestdata(event) {
	            if (!event) event = window.event;
	            var nodeIdx = event.nodeIdx;
	            if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
	                nodeIdx = arguments[0].nodeIdx;
	            }
	            var childxml = get_childXML(PostTreeView.getvalue(nodeIdx, "href"), false, true);
	            PostTreeView.putchildxml(nodeIdx, childxml);
	        }
	        
	        function selectnode() {
	            var nodeIdx = PostTreeView.selectedIndex();
	            var folderId = PostTreeView.getvalue(nodeIdx, "href");
	            
	            var url = "/ezCircular/circularFolderDoc.do?folderId=" + folderId;
 	            
				window.open(url, "right");
	        }

	        function Function_Flag(v_data) {
	            v_data = parseInt(v_data);
	
	            switch (v_data) {
	                case 1:
	                    LoadEmailTree();
	                    break;
	                case 2:
	                    LoadEmailTree();
	                    WebPartToggle(level1El.item(1));
	                    break;
	            }
	        }

	        function WebPartToggle(obj) {
	
	            if (obj.listNum && currentListNum != obj.listNum + 1) {
	                level1El.item(currentListNum - 1).className = null;
	                level2El.item(currentListNum - 1).className = "off";
	            }
	
	            if (level2El.item(obj.listNum).className == "on") {
	                level1El.item(obj.listNum).className = null;
	                level2El.item(obj.listNum).className = "off";
	            }
	            else {
	                level1El.item(obj.listNum).className = "on";
	                level2El.item(obj.listNum).className = "on";
	            }
	
	            currentListNum = obj.listNum + 1;
	
	            setMenu(level2El.item(obj.listNum));
	        }

	        /* 2017-05-17 장진혁 구현 */	        
	        function openFolder() {
	        	if ($("#PostTreeView").height() != "0"){	        	
		        	$("#PostTreeView").height("0px");	        	
		        	$("#PostTreeView").css("padding","0px");
		        	$("#openImg").attr("src", "/images/expnd.gif");
		        	$("#circularDoc").css("border-bottom", "0px");
	        	} else {
	        		$("#PostTreeView").height("200px");	        	
		        	$("#PostTreeView").css("padding","10px 20px");
		        	$("#openImg").attr("src", "/images/cllps.gif");
		        	$("#circularDoc").css("border-bottom", "1px solid #dedede");
	        	}
	        }
	        
	        function folder_Manage() {
	        	var OpenWin = window.open("/ezCircular/circularFolderManage.do", "", GetOpenWindowfeature(500, 500));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        
	        /* 2017-05-17 정수현 구현 */
	        function newCircular() {                
	        	window.parent.frames["right"].location.href = "/ezcircular/newCircular.do";
	        }
	        
	        function circularComplete() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularComplete.do";
	        }
	        
	        function circularMyCircular() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularMyCircular.do";
	        }
	        
	        function circularTemp() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularTemp.do";
	        }
	        
	        function circularDelete() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularDelete.do";
	        }
	        
	        function circularConfig() {                
	        	window.parent.frames["right"].location.href = "/ezCircular/circularConfig.do";
	        }

	        function circular_Search() {
	        	window.parent.frames["right"].location.href = "/ezCircular/circularSearchView.do";	
	        }
	    </script>
	</head>
	<body class="leftbody" style="overflow: hidden;">
	    <div id="left">
	        <div class="left_mail" title="회람판"></div>
	        <h2><span style="width: 100%; display: inline-block;"><spring:message code="ezCircular.t1" /></span></h2>				
	        <ul id="iconul">
	        	<li><span style="width:100%;display:inline-block;" id="newCircular" onClick="newCircular()"><img src="/images/ImgIcon/icon_approval.gif" width="16" height="16" class="icon"><spring:message code="ezCircular.t2" /><span id=count1></span></span></li>
				<li><span style="width:100%;display:inline-block;" id="circularComplete" onClick="circularComplete()"><img src="/images/ImgIcon/icon_ingapproval.gif" width="16" height="16" class="icon"><spring:message code="ezCircular.t3" /></span></li>
				<li><span style="width:100%;display:inline-block;" id="circularMyCircular" onClick="circularMyCircular()"><img src="/images/ImgIcon/icon_writeapproval.gif" width="16" height="16" class="icon"><spring:message code="ezCircular.t4" /></span></li>				
				<li><span style="width:100%;display:inline-block;" id="circularTemp" onClick="circularTemp()"><img src="/images/ImgIcon/icon_extraappr.gif" width="16" height="16" class="icon"><spring:message code="ezCircular.t5" /></span></li>
				<li><span style="width:100%;display:inline-block;" id="circularDelete" onClick="circularDelete()"><img src="/images/ImgIcon/deleted.gif" width="16" height="16" class="icon" style="margin-left:-1px"><span style="margin-left:1px"><spring:message code="ezCircular.t6" /></span></span></li>
				<li id="circularDoc"><span style="width:100%;display:inline-block;" onClick="openFolder()"><img src="/images/ImgIcon/icon_partapproval.gif" width="16" height="16" class="icon"><span><spring:message code="ezCircular.t7" /></span>&nbsp;&nbsp;<img src="/images/cllps.gif" id="openImg" class="icon"></span></li>	        
	            <div class="tree" style="height: 200px; background-color: #ffffff; border-bottom: 1px solid #dedede; overflow: auto; padding-left: 20px;" id="PostTreeView"></div>
	            <li style="background: url('/images/kr/left/left_dot02.gif') no-repeat 25px 9px #fff;padding: 8px 5px 7px 40px"><span onclick="circular_Search()" style="width: 100%; display: inline-block;"><spring:message code="ezCircular.t8" /></span></li>
	            <li style="background: url('/images/kr/left/left_dot02.gif') no-repeat 25px 9px #fff;padding: 8px 5px 7px 40px"><span onclick="folder_Manage()" style="width: 100%; display: inline-block;"><spring:message code="ezCircular.t9" /></span></li>	            
	        </ul>	        
	        <h3><span onclick="circularConfig()" style="width:100%;display:inline-block;"><spring:message code="ezCircular.t10" /></span></h3>
	    </div>
	    <script type="text/javascript">
	        initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	    <xml id="RootFolderXML" style="display: none;">
	    	${rootFolderXML}
	    </xml>
	</body>
</html>