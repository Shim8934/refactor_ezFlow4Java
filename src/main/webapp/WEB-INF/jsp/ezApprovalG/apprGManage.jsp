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
		<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
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
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/PreviewItem.js')}"></script>
		
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
		    var pListTypeValue = '<c:out value="${listType}"/>';
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
		    var USE_OCS = "<c:out value = '${useOcs}'/>";
		    var SendOutFlag = "O";
		    var g_RelayG_Type = "<c:out value = '${relayG_type}'/>";
		    var userLang = "1";
		    var pSelMenu = "<c:out value = '${selMenu}'/>";
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
		    var useHWP = "${useHWP}";
		    var useWebHWP = "<c:out value = '${useWebHWP}'/>";
			var userLang = "<c:out value = '${userLang}'/>";
			var useAdditionalRole = "${useAdditionalRole}";
			var userLang = "${userInfo.lang}";
		    var shareUser = "<c:out value = '${shareUser}'/>";
		    var primary = "<c:out value = '${primary}'/>"; // 재기안 시 부서명 다국어 분기처리를 위한 primary (1:기본어, 2:다국어)
		    var setting = null;
		    var onclickFlag = false;
		    var pMailListDiv = 0;
		    var pMailPreVDiv = 0;
		    var pMailListWidthH = 0;
		    var pMailPreWidthH = 0;
		    var pMailListDiv_H = 0;
		    var pMailPreVDiv_H = 0;
		    var p_ListorderValue = "";
		    var pPreviewShow_HOW = "";
		    var clickPreviweType = "TEXT";
		    var PreviewH_Move = false;
		    var selobj = null;
		    var previewInfo = "<c:out value = '${previewInfo}'/>";
		    var useAprPreview = "<c:out value = '${useAprPreview}'/>";
		    var extensionattribute4 = "<c:out value = '${userInfo.gyumJik}'/>";
		    var extensionattribute5 = "<c:out value = '${userInfo.extensionattribute5}'/>";
		    var absenceAllClear = "<c:out value = '${absenceAllClear}'/>";
		    var deptPathCode = "<c:out value = '${userInfo.deptPathCode}'/>";
		    var pNonElecRecType = "<c:out value = '${nonElecRecType}'/>";
		    
		    var selectcabinet_cross_dialogArguments = new Array();
		    
		    /* 2022-02-10 홍승비 - 일괄기안 기능을 위한 변수 추가 */
            var isGroupDoc = "";
        	var groupDocListCnt = 0;
        	var groupDocDelCnt = 0;

			var selectYearVal = "ALL";
        	
        	/* 2023-04-20 이가은 - 일괄접수 기능을 위한 변수 추가 */
        	var isReceiptAll = "";
        	var pCurSelRowSend = [];
        	var minSignCountInfo = [];
        	var minSignCount = 0;
        	var receiptFlag = "";
        	var retValue = [];
        	var OpenPopupWin;
        	
        	// 2023-08-24 조수빈 - 누락된 변수 추가
        	var tempSecurity = "";
		    var tempKeep = "";
		    var tempPublic = "Y";
		    var tempUrgent = "N";
		    var tempKeyword = "";
		    var tempItemCode = "";
		    var tempItemName = "";
		    var tempItemName2 = "";
		    var pSpecialRecordCode = "";
		    var pPublicityCode = "";
		    var pPublicityYN = "";
		    var pLimitRange = "";
		    var pPageNum = "";
		    var cabinetID = "";
		    var TaskCode = "";	    
		    var useReceiveInfoName = "<c:out value ='${useReceiveInfoName}'/>"; // 수신처 뒤에 "장"을 붙이는지 여부 (0 : 안붙임 / 1 : 붙임 / 2: 상위부서 + 수신처장)

		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
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
		            
		            if (userLang == "1" || userLang == "3" || userLang == "6") {
			            pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>" + "<spring:message code='ezApprovalG.t1723'/>" + "<br>" + " <spring:message code='ezApprovalG.t1724'/>";
		            }
		            else if (userLang == "2") {
			            pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>" + " <spring:message code='ezApprovalG.t1724'/>";
		            }

// 		            var Rtnval = OpenInformationUI(pAlertContent, checkBujaeInfo_Complete, "OPEN");
		            showConfirm(pAlertContent, checkBujaeInfo_Complete);
// 			            if (Rtnval) {
// 			                checkBujaeInfo_Complete(true);
// 			            }
// 			            else {
// 			                checkBujaeInfo_Complete(false);
// 			            }		            	
		        } else if(GetBujaeFlag()){
		        	
		        		tmpStartDate = proxyStartDate;
		        		tmpEndDate = proxyEndDate;
		        		
		        		var pAlertContent = "";
		        		
			            if (userLang == "1" || userLang == "3" || userLang == "6") {
				            pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>" + "<spring:message code='ezApprovalG.t1723'/>" + "<br>" + " <spring:message code='ezApprovalG.t1724'/>";
			            }
			            else if (userLang == "2") {
				            pAlertContent = arr_userinfo[2] + "<spring:message code='ezApprovalG.t1721'/>" + "<br>" + tmpStartDate + "~" + tmpEndDate + "<br>" + " <spring:message code='ezApprovalG.t1724'/>";
			            }

// 			            var Rtnval = OpenInformationUI(pAlertContent, checkBujaeInfo_Complete, "OPEN");
						showConfirm(pAlertContent, checkBujaeInfo_Complete);
// 			            if (Rtnval) {
// 			                checkBujaeInfo_Complete(true);
// 			            }
// 			            else {
// 			                checkBujaeInfo_Complete(false);
// 			            }		            	
		        } else {
		            checkBujaeInfo_Complete("ING");
		        }
		    }
		
		    function checkBujaeInfo_Complete(Rtnval) {
		    	hideConfirm();
		    	if (Rtnval == true) {
	                // setBujaeOff();
	                saveBujaeUser();
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
				
				listLoading(true); //20201211 조진호 - 리스트 출력 시 시간이 오래 걸릴 수 있어 로딩바 추가
				
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
		        else if (pListTypeValue == "5") {
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
				else if (pListTypeValue == "24") {
					getDocList();
				}
		        else if (pListTypeValue == "99") {
		            getDocList();
		        }
		        else if (pListTypeValue == "11") {
		        	getDocList();
		        }
				else if (pListTypeValue == "97") {
					getReceivedDocList();
				}	
		        else if (pListTypeValue == "98") {
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
		    
		    function saveBujaeUser() {
		    	
		    	var jo = new Object();
		    	var formArray = new Array();
		    	var index = 0;
		    	
		    	var gyumjikArray = extensionattribute4.split(";");
				var deptPathCodeArray = deptPathCode.split(",");
				var deptId = deptPathCodeArray[deptPathCodeArray.length-1];
				var title = "";
				var addJobXml = createXmlDom();
				
				$.ajax({
					type : "POST"
					,dataType : "text"
					,url : "/admin/ezOrgan/getEntryInfo.do"
					,async : false
					,data : {
						cn : arr_userinfo[1]
						,prop : "department;title;extensionAttribute5"
						,pMode : "user"
					}
				})
				.success(function(result) {
					var xmlDom = loadXMLString(result);
					deptId = SelectSingleNodeValueNew(xmlDom, "DATA/DEPARTMENT").trim();
					title = SelectSingleNodeValueNew(xmlDom, "DATA/TITLE").trim();
					extensionattribute5 = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE5").trim();
				})
				.fail(function(fail) {
					console.log("apprGManage > /admin/ezOrgan/getEntryInfo.do > fail => ", fail);
					showAlert("<spring:message code='ezTask.t200913'/>");
					return;
				});
				
				if(absenceAllClear == "YES" || (arr_userinfo[4] == deptId && arr_userinfo[13] == title)) {
	        		extensionattribute5 = "";
    			}
		    	
		    	jo.count = index;
	        	jo.deptId = deptId	// 본직
	        	jo.proxy = extensionattribute5;
	        	
	        	formArray.push(jo);
		        
	        	$.ajax({
		    		type : "POST"
		    		,dataType : "text"
		    		,async : false
		    		,url : "/admin/ezOrgan/getUserAddJobList.do"
		    		,data : {
		    			cn : arr_userinfo[1]
		    		}
		    	})
		    	.success(function(res) {
		    		addJobXml = loadXMLString(res);
		    	})
		    	.fail(function(fail) {
		    		console.log("apprGManage > /admin/ezOrgan/getUserAddJobList.do > fail => ", fail);
		    		showAlert("<spring:message code='ezTask.t200913'/>");
					return;
		    	});
		         
	        	var rows = addJobXml.getElementsByTagName("ROW");
	    		for(var i=0; i<rows.length; i++) {
	    			var getUserId = rows[i].getElementsByTagName("CN")[0].textContent;
	    			var getDeptId = rows[i].getElementsByTagName("DEPARTMENT")[0].textContent;
	    			var getTitle = rows[i].getElementsByTagName("TITLE")[0].textContent;
	    			var getJobId = rows[i].getElementsByTagName("JOBID")[0].textContent;
	    			var getProxy = rows[i].getElementsByTagName("EXTENSIONATTRIBUTE5")[0].textContent;
	    			
	    			if(absenceAllClear == "YES" || (arr_userinfo[4] == getDeptId && arr_userinfo[13] == getTitle)) {
	    				getProxy = "";
	    			}
					jo = new Object();
	    			
					jo.count = i+1;
		        	jo.deptId = getDeptId	// 겸직부서
		        	jo.proxy = getProxy;
		        	jo.jobId = getJobId;
		        	
		        	formArray.push(jo);
	    		}
	    		
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/saveBujaeUser.do",
		    		data : {
		    				formArray : JSON.stringify(formArray)
		    				},
		    		success: function(text){
			            //alert("<spring:message code='ezPersonal.tt16'/>");
			            // 2021-03-25 김민성 - 부재자 설정 해제시 부재자 정보 초기화
			            arr_userinfo[7] = "";
		    		},
		    		error: function(){
			            //alert("<spring:message code='ezPersonal.tt14'/>");
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
		        draftAllTypeB = "<c:out value='${draftAllTypeB}'/>";
		        CurrentHeight = document.documentElement.clientHeight;
		        CurrentWidth = document.documentElement.clientWidth;
		        var height = parseInt(divList.style.height.replace('px', '')) + 200;
		        var reheight = document.documentElement.offsetHeight - parseInt(height);
	            
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		        /* 2022-07-04 홍승비 - 우측 미리보기 영역의 표출여부 스타일 속성을 온로드 초기에 제어 */
	        	if (useAprPreview == "YES" && previewInfo == "H") {
	        		document.getElementById("PreviewRayerH").style.display = "";
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
						$("#presentcell").html("<spring:message code='ezApprovalG.t1747'/>");
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
				
				// 미리보기 영역 관련 온로드 설정, 테넌트 컨피그에 따라 제어
				if (useAprPreview == "YES") { // 전자결재 미리보기 영역 활성화 시
					if (pPreviewShow_HOW == "") {
						if (previewInfo != null && previewInfo.trim() != "") {
							pPreviewShow_HOW = previewInfo;
						} else {
							pPreviewShow_HOW = "OFF";
						}
					}
					PreviewRayerChange(pPreviewShow_HOW, 'Manage');
					/* 2022-06-29 홍승비 - 우측 미리보기 영역을 위한 온로드 시 리사이즈 동작 추가 */
			    	Window_resize();
				} else {
					pPreviewShow_HOW = "OFF";
					PreviewRayerChange(pPreviewShow_HOW, 'Manage');
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
					<%-- AddOption(sel_status, '<spring:message code="ezApprovalG.t49"/>', "004"); // 2023-03-13 양지혜 - 반송된문서 추가 > 결재할문서에서 반송 상태 제외 --%>
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t66"/>', "006");
		        	AddOption(sel_status, '<spring:message code="ezApproval.t497"/>', "015");
		        } else if (pListTypeValue == "2" || pListTypeValue == "3") {
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t1422"/>', "002");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t50"/>', "005");
		        	<%-- AddOption(sel_status, '<spring:message code="ezApprovalG.t49"/>', "004"); // 2023-04-12 양지혜 - 반송된문서 추가 > 결재진행문서, 기안한문서에서 반송 상태 제외 --%>
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t66"/>', "006");
		        } else if (pListTypeValue == "4") {
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.garm06"/>', "011");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t1432"/>', "014");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t1430"/>', "012");
		        	AddOption(sel_status, '<spring:message code="ezApproval.t497"/>', "015");
		        } else if (pListTypeValue == "9") {
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t1308"/>', "I");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t239"/>', "T");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.F0031"/>', "R");
		        	AddOption(sel_status, '<spring:message code="ezApproval.t155"/>', "S");
		        	AddOption(sel_status, strLangAprState21, "V");
		        } else if (pListTypeValue == "11") {
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t1422"/>', "002");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t50"/>', "005");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t49"/>', "004");
		        	AddOption(sel_status, '<spring:message code="ezApprovalG.t66"/>', "006");
		        	AddOption(sel_status, '<spring:message code="ezApproval.t497"/>', "015");
		        } else if (pListTypeValue == "97") {
					AddOption(sel_status, '<spring:message code="ezApprovalG.garm06"/>', "011");
					AddOption(sel_status, '<spring:message code="ezApprovalG.t1430"/>', "012");
				} else {
		        	$('#sel_status_div').closest("li").hide();
		        }
		        
		    }
		    
		    var SelYearFlag = false;
		    function onSelect_Year() {
		        SelYearFlag = true;
				selectYearVal = document.getElementById("sel_year").value;

				var nowyear = nowDate.substring(0,4);
				var nowmonth = nowDate.substring(5,7);
				var nowday = nowDate.substring(8,10);

				if (approvalFlag == "G") {
					if (selectYearVal != "ALL") {
						SearchCond[3] = selectYearVal;
						SearchCond[4] = "01";
						SearchCond[5] = "01";
						SearchCond[6] = selectYearVal;
						SearchCond[7] = "12";
						SearchCond[8] = "31";
					} else { // 최근 1년
						SearchCond[3] = nowyear - 1;
						SearchCond[4] = nowmonth;
						SearchCond[5] = nowday;
						SearchCond[6] = nowyear;
						SearchCond[7] = nowmonth;
						SearchCond[8] = nowday;
					}
				} else {
					if (selectYearVal != "ALL") {
						condition[3] = selectYearVal + "-01-01";
						condition[4] = selectYearVal + "-12-31";
					} else { // 최근 1년
						condition[3] = (nowyear - 1) + "-" + nowmonth + "-" + nowday;
						condition[4] = nowyear + "-" + nowmonth + "-" + nowday;
					}
				}
				MakeSubCondition();
		        listLoading(true); // 20201211 조진호 - 리스트 출력 시 시간이 오래 걸릴 수 있어 로딩바 추가
		        
		        if (pListTypeValue == "1") {
		            getDocList();
		        }
		        else if (pListTypeValue == "2") {
		            getDocList();
		        }
		        else if (pListTypeValue == "3") {
		            getDocList();
		        }
		        else if (pListTypeValue == "4" || pListTypeValue == "5" || pListTypeValue == "97") {
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
				else if (pListTypeValue == "24") {
					getDocList();
				}
				else if (pListTypeValue == "98") {
					getDocList();
				}
		    }
		    
		    function onSelect_Status() {
		    	pageNum = 1;
		        if (pListTypeValue == "1" || pListTypeValue == "2" || pListTypeValue == "3" || pListTypeValue == "11") {
		            getDocList();
		        } else if (pListTypeValue == "4" || pListTypeValue == "97") {
		        	getReceivedDocList();
		        } else if (pListTypeValue == "9") {
		        	getSendOutDocList();
		        }
		    }
		    
		    function lvDocList_SelChange() {
		        var SelList = new ListView();
		        SelList.LoadFromID("DocList");
		        var oArrRows = SelList.GetSelectedRows();
		        onclickFlag = true;
		        var tr = oArrRows[0];
		        ext =  tr.getAttribute("DATA3").substr(tr.getAttribute("DATA3").length - 3, tr.getAttribute("DATA3").length).toLowerCase();
		        if (tr.length != 0) {
		            //if (pListTypeValue != "5") {
		                if (pDocInfoValue == "1")
		                    getAprLine(tr);
		                else {
		                    getAprDocAproveInfo(tr);
		                }
		            /* }
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
		            } */
		            setbuttonenable();
		        } 
		        
		        if ($("#PreviewRayerH").css("display") != "none") {
		        	PreviewRayerChange("H", 'Manage');
		        	if (CrossYN()) {
		        		if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
			        		ifrmPreViewH.document.getElementById("ifrmviewEmptyText").textContent = strLang930;	        			
		        		}
		            } else {
		            	if (ifrmPreViewH.document.getElementById("ifrmviewEmptyText") != null){
			            	ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = strLang930;		            		
		            	}
		            }
		        }
		        // 원클릭 이벤트는 미리보기 영역이 열려있지 않을때만 동작
		        else {
					/* 2021-03-24 홍승비 - 제목 클릭 시 원클릭 이벤트로 전자결재 읽기, 결재 팝업창을 표출 */
		            var headerNameTD = $(event.target).attr("headerName");
		            if (tr.length != 0 && headerNameTD != null && typeof(headerNameTD) != "undefined" && headerNameTD == "DOCTITLE") {
		            	lvDocList_DBSelChange();
		            }
		            
		        	PreviewRayerChange("NONE", 'Manage');
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
							showAlert("<spring:message code='ezApprovalG.bhs23'/>");
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
		            } else if (pListTypeValue == "4" || pListTypeValue == "5" || pListTypeValue == "97") {
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
		                	if(useWebHWP == "NO") {
			                	if (isIE()) {
				                	openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
			                	} else {
			                		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
				                    showAlert(pAlertContent);
				                    
				                    return;
			                	}
		                	} else {
		                		openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
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
						// var win;
						if (pListTypeValue == "99" || pListTypeValue == "10") {
							var heigth = window.screen.availHeight;
							var width = window.screen.availWidth;
							var left = (parseInt(width) - 540) / 2;
							var top = (parseInt(heigth) - 220) / 2;
							var isExtYN = tr.getAttribute("DATA3");

							if (isExtYN.toUpperCase() == "Y") {
								var url = "/ezApprovalG/ezReceiptHistoryInfo.do?docID=" + tr.getAttribute("DATA2") + "&deptID=" + encodeURI(tr.getAttribute("DATA1"));
								// win = window.open(url, "", "height=300px,width=855px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
								showPopup(url, 855, 300, "", "height=300px,width=855px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1", hidePopup);
							} else {
								left = (parseInt(width) - 1155) / 2;
								top = (parseInt(heigth) - 460) / 2;
								// win = window.open("/ezApprovalG/ezLineInfo.do?docID=" + tr.getAttribute("DATA2") + "&deptID=" + encodeURI(tr.getAttribute("DATA1")) + "&docState=011" + "&aprState=" + escape(tr.getAttribute("DATA4")), "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
								showPopup("/ezApprovalG/ezLineInfo.do?docID=" + tr.getAttribute("DATA2") + "&deptID=" + encodeURI(tr.getAttribute("DATA1")) + "&docState=011" + "&aprState=" + escape(tr.getAttribute("DATA4")), 1155, 460, "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1", hidePopup);
							}
						} else {
							var url = "/ezApprovalG/ezReceiptInfoIng.do?docId=" + tr.getAttribute("DATA2") + "&receiptId=" + tr.getAttribute("DATA1") + "&receiptName=" + encodeURIComponent(tr.getAttribute("DATA10"));
							// win = window.open(url, "", GetOpenWindowfeature(1155, 460, false));
							showPopup(url, 1155, 460, "", GetOpenWindowfeature(1155, 460, false), hidePopup);
						}

						// try { win.focus(); } catch (e) {}
		                break;
		            case "4":
		            	var AttachfilenameA1 = tr.cells[1].innerHTML;
                        if (AttachfilenameA1 != null) {
                            var AttachfilenameN1 = AttachfilenameA1.lastIndexOf(".");
                            var AttachfilenameA2 = AttachfilenameA1.substr(AttachfilenameN1, AttachfilenameA1.length);
                            var AttachUrlA1 = GetAttribute(tr,"DATA1");
                            var AttachUrlN1 = AttachUrlA1.lastIndexOf(".");
                            var AttachUrlA2 = getOriginalFileExtension(AttachUrlA1); // fileExt(hwp, ezd, mht)
                            AttachUrl = encodeURIComponent(GetAttribute(tr,"DATA1"));
                          
                            if (AttachfilenameN1 < 0) {
                                Attachfilename = encodeURIComponent(tr.cells[1].innerText + AttachUrlA2);
                            } else {
	                            Attachfilename = encodeURIComponent(tr.cells[1].innerText);
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
                                
                                /* 2023-09-01 홍승비 - 전자결재 결재문서리스트 하단 첨부탭에서 문서첨부파일을 여는 경우, DOCID에 '.' 문자가 포함되어 전달되는 오류 수정 (비공개문서의 접근권한 체크 등 관련) */
                                //2018-09-12 천성준 - 전자결재 결재문서리스트 하단 첨부탭에서 첨부파일이 문서첨부일경우 문서보기로 열수있게
                                try {
	                                if (GetAttribute(tr,"data4") == strLangCSJ01 || GetAttribute(tr,"data4") == "Document") {
	                                	var tempStr = AttachUrlA1.split("/");
	                                    var docID = tempStr[tempStr.length - 1].replace("." + AttachUrlA2, '');
	                                    var openLocation;
	                                    
	                                    if (AttachUrlA2 == "hwp") {
	                                    	if(useWebHWP == "NO") {
		                                    	if (isIE()) {
		                                    		openLocation = "/ezApprovalG/ezViewEnd_HWP.do";
		                                    	} else {
		                                    		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
		                		                	showAlert(pAlertContent);
		                		                	return;
		                                    	}
	                                    	} else {
	                                    		openLocation = "/ezApprovalG/ezViewEnd_WHWP.do";
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
							showAlert("<spring:message code='ezApprovalG.bhs23'/>");
							getDocList();
							return;
							
						}
		            	
		            	/* 2022-02-23 홍승비 - 일괄기안된 문서는 모두결재에서 제외 */
						var isGroupDoc = checkIsGroupDoc(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("ORGCOMPANYID")); // 일괄기안문서 여부 체크 (1안 기준의 DOCID 전달)
		            	if (tempFlag == 1 && isGroupDoc == "Y") {
		            		showAlert("<spring:message code='ezApprovalG.HSBDa05'/>");
							return;
		            	}
                	}
		            openApprovUI(tempFlag);
		        } else {
		            OpenInformationUI(strLang930 + "<br>" + strLang336);
		        }
		    }
		    function btnUserInfo_onclick() {        
		        if (pDocInfoValue == "1")
		            openUserInfo();
		        else if (pDocInfoValue == "2")
		            OpenReceiptHistory();
		    }
		    function btnViewDoc_onclick() {
                var DocList = new ListView();
                DocList.LoadFromID("DocList");
                var oArrRows = DocList.GetSelectedRows();
				var pCurSelRow = oArrRows[0];
                // 2024-02-19 전인하 - 문서보기 버튼 - 선택된 문서가 없을 시 알림 추가
                if (oArrRows.length == 0) {
                    OpenInformationUI(strLang930 + "<br>" + strLang336);
                    return;
                }
				orgCompanyID = pCurSelRow.getAttribute("ORGCOMPANYID");
                
		        if (pListTypeValue != "5") {
		            if (oArrRows.length > 0)
		                openViewDocInfo();
		            else {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		                //OpenAlertUI(pAlertContent);
		                showAlert(pAlertContent);
		            }
		        }
		        else {
					// 대외수신함 문서보기
					var pURL = pCurSelRow.getAttribute("DATA3");
					var pDocID = pCurSelRow.getAttribute("DATA1").trim();
					var docHref = pURL.substr(pURL.length - 3, pURL.length).toLowerCase();
					var isMht = docHref == "mht" || (docHref != "hwp" && g_RelayG_Type.toUpperCase() == "MHT");
					if (isMht) {
						openLocation = "";

						if (pCurSelRow.getAttribute("DATA15") == "001") {
							openLocation = "/ezApprovalG/recevG.do";
						} else {
							openLocation = "/ezApprovalG/recevGSusin.do";
						}

						openLocation = openLocation + "?docID=" + encodeURI(pDocID) + "&draftFlag=" + encodeURI("SUSIN");
						openLocation = openLocation + "&uOrgID=" + encodeURI(pCurSelRow.getAttribute("DATA7")) + "&orgCompanyID=" + orgCompanyID + "&viewDoc=Y";
					} else {
						if(useWebHWP == "NO") {
							if (/chrome/i.test(navigator.userAgent)) {
								showAlert(strLang1103);
								return;
							} else {
								if (docHref == "hwp" || g_RelayG_Type.toUpperCase() == "HWP") {
									openLocation = "/ezApprovalG/ezRecevGSusinHWP.do?docID=" + escape(pDocID) + "&draftFlag=" + escape("SUSIN") + "&uOrgID=" + encodeURI(pCurSelRow.getAttribute("DATA7")) + "&orgCompanyID=" + orgCompanyID + "&viewDoc=Y";
								}
							}
						} else {
							openLocation = "/ezApprovalG/ezRecevGSusinWHWP.do?docID=" + escape(pDocID) + "&draftFlag=" + escape("SUSIN") + "&uOrgID=" + encodeURI(pCurSelRow.getAttribute("DATA7")) + "&orgCompanyID=" + orgCompanyID + "&viewDoc=Y";
						}
					}
					openwindow(openLocation, "receive", 880, 550)
		        }
		    }
		    
		    function btnRedraft_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        
		        var oArrRows = DocList.GetSelectedRows();
		        
		        if (oArrRows.length <= 0) {
		        	var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		        	showAlert(pAlertContent);
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
		        	showAlert(pAlertContent);
		            return;
		        }
		        
		        // if (CheckFormConnFlag(pCurSelRow.getAttribute("DATA1"))) {
		        //     var pAlertContent = "<spring:message code='ezApprovalG.t1726'/>";
		        //     //OpenAlertUI(pAlertContent);
		        //     alert(pAlertContent);
		        //     return;
		        // }
		        if (pCurSelRow) {
		            var ret = CheckAprLineInfo(pCurSelRow);
		            if (ret != "OK") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1727'/>" + "\n" +
		                            "<spring:message code='ezApprovalG.t1712'/>" + ret + "<spring:message code='ezApprovalG.t1713'/>";
		                //OpenAlertUI(pAlertContent);
		                showAlert(pAlertContent);
		                return;
		            }
		        }
		        
		        if ((pListTypeValue == "1" || pListTypeValue == "11") && checkAprState(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("DATA12"), pCurSelRow.getAttribute("DATA4"), pCurSelRow.getAttribute("APRMEMBERSN"), pCurSelRow.getAttribute("ORGCOMPANYID"))){
		        	showAlert("<spring:message code='ezApprovalG.bhs23'/>");
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
					showAlert(pAlertContent);
		            return;
		        }

				ezCommon_cross_dialogParams[0] = oArrRows;
				showConfirm("<spring:message code='ezApprovalG.t1728'/>", btnRemoveDoc_onclick_afterConfirm);
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
		                        showAlert(strLang1103);
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
		                    } else if (pCurSelRow.getAttribute("DATA9") == strDocState14) {
		                    	pDraftFlag = "GAMSABU";
		                    }
		                    
		                    OpenReceiveDraftUI(pCurSelRow, pDraftFlag);
		                } else {
		                    var pAlertContent = "<spring:message code='ezApprovalG.t1730'/>";
		                    //OpenAlertUI(pAlertContent);
		                    showAlert(pAlertContent);
		                }
		            }
		        } else {
		        	var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		        	showAlert(pAlertContent);
		            return;
		        }
		    }
		    
		    // 2024-04-18 조수빈 - 일괄접수 / 일괄접수전결에서 제외할 문서 카운트
		    function excludeBulkRecv(selectedRows) {
		    	var count = 0;
		    	
		    	for (var i = 0; i < selectedRows.length; i++) {
		    		// 문서의 상태가 회송이거나 문서에 분리첨부가 있는 경우이거나 시행문이거나 합의문인 경우 카운트
		    		if (selectedRows[i].getAttribute('DATA10') == '015' || selectedRows[i].getAttribute("SEPERATEATTACHXML") == 'Y'
		    			|| (approvalFlag == "S" && selectedRows[i].getAttribute('DATA15') == "004")
		    			|| (approvalFlag == "G" && selectedRows[i].getAttribute('DATA15') == "001")
		    			|| selectedRows[i].getAttribute('DATA9') == "012") {
		    			count++;
		    		}
		    	}
		    	return count;
		    }
		    
		    function btnRJunkyulAll_onclick() {
		    	receiptFlag = "J";
		    	var DocList = new ListView();
				DocList.LoadFromID("DocList");
				pCurSelRow = DocList.GetSelectedRows();
				if (pCurSelRow.length == 0) {
					var pAlertContent = strLang930 + "<br>" + strLang336;
					OpenAlertUI(pAlertContent);
					return;
				} else {
					if(approvalFlag == "G"){
						OpenInformationUI(strLangJSBAP03, btnRJunkyulAll_onclick_Complete);
					}else{
						OpenInformationUI(strLangKMH03, btnReceiptAll_onclick_Complete);
					}
				}
		    }
		    
		    function btnRJunkyulAll_onclick_Complete(rtn) {
		    	DivPopUpHidden();
		    	var DocList = new ListView();
				DocList.LoadFromID("DocList");
				pCurSelRowSend = DocList.GetSelectedRows();
				
				// 2024-04-18 조수빈 - 선택된 문서들이 모두 회송 상태 또는 분리첨부가 있는 문서들인 경우 alert 띄우고 더이상 진행하지 않음.
				if (rtn && (pCurSelRowSend.length == excludeBulkRecv(pCurSelRowSend))) {
					OpenAlertUI(strLang721);
					return;
				}
				
		    	if (rtn) {
		    		for (var i = pCurSelRowSend.length - 1; i >= 0; i--) {
			    		if (pSusinManagerFlag == "admin" || pCurSelRowSend[i].getAttribute("DATA8") == pUserID) {
							pDocID = pCurSelRowSend[i].getAttribute('DATA1');
							pURL = pCurSelRowSend[i].getAttribute('DATA3');
							pAprState = pCurSelRowSend[i].getAttribute('DATA10');
							var seperateAttachXml = pCurSelRowSend[i].getAttribute("SEPERATEATTACHXML");
							var docType = pCurSelRowSend[i].getAttribute('DATA15');
							var docState = pCurSelRowSend[i].getAttribute('DATA9');
				    		isReceiptAll = "Y";
		                    var pDraftFlag = "SUSIN";
				    		var pOrgDocID = pCurSelRowSend[i].getAttribute('DATA7');
				    		var docUrlType = (pURL.substr(pURL.length-3, pURL.length)).toUpperCase(); 
							var ajaxUrl = "";
							
					        var Resultxml;
					        var d = new Date();
					        var RecieveDay = d.getFullYear() + "." + (d.getMonth() + 1) + "." + d.getDate();
					        Resultxml = "<LISTVIEWDATA><ROWS><ROW>";
					        Resultxml = Resultxml + "<COLUMN>1</COLUMN>";
					        Resultxml = Resultxml + "<COLUMN>" + MakeXMLString(arr_userinfo[2]) + "</COLUMN>";
					        Resultxml = Resultxml + "<COLUMN>" + MakeXMLString(arr_userinfo[3]) + "</COLUMN>";
					        
					        /* 2021-06-03 홍승비 - 부서명에 특수문자를 허용 + c:out 처리되었으므로 특수문자 역 인코딩 및 CDATA 처리 진행 */
					        Resultxml = Resultxml + "<COLUMN><![CDATA[" + ConvMakeXMLString(arr_userinfo[5]) + "]]></COLUMN>";
					
					        Resultxml = Resultxml + "<COLUMN>" + "<spring:message code='ezApprovalG.t25'/>" + "</COLUMN>";
					        Resultxml = Resultxml + "<COLUMN>" + "<spring:message code='ezApprovalG.t1422'/>" + "</COLUMN>";
					        Resultxml = Resultxml + "<DATA name='ProcessDate'>" + "" + "</DATA>";
					        Resultxml = Resultxml + "<DATA name='ReceivedDate'>" + RecieveDay + "</DATA>";
					        Resultxml = Resultxml + "<DATA name='DocID'>" + pDocID + "</DATA>";
					        Resultxml = Resultxml + "<DATA name='AprMemberID'>" + pUserID + "</DATA>";
					        Resultxml = Resultxml + "<DATA name='AprmemberIsDeptYN'>N</DATA>";
					        Resultxml = Resultxml + "<DATA name='AprMemberDeptID'>" + arr_userinfo[4] + "</DATA>";
					        Resultxml = Resultxml + "<DATA name='ReasonDoNotApprov'></DATA>";
					        Resultxml = Resultxml + "<DATA name='isProposerYN'>N</DATA>";
					        Resultxml = Resultxml + "<DATA name='isBriefUserYN'>N</DATA>";
					        Resultxml = Resultxml + "<DATA name='isCompanyID'>" + companyID + "</DATA>";
					
					        Resultxml = Resultxml + "<DATA name='AprType'>" + strAprType4 + "</DATA>";
					        Resultxml = Resultxml + "<DATA name='AprState'>" + strAprState2 + "</DATA>";
					        Resultxml = Resultxml + "<DATA name='PMemberName'>" + MakeXMLString(arr_userinfo[11]) + "</DATA>";
					        Resultxml = Resultxml + "<DATA name='SMemberName'>" + MakeXMLString(arr_userinfo[12]) + "</DATA>";
					        Resultxml = Resultxml + "<DATA name='PMemberDeptName'><![CDATA[" + ConvMakeXMLString(arr_userinfo[15]) + "]]></DATA>";
					        Resultxml = Resultxml + "<DATA name='SMemberDeptName'><![CDATA[" + ConvMakeXMLString(arr_userinfo[16]) + "]]></DATA>";
					        Resultxml = Resultxml + "<DATA name='PMemberJobTitle'>" + MakeXMLString(arr_userinfo[13]) + "</DATA>";
					        Resultxml = Resultxml + "<DATA name='SMemberJobTitle'>" + MakeXMLString(arr_userinfo[14]) + "</DATA>";
					
					        Resultxml = Resultxml + "</ROW></ROWS></LISTVIEWDATA>";
							
					        // 문서의 상태가 회송이거나 분리첨부가 있거나 합의문 혹은 시행문인 경우에는 결재선 저장 안하는 분기
					        if (pAprState != '015' || !seperateAttachXml || (approvalFlag == "S" && docType == "004") || (approvalFlag == "G" && docType == "001") || docState == "012") {
						        $.ajax({
				            		type : "POST",
				            		dataType : "text",
				            		async : false,
				            		url : "/ezApprovalG/aprLineSave.do",
				            		data : {
			            				ret : Resultxml
		            				}
				            	});
					        }
					    		
				    		if (docUrlType == "MHT") {
				    			ajaxUrl = "/ezApprovalG/recevGSusin.do";
				    		} else if (docUrlType == "HWP") {
				    			ajaxUrl = "/ezApprovalG/ezRecevGSusinHWP.do";
				    		} else if (docUrlType == "WHWP") {
				    			ajaxUrl = "/ezApprovalG/ezRecevGSusinWHWP.do";
				    		}
					    		
			    			// 수신문서 열어주는 작업
				    		$.ajax({
				    			type : "GET",
				    			dataType : "text",
				    			async : false,
				    			url : ajaxUrl,
				    			data : {
				    				docID : pDocID,
				    				uOrgID : pOrgDocID,
				    				isReDraft : "",
				    				draftFlag : pDraftFlag,
				    				retFlag : "",
				    				isPreview : "Y"
				    			},
					    		success : function(result) {
					    		}
				    		});
			    			
		                } else {
		                    var pAlertContent = "<spring:message code='ezApprovalG.t1730'/>";
		                    OpenInformationUI(pAlertContent);
		                }
		    		}
		    		
	    			if (approvalFlag == "G") {
		    		
				    	getDocInfo();
				        var para = new Array();
				        para[0] = cabinetID;
				        var url = "/ezApprovalG/selectCabinet.do?initFlag=1";
				
				        selectcabinet_cross_dialogArguments[0] = para;
				        selectcabinet_cross_dialogArguments[1] = btnCabinet_onclick_Complete;
				
				        OpenPopupWin = window.open(url, "SelectCabinet_Cross", GetOpenWindowfeature(1000, 620));
			            try { OpenPopupWin.focus(); } catch (e) { }
	    			} else {
	    				btnRJunkyulAll_after();
	    			}
		    	}
		    }
		    
		    function btnRJunkyulAll_after() {
				listLoading(true);
				
				setTimeout(function() {
                	var RtnVal = receiptAll_btnSendDraft();
                	listLoading(false);
					var arrRtnVal = RtnVal.split("/");
    		        
     		        if (arrRtnVal[0] == "OK") {
     		        	pAlertContent = strLang933 + (Number(arrRtnVal[1])) + strLang934_1 + "<br/>";

     		            if (arrRtnVal[2] != 0) {
	     		            pAlertContent += strLang935 + arrRtnVal[2] + strLang934_1;
						}
     		            
     		            if (arrRtnVal[3] != 0) {
     		            	
     		            	if (arrRtnVal[2] != 0) {
     		            		pAlertContent += " / ";
     		            	}
     		                
     		            	pAlertContent += strLang936 + arrRtnVal[3] + strLang934_1;
     		            }

     		            if (arrRtnVal[4] != 0) {
     		            	
     		            	if (arrRtnVal[2] != 0 || arrRtnVal[3] != 0) {
     		            		pAlertContent += " / ";
     		            	}
     		                
     		            	pAlertContent += strLang938 + arrRtnVal[4] + strLang934_1;
     		            }
     		            
     		            if (receiptFlag == "R") {
     			            pAlertContent += "<br/>" + strLangLGEAR01;
     		            } else {
     			            pAlertContent += "<br/>" + strLangLGEAR03;
     		            }
     		            
     		        } else {
     		        	
     		        	if (receiptFlag == "R") {
     			            pAlertContent = strLangLGEAR02;
     		        	} else {
     			            pAlertContent = strLangLGEAR04;
     		        	}
     		        	
     		        }
     		        
   		        	// 2023-08-22 조수빈 - 작업을 완료한 후에는 부서수신함을 리로딩
  		        	OpenAlertUI(pAlertContent, btnRJunkyulAll_after_complete);
            	}, 0);
		    }
		    
		    
		    function btnRJunkyulAll_after_complete() {
		    	listLoading(false);
	     		window.parent.frames[0].mailPanel_left.style.display = "none";
				 if(pListTypeValue && pListTypeValue == "97"){
					 window.parent.frames[0].convMain('97', '');
				 }else{
					 window.parent.frames[0].convMain('4', '');
				 }
		    }
		    
		    function btnCabinet_onclick_Complete(rtn) {
		        DivPopUpHidden();
		        
		        if (rtn[0] == "TRUE") {
		            var g_SelCabXml = rtn[1];
		            var xmlCab = createXmlDom();
		            xmlCab = loadXMLString(g_SelCabXml);

		            cabinetID = getNodeText(SelectSingleNodeNew(xmlCab, "CABINETINFO/CABINET/CABINETID"));
		            TaskCode = getNodeText(SelectSingleNodeNew(xmlCab, "CABINETINFO/CABINET/TASKCODE"));
		        }
		
		        if (cabinetID != "") {
		        	LastSignSN = "1";
		        }
		    }
		    
		    function btnReceiptAll_onclick() {
		    	receiptFlag = "R";
				var DocList = new ListView();
				DocList.LoadFromID("DocList");
				var pCurSelRow = DocList.GetSelectedRows();
				
				if (pCurSelRow.length == 0) {
					var pAlertContent = strLang930 + "<br>" + strLang336;
					OpenAlertUI(pAlertContent);
					return;
				} else{
					if(approvalFlag == "G"){
						OpenInformationUI(strLangJSBAP02, btnReceiptAll_onclick_Complete);
					}else{
						OpenInformationUI(strLangKMH02, btnReceiptAll_onclick_Complete);
					}
				}
		    }
		    
	    	// var ezapprovalinfo_dialogArguments = new Array();
	    	
		    function btnReceiptAll_onclick_Complete(rtn) {
		    	DivPopUpHidden();
		    	var DocList = new ListView();
		    	var pOrgDocID = "";
                var pDraftFlag = "SUSIN";
				DocList.LoadFromID("DocList");
				pCurSelRowSend = DocList.GetSelectedRows();
				pDocID = pCurSelRowSend[0].getAttribute('DATA1');
				pURL = pCurSelRowSend[0].getAttribute('DATA3');
				orgCompanyID = pCurSelRowSend[0].getAttribute('orgcompanyid');
	    		pDocType = pCurSelRowSend[0].getAttribute('DATA15');
	    		pFormID = pCurSelRowSend[0].getAttribute('DATA16');
	    		pOrgDocID = pCurSelRowSend[0].getAttribute('DATA7');
	    		isReceiptAll = "Y";
	    		pGubun = "11";
		    	var chkReceivedDoc = 0;

				// 2024-04-18 조수빈 - 선택된 문서들이 모두 회송 상태 또는 분리첨부가 있는 문서들인 경우 alert 띄우고 더이상 진행하지 않음.
				if (rtn && (pCurSelRowSend.length == excludeBulkRecv(pCurSelRowSend))) {
					OpenAlertUI(strLang721);
					return;
				}
				
		    	if (rtn) {
		    		
		    		for (var i = pCurSelRowSend.length - 1; i >= 0; i--) {
			    		
		    			if (pSusinManagerFlag == "admin" || pCurSelRowSend[i].getAttribute("DATA8") == pUserID) {
							pDocID = pCurSelRowSend[i].getAttribute('DATA1');
							pURL = pCurSelRowSend[i].getAttribute('DATA3');
							orgCompanyID = pCurSelRowSend[i].getAttribute('orgcompanyid');
				    		pDocType = pCurSelRowSend[i].getAttribute('DATA15');
				    		pFormID = pCurSelRowSend[i].getAttribute('DATA16');
				    		pOrgDocID = pCurSelRowSend[i].getAttribute('DATA7');
				    		var docUrlType = (pURL.substr(pURL.length-3, pURL.length)).toUpperCase(); 
				    		var ajaxUrl = "";
				    		
				    		if (docUrlType == "MHT") {
				    			ajaxUrl = "/ezApprovalG/recevGSusin.do";
				    		} else if (docUrlType == "HWP") {
				    			ajaxUrl = "/ezApprovalG/ezRecevGSusinHWP.do";
				    		} else if (docUrlType == "WHWP") {
				    			ajaxUrl = "/ezApprovalG/ezRecevGSusinWHWP.do";
				    		}
					    		
				    		// 수신문서 열어주는 작업 - 수신 파일을 만들어주기 위해서.
				    		$.ajax({
				    			type : "GET",
				    			dataType : "text",
				    			async : false,
				    			url : ajaxUrl,
				    			data : {
				    				docID : pDocID,
				    				uOrgID : pOrgDocID,
				    				isReDraft : "",
				    				draftFlag : pDraftFlag,
				    				retFlag : "",
				    				isPreview : "Y"
				    			},
				    			success : function(result) {
				 					if (getSignCount(pCurSelRowSend[i]) != undefined){
				 						pCurSelRowSend.push(pCurSelRowSend[i]);
				 					}
				    			}
				    		});
		                } else {
		                    var pAlertContent = "<spring:message code='ezApprovalG.t1730'/>";
		                    showAlert(pAlertContent);
		                }
			    	
				    	// 접수된 문서인지 확인하기
				    	$.ajax({
				    		type : "POST",
				    		dataType : "text",
				    		async : false,
				    		url : "/ezApprovalG/isReceivedDoc.do",
				    		data : {
				    			docID : pDocID
				    		},
				    		success : function(result) {
				    			
				    			if (result > 0) {
				    				chkReceivedDoc++;
				    			}
				    		}
				    		
				    	});
		    		}
		    		
		    		// 결재정보 창을 띄우기 위한 임시 정보 세팅
					getDocInfo();
					nonElecRec = "";
			        var onlydocinfiview = false;
			        var parameter = new Array();
			        parameter[0] = pDocID;
			        parameter[1] = pFormID;
			        parameter[2] = "4"; // SignCount
			        parameter[3] = ";;;;;"; // SignInfo
			        parameter[4] = "4"; // hapyuiCount
			        parameter[5] = "SUSIN";
			        parameter[6] = "N";
			        parameter[7] = "Y";
			        parameter[8] = "4";	// gongramCount
			        parameter[9] = false;
			        parameter[10] = pDocType;
			        parameter[11] = "";
			        parameter[12] = "RECV";
			        parameter[28] = onlydocinfiview;
			        parameter[30] = cabinetID;
			        parameter[31] = tempSecurity;
			        parameter[32] = tempUrgent;
			        parameter[33] = pSummery;
			        parameter[34] = pSpecialRecordCode;
			        parameter[35] = pPublicityCode;
			        parameter[36] = pLimitRange;
			        parameter[37] = pPageNum;
			        parameter[38] = tempSecurityDate;
			        parameter[39] = "";	// SummaryFlag
			        parameter[45] = pPublicityYN;
			        parameter[46] = nonElecRec;
			        
			        if (nonElecRec == "Y") {
			        	
			        	if (pGubun == "11") {
				        	parameter[47] = cabinetID;
			        	} else {
				        	parameter[47] = "nonElecRecTempCabinet";
			        	}
			        	
				        parameter[48] = nonElecRecInfoXml; // 기록물 기본등록 정보
				        parameter[49] = nonSepAttachLVXml; // 분첨
				        parameter[50] = g_szSCListXml; // 특수목록
				        parameter[51] = sepAttachCheckYN; // 특수목록
			        }
			        
			        if (approvalFlag == "S") {
			            parameter[19] = "ING";
			            parameter[20] = tempKeep;
			            parameter[23] = tempPublic;
			            parameter[25] = tempItemCode;
				        parameter[29] = TaskCode;
				        parameter[33] = pSummery;
				        // 2023-08-23 조수빈 - 일반 접수의 경우 분류코드 이름, 분류코드다국어 이름이 들어감.
				        parameter[41] = tempItemName;
				        parameter[42] = tempItemName2;
			        }

			        if (tempItemCode != "")
			            tempdocnumcode = tempItemCode;
			
			        // ezapprovalinfo_dialogArguments[0] = parameter;
			        // ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;
			
			        if (chkReceivedDoc != 0) {
			        	showAlert("<spring:message code='ezApprovalG.pjg04'/>", "");
			        	// window.close();
			        } else {
			        	// OpenPopupWin = window.open("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&orgCompanyID=" + orgCompanyID + "&docType=" + pDocType, "ezApprovalInfo", GetOpenWindowfeature(1210, 750));
			        	// try { OpenPopupWin.focus(); } catch (e) { }
						ezCommon_cross_dialogArguments[0] = parameter;
						showPopup("/ezApprovalG/ezApprovalInfo.do?initFlag=1&guBun=" + pGubun + "&orgCompanyID=" + orgCompanyID + "&docType=" + pDocType, 1210, 750, "ezApprovalInfo", GetOpenWindowfeature(1210, 750), btnApprovalInfo_Complete);
			        }
		    	}
		    }
		    
		    function btnApprovalInfo_Complete(ret) {
		    	hidePopup();
				retValue = ret;
		    	
			        if (ret && ret[0] == "OK") {
			            
			        	try {
			                
			        		if (pGubun != "5" && pGubun != "7" && pGubun != "10") {
			                    
			        			if (ret[1] != false) {
			                    	$.ajax({
			                    		type : "POST",
			                    		dataType : "json",
			                    		async : false,
			                    		url : "/ezApprovalG/aprLineSave.do",
			                    		data : {
			                    				ret    : ret[1]
			                    				},
			                    		success : function(result){
			                    			
			                    		}
			                    	});
			
			                        IsSkipDrafter = "FALSE";
			                        btnSendDraftEnable = "true";
			                    }
			                    savexmlhttp = null;
			                    savexmlhttp = createXMLHttpRequest();
			                }
			
			                if (pGubun != "6" && pGubun != "7" && pGubun != "9" && pGubun != "11" && pGubun != "12" && pGubun != "13") {
			                	$.ajax({
		                    		type : "POST",
		                    		dataType : "text",
		                    		async : false,
		                    		url : "/ezApprovalG/aprDeptSave.do",
		                    		data : {
		                    				aprDeptInfo : ret[2]
		                    				},
		                    		success : function(result){
		                    			if (result == 'TRUE') {
		                    				
		                    			} else {
		                    				showAlert(strLang163);
		                    			}
		                    		}
		                    	});
			                	
			                    btnReceivLineEnable = false;
			                    setRecevInfo(ret[3]);
			                }
			
			                if (pGubun != "5" && pGubun != "6" && pGubun != "7" && pGubun != "8" && pGubun != "9" && pGubun != "10") {
			                    var g_SelCabXml = ret[4];
			                    var xmlCab = createXmlDom();
			                    xmlCab = loadXMLString(g_SelCabXml);
			                    cabinetID = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/CABINETID");
			                    TaskCode = SelectSingleNodeValueNew(xmlCab, "CABINETINFO/CABINET/TASKCODE");
			                }

							tempKeyword = ret[6]; 				// 2021-03-10 박기범 - 키워드 추가
			                tempSecurity = ret[7];                // 보안등급 관련
			                tempUrgent = ret[8];                  // 긴급 결재 여부
			                pSummery = ret[9];                    // 요약 내용 관련
			                tempSecurityDate = ret[14];           // 보안 결재 체크 관련
			                pPublicityCode = ret[11];             // 대민공개여부 및 공개등급 관련 
			                pPublicityYN = ret[21];             // 공개여부 및 공개등급 관련 
			                pSpecialRecordCode = ret[10];
			                pLimitRange = ret[12];
			                pPageNum = ret[13];
			                
			                if (nonElecRec == "Y") {
				            	nonElecRecInfoXml = ret[23];
				            	nonSepAttachLVXml = ret[24];
				            	g_szSCListXml = ret[25];
						        sepAttachCheckYN = ret[26];
				            	
						        if (ext == "hwp") {
					            	setNonElecRecInfo_whwp(nonElecRecInfoXml);
				            	}
				            }


						SummaryFlag = true;
			            savexmlhttp = null;
			            }
			            catch (e) {
			                showAlert("저장시 오류 발생");
			            }
			        }
		    }
		    
		    function receiptAll_btnSendDraft() {
	    	    var xmlpara = createXmlDom();
	    	    var objRoot, objNode, doc, objNode2, objNodes, objDocinfoNode;
	    	    objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
	    	    createNodeAndInsertText(xmlpara, objNode, "USERID", arr_userinfo[1]);
	    	    createNodeAndInsertText(xmlpara, objNode, "DISPLAYNAME", arr_userinfo[2]);
	    	    createNodeAndInsertText(xmlpara, objNode, "TITLE", arr_userinfo[3]);
	    	    createNodeAndInsertText(xmlpara, objNode, "DEPTID", arr_userinfo[4]);
	    	    createNodeAndInsertText(xmlpara, objNode, "DEPTNAME", arr_userinfo[5]);
	    	    createNodeAndInsertText(xmlpara, objNode, "JIKCHEK", arr_userinfo[6]);
	    	    createNodeAndInsertText(xmlpara, objNode, "COMPANYID", companyID);
	    	    createNodeAndInsertText(xmlpara, objNode, "PASSWD", "");
	    	    createNodeAndInsertText(xmlpara, objNode, "LANGTYPE", "1");
	    	    var list = createNodeAndAppandNode(xmlpara, objRoot, list, "DOCIDS");
	    	    
	    	    // 결재선 저장
	    	    if (receiptFlag == 'R') {
		    	    for (var i = 0; i < pCurSelRowSend.length; i++) {
			    		pDocID = pCurSelRowSend[i].getAttribute('DATA1');
		    	    	
			    		var aprLine = "";
				    	
				    	for (var j = 0; j < (retValue[1].split('<ROW>').length -1); j++) {
				    		aprLine += retValue[1].split('<ROW>')[j] + "<ROW>";
				    	}
				    	aprLine += retValue[1].split('<ROW>')[retValue[1].split('<ROW>').length -1];
					    	
				    	var xmlParser = new DOMParser();
				    	var xmlDoc = xmlParser.parseFromString(aprLine, "text/xml");
				    	var value = xmlDoc.getElementsByTagName("DATA");
				    	pAprState = pCurSelRowSend[i].getAttribute('DATA10');
				    	
				    	for (var j = 0; j < value.length; j++) {
				    		if (xmlDoc.getElementsByTagName("DATA")[j].attributes[0].value == "DocID") {
						    	xmlDoc.getElementsByTagName("DATA")[j].innerHTML = pDocID;
				    		}
				    	}
				    	
				    	if (pAprState != '015' || !seperateAttachXml || (approvalFlag == "S" && docType == "004") || (approvalFlag == "G" && docType == "001") || docState == "012") {
					    	$.ajax({
		                		type : "POST",
		                		dataType : "text",
		                		async : false,
		                		url : "/ezApprovalG/aprLineSave.do",
		                		data : {
	               					ret    : getXmlString(xmlDoc)
	               				}
			                });
				    	}
		    	    }
	    	    }
		    	for (var i = 0; i < pCurSelRowSend.length; i++) {
		    		pDocID = pCurSelRowSend[i].getAttribute('DATA1');
		    		pHasAttachYN = pCurSelRowSend[i].getAttribute('DATA4');
		    		pHasOpinionYN = pCurSelRowSend[i].getAttribute('DATA5');
		    		pOrgDocID = pCurSelRowSend[i].getAttribute('DATA7');
		    		pDocTitle = pCurSelRowSend[i].children[1].title;
		    		pFormID = pCurSelRowSend[i].getAttribute('DATA16');
		    		pOrgCompanyID = pCurSelRowSend[i].getAttribute('orgcompanyid');
		    		pUrl = pCurSelRowSend[i].getAttribute('DATA3');
		    		pDocState = pCurSelRowSend[i].getAttribute('DATA9');
		    		pAprState = pCurSelRowSend[i].getAttribute('DATA10');
		    		docUrlType = (pUrl.substr(pUrl.length-3, pUrl.length)).toUpperCase(); 
		    		pDocType = pCurSelRowSend[i].getAttribute('DATA15');
		    		var curDeptId = pCurSelRowSend[i].getAttribute("DATA6");
		    		var curAprMemberSN = 1;
		    		var curAprType = "";
		    		var pMode = "";
		    		var seperateAttachXml = pCurSelRowSend[i].getAttribute("SEPERATEATTACHXML");
		    		var writerId = pCurSelRowSend[i].getAttribute("WRITERID");
		    		
		    		doc = createNodeAndAppandNode(xmlpara, list, doc, "DOC");
		            $.ajax({
		                  type : "POST",
		                  dataType : "text",
		                  async : false,
		                  url : "/ezApprovalG/getLineMode.do",
		                  data : {
		                          docID : pDocID,
		                          orgCompanyID : pOrgCompanyID
		                          },
		                  success: function(xml){
		                      pMode = xml;
		                  }        			
		            }); 
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCID", pDocID);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "FORMID", pFormID);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "ORGDOCID", pOrgDocID);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCTYPE", pDocType);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCSTATE", pDocState);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "FUNCTIONTYPE", strAprState2);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "HREF", pUrl); 
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCTITLE", pDocTitle);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCNO", "");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "HASATTACHYN", pHasAttachYN);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "HASOPINIONYN", pHasOpinionYN);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "STARTDATE", "DRAFT");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "ENDDATE", "DRAFT");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "WRITERID", writerId);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "WRITERNAME", "");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "WRITERJOBTITLE", "");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "WRITERDEPTID", "");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "WRITERDEPTNAME", "");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "HTML", "");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "ORGHTML", "");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "PUSERID", arr_userinfo[1]);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "PUSERNAME", arr_userinfo[2]);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "PDEPTID", arr_userinfo[4]);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "SECURITY", tempSecurity);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "KEEPPERIOD", tempKeep);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "PUBLICATION", tempPublic);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "PUBLIC", "");
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "ITEMCODE", tempItemCode);
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "ITEMNAME", tempItemName);
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "URGENTAPPROVAL", tempUrgent);
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "KEYWORD", tempKeyword);
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "XDOCID", "");
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "SPECIALRECORDCODE", pSpecialRecordCode);
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "PUBLICITYCODE", pPublicityCode);
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "PUBLICITYYN", pPublicityYN);
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "LIMITRANGE", pLimitRange);
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "PAGENUM", pPageNum);
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "CABINETID", cabinetID);
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "TASKCODE", TaskCode);
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCNUMCODE", "");
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "ORGDOCNUMCODE", "");
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "SUMMARY", "");
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "SECURITYAPPROVAL", "");
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "WRITERNAME2", "");
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "WRITERJOBTITLE2", "");
		    		createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "WRITERDEPTNAME2", "");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "PUSERNAME2", arr_userinfo[1]);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "ITEMNAME2", "");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "CURDOCNUM", "");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "PASSAPRLINE", "");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "ORGAPRUSERID", writerId);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "TYPE", docUrlType);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "orgCompanyID", pOrgCompanyID);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "APRMEMBERSN", curAprMemberSN);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "APRSTATE", pAprState);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "SEPERATEATTACHXML", "");
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "SEPERATEATTACHXMLFLAG", seperateAttachXml);
		            createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "RECEIPTFLAG", receiptFlag);

		            createNodeAndInsertText(xmlpara, objNode, "MODE", pMode);   
		    	}
		    	
		    	xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezApprovalG/receiptAllG.do", false);
		        xmlhttp.send(xmlpara);
		        var RtnVal = xmlhttp.responseText;

		        return RtnVal;
		    }
		    
		    // 사인칸 수 추출 및 저장
		    function getSignCount(selectRow) {
		    	var url = selectRow.getAttribute('DATA3');
		    	var urlType = url.substring(url.length-3).toUpperCase();
		    	var str = "";
		    	var signYn = false;
		    	var isreceiptNumber = false;
		    	var signCount = 0;
		    	
		    	if (urlType == "MHT") {
			    	str = ConvertMHTtoHTML(url);
			    	signYn = str.includes('1sign');
			    	isreceiptNumber = str.includes('receiptnumber');
			    	signCount = 0;
			    	
			    	if (signYn) { 
			    		signCount = (str.match(/1sign/g)).length;
		    		}
		    	} else {
		    		var key = "1sign";
		    		 $.ajax({
		    			type : "POST",
		     			dataType : "text",
		     			async : false,
		        		url : "/ezApprovalG/getHwpSignCount.do",
		        		data : {
			        				key : key,
			        				href : url 
		        				},
		        		success: function(result){
		        			signCount = result;
		        		}        			
			        });
		    	}
		    	
	    		if (signCount == 0) {
	    			return;
	    		}
	    		
	    		if (minSignCount == 0) { 
	    			minSignCount = signCount;
	    		}
	    		
	    		if (minSignCount >= signCount) {
	    			minSignCountInfo = [];
			    	var formTitle = (selectRow.childNodes[7]).getAttribute('title');
			    	minSignCountInfo.push(signCount, formTitle);
			    	minSignCount = signCount;
	    		}
		    }
		    
		    function getDocInfo() {
		    	var result = "";
		    	
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getDocInfo.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}        			
		    	});
		        
		        xmldoc = result;

		        var objNodes = GetChildNodes(result.documentElement);
		        if (objNodes) {
		            pOrgDocID = getNodeText(objNodes[2]);
		            if (getNodeText(objNodes[10]) == "Y" || getNodeText(objNodes[10]) == "O")
		                pHasOpinionYN = "Y";
		            tempSecurity = getNodeText(objNodes[19]);
		            tempKeep = getNodeText(objNodes[20]);
		            tempUrgent = getNodeText(objNodes[21]);
		            tempPublic = getNodeText(objNodes[18]);
		            tempKeyword = getNodeText(objNodes[25]);
		            tempItemCode = getNodeText(objNodes[23]);
		            tempItemName = getNodeText(objNodes[24]);
		            tempItemName2 = getNodeText(objNodes[37]);
		            pSummery = getNodeText(objNodes[35]);
		            pSpecialRecordCode = getNodeText(objNodes[26]);
		            pPublicityCode = getNodeText(objNodes[27]);
		            pLimitRange = getNodeText(objNodes[28]);
		            pPageNum = getNodeText(objNodes[29]);
		            pPublicityYN = getNodeText(objNodes[41]);
		            
		            if (approvalFlag == "G") {
		            	cabinetID = "";
		            	TaskCode = "";
		            } else {
		            	cabinetID = getNodeText(objNodes[30]);
		            	TaskCode = getNodeText(objNodes[31]);
		            }

		            tempSecurityDate = getNodeText(objNodes[36]);

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
			        		showAlert("비전자문서는 회송이 불가능 합니다.");
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
									showAlert(pAlertContent);
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
							showAlert("<spring:message code='ezApprovalG.bhs23'/>");
							getDocList();
							return;
	                	}
		                //OpenOpinionUI(pCurSelRow, "HeSong");
		                openOpinionUI_New(pCurSelRow, "HeSong");
		            }
			    }
		    }
		    var DocID_Complete;
		    var tempDocID;
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
					showAlert(pAlertContent);
		            return;
		        }
		        if (tr) {
		            var ret = CheckAprLineInfo(tr);
		            if (ret != "OK") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1727'/>" + "\n" +
		                            "<spring:message code='ezApprovalG.t1712'/>" + ret + "<spring:message code='ezApprovalG.t1713'/>";
		                //OpenAlertUI(pAlertContent);
						showAlert(pAlertContent);
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
		        	if(useWebHWP == "NO") {
			            if (/msie/i.test(navigator.userAgent)) {
							showAlert(strLang1103);
			                return;
			            } else if (!isIE()) {
							showAlert("한글양식은 IE에서만 발송할 수 있습니다.");
							return;
			            } else {
			                openLocation = "/ezApprovalG/ezSimsaG_HWP.do";
			            }
		        	} else {
		        		openLocation = "/ezApprovalG/ezSimsaG_WHWP.do";
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
							showAlert("'" + tr.getAttribute("DATA7") + "'부서의 문서입니다. \n'" + tr.getAttribute("DATA7") + "'부서로 겸직변경 후 대장등록해주시기 바랍니다.");
			            	return;
			            }
					} else if (pListTypeValue == "4" || pListTypeValue == "97") {
			            if (arr_userinfo[4] != tr.getAttribute("DATA6")) {
			            	showAlert("'" + tr.getAttribute("DATA6") + "'부서의 문서입니다. \n'" + tr.getAttribute("DATA6") + "'부서로 겸직변경 후 대장등록해주시기 바랍니다.");
			            	return;
			            }
					}
		            
		            var ret = CheckAprLineInfo(tr);
		            if (ret != "OK") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1727'/>" + "\n" +
		                            "<spring:message code='ezApprovalG.t1712'/>" + ret + "<spring:message code='ezApprovalG.t1713'/>";
		                //OpenAlertUI(pAlertContent);
						showAlert(pAlertContent);
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
					showAlert(pAlertContent);
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
					var openDocID = "";
					if (pListTypeValue == "98") {
						openDocID = tr.getAttribute("DATA2");
					} else {
						openDocID = tr.getAttribute("DATA1");
					}
// 		            window.open("/ezApprovalG/ezLineInfo.do?docID=" + openDocID + "&deptID=&docState=015", "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		            showPopup("/ezApprovalG/ezLineInfo.do?docID=" + openDocID + "&deptID=&docState=015", 1155, 460, "", "height=460px,width=1155px, left=" + left + "px, top=" + top + ", status = no, toolbar=no, menubar=no,location=no, resizable=1", hidePopup);
		        }
		        else {
                    OpenAlertUI("<spring:message code='ezApprovalG.t632'/>");
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
					OpenInformationUI("<spring:message code='ezApprovalG.t900002'/>" + "<spring:message code='ezApprovalG.kbh03'/>", btnApproveALL_onclick_Complete);
				}
			}

			function btnApproveALL_onclick_Complete(rtn) {
				DivPopUpHidden();
				if (rtn) {
					var aprAllType = document.getElementById("btnApproveALL").getAttribute("aprAllType");

					if (aprAllType == "LIST") {
						if (CheckUsePassword()) {
							chk_Passwd(arr_userinfo[1]);
							return;
						}
						else {
							chk_Passwd_Complete("TRUE");
						}
					} else {
						btnApproveALL_popup_onclick();
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
					OpenInformationUI(strLang930 + "<br>" + strLang336);
		            return;
		        }
		        
	            pDocID = tr[0].getAttribute("DATA1");
	            orgCompanyID = tr[0].getAttribute("orgCompanyID");
		        
	            if (orgCompanyID == null) {
	            	orgCompanyID = companyID;
	            }
	            
	            /* 2022-02-23 홍승비 - 일괄기안된 문서의 경우, 통합PC저장 불가능 */
	            var isGroupDoc = checkIsGroupDoc(pDocID, orgCompanyID); // 일괄기안문서 여부 체크 (1안 기준의 DOCID 전달)
	            if (isGroupDoc == "Y") {
	            	var pAlertContent = "일괄기안된 문서는 결재완료 이전에 통합 PC 저장이 불가능합니다.";
					showAlert(pAlertContent);
		            return;
	            }
	            
		        var mode = getDocMode(pDocID, orgCompanyID);
				var url = "totalSaveFileInfo.do?docID=" + pDocID + "&type=" + mode + "&orgCompanyID=" + orgCompanyID;
		        var feature = "status=no,help=no,scroll=no,edge=sunken,width=580px,height=480px";
		        
		        feature = feature + GetOpenPosition(580, 480);
		        // window.open(url, "", feature);
				showPopup(url, 580, 480, "", feature, DivPopUpHidden);
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
					showAlert("getDocMode() :: " + e.description);
		    	}
		    	
		    	return rtnVal;
		    }
		
		    // var setsearchinfo_cross_dialogArguments = new Array();
		    // var OpenWin2;
		    function SearchCondi_onclick() {
		        var para;
		        // setsearchinfo_cross_dialogArguments[0] = para;
		        // setsearchinfo_cross_dialogArguments[1] = SearchCondi_onclick_Complete;
		        // var type = "APR";
		        // OpenWin2 = window.open("/ezApprovalG/setSearchInfo.do?type=" + type+ "&searchType="+pListTypeValue, "setsearchInfo_Cross", GetOpenWindowfeature(510, 405));
		        // try { OpenWin2.focus(); } catch (e) { }
				ezCommon_cross_dialogArguments[0] = para;
				var url = "/ezApprovalG/setSearchInfo.do?type=APR&searchType=" + pListTypeValue;
				var height = approvalFlag == "S" ? 355 : 375;
				showPopup(url, 600, height, "setsearchInfo_Cross", GetOpenWindowfeature(600, 405), SearchCondi_onclick_Complete);
		    }
		
		    var SearchCond = new Array();

		    var SQLPARADATA;
		    function SearchCondi_onclick_Complete(returnvalue) {
				hidePopup();
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
		            else if (pListTypeValue == "4" || pListTypeValue == "5" || pListTypeValue == "97") {
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
			        if (SearchCond[0] != "" && SearchCond[0] !== undefined)		// DocNumber
			        {
			            TYPE += "DOCNO;";
			            DATA += "<DOCNO>" + SearchCond[0] + "</DOCNO>";
			        }
			
			        if (SearchCond[1] != "" && SearchCond[1] !== undefined)		// DocTitle
			        {
			            TYPE += "DOCTITLE;";
						SearchCond[1] = SearchCond[1].replace(/\\/g, "\\\\");
			            DATA += "<DOCTITLE>" + SearchCond[1] + "</DOCTITLE>";
			        }
			
			        if (SearchCond[2] != "" && SearchCond[2] !== undefined)		// DrafterName
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
			            TYPE += "FORMNAME;";
			            DATA += "<FORMNAME>" + SearchCond[21] + "</FORMNAME>";
			        }
			
			        if (SearchCond[23] != "" && SearchCond[23] !== undefined )		// draftDeptName
			        {
			            TYPE += "WRITERDEPTNAME;";
			            DATA += "<WRITERDEPTNAME>" + SearchCond[23] + "</WRITERDEPTNAME>";
			        }

			        // 2021-03-15 키워드 검색 추가 - 박기범
					if (SearchCond[24] != "" && SearchCond[24] !== undefined )
					{
						TYPE += SearchCond[24].slice(0,5);
						DATA += "<KEYWORD>" + SearchCond[24].slice(5) + "</KEYWORD>";
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

					SQLPARADATA = "<ROOT><TYPE>" + TYPE + "</TYPE><DATA>" + DATA + "</DATA></ROOT>";
			        
				} else {
					if (condition[0] != "" && condition[0] !== undefined) {
				        TYPE += "DOCNO;"
				        DATA += "<DOCNO>" + condition[0] + "</DOCNO>";
				    }

				    if (condition[1] != "" && condition[1] !== undefined) {
				        TYPE += "DOCTITLE;"
				        DATA += "<DOCTITLE>" + condition[1] + "</DOCTITLE>";
				    }

				    if (condition[2] != "" && condition[2] !== undefined) {
				        TYPE += "WRITERNAME;"
				        DATA += "<WRITERNAME>" + condition[2] + "</WRITERNAME>";
				    }

				    if (condition[3] != "" && condition[3] !== undefined) {
				        TYPE += "APRSTARTDATE;"
				        DATA += "<APRSTARTDATE>" + condition[3] + "</APRSTARTDATE>";
				    }

				    if (condition[4] != "" && condition[4] !== undefined) {
				        TYPE += "APRENDDATE;"
				        DATA += "<APRENDDATE>" + condition[4] + "</APRENDDATE>";
				    }

				    if (condition[5] != "" && condition[5] !== undefined) {
				        TYPE += "APRSTARTDATE;"
				        DATA += "<APRSTARTDATE>" + condition[5] + "</APRSTARTDATE>";
				    }

				    if (condition[6] != "" && condition[6] !== undefined) {
				        TYPE += "APRENDDATE;"
				        DATA += "<APRENDDATE>" + condition[6] + "</APRENDDATE>";
				    }

				    if (condition[9] != "" && condition[9] !== undefined) {
				        TYPE += "FORMNAME;"
				        DATA += "<FORMNAME>" + condition[9] + "</FORMNAME>";
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

					// 2021-03-15 키워드 검색 추가 - 박기범
					if (SearchCond[24] != "" && SearchCond[24] !== undefined )
					{
						TYPE += SearchCond[24].slice(0,5);
						DATA += "<KEYWORD>" + SearchCond[24].slice(5) + "</KEYWORD>";
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
				// console.log("SQLPARADATA : " + SQLPARADATA);
		    }
		
		    window.onresize = function () {
// 		        var height = parseInt(divList.style.height.replace('px', '')) + 200;
// 		        var reheight = document.documentElement.offsetHeight - parseInt(height);
// 		        if (reheight < 0) {
// 		            reheight = 0;
// 		        }
		
// 		        document.getElementById('div_AprLine').style.height = reheight + "px";

				/* 2022-06-24 홍승비 - 우측 미리보기 영역을 위한 리사이즈 동작 추가 */
		    	Window_resize();
		    	adjustLayerAlertPosition("iFramePanel");
		    };
		
		    function ShowMailProgress() {
		        document.getElementById("loadingPanel").style.display = "";
		        document.getElementById("loadingProgress").style.top = "400px";
		        document.getElementById("loadingProgress").style.left = (CurrentWidth / 2) - 100 + "px";
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
		        
		        var nowyear = nowDate.substring(0,4);
	            var nowmonth = nowDate.substring(5,7);
	            var nowday = nowDate.substring(8,10);      
		        
		        if (document.getElementById("txt_keyword").value != "") {
		            var selectSearch = document.getElementById('selectType');
		            /* 2022-11-07 강동주 - 우측 상단 간단검색 시 "최근 1년" 셀렉트박스 값이 적용되지 않는 오류 수정 */
		            // var selectYearVal = document.getElementById('sel_year').value;
					
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
			           
			            // 년도 파라미터 설정 추가
			            if (selectYearVal != "ALL") {
							SearchCond[3] = selectYearVal;
							SearchCond[4] = "01";
							SearchCond[5] = "01";
							SearchCond[6] = selectYearVal;
							SearchCond[7] = "12";
							SearchCond[8] = "31";
				        } else { // 최근 1년
							SearchCond[3] = nowyear - 1;
							SearchCond[4] = nowmonth;
							SearchCond[5] = nowday;
							SearchCond[6] = nowyear;
							SearchCond[7] = nowmonth;
							SearchCond[8] = nowday;
				        }
					} else {
						for (i = 0; i < 11; i++) {
							condition[i] = "";
						}

		                if (selectSearch.item(0).selected) {
		                	condition[1] = replaceCond(document.getElementById("txt_keyword").value);
		                }
		                else if (selectSearch.item(1).selected) {
		                	condition[2] = replaceCond(document.getElementById("txt_keyword").value);
		                }
		                
		                // 년도 파라미터 설정 추가
				        if (selectYearVal != "ALL") {
				        	condition[3] = selectYearVal + "-01-01";
							condition[4] = selectYearVal + "-12-31";
				        } else { // 최근 1년
							condition[3] = (nowyear - 1) + "-" + nowmonth + "-" + nowday;
							condition[4] = nowyear + "-" + nowmonth + "-" + nowday;
				        }
					}
		        }
		        else {
					showAlert("<spring:message code='ezApprovalG.t1160'/>");
		            return;
		        }
		        pageNum = 1;
		        MakeSubCondition();
				listLoading(true);
		        if (pListTypeValue == "1") {
		            getDocList();
		        }
		        else if (pListTypeValue == "2") {
		            getDocList();
		        }
		        else if (pListTypeValue == "3") {
		            getDocList();
		        }
		        else if (pListTypeValue == "4" || pListTypeValue == "5" || pListTypeValue == "97") {
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
		
		        $('#sel_year').val(selectYearVal);
		        /* $('#sel_year').selectmenu('refresh'); */
		    }
		    
		    var SelUserCont_dialogArgument = new Array();
		    function btnRegUserCont_onclick() {
		        SelUserCont_dialogArgument[0] = "";
		        SelUserCont_dialogArgument[1] = RegUserCont_Complete;
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
					showAlert(InformationString);
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
		    	return condStr.toString().replace(/\\/g, "\\\\").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/%/g, "\\%").replace(/'/g, "\\'").replace(/_/g, "\\_");
		    }
		    
		    function getDocListByCompany(){
		    	pageNum = 1;
		    	getDocList();
		    }
		    function initselyear() {
		        $('#sel_year').selectmenu('close');
		    }
		    
		    /*2021-04-07 홍승비 - MHT양식의 비전자문서등록 추가 */
			<%-- 비전자문서 등록 --%>
			function btnNonElecRec_onclick() {
				if (pNonElecRecType.toUpperCase() == "MHT") {
					var url = "/ezApprovalG/draftui.do?formURL=";
				    var form = "/files/upload_approvalG/form/2021000000.mht";
				    var docInfo = "&draftFlag=DRAFT&formDocType=003&susinSN=0&docState=&listType=4&aprState=&isTmpDoc=&nonElecRec=Y";
				   	window.open(url + form + docInfo, "", GetOpenWindowfeature(1145, 1000));
				}
				else { // 기존 HWP
					if (useWebHWP == "NO") {
						if (isIE()) {
							var url = "/ezApprovalG/draftuiHWP.do?formURL=";
						    var form = "/files/upload_approvalG/form/2018000000.hwp";
						    var docInfo = "&draftFlag=DRAFT&formDocType=003&susinSN=0&docState=&listType=4&aprState=&isTmpDoc=&nonElecRec=Y";
						   	window.open(url + form + docInfo, "", GetOpenWindowfeature(1145, 1000));
		                } else {
		                	showAlert("비전자문서 등록은 IE에서만 가능합니다.");
		                }
					}
					else {
						var url = "/ezApprovalG/draftuiWHWP.do?formURL=";
					    var form = "/files/upload_approvalG/form/2018000000.hwp";
					    var docInfo = "&draftFlag=DRAFT&formDocType=003&susinSN=0&docState=&listType=4&aprState=&isTmpDoc=&nonElecRec=Y";
					   	window.open(url + form + docInfo, "", GetOpenWindowfeature(1145, 1000));
					}
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
			
			/* 2022-06-29 홍승비 - 결재할문서에서 체크박스를 해제하는 경우, 미리보기 iframe 영역에서 정보를 얻도록 분기처리 */
			function btn_newpopup() {
				var SelList = new ListView();
		        SelList.LoadFromID("DocList");
		        var oArrRows = SelList.GetSelectedRows();
		        
				if (oArrRows > 0) {
					lvDocList_DBSelChange();
				} else {
					var iframePrev = document.getElementById("ifrmPreViewH");
					if (iframePrev != null) {
						var openLocation = iframePrev.src.replace("&isPreview=Y", ""); // 미리보기가 아닌 팝업으로 열게 되므로, url 수정
						openwindow(openLocation, "", 880, 570);
					}
				}
			}
			
			/* 2023-06-20 조소정 - 전자결재(G/일반) 공람할문서 일괄공람 / 회람수신함 일괄회람 함수 추가 */
			function btnGongRamALL_onclick() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var pCurSelRow = DocList.GetSelectedRows();
		        
		        if (pCurSelRow.length == 0) {
		            var pAlertContent = strLang930 + "<br>" + strLang336;
		            OpenAlertUI(pAlertContent);
				} else {
					if (approvalFlag == "G") {
						OpenInformationUI("<spring:message code='ezApprovalG.CSJBDA02'/>", btnGongRamALL_onclick_complete);
					}
					else {
						OpenInformationUI("<spring:message code='ezApprovalG.CSJBDA04'/>", btnGongRamALL_onclick_complete);
					}
				}
			}

			function btnGongRamALL_onclick_complete(Rtnval) {
				if (Rtnval === true) {
					var DocList = new ListView();
					DocList.LoadFromID("DocList");
					var pCurSelRow = DocList.GetSelectedRows();

					var userID = arr_userinfo[1];
					var docIDArray = [];
					var orgCompanyIDArray = [];
					var tempValue = "";
					var rtnVal = "";

					$(pCurSelRow).each(function(idx, curRow) {
						docIDArray.push($(this).attr("DATA1"));
						orgCompanyIDArray.push($(this).attr("orgCompanyID"));
					});

					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezApprovalG/gongRamAllUpdate.do",
						data : {
							userID : userID,
							docIDArray : docIDArray,
							orgCompanyIDArray : orgCompanyIDArray
						},
						success : function(result) {
							rtnVal = result.split("/");
							tempValue = "TRUE";
						},
						error : function(e) {
							console.log(e);
						}
					});
					
					if (tempValue == "TRUE") {
						if (approvalFlag == "G") {
							OpenAlertUI(strLang933 + rtnVal[0] + strLang934 + strLang935 + rtnVal[1] + strLang934_1 + strLangCSJBDA01, OpenAlertUI_Close);
						}
						else {
							OpenAlertUI(strLang933 + rtnVal[0] + strLang934 + strLang935 + rtnVal[1] + strLang934_1 + strLangCSJBDA03, OpenAlertUI_Close);
						}
					} 
					else {
						if (approvalFlag == "G") {
							OpenAlertUI(strLangCSJBDA02, OpenAlertUI_Close);
						}
						else {
							OpenAlertUI(strLangCSJBDA04, OpenAlertUI_Close);
						}					
					}
				} else {
					DivPopUpHidden();
				}
			}
            
			// var ezreceivejijungall_cross_dialogArguments = new Array();
			function btnJiJungAll_onclick() {
				var DocList = new ListView();
				DocList.LoadFromID("DocList");
				var selRows = DocList.GetSelectedRows();

				if (selRows.length == 0) {
					var pAlertContent = strLang930 + "<br>" + strLang336;
					OpenAlertUI(pAlertContent);
					return;
				} else{
					OpenInformationUI(strLangKMH01, btnJiJungAll_onclick_Complete);
				}
			}

			function btnJiJungAll_onclick_Complete(rtn) {
				if(rtn) {
					DivPopUpHidden();
					var DocList = new ListView();
					DocList.LoadFromID("DocList");
					var selRows = DocList.GetSelectedRows();

					var progressCount = selRows.length;
					var excludeCount = 0;

					var JDocID = "";
					var JSusinSN = "";
					var JAprState = "";
					var JDocState = "";
					var JOrgCompanyID = "";

					for (var i = 0; i < progressCount; i++) {
						if ((selRows[i].getAttribute("data1") == null || selRows[i].getAttribute("data1") === undefined || selRows[i].getAttribute("data1").trim() === "") || (selRows[i].getAttribute("data2") == null || selRows[i].getAttribute("data2") === undefined || selRows[i].getAttribute("data2").trim() === "")) {
							OpenAlertUI(strLang721);
							return; 
						}
						
						JDocID += selRows[i].getAttribute("data1") + ",";
						JSusinSN += selRows[i].getAttribute("data2") + ",";
						JAprState += selRows[i].getAttribute("data10") && selRows[i].getAttribute("data10").trim() !== "" ? selRows[i].getAttribute("data10") + "," : "[Nodata],";
						JDocState += selRows[i].getAttribute("data9") && selRows[i].getAttribute("data9").trim() !== "" ? selRows[i].getAttribute("data9") + "," : "[Nodata],";
						JOrgCompanyID += selRows[i].getAttribute("orgcompanyid") && selRows[i].getAttribute("orgcompanyid").trim() !== "" ? selRows[i].getAttribute("orgcompanyid") + "," : "[Nodata],";
						
						if (selRows[i].getAttribute("data10") == "015" || selRows[i].getAttribute("data9") == "012") {
							excludeCount++;
						}
					}

					if (excludeCount == progressCount) {
						OpenAlertUI(strLang721);
						return;
					}

					var parameter = new Array();
					parameter[0] = JDocID;
					parameter[1] = JSusinSN;
					parameter[2] = JAprState;
					parameter[3] = JDocState;
					parameter[4] = "";
					parameter[5] = JOrgCompanyID;
					// ezreceivejijungall_cross_dialogArguments[0] = parameter;

					DivPopUpHidden();
					// OpenPopupWin = window.open("/ezApprovalG/ezReceiveAssignUI.do?mode=ALL", "", GetOpenWindowfeature(800, 620));
					// try { OpenPopupWin.focus(); } catch (e) { }
					ezCommon_cross_dialogArguments[0] = parameter;
					showPopup("/ezApprovalG/ezReceiveAssignUI.do?mode=ALL", 800, 620, "", GetOpenWindowfeature(800, 620), btnJiJungAll_onclick_Complete_afterPopup);
				} else {
					DivPopUpHidden();
				}
			}
			
			function btnJiJungAll_onclick_Complete_afterPopup(rtn) {
				hidePopup();
				
				if (rtn == "true") {
					if (pListTypeValue == "97") {
						window.parent.frames[0].convMain('97', '');
					} else {
						window.parent.frames[0].convMain('4', '');
					}
				}
			}
			
			/* 2024-06-28 양지혜 - 전자결재 > 부서수신함 > 지정목록 */
			var assignChk = "N";
			var assignPermission = "<c:out value = '${assignPermission}'/>";
			function btnAssignList_onclick() {
				assignChk = "Y";
				getReceivedDocList();
				$('#sel_status_div').closest("li").hide();
			}
			function btnDeptRecevList_onclick() {
				assignChk = "N";
				getReceivedDocList();
				$('#sel_status_div').closest("li").show();
			}

			/* 2024-06-28 양지혜 - 전자결재 > 부서수신함 > 지정목록 > 지정
			* 리스트에서 선택한 문서를 바로 지정할 수 있도록 함 */
			var ezreceiveassignui_cross_dialogArguments = new Array();
			function btnAssign_onclick2() {
				var DocList = new ListView();
				DocList.LoadFromID("DocList");
				var oArrRows = DocList.GetSelectedRows();
				var pCurSelRow = oArrRows[0];

				var parameter = new Array();
				parameter[0] = pCurSelRow.getAttribute("DATA1"); //pDocID;
				parameter[1] = pCurSelRow.getAttribute("DATA2"); //pSusinSN;
				parameter[2] = pCurSelRow.getAttribute("DATA10") //pAprState;
				parameter[3] = pCurSelRow.getAttribute("DATA9"); //pDocState;
				parameter[4] = ""; //REDIRECTYN
				parameter[5] = pCurSelRow.getAttribute("ORGCOMPANYID") //orgCompanyID;

				ezreceiveassignui_cross_dialogArguments[0] = parameter;
				ezreceiveassignui_cross_dialogArguments[1] = btnAssign_onclick_Complete;

				DivPopUpShow(800, 600, "/ezApprovalG/ezReceiveAssignUI.do");
				// 지정선택 창 떠있는 동안은 스크롤 비활성화
				parent.frames[1].frameElement.setAttribute('scrolling','no');
			}

			function btnAssign_onclick_Complete(ret) {
				parent.frames[1].frameElement.setAttribute('scrolling','auto'); // 스크롤 활성화
				DivPopUpHidden();
				if (ret == "OK") {
					var pAlertContent = "<spring:message code='ezApprovalG.t1420'/>";
					OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
				} else if (ret == "DUPL") {
					showAlert("<spring:message code='ezApprovalG.bhs23'/>", "");
					// window.close();
				}
			}
			
			function btnRemoveDoc_onclick_afterConfirm(rtn) {
				var oArrRows = ezCommon_cross_dialogParams[0];
				hideConfirm();
				/* 2020-08-27 홍승비 - 체크박스로 다중선택된 반송(004), 회송(015), 회수(006)문서의 다중삭제가 가능하도록 수정 */
				if (rtn) {
					var pCurSelRow = "";
					var pFunctionType = "";
					var pDocState = "";

					for (var i = 0; i < oArrRows.length; i++) {
						pCurSelRow = oArrRows[i];
						pFunctionType = GetAttribute(pCurSelRow, "DATA10"); // DATA10 = APRSTATE(FUNCTIONTYPE)
						pDocState = GetAttribute(pCurSelRow, "DATA12"); // DATA9 = 수신문 관련 플래그, DATA12 = DOCSTATE

						// 내부결재가 아닌 수신문(011), 합의문(012)의 경우 삭제 불가능, 재기안만 가능함 + 임시보관함의 경우 전부 삭제 가능
						// 부서수신함과 발송의뢰문서(pListTypeValue == "4"/"6")의 경우, 회송된 수신문과 합의문 모두 삭제 가능함 (G버전은 부서수신함에서 회송 시 상태만 변하고 문서는 리스트 상에 남아있음)
						if ((pListTypeValue == "21") || (pListTypeValue == "10") ||
								((pFunctionType == "004" || pFunctionType == "006" || pFunctionType == "015") && ((pListTypeValue == "4" || pListTypeValue == "97") || (pListTypeValue == "6") || (GetAttribute(pCurSelRow, "DATA9") == "0" && pDocState != "011" && pDocState != "012")))) {
							if (pListTypeValue == "1" || pListTypeValue == "11" || pListTypeValue == "2") {
								if (checkAprState(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("DATA12"), pCurSelRow.getAttribute("DATA4"), pCurSelRow.getAttribute("APRMEMBERSN"), pCurSelRow.getAttribute("ORGCOMPANYID"))){
									showAlert("<spring:message code='ezApprovalG.bhs23'/>");
									getDocList();
									return;
								}
							}

							/* 2022-02-10 홍승비 - 문서 삭제 시 일괄기안 그룹정보 레코드도 함께 삭제 (1안의 DOCID / DOCSN 기준으로 GROUPDOCSN 찾아서 삭제함)*/
							isGroupDoc = checkIsGroupDoc(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("ORGCOMPANYID"));
							if (isGroupDoc == "Y") {
								// 해당 일괄기안그룹에 속한 문서들은 루프를 돌며 전부 삭제한다.
								var groupDocList = getGroupDocListByDocID(pCurSelRow.getAttribute("DATA1"));
								groupDocListCnt = groupDocList.length;
								groupDocDelCnt = 0;

								for (var g = 0; g < groupDocList.length; g++) {
									// 삭제완료 알러트는 한번만 표출하도록 내부 분기 추가함
									if (pListTypeValue == "21") {
										RemoveTmpDoc(groupDocList[g]);
									} else {
										RemoveDoc(groupDocList[g], pCurSelRow.getAttribute("orgcompanyid"));
									}
								}
								// 문서정보 삭제 루프 이후, 일괄기안 그룹 레코드는 전체적으로 삭제한다.(GROUPDOCSN조건으로 삭제, mode = ALL)
								delGroupDocInfoByDocID(draftAllTypeB == "Y" ? pCurSelRow.getAttribute("DATA3").substr(pCurSelRow.getAttribute("DATA3").lastIndexOf(".") - 20, 20) : pCurSelRow.getAttribute("DATA1"), "ALL");
							}
							// 일괄기안 그룹이 아닌 경우, 기존 삭제 분기 동작
							else {
								if (pListTypeValue == "21") {  //[한양대] 추가 사항 (서버 임시저장하기)
									RemoveTmpDoc(pCurSelRow.getAttribute("DATA1"));
								} else if (pListTypeValue == "10") {	// 공람완료문서 삭제기능
									RemoveGongramDoc(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("aprmembersn"));
								} else {
									RemoveDoc(pCurSelRow.getAttribute("DATA1"), pCurSelRow.getAttribute("orgcompanyid"));
								}
							}
						}
					}

					if (pListTypeValue == "4" || pListTypeValue == "97") {
						getReceivedDocList();
					} else if (pListTypeValue == "6") {
						getSimsaDocList();
					} else {
						getDocList();
					}

					parent.frames["left"].getAprCount();
				}
			}
		</script>
	</head>
	<body class="mainbody" style="margin-top:0px; overflow:auto;" marginwidth="0" marginheight="0" onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">	
		<h1 class="title_h1">
			<span id="presentcell"></span><span id="TitleInfo" style="color:#666;font-weight:normal;"></span>
		    <span class="searchForm">
		    	<select id="selectType" class="text" style="width:80px; height:27px; border-color: #c8c8c8;">
		    		<option selected value="rad_Subject"><spring:message code='ezApprovalG.t106'/></option>
		    		<option value="rad_Writer"><spring:message code='ezApprovalG.t445'/></option>
		    	</select>
			    <input id="txt_keyword" class="searchinputBox" style="height: 27px;border: 1px solid #cbcbcb;" onkeypress="onkeydown_start_search();" onselectstart="event.cancelBubble=true;event.returnValue=true"  onmousedown="keyword_Clear();"/> 
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
				<li id="tbtnSimsa" style="DISPLAY:none"><span id="btnSimsa" onclick="return btnSimsa_onclick()" ><spring:message code='ezApprovalG.t214'/></span></li>
				<li id="tbtnReceiptAll" style="DISPLAY:none"><span id="btnReceiptAll" onclick="return btnReceiptAll_onclick()" ><spring:message code='ezApprovalG.lgeAR01'/></span></li>
				<li id="tbtnRJunkyulAll" style="DISPLAY:none"><span id="btnRJunkyulAll" onclick="return btnRJunkyulAll_onclick()" ><spring:message code='ezApprovalG.lgeAR02'/></span></li>
				<li id="tbtnJiJungAll" style="DISPLAY:none"><span id="btnJiJunglAll" onclick="return btnJiJungAll_onclick()" ><spring:message code='ezApprovalG.JKMH01'/></span></li>
				<li id="tbtnBebuAll" style="DISPLAY:none"><span id="btnBebuAll" onclick="return btnBaeBuAll_onclick()" ><spring:message code='ezApprovalG.bebuAll01'/></span></li>
				<li id="tbtnRegList" class="approvalG"><span id="btnAddCabinet" onclick="return btnAddCabinet_onclick()" ><spring:message code='ezApprovalG.t933'/></span></li>
				<li id="tbtnUserInfo" style="DISPLAY:none"><span id="btnUserInfo" onclick="return btnUserInfo_onclick()" ><spring:message code='ezApprovalG.t1741'/></span></li>
				<c:if test="${approvalFlag == 'G'}">
					<li id="tDocInfo"  class="approvalG"><span id="DocInfo" onclick="return GongRamDocInfo()" ><spring:message code='ezApprovalG.t946'/></span></li>
					<li id="tdGongRam" style="display:none"><span id="GongRam" onclick="return btnSendAround_onclick()"><spring:message code='ezApprovalG.t1428'/></span></li>		
					<li id="tbtnGongRam"><span id="btnGongRam" onclick="return btnViewDoc_onclick()" ><spring:message code='ezApprovalG.t1442'/></span></li>
					<li id="tbtnGongRamALL" style="display:none"><span id="btnGongRamALL" onclick="return btnGongRamALL_onclick()" ><spring:message code='ezApprovalG.CSJBDA01'/></span></li>
				</c:if>
				<c:if test="${approvalFlag != 'G'}">
					<li id="tDocInfo"  class="approvalG"><span id="DocInfo" onclick="return GongRamDocInfo()" ><spring:message code='ezApprovalG.sendGongram03'/></span></li>
					<li id="tdGongRam" style="display:none"><span id="GongRam" onclick="return btnSendAround_onclick()"><spring:message code='ezApprovalG.hyj25'/></span></li>		
					<li id="tbtnGongRam" style="DISPLAY:none"><span id="btnGongRam" onclick="return btnViewDoc_onclick()" ><spring:message code='ezApprovalG.hyj21'/></span></li>
					<li id="tbtnGongRamALL" style="display:none"><span id="btnGongRamALL" onclick="return btnGongRamALL_onclick()" ><spring:message code='ezApprovalG.CSJBDA03'/></span></li>
				</c:if>
				<li id="tbtnViewDoc" style="DISPLAY:none"><span id="btnViewDoc" onclick="return btnViewDoc_onclick()" ><spring:message code='ezApprovalG.t367'/></span></li>
				<li id="tbtnAssignList" style="display:none"><span id="btnAssignList" onclick="return btnAssignList_onclick()"><spring:message code='ezApprovalG.yjh06'/></span></li>
				<li id="tbtnAssign" style="display:none"><span id="btnAssign" onClick="return btnAssign_onclick2()"><spring:message code='ezApprovalG.t1430'/></span></li>
				<li id="tbtnDeptRecevList" style="display:none"><span id="btnDeptRecevList" onclick="return btnDeptRecevList_onclick()"><spring:message code='ezApprovalG.t1749'/></span></li>
		        <li id="tbtnTotalSave" style="DISPLAY:none"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
		        <li id="tSearchCondi" style="DISPLAY:none"><span class="icon16 icon16_search" id="SearchCondi" onclick="return SearchCondi_onclick()"></span></li>
		        <%-- <li id="tSecondApproval" class="approvalG"><span id="btnSecondApproval" onclick="return btnSecondApproval()"><spring:message code='ezApprovalG.t26'/><spring:message code='ezApprovalG.t54'/></span></li> --%>
		        <li id="tbtnRemoveDoc" style="DISPLAY:none"><span class="icon16 icon16_delete" id="btnRemoveDoc" onclick="return btnRemoveDoc_onclick()"></span></li>
		        <!-- <li style="background: none; padding-right: 2px;"><img src="/images/i_bar.gif"></li> -->
		       
		       <%-- 전자결재 우측 미리보기 상단 아이콘 --%>
		        <div id="right" class="sub_frameIcon" <c:if test="${useAprPreview != 'YES'}">style="display:none;"</c:if>>	
					<div class="sub_frameIconUL" style="width:auto !important;">
					   	<p class="frameIconLI"><span class="icon16 btn_noframe" id="PreViewNone" onclick="PreviewRayerChange('NONE', 'Manage')"></span></p>
					    <p class="frameIconLI"><span class="icon16 btn_leftframe" id="PreViewleft" onclick="PreviewRayerChange('H', 'Manage')"></span></p>
					</div>
				</div>
				
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
		        <c:if test="${fn:length(companyList) gt 1 and listType ne '4' and listType ne '21' and listType ne '97'}">
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
		
		<%-- 리사이즈 바 클릭 시의 음영을 위한 부분 --%>
 		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="ResizeBarPanel"></div>
	    <div style="width: 8px; height:738px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
		<span id="MailListRayer" style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: inline-block;">
			<div class="div_scroll" style="width:100%;HEIGHT:480px; overflow-y:auto; overflow-x:auto; margin-bottom:10px" id="divList">
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
					<c:if test="${approvalFlag == 'G'}">
					   	<p><span id="tagsub5"><spring:message code='ezApprovalG.LJEAppr06'/></span></p>
					</c:if>
			  	</div>
			</div>
			
			<div style="WIDTH:100%;HEIGHT:171px; font-size:92%; OVERFLOW-Y:AUTO;" id="div_AprLine">
				<div id="lvAprLine" ></div>
			</div>
			<div style="width: 100%; height: 100%; position: fixed; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
			<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
				<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
			</div>
			<form id="formAPP">
		        <input type="hidden"  id="APPXML" name="APPXML" />
		    </form>
	    </span>
	    
	    <%-- 전자결재 우측 미리보기 영역 --%>
	    <div id="PreviewRayerH" style="border:0px; width:500px; height:100%; overflow:hidden; vertical-align:top; display:none; margin-left:-5px;">
	        <div class="previewmail_bar_h" id="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor: w-resize; display: inline-block; height:753px;">
	            <p class="hbar_dotted">
	                <img src="/images/prevview_hbar_dotted.gif">
	            </p>
	        </div>
	        <div id="PreContent_RayerH" style="position: absolute; border: 0px; margin-left:7px;">
	            <div class="previewmail"> 
	            	<div class="previewmail_info"></div>
	                <iframe id="ifrmPreViewH" name="ifrmPreViewH" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 738px; border: solid 0px green; display: inline-block;"></iframe>
	            </div>
	        </div>
	    </div>
	    
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel2">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel2">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer2"></iframe>
		</div>
		
	    <script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			//selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
			Tab1_NewTabIni("tab1");
		</script>
	</body>
</html>
