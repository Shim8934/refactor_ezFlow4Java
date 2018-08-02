<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t8' /></title>
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
	    <link rel="stylesheet" href="/css/Tab.css" type="text/css">
	    <link rel="stylesheet" href="/js/ezEmail/Controls/ezSearchDatePicker.htc" type="text/css">
	    <link rel="stylesheet" href="<spring:message code="main.lhm01" />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script src="/js/ezPersonal/controls/TreeView.js" type="text/javascript"></script>
	    <script type="text/javascript" src="/js/ezEmail/Controls/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <style>
	    	.mainlist thead tr {
	    		height: 0px;
	    	}
	    	.mainlist tr td:first-child {
	    		padding-left:15px;	    		
	    	}
	    	.box {
	    		border-right:0px;
	    	}
	    </style>
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
	        var m_orgImg = { "normal": "/images/tab_org1.gif", "select": "/images/tab_org.gif" };
	        var m_dlImg = { "normal": "/imagefs/tab_dl1.gif", "select": "/images/tab_dl.gif" };
	        var m_contactImg = { "normal": "/images/tab_addr1.gif", "select": "/images/tab_addr.gif" };
	        var m_tabDialogState = { "org": "select", "contact": "normal", "dl": "normal" };
	        var ua = navigator.userAgent;
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
				
	            var xmlpara = createXmlDom();
                var xmlTree = createXmlDom();
                var xmlHTTP = createXMLHttpRequest();
                var objNode;
                createNodeInsert(xmlpara, objNode, "DATA");
                createNodeAndInsertText(xmlpara, objNode, "DEPTID", "${deptID}");
                createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top");
                createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
	            xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	            xmlHTTP.send(xmlpara);
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
	            orgTabButton_onClick();
	            
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
	            
	            ChangeListView_onClick(getOrganListType());
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
	                        if(getNodeText(GetChildNodes(nodes[i])[0]) == "user"){
	                            pparsingXML = pparsingXML + "<VALUE>" + getNodeText(GetChildNodes(nodes[i])[2]) + "</VALUE></CELL></ROW>";
	                        	
	                        } else if (getNodeText(GetChildNodes(nodes[i])[0]) == "group"){
	                            pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t15' />" + getNodeText(GetChildNodes(nodes[i])[2]) + "</VALUE></CELL></ROW>";
	                        } else if (getNodeText(GetChildNodes(nodes[i])[0]) == "distribution") {
	                            pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t57' /> : " + getNodeText(GetChildNodes(nodes[i])[2]) + "</VALUE></CELL></ROW>";
	                        }
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
	            document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >" + nodeIdx.GetNodeData("VALUE");
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
		        		var resultXML = loadXMLString(result);
		        		var headerData = createXmlDom();
		        		
	                    headerData = loadXMLString(result);
// 	                    headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
	
	                    if (CrossYN()) {
	                        var xmlRtn = resultXML.documentElement.getElementsByTagName("ROWS")[0];
	                        var Node = headerData.importNode(xmlRtn, true);
	                        headerData.documentElement.appendChild(Node);
	                    }
	                    else {
	                        var xmlRtn = resultXML.documentElement.getElementsByTagName("ROWS")[0];
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
	        	
	        	$.ajax({
					url : "/ezOrgan/getDeptMemberListCount.do",
					method : "POST",
					dataType : "json",
					data : {
						deptID : DeptID
					},
					success : function(result) {
						var deptName = document.getElementsByClassName("node_selected")[0].innerHTML;
						
						if (SelectDeptNM.getAttribute("countinfo") != "1" && !pSeach ) {
							if (result.containLow == "YES") {
								var id = $("span[class=node_selected]").eq(0).closest("div").attr("id");
								var strIsLeaf = $("div#" + id + "").attr("isleaf");
	
								if (strIsLeaf == "TRUE") { //하위가 없으면
				        			SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + result.totalCount + strLang1 + "</span>]";
				        		} else { //하위가 있으면
				        			SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + result.totalCount + strLang1 + "</span>/<spring:message code='ezAddress.t362' /> <span style='color:#017BEC;'>" + result.totalCount2 + strLang1 + "</span>]";
				        		}
							} else {
								SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + result.totalCount + strLang1 + "</span>]";
							}			            	
			            	SelectDeptNM.setAttribute("countinfo","1")
			        	}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert(error);
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
	        	p_ListOrderObject = null;
	        	var searchKeyword = document.all("keyword").value.trim();
	        	
	            if (searchKeyword == "") {
	                alert("<spring:message code='ezEmail.t10' />");
	                document.all("keyword").value = searchKeyword;
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
	                    headerData = loadXMLString(result);
// 	                    headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
						
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
	            // 검색어 양쪽의 whitespace를 제거한다.
	            var searchWord = document.all("deptkeyword").value.trim();
	            // whitespace를 제거한 스트링으로 Text Box를 다시 세트한다.
	            document.all("deptkeyword").value = searchWord;
	            
	            if (searchWord == "") {
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
		        		search : "displayname::" + searchWord, 
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
	                alert("<spring:message code='ezEmail.lhm10' />");
	                document.all("TextId").focus();
	                return;
	            }
	            
	            var regex=/^([\w-]+(?:\.[\w-]+)*)$/;
	            if(regex.test(document.all("TextId").value.trim()) === false) {
	            	alert("<spring:message code='ezEmail.lhm13' />");
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
	            
	            var memberList = document.getElementById("ListViewMsgTo").children.item(0).children.item(1).children;
	            var memberListLength = memberList.length;
	            
	            if (memberListLength <= 0) {
	            	alert("<spring:message code='ezSchedule.t197' />");
	            	return;
	            }
	            
	            for (var i = 0; i < memberListLength; i++) {
	                createNodeAndInsertText(xmlDom, objNode, "MEMBERID", memberList.item(i).getAttribute("data1"));
	
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
	            	alert("<spring:message code='ezEmail.lhm11' />");
	            }
	            else if (xmlHTTP.status == 200 && xmlHTTP.responseText == "GROUP_ID") {
	            	alert("<spring:message code='ezEmail.lhm12' />");
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
	           /*  if (SelectDeptNM.getAttribute("countinfo") != "1" && SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length && SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length != "") {
	                //SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	                if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length ==  getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0])) {
	        			SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	        		} else {
	        			SelectDeptNM.innerHTML += "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + "/" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0]) + strLang1 + "</span>]";
	        		}
	                
	                SelectDeptNM.setAttribute("countinfo", "1")
	            } */
	            if (pListType == "IMG") {
	                document.getElementById("DeptUserImgList").style.display = "";
	                document.getElementById("txtlist_Layer").style.display = "none";
	                document.getElementById("txtlist_table").style.display = "none";
	                document.getElementById("Search_txtlist_table").style.display = "none";
	                if (pSeach) {
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >" + "<spring:message code='ezEmail.t655' />" + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
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
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >" + "<spring:message code='ezEmail.t655' />" + "" + "-[<span style='color:#017BEC;'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
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
	
	        var m_strColorSelect = "#edf4fd";
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
	                        
	                        if (p_ListOrderObject != null) {
		                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
		                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
		                        }
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
	            setOrganListType(pListType);
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
				
	            if (m_selectedTree == orglistView) {
		            if (p_ListOrderObject == null || p_ListOrderObject == "") {
		
		                var organTree = new TreeView();
		                organTree.LoadFromID("FromTreeView");
		                var nodeIdx = organTree.GetSelectNode();
		                var strId = nodeIdx.GetNodeData("CN");
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
			                
		                	var strId = nodeIdx.GetNodeData("CN");
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
	            } else if (m_selectedTree == ListViewDL) {
	            	var pListViewDL = new ListView();
	                pListViewDL.LoadFromID("pListViewDL");
	                var arrRows = pListViewDL.GetSelectedRows();
	                if (arrRows.length > 0) {
	                	for (var i = 0; i < arrRows.length; i++) {
		                	var strId = GetAttribute(arrRows[i], "DATA1");
			                var strName = arrRows[i].innerText;
			
			                var bFlag = getlistview.ExistRow("data1", strId);
		                    if (bFlag) {
		                        pAddFlag = true;
		                    }
		                    else {
		                    	pparsingXML2 = "";
			                    pparsingXML = "";
			                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
			                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + strId + "</DATA1>";
			                    pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t57' /> :" +MakeXMLString(strName) + "</VALUE></CELL></ROW>";
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
	            }
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
			
	        function orgTabButton_onClick() {
	        	methodForTabAction(1);
		        selTab = "orglistView";
		        m_tabDialogState["org"] = "select";
		        m_tabDialogState["contact"] = "normal";
		        m_tabDialogState["dl"] = "normal";
		        ImageUpdate();
		        TreeViewTD.style.display = "block";
		        ListViewTD.style.display = "none";
		        ListViewDLTD.style.display = "none";
		        ListViewINPUT.style.display = "none";
		        dlmember.style.display = "none";
		        m_selectedTree = orglistView;
		        AddrSearch.style.display = "none";
		    }
	        
	        function dlTabButton_onClick() {
	        	methodForTabAction(3);
		        m_tabDialogState["org"] = "normal";
		        m_tabDialogState["contact"] = "normal";
		        m_tabDialogState["dl"] = "select";
		        ImageUpdate();
		        TreeViewTD.style.display = "none";
		        ListViewTD.style.display = "none";
		        ListViewDLTD.style.display = "block";
		        ListViewINPUT.style.display = "none";
		        dlmember.style.display = "block";
		        AddrSearch.style.display = "none";
		        m_selectedTree = ListViewDL;
		        try {
		        	var xmlDom = createXmlDom();
		            var xmlHTTP = createXMLHttpRequest();
		            
		            var objRoot;
		            createNodeInsert(xmlDom, objRoot, "DATA");
		            createNodeAndInsertText(xmlDom, objRoot, "COMPID", companyid);
		            
		            if (cn != null) {
		            	createNodeAndInsertText(xmlDom, objRoot, "CN", cn);
		            }
		            
		            xmlHTTP.open("POST", "/admin/ezEmail/mailGetDistribution.do", false);
		            xmlHTTP.send(xmlDom);
		        } catch (e) {
		            alert("<spring:message code='ezEmail.t574' />" + e.description);
		            xmlHTTP = null;
		            return;
		        }
		        if (xmlHTTP.status != 200) {
		            alert("<spring:message code='ezEmail.t574' />" + xmlHTTP.statusText);
		                xmlHTTP = null;
		                xmlDom = null;
		                return;
	            }
	            document.getElementById("ListViewDL").innerHTML = "";
	            var pListViewDL = new ListView();
	            pListViewDL.SetID("pListViewDL");
	            pListViewDL.SetSelectFlag(false);
	            pListViewDL.SetMulSelectable(true);
	            pListViewDL.SetRowOnDblClick("ListViewNodeDblClick");
	            pListViewDL.DataSource(loadXMLString(document.getElementById("listviewheader3").innerHTML.toUpperCase()));
	            pListViewDL.DataBind("ListViewDL");
	            pListViewDL.DataSource(loadXMLString(xmlHTTP.responseText));
	            pListViewDL.RowDataBind();
	
	            for (var i = 0; i < pListViewDL.GetRowCount() ; i++) {
	                pListViewDL.GetDataRows()[i].draggable = true;
	                if (CrossYN())
	                    pListViewDL.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
	                else
	                    pListViewDL.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); };
	
	                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                    pListViewDL.GetDataRows()[i].ondragend = function (event) { event_listdragend(event); };
	                }
	            }
	        }
	        function event_listdragend(evt) {
                evt.stopPropagation();
                evt.preventDefault();
                if (dropelement != "")
                    InsertReceiver(document.getElementById(dropelement));
            }
            
            function event_listdragstart(obj) {
                dropelement = "";
                var islist = false;
                if (m_selectedTree == AddressListView) {
                    var pListViewDL = new ListView();
                    pListViewDL.LoadFromID("Address");
                    for (var i = 0; i < pListViewDL.GetSelectedRows().length; i++) {
                        if (pListViewDL.GetSelectedRows()[i].id == obj.id) {
                            islist = true;
                            break;
                        }
                    }
                    if (!islist)
                        obj.onclick();
                }
                else if (m_selectedTree == ListViewDL) {
                    var pListViewDL = new ListView();
                    pListViewDL.LoadFromID("pListViewDL");
                    for (var i = 0; i < pListViewDL.GetSelectedRows().length; i++) {
                        if (pListViewDL.GetSelectedRows()[i].id == obj.id) {
                            islist = true;
                            break;
                        }
                    }
                    if (!islist)
                        obj.onclick();
                }
                else if (m_selectedTree == orglistView) {
                    for (var i = 0; i < listContentArry.length; i++) {
                        if (listContentArry[i] == obj.getAttribute("id")) {
                            islist = true;
                            break;
                        }
                    }
                    if (!islist)
                        event_listclick(obj);
                }
            }
            
	        function ImageUpdate() {
	            return (navigator.userAgent.indexOf('Firefox') != -1) ?
	                (function () {
	                    orgTabButton.setAttribute('src', m_orgImg[m_tabDialogState["org"]]);
	                    dlTabButton.setAttribute('src', m_dlImg[m_tabDialogState["dl"]]);
	                }).call(this)
	                : (CrossYN()) ?
	                (function () {
	                    orgTabButton.setAttribute('src', m_orgImg[m_tabDialogState["org"]]);
	                    dlTabButton.setAttribute('src', m_dlImg[m_tabDialogState["dl"]]);
	                }).call(this)
	                :
	                (function () {
	                    orgTabButton.src = m_orgImg[m_tabDialogState["org"]];
	                    dlTabButton.src = m_dlImg[m_tabDialogState["dl"]];
	                }).call(this)
	            ;
	        }
	        
	        function ListViewNodeDblClick() {
	                InsertReceiver("MsgToList");
	        }
	        
	        function infoview_click() {
	            if (p_ListOrderObject == null || p_ListOrderObject == "") {
	                alert("<spring:message code='ezEmail.t579' />");
	                return;
	            }
	            var id = p_ListOrderObject.getAttribute("_DATA2");
	            var dept = p_ListOrderObject.getAttribute("_DATA13");
	            var rtn
	            var width = 420, height = 450;
	            var leftPosition, topPosition;
	            leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
	            topPosition = (window.screen.height / 2) - ((height / 2) + 50);
	
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        }
	        
	        var mail_select_dlmember_cross_dialogArguments = new Array();
	        function dlmember_click() {
	            var DlList = new ListView();
	            DlList.LoadFromID("pListViewDL");
	            var arrRows = DlList.GetSelectedRows();
	            if (arrRows.length < 1) {
	                alert("<spring:message code='ezEmail.t580' />");
	                return;
	            }
	            if (ReturnFunction != null) {
	                var rtnValue = { "name": new Array(), "email": new Array() };
	                mail_select_dlmember_cross_dialogArguments[0] = rtnValue;
	                mail_select_dlmember_cross_dialogArguments[1] = dlmember_click_Complete;
	                mail_select_dlmember_cross_dialogArguments[2] = DivPopUpHidden;
	                DivPopUpShow(601, 470, "/ezEmail/mailSelectDLMember.do?cn=" + GetAttribute(arrRows[0], "DATA1"));
	            }
	            else {
	                var rtnValue = { "name": new Array(), "email": new Array() };
	                var count = window.showModalDialog("/ezEmail/mailSelectDLMember.do?cn=" + GetAttribute(arrRows[0], "DATA1"), rtnValue, "dialogHeight:470px; dialogWidth:601px; status:no;scroll:auto; help:no; edge:sunken");
	                var listid = "";
	
	                if (m_selectedWindow.id == "ListViewMsgTo") {
	                    var listviewTo = new ListView();
	                    listviewTo.LoadFromID("MsgToList");
	                    var InitTrTo = listviewTo.GetDataRows();
	                    var pparsingXML = "";
	                    var pparsingXML2 = "";
	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                    var aa = 0;
	                    for (var i = 0; i < count; i++) {
	                        var IsInsert = CheckMailReceiver(rtnValue["email"][i], "3");
	                        if (!IsInsert) {
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(rtnValue["name"][i]) + "</DATA1>";
	                            pparsingXML = pparsingXML + "<DATA2>" + rtnValue["email"][i] + "</DATA2>";
	                            pparsingXML = pparsingXML + "<DATA3></DATA3>";
	                            pparsingXML = pparsingXML + "<DATA4></DATA4>";
	                            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(rtnValue["name"][i]) + " &lt;" + rtnValue["email"][i] + "&gt;" + "</VALUE></CELL></ROW>";
	                        }
	                    }
	                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	
	                    var Resultxml = loadXMLString(pparsingXML2);
	
	                    var listview = new ListView();
	                    listview.SetID("MsgToList");
	                    listview.SetHeightFree(true);
	                    listview.SetSelectFlag(false);
	                    listview.SetMulSelectable(false);
	                    listview.SetRowOnDblClick("DeleteReceiver");
	                    listview.DataSource(Resultxml);
	                    listview.RowDataBind2();
	                }
	            }
	        }
	        
	        function dlmember_click_Complete(count) {
	            DivPopUpHidden();
	            try {
	                if (m_selectedWindow.id == "ListViewMsgTo") {
	                    var listviewTo = new ListView();
	                    listviewTo.LoadFromID("MsgToList");
	                    var InitTrTo = listviewTo.GetDataRows();
	                    var pparsingXML = "";
	                    var pparsingXML2 = "";
	                    var aa = 0;
	                    for (var i = 0; i < count; i++) {
	                        var IsInsert = CheckMailReceiver(mail_select_dlmember_cross_dialogArguments[0]["email"][i], "3");
	                        if (!IsInsert) {
	                        	pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(mail_select_dlmember_cross_dialogArguments[0]["name"][i]) + "</DATA1>";
	                            pparsingXML = pparsingXML + "<DATA2>" + mail_select_dlmember_cross_dialogArguments[0]["email"][i] + "</DATA2>";
	                            pparsingXML = pparsingXML + "<DATA3></DATA3>";
	                            pparsingXML = pparsingXML + "<DATA4></DATA4>";
	                            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(mail_select_dlmember_cross_dialogArguments[0]["name"][i]) + " &lt;" + mail_select_dlmember_cross_dialogArguments[0]["email"][i] + "&gt;" + "</VALUE></CELL></ROW>";
	                            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                            var Resultxml = loadXMLString(pparsingXML2);
	                            
	                            pparsingXML2 = "";
	                            pparsingXML = "";
	                            
	                            var listview = new ListView();
	                            listview.LoadFromID("MsgToList");
	                            
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

                                document.getElementById("MsgToList").className = "receiver_list";
                                var _tdlength = document.getElementById("MsgToList").getElementsByTagName("TD").length;
                                for (var y = 0; y < _tdlength; y++) {
                                    document.getElementById("MsgToList").getElementsByTagName("TD")[y].style.textOverflow = "";
                                    document.getElementById("MsgToList").getElementsByTagName("TD")[y].style.overflow = "";
                                }

                            }
                        }
	                }
	            } catch (e) { }
	        }
	        
	        function dept_select() {
	            var organTree = new TreeView();
	            organTree.LoadFromID("FromTreeView");
	
	            var nodeIdx = organTree.GetSelectNode();
	
	            if (nodeIdx != -1) {
	                var IsInsert = CheckMailReceiver(nodeIdx.GetNodeData("MAIL"), "3");
	
	                if (!IsInsert) {
	                    var organTree = new TreeView();
	                    organTree.LoadFromID("FromTreeView");
	
	                    var nodeIdx = organTree.GetSelectNode();
	
	                    var listid = "MsgToList";
	                    var strSIP = "";
	
	                    var listview = new ListView();
	                    listview.LoadFromID(listid);
						
	                    var strId = nodeIdx.GetNodeData("CN");
	                    var strDeptNM = nodeIdx.NodeName;
	                    var strEmail = nodeIdx.GetNodeData("MAIL");
	
	                    var pparsingXML = "";
	
	                    var getlistview = new ListView();
	                    getlistview.LoadFromID(listid);
	                    var bFlag = getlistview.ExistRow("DATA3", strEmail);
	
	                    if (bFlag) {
	                        return;
	                    }
	                    else {
	                        pparsingXML = "<LISTVIEWDATA2><ROWS>";
	                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
	                        pparsingXML = pparsingXML + "<DATA2>" + strEmail + "</DATA2>";
	                        pparsingXML = pparsingXML + "<DATA3><![CDATA[" + MakeXMLString(strDeptNM) + "]]></DATA3>";
	                        pparsingXML = pparsingXML + "<DATA4>" + strSIP + "</DATA4>";
	                        pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t15' />" + MakeXMLString(strDeptNM) + "</VALUE></CELL></ROW>";
	                        pparsingXML = pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                    }
	
	                    Resultxml = loadXMLString(pparsingXML);
	
	                    var listview = new ListView();
	                    listview.LoadFromID(listid);
	
	                    var MaxID = 0;
	                    var InitTr = listview.GetDataRows();
	
	                    for (var j = 0  ; j < InitTr.length  ; j++) {
	                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                        if (MaxID < curnum)
	                            MaxID = curnum;
	                    }
	
	                    var objTr = listview.AddRow(InitTr.length);
	                    SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxID).substring(0, listview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1) + eval(MaxID + 1));
	                    listview.AddDataRow(objTr, Resultxml);
	
	                    document.getElementById(listid).className = "receiver_list";
	                    var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                    for (var y = 0; y < _tdlength; y++) {
	                        document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                        document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                    }
	                }
	            }
	        }
	        function onDragEnter(evt, obj) {
                evt.stopPropagation();
                evt.preventDefault();
                evt.dataTransfer.dropEffect = "copy";
                evt.dataTransfer.effectAllowed = "copy";
                dropelement = obj.id;
            }
	        
            function onDrop(evt, element) {
                evt.stopPropagation();
                evt.preventDefault();
                InsertReceiver(element);
            }
	        function setOrganListType(pListType) {
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		url : "/ezOrgan/setListType.do",
	        		async : false,
	        		data : {
	        			listType : pListType
	        		},
	        		success : function(result) {
	        			
	        		}
	        		
	        	})
	        }
	        
	        function getOrganListType() {
	        	var organListType = "TXT";
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		url : "/ezOrgan/getListType.do",
	        		async : false,
	        		success : function(result) {
	        			organListType = result;
	        		}
	        	})
	        	return organListType;
	        }
	        
	        function SelectReceiverWindow(Title, selectedWindow) {
	            for (var count = 0; count < m_receiverTitleList.length; count++) {
	                m_receiverTitleList[count].style.fontWeight = "normal";
	                m_receiverWindowList[count].style.backgroundColor = m_titleNoneSelectedColor;
	                m_receiverWindowList[count].normalColor = m_titleNoneSelectedColor;
	                m_receiverTitleList[count].setAttribute("class", "receiver_tltype02");
	            }
	            Title.style.fontWeight = "bold";
	            Title.setAttribute("class", "receiver_tltype01");
	            if (type == "")
	                selectedWindow.style.backgroundColor = m_titleSelectedColor;
	            else
	                selectedWindow.style.backgroundColor = "white";
	
	            selectedWindow.normalColor = m_titleSelectedColor;
	            m_selectedWindow = selectedWindow;
	        }
	        
	        function methodForTabAction(target) {
            	var tab1 = document.getElementById("orgTabButton").children[0];
            	var tab3 = document.getElementById("dlTabButton").children[0];
            	if (target == 1) {
            		tab1.className = "tabon";
            		tab3.className = "";
            	} else if (target == 3) {
            		tab1.className = "";
            		tab3.className = "tabon";
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
    	</script>
	</head>
	<body class="popup" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);" style="overflow:hidden">
		<xml id="listviewheader" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t586' /></NAME>
		        <WIDTH>40</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME>E-MAIL</NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		    <xml id="listviewheader2" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>	
		        <NAME><spring:message code='ezEmail.t31' /></NAME>
		        <WIDTH>60</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t28' /></NAME>
		        <WIDTH>50</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t29' /></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		    <xml id="listviewheader3" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t57' /></NAME>
		        <WIDTH>70</WIDTH>
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
		                <li><span onclick="window.close()"></span></li>
		            </ul>
		        </div>
		
		         <table class="content">
		            <tr>
		                <th><spring:message code='ezEmail.t710' /></th>
		                <td>
		                    &nbsp;<input name="TextName" type="text" id="TextName" maxlength="24" class="txtClass" style="width:99%;" value="${textName}">
		                </td>
		            </tr>
		            <tr>
		                <th><spring:message code='ezEmail.lhm09' /></th>
		                <td>
		                    &nbsp;<input name="TextId" type="text" id="TextId" maxlength="24" class="txtClass" style="width:99%;" value="${cn}">
		                </td>
		            </tr>
		        </table>
		    <table style="width:100%;margin-top:10px">
		        <tr>
		            <td style="vertical-align: top;">
		            	<div class="portlet_tabpart01" style="margin:0px;">
		            		<div class="portlet_tabpart01_top" id="tab1" style="margin-bottom:3px;">
		            			<p id="orgTabButton">
		            				<span onclick="orgTabButton_onClick()"><spring:message code='ezEmail.t591' /></span>
		            			</p>
		            			<p id="dlTabButton">
		            				<span onclick="dlTabButton_onClick()"><spring:message code='ezEmail.t593' /></span>
		            			</p>
		            		</div>
	            		</div>
		                <table id="TreeViewTD">
		                    <tr>
		                        <td>
		                            <div class="portlet_tabpart03" style="background-color: #f8f8f8; margin-top: 4px;">
		                                <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #d3d2d2;">
		                                    <table style="margin-top: 3px; width: 100%;">
		                                        <tr>
		                                            <td>
		                                                <div style="margin-left: 5px;">
		                                                    <select id="search_type">
		                                                        <option selected value="displayname" usedefault="1"><spring:message code='ezEmail.t31' /></option>
		                                                        <option value="description" usedefault="1"><spring:message code='ezEmail.t26' /></option>
		                                                        <option value="title" usedefault="1"><spring:message code='ezEmail.t28' /></option>
		                                                        <option value="extensionAttribute10" usedefault="1"><spring:message code='ezEmail.t281' /></option>
		                                                        <option value="telephonenumber" usedefault="1"><spring:message code='ezEmail.t99000045' /></option>
		                                                        <option value="mobile" usedefault="0"><spring:message code='ezEmail.t99000046' /></option>
		                                                        <option value="HomePhone" usedefault="0"><spring:message code='ezEmail.t29' /></option>
		                                                        <option value="facsimileTelephoneNumber" usedefault="0"><spring:message code='ezEmail.t99000047' /></option>
		                                                        <option value="mail" usedefault="0"><spring:message code='ezEmail.t99000048' /></option>
		                                                        <option value="streetAddress" usedefault="0"><spring:message code='ezEmail.t99000049' /></option>
		                                                    </select>
		                                                    <input id="keyword" value="" onkeypress="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px;height:22px">
		                                                    <a class="imgbtn"><span onclick="search_click('search')"><spring:message code='ezEmail.t37' /></span></a>
		
		                                                </div>
		                                            </td>
		                                            <td>
		                                                <div style="float: right; margin-right: 5px; position: relative;">
		                                                    <a href="#" class="imgbtn" id="dept_select"><span onclick="dept_select()" style="z-index:10"><spring:message code='ezEmail.t596' /></span></a>
		                                                    <a href="#" class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezEmail.t597' /></span></a>
		                                                </div>
		                                            </td>
		                                        </tr>
		                                    </table>
		                                </div>
		                            </div>
		                            <table style="margin-top: 3px;">
		                                <tr>
		                                    <td class="box" style="border-right:0px">
		                                        <div style="width: 220px; height: 445px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
		                                    </td>
		                                    <td></td>
		                                    <td class="listview" style="width: 432px" id="orglistView">
		                                        <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
		                                            <tr>
		                                                <th style="white-space:normal">
		                                                    <span id="SelectDeptNM" style="font-weight: bold; width: 300px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;"></span>
		                                                    <span style="float:right; position: relative;">
		                                                        <span onclick="ChangeListView_onClick('TXT');">
		                                                            <img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
		                                                        <span onclick="ChangeListView_onClick('IMG');">
		                                                            <img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
		                                                    </span>
		                                                </th>
		                                            </tr>
		                                        </table>
		                                        <div style="vertical-align: top; height: 410px; overflow: auto; width: 446px;" id="txtlist_Layer">
		                                            <table style="width: 100%; border: 1px solid #ddd; display: none;" id="txtlist_table" class="mainlist">
		                                                <tr>
		                                                    <td style="width: 150px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t31' /></td>
		                                                    <td style="width: 130px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t28' /></td>
		                                                    <td class="td_gray" style="font-weight: bold;"><spring:message code='ezEmail.t99000045' /></td>
		                                                </tr>
		                                            </table>
		                                            <table style="width: 100%; border: 1px solid #ddd; display: none;" id="Search_txtlist_table" class="mainlist">
		                                                <tr>
		                                                    <td style="width: 110px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t26' /></td>
		                                                    <td style="width: 90px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t31' /></td>
		                                                    <td style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t28' /></td>
		                                                    <td class="td_gray" style="font-weight: bold;"><spring:message code='ezEmail.t99000045' /></td>
		                                                </tr>
		                                            </table>
		                                        </div>
		                                        <div style="vertical-align: top; text-align: center; height: 410px; overflow: auto; display: none; width: 446px;" id="DeptUserImgList"></div>
		                                        <div id="tblPageRayer2"  style="text-align:center;"></div>
		                                	</td>
		                                </tr>
		                            </table>
		                        </td>
		                    </tr>
		                </table>
		                <table id="ListViewTD" style="display: none">
		                    <tr>
		                        <td colspan="3">
		                            <table style="width: 100%;">
		                                <tr>
		                                    <td id="AddrSearch">
		                                        <div class="portlet_tabpart03" style="background-color: #f8f8f8; margin-top: 4px;">
		                                            <div class="portlet_tabpart03_top" id="Div1" style="border: 1px solid #d3d2d2;">
		                                                <table style="margin-top: 3px; width: 100%;">
		                                                    <tr>
		                                                        <td>
		                                                            <div style="margin-left: 5px;">
		                                                                <select name="search_case" id="search_case">
		                                                                    <option value="S_NAME">
		                                                                        <spring:message code='ezEmail.t31' /></option>
		                                                                    <option value="S_COMPANY">
		                                                                        <spring:message code='ezEmail.t712' /></option>
		                                                                    <option value="S_EMAIL">
		                                                                        <spring:message code='ezEmail.t713' /></option>
		                                                                </select>
		                                                                <input id="search_text" value="" onkeyup="AddrSearch_press()" style="width: 150px; margin: 0px;" name="Input">
		                                                                <a href="#" class="imgbtn">
		                                                                    <span onclick="AddrSearch_click()"><spring:message code='ezEmail.t37' /></span>
		                                                                </a>
		
		                                                            </div>
		                                                        </td>
		                                                        <td>
		                                                            <div style="float: right; margin-right: 5px;">
		                                                                <a href="#" class="imgbtn"><span onclick="groupmember_click()"><spring:message code='ezEmail.t598' /></span></a>
		                                                            </div>
		                                                        </td>
		                                                    </tr>
		                                                </table>
		                                            </div>
		                                        </div>
		                                    </td>
		                                </tr>
		                            </table>
		                        </td>
		                    </tr>
		                </table>
		                <table id="ListViewDLTD" style="display: none">
		                    <tr>
		                        <td>
		                            <div class="portlet_tabpart03" style="background-color: #f8f8f8; margin-top: 4px;">
		                                <div class="portlet_tabpart03_top" id="Div2" style="border: 1px solid #d3d2d2;">
		                                    <table style="margin-top: 3px; width: 100%;">
		                                        <tr>
		                                            <td id="dlmember" style="display: none">
		                                                <a href="#" class="imgbtn" style="float: right; margin-right: 5px;"><span onclick="dlmember_click()">
		                                                    <spring:message code='ezEmail.t598' /></span></a>
		                                            </td>
		                                        </tr>
		                                    </table>
		                                </div>
		                            </div>
		                            <div style="width: 668px; height: 474px; overflow: auto; background-color: #ffffff; margin-top: 3px;" id="ListViewDL" class="border_gray">
		                            </div>
		                        </td>
		                    </tr>
		                </table>
		                <table id="ListViewINPUT" style="display: none">
		                    <tr>
		                        <td>
		                            <div id="ManualView" style="HEIGHT: 504px; width: 667px;" class="box">
		                                <table class="content">
		                                    <tr>
		                                        <th><spring:message code='ezEmail.t31' /></th>
		                                        <td>
		                                            <input type="text" id="emailname" style="WIDTH: 99%; ime-mode: active; box-sizing: border-box; -moz-box-sizing: border-box;">
		                                        </td>
		                                    </tr>
		                                    <tr>
		                                        <th><spring:message code='ezEmail.t35' /></th>
		                                        <td>
		                                            <input type="text" id="emailaddr" style="WIDTH: 99%; ime-mode: inactive; box-sizing: border-box; -moz-box-sizing: border-box;" onkeyup="return on_keydown()">
		                                        </td>
		                                    </tr>
		                                </table>
		                               <%-- <div style="padding-top: 10px; text-align: center;"><a class="imgbtn"><span onclick="inputAddress()"><%=RM.GetString("t308")%></span></a></div>--%>
		                            </div>
		                        </td>
		                    </tr>
		                </table>
		            </td>
		            <td style="vertical-align: top;">
		                <table id="listType1">
		                    <tr id="ListMsgTo">
		                        <td style="width: 30px; text-align: center;">
		                            <img src="../../images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0"
		                                style="cursor: pointer;" onclick="InsertReceiver(ListViewMsgTo)"><br>
		                            <img src="../../images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0"
		                                style="cursor: pointer;" onclick="DeleteReceiver(ListViewMsgTo)">
		                        </td>
		                        <td style="vertical-align: top;">
		                            <h2 id="ToTitle" class="receiver_tltype01" onclick="SelectReceiverWindow(ToTitle,ListViewMsgTo)" style="cursor: pointer;">
		                                <span style="min-width: 45px;" id="ToTitleStr"><spring:message code='ezEmail.t659' /></span>
		                            </h2>
		                            <div class="receiver_borderbox">
		                                <div id="ListViewMsgTo" ondragover ="onDragEnter(event, this)" ondrop ="onDrop(event, this)" style="width: 250px; Height: 501px; overflow-x: auto; overflow-y: auto;" onclick="SelectReceiverWindow(ToTitle,this)" ondblclick="DeleteReceiver(ListViewMsgTo)"></div>
		                            </div>
		                        </td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
		    </table>
			<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
			<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
				<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
			</div>
		</form>
	</body>
</html>
