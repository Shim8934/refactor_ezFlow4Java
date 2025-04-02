<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<style>
			.btnDwn:hover span{color: #0470E4;}
			.mainlist tr th { border-top:0px }

			#excelFile {
				visibility: hidden;
				float: left;
				position: relative;
				width: 58px;
				height: 31px;
				right: 122px;
			}

			.info-message {
				right: 54px;
				position: relative;
				line-height: 31px;
				color: #ff2828;
			}
			.tree_plus {margin-top: -3px !important;}
			.tree_minus {margin-top: 0px !important;}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewCtrl_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGReceiveGroup.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script src="${util.addVer('/js/ezApprovalG/Lineinfo.js')}" type="text/javascript"></script>
		
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var OrderCell = "";
	        var p_groupid = "";
	        var lvtDept = new ListView();
	        var lvtDeptSelect = new ListView();
	        var treeView = new TreeView();
	        var useReceiveInfoName = "<c:out value='${useReceiveInfoName}'/>"; // 수신처 뒤에 "장"을 붙이는지 여부 (0 : 안붙임 / 1 : 붙임 / 2: 상위부서 + 수신처장)	        
		    
		    $(document).ready(function(){
		    	document.getElementById("SCompID").value = companySelectID;
		    	initializeApprGReceoveGroup();
		    	
                // 외부수신처 비동기로 호출
                initReceptOuter();
		    });
		    
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
		        xmlHTTP.send();
		        
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {		            
		            treeView.SetConfig(xmlHTTP.responseXML);
		        }
		    }

		    function InitlvtDeptListView() {
		        lvtDept.SetID("lvtDeptForm");
		        lvtDept.SetMulSelectable(false);
		        lvtDept.SetRowOnClick("lvtDept_SelChange");
		        lvtDept.DataBind("lvtDept");
		    }

		    function InitlvtDeptSelectListView() {
				document.getElementById('lvtDeptSelect').innerHTML = "";
		        lvtDeptSelect.SetID("lvtDeptSelForm");
		        lvtDeptSelect.SetMulSelectable(false);
		        lvtDeptSelect.SetRowOnClick("lvtDeptSelect_SelChange");
		        lvtDeptSelect.SetRowOnDblClick("lvtDeptSelect_rowdblclick");
		        lvtDeptSelect.DataBind("lvtDeptSelect");
		    }
		    
		    function getAdminReceivGroup() {
		        var xmlRtn = createXmlDom();
		        var xmlpara = createXmlDom();
		        var objNode;

		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "NODE1", "");
		        createNodeAndInsertText(xmlpara, objNode, "NODE2", "GROUP");
		        createNodeAndInsertText(xmlpara, objNode, "NODE3", document.getElementById("SCompID").value);

		        xmlhttp.open("POST", "/admin/ezApprovalG/getAdminReceivGroup.do", false);
		        xmlhttp.send(xmlpara);

		        xmlRtn = loadXMLString(xmlhttp.responseText);

		        document.getElementById('lvtDept').innerHTML = "";
		        lvtDept.DataSource(xmlRtn);
		        lvtDept.DataBind("lvtDept");
		        $("#lvtDeptForm_THEAD").remove();
		    }
		    
		    function lvtDept_SelChange() {
		        lvtDept.LoadFromID("lvtDeptForm");
		        var selRow = lvtDept.GetSelectedRows();

		        if (selRow.length > 0) {
		            getAdminReceivItem(selRow[0].getAttribute("DATA1"));
		            p_groupid = selRow[0].getAttribute("DATA1");
		            //pGroupID.innerText = selRow[0].getAttribute("DATA1");
		            pGroupName2.innerText = ConvertEntityReferenceToChar(selRow[0].cells[0].innerHTML);
		            pGroupName.value = ConvertEntityReferenceToChar(selRow[0].cells[0].innerHTML);
		        } else {
					p_groupid = "";
					pGroupName2.innerText = "";
					pGroupName.value = "";
				}
		    }
		    
		    function getAdminReceivItem(groupid) {
		        var xmlRtn = createXmlDom();
		        var xmlpara = createXmlDom();
		        var objNode;

		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "NODE1", groupid);
		        createNodeAndInsertText(xmlpara, objNode, "NODE2", "ITEM");
		        createNodeAndInsertText(xmlpara, objNode, "NODE3", document.getElementById("SCompID").value);
		        
		        xmlhttp.open("POST", "/admin/ezApprovalG/getAdminReceivGroup.do", false);
		        
		        xmlhttp.send(xmlpara);

		        xmlRtn = loadXMLString(xmlhttp.responseText);

		        document.getElementById('lvtDeptSelect').innerHTML = "";
		        lvtDeptSelect.DataSource(xmlRtn);
		        lvtDeptSelect.DataBind("lvtDeptSelect");
		        
		    }
		    
		    function DuplicateAprDeptCheck(DeptID) {
		        var AprDeptList;
		        var AprDeptListLen;
		        var deptID;

		        AprDeptList = lvtDeptSelect.GetDataRows();
		        AprDeptListLen = AprDeptList.length;
		        var i;

		        for (i = 0 ; i < AprDeptListLen ; i++) {
		            deptID = AprDeptList[i].getAttribute("DATA3");
		            
		            if (deptID == DeptID) {
		                return false;
		                break;
		            }
		        }
		        return true;
		    }
		    
		    function AprLineAddDept(selindex) {
		        var xmlRtn = createXmlDom();
		        var xmlpara = createXmlDom();
		        var objNode;

		        treeView.LoadFromID("FromTreeView");
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

		        var deptId = treeNode.GetNodeData("CN"); 
		        if (!isgetUser(deptId)) {
		            var pAlertContent = strLang291 + strLang1102;
		            alert(pAlertContent);
		            return;
		        }
		        if (!isReceiverChk(deptId)) {
		            var pAlertContent = strLang1101 + strLang1102;
		            alert(pAlertContent);
		            return;
		        }
		        
		        var companyId = document.getElementById("SCompID").value;
		        var upperDeptName = getParentDeptNameForDB(deptId);
		        var deptName = treeNode.GetNodeData("DISPLAYNAME1");
		        var resultDeptName = "";
		        
                if (useReceiveInfoName == '1') {
                    //현재부서명 + 장
                    resultDeptName = deptName + strLang93;
                } else if (useReceiveInfoName == '2') {
                    // 상위부서명(현재부서명 + 장)
                    if (!upperDeptName || deptId === companyId) { // 회사
                        resultDeptName = deptName + strLang93;
                    } else { // 부서
                        resultDeptName = upperDeptName + "(" + deptName + strLang93 + ")";
                    }
                } else {
                    //default
                    resultDeptName = deptName;
                }

		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "html",
		        	url : "/admin/ezApprovalG/setGroupSubItemInfo.do",
		        	async : false,
		        	data : {
		        		node1 : p_groupid,
		        		node2 : deptId,
		        		node3 : resultDeptName,
		        		node4 : companyId,
// 		        		node5 : treeNode.GetNodeData("EXTENSIONATTRIBUTE2"),
		        		node6 : resultDeptName
		        	},
		        	success : function() {
		        		getAdminReceivItem(p_groupid);
		        	},
		        	error : function(jqXHR, textStatus, errorThrown) {
		        		
		        	}
		        });

		    }
		    
		    function insertCont_onclick() {
		        if (p_groupid == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1561'/>";
		          	//2016-05-13 장진혁과장 -- UI 팝업창 alert로 교체
		            //OpenAlertUI(pAlertContent);		            
		            alert(pAlertContent);
		            return;
		        }
		        
                var currDiv = document.querySelector(".tabon").getAttribute("divname");
                if (currDiv === "ReceptOrgan") {
                    if (isExistDept(true)) {
                        var pAlertContent = "외부 수신자가 존재합니다.\n내부 수신자와 외부 수신자는 동시에 등록할 수 없습니다.";
                        alert(pAlertContent);
                        return;
                    }

			        treeView.LoadFromID("FromTreeView");
			        var nodeIdx = treeView.GetSelectNode();
			        var treeNode = new TreeNode();
			        treeNode.LoadFromID(nodeIdx.NodeID);
	
			        if (nodeIdx.NodeID != null) {
			            var DuplicateFlag = DuplicateAprDeptCheck(treeNode.GetNodeData("CN"));
			            
			            if (DuplicateFlag) {
			                AprLineAddDept(nodeIdx.NodeID);
			            } else {
			                var pAlertContent = "<spring:message code='ezApprovalG.t317'/>";
			            	//2016-05-13 장진혁과장 -- UI 팝업창 alert로 교체
			                //OpenAlertUI(pAlertContent);
			                alert(pAlertContent);
			                return;
			            }
			        }
                } else if (currDiv === "ReceptOuter") {
                    AprDeptOuterAdd_onclick();
                }
		    }
		    
		    function deleteGroupSubiteminfo(selRow) {
		        var pgid = selRow.getAttribute("DATA1");
		        var result = "";

		        $.ajax({
		        	type : "POST",
		        	dataType : "html",
		        	url : "/admin/ezApprovalG/deleteGroupSubiteminfo.do",
		        	async : false,
		        	data : { node1 : pgid, node2 : document.getElementById("SCompID").value },
		        	success : function(text) {
		        		result = text;
		        	}		        	
		        });		        
		        return result;
		    }
		    
		    function deleteCont_onclick() {
		        lvtDeptSelect.LoadFromID("lvtDeptSelForm");
		        var selRow = lvtDeptSelect.GetSelectedIndexes().split(",");
		        var subItem = lvtDeptSelect.GetDataRows()[selRow];

		        if (subItem) {
		            var rtn = deleteGroupSubiteminfo(subItem);
		            
		            if (rtn == "TRUE") {
		                try {
		                    subItem.remove();
		                } catch (e) {
		                    subItem.parentElement.removeChild(subItem);
		                }
		                
		                if (lvtDeptSelect.GetDataRows().length <= 0) {
				        	var objTr = document.createElement("TR");
				        	objTr.setAttribute("id", "lvtDeptSelForm_TR_noItems");
				        		
				        	var oText = document.createTextNode(strLang944);
				        	var objTd = document.createElement("TD");
				        	objTd.align = "center";
				        	
				        	var colCount = document.getElementById("lvtDeptSelForm").getElementsByTagName("th").length;
				        	objTd.setAttribute("colSpan", colCount);
				        	objTd.appendChild(oText);
				        	objTr.appendChild(objTd);
				        	
				        	document.getElementById("lvtDeptSelForm").appendChild(objTr);
				        }
		            }
		        }
		    }
		    
		    function insertAllCont_onclick() {
		        if (p_groupid == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1561'/>";
		          	//2016-05-13 장진혁과장 -- UI 팝업창 alert로 교체
		            //OpenAlertUI(pAlertContent);
		            alert(pAlertContent);
		            return;
		        }

		        var pAlertContent = "<spring:message code='ezApprovalG.t1361'/>";
		        var Ans = OpenInformationUI(pAlertContent);
		    }
		    
		    function deleteAllCont_onclick() {

		        var selRow = lvtDeptSelect.GetDataRows()
		        if (selRow.length > 0 && selRow[0].id != "lvtDeptSelForm_TR_noItems") {
		            for (i = selRow.length - 1; i >= 0; i--) {
		                var rtn = deleteGroupSubiteminfo(selRow[i]);
		                if (rtn == "TRUE") {
		                    try{
		                        selRow[i].remove();
		                    }
		                    catch (e) {
		                        selRow[i].parentElement.removeChild(selRow[i]);
		                    }
		                }
		            }
		            
		            if (lvtDeptSelect.GetDataRows().length <= 0) {
			        	var objTr = document.createElement("TR");
			        	objTr.setAttribute("id", "lvtDeptSelForm_TR_noItems");
			        		
			        	var oText = document.createTextNode(strLang944);
			        	var objTd = document.createElement("TD");
			        	objTd.align = "center";
			        	
			        	var colCount = document.getElementById("lvtDeptSelForm").getElementsByTagName("th").length;
			        	objTd.setAttribute("colSpan", colCount);
			        	objTd.appendChild(oText);
			        	objTr.appendChild(objTd);
			        	
			        	document.getElementById("lvtDeptSelForm").appendChild(objTr);
			        }
		        }
		    }
		    
		    function SCompID_onchange() {
		        getAdminReceivGroup();
		        p_groupid = "";
		        //pGroupID.innerText = "";
		        pGroupName2.innerText = "";
		        pGroupName.value = "";
		    }
		    
			function lvtDeptSelect_SelChange() { }
		    
		    function lvtDeptSelect_rowdblclick() {
		        deleteCont_onclick();
		    }
		    
		    function TreeViewNodeClick() { }
		    
		    function TreeCtrl_onNodeDblClick() {
		        displayMemberTree();
		        insertCont_onclick();
		    }
		    
		    function Updategroupmaininfo() {
				if(!document.getElementById("pGroupName").value){
					alert("<spring:message code='ezApprovalG.t1562'/>");
					return;
				}
		        $.ajax({
		        	type : "POST",
		        	dataType : "html",
		        	url : "/admin/ezApprovalG/updateGroupMainInfo.do",
		        	async : false,
		        	data : { 
		        		node1 : p_groupid, node2 : document.getElementById("pGroupName").value, node3 : document.getElementById("SCompID").value
		        	},
		        	success : function(result) {
		        		if (result == "TRUE") {
				            getAdminReceivGroup();
				            p_groupid = "";
				            //document.getElementById("pGroupID").innerText = "";
				            document.getElementById("pGroupName2").innerText = "";
				            document.getElementById("pGroupName").value = "";
				            lvtDept_SelChange();
				        }
		        	}		        	
		        });
		    }
		    
		    function SetGroupMainInfo() {
		        if (pGroupName.value == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1562'/>";
		            //2016-05-13 장진혁과장 -- UI 팝업창 alert로 교체
		            //OpenAlertUI(pAlertContent);
		            alert(pAlertContent);		            
		            return;
		        }
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "html",
		        	url : "/admin/ezApprovalG/setGroupMainInfo.do",
		        	async : false,
		        	data : { 
		        		node1 : document.getElementById("pGroupName").value, node2 : document.getElementById("SCompID").value
		        	},
		        	success : function(result) {
		        		if (result == "TRUE") {
		        			getAdminReceivGroup();
				            p_groupid = "";
				            //pGroupID.innerText = "";
				            pGroupName2.innerText = "";
				            pGroupName.value = "";
				            lvtDept_SelChange();
				        }
		        	}		        	
		        });
		    }
		    
		    function Deletegroupmaininfo() {
		    	var chkDel = false;
		    	
		        if (p_groupid == "") {		            
		            //2016-05-13 장진혁과장 -- UI 팝업창 alert로 교체
		            //OpenAlertUI("<spring:message code='ezApprovalG.t1563'/>");
		            alert("<spring:message code='ezApprovalG.t1563'/>");
		            return;
		        }
		        
		        if (confirm("<spring:message code='ezApprovalG.t999933'/>")) {
					chkDel = true;  	
		        }

		        if (chkDel) {
			        $.ajax({
			        	type : "POST",
			        	dataType : "html",
			        	url : "/admin/ezApprovalG/deleteGroupMainInfo.do",
			        	async : false,
			        	data : { 
			        		node1 : p_groupid, node2 : document.getElementById("SCompID").value
			        	},
			        	success : function(result) {
			        		if (result == "TRUE") {
			        			getAdminReceivGroup();
					            p_groupid = "";
					            //pGroupID.innerText = "";
					            pGroupName2.innerText = "";
					            pGroupName.value = "";
					            lvtDeptSelect.DataSource("");
					            if (lvtDept.GetRowCount() == 1 && lvtDept.GetDataRows()[0].getAttribute("id") == "lvtDeptForm_TR_noItems") {
					            	deleteAllCont_onclick();
					            } else {
						            lvtDept_SelChange();
					            }
					            
					            
					        } else {
					        	//2016-05-13 장진혁과장 -- UI 팝업창 alert로 교체
					            //OpenAlertUI("<spring:message code='ezApprovalG.t1564'/>");
					            alert("<spring:message code='ezApprovalG.t1564'/>");
					        }
			        	}, 
			        	error : function() {
			        		//2016-05-13 장진혁과장 -- UI 팝업창 alert로 교체
				            //OpenAlertUI("<spring:message code='ezApprovalG.t1564'/>");
				            alert("<spring:message code='ezApprovalG.t1564'/>");
			        	}
			        });
		        }
			}
		    
		    var ezapropinion_cross_dialogArguments = new Array();
	        function OpenInformationUI(pInformationContent) {
	            if (CrossYN()) {
	                ezapropinion_cross_dialogArguments[0] = pInformationContent;
	                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
	                ezapropinion_cross_dialogArguments[2] = true;
	                var ezAPROPINION_Cross = window.open("/ezApprovalG/ezAprOpinion.do", "ezAPROPINION", GetOpenWindowfeature(330, 205));
	                try { ezAPROPINION_Cross.focus(); } catch (e) {
	                }
	            }
	            else {
	                var parameter = pInformationContent;
	                var url = "../ezAPROPINION_Cross.aspx";
	                var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	                var RtnVal = window.showModalDialog(url, parameter, feature);
	                if (!RtnVal)
	                    return;

	                treeView.LoadFromID("FromTreeView");
	                var nodeIdx = treeView.GetSelectNode();
	                var treeNode = new TreeNode();
	                treeNode.LoadFromID(nodeIdx.NodeID);

	                if (nodeIdx.NodeID != null) {
	                    chkAllDept(treeNode.GetNodeData("CN"), treeNode.GetNodeData("DISPLAYNAME1"), treeNode.GetNodeData("DISPLAYNAME2"), treeNode.GetNodeData("EXTENSIONATTRIBUTE2"));
	                    getAdminReceivItem(p_groupid);
	                }
	            }
	        }

	        function OpenInformationUI_Complete(RtnVal) {
	            if (!RtnVal) {
	                return;
	            }
	            
                var currDiv = document.querySelector(".tabon").getAttribute("divname");
                if (currDiv === "ReceptOrgan") {
                    if (isExistDept(true)) {
                        var pAlertContent = "외부 수신자가 존재합니다.\n내부 수신자와 외부 수신자는 동시에 등록할 수 없습니다.";
                        alert(pAlertContent);
                        return;
                    }
	            
		            treeView.LoadFromID("FromTreeView");
		            var nodeIdx = treeView.GetSelectNode();
		            var treeNode = new TreeNode();
		            treeNode.LoadFromID(nodeIdx.NodeID);
	
		            if (nodeIdx.NodeID != null) {
		                chkAllDept(treeNode.GetNodeData("CN"), treeNode.GetNodeData("DISPLAYNAME1"), treeNode.GetNodeData("DISPLAYNAME2"), treeNode.GetNodeData("EXTENSIONATTRIBUTE2"));
		                getAdminReceivItem(p_groupid);
		            }
                } else if (currDiv === "ReceptOuter") {
                    AprDeptOuterAddAll_onclick();
                }
	        }
	        
	        function chkAllDept(aDeptID, aDeptName, aDeptName2, aCompanyID) {
	        	var DuplicateFlag = DuplicateAprDeptCheck(aDeptID);
	        	
	        	if (DuplicateFlag) {
	        		AddDept(aDeptID, aDeptName, aDeptName2, aCompanyID);
	            }

	            var xmlHTTP = createXMLHttpRequest();
	            var strQuery = "<DATA><DEPTID>" + aDeptID + "</DEPTID><PROP>extensionAttribute2;displayName</PROP></DATA>";
	            xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
	            xmlHTTP.send(strQuery);

	            var xmlNodes;
	            xmlNodes = SelectNodes(xmlHTTP.responseXML, "NODES/NODE");
	            if (xmlNodes.length > 0) {
	                var i = 0;
	                for (i = 0; i < xmlNodes.length; i++) {
	                    chkAllDept(SelectSingleNodeValue(xmlNodes.item(i), "CN"), SelectSingleNodeValue(xmlNodes.item(i), "DISPLAYNAME1"), SelectSingleNodeValue(xmlNodes.item(i), "DISPLAYNAME2"), SelectSingleNodeValue(xmlNodes.item(i), "EXTENSIONATTRIBUTE2"));
	                }
	            }
	            return;
	        }
	        
	        function AddDept(aDeptID, aDeptName, aDeptName2, aCompanyID) {
	        	
	            if (!isgetUser(aDeptID)) { 
	                return;
	            }
	            if (!isReceiverChk(aDeptID)) { 
	                return;
	            }
	            
	            var upperDeptName = getParentDeptNameForDB(aDeptID);
	            var resultDeptName = aDeptName;
	            if (useReceiveInfoName == '1') {
                    //현재부서명 + 장
                    resultDeptName = aDeptName + strLang93;
                } else if (useReceiveInfoName == '2') {
                    // 상위부서명(현재부서명 + 장)
                    if (!upperDeptName || aDeptID === aCompanyID) { // 회사
                        resultDeptName = aDeptName + strLang93;
                    } else { // 부서
                        resultDeptName = upperDeptName + "(" + aDeptName + strLang93 + ")";
                    }
                }

	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezApprovalG/setGroupSubItemInfo.do",
	            	async : false,
	            	data : { node1 : p_groupid, node2 : aDeptID, node3 : resultDeptName, node4 : document.getElementById("SCompID").value, node5 : aCompanyID, node6 : aDeptName2 },
	            	success : function(result) {
	            	}
	            });
	        }
	        
	        var aprdeptname_cross_dialogArguments = new Array();
		    function btnaddressChange() {
		        var listview = new ListView();
		        listview.LoadFromID("lvtDeptSelForm");
		        var CurSelRow = listview.GetSelectedRows();
		        var windowName = "/admin/ezApprovalG/aprDeptName.do";
		        var parameter = "status:no;dialogWidth:340px;dialogHeight:195px;scroll:no;edge:sunken;help:no";
		
		        if (CurSelRow[0] == undefined) {
		            alert("<spring:message code='ezApprovalG.t10501'/>");
		            return;
		        }
		        
		        var dialogValue = CurSelRow[0].cells[0].innerText;
		        if (CrossYN()) {
		            aprdeptname_cross_dialogArguments[0] = dialogValue;
		            aprdeptname_cross_dialogArguments[1] = btnaddressChange_Complete;
		            
		            var feature = "width=360, height=220, toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1";
		            feature = feature + GetOpenPosition(360, 220);
		            window.open(windowName, "", feature);
		            
// 		            DivPopUpShow(360, 220, windowName);
		        }
		        else {
		            parameter = parameter + GetShowModalPosition(330, 205);
		            var AddressName = window.showModalDialog(windowName, dialogValue, parameter);
		            if (AddressName == "cancel" || AddressName == undefined)
		                return;
		            if (CrossYN()) {
		                CurSelRow[0].cells[0].textContext = AddressName;
		                CurSelRow[0].cells[0].innerText = AddressName;
		            }
		            else {
		                CurSelRow[0].cells[0].innerText = AddressName;
		            }
		            SetAttribute(CurSelRow[0], "DATA5", AddressName);
		            SetAttribute(CurSelRow[0], "DATA6", AddressName);
		        }
		    }
		
		    function btnaddressChange_Complete(AddressName) {
		        if (AddressName == "cancel" || AddressName == undefined)
		            return;
		
		        var listview = new ListView();
		        listview.LoadFromID("lvtDeptSelForm");
		        var CurSelRow = listview.GetSelectedRows();
		
		        if (CrossYN()) {
		            CurSelRow[0].cells[0].textContext = AddressName;
		            CurSelRow[0].cells[0].innerText = AddressName;
		        }
		        else {
		            CurSelRow[0].cells[0].innerText = AddressName;
		        }
		        SetAttribute(CurSelRow[0], "DATA5", AddressName);
		        SetAttribute(CurSelRow[0], "DATA6", AddressName);
		        
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezApprovalG/updateGroupSubItemInfo.do",
		        	async : false,
		        	data : {
		        		node1 : p_groupid,
		        		node2 : CurSelRow[0].getAttribute("DATA3"),
		        		node3 : CurSelRow[0].getAttribute("DATA5"),
		        		node4 : CurSelRow[0].getAttribute("DATA4"),
		        		node6 : CurSelRow[0].getAttribute("DATA6")
		        	},
		        	success : function() {
		        		getAdminReceivItem(p_groupid);
		        	},
		        	error : function(jqXHR, textStatus, errorThrown) {
		        	}
		        });
		    }

			var excelUpload = function (obj){
				tempObj = obj;
				document.getElementById("excelFile").click();
			}

			var btn_AttachAdd_onclick = function () {
				var fd = new FormData();
				var _file = document.getElementById("excelFile").files[0];
				var ext = _file.name.split('.').pop().toLowerCase();

				if (_file.size / 1024 / 1024 > 5) {
					alert("<spring:message code = 'ezPoll.t208' />");
					return;
				}

				fd.append("file", _file);
				fd.append("ext", ext);
				var request = new XMLHttpRequest();

				if ( ext === "xls" || ext === "xlsx") {
					request.open("POST", "/admin/ezApprovalG/setGroupWithExcel.do", false);

					request.onload = function() {
						var result = request.responseText;

						if (result === "") {
							alert("<spring:message code='ezApprovalG.pgb04'/>");
						} else if (result === "error") {
							alert("<spring:message code='ezApprovalG.pgb09'/>");
						} else if (result === "ext out") {
							alert("<spring:message code='ezApprovalG.pgb03'/>");
						} else if (result === "no data") {
							alert("<spring:message code='ezApprovalG.pgb06'/>");
						} else if (result.indexOf("none deptId") >= 0 ) {
							alert("<spring:message code='ezApprovalG.pgb07'/>" + result.split(":")[1]);
						} else if (result.indexOf("duplicated") >= 0) {
							alert("<spring:message code='ezApprovalG.pgb08'/>" + result.split(":")[1]);
						} else {
							var tempNum = Number(result);

							if (!isNaN(tempNum)) {
								alert(tempNum + " <spring:message code='ezApprovalG.pgb05'/>");
							} else {
								alert("<spring:message code='ezApprovalG.pgb04'/>");
							}
						}
					}

					request.send(fd);
					window.location.reload();
				} else {
					alert("<spring:message code='ezApprovalG.pgb03'/>")
					return false;
				}
			}

			function initializeApprGReceoveGroup() {
				Tree_setconfig();
				TreeViewinitialize("", companySelectID + "/organ", "extensionAttribute2;displayName", "<c:out value='${serverName}'/>", null, null, true);
				InitlvtDeptListView();
				InitlvtDeptSelectListView();

				getAdminReceivGroup();
				// 페이지가 열리자마자 최상위 수신자 그룹 선택처리.
				lvtDept_SelChange();
			}

			function changeCompany() {
				document.getElementById("SCompID").value = companySelectID;
				lvtDept_SelChange();
				initializeApprGReceoveGroup();
			}
			
			function getParentDeptNameForDB(deptID) {
                var rtnVal = "";
                
                $.ajax({
                    type : "GET",
                    dataType : "json",
                    async : false,
                    url : "/ezOrgan/getUpperDeptName.do",
                    data : {
                        deptID : deptID
                    },
                    success: function(result) {
                        rtnVal = result.upperDeptName;
                    },
                    error: function(xhr, status, error){
                        console.log(error);
                        alert(strLang199);
                    },
                });
                
                return rtnVal;
            }
		</script>
	</head>
	<body class="mainbody">
	<h1>
		<c:choose>
			<c:when test="${approvalFlag == 'S' }">
				<spring:message code='main.t39'/>
			</c:when>
			<c:otherwise>
				<spring:message code='ezApprovalG.t718'/>
			</c:otherwise>
		</c:choose>
		<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp"/>
	</h1>
		<div id="mainmenu" style="padding-left: 5px;">
			<ul class="on">
				<li class="important off" id="2"><span onclick="excelUpload()"><spring:message code='ezApprovalG.pgb01'/></span></li>
				<c:if test="${userLang eq '2'}">
					<li id="3" class="off"><a href="<c:url value="/files/RecipientGroupBulkRegistrationForm2.xlsx"/>"><span><spring:message code='ezApprovalG.pgb02'/></span></a></li>
				</c:if>
				<c:if test="${userLang ne '2' && userLang ne '3'}">
					<li id="3" class="off btnDwn"><a href="<c:url value="/files/RecipientGroupBulkRegistrationForm1.xlsx"/>"><span><spring:message code='ezApprovalG.pgb02'/></span></a></li>
				</c:if>
				<c:if test="${userLang eq '3'}">
					<li id="3" class="off btnDwn"><a href="<c:url value="/files/RecipientGroupBulkRegistrationForm3.xlsx"/>"><span><spring:message code='ezApprovalG.pgb02'/></span></a></li>
				</c:if>
				<input type="file" name="excelFile" class="important off" id="excelFile" onchange="btn_AttachAdd_onclick()" />
				<span class="info-message"><spring:message code='ezApprovalG.pgb10'/></span>
			</ul>
		</div>
	    <table>
        	<tr>
        		<td style="vertical-align: top;">
        			<input type="hidden" id="SCompID" value="${userInfo.companyID }" >
                	<div class="listview">
                    	<div id="lvtDept" style="border: 0px solid #ddd; OVERFLOW-Y: auto; OVERFLOW-X: hidden; Width: 360px; Height: 110px;" onselchanged="return lvtDept_SelChange()"></div>
                	</div>
                	<br/>
            	</td>
            	<td>&nbsp;</td>
            	<td style="vertical-align: top;">
                	<table class="popuplist" style="width: 360px; height: 110px;">
                    	<tr>
                    		<c:choose>
                    			<c:when test="${approvalFlag == 'S' }">
		                        	<th id="pGroupID" style="width:25%;height:17px"><spring:message code = 'ezApproval.t227' /></th>
                    			</c:when>
                    			<c:otherwise>
		                        	<th id="pGroupID" style="width:25%;height:17px"><spring:message code = 'ezApprovalG.t1568' /></th>
                    			</c:otherwise>
                    		</c:choose>
                        	<td id="pGroupName2" style="word-break: break-all;width:75%;padding-left:5px;height:17px"></td>
                    	</tr>
                    	<tr>
	                        <td colspan="2">
	                            <input type="text" name="textfield" style="width: 98%; box-sizing: border-box; -moz-box-sizing: border-box; margin-left:3px" id="pGroupName" maxlength="50" />
	                            <div style="margin-top:10px;text-align:center">
		                            <a class="imgbtn imgbck"><span onclick="return Updategroupmaininfo()"><spring:message code='ezApprovalG.t1567'/></span></a>
	                            	<a class="imgbtn imgbck"><span onclick="return SetGroupMainInfo()"><spring:message code='ezApprovalG.t268'/></span></a>
	                            	<a class="imgbtn imgbck"><span onclick="return Deletegroupmaininfo()"><spring:message code='ezApprovalG.t266'/></span></a>
	                            </div>	
	                        </td>
	                    </tr>
                	</table>
            	</td>
        	</tr>
        	<tr>
            	<td style="vertical-align: top;">
                 	<%-- <h2><spring:message code='ezApprovalG.t232'/></h2> --%>
                    <div class="portlet_tabpart01" style="margin: 0;">
                        <div id="tab" class="portlet_tabpart01_top">
                            <p><span id="tab1" divname="ReceptOrgan" class="tabon" onclick="clickTab(event)"><spring:message code='ezApprovalG.t232'/></span></p>
							<c:if test="${approvalFlag eq 'G'}">
	                            <p><span id="tab2" divname="ReceptOuter" onclick="clickTab(event)">외부</span></p>
							</c:if>
                        </div>
                    </div>
                    <div id="ReceptOrgan">
                        <div class="box" style="overflow: auto; height: 594px; width: 360px;" id="TreeView" onrequestdata="RequestData()" onnodeselect="TreeViewNodeClick()" onnodedblclick="TreeView.toggle(TreeView.selectedIndex)"></div>
                    </div>
                    <div id="ReceptOuter" style="display: none;">
                        <div class="box" style="overflow: auto; height: 594px; width: 360px;" id="TreeView2"></div>
                    </div>
            	</td>
            	<td style="width: 30px; text-align: center;">
                	<img src="/images/arr_right.gif" onclick="return insertCont_onclick()" style="cursor: pointer">
                	<img src="/images/arr_left.gif" onclick="return deleteCont_onclick()" style="cursor: pointer;margin-top:5px">
                	<img src="/images/arr_rright.gif" onclick="return insertAllCont_onclick()" style="cursor: pointer;margin-top:5px">
                	<img src="/images/arr_lleft.gif" onclick="return deleteAllCont_onclick()" style="cursor: pointer;margin-top:5px">
            	</td>
            	<td style="vertical-align: top;">
            		<c:choose>
						<c:when test="${approvalFlag == 'S' }">
							<%-- <h2><spring:message code='ezApprovalG.t999932'/></h2> --%>
							<h2 class="h2_dot" style="padding-top:0px"><spring:message code='ezApprovalG.t999932'/></h2>
						</c:when>
						<c:otherwise>
							<%-- <h2><spring:message code='ezApprovalG.t53'/></h2> --%>
							<h2 class="h2_dot" style="padding-top:0px;height: 25px;"><spring:message code='ezApprovalG.t53'/></h2>
						</c:otherwise>
					</c:choose>
                	
                	<div class="listview">
                    	<div id="lvtDeptSelect" style="border: 0px solid #ddd; OVERFLOW-Y: auto; OVERFLOW-X: hidden; BACKGROUND-COLOR: #ffffff; Width: 360px; Height: 598px; font-size: 9pt" onselchanged="return lvtDeptSelect_SelChange()" onrowdblclick="return lvtDeptSelect_rowdblclick()"></div>
                	</div>
            	</td>
        	</tr>
			<tr>
				<td colspan="3">
					<a class="imgbtn imgbck" style="float: right;"><span id="Span6" onclick="return btnaddressChange()"><c:if test="${approvalFlag == 'G'}"><spring:message code='ezApprovalG.t348'/></c:if><c:if test="${approvalFlag == 'S'}"><spring:message code='ezApproval.t1104'/></c:if></span></a>
				</td>
			</tr>
    	</table>
    	<br/>
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
