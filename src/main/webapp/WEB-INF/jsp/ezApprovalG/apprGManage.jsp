<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.hyj02'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<!-- <link rel="stylesheet" href="/js/jquery/jquery-ui.css"> -->
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
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
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>	
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
		
		<script ID="clientEventHandlersJS" type="text/javascript">
		    window.onload = window_onload;
		    var Resultxml = createXmlDom();
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "${userInfo.id}";
		    arr_userinfo[2]  = "${userInfo.displayName}";
		    arr_userinfo[3]  = "${userInfo.title}";
		    arr_userinfo[4]  = "${userInfo.deptID}";
		    arr_userinfo[5]  = "${userInfo.deptName}";
		    arr_userinfo[6]  = "${userInfo.jikChek}";
		    arr_userinfo[8]  = "${userInfo.email}";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "${susinAdmin}";
		    var companyID = "${userInfo.companyID}";
		    arr_userinfo[7] = "${buJaeInfo}";
		    arr_userinfo[11]  = "${userInfo.displayName1}";
		    arr_userinfo[12]  = "${userInfo.displayName2}";
		    arr_userinfo[13]  = "${userInfo.title1}";
		    arr_userinfo[14]  = "${userInfo.title2}";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";
		    var proxyInfo = "${proxyInfo}";
		    var proxyStartDate = "${proxyInfo.startDate}"
		    var proxyEndDate = "${proxyInfo.endDate}"
		    var formURL = "";
		    var formDocType = "";
		    var formExt = "";
		    var pDocInfoValue = "1";
		    var pListTypeValue = "${listType}";
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
		    var USE_OCS = "${useOcs}";
		    var SendOutFlag = "O";
		    var g_RelayG_Type = "${relayG_type}";
		    var userLang = "1";
		    var pSelMenu = "${selMenu}";
		    var pOpenYaer = "${openYear}";
		    var ViewLeftCount = "${viewLeftCount}";
		    var CurrentHeight = 0;
		    var CurrentWidth = 0;
		    var approvalFlag = "${approvalFlag}"; //전자결재 G , S 여부
		    var forceCallBackYN = "${forceCallBackYN}";
		    var SubQuery = "${SubQuery}";
		    var condition = new Array();
		    var nowDate = "${nowDateUTC}";
		    var currentpage = 1;
		    
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
		    function checkBujaeInfo() {
		        var BString = arr_userinfo[7];
		        if (BString != "") {
		            var BDim = new Array("");
		            BDim = BString.split(":");
		            var tmpStartDate = (BDim[3] + ":" + BDim[4]).substring(0, 16);
		            var tmpEndDate = (BDim[5] + ":" + BDim[6]).substring(0, 16);
		
		            tmpStartDate = tmpStartDate.replace("/", ":");
		            tmpEndDate = tmpEndDate.replace("/", ":");
		            
		            if (tmpEndDate < "${nowDate}") {
		                setBujaeOff();
		                checkBujaeInfo_Complete(true);
		                return true;

		            } else if (tmpStartDate > "${nowDate}") {
		            	checkBujaeInfo_Complete("ING");
		                return true;
		            }
		            var pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>"+"<spring:message code='ezApprovalG.t1723'/>" + "<br>"+ " <spring:message code='ezApprovalG.t1724'/>";

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
		        		
		        		var pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>"+"<spring:message code='ezApprovalG.t1723'/>" + "<br>"+ " <spring:message code='ezApprovalG.t1724'/>";

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
	            }
	            else if (Rtnval == "ING") { }
	            else {
	                setbuttonenable();
	                return;
	            }

	            if (beforeJob != pListTypeValue) {
		            beforeJob = pListTypeValue;
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
		            getSendOutDocList();
		        }
		        else if (pListTypeValue == "10") {
		            getDocList();
		        }
		        else if (pListTypeValue == "21") {
		            getDocList();
		        }
		        else if (pListTypeValue == "99") {
		            getDocList();
		        }
		
		        try {
		            parent.frames["left"].getAprCount();
		            parent.frames["left"].setPresentValue("");
		        } catch (e) { }
	        }
		    
		        
		    function setBujaeOff() {
		    	var result = "";
		    	
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/saveBujae.do",
		    		data : {
		    				buJae  : "",
		    				proxy  : ""
		    				},
		    		success: function(xml){
		    			result = xml;
		    		}        			
		    	});
		        
		        arr_userinfo[7] = "";
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
		    }
		
		    function lvDocList_SelChange() {
		        var SelList = new ListView();
		        SelList.LoadFromID("DocList");
		        var oArrRows = SelList.GetSelectedRows();
		        var tr = oArrRows[0];
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
		        if (pCurSelRow != null && oArrRows.length > 0) {
		            if (GetBujaeFlag())
		                return;
		            if (pListTypeValue == "1") {
		                if (pCurSelRow.getAttribute("DATA12") == "015")
		                    openViewDocInfo();
		                else if (document.getElementById("tbtnRedraft").style.display == "none" && document.getElementById("tbtnApprove").style.display == "")
		                    openApprovUI();
		                else
		                    btnRedraft_onclick();
		            }
		            else if (pListTypeValue == "4") {
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
		                }
		                else {
		                    openViewDocInfo();
		                }
		            }
		            else if (pListTypeValue == "21") //한양대 임시저장
		            {
		                pDocID = pCurSelRow.getAttribute("DATA1");
// 		                var newDocID = MakeTmp2Ing(pDocID);
		                pURL = pCurSelRow.getAttribute("DATA3");
		                btnRedraft_onclick();
		            }
		            else if (pListTypeValue != "5") {
		                openViewDocInfo();
		            }
		            else {
		                var para = new Array();
		                para[0] = pDocID;
		                para[1] = pURL;
		                if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp")
		                    openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezViewEnd_HWP_Cross.aspx";
		                else {
	                        openLocation = "/ezApprovalG/contDocView.do";
		                    openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pURL) + "&listSusin=";
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
                            var AttachUrlA2 = AttachUrlA1.substr(AttachUrlN1, AttachUrlA1.length);
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
                                    
                                if (GetAttribute(tr,"data4") == "file") {
                                    window.open(document.location.protocol + "//" + document.location.hostname + "/approvalG/downloadAttach.do?type=APPROVAL&docID=" + GetAttribute(tr, "data3") + "&docStatus=" + tempINGFlag + "&docAttachSn=" + GetAttribute(tr,"data2"));
                                } else {
                                    window.open("/ezApprovalG/downloadAttach.do?fileName=" + Attachfilename + "&filePath=" + AttachUrl, "_self");
                                }
                            }

                        }
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
		            if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
		                openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezViewEnd_HWP_Cross.aspx";
		            }
		            else {
	                    openLocation = "/ezApprovalG/contDocView.do";
		            }
		            openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pURL) + "&listSusin=";
		            openwindow(openLocation, "", 880, 570);
		        }
		    }
		    function btnRedraft_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        var pCurSelRow = oArrRows[0];
		        if (CheckFormConnFlag(pCurSelRow.getAttribute("DATA1"))) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1726'/>";
		            //OpenAlertUI(pAlertContent);
		            alert(pAlertContent);
		            return;
		        }
		        if (pCurSelRow) {
		            var ret = CheckAprLineInfo(pCurSelRow);
		            if (ret != "OK") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1727'/>" + "<br>" +
		                            "<spring:message code='ezApprovalG.t1712'/>" + ret + "<spring:message code='ezApprovalG.t1713'/>";
		                //OpenAlertUI(pAlertContent);
		                alert(pAlertContent);
		                return;
		            }
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
		
		            Html1 = Html.substring(Html.length - 3);
		
		            if (Html1 == "hwp") {
		                if (FunctionType == "000")                   //한글양식 미결 문서
		                    //openServerDraftUI_HWP("REDRAFT", pCurSelRow);
		                    alert(strLang1103);
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
		
		        var Ans = confirm("<spring:message code='ezApprovalG.t1728'/>");
		        if (Ans) {
		            var pCurSelRow = oArrRows[0];
		            if (pListTypeValue == "21")  //[한양대] 추가 사항 (서버 임시저장하기)
		                RemoveTmpDoc(pCurSelRow.getAttribute("DATA1"));
		            else
		                RemoveDoc(pCurSelRow.getAttribute("DATA1"));
		            if (pListTypeValue == "4")
		                getReceivedDocList();
		            else if (pListTypeValue == "6")
		                getSimsaDocList();
		            else
		                getDocList();
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
		        DocList.LoadFromID("DocList");
		        var oArrRows = DocList.GetSelectedRows();
		        
		        if (oArrRows.length > 0) {
		            var pCurSelRow = oArrRows[0];
		            
		            if (pListTypeValue == "7") {
		                var pDocID = pCurSelRow.getAttribute("DATA1");
		                var pURL = pCurSelRow.getAttribute("DATA3");
		                var openLocation = "";
		                
		                if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "doc") {
		                    openLocation = "/myoffice/ezApprovalG/ezViewWord/ezConvOut_word_Cross.aspx?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pURL);
		                } else if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
		                    if (CrossYN()) {
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
			            var pCurSelRow = oArrRows[0];
			            if (pCurSelRow.cells.length >= 7) {
			                if (pCurSelRow.cells[6].innerHTML == "<spring:message code='ezApprovalG.t1731'/>") {
			                    var pAlertContent = "<spring:message code='ezApprovalG.t1732'/>";
			                    //OpenAlertUI(pAlertContent);
			                    alert(pAlertContent);
			                    return;
			                }
			            }
			            if (pListTypeValue == "1") {
			                g_selReturn = "Y";
			                OpenReceiveENDDraftUI(pCurSelRow, "REDRAFT");
			            }
			            else
			                OpenOpinionUI(pCurSelRow, "HeSong");
			        }
			    } else {
			    	if (oArrRows != 0) {
		                var pCurSelRow = oArrRows[0];
		                OpenOpinionUI(pCurSelRow, "HeSong");
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
		            if (pListTypeValue == "3") {
		                var pMsg = "<spring:message code='ezApprovalG.t67'/>";
		                var Ans = OpenInformationUI(pMsg, btncallback_onclick_Complete, "open");
		            }
		            else {
		                var pMsg = "<spring:message code='ezApprovalG.t68'/>";
		                var Ans = OpenInformationUI(pMsg, btncallback_onclick_Complete, "open");
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
		            if (tempListType == "3") {
		                var pAlertContent = strLang891 + "\n" + strLang892;
		                alert(pAlertContent);
		            }
		            else {
		                var pAlertContent = strLang893 + "\n" + strLang894;
		                alert(pAlertContent);
		            }
		            getDocList();
		
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
		        pListTypeValue = strVal;
		        window.parent.frames["left"].pListTypeValue = strVal;
		        if (pListTypeValue == "7")
		            SendOutFlag = "O";
		        else if (pListTypeValue == "8")
		            SendOutFlag = "S";
		        else if (pListTypeValue == "9")
		            SendOutFlag = "SS";
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
		    				companyName : "${userInfo.companyName}",
		    				companyName2 : "${userInfo.companyName2}"
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
		                var pAlertContent = "<spring:message code='ezApprovalG.t1727'/>" + "<br>" +
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
		        var left = 0;
		        var top = 0;
		        var pDocID = tr.getAttribute("DATA1");
		        var pOrgDocID = tr.getAttribute("DATA7");
		        var pHref = tr.getAttribute("DATA3");
		        var openLocation;
		        if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
		            if (CrossYN()) {
		                alert(strLang1103);
		                return;
		            }
		            else {
		                openLocation = "ezViewHWP/ezSimsaG_HWP.aspx";
		            }
		        }
		        else {
	                openLocation = "/ezApprovalG/ezSimsaG.do";
		        }
		        openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&docHref=" + encodeURI(pHref) + "&orgDocID=" + encodeURI(pOrgDocID);
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
		            if (parseInt(pageNum) - 1 < 1)
		                return;
		            pageNum = pageNum - 1;
		            openergetDocInfo();
		        }
		        else if (page == "next") {
		            if (parseInt(pageNum) + 1 > parseInt(totalPages))
		                return;
		            pageNum = pageNum + 1;
		            openergetDocInfo();
		        }
		        else if (page == "page") {
		            if (event.keyCode == 13) {
		                var goPage = document.all.txt_PageInputNum.value;
		                if (parseInt(goPage) != goPage || parseInt(goPage) == "" || parseInt(goPage) < 1 || parseInt(goPage) > parseInt(totalPages))
		                    return;
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
		            var ret = CheckAprLineInfo(tr);
		            if (ret != "OK") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1727'/>" + "<br>" +
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
		                RemoveDocCabinet(tr.getAttribute("DATA1"), "Y");
		                openergetDocInfo();
		            }
		        }
		        else {
		            if (Ans) {
		                RemoveDocCabinet(tr.getAttribute("DATA1"), "");
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
		
		            if (BDim[3] <= "${nowDate}" && BDim[4] >= "${nowDate}") {
		                return true;
		            }
		        } else if (proxyInfo != null && proxyInfo != "") {
		        	var strDate = "${proxyInfo.startDate}";
		        	var endDate = "${proxyInfo.endDate}";
		            if (strDate <= "${nowDate}" && endDate >= "${nowDate}") {
		                return true;
		            }
		        }
		        setBujaeOff();
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
		    function btnApproveALL_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var pCurSelRow = DocList.GetSelectedRows();
		        if (pCurSelRow.length == 0) {
		            var pAlertContent = strLang930 + "<br>" + strLang336;
		            //OpenAlertUI(pAlertContent);
		            alert(pAlertContent);
		            return;
		        }
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

		        var wWeigth = 630;
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
		        window.open("secondApprovalInfo.do", '', "status=0,menubar=0,scrollbars=0,resizable=1,height=220,width=468,top=" + top + ",left =" + left);
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
		            OpenAlertUI("<spring:message code='ezApprovalG.t113'/>", "", "OPEN");
		            return;
		        }
		        else
		            pDocID = tr[0].getAttribute("DATA1");
				
		        //직인의뢰함에서 타입을 END로 주기위해
		        var url;
		        if (pListTypeValue == 7 || pListTypeValue == 8 || pListTypeValue == 9) {
		        	url = "totalSaveFileInfo.do?docID=" + pDocID + "&type=END";	
		        } else {
		        	url = "totalSaveFileInfo.do?docID=" + pDocID + "&type=APR";
		        }
		        
		        var feature = "status=no,help=no,scroll=no,edge=sunken,width=580px,height=450px";
		        feature = feature + GetOpenPosition(580, 450);
		        window.open(url, "", feature);
		    }
		
		    var setsearchinfo_cross_dialogArguments = new Array();
		    var OpenWin2;
		    function SearchCondi_onclick() {
		        var para;
		        setsearchinfo_cross_dialogArguments[0] = para;
		        setsearchinfo_cross_dialogArguments[1] = SearchCondi_onclick_Complete;
		        var type = "APR";
		        OpenWin2 = window.open("/ezApprovalG/setSearchInfo.do?type=" + type, "setsearchInfo_Cross", GetOpenWindowfeature(510, 375));
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
		                if ("${listType}" == 10) {
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
		    	return condStr.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/%/g, "\\%").replace(/'/g, "\\'").replace(/_/g, "\\_");
		    }
		    
		</script>
	</head>
	<body class="mainbody" style="margin-top:0px;">	
		<h1>
			<span id="presentcell"></span><span id="TitleInfo" style="color:#666;font-weight:normal;"></span>
		    <span style="float:right;font-weight:normal;color:black;">
		    	<select id="selectType" style="width:80px; height:27px; border-color: #c8c8c8;">
		    		<option selected value="rad_Subject"><spring:message code='ezApprovalG.t106'/></option>
		    		<option value="rad_Writer"><spring:message code='ezApprovalG.t445'/></option>
		    	</select>
			    <input id="txt_keyword" style="height: 27px;border: 1px solid #cbcbcb; border-right:0px" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
		        <a href="#" style="float:right;"><img src="/images/bsearch_new.gif" border="0" onClick="search()"></a>
		    </span>
		</h1>
		<div id="mainmenu">
			<ul>  
		  		<li id="tbtnRegUserCont" style="DISPLAY:none"><span id=btnRegUserCont onClick ="return btnRegUserCont_onclick()" ><spring:message code='ezApproval.t589'/></span></li>
				<li id="tbtnDraft" style="DISPLAY:none"><span id="btnDraft" onclick="return btnDraft_onclick()" ><spring:message code='ezApprovalG.t30'/></span></li>
				<li id="tbtnLinkDraft" style="display:none"><span id="btnLinkDraft" onclick="return btnLinkDraft_onclick()"><spring:message code='ezApprovalG.t1737'/></span></li>
				<li id="tbtnRedraft" style="DISPLAY:none"><span id="btnRedraft" onclick="return btnRedraft_onclick()"><spring:message code='ezApprovalG.t1738'/></span></li>
				<!-- <li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" ></li> -->
				<li id="tbtnApprove" style="DISPLAY:none"><span id="btnApprove" onclick="return  btnApprove_onclick('0')" ><spring:message code='ezApprovalG.t1'/></span></li>
				<li id="tbtnApprove1" style="DISPLAY:none"><span id="btnApprove1"  onclick ="return  btnApprove_onclick('1')" ><spring:message code='ezApprovalG.t1739'/></span></li>
				<li id="tbtnApproveALL" style="DISPLAY:none"><span id="btnApproveALL"  onClick="return  btnApproveALL_onclick()"><spring:message code='ezApprovalG.t1740'/></span></li>
				<li id="tbtnApprove2" style="DISPLAY:none"><span  id=btnApprove2  onClick ="return  btnApprove_onclick('2')" ><spring:message code='ezApprovalG.t1740'/></span></li>
				<li id="tbtnReceipt"  style="DISPLAY:none"><span id="btnReceipt" onclick="return btnReceipt_onclick()" ><spring:message code='ezApprovalG.t1308'/></span></li>
				<li id="tbtnReturn" style="DISPLAY:none"><span id="btnReturn" onclick="return btnReturn_onclick()" ><spring:message code='ezApprovalG.t1434'/></span></li>
				<li id="tbtnSimsa" style="DISPLAY:none"><span id="btnSimsa" onclick="return btnSimsa_onclick()" ><spring:message code='ezApprovalG.t214'/></span></li>
				<li id="tbtnRegList" class="approvalG"><span id="btnAddCabinet" onclick="return btnAddCabinet_onclick()" ><spring:message code='ezApprovalG.t933'/></span></li>
				<li id="tbtnUserInfo" style="DISPLAY:none"><span id="btnUserInfo" onclick="return btnUserInfo_onclick()" ><spring:message code='ezApprovalG.t1741'/></span></li>
				<li id="tDocInfo"  class="approvalG"><span id="DocInfo" onclick="return GongRamDocInfo()" ><spring:message code='ezApprovalG.t946'/></span></li>		
				<li id="tbtncallback" style="DISPLAY:none"><span id="btncallback" onclick="return btncallback_onclick('CALLBACK')" ><spring:message code='ezApprovalG.t66'/></span></li>
		        
		        	<li id="tbtnforcecallback" style="display:none"><span id="btnforcecallback" onclick="return btnforcecallback_onclick()"><spring:message code='ezApprovalG.t2005'/></span></li>
				
				<li id="tbtnRemoveDoc" style="DISPLAY:none"><span id="btnRemoveDoc" onclick="return btnRemoveDoc_onclick()"><spring:message code='ezApprovalG.t266'/></span></li>
				<li id="tbtnViewDoc" style="DISPLAY:none"><span id="btnViewDoc" onclick="return btnViewDoc_onclick()" ><spring:message code='ezApprovalG.t367'/></span></li>
				<c:if test="${approvalFlag == 'G'}">
					<li id="tbtnGongRam"><span id="btnGongRam" onclick="return btnViewDoc_onclick()" ><spring:message code='ezApprovalG.t1442'/></span></li>
				</c:if>
				<c:if test="${approvalFlag != 'G'}">
					<li id="tbtnGongRam" style="DISPLAY:none"><span id="btnGongRam" onclick="return btnViewDoc_onclick()" ><spring:message code='ezApprovalG.hyj21'/></span></li>
				</c:if>
		        <li id="tSearchCondi" style="DISPLAY:none"><span id="SearchCondi" onclick="return SearchCondi_onclick()"><spring:message code='ezApprovalG.t111'/></span></li>
		        <li id="tbtnTotalSave" style="DISPLAY:none"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
		        <li id="tSecondApproval" class="approvalG"><span id="btnSecondApproval" onclick="return btnSecondApproval()"><spring:message code='ezApprovalG.t26'/><spring:message code='ezApprovalG.t54'/></span></li>
		        <!-- <li style="background: none; padding-right: 2px;"><img src="/images/i_bar.gif"></li> -->
		        <li style="vertical-align: middle;">
		        	<select id="sel_year" name="sel_year" style="height:29px;" onchange="onSelect_Year(this);">    
		            	<%-- <option value="ALL"><spring:message code='ezApprovalG.kmsg01'/></option> --%>
		        	</select>  
		        </li>
			</ul>
		</div>
		<div class="div_scroll" style="width:100%;HEIGHT:360px; overflow:AUTO" id="divList">
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
		
		<div style="WIDTH:100%;HEIGHT:230px; font-size:92%; OVERFLOW-Y:AUTO;" id="div_AprLine">
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