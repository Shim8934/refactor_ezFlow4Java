<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t200'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/attachG.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/conn_HWP.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getDocAttach.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ezSimsaG_HWP.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
	    <script type="text/javascript">
	    	var pNoneActiveX = "<%=NoneActiveX%>";
			var pDocID = '<%=_DocID%>';
			var pDocHref = '<%=_DocHref%>';
			var pOrgDocID = '<%=_DocID%>';
			var pFormID = "<%=_FormID%>";
			var pUserID = "<%=userinfo.UserID%>";     
			var flag = false;
			var flag2 = false;
			var newDocID = "";
			var stampFlag = false;
			var NostampFlag = false;
			var modeflag = false;
			var companyID = "<%=userinfo.CompanyID%>"
			var arr_userinfo = new Array();
			var maxwidth = 659;							
			var arr_userinfo = new Array();
			arr_userinfo[0]  = "user";								
			arr_userinfo[1]  = "<%=userinfo.UserID%>";              
			arr_userinfo[2]  = "<%=userinfo.DisplayName%>";         
			arr_userinfo[3]  = "<%=userinfo.Title%>";               
			arr_userinfo[4]  = "<%=userinfo.DeptID%>";              
			arr_userinfo[5]  = "<%=userinfo.DeptName%>";            
			arr_userinfo[6]  = "<%=userinfo.Jikchek%>";                         
			arr_userinfo[8]  = "<%=userinfo.Email%>";               
			arr_userinfo[9]  = companyID;
			arr_userinfo[11]  = "<%=userinfo.DisplayName1%>";		
			arr_userinfo[12]  = "<%=userinfo.DisplayName2%>";		
			arr_userinfo[13]  = "<%=userinfo.Title1%>";				
			arr_userinfo[14]  = "<%=userinfo.Title2%>";				
			arr_userinfo[15]  = "<%=userinfo.DeptName1%>";			
			arr_userinfo[16]  = "<%=userinfo.DeptName2%>";			
			
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
			var pUse_Editor = "<%= Use_Editor%>";
	
			function showProgress(inforstring) {
				g_progresswin = window.showModelessDialog("/myoffice/common/show_progress.aspx?fileinfo=" + escape(inforstring) , "", "dialogWidth=390px; dialogHeight:185px; center:yes; status:no; help:no; edge:sunken;");
			}
			
			function hideProgress() {
			  try {
				if (g_progresswin)
					g_progresswin.close();
			  } catch(e) {}
			}
	
			function btnPrint_onclick()	{
				HwpCtrl.PrintDocument("", true);
			}
			
			function window_onbeforeunload() {
			  try {
				window.opener.GetRecordList();
			  } catch(e) {}
			  
			  try {
				UndoCreateDoc(newDocID)
			  } catch(e) {}
			}
			
			function btnClose_onclick() {
				window.close();
			}
	
			function openwindow(wfileLocation , wName) {
			  try{
				var heigth = window.screen.availHeight;
				var width = window.screen.availWidth;
				var left = 0;
				var top = 0;
					
				if(window.screen.width > 800)
				{
					var pleftpos;
					pleftpos = parseInt(width) - 725;
					heigth = parseInt(heigth) - 30;
					width = parseInt(width) - pleftpos;
					left = pleftpos / 2;
				}
				else
				{
					heigth = parseInt(heigth) - 30;
					width = parseInt(width) - 10;
				}
				window.open(wfileLocation,wName,"toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
			  }catch(e){
				alert("openwindow :: " + e.description);
			  }
			}
	
			function OpenInformationUI(pInformationContent)	{
				var parameter = pInformationContent;	
				var url = "/myoffice/ezApprovalG/ezAPROPINION.aspx";
				var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";	
				var RtnVal = window.showModalDialog(url,parameter,feature);
				return RtnVal;
			}
	
			function OpenAlertUI(pAlertContent)	{
				var parameter	= pAlertContent;
				var url = "/myoffice/ezApprovalG/ezAPRALERT.aspx";
				var feature		= "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
				var RtnVal		= window.showModelessDialog(url,parameter,feature);
			}
	
			function chk_Passwd(pPwd) {
				var parameter	= pUserID;
				var url = "/myoffice/ezApprovalG/ezchkPasswd.aspx";
				var feature		= "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
				var ret			= window.showModalDialog(url,parameter,feature);
				return ret
			}
	
			function window_onload() {
			    HwpCtrl.SetSaveMode(1);
			    
			  try{
				if(pDocHref != "") {
				  	showProgress("<spring:message code='ezApprovalG.t368'/>");
				  	var URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(pDocHref);  
				    var isTrue = HwpCtrl.LoadFile(URL, false);
				    
				    FieldsAvailable(isTrue);
				}
			
			    HwpCtrl.SetFieldFocus("doctitle");
			    HwpCtrl.ezSetScrollPosInfo(0);
			  }catch(e){
				alert("<spring:message code='ezApprovalG.t1373'/>" + e.description);
				hideProgress();
			  }    	
			}
	
			function FieldsAvailable(isTrue) {
				if (isTrue)
				{
					if (newDocID == "")	
					{
						newDocID = createNewDoc();	
						pDocID = newDocID;
						sendOffer();
						UpdateReceiptOffer(pDocID, pOrgDocID);
					}
					
					setAttachInfo(pOrgDocID, "END", lstAttachLink);
					GetAprDeptXML();
					GetExchInfo();
					
					if ((attachxml.length > 0) && (attachxsl.length > 0))
					{
						btnXMLEdit.style.display = "";
						attachxmlPath = "/Upload_ApprovalG/" + companyID + "/sendXML/" + attachxml;
						attachxmlName = attachxml.replace(PackDocID, "");
						attachxslPath = "/Upload_ApprovalG/" + companyID + "/sendXML/" + attachxsl;
						attachxslName = attachxsl.replace(PackDocID, "");
					}		
					hideProgress();
					
					var Rtnval = CheckOpinionInfo();
					if(Rtnval)
					{
						var pInformationContent = "<spring:message code='ezApprovalG.t9'/><br> <spring:message code='ezApprovalG.t170'/>";
						var Ans = OpenInformationUI(pInformationContent);
						if(Ans)
						{
							btnOpinion_onclick();
						}  
					}
				    HwpCtrl.SetImgReg();
				}
				else
				{
				    hideProgress();
			       	var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
			       	OpenAlertUI(pAlertContent);       
			       	HwpCtrl.ClearDocument();   
				}
			}
	
			function createNewDoc()
			{
			  try{
				var objRoot;
				var objNode;
					
				var xmlpara = createXmlDom();
				var xmlhttp = createXMLHttpRequest();
			
				createNodeInsert(xmlpara, objNode, "PARAMETER");
				createNodeAndInsertText(xmlpara, objNode, "FormID", pFormID);
					
				xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/createnewdoc.aspx", false);
				xmlhttp.send(xmlpara);
				
				if(xmlhttp.responseText == "False")
				{
					var pAlertContent = "<spring:message code='ezApprovalG.t173'/><br> <spring:message code='ezApprovalG.t174'/>";
					OpenAlertUI(pAlertContent);
				}else{
					return xmlhttp.responseText;
				}
			  }catch(e){
			    alert("createNewDoc()" + e.description);
			  }
			}
	
			function sendOffer()
			{
				var xmlpara = createXmlDom();
				var xmlhttp = createXMLHttpRequest();
						
				var objNode;
				createNodeInsert(xmlpara, objNode, "PARAMETER");
				createNodeAndInsertText(xmlpara, objNode, "DOCID", newDocID);
				createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", pOrgDocID);
			
				if (HwpCtrl.CheckFieldExist("doctitle"))
				    createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", HwpCtrl.GetFieldText("doctitle"));
				else
				    createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", "");
				createNodeAndInsertText(xmlpara, objNode, "HTML", "hwp");
				createNodeAndInsertText(xmlpara, objNode, "HREF", "/Upload_ApprovalG/" + companyID + "/Doc/" + "<%=DateTime.Now.Year.ToString()%>" + "/1000/" + (newDocID % 1000) + "/" + newDocID + ".hwp");
			    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERID", arr_userinfo[1]);
			    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERNAME", arr_userinfo[11]);
			    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERJOBTITLE", arr_userinfo[13]);
			    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERDEPTID", arr_userinfo[4]);
			    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERDEPTNAME", arr_userinfo[15]);
			    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERNAME2", arr_userinfo[12]);
			    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERDEPTNAME2", arr_userinfo[14]);
			    createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERJOBTITLE2", arr_userinfo[16]);
			
			    xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/sendOfferG.aspx", false);
				xmlhttp.send(xmlpara);
				
				if(getNodeText(loadXMLString(xmlhttp.responseText)) != "TRUE")
				{
					var pAlertContent = "<spring:message code='ezApprovalG.t180'/>";
					OpenAlertUI(pAlertContent);
					return;
				}
			}
	
			function UpdateReceiptOffer(pDocID, pOrgDocID)
			{
				var xmlhttp = createXMLHttpRequest();
				var xmlpara = createXmlDom();
				var objNode;
				createNodeInsert(xmlpara, objNode, "PARAMETER");
				createNodeAndInsertText(xmlpara, objNode, "DOCID", pDocID);
				createNodeAndInsertText(xmlpara, objNode, "pOrgDocID", pOrgDocID);
				
				xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/UpdateReceiptOffer.aspx", false);
				xmlhttp.send(xmlpara);
				
				var rtnVal = getNodeText(loadXMLString(xmlhttp.responseText));
				if (rtnVal == "TRUE")
					return true;
				else
					return false;
			}
	
			function CheckOpinionInfo()
			{
				var xmlhttp = createXMLHttpRequest();
				var xmlpara = createXmlDom();
				var objNode;
				createNodeInsert(xmlpara, objNode, "PARAMETER");
				createNodeAndInsertText(xmlpara, objNode, "DocID", pOrgDocID);
			
				xmlhttp.open("POST", "/myoffice/ezApprovalG/formContainer/aspx/getEndOpinionInfo.aspx", false);
				xmlhttp.send(xmlpara);
			
				Resultxml = loadXMLString(xmlhttp.responseText);
			  
				var NodeList = Resultxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
				
				if(NodeList.length > 0)
					return true;
				else
					return false;
			}
	
			function btnSetReceivLine_onclick()
			{
			    var url = "/myoffice/ezApprovalG/ezDocInfo/ezReceiptInfo.aspx?pDocID=" + pDocID;
				var feature	= "status:no;dialogWidth:540px;dialogHeight:220px;help:no;scroll:no;edge:sunken";
			  	var ret = window.showModalDialog(url,"",feature);
			}
	
			function btnOpinion_onclick()
			{
				var parameter = new Array();
				parameter[0] = pOrgDocID; 
				parameter[1] = "Show";    
			  
				var url = "/myoffice/ezApprovalG/formContainer/AprEndOpinion.aspx";
				var feature = "status:no;dialogWidth:530px;dialogHeight:450px;scroll:no;edge:sunken"
				var ret = window.showModalDialog(url,parameter,feature);
			}
	
			function btnSend_onclick()
			{
				if (!stampFlag && !NostampFlag)
				{
					var pAlertContent = "<spring:message code='ezApprovalG.t216'/>";
					OpenAlertUI(pAlertContent);
					return;
				}
			
				var pInformationContent = "<spring:message code='ezApprovalG.t205'/>";
				var Ans = OpenInformationUI(pInformationContent);
				if(!Ans) return;  
			
				var chkpass = chk_Passwd(pUserID);
				if(chkpass == "False")
				{
					var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
					OpenAlertUI(pAlertContent);
					return;
				}
				else if(chkpass == "cancel") 
				{
					var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
					OpenAlertUI(pAlertContent);
					return;
				}
			
				SaveFile();
				
				GetAprDeptXML();
				var rtnVal = "FALSE";
				if(isExternal)
				{
					if (isAddress)
					{
						rtnVal = SetContainer();	
					}
					else
					{
						is_Enc = OpenCheckUI();		
						if(!sendExt())
						{
						}
						else
						{
							rtnVal = SetContainer();	
						}
					}
				}
				else	
					rtnVal = SetContainer();	
				
				if (rtnVal == "TRUE")
				{
					var pAlertContent = "<spring:message code='ezApprovalG.t206'/>";
					OpenAlertUI(pAlertContent);
					setBtnDisable();
				}
				else
				{
					var pAlertContent = "<spring:message code='ezApprovalG.t217'/>";
					OpenAlertUI(pAlertContent);
				}
			}
	
			function btnBoard_onclick()
			{
				if (!stampFlag && !NostampFlag)
				{
					var pAlertContent = "<spring:message code='ezApprovalG.t216'/>";
					OpenAlertUI(pAlertContent);
					return;
				}
			
				var pInformationContent = "<spring:message code='ezApprovalG.t218'/><br><spring:message code='ezApprovalG.t219'/>";
				var Ans = OpenInformationUI(pInformationContent);
				if(!Ans) return;  
			
				SaveFile();
			    
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
				            window.open("/myoffice/ezBoardSTD/NewBoardItem.aspx?BoardID=" + pBoardID + "&Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pOrgDocID + "&Url=" + pDocHref, '', 'height=720,width=765,resizable=yes,scrollbars=no, left=' + left + 'px, top=' + top);
				        }
				        else {
				            window.open("/myoffice/ezBoardSTD/NewBoardItem_IE.aspx?BoardID=" + pBoardID + "&Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pOrgDocID + "&Url=" + pDocHref, '', 'height=720,width=765,resizable=yes,scrollbars=no, left=' + left + 'px, top=' + top);
				        }
				    }
				}
			}
	
			function SuccessBoard()
			{
				var rtnVal = SetContainer();	
				if (rtnVal == "TRUE")
				{
					var pAlertContent = "<spring:message code='ezApprovalG.t211'/>";
					OpenAlertUI(pAlertContent);
					setBtnDisable();
				}
				else
				{
					var pAlertContent = "<spring:message code='ezApprovalG.t220'/>";
					OpenAlertUI(pAlertContent);
				}
			}
	
			function SetContainer()
			{
				var xmlpara = createXmlDom();
				var xmlhttp = createXMLHttpRequest();
				var objNode;
				createNodeInsert(xmlpara, objNode, "PARAMETER");
				createNodeAndInsertText(xmlpara, objNode, "DocID", newDocID);
				createNodeAndInsertText(xmlpara, objNode, "pOrgDocID", pOrgDocID);
				createNodeAndInsertText(xmlpara, objNode, "SUserID", pUserID);
				createNodeAndInsertText(xmlpara, objNode, "SUserName", arr_userinfo[2]);
				createNodeAndInsertText(xmlpara, objNode, "SDeptID", arr_userinfo[4]);
				createNodeAndInsertText(xmlpara, objNode, "SUserName2", arr_userinfo[11]);
				
				xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/sendOfferAprove.aspx", false);
				xmlhttp.send(xmlpara);
					
				return getNodeText(loadXMLString(xmlhttp.responseText))
			}
	
			function setBtnDisable()
			{
				btnOpinion.style.display = "none";
				btnSetReceivLine.style.display = "none";
				btnStamp.style.display = "none";
				btnNoStamp.style.display = "none";
				btnSend.style.display = "none";
				btnBoard.style.display = "none";
			}
	
			function SaveFile()
			{
				var xmlhttp = createXMLHttpRequest();
				var xmlpara = createXmlDom();
			
				var objNode;
				createNodeInsert(xmlpara, objNode, "PARAMETER");
				createNodeAndInsertText(xmlpara, objNode, "DocID", pOrgDocID);
				createNodeAndInsertText(xmlpara, objNode, "Html", HwpCtrl.GetCloneData("", "HWP"));
					
				xmlhttp.open("POST","aspx/SaveEndFileHWP.aspx",false);
				xmlhttp.send(xmlpara);
			
				var xmlhttp2 = createXMLHttpRequest();
				var xmlpara = createXmlDom();
			
				var objNode;
				createNodeInsert(xmlpara, objNode, "PARAMETER");
				createNodeAndInsertText(xmlpara, objNode, "DocID", newDocID);
				createNodeAndInsertText(xmlpara, objNode, "Html", HwpCtrl.GetCloneData("", "HWP"));
			
				xmlhttp2.open("POST","aspx/SaveFileHWP.aspx",false);
				xmlhttp2.send(xmlpara);
					
				return xmlhttp.responseText;
			}
	
			function GetSealInfo()
			{
			    var xmlhttp = createXMLHttpRequest();
			    var xmlpara = createXmlDom();
			    var objNode;
			    createNodeInsert(xmlpara, objNode, "PARAMETER");
			    createNodeAndInsertText(xmlpara, objNode, "Flag", "LIST");
					
			    xmlhttp.open("POST", "/myoffice/ezApprovalG/ezSealInfo/aspx/GetSealList.aspx", false);
				xmlhttp.send(xmlpara);
					
				return loadXMLString(xmlhttp.responseText);
			}
	
			function GetDeptSealInfo()
			{
				var xmlhttp = createXMLHttpRequest();
				var xmlpara = createXmlDom();
				var objNode;
				createNodeInsert(xmlpara, objNode, "PARAMETER");
				createNodeAndInsertText(xmlpara, objNode, "Flag", "LIST");
				createNodeAndInsertText(xmlpara, objNode, "DeptID", arr_userinfo[4]);
					
				xmlhttp.open("POST", "/myoffice/ezApprovalG/ezSealInfo/aspx/GetDeptSealList.aspx", false);
				xmlhttp.send(xmlpara);
					
				return loadXMLString(xmlhttp.responseText);
			}
	
			function btnStamp_onclick()
			{
				if (!HwpCtrl.CheckFieldExist("sealsign"))
				{
				    var pAlertContent = "<spring:message code='ezApprovalG.t201'/><br><spring:message code='ezApprovalG.t191'/>";
				    OpenAlertUI(pAlertContent);
				    return;
				}
			
			    if (!stampFlag) {
			        var DeptSealXML = GetDeptSealInfo();
			        var CompSealXML = GetSealInfo();
			
			        if (DeptSealXML.selectNodes("ROWS/ROW").length > 0 && CompSealXML.selectNodes("ROWS/ROW").length > 0) {
			            var pInformationContent = "<spring:message code='ezApprovalG.t192'/><BR><spring:message code='ezApprovalG.t193'/>";
					    var Ans = OpenInformationUI(pInformationContent);
					    if (!Ans)
					        SealXML = CompSealXML;
					    else
					        SealXML = DeptSealXML;
					}
					else if (DeptSealXML.selectNodes("ROWS/ROW").length <= 0 && CompSealXML.selectNodes("ROWS/ROW").length <= 0) {
					    var pAlertContent = "<spring:message code='ezApprovalG.t194'/><br><spring:message code='ezApprovalG.t195'/>";
					        OpenAlertUI(pAlertContent);
					        return;
				    }
				    else if (DeptSealXML.selectNodes("ROWS/ROW").length > 0) {
				        SealXML = DeptSealXML;
				    }
				    else if (CompSealXML.selectNodes("ROWS/ROW").length > 0) {
				        SealXML = CompSealXML;
				    }
			
			        var SealHref = getNodeText(SealXML.selectNodes("ROWS/ROW/CELL").item(0).selectSingleNode("DATA2"));
			        var SealWidth = parseInt(getNodeText(SealXML.selectNodes("ROWS/ROW/CELL").item(1).selectSingleNode("VALUE")));
			        var SealHeight = parseInt(getNodeText(SealXML.selectNodes("ROWS/ROW/CELL").item(2).selectSingleNode("VALUE")));
			
			        if (HwpCtrl.CheckFieldExist("sealsign")) {
			            HwpCtrl.SetFieldText("sealsign", "");
			            HwpCtrl.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(SealHref));
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
			        var pAlertContent = "<spring:message code='ezApprovalG.t201'/><br><spring:message code='ezApprovalG.t191'/>";
			        OpenAlertUI(pAlertContent);
			        return;
			    }
			
			    if (!NostampFlag) {
			        var SealHref = "/Upload_ApprovalG/SealImg/nostamp.gif"
			        var SealWidth = 30;
			        var SealHeight = 10;
			
			        if (HwpCtrl.CheckFieldExist("sealsign")) {
			            HwpCtrl.SetFieldText("sealsign", "");
			            HwpCtrl.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(SealHref), 12);
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
			
			function UndoCreateDoc(tempDocID) {
			    if (tempDocID != "") {
			        var xmlpara = createXmlDom();
			        var xmlhttp = createXMLHttpRequest();
			        var objNode;
			        createNodeInsert(xmlpara, objNode, "PARAMETER");
			        createNodeAndInsertText(xmlpara, objNode, "pDocID", tempDocID);
			
			        xmlhttp.open("Post", "/myoffice/ezApprovalG/aspx/UndoDocMust.aspx", false);
			        xmlhttp.send(xmlpara);
			
			    }
			}
	    </script>
	    <script language="vbscript">
Function Encode2(text, field)
	Dim doc 
	dim doctemp
	Dim tags, tagstemp
	Dim enumTag, enumTagtemp
	Dim tagNames
	Dim i , j
	Dim pzDoc
  
	Set pzDoc = CreateObject("pzDNAClass.pzHTMLDocument")  
	pzDoc.Async = false
	tagNames = Array("TABLE", "TD", "COL", "IMG", "COLGROUP", "TH")
  
	pzDoc.HTMLText = "<Html>" & text & "</Html>" 
	Set doctemp = pzDoc.Document
	set doc = field
	For i = 0 To UBound(tagNames)
		Set tags = doc.All.tags(tagNames(i))
		set tagstemp = doctemp.All.tags(tagNames(i))
		For j = 0 to tags.length - 1
			set enumTag = tags(j)
			set enumTagtemp = tagstemp(j)
			If enumTagtemp.Width <> "" Then
				enumTagtemp.setAttribute "Width", CStr(Conversion(enumTag.offsetWidth)) & "mm"
				enumTagtemp.removeAttribute ("width")
			Else
				enumTagtemp.setAttribute "Width", CStr(Conversion(enumTag.offsetWidth)) & "mm"
			End If
			If enumTagtemp.Style.Width <> "" Then
				enumTagtemp.setAttribute "Width", CStr(Conversion(enumTagtemp.Style.pixelWidth)) & "mm"
				enumTagtemp.Style.removeAttribute ("width")
			End If
			If enumTagtemp.tagName <> "COL" And enumTagtemp.tagName <> "COLGROUP" Then
				If enumTagtemp.Height <> "" Then
					enumTagtemp.setAttribute "Height", CStr(Conversion(enumTag.offsetHeight)) & "mm"
					enumTagtemp.removeAttribute ("height")
				Else
					enumTagtemp.setAttribute "Height", CStr(Conversion(enumTag.offsetHeight)) & "mm"
				End If
				If enumTagtemp.Style.Height <> "" Then
					enumTagtemp.setAttribute "Height", CStr(Conversion(enumTagtemp.Style.pixelHeight)) & "mm"
					enumTagtemp.Style.removeAttribute ("height")
				End If
			End If			
			
		Next
    
	Next   
	Encode2 = doctemp.body.innerHTML
  
End Function

Function Encode(text)
	Dim doc 
	Dim tags 
	Dim enumTag 
	Dim tagNames
	Dim i 
	Dim pzDoc
  
	Set pzDoc = CreateObject("pzDNAClass.pzHTMLDocument")  
	pzDoc.Async = false
	tagNames = Array("TABLE", "TD", "COL", "IMG", "COLGROUP", "TH")
  
	pzDoc.HTMLText = "<Html>" & text & "</Html>" 
	Set doc = pzDoc.Document
  
	For i = 0 To UBound(tagNames)
		Set tags = doc.All.tags(tagNames(i))
    
		For Each enumTag In tags
			With enumTag
				If .Width <> "" Then
					.setAttribute "Width", CStr(Conversion(.Width)) & "mm"
					.removeAttribute ("width")
				End If
				If .Style.Width <> "" Then
					.setAttribute "Width", CStr(Conversion(.Style.pixelWidth)) & "mm"
					.Style.removeAttribute ("width")
				End If
				If .tagName <> "COL" And .tagName <> "COLGROUP" Then
					If .Height <> "" Then
						.setAttribute "Height", CStr(Conversion(.Height)) & "mm"
						.removeAttribute ("height")
					End If
					If .Style.Height <> "" Then
						.setAttribute "Height", CStr(Conversion(.Style.pixelHeight)) & "mm"
						.Style.removeAttribute ("height")
					End If
				End If
			End With
		Next
	Next   
	Encode = doc.body.innerHTML
  
End Function

Function Conversion(pixel)
	Conversion = Round(pixel * (CDbl(100) / CDbl(378)), 2)
End Function
    	</script>
	</head>
	<body class="popup" onload="return window_onload()" style="overflow: hidden" onbeforeunload="return window_onbeforeunload()">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
	                        <li id="btnSetReceivLine"><span onclick="return btnSetReceivLine_onclick()"><spring:message code='ezApprovalG.t53'/></span></li>
	                        <li id="btnStamp"><span onclick="return btnStamp_onclick()"><spring:message code='ezApprovalG.t213'/></span></li>
	                        <li id="btnNoStamp"><span onclick="return btnNoStamp_onclick()"><spring:message code='ezApprovalG.t222'/></span></li>
	                        <li id="btnSend"><span onclick="return btnSend_onclick()"><spring:message code='ezApprovalG.t214'/></span></li>
	                        <li id="btnBoard"><span onclick="return btnBoard_onclick()"><spring:message code='ezApprovalG.t215'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li id="btnClose"><span onclick="return btnClose_onclick()"><spring:message code='ezApprovalG.t64'/></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="padding-bottom: 10px">
	                <div style="height: 100%">
	                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "<%=_HwpToolbar%>", "");</script>
	                    classid=CLSID:1D50E26E-E51E-4153-93DD-D08745457090 VIEWASTEXT>
							<param name="StartMode" value="3">
	                    <param name="StatusBar" value="0">
	                    <param name="ToolBar" value="<%=_HwpToolbar%>">
	                    </OBJECT-->
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