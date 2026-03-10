<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>${pageTitle}</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <style>
	        .IMG_BTN {
	            behavior: url("/css/include/ImgBtn.htc");
	        }
	
	        .pagetd {
	            padding-top: 6px;
	        }
	
	        .pcol {
	            padding-top: 6px;
	        }
	
	        .Right_Point01 {
	            font: bold;
	            color: #017bec;
	        }
	    </style>
	    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
   		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezCabinet_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabinetInfo_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabRoleInfo_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getContainerInfoCB_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/OpenSelWin_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AdminPage_Cross.js')}"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var OrderCell = "";
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var ContainerID, condition, jobState, SelDept, DelListYN;
	        var DocID, pURL, FormID, DocDeptYN, OrganID;
	        var NodeList, nowblock, totalPage, block, p_page, p_nowblock, Init_Flag, DocList_Flag, DocTitle;
	        var DeptAdminYN, AdminYN;
			//0편철확정, 4종료연기승인만 쓰고잇는건가
	        var g_InitFlag = "<c:out value ='${initFlag}'/>";
	        var UserID = "<c:out value ='${userInfo.id}'/>";
	        var CompanyID = "<c:out value ='${userInfo.companyID}'/>";
	        var DeptID = "<c:out value ='${deptCode}'/>";
	        var deptName = "<c:out value ='${deptName}'/>";
	        var PageSize, Block_Size, curpage, ListView, NodeList2, NodeListLen;
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "<c:out value ='${userInfo.id}'/>";
	        arr_userinfo[2] = "<c:out value ='${userInfo.displayName}'/>";
	        arr_userinfo[3] = "<c:out value ='${userInfo.title}'/>";
	        arr_userinfo[4] = "<c:out value ='${deptCode}'/>";
	        arr_userinfo[5] = "<c:out value ='${deptName}'/>";
	        arr_userinfo[6] = "<c:out value ='${userInfo.jikChek}'/>";
	        arr_userinfo[8] = "<c:out value ='${userInfo.email}'/>";
	        arr_userinfo[9] = CompanyID;
	        arr_userinfo[11] = "<c:out value ='${userInfo.displayName1}'/>";
	        arr_userinfo[12] = "<c:out value ='${userInfo.displayName2}'/>";
	        arr_userinfo[13] = "<c:out value ='${userInfo.title1}'/>";
	        arr_userinfo[14] = "<c:out value ='${userInfo.title2}'/>";
	        arr_userinfo[15] = "<c:out value ='${userInfo.deptName1}'/>";
	        arr_userinfo[16] = "<c:out value ='${userInfo.deptName2}'/>";
            var g_sFlag = ""
            var g_uFlag = "";
	        var UserLang = "<c:out value ='${userInfo.lang}'/>";
	        var isPeriodYear = true;
	        var OpenWin;
	        var approvalFlag = "<c:out value ='${approvalFlag}'/>";
	        var ext = "";
	        var useWebHWP = "<c:out value ='${useWebHWP}'/>";
            var selRowChangeFlag = false;
            var diffPaging = "";
	        
	        document.onselectstart = function () { return false; };
	        
	        window.onload = function () {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            
		        PageSize = 10;
		        Block_Size = 10;
		        curpage = 1;
		        nowblock = 0;
		        totalPage = 0;
		        DocDeptYN = IsDocDept(DeptID);
		        OrganID = CompanyID;
	
		        switch (g_InitFlag) {
		            case "0":
		            	PageSize = 15;
		                btnConfirmTargetCab_onclick();
		                break;
		
		            case "1":
		                ListTypeFlag = "2";
		                DisplayTransStatus("0");
		                btnProdReportCabList_onclick();
		
		                if (DocDeptYN)
		                    document.getElementById("trTabList").style.display = "";
		                else
		                    document.getElementById("trTabList").style.display = "none";
		
		                break;
		
		            case "2":
		                ListTypeFlag = "3";
		                DisplayTransStatus("1");
		                btnTransCabList_onclick();
		                break;
		
		            case "3":
		                ListTypeFlag = "7";
		                btnDelTargetCabList_onclick();
		                break;
		
		            case "4":
		                ListTypeFlag = "11";
                        PageSize = 20
		                GetEndYConfirmList();
		                break;
		        }
		        
		        settingResize();
		    };
		    
		    window.onresize = function() {
	        	settingResize();
	        }
		    
		    var settingResize = function() {
		    	var currentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
		        var divListHeight = document.getElementById('divList').style.height;
		        
		    	if (document.getElementById('tabs')) {
		    		document.getElementById('divList').style.height = (currentHeight - 133) + "px";
		    	} else {
		    		document.getElementById('divList').style.height = (currentHeight - 69) + "px";
		    	}
		    }
		    
		    function DisplayTransStatus(szFlag) {
		        var oXml = GetTransStatus(szFlag);
		        if (oXml.text == "") {
		            OpenAlertUI("<spring:message code='ezApprovalG.t458'/>");
		        }
		        else if (oXml.text == "FALSE") {
		            OpenAlertUI("<spring:message code='ezApprovalG.t459'/>");
		        }
		        else {
		            var DeptCode = oXml.documentElement.selectSingleNode("DEPTINFO/DEPTCODE").text;
		            var DeptName = oXml.documentElement.selectSingleNode("DEPTINFO/DEPTNAME").text;
		            var StatusCode = parseInt(oXml.documentElement.selectSingleNode("DEPTINFO/STATUSCODE").text);
		            var StatusString = oXml.documentElement.selectSingleNode("DEPTINFO/STATUSSTRING").text;
		            var ErrMsg = oXml.documentElement.selectSingleNode("DEPTINFO/ERRMSG").text;
		            var arrStatus = StatusString.split(":");
		
		            document.getElementById("tdDeptInfo").innerText = "<spring:message code='ezApprovalG.t460'/>" + DeptName + "(" + DeptCode + ")";
		
		            document.getElementById("tdListTransStatus").innerText = arrStatus[0];
		            if (typeof (tdFileTransStatus) == "object") document.getElementById("tdFileTransStatus").innerText = arrStatus[1];
		            if (typeof (tdArchiveRcvStatus) == "object") document.getElementById("tdArchiveRcvStatus").innerText = arrStatus[2];
		            document.getElementById("tdRcvComplStatus").innerText = arrStatus[3];
		            if ((StatusCode & 1 == 1 && StatusCode & 2 == 0) || (StatusCode & 4 == 4 && StatusCode & 16 == 0) || (StatusCode & 32 == 32 && StatusCode & 64 == 0))	//오류발생일 때
		            {
		                document.getElementById("tdErrMsg").innerText = ErrMsg;
		                document.getElementById("divErrMsg").style.display = "";
		            }
		            else {
		                document.getElementById("divErrMsg").style.display = "none";
		            }
		        }
		    }
		    function SwapMenuIcon(StatusCode) {
		
		        if ((StatusCode & 2) == 0) {
		            if (typeof (imgSndProdList) != "undefined" && typeof (imgSndProdList) != "unknown")
		                SwapIcon(imgSndProdList, "true");
		
		            if (typeof (imgSndTransList) != "undefined" && typeof (imgSndTransList) != "unknown")
		                SwapIcon(imgSndTransList, "true");
		
		            if (typeof (imgAddDelayList) != "undefined" && typeof (imgAddDelayList) != "unknown")
		                SwapIcon(imgAddDelayList, "true");
		
		            if (typeof (imgSndTransFile) != "undefined" && typeof (imgSndTransFile) != "unknown")
		                SwapIcon(imgSndTransFile, "false");
		
		            if (typeof (imgTransComplete) != "undefined" && typeof (imgTransComplete) != "unknown")
		                SwapIcon(imgTransComplete, "false");
		        }
		        else if ((StatusCode & 16) == 0) {
		            if (typeof (imgSndProdList) != "undefined" && typeof (imgSndProdList) != "unknown")
		                SwapIcon(imgSndProdList, "false");
		
		            if (typeof (imgSndTransList) != "undefined" && typeof (imgSndTransList) != "unknown")
		                SwapIcon(imgSndTransList, "false");
		
		            if (typeof (imgAddDelayList) != "undefined" && typeof (imgAddDelayList) != "unknown")
		                SwapIcon(imgAddDelayList, "false");
		
		            if (typeof (imgSndTransFile) != "undefined" && typeof (imgSndTransFile) != "unknown")
		                SwapIcon(imgSndTransFile, "true");
		
		            if (typeof (imgTransComplete) != "undefined" && typeof (imgTransComplete) != "unknown")
		                SwapIcon(imgTransComplete, "false");
		        }
		        else if ((StatusCode & 64) == 0) {
		            if (typeof (imgSndProdList) != "undefined" && typeof (imgSndProdList) != "unknown")
		                SwapIcon(imgSndProdList, "false");
		
		            if (typeof (imgSndTransList) != "undefined" && typeof (imgSndTransList) != "unknown")
		                SwapIcon(imgSndTransList, "false");
		
		            if (typeof (imgAddDelayList) != "undefined" && typeof (imgAddDelayList) != "unknown")
		                SwapIcon(imgAddDelayList, "false");
		
		            if (typeof (imgSndTransFile) != "undefined" && typeof (imgSndTransFile) != "unknown")
		                SwapIcon(imgSndTransFile, "false");
		
		            if (typeof (imgTransComplete) != "undefined" && typeof (imgTransComplete) != "unknown")
		                SwapIcon(imgTransComplete, "true");
		        }
		        else if ((StatusCode & 256) == 0) {
		            if (typeof (imgSndProdList) != "undefined" && typeof (imgSndProdList) != "unknown")
		                SwapIcon(imgSndProdList, "false");
		
		            if (typeof (imgSndTransList) != "undefined" && typeof (imgSndTransList) != "unknown")
		                SwapIcon(imgSndTransList, "false");
		
		            if (typeof (imgAddDelayList) != "undefined" && typeof (imgAddDelayList) != "unknown")
		                SwapIcon(imgAddDelayList, "false");
		
		            if (typeof (imgSndTransFile) != "undefined" && typeof (imgSndTransFile) != "unknown")
		                SwapIcon(imgSndTransFile, "false");
		
		            if (typeof (imgTransComplete) != "undefined" && typeof (imgTransComplete) != "unknown")
		                SwapIcon(imgTransComplete, "false");
		        }
		    }
		    function lvtDoclist_onSel_DBclick() {
		        if (DocList_Flag == "CABINET") {
		            btnViewCabInfo_onclick();
		        }
		        else {
		            ViewDoc_onclick();
		        }
		    }
		    function btnClose_onclick() {
		        window.close();
		    }
		    function GetEndYConfirmList() {
		        ListTypeFlag = "11";
		        DocList_Flag = "CABINET";
		        InitSubMenu();
		        GetCaninetList();
		    }
		    var tempFlag;
		    function btnConfirmEndY_onclick(Flag) {
		        var listView = new ListView();
		        listView.LoadFromID("DocList");
		        var selRow = listView.GetSelectedRows();
		        var len = selRow.length;
		        var i;
		        tempFlag = Flag;
		        if (Flag == "1") {
		            if (listView.GetDataRows()[0].id == "DocList_TR_noItems") {
		                OpenAlertUI("<spring:message code='ezApprovalG.t471'/>");
		                return;
		            }
		            var pInformationContent = "<spring:message code='ezApprovalG.t472'/>";
		            OpenInformationUI(pInformationContent, btnConfirmEndY_onclick_Complete);
		        }
		        else if (Flag == "2") {
		            if (len > 0) {
		                var pInformationContent = "<spring:message code='ezApprovalG.t475'/>";
		                OpenInformationUI(pInformationContent, btnConfirmEndY_onclick_Complete2);
		            }
		            else {
		                OpenAlertUI("<spring:message code='ezApprovalG.t478'/>");
		            }
		        }
		        else {
		            if (len > 0) {
		                var pInformationContent = "<spring:message code='ezApprovalG.t479'/>";
		                OpenInformationUI(pInformationContent, btnConfirmEndY_onclick_Complete3);
		            }
		            else {
		                OpenAlertUI("<spring:message code='ezApprovalG.t478'/>");
		            }
		        }
		    }
		    function btnConfirmEndY_onclick_Complete(bCon) {
		        if (bCon) {
		            var listView = new ListView();
		            listView.LoadFromID("DocList");
		            var selRow = listView.GetSelectedRows();
		            var len = selRow.length;
		            if (DelayCabEndY("", tempFlag) == "TRUE") {
		                OpenAlertUI("<spring:message code='ezApprovalG.t473'/>");
		                GetEndYConfirmList();
		            }
		            else {
		                OpenAlertUI("<spring:message code='ezApprovalG.t474'/>");
		            }
		
		        }
		    }
		    function btnConfirmEndY_onclick_Complete2(bCon) {
		        if (bCon) {
		            var listView = new ListView();
		            listView.LoadFromID("DocList");
		            var selRow = listView.GetSelectedRows();
		            var len = selRow.length;
		            var CabClassList = "";
		            for (i = 0; i < len; i++) {
		                if (CabClassList != "")
		                    CabClassList += ",";
		
		                CabClassList += selRow[i].getAttribute("DATA2");
		            }
		
		            if (DelayCabEndY(CabClassList, tempFlag) == "TRUE") {
		                OpenAlertUI("<spring:message code='ezApprovalG.t476'/>");
		                GetEndYConfirmList();
		            }
		            else {
		                OpenAlertUI("<spring:message code='ezApprovalG.t477'/>");
		            }
		        }
		    }
		    function btnConfirmEndY_onclick_Complete3(bCon) {
		        if (bCon) {
		            var listView = new ListView();
		            listView.LoadFromID("DocList");
		            var selRow = listView.GetSelectedRows();
		            var len = selRow.length;
		            var CabClassList = "";
		            for (i = 0; i < len; i++) {
		                if (CabClassList != "")
		                    CabClassList += ",";
		
		                CabClassList += selRow[i].getAttribute("DATA2");
		            }
		
		            if (DelayCabEndY(CabClassList, tempFlag) == "TRUE") {
		                OpenAlertUI("<spring:message code='ezApprovalG.t473'/>");
		                GetEndYConfirmList();
		            }
		            else {
		                OpenAlertUI("<spring:message code='ezApprovalG.t474'/>");
		            }
		        }
		    }
			function DelayCabEndY(CabClassList, Flag) {
				var result = "";
				
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/delayCabEndY.do",
					data : {
						companyID : CompanyID,
						deptCode  : DeptID,
						flag 	  : Flag,
						cabClassList  : CabClassList
					},
					success: function(xml){
						result = loadXMLString(xml);
					}, error : function() {
						return "FALSE";
					}
				});
				
			    var dataNodes = GetChildNodes(result);
			    
			    return getNodeText(dataNodes[0]);
			}
			function btnConfirmTargetCab_onclick() {
			    if (nSelTab == "2") {
			        btnNotArrangedCab_onclick();
			    }
			    else {
			        ListTypeFlag = "1";
			        DocList_Flag = "CABINET";
			        curpage = 1;
			        nowblock = 0;
			        totalPage = 0;
			        InitSubMenu();
			        GetCaninetList();
			    }
			}
			function btnNotArrangedCab_onclick() {
			    ListTypeFlag = "12";
			    DocList_Flag = "CABINET";
			    curpage = 1;
			    nowblock = 0;
			    totalPage = 0;
			    InitSubMenu();
			    GetCaninetList();
			}
			function GetConfirmList() {
			    if (ListTypeFlag == "12")
			        btnNotArrangedCab_onclick();
			    else
			        btnConfirmTargetCab_onclick();
			}
			function btnConfirmList_onclick() {
			    var szDocCnt = getNodeText(NodeList2);
			    if (parseInt(szDocCnt) <= 0) {
			        OpenAlertUI("<spring:message code='ezApprovalG.t480'/>");
			        return;
			    }
			    OpenWin = OpenInformationUI("<spring:message code='ezApprovalG.t481'/>", btnConfirmList_onclick_Complete);
			    
			}
			function btnConfirmList_onclick_Complete(bCon) {
			    if (bCon) {
			        var DocCount = GetUncabinetedDocCount();
			        if (parseInt(DocCount) > 0) {
			            var Msg = "<spring:message code='ezApprovalG.t482'/>" + "<br>";
			            Msg += "<spring:message code='ezApprovalG.t483'/>" + DocCount + "<spring:message code='ezApprovalG.t484'/>" + "<br>";
			            Msg += "<spring:message code='ezApprovalG.t485'/>";
			
			            OpenAlertUI(Msg);
			        }
			        else {
			            chkIfNotArrangedCabExist();
			        }
			    }
			}
			function GetUncabinetedDocCount() { 
				var result = "";
				
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/getUncabinetedDocCount.do",
					data : {
						companyID : CompanyID,
						deptCode  : DeptID,
					},
					success: function(xml){
						result = loadXMLString(xml);
					}        			
				});
				
			    var dataNodes = GetChildNodes(result);
			    
			    return getNodeText(dataNodes[0]);
			}
			function chkIfNotArrangedCabExist() {
				var result = "";
				
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/chkIfNotArrangedCabExist.do",
					data : {
						companyID : CompanyID,
						deptCode  : DeptID,
					},
					success: function(xml){
						result = loadXMLString(xml);
					}        			
				});
				
			    var dataNodes = GetChildNodes(result);
			    var rtnTxt = getNodeText(dataNodes[0]);
			    if (rtnTxt == "FALSE") {
			        OpenAlertUI("<spring:message code='ezApprovalG.t486'/>");
			            return false;
			    } else {
		            if (parseInt(rtnTxt) > 0) {
		                var pInformationContent = "<spring:message code='ezApprovalG.t487'/>" +
		                                          "(<spring:message code='ezApprovalG.t488'/>" + "<spring:message code='ezApprovalG.t489'/>" + "<spring:message code='ezApprovalG.t490'/>";
		                bCon = OpenInformationUI(pInformationContent, chkIfNotArrangedCabExist_Complete);
		
		            }
		            else {
		                chkIfNotArrangedCabExist_Complete(true);
		            }
		        }
			}
		    function chkIfNotArrangedCabExist_Complete(bCon) {
		        if (bCon) {
		            ConfirmClassfy(DeptID);
		            if (DocList_Flag == "CABINET") {
		                GetCaninetList();
		            }
		            else if (DocList_Flag == "RECORD") {
		                GetRecordList();
		            }
		        }
		    }
		    function ConfirmClassfy(pDeptCode) {
				var result = "";
				
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/confirmClassfy.do",
					data : {
						companyID : CompanyID,
						deptCode  : pDeptCode,
					},
					success: function(xml){
						result = loadXMLString(xml);
					}, error: function() {
						  OpenAlertUI("<spring:message code='ezApprovalG.t491'/>");
					}
				});
				
			}
			function btnProdReportRecList_onclick() {
			    DocList_Flag = "RECORD";
			    curpage = 1;
			    nowblock = 0;
			    totalPage = 0;
			    InitSubMenu();
			    GetRecordList();
			}
			function btnProdReportCabList_onclick() {
			    DocList_Flag = "CABINET";
			    curpage = 1;
			    nowblock = 0;
			    totalPage = 0;
			    InitSubMenu();
			    GetCaninetList();
			}
			function btnStaTargetDeli_onclick() {
			}
	function btnSndProdList_onclick() {
	    var ConStr = "<spring:message code='ezApprovalG.t492'/>"+ "<br>" +
	                 " * " + "<spring:message code='ezApprovalG.t912'/>" + "\n" +
	                 " * " + "<spring:message code='ezApprovalG.t552'/>" + "\n" +
	                 " * " + "<spring:message code='ezApprovalG.t96'/>" + "\n" +
	                 " * " + "<spring:message code='ezApprovalG.t92'/>" + "\n" +
	                 " * " + "<spring:message code='ezApprovalG.t93'/>" + "\n" +
	                 " * " + "<spring:message code='ezApprovalG.t498'/>" +
	                 " * " + "<spring:message code='ezApprovalG.t499'/>" ;
	    bCon = OpenConfirmUI(ConStr);
	    if (bCon) {
	        if (TransferProdList(DeptID, "0")) {
	            OpenAlertUI("<spring:message code='ezApprovalG.t500'/>");
	            }
	            else {
	                OpenAlertUI("<spring:message code='ezApprovalG.t501'/>");
	            }
	
	            btnProdReportCabList_onclick();
	            DisplayTransStatus("0");
	        }
	    }
	    function btnMakeProdFile_onclick() {
	        var ConStr = "다음 목록을 전자파일로 생성하시겠습니까?<br>" +
	                     " * 기록물철등록부\n" +
	                     " * 기록물등록대장\n" +
	                     " * 배부대장\n" +
	                     " * 기록물철등록부 변경이력\n" +
	                     " * 기록물등록대장 변경이력\n" +
	                     " * 첨부파일정보\n" +
	                     " * 특수목록정보";
	        bCon = OpenConfirmUI(ConStr);
	        if (bCon) {
	            if (TransferProdList(DeptID, "1")) {
	                OpenAlertUI("<spring:message code='ezApprovalG.t503'/>");
	            }
	            else {
	                OpenAlertUI("<spring:message code='ezApprovalG.t504'/>");
	            }
	        }
	    }
	    function TransferProdList(pDeptCode, pFlag) {
	        var XmlHttp = createXMLHttpRequest();
	        var xmlpara = createXmlDom();
	
	        var objNode;
	        createNodeInsert(xmlpara, objNode, "PARAMETERS");
	        createNodeAndInsertText(xmlpara, objNode, "DEPTCODE", pDeptCode);
	        createNodeAndInsertText(xmlpara, objNode, "PRODFLAG", pFlag);
	        createNodeAndInsertText(xmlpara, objNode, "ORGANID", OrganID);
	        if (DocDeptYN)
	            createNodeAndInsertText(xmlpara, objNode, "DOCDEPTFLAG", "1");
	        else
	            createNodeAndInsertText(xmlpara, objNode, "DOCDEPTFLAG", "0");
	        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
	        XmlHttp.open("POST", "aspx/API_TransProdList.aspx", false);
	        XmlHttp.send(xmlpara);
	        var rtnXml = XmlHttp.responseXML;
	        try {
	            var errcode = getNodeText(SelectSingleNodeNew(rtnXml, "ERRCODE"));
	            if (errcode == "00000") {
	                if (pFlag == "1") {
	                    return GetProdListFile(rtnXml);
	                }
	                else {
	                    return true;
	                }
	            }
	            else {
	                return false;
	            }
	        } catch (e) {
	            alert("<spring:message code='ezApprovalG.t505'/>");
	            return false;
	        }
	    }
	
	    function GetProdListFile(InfoXml) {
	        if (!CrossYN()) {
	            var objSave = new ActiveXObject("EzUtil.MiscFunc");
	            objSave.CreateFolder("c:\\ProdReport");
	            var nlFileList = SelectSingleNodeNew(InfoXml, "FILELIST/FILE");
	            var i;
	
	            for (i = 1; i < nlFileList.length; i++) {
	                var Href = SelectSingleNodeValue(nlFileList[i], "HREF");
	                var FileName = GetFileName(Href);
	                var LocalPath = "c:\\ProdReport" + "\\" + FileName;
	                var FileUrl = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(Href);
	
	                bResult = objSave.DownloadToFile(FileUrl, LocalPath);
	                if (!bResult) {
	                    var szMsg = "<spring:message code='ezApprovalG.t506'/>" + "<br>" +
	                                "<spring:message code='ezApprovalG.t507'/>" + FileName;
	                    OpenAlertUI_ezCab(szMsg);
	                }
	            }
	            return true;
	        }
	    }
	    function btnProdStatistics_onclick() {
	        var para = new Array();
	        para[0] = DeptID;
	        para[1] = deptName;
	        para[2] = CompanyID;
	        var url = "../PrintForm/PrintProdReport.aspx";
	        var feature = "dialogWidth:850px;dialogHeight:550px;scroll:no;resizable:yes; status:no; help:no";
	        if (url != "")
	            window.showModalDialog(url, para, feature);
	    }
	    function btnTransCabList_onclick() {
	        DocList_Flag = "CABINET";
	        curpage = 1;
	        nowblock = 0;
	        totalPage = 0;
	        InitSubMenu();
	        GetCaninetList();
	    }
	    function btnTransRecList_onclick() {
	        DocList_Flag = "RECORD";
	        curpage = 1;
	        nowblock = 0;
	        totalPage = 0;
	        InitSubMenu();
	        GetRecordList();
	    }
	    function btnTranserFile_onclick() {
	        ListTypeFlag = "4";
	        DocList_Flag = "CABINET";
	        InitSubMenu();
	        GetCaninetList();
	    }
	    function btnDelayList_onclick() {
	        ListTypeFlag = "6";
	        DocList_Flag = "CABINET";
	
	        InitSubMenu();
	        GetCaninetList();
	    }
	    function btnTransfferdList_onclick() {
	        ListTypeFlag = "5";
	        DocList_Flag = "CABINET";
	
	        InitSubMenu();
	        GetCaninetList();
	    }
	    function btnTransTargetCabList_onclick() {
	        DocList_Flag = "CABINET";
	        InitSubMenu();
	        GetCaninetList();
	    }
	    function btnTransTargetRecList_onclick() {
	        DocList_Flag = "RECORD";
	        InitSubMenu();
	    }
	    function imgSndTransList_onclick() {
	        if (TransferCatalog(DeptID)) {
	            OpenAlertUI("<spring:message code='ezApprovalG.t508'/>");
	            btnTransTargetCabList_onclick();
	        }
	        else {
	            OpenAlertUI("<spring:message code='ezApprovalG.t509'/>");
	            btnTransTargetCabList_onclick();
	        }
	        DisplayTransStatus("1");
	    }
	    function imgSndTransFile_onclick() {
	        var rtn = openSelFileTransCab();
	        btnTransTargetCabList_onclick();
	        DisplayTransStatus("1");
	    }
	    function TransferCatalog(pDeptCode) {
	        var XmlHttp = createXMLHttpRequest();
	        var xmlpara = createXmlDom();
	        var objNode;
	        createNodeInsert(xmlpara, objNode, "PARAMETERS");
	        createNodeAndInsertText(xmlpara, objNode, "DEPTCODE", pDeptCode);
	        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
	        XmlHttp.open("POST", "aspx/API_TransferCatalog.aspx", false);
	        XmlHttp.send(xmlpara);
	        var rtnXml = XmlHttp.responseXML;
	        try {
	            var errcode = getNodeText(SelectSingleNodeNew(rtnXml, "ERRCODE"));
	            if (errcode == "00000") {
	                return true;
	            }
	            else {
	                return false;
	            }
	        } catch (e) {
	            alert("<spring:message code='ezApprovalG.t505'/>");
	            return false;
	        }
	    }
	    function TransComplete_OnClick() {
	        var bCon = OpenConfirmUI("<spring:message code='ezApprovalG.t510'/>");
	        if (bCon) {
	            if (CompleteTransfer(DeptID))
	                OpenAlertUI("<spring:message code='ezApprovalG.t511'/>");
	            else
	                OpenAlertUI("<spring:message code='ezApprovalG.t512'/>");
	            btnTransTargetCabList_onclick();
	            DisplayTransStatus("1");
	        }
	    }
	    function CompleteTransfer(pDeptCode) {
	        var XmlHttp = createXMLHttpRequest();
	        var xmlpara = createXmlDom();
	        var objNode;
	        createNodeInsert(xmlpara, objNode, "PARAMETERS");
	        createNodeAndInsertText(xmlpara, objNode, "DEPTCODE", pDeptCode);
	        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
	        XmlHttp.open("POST", "aspx/API_CompleteTransfer.aspx", false);
	        XmlHttp.send(xmlpara);
	        var rtnXml = XmlHttp.responseXML;
	        try {
	            var errcode = getNodeText(SelectSingleNodeNew(rtnXml, "ERRCODE"));
	            if (errcode == "00000") {
	                return true;
	            }
	            else {
	                return false;
	            }
	        } catch (e) {
	            alert("<spring:message code='ezApprovalG.t505'/>");
	            return false;
	        }
	    }
	    function btnAddDelayList_onclick() {
	        var DocList = new ListView();
	        DocList.LoadFromID("lvtDoclist");
	        var selnode = DocList.GetSelectedRows();
	        if (selnode > 0) {
	            var para = new Array();
	            para[0] = selnode[0].getAttribute("DATA2");
	            para[1] = CompanyID;
	            var url = "AddTransDelayList.aspx";
	            var feature = "dialogWidth:360px;dialogHeight:270px;scroll:no;resizable:yes;status:no; help:no ";
	            if (url != "")
	                var rtn = window.showModalDialog(url, para, feature);
	            if (rtn[0] == "TRUE") {
	                GetCaninetList();
	            }
	        }
	        else {
	            OpenAlertUI("<spring:message code='ezApprovalG.t513'/>");
	        }
	    }
	    function btnDelTargetCabList_onclick() {
	        DocList_Flag = "CABINET";
	        curpage = 1;
	        nowblock = 0;
	        totalPage = 0;
	        InitSubMenu();
	        GetCaninetList();
	    }
	    function btnDelTargetRecList_onclick() {
	        DocList_Flag = "RECORD";
	        curpage = 1;
	        nowblock = 0;
	        totalPage = 0;
	        InitSubMenu();
	        GetRecordList();
	    }
	    function btnEzCabSearch_onclick() {
	    }
	    function btnDisuseItem_onclick() {
	        var DocList = new ListView();
	        DocList.LoadFromID("lvtDoclist");
	        var selnode = DocList.GetSelectedRows();
	        if (selnode.length > 0) {
	            var bCon = OpenConfirmUI("<spring:message code='ezApprovalG.t514'/>");
	            if (bCon) {
	                if (DocList_Flag == "CABINET") {
	                    if (DisuseCabinetByID()) {
	                        OpenAlertUI("<spring:message code='ezApprovalG.t515'/>");
	                        btnDelTargetCabList_onclick();
	                    }
	                    else {
	                        OpenAlertUI("<spring:message code='ezApprovalG.t516'/>");
	                    }
	                }
	                else if (DocList_Flag == "RECORD") {
	                    if (DisuseRecordByID()) {
	                        OpenAlertUI("<spring:message code='ezApprovalG.t517'/>");
	                        btnDelTargetRecList_onclick();
	                    }
	                    else {
	                        OpenAlertUI("<spring:message code='ezApprovalG.t518'/>");
	                    }
	                }
	        }
	    }
	    else {
	        OpenAlertUI("<spring:message code='ezApprovalG.t519'/>");
	        }
	    }
	    function GetSelCabInfoXml() {
	        var objXml = createXmlDom();
	        var objNode;
	        createNodeInsert(xmlpara, objNode, "CABINETINFO");
	        var DocList = new ListView();
	        DocList.LoadFromID("lvtDoclist");
	        var selRows = DocList.GetSelectedRows();
	        iLen = selRows.length;
	        var i;
	        if (iLen > 0) {
	            for (i = 0; i < iLen; i++) {
	                createNodeAndInsertText(xmlpara, objNode, "ID", selRows[i].getAttribute("DATA1"));
	            }
	        }
	        return objXml;
	    }
	    function GetSelRecInfoXml() {
	        var objXml = createXmlDom();
	        var objNode, objCab;
	        createNodeInsert(xmlpara, objNode, "RECINFO");
	        var DocList = new ListView();
	        DocList.LoadFromID("lvtDoclist");
	        var selRows = DocList.GetSelectedRows();
	        iLen = selRows.length;
	        var i;
	        if (iLen > 0) {
	            for (i = 0; i < iLen; i++) {
	                createNodeAndAppandNode(xmlpara, objNode, objCab, "RECORD");
	                createNodeAndInsertText(xmlpara, objCab, "ID", selRows[i].getAttribute("DATA6"));
	                createNodeAndInsertText(xmlpara, objCab, "SEPATTNO", selRows[i].getAttribute("DATA8"));
	            }
	        }
	        return objXml;
	    }
	    function DisuseCabinetByID() {
	        var xmlhttp = createXMLHttpRequest();
	        var xmlpara = createXmlDom();
	        var objNode;
	        createNodeInsert(xmlpara, objNode, "PARAMETERS");
	        var objIDXml = GetSelCabInfoXml();
	        if (CrossYN()) {
	            var nodeToImport = xmlpara.importNode(objIDXml, true);
	            xmlLIST.appendChild(nodeToImport);
	
	            objNode = loadXMLString(GetSerializeXml(xmlLIST));
	        }
	        else {
	            objNode.appendChild(listNode);
	        }
	        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
	        xmlhttp.open("POST", "aspx/API_DisuseCabinetByID.aspx", false);
	        xmlhttp.send(xmlpara);
	        var dataNodes = GetChildNodes(xmlhttp.responseXML);
	        if (getNodeText(dataNodes[0]) != "TRUE") {
	            return false;
	        }
	        else {
	            return true;
	        }
	    }
	    function DisuseRecordByID() {
	        var xmlhttp = createXMLHttpRequest();
	        var xmlpara = createXmlDom();
	        var objNode;
	        createNodeInsert(xmlpara, objNode, "PARAMETERS");
	        createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
	        var objIDXml = GetSelRecInfoXml();
	        if (CrossYN()) {
	            var nodeToImport = xmlpara.importNode(objIDXml, true);
	            xmlLIST.appendChild(nodeToImport);
	
	            objNode = loadXMLString(GetSerializeXml(xmlLIST));
	        }
	        else {
	            objNode.appendChild(listNode);
	        }
	        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
	        xmlhttp.open("POST", "aspx/API_DisuseRecordByID.aspx", false);
	        xmlhttp.send(xmlpara);
	        var dataNodes = GetChildNodes(xmlhttp.responseXML);
	        if (getNodeText(dataNodes[0]) != "TRUE") {
	            return false;
	        }
	        else {
	            return true;
	        }
	    }
	    function ViewRecListInCab() {
	        var DocList = new ListView();
	        DocList.LoadFromID("DocList");
	        var selRow = DocList.GetSelectedRows();
	        if (selRow.length > 0) {
	            curpage = 1;
	            nowblock = 0;
	            totalPage = 0;
	            DocList_Flag = "RECORD";
	            ListTypeFlag = "0";
	            InitSubMenu();
	            g_SelCabXml = "<CABINETINFO><CABINET><CABINETID><![CDATA[" + selRow[0].getAttribute("DATA1") + "]]></CABINETID></CABINET></CABINETINFO>";
	            GetRecordList();
	        }
	        else {
	            OpenAlertUI("<spring:message code='ezApprovalG.t513'/>");
	    }
	}
	function btnViewInfo_onclick() {
	    if (DocList_Flag == "CABINET")
	        btnViewCabInfo_onclick();
	    else if (DocList_Flag == "RECORD")
	        btnViewRecInfo_onclick();
	}
	function btnViewHistory_onclick() {
	    if (DocList_Flag == "CABINET")
	        btnViewCabHistory_onclick();
	    else if (DocList_Flag == "RECORD")
	        btnViewRecHistory_onclick();
	}
	function InitSubMenu() {
	    switch (g_InitFlag) {
	        case "0":
	
	            if (DocList_Flag == "RECORD") {
	                document.getElementById("tdViewContent").style.display = "";
	                document.getElementById("tdViewCabList").style.display = "";
	
	                document.getElementById("tdViewRecList").style.display = "none";
	                document.getElementById("tdConfirmList").style.display = "none";
	            }
	
	            if (DocList_Flag == "CABINET") {
	
	                document.getElementById("tdViewContent").style.display = "none";
	                document.getElementById("tdViewCabList").style.display = "none";
	
	                document.getElementById("tdViewRecList").style.display = "";
	
	                if (ListTypeFlag == "1")
	                    document.getElementById("tdConfirmList").style.display = "";
	                else
	                    document.getElementById("tdConfirmList").style.display = "none";
	            }
	
	            break;
	
	        case "1":
	            if (DocList_Flag == "CABINET") {
	                document.getElementById("tdViewRejectReason").style.display = "";
	                document.getElementById("tdSearch").style.display = "";
	            }
	            else {
	                document.getElementById("tdViewRejectReason").style.display = "none";
	                document.getElementById("tdSearch").style.display = "none";
	            }
	
	
	            if (DocList_Flag == "CABHIST" || DocList_Flag == "RECHIST" || DocList_Flag == "SCLIST" || DocList_Flag == "ATTACH" || DocList_Flag == "DISTLIST") {
	                document.getElementById("tdViewInfo").style.display = "none";
	            }
	            else {
	                document.getElementById("tdViewInfo").style.display = "";
	            }
	
	            break;
	
	        case "2":
	
	            if (DocList_Flag == "CABINET") {
	                document.getElementById("tdViewRejectReason").style.display = "";
	                document.getElementById("tdAddDelayList").style.display = "";
	                document.getElementById("tdDelayList").style.display = "";
	                document.getElementById("tdSearch").style.display = "";
	            }
	            else {
	                document.getElementById("tdViewRejectReason").style.display = "none";
	                document.getElementById("tdAddDelayList").style.display = "none";
	                document.getElementById("tdDelayList").style.display = "none";
	                document.getElementById("tdSearch").style.display = "none";
	            }
	
	
	            if (DocList_Flag == "CABHIST" || DocList_Flag == "RECHIST" || DocList_Flag == "SCLIST" || DocList_Flag == "ATTACH" || DocList_Flag == "DISTLIST") {
	                document.getElementById("tdViewInfo").style.display = "none";
	            }
	            else {
	                document.getElementById("tdViewInfo").style.display = "";
	            }
	
	            break;
	
	        case "3":
	
	            if (DocList_Flag == "RECORD")
	                document.getElementById("tdViewContent").style.display = "";
	            else
	                document.getElementById("tdViewContent").style.display = "none";
	
	            break;
	
	        case "4":
	
	            if (DocList_Flag == "RECORD") {
	
	                document.getElementById("tdViewContent").style.display = "";
	                document.getElementById("tdViewCabList").style.display = "";
	
	
	                document.getElementById("tdViewRecList").style.display = "none";
	                document.getElementById("tdConfirmEndY").style.display = "none";
	                document.getElementById("tdConfirmEndYAll").style.display = "none";
	                document.getElementById("tdCancelDelayEndY").style.display = "none";
	
	            }
	
	            if (DocList_Flag == "CABINET") {
	                document.getElementById("tdViewContent").style.display = "none";
	                document.getElementById("tdViewCabList").style.display = "none";
	
	                document.getElementById("tdViewRecList").style.display = "";
	                document.getElementById("tdConfirmEndY").style.display = "";
	                document.getElementById("tdConfirmEndYAll").style.display = "";
	                document.getElementById("tdCancelDelayEndY").style.display = "";
	            }
	            break;
	    }
	}
	var g_tagSelect = "";
	var nSelTab = "";
	function MM_swapImage(nSel, szSuffix, obj) {
		methodForTabAction(obj);
	    nSelTab = nSel;
	    var curTag = szSuffix + nSel.toString();
	    if (curTag != g_tagSelect) {
	        g_tagSelect = curTag;
	        var i, sIdx, eIdx;
	        if (szSuffix == "d") {
	            sIdx = 7;
	            eIdx = 17;
	        }
	        else {
	            sIdx = 1;
	            eIdx = 2;
	        }
	        var str;
	        var imgObj;
	
	        for (i = sIdx ; i <= eIdx; i++) {
	
	            imgObj = document.all("tab" + GetTwoDigitNumber(i.toString()));
	            if (imgObj) {
	                if (g_tagSelect != (szSuffix + i.toString())) {
	                    imgObj.src = "/images/ezApprovalG/tab_" + szSuffix + GetTwoDigitNumber(i.toString()) + ".gif";
	                    imgObj.height = 23;
	                }
	                else {
	                    imgObj.src = "/images/ezApprovalG/tab_" + szSuffix + GetTwoDigitNumber(i.toString()) + "o.gif";
	                    imgObj.height = 23;
	                }
	            }
	        }
	    }
	}
	function btnViewRejectReason_onclick(TransFlag) {
	    var DocList = new ListView();
	    DocList.LoadFromID("lvtDoclist");
	    var selnode = DocList.GetSelectedRows();
	
	    if (selnode.length > 0) {
	        var para = new Array();
	        para[0] = selnode[0].getAttribute("DATA1");
	        para[1] = TransFlag;
	
	        var url = "ViewCabRejectInfo.aspx";
	        var feature = "resizable:yes;status:no;dialogWidth:640px;dialogHeight:375px;scroll:no;help:no;edge:sunken";
	
	        if (url != "")
	            window.showModalDialog(url, para, feature);
	    }
	    else {
	        OpenAlertUI("<spring:message code='ezApprovalG.t513'/>");
	        }
	    }
	
		//페이지네이션
		function makePageSelPage(pTotalCnt) {
		    var strtext;
		    var PagingHTML = "";
		    document.getElementById("tblPageRayer").innerHTML = "";
		    strtext = "<div class='pagenavi'>";
		
		    PagingHTML += strtext;
		    totalPage = Math.ceil(new Number(pTotalCnt / PageSize));
		    var pageNum = curpage;
		    if (totalPage > 1 && pageNum != 1) {
				strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
				PagingHTML += strtext;
		    }
		    else {
				strtext = "<span class='btnimg first disabled'></span>"
				PagingHTML += strtext;
		    }
		    if (totalPage > BlockSize) {
		        if (pageNum > BlockSize) {
					strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
					PagingHTML += strtext;
		        }
		        else {
					strtext = "<span class='btnimg prev disabled'></span>";
					PagingHTML += strtext;
		        }
		    }
		    else {
				strtext = "<span class='btnimg prev disabled'></span>";
				PagingHTML += strtext;
		    }
		    var MaxNum;
		    var i;
		    var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
		    if (totalPage >= (startNum + parseInt(BlockSize))) {
		        MaxNum = (startNum + parseInt(BlockSize)) - 1;
		    }
		    else {
		        MaxNum = totalPage;
		    }
		    
		    if(totalPage == "0") {
		    	MaxNum = 1;
		    }
		    for (i = startNum; i <= MaxNum; i++) {
		        if (i == pageNum) {
		            strtext = "<span class='on'>" + i + "</span>"
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span onclick = 'goToPageByNum(" + i + ")'>" + i + "</span>"
		            PagingHTML += strtext;
		        }
		    }
		    if (totalPage > BlockSize) {
		        if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
					strtext = "<span class='btnimg next' onclick='return selafterBlock()'></span>";
					PagingHTML += strtext;
		        }
		        else {
					strtext = "<span class='btnimg next disabled'></span>";
					PagingHTML += strtext;
		        }
		    }
		    else {
				strtext = "<span class='btnimg next disabled'></span>";
				PagingHTML += strtext;
		    }
		    if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
				strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
				PagingHTML += strtext;
		    }
		    else {
				strtext = "<span class='btnimg last disabled'></span>";
				PagingHTML += strtext;
		    }
		    PagingHTML += "</div>";
		    td_Create1(PagingHTML);
		    TotalCount(pTotalCnt)
		}
		
		//리스트 총 갯수
		function TotalCount(pTotalCnt){
			if (pTotalCnt != null || pTotalCnt != undefined) {
				document.getElementById("TitleInfo").innerHTML = "&nbsp;<span class='txt_color' style='font-weight:bold;'>" + pTotalCnt + "</span>";
			}
			else {
	            document.getElementById("TitleInfo").innerHTML = "&nbsp;<span class='txt_color' style='font-weight:bold;'>" + pTotalCnt + "</span>&nbsp;/ " + period;
			}
			
		}
		function methodForTabAction(target) {
			//var tabObjs = target.parentElement.parentElement.children;
			var tabObjs = document.getElementById("tabs").children;
			for (var i = 0; i < tabObjs.length; i++){
				tabObjs[i].children[0].className = "";
			}
			target.className = "tabon";
		}
		
		// 기록물대장의 대외접수목록(m12), 대외발송목록(m13)이 아니라면 기본적으로 자신의 부서에만 접근한다. (false 리턴)
		function checkRecordAll() {
			return false;
		}
		
	    </script>
	</head>
	<body class="mainbody">
	    <h1>
	    	<c:choose>
	    		<c:when test="${initFlag == '0'}">
			        <spring:message code='ezApprovalG.t520'/>
	    		</c:when>
	    		<c:when test="${initFlag == '1'}">
			        <spring:message code='ezApprovalG.t521'/>
	    		</c:when>
	    		<c:when test="${initFlag == '2'}">
			        <spring:message code='ezApprovalG.t522'/>
	    		</c:when>
	    		<c:when test="${initFlag == '3'}">
			        <spring:message code='ezApprovalG.t523'/>
	    		</c:when>
	    		<c:when test="${initFlag == '4'}">
			       	 종료연기승인
	    		</c:when>
	    	</c:choose>
	        <span id="TitleInfo" style="color:#666;font-weight:normal;"></span>
	    </h1>
			<c:choose>
	    		<c:when test="${initFlag == '0'}">
		    		<div class="portlet_tabnew01" style="margin:0px;margin-bottom:15px">
						<div class="portlet_tabnew01_top" id="tabs">
							<p id="tab01"><span onclick="MM_swapImage(1, 'confirm', this);btnConfirmTargetCab_onclick();"class="tabon"><spring:message code='ezApprovalG.t549'/></span></p>
							<p id="tab02"><span onclick="MM_swapImage(2, 'confirm', this);btnNotArrangedCab_onclick();"><spring:message code='ezApprovalG.t550'/></span></p>
						</div>
					</div>
	    		</c:when>
	    		<c:when test="${initFlag == '1'}">
	    			<div class="portlet_tabnew01" style="margin:0px;margin-bottom:15px">
						<div class="portlet_tabnew01_top" id="tabs">
							<p id="tab08"><span onclick="MM_swapImage(8, 'd');btnProdReportCabList_onclick();"class="tabon"><spring:message code='ezApprovalG.t551'/></span></p>
							<p id="tab07"><span onclick="MM_swapImage(7, 'd');btnProdReportRecList_onclick();"><spring:message code='ezApprovalG.t552'/></span></p>
							<p id="tab13"><span onclick="MM_swapImage(13, 'd');GetCabHistList();"><spring:message code='ezApprovalG.t553'/></span></p>
							<p id="tab14"><span onclick="MM_swapImage(14, 'd');GetRecHistList();"><spring:message code='ezApprovalG.t554'/></span></p>
							<p id="tab15"><span onclick="MM_swapImage(15, 'd');GetSCList();"><spring:message code='ezApprovalG.t94'/></span></p>
							<p id="tab16"><span onclick="MM_swapImage(16, 'd');GetAttachList();"><spring:message code='ezApprovalG.t555'/></span></p>
							<p id="trTabList" style="display: none"><span id="tab17" onclick="MM_swapImage(17, 'd');GetDistList();"><spring:message code='ezApprovalG.t556'/></span></p>
						</div>
					</div>
	    		</c:when>
	    		<c:when test="${initFlag == '2'}">
	    			<div class="portlet_tabnew01" style="margin:0px;margin-bottom:15px">
						<div class="portlet_tabnew01_top" id="tabs">
							<p id="tab08"><span onclick="MM_swapImage(8, 'd');btnProdReportCabList_onclick();"class="tabon"><spring:message code='ezApprovalG.t551'/></span></p>
							<p id="tab07"><span onclick="MM_swapImage(7, 'd');btnProdReportRecList_onclick();"><spring:message code='ezApprovalG.t552'/></span></p>
							<p id="tab13"><span onclick="MM_swapImage(13, 'd');GetCabHistList();"><spring:message code='ezApprovalG.t553'/></span></p>
							<p id="tab14"><span onclick="MM_swapImage(14, 'd');GetRecHistList();"><spring:message code='ezApprovalG.t554'/></span></p>
							<p id="tab15"><span onclick="MM_swapImage(15, 'd');GetSCList();"><spring:message code='ezApprovalG.t94'/></span></p>
							<p id="tab16"><span onclick="MM_swapImage(16, 'd');GetAttachList();"><spring:message code='ezApprovalG.t555'/></span></p>
						</div>
					</div>
	    		</c:when>
	    		<c:when test="${initFlag == '3'}">
	    			<div class="portlet_tabnew01" style="margin:0px;margin-bottom:15px">
						<div class="portlet_tabnew01_top" id="tabs">
							<p id="tab01"><span onclick="MM_swapImage(1, 'disuse');btnDelTargetCabList_onclick();"class="tabon"><spring:message code='ezApprovalG.t557'/></span></p>
							<p id="tab02"><span onclick="MM_swapImage(2, 'disuse');btnDelTargetRecList_onclick();"><spring:message code='ezApprovalG.t558'/></span></p>
						</div>
					</div>
	    		</c:when>
	    		<c:when test="${initFlag == '4'}">
	    		</c:when>
	    	</c:choose>
			<c:choose>
	    		<c:when test="${initFlag == '0'}">
				    <div id="mainmenu">
				        <ul>
				            <li class="important" id="tdConfirmList"><span onclick="return btnConfirmList_onclick()"><spring:message code='ezApprovalG.t520'/></span></li>
				            <li id="tdViewInfo"><span onclick="return btnViewInfo_onclick()"><spring:message code='ezApprovalG.t527'/></span></li>
				            <li id="tdViewContent"><span onclick="return btnViewContent_onclick()"><spring:message code='ezApprovalG.t528'/></span></li>
				            <li id="tdViewHistory"><span onclick="return btnViewHistory_onclick()"><spring:message code='ezApprovalG.t947'/></span></li>
				            <li id="tdListPrint"><span onclick="return DocListPrinter_onclick()"><spring:message code='ezApprovalG.t530'/></span></li>
				            <li id="tdViewCabList"><span onclick="return btnConfirmTargetCab_onclick()"><spring:message code='ezApprovalG.t525'/></span></li>
				            <li id="tdViewRecList"><span onclick="return ViewRecListInCab()"><spring:message code='ezApprovalG.t526'/></span></li>
				        </ul>
				    </div>
	    		</c:when>
	    		<c:when test="${initFlag == '1'}">
				    <div id="mainmenu">
				        <ul>
				            <li id="tdMKProdListFile"><span onclick="return btnMakeProdFile_onclick()"><spring:message code='ezApprovalG.t531'/></span></li>
				            <li id="tdProdStatistics"><span onclick="return btnProdStatistics_onclick()"><spring:message code='ezApprovalG.t532'/></span></li>
				            <li id="tdSndProdList"><span onclick="return btnSndProdList_onclick()"><spring:message code='ezApprovalG.t533'/></span></li>
				            <li id="tdViewRejectReason"><span onclick="return btnViewRejectReason_onclick('0')"><spring:message code='ezApprovalG.t534'/></span></li>
				            <!-- <li id="tbar2" style="background: none; padding-right: 2px;">
				                <img src="/images/i_bar.gif" align="absmiddle"></li> -->
				            <li id="tdSearch"><span onclick="return Search_Onclick('1')"><spring:message code='ezApprovalG.t111'/></span></li>
				            <li id="tdViewInfo"><span onclick="return btnViewInfo_onclick()"><spring:message code='ezApprovalG.t527'/></span></li>
				            <li id="tdListPrint"><span onclick="return DocListPrinter_onclick()"><spring:message code='ezApprovalG.t530'/></span></li>
				        </ul>
				    </div>
	    		</c:when>
	    		<c:when test="${initFlag == '2'}">
				    <div id="mainmenu">
				        <ul>
				            <li id="tdTransList"><span onclick="return imgSndTransList_onclick()"><spring:message code='ezApprovalG.t535'/></span></li>
				            <li id="tdTransFile"><span onclick="return imgSndTransFile_onclick()"><spring:message code='ezApprovalG.t536'/></span></li>
				            <li id="tdTransComplete"><span onclick="return TransComplete_OnClick()"><spring:message code='ezApprovalG.t537'/></span></li>
				            <!-- <li id="tbar3" style="background: none; padding-right: 2px;">
				                <img src="/images/i_bar.gif" align="absmiddle"></li> -->
				            <li id="tdAddDelayList"><span onclick="return btnAddDelayList_onclick()"><spring:message code='ezApprovalG.t538'/></span></li>
				            <li id="tdDelayList"><span onclick="return btnDelayList_onclick()"><spring:message code='ezApprovalG.t539'/></span></li>
				            <li id="tdViewRejectReason"><span onclick="return btnViewRejectReason_onclick('0')"><spring:message code='ezApprovalG.t534'/></span></li>
				            <!-- <li id="tbar4" style="background: none; padding-right: 2px;">
				                <img src="/images/i_bar.gif" align="absmiddle"></li> -->
				            <li id="tdSearch"><span onclick="return Search_Onclick('1')"><spring:message code='ezApprovalG.t111'/></span></li>
				            <li id="tdViewInfo"><span onclick="return btnViewInfo_onclick()"><spring:message code='ezApprovalG.t527'/></span></li>
				            <li id="tdListPrint"><span onclick="return DocListPrinter_onclick()"><spring:message code='ezApprovalG.t530'/></span></li>
				        </ul>
				    </div>
	    		</c:when>
	    		<c:when test="${initFlag == '3'}">
				    <div id="mainmenu">
				        <ul>
				            <li><span onclick="return btnDisuseItem_onclick()"><spring:message code='ezApprovalG.t523'/></span></li>
				            <!-- <li id="tbar4" style="background: none; padding-right: 2px;">
				                <img src="/images/i_bar.gif" align="absmiddle"></li> -->
				            <li id="tdViewInfo"><span onclick="return btnViewInfo_onclick()"><spring:message code='ezApprovalG.t527'/></span></li>
				            <li id="tdViewContent"><span onclick="return btnViewContent_onclick()"><spring:message code='ezApprovalG.t528'/></span></li>
				            <li id="tdViewHistory"><span onclick="return btnViewHistory_onclick()"><spring:message code='ezApprovalG.t947'/></span></li>
				            <li id="tdListPrint"><span onclick="return DocListPrinter_onclick()"><spring:message code='ezApprovalG.t530'/></span></li>
				        </ul>
				    </div>
	    		</c:when>
	    		<c:when test="${initFlag == '4'}">
				    <div id="mainmenu">
				        <ul>
				        	<li class="important" id="tdConfirmEndYAll"><span onclick="return btnConfirmEndY_onclick('1')">종료연기전체승인</span></li>
				            <li class="important" id="tdConfirmEndY"><span onclick="return btnConfirmEndY_onclick('0')">종료연기승인</span></li>
				            <li class="important" id="tdCancelDelayEndY"><span onclick="return btnConfirmEndY_onclick('2')">종료연기취소</span></li>
				            <li id="tdViewInfo"><span onclick="return btnViewInfo_onclick()"><spring:message code='ezApprovalG.t527'/></span></li>
				            <li id="tdViewContent"><span onclick="return btnViewContent_onclick()"><spring:message code='ezApprovalG.t528'/></span></li>
				            <li id="tdListPrint"><span onclick="return DocListPrinter_onclick()"><spring:message code='ezApprovalG.t530'/></span></li>
				            <li id="tdViewCabList"><span onclick="return GetEndYConfirmList()"><spring:message code='ezApprovalG.t525'/></span></li>
				            <li id="tdViewRecList"><span onclick="return ViewRecListInCab()"><spring:message code='ezApprovalG.t526'/></span></li>
				        </ul>
				    </div>
	    		</c:when>
	    	</c:choose>
	    	<c:choose>
	    		<c:when test="${initFlag == '1'}">
				    <table class="content">
				        <tr>
				            <th><spring:message code='ezApprovalG.t542'/></th>
				            <td id="tdDeptInfo">&nbsp;</td>
				        </tr>
				    </table>
				    <table class="popuplist" width="100%" style="margin-top: 5px">
				        <tr>
				            <th width="50%"><spring:message code='ezApprovalG.t543'/></th>
				            <th width="50%"><spring:message code='ezApprovalG.t544'/></th>
				        </tr>
				        <tr>
				            <td width="50%" id="tdListTransStatus" align="center">&nbsp;</td>
				            <td width="50%" id="tdRcvComplStatus" align="center">&nbsp;</td>
				        </tr>
				    </table>
				
				    <div id="divErrMsg" style="display: yes">
				        <table class="content" style="margin-top: 5px">
				            <tr>
				                <th><spring:message code='ezApprovalG.t545'/></th>
				                <td id="tdErrMsg">&nbsp;</td>
				            </tr>
				        </table>
				    </div>
				
				    <table border="0" cellpadding="0" cellspacing="0">
				        <tr>
				            <td height="5">&nbsp;</td>
				        </tr>
				    </table>
	    		</c:when>
	    		<c:when test="${initFlag == '2'}">
				    <table class="content">
				        <tr>
				            <th><spring:message code='ezApprovalG.t546'/></th>
				            <td id="tdDeptInfo">&nbsp;</td>
				        </tr>
				    </table>
				    <table class="popuplist" width="100%" style="margin-top: 5px">
				        <tr>
				            <th width="25%"><spring:message code='ezApprovalG.t543'/></th>
				            <th width="25%"><spring:message code='ezApprovalG.t547'/></th>
				            <th width="25%"><spring:message code='ezApprovalG.t548'/></th>
				            <th width="25%"><spring:message code='ezApprovalG.t544'/></th>
				        </tr>
				        <tr>
				            <td width="25%" id="tdListTransStatus">&nbsp;</td>
				            <td width="25%" id="tdFileTransStatus">&nbsp;</td>
				            <td width="25%" id="tdArchiveRcvStatus">&nbsp;</td>
				            <td width="25%" id="tdRcvComplStatus">&nbsp;</td>
				        </tr>
				    </table>
				    <div id="divErrMsg" style="display: none">
				        <table width="650" border="1" cellpadding="3" cellspacing="0" bordercolor="b6b6b6" class="pt" style="border-collapse: collapse;">
				            <tr>
				                <td><spring:message code='ezApprovalG.t545'/></td>
				                <td width="100%" id="tdErrMsg">&nbsp;</td>
				            </tr>
				        </table>
				    </div>
				    <table>
				        <tr>
				            <td height="5">&nbsp;</td>
				        </tr>
				    </table>
	    		</c:when>
	    	</c:choose>	
	    <table style="display:none">
	        <tr>
	            <td height="25"><span id="listcount" class="point">&nbsp;</span></td>
	            <td align="right">
	                <table border="0" cellpadding="0" cellspacing="0">
	                    <tr>
	                        <td align="right" id="PageNum">&nbsp;</td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
    	<%-- <c:choose>
	    		<c:when test="${initFlag == '0'}">
				    <div id="tabnav" style="width: 100%">
				        <ul>
				            <li id="tab01"><span onclick="MM_swapImage(1, 'confirm');btnConfirmTargetCab_onclick();"><spring:message code='ezApprovalG.t549'/></span></li>
				            <li id="tab02"><span onclick="MM_swapImage(2, 'confirm');btnNotArrangedCab_onclick();"><spring:message code='ezApprovalG.t550'/></span></li>
				        </ul>
				    </div>
	    		</c:when>
	    		<c:when test="${initFlag == '1'}">
				    <div id="tabnav" style="width: 100%">
				        <ul>
				            <li id="tab08"><span onclick="MM_swapImage(8, 'd');btnProdReportCabList_onclick();"><spring:message code='ezApprovalG.t551'/></span></li>
				            <li id="tab07"><span onclick="MM_swapImage(7, 'd');btnProdReportRecList_onclick();"><spring:message code='ezApprovalG.t552'/></span></li>
				            <li id="tab13"><span onclick="MM_swapImage(13, 'd');GetCabHistList();"><spring:message code='ezApprovalG.t553'/></span></li>
				            <li id="tab14"><span onclick="MM_swapImage(14, 'd');GetRecHistList();"><spring:message code='ezApprovalG.t554'/></span></li>
				            <li id="tab15"><span onclick="MM_swapImage(15, 'd');GetSCList();"><spring:message code='ezApprovalG.t94'/></span></li>
				            <li id="tab16"><span onclick="MM_swapImage(16, 'd');GetAttachList();"><spring:message code='ezApprovalG.t555'/></span></li>
				            <li id="trTabDist" style="display: none"><span id="tab17" onclick="MM_swapImage(17, 'd');GetDistList();"><spring:message code='ezApprovalG.t556'/></span></li>
				        </ul>
				    </div>
	    		</c:when>
	    		<c:when test="${initFlag == '2'}">
				    <div id="tabnav" style="width: 100%">
				        <ul>
				            <li id="tab08"><span onclick="MM_swapImage(8, 'd');btnProdReportCabList_onclick();"><spring:message code='ezApprovalG.t551'/></span></li>
				            <li id="tab07"><span onclick="MM_swapImage(7, 'd');btnProdReportRecList_onclick();"><spring:message code='ezApprovalG.t552'/></span></li>
				            <li id="tab13"><span onclick="MM_swapImage(13, 'd');GetCabHistList();"><spring:message code='ezApprovalG.t553'/></span></li>
				            <li id="tab14"><span onclick="MM_swapImage(14, 'd');GetRecHistList();"><spring:message code='ezApprovalG.t554'/></span></li>
				            <li id="tab15"><span onclick="MM_swapImage(15, 'd');GetSCList();"><spring:message code='ezApprovalG.t94'/></span></li>
				            <li id="tab16"><span onclick="MM_swapImage(16, 'd');GetAttachList();"><spring:message code='ezApprovalG.t555'/></span></li>
				        </ul>
				    </div>
	    		</c:when>
	    		<c:when test="${initFlag == '3'}">
				    <div id="tabnav" style="width: 100%">
				        <ul>
				            <li id="tab01"><span onclick="MM_swapImage(1, 'disuse');btnDelTargetCabList_onclick();"><spring:message code='ezApprovalG.t557'/></span></li>
				            <li id="tab02"><span onclick="MM_swapImage(2, 'disuse');btnDelTargetRecList_onclick();"><spring:message code='ezApprovalG.t558'/></span></li>
				        </ul>
				    </div>
	    		</c:when>
	    		<c:when test="${initFlag == '4'}">
	    		</c:when>
	    	</c:choose> --%>
    	
    	<c:choose>
    		<c:when test = "${initFlag == '0' }">
    			<div id="divList" class="div_scroll" style="width: 100%; height: 676px; overflow: AUTO; margin-bottom:10px;">
    		</c:when>
    		<c:when test = "${initFlag == '4' }">
    			<div id="divList" class="div_scroll" style="width: 100%; height: 740px; overflow: AUTO; margin-bottom:10px;">
    		</c:when>
	    </c:choose>
	    
	        <div id="lvtDoclist"></div>
	    </div>
	    <div id="tblPageRayer"></div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	        
			if ("${initFlag}" != "4") {
        		/* selToggleList(document.getElementById("tabnav"), "ul", "li", "1"); */
	        }
	    </script>
	    
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
