<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t84" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e2', 'msg')}" type="text/css">
		<style>
	    	.mainlist_free tr th {
	    		border-top: 0px;
	    	}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezOrgan/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/admin.css')}">
		<script type="text/javascript">
			var topid = "<c:out value='${topid}'/>";
		    var useOCS = "<c:out value='${useOCS}'/>";
		    var g_xmlHTTP = null;
		    var useBizmekaSpambox = "${useBizmekaSpambox}";
		    var userinfo_dialogArguments = new Array();
		    var useDisablePopImap = "";
		    var deptTreeTopId = "${deptTreeTopId}";
		    var changePassLength = 0;
			var totalPage = "";
			var BlockSize = 10;
			var pageNum = 1;
			var PageSize = 15;
			
		    document.onselectstart = function(){
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA"){
		            return false;
		        }else{
		            return true;
		        }
		    };
		    
		    $(document).ready(function(){
		    	getDeptFullTree(topid);
				
				if (topid != "Top"){
					companybutton1.style.display = "none";
					companybutton2.style.display = "none";
					companybutton3.style.display = "none";
				}
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
				windowResize();
			});

			window.onresize = function(event) {
				windowResize();
			};

			function Tree_setconfig(){
			    var xmlHTTP = createXMLHttpRequest();
			    xmlHTTP.open("GET", "/xml/common/organtree_config3.xml", false);			    
			    xmlHTTP.send();
			    if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200){
			        var treeView = new TreeView();
			        treeView.SetConfig(xmlHTTP.responseXML);
			    }
			}		    
		    
		    function getDeptFullTree(deptid){
			    g_xmlHTTP = createXMLHttpRequest();
				var strQuery = "<DATA><DEPTID>" + deptid + "</DEPTID><TOPID>" + deptTreeTopId + "</TOPID><PROP>extensionAttribute1;extensionAttribute2;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";

				g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
				g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
				g_xmlHTTP.send(strQuery);
			}
		    
			function event_getDeptFullTree(){
				if(g_xmlHTTP != null && g_xmlHTTP.readyState == 4){
					if (g_xmlHTTP.statusText == "OK"){
					    Tree_setconfig();
		                document.getElementById("TreeView").innerHTML = "";
					    var treeView = new TreeView();
					    treeView.SetID("FromTreeView");
					    treeView.SetUseAgency(true);
					    treeView.SetRequestData("TreeViewRequestData");
					    treeView.SetNodeClick("TreeViewNodeClick");
					    treeView.SetNodeDblClick("TreeViewNodeDbClick");
					    treeView.DataSource(g_xmlHTTP.responseXML);
					    treeView.DataBind("TreeView");
					}else{	
						alert("<spring:message code='ezOrgan.t1' />" + g_xmlHTTP.statusText);
						g_xmlHTTP = null;
					}
				}
			}			
			
			function TreeViewRequestData(pNodeID, pTreeID) {
		        document.getElementById("TreeView").style.height = "509px";
		        var TreeIdx = pNodeID;

			    var treeNode = new TreeNode();
			    treeNode.LoadFromID(TreeIdx);

			    var deptID = treeNode.GetNodeData("CN");
			    GetDeptSubTreeInfo(deptID, TreeIdx);
			    document.getElementById("TreeView").style.height = "510px";
			}
			
			function GetDeptSubTreeInfo(deptID, TreeIdx) {
			    var xmlHTTP = createXMLHttpRequest();
			    var xmlRtn = createXmlDom();
			    var xmlpara = createXmlDom();

			    var objNode;
			    createNodeInsert(xmlpara, objNode, "DATA");
			    createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptID);
			    createNodeAndInsertText(xmlpara, objNode, "PROP", "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName");
			    
			    xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
			    xmlHTTP.send(xmlpara);
			    xmlRtn = loadXMLString(xmlHTTP.responseText);
			    
			    if (SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0) {
			        if (CrossYN()){
			            xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
			        }else{
			            xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
			        }
			    }

			    var treeView = new TreeView();
			    treeView.LoadFromID("FromTreeView");
			    treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
			}
			
			function TreeViewNodeClick() {
			    var nodeIdx = 1;
			    var treeView = new TreeView();
			    treeView.LoadFromID("FromTreeView");
			    var selnode = treeView.GetSelectNode();
			    DeptID = selnode.GetNodeData("CN");
			    displayUserList(DeptID);
			}
			
			function TreeViewNodeDbClick(){
			    return;
			}			
			
			function displayUserList(DeptID){
				var cellContent;
				var typeContent;

				if (listOpt1.checked == true){
					cellContent = "extensionAttribute9;displayname;cn;description;title;extensionAttribute10";
					typeContent = "userWithMasterAdmin";
				}else{
					cellContent = "displayname;extensionAttribute9";
					typeContent = "group";
				}
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/ezOrgan/getDeptMemberList.do",
					data : {
							deptID : DeptID,
							cell : cellContent,
							prop : "userType",
							type : typeContent
					},
					success : function(xml){
						result=loadXMLString(xml);
						var headerData = createXmlDom();

						if (listOpt1.checked == true){
							headerData = loadXMLString(listviewheader1.innerHTML.toUpperCase());
							$("#maillist_user").css("display", "");
							$("#maillist_dept").css("display", "none");
						} else {
							headerData = loadXMLString(listviewheader2.innerHTML.toUpperCase());
							$("#maillist_user").css("display", "none");
							$("#maillist_dept").css("display", "");
						}

						if (listOpt1.checked == true) {
							// 암호관리, 사원이동, 퇴직 cell append
							var cnt = result.getElementsByTagName('ROWS')[0].childElementCount;
							var i = 0;
							for(i;i<cnt;i++) {
								var cell1 = result.createElement("CELL");
								var value1 = result.createElement("VALUE");
								cell1.appendChild(value1);
								var cell2 = result.createElement("CELL");
								var value2 = result.createElement("VALUE");
								cell2.appendChild(value2);
								var cell3 = result.createElement("CELL");
								var value3 = result.createElement("VALUE");
								cell3.appendChild(value3);
								result.getElementsByTagName("ROW")[i].appendChild(cell1);
								result.getElementsByTagName("ROW")[i].appendChild(cell2);
								result.getElementsByTagName("ROW")[i].appendChild(cell3);
							}
						} else {
							var cnt = result.getElementsByTagName('ROWS')[0].childElementCount;
							var i = 0;
							for(i;i<cnt;i++) {
								var cell1 = result.createElement("CELL");
								var value1 = result.createElement("VALUE");
								cell1.appendChild(value1);
								result.getElementsByTagName("ROW")[i].prepend(cell1);
							}
						}

				        if (CrossYN()) {
				            var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
				            $(xmlRtn.getElementsByTagName("ROW")).each(function(index){
				            	if($(this).find("DATA3").text() == "addJob"){
				            		var orgPosition = $(this).find("CELL").eq(2).find("VALUE").text();
				            		$(this).find("CELL").eq(2).find("VALUE").text("<spring:message code='ezOrgan.psb03'/>"+" "+orgPosition);
				            	}
				            });
				            var Node = headerData.importNode(xmlRtn, true);
				            headerData.documentElement.appendChild(Node);
				        }else{
				            var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
				            headerData.documentElement.appendChild(xmlRtn);
				        }
		                document.getElementById("OrganListView").innerHTML = "";

						var pUserList = new ListView();
						pUserList.SetID("lvUserList");
						pUserList.SetMulSelectable(true);
						pUserList.SetRowOnDblClick("info_user");
						pUserList.SetSelectFlag(false);
						pUserList.SetHeightFree(true);
						pUserList.DataSource(headerData);
						pUserList.DataBind("OrganListView");
						if (listOpt1.checked == true) {
							sawonDataParsing();
						}
						moveDisplay(false);
					},
					error : function(error){
						alert("<spring:message code='ezOrgan.t2'/>" + error);	
					}
				});	
			}			
			
			function add_company(){
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

				if (treeNode.selectedIndex == -1){
					alert("<spring:message code='ezOrgan.t3' />");
					return;
				}
				
				var args = new Array();
				args[0] = treeNode.GetNodeData("CN");
				args[1] = "";
				
			    if (CrossYN()){
			        companyinfo_dialogArguments[0] = args;
			        companyinfo_dialogArguments[1] = add_company_Complete;
			        var OpenWin = window.open("/admin/ezOrgan/companyInfo.do", "CompanyInfo", GetOpenWindowfeature(328, 260));
			        try { OpenWin.focus(); } catch (e) { }
			    }else{
			        var rtnValue = window.showModalDialog("/admin/ezOrgan/companyInfo.do", treeNode.GetNodeData("CN"), "dialogHeight:230px; dialogWidth:328px; scroll:no;status:no; help:no; edge:sunken" + GetShowModalPosition(328, 260));

			        if (typeof (rtnValue) != "undefined"){
			            getDeptFullTree(rtnValue);
			        }
			    }
			}

			var companyinfo_dialogArguments = new Array();
		    function add_company_Complete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
		            getDeptFullTree(rtnValue);
		        }
		    }		    
		    
		    function info_company(){
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

				if (treeNode.selectedIndex == -1){
					alert("<spring:message code='ezOrgan.x0004' />");
					return;
				}

				if (treeNode.GetNodeData("CN") != treeNode.GetNodeData("EXTENSIONATTRIBUTE2")){
					alert("<spring:message code='ezOrgan.x0004' />");
					return;
				}

				var args = new Array();
				args[0] = treeNode.GetNodeData("CN");
				args[1] = treeNode.GetNodeData("VALUE");
				
				if (CrossYN()) {
				    companyinfo_dialogArguments[0] = args;
				    companyinfo_dialogArguments[1] = info_company_Complete;
				    
                    var OpenWin = window.open("/admin/ezOrgan/companyInfo.do", "CompanyInfo", GetOpenWindowfeature(328, 260));
				    
				    try { OpenWin.focus(); } catch (e) { }
				} else {
                    var rtnValue = window.showModalDialog("/admin/ezOrgan/companyInfo.do", args, "dialogHeight:480px; dialogWidth:335px; scroll:no;status:no; help:no; edge:sunken" + GetShowModalPosition(335, 270));

				    if (typeof (rtnValue) != "undefined") {
				        alert("<spring:message code='ezOrgan.x0005' />");
				        getDeptFullTree(rtnValue);
				    }
				}
			}
		    
		    function info_company_Complete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
		            alert("<spring:message code='ezOrgan.x0005' />");
		            getDeptFullTree(rtnValue);
		        }
		    }
		    
		    var deptinfo_dialogArguments = new Array();
		    
			function add_dept(){
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

				if (treeNode.selectedIndex == -1){
					alert("<spring:message code='ezOrgan.t4' />");
					return;
				}

				var args = new Array();
				args[0] = treeNode.GetNodeData("CN");
				args[1] = "";
				
				if (CrossYN()) {
				    deptinfo_dialogArguments[0] = args;
				    deptinfo_dialogArguments[1] = add_dept_Complete;
				    
				    var OpenWin = window.open("/admin/ezOrgan/deptInfo.do", "DeptInfo", GetOpenWindowfeature(335, 320));
				    
				    try { OpenWin.focus(); } catch (e) { }
				}else{
				    var rtnValue = window.showModalDialog("/admin/ezOrgan/deptInfo.do", args,"dialogHeight:320px; dialogWidth:335px; scroll:no;status:no; help:no; edge:sunken" + GetShowModalPosition(335, 320));
                    
				    if (typeof (rtnValue) != "undefined"){
				        getDeptFullTree(rtnValue);
				    }
				}
			}
			
		    function add_dept_Complete(rtnValue){
		        if (typeof (rtnValue) != "undefined"){
		            getDeptFullTree(rtnValue);
		        }
		    }		    
		    
		    function del_company(){
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

				if (treeNode.selectedIndex == -1){
					alert("<spring:message code='ezOrgan.t64' />");
					return;
				}
				if(treeNode.GetNodeData("EXTENSIONATTRIBUTE2") != treeNode.GetNodeData("CN")){
					alert("'" + treeNode.GetNodeData("VALUE") + "'<spring:message code='ezOrgan.t65' />");
					return;
				}
				if (!confirm("'" + treeNode.GetNodeData("VALUE") + "'<spring:message code='ezOrgan.t35' />")){
					return;
				}
				
				$.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezOrgan/delDept.do",
		        	async : false,
		        	data : {cn : treeNode.GetNodeData("CN")},
		        	success : function(result){
		        		if (result == "HASCHILD"){
		        			alert("<spring:message code='ezOrgan.t37' />");
		        		}else if (result == "EMAIL_ERROR") {
		        			alert("'" + treeNode.GetNodeData("VALUE") + "'<spring:message code='ezOrgan.t66' />");
		        		}else{
		        			alert("'" + treeNode.GetNodeData("VALUE") + "'<spring:message code='ezOrgan.t38' />");
							getDeptFullTree(topid);
		        		}
		        	},
		        	error : function(error){
		        		alert("'" + treeNode.GetNodeData("VALUE") + "'<spring:message code='ezOrgan.t66' />");
		        	}
				});
			}		    
		    
		    function info_dept(){
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

				if (treeNode.selectedIndex == -1){
					alert("<spring:message code='ezOrgan.t5' />");
					return;
				}

				if (treeNode.GetNodeData("CN") == treeNode.GetNodeData("EXTENSIONATTRIBUTE2")){
					alert("<spring:message code='ezOrgan.t6' />");
					return;
				}

				var args = new Array();
				args[0] = treeNode.GetNodeData("CN");
				args[1] = treeNode.GetNodeData("VALUE");
				
				if (CrossYN()) {
				    deptinfo_dialogArguments = new Array();
				    deptinfo_dialogArguments[0] = args;
				    deptinfo_dialogArguments[1] = info_dept_Complete;
				    
				    var OpenWin = window.open("/admin/ezOrgan/deptInfo.do", "DeptInfo", GetOpenWindowfeature(335, 320));
				    
				    try { OpenWin.focus(); } catch (e) { }
				}else {
				    var rtnValue = window.showModalDialog("/admin/ezOrgan/deptInfo.do", args, "dialogHeight:320px; dialogWidth:335px; scroll:no;status:no; help:no; edge:sunken" + GetShowModalPosition(335, 320));

				    if (typeof (rtnValue) != "undefined") {
				        alert("<spring:message code='ezOrgan.t7' />");
				        getDeptFullTree(rtnValue);
				    }
				}
			}
		    
		    function info_dept_Complete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
		            alert("<spring:message code='ezOrgan.t7' />");
		            getDeptFullTree(rtnValue);
		        }
		    }
		    
		    function del_dept(){
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

				if (TreeView.selectedIndex == -1){
					alert("<spring:message code='ezOrgan.t32' />");
					return;
				}
		        // 표준모듈 (2007.02.22) 수정 : 회사 삭제 되지 않도록 처리
				if(treeNode.GetNodeData("EXTENSIONATTRIBUTE2") == treeNode.GetNodeData("CN")){
					alert("'" + treeNode.GetNodeData("VALUE") + "'<spring:message code='ezOrgan.t34' />");
					return;
				}
				if (!confirm("'" + treeNode.GetNodeData("VALUE") + "'<spring:message code='ezOrgan.t35' />")){
					return;
				}
				
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/delDept.do",
					async : false,
					data : {cn : treeNode.GetNodeData("CN")},
					success : function(result){
						if (result == "HASCHILD"){
							alert("<spring:message code='ezOrgan.t37' />");
						}else if (result == "EMAIL_ERROR") {
		        			alert("'" + treeNode.GetNodeData("VALUE") + "'<spring:message code='ezOrgan.t36' />");
		        		}else{
							alert("'" + treeNode.GetNodeData("VALUE") + "'<spring:message code='ezOrgan.t38' />");
							getDeptFullTree(topid);
						}
					},
					error : function(){
						alert("'" + treeNode.GetNodeData("VALUE") + "'<spring:message code='ezOrgan.t36' />");
					}
				});				
			}
		    
		    function mov_dept(){
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

				if (treeNode.selectedIndex == -1){
					alert("<spring:message code='ezOrgan.t17' />");
					return;
				}
				if (treeNode.GetNodeData("CN") == treeNode.GetNodeData("EXTENSIONATTRIBUTE2")){
					alert("<spring:message code='ezOrgan.t18' />");
					return;
				}
			    
			    //2016-04-12 장진혁과장 -- cross 팝업만 이용하도록 수정 및 소스추가
			    document.getElementById("selectedCN").value = treeNode.GetNodeData("CN");
			    document.getElementById("selectedValue").value = treeNode.GetNodeData("VALUE");
			    
		        selectdept_cross_dialogArguments = new Array();
		        selectdept_cross_dialogArguments[0] = "<spring:message code='ezOrgan.t19' />";
		        selectdept_cross_dialogArguments[1] = mov_dept_CompleteWithTimeout;
		        var OpenWin = window.open("/admin/ezOrgan/selectDept.do", "SelectDept_Cross", GetOpenWindowfeature(302, 390));		        
		        try { OpenWin.focus(); } catch (e) { }			    
			}
		    function mov_dept_CompleteWithTimeout(rtnValue) {
		    	 setTimeout(function() {
		    		 mov_dept_Complete(rtnValue);
	                }, 10);
		    }
		    
		    function GetDeptFullPath(DeptID, topid){
		    	var data;
		    	
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/ezOrgan/getDeptFullPath.do",
					async : false,
					data : {cn : DeptID},
					success : function(result){
						data = result						
					}
				});
				
				return data;				
			}

		    function mov_dept_Complete(rtnValue) {
		    	var selectedCN = document.getElementById("selectedCN").value;
		    	var selectedValue = document.getElementById("selectedValue").value;
		    	
		        if (typeof (rtnValue) != "undefined") {
		        	//2016-04-12 장진혁과장 --동일한 부서로 이동불가
		            if (rtnValue.toLowerCase() == selectedCN.toLowerCase()) {
		                alert("<spring:message code='ezOrgan.t21' />");
		                return;
		            }
					//2016-04-12 장진혁과장 --AD 체크부분 주석
 		            /* if (rtnValue.toLowerCase() == GetAdInfos(selectedCN, "EXTENSIONATTRIBUTE1").toLowerCase()) {
		                alert("<spring:message code='ezOrgan.t20' />");
		                return;
		            } */

		            //2016-04-12 장진혁과장 --자신의 하위 부서로 이동불가
		            var arrDeptPath = GetDeptFullPath(rtnValue, topid).split(",");
		            for (var iCnt = 0 ; iCnt < arrDeptPath.length ; iCnt++) {
		                if (arrDeptPath[iCnt] == selectedCN) {
		                    alert("<spring:message code='ezOrgan.t23' />");
		                    return;
		                }
		            }
		            if (!confirm("'" + selectedValue + "'<spring:message code='ezOrgan.t24' />")){
		                return;
		            }
		           		            
		            $.ajax({
		            	type : "POST",
		            	dataType : "html",
		            	url : "/admin/ezOrgan/movDept.do",
		            	async : false,
		            	data : {parentCn : rtnValue, cn : selectedCN},
		            	success : function(result) {
		            		if (result == "SAME") {
		            			alert("<spring:message code='ezOrgan.t21' />");
		            		} else if (result == "DIFF_COMPANY") {
		            			alert("<spring:message code='ezOrgan.lhm4' />");
		            		} else if (result == "EMAIL_ERROR") {
		            			alert("'" + selectedValue + "'<spring:message code='ezOrgan.t25' />");
		            		} else {
		            			alert("'" + selectedValue + "'<spring:message code='ezOrgan.t27' />");
				                getDeptFullTree(selectedCN);
		            		}
		            	},
		            	error : function() {
		            		alert("'" + selectedValue + "'<spring:message code='ezOrgan.t25' />");
		            	}
		            });
		        }
		    }
		    
		    function search_press(){
				if (window.event.keyCode == "13"){
					search_click();
				}
			}

			function deptsearch_press(){			
				if (window.event.keyCode == "13"){
					deptsearch_click();
				}
			}
			
		    var rgParams = new Array();
		    var checkname2_cross_dialogArguments = new Array();
		    
			function deptsearch_click(){
				if ($.trim(document.getElementById("deptkeyword").value) == ""){
					alert("<spring:message code='ezOrgan.t56' />");
				    document.getElementById("deptkeyword").focus();
					return;
				}
				
				var xmlDOM = createXmlDom();
				
			    $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : false,
		        	data : {search : "displayname::" + document.getElementById("deptkeyword").value, cell : "extensionAttribute3;displayName;extensionAttribute9", prop : "", type : "group", adminOrgan : "y"},
		        	success : function(result){	
		        		xmlDOM = loadXMLString(result);
		                adCount = xmlDOM.getElementsByTagName("ROW").length;
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezOrgan.t60' />" + xmlHTTP.statusText);
		        		xmlDOM = null;
		        	}
		        });		        	
			    var ModalCheck = false;
				if (adCount == 0){
					alert("<spring:message code='ezOrgan.t61' />");
					return;
				}else if (adCount == 1){
				    g_xmlHTTP = createXMLHttpRequest();
				    var strQuery = "<DATA><DEPTID>" + getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]) + "</DEPTID><TOPID>" + deptTreeTopId + "</TOPID><PROP>extensionAttribute1;extensionAttribute2;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";
				    g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
					g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
					g_xmlHTTP.send(strQuery);
				}else{
					rgParams["addrBook"] = xmlDOM;
					rgParams["deptid"] = "";
					
					if (CrossYN()) {
					    ModalCheck = true;
					    checkname2_cross_dialogArguments[0] = rgParams;
					    checkname2_cross_dialogArguments[1] = deptsearch_click_Complete;
					    var OpenWin = window.open("/admin/ezOrgan/checkName2.do", "checkName2_Cross", GetOpenWindowfeature(600, 320));					    
					    try { OpenWin.focus(); } catch (e) { }
					}else{
					    window.showModalDialog("/admin/ezOrgan/checkName2.do", rgParams, "dialogHeight:340px; dialogWidth:598px; status:no;scroll:no; help:no; edge:sunken" + GetShowModalPosition(600, 320));

					    if (rgParams["deptid"] != "") {
					        g_xmlHTTP = createXMLHttpRequest();
					        // 20110412 사용자 추가시 필요 정보 추가처리.
					        var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + deptTreeTopId + "</TOPID><PROP>extensionAttribute1;extensionAttribute2;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";					        
					        g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
					        g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
					        g_xmlHTTP.send(strQuery);
					    }
					}
				}
			    if(!ModalCheck){
			        document.getElementById("deptkeyword").value = "";
			    }
			}
			
		    function deptsearch_click_Complete() {
		        if (rgParams["deptid"] != "") {
		            g_xmlHTTP = createXMLHttpRequest();
		            var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>" + deptTreeTopId + "</TOPID><PROP>extensionAttribute1;extensionAttribute2;displayName</PROP><DISPLAYTRASHDEPT>true</DISPLAYTRASHDEPT></DATA>";		            
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		        document.getElementById("deptkeyword").value = "";
		    }

			var searchWord = "";
			var searchType = "";
			function search_click(){
				pageNum = 1;
				if ($.trim(keyword.value) == ""){
					alert("<spring:message code='ezOrgan.t56' />");
					keyword.focus();
					return;
				}

				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/ezOrgan/getSearchList.do",
					async : false,
					data : {
						search : search_type.value + "::" + keyword.value,
						cell : "extensionAttribute9;displayName;cn;description;title;extensionAttribute10",
						prop : "department",
						type : "user",
						page : pageNum,
						adminOrgan : "y"
					},
					success : function(xml){
						searchWord = keyword.value;
						searchType = search_type.value;
						result=loadXMLString(xml);
						var listview = new ListView();
						listview.LoadFromID("lvUserList");

						// 전체페이지 처리
						var totCount = result.getElementsByTagName('TOTALCOUNT')[0].innerHTML;
						totalPage = Math.ceil((totCount)/10);
						if(totalPage == 0) {
							totalPage = 1;
						}

						// 암호관리, 사원이동, 퇴직 cell append
						var cnt = result.getElementsByTagName('ROWS')[0].childElementCount;
						var i = 0;
						for(i;i<cnt;i++) {
							var cell1 = result.createElement("CELL");
							var value1 = result.createElement("VALUE");
							cell1.appendChild(value1);
							var cell2 = result.createElement("CELL");
							var value2 = result.createElement("VALUE");
							cell2.appendChild(value2);
							var cell3 = result.createElement("CELL");
							var value3 = result.createElement("VALUE");
							cell3.appendChild(value3);
							result.getElementsByTagName("ROW")[i].appendChild(cell1);
							result.getElementsByTagName("ROW")[i].appendChild(cell2);
							result.getElementsByTagName("ROW")[i].appendChild(cell3);
						}

						var headerData = createXmlDom();
						headerData = loadXMLString(listviewheader1.innerHTML.toUpperCase());
						$("#maillist_user").css("display", "");
						$("#maillist_dept").css("display", "none");

				        if (CrossYN()) {
				            var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
				            var Node = headerData.importNode(xmlRtn, true);
				            headerData.documentElement.appendChild(Node);
				        }else{
				            var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
				            headerData.documentElement.appendChild(xmlRtn);
				        }
		                document.getElementById("OrganListView").innerHTML = "";

						var pUserList = new ListView();
						pUserList.SetID("lvUserList");
						pUserList.SetRowOnDblClick("info_user");
						pUserList.SetSelectFlag(false);
						pUserList.SetHeightFree(true);
						pUserList.DataSource(headerData);
						pUserList.DataBind("OrganListView");
						sawonDataParsing();
						moveDisplay(true);
						makePageSelPage();
					},
					error : function(error){
						alert("<spring:message code='ezOrgan.t59' />" + error);
					}
		        });				
				// [2006. 02. 10. 이민수] 검색을 완료하면 TextBox를 초기화하도록 변경
				//keyword.value = "";
			}
		    
		    function mail_manage(){
		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");

		        if (listview.GetSelectedRows().length == 0) {
					alert("<spring:message code='ezOrgan.t50' />");
					return;
				} else if (listview.GetSelectedRows()[0].getAttribute("DATA1") != 'user') {
                    alert(strLang13);
                    return;
			    } else if (listview.GetSelectedRows().length > 1) {
					alert("<spring:message code='ezOrgan.t51' />");
					return;
				} else if (listview.GetSelectedRows()[0].getAttribute("DATA3") == 'addJob'){
		    		alert("<spring:message code='ezOrgan.psb02' />");
					return;
			    }

			    window.open("/admin/ezOrgan/configEmail.do?id=" + GetAttribute(listview.GetSelectedRows()[0],"DATA2"), "", "height=315px,width=462px,status=no,toolbar=no,menubar=no,location=no,resizable=1" + GetOpenPosition(462, 315));
			}

			function Change_List(){
				var treeView = new TreeView();
				treeView.LoadFromID("FromTreeView");
				var nodeIdx = treeView.GetSelectNode();
				var treeNode = new TreeNode();
				treeNode.LoadFromID(nodeIdx.NodeID);

/* 				usermenu3.disabled = false;
				usermenu4.disabled = false;
				usermenu6.disabled = false;
				usermenu7.disabled = false;
				usermenu8.disabled = false; */

				try {
					usermenu9.disabled = false;
				} catch (e) { }
				usermenu10.disabled = false;
				//usermenu13.disabled = false;
				if(useOCS == "YES"){
					usermenusipuri.disabled = false;
				}

				if (TreeView.selectedIndex != -1){
					displayUserList(treeNode.GetNodeData("CN"));
				}
			}

			function MoveUp_onclick(){
		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");

			    listview.RowMoveUp();
			}
			
			function MoveDown_onclick(){
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");

			    listview.RowMoveDown();
			}
			
			function MoveConfirm_onclick(){
				var objNode = "";
				var pClass = "";
			    var treeView = new TreeView();
			    treeView.LoadFromID("FromTreeView");
			    var nodeIdx = treeView.GetSelectNode();			    
			    var treeNode = new TreeNode();
			    treeNode.LoadFromID(nodeIdx.NodeID);
			    var userType = "";

		        var listview = new ListView();		        
		        listview.LoadFromID("lvUserList");

				if (listview.GetDataRows().length == 0){
					return;
				}

				for (var i = 0 ; i < listview.GetDataRows().length ; i++){
					objNode += listview.GetDataRows()[i].getAttribute("DATA2");
					userType += listview.GetDataRows()[i].getAttribute("DATA3");
					
					if(i != listview.GetDataRows().length){
						objNode += ",";
						userType +=",";
					}
				}

				if (listOpt1.checked == true){
					pClass = "user";
				} else {
					pClass = "dept";
				}
				
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/saveOrderList.do",
					async : false,
					data : {cn : objNode, pClass : pClass, userType : userType , deptId : DeptID},
					success : function(result){
						alert("<spring:message code='ezOrgan.t49' />");
						getDeptFullTree(treeNode.GetNodeData("CN"));
					},
					error : function(){
						alert("<spring:message code='ezOrgan.t48' />");
					}
				});
			}
			
			function showProgress() {
			    document.getElementById("progressPanel").style.display = "";
			    document.getElementById("loadingLayer").style.display = "";
			    
			    parent.document.getElementById("lef").contentWindow.showProgress();
			}

			function hideProgress() {
			    document.getElementById("progressPanel").style.display = "none";
			    document.getElementById("loadingLayer").style.display = "none";
			    
			    parent.document.getElementById("lef").contentWindow.hideProgress();
			}
			
			function add_user(){
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

				if (treeNode.selectedIndex == -1){
					alert("<spring:message code='ezOrgan.t8' />");
					return;
				}
				var args = new Array();
				args[0] = treeNode.GetNodeData("CN");
				args[1] = treeNode.GetNodeData("DISPLAYNAME1");
				args[2] = "";
				args[3] = treeNode.GetNodeData("DISPLAYNAME2");
				args[4] = treeNode.GetNodeData("EXTENSIONATTRIBUTE2");
				args[5] = "";
				
				//2016-04-19 장진혁과장 -- Cross 버전 사용으로 주석 처리
				//if (CrossYN()) {
			    userinfo_dialogArguments[0] = args;
			    userinfo_dialogArguments[1] = add_user_Complete;
			    var OpenWin = window.open("/admin/ezOrgan/userInfo.do", "UserInfo", GetOpenWindowfeature(930, 550));
			    try { OpenWin.focus(); } catch (e) { }
				/* }else{
				    var rtnValue;
				    rtnValue = window.showModalDialog("UserInfo.aspx", args,
		                "dialogHeight:500px; dialogWidth:830px; scroll:yes;status:no; help:no; edge:sunken" + GetShowModalPosition(830, 520));

				    if (typeof (rtnValue) != "undefined") {
				        displayUserList(rtnValue);
				    }
				} */
			}
			
		    function add_user_Complete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
		            displayUserList(rtnValue);
		        }
		    }
		    
			function info_user() {
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);
		              
		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");

				if (listview.GetSelectedRows().length == 0) {
					alert("<spring:message code='ezOrgan.t9' />");
					return;
				} else if (listview.GetSelectedRows()[0].getAttribute("DATA1") != 'user') {
                    alert(strLang13);
                    return;
		        } if (listview.GetSelectedRows().length > 1) {
					alert("<spring:message code='ezOrgan.t10' />");
					return;
				}
		        
				var args = new Array();
				args[0] = treeNode.GetNodeData("CN");
				
				// 수정(2007.06.26) : 사용자 추가 시 부서명(P/S)이 제대로 보이지 않는 문제 수정
				args[1] = treeNode.GetNodeData("DISPLAYNAME1");
				args[2] = listview.GetSelectedRows()[0].getAttribute("DATA2");
				args[3] = treeNode.GetNodeData("DISPLAYNAME2");
				args[4] = treeNode.GetNodeData("EXTENSIONATTRIBUTE2");
				args[5] = listview.GetSelectedRows()[0].getAttribute("DATA3");
				
				//2016-04-18 장진혁과장 -- Cross 버전 사용으로 인한 주석처리
				//if (CrossYN()) {
			    userinfo_dialogArguments = new Array();
			    userinfo_dialogArguments[0] = args;
			    userinfo_dialogArguments[1] = info_user_Complete;
			    var OpenWin = window.open("/admin/ezOrgan/userInfo.do", "UserInfo", GetOpenWindowfeature(930, 550));
			    try { OpenWin.focus(); } catch (e) { }
				/* }else{
				    var rtnValue;
				    rtnValue = window.showModalDialog("/admin/ezOrgan/userInfo.do", args, "dialogHeight:500px; dialogWidth:830px; scroll:no;status:no; help:no; edge:sunken; resize:no" + GetShowModalPosition(830, 520));

				    if (typeof (rtnValue) != "undefined") {
				        alert("<spring:message code='ezOrgan.t11' />");
				        displayUserList(treeNode.GetNodeData("CN"));

				        if (trim(document.getElementById("keyword").value) != "") {
				            search_click();
				        }
				    }
				} */
			}
			
		    function info_user_Complete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
		        	var cn = userinfo_dialogArguments[0][0];
		        	
		            alert("<spring:message code='ezOrgan.t11' />");
		            displayUserList(cn);

		            if (trim(document.getElementById("keyword").value) != "") {
		                search_click();
		            }
		        }
		    }
		    
		    function mod_quota() {
		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");

		        if (listview.GetSelectedRows().length == 0) {
		            alert("<spring:message code='ezOrgan.t43' />");
		            return;
		        } else if (listview.GetSelectedRows()[0].getAttribute("DATA1") != 'user') {
                    alert(strLang13);
                    return;
		        } else if (listview.GetSelectedRows().length > 1) {
		            alert("<spring:message code='ezOrgan.t44' />");
		            return;
		        } else if (listview.GetSelectedRows()[0].getAttribute("DATA3") == 'addJob'){
		    		alert("<spring:message code='ezOrgan.psb02' />");
					return;
			    }
		        
		        var agent = navigator.userAgent.toLowerCase();
	            if (agent.indexOf("chrome") != -1) {
			        window.open("/admin/ezOrgan/configUserQuota.do?id=" + GetAttribute(listview.GetSelectedRows()[0],"DATA2"), "", "height=210px,width=480px,status=no,toolbar=no,menubar=no,location=no,resizable=1" + GetOpenPosition(480, 210));
	            } else {
			        window.open("/admin/ezOrgan/configUserQuota.do?id=" + GetAttribute(listview.GetSelectedRows()[0],"DATA2"), "", "height=210px,width=300px,status=no,toolbar=no,menubar=no,location=no,resizable=1" + GetOpenPosition(480, 210));
	            }
		        
		    }
		    
		    function mod_sign() {
		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");

		        if (listview.GetSelectedRows().length == 0) {
		            alert("<spring:message code='ezOrgan.t45' />");
		            return;
		        } else if (listview.GetSelectedRows()[0].getAttribute("DATA1") != 'user') {
                    alert(strLang13);
                    return;
				} else if (listview.GetSelectedRows().length > 1) {
		            alert("<spring:message code='ezOrgan.t46' />");
		            return;
		        } else if (listview.GetSelectedRows()[0].getAttribute("DATA3") == 'addJob'){
		    		alert("<spring:message code='ezOrgan.psb02' />");
					return;
			    }
		        
		        //2016-04-15 장진혁과장 -- cross 버전으로 통일하기 위한 주석처리
		        //if (CrossYN()){
		        	 //크롬일때 alert창 크기때문에 크롬일때 구별
		            var agent = navigator.userAgent.toLowerCase();
		            if (agent.indexOf("chrome") != -1) {
		            	window.open("/admin/ezOrgan/configSignImage.do?id=" + listview.GetSelectedRows()[0].getAttribute("DATA2"), "", "height=305px,width=460px,status=no,toolbar=no,menubar=no,location=no,resizable=1" + GetOpenPosition(449, 315));	
		            } else {
		            	window.open("/admin/ezOrgan/configSignImage.do?id=" + listview.GetSelectedRows()[0].getAttribute("DATA2"), "", "height=300px,width=320px,status=no,toolbar=no,menubar=no,location=no,resizable=1" + GetOpenPosition(320, 310));
		            }
		        /* }else{
		            window.open("ConfigSignImage.do?id=" + listview.GetSelectedRows()[0].getAttribute("DATA2"), "", "height=297px,width=320px,status=no,toolbar=no,menubar=no,location=no,resizable=1" + GetOpenPosition(320, 297));
		        } */
		    }
		    
		    var inputpassword_dialogArguments = new Array();
		    
		    function Retire_user(){
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	            
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(nodeIdx.NodeID);

	            var listview = new ListView();
	            listview.LoadFromID("lvUserList");

	            if (listview.GetSelectedRows().length == 0) {
	        		alert(strLang2);
	        		return;
	        	} else {
				    if (listview.GetSelectedRows()[0].getAttribute("DATA1") != 'user') {
	                    alert(strLang13);
	                    return;
				    } else {
				    	if (listview.GetSelectedRows()[0].getAttribute("DATA3") == 'addJob'){
				    		alert("<spring:message code='ezOrgan.psb02' />");
							return;
				    	}
				    }
				}
	            
	            var length = listview.GetSelectedRows().length;		            
	        	
	        	if (!confirm(length + strLang1)){
					return;
	        	}
	        	
	        	var data = "";
	            for (var i = 0; i < length; i++) {
	            	data += listview.GetSelectedRows()[i].getAttribute("DATA2");
	            	
	            	if(i != length-1){
	            		data = data + ",";
	            	}		                
	            }

	            $.ajax({
	            	type : "POST",
	            	dataType : "html",
	            	url : "/admin/ezOrgan/retireUser.do",
	            	async : false,
	            	data : {cn : data},
	            	success : function(result) {
	            	    if (result == "OK") {
	            			alert(strLang3);
	            	    } else {
	            	        alert(strLang4);
	            	    }
	            	},
	            	error : function(){
	            		alert(strLang4);            		
	            	}
	            });
	            
	            if (treeNode.selectedIndex != -1){
	        		displayUserList(treeNode.GetNodeData("CN"));
	            }		            
	        }
		    
		    var selectdept_cross_dialogArguments = new Array();
		    

		    function del_user(){
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        
		        var nodeIdx = treeView.GetSelectNode();		        
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");

		        if (listview.GetSelectedRows().length == 0){
					alert("<spring:message code='ezOrgan.t28' />");
					return;
				}
			    var length = listview.GetSelectedRows().length;
				if (!confirm(length + "<spring:message code='ezOrgan.t29' />")){
					return;
				}
				
				var data = "";
	            for (var i = 0; i < length; i++) {
	            	data += listview.GetSelectedRows()[i].getAttribute("DATA2");
	            	
	            	if(i != length-1){
	            		data = data + ",";
	            	}		                
	            }

	            if (useBizmekaSpambox == "YES") {
	            	showProgress();
	            }	            
	            
	            $.ajax({
	            	type : "POST",
	            	dataType : "html",
	            	url : "/admin/ezOrgan/delUser.do",
	            	async : true,
	            	data : {cn : data},
	            	success : function(result) {
	            	    if (useBizmekaSpambox == "YES") {
	            	    	hideProgress();
	            	    }
	            	    
	            	    setTimeout(function() {
	            	        if (result == "OK") {	            	        
  	            				alert(length + "<spring:message code='ezOrgan.t31' />");
	            	        } else {
	            	            alert("<spring:message code='ezOrgan.t30' />");
	            	        }
  	            		
  	    					if (TreeView.selectedIndex != -1){
  	    						displayUserList(treeNode.GetNodeData("CN"));
  	    					}	            		
	            	    }, 100);
	            	},
	            	error : function() {
	            	    if (useBizmekaSpambox == "YES") {
	            	    	hideProgress();
	            	    }
	            	    
	            	    setTimeout(function() {
	            			alert("<spring:message code='ezOrgan.t30' />");
	            		
	    					if (TreeView.selectedIndex != -1){
	    						displayUserList(treeNode.GetNodeData("CN"));
	    					}	   
	            	    }, 100);
	            	}
	            });				
			}
		    
		    function syncOrganAccounts() {
		    	showProgress();
		    	
	            $.ajax({
	            	type : "POST",
	            	dataType : "text",
	            	url : "/admin/ezOrgan/syncOrganAccounts.do",
	            	async : true,
	            	success : function(result) {
	            		hideProgress();
	            		
	            		if (result == "OK") {
	            	        alert("<spring:message code='ezOrgan.lhm6' />");
	            	    } else {
	            	        alert("<spring:message code='ezQuestion.t263' />");
	            	    }
	            	},
	            	error : function(error) {
	            		hideProgress();
	            		
	            	    alert("<spring:message code='ezQuestion.t263' /> " + error);
	            	}
	            });
		    }
		    
		    function syncWithBizmekaTalkAccounts() {
	            $.ajax({
	            	type : "POST",
	            	dataType : "text",
	            	url : "/admin/ezOrgan/syncWithBizmekaTalkAccounts.do",
	            	async : true,
	            	success : function(result) {
	            	    if (result == "OK") {
	            	        alert("<spring:message code='ezTalkGate.ldh004' />");
	            	    } else {
	            	        alert("<spring:message code='ezQuestion.t263' />");
	            	    }
	            	},
	            	error : function(error) {
	            	    alert("<spring:message code='ezQuestion.t263' /> " + error);
	            	}
	            });		        
		    }
		    
		    // 모바일 설정 함수 
		    function mobile_managed() {
		    	var data = "";
				var mobileOwner = "";
		    	var listview = new ListView();
		    	listview.LoadFromID("lvUserList");
		    	
		    	var length = listview.GetSelectedRows().length;
		    	
		    	if (length == 0) {
		    		alert("<spring:message code='ezOrgan.kyj05' />");
		    		return;
		    	} else if (listview.GetSelectedRows()[0].getAttribute("DATA1") != 'user') {
                    alert(strLang13);
                    return;
				} else if (length > 1) {
	    			alert("<spring:message code='ezOrgan.kyj06' />");
		    		return;
	    		}
		    	
	    		var trIdx = listview.GetSelectedRows()[0];
	    		mobileOwner = $(trIdx).children().eq(0).text();
	    		data = listview.GetSelectedRows()[0].getAttribute("DATA2");
		    	
		    	document.getElementById("userSend").value = data;
		    	
		    	var agent = navigator.userAgent.toLowerCase();
		    	
		    	if (agent.indexOf("chrome") != -1) {
		    		var OpenWin = window.open("/admin/ezOrgan/configMobileManaged.do?userId=" + data + "&userName=" + mobileOwner, "", GetOpenWindowfeature(460, 300));
		    	} else {
			    	var OpenWin = window.open("/admin/ezOrgan/configMobileManaged.do?userId=" + data + "&userName=" + mobileOwner, "", GetOpenWindowfeature(460, 300));
		    	}
		    } 
		   
		    // POP3/IMAP 설정 함수
		    var serUseDisablePopImap_dialogArguments = new Array();
		    
		    function mod_pop3Imap() {
		    	var listview = new ListView();
		    	listview.LoadFromID("lvUserList");
		    	
		    	var length = listview.GetSelectedRows().length;
		    	
		    	if (length == 0) {
		    		alert("<spring:message code='ezOrgan.kyj05' />");
		    		return;
		    	} else if (listview.GetSelectedRows()[0].getAttribute("DATA1") != 'user') {
                    alert(strLang13);
                    return;
				} else if (length > 1) {
	    			alert("<spring:message code='ezOrgan.kyj06' />");
		    		return;
	    		}

		    	var data = "";

		    	for (var i = 0; i < length; i++) {
		    		data += listview.GetSelectedRows()[0].getAttribute("DATA2");
		    	}
		    	
		    	serUseDisablePopImap_dialogArguments[1] = mod_pop3Imap_Complete;
		    	
		    	document.getElementById("userSend").value = data;
		    	
		    	var agent = navigator.userAgent.toLowerCase();
		    
		    	if (agent.indexOf("chrome") != -1) {
		    		var OpenWin = window.open("/admin/ezOrgan/configPopImap.do?userId=" + data, "setUsePop3Imap", GetOpenWindowfeature(450, 185));
		    	} else {
			    	var OpenWin = window.open("/admin/ezOrgan/configPopImap.do?userId=" + data, "setUsePop3Imap", GetOpenWindowfeature(330, 185));
		    	}
		    	
		    	try { OpenWin.focus(); } catch (e) { }
				
		    }
		    
		    
		    function mod_pop3Imap_Complete(rtnValue) {
		    	var propertyName = "disablePopImap";
		    	
		    	if (typeof (rtnValue) != "undefined") {
		    		
		    		var listview = new ListView();
		    		listview.LoadFromID("lvUserList");
		    		
		    		var data = listview.GetSelectedRows()[0].getAttribute("DATA2");
		    		
		    		$.ajax({
		    			url: "/admin/ezOrgan/setUseDisablePop3Imap.do",
		    			type: "POST",
		    			dataType: "text",
		    			data: {userId : data, propertyValue : rtnValue,
		    					propertyName : propertyName},
		    			success: function(res) {
		    				
		    				if (res == "SUCCESS") {
			    				alert("<spring:message code='ezOrgan.kyj03' />");
		    				} else {
		    					alert("<spring:message code='ezOrgan.kyj04' />");
		    				}
		    			},
		    			error: function(){
		    				alert("<spring:message code='ezOrgan.kyj04' />");
		    			}
		 
		    		});
		    	}
		    }

			function moveDisplay(mode) {
				if (mode) {
					$(".moveWrap").css("display","none");
					$(".tblPageRayerOrgan").css("display","block");
				} else {
					pageNum = 1;
					$(".moveWrap").css("display","block");
					$(".tblPageRayerOrgan").css("display","none");
				}
			}
			
			// xml data -> input checkbox method
			var cnt;
			var sawonDataParsing = function() {
				var doc = window.document;
				var acList = doc.getElementById("lvUserList");

				cnt = acList.children[1].childElementCount;
				// 사원이 없을 경우
				if(cnt == 1) {
					if(acList.children[1].children[0].id === "lvUserList_TR_noItems") {
						return;
					}
				}

				var i = 0;
				for (i; i < cnt; i++) {
					var tempLV = doc.getElementById('lvUserList_TR_' + i);
					var userID = tempLV.getAttribute('DATA2');
					var gyumInfo = tempLV.getAttribute('DATA3');
					// 3 암호관리 4 사원이동 5 퇴직
					if(tempLV.children[0].innerHTML != "") {
						tempLV.children[0].innerHTML = "<span><img id='pwd" + userID +"' class='deptMaster' onclick='mod_pwd(event)' src='/images/admin/deptmaster.png'></span>";
					}
					tempLV.children[6].innerHTML = "<span><img id='pwd" + userID +"' class='pwd' onclick='mod_pwd(event)' src='/images/admin/password.png'></span>";
					tempLV.children[7].innerHTML = "<span><img id='move" + userID +"' class='move' onclick='move_user(event)' src='/images/admin/move_sawon.png'></span>";
					tempLV.children[8].innerHTML = "<span><img id='retire" + userID +"' data1='" + gyumInfo + "' class='retire' onclick='retire_user(event)' src='/images/admin/retire.png'></span>";
				}
			}

			// 암호관리 수정 팝업
			var userID;
			function mod_pwd(event) {
				event.stopPropagation();
				changePassLength = 1;
				userID = event.target.id;
				var indexCN = userID.indexOf("pwd") + 3;
				userID = userID.substring(indexCN);
				inputpassword_dialogArguments[1] = mod_pwd_complete;

				//크롬일때 alert창 크기때문에 크롬일때 구별
				var agent = navigator.userAgent.toLowerCase();
				if (agent.indexOf("chrome") != -1) {
					var OpenWin = window.open("/admin/ezOrgan/inputPassword.do", "InputPassword", GetOpenWindowfeature(467, 192));
				} else {
					var OpenWin = window.open("/admin/ezOrgan/inputPassword.do", "InputPassword", GetOpenWindowfeature(330, 192));	
				}
			}

			// 암호관리 수정 수행
			function mod_pwd_complete(rtnValue){
				if (typeof (rtnValue) != "undefined") {
					var data = userID;

					$.ajax({
						type : "POST",
						dataType : "xml",
						url : "/admin/ezOrgan/changePassword.do",
						async : false,
						data : {password : rtnValue, cn : data},
						success : function(result){
							alert("비밀번호를 수정하였습니다.");
						},
						error : function(){
							alert("<spring:message code='ezOrgan.t41' />");
						}
					});
				}
				userID = "";
			}

			// 사원이동 호출
			function move_user(event){
				event.stopPropagation();
				
				userID = event.target.id;
				var indexCN = userID.indexOf("move") + 4;
				userID = userID.substring(indexCN);
				
				// 조직도 load
				var treeView = new TreeView();
				treeView.LoadFromID("FromTreeView");

				var nodeIdx = treeView.GetSelectNode();
				var treeNode = new TreeNode();
				treeNode.LoadFromID(nodeIdx.NodeID);
				document.getElementById("selectedCN").value = treeNode.GetNodeData("CN");

				selectdept_cross_dialogArguments[0] = "<spring:message code='ezOrgan.t13' />";
				selectdept_cross_dialogArguments[1] = move_user_CompleteWithTimeout;
				var OpenWin = window.open("/admin/ezOrgan/selectDept.do", "SelectDept_Cross", GetOpenWindowfeature(302, 390));
				try { OpenWin.focus(); } catch (e) { }
			}

			// tree load 시간
			function move_user_CompleteWithTimeout(rtnValue) {
				setTimeout(function() {
					move_user_Complete(rtnValue);
				}, 10);
			}

			// 사원이동 수행
			function move_user_Complete(rtnValue) {
				if (typeof (rtnValue) != "undefined") {

					// 동일 부서 체크
					var selectedCN = document.getElementById("selectedCN").value;
					if (rtnValue.toLowerCase() == selectedCN.toLowerCase()) {
						alert("<spring:message code='ezOrgan.t21' />");
						return;
					}

					// 사원이동 confirm
					if (!confirm("사원을 이동하시겠습니까?")){
						return;
					}

					var data = userID;

					$.ajax({
						type : "POST",
						dataType : "html",
						url : "/admin/ezOrgan/movUser.do",
						async : false,
						data : {parentCn : rtnValue, cn : data},
						success : function(result) {
							if (result == "EMAIL_ERROR") {
								alert("<spring:message code='ezOrgan.t15' />");
							} else if (result == "SAME") {
								alert("<spring:message code='ezOrgan.t15' />");
							} else if (result == "DIFF_COMPANY") {
								alert("<spring:message code='ezOrgan.lhm4' />");
							} else {
								alert("사원을 이동하였습니다.");
							}
						},
						error : function() {
							alert("<spring:message code='ezOrgan.t15' />");
						}
					});

					// 이동 후 tree 재 호출
					curTreeNodeReload()
				}
			}

			// 사원 퇴직
			var retire_user = function(event) {
				event.stopPropagation();
				
				userID = event.target.id;
				var indexCN = userID.indexOf("retire") + 6;
				userID = userID.substring(indexCN);

				// 겸직유무 체크
				var gyumInfo = event.target.getAttribute('data1')
				if (gyumInfo === 'addJob'){
					alert("<spring:message code='ezOrgan.psb02' />");
					return;
				}

				var data = userID;
				if (!confirm("사원을 퇴직 처리하겠습니까?")){
					return;
				}

				$.ajax({
					type : "POST",
					dataType : "html",
					url : "/admin/ezOrgan/retireUser.do",
					async : false,
					data : {cn : data},
					success : function(result) {
						if (result == "OK") {
							alert(strLang3);
							curTreeNodeReload();
						} else {
							alert(strLang4);
						}
					},
					error : function(){
						alert(strLang4);
					}
				});
			}

			function curTreeNodeReload() {
				var treeView = new TreeView();
				treeView.LoadFromID("FromTreeView");
				var nodeIdx = treeView.GetSelectNode();
				var treeNode = new TreeNode();
				treeNode.LoadFromID(nodeIdx.NodeID);
				displayUserList(treeNode.GetNodeData("CN"));
			}

			function check_info() {

				var treeView = new TreeView();
				treeView.LoadFromID("FromTreeView");
				var nodeIdx = treeView.GetSelectNode();
				var treeNode = new TreeNode();
				treeNode.LoadFromID(nodeIdx.NodeID);

				if (treeNode.selectedIndex == -1){
					alert("<spring:message code='ezOrgan.t5' />");
					return;
				}

				// 회사정보
				if (treeNode.GetNodeData("CN") == treeNode.GetNodeData("EXTENSIONATTRIBUTE2")){
					info_company();	
				} else { // 부서정보
					info_dept();
				}
			}

			// 페이징 객체 생성 method
			function td_Create1(strtext) {
				document.getElementById("tblPageRayer").innerHTML = strtext;
			}

			// 페이징 method
			function makePageSelPage() {
				var strtext;
				var PagingHTML = "";
				document.getElementById("tblPageRayer").innerHTML = "";
				/* document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span style='color:#017BEC;'>" + TotalCount + "</span>";  */
				strtext = "<div class='pagenavi'>";
				PagingHTML += strtext;

					if (totalPage > 1 && pageNum != 1) {
					strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' ></span>";
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' ></span>";
					PagingHTML += strtext;
				}

				if (totalPage > BlockSize) {
					if (pageNum > BlockSize) {
						strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' ></span>";
						PagingHTML += strtext;
					} else {
						strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
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


				//2018-08-02 김보미 - 데이터가 하나도 없을때 디폴트 페이징
				if (i == 1) {
					strtext = "<span class='on'>" + i + "</span>";
					PagingHTML += strtext;
				}


				if (totalPage > BlockSize) {
					if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
						strtext = "";
						strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' ></span>";
						PagingHTML += strtext;
					} else {
						strtext = "";
						strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
						PagingHTML += strtext;
					}
				} else {
					strtext = "";
					strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
					PagingHTML += strtext;
				}

				if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
					strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' ></span>";
					PagingHTML += strtext;
				} else {
					strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' ></span>";
					PagingHTML += strtext;
				}

				PagingHTML += "</div>";
				td_Create1(PagingHTML);
			}

			function goToPageByNum(Value) {
				pageNum = Value;
				makePageSelPage();
				pageChange();
			}

			function selbeforeBlock() {
				pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
				goToPageByNum(pageNum);
			}

			function selbeforeBlock_one() {
				if (parseInt(pageNum - 1) > 0) {
					goToPageByNum(parseInt(pageNum - 1));
				} else {
					return;
				}
			}

			function selafterBlock() {
				pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
				goToPageByNum(pageNum);
			}

			function selafterBlock_one() {
				if (parseInt(pageNum + 1) <= totalPage) {
					goToPageByNum(parseInt(pageNum + 1));
				} else {
					return;
				}
			}

			function selNum(pselNum) {
				pageNum = pselNum;
				pageChange();
			}

			function selNext() {
				pageNum = pageNum + 1;
				pageChange();
			}

			function selPrev() {
				pageNum = pageNum - 1;
				pageChange();
			}
			
			function pageChange() {
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/ezOrgan/getSearchList.do",
					async : false,
					data : {
						search : searchType + "::" + searchWord,
						cell : "extensionAttribute9;displayName;cn;description;title;extensionAttribute10",
						prop : "department",
						type : "user",
						page : pageNum,
						adminOrgan : "y"
					},
					success : function(xml){
						result=loadXMLString(xml);
						var listview = new ListView();
						listview.LoadFromID("lvUserList");

						// 전체페이지 처리
						var totCount = result.getElementsByTagName('TOTALCOUNT')[0].innerHTML;
						totalPage = Math.ceil((totCount)/10);
						if(totalPage == 0) {
							totalPage = 1;
						}

						// 암호관리, 사원이동, 퇴직 cell append
						var cnt = result.getElementsByTagName('ROWS')[0].childElementCount;
						var i = 0;
						for(i;i<cnt;i++) {
							var cell1 = result.createElement("CELL");
							var value1 = result.createElement("VALUE");
							cell1.appendChild(value1);
							var cell2 = result.createElement("CELL");
							var value2 = result.createElement("VALUE");
							cell2.appendChild(value2);
							var cell3 = result.createElement("CELL");
							var value3 = result.createElement("VALUE");
							cell3.appendChild(value3);
							result.getElementsByTagName("ROW")[i].appendChild(cell1);
							result.getElementsByTagName("ROW")[i].appendChild(cell2);
							result.getElementsByTagName("ROW")[i].appendChild(cell3);
						}

						var headerData = createXmlDom();
						headerData = loadXMLString(listviewheader1.innerHTML.toUpperCase());
						$("#maillist_user").css("display", "");
						$("#maillist_dept").css("display", "none");

				        if (CrossYN()) {
				            var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
				            var Node = headerData.importNode(xmlRtn, true);
				            headerData.documentElement.appendChild(Node);
				        }else{
				            var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
				            headerData.documentElement.appendChild(xmlRtn);
				        }
		                document.getElementById("OrganListView").innerHTML = "";

						var pUserList = new ListView();
						pUserList.SetID("lvUserList");
						pUserList.SetRowOnDblClick("info_user");
						pUserList.SetSelectFlag(false);
						pUserList.SetHeightFree(true);
						pUserList.DataSource(headerData);
						pUserList.DataBind("OrganListView");
						sawonDataParsing();
						moveDisplay(true);
						makePageSelPage();
					},
					error : function(error){
						alert("<spring:message code='ezOrgan.t59' />" + error);
					}
				});
			}

			var windowResize = function() {
				var doc = window.document;
				var height = window.innerHeight * 0.8 - 72;
				doc.getElementById('TreeView').style.height = height + "px";
				doc.getElementsByClassName('OrganListView')[0].style.height = (height -60) + "px";
			}
		</script>
		<style>
			.OrganListView {width:100%;}
		</style>
	</head>
	<body class="mainbody">
		<input type="hidden" name="selectedCN" id="selectedCN" />
		<input type="hidden" name="selectedValue" id="selectedValue" />
		<form name="sendForm">
			<input type="hidden" name="userSend" id="userSend" />
		</form>

		<xml id="listviewheader1" style="display:none;">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER><WIDTH>4%</WIDTH></HEADER>
					<HEADER><WIDTH>20%</WIDTH></HEADER>
					<HEADER><WIDTH></WIDTH></HEADER>
					<HEADER><WIDTH>15%</WIDTH></HEADER>
					<HEADER><WIDTH>10%</WIDTH></HEADER>
					<HEADER><WIDTH>10%</WIDTH></HEADER>
					<HEADER><WIDTH>8%</WIDTH></HEADER>
					<HEADER><WIDTH>8%</WIDTH></HEADER>
					<HEADER><WIDTH>7%</WIDTH></HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>

		<xml id="listviewheader2" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER><WIDTH>4%</WIDTH></HEADER>
					<HEADER><WIDTH>46%</WIDTH></HEADER>
					<HEADER><WIDTH>50%</WIDTH></HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<h1>
			<c:if test="${dotNetIntegration != 'YES'}">
				<spring:message code='main.t56' />
			</c:if>
			<c:if test="${dotNetIntegration == 'YES'}">
				<spring:message code='main.t24' />
			</c:if>
		</h1>

		<div id="mainmenu" class="organMainmenu">
			<ul style="height:33px;">
				<c:if test="${dotNetIntegration != 'YES'}">
					<li id="companybutton3"><span onClick="check_info()">조직도정보</span></li>
					<li id="companybutton1"><span onClick="add_company()"><spring:message code='ezOrgan.t76' /></span></li>
					<li><span onClick="add_dept()"><spring:message code='ezOrgan.t80' /></span></li>
					<li><span onClick="add_user()"><spring:message code='ezOrgan.t84' /></span></li>
					<li id="companybutton2"><span onClick="del_company()"><spring:message code='ezOrgan.t78' /></span></li>
					<li id="usermenu10"><span onClick="del_dept()"><spring:message code='ezOrgan.t81' /></span></li>
					<li id="usermenu8"><span onClick="mov_dept()"><spring:message code='ezOrgan.t82' /></span></li>
					<c:if test="${use_approvalG != 'YES'}">style="display:none;"</c:if>
					<c:if test="${use_approvalG != 'YES'}">style="display:none;"</c:if>
					<li id="usermenu4"><span onClick="mod_sign()"><spring:message code='ezOrgan.t89' /></span></li>
				</c:if>
				<%-- <li id="usermenu6"><span onClick="mail_manage()"><spring:message code='ezOrgan.t91' /></span></li> --%>
				<c:if test="${useSyncServer == 'YES'}">			
					<li id="usermenu24"><span onClick="syncOrganAccounts()"><spring:message code='ezOrgan.lhm5' /></span></li>
				</c:if>
				<c:if test="${useBizmekaTalk == 'YES'}">
					<li id="usermenu21"><span onClick="syncWithBizmekaTalkAccounts()"><spring:message code='ezOrgan.t1002' /></span></li>
				</c:if>
				<c:if test="${useDisablePopImap == 'YES'}">
					<li id="usermenu22"><span onClick="mod_pop3Imap()">POP3/IMAP</span></li>
				</c:if>
				<c:if test="${useMobileManagemant == 'YES' }">
					<li id="usermenu23"><span onClick="mobile_managed()"><spring:message code='ezPersonal.t998' /></span></li>
				</c:if>
				<input type="radio" name="listOpt" id="listOpt1" value="muser" onClick="Change_List()" checked /><label for="listOpt1" style="cursor:pointer;"><spring:message code='ezOrgan.t74' /></label>
				<input type="radio" name="listOpt" id="listOpt2" value="mgroup" onClick="Change_List()" /><label for="listOpt2" style="cursor:pointer;"><spring:message code='ezOrgan.t75' /></label>
				<div class="organSearchEnter" >
					<a class="imgbtn search" style="vertical-align:middle; width: 35px; ">
						<span onClick="search_click()"><spring:message code='ezOrgan.t101' /></span>
					</a>
				</div>
				<div class="organSearchForm">
					<div class="organSearchTab"><span>검색대상</span></div>
					<div class="organSearchContent">
						<span>
							<select id="search_type" style="width:100px; height:27px !important;line-height:normal !important;">
								<option selected value="displayname"><spring:message code='ezOrgan.t67' /></option>
								<option value="cn"><spring:message code='ezOrgan.t94' /></option>
								<option value="description"><spring:message code='ezOrgan.t68' /></option>
								<option value="title"><spring:message code='ezOrgan.t69' /></option>
								<option value="extensionAttribute10"><spring:message code='ezOrgan.t1500' /></option>
								<option value="telephonenumber"><spring:message code='ezOrgan.t95' /></option>
								<option value="mobile"><spring:message code='ezOrgan.t96' /></option>
								<option value="HomePhone"><spring:message code='ezOrgan.t97' /></option>
								<option value="facsimileTelephoneNumber"><spring:message code='ezOrgan.t98' /></option>
								<option value="mail"><spring:message code='ezOrgan.t99' /></option>
								<option value="streetAddress"><spring:message code='ezOrgan.t100' /></option>
							</select>
						</span>
						<span><input id="keyword" class="organSearchKeyword" onKeyPress="search_press()"/></span>
					</div>
				</div>
			</ul>
		</div>

		<div>
			<div style="border: 1px solid #ddd; height: 530px; width: 30%;  overflow-x: hidden; overflow-y: auto; background-color: #FFFFFF; float:left;" id="TreeView"></div>
			<div class="organHeader">
	 		 	<table id="maillist_user" class="mainlist" style="width:100%;">
					<tr class="header">
						<th width="4%"></th> 
						<th width="20%"><spring:message code='ezOrgan.t67' /></th> 
						<th >아이디</th>
						<th  width="15%">부서</th> 
						<th width="10%">직위</th> 
						<th  width="10%">직책</th>
						<th width="8%">암호관리</th>
						<th width="8%">사원이동</th>
						<th  width="7%">퇴직</th>
					</tr>
				</table>
 				<table id="maillist_dept" class="mainlist" style="width:100%;display:none;">
					<tr class="header">
						<th width="4%"></th>
						<th width="46%"><spring:message code='ezOrgan.t70' /></th>
						<th width="50%"><spring:message code='ezOrgan.t71' /></th>
					</tr>
				</table>
			</div> 
			<div class="listview organ" style="width:69%; float:right;">
				<c:if test="${dotNetIntegration != 'YES'}">
					<div id="OrganListView" class="OrganListView"></div>
				</c:if>
				<c:if test="${dotNetIntegration == 'YES'}">
					<div id="OrganListView" class="OrganListView"></div>
				</c:if>
			</div>
		</div>	
		<c:if test="${dotNetIntegration != 'YES'}">
			<div class="moveWrap" style="width:69%; vertical-align:middle; text-align:center; float:right; border: 1px solid #ddd;background-color: #f8f8fa;">
				<img style="cursor:pointer;" <spring:message code='ezOrgan.i2' />>&nbsp;<span style="padding-top:5px; display: inline-block;"><spring:message code='ezOrgan.t102' /></span>
				<img style="cursor:pointer;" <spring:message code='ezOrgan.i3' />>&nbsp;<span style="padding-top:5px; display: inline-block;"><spring:message code='ezOrgan.t103' /></span>
				<a class="imgbtn order" name="MoveConfirm"><span onClick="MoveConfirm_onclick()"><spring:message code='ezOrgan.t104' /></span></a>
			</div>
			
		</c:if>
		<div id="tblPageRayer" class="tblPageRayerOrgan" style="width: 69% !important;"></div>

	<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="progressPanel">&nbsp;</div>
	<span class="loading_layer" style="z-index:6000;position:absolute;top:350px;left:350px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t680' /></span></span>  
	</body>
</html>
