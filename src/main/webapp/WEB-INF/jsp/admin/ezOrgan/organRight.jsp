<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezBoard.t84" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href='/css/organ_tree.css' type="text/css" />
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">		
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var topid = "${topid}";
		    var useOCS = "${useOCS}";		    
		    
		    document.onselectstart = function(){
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA"){
		            return false;
		        }else{
		            return true;
		        }
		    };
		    
		    $(document).ready(function(){
		    	getDeptFullTree(topid);
				
				if (topid != "Top"){
					companybutton1.style.display = "none";
					companybutton2.style.display = "none";
				}
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
				var strQuery = "<DATA><DEPTID>" + deptid + "</DEPTID><TOPID>" + topid + "</TOPID><PROP>EXTENSIONATTRIBUTE1;EXTENSIONATTRIBUTE2;DISPLAYNAME</PROP></DATA>";

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
			    createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;extensionAttribute3;extensionAttribute9;DisplayName");

			    xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptSubTreeInfo.aspx", false);
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
				
				if (listOpt1.checked == true){
					cellContent = "displayname;description;title";
					typeContent = "user";
				}else{
					cellContent = "displayname;extensionAttribute9";
					typeContent = "group";
				}
				
		        $.ajax({
		        	type : "POST",
		        	dataType : "xml",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	data : {deptID : DeptID, cell : cellContent, prop : "", type : typeContent},
		        	success : function(result){		        		
		        		var headerData = createXmlDom();
		        		
				        if (listOpt1.checked == true){
				            headerData = loadXMLString(listviewheader1.innerHTML.toUpperCase());
				        }else{
				            headerData = loadXMLString(listviewheader2.innerHTML.toUpperCase());
				        }
				        
				        if (CrossYN()) {
				            var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
				            var Node = headerData.importNode(xmlRtn, true);
				            headerData.documentElement.appendChild(Node);
				        }else{
				            var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
				            headerData.documentElement.appendChild(xmlRtn);
				        }
		                document.getElementById("OrganListView").innerHTML = "";

				        var pUserList = new ListView();
				        pUserList.SetID("lvUserList");
				        pUserList.SetMulSelectable(true);
				        pUserList.SetRowOnDblClick("info_user");
				        pUserList.SetSelectFlag(false);
				        pUserList.SetHeightFree(true);
				        pUserList.DataSource(headerData);
				        pUserList.DataBind("OrganListView");
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezOrgan.t2'/>" + error);	
		        	}
		        });	
			}
	    </script>
	</head>
	<body class="mainbody">
		<xml id="listviewheader1" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t67' /></NAME>
						<WIDTH>40</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t68' /></NAME>
						<WIDTH>80</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t69' /></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<xml id="listviewheader2" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t70' /></NAME>
						<WIDTH>70</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t71' /></NAME>
						<WIDTH>30</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<h1><spring:message code='ezOrgan.t72' /></h1>
		<table style="margin-top:10px">
			<tr>
				<th><spring:message code='ezOrgan.t73' /></th>
				<th>
					<input type="radio" name="listOpt" id="listOpt1" value="muser" onClick="Change_List()" checked /><spring:message code='ezOrgan.t74' />					
					<input type="radio" name="listOpt" id="listOpt2" value="mgroup" onClick="Change_List()" /><spring:message code='ezOrgan.t75' />
				</th>
				<th style="width:80px;text-align:center" rowspan="3">
					<table>
						<tr id="companybutton1">
							<td><a class="imgbtn"><span onClick="add_company()"><spring:message code='ezOrgan.t76' /></span></a></td>
						</tr>
						<tr id="companybutton2">
							<td><a class="imgbtn"><span onClick="del_company()"><spring:message code='ezOrgan.t78' /></span></a></td>
						</tr>
						<tr>
							<td height="15"><img <spring:message code='ezOrgan.i1' />></td>
						</tr>
						<tr>
							<td><a class="imgbtn"><span onClick="info_dept()"><spring:message code='ezOrgan.t79' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn"><span onClick="add_dept()"><spring:message code='ezOrgan.t80' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="usermenu10"><span onClick="del_dept()"><spring:message code='ezOrgan.t81' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="usermenu8"><span onClick="mov_dept()"><spring:message code='ezOrgan.t82' /></span></a></td>
						</tr>
						<tr>
							<td height="15"><img <spring:message code='ezOrgan.i1' />></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="usermenu3"><span onClick="info_user()"><spring:message code='ezOrgan.t83' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn"><span onClick="add_user()"><spring:message code='ezOrgan.t84' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="usermenu2"><span onClick="del_user()"><spring:message code='ezOrgan.t85' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="usermenu1"><span onClick="mov_user()"><spring:message code='ezOrgan.t86' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="userRetire"><span onClick="Retire_user()"><spring:message code='ezOrgan.t310' /></span></a></td>
						</tr>
						<tr>
							<td height="15"><img <spring:message code='ezOrgan.i1' />></td>
						</tr>
						<%--<tr>
							<td><a class="imgbtn" id="usermenu12"><span onClick="mod_deptsign()"><spring:message code='ezOrgan.t87' /></span></a></td>
						</tr>
						<tr>
							<td height="15"><img <spring:message code='ezOrgan.i1' />></td>
						</tr>--%>
						<%--<tr>
							<td><a class="imgbtn" id="usermenu13"><span onClick="set_subtitle()"><spring:message code='ezOrgan.t88' /></span></a></td>
						</tr>--%>
						<tr>
							<td><a class="imgbtn" id="usermenu4"><span onClick="mod_sign()"><spring:message code='ezOrgan.t89' /></span></a></td>
						</tr>
						<tr>
							<td height="15"><img <spring:message code='ezOrgan.i1' />></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="usermenu5"><span onClick="mod_password()"><spring:message code='ezOrgan.t90' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="usermenu6"><span onClick="mail_manage()"><spring:message code='ezOrgan.t91' /></span></a></td>
						</tr>		
						<tr>
							<td><a class="imgbtn" id="usermenu7"><span onClick="mod_quota()"><spring:message code='ezOrgan.t92' /></span></a></td>
						</tr>		                
		                <c:if test="${useOCS == 'YES'}">
						<tr>
							<td><a class="imgbtn" id="usermenusipuri"><span onClick="ocssip_manage()">Lync <spring:message code='ezOrgan.t1012' /></span></a></td>
						</tr>
						</c:if>						
						<tr>
		                	<td><a class="imgbtn" id="usermenu21"><span onClick="SettingMsn()"><spring:message code='ezOrgan.t1002' /></span></a></td>
		                </tr>
					</table>
				</th>
			</tr>
			<tr>
				<th>
					<input id="deptkeyword" onKeyPress="deptsearch_press();" style="WIDTH:130px" />
					<a class="imgbtn" style="vertical-align:middle"><span onClick="deptsearch_click()"><spring:message code='ezOrgan.t93' /></span></a>
				</th>
				<th>
					<select id="search_type" style="WIDTH:60px">
						<option selected value="displayname"><spring:message code='ezOrgan.t67' /></option>
						<option value="cn"><spring:message code='ezOrgan.t94' /></option>
						<option value="description"><spring:message code='ezOrgan.t68' /></option>
						<option value="title"><spring:message code='ezOrgan.t69' /></option>
						<option value="telephonenumber"><spring:message code='ezOrgan.t95' /></option>
						<option value="mobile"><spring:message code='ezOrgan.t96' /></option>
						<option value="HomePhone"><spring:message code='ezOrgan.t97' /></option>
						<option value="facsimileTelephoneNumber"><spring:message code='ezOrgan.t98' /></option>
						<option value="mail"><spring:message code='ezOrgan.t99' /></option>
						<option value="streetAddress"><spring:message code='ezOrgan.t100' /></option>
					</select>
					<input id="keyword" onKeyPress="search_press()" style="WIDTH:100px" />
					<a class="imgbtn" style="vertical-align:middle"><span onClick="search_click()"><spring:message code='ezOrgan.t101' /></span></a>
				</th>
			</tr>
		    <tr>
		        <th style="padding: 3px; text-align: left; font-weight: normal;vertical-align:top">
		            <div style="border: 1px solid #b6b6b6; height: 510px; width: 280px; overflow: auto; background-color: #FFFFFF" id="TreeView"></div>
		        </th>
		        <th style="padding: 3px; text-align: left;vertical-align:top">
		            <div class="listview">
		                <div id="OrganListView" style="border: 0px solid #B6B6B6; Width: 350px; Height: 480px; overflow-x: hidden; BACKGROUND-COLOR: white; overflow-y:scroll; "></div>
		            </div>
		            <div style="height: 5px; overflow: hidden">&nbsp;</div>
		            <div style="width:100%; vertical-align:middle; text-align:center">
		            	<img style="cursor:pointer;" <spring:message code='ezOrgan.i2' />>&nbsp;<span style="padding-top:5px; display: inline-block;"><spring:message code='ezOrgan.t102' /></span>
						<img style="cursor:pointer;" <spring:message code='ezOrgan.i3' />>&nbsp;<span style="padding-top:5px; display: inline-block;"><spring:message code='ezOrgan.t103' /></span>
		                <a class="imgbtn" name="MoveConfirm"><span onClick="MoveConfirm_onclick()"><spring:message code='ezOrgan.t104' /></span></a>
		            </div>
		        </th>
		    </tr>
		</table>
	</body>
</html>