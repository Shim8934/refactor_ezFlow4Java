<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t66'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <script type="text/javascript" src="<%= MakeFileVersionPath("/myoffice/common/XmlHttpRequest.js") %>"></script>
	    <link rel="stylesheet" href="<%=MakeFileVersionPath(RM.GetString("e2")) %>" type="text/css">
	    <script type="text/javascript" src="<%=MakeFileVersionPath(RM.GetString("e1")) %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/common/mouseeffect.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("/myoffice/ezApprovalG/conn/conn_HWP.js") %>"></script>
	    <script type="text/javascript" src="<%=MakeFileVersionPath("../ezDocInfo/setLogData.js") %>"></script>
	    <script type="text/javascript">
	    	var pNoneActiveX = "<%=NoneActiveX%>";
	        var xmlhttp = createXMLHttpRequest();
	        var pDocID = '<%=_DocID%>';
	        var pDocHref = '<%=_DocHref%>';
	        var pListType = '<%=_ListType%>';
	        var pUserID = '<%=userinfo.UserID%>';
	        var pDraftFlag = "DRAFT";
	
	        function window_onload() {
	            HwpCtrl.SetSaveMode(1);
	
	            if (pDocHref != "") {
	                showProgress("<spring:message code='ezApprovalG.t368'/>");
	
				    var URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(pDocHref);
				    var isTrue = HwpCtrl.LoadFile(URL, false);
			
				    if (isTrue) {
				        hideProgress();
				    }
				    else {
				        hideProgress();
				        var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
						OpenAlertUI(pAlertContent);
						HwpCtrl.ClearDocument();
			        }
			    }
	            
			    HwpCtrl.SetFieldFocus("doctitle");
			    HwpCtrl.ezSetScrollPosInfo(0);
			}
	
			function OpenAlertUI(pAlertContent) {
			    var parameter = pAlertContent;
			    var url = "/myoffice/ezApprovalG/ezAPRALERT.aspx";
			    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
			    var RtnVal = window.showModalDialog(url, parameter, feature);
			}
		
			function btnCallBack_onclick() {
			    if (pListType == "3") {
			        var pMsg = "<spring:message code='ezApprovalG.t67'/>";
				    var Ans = OpenInformationUI(pMsg);
				    if (Ans) {
				        doCancel(pDocID, pListType);
				    }
				}
				else {
				    var pMsg = "<spring:message code='ezApprovalG.t68'/>";
				    var Ans = OpenInformationUI(pMsg);
				    if (Ans) {
				        doCancel(pDocID, pListType);
				    }
				}
			}
		
			function btnPrint_onclick() {
			    HwpCtrl.PrintDocument("", true);
			}
			
			function btnClose_onclick() {
			    window.close();
			}
	
			function doCancel(pDocID, tempListType) {
			    var xmlhttp = createXMLHttpRequest();
			    var xmlpara = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlpara, objNode, "ASSIGN");
			    createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
			    createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
			
			    xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/doCancel.aspx", false);
			    xmlhttp.send(xmlpara);
			
			    var RtnVal = getNodeText(loadXMLString(xmlhttp.responseText));
			
			    if (RtnVal == "TRUE") {
			        setLogData(pDocID, "AP1002", "", "");
			
			        var ret = ExcuteInfo("BANSONG_BEFORE", "")
			        if (!ret) {
			            pAlertContent = "[<spring:message code='ezApprovalG.t69'/>";
					    OpenAlertUI(pAlertContent);
					    return;
					}
			
			        if (tempListType == "3") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t70'/><br> <spring:message code='ezApprovalG.t71'/>";
					    OpenAlertUI(pAlertContent);
					}
					else {
					    var pAlertContent = "<spring:message code='ezApprovalG.t72'/><br> MIS<spring:message code='ezApprovalG.t73'/>";
					    OpenAlertUI(pAlertContent);
					}
			
			        try {
			            window.opener.openergetDocInfo();
			        }
			        catch (e) { }
			    }
			    else if (RtnVal == "ERR01") {
			        var pAlertContent = "<spring:message code='ezApprovalG.t74'/>";
				    OpenAlertUI(pAlertContent);
				}
				else if (RtnVal == "ERR02") {
				    var pAlertContent = "<spring:message code='ezApprovalG.t75'/>";
				    OpenAlertUI(pAlertContent);
				}
				else if (RtnVal == "ERR03") {
				    var pAlertContent = "<spring:message code='ezApprovalG.t76'/>";
				    OpenAlertUI(pAlertContent);
				}
				else {
				    var pAlertContent = "<spring:message code='ezApprovalG.t77'/>";
				    OpenAlertUI(pAlertContent);
				}
			
			    window.close();
			}
	
			function OpenAlertUI(pAlertContent) {
			    var parameter = pAlertContent;
			    var url = "/myoffice/ezApprovalG/ezAPRALERT.aspx";
			    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
			    var RtnVal = window.showModalDialog(url, parameter, feature);
			}
			
			function OpenInformationUI(pInformationContent) {
			    var parameter = pInformationContent;
			    var url = "/myoffice/ezApprovalG/ezAPROPINION.aspx";
			    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
			    var RtnVal = window.showModalDialog(url, parameter, feature);
			
			    return RtnVal;
			}
	
			function trim(parm_str) {
			    if (parm_str == "")
			        return ""
			    else
			        return rtrim(ltrim(parm_str));
			}
			
			function ltrim(parm_str) {
			    var str_temp = parm_str;
			    while (str_temp.length != 0) {
			        if (str_temp.substring(0, 1) == " ") {
			            str_temp = str_temp.substring(1, str_temp.length);
			        } else {
			            return str_temp;
			        }
			    }
			    return str_temp;
			}
			
			function rtrim(parm_str) {
			    var str_temp = parm_str;
			    while (str_temp.length != 0) {
			        int_last_blnk_pos = str_temp.lastIndexOf(" ");
			        if ((str_temp.length - 1) == int_last_blnk_pos) {
			            str_temp = str_temp.substring(0, str_temp.length - 1);
			        } else {
			            return str_temp;
			        }
			    }
			    return str_temp;
			}
	    </script>
	</head>
	<body class="popup" style="overflow: hidden" onload="javascript:window_onload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul id="icons">
	                        <li id="btnCallBack"><span onclick="return btnCallBack_onclick()"><spring:message code='ezApprovalG.t66'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul id="btnClose">
	                        <li><span onclick="return btnClose_onclick()"><spring:message code='ezApprovalG.t64'/></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="padding-bottom: 10px">
	                <div style="height: 100%">
	                    <object id="HwpCtrl" style="LEFT: 0px; TOP: 0px" height="100%" width="100%" align="center" classid="CLSID:1D50E26E-E51E-4153-93DD-D08745457090" viewastext>
	                        <param name="StartMode" value="3">
	                        <param name="StatusBar" value="0">
	                        <param name="ToolBar" value="<%=_HwpToolbar%>">
	                    </object>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("menu"), "ul", "li", "0");
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>
	</body>
</html>