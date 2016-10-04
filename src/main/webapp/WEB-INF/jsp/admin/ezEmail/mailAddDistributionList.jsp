<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t8' /></title>
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
	    <link rel="stylesheet" href="/js/ezEmail/Controls/ezSearchDatePicker.htc" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script src="/js/ezPersonal/controls/TreeView.js" type="text/javascript"></script>
	    <script type="text/javascript" src="/js/ezEmail/Controls/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script>
	        var cn = "${cn}";
	        var companyid = "";
	        var UserAgentState = navigator.userAgent.toLowerCase();
	        var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
	        var pListType = "TXT";
	        var pListXML_Info = null;
	        var strLang1 = "<spring:message code='ezEmail.t10001' />";
	        var strLang2 = "<spring:message code='ezEmail.t10000' />";
	        var xmlHTTP2 = createXMLHttpRequest();
	        var ReturnFunction;
	        var RetValue;
	        window.onload = function () {
	            try {
	                RetValue = parent.mail_add_distributionlist_cross_dialogArguments[0];
	                ReturnFunction = parent.mail_add_distributionlist_cross_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.mail_add_distributionlist_cross_dialogArguments[0];
	                    ReturnFunction = opener.mail_add_distributionlist_cross_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	            companyid = RetValue;
	
	            var strQuery = "<DATA><DEPTID>" + "${deptID}" + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	            xmlHTTP.send(strQuery);
	
	            recevieListview("MsgToList", "ListViewMsgTo");
	            ListTypeChangeIcon();
	
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
	                }
	                else {
	                    alert("<spring:message code='ezEmail.t13' />" + xmlHTTP.statusText);
	                    xmlHTTP = null;
	                }
	            }
	
	            if ("${cn}" != "") {
	                
	                var xmlpara = createXmlDom();
	                var objRoot, objNode;
	                objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "CN", "${cn}");
	
	                xmlHTTP2 = createXMLHttpRequest();
	                xmlHTTP2.open("POST", "/admin/ezEmail/mailViewDistributionList.do", true);
	                xmlHTTP2.onreadystatechange = event_GetDistributionList;
	                xmlHTTP2.send(xmlpara);
	            }
	        }
	
	        function MakeXMLString(pStr) {
	            pStr = ReplaceText(pStr, "&", "&amp;");
	            pStr = ReplaceText(pStr, "<", "&lt;");
	            pStr = ReplaceText(pStr, ">", "&gt;");
	            return pStr;
	        }
	
	        function ReplaceText(orgStr, findStr, replaceStr) {
	            var re = new RegExp(findStr, "gi");
	            return (orgStr.replace(re, replaceStr));
	        }
	
	        function event_GetDistributionList()
	        {
	            if (xmlHTTP2 != null && xmlHTTP2.readyState == 4) {
	                if (xmlHTTP2.statusText == "OK") {
	                    
	                    var result = loadXMLString(xmlHTTP2.responseText);
	                    var Resultxml = "";
	                    pparsingXML2 = "";
	                    pparsingXML = "";
	                    pparsingXML2 = "<LISTVIEWDATA><ROWS>";
	
	                    var nodes = SelectNodes(result, "DATA/ROW");
	
	                    for (var i = 0 ; i < nodes.length ; i++)
	                    {
	                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + getNodeText(GetChildNodes(nodes[i])[1]) + "</DATA1>";
	                        // 
	                        if(getNodeText(GetChildNodes(nodes[i])[0]) == "user")
	                            pparsingXML = pparsingXML + "<VALUE>" + getNodeText(GetChildNodes(nodes[i])[2]) + "</VALUE></CELL></ROW>";
	                        else
	                            pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t15' />" + getNodeText(GetChildNodes(nodes[i])[2]) + "</VALUE></CELL></ROW>";
	                    }
	                              
	                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA>";
	                    Resultxml = loadXMLString(pparsingXML2);
	
	                    var listview = new ListView();
	                    listview.SetID("MsgToList");
	                    listview.SetSelectFlag(false);
	                    listview.SetMulSelectable(false);
	                    listview.SetRowOnDblClick("DeleteReceiver");
	                    listview.DataSource(Resultxml);
	                    listview.RowDataBind();
	
	                    for (var i = 0; i < listview.GetRowCount() ; i++) {
	                        listview.GetDataRows()[i].style.whiteSpace = "nowrap";
	                        listview.GetDataRows()[i].childNodes[0].setAttribute("height", "");
	                        listview.GetDataRows()[i].childNodes[0].style.whiteSpace = "";
	                        listview.GetDataRows()[i].childNodes[0].style.overflow = "";
	                        listview.GetDataRows()[i].childNodes[0].style.textOverflow = "";
	                    }
	                }
	                xmlHTTP2 = null;
	            }
	        }
	
	        function recevieListview(pID, pListView) {
	            var listview = new ListView();
	            listview.SetID(pID);
	            listview.SetSelectFlag(false);
	            listview.SetMulSelectable(true);
	            listview.SetRowOnDblClick("DeleteReceiver");
	            listview.DataSource(loadXMLString("<LISTVIEWDATA></LISTVIEWDATA>"));
	            listview.DataBind(pListView);
	            listview.RowDataBind();
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
	            nodeIdx = treeView.GetSelectNode();
	            document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + nodeIdx.GetNodeData("VALUE");
	            SelectDeptNM.setAttribute("countinfo", "")
	            displayUserList(nodeIdx.GetNodeData("CN"));
	        }
	
	        function displayUserList(DeptID) {
	        	listContentArry = new Array();
	        	
	        	$.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	async : true,
		        	data : {deptID : DeptID, cell : "company;description;displayName;title;telephoneNumber", prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2", type : "user"},
		        	success : function(result){
		        		var headerData = createXmlDom();
	                    headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
	
	                    if (CrossYN()) {
	                        var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
	                        var Node = headerData.importNode(xmlRtn, true);
	                        headerData.documentElement.appendChild(Node);
	                    }
	                    else {
	                        var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
	                        headerData.documentElement.appendChild(xmlRtn);
	                    }
	                    pListXML_Info = headerData;
	                    pSeach = false;
	                    DisplayUserImageList();
	
	                    if ("${useOcs}" == "YES") {
	                        check_presence();
	                    }
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezEmail.t9' />" + error);
		        	}
		        });
	        	
	            listContentArry = new Array();
	            var xmlpara = createXmlDom();
	
	        }
	
	        function event_displayUserList2() {
	            if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
	                if (g_xmlHTTP.statusText == "OK") {
	                    var headerData = createXmlDom();
	                    headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
	
	                    if (CrossYN()) {
	                        var xmlRtn = g_xmlHTTP.responseXML.documentElement.getElementsByTagName("ROWS")[0];
	                        var Node = headerData.importNode(xmlRtn, true);
	                        headerData.documentElement.appendChild(Node);
	                    }
	                    else {
	                        var xmlRtn = g_xmlHTTP.responseXML.documentElement.getElementsByTagName("ROWS")[0];
	                        headerData.documentElement.appendChild(xmlRtn);
	                    }
	                    pListXML_Info = headerData;
	                    pSeach = true;
	                    DisplayUserImageList();
	
	                    if ("${useOcs}" == "YES") {
	                        check_presence();
	                    }
	                }
	
	                else
	                    alert("<spring:message code='ezEmail.t9' />" + g_xmlHTTP.statusText)
	
	                g_xmlHTTP = null;
	            }
	        }
	
	
	        function search_press() {
	            if (window.event.keyCode == "13") {
	                search_click();
	                event.cancelBubble = true;
	                event.returnValue = false;
	            }
	        }
	
	        function deptsearch_press() {
	            if (window.event.keyCode == "13") {
	                deptsearch_click();
	                event.cancelBubble = true;
	                event.returnValue = false;
	            }
	        }
	        function search_click() {
	            if (document.all("keyword").value == "") {
	                alert("<spring:message code='ezEmail.t10' />");
	                document.all("keyword").focus();
	                return;
	            }
				
	            $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : true,
		        	data : {
		        		search : document.all("search_type").value + "::" + document.all("keyword").value, 
		        		cell : "company;description;displayName;title;telephoneNumber;" + document.getElementById("search_type").value, 
		        		prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2", 
		        		type : "user"
		        	},
		        	success : function(result){	
		        		var headerData = createXmlDom();
	                    headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
						
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
	                    pListXML_Info = headerData;
	                    pSeach = true;
	                    DisplayUserImageList();
	
	                    if ("${useOcs}" == "YES") {
	                        check_presence();
	                    }
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezEmail.t9' />" + error);
		        	}
		        });
	            
	            var usedefault;
	            if (browserIE) {
	                usedefault = document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex].usedefault;
	            }
	            else {
	                usedefault = GetAttribute(document.getElementById("search_type").options[document.getElementById("search_type").selectedIndex], "usedefault");
	            }
	
	        }
	        var checkname2_cross_dialogArguments = new Array();
	        var rgParams = new Array();
	        function deptsearch_click() {
	            if (document.all("deptkeyword").value == "") {
	                alert("<spring:message code='ezEmail.t10' />");
	                document.all("deptkeyword").focus();
	                return;
	            }
	            
	            var xmlDOM = createXmlDom();
	            
	            $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : false,
		        	data : {
		        		search : "displayname::" + document.all("deptkeyword").value, 
		        		cell : "extensionAttribute3;displayName;extensionAttribute9;", 
		        		prop : "cn", 
		        		type : "group"
		        	},
		        	success : function(result){	
		        		xmlDOM = loadXMLString(result);
		                adCount = xmlDOM.getElementsByTagName("ROW").length;
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezEmail.t11' />" + error);
		        		xmlDOM = null;
		        	}
		        });
	            
	            if (adCount == 0) {
	                alert("<spring:message code='ezEmail.t12' />");
	                return;
	            }
	            else if (adCount == 1) {
	                bSearch = true;
	                g_xmlHTTP = createXMLHttpRequest();
	
	                if (CrossYN())
	                    var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
	                else
	                    var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>Top</TOPID><PROP></PROP></DATA>";
	
	                g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	                g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	                g_xmlHTTP.send(strQuery);
	            }
	            else {
	                
	                rgParams["addrBook"] = xmlDOM;
	                rgParams["deptid"] = "";
	                var feature = "dialogHeight:372px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken";
	                feature = feature + GetShowModalPosition(609, 460);
	
	                if (CrossYN()) {
	                    checkname2_cross_dialogArguments[0] = rgParams;
	                    checkname2_cross_dialogArguments[1] = deptsearch_click_Complete;
	                    var OpenWin = window.open("/admin/ezOrgan/checkName2.do", "checkName2_cross", GetOpenWindowfeature(609, 460));
	                    try { OpenWin.focus(); } catch (e) { }
	                }
	                else {
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
	                        try {
	                            if (CrossYN())
	                                opener.opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
	                            else
	                                window.dialogArguments["window"].opener.top.organview = loadXMLString(g_xmlHTTP.responseText);
	                        }
	                        catch (e) { }
	                    }
	
	                    var treeXML = loadXMLFile("/xml/common/organtree_config2.xml");
	                    document.getElementById('TreeView').innerHTML = "";
	
	                    var treeView = new TreeView();
	                    treeView.SetConfig(treeXML);
	                    treeView.SetID("FromTreeView");
	                    treeView.SetUseAgency(true);
	                    treeView.SetRequestData("RequestData");
	                    treeView.SetNodeClick("TreeViewNodeClick");
	                    treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
	                    treeView.DataBind("TreeView");
	                }
	                else {
	                    alert("<spring:message code='ezEmail.t9' />" + g_xmlHTTP.statusText)
	                g_xmlHTTP = null;
	            }
	        }
	        }        
	
	        String.prototype.trim = function () {
	            return this.replace(/(^\s*)|(\s*$)/g, "");
	        }
	
	        function OK_Click() {
	            if (document.all("TextName").value.trim() == "") {
	                alert("<spring:message code='ezEmail.t22' />");
	                document.all("TextName").focus();
	                return;
	            }
	            if (document.all("TextId").value.trim() == "") {
	                alert("<spring:message code='ezEmail.t99000093' />");
	                document.all("TextId").focus();
	                return;
	            }
	            
	            var regex=/^([\w-]+(?:\.[\w-]+)*)$/;
	            if(regex.test(document.all("TextId").value.trim()) === false) {
	            	alert("<spring:message code='ezEmail.t99000096' />");
	            	return;
	            }
	            
	            var xmlDom = createXmlDom();
	            var xmlHTTP = createXMLHttpRequest();
	            var objNode = "";
	            createNodeInsert(xmlDom, objNode, "DATA");
	            createNodeAndInsertText(xmlDom, objNode, "COMPID", companyid);
	            createNodeAndInsertText(xmlDom, objNode, "CN", cn);
	            createNodeAndInsertText(xmlDom, objNode, "NAME", document.all("TextName").value);
	            createNodeAndInsertText(xmlDom, objNode, "ID", document.all("TextId").value);
	            
	            for (var i = 0; i < document.getElementById("ListViewMsgTo").children.item(0).children.item(1).childNodes.length; i++) {
	                createNodeAndInsertText(xmlDom, objNode, "MEMBERID", document.getElementById("ListViewMsgTo").children.item(0).children.item(1).children.item(i).getAttribute("data1"));
	
	            }
	            xmlHTTP.open("POST", "/admin/ezEmail/mailSaveDistributionList.do", false);
	            xmlHTTP.send(xmlDom);
	            if (xmlHTTP.status == 200 && xmlHTTP.responseText == "OK") {
	            	alert("<spring:message code='ezEmail.t24' />");
	                if (ReturnFunction != null)
	                    ReturnFunction(1);
	                else
	                    window.returnValue = 1;
	                window.close();
	            }
	            else if (xmlHTTP.status == 200 && xmlHTTP.responseText == "GROUP_NAME") {
	            	alert("<spring:message code='ezEmail.t99000094' />");
	            }
	            else if (xmlHTTP.status == 200 && xmlHTTP.responseText == "GROUP_ID") {
	            	alert("<spring:message code='ezEmail.t99000095' />");
	            }
	            else {
	            	alert("<spring:message code='ezEmail.t23' />");
	            }
	        }
	
	        var pSeach = false;
	        function DisplayUserImageList() {
	            var xmlRtn = pListXML_Info;
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
	                SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	                SelectDeptNM.setAttribute("countinfo", "1")
	            }
	            if (pListType == "IMG") {
	                document.getElementById("DeptUserImgList").style.display = "";
	                document.getElementById("txtlist_Layer").style.display = "none";
	                document.getElementById("txtlist_table").style.display = "none";
	                document.getElementById("Search_txtlist_table").style.display = "none";
	                if (pSeach) {
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + "<spring:message code='ezEmail.t655' />" + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	                    SelectDeptNM.setAttribute("countinfo", "1")
	                }
	            }
	            else {
	                document.getElementById("DeptUserImgList").style.display = "none";
	                document.getElementById("txtlist_Layer").style.display = "";
	                if (!pSeach) {
	                    document.getElementById("txtlist_table").style.display = "";
	                    document.getElementById("Search_txtlist_table").style.display = "none";
	                }
	                else {
	                    document.getElementById("Search_txtlist_table").style.display = "";
	                    document.getElementById("txtlist_table").style.display = "none";
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;\" >" + "<spring:message code='ezEmail.t655' />" + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	                    SelectDeptNM.setAttribute("countinfo", "1")
	                }
	            }
	
	            for (var i = 0; i < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length; i++) {
	                if (pListType == "IMG") {
	
	                    var MainTable = document.createElement("TABLE");
	                    MainTable.setAttribute("class", pListType == "IMG" ? "organwrap" : "organwrap_list");
	                    MainTable.setAttribute("cellspacing", "0");
	                    MainTable.setAttribute("cellpadding", "0");
	                    if (pListType == "IMG")
	                        MainTable.style.marginTop = "5px";
	
	                    MainTable.style.marginLeft = "auto";
	                    MainTable.style.marginRight = "auto";
	                    var M_TR = document.createElement("TR");
	                    M_TR.setAttribute("id", "MailUserlist_" + i);
	                    M_TR.style.cursor = "pointer";
	                    M_TR.onmouseover = function () { event_listMover(this); };
	                    M_TR.onmouseout = function () { event_listMout(this); };
	                    M_TR.onclick = function () { event_listclick(this); };
	                    M_TR.ondblclick = function () { event_listDBclick(this); };
	                    M_TR.setAttribute("draggable", true);
	                    M_TR.onselectstart = function () { return false; };
	                    if (CrossYN()) {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                            }
	                        }
	                    }
	                    else {
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
	                    if ("${useOcs}" == "YES") {
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
	                }
	                else {
	                    var M_TR = document.createElement("TR");
	                    M_TR.setAttribute("id", "MailUserlist_" + i);
	                    M_TR.style.cursor = "pointer";
	                    M_TR.onmouseover = function () { event_listMover(this); };
	                    M_TR.onmouseout = function () { event_listMout(this); };
	                    M_TR.onclick = function () { event_listclick(this); };
	                    M_TR.ondblclick = function () { event_listDBclick(this); };
	                    M_TR.setAttribute("draggable", true);
	                    M_TR.onselectstart = function () { return false; };
	                    if (CrossYN()) {
	                        for (var NodeCount = 0; NodeCount < SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.length; NodeCount++) {
	                            if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName != "#text") {
	                                M_TR.setAttribute("_" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).nodeName,
	                                                  trim_Cross(SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").item(i).childNodes.item(0).childNodes.item(NodeCount).textContent));
	                            }
	                        }
	                    }
	                    else {
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
	                        if ("${useOcs}" == "YES")
	                            M_TR_TD2.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
	                        else
	                            M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA4");
	
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
	                    }
	                    else {
	                        var M_TR_TD1 = document.createElement("TD");
	                        M_TR_TD1.style.overflow = "hidden";
	                        M_TR_TD1.style.textOverflow = "ellipsis";
	                        M_TR_TD1.style.whiteSpace = "nowrap";
	                        M_TR_TD1.style.width = "150px";
	                        if ("${useOcs}" == "YES")
	                            M_TR_TD1.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
	                        else
	                            M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA4");
	
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
	        var PressShiftKey = false;
	        var PressCtrlKey = false;
	        function event_listOnkeyUp(event) {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (!event) event = window.event;
	            }
	            switch (event.keyCode) {
	                case 16: PressShiftKey = false; break;
	                case 17: PressCtrlKey = false; break;
	                case 46: deleteWork(false); break;
	            }
	        }
	
	        function event_listOnkeyDown(event) {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                if (!event) event = window.event;
	            }
	            switch (event.keyCode) {
	                case 16: PressShiftKey = true; break;
	                case 17: PressCtrlKey = true; break;
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
	                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	                        }
	
	                    }
	                    listContentArry = new Array();
	                }
	                if (PressShiftKey) {
	                    var SelectedPreObj = null;
	                    for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
	                        p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
	                        if (Cnt == 0)
	                            SelectedPreObj = p_ListOrderObject;
	
	                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
	                        }
	                    }
	                    listContentArry = new Array();
	                    if (p_ListOrderObject == null)
	                        return;
	
	                    var PrelistContent;
	                    if (SelectedPreObj == null)
	                        PrelistContent = p_ListOrderObject.getAttribute("id");
	                    else
	                        PrelistContent = SelectedPreObj.getAttribute("id");
	
	                    p_ListOrderObject = obj;
	
	                    var CurlistContent = obj.getAttribute("id");
	                    var PrePoint = parseInt(PrelistContent.replace("MailUserlist_", ""));
	                    var CurPoint = parseInt(CurlistContent.replace("MailUserlist_", ""));
	                    if (PrePoint < CurPoint) {
	
	                        for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
	                            p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
	                            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                            }
	                            listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
	                        }
	
	                    }
	                    else if (PrePoint > CurPoint) {
	                        for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
	                            p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
	                            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                            }
	                            listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
	                        }
	                    }
	                    else
	                        return;
	
	                }
	                else {
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
	                                if (listContentArry.length == 0)
	                                    p_ListOrderObject = "";
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
	            }
	            else
	                listEventCheckbox = false;
	        }
	
	        function event_listDBclick(obj) {
	            InsertReceiver("MsgToList");
	        }
	
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
	
	        function keyword_Clear() {
	            document.getElementsByName('keyword').value = "";
	        }
	
	        function InsertReceiver(pListView) {
	            var pparsingXML = "";
	            var pparsingXML2 = "";
	            var strSIP = "";
	            var pAddFlag = false;
	
	            var listid = "MsgToList";
	            var getlistview = new ListView();
	            getlistview.LoadFromID(listid);
	
	            var arrRows = getlistview.GetSelectedRows();
	            var length = arrRows.length;
	
	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	
	                var organTree = new TreeView();
	                organTree.LoadFromID("FromTreeView");
	                var nodeIdx = organTree.GetSelectNode();
	                var strId = nodeIdx.GetNodeData("CN")
	                var strName = nodeIdx.NodeName;
	
	                var bFlag = getlistview.ExistRow("data1", strId);
	                if (bFlag) {
	                    pAddFlag = true;
	                }
	                else {
	                    pparsingXML2 = "";
	                    pparsingXML = "";
	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	                    pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t15' />" + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
	                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                    Resultxml = loadXMLString(pparsingXML2);
	
	                    var listview = new ListView();
	                    listview.LoadFromID(listid);
	
	                    var MaxID = 0;
	                    var InitTr = listview.GetDataRows();
	                    var MaxCntNum = 0;
	
	                    for (var j = 0  ; j < InitTr.length  ; j++) {
	                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                        if (MaxID < curnum) {
	                            MaxID = curnum;
	                            MaxCntNum = j;
	                        }
	                    }
	
	                    var objTr = listview.AddRow(InitTr.length);
	                    if (MaxCntNum != 0)
	                        MaxCntNum = MaxCntNum + 1;
	                    SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
	                    listview.AddDataRow(objTr, Resultxml);
	
	                    var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                    for (var y = 0; y < _tdlength; y++) {
	                        document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                        document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                    }
	                }
	            }
	            else {
	                if (listContentArry != "") {
	                    for (var i = 0; i < listContentArry.length; i++) {
	                        var strId = document.getElementById(listContentArry[i]).getAttribute("_data2");
	                        var strName = document.getElementById(listContentArry[i]).getAttribute("_data4");
	                        var bFlag = getlistview.ExistRow("data1", strId);
	
	                        if (bFlag) {
	                            pAddFlag = true;
	                        }
	                        else {
	                            pparsingXML2 = "";
	                            pparsingXML = "";
	                            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
	                            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
	                            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                            Resultxml = loadXMLString(pparsingXML2);
	
	                            var listview = new ListView();
	                            listview.LoadFromID(listid);
	
	                            var MaxID = 0;
	                            var InitTr = listview.GetDataRows();
	                            var MaxCntNum = 0;
	
	                            for (var j = 0  ; j < InitTr.length  ; j++) {
	                                var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                                if (MaxID < curnum) {
	                                    MaxID = curnum;
	                                    MaxCntNum = j;
	                                }
	                            }
	
	                            var objTr = listview.AddRow(InitTr.length);
	                            if (MaxCntNum != 0)
	                                MaxCntNum = MaxCntNum + 1;
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
	                else {
	                	var organTree = new TreeView();
		                organTree.LoadFromID("FromTreeView");
		                var nodeIdx = organTree.GetSelectNode();
		                
	                	var strId = nodeIdx.GetNodeData("CN")
		                var strName = nodeIdx.NodeName;
		
		                var bFlag = getlistview.ExistRow("data1", strId);
	                    if (bFlag) {
	                        pAddFlag = true;
	                    }
	                    else {
	                    	pparsingXML2 = "";
		                    pparsingXML = "";
		                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
		                    pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t15' />" + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
		                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
		                    Resultxml = loadXMLString(pparsingXML2);
		
		                    var listview = new ListView();
		                    listview.LoadFromID(listid);
		
		                    var MaxID = 0;
		                    var InitTr = listview.GetDataRows();
		                    var MaxCntNum = 0;
		
		                    for (var j = 0  ; j < InitTr.length  ; j++) {
		                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
		                        if (MaxID < curnum) {
		                            MaxID = curnum;
		                            MaxCntNum = j;
		                        }
		                    }
		
		                    var objTr = listview.AddRow(InitTr.length);
		                    if (MaxCntNum != 0)
		                        MaxCntNum = MaxCntNum + 1;
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
	            var listid = "MsgToList";
	        }
	
	        function CheckMailReceiver(selRow, option) {
	            var rtnValue = false;
	            var email;
	            if (option == "1")
	                email = selRow.cells[0].DATA3;
	            else if (option == "2")
	                email = selRow.cells[0].DATA2;
	            else if (option == "3")
	                email = selRow;
	
	            var _listview = new ListView();
	            _listview.LoadFromID("MsgToList");
	            var arrRows = _listview.GetDataRows();
	            for (count2 = 0; count2 < arrRows.length; count2++) {
	                if (email == arrRows[count2].getAttribute("data1"))
	                    rtnValue = true;
	            }
	            return rtnValue
	        }
	
	        function DeleteReceiver(pListView) {
	            var listid = "MsgToList";
	            var selList = new ListView();
	            selList.LoadFromID(listid);
	
	            var arrRows = selList.GetSelectedRows();
	            var strName = "";
	
	            for (var i = 0; i < arrRows.length; i++) {
	                selList.DeleteRow(arrRows[i].id);
	            }
	        }
	
	    </script>
	</head>
	<body class="popup">
	    <xml id="listviewheader" style="display: none"> 
	<LISTVIEWDATA> 
	    <HEADERS> 
	        <HEADER> 
	            <NAME><spring:message code='ezEmail.t27' /></NAME>
	            <WIDTH>60</WIDTH>
	        </HEADER>   
	        <HEADER> 
	            <NAME><spring:message code='ezEmail.t28' /></NAME> 
	            <WIDTH>70</WIDTH> 
	        </HEADER> 
	        <HEADER>
	            <NAME><spring:message code='ezEmail.t29' /></NAME>
	            <WIDTH>90</WIDTH>
	        </HEADER>                 
	    </HEADERS> 
	</LISTVIEWDATA> 
	</xml>
	    <form method="post">
	         <div id="menu">
	            <ul>
	                <li><span onclick="return OK_Click()"><spring:message code='ezEmail.t378' /></span></li>
	            </ul>
	        </div>
	        <div id="close">
	            <ul>
	                <li><span onclick="window.close()"><spring:message code='ezEmail.t63' /></span></li>
	            </ul>
	        </div>
	
	         <table class="content">
	            <tr>
	                <th><spring:message code='ezEmail.t710' /></th>
	                <td>
	                    <input name="TextName" type="text" id="TextName" maxlength="24" class="txtClass" style="width:99%;" value="${textName}">
	                </td>
	            </tr>
	            <tr>
	                <th><spring:message code='ezEmail.t99000092' /></th>
	                <td>
	                    <input name="TextId" type="text" id="TextId" maxlength="24" class="txtClass" style="width:99%;" value="${cn}">
	                </td>
	            </tr>
	        </table>
	        <table id="TreeViewTD">
	                    <tr>
	                        <td>
	                            <div class="portlet_tabpart03" style="background-color: #e9e9e9; margin-top: 4px;">
	                                <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #d3d2d2;">
	                                    <table style="margin-top: 3px; width: 100%;">
	                                        <tr>
	                                            <td>
	                                                 <div style="padding-left:60px">
	                                                    <input name="Input" id="deptkeyword" style="WIDTH: 110px; margin: 0px;" onkeypress="deptsearch_press()">
	                                                    <a class="imgbtn"><span onclick="deptsearch_click()"><spring:message code='ezEmail.t30' /></span></a>
	                                                 </div>
	                                            </td>
	                                            <td>
	                                                <div style="float:right">
	                                                    <select id="search_type">
	                                                        <option selected value="displayName"><spring:message code='ezEmail.t31' /></option>
	                                                        <option value="description"><spring:message code='ezEmail.t26' /></option>
	                                                        <option value="title"><spring:message code='ezEmail.t28' /></option>
	                                                        <option value="extensionAttribute10"><spring:message code='ezEmail.t334' /></option>
	                                                        <option value="telephoneNumber"><spring:message code='ezEmail.t29' /></option>
	                                                        <option value="mobile"><spring:message code='ezEmail.t32' /></option>
	                                                        <option value="homePhone"><spring:message code='ezEmail.t33' /></option>
	                                                        <option value="facsimileTelephoneNumber"><spring:message code='ezEmail.t34' /></option>
	                                                        <option value="mail"><spring:message code='ezEmail.t35' /></option>
	                                                        <option value="streetAddress"><spring:message code='ezEmail.t36' /></option>
	                                                    </select>
	                                                    <input id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px;">
	                                                    <a class="imgbtn"><span onclick="search_click()"><spring:message code='ezEmail.t37' /></span></a>
	
	                                                </div>
	                                            </td>    
	                                            <td>
	                                            </td>
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
	                                                        <span onclick="ChangeListView_onClick('TXT');">
	                                                            <img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
	                                                        <span onclick="ChangeListView_onClick('IMG');">
	                                                            <img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
	                                                    </span>
	                                                </th>
	                                            </tr>
	                                        </table>
	                                        <div style="vertical-align: top; height: 440px; overflow: auto; width: 440px;" id="txtlist_Layer">
	                                            <table style="width:100%; border: 1px solid #B6B6B6; display: none;" id="txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 150px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t31' /></td>
	                                                    <td style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t28' /></td>
	                                                    <td class="td_gray" style="font-weight: bold;"><spring:message code='ezEmail.t29' /></td>
	                                                </tr>
	                                            </table>
	                                            <table style="width:100%; border: 1px solid #B6B6B6; display: none;" id="Search_txtlist_table" class="mainlist">
	                                                <tr>
	                                                    <td style="width: 110px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t26' /></td>
	                                                    <td style="width: 90px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t31' /></td>
	                                                    <td style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t28' /></td>
	                                                    <td class="td_gray" style="font-weight: bold;"><spring:message code='ezEmail.t29' /></td>
	                                                </tr>
	                                            </table>
	                                        </div>
	                                        <div style="vertical-align: top; text-align: center; height: 440px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div>
	                                </tr>
	                            </table>
	                        </td>
	                        <td style="width: 30px; text-align: center;">
	                            <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0"
	                                style="cursor: pointer;" onclick="InsertReceiver(ListViewMsgTo)"><br>
	                            <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0"
	                                style="cursor: pointer;" onclick="DeleteReceiver(ListViewMsgTo)">
	                        </td>
	                        <td >                                                 
	                             <h2 id="ToTitle" class="receiver_tltype01" style="cursor: pointer; margin-top:5px">
	                                <span style="min-width: 45px;" id="ToTitleStr"><spring:message code='ezEmail.t659' /></span>
	                            </h2>
	                            <div class="listview">
	                                  <div id="ListViewMsgTo" style="width: 220px; Height: 477px; overflow-x: auto; overflow-y: auto;"  ondblclick="DeleteReceiver(ListViewMsgTo)"></div>
	                            </div>       
	                        </td>
	                    </tr>
	                </table>
	    </form>
	</body>
</html>
