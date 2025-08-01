<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/quickLinkListView_list_admin.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<script type="text/javascript">
			var m_orgImg = { "normal": "/images/tab_org1.gif", "select": "/images/tab_org.gif" };
	        var m_dlImg = { "normal": "/images/tab_dl1.gif", "select": "/images/tab_dl.gif" };
	        var m_contactImg = { "normal": "/images/tab_addr1.gif", "select": "/images/tab_addr.gif" };
	        var m_tabDialogState = { "org": "select", "contact": "normal", "dl": "normal" };
	        var m_receiverTitleList;
	        var m_receiverWindowList;
	        var m_titleNoneSelectedColor = "#F6F6F6";
	        var m_titleSelectedColor = "#ffffff";
	        var m_selectedWindow = null;
	        var m_selectedTree = null;
	        var g_fnaddReceiver;
	        var g_xmlHTTP = null;
	        var bSearch = false;
	        var strInitList = "";
	        var topid = "<c:out value = '${topID}' />";
	        var userLang = "<c:out value = '${strUserLang}' />";
	        var strAddJob = "<spring:message code='ezOrgan.psb03'/> ";
	        var ReturnFunction;
	        var RetValue;
			var CurPage = 1;
			var Tab1_SelectID = "1tab1";
			var type = "new";
			// 설정된 권한목록
			var quickLinkAuths = new Array();
	        
	        $(document).ready(function () {
	            try{
	                RetValue = parent.selecttarget_dialogArguments[0];
	                ReturnFunction = parent.selecttarget_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.selecttarget_dialogArguments[0];
	                    ReturnFunction = opener.selecttarget_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	
	            m_receiverTitleList = new Array(ToTitle);
	            m_receiverWindowList = new Array(ListViewMsgTo);
	
	            var listview = new ListView();
	            listview.SetID("ListViewMsgToView");
	            listview.SetMulSelectable(false);
	            listview.SetRowOnClick("SelectReceiverWindow");
	            listview.SetRowOnDblClick("DeleteReceiver");
	            listview.DataSource(loadXMLString(listviewheader.innerHTML.toUpperCase()));
	            listview.DataBind("ListViewMsgTo");
	            initUserList();
	
	            var listview5 = new ListView();
	            listview5.SetID("OrganList");
	            listview5.SetMulSelectable(false);
	            listview5.SetRowOnDblClick("ListViewNodeDblClick");
	            listview5.DataSource(loadXMLString(listviewheader2.innerHTML.toUpperCase()));
	            listview5.DataBind("OrganListView");
	
 	            //applyCurrentData();
	
	            g_xmlHTTP = createXMLHttpRequest();
	            var strQuery = "<DATA><DEPTID>${userInfo.deptID}</DEPTID><TOPID>" + topid + "</TOPID><PROP>mail;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
	            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
	            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
	            g_xmlHTTP.send(strQuery);
	            
	            m_selectedTree = TreeView;
	            SelectReceiverWindow(ToTitle, ListViewMsgTo);
	        });
	        
		    function event_getDeptFullTree() {
		        if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
		            if (g_xmlHTTP.status == 200) {
		                if (!bSearch) {
		                    try {
		                        RetValue["window"].opener.top.organview = getXmlString(g_xmlHTTP.responseXML);
		                    } catch (e) { }
		                }
		
		                var xmlDom = loadXMLFile("/xml/common/organtree_config3.xml");
		                document.getElementById('TreeView').innerHTML = "";
		
		                var treeView = new TreeView();
		                treeView.SetID("TreeViewList");
		                treeView.SetConfig(xmlDom);
		                treeView.SetNodeClick("TreeViewNodeClick");
		                treeView.SetRequestData("RequestData");
		                treeView.DataSource(g_xmlHTTP.responseXML);
		                treeView.DataBind("TreeView");
		            } else {
		                alert("<spring:message code = 'ezPersonal.t17' />" + g_xmlHTTP.status);
		                g_xmlHTTP = null;
		            }
		        }
		    }
		    
	        function initUserList() {
	            if (RetValue != "" && RetValue != null) {
	                var listView = new ListView();
	                listView.LoadFromID("ListViewMsgToView");
	
	                var totalRows = listView.GetDataRows();
	                var totalLen = totalRows.length;
					accessName = RetValue["accessName"];
					accessName2 = RetValue["accessName2"];
					accessId = RetValue["accessId"];
					accessYN = RetValue["accessYN"];
					subdeptPermitted = RetValue["subdeptPermitted"];
					userType = RetValue["userType"];
	                
	                for (var i = 0; i < accessId.length; i++) {
						var ACCESSNAME = accessName[i];
						var ACCESSNAME2 = accessName2[i];
						var ACCESSID = accessId[i];
						var ACCESSYN = accessYN[i];
						var SUBDEPTPERMITTED = subdeptPermitted[i];
						var USERTYPE = userType[i];

						var quickLinkAuth = {
							"userId": accessId[i],
							"accessYN": accessYN[i],
							"userName": accessName[i],
							"userName2": accessName2[i],
							"userType": userType[i],
							"subdeptPermitted": subdeptPermitted[i]
						};
						quickLinkAuths.push(quickLinkAuth);

						/*
	                    var ACCESSNAME = dialogArgData1[i];
	                    var ACCESSNAME2 = dialogArgData2[i];
	                    var ACCESSID = dialogArgData3[i];
	                    var PERMISSIONS = dialogArgData5[i];

	                    pparsingXML2 = "";
	                    pparsingXML = "";
	                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
	                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + ACCESSID + "</DATA1>";
	                    pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(ACCESSNAME) + "</DATA2>";
	                    pparsingXML = pparsingXML + "<DATA3>" + MakeXMLString(ACCESSNAME2) + "</DATA3>";
	                    pparsingXML = pparsingXML + "<DATA5>" + PERMISSIONS + "</DATA5>";

	                    if (userLang == "") {
	                        pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(ACCESSNAME) + "</VALUE>";
	                    } else {
	                        pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(ACCESSNAME2) + "</VALUE>";
	                    }

	                    pparsingXML = pparsingXML + "</CELL>";
	                    pparsingXML = pparsingXML + "<CELL><VALUE>" + PERMISSIONS + "</VALUE></CELL></ROW>";
	                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";

	                    Resultxml = loadXMLString(pparsingXML2);

	                    var listview = new ListView();
	                    listview.LoadFromID("ListViewMsgToView");

	                    var MaxID = 0;
	                    var InitTr = listview.GetDataRows();

	                    for (var j = 0  ; j < InitTr.length  ; j++) {
	                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
	                        if (MaxID < curnum)
	                            MaxID = curnum;
	                    }
	                    var objTr = listview.AddRow(MaxID);
	                    SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxID).substring(0, listview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1) + eval(MaxID + 1));
	                    listview.AddDataRow(objTr, Resultxml);

						 */

	                }
					/*
	                var listview2 = new ListView();
	                listview2.LoadFromID("ListViewMsgToView");
	                var InitTr2 = listview2.GetDataRows();

					 */
	
	
	                /* for (var i = 0; i < InitTr2.length; i++) {
	                    if (InitTr2[i].getAttribute("data5") == "N") {
	                        InitTr2[i].childNodes[0].style.color = "red";
	                    }
	                } */
	
	            }
				drawAuths();
	        }

			var drawAuths = function() {
				$( '#ListViewMsgToView > tbody').empty();
				quickLinkAuths.forEach(function(item, index) {
					var ACCESSNAME = item.userName;
					var ACCESSNAME2 = item.userName2;
					var ACCESSID = item.userId;
					var ACCESSYN = item.accessYN;
					var SUBDEPTPERMITTED = item.subdeptPermitted;
					var USERTYPE = item.userType;

					pparsingXML2 = "";
					pparsingXML = "";
					pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
					pparsingXML = pparsingXML + "<ROW><CELL><DATA>" + escapeHtml(ACCESSNAME) + "</DATA>";
					pparsingXML = pparsingXML + "<DATA1>" + escapeHtml(ACCESSNAME2) + "</DATA1>";
					pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(ACCESSID) + "</DATA2>";
					pparsingXML = pparsingXML + "<DATA3>" + MakeXMLString(ACCESSYN) + "</DATA3>";
					pparsingXML = pparsingXML + "<DATA4>" + MakeXMLString(USERTYPE) + "</DATA4>";
					pparsingXML = pparsingXML + "<DATA5>" + MakeXMLString(SUBDEPTPERMITTED) + "</DATA5>";

					pparsingXML = pparsingXML + "<VALUE>";
					if (item.userType == "USER") {
					} else if(item.userType == "DEPT") {
						pparsingXML +=  "<spring:message code='ezBoard.t9'/>" + " : ";
					} else if (item.userType == "JIKWI"){
						pparsingXML += "<spring:message code='ezEmail.t28'/>" + " : ";
					} else if (item.userType == "JIKCHEK") {
						pparsingXML += "<spring:message code='ezEmail.t281'/>" + " : ";
					} else if (item.userType == "GROUP") {
						pparsingXML += "<spring:message code='ezPersonal.yej05'/>" + " : ";
					}

					if (userLang == "") {
						pparsingXML = pparsingXML + escapeHtml(ACCESSNAME) + "</VALUE>";
					} else {
						pparsingXML = pparsingXML + escapeHtml(ACCESSNAME2) + "</VALUE>";
					}

					pparsingXML = pparsingXML + "</CELL>";
					pparsingXML = pparsingXML + "<CELL><VALUE>" + ACCESSYN + "</VALUE></CELL></ROW>";
					pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";

					Resultxml = loadXMLString(pparsingXML2);

					var listview = new ListView();
					listview.LoadFromID("ListViewMsgToView");

					var MaxID = 0;
					var InitTr = listview.GetDataRows();

					for (var j = 0  ; j < InitTr.length  ; j++) {
						var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
						if (MaxID < curnum)
							MaxID = curnum;
					}
					var objTr = listview.AddRow(MaxID);
					SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxID).substring(0, listview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1) + eval(MaxID + 1));
					listview.AddDataRow(objTr, Resultxml);


				});
				var listview2 = new ListView();
				listview2.LoadFromID("ListViewMsgToView");
				var InitTr2 = listview2.GetDataRows();
			}

			function applyReceiver() {
				var selId = "";

				if (Tab1_SelectID === "1tab1") {
					selId = $("#txtlist_Layer").find(".selectTR");
					var isUser = true;

					if (selId.length == 0) {
						isUser = false;
					}

					if (isUser) {
						setAuthorViewUser("user");
					} else {
						setAuthorViewUser("dept");
					}
				} else if (Tab1_SelectID === "1tab2") {
					selId = $("#pListViewJikwi_TBODY").find(".selectTR");

					if (selId.length != 0) {
						setAuthorViewUser("jikwi");
					}
				} else if (Tab1_SelectID === "1tab3") {
					selId = $("#pListViewJikchek_TBODY").find(".selectTR");

					if (selId.length != 0) {
						setAuthorViewUser("jikchek");
					}
				} else if (Tab1_SelectID === "1tab4") {
					selId = $("#pListViewGroup_TBODY").find(".selectTR");

					if (selId.length != 0) {
						setAuthorViewUser("group");
					}
				}
			}

	        function applyCurrentData() {
	            var xmldoc = loadXMLString(RetValue["selectTargetListXML"]);
	            var i = 0;
	            var username;
	        	var username2;
				var useremail;

	        	for (i = 0; i < GetElementsByTagName(xmldoc, "CN").length; i++) {
		            if (CrossYN()) {
		                username = GetElementsByTagName(xmldoc, "NAME")[i].textContent;
		                username2 = GetElementsByTagName(xmldoc, "NAME2")[i].textContent;
		                useremail = GetElementsByTagName(xmldoc, "CN")[i].textContent;
		            } else {
		                username = GetElementsByTagName(xmldoc, "NAME")[i].text;
		                username2 = GetElementsByTagName(xmldoc, "NAME2")[i].text;
		                useremail = GetElementsByTagName(xmldoc, "CN")[i].text; 
		            }
		            
		            pparsingXML2 = "";
		            pparsingXML = "";
		            pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		            pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + useremail + "</DATA1>";
		            pparsingXML = pparsingXML + "<DATA2>" + username + "</DATA2>";
		            pparsingXML = pparsingXML + "<DATA3>" + username2 + "</DATA3>";
		            
		            if (userLang == "") {
		                pparsingXML = pparsingXML + "<VALUE>" + username + "</VALUE>";
		            } else {
		                pparsingXML = pparsingXML + "<VALUE>" + username2 + "</VALUE>";
		            }
		            
		            pparsingXML = pparsingXML + "</CELL></ROW>";
		            pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
		
		            Resultxml = loadXMLString(pparsingXML2);
		
		            var listview = new ListView();
		            listview.LoadFromID("ListViewMsgToView");
		
		            var MaxID = 0;
		            var InitTr = listview.GetDataRows();
		
		            for (var j = 0  ; j < InitTr.length  ; j++) {
		                var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
		                
		                if (MaxID < curnum) {
		                    MaxID = curnum;
		                }
		            }
		            
		            var objTr = listview.AddRow(MaxID);
		            SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxID).substring(0, listview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1) + eval(MaxID + 1));
		            listview.AddDataRow(objTr, Resultxml);
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
		
		        var strQuery = "<DATA><DEPTID>" + deptID + "</DEPTID><PROP>mail;displayName</PROP></DATA>";
		        xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
		        xmlHTTP.send(strQuery);
		
		        xmlRtn = loadXMLString(xmlHTTP.responseText);
		
		        var treeView = new TreeView();
		        treeView.LoadFromID("TreeViewList");
		        treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
		    }
	
		    function MakeXMLString(str) {
		        str = ReplaceText(str, "&", "&amp;");
		        str = ReplaceText(str, "<", "&lt;");
		        str = ReplaceText(str, ">", "&gt;");
		        return str;
		    }
	
		    function confirm_onClick() {
		        var listview = new ListView();
		        listview.LoadFromID("ListViewMsgToView");
		        var listviewSelected = listview.GetDataRows();
		        var selectTargetListXML = "<NODES>";

				quickLinkAuths.forEach(function(item, index) {
		            selectTargetListXML += "<NODE>";
		            selectTargetListXML += "<ACCESSID>" + item.userId + "</ACCESSID>";
		            selectTargetListXML += "<ACCESSNAME>" + escapeHtml(item.userName) + "</ACCESSNAME>";
		            selectTargetListXML += "<ACCESSNAME2>" + escapeHtml(item.userName2) + "</ACCESSNAME2>";
		            selectTargetListXML += "<USERTYPE>" + item.userType + "</USERTYPE>";
		            selectTargetListXML += "<PERMISSIONS>" + item.accessYN + "</PERMISSIONS>";
		            selectTargetListXML += "<SUBDEPTPERMITTED>" + item.subdeptPermitted + "</SUBDEPTPERMITTED>";
		            selectTargetListXML += "</NODE>";
		        });
		        
		        selectTargetListXML += "</NODES>";
		        
		        if(ReturnFunction != null) {
		            ReturnFunction(selectTargetListXML);
		        } else {
		            window.returnValue = selectTargetListXML;
		        }
		        window.close();
		    }
	
		    function InsertReceiver(pListView) {
		        /* admin_OK.checked = true;
		        admin_NO.checked = false; */
		        if (m_selectedTree == TreeView) {
		            var pListViewDL = new ListView();      //// ListView 선언
		            pListViewDL.LoadFromID("OrganList");
		
		            var arrRows = pListViewDL.GetSelectedRows();
		
		            if (arrRows.length > 0) {
		                var getlistview = new ListView();
		                getlistview.LoadFromID("ListViewMsgToView");
		                var existId = GetAttribute(arrRows[0], "data2");
		                var existName = GetAttribute(arrRows[0], "data8");
		                var strDeptNM = GetAttribute(arrRows[0], "data9");
		                var existName2 = GetAttribute(arrRows[0], "data10");
		                var strDeptNM2 = GetAttribute(arrRows[0], "data11");
		                var bFlag = getlistview.ExistRow("DATA1", existId);
		                if (bFlag) {
		                    alert("<spring:message code = 'ezPersonal.t354' />");
		                    pAddFlag = true;
		                    return;
		                }
		                else {
		                    pparsingXML2 = "";
		                    pparsingXML = "";
		                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + existId + "</DATA1>";
		                    pparsingXML = pparsingXML + "<DATA2>" + existName + "(" + MakeXMLString(strDeptNM.trim()) + ")" + "</DATA2>";
		                    pparsingXML = pparsingXML + "<DATA3>" + existName2 + "(" + MakeXMLString(strDeptNM2.trim()) + ")" + "</DATA3>";
		                    pparsingXML = pparsingXML + "<DATA5>" + "Y" + "</DATA5>";
		
		
		                    if (userLang == "")
		                        pparsingXML = pparsingXML + "<VALUE>" + existName + "(" + MakeXMLString(strDeptNM.trim()) + ")" + "</VALUE>";
		                    else
		                        pparsingXML = pparsingXML + "<VALUE>" + existName2 + "(" + MakeXMLString(strDeptNM2.trim()) + ")" + "</VALUE>";
		                    pparsingXML = pparsingXML + "</CELL>";
		                    pparsingXML = pparsingXML + "<CELL><VALUE>" + "Y" + "</VALUE></CELL></ROW>";
		                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
		
		                    Resultxml = loadXMLString(pparsingXML2);
		
		                    var listview = new ListView();
		                    listview.LoadFromID("ListViewMsgToView");
		
		                    var MaxID = 0;
		                    var InitTr = listview.GetDataRows();
		
		                    for (var j = 0  ; j < InitTr.length  ; j++) {
		                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
		                        if (MaxID < curnum)
		                            MaxID = curnum;
		                    }
		                    var objTr = listview.NewAddRow(0, "ListViewMsgToView" + "_TR_" + eval(MaxID + 1));
		                    listview.AddDataRow(objTr, Resultxml);
		                    listview.SetSelectedIndex(MaxID + 1);
		                    //var objTr = listview.AddRow(0, "ListViewMsgToView" + "_TR_" + eval(MaxID + 1));
		                    //listview.AddDataRow(objTr, Resultxml);
		                    //listview.SetSelectedIndex(MaxID + 1);
		                }
		            }
		            else {
		                var organTree = new TreeView();
		                organTree.LoadFromID("TreeViewList");
		
		                var nodeIdx = organTree.GetSelectNode();
		                var strCN = nodeIdx.GetNodeData("CN");
		                var pparsingXML = "";
		                var getlistview = new ListView();
		                getlistview.LoadFromID("ListViewMsgToView");
		                var bFlag = getlistview.ExistRow("DATA1", strCN);
		
		                if (bFlag) {
		                    alert("<spring:message code = 'ezPersonal.t354' />");
		                    return;
		                }
		                else {
		                    pparsingXML2 = "";
		                    pparsingXML = "";
		                    pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
		                    pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + nodeIdx.GetNodeData("CN") + "</DATA1>";
		                    pparsingXML = pparsingXML + "<DATA2>" + MakeXMLString(nodeIdx.GetNodeData("DISPLAYNAME")) + "</DATA2>";
		                    pparsingXML = pparsingXML + "<DATA3>" + MakeXMLString(nodeIdx.GetNodeData("DISPLAYNAME2")) + "</DATA3>";
		                    pparsingXML = pparsingXML + "<DATA5>" + "Y" + "</DATA5>";
		
		                    if (userLang == "")
		                        pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(nodeIdx.GetNodeData("DISPLAYNAME")) + "</VALUE>";
		                    else
		                        pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(nodeIdx.GetNodeData("DISPLAYNAME2")) + "</VALUE>";
		                    pparsingXML = pparsingXML + "</CELL>";
		                    pparsingXML = pparsingXML + "<CELL><VALUE>" + "Y" + "</VALUE></CELL></ROW>";
		                    pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
		                    Resultxml = loadXMLString(pparsingXML2);
		
		                    Resultxml = loadXMLString(pparsingXML);
		
		                    var listview = new ListView();
		                    listview.LoadFromID("ListViewMsgToView");
		
		                    var MaxID = 0;
		                    var InitTr = listview.GetDataRows();
		
		                    for (var j = 0  ; j < InitTr.length  ; j++) {
		                        var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
		                        if (MaxID < curnum)
		                            MaxID = curnum;
		                    }
		                    
		                    var objTr = listview.NewAddRow(0, "ListViewMsgToView" + "_TR_" + eval(MaxID + 1));
		                    listview.AddDataRow(objTr, Resultxml);
		                    listview.SetSelectedIndex(MaxID + 1);
		                }
		            }
		        }
		    }
		
		    function DeleteReceiver(pListView) {
		        var listView = new ListView();
		        listView.LoadFromID("ListViewMsgToView");
		        // listView.DeleteRow(listView.GetSelectedRows()[0].id);
				if(listView.GetSelectedRows()[0] == null) {
					return;
				}
				var selectedAuthId = listView.GetSelectedRows()[0].getAttribute("data2");
				quickLinkAuths.some(function(item, index) {
					if (item.userId === selectedAuthId) {
						quickLinkAuths.splice(index, 1);
					}
				});

				drawAuths();
		    }
		    
		    function switchOnAndOff(e) {
		    	var switchOn = e.target.checked;
		    	var checkFlag = "Y";
		    	
		    	if (switchOn) {
		    		checkFlag = "Y";
		    	} else {
		    		checkFlag = "N";
		    	}
		
		        var pListViewDL = new ListView();
		        pListViewDL.LoadFromID("ListViewMsgToView");
		        var arrRows = pListViewDL.GetSelectedRows();
		        if (arrRows == "") return;
		        SetAttribute(arrRows[0], "DATA3", checkFlag);

				var userId = GetAttribute(arrRows[0], "DATA2");
				quickLinkAuths.forEach(function(item, index) {
					if (item.userId == userId) {
						quickLinkAuths[index].accessYN = checkFlag;
					}
				});

		        /* if (checkFlag == "N") {
		            if (CrossYN())
		                SetAttribute(arrRows[0].childNodes[0], "style", "color:red;");
		            else
		                arrRows[0].childNodes[0].style.color = "red";
		        }
		        else {
		            if (CrossYN())
		                SetAttribute(arrRows[0].childNodes[0], "style", "color:;");
		            else
		                arrRows[0].childNodes[0].style.color = "";
		        } */
		    }
		    
		    function checkbox_onclick(e) {
		        if (window.ActiveXObject)
		            srcElementID = window.event.srcElement.id;
		        else
		            srcElementID = e.target.id;
		
		        var checkFlag = "Y";
		        if (srcElementID == "admin_OK") {
		            admin_OK.checked = true;
		            admin_NO.checked = false;
		            checkFlag = "Y";
		        }
		        else {
		            admin_OK.checked = false;
		            admin_NO.checked = true;
		            checkFlag = "N";
		        }
		
		        var pListViewDL = new ListView();
		        pListViewDL.LoadFromID("ListViewMsgToView");
		        var arrRows = pListViewDL.GetSelectedRows();
		        if (arrRows == "") return;
		        SetAttribute(arrRows[0], "DATA5", checkFlag);

				var userId = GetAttribute(arrRows[0], "DATA2");

				quickLinkAuths.forEach(function(item, index) {
					if (item.userId == userId) {
						quickLinkAuths[index].subdeptPermitted = checkFlag;
					}
				});

		        /* if (checkFlag == "N") {
		            if (CrossYN())
		                SetAttribute(arrRows[0].childNodes[0], "style", "color:red;");
		            else
		                arrRows[0].childNodes[0].style.color = "red";
		        }
		        else {
		            if (CrossYN())
		                SetAttribute(arrRows[0].childNodes[0], "style", "color:;");
		            else
		                arrRows[0].childNodes[0].style.color = "";
		        } */
		    }
		    function SelectReceiverWindow(Title, selectedWindow) {
		        var pListViewDL = new ListView();
		        pListViewDL.LoadFromID("ListViewMsgToView");
		        var arrRows = pListViewDL.GetSelectedRows();
		        if (arrRows.length > 0) {
		            var permissionsFlag = GetAttribute(arrRows[0], "data3");
		            /* if (permissionsFlag == "Y") {
		                admin_OK.checked = true;
		                admin_NO.checked = false;
		            }
		            else {
		                admin_NO.checked = true;
		                admin_OK.checked = false;
		            } */
					if (GetAttribute(arrRows[0], "data4") == "DEPT") {
						document.getElementById("admin_OK").disabled = false;
						document.getElementById("admin_NO").disabled = false;
						var subdeptPermitted = GetAttribute(arrRows[0], "DATA5")

						if (subdeptPermitted == "Y" || subdeptPermitted == "true") {
							document.getElementById("admin_OK").checked = true;
							document.getElementById("admin_NO").checked = false;
						} else {
							document.getElementById("admin_OK").checked = false;
							document.getElementById("admin_NO").checked = true;
							SetAttribute(arrRows[0], "DATA5", "N");
						}
					} else {
						document.getElementById("admin_OK").disabled = true;
						document.getElementById("admin_OK").checked = false;
						document.getElementById("admin_NO").disabled = true;
						document.getElementById("admin_NO").checked = true;
					}
		        }
		
		        for (var count = 0; count < m_receiverTitleList.length; count++) {
		            m_receiverTitleList[count].style.fontWeight = "normal";
		            m_receiverWindowList[count].style.backgroundColor = m_titleNoneSelectedColor;
		            m_receiverWindowList[count].normalColor = m_titleNoneSelectedColor;
		            ChangeRowsColor(m_receiverWindowList[count], m_titleNoneSelectedColor);
		
		        }
		
		        ToTitle.style.fontWeight = "bold";
		        ListViewMsgTo.style.backgroundColor = m_titleSelectedColor;
		        ListViewMsgTo.normalColor = m_titleSelectedColor;
		        ChangeRowsColor(ListViewMsgTo, m_titleSelectedColor);
		        m_selectedWindow = ListViewMsgTo;
		        
		    }
		
		    function TreeViewNodeClick(pNodeID, pTreeID) {
		        var treenode = new TreeNode();
		        treenode.LoadFromID(pNodeID);
		        nodeIdx = treenode.GetNodeData("CN");
		        displayUserList(nodeIdx);
		    }
		
		    function displayUserList(DeptID) {
				setUserList("DEPARTMENT", DeptID);
				/*
		    	$.ajax({
		    		type : 'POST',
		    		url : '/ezOrgan/getDeptMemberList.do',
		    		dataType : "text",
		    		data : {deptID : DeptID,
		    				cell : 'displayName;description;title',
		    				prop : 'mail;displayName;description;title;userType',
		    				type : 'user'},
		    		success : function (result) {
		    			document.getElementById("OrganListView").innerHTML = "";
		                var listview = new ListView();
		                listview.SetID("OrganList");
		                listview.SetSelectFlag(false);
		                listview.SetMulSelectable(false);
		                listview.SetRowOnDblClick("ListViewNodeDblClick");
		                listview.DataSource(loadXMLString($('#listviewheader2').html().toUpperCase()));
		                listview.DataBind("OrganListView");
		                listview.DataSource(loadXMLString(result));
		                listview.RowDataBind();
		    		},
		    		error : function(jqXHR, textStatus, errorThrown) {
		    			alert("<spring:message code = 'ezPersonal.t22' />" + textStatus);
		    		}
		    	});
		    	*/
		    }

			//사원 리스트 뿌리기
			var setUserList = function(key, value, deptName) {
				if(key === undefined || value === undefined || deptName === undefined) {
					key = "DEPARTMENT";
					var organTree = new TreeView();
					organTree.LoadFromID("TreeViewList");
					var nodeIdx = organTree.GetSelectNode();
					value = nodeIdx.GetNodeData("CN");
					deptName = nodeIdx.GetNodeData("DISPLAYNAME");
				}

				var listType = getOrganListType();

				$.ajax({
					type:"post",
					dataType:"html",
					url:"/admin/ezNewPortal/userList.do",
					data:{"key" : key, "value" : value, "deptName" : deptName, "companyId":"<c:out value='${userInfo.companyID}'/>", "listType" : listType, "curPage" : CurPage },
					success: function(result){
						var picList = $(result).find(".organwrap");
						if(picList.length == 0 && key != "DEPARTMENT"){
							alert("<spring:message code='ezCommunity.t1379'/>");
							issearch = false;
						}
						$("#OrganListView").empty();
						$("#OrganListView").html(result);
						/**
						 2018-07-10 페이징 기능 추가.
						 */
						$("#OrganListView").append("<div id='tblPageRayer' style='text-align:center;'></div>");
						totalPage = Math.ceil($("#totalCount").val() / 50 );
						makePageSelPage();
					}
				});
			}

			var BlockSize = 10;
			var td_Create1 = function(strtext) {
				document.getElementById("tblPageRayer").innerHTML = strtext;
			}

			var makePageSelPage = function() {
				var strtext;
				var PagingHTML = "";
				document.getElementById("tblPageRayer").innerHTML = "";
				strtext = "<div class='pagenavi'>";
				PagingHTML += strtext;
				var pageNum = CurPage;
				if (totalPage > 1 && pageNum != 1) {
					strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg first disabled'></span>";
					PagingHTML += strtext;
				}
				if (totalPage > BlockSize) {
					if (pageNum > BlockSize) {
						strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span class='btnimg prev disabled'></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "<span class='btnimg prev disabled'></span>";
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
						strtext = "";
						strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
						PagingHTML += strtext;
					} else {
						strtext = "";
						strtext = strtext + "<span class='btnimg next disabled'></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "";
					strtext = strtext + "<span class='btnimg next disabled'></span>";
					PagingHTML += strtext;
				}
				if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
					strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg last disabled'></span>";
					PagingHTML += strtext;
				}
				PagingHTML += "</div>";
				td_Create1(PagingHTML);
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
				});

				return organListType;
			}

			function ListViewNodeDblClick() {
		        if (m_selectedWindow != null)
		            InsertReceiver(m_selectedWindow);
		    }
		
		    function RemoveEventDblClick(TreeViewNode) {
		        var children;
		        var child;
		        children = TreeViewNode.childNodes;
		        
		        for (var count = 0; count < children.length; count++) {
		            child = children.item(count);
		            child.iconItem.ondblclick = fire_dblClickEvent;
		            child.textItem.ondblclick = fire_dblClickEvent;
		            RemoveEventDblClick(child);
		        }
		    }
		
		    function fire_dblClickEvent() {
		        var selectedNode = window.event.srcElement.parentElement;
		        var currentState = selectedNode.expandState;
		        try {
		            window.event.srcElement.parentElement.expandState = (currentState == 0) ? 1 : 0;
		        } catch (e) { }
		    }
		
		    function ChangeRowsColor(pListView, color) {
		    }
		
		    function search_press() {
		        if (window.event.keyCode == "13")
		            contactTabButton_onClick();
		    }
		    function cnsearch_press() {
		        if (window.event.keyCode == "13")
		            cnsearch_click();
		    }
		
		    function cnsearch_click(pMode) {
		        if (cnkeyword.value == "") {
		            alert("<spring:message code = 'ezPersonal.t23' />");
		            cnkeyword.focus();
		            return;
		        }
		        var count;
		        var adCount = 0;
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDOM = createXmlDom();
		        var objNode;
		
		        createNodeInsert(xmlDOM, objNode, "DATA");
		        createNodeAndInsertText(xmlDOM, objNode, "SEARCH", pMode + "::" + cnkeyword.value);
		        createNodeAndInsertText(xmlDOM, objNode, "CELL", "company;description;title;displayName;mail");
		        createNodeAndInsertText(xmlDOM, objNode, "PROP", "department");
		        createNodeAndInsertText(xmlDOM, objNode, "TYPE", "user");
		
		        try {
		            xmlHTTP.open("POST", "/ezOrgan/getSearchList.do", false);
		            xmlHTTP.send(xmlDOM);
		            if (xmlHTTP.status != 200) {
		                alert("<spring:message code = 'ezPersonal.t24' />" + xmlHTTP.status);
		                xmlDOM = null;
		                xmlHTTP = null;
		            }
		            else {
		                xmlDOM = xmlHTTP.responseXML;
		                adCount = xmlDOM.getElementsByTagName("ROW").length;
		            }
		        } catch (e) {
		            alert("<spring:message code = 'ezPersonal.t24' />" + e.description);
		            xmlDOM = null;
		            xmlHTTP = null;
		        }
		        if (adCount == 0) {
		            alert("<spring:message code = 'ezPersonal.t25' />");
		            return;
		        }
		        else if (adCount == 1) {
		            bSearch = true;
		            g_xmlHTTP = createXMLHttpRequest();
		            if (CrossYN()) {
		                var strQuery = "<DATA><DEPTID>" + GetElementsByTagName(xmlDOM, "DATA3")[0].textContent +
		                        "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		            }
		            else {
		                var strQuery = "<DATA><DEPTID>" + xmlDOM.getElementsByTagName("DATA3").item(0).text +
		                      "</DEPTID><TOPID>Top</TOPID><PROP>mail</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		            }
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		        else {
		            var rgParams = new Array();
		            rgParams["addrBook"] = xmlDOM;
		            rgParams["deptid"] = "";
		            window.showModalDialog("/admin/ezOrgan/checkName2.do", rgParams, "dialogHeight:320px; dialogWidth:600px; status:no;scroll:no; help:no; edge:sunken" + GetShowModalPosition(600, 320));
		
		            if (rgParams["deptid"] != "") {
		                bSearch = true;
		                g_xmlHTTP = createXMLHttpRequest();
		                var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>mail;DisplayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		                g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		                g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		                g_xmlHTTP.send(strQuery);
		            }
		        }
		    }
		
		    function infoview_click() {
		        if (selUserId == null || selUserId == "") {
		            alert("<spring:message code = 'ezCircular.t148' />");
		            return;
		        }
		        // var cn = OrganListView.multiSelects.item(0).cells[0].DATA2;
		        // window.dialogArguments["window"].document.Script.open_userinfo(cn);
				var pheight = window.screen.availHeight;
				var pwidth = window.screen.availWidth;
				var pTop = (pheight - 450) / 2;
				var pLeft = (pwidth - 420) / 2;

				window.open("/ezCommon/showPersonInfo.do?id=" + selUserId + "&dept=" + selDeptId, "", "height=450px,width=420px,  top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		    }
		
		    function dlmember_click() {
		        if (ListViewDL.multiSelects.length < 1) {
		            alert("<spring:message code = 'ezPersonal.t27' />");
		            return;
		        }
		        var rtnValue = { "name": new Array(), "email": new Array() };
		        var count = window.showModalDialog("mail_select_dlmember.aspx?cn=" + ListViewDL.multiSelects.item(0).cells[0].DATA1, rtnValue, "dialogHeight:450px; dialogWidth:601px; status:no;scroll:auto; help:no; edge:sunken" + GetShowModalPosition(601, 450));
		        for (var i = 0; i < count; i++) {
		            var row = m_selectedWindow.rows.add();
		            row.cells[0].innerText = rtnValue["name"][i];
		            row.cells[0].name = rtnValue["name"][i];
		            row.cells[0].href = "";
		            row.cells[0].type = "contact";
		            row.cells[0].email = rtnValue["email"][i];
		            row.cells[1].innerText = rtnValue["email"][i];
		            row.cells[0].parentElement.style.backgroundColor = m_titleSelectedColor;
		        }
		    }

			var mail_select_groupmember_cross_dialogArguments = new Array();
		    function groupmember_click() {
				var selectGroup = document.getElementById("pListViewGroup").querySelector(".selectTR");
				if (selectGroup == null || selectGroup == undefined) {
					alert("<spring:message code = 'ezOrgan.zNo003' />");
					return;
				}
				var groupID = selectGroup.getAttribute("data1");
				mail_select_groupmember_cross_dialogArguments[0] = DivPopUpHidden;
				var companyId = "<c:out value='${userInfo.companyID}'/>";
				DivPopUpShow(601, 470, "/admin/ezOrgan/permissionGroupUserListView.do?groupID=" + groupID + "&companyID=" + companyId);

				/*
		        if (AddressListView.multiSelects.length < 1) {
		            alert("<spring:message code = 'ezPersonal.t28' />");
		            return;
		        }
		        if (AddressListView.multiSelects.item(0).cells[0].DATA2 != "mailgroup") {
		            alert("<spring:message code = 'ezPersonal.t28' />");
		            return;
		        }
		        var rtnValue = { "name": new Array(), "email": new Array() };
		        var count = window.showModalDialog(AddressListView.multiSelects.item(0).cells[0].DATA1.replace("get", "select").replace("/remote", ""), rtnValue, "dialogHeight:450px; dialogWidth:501px; status:no;scroll:auto; help:no; edge:sunken" + GetShowModalPosition(501, 450));
		        for (var i = 0; i < count; i++) {
		            var row = m_selectedWindow.rows.add();
		            row.cells[0].innerText = rtnValue["name"][i];
		            row.cells[0].name = rtnValue["name"][i];
		            row.cells[0].href = "";
		            row.cells[0].type = "contact";
		            row.cells[0].email = rtnValue["email"][i];
		            row.cells[1].innerText = rtnValue["email"][i];
		            row.cells[0].parentElement.style.backgroundColor = m_titleSelectedColor;
		        }
		        */
		    }
		    function dept_select() {
		        var nodeIdx = TreeView.selectedIndex;
		        if (TreeView.selectedIndex > 0) {
		            selname = TreeView.getvalue(nodeIdx, "VALUE");
		            selid = TreeView.getvalue(nodeIdx, "CN");
		        }
		        else {
		            alert("<spring:message code = 'ezPersonal.t29' />");
		            return;
		        }
		        if (selid == "Top") selid = "everyone";
		        if (ReturnFunction != null)
		            ReturnFunction(selid + ";" + selname);
		        else
		            window.returnValue = selid + ";" + selname;
		        window.close();
		    }
		
		    function Save_onclick() {
		        var length = OrganListView.multiSelects.length;
		        var selid = "";
		        var selname = "";
		        if (length == 0) {
		            selname = TreeView.getvalue(TreeView.selectedIndex, "VALUE");
		            selid = TreeView.getvalue(TreeView.selectedIndex, "CN");
		        }
		        else {
		            if (length > 1) {
		                alert("<spring:message code = 'ezPersonal.t34' />");
		                return;
		            }
		            var selRow = OrganListView.multiSelects.item(0);
		            selname = selRow.cells[0].innerText + "(" + selRow.cells[4].innerText + ", " + selRow.cells[1].innerText + ")";
		            selid = selRow.cells[0].DATA2;
		        }
		        if (selid == "Top") selid = "everyone";
		        if (ReturnFunction != null)
		            ReturnFunction(selid + ";" + selname);
		        else
		            window.returnValue = selid + ";" + selname;
		        window.close();
		    }
		    
		    function Cancel_onclick() {
		        window.close();
		    }

			//검색
			function fn_serach(type) {
				var value = $("#keyword").val().trim();
				if (value == '' || value == undefined) {
					alert("<spring:message code='ezSchedule.t8'/>");
				} else {
					search_click(type);
				}
			}

			var issearch = false;
			var searchKey = "";
			function search_click(type) {
				var key = $("#search_type").val();

				if ($("#keyword").val().trim()!= '' && $("#keyword").val().trim() != undefined) {
					searchKey = $("#keyword").val().trim();
				}

				if(searchKey){
					if(type === "search") {
						CurPage = 1;            // 검색을 할 때마다 curPage 초기화
						issearch = true;
					}
					setUserList(key, searchKey);
				} else {
					alert("<spring:message code='ezSchedule.t8'/>")
				}
			}

			// 조직도 사원목록 클릭이벤트 적용
			function setUserAuthorDept(elem) {
				if ($(elem).parent().parent().parent().attr("id") === "txtlist_Layer") {
					$("#txtlist_Layer tr").removeClass("selectTR");
				} else if ($(elem).parent().parent().parent().attr("id") === "DeptUserImgList") {
					$("#DeptUserImgList tr").removeClass("selectTR");
				}

				$(elem).addClass("selectTR");
				selUserId = $(elem).attr("id");
				selUserName = $(elem).attr("name");
				selDeptId = $(elem).attr("deptId");
				//user / dept 구분
			}

			// 선택한 사람을 수신자에 추가
			function setAuthorViewUser(isUser) {
				var receiverId = "";
				var userType = 1;

				if (isUser == undefined) {
					isUser = "user";
				}

				if (isUser == "dept"){
					var organTree = new TreeView();
					organTree.LoadFromID("TreeViewList");
					var nodeIdx = organTree.GetSelectNode();
					receiverId = nodeIdx.GetNodeData("CN");
					// receiverId = receiverId.substring(0, receiverId.lastIndexOf("_anchor"));
					userType = "DEPT";
					userName = nodeIdx.GetNodeData("DISPLAYNAME1");
					userName2 = nodeIdx.GetNodeData("DISPLAYNAME2");
					// userDeptName = $(".jstree-clicked").text();
				} else if (isUser == "jikwi") {
					userType = "JIKWI";
					var selectedElem = document.getElementById("pListViewJikwi_TBODY").querySelector(".selectTR");
					receiverId = selectedElem.getAttribute("data1");
					userName = selectedElem.getAttribute("data3");
					userName2 = selectedElem.getAttribute("data3");
				} else if (isUser == "jikchek") {
					userType = "JIKCHEK";
					var selectedElem = document.getElementById("pListViewJikchek_TBODY").querySelector(".selectTR");
					receiverId = selectedElem.getAttribute("data1");
					userName = selectedElem.getAttribute("data3");
					userName2 = selectedElem.getAttribute("data3");
				} else if (isUser == "group") {
					userType = "GROUP";
					var selectedElem = document.getElementById("pListViewGroup_TBODY").querySelector(".selectTR");
					receiverId = selectedElem.getAttribute("data1");
					userName = selectedElem.getAttribute("data3");
					userName2 = selectedElem.getAttribute("data3");
				} else if (isUser == "user") {
					receiverId = selUserId;
					userType = "USER";
					userName = selUserName;
					userName2 = selUserName;
				}

				var chkFlag = true;
				for(var i = 0; i < quickLinkAuths.length; i++) {
					if (quickLinkAuths[i].userId == receiverId) {
						chkFlag = false;
					}
				}

				if (chkFlag) {
					quickLinkAuths.push({"userId" : receiverId, "accessYN" : "N", "userName" : userName, "userName2" : userName2, "userType" : userType, "subdeptPermitted" : "N"});
				} else {
					alert("<spring:message code='ezJournal.t127'/>");
				}

				drawAuths();
			}

			function Tab1_MouseClick(obj) {
				obj.className = "tabon";
				if (obj.id != Tab1_SelectID) {
					if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null) {
						document.getElementById(Tab1_SelectID).className = "";
					}
					obj.className = "tabon";
					Tab1_SelectID = obj.id;
					ChangeTab(obj);
				}
			}

			function ChangeTab(obj) {
				var pSelectTab = GetAttribute(obj, "tdname");
				curTab = pSelectTab;

				switch (pSelectTab) {
					case "portalOrgan":
						document.getElementById("portalOrgan_content").style.display = "";
						document.getElementById("portalJikwi_content").style.display = "none";
						document.getElementById("portalJikchek_content").style.display = "none";
						document.getElementById("portalGroup_content").style.display = "none";
						break;
					case "portalJikwi":
						document.getElementById("portalOrgan_content").style.display = "none";
						document.getElementById("portalJikwi_content").style.display = "";
						document.getElementById("portalJikchek_content").style.display = "none";
						document.getElementById("portalGroup_content").style.display = "none";
						getTitleList('001');
						break;
					case "portalJikchek":
						document.getElementById("portalOrgan_content").style.display = "none";
						document.getElementById("portalJikwi_content").style.display = "none";
						document.getElementById("portalJikchek_content").style.display = "";
						document.getElementById("portalGroup_content").style.display = "none";
						getTitleList('002');
						break;
					case "portalGroup":
						document.getElementById("portalOrgan_content").style.display = "none";
						document.getElementById("portalJikwi_content").style.display = "none";
						document.getElementById("portalJikchek_content").style.display = "none";
						document.getElementById("portalGroup_content").style.display = "";
						getPermissionGroup();
						break;
				}
				selMainListUserId = "";
				selUserId = "";
			}

			var getTitleList = function(type) {
				var request = new XMLHttpRequest();
				request.open('POST', '/admin/ezNewPortal/getTitleList.do', true);
				request.setRequestHeader('Content-Type', 'application/json');

				request.onload = function() {
					if (this.status >= 200 && this.status < 400) {
						var titleList = JSON.parse(request.responseText);
						var titleListCount = titleList.length;

						if (type == "001") {
							document.getElementById("pListViewJikwi_TBODY").innerHTML = "";
						} else {
							document.getElementById("pListViewJikchek_TBODY").innerHTML = "";
						}

						for (var i = 0; i < titleListCount; i++) {
							var titleTR = document.createElement("tr");
							var titleTD = document.createElement("td");
							titleTR.className="titleListTR";
							titleTR.id = "title_" + titleList[i].jobID + "_" + titleList[i].type;
							titleTR.setAttribute("data1", titleList[i].jobID);
							titleTR.setAttribute("data2", titleList[i].type);
							titleTR.setAttribute("data3", titleList[i].displayName);
							titleTR.setAttribute("ondblclick", "applyReceiver()");
							titleTR.setAttribute("onclick", "setSelectTR(this)");
							titleTD.textContent = titleList[i].displayName;
							titleTD.style.height = "24px";

							titleTR.appendChild(titleTD);

							if (type == "001") {
								document.getElementById("pListViewJikwi_TBODY").appendChild(titleTR);
							} else {
								document.getElementById("pListViewJikchek_TBODY").appendChild(titleTR);
							}
						}
					} else {
						alert("<spring:message code='ezJournal.t127'/>");
					}
				};

				request.onerror = function() {
					alert("<spring:message code='ezJournal.t149'/>");
					return;
				};

				var data = JSON.stringify({
					companyId : "<c:out value='${userInfo.companyID}'/>",
					type : type
				});

				request.send(data);
			}

			var getPermissionGroup = function() {
				var request = new XMLHttpRequest();
				request.open('POST', '/admin/ezNewPortal/getGroupList.do', true);
				request.setRequestHeader('Content-Type', 'application/json');

				request.onload = function() {
					if (this.status >= 200 && this.status < 400) {
						var groupList = JSON.parse(request.responseText);
						//pListViewJikwi_TBODY
						var groupListCount = groupList.length;
						document.getElementById("pListViewGroup_TBODY").innerHTML = "";

						for (var i = 0; i < groupListCount; i++) {
							var groupTR = document.createElement("tr");
							var groupTD = document.createElement("td");
							groupTR.className="groupListTR";
							groupTR.id = "group_" + groupList[i].groupID;
							groupTR.setAttribute("data1", groupList[i].groupID);
							groupTR.setAttribute("data3", groupList[i].groupName);
							groupTR.setAttribute("ondblclick", "applyReceiver()");
							groupTR.setAttribute("onclick", "setSelectTR(this)");
							groupTD.textContent = groupList[i].groupName;
							groupTD.style.height = "24px";

							groupTR.appendChild(groupTD);
							document.getElementById("pListViewGroup_TBODY").appendChild(groupTR);
						}
					} else {
						alert("<spring:message code='ezJournal.t149'/>");
						return;
					}
				};

				request.onerror = function() {
					alert("<spring:message code='ezJournal.t149'/>");
					return;
				};

				var data = JSON.stringify({
					companyId : "<c:out value='${userInfo.companyID}'/>",
					type : type
				});

				request.send(data);
			}

			function tabover(tabObj) {
				tabObj.setAttribute("class", "tabon");
			}
			function tabout(tabObj) {
				if (tabObj.id != Tab1_SelectID) {
					tabObj.setAttribute("class", "");
				}
			}

			var setSelectTR = function(elem) {
				$(".selectTR").removeClass("selectTR");
				$(elem).addClass("selectTR");
			}

			var goToPageByNum = function(Value) {
				CurPage = Value;
				makePageSelPage();
				movePage(CurPage);
			}

			var movePage = function(newPage) {
				if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
					CurPage = newPage;
					if(issearch) {
						search_click();
					} else {
						setUserList();
					}
				}
			}

			function journalKeywordClear(elem){
				$(elem).val("");
			}

		</script>
		<style type="text/css">
			.switch {
				margin-left:21px;
			}
			tr.hover:not(.selectTR):hover {
				background:#eee;
				color:#fff;
			}
			.selectTR{
				background-color: rgb(237, 244, 253);
			}
			#portalJikwi, #portalJikchek {width: 100%; height: 510px; overflow: auto; background-color: #ffffff;}
			#portalGroup {height:478px;width: 100%; overflow: auto; background-color: #ffffff;}
			#portalGroup_btn {width:100%;padding:0;}
			.titleListTR:hover, .groupListTR:hover {background-color : #f4f5f5; cursor:pointer;}
		</style>
		
	</head>
	<body class="popup">
		<xml id="listviewheader" style="display: none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezPersonal.t304' /></NAME>
		        		<WIDTH>100</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezNewPortal.t074' /></NAME>
		        		<WIDTH>70</WIDTH>
		        		<STYLE>border-top:0px; text-align:center;</STYLE>
		      		</HEADER>
		    	</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<xml id="listviewheader2" style="display: none">
			<LISTVIEWDATA>
		    	<HEADERS>
		    		<HEADER>
		        		<NAME><spring:message code = 'ezPersonal.t68' /></NAME>
		        		<WIDTH>80</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezPersonal.t7' /></NAME>
		        		<WIDTH>100</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezPersonal.t69' />/<spring:message code = 'ezPersonal.t175' /></NAME>
		        		<WIDTH>80</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>		      		
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
		
	    <h1 style="height:20px;"><spring:message code = 'ezNewPortal.t070' /></h1>
	    <div id="close">
            <ul>
                <li><span onclick="return window.close()"></span></li>
            </ul>
        </div>
	    <table>
			<tr>
	            <td rowspan="1" valign="top">
	                <table border="0" cellspacing="0" cellpadding="0">
	                    <tr>
	                        <td id="TreeViewTD" valign="top">
								<div class="portlet_tabpart01" style="width: 680px; text-align: center;">
									<div class="portlet_tabpart01_top" id="tab1" style="margin-top: 25px;margin-bottom: 2px;">
										<p><span id="1tab1" tdname="portalOrgan" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)" onmouseover="tabover(this)" onmouseout="tabout(this)" class="tabon"><spring:message code='ezNewPortal.t024' /></span></p>
										<p><span id="1tab2" tdname="portalJikwi" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)" onmouseover="tabover(this)" onmouseout="tabout(this)" class=""><spring:message code='ezEmail.t28'/></span></p>
										<p><span id="1tab3" tdname="portalJikchek" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)" onmouseover="tabover(this)" onmouseout="tabout(this)" class=""><spring:message code='ezEmail.t281'/></span></p>
										<p><span id="1tab4" tdname="portalGroup" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)" onmouseover="tabover(this)" onmouseout="tabout(this)" class=""><spring:message code='ezPersonal.yej05'/></span></p>
									</div>
								</div>
								<div id="portalOrgan_content">
									<div class="portlet_tabpart03" style="background-color: #f8f8fa; margin-top: 2px; padding:0px; border-top: none;">
										<div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #eaeaea;">
											<table style="margin-top: 3px; width: 100%;">
												<tr>
													<td>
														<div style="float: left; margin-left: 5px;">
															<select id="search_type" style="height:22px">
																<option selected value="displayname"><spring:message code='ezOrgan.t67'/></option>
																<option value="cn"><spring:message code='ezOrgan.t94'/></option>
																<option value="description"><spring:message code='ezOrgan.t68'/></option>
																<option value="title"><spring:message code='ezOrgan.t69'/></option>
																<option value="telephonenumber"><spring:message code='ezOrgan.t95'/></option>
																<option value="mobile"><spring:message code='ezOrgan.t96'/></option>
																<option value="HomePhone"><spring:message code='ezOrgan.t97'/></option>
																<option value="facsimileTelephoneNumber"><spring:message code='ezOrgan.t98'/></option>
																<option value="mail"><spring:message code='ezOrgan.t99'/></option>
																<option value="streetAddress" style="display:none"><spring:message code='ezOrgan.t100'/></option>
															</select>
															<input id="keyword" onfocus="journalKeywordClear(this);" onkeypress="if(event.keyCode==13){fn_serach('search'); return false;}" value="" style="width: 130px; margin: 0px;height:22px" />
															<a class="imgbtn"><span onclick="fn_serach('search')"><spring:message code='ezOrgan.t101'/></span></a>
														</div>
													</td>
													<td>
														<div style="float: right; margin-right: 5px; position: relative;">
															<a class="imgbtn"><span onclick="setAuthorViewUser('dept')"><spring:message code='ezNewPortal.t071' /></span></a>
															<a class="imgbtn"><span onclick="infoview_click()"><spring:message code='ezCircular.t161' /></span></a>
														</div>
													</td>
													<td></td>
												</tr>
											</table>
										</div>
									</div>
	                            <table>
	                                <tr>
	                                    <td>
	                                        <div style="overflow-y: auto; overflow-x: auto; WIDTH: 250px; HEIGHT: 482px; BACKGROUND-COLOR: #ffffff;" id="TreeView" onrequestdata="RequestData()" onnodeselect="TreeViewNodeClick()" onnodedblclick="TreeView.toggle(TreeView.selectedIndex)" class="box"></div>
	                                    </td>
	                                    <td>
	                                        <div class="listview" style="margin-left: 2px;">
	                                            <div id="OrganListView" style="OVERFLOW: auto; WIDTH: 426px; HEIGHT: 482px; border: 0;"></div>
	                                        </div>
	                                    </td>
	                                </tr>
	                            </table>
								</div>
								<div id="portalJikwi_content" style="display:none;">
									<div>
										<div id="portalJikwi" class="border_gray">
											<table id="pListViewJikwi" cellspacing="0" cellpadding="0" multiselectable="true" useocs="false" rowondblclick="InsertReceiver" width="100%" border="0" class="mainlist">
												<thead id="pListViewJikwi_THEAD">
												<tr id="pListViewJikwi_TH">
													<th id="pListViewJikwi_TH_0" class="h4_center" bgcolor="#CCCCCC" width="70px"><spring:message code='ezPersonal.yej07'/></th>
												</tr>
												</thead>
												<tbody id="pListViewJikwi_TBODY"></tbody>
											</table>
										</div>
									</div>
								</div>
								<div id="portalJikchek_content" style="display:none;">
									<div>
										<div id="portalJikchek" class="border_gray">
											<table id="pListViewJikchek" cellspacing="0" cellpadding="0" multiselectable="true" useocs="false" rowondblclick="InsertReceiver" width="100%" border="0" class="mainlist">
												<thead id="pListViewJikchek_THEAD">
												<tr id="pListViewJikchek_TH">
													<th id="pListViewJikchek_TH_0" class="h4_center" bgcolor="#CCCCCC" width="70px"><spring:message code='ezPersonal.yej07'/></th>
												</tr>
												</thead>
												<tbody id="pListViewJikchek_TBODY"></tbody>
											</table>
										</div>
									</div>
								</div>
								<div id="portalGroup_content" style="display:none;">
									<table id="portalGroup_btn" class="mainlist">
										<tr>
											<td>
												<a class="imgbtn" style="float: right; margin-right: 5px;"><span onclick="groupmember_click()"><spring:message code='ezEmail.t598' /></span></a>
											</td>
										</tr>
									</table>
									<div class="border_gray">
										<div id="portalGroup">
											<table id="pListViewGroup" cellspacing="0" cellpadding="0" multiselectable="true" useocs="false" rowondblclick="InsertReceiver" width="100%" border="0" class="mainlist">
												<thead id="pListViewGroup_THEAD">
												<tr id="pListViewGroup_TH">
													<th id="pListViewGroup_TH_0" class="h4_center" bgcolor="#CCCCCC" width="70px"><spring:message code='ezPersonal.yej07'/></th>
												</tr>
												</thead>
												<tbody id="pListViewGroup_TBODY"></tbody>
											</table>
										</div>
									</div>
								</div>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	            <td width="30" align="center">
	                <img style="cursor: pointer" src="/images/kr/cm/arr_right.gif" alt="" border="0" onclick="applyReceiver()" width="16" height="16">
	                <img style="cursor: pointer" src="/images/kr/cm/arr_left.gif" alt="" border="0" onclick="DeleteReceiver()" width="16" height="16">
	            </td>
	            <td>
	            	<table>
	                    <tr>
	                        <td id="ToTitle" colspan="2" class="receiver_tltype01" style="padding-top:25px;">
								<span><spring:message code = 'ezNewPortal.t072' /></span>
							</td>
	                    </tr>
	                    <tr>
	                        <td colspan="2">
	                            <div class="listview">
	                                <div id="ListViewMsgTo" style="BORDER: 0; HEIGHT: 482px; WIDTH: 250px; overflow: auto"></div>
	                            </div>
	                        </td>
	                    </tr>
	                    <tr>
	                        <table class="content" style="width:100%; margin-top:2px;">
	                            <tr>
	                                <th><spring:message code = 'ezBoard.t999025' /></th>
	                                <td>
										<div class='custom_checkbox'>
											<input type="checkbox" id="admin_OK" disabled onclick="checkbox_onclick(event)"><label for="admin_OK"><spring:message code = 'ezPersonal.t1020' /></label>
											<input type="checkbox" id="admin_NO" disabled onclick="checkbox_onclick(event)"><label for="admin_NO"><spring:message code = 'ezPersonal.t1021' /></label>
										</div>
	                                </td>
	                            </tr>
	                        </table>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <div class="btnpositionNew" style="float: center">
	        <a class="imgbtn"><span onclick="confirm_onClick()"><spring:message code = 'ezPersonal.t12' /></span></a>
	    </div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>