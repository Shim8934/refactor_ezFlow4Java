<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t367'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style>
			.contentlist_layout {
    			padding: 0px 15px;
    			box-sizing: border-box;
			}
			.contentlist_layout {
    			padding: 0px 15px;
    			box-sizing: border-box;
			}
			
			.tab_menu {
    			clear: both;
    			height: 30px;
    			margin: 0px 0px -1px 0px;
    			padding: 0px 0px 0px 1px;
   		 		border-bottom: 1px solid #d4d4d4;
			}
			.tab_menuBox {
    			height: 31px;
    			margin-bottom: -1px;
    			overflow: hidden;
			}
			.tab_menu dt {
    			float: left;
   				margin: 0px;
    			padding: 0px;
			}
			.tab_menu dt span {
			    display: block;
			    height: 29px;
			    line-height: 29px;
			    padding: 0px 20px;
			    margin: 0px 0px 0px -1px;
			    border: 1px solid #d4d4d4;
			    border-bottom: 0 none;
			    background: #e7e7e7;
			    font-size: 12px;
			    font-weight: bold;
			    color: #777;
			    cursor: pointer;
			}
			.tab_menu dt:hover span {
    			position: relative;
    			border: 1px solid #828282;
    			border-bottom: 1px solid #ffffff;
    			background: #ffffff;
    			color: #333;
			}
			.tab_menu dt.on span {
    			position: relative;
    			border: 1px solid #828282;
    			border-bottom: 1px solid #ffffff;
    			background: #ffffff;
    			color: #333;
			}
			
			dl {
    			display: block;
    			margin-block-start: 1em;
    			margin-block-end: 1em;
    			margin-inline-start: 0px;
    			margin-inline-end: 0px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AprDocView_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/html2canvas.js')}"></script>
	    <script type="text/javascript">
	        var docID = "<c:out value='${docID}'/>";
	        var docHref = "<c:out value='${docHref}'/>";
	        var opinionFlag = "<c:out value='${opinionFlag}'/>";
	        var listTypeValue = "<c:out value='${listTypeValue}'/>";
	        var listSusin = "<c:out value='${listSusin}'/>";
	        var pDocState = "<c:out value='${docState}'/>";
	        var pOrgDocID = "<c:out value='${orgDocID}'/>";
	        var isOpinion = "<c:out value='${showOpinion}'/>";
	        var pDocID;
	        var pDocHref;
	        var pOpinionFlag;
	        var pUserID;
	        var pListTypeValue;
	        var arrPrevDoc = new Array();
	        var arrNextDoc = new Array();
	        var flag = false;
	        var pOrgDocHref;
	        var pDocTitle;
	        var AppendFileAttach = "";
	        var AppenAprDocAttachList = "";
	        var ext = "hwp";
	
	        var arr_userinfo = new Array();
	        arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "<c:out value='${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value='${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value='${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value='${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value='${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value='${userInfo.jikChek}'/>";
		    arr_userinfo[7]  = "N";
		    arr_userinfo[8]  = "<c:out value='${userInfo.email}'/>";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "<c:out value='${susinAdmin}'/>";
		    var pCompanyID = "<c:out value='${userInfo.companyID}'/>";
		    arr_userinfo[11]  = "<c:out value='${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value='${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value='${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value='${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value='${userInfo.deptName1}'/>";
			arr_userinfo[16]  = "<c:out value='${userInfo.deptName2}'/>";
		    
	        pUserID = arr_userinfo[1];
	
	        var pHasOpinion = "<c:out value='${hasOpinionYN}'/>"; // 1안에 대한 의견존재여부 플래그
			var pOpinionType = "Show";
			var pUse_Editor = "<c:out value='${useEditor}'/>";
			var approvalFlag = "<c:out value='${approvalFlag}'/>";
			var orgCompanyID = "<c:out value='${orgCompanyID}'/>";
			
			var useExternalMailServer = "<c:out value='${useExternalMailServer}'/>";
			var forceCallBackYN = "<c:out value='${forceCallBackYN}'/>";
			var useWebHWP = "<c:out value='${useWebHWP}'/>";
			
	        // 대용량첨부 관련
	        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
	        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
	        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";
	        
			// 일괄기안 관련
			var draftAllFlag = "Y";
			var groupDocSN = "<c:out value ='${groupDocSN}'/>"; // 일괄기안된 문서가 가지는 TBL_APRDOCGROUPINFO의 GROUPDOCSN값 (1안의 DOCID)
			var pDocHrefAry = new Array();
	        var pDocIDAry = new Array();
	        var pDocTypeAry = new Array();
	        var extAry = new Array();

			var currentTabIdx = 0; // 안별 탭 구분용 인덱스 (현재 선택됨)
			var allTabNum = "<c:out value ='${groupDocInfoListCnt}'/>"; //  현재 안의 갯수 (groupDocInfoListCnt)
			var wh = window.innerHeight - 100;
			
			var HwpCtrl = "";
			var lstAttachLink = ""; // 안별로 첨부파일 등의 관리를 위한 변수 
    		var docLoadCompleteCnt = 0; // 각 안의 문서들이 로딩되었는지 판단하기 위한 카운트 변수
    		// 초기 문서 로딩 시 사용하며, 초기 문서 로딩을 전부 완료한 후에는 더이상 카운트를 증가시키지 않는다.
    		
    		// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = "${useAprFilePrvw}";
			
			// 2024-01-11 김우철 - 다안기안문서 전체 탭 호출 후 selTab(1)을 위한 setTimeout 시간
			var loadTime = "${loadTimeForApprAll}";
			var ReturnFunction;
    		
			function btnOpinion_onclick() {
				openOpinionUI_New("Show");
			}
			
			function btnOpinion_onclick_complete(Ans) {
			    DivPopUpHidden();
    			if (Ans) {
					openOpinionUI_New("Show");
			    }
			}
	
			window.onresize = function () {
	       		getReSize();
				// 자식 iframe은 자기 자신을 리사이즈 할수 없으므로, 부모창에서 대신 조절함
					$(".tab_container").find("iframe").each(function(index, item) {
						this.contentWindow.Resize();
					});
	        }
	
			function window_onload() {
			    if (docHref == "") {
			        var pAlertContent = "<spring:message code='ezApprovalG.t1439'/><br><spring:message code='ezApprovalG.t1440'/>";
				    OpenAlertUI(pAlertContent);
				    btnClose_onclick();
				    return;
				}

				try {
					if (isParentCommonArgsUsed()) {
						ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
					}
				} catch (e) { }
			
			    /*
			    if (pDocState == "015" && pOrgDocID.length >= 20 && "<c:out value='${listTypeValue}'/>" == "99") {
			        btnGongRam.style.display = "none"; // 일괄기안 전용창에서는 공람지정불가 (애초에 공람할문서에서 일괄기안창 진입 불가하므로 listTypeValue가 99가 될 수 없음)
			        pOpinionType = "";
			    }
			    */
			    
			 // 1안을 의미하는 [1] 인덱스 부터 배열 데이터가 들어가도록, [0]에는 공백 데이터를 부여함
				pDocIDAry.push("");
				pDocHrefAry.push("");
				pDocTypeAry.push("");
				extAry.push("");

            <c:forEach items="${groupDocInfoList}" var="item">
           		pDocIDAry.push("${item.docID}");
           		pDocHrefAry.push("${item.docHref}"); // 문서경로
    			pDocTypeAry.push("${item.docType}"); // 문서타입 (내부결재, 수신문...)
    			extAry.push("${item.docHref}".substring("${item.docHref}".lastIndexOf(".") + 1));
    		</c:forEach>
    			
			    pDocID = docID;
			    pDocHref = docHref;
			    pOpinionFlag = opinionFlag;
			    pListTypeValue = listTypeValue;
			    if (pListTypeValue == "4" || pListTypeValue == "97") {
					pListSusin = listSusin;
				}
			    
				cancelYN(); // 강제회수버튼 제어
				//returnYN(); // 회송버튼 제어 (수신문서에 대한 기능으로, 일괄기안문서 보기 전용창에서는 지원안함)
				
				// 각 안별 탭 생성 및 로딩 진행
    			makeTabs();
				
				if (useExternalMailServer == "NO") {
					$("#btnMail").css("display","");
				}
    			
    			// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가 (부모창)
				setAttachGuideText();
			}
	
			// 웹 한글 기안기용 (각 안별 iframe에서 부모창의 함수를 동작시킴)
	    	function Editor_Complete(iframeID, docHref) {
	    		var iframe = document.getElementById(iframeID);
	    		
	    		if (iframe == null || typeof(iframe) == "undefined") {
	    			return;
	    		}
	    		
	    		var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(docHref);
                iframe.contentWindow.Open(URL, "", "", function (res) {iframe.contentWindow.FieldsAvailable(res.result);}, null);
			}
	
			function btnPrint_onclick() {
				var formFileLocation = pDocHrefAry[currentTabIdx];
				var currentExt = formFileLocation.substring(formFileLocation.lastIndexOf(".") + 1);
				if (currentExt === "mht") {
					PrintClick("Cross", pDocID, "ING");
				} else {
					var currIfrm = document.getElementById("ifrm" + currentTabIdx);
					currIfrm.contentWindow.PrintDocument();
				}
			}
			
			function btnClose_onclick() {
				//2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
		        if (parent.opener != null && parent.opener.getApprovalList != undefined) {
		        	parent.opener.clearAbsence(true);
		        }

				if (ReturnFunction != null) {
					ReturnFunction();
				}
			    window.close();
			}
			
			function btnMail_onclick() {
				if(extAry[currentTabIdx] == "hwp")
					showPopup("/ezEmail/mailWrite.do?docHref=" + pDocHrefAry[currentTabIdx] + "&cmd=docsend&docID=" + pDocIDAry[currentTabIdx] + "&target=APPROVALG", 1200, window.screen.availHeight * 0.8, "", "height = " + window.screen.availHeight * 0.8 + ", width = 1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(1200, window.screen.availHeight * 0.8), hidePopup);
				else{
					html2canvas(document.getElementById("ifrm" + currentTabIdx).contentWindow.document.getElementById("div_Content")).then(function(canvas) {
						$.ajax({
							type:"POST",
							dataType:"text",
							data : {
									imgUrl : canvas.toDataURL("image/png"),
									docID: pDocID
							},
							url: "/ezApprovalG/createMailImg.do",
							success: function (data) {
							}
						});
					}
				);
				var pheight = window.screen.availHeight;
				var conHeight = pheight * 0.8;
				var pwidth = window.screen.availWidth;
				var pTop = (pheight - conHeight) / 2;
				var pLeft = (pwidth - 1200) / 2;
				var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + pDocID + "&docHref=" + encodeURIComponent(pDocHref)+"&orgCompanyID="+orgCompanyID;
				var newwin = window.open(pURL, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
				newwin.focus();
				}			
			}	
	
			function btnhistory_onclick() {
			    getHistory();
			}
	
			// 일괄기안 전용창에서는 공람지정 불가
			/*
			function btnGongRam_onclick() {
				var result = "";
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/gongRamUpdate.do",
		    		data : {
		    			docID : docID,
		    			userID: listSusin
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		},error: function() {
		    			
		    		}	
		    	});
		        
		        var dataNodes = GetChildNodes(result);
		        var tempValue = getNodeText(dataNodes[0]);
		
		        if (tempValue == "TRUE") {
		        	var pAlertContent = "";
		        	
		        	if (approvalFlag == "G") {
			            pAlertContent = "<spring:message code='ezApprovalG.t1441'/>";
		        	} else {
		        		pAlertContent = "<spring:message code='ezApprovalG.hyj23'/>";
		        	}
		        	 OpenAlertUI(pAlertContent, OpenAlertUI_Close);
		        }
			}
			*/
			
		    function CheckOpinionYN() {
				if (pHasOpinion == "Y") { // 1안에 대한 의견정보 확인
		            var pInformationContent = "<spring:message code='ezApprovalG.t9'/><br> <spring:message code='ezApprovalG.t170'/>";
				    OpenInformationUI(pInformationContent, btnOpinion_onclick_complete);
				}
		    }
			
			function OpenAlertUI_Close() {
				if (parent.opener != null && parent.opener.getApprovalList != undefined) {
				    parent.opener.clearAbsence(true);
				}
		    
		        window.close();
			}
	
			function window_onbeforeunload() {
			    try {
			        window.opener.openergetDocInfo();
			    }
			    catch (e) {
					window.parent.openergetDocInfo();
				}
			    // try {
			    //     window.opener.Refresh_Window();
			    // } catch (e) { }
			}
	
			var ezdocinfog_view_cross_dialogArguments = new Array();
			function btnDocInfo_onclick() {
				ezdocinfog_view_cross_dialogArguments[0] = "";
			    ezdocinfog_view_cross_dialogArguments[1] = btnDocInfo_onclick_Complete;
			    var url = "/ezApprovalG/ezDocInfoView.do?docID=" + docID + "&ingFlag=APR";
				if (typeof approvalFlag !== "undefined" && approvalFlag == "G") {
					DivPopUpShow(420, 400, url);
				}else {
					DivPopUpShow(420, 300, url);
				}
			}
			
			function btnDocInfo_onclick_Complete() {
		        DivPopUpHidden();
		    }
			
			/*
			// 일괄기안문서는 통합PC저장 불가능
			var totalsavefileinfo_dialogArguments = new Array();
		    function TotalSave_onclick() {
		        totalsavefileinfo_dialogArguments[0] = "";
		        totalsavefileinfo_dialogArguments[1] = TotalSave_onclick_Complete;
				
		        if (listTypeValue == "21") { //2019-02-08 천성준 - #14965 임시보관함문서 > 문서보기 > 통합PC저장 시, 첨부 및 문서파일을 내려받을수 없던 문제해결
			        DivPopUpShow(580, 480, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=TMP&orgCompanyID=" + orgCompanyID);
		        } else {
		        	var mode = getDocMode();
			        DivPopUpShow(580, 480, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=" + mode + "&orgCompanyID=" + orgCompanyID);
		        }
		    }
		    function TotalSave_onclick_Complete() {
		        DivPopUpHidden();
		    }
		    function getDocMode() {
		    	var rtnVal = "APR";
		    	
		    	try {
		    		$.ajax({
		     			type : "POST",
		     			dataType : "text",
		     			async : false,
		     			url : "/ezApprovalG/getLineMode.do",
		     			data : {
		     					docID : pDocID,
		     					orgCompanyID : orgCompanyID
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
			*/
			
			function btnforcecallback_onclick() {
				var pMsg = "<spring:message code='ezApprovalG.km02'/>";
				OpenInformationUI(pMsg, btnforcecallback_onclick_Complete);
			}
			
		    function btnforcecallback_onclick_Complete(ans) {
		        if (ans) {
		            doCancelForce();
		        } else {
					DivPopUpHidden();
				}
			}
		    
			function doCancelForce() {
/* 				var retVal = ExcuteInfo("CALLBACK_BEFORE", "DRAFT"); // pdraftflag 정상적으로 가져오게 수정해야함
				if (!retVal) {
					return;
				}
 */
				var currentAprLineForMail = getAprLinefor("APR", pDocIDAry[1]); // 회수동작이 완료되기 이전 상태의 결재선 정보를 저장
				var result = "";
				
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : false,
	        		url : "/ezApprovalG/doCancelForce.do",
	        		data : {
						docID : pDocIDAry[1], // 일괄기안문서 회수 시에는 사용하지 않으며, pDocIDAry를 대신 사용한다.
						userID : pUserID,
						draftAllFlag : "Y",
						docIDAry : pDocIDAry
	        		},
	        		success: function(xml){
	        			result = xml;
	        		}, error: function () {
    	                doCancel_error();
    	                return false; // 모든 안의 회수 중 하나라도 에러 발생 시 바로 리턴
    	            }
	        	});
		        
	        	//2018-07-10 배현상, OpenAlertUI에서 브라우저alert으로 변경 및 로직 수정
	        	var RtnVal = getNodeText(loadXMLString(result).documentElement);
	        	
		        if (RtnVal == "TRUE") {
					SendMailToCancel_Function(currentAprLineForMail); // 1안의 정보를 기준으로 회수알림메일 발송
					//attitude_annual_conn(pDocID);
					//ExcuteInfo("CALLBACK_AFTER", "DRAFT");

					HiddenMailProgress();
					OpenAlertUI(strLangKm01, function() {
						btnClose_onclick();
					});
		        } else {
					doCancel_error(RtnVal);
				//	ExcuteInfo("CALLBACK_FAIL", "DRAFT");
				}
			}
			
			// 강제회수 시, 현재 결재를 승인한 결재자(003) + 다음 결재순서인 결재자(002)에게 메일을 보낸다.
		    function SendMailToCancel_Function(GetCurrentlinelist) {
	            var MemberList = loadXMLString(GetCurrentlinelist)
	            var pDocTitle = document.getElementById("ifrm1").contentWindow.GetFieldText("doctitle").trim();
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
	                        sendmail(LineUserID, pDocTitle, arr_userinfo[2], pDraftDate, "callback", "", true);
	                    }
	                }

	            }
			}
		    
			/*
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
		    */
		    // 일괄기안문서 보기 전용창과 연동은 같이 사용할 수 없음
			//2019-05-03 김보미 - 근태관리 연동
			/*
			function attitude_annual_conn(docId) {
				$.ajax({ 			
					type:'POST', 			
					dataType : 'json', 			
					async : true, 			
					url : '/ezAttitude/approvalGConn.do', 			
					data : { 				
						status : 'delete', 				
						docId : docId 			
					},
					success : function(result) { 			},
					error : function() { 			} 		
				});  
			}
		    */
			
		    function btncallback_onclick() {
				var pMsg = "<spring:message code='ezApprovalG.km01'/>";
				OpenInformationUI(pMsg, btncallback_onclick_Complete);
		    }
		    
		    function btncallback_onclick_Complete(ans) {
				DivPopUpHidden();
		        if (ans) {
                    doCancel();
                } else {
                    DivPopUpHidden();
                }
            }
		    
			function doCancel() {
				/*
				var retVal = ExcuteInfo("CALLBACK_BEFORE", "DRAFT");
				if (!retVal) {
					return;
				}*/
				ShowMailProgress();
				var currentAprLineForMail = getAprLinefor("APR", pDocIDAry[1]); // 회수동작이 완료되기 이전 상태의 결재선 정보를 저장

				// 롤백 처리 함수가 따로 없어서 모든 안의 회수작업을 하나의 트랙잭션으로 묶는다. (하나라도 회수동작이 실패하면 전부 롤백되도록)
				// draftAllFlag와 docIDAry 파라미터를 통째로 던져주도록 한다. 루프는 /ezApprovalG/doCancel.do 내부에서 진행한다.
				var result = "";
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/doCancel.do",
					data : {
						docID : pDocIDAry[1], // 일괄기안문서 회수 시에는 사용하지 않으며, pDocIDAry를 대신 사용한다.
						userID : pUserID,
						draftAllFlag : "Y",
						docIDAry : pDocIDAry
					},
					success: function(xml) {
						result = xml;
					}, error: function () {
						doCancel_error();
						return false; // 회수 중 오류 발생 시 바로 동작을 정지한다. RtnVal값의 에러메세지 분기처리는 사실상 없는거나 마찬가지라서 안줘도 됨
					}
				});
				
				var RtnVal = getNodeText(loadXMLString(result).documentElement);

				if (RtnVal == "TRUE") {
					var rows = GetElementsByTagName(loadXMLString(currentAprLineForMail), "ROW");
					var drafterRow = rows[rows.length - 1];
					var cell = drafterRow.firstElementChild;

					var docTitle = document.getElementById("ifrm1").contentWindow.GetFieldText("doctitle").trim();
					var drafterName = SelectSingleNodeValue(cell, "DATA13");
					var pDraftDate = GetDocInfoData("APR", "STARTDATE"); // 메일 발송 시 회수일시가 아닌 기안일시를 사용
					
					// 회수알림 메세지 발송 동작은 1안의 정보를 기준으로 한번만 진행한다.
					SendMailToCancel(pDocIDAry[1], docTitle, drafterName, pDraftDate); 
					//attitude_annual_conn(pDocID);
					//ExcuteInfo("CALLBACK_AFTER", "DRAFT");

					HiddenMailProgress();
					OpenAlertUI(strLangKm01, function() {
						btnClose_onclick();
					});
					
				} else {
					doCancel_error(RtnVal);
					//ExcuteInfo("CALLBACK_FAIL", "DRAFT");
				}
			}
			
			// 사실상 결과값은 TRUE / FALSE로만 리턴되므로, strLang898("결재 문서를 회수하실 수 없습니다.")만 표출된다. 
			// 강제회수, 회수 모두 동일하다.
			function doCancel_error(errType) {
				var pAlertContent = "";
				HiddenMailProgress();
				
				switch (errType) {
					case "ERR01":
						pAlertContent = strLang895;
						break;
					case "ERR02":
						pAlertContent = strLang896;
						break;
					case "ERR03":
						pAlertContent = strLang897;
						break;
					default:
						pAlertContent = strLang898;
						break;
				}

				OpenAlertUI(pAlertContent);
			}
			
			// 강제회수, 일반 회수 버튼의 표출을 제어
			function cancelYN() {
				$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezApprovalG/doCanCelYN.do",
					data : {
						docID : pDocID,
						userID : pUserID
					},
					success: function(xml){
						cancelYN_after(loadXMLString(xml));
					}
				});
			}
			
			function cancelYN_after(xml) {
				var RtnVal = getNodeText(xml.documentElement);
				var btnCallback = document.querySelector("#btnCallback");
				var btnForceCallback = document.querySelector("#btnForceCallback");

				btnCallback.style.display = "none";
				btnForceCallback.style.display = "none";

				var aprLineXml = loadXMLString(getAprLinefor("APR", pDocID));

				if (RtnVal === "CALLBACK" || RtnVal === "CANCEL") {
					btnCallback.style.display = "";
				} else {
					if (forceCallBackYN === "YES" && checkIsDrafter(aprLineXml)) {
						$.ajax({
							type : "POST",
							dataType : "text",
							async : false,
							url : "/ezApprovalG/doForceCancelYN.do",
							data : {
								docID : pDocID,
								userID : pUserID
							},
							success: function(xml){
								result = xml;
							}
						});
						
						var RtnVal = getNodeText(loadXMLString(result).documentElement);

						if (RtnVal === "TRUE") {
							btnForceCallback.style.display = "";
						}
					}
				}
			}
			
			function checkIsDrafter(pAprLineXml) {
				var rows = GetElementsByTagName(pAprLineXml, "ROW");
				var drafterRow = rows[rows.length - 1];

				var cell = drafterRow.firstElementChild;
				var aprUserID = SelectSingleNodeValue(cell, "DATA4");
				var aprType = SelectSingleNodeValue(cell, "DATA11");

				if (aprUserID === pUserID) {
					return true;
				}

				return false;
			}
		    
	    	// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
	    	function setAttachGuideText() {
	    		// 대용량첨부의 자동삭제 기능, 저장만료기한 사용하지 않음
                var attachGuideText =  "<td align='left' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-left:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; border-right:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                
                if(bigSizeAttachDownloadLimitCount > 0) {
                	attachGuideText += strLangHSBAt06 + " <span style='color:#FF0000 ;'>" + bigSizeAttachDownloadLimitCount + strLangHSBAt09 + "</span> " + strLangHSBAt10;
                }
                
                attachGuideText += "<td align='right' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-right:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; border-left:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += "</td>";
/*                 
                var attachGuideText =  "<td align='left' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-left:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; border-right:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += strLangHSBAt05 + "<span style='color:#FF0000 ;'>" + bigAttachDownloadPeriod + "</span></td>";
                attachGuideText += "<td align='right' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-right:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; border-left:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
                attachGuideText += strLangHSBAt06 + "<span style='color:#FF0000 ;'>" + bigAttachDownloadDay + strLangHSBAt07 + "</span>" + strLangHSBAt08;
                 */
                 
                 if (bigSizeAttachDownloadLimitCount > 0) {
                	 document.getElementById("apprAttachGuideTR").innerHTML = attachGuideText;
                 }
                 else {
                	 document.getElementById("apprAttachGuideTR").style.display = "none";
                 }
	    	}
	    	
	    	// 일괄기안문서는 부서수신함에 도착한 수신문서와 호환되지 않으므로, 회송기능 제외
	    	/*
		    var apropinion_cross_dialogArguments = new Array();
		    var temppDocSN = "";
		    function btnReturn_onclick() {
	        	var deptCheckFlag = checkDeptAndCabinetId();
		    	if (deptCheckFlag == "3") {
		    		alert(strLanggarm06 + " '" + arr_userinfo[5] + "'" +strLanggarm03 + " '" + arr_userinfo[5] + "'" + strLanggarm07 );
		    		return;
		    	} else if (deptCheckFlag == "4") {
		    		alert(strLanggarm06 + " '" + "'" + strLanggarm08);
		    		return;
		    	} else if (deptCheckFlag == "2") {
					alert("타부서의 철정보로 설정되어있습니다. \n'" + arr_userinfo[5] + "'부서의 철로 변경해주시기바랍니다.");
					return;
				}	
		    	
		        var RecevState = getDocRecevState();
		        if (RecevState != "011" && RecevState != "012" && RecevState != "013" && RecevState != "014") {
		            if (RecevState == "015") {
		                var pAlertContent = strLang912;
		                OpenAlertUI(pAlertContent);
		            }
		            return false;
		        }
		        var pDocSN = "";
				var field = "receiptnumber";
				if (message.FieldExist(field)) {
		            var fieldValue = trim(message.GetFieldText(field));
		            if (fieldValue && fieldValue.replace("@", "") == fieldValue) {
		                var tmpDocSN = fieldValue.substr(fieldValue.lastIndexOf("-") + 1);
		                if (!isNaN(tmpDocSN))
		                    pDocSN = tmpDocSN;
		            }
				}
		        temppDocSN = pDocSN;
		        
		        openOpinionUI_New("HeSong", btnReturn_onclick_Complete);
		    }
		    function btnReturn_onclick_Complete(ret) {
		        DivPopUpHidden();

		        if (checkAprState()) {
		    		alert("<spring:message code='ezApprovalG.bhs23'/>");
	    			window.close();
	    			return;
		    	}

		        var hesongok = true;
		        if (ret != "cancel") {
					var draftFlag = "SUSIN";
					if (pDocState === "012") {
						draftFlag = "HAPYUI";
					}
					
					var RtnVal = ExcuteInfo("HESONG_BEFORE", draftFlag);
		        	if (!RtnVal) {
		                return;
		            }

		        	var Rtnxml = loadXMLString(ret);
		            if (temppDocSN) {
		                hesongok = setCabinetHeSong(temppDocSN);
					}
		
		            if (hesongok) {
						var writerID = GetDocInfoData("APR", "writerid");
						var writerName = GetDocInfoData("APR", "writername");
						var docTitle = GetDocInfoData("APR", "doctitle");
		            	SendMailToDrafter_Hesong(writerID, writerName, docTitle);
		                hesongok = setHeSongDocInfo();

						if (hesongok) {
							ExcuteInfo("HESONG_AFTER", draftFlag);
						} else {
							ExcuteInfo("HESONG_FAIL", draftFlag);
						}
		            }
		        }
		    }
		    */
		    
		    // 회송버튼 표출 (수신문에 대해서만 동작하며, 일괄기안문서 전용 보기창과는 호환되지 않는 기능이므로 주석처리함)
		    // 수신문으로 부서수신함에 도착한 일괄기안문서는 각 안 별로 분리되므로, 일괄기안 전용 보기창이 아닌 일반 웹한글문서 보기창으로 열리게 된다.
		    /*
			function returnYN() {
				var req = new XMLHttpRequest();
				req.open("GET", "/ezApprovalG/returnYN.do?docID=" + pDocID + "&orgDocID=" + pOrgDocID + "&orgCompanyID=" + orgCompanyID);
				req.send();
				req.onload = function() {
					var res = req.responseText;
					switch (res) {
						case "Y":
							document.querySelector("#tbtnReturn").style.display = "";
							break;
						case "N":
							document.querySelector("#tbtnReturn").style.display = "none";
							break;
						case "E":
							console.log("fail returnYN");
							break;
					}
				}
			}
			*/
			
	    	function ShowMailProgress() {
	    		var CurrenWidth = document.documentElement.clientWidth;
	    		
	            document.getElementById("mailPanel").style.display = "";
	            document.getElementById("loadingProgress").style.top = "600px";
	            document.getElementById("loadingProgress").style.left = (CurrenWidth / 2) - 100 + "px";
	            document.getElementById("loadingProgress").style.display = "";
		    }
	    	
		    function HiddenMailProgress() {
		    	document.getElementById("mailPanel").style.display = "none";
	        	document.getElementById("loadingProgress").style.display = "none";
		    }
			 
	    	/************************* 일괄기안 전용 함수 ***************************/	
	    	
	    	// 각 안별 탭 생성
	    	function makeTabs() {
                ShowMailProgress();
                
                var viewTabCnt = pDocIDAry.length - 1; // 임시저장된 문서 갯수만큼 탭을 만들어줄 예정이므로, 변수는 미리 설정해뒀음 (안 갯수는 0번배열 제외하기 위해 -1처리)
                
                for (var i = 1; i <= viewTabCnt; i++) {
                    var viewNewTabCnt = Number(i); // 1안부터 시작
                    
                    // 탭의 요소 길이 자체는 0부터 시작하게 되며, 루프를 진행하면서 1, 2... 로 증가한다.
                    var viewTabIdx = viewNewTabCnt; // 최초 루프 시 0 -> 1로 현재 탭 인덱스 증가
					var addString = "";
					if (viewTabIdx == 1) { // 1안인 경우, 선택된 상태로 스타일 처리
                        $("dl.tab_menu").append("<dt class=\"on\" id=\"dt" + viewTabIdx + "\" style=\"cursor:pointer\"><span onclick=\"selTab('" + viewTabIdx + "')\"  id=\"sp" + viewTabIdx + "\">" + viewTabIdx + " " + strLangHSBRDa01 + "</span></dt>");
                        addString = "<div class=\"tab_content\" id=\"tab" + viewTabIdx + "\" style=\"display:black;\"> ";
					}
                    else {
                        $("dl.tab_menu").append("<dt id=\"dt" + viewTabIdx + "\" style=\"cursor:pointer\"><span onclick=\"selTab('" + viewTabIdx + "')\"  id=\"sp" + viewTabIdx + "\">" + viewTabIdx + " " + strLangHSBRDa01 + "</span></dt>");
                        addString = "<div class=\"tab_content\" id=\"tab" + viewTabIdx + "\" style=\"display:black;\">";
                    }

					// formID는 자식 프레임에서 process_AfterOpen() > getApprovInfo() 등으로 알아서 가져오게 된다. 안 넘겨줘도 됨
                    var iframeURL = (extAry[i] == "mht" ? "/ezApprovalG/aprDocViewContent.do" : "/ezApprovalG/apprViewContentAll_WHWP.do") + "?frameNum=" + viewTabIdx + "&docHref=" + encodeURI(pDocHrefAry[viewTabIdx]) + "&docID=" + encodeURI(pDocIDAry[viewTabIdx]);
					addString = addString + "<iframe name=\"ifrm" + viewTabIdx + "\" id=\"ifrm" + viewTabIdx + "\" style=\"width:100%; height:" + wh + "px; border:0px\" onload=\"getReSize()\" src=\"" + iframeURL + "\"></iframe></div>";
					
                    $("div.tab_container").append(addString);
                    HiddenMailProgress();
                }
	        }
	    	
	        // 안별 탭 선택 (objNum는 선택한 탭의 인덱스)
	        function selTab(objNum) {
	            $("dl.tab_menu dt").removeClass("on"); // 기존 탭 활성화 모두 제거
	            $("#dt" + objNum).addClass("on"); // 현재 선택한 탭 활성화

	            $("div.tab_content").attr("style", "display:none"); // 생성된 iframe 영역을 전부 안보이게 처리
	            $("#tab" + objNum).attr("style", "display:block"); // 현재 선택한 탭의 iframe을 보이게 함

	            currentTabIdx = objNum; //현재 선택된 탭 인덱스 변경
	            
	            // 현재 선택한 탭의 배열 데이터를 부모 파라미터로 사용
	            setTabInfo(objNum);
	            
	        	// 선택한 안의 첨부파일정보를 표출
	            document.getElementById("attachFileTR").style.display = ""; // 숨겨둔 첨부파일영역 표출
	            setAttachInfo(pDocIDAry[objNum], "APR", lstAttachLink);
	        }
	        
	        function setTabInfo(setNum) {
        		if (setNum) { // 주어진 번호가 있다면 바로 사용
        			currentTabIdx = setNum;
        		} else { // 아니라면 현재 활성화된 탭에서 가져옴
        			currentTabIdx = $("#container").find("dt.on").attr("id").replace("dt", "");
        		}
        		
        		HwpCtrl = document.getElementById("ifrm" + currentTabIdx).contentWindow.HwpCtrl; // 웹한글기안기 내부 컨트롤에 접근
        		lstAttachLink = document.getElementById("lstAttachLink");
        		
        		//SignInfo = undefined2EmptyString(SignInfoAry[currentTabIdx]);
        		//pFormID = undefined2EmptyString(pFormIDAry[currentTabIdx]);
        		pDocID = undefined2EmptyString(pDocIDAry[currentTabIdx]);
        		//hapyuiCount = undefined2EmptyString(hapyuiCountAry[currentTabIdx]);
        		//SignCount = undefined2EmptyString(SignCountAry[currentTabIdx]);
        		//gamsaCount = undefined2EmptyString(gamsaCountAry[currentTabIdx]);
        		//pSuSinFlag = undefined2EmptyString(pSuSinFlagAry[currentTabIdx]);
        		//btnReceivLineEnable = undefined2EmptyString(btnReceivLineEnableAry[currentTabIdx]);
        		pDocHref = undefined2EmptyString(pDocHrefAry[currentTabIdx]);
        		//pHasAttachYN = undefined2EmptyString(pHasAttachYNAry[currentTabIdx]);
        		//pHasDocAttachYN = undefined2EmptyString(pHasDocAttachYNAry[currentTabIdx]);
        		//pHasOpinionYN = undefined2EmptyString(pHasOpinionYNAry[currentTabIdx]);
				
				//SummaryOuterReceiverList = undefined2EmptyString(SummaryOuterReceiverListAry[currentTabIdx]);
   		        //fileOpenFlagList = undefined2EmptyString(fileOpenFlagListArr[currentTabIdx]);
   		        
				pDocType = undefined2EmptyString(pDocTypeAry[currentTabIdx]);
				//pDocTitle = undefined2EmptyString(pDocTitleAry[currentTabIdx]);
        	}
        	
        	function undefined2EmptyString(value) {
        		if (value == undefined) {
	        		return ""; 
        		} else {
	        		return value; 
        		}
        	}
        	
        	 // iframe 리사이즈 (1안이 존재하는 경우에만, 모든 안에 대하여 루프를 돌며 적용하므로 한번만 동작하게 할것!)
	        function getReSize() {
	            var ifrm1 = document.getElementById("ifrm1");
	            if (ifrm1 != null && typeof(ifrm1) != "undefined") {
	                var viewTabCnt = Number(allTabNum); // 모든 안의 갯수
	                
	                for (var i = 0; i < viewTabCnt; i++) {
	                    var viewTabNo = Number(i) + 1;
	                 //   var wh = window.innerHeight - 69;
	                 	var wh = window.innerHeight - 169; // 첨부파일영역 추가로 리사이즈 조정
	                    var Frame_name = document.all("ifrm" + viewTabNo);
	                    
	                    if (Frame_name != null && typeof(Frame_name) != "undefined") { // 각 iframe이 존재하면 높이를 셋팅
	                        Frame_name.style.height = wh + "px";
	                    }
	                }
	            }                       
	        }

        	function DocumentComplete(frame){
        	    var frameNum = frame.name.substring(4);
        	    frame.Set_EditorContentURL(pDocHrefAry[frameNum]);
        	}

        	function FieldsAvailable(frame) {
                try {
                    var frameNum = frame.name.substring(4);
                    setTabInfo(frameNum);

                    docLoadCompleteCnt ++;

                    // 로딩된 문서의 전체 갯수가 재기안 시작 시 가져온 전체 안의 갯수와 일치하는 경우
                    if (docLoadCompleteCnt == (pDocIDAry.length - 1)) {
                        HiddenMailProgress(); // 전부 완료 시 로딩중 이미지 제거
                        CheckOpinionYN(); // 모든 문서가 완료된 다음, 대표로 1안에 대해서만 의견 존재 여부를 확인하고, 레이어 팝업을 호출한다.
                        setTimeout(function() {
                            selTab(1); // 각 안을 전부 로딩한 뒤, 기본으로 1안을 선택하도록 한다.
                        }, loadTime);
                    }
                } catch (e) {
                    alert("apprGviewAprAllContent_WHWP.jsp.FieldsAvailable()  ::  " + e);
                }
            }
	    </script>
	</head>
	<body class="popup" style="overflow:hidden;" onload="return window_onload()" onbeforeunload="return window_onbeforeunload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
						<%-- 2022-06-30 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
				        <ul <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
	                       <%-- <li id="btnGongRam" style="display: none"><span onclick="btnGongRam_onclick()"><spring:message code='ezApprovalG.t1442'/></span></li>--%>
	                        <li id="btnCallback" style="display:none"><span onclick="return btncallback_onclick()" ><spring:message code='ezApprovalG.t66'/></span></li>
							<li id="btnForceCallback" style="display:none"><span onclick="return btnforcecallback_onclick()"><spring:message code='ezApprovalG.t2005'/></span></li>
							<%--<li id="tbtnReturn" style="display: none;"><span onclick="return btnReturn_onclick()"><spring:message code='ezApprovalG.t1434'/></span></li>--%>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        <li id="btnSummary"><span onclick="return btnSummaryView()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
	                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
	                        <%-- 일괄기안문서는 결재진행 도중 문서저장 불가능 --%>
	                        <li id="tbtnTotalSave" style="display: none"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
	                        <li id="btnPrint"><span class="icon16 popup_icon16_print" onclick="return btnPrint_onclick()"></span></li>
	                        <c:if test="${useExternalMailServer == 'NO'}">
	                        	<li id="btnMail" style="display:none"><span class="icon16 popup_icon16_mail_gray" onclick="return btnMail_onclick()"></span></li>
	                        </c:if>
	                    </ul>
	                    
						<ul <c:if test="${isPreview != 'Y'}">style="display:none"</c:if>>
				        	<li><img src='/images/kr/cm/btn_newpopup.gif' title=<spring:message code='ezEmail.t99000001'/> alt=<spring:message code='ezEmail.t99000001'/> onclick='return parent.btn_newpopup()'></li>
				        </ul>
	                </div>
	                <div id="close" <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
	                    <ul>
	                        <li id="btnClose"><span onclick="return btnClose_onclick()"></span></li>
	                    </ul>
	                </div>
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	                    selToggleList(document.getElementById("close"), "ul", "li", "0");
	                </script>
	            </td>
	        </tr>
	        
		<%-- 각 웹에디터 파트는 content 페이지로 이동 --%>
		<%-- 버튼 하단 안별 탭 영역 --%>
			<tr>
			    <td  style="height:86%;vertical-align: top;" >
			    	<div id="container">        
	        			<div class="tab_menuBox contentlist_layout">
	            			<dl class="tab_menu" >              
	            			</dl>
	        			</div>
	        			<div class="tab_container" style="margin-top:5px;"> 
	        			</div>
	    			</div>
			    </td>
			</tr>
	        
	        <tr id="attachFileTR" style="display:none;">
	            <td height="20">
	                <table class="file" style="height:80px; margin-top:-9px;">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td style=" width:62%; border-right:1px solid #d5d5d5;">
	                            <div id="lstAttachLink" style="height:70px;"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
	                        </td>
	                        <td style=" width:30%;">
								<div id="lstAttachLinkDoc" style="height:70px;"></div>
							</td>
							<td class="pos2" style="width:8%; background:#fffcfa;">
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a><br/>
	                        </td>
	                    </tr>
	                </table>
	                
	                <%-- 대용량첨부 가이드 메세지 영역 --%>
	                <table class="file" style="height: 20px;">
	                    <tr id="apprAttachGuideTR"></tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<%-- 로딩 이미지 표출 영역 --%>
		<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingProgress">
        	<img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
    	</div>
	</body>
</html>
