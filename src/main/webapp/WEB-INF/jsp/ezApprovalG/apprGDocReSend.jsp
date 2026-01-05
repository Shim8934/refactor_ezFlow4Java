<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html style="height: 97%">
	<head>
	    <title><spring:message code='ezApproval.t157'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getDocAttach_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/SendMailApprove.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezDraftCK_Common.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Common_Function.js')}"></script>
<%-- 	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/recevG_Susin_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CheckLines_Cross.js')}"></script> --%>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var pDocID = "<c:out value ='${docID}'/>";
	        var pDocHref = "<c:out value ='${docHref}'/>";
	        var pFormID = "<c:out value ='${formID}'/>";
	        var pOpinionFlag;
	        var pUserID;
	        var flag = false;
	        var modeflag = false;
	        var newDocID = "";
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "<c:out value ='${userInfo.id}'/>";
	        arr_userinfo[2] = "<c:out value ='${userInfo.displayName}'/>";
	        arr_userinfo[3] = "<c:out value ='${userInfo.title}'/>";
	        arr_userinfo[4] = "<c:out value ='${userInfo.deptID}'/>";
	        arr_userinfo[5] = "<c:out value ='${userInfo.deptName}'/>";
	        arr_userinfo[6] = "<c:out value ='${userInfo.jikChek}'/>";
	        arr_userinfo[8] = "<c:out value ='${userInfo.email}'/>";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "<c:out value ='${susinAdmin}'/>";
	        arr_userinfo[11] = "<c:out value ='${userInfo.displayName1}'/>";
	        arr_userinfo[12] = "<c:out value ='${userInfo.displayName2}'/>";
	        arr_userinfo[13] = "<c:out value ='${userInfo.title1}'/>";
	        arr_userinfo[14] = "<c:out value ='${userInfo.title2}'/>";
	        arr_userinfo[15] = "<c:out value ='${userInfo.deptName1}'/>";
	        arr_userinfo[16] = "<c:out value ='${userInfo.deptName2}'/>";
	        var companyID = "<c:out value ='${userInfo.companyID}'/>";
	        var pUserID = arr_userinfo[1];
	        var CurrYear = "<c:out value ='${oldYear}'/>";
	        var g_szUserID = arr_userinfo[8];
	        var g_senderinfo = "<c:out value ='${userInfo.companyName}'/>" + ", " + "<c:out value ='${userInfo.deptName}'/>" + ", " + "<c:out value ='${userInfo.title}'/>";
	        var pUse_Editor = "<c:out value ='${useEditor}'/>";
	        var orgCompanyID = "";
	        var preSusinGroupStr = "<c:out value ='${preSusinGroupStr}'/>"; // 수신처그룹 구분 관련 파라미터
			var ReturnFunction;

			// 창마다 고유한 id 지정용
			var windowUuid = getRandomId();
	        
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        window.onload = function () {
				if (isParentCommonArgsUsed()) {
					ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
				}
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            if (pDocHref != "") {
	                message.Set_EditorContentURL(pDocHref);
	            }
	        }
	        window.onresize = function () {
	            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 130 + "PX";
	        }
	
	        var aprendopinion_dialogArgument = new Array();
	        function btnOpinion_onclick() {
	            var parameter = new Array();
	            parameter[0] = pDocID;
	            parameter[1] = "Show";
	            aprendopinion_dialogArgument[0] = parameter;
	            aprendopinion_dialogArgument[1] = btnOpinion_onclick_Complete;
	            var url = "/ezApprovalG/aprEndOpinion.do";
	            DivPopUpShow(530, 520, url);
	        }
	        function btnOpinion_onclick_Complete(RtnVal) {
	            DivPopUpHidden();
	        }
	
	        function DocumentComplete() {
	            if (flag == false) {
	                flag = true;
	            }
	        }
	        function FieldsAvailable() {
	            if (newDocID == "")
	                newDocID = createNewDoc();
	            setAttachInfo(pDocID, "END", document.getElementById("lstAttachLink"));
	        }
	        var PrtBodyContent;
	        function btnPrint_onclick() {
	            PrintClick("Cross", pDocID, "");
	        }
	        // function btnClose_onclick() {
	        //     window.close();
	        // }
	        
	        function createNewDoc() {
	            try {
	            	var result = "";
	            	
	                $.ajax({
	            		type : "POST",
	            		dataType : "text",
	            		async : false,
	            		url : "/ezApprovalG/createNewDoc.do",
	            		data : {
	            			formID : pFormID,
	            			pUserID : ""
	            		},
	            		success: function(text){
	            			result = text;
	            		}, error: function() {
	            			var pAlertContent = "<spring:message code='ezApproval.t126'/><br> <spring:message code='ezApproval.t127'/>";
		                    OpenAlertUI(pAlertContent);
		                    return "";
	            		}        			
	            	});
	                return result;
	            } catch (e) {
	                showAlert("createNewDoc()" + e.description);
	            }
	        }
	        var beforeHtml = "";
	        var modeflag = true;
	        var modifiOrgBody;
	        function btnEdit_onclick() {
	            if (getNodeText(btnEdit.childNodes.item(0)) == "<spring:message code='ezApproval.t46'/>") {
	                setMenuBar("btnOpinion", false);
	                setMenuBar("btnSend", false);
	                setMenuBar("btnPrint", false);
	                setMenuBar("btntotaldocinfo", false);
	                modeflag = false;
	                beforeHtml = message.Get_EditorBodyHTML();
	                message.SetEditable(true);
	                setNodeText(btnEdit.childNodes.item(0) , "<spring:message code='main.sp09'/>");
	            }
	            else {
	                var pInformationContent = "<spring:message code='ezApproval.t45'/>";
	                // OpenInformationUI(pInformationContent, Edit_Complete);
	                showConfirmUI(pInformationContent, Edit_Complete);
	            }
	        }
	        function Edit_Complete(RtnVal)
	        {
	        	DivPopUpHidden();

	            if (RtnVal) {
	                modeflag = true;
	            } else {
	                message.Set_EditorInputBodyHTML(modifiOrgBody);
	                message.Set_HtmlDocument();
	            }
	            message.SetEditable(false);
	            setNodeText(btnEdit.childNodes.item(0) , "<spring:message code='ezApproval.t46'/>");
	            setMenuBar("btnOpinion", true);
	            setMenuBar("btnSend", true);
	            setMenuBar("btnPrint", true);
	            setMenuBar("btntotaldocinfo", true);
	        }
	
	        function setMenuBar(id, flag) {
	            var strCmd, display_Value
	            if (flag)
	                display_Value = ""
	            else
	                display_Value = "none"
	            document.getElementById(id).style.display = display_Value;
	        }
	        var chkReceipt = false;
	        
	        function setRecevInfo(ret) {
	            var precipent = " ";
	            var precipents = " ";
	            var recipflag = true;
	            var xmldom = createXmlDom();
	            xmldom.async = false;
	            xmldom = loadXMLString(ret);
	            var fields = message.GetFieldsList();
	            var field = message.GetListItem(fields, "hrecipients");
	            if (field) setNodeText(field," ");
	            var field = message.GetListItem(fields, "recipient");
	            if (field) setNodeText(field," ");
	            var field = message.GetListItem(fields, "recipients")
	            if (field) setNodeText(field," ");
	            var rows = GetChildNodes(xmldom.documentElement);
	            if (rows.length == 0) {
	                chkReceipt = false;
	                return;
	            }
	            
	            for (i = rows.length - 1; i >= 0; i--) {
	                var row = rows[i];
	                var dataNodes = GetChildNodes(row);
	                
	                if (recipflag) {
	                    if (getNodeText(GetChildNodes(rows[i])[3]) == "Y") {
	                    	if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
	                            precipent = strLangS68;
	                            precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
	                        } else {
								precipent = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
	                            precipents = (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
	                        }
	                        recipflag = false;
	                    }
	                    else {
                    	   if (getNodeText(dataNodes[1]).indexOf(preSusinGroupStr) == 0) {
                               precipent = strLangS68;
                               precipents = getNodeText(dataNodes[0]);
                           } else {
                               precipent = getNodeText(dataNodes[0]);
                               precipents = getNodeText(dataNodes[0]);
                           }
	                        recipflag = false;
	                    }
	                }
	                else {
	                	precipent = strLangS68; // 수신처참조
	                	
	                    if (getNodeText(dataNodes[3]) == "Y")
	                    	precipents = precipents + ", " + (getNodeText(dataNodes[7]) ? getNodeText(dataNodes[7]) + " " : "") + getNodeText(dataNodes[0]);
	                    else {
							precipents = precipents + ", " + getNodeText(dataNodes[0]);
	                    }
	                }
	            }
	            var field = message.GetListItem(fields, "recipient");
	            if (field) {
	                if (precipent == strLangS68) { // 수신처참조
	                    setNodeText(field , precipent);
	                    var field = message.GetListItem(fields, "recipients");
	                    if (field) {
	                        setNodeText(field, precipents);
	                        var field = message.GetListItem(fields, "hrecipients");
	                        if (field)
	                            setNodeText(field , strLangS70); // 수신처:
	                    }
	                }
	                else {
	                    setNodeText(field , precipent);
	                    
	                    if (precipents == "") {
	                        var field = message.GetListItem(fields, "hrecipients");
	                        if (field)
	                            setNodeText(field , " ");
	                        var field = message.GetListItem(fields, "recipients");
	                        if (field)
	                            setNodeText(field , " ");
	                    }
	                }
	            }
	            
	            // SummaryOuterReceiverList는 G버전의 외부수신처 관련 값이므로 제외
	            var field = message.GetListItem(fields, "recipients");
	            if (field) {
	            	var precipentsList = precipents.split(",");
	            	
	            	if (precipentsList.length > 1) {
	                    setNodeText(field , precipents);
	            	}
	            }
	        }
	
	        function btnSend_onclick() {
	            if (!chkReceipt) {
	                var pAlertContent = "<spring:message code='ezApproval.t144'/><br><spring:message code='ezApproval.t159'/>";
	                // OpenInformationUI(pAlertContent, chkReceipt_Complete);
	                showConfirmUI(pAlertContent, chkReceipt_Complete);
	            }
	            else {
	                var pInformationContent = "<spring:message code='ezApproval.t146'/>";
// 	                OpenInformationUI(pInformationContent, Send_Complete, 'resend');
	                showConfirmUI(pInformationContent, Send_Complete);
	            }
	        }
	        
	        function chkReceipt_Complete(RtnVal)
	        {
	        	DivPopUpHidden();
	        	
	            if (RtnVal) {
	                btnApprovalInfo("10");            
	            }
	        }
	        
	        function Send_Complete(RtnVal) {
	        	hideConfirm();
	        	if (!RtnVal) return;
	            //if ("${approvalPWD}" != "N") {
	            if (CheckUsePassword()) {
	                chk_Passwd(chk_Passwd_Complete);
	            }
	            else {
	                chk_Passwd_Complete("TRUE");
	            }
	        }
	
	        function chk_Passwd_Complete(RtnVal) {
	            DivPopUpHidden();
	
	            if (RtnVal == "FALSE") {
	                var pAlertContent = "<spring:message code='ezApproval.t26'/>";
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	            else if (RtnVal == "cancel") {
	                var pAlertContent = "<spring:message code='ezApproval.t27'/>";
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	            
	            var rtnVal = SaveFile();
	            if (rtnVal != "TRUE") {
	                var pAlertContent = "<spring:message code='ezApproval.t131'/>";
	                OpenAlertUI(pAlertContent);
	                return;
	            }
	            var xmlpara = createXmlDom();
	            var xmlhttp = createXMLHttpRequest();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "DOCID", newDocID);
	            createNodeAndInsertText(xmlpara, objNode, "ORGDOCID", pDocID);
	            var fields = message.GetFieldsList();
	            var field = message.GetListItem(fields, "doctitle")
	            createNodeAndInsertText(xmlpara, objNode, "DOCTITLE", trim_Cross(getNodeText(field)));
	            createNodeAndInsertText(xmlpara, objNode, "HTML", "");
	            var href = "/fileroot/<c:out value ='${userInfo.tenantId}'/>/files/upload_approvalG/" + companyID + "/doc/" + CurrYear + "/1000/" + (newDocID % 1000) + "/" + newDocID + ".mht";
	            createNodeAndInsertText(xmlpara, objNode, "HREF", href);
	            createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERID", arr_userinfo[1]);
	            createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERNAME", arr_userinfo[11]);
	            createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERNAME2", arr_userinfo[12]);
	            createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERJOBTITLE", arr_userinfo[13]);
	            createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERJOBTITLE2", arr_userinfo[14]);
	            createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERDEPTID", arr_userinfo[4]);
	            createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERDEPTNAME", arr_userinfo[15]);
	            createNodeAndInsertText(xmlpara, objNode, "SIMSAUSERDEPTNAME2", arr_userinfo[16]);
	            xmlhttp.open("POST", "/ezApprovalG/sendOffer.do", false);
	            xmlhttp.send(xmlpara);
	            
	            if (xmlhttp != null && xmlhttp.readyState == 4) {
	           	 if (xmlhttp.status == 200) {
	           		 var dataNodes = GetChildNodes(loadXMLString(xmlhttp.responseText));
	 	            if (getNodeText(dataNodes[0]) == "TRUE") {
	 	                var rtnVal = SetContainer();
	 	                if (rtnVal == "TRUE") {
	 	                    var title = "";
	 	                    var fields = message.GetFieldsList();
	 	                    var field = message.GetListItem(fields, "doctitle");
	 	                    if (field)
	 	                        title = getNodeText(field);
	 	                    var drafdate = GetDocInfoData("END", "STARTDATE");
	 	                    SendMailToReceiveDept(title, arr_userinfo[2], drafdate, newDocID);
	 	                    var pAlertContent = "<spring:message code='ezApproval.t147'/>";
	 	                    OpenAlertUI(pAlertContent);
	 	                    setBtnDisable();
	 	                }
	 	                else {
	 	                    var pAlertContent = "<spring:message code='ezApproval.t160'/>";
	 	                    OpenAlertUI(pAlertContent);
	 	                }
	 	            }
	           	 } else {
	           		var pAlertContent = "<spring:message code='ezApproval.t131'/>";
	                OpenAlertUI(pAlertContent);
	           	 }
	           } 
	          
	        }
	
	        function setBtnDisable() {
	            document.getElementById("btnOpinion").style.display = "none";
	            document.getElementById("btntotaldocinfo").style.display = "none";
	            document.getElementById("btnSend").style.display = "none";
	            document.getElementById("btnEdit").style.display = "none";
	        }
	        function SaveFile() {
	            if (CheckBlankDoc() == "FALSE")
	                return "FALSE";
	            
	            var mhtBody = "";
	            mhtBody = message.Get_EditorBodyHTML()
	            mhtBody = ConvertHTMLtoMHT(mhtBody);
	            
	            var result = "";
	        	
	        	var data = {
	    			docID : newDocID,
					formId : pFormID,
	    			html  : mhtBody,
	    			orgCompanyID : orgCompanyID
	        	}
	            
	            $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/saveFile.do",
		    		contentType : "application/json",
		    		data : JSON.stringify(data),
		    		success: function(text){
		    			result = text;
		    		}        			
		    	});
	            
	            return result;
	        }
	        function CheckBlankDoc() {
	            var rtnVal = "TRUE";
	            var fields = message.GetFieldsList();
	            var field = message.GetListItem(fields, "doctitle");
	            pDocTitle = getNodeText(field);
	            var mhtData = message.Get_EditorBodyHTML();
	            var pDocMHTSubject = mhtData.substring(mhtData.indexOf("Subject:"), mhtData.indexOf("Date:"));
	            var pDocTitleCheckOn = pDocTitle;
	            if (pDocTitleCheckOn == "HTML to Mime-HTML")
	                rtnVal = "FALSE";
	            if (pDocMHTSubject.replace("Subject:", "").replace(" ", "") == "HTMLtoMime-HTML")
	                rtnVal = "FALSE";
	            return rtnVal;
	        }
	        function SetContainer() {
				var result = "";
		    	
	    		$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/sendOfferAprove.do",
		    		data : {
		    			docID : newDocID,
		    			orgDocID  : pDocID,
		    			userID : pUserID,
		    			userName : arr_userinfo[2],
		    			deptID   : arr_userinfo[4],
		    			userName2: arr_userinfo[12],
		    			type     : "RESEND"
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}, error: function() {
		    			return "FALSE";
		    		}
	    		});
	    		
	            var dataNodes = GetChildNodes(result);
	            return getNodeText(dataNodes[0]);
	        }
	        var ezchkpasswd_cross_dialogArguments = new Array();
	        function chk_Passwd(FunctionName) {
	            var url = "/ezApprovalG/ezchkPasswd.do";
	            ezchkpasswd_cross_dialogArguments[0] = pUserID;
	            ezchkpasswd_cross_dialogArguments[1] = FunctionName;
	            DivPopUpShow(350, 225, url);
	        }
	        // var ezapprovalinfo_dialogArguments = new Array();
	        function btnApprovalInfo(pGubun) {
	            var parameter = new Array();
	            parameter[0] = newDocID;
	            parameter[1] = pFormID;
	            parameter[12] = "SEND"
	            parameter[27] = true;
	
	            // ezapprovalinfo_dialogArguments[0] = parameter;
	            // ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;
		        
	            var url = "/ezApprovalG/ezApprovalInfo.do?guBun=" + pGubun + "&ext=" + "mht";
	            // var result = GetOpenWindow(url, "ezApprovalInfo-" + windowUuid, 1210, 750, "NO");
				ezCommon_cross_dialogArguments[0] = parameter;
				showPopup(url, 1210, 750, "ezApprovalInfo-" + windowUuid, GetOpenWindowfeature(1210, 750), btnApprovalInfo_Complete);
	        }
	        function btnApprovalInfo_Complete(RtnVal)
	        {
	            hidePopup();
				if (RtnVal != undefined && RtnVal[0] == "OK") {
	                chkReceipt = true;
	                btnApprovalInfo_save(RtnVal);
	            }
	        }
	        
	        function btnApprovalInfo_save(ret) {
	        	$.ajax({
            		type : "POST",
            		dataType : "text",
            		async : false,
            		url : "/ezApprovalG/aprDeptSave.do",
            		data : {
            				aprDeptInfo : ret[2]
            				},
            		success : function(result) {
            			 /* 2022-11-04 홍승비 -  전자결재 S버전 > 문서 재발송 팝업창 내부 > 문서 재발송 시 파일 저장 이전, 선택한 수신처에 맞게 현재 결재양식의 수신처명 필드를 갱신하도록 수정 */
            			if (result == 'TRUE') {
            	            try {
            	            	setRecevInfo(ret[5]); // 문서 맵핑용 수신자 정보 (결재정보 팝업창에서 MakertnVal()로 리턴한 값)
            	            } catch (e) {
            	            	console.log(e);
            	            }
            			} else {
            				showAlert(strLangS163 + strLangS164);
            			}
            		}
            	});
	        }
	        
	        function AprDeptParameter(pAprNDeptNumber, pAprDeptFlag) {
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "APRDEPT");
	            createNodeAndInsertText(xmlpara, objNode, "pAprNDeptNumber", pAprNDeptNumber);
	            createNodeAndInsertText(xmlpara, objNode, "pAprDeptFlag", pAprDeptFlag);
	            return xmlpara
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
	<body class="popup" style="overflow: hidden; height: 100%">
	    <table class="layout">
	        <tr>
	            <td style="height: 20px">
	                <div id="menu">
	                    <ul>
	                        <li id="btnOpinion"><span onclick="return btnOpinion_onclick()"><spring:message code='ezApproval.t63'/></span></li>
	                        <li id="btntotaldocinfo"><span onclick="return btnApprovalInfo('10')"><spring:message code='ezApproval.t829'/></span></li>
	                        <li id="btnEdit"><span onclick="return btnEdit_onclick()"><spring:message code='ezApproval.t46'/></span></li>
	                        <li id="btnSend"><span onclick="return btnSend_onclick()"><spring:message code='ezApproval.t155'/></span></li>
	                        <li id="btnPrint"><span onclick="return btnPrint_onclick()"><spring:message code='ezApproval.t67'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li id="btnClose"><span onclick="return btnClose_onclick()"></span></li>
	                    </ul>
	                </div>
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	                </script>
	            </td>
	        </tr>
	        <tr>
	            <td style="padding-bottom: 10px; height: 100%" id="EdtorSize">
	                <div style="height: 100%" id="pz1">
	                    <iframe id="message" class="viewbox" src="/ezApprovalG/enforceContent.do" name="message" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
	
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="height: 20px">
	                <table class="file">
	                    <tr>
	                        <th><spring:message code='ezApproval.t124'/></th>
	                        <td>
	                            <div id="lstAttachLink"></div>
	                        </td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	
	    <script type="text/javascript">
	        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 130 + "PX";
	    </script>
	
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	    <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>
