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
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezViewApr_HWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_HWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
	    <script type="text/javascript">
	        var docID = "${docID}";
	        var docHref = "${docHref}";
	        var opinionFlag = "${opinionFlag}";
	        var listTypeValue = "${listTypeValue}";
	        var listSusin = "${listSusin}";
	        var pDocState = "${docState}";
	        var pOrgDocID = "${orgDocID}";
	        var isOpinion = "${showOpinion}";
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
	
	        var arr_userinfo = new Array();
	        arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "${userInfo.id}";
		    arr_userinfo[2]  = "${userInfo.displayName}";
		    arr_userinfo[3]  = "${userInfo.title}";
		    arr_userinfo[4]  = "${userInfo.deptID}";
		    arr_userinfo[5]  = "${userInfo.deptName}";
		    arr_userinfo[6]  = "${userInfo.jikChek}";
		    arr_userinfo[7]  = "N";
		    arr_userinfo[8]  = "${userInfo.email}";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "${susinAdmin}";
		    var pCompanyID = "${userInfo.companyID}";
		    arr_userinfo[11]  = "${userInfo.displayName1}";
		    arr_userinfo[12]  = "${userInfo.displayName2}";
		    arr_userinfo[13]  = "${userInfo.title1}";
		    arr_userinfo[14]  = "${userInfo.title2}";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";
		    
	        pUserID = arr_userinfo[1];
	
	        var pHasOpinion = "${hasOpinionYN}";
			var pOpinionType = "Show";
			var pUse_Editor = "${useEditor}";
			var approvalFlag = "${approvalFlag}";
			
			function btnOpinion_onclick() {
			    openOpinionViewUI();
			}
	
			window.onresize = function () {
			    HwpCtrl.style.height = null;
			    HwpCtrl.height = document.documentElement.clientHeight - 150;
			}
	
			function window_onload() {
			    window.onresize();
			
			    HwpCtrl.SetSaveMode(1);
			
			    if (docHref == "") {
			        var pAlertContent = "<spring:message code='ezApprovalG.t1439'/><br><spring:message code='ezApprovalG.t1440'/>";
				    OpenAlertUI(pAlertContent);
				    btnClose_onclick();
				    return;
				}
			
			    if (pDocState == "015" && pOrgDocID.length >= 20 && "${listTypeValue}" == "99") {
			        btnGongRam.style.display = "";
			        pOpinionType = "";
			    }
			    pDocID = docID;
			    pDocHref = docHref;
			    pOpinionFlag = opinionFlag;
			    pListTypeValue = listTypeValue;
			    if (pListTypeValue == "4")
			        pListSusin = listSusin;
			
			    if (pDocHref != "") {
			        showProgress("<spring:message code='ezApprovalG.t368'/>");
				    var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(pDocHref);
				    var isTrue = HwpCtrl.LoadFile(URL, false);
			
				    if (isTrue) {
				    	if (listTypeValue == "21") {
				    		setAttachInfo(pDocID, "TMP", lstAttachLink);
				    	} else {
					        setAttachInfo(pDocID, "APR", lstAttachLink);
				    	}
				        GetExchInfo();
				        //SignCheck();
				        hideProgress();
			
				        if (pHasOpinion == "Y") {
				            var pInformationContent = "<spring:message code='ezApprovalG.t9'/><br> <spring:message code='ezApprovalG.t170'/>";
						    var Ans = OpenInformationUI(pInformationContent);
			
						    if (Ans) {
						        btnOpinion_onclick();
						    }
						}
			        }
			        else {
			            hideProgress();
			            var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
						OpenAlertUI(pAlertContent);
						HwpCtrl.ClearDocument();
			        }
			    }
			    HwpCtrl.ChangeMode(3);
			    HwpCtrl.SetFieldFocus("doctitle");
			    HwpCtrl.ezSetScrollPosInfo(0);
			}
	
	
			function btnPrint_onclick() {
			    HwpCtrl.PrintDocument("", true);
			}
			
			function btnClose_onclick() {
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
		        	 OpenAlertUI(pAlertContent);
					    window.close();
		        }
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
	
			function btnDocInfo_onclick() {
			    var url = "/ezApprovalG/ezDocInfoG_View.do?docID=" + docID + "&ingFlag=APR";
			    var feature = "status:no;dialogWidth:420px;dialogHeight:495px;help:no;scroll:no;edge:sunken;";
			    var RtnVal = window.showModalDialog(url, "", feature);
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
	                        <li id="btnMail"><span onclick="return btnMail_onclick()"><spring:message code='ezApprovalG.t62'/></span></li>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
	                        <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
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
	            <td style="padding-bottom: 10px">
	                <div style="height: 100%">
	                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "${hwpToolbar}", "");</script>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td height="20">
	                <table class="file" style="height: 70px;">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td>
	                            <div id="lstAttachLink" style="height: 65px;"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	</body>
</html>