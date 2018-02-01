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
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/ezAprDocAttach/getDocAttach.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/conn/conn_HWP.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/escapenew.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/printer/appandbody.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/Common/Kaoni_ActiveX.js") %>"></script>
	    <script type="text/javascript">
	    	var pNoneActiveX = "<%=NoneActiveX%>";
	        var pDocID = '<%=_DocID%>';
	        var pDocHref = '<%=_DocHref%>';
	        var pListSusin = '<%=_ListSusin%>';
	        var porgDocID = '<%=_orgDocID%>';
	        var pFormID = '<%=_formID%>';
	        var pTitle = '<%=_Doctitle%>';
	        var pOpinionFlag;
	        var pListTypeValue = 4;
	        var flag = false;
	        var PrevOpinionFlag = false;
	        var NextOpinionFlag = true;
	        var doctitle = "";
	        var pOrgAttach = "";
	        var pendDir = "<%=_endDir%>"
			var xmlhttp = createXMLHttpRequest();
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
	        var companyID = "<%=userinfo.CompanyID%>";
	        var pUserID = arr_userinfo[1];
	        var SignCheckFlag = "<%=SignCheck%>";
	        var pUse_Editor = "<%= Use_Editor%>";
	
	        window.onresize = function () {
	            HwpCtrl.style.height = null;
	            HwpCtrl.height = document.documentElement.clientHeight - 150;
	        }
	
	        function btnOpinion_onclick() {
	            var parameter = new Array();
	            parameter[0] = pDocID;
	            parameter[1] = "Show";
	
	            var url = "/myoffice/ezApprovalG/formContainer/AprEndOpinion.aspx";
	            var feature = "status:no;dialogWidth:530px;dialogHeight:420px;scroll:no;edge:sunken"
	            var ret = window.showModalDialog(url, parameter, feature);
	        }
	
	        function CheckOpinionInfo() {
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	
	            xmlhttp.open("POST", "/myoffice/ezApprovalG/formContainer/aspx/getEndOpinionInfo.aspx", false);
	            xmlhttp.send(xmlpara);
	
	            Resultxml = loadXMLString(xmlhttp.responseText);
	
	            var NodeList = Resultxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
	            if (NodeList.length > 0)
	                return true;
	            else
	                return false;
	        }
	
	        function window_onload() {
	            window.onresize();
	
	            HwpCtrl.SetSaveMode(1);
	
	            if ("<%=PASS%>" != "<RESULT>TRUE</RESULT>") {
	                QuitWindow();
	            }
	            else if (pDocHref != "") {
	                showProgress("<spring:message code='ezApprovalG.t368'/>");
	                var URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(pDocHref);
	                var isTrue = HwpCtrl.LoadFile(URL, false);
	
	                if (isTrue) {
	
	                    if (pFormID == "") {
	                        btnSave.style.display = "none";
	                    }
	
	                    setAttachInfo(pDocID, "END", lstAttachLink);
	                    hideProgress();
	
	                    var Rtnval = CheckOpinionInfo();
	                    if (Rtnval) {
	                        var pInformationContent = "<spring:message code='ezApprovalG.t9'/><br> <spring:message code='ezApprovalG.t170'/>";
	                        var Ans = OpenInformationUI(pInformationContent);
	
	                        if (Ans) {
	                            btnOpinion_onclick();
	                        }
	                    }
	
	                    if (SignCheckFlag == "N")
	                        SignCheck();
	
	                    HwpCtrl.SetImgReg();
	                }
	                else {
	                    hideProgress();
	                    var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
	                    OpenAlertUI(pAlertContent);
	                    HwpCtrl.ClearDocument();
	                }
	                HwpCtrl.ChangeMode(3);
	            }
	
	            HwpCtrl.SetFieldFocus("doctitle");
	            HwpCtrl.ezSetScrollPosInfo(0);
	        }
	
			function QuitWindow() {
			    menu.style.display = "none";
			    OpenAlertUI("<spring:message code='ezApprovalG.t1443'/><br><spring:message code='ezApprovalG.t1444'/>");
			    btnClose_onclick();
			    window.close();
			}
	
			function OpenAlertUI(pAlertContent) {
			    var parameter = pAlertContent;
			    var url = "/myoffice/ezApprovalG/ezAPRALERT.aspx";
			    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
			    var RtnVal = window.showModalDialog(url, parameter, feature);
			}
	
			function btnPrint_onclick() {
			    HwpCtrl.PrintDocument("", true);
			}
			
			function btnClose_onclick() {
			    window.close();
			}
	
			function OpenInformationUI(pInformationContent) {
			    var parameter = pInformationContent;
			    var url = "/myoffice/ezApprovalG/ezAPROPINION.aspx";
			    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
			    var RtnVal = window.showModalDialog(url, parameter, feature);
			
			    return RtnVal;
			}
	
			function btnSave_onclick() {
			    HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
			    HwpCtrl.SetDocumentInfo(pFormID);
			    var hwpDoctitle = HwpCtrl.GetFieldText("doctitle").replace("\r\n", "");
			    hwpDoctitle = hwpDoctitle.replace(/\\/ig, '').replace(/\//ig, '').replace(/:/ig, '').replace(/\*/ig, '').replace(/\?/ig, '').replace(/“/ig, '').replace(/</ig, '').replace(/>/ig, '').replace(/|/ig, '').replace("“", "").replace("|", "");
			    HwpCtrl.SaveFile("", hwpDoctitle);
			}
	
			function btnMail_onclick() {
			    window.open("/myoffice/ezEmail/mail_write.aspx?DocHref=<%=_DocHref%>&cmd=docsend&DocID=<%=_DocID%>" + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
			}
	
			function btnBoard_onclick() {
			    var wWeight = "345";
			    var wHeight = "660";
			
			    var heigth = window.screen.availHeight;
			    var width = window.screen.availWidth;
			
			    var left = (width - wWeight) / 2;
			    var top = (heigth - wHeight) / 2;
			    var ret = window.showModalDialog("/myoffice/ezBoardSTD/WriteBoardSelect_Modal.aspx", "",
			        "DialogHeight:660px;DialogWidth:345px;status:no;help:no;edge:sunken,top=" + top + ",left = " + left);
			
			    if (typeof (ret) != "undefined") {
			        pBoardID = ret[0];
			
			        if (pBoardID == "" || typeof (pBoardID) == "undefined") {
			            return;
			        }
			
			        var pheight = window.screen.availHeight;
			        var pwidth = window.screen.availWidth;
			        var pTop = (pheight - 720) / 2;
			        var pLeft = (pwidth - 765) / 2;
			
			        if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4") {
			            alert(strLang1031);
			        }
			        else {
			            if (pUse_Editor == "" || pUse_Editor == "CK") {
			                window.open("/myoffice/ezBoardSTD/NewBoardItem.aspx?BoardID=" + pBoardID + "&Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pDocID + "&Url=" + pDocHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
			            }
			            else {
			                window.open("/myoffice/ezBoardSTD/NewBoardItem_IE.aspx?BoardID=" + pBoardID + "&Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pDocID + "&Url=" + pDocHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
			            }
			        }
			    }
			}
	
			function btnhistory_onclick() {
			    getHistory();
			}
	
			function getHistory() {
			    var URL = "/myoffice/ezApprovalG/ezAPRHISTORY/ezAPRHISTORY_Cross.aspx?DocID=" + pDocID;
			    centerOpenWindow(URL, 730, 430);
			}
	
			function centerOpenWindow(wfileLocation, wWeight, wHeight) {
			    try {
			        var heigth = window.screen.availHeight;
			        var width = window.screen.availWidth;
			
			        var left = (width - wWeight) / 2;
			        var top = (heigth - wHeight) / 2;
			
			        window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=0,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
			
			    } catch (e) {
			        alert("centerOpenWindow :: " + e.description);
			    }
			}
	
			function btnDocInfo_onclick() {
			    var url = "/myoffice/ezApprovalG/ezDocInfo/ezDocInfoG_View.aspx?DocID=" + pDocID + "&IngFlag=END";
			    var feature = "status:no;dialogWidth:420px;dialogHeight:495px;help:no;scroll:no;edge:sunken;";
			    var RtnVal = window.showModalDialog(url, "", feature);
			}
	
			function SignCheck() {
			    var SignXML = createXmlDom();
			    var xmlhttp = createXMLHttpRequest();
			    var xmlpara = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlpara, objNode, "PARAMETER");
			    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
			
			    xmlhttp.open("Post", "/myoffice/ezApprovalG/ezAPRSIGN/aspx/getSignInfo.aspx", false);
			    xmlhttp.send(xmlpara);
			
			    if (loadXMLString(xmlhttp.responseText).xml == "") {
			        SaveSignCheck();
			        return;
			    }
			
			    var NodeList;
			    NodeList = loadXMLString(xmlhttp.responseText).selectNodes("SIGNINFOS/SIGNINFO");
			    if (NodeList.length <= 0) {
			        SaveSignCheck();
			        return;
			    }
			
			    SignXML = loadXMLString(xmlhttp.responseText);
			    var rtnVal = putSignXML(SignXML);
			    if (rtnVal) {
			        SaveFile();
			
			        SaveSignCheck();
			    }
			}
	
			function putSignXML(SignXML) {
			    var retVal = false;
			    try {
			        var NodeList;
			        NodeList = SignXML.selectNodes("SIGNINFOS/SIGNINFO");
			        if (NodeList.length > 0) {
			            for (i = 0; i < NodeList.length; i++) {
			                var SignType = getNodeText(NodeList.item(i).selectSingleNode("SIGNTYPE"));
			                var SignName = getNodeText(NodeList.item(i).selectSingleNode("SIGNNAME"));
			                var SignCont = getNodeText(NodeList.item(i).selectSingleNode("CONTENT"));
			
			                if (HwpCtrl.CheckFieldExist(SignName)) {
			                    retVal = true;
			                    if (SignType == "TEXT") {
			                        HwpCtrl.SetFieldText(SignName, SignCont);
			                    }
			                    else if (SignType == "HTML") {
			
			                        HwpCtrl.AppendFieldText(SignName, SignCont, true, true, true);
			                    }
			                    else if (SignType == "PROXY") {
			                        HwpCtrl.SetFieldText(SignName, " ");
			                        HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(SignCont), 3, 0, 0, true, 2);
			                        HwpCtrl.AppendFieldText(SignName, strLang17, true);
			                    }
			                    else if (SignType == "IMAGE") {
			                        var img = SignCont.split("::");
			                        HwpCtrl.SetFieldText(SignName, "");
			                        if (img.length >= 1)
			                            HwpCtrl.SetFieldImage(SignName, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(img[0]), 3, 0, 0, true, 2);
			
			                        if (img.length >= 2)
			                            HwpCtrl.AppendFieldText(SignName, img[1], true);
			
			                    }
			                }
			            }
			        }
			    } catch (e) {
			        alert("putSignXML : " + e.description);
			        return false;
			    }
			    return retVal;
			}
	
			function SaveFile() {
			    var xmlhttp = createXMLHttpRequest();
			    var xmlpara = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlpara, objNode, "PARAMETER");
			    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
			    createNodeAndInsertText(xmlpara, objNode, "Html", HwpCtrl.GetCloneData("", "HWP"));
			
			    xmlhttp.open("POST", "aspx/saveendfilehwp.aspx.aspx", false);
			    xmlhttp.send(xmlpara);
			
			    return xmlhttp.responseText;
			}
	
			function SaveSignCheck() {
			    var xmlhttp = createXMLHttpRequest();
			    var xmlpara = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlpara, objNode, "PARAMETER");
			    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
			    createNodeAndInsertText(xmlpara, objNode, "SignCheck", "Y");
			
			    xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/UpdateSignCheck.aspx", false);
			    xmlhttp.send(xmlpara);
			
			    return xmlhttp.responseText;
			}
	    </script>
	</head>
	<body class="popup" style="overflow: hidden" onload="javascript:window_onload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul>
	                        <li id="btnMail"><span onclick="return btnMail_onclick()"><spring:message code='ezApprovalG.t1436'/></span></li>
	                        <li id="btnBoard"><span onclick="return btnBoard_onclick()"><spring:message code='ezApprovalG.t1445'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
	                        <li id="btnSave"><span onclick="return btnSave_onclick()">PC<spring:message code='ezApprovalG.t59'/></span></li>
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
	                        <th><spring:message code='ezApprovalG.t65'/></th>
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