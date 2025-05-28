<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code='ezApprovalG.csj02'/></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewCtrl_Cross.js')}"></script>
	<style>
		.mainlist tr th { border-top:0px }
	</style>
	<script type="text/javascript">
		var Tab1_flag = true;
		var Tab1_SelectID = "";
		var treeView = new TreeView();
		var lvtDeptSelect = new ListView();
		var OrderCell = "";
		
		$(document).ready(function(){
			ListChange();
		});
		
		//저장Btn Action
		function Save() {
			var docNumZeroCnt = document.getElementById("docNumZeroCnt"); 
			
			if (!ValidationValues(docNumZeroCnt)) {
				docNumZeroCnt.focus();
				return;
			} else {
				SaveDocNumConfig();
			}
		}
		
		//입력필드 유효성 검사
		function ValidationValues(target) {
			var resultVal = false;
			
			if (target.value.trim() == "") {
				alert("<spring:message code='ezApprovalG.csj05'/>");
			} else if (!target.value.match(/^\d+$/)) {
				alert("<spring:message code='ezApprovalG.csj06'/>");
			} else if (parseInt(target.value) >= 9) {
				alert("<spring:message code='ezApprovalG.csj08'/>");
			} else if (parseInt(target.value) < 1) {
				alert("<spring:message code='ezApprovalG.csj07'/>");
			} else {
				resultVal = true;
			}
			
			return resultVal;
		}
		
		//유효성 검사 후, 저장 ajax
		function SaveDocNumConfig() {
			var companyID = document.getElementById("ListCompany").value;
			var docNumVal = parseInt(document.getElementById("docNumZeroCnt").value);
			
			$.ajax({
            	type : "POST",
            	dataType: "text",
            	url : "/admin/ezApprovalG/setDocNumZeroCnt.do",
            	async : false,
            	data : 
            	{
            		docNumCnt : docNumVal,
            		companyID : companyID
            	},
            	success : function (result) {
            		alert("<spring:message code='ezApprovalG.t1581'/>");
            		ListChange();
            	},
            	error : function(e) {
            		alert("<spring:message code='ezApprovalG.t1296'/>")
            	}
            });
		}
		
		//선택 회사 조회Action
		function ListChange() {
			var companyID = document.getElementById("ListCompany").value;
			
			if(Tab1_SelectID == "001") {
				$.ajax({
	            	type : "POST",
	            	dataType: "text",
	            	url : "/admin/ezApprovalG/getDocNumZeroCnt.do",
	            	async : false,
	            	data : 
	            	{
	            		companyID : companyID
	            	},
	            	success : function (result) {
	            		document.getElementById("docNumZeroCnt").value = result;
	            	},
	            	error : function(e) {
	            		alert("listChange() error!");
	            	}
	            });
			} else {
				Tree_setconfig();
				TreeViewinitialize("", "Top/organ", "extensionAttribute2;displayName", "<c:out value='${serverName}'/>", null, null, true);
				
				lvtDeptSelect.SetID("lvtDeptSelForm");
		        lvtDeptSelect.SetMulSelectable(true);
		        lvtDeptSelect.SetRowOnDblClick("lvtDeptSelect_rowdblclick");
		        
				lvtDeptSelectListView();
			}
		}
		
		function lvtDeptSelect_rowdblclick() {
			DeleteDept();
		}
		
		//조회Action Complete메소드(조회값이 1개뿐이라 만들어놓기만)
		/* function listChange_Complete(val) {
			document.getElementById("docNumZeroCnt").value = val;
		} */
		
		function Tree_setconfig() {
	        var xmlHTTP = createXMLHttpRequest();
	        xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
	        xmlHTTP.send();
	        
	        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {		            
	            treeView.SetConfig(xmlHTTP.responseXML);
	        }
	    }

	    function lvtDeptSelectListView() {
	    	var targetDept = document.getElementsByName("targetDept")[0].value;
	    
	        var xmlRtn = createXmlDom();
		    var xmlpara = createXmlDom();
		    var objNode;
		        
	        createNodeInsert(xmlpara, objNode, "PARAMETER");
			if(targetDept == "") {
		    	createNodeAndInsertText(xmlpara, objNode, "NODE1", "");
		    	createNodeAndInsertText(xmlpara, objNode, "NODE2", "");
	    	} else {
	    		treeView.LoadFromID("FromTreeView");
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);
	    		
	    		createNodeAndInsertText(xmlpara, objNode, "NODE1", treeNode.GetNodeData("CN"));
		    	createNodeAndInsertText(xmlpara, objNode, "NODE2", treeNode.GetNodeData("EXTENSIONATTRIBUTE2"));
	    	}
		        
	        var xmlhttp = createXMLHttpRequest();
	        xmlhttp.open("POST", "/admin/ezApprovalG/getChaebunDeptList.do", false);
	        xmlhttp.send(xmlpara);
	        xmlRtn = loadXMLString(xmlhttp.responseText);

	        document.getElementById('lvtDeptSelect').innerHTML = "";
	        lvtDeptSelect.DataSource(xmlRtn); 
	        lvtDeptSelect.DataBind("lvtDeptSelect");
	    }
	    
	    function TreeViewNodeClick() { }
		
		/* 탭 이동 관련 이벤트 1 [리스트 변경] */
		function ChangeTab(obj) {
			$("#searchValue").val("");
			
			pSearchValue = "";
			pCurPage = 1;
			
			if(Tab1_SelectID == "001") {
				document.getElementById("mainmenu").style.display = "";
				document.getElementById("mainmenu2").style.display = "none";
				document.getElementById("ListCompany").style.display = "";
			} else {
				document.getElementById("mainmenu").style.display = "none";
				document.getElementById("mainmenu2").style.display = "";
				document.getElementById("ListCompany").style.display = "none";
				
				document.getElementsByName("targetDept")[0].value = "";
				document.getElementById('lvtDeptSelect').innerHTML = "";
			}
			ListChange();
			
		}
		/* 탭 이동 관련 이벤트 2 [마우스오버] */
	    function Tab1_MouserOver(obj) {
	        obj.className = "tabover";
	    }
	    /* 탭 이동 관련 이벤트 3 [마우스아웃] */
	    function Tab1_MouserOut(obj) {
	        if (Tab1_SelectID != obj.id) {
	            obj.className = "";
	        }
	    }
	    /* 탭 이동 관련 이벤트 4 [마우스클릭] */
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
	    /* 탭 이동 관련 이벤트 5 [탭 init이벤트] */
	    function Tab1_NewTabIni(pTabNodeID) {
	        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	            if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
	                if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
	                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab1_MouserOver(this); };;
	                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab1_MouserOut(this); };;
	                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };;
	
	                    if (Tab1_flag) {
	                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
	                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
	                        Tab1_flag = false;
	                    }
	                }
	            }
	        }
	    }
	    /* Tab관련 메소드들 ↑ */
	    
	    function InsertTargetDept() {
	    	treeView.LoadFromID("FromTreeView");
	        var nodeIdx = treeView.GetSelectNode();
	        var treeNode = new TreeNode();
	        treeNode.LoadFromID(nodeIdx.NodeID);
	        
	    	document.getElementsByName("targetDept")[0].value = treeNode.GetNodeData("DISPLAYNAME1");
	    	document.getElementsByName("targetDept")[0].setAttribute("id", treeNode.GetNodeData("ID"));
	    	document.getElementsByName("targetDept")[0].setAttribute("data1", treeNode.GetNodeData("CN"));
	    	document.getElementsByName("targetDept")[0].setAttribute("data2", treeNode.GetNodeData("DISPLAYNAME1"));
	    	document.getElementsByName("targetDept")[0].setAttribute("data3", treeNode.GetNodeData("extensionattribute2"));
	    	
	    	lvtDeptSelectListView();
	    }
	    
	    function DeleteTargetDept() {
	    	document.getElementsByName("targetDept")[0].value = "";
	    	document.getElementsByName("targetDept")[0].setAttribute("id", "");
	    	document.getElementsByName("targetDept")[0].setAttribute("data1", "");
	    	document.getElementsByName("targetDept")[0].setAttribute("data2", "");
	    	document.getElementsByName("targetDept")[0].setAttribute("data3", "");
	    	
	    	lvtDeptSelectListView();
	    }
	    
	    function InsertDept() {
	    	treeView.LoadFromID("FromTreeView");
	        var nodeIdx = treeView.GetSelectNode();
	        var treeNode = new TreeNode();
	        treeNode.LoadFromID(nodeIdx.NodeID);
	        
	        var InitTr = lvtDeptSelect.GetDataRows();
	        var MaxID = 0;
	        var objTr;
	        var selectDeptNodeId = document.getElementsByName("targetDept")[0].id
	        
	        // 1. 채번부서를 선택했는지 확인
	        if(selectDeptNodeId == "") {
	        	alert(strLang970);
	        	return;
	        }
	        
	        // 2. 현재 선택한 부서가 채번부서의 하위 부서인지 체크
	        if(treeNode.GetNodeData("ID").indexOf(selectDeptNodeId) == -1) {
	        	alert(strLang971)
	        	return;
	        }
	        
	        // 3. 중복 추가된 부서 체크
	        if(DuplicateDeptCheck(treeNode.GetNodeData("CN"))) {
	        	return;
	        }
	        
	        if (InitTr.length > 0 && InitTr[0].id.indexOf("noItems") == -1) {
	    	    for (var i = 0; i < InitTr.length; i++) {
	    	        var curnum = Number(lvtDeptSelect.GetSelectedRowID(i).substring(lvtDeptSelect.GetSelectedRowID(i).lastIndexOf('_') + 1), lvtDeptSelect.GetSelectedRowID(i).length);
	    	        if (MaxID < curnum)
	    	            MaxID = curnum;
	    	    }
	    	    
	    	    objTr = lvtDeptSelect.AddRow(InitTr.length);
	        } else {
	        	objTr = lvtDeptSelect.AddRow(0);
	        }
	        
	        var pparsingXML = "<CELL>";
	        pparsingXML += "<VALUE>" + MakeXMLString(treeNode.GetNodeData("DISPLAYNAME1")) + "</VALUE>";
        	pparsingXML += "<DATA1>" + treeNode.GetNodeData("CN") + "</DATA1>";
        	pparsingXML += "<DATA2>" + treeNode.GetNodeData("EXTENSIONATTRIBUTE2") + "</DATA2>";
        	pparsingXML += "<DATA3>" + MakeXMLString(treeNode.GetNodeData("DISPLAYNAME1")) + "</DATA3>";
        	pparsingXML += "</CELL>";
	        var objXML = loadXMLString(pparsingXML);
	        
	        SetAttribute(objTr, "id", "lvtDeptSelForm" + "_TR_" + eval(MaxID + 1));
	        lvtDeptSelect.AddDataRow(objTr, objXML);
	    }
	    
	    function DuplicateDeptCheck(deptID) {
	    	var CurSelRow = lvtDeptSelect.GetDataRows();
	    	
	    	for(var i=0; i<CurSelRow.length; i++) {
	    		var selDeptID = CurSelRow[i].getAttribute("data1");
	    		if(deptID == selDeptID) {
	    			return true;
	    			break;
	    		}
	    	}
	    	
	    	return false;
	    }
	    
	    function InsertDeptAll() {
	    	treeView.LoadFromID("FromTreeView");
            var nodeIdx = treeView.GetSelectNode();
            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx.NodeID);
            
			var selectDeptNodeId = document.getElementsByName("targetDept")[0].id
 	        
 	        if(selectDeptNodeId == "") {
 	        	alert(strLang970);
 	        	return;
 	        }
			
			if(treeNode.GetNodeData("ID").indexOf(selectDeptNodeId) == -1) {
	        	alert(strLang971)
	        	return;
	        }
            
	    	var pAlertContent = "<spring:message code='ezApprovalG.t1361'/>";
	        var Ans = OpenInformationUI(pAlertContent);
	    }
	    
	    var ezapropinion_cross_dialogArguments = new Array();
        function OpenInformationUI(pInformationContent) {
            ezapropinion_cross_dialogArguments[0] = pInformationContent;
            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
            ezapropinion_cross_dialogArguments[2] = true;
            var ezAPROPINION_Cross = window.open("/ezApprovalG/ezAprOpinion.do", "ezAPROPINION", GetOpenWindowfeature(330, 205));
            try { ezAPROPINION_Cross.focus(); } catch (e) {
            }
        }
        
        function OpenInformationUI_Complete(RtnVal) {
        	if (!RtnVal) {
                return;
            }
        	
        	treeView.LoadFromID("FromTreeView");
            var nodeIdx = treeView.GetSelectNode();
            var treeNode = new TreeNode();
            treeNode.LoadFromID(nodeIdx.NodeID);

            if (nodeIdx.NodeID != null) {
                chkAllDept(treeNode.GetNodeData("CN"), treeNode.GetNodeData("DISPLAYNAME1"), treeNode.GetNodeData("DISPLAYNAME2"), treeNode.GetNodeData("EXTENSIONATTRIBUTE2"));
            }
        }
        
        function chkAllDept(deptID, deptName, deptName2, companyID) {
        	var DuplicateFlag = DuplicateDeptCheck(deptID);
        	
        	if (!DuplicateFlag) {
        		AddDept(deptID, deptName, companyID);
            }
        	
        	var xmlHTTP = createXMLHttpRequest();
            var strQuery = "<DATA><DEPTID>" + deptID + "</DEPTID><PROP>extensionAttribute2;displayName</PROP></DATA>";
            xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
            xmlHTTP.send(strQuery);
            
            var xmlNodes;
            xmlNodes = SelectNodes(xmlHTTP.responseXML, "NODES/NODE");
            if (xmlNodes.length > 0) {
                for (var i=0; i<xmlNodes.length; i++) {
                    chkAllDept(SelectSingleNodeValue(xmlNodes.item(i), "CN"), SelectSingleNodeValue(xmlNodes.item(i), "DISPLAYNAME1"), SelectSingleNodeValue(xmlNodes.item(i), "DISPLAYNAME2"), SelectSingleNodeValue(xmlNodes.item(i), "EXTENSIONATTRIBUTE2"));
                }
            }
            return;
        }
        
        function AddDept(deptID, deptName, companyID) {
        	var InitTr = lvtDeptSelect.GetDataRows();
        	var MaxID = 0;
        	var objTr;
        	
        	if (InitTr.length > 0 && InitTr[0].id.indexOf("noItems") == -1) {
	    	    for (var i = 0; i < InitTr.length; i++) {
	    	        var curnum = Number(lvtDeptSelect.GetSelectedRowID(i).substring(lvtDeptSelect.GetSelectedRowID(i).lastIndexOf('_') + 1), lvtDeptSelect.GetSelectedRowID(i).length);
	    	        if (MaxID < curnum)
	    	            MaxID = curnum;
	    	    }
	    	    
	    	    objTr = lvtDeptSelect.AddRow(InitTr.length);
	        } else {
	        	objTr = lvtDeptSelect.AddRow(0);
	        }
	        
	        var pparsingXML = "<CELL>";
	        pparsingXML += "<VALUE>" + MakeXMLString(deptName) + "</VALUE>";
        	pparsingXML += "<DATA1>" + deptID + "</DATA1>";
        	pparsingXML += "<DATA2>" + companyID + "</DATA2>";
        	pparsingXML += "<DATA3>" + MakeXMLString(deptName) + "</DATA3>";
        	pparsingXML += "</CELL>";
	        var objXML = loadXMLString(pparsingXML);
	        
	        SetAttribute(objTr, "id", "lvtDeptSelForm" + "_TR_" + eval(MaxID + 1));
	        lvtDeptSelect.AddDataRow(objTr, objXML);
        }
        
        function insertNoItems() {
        	var objTr = document.createElement("TR");
    		objTr.setAttribute("id", "lvtDeptSelForm_TR_noItems");

    		var oText = document.createTextNode(strLang944);
    		
    		var objTd = document.createElement("TD");
        	objTd.align = "center";
        	
        	var colCount = document.getElementById("lvtDeptSelForm").getElementsByTagName("th").length;
        	
        	objTd.setAttribute("colSpan", colCount);
        	objTd.appendChild(oText);
        	objTr.appendChild(objTd);
        	
        	document.getElementById("lvtDeptSelForm").getElementsByTagName("tbody")[0].appendChild(objTr);
        }
	    
	    function DeleteDept() {
	    	try {
		        var CurSelRow = lvtDeptSelect.GetSelectedRows();
		        for(var i=0; i<CurSelRow.length; i++)
			        lvtDeptSelect.DeleteRow(GetAttribute(CurSelRow[i], "id"));
		        
		        if (lvtDeptSelect.GetDataRows().length <= 0) {
		        	insertNoItems();
		        }
	    	} catch(e) {
	    		alert(strLang131 + '\n' + e);
	    	}
	    }
	    
	    function DeleteDeptAll() {
	    	try {
		    	var CurSelRow = lvtDeptSelect.GetDataRows();
		    	for (var i = 0; i < CurSelRow.length; i++) {
		    		lvtDeptSelect.DeleteRow(GetAttribute(CurSelRow[i], "id"));
		    	}
		    	
		    	insertNoItems();
		    } catch(e) {
		    	alert(strLang131 + '\n' + e);
	    	}
	    }
	    
	    function Save2() {
		    var xmlpara = createXmlDom();
		    var objNode;
		    var objRow, objRow2;
		    var subNode;
		    var InitTr = lvtDeptSelect.GetDataRows();
		    
		    if(document.getElementsByName("targetDept")[0].value == "") {
		    	alert(strLang970);
		    	return;
		    }
		    
		    var targetDeptID = document.getElementsByName("targetDept")[0].getAttribute("data1");
		    var targetDeptName = document.getElementsByName("targetDept")[0].getAttribute("data2");
		    var targetCompanyID = document.getElementsByName("targetDept")[0].getAttribute("data3");
		    
		    var objNode = createNodeInsert(xmlpara, objNode, "PARAMETER");
		    
		    objRow = createNodeAndAppandNode(xmlpara, objNode, objRow, "ROW");
		    
		    subNode = createNodeAndAppandNodeText(xmlpara, objRow, subNode, "DEPTID", targetDeptID);
		    subNode = createNodeAndAppandNodeText(xmlpara, objRow, subNode, "DEPTNAME", targetDeptName);
		    subNode = createNodeAndAppandNodeText(xmlpara, objRow, subNode, "COMPANYID", targetCompanyID);
		    
		    objRow = createNodeAndAppandNode(xmlpara, objNode, objRow, "ROWS");
		    if (InitTr.length > 0 && InitTr[0].id.indexOf("noItems") == -1) {
			    for(var i=0; i<InitTr.length; i++) {
			    	var curDeptID = InitTr[i].getAttribute("data1");
			    	var curDeptName = InitTr[i].getAttribute("data3");
			    	
			    	objRow2 = createNodeAndAppandNode(xmlpara, objRow, objRow2, "ROW");
				    
			    	subNode = createNodeAndAppandNodeText(xmlpara, objRow2, subNode, "DEPTID", curDeptID);
				    subNode = createNodeAndAppandNodeText(xmlpara, objRow2, subNode, "DEPTNAME", curDeptName);
			    }
		    }
		    
	    	var xmlhttp = createXMLHttpRequest();
	        xmlhttp.open("POST", "/admin/ezApprovalG/setChaebunDeptList.do", false);
	        xmlhttp.send(xmlpara);
	        var xmlRtn = xmlhttp.responseText;
	        
	        if(xmlRtn == "error"){
	    		alert(strLang131 + '\n' + e);
			} else if(xmlRtn == "OK"){
				alert(strLang490);
			} else {
				alert(strLang972 + "\n" + xmlRtn);
			}
	    }
	</script>
</head>
<body class="mainbody">
	<h1>
		<spring:message code='ezApprovalG.csj02'/>
		<span class="title_bar"><img src="/images/name_bar.gif"></span>
		<select class="companySelect" id="ListCompany" onChange="ListChange()">
			<c:forEach var="item" items="${list}">
				<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
			</c:forEach>
		</select>
	</h1>
	<div class="portlet_tabpart01" style="width: 100%; display:none;">
		<div class="portlet_tabpart01_top" id="tab1">
			<p><span id="001" class="tabover"><spring:message code='ezApprovalG.chaebun01'/></span></p>
			<p><span id="002"><spring:message code='ezApprovalG.chaebun02'/></span></p>
	    </div>
	</div>
	<div id="mainmenu" style="width: 350px;margin-top:30px">
		<div style="margin-top:3px;">▒&nbsp;<spring:message code='ezApprovalG.csj04'/></div>
		<div style="margin-top:3px;">▒&nbsp;<spring:message code='ezApprovalG.csj12'/></div>
		<br/>
		<table class="content">
			<tr>
				<th><spring:message code='ezApprovalG.csj09'/></th>
				<td>
					<spring:message code='ezApprovalG.csj11'/> : 1 ,
					<spring:message code='ezApprovalG.csj10'/> : 8
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezApprovalG.csj03'/></th>
				<td><input type="text" id="docNumZeroCnt" style="width: 275px; padding-left: 5px;"/></td>
			</tr>
		</table>
		<div class="btnpositionJsp">
			<a class="imgbtn" onClick="Save()"><span><spring:message code='main.sp09' /></span></a>
	    </div>
	</div>
	<div id="mainmenu2" style="margin-top:30px;display:none">
		<div style="margin-top:3px;">▒&nbsp;<spring:message code='ezApprovalG.chaebun03' /></div>
		<div style="margin-top:3px;">▒&nbsp;<spring:message code='ezApprovalG.chaebun04' /></div>
		<div style="margin-top:3px;">▒&nbsp;<spring:message code='ezApprovalG.chaebun05' /></div>
		<br/>
		<table>
			<tbody>
				<tr>
		           	<td style="vertical-align: top;">
		               	<h2 class="h2_dot" style="padding-top:0px"><spring:message code='ezApprovalG.t232'/></h2>
		               	<div class="box" style="overflow: auto; height: 400px; width: 350px;" id="TreeView" onrequestdata="RequestData()" onnodeselect="TreeViewNodeClick()" onnodedblclick="TreeView.toggle(TreeView.selectedIndex)"></div>
		           	</td>
		           	<td style="vertical-align: top;">
	                <table id="listType1" style="margin-top:1px;">
	                    <tbody>
		                    <tr id="ListTargetDept">
		                        <td style="width: 30px; text-align: center; padding: 5px;">
		                        	<br>
		                        	<img src="/images/arr_right.gif" alt="" border="0" style="cursor: pointer; margin-top:3px" onclick="InsertTargetDept()"><br>
		                            <img src="/images/arr_left.gif" alt="" border="0" style="cursor: pointer;" onclick="DeleteTargetDept()">
		                        </td>
		                        <td style="vertical-align: top;">
		                            <h2 id="ToTitle" class="h2_dot" style="font-weight: bold;">
		                                <span style="min-width: 45px;" id="ToTitleStr"><spring:message code='ezApprovalG.chaebun06' /></span>
		                            </h2>
		                            <input type="text" name="targetDept" style="width:360px;" readonly>
		                        </td>
		                    </tr>
		                    <tr id="ListCriteriaDept">
		                        <td style="width: 30px; text-align: center; padding: 5px;">
		                            <img src="/images/arr_rright.gif" alt="" border="0" style="cursor: pointer; margin-top:3px" id="imgInsertAll" onclick="return InsertDeptAll();"><br>
		                            <img src="/images/arr_right.gif" alt="" border="0" style="cursor: pointer; margin-top:3px" onclick="InsertDept()"><br>
		                            <img src="/images/arr_left.gif" alt="" border="0" style="cursor: pointer; margin-top:3px" onclick="DeleteDept()"><br>
		                        	<img src="/images/arr_lleft.gif" alt="" border="0" style="cursor: pointer;" id="imgDeleteAll" onclick="return DeleteDeptAll();">
		                        </td>
		                        <td style="vertical-align: top;">
		                            <br>
		                            <h2 id="CriteriaDept" class="h2_dot" style="font-weight: bold;">
		                                <span style="min-width: 45px;"><spring:message code='ezApprovalG.chaebun07' /></span>
		                            </h2>
		                            <div class="listview">
				                    	<div id="lvtDeptSelect" style="OVERFLOW-Y: auto; OVERFLOW-X: hidden; BACKGROUND-COLOR: #ffffff; Width: 360px; Height: 320px; font-size: 9pt"></div>
				                	</div>
		                        </td>
		                    </tr>
	                	</tbody>
	                </table>
	            	</td>
		       	</tr>
	       	</tbody>
		</table>
		<div class="btnpositionJsp" style="width:700px;">
			<a class="imgbtn" onclick="Save2()"><span><spring:message code='main.sp09' /></span></a>
	    </div>
	</div>
</body>
<script type="text/javascript">
	Tab1_NewTabIni("tab1");
</script>
</html>