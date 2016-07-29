<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t713' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e3'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeViewCtrl_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getContainerInfoCB_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ezCabinet_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TaskManage_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/OpenSelWin_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/CabRoleInfo_Cross.js"></script>
		
		<script type="text/javascript">
			var OrderCell = "";
		    var xmlhttp = createXMLHttpRequest();
		    var xmldoc = createXmlDom();
		    var ContainerID, condition, jobState,SelDept,DelListYN; 
		    var UserID, DocID, DeptID, pURL,FormID,DocDeptYN,deptName;
		    var NodeList, curpage, nowblock,totalPage,block,p_page,p_nowblock,NodeListLen,Init_Flag,DocList_Flag,DocTitle;
		    var DeptAdminYN,AdminYN; 
		    var PageFlag="1";
		    var g_ListFlag="1";
		    var OrganID;
		    var szRoleInfo="<c:out value = '${userInfo.rollInfo}' />";
		    var UserID = "<c:out value = '${userInfo.id}' />";
		    var DeptID = "";
		    var deptName = "<c:out value = '${userInfo.deptName1}' />";
		    var CompanyID = "<c:out value = '${userInfo.companyID}' />";
		    var bTreeInit = false;
		    var PageSize, Block_Size, curpage, ListView, NodeList2, NodeListLen;
		    
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "<c:out value = '${userInfo.id} '/>";
		    arr_userinfo[2]  = "<c:out value = '${userInfo.displayName1} '/>";
		    arr_userinfo[3]  = "<c:out value = '${userInfo.title1} '/>";
		    arr_userinfo[4]  = "<c:out value = '${userInfo.deptID} '/>";
		    arr_userinfo[5]  = "<c:out value = '${userInfo.deptName1} '/>";
		    arr_userinfo[6]  = "<c:out value = '${userInfo.jikChek} '/>";
		    arr_userinfo[8]  = "<c:out value = '${userInfo.email} '/>";
		    arr_userinfo[9]  = CompanyID;
		    arr_userinfo[11]  = "<c:out value = '${userInfo.displayName1} '/>";
		    arr_userinfo[12]  = "<c:out value = '${userInfo.displayName2} '/>";
		    arr_userinfo[13]  = "<c:out value = '${userInfo.title1} '/>";
		    arr_userinfo[14]  = "<c:out value = '${userInfo.title2} '/>";
		    arr_userinfo[15]  = "<c:out value = '${userInfo.deptName1} '/>";
		    arr_userinfo[16]  = "<c:out value = '${userInfo.deptName2} '/>";
		    var userLang = "<c:out value = '${userInfo.lang} '/>";
		    var UserLang = "<c:out value = '${userInfo.lang} '/>";
		    
		    $(document).ready(function(){
		        document.getElementById("SCompID").value = CompanyID;
		        OrganID = CompanyID;
		        PageSize = -1;
		        Block_Size = 10;
		        curpage = 1;
		        nowblock = 0;
		        totalPage = 0;
		        DeptID = OrganID;
		        
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
	
		    function InitDeptTaskList(pDeptID, pDeptName) {
		        DeptID = pDeptID;
		        g_DeptName = pDeptName;
		        deptName = pDeptName;
		        GetTaskFullList();
		    }
		    
		    function GetDeptTaskList(pDeptID) {
		        if (pDeptID == OrganID) {
		            DeptID = "";
		            DeptID = OrganID;
		            GetTaskFullList();
		        } else if (pDeptID != "top") {
		            DeptID = pDeptID;
		            GetTaskFullList();
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
		    
		    function UpdateClass_Admin() {
		        if (DeptID == "") {
		            DeptID = OrganID;
		        }
		        
		        btnUpdateClass_onclick();
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
		        
		        var deptID = treeNode.GetNodeData("CN");
		        var deptName = treeNode.GetNodeData("VALUE");
		        GetTaskList(deptID, deptName);
		    }
		    
		    function TreeViewNodeDbClick() {
		    }
		    
		    function GetTaskList(pDeptID, deptName) {
		        InitDeptTaskList(pDeptID, deptName);
		    }
	
		    function GetTaskFullList_Admin() {
		        curpage = 1;
		        nowblock = 0;
		        totalPage = 0;
	
		        var ListName;
		        
		        switch (g_ListFlag) {
		            case "1":
		                Resultxml = GetTaskFullListXml();
		                ListName = "<spring:message code = 'ezApprovalG.t1093' />";
		                break;
	
		            case "2":
		                Resultxml = GetTaskReqListXml();
		                ListName = "<spring:message code = 'ezApprovalG.lhj01' />";
		                break;
		        }

		        if (getNodeText(Resultxml) != "") {
		            if (getNodeText(SelectSingleNodeValue(Resultxml, "RESULT"))) {
		                alert("<spring:message code = 'ezApprovalG.lhj02' />");
		            } else {
		                DisplayTaskList_Admin(Resultxml);
		                listcount.innerHTML = "<b>" + deptName + "</b>의 " + ListName + " : <span class='point'>" + NodeListLen + "</span> 개";
		            }
		        }
		    }
	
		    function selectCompanyID() {
		        if (CompanyID != document.getElementById("SCompID").value) {
		            CompanyID = document.getElementById("SCompID").value;
		            TreeViewinitialize("", CompanyID, "", "<c:out value='${serverName}'/>");
		        }
		    }
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code = 'ezApprovalG.t713' /></h1>
		<div class="page" id="PageNum"><span id="listcount">&nbsp;</span></div>
		<div id="mainmenu">
  			<ul>
      			<b><spring:message code = 'ezApprovalG.t1276' /></b>
		        <SELECT id="SCompID" name="SCompID" onChange="selectCompanyID()">
		        	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
		        </SELECT><br /><br />
		   		<li id=UpdateClass style="display:none" ><span onClick="return ReceiveTaskResult()" ><spring:message code = 'ezApprovalG.t714' /></span></li>
			   	<li id=ViewTaskCode><span onClick="return btnViewTask_onclick()" ><spring:message code = 'ezApprovalG.t715' /></span></li>
			   	<li id=ViewTaskCode><span onClick="return btnViewTaskHistoryInfo_onclick()" ><spring:message code = 'ezApprovalG.t716' /></span></li>
  			</ul>
		</div>
		<table>
  			<tr> 
				<td><div class="box" id="TreeView" style="border:1px solid #B6B6B6; height:400px;width:250px; overflow-x:auto;overflow-y:auto"></div></td>
				<td style="padding-left:5px" >
        			<div class="listview">
            			<div id="lvtDoclist" style="OVERFLOW-Y:auto; overflow-x:auto;border:0;HEIGHT: 400px; WIDTH: 490px" onClick ="" onselchanged="lvtDoclist_onselchanged()" onrowdblclick="">
            			</div>
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