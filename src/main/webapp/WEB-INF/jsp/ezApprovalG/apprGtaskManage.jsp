<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t717'/></title>
		<style>
		  .IMG_BTN { behavior:url("/css/include/ImgBtn.htc") }
		</style>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
    	<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TaskManage_Cross.js')}"></script>
    	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezCabinet_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabRoleInfo_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabCategoryInfo_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var OrderCell = "";
		    var xmlhttp = createXMLHttpRequest();	
		    var xmldoc = createXmlDom();		
		    var NodeList, nowblock,totalPage,block,p_page,p_nowblock,Init_Flag,DocList_Flag,DocTitle;
		    var DeptAdminYN,AdminYN; 
		    var OrganID;
		    var PageFlag="0";
		    var g_ListFlag="1";
		    var PageSize, Block_Size, curpage, ListView, NodeList2, NodeListLen;
		    var UserID = "${userInfo.id}";
		    var CompanyID = "${userInfo.companyID}";
		    var DeptID = "${userInfo.deptID}";
		    var deptName = "${userInfo.deptName}";
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";								
		    arr_userinfo[1]  = "${userInfo.id}";              
		    arr_userinfo[2]  = "${userInfo.displayName}";         
		    arr_userinfo[3]  = "${userInfo.title}";               
		    arr_userinfo[4]  = "${userInfo.deptID}";              
		    arr_userinfo[5]  = "${userInfo.deptName}";            
		    arr_userinfo[6]  = "${userInfo.jikChek}";                         
		    arr_userinfo[8]  = "${userInfo.email}";               
		    arr_userinfo[9]  = CompanyID;
		    arr_userinfo[10] = "";
		    arr_userinfo[11]  = "${userInfo.displayName1}";		
		    arr_userinfo[12]  = "${userInfo.displayName2}";		
		    arr_userinfo[13]  = "${userInfo.title1}";				
		    arr_userinfo[14]  = "${userInfo.title2}";				
		    arr_userinfo[15]  = "${userInfo.deptName1}";			
		    arr_userinfo[16]  = "${userInfo.deptName2}";			
		    var UserLang = "${userInfo.lang}";
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        PageSize = -1; // 2018-08-25 강민수92 단위업무관리는 페이징이아닌 스크롤로 사용됨으로 페이지사이즈 -1로 바꿔줌
		        Block_Size = 10;
		        curpage = 1;
		        nowblock = 0;
		        totalPage = 0;
		        OrganID = CompanyID;
		        GetTaskFullList();
		        DocList_Resizer();
		    };
		    window.onresize = function () {
		    	DocList_Resizer();
		    };
		    function DocList_Resizer() {
		    	var CurrentHeight = document.documentElement.clientHeight;
		    	document.getElementById("divList").style.height = (CurrentHeight - 105) + "px";
		    }
		    function lvtDoclist_onselchanged() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var tr = DocList.GetSelectedRows();
		        if (tr.length > 0) {
		            selRow = tr[0];
		            if (selRow.getAttribute("DATA6") == "1")
		            {
		
		                document.getElementById("btnUpdateTempReq").style.display = "";
		            }
		            else {
		                document.getElementById("btnUpdateTempReq").style.display = "none";
		            }
		        }
		    }
		    function btnClose_onclick() {
		        window.close();
		    }
		    var g_tagSelect="";
		    function MM_swapImage(nSel, szSuffix) {
		        g_ListFlag = nSel.toString();
		
		        var curTag = szSuffix + nSel.toString();
		        if (curTag != g_tagSelect) {
		            g_tagSelect = curTag;
		            var i, sIdx, eIdx;
		            sIdx = 1;
		            eIdx = 2;
		
		            for (i = sIdx ; i <= eIdx; i++) {
		                if (g_tagSelect != (szSuffix + i.toString())) {
		                    var str = "tab" + GetTwoDigitNumber(i.toString()) + ".src" + "=" + "\"/images/ezApprovalG/tab_" + szSuffix + GetTwoDigitNumber(i.toString()) + ".gif\"";
		                    eval(str);
		                    var str = "tab" + GetTwoDigitNumber(i.toString()) + ".height" + "=23";
		                    eval(str);
		                }
		                else {
		                    var str = "tab" + GetTwoDigitNumber(i.toString()) + ".src" + "=" + "\"/images/ezApprovalG/tab_" + szSuffix + GetTwoDigitNumber(i.toString()) + "o.gif\"";
		                    eval(str);
		                    var str = "tab" + GetTwoDigitNumber(i.toString()) + ".height" + "=23";
		                    eval(str);
		                }
		            }
		        }
		    }
		    
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezApprovalG.t717'/></h1>
		<div class="page"><span id="listcount"></span><span id="PageNum"></span></div>  
		<div id="mainmenu">
		<ul>
			<li id=btnAddTempTask style="display:none"><span onClick="return btnCreateTask_onclick()" ><spring:message code='ezApprovalG.t809'/></span></li>
			<li id=btnUpdateTempReq  style="display:none" ><span onClick="return btnUpdateTempReq_onclick()" ><spring:message code='ezApprovalG.t810'/></span></li>
			<li id=btnNewTaskReq  style="display:none"><span onClick="return btnNewTaskReq_onclick()"><spring:message code='ezApprovalG.t811'/></span></li>
			<li id=btnChDeptCodeReq  style="display:none"><span  onClick="return btnChDeptCodeReq_onclick()" ><spring:message code='ezApprovalG.t812'/></span></li>
			<li id=btnChOwnerDeptReq  style="display:none"><span onClick="return btnChOwnerDeptReq_onclick()" ><spring:message code='ezApprovalG.t813'/></span></li>
			<li id=btnDisuseTaskReq style="display:none"><span onClick="return btnDisuseTaskReq_onclick()" ><spring:message code='ezApprovalG.t814'/></span></li>
			<li id=btnUpdateTaskReq style="display:none"><span onClick="return btnUpdateTaskReq_onclick()" ><spring:message code='ezApprovalG.t815'/></span></li>
			<li id=istat ><span onClick="return btnViewTaskInfo_onclick()" ><spring:message code='ezApprovalG.t527'/></span></li>
			<li id=iViewHist ><span onClick="return btnViewTaskHistoryInfo_onclick()"><spring:message code='ezApprovalG.t529'/></span></li>
			<li id=istat2 ><span class="icon16 icon16_search" onClick="return btnFindTaskFullList_onclick()"></span></li>
		</ul>
		</div>
		<div class="div_scroll"  style="width:100%;HEIGHT:100%; overflow:AUTO" id="divList">
		    <div ID="lvtDoclist"></div>
		</div>    
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<div id=tdDebug></div>
	</body>
</html>