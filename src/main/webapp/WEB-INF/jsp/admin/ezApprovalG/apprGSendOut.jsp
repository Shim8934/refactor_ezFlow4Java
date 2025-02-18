<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<!-- <link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.css')}"> -->
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/font-awesome-4.7.0/css/font-awesome.min.css')}" type="text/css"/>
		<style> 
			.IMG_BTN { behavior:url("/css/include/ImgBtn.htc") }
			.pagetd{padding-top:6px; }
			.pcol{padding-top:6px; }
			.Right_Point01 {
				font:bold;
				color:#017bec;
			}
			#div_AprLine .mainlist tr th {
				border-top:0px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>	
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/aprmanage_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/setLogData.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.js')}"></script>
		<!-- <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script> -->
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/nonElecRec.js')}"></script>
		
		<script ID="clientEventHandlersJS" type="text/javascript">
		    window.onload = window_onload;
		    var Resultxml = createXmlDom();
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "<c:out value = '${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value = '${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value = '${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value = '${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value = '${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value = '${userInfo.jikChek}'/>";
		    arr_userinfo[8]  = "<c:out value = '${userInfo.email}'/>";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "<c:out value = '${susinAdmin}'/>";
		    var companyID = "<c:out value = '${userInfo.companyID}'/>";
		    arr_userinfo[7] = "<c:out value = '${buJaeInfo}'/>";
		    arr_userinfo[11]  = "<c:out value = '${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value = '${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value = '${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value = '${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value = '${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value = '${userInfo.deptName2}'/>";
		    var proxyInfo = "<c:out value = '${proxyInfo}'/>";
		    var proxyStartDate = "<c:out value = '${proxyInfo.startDate}'/>"
		    var proxyEndDate = "<c:out value = '${proxyInfo.endDate}'/>"
		    var formURL = "";
		    var formDocType = "";
		    var pDocInfoValue = "1";
		    var pListTypeValue = '9';
		    var pListTypeName = "LISTTYPE";
		    var pDocTypeName = "DOCTYPE";
		    var pUserID = arr_userinfo[1];
		    var KuyjeType;
		    var g_tagSelect = "1";
		    var g_tagSelectsub ="1";
		    var SelectFlag = true;
		    var pSusinManagerFlag;
		    var g_timeID;
		    var displayFlag = true;
		    var pdate; 
		    var datedisplay = "";
		    var pageNum = "1";
		    var BlockSize = "10";
		    var chkPage = true;
		    var newDocID = "";
		    var pDocID = "";
		    var pURL = "";
		    var Block_Size = 10; 
		    var nowblock = "0";
		    var OrderOption = "";
		    var OrderCell = "";
		    var USE_OCS = "NO";
		    var SendOutFlag = "O";
		    var g_RelayG_Type = "HWP";
		    var userLang = "1";
		    var pSelMenu = "all";
		    var pOpenYaer = "<c:out value = '${openYear}'/>";
		    var ViewLeftCount = "<c:out value = '${viewLeftCount}'/>";
		    var CurrentHeight = 0;
		    var CurrentWidth = 0;
		    var approvalFlag = "<c:out value = '${approvalFlag}'/>"; //전자결재 G , S 여부
		    var forceCallBackYN = "<c:out value = '${forceCallBackYN}'/>";
		    var SubQuery = "<c:out value = '${SubQuery}'/>";
		    var condition = new Array();
		    var nowDate = "<c:out value = '${nowDateUTC}'/>";
		    var ext;
		    var currentpage = 1;
		    var selRowChangeFlag = false;
		    var orgCompanyID = "";
		    var useHWP = "Y";
			var userLang = "<c:out value = '${userLang}'/>";
			var useAdditionalRole = "${useAdditionalRole}";
			var userLang = "${userInfo.lang}";
		    var shareUser = "<c:out value = '${shareUser}'/>";
		    var primary = "<c:out value = '${primary}'/>"; // 재기안 시 부서명 다국어 분기처리를 위한 primary (1:기본어, 2:다국어)
		    
		    var selectcabinet_cross_dialogArguments = new Array();
		    
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
		    
		    
		    function getAdminSendOutDocList() {    
		        pSelMenu = "all";

		        if (beforeJob != pListTypeValue || SelYearFlag || SearchFlag) {
		            beforeJob = pListTypeValue;
		            pageNum = 1;
		            OrderOption = "";
		            OrderCell = "";
		        }
		        
		        var searchStatus = $("#sel_status option:selected").val();

		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/admin/ezApprovalG/getSendOutDocList.do",
		    		data : {
		    				userID : pUserID,
		    				deptID  : arr_userinfo[4],
		    				susinManagerFlag : SendOutFlag,
		    				pageSize : pageSize,
		    				pageNum  : pageNum,
		    				orderCell : OrderCell,
		    				orderOption : OrderOption,
		    				listType : pListTypeValue,
		    				searchQuery  : SQLPARADATA,
		    				searchStatus : searchStatus
		    				},
		    		success: function(xml){
		    			getSendOutDocList_after(loadXMLString(xml));
		    		}        			
		    	});
		        
		        //DisplayWaitStat();

		    }
		    
		    
		    function checkBujaeInfo() {
//		    	if (pListTypeValue == "10") {
//		    		checkBujaeInfo_Complete(true);
//		    		return;
//	            }
		        var BString = arr_userinfo[7];
		        
		        if (BString != "") {
		            var BDim = new Array("");
		            BDim = BString.split(":");
		            var tmpStartDate = (BDim[3] + ":" + BDim[4]).substring(0, 16);
		            var tmpEndDate = (BDim[5] + ":" + BDim[6]).substring(0, 16);
		
		            tmpStartDate = tmpStartDate.replace("/", ":");
		            tmpEndDate = tmpEndDate.replace("/", ":");
		            
		            if (tmpEndDate < "<c:out value = '${nowDate}'/>") {
		                setBujaeOff();
		                checkBujaeInfo_Complete(true);
		                return true;

		            } else if (tmpStartDate > "<c:out value = '${nowDate}'/>") {
		            	checkBujaeInfo_Complete("ING");
		                return true;
		            }
		            
		            var pAlertContent = "";
		            pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>"+"<spring:message code='ezApprovalG.t1723'/>" + "<br>"+ " <spring:message code='ezApprovalG.t1724'/>";

		            var Rtnval = OpenInformationUI(pAlertContent, checkBujaeInfo_Complete, "OPEN");
		            if (Rtnval) {
		                checkBujaeInfo_Complete(true);
		            }
		            else {
		                checkBujaeInfo_Complete(false);
		            }
		        } else if(GetBujaeFlag()){
		        	
		        		tmpStartDate = proxyStartDate;
		        		tmpEndDate = proxyEndDate;
		        		
		        		var pAlertContent = "";
		        		pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>"+"<spring:message code='ezApprovalG.t1723'/>" + "<br>"+ " <spring:message code='ezApprovalG.t1724'/>";

			            var Rtnval = OpenInformationUI(pAlertContent, checkBujaeInfo_Complete, "OPEN");
			            if (Rtnval) {
			                checkBujaeInfo_Complete(true);
			            }
			            else {
			                checkBujaeInfo_Complete(false);
			            }		            	
		        } else {
		            checkBujaeInfo_Complete("ING");
		        }
		    }
		
		    function checkBujaeInfo_Complete(Rtnval) {
	            if (Rtnval == true) {
	                setBujaeOff();
	                btnVisible('ok');
	            }
	            else if (Rtnval == "ING") { }
	            else {
	            	btnVisible('false');
	                setbuttonenable();
	                return;
	            }

	            if (beforeJob != pListTypeValue) {
		            pageNum = 1;
		        }
		        if (arr_userinfo[10] == "YES" || arr_userinfo[10] == "Y")
		            pSusinManagerFlag = "admin";
		        else
		            pSusinManagerFlag = "user";
		
		        var nowyear = nowDate.substring(0,4);
		        var nowmonth = nowDate.substring(5,7);
		        var nowday = nowDate.substring(8,10);
		        
				if (SQLPARADATA == null || SQLPARADATA == "") {
			        SQLPARADATA = "<ROOT><TYPE>APRSTARTDATE;APRENDDATE;</TYPE><DATA><APRSTARTDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + "</APRSTARTDATE><APRENDDATE>" + nowyear + "-" + nowmonth + "-" + nowday + "</APRENDDATE></DATA></ROOT>";
				}
		
		        if (pListTypeValue == "1") {
		            getDocList();
		        }
		        else if (pListTypeValue == "2") {
		            getDocList();
		        }
		        else if (pListTypeValue == "3") {
		            getDocList();
		        }
		        else if (pListTypeValue == "4") {
		            getReceivedDocList();
		        }
		        else if (pListTypeValue == "6") {
		            getSimsaDocList();
		        }
		        else if (pListTypeValue == "7") {
		            SendOutFlag = "O";
		            getSendOutDocList();
		        }
		        else if (pListTypeValue == "8") {
		            SendOutFlag = "S";
		            getSendOutDocList();
		        }
		        else if (pListTypeValue == "9") {
		            SendOutFlag = "SS";
		            getAdminSendOutDocList();
		        }
		        else if (pListTypeValue == "10") {
		            getDocList();
// 		            var result = "";
			    	
// 			        $.ajax({
// 			    		type : "POST",
// 			    		dataType : "text",
// 			    		async : false,
// 			    		url : "/ezPersonal/saveBujae.do",
// 			    		data : {
// 			    				buJae  : bujaeVal,
// 			    				proxy  : ""
// 			    				},
// 			    		success: function(xml){
// 			    			result = xml;
// 			    		}        			
// 			    	});
		        }
		        else if (pListTypeValue == "21") {
		            getDocList();
		        }
		        else if (pListTypeValue == "99") {
		            getDocList();
		        }
		        else if (pListTypeValue == "11") {
		        	getDocList();
		        }
		        
		        
		        try {
		            parent.frames["left"].getAprCount();
		            parent.frames["left"].setPresentValue("");
		        } catch (e) { }
	        }
		    
		  	var bujaeVal="";
		    function setBujaeOff() {
		    	var result = "";
		    	
// 		    	if(pListTypeValue != "10") {
// 		    		bujaeVal = "";
// 		    	}
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/saveBujae.do",
		    		data : {
		    				buJae  : "",
		    				proxy  : "",
		    				dept : arr_userinfo[4]
		    				},
		    		success: function(xml){
		    			result = xml;
		    		}        			
		    	});
		        
		        bujaeVal = arr_userinfo[7];
		        arr_userinfo[7] = "";
		       
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/getBujaeInfo.do",
		    		data : {
		    				buJae  : bujaeVal,
		    				proxy  : "",
		    				dept : arr_userinfo[4]
		    				},
		    		success: function(xml){
		    			result = xml;
		    			if (result != "") {
		    				window.location.reload();
		    			}
		    		}        			
		    	});
		        
		        
		    }
		
		    $(function () {
		      	if(approvalFlag == "G") {
	        		$(".approvalG").css("display","");
	        		$(".approval").css("display","none");
	        	} else{
	        		$(".approvalG").css("display","none");
	        		$(".approval").css("display","");
	        	}
		      	
		      	/* 2018-06-19 김민성 - 전자결재 selectbox 기본으로 변경 */
		        /* $("#sel_year").selectmenu({
		            change: function (event, data) {
		                onSelect_Year(data.item.value);
		            }
		        }); */
		
		        /* $("#number")
		          .selectmenu()
		          .selectmenu("menuWidget")
		            .addClass("overflow"); */
		    });
		  
		    function window_onload() {
		        CurrentHeight = document.documentElement.clientHeight;
		        CurrenWidth = document.documentElement.clientWidth;
		        var height = parseInt(divList.style.height.replace('px', '')) + 200;
		        var reheight = document.documentElement.offsetHeight - parseInt(height);
		
		        //document.getElementById('div_AprLine').style.height = reheight + "px";
		
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        try {
		        var toDay = new Date();
		        var toDayYear = parseInt(nowDate.substring(0,4));
		        var minusYear = parseInt(nowDate.substring(0,4)) - parseInt(pOpenYaer);
				
		        var cell = document.getElementById("sel_year");

		        var selectedCell = $("#sel_year option:selected").val();
		        
		        while(cell.hasChildNodes()) {
		        	cell.removeChild(cell.firstChild);	
		        }
		        
		        var defaultCell = '<spring:message code="ezApprovalG.kmsg01"/>';
		        
		        AddOption(sel_year, defaultCell, "ALL");
		        
		        for (var i = toDayYear; i >= toDayYear - minusYear ; i--) {
		            AddOption(sel_year, i, i);
		        }
		        if(selectedCell !== undefined) {
		        	document.getElementById("sel_year").value = selectedCell;
		        }
		        checkBujaeInfo();
		        } catch (e) {
		            hideProgress();
		        }
		        
		        var selectedStatusCell = $("#sel_status option:selected").val();
		        if (selectedStatusCell == undefined) {
		        	change_statusCell();
		        }
		        
				if ($("#presentcell").html() != undefined) {
                    if ($("#presentcell").html().trim() == "") {
						$("#presentcell").html("발송현황");
                    }
                    document.title = $("#presentcell").html();
		        }
				
				/* 2020-06-18 홍승비 - 임시보관함으로 진입한 경우, 우측 상단 간단검색메뉴에서 기안자 제거 (window_onload가 동작하는 S버전 기준) */
				var selectWriter = $("#selectType").find("option[value='rad_Writer']");
				if (pListTypeValue == "21") { // 임시보관함의 경우, 기안자 검색조건 제거
					if (selectWriter.length > 0) {
						selectWriter.remove();
					}
				} else { // 그 외의 경우, 다시 기안자 검색조건을 어팬드
					if (selectWriter.length <= 0) {
						$("#selectType").append('<option value="rad_Writer"><spring:message code="ezApprovalG.t445"/></option>');
					}
				}
				
		    }
			
		    function change_statusCell() {
		        var statusCell = document.getElementById("sel_status");
		        
		        while(statusCell.hasChildNodes()) {
		        	statusCell.removeChild(statusCell.firstChild);	
		        }
		        
			    AddOption(sel_status, '<spring:message code="ezPoll.t104"/>', "ALL");
			    
			    $('#sel_status_div').closest("li").show();
			    
		        if (pListTypeValue == "1") {
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t1422"/>', "002");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t50"/>', "005");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t49"/>', "004");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t66"/>', "006");
		        	AddOption(sel_status, '<spring:message code="ezApproval.t497"/>', "015");
		        } else if (pListTypeValue == "2" || pListTypeValue == "3") {
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t1422"/>', "002");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t50"/>', "005");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t49"/>', "004");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t66"/>', "006");
		        } else if (pListTypeValue == "4") {
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.garm06"/>', "011");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t1432"/>', "014");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t1430"/>', "012");
		        	AddOption(sel_status, '<spring:message code="ezApproval.t497"/>', "015");
		        } else if (pListTypeValue == "9") {
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t1308"/>', "I");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t239"/>', "Y");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.F0031"/>', "R");
		        	AddOption(sel_status, '<spring:message code="ezApproval.t155"/>', "S");
		        	AddOption(sel_status, strLangAprState21, "V");
		        } else if (pListTypeValue == "11") {
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t1422"/>', "002");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t50"/>', "005");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t49"/>', "004");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t66"/>', "006");
		        	AddOption(sel_status, '<spring:message code="ezApproval.t497"/>', "015");
		        } else {
		        	$('#sel_status_div').closest("li").hide();
		        }
		        
		    }
		    
		    var SelYearFlag = false;
		    function onSelect_Year() {
		        SelYearFlag = true;
		        if (GetSelectVal("sel_year") != "ALL")
		            SQLPARADATA = "<ROOT><TYPE>APRSTARTDATE;APRENDDATE;</TYPE><DATA><APRSTARTDATE>" + GetSelectVal("sel_year") + "-01-01</APRSTARTDATE><APRENDDATE>" + GetSelectVal("sel_year") + "-12-31</APRENDDATE></DATA></ROOT>";
		        else {
		            var nowyear = nowDate.substring(0,4);
		            var nowmonth = parseInt(nowDate.substring(5,7));
		            var nowday = parseInt(nowDate.substring(8,10));        
		
		            SQLPARADATA = "<ROOT><TYPE>APRSTARTDATE;APRENDDATE;</TYPE><DATA><APRSTARTDATE>" + (nowyear - 1) + "-" + nowmonth + "-" + nowday + "</APRSTARTDATE><APRENDDATE>" + nowyear + "-" + nowmonth + "-" + nowday + "</APRENDDATE></DATA></ROOT>";		            

		        }
		
		        if (pListTypeValue == "1") {
		            getDocList();
		        }
		        else if (pListTypeValue == "2") {
		            getDocList();
		        }
		        else if (pListTypeValue == "3") {
		            getDocList();
		        }
		        else if (pListTypeValue == "4") {
		            getReceivedDocList();
		        }
		        else if (pListTypeValue == "6") {
		            getSimsaDocList();
		        }
		        else if (pListTypeValue == "7") {
		            SendOutFlag = "O";
		            getSendOutDocList();
		        }
		        else if (pListTypeValue == "8") {
		            SendOutFlag = "S";
		            getSendOutDocList();
		        }
		        else if (pListTypeValue == "9") {
		            SendOutFlag = "SS";
		            getSendOutDocList();
		        }
		        else if (pListTypeValue == "10") {
		            getDocList();
		        }
		        else if (pListTypeValue == "99") {
		            getDocList();
		        }
		        else if (pListTypeValue == "21") {
		            getDocList();
		        }
		        else if (pListTypeValue == "11") {
		        	getDocList();
		        }
		    }
		    
		    function onSelect_Status() {
		    	pageNum = 1;
		        if (pListTypeValue == "1" || pListTypeValue == "2" || pListTypeValue == "3" || pListTypeValue == "11") {
		            getDocList();
		        } else if (pListTypeValue == "4") {
		        	getReceivedDocList();
		        } else if (pListTypeValue == "9") {
		        	getSendOutDocList();
		        }
		    }
		
		    function lvDocList_SelChange() {
		        var SelList = new ListView();
		        SelList.LoadFromID("DocList");
		        var oArrRows = SelList.GetSelectedRows();
		        var tr = oArrRows[0];
		        ext =  tr.getAttribute("DATA3").substr(tr.getAttribute("DATA3").length - 3, tr.getAttribute("DATA3").length).toLowerCase();
		        if (tr.length != 0) {
		            if (pListTypeValue != "5") {
		                if (pDocInfoValue == "1")
		                    getAprLine(tr);
		                else {
		                    getAprDocAproveInfo(tr);
		                }
		            }
		            else {
		                if (tr) {
		                    pDocID = tr.getAttribute("DATA1");
		                    pURL = tr.getAttribute("DATA2");
							
		                    switch (pDocInfoValue) {
		                        case "4":
		                            getDataInfo("3");
		                            break;
		
		                        case "3":
		                            getDataInfo("4");
		                            break;
		
		                        case "1":
		                            getDataInfo("1");
		                            break;
		
		                        case "2":
		                            getDataInfo("2");
		                            break;
		                    }
		                }
		            }
		            setbuttonenable();
		            if (pListTypeValue == "2" || pListTypeValue == "3") {
		                if (oArrRows.length != 0) {
		                    var DocID = tr.getAttribute("DATA1");
		                    cancelYN(DocID);
		                }
		            }
		        }
		    }
		    function lvDocList_SelChanging() {
		
		    }
		    function lvDocList_DBSelChange() {
		        var SelList = new ListView();
		        SelList.LoadFromID("DocList");
		        var oArrRows = SelList.GetSelectedRows();
		        var pCurSelRow = oArrRows[0];
		        orgCompanyID = pCurSelRow.getAttribute("ORGCOMPANYID");
		        if (pCurSelRow != null && oArrRows.length > 0) {
		            if (GetBujaeFlag())
		                return;
		            if (pListTypeValue == "1" || pListTypeValue == "11") { //listTypeValue = 11(공유결재문서)
						if (checkAprState(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("DATA12"), pCurSelRow.getAttribute("DATA4"), pCurSelRow.getAttribute("APRMEMBERSN"), pCurSelRow.getAttribute("ORGCOMPANYID"))){
							alert("<spring:message code='ezApprovalG.bhs23'/>");
							getDocList();
							return;
	                	}
		                if (pCurSelRow.getAttribute("DATA12") == "015")
		                    openViewDocInfo();
		                else if (document.getElementById("tbtnRedraft").style.display == "none" && document.getElementById("tbtnApprove").style.display == ""){
		                    openApprovUI();
		                }
		                else
		                    btnRedraft_onclick();
		            } else if (pListTypeValue == "4") {
		                if (pSusinManagerFlag == "admin" || pCurSelRow.getAttribute("DATA8") == pUserID) {
		                    var pDraftFlag;
		                    var tmpDocState = pCurSelRow.getAttribute("DATA9");
		                    if (tmpDocState == strDocState11 || tmpDocState == strDocState16)
		                        pDraftFlag = "SUSIN";
		                    else if (tmpDocState == strDocState12 || tmpDocState == strDocState2)
		                        pDraftFlag = "HAPYUI";
		                    if (pCurSelRow.getAttribute("DATA10") == strAprState15) {
		                        openViewDocInfo();
		                    }
		                    else {
		                        OpenReceiveDraftUI(pCurSelRow, pDraftFlag);
		                    }
		                } else {
		                    openViewDocInfo();
		                }
		            } else if (pListTypeValue == "21") { //한양대 임시저장 
		                pDocID = pCurSelRow.getAttribute("DATA1");
// 		                var newDocID = MakeTmp2Ing(pDocID);
		                pURL = pCurSelRow.getAttribute("DATA3");
		                btnRedraft_onclick();
		            } else if (pListTypeValue != "5") {
		                openViewDocInfo();
		            } else {
		                var para = new Array();
		                var tempURL = pURL;
		                
		                para[0] = pDocID;
		                para[1] = pURL;
		                
		                if (tempURL.substr(tempURL.length - 4, tempURL.length).toLowerCase() == ".ezd") {
		                	tempURL = tempURL.substr(0, tempURL.length - 4);
		                }
		                
		                if (tempURL.substr(tempURL.length - 3, tempURL.length).toLowerCase() == "hwp") {
		                	if (isIE()) {
			                	openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
		                	} else {
		                		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
			                    alert(pAlertContent);
			                    
			                    return;
		                	}
		                } else {
	                        openLocation = "/ezApprovalG/contDocView.do";
		                    openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pURL) + "&listSusin=" +"&orgCompanyID=" + orgCompanyID;
		                }
		                
		                openwindow(openLocation, "", 880, 570);
		            }
		        }
		    }
		    function lvDocList_HeaderClick(pHeaderName) {
		        if (OrderCell == pHeaderName) {
		            if (OrderOption == "")
		                OrderOption = "DESC";
		            else
		                OrderOption = "";
		        }
		        else {
		            OrderCell = pHeaderName;
		            OrderOption = "";
		        }
		        openergetDocInfo();
		    }
		    function lvAprLine_SelChange() {
		        if (pDocInfoValue == "1" || pDocInfoValue == "2") {
		            var SelList = new ListView();
		            SelList.LoadFromID("AprLine");
		            var pCurSelRow = SelList.GetSelectedRows();
		            //if (pCurSelRow.length != 0)
		            //    document.getElementById("tbtnUserInfo").style.display = "";
		        }
		    }
		    
		    function lvAprLine_DBSelChange() {
				var DocList = new ListView();
	            DocList.LoadFromID("AprLine");
	            var oArrRows = DocList.GetSelectedRows();
	            var tr = oArrRows[0];
	            
		        switch (pDocInfoValue) {
		            case "1":
		                openUserInfo();
		                break;
		            case "2":
		                break;
		            case "4":
		            	var AttachfilenameA1 = tr.cells[1].innerHTML;
                        if (AttachfilenameA1 != null) {
                            var AttachfilenameN1 = AttachfilenameA1.lastIndexOf(".");
                            var AttachfilenameA2 = AttachfilenameA1.substr(AttachfilenameN1, AttachfilenameA1.length);
                            var AttachUrlA1 = GetAttribute(tr,"DATA1");
                            var AttachUrlN1 = AttachUrlA1.lastIndexOf(".");
                            var AttachUrlA2 = getOriginalFileExtension(AttachUrlA1); //fileExt(.hwp, .ezd, .mht)
                            AttachUrl = encodeURIComponent(GetAttribute(tr,"DATA1"));
                          
                            if (AttachfilenameN1 < 0) {
                                Attachfilename = encodeURIComponent(tr.cells[1].innerText + AttachUrlA2);
                            } else {
                            	if (AttachUrlA2 == ".mht") {
		                            Attachfilename = encodeURIComponent(tr.cells[1].innerText + AttachUrlA2);
	                        	} else {
		                            Attachfilename = encodeURIComponent(tr.cells[1].innerText);
	                        	}
                            }

                            if (AttachUrl != "null") {
                                var tempINGFlag = "";
                                
                                if (pListTypeValue == "9")
                                    tempINGFlag = "TMP"
                                else if (pListTypeValue == "6")
                                    tempINGFlag = "END"
                                else
                                    tempINGFlag = "APR"
                                    
                                /* if (GetAttribute(tr,"data4") == "file") {
                                    window.open(document.location.protocol + "//" + document.location.hostname + "/approvalG/downloadAttach.do?type=APPROVAL&docID=" + GetAttribute(tr, "data3") + "&docStatus=" + tempINGFlag + "&docAttachSn=" + GetAttribute(tr,"data2"));
                                } else {
                                	window.open("/ezApprovalG/downloadAttach.do?fileName=" + Attachfilename + "&filePath=" + AttachUrl, "_self");
                                } */ 
                                
                                //2018-09-12 천성준 - 전자결재 결재문서리스트 하단 첨부탭에서 첨부파일이 문서첨부일경우 문서보기로 열수있게
                                try {
	                                if (GetAttribute(tr,"data4") == strLangCSJ01 || GetAttribute(tr,"data4") == "Document") {
	                                	var tempStr = AttachUrlA1.split("/");
	                                    var docID = tempStr[tempStr.length - 1].replace(AttachUrlA2, '');
	                                    var openLocation;
	                                    
	                                    if (AttachUrlA2 == ".hwp") {
	                                    	if (isIE()) {
	                                    		openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
	                                    	} else {
	                                    		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	                		                	alert(pAlertContent);
	                		                	return;
	                                    	}
	                                    } else {
	                                    	openLocation = "/ezApprovalG/contDocView.do";
	                                    }
	                                    openLocation += "?docID=" + docID + "&docHref=" + AttachUrl + "&formID=&orgDocID=";
	                                    openwindow(openLocation, "", 880, 570);
									} else {
	                                    window.open("/ezApprovalG/downloadAttach.do?fileName=" + Attachfilename + "&filePath=" + AttachUrl, "_self");
	                                }
                                } catch(e) {
                                	console.log(e);
                                }
                            }
                        }
		            	break;
		            case "5" :
		            	openUserInfo();
		            	break;
		            default:
		        }
		    }
		    function btnDraft_onclick() {
		        if (GetBujaeFlag())
		            return;
		        openForm();
		    }
		    var selectedDocIDS = "";
		    function btnApprove_onclick(tempFlag) { // tempFlag -> 0:결재, 1:모두결재, 2:일괄결재
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        if (oArrRows.length > 0) {
		            var pCurSelRow = oArrRows[0];
		            if (tempFlag == "2") {
		                selectedDocIDS = "<DOCIDS>";
		                for (var i = 0; i < oArrRows.length; i++) {
		                    pCurSelRow = oArrRows[i];
		                    if (pCurSelRow.getAttribute("DATA12") != strDocState15 && (pCurSelRow.getAttribute("DATA10") == strAprState2 || pCurSelRow.getAttribute("DATA10") == strAprState5))
		                        selectedDocIDS = selectedDocIDS + "<DOCID>" + pCurSelRow.getAttribute("DATA1") + "</DOCID>";
		                }
		                selectedDocIDS = selectedDocIDS + "</DOCIDS>";
		            }
		            //2018-10-31 배현상, 공유결재자 중복 결재 방지 처리
		            if (tempFlag == 0 || tempFlag == 1) {
		            	//첫번째 문서가 모두결재인 경우에는 결재창을 열지 않도록 변경
						if (checkAprState(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("DATA12"), pCurSelRow.getAttribute("DATA4"), pCurSelRow.getAttribute("APRMEMBERSN"), pCurSelRow.getAttribute("ORGCOMPANYID"))){
							alert("<spring:message code='ezApprovalG.bhs23'/>");
							getDocList();
							return;
						}
                	}
		            openApprovUI(tempFlag);
		        }
		    }
		    function btnUserInfo_onclick() {        
		        if (pDocInfoValue == "1")
		            openUserInfo();
		        else if (pDocInfoValue == "2")
		            OpenReceiptHistory();
		    }
		    function btnViewDoc_onclick() {
		        if (pListTypeValue != "5") {
		            var DocList = new ListView();
		            DocList.LoadFromID("DocList");
		            var oArrRows = DocList.GetSelectedRows();
		            var pCurSelRow = oArrRows[0];
			        orgCompanyID = pCurSelRow.getAttribute("ORGCOMPANYID");
		            if (oArrRows.length > 0)
		                openViewDocInfo();
		            else {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		                //OpenAlertUI(pAlertContent);
		                alert(pAlertContent);
		            }
		        }
		        else {
		            var para = new Array();
		            para[0] = pDocID;
		            para[1] = pURL;
		            var openLocation;
		            var ext = getOriginalFileExtension(pURL);
		            if (ext == "hwp") {
		            	if (isIE()) {
			            	openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
		                } else {
		                	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
		                	alert(pAlertContent);
		                    
		                    return;
		                }
		            } else {
	                    openLocation = "/ezApprovalG/contDocView.do";
		            }
		            openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pURL) + "&listSusin=" + "&orgCompanyID=" + orgCompanyID;
		            openwindow(openLocation, "", 880, 570);
		        }
		    }
		    
		    function btnRedraft_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        
		        var oArrRows = DocList.GetSelectedRows();
		        
		        if (oArrRows.length <= 0) {
		        	var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		        	alert(pAlertContent);
		            return;
		        }
		        
		        /* 2020-08-27 홍승비 -  체크박스로 다중선택된 문서 재기안 시, 가장 상단에 존재하는 반송(004), 회송(015), 회수(006)문서를 선택하도록 수정 */
		        var pFunctionType = "";
		        var pCurSelRow = oArrRows[0];
		        for (var i = 0; i < oArrRows.length; i++) {
		        	pFunctionType = GetAttribute(oArrRows[i], "DATA10");
		        	if (pFunctionType == "004" || pFunctionType == "006" || pFunctionType == "015") {
		        		pCurSelRow = oArrRows[i];
		        		break;
		        	}
		        }
		        
		        if (pCurSelRow.getAttribute("orgcompanyid") != "" && pCurSelRow.getAttribute("orgcompanyid") != companyID) {
		        	var pAlertContent = "<spring:message code='ezApprovalG.csj01'/>";
		        	alert(pAlertContent);
		            return;
		        }
		        
		        if (CheckFormConnFlag(pCurSelRow.getAttribute("DATA1"))) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1726'/>";
		            //OpenAlertUI(pAlertContent);
		            alert(pAlertContent);
		            return;
		        }
		        if (pCurSelRow) {
		            var ret = CheckAprLineInfo(pCurSelRow);
		            if (ret != "OK") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1727'/>" + "\n" +
		                            "<spring:message code='ezApprovalG.t1712'/>" + ret + "<spring:message code='ezApprovalG.t1713'/>";
		                //OpenAlertUI(pAlertContent);
		                alert(pAlertContent);
		                return;
		            }
		        }
		        
		        if ((pListTypeValue == "1" || pListTypeValue == "11") && checkAprState(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("DATA12"), pCurSelRow.getAttribute("DATA4"), pCurSelRow.getAttribute("APRMEMBERSN"), pCurSelRow.getAttribute("ORGCOMPANYID"))){
		        	alert("<spring:message code='ezApprovalG.bhs23'/>");
					getDocList();
					return;
				}
		        
		        formURL = pCurSelRow.getAttribute("DATA3");
		        var docState = pCurSelRow.getAttribute("DATA12");
		        if (docState == "012" || docState == "014" || docState == "018") {
		            OpenReceiveDraftUI(pCurSelRow, "REDRAFT");
		        }
		        else if (docState == "011") {
		            OpenReceiveENDDraftUI(pCurSelRow, "REDRAFT");
		        }
		        else {
		            var FunctionType = pCurSelRow.getAttribute("DATA10");
		            var Html = pCurSelRow.getAttribute("DATA3");
		
		            var Html1 = getOriginalFileExtension(Html);
		
		            if (Html1 == "hwp") {
		                if (FunctionType == "000")                   //한글양식 미결 문서
		                    openServerDraftUI("REDRAFT", pCurSelRow);
		                else
		                    openDraftUI("REDRAFT", pCurSelRow);
		            }
		
		                //[한양대]2011.11.17 임시저장
		                //서버 저장문서 open하기.
		            else {
		                if (FunctionType == "000")                   //미결 문서
		                    openServerDraftUI("REDRAFT", pCurSelRow);
		                else
		                    openDraftUI("REDRAFT", pCurSelRow);
		            }
		        }
		    }
		    
		    function btnRemoveDoc_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		
		        var oArrRows = DocList.GetSelectedRows();
		        if (oArrRows == 0) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		            //OpenAlertUI(pAlertContent);
		            alert(pAlertContent);
		            return;
		        }
		        
		        /* 2020-08-27 홍승비 - 체크박스로 다중선택된 반송(004), 회송(015), 회수(006)문서의 다중삭제가 가능하도록 수정 */
		        var Ans = confirm("<spring:message code='ezApprovalG.t1728'/>");
		        if (Ans) {
		        	var pCurSelRow = "";
		        	var pFunctionType = "";
					var pDocState = "";
		        	 
		        	for (var i = 0; i < oArrRows.length; i++) {
		        		pCurSelRow = oArrRows[i];
		        		pFunctionType = GetAttribute(pCurSelRow, "DATA10"); // DATA10 = APRSTATE(FUNCTIONTYPE)
		        		pDocState = GetAttribute(pCurSelRow, "DATA12"); // DATA9 = 수신문 관련 플래그, DATA12 = DOCSTATE
		        		
		        		// 내부결재가 아닌 수신문(011), 합의문(012)의 경우 삭제 불가능, 재기안만 가능함 + 임시보관함의 경우 전부 삭제 가능
		        		// 부서수신함(pListTypeValue == "4")의 경우, 회송된 수신문과 합의문 모두 삭제 가능함 (G버전은 부서수신함에서 회송 시 상태만 변하고 문서는 리스트 상에 남아있음)
				        if ((pListTypeValue == "21") ||
				        		((pFunctionType == "004" || pFunctionType == "006" || pFunctionType == "015") && ((pListTypeValue == "4") || (GetAttribute(pCurSelRow, "DATA9") == "0" && pDocState != "011" && pDocState != "012")))) {
					        if (pListTypeValue == "1" || pListTypeValue == "11" || pListTypeValue == "2") {
								if (checkAprState(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("DATA12"), pCurSelRow.getAttribute("DATA4"), pCurSelRow.getAttribute("APRMEMBERSN"), pCurSelRow.getAttribute("ORGCOMPANYID"))){
									alert("<spring:message code='ezApprovalG.bhs23'/>");
									getDocList();
									return;
								}
							}
					        
				            if (pListTypeValue == "21") {  //[한양대] 추가 사항 (서버 임시저장하기)
				                RemoveTmpDoc(pCurSelRow.getAttribute("DATA1"));
				            } else {
				                RemoveDoc(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("orgcompanyid"));
				            }
				        }
		        	}
		            
		            if (pListTypeValue == "4") {
		                getReceivedDocList();
		            } else if (pListTypeValue == "6") {
		                getSimsaDocList();
		            } else {
		                getDocList();
		            }
		            
		            parent.frames["left"].getAprCount();
		        }
		    }
		    function btnAssign_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        var pCurSelRow = oArrRows[0];
		        if (pCurSelRow.length != 0)
		            OpenReceiveAssignUI(pCurSelRow);
		    }
		    function btnReceipt_onclick() {
		        var DocList = new ListView();
		        var ua = navigator.userAgent;
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        
		        if (oArrRows.length > 0) {
		            var pCurSelRow = oArrRows[0];
		            
		            if (pListTypeValue == "7") {
		                var pDocID = pCurSelRow.getAttribute("DATA1");
		                var pURL = pCurSelRow.getAttribute("DATA3");
		                var openLocation = "";
		                var ext = getOriginalFileExtension(pURL);
		                
		                if (ext == "doc") {
		                    openLocation = "/myoffice/ezApprovalG/ezViewWord/ezConvOut_word_Cross.aspx?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pURL);
		                } else if (ext == "hwp") { // 2018.07.26 (KLIB) - ezd 확장자 처리
		                    if (CrossYN() && !(/netscape/i.test(navigator.appName) && /trident/i.test(navigator.userAgent) || /msie/i.test(navigator.userAgent))) {
		                        alert(strLang1103);
		                        return;
		                    } else {
// 		                        openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezConvOut_HWP.aspx?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pURL);
		                        openLocation = "/ezApprovalG/ezConvOutHWP.do?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pURL);
		                    }
		                } else {
		                    /* if (CrossYN()) {
		                        openLocation = "/myoffice/ezApprovalG/enforce/ezConvOut_Cross.aspx?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pURL);
		                    } else {
	                            openLocation = "/myoffice/ezApprovalG/enforce/ezConvOut.aspx?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pURL);
		                    } */
		                    
		                	openLocation = "/ezApprovalG/ezConvOut.do?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pURL);
		                }
		                
		                openwindow(openLocation, "enforce", 880, 550);
		            } else {
		                if (pSusinManagerFlag == "admin" || pCurSelRow.getAttribute("DATA8") == pUserID) {
		                    var pDraftFlag;
		                    
		                    if (pCurSelRow.getAttribute("DATA9") == strDocState11) {
		                        pDraftFlag = "SUSIN";
		                    } else if (pCurSelRow.getAttribute("DATA9") == strDocState12 || pCurSelRow.getAttribute("DATA9") == strDocState2) {
		                        pDraftFlag = "HAPYUI";
		                    }
		                    
		                    OpenReceiveDraftUI(pCurSelRow, pDraftFlag);
		                } else {
		                    var pAlertContent = "<spring:message code='ezApprovalG.t1730'/>";
		                    //OpenAlertUI(pAlertContent);
		                    alert(pAlertContent);
		                }
		            }
		        } else {
		        	var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		        	alert(pAlertContent);
		            return;
		        }
		    }
		    
		    function btnDistribute_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        var pCurSelRow = oArrRows[0];
		        if (pCurSelRow.length != 0)
		            OpenReceiveDistributeUI(pCurSelRow);
		    }
		    var g_selReturn = "N";
		    function btnReturn_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        
		        if (approvalFlag == "G") {
			        if (oArrRows.length > 0) {
			        	if (checkNonElecRec(oArrRows[0].getAttribute("DATA7"))) {
			        		alert("비전자문서는 회송이 불가능 합니다.");
			        		return;
			        		/* if (confirm("삭제 하시겠습니까 ?")) {
			        			RemoveSusinNonElecRecDoc(oArrRows[0].getAttribute("DATA1"));
			        		} else {
				        		return;
			        		} */
			        	} else {
				            var pCurSelRow = oArrRows[0];
				            if (pCurSelRow.cells.length >= 7) {
				                if (pCurSelRow.cells[6].innerHTML == "<spring:message code='ezApprovalG.t1731'/>") {
				                    var pAlertContent = "<spring:message code='ezApprovalG.t1732'/>";
				                    //OpenAlertUI(pAlertContent);
				                    alert(pAlertContent);
				                    return;
				                }
				            }
				            if (pListTypeValue == "1" || pListTypeValue == "11") {
				                g_selReturn = "Y";
				                OpenReceiveENDDraftUI(pCurSelRow, "REDRAFT");
				            }
				            else
				                //OpenOpinionUI(pCurSelRow, "HeSong");
				            	openOpinionUI_New(pCurSelRow, "HeSong");
					        }
			        	}
			    } else {
			    	if (oArrRows != 0) {
		                var pCurSelRow = oArrRows[0];
		                if (checkAprState(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("DATA12"), pCurSelRow.getAttribute("DATA4"), pCurSelRow.getAttribute("APRMEMBERSN"),pCurSelRow.getAttribute("ORGCOMPANYID"))){
							alert("<spring:message code='ezApprovalG.bhs23'/>");
							getDocList();
							return;
	                	}
		                //OpenOpinionUI(pCurSelRow, "HeSong");
		                openOpinionUI_New(pCurSelRow, "HeSong");
		            }
			    }
		    }
		    var DocID_Complete;
		    function btncallback_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        var pMsg;
		        if (oArrRows.length != 0) {
		            var pCurSelRow = oArrRows[0];
		            var DocID = pCurSelRow.getAttribute("DATA1");
		            DocID_Complete = DocID;
		            orgCompanyID = pCurSelRow.getAttribute("orgCompanyID");
		            if (pListTypeValue == "3") {
		                var pMsg = "<spring:message code='ezApprovalG.t67'/>";
		                var Ans = OpenInformationUI(pMsg, btncallback_onclick_Complete, "open");
		            } else {
		                var pMsg = "<spring:message code='ezApprovalG.t68'/>";
		                var Ans = OpenInformationUI(pMsg, btncallback_onclick_Complete, "open");
		            }
		            
		            if (Ans) {
		            	btncallback_onclick_Complete(true);
		            }
		        }
		    }
		    function btncallback_onclick_Complete(Ans) {
		        if (Ans) {
		            doCancel(DocID_Complete, pListTypeValue);
		        }
		    }
		
		    var tempDocID;
		    function btnforcecallback_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        var pMsg;
		        if (oArrRows.length != 0) {
		            var pCurSelRow = oArrRows[0];
		            var DocID = pCurSelRow.getAttribute("DATA1");
					
		            //2018-07-10 배현상, btnforcecallback_onclick 수정 (강제회수)
		            tempDocID = DocID;
		            
		            if (pListTypeValue == "3") {
		                var pMsg = "<spring:message code='ezApprovalG.t67'/>";
		                var Ans = OpenInformationUI(pMsg, btnforcecallback_onclick_Complete, "open");
		            }
		            else {
		                var pMsg = "<spring:message code='ezApprovalG.t68'/>";
		                var Ans = OpenInformationUI(pMsg, btnforcecallback_onclick_Complete, "open");
		            }
		        }
		    }
		
		    function btnforcecallback_onclick_Complete(Ans) {
		        if (Ans) {
		            doCancelForce(tempDocID, pListTypeValue);
		        }
		    }
		
		    function doCancelForce(pDocID, tempListType) {
				var GetCurrentlinelist = getAprLinefor("APR", tempDocID);
				var result = "";
				
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : false,
	        		url : "/ezApprovalG/doCancelForce.do",
	        		data : {
	        			docID : pDocID,
	        			userID : pUserID
	        		},
	        		success: function(xml){
	        			result = xml;
	        		}, error: function () {
    	                var pAlertContent = strLang898;
    	                OpenAlertUI(pAlertContent);
    	            }
	        	});
		        
	        	//2018-07-10 배현상, OpenAlertUI에서 브라우저alert으로 변경 및 로직 수정
	        	var RtnVal = getNodeText(loadXMLString(result).documentElement);
	        	
		        if (RtnVal == "TRUE") {
		        	SendMailToCancel_Function(GetCurrentlinelist);
		            if (tempListType == "3") {
		                var pAlertContent = strLang891 + "\n" + strLang892;
		                alert(pAlertContent);
		            }
		            else {
		                var pAlertContent = strLang893 + "\n" + strLang894;
		                alert(pAlertContent);
		            }
		            getDocList();
		            attitude_annual_conn(pDocID);
		
		            try {
		                parent.frames["left"].getAprCount();
		            }
		            catch (e) { }
		        }
		        else if (RtnVal == "ERR01") {
		            var pAlertContent = strLang895;
		            alert(pAlertContent);
		        }
		        else if (RtnVal == "ERR02") {
		            var pAlertContent = strLang896;
		            alert(pAlertContent);
		        }
		        else if (RtnVal == "ERR03") {
		            var pAlertContent = strLang897;
		            alert(pAlertContent);
		        }else {
	            	var pAlertContent = strLang898;
	                alert(pAlertContent);
	            }
		    }
		    
		    function SendMailToCancel_Function(GetCurrentlinelist) {
	            var MemberList = loadXMLString(GetCurrentlinelist)
	            var pDocTitle = GetDocTitleInfoData("APR", "DOCTITLE");
	            var objNodes = SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW");
	            var pDraftDate = GetDocInfoData("APR", "STARTDATE"); // 메일 발송 시 회수일시가 아닌 기안일시를 사용
	            g_szUserID = pUserID;
	            g_senderinfo = "";
	            
	            for (i = 0; i < objNodes.length; i++) {
	                var nowstate = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW")[i])[0])[12]);
	                var LineUserID = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW")[i])[0])[4]);
	                var LineSN = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW")[i])[0])[0]);
	                if (nowstate == "002" || nowstate == "003") {
	                    if (LineSN != "1") {
	                        sendmail(LineUserID, pDocTitle, arr_userinfo[2], pDraftDate, "callback", "", true)
	                    }
	                }

	            }
	        }
	        function GetDocTitleInfoData(mode, filed) {
	            try {
	                var value = "";
	                var xmlpara = createXmlDom();
	                var objNode;
	                
	                createNodeInsert(xmlpara, objNode, "PARAMETER");
	                createNodeAndInsertText(xmlpara, objNode, "DocID", tempDocID);
	                createNodeAndInsertText(xmlpara, objNode, "mode", mode);
	                createNodeAndInsertText(xmlpara, objNode, "fields", filed);

	                var xmlhttp = createXMLHttpRequest();
	                xmlhttp.open("Post", "/ezApprovalG/GetDocInfoMode.do", false);
	                xmlhttp.send(xmlpara);

	                var xmlDocument = createXmlDom();
	                xmlDocument = loadXMLString(xmlhttp.responseText);

	                var objNodes = GetChildNodes(xmlDocument.documentElement);

	                if (objNodes) {
	                    if (objNodes.length > 0) {
	                        value = getNodeText(objNodes[0]);
	                    }
	                }
	                return value;
	            }
	            catch (e) { }
	        }
	        
	        function js_yyyy_mm_dd_hh_mm_ss() {
	            now = new Date();
	            year = "" + now.getFullYear();
	            month = "" + (now.getMonth() + 1); if (month.length == 1) { month = "0" + month; }
	            day = "" + now.getDate(); if (day.length == 1) { day = "0" + day; }
	            hour = "" + now.getHours(); if (hour.length == 1) { hour = "0" + hour; }
	            minute = "" + now.getMinutes(); if (minute.length == 1) { minute = "0" + minute; }
	            second = "" + now.getSeconds(); if (second.length == 1) { second = "0" + second; }
	            return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second;
	        }
		    
		    function Recipent_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        if (oArrRows.length > 0) {
		            var tr = oArrRows[0];
		
		            if (pListTypeValue != "5")
		                getAprDocAproveInfo(tr);
		            else
		                getDataInfo("2");
		
		            setbuttonenable();
		        }
		    }
		    function Approval_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        if (oArrRows.length > 0) {
		            var tr = oArrRows[0];
		
		            if (pListTypeValue != "5")
		                getAprLine(tr);
		            else
		                getDataInfo("1");
		            setbuttonenable();
		        }
		    }
		    function Opinion_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        if (oArrRows.length > 0) {
		            var tr = oArrRows[0];
		
		            if (pListTypeValue != "5")
		                getAprDocAproveInfo(tr);
		            else
		                getDataInfo("4");
		            setbuttonenable();
		        }
		    }
		    function Circulation_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        if (oArrRows.length > 0) {
		            var tr = oArrRows[0];
		
		            if (pListTypeValue != "5")
		                getAprDocAproveInfo(tr);
		            else
		                getDataInfo("5");
		            setbuttonenable();
		        }
		    }
		    function Attach_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		
		        if (oArrRows.length > 0) {
		            var tr = oArrRows[0];
		
		            if (pListTypeValue != "5")
		                getAprDocAproveInfo(tr);
		            else
		                getDataInfo("3");
		            setbuttonenable();
		        }
		    }
		
		    function MM_swapImage(nSel) {
		        if (nSel != g_tagSelect) {
		            g_tagSelect = nSel;
		            var Element = window.event.srcElement;
		            Element.src = "/images/tab_ez0" + nSel + ".gif";
		            var i;
		            for (i = 1 ; i <= 4; i++) {
		                if (g_tagSelect != i) {
		                    var str = "tag" + i + ".src" + "=" + "\"/images/tab_ez0" + i + "o.gif\"";
		                    eval(str);
		                }
		            }
		            if (nSel != 6) {
		                var str = "tag6.src" + "=" + "\"/images/tab_ez06o.gif\"";
		                eval(str);
		            }
		        }
		    }
		    function MM_swapImagesub(nSel, e) {
		        if (nSel != g_tagSelectsub) {
		            g_tagSelectsub = nSel;
		
		            var Event = e ? e : window.event;
		            var Element = Event.target ? Event.target : Event.srcElement;
		
		            Element.src = "/images/tab_appsub" + nSel + ".gif";
		
		            var i;
		            for (i = 1 ; i <= 4; i++) {
		                if (g_tagSelectsub != i) {
		                    var str = "tagsub" + i + ".src" + "=" + "\"/images/tab_appsub" + i + "a.gif\"";
		
		                    eval(str);
		                }
		            }
		        }
		    }
		    function passValLeftMenu(strVal) {
		        pageNum = 1;
		        SQLPARADATA = "";
		        //2018-10-11 배현상, 검색조건인 SearchCont 초기화 작업이 미처리되있어 상단에 다른탭에서 검색한 날짜가 적용되있는 오류 수정
		        SearchCond = new Array();
		        pListTypeValue = strVal;
		        window.parent.frames["left"].pListTypeValue = strVal;
		        if (pListTypeValue == "7")
		            SendOutFlag = "O";
		        else if (pListTypeValue == "8")
		            SendOutFlag = "S";
		        else if (pListTypeValue == "9")
		            SendOutFlag = "SS";
		        
				/* 2020-06-18 홍승비 - 임시보관함으로 진입한 경우, 우측 상단 간단검색메뉴에서 기안자 제거 (G버전은 window_onload 분기를 타지 않으므로, 검색조건 초기화 작업과 함께 적용) */
				var selectWriter = $("#selectType").find("option[value='rad_Writer']");
				if (pListTypeValue == "21") { // 임시보관함의 경우, 기안자 검색조건 제거
					if (selectWriter.length > 0) {
						selectWriter.remove();
					}
				} else { // 그 외의 경우, 다시 기안자 검색조건을 어팬드
					if (selectWriter.length <= 0) {
						$("#selectType").append('<option value="rad_Writer"><spring:message code="ezApprovalG.t445"/></option>');
					}
				}
				
		    }
		    
		    function Search_onclick() {
		        window.open("./ReceivUI/Receive_Search.aspx", "_self", "");
		    }
		    function btnAddJob_onclick() {
		        var parameter = "";
		        var url = "ezDocInfo/ezSubTitle_Cross.aspx?id=" + encodeURI(pUserID);
		        var feature = "status:no;dialogWidth:270px;dialogHeight:250px;help:no;scroll:no;edge:sunken";
		        feature = feature + GetShowModalPosition(270, 250);
		        var RtnVal = window.showModalDialog(url, parameter, feature);
		        if (RtnVal[0] == "OK") {
		            arr_userinfo[4] = RtnVal[1];
		            arr_userinfo[5] = RtnVal[2];
		            arr_userinfo[3] = RtnVal[3];
		            arr_userinfo[13] = RtnVal[6];
		            arr_userinfo[14] = RtnVal[7];
		            arr_userinfo[15] = RtnVal[4];
		            arr_userinfo[16] = RtnVal[5];
		            DeptID = RtnVal[1];
		            ChangeCookies();
		            if (pListTypeValue == "7" || pListTypeValue == "8" || pListTypeValue == "9")
		                pListTypeValue = "1";
		            window.parent.frames["left"].document.location.href = "/myoffice/ezApprovalG/left_approval_Cross.aspx?listType=" + pListTypeValue;
		        }
		    }
		    function ChangeCookies() {
	            $.ajax({
	        		type : "POST",
	        		async : false,
	        		url : "/ezApprovalG/ChangeUserInfo.do",
	        		data : {
	        				deptID : arr_userinfo[4],
	        				deptName  : arr_userinfo[5],
	        				deptName2 : arr_userinfo[14],
	        				position  : arr_userinfo[3],
	        				position2 : arr_userinfo[16],
			        		companyID : companyID,
		    				companyName : "<c:out value = '${userInfo.companyName}'/>",
		    				companyName2 : "<c:out value = '${userInfo.companyName2}'/>"
	        				},
	        		success: function(xml){
	        		}        			
	        	});
		    }
		    function btnSimsa_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        var tr = oArrRows[0];
		        if (oArrRows.length == 0) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		            //OpenAlertUI(pAlertContent);
		            alert(pAlertContent);
		            return;
		        }
		        if (tr) {
		            var ret = CheckAprLineInfo(tr);
		            if (ret != "OK") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1727'/>" + "\n" +
		                            "<spring:message code='ezApprovalG.t1712'/>" + ret + "<spring:message code='ezApprovalG.t1713'/>";
		                //OpenAlertUI(pAlertContent);
		                alert(pAlertContent);
		                return;
		            }
		        }
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var heigth = heigth - 50;
		        var width = width/2;
		        var left = width/2;
		        var top = 0;
		        var pDocID = tr.getAttribute("DATA1");
		        var pOrgDocID = tr.getAttribute("DATA7");
		        var pHref = tr.getAttribute("DATA3");
		        var openLocation;
		        var pOrgCompanyID = tr.getAttribute("ORGCOMPANYID");
		        var pDocTitle = tr.firstChild.textContent;
		        
		        var pHrefExt = getOriginalFileExtension(pHref);
		        
		        if (pHrefExt === "hwp") {
		            if (/msie/i.test(navigator.userAgent)) {
		                alert(strLang1103);
		                return;
		            } else if (!isIE()) {
						alert("한글양식은 IE에서만 발송할 수 있습니다.");
						return;
		            } else {
		                openLocation = "/ezApprovalG/ezSimsaG_HWP.do";
		            }
		        } else {
	                openLocation = "/ezApprovalG/ezSimsaG.do";
		        }
		        openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pHref) + "&orgDocID=" + encodeURI(pOrgDocID) + 
		        		"&orgCompanyID=" + encodeURI(pOrgCompanyID) + "&docTitle=" + encodeURI(pDocTitle);
		        var param = "status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left;
		        window.open(openLocation, "enforce", param);
		    }
		    
		    window.onbeforeunload = function () {
		        try {
		            hideProgress();
		        } catch (e) { }
		    };
		    
		    function goToPage(page) {
		        if (page == "front") {
		            if (parseInt(pageNum) - 1 < 1) {
		                return;
		            }
		            pageNum = pageNum - 1;
		            openergetDocInfo();
		        } else if (page == "next") {
		            if (parseInt(pageNum) + 1 > parseInt(totalPages))
		                return;
		            pageNum = pageNum + 1;
		            openergetDocInfo();
		        } else if (page == "page") {
		            if (event.keyCode == 13) {
		                var goPage = document.all.txt_PageInputNum.value;
		                if (parseInt(goPage) != goPage || parseInt(goPage) == "" || parseInt(goPage) < 1 || parseInt(goPage) > parseInt(totalPages)) {
		                    return;
		                }
		                pageNum = parseInt(goPage);
		                openergetDocInfo();
		            }
		        }
		    }
		    
		    function btnAddCabinet_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        if (oArrRows.length > 0) {
		            var tr = oArrRows[0];
		            
		            //현재부서정보와 대장등록할 문서의 부서정보가 다르면 리턴 (겸직변경)
		            //결재할문서(1)과 부서수신함(4)의 부서아이디 DATA가 달라서 변경 
					if (pListTypeValue == "1") {
			            if (arr_userinfo[4] != tr.getAttribute("DATA7")) {
			            	alert("'" + tr.getAttribute("DATA7") + "'부서의 문서입니다. \n'" + tr.getAttribute("DATA7") + "'부서로 겸직변경 후 대장등록해주시기 바랍니다.");
			            	return;
			            }
					} else if (pListTypeValue == "4") {
			            if (arr_userinfo[4] != tr.getAttribute("DATA6")) {
			            	alert("'" + tr.getAttribute("DATA6") + "'부서의 문서입니다. \n'" + tr.getAttribute("DATA6") + "'부서로 겸직변경 후 대장등록해주시기 바랍니다.");
			            	return;
			            }
					}
		            
		            var ret = CheckAprLineInfo(tr);
		            if (ret != "OK") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1727'/>" + "\n" +
		                            "<spring:message code='ezApprovalG.t1712'/>" + ret + "<spring:message code='ezApprovalG.t1713'/>";
		                //OpenAlertUI(pAlertContent);
		                alert(pAlertContent);
		                return;
		            }
		            if (tr.getAttribute("DATA10") == "015") {
		                var pInformationContent = "<spring:message code='ezApprovalG.t1733'/>";
		                var Ans = OpenInformationUI(pInformationContent, btnAddCabinet_onclick_Complete, "OPEN");
		                if (Ans) {
		                    RemoveDocCabinet(tr.getAttribute("DATA1"), "Y");
// 		                    openergetDocInfo();
		                }
		            }
		            else {
		                var pInformationContent = "<spring:message code='ezApprovalG.t1734'/>";
		                var Ans = OpenInformationUI(pInformationContent, btnAddCabinet_onclick_Complete, "OPEN");
		                if (Ans) {
		                    RemoveDocCabinet(tr.getAttribute("DATA1"), "");
// 		                    openergetDocInfo();
		                }
		            }
		        }
		        else {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		            //OpenAlertUI(pAlertContent);
		            alert(pAlertContent);
		            return;
		        }
		    }
		    function btnAddCabinet_onclick_Complete(Ans) {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        var tr = oArrRows[0];
		        if (tr.getAttribute("DATA10") == "015") {
		        	if (Ans) {
		            	//2019-02-18 기안원문서철과 비교해서 다르면 다시 세팅
		            	//2019-03-11 위의 주석내용 삭제 후 철정보 다시 세팅하도록 수정
						var para = new Array();
				        var url = "/ezApprovalG/selectCabinet.do?initFlag=1&hesongFlag=Y&docId=" + tr.getAttribute("DATA1");
				
				        selectcabinet_cross_dialogArguments[0] = para;
				        selectcabinet_cross_dialogArguments[1] = RemoveDocCabinet;
				
				        var OpenWin = window.open(url, "selectCabinet", GetOpenWindowfeature(1000, 620));
				        try { OpenWin.focus(); } catch (e) { }
		                openergetDocInfo();
		            }
		        }
		        else {
		            if (Ans) {
						var para = new Array();
				        var url = "/ezApprovalG/selectCabinet.do?initFlag=1&docId=" + tr.getAttribute("DATA1");
				
				        selectcabinet_cross_dialogArguments[0] = para;
				        selectcabinet_cross_dialogArguments[1] = RemoveDocCabinet;
				
				        var OpenWin = window.open(url, "selectCabinet", GetOpenWindowfeature(1000, 620));
				        try { OpenWin.focus(); } catch (e) { }

		                openergetDocInfo();
		            }
		        }
		    }
		    function btnLinkDraft_onclick() {
		        btnRedraft_onclick();
		    }
		    function GongRamDocInfo() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        if (oArrRows.length > 0) {
		            var tr = oArrRows[0];
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		            var left = (parseInt(width) - 1155) / 2;
		            var top = (parseInt(heigth) - 460) / 2;
		            window.open("/ezApprovalG/ezLineInfo.do?docID=" + tr.getAttribute("DATA1") + "&deptID=&docState=015", "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		        }
		    }
		    function GetBujaeFlag() {
		        var BString = arr_userinfo[7];
		        if (BString != "") {
		            var BDim = new Array("");
		            BDim = BString.split(":");
		            var tmpStartDate = (BDim[3] + ":" + BDim[4]).substring(0, 16);
		            var tmpEndDate = (BDim[5] + ":" + BDim[6]).substring(0, 16);
					
		            if (tmpStartDate <= "<c:out value = '${nowDate}'/>" && tmpEndDate >= "<c:out value = '${nowDate}'/>") {
		                return true;
		            } else if(tmpStartDate < "<c:out value = '${nowDate}'/>" && tmpEndDate < "<c:out value = '${nowDate}'/>"){
		            	setBujaeOff();
				        return false;
		            }
		        } else if (proxyInfo != null && proxyInfo != "") {
		        	var strDate = "<c:out value = '${proxyInfo.startDate}'/>";
		        	var endDate = "<c:out value = '${proxyInfo.endDate}'/>";
		            if (strDate <= "<c:out value = '${nowDate}'/>" && endDate >= "<c:out value = '${nowDate}'/>") {
		                return true;
		            }else if(strDate < "<c:out value = '${nowDate}'/>" && endDate < "<c:out value = '${nowDate}'/>"){
		            	setBujaeOff();
				        return false;
		            }
		        }
		        return false;
		    }
		    function setpause(numberMillis) {
		        var now = new Date();
		        var exitTime = now.getTime() + numberMillis;
		        while (true) {
		            now = new Date();
		            if (now.getTime() > exitTime)
		                return;
		        }
			}

			//2020-04-29 : 일괄결재 리스트 직접결재
			function btnApproveALL_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var pCurSelRow = DocList.GetSelectedRows();
		        if (pCurSelRow.length == 0) {
		            var pAlertContent = strLang930 + "<br>" + strLang336;
		            OpenAlertUI(pAlertContent);
		            return;
				}else{
					OpenInformationUI("<spring:message code='ezApprovalG.t900002'/>" + "<br><spring:message code='ezApprovalG.kbh03'/>", btnApproveALL_onclick_Complete);
				}
			}

			function btnApproveALL_onclick_Complete(rtn){
				DivPopUpHidden();
				if(rtn){
					var aprAllType = document.getElementById("btnApproveALL").getAttribute("aprAllType");

					if(aprAllType == "LIST"){
						if (CheckUsePassword()) {
							chk_Passwd(arr_userinfo[1]);
							return;
						}
						else {
							chk_Passwd_Complete("TRUE");
						}
					}else{
						btnApproveALL_popup_onclick()
					}					
				}
			}

			//2020-04-29 : 일괄결재 , 기존 팝업결재
		    function btnApproveALL_popup_onclick() {
		        var xmlpara = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "PLISTTYPENAME", pListTypeValue);
		        createNodeAndInsertText(xmlpara, objNode, "PDOCTYPENAME", pDocTypeValue);
		        createNodeAndInsertText(xmlpara, objNode, "PUSERID", pUserID);
		        createNodeAndInsertText(xmlpara, objNode, "PUSERDEPTID", arr_userinfo[4]);
		        createNodeAndInsertText(xmlpara, objNode, "PPAGESIZE", pageSize);
		        createNodeAndInsertText(xmlpara, objNode, "PPAGENUM", pageNum);
		        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", companyID);
		        createNodeAndInsertText(xmlpara, objNode, "ORDERCELL", OrderCell);
		        createNodeAndInsertText(xmlpara, objNode, "ORDEROPTION", OrderOption);
		        createNodeAndInsertText(xmlpara, objNode, "SEARCHQUERY", SQLPARADATA);
		        createNodeAndInsertText(xmlpara, objNode, "APPROVALFLAG", approvalFlag);
		        
		        var searchCompanyID = $("#selectCompany option:selected").val();
		        if(searchCompanyID == undefined) {
		        	searchCompanyID = "";
		        }
		        createNodeAndInsertText(xmlpara, objNode, "searchCompanyID", searchCompanyID);

		        var wWeigth = 700;
		        var wHeigth = 480;
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = 0;
		        var top = 0;
		        left = (parseInt(width) - parseInt(wWeigth)) / 2;
		        top = (parseInt(heigth) - parseInt(wHeigth)) / 2;
		        var pop = window.open("", "POP", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeigth + ",width=" + wWeigth + ",top=" + top + ",left =" + left);
		        formAPP.APPXML.value = getXmlString(xmlpara);
		        formAPP.method = "post";
		        formAPP.action = "/ezApprovalG/doApprovAllselect.do";
		        formAPP.target = "POP";
		        formAPP.submit();
		    }
		    function ALLapproval_afterCall() {
		        parent.frames["left"].getAprCount();
		        getDocList();
		    }
		    function btnSecondApproval() {
		        var wWeigth = 400;
		        var wHeigth = 300;
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = 0;
		        var top = 0;
		        left = (parseInt(width) - parseInt(wWeigth)) / 2;
		        top = (parseInt(heigth) - parseInt(wHeigth)) / 2;
		        window.open("secondApprovalInfo.do", '', "status=0,menubar=0,scrollbars=1,resizable=1,height=220,width=468,top=" + top + ",left =" + left);
		    }
		    function TextReplace(pStr, pStr1, pStr2) {
		        TextReplace = pStr.replace(pStr1, pStr2);
		        return;
		    }
		    function TotalSave_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        
		        var tr = DocList.GetSelectedRows();
		        if (tr.length == 0) {
					var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
					alert(pAlertContent);
		            return;
		        }
		        
	            pDocID = tr[0].getAttribute("DATA1");
	            orgCompanyID = tr[0].getAttribute("orgCompanyID");
		        
	            if (orgCompanyID == null)
	            	orgCompanyID = companyID;
	            
		        var mode = getDocMode(pDocID, orgCompanyID);
				var url = "totalSaveFileInfo.do?docID=" + pDocID + "&type=" + mode + "&orgCompanyID=" + orgCompanyID;
		        var feature = "status=no,help=no,scroll=no,edge=sunken,width=580px,height=480px";
		        
		        feature = feature + GetOpenPosition(580, 480);
		        window.open(url, "", feature);
		    }
		    function getDocMode(pDocID, pOrgCompanyID) {
		    	var rtnVal = "APR";
		    	try {
		    		$.ajax({
		     			type : "POST",
		     			dataType : "text",
		     			async : false,
		     			url : "/ezApprovalG/getLineMode.do",
		     			data : {
		     					docID : pDocID,
		     					orgCompanyID : pOrgCompanyID
		     					},
		     			success: function(result) {
		     				rtnVal = result;
		     			}
		            });
		    	} catch (e) {
		    		alert("getDocMode() :: " + e.description);
		    	}
		    	
		    	return rtnVal;
		    }
		
		    var setsearchinfo_cross_dialogArguments = new Array();
		    var OpenWin2;
		    function SearchCondi_onclick() {
		        var para;
		        setsearchinfo_cross_dialogArguments[0] = para;
		        setsearchinfo_cross_dialogArguments[1] = SearchCondi_onclick_Complete;
		        var type = "APR";
		        OpenWin2 = window.open("/ezApprovalG/setSearchInfo.do?type=" + type+ "&searchType="+pListTypeValue, "setsearchInfo_Cross", GetOpenWindowfeature(510, 405));
		        try { OpenWin2.focus(); } catch (e) { }
		    }
		
		    var SearchCond = new Array();

		    var SQLPARADATA;
		    function SearchCondi_onclick_Complete(returnvalue) {
		        condition = returnvalue;
		        if (condition) {
		        	for (var i = 0; i < condition.length; i++) {
		                if (condition[i] == null)
		                    condition[i] = "";
		                condition[i] = replaceCond(condition[i]);
		                SearchCond[i] = condition[i];
		            }
		            pageNum = 1;
		            MakeSubCondition();
		            if (pListTypeValue == "1") {
		                getDocList();
		            }
		            else if (pListTypeValue == "2") {
		                getDocList();
		            }
		            else if (pListTypeValue == "3") {
		                getDocList();
		            }
		            else if (pListTypeValue == "4") {
		                getReceivedDocList();
		            }
		            else if (pListTypeValue == "6") {
		                getSimsaDocList();
		            }
		            else if (pListTypeValue == "7") {
		                SendOutFlag = "O";
		                getSendOutDocList();
		            }
		            else if (pListTypeValue == "8") {
		                SendOutFlag = "S";
		                getSendOutDocList();
		            }
		            else if (pListTypeValue == "9") {
		                SendOutFlag = "SS";
		                getSendOutDocList();
		            }
		            else if (pListTypeValue == "10") {
		                getDocList();
		            }
		            else if (pListTypeValue == "21") {
		                getDocList();
		            }
		            else if (pListTypeValue == "11") {
		            	getDocList();
		            }
		            else {
		                getDocList();
		            }
		        }
		        $('#sel_year').val("ALL");
		        /* $('#sel_year').selectmenu('refresh'); */
		    }
		    var SearchFlag = false;
		    function MakeSubCondition() {
		        SearchFlag = true;
		        var TYPE = "";
		        var DATA = "";
				if (approvalFlag =='G') {
			        if (SearchCond[0] != "")		// DocNumber
			        {
			            TYPE += "DOCNO;";
			            DATA += "<DOCNO>" + SearchCond[0] + "</DOCNO>";
			        }
			
			        if (SearchCond[1] != "")		// DocTitle
			        {
			            TYPE += "DOCTITLE;";
			            DATA += "<DOCTITLE>" + SearchCond[1] + "</DOCTITLE>";
			        }
			
			        if (SearchCond[2] != "")		// DrafterName
			        {
			            TYPE += "WRITERNAME;";
			            DATA += "<WRITERNAME>" + SearchCond[2] + "</WRITERNAME>";
			        }
			
			        if (SearchCond[3] != "" && SearchCond[4] != "" && SearchCond[5] != "")		// APRSTARTDATE
			        {
			            TYPE += "APRSTARTDATE;";
			            DATA += "<APRSTARTDATE>" + SearchCond[3] + "-" + SearchCond[4] + "-" + SearchCond[5] + "</APRSTARTDATE>";
			        }
			
			        if (SearchCond[6] != "" && SearchCond[7] != "" && SearchCond[8] != "")		// APRENDDATE
			        {
			            TYPE += "APRENDDATE;";
			            DATA += "<APRENDDATE>" + SearchCond[6] + "-" + SearchCond[7] + "-" + SearchCond[8] + "</APRENDDATE>";
			        }

			        if (SearchCond[21] != "" && SearchCond[21] !== undefined )		// FormID
			        {
			            TYPE += "FORMID;";
			            DATA += "<FORMID>" + SearchCond[21] + "</FORMID>";
			        }
			
			        if (SearchCond[23] != "" && SearchCond[23] !== undefined )		// draftDeptName
			        {
			            TYPE += "WRITERDEPTNAME;";
			            DATA += "<WRITERDEPTNAME>" + SearchCond[23] + "</WRITERDEPTNAME>";
			        }
			        
			        SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
			        
				} else {
					if (condition[0] != "") {
				        TYPE += "DOCNO;"
				        DATA += "<DOCNO>" + condition[0] + "</DOCNO>";
				    }

				    if (condition[1] != "") {
				        TYPE += "DOCTITLE;"
				        DATA += "<DOCTITLE>" + condition[1] + "</DOCTITLE>";
				    }

				    if (condition[2] != "") {
				        TYPE += "WRITERNAME;"
				        DATA += "<WRITERNAME>" + condition[2] + "</WRITERNAME>";
				    }

				    if (condition[3] != "null" && condition[3].trim() != "") {
				        TYPE += "APRSTARTDATE;"
				        DATA += "<APRSTARTDATE>" + condition[3] + "</APRSTARTDATE>";
				    }

				    if (condition[4] != "null" && condition[4].trim() != "") {
				        TYPE += "APRENDDATE;"
				        DATA += "<APRENDDATE>" + condition[4] + "</APRENDDATE>";
				    }

				    if (condition[5] != "null" && condition[5].trim() != "") {
				        TYPE += "APRSTARTDATE;"
				        DATA += "<APRSTARTDATE>" + condition[5] + "</APRSTARTDATE>";
				    }

				    if (condition[6] != "null" && condition[6].trim() != "") {
				        TYPE += "APRENDDATE;"
				        DATA += "<APRENDDATE>" + condition[6] + "</APRENDDATE>";
				    }

				    if (condition[9] != "") {
				        TYPE += "FORMID;"
				        DATA += "<FORMID>" + condition[9] + "</FORMID>";
				    }
				    
				    if (typeof (condition[11]) != "undefined" && condition[11] != "") {
				        TYPE += "WRITERDEPTNAME;"
				        DATA += "<WRITERDEPTNAME>" + condition[11] + "</WRITERDEPTNAME>";
				    }

				    if (typeof (condition[12]) != "undefined" && condition[12] != "") {
				        TYPE += condition[12];
				        DATA += condition[13];
				    }
				    if (typeof (condition[14]) != "undefined" && condition[14] != "") {
				        TYPE += condition[14];
				        DATA += condition[15];
				    }
				    if (typeof (condition[16]) != "undefined" && condition[16] != "") {
				        TYPE += condition[16];
				        DATA += condition[17];
				    }
				    if (typeof (condition[25]) != "undefined" && condition[25] != "") {
				    	TYPE += "RECVSTARTDATE;"
				        DATA += "<RECVSTARTDATE>" + condition[25] + "</RECVSTARTDATE>";
				    }
				    if (typeof (condition[26]) != "undefined" && condition[26] != "") {
				    	TYPE += "RECVENDDATE;"
				        DATA += "<RECVENDDATE>" + condition[26] + "</RECVENDDATE>";
				    }
				    if (typeof (condition[27]) != "undefined" && condition[27] != "") {
				    	TYPE += "SENTDEPTNAME;"
				        DATA += "<SENTDEPTNAME>" + condition[27] + "</SENTDEPTNAME>";
				    }
				    if (typeof (condition[28]) != "undefined" && condition[28] != "") {
				    	TYPE += "RECEIVEDDEPTNAME;"
				        DATA += "<RECEIVEDDEPTNAME>" + condition[28] + "</RECEIVEDDEPTNAME>";
				    }
				}
				SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
		    }
		
		    window.onresize = function () {
// 		        var height = parseInt(divList.style.height.replace('px', '')) + 200;
// 		        var reheight = document.documentElement.offsetHeight - parseInt(height);
// 		        if (reheight < 0) {
// 		            reheight = 0;
// 		        }
		
// 		        document.getElementById('div_AprLine').style.height = reheight + "px";
		    };
		
		    function ShowMailProgress() {
		        document.getElementById("loadingPanel").style.display = "";
		        document.getElementById("loadingProgress").style.top = "400px";
		        document.getElementById("loadingProgress").style.left = (CurrenWidth / 2) - 100 + "px";
		        document.getElementById("loadingProgress").style.display = "";
		    }
		    function HiddenMailProgress() {
		        document.getElementById("loadingPanel").style.display = "none";
		        document.getElementById("loadingProgress").style.display = "none";
		    }
		
		    function onkeydown_start_search() {
		        if (window.event.keyCode == "13") {
		            search();
		        }
		    }
		
		    function keyword_Clear() {
		        document.getElementById('txt_keyword').value = "";
		    }
		
		    function search() {
		        pChackYN = "SEARCH";
		        if (document.getElementById("txt_keyword").value != "") {
		            var selectSearch = document.getElementById('selectType');
					if (approvalFlag == "G") {
			            for (var i = 0; i < 25; i++) {
			                SearchCond[i] = "";
			            }
			
			            if (selectSearch.item(0).selected) {
			                SearchCond[1] = replaceCond(document.getElementById("txt_keyword").value);
			            }
			            else if (selectSearch.item(1).selected) {
			                SearchCond[2] = replaceCond(document.getElementById("txt_keyword").value);
			            }
					} else {
						for (i = 0; i < 11; i++)
							condition[i] = "";

		                if (selectSearch.item(0).selected) {
		                	condition[1] = replaceCond(document.getElementById("txt_keyword").value);
		                }
		                else if (selectSearch.item(1).selected) {
		                	condition[2] = replaceCond(document.getElementById("txt_keyword").value);
		                }
					}
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t1160'/>");
		            return;
		        }
		        pageNum = 1;
		        MakeSubCondition();
		        if (pListTypeValue == "1") {
		            getDocList();
		        }
		        else if (pListTypeValue == "2") {
		            getDocList();
		        }
		        else if (pListTypeValue == "3") {
		            getDocList();
		        }
		        else if (pListTypeValue == "4") {
		            getReceivedDocList();
		        }
		        else if (pListTypeValue == "6") {
		            getSimsaDocList();
		        }
		        else if (pListTypeValue == "7") {
		            SendOutFlag = "O";
		            getSendOutDocList();
		        }
		        else if (pListTypeValue == "8") {
		            SendOutFlag = "S";
		            getSendOutDocList();
		        }
		        else if (pListTypeValue == "9") {
		            SendOutFlag = "SS";
		            getSendOutDocList();
		        }
		        else if (pListTypeValue == "10") {
		            getDocList();
		        }
		        else if (pListTypeValue == "21") {
		            getDocList();
		        }
		        else if (pListTypeValue == "11") {
		        	getDocList();
		        }
		        else {
		            getDocList();
		        }
		
		        $('#sel_year').val("ALL");
		        /* $('#sel_year').selectmenu('refresh'); */
		    }
		    
		    var SelUserCont_dialogArgument = new Array();
		    function btnRegUserCont_onclick() {
		        SelUserCont_dialogArgument[0] = "";
		        SelUserCont_dialogArgument[1] = RegUserCont_Complete;;
		        var url = "/ezApprovalG/selUserCont.do";
		        ContOpen = GetOpenWindow(url, "selUserCont", 340, 460, "NO");
		        try { ContOpen.focus() } catch (e) { }
		    }
		    
		    function RegUserCont_Complete(RtnVal) {
		        ContOpen.close();
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var selRow = DocList.GetSelectedRows();

		        if (selRow.length <= 0) {
		            var InformationString = strLangS385;
		            OpenAlertUI(InformationString);
		            return;
		        }
		        if (RtnVal != "cancel") {
		            for (i = 0; i < selRow.length; i++) {
		                var xmlhttp = createXMLHttpRequest();
		                var xmlpara = createXmlDom();
		                var objNode;
		                var tr = selRow[i];
		                createNodeInsert(xmlpara, objNode, "PARAMETER");
		                if ("<c:out value = '${listType}'/>" == 10) {
		                	createNodeAndInsertText(xmlpara, objNode, "DocID", GetAttribute(tr, "DATA2"));
		                } else {
		                	createNodeAndInsertText(xmlpara, objNode, "DocID", GetAttribute(tr, "DATA1"));
		                }
		                createNodeAndInsertText(xmlpara, objNode, "ContID", RtnVal);
		                createNodeAndInsertText(xmlpara, objNode, "Desc", "");

		                xmlhttp.open("POST", "/ezApprovalG/setUserContDoc.do", false);
		                xmlhttp.send(xmlpara);
		            }
		            var InformationString
		            if (xmlhttp.responseText.indexOf("TRUE") > -1)
		                InformationString = strLangS386;
		            else
		                InformationString = strLangS1124;
		            alert(InformationString);
		        }
		    }
		    
		    var Tab1_SelectID = "";
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
	
		    function Tab1_MouserOut(obj) {
		        if(Tab1_SelectID != obj.id)
		            obj.className = "";
		    }
	
		    function Tab1_MouseClick(obj) {		    	
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
		                document.getElementById(Tab1_SelectID).className = "";
	
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
		    
		    function ChangeTab(obj) {
		        var pSelectTab = obj.id;

		        switch (pSelectTab) {
		            case "tagsub1": pDocInfoValue='1';Approval_onclick(); break;
		            case "tagsub2": pDocInfoValue='2';Recipent_onclick(); break;
		            case "tagsub3": pDocInfoValue='4';Attach_onclick(); break;
		            case "tagsub4": pDocInfoValue='3';Opinion_onclick(); break;
		            case "tagsub5": pDocInfoValue='5';Circulation_onclick(); break;
		        }
		    }
		    
		    function Tab1_NewTabIni(pTabNodeID) {
		        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
		            if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };

		                    if (i == 1) {
		                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).className = "tabon";
		                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).id;
		                    }	
		                }
		            }
		        }
		    }
		    
		    function replaceCond(condStr){//검색조건 수정(% _ ' 추가)
		    	return condStr.toString().replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/%/g, "\\%").replace(/'/g, "\\'").replace(/_/g, "\\_");
		    }
		    
		    function getDocListByCompany(){
		    	pageNum = 1;
		    	getDocList();
		    }
		    function initselyear() {
		        $('#sel_year').selectmenu('close');
		    }
			<%-- 비전자문서 등록 --%>
			function btnNonElecRec_onclick() {
				if (isIE()) {
					var url = "/ezApprovalG/draftuiHWP.do?formURL=";
				    var form = "/files/upload_approvalG/form/2018000000.hwp";
				    var docInfo = "&draftFlag=DRAFT&formDocType=003&susinSN=0&docState=&listType=4&aprState=&isTmpDoc=&nonElecRec=Y";
				   	window.open(url + form + docInfo, "", GetOpenWindowfeature(1145, 1000));
                } else {
                	alert("비전자문서 등록은 IE에서만 가능합니다.");
                }
			}
		    
			
			// 부재자설정에 따른 버튼 활성화 
			function btnVisible(val) {
				var scopeDoc = window.document;
				// 메인버튼
    			var mainmenu = scopeDoc.getElementById('mainmenu');
				// 페이지레이어
    			var tblPageRayer = scopeDoc.getElementById('tblPageRayer');
				// 결재리스트
    			var div_scroll = scopeDoc.getElementsByClassName('div_scroll');
				// 타이틀
    			var title_h1 = scopeDoc.getElementsByClassName('title_h1');
				// 결재선
				var div_AprLine = scopeDoc.getElementById('div_AprLine');
				
    			if(val === "ok") {
	    			mainmenu.style.visibility = "visible";
	    			tblPageRayer.style.visibility = "visible";
	    			div_AprLine.style.visibility = "visible";
	    			div_scroll[0].style.visibility = "visible";
	    			title_h1[0].style.visibility = "visible";
    			} else if(val === "false"){
    				mainmenu.style.visibility = "hidden";
	    			tblPageRayer.style.visibility = "hidden";
	    			div_AprLine.style.visibility = "hidden";
	    			div_scroll[0].style.visibility = "hidden";
	    			title_h1[0].style.visibility = "hidden";
    			}
		    }
			
			function checkAprState(pDocID, docState, OrgAprUserID, aprMemberSN, pOrgCompanyID) {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/checkAprState.do",
		    		data : {
		    			docID : pDocID,
		    			docState : docState,
		    			userID : OrgAprUserID,
		    			aprMemberSN : aprMemberSN,
		    			orgCompanyID : pOrgCompanyID
		    		},
		    		success : function(text) {
		    			result = text;
		    		}
		    	});
		    	
		    	return result == "FALSE" ? true : false;
		    }

			function getOriginalFileExtension(filePath) {
				var pathLength = filePath.length;
				var lastIndexOfDot = filePath.lastIndexOf(".");
				
				if (lastIndexOfDot < 0) {
					return "";
				}
				
				var ext = trim_Cross(filePath.substr(lastIndexOfDot + 1, filePath.length).toLowerCase());
				
				if (ext === "ezd") {
					return getOriginalFileExtension(filePath.substr(0, lastIndexOfDot));
				}
				
				return ext;
			}
		</script>
	</head>
	<body class="mainbody" style="margin-top:0px;">	
		<h1 class="title_h1">
			<span id="presentcell">발송현황</span><span id="TitleInfo" style="color:#666;font-weight:normal;"></span>
		    <span class="searchForm">
		    	<select id="selectType" class="text"; style="width:80px; height:27px; border-color: #c8c8c8;">
		    		<option selected value="rad_Subject"><spring:message code='ezApprovalG.t106'/></option>
		    		<option value="rad_Writer"><spring:message code='ezApprovalG.t445'/></option>
		    	</select>
			    <input id="txt_keyword" class="searchinputBox searchinputBox" style="height: 27px;border: 1px solid #cbcbcb;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
		        <a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onClick="search()"></a>
		    </span>
		</h1>
		<div id="mainmenu">
			<ul>  
		  		<li id="tbtnRegUserCont" style="DISPLAY:none"><span id=btnRegUserCont onClick ="return btnRegUserCont_onclick()" ><spring:message code='ezApproval.t589'/></span></li>
				<li class="important" id="tbtnDraft" style="DISPLAY:none"><span id="btnDraft" onclick="return btnDraft_onclick()" ><spring:message code='ezApprovalG.t30'/></span></li>
				<li class="important" id="tbtnLinkDraft" style="display:none"><span id="btnLinkDraft" onclick="return btnLinkDraft_onclick()"><spring:message code='ezApprovalG.t1737'/></span></li>
				<li class="important" id="tbtnRedraft" style="DISPLAY:none"><span id="btnRedraft" onclick="return btnRedraft_onclick()"><spring:message code='ezApprovalG.t1738'/></span></li>
				<!-- <li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" ></li> -->
				<li id="tbtnApprove" style="DISPLAY:none"><span id="btnApprove" onclick="return  btnApprove_onclick('0')" ><spring:message code='ezApprovalG.t1'/></span></li>
				<li id="tbtnApprove1" style="DISPLAY:none"><span id="btnApprove1"  onclick ="return  btnApprove_onclick('1')" ><spring:message code='ezApprovalG.t1739'/></span></li>
				<li class="important" id="tbtnNonElecRec" style="DISPLAY:none"><span id="btnNonElecRec" onclick="return btnNonElecRec_onclick()" >비전자문서등록</span></li><%-- 비전자문서 등록 --%>
				<li id="tbtnApproveALL" style="DISPLAY:none"><span id="btnApproveALL" aprAllType="LIST"  onClick="return  btnApproveALL_onclick()"><spring:message code='ezApprovalG.t1740'/></span></li>  <!--onclick 함수 파라미터(LIST : 리스트 직접 일괄결재, POPUP : 팝업창 일괄결재-->
				<li id="tbtnApprove2" style="DISPLAY:none"><span  id=btnApprove2  onClick ="return  btnApprove_onclick('2')" ><spring:message code='ezApprovalG.t1740'/></span></li>
				<li id="tbtnReceipt"  style="DISPLAY:none"><span id="btnReceipt" onclick="return btnReceipt_onclick()" ><spring:message code='ezApprovalG.t1308'/></span></li>
				<li id="tbtnReturn" style="DISPLAY:none"><span id="btnReturn" onclick="return btnReturn_onclick()" ><spring:message code='ezApprovalG.t1434'/></span></li>
				<li id="tbtnSimsa" style="DISPLAY:none"><span id="btnSimsa" onclick="return btnSimsa_onclick()" ><spring:message code='ezApprovalG.t214'/></span></li>
				<li id="tbtnRegList" class="approvalG"><span id="btnAddCabinet" onclick="return btnAddCabinet_onclick()" ><spring:message code='ezApprovalG.t933'/></span></li>
				<li id="tbtnUserInfo" style="DISPLAY:none"><span id="btnUserInfo" onclick="return btnUserInfo_onclick()" ><spring:message code='ezApprovalG.t1741'/></span></li>
				<li id="tDocInfo"  class="approvalG"><span id="DocInfo" onclick="return GongRamDocInfo()" ><spring:message code='ezApprovalG.t946'/></span></li>		
				<li id="tbtncallback" style="DISPLAY:none"><span id="btncallback" onclick="return btncallback_onclick('CALLBACK')" ><spring:message code='ezApprovalG.t66'/></span></li>
		        <li id="tbtnforcecallback" style="display:none"><span id="btnforcecallback" onclick="return btnforcecallback_onclick()"><spring:message code='ezApprovalG.t2005'/></span></li>
				<c:if test="${approvalFlag == 'G'}">
					<li id="tbtnGongRam"><span id="btnGongRam" onclick="return btnViewDoc_onclick()" ><spring:message code='ezApprovalG.t1442'/></span></li>
					<%-- 2024-06-04 홍승비 - 버튼 표출 제어 함수 오류를 방지하기 위해 관리자단의 발송현황 내부 페이지에 '일괄공람/일괄회람' 버튼 추가, 실제 동작은 필요하지 않으므로 onclick 속성 제거 --%>
					<li id="tbtnGongRamALL" style="display:none"><span id="btnGongRamALL"><spring:message code='ezApprovalG.CSJBDA01'/></span></li>
				</c:if>
				<c:if test="${approvalFlag != 'G'}">
					<li id="tbtnGongRam" style="DISPLAY:none"><span id="btnGongRam" onclick="return btnViewDoc_onclick()" ><spring:message code='ezApprovalG.hyj21'/></span></li>
					<li id="tbtnGongRamALL" style="display:none"><span id="btnGongRamALL"><spring:message code='ezApprovalG.CSJBDA03'/></span></li>
				</c:if>
				<li id="tbtnViewDoc" style="DISPLAY:none"><span id="btnViewDoc" onclick="return btnViewDoc_onclick()" ><spring:message code='ezApprovalG.t367'/></span></li>
		        <li id="tbtnTotalSave" style="DISPLAY:none"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
		        <li id="tSearchCondi" style="DISPLAY:none"><span class="icon16 icon16_search" id="SearchCondi" onclick="return SearchCondi_onclick()"></span></li>
		        <%-- <li id="tSecondApproval" class="approvalG"><span id="btnSecondApproval" onclick="return btnSecondApproval()"><spring:message code='ezApprovalG.t26'/><spring:message code='ezApprovalG.t54'/></span></li> --%>
		        <li id="tbtnRemoveDoc" style="DISPLAY:none"><span class="icon16 icon16_delete" id="btnRemoveDoc" onclick="return btnRemoveDoc_onclick()"></span></li>
		        <!-- <li style="background: none; padding-right: 2px;"><img src="/images/i_bar.gif"></li> -->
		        <li style="vertical-align: middle; float:right">
		        	<select id="sel_year" name="sel_year" style="height:29px;" onchange="onSelect_Year(this);">    
		            	<%-- <option value="ALL"><spring:message code='ezApprovalG.kmsg01'/></option> --%>
		        	</select>
		        </li>
		        <li style="vertical-align: middle; float:right">
		        	<div id="sel_status_div" style="display:inline;">
						<select id="sel_status" name="sel_status" onchange="onSelect_Status(this);">    
			            	<%-- <option value="ALL"><spring:message code='ezApprovalG.kmsg01'/></option> --%>
			        	</select>  
		        	</div>
		        </li>
		        <c:if test="${fn:length(companyList) gt 1 and listType ne '4' and listType ne '21'}">
			        <li style="vertical-align: middle; float:right">		        	
						<select id="selectCompany" onchange="getDocListByCompany();">
							<option value="">
								<spring:message code='main.t74'/>
							</option>
							<c:forEach items="${companyList }" var="company">
								<option value="${company.companyID }">
									${company.companyName }
								</option>
							</c:forEach>
						</select>
					</li>	
				</c:if>
			</ul>
		</div>
		<div class="div_scroll" style="width:100%;HEIGHT:375px; overflow:AUTO; margin-bottom:10px" id="divList">
			<div id="lvDocList"></div>
		</div>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="loadingPanel" onclick="ContextMenuHidden();"></div>
		<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingProgress">
		    <img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
		</div>
		
		<div id="tblPageRayer"></div>
				
		<div id="tabnav" class="portlet_tabpart01" style="width:100%">
			<div class="portlet_tabpart01_top" id="tab1">
			    <p><span id="tagsub1"><spring:message code='ezApprovalG.t1769'/></span></p>
			    <p><span id="tagsub2"><spring:message code='ezApprovalG.t950'/></span></p>
			    <p><span id="tagsub3"><spring:message code='ezApprovalG.t56'/></span></p>
			    <p><span id="tagsub4"><spring:message code='ezApprovalG.t55'/></span></p>
			    <c:if test="${approvalFlag != 'G'}">
				   	<p><span id="tagsub5"><spring:message code='ezApprovalG.hyj24'/></span></p>
			    </c:if>
		  	</div>	
		</div>
		
		<div style="WIDTH:100%;HEIGHT:315px; font-size:92%; OVERFLOW-Y:AUTO;" id="div_AprLine">
			<div id="lvAprLine" ></div>
		</div>		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<form id="formAPP">
	        <input type="hidden"  id="APPXML" name="APPXML" />
	    </form>
	    <script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			//selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
			Tab1_NewTabIni("tab1");
		</script>
	</body>
</html>
