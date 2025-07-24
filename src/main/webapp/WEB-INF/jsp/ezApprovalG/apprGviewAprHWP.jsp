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
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezViewApr_HWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_HWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
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
			
			function btnOpinion_onclick() {
			    //openOpinionViewUI();
				openOpinionUI_New("Show");
			}
	
			window.onresize = function () {
			    HwpCtrl.style.height = null;
			    HwpCtrl.height = document.documentElement.clientHeight - 150;
			}
	
			function window_onload() {
			    window.onresize();
			
			    HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
			    HwpCtrl.SetSaveMode(1);
			
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
			    if (pListTypeValue == "4" || pListTypeValue == "97")
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
			    
			    if(useExternalMailServer == "NO") {
			    	$("#btnMail").css("display","");
			    }
			}
	
	
			function btnPrint_onclick() {
			    HwpCtrl.PrintDocument("", true);
			}
			
			function btnClose_onclick() {
				//2019.02.21 유은정 : 포탈개인화 결재리스트에서 포틀릿 정보 가져오는 매서드 추가
		        if (parent.opener != null && parent.opener.getApprovalList != undefined) {
		        	parent.opener.clearAbsence(true);
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
			    var url = "/ezApprovalG/ezDocInfoView.do?docID=" + docID + "&ingFlag=APR";
			    var feature = "";
				if (typeof approvalFlag !== "undefined" && approvalFlag == "G") {
					feature = "status:no;dialogWidth:400px;dialogHeight:540px;help:no;scroll:no;edge:sunken;";
				}else {
					feature = "status:no;dialogWidth:300px;dialogHeight:540px;help:no;scroll:no;edge:sunken;";
				}
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
	                        <li id="btnMail" style="display:none"><span onclick="return btnMail_onclick()"><spring:message code='ezApprovalG.t62'/></span></li>
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
	                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "<c:out value='${hwpToolbar}'/>", "");</script>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td height="20">
	                <table class="file" style="height:80px;">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td style="width:62%; border-right:1px solid #d5d5d5; overflow: auto;">
	                            <div id="lstAttachLink" style="height:70px;"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
	                        </td>
	                        <td style="width:30%;">
								<div id="lstAttachLinkDoc" style="height:70px;"></div>
	                        </td>
							<td class="pos2" style="display:none;width:8%; background:#fffcfa;">
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
								<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a><br/>
							</td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	</body>
</html>