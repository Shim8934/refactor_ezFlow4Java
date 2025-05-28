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
		<style>
			.mainlist tr th { border-top:0px }
			.tree_plus {margin-top: -3px !important;}
			.tree_minus {margin-top: 0px !important;}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewCtrl_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var labelcolor = "gray";
	        var OrderCell = "";
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var gManageID, gFContID, gParant, Flag, RtnState;
	        var DeptID;
	        var CompanyID = "<c:out value='${companyID}'/>";
	        var TopID = "<c:out value='${companyID}'/>";
	        var listview = new ListView();
		    var sDeptID;
	        
		    $(document).ready(function(){
	            InitListView();
	            Tree_setconfig();
				changeCompany();
		    });
		    
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
		        xmlHTTP.send();
		        
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlHTTP.responseXML);
		        }
		    }

		    function InitListView() {
		        var xmlTree = createXmlDom();
		        xmlTree = loadXMLString(FORMLIST.innerHTML.toUpperCase());

		        listview.SetID("lvtDocForm");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnClick("lvtForm_onSel_Changed");
		        listview.SetRowOnDblClick("lvtForm_onSel_DBclick");
		        listview.DataSource(xmlTree);
		        listview.DataBind("lvtForm");
		    }
		    
		    function TreeViewNodeClick(pNodeID) {
		        TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        CompanyID = treeNode.GetNodeData("EXTENSIONATTRIBUTE2");
		        sDeptID = treeNode.GetNodeData("CN");
		        getContInfo(sDeptID);
		    }
		    
		    function lvtForm_onSel_Changed() { }
		    function lvtForm_onSel_Click() { }
		    function lvtForm_onSel_DBclick() { }
		    function lvtForm_onclick() { }
		    
		    var tempDeptID;
		    function getContInfo(DeptID) {
		        tempDeptID = DeptID;
		        var xmlRtn = createXmlDom();		 
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezApprovalG/apprGMgetContInfo.do",
		        	async : false,
		        	data : {deptID : DeptID, comID : CompanyID},
		        	success : function(result){
		        		xmlRtn = loadXMLString(result);		        		
		        	},
		        	error : function() {
		        		xmlRtn = loadXMLString("<LISTVIEWDATA><HEADERS><HEADERS><ROWS></ROWS></LISTVIEWDATA>");
		        	}
		        });
		        
		        document.getElementById('lvtForm').innerHTML = "";
		        listview.DataSource(xmlRtn);
		        listview.DataBind("lvtForm");
		    }
		    
		    function changeCompany() {
		        if (CompanyID != document.getElementById("ListCompany").value) {
		            CompanyID = document.getElementById("ListCompany").value;
		            
		            TreeViewinitialize("", CompanyID, "extensionAttribute2", "<c:out value='${serverName}'/>", "", CompanyID, true);
		        }
		    }
		    
		    var mconttype_cross_dialogArguments = new Array();
		    function btnDocTypeReg_onclick() {
		        var para = new Array();
		        
		        if (CompanyID == "") {
		            alert("<spring:message code='ezApprovalG.t1588'/>");
		        } else {
		            para["P_companyID"] = CompanyID;
		            mconttype_cross_dialogArguments[0] = para;
		            var OpenWin = window.open("/admin/ezApprovalG/apprGMContType.do", "MContType_Cross", GetOpenWindowfeature(500, 500));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		    }
		    
		    var minsconttype_cross_dialogArguments = new Array();
		    function btnContTypeReg_onclick() {
		        var para = new Array();

		        if (CompanyID == "") {
		            alert("<spring:message code='ezApprovalG.t1588'/>");
		        } else {
		            para["P_companyID"] = CompanyID;
		            minsconttype_cross_dialogArguments[0] = para;
		            var OpenWin = window.open("/admin/ezApprovalG/apprGMinsContType.do", "MinsContType_Cross", GetOpenWindowfeature(540, 420));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		    }
		    
		    var minscontmain_cross_dialogArguments = new Array();
		    function btnIns_onclick() {
		        var para = new Array();
		        var treeView = new TreeView();
		        treeView.LoadFromID("FromTreeView");
		        
		        var nodeIdx = treeView.GetSelectNode();
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx.NodeID);

		        if (CompanyID == "") {
		            alert("<spring:message code='ezApprovalG.t1588'/>");
		            return;
		        }
		        if (nodeIdx.NodeID != null) {
		            para[0] = "I";
		            para[1] = treeNode.GetNodeData("CN");
		            para[2] = CompanyID;
		            para[3] = sDeptID;

		            var url = "/admin/ezApprovalG/apprGMinsContMain.do?tCheck=DContIns";

		            minscontmain_cross_dialogArguments[0] = para;
		            minscontmain_cross_dialogArguments[1] = btnIns_onclick_Complete;

		            var OpenWin = window.open(url, "MinsContMain", GetOpenWindowfeature(580, 455));
		            try { OpenWin.focus(); } catch (e) { }
		        } else {
		            alert("<spring:message code='ezApprovalG.t1589'/>");
		        }
		    }
		    
	        function btnIns_onclick_Complete() {
	            getContInfo(tempDeptID);
	        }
	        
	        function btnUpdate_onclick() {
	            var para = new Array();
	            listview.LoadFromID("lvtDocForm");
	            var selRow = listview.GetSelectedRows();

	            if (CompanyID == "") {
	            	alert("<spring:message code='ezApprovalG.t1588'/>");
	                return;
	            }
	            
	            if (selRow) {
	                para[0] = "U";
	                para[1] = selRow[0].getAttribute("DATA1");
	                para[2] = selRow[0].getAttribute("DATA2");
	                para[3] = selRow[0].getAttribute("DATA4");
	                para[4] = CompanyID;
	                para[5] = sDeptID;

	                var url = "/admin/ezApprovalG/apprGMinsContMain.do?tCheck=DContUpdate";

	                minscontmain_cross_dialogArguments[0] = para;
	                minscontmain_cross_dialogArguments[1] = btnUpdate_onclick_Complete;

	                var OpenWin = window.open(url, "MinsContMain_Cross", GetOpenWindowfeature(580, 455));
	                try { OpenWin.focus(); } catch (e) { }
	            } else {
	            	alert("<spring:message code='ezApprovalG.t1590'/>");
	            }
	        }
	        
	        function btnUpdate_onclick_Complete() {
	        	getContInfo(tempDeptID);
	        }
	        
	        function delContainer(selRow) {
	            var ContID = listview.GetDataRows()[selRow].getAttribute("DATA1");
	            
	            $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezApprovalG/apprGMdelCont.do",
		        	async : false,
		        	data : {contID : ContID, comID : CompanyID},
		        	success : function(result){
		        		if (result == "TRUE") {
		        			getContInfo(sDeptID);
			            } else {
			            	alert("<spring:message code='ezApprovalG.t1587'/>");
			            }
		        	},
		        	error : function() {
		        		alert("<spring:message code='ezApprovalG.t1587'/>");
		        	}
		        });	            
	   	 	}
	        
		    function btnDel_onclick() {
		        listview.LoadFromID("lvtDocForm");
		        
		        if (listview.GetSelectedRows() == "") {
		        	alert("<spring:message code='ezBoard.t179'/>");
					return;		        	
		        }
		        
		    	if (confirm("<spring:message code='ezApprovalG.t999933'/>")) {
			        var selRow = listview.GetSelectedIndexes().split(",");
			        
			        if (selRow) {
			            delContainer(selRow);
			        }
		    	}
		    }
		    
		    function btnSpecial_onclick() {
		    	
	            var treeView = new TreeView();
	            treeView.LoadFromID("FromTreeView");
	            var nodeIdx = treeView.GetSelectNode();
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(nodeIdx.NodeID);
	
	            if (CompanyID == "") {
	                alert("<spring:message code='ezApproval.t683'/>");
	                return;
	            }
	
	            if (nodeIdx != "") {
	                var url = "manageSpecialCont.do?deptID=" + encodeURIComponent(treeNode.GetNodeData("CN")) + "&companyID=" + encodeURIComponent(treeNode.GetNodeData("EXTENSIONATTRIBUTE2")) + "&deptName=" + encodeURIComponent(treeNode.GetNodeData("VALUE"));
	                var result = GetOpenWindow(url, "ManageSpecialCont", 540, 296, "NO");
	            }
	        }
		</script>
	</head>
	<body class="mainbody">
		<xml id='FORMLIST' style="display: none">
  			<LISTVIEWDATA>
    			<HEADERS>
      				<HEADER>
        				<NAME><spring:message code='ezApprovalG.t1548'/></NAME>
        				<WIDTH>215</WIDTH>
        			</HEADER>
    			</HEADERS>
  			</LISTVIEWDATA>
		</xml>
		<h1>
			<spring:message code='ezApprovalG.t1591'/>
		    <span class="title_bar"><img src="/images/name_bar.gif"></span>
			<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp"/>
		</h1>
	    <table style="margin-top:30px">
	        <tr>
	            <td>
	                <h2 class="h2_dot" style="padding-top:0px"><spring:message code='ezApprovalG.t232'/></h2>
	            </td>
	            <td style="padding-left: 5px; padding-right: 5px">
	                <h2 class="h2_dot" style="padding-top:0px"><spring:message code='ezApprovalG.t904'/></h2>
	            </td>
	            <td>&nbsp;</td>
	        </tr>
	        <tr>
	            <td style="vertical-align: top;">
	                <div class="listview" style="BORDER-RIGHT: #ddd 1px solid; BORDER-TOP: #ddd 1px solid; OVERFLOW-Y: auto; OVERFLOW-X: auto; BORDER-LEFT: #ddd 1px solid; BORDER-BOTTOM: #ddd 1px solid; WIDTH: 300px; HEIGHT: 400px; BACKGROUND-COLOR: #ffffff">
	                    <div id="TreeView" style="padding:5px"></div>
	                </div>
	            </td>
	            <td style="padding-left: 5px; padding-right: 5px">
	                <div class="listview">
	                    <div id="lvtForm" style="BORDER: #c6c6c6 0px solid; WIDTH: 300px; HEIGHT: 400px; BACKGROUND-COLOR: #ffffff"></div>
	                </div>	
	            </td>
	            <th>
	            	<a class="imgbtn"><span onclick="return btnDocTypeReg_onclick()"><spring:message code='ezApprovalG.t1592'/></span></a><br/>
	                <a class="imgbtn"><span onclick="return btnContTypeReg_onclick()"><spring:message code='ezApprovalG.t1593'/></span></a><br/>
	                <a class="imgbtn"><span onclick="return btnIns_onclick()"><spring:message code='ezApprovalG.t268'/></span></a><br/>
	                <a class="imgbtn"><span onclick="return btnUpdate_onclick()"><spring:message code='ezApprovalG.t269'/></span></a><br/>
	                <a class="imgbtn"><span onclick="return btnDel_onclick()"><spring:message code='ezApprovalG.t266'/></span></a><br/>
<!-- 	                특수문서함 주석처리 -->
	                <c:if test="${approvalFlag == 'S' }">
		                <a class="imgbtn" style="display: none"><span onclick="return btnSpecial_onclick()"><spring:message code='ezApproval.t689'/></span></a> </th>
	                </c:if>
	            </th>
	        </tr>
	    </table>
	</body>
</html>
