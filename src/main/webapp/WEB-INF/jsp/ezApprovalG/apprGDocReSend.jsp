<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE HTML>
<html style="height: 97%">
	<head>
	    <title><spring:message code='ezApproval.t157'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getDocAttach_Cross.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/SendMailApprove.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/appandbody_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/ezDraftCK_Common.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/Common_Function.js"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var pDocID = '${docID}';
	        var pDocHref = '${docHref}';
	        var pFormID = '${formID}';
	        var pOpinionFlag;
	        var pUserID;
	        var flag = false;
	        var modeflag = false;
	        var newDocID = "";
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "${userInfo.id}";
	        arr_userinfo[2] = "${userInfo.displayName}";
	        arr_userinfo[3] = "${userInfo.title}";
	        arr_userinfo[4] = "${userInfo.deptID}";
	        arr_userinfo[5] = "${userInfo.deptName}";
	        arr_userinfo[6] = "${userInfo.jikChek}";
	        arr_userinfo[8] = "${userInfo.email}";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "${susinAdmin}";
	        arr_userinfo[11] = "${userInfo.displayName1}";
	        arr_userinfo[12] = "${userInfo.displayName2}";
	        arr_userinfo[13] = "${userInfo.title1}";
	        arr_userinfo[14] = "${userInfo.title2}";
	        arr_userinfo[15] = "${userInfo.deptName1}";
	        arr_userinfo[16] = "${userInfo.deptName2}";
	        var companyID = "${userInfo.companyID}";
	        var pUserID = arr_userinfo[1];
	        var CurrYear = "${oldYear}";
	        var g_szUserID = arr_userinfo[8];
	        var g_senderinfo = "${userInfo.companyName}" + ", " + "${userInfo.deptName}" + ", " + "${userInfo.title}";
	        var pUse_Editor = "${useEditor}";
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        window.onload = function () {
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
	        function btnClose_onclick() {
	            window.close();
	        }
	        
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
	                alert("createNewDoc()" + e.description);
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
	                setNodeText(btnEdit.childNodes.item(0) , "<spring:message code='ezApproval.t44'/>");
	            }
	            else {
	                var pInformationContent = "<spring:message code='ezApproval.t45'/>";
	                OpenInformationUI(pInformationContent, Edit_Complete);
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
	                        precipent = getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
	                        precipents = getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
	                        recipflag = false;
	                    }
	                    else {
	                        precipent = getNodeText(dataNodes[0]);
	                        precipents = getNodeText(dataNodes[0]);
	                        recipflag = false;
	                    }
	                }
	                else {
	                    precipent = "<spring:message code='ezApproval.t128'/>"
	                    if (getNodeText(dataNodes[3]) == "Y")
	                        precipents = precipents + "," + getNodeText(dataNodes[7]) + " " + getNodeText(dataNodes[0]);
	                    else {
	                        precipents = precipents + "," + getNodeText(dataNodes[7]);
	                    }
	                }
	            }
	            var field = message.GetListItem(fields, "recipient")
	            if (field) {
	                if (precipent == "<spring:message code='ezApproval.t128'/>") {
	                    setNodeText(field , precipent);
	                    var field = message.GetListItem(fields, "recipients")
	                    if (field) {
	                        setNodeText(field, precipents);
	                        var field = message.GetListItem(fields, "hrecipients")
	                        if (field)
	                            setNodeText(field , "<spring:message code='ezApproval.t129'/>");
	                    }
	                    else {
	                        var field = message.GetListItem(fields, "recipient")
	                        setNodeText(field , precipents);
	                    }
	                }
	                else {
	                    setNodeText(field , precipent);
	                    if (precipents == "") {
	                        var field = message.GetListItem(fields, "hrecipients")
	                        if (field)
	                            setNodeText(field , " ");
	                        var field = message.GetListItem(fields, "recipients")
	                        if (field)
	                            setNodeText(field , " ");
	                    }
	                }
	            }
	            var field = message.GetListItem(fields, "recipients")
	            if (field) {
	                setNodeText(field , precipents);
	            }
	        }
	
	        function btnSend_onclick() {
	            if (!chkReceipt) {
	                var pAlertContent = "<spring:message code='ezApproval.t144'/><br><spring:message code='ezApproval.t159'/>";
	                OpenInformationUI(pAlertContent, chkReceipt_Complete);
	            }
	            else {
	                var pInformationContent = "<spring:message code='ezApproval.t146'/>";
	                OpenInformationUI(pInformationContent, Send_Complete);
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
	            if (!RtnVal) return;
	            if ("${approvalPWD}" != "N") {
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
	            var href = "/fileroot/${userInfo.tenantId}/files/upload_approvalG/" + companyID + "/doc/" + CurrYear + "/1000/" + (newDocID % 1000) + "/" + newDocID + ".mht";
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
	           	 if (xmlhttp.statusText == "OK") {
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
	            
	            $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/saveFile.do",
		    		data : {
		    			docID : newDocID,
		    			html  : mhtBody
		    		},
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
	            DivPopUpShow(330, 200, url);
	        }
	        var ezapprovalinfo_dialogArguments = new Array();
	        function btnApprovalInfo(pGubun) {
	            var parameter = new Array();
	            parameter[0] = newDocID;
	            parameter[1] = pFormID;
	            parameter[12] = "SEND"
	            parameter[27] = true;
	
	            ezapprovalinfo_dialogArguments[0] = parameter;
	            ezapprovalinfo_dialogArguments[1] = btnApprovalInfo_Complete;
		        
	            var url = "/ezApprovalG/ezApprovalInfo.do?guBun=" + pGubun + "&ext=" + "mht";
	            var result = GetOpenWindow(url, "ezApprovalInfo", 1130, 750, "NO");
	        }
	        function btnApprovalInfo_Complete(RtnVal)
	        {
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
            		success : function(result){
            			if (result == 'TRUE') {
            				
            			} else {
            				alert(strLangS163 + strLangS164);
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