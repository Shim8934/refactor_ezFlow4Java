<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1124'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css"  type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/ezApprovalG/OrganTree_Cross.js"></SCRIPT>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/CabRoleInfo_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ezCabinet_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/CabinetInfo_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getContainerInfo_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/SendOffer_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
		    var OrderCell = "";
		    var UserAgentState = navigator.userAgent.toLowerCase();
		    var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
		</script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var InitTreeVal = "";	
		    var selectobject = "tree";
		    var arrDeptInfo = new Array();
		    var rtnVal = new Array();
		    var DeptID = "${userInfo.deptID}";
		    var CompanyID = "${userInfo.companyID}";
		    var CurMthd = "OrganTree";
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            ReturnFunction = parent.selectdept_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                ReturnFunction = opener.selectdept_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		
		
		        var ua = navigator.userAgent;
		        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		            KeEventControl(document.getElementById("textDeptName"));
		        }
		        rtnVal[0] = "FALSE";
		        LoadOrganTreeData(DeptID, CompanyID);
		    };
		    function TreeCtrl_onNodeClick(obj) {
		        selectobject = "tree";
		        var nodeIdx = obj;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(nodeIdx);
		
		        arrDeptInfo[0] = treeNode.GetNodeData("CN");
		        arrDeptInfo[1] = treeNode.GetNodeData("VALUE");
		        document.getElementById("tdSelDept").innerHTML = ReplaceText(arrDeptInfo[1], "&", "&amp;");
		    }
		    function btSearchDept_onclick() {
		        if (textDeptName.value == "") {
		            alert("<spring:message code='ezApprovalG.t1125'/>");
		        }
		        else {
		            var pSearchList = "displayname::" + textDeptName.value + ";;EXACT_extensionAttribute2::" + CompanyID;
		            var pCellList = "displayname;extensionAttribute3";
		            var pPropList = "";
		            var pClass = "group";
		            DisplayOrganSearchList(pSearchList, pCellList, pPropList, pClass);
		        }
		    }
		    function textDeptName_onkeypress() {
		        if (window.event.keyCode == 13) {
		            btSearchDept.click();
		        }
		    }
		    function OrganList_rowclick() {
		        var listview = new ListView();
		        listview.LoadFromID("OrganListView");
		        var selnode = listview.GetSelectedRows();
		        var tr = selnode[0];
		        arrDeptInfo[0] = GetAttribute(tr, "DATA2");
		        arrDeptInfo[1] = tr.cells[0].innerText;
		        if(CrossYN())
		            tdSelDept.textContent = ReplaceText(arrDeptInfo[1], "&", "&amp;");
		        else
		            tdSelDept.innerText = ReplaceText(arrDeptInfo[1], "&", "&amp;");
		    }
		    function cmdCancel_onclick() {
		        rtnVal[0] = "FALSE";
		        if (ReturnFunction != null)
		            ReturnFunction(rtnVal);
		        else
		            window.returnValue = rtnVal;
		        window.close();
		    }
		    function cmdConfirm_onclick() {
		        if (typeof (arrDeptInfo[0]) == "undefined") {
		            alert("<spring:message code='ezApprovalG.t1126'/>");
		        }
		        else if (arrDeptInfo[0] == "") {
		            alert("<spring:message code='ezApprovalG.t1126'/>");
		        }
		        else {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = arrDeptInfo[0];
		            rtnVal[2] = arrDeptInfo[1];
		            if (ReturnFunction != null)
		                ReturnFunction(rtnVal);
		            else
		                window.returnValue = rtnVal;
		            window.close();
		        }
		    }
		    function FindDeptRdo_onclick(strValue) {
		        switch (strValue) {
		            case "OrganTree":
		                trOrganTree.style.display = "block";
		                trFindDept.style.display = "none";
		                break;
		
		            case "FindByName":
		                trOrganTree.style.display = "none";
		                trFindDept.style.display = "block";
		                break;
		
		            default:
		                trOrganTree.style.display = "block";
		                trFindDept.style.display = "none";
		                break;
		        }
		        if (CurMthd != strValue) {
		            arrDeptInfo[0] = "";
		            arrDeptInfo[1] = "";
		
		            tdSelDept.innerText = ReplaceText(arrDeptInfo[1], "&", "&amp;");
		        }
		        CurMthd = strValue;
		    }
		</SCRIPT>
	</head>
	<body class="popup" leftmargin="0" topmargin="0">
		<xml id="OrganListHeader" style="display:none;">
		<LISTVIEWDATA>
			<HEADERS>
				<HEADER>
					<NAME><spring:message code='ezApprovalG.t687'/></NAME>
					<WIDTH>184</WIDTH>
				</HEADER>
				<HEADER>
					<NAME><spring:message code='ezApprovalG.t1127'/></NAME>
					<WIDTH>100</WIDTH>
				</HEADER>
			</HEADERS>
		</LISTVIEWDATA>
		</xml>
		<h1><spring:message code='ezApprovalG.t1124'/></h1>
		
		<table class="content">
		  <tr> 
		    <td colspan="2" > 
			  <input type="radio" name="FindDept" id="FindDept" value="OrganTree" checked
				onclick="FindDeptRdo_onclick(this.value)"><span style=" vertical-align:bottom"><spring:message code='ezApprovalG.t1128'/></span>
			  <input type="radio" name="FindDept" id="FindDept" value="FindByName"
				onclick="FindDeptRdo_onclick(this.value)"><span style=" vertical-align:bottom"><spring:message code='ezApprovalG.t1129'/></span>
			</td>
		  </tr>
		  <tr> 
			<th ><spring:message code='ezApprovalG.t1130'/></th>
		    <td id="tdSelDept">&nbsp;</td>
		  </tr>
		</table>	
		<div id="trOrganTree" style="margin-top:10px" >
			  <div class="box" id="DocTreeView" style="height:175px;overflow:auto;">
			  </div>
		</div>
		<table style="display:none" id=trFindDept >
		  <tr> 
			<th><input id= "textDeptName"type="text" class="text" style="Width:200px;margin:0;" name="text232422222" onKeyPress="return textDeptName_onkeypress()"><a  class="imgbtn"><span id=btSearchDept onclick= "return btSearchDept_onclick()"><spring:message code='ezApprovalG.t250'/></span></a></th>
		  </tr>
		  <tr> 
			<td>
		        <div class="listview" style="Width:307px; Height:159px;">
			    <div id="OrgListView"  STYLE="overflow:auto;Width:306px; Height:159px;margin:1px 1px 1px 1px;"></div></div>
			</td>
		  </tr>
		</table>
		
		<div class="btnposition">
			<a class="imgbtn" name="btnOK"><span onClick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
			<a class="imgbtn" name="btnCancel"><span onClick="return cmdCancel_onclick()" ><spring:message code='ezApprovalG.t119'/></span></a>
		</div>
	</body>
</html>