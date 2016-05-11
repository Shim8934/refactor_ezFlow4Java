<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeViewCtrl_Cross.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
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
		    
		    $(document).ready(function(){
		    	document.getElementById("SCompID").value = CompanyID;
	            InitListView();
	            Tree_setconfig();
	            TreeViewinitialize("", CompanyID, "extensionAttribute2", "<c:out value='${serverName}'/>");
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
		        getContInfo(treeNode.GetNodeData("CN"));
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
		        		document.getElementById('lvtForm').innerHTML = "";
				        listview.DataSource(xmlRtn);
				        listview.DataBind("lvtForm");
		        	}
		        });
		    }
		    
		    function selectCompanyID() {
		        if (CompanyID != document.getElementById("SCompID").value) {
		            CompanyID = document.getElementById("SCompID").value;
		            
		            TreeViewinitialize("", CompanyID, "extensionAttribute2", "<c:out value='${serverName}'/>");
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
		            var OpenWin = window.open("/admin/ezApprovalG/apprGMContType.do", "MContType_Cross", GetOpenWindowfeature(290, 390));
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
		            para[3] = DeptID;

		            var url = "/admin/ezApprovalG/apprGMinsContMain.do?tCheck=DContIns";

		            minscontmain_cross_dialogArguments[0] = para;
		            minscontmain_cross_dialogArguments[1] = btnIns_onclick_Complete;

		            var OpenWin = window.open(url, "MinsContMain_Cross", GetOpenWindowfeature(580, 455));
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
	                para[5] = DeptID

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
	            getContInfo(para[3]);
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
		<h1><spring:message code='ezApprovalG.t1591'/></h1>
	    <span>
	    	<b><spring:message code='ezApprovalG.t1276'/></b>
	    	<select id="SCompID" name="SCompID" onchange="selectCompanyID()">
	    		<c:forEach var="item" items="${list}">
            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            	</c:forEach>
            </select>	
	    </span>
	    <table>
	        <tr>
	            <td>
	                <h2><spring:message code='ezApprovalG.t232'/></h2>
	            </td>
	            <td style="padding-left: 5px; padding-right: 5px">
	                <h2><spring:message code='ezApprovalG.t904'/></h2>
	            </td>
	            <td>&nbsp;</td>
	        </tr>
	        <tr>
	            <td style="vertical-align: top;">
	                <div class="listview" style="BORDER-RIGHT: #b6b6b6 1px solid; BORDER-TOP: #b6b6b6 1px solid; OVERFLOW-Y: auto; OVERFLOW-X: auto; BORDER-LEFT: #b6b6b6 1px solid; BORDER-BOTTOM: #b6b6b6 1px solid; WIDTH: 300px; HEIGHT: 400px; BACKGROUND-COLOR: #ffffff">
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
	            </th>
	        </tr>
	    </table>
	</body>
</html>
