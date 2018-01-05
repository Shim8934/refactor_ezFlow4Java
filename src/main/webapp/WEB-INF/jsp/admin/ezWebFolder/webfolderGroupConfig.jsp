<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	    <link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
   		<script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>	
		<script type="text/javascript" >        
			var topid = "<c:out value='${companyID}'/>";
			
			window.onload = function () {
		        var xmlpara = createXmlDom();
		        var xmlTree = createXmlDom();
		        var xmlHTTP = createXMLHttpRequest();
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "DATA");
		        createNodeAndInsertText(xmlpara, objNode, "DEPTID", "");
		        createNodeAndInsertText(xmlpara, objNode, "TOPID", "${companyID}");
		        createNodeAndInsertText(xmlpara, objNode, "PROP", "");
		        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
		        xmlHTTP.send(xmlpara);
		        xmlTree = loadXMLString(xmlHTTP.responseText);
		        var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");
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
			
			function TreeViewNodeClick() {
		        var nodeIdx = 1;
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        var selnode = treeView.GetSelectNode();
		        DeptID = selnode.GetNodeData("CN");
		        displayUserList(DeptID);
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
		        createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName");


		        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
		        xmlHTTP.send(xmlpara);


		        xmlRtn = loadXMLString(xmlHTTP.responseText);
		        {
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

		    function displayUserList(DeptID) {
		    	
		    	$.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	async : false,
		        	data : {deptID : DeptID, cell : "displayName;description", prop : "department;displayName;description;title", type : "user"},
		        	success : function(result){
		        		var retXml = createXmlDom();

		                if (document.getElementById("UserList").innerHTML != "")
		                    document.getElementById("UserList").innerHTML = "";

		                var headerData = createXmlDom();
		                headerData = loadXMLString(userlist_h.innerHTML.toUpperCase());
		                if (result != "") {
		                	var xmlDom = loadXMLString(result);
		                    if (CrossYN()) {
		                        var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
		                        var Node = headerData.importNode(xmlRtn, true);
		                        headerData.documentElement.appendChild(Node);
		                    }
		                    else {
		                        var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
		                        headerData.documentElement.appendChild(xmlRtn);
		                    }
		                }
		                var pUserList = new ListView();
		                pUserList.SetID("lvUserList");
		                pUserList.SetRowOnClick("getmailstatistics");
		                pUserList.SetSelectFlag(false);
		                pUserList.SetHeightFree(true);
		                pUserList.DataSource(headerData);
		                pUserList.DataBind("UserList");
		        	},
		        	error : function(error){
		        		OpenAlertUI(linealt2 + error)
		        	}
		        });

		    }
	    </script>
	</head>
	<body class="mainbody">
	   <xml id="userlist_h" style="display: none">
		    <LISTVIEWDATA>
		    <HEADERS>
		        <HEADER>
		        <NAME><spring:message code='ezStatistics.t1017' /></NAME>
		        <WIDTH>70</WIDTH>
		        </HEADER>
		        <HEADER>
		        <NAME><spring:message code='ezStatistics.t113' /></NAME>
		        <WIDTH>100</WIDTH>
		        </HEADER>
		    </HEADERS>
		    <ROWS></ROWS>
		    </LISTVIEWDATA>
	   </xml>
	
	   <h1><spring:message code='ezWebFolder.t104' /></h1>
	   <div id="companySelect" style="margin: 10px 10px;">
	   		<span style="font-size: 16px;"><b>회사 선택: </b></span>
	   		<select id="companyList" style="font-size: 14px;">
	   			<option>가온아이</option>
	   			<option>리딩</option>
	   			<option>아추 저죽은행</option>
	   			<option>테스트1</option>
	   			<option>테스트2</option>
	   		</select>
	   </div>
	   
	   <div id="mainSetting" style="margin: 10px 10px;">
		   <table style="width: 1150px;height:640px ;border:1px solid #b6b6b6"> 
		        <tr>
		            <td style="vertical-align:top">
		                <div style="width: 310px; height: 310px; overflow-x: auto; overflow-y: auto; border-right: 1px solid #b6b6b6;" id="TreeView"></div>
		                <div id="UserList" style="Width: 310px; Height: 330px; overflow: auto; border-right: 1px solid #b6b6b6"></div>
		            </td>
		            <td style="padding-left:20px;padding-right:20px;width: 100%; text-align: center">
		                
		            </td>
		        </tr>
		    </table>
	   </div>
	   <div style="margin: 10px 70px;">
		   <a class="imgbtn"><span onclick="">저장</span></a>
		   <a class="imgbtn"><span onclick="">취소</span></a>
	   </div>
	</body>
</html>