<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t16" /></title>
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezAddress/address_tree.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list_admin.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component_utf8.js')}"></script>
		<script type="text/javascript" language="javascript">
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
		    var topid = "<c:out value='${topid}'/>";
		    var primary = "<c:out value='${primary}'/>";
		    var ReturnFunction;
		    var RetValue;
		    var isAllGroupBoard;
		    
		    window.onload = function () {
				try {
					RetValue = parent.selecttarget_dialogArguments[0];
		            ReturnFunction = parent.selecttarget_dialogArguments[1];
		            isAllGroupBoard = parent.selecttarget_dialogArguments[2];
		        } catch (e) {
		            try {
		            	RetValue = opener.selecttarget_dialogArguments[0];
		                ReturnFunction = opener.selecttarget_dialogArguments[1];
		                isAllGroupBoard = opener.selecttarget_dialogArguments[2];
		            } catch (e) {
		            }
		        }

		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                var input = document.getElementsByTagName("input");
		                for (var i = 0; i < input.length; i++) {
		                    if (input[i].getAttribute("type") == "text")
		                        KeEventControl(input[i]);
		                }
		            }
		        } catch (e) { }

		        m_receiverTitleList = new Array(ToTitle);
		        m_receiverWindowList = new Array(ListViewMsgTo);
		        
		        var listview = new ListView();
		        listview.SetID("ListViewMsgToView");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnClick("SelectReceiverWindow");
		        listview.SetRowOnDblClick("DeleteReceiver");
		        listview.DataSource(loadXMLString(document.getElementById("listviewheader").innerHTML.toUpperCase()));
		        listview.DataBind("ListViewMsgTo");
		        
		        var listview5 = new ListView();
		        listview5.SetID("OrganList");
		        listview5.SetMulSelectable(false);
		        listview5.SetRowOnDblClick("ListViewNodeDblClick");
		        listview5.DataSource(loadXMLString(document.getElementById("listviewheader2").innerHTML.toUpperCase()));
		        listview5.DataBind("OrganListView");

		        applyCurrentData();
		        
		        /* 2019-01-22 홍승비 - 전체관리자가 그룹사게시판의 권한 설정하는 경우, 전체 조직도 표출 */
		        if (isAllGroupBoard == "Y") {
		        	topid += "/organ";
		        }
		        
		        g_xmlHTTP = createXMLHttpRequest();
		        var strQuery = "<DATA><DEPTID>" + "${deptID}" + "</DEPTID><TOPID>" + topid + "</TOPID><PROP>mail;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
		        g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		        g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		        g_xmlHTTP.send(strQuery);

		        m_selectedTree = TreeView;
		        SelectReceiverWindow(ToTitle, ListViewMsgTo);

		        admin_OK.disabled = true;
		        admin_NO.disabled = true;
		        admin_OK.checked = false;
		        admin_NO.checked = true;
			};
			
			function TreeViewNodeClick(pNodeID, pTreeID) {						        	
	            var treenode = new TreeNode();
	            treenode.LoadFromID(pNodeID);
	            nodeIdx = treenode.GetNodeData("CN");
	            displayUserList(nodeIdx);
	        }
		        
		    function displayUserList(DeptID) {
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	data : {
		        		deptID : DeptID, 
		        		cell : "displayname;description;title;telephonenumber", 
		        		prop : "mail;displayName;description;title",
		        		type : "user"
		        	},
		        	success : function(result){		 
		        		result = loadXMLString(result);
		                document.getElementById("OrganListView").innerHTML = "";
		                var listview = new ListView();
		                listview.SetID("OrganList");
		                listview.SetSelectFlag(false);
		                listview.SetMulSelectable(false);
		                listview.SetRowOnDblClick("ListViewNodeDblClick");
		                listview.DataSource(loadXMLString(document.getElementById("listviewheader2").innerHTML.toUpperCase()));
		                listview.DataBind("OrganListView");
		                listview.DataSource(result);
		                listview.RowDataBind();
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezBoard.t22'/>" + error);	
		        	}
		        });		            
		    }
		    
		    //2018.04.03//검색된 인물 하나만을 organView에 나타낸다.
		    var listv = "";
		    var rows = "";
		    var row = "";
		    var thead = "";
			function displayUserOne(UserID, DeptID) {			
				 $.ajax({
			        	type : "POST",
			        	dataType : "text",
			        	url : "/ezOrgan/getDeptMemberList.do",
			        	async : false,
			        	data : {
			        		deptID : DeptID, 
			        		cell : "displayname;description;title;telephonenumber", 
			        		prop : "mail;displayName;description;title",
			        		type : "user"
			        	},
			        	success : function(result){	
			        		result = loadXMLString(result);
			        		thead = loadXMLString(document.getElementById("listviewheader2").innerHTML.toUpperCase());
			        		row = result.getElementsByTagName("ROW");
			        		
			        		for(var i = 0; i < row.length; i++){
			        			if(row[i].getElementsByTagName("DATA2")[0].textContent == UserID){
			        				row = row[i];
			        			}
			        		}
			        			
							listv = document.createElement("LISTVIEWDATA");
							rows = document.createElement("ROWS");
							rows.appendChild(row);
							listv.appendChild(rows);
							
							document.getElementById("OrganListView").innerHTML = "";
							var listview = new ListView();
							listview.SetID("OrganList");
							listview.SetSelectFlag(false);
							listview.SetMulSelectable(false);
							listview.SetRowOnDblClick("ListViewNodeDblClick");
							listview.DataSource(thead);
							listview.DataBind("OrganListView");
							listview.DataSource(listv);
							listview.RowDataBind();
						},
						error : function(error) {
							alert("<spring:message code='ezBoard.t22'/>" + error);
						}
					});
			}

			function RequestData(pNodeID, pTreeID) {
				var TreeIdx = pNodeID;
				var treeNode = new TreeNode();
				treeNode.LoadFromID(TreeIdx);
				var deptID = treeNode.GetNodeData("CN");

				GetDeptSubTreeInfo(deptID, TreeIdx);
			}

			function event_getDeptFullTree() {
				if (g_xmlHTTP != null && g_xmlHTTP.readyState == 4) {
					if (g_xmlHTTP.status == 200) {
						if (!bSearch) {
							try {
								RetValue["window"].opener.top.organview = g_xmlHTTP.responseText;
							} catch (e) {
							}
						}
						var xmlDom = loadXMLFile("/xml/common/organtree_config3.xml");
						document.getElementById('TreeView').innerHTML = "";

						var treeView = new TreeView();
						treeView.SetConfig(xmlDom);
						treeView.SetID("TreeViewList");
						treeView.SetUseAgency(true);
						treeView.SetRequestData("RequestData");
						treeView.SetNodeClick("TreeViewNodeClick");
						treeView.DataSource(loadXMLString(g_xmlHTTP.responseText));
						treeView.DataBind("TreeView");

					} else {
						alert("<spring:message code='ezBoard.t17' />"
								+ g_xmlHTTP.status);
						g_xmlHTTP = null;
					}
				}
			}

			function applyCurrentData() {
				var xmldoc;
				xmldoc = loadXMLString(RetValue["selectTargetListXML"]);
				var i = 0;
				var username, useremail;
				var username2, boardGroupACL, dept;
				for (i = 0; i < GetElementsByTagName(xmldoc, "CN").length; i++) {
					username = getNodeText(GetElementsByTagName(xmldoc, "NAME")[i]);
					username2 = getNodeText(GetElementsByTagName(xmldoc,"NAME2")[i]);
					useremail = getNodeText(GetElementsByTagName(xmldoc, "CN")[i]);
					boardGroupACL = getNodeText(GetElementsByTagName(xmldoc,"GROUP")[i]);
					dept = getNodeText(GetElementsByTagName(xmldoc, "DEPT")[i]);
					pparsingXML2 = "";
					pparsingXML = "";
					pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
					pparsingXML = pparsingXML + "<ROW><CELL><DATA1>"+ useremail + "</DATA1>";
					pparsingXML = pparsingXML + "<DATA2><![CDATA[" + username+ "]]></DATA2>";
					pparsingXML = pparsingXML + "<DATA3><![CDATA[" + username2+ "]]></DATA3>";
					pparsingXML = pparsingXML + "<DATA4><![CDATA[" + dept+ "]]></DATA4>";
					pparsingXML = pparsingXML + "<DATA5><![CDATA["+ boardGroupACL + "]]></DATA5>";
					
					if (primary == "1") {
						pparsingXML = pparsingXML + "<VALUE><![CDATA["+ username + "]]></VALUE>";
					} else {
						pparsingXML = pparsingXML + "<VALUE><![CDATA["+ username2 + "]]></VALUE>";
					}
					pparsingXML = pparsingXML + "</CELL></ROW>";
					pparsingXML2 = pparsingXML2 + pparsingXML+ "</ROWS></LISTVIEWDATA2>";

					Resultxml = loadXMLString(pparsingXML2);

					var listview = new ListView();
					listview.LoadFromID("ListViewMsgToView");

					var MaxID = 0;
					var InitTr = listview.GetDataRows();

					for (var j = 0; j < InitTr.length; j++) {
						var curnum = Number(listview.GetSelectedRowID(j)
								.substring(
										listview.GetSelectedRowID(j)
												.lastIndexOf('_') + 1),
								listview.GetSelectedRowID(j).length);
						if (MaxID < curnum)
							MaxID = curnum;
					}
					var objTr = listview.AddRow(MaxID);
					SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxID)
							.substring(0, listview.GetSelectedRowID(MaxID).lastIndexOf('_') + 1)+ eval(MaxID + 1));
					listview.AddDataRow(objTr, Resultxml);
				}
			}

			function GetDeptSubTreeInfo(deptID, TreeIdx) {
				var xmlHTTP = createXMLHttpRequest();
				var xmlRtn = createXmlDom();

				var strQuery = "<DATA><DEPTID>" + deptID
						+ "</DEPTID><PROP>mail;displayName</PROP></DATA>";

				xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
				xmlHTTP.send(strQuery);

				xmlRtn = loadXMLString(xmlHTTP.responseText);

				var treeView = new TreeView();
				treeView.LoadFromID("TreeViewList");
				treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
			}

			function SelectReceiverWindow(Title, selectedWindow) {
				for (var count = 0; count < m_receiverTitleList.length; count++) {
					m_receiverTitleList[count].style.fontWeight = "normal";
					m_receiverWindowList[count].style.backgroundColor = m_titleNoneSelectedColor;
					m_receiverWindowList[count].normalColor = m_titleNoneSelectedColor;
				}
				ToTitle.style.fontWeight = "bold";
				ListViewMsgTo.style.backgroundColor = m_titleSelectedColor;
				ListViewMsgTo.normalColor = m_titleSelectedColor;
				m_selectedWindow = ListViewMsgTo;
				if (document.getElementById(Title)) {
					if (document.getElementById(Title).getAttribute("DATA4") == "DEPT") {
						admin_OK.disabled = false;
						admin_NO.disabled = false;
						var _data5 = document.getElementById(Title).getAttribute("DATA5");

						if (_data5 == "Y") {
							admin_OK.checked = true;
							admin_NO.checked = false;
						} else {
							admin_OK.checked = false;
							admin_NO.checked = true;
						}
					} else {
						admin_OK.checked = false;
						admin_OK.disabled = true;
						admin_NO.checked = true;
						admin_NO.disabled = true;
					}
				}
			}

			function DeleteReceiver(pListView) {
				var listView = new ListView();
				listView.LoadFromID("ListViewMsgToView");
				listView.DeleteRow(listView.GetSelectedRows()[0].id);
			}

			function ListViewNodeDblClick() {
				if (m_selectedWindow != null)
					InsertReceiver(m_selectedWindow);
			}

			/* 다국어 설정할 시, 우측에 들어가는 이름도 다국어로 나타나야 한다. */
			function InsertReceiver(pListView) {
				if (m_selectedTree == TreeView) {
					var pListViewDL = new ListView(); //// ListView 선언
					pListViewDL.LoadFromID("OrganList");

					var arrRows = pListViewDL.GetSelectedRows();

					if (arrRows.length > 0) {
						var getlistview = new ListView();
						getlistview.LoadFromID("ListViewMsgToView");
						var existId = GetAttribute(arrRows[0], "data2");
						var existName = GetAttribute(arrRows[0], "data7");
						var strDeptNM = GetAttribute(arrRows[0], "data9");
						var existName2 = GetAttribute(arrRows[0], "data8");
						var strDeptNM2 = GetAttribute(arrRows[0], "data10");
						var bFlag = getlistview.ExistRow("DATA1", existId);
						if (bFlag) {
							alert("<spring:message code='ezBoard.t20' />");
							pAddFlag = true;
							return;
						} else {
							pparsingXML2 = "";
							pparsingXML = "";
							pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
							pparsingXML = pparsingXML + "<ROW><CELL><DATA1>"+ existId + "</DATA1>";
							pparsingXML = pparsingXML + "<DATA2><![CDATA["+ existName + "(" + strDeptNM.trim() + ")"+ "]]></DATA2>";
							pparsingXML = pparsingXML + "<DATA3><![CDATA["+ existName2 + "(" + strDeptNM2.trim()+ ")" + "]]></DATA3>";
							pparsingXML = pparsingXML + "<DATA4><![CDATA[PERSON]]></DATA4>";
							pparsingXML = pparsingXML + "<DATA5><![CDATA[N]]></DATA5>";
							
							if (primary == "1") {
								pparsingXML = pparsingXML + "<VALUE><![CDATA["+ existName + "(" + strDeptNM.trim()+ ")" + "]]></VALUE>";
							} else {
								pparsingXML = pparsingXML + "<VALUE><![CDATA["+ existName2 + "(" + strDeptNM2.trim()+ ")" + "]]></VALUE>";
							}							
							pparsingXML = pparsingXML + "</CELL></ROW>";
							pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";

							Resultxml = loadXMLString(pparsingXML2);

							var listview = new ListView();
							listview.LoadFromID("ListViewMsgToView");

							var MaxID = 0;
							var InitTr = listview.GetDataRows();

							for (var j = 0; j < InitTr.length; j++) {
								var curnum = Number(listview.GetSelectedRowID(j).substring(
										listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
								if (MaxID < curnum)
									MaxID = curnum;
							}

							var objTr = listview.NewAddRow(0,"ListViewMsgToView" + "_TR_"+ eval(MaxID + 1));
							listview.AddDataRow(objTr, Resultxml);
							listview.SetSelectedIndex(MaxID + 1);
							admin_OK.disabled = true;
							admin_NO.disabled = true;
						}
					} else {
						var organTree = new TreeView();
						organTree.LoadFromID("TreeViewList");

						var nodeIdx = organTree.GetSelectNode();
						var strCN = nodeIdx.GetNodeData("CN");
						var pparsingXML = "";
						var getlistview = new ListView();
						getlistview.LoadFromID("ListViewMsgToView");
						var bFlag = getlistview.ExistRow("DATA1", strCN);

						if (bFlag) {
							alert("<spring:message code='ezBoard.t20' />");
							return;
						} else {
							pparsingXML2 = "";
							pparsingXML = "";
							pparsingXML2 = "<LISTVIEWDATA2><ROWS>";
							pparsingXML = pparsingXML + "<ROW><CELL><DATA1>"+ nodeIdx.GetNodeData("CN") + "</DATA1>";
							pparsingXML = pparsingXML + "<DATA2><![CDATA["+ nodeIdx.GetNodeData("DISPLAYNAME")+ "]]></DATA2>";
							pparsingXML = pparsingXML + "<DATA3><![CDATA["+ nodeIdx.GetNodeData("DISPLAYNAME2")+ "]]></DATA3>";
							pparsingXML = pparsingXML + "<DATA4><![CDATA[DEPT]]></DATA4>";
							pparsingXML = pparsingXML + "<DATA5><![CDATA[N]]></DATA5>";
							
							if (primary == "1") {
								pparsingXML = pparsingXML + "<VALUE><![CDATA[" + nodeIdx.GetNodeData("DISPLAYNAME") + "]]></VALUE>";
							} else {
								pparsingXML = pparsingXML + "<VALUE><![CDATA[" + nodeIdx.GetNodeData("DISPLAYNAME2") + "]]></VALUE>";
							}
							pparsingXML = pparsingXML + "</CELL></ROW>";
							pparsingXML2 = pparsingXML2 + pparsingXML + "</ROWS></LISTVIEWDATA2>";
							Resultxml = loadXMLString(pparsingXML2);

							Resultxml = loadXMLString(pparsingXML);

							var listview = new ListView();
							listview.LoadFromID("ListViewMsgToView");

							var MaxID = 0;
							var InitTr = listview.GetDataRows();

							for (var j = 0; j < InitTr.length; j++) {
								var curnum = Number(listview.GetSelectedRowID(j).substring(
									listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
								if (MaxID < curnum)
									MaxID = curnum;
							}
							var objTr = listview.NewAddRow(0, "ListViewMsgToView" + "_TR_" + eval(MaxID + 1));

							listview.AddDataRow(objTr, Resultxml);
							listview.SetSelectedIndex(MaxID + 1);
							admin_OK.disabled = false;
							admin_NO.disabled = false;
						}
					}
					document.getElementById("admin_OK").checked = false;
					document.getElementById("admin_NO").checked = true;
				}
			}

			function confirm_onClick() {
				var listview = new ListView();
				listview.LoadFromID("ListViewMsgToView");
				var listviewSelected = listview.GetDataRows();
				var selectedTarget = "";
				var selectTargetListXML = "<DATA>";
				for (var nCnt1 = 0; nCnt1 < listviewSelected.length; nCnt1++) {
					selectTargetListXML += "<CN>"+ listviewSelected[nCnt1].getAttribute("data1")+ "</CN>";
					selectTargetListXML += "<NAME><![CDATA["+ listviewSelected[nCnt1].getAttribute("data2")+ "]]></NAME>";
					selectTargetListXML += "<NAME2><![CDATA["+ listviewSelected[nCnt1].getAttribute("data3")+ "]]></NAME2>";
					selectTargetListXML += "<DEPT><![CDATA["+ listviewSelected[nCnt1].getAttribute("data4")+ "]]></DEPT>";
					selectTargetListXML += "<GROUP><![CDATA["+ listviewSelected[nCnt1].getAttribute("data5")+ "]]></GROUP>";
					if (nCnt1 == 0)
						selectedTarget = listviewSelected[nCnt1].cells[0].innerText;
					else
						selectedTarget += ", "+ listviewSelected[nCnt1].cells[0].innerText;
				}
				selectTargetListXML += "</DATA>";

				RetValue["window"].document.getElementById("selectedTarget").innerHTML = MakeXMLString(selectedTarget);
				if (ReturnFunction != null) {
					ReturnFunction(selectTargetListXML);
				} else {
					window.returnValue = selectTargetListXML;
				}
				window.close();
			}

			var checkname2_cross_dialogArguments = new Array();
			var rgParams = new Array();
			var adCount = 0;
			var userID = "";
			var deptID = "";
			function cnsearch_click(pMode) {
				if (cnkeyword.value.replace(/\s/g, "") == "") {
					alert("<spring:message code='ezBoard.t23'/>");
					cnkeyword.focus();
					return;
				}
				adCount = 0;
				var xmlDOM = createXmlDom();
				var adminOrgan = "";
				if (isAllGroupBoard == "Y") {
					adminOrgan = "y";
				}

				$.ajax({
						type : "POST",
						dataType : "text",
						url : "/ezOrgan/getSearchList.do",
						async : false,
						data : {
							search : pMode + "::" + cnkeyword.value,
							cell : 'company;description;title;displayName;mail',
							prop : 'department',
							type : 'user',
			        		adminOrgan : adminOrgan
						},
						success : function(result) {
							xmlDOM = loadXMLString(result);
							adCount = xmlDOM.getElementsByTagName("ROW").length;
							userID = getNodeText(GetElementsByTagName(xmlDOM, "DATA2")[0]);
							deptID = getNodeText(GetElementsByTagName(xmlDOM, "DATA3")[0]);
							
							//getSearchList실행 뒤에 동작해야 하므로, success 시 실행한다.
							if (adCount == 1) {
								displayUserOne(userID, deptID);
							}
						},
						error : function(error) {
							alert("<spring:message code='ezBoard.t24'/>"
									+ error);
							xmlDOM = null;
						}
					});

				if (adCount == 0) {
					alert("<spring:message code='ezBoard.t25'/>");
					return;
				}
				else if (adCount != 1) {
					rgParams["addrBook"] = xmlDOM;
					rgParams["deptid"] = "";
					checkname2_cross_dialogArguments[0] = rgParams;
					checkname2_cross_dialogArguments[1] = cnsearch_click_Complete;
					var checkName2 = window.open("/admin/ezBoard/checkName.do", "checkName2", GetOpenWindowfeature(900, 430));
					try {
						checkName2.focus();
					} catch (e) {
					}
				}
			}

			//검색한 여러명 중 한 명을 선택할 경우
			function cnsearch_click_Complete(RetValue) {
				if ((RetValue["deptid"] != "") && (RetValue["userid"] != "")) {
					displayUserOne(RetValue["userid"], RetValue["deptid"]);
				}		
			}

			function Key_Down(e) {
				if (e.keyCode == 13) {
					cnsearch_click("displayName");
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
					admin_OK.checked = true;
					admin_NO.checked = false;
					checkFlag = "Y";
				} else {
					admin_OK.checked = false;
					admin_NO.checked = true;
					checkFlag = "N";
				}

				var pListViewDL = new ListView();
				pListViewDL.LoadFromID("ListViewMsgToView");
				var arrRows = pListViewDL.GetSelectedRows();
				if (arrRows == "")
					return;
				SetAttribute(arrRows[0], "DATA5", checkFlag);

				if (checkFlag == "N") {
					if (CrossYN()) {
						SetAttribute(arrRows[0].childNodes[0], "style", "color:red;");
					} else {
						arrRows[0].childNodes[0].style.color = "red";
					}
				} else {
					if (CrossYN()) {
						SetAttribute(arrRows[0].childNodes[0], "style", "color:;");
					} else {
						arrRows[0].childNodes[0].style.color = "";
					}
				}
			}
		</script>
	</head>
	<body class="popup">
		<xml id="listviewheader" style ="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<NAME><spring:message code='ezBoard.t35' /></NAME>
		        		<WIDTH>100</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
		<xml id="listviewheader2" style ="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<NAME><spring:message code='ezBoard.t36' /></NAME>
		        		<WIDTH>100</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezBoard.t9' /></NAME>
		        		<WIDTH>100</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezBoard.t37' /></NAME>
		        		<WIDTH>80</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezPersonal.t177' /></NAME>
		        		<WIDTH>100</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>		     
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
		<h1><spring:message code='ezBoard.t16' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<table>
			<tr align=left>
		    	<td  colspan="1" id="cnblock" style="height: 30px; background-color: #f8f8fa; margin: 0px; padding: 0px; border: 1px solid #eaeaea;" align="right">
		    		<div style="margin-right: 5px; margin-top: 2px;">
			        	<input type="text" id="cnkeyword" style="WIDTH:124px; height: 22px;" name="Input" onkeydown='Key_Down(event)'>
			        	<a class="imgbtn"  name="button"><span onClick='cnsearch_click("displayName")'><spring:message code='ezBoard.t42' /></span></a>
		    		</div>
		    	</td>
		    	<td></td>
		    	<td>
		    	<h2 class="receiver_tltype01" style="margin-bottom: -15px;">
		    		<span style="min-width: 45px;" id="PermissionStr"><spring:message code='ezBoard.t606' /></span>
		    	</h2>
		    	</td>
		  	</tr>
		  	<tr>
		    	<td rowspan="1" valign="top" >
		        	<table border="0" cellspacing="0" cellpadding="0">
		            	<tr>
		              		<td align="center" id="TreeViewTD" valign="top">
		                  		<table style="margin-top: 4px;">
		                      		<tr>
		                            	<td>
		                                	<div style="overflow-y:auto;overflow-x:auto;WIDTH:270px;HEIGHT:440px;BACKGROUND-COLOR:#ffffff;" id="TreeView" onrequestdata="RequestData()" onnodeselect="TreeViewNodeClick()" onnodedblclick="TreeView.toggle(TreeView.selectedIndex)" class="box"></div>
		                            	</td>
		                            	<td width="5"></td>
		                            	<td>
		                                	<div class="listview">
		                	                <div id=OrganListView style ="OVERFLOW:auto; WIDTH:100%; min-width:612px; HEIGHT:440px; border:0"></div></div>
		                    	        </td>
		                      		</tr>
		                 		</table>
		              		</td>                    
		            	</tr>
		      		</table>
		    	</td>
		    	<td  width="30" align="center">
		        	<img style="cursor:pointer" src="/images/kr/cm/arr_right.gif" alt="" border="0" onClick="InsertReceiver(ListViewMsgTo)" width="16" height="16"> 
		        	<img style="cursor:pointer" src="/images/kr/cm/arr_left.gif" alt="" border="0" onClick="DeleteReceiver(ListViewMsgTo)" width="16" height="16"> 
		    	</td>		
		    	<td>
		        	<table>
		            	<tr style="DISPLAY:none">
		                	<td id="ToTitle"><spring:message code='ezBoard.t43' /></td>
		            	</tr>
		            	<tr>
		                	<td>
		                		<div class="listview" style="border-bottom:0px;margin-top: 6px;">
		                    		<div id=ListViewMsgTo style ="BORDER:0;HEIGHT: 409px; WIDTH:200px;overflow:auto"></div>
		                		</div>
		                	</td>
		            	</tr>
		        	</table>
		        	<table class="content" style="width: 100%;">
		            	<tbody>
		                	<tr>
		                    	<th><spring:message code='ezBoard.t999025' /></th>
		                    	<td>
			                        <input type="checkbox" id="admin_OK" onclick="checkbox_onclick(event)">&nbsp;<spring:message code='ezBoard.t95' />
			                        <input type="checkbox" id="admin_NO" onclick="checkbox_onclick(event)">&nbsp;<spring:message code='ezBoard.t96' />
			                    </td>
		                	</tr>
		            	</tbody>
		        	</table>
		    	</td>
		  	</tr>
		</table>
		<div class="btnpositionNew">
			<a class="imgbtn"><span onclick="confirm_onClick()" ><spring:message code='ezBoard.t48' /></span></a>
		</div>
	</body>
</html>