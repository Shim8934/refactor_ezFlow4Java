<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t185'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_HWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
		
	    <script type="text/javascript">
	        var pDocID = "<c:out value ='${docID}'/>";
	        var pDocHref = "<c:out value ='${docHref}'/>";
	        var pUserID = "<c:out value ='${userInfo.id}'/>";
	        var flag = false;
	        var flag2 = false;
	        var newDocID = "";
	        var stampFlag = false;
	        var NostampFlag = false;
	        var modeflag = false;
	        var companyID = "<c:out value ='${userInfo.companyID}'/>";
			var arr_userinfo = new Array();
			var maxwidth = 659;
			var orgCompanyID = "<c:out value ='${userInfo.companyID}'/>";
			
			var arr_userinfo = new Array();
		    arr_userinfo[0] = "user";
		    arr_userinfo[1]  = "<c:out value ='${userInfo.id}'/>";
		    arr_userinfo[2]  = "<c:out value = '${userInfo.displayName}'/>";
		    arr_userinfo[3]  = "<c:out value = '${userInfo.title}'/>";
		    arr_userinfo[4]  = "<c:out value = '${userInfo.deptID}'/>";
		    arr_userinfo[5]  = "<c:out value = '${userInfo.deptName}'/>";
		    arr_userinfo[6]  = "<c:out value = '${userInfo.jikChek}'/>";
		    arr_userinfo[8]  = "<c:out value = '${userInfo.email}'/>";
	        arr_userinfo[9] = companyID;
	        arr_userinfo[11]  = "<c:out value = '${userInfo.displayName1}'/>";
		    arr_userinfo[12]  = "<c:out value = '${userInfo.displayName2}'/>";
		    arr_userinfo[13]  = "<c:out value = '${userInfo.title1}'/>";
		    arr_userinfo[14]  = "<c:out value = '${userInfo.title2}'/>";
		    arr_userinfo[15]  = "<c:out value = '${userInfo.deptName1}'/>";
		    arr_userinfo[16]  = "<c:out value = '${userInfo.deptName2}'/>";
	
	        var is_Enc = "NONE";
	        var isExternal = false;
	        var isAddress = false;
	        var APRDEPTXML = createXmlDom();
	        var sealPath = ""
	        var sealName = ""
	        var attachName = new Array();
	        var attachPath = new Array();
	        var attachType = new Array();
	        var encodePass = ""
	        var encodePath = ""
	        var attachxmlName = "";
	        var attachxslName = "";
	        var attachxmlPath = "";
	        var attachxslPath = "";
	        var attachbodyPath = "";
	        var psignName = new Array();
	        var psignPath = new Array();
	        var psignCount = 1;
	        var BaseURL = new Array();
	        var AddInfo = new Array();
	        var isGPKI = new Array();
	        var sendCNT = new Array();
	        var pDocInfoXML = createXmlDom();
	        var pDomainName = document.location.protocol + "//" + document.location.hostname
	        var symbolPath = "";
	        var symbolName = "";
	        var logoPath = "";
	        var logoName = "";
	        var pAprType = "";
	        var tempAttachSN = 0;
			var g_progresswin = null;
			var ext = 'hwp';
			
			function showProgress(inforstring) {
			    g_progresswin = window.showModelessDialog("/ezApprovalG/showProgress.do?fileInfo=" + escape(inforstring), "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken;");
			}
			
			function hideProgress() {
			    try {
			        if (g_progresswin)
			            g_progresswin.close();
			    } catch (e) { }
			}
	
			function btnPrint_onclick() {
			    HwpCtrl.PrintDocument("", true);
			}
	
			function window_onbeforeunload() {
			    try {
			        window.opener.openergetDocInfo();
			    } catch (e) { 
					window.parent.openergetDocInfo();
				}
			}
			
			function btnClose_onclick() {
			    window.close();
			}
	
			function openwindow(wfileLocation, wName) {
			    try {
			        var heigth = window.screen.availHeight;
			        var width = window.screen.availWidth;
			        var left = 0;
			        var top = 0;
			
			        if (window.screen.width > 800) {
			            var pleftpos;
			            pleftpos = parseInt(width) - 725;
			            heigth = parseInt(heigth) - 30;
			            width = parseInt(width) - pleftpos;
			            left = pleftpos / 2;
			        }
			        else {
			            heigth = parseInt(heigth) - 30;
			            width = parseInt(width) - 10;
			        }
			        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
			    } catch (e) {
			        alert("openwindow :: " + e.description);
			    }
			}
	
			function OpenInformationUI(pInformationContent) {
			    var parameter = pInformationContent;
			    var url = "/ezApprovalG/ezAprOpinion.do";
			    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
			    var RtnVal = window.showModalDialog(url, parameter, feature);
			    return RtnVal;
			}
	
			function OpenAlertUI(pAlertContent) {
			    var parameter = pAlertContent;
			    var url = "/ezApprovalG/ezAprAlert.do";
			    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
			    var RtnVal = window.showModelessDialog(url, parameter, feature);
			}
	
			function chk_Passwd(pPwd) {
			    var parameter = pPwd;
			    var url = "/ezApprovalG/ezchkPasswd.do";
			    var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
			    var ret = window.showModalDialog(url, parameter, feature);
			    return ret
			}
	
			function window_onload() {
				window.onresize();
			    HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
			    HwpCtrl.SetSaveMode(1);
			
			    try {
			        if (pDocHref != "") {
			            showProgress("<spring:message code='ezApprovalG.t368'/>");
					    var URL = document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(pDocHref);
					    var isTrue = HwpCtrl.LoadFile(URL, false);
				
					    FieldsAvailable(isTrue);
				
					    HwpCtrl.ChangeMode(3);
						
			            HwpCtrl.SetFieldFocus("doctitle");
			            HwpCtrl.ezSetScrollPosInfo(0);
					}
				} catch (e) {
			    	alert("<spring:message code='ezApprovalG.t1373'/>" + e.description);
			      	hideProgress();
			  	}
			}
			
			window.onresize = function () {
	            HwpCtrl.style.height = null;
	            HwpCtrl.height = document.documentElement.clientHeight - 150;
	        }
	
			function FieldsAvailable(isTrue) {
			    if (isTrue) {
			        setAttachInfo(pDocID, "END", lstAttachLink);
			        GetExchInfo();
			        
			        /* 이효진 2018-03-15 경로수정 필요할듯 */
			        if ((attachxml.length > 0) && (attachxsl.length > 0)) {
			            btnXMLEdit.style.display = "";
			            attachxmlPath = "/Upload_ApprovalG/" + companyID + "/sendXML/" + attachxml;
			            attachxmlName = attachxml.replace(PackDocID, "");
			            attachxslPath = "/Upload_ApprovalG/" + companyID + "/sendXML/" + attachxsl;
			            attachxslName = attachxsl.replace(PackDocID, "");
			        }
			        
			        hideProgress();
			        
			        var Rtnval = CheckOpinionInfo();
			        if (Rtnval) {
			            var pInformationContent = "<spring:message code='ezApprovalG.t9'/><br> <spring:message code='ezApprovalG.t170'/>";
					    var Ans = OpenInformationUI(pInformationContent);
					    if (Ans) {
					        btnOpinion_onclick();
					    }
					}
			        HwpCtrl.SetImgReg();
			    }
			    else {
			        hideProgress();
			        var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
				    OpenAlertUI(pAlertContent);
				    HwpCtrl.ClearDocument();
			    }
			}
	
			function SetSusinState() {
				var result = "";
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/updateSusinState.do",
		    		data : {
		    			docID : pDocID,
		    			deptID : "Address",
		    			mode : "send"
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		        
		        return result;
		        
			    /* var xmlhttp = createXMLHttpRequest();
			    var xmlpara = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlpara, objNode, "PARAMETER");
			    createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
			    createNodeAndInsertText(xmlpara, objNode, "pRecDate", "");
			    createNodeAndInsertText(xmlpara, objNode, "pMode", "send");
			    createNodeAndInsertText(xmlpara, objNode, "pDeptID", "Address");
			
			    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezAPRRECEIVE/aspx/UpdateSusinState.aspx", false);
			    xmlhttp.send(xmlpara);
			
			    return getNodeText(loadXMLString(xmlhttp.responseText)); */
			}
	
			function CheckOpinionInfo() {
			    /* var xmlhttp = createXMLHttpRequest();
			    var xmlpara = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlpara, objNode, "PARAMETER");
			    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
			
			    xmlhttp.open("POST", "/ezApprovalG/getEndOpinionInfo.do", false);
			    xmlhttp.send(xmlpara);
			
			    Resultxml = loadXMLString(xmlhttp.responseText);
			
			    var NodeList = Resultxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
			
			    if (NodeList.length > 0)
			        return true;
			    else
			        return false; */
			    
				var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getEndOpinionInfo.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}
		    	});
		
		        Resultxml = result;
		
		        var NodeList = SelectNodes(Resultxml, "LISTVIEWDATA/ROWS/ROW");
		
		        if (NodeList.length != "0") {
		            return true;
		        } else {
		            return false;
		        }
			}
	
			function btnOpinion_onclick() {
			    var parameter = new Array();
			    parameter[0] = pDocID;
			    parameter[1] = "Show";
			
			    var url = "/ezApprovalG/aprEndOpinion.do"
			    var feature = "status:no;dialogWidth:530px;dialogHeight:520px;scroll:no;edge:sunken"
			    var ret = window.showModalDialog(url, parameter, feature);
			}
	
			function btnSend_onclick() {
			    if (!stampFlag && !NostampFlag) {
			        var pAlertContent = "<spring:message code='ezApprovalG.t186'/>";
				    OpenAlertUI(pAlertContent);
				    return;
				}
			
			    var pInformationContent = "<spring:message code='ezApprovalG.t187'/>";
			    var Ans = OpenInformationUI(pInformationContent);
			    if (!Ans) return;
			
			    //if ("${approvalPWD}" != "N") {
			    if (CheckUsePassword()) {
				    var chkpass = chk_Passwd(pUserID);
				    
				    if (chkpass == "False") {
				        var pAlertContent = "<spring:message code='ezApprovalG.t1383'/>";
					    OpenAlertUI(pAlertContent);
					    return;
				    } else if (chkpass == "cancel" || chkpass == undefined) {
	                    var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
	                    OpenAlertUI(pAlertContent);
	                    return;
	                }    
			    }
			
			    var rMatch = SaveFile();
			    if (rMatch == "SUCCESS") {
			        var rtnVal = SetSusinState();
			        if (rtnVal == "TRUE") {
			            var pAlertContent = "<spring:message code='ezApprovalG.t188'/>";
					    OpenAlertUI(pAlertContent);
					    setBtnDisable();
					}
					else {
					    var pAlertContent = "<spring:message code='ezApprovalG.t189'/>";
					    OpenAlertUI(pAlertContent);
					}
			    }
			    else {
			        var pAlertContent = "<spring:message code='ezApprovalG.t189'/>";
				    OpenAlertUI(pAlertContent);
				}
			}
	
			function setBtnDisable() {
			    btnOpinion.style.display = "none";
			    btnStamp.style.display = "none";
			    btnNoStamp.style.display = "none";
			    btnSend.style.display = "none";
			}
	
			function SaveFile() {
				var result = "";
				
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/saveEndFileHwp.do",
		    		data : {
		    			docID : pDocID,
		    			html  : HwpCtrl.GetCloneData("", "HWP")
		    		},
		    		success: function(text){
		    			result = text;
		    		}
		    	});
		        
		        return result;
		        
			    /* var xmlhttp = createXMLHttpRequest();
			    var xmlpara = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlpara, objNode, "PARAMETER");
			    createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
			    createNodeAndInsertText(xmlpara, objNode, "Html", HwpCtrl.GetCloneData("", "HWP"));
			
			    xmlhttp.open("POST", "aspx/SaveEndFileHWP.aspx", false);
			    xmlhttp.send(xmlpara);
			
			    return xmlhttp.responseText; */
			}
	
			function GetSealInfo() {
			    /* var xmlhttp = createXMLHttpRequest();
			    var xmlpara = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlpara, objNode, "PARAMETER");
			    createNodeAndInsertText(xmlpara, objNode, "Flag", "LIST");
			
			    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezSealInfo/aspx/GetSealList.aspx", false);
			    xmlhttp.send(xmlpara);
			
			    return loadXMLString(xmlhttp.responseText); */
			    
				var result = "";
		    	
	    		$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApprovalG/getSealList.do",
		    		data : {
		    			flag : "LIST"
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}
		    	});
	    		
		        return result;
			}
	
			function GetDeptSealInfo() {
			    /* var xmlhttp = createXMLHttpRequest();
			    var xmlpara = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlpara, objNode, "PARAMETER");
			    createNodeAndInsertText(xmlpara, objNode, "Flag", "LIST");
			    createNodeAndInsertText(xmlpara, objNode, "DeptID", arr_userinfo[4]);
			
			    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezSealInfo/aspx/GetDeptSealList.aspx", false);
			    xmlhttp.send(xmlpara);
			
			    return loadXMLString(xmlhttp.responseText); */
			    
				var result = "";
		    	
	    		$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezApprovalG/getDeptSealList.do",
		    		data : {
		    			flag : "LIST",
		    			deptID  : arr_userinfo[4]
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		},
		    		error : function(jqXHR, textStatus, errorThrown) {
		        		alert("<spring:message code = 'ezApprovalG.t228' />" + jqXHR.statusText);
		        	}
		    	});
	    		
		        return result;
			}
	
			function btnStamp_onclick() {
			    if (!HwpCtrl.CheckFieldExist("sealsign")) {
			        var pAlertContent = "<spring:message code='ezApprovalG.t190'/><br><spring:message code='ezApprovalG.t191'/>";
				    OpenAlertUI(pAlertContent);
				    return;
				}
			
			    if (!stampFlag) {
			        var DeptSealXML = GetDeptSealInfo();
			        var CompSealXML = GetSealInfo();
			
			        if (SelectNodes(DeptSealXML, "ROWS/ROW").length > 0 && SelectNodes(CompSealXML, "ROWS/ROW").length > 0) {
			            var pInformationContent = "<spring:message code='ezApprovalG.t192'/><BR><spring:message code='ezApprovalG.t193'/>";
					    var Ans = OpenInformationUI(pInformationContent);
					    if (!Ans)
					        SealXML = CompSealXML;
					    else
					        SealXML = DeptSealXML;
					}
					else if (SelectNodes(DeptSealXML, "ROWS/ROW").length <= 0 && SelectNodes(CompSealXML, "ROWS/ROW").length <= 0) {
					    var pAlertContent = "<spring:message code='ezApprovalG.t194'/><br><spring:message code='ezApprovalG.t195'/>";
						    OpenAlertUI(pAlertContent);
						    return;
					}
					else if (SelectNodes(DeptSealXML, "ROWS/ROW").length > 0) {
					    SealXML = DeptSealXML;
					}
					else if (SelectNodes(CompSealXML, "ROWS/ROW").length > 0) {
					    SealXML = CompSealXML;
					}
			
			        /* var SealHref = getNodeText(SelectNodes(SealXML, "ROWS/ROW/CELL").item(0).selectSingleNode("DATA2"));
			        var SealWidth = parseInt(getNodeText(SelectNodes(SealXML, "ROWS/ROW/CELL").item(1).selectSingleNode("VALUE")));
			        var SealHeight = parseInt(getNodeText(SelectNodes(SealXML, "ROWS/ROW/CELL").item(2).selectSingleNode("VALUE"))); */
			        
			        var SealHref = getNodeText(SelectNodes(SealXML, "ROWS/ROW/CELL")[0].getElementsByTagName("DATA2")[0]);
		            var SealWidth = parseInt(getNodeText(GetChildNodes(SelectNodes(SealXML, "ROWS/ROW/CELL")[1])[0]));
		            var SealHeight = parseInt(getNodeText(GetChildNodes(SelectNodes(SealXML, "ROWS/ROW/CELL")[2])[0]));
		            
			
			        if (HwpCtrl.CheckFieldExist("sealsign")) {
			            HwpCtrl.SetFieldText("sealsign", "");
			            HwpCtrl.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + encodeURIComponent(SealHref));
			            SetDocumentElement(HwpCtrl, "surl", SealHref);
			            stampFlag = true;
			        }
			    }
			    else {
			        if (HwpCtrl.CheckFieldExist("sealsign")) {
			            HwpCtrl.SetFieldText("sealsign", "");
			            HwpCtrl.SetFieldBackImage("sealsign", "");
			        }
			        stampFlag = false;
			    }
			}
	
			function btnNoStamp_onclick() {
			    var strimg;
			    if (!HwpCtrl.CheckFieldExist("sealsign")) {
			        var pAlertContent = "<spring:message code='ezApprovalG.t190'/><br><spring:message code='ezApprovalG.t191'/>";
				    OpenAlertUI(pAlertContent);
				    return;
				}
			
			    if (!NostampFlag) {
			        var SealHref = "/files/sealImg/nostamp.gif"
			        var SealWidth = 30;
			        var SealHeight = 30;
			
			        if (HwpCtrl.CheckFieldExist("sealsign")) {
			            HwpCtrl.SetFieldText("sealsign", "");
			            HwpCtrl.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname + ":" + document.location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(SealHref), 12);
			            NostampFlag = true;
			            SetDocumentElement(HwpCtrl, "surl", SealHref);
			        }
			    }
			    else {
			        if (HwpCtrl.CheckFieldExist("sealsign")) {
			            HwpCtrl.SetFieldText("sealsign", "");
			            HwpCtrl.SetFieldBackImage("sealsign", "");
			        }
			        NostampFlag = false;
			    }
			}
	
			function getPixel(pLength) {
			    try {
			        var tempLength = parseInt(pLength);
			        tempLength = tempLength * 7 / 2;
			        return tempLength;
			
			    } catch (e) {
			        return 30;
			    }
			}
			
			/* 2019-01-02 천성준 #14647
			     결재암호 사용유무 조회 (Y / N)
			*/
			function CheckUsePassword() {
				var result = "";
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezApprovalG/getApprovalPWD.do",
					success: function(text) {
						result = text;
					}        			
				});
				
				if (result != "N") {
					return true;
				} else {
					return false;
				}
			}
	    </script>
	</head>
	<body class="popup" onload="javascript:window_onload()" style="overflow: hidden" onbeforeunload="javascript:window_onbeforeunload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnStamp"><span onclick="return btnStamp_onclick()"><spring:message code='ezApprovalG.t197'/></span></li>
	                        <li id="btnNoStamp"><span onclick="return btnNoStamp_onclick()"><spring:message code='ezApprovalG.t198'/></span></li>
	                        <li id="btnSend"><span onclick="return btnSend_onclick()"><spring:message code='ezApprovalG.t199'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li id="btnClose"><span onclick="return btnClose_onclick()"></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td class="pad1">
	                <div style="height: 100%">
	                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "<c:out value ='${hwpToolbar}'/>", "1");</script>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td height="20">
	                <table class="file" style="height:80px;">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td style="width:62%; border-right:1px solid #d5d5d5;">
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
	    <script type="text/javascript">
	        selToggleList(document.getElementById("menu"), "ul", "li", "0");
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>
	</body>
</html>