<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<title><spring:message code='ezApprovalG.t257'/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_HWP.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezSimsaG_Cross.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezSimsaG_HWP.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
    <script type="text/javascript">
    	var pDocID = "<c:out value = '${docID}'/>";
    	var pDocHref = "<c:out value = '${docHref}'/>";
    	var pOrgDocID = "<c:out value = '${orgDocID}'/>";
        var pUserID;
        var flag = false;
        var flag2 = false;
        var stampFlag = false;
        var NostampFlag = false;
        var modeflag = false;
        var companyID = "<c:out value = '${userInfo.companyID}'/>";
	    var companyName = "<c:out value = '${userInfo.companyName}'/>";
        var maxwidth = 659;
        var arr_userinfo = new Array();
        arr_userinfo[0]  = "user";
	    arr_userinfo[1]  = "<c:out value = '${userInfo.id}'/>";
	    arr_userinfo[2]  = "<c:out value = '${userInfo.displayName}'/>";
	    arr_userinfo[3]  = "<c:out value = '${userInfo.title}'/>";
	    arr_userinfo[4]  = "<c:out value = '${userInfo.deptID}'/>";
	    arr_userinfo[5]  = "<c:out value = '${userInfo.deptName}'/>";
	    arr_userinfo[6]  = "<c:out value = '${userInfo.jikChek}'/>";
	    arr_userinfo[8]  = "<c:out value = '${userInfo.email}'/>";
	    arr_userinfo[9]  = companyID;
	    arr_userinfo[11]  = "<c:out value = '${userInfo.displayName}'/>";
	    arr_userinfo[12]  = "<c:out value = '${userInfo.displayName2}'/>";
	    arr_userinfo[13]  = "<c:out value = '${userInfo.title1}'/>";
	    arr_userinfo[14]  = "<c:out value = '${userInfo.title2}'/>";
	    arr_userinfo[15]  = "<c:out value = '${userInfo.deptName1}'/>";
	    arr_userinfo[16]  = "<c:out value = '${userInfo.deptName2}'/>";
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
        var pUse_Editor = "<c:out value = '${useEditor}'/>";
        var approvalRoot = "<c:out value = '${approvalRoot}'/>";
        var ext = "hwp";
        var orgCompanyID = "<c:out value='${orgCompanyID}' />";
        var docTitle = "";
        
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
            var parameter = pUserID
            var url = "/ezApprovalG/ezchkPasswd.do";
            var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
            var ret = window.showModalDialog(url, parameter, feature);
            return ret
        }

        function window_onload() {
            try {
                window.onresize();
                HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
                HwpCtrl.SetSaveMode(1);

                if (pDocHref != "") { 
                    showProgress("<spring:message code='ezApprovalG.t368'/>");
                    var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(pDocHref);
                    var isTrue = HwpCtrl.LoadFile(URL, false);
                    FieldsAvailable(isTrue);
                }

                HwpCtrl.SetFieldFocus("doctitle");
                HwpCtrl.ezSetScrollPosInfo(0);

            } catch (e) {
                alert("<spring:message code='ezApprovalG.t1373'/>" + e.description);
                hideProgress();
            }
        }

        window.onresize = function () {
            HwpCtrl.style.height = null;
            HwpCtrl.height = document.documentElement.clientHeight - 150;
        }

        function setArrAttachInfo() {
            try {
            	var result = "";
            	$.ajax({
            		type : "POST",
            		dataType : "text",
            		async : false,
            		url : "/ezApprovalG/getTotalAttachInfo.do",
            		data : {
            			docID : pOrgDocID,
            			mode : "END"
            		},
            		success: function(xml){
            			result = xml;
            		}        			
            	});

                var xmldom = createXmlDom();

                xmldom =loadXMLString(result);
                var xmlRtn = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");

                if (xmlRtn.length > 0) {
                    var strAttach = " &nbsp ";
                    var rep = /'/g
                    for (i = 0; i < xmlRtn.length; i++) {
                    	 var Row = xmlRtn[i];
                         var Cell = GetChildNodes(Row);

                         if (SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA4") == "File" || SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA4") == strLang1136 || SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA4").toLowerCase().indexOf("file") > -1) {
                            attachName[i] = SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA5");
                            var SeqNum = escapenew(SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA2"));
                            attachPath[i] = SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA1");
                            attachType[i] = "N";
                        }
                    }
                }
            } catch (e) {
                alert("ezsimsag_hwp.do.setArrAttachInfo()" + e.description);
            }
        }

        function FieldsAvailable(isTrue) {
            try {
                if (isTrue) {

                    ObjGPKI.ServerName = "ldap.gcc.go.kr";

                    setAttachInfo(pOrgDocID, "END", lstAttachLink);
                    setArrAttachInfo();
                    GetAprDeptXML();
                    GetExchInfo();

                    if ((attachxml.length > 0) && (attachxsl.length > 0)) {
                        btnXMLEdit.style.display = "";
                        attachxmlPath = "/Upload_ApprovalG/" + companyID + "/sendXML/" + attachxml;
                        attachxmlName = attachxml.replace(PackDocID, "");
                        attachxslPath = "/Upload_ApprovalG/" + companyID + "/sendXML/" + attachxsl;
                        attachxslName = attachxsl.replace(PackDocID, "");
                    }

                    hideProgress();

                    if (HwpCtrl.CheckFieldExist("sealsign")) {
                        var tmpSUrl = GetDocumentElement(HwpCtrl, "surl");

                        if (tmpSUrl != "") {
                            if (tmpSUrl == "/files/upload_approvalG/sealImg/nostamp.gif")
                                NostampFlag = true;
                            else
                                stampFlag = true;
                        }
                    }
                    HwpCtrl.SetImgReg();
                } else {
                    hideProgress(); 
                    var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
                    OpenAlertUI(pAlertContent);
                    HwpCtrl.ClearDocument();
                }
            } catch (e) {
                alert("ezsimsag_hwp.FieldsAvailable()" + e.description);
            }
        }

        function btnSetReceivLine_onclick() {
        	var url = "/ezApprovalG/ezReceiptInfo.do?docID=" + pDocID + "&ext=" + ext;
            var feature = "status:no;dialogWidth:540px;dialogHeight:230px;help:no;scroll:no;edge:sunken";
            var ret = window.showModalDialog(url, "", feature);
        }

        function btnOpinion_onclick() {
            var parameter = new Array();
            parameter[0] = pOrgDocID;
            parameter[1] = "Show";

            var url = "/myoffice/ezApprovalG/formContainer/AprEndOpinion.aspx";
            var feature = "status:no;dialogWidth:387px;dialogHeight:304px;scroll:no;edge:sunken"
            var ret = window.showModalDialog(url, parameter, feature);
        }

        function btnSend_onclick() {
            try {
                if (!stampFlag && !NostampFlag) {
                    var pAlertContent = "<spring:message code='ezApprovalG.t216'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }
                
                var pInformationContent = "<spring:message code='ezApprovalG.t205'/>";
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
                
                SaveFile();

                var rtnVal = "FALSE";
                if (isExternal) {
                    if (isAddress) {
                        rtnVal = SetContainer();
                    } else {
                        is_Enc = OpenCheckUI();
                        if (sendExt()) {
                            rtnVal = SetContainer();
                        }
                    }
                } else {
                    rtnVal = SetContainer();
                }

                if (rtnVal == "TRUE") {
                    HwpCtrl.SetFieldFocus("doctitle");

                    var pAlertContent = "<spring:message code='ezApprovalG.t206'/>";
                    OpenAlertUI(pAlertContent);
                    setBtnDisable();
                } else {
                    var pAlertContent = "<spring:message code='ezApprovalG.t217'/>";
                    OpenAlertUI(pAlertContent);
                }
            } catch (e) {
                alert("ezsimsag_hwp.btnSend_onclick()" + e.description);
        	}
        }

        function DeleteLocalFiles() {

            var ezUtil = new ActiveXObject("EzUtil.MiscFunc");

            for (var i = 0 ; i < arrDelFiles.length ; i++) {
                ezUtil.UseUTF8 = true;
                ezUtil.DeleteFile(arrDelFiles[i]);
            }

            ezUtil = null;
        }

        function btnBoard_onclick() {
            if (!stampFlag && !NostampFlag) {
                var pAlertContent =  "<spring:message code='ezApprovalG.t216'/>";
                OpenAlertUI(pAlertContent);
                return;
            }

            var pInformationContent = "<spring:message code='ezApprovalG.t218'/><br><spring:message code='ezApprovalG.t219'/>";
            var Ans = OpenInformationUI(pInformationContent);
            if (!Ans)
                return;

            SaveFile();

            var wWeight = "345";
            var wHeight = "660";

            var heigth = window.screen.availHeight;
            var width = window.screen.availWidth;

            var left = (width - wWeight) / 2;
            var top = (heigth - wHeight) / 2;
            var ret = window.showModalDialog("/ezBoard/writeBoardSelectModal.do", "",
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
                        window.open("/myoffice/ezBoardSTD/NewBoardItem.aspx?BoardID=" + pBoardID + "&Mod=New&pbrdGbn=SiteNewBoard&pFromScreen=Mail&DocID=" + pOrgDocID + "&Url=" + pDocHref, '', 'height=720,width=765,resizable=yes,scrollbars=no' + GetOpenPosition(765, 720));
                    }
                    else {
                        window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + pDocHref, '', "top=" + pTop.toString() + ", left=" + pLeft.toString() + ',height=870,width=765,scrollbars=no');
                    }
                }
            }
        }

        function btnReject_onclick() {
            var pInformationContent =  "<spring:message code='ezApprovalG.t36'/>";
            var Ans = OpenInformationUI(pInformationContent);
            if (!Ans) return;

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

            //var ret = openOpinionUI("BanSong");
            var ret = openOpinionUI_New("BanSong");
            if (ret != "cancel" && ret != undefined) {
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
		    		}, error: function () {
		    			 var pAlertContent = "<spring:message code='ezApprovalG.t258'/>";
			                OpenAlertUI(pAlertContent);
		    		}        			
		    	});
	    		
	            var ResultXML = result;
	            if (getNodeText(GetChildNodes(ResultXML)[0]) == "TRUE") {
	            	if (HwpCtrl.CheckFieldExist("doctitle")) {
	            		docTitle = HwpCtrl.GetFieldText("doctitle");
	            	}

	            	//여기다 발송의뢰반송 메일알람 추가
	                SendSimsaBansong(docTitle);
	                var pAlertContent = "<spring:message code='ezApprovalG.t256'/>";
	                OpenAlertUI(pAlertContent);
	                setBtnDisable();
	            } else {
	            	 var pAlertContent = "<spring:message code='ezApprovalG.t258'/>";
	                    OpenAlertUI(pAlertContent);
	                    setMenuDisable("btnSend", false);
	            }
            }
        }

        function openOpinionUI(ret) {
            var parameter = new Array();
            parameter[0] = pDocID;
            parameter[1] = ret;
            parameter[2] = "002";
            parameter[3] = pOrgDocID;
            //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
            parameter[99] = "hwp";
            
            var url = "/ezApprovalG/aprOpinion.do";
            var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no;help:no"
            var ret = window.showModalDialog(url, parameter, feature);
            return ret;
        }
        
        function openOpinionUI_New(pOpinionType) {
        	try {
        		var parameter = new Array();
        		parameter[0] = pDocID;		//DOCID
        		parameter[1] = pOpinionType;//OPINIONTYPE NAME
        		parameter[2] = "";			//DRAFTFLAG 
        		parameter[3] = "";			//DOCSTATE
        		parameter[4] = orgCompanyID;//ORGCOMPANYID
        		parameter[99] = ext;		//EXT
        		
        		var url = "/ezApprovalG/aprOpinionNew.do";
        		var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
        		var ret = window.showModalDialog(url,parameter,feature);
        		
        	    return ret;
        	} catch (e) {
        		alert("openOpinionUI_New ::: " + e.description);
        	}
        }

        function SuccessBoard() {
            var rtnVal = SetContainer();
            if (rtnVal == "TRUE") {
                var pAlertContent =  "<spring:message code='ezApprovalG.t211'/>";
                OpenAlertUI(pAlertContent);
                setBtnDisable();
            } else {
                var pAlertContent =  "<spring:message code='ezApprovalG.t220'/>";
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
	    		} , error: function() {
	    			return "FALSE";
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
			var result = "";
			
			var data = {
	    			docID : pOrgDocID,
	    			// formId : pFormID,
	    			html  : HwpCtrl.GetCloneData("", "HWP")
				}
				
		    $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/saveEndFileHwp.do",
		    		contentType : "application/json",
		    		data : JSON.stringify(data),
		    		success: function(xml){
		    			result = xml;
		    		}        			
		    	});
			
	        var reqData = {
    			docID : pDocID,
                   // formId : pFormID,
    			html  :  HwpCtrl.GetCloneData("", "HWP")
        	}
	        
	        $.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		url : "/ezApprovalG/saveFileHWP.do",
	    		contentType : "application/json",
	    		data : JSON.stringify(reqData),
	    		success: function(text){
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

	    function GetDeptSealInfo() {
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
                var pAlertContent =  "<spring:message code='ezApprovalG.t201'/><br><spring:message code='ezApprovalG.t191'/>";
                OpenAlertUI(pAlertContent);
                return;
            }

            if (!stampFlag) {
                var DeptSealXML = GetDeptSealInfo();
                var CompSealXML = GetSealInfo();

                if (SelectNodes(DeptSealXML, "ROWS/ROW").length > 0 && SelectNodes(CompSealXML, "ROWS/ROW").length > 0) {
                    var pInformationContent = "<spring:message code='ezApprovalG.t192'/><BR><spring:message code='ezApprovalG.t193'/>";
                    var Ans = OpenInformationUI(pInformationContent);
                    if (!Ans) {
                        SealXML = CompSealXML;
                    } else {
                        SealXML = DeptSealXML;
                    }
                } else if (SelectNodes(DeptSealXML, "ROWS/ROW").length <= 0 && SelectNodes(CompSealXML, "ROWS/ROW").length <= 0) {
                    var pAlertContent =  "<spring:message code='ezApprovalG.t194'/><BR><spring:message code='ezApprovalG.t195'/>";
                        OpenAlertUI(pAlertContent);
                        return;
                } else if (SelectNodes(DeptSealXML, "ROWS/ROW").length > 0) {
                    SealXML = DeptSealXML;
                } else if (SelectNodes(CompSealXML, "ROWS/ROW").length > 0) {
                    SealXML = CompSealXML;
                }

                var SealHref = getNodeText(SelectNodes(SealXML, "ROWS/ROW/CELL")[0].getElementsByTagName("DATA2")[0]);
	            var SealWidth = parseInt(getNodeText(GetChildNodes(SelectNodes(SealXML, "ROWS/ROW/CELL")[1])[0]));
	            var SealHeight = parseInt(getNodeText(GetChildNodes(SelectNodes(SealXML, "ROWS/ROW/CELL")[2])[0]));

                if (HwpCtrl.CheckFieldExist("sealsign")) {
                    HwpCtrl.SetFieldText("sealsign", "");
                    HwpCtrl.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(SealHref), 6);
                    SetDocumentElement(HwpCtrl, "surl", SealHref);
                    SetDocumentElement(HwpCtrl, "swidth", SealWidth);
                    SetDocumentElement(HwpCtrl, "sheight", SealHeight);
                    stampFlag = true;
                    NostampFlag = false;
                }
            } else {
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
                var pAlertContent =  "<spring:message code='ezApprovalG.t201'/><BR><spring:message code='ezApprovalG.t191'/>";
                OpenAlertUI(pAlertContent);
                return;
            }

            if (!NostampFlag) {
                var SealHref = "/files/sealImg/nostamp.gif"
                var SealWidth = 30;
                var SealHeight = 10;

                if (HwpCtrl.CheckFieldExist("sealsign")) {
                    HwpCtrl.SetFieldText("sealsign", "");
                    HwpCtrl.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(SealHref), 6);
                    NostampFlag = true;
                    SetDocumentElement(HwpCtrl, "surl", SealHref);


                    SetDocumentElement(HwpCtrl, "swidth", SealWidth);
                    SetDocumentElement(HwpCtrl, "sheight", SealHeight);
                }
            } else {
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

        function PixelToMillimeter(size) {
            var Num;
            if (size.indexOf("mm") > -1) {
                Num = size;
            }
            else {
                Num = parseInt(size);
                try {
                    Num = (Num * 0.264583).toPrecision(5);
                } catch (e) {
                    alert(e.description);
                }
            }
            return Num;
        }

        function PointToMillimeter(strPoint) {
            var mmResult;
            if (strPoint.indexOf("mm") > -1) {
                mmResult = strPoint;
            }
            else {
                var mmResult = parseInt(strPoint);
                try {
                    //mmResult = (mmResult * 0.35277777).toPrecision(5);
                    mmResult = (mmResult * 0.264583).toPrecision(5);
                } catch (e) {
                    alert(e.description);
                }
            }
            return mmResult;
        }

        function Encode(text) {
            try {
                /* var xmlhttp = createXMLHttpRequest();
                var xmlpara = createXmlDom();
                var objNode;

                createNodeInsert(xmlpara, objNode, "PARAMETER");
                createNodeAndInsertText(xmlpara, objNode, "DEFAULTFONTFAMILY", "");
                createNodeAndInsertText(xmlpara, objNode, "DEFAULTFONTSIZE", "");
                createNodeAndInsertText(xmlpara, objNode, "CONTENT", text);
                xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/GetContentXml.aspx", false);
                xmlhttp.send(xmlpara); */
                $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getContentXml.do",
		    		data : {
		    			fontFamily : "",
		    			fontSize : "",
		    			content : text,
		    			docType : "HWP"
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}     			
		    	});
                
                var Content = document.createElement("DIV");
                //var pTemp = xmlhttp.responseXML;
				var pTemp = result;	
                
                if (getNodeText(pTemp.getElementsByTagName("RESULT")[0]) === "OK") {
                    Content.innerHTML = getNodeText(pTemp.getElementsByTagName("CONTENT")[0]);
                }
                else {
                    alert(getNodeText(pTemp.getElementsByTagName("CONTENT")[0]));
                    return "";
                }

                // 태그는 GetContentXml페이지에서 처리하여 리턴되므로 Element의 Attribute중 필요없는 것만 제거한다.
                var ElementsRows = Content.getElementsByTagName("*");
                var ArrAttr = null;
                for (var Cnt = 0; Cnt < ElementsRows.length; Cnt++) {
                    switch (ElementsRows.item(Cnt).tagName) {
                        case "SUB":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "SUP":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "I":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "B":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "U":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "P":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "style":
                                    case "align":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }

                            var LastTag = ElementsRows.item(Cnt).outerHTML.substring(ElementsRows.item(Cnt).outerHTML.length - 4).toUpperCase();
                            if (LastTag != "</P>")
                                ElementsRows.item(Cnt).outerHTML = ElementsRows.item(Cnt).outerHTML + "</P>";
                            break;
                        case "UL":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "OL":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "LI":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "A":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "name":
                                    case "href":
                                    case "rel":
                                    case "rev":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "IMG":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "src":
                                    case "alt":
                                    case "name":
                                    case "longdesc":
                                    case "height":
                                    case "height_kaoni":
                                    case "width":
                                    case "width_kaoni":
                                    case "align":
                                    case "border":
                                    case "hspace":
                                    case "vspace":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "TABLE":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "summary":
                                    case "style":
                                    case "width":
                                    case "width_kaoni":
                                    case "height":
                                    case "height_kaoni":
                                    case "border":
                                    case "cellspacing":
                                    case "cellpadding":
                                    case "align":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "CAPTION":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "align":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "COLGROUP":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "span":
                                    case "width":
                                    case "width_kaoni":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "COL":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "span":
                                    case "width":
                                    case "width_kaoni":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "THEAD":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "style":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "TFOOT":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "style":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "TBODY":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "style":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "TR":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "style":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "TH":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "style":
                                    case "abbr":
                                    case "axis":
                                    case "headers":
                                    case "scope":
                                    case "rowspan":
                                    case "colspan":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                    case "nowrap":
                                    case "width":
                                    case "width_kaoni":
                                    case "height":
                                    case "height_kaoni":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                        case "TD":
                            ArrAttr = ElementsRows.item(Cnt).attributes;
                            for (var AttrIdx = 0; AttrIdx < ArrAttr.length; AttrIdx++) {
                                switch (ArrAttr[AttrIdx].name.toLowerCase()) {
                                    case "id":
                                    case "class":
                                    case "style":
                                    case "abbr":
                                    case "axis":
                                    case "headers":
                                    case "scope":
                                    case "rowspan":
                                    case "colspan":
                                    case "align":
                                    case "char":
                                    case "charoff":
                                    case "valign":
                                    case "nowrap":
                                    case "width":
                                    case "width_kaoni":
                                    case "height":
                                    case "height_kaoni":
                                        break;
                                    default:
                                        ElementsRows.item(Cnt).removeAttribute(ArrAttr[AttrIdx].name);
                                        break;
                                }
                            }
                            break;
                    }
                }

                var rtnVal = Content.innerHTML.replace(/width_kaoni/g, "width").replace(/height_kaoni/g, "height");
                rtnVal = rtnVal.replace(/\r/g, "").replace(/\n/g, "").replace(/&nbsp; /g, "&nbsp;&nbsp;");
                
                var nodeText = getNodeText(pTemp.getElementsByTagName("CONTENT")[0]);
                nodeText = nodeText.replace(/width_kaoni/g, "width").replace(/height_kaoni/g, "height");
                nodeText = nodeText.replace(/\r/g, "").replace(/\n/g, "").replace(/&nbsp; /g, "&nbsp;&nbsp;");
                
                return nodeText;

                //return Content.innerHTML;
            } catch (e) {
                alert(e.description);
                return "</ERROR/>";
            }
        }

function GetHTMLBody(strHTML) {
    var objElem = document.createElement('div');
    try {
        objElem.innerHTML = strHTML;
        return objElem.innerHTML;
    } catch (e) {
        alert(e.description);
        return objElem.innerHTML;
    }
}

function PercentToMillimeter(strFontSize, strPercent) {
    var num1 = parseInt(strFontSize).toPrecision(5);
    var num2 = parseInt(strPercent).toPrecision(5);
    try {
        //var result = (((num1 * num2) * 0.352777778) / 100).toPrecision(5);
        var result = (((num1 * num2) * 0.264583) / 100).toPrecision(5);
        return result;
    } catch (e) {
        alert(e.description);
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
<body class="popup" onload="return window_onload()" style="overflow: hidden" onbeforeunload="return window_onbeforeunload()">
    <object id="oPoster" classid="clsid:19E224CA-6992-425C-8006-8FA6FD2BD9E5" style="DISPLAY: none; HEIGHT: 86px; WIDTH: 243px" viewastext>
    </object>
    <object classid="clsid:80009476-666B-4869-8C04-AB03492561CD" id="ObjGPKI" style="DISPLAY: none; HEIGHT: 86px; WIDTH: 243px" viewastext>
    </object>
    <table class="layout">
        <tr>
            <td height="20">
                <div id="menu">
                    <ul>
                        <li id="btnOpinion" style="display: none"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApprovalG.t55'/></span></li>
                        <li id="btnSetReceivLine"><span onclick="return btnSetReceivLine_onclick()"><spring:message code='ezApprovalG.t53'/></span></li>
                        <li id="btnStamp"><span onclick="return btnStamp_onclick()"><spring:message code='ezApprovalG.t213'/></span></li>
                        <li id="btnNoStamp"><span onclick="return btnNoStamp_onclick()"><spring:message code='ezApprovalG.t222'/></span></li>
                        <li id="btnSend"><span onclick="return btnSend_onclick()"><spring:message code='ezApprovalG.t214'/></span></li>
                        <li id="btnBoard"><span onclick="return btnBoard_onclick()"><spring:message code='ezApprovalG.t215'/></span></li>
                        <li id="btnReject"><span onclick="return btnReject_onclick()"><spring:message code='ezApprovalG.t49'/></span></li>
                        <li id="btnPrint"><span class='icon16 popup_icon16_print' onclick="return btnPrint_onclick()"></span></li>
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
                    <script language='JavaScript'>ezHwpCtrl_ActiveX("HwpCtrl", "3", "0", "<c:out value = '${hwpToolbar}'/>", "");</script>
                </div>
            </td>
        </tr>
        <tr>
            <td height="20">
	                <table class="file" style="height:80px;">
	                    <tr>
	                        <th id="btn_Attach"><spring:message code='ezApprovalG.t65'/></th>
	                        <td style="width:62%; border-right:1px; solid #d5d5d5; overflow: auto;">
	                            <div id="lstAttachLink" style="height:70px;"></div>
	                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
	                        </td>
	                        <td style="width:30%; overflow: auto;">
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
