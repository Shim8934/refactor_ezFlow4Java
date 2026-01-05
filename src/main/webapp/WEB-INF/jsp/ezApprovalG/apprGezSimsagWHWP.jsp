<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <c:choose>
        <c:when test="${isConvSihang}">
            <title>시행문변환</title>
        </c:when>
        <c:otherwise>
            <title><spring:message code='ezApprovalG.t257'/></title>
        </c:otherwise>
    </c:choose>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_WHWP.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezSimsaG_Cross.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezSimsaG_WHWP.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendOffer_Cross.js')}"></script>
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
        var SaveHtml = "";
        var isConvSihang = ${isConvSihang};
        var HtmlBody = "";
        var useWebHWP = "<c:out value ='${useWebHWP}'/>";
        
        // 대용량첨부 관련
        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";
        
        var isSihangReject = "N"; // 시행문변환 시 반송을 위한 구분값 전달
        var pRecordID = "<c:out value = '${recordID}'/>";
        var approvalFlag = "<c:out value = '${approvalFlag}'/>";
        var pFormURL = "<c:out value = '${pFormURL}'/>";

		// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
		var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";
		
        function btnPrint_onclick() {
        	message.PrintDocument();
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
        
        var ezapropinion_cross_dialogArguments = new Array();
        function OpenInformationUI(pInformationContent, CompleteFunction, pType) {
            var parameter = pInformationContent;
            var url = "/ezApprovalG/ezAprOpinion.do?type=" + pType;
            //var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
            //var RtnVal = window.showModalDialog(url, parameter, feature);
            //return RtnVal;
            
            ezapropinion_cross_dialogArguments[0] = parameter;
            if (CompleteFunction != undefined)
                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
            else
                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
            DivPopUpShow(330, 205, url);
        }
        
        function OpenInformationUI_Complete() {
            DivPopUpHidden();
        }

        var ezapralert_cross_dialogArguments = new Array();
        function OpenAlertUI(pAlertContent, CompleteFunction) {
            var parameter = pAlertContent;
            var url = "/ezApprovalG/ezAprAlert.do";
            //var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
            //var RtnVal = window.showModelessDialog(url, parameter, feature);
            
            ezapralert_cross_dialogArguments[0] = parameter;
    		if (CompleteFunction != undefined)
    			ezapralert_cross_dialogArguments[1] = CompleteFunction;
    		else
    			ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
    		DivPopUpShow(330, 205, url);
        }
        
        function OpenAlertUI_Complete() {
            DivPopUpHidden();
        }

        var ezchkpasswd_cross_dialogArguments = new Array();
        function chk_Passwd(pUserID, CompleteFunction) {
            var parameter = pUserID
            ezchkpasswd_cross_dialogArguments[0] = parameter;
            
            var url = "/ezApprovalG/ezchkPasswd.do";
            //var feature = "status:no;dialogWidth:330px;dialogHeight:200px;help:no;scroll:no;edge:sunken";
            //var ret = window.showModalDialog(url, parameter, feature);
            //return ret
            
            if (CompleteFunction != undefined)
            	ezchkpasswd_cross_dialogArguments[1] = CompleteFunction;
            else
            	ezchkpasswd_cross_dialogArguments[1] = chk_Passwd_Complete;
            DivPopUpShow(330, 200, url);
        }
        
        function chk_Passwd_Complete(ret) {
        	DivPopUpHidden();
        	
        	var chkpass = ret;
        	if (chkpass == "False") {
                var pAlertContent = "<spring:message code='ezApprovalG.t1383'/>";
                OpenAlertUI(pAlertContent);
                return;
            } else if (chkpass == "cancel" || chkpass == undefined) {
                var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
                OpenAlertUI(pAlertContent);
                return;
            }
        	
        	GetHTML(Send_OpenUI2);
        }

        function window_onload() {
            try {
                window.onresize();
                
                if (isConvSihang && approvalFlag == "G") {
                    setMenuDisable("btnOpinion", true);
                    isSihangReject = "Y"; // 시행문변환으로 접근 시 반송 관련 플래그 설정
                }
                if(approvalFlag == "G")
                    setMenuDisable("btnReject", true); // 시행문변환으로 접근해도 반송이 가능하도록 수정

				// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
				setAttachGuideText();
            } catch (e) {
                alert("<spring:message code='ezApprovalG.t1373'/>" + e.description);
                hideProgress();
            }
        }

        window.onresize = function () {
        	var mHeight = document.documentElement.clientHeight - 172 - document.getElementById("message").offsetTop + "px";
       		message.Resize(mHeight);
        }
        
        function Editor_Complete() {
        	showLoadingProgress();

        	if(approvalFlag == "G"){
                if (pDocHref != "") {
                    var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pDocHref);
                    message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
                }
        	}else{
                var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pFormURL);
                message.Open(URL, "", "", function (res) { Insert_Content(res.result) }, null);
        	}
        }

        function Editor_Complete2() {
        }

        function Insert_Content() {
            var URL;
            URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(pDocHref);
            message2.Open(URL, "", "", function (res) { CopyAndPasteContent(res.result) }, null);
        }

        function CopyAndPasteContent(isTrue) {
            try {
                message.EditMode(0);
                if(isTrue) {
                    var fieldList = message2.GetFieldList();
                    message2.GetCloneData("doctitle", "JSON", function (tempContent) { message.SetCloneData(tempContent, "doctitle", "JSON") });
                    message2.GetCloneData("body", "JSON", function (tempContent) { message.SetCloneData(tempContent, "body", "JSON") });
                    message.PutFieldText("docnumber", message2.GetFieldText("docnumber"));
                    message.PutFieldText("recipient", message2.GetFieldText("recipient"));
                    message.PutFieldText("recipients", message2.GetFieldText("recipients"));
                    var enforcedate = message2.GetFieldText("enforcedate");
                    if(trim(enforcedate) == ""){
                        enforcedate = GetDocInfoData("END", "ENDDATE").substring(0,10).replace("-",".").replace("-",".");
                    }
                    message.PutFieldText("enforcedate", enforcedate);
                    pOrgDocID = pDocID;
                    pDocID = CreateNewDoc(pDocID, pUserID);
                    pDocHref = pDocHref.substring(0,pDocHref.lastIndexOf("/"));
                    pDocHref = pDocHref.substring(0,pDocHref.lastIndexOf("/")) + "/" + Number(pDocID.substr(-3)) + "/" + pDocID + "." + ext;
                } else {
                    var pAlertContent = "<spring:message code='ezApprovalG.t1373'/>";
                    OpenAlertUI(pAlertContent);
                    message.Clear();
                }
                hideLoadingProgress();
            } catch (e) {
                alert("CopyAndPasteContent ::" + e);
            }
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
                	message.EditMode(0);
                    message.SetViewProperties(2, 100);
                	
                    ObjGPKI.ServerName = "ldap.gcc.go.kr";

                    if (isConvSihang) {
                        setAttachInfo(pDocID, "END", lstAttachLink);
                    } else {
                        setAttachInfo(pOrgDocID, "END", lstAttachLink);
                    }
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

                    hideLoadingProgress();

                    if (message.FieldExist("sealsign")) {
                        var tmpSUrl = GetDocumentElement("surl");

                        if (tmpSUrl != "") {
                            if (tmpSUrl == "/files/upload_approvalG/sealImg/nostamp.gif")
                                NostampFlag = true;
                            else
                                stampFlag = true;
                        }
                    }
                    //HwpCtrl.SetImgReg();
                } else {
                	hideLoadingProgress();
                    var pAlertContent = "<spring:message code='ezApprovalG.t369'/>";
                    OpenAlertUI(pAlertContent);
                    message.ClearDocument();
                }
            } catch (e) {
                alert("ezsimsag_hwp.FieldsAvailable()" + e);
            }
        }

        function btnSetReceivLine_onclick() {
            var convSihangParam = isConvSihang ? "&mode=END" : "";
            var url = "/ezApprovalG/ezReceiptInfo.do?docID=" + pDocID + "&ext=" + ext + convSihangParam;
            //var feature = "status:no;dialogWidth:540px;dialogHeight:230px;help:no;scroll:no;edge:sunken";
            //var ret = window.showModalDialog(url, "", feature);
            DivPopUpShow(720, 240, url);
        }

        var aprendopinion_dialogArgument = [];
        function btnOpinion_onclick() {
            var parameter = [];
            parameter[0] = pDocID;
            parameter[1] = "Show";
            parameter[2] = orgCompanyID;
    
            aprendopinion_dialogArgument[0] = parameter;
            aprendopinion_dialogArgument[1] = btnOpinion_onclick_Complete;

            DivPopUpShow(530, 520, "/ezApprovalG/aprEndOpinion.do");
        }
        function btnOpinion_onclick_Complete() {
            DivPopUpHidden();
        }

        function btnSend_onclick() {
            try {
                if (!stampFlag && !NostampFlag) {
                    var pAlertContent = "<spring:message code='ezApprovalG.t216'/>";
                    OpenAlertUI(pAlertContent);
                    return;
                }
                
                var pInformationContent = "<spring:message code='ezApprovalG.t205'/>";
                OpenInformationUI(pInformationContent, Send_OpenUI);
            } catch (e) {
                alert("ezsimsag_hwp.btnSend_onclick()" + e);
        	}
        }
            
        function Send_OpenUI(Ans) {
        	DivPopUpHidden();
        	
        	if (!Ans) return;
        	
        	if (CheckUsePassword()) {
                chk_Passwd(pUserID, chk_Passwd_Complete);
            } else {
        		GetHTML(Send_OpenUI2);
            }
        }
        
        function Send_OpenUI2(html) {
        	SaveHtml = html;
            var saveFileRtnVal = SaveFile();
            if (!saveFileRtnVal) {
                OpenAlertUI("문서 저장에 실패했습니다.");
                return;
            }
            
            if (message.FieldExist("body")) {
                message.GetCloneData("body", "HTML", before_SendExt);
            }
            else {
                before_SendExt("");
            }
        }
        
        function before_SendExt(pBody) {
        	HtmlBody = pBody;
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
            	message.MoveToField("doctitle");

                var pAlertContent = "<spring:message code='ezApprovalG.t206'/>";
                OpenAlertUI(pAlertContent);
                setBtnDisable();
            } else {
                var pAlertContent = "<spring:message code='ezApprovalG.t217'/>";
                OpenAlertUI(pAlertContent);
            }
        }

        function btnBoard_onclick() {
            if (!stampFlag && !NostampFlag) {
                var pAlertContent =  "<spring:message code='ezApprovalG.t216'/>";
                OpenAlertUI(pAlertContent);
                return;
            }

            var pInformationContent = "<spring:message code='ezApprovalG.t218'/><br><spring:message code='ezApprovalG.t219'/>";
            OpenInformationUI(pInformationContent, btnBoard_onclick_complete);

        }
        
        function btnBoard_onclick_complete(Ans) {
        	DivPopUpHidden();
        	if (!Ans)
                return;
        	
        	GetHTML(btnBoard_onclick_complete2);
        }

        var writeboardselect_modal_dialogArguments = new Array();
        function btnBoard_onclick_complete2(html) {
            SaveHtml = html;
            if(approvalFlag == "S")
                saveEndFile(pDocID, html);

            btnBoard_onclick_complete3();
        }
        
        /* 2021-04-30 홍승비 - 웹한글문서에서 결재문서 게시하는 경우, 한글 웹기안기 URL 리다이렉트 방지 (절대경로 URL 사용) */
        function btnBoard_onclick_complete3() {
            writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
            var openLocation = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezBoard/writeBoardSelectModal.do";
            var OpenWin = window.open(openLocation, "WriteBoardSelect_Modal", GetOpenWindowfeature(355, 600));
        }
        
        function NewItem_onclick_Complete(ret) {
            if (typeof (ret) != "undefined") {
                pBoardID = ret[0];

                if (pBoardID == "" || typeof (pBoardID) == "undefined") {
                    return;
                }

                var pheight = window.screen.availHeight;
                var pwidth = window.screen.availWidth;
                var pTop = (pheight - 720) / 2;
                var pLeft = (pwidth - 765) / 2;

                if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4" || ret[2] == "7" || ret[2] == "8") {
                    alert(strLang1031);
                }
                else {
                    window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + (approvalFlag == "S" ? pOrgDocID : pDocID) + "&url=" + pDocHref, '', "top=" + pTop.toString() + ", left=" + pLeft.toString() + ',height=870,width=765,scrollbars=no');
                }
            }
        }

        function btnReject_onclick() {
            var pInformationContent =  "<spring:message code='ezApprovalG.t36'/>";
            OpenInformationUI(pInformationContent, Reject_OpenUI);
        }
        
        function Reject_OpenUI(Ans) {
        	DivPopUpHidden();
            if (!Ans) return;

            if (CheckUsePassword()) {
	            chk_Passwd(pUserID, Reject_ChkPassword);
	        }
	        else {
	            //openOpinionUI("BanSong");
	        	openOpinionUI_New("BanSong");
	        }
        }
        
        function Reject_ChkPassword(chkpass) {
        	DivPopUpHidden();
        	
        	if (chkpass == "False") {
                var pAlertContent = "<spring:message code='ezApprovalG.t1383'/>";
                OpenAlertUI(pAlertContent);
                return;
            } else if (chkpass == "cancel" || chkpass == undefined) {
                var pAlertContent = "<spring:message code='ezApprovalG.t28'/>";
                OpenAlertUI(pAlertContent);
                return;
            }
            
        	openOpinionUI_New("BanSong");
        }

/*         function openOpinionUI(ret) {
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
        */
        
        var apropinion_cross_dialogArguments = new Array();
        function openOpinionUI_New(pOpinionType) {
        	try {
        		var parameter = new Array();
        		parameter[0] = pDocID;		//DOCID
        		parameter[1] = pOpinionType;//OPINIONTYPE NAME
        		parameter[2] = "";			//DRAFTFLAG 
        		parameter[3] = "";			//DOCSTATE
        		parameter[4] = orgCompanyID;//ORGCOMPANYID
        		parameter[99] = ext;		//EXT
        		
        		apropinion_cross_dialogArguments[0] = parameter;
    			apropinion_cross_dialogArguments[1] = openOpinionUI_Complete;
        		
        		var url = "/ezApprovalG/aprOpinionNew.do";
        		//var feature = "status:no;dialogWidth:530px;dialogHeight:520px;edge:sunken;scroll:no"
        		//var ret = window.showModalDialog(url,parameter,feature);
        		
        		DivPopUpShow(530, 520, url);
        	} catch (e) {
        		alert("openOpinionUI_New ::: " + e);
        	}
        } 
        
        function openOpinionUI_Complete(ret) {
        	DivPopUpHidden();
        	
        	if (ret != "cancel" && ret != undefined) {
        		GetHTML(openOpinionUI_Complete2);
            }
        }
        
        function openOpinionUI_Complete2(html) {
        	SaveHtml = html;
        	SaveFile();

          	var result = "";
	    	
    		$.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		url : "/ezApprovalG/sendOfferReject.do",
	    		data : {
	    			docID : pDocID,
	    			deptID : arr_userinfo[4],
	    			userID : pUserID,
	    			isSihangReject : isSihangReject,
	    			recordID : pRecordID
	    		},
	    		success: function(xml) {
	    			result = loadXMLString(xml);
	    		}, error: function() {
	    			 var pAlertContent = "<spring:message code='ezApprovalG.t258'/>";
		                OpenAlertUI(pAlertContent);
	    		}        			
	    	});
    		
            var ResultXML = result;
            if (getNodeText(GetChildNodes(ResultXML)[0]) == "TRUE") {
            	if (message.FieldExist("doctitle")) {
            		docTitle = message.GetFieldText("doctitle");
            	}

            	// 발송의뢰반송 메일알람 추가
            	if (isSihangReject == "Y") { // 미처리문서함 > 내부시행문의 반송 (완료문서 접근)
            		SendSihangBansong(docTitle);
            	} else { // 대외발송함 > 심사자의 반송
                	SendSimsaBansong(docTitle);
            	}
                var pAlertContent = "<spring:message code='ezApprovalG.t256'/>";
                OpenAlertUI(pAlertContent);
                setBtnDisable();
            } else {
            	 var pAlertContent = "<spring:message code='ezApprovalG.t258'/>";
                 OpenAlertUI(pAlertContent);
                 setMenuDisable("btnSend", false);
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
            var docID = pDocID;
            var orgDocID = pOrgDocID;

            if (isConvSihang) {
                var simsaUserInfo = [];
                simsaUserInfo[0] = "OK";
                simsaUserInfo[1] = arr_userinfo[1];
                simsaUserInfo[2] = arr_userinfo[11];
                simsaUserInfo[3] = arr_userinfo[13];
                simsaUserInfo[4] = arr_userinfo[4];
                simsaUserInfo[5] = arr_userinfo[15];
                simsaUserInfo[6] = arr_userinfo[12];
                simsaUserInfo[7] = arr_userinfo[16];
                simsaUserInfo[8] = arr_userinfo[14];

                var rtnJson = SendOfferForConvSihang(simsaUserInfo, pDocID, pDocHref, arr_userinfo[1]);
                if (!rtnJson.state) {
                    OpenAlertUI(rtnJson.msg);
                    return;
                }

                docID = rtnJson.newDocID;
                orgDocID = pDocID;
            }
            
        	var result = "";
	    	
    		$.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		url : "/ezApprovalG/sendOfferAprove.do",
	    		data : {
                    docID : docID,
                    orgDocID  : orgDocID,
	    			userID : pUserID,
	    			userName : arr_userinfo[11],
	    			deptID   : arr_userinfo[4],
	    			userName2: arr_userinfo[12]
	    		},
	    		success: function(xml){
                    var ResultXML = loadXMLString(xml);
                    result = getNodeText(GetChildNodes(ResultXML)[0]);
	    		} , error: function() {
	    			return "FALSE";
	    		}     			
	    	});
	    	 
            if (isConvSihang && result !== "TRUE") {
                UndoCreateDoc(docID);
                UndoUpdateProcessYN(orgDocID);
            }

            return result;
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
            
            if (isConvSihang) {
                result = saveEndFile(pDocID, SaveHtml);
            } else {
                result = saveEndFile(pOrgDocID, SaveHtml);
                if (result) {
                    result = saveIngFile(pDocID, SaveHtml);
                }
            }
            
            return result;
        }

        function saveEndFile(pDocID, pHtml) {
            var result = null;

            // 2021.01.07 강승구 : 오류발생 후 파일이 사라지는 오류 수정
            if (!pHtml)
                return;

            var reqData = {
                docID : pDocID,
                html  : pHtml
            };
            
            $.ajax({
                type : "POST",
                dataType : "text",
                async : false,
                url : "/ezApprovalG/saveEndFileHwp.do",
                contentType : "application/json",
                data : JSON.stringify(reqData),
                success: function(xml){
                    result = xml;
                }                   
            });
            
            return result === "SUCCESS";
        }

        function saveIngFile(pDocID, pHtml) {
            var result = null;
            var reqData = {
                docID : pDocID,
                html  :  pHtml
            };
            
            $.ajax({
                type : "POST",
                dataType : "text",
                async : false,
                url : "/ezApprovalG/saveFileHWP.do",
                contentType : "application/json",
                data : JSON.stringify(reqData),
                success: function(xml){
                    result = xml;
                }                   
            });
            
            return result === "TRUE";
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

        var selectSeal_cross_dialogArguments = new Array(); // 관인선택 레이어팝업에 파라미터를 전달할 배열
        var selectSeal_cross_returnValues = new Array(); // 레이어팝업에서 선택된 관인의 정보를 리턴하는 배열
	    var tempDeptSealXML;
	    var tempCompSealXML;
        function btnStamp_onclick() {
            if (!message.FieldExist("sealsign")) {
                var pAlertContent =  "<spring:message code='ezApprovalG.t201'/><br><spring:message code='ezApprovalG.t191'/>";
                OpenAlertUI(pAlertContent);
                return;
            }

            if (!stampFlag && !NostampFlag) {
                var DeptSealXML = GetDeptSealInfo();
                var CompSealXML = GetSealInfo();
                var sealType = "";

                if (SelectNodes(DeptSealXML, "ROWS/ROW").length > 0 && SelectNodes(CompSealXML, "ROWS/ROW").length > 0) {
                    var pInformationContent = "관인을 선택하세요.";
                    var Ans = OpenInformationUI(pInformationContent, Stamp_OpenUI, "seal");
                    tempDeptSealXML = DeptSealXML;
                    tempCompSealXML = CompSealXML;
                    return;
                } else if (SelectNodes(DeptSealXML, "ROWS/ROW").length <= 0 && SelectNodes(CompSealXML, "ROWS/ROW").length <= 0) {
                    var pAlertContent =  "<spring:message code='ezApprovalG.t194'/><BR><spring:message code='ezApprovalG.t195'/>";
                        OpenAlertUI(pAlertContent);
                        return;
                } else if (SelectNodes(DeptSealXML, "ROWS/ROW").length > 0) {
                    SealXML = DeptSealXML;
                    sealType = "dept";
                } else if (SelectNodes(CompSealXML, "ROWS/ROW").length > 0) {
                    SealXML = CompSealXML;
                    sealType = "comp";
                }

                selectSeal_cross_dialogArguments[0] = sealType; // 회사관인 또는 부서별관인(직인) 타입
                selectSeal_cross_dialogArguments[1] = SealXML; // 관인정보 XML
                selectSeal_cross_dialogArguments[2] = Stamp_OpenUI_complete; // 관인 선택 후 레이어팝업 종료 시 동작할 함수
                DivPopUpShow(350, 290, "/ezApprovalG/selectSeal.do");
            } else {
                if (message.FieldExist("sealsign")) {
                    message.PutFieldText("sealsign", "");
                    message.SetFieldBackImage("sealsign", "");
                }
                stampFlag = false;
                NostampFlag = false;
            }
        }

        function Stamp_OpenUI(Ans) {
            DivPopUpHidden();
            
            var sealType = "";
            if (!Ans) {
                SealXML = tempCompSealXML;
                sealType = "comp";
            } else {
                SealXML = tempDeptSealXML;
                sealType = "dept";
            }
            
            selectSeal_cross_dialogArguments[0] = sealType; // 회사관인 또는 부서별관인(직인) 타입
            selectSeal_cross_dialogArguments[1] = SealXML; // 관인정보 XML
            selectSeal_cross_dialogArguments[2] = Stamp_OpenUI_complete; // 관인 선택 후 레이어팝업 종료 시 동작할 함수
            DivPopUpShow(350, 290, "/ezApprovalG/selectSeal.do");
        }

        function Stamp_OpenUI_complete(retVal) {
            DivPopUpHidden();
            
            var SealHref = retVal[0];
            var SealWidth = retVal[1];
            var SealHeight = retVal[2];
            var SealCheck = retVal[3];

            // var fields = message.GetFieldsList();
            // field = message.GetListItem(fields, "sealsign");
            
            if (message.FieldExist("sealsign") && SealCheck != "false") {
                var signWidth = getPixel(SealWidth) + "px";
                var signHeight = getPixel(SealHeight) + "px";
                strimg = "<img src='" + encodeURI(SealHref) + "' border=0 embedding='1' ";
                strimg = strimg + " width=" + signWidth;
                strimg = strimg + " height=" + signHeight + ">";

                message.PutFieldText("sealsign", "");
                message.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(SealHref), 5);
                SetDocumentElement("surl", SealHref);
                SetDocumentElement("swidth", SealWidth);
                SetDocumentElement("sheight", SealHeight);
                stampFlag = true;
                NostampFlag = false;
            }
            else if (SealCheck == "false") {
                return; // 관인선택 레이어팝업에서 취소버튼을 클릭한 경우
            }
            else {
                alert("<spring:message code='ezApprovalG.t194'/>")
            }
        }
        
        function btnNoStamp_onclick() {
            var strimg;
            if (!message.FieldExist("sealsign")) {
                var pAlertContent =  "<spring:message code='ezApprovalG.t201'/><BR><spring:message code='ezApprovalG.t191'/>";
                OpenAlertUI(pAlertContent);
                return;
            }

            if (!NostampFlag && !stampFlag) {
                var SealHref = "/files/sealImg/nostamp.gif"
                var SealWidth = 30;
                var SealHeight = 10;

                if (message.FieldExist("sealsign")) {
                    message.PutFieldText("sealsign", "");
                    message.SetFieldBackImage("sealsign", document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(SealHref), 6);
                    SetDocumentElement("surl", SealHref);
                    SetDocumentElement("swidth", SealWidth);
                    SetDocumentElement("sheight", SealHeight);
                    NostampFlag = true;
                    stampFlag = false;
                }
            } else {
                if (message.FieldExist("sealsign")) {
                    message.PutFieldText("sealsign", "");
                    message.SetFieldBackImage("sealsign", "");
                }
                NostampFlag = false;
                stampFlag = false;
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
		    			docType : "WHWP"
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
	
		function GetHTML(callback) {
		    message.GetTextFile("HWP", "", function (data) { callback(data) });
		}
		
    	// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
    	function setAttachGuideText() {
    		// 대용량첨부의 자동삭제 기능, 저장만료기한 사용하지 않음
            var attachGuideText =  "<td align='left' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-left:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; border-right:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
            
            if(bigSizeAttachDownloadLimitCount > 0) {
            	attachGuideText += strLangHSBAt06 + " <span style='color:#FF0000 ;'>" + bigSizeAttachDownloadLimitCount + strLangHSBAt09 + "</span> " + strLangHSBAt10;
            }
            
            attachGuideText += "<td align='right' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-right:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; border-left:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
            attachGuideText += "</td>";
/*                 
            var attachGuideText =  "<td align='left' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-left:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-left:1px solid #dadada; border-right:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
            attachGuideText += strLangHSBAt05 + "<span style='color:#FF0000 ;'>" + bigAttachDownloadPeriod + "</span></td>";
            attachGuideText += "<td align='right' style='width:50%; font-size:11px; font-weight:normal; color:#666666; padding-right:10px; padding-top:0px; padding-bottom:0px; margin:0px; border-bottom:1px solid #dadada;border-right:1px solid #dadada; border-left:none; border-top: none; background:#fffcfa; height:20px; line-height:20px;'>";
            attachGuideText += strLangHSBAt06 + "<span style='color:#FF0000 ;'>" + bigAttachDownloadDay + strLangHSBAt07 + "</span>" + strLangHSBAt08;
             */
             
             if (bigSizeAttachDownloadLimitCount > 0) {
            	 document.getElementById("apprAttachGuideTR").innerHTML = attachGuideText;
             }
             else {
            	 document.getElementById("apprAttachGuideTR").style.display = "none";
             }
    	}

        //메일발송
        function btnMail_onclick() {
            if (!stampFlag && !NostampFlag) {
                var pAlertContent = "<spring:message code='ezApprovalG.t216'/>";
                OpenAlertUI(pAlertContent);
                return;
            }
            GetHTML(sendMail);
        }

        function sendMail(){
            // window.open(document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezEmail/mailWrite.do?docHref=" + pDocHref + "&cmd=docsend&docID=" + pOrgDocID + "&TARGET=APPROVALG", "", "height = " + window.screen.availHeight * 0.8 + ", width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(890, window.screen.availHeight * 0.8));
            showPopup(document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezEmail/mailWrite.do?docHref=" + pDocHref + "&cmd=docsend&docID=" + pOrgDocID + "&TARGET=APPROVALG", 1200, window.screen.availHeight * 0.8, "", "height = " + window.screen.availHeight * 0.8 + ", width = 1200px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(1200, window.screen.availHeight * 0.8), hidePopup);
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
                        <li id="btnSetReceivLine" <c:if test="${approvalFlag == 'S'}">style="display: none"</c:if>><span onclick="return btnSetReceivLine_onclick()"><spring:message code='ezApprovalG.t53'/></span></li>
                        <li id="btnStamp"><span onclick="return btnStamp_onclick()"><spring:message code='ezApprovalG.t213'/></span></li>
                        <li id="btnNoStamp"><span onclick="return btnNoStamp_onclick()"><spring:message code='ezApprovalG.t222'/></span></li>
                        <li id="btnSend"<c:if test="${approvalFlag == 'S'}">style="display: none"</c:if>><span onclick="return btnSend_onclick()"><spring:message code='ezApprovalG.t214'/></span></li>
                        <li id="btnBoard"><span onclick="return btnBoard_onclick()"><spring:message code='ezApprovalG.t215'/></span></li>
                        <li id="btnReject" style="display: none"><span onclick="return btnReject_onclick()"><spring:message code='ezApprovalG.t49'/></span></li>
                        <li id="btnPrint"><span class='icon16 popup_icon16_print' onclick="return btnPrint_onclick()"></span></li>
                        <c:if test="${approvalFlag == 'S'}">
	                        <li id="btnMail"><span class="icon16 popup_icon16_mail_gray" onclick="return btnMail_onclick()"></span></li>
                        </c:if>
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
            <td style="padding-bottom:10px;height:800px;" id="messageWHWPEditor">
		    	<iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="/ezApprovalG/WHWPEditor.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	        </td>
        </tr>
        <c:if test="${approvalFlag == 'S'}">
        <tr>
            <td style="vertical-align: top; height: 0%" id="form2">
                <iframe id="message2" name="message2" src="/ezApprovalG/WHWPEditor.do?type=copyAppr"  style="background-color: White; height: 0px; width: 0px;"></iframe>
            </td>
        </tr>
        </c:if>
        <tr>
            <td height="20">
                <table class="file" style="height:80px; margin-top:-9px;">
                    <tr>
                        <th><spring:message code='ezApprovalG.t65'/></th>
                        <td style=" width:62%; border-right:1px solid #d5d5d5;">
                            <div id="lstAttachLink" style="height:70px;"></div>
                            <iframe id="ifrmDownload" name="ifrmDownload" src="about:blank" width="0" height="0" style="display: none;"></iframe>
                        </td>
                        <td style=" width:30%;">
							<div id="lstAttachLinkDoc" style="height:70px;"></div>
						</td>
                        <td class="pos2" style="width:8%; background:#fffcfa;">
							<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
							<a class="imgbtn imgbck" style="width:70px;"><span style="height:24px;" onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a><br/>
						</td>
                    </tr>
                </table>
                
				<%-- 대용량첨부 가이드 메세지 영역 --%>
                <table class="file" style="height: 20px;">
                    <tr id="apprAttachGuideTR"></tr>
                </table>
            </td>
        </tr>
    </table>
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	</div>
	<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingLayer">
        <img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
    </div>
</body>
</html>
