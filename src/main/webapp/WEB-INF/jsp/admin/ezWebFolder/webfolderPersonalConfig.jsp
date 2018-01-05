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
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>
		<script type="text/javascript" >
			var topid = "<c:out value='${topid}'/>";
			
		 	document.onselectstart = function(){
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA"){
		            return false;
		        }else{
		            return true;
		        }
		    };
		    
		    $(document).ready(function(){
		    	getDeptFullTree(topid);
		    });		    
		    
		    function Tree_setconfig(){
			    var xmlHTTP = createXMLHttpRequest();
			    xmlHTTP.open("GET", "/xml/common/organtree_config3.xml", false);			    
			    xmlHTTP.send();
			    if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200){
			        var treeView = new TreeView();			        
			        treeView.SetConfig(xmlHTTP.responseXML);
			    }
			}		    
		    
		    function getDeptFullTree(deptid){
			    g_xmlHTTP = createXMLHttpRequest();
				var strQuery = "<DATA><DEPTID>" + deptid + "</DEPTID><TOPID>" + topid + "</TOPID><PROP>extensionAttribute1;extensionAttribute2;displayName</PROP></DATA>";

				g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
				g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
				g_xmlHTTP.send(strQuery);
			}
		    
			function event_getDeptFullTree(){
				if(g_xmlHTTP != null && g_xmlHTTP.readyState == 4){
					if (g_xmlHTTP.statusText == "OK"){
					    Tree_setconfig();
		                document.getElementById("TreeView").innerHTML = "";
					    var treeView = new TreeView();
					    treeView.SetID("FromTreeView");
					    treeView.SetUseAgency(true);
					    treeView.SetRequestData("TreeViewRequestData");
					    treeView.SetNodeClick("TreeViewNodeClick");
					    treeView.SetNodeDblClick("TreeViewNodeDbClick");
					    treeView.DataSource(g_xmlHTTP.responseXML);
					    treeView.DataBind("TreeView");
					}else{	
						alert("<spring:message code='ezOrgan.t1' />" + g_xmlHTTP.statusText);
						g_xmlHTTP = null;
					}
				}
			}			
			
			function TreeViewRequestData(pNodeID, pTreeID) {
		        document.getElementById("TreeView").style.height = "509px";
		        var TreeIdx = pNodeID;

			    var treeNode = new TreeNode();
			    treeNode.LoadFromID(TreeIdx);

			    var deptID = treeNode.GetNodeData("CN");
			    GetDeptSubTreeInfo(deptID, TreeIdx);
			    document.getElementById("TreeView").style.height = "510px";
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
			    
			    if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
			        if (CrossYN()){
			            xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
			        }else{
			            xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
			        }
			    }

			    var treeView = new TreeView();
			    treeView.LoadFromID("FromTreeView");
			    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
			}
			
			function TreeViewNodeClick() {
			    var nodeIdx = 1;
			    var treeView = new TreeView();
			    treeView.LoadFromID("FromTreeView");
			    var selnode = treeView.GetSelectNode();
			    DeptID = selnode.GetNodeData("CN");
			    displayUserList(DeptID);
			}
			
			function TreeViewNodeDbClick(){
			    return;
			}			
			
			function displayUserList(DeptID){		        
				var cellContent;
				var typeContent;

				cellContent = "displayname;description;title";
				typeContent = "userWithMasterAdmin";
				
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	data : {deptID : DeptID, cell : cellContent, prop : "", type : typeContent},
		        	success : function(xml){
				        var listElmt = document.getElementById("bnkUserData");
				        listElmt.innerHTML = "";				        
		        		result = loadXMLString(xml);
				        
				        var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0].getElementsByTagName("ROW");
				        
				        if (xmlRtn.length > 0) {				        
					        for (var i = 0; i < xmlRtn.length; i++) {
					        	var trElmt    = document.createElement("tr");
					        	var tdElmt1   = document.createElement("td");
					        	var tdElmt2   = document.createElement("td");
					        	var tdElmt3   = document.createElement("td");
					        	var inputElmt = document.createElement("input");
					        	var spanElmt  = document.createElement("span");
					        	
					        	tdElmt1.setAttribute("align", "left");
					        	tdElmt1.setAttribute("style", "overflow: hidden; text-overflow: ellipsis; white-space: nowrap;");
					        	
					        	tdElmt2.setAttribute("align", "left");
					        	tdElmt2.setAttribute("style", "overflow: hidden; text-overflow: ellipsis; white-space: nowrap;");
					        	
					        	tdElmt3.setAttribute("align", "left");
					        	tdElmt3.setAttribute("style", "overflow: hidden; text-overflow: ellipsis; white-space: nowrap;");
					        	
					        	inputElmt.setAttribute("type", "text");
					        	inputElmt.setAttribute("style", "width: 80px; margin-right: 5px;");
					        	spanElmt.textContent = "MB";       
	
					        	tdElmt1.innerHTML = SelectSingleNodeValue(xmlRtn[i].getElementsByTagName("CELL")[0], "VALUE");
					        	tdElmt2.innerHTML = SelectSingleNodeValue(xmlRtn[i].getElementsByTagName("CELL")[1], "VALUE");
					        	tdElmt3.appendChild(inputElmt);
					        	tdElmt3.appendChild(spanElmt);
					        	
					        	trElmt.appendChild(tdElmt1);
					        	trElmt.appendChild(tdElmt2);
					        	trElmt.appendChild(tdElmt3);
					        	
					        	listElmt.appendChild(trElmt);
					        }      
				        }
				        else {
				        	var trElmt    = document.createElement("tr");
				        	var tdElmt    = document.createElement("td");
				        	var textElmt  = document.createTextNode(strLang535);
				        	tdElmt.setAttribute("align", "center");
				        	tdElmt.setAttribute("colspan", "3");
				        	
				        	tdElmt.appendChild(textElmt);
				        	trElmt.appendChild(tdElmt);
				        	listElmt.appendChild(trElmt);
				        }
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezOrgan.t2'/>" + error);	
		        	}
		        });	
			}			    
	    </script>
	</head>
	<body class="mainbody">
	   <h1><spring:message code='ezWebFolder.t103' /></h1>
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
		   	<input type="hidden" name="selectedCN" id="selectedCN" />
			<input type="hidden" name="selectedValue" id="selectedValue" />
			<form name="sendForm">
				<input type="hidden" name="userSend" id="userSend" />
			</form>
			
			<table style="margin-top:10px">
				<tr>
					<th><spring:message code='ezOrgan.t73' /></th>
					<th>용량 관리</th>				
				</tr>
			    <tr>
			        <th style="padding: 3px; text-align: left; font-weight: normal;vertical-align:top">
			            <div style="border: 1px solid #b6b6b6; height: 510px; width: 350px; overflow: auto; background-color: #FFFFFF" id="TreeView"></div>
			        </th>
			        <th style="padding: 3px; text-align: left;vertical-align:top">
			            <div class="listview">
			                <div id="OrganListView" style="border: 0px solid #B6B6B6; Width: 450px; Height: 510px; overflow-x: hidden; BACKGROUND-COLOR: white; overflow-y:scroll; ">
			                	<table id="bnkUsersTable" class="mainlist_free" width="100%">
			                		<thead id="">
			                			<tr id="" class="" style="background-color: rgb(255, 255, 255);">
			                				<th id="" class="h4_center" bgcolor="#CCCCCC" width="40px"><spring:message code='ezOrgan.t67' /></th>
			                				<th id="" class="h5_center" width="80px"><spring:message code='ezOrgan.t68' /></th>
			                				<th id="" class="h5_center" width="50px">저장크기</th>
			                			</tr>
			                		</thead>
			                		<tbody style="background-color: rgb(255, 255, 255);" id="bnkUserData">		                	
			                			
			                		</tbody>
			                	</table>
			                </div>
			            </div>
			        </th>
			    </tr>
			</table>
	     <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="progressPanel">&nbsp;</div>
	     <span class="loading_layer" style="z-index:6000;position:absolute;top:350px;left:350px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t680' /></span></span> 	
	   </div>
	   <div style="margin: 10px 70px;">
		   <a class="imgbtn"><span onclick="">저장</span></a>
		   <a class="imgbtn"><span onclick="">취소</span></a>
	   </div>
	</body>
</html>