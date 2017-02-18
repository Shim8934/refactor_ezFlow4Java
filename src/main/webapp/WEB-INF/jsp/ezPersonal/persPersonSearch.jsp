<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css" />
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			var bSearch = false;
	    	var UserAgentState = navigator.userAgent.toLowerCase();
	    	var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
	    	var pListType = "IMG";
	    	var pListXML_Info = null;
	    	var strLang1 = "<spring:message code='ezPersonal.t249'/>";
	    	var strLang2 = "<spring:message code='ezPersonal.t1003'/>";
	    	var strLang39 = "<spring:message code='ezPersonal.t10000'/>";
	    	var strLang40 = "<spring:message code='ezPersonal.t10001'/>";
	    	var strSearch = "${searchString}";

	    	var CurPage = "1";

	    	document.onselectstart = function () { return false; };
	    	
	     	 window.onload = function () {
	 			if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
	    	        document.body.style.WebkitUserSelect = 'none';
	        	    document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
	            	document.body.style.UserSelect = 'none';
	            	window.resizeTo(770, 645);
	        	}

	        	if (navigator.userAgent.indexOf("Safari") > 0 && navigator.userAgent.indexOf("Chrome") == -1) {
		            window.resizeTo(770, 595);
	        	}
	        	ListTypeChangeIcon();
	        	try {
		            var xmlpara = createXmlDom();
	            	var xmlTree = createXmlDom();
	            	var xmlHTTP = createXMLHttpRequest();
	            	var objNode;
	            	createNodeInsert(xmlpara, objNode, "DATA");
	            	createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${userInfo.deptID}");
	            	createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top");
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
					
		        } catch (ErrMsg) {
	            	alert(" TreeViewinitialize : " + ErrMsg.description);
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
	        	createNodeAndInsertText(xmlpara, objNode, "PROP", "mail;displayName");
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
	    	function TreeViewNodeClick() {
		        issearch = false;
		        CurPage = "1";
	    	    var treeView = new TreeView();
	        	treeView.LoadFromID("FromTreeView");
	        	var nodeIdx = treeView.GetSelectNode();
	        	document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + nodeIdx.GetNodeData("VALUE");
	        	SelectDeptNM.setAttribute("countinfo","")
	        	displayUserList(nodeIdx.GetNodeData("CN"));

	    	}
	    	var tempDeptID = "";
	    	function displayUserList(DeptID) {
		        if (DeptID != undefined) {
	            	tempDeptID = DeptID;
		        }

	        	 $.ajax({
	  					url : '/ezOrgan/getDeptMemberList.do',
	  					method : 'POST',
	  					dataType : "text",
	  					data : {
	  						deptID : tempDeptID ,
	  						cell : "company;description;displayName;title;telephoneNumber",
	  						prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2",
	  						page : CurPage ,
	  						type : "user"
	  					} ,
	      				success : function(xml) {
	 		                event_displayUserList(loadXMLString(xml));
	 		                
	 		                //2016-10-17 자바스크립트 실행순서때문에 자꾸 getDeptMemberList.do리스트가 나중에 나와서 window.onload 밑에있던부분 이쪽으로 위치 이동
	 		               	if (strSearch != "") {
	 			            	document.getElementById('keyword').value = strSearch;
	 							search_click("search"); 
	 							strSearch = "";
	 		              	}
	  					},
	  					error : function(jqXHR, textStatus, errorThrown) {
	  						alert(error);
	  					}
	  				});   
	        	 
	    	}
	    	
	     	function event_displayUserList(xml) {
		        if (xml != null) {
    	            pListXML_Info = xml;
    	            xml = null;
                	pSeach = false;
                	DisplayUserImageList();
                	makePageSelPage();
		        } 
		    } 
		    var m_strColorSelect = "#DBE1E7";
	    	var m_strColorOver = "#f4f5f5";
	    	var m_strColorDefault = "#ffffff";
	    	var p_ListOrderObject = null;
	    	
	    	function event_listMover(obj) {
		        if (p_ListOrderObject != obj ) {
		            for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
	        	        obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorOver;
		            }
	        	}
	    	}
	    	
	    	function event_listMout(obj) {
	        	if (p_ListOrderObject != obj ) {
		            for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
		                obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	    	        }
	        	}
	    	}
	    	
	    	function event_listclick(obj) {
		        if (p_ListOrderObject != obj && p_ListOrderObject != null) {
		            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	    	            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	        	    }
	        	}
	        	p_ListOrderObject = obj;
	        	
	        	for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
	            	obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	        	}
	    	}
	    	
	    	function event_listDBclick(obj) {
		        var id = obj.getAttribute("_DATA2");
		        var dept = obj.getAttribute("_DATA11");

	    	    var width = 420, height = 450;
	        	var leftPosition, topPosition;
	        	//Allow for borders.
	        	leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
	        	//Allow for title and status bars.
	        	topPosition = (window.screen.height / 2) - ((height / 2) + 50);
	        	//Open the window.

		        if(CrossYN())
		            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	    	    else
	        	    window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ",status = no, toolbar=no, menubar=no,location=no, resizable=1");
	    	}
	    	var pSeach = false;
	    	function DisplayUserImageList() {
		        var xmlRtn = pListXML_Info;
		        totalPage = Math.ceil(new Number(getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) / 50));
	    	    document.getElementById("DeptUserImgList").innerHTML = "";
	        	document.getElementById("txtlist_Layer").scrollTop = "0";
	        	document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes
	        	while (document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
		        }
	        	while (document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
	        	}
	        	var UserListHTML = "";
	        	
	        	if (SelectDeptNM.getAttribute("countinfo") != "1") {
	            	SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT")[0]) + strLang1 + "</span>]";
	            	SelectDeptNM.setAttribute("countinfo","1")
	        	}
	        	
	        	if (pListType == "IMG") {
	            	document.getElementById("DeptUserImgList").style.display = "";
	            	document.getElementById("txtlist_Layer").style.display = "none";
	            	document.getElementById("txtlist_table").style.display = "none";
	            	document.getElementById("Search_txtlist_table").style.display = "none";
	            	if (pSeach) {
	                	document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang2 + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	                	SelectDeptNM.setAttribute("countinfo", "1")
	            	}
	        	} else {
	            	document.getElementById("DeptUserImgList").style.display = "none";
	            	document.getElementById("txtlist_Layer").style.display = "";
	            	if (!pSeach) {
	                	document.getElementById("txtlist_table").style.display = "";
	                	document.getElementById("Search_txtlist_table").style.display = "none";
	            	} else {
	                	document.getElementById("Search_txtlist_table").style.display = "";
	                	document.getElementById("txtlist_table").style.display = "none";
	                	document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + strLang2 + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	                	SelectDeptNM.setAttribute("countinfo", "1")
	            	}
	        	}
	        	
	        	for (var i = 0; i < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length; i++) {
	            	if (pListType == "IMG") {
		                var MainTable = document.createElement("TABLE");
		                MainTable.setAttribute("class", pListType == "IMG" ? "organwrap" : "organwrap_list");
	    	            MainTable.setAttribute("cellspacing", "0");
	        	        MainTable.setAttribute("cellpadding", "0");
	        	        
		                if (pListType == "IMG") {
	                	    MainTable.style.marginTop = "5px";
	                	}

	                	MainTable.style.marginLeft = "auto";
	                	MainTable.style.marginRight = "auto";
	                	var M_TR = document.createElement("TR");
	                	M_TR.style.cursor = "pointer";
	                	M_TR.onmouseover = function () { event_listMover(this); };
	                	M_TR.onmouseout = function () { event_listMout(this); };
	                	M_TR.onclick = function () { event_listclick(this); };
	                	M_TR.ondblclick = function () { event_listDBclick(this); };
	                	
	                	if (CrossYN()) {
	                    	for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                        	if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	                            	M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
									trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                        	}
	                    	}
	                	} else {
	                    	for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                        	M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                            SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).text);
	                    	}
	                	}

	                	var M_TR_TD = document.createElement("TD");
	                	M_TR_TD.setAttribute("class", "pictd");
	                	var M_TR_DIV = document.createElement("DIV");
	                	M_TR_DIV.setAttribute("class", "pic");
	                	
	                	if (M_TR.getAttribute("_DATA9") != "") {
	                    	var M_TR_IMG = document.createElement("IMG");
	                    	M_TR_IMG.setAttribute("SRC", "/admin/ezOrgan/getPersonalInfo.do?fileName=" + M_TR.getAttribute("_DATA9"));
	                    	M_TR_IMG.setAttribute("width", "90px");
	                    	M_TR_IMG.setAttribute("height", "90px");
	                    	M_TR_DIV.appendChild(M_TR_IMG);
	                	}
	                	M_TR_TD.appendChild(M_TR_DIV);
	                	M_TR.appendChild(M_TR_TD);

	                	var M_TR_TD2 = document.createElement("TD");
	                	M_TR_TD2.style.width = "300px";

	                	var M_TR_TDS_Table = document.createElement("TABLE");
	                	M_TR_TDS_Table.setAttribute("class", "organinfo");
	                	M_TR_TD2.appendChild(M_TR_TDS_Table);

		                var Sub_TR1 = document.createElement("TR");
		                var Sub_TD1 = document.createElement("TD");
	    	            Sub_TD1.style.textAlign = "left";
	        	        Sub_TD1.setAttribute("class", "name");
	            	    var pDisplayName = "";
	            	    
		                if ("${useOCS}" == "YES") {
	                    	pDisplayName += "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>";
	                	}
	                	pDisplayName += M_TR.getAttribute("_DATA4") == "" ? "" : M_TR.getAttribute("_DATA4");
	                	pDisplayName += M_TR.getAttribute("_DATA6") == "" ? "" : "[" + M_TR.getAttribute("_DATA6") + "]";
	                	Sub_TD1.innerHTML = pDisplayName;
	                	Sub_TR1.appendChild(Sub_TD1);

	                	var Sub_TR2 = document.createElement("TR");
	                	var Sub_TD2 = document.createElement("TD");
	                	Sub_TD2.style.textAlign = "left";
	                	Sub_TD2.innerHTML = M_TR.getAttribute("_DATA5");
	                	Sub_TR2.appendChild(Sub_TD2);

	                	var Sub_TR3 = document.createElement("TR");
	                	var Sub_TD3 = document.createElement("TD");
	                	Sub_TD3.style.textAlign = "left";
	                	var Sub_TD3_Img = document.createElement("IMG");
	                	Sub_TD3_Img.setAttribute("class", "icon");
	                	Sub_TD3_Img.setAttribute("src", "/images/OrganTree/icon_hp.gif");
	                	Sub_TD3.appendChild(Sub_TD3_Img);
	                	Sub_TD3.innerHTML += M_TR.getAttribute("_DATA8") == "" ? " - " : M_TR.getAttribute("_DATA8");
	                	Sub_TR3.appendChild(Sub_TD3);

	                	var Sub_TR4 = document.createElement("TR");
	                	var Sub_TD4 = document.createElement("TD");
	                	Sub_TD4.style.textAlign = "left";
	                	var Sub_TD4_Img = document.createElement("IMG");
	                	Sub_TD4_Img.setAttribute("class", "icon");
	                	Sub_TD4_Img.setAttribute("src", "/images/OrganTree/icon_mail.gif");
	                	Sub_TD4.appendChild(Sub_TD4_Img);
	                	Sub_TD4.innerHTML += M_TR.getAttribute("_DATA3")
	                	Sub_TR4.appendChild(Sub_TD4);

	                	M_TR_TDS_Table.appendChild(Sub_TR1);
	                	M_TR_TDS_Table.appendChild(Sub_TR2);
	                	M_TR_TDS_Table.appendChild(Sub_TR3);
	                	M_TR_TDS_Table.appendChild(Sub_TR4);

	                	M_TR.appendChild(M_TR_TD2);
	                	MainTable.appendChild(M_TR);
	                	document.getElementById("DeptUserImgList").appendChild(MainTable);
	            	} else {
	                	var M_TR = document.createElement("TR");
	                	M_TR.style.cursor = "pointer";
	                	M_TR.onmouseover = function () { event_listMover(this); };
	                	M_TR.onmouseout = function () { event_listMout(this); };
	                	M_TR.onclick = function () { event_listclick(this); };
	                	M_TR.ondblclick = function () { event_listDBclick(this); };
	                	
	                	if (CrossYN()) {
		                    for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
		                        if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	    	                        M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
									trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                        	}
	                    	}
	                	} else {
	                    	for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
		                        M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
								SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).text);
	                    	}
	                	}
	                
	                	if (pSeach) {
	                    	var M_TR_TD1 = document.createElement("TD");
	                    	M_TR_TD1.style.overflow = "hidden";
	                    	M_TR_TD1.style.textOverflow = "ellipsis";
	                    	M_TR_TD1.style.whiteSpace = "nowrap";
	                    	M_TR_TD1.style.width = "110px";
	                    	M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA5");

		                    var M_TR_TD2 = document.createElement("TD");
		                    M_TR_TD2.style.overflow = "hidden";
	    	                M_TR_TD2.style.textOverflow = "ellipsis";
	        	            M_TR_TD2.style.whiteSpace = "nowrap";
	            	        M_TR_TD2.style.width = "90px";
	            	        
	                    	if ("${useOCS}" == "YES") {
	                        	M_TR_TD2.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
	                    	} else {
	                        	M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA4");
	                    	}

	                    	var M_TR_TD3 = document.createElement("TD");
							M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
	                    	M_TR_TD3.style.width = "80px";

		                    var M_TR_TD4 = document.createElement("TD");
							M_TR_TD4.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");
		                    
	                    	M_TR.appendChild(M_TR_TD1);
	                    	M_TR.appendChild(M_TR_TD2);
	                    	M_TR.appendChild(M_TR_TD3);
	                    	M_TR.appendChild(M_TR_TD4);
	                    	document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
	                	} else {
	                    	var M_TR_TD1 = document.createElement("TD");
	                    	M_TR_TD1.style.overflow = "hidden";
	                    	M_TR_TD1.style.textOverflow = "ellipsis";
	                    	M_TR_TD1.style.whiteSpace = "nowrap";
	                    	M_TR_TD1.style.width = "150px";
	                    	
	                    	if ("${useOCS}" == "YES") {
	                        	M_TR_TD1.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
	                    	} else {
		                        M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA4");
	                    	}

		                    var M_TR_TD2 = document.createElement("TD");
	    	                M_TR_TD2.style.width = "80px";
	        	            M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");

	            	        var M_TR_TD3 = document.createElement("TD");
	                	    M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");

		                    M_TR.appendChild(M_TR_TD1);
	                    	M_TR.appendChild(M_TR_TD2);
	                    	M_TR.appendChild(M_TR_TD3);
	                    	document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
	                	}
	            	}
		        }
	    	}
	    	
	    	function show_member() {
	        	var listview = new ListView();
	        	listview.LoadFromID("Organ");
	        	var length = listview.GetRowCount()
	        	var selectdata = listview.GetSelectedRows();
	        	
	        	if (length > 0) {
	            	var id = GetAttribute(selectdata[0], "DATA2");
	            	var dept = GetAttribute(selectdata[0], "DATA10");
	            	window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(420, 450));
	        	}
	    	}
	    	
	    	function search_press(e) {
		        if (window.event) {
	            	if (window.event.keyCode == 13) {
		                search_click("search");
	            	}
	        	} else {
	            	if (e.which == 13)
		                search_click("search");
	        	}
		    }
	    	var issearch = false;
	    	function search_click(type) {
		        if (keyword.value == "") {
	            	alert("<spring:message code='ezPersonal.t61'/>");
	            	keyword.focus();
	            	return;
	        	}
	        	if (type == "search") {
		            CurPage = "1";
	            	issearch = true;
	        	}

	        	$.ajax({
					url : '/ezOrgan/getSearchList.do',
					method : 'POST',
					dataType : "text",
					data : {
						search : document.getElementById("search_type").value + "::" + keyword.value,
						cell : "company;description;displayName;title;telephoneNumber;" + document.getElementById("search_type").value,
						prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2",
						page : CurPage ,
						type : "user"
					} ,
   					success : function(xml) {
   						event_displayUserList2(loadXMLString(xml));
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code="ezResource.t2"/>" + textStatus);
					}
				});
	        	var usedefault;
	        	if (browserIE) {
	        		usedefault = document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex].usedefault;
	        	} else {
	        		usedefault = GetAttribute(document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex], "usedefault");
	        	}
	        	
	    	}
	    	function event_displayUserList2(xml) {
		        if (xml != null) {
	                if (SelectNodes(xml, "LISTVIEWDATA/ROWS/ROW").length == 0) {
                    	alert("<spring:message code='ezPersonal.t211'/>");
	                } else {
	                    pListXML_Info = xml;
                    	pSeach = true;
                    	DisplayUserImageList();
                    	makePageSelPage();
                	}
	    	    }
	    	}
	    	function SelectReceiverWindow(Title, selectedWindow) {
	        	for (var count = 0; count < m_receiverTitleList.length; count++) {
	            	m_receiverTitleList[count].style.fontWeight = "normal";
	            	m_receiverWindowList[count].style.backgroundColor = m_titleNoneSelectedColor;
	            	m_receiverWindowList[count].normalColor = m_titleNoneSelectedColor;
	            	ChangeRowsColor(m_receiverWindowList[count], m_titleNoneSelectedColor);
	        	}
	        	Title.style.fontWeight = "bold";
	        	selectedWindow.style.backgroundColor = m_titleSelectedColor;
	        	selectedWindow.normalColor = m_titleSelectedColor;
	        	ChangeRowsColor(selectedWindow, m_titleSelectedColor);
	        	m_selectedWindow = selectedWindow;
	    	}
	    	var rgParams = new Array();
	    	var checkname2_cross_dialogArguments = new Array();
	    	
	    	function deptsearch_click() {
		        if (deptkeyword.value == "") {
		            alert("<spring:message code='ezPersonal.t61'/>");
	    	        deptkeyword.focus();
	        	    return;
	        	}
	        	
		        var xmlDOM = createXmlDom();
	        	 $.ajax({
					url : '/ezOrgan/getSearchList.do',
					method : 'POST',
					dataType : "text",
					async : false,
					data : {search : "displayname::" + document.all("deptkeyword").value, cell : "extensionAttribute3;displayname;extensionAttribute9;", prop : "", type : 'group'}, 
   					success : function(result) {
   						xmlDOM = loadXMLString(result);
   						var row = SelectNodes(xmlDOM, "LISTVIEWDATA/ROWS/ROW");
	                	adCount = row.length;
						},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezResource.t2'/>" + textStatus);
						xmlDOM = null;
					}
				}); 

		        if (adCount == 0) {
	    	        alert("<spring:message code='ezPersonal.t63'/>");
	        	    return;
	        	} else if (adCount == 1) {
	            	bSearch = true;
	            	g_xmlHTTP = createXMLHttpRequest();

	            	if(CrossYN())
		                var strQuery = "<DATA><DEPTID>" + SelectNodes(xmlDOM, "LISTVIEWDATA/ROWS/ROW/DATA2").item(0).textContent + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
	            	else
	                	var strQuery = "<DATA><DEPTID>" + SelectNodes(xmlDOM, "LISTVIEWDATA/ROWS/ROW/DATA2").item(0).text + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";

	            	g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	            	g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	            	g_xmlHTTP.send(strQuery);
	        	} else {
		            rgParams["addrBook"] = xmlDOM;
		            rgParams["deptid"] = "";
	            	var feature = "dialogHeight:320px; dialogWidth:600px; status:no;scroll:no; help:no; edge:sunken";
	            	feature = feature + GetShowModalPosition(600, 320);
	            	
	            	if (CrossYN()) {
		                checkname2_cross_dialogArguments[0] = rgParams;
	                	checkname2_cross_dialogArguments[1] = deptsearch_click_Complete;
	                	var OpenWin = window.open("/admin/ezOrgan/checkName2.do", "checkName2_cross", GetOpenWindowfeature(600, 320));
	             	    OpenWin.focus();
	            	} else {
	                	window.showModalDialog("/admin/ezOrgan/checkName2.do", rgParams, feature);

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
            	            if (CrossYN())
                    	        opener.opener.top.organview = g_xmlHTTP.responseXML;
                	        else
                        	    window.dialogArguments["window"].opener.top.organview = g_xmlHTTP.responseXML;
	                	}

		                var treeXML = loadXMLFile("/xml/organtree_config.xml");
	                	document.getElementById('TreeView').innerHTML = "";

	                	var treeView = new TreeView();
	                	treeView.SetConfig(treeXML);
	                	treeView.SetID("FromTreeView");
	                	treeView.SetUseAgency(true);
	                	treeView.SetRequestData("RequestData");
	                	treeView.SetNodeClick("TreeViewNodeClick");
	                	treeView.DataSource(g_xmlHTTP.responseXML);
	                	treeView.DataBind("TreeView");
	            	} else {
	                	alert("<spring:message code='ezPersonal.t17'/>" + g_xmlHTTP.statusText)
	                	g_xmlHTTP = null;
	            	}
	        	}
	    	}
	    	
	    	function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");

		        return (orgStr.replace(re, replaceStr));
	    	}
	    	function onkey_down(e) {
	        	if (window.event) {
	            	if (window.event.keyCode == 13) {
		                deptsearch_click();
		            }
	    	    } else {
	            	if (e.which == 13) {
		                deptsearch_click();
	            	}
	        	}
	    	}
	    	
	    	function ListTypeChangeIcon() {
		        if (pListType == "IMG") {
	            	document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_onimglist.gif");
	            	document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_list.gif");
	        	} else {
	            	document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_imglist.gif");
	            	document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_onlist.gif");
	        	}
	    	}
	    	
	    	function ChangeListView_onClick(Div) {
		        pListType = Div;
	        	ListTypeChangeIcon();
	        	DisplayUserImageList();
	    	}
	    	function keyword_Clear() {
		        document.getElementById('keyword').value = "";
	    	}
	    	var personsearch_print_dialogArguments = new Array();
	    	
	    	function Listprint() {
		        var param = new Array();
		        param["Dept"] = document.getElementById("SelectDeptNM").innerHTML;
	    	    param["TreeXml"] = pListXML_Info;
		        param["ListType"] = pListType;
	        	param["Search"] = pSeach;
	
	        	var config = "status:false;dialogWidth:800px;dialogHeight:520px;scroll:yes;status:no;edge:sunken" + GetShowModalPosition(800, 520);
	        	if (CrossYN()) {
		            personsearch_print_dialogArguments[0] = param;
	            	//Listprint_dialogArguments[1] = Listprint_Complete;
	            	var OpenWin = window.open("/ezPersonal/personSearchPrint.do", "personsearch_print", GetOpenWindowfeature(800, 520));
	            	try { OpenWin.focus(); } catch (e) { }
	        	} else
	            	var ret = window.showModalDialog("/ezPersonal/personSearchPrint.do", param, config);
		    }

	    	var BlockSize = 10;
	    	function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
	    	}
	    	function makePageSelPage() {
		        var strtext;
	        	var PagingHTML = "";
	        	document.getElementById("tblPageRayer").innerHTML = "";
	        	strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
	        	var pageNum = CurPage;
	        	if (totalPage > 1 && pageNum != 1) {
	            	strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
	            	PagingHTML += strtext;
	        	} else {
	            	strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
	            	PagingHTML += strtext;
	        	}
	        	if (totalPage > BlockSize) {	
		            if (pageNum > BlockSize) {
	                	strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
		                PagingHTML += strtext;
		            } else {
	                	strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
	                	PagingHTML += strtext;
	            	}
	        	} else {
	            	strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
	            	PagingHTML += strtext;
	        	}
	        	var MaxNum;
	        	var i;
	        	var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
	        	if (totalPage >= (startNum + parseInt(BlockSize))) {
	            	MaxNum = (startNum + parseInt(BlockSize)) - 1;
	        	} else {
	            	MaxNum = totalPage;
	        	}
	        	for (i = startNum; i <= MaxNum; i++) {
		            if (i == pageNum) {
		                strtext = "<span class='on'>" + i + "</span>";
	    	            PagingHTML += strtext;
	            	} else {
	                	strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
	                	PagingHTML += strtext;
	            	}
	        	}
	        	if (totalPage > BlockSize) {
		            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
	                	strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
	                	strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
	                	PagingHTML += strtext;
	            	} else {
	                	strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
	                	strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	                	PagingHTML += strtext;
	            	}
	        	} else {
	            	strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
	            	strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
	            	PagingHTML += strtext;
	        	}
	        	if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	            	strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
	            	PagingHTML += strtext;
	        	} else {
	            	strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
	            	PagingHTML += strtext;
	        	}
	        	PagingHTML += "</div>";
	        	td_Create1(PagingHTML);
	    	}
	    	function goToPageByNum(Value) {
	        	CurPage = Value;
	        	makePageSelPage();
	        	movePage(CurPage);
	    	}
	    	function selbeforeBlock() {
		        var pageNum = parseInt(CurPage);
	        	pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
	        	goToPageByNum(pageNum);
	    	}
	    	function selbeforeBlock_one() {
		        var pageNum = parseInt(CurPage);
	        	if (parseInt(pageNum - 1) > 0)
		            goToPageByNum(parseInt(pageNum - 1));
	        	else
		            return;
	    	}
	    	function selafterBlock() {
		        var pageNum = parseInt(CurPage);
	        	pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	        	goToPageByNum(pageNum);
	    	}
	    	function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
	        	if (parseInt(pageNum + 1) <= totalPage)
		            goToPageByNum(parseInt(pageNum + 1));
		        else
	    	        return;
	    	}
	    	function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
	            	CurPage = newPage;
	            	if(issearch) {
		                search_click();
	            	} else {
		                displayUserList();
	            	}
	        	}
	    	}
	    	function prevPage_onclick() {
		        newPage = parseInt(CurPage) - 1;
	        	if (newPage > 0) {
		            CurPage = newPage;
	            	if (issearch) {
		                search_click();
	            	} else {
		                displayUserList();
	            	}
	        	}
	    	}
	    	function nextPage_onclick() {
		        newPage = parseInt(CurPage) + 1;
	        	if (newPage <= parseInt(totalPage)) {
		            CurPage = newPage;
	            	if (issearch) {
		                search_click();
	            	} else {
		                displayUserList();
	            	}
	        	}
	    	}
		</script>
	</head>
	<body class="popup" style="overflow:hidden;">
		<div id="normalScreen">
  			<div id="menu">
    			<ul>
      				<li><span onClick="Listprint()"><spring:message code='ezPersonal.t1005'/></span></li>
    			</ul>
  			</div>
  			<div id="close">
    			<ul>
      				<li><span onClick="window.close()"><spring:message code='ezPersonal.t10'/></span></li>
    			</ul>
  			</div>
  			<script type="text/javascript" >
      			selToggleList(document.getElementById("menu"), "ul", "li", "0");
      			selToggleList(document.getElementById("close"), "ul", "li", "0");
  			</script>
        	<div class="portlet_tabpart03">
	            <div class="portlet_tabpart03_top" id="tab1" style="border-left:1px solid #d3d2d2;">
    	           <table style="margin-top:5px;width:100%;">
						<tr>
	                        <td>
    	                        <div style="margin-left:5px;">
        		                    <input id="deptkeyword" value="" onKeyPress="onkey_down(event)" style="width:120px;margin:0px;">
                			            <a class="imgbtn"><span onClick="deptsearch_click()"><spring:message code='ezPersonal.t71'/></span></a>
	                            </div>
                        	</td>
                       		<td>
                           		<div style="float:right;margin-right:5px;">
                            		<select id="search_type">
                            			<option selected value="displayname" usedefault="1"><spring:message code='ezPersonal.t9'/></option>
                            			<option value="description" usedefault="1"><spring:message code='ezPersonal.t7'/></option>
                            			<option value="title" usedefault="1"><spring:message code='ezPersonal.t69'/></option>
                            			<option value="telephonenumber" usedefault="1"><spring:message code='ezPersonal.t177'/></option>
                            			<option value="mobile" usedefault="0"><spring:message code='ezPersonal.t178'/></option>
                            			<option value="HomePhone" usedefault="0"><spring:message code='ezPersonal.t70'/></option>
                            			<option vaue="facsimileTelephoneNumber" usedefault="0"><spring:message code='ezPersonal.t179'/></option>
                            			<option value="mail" usedefault="0"><spring:message code='ezPersonal.t176'/></option>
                            			<option value="streetAddress" usedefault="0"><spring:message code='ezPersonal.t180'/></option>
                            		</select>
                            		<input id="keyword" value="" onKeyPress="search_press(event)" onmousedown="keyword_Clear();" style="width:130px;margin:0px;">
                            			<a class="imgbtn"><span onclick="search_click('search')"><spring:message code='ezPersonal.t83'/></span></a>
                           		</div>
                       		</td>
                   		</tr>
               		</table>
            	</div>
        	</div>
		  <table>
    		<tr>
      			<td class="box">
          			<div style="width:300px;height:450px;overflow-x:auto;overflow-y:auto;" id="TreeView" ></div>
      			</td>
      			<td></td>
      			<td class="listview" style="width:426px">
          			<table style="width:425px;margin-top:-1px;"  class="popup_mainlist" > 
              			<tr>
                  			<th style="white-space:normal">
                      			<span id="SelectDeptNM" style="font-weight:bold;width:300px;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;display:inline-block;vertical-align:bottom;"></span>
					  			<span style="float:right;">
                          			<span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
                          			<span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
					  			</span>
                  			</th>
              			</tr>              
          			</table>
          			<div style="vertical-align:top;height:390px;overflow:auto;width:425px;" id="txtlist_Layer">   
          				<table style="width:100%;border:1px solid #B6B6B6;display:none;" id="txtlist_table" class="mainlist" > 
              				<tr>
                  				<td style="width:170px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t304'/></td>
                  				<td style="width:150px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t69'/></td>
                  				<td class="td_gray" style="font-weight:bold;"><spring:message code='ezPersonal.t177'/></td>
              				</tr>
          				</table>
          				<table style="width:100%;border:1px solid #B6B6B6;display:none;" id="Search_txtlist_table" class="mainlist" > 
              				<tr>
                  				<td style="width:130px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t305'/></td>
                  				<td style="width:90px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t304'/></td>
                  				<td style="width:90px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t69'/></td>
                  				<td class="td_gray" style="font-weight:bold;"><spring:message code='ezPersonal.t177'/></td>
              				</tr>
          				</table>
          			</div>
		  			<div style="vertical-align:top;text-align:center;height:390px;overflow:auto;display:none;width:425px;" id="DeptUserImgList"></div>
          			<div id="tblPageRayer" style="text-align:center;border-top:1px solid #B6B6B6"></div>
    			</tr>
    			<tr>
      				<td  height="30"></td>
      				<td width="5"></td>
      				<td></td>
    			</tr>
  			</table>
		</div>
		<div id="printScreen" style="DISPLAY: none">
			<table style="width:100%;height:auto;border:1px solid #B6B6B6;display:none;" id="Print_txtlist_table" class="mainlist" > 
				<tr>
                  	<td style="width:150px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t304'/></td>
                  	<td style="width:80px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t69'/></td>
                  	<td class="td_gray" style="font-weight:bold;"><spring:message code='ezPersonal.t177'/></td>
              </tr>
          	</table>
          	<table style="width:100%;height:auto; border:1px solid #B6B6B6;display:none;" id="Print_Search_txtlist_table" class="mainlist" > 
            	<tr>
                	<td style="width:110px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t305'/></td>
					<td style="width:90px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t304'/></td>
                  	<td style="width:80px;font-weight:bold;" class="td_gray"><spring:message code='ezPersonal.t69'/></td>
                  	<td class="td_gray" style="font-weight:bold;"><spring:message code='ezPersonal.t177'/></td>
              	</tr>
          	</table>
		  	<div style="vertical-align:top;text-align:center;height:auto;display:none;width:425px;" id="Print_DeptUserImgList"></div>
		</div>
	</body>
</html>