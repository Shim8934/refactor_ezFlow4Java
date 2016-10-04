<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e3'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeViewCtrl_Cross.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var OrderCell = "";
	        var p_groupid = "";
	        var lvtDept = new ListView();
	        var lvtDeptSelect = new ListView();
	        var treeView = new TreeView();
		    
		    $(document).ready(function(){
		    	document.getElementById("SCompID").value = "<c:out value='${companyID}'/>";

	            Tree_setconfig();
	            TreeViewinitialize("", "<c:out value='${topID}'/>", "extensionAttribute2;displayName", "<c:out value='${serverName}'/>");
	        	InitlvtDeptListView();
	        	InitlvtDeptSelectListView();

	        	getAdminReceivGroup();
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
		    }
		    
		    function lvtDept_SelChange() {
		        lvtDept.LoadFromID("lvtDeptForm");
		        var selRow = lvtDept.GetSelectedRows();

		        if (selRow) {
		            getAdminReceivItem(selRow[0].getAttribute("DATA1"));
		            p_groupid = selRow[0].getAttribute("DATA1");
		            //pGroupID.innerText = selRow[0].getAttribute("DATA1");
		            pGroupName2.innerText = selRow[0].cells[0].innerHTML;
		            pGroupName.value = selRow[0].cells[0].innerHTML;
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

		        $.ajax({
		        	type : "POST",
		        	dataType : "html",
		        	url : "/admin/ezApprovalG/setGroupSubItemInfo.do",
		        	async : false,
		        	data : {
		        		node1 : p_groupid, node2 : treeNode.GetNodeData("CN"), node3 : treeNode.GetNodeData("DISPLAYNAME1"), node4 : document.getElementById("SCompID").value,
		        		node5 : treeNode.GetNodeData("EXTENSIONATTRIBUTE2"), node6 : treeNode.GetNodeData("DISPLAYNAME2")
		        	},
		        	success : function() {
		        		getAdminReceivItem(p_groupid);
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
		        if (selRow.length > 0) {
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
				        }
		        	}		        	
		        });
		    }
		    
		    function Deletegroupmaininfo() {
		        if (p_groupid == "") {		            
		            //2016-05-13 장진혁과장 -- UI 팝업창 alert로 교체
		            //OpenAlertUI("<spring:message code='ezApprovalG.t1563'/>");
		            alert("<spring:message code='ezApprovalG.t1563'/>");
		            return;
		        }

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
		    
		    var ezapropinion_cross_dialogArguments = new Array();
	        function OpenInformationUI(pInformationContent) {
	            if (CrossYN()) {
	                ezapropinion_cross_dialogArguments[0] = pInformationContent;
	                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
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
	            
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(nodeIdx.NodeID);

	            if (nodeIdx.NodeID != null) {
	                chkAllDept(treeNode.GetNodeData("CN"), treeNode.GetNodeData("DISPLAYNAME1"), treeNode.GetNodeData("DISPLAYNAME2"), treeNode.GetNodeData("EXTENSIONATTRIBUTE2"));
	                getAdminReceivItem(p_groupid);
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
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezApprovalG/setGroupSubItemInfo.do",
	            	async : false,
	            	data : { node1 : p_groupid, node2 : aDeptID, node3 : aDeptName, node4 : document.getElementById("SCompID").value, node5 : aCompanyID, node6 : aDeptName2 },
	            	success : function(result) {
	            	}
	            });
	        }
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezApprovalG.t718'/></h1>
	    <table>
        	<tr>
            	<td style="vertical-align: top;">
                	<h2><spring:message code='ezApprovalG.t1566'/></h2>
                	<table class="popuplist" style="width: 360px; height: 110px;">
                    	<tr>
                        	<td colspan="2">        
                            	<select id="SCompID" name="SCompID" onchange="SCompID_onchange()">
						    		<c:forEach var="item" items="${list}">
					            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
					            	</c:forEach>
					            </select>
                        	</td>
                    	</tr>
                    	<tr>
                        	<th id="pGroupID" style="width:25%">수신자그룹명</th>
                        	<td id="pGroupName2" style="word-break: break-all;width:75%;padding-left:5px"></td>
                    	</tr>
                    	<tr>
	                        <td colspan="2">
	                            <input type="text" name="textfield" style="width: 100%; box-sizing: border-box; -moz-box-sizing: border-box;" id="pGroupName" maxlength="50" />
	                            <div style="margin-top:1px">
		                            <a class="imgbtn"><span onclick="return Updategroupmaininfo()"><spring:message code='ezApprovalG.t1567'/></span></a>
	                            	<a class="imgbtn"><span onclick="return SetGroupMainInfo()"><spring:message code='ezApprovalG.t268'/></span></a>
	                            	<a class="imgbtn"><span onclick="return Deletegroupmaininfo()"><spring:message code='ezApprovalG.t266'/></span></a>
	                            </div>	
	                        </td>
	                    </tr>
                	</table>
            	</td>
            	<td>&nbsp;</td>
            	<td style="vertical-align: top;">
                	<h2><spring:message code='ezApprovalG.t1568'/></h2>
                	<div class="listview">
                    	<div id="lvtDept" style="border: 0px solid #B6B6B6; OVERFLOW-Y: auto; OVERFLOW-X: hidden; Width: 360px; Height: 110px;" onselchanged="return lvtDept_SelChange()"></div>
                	</div>
                	<br/>
            	</td>
        	</tr>
        	<tr>
            	<td style="vertical-align: top;">
                	<h2><spring:message code='ezApprovalG.t232'/></h2>
                	<div class="box" style="overflow: auto; height: 320px; width: 360px;" id="TreeView" onrequestdata="RequestData()" onnodeselect="TreeViewNodeClick()" onnodedblclick="TreeView.toggle(TreeView.selectedIndex)"></div>
            	</td>
            	<td style="width: 30px; text-align: center;">
                	<img src="/images/arr_right.gif" width="16" height="16" onclick="return insertCont_onclick()" style="cursor: pointer">
                	<img src="/images/arr_left.gif" width="16" height="16" onclick="return deleteCont_onclick()" style="cursor: pointer">
                	<img src="/images/arr_rright.gif" width="16" height="16" onclick="return insertAllCont_onclick()" style="cursor: pointer">
                	<img src="/images/arr_lleft.gif" width="16" height="16" onclick="return deleteAllCont_onclick()" style="cursor: pointer">
            	</td>
            	<td style="vertical-align: top;">
                	<h2><spring:message code='ezApprovalG.t53'/></h2>
                	<div class="listview">
                    	<div id="lvtDeptSelect" style="border: 0px solid #B6B6B6; OVERFLOW-Y: auto; OVERFLOW-X: hidden; BACKGROUND-COLOR: #ffffff; Width: 360px; Height: 320px; font-size: 9pt" onselchanged="return lvtDeptSelect_SelChange()" onrowdblclick="return lvtDeptSelect_rowdblclick()"></div>
                	</div>
            	</td>
        	</tr>
    	</table>
    	<br/>
	</body>
</html>
