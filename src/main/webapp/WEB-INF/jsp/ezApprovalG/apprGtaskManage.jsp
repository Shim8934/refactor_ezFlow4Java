<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t717'/></title>
		<style>
		  .IMG_BTN { behavior:url("/css/include/ImgBtn.htc") }
		</style>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    	<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TaskManage_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabRoleInfo_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabCategoryInfo_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezCabinet_Cross.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
			var OrderCell;
		    var xmlhttp = createXMLHttpRequest();	
		    var xmldoc = createXmlDom();		
		    var NodeList, totalPage, p_page, Init_Flag, DocList_Flag, DocTitle;
		    var DeptAdminYN,AdminYN; 
		    var PageSize, curpage, ListView, NodeList2, NodeListLen;
		    var UserID = "<c:out value='${userInfo.id}'/>";
		    var CompanyID = "<c:out value='${userInfo.companyID}'/>";
		    var DeptID = "<c:out value='${userInfo.deptID}'/>";
		    var deptName = "<c:out value='${userInfo.deptName}'/>";
		    var UserLang = "<c:out value='${userInfo.lang}'/>";
		    var taskCount = "<c:out value='${taskCount}'/>"; // 단위업무 전체 갯수
		    var pageAdminFlag = 'user'
		    var searchTitle = '';
            var searchCode = '';
            var searchFlag = '';
		    
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        PageSize = 20; // 한 페이지에서 표출하는 항목 갯수
		        curpage = 1; // 현재 페이지
		        totalPage = Math.ceil(taskCount/PageSize); // 총 페이지 수
		        makePagenationBar(null, null, 0);
		        DocList_Resizer();
		    };
		    window.onresize = function () {
		    	DocList_Resizer();
		    };
		    function DocList_Resizer() {
		    	var currentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
                document.getElementById("divList").style.height = (currentHeight - 69) + "px";
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
		            
		            /* 2021-03-24 홍승비 - 전자결재G 기록물관리에서 제목 클릭 시 원클릭 시 더블클릭 이벤트 함께 적용 */
			        var headerNameTD = $(event.target).attr("headerName");
        			if (headerNameTD != null && typeof(headerNameTD) != "undefined" && (headerNameTD == "DOCTITLE" || headerNameTD == "RECTITLE" || headerNameTD == "TITLE")) {
        				btnViewTask_onclick();
     			   }
		        }
		    }
		    function lvtDoclist_HeaderClick(pHeader) {
                if (OrderCell == pHeader) {
                    if (OrderOption == "")
                        OrderOption = "DESC";
                    else
                        OrderOption = "";
                }
                else {
                    OrderCell = pHeader;
                    OrderOption = "";
                }
                    SortList(pHeader);
            }

            function SortList(szField) {
                if (g_SortField == szField)
                {
                    g_SortType = GetToggledSotrType();
                }
                else {
                    g_SortType = "ASC";
                }
                g_SortField = szField;

                GetTaskFullList(searchTitle, searchCode, searchFlag);
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
		    
		 	// 2020-11-23 더블클릭 이벤트 추가 - 박기범
		    function btnViewTask_onclick() {
		        var tempDeptID = DeptID;
		        DeptID = "";
		        btnViewTaskInfo_onclick();
		        DeptID = tempDeptID;
		    }
		    
		</script>
	</head>
	<body class="mainbody">
		<h1>
		    <spring:message code='ezApprovalG.t717'/>
		    <span id='TitleInfo' style='color: #666; font-weight:normal;'>
		     &nbsp;
		     <span id='listcount' class='txt_color' style='font-weight:bold;'></span>
		    </span>
		</h1>
		<div id="mainmenu">
		<ul>
			<li id="istat" ><span onClick="return btnViewTaskInfo_onclick()" ><spring:message code='ezApprovalG.t527'/></span></li>
			<li id="iViewHist" ><span onClick="return btnViewTaskHistoryInfo_onclick()"><spring:message code='ezApprovalG.t947'/></span></li>
			<li id="istat2" ><span class="icon16 icon16_search" onClick="return btnFindTaskFullList_onclick()"></span></li>
		</ul>
		</div>
		<span id="MailListRayer" style="width: 100%; border: 0px solid blue; vertical-align: top; overflow: hidden; display: inline-block;">
            <div id="divList" class="div_scroll" style="width: 100%; height: 641x; overflow: AUTO; margin-bottom:10px;">
                <div ID="lvtDoclist"></div>
            </div>
            <div id="tblPageRayer"></div>
        </span>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<div id=tdDebug></div>
	</body>
</html>