<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t8' /></title>
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/js/ezEmail/Controls/ezSearchDatePicker.htc')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('main.lhm01', 'msg')}" type="text/css">
   		<link rel="stylesheet" href="${util.addVer('/css/jquery-ui.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/jquery.ui.all.css')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script src="${util.addVer('/js/ezPersonal/controls/TreeView.js')}" type="text/javascript"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview_namespace.htc.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAddress/address_tree_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/datepicker.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
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
	    	#userDLInput span {
	    		display: inline-block;
	    		vertical-align: middle;
	    	}


             .mainlist tr td[style*="display: none"]:first-child.none + td{padding-left:15px;}

	    </style>
	    <script>
	        var cn = "${cn}";
	        var companyid = "";
	        var ua = navigator.userAgent.toLowerCase();
	        var browserIE = (ua.indexOf("msie") != -1) ? true : false;
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
	        var m_tabDialogState = { "org": "select", "contact": "normal", "dl": "normal",
	        		"orgJobMst1": "normal", "orgJobMst2": "normal" };
	        var ua = navigator.userAgent;
	        var companyId = "<c:out value='${companyId}'/>";
	        var selSpan = "";
	        var AddressTreeView = null;
	        var searchgubun = "N";
	        var selectDomain = "${companyMailDomain}";
	        var distributionMail = "${distributionMail}";
	        var userDL = "${userDL}"; // add, modify
	        var offsetMin = "${offsetMin}";
	        var userId = "${userId}";
	        var userName = "${userName}";
	        var setEndDate = utcDate2(offsetMin);
	        var policy = "${policy}";
	        var endDate = "${endDate}";
	        var userDl_ownerId =  "${ownerId}";
	        var userDl_ownerId_temp =  "${userId}";
	        var userDl_ownerName = "${ownerName}";
	        var useShowAllCompanies = "${useShowAllCompanies}";
	        
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
	            
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
				
	            recevieListview("MsgToList", "ListViewMsgTo");
	            AddressTreeView = new window['treeview.htc'].TreeView('AddressTreeView', 'AddressTreeView');
	            AddressTreeView.attachEvent('requestdata', address_requestdata);
	            AddressTreeView.attachEvent('nodeselect', function () { address_selectnode("node") });
	            AddressTreeView.attachEvent('nodedblclick', function () { AddressTreeView.toggle(AddressTreeView.selectedIndex()) });
	           
	            if (userDL != "") { // 사용자 정의 공용배포그룹
	            	var $endDateCheckBox = $("input[name=endDateCheckBox]")[0];

	            	if ("${cn}" != "" && userDL == "modify") {
	            		userDl_ownerId_temp = userDl_ownerId;
	            		
	            		if (endDate != "") {
		            		setEndDate = endDate;
		            		$endDateCheckBox.checked = false;       			
	            		}
	            		$("#userDLInput input:radio[value='"+policy+"']")[0].checked = true;
	            	}
	            
	            	userDLSetDatePicker();
	            	endDateCheckBox_Click($endDateCheckBox);
	            }
	            
	            /* var xmlpara = createXmlDom();
                var xmlTree = createXmlDom();
                var xmlHTTP = createXMLHttpRequest();
                var objNode;
                
                createNodeInsert(xmlpara, objNode, "DATA");
                <c:choose>
                <c:when test="${cChk == '1'}">
                createNodeAndInsertText(xmlpara, objNode, "DEPTID", companyId);
                createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top/organ");
                createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
                createNodeAndInsertText(xmlpara, objNode, "ADMINDIST", "false");
                createNodeAndInsertText(xmlpara, objNode, "DISPLAYTRASHDEPT", "true");
                </c:when>
                <c:otherwise>
                createNodeAndInsertText(xmlpara, objNode, "DEPTID", companyId);
                createNodeAndInsertText(xmlpara, objNode, "TOPID", companyId);
                createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
                createNodeAndInsertText(xmlpara, objNode, "ADMINDIST", "true");
                createNodeAndInsertText(xmlpara, objNode, "DISPLAYTRASHDEPT", "true");
                </c:otherwise>
                </c:choose>
                
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
	            } */
	            orgTabButton_onClick();
	            
	            if ("${cn}" != "") {
	                var xmlpara = createXmlDom();
	                var objRoot, objNode;
	                objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "CN", "${cn}");
	                createNodeAndInsertText(xmlpara, objNode, "COMPID", companyid);
	
	                xmlHTTP2.open("POST", "/admin/ezEmail/mailViewDistributionList.do", true);
	                xmlHTTP2.onreadystatechange = event_GetDistributionList;
	                xmlHTTP2.send(xmlpara);
	            } else if (userDL != ""){
	            	inputOwnerAddress(userName, userId);
	            }
	            
	            ChangeListView_onClick(getOrganListType());

	            setMsgToCnt();
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
	                    
	                    document.getElementById("TextId").disabled = true;
	                    
	                    var mailNode = SelectNodes(result, "DATA/MAIL")[0];
	                    var mail = getNodeText(mailNode);
	                    document.getElementById("mailDomain").innerHTML = mail.substring(mail.indexOf("@"));
	                    
	                    var Resultxml = "";
	                    pparsingXML2 = "";
	                    pparsingXML = "";
	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                    var nodes = SelectNodes(result, "DATA/ROW");
	                    
	                    for (var i = 0 ; i < nodes.length ; i++) {
	                    	var node0 = getNodeText(GetChildNodes(nodes[i])[0]);
	                    	var node1 = MakeXMLString(getNodeText(GetChildNodes(nodes[i])[1]));
	                    	var node2 = MakeXMLString(getNodeText(GetChildNodes(nodes[i])[2]));
	                    	var node3 = MakeXMLString(getNodeText(GetChildNodes(nodes[i])[3]));
	                    	
	                        if (getNodeText(GetChildNodes(nodes[i])[0]) == "distributionSub") {
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + node2 + "</DATA1>";
	                        } else {
	                        	pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + node1 + "</DATA1>";
	                        }
	                        
	                        switch (node0) {
		                        case "group" :
		                        	 pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t15' /> " + node2 + "</VALUE></CELL></ROW>";
		                        	break;
	                        	
		                        case "distribution" :
		                        	pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t57' /> : " + node2 + "</VALUE></CELL></ROW>";
		                        	break;
	                        	
		                        case "distributionSub" :
		                        	pparsingXML = pparsingXML + "<DATA3>" + node3 + "</DATA3>";
		                            pparsingXML = pparsingXML + "<DATA4>DIRECT</DATA4>";
		                            pparsingXML = pparsingXML + "<VALUE>" + node2 + "(" + node3 + ")" + "</VALUE></CELL></ROW>";
		                        	break;
	                        	
		                        case "jobmst" :
			                    	var node6 = MakeXMLString(getNodeText(GetChildNodes(nodes[i])[6])); //title
			                    	
		                        	jobmstValTmp  = (node6 === "001") ? "<spring:message code='main.t77' />" : "<spring:message code='ezPersonal.t175' />";
		                        	jobmstValTmp += " : ";
		                        	
		                        	pparsingXML = pparsingXML + "<DATA3>" + node3 + "</DATA3>";
		                            pparsingXML = pparsingXML + "<DATA4>JOBMST</DATA4>";
		                            pparsingXML = pparsingXML + "<JOBTYPE>" + node6 + "</JOBTYPE>";
		                            pparsingXML = pparsingXML + "<VALUE>" + jobmstValTmp + node2 + "</VALUE></CELL></ROW>";
		                        	break;

		                        default :
		                        	pparsingXML = pparsingXML + "<VALUE>" + node2 + "</VALUE></CELL></ROW>";
	                        }
	                    }
	                              
	                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
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
	                    
	                    if (userDL == "modify") { // ownerId
	    		            inputOwnerAddress(userDl_ownerName, userId);
	    	            }
	                    
	                }
	                
	                xmlHTTP2 = null;
	                setMsgToCnt();
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
		        	data : {deptID : DeptID, cell : "company;description;displayName;title;telephoneNumber", prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department;usertype", type : "user", adminOrgan :"y"},
		        	success : function(result){
		        		var resultXML = loadXMLString(result);
		        		var headerData = createXmlDom();
		        		
	                    // headerData = loadXMLString(result);
	                    headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
	
	                    if (CrossYN()) {
	                        var xmlRtn = resultXML.documentElement.getElementsByTagName("ROWS")[0];
	                        $(xmlRtn.getElementsByTagName("ROW")).each(function(index){
				            	if($(this).find("DATA11").text() == "addJob"){
				            		var orgPosition = $(this).find("CELL").eq(3).find("VALUE").text();
				            		$(this).find("CELL").eq(0).find("DATA6").text("<spring:message code='ezOrgan.psb03'/>"+" "+orgPosition);
				            	}
				            });
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
		        		search : document.all("search_type").value + "::" + encodeURIComponent(document.all("keyword").value), 
		        		cell : "company;description;displayName;title;telephoneNumber;" + document.getElementById("search_type").value, 
		        		prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department;usertype",
		        		<c:if test="${cChk == '1'}">		        		
		        		company : "",
		        		</c:if>
		        		type : "user"
		        	},
		        	success : function(result){	
		        		var headerData = createXmlDom();
	                    // headerData = loadXMLString(result);
 	                    headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
						
	                    var xmlDom = loadXMLString(result);
	                    if (CrossYN()) {
	                        var xmlRtn = xmlDom.documentElement.getElementsByTagName("ROWS")[0];
	                        $(xmlRtn.getElementsByTagName("ROW")).each(function(index){
				            	if($(this).find("DATA11").text() == "addJob"){
				            		var orgPosition = $(this).find("CELL").eq(3).find("VALUE").text();
				            		$(this).find("CELL").eq(0).find("DATA6").text("<spring:message code='ezOrgan.psb03'/>"+" "+orgPosition);
				            		//$(this).find("CELL").eq(3).find("VALUE").text("<spring:message code='ezOrgan.psb03'/>"+" "+orgPosition);
				            	}
				            });
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
		        		search : "displayname::" + encodeURIComponent(searchWord), 
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
	        	var strName = document.getElementById("TextName").value.trim();
	        	var strId = document.getElementById("TextId").value.trim();
	        	
	            if (strName == "") {
	                alert("<spring:message code='ezEmail.t22' />");
	                document.getElementById("TextName").focus();
	                return;
	            }
	            
	            if (strId == "") {
	                alert("<spring:message code='ezEmail.lhm10' />");
	                document.getElementById("TextId").focus();
	                return;
	            }
	            
	            if (strName.indexOf("&") > -1 || strName.indexOf("<") > -1 || strName.indexOf(">") > -1 
		        		 || strName.indexOf("\"") > -1 || strName.indexOf("'") > -1 || strName.indexOf("\\") > -1 ) {
	           		alert("<spring:message code='ezEmail.t710' />: <spring:message code='ezEmail.kyj17' /> [ & < > \" ' \\ ]");
	           		document.getElementById("TextName").focus();
		            return;
		        }
	            
	            var regex = /^[a-z0-9\_\-\.]+$/;
	            if (!regex.test(strId)) {
	            	alert("<spring:message code='ezEmail.lhm13' />");
	            	return;
	            }
	            
	           	if (cn == "" && $("#selectDomain").val() == "") {
					alert("<spring:message code='ezEmail.multiDomain.ksa17' />");
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
	            createNodeAndInsertText(xmlDom, objNode, "SELECTDOMAIN", selectDomain);
	            
	            if (userDL != "") {
	            	var endDateParam = "";
	            	if ($("input[name=endDateCheckBox]:checked").val() != "on") {
	            		endDateParam = $("input[name=endDate]").val();
	            	}
	            	
		            createNodeAndInsertText(xmlDom, objNode, "OWNERID", userDl_ownerId_temp);
		            createNodeAndInsertText(xmlDom, objNode, "POLICY", $("input[name=policy]:checked").val());
		            createNodeAndInsertText(xmlDom, objNode, "EXPLAINATION", $("input[name=explain]").val());
		            createNodeAndInsertText(xmlDom, objNode, "ENDDATE", endDateParam);
	            }
	            
	            var memberList = document.getElementById("ListViewMsgTo").children.item(0).children.item(1).children;
	            var memberListLength = memberList.length;
	            
	            if (memberListLength <= 0) {
	            	alert("<spring:message code='ezSchedule.t197' />");
	            	return;
	            }
	            
	            for (var i = 0; i < memberListLength; i++) {
	            	var type = memberList.item(i).getAttribute("data4");
	            	
	            	if (type == "ADDRESS") {
		            	var addressType = memberList.item(i).getAttribute("data2");
		            	
		                if (addressType == "mailgroup") {
			                createNodeAndInsertText(xmlDom, objNode, "ADDRESSID", memberList.item(i).getAttribute("data3"));
			                createNodeAndInsertText(xmlDom, objNode, "ADDRESSNAME", "");
			                createNodeAndInsertText(xmlDom, objNode, "ADDRESSMAIL", "");
			                createNodeAndInsertText(xmlDom, objNode, "ADDRESSTYPE", "MAILGROUP");
		                } else {
			                createNodeAndInsertText(xmlDom, objNode, "ADDRESSID", "");
			                createNodeAndInsertText(xmlDom, objNode, "ADDRESSNAME", memberList.item(i).getAttribute("data1"));
			                createNodeAndInsertText(xmlDom, objNode, "ADDRESSMAIL", memberList.item(i).getAttribute("data3"));
			                createNodeAndInsertText(xmlDom, objNode, "ADDRESSTYPE", "MAIL");
		                }
		                
	            	} else if (type == "DIRECT") {
		                createNodeAndInsertText(xmlDom, objNode, "DIRECTMAIL", memberList.item(i).getAttribute("data3"));
		                createNodeAndInsertText(xmlDom, objNode, "DIRECTNAME", memberList.item(i).getAttribute("data1"));
	            		
	            	} else if (type == "JOBMST") {
		                createNodeAndInsertText(xmlDom, objNode, "MEMBERID", memberList.item(i).getAttribute("data3"));
	            	} else {
		                createNodeAndInsertText(xmlDom, objNode, "MEMBERID", memberList.item(i).getAttribute("data1"));
	            	}
	            }
	            
	            xmlHTTP.open("POST", "/admin/ezEmail/mailSaveDistributionList.do", false);
	            xmlHTTP.send(xmlDom);
	            
	            if (xmlHTTP.status == 200 && xmlHTTP.responseText == "OK") {
	            	alert("<spring:message code='ezEmail.t24' />");
	            	
	                if (ReturnFunction != null) {
	                    ReturnFunction(1);
	                } else {
	                    window.returnValue = 1;
	                }
	                
	                window.close();
	            } else if (xmlHTTP.status == 200 && xmlHTTP.responseText == "GROUP_NAME") {
	            	alert("<spring:message code='ezEmail.lhm11' />");
	            } else if (xmlHTTP.status == 200 && xmlHTTP.responseText == "GROUP_ID") {
	            	alert("<spring:message code='ezEmail.lhm12' />");
	            } else {
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
	                        
	                        if ("${useOcs}" == "YES") {
	                            M_TR_TD1.innerHTML = "<span><img src='/images/Presence/unknown.gif' id= '" + GetGUID() + ",type=smtp' style='vertical-align:middle;margin-right:3px;'  onload='PresenceControl(\"" + M_TR.getAttribute("_DATA3") + "\",this);'/></span>" + M_TR.getAttribute("_DATA4");
	                        } else {
	                            M_TR_TD1.innerHTML = M_TR.getAttribute("_DATA4");
	                        	
	                        }
	
	                        var M_TR_TD2 = document.createElement("TD");
	                        M_TR_TD2.style.width = "80px";
	                        M_TR_TD2.innerHTML = M_TR.getAttribute("_DATA6") == "" ? "" : M_TR.getAttribute("_DATA6");
	
	                        var M_TR_TD3 = document.createElement("TD");
	                        M_TR_TD3.innerHTML = M_TR.getAttribute("_DATA8") == "" ? "" : M_TR.getAttribute("_DATA8");
	
	                        if (selTab.indexOf("orgJobMstListView") > -1) {
			                    var M_TR_DEPT_TD = document.createElement("TD");
			                    M_TR_DEPT_TD.style.overflow = "hidden";
			                    M_TR_DEPT_TD.style.textOverflow = "ellipsis";
			                    M_TR_DEPT_TD.style.whiteSpace = "nowrap";
			                    M_TR_DEPT_TD.style.width = "110px";
			                    M_TR_DEPT_TD.innerHTML = M_TR.getAttribute("_DATA5");
			                    
			                    M_TR.appendChild(M_TR_DEPT_TD);
		                    }
	                        
	                        M_TR.appendChild(M_TR_TD1);
	                        M_TR.appendChild(M_TR_TD2);
	                        M_TR.appendChild(M_TR_TD3);
	                        document.getElementById("txtlist_table").getElementsByTagName("TBODY").item(0).appendChild(M_TR);
	                    }
	                }
	            }
	            
	            if (selSpan == "orgSpan" && $(".txtlist_DeptTD").length > 0) {
		        	$(".none").css("display", "none");
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
		                var strMail = nodeIdx.GetNodeData("mail");
		                var isJob = nodeIdx.GetNodeData("isjob"); // 조직도(직위, 직책)
			            var isJobType = nodeIdx.GetNodeData("jobtype"); // 직위:001, 직책:002
						
		                var listid = "MsgToList";
		                var getlistview = new ListView();
		                getlistview.LoadFromID(listid);
		                var bFlag = getlistview.ExistRow("data1", strId);
		                
		                if (!bFlag) {
			            	var valueStr = "<spring:message code='ezEmail.t15' />";
			            	var data3Str = "";
			            	var data4Str = "ORGAN";
			            	
			            	if (isJob === 'true') {
			            		valueStr  = (isJobType === '001') ? "<spring:message code='main.t77' />" : "<spring:message code='ezPersonal.t175' />";
			            		valueStr += " : ";
			            		data4Str  = "JOBMST";
			            		data3Str  = "<DATA3>" + strMail + "</DATA3>";
			            		data3Str += "<JOBTYPE>" + isJobType + "</JOBTYPE>";
			            	}
		                	
		                    pparsingXML2 = "";
		                    pparsingXML = "";
		                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
		                    pparsingXML = pparsingXML + "<DATA4>" + data4Str + "</DATA4>";
		                    pparsingXML = pparsingXML + data3Str;
		                    pparsingXML = pparsingXML + "<VALUE>" + valueStr + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
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
		                            pparsingXML = pparsingXML + "<DATA4>ORGAN</DATA4>";
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
			                var strMail = nodeIdx.GetNodeData("mail");
			                var isJob = nodeIdx.GetNodeData("isjob"); // 조직도(직위, 직책)
				            var isJobType = nodeIdx.GetNodeData("jobtype"); // 직위:001, 직책:002
			                
			                var listid = "MsgToList";
			                var getlistview = new ListView();
	                        getlistview.LoadFromID(listid);
			                var bFlag = getlistview.ExistRow("data1", strId);
			                
		                    if (!bFlag) {
		    	            	var valueStr = "<spring:message code='ezEmail.t15' />";
		    	            	var data3Str = "";
		    	            	var data4Str = "ORGAN";
		    	            	
		    	            	if (isJob === 'true') {
		    	            		valueStr  = (isJobType === '001') ? "<spring:message code='main.t77' />" : "<spring:message code='ezPersonal.t175' />";
		    	            		valueStr += " : ";
		    	            		data4Str  = "JOBMST";
		    	            		data3Str  = "<DATA3>" + strMail + "</DATA3>";
		    	            		data3Str += "<JOBTYPE>" + isJobType + "</JOBTYPE>";
		    	            	}
		    	            	
		                    	pparsingXML2 = "";
			                    pparsingXML = "";
			                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
			                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
			                    pparsingXML = pparsingXML + "<DATA4>" + data4Str + "</DATA4>";
			                    pparsingXML = pparsingXML + data3Str;
			                    pparsingXML = pparsingXML + "<VALUE>" + valueStr + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
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
	            } else if (m_selectedTree == ListViewDL) {
	            	var pListViewDL = new ListView();
	                pListViewDL.LoadFromID("pListViewDL");
	                var arrRows = pListViewDL.GetSelectedRows();
	                
	                if (arrRows.length > 0) {
	                	for (var i = 0; i < arrRows.length; i++) {
		                	var strId = GetAttribute(arrRows[i], "DATA1");
			                var strName = arrRows[i].innerText;
							
			                var listid = "MsgToList";
			                var getlistview = new ListView();
	                        getlistview.LoadFromID(listid);
			                var bFlag = getlistview.ExistRow("data1", strId);
			                
		                    if (!bFlag) {
		                    	pparsingXML2 = "";
			                    pparsingXML = "";
			                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
			                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
			                    pparsingXML = pparsingXML + "<DATA4>DISTRIBUTION</DATA4>";
			                    pparsingXML = pparsingXML + "<VALUE>" + "<spring:message code='ezEmail.t57' /> : " +MakeXMLString(strName) + "</VALUE></CELL></ROW>";
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
	            } else if (m_selectedTree == AddressListView) {
	                var pListViewDL = new ListView();
	                pListViewDL.LoadFromID("Address");
	                var arrRows = pListViewDL.GetSelectedRows();
	                var _tdlength = 0;
	                
	                if (arrRows.length > 0) {
	                    for (var i = 0; i < arrRows.length; i++) {
	                        var pAddressID = GetAttribute(arrRows[i], "DATA1");
	                        var pAddressType = GetAttribute(arrRows[i], "DATA2");
	                        var strName = arrRows[i].cells[0].innerText
	                        var strEmail = GetAttribute(arrRows[i], "DATA3");
	                        
	                        if (strEmail.trim() == "") {
	                            alert(strName + " " + strLang301)
	                            continue;
	                        }
	                        
	                        if (strName.trim() == "") {
	                            strName = strEmail;
	                        }
	
	                        if (strEmail.trim() == "mail") {
	                            continue;
	                        }
	                        
	                        var listid = "MsgToList";
	                        var getlistview = new ListView();
	                        getlistview.LoadFromID("MsgToList");
	                        
	                        var bFlag;
	                        if (pAddressType == "mailgroup") {
	                        	bFlag = getlistview.ExistRow("data3", pAddressID)
	                        } else {
	                        	bFlag = getlistview.ExistRow("data3", strEmail)
	                        } 
	                        
	                        if (!bFlag) {
	                            pparsingXML2 = "";
	                            pparsingXML = "";
	                            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
                                pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(pAddressType) + "</DATA2>";
	                            
	                            if (pAddressType == "mailgroup") {
		                            pparsingXML = pparsingXML + "<DATA3><![CDATA[" + MakeXMLString(pAddressID) + "]]></DATA3>";
	                            } else {
		                            pparsingXML = pparsingXML + "<DATA3><![CDATA[" + MakeXMLString(strEmail) + "]]></DATA3>";
	                            }
	                            
	                            pparsingXML = pparsingXML + "<DATA4>ADDRESS</DATA4>";
	                            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName) + " &lt;" + MakeXMLString(strEmail) + "&gt;" + "</VALUE></CELL></ROW>";
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
	                            _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	                          
	                            for (var y = 0; y < _tdlength; y++) {
	                                document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                                document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	                            }
	                        }
	                    }
	                }
	                
		            for (var i = 0; i < arrRows.length; i++) {
		            	for (var j = 0; j < 3; j++) {
		            		arrRows[i].style.backgroundColor = m_strColorDefault;
		            		arrRows[i].setAttribute("selected", "false");
		            	}
	            	}
	            } else if (m_selectedTree == ListViewINPUT) {
	            	inputAddress();
	            } else if (m_selectedTree == ListViewUserDlApply) {
	            	var pListViewDL = new ListView();
	                pListViewDL.LoadFromID("ListViewUserDlApplyDiv");
	                var arrRows = pListViewDL.GetSelectedRows();
	                
	                if (arrRows.length > 0) {
	                	for (var i = 0; i < arrRows.length; i++) {
		                	var strId = GetAttribute(arrRows[i], "DATA1");
			                var strName = GetAttribute(arrRows[i], "DATA2");
							
			                var listid = "MsgToList";
			                var getlistview = new ListView();
	                        getlistview.LoadFromID(listid);
			                var bFlag = getlistview.ExistRow("data1", strId);
			                
		                    if (!bFlag) {
	                    		pparsingXML2 = "";
	                            pparsingXML = "";
	                            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
	                            pparsingXML = pparsingXML + "<DATA4>ORGAN</DATA4>";
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
	                }
	            }
	            
	            setMsgToCnt();
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
	            	if (userDL == '' || (userDL != '' && userDl_ownerId_temp != arrRows[i].getAttribute("data1"))) {
		            	selList.DeleteRow(arrRows[i].id);
		            }
	            }
	            
	            setMsgToCnt();
	        }
			
	        function orgTabButton_onClick() {
	        	methodForTabAction(1);
		        selTab = "orglistView";
		        selSpan = "orgSpan";
		        
		        m_tabDialogState["org"] = "select";
		        m_tabDialogState["contact"] = "normal";
		        m_tabDialogState["dl"] = "normal";
		        
		        ImageUpdate();
		        clearOrgTab("org");
		        
		        TreeViewTD.style.display = "block";
		        ListViewTD.style.display = "none";
		        ListViewDLTD.style.display = "none";
		        ListViewINPUT.style.display = "none";
		        
		        dlmember.style.display = "none";
		        m_selectedTree = orglistView;
		        AddrSearch.style.display = "none";
		        
		        var xmlpara = createXmlDom();
                var xmlTree = createXmlDom();
                var xmlHTTP = createXMLHttpRequest();
                var objNode;
                
                createNodeInsert(xmlpara, objNode, "DATA");
                <c:choose>
                <c:when test="${cChk == '1'}">
                createNodeAndInsertText(xmlpara, objNode, "DEPTID", companyId);
                createNodeAndInsertText(xmlpara, objNode, "TOPID", "Top/organ");
                createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
                createNodeAndInsertText(xmlpara, objNode, "ADMINDIST", "false");
                createNodeAndInsertText(xmlpara, objNode, "DISPLAYTRASHDEPT", "true");
                </c:when>
                <c:otherwise>
                createNodeAndInsertText(xmlpara, objNode, "DEPTID", companyId);
                createNodeAndInsertText(xmlpara, objNode, "TOPID", companyId);
                createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
                createNodeAndInsertText(xmlpara, objNode, "ADMINDIST", "true");
                createNodeAndInsertText(xmlpara, objNode, "DISPLAYTRASHDEPT", "true");
                </c:otherwise>
                </c:choose>
                
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
		    }
	        
	        var g_bContactLoaded = false;
		    function contactTabButton_onClick() {
		    	methodForTabAction(2);
		        selTab = "AddressListView";
		        selSpan = "contactSpan";
		        
		        if (g_bContactLoaded == false) {
		            g_bContactLoaded = true;
		            LoadAddressTree();
		        }
		        
		        m_tabDialogState["org"] = "normal";
		        m_tabDialogState["contact"] = "select";
		        m_tabDialogState["dl"] = "normal";
		        
		        ImageUpdate();
		        
		        TreeViewTD.style.display = "none";
		        ListViewTD.style.display = "block";
		        ListViewDLTD.style.display = "none";
		        ListViewINPUT.style.display = "none";
		        
		        dlmember.style.display = "none";
		        m_selectedTree = AddressListView;
		        AddrSearch.style.display = "block";
		    }
		    
	        function dlTabButton_onClick() {
	        	methodForTabAction(3);
	        	selTab = "DistributionList";
	        	selSpan = "dlSpan";
	        	
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
		            alert("<spring:message code='ezEmail.t574' />" + xmlHTTP.status);
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
	
	            var dataRows = pListViewDL.GetDataRows();
	            var dataRowCount = pListViewDL.GetRowCount();
	            
	            for (var i = 0; i < dataRowCount; i++) {
	                dataRows[i].draggable = true;
	                if (CrossYN()) {
	                    dataRows[i].ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
	                } else {
	                    dataRows[i].ondragstart = function (event) { event_listdragstart(this); };
	                }
	
	                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                    dataRows[i].ondragend = function (event) { event_listdragend(event); };
	                }
	                
	            }
	        }
	        
	        var g_binputLoaded = false;
	        function inputTabButton_onClick() {
	        	methodForTabAction(4);
	        	selTab = "direct";
	            selSpan = "inputSpan";
	            
	            if (g_binputLoaded == false) {
	                g_binputLoaded = true;
	            }
	            
	            m_tabDialogState["org"] = "normal";
	            m_tabDialogState["contact"] = "normal";
	            m_tabDialogState["dl"] = "normal";
	            m_tabDialogState["input"] = "select";
	            
	            ImageUpdate();
	            
	            TreeViewTD.style.display = "none";
	            ListViewTD.style.display = "none";
	            ListViewDLTD.style.display = "none";
	            ListViewINPUT.style.display = "block";
	            
	            dlmember.style.display = "none";
	            AddrSearch.style.display = "none";
	            
		        m_selectedTree = ListViewINPUT;
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
                
                if (m_selectedTree == AddressListView) {
                    var pListViewDL = new ListView();
                    pListViewDL.LoadFromID("Address");
                    for (var i = 0; i < pListViewDL.GetSelectedRows().length; i++) {
                        if (pListViewDL.GetSelectedRows()[i].id == obj.id) {
                            islist = true;
                            break;
                        }
                    }
                    
                    if (!islist) {
                        obj.onclick();
                    }
                } else if (m_selectedTree == ListViewDL) {
                    var pListViewDL = new ListView();
                    pListViewDL.LoadFromID("pListViewDL");
                    for (var i = 0; i < pListViewDL.GetSelectedRows().length; i++) {
                        if (pListViewDL.GetSelectedRows()[i].id == obj.id) {
                            islist = true;
                            break;
                        }
                    }
                    if (!islist) {
                        obj.onclick();
                    }
                } else if (m_selectedTree == orglistView) {
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
	                    contactTabButton.setAttribute('src', m_contactImg[m_tabDialogState["contact"]]);
	                    dlTabButton.setAttribute('src', m_dlImg[m_tabDialogState["dl"]]);
	                }).call(this)
	                : (CrossYN()) ?
	                (function () {
	                    orgTabButton.setAttribute('src', m_orgImg[m_tabDialogState["org"]]);
	                    contactTabButton.setAttribute('src', m_contactImg[m_tabDialogState["contact"]]);
	                    dlTabButton.setAttribute('src', m_dlImg[m_tabDialogState["dl"]]);
	                }).call(this)
	                :
	                (function () {
	                    orgTabButton.src = m_orgImg[m_tabDialogState["org"]];
	                    contactTabButton.src = m_contactImg[m_tabDialogState["contact"]];
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
	            //var dept = p_ListOrderObject.getAttribute("_DATA13");
	            var dept = p_ListOrderObject.getAttribute("_DATA10");
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
	            } else {
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
	                            pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(rtnValue["email"][i]) + "</DATA2>";
	                            pparsingXML = pparsingXML + "<DATA3></DATA3>";
	                            pparsingXML = pparsingXML + "<DATA4></DATA4>";
	                            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(rtnValue["name"][i]) + " &lt;" + MakeXMLString(rtnValue["email"][i]) + "&gt;" + "</VALUE></CELL></ROW>";
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
                    var pparsingXML = "";
                    var pparsingXML2 = "";
                    
                    for (var i = 0; i < count; i++) {
                    	var strEmail = mail_select_dlmember_cross_dialogArguments[0]["email"][i];
                    	var strName = mail_select_dlmember_cross_dialogArguments[0]["name"][i];
                    	
                        var listview = new ListView();
                        listview.LoadFromID("MsgToList");
                        var bFlag = listview.ExistRow("data1", strName);
                        
                        if (!bFlag) {
                            pparsingXML = "";
                            pparsingXML2 = "";
                        	pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
                            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
                            pparsingXML = pparsingXML + "<DATA3>" + MakeXMLString(strEmail) + "</DATA3>";
                            pparsingXML = pparsingXML + "<DATA4>DIRECT</DATA4>";
                            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName) + " &lt;" + MakeXMLString(strEmail) + "&gt;" + "</VALUE></CELL></ROW>";
                            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
                            Resultxml = loadXMLString(pparsingXML2);
                            
                            var MaxID = 0;
                            var getlistview = new ListView();
                            getlistview.LoadFromID("MsgToList");
                            var InitTr = getlistview.GetDataRows();
                            
                            for (var j = 0  ; j < InitTr.length  ; j++) {
                                var curnum = Number(getlistview.GetSelectedRowID(j).substring(getlistview.GetSelectedRowID(j).lastIndexOf('_') + 1), getlistview.GetSelectedRowID(j).length);
                                if (MaxID < curnum) {
                                    MaxID = curnum;
                                }
                            }

                            var objTr = getlistview.AddRow(InitTr.length);
                            SetAttribute(objTr, "id", getlistview.GetSelectedRowID(MaxID).substring(0, getlistview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1) + eval(MaxID + 1));
                            getlistview.AddDataRow(objTr, Resultxml);
                            
                            var _tdlength = document.getElementById("MsgToList").getElementsByTagName("TD").length;
                            
                            for (var y = 0; y < _tdlength; y++) {
                                document.getElementById("MsgToList").getElementsByTagName("TD")[y].style.textOverflow = "";
                                document.getElementById("MsgToList").getElementsByTagName("TD")[y].style.overflow = "";
                            }
                    	}
					}
	            } catch (e) { }
	        }
	        
	        function dept_select() {
	            var organTree = new TreeView();
	            organTree.LoadFromID("FromTreeView");
	            var nodeIdx = organTree.GetSelectNode();
	            var listid = "MsgToList";
	           
	            var strId = nodeIdx.GetNodeData("CN");
	            var strName = nodeIdx.NodeName;
	            var strMail = nodeIdx.GetNodeData("mail");
	            var isJob = nodeIdx.GetNodeData("isjob"); // 조직도(직위, 직책)
	            var isJobType = nodeIdx.GetNodeData("jobtype"); // 직위:001, 직책:002
	           
	            var pparsingXML = "";
	            var getlistview = new ListView();
	            getlistview.LoadFromID(listid);
	            var bFlag = getlistview.ExistRow("data1", strId);
				
	            if (!bFlag) {
	            	var valueStr = "<spring:message code='ezEmail.t15' />";
	            	var data3Str = "";
	            	var data4Str = "ORGAN";
	            	
	            	if (isJob === 'true') {
	            		valueStr  = (isJobType === '001') ? "<spring:message code='main.t77' />" : "<spring:message code='ezPersonal.t175' />";
	            		valueStr += " : ";
	            		data4Str  = "JOBMST";
	            		data3Str  = "<DATA3>" + strMail + "</DATA3>";
	            		data3Str += "<JOBTYPE>" + isJobType + "</JOBTYPE>";
	            	}
	            	
                    pparsingXML2 = "";
                    pparsingXML = "";
                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
                    pparsingXML = pparsingXML + "<DATA4>" + data4Str + "</DATA4>";
                    pparsingXML = pparsingXML + data3Str;
                    pparsingXML = pparsingXML + "<VALUE>" + valueStr + MakeXMLString(strName) + "</VALUE></CELL></ROW>";
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
	        	var tabIds = ["orgTabButton", "contactTabButton", "dlTabButton", "inputTabButton", "userDlApplyButton",
	        	              "orgJobMasterTabButton1", "orgJobMasterTabButton2"];
            	var targetTab = tabIds[target-1];
            	
            	$.each(tabIds, function(i,d) {
        			var setVal = targetTab == d ? "tabon" : "";
        			var tmp = document.getElementById(d);
        				
        			if (tmp != null) {
        				tmp.children[0].className = setVal;
        			}
        		});
	        	
            	/* var tab1 = document.getElementById("orgTabButton").children[0];
            	var tab2 = document.getElementById("contactTabButton").children[0];
            	var tab3 = document.getElementById("dlTabButton").children[0];
            	var tab4 = document.getElementById("inputTabButton").children[0];
            	
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
            	
            	if (userDL == "modify") {
            		var tab5 = document.getElementById("userDlApplyButton").children[0];
            		
            		if (target != 5) {
                		tab5.className = "";
            		} else {
                		tab1.className = "";
                		tab2.className = "";
                		tab3.className = "";
                		tab4.className = "";
                		tab5.className = "tabon";
            		}
            	} */
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
	        
	        var xmlHTTP = null;
	        function get_Address_FullTree() {
	            xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("POST", "/ezAddress/addressGetFullTree.do", true);
	            xmlHTTP.onreadystatechange = event_get_Address_FullTree;
	            xmlHTTP.send();
	        }
	        
	        function event_get_Address_FullTree() {
	            if (xmlHTTP.readyState == 4 && xmlHTTP != null) {
	                if (xmlHTTP.status == 200) {
	                    var treexmldom = loadXMLString(xmlHTTP.responseText);
	                    var IDNodes = treexmldom.getElementsByTagName("FOLDERID");
	                    var ChangeKeyNodes = treexmldom.getElementsByTagName("CHANGEKEY");
	                    var OwnerNodes = treexmldom.getElementsByTagName("OWNERID");
	                    var TypeNodes = treexmldom.getElementsByTagName("FOLDERTYPE");
	                    var NameNodes = treexmldom.getElementsByTagName("FOLDERNAME");
	                    var ChildNodes = treexmldom.getElementsByTagName("CHILDCOUNT");
	                    xmlHTTP = null;
	                    var childXML = "<tree><nodes>";
	
	                    for (var i = 0; i < NameNodes.length; i++) {
	                        var strFolderName = NameNodes[i].firstChild.nodeValue;
	
	                        childXML += "<node imgidx='1' caption=\"";
	                        childXML += (strFolderName + "\" ");
	                        childXML += ("ownerid=\"" + MakeRightField(OwnerNodes[i].firstChild.nodeValue) + "\" ");
	                        childXML += ("type=\"" + MakeRightField(TypeNodes[i].firstChild.nodeValue) + "\" ");
	                        childXML += ("folderid=\"" + MakeRightField(IDNodes[i].firstChild.nodeValue) + "\" ");
	                        childXML += ("changekey=\"" + MakeRightField(ChangeKeyNodes[i].firstChild.nodeValue) + "\" ");
	
	                        if (ChildNodes[i].firstChild.nodeValue != "0") {
	                            childXML += "hassub='1' ";
	                        }
	
	                        childXML += "/>";
	                    }
	                    childXML += "</nodes></tree>";
	
	                    AddressTreeView.source(childXML);
	                    AddressTreeView.update();
	                    AddressTreeView.select(1);
	                } else { 
	                    xmlHTTP = null;
	                }
	            }
	        }
	        
	        function address_requestdata(event) {
                if (!event) {
                    event = window.event;
                }

                var nodeIdx = event.nodeIdx;

                if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
                    nodeIdx = arguments[0].nodeIdx;
                }

                var childxml = get_Address_childXML(AddressTreeView.getvalue(nodeIdx, "folderid"), AddressTreeView.getvalue(nodeIdx, "ownerid"), AddressTreeView.getvalue(nodeIdx, "type"))
                AddressTreeView.putchildxml(nodeIdx, childxml);
            }
	        
	        var tempfolderid = "";
	        function address_selectnode(pGubun) {
	            var nodeIdx = AddressTreeView.selectedIndex();
	            var folderid = AddressTreeView.getvalue(nodeIdx, "folderid");
	            var ownerid = AddressTreeView.getvalue(nodeIdx, "ownerid");
	            var foldertype = AddressTreeView.getvalue(nodeIdx, "type");
	            
	            if (CrossYN()) {
	                document.getElementById("addressFolderName").textContent = AddressTreeView.selectedNode().textContent;
	            } else {
	                document.getElementById("addressFolderName").innerText = AddressTreeView.selectedNode().innerText;
	            }
	
	            var xmlDom = null;
	            if (tempfolderid != folderid) {
	                page = "1";
	            }

	            xmlDom = call_page_address_get_list_mailCall(folderid, ownerid, foldertype,
	                "ADDRESSID,STYPE,SNAME,SCOMPANY,SCOMPANYPHONE,SEMAIL", "NOT SEMAIL=''", page, "25", searchgubun, "<spring:message code='ezEmail.t585' />");
	            tempfolderid = folderid;
	
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.getElementById('totalcount').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue;
	                document.getElementById('addressFolderCnt').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue + strLang300;
	                document.getElementById('txt_PageInputNum').value = pGubun == "page" ? xmlDom.getElementsByTagName("CURRENTPAGE").item(0).firstChild.nodeValue : "1";
	                page = document.getElementById('txt_PageInputNum').value;
	
	                totalPage = Math.ceil(xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue / 25);
	                pageNum = page;
	            } else if (CrossYN()) {
	                document.getElementById('totalcount').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue;
	                document.getElementById('addressFolderCnt').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue + strLang300;
	                document.getElementById('txt_PageInputNum').value = pGubun == "page" ? xmlDom.getElementsByTagName("CURRENTPAGE").item(0).firstChild.nodeValue : "1";
	                page = document.getElementById('txt_PageInputNum').value;
	
	                totalPage = Math.ceil(xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue / 25);
	                pageNum = page;
	            } else {
	                document.getElementById('totalcount').innerText = xmlDom.getElementsByTagName("TOTALCN").item(0).text;
	                document.getElementById('addressFolderCnt').innerText = xmlDom.getElementsByTagName("TOTALCN").item(0).text + strLang300;
	                document.getElementById('txt_PageInputNum').value = pGubun == "page" ? xmlDom.getElementsByTagName("CURRENTPAGE").item(0).text : "1";
	                page = document.getElementById('txt_PageInputNum').value;
	
	                totalPage = Math.ceil(xmlDom.getElementsByTagName("TOTALCN").item(0).text / 25);
	                pageNum = page;
	            }
	            
	            document.getElementById("AddressListView").innerHTML = "";
	            var addressList = new ListView();
	            addressList.SetID("Address");
	            addressList.SetSelectFlag(false);
	            addressList.SetHeightFree(true);
	            addressList.SetMulSelectable(true);
	            addressList.SetRowOnDblClick("ListViewNodeDblClick");
	            addressList.DataSource(loadXMLString(document.getElementById("listviewheader4").innerHTML.toUpperCase()));
	            addressList.DataBind("AddressListView");
	            addressList.DataSource(get_xmldom_addresslistview(xmlDom));
	            addressList.RowDataBind();
	            
	            for (var i = 0; i < addressList.GetRowCount() ; i++) {
	                addressList.GetDataRows()[i].draggable = true;
	                
	                if (CrossYN()) {
	                    addressList.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
	                } else {
	                    addressList.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); };
	                }
	
	                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                    addressList.GetDataRows()[i].ondragend = function (event) { event_listdragend(event); };
	                }
	            }
	            
	            addressList = null;
	            addrsearh = false;
	            makePageSelPage();
	        }
	        
	        function call_page_address_get_list_mailCall(folderid, ownerid, foldertype, field, filter, page, pagesize, searchgubun, errormesg) {
                var xmlhttp = createXMLHttpRequest();
                var xmlpara = createXmlDom();
                var objNode;
                
                createNodeInsert(xmlpara, objNode, "DATA");
                createNodeAndInsertText(xmlpara, objNode, "FOLDERID", folderid);
                createNodeAndInsertText(xmlpara, objNode, "OWNERID", ownerid);
                createNodeAndInsertText(xmlpara, objNode, "FOLDERTYPE", foldertype);
                createNodeAndInsertText(xmlpara, objNode, "FIELD", field);
                createNodeAndInsertText(xmlpara, objNode, "FILTER", filter);
                createNodeAndInsertText(xmlpara, objNode, "PAGE", page);
                createNodeAndInsertText(xmlpara, objNode, "PAGESIZE", pagesize);
                createNodeAndInsertText(xmlpara, objNode, "SEARCHGUBUN", searchgubun);
                
                /* if(foldertype =="P")
                    xmlhttp.open("POST", "/myoffice/ezAddress/remoteEWS/address_get_list_mailCall.aspx", false);
                else
                    xmlhttp.open("POST", "/myoffice/ezAddress/remote/address_get_list_mailCall.aspx", false); */
                xmlhttp.open("POST", "/ezAddress/addressGetListMailCall.do", false);
                
                xmlhttp.send(xmlpara);
                if(CrossYN()) {
                    return xmlhttp.responseXML;
                } else {
                    return loadXMLString(xmlhttp.responseText);
                }
            }
	        
	        function get_xmldom_addresslistview(xmlDom) {
                var XmlRows = SelectNodes(xmlDom, "RTNDATA/DATA/ROW");
                var xmlpara = createXmlDom();
                var objRoot, objNode, objHeader, HEADERS, HEADER, ROWS, ROW, CELL, CELLVALUE;
                
                objRoot = createNodeInsert(xmlpara, objRoot, "LISTVIEWDATA");
                ROWS = createNodeAndAppandNode(xmlpara, objRoot, ROWS, "ROWS");
                
                for (var count = 0; count < XmlRows.length; count++) {
                    ROW = createNodeAndAppandNode(xmlpara, ROWS, ROW, "ROW");
                    CELL = createNodeAndAppandNode(xmlpara, ROW, CELL, "CELL");
                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "VALUE", SelectSingleNodeValue(XmlRows[count], "SNAME"));
                    
                    if (SelectSingleNodeValue(XmlRows[count], "STYPE") == "G") {
                        createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA1", SelectSingleNodeValue(XmlRows[count], "ADDRESSID"));
                        createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA2", "mailgroup");
                    } else {
                        createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA1", "");
                        createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA2", "email");
                    }
                    
                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA3", SelectSingleNodeValue(XmlRows[count], "SEMAIL"));
                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "DATA4", SelectSingleNodeValue(XmlRows[count], "FOLDERTYPE"));
                    CELL = createNodeAndAppandNode(xmlpara, ROW, CELL, "CELL");
                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "VALUE", SelectSingleNodeValue(XmlRows[count], "SCOMPANY"));
                    CELL = createNodeAndAppandNode(xmlpara, ROW, CELL, "CELL");
                    createNodeAndAppandNodeText(xmlpara, CELL, CELLVALUE, "VALUE", SelectSingleNodeValue(XmlRows[count], "SEMAIL"));
                }
                return xmlpara;
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
                    PagingHTML += "<span class=\"btnimg first\" onclick= 'return goToPageByNum(1)'></span>";
                } else {
                    PagingHTML += "<span class=\"btnimg first disabled\"></span>";
                }
                
                if (totalPage > BlockSize) {
                    if (parseInt(pageNum) > parseInt(BlockSize)) {
                        PagingHTML += "<span class=\"btnimg prev\" onclick= 'return selbeforeBlock()'></span>";
                    } else {
                        PagingHTML += "<span class=\"btnimg prev disabled\" ></span>";
                    }
                } else {
                    PagingHTML += "<span class=\"btnimg prev disabled\" ></span>";
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
                        PagingHTML += "<span class=\"btnimg next\" onclick='return selafterBlock()'></span>";
                    } else {
                        PagingHTML += "<span class=\"btnimg next disabled\"></span>";
                    }
                } else {
                    PagingHTML += "<span class=\"btnimg next disabled\"></span>";
                }
                
                if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
                    PagingHTML += "<span class=\"btnimg last\" onclick='return goToPageByNum(" + totalPage + ")'></span>";
                } else {
                    PagingHTML += "<span class=\"btnimg last disabled\"></span>";
                }
                
                PagingHTML += "</div>";
                td_Create1(PagingHTML);
            }
            
            var address_select_groupemaillist_dialogArguments = new Array();
	        function groupmember_click() {
	            var AdddressList = new ListView();
	            AdddressList.LoadFromID("Address");
	            var listview = AdddressList.GetSelectedRows();
	            
	            if (listview.length < 1) {
	                alert("<spring:message code='ezEmail.t581' />");
	                return;
	            }
	            
	            var type = GetAttribute(listview[0], "DATA2");
	            if (type != "mailgroup") {
	                alert("<spring:message code='ezEmail.t581' />");
	                return;
	            }
	            
	            var FolderType = GetAttribute(listview[0], "DATA4");
	            var ID = GetAttribute(listview[0], "DATA1");
	            var Url = "";
	            /* if(FolderType =="P")
	                Url = "../ezAddress/RemoteEWS/address_select_groupemaillist.aspx?id=" + encodeURIComponent(ID) + "&foldertype=" + encodeURIComponent(FolderType);
	            else
	                Url = "../ezAddress/Remote/address_select_groupemaillist.aspx?id=" + encodeURIComponent(ID) + "&foldertype=" + encodeURIComponent(FolderType); */
	            Url = "/ezAddress/addressSelectGroupMailList.do?id=" + encodeURIComponent(ID) + "&foldertype=" + encodeURIComponent(FolderType);
	            
	            if (ReturnFunction != null)  {
	                var rtnValue = { "name": new Array(), "email": new Array() };
	                address_select_groupemaillist_dialogArguments[0] = rtnValue;
	                address_select_groupemaillist_dialogArguments[1] = groupmember_click_Complete;
	                address_select_groupemaillist_dialogArguments[2] = DivPopUpHidden;
	                DivPopUpShow(601, 470, Url);
	            } else {
	                var rtnValue = { "name": new Array(), "email": new Array() };
	                var count = window.showModalDialog(Url, rtnValue, "dialogHeight:470px; dialogWidth:601px; status:no;scroll:auto; help:no; edge:sunken");
	                
	                for (var i = 0; i < count; i++) {
	                    var listview = new ListView();
	                    listview.LoadFromID("MsgToList");
	                    
	                    var bFlag = listview.ExistRow("data1", rtnValue["email"][i]);
	                    targetList = null;
	                    
	                    if (!bFlag) {
	                        pparsingXML2 = "";
	                        pparsingXML = "";
	                        pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(rtnValue["name"][i]) + "</DATA1>";
	                        pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(rtnValue["email"][i]) + "</DATA2>";
	                        pparsingXML = pparsingXML + "<DATA3></DATA3>";
	                        pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(rtnValue["name"][i]) + " &lt;" + MakeXMLString(rtnValue["email"][i]) + "&gt;" + "</VALUE></CELL></ROW>";
	                        pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                        Resultxml = loadXMLString(pparsingXML2);
	                        
	                        var MaxID = 0;
	                        var InitTr = listview.GetDataRows();
	                        
	                        for (var j = 0  ; j < InitTr.length  ; j++) {
	                            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);

	                            if (MaxID < curnum) {
	                                MaxID = curnum;
	                            }
	                        }
	                        
	                        var objTr = listview.AddRow(InitTr.length);
	                        SetAttribute(objTr, "id", listview.GetSelectedRowID(InitTr.length).substring(0, listview.GetSelectedRowID(InitTr.length).lastIndexOf('_') + 1) + eval(MaxID + 1));
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
	        
	        function groupmember_click_Complete(count) {
	            DivPopUpHidden();
	            try {
	                for (var i = 0; i < count; i++) {
	                	var strEmail = address_select_groupemaillist_dialogArguments[0]["email"][i];
	                	var strName = address_select_groupemaillist_dialogArguments[0]["name"][i];
	                	
	                    var listview = new ListView();
	                    listview.LoadFromID("MsgToList");
	                    var bFlag = listview.ExistRow("data1", strName);
	                    
	                    if (!bFlag) {
	                        pparsingXML2 = "";
	                        pparsingXML = "";
	                        pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                        pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
	                        pparsingXML = pparsingXML + "<DATA3>" + MakeXMLString(strEmail) + "</DATA3>";
	                        pparsingXML = pparsingXML + "<DATA4>DIRECT</DATA4>";
                            pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName) + " &lt;" + MakeXMLString(strEmail) + "&gt;" + "</VALUE></CELL></ROW>";
	                        pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	                        Resultxml = loadXMLString(pparsingXML2);
	                        
	                        var MaxID = 0;
	                        var getlistview = new ListView();
	                        getlistview.LoadFromID("MsgToList");
	                        var InitTr = getlistview.GetDataRows();
	                        
	                        for (var j = 0  ; j < InitTr.length  ; j++) {
	                            var curnum = Number(getlistview.GetSelectedRowID(j).substring(getlistview.GetSelectedRowID(j).lastIndexOf('_') + 1), getlistview.GetSelectedRowID(j).length);
	                            if (MaxID < curnum) {
	                                MaxID = curnum;
	                            }
	                        }
	                        
	                        var objTr = getlistview.AddRow(InitTr.length);
	                        SetAttribute(objTr, "id", getlistview.GetSelectedRowID(MaxID).substring(0, getlistview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1) + eval(MaxID + 1));
	                        getlistview.AddDataRow(objTr, Resultxml);
	                        
	                        var _tdlength = document.getElementById("MsgToList").getElementsByTagName("TD").length;
	                        
	                        for (var y = 0; y < _tdlength; y++) {
	                            document.getElementById("MsgToList").getElementsByTagName("TD")[y].style.textOverflow = "";
	                            document.getElementById("MsgToList").getElementsByTagName("TD")[y].style.overflow = "";
	                        }
	                    
	                    }
	                }
	            } catch (e) { }
	        }
	        
	        function on_keydown() {
                if (window.event.keyCode == "13")
                    inputAddress();
            }
	        
	        function inputAddress() {
	        	var strName = document.getElementById("emailname").value;
                var strEmail = document.getElementById("emailaddr").value.trim();
	        	
                if (strName == "") {
                    document.getElementById("emailname").focus();
                    alert(strLang196);
                    return;
                } else if (strEmail == "") {
                    document.getElementById("emailaddr").focus();
                    alert(strLang197);
                    return;
                }
                
                if (strName.indexOf("&") > -1 || strName.indexOf("<") > -1 || strName.indexOf(">") > -1 
		        		 || strName.indexOf("\"") > -1 || strName.indexOf("'") > -1 || strName.indexOf("\\") > -1) {
                	alert("<spring:message code='ezEmail.psb17' /> [ & < > \" ' \\ ]");
                	document.getElementById("emailname").focus();
		            return;
		        }
                
                var emailMatch = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9_-]+\.[a-zA-Z0-9_.-]+$/;
                if (!emailMatch.test(strEmail)) {
                	document.getElementById("emailaddr").focus();
                    alert(strLang198);
                    return;
                }

                var pparsingXML = "";
                var pparsingXML2 = "";
                var listid = "MsgToList";
                var listview = new ListView();
                listview.LoadFromID(listid);
                var MaxID = 0;
                var InitTr = listview.GetDataRows();
                
                var bFlag = listview.ExistRow("data3", strEmail);
                if(!bFlag) {
	              pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	              pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strName) + "</DATA1>";
	              pparsingXML = pparsingXML + "<DATA3>" + MakeXMLString(strEmail) + "</DATA3>";
	              pparsingXML = pparsingXML + "<DATA4>DIRECT</DATA4>";
	              pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(strName) + " &lt;" + MakeXMLString(strEmail) + "&gt;" + "</VALUE></CELL></ROW>";
	              pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
	              Resultxml = loadXMLString(pparsingXML2);
	              
	              for (var j = 0  ; j < InitTr.length  ; j++) {
	                  var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                  if (MaxID < curnum)
	                      MaxID = curnum;
	              }
	              
	              var objTr = listview.AddRow(InitTr.length);
	              SetAttribute(objTr, "id", listview.GetSelectedRowID(InitTr.length).substring(0, listview.GetSelectedRowID(InitTr.length).lastIndexOf('_') + 1) + eval(MaxID + 1));
	              listview.AddDataRow(objTr, Resultxml);
	
	              var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
	              for (var y = 0; y < _tdlength; y++) {
	                  document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
	                  document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
	              }
	              
	              if (document.getElementById("emailname").value != "") {
	                  document.getElementById("emailname").value = "";
	              }
	              
	              if (document.getElementById("emailaddr").value != "") {
	                  document.getElementById("emailaddr").value = "";
	              }
                }
                
                setMsgToCnt();
            }
	        
	        function AddrSearch_press() {
	            if (window.event.keyCode == "13") {
	                AddrSearch_click();
	            }
	        }
	        
	        function AddrSearch_click() {
	            page = "1";
	            AddrSearch_event();
	        }
	        
	        function AddrSearch_event() {
	            var objSel = "SNAME";
	            var objText = document.getElementById("search_text");
	            
	            if (objText.value == "") {
	                alert("<spring:message code='ezEmail.t576' />");
	                objText.focus();
	                return;
	            }
	
	            var nodeIdx = AddressTreeView.selectedIndex();
	            var parentFolderId = AddressTreeView.getvalue(nodeIdx, "folderid");
	            var ownerid = AddressTreeView.getvalue(nodeIdx, "ownerid");
	            var foldertype = AddressTreeView.getvalue(nodeIdx, "type");
	
	            var curpage = "1";
	            if (addrsearh) {
	                curpage = page;
	            }
	            
	            var strXML = "<DATA>"
	                         + "<FOLDERID>" + parentFolderId + "</FOLDERID>"
	                         + "<FOLDERTYPE>" + foldertype + "</FOLDERTYPE>"
	                         + "<OWNERID>" + ownerid + "</OWNERID>"
	                         + "<CASE>" + document.getElementById("search_case").value + "</CASE>"
	                         + "<FILTER>" + document.getElementById("search_text").value + "</FILTER>"
	                         + "<PAGE>" + curpage + "</PAGE>"
	                         + "<PAGESIZE>25</PAGESIZE>"
	                         + "</DATA>";
	
	            addrsearh = true;
	            var xmlHTTP = createXMLHttpRequest();
                xmlHTTP.open("POST", "/ezAddress/addressGetListMailSearchCall.do", false);
	            xmlHTTP.send(strXML);
	            
	            if (xmlHTTP.status != 200) {
	                alert("<spring:message code='ezEmail.t585' />");
	                objText.focus();
	                return;
	            }
	            
	            var xmlDom
	            if (CrossYN()) {
	                xmlDom = xmlHTTP.responseXML;
	            } else {
	                xmlDom = loadXMLString(xmlHTTP.responseText);
	            }
	
	            var arrRows = GetElementsByTagName(xmlDom, "ROW");
	            if (arrRows.length > 0) {
	                document.getElementById("totalcount").innerHTML = arrRows.length;
	            } else {
	                document.getElementById("totalcount").innerHTML = "0";
	            }
	            
	            var addressList = new ListView();
	            addressList.SetID("Address");
	            addressList.SetSelectFlag(false);
	            addressList.SetHeightFree(true);
	            addressList.SetMulSelectable(true);
	            addressList.SetRowOnDblClick("ListViewNodeDblClick");
	            addressList.DataBind("AddressListView");
	            addressList.DataSource(get_xmldom_addresslistview(xmlDom));
	            addressList.RowDataBind();
	            
	            for (var i = 0; i < addressList.GetRowCount() ; i++) {
	                addressList.GetDataRows()[i].draggable = true;
	                if (CrossYN())
	                    addressList.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
	                else
	                    addressList.GetDataRows()[i].ondragstart = function (event) { event_listdragstart(this); };
	
	                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                    addressList.GetDataRows()[i].ondragend = function (event) { event_listdragend(event); };
	                }
	            }
	            
	            addressList = null;
	            document.getElementById('totalcount').textContent = xmlDom.getElementsByTagName("PAGECOUNT").item(0).firstChild.nodeValue;
	            
	            if (CrossYN()) {
	                document.getElementById('addressFolderCnt').textContent = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue + strLang300;
	            }
	            else {
	                document.getElementById('addressFolderCnt').innerText = xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue + strLang300;
	            }
	            
	            document.getElementById('txt_PageInputNum').value = "1";
	            //page = document.getElementById('txt_PageInputNum').value;
	            totalPage = Math.ceil(xmlDom.getElementsByTagName("TOTALCN").item(0).firstChild.nodeValue / 25);
	            pageNum = page;
	
	            makePageSelPage();
	        }
	        
	        $(document).on("change", "#selectDomain", function() {
				var mailDomain = "@" + $(this).val();
	        	$("#mailDomain").text(mailDomain);
	        	
	        	selectDomain = $(this).val();
	        });
	        
	        function userDLSetDatePicker() {
	        	$.datepicker.regional["<spring:message code='main.t0619' />"] = {
			            closeText: "<spring:message code='main.t3' />",
			            prevText: "<spring:message code='main.t0604' />",
			            nextText: "<spring:message code='main.t0605' />",
			            currentText: "<spring:message code='main.t0606' />",
			            monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
			                         "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
			                         "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
			                         "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
			            monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
			                              "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
			                              "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
			                              "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
			            dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
			                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
			                       "<spring:message code='main.t0627' />"],
			            dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					                       "<spring:message code='main.t0627' />"],
			            dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
				                       "<spring:message code='main.t0627' />"],
			            weekHeader: "Wk",
			            dateFormat: "yy-mm-dd",
			            firstDay: 0,
			            isRTL: false,
			            duration: 200,
			            showAnim: "show",
			            showMonthAfterYear: true
			        };
			        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
	        	
	        	$("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            minDate: 0,
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true,
		        });
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', setEndDate);
	        }
	        
	        function endDateCheckBox_Click(obj) {
		        if (obj.checked) {
		            $("#Sdatepicker").datepicker('disable');
		            $(".datepickerImg").css({"opacity" : 0.5, "cursor" : "pointer"});
		        } else {
		            $("#Sdatepicker").datepicker('enable');
		            $(".datepickerImg").css({"opacity" : 1, "cursor" : "default"});
		        }
		    }
	        
	        // 사용자 정의 공용배포그룹 가입신청 탭
	        function userDlApplyButton_onClick() {
	        	methodForTabAction(5);
	        	selTab = "userDlApply";
	            selSpan = "userDlSpan";
	            
	            m_tabDialogState["org"] = "normal";
	            m_tabDialogState["contact"] = "normal";
	            m_tabDialogState["dl"] = "normal";
	            m_tabDialogState["input"] = "normal";
	            m_tabDialogState["userDlApply"] = "select";
	            
	            ImageUpdate();
	             
	            TreeViewTD.style.display = "none";
	            ListViewTD.style.display = "none";
	            ListViewDLTD.style.display = "none";
	            ListViewINPUT.style.display = "none";
	            ListViewUserDlApply.style.display = "block";

		        dlmember.style.display = "none";
		        AddrSearch.style.display = "none";
		        m_selectedTree = ListViewUserDlApply;
		        
		        userDlApplyList();
	        }
	        
	        function userDlApplyList() {
	        	try {
		        	var xmlDom = createXmlDom();
		            var xmlHTTP = createXMLHttpRequest();
		            var objRoot;
		            createNodeInsert(xmlDom, objRoot, "DATA");
		            createNodeAndInsertText(xmlDom, objRoot, "COMPID", companyid);
		            
		            if (cn != null) {
		            	createNodeAndInsertText(xmlDom, objRoot, "CN", cn);
		            }
		            
		            xmlHTTP.open("POST", "/ezEmail/mailUserDistributionApplyList.do", false);
		            xmlHTTP.send(xmlDom);
		        } catch (e) {
		            alert("<spring:message code='ezEmail.userDL29' />" + e.description);
		            xmlHTTP = null;
		            return;
		        }
		        
		        if (xmlHTTP.status != 200) {
		            alert("<spring:message code='ezEmail.userDL29' />" + xmlHTTP.status);
		                xmlHTTP = null;
		                xmlDom = null;
		                return;
	            }
		        
	            document.getElementById("ListViewUserDlApplyDiv").innerHTML = "";
	            var pListViewDLApply = new ListView();
	            pListViewDLApply.SetID("ListViewUserDlApplyDiv");
	            pListViewDLApply.SetSelectFlag(false);
	            pListViewDLApply.SetMulSelectable(true);
	            pListViewDLApply.SetRowOnDblClick("ListViewNodeDblClick");
	            pListViewDLApply.DataBind("ListViewDL");
	            pListViewDLApply.DataSource(loadXMLString(xmlHTTP.responseText));
	            pListViewDLApply.RowDataBind();
	
	            var dataRows = pListViewDLApply.GetDataRows();
	            var dataRowCount = pListViewDLApply.GetRowCount();
	            
	            for (var i = 0; i < dataRowCount; i++) {
	                dataRows[i].draggable = true;
	                if (CrossYN()) {
	                    dataRows[i].ondragstart = function (event) { event_listdragstart(this); event.dataTransfer.setData('text/plain', 'dragged'); };
	                } else {
	                    dataRows[i].ondragstart = function (event) { event_listdragstart(this); };
	                }
	
	                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                    dataRows[i].ondragend = function (event) { event_listdragend(event); };
	                }
	                
	            }
	        }
	        
	        function setMsgToCnt() {
	        	var msgCnt = $("#MsgToList tbody>tr").length;
	        	$(".toTitleCnt b").text(msgCnt);
	        }
	        
	        // 사용자 정의 공용배포그룹 소유자 등록
	        function inputOwnerAddress(strName, strId) {
	        	strName = strName.trim();
	        	strId = strId.trim();
	        	
	        	if (strName == "" || strId == "") {return; }
					                
                var pparsingXML = "";
                var pparsingXML2 = "";
                var listid = "MsgToList";
                var getlistview = new ListView();
                getlistview.LoadFromID(listid);
                var MaxID = 0;
                var InitTr = getlistview.GetDataRows();
                
                var bFlag = getlistview.ExistRow("data1", strId);
                if(!bFlag) {
                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + MakeXMLString(strId) + "</DATA1>";
                    pparsingXML = pparsingXML + "<DATA4>ORGAN</DATA4>";
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
                    
					var ownerTR_ID = getlistview.GetSelectedRowID(MaxCntNum).substring(0, getlistview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1);
                    SetAttribute(objTr, "id", ownerTR_ID);
                    getlistview.AddDataRow(objTr, Resultxml);

                    var _tdlength = document.getElementById(listid).getElementsByTagName("TD").length;
                    for (var y = 0; y < _tdlength; y++) {
                        document.getElementById(listid).getElementsByTagName("TD")[y].style.textOverflow = "";
                        document.getElementById(listid).getElementsByTagName("TD")[y].style.overflow = "";
                    }
                    
                    setMsgToCnt();
                }
            }

		    var mail_user_distributionOwner_cross_dialogArguments = new Array();
	        function ownerChange() {
	        	var popUrl = "/ezEmail/mailUserDistributionSelectOwner.do";
				var param = "?ownerId=" + userDl_ownerId + "&ownerName=" +userDl_ownerName;
				var popSizeW = 750;
				var popSizeH = 580;
				var feature = "dialogHeight:" + popSizeH + "px; dialogWidth:" + popSizeW + "px; scroll:no;status:no; help:no; edge:sunken";
		        feature = feature + GetShowModalPosition(popSizeW, popSizeH);
		        
		        if (CrossYN()) {
		            mail_user_distributionOwner_cross_dialogArguments[0] = ownerChange_Complete;
		            var OpenWin = window.open(popUrl + param, "", GetOpenWindowfeature(popSizeW, popSizeH));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var rtnValue = window.showModalDialog(popUrl + param, companyId, feature);
		            if (typeof (rtnValue) != "undefined") {}
		            	ownerChange_Complete();
		        }
	        }
	        
	        function ownerChange_Complete(returnVal) {
	        	var id = returnVal.id;
	        	var name = returnVal.name;
	        	
	        	userDl_ownerId_temp = id;
	        	document.getElementById("ownerInput").setAttribute("data-id", id);
	        	document.getElementById("ownerInput").value = name;
	        	
	        	inputOwnerAddress(name, id);
	        }
	        
	        function refuseToApplyDL_onClick() {
	        	var pListViewDL = new ListView();
                pListViewDL.LoadFromID("ListViewUserDlApplyDiv");
                var arrRows = pListViewDL.GetSelectedRows();
                
                if (arrRows.length > 0) {
                	var strId = GetAttribute(arrRows[0], "DATA1");
					
	                var listid = "MsgToList";
	                var getlistview = new ListView();
                    getlistview.LoadFromID(listid);
	                var bFlag = getlistview.ExistRow("data1", strId);
                	
	                if (!bFlag) {
			        	$.ajax({
				        	type : "POST",
				        	url : "/ezEmail/refuseToApplyDL.do",
				        	data : {cn : cn, userId : strId },
				        	success : function(result){	
				        		if (result == "OK") {
				        			alert("<spring:message code='ezEmail.userDL39' />");        			
				        		} else {
				        			alert("<spring:message code='ezEmail.lhm14' />");
				        		}
				        		
				        		userDlApplyList();
				        	},
				        	error : function(error){
				        		alert("<spring:message code='ezEmail.lhm14' />" + error);
				        		xmlDOM = null;
				        	}
			    		});
	                } else {
	                	alert("<spring:message code='ezEmail.userDL41'/>");
	                }
                } else {
                	alert("<spring:message code='ezEmail.userDL30'/>");
                }
	        }   
	        
	        function memberReplaceHTML(orgStr) {
	            var tempStr = new String(orgStr);
	            tempStr = ReplaceText(tempStr, "&", "&amp;");
	            tempStr = ReplaceText(tempStr, "<", "&lt;");
	            tempStr = ReplaceText(tempStr, ">", "&gt;");
	            return tempStr;
	        }
	        
	        
	        function orgJobMasterTabButton_onClick(tabType) { // 조직도(직위, 직책) tabType::1=직위, 2=직책
	        	var tabNum = tabType == 1 ? 6 : 7;
	        	methodForTabAction(tabNum);
		        
	        	selTab = "orgJobMstListView" + tabType;
		        selSpan = "orgJobMstSpan" + tabType;
		        m_selectedTree = orglistView;
	        	
	        	$.each(m_tabDialogState, function(i,d) {
        			var setVal = ("orgJobMst"+tabType) == i ? "select" : "normal";
        			m_tabDialogState[i] = setVal;
        		});
	        	
	            ImageUpdate();
	            
		        ListViewTD.style.display = "none";
		        ListViewINPUT.style.display = "none";
		        ListViewDLTD.style.display = "none";
		        TreeViewTD.style.display = "block";

		        dlmember.style.display = "none";
		        AddrSearch.style.display = "none";
		        $(".txtlist_DeptTD").css("display", "table-cell");
		        
	            clearOrgTab("orgJobMst");
		        orgJobMasterListSet(tabType);
	        }
	        
	        function clearOrgTab(type) { // org or orgJobMst
	        	document.getElementById('TreeView').innerHTML = "";
	        	document.getElementById("SelectDeptNM").innerHTML = "";
                
                var searchSelectObj = document.getElementById('search_type');
                searchSelectObj.setAttribute("data-type", type);
				
                document.getElementById("keyword").value = "";
                issearch = false;
                
                var hide_orgJobMstSearchOpt = [
					{"name":"extensionAttribute10", "usedefault":"1", "msg":"<spring:message code='ezEmail.t281' />"},
                	{"name":"title", "usedefault":"1", "msg":"<spring:message code='ezAddress.t359'/>"},
                    {"name":"description", "usedefault":"1", "msg":"<spring:message code='ezAddress.t54'/>"},
                ];
                
             	// 부서선택 버튼명 변경
                var deptSelectBtnNm = selTab == "orglistView" ? "<spring:message code='ezEmail.t596' />" : selTab == "orgJobMstListView1" 
                		? "<spring:message code='ezOrgan.ksaOrganList04' />" : "<spring:message code='ezOrgan.ksaOrganList05' />";
                $("#dept_select > span").text(deptSelectBtnNm);
                                           
                $.each(hide_orgJobMstSearchOpt, function(i,e) {
                	var searchOpt = $("#search_type option[value='"+e.name+"']");
               		if (type == "org" && searchOpt.length < 1) {
                   		var tempOpt = "<option value="+e.name+" usedefault="+e.usedefault+">"+e.msg+"</option>";
                   		$(tempOpt).insertAfter("#search_type option[value='displayname']");
                   	} else if (type == "orgJobMst") {
                   		searchOpt.remove();
                   	}
                });
	        }
	        
	        function orgJobMasterListSet(type) {
	        	try {
	        		var pType = type == 1 ? "POS" : "TIT";
	        		
	                var xmlpara = createXmlDom();
	                var xmlTree = createXmlDom();
	                var xmlHTTP = createXMLHttpRequest();
	                var objNode;
	                var topID = useShowAllCompanies == "YES" ? "Top/organ" : "Top";
	                
	                createNodeInsert(xmlpara, objNode, "DATA");
	                createNodeAndInsertText(xmlpara, objNode, "COMID", "");
	                createNodeAndInsertText(xmlpara, objNode, "TOPID", topID);
	                createNodeAndInsertText(xmlpara, objNode, "PROP", "mail");
	                createNodeAndInsertText(xmlpara, objNode, "TYPE", pType);
	                
	                xmlHTTP.open("POST", "/ezOrgan/getCompanyJobTreeInfo.do", false);
	                xmlHTTP.send(xmlpara);
	                xmlTree = loadXMLString(xmlHTTP.responseText);
	                var treeXML = loadXMLFile("/xml/common/organtree_config3.xml");

	                var treeView = new TreeView();
	                treeView.SetConfig(treeXML);
	                treeView.SetID("FromTreeView");
	                treeView.SetUseAgency(true);
	                treeView.SetRequestData("orgJobMstCompanyClick"); 
	                treeView.SetNodeClick("orgJobMstClick");
	                treeView.DataSource(xmlTree);
	                treeView.DataBind("TreeView");
	        	}
	            catch (ErrMsg) {
	                alert("TreeViewinitialize : " + ErrMsg.description);
	            }
	        }
	        
	        function orgJobMstClick(i) {
	        	CurPage = "1";
	        	var thisNode = document.getElementById(i);
	        	var thisNode_jobChk = thisNode.getAttribute("isjob");
	        	listContentArry = new Array();
	        
	        	if (thisNode_jobChk != null && thisNode_jobChk) {
	        		orgJobMstUserList();
	        	} else { // company
		        	document.getElementById("SelectDeptNM").innerHTML = "";
	                pListXML_Info = "";
	                DisplayUserImageList();
	        	}
	        }
	        
	        function orgJobMstUserList() {
	        	var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var treeViewSelectNode = treeView.GetSelectNode();
	            
        		var jobId = treeViewSelectNode.GetNodeData("cn");
        		var comId = treeViewSelectNode.GetNodeData("comid");
        		var jobType = treeViewSelectNode.GetNodeData("jobtype");
        		var jobName = treeViewSelectNode.GetNodeData("value");
        		
				$.ajax({
					type : "POST",
					url : "/ezOrgan/getJobMasterMemberList.do",
					dataType : "text",
					data : {
						type : jobType,
						jobID : jobId,
						pageNum : CurPage,
						cell : "company;description;displayName;title;telephoneNumber", 
						prop : "mail;displayName;description;title;company;telephoneNumber;extensionAttribute2;department;userType",
						searchType : "",
						searchValue : "",
						comID : comId
					}, success : function(result) {
						pListXML_Info = loadXMLString(result);
		        		var totalCnt = pListXML_Info.getElementsByTagName("TOTALCOUNT")[0].textContent;
		        		
						document.getElementById("SelectDeptNM").innerHTML 
							= "<img src=\"/images/OrganTree_cross/ic-open.gif\" style=\"padding-right:3px; \" >"
			            	+ "<span id='spn_deptName' title='" + jobName + "'>" + jobName + "</span>"
			            	+ "<span id='countInfo'>&nbsp;<span class='txt_color'> " + totalCnt + "</span></span>";
						
		                pSeach = false;
		                DisplayUserImageList();
					}, error : function (error) {
						alert("error : " + error);
					}
				});
	        }
	        function orgJobMstCompanyClick(pNodeID, pTreeID) {
				var TreeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	            var deptID = treeNode.GetNodeData("CN");
	            GetCompanySubTreeInfo(deptID, TreeIdx);
	        }
	        
	        function GetCompanySubTreeInfo(comID, TreeIdx) {
	        	var jobMstType = (selTab == "orgJobMstListView1") ? "POS" : "TIT";
	        	
	            var xmlHTTP = createXMLHttpRequest();
	            var xmlRtn = createXmlDom();
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "DATA");
	            createNodeAndInsertText(xmlpara, objNode, "COMID", comID);
	            createNodeAndInsertText(xmlpara, objNode, "TYPE", jobMstType);
	            xmlHTTP.open("POST", "/ezOrgan/getJobMasterTreeInfo.do", false);
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
		        <NAME>EMAIL</NAME>
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
	    <xml id="listviewheader4" style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t31' /></NAME>
		        <WIDTH>60</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.t712' /></NAME>
		        <WIDTH>65</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME>Email</NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<form method="post">
		         <div id="menu">
		            <ul>
		                <li><span onclick="OK_Click()"><spring:message code='ezEmail.t48' /></span></li>
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
		                <td <c:if test="${userDL ne ''}">colspan='3'</c:if>>
		                    <input name="TextName" type="text" id="TextName" maxlength="24" class="txtClass" style="width:100%;" value="<c:out value='${textName}'/>">
		                </td>
		            </tr>
		            <tr>
		                <th><spring:message code='ezEmail.lhm09' /></th>
		                <td <c:if test="${userDL ne ''}">colspan='3'</c:if>>
		                    <input name="TextId" type="text" id="TextId" maxlength="20" class="txtClass" style="width:40%;" value="${cn}">
		                    <span id="mailDomain" style="width:60%; font-weight: bold; display:none;">@${mailDomain}</span>
							<c:if test="${cn eq ''}">
								<span style="font-weight: bold; ">@</span>
								<select id="selectDomain" style="width: 220px; ">
									<c:forEach var="item" items="${domainList}">
										<option value="<c:out value='${item}'/>" ${item eq companyMailDomain ? 'selected' : ''}><c:out value='${item}'/></option>
									</c:forEach>
								</select>
							</c:if>
		                </td>
		            </tr>
		            <c:if test="${cn ne ''}">
			            <tr>
			            	<th><spring:message code='main.t78' /></th>
							<td <c:if test="${userDL eq 'modify'}">style="width:65%" </c:if>>
								${distributionMail}
							</td>	
							<c:if test="${userDL eq 'modify'}">
								<th style="width:10%; "><spring:message code='ezEmail.userDL25' /></th>
			            		<td>
			            			<input id="ownerInput" class="us" type="text" data-id="<c:out value='${ownerId}'/>" value="<c:out value='${ownerName}'/>" style="width: 75%;" disabled/>
									<a class="imgbtn" style="margin: 0; float: right;"><span onClick="ownerChange()"><spring:message code='ezEmail.userDL11' /></span></a>
			            		</td>
							</c:if>
			            </tr>
		            </c:if>
		            <c:if test="${userDL ne ''}">
		            	<tr id="userDLInput">
		            		<th><spring:message code='ezEmail.userDL20' /></th>
		            		<td style="width:65%;">
		            			<label>
			            			<input type="radio" name="policy" value="all" checked/>
									<span><spring:message code='ezEmail.userDL21' /></span>	            			
		            			</label>
		            			<label>
			            			<input type="radio" name="policy" value="member" />
									<span><spring:message code='ezEmail.userDL22' /></span>	            			
		            			</label>
		            			<label>
			            			<input type="radio" name="policy" value="private" />
									<span><spring:message code='ezEmail.userDL23' /></span>	            			
		            			</label>
		            		</td>
		            		<th style="width:10%; "><spring:message code='ezEmail.userDL05' /></th>
		            		<td>
		            			<label>
		            				<input type="checkBox" name="endDateCheckBox" onClick="endDateCheckBox_Click(this)" checked />
									<span><spring:message code='ezEmail.userDL24' /></span>	            			
		            			</label>
								<input type="text" name="endDate" id="Sdatepicker" style="width:80px;text-align:center" readonly>
		            		</td>
		            	</tr> 
		            	<tr>
		            		<th><spring:message code='ezEmail.userDL04' /></th>
		            		<td colspan='3'>
		            			<input type="text" name="explain" maxlength="65" style="width:100%;" value="<c:out value='${explain}'/>"/>
		            		</td>
		            	</tr>
		            </c:if>
		        </table>
				<div class="portlet_tabpart01" style="margin:0px;">
					<div class="portlet_tabpart01_top" id="tab1" style="margin-bottom:3px; margin-top:5px;">
						<p id="orgTabButton">
							<span id="orgSpan" onclick="orgTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.t591' /></span>
						</p>
						<p id="orgJobMasterTabButton1">
							<span id="orgJobMstSpan1" onclick="orgJobMasterTabButton_onClick(1)" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezOrgan.ksaOrganList01' /></span>
						</p>
						<p id="orgJobMasterTabButton2">
							<span id="orgJobMstSpan2" onclick="orgJobMasterTabButton_onClick(2)" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezOrgan.ksaOrganList02' /></span>
						</p>
						<p id="contactTabButton">
							<span id="contactSpan" onclick="contactTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.t592' /></span>
						</p>
						<p id="dlTabButton">
							<span id="dlSpan" onclick="dlTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.t593' /></span>
						</p>
						<p id="inputTabButton">
							<span id="inputSpan" onclick="inputTabButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.t244' /></span>
					</p>
						<c:if test="${userDL eq 'modify'}">
						<p id="userDlApplyButton">
							<span id="userDlSpan" onclick="userDlApplyButton_onClick()" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezEmail.userDL12' /></span>
						</p>
						</c:if>
					</div>
				</div>
		    <table style="width:100%;margin-top:10px">
		        <tr>
		            <td style="vertical-align: top;">
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
		                                                	<td style="width: 110px; color:#333; font-weight: bold;" class="td_gray txtlist_DeptTD"><spring:message code='ezAddress.t54' /></td>
		                                                    <td style="width: 100px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t31' /></td>
		                                                    <td style="width: 120px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t28' /></td>
		                                                    <td class="td_gray" style="font-weight: bold;"><spring:message code='ezEmail.t99000045' /></td>
		                                                </tr>
		                                            </table>
		                                            <table style="width: 100%; border: 1px solid #ddd; display: none;" id="Search_txtlist_table" class="mainlist">
		                                                <tr>
		                                                    <td style="width: 110px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t26' /></td>
		                                                    <td style="width: 90px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t31' /></td>
		                                                    <td style="width: 130px; font-weight: bold;" class="td_gray"><spring:message code='ezEmail.t28' /></td>
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
		                <table id="ListViewTD" style="display: none">
		                    <tr>
		                        <td colspan="3">
		                            <table style="width: 100%;">
		                                <tr>
		                                    <td id="AddrSearch">
		                                        <div class="" style="background-color: #f8f8fa; margin: 0px; padding: 0px; border: 1px solid #eaeaea; margin-top:4px">
		                                            <div class="portlet_tabpart03_top" id="Div1" style="border-bottom: 0px; height:26px;">
		                                                <table style="margin-top: 4px; width: 100%;">
		                                                    <tr>
		                                                        <td>
		                                                            <div style="margin-left: 5px;">
		                                                                <select name="search_case" id="search_case" style="padding-right:28px;">
		                                                                    <option value="S_NAME">
		                                                                        <spring:message code='ezEmail.t31' /></option>
		                                                                    <option value="S_COMPANY">
		                                                                        <spring:message code='ezEmail.t712' /></option>
		                                                                    <option value="S_EMAIL">
		                                                                        <spring:message code='ezEmail.t713' /></option>
		                                                                </select>
		                                                                <input id="search_text" value="" onkeyup="AddrSearch_press()" style="width: 130px; margin: 0px; height:21px" name="Input">
		                                                                <a class="imgbtn">
		                                                                    <span onclick="AddrSearch_click()"><spring:message code='ezEmail.t37' /></span>
		                                                                </a>
		                                                            </div>
		                                                        </td>
		                                                        <td>
		                                                            <div style="float: right; margin-right: 5px;">
		                                                                <a class="imgbtn"><span onclick="groupmember_click()"><spring:message code='ezEmail.t598' /></span></a>
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
		                    <tr>
		                        <td>
		                            <div id="AddressTreeView" style="overflow-x: auto; overflow-y: auto; width: 221px; height: 452px; border: 1px solid #ddd; background-color: #FFFFFF; margin-top: 3px;padding-top:5px;border-right:0px;"></div>
		                        </td>
		                        <td></td>
		                        <td style="vertical-align: top;">
		                            <div style="margin-top: 3px; vertical-align: middle; border: 1px solid #ddd; border-bottom: 0px; height: 23px; padding-top: 7px; padding-left: 5px;">
		                                <img align="absmiddle" hspace="2" style="cursor: pointer; margin-right:0px;" />
		                                <span id="addressFolderName" style="font-weight: normal;"></span>
		                                -[<span id="addressFolderCnt" class='txt_color'></span>]
		                            </div>
		                            <div id="AddressListView" style="width: 446px; height: 379px; overflow: auto; background-color: #ffffff; border-bottom:0px; border-top: 1px solid #eaeaea"  class="border_gray">
		                            </div>
		                            <div id="tblPageRayer" style="left: 446px; vertical-align: middle; border: 1px solid #ddd; border-top: 0px; width:auto !important"></div>
		                            <div id="tblpage" style="display: none; padding-top: 2px; text-align: center; vertical-align: middle; left: 446px; border: 1px solid #ddd; border-top: 0px; height: 27px;">
		                                <spring:message code='ezEmail.t588' /><span class='txt_color' style="font-weight: bold;" id="totalcount"></span>
		                                <spring:message code='ezEmail.t589' /><span id="td_Previous" onclick="pagemove(-1)"><img src="/images/kr/cm/btn_prev.gif"
		                                    width="15" height="15" align="absmiddle" hspace="2" style="cursor: pointer"></span><spring:message code='ezEmail.t590' /><span
		                                        id="td_pageCount"></span>
		                                <spring:message code='ezEmail.t97' />
		                                <input type="text" id="txt_PageInputNum" name="txt_PageInputNum" onkeyup="pagemove('0')"
		                                    size="4" onselectstart="event.cancelBubble=true;event.returnValue=true" onkeypress="OnlyNumber()"
		                                    style="ime-mode: disabled">
		                                <span id="td_Next" onclick="pagemove('1')">
		                                    <img src="/images/kr/cm/btn_next.gif" width="15" height="15" align="absmiddle" hspace="2" style="cursor: pointer" />
		                                </span>
		                            </div>
		                        </td>
		                    </tr>
	                	</table>
		                <table id="ListViewDLTD" style="display: none">
		                    <tr>
		                        <td>
		                            <div class="" style="background-color: #f8f8f8; margin-top: 4px;">
		                                <div class="portlet_tabpart03_top" id="Div2" style="border: 1px solid #eaeaea;">
		                                    <table style="margin-top: 3px; width: 100%;">
		                                        <tr>
		                                            <td id="dlmember" style="display: none">
		                                                <a class="imgbtn" style="float: right; margin-right: 5px;"><span onclick="dlmember_click()">
		                                                    <spring:message code='ezEmail.t598' /></span></a>
		                                            </td>
		                                        </tr>
		                                    </table>
		                                </div>
		                            </div>
		                            <div style="width: 668px; height: 457px; overflow: auto; background-color: #ffffff; margin-top: 3px;" id="ListViewDL" class="border_gray">
		                            </div>
		                        </td>
		                    </tr>
		                </table>
		                <table id="ListViewINPUT" style="display: none">
		                    <tr>
		                        <td>
		                             <div id="ManualView" style="width: 648px; height: 472px; padding: 10px; border-right: 1px solid #ddd; margin-top: 4px;" class="box">
	                        		 	<table class="content">
	                            			<tr>
	                                			<th><spring:message code='ezEmail.t31' /></th>
	                                			<td>
	                                    			<input type="text" id="emailname" style="width: 100%;" maxlength="24">
	                                			</td>
	                            			</tr>
	                            			<tr>
		                                		<th><spring:message code='ezEmail.t35' /></th>
		                                		<td>
		                                    		<input type="text" id="emailaddr" style="width: 100%;" maxlength="100" onkeypress="return on_keydown(event)">
		                                		</td>
	                            			</tr>
	                        			</table>
	                        			<div style="text-align: center">
	                        				<div class="btnpositionJsp">
	                        					<a class="imgbtn">
	                        						<span onclick="inputAddress()">
	                        							<spring:message code='ezAddress.t173' />
	                        						</span>
	                        					</a>
	                        				</div>	
	                        			</div>
	                    			</div>
		                        </td>
		                    </tr>
		                </table>
		                <table id="ListViewUserDlApply" style="display: none">
		                    <tr>
		                        <td>
		                        	<div class="" style="background-color: #f8f8f8; margin-top: 4px;">
		                                <div class="portlet_tabpart03_top" id="tab5" style="border: 1px solid #eaeaea;">
		                                    <table style="margin-top: 3px; width: 100%;">
		                                        <tr>
		                                            <td id="userDlMenu01" style="">
		                                                <a class="imgbtn" style="float: right; margin-right: 5px;"><span onclick="refuseToApplyDL_onClick()">
		                                                    	<spring:message code='ezEmail.userDL28' /></span></a>
		                                            </td>
		                                        </tr>
		                                    </table>
		                                </div>
		                            </div>
		                        
		                            <div style="width: 668px; height: 457px; overflow: auto; background-color: #ffffff; margin-top: 3px;" id="" class="border_gray">
		                            	<table class="mainlist" style="width: 100%">
											<thead>
												<tr>
													<th><spring:message code='main.t76'/></th>
													<th><spring:message code='main.t78'/></th>
													<th><spring:message code='main.t75'/></th>
													<th><spring:message code='ezEmail.userDL15' /></th>
												</tr>
											</thead>		                            	
		                            	</table>
		                            	<div style="height: 425px; overflow-y: auto;">
			                            	<table class="mainlist" id="ListViewUserDlApplyDiv" style="width: 100%"></table>
		                            	</div>
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
		                                <span style="min-width: 45px; padding-right:5px;" id="ToTitleStr"><spring:message code='ezEmail.t659' /></span>
		                                <span style="min-width:0; padding:0;" class="toTitleCnt" ><b></b> <spring:message code='main.t20000' /></span>
		                            </h2>
		                            <div class="receiver_borderbox">
		                                <div id="ListViewMsgTo" ondragover ="onDragEnter(event, this)" ondrop ="onDrop(event, this)" style="width: 250px; Height:464px; overflow: auto;" ondblclick="DeleteReceiver(ListViewMsgTo)"></div>
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
