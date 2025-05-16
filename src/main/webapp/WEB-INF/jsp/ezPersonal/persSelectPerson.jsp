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
			<c:when test="${type == 'selDeptMaster'}">
				<title><spring:message code='ezEmail.jje17'/></title>
			</c:when>
			<c:otherwise>
				<title><spring:message code='ezPersonal.t401'/></title>
			</c:otherwise>
		</c:choose>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/ListView_list.js')}"></script>
		<script type="text/javascript">
		    var type = "<c:out value='${type}'/>";
		    var tagName = "${tagName}";
		    var ReturnFunction;
		    var userID = "${userInfo.id}";
		    var companyID = "${companyID}";
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
		            else if (type == "selDeptMaster") {
		                createNodeInsert(xmlpara, objNode, "DATA");
		            	createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${userInfo.deptID}");
		            	
		            	if ("${userInfo.rollInfo}".indexOf("c=1") != -1) {
		            		createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top/organ");
		            	} else {
			                createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top");
		            	}
		            	
		                createNodeAndInsertText(xmlpara, objNode, "PROP", "");
		            }
					else if (type === "EMP") {
						createNodeInsert(xmlpara, objNode, "DATA");
						createNodeAndInsertText(xmlpara, objNode, "DEPTID", companyID);
						createNodeAndInsertText(xmlpara, objNode, "TOPID", companyID);
						createNodeAndInsertText(xmlpara, objNode, "ADMINCHK", true);
						createNodeAndInsertText(xmlpara, objNode, "PROP", "");
					} else {
		                createNodeInsert(xmlpara, objNode, "DATA");
		                createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${userInfo.deptID}");
		                createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top");
		                createNodeAndInsertText(xmlpara, objNode, "PROP", "");
		            }
		            
		            if (type == "EMP" || type == "selDeptMaster") {
		            	createNodeAndInsertText(xmlpara, objNode, "DISPLAYTRASHDEPT", "true");
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
		            showAlert(" TreeViewinitialize : " + ErrMsg.description);
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
		    				cell 	 : "company;description;displayName;title;telephoneNumber;extensionattribute5",
		    				prop     : "department",
		    				type 	 : "user"
		    				},
		    		success: function(xml){
		    			event_displayUserList(loadXMLString(xml));
		    		},
		    		error: function(request, status){
		    			showAlert("<spring:message code='ezPersonal.t60'/>" + request.status);
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
		    	if (specialChk(document.getElementById("keyword").value.trim())) {
			    	showAlert("<spring:message code='ezResource.special' />");     
			    	return;
			    }
		    	
		        if (document.getElementById("keyword").value.trim() == "") {
		            showAlert("<spring:message code='ezPersonal.t61'/>");
		            document.getElementById("keyword").focus();
		            return;
		        }
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezOrgan/getSearchList.do",
		    		data : {
		    			search : document.getElementById("search_type").value + "::" + document.getElementById("keyword").value.trim(),
		    			cell   : "company;description;displayname;title;telephonenumber;extensionAttribute5",
		    			prop   : "department;userType",
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
		    	if (specialChk(document.getElementById("deptkeyword").value)) {
			    	showAlert("<spring:message code='ezResource.special' />");
			    	return;
			    }
		    	
		        if (deptkeyword.value.trim() == "") {
		            showAlert("<spring:message code='ezPersonal.t61'/>");
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
		    			search : "displayname::" + deptkeyword.value.trim(),
		    			cell   : "extensionAttribute3;displayname;extensionAttribute9;",
		    			prop   : "",
		    			type   : "group"
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		},
		    		error: function(request, status){
		    			showAlert("<spring:message code='ezPersonal.t62'/>" + request.status);
		    		}
		    	});
		    	
                xmlDom = result;
                adCount = xmlDom.getElementsByTagName("ROW").length;
		
		        if (adCount == 0) {
		            showAlert("<spring:message code='ezPersonal.t63'/>");
		            return;
		        }
		        else if (adCount == 1) {
		            bSearch = true;
		            
		            var displayTrashDeptStr = "";
		            if (type == "EMP" || type == "selDeptMaster") {
		            	displayTrashDeptStr = "<DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT>";
		            }
		            
		            g_xmlHTTP = createXMLHttpRequest();
		            
		            var strQuery = "<DATA><DEPTID>" + xmlDom.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>Top</TOPID><PROP></PROP>" + displayTrashDeptStr + "</DATA>";
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
		                var OpenWin = window.open("/ezPersonal/checkName2.do", "checkName2_cross", GetOpenWindowfeature(600, 350));
		                try { OpenWin.focus(); } catch (e) { }
		            }
		            else {
		                window.showModalDialog("/ezPersonal/checkName2.do", rgParams, feature);
		
		                if (rgParams["deptid"] != "") {
		                    bSearch = true;
		                    
		                    var displayTrashDeptStr = "";
				            if (type == "EMP" || type == "selDeptMaster") {
				            	displayTrashDeptStr = "<DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT>";
				            }
		                    
		                    g_xmlHTTP = createXMLHttpRequest();
		                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP>" + displayTrashDeptStr + "</DATA>";
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
		            
		            var displayTrashDeptStr = "";
		            if (type == "EMP" || type == "selDeptMaster") {
		            	displayTrashDeptStr = "<DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT>";
		            }
		            
		            g_xmlHTTP = createXMLHttpRequest();
		            var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP>" + displayTrashDeptStr + "</DATA>";
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		    }
		
		    function event_getDeptFullTree() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.status == 200) {
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
		                showAlert("<spring:message code='ezPersonal.t17'/>" + g_xmlHTTP.statusText);
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
		        	if (type == "EMP") {
		        		showAlert("<spring:message code='ezPersonal.bhs01'/>");
		        	} else if (type == "selDeptMaster") {
		        		showAlert("<spring:message code='ezOrgan.kyj05'/>");
		        	} else {
			            showAlert("<spring:message code='ezPersonal.t65'/>");
		        	}
		            return;
		        }
		        if (length > 1) {
		        	if (type == "EMP") {
		        		showAlert("<spring:message code='ezPersonal.bhs02'/>");
		        	} else if (type == "selDeptMaster") {
		        		showAlert("<spring:message code='ezOrgan.kyj06'/>");
		        	} else {
			            showAlert("<spring:message code='ezPersonal.t66'/>");
		        	}
		            return;
		        }
		        var selRow = tr[0];
		        if ("${userInfo.id}" == selRow.getAttribute("DATA2")) {
					if (type != "EMP" && type != "selDeptMaster") {
						showAlert("<spring:message code='ezPersonal.t16'/>");
						return;
					}
		        }		        
		        if (type == "Proxy") {
		            if ("${userInfo.deptID}" != selRow.getAttribute("DATA3")) {
		                showAlert("<spring:message code='ezPersonal.t400'/>");
		                return;
		            }
		        }
		        
                var rtnJson = new Object();
		        rtnJson.userId = selRow.getAttribute("DATA2");
		        rtnJson.deptId =  selRow.getAttribute("DATA3");
		        rtnJson.deptName = selRow.cells[1].textContent;
		        rtnJson.userName = selRow.cells[2].textContent;
		        rtnJson.jobName =  selRow.cells[3].textContent;
		        rtnJson.tagName = tagName;
		        
		        if (ReturnFunction != null) {
                    ReturnFunction(rtnJson);
		        } else {
                    window.returnValue = rtnJson;
		        }
		        window.close();
		    }
		</script>
		<style>
			.mainlist tr th{border-top:0px;}
		</style>
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
		        <NAME><spring:message code='ezPersonal.t177'/></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.b12'/></NAME>
		        <WIDTH>50</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<c:choose>
			<c:when test="${type == 'EMP'}">
				<h1> <spring:message code='ezPersonal.t299'/></h1>
			</c:when>
			<c:when test="${type == 'selDeptMaster'}">
				<h1> <spring:message code='ezEmail.jje17'/></h1>
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
					<span onClick="window.close()" style="cursor:pointer"></span>
				</li>
			</ul>
		</div>
		<table>
			<tr style="height:33px; background-color: #f8f8fa; margin-bottom : 3px; padding: 0px; border: 1px solid #eaeaea;">
			    <td style="padding-right:5px">
			    	<c:if test="${type != 'Proxy'}">
			    	<div style="padding-top: 3px;">
					    <input type="text" id="deptkeyword" onKeyPress="deptsearch_press(event)" style="width:120px; height:25px; margin-left:5px;" maxLength="50">
					    <a class="imgbtn"><span onclick="deptsearch_click()"><spring:message code='ezPersonal.t71'/></span></a>
			    	</div>
			    	</c:if>
			    </td>
			    <td align="right">
			    	<c:if test="${type != 'Proxy'}">
			    	<div style="padding-top: 3px;">
						<select id="search_type" style="height: 22px;">
				            <option selected value="displayname"><spring:message code='ezPersonal.t9'/></option>
				            <option value="description"><spring:message code='ezPersonal.t7'/></option>
				            <option value="title"><spring:message code='ezPersonal.t69'/></option>
				            <option value="telephonenumber"><spring:message code='ezPersonal.t177'/></option>
				            <option value="mobile"><spring:message code='ezPersonal.t72'/></option>
				            <option value="HomePhone"><spring:message code='ezPersonal.t73'/></option>
				            <option value="facsimileTelephoneNumber"><spring:message code='ezPersonal.t74'/></option>
				            <option value="mail"><spring:message code='ezPersonal.t75'/></option>
				            <option value="streetAddress" style="display:none"><spring:message code='ezPersonal.t76'/></option>
				        </select>
				        <input type="text" id="keyword" onKeyPress="search_press(event)" style="width:130px; height:25px;" maxLength="50">
				        <a class="imgbtn" style="margin-right:5px;"><span onClick="search_click()"><spring:message code='ezPersonal.t83'/></span></a>
				    </div>
			    	</c:if>			    	
			    </td>
		  	</tr>
		  	<tr><td colspan="2" style="padding:2px;"></td></tr>
		  	<tr>
			    <td class="box" style="padding-right:4px"><div style="overflow: auto; WIDTH:235px; HEIGHT:380px; margin-bottom:-1px;" id="TreeView" ></div></td>
			    <td class="listview">
			        <div id="OrganListView" style="border:0;OVERFLOW: auto; WIDTH: 595px; HEIGHT: 380px; BACKGROUND-COLOR: white"></div>
				</td>
		  	</tr>
		</table>
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn" onClick="select_member()" ><span><spring:message code='ezPersonal.t12'/></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
