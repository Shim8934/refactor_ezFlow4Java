<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezOrgan.t00004' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/Controls/ListView_list.js"></script>	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>
		<script type="text/javascript" language="javascript">
			var topid = "<c:out value='${topID}'/>";
		    var cn = "<c:out value='${userID}'/>";
		    var deptid = "<c:out value='${userInfo.deptID}'/>";
		    var g_szAuthor = "";
		    var g_senderinfo = "<c:out value='${userInfo.companyName1}'/>" + ", " + "<c:out value='${userInfo.deptName1}'/>" + ", " + "<c:out value='${userInfo.title1}'/>";
		    var g_szUserID = "<c:out value='${userInfo.email}'/>";
		    var name = "";
		    var UserAgentState = navigator.userAgent.toLowerCase();
		    var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
		    var pListType = "TXT";
		    var pListXML_Info = null;
		    var xmlHTTP = createXMLHttpRequest();
		    var xmlHTTP2 = createXMLHttpRequest();
		    var ReturnFunction;
			
		    $(document).ready(function(){
		    	try {
	                ReturnFunction = opener.permissions_check_dialogArguments[1];
	            } catch (e) {}	        

		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                var input = document.getElementsByTagName("input");
		                
		                for (var i = 0; i < input.length; i++) {
		                    if (input[i].getAttribute("type") == "text") {
		                        KeEventControl(input[i]);
		                    }
		                }
		            }
		        } catch (e) {}
	
		        var strQuery = "<DATA><DEPTID><c:out value='${userInfo.deptID}'/></DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
		        xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		        xmlHTTP.onreadystatechange = event_GetDeptTreeInfo;
		        xmlHTTP.send(strQuery);
	
		        ListTypeChangeIcon();
			        
		        var Resultxml = loadXMLString(PermissionList.innerHTML.toUpperCase());
		        var pUserList = new ListView();
		        pUserList.SetID("lvPermissionBasic");
		        pUserList.SetMulSelectable(false);
		        pUserList.SetHeightFree(true);
		        pUserList.DataSource(Resultxml);
		        pUserList.DataBind("PermissionBasic"); 
		    });
		    
		    function ListTypeChangeIcon() {
		        if (pListType == "IMG") {
		            document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_onimglist.gif");
		            document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_list.gif");
		        }
		        else {
		            document.getElementById("imglist").setAttribute("src", "/images/kr/cm/btn_imglist.gif");
		            document.getElementById("txtlist").setAttribute("src", "/images/kr/cm/btn_onlist.gif");
		        }
		    }
		    
		    function ChangeListView_onClick(Div) {
		        pListType = Div;
		        ListTypeChangeIcon();
		        DisplayUserImageList();
		    }
		    
		    function event_GetDeptTreeInfo() {
		    	if (xmlHTTP != null && xmlHTTP.readyState == 4) {
		        	if (xmlHTTP.statusText == "OK") {
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
		                alert("<spring:message code='ezOrgan.t13' />" + xmlHTTP.statusText);
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
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        nodeIdx = treeView.GetSelectNode();
		        document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + nodeIdx.GetNodeData("VALUE");
		        SelectDeptNM.setAttribute("countinfo", "")

		        if (cn != "") {
		            document.getElementById('search_type').selectedIndex = 1;
		            document.getElementById('keyword').value = cn;
		            
		            $.ajax({
			        	type : "POST",
			        	dataType : "xml",
			        	url : "/ezOrgan/getSearchList.do",
			        	async : false,
			        	data : {search : "cn::" + cn, cell : "company;description;displayname;title;telephonenumber;"+ document.getElementById("search_type").value, prop : 'mail;displayName;description;title;company;telephoneNumber;extensionAttribute2', type : 'user'},
			        	success : function(result){	
			        		var headerData = createXmlDom();
		                    headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());

		                    if (CrossYN()) {
		                        var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                        var Node = headerData.importNode(xmlRtn, true);
		                        headerData.documentElement.appendChild(Node);
		                    } else {
		                        var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                        headerData.documentElement.appendChild(xmlRtn);
		                    }
		                    pListXML_Info = headerData;
		                    pSeach = true;
		                    DisplayUserImageList();

		                    if ("<c:out value='${use_ocs}'/>" == "YES") {
		                        check_presence();
		                    }
			        	},
			        	error : function(error){
			        		alert("<spring:message code='ezOrgan.t9' />" + error);
			        	}
			        });			           
		        } else {
		            displayUserList(nodeIdx.GetNodeData("CN"));
		        }
		    }
		    
		    function displayUserList(DeptID) {
		        $.ajax({
		        	type : "POST",
		        	dataType : "xml",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	data : {deptID : DeptID, cell : "company;description;displayName;title;telephoneNumber", prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2", type : "user"},
		        	success : function(result){
		        		var headerData = createXmlDom();
		                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());

		                if (CrossYN()) {
		                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                    var Node = headerData.importNode(xmlRtn, true);
		                    headerData.documentElement.appendChild(Node);
		                } else {
		                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                    headerData.documentElement.appendChild(xmlRtn);
		                }
		                pListXML_Info = headerData;
		                pSeach = false;
		                DisplayUserImageList();

		                if ("<c:out value='${use_ocs}'/>" == "YES") {
	                        check_presence();
	                    }
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezOrgan.t9' />" + error);
		        	}
		        });
		    }
		    
		    pSeach = false;
		    function DisplayUserImageList() {
		        var xmlRtn = pListXML_Info;
		        document.getElementById("DeptUserImgList").innerHTML = "";
		        document.getElementById("txtlist_Layer").scrollTop = "0";
		        document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes;
		        
		        while (document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
		        }
		        
		        while (document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.length > 1) {
		            document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).removeChild(document.getElementById("Search_txtlist_table").getElementsByTagName("TBODY").item(0).childNodes.item(1));
		        }
		        
		        var UserListHTML = "";
		        if (SelectDeptNM.getAttribute("countinfo") != "1") {
		            SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang24 + "</span>]";
		            SelectDeptNM.setAttribute("countinfo", "1")
		        }
		        
		        if (pListType == "IMG") {
		            document.getElementById("DeptUserImgList").style.display = "";
		            document.getElementById("txtlist_Layer").style.display = "none";
		            document.getElementById("txtlist_table").style.display = "none";
		            document.getElementById("Search_txtlist_table").style.display = "none";
		            
		            if (pSeach) {
		                document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + "<spring:message code='ezOrgan.t101' />" + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang24 + "</span>]";
		                SelectDeptNM.setAttribute("countinfo", "1");
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
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + "<spring:message code='ezOrgan.t101' />" + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang24 + "</span>]";
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
	                    M_TR.setAttribute("id", "MailUserlist_" + i);
	                    M_TR.style.cursor = "pointer";
	                    M_TR.onmouseover = function () { event_listMover(this); };
	                    M_TR.onmouseout = function () { event_listMout(this); };
	                    M_TR.onclick = function () { event_listclick(this); };                    
	                    M_TR.setAttribute("draggable", true);
	                    M_TR.onselectstart = function () { return false; };
	                    
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
	                    if ("<c:out value='${use_ocs}'/>" == "YES") {
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
	                    M_TR.setAttribute("id", "MailUserlist_" + i);
	                    M_TR.style.cursor = "pointer";
 	                    M_TR.onmouseover = function () { event_listMover(this); };
	                    M_TR.onmouseout = function () { event_listMout(this); };
	                    M_TR.onclick = function () { event_listclick(this); };
	                    M_TR.setAttribute("draggable", true);
	                    M_TR.onselectstart = function () { return false; };
	                    
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
	                        if ("<c:out value='${use_ocs}'/>" == "YES") {
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
	                        
	                        if ("<c:out value='${use_ocs}'/>" == "YES") {
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
		    
		    var m_strColorSelect = "#DBE1E7";
	        var m_strColorOver = "#f4f5f5";
	        var m_strColorDefault = "#ffffff";
	        var p_ListOrderObject = null;
	        function event_listMover(obj) {
	            for (var i = 0; i < listContentArry.length; i++) {
	                if (document.getElementById(listContentArry[i]) == obj) {
	                    return;
	                }
	            }
	            if (p_ListOrderObject != obj) {
	                for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
	                    obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorOver;
	                }
	            }
	        }
	        function event_listMout(obj) {

	            for (var i = 0; i < listContentArry.length; i++) {
	                if (document.getElementById(listContentArry[i]) == obj) {
	                    return;
	                }
	            }
	            if (p_ListOrderObject != obj) {
	                for (var RowCnt = 0; RowCnt < obj.childNodes.length; RowCnt++) {
	                    obj.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	                }
	            }
	        }

	        var listContentArry = new Array();
	        var listSubContentArry = new Array();
	        var listEventCheckbox = false;
	        var listSubEventCheckbox = false;
	        function event_listclick(obj) {
	            if (!listEventCheckbox) {
	                if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
	                    for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                        p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
	                        
							if(p_ListOrderObject != null){
		                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		                        }
							}
	                    }
	                    listContentArry = new Array();
	                }
	                p_ListOrderObject = obj;
	                var insertFlag = true;
	                
	                for (var i = 0; i < listContentArry.length; i++) {
	                    if (listContentArry[i] == p_ListOrderObject.getAttribute("id")) {
	                        insertFlag = false;
	                        
	                        if (PressCtrlKey) {
	                            listContentArry.splice(i, 1);
	                            
	                            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	                            }
	                            if (listContentArry.length == 0) {
	                                p_ListOrderObject = "";
	                            }
	                        }
	                    }
	                }
	                if (insertFlag) {
	                    for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                        p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                    }
	                    listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
	                }
	            }
	            Permissions_Check(GetAttribute(p_ListOrderObject, "_data2"));
	        }
	        
	        function Permissions_Check(UserID) {
	            var listview = new ListView();
	            listview.LoadFromID("lvUserList");

	            var xmlDom = createXmlDom();
	            
	            $.ajax({
					type : "POST",
					dataType : "xml",
					url : "/admin/ezOrgan/getEntryInfo.do",
					async : false,
					data : {cn : UserID, prop : "extensionAttribute1", pMode : "user" },
					success : function(result){
						xmlDom = result;
		                var AclList = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE1").toLowerCase().trim();
		                
		                if (AclList != "") {
		                    var Permission = loadXMLString(PermissionList.innerHTML.toUpperCase());
		                    var AclArray = AclList.split(';');
		                    var UserACL = "";
		                    var LISTVIEWDATA = "<LISTVIEWDATA><ROWS>";
		                    
		                    for (var j = 0; j < AclArray.length - 1; j++) {
		                        for (var i = 0; i < Permission.documentElement.getElementsByTagName("ROW").length; i++) {
		                            var AclValue = AclArray[j].split('=');

		                            if (getNodeText(GetChildNodes(GetChildNodes(Permission.documentElement.getElementsByTagName("ROW")[i])[0])[1]) == AclValue[0].toUpperCase()) {
		                                if (AclValue[1] == "1") {
		                                    LISTVIEWDATA = LISTVIEWDATA + "<ROW><CELL>";
		                                    LISTVIEWDATA = LISTVIEWDATA + "<VALUE>";
		                                    LISTVIEWDATA = LISTVIEWDATA + getNodeText(GetChildNodes(GetChildNodes(Permission.documentElement.getElementsByTagName("ROW")[i])[0])[0]);
		                                    LISTVIEWDATA = LISTVIEWDATA + "</VALUE>";
		                                    LISTVIEWDATA = LISTVIEWDATA + "<DATA1>";
		                                    LISTVIEWDATA = LISTVIEWDATA + getNodeText(GetChildNodes(GetChildNodes(Permission.documentElement.getElementsByTagName("ROW")[i])[0])[1]);
		                                    LISTVIEWDATA = LISTVIEWDATA + "</DATA1>";
		                                    LISTVIEWDATA = LISTVIEWDATA + "</CELL></ROW>";
		                                }
		                            }
		                        }
		                    }
		                    LISTVIEWDATA = LISTVIEWDATA + "</ROWS></LISTVIEWDATA>";
		                    document.getElementById('UserAclList').innerHTML = "";                   
		                } else {
		                    LISTVIEWDATA = "<LISTVIEWDATA><ROWS></ROWS></LISTVIEWDATA>";
		                    document.getElementById('UserAclList').innerHTML = "";
		                }
		                var Resultxml = loadXMLString(LISTVIEWDATA);
		                var pAclList = new ListView();
		                pAclList.SetID("lvAclList");
		                pAclList.SetMulSelectable(false);
		                pAclList.SetHeightFree(true);
		                pAclList.DataSource(Resultxml);
		                pAclList.DataBind("UserAclList");
					}
				});
	        }
	        
	        function InsertReceiver() {
	            var pparsingXML = "";
	            var pparsingXML2 = "";
	            var strSIP = "";
	            var pAddFlag = false;
	            var listid = "lvPermissionBasic";
	            var getlistview = new ListView();
	            getlistview.LoadFromID(listid);

	            var arrRows = getlistview.GetSelectedRows();
	            var length = arrRows.length;

	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                alert(strLang13);
	                return;
	            } else {
	                var UserAcllistview = new ListView();
	                UserAcllistview.LoadFromID("lvAclList");
	                var strId = GetAttribute(arrRows[0], "data1");
	                var strName = GetChildNodes(arrRows[0])[0].innerText;
	                var bFlag = UserAcllistview.ExistRow("data1", strId);

	                if (bFlag) {
	                    alert(strLang25);
	                    pAddFlag = true;
	                } else {
	                    pparsingXML2 = "";
	                    pparsingXML = "";
	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	                    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
	                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                    Resultxml = loadXMLString(pparsingXML2);

	                    var listview = new ListView();
	                    listview.LoadFromID("lvAclList");

	                    var MaxID = 0;
	                    var InitTr = listview.GetDataRows();
	                    var MaxCntNum = 0;

	                    for (var j = 0  ; j < listview.GetRowCount() ; j++) {
	                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                        
	                        if (MaxID < curnum) {
	                            MaxID = curnum;
	                            MaxCntNum = j;
	                        }
	                    }
	                    var objTr = listview.AddRow(listview.GetRowCount());
	                    
	                    if (MaxCntNum != 0) {
	                        MaxCntNum = MaxCntNum + 1;
	                    }
	                    SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
	                    listview.AddDataRow(objTr, Resultxml);

	                    var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                    
	                    for (var y = 0; y < _tdlength; y++) {
	                        document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                        document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                    }
	                }
	            }
	        }

	        function DeleteReceiver() {
	            var listid = "lvAclList";
	            var selList = new ListView();
	            selList.LoadFromID(listid);

	            var arrRows = selList.GetSelectedRows();
	            var strName = "";

	            for (var i = 0; i < arrRows.length; i++) {
	                selList.DeleteRow(arrRows[i].id);
	            }
	        }
	        
	        String.prototype.trim = function () {
	            return this.replace(/(^\s*)|(\s*$)/g, "");
	        }
	        
	        function keyword_Clear() {
	            document.getElementsByName('keyword').value = "";
	        }
	        
	        function close_Click() {
	            if (ReturnFunction!=null) {
	                ReturnFunction();
	            }
	            window.close();
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
		        	dataType : "xml",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : false,
		        	data : {search : "displayname::" + document.all("deptkeyword").value, cell : "extensionAttribute3;displayname;extensionAttribute9;", prop : "cn", type : 'group'},
		        	success : function(result){	
		        		xmlDOM = result;
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
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
		            } else {
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
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
		                try { OpenWin.focus(); } catch (e) { }
		            }else{
		                var feature = "dialogHeight:340px; dialogWidth:598px; status:no;scroll:no; help:no; edge:sunken";
		                feature = feature + GetShowModalPosition(600, 340);
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
		    
		    var bSearch = true;
		    function event_getDeptFullTree() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.statusText == "OK") {
		                if (!bSearch) {
		                    try {
		                        if (CrossYN()) {
		                            opener.opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
		                        } else {
		                            window.dialogArguments["window"].opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
		                        }
		                    } catch (e) { }
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
		                alert("<spring:message code='ezOrgan.t9' />" + g_xmlHTTP.statusText);
		                g_xmlHTTP = null;
		            }
		        }
		    }
		    
		    function search_click(){
				if (keyword.value == ""){
					alert("<spring:message code='ezOrgan.t56' />");
					keyword.focus();
					return;
				}			   
			    				
				$.ajax({
		        	type : "POST",
		        	dataType : "xml",
		        	url : "/ezOrgan/getSearchList.do",		        	
		        	data : {search : document.getElementById("search_type").value + "::" + document.getElementById("keyword").value, cell : "company;description;displayname;title;telephonenumber;" + document.getElementById("search_type").value, 
		        			prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2", type : "user"},
		        	success : function(result){
		        		var usedefault;		                
		                var headerData = createXmlDom();
		                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
		                
		                if (CrossYN()) {
		                	usedefault = document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex].usedefault;
		                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                    var Node = headerData.importNode(xmlRtn, true);
		                    headerData.documentElement.appendChild(Node);
		                } else {
		                	usedefault = GetAttribute(document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex], "usedefault");
		                    var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
		                    headerData.documentElement.appendChild(xmlRtn);
		                }
		                pListXML_Info = headerData;
		                pSeach = true;
		                DisplayUserImageList();

		                if ("<c:out value='${use_ocs}'/>" == "YES") {
		                    check_presence();
		                }
		                
					},
					error : function(error){
						alert("<spring:message code='ezOrgan.t9' />" + error);
					}
		        });				
				// [2006. 02. 10. 이민수] 검색을 완료하면 TextBox를 초기화하도록 변경
				//keyword.value = "";
			}
		    
		    function deptsearch_press() {
	            if (window.event.keyCode == "13") {
	                deptsearch_click();
	                event.cancelBubble = true;
	                event.returnValue = false;
	            }
	        }
		    
		    function search_press(){
				if (window.event.keyCode == "13"){
					search_click();
				}
			}
		    
		    function OK_Click() {
	            var PermissionList = new ListView();
	            PermissionList.LoadFromID("lvPermissionBasic");

	            var Acllistview = new ListView();
	            Acllistview.LoadFromID("lvAclList");

	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                alert(strLang13);
	                return;
	            }
	     
	            var AclList = "";
	            var AclText = "";
	            
	            for (var i = 0; i < PermissionList.GetRowCount() ; i++) {
	                AclList += GetAttribute(PermissionList.GetDataRows()[i], "data1").toLowerCase() + "=0;";
	            }

	            for (var j = 0; j < Acllistview.GetRowCount() ; j++) {
	                var AclCheck = GetAttribute(Acllistview.GetDataRows()[j], "data1").toLowerCase() + "=1";
	                AclList = AclList.replace(GetAttribute(Acllistview.GetDataRows()[j], "data1").toLowerCase() + "=0", GetAttribute(Acllistview.GetDataRows()[j], "data1").toLowerCase() + "=1");
	                AclText += "- " + GetChildNodes(Acllistview.GetDataRows()[j])[0].innerText + "<br>";
	            }

	            $.ajax({
	            	type : "POST",
	            	dataType : "html",
	            	url : "/admin/ezOrgan/saveUserInfo.do",
	            	async : false,
	            	data : {parentCn : "", cn : GetAttribute(p_ListOrderObject, "_data2"), extensionAttribute1 : AclList},
	            	success : function(result){
	            		//TODO : 2016-05-03 장진혁과장 -- Email 전송메소드 구현 필요
	            		//sendmail(GetAttribute(p_ListOrderObject, "_data2"), strLang18, AclText)
		                alert(strLang14);
	            	},
	            	error : function(){
	            		alert(strLang15);
	            	}
	            });
	        }
	    </script>
	</head>
	<body class="popup">
	    <xml id="listviewheader" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t67'/></NAME>
						<WIDTH>40</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t69'/></NAME>
						<WIDTH>80</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t97'/></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<xml id="PermissionList" style="display:none">
			<LISTVIEWDATA>
				<ROWS>
			        <ROW>
			            <CELL>            
			                <VALUE><spring:message code='ezOrgan.t291'/></VALUE>
			                <DATA1>c</DATA1>
			            </CELL>
			        </ROW>
			        <ROW>
			            <CELL>            
			                <VALUE><spring:message code='ezOrgan.t293'/></VALUE>
			                <DATA1>k</DATA1>
			            </CELL>
			        </ROW>
			        <ROW>
			            <CELL>            
			                <VALUE><spring:message code='ezOrgan.t295'/></VALUE>
			                <DATA1>g</DATA1>
			            </CELL>
			        </ROW>
			        <ROW>
			            <CELL>            
			                <VALUE><spring:message code='ezOrgan.t292'/></VALUE>
			                <DATA1>a</DATA1>
			            </CELL>
			        </ROW>
			        <ROW>
			            <CELL>            
			                <VALUE><spring:message code='ezOrgan.t294'/></VALUE>
			                <DATA1>i</DATA1>
			            </CELL>
			        </ROW>
			        <ROW>
			            <CELL>            
			                <VALUE><spring:message code='ezOrgan.t297'/></VALUE>
			                <DATA1>n</DATA1>
			            </CELL>
			        </ROW>
			        <ROW>
			            <CELL>            
			                <VALUE><spring:message code='ezOrgan.t296'/></VALUE>
			                <DATA1>l</DATA1>
			            </CELL>
			        </ROW>
			        <ROW>
			            <CELL>            
			                <VALUE><spring:message code='ezOrgan.t301'/></VALUE>
			                <DATA1>w</DATA1>
			            </CELL>
			        </ROW>
			        <ROW>
			            <CELL>            
			                <VALUE><spring:message code='ezOrgan.t300'/></VALUE>
			                <DATA1>m</DATA1>
			            </CELL>
			        </ROW>   
				</ROWS>
			</LISTVIEWDATA>
		</xml>
	    <div id="menu">
	        <ul>
	            <li><span onclick="OK_Click()"><spring:message code='ezOrgan.t167'/></span></li>
	        </ul>
	    </div>
	    <div id="close">
	        <ul>
	            <li><span onclick="close_Click()"><spring:message code='ezOrgan.t143'/></span></li>
	        </ul>
	    </div>
	    <table id="TreeViewTD">
	        <tr>
	            <td>
	                <div class="portlet_tabpart03" style="background-color: #e9e9e9; margin-top: 4px;">
	                    <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #d3d2d2;">
	                        <table style="margin-top: 3px; width: 100%;">
	                            <tr>
	                                <td>
	                                	<div style="padding-left:60px">
	                                    	<input type="text" name="Input" id="deptkeyword" style="WIDTH: 110px; margin: 0px;" onkeypress="deptsearch_press()" />
	                                        <a class="imgbtn"><span onclick="deptsearch_click()"><spring:message code='ezOrgan.t93'/></span></a>
	                                	</div>
	                                </td>
	                                <td>
	                                    <div style="float:right">
	                                        <select id="search_type">
	                                            <option selected value="displayname"><spring:message code='ezOrgan.t67'/></option>
					                            <option value="cn"><spring:message code='ezOrgan.t94'/></option>
					                            <option value="description"><spring:message code='ezOrgan.t68'/></option>
					                            <option value="title"><spring:message code='ezOrgan.t69'/></option>
					                            <option value="telephonenumber"><spring:message code='ezOrgan.t95'/></option>
					                            <option value="mobile"><spring:message code='ezOrgan.t96'/></option>
					                            <option value="HomePhone"><spring:message code='ezOrgan.t97'/></option>
					                            <option value="facsimileTelephoneNumber"><spring:message code='ezOrgan.t98'/></option>
					                            <option value="mail"><spring:message code='ezOrgan.t99'/></option>
					                            <option value="streetAddress"><spring:message code='ezOrgan.t100'/></option>
	                                        </select>
	                                        <input type="text" id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px;" />
	                                        <a class="imgbtn"><span onclick="search_click()"><spring:message code='ezOrgan.t101'/></span></a>
	                                    </div>
	                                </td>    
	                                <td></td>
	                            </tr>
	                        </table>
	                    </div>
	                </div>
	                <table style="margin-top: 3px;">
	                    <tr>
	                        <td class="box">
	                            <div style="width: 250px; height: 465px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
	                        </td>
	                        <td></td>
	                        <td class="listview" style="width: 426px" id="orglistView">
	                            <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
	                                <tr>
	                                    <th style="white-space:normal">
	                                        <span id="SelectDeptNM" style="font-weight: bold; width: 300px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;"></span>
	                                        <span style="float:right;">
	                                            <span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
	                                            <span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
	                                        </span>
	                                    </th>
	                                </tr>
	                            </table>
	                            <div style="vertical-align: top; height: 440px; overflow: auto; width: 440px;" id="txtlist_Layer">
	                                <table style="width:100%; border: 1px solid #B6B6B6; display: none;" id="txtlist_table" class="mainlist">
	                                    <tr>
	                                        <td style="width: 150px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t67'/></td>
	                                        <td style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t69'/></td>
	                                        <td class="td_gray" style="font-weight: bold;"><spring:message code='ezOrgan.t97'/></td>
	                                    </tr>
	                                </table>
	                                <table style="width:100%; border: 1px solid #B6B6B6; display: none;" id="Search_txtlist_table" class="mainlist">
	                                    <tr>
	                                        <td style="width: 110px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t68'/></td>
	                                        <td style="width: 90px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t67'/></td>
	                                        <td style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t69'/></td>
	                                        <td class="td_gray" style="font-weight: bold;"><spring:message code='ezOrgan.t97'/></td>
	                                    </tr>
	                                </table>
	                            </div>
	                            <div style="vertical-align: top; text-align: center; height: 440px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
	                        </td>    
	                    </tr>
	                </table>
	            </td>        
	            <td style="vertical-align:top; padding-top:4px; padding-left:3px;">
	                <table>
	                    <tr>
	                        <td>
	                            <h2 id="Permission" class="receiver_tltype01" onclick="SelectReceiverWindow(ToTitle,ListViewMsgTo)" style="cursor: pointer;">
	                                <span style="min-width: 45px;" id="PermissionStr"><spring:message code='ezOrgan.t00011'/></span>
	                            </h2>
	                            <div class="receiver_borderbox">
	                                <div id="PermissionBasic" style="width: 250px; Height: 210px; overflow-x: auto; overflow-y: auto;" ondblclick="InsertReceiver()"></div>
	                            </div>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td style="text-align:center; padding-top:1px;">
	                            <img src="../../../images/kr/cm/arr_down.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertReceiver()" />
	                            <img src="../../../images/kr/cm/arr_up.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver()" />
	                        </td>
	                    </tr>
	                    <tr>
	                        <td>
	                            <h2 id="UserAcl" class="receiver_tltype01" onclick="SelectReceiverWindow(ToTitle,ListViewMsgTo)" style="cursor: pointer;">
	                                <span style="min-width: 45px;" id="Span1"><spring:message code='ezOrgan.t00012'/></span>
	                            </h2>
	                            <div class="receiver_borderbox">
	                                <div id="UserAclList" style="width: 250px; Height: 209px; overflow-x: auto; overflow-y: auto;" ondblclick="DeleteReceiver()"></div>
	                            </div>
	                        </td>
	                    </tr>
	                </table>                                      
	            </td>
	        </tr>
	    </table>
	</body>	
</html>