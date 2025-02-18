<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t713' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<%-- <link rel="stylesheet" href="${util.addVer('ezApprovalG.e3', 'msg')}" type="text/css"> --%>
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<style>
			.mainlist tr th { border-top:0px }
			.tree_plus {margin-top: -3px !important;}
			.tree_minus {margin-top: 0px !important;}
		</style>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeView.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewCtrl_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getContainerInfoCB_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezCabinet_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TaskManage_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/OpenSelWin_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabRoleInfo_Cross.js')}"></script>
		
		<script type="text/javascript">
		    var OrderCell;
		    var xmlhttp = createXMLHttpRequest();
		    var xmldoc = createXmlDom();
		    var UserID, deptName;
		    var NodeList, NodeList2, NodeListLen;
		    var DeptAdminYN,AdminYN; 
		    var OrganID;
		    var szRoleInfo="<c:out value = '${userInfo.rollInfo}' />";
		    var UserID = "<c:out value = '${userInfo.id}' />";
		    var deptName = "<c:out value = '${userInfo.deptName1}' />";
		    var CompanyID = "<c:out value = '${userInfo.companyID}' />";
		    var DeptID = CompanyID;
		    var bTreeInit = false;
            var ListView
		    var UserLang = "<c:out value = '${userInfo.lang} '/>";
		    var taskCount = "<c:out value='${taskCount}'/>"; // 단위업무 전체 갯수
		    var pageAdminFlag = 'admin';
		    var curpage = 1;
		    var PageSize = 20;
		    var totalPage = Math.ceil(taskCount/PageSize);
            var searchTitle = '';
            var searchCode = '';
            var searchFlag = '';
		    
		    $(document).ready(function(){
		        document.getElementById("ListCompany").value = CompanyID;
		        
		        if (!bTreeInit) {
		            Tree_setconfig();
		            TreeViewinitialize("", CompanyID, "", "<c:out value='${serverName}'/>");
		            bTreeInit = true;
		        }
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
		    
		    function lvtDoclist_onselchanged() {
		        var DocList = new ListView();          
		        DocList.LoadFromID("DocList");
		        var tr = DocList.GetSelectedRows();
		        
		        if (tr.length > 0) { 
		            selRow = tr[0];
		        }
	
		        if (selRow) {
		            if (selRow.getAttribute("DATA6") == "1") {
		            } else {
		            }
		        }
		    }
		    
		    function btnClose_onclick() {
		        window.close();
		    }
		    
		    function btnViewTask_onclick() {
		        var tempDeptID = DeptID;
		        DeptID = "";
		        btnViewTaskInfo_onclick();
		        DeptID = tempDeptID;
		    }
		    
		    function TreeViewNodeClick(pNodeID) {
		        TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        //2016-07-26 이효진 CompnayID 가 Top로 고정되어있어서 추가
		        if (treeNode.GetNodeData("EXTENSIONATTRIBUTE2") != "") {
		        	CompanyID = treeNode.GetNodeData("EXTENSIONATTRIBUTE2");
		        }
		        
		        DeptID = treeNode.GetNodeData("CN");
		        deptName = treeNode.GetNodeData("VALUE");
		        curpage = 1;
		        makePagenationBar(null, null, 0);
		    }
		    
		    function TreeViewNodeDbClick() {
		    }
		    
		    function GetTaskList(pDeptID, deptName) {
		        InitDeptTaskList(pDeptID, deptName);
		    }
	
		    function selectCompanyID() {
		        if (CompanyID != document.getElementById("ListCompany").value) {
		            CompanyID = document.getElementById("ListCompany").value;
		            TreeViewinitialize("", CompanyID + "/other", "", "<c:out value='${serverName}'/>");
		        }
		    }
		</script>
	</head>
	<body class="mainbody">
		<h1>
			<spring:message code = 'ezApprovalG.t713' />
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
			<SELECT id="ListCompany" name="SCompID" class="companySelect" onChange="selectCompanyID()">
	        	<c:forEach var="item" items="${list}">
            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
            	</c:forEach>
	        </SELECT>
		</h1>		
		<div id="mainmenu">
  			<ul>
      			<%-- <b><spring:message code = 'ezApprovalG.t1276' /></b>
		        <SELECT id="SCompID" name="SCompID" onChange="selectCompanyID()">
		        	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
		        </SELECT><br /><br /> --%>
		   		<li id=UpdateClass style="display:none" ><span onClick="return ReceiveTaskResult()" ><spring:message code = 'ezApprovalG.t714' /></span></li>
			   	<li id=ViewTaskCode><span onClick="return btnViewTask_onclick()" ><spring:message code = 'ezApprovalG.t715' /></span></li>
			   	<li id=ViewTaskCode><span onClick="return btnViewTaskHistoryInfo_onclick()" ><spring:message code = 'ezApprovalG.t716' /></span></li>
			   	<div id="PageNum" style="margin:15px 0px 0px 258px"><span id="listcount">&nbsp;</span></div>
  			</ul>
		</div>
		
		<table>
  			<tr> 
				<td style="vertical-align:top"><div class="box" id="TreeView" style="border:1px solid #ddd; height:550px;width:250px; overflow-x:auto;overflow-y:auto"></div></td>
				<td style="padding-left:5px" >
        			<div class="listview">
            			<div id="lvtDoclist" style="OVERFLOW-Y:auto; overflow-x:auto;border:0;HEIGHT: 550px; WIDTH: 100%; min-width:1200px" onClick ="" onselchanged="lvtDoclist_onselchanged()" onrowdblclick="">
            			</div>
        			</div>
        			<div id='tblPageRayer'>
        			</div>
				</td>
  			</tr>
		</table>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<div id=tdDebug></div>
	</body>
</html>
