<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1124'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}"  type="text/css">
		<style type="text/css">
			.mainlist tr th {
				border-top :0px;
			}
			.tree_plus {margin-top: -3px !important;}
			.tree_minus {margin-top: 0px !important;}
		</style>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/OrganTree_Cross.js')}"></SCRIPT>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabRoleInfo_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezCabinet_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabinetInfo_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getContainerInfo_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendOffer_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
		    var OrderCell = "";
		    var UserAgentState = navigator.userAgent.toLowerCase();
		    var browserIE = (!CrossYN()) ? true : false;
		</script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var InitTreeVal = "";	
		    var selectobject = "tree";
		    var arrDeptInfo = new Array();
		    var rtnVal = new Array();
		    var DeptID = "<c:out value='${userInfo.deptID}'/>";
		    var CompanyID = "<c:out value='${userInfo.companyID}'/>";
		    var CurMthd = "OrganTree";
		    var ReturnFunction;
		    var winFlag;
		    window.onload = function () {
		        try {
		            ReturnFunction = parent.selectdept_cross_dialogArguments[1];
		            winFlag = parent.selectdept_cross_dialogArguments[2];
		        } catch (e) {
		            try {
		                ReturnFunction = opener.selectdept_cross_dialogArguments[1];
		                winFlag = opener.selectdept_cross_dialogArguments[2];
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
				arrDeptInfo[2] = treeNode.GetNodeData("USEUPPERDEPTBOX");
		        document.getElementById("tdSelDept").innerHTML = ReplaceText(arrDeptInfo[1], "&", "&amp;");
		    }
		    function btSearchDept_onclick() {
		        if (textDeptName.value == "") {
		        	OpenAlertUI("<spring:message code='ezApprovalG.t1125'/>");
		        }
		        else {
		            var pSearchList = "displayname::" + textDeptName.value + ";;EXACT_extensionAttribute2::" + CompanyID;
		            var pCellList = "displayname;extensionAttribute3";
		            var pPropList = "useupperdeptbox";
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
				arrDeptInfo[2] = GetAttribute(tr, "USEUPPERDEPTBOX");
		        if(CrossYN())
		            tdSelDept.textContent = arrDeptInfo[1];
		        else
		            tdSelDept.innerText = arrDeptInfo[1];
		    }
		    function cmdCancel_onclick() {
		        rtnVal[0] = "FALSE";
		        if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
		            
		            if (winFlag) {
				        window.close();
		            }
		        } else {
		            window.returnValue = rtnVal;
			        window.close();
		        }
		    }
		    function cmdConfirm_onclick() {
		        if (typeof (arrDeptInfo[0]) == "undefined") {
	                OpenAlertUI("<spring:message code='ezApprovalG.t1126'/>");
		        }
		        else if (arrDeptInfo[0] == "") {
		        	OpenAlertUI("<spring:message code='ezApprovalG.t1126'/>");
		        }
				else if (arrDeptInfo[2] == "Y") { // 상위부서문서함 사용여부 확인
					OpenAlertUI("<spring:message code='ezApprovalG.yjh07'/>");
				}
		        else {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = arrDeptInfo[0];
		            rtnVal[2] = arrDeptInfo[1];
		            if (ReturnFunction != null) {
		                ReturnFunction(rtnVal);
		            	
		                if (winFlag) {
					        window.close();
			            }
		            } else {
		            	window.returnValue = rtnVal;
			            window.close();
		            }
		        }
		    }
		    function FindDeptRdo_onclick(strValue) {
		        switch (strValue) {
		            case "OrganTree":
		                trOrganTree.style.display = "block";
		                trFindDept.style.display = "none";
		                trFindDept2.style.display = "none";
		                break;
		
		            case "FindByName":
		                trOrganTree.style.display = "none";
		                trFindDept.style.display = "block";
		                trFindDept2.style.display = "";
		                break;
		
		            default:
		                trOrganTree.style.display = "block";
		                trFindDept.style.display = "none";
		                trFindDept2.style.display = "none";
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
		<div id="close">
            <ul>
                <li><span name="btnCancel" onclick="return cmdCancel_onclick()"></span></li>
            </ul>
        </div>
		<table class="content">
		  <tr> 
		    <td colspan="2" > 
			  <input type="radio" name="FindDept" id="FindDept" value="OrganTree" checked 
				onclick="FindDeptRdo_onclick(this.value)"><span style=" vertical-align:middle;"><spring:message code='ezApprovalG.t1128'/></span>
			  <input type="radio" name="FindDept" id="FindDept" value="FindByName"
				onclick="FindDeptRdo_onclick(this.value)"><span style=" vertical-align:middle;"><spring:message code='ezApprovalG.t1129'/></span>
			</td>
		  </tr>
		  <tr> 
			<th ><spring:message code='ezApprovalG.t1130'/></th>
		    <td id="tdSelDept">&nbsp;</td>
		  </tr>
		  <tr style="display: none;" id="trFindDept2">
		  	<th><spring:message code='ezApprovalG.t250'/></th>
		  	<td colspan="2">
		  		<input id= "textDeptName"type="text" class="text" style="Width:155px;" name="text232422222" onKeyPress="return textDeptName_onkeypress()">&nbsp;<a  class="imgbtn imgbck" style="vertical-align:middle;">
				<span id=btSearchDept style="vertical-align:middle;" onclick= "return btSearchDept_onclick()"><spring:message code='ezApprovalG.t250'/></span></a>
		  	</td>
		  </tr>
		</table>	
		<div id="trOrganTree" style="margin-top:10px" >
			  <div class="box" id="DocTreeView" style="height:178px;overflow:auto;">
			  </div>
		</div>
		<table style="display:none" id=trFindDept >
		  <tr> 
			<td>
		        <div class="listview" style="Width:328px; Height:150px; margin-top: 10px;">
			    	<div id="OrgListView"  STYLE="overflow:auto;Width:327px; Height:159px;"></div>
			    </div>
			</td>
		  </tr>
		</table>
		
		<div class="btnposition btnpositionNew">
			<a class="imgbtn" name="btnOK"><span onClick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
		</div>
	</body>
</html>
