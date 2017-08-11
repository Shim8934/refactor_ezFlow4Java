<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>조직도</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezTask.e2' />" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script>
			window.onload = function(){
				if (window.dialogArguments != "" && window.dialogArguments != null)
				{
					for (var i=0; i<window.dialogArguments["id"].length; i++)
					{
						lastindex = document.getElementById("ListMember").length;
						newoption = new Option(window.dialogArguments["name"][i], window.dialogArguments["id"][i] + ";" + window.dialogArguments["deptname"][i] + ";" + window.dialogArguments["name1"][i] + ";" + window.dialogArguments["name2"][i] +  ";" + window.dialogArguments["deptname2"][i]);
						document.getElementById("ListMember").options[lastindex] = newoption;
					}
				}
				
				document.getElementById("OrganListView").hotTrackColor = "#F7FAE0";
				document.getElementById("OrganListView").selectColor = "#ECF3BA";
				document.getElementById("OrganListView").dataSource = listviewheader;
			
				var strQuery = "<DATA><DEPTID>" + ${userinfo.DeptID} + "</DEPTID><TOPID>Top</TOPID><PROP>displayname</PROP></DATA>";
				var xmlHTTP = createXMLHttpRequest();
				xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
				xmlHTTP.send(strQuery);
			
				var xmlDom = createXmlDom();
				xmlDom.async = false;
				xmlDom.load("/xml/common/organtree_config.xml");
				document.getElementById("TreeView").server = document.location.hostname;
				document.getElementById("TreeView").config = xmlDom;
				document.getElementById("TreeView").source = loadXMLString(xmlHTTP.responseText);
				document.getElementById("TreeView").update();
			}

			function RequestData() {
				var nodeIdx = window.event.nodeIdx;
				var xmlHTTP = createXMLHttpRequest();
				var strQuery = "<DATA><DEPTID>" + document.getElementById("TreeView").getvalue(nodeIdx, "CN") + "</DEPTID><PROP></PROP></DATA>";
				xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
				xmlHTTP.send(strQuery);
				document.getElementById("TreeView").putchildxml(nodeIdx, loadXMLString(xmlHTTP.responseText));
			}

			function TreeViewNodeClick() {
				var nodeIdx = document.getElementById("TreeView").selectedIndex;
				displayUserList(document.getElementById("TreeView").getvalue(nodeIdx, "CN"));		
			}
	
			function displayUserList(DeptID) {
				var xmlpara = createXmlDom();
				g_xmlHTTP = createXMLHttpRequest();
				var objNode;

				createNodeInsert(xmlpara, objNode, "DATA");
				createNodeAndInsertText(xmlpara, objNode, "DEPTID", tempDeptID);
				createNodeAndInsertText(xmlpara, objNode, "CELL", "company;description;displayname;title;telephonenumber");
				createNodeAndInsertText(xmlpara, objNode, "PROP", "mail;displayname;description;title;company;telephonenumber;extensionattribute2");
				createNodeAndInsertText(xmlpara, objNode, "PAGE", CurPage);
				createNodeAndInsertText(xmlpara, objNode, "TYPE", "user");

				g_xmlHTTP = createXMLHttpRequest();
				g_xmlHTTP.open("POST","/ezOrgan/getDeptMemberList.do", true);
				g_xmlHTTP.onreadystatechange = event_displayUserList;
				g_xmlHTTP.send(xmlpara.xml);
			}

			function event_displayUserList() {
				if(g_xmlHTTP != null && g_xmlHTTP.readyState == 4)
				{
					if (g_xmlHTTP.statusText == "OK")
					{
					    document.getElementById("OrganListView").rows.dataSource = loadXMLString(g_xmlHTTP.responseText);
				    }
					else
						alert("<spring:message code='ezTask.t193' />" + g_xmlHTTP.statusText)

					g_xmlHTTP = null;
				}
			}

			function cnsearch_press() {
				if (window.event.keyCode == "13")
				{
					event.returnValue = false;
					cnsearch_click();
				}
			}

			var g_xmlHTTP = null;
			function cnsearch_click()
			{
				if (document.getElementById("cnkeyword").value == "")
				{
					alert("<spring:message code='ezTask.t194' />");
					document.getElementById("cnkeyword").focus();
					return;
				}

				var count;
				var adCount = 0;

				var xmlHTTP = createXMLHttpRequest();
				var xmlDOM = createXmlDom();
				var objNode;

				createNodeInsert(xmlpara, objNode, "DATA");
				createNodeAndInsertText(xmlpara, objNode, "SEARCH", "displayname::" + document.getElementById("cnkeyword").value);
				createNodeAndInsertText(xmlpara, objNode, "CELL", "company;description;title;displayname;mail");
				createNodeAndInsertText(xmlpara, objNode, "PROP", "department");
				createNodeAndInsertText(xmlpara, objNode, "TYPE", "user");

				try {	
					xmlHTTP.open("POST","/ezOrgan/getSearchList.do",false);
					xmlHTTP.send(xmlDOM.xml);

					if (xmlHTTP.statusText != "OK") {
						alert("<spring:message code='ezTask.t195' />" + xmlHTTP.statusText);
						xmlDOM = null;
						xmlHTTP = null;
					} else {
					    xmlDOM = loadXMLString(xmlHTTP.responseText)
						adCount = xmlDOM.getElementsByTagName("ROW").length;
					}
				} catch(e) {
					alert("<spring:message code='ezTask.t195' />" + e.description);
					xmlDOM = null;
					xmlHTTP = null;
				}

				if (adCount == 0) {
					alert("<spring:message code='ezTask.t196' />");
					return;
				} else if (adCount == 1) {
					g_xmlHTTP = createXMLHttpRequest();
					var strQuery = "<DATA><DEPTID>" + getNodeText(xmlDOM.getElementsByTagName("DATA3").item(0)) + 
							"</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
					g_xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetDeptTreeInfo.aspx", true);
					g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
					g_xmlHTTP.send(strQuery);
				} else {
					var rgParams = new Array();
					rgParams["addrBook"] = xmlDOM;
					rgParams["deptid"] = "";
					var feature = GetShowModalPosition(610, 372);
					window.showModalDialog("/admin/ezOrgan/checkName2.do", rgParams, "dialogHeight:372px; dialogWidth:610px; status:no;scroll:no; help:no; edge:sunken" + feature);

					if (rgParams["deptid"] != "") {
						g_xmlHTTP = createXMLHttpRequest();
						var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
						g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
						g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
						g_xmlHTTP.send(strQuery);
					}
				}
			}

			function event_getDeptFullTree() {
				if(g_xmlHTTP != null && g_xmlHTTP.readyState == 4)
				{
					if (g_xmlHTTP.statusText == "OK")
					{
						var xmlDom = createXmlDom();
						xmlDom.async = false;
						xmlDom.load("/xml/common/organtree_config.xml");
						document.getElementById("TreeView").server = document.location.hostname;
						document.getElementById("TreeView").config = xmlDom;
						document.getElementById("TreeView").source = loadXMLString(g_xmlHTTP.responseText);
						document.getElementById("TreeView").update();
					}
					else
					{
						alert("<spring:message code='ezTask.t197' />" + g_xmlHTTP.statusText)
						g_xmlHTTP = null;
					}
				}
			}

			function add_member() {
				var length = document.getElementById("OrganListView").multiSelects.length;
				
				if (length == 0)
				{
					var nodeIdx = document.getElementById("TreeView").selectedIndex;
					lastindex = document.getElementById("ListMember").length;
					newoption = new Option(document.getElementById("TreeView").getvalue(nodeIdx, "VALUE"), document.getElementById("TreeView").getvalue(nodeIdx, "CN") + ";<spring:message code='ezTask.t15' />;" + 
					document.getElementById("TreeView").getvalue(nodeIdx, "DISPLAYNAME1") + ";" + document.getElementById("TreeView").getvalue(nodeIdx, "DISPLAYNAME2") + ";Department"); 
					document.getElementById("ListMember").options[lastindex] = newoption;
				}
				
				for(var count1 = 0; count1 < length; count1++)
				{
					var selRow = document.getElementById("OrganListView").multiSelects.item(count1);
					if(selRow)
					{		
						lastindex = document.getElementById("ListMember").length;
						var isExist = false;
						
				        if ("${userInfo.UserID}" != selRow.cells[0].DATA3) {
						    for (var i=0; i<lastindex; i++)
						    {
							    if (document.getElementById("ListMember").options[i].value.split(";")[0] == selRow.cells[0].DATA3)
							    {
							        alert("'" + getNodeText(selRow.cells[0]) + "'<spring:message code='ezTask.t198' />");
								    isExist = true;
								    break;
							    }
						    }
						} else {
				            alert("<spring:message code='ezTask.t199' />");
				            isExist = true;				    
				        }							

						if (!isExist)
						{	
						    newoption = new Option(getNodeText(selRow.cells[0]), selRow.cells[0].DATA3 + ";" + selRow.cells[0].DATA7+ ";" + selRow.cells[0].DATA9 + ";" + selRow.cells[0].DATA10+ ";" + selRow.cells[0].DATA8);
							document.getElementById("ListMember").options[lastindex] = newoption;
						}
					}
				}
			}

			function delete_member() {
				while (true) 
				{
					selectindex = document.getElementById("ListMember").selectedIndex;

					if (selectindex < 0 || selectindex >= document.getElementById("ListMember").length)
						return;

					document.getElementById("ListMember").options[selectindex] = null;
				}
			}

			function close_onclick()
			{
				var rtn = {"id":new Array(), "name":new Array(), "deptname":new Array(), "name1":new Array(), "name2":new Array(), "deptname2":new Array()};
				
				for (var i=0; i<document.getElementById("ListMember").options.length; i++)
				{
				    rtn["name"][i] = getNodeText(document.getElementById("ListMember").options[i]);
					rtn["id"][i] = document.getElementById("ListMember").options[i].value.split(";")[0];
					rtn["deptname"][i] = document.getElementById("ListMember").options[i].value.split(";")[1];
			        rtn["name1"][i] = document.getElementById("ListMember").options[i].value.split(";")[2];
			        rtn["name2"][i] = document.getElementById("ListMember").options[i].value.split(";")[3];
			        rtn["deptname2"][i] = document.getElementById("ListMember").options[i].value.split(";")[4];
				}

				window.returnValue = rtn;
				window.close();
			}
		</script>
	</head>
	<body class="popup">
		<xml id="treeconfig">
			<tree>
				<config>
					<size width="12" height="17" />
					<baseimage>
					<dot_continue path="/images/Email/tree/dot_continue.gif" />
					<dot_end path="/images/Email/tree/dot_end.gif" />
					<dot_normal path="/images/Email/tree/dot_normal.gif" />
					<minus_end path="/images/Email/tree/minus_end.gif" />
					<minus_normal path="/images/Email/tree/minus_normal.gif" />
					<plus_end path="/images/Email/tree/plus_end.gif" />
					<plus_normal path="/images/Email/tree/plus_normal.gif" />
					<space path="/images/Email/tree/space.gif" />
					<selected path="/images/Email/tree/folderselect.gif" />
					</baseimage>
					<baseclass>
					<normal name="node_normal" />
					<selected name="node_selected" />
					<hover name="node_hover" />
					</baseclass>
					<images>
					<image idx="1" path="/images/Email/tree/folder.gif" />
					</images>
				</config>
			</tree>
		</xml>
		<xml id="listviewheader">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezTask.t200' /></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezTask.t201' /></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezTask.t202' /></NAME>
						<WIDTH>70</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<form method="post" runat="server">
	<!-- 	<OBJECT id="ListViewBehave" style="DISPLAY: none" height="0" width="0" classid="clsid:F8E93A35-2D04-4E2C-A04D-87947594C674" VIEWASTEXT> -->
	<!-- 	</OBJECT> -->
			<h1>조직도</h1>
			<table>
				<tr>
					<td valign="top"><div class="box" style="OVERFLOW-Y:auto; OVERFLOW-X:auto; BEHAVIOR:url(/myoffice/common/organtreeview.htc);  WIDTH:240px;  HEIGHT:380px;" id="TreeView" onrequestdata="RequestData()" onnodeselect="TreeViewNodeClick()" onnodedblclick="TreeView.toggle(TreeView.selectedIndex)"></div></td>
					<td style="padding-left:4px" width="250" valign="top"><div class="listview" id="OrganListView" STYLE="BEHAVIOR: url('#ListViewBehave#ListView'); OVERFLOW: hidden;  WIDTH: 250px;  HEIGHT: 347px;" onRowDblClick="add_member()"></div>
						<table width="100%" class="box" style="margin-top:4px">
							<tr>
								<td width="100%" style="padding:2px"><input id="cnkeyword" onKeyPress="cnsearch_press()" style="WIDTH:100%"></td>
								<td style="padding:2px">
									<a class ="imgbtn" onclick ="cnsearch_click()"><span><spring:message code='ezTask.t183' /></span></a>
								</td>
							</tr>
						</table>
					</td>
					<td width="30" align="center"><img src="/images/arr_right.gif" width="16" height="16" vspace="3" onClick="add_member()" style="cursor:pointer"> <img src="/images/arr_left.gif" width="16" height="16" vspace="3" onClick="delete_member()" style="cursor:pointer"></td>
					<td  valign="top">
						<div style="OVERFLOW:hidden; HEIGHT:388px">
	<!-- 					<asp:ListBox ID="ListMember" runat="server" Width="180" Height="388" ondblclick='delete_member()' SelectionMode="Multiple"></asp:ListBox> -->
						</div>
					</td>
				</tr>
			</table>
			<div class="btnposition">
				<a class="imgbtn" onClick="close_onclick()"><span><spring:message code='ezTask.t19' /></span></a>
				<a class="imgbtn" onClick="window.close()"><span><spring:message code='ezTask.t20' /></span></a>
			</div>
		</form>
	</body>
</html>
