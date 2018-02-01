<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t367'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<%=MakeFileVersionPath(RM.GetString("e2")) %>" type="text/css">
	    <script type="text/javascript" src="<%=MakeFileVersionPath(RM.GetString("e1")) %>"></script>
	    <script type="text/javascript" src="<%= MakeFileVersionPath("/myoffice/common/XmlHttpRequest.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/mouseeffect.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("ezViewApr_HWP.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezAprDocAttach/getDocAttach.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezAPRATTACH/attachG.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/conn/conn_HWP.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/escapenew.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/printer/appandbody.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/Common/Kaoni_ActiveX.js") %>"></script>
	    <script type="text/javascript">
	    	var pNoneActiveX = "<%=NoneActiveX%>";
	        var DocID = '<%=_DocID%>'
	        var DocHref = '<%=_DocHref%>'
	        var OpinionFlag = '<%=_OpinionFlag%>'
	        var ListTypeValue = '<%=_ListTypeValue%>'
	        var ListSusin = '<%=_ListSusin%>'
	        var pDocState = '<%=_docState%>'
	        var pOrgDocID = '<%=_orgDocID%>'
	        var isOpinion = '<%=_showOpinion%>'
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
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "<%=userinfo.UserID%>";
			arr_userinfo[2] = "<%=userinfo.DisplayName%>";
	        arr_userinfo[3] = "<%=userinfo.Title%>";
	        arr_userinfo[4] = "<%=userinfo.DeptID%>";
	        arr_userinfo[5] = "<%=userinfo.DeptName%>";
	        arr_userinfo[6] = "<%=userinfo.Jikchek%>";
	        arr_userinfo[8] = "<%=userinfo.Email%>";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "<%=_pSusinAdmin%>";
			arr_userinfo[11] = "<%=userinfo.DisplayName1%>";
	        arr_userinfo[12] = "<%=userinfo.DisplayName2%>";
	        arr_userinfo[13] = "<%=userinfo.Title1%>";
	        arr_userinfo[14] = "<%=userinfo.Title2%>";
	        arr_userinfo[15] = "<%=userinfo.DeptName1%>";
	        arr_userinfo[16] = "<%=userinfo.DeptName2%>";
	        pUserID = arr_userinfo[1];
	
	        var pHasOpinion = "<%=HASOPINIONYN%>";
			var pOpinionType = "Show";
			var pUse_Editor = "<%= Use_Editor%>";
			
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
			
			    if (DocHref == "") {
			        var pAlertContent = "<spring:message code='ezApprovalG.t1439'/><br><spring:message code='ezApprovalG.t1440'/>";
				    OpenAlertUI(pAlertContent);
				    btnClose_onclick();
				    return;
				}
			
			    if (pDocState == "015" && pOrgDocID.length >= 20 && "<%=_ListTypeValue%>" == "99") {
			        btnGongRam.style.display = "";
			        pOpinionType = "";
			    }
			    pDocID = DocID;
			    pDocHref = DocHref;
			    pOpinionFlag = OpinionFlag;
			    pListTypeValue = ListTypeValue;
			    if (pListTypeValue == "4")
			        pListSusin = ListSusin;
			
			    if (pDocHref != "") {
			        showProgress("<spring:message code='ezApprovalG.t368'/>");
				    var URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(pDocHref);
				    var isTrue = HwpCtrl.LoadFile(URL, false);
			
				    if (isTrue) {
				        setAttachInfo(pDocID, "APR", lstAttachLink);
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
			    window.open("/myoffice/ezEmail/mail_write.aspx?DocHref=<%=_DocHref%>&cmd=docsend&DocID=<%=_DocID%>" + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
			}
	
			function btnhistory_onclick() {
			    getHistory();
			}
	
			function btnGongRam_onclick() {
			    var xmlhttp = createXMLHttpRequest();
			    var xmlpara = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlpara, objNode, "PARAMETER");
			    createNodeAndInsertText(xmlpara, objNode, "DocID", DocID);
			    createNodeAndInsertText(xmlpara, objNode, "UserID", ListSusin);
			
			    xmlhttp.open("Post", "/myoffice/ezApprovalG/ReceivUI/aspx/GongRamUpdate.aspx", false);
			    xmlhttp.send(xmlpara);
			
			    if (getNodeText(loadXMLString(xmlhttp.responseText)) == "TRUE") {
			        var pAlertContent = "<spring:message code='ezApprovalG.t1441'/>";
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
			    var url = "/myoffice/ezApprovalG/ezDocInfo/ezDocInfoG_View.aspx?DocID=" + DocID + "&IngFlag=APR";
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
	                        <li id="btnMail"><span onclick="return btnMail_onclick()"><spring:message code='ezApprovalG.t1436'/></span></li>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
	                        <li id="btnDocInfo"><span onclick="return btnDocInfo_onclick()"><spring:message code='ezApprovalG.t54'/></span></li>
	                        <li id="btnhistory"><span onclick="btnhistory_onclick()"><spring:message code='ezApprovalG.t61'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li id="btnClose"><span onclick="return btnClose_onclick()"><spring:message code='ezApprovalG.t64'/></span></li>
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
	                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "<%=_HwpToolbar%>", "");</script>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td height="20">
	                <table class="file">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td>
	                            <div id="lstAttachLink"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0"></iframe>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	</body>
</html>