<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezOrgan.t248' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var g_xmlHTTP = null;
			var topid = "<c:out value='${companyID}'/>";			
			var xmlHTTP = createXMLHttpRequest();
			
		    $(document).ready(function(){
		    	var strQuery = "<DATA><DEPTID></DEPTID><TOPID>" + topid + "/organ</TOPID><PROP>extensionAttribute1;extensionAttribute2;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		    		
		    	xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		    	xmlHTTP.onreadystatechange = event_GetDeptTreeInfo;
		    	xmlHTTP.send(strQuery);
		    });
		    
		    function event_GetDeptTreeInfo() {
		    	if (xmlHTTP != null && xmlHTTP.readyState == 4) {
		        	if (xmlHTTP.status == 200) {
		            	var xmlTree = loadXMLString(xmlHTTP.responseText);
		                var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
		                var treeView = new TreeView();
		                treeView.SetConfig(treeXML);
		                treeView.SetID("FromTreeView");
		                treeView.SetUseAgency(true);
		                treeView.SetRequestData("RequestData");
		                treeView.SetNodeClick("TreeViewNodeClick");
		                treeView.DataSource(xmlTree);
		                treeView.DataBind("TreeView");

		                xmlHTTP = null;
		            } else {
		                alert("<spring:message code='ezOrgan.t13' />" + xmlHTTP.status);
		                xmlHTTP = null;
		            }
		        }
		    }
		    
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
		        createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;mail;displayName");
		        createNodeAndInsertText(xmlpara, objNode, "DISPLAY_TRASH_DEPT", "");

		        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
		        xmlHTTP.send(xmlpara);

		        xmlRtn = loadXMLString(xmlHTTP.responseText);

		        if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
		            if (CrossYN()) {
		                xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
		            } else {
		                xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
		            }
		        }
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);        
		    }
		    var selectedCompanyID = "";
		    function TreeViewNodeClick() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        nodeIdx = treeView.GetSelectNode();
		        
		        selectedCompanyID = nodeIdx.GetNodeData("extensionattribute2");
		        console.log("selectedCompanyID = ", selectedCompanyID);
		        parent.getTitleOption(selectedCompanyID);
		    }
		    
		    function deptsearch_press() {
			    if (window.event.keyCode == "13") {
			        deptsearch_click();
			        event.cancelBubble = true;
			        event.returnValue = false;
			    }
			}
		    
		    var rgParams = new Array();
			var checkname2_cross_dialogArguments = new Array();
			function deptsearch_click() {
			    if (document.all("deptkeyword").value == "") {
			        alert("<spring:message code='ezOrgan.t56' />");
		            document.all("deptkeyword").focus();
		            return;
		        }		        
		        var xmlDOM = createXmlDom();
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : false,
		        	data : {search : "displayname::" + encodeURIComponent(document.all("deptkeyword").value), cell : "extensionAttribute3;displayname;extensionAttribute9;", prop : "cn", type : 'group'},
		        	success : function(result){	
		        		xmlDOM = loadXMLString(result);
		                adCount = xmlDOM.getElementsByTagName("ROW").length;
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezOrgan.t11' />" + error);
		        		xmlDOM = null;
		        	}
		        });		        
		        
		        if (adCount == 0) {
		            alert("<spring:message code='ezOrgan.t61' />");
		            return;
		        } else if (adCount == 1) {
		            bSearch = true;
		            g_xmlHTTP = createXMLHttpRequest();

		            if (CrossYN()) {
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>" + topid + "</TOPID><PROP>extensionAttribute1;extensionAttribute2;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		            } else {
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>" + topid + "</TOPID><PROP>extensionAttribute1;extensionAttribute2;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		            }
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);  
		        } else {            
		            rgParams["addrBook"] = xmlDOM;
		            rgParams["deptid"] = "";
		            if (CrossYN()){
		                checkname2_cross_dialogArguments[0] = rgParams;
		                checkname2_cross_dialogArguments[1] = deptsearch_click_Complete;		                
		                var OpenWin = window.open("/admin/ezOrgan/checkName2.do", "checkName2_Cross", GetOpenWindowfeature(598, 340));
		                try { OpenWin.focus(); } catch (e) {console.log(e);}
		            }else{
		                var feature = "dialogHeight:340px; dialogWidth:598px; status:no;scroll:no; help:no; edge:sunken";
		                feature = feature + GetShowModalPosition(600, 340);
		                window.showModalDialog("/admin/ezOrgan/checkName2.do", rgParams, feature);

		                if (rgParams["deptid"] != "") {
		                    bSearch = true;
		                    g_xmlHTTP = createXMLHttpRequest();
		                    var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + topid + "</TOPID><PROP>mail;extensionAttribute1;extensionAttribute2;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
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
		            var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + topid + "</TOPID><PROP>mail;extensionAttribute1;extensionAttribute2;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }	        
		    }
		    var bSearch = true;
		    function event_getDeptFullTree() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.status == 200) {
		                if (!bSearch) {
		                    try {
		                        if (CrossYN()) {
		                            opener.opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
		                        } else {
		                            window.dialogArguments["window"].opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
		                        }
		                    } catch (e) {console.log(e);}
		                }

		                var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
		                document.getElementById('TreeView').innerHTML = "";

		                var treeView = new TreeView();
		                treeView.SetConfig(treeXML);
		                treeView.SetID("FromTreeView");
		                treeView.SetUseAgency(true);
		                treeView.SetRequestData("RequestData");
		                treeView.SetNodeClick("TreeViewNodeClick");
		                treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
		                treeView.DataBind("TreeView");
		            } else {
		                alert("<spring:message code='ezOrgan.t9' />" + g_xmlHTTP.status);
		                g_xmlHTTP = null;
		            }
		        }
		    }
		    
		    function OK_Click() {
			    var treeView = new TreeView();
			    treeView.LoadFromID("FromTreeView");
			    var nodeIdx = treeView.GetSelectNode();
			    var treeNode = new TreeNode();
			    treeNode.LoadFromID(nodeIdx.NodeID);

			    if (treeNode.selectedIndex != -1) {
			        return treeNode.GetNodeData("CN") + ";" + treeNode.GetNodeData("VALUE");
			    }
			}
	    </script>
	</head>
	<body>
	    <table style="width:100%;">
	        <tr>
	            <th style="background-color: #f8f8f8; border-right:0px; border-left:0px; border-top:0px; padding-left:3px;padding-top:3px">
	                <div style="width:100%; text-align:left">
	                    <input name="Input" id="deptkeyword" style="WIDTH: 110px; height:22px; margin: 0px;" onkeypress="deptsearch_press()" />
	                    <a class="imgbtn"><span onclick="deptsearch_click()"><spring:message code='ezOrgan.t93' /></span></a>
	                </div>        
	            </th>
	        </tr>
	        <tr>
	            <td>
	            	<div style="width:300px;">
		                <div style="border: 0px solid #ddd; padding-top:5px; height: 250px; width: auto; overflow-x: auto; overflow-y: auto; background-color: #FFFFFF" id="TreeView"></div>
	                </div>
	            </td>
	        </tr>
	    </table>
	</body>	
</html>