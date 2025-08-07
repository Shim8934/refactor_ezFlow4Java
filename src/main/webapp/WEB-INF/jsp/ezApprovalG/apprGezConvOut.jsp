<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html style="height:97%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title><spring:message code = 'ezApprovalG.t185' /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>	
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		
		<script type="text/javascript">
			var pDocID = "<c:out value ='${docID}'/>";
	        var pDocHref = "<c:out value ='${docHref}'/>";
	        var pUserID = "<c:out value ='${userInfo.id}'/>";
	        var flag = false;
	        var newDocID = "";
	        var stampFlag = false;
	        var NostampFlag = false;
	        var modeflag = false;
	        var companyID = "<c:out value = '${userInfo.companyID}' />";
		    var maxwidth = 659;
	        
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
// 	        var pDomainName = document.location.protocol + "//" + document.location.hostname
	        var symbolPath = "";
	        var symbolName = "";
	        var logoPath = "";
	        var logoName = "";
	        var pAprType = "";
	        var tempAttachSN = 0;
	        var orgCompanyID = "";
			var ext = 'mht';
			
		    window.onload = function () {
		
		    }
		
		    var PrtBodyContent;
		    function btnPrint_onclick() {
		        PrintClick("Cross", pDocID, "");
		    }
		
		    window.onbeforeunload = function () {
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
		
		    var ezapropinion_cross_dialogArguments = new Array();
		    function OpenInformationUI(pInformationContent, CompleteFunction) {
		        var parameter = pInformationContent;
		        var url = "/ezApprovalG/ezAprOpinion.do";
		        
		        if (CrossYN()) {
		            ezapropinion_cross_dialogArguments[0] = parameter;
		            
		            if (CompleteFunction != undefined) {
		                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            } else {
		                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		            }
		            
		            DivPopUpShow(330, 205, url);
		        } else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		        
		        return RtnVal;
		    }
		
		    function OpenInformationUI_Complete() {
		        DivPopUpHidden();
		    }
		    var ezapralert_cross_dialogArguments = new Array();
		
		    function OpenAlertUI(pAlertContent, CompleteFunction) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		
		        if (CrossYN()) {
		            ezapralert_cross_dialogArguments[0] = parameter;
		            
		            if (CompleteFunction != undefined) {
		                ezapralert_cross_dialogArguments[1] = CompleteFunction;
		            } else {
		                ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            }
		            
		            DivPopUpShow(330, 205, url);
		        } else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		    }
		
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		
		    var ezchkpasswd_cross_dialogArguments = new Array();
		    function chk_Passwd(pPwd, CompleteFunction) {
		        var parameter = pPwd;
		        ezchkpasswd_cross_dialogArguments[0] = parameter;
		        if (CompleteFunction != undefined)
		            ezchkpasswd_cross_dialogArguments[1] = CompleteFunction;
		        else
		            ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;
		
		        DivPopUpShow(350, 225, "/ezApprovalG/ezchkPasswd.do");
		    }
		
		    function chk_Passwd_Complete(chkpass) {
		        DivPopUpHidden();
		        if (chkpass == "False") {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t27' />";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else if (chkpass == "cancel") {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t28' />";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		            else {
		                btnSend_onclick_Complete();
		            }
		    }
		
		    function DocumentComplete() {
		        if (flag == false) {
		            flag = true;
		            if (pDocHref != "") {
		                message.Set_EditorContentURL(pDocHref);
		            }
		        }
		    }
		
		    function SetSusinState() {
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
		        return getNodeText(GetChildNodes(loadXMLString(xmlhttp.responseText))[0]); */
		        
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
		    }
		
		    function FieldsAvailable() {
		        setAttachInfo(pDocID, "END", lstAttachLink);
		        GetExchInfo();
		        
		        if ((attachxml.length > 0) && (attachxsl.length > 0)) {
		            btnXMLEdit.style.display = "";
		            attachxmlPath = "/Upload_ApprovalG/" + companyID + "/sendXML/" + attachxml;
		            attachxmlName = attachxml.replace(PackDocID, "");
		            attachxslPath = "/Upload_ApprovalG/" + companyID + "/sendXML/" + attachxsl;
		            attachxslName = attachxsl.replace(PackDocID, "");
		        }
		        
		        var Rtnval = CheckOpinionInfo();
		        
		        if (Rtnval) {
		            var pInformationContent = "<spring:message code = 'ezApprovalG.t9' /><br> <spring:message code = 'ezApprovalG.t170' />";
		            OpenInformationUI(pInformationContent, FieldsAvailable_Complete);
		        }
		    }
		
		    function FieldsAvailable_Complete(Ans) {
		        if (Ans) {
		            btnOpinion_onclick();
		        }
		    }
		
		    function CheckOpinionInfo() {
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
		
		    var aprendopinion_dialogArgument = new Array();
		    function btnOpinion_onclick() {
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = "Show";
		
		        aprendopinion_dialogArgument[0] = parameter;
		        aprendopinion_dialogArgument[1] = openOpinionUI_Complete;
		        DivPopUpShow(530, 520, "/ezApprovalG/aprEndOpinion.do");
		    }
		    function openOpinionUI_Complete() {
		        DivPopUpHidden();
		    }
		
		    function btnSend_onclick() {
		        if (!stampFlag && !NostampFlag) {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t186' />";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        var pInformationContent = "<spring:message code = 'ezApprovalG.t187' />";
		        OpenInformationUI(pInformationContent, btnSend_onclick_Information);
		    }
		
		    function btnSend_onclick_Information(Ans) {
		        if (!Ans) {
		        	DivPopUpHidden();
		        	return;
		        }
		        
		    	//if ("${approvalPWD}" != "N") {
		    	if (CheckUsePassword()) {
		            chk_Passwd(pUserID, chk_Passwd_Complete);
		        } else {
		        	btnSend_onclick_Complete()
		        }
		    }
		
		    function btnSend_onclick_Complete() {
		        var rMatch = SaveFile();
		        if (rMatch == "SUCCESS") {
		            var rtnVal = SetSusinState();
		            if (rtnVal == "TRUE") {
		                var pAlertContent = "<spring:message code = 'ezApprovalG.t188' />";
		                OpenAlertUI(pAlertContent);
		                setBtnDisable();
		            }
		            else {
		                var pAlertContent = "<spring:message code = 'ezApprovalG.t189' />";
		                OpenAlertUI(pAlertContent);
		            }
		        }
		        else {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t189' />";
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
		        /* var xmlhttp = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var mhtBody = "";
		        mhtBody = message.Get_EditorBodyHTML()
		        mhtBody = ConvertHTMLtoMHT(mhtBody);
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
		        createNodeAndInsertText(xmlpara, objNode, "Html", mhtBody);
		        xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/saveEndFile.aspx", false);
		        xmlhttp.send(xmlpara);
		        return xmlhttp.responseText; */
		        
		        var result = "";
		    	var mhtBody = "";
		        mhtBody = message.Get_EditorBodyHTML();
		        mhtBody = "<HTML>" + mhtBody + "</HTML>";
		        mhtBody = ConvertHTMLtoMHT(mhtBody);
		    	
		    	var data = {
	    			docID : pDocID,
	    			html  : mhtBody
		    	}
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/saveEndFile.do",
		    		contentType : "application/json",
		    		data : JSON.stringify(data),
		    		success: function(xml){
		    			result = xml;
		    		}
		    	});
		        
		        return result;
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
		        var strimg;
		        var fields = message.GetFieldsList();
		        var field;
		        field = message.GetListItem(fields, "sealsign");
		        if (!field) {
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t190' /><br><spring:message code = 'ezApprovalG.t191' />";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		
		        if (!stampFlag) {
		            var DeptSealXML = GetDeptSealInfo();
		            var CompSealXML = GetSealInfo();
		            if (SelectNodes(DeptSealXML, "ROWS/ROW").length > 0 && SelectNodes(CompSealXML, "ROWS/ROW").length > 0) {
		                var pInformationContent = "<spring:message code = 'ezApprovalG.t192' /><BR><spring:message code = 'ezApprovalG.t193' />";
		                var Ans = OpenInformationUI(pInformationContent);
		                if (!Ans)
		                    SealXML = CompSealXML;
		                else
		                    SealXML = DeptSealXML;
		            }
		            else if (SelectNodes(DeptSealXML, "ROWS/ROW").length <= 0 && SelectNodes(CompSealXML, "ROWS/ROW").length <= 0) {
		                var pAlertContent = "<spring:message code = 'ezApprovalG.t194' /><br><spring:message code = 'ezApprovalG.t195' />";
		                    OpenAlertUI(pAlertContent);
		                    return;
		                }
		                else if (SelectNodes(DeptSealXML, "ROWS/ROW").length > 0) {
		                    SealXML = DeptSealXML;
		                }
		                else if (SelectNodes(CompSealXML, "ROWS/ROW").length > 0) {
		                    SealXML = CompSealXML;
		                }
		            var SealHref = getNodeText(SelectNodes(SealXML, "ROWS/ROW/CELL")[0].getElementsByTagName("DATA2")[0]);
		            var SealWidth = getNodeText(GetChildNodes(SelectNodes(SealXML, "ROWS/ROW/CELL")[1])[0]);
		            var SealHeight = getNodeText(GetChildNodes(SelectNodes(SealXML, "ROWS/ROW/CELL")[2])[0]);
		            field = message.GetListItem(fields, "sealsign");
		            if (field) {
		                var signWidth = getPixel(SealWidth) + "px";
		                var signHeight = getPixel(SealHeight) + "px";
		                /* strimg = "<img src='" + pDomainName + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(SealHref) + "' border=0 embedding='1' "; */
		                strimg = "<img src='" + encodeURI(SealHref) + "' border=0 embedding='1' ";
		                strimg = strimg + " width=" + signWidth;
		                strimg = strimg + " height=" + signHeight + ">";
		                var field2 = message.GetListItem(fields, "chief");
		                var chiefwidth = 1;
		                if (field2) {
		                    chiefwidth = parseInt(field2.offsetWidth);
		                    field2.height = signHeight;
		                }
		                var sealwidth = (maxwidth + chiefwidth) / 2 - 30;
		                var field2 = message.GetListItem(fields, "sealwidth");
		                if (field2)
		                    field2.width = sealwidth;
		                var field2 = message.GetListItem(fields, "noseal");
		                if (field2) {
		                    field2.width = (maxwidth - sealwidth - getPixel(SealWidth));
		                    field2.innerHTML = " ";
		                    NostampFlag = false;
		                }
		                field.width = getPixel(SealWidth);
		                field.height = getPixel(SealHeight);
		                field.innerHTML = strimg;
		
		                field.setAttribute("surl", SealHref)
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
		    function getPixel(pLength) {
		        try {
		            var tempLength = parseInt(pLength);
		            tempLength = tempLength * 7 / 2;
		            return tempLength;
		
		        } catch (e) {
		            return 30;
		        }
		    }
		
		    function btnNoStamp_onclick() {
		        var strimg;
		        var fields = message.GetFieldsList();
		        var field;
		        field = message.GetListItem(fields, "sealsign");
		        if (!field) {
		            NostampFlag = true;
		            var pAlertContent = "<spring:message code = 'ezApprovalG.t190' /><br><spring:message code = 'ezApprovalG.t196' />";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        if (!NostampFlag) {
		            var SealHref = "/files/sealImg/nostamp.gif"
		            var SealWidth = 30;
		            var SealHeight = 30;
		            field = message.GetListItem(fields, "sealsign");
		            if (field) {
		                var signWidth = getPixel(SealWidth) + "px";
		                var signHeight = getPixel(SealHeight) + "px";
// 		                strimg = "<img src='" + pDomainName + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(SealHref) + "' border=0 embedding='1' >";
		                strimg = "<img src='" + encodeURI(SealHref) + "' border=0 embedding='1' >";
		                var field2 = message.GetListItem(fields, "chief");
		                var chiefwidth = 1;
		                if (field2) {
		                    chiefwidth = parseInt(field2.offsetWidth);
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
		                field.setAttribute("surl", SealHref)
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
	
	<body class="popup" style="height: 100%;">
	    <table class="layout">
	        <tr>
	            <td style="height: 20px;">
	                <div id="menu">
	                    <ul>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code = 'ezApprovalG.t55' /></span></li>
	                        <li id="btnStamp"><span onclick="return btnStamp_onclick()"><spring:message code = 'ezApprovalG.t197' /></span></li>
	                        <li id="btnNoStamp"><span onclick="return btnNoStamp_onclick()"><spring:message code = 'ezApprovalG.t198' /></span></li>
	                        <li id="btnSend"><span onclick="return btnSend_onclick()"><spring:message code = 'ezApprovalG.t199' /></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code = 'ezApprovalG.t60' /></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li><span id="btnClose" onclick="return btnClose_onclick()"></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="padding-bottom: 10px; height: 90%">
                    <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" src="/ezApprovalG/enforceContent.do" name="message" frameborder="0" style="margin: 0px; padding: 0px; width: 99.8%; height: 99.7%; overflow: hidden;"></iframe>
	            </td>
	        </tr>
	        <tr>
	            <td style="height: 20px;">
	                <table class="file">
	                    <tr>
	                        <th><spring:message code = 'ezApprovalG.t65' /></th>
	                        <td>
	                            <div id="lstAttachLink"></div>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
	    <script type="text/javascript">
	        selToggleList(document.getElementById("menu"), "ul", "li", "0");
	    </script>
	</body>
</html>
