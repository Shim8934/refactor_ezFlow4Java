<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<c:choose>
			<c:when test="${type == 'EMP'}">
				<title><spring:message code='ezPersonal.t299'/></title>
			</c:when>
			<c:otherwise>
				<title><spring:message code='ezPersonal.t59'/></title>
			</c:otherwise>
		</c:choose>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script src="/js/ezPersonal/controls/TreeView.js" type="text/javascript"></script>
		<script src="/js/ezPersonal/ListView_list.js" type="text/javascript"></script>
		<script type="text/javascript">
		    var type = "${type}";
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            ReturnFunction = parent.selectperson_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                ReturnFunction = opener.selectperson_cross_dialogArguments[1];
		            } catch (e) {
		                
		            }
		        }
		
		
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                var input = document.getElementsByTagName("input");
		                for (var i = 0; i < input.length; i++) {
		                    if (input[i].getAttribute("type") == "text")
		                        KeEventControl(input[i]);
		                }
		            }
		
		            var xmlpara = createXmlDom();
		            var xmlTree = createXmlDom();
		            var xmlHTTP = createXMLHttpRequest();
		            var objNode;
		
		            if (type == "Proxy") {
		                createNodeInsert(xmlpara, objNode, "DATA");
		                createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${userInfo.deptID}");
		                createNodeAndInsertText(xmlpara, objNode, "TOPID", "${userInfo.deptID}");
		                createNodeAndInsertText(xmlpara, objNode, "PROP", "");
		            }
		            else {
		                createNodeInsert(xmlpara, objNode, "DATA");
		                createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${userInfo.deptID}");
		                createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top");
		                createNodeAndInsertText(xmlpara, objNode, "PROP", "");
		            }
		            xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
		            xmlHTTP.send(xmlpara);
		
		            xmlTree = loadXMLString(xmlHTTP.responseText);
		            var treeXML = loadXMLFile("/xml/ezPersonal/organtree_config.xml");
		            document.getElementById('TreeView').innerHTML = "";
		
		            var treeView = new TreeView();
		            treeView.SetConfig(treeXML);
		            treeView.SetID("FromTreeView");
		            treeView.SetUseAgency(true);
		            treeView.SetRequestData("RequestData");
		            treeView.SetNodeClick("TreeViewNodeClick");
		            treeView.DataSource(xmlTree);
		            treeView.DataBind("TreeView");
		        }
		        catch (ErrMsg) {
		            alert(" TreeViewinitialize : " + ErrMsg.description);
		        }
		    };
		    function RequestData(pNodeID, pTreeID) {
		        var TreeIdx = pNodeID;
		
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		
		        var deptID = treeNode.GetNodeData("CN");
		
		        GetDeptSubTreeInfo(deptID, TreeIdx);
		    }
		
		    function GetDeptSubTreeInfo(deptID, TreeIdx) {
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlRtn = createXmlDom();
		        var xmlpara = createXmlDom();
		
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "DATA");
		        createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptID);
		        createNodeAndInsertText(xmlpara, objNode, "PROP", "");
		
		        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
		        xmlHTTP.send(xmlpara);
		
		        xmlRtn = loadXMLString(xmlHTTP.responseText);
		
		        if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
		            if (CrossYN()) {
		                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
		            }
		            else {
		                xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
		            }
		        }
		
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
		    }
		    function TreeViewNodeClick() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		
		        var nodeIdx = treeView.GetSelectNode();
		        displayUserList(nodeIdx.GetNodeData("CN"));
		    }
		    function displayUserList(DeptID) {
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezOrgan/getDeptMemberList.do",
		    		data : {
		    				deptID   : DeptID, 
		    				cell 	 : "company;description;displayName;title;telephoneNumber",
		    				prop     : "department",
		    				type 	 : "user"
		    				},
		    		success: function(xml){
		    			event_displayUserList(loadXMLString(xml));
		    		},
		    		error: function(request, status){
		    			alert("<spring:message code='ezPersonal.t60'/>" + request.status);
		    		}
		    	});
		    }
		    function event_displayUserList(xml) {
                document.getElementById("OrganListView").innerHTML = "";
                var listview = new ListView();
                listview.SetID("Organ");
                listview.SetSelectFlag(false);
                listview.SetMulSelectable(true);
                listview.SetRowOnDblClick("select_member");
                listview.DataSource(loadXMLString(listviewheader.innerHTML.toUpperCase()));
                listview.DataBind("OrganListView");
                listview.DataSource(xml);
                listview.RowDataBind();
		    }
		    function search_press(e) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		                search_click();
		            }
		        }
		        else {
		            if (e.which == 13)
		                search_click();
		        }
		    }
		    function deptsearch_press(e) {
		        if (window.event) {
		            if (window.event.keyCode == 13) {
		                deptsearch_click();
		            }
		        }
		        else {
		            if (e.which == 13)
		                deptsearch_click();
		        }
		    }
		    function search_click() {
		        if (document.getElementById("keyword").value == "") {
		            alert("<spring:message code='ezPersonal.t61'/>");
		            document.getElementById("keyword").focus();
		            return;
		        }
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezOrgan/getSearchList.do",
		    		data : {
		    			search : document.getElementById("search_type").value + "::" + document.getElementById("keyword").value,
		    			cell   : "company;description;displayname;title;telephonenumber",
		    			prop   : "department",
		    			type   : "user"
		    		},
		    		success: function(xml){
		    			event_displayUserList(loadXMLString(xml));
		    		}        			
		    	});
		    }
		    var checkname2_cross_dialogArguments = new Array();
		    var rgParams = new Array();
		    function deptsearch_click() {
		
		        if (deptkeyword.value == "") {
		            alert("<spring:message code='ezPersonal.t61'/>");
		            deptkeyword.focus();
		            return;
		        }
		        var result = "";
		        var xmlDom = createXmlDom();
		        
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezOrgan/getSearchList.do",
		    		data : {
		    			search : "displayname::" + deptkeyword.value,
		    			cell   : "extensionAttribute3;displayname;extensionAttribute9;",
		    			prop   : "",
		    			type   : "group"
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		},
		    		error: function(request, status){
		    			alert("<spring:message code='ezPersonal.t62'/>" + request.status);
		    		}
		    	});
		    	
                xmlDom = result;
                adCount = xmlDom.getElementsByTagName("ROW").length;
		
		        if (adCount == 0) {
		            alert("<spring:message code='ezPersonal.t63'/>");
		            return;
		        }
		        else if (adCount == 1) {
		            bSearch = true;
		            g_xmlHTTP = createXMLHttpRequest();
		            var strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		        else {
		            
		            rgParams["addrBook"] = xmlDom;
		            rgParams["deptid"] = "";
		            var feature = "dialogHeight:320px; dialogWidth:600px; status:no;scroll:no; help:no; edge:sunken";
		            feature = feature + GetShowModalPosition(600, 320);
		
		
		            if (CrossYN()) {
		                checkname2_cross_dialogArguments[0] = rgParams;
		                checkname2_cross_dialogArguments[1] = deptsearch_click_Complete;
		                var OpenWin = window.open("/ezPersonal/checkName2.do", "checkName2_cross", GetOpenWindowfeature(600, 320));
		                try { OpenWin.focus(); } catch (e) { }
		            }
		            else {
		                window.showModalDialog("/ezPersonal/checkName2.do", rgParams, feature);
		
		                if (rgParams["deptid"] != "") {
		                    bSearch = true;
		                    g_xmlHTTP = createXMLHttpRequest();
		                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
		                    g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		                    g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		                    g_xmlHTTP.send(strQuery);
		                }
		            }
		        }
		    }
		    function deptsearch_click_Complete() {
		        if (rgParams["deptid"] != "") {
		            bSearch = true;
		            g_xmlHTTP = createXMLHttpRequest();
		            var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP></DATA>";
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		    }
		
		    function event_getDeptFullTree() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.statusText == "OK") {
		                if (!bSearch) {
		                    try {
		                        if (CrossYN())
		                            opener.opener.top.organview = g_xmlHTTP.responseXML;
		                        else
		                            window.dialogArguments["window"].opener.top.organview = g_xmlHTTP.responseXML;
		                    }
		                    catch (e) { }
		                }
		
		                var treeXML = loadXMLFile("/xml/ezPersonal/organtree_config.xml");
		                document.getElementById('TreeView').innerHTML = "";
		
		                var treeView = new TreeView();
		                treeView.SetConfig(treeXML);
		                treeView.SetID("FromTreeView");
		                treeView.SetUseAgency(true);
		                treeView.SetRequestData("RequestData");
		                treeView.SetNodeClick("TreeViewNodeClick");
		                treeView.DataSource(g_xmlHTTP.responseXML);
		                treeView.DataBind("TreeView");
		            }
		            else {
		                alert("<spring:message code='ezPersonal.t17'/>" + g_xmlHTTP.statusText);
		                g_xmlHTTP = null;
		            }
		        }
		    }
		    function select_member() {
		        var listview = new ListView();
		        listview.LoadFromID("Organ");
		        var tr = listview.GetSelectedRows();
		        var length = tr.length;
		        if (length == 0) {
		            alert("<spring:message code='ezPersonal.t65'/>");
		            return;
		        }
		        if (length > 1) {
		            alert("<spring:message code='ezPersonal.t66'/>");
		            return;
		        }
		        var selRow = tr[0];
		        if (type == "Proxy") {
		            if ("${userInfo.deptID}" != selRow.getAttribute("DATA3")) {
		                alert("<spring:message code='ezPersonal.t400'/>");
		                return;
		            }
		        }
		        if (ReturnFunction != null) {
		            if (type == "EMP")
		                ReturnFunction(selRow.getAttribute("DATA2") + ":" + selRow.cells[2].textContent + ":" + selRow.cells[1].textContent + ":" + selRow.cells[3].textContent + ":" + selRow.getAttribute("DATA3"));
		            else
		                ReturnFunction(selRow.getAttribute("DATA2") + ":" + selRow.cells[2].textContent + ":" + selRow.getAttribute("DATA3"));
		        }
		        else {
		            if (type == "EMP")
		                window.returnValue = selRow.getAttribute("DATA2") + ":" + selRow.cells[2].textContent + ":" + selRow.cells[1].textContent + ":" + selRow.cells[3].textContent + ":" + selRow.getAttribute("DATA3");
		            else
		                window.returnValue = selRow.getAttribute("DATA2") + ":" + selRow.cells[2].textContent + ":" + selRow.getAttribute("DATA3");
		        }
		        window.close();
		    }
		</script>
	</head>
	<body class="popup">
		<xml id="listviewheader" style="display:none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.t67'/></NAME>
		        <WIDTH>50</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.t7'/></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.t68'/></NAME>
		        <WIDTH>50</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.t69'/></NAME>
		        <WIDTH>50</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.t70'/></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<c:choose>
			<c:when test="${type == 'EMP'}">
				<h1> <spring:message code='ezPersonal.t299'/></h1>
			</c:when>
			<c:otherwise>
				<h1>
					<c:choose>
						<c:when test="${type != 'Proxy'}">
							<spring:message code='ezPersonal.t59'/>
						</c:when>
						<c:otherwise>
							<spring:message code='ezPersonal.t401'/>
						</c:otherwise>
					</c:choose> 
				</h1>
			</c:otherwise>
		</c:choose>
		<div id="close">
			<ul>
				<li>
					<span onClick="window.close()" style="cursor:pointer">
						<spring:message code='ezPersonal.t10'/>
					</span>
				</li>
			</ul>
		</div>
		<table>
		  <tr>
		    <td style="padding-right:5px">
		    	<c:if test="${type != 'Proxy'}">
				    <input type="text" id="deptkeyword" onKeyPress="deptsearch_press(event)" style="WIDTH:115px">
				    <a class="imgbtn" style="vertical-align:bottom"><span onclick="deptsearch_click()"><spring:message code='ezPersonal.t71'/></span></a>
		    	</c:if>
		    </td>
		    <td>
		    	<c:if test="${type != 'Proxy'}">
			    	<select id="search_type">
			              <option selected value="displayname"><spring:message code='ezPersonal.t9'/></option>
			              <option value="description"><spring:message code='ezPersonal.t7'/></option>
			              <option value="title"><spring:message code='ezPersonal.t69'/></option>
			              <option value="telephonenumber"><spring:message code='ezPersonal.t70'/></option>
			              <option value="mobile"><spring:message code='ezPersonal.t72'/></option>
			              <option value="HomePhone"><spring:message code='ezPersonal.t73'/></option>
			              <option value="facsimileTelephoneNumber"><spring:message code='ezPersonal.t74'/></option>
			              <option value="mail"><spring:message code='ezPersonal.t75'/></option>
			              <option value="streetAddress"><spring:message code='ezPersonal.t76'/></option>
			        </select>
			        <input type="text" id="keyword" onKeyPress="search_press(event)" style="WIDTH:130px">
			        <a class="imgbtn" style="vertical-align:bottom"><span onClick="search_click()"><spring:message code='ezPersonal.t77'/></span></a>
		    	</c:if> 
		    </td>
		  </tr>
		  <tr>
		    <td style="padding-right:5px"><div class="box" style="OVERFLOW-Y:auto; OVERFLOW-X:hidden; WIDTH:235px; HEIGHT:340px;" id="TreeView" ></div></td>
		    <td class="listview">
		        <div id="OrganListView" style="border:0;OVERFLOW: auto; WIDTH: 385px; HEIGHT: 340px; BACKGROUND-COLOR: white"></div></td>
		  </tr>
		</table>
		<div class="btnposition">
		    <a class="imgbtn" onClick="select_member()" ><span><spring:message code='ezPersonal.t12'/></span></a>
		    <a class="imgbtn" onClick="window.close()"><span><spring:message code='ezPersonal.t13'/></span></a>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
	</body>
</html>