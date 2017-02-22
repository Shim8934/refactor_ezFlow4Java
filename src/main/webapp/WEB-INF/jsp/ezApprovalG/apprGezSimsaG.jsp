<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:97%;">
	<head>
		<title><spring:message code='ezApprovalG.t257'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>	
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ezSimsaG_Cross.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/attachG_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getDocAttach_Cross.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></SCRIPT>
		<script type="text/javascript" src="/js/ezApprovalG/conn_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/appandbody_Cross.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var pDocID = "${docID}";
		    var pDocHref = "${docHref}";
		    var pOrgDocID = "${orgDocID}";
		    var pUserID;
		    var flag = false;
		    var flag2 = false;
		    var stampFlag = false;
		    var NostampFlag = false;
		    var modeflag = false;
		    var companyID = "${userInfo.companyID}";
		    var companyName = "${userInfo.companyName}";
		    var maxwidth = 659;
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "${userInfo.id}";
		    arr_userinfo[2]  = "${userInfo.displayName}";
		    arr_userinfo[3]  = "${userInfo.title}";
		    arr_userinfo[4]  = "${userInfo.deptID}";
		    arr_userinfo[5]  = "${userInfo.deptName}";
		    arr_userinfo[6]  = "${userInfo.jikChek}";
		    arr_userinfo[8]  = "${userInfo.email}";
		    arr_userinfo[9]  = companyID;
		    arr_userinfo[11]  = "${userInfo.displayName}";
		    arr_userinfo[12]  = "${userInfo.displayName2}";
		    arr_userinfo[13]  = "${userInfo.title1}";
		    arr_userinfo[14]  = "${userInfo.title2}";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";
		    pUserID = arr_userinfo[1];
		    var is_Enc = "NONE";
		    var isExternal = false;
		    var isAddress = false;
		    var APRDEPTXML = createXmlDom();
		    var sealPath = "";
		    var sealName = "";
		    var attachName = new Array();
		    var attachPath = new Array();
		    var attachType = new Array();
		    var encodePass = "";
		    var encodePath = "";
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
		    var pDomainName = document.location.protocol + "//" + document.location.hostname;
		    var symbolPath = "";
		    var symbolName = "";
		    var logoPath = "";
		    var logoName = "";
		    var pAprType = "";
		    var tempAttachSN = 0;
		    var arrDelFiles = new Array();
		    arrDelFiles[0] = "c:\\" + pDocID + ".xml";
		    arrDelFiles[1] = "c:\\" + pOrgDocID + ".xml";
		    var flag = false;
		    var pUse_Editor = "${useEditor}";
		    var PrtBodyContent;
		    var NonActiveX = "YES";
		    function btnPrint_onclick() {
		        PrintClick("Cross", pDocID, "");
		    }
		    function DocumentComplete() {
		        if (flag == false) {
		            flag = true;
		
		            if ("${pass}" != "<RESULT>TRUE</RESULT>") {
		                QuitWindow();
		            }
		            else {
		                if (pDocHref != "") {
		                    message.Set_EditorContentURL(pDocHref);
		                }
		            }
		        }
		    }
		    var noFieldsAvailable = false;
		    function FieldsAvailable() {
		        var fields = message.GetFieldsList();
		        ObjGPKI.ServerName = "ldap.gcc.go.kr";
		        setAttachInfo(pOrgDocID, "END", lstAttachLink);
		        setArrAttachInfo();
		        GetAprDeptXML();
		        GetExchInfo();
		        if ((attachxml.length > 0) && (attachxsl.length > 0)) {
		            btnXMLEdit.style.display = "";
		            attachxmlPath = "/files/upload_approvalG/" + companyID + "/sendXML/" + attachxml;
		            attachxmlName = attachxml.replace(PackDocID, "");
		            attachxslPath = "/files/upload_approvalG/" + companyID + "/sendXML/" + attachxsl;
		            attachxslName = attachxsl.replace(PackDocID, "");
		        }
		        var fields = message.GetFieldsList();
		        var field = message.GetListItem(fields, "sealsign");
		        if (field) {
		            if (field.innerHTML.indexOf("<IMG ") == 0 || field.innerHTML.indexOf("<img") == 0) {
		                if (field.getAttribute("surl") == "/files/upload_approvalG/sealImg/nostamp.gif")
		                    NostampFlag = true;
		                else
		                    stampFlag = true;
		            }
		        }
		        if (modeflag) {
		            CheckSignImg();
		            if (noFieldsAvailable) {
		                noFieldsAvailable = false;
		            }
		            else {
		                var rtnVal = ExcuteInfo("MIDDLE_SIGN_INIT", "");
		                if (!rtnVal) {
		                    var pAlertContent = "[" + "<spring:message code='ezApprovalG.t8'/>";
		                    OpenAlertUI(pAlertContent);
		                    return;
		                }
		
		                process_AfterOpen();
		                CheckOpinionYN();
		
		                if (message.CKEDITOR.instances.editor1.document.$.body.getAttribute(("KP_YGubun"), 0)) {
		                    setMenuBar("btnConn", true);
		                    btnConn.childNodes(0).innerText = "<spring:message code='ezApprovalG.t9'/>";
		                }
		                else
		                    setMenuBar("btnConn", false);
		
		                AllApprove.style.display = "";
		                if (allFlag == "1" || allFlag == "2")
		                    OpenAllApproveFlag();
		            }
		        }
		        message.SetEditable(false);
		    }
		    window.onbeforeunload = function () {
		        try {
		            window.opener.openergetDocInfo();
		        } catch (e) { }
		    };
		    function btnClose_onclick() {
		        window.close();
		    }
		    var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent, CompleteFunction) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		
		        if (CrossYN()) {
		            ezapralert_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapralert_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		    }
		
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		
		
		    var ezapropinion_cross_dialogArguments = new Array();
		    function OpenInformationUI(pInformationContent, CompleteFunction) {
		        var parameter = pInformationContent;
		        var url = "/ezApprovalG/ezAprOpinion.do";
		
		        if (CrossYN()) {
		            ezapropinion_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		        return RtnVal;
		    }
		
		    function OpenInformationUI_Complete() {
		        DivPopUpHidden();
		    }
		    var ezchkpasswd_cross_dialogArguments = new Array();
		    function chk_Passwd(pPwd, Complete_Function) {
		        var parameter = pUserID;
		
		        ezchkpasswd_cross_dialogArguments[0] = parameter;
		        ezchkpasswd_cross_dialogArguments[1] = Complete_Function;
		
		        DivPopUpShow(330, 205, "/ezApprovalG/ezchkPasswd.do");
		    }
		    function setArrAttachInfo() {
		        // lstAttachLink.getElementsByTagName("a").length
		
		        //var objNodes = lstAttachLink.getElementsByTagName("a");
		        //var idx = 0;
		        //for (var i = 0 ; i < objNodes.length ; i++) {
		        //    if (typeof (objNodes[i].outerHTML) != "undefined") {
		        //        var pHref = objNodes[i].href;
		        //        var pFilePath;
		        //        var pFileExt = "";
		        //        if (pHref == "") {
		        //            pHref = objNodes[i].outerHTML;
		        //            pFilePath = pHref.substring(pHref.indexOf("DocHref=") + 8, pHref.indexOf("&amp;", pHref.indexOf("DocHref=")));
		        //            pFileExt = pFilePath.substring(pFilePath.lastIndexOf("."), pFilePath.length);
		        //        }
		        //        else {
		        //            //pFilePath = pHref.substring(pHref.indexOf("filepath=") + 9, pHref.length);
		        //            pFilePath = pHref;
		        //        }
		        //        attachName[idx] = objNodes[i].innerText + pFileExt;
		        //        attachPath[idx] = unescape(pFilePath);
		        //        attachType[idx] = "";
		        //        idx++;
		        //    }
		        //}
		
		        var objNodes = lstAttachLink.getElementsByTagName("a");
		        var idx = 0;
		        for (var i = 0 ; i < objNodes.length ; i++) {
		            if (typeof (objNodes[i].outerHTML) != "undefined") {
		                var pHref = objNodes[i].href;
		                var pFilePath;
		                var pFileExt = "";
		                if (pHref == "") {
		                    pHref = objNodes[i].outerHTML;
		                    pFilePath = pHref.substring(pHref.indexOf("DocHref=") + 8, pHref.indexOf("&amp;", pHref.indexOf("DocHref=")));
		                    pFileExt = pFilePath.substring(pFilePath.lastIndexOf("."), pFilePath.length);
		                }
		                else {
		                    pFilePath = pHref.substring(pHref.indexOf("filepath=") + 9, pHref.length);
		                }
		                attachName[idx] = objNodes[i].innerText + pFileExt;
		                attachPath[idx] = unescape(pFilePath);
		                attachType[idx] = "";
		                idx++;
		            }
		        }
		    }
		    function btnSetReceivLine_onclick() {
		        DivPopUpShow(540, 240, "/ezApprovalG/ezReceiptInfo.do?docID=" + pDocID);
		    }
		    function btnOpinion_onclick() {
		        var parameter = new Array();
		        parameter[0] = pOrgDocID;
		        parameter[1] = "Show";
		        var url = "/ezApprovalG/aprEndOpinion.do";
		        var feature = "status:no;dialogWidth:387px;dialogHeight:304px;scroll:no;edge:sunken";
		        feature = feature + GetShowModalPosition(387, 304);
		        var ret = window.showModalDialog(url, parameter, feature);
		    }
		    function btnSend_onclick() {
		        if (!stampFlag && !NostampFlag) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t216'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        var pInformationContent = "<spring:message code='ezApprovalG.t205'/>";
		        OpenInformationUI(pInformationContent, Send_OpenUI);
		    }
		    function Send_OpenUI(Ans) {
		        DivPopUpHidden();
		        if (!Ans) return;
		        if ("${approvalPWD}" != "N") {
		            var chkpass = chk_Passwd(pUserID, Send_ChkPassword);
		        }
		        else {
		            btnSend_onclick_Complete();
		        }
		    }
		    function Send_ChkPassword(chkpass) {
		        DivPopUpHidden();
		        if (chkpass == "False") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else if (chkpass == "cancel")
		            return;
		
		        btnSend_onclick_Complete();
		    }
		
		    function btnSend_onclick_Complete() {
		        SaveFile();
		        var rtnVal = "FALSE";
		        if (isExternal) {
		            if (isAddress) {
		                rtnVal = SetContainer();
		            }
		            else {
		                is_Enc = OpenCheckUI();
		            }
		        }
		        else {
		            Check_Container();
		        }
		    }
		
		    function Check_Container() {
		        rtnVal = SetContainer();
		        if (rtnVal == "TRUE") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t206'/>";
		            OpenAlertUI(pAlertContent);
		            setBtnDisable();
		        }
		        else {
		            var pAlertContent = "<spring:message code='ezApprovalG.t217'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		
		    function OpenCheckUI_Complete(returnvalue) {
		        DivPopUpHidden();
		        is_Enc = returnvalue;
		        sendExt();
		    }
		
		    function DeleteLocalFiles() {
		    }
		
		    function btnBoard_onclick() {
		        if (!stampFlag && !NostampFlag) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t216'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        var pInformationContent = "<spring:message code='ezApprovalG.t218'/>" + "<br>" + "<spring:message code='ezApprovalG.t219'/>";
		        OpenInformationUI(pInformationContent, btnBoard_onclick_Complete);
		    }
		    var writeboardselect_modal_dialogArguments = new Array();
		    function btnBoard_onclick_Complete(Ans) {
		        DivPopUpHidden();
		        if (!Ans) return;
// 		        SaveFile();
		
		        writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
		        var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(345, 660));
		    }
		
		    function NewItem_onclick_Complete(ret) {
		        if (typeof (ret) != "undefined") {
		            pBoardID = ret[0];
		
		            if (pBoardID == "" || typeof (pBoardID) == "undefined") {
		                return;
		            }
		
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 870) / 2;
		            var pLeft = (pwidth - 765) / 2;
		
		            if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4") {
		                alert(strLang625);
		            }
		            else {
		                window.open("/ezBoard/boardNewItem.do?boardID=" + pBoardID + "&mode=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + pDocHref, '', "top=" + pTop.toString() + ", left=" + pLeft.toString() + ',height=870,width=765,scrollbars=no');
		            }
		        }
		    }
		
		    function btnReject_onclick() {
		        var pInformationContent = "<spring:message code='ezApprovalG.t36'/>";
		        OpenInformationUI(pInformationContent, Reject_OpenUI);
		    }
		    function Reject_OpenUI(Ans) {
		        DivPopUpHidden();
		        if (!Ans) return;
		        if ("${approvalPWD}" != "N") {
		            chk_Passwd(pUserID, Reject_ChkPassword);
		        }
		        else {
		            openOpinionUI("BanSong");
		        }
		    }
		    function Reject_ChkPassword(chkpass) {
		        DivPopUpHidden();
		        if (chkpass == "False") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else if (chkpass == "cancel")
		            return;
		
		        openOpinionUI("BanSong");
		    }
		
		    var apropinion_cross_dialogArguments = new Array();
		    function openOpinionUI(ret) {
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = ret;
		        parameter[2] = "002";
		        parameter[3] = pOrgDocID;
		
		        apropinion_cross_dialogArguments[0] = parameter;
		        apropinion_cross_dialogArguments[1] = openOpinionUI_Complete;
		
		        DivPopUpShow(530, 520, "/ezApprovalG/aprOpinion.do");
		    }
		
		    function openOpinionUI_Complete(ret) {
		        DivPopUpHidden();
		
		        if (ret != "cancel") {
		            SaveFile();
		            
			    	var result = "";
			    	
		    		$.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/ezApprovalG/sendOfferReject.do",
			    		data : {
			    			docID : pDocID,
			    			userID : pUserID
			    		},
			    		success: function(xml){
			    			result = loadXMLString(xml);
			    		}        			
			    	});
		    		
		            var ResultXML = result;
		            if (getNodeText(GetChildNodes(ResultXML)[0]) == "TRUE") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t256'/>";
		                OpenAlertUI(pAlertContent);
		                setBtnDisable();
		            }
		            else {
		                var pAlertContent = "<spring:message code='ezApprovalG.t258'/>";
		                OpenAlertUI(pAlertContent);
		            }
		        }
		    }
		
		    function SuccessBoard() {
		        var rtnVal = SetContainer();
		        if (rtnVal == "TRUE") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t211'/>";
		            OpenAlertUI(pAlertContent);
		            setBtnDisable();
		        }
		        else {
		            var pAlertContent = "<spring:message code='ezApprovalG.t220'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		    function SetContainer() {
		    	var result = "";
		    	
	    		$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/sendOfferAprove.do",
		    		data : {
		    			docID : pDocID,
		    			orgDocID  : pOrgDocID,
		    			userID : pUserID,
		    			userName : arr_userinfo[11],
		    			deptID   : arr_userinfo[4],
		    			userName2: arr_userinfo[12]
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}        			
		    	});
		    	 
		        var ResultXML = result;
		        return getNodeText(GetChildNodes(ResultXML)[0]);
		    }
		    function setBtnDisable() {
		        btnOpinion.style.display = "none";
		        btnSetReceivLine.style.display = "none";
		        btnStamp.style.display = "none";
		        btnNoStamp.style.display = "none";
		        btnSend.style.display = "none";
		        btnBoard.style.display = "none";
		        btnReject.style.display = "none";
		    }
		    function SaveFile() {
		        var mhtBody = "";
		        mhtBody = message.Get_EditorBodyHTML();
		        mhtBody = "<HTML>" + GetCKEditerHeader() + mhtBody + "</HTML>";
		        mhtBody = ConvertHTMLtoMHT(mhtBody);
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/saveEndFile.do",
		    		data : {
		    			docID : pOrgDocID,
		    			html  : mhtBody
		    		},
		    		success: function(xml){
		    			result = xml;
		    		}        			
		    	});
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/saveFile.do",
		    		data : {
		    			docID : pDocID,
		    			html  : mhtBody
		    		},
		    		success: function(text){
		    			result = text;
		    		}        			
		    	});
		        
		        return result;
		    }
		    function GetSealInfo() {
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
		    var tempDeptSealXML;
		    var tempCompSealXML;
		    function btnStamp_onclick() {
		        var strimg;
		        var field;
		        var fields = message.GetFieldsList();
		        field = message.GetListItem(fields, "sealsign");
		        if (!field) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t201'/>" + "<br>" + "<spring:message code='ezApprovalG.t191'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        if (!stampFlag) {
		            var DeptSealXML = GetDeptSealInfo();
		            var CompSealXML = GetSealInfo();
		            if (GetChildNodes(DeptSealXML, "ROWS/ROW").length > 0 && GetChildNodes(CompSealXML, "ROWS/ROW").length > 0) {
		                var pInformationContent = "<spring:message code='ezApprovalG.t192'/>" + "<BR>" + "<spring:message code='ezApprovalG.t193'/>";
		                OpenInformationUI(pInformationContent, Stamp_OpenUI);
		                tempDeptSealXML = DeptSealXML;
		                tempCompSealXML = CompSealXML;

		                return;
		            }
		            else if (GetChildNodes(DeptSealXML, "ROWS/ROW").length <= 0 && GetChildNodes(CompSealXML, "ROWS/ROW").length <= 0) {
		                var pAlertContent = "<spring:message code='ezApprovalG.t194'/>" + "<br>" + "<spring:message code='ezApprovalG.t195'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		            else if (GetChildNodes(DeptSealXML, "ROWS/ROW").length > 0) {
		                SealXML = DeptSealXML;
		            }
		            else if (GetChildNodes(CompSealXML, "ROWS/ROW").length > 0) {
		                SealXML = CompSealXML;
		            }

		            var SealHref = getNodeText(SelectSingleNode(SelectNodes(SealXML, "ROWS/ROW/CELL")[0], "DATA2"));
		            var SealWidth = parseInt(getNodeText(SelectSingleNode(SelectNodes(SealXML, "ROWS/ROW/CELL")[1], "VALUE")));
		            var SealHeight = parseInt(getNodeText(SelectSingleNode(SelectNodes(SealXML, "ROWS/ROW/CELL")[2], "VALUE")));
		            field = message.GetListItem(fields, "sealsign");
		            if (field) {
		                var signWidth = getPixel(SealWidth) + "px";
		                var signHeight = getPixel(SealHeight) + "px";
		                strimg = "<img src='" + encodeURI(SealHref) + "' border=0 embedding='1' ";
		                strimg = strimg + " width=" + signWidth;
		                strimg = strimg + " height=" + signHeight + ">";
		                var field2 = message.GetListItem(fields, "chief");
		                var chiefwidth = 1;
		                if (field2) {
		                    chiefwidth = (GetByte(field2.innerText) / 2) * 20;
		                    field2.height = signHeight;
		                }
		                var sealwidth = (maxwidth + chiefwidth) / 2 - 5;
		                var field2 = message.GetListItem(fields, "sealwidth");
		                if (field2)
		                    field2.width = sealwidth;
		                var field2 = message.GetListItem(fields, "noseal");
		                if (field2) {
		                    field2.width = (maxwidth - sealwidth - getPixel(SealWidth));
		                    field2.innerHTML = " ";
		                    NostampFlag = false;
		                }
		                field.innerHTML = strimg;
		                field.width = getPixel(SealWidth);
		                field.height = getPixel(SealHeight);
		                field.setAttribute("surl", SealHref);
		                stampFlag = true;
		            }
		        }
		        else {
		            field = message.GetListItem(fields, "sealsign");
		            if (field) {
		                field.innerHTML = " ";
		                stampFlag = false;
		            }
		        }
		    }
		
		    function Stamp_OpenUI(Ans) {
		        DivPopUpHidden();
		        if (!Ans)
		            SealXML = tempCompSealXML;
		        else
		            SealXML = tempDeptSealXML;

		        var SealHref = getNodeText(SelectSingleNode(SelectNodes(SealXML, "ROWS/ROW/CELL")[0], "DATA2"));
		        var SealWidth = parseInt(getNodeText(SelectSingleNode(SelectNodes(SealXML, "ROWS/ROW/CELL")[1], "VALUE")));
		        var SealHeight = parseInt(getNodeText(SelectSingleNode(SelectNodes(SealXML, "ROWS/ROW/CELL")[2], "VALUE")));
		        var fields = message.GetFieldsList();
		        field = message.GetListItem(fields, "sealsign");
		        if (field) {
		            var signWidth = getPixel(SealWidth) + "px";
		            var signHeight = getPixel(SealHeight) + "px";
		            strimg = "<img src='" + encodeURI(SealHref) + "' border=0 embedding='1' ";
		            strimg = strimg + " width=" + signWidth;
		            strimg = strimg + " height=" + signHeight + ">";
		            var field2 = message.GetListItem(fields, "chief");
		            var chiefwidth = 1;
		            if (field2) {
		                chiefwidth = (GetByte(field2.innerText) / 2) * 20;
		                field2.height = signHeight;
		            }
		            var sealwidth = (maxwidth + chiefwidth) / 2 - 5;
		            var field2 = message.GetListItem(fields, "sealwidth");
		            if (field2)
		                field2.width = sealwidth;
		            var field2 = message.GetListItem(fields, "noseal");
		            if (field2) {
		            	if ((maxwidth - sealwidth - getPixel(SealWidth)) < 0) {
			                field2.width = 20;
		            	} else {
			                field2.width = (maxwidth - sealwidth - getPixel(SealWidth));
		            	}
		            	
		                field2.innerHTML = " ";
		                NostampFlag = false;
		            }
		            field.innerHTML = strimg;
		            field.width = getPixel(SealWidth);
		            field.height = getPixel(SealHeight);
		            field.setAttribute("surl", SealHref);
		            stampFlag = true;
		        }
		    }
		    function GetByte(pStr) {
		        var len = pStr.length;
		        var tot = 0;
		
		        for (var i = 0 ; i < len ; i++) {
		            var temp = pStr.charAt(i);
		
		            if (escape(temp).length > 4) {
		                tot += 2;
		            }
		            else {
		                tot++;
		            }
		        }
		        return tot;
		    }
		    function btnNoStamp_onclick() {
		        var strimg;
		        var field;
		        var fields = message.GetFieldsList();
		        field = message.GetListItem(fields, "sealsign");
		        if (!field) {
		            NostampFlag = true;
		            var pAlertContent = "<spring:message code='ezApprovalG.t201'/>" + "<br>" + "<spring:message code='ezApprovalG.t221'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        if (!NostampFlag) {
		            var SealHref = "/fileroot/${userInfo.tenantId}/files/upload_approvalG/sealImg/nostamp.gif";
		            var SealWidth = 30;
		            var SealHeight = 30;
		            field = message.GetListItem(fields, "sealsign");
		            if (field) {
		                var signWidth = getPixel(SealWidth) + "px";
		                var signHeight = getPixel(SealHeight) + "px";
		
		                strimg = "<img src='" + encodeURI(SealHref) + "' border=0 embedding='1' >";
		                //strimg = strimg + " width=" + signWidth;
		                //strimg = strimg + " height=" + signHeight + ">";
		
		                var field2 = message.GetListItem(fields, "chief");
		                var chiefwidth = 1;
		                if (field2) {
		                    chiefwidth = parseInt(field2.width);
		                    field2.height = signHeight;
		                }
		                var sealwidth = (maxwidth + chiefwidth) / 2 + 20;
		                var field2 = message.GetListItem(fields, "sealwidth");
		                if (field2)
		                    field2.width = sealwidth;
		
		                var field2 = message.GetListItem(fields, "noseal");
		                if (field2) {
		                    if ((maxwidth - sealwidth - getPixel(SealWidth)) > 0)
		                        field2.width = (maxwidth - sealwidth - getPixel(SealWidth));
		                    else
		                        field2.width = (maxwidth - sealwidth - getPixel(SealWidth)) * (-1);
		                    field2.innerHTML = " ";
		                    stampFlag = false;
		                }
		                field.width = getPixel(SealWidth);
		                field.height = getPixel(SealHeight);
		                field.innerHTML = strimg;
		                field.setAttribute("surl", SealHref);
		                NostampFlag = true;
		            }
		        }
		        else {
		            field = message.GetListItem(fields, "sealsign");
		            if (field) {
		                field.innerHTML = " ";
		                NostampFlag = false;
		            }
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
		    function GetDeptSealInfo()
		    {
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
		    		}        			
		    	});
	    		
		        return result;
		    }
		    function Conversion(pixel) {
		        return parseInt(pixel * (35 / 100));
		    }
		
		    function SizeConvert(size) {
		        return Math.round(parseFloat(size) * parseFloat("0.35")).toFixed(2);
		    }
		
		    function Document_Encode(text) {   
		        var xmlhttp = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "CONTENT", text);
		        xmlhttp.open("POST", "aspx/GetContentXml.aspx", false);
		        xmlhttp.send(xmlpara);
		
		        var Content = document.createElement("DIV");
		        Content.innerHTML = xmlhttp.responseText;
		
		        var ElementsRows = Content.getElementsByTagName("*");
		        for (var Cnt = 0; Cnt < ElementsRows.length; Cnt++) {
		            ElementsRows.item(Cnt).removeAttribute("bgColor");
		            if (ElementsRows.item(Cnt).tagName == "P") {
		                if (ElementsRows.item(Cnt).innerHTML == "")
		                    ElementsRows.item(Cnt).outerHTML = "";
		                else {
		                    var ArrCSSs = ElementsRows.item(Cnt).style.cssText.split(';');
		                    var retCssText = "";
		                    var retAlignText = "";
		                    for (var i = 0; i < ArrCSSs.length; i++) {
		                        if (ArrCSSs[i] != "") {
		                            var ArrCss = ArrCSSs[i].split(":");
		                            if (ArrCss.length == 2) {
		                                switch (trim_Cross(ArrCss[0].toLowerCase())) {
		                                    case "text-indent":
		                                        if (ArrCss[1].indexOf("mm") > 0)
		                                            retCssText += " text-indent:" + ArrCss + ";";
		                                        else {
		                                            var Size = ArrCss[1].replace("pt", "").replace("px", "").replace("mm", "");
		                                            if (parseInt(Size) < 0)
		                                                retCssText += " text-indent:" + SizeConvert(Size) + "mm;";
		                                            else
		                                                retCssText += " text-indent:0mm;";
		                                        }
		                                        break;
		                                    case "margin-left": retCssText += ArrCSSs[i] + ";";
		                                        break;
		                                    case "margin-right": retCssText += ArrCSSs[i] + ";";
		                                        break;
		                                    case "margin-top": retCssText += ArrCSSs[i] + ";";
		                                        break;
		                                    case "margin-bottom": retCssText += ArrCSSs[i] + ";";
		                                        break;
		                                    case "font-family": retCssText += ArrCSSs[i] + ";";
		                                        break;
		                                    case "font-size": retCssText += ArrCSSs[i] + ";";
		                                        break;
		                                    case "line-height": retCssText += ArrCSSs[i] + ";";
		                                        break;
		                                    case "text-align": retAlignText = ArrCss[1].toLowerCase().replace("justify", "left");
		                                        break;
		                                }
		
		                                ElementsRows.item(Cnt).style.cssText = retCssText;
		                                if (retAlignText != "")
		                                    ElementsRows.item(Cnt).style.textAlign = retAlignText;
		                                var LastTag = ElementsRows.item(Cnt).outerHTML.substring(ElementsRows.item(Cnt).outerHTML.length - 4).toUpperCase();
		                                if (LastTag != "</P>")
		                                    ElementsRows.item(Cnt).outerHTML = ElementsRows.item(Cnt).outerHTML + "</P>";
		                            }
		                        }
		                    }
		                    ElementsRows.item(Cnt).removeAttribute("dir");
		                }
		            }
		            else if (ElementsRows.item(Cnt).tagName == "SPAN") {
		                if (ElementsRows.item(Cnt).innerText == "")
		                    ElementsRows.item(Cnt).outerHTML = "";
		                if (ElementsRows.item(Cnt).style.getAttribute("HWP-TAB") != null)
		                    ElementsRows.item(Cnt).outerHTML = "";
		            }
		            else if (ElementsRows.item(Cnt).tagName == "A") {
		                ElementsRows.item(Cnt).innerHTML = ElementsRows.item(Cnt).innerText;
		                ElementsRows.item(Cnt).removeAttribute("target");
		                ElementsRows.item(Cnt).removeAttribute("name");
		            }
		            else {
		                //if (ElementsRows.item(Cnt).tagName != "TR") {
		                //    if (ElementsRows.item(Cnt).style.width != "") {
		                //        ElementsRows.item(Cnt).style.setAttribute("Width", SizeConvert(ElementsRows.item(i).style.pixelWidth) + "mm");
		                //        ElementsRows.item(Cnt).style.removeProperty("width");
		                //    }
		                //    if (ElementsRows.item(Cnt).getAttribute("width") != null && ElementsRows.item(Cnt).getAttribute("width") != "") {
		                //        ElementsRows.item(Cnt).setAttribute("Width", SizeConvert(ElementsRows.item(Cnt).getAttribute("width")) + "mm");
		                //        ElementsRows.item(Cnt).removeAttribute("width");
		                //    }
		                //}
		                if (ElementsRows.item(Cnt).tagName != "COL" && ElementsRows.item(i).tagName != "COLGROUP" && ElementsRows.item(i).tagName != "TR") {
		                    if (ElementsRows.item(Cnt).style.height != "") {
		                        ElementsRows.item(Cnt).style.setAttribute("Hidth", SizeConvert(ElementsRows.item(i).style.pixelHeight) + "mm");
		                        ElementsRows.item(Cnt).style.removeProperty("height");
		                    }
		                    if (ElementsRows.item(Cnt).getAttribute("height") != null && ElementsRows.item(Cnt).getAttribute("height") != "") {
		                        ElementsRows.item(Cnt).setAttribute("Height", SizeConvert(ElementsRows.item(Cnt).getAttribute("height")) + "mm");
		                        ElementsRows.item(Cnt).removeAttribute("height");
		                    }
		                }
		                if (ElementsRows.item(Cnt).tagName == "TD") {
		                    if (ElementsRows.item(Cnt).style.background != "")
		                        ElementsRows.item(Cnt).style.removeProperty("background");
		                    if (ElementsRows.item(Cnt).style.backgroundColor != "")
		                        ElementsRows.item(Cnt).style.removeProperty("backgroundColor");
		
		                    ElementsRows.item(Cnt).removeAttribute("x:num");
		                    ElementsRows.item(Cnt).removeAttribute("x:str");
		
		                    if (ElementsRows.item(Cnt).style.width != "") {
		                        ElementsRows.item(Cnt).style.setAttribute("Width", SizeConvert(ElementsRows.item(i).style.pixelWidth) + "mm");
		                        ElementsRows.item(Cnt).style.removeProperty("width");
		                    }
		
		                    if (ElementsRows.item(Cnt).getAttribute("width") != null && ElementsRows.item(Cnt).getAttribute("width") != "") {
		                        ElementsRows.item(Cnt).setAttribute("Width", SizeConvert(ElementsRows.item(Cnt).getAttribute("width")) + "mm");
		                        //ElementsRows.item(Cnt).removeAttribute("width");
		                    }
		                }
		                if (ElementsRows.item(Cnt).tagName == "TABLE") {
		                    if (ElementsRows.item(Cnt).getAttribute("border") == "")
		                        ElementsRows.item(Cnt).setAttribute("border", "1");
		
		                    if (ElementsRows.item(Cnt).style.height != "") {
		                        ElementsRows.item(Cnt).style.setAttribute("Height", SizeConvert(ElementsRows.item(i).style.pixelWidth) + "mm");
		                        ElementsRows.item(Cnt).style.removeProperty("Height");
		                    }
		
		                    if (ElementsRows.item(Cnt).getAttribute("height") != null && ElementsRows.item(Cnt).getAttribute("height") != "") {
		                        ElementsRows.item(Cnt).setAttribute("height", SizeConvert(ElementsRows.item(Cnt).getAttribute("height")) + "mm");
		                        //ElementsRows.item(Cnt).removeAttribute("width");
		                    }
		
		
		                    ElementsRows.item(Cnt).removeAttribute("ver");
		                    ElementsRows.item(Cnt).removeAttribute("kaoni");
		                    ElementsRows.item(Cnt).removeAttribute("x:num");
		                    ElementsRows.item(Cnt).removeAttribute("x:str");
		                }
		                if (ElementsRows.item(Cnt).tagName == "TR") {
		                    ElementsRows.item(Cnt).removeAttribute("height");
		                    ElementsRows.item(Cnt).removeAttribute("Height");
		                }
		            }
		        }
		        return Content.outerHTML;
		    }
		
		    function EncodeJavaScript(text) {
		        var BodyStr = text;
		        BodyStr = BodyStr.replace(/&nbsp;/g, "&amp;nbsp;");
		        BodyStr = BodyStr.replace(/"/g, "'");
		        BodyStr = BodyStr.replace(/: '/g, ":");
		        BodyStr = BodyStr.replace(/'; /g, "; ");
		        BodyStr = BodyStr.replace(/<br>/g, "");
		        BodyStr = BodyStr.replace(/vAlign=center/g, "vAlign=middle");
		        var xmlhttp = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "CONTENT", BodyStr);
		        xmlhttp.open("POST", "aspx/GetContentXml.aspx", false);
		        xmlhttp.send(xmlpara);        
		
		        var BodyXml = loadXMLString(xmlhttp.responseText);
		
		        pPtags = BodyXml.getElementsByTagName("p");
		        for (var i = 0; i < pPtags.length; i++) {
		            var arrCss = pPtags.item(i).getAttribute("style");
		            var NewarrCss;
		            var RetAlignText = "";
		            var RetCss = "";
		            if (arrCss != null) {
		                var CssArry = arrCss.split(";");
		                for (var j = 0; j < CssArry.length; j++) {
		                    switch (CssArry[j].split(":")[0].toLowerCase()) {
		                        case "text-indent":
		                            var ti;
		                            ti = parseInt(CssArry[j].split(":")[1].replace("pt", "").replace("px", "").replace("mm", ""));
		                            if (ti > 0)
		                                RetCss += " text-indent:" + Conversion(ti) + "mm;";
		                            else
		                                RetCss += " text-indent:0mm;";
		                            continue;
		                        case "margin-left":
		                            RetCss += CssArry[j] + ";"; continue;
		                        case "margin-right":
		                            RetCss += CssArry[j] + ";"; continue;
		                        case "margin-top":
		                            RetCss += CssArry[j] + ";"; continue;
		                        case "margin-bottom":
		                            RetCss += CssArry[j] + ";"; continue;
		                        case "font-family":
		                            RetCss += CssArry[j] + ";"; continue;
		                        case "font-size":
		                            RetCss += CssArry[j] + ";"; continue;
		                        case "line-height":
		                            RetCss += CssArry[j] + ";"; continue;
		                        case "text-align":
		                            RetAlignText = CssArry[j].split(":")[1].replace("justify", "left");
		                    }
		                }
		                pPtags.item(i).setAttribute("style", RetCss);
		                if (RetAlignText != "")
		                    pPtags.item(i).setAttribute("align", RetAlignText);
		            }
		            pPtags.item(i).removeAttribute("dir");
		        }
		        pSpanTags = BodyXml.getElementsByTagName("span");
		        for (var i = 0; i < pSpanTags.length; i++) {
		            if (getNodeText(pSpanTags.item(8)) == "") {
		                var RemoveNode = pSpanTags.item(8);
		                BodyXml.documentElement.removeChild(RemoveNode);
		            }
		        }
		        pAtags = BodyXml.getElementsByTagName("a");
		        for (var i = 0; i < pAtags.length; i++) {
		            pAtags.item(i).removeAttribute("target");
		        }
		        pTrTags = BodyXml.getElementsByTagName("tr");
		        for (var i = 0; i < pTrTags.length; i++) {
		            pTrTags.item(i).removeAttribute("height");
		            pTrTags.item(i).removeAttribute("Height");
		        }
		        pImgTags = BodyXml.getElementsByTagName("img");
		        for (var i = 0; i < pImgTags.length; i++) {
		            if (pImgTags.item(i).getAttribute("style") != null && pImgTags.item(i).getAttribute("style") != null) {
		                var arrCss = pImgTags.item(i).getAttribute("style");
		                var CssArry = arrCss.split(";");
		                var pWidthCss = "";
		                var pHeighCss = "";
		                var RetCss = "";
		                for (var j = 0; j < CssArry.length; j++) {
		                    switch (CssArry[j].split(":")[0].toLowerCase()) {
		                        case "width":
		                            pWidthCss = CssArry[j].split(":")[1]; continue;
		                        case "heigh":
		                            pHeighCss = CssArry[j].split(":")[1]; continue;
		                        default:
		                            RetCss += CssArry[j] + ";"; continue;
		                    }
		                }
		                pImgTags.item(i).setAttribute("style", RetCss);
		
		                if (pWidthCss != "") {
		                    var temp = pWidthCss.replace("pt", "").replace("px", "").replace("mm", "");
		                    pWidthCss = parseInt(temp == "" ? 0 : temp);
		                    pImgTags.item(i).setAttribute("width", Conversion(pWidthCss) + "mm");
		
		                }
		                else {
		                    var temptag = pImgTags.item(i).getAttribute("width") == null ? "" : pImgTags.item(i).getAttribute("width");
		                    if (temptag != "") {
		                        temptag = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                        pWidth = parseInt(temptag == "" ? 0 : temptag);
		                        pImgTags.item(i).setAttribute("width", Conversion(pWidth) + "mm");
		                    }
		                }
		                if (pHeighCss != "") {
		                    var temp = pHeighCss.replace("pt", "").replace("px", "").replace("mm", "");
		                    pHeighCss = parseInt(temp == "" ? 0 : temp);
		                    pImgTags.item(i).setAttribute("height", Conversion(pHeighCss) + "mm");
		                }
		                else {
		                    var temptag = pImgTags.item(i).getAttribute("height") == null ? "" : pImgTags.item(i).getAttribute("height");
		                    if (temptag != "") {
		                        temp = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                        pHidth = parseInt(temp == "" ? 0 : temp);
		                        pImgTags.item(i).setAttribute("height", Conversion(pHidth) + "mm");
		                    }
		                }
		            }
		            else {
		                var temptag = pImgTags.item(i).getAttribute("width") == null ? "" : pImgTags.item(i).getAttribute("width");
		                if (temptag != "") {
		                    temptag = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                    pWidth = parseInt(temptag == "" ? 0 : temptag);
		                    pImgTags.item(i).setAttribute("width", Conversion(pWidth) + "mm");
		                }
		                var temptag = pImgTags.item(i).getAttribute("height") == null ? "" : pImgTags.item(i).getAttribute("height");
		                if (temptag != "") {
		                    temp = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                    pHidth = parseInt(temp == "" ? 0 : temp);
		                    pImgTags.item(i).setAttribute("height", Conversion(pHidth) + "mm");
		                }
		            }
		        }
		        pTdTags = BodyXml.getElementsByTagName("td");
		        for (var i = 0; i < pTdTags.length; i++) {
		            if (pTdTags.item(i).getAttribute("style") != null && pTdTags.item(i).getAttribute("style") != null) {
		                var arrCss = pTdTags.item(i).getAttribute("style");
		                var CssArry = arrCss.split(";");
		                var pWidthCss = "";
		                var pHeighCss = "";
		                var RetCss = "";
		                for (var j = 0; j < CssArry.length; j++) {
		                    switch (CssArry[j].split(":")[0].toLowerCase()) {
		                        case "width":
		                            pWidthCss = CssArry[j].split(":")[1]; continue;
		                        case "heigh":
		                            pHeighCss = CssArry[j].split(":")[1]; continue;
		                        default:
		                            RetCss += CssArry[j] + ";"; continue;
		                    }
		                }
		                pTdTags.item(i).setAttribute("style", RetCss);
		
		                if (pWidthCss != "") {
		                    var temp = pWidthCss.replace("pt", "").replace("px", "").replace("mm", "");
		                    pWidthCss = parseInt(temp == "" ? 0 : temp);
		                    pTdTags.item(i).setAttribute("width", Conversion(pWidthCss) + "mm");
		                }
		                else {
		                    var temptag = pTdTags.item(i).getAttribute("width") == null ? "" : pTdTags.item(i).getAttribute("width");
		                    if (temptag != "") {
		                        temptag = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                        pWidth = parseInt(temptag == "" ? 0 : temptag);
		                        pTdTags.item(i).setAttribute("width", Conversion(pWidth) + "mm");
		                    }
		                }
		                if (pHeighCss != "") {
		                    var temp = pHeighCss.replace("pt", "").replace("px", "").replace("mm", "");
		                    pHeighCss = parseInt(temp == "" ? 0 : temp);
		                    pTdTags.item(i).setAttribute("height", Conversion(pHeighCss) + "mm");
		                }
		                else {
		                    var temptag = pTdTags.item(i).getAttribute("height") == null ? "" : pTdTags.item(i).getAttribute("height");
		                    if (temptag != "") {
		                        temp = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                        pHidth = parseInt(temp == "" ? 0 : temp);
		                        pTdTags.item(i).setAttribute("height", Conversion(pHidth) + "mm");
		                    }
		                }
		            }
		            else {
		                var temptag = pTdTags.item(i).getAttribute("width") == null ? "" : pTdTags.item(i).getAttribute("width");
		                if (temptag != "") {
		                    temptag = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                    pWidth = parseInt(temptag == "" ? 0 : temptag);
		                    pTdTags.item(i).setAttribute("width", Conversion(pWidth) + "mm");
		                }
		                var temptag = pTdTags.item(i).getAttribute("height") == null ? "" : pTdTags.item(i).getAttribute("height");
		                if (temptag != "") {
		                    temp = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                    pHidth = parseInt(temp == "" ? 0 : temp);
		                    pTdTags.item(i).setAttribute("height", Conversion(pHidth) + "mm");
		                }
		            }
		
		            if (pTdTags.item(i).getAttribute("Background") == "")
		                pTdTags.item(i).removeAttribute("Background");
		
		            pTdTags.item(i).removeAttribute("x:num");
		            pTdTags.item(i).removeAttribute("x:str");
		            pTdTags.item(i).removeAttribute("free");
		        }
		        pTables = BodyXml.getElementsByTagName("table");
		        for (var i = 0; i < pTables.length; i++) {
		            if (pTables.item(i).getAttribute("style") != null && pTables.item(i).getAttribute("style") != null) {
		                var arrCss = pTables.item(i).getAttribute("style");
		                var CssArry = arrCss.split(";");
		                var pWidthCss = "";
		                var pHeighCss = "";
		                var RetCss = "";
		                for (var j = 0; j < CssArry.length; j++) {
		                    switch (CssArry[j].split(":")[0].toLowerCase()) {
		                        case "width":
		                            pWidthCss = CssArry[j].split(":")[1]; continue;
		                        case "heigh":
		                            pHeighCss = CssArry[j].split(":")[1]; continue;
		                        default:
		                            RetCss += CssArry[j] + ";"; continue;
		                    }
		                }
		                pTables.item(i).setAttribute("style", RetCss);
		
		                if (pWidthCss != "") {
		                    var temp = pWidthCss.replace("pt", "").replace("px", "").replace("mm", "");
		                    pWidthCss = parseInt(temp == "" ? 0 : temp);
		                    pTables.item(i).setAttribute("width", Conversion(pWidthCss) + "mm");
		
		                }
		                else {
		                    var temptag = pTables.item(i).getAttribute("width") == null ? "" : pTables.item(i).getAttribute("width");
		                    if (temptag != "") {
		                        temptag = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                        pWidth = parseInt(temptag == "" ? 0 : temptag);
		                        pTables.item(i).setAttribute("width", Conversion(pWidth) + "mm");
		                    }
		                }
		                if (pHeighCss != "") {
		                    var temp = pHeighCss.replace("pt", "").replace("px", "").replace("mm", "");
		                    pHeighCss = parseInt(temp == "" ? 0 : temp);
		                    pTables.item(i).setAttribute("height", Conversion(pHeighCss) + "mm");
		                }
		                else {
		                    var temptag = pTables.item(i).getAttribute("height") == null ? "" : pTables.item(i).getAttribute("height");
		                    if (temptag != "") {
		                        temp = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                        pHidth = parseInt(temp == "" ? 0 : temp);
		                        pTables.item(i).setAttribute("height", Conversion(pHidth) + "mm");
		                    }
		                }
		            }
		            else {
		                var temptag = pTables.item(i).getAttribute("width") == null ? "" : pTables.item(i).getAttribute("width");
		                if (temptag != "") {
		                    temptag = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                    pWidth = parseInt(temptag == "" ? 0 : temptag);
		                    pTables.item(i).setAttribute("width", Conversion(pWidth) + "mm");
		                }
		                var temptag = pTables.item(i).getAttribute("height") == null ? "" : pTables.item(i).getAttribute("height");
		                if (temptag != "") {
		                    temp = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                    pHidth = parseInt(temp == "" ? 0 : temp);
		                    pTables.item(i).setAttribute("height", Conversion(pHidth) + "mm");
		                }
		            }
		
		            if (pTables.item(i).getAttribute("border") == "")
		                pTables.item(i).setAttribute("border", "1");
		            pTables.item(i).removeAttribute("ver");
		            pTables.item(i).removeAttribute("kaoni");
		            pTables.item(i).removeAttribute("x:num");
		            pTables.item(i).removeAttribute("x:str");
		        }
		        return getXmlString(BodyXml);
		    }
		    function TagsWidthHeightConvert(obj) {
		        if (obj.getAttribute("style") != null && obj.getAttribute("style") != null) {
		            var arrCss = pPtags.item(i).getAttribute("style");
		            var CssArry = arrCss.split(";");
		            var pWidthCss = "";
		            var pHeighCss = "";
		            var RetCss = "";
		            for (var j = 0; j < CssArry.length; j++) {
		                switch (CssArry[j].split(":")[0].toLowerCase()) {
		                    case "width":
		                        pWidthCss = CssArry[j].split(":")[1]; continue;
		                    case "heigh":
		                        pHeighCss = CssArry[j].split(":")[1]; continue;
		                    default:
		                        RetCss += CssArry[j] + ";"; continue;
		                }
		            }
		            obj.setAttribute("style", RetCss);
		            if (pWidthCss != "") {
		                var temp = pWidthCss.replace("pt", "").replace("px", "").replace("mm", "");
		                pWidthCss = parseInt(temp == "" ? 0 : temp);
		                obj.setAttribute("width", Conversion(pWidthCss) + "mm");
		            }
		            else {
		                var temptag = obj.getAttribute("width") == null ? "" : obj.getAttribute("width");
		                if (temptag != "") {
		                    temptag = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                    pWidth = parseInt(temptag == "" ? 0 : temptag);
		                    obj.setAttribute("width", Conversion(pWidth) + "mm");
		                }
		            }
		            if (pHeighCss != "") {
		                var temp = pHeighCss.replace("pt", "").replace("px", "").replace("mm", "");
		                pHeighCss = parseInt(temp == "" ? 0 : temp);
		                obj.setAttribute("height", Conversion(pHeighCss) + "mm");
		            }
		            else {
		                var temptag = obj.getAttribute("height") == null ? "" : obj.getAttribute("height");
		                if (temptag != "") {
		                    temp = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                    pHidth = parseInt(temp == "" ? 0 : temp);
		                    obj.setAttribute("height", Conversion(pHidth) + "mm");
		                }
		            }
		        }
		        else {
		            var temptag = obj.getAttribute("width") == null ? "" : obj.getAttribute("width");
		            if (temptag != "") {
		                temptag = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                pWidth = parseInt(temptag == "" ? 0 : temptag);
		                obj.setAttribute("width", Conversion(pWidth) + "mm");
		            }
		            var temptag = obj.getAttribute("height") == null ? "" : obj.getAttribute("height");
		            if (temptag != "") {
		                temp = temptag.replace("pt", "").replace("px", "").replace("mm", "");
		                pHidth = parseInt(temp == "" ? 0 : temp);
		                obj.setAttribute("height", Conversion(pHidth) + "mm");
		            }
		        }
		        return obj;
		    }
		</script>
	</head>
	<body class="popup"  style="overflow:hidden;height:100%;">
		<object id=oPoster classid="clsid:19E224CA-6992-425C-8006-8FA6FD2BD9E5" style="DISPLAY: none; HEIGHT: 86px; WIDTH: 243px" VIEWASTEXT></object>
		<OBJECT classid=clsid:80009476-666B-4869-8C04-AB03492561CD id=ObjGPKI style="DISPLAY: none; HEIGHT: 86px; WIDTH: 243px"></OBJECT>
		<table class="layout">
			<tr> 
				<td style="height:20px;"> 
				<div id="menu">
				<ul>
				    <li id=btnOpinion style="display:none"><span onClick="return btnOpinion_onclick()"  ><spring:message code='ezApprovalG.t55'/></span></li> 
				    <li id=btnSetReceivLine><span onClick="return btnSetReceivLine_onclick()"  ><spring:message code='ezApprovalG.t53'/></span></li> 
				    <li id=btnStamp><span onClick="return btnStamp_onclick()"  ><spring:message code='ezApprovalG.t213'/></span></li> 
				    <li id=btnNoStamp><span onClick="return btnNoStamp_onclick()"  ><spring:message code='ezApprovalG.t222'/></span></li> 
				    <li id=btnSend><span onClick="return btnSend_onclick()"  ><spring:message code='ezApprovalG.t214'/></span></li> 
				    <li id=btnBoard><span onClick="return btnBoard_onclick()"  ><spring:message code='ezApprovalG.t215'/></span></li> 
				    <li id=btnReject><span onClick="return btnReject_onclick()"  ><spring:message code='ezApprovalG.t49'/></span></li> 
				    <li id=btnPrint><span onClick="return btnPrint_onclick()" ><spring:message code='ezApprovalG.t60'/></span></li>
				</ul>
				</div>
				<div id="close">
		        <ul>
		          <li><span id="btnClose" onClick="return btnClose_onclick()" ><spring:message code='ezApprovalG.t64'/></span></li>
		        </ul>
		      </div>
				</td>
			</tr>
		  <tr>
		    <td style="vertical-align: top; height: 90%;">
		         <iframe id="Iframe1" name="message" class="viewbox" frameborder="0" style="margin: 0px; padding: 0px; width: 99.8%; height: 99.7%; overflow: hidden;" src="enforceContent.do"></iframe>
		    </td>
		  </tr>
			<tr> 
				<td style="height:20px;"><table class="file">
		        <tr>
		          <th><spring:message code='ezApprovalG.t65'/></th>
		          <td><div id="lstAttachLink"></div></td>
		        </tr>
		      </table> 
				</td>
			</tr>
		</table>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
	</body>
</html>