<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code="ezPersonal.yej04"/></title>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/js/ezEmail/Controls/ezSearchDatePicker.htc')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('main.lhm01', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script src="${util.addVer('/js/ezPersonal/controls/TreeView.js')}" type="text/javascript"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview_namespace.htc.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAddress/address_tree_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <style>
	    	.mainlist thead tr {
	    		height: 0px;
	    	}
	    	
	    	.mainlist #MsgToList_THEAD #MsgToList_TH {
	    		height: 0px;
	    	}
	    	
	    	.mainlist tr td:first-child {
	    		padding-left:15px;	    		
	    	}
	    	.box {
	    		border-right:0px;
	    	}
			/* 조직도 #SelectDeptNM(부서명[사원수]) 부분 */
	    	#spn_deptName {
	    		text-overflow: ellipsis;
	    		white-space: nowrap;
	    		overflow: hidden;
	    		display: inline-block;
	    	}
	    	#countInfo {
	    		overflow: hidden;
	    		display: inline-block;
	    	}
	    </style>
	    <script>
	        var cn = "${cn}";
	        var ua = navigator.userAgent.toLowerCase();
	        var browserIE = (ua.indexOf("msie") != -1) || (ua.indexOf("trident") != -1) ? true : false;
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
	        var m_tabDialogState = { "org": "select", "group": "normal"};
	        var ua = navigator.userAgent;
	        var companyId = "<c:out value='${companyId}'/>";
	        var selSpan = "";
	        var searchgubun = "N";
	        var deptId = "<c:out value='${dept}'/>";
	        var authList = [];
	        var primary = "<c:out value='${lang}'/>";
	        
	        window.onload = function () {
	            
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }

	            if (typeof window.opener.authList == "string") {
	            	authList = JSON.parse(window.opener.authList);
	   			} else {
	   				authList = JSON.parse(JSON.stringify(window.opener.authList));
	   			}
	            
				
	            recevieListview("MsgToList", "ListViewMsgTo");
	            setAuthListToXML();

	            var xmlpara = createXmlDom();
                var xmlTree = createXmlDom();
                var xmlHTTP = createXMLHttpRequest();
                var objNode;
                
                createNodeInsert(xmlpara, objNode, "DATA");
                createNodeAndInsertText(xmlpara, objNode, "DEPTID", "");
				createNodeAndInsertText(xmlpara, objNode, "TOPID", companyId + "/organ");
                
                createNodeAndInsertText(xmlpara, objNode, "PROP", "");
/*                 createNodeAndInsertText(xmlpara, objNode, "ADMINDIST", "true");
                createNodeAndInsertText(xmlpara, objNode, "DISPLAYTRASHDEPT", "true"); */
	            xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	            xmlHTTP.send(xmlpara);
	            ListTypeChangeIcon();
	            
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
	                }
	                else {
	                    alert("<spring:message code='ezEmail.t13' />" + xmlHTTP.status);
	                    xmlHTTP = null;
	                }
	            }
	            orgTabButton_onClick();
	            
	            if ("${cn}" != "") {
	                var xmlpara = createXmlDom();
	                var objRoot, objNode;
	                objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "GROUPID", "${cn}");
	                createNodeAndInsertText(xmlpara, objNode, "COMPANYID", companyId);
	
	                xmlHTTP2.open("POST", "/admin/ezOrgan/getPermissionGroupInfo.do", true);
	                xmlHTTP2.onreadystatechange = event_GetDistributionList;
	                xmlHTTP2.send(xmlpara);
	            }
	            
	            ChangeListView_onClick(getOrganListType());
	        }
		
	        var setAuthListToXML = function() {
	        	var authListLength = authList.length;
	        	
	        	for (var i = 0; i < authListLength; i++) {
	                var pparsingXML = "";
	                var pparsingXML2 = "";
	
	                pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                var userId = authList[i].userId;
	                var userType = authList[i].userType;
	                var userName = authList[i].userName;
	                var subDept = authList[i].subdeptPermitted;
	                var strName = "";
	                
	                if (userType == "DEPT") {
	                	strName = "<spring:message code='ezSurvey.t59'/>" + " : " + userName;
	                } else if (userType == "JIKWI") {
	                	strName = "<spring:message code='ezSurvey.t60'/>" + " : " + userName;
	                } else if (userType == "JIKCHEK") {
	                	strName = "<spring:message code='ezSurvey.t107'/>" + " : " + userName;
	                } else if (userType == "GROUP") {
	                	strName = "<spring:message code='ezPersonal.yej05'/>" + " : " + userName;
	                } else {
	                	strName = userName;
	                }
	
	                pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + userId + "</DATA1>";
	                pparsingXML = pparsingXML + "<DATA2><![CDATA[" + userName + "]]></DATA2>";
	                pparsingXML = pparsingXML + "<DATA4><![CDATA[" + userType + "]]></DATA4>";
	                pparsingXML = pparsingXML + "<DATA5><![CDATA[" + subDept + "]]></DATA5>";
	                pparsingXML = pparsingXML + "<VALUE><![CDATA[" + strName + "]]></VALUE></CELL></ROW>";
	
	                pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                var Resultxml = loadXMLString(pparsingXML2);
	
	                var listview = new ListView();
	                listview.LoadFromID("MsgToList");
	
	                var MaxID = 0;
	                var InitTr = listview.GetDataRows();
	
	                for (var j = 0  ; j < InitTr.length  ; j++) {
	                    var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                    if (MaxID < curnum)
	                        MaxID = curnum;
	                }
	
	                var objTr = listview.AddRow(InitTr.length);
	                SetAttribute(objTr, "id", listview.GetSelectedRowID(InitTr.length).substring(0, listview.GetSelectedRowID(InitTr.length).lastIndexOf('_') + 1) + eval(MaxID + 1));
	                
	                listview.AddDataRow(objTr, Resultxml);
	        		
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
	
	        function event_GetDistributionList() {
	            if (xmlHTTP2 != null && xmlHTTP2.readyState == 4) {
	                if (xmlHTTP2.status == 200) {
	                    var result = loadXMLString(xmlHTTP2.responseText);
 
	                    var groupNameNode = SelectNodes(result, "DATA/GROUPNAME")[0];
	                    var groupName = getNodeText(groupNameNode);
	                    document.getElementById("TextName").innerHTML = groupName;
	                    
	                    var Resultxml = "";
	                    pparsingXML2 = "";
	                    pparsingXML = "";
	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                    var nodes = SelectNodes(result, "DATA/ROW");
	                    
	                    for (var i = 0 ; i < nodes.length ; i++) {
	                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + getNodeText(GetChildNodes(nodes[i])[1]) + "</DATA1>";
	                        pparsingXML = pparsingXML + "<DATA4>" + getNodeText(GetChildNodes(nodes[i])[0]) + "</DATA4>";
		                    pparsingXML = pparsingXML + "<DATA5>" + getNodeText(GetChildNodes(nodes[i])[7]) + "</DATA5>";
	                        if(getNodeText(GetChildNodes(nodes[i])[0]) == "USER"){
	                            pparsingXML = pparsingXML + "<VALUE>" + getNodeText(GetChildNodes(nodes[i])[2]) + "</VALUE></CELL></ROW>";
	                        } else if (getNodeText(GetChildNodes(nodes[i])[0]) == "DEPT"){
	                            pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t15' />" + getNodeText(GetChildNodes(nodes[i])[2]) + "</VALUE></CELL></ROW>";
	                        }
	                    }
	                              
	                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                    Resultxml = loadXMLString(pparsingXML2);
	
	                    var listview = new ListView();
	                    listview.SetID("MsgToList");
	                    listview.SetSelectFlag(false);
	                    listview.SetMulSelectable(false);
	                    listview.SetRowOnDblClick("DeleteReceiver");
	                    listview.SetRowOnClick("SelectReceiverWindow");
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
	            listview.SetRowOnClick("SelectReceiverWindow");
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
        		document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:top;padding-right:3px;\" >" 
        		+ "<span id='spn_deptName' title='" + nodeIdx.GetNodeData("VALUE") + "'>" + nodeIdx.GetNodeData("VALUE") + "</span>"
        		+ "<span id='countInfo'></span>";
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
		        	data : {deptID : DeptID, cell : "company;description;displayName;title;telephoneNumber", prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department;userType", type : "user"},
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
						if (SelectDeptNM.getAttribute("countinfo") != "1" && !pSeach ) {
							var id = $("span[class=node_selected]").eq(0).closest("div").attr("id");
							var strIsLeaf = $("div#" + id + "").attr("isleaf");
							
							if (result.containLow == "YES" && strIsLeaf != "TRUE") { //하위가 있고, 표기방식이 [1명/ 전체10명]일 경우
			        			document.getElementById("countInfo").innerHTML += "&nbsp;&nbsp;<span class='txt_color'>" + result.totalCount + "</span> / <span class='txt_color'>" + parseInt(result.totalCount + result.totalCount2) + "</span>";
							} else {
								document.getElementById("countInfo").innerHTML += "&nbsp;&nbsp;<span class='txt_color'>" + result.totalCount + "</span>";
							}
							//2018-08-01 김보미 - 부서명 [사원수] 가 넘치는지 확인하는 함수
							deptNameLong(result.containLow, strIsLeaf);
										            	
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
	                if (g_xmlHTTP.status == 200) {
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
	                } else {
	                    alert("<spring:message code='ezEmail.t9' />" + g_xmlHTTP.status)
	                }
	
	                g_xmlHTTP = null;
	            }
	        }
	
	
	        function search_press() {
	            if (window.event.keyCode == "13") {
	                search_click();
	                window.event.cancelBubble = true;
	                if (browserIE) {
	                	event.preventDefault();	
	                }
	                else {
	                	event.returnValue = false;
	                }
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
		        		prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department;userType",
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
		     	// 2021-04-09 김은실 - 검색 시 PressShiftKey = true 되는 현상(commit 6c23f8716 참조): 모든 search_click()에 적용. 
	            PressShiftKey = false;
	
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
	            } else if (adCount == 1) {
	                bSearch = true;
	                g_xmlHTTP = createXMLHttpRequest();
	
	                if (CrossYN()) {
	                    var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).textContent + "</DEPTID><TOPID>Top</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
	                } else {
	                    var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA2").item(0).text + "</DEPTID><TOPID>Top</TOPID><PROP></PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
	                }
	
	                g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
	                g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	                g_xmlHTTP.send(strQuery);
	            } else {
	                rgParams["addrBook"] = xmlDOM;
	                rgParams["deptid"] = "";
	                var feature = "dialogHeight:372px; dialogWidth:609px; status:no;scroll:no; help:no; edge:sunken";
	                feature = feature + GetShowModalPosition(609, 460);
	
	                if (CrossYN()) {
	                    checkname2_cross_dialogArguments[0] = rgParams;
	                    checkname2_cross_dialogArguments[1] = deptsearch_click_Complete;
	                    var OpenWin = window.open("/admin/ezOrgan/checkName2.do", "checkName2_cross", GetOpenWindowfeature(609, 460));
	                    try { OpenWin.focus(); } catch (e) { }
	                } else {
	                    window.showModalDialog("/admin/ezOrgan/checkName2.do", rgParams, feature);
	
	                    if (rgParams["deptid"] != "") {
	                        bSearch = true;
	                        g_xmlHTTP = createXMLHttpRequest();
	                        var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
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
	                var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
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
	                } else {
	                    alert("<spring:message code='ezEmail.t9' />" + g_xmlHTTP.status)
	                g_xmlHTTP = null;
	            	}
	        	}
	        }        
	
	        String.prototype.trim = function () {
	            return this.replace(/(^\s*)|(\s*$)/g, "");
	        }
	
	        function OK_Click() {
	            var memberList = document.getElementById("ListViewMsgTo").children.item(0).children.item(1).children;
	            var memberListLength = memberList.length;
	            
	            if (memberListLength <= 0) {
	            	alert("<spring:message code='ezSchedule.t197' />");
	            	return;
	            }
	            
	            var popupUserList = [];
	            
	            var userListText = "";
	            
	            for (var i = 0; i < memberListLength;i++) {
	            	var memberId = memberList[i].getAttribute('data1');
	            	var memberName = memberList[i].getAttribute("data2");
	            	var memberType = memberList[i].getAttribute("data4");
	            	var subDept = memberList[i].getAttribute("data5");
	            	
	            	if (memberType == "ORGAN") {
	            		memberType = "DEPT";
	            	}
	            	
	            	if (subDept == null || subDept == undefined) {
	            		subDept = false;
	            	} else {
	            		if (subDept == "Y" || subDept == "true") {
	            			subDept = true;
	            		} else {
	            			subDept = false
	            		}
	            	}
	            	
	            	userListText += ", " + memberName
	            	popupUserList.push({"userId" : memberId, "userName" : memberName, "userType" : memberType, "subdeptPermitted" : subDept, "sn" : i });
	            }
	            
	   			window.opener.authList = JSON.stringify(popupUserList);
	   			window.opener.$("#authList_div").text(userListText.substring(1));

				window.close();
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
	                //SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	                if (SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length ==  getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0])) {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
	        		} else {
	        			SelectDeptNM.innerHTML += "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + "/" + getNodeText(SelectNodes(xmlRtn, "LISTVIEWDATA/TOTALCOUNT2")[0]) + strLang1 + "</span>]";
	        		}
	                
	                SelectDeptNM.setAttribute("countinfo", "1")
	            } */
	            if (pListType == "IMG") {
	                document.getElementById("DeptUserImgList").style.display = "";
	                document.getElementById("txtlist_Layer").style.display = "none";
	                document.getElementById("txtlist_table").style.display = "none";
	                document.getElementById("Search_txtlist_table").style.display = "none";
	                
	                if (pSeach) {
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >" + "<spring:message code='ezEmail.t655' />" + "" + "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
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
	                    document.getElementById("SelectDeptNM").innerHTML = "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"vertical-align:middle;padding-right:3px;\" >" + "<spring:message code='ezEmail.t655' />" + "" + "-[<span class='txt_color'>" + SelectNodes(xmlRtn, "LISTVIEWDATA/ROWS/ROW").length + strLang1 + "</span>]";
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
	                    
	                    if ("${useOcs}" == "YES") {
	                        pDisplayName += "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>";
	                    }

	            	    if($(M_TR).attr("_DATA11") == "addJob"){
		            		pDisplayName += "<spring:message code='ezOrgan.psb03'/> ";
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
	                        
	                        if ("${useOcs}" == "YES") {
	                            M_TR_TD2.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
	                        } else {
	                            M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA4");
	                        }
	
	                        var M_TR_TD3 = document.createElement("TD");

	                    	var jobName = "";
	                        if($(M_TR).attr("_DATA11") == "addJob"){
			            		jobName += "<spring:message code='ezOrgan.psb03'/> ";
			            	}

	                        jobName += M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
	                        M_TR_TD3.innerHTML = jobName;
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
	                        
	                        if ("${useOcs}" == "YES") {
	                            M_TR_TD1.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
	                        } else {
	                            M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA4");
	                        	
	                        }
	
	                        var M_TR_TD2 = document.createElement("TD");
	                        M_TR_TD2.style.width = "80px";

	                    	var jobName = "";
	                        if($(M_TR).attr("_DATA11") == "addJob"){
			            		jobName += "<spring:message code='ezOrgan.psb03'/> ";
			            	}

	                        jobName += M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
	                        M_TR_TD2.innerHTML = jobName;
	
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
	
	        var m_strColorSelect = "#f1f8ff";
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
	                    if (SelectedPreObj == null) {
	                        PrelistContent = p_ListOrderObject.getAttribute("id");
	                    } else {
	                        PrelistContent = SelectedPreObj.getAttribute("id");
	                    }
	
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
	
	                    } else if (PrePoint > CurPoint) {
	                        for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
	                            p_ListOrderObject = document.getElementById("MailUserlist_" + Cnt);
	                            for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
	                                p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
	                            }
	                            listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
	                        }
	                    } else {
	                        return;
	                    }
	
	                } else {
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
	            } else {
	                listEventCheckbox = false;
	            }
	        }
	
	        function event_listDBclick(obj) {
	            InsertReceiver("MsgToList");
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
	            setOrganListType(pListType);
	        }
	
	        function keyword_Clear() {
	            document.getElementsByName('keyword').value = "";
	        }
	
	        function InsertReceiver(pListView) {
	            var pparsingXML = "";
	            var pparsingXML2 = "";
	            var strSIP = "";
				
	            if (m_selectedTree == orglistView) {
		            if (p_ListOrderObject == null || p_ListOrderObject == "") {
		                var organTree = new TreeView();
		                
		                organTree.LoadFromID("FromTreeView");
		                var nodeIdx = organTree.GetSelectNode();
		                var strId = nodeIdx.GetNodeData("CN");
		                var strName = nodeIdx.NodeName;
						
		                var listid = "MsgToList";
		                var getlistview = new ListView();
		                getlistview.LoadFromID(listid);
		                var bFlag = getlistview.ExistRow("data1", strId);
		                
		                if (!bFlag) {
		                    pparsingXML2 = "";
		                    pparsingXML = "";
		                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
		                    pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(strName) + "</DATA2>";
		                    pparsingXML = pparsingXML + "<DATA4>DEPT</DATA4>";
		                    pparsingXML = pparsingXML + "<DATA5>N</DATA5>";
		                    pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t15' /> " + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
		                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
		                    Resultxml = loadXMLString(pparsingXML2);
		
		                    var MaxID = 0;
		                    var InitTr = getlistview.GetDataRows();
		                    var MaxCntNum = 0;
		
		                    for (var j = 0; j < InitTr.length; j++) {
		                        var curnum = Number(getlistview.GetSelectedRowID(j).substring(getlistview.GetSelectedRowID(j).lastIndexOf('_') + 1), getlistview.GetSelectedRowID(j).length);
		                        if (MaxID < curnum) {
		                            MaxID = curnum;
		                            MaxCntNum = j;
		                        }
		                    }
		
		                    var objTr = getlistview.AddRow(InitTr.length);
		                    if (MaxCntNum != 0) {
		                        MaxCntNum = MaxCntNum + 1;
		                    }

		                    SetAttribute(objTr, "id", getlistview.GetSelectedRowID(MaxCntNum).substring(0, getlistview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
		                    getlistview.AddDataRow(objTr, Resultxml);
		
		                    var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
		                    for (var y = 0; y < _tdlength; y++) {
		                        document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
		                        document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
		                    }
		                } 
		            } else {
		                if (listContentArry != "") {
		                    for (var i = 0; i < listContentArry.length; i++) {
		                        var strId = document.getElementById(listContentArry[i]).getAttribute("_data2");
		                        var strName = document.getElementById(listContentArry[i]).getAttribute("_data4");
		                        
		                        var listid = "MsgToList";
		                        var getlistview = new ListView();
		                        getlistview.LoadFromID(listid);
		                        var bFlag = getlistview.ExistRow("data1", strId);
								
		                        if (!bFlag) {
		                            pparsingXML2 = "";
		                            pparsingXML = "";
		                            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
				                    pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(strName) + "</DATA2>";
		                            pparsingXML = pparsingXML + "<DATA4>USER</DATA4>";
		                            pparsingXML = pparsingXML + "<DATA5>N</DATA5>";
		                            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
		                            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
		                            Resultxml = loadXMLString(pparsingXML2);
		                            
	                                var MaxID = 0;
	                                var InitTr = getlistview.GetDataRows();
	                                var MaxCntNum = 0;
		
		                            for (var j = 0; j < InitTr.length; j++) {
		                                var curnum = Number(getlistview.GetSelectedRowID(j).substring(getlistview.GetSelectedRowID(j).lastIndexOf('_') + 1), getlistview.GetSelectedRowID(j).length);
		                                if (MaxID < curnum) {
		                                    MaxID = curnum;
		                                    MaxCntNum = j;
		                                }
		                            }
		
		                            var objTr = getlistview.AddRow(InitTr.length);
		                            if (MaxCntNum != 0) {
		                                MaxCntNum = MaxCntNum + 1;
		                            }

		                            SetAttribute(objTr, "id", getlistview.GetSelectedRowID(MaxCntNum).substring(0, getlistview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
		                            getlistview.AddDataRow(objTr, Resultxml);
		
		                            var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
		                            for (var y = 0; y < _tdlength; y++) {
		                                document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
		                                document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
		                            }
		                        } 
		                    }
		                } else {
		                	var organTree = new TreeView();
			                organTree.LoadFromID("FromTreeView");
			                var nodeIdx = organTree.GetSelectNode();
		                	var strId = nodeIdx.GetNodeData("CN");
			                var strName = nodeIdx.NodeName;
			                
			                var listid = "MsgToList";
			                var getlistview = new ListView();
	                        getlistview.LoadFromID(listid);
			                var bFlag = getlistview.ExistRow("data1", strId);
			                
		                    if (!bFlag) {
		                    	pparsingXML2 = "";
			                    pparsingXML = "";
			                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
			                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
			                    pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(strName) + "</DATA2>";
			                    pparsingXML = pparsingXML + "<DATA4>DEPT</DATA4>";
			                    pparsingXML = pparsingXML + "<DATA5>N</DATA5>";
			                    pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t15' /> " + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
			                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
			                    Resultxml = loadXMLString(pparsingXML2);
			
			                    var MaxID = 0;
			                    var InitTr = getlistview.GetDataRows();
			                    var MaxCntNum = 0;
			
			                    for (var j = 0; j < InitTr.length; j++) {
			                        var curnum = Number(getlistview.GetSelectedRowID(j).substring(getlistview.GetSelectedRowID(j).lastIndexOf('_') + 1), getlistview.GetSelectedRowID(j).length);
			                        if (MaxID < curnum) {
			                            MaxID = curnum;
			                            MaxCntNum = j;
			                        }
			                    }
			
			                    var objTr = getlistview.AddRow(InitTr.length);
			                    if (MaxCntNum != 0) {
			                        MaxCntNum = MaxCntNum + 1;
			                    }

			                    SetAttribute(objTr, "id", getlistview.GetSelectedRowID(MaxCntNum).substring(0, getlistview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
			                    getlistview.AddDataRow(objTr, Resultxml);
			                    var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;

			                    for (var y = 0; y < _tdlength; y++) {
			                        document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
			                        document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
			                    }
		                    } 
		                }
		            }
	            }  else if (m_selectedTree == ListViewJikwi) { // 직위
	            	var listid = "MsgToList";
		            var getlistview = new ListView();
		            getlistview.LoadFromID(listid);
		            
	            	var jikwelistview = new ListView();
	                jikwelistview.LoadFromID("pListViewJikwi");
                   
                    var arrRows = jikwelistview.GetSelectedRows();
                    var strName = "";
                    var strId = "";
                    var jikwiCompanyID = "";
    	            if (arrRows.length > 0) {
    	            	for (var i = 0; i < arrRows.length; i++) {
    	            		strName = arrRows[i].innerText;
    	                	strId = GetAttribute(arrRows[i], "data1");
    	                	jikwiCompanyID = GetAttribute(arrRows[i], "data4");
    	                	
    	                	var bFlag = getlistview.ExistRow("data1", strId);
    		                
							// 직위 중복체크 추가
	                        if (bFlag) {
								alert("<spring:message code='ezBoard.t20' />");
								return;
							} else {
    	                    	pparsingXML2 = "";
        	                    pparsingXML = "";
        	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
        	                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
        	                    // 직위명 추가
								pparsingXML = pparsingXML + "<DATA2><![CDATA["+ strName + "]]></DATA2>";
        	                    pparsingXML = pparsingXML + "<DATA4>JIKWI</DATA4>";
        	                    pparsingXML = pparsingXML + "<DATA5>N</DATA5>";
        	                    
								if (primary == "1") { // 직위이름 다국어 처리
									pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t28' /> : " + MakeXMLString(strName) + "</VALUE>";
								} else {
									pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t28' /> : " + MakeXMLString(strName) + "</VALUE>";
								}
								pparsingXML = pparsingXML + "</CELL></ROW>";
								
        	                   // pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t28' /> : " + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
        	                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
        	                    Resultxml = loadXMLString(pparsingXML2);
        	                        
        	                    var MaxID = 0;
        	                    var InitTr = getlistview.GetDataRows();
        	                    var MaxCntNum = 0;

        	                    for (var j = 0; j < InitTr.length; j++) {
        	                    	var curnum = Number(getlistview.GetSelectedRowID(j).substring(getlistview.GetSelectedRowID(j).lastIndexOf('_') + 1), getlistview.GetSelectedRowID(j).length);
        	                    	if (MaxID < curnum) {
        	                        	MaxID = curnum;
        	                        	MaxCntNum = j;
        	                        }
        	                    }

        	                    var objTr = getlistview.AddRow(InitTr.length);
        	                    if (MaxCntNum != 0) {
        	                    	MaxCntNum = MaxCntNum + 1;
        	                    }

        	                    SetAttribute(objTr, "id", getlistview.GetSelectedRowID(MaxCntNum).substring(0, getlistview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
        	                    getlistview.AddDataRow(objTr, Resultxml);

        	                    var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
        	                    for (var y = 0; y < _tdlength; y++) {
        	                    	document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
        	                    	document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
        	                    }
    	                    }
    	                }
    	            }
	            } else if (m_selectedTree == ListViewJikchek) { // 직책
	            	var listid = "MsgToList";
		            var getlistview = new ListView();
		            getlistview.LoadFromID(listid);
	            	
	            	var jikwelistview = new ListView();
	                jikwelistview.LoadFromID("pListViewJikchek");
                   
                    var arrRows = jikwelistview.GetSelectedRows();
                    var strName = "";
                    var strId = "";
                    var jikwiCompanyID = "";
    	            if (arrRows.length > 0) {
    	            	for (var i = 0; i < arrRows.length; i++) {
    	            		strName = arrRows[i].innerText;
    	                	strId = GetAttribute(arrRows[i], "data1");
    	                	jikwiCompanyID = GetAttribute(arrRows[i], "data4");
    	                	
							var bFlag = getlistview.ExistRow("data1", strId);
    		                
							// 직책 중복체크 추가
	                        if (bFlag) {
								alert("<spring:message code='ezBoard.t20' />");
								return;
							} else {
    	                    	pparsingXML2 = "";
    	                        pparsingXML = "";
    	                        pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
    	                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
    	                        // 직책명 추가
								pparsingXML = pparsingXML + "<DATA2><![CDATA["+ strName + "]]></DATA2>";
    	                        pparsingXML = pparsingXML + "<DATA4>JIKCHEK</DATA4>";
    	                        pparsingXML = pparsingXML + "<DATA5>N</DATA5>";
    	                        
								if (primary == "1") { // 직책이름 다국어 처리
									pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t281' /> : " + MakeXMLString(strName) + "</VALUE>";
								} else {
									pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t281' /> : " + MakeXMLString(strName) + "</VALUE>";
								}
								pparsingXML = pparsingXML + "</CELL></ROW>";
								
    	                      // pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t281' /> : " + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
    	                        pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
    	                        Resultxml = loadXMLString(pparsingXML2);
    	                            
    	                        var MaxID = 0;
    	                        var InitTr = getlistview.GetDataRows();
    	                        var MaxCntNum = 0;

    	                        for (var j = 0; j < InitTr.length; j++) {
    	                        	var curnum = Number(getlistview.GetSelectedRowID(j).substring(getlistview.GetSelectedRowID(j).lastIndexOf('_') + 1), getlistview.GetSelectedRowID(j).length);
    	                        	if (MaxID < curnum) {
    	                            	MaxID = curnum;
    	                            	MaxCntNum = j;
    	                            }
    	                        }

    	                        var objTr = getlistview.AddRow(InitTr.length);
    	                        if (MaxCntNum != 0) {
    	                        	MaxCntNum = MaxCntNum + 1;
    	                        }

    	                        SetAttribute(objTr, "id", getlistview.GetSelectedRowID(MaxCntNum).substring(0, getlistview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
    	                        getlistview.AddDataRow(objTr, Resultxml);

    	                        var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
    	                        for (var y = 0; y < _tdlength; y++) {
    	                        	document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
    	                        	document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
    	                        }
    	                    }
    	                }
    	            }
	            } else if (m_selectedTree == ListViewGroup) {
	            	var pListViewGroup = new ListView();
	                var _tdlength = 0;
	                pListViewGroup.LoadFromID("pListViewGroup");
	                var arrRows = pListViewGroup.GetSelectedRows();
	                
	                if (arrRows.length > 0) {
	                    var pparsingXML = "";
	                    var pparsingXML2 = "";
	                    for (var i = 0; i < arrRows.length; i++) {
	                        var strName = arrRows[i].innerText;
	                        var groupId = arrRows[i].getAttribute("data1");
	                        var listid = "MsgToList";
	
	                        var targetList = new ListView();
	                        targetList.LoadFromID(listid);

	                            pparsingXML2 = "";
	                            pparsingXML = "";
	                            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(groupId) + "</DATA1>";
			                    pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(strName) + "</DATA2>";
	                            pparsingXML = pparsingXML + "<DATA4>GROUP</DATA4>";
	                            pparsingXML = pparsingXML + "<DATA5>N</DATA5>";
	                            pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezPersonal.yej05' /> : " + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
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
	
	                            _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                            for (var y = 0; y < _tdlength; y++) {
	                                document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                                document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                            }
	                    }

	                }
	                
		            for (var i = 0; i < arrRows.length; i++) {
	            		arrRows[i].style.backgroundColor = m_strColorDefault;
	            		arrRows[i].setAttribute("selected", "false");
		            }
	            }
	        }
	
	        function CheckMailReceiver(selRow, option) {
	            var rtnValue = false;
	            var email;
	           
	            if (option == "1") {
	                email = selRow.cells[0].DATA3;
	            } else if (option == "2") {
	                email = selRow.cells[0].DATA2;
	            } else if (option == "3") {
	                email = selRow;
	            }
	
	            var _listview = new ListView();
	            _listview.LoadFromID("MsgToList");
	            var arrRows = _listview.GetDataRows();
	            
	            for (count2 = 0; count2 < arrRows.length; count2++) {
	                if (email == arrRows[count2].getAttribute("data1")) {
	                    rtnValue = true;
	                }
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
		        selSpan = "orgSpan";

		        m_tabDialogState["org"] = "select";
		        m_tabDialogState["jikwi"] = "normal";
		        m_tabDialogState["jikchek"] = "normal";
		        m_tabDialogState["group"] = "normal";
		        
		        ImageUpdate();
		        
		        TreeViewTD.style.display = "block";
		        ListViewJikwiTD.style.display = "none";
		        ListViewJikchekTD.style.display = "none";
		        ListViewGroupTD.style.display = "none";
		        
		        m_selectedTree = orglistView;
		    }
	        
	        function groupTabButton_onClick() {
		    	methodForTabAction(4);
		    	selSpan = "groupSpan";
		        m_tabDialogState["org"] = "normal";
		        m_tabDialogState["jikwi"] = "normal";
		        m_tabDialogState["jikchek"] = "normal";
		        m_tabDialogState["group"] = "select";

		        TreeViewTD.style.display = "none";
		        ListViewJikwiTD.style.display = "none";
		        ListViewJikchekTD.style.display = "none";
		        ListViewGroupTD.style.display = "block";
		       
		        groupMember.style.display = "block"; 
		        m_selectedTree = ListViewGroup;
		        
		        try {
		            var xmlHTTP = createXMLHttpRequest();
		            xmlHTTP.open("POST", "/admin/ezOrgan/getGroupList.do", false);
		            xmlHTTP.send("");
		            
		            if (xmlHTTP.status != 200) {
			            alert("<spring:message code='ezEmail.t574' />" + xmlHTTP.status);
		            } else {
		            	document.getElementById("ListViewGroup").innerHTML = "";
			            var pListViewGroup = new ListView();
			            pListViewGroup.SetID("pListViewGroup");
			            pListViewGroup.SetSelectFlag(false);
			            pListViewGroup.SetMulSelectable(true);
			            pListViewGroup.SetRowOnDblClick("ListViewNodeDblClick");
			            pListViewGroup.DataSource(loadXMLString(document.getElementById("listviewheader1").innerHTML.toUpperCase()));
			            pListViewGroup.DataBind("ListViewGroup");
			            pListViewGroup.DataSource(loadXMLString(xmlHTTP.responseText));
			            pListViewGroup.RowDataBind();
			
			            for (var i = 0; i < pListViewGroup.GetRowCount() ; i++) {
			            	pListViewGroup.GetDataRows()[i].draggable = true;
			                if (CrossYN())
			                	pListViewGroup.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
			                else
			                	pListViewGroup.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); };
			
			                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
			                	pListViewGroup.GetDataRows()[i].ondragend = function (event) { event_listdragend(event); };
			                }
			            }
		            }
		            
		            xmlHTTP = null;
		        } catch (e) {
		            alert("<spring:message code='ezEmail.t574' />" + e.description);
		            xmlHTTP = null;
		            return;
		        }
	        }
	        
	        function event_listdragend(evt) {
                evt.stopPropagation();
                evt.preventDefault();
                
                if (dropelement != "") {
                    InsertReceiver(document.getElementById(dropelement));
                }
            }
            
            function event_listdragstart(obj) {
                dropelement = "";
                var islist = false;
                
                if (m_selectedTree == orglistView) {
                    for (var i = 0; i < listContentArry.length; i++) {
                        if (listContentArry[i] == obj.getAttribute("id")) {
                            islist = true;
                            break;
                        }
                    }
                    
                    if (!islist) {
                        event_listclick(obj);
                    }
                }
            }
            
	        function ImageUpdate() {
	            return (navigator.userAgent.indexOf('Firefox') != -1) ?
	                (function () {
	                    orgTabButton.setAttribute('src', m_orgImg[m_tabDialogState["org"]]);
	                }).call(this)
	                : (CrossYN()) ?
	                (function () {
	                    orgTabButton.setAttribute('src', m_orgImg[m_tabDialogState["org"]]);
	                }).call(this)
	                :
	                (function () {
	                    orgTabButton.src = m_orgImg[m_tabDialogState["org"]];
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
	            //var dept = p_ListOrderObject.getAttribute("_DATA13");
	            var dept = p_ListOrderObject.getAttribute("_DATA10");
	            var rtn
	            var width = 420, height = 450;
	            var leftPosition, topPosition;
	            leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
	            topPosition = (window.screen.height / 2) - ((height / 2) + 50);
	
	            window.open("/ezCommon/showPersonInfo.do?id=" + id + "&dept=" + dept, "", "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        }
	        
	        
	        
	        function dept_select() {
	            var organTree = new TreeView();
	            organTree.LoadFromID("FromTreeView");
	            var nodeIdx = organTree.GetSelectNode();
	            var listid = "MsgToList";
	           
	            var strId = nodeIdx.GetNodeData("CN");
	            var strName = nodeIdx.NodeName;
	           
	            var pparsingXML = "";
	            var getlistview = new ListView();
	            getlistview.LoadFromID(listid);
	            var bFlag = getlistview.ExistRow("data1", strId);
				
	            if (!bFlag) {
                    pparsingXML2 = "";
                    pparsingXML = "";
                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
                    pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(strName) + "</DATA2>";
                    pparsingXML = pparsingXML + "<DATA4>ORGAN</DATA4>";
                    pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t15' />" + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
                    Resultxml = loadXMLString(pparsingXML2);

                    var MaxID = 0;
                    var InitTr = getlistview.GetDataRows();
                    var MaxCntNum = 0;

                    for (var j = 0; j < InitTr.length; j++) {
                        var curnum = Number(getlistview.GetSelectedRowID(j).substring(getlistview.GetSelectedRowID(j).lastIndexOf('_') + 1), getlistview.GetSelectedRowID(j).length);
                        if (MaxID < curnum) {
                            MaxID = curnum;
                            MaxCntNum = j;
                        }
                    }

                    var objTr = getlistview.AddRow(InitTr.length);
                    if (MaxCntNum != 0) {
                        MaxCntNum = MaxCntNum + 1;
                    }

                    SetAttribute(objTr, "id", getlistview.GetSelectedRowID(MaxCntNum).substring(0, getlistview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
                    getlistview.AddDataRow(objTr, Resultxml);

                    var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
                    for (var y = 0; y < _tdlength; y++) {
                        document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
                        document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
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
	        
	        function methodForTabAction(target) {
            	var tab1 = document.getElementById("orgTabButton").children[0];
            	var tab2 = document.getElementById("orgTabButton2").children[0];
            	var tab3 = document.getElementById("orgTabButton3").children[0];
            	var tab4 = document.getElementById("orgTabButton4").children[0];
            	
            	if (target == 1) {
            		tab1.className = "tabon";
            		tab2.className = "";
            		tab3.className = "";
            		tab4.className = "";
            	} else if (target == 2) {
            		tab1.className = "";
            		tab2.className = "tabon";
            		tab3.className = "";
            		tab4.className = "";
            	} else if (target == 3) {
            		tab1.className = "";
            		tab2.className = "";
            		tab3.className = "tabon";
            		tab4.className = "";
            	} else if (target == 4) {
            		tab1.className = "";
            		tab2.className = "";
            		tab3.className = "";
            		tab4.className = "tabon";
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
   		    
		    //2018-08-01 김보미 - 부서명 [사원수] 길이가 길면 조정하는 함수
	        function deptNameLong(containLow, strIsLeaf) {
	        	var deptNameWidth = "";
	        	var sum = $("#spn_deptName").width() + $("#countInfo").width();
	        	
	          	if (containLow == "YES" && strIsLeaf != "TRUE") { //하위가 있고, 표기방식이 [1명/ 전체10명]일 경우
	          		if (sum > 366) {
	          			deptNameWidth = 367 - $("#countInfo").width();
	          		}
	          	} else {
	          		if (sum > 364) {
	          			deptNameWidth = 365 - $("#countInfo").width();
	          		}
	          	}
	        	
	        	$("#spn_deptName").css("width", deptNameWidth);
	        }
		    
	        /* 2018-09-04 홍승비 - 탭메뉴 마우스오버 시 하이라이트 설정 */
	        function tabover(tabObj) {
	        	tabObj.setAttribute("class", "tabon");
	        }
	        
	        function tabout(tabObj) {
	        	if (tabObj.id != selSpan) {
	        		tabObj.setAttribute("class", "");
	        	}
	        }
	        
	        function LoadAddressTree() {
	            var treeXML = loadXMLFile("/xml/common/organtree_config2.xml");
	            AddressTreeView.config(treeXML);
	            get_Address_FullTree();
	        }
	      
	        var totalPage = "";
            var pageNum = "";
            function goToPageByNum(Value) {
                page = Value;
                makePageSelPage();
                movePage(page);
            }
            function selbeforeBlock() {
                var pageNum = parseInt(page);
                pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
                goToPageByNum(pageNum);
            }
            function selbeforeBlock_one() {
                var pageNum = parseInt(page);
                if (parseInt(pageNum - 1) > 0)
                    goToPageByNum(parseInt(pageNum - 1));
                else
                    return;
            }
            function selafterBlock() {
                var pageNum = parseInt(page);
                pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
                goToPageByNum(pageNum);
            }
            function selafterBlock_one() {
                var pageNum = parseInt(page);
                if (parseInt(pageNum + 1) <= totalPage)
                    goToPageByNum(parseInt(pageNum + 1));
                else
                    return;
            }
            function movePage(newPage) {
                if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
                    page = newPage;
                    if (addrsearh)
                        AddrSearch_event();
                    else
                        address_selectnode("page");
                }
            }
            function prevPage_onclick() {
                newPage = parseInt(page) - 1;
                if (newPage > 0) {
                    page = newPage;
                    address_selectnode("page");
                }
            }
            function nextPage_onclick() {
                newPage = parseInt(page) + 1;
                if (newPage <= parseInt(totalPage)) {
                    page = newPage;
                    address_selectnode("page");
                }
            }
            
	        function td_Create1(strtext) {
                document.getElementById("tblPageRayer").innerHTML = strtext;
            }
	        
	        var BlockSize = "5";
            function makePageSelPage() {
                var strtext;
                var PagingHTML = "";
                document.getElementById("tblPageRayer").innerHTML = "";
                strtext = "<div class=\"pagenavi\">";
                PagingHTML += strtext;
                
                if (totalPage > 1 && pageNum != 1) {
                    PagingHTML += "<span class=\"btnimg\" onclick= 'return goToPageByNum(1)'><img src=\"/images/kr/cm/btn_p_prev.gif\"></span>";
                } else {
                    PagingHTML += "<span class=\"btnimg\"><img src=\"/images/kr/cm/btn_p_prev01.gif\"></span>";
                }
                
                if (totalPage > BlockSize) {
                    if (parseInt(pageNum) > parseInt(BlockSize)) {
                        PagingHTML += "<span class=\"btnimg\" onclick= 'return selbeforeBlock()'><img src=\"/images/kr/cm/btn_prev.gif\"></span>";
                    } else {
                        PagingHTML += "<span class=\"btnimg\" ><img src=\"/images/kr/cm/btn_prev01.gif\"></span>";
                    }
                } else {
                    PagingHTML += "<span class=\"btnimg\" ><img src=\"/images/kr/cm/btn_prev01.gif\"></span>";
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
                        PagingHTML += "<span class=\"on\">" + i + "</span>";
                    } else {
                        PagingHTML += "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
                    }
                }
                
                if (MaxNum == 0) {
                	PagingHTML += "<span class=\"on\">" + 1 + "</span>";
                }
                
                if (totalPage > BlockSize) {
                    if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
                        PagingHTML += "<span class=\"btnimg\" onclick='return selafterBlock()'><img src=\"/images/kr/cm/btn_next.gif\"></span>";
                    } else {
                        PagingHTML += "<span class=\"btnimg\"><img src=\"/images/kr/cm/btn_next01.gif\"></span>";
                    }
                } else {
                    PagingHTML += "<span class=\"btnimg\"><img src=\"/images/kr/cm/btn_next01.gif\" ></span>";
                }
                
                if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
                    PagingHTML += "<span class=\"btnimg\" onclick='return goToPageByNum(" + totalPage + ")'><img src=\"/images/kr/cm/btn_n_next.gif\" ></span>";
                } else {
                    PagingHTML += "<span class=\"btnimg\"><img src=\"/images/kr/cm/btn_n_next01.gif\" ></span>";
                }
                
                PagingHTML += "</div>";
                td_Create1(PagingHTML);
            }
            
            
	        
	        function on_keydown() {
                if (window.event.keyCode == "13")
                    inputAddress();
            }
	        
	        function SelectReceiverWindow() {
	        	var listview = new ListView();
                listview.LoadFromID("MsgToList");
				var arrRows = listview.GetSelectedRows();
				
				if (arrRows == "") {
					return;
				} else {
					if (arrRows[0].getAttribute("DATA4") == "ORGAN" || arrRows[0].getAttribute("DATA4") == "DEPT") {
						document.getElementById("admin_OK").disabled = false;
						document.getElementById("admin_NO").disabled = false;
						var _data5 = arrRows[0].getAttribute("DATA5");

						if (_data5 == "Y" || _data5 == "true") {
							document.getElementById("admin_OK").checked = true;
							document.getElementById("admin_NO").checked = false;
						} else {
							document.getElementById("admin_OK").checked = false;
							document.getElementById("admin_NO").checked = true;
							arrRows[0].setAttribute("DATA5", "N");
						}
					} else {
						document.getElementById("admin_OK").disabled = true;
						document.getElementById("admin_OK").checked = false;
						document.getElementById("admin_NO").disabled = true;
						document.getElementById("admin_NO").checked = true;
					}
				}
			}
	        
	        function checkbox_onclick(e) {
				if (!CrossYN()) {
					srcElementID = window.event.srcElement.id;
				} else {
					srcElementID = e.target.id;
				}

				var checkFlag = "Y";
				if (srcElementID == "admin_OK") {
					document.getElementById("admin_OK").checked = true;
					document.getElementById("admin_NO").checked = false;
					checkFlag = "Y";
				} else {
					document.getElementById("admin_OK").checked = false;
					document.getElementById("admin_NO").checked = true;
					checkFlag = "N";
				}

				var pListViewDL = new ListView();
				pListViewDL.LoadFromID("MsgToList");
				var arrRows = pListViewDL.GetSelectedRows();
				
				if (arrRows == "")
					return;
				
				arrRows[0].setAttribute("DATA5", checkFlag);

			}
	        
	        function jikwiTabButton_onClick() {
		    	selSpan = "jikweeSpan";
		    	methodForTabAction(2);
		        m_tabDialogState["org"] = "normal";
		        m_tabDialogState["jikwi"] = "select";
		        m_tabDialogState["jikchek"] = "normal";
		        m_tabDialogState["group"] = "normal";

		        TreeViewTD.style.display = "none";
		        ListViewJikwiTD.style.display = "block";
		        ListViewJikchekTD.style.display = "none";
		        ListViewGroupTD.style.display = "none";
		        
		        m_selectedTree = ListViewJikwi;
		        
		        try {
		        	var xmlHTTP = createXMLHttpRequest();
		            xmlHTTP.open("POST", "/admin/ezOrgan/getJikwiList.do?companyId=" + companyId + "&type=001", false);
		            xmlHTTP.send("");
		            
		            if (xmlHTTP.status != 200) {
			            alert("<spring:message code='ezEmail.t574' />" + xmlHTTP.status);
		            } else {
		            	document.getElementById("ListViewJikwi").innerHTML = "";
			            var pListViewJikwi = new ListView();
			            pListViewJikwi.SetID("pListViewJikwi");
			            pListViewJikwi.SetSelectFlag(false);
			            pListViewJikwi.SetMulSelectable(true);
			            pListViewJikwi.SetRowOnDblClick("InsertReceiver");
			            pListViewJikwi.DataSource(loadXMLString(document.getElementById("listviewheaderJW").innerHTML.toUpperCase()));
			            pListViewJikwi.DataBind("ListViewJikwi");
			            pListViewJikwi.DataSource(loadXMLString(xmlHTTP.responseText));
			            pListViewJikwi.RowDataBind();
			
		            }
		            
		            xmlHTTP = null;
		        } catch (e) {
		            alert("<spring:message code='ezEmail.t574' />" + e.description);
		            xmlHTTP = null;
		            return;
		        }
	        }
	        
	        function jikchekTabButton_onClick() {
		    	selSpan = "jikchekSpan";
		    	methodForTabAction(3);
		        m_tabDialogState["org"] = "normal";
		        m_tabDialogState["jikwi"] = "normal";
		        m_tabDialogState["jikchek"] = "select";
		        m_tabDialogState["group"] = "normal";

		        TreeViewTD.style.display = "none";
		        ListViewJikwiTD.style.display = "none";
		        ListViewJikchekTD.style.display = "block";
		        ListViewGroupTD.style.display = "none";
		        
		        m_selectedTree = ListViewJikchek;
		        
		        try {
		        	var xmlHTTP = createXMLHttpRequest();
		            xmlHTTP.open("POST", "/admin/ezOrgan/getJikwiList.do?companyId=" + companyId + "&type=002", false);
		            xmlHTTP.send("");
		            
		            if (xmlHTTP.status != 200) {
			            alert("<spring:message code='ezEmail.t574' />" + xmlHTTP.status);
		            } else {
		            	document.getElementById("ListViewJikchek").innerHTML = "";
			            var pListViewJikchek = new ListView();
			            pListViewJikchek.SetID("pListViewJikchek");
			            pListViewJikchek.SetSelectFlag(false);
			            pListViewJikchek.SetMulSelectable(true);
			            pListViewJikchek.SetRowOnDblClick("InsertReceiver");
			            pListViewJikchek.DataSource(loadXMLString(document.getElementById("listviewheaderJC").innerHTML.toUpperCase()));
			            pListViewJikchek.DataBind("ListViewJikchek");
			            pListViewJikchek.DataSource(loadXMLString(xmlHTTP.responseText));
			            pListViewJikchek.RowDataBind();
			
		            }
		            
		            xmlHTTP = null;
		        } catch (e) {
		            alert("<spring:message code='ezEmail.t574' />" + e.description);
		            xmlHTTP = null;
		            return;
		        }
	        }
	        
	        var mail_select_groupmember_cross_dialogArguments = new Array();
	        function groupmember_click() {
	            var groupList = new ListView();
	            groupList.LoadFromID("pListViewGroup");
	            var arrRows = groupList.GetSelectedRows();
	            if (arrRows.length < 1) {
	                alert("<spring:message code='ezOrgan.zNo003' />");
	                return;
	            }
	            
	            var groupID = GetAttribute(arrRows[0], "DATA1")
	            mail_select_groupmember_cross_dialogArguments[0] = DivPopUpHidden;
	            DivPopUpShow(601, 470, "/admin/ezOrgan/permissionGroupUserListView.do?groupID=" + groupID + "&companyID=" + companyId);
	            
	        }
    	</script>
	</head>
	<body class="popup" onkeydown="event_listOnkeyDown(event);" onkeyup="event_listOnkeyUp(event);" style="overflow:hidden">
		<%-- 직위, 직책용 리스트헤더 --%>
		<xml id="listviewheaderJW" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezOrgan.csj04' /></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<xml id="listviewheaderJC" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezOrgan.csj17' /></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<%-- 권한그룹용 리스트헤더 --%>
		<xml id="listviewheader1" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.yej05' /></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<form method="post">
			<h1><spring:message code='ezPersonal.yej04' /></h1>
	        <div id="close">
	            <ul>
	                <li><span onclick="window.close()"></span></li>
	            </ul>
	        </div>
		    <table style="width:100%;margin-top:10px">
		        <tr>
		            <td style="vertical-align: top;">
		            	<div class="portlet_tabpart01" style="margin:0px;">
		            		<div class="portlet_tabpart01_top" id="tab1" style="margin-bottom:3px;">
		            			<p id="orgTabButton">
		            				<span id="orgSpan" onclick="orgTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.t591' /></span>
		            			</p>
		            			<p id="orgTabButton2">
		            				<span id="jikweeSpan" onclick="jikwiTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.t28' /></span>
		            			</p>
		            			<p id="orgTabButton3">
		            				<span id="jikchekSpan" onclick="jikchekTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.t281' /></span>
		            			</p>
		            			<p id="orgTabButton4">
		            				<span id="groupSpan" onclick="groupTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezPersonal.yej05' /></span>
		            			</p>
		            		</div>
	            		</div>
		                <table id="TreeViewTD">
		                    <tr>
		                        <td>
		                            <div class="" style="background-color: #f8f8f8; margin-top: 4px;">
		                                <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #eaeaea;">
		                                    <table style="margin-top: 4px; width: 100%;">
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
		                                                        <option value="streetAddress" usedefault="0" style="display:none"><spring:message code='ezEmail.t99000049' /></option>
		                                                    </select>
		                                                    <input id="keyword" value="" onkeypress="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px;height:22px">
		                                                    <a class="imgbtn"><span onclick="search_click('search')"><spring:message code='ezEmail.t37' /></span></a>
		
		                                                </div>
		                                            </td>
		                                            <td>
		                                                <div style="float: right; margin-right: 5px; position: relative;">
		                                                    <a class="imgbtn" id="dept_select"><span onclick="dept_select()" style="z-index:10"><spring:message code='ezEmail.t596' /></span></a>
		                                                    <a class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezEmail.t597' /></span></a>
		                                                </div>
		                                            </td>
		                                        </tr>
		                                    </table>
		                                </div>
		                            </div>
		                            <table style="margin-top: 3px;">
		                                <tr>
		                                    <td class="box" style="border-right:0px">
		                                        <div style="width: 220px; height: 455px; overflow-x: auto; overflow-y: auto;" id="TreeView"></div>
		                                    </td>
		                                    <td></td>
		                                    <td class="listview" style="width: 432px" id="orglistView">
		                                        <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
		                                            <tr>
		                                                <th style="white-space:normal; background: #fff; border-top:0px;">
															<span id="SelectDeptNM" style="font-weight: normal; width: 386px; height: 18px; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: middle; margin-top:-4px;"></span>
		                                                    <span style="float:right; position: relative;">
		                                                        <span onclick="ChangeListView_onClick('TXT');">
		                                                            <img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
		                                                        <span onclick="ChangeListView_onClick('IMG');">
		                                                            <img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
		                                                    </span>
		                                                </th>
		                                            </tr>
		                                        </table>
		                                        <div style="vertical-align: top; height: 426px; overflow: auto; width: 446px;" id="txtlist_Layer">
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
		                                        <div style="vertical-align: top; text-align: center; height: 426px; overflow: auto; display: none; width: 446px;" id="DeptUserImgList"></div>
		                                        <div id="tblPageRayer2"  style="text-align:center;"></div>
		                                	</td>
		                                </tr>
		                            </table>
		                        </td>
		                    </tr>
		                </table>
		                <table id="ListViewGroupTD" style="display: none">
		                    <tr>
		                        <td>
		                                    <table style="margin-top: 4px; width: 100%;">
		                                        <tr>
		                                            <td id="groupMember" style="display: none">
		                                                <a class="imgbtn" style="float: right; margin-right: 5px;"><span onclick="groupmember_click()">
		                                                    <spring:message code='ezEmail.t598' /></span></a>
		                                            </td>
		                                        </tr>
		                                    </table>
		                            <div style="width: 668px; height: 494px; overflow: auto; background-color: #ffffff; margin-top: 3px;" id="ListViewGroup" class="border_gray">
		                            </div>
		                        </td>
		                    </tr>
	                	</table>
	                	<%-- 2019-09-25 홍승비 - 직위/직책권한 UI 적용 --%>
						<table id="ListViewJikwiTD" style="display: none">
		                    <tr>
		                        <td>
									<table style="margin-top: 4px; width: 100%;">
										<tr>
	                                           <td id="jikwiList" style="display: none">
	                                               <a class="imgbtn" style="float: right; margin-right: 5px;"><span onclick="jikwiList_click()">
	                                                   <spring:message code='ezEmail.t598' /></span></a>
	                                           </td>
	                                       </tr>
	                                   </table>
		                            <div style="width: 668px; height: 489px; overflow: auto; background-color: #ffffff; margin-top: 3px;" id="ListViewJikwi" class="border_gray">
		                            </div>
		                        </td>
		                    </tr>
	                	</table>
	                	<table id="ListViewJikchekTD" style="display: none">
		                    <tr>
		                        <td>
	                                   <table style="margin-top: 4px; width: 100%;">
	                                       <tr>
	                                           <td id="JikchekList" style="display: none">
	                                               <a class="imgbtn" style="float: right; margin-right: 5px;"><span onclick="JikchekList_click()">
	                                                   <spring:message code='ezEmail.t598' /></span></a>
	                                           </td>
	                                       </tr>
	                                   </table>
		                            <div style="width: 668px; height: 489px; overflow: auto; background-color: #ffffff; margin-top: 3px;" id="ListViewJikchek" class="border_gray">
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
		                            <h2 id="ToTitle" class="receiver_tltype01" style="cursor: pointer;">
		                                <span style="min-width: 45px;" id="ToTitleStr"><spring:message code='ezPersonal.yej06' /></span>
		                            </h2>
		                            <div class="receiver_borderbox" style="border-bottom:none;">
		                                <div id="ListViewMsgTo" ondragover ="onDragEnter(event, this)" ondrop ="onDrop(event, this)" style="width: 250px; Height: 472px; overflow: auto;" ondblclick="DeleteReceiver(ListViewMsgTo)"></div>
		                            </div>
		                            <table class="content" style="width: 100%;">
						            	<tbody>
						                	<tr>
						                    	<th><spring:message code='ezBoard.t999025' /></th>
						                    	<td>
													<div class='custom_checkbox'><input type="checkbox" id="admin_OK" disabled name="admin_OK" onclick="checkbox_onclick(event)"></div>&nbsp;<spring:message code='ezSurvey.t51' />
													<div class='custom_checkbox'><input type="checkbox" id="admin_NO" disabled name="admin_NO" onclick="checkbox_onclick(event)"></div>&nbsp;<spring:message code='ezSurvey.t50' />
							                    </td>
						                	</tr>
						            	</tbody>
						        	</table>
		                        </td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
		    </table>
		    <div class="btnposition btnpositionNew">
	    		<a class="imgbtn" onclick="OK_Click()"><span><spring:message code='ezPersonal.t12' /></span></a>
			</div>
			<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
			<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
				<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
			</div>
		</form>
	</body>
</html>
