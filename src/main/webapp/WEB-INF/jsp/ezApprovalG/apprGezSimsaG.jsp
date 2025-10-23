<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html style="height:97%;">
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
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>	
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezSimsaG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/attachG_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></SCRIPT>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendOffer_Cross.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
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
		    var pDomainName = document.location.protocol + "//" + document.location.hostname + ":" + document.location.port;
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
		    var pUse_Editor = "<c:out value = '${useEditor}'/>";
		    var PrtBodyContent;
		    var orgCompanyID = "";
		    var ext = "mht";
		    var docTitle = "";
		    var isConvSihang = ${isConvSihang};
		    var useWebHWP = "<c:out value ='${useWebHWP}'/>";
		    
	        // 대용량첨부 관련
	        var bigAttachDownloadPeriod = "<c:out value ='${bigAttachDownloadPeriod}'/>";
	        var bigAttachDownloadDay = "<c:out value ='${bigAttachDownloadDay}'/>";
	        var bigSizeAttachDownloadLimitCount = "<c:out value ='${bigSizeAttachDownloadLimitCount}'/>";
	        
	        var isSihangReject = "N"; // 시행문변환 시 반송을 위한 구분값 전달
	        var pRecordID = "<c:out value = '${recordID}'/>";

			// 2023-05-25 조수빈 - 전자결재 첨부파일 미리보기 사용 여부
			var useAprFilePrvw = "<c:out value ='${useAprFilePrvw}'/>";
	        
		    function btnPrint_onclick() {
		        PrintClick("Cross", pDocID, "");
		    }
		    function DocumentComplete() {
		        if (flag == false) {
					flag = true;
					
					if (isConvSihang) {
						setMenuDisable("btnOpinion", true);
						setMenuDisable("btnReject", true); // 시행문변환으로 접근해도 반송이 가능하도록 수정
	                    isSihangReject = "Y"; // 시행문변환으로 접근 시 반송 관련 플래그 설정
					} else {
						setMenuDisable("btnReject", true);
					}
		
		            if ("${pass}" != "<RESULT>TRUE</RESULT>") {
		                QuitWindow();
		            } else {
		                if (pDocHref != "") {
		                    message.Set_EditorContentURL(pDocHref);
		                }
		            }
		        }
		        
				// 일반첨부, 대용량첨부파일 관련 가이드 메세지 추가
				setAttachGuideText();
		    }
		    var noFieldsAvailable = false;
		    function FieldsAvailable() {
		        var fields = message.GetFieldsList();
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
		        } catch (e) { 
		            window.parent.openergetDocInfo();
		        }
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
		    function OpenInformationUI(pInformationContent, CompleteFunction, pType) {
		        var parameter = pInformationContent;
		        var url = "/ezApprovalG/ezAprOpinion.do?type=" + pType;
		
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
		
		        DivPopUpShow(350, 225, "/ezApprovalG/ezchkPasswd.do");
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
		                    pFilePath = pHref.substring(pHref.indexOf("docHref=") + 8, pHref.indexOf("&amp;", pHref.indexOf("docHref=")));
		                    pFileExt = pFilePath.substring(pFilePath.lastIndexOf("."), pFilePath.length);
		                } else {
		                    pFilePath = pHref.substring(pHref.indexOf("filePath=") + 9, pHref.length);
		                }
		                attachName[idx] = objNodes[i].innerText + pFileExt;
		                attachPath[idx] = decodeURIComponent(pFilePath);
		                attachType[idx] = "";
		                idx++;
		            }
		        }
		    }
		    function btnSetReceivLine_onclick() {
				var convSihangParam = isConvSihang ? "&mode=END" : "";
		        DivPopUpShow(720, 240, "/ezApprovalG/ezReceiptInfo.do?docID=" + pDocID + "&ext=" + ext + convSihangParam);
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
		        if (!stampFlag && !NostampFlag) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t216'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        
		        setMenuDisable("btnSend", true);
		        var pInformationContent = "<spring:message code='ezApprovalG.t205'/>";
		        OpenInformationUI(pInformationContent, Send_OpenUI);
		    }
		    function Send_OpenUI(Ans) {
		        DivPopUpHidden();
		        if (!Ans) {
		        	//setMenuDisable("btnSend", false);
		        	return;
		        }
		        //if ("${approvalPWD}" != "N") {
		        if (CheckUsePassword()) {
		            var chkpass = chk_Passwd(pUserID, Send_ChkPassword);
		        } else {
		            btnSend_onclick_Complete();
		        }
		    }
		    function Send_ChkPassword(chkpass) {
		        DivPopUpHidden();
		        if (chkpass == "False") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
		            OpenAlertUI(pAlertContent);
		            setMenuDisable("btnSend", false);
		            return;
		        }
		        else if (chkpass == "cancel") {
		        	setMenuDisable("btnSend", false);		        	
		            return;
		        }
		
		        btnSend_onclick_Complete();
		    }
		
		    function btnSend_onclick_Complete() {
				SaveFile();
				
		        var rtnVal = "FALSE";
		        if (isExternal) {
		            if (isAddress) {
		                rtnVal = SetContainer();
				        if (rtnVal == "TRUE") {
				            var pAlertContent = "<spring:message code='ezApprovalG.t206'/>";
				            OpenAlertUI(pAlertContent);
				            setBtnDisable();
				        } else {
				            var pAlertContent = "<spring:message code='ezApprovalG.t217'/>";
				            OpenAlertUI(pAlertContent);
				            setMenuDisable("btnSend", false);
				        }
		            } else {
		                is_Enc = OpenCheckUI();
		            }
		        } else {
		            Check_Container();
		        }
		    }
		
		    function Check_Container() {
		        rtnVal = SetContainer();
		        if (rtnVal == "TRUE") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t206'/>";
		            OpenAlertUI(pAlertContent);
		            setBtnDisable();
		        } else {
		            var pAlertContent = "<spring:message code='ezApprovalG.t217'/>";
		            OpenAlertUI(pAlertContent);
		            setMenuDisable("btnSend", false);
		        }
		    }
		
		    var selectenc_dialogArguments = new Array();
		    function OpenCheckUI() {
		    	var parameter = "";

		    	/* selectenc_dialogArguments[0] = parameter;
		    	selectenc_dialogArguments[1] = OpenCheckUI_Complete;

		    	DivPopUpShow(330, 205, "/ezApprovalG/selectEnc.do"); */
		    	OpenCheckUI_Complete("NONE");
		    }
		    
		    function OpenCheckUI_Complete(returnvalue) {
		        //DivPopUpHidden();
		        is_Enc = returnvalue;
		        rtnVal = sendExt();
		        
		        if (rtnVal) {
	                var pAlertContent = "<spring:message code='ezApprovalG.t206'/>";
	                 OpenAlertUI(pAlertContent);
	                 setBtnDisable();
	             }
	             else {
	                 var pAlertContent = "<spring:message code='ezApprovalG.t217'/>";

	                 OpenAlertUI(pAlertContent);
	             }
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
		        var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(355, 600));
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
		
		            if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4" || ret[2] == "7" || ret[2] == "8") {
		                alert(strLang1031);
		            }
		            else {
		                window.open("/ezBoard/boardNewItem.do?boardID=" + encodeURIComponent(pBoardID) + "&mode=new1&pbrdGbn=SiteNewBoard&pFromScreen=Mail&docID=" + pDocID + "&url=" + pDocHref, '', "top=" + pTop.toString() + ", left=" + pLeft.toString() + ',height=870,width=765,scrollbars=no');
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
		        //if ("${approvalPWD}" != "N") {
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
		            var pAlertContent = "<spring:message code='ezApprovalG.t27'/>";
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else if (chkpass == "cancel")
		            return;
		
		        //openOpinionUI("BanSong");
		        openOpinionUI_New("BanSong");
		    }
		
		    var apropinion_cross_dialogArguments = new Array();
		    function openOpinionUI(ret) {
		        var parameter = new Array();
		        parameter[0] = pDocID;
		        parameter[1] = ret;
		        parameter[2] = "002";
		        parameter[3] = pOrgDocID;
		        //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
		        parameter[99] = "mht";
		        
		        apropinion_cross_dialogArguments[0] = parameter;
		        apropinion_cross_dialogArguments[1] = openOpinionUI_Complete;
		
		        DivPopUpShow(530, 520, "/ezApprovalG/aprOpinion.do");
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
		    		
		    		apropinion_cross_dialogArguments[0] = parameter;
	    			apropinion_cross_dialogArguments[1] = openOpinionUI_Complete;
		    		
		    		DivPopUpShow(530, 520, "/ezApprovalG/aprOpinionNew.do");
		    	} catch (e) {
		    		alert("openOpinionUI_New ::: " + e.description);
		    	}
		    }
		
		    function openOpinionUI_Complete(ret) {
		        DivPopUpHidden();
		
		        if (ret != "cancel") {
					var fields = message.GetFieldsList();
	                field = message.GetListItem(fields, "sealsign");
	                if (field) {
	                    field.innerHTML = " ";
	                }
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
			    		success: function(xml){
			    			result = loadXMLString(xml);
			    		}, error: function () {
			    			 var pAlertContent = "<spring:message code='ezApprovalG.t258'/>";
				                OpenAlertUI(pAlertContent);
			    		}        			
			    	});
		    		
		            var ResultXML = result;
		            if (getNodeText(GetChildNodes(ResultXML)[0]) == "TRUE") {
		            	var fields = message.GetFieldsList();
		            	var field = message.GetListItem(fields, "doctitle");

		            	if (field) {
		            		docTitle = field.textContent;
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
		    }
		    
		    /* 2020-02-26 홍승비 - 발송문서 게시 성공 이후 자동발송 > 발송된 문서에 관인 이미지가 부여되지 않는 오류 수정 */
		    function SuccessBoard() {
				SaveFile();
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
		    			result = "FALSE";
		    		}     			
				});
				
				if (isConvSihang && result !== "TRUE") {
					UndoCreateDoc(docID);
					UndoUpdateProcessYN(orgDocID);
				}

				return result;
		    }
		    
		    function setBtnDisable() {
		    	setMenuDisable("btnSend", false);
		    	
		        btnOpinion.style.display = "none";
		        btnSetReceivLine.style.display = "none";
		        btnStamp.style.display = "none";
		        btnNoStamp.style.display = "none";
		        btnSend.style.display = "none";
		        btnBoard.style.display = "none";
		        btnReject.style.display = "none";
		    }
		    
		    function SaveFile() {
				var result = null;
		        var mhtBody = "";
		        mhtBody = message.Get_EditorBodyHTML();
		        mhtBody = "<HTML>" + GetCKEditerHeader() + mhtBody + "</HTML>";
				mhtBody = ConvertHTMLtoMHT(mhtBody);
				
				if (isConvSihang) {
					result = saveEndFile(pDocID, mhtBody);
				} else {
					result = saveEndFile(pOrgDocID, mhtBody);
					result = saveIngFile(pDocID, mhtBody, orgCompanyID);
				}
		        
		        return result;
			}
			
			function saveEndFile(pDocID, pMhtBody) {
				var result = null;
		    	var reqData = {
	    			docID : pDocID,
	    			html  : pMhtBody
		    	}
				
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/saveEndFile.do",
		    		contentType : "application/json",
		    		data : JSON.stringify(reqData),
		    		success: function(xml){
		    			result = xml;
		    		}        			
				});
				
				return result;
			}
			function saveIngFile(pDocID, pMhtBody, pOrgCompnyID) {
				var result = null;
		    	var reqData = {
	    			docID : pDocID,
	    			html  : pMhtBody,
	    			orgCompanyID : pOrgCompnyID
		    	}
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/saveFile.do",
		    		contentType : "application/json",
		    		data : JSON.stringify(reqData),
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
		    
		    /* 2020-02-18 홍승비 - 회사관인, 부서별관인(직인)을 선택할 수 있도록 수정 */
		    var selectSeal_cross_dialogArguments = new Array(); // 관인선택 레이어팝업에 파라미터를 전달할 배열
		    var selectSeal_cross_returnValues = new Array(); // 레이어팝업에서 선택된 관인의 정보를 리턴하는 배열
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
		        
		        if (!stampFlag && !NostampFlag) { // 관인영역이 비어있는 경우에만 진행
		            var DeptSealXML = GetDeptSealInfo();
		            var CompSealXML = GetSealInfo();
				    var sealType = "";
				    
				    /* 2020-02-19 홍승비 - 회사관인과 부서관인의 존재여부 체크 로직 수정(GetChildNodes -> SelectNodes) */
		            // 회사관인과 부서관인이 모두 존재하는 경우
		            if (SelectNodes(DeptSealXML, "ROWS/ROW").length > 0 && SelectNodes(CompSealXML, "ROWS/ROW").length > 0) {
		                var pInformationContent = "관인을 선택하세요.";
		                OpenInformationUI(pInformationContent, Stamp_OpenUI, "seal");
		                tempDeptSealXML = DeptSealXML;
		                tempCompSealXML = CompSealXML;
		                
		                return;
		            }
		            // 모든 관인이 존재하지 않는 경우
		            else if (SelectNodes(DeptSealXML, "ROWS/ROW").length <= 0 && SelectNodes(CompSealXML, "ROWS/ROW").length <= 0) {
		                var pAlertContent = "<spring:message code='ezApprovalG.t194'/>" + "<br>" + "<spring:message code='ezApprovalG.t195'/>";
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		            // 부서관인만 존재
		            else if (SelectNodes(DeptSealXML, "ROWS/ROW").length > 0) {
		                SealXML = DeptSealXML;
		                sealType = "dept";
		            }
		            // 회사관인만 존재
		            else if (SelectNodes(CompSealXML, "ROWS/ROW").length > 0) {
		                SealXML = CompSealXML;
		                sealType = "comp";
		            }
				    
					selectSeal_cross_dialogArguments[0] = sealType; // 회사관인 또는 부서별관인(직인) 타입
			        selectSeal_cross_dialogArguments[1] = SealXML; // 관인정보 XML
			        selectSeal_cross_dialogArguments[2] = Stamp_OpenUI_complete; // 관인 선택 후 레이어팝업 종료 시 동작할 함수
			        DivPopUpShow(350, 290, "/ezApprovalG/selectSeal.do");
			        
			        /* 2020-02-18 홍승비 - 기존 관인지정 코드 주석처리 */
/* 		            
		            var SealHref = getNodeText(SelectSingleNode(SelectNodes(SealXML, "ROWS/ROW/CELL")[0], "DATA2"));
		            var SealWidth = Number(getNodeText(SelectSingleNode(SelectNodes(SealXML, "ROWS/ROW/CELL")[1], "VALUE")));
		            var SealHeight = Number(getNodeText(SelectSingleNode(SelectNodes(SealXML, "ROWS/ROW/CELL")[2], "VALUE")));
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
		             */
		        }
		        else { // 기존 관인이 찍혀있는 경우, 관인버튼 클릭 시 해당 이미지를 제거한다.
		            field = message.GetListItem(fields, "sealsign");
		            if (field) {
		                field.innerHTML = " ";
		                stampFlag = false;
		                NostampFlag = false; // 관인생략 이미지도 제거하므로 플래그값 변경
		            }
		        }
		    }
		
		    /* 2020-02-18 홍승비 - 회사관인, 부서별관인(직인)을 선택할 수 있도록 수정 중 */
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
		        
		        /* 2020-02-18 홍승비 - 기존 관인지정 코드 주석처리 */
/* 
		        var SealHref = getNodeText(SelectSingleNode(SelectNodes(SealXML, "ROWS/ROW/CELL")[0], "DATA2"));
		        var SealWidth = parseInt(getNodeText(SelectSingleNode(SelectNodes(SealXML, "ROWS/ROW/CELL")[1], "VALUE")));
		        var SealHeight = parseInt(getNodeText(SelectSingleNode(SelectNodes(SealXML, "ROWS/ROW/CELL")[2], "VALUE")));
		        var fields = message.GetFieldsList();
		        var SealCheck = getNodeText(SelectSingleNode(SelectNodes(SealXML, "ROWS/ROW/CELL")[0], "DATA4"));
		        field = message.GetListItem(fields, "sealsign");
		        
		        if (field && SealCheck != "false") {
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
		        } else {
		        	alert("<spring:message code='ezApprovalG.t194'/>")
		        }
		         */
		    }
		    
		    /* 2020-02-18 홍승비 - 관인선택 완료 시 동작할 함수 */
		    function Stamp_OpenUI_complete(retVal) {
		    	DivPopUpHidden();
		    	
		    	var SealHref = retVal[0];
		        var SealWidth = retVal[1];
		        var SealHeight = retVal[2];
		        var SealCheck = retVal[3];
		        var fields = message.GetFieldsList();
		        field = message.GetListItem(fields, "sealsign");
		        
		        if (field && SealCheck != "false") {
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
		        else if (SealCheck == "false") {
		        	return; // 관인선택 레이어팝업에서 취소버튼을 클릭한 경우
		        }
		        else {
		        	alert("<spring:message code='ezApprovalG.t194'/>")
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
		        if (!NostampFlag && !stampFlag) { // 관인영역이 비어있는 경우에만 진행
		            var SealHref = "/files/sealImg/nostamp.gif";
		            var SealWidth = 30;
		            var SealHeight = 30;
		            field = message.GetListItem(fields, "sealsign");
		            if (field) {
		                var signWidth = getPixel(SealWidth) + "px";
		                var signHeight = getPixel(SealHeight) + "px";
		
		                strimg = "<img src='" + encodeURI(SealHref) + "' border=0 embedding='1' >";
		                //strimg = strimg + " width=" + signWidth;
		                //strimg = strimg + " height=" + signHeight + ">";
		
		                /* var field2 = message.GetListItem(fields, "chief");
		                var chiefwidth = 1;
		                if (field2) {
		                    if (isNaN(chiefwidth)) {
	                           chiefwidth = Number(field2.width);
	                        }
		                    field2.height = signHeight;
		                }
		                var sealwidth = (maxwidth + chiefwidth) / 2 + 20; */
		                var field2 = message.GetListItem(fields, "sealwidth");
		                if (field2)
		                    field2.width = "480px";
		
		                var field2 = message.GetListItem(fields, "noseal");
		                if (field2) {
		                    /* if ((maxwidth - sealwidth - getPixel(SealWidth)) > 0)
		                        field2.width = (maxwidth - sealwidth - getPixel(SealWidth));
		                    else
		                        field2.width = (maxwidth - sealwidth - getPixel(SealWidth)) * (-1); */
		                    field2.width = "105px";
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
		                stampFlag = false; // 기존 관인생략 이미지 제거 시 관인이미지 플래그도 변경
		            }
		        }
		    }
		    function getPixel(pLength) {
		        try {
		            var tempLength = Number(pLength);
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
		    		},
		    		error : function(jqXHR, textStatus, errorThrown) {
		        		alert("<spring:message code = 'ezApprovalG.t228' />" + jqXHR.statusText);
		        	}
		    	});
	    		
		        return result;
		    }
		    function Conversion(pixel) {
// 		        return Number(pixel * (35 / 100));
		        return Number(pixel * (26.4583 / 100));
		    }
		
		    function SizeConvert(size) {
		        return Math.round(parseFloat(size) * parseFloat("0.35")).toFixed(2);
		    }
		
	        function Document_Encode(text, pDefaultFontFamily, pDefaultFontSize) {
				var textContent = document.createElement('div');
				textContent.style.position = 'absolute';
				textContent.style.visibility = 'hidden';
				textContent.innerHTML = text;
				document.body.appendChild(textContent);
				
				var autoElements = textContent.querySelectorAll('td[style*="auto"], th[style*="auto"]');
				
				for (var i = 0; i < autoElements.length; i++) {
					var autoElement = autoElements[i];
					var styleAttr = autoElement.getAttribute('style');
					if (!styleAttr) continue;
				
					var autoDel = styleAttr;
				
					if (/width\s*:\s*auto/i.test(styleAttr)) {
						var width = autoElement.offsetWidth;
						autoDel = autoDel.replace(/width\s*:\s*auto/i, 'width:' + width + 'px');
					}
				
					if (/height\s*:\s*auto/i.test(styleAttr)) {
						var height = autoElement.offsetHeight;
						autoDel = autoDel.replace(/height\s*:\s*auto/i, 'height:' + height + 'px');
					}
				
					autoElement.setAttribute('style', autoDel);
				}
				
				var contentText = textContent.innerHTML;
				document.body.removeChild(textContent); 
				contentText = contentText
						.replace(/"/g,'\"')
						.replace(/<div id=\\?"hwpEditorBoardContent\\"[^]*?<\/div>/g, '')
						.replace(/font-family\s*:\s*([^;]+);/g, (match, fonts) => {
					if (/^'[^']+'$/.test(fonts.trim())) {
                        const inside = fonts.trim().slice(1, -1);
                        return "font-family:&quot;" + inside + "&quot;;";
                    } else {
                        return match;  // 그대로 원본 반환
                    }
				});
				
	        	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getContentXml.do",
		    		data : {
		    			fontFamily : pDefaultFontFamily,
		    			fontSize : pDefaultFontSize,
		    			content : contentText,
		    			docType : "MHT"
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}     			
		    	});
	        	
	            var Content = document.createElement("DIV");
	            var pTemp = result;

	            if (getNodeText(pTemp.getElementsByTagName("RESULT")[0]) === "OK") {
	                Content.innerHTML = getNodeText(pTemp.getElementsByTagName("CONTENT")[0]);
	            } else {
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
	                                case "style":
	                                case "class":
	                                case "summary":
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
	            
	            // 한글기안기에서 접수 할 때, table 태그에 align이 있어도 적용되지 않고 align 속성을 가진 p태그로 감싸져 있어야 해서 처리. 2020-05-20 홍대표.
	            coverTableWithP(Content);

	            var rtnVal = Content.innerHTML.replace(/width_kaoni/g, "width").replace(/height_kaoni/g, "height");
	            rtnVal = rtnVal.replace(/\r/g, "").replace(/\n/g, "").replace(/&nbsp; /g, "&nbsp;&nbsp;");

	            // COL TAG의 닫는 태그가 없는 경우가 있어 강제 변환처리.
	            rtnVal = rtnVal.replace(/<COL>/g, "<col>").replace(/<COL /g, "<col ").replace(/<\/COL>/g, "</col>"); // 대문자 태그를 소문자로 변환
	            rtnVal = rtnVal.replace(/<col>/g, "<col></col>").replace(/<\/col><\/col>/g, "</col>").replace(/\/><\/col>/g, "></col>");
	            
	            var rtnVal2 = rtnVal.match(/<img.*?>(.*?)/gm);
	            if (rtnVal2 != null) {
		            for( var j=0; j < rtnVal2.length;j++) {
		            	rtnVal = rtnVal.replace(rtnVal2[j],rtnVal2[j].replace(">","/>"));
		            }
	            }
	            return rtnVal;
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
		    
		    function coverTableWithP(bodyContent){
	            var tableElementArray = bodyContent.getElementsByTagName("table");
	            for (var i = 0; i < tableElementArray.length; i++) {
	            	var tableElement = tableElementArray[i];
	            	if (tableElement.parentElement.tagName.toLowerCase() != "p" && tableElement.getAttribute("align")) {
	            		var pElem = document.createElement("p");
	            		pElem.innerHTML = tableElement.outerHTML;
	            		pElem.setAttribute("align", tableElement.getAttribute("align"));
	            		tableElement.parentNode.insertBefore(pElem, tableElement);
	            		tableElement.parentNode.removeChild(tableElement);
	            	}
	            }
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
	    	
		</script>
	</head>
	<body class="popup"  style="overflow:hidden;height:100%;">
	    <object classid="clsid:80009476-666B-4869-8C04-AB03492561CD" id="ObjGPKI" style="DISPLAY: none; HEIGHT: 86px; WIDTH: 243px"></object>
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
				    <li id=btnReject style="display:none"><span onClick="return btnReject_onclick()"  ><spring:message code='ezApprovalG.t49'/></span></li> 
				    <li id=btnPrint><span class='icon16 popup_icon16_print' onClick="return btnPrint_onclick()" ></span></li>
				</ul>
				</div>
				<div id="close">
		        <ul>
		          <li><span id="btnClose" onClick="return btnClose_onclick()" ></span></li>
		        </ul>
		      </div>
				</td>
			</tr>
		  <tr>
		    <td style="vertical-align: top; height: 90%;">
		         <iframe id="Iframe1" name="message" class="viewbox" frameborder="0" style="margin: 0px; padding: 0px; width: 100%; height: 99.7%; overflow: hidden;" src="enforceContent.do"></iframe>
		    </td>
		  </tr>
			<tr> 
				<td style="height:20px;">
	                <table class="file" style="height:80px;">
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
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		</script>
	</body>
</html>