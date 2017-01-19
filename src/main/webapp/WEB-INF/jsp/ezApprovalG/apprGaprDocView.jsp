<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:97%;">
	<head>
		<title><spring:message code='ezApprovalG.t367'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/AprDocView_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/getDocAttach_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/attachG_Cross.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/appandbody_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/SendMailApprove.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/conn_Cross.js"></script>
		
		
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var	DocID = '${docID}';
		    var	DocHref = '${docHref}';
		    var	OpinionFlag = '${opinionFlag}';
		    var	ListTypeValue = '${listType}';
		    var	ListSusin = '${listSusin}';
		    var pDocState =  '${docState}';
		    var pOrgDocID = '${orgDocID}';
		    var isOpinion = '${isOpinion}';
		    var pDocID;
		    var pDocHref;
		    var pOpinionFlag;
		    var pUserID;
		    var pListTypeValue;
		    var arrPrevDoc = new Array();
		    var arrNextDoc = new Array();
		    var flag = false;
		    var pOrgDocHref;
		    var pDocTitle;
		    var AppendFileAttach = "";
		    var AppenAprDocAttachList = "";
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "${userInfo.id}";
		    arr_userinfo[2]  = "${userInfo.displayName}";
		    arr_userinfo[3]  = "${userInfo.title}";
		    arr_userinfo[4]  = "${userInfo.deptID}";
		    arr_userinfo[5]  = "${userInfo.deptName}";
		    arr_userinfo[6]  = "${userInfo.jikChek}";
		    arr_userinfo[8]  = "${userInfo.email}";
		    arr_userinfo[9]  = "";
		    arr_userinfo[10] = "${susinAdmin}";
		    arr_userinfo[11]  = "${userInfo.displayName1}";
		    arr_userinfo[12]  = "${userInfo.displayName2}";
		    arr_userinfo[13]  = "${userInfo.title1}";
		    arr_userinfo[14]  = "${userInfo.title2}";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";
		    pUserID = arr_userinfo[1];
		    
	        var callBackType = "${callBackType}";
		    var pHasOpinion = "${hasOpinionYN}";
		    var pOpinionType = "Show";
		    var pMailEditor = "${crossEditor}";
		    var NonActiveX = "YES";
		
		    function btnOpinion_onclick() {
		        openOpinionViewUI();
		    }
		    function DocumentComplete() {
		        if (flag == false) {
		            if (DocHref == "") {
		                var pAlertContent = "<spring:message code='ezApprovalG.t1439'/>" + "<br>" + "<spring:message code='ezApprovalG.t440'/>";
		                OpenAlertUI(pAlertContent);
		                btnClose_onclick();
		                return;
		            }
		            if (pDocState == "015" && pOrgDocID.length >= 20 && "${listType}" == "99") {
		                document.getElementById("btnGongRam").style.display = "";
		                pOpinionType = "";
		            }
		            LoadpzFormDocInfo();
		            SignCheck();
		            cancelYN();
		        }
		    }
		    
		    function SignCheck() {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getSignInfo.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(xml){
		    			result = xml;
		    		}
		    	});
		        var SignXML = createXmlDom();
		        
		        if (result == "") {
		            return;
		        }
		        result = loadXMLString(result);
		        var NodeList;
		        NodeList = SelectNodes(result, "SIGNINFOS/SIGNINFO");
		        if (NodeList.length <= 0) {
		            return;
		        }
		        SignXML = result;
		        var rtnVal = putSignXML(SignXML);
		    }
		    
		    function putSignXML(SignXML) {
		        var retVal = false;
		        try {
		            var NodeList;
		            var fields = message.GetFieldsList();
		            var field;
		            NodeList = SelectNodes(SignXML, "SIGNINFOS/SIGNINFO");
		            if (NodeList.length > 0) {
		                for (i = 0; i < NodeList.length; i++) {
		                    var SignType = getNodeText(SelectSingleNode(NodeList[i], "SIGNTYPE"));
		                    var SignName = getNodeText(SelectSingleNode(NodeList[i], "SIGNNAME"));
		                    var SignCont = getNodeText(SelectSingleNode(NodeList[i], "CONTENT"));
		                    var field = GetListItem(fields, SignName);
		                    if (field) {
		                        retVal = true;
		                        if (SignType == "TEXT" ) {
		                            field.textContent = SignCont;
		                        }
		                        else if (SignType == "HTML") {
		                            field.innerHTML = SignCont;
		                        }
		                        else {
		                            var img = SignCont.split("::");
		                            var signWidth = parseInt(field.offsetWidth) - 4 - 15;
		                            var signHeight = parseInt(field.offsetHeight) - 4;
		                            signWidth = 50;
		                            signHeight = 28;
		
		                            var strimg;
		                            if (img.length >= 1) {
		                                strimg = "<img src='" + encodeURI(img[0]) + "' border=0 embedding='1' ";
		                                strimg = strimg + " width=" + signWidth;
		                                strimg = strimg + " height=" + signHeight + " spath='" + encodeURI(img[0]) + "'>";
		                                message.BodySetAttribute(SignName, img[0]);
		                            }
		                            if (img.length >= 2 && img[1] != "") {
		                                field.innerHTML = img[1] + "<br>" + strimg;
		                            }
		                            else {
		                                field.innerHTML = strimg;
		                            }
		                        }
		                    }
		                }
		            }
		        } catch (e) {
		            alert("putSignXML : " + e.description);
		            return false;
		        }
		        return retVal;
		    }
		    
		    var temppDocID;
		    function cancelYN() {
		        temppDocID = pDocID;
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
		    		url : "/ezApprovalG/doCanCelYN.do",
		    		data : {
		    			docID : pDocID,
		    			userID : pUserID
		    		},
		    		success: function(xml){
		    			cancelYN_after(loadXMLString(xml));
		    		}
		    	});
		    }
		    function cancelYN_after(xml) {
		        var RtnVal =  getNodeText(GetChildNodes(xml)[0]);
		        if (RtnVal == "CANCEL" || RtnVal == "CALLBACK") {
		            document.getElementById("tbtncallback").style.display = "";
		         if (callBackType == "CALLBACK") {
		        	 btncallback_onclick();
		         }
		        }
		        else {
		        	var result = "";
		        	
		        	$.ajax({
		        		type : "POST",
		        		dataType : "text",
		        		async : false,
		        		url : "/ezApprovalG/doForceCancelYN.do",
		        		data : {
		        			docID : temppDocID,
		        			userID : pUserID
		        		},
		        		success: function(xml){
		        			
		        			ForcecancelYN_after(loadXMLString(xml));
		        		}
		        	});
		        }
		    }
		    
		      function ForcecancelYN_after(xml) {
			        var RtnVal =  getNodeText(GetChildNodes(xml)[0]);
		            if (RtnVal == "TRUE") {
		                document.getElementById("tbtnforcecallback").style.display = "";

		                if (callBackType == "FORCECALLBACK") {
		                    btncallback_onclick();
		                }
		            }
		        }
		    
		    var PrtBodyContent;
		    function btnPrint_onclick() {
		        PrintClick("Cross", pDocID, "ING");
		    }
		    function btnClose_onclick() {
		        window.close();
		    }
		
		    function btnMail_onclick() {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var pURL = "/ezApprovalG/sendToMailApproval.do?cmd=docsend&docID=" + DocID + "&docHref=" + encodeURIComponent(DocHref);
// 		        var pURL = "/ezEmail/mailWrite.do?docHref=" + encodeURIComponent(DocHref) + "&cmd=docsend&docID=" + DocID + "&imageCnt=&target=APPROVALG";
		        var newwin = window.open(pURL, "mailsend", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width =890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		        newwin.focus();
		    }
		    function btnhistory_onclick() {
		        getHistory();
		    }
		    function btnGongRam_onclick() {
		        var result = "";
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/gongRamUpdate.do",
		    		data : {
		    			docID : DocID,
		    			userID: ListSusin
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}        			
		    	});
		        
		        var dataNodes = GetChildNodes(result);
		        var tempValue = getNodeText(dataNodes[0]);
		
		        if (tempValue == "TRUE") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1441'/>";
		            OpenAlertUI(pAlertContent, OpenAlertUI_Close);
		        }
		    }
		    function OpenAlertUI_Close() {
		        window.close();
		    }
		    window.onbeforeunload = function () {
		        try {
		            window.opener.openergetDocInfo();
		        }
		        catch (e) { }
		        try {
		            window.opener.Refresh_Window();
		        } catch (e) { }
		    };
		    var ezdocinfog_view_cross_dialogArguments = new Array();
		    function btnDocInfo_onclick() {
		        ezdocinfog_view_cross_dialogArguments[0] = "";
		        ezdocinfog_view_cross_dialogArguments[1] = btnDocInfo_onclick_Complete;
		
		        DivPopUpShow(420, 500, "/ezApprovalG/ezDocInfoGView.do?docID=" + DocID + "&ingFlag=APR");
		    }
		    function btnDocInfo_onclick_Complete() {
		        DivPopUpHidden();
		    }
		    function FieldsAvailable() {
		        message.SetEditable(false);
		    }
		
		    var totalsavefileinfo_dialogArguments = new Array();
		    function TotalSave_onclick() {
		        totalsavefileinfo_dialogArguments[0] = "";
		        totalsavefileinfo_dialogArguments[1] = TotalSave_onclick_Complete;
		
		        DivPopUpShow(600, 450, "/ezApprovalG/totalSaveFileInfo.do?docID=" + pDocID + "&type=APR");
		    }
		    function TotalSave_onclick_Complete() {
		        DivPopUpHidden();
		    }
		    
		    function btncallback_onclick() {
	            OpenInformationUI("<spring:message code='ezApprovalG.t815'/>", btncallback_onclick_Complete);
	        }
	        function btncallback_onclick_Complete(ans) {
	            if (ans && ConnExist("DRAFT_CALLBACK", "")) {
	                var RtnVal = ExcuteInfo("DRAFT_CALLBACK", "")
	                if (RtnVal) {
	                    doCancel();
	                }
	            }
	            else
	                doCancel();
	        }
	        function doCancel() {
	            var GetCurrentlinelist = getAprLinefor("APR", DocID);
	        	var result = "";
	        	
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : false,
	        		url : "/ezApprovalG/doCancel.do",
	        		data : {
	        			docID : pDocID,
	        			userID : pUserID
	        		},
	        		success: function(xml){
	        			result = xml;
	        		}
	        	});
	            var RtnVal = getNodeText(GetChildNodes(loadXMLString(result))[0]);
	            if (RtnVal == "TRUE") {
	            	SendMailToCancel_Function(GetCurrentlinelist);
                    var pAlertContent = strLang891 + "<br> " + strLang892;
                    OpenAlertUI(pAlertContent, OpenAlertUI_Close);
	            }
	            else if (RtnVal == "ERR01") {
	                var pAlertContent = strLang483;
	                OpenAlertUI(pAlertContent);
	            }
	            else if (RtnVal == "ERR02") {
	                var pAlertContent = strLang484;
	                OpenAlertUI(pAlertContent);
	            }
	            else if (RtnVal == "ERR03") {
	                var pAlertContent = strLang485;
	                OpenAlertUI(pAlertContent);
	            }
	            else {
	                var pAlertContent = strLang486;
	                OpenAlertUI(pAlertContent);
	            }
	        }
	        
	        function SendMailToCancel_Function(GetCurrentlinelist) {
	            var MemberList = loadXMLString(GetCurrentlinelist)
	            var pDocTitle = GetDocTitleInfoData("APR", "DOCTITLE");
	            var objNodes = SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW");
	            g_szUserID = pUserID;
	            g_senderinfo = "";
	            for (i = 0; i < objNodes.length; i++) {
	                var nowstate = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW")[i])[0])[12]);
	                var LineUserID = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW")[i])[0])[4]);
	                var LineSN = getNodeText(GetChildNodes(GetChildNodes(SelectNodes(MemberList, "LISTVIEWDATA/ROWS/ROW")[i])[0])[0]);
	                if (nowstate == "002" || nowstate == "003") {
	                    if (LineSN != "1") {
	                        sendmail(LineUserID, pDocTitle, arr_userinfo[2], js_yyyy_mm_dd_hh_mm_ss(), "callback", "", true)
	                    }
	                }

	            }
	        }
	        
	        function GetDocTitleInfoData(mode, filed) {
	            try {
	                var value = "";
	                var xmlpara = createXmlDom();
	                var objNode;
	                
	                createNodeInsert(xmlpara, objNode, "PARAMETER");
	                createNodeAndInsertText(xmlpara, objNode, "DocID", pDocID);
	                createNodeAndInsertText(xmlpara, objNode, "mode", mode);
	                createNodeAndInsertText(xmlpara, objNode, "fields", filed);

	                var xmlhttp = createXMLHttpRequest();
	                xmlhttp.open("Post", "/ezApprovalG/GetDocInfoMode.do", false);
	                xmlhttp.send(xmlpara);

	                var xmlDocument = createXmlDom();
	                xmlDocument = loadXMLString(xmlhttp.responseText);

	                var objNodes = GetChildNodes(xmlDocument.documentElement);

	                if (objNodes) {
	                    if (objNodes.length > 0) {
	                        value = getNodeText(objNodes[0]);
	                    }
	                }
	                return value;
	            }
	            catch (e) { }
	        }
	        
	        function js_yyyy_mm_dd_hh_mm_ss() {
	            now = new Date();
	            year = "" + now.getFullYear();
	            month = "" + (now.getMonth() + 1); if (month.length == 1) { month = "0" + month; }
	            day = "" + now.getDate(); if (day.length == 1) { day = "0" + day; }
	            hour = "" + now.getHours(); if (hour.length == 1) { hour = "0" + hour; }
	            minute = "" + now.getMinutes(); if (minute.length == 1) { minute = "0" + minute; }
	            second = "" + now.getSeconds(); if (second.length == 1) { second = "0" + second; }
	            return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second;
	        }
	        
	        function RemoveDoc_Complete() {
	            try { window.opener.getDocList(); } catch (e) { }
	            window.close();
	        }
		</script>
	</head>
	<body class="popup" style="height:100%">
		<table class="layout">
		  <tr>
		    <td style="height:20px" ><div id="menu">
		        <ul>
		          <li id="btnGongRam" style="display:none"><span onclick ="return btnGongRam_onclick()" ><spring:message code='ezApprovalG.t1720'/></span></li>
		          <li id="btnMail"><span onClick="return btnMail_onclick()" ><spring:message code='ezApprovalG.t1513'/></span></li>
		          <li id="btnOpinion"><span onClick="return btnOpinion_onclick()" ><spring:message code='ezApprovalG.t55'/></span></li>
		          <li id="btnPrint" ><span  onClick="return btnPrint_onclick()" ><spring:message code='ezApprovalG.t60'/></span></li>
		          <li id="btnDocInfo"><span onClick="return btnDocInfo_onclick()" ><spring:message code='ezApprovalG.t54'/></span></li>
		          <li id="btnhistory"><span onClick="btnhistory_onclick()" ><spring:message code='ezApprovalG.t61'/></span></li>
		          <li id="tbtnTotalSave"><span id="btnTotalSave" onclick="return TotalSave_onclick()"><spring:message code='ezApprovalG.t00008'/></span></li>
		          <li id="tbtncallback" style="display: none;"><span id="btncallback" onclick="return btncallback_onclick()"><spring:message code='ezApprovalG.t66'/></span></li>
                  <li id="tbtnforcecallback" style="display: none;"><span id="btnforcecallback" onclick="return btncallback_onclick()"><spring:message code='ezApprovalG.t2005'/></span></li>
		        </ul>
		      </div>
		      <div id="close">
		        <ul>
		          <li id="btnClose"><span onClick="return btnClose_onclick()"><spring:message code='ezApprovalG.t64'/></span></li>
		        </ul>
		      </div></td>
		  </tr>
		  <tr>
		    <td style="vertical-align:top;height:90%;">
		            <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox"  src="aprDocViewContent.do" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
		    </td>
		  </tr>
		  <tr>
		    <td style="height:20px"><table class="file" style="margin-top:5px;">
		        <tr>
		          <th><spring:message code='ezApprovalG.t65'/></th>
		          <td><div id="lstAttachLink"></div></td>
		        </tr>
		      </table></td>
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