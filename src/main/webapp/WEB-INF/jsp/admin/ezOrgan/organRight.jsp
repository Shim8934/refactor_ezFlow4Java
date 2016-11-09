<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t84" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href='/css/organ_tree.css' type="text/css" />
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">		
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var topid = "<c:out value='${topid}'/>";
		    var useOCS = "<c:out value='${useOCS}'/>";
		    var g_xmlHTTP = null;
		    var userinfo_dialogArguments = new Array();
		    
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
				}
		    });		    
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
				var strQuery = "<DATA><DEPTID>" + deptid + "</DEPTID><TOPID>" + topid + "</TOPID><PROP>extensionAttribute1;extensionAttribute2;displayName</PROP></DATA>";

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
					cellContent = "displayname;description;title";
					typeContent = "user";
				}else{
					cellContent = "displayname;extensionAttribute9";
					typeContent = "group";
				}
				
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getDeptMemberList.do",
		        	data : {deptID : DeptID, cell : cellContent, prop : "", type : typeContent},
		        	success : function(xml){
		        		result=loadXMLString(xml);
		        		var headerData = createXmlDom();
		        		
				        if (listOpt1.checked == true){
				            headerData = loadXMLString(listviewheader1.innerHTML.toUpperCase());
				        }else{
				            headerData = loadXMLString(listviewheader2.innerHTML.toUpperCase());
				        }
				        
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
				        pUserList.SetMulSelectable(true);
				        pUserList.SetRowOnDblClick("info_user");
				        pUserList.SetSelectFlag(false);
				        pUserList.SetHeightFree(true);
				        pUserList.DataSource(headerData);
				        pUserList.DataBind("OrganListView");
		        	},
		        	error : function(error){
		        		alert("<spring:message code='ezOrgan.t2'/>" + error);	
		        	}
		        });	
			}			
			var companyinfo_dialogArguments = new Array();
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
			    if (CrossYN()){
			        companyinfo_dialogArguments[0] = treeNode.GetNodeData("CN");
			        companyinfo_dialogArguments[1] = add_company_Complete;
			        var OpenWin = window.open("/admin/ezOrgan/companyInfo.do", "CompanyInfo", GetOpenWindowfeature(328, 230));
			        try { OpenWin.focus(); } catch (e) { }
			    }else{
			        var rtnValue = window.showModalDialog("/admin/ezOrgan/companyInfo.do", treeNode.GetNodeData("CN"), "dialogHeight:230px; dialogWidth:328px; scroll:no;status:no; help:no; edge:sunken" + GetShowModalPosition(328, 230));

			        if (typeof (rtnValue) != "undefined"){
			            getDeptFullTree(rtnValue);
			        }
			    }
			}			
		    function add_company_Complete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
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
				    var OpenWin = window.open("/admin/ezOrgan/deptInfo.do", "DeptInfo", GetOpenWindowfeature(335, 490));
				    try { OpenWin.focus(); } catch (e) { }
				}else{
				    var rtnValue = window.showModalDialog("/admin/ezOrgan/deptInfo.do", args,"dialogHeight:480px; dialogWidth:335px; scroll:no;status:no; help:no; edge:sunken" + GetShowModalPosition(335, 440));

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
				    var OpenWin = window.open("/admin/ezOrgan/deptInfo.do", "DeptInfo", GetOpenWindowfeature(335, 490));				    
				    try { OpenWin.focus(); } catch (e) { }
				}else {
				    var rtnValue = window.showModalDialog("/admin/ezOrgan/deptInfo.do", args, "dialogHeight:480px; dialogWidth:335px; scroll:no;status:no; help:no; edge:sunken" + GetShowModalPosition(335, 440));

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
		        selectdept_cross_dialogArguments[1] = mov_dept_Complete;
		        var OpenWin = window.open("/admin/ezOrgan/selectDept.do", "SelectDept_Cross", GetOpenWindowfeature(302, 390));		        
		        try { OpenWin.focus(); } catch (e) { }			    
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
		            	success : function(result){
		            		if(result == "SAME"){
		            			alert("<spring:message code='ezOrgan.t21' />");
		            		}else if (result == "EMAIL_ERROR") {
		            			alert("'" + selectedValue + "'<spring:message code='ezOrgan.t25' />");
		            		}else{
		            			alert("'" + selectedValue + "'<spring:message code='ezOrgan.t27' />");
				                getDeptFullTree(selectedCN);
		            		}
		            	},
		            	error : function(){
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
				if (document.getElementById("deptkeyword").value == ""){
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
		        	data : {search : "displayname::" + document.getElementById("deptkeyword").value, cell : "extensionAttribute3;displayName;extensionAttribute9", prop : "", type : "group"},
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
				    var strQuery = "<DATA><DEPTID>" + getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]) + "</DEPTID><TOPID>Top</TOPID><PROP>extensionAttribute1;extensionAttribute2;displayName</PROP></DATA>";
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
					    var OpenWin = window.open("/admin/ezOrgan/checkName2.do", "checkName2_Cross", GetOpenWindowfeature(598, 340));					    
					    try { OpenWin.focus(); } catch (e) { }
					}else{
					    window.showModalDialog("/admin/ezOrgan/checkName2.do", rgParams, "dialogHeight:340px; dialogWidth:598px; status:no;scroll:no; help:no; edge:sunken" + GetShowModalPosition(609, 340));

					    if (rgParams["deptid"] != "") {
					        g_xmlHTTP = createXMLHttpRequest();
					        // 20110412 사용자 추가시 필요 정보 추가처리.
					        var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>extensionAttribute1;extensionAttribute2;displayName</PROP></DATA>";					        
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
		            var strQuery = "<DATA><DEPTID>" + rgParams["deptid"] + "</DEPTID><TOPID>Top</TOPID><PROP>extensionAttribute1;extensionAttribute2;displayName</PROP></DATA>";		            
		            g_xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", true);
		            g_xmlHTTP.onreadystatechange = event_getDeptFullTree;
		            g_xmlHTTP.send(strQuery);
		        }
		        document.getElementById("deptkeyword").value = "";
		    }
		    function search_click(){
				if (keyword.value == ""){
					alert("<spring:message code='ezOrgan.t56' />");
					keyword.focus();
					return;
				}
			    document.getElementById("listOpt1").checked = true;
			    //2016-04-14 장진혁과장 -- Change_List 실행시 검색 결과값 불일치로 인한 주석처리
			    //Change_List();
			    				
				$.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/ezOrgan/getSearchList.do",
		        	async : false,
		        	data : {search : search_type.value + "::" + keyword.value, cell : "displayName;description;title", prop : "department", type : "user"},
		        	success : function(xml){
		        		result=loadXMLString(xml);
		        		var listview = new ListView();
				        listview.LoadFromID("lvUserList");
						
				        var headerData = createXmlDom();
				        if (listOpt1.checked == true)
				            headerData = loadXMLString(listviewheader1.innerHTML.toUpperCase());
				        else
				            headerData = loadXMLString(listviewheader2.innerHTML.toUpperCase());

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
					},
					error : function(error){
						alert("<spring:message code='ezOrgan.t59' />" + error);
					}
		        });				
				// [2006. 02. 10. 이민수] 검색을 완료하면 TextBox를 초기화하도록 변경
				//keyword.value = "";
			}			
			function Change_List(){
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

		        if (listOpt1.checked == true) {
		            usermenu1.disabled = false;
		            usermenu2.disabled = false;
		            usermenu3.disabled = false;
		            usermenu4.disabled = false;
		            usermenu5.disabled = false;
		            usermenu6.disabled = false;
		            usermenu7.disabled = false;
		            usermenu8.disabled = false;
		            try {
		                usermenu9.disabled = false;
		            } catch (e) { }
		            usermenu10.disabled = false;
		            //usermenu13.disabled = false;
		            userRetire.disabled = false;
		            if(useOCS == "YES"){
		                usermenusipuri.disabled = false;
		            }
		        }else{
		            usermenu1.disabled = true;
		            usermenu2.disabled = true;
		            usermenu3.disabled = true;
		            usermenu4.disabled = true;
		            usermenu5.disabled = true;
		            usermenu6.disabled = true;
		            usermenu7.disabled = true;
		            usermenu8.disabled = true;
		            
		            try {
		                usermenu9.disabled = false;
		            } catch (e) { }
		            usermenu10.disabled = true;
		            //usermenu13.disabled = true;
		            userRetire.disabled = true;
		            
		            if (useOCS == "YES"){
		                usermenusipuri.disabled = true;
		            }
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

		        var listview = new ListView();		        
		        listview.LoadFromID("lvUserList");

				if (listview.GetDataRows().length == 0){
					return;
				}

				for (var i = 0 ; i < listview.GetDataRows().length ; i++){
					objNode += listview.GetDataRows()[i].getAttribute("DATA2");
					if(i != listview.GetDataRows().length){
						objNode += ",";
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
					data : {cn : objNode, pClass : pClass},
					success : function(result){
						alert("<spring:message code='ezOrgan.t49' />");
						getDeptFullTree(treeNode.GetNodeData("CN"));
					},
					error : function(){
						alert("<spring:message code='ezOrgan.t48' />");
					}
				});
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
				
				//2016-04-19 장진혁과장 -- Cross 버전 사용으로 주석 처리
				//if (CrossYN()) {
			    userinfo_dialogArguments[0] = args;
			    userinfo_dialogArguments[1] = add_user_Complete;
			    var OpenWin = window.open("/admin/ezOrgan/userInfo.do", "UserInfo", GetOpenWindowfeature(830, 520));
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
			function info_user(){
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);
		              
		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");

				if (document.getElementById("listOpt2").checked == true){
					return;
				}
				if (listview.GetSelectedRows().length == 0){
					alert("<spring:message code='ezOrgan.t9' />");
					return;
				}
			    if (listview.GetSelectedRows().length > 1){
					alert("<spring:message code='ezOrgan.t10' />");
					return;
				}				
				var args = new Array();
				args[0] = treeNode.GetNodeData("CN");
				
				// 수정(2007.06.26) : 사용자 추가 시 부서명(P/S)이 제대로 보이지 않는 문제 수정
				args[1] = treeNode.GetNodeData("DISPLAYNAME1");
				args[2] = listview.GetSelectedRows()[0].getAttribute("DATA2");
				args[3] = treeNode.GetNodeData("DISPLAYNAME2");
				
				//2016-04-18 장진혁과장 -- Cross 버전 사용으로 인한 주석처리
				//if (CrossYN()) {
			    userinfo_dialogArguments = new Array();
			    userinfo_dialogArguments[0] = args;
			    userinfo_dialogArguments[1] = info_user_Complete;
			    var OpenWin = window.open("/admin/ezOrgan/userInfo.do", "UserInfo", GetOpenWindowfeature(830, 520));
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
		    function mod_sign() {
		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");

		        if (listview.GetSelectedRows().length == 0) {
		            alert("<spring:message code='ezOrgan.t45' />");
		            return;
		        }
		        if (listview.GetSelectedRows().length > 1) {
		            alert("<spring:message code='ezOrgan.t46' />");
		            return;
		        }
		        //2016-04-15 장진혁과장 -- cross 버전으로 통일하기 위한 주석처리
		        //if (CrossYN()){
		            window.open("/admin/ezOrgan/configSignImage.do?id=" + listview.GetSelectedRows()[0].getAttribute("DATA2"), "", "height=310px,width=320px,status=no,toolbar=no,menubar=no,location=no,resizable=1" + GetOpenPosition(320, 310));
		        /* }else{
		            window.open("ConfigSignImage.do?id=" + listview.GetSelectedRows()[0].getAttribute("DATA2"), "", "height=297px,width=320px,status=no,toolbar=no,menubar=no,location=no,resizable=1" + GetOpenPosition(320, 297));
		        } */
		    }
		    var inputpassword_dialogArguments = new Array();
			function mod_password(){
		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");

		        if (listview.GetSelectedRows().length == 0){
					alert("<spring:message code='ezOrgan.t39' />");
					return;
				}
		        //2016-04-18 장진혁과장 -- Cross 사용으로 인한 주석처리
			    //if (CrossYN()){
		        inputpassword_dialogArguments[1] = mod_password_Complete;
		        var OpenWin = window.open("/admin/ezOrgan/inputPassword.do", "InputPassword", GetOpenWindowfeature(330, 185));
		        try { OpenWin.focus(); } catch (e) { }
			    <%-- }else{
			        var rtnValue = window.showModalDialog("InputPassword.aspx", "", "dialogHeight:185px; dialogWidth:330px; scroll:no;status:no; help:no; edge:sunken" + GetShowModalPosition(330, 185));

			        if (typeof (rtnValue) != "undefined") {
			            var length = listview.GetSelectedRows().length;
			            if (!confirm(length + "<%=RM.GetString("t40")%>")){
			                return;
			            }
			            var xmlDom = createXmlDom();
			            var xmlHTTP = createXMLHttpRequest();

			            var objNode = "";
			            createNodeInsert(xmlDom, objNode, "DATA");
			            createNodeAndInsertText(xmlDom, objNode, "PASSWORD", rtnValue);
			            
			            for (var i = 0; i < length; i++) {
			                createNodeAndInsertText(xmlDom, objNode, "CN", listview.GetSelectedRows()[i].getAttribute("DATA2"));
			            }
			            xmlHTTP.open("POST", "ChangePassword.aspx", false);
			            xmlHTTP.send(xmlDom);

			            if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK"){
			                alert("<%=RM.GetString("t41")%>");
			            }else{
			                alert(length + "<%=RM.GetString("t42")%>");
			            }
			        }
			    } --%>
			}
		    function mod_password_Complete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
		            var listview = new ListView();
		            listview.LoadFromID("lvUserList");

		            var length = listview.GetSelectedRows().length;
		            if (!confirm(length + "<spring:message code='ezOrgan.t40' />")){
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
		            	dataType : "xml",
		            	url : "/admin/ezOrgan/changePassword.do",
		            	async : false,
		            	data : {password : rtnValue, cn : data},
		            	success : function(result){
		            		alert(length + "<spring:message code='ezOrgan.t42' />");
		            	},
		            	error : function(){
		            		alert("<spring:message code='ezOrgan.t41' />");		            		
		            	}
		            });
	            }		        
		    }		    
		    function Retire_user(){
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	            
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(nodeIdx.NodeID);

	            var listview = new ListView();
	            listview.LoadFromID("lvUserList");

	            if (listview.GetSelectedRows().length == 0){
	        		alert(strLang2);
	        		return;
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
	            	dataType : "xml",
	            	url : "/admin/ezOrgan/retireUser.do",
	            	async : false,
	            	data : {cn : data},
	            	success : function(result){
	            		alert(strLang3);
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
			function mov_user(){
		        var listview = new ListView();
		        listview.LoadFromID("lvUserList");

		        if (listview.GetSelectedRows().length == 0){
					alert("<spring:message code='ezOrgan.t12' />");
					return;
				}
		        //2016-04-18 장진혁 과장 -- Cross 버전 사용으로 인한 주석 처리
			    //if (CrossYN()) {
		        selectdept_cross_dialogArguments[0] = "<spring:message code='ezOrgan.t13' />";
		        selectdept_cross_dialogArguments[1] = mov_user_Complete;
		        var OpenWin = window.open("/admin/ezOrgan/selectDept.do", "SelectDept_Cross", GetOpenWindowfeature(302, 390));
		        try { OpenWin.focus(); } catch (e) { }
			    <%-- }else {
			        var rtnValue = '';
			        rtnValue = window.showModalDialog("SelectDept_Cross.aspx", "<%=RM.GetString("t13")%>", "dialogHeight:390px; dialogWidth:302px; scroll:no;status:no; help:no; edge:sunken" + GetShowModalPosition(302, 390));

			        if (typeof (rtnValue) != "undefined") {
			            var length = listview.GetSelectedRows().length;
			            if (!confirm(length + "<%=RM.GetString("t14")%>"))
			                return;

			            var xmlDom = createXmlDom();
			            var xmlHTTP = createXMLHttpRequest();

			            var objNode = "";
			            createNodeInsert(xmlDom, objNode, "DATA");
			            createNodeAndInsertText(xmlDom, objNode, "PARENTCN", rtnValue);
			            for (var i = 0; i < length; i++) {
			                createNodeAndInsertText(xmlDom, objNode, "CN", listview.GetSelectedRows()[i].getAttribute("DATA2"));
			            }

			            xmlHTTP.open("POST", "MovUser.aspx", false);
			            xmlHTTP.send(xmlDom);

			            if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
			                alert("<%=RM.GetString("t15")%>");
			            else
			                alert(length + "<%=RM.GetString("t16")%>");

			            var treeView = new TreeView();
			            treeView.LoadFromID("FromTreeView");
			            var nodeIdx = treeView.GetSelectNode();
			            var treeNode = new TreeNode();
			            treeNode.LoadFromID(nodeIdx.NodeID);
			            displayUserList(treeNode.GetNodeData("CN"));
			        }
			    } --%>
			}
		    function mov_user_Complete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
		        	var listview = new ListView();
			        listview.LoadFromID("lvUserList");
			        
		            var length = listview.GetSelectedRows().length;
		            if (!confirm(length + "<spring:message code='ezOrgan.t14' />")){
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
		            	url : "/admin/ezOrgan/movUser.do",
		            	async : false,
		            	data : {parentCn : rtnValue, cn : data},
		            	success : function(result){
		            		if (result == "EMAIL_ERROR") {
		            			alert("<spring:message code='ezOrgan.t15' />");
		            		}else if (result == "SAME") {
		            			alert("<spring:message code='ezOrgan.t15' />");
		            		}else{
		            			alert(length + "<spring:message code='ezOrgan.t16' />");
		            		}
		            	},
		            	error : function(){
		            		alert("<spring:message code='ezOrgan.t15' />");
		            	}
		            });

		            var treeView = new TreeView();
		            treeView.LoadFromID("FromTreeView");
		            var nodeIdx = treeView.GetSelectNode();
		            var treeNode = new TreeNode();
		            treeNode.LoadFromID(nodeIdx.NodeID);
		            displayUserList(treeNode.GetNodeData("CN"));
		        }
		    }
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

	            $.ajax({
	            	type : "POST",
	            	dataType : "html",
	            	url : "/admin/ezOrgan/delUser.do",
	            	async : false,
	            	data : {cn : data},
	            	success : function(result){
	            		alert(length + "<spring:message code='ezOrgan.t31' />");
	            	},
	            	error : function(){
	            		alert("<spring:message code='ezOrgan.t30' />");
	            	}
	            });
				
				if (TreeView.selectedIndex != -1){
					displayUserList(treeNode.GetNodeData("CN"));
				}
			}
	    </script>
	</head>
	<body class="mainbody">
		<input type="hidden" name="selectedCN" id="selectedCN" />
		<input type="hidden" name="selectedValue" id="selectedValue" />
		
		<xml id="listviewheader1" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t67' /></NAME>
						<WIDTH>40</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t68' /></NAME>
						<WIDTH>80</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t69' /></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<xml id="listviewheader2" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t70' /></NAME>
						<WIDTH>70</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezOrgan.t71' /></NAME>
						<WIDTH>30</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<h1><spring:message code='ezOrgan.t72' /></h1>
		<table style="margin-top:10px">
			<tr>
				<th><spring:message code='ezOrgan.t73' /></th>
				<th>
					<input type="radio" name="listOpt" id="listOpt1" value="muser" onClick="Change_List()" checked /><spring:message code='ezOrgan.t74' />					
					<input type="radio" name="listOpt" id="listOpt2" value="mgroup" onClick="Change_List()" /><spring:message code='ezOrgan.t75' />
				</th>
				<th style="width:80px;text-align:center" rowspan="3">
					<table>
						<tr id="companybutton1">
							<td><a class="imgbtn"><span onClick="add_company()"><spring:message code='ezOrgan.t76' /></span></a></td>
						</tr>
						<tr id="companybutton2">
							<td><a class="imgbtn"><span onClick="del_company()"><spring:message code='ezOrgan.t78' /></span></a></td>
						</tr>
						<tr>
							<td height="15"><img <spring:message code='ezOrgan.i1' />></td>
						</tr>
						<tr>
							<td><a class="imgbtn"><span onClick="info_dept()"><spring:message code='ezOrgan.t79' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn"><span onClick="add_dept()"><spring:message code='ezOrgan.t80' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="usermenu10"><span onClick="del_dept()"><spring:message code='ezOrgan.t81' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="usermenu8"><span onClick="mov_dept()"><spring:message code='ezOrgan.t82' /></span></a></td>
						</tr>
						<tr>
							<td height="15"><img <spring:message code='ezOrgan.i1' />></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="usermenu3"><span onClick="info_user()"><spring:message code='ezOrgan.t83' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn"><span onClick="add_user()"><spring:message code='ezOrgan.t84' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="usermenu2"><span onClick="del_user()"><spring:message code='ezOrgan.t85' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="usermenu1"><span onClick="mov_user()"><spring:message code='ezOrgan.t86' /></span></a></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="userRetire"><span onClick="Retire_user()"><spring:message code='ezOrgan.t310' /></span></a></td>
						</tr>
						<tr>
							<td height="15"><img <spring:message code='ezOrgan.i1' />></td>
						</tr>
						<%--<tr>
							<td><a class="imgbtn" id="usermenu12"><span onClick="mod_deptsign()"><spring:message code='ezOrgan.t87' /></span></a></td>
						</tr>
						<tr>
							<td height="15"><img <spring:message code='ezOrgan.i1' />></td>
						</tr>--%>
						<%--<tr>
							<td><a class="imgbtn" id="usermenu13"><span onClick="set_subtitle()"><spring:message code='ezOrgan.t88' /></span></a></td>
						</tr>--%>
						<tr>
							<td><a class="imgbtn" id="usermenu4"><span onClick="mod_sign()"><spring:message code='ezOrgan.t89' /></span></a></td>
						</tr>
						<tr>
							<td height="15"><img <spring:message code='ezOrgan.i1' />></td>
						</tr>
						<tr>
							<td><a class="imgbtn" id="usermenu5"><span onClick="mod_password()"><spring:message code='ezOrgan.t90' /></span></a></td>
						</tr>
						<!--
						<tr>
							<td><a class="imgbtn" id="usermenu6"><span onClick="mail_manage()"><spring:message code='ezOrgan.t91' /></span></a></td>
						</tr>		
						<tr>
							<td><a class="imgbtn" id="usermenu7"><span onClick="mod_quota()"><spring:message code='ezOrgan.t92' /></span></a></td>
						</tr>		                
						-->
		                <c:if test="${useOCS == 'YES'}">
						<tr>
							<td><a class="imgbtn" id="usermenusipuri"><span onClick="ocssip_manage()">Lync <spring:message code='ezOrgan.t1012' /></span></a></td>
						</tr>
						</c:if>			
						<!--			
						<tr>
		                	<td><a class="imgbtn" id="usermenu21"><span onClick="SettingMsn()"><spring:message code='ezOrgan.t1002' /></span></a></td>
		                </tr>
		                -->
					</table>
				</th>
			</tr>
			<tr>
				<th>
					<input id="deptkeyword" onKeyPress="deptsearch_press();" style="WIDTH:130px" />
					<a class="imgbtn" style="vertical-align:middle"><span onClick="deptsearch_click()"><spring:message code='ezOrgan.t93' /></span></a>
				</th>
				<th>
					<select id="search_type" style="WIDTH:60px">
						<option selected value="displayname"><spring:message code='ezOrgan.t67' /></option>
						<option value="cn"><spring:message code='ezOrgan.t94' /></option>
						<option value="description"><spring:message code='ezOrgan.t68' /></option>
						<option value="title"><spring:message code='ezOrgan.t69' /></option>
						<option value="telephonenumber"><spring:message code='ezOrgan.t95' /></option>
						<option value="mobile"><spring:message code='ezOrgan.t96' /></option>
						<option value="HomePhone"><spring:message code='ezOrgan.t97' /></option>
						<option value="facsimileTelephoneNumber"><spring:message code='ezOrgan.t98' /></option>
						<option value="mail"><spring:message code='ezOrgan.t99' /></option>
						<option value="streetAddress"><spring:message code='ezOrgan.t100' /></option>
					</select>
					<input id="keyword" onKeyPress="search_press()" style="WIDTH:100px" />
					<a class="imgbtn" style="vertical-align:middle"><span onClick="search_click()"><spring:message code='ezOrgan.t101' /></span></a>
				</th>
			</tr>
		    <tr>
		        <th style="padding: 3px; text-align: left; font-weight: normal;vertical-align:top">
		            <div style="border: 1px solid #b6b6b6; height: 510px; width: 280px; overflow: auto; background-color: #FFFFFF" id="TreeView"></div>
		        </th>
		        <th style="padding: 3px; text-align: left;vertical-align:top">
		            <div class="listview">
		                <div id="OrganListView" style="border: 0px solid #B6B6B6; Width: 350px; Height: 480px; overflow-x: hidden; BACKGROUND-COLOR: white; overflow-y:scroll; "></div>
		            </div>
		            <div style="height: 5px; overflow: hidden">&nbsp;</div>
		            <div style="width:100%; vertical-align:middle; text-align:center">
		            	<img style="cursor:pointer;" <spring:message code='ezOrgan.i2' />>&nbsp;<span style="padding-top:5px; display: inline-block;"><spring:message code='ezOrgan.t102' /></span>
						<img style="cursor:pointer;" <spring:message code='ezOrgan.i3' />>&nbsp;<span style="padding-top:5px; display: inline-block;"><spring:message code='ezOrgan.t103' /></span>
		                <a class="imgbtn" name="MoveConfirm"><span onClick="MoveConfirm_onclick()"><spring:message code='ezOrgan.t104' /></span></a>
		            </div>
		        </th>
		    </tr>
		</table>
	</body>
</html>