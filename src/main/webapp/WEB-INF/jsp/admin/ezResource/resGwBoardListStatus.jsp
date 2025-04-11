<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title><spring:message code="ezResource.kwc01"/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/organtreeview.htc.js')}"></script> 
		<script type="text/javascript" src="${util.addVer('/js/ezResource/control/ListView_Schedule.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/admin/gwAdmin.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/jquery.mCustomScrollbar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		
		<style type="text/css">
	    .tabpart01UL{
	    	position:absolute;
	    	top:35px;
	    	right:0px;
	    	background:white;
	    	padding:25px;
	    	border:1px solid #999;
	    	width:120px;
	    	list-style-image:url("/images/kr/cm/dot_blue.gif");
	    }
	    .tabpart01UL li {
	    	height:20px;
	    	color:#777;
			white-space: nowrap;
		    text-overflow: ellipsis;
		    overflow: hidden;
	    }
	    .portlet_tabnew01_top {
	    	height:48px;
	    	list-style:none;
	    	margin:0px;
	    	padding:0px;
	    }
	    select {
			height: auto;
			font-size: 12px !important;
		}
		.node_div {cursor:pointer;}
		
		.node_selected {
		    height: 26px;
		    line-height: 26px;
		    color: #0470E4;
		    display: inline-block;
		    padding: 0px 0px 0px 3px;
		    cursor: pointer;
		    width: 76%;
		    white-space: nowrap;
		    text-overflow: ellipsis;
		    overflow: hidden;
		    box-sizing: border-box;
		    font-weight: bold;
		    text-decoration: underline !important;
		}
		
		.node_normal {
		    height: 26px;
		    line-height: 26px;
		    display: inline-block;
		    padding: 0px 0px 0px 3px;
		    cursor: pointer;
		    width: 76%;
		    white-space: nowrap;
		    text-overflow: ellipsis;
		    overflow: hidden;
		    box-sizing: border-box;
		}
		
	    </style>
		<script type="text/javascript" id="clientEventHandlersJS" >
			var pUserID		= "<c:out value='${userInfo.id}'/>";
			var pDeptID		= "<c:out value='${userInfo.deptID}'/>";
			var pCompanyID	= "<c:out value='${selectedCompany}'/>";
			var pAdminYN	= "<c:out value='${adminYN}'/>";
			var HqProposalNM;
			var selectNo = "<c:out value='${selectNo}'/>";
			var timer = null;
			var searchStartTime = "";
			var searchEndTime = "";
			var std = "";
			var etd = "";
			var startDate = "";
			var endDate = "";
			var g_AccessCode = "0";
			var g_DeptPath	= "${deptPathCode}";
			var NowDate3;
			var selectedObj;
        	var selectedTabId;
			var selectedTabType;
			var CurPage = "1";
	    	var totalPage = "";
	    	var pType;
	    	var returnFlagarr = new Array();
	    	var openFlag = false;
			
			window.onload = function () {
		        var TreeView = new organtreeview('TreeView', 'TreeView');
		        TreeView.attachEvent('requestdata', TreeView_onNodeExpanded);
		        TreeView.attachEvent('nodeselect', TreeView_onNodeClick);

		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
		        xmlHTTP.send();

		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            TreeView.server("<c:out value='${serverName}'/>");
		            TreeView.config(xmlHTTP.responseXML);
		            TreeView.update();
					changeCompany(pCompanyID);
		        }
		        
		        GetMyBoardItem_event();
		        makePageSelPage();
		    }
			
			$(function () {
	            $("#Sdatepicker").datepicker({
	                changeMonth: true,
	                changeYear: true,
	                autoSize: true,
	                showOn: "both",
	                buttonImage: "/images/ImgIcon/calendar-month.png",
	                buttonImageOnly: true,
	                onSelect: function(selected) {
	                	compareDateStart();
		    		}
	            });
	            $("#Sdatepicker2").datepicker({
	                changeMonth: true,
	                changeYear: true,
	                autoSize: true,
	                showOn: "both",
	                buttonImage: "/images/ImgIcon/calendar-month.png",
	                buttonImageOnly: true,
	                onSelect: function(selected) {
		    			compareDateEnd();
		    		}
	            });
	            var NowDate = new Date();
	            var NowDate2 = new Date();
	            NowDate2.setDate(NowDate2.getDate() + 90);
	            $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	            $("#Sdatepicker").datepicker('setDate', NowDate);
	            $("#Sdatepicker2").datepicker("option", "dateFormat", "yy-mm-dd");
	            $("#Sdatepicker2").datepicker('setDate', NowDate2);
	        });
			
	        $(function () {
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
	        });
	        
	        function compareDateStart() {
				startDate = new Date($("#Sdatepicker").datepicker("getDate"));
				endDate = new Date($("#Sdatepicker2").datepicker("getDate"));
				
				if (startDate - endDate > 0) {
					std = $('#Sdatepicker').val();
    				$('#Sdatepicker2').val(std);
				}		
				
			}
		   	
		   	function compareDateEnd() {
				startDate = new Date($("#Sdatepicker").datepicker("getDate"));
				endDate = new Date($("#Sdatepicker2").datepicker("getDate"));
				
				if (endDate - startDate < 0) {
					etd = $('#Sdatepicker2').val();
					$('#Sdatepicker').val(etd);
				} 
			}
			
			function treeInit() {
				var event1 = {'nodeIdx' : '1'};
		        TreeView_onNodeExpanded(event1);
			}
			
			function TreeView_onNodeDblClick() {
		        TreeView.toggle(TreeView.selectedIndex());
		    }
			
			function changeTree() {
				changeCompany(pCompanyID);
			}

			function changeCompany(selCompany) {
				pCompanyID = selCompany;
				if (pAdminYN == "YES")
					cAdmin = "ADMIN"
				else
					cAdmin = "BOARDADMIN"

				initTreeInfo(pUserID, selCompany);
			}
			
			function initTreeInfo(p_UserID, selectedCompany) {
		        var xmlhttp = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var xmlRtn = createXmlDom();

		        var objNode;
		        createNodeInsert(xmlpara, objNode, "BRDLIST");
		        createNodeAndInsertText(xmlpara, objNode, "PARENT_ID", "");
		        createNodeAndInsertText(xmlpara, objNode, "COMPANY_ID", selectedCompany);
		        createNodeAndInsertText(xmlpara, objNode, "ACCESS_FLAG", "0");
		        createNodeAndInsertText(xmlpara, objNode, "FIRST_NODE", "Y");
		        createNodeAndInsertText(xmlpara, objNode, "TREE_TYPE", "1");

		        xmlhttp.open("POST", "/ezResource/callNodeTreeData.do?flag=" + encodeURIComponent(selectNo), false);
		        xmlhttp.send(xmlpara);

		        var XMLstring = xmlhttp.responseText;

		        xmlRtn = loadXMLString(XMLstring);
		        TreeView.source(xmlRtn);
		        TreeView.update();
		    }
			
		    function TreeView_onNodeExpanded(event) {
        		displayBrdTree.call(this, pUserID, pDeptID, event);
    		}
		    
		    function displayBrdTree(p_UserID, p_DeptID, event) {
		        if (!event) event = window.event;
		    	var nodeIdx = event.nodeIdx;
		    	var p_BrdID = TreeView.getvalue(nodeIdx, "DATA1");
		    	
		    	AddSubBrdTree(p_UserID, p_DeptID, p_BrdID, nodeIdx);
		    }

		    function AddSubBrdTree(p_UserID, p_DeptID, p_BrdID, nodeIdx) {
	    		var xmlhttp = createXMLHttpRequest();
	    		var xmlpara = createXmlDom();
	    		var xmlRtn = createXmlDom(); 
	    		
	    		var objNode;		
	    	    createNodeInsert(xmlpara, objNode, "BRDLIST"); 
	    	    createNodeAndInsertText(xmlpara, objNode, "PARENT_ID", p_BrdID);
	    	    createNodeAndInsertText(xmlpara, objNode, "COMPANY_ID", pCompanyID);
	    	    createNodeAndInsertText(xmlpara, objNode, "ACCESS_FLAG", g_AccessCode);
	    	    createNodeAndInsertText(xmlpara, objNode, "FIRST_NODE", "N");
	    	    createNodeAndInsertText(xmlpara, objNode, "TREE_TYPE", "0");
	    	    createNodeAndInsertText(xmlpara, objNode, "USER_ID", p_UserID);
	    	    createNodeAndInsertText(xmlpara, objNode, "DEPT_PATH", g_DeptPath);
	    	    createNodeAndInsertText(xmlpara, objNode, "ADMIN_CHECK", "Y");
	    	    
	    		xmlhttp.open("POST","/ezResource/callNodeTreeData.do",false);
	    		xmlhttp.send(xmlpara);
	    		
	    		xmlRtn = xmlhttp.responseXML;
	    	
	            TreeView.putchildxml(nodeIdx, xmlRtn);
		    }

		    function getFirstDepthNode(p_Depth, p_brd_id, nodeIdx) {
		        var xmlhttp = createXMLHttpRequest();
		        var xmlRtn = createXmlDom();
		        var xmlpara = createXmlDom();

		        var objNode;
		        createNodeInsert(xmlpara, objNode, "BRDLIST");
		        createNodeAndInsertText(xmlpara, objNode, "PARENT_ID", p_brd_id);
		        createNodeAndInsertText(xmlpara, objNode, "COMPANY_ID", pCompanyID);
		        createNodeAndInsertText(xmlpara, objNode, "ACCESS_FLAG", "0");
		        createNodeAndInsertText(xmlpara, objNode, "FIRST_NODE", "N");
		        createNodeAndInsertText(xmlpara, objNode, "TREE_TYPE", "1");

		        xmlhttp.open("POST", "/ezResource/callNodeTreeData.do", false);
		        xmlhttp.send(xmlpara);

		        var XMLstring = xmlhttp.responseText;
		        xmlRtn = loadXMLString(XMLstring);
		        if (XMLstring == "" || XMLstring == "<NODES/>") return;

		        if (SelectNodes(xmlRtn, "NODES/NODE/SELECT").length > 0) {
		            xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].removeChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("SELECT")[0]);
		        }
		        TreeView.putchildxml(nodeIdx, xmlRtn);
		    }

		    function TreeView_onNodeClick() {
	    		var selNode = TreeView.selectedIndex();
	    		
		    	if (selNode != null) {
		    		var brdGB = TreeView.getvalue(selNode, "DATA7");
		    		if (brdGB == "2") {
		    			CurPage = 1;
		    			getResourceList();
		    		} else {
		    			document.getElementById("TreeView_node_" + selNode).classList.remove("node_selected");
		    		}
		    		TreeView.toggle(selNode);
		    	}
		    }
	        
	        var overCnt = 0;
	        var widthCheck = false;
	        var overCntText = '...';
	        function GetMyBoardItem_event(doNotRefresh) {
	        	
		        var tabText = "";
	        	var tabType = "approve";
	        	var tabType2 = "wait";
	        	var tabType3 = "end";
	        	
	        	var tabName = strLangKWC01;
	        	var tabName2 = strLangKWC02;
	        	var tabName3 = strLangKWC03;
	        	
	        	tabText += "<p id='FBoard_sub0'>";
	        	tabText += "<span id='1tab0' divname='FBoard_div0' name='FBoard_div' data1=\'" + tabType + "\' data2=\'" + tabName + "\' data5='0' class='tabover' style='margin-right:10px;'>" + tabName + "</span>";
	        	tabText += "</p>";
	        	tabText += "<p id='FBoard_sub1'>";
	        	tabText += "<span id='1tab1' divname='FBoard_div1' name='FBoard_div' data1=\'" + tabType2 + "\' data2=\'" + tabName2 + "\' data5='0' style='margin-right:10px;'>" + tabName2 + "</span>";
	        	tabText += "</p>";
	        	tabText += "<p id='FBoard_sub2'>";
	        	tabText += "<span id='1tab2' divname='FBoard_div2' name='FBoard_div' data1=\'" + tabType3 + "\' data2=\'" + tabName3 + "\' data5='0' style='margin-right:10px;'>" + tabName3 + "</span>";
	        	tabText += "</p>";
				
	        	document.getElementById("tab1").innerHTML = tabText;
				
                Tab1_NewTabIni("tab1");

               if(doNotRefresh !== true) {
              		document.getElementById("1tab0").setAttribute("class", "tabon");
              		Tab1_SelectID = "1tab0";	                    	
              		ChangeTab(document.getElementById("1tab0"));	
               }
	        }
	
	        function Tab1_MouseClick_more(obj, displayFlag) {
	            if (obj.className != "tabon") {
	
	                obj.className = "tabon";
	                if (obj.id != Tab1_SelectID) {
	                    if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null) {
	                        document.getElementById(Tab1_SelectID).className = "";
	                    }
	
	                    obj.className = "tabon";
	                    Tab1_SelectID = obj.id;
	                    selValue = obj.textContent;
	                    CurPage = 1;
	                }
	                if (!displayFlag) {
	                    document.getElementById("tabpart01UL").style.display = "";
	                } else {
	                    if (document.getElementById("tabpart01UL").style.display == "") {
	                        document.getElementById("tabpart01UL").style.display = "none";
	                    } else {
	                        document.getElementById("tabpart01UL").style.display = "";
	                    }
	                }
	            } else {
	                if (document.getElementById("tabpart01UL").style.display == "") {
	                    document.getElementById("tabpart01UL").style.display = "none";
		            } else {
	                    document.getElementById("tabpart01UL").style.display = "";
		            }
	            }
	        }
	        
	        function tabAllWidth() {
	            var allWidth = 0;
	            for (var i = 0; i < document.getElementById("tab1").getElementsByTagName("P").length; i++) {
	                allWidth += document.getElementById("tab1").getElementsByTagName("P")[i].offsetWidth;
	            }
	            return allWidth;
	        }
	
	        function ChangeTab(obj) {
	        	selectedObj = obj;
	        	selectedTabType = obj.getAttribute("DATA1");
	        	selectedTabId = obj.id;
	        	
	        	CurPage = 1;
	        	getResourceList();	
	        }
	
	        var Tab1_SelectID = "";
	        function Tab1_MouserOver(obj) {
	            obj.className = "tabover";
	        }
	        
	        function Tab1_MouserOut(obj) {
	            if (Tab1_SelectID != obj.id)
	                obj.className = "";
	        }
	        
	        function Tab1_MouseClick(obj) {
	            if(document.getElementById("tabpart01UL") != null)
	                document.getElementById("tabpart01UL").style.display = "none";
	            obj.className = "tabon";
	            if (obj.id != Tab1_SelectID) {
	                if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
	                    document.getElementById(Tab1_SelectID).className = "";
	
	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                ChangeTab(obj);
	            }
	        }
	        
	        function Tab1_MouseClick2(obj) {
	            ChangeTab(obj);
	            document.getElementById("tabpart01UL").style.display = "none";	            
	        }
	
	        function Tab1_NewTabIni(pTabNodeID) {
	            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	                if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
	                    if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };
	                        
	                        if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id != "overSpan")
	                            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };
	                        else
	                            document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick_more(this, true); };
	
	                        if (i == 0) {
	                            document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
	                            Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
	                        }
	                    }
	                }
	            }
	            
	            selectedObj = document.getElementById("1tab0");
	            selectedTabId = selectedObj.id;
	            selectedTabType = selectedObj.getAttribute("DATA1"); 
	        }
	        
	        function getResourceList() {
	        	ShowMailProgress();
	        	xmlhttp = createXMLHttpRequest();
	        	var xmlpara = createXmlDom();
	        	var objNode;
	        	createNodeInsert(xmlpara, objNode, "PARAMETER");
	        	createNodeAndInsertText(xmlpara, objNode, "STARTDATETIME", $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
	        	createNodeAndInsertText(xmlpara, objNode, "ENDDATETIME", $("#Sdatepicker2").datepicker({ dateFormat: 'yy-mm-dd' }).val());
	        	createNodeAndInsertText(xmlpara, objNode, "NOWTIME", getNowDate());
	        	xmlhttp.open("POST", "/admin/ezResource/scheduleGet.do?resID=" + TreeView.getvalue(TreeView.selectedIndex(), "DATA1") + "&pType=" + selectedTabType + "&page=" + CurPage, true);
	        	xmlhttp.onreadystatechange = getResourceList_after;
	        	xmlhttp.send(xmlpara);
	        }
	        
	        function getResourceList_after() {
	        	if (xmlhttp == null || xmlhttp.readyState != 4)
	            	return;
	        	if (xmlhttp.status >= 200 && xmlhttp.status < 300) {
	        		try {
	        			var listxml = xmlhttp.responseXML;
		            	var list = "<ROWS>";

		            	totalPage = Math.ceil(new Number(getNodeText(SelectNodes(listxml, "root/totalcount")[0]) / 20));
						
		            	if(totalPage == 0){
		                	if (document.getElementById("listviewheader") == null) {
		                		createListviewHeader();
		                	}
		                	var listheader = document.getElementById("listviewheader");
							document.getElementById("resourceList").innerHTML = ""
							var rows = listheader.getElementsByTagName('ROWS');
							Array.prototype.forEach.call(rows, function (row) {
								row.parentNode.removeChild(row);
							});
		                	var xmldom = xmlhttp.responseXML;
		                	var listview = new ListView();
		                	listview.SetID("resourceListView");
		                	listview.SetSelectFlag(false);
		                	listview.SetMulSelectable(false);
		                	listview.SetRowOnDblClick("show_Resource");
		                	listview.DataSource(listheader);
		                	listview.DataBind("resourceList");
		                	makePageSelPage();
		                	HiddenMailProgress();
		                	return;
		            	}

		            	if (CurPage > totalPage) {
			                CurPage--;
			                getResourceList();
			                HiddenMailProgress();
		                	return;
		            	}
		            	makePageSelPage();
		        		
		            	for (var i = 0; i < SelectNodes(listxml, "root/appointment").length; i++) {
			                list += "<ROW><CELL>";
		                	list += "<DATA1>" + getNodeText(SelectNodes(listxml, "num")[i]) + "</DATA1>";
		                	list += "<DATA2>" + getNodeText(SelectNodes(listxml, "pnum")[i]) + "</DATA2>";
		                	list += "<DATA3>" + getNodeText(SelectNodes(listxml, "ownerID")[i]) + "</DATA3>";
		                	list += "<DATA4>" + getNodeText(SelectNodes(listxml, "title")[i]) + "</DATA4>";
		                	list += "<DATA5>" + getNodeText(SelectNodes(listxml, "location")[i]) + "</DATA5>";
		                	list += "<DATA6>" + getNodeText(SelectNodes(listxml, "timeDisplay")[i]) + "</DATA6>";
		                	list += "<DATA7>" + getNodeText(SelectNodes(listxml, "startDate")[i]).substring(0, 10) + "</DATA7>";
		                	list += "<DATA8>" + getNodeText(SelectNodes(listxml, "endDate")[i]).substring(0, 10) + "</DATA8>";
		                	list += "<DATA9>" + getNodeText(SelectNodes(listxml, "alertTime")[i]) + "</DATA9>";
		                	list += "<DATA10>" + getNodeText(SelectNodes(listxml, "reFlag")[i]) + "</DATA10>";
		                	list += "<DATA11>" + getNodeText(SelectNodes(listxml, "gresFlag")[i]) + "</DATA11>";
		                	list += "<DATA12>" + getNodeText(SelectNodes(listxml, "writerID")[i]) + "</DATA12>";
		                	list += "<DATA13>" + getNodeText(SelectNodes(listxml, "importance")[i]) + "</DATA13>";
		                	list += "<DATA14>" + getNodeText(SelectNodes(listxml, "entryList")[i]) + "</DATA14>";
		                	list += "<DATA15>" + getNodeText(SelectNodes(listxml, "allDay")[i]) + "</DATA15>";
		                	list += "<DATA16>" + getNodeText(SelectNodes(listxml, "writeDay")[i]) + "</DATA16>";
		                	list += "<DATA17>" + getNodeText(SelectNodes(listxml, "attachFlag")[i]) + "</DATA17>";
		                	list += "<DATA18>" + getNodeText(SelectNodes(listxml, "characterID")[i]) + "</DATA18>";
		                	list += "<DATA19>" + getNodeText(SelectNodes(listxml, "approveFlag")[i]) + "</DATA19>";
		                	list += "<DATA20>" + getNodeText(SelectNodes(listxml, "returnFlag")[i]) + "</DATA20>";
		                	list += "<DATA21>" + getNodeText(SelectNodes(listxml, "useApprove")[i]) + "</DATA21>";
		                	list += "<DATA22>" + getNodeText(SelectNodes(listxml, "useReturn")[i]) + "</DATA22>";
		                	list += "<DATA23>" + getNodeText(SelectNodes(listxml, "nowDate")[i]) + "</DATA23>";
		                	list += "<DATA24>" + getNodeText(SelectNodes(listxml, "startDate")[i]) + "</DATA24>";
		                	list += "<DATA25>" + getNodeText(SelectNodes(listxml, "endDate")[i]) + "</DATA25>";
		                	list += "<DATA26>" + getNodeText(SelectNodes(listxml, "count")[i]) + "</DATA26></CELL>";
		                	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "approveFlag")[i]) + "</VALUE></CELL>";
		                	list += "<CELL><VALUE><![CDATA[" + getNodeText(SelectNodes(listxml, "title")[i]) + "]]></VALUE></CELL>";
		                	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "startDate")[i]).substring(0, 16) + "</VALUE></CELL>";
		                	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "endDate")[i]).substring(0, 16) + "</VALUE></CELL>";
		                	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "deptNM")[i]) + "</VALUE></CELL>";
		                	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "ownerNM")[i]) + "</VALUE></CELL>";
		                	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "reFlag")[i]) + "</VALUE></CELL>";
		                	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "returnFlag")[i]) + "</VALUE></CELL>";
		                	list += "<CELL><VALUE>" + getNodeText(SelectNodes(listxml, "writeDay")[i]).substring(0, 10) + "</VALUE></CELL></ROW>";
		                	returnFlagarr[i] = getNodeText(SelectNodes(listxml, "returnFlag")[i]);
		            	}
		            	list += "</ROWS>";

			            list = loadXMLString(list);
			            if (document.getElementById("listviewheader") == null) {
	                		createListviewHeader();
	                	}
						var listheader = document.getElementById("listviewheader");
						var rows = listheader.getElementsByTagName('ROWS');
						Array.prototype.forEach.call(rows, function (row) {
							row.parentNode.removeChild(row);
						});
		            	SelectSingleNode(listheader, "LISTVIEWDATA").appendChild(list.documentElement)

			            document.getElementById("resourceList").innerHTML = ""
		            	var xmldom = xmlhttp.responseXML;
		            	var listview = new ListView();
		            	listview.SetID("resourceListView");
		            	listview.SetSelectFlag(false);
		            	listview.SetMulSelectable(false);
		            	listview.SetRowOnDblClick("show_Resource");
		            	listview.DataSource(listheader);
		            	listview.DataBind("resourceList");
		            	HiddenMailProgress();

			            xmldom = null;
	        			
	        		} catch (e) {
	        			HiddenMailProgress();
	        			alert(e.message);
	        		}
	        	}
	        }
	        
	        function createListviewHeader() {
	        	var listview = "<xml id='listviewheader' style='display:none'><LISTVIEWDATA><HEADERS>" + 
    			"<HEADER><NAME><spring:message code='ezResource.t191'/></NAME><WIDTH>4%</WIDTH></HEADER>" +				      
    			"<HEADER><NAME><spring:message code='ezResource.t224'/></NAME><WIDTH>20%</WIDTH></HEADER>" + 
    			"<HEADER><NAME><spring:message code='ezResource.t202'/></NAME><WIDTH>10%</WIDTH></HEADER>" + 
    			"<HEADER><NAME><spring:message code='ezResource.t212'/></NAME><WIDTH>10%</WIDTH></HEADER>" +
    			"<HEADER><NAME><spring:message code='ezResource.t132'/></NAME><WIDTH>8%</WIDTH></HEADER>" +
    			"<HEADER><NAME><spring:message code='ezResource.t2003'/></NAME><WIDTH>5%</WIDTH></HEADER>" + 
    			"<HEADER><NAME><spring:message code='ezResource.t195'/></NAME><WIDTH>6%</WIDTH></HEADER>" + 
    			"<HEADER><NAME><spring:message code='ezResource.kmsr29'/></NAME><WIDTH>6%</WIDTH></HEADER>" + 
    			"<HEADER><NAME><spring:message code='ezResource.t2004'/></NAME><WIDTH>6%</WIDTH></HEADER></HEADERS></LISTVIEWDATA></xml>";
    			document.getElementById("resourceList").innerHTML = listview;
	        }
	        
	        function show_Resource(obj) {
		        var szNum = document.getElementById(obj).getAttribute("DATA1");
	        	var szOwnerID = document.getElementById(obj).getAttribute("DATA3");
	        	var pStartDate = document.getElementById(obj).getAttribute("DATA7");
	        	var pEndDate = document.getElementById(obj).getAttribute("DATA8");
	        	var szType = "Master";
	        	if (CrossYN()) {
		            var feature = GetOpenPosition(820, 700);
	            	window.open("/ezResource/scheduleRead.do?cmd=mod&from=schedule&" + "num=" + szNum + "&ownerID=" + szOwnerID + "&type=" + szType + "&startDate=" + pStartDate + "&endDate=" + pEndDate, "", "width=820, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        	} else {
	            	var feature = GetOpenPosition(790, 700);
	            	window.open("/ezResource/scheduleRead.do?cmd=mod&from=schedule&" + "num=" + szNum + "&ownerID=" + szOwnerID + "&type=" + szType + "&startDate=" + pStartDate + "&endDate=" + pEndDate, "", "width=770, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        	}
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
		            strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
		            PagingHTML += strtext;
	    	    } else {
	            	strtext = "<span class='btnimg first disabled'></span>"
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
	        	
	        	/* 2018.03.23 서주연 - #12123 데이터없는경우 페이지네이션 1이 없는 문제해결 */
	        	if (i == 1) {
		           	strtext = "<span class='on'>" + i + "</span>";
	                PagingHTML += strtext;
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
		        if (parseInt(pageNum - 1) > 0) {
	    	        goToPageByNum(parseInt(pageNum - 1));
		        } else {
	            	return;
		        }
	    	}
	    	
	    	function selafterBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	    	    goToPageByNum(pageNum);
	    	}
	    	
	    	function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum + 1) <= totalPage) {
	    	        goToPageByNum(parseInt(pageNum + 1));
		        } else {
	            	return;
		        }
	    	}
	    	
	    	function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		            CurPage = newPage;
	    	        getResourceList();
	        	}
	    	}
	    	
	    	function prevPage_onclick() {
		        newPage = parseInt(CurPage) - 1;
		        if (newPage > 0) {
	    	        CurPage = newPage;
	        	    getResourceList();
	        	}
	    	}
	    	
	    	function nextPage_onclick() {
		        newPage = parseInt(CurPage) + 1;
		        if (newPage <= parseInt(totalPage)) {
	    	        CurPage = newPage;
	        	    getResourceList();
	        	}
	    	}
	    	
	    	function getNowDate() {
	    		var date = new Date();
	    		var nowDate = date.getFullYear() +
	    		'-' + ((date.getMonth() + 1) < 9 ? "0" + (date.getMonth() + 1) : (date.getMonth() + 1)) +
	    		'-' + ((date.getDate()) < 9 ? "0" + (date.getDate()) : (date.getDate())) +
	    		" " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
	    
	    		return nowDate;
	    	}
	    	
	    	function btnRefresh_onclick() {
	    		getResourceList();
	    	}
	    	
	    	function search() {
	    		CurPage = 1;
	    		getResourceList();
	    	}
	    	
	    	function ShowMailProgress() {
	    		var CurrenWidth = document.documentElement.clientWidth;
	    		
	            document.getElementById("mailPanel").style.display = "";
	            document.getElementById("loadingProgress").style.top = "600px";
	            document.getElementById("loadingProgress").style.left = (CurrenWidth / 2) - 100 + "px";
	            document.getElementById("loadingProgress").style.display = "";
	            $("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%'></div>").appendTo(parent.frames[0].document.body);
		    }
	    	
		    function HiddenMailProgress() {
		    	document.getElementById("mailPanel").style.display = "none";
	        	document.getElementById("loadingProgress").style.display = "none";
	        	$(parent.frames[0].document.getElementById("blockLeft")).remove();
		    }
		</script>
	</head>
	<body>
		<div><h1 id="ToTitle" class="receiver_tltype01" style="padding: 10px 0px 10px 23px; font-size: 16px; border-bottom:1px solid #dddddd;"><spring:message code="ezResource.kwc01" /></h1></div>
		<div style="padding:0px 30px;">
			<div id="tab_menu_box" style="margin-top:15px">
				<div id="tab_menu_list">
					<div style="padding-left:10px; padding-right:10px">
					    <div class="portlet_tabnew01">
					        <div class="portlet_tabnew01_top noLine" id="tab1"></div>
					    </div>
					</div>    
				</div>
			</div>
		
			<div style="height: 450px; width: 100%; margin-top:15px;">
				<table style="border-collapse: collapse; width: 100%;">
					<tbody>
						<tr>
							<td style="width: 220px; min-width: 220px; vertical-align:top;">
								<div>
									<div id="folderTree" style="width: 220px; height: 450px; border: 1px solid #ddd; overflow: hidden; padding: 5px 0px 0px 5px;">
										<div id="TreeView" data="select" valign="top" style="height:450px; overflow-x:hidden; overflow-y:auto;
								   			padding-left: 0px;" onrequestdata="TreeView_onNodeExpanded(event);"  onnodeselect="TreeView_onNodeClick();"
											onnodedblclick="TreeView.toggle(TreeView.selectedIndex)" >
										</div>
									</div>
								</div>
									<input type="hidden" id="curTabID" namd="curTabID" value=""/>
							</td>
							<td style="vertical-align:top;">
								<input type="text" id="Sdatepicker" class="hasDatapicker" style="width: 100px; text-align: center; margin-left:15px" readonly="readonly" /> ~ 
								<input type="text" id="Sdatepicker2" class="hasDatapicker" style="width: 100px; text-align: center;" readonly="readonly" />
								<a class="imgbtn" style="margin-left:7px;">
									<span onclick="javascript:search();"><spring:message code="ezResource.kwc02"></spring:message></span>
								</a>
								<div id="resourceList" style="height:430px; margin-left:10px; margin-top:5px; border: 1px solid #ddd; overflow:auto;">
									<xml id="listviewheader" style="display:none">
										<LISTVIEWDATA>
							    			<HEADERS>
							        			<HEADER>
							            			<NAME><spring:message code='ezResource.t191'/></NAME>
							            			<WIDTH>4%</WIDTH>
							        			</HEADER>   
							        			<HEADER>
							            			<NAME><spring:message code='ezResource.t224'/></NAME>
							            			<WIDTH>20%</WIDTH>
							        			</HEADER>
							        			<HEADER>
							            			<NAME><spring:message code='ezResource.t202'/></NAME>
							            			<WIDTH>10%</WIDTH>
							        			</HEADER>
							        			<HEADER>
							            			<NAME><spring:message code='ezResource.t212'/></NAME>
							            			<WIDTH>10%</WIDTH>
							        			</HEADER>
							        			<HEADER>
							            			<NAME><spring:message code='ezResource.t132'/></NAME>
							            			<WIDTH>8%</WIDTH>
							        			</HEADER>  
							        			<HEADER>
							            			<NAME><spring:message code='ezResource.t2003'/></NAME>
							            			<WIDTH>5%</WIDTH>
							        			</HEADER>  
							        			<HEADER>
							            			<NAME><spring:message code='ezResource.t195'/></NAME>
							            			<WIDTH>6%</WIDTH>
							        			</HEADER>
							        			<HEADER>
							            			<NAME><spring:message code='ezResource.kmsr29'/></NAME>
							            			<WIDTH>6%</WIDTH>
							        			</HEADER> 
							        			<HEADER>
							            			<NAME><spring:message code='ezResource.t2004'/></NAME>
							            			<WIDTH>6%</WIDTH>
							        			</HEADER> 					
							    			</HEADERS>
										</LISTVIEWDATA>
									</xml>
								</div>
								<div id="tblPageRayer" style="text-align:center"></div>
							</td>						
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<%-- 로딩 이미지 표출 영역 --%>
		<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingProgress">
        	<img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
    	</div>
    	<form name="brds">
            <input type="hidden" id="proc" name="proc" value="STATUS">
        </form>
	</body>
</html>