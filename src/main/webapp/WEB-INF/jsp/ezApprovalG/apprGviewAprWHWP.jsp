<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t367'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
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
	        	var mHeight = document.documentElement.clientHeight - 172 - document.getElementById("message").offsetTop + "px";
	       		message.Resize(mHeight);
	        }
	
			function window_onload() {
			    if (docHref == "") {
			        var pAlertContent = "<spring:message code='ezApprovalG.t1439'/><br><spring:message code='ezApprovalG.t1440'/>";
				    OpenAlertUI(pAlertContent);
				    btnClose_onclick();
				    return;
				}
			
			    if (pDocState == "015" && pOrgDocID.length >= 20 && "<c:out value='${listTypeValue}'/>" == "99") {
			        btnGongRam.style.display = "";
			        pOpinionType = "";
			    }
			    pDocID = docID;
			    pDocHref = docHref;
			    pOpinionFlag = opinionFlag;
			    pListTypeValue = listTypeValue;
			    if (pListTypeValue == "4") {
					pListSusin = listSusin;
				}	
				cancelYN();
				setAttachGuideText();
			}
	
			// 웹 한글 기안기용
	    	function Editor_Complete() {
	    		if (pDocHref != "") {
				    var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pDocHref);
				    //var URL = document.location.protocol + "//" + "10.0.100.108" + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pDocHref);
				    message.Open(URL, "", "", function (res) { 
					    if (res.result) {
					    	if (listTypeValue == "21") {
					    		setAttachInfo(pDocID, "TMP", lstAttachLink);
					    	} else {
						        setAttachInfo(pDocID, "APR", lstAttachLink);
					    	}
					        GetExchInfo();
					        //SignCheck();
					        //hideProgress();
				
					        if (pHasOpinion == "Y") {
					            var pInformationContent = "<spring:message code='ezApprovalG.t9'/><br> <spring:message code='ezApprovalG.t170'/>";
							    OpenInformationUI(pInformationContent, btnOpinion_onclick_complete);
							}
				        }
				        else {
				            //hideProgress();
				            var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
							OpenAlertUI(pAlertContent);
							message.Clear();
				        }
					    message.EditMode(0);
					    message.ScrollPosInfo(0, 0);
					    
					    window.onresize();
					    
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
		        	parent.opener.getApprovalList("draft");
		        }
			
			    window.close();
			}
	
			function btnSave_onclick() {
			    HwpCtrl.SetDocumentInfo(pFormID);
			    HwpCtrl.SaveFile("");
			}
			
			function btnMail_onclick() {
			    window.open("/ezEmail/mailWrite.do?docHref=" + docHref + "&cmd=docsend&docID=" + docID + "&target=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
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
				    parent.opener.getApprovalList("draft");
				}
		    
		        window.close();
			}
	
			function window_onbeforeunload() {
			    try {
			        window.opener.openergetDocInfo();
			    }
			    catch (e) { }
			    try {
			        window.opener.Refresh_Window();
			    } catch (e) { }
			}
	
			var ezdocinfog_view_cross_dialogArguments = new Array();
			function btnDocInfo_onclick() {
				ezdocinfog_view_cross_dialogArguments[0] = "";
			    ezdocinfog_view_cross_dialogArguments[1] = btnDocInfo_onclick_Complete;
			    var url = "/ezApprovalG/ezDocInfoView.do?docID=" + docID + "&ingFlag=APR";
			    //var feature = "status:no;dialogWidth:420px;dialogHeight:495px;help:no;scroll:no;edge:sunken;";
			    //var RtnVal = window.showModalDialog(url, "", feature);
			    DivPopUpShow(420, 500, url);
			}
			
			function btnDocInfo_onclick_Complete() {
		        DivPopUpHidden();
		    }
			
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
			
			function btnforcecallback_onclick() {
				var pMsg = "문서를 강제회수하시겠습니까?";
				OpenInformationUI(pMsg, btnforcecallback_onclick_Complete);
			}
		    function btnforcecallback_onclick_Complete(ans) {
		        if (ans) {
		            doCancelForce();
		        }
			}
			function doCancelForce() {
				var retVal = ExcuteInfo("CALLBACK_BEFORE", "DRAFT"); // pdraftflag 정상적으로 가져오게 수정해야함
				if (!retVal) {
					return;
				}

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
	        	
		        if (RtnVal == "TRUE") {
					SendMailToCancel_Function(getAprLinefor("APR", pDocID));
					attitude_annual_conn(pDocID);
					
					ExcuteInfo("CALLBACK_AFTER", "DRAFT");

					OpenAlertUI("문서를 회수하였습니다.", function() {
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
	            g_szUserID = pUserID;
	            g_senderinfo = "";
	            for (i = 0; i < objNodes.length; i++) {
	                var nowstate = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW")[i])[0])[12]);
	                var LineUserID = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW")[i])[0])[4]);
	                var LineSN = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW")[i])[0])[0]);
	                if (nowstate == "002" || nowstate == "003") {
	                    if (LineSN != "1") {
	                        sendmail(LineUserID, pDocTitle, arr_userinfo[2], js_yyyy_mm_dd_hh_mm_ss(), "callback", "", true)
	                    }
	                }

	            }
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
				var pMsg = "문서를 회수하시겠습니까?";
				OpenInformationUI(pMsg, btncallback_onclick_Complete);
		    }
		    function btncallback_onclick_Complete(ans) {
		        if (ans) {
		            doCancel();
		        }
			}
			function doCancel() {
				var retVal = ExcuteInfo("CALLBACK_BEFORE", "DRAFT"); // pdraftflag 정상적으로 가져오게 수정해야함
				if (!retVal) {
					return;
				}

				var result = "";

				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/doCancel.do",
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
				
				var RtnVal = getNodeText(loadXMLString(result).documentElement);

				if (RtnVal == "TRUE") {
					var rows = GetElementsByTagName(loadXMLString(getAprLinefor("APR", pDocID)), "ROW");
					var drafterRow = rows[rows.length - 1];
					var cell = drafterRow.firstElementChild;

					var docTitle = message.GetFieldText("doctitle").trim();
					var drafterName = SelectSingleNodeValue(cell, "DATA13");
					var draftDate = SelectSingleNodeValue(cell, "DATA2");

					SendMailToCancel(pDocID, docTitle, drafterName, draftDate); 
					attitude_annual_conn(pDocID);

					ExcuteInfo("CALLBACK_AFTER", "DRAFT");

					OpenAlertUI("문서를 회수하였습니다.", function() {
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

				if (aprUserID === pUserID && aprType === "018") {
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
	    	
	    </script>
	</head>
	<body class="popup" onload="return window_onload()" onbeforeunload="return window_onbeforeunload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul>
	                        <li id="btnGongRam" style="display: none"><span onclick="btnGongRam_onclick()"><spring:message code='ezApprovalG.t1442'/></span></li>
	                        <li id="btnCallback" style="display:none"><span onclick="return btncallback_onclick()" ><spring:message code='ezApprovalG.t66'/></span></li>
							<li id="btnForceCallback" style="display:none"><span onclick="return btnforcecallback_onclick()"><spring:message code='ezApprovalG.t2005'/></span></li>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
	                        <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
	                        <li id="btnPrint"><span class="icon16 popup_icon16_print" onclick="return btnPrint_onclick()"></span></li>
	                        <c:if test="${useExternalMailServer == 'NO'}">
	                        	<li id="btnMail" style="display:none"><span class="icon16 popup_icon16_mail_gray" onclick="return btnMail_onclick()"></span></li>
	                        </c:if>
	                    </ul>
	                </div>
	                <div id="close">
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
	            <td style="padding-bottom:10px;height:800px;" >
		    		<iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="/ezApprovalG/WHWPEditor.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	            </td>
	        </tr>
	        <tr>
	            <td height="20">
	                <table class="file" style="height:80px; margin-top:-9px;">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td style=" width:62%; border-right:1px solid #d5d5d5;">
	                            <div id="lstAttachLink" style="height:70px;"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
	                        </td>
	                        <td class="pos2" style="width:8%; background:#fffcfa;">
								<a class="imgbtn imgbck" style="width:60px;"><span style="padding:0px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
								<a class="imgbtn imgbck" style="width:60px"><span onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a> 
	                        </td>
	                        <td style=" width:30%;">
								<div id="lstAttachLinkDoc" style="height:70px;"></div>
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
	</body>
</html>