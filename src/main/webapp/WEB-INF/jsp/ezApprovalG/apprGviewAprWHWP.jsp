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
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<%-- <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezViewApr_HWP.js')}"></script> --%>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/AprDocView_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_WHWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
	    <script type="text/javascript">
            if(location.pathname.endsWith("view.do")){
                history.replaceState(null, null, location.pathname);
                sessionStorage.setItem("docID", "<c:out value ='${docID}'/>");
                sessionStorage.setItem("isPreview", "<c:out value ='${isPreview}'/>");
                sessionStorage.setItem("allFlag", "<c:out value ='${allFlag}'/>");
                sessionStorage.setItem("listSusin", "<c:out value ='${listSusin}'/>");
                sessionStorage.setItem("sendType", "<c:out value ='${sendType}'/>");
                sessionStorage.setItem("docAttachParent", "<c:out value ='${docAttachParent}'/>");
                sessionStorage.setItem("admin", "<c:out value ='${admin}'/>");
                sessionStorage.setItem("listType", "<c:out value ='${listType}'/>");
                sessionStorage.setItem("pageType", "<c:out value ='${pageType}'/>");
                sessionStorage.setItem("isOpinion", "<c:out value ='${isOpinion}'/>");
                sessionStorage.setItem("callBackType", "<c:out value ='${callBackType}'/>");
            }

	        var docID = "<c:out value='${docID}'/>";
	        var docHref = "<c:out value='${docHref}'/>";
	        var formUrl = "<c:out value='${formUrl}'/>";
	        var formDocType = "<c:out value='${formDocType}'/>";
	        var useFormContOnReuseForWHWP = "<c:out value='${useFormContOnReuseForWHWP}'/>";
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
	
	        var pHasOpinion = "<c:out value='${hasOpinionYN}'/>";
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
	        
	     	// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";
			var ReturnFunction;

            var isPreview = "<c:out value='${isPreview}'/>";
	        
            // 일괄 타입 B
            var draftAllTypeB = "<c:out value ='${draftAllTypeB}'/>";
            var pMode;
            var draftAllFlag = <c:if test="${fn:length(group) > 0}">"Y"</c:if><c:if test="${fn:length(group) == 0}">"N"</c:if>;
            var groupDocSN = "<c:out value ='${groupDocSN}'/>"; // 일괄기안된 문서가 가지는 TBL_APRDOCGROUPINFO의 GROUPDOCSN값 (1안의 DOCID)
            var pDocHrefAry = new Array();
            var pFormIDAry = new Array();
            var pSuSinFlagAry = new Array();
            var pDocIDAry = new Array();
            var pOrgDocIDAry = new Array();
            var pDocTypeAry = new Array();
            var pDocTitleAry = new Array();
            var pDocNumCodeAry = new Array(); // 문서번호 배열
            var pDocNumSnAry = new Array(); // 문서번호 숫자부분(tempNumString) 배열
            
            var pHasAttachYNAry = new Array();
            var pHasDocAttachYN = new String("N");
            var pHasDocAttachYNAry = new Array();
            var attachReload = new Array();
            var pHasOpinionYN = new String("N");
            var pHasOpinionYNAry = new Array();
            
            var SignInfoAry = new Array();
            var hapyuiCountAry = new Array();
            var SignCountAry = new Array();
            var gamsaCountAry = new Array();

            var extAry = new Array();
 
            var htmlDataAry = new Array(""); // 웹한글기안기의 GetHTML 함수가 비동기로 동작하므로, 이 배열에 가져온 data를 넣어준다. 
            var pOrgHtmlAry = new Array(""); // 결재 중 오류 발생 시 원래 문서로 돌려주기 위한 데이터 저장 배열. 기본적으로 htmlDataAry값과 동일하다.
            
            var pDocInfoAry = new Array();
            var pAttachInfoAry = new Array();
            var currentTabIdx = 0;
            var attachHTML = new Array();
            var docAttachHTML = new Array();
            var attachLoad = new Array();
            var anCnt = 1;
            var FirstHtmlAry = new Array();
            var SaveHtmlAry = new Array();

            var isPreview = "<c:out value = '${isPreview}'/>";
            
			function btnOpinion_onclick() {
			    //openOpinionViewUI();
				openOpinionUI_New("Show");
			}
			
			function btnOpinion_onclick_complete(Ans) {
			    //openOpinionViewUI();
			    DivPopUpHidden();
    			if (Ans) {
					openOpinionUI_New("Show");
			    }
			}
	
			window.onresize = function () {
	       		document.getElementById("messageWHWPEditor").style.height = document.documentElement.clientHeight - 150 + "px";
	       		var mHeight = document.documentElement.clientHeight - 110 - document.getElementById("messageWHWPEditor").offsetTop + "px";
	       		message.Resize(mHeight);
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
			
			    if (pDocState === "015" && pOrgDocID.length >= 20) {
			    	if (listTypeValue === "99") {	// 공람할문서
			    		btnGongRam.style.display = "";
				        btnBoard.style.display = "";
				        if(typeof btnReuse != "undefined")
				            btnReuse.style.display = "";
				        pOpinionType = "";
			    	} else if (listTypeValue === "10") {	// 공람완료문서
			    		btnBoard.style.display = "";
				        if(typeof btnReuse != "undefined")
                            btnReuse.style.display = "";
			    	}
			    }
			    
			    pDocID = docID;
			    pDocHref = docHref;
			    pOpinionFlag = opinionFlag;
			    pListTypeValue = listTypeValue;
			    if (pListTypeValue == "4" || pListTypeValue == "97") {
					pListSusin = listSusin;
				}	
				cancelYN();
				returnYN();
				setAttachGuideText();
				
                // 일괄기안 B
                <c:if test="${fn:length(group) > 0}">
                    anCnt = an.options.length;
                    pDocIDAry.push("");
                    pDocHrefAry.push("");
                    pDocTypeAry.push("");
                    extAry.push("");

                    <c:forEach items="${group}" var="item">
                        pDocIDAry.push("${item.docID}");
                        pDocHrefAry.push("${item.docHref}"); // 문서경로
                        pDocTypeAry.push("${item.docType}"); // 문서타입 (내부결재, 수신문...)
                        extAry.push("${item.docHref}".substring("${item.docHref}".lastIndexOf(".") + 1)); // 확장자
                    </c:forEach>		                
                </c:if>
			}
	
			// 웹 한글 기안기용
	    	function Editor_Complete() {
	    		showLoadingProgress();
	    		
	    		if (pDocHref != "") {
				    var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pDocHref);
				    message.Open(URL, "", "", function (res) { 
					    if (res.result) {
					    	if (listTypeValue == "21") {
					    		setAttachInfo(pDocID, "TMP", lstAttachLink);
					    	} else {
						        setAttachInfo(pDocID, "APR", lstAttachLink);
					    	}
					        GetExchInfo();
					        //SignCheck();
					        hideLoadingProgress();
					        
					        /* 2023-12-07 홍승비 - 결재서명 재맵핑 함수 호출 (TBL_SIGNINFO 테이블에 정상적인 서명 데이터가 확정 삽입되는 시점은 테넌트 컨피그로 체크) */
					        message.startRemapAllAprSign_WHWP(pDocID, orgCompanyID);
					        
					        // 현재 문서가 수신문 또는 공람문서이면서 원문서가 존재하는 경우, 원문서의 서명 데이터도 재맵핑
					        if ((pDocState == "011" || pDocState == "015") && pOrgDocID != null && typeof(pOrgDocID) != "undefined" && pOrgDocID != "") {
					        	message.startRemapAllAprSign_WHWP(pOrgDocID, orgCompanyID);
					        }
				
					        if (pHasOpinion == "Y") {
					            var pInformationContent = "<spring:message code='ezApprovalG.t9'/><br> <spring:message code='ezApprovalG.t170'/>";
							    OpenInformationUI(pInformationContent, btnOpinion_onclick_complete);
							}
				        }
				        else {
				        	hideLoadingProgress();
				            var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
							OpenAlertUI(pAlertContent);
							message.Clear();
				        }
					    message.EditMode(0);
						message.SetViewProperties(2, 100);
					    message.ScrollPosInfo(0, 0);
					    
					    window.onresize();

                        if(anCnt > 1){
                            scrollPos.push(0);
                            hwpChange(() => scrollSetBefore(1));
                            message.HwpCtrl.AddEventListener(2, function(){
                                for(var i = scrollPos.length - 1; i >= 0; i--){
                                    if(message.HwpCtrl.ScrollPosInfo.Item("VertPos") >= scrollPos[i]){
                                        if(currentTabIdx != i + 1){
                                            changeAn(i + 1, true);
                                        }
                                        break;
                                    }
                                }
                            });
                            for(var i = 0; i < anCnt; i++){
                                pSuSinFlagAry[i + 1] = message.FieldExist("recipient{{" + i + "}}")
                            }
                        }					    
					    if(useExternalMailServer == "NO") {
					    	$("#btnMail").css("display","");
					    }
				    }, null);
			    }
			}
	
			function btnPrint_onclick() {
				message.PrintDocument();
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
	
			function btnSave_onclick() {
			    HwpCtrl.SetDocumentInfo(pFormID);
			    HwpCtrl.SaveFile("");
			}
			
			function btnMail_onclick() {
			    if(anCnt > 1 && draftAllTypeB == "Y"){
                    changeAn(1, true);
                }
				
                // window.open("/ezEmail/mailWrite.do?docHref=" + docHref + "&cmd=docsend&docID=" + docID + "&target=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
				showPopup("/ezEmail/mailWrite.do?docHref=" + docHref + "&cmd=docsend&docID=" + docID + "&target=APPROVALG", 1200, window.screen.availHeight * 0.8, "", "height = " + window.screen.availHeight * 0.8 + ", width = 1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(1200, window.screen.availHeight * 0.8), hidePopup);
			}	
	
			function btnhistory_onclick() {
			    getHistory();
			}
	
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
			
			function OpenAlertUI_Close() {
				if (parent.opener != null && parent.opener.getApprovalList != undefined) {
				    parent.opener.clearAbsence(true);
				}
		    
		        window.close();
			}
	
			function window_onbeforeunload() {
                if (isPreview != "Y") {
                    try {
                        window.opener.openergetDocInfo();
                    }
                    catch (e) {
                        window.parent.openergetDocInfo();
                    }
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
			    //var feature = "status:no;dialogWidth:420px;dialogHeight:495px;help:no;scroll:no;edge:sunken;";
			    //var RtnVal = window.showModalDialog(url, "", feature);
				if (typeof approvalFlag !== "undefined" && approvalFlag == "G") {
					DivPopUpShow(420, 400, url);
				}else {
					DivPopUpShow(420, 300, url);
				}
			}
			
			function btnDocInfo_onclick_Complete() {
		        DivPopUpHidden();
		    }
			
			// var totalsavefileinfo_dialogArguments = new Array();
		    function TotalSave_onclick() {
		        ezCommon_cross_dialogArguments[0] = "";
		        ezCommon_cross_dialogArguments[1] = TotalSave_onclick_Complete;
				
				if(anCnt > 1 && draftAllTypeB == "Y"){
                    changeAn(1, true);
                }
				
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
				var retVal = ExcuteInfo("CALLBACK_BEFORE", "DRAFT"); // pdraftflag 정상적으로 가져오게 수정해야함
				if (!retVal) {
					return;
				}

				var GetCurrentlinelist = getAprLinefor("APR", pDocID);
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
    	                doCancel_error();
    	            }
	        	});
		        
	        	//2018-07-10 배현상, OpenAlertUI에서 브라우저alert으로 변경 및 로직 수정
	        	var RtnVal = getNodeText(loadXMLString(result).documentElement);
	        	
	        	/* 2022-03-15 홍승비 - 회수메일 발송 시 회수동작 이전의 결재선 정보를 전달하도록 수정 */
		        if (RtnVal == "TRUE") {
					SendMailToCancel_Function(GetCurrentlinelist);
					attitude_annual_conn(pDocID);
					
					ExcuteInfo("CALLBACK_AFTER", "DRAFT");

					OpenAlertUI(strLangKm01, function() {
						btnClose_onclick();
					});
		        } else {
					doCancel_error(RtnVal);
					ExcuteInfo("CALLBACK_FAIL", "DRAFT");
				}
			}
		    function SendMailToCancel_Function(GetCurrentlinelist) {
	            var MemberList = loadXMLString(GetCurrentlinelist)
	            var pDocTitle = message.GetFieldText("doctitle").trim();
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
		    
			//2019-05-03 김보미 - 근태관리 연동
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
		    function btncallback_onclick() {
				var pMsg = "<spring:message code='ezApprovalG.km01'/>";
				OpenInformationUI(pMsg, btncallback_onclick_Complete);
		    }
		    function btncallback_onclick_Complete(ans) {
				DivPopUpHidden();
		        if (ans) {
		            if(anCnt > 1 && draftAllTypeB == "Y"){
		                changeAn(1, true);
		            }
		        
                    doCancel();
                } else {
                    DivPopUpHidden();
                }

            }
			function doCancel() {
				var retVal = ExcuteInfo("CALLBACK_BEFORE", "DRAFT"); // pdraftflag 정상적으로 가져오게 수정해야함
				if (!retVal) {
					return;
				}

				var result = "";
				var sendData;
				if(anCnt > 1 && draftAllTypeB == "Y"){
                    sendData = {
                        docID : pDocIDAry[1], // 일괄기안문서 회수 시에는 사용하지 않으며, pDocIDAry를 대신 사용한다.
                        userID : pUserID,
                        draftAllFlag : "Y",
                        docIDAry : pDocIDAry
                    };
				}else{
				    sendData = {
                        docID : pDocID,
                        userID : pUserID
                    };
				}
				
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/doCancel.do",
					data : sendData,
					success: function(xml){
						result = xml;
					}, error: function () {
						doCancel_error();
					}
				});
				
				var RtnVal = getNodeText(loadXMLString(result).documentElement);

				if (RtnVal == "TRUE") {
					var rows = GetElementsByTagName(loadXMLString(getAprLinefor("APR", pDocID)), "ROW"); // SendMailToCancel 함수 내부에서 다시 한번 결재선을 가져온다.
					var drafterRow = rows[rows.length - 1];
					var cell = drafterRow.firstElementChild;

					var docTitle = message.GetFieldText("doctitle").trim();
					var drafterName = SelectSingleNodeValue(cell, "DATA13");
					//var draftDate = SelectSingleNodeValue(cell, "DATA2");
					var pDraftDate = GetDocInfoData("APR", "STARTDATE"); // 메일 발송 시 회수일시가 아닌 기안일시를 사용

					SendMailToCancel(pDocID, docTitle, drafterName, pDraftDate); 
					attitude_annual_conn(pDocID);

					ExcuteInfo("CALLBACK_AFTER", "DRAFT");

					OpenAlertUI(strLangKm01, function() {
						btnClose_onclick();
					});
					
				} else {
					doCancel_error(RtnVal);
					ExcuteInfo("CALLBACK_FAIL", "DRAFT");
				}
			}
			function doCancel_error(errType) {
				var pAlertContent = "";

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
		    	} else if (deptCheckFlag == "2" && upperDeptCode == "") {
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
			
	    	// 게시판 게시
	    	// var writeboardselect_modal_dialogArguments = new Array();
		    function NewItem_onclick() {
		    	// writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
		        // var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(355, 600));
		        // try {
		        // 	if (OpenWin) {
		        // 		OpenWin.focus(); 
		        // 	} 
		        // } catch (e) {
		        // 	console.error('OpenWin 접근 실패:', e);
		        // }
				showPopup("/ezBoard/writeBoardSelectModal.do", 355, 600, "WriteBoardSelect_Modal", GetOpenWindowfeature(355, 600), NewItem_onclick_Complete);
		    }
		    
		    function NewItem_onclick_Complete(ret) {
				hidePopup();
		        if (typeof (ret) != "undefined") {
		            pBoardID = ret[0];
		
		            if (pBoardID == "" || typeof (pBoardID) == "undefined") {
		                return;
		            }
		
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 720) / 2;
		            var pLeft = (pwidth - 765) / 2;
		            
		            if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4" || ret[2] == "7" || ret[2] == "8" || (ret[3] != "null" && ret[3] != null && ret[3] != "")) {
		                alert(strLang1031);
		            }
		            else {
		                // window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + docHref + "&orgCompanyID=" + orgCompanyID, '', GetOpenWindowJun(765, 870));
						showPopup("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + docHref + "&orgCompanyID=" + orgCompanyID, 765, 870, "", GetOpenWindowJun(765, 870), hidePopup);
		            }
		        }
		    }
		    
		    // 재사용 - 공람할문서, 공람완료문서 메뉴에서 사용함
			var editable = "";
			var getformcont_cross_dialogArguments = new Array();
		 	function btnReuse_onclick(type) {
		 		editable = type;
		 		if (useFormContOnReuseForWHWP === "YES") {
			 		var parameter = new Array();
			        parameter[0] = "sol2";
			        parameter[1] = "A01000";
			        
			        url = "/ezApprovalG/getFormCont.do";
			        
			        if (CrossYN()) {
			            getformcont_cross_dialogArguments[0] = parameter;
			            getformcont_cross_dialogArguments[1] = btnReuse_onclick_complete;
			            var getFormCont_Cross = window.open(url, "/ezApproval/getFormCont.do", GetOpenWindowfeature(713, 570));
			            
			            try {
			            	getFormCont_Cross.focus();
			            } catch (e) {
			            	console.error('Error focusing window:', e);
			            }
			        } else {
			            var feature = "status:no;dialogWidth:713px;dialogHeight:570px;edge:sunken;scroll:no";
			            var ret = window.showModalDialog(url, parameter, feature);
			            formURL = ret[0];
			            formDocType = ret[1];
			            
			            if (formURL != "cancel") {
			                openDraftUI(formURL, formDocType);
			            }
			        }
		 		}
		 		else {
		 			newFormURL = formUrl;
		 			newFormDocType = formDocType;
		 	        openDraftUI("DRAFT");
		 		}
		 	}	
		 	
		 	var editable = "";
		 	var newFormURL = "";
		 	var newFormDocType = "";
			function btnReuse_onclick_complete(ret) {
				if(ret[0] != "cancel") {
					newFormURL = ret[0];
			        newFormDocType = ret[1];
			        newFormID = newFormURL.substring(newFormURL.lastIndexOf("/")+1);
			        
					var pAlertContent;
					 $.ajax({
				    		type : "POST",
				    		dataType : "text",
				    		data : {
				    			formID : newFormID,
				    			companyID : orgCompanyID
				    		},
				    		url : "/ezApprovalG/getFormDetail.do",
				    		success: function(xml){
								xml = loadXMLString(xml);
								
								var currConnflag = getNodeText(GetElementsByTagName(xml, 'FORMCONNFLAG')[0]);
								var currVersion = getNodeText(GetElementsByTagName(xml, 'FORMVERSION')[0]);
		
								if(currConnflag === 'Y') {
									pAlertContent = '연동양식은 재사용 할 수 없습니다.';
									OpenAlertUI(pAlertContent);
									return;
								}
								
								openDraftUI("DRAFT");
							},
							error: function() {
								pAlertContent = '문서 재사용에 실패하였습니다.';
								OpenAlertUI(pAlertContent);
							}        			
			    	});
				}
		     }
			 
			function openDraftUI(pDraftFlag) {
		        var pArgument = new Array();

		        pArgument[0] = pUserID;
		        pArgument[1] = newFormURL;
		        pArgument[2] = pDraftFlag;
		        pArgument[3] = newFormDocType;
	            pArgument[4] = "0";
	            pArgument[5] = "";
	            pArgument[6] = "";
	            pArgument[7] = "";
	            pArgument[8] = listTypeValue;
	            pArgument[9] = editable;
	            pArgument[10] = pDocID;
	            pArgument[11] = pOrgDocID;
	            pArgument[12] = 1;
	            			
	            var params = {
	            	formURL: escape(pArgument[1]),
	            	draftFlag: escape(pArgument[2]),
	            	formDocType: escape(pArgument[3]),
	            	susinSN: escape(pArgument[4]),
	            	docState: escape(pArgument[5]),
	            	aprState: escape(pArgument[6]),
	            	isTmpDoc: escape(pArgument[7]),
	            	listType: escape(pArgument[8]),
	            	isUsed: escape(pArgument[9]),
	            	beforeDocID: escape(pArgument[10]),
	            	orgDocID: escape(pArgument[11]),
	            	fromGongram: escape(pArgument[12])
	            };
	            
				var openLocation = "";
				
				if (useWebHWP == "YES") {
					openLocation = "/ezApprovalG/draftuiWHWP.do?" + new URLSearchParams(params);	
				} else {
					openLocation = "/ezApprovalG/draftuiHWP.do?" + new URLSearchParams(params);
				} 
				
		        var result = GetOpenWindow(openLocation, "", 1050, 970, "YES");
		        window.close();
		    }
	    </script>
	</head>
	<body class="popup" onload="return window_onload()" onbeforeunload="return window_onbeforeunload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <%-- 2022-06-23 홍승비 - 전자결재 미리보기 영역에서 문서보기 페이지 접근 시, 모든 버튼을 ul 태그부터 숨김처리 --%>
		        		<ul <c:if test="${isPreview == 'Y'}">style="display:none"</c:if>>
                            <c:if test="${approvalFlag == 'G'}">
    	                        <li id="btnGongRam" style="display: none"><span onclick="btnGongRam_onclick()"><spring:message code='ezApprovalG.t1442'/></span></li>
                            </c:if>
                            <c:if test="${approvalFlag != 'G'}">
                              <li id="btnGongRam" style="display:none"><span onclick ="return btnGongRam_onclick()" ><spring:message code='ezApprovalG.hyj22'/></span></li>
                            </c:if>
	                        <li id="btnCallback" style="display:none"><span onclick="return btncallback_onclick()" ><spring:message code='ezApprovalG.t66'/></span></li>
							<li id="btnForceCallback" style="display:none"><span onclick="return btnforcecallback_onclick()"><spring:message code='ezApprovalG.t2005'/></span></li>
							<li id="tbtnReturn" style="display: none;"><span onclick="return btnReturn_onclick()"><spring:message code='ezApprovalG.t1434'/></span></li>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        <li id="btnSummary"><span onclick="return btnSummaryView()"><spring:message code='ezApprovalG.t1203'/></span></li> <%-- 요약전 --%>
	                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
	                        <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
				            <c:if test="${useBoard == 'YES'}">
				          		<li id="btnBoard" style="display: none;"><span onclick="return NewItem_onclick()"><spring:message code='ezApprovalG.t1514'/></span></li>
				            </c:if>
				            <c:if test="${formID != '2018000000'}">
				          		<li id="btnReuse" style="display: none;"><span onClick="return btnReuse_onclick('reuse')"><spring:message code='ezApprovalG.t990048'/></span></li>
				            </c:if>
				            <li id="btnPrint"><span class="icon16 popup_icon16_print" onclick="return btnPrint_onclick()"></span></li>
	                        <c:if test="${useExternalMailServer == 'NO'}">
	                        	<li id="btnMail" style="display:none"><span class="icon16 popup_icon16_mail_gray" onclick="return btnMail_onclick()"></span></li>
	                        </c:if>
                            <select class="draftAllTypeB" id="an" onchange="changeAn()" <c:if test="${fn:length(group) < 2}">style="display:none"</c:if>>
                            <c:forEach var="item" items="${group}">
                                <option value="<c:out value='${item.docID}'/>"><c:out value='${item.tabSN}'/><spring:message code='ezApprovalG.HSBDa04'/></option>
                            </c:forEach>
                            </select>
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
	        <tr>
	            <td style="padding-bottom:10px;height:800px;" id="messageWHWPEditor">
		    		<iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="/ezApprovalG/WHWPEditor.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	            </td>
	        </tr>
	        <tr>
	            <td height="20">
	                <table class="file" style="height:80px; margin-top:-9px;">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td style=" width:62%; border-right:1px solid #d5d5d5; overflow: auto;">

	                            <div id="lstAttachLink" style="height:70px;"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
	                        </td>
	                        <td style=" width:30%; overflow: auto;">
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
		<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingLayer">
	        <img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
	    </div>
	</body>
</html>
