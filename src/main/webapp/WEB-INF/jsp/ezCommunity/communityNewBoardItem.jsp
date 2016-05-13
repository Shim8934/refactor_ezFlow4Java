<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1'/>"></script>
		<script type="text/javascript" src="/js/ezCommunity/ConvertSaveImage.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/AttachMain_CK.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/AttachItem_CK.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
		<script type="text/javascript" src="/js/rsa/asn1.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<!-- data picker -->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css"/>
        <script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
        <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
        <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="/js/jquery/dateControls/demos.css"/>
		<!-- time picker -->
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css"/>
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>

		<c:choose>
			<c:when test="${mode == 'new' || url != ''}">
				<title><spring:message code='ezCommunity.t1128'/></title>
			</c:when>
			<c:when test="${mode == 'reply' }">
				<title><spring:message code='ezCommunity.t1129'/></title>
			</c:when>
			<c:otherwise>
				<title><spring:message code='ezCommunity.t1130'/></title>
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
// 			변수
			var strStartDate = "";
			var mode = "${mode}";
			var url = "${url}";
			
			var flag = false;

			window.onload = function () {
		        initKey();
		        if(navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1){
		            document.getElementById("file1").multiple = false;
		        }
										
		        if (pReservedItem != "true") {
		        	document.getElementById("reservation_date").style.display = "none";
		        }
							
		        if(pMode == "modify" && strAttachments != "") {
		            pAttachListXml = MakeAttachList();
		            AppendFileAttachInfo(pAttachListXml);
		        }
					
		        if(pMode == "new") {
		            btn_PostDate_Clear();
		        } else {
		            if (pReservedItem != "true") {
		            	$("#Sdatepicker").datepicker('setDate', "");
		            }
		        }
							
							
		        if (ExpireDays == -1) {
		        	document.getElementById('Makedate').style.display = "none";
		        }
							
		        if( pMode == "modify") {												
		            document.getElementById("txtTitle").value  = "${strTitle}";
		            document.getElementById("txtAbstract").value = "${strAbstract}";
		        }
							
		        if (pMode == "reply") {
		            document.getElementById("txtTitle").value = "${strTitle}";
		        }
		        
		        ChkPermanent();
		    }
			
			$(function(){
				$("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
				
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        	
		        var settime;
		        var NowDate;
		        
		        if(strStartDate  == "") {
		            settime = "${startDateTime}";
		        } else {
		            settime = strStartDate;
		        }
		        
		        NowDate = new Date(settime.substring(0, 4), settime.substring(5, 7), settime.substring(8, 10), settime.substring(11, 13), settime.substring(14, 16));
		        NowDate.setMonth(NowDate.getMonth() - 1);

		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', NowDate);
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });

		        var NowDate2 = new Date();
		        NowDate2.setMonth(NowDate2.getMonth() + 1);
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', NowDate2);
		        
		        if("${userInfo.lang == '1'}"){
					$.datepicker.regional['ko'] = {
		            	closeText: '닫기',
		            	prevText: '이전달',
		            	nextText: '다음달',
		            	currentText: '오늘',
		            	monthNames: ['1월', '2월', '3월', '4월', '5월', '6월',
		            	'7월', '8월', '9월', '10월', '11월', '12월'],
		            	monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월',
		            	'7월', '8월', '9월', '10월', '11월', '12월'],
		            	dayNames: ['일', '월', '화', '수', '목', '금', '토'],
		            	dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
		            	dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		            	weekHeader: 'Wk',
		            	dateFormat: 'yy-mm-dd',
		            	firstDay: 0,
		            	isRTL: false,
		            	duration: 200,
		            	showAnim: 'show',
		            	showMonthAfterYear: true
		        	};
		        	
		        	$.datepicker.setDefaults($.datepicker.regional['ko']);
				} else {
					$.datepicker.regional['en'] = {
			            dateFormat: 'yy-mm-dd',
		    	        firstDay: 0,
		        	    isRTL: false,
		            	duration: 200,
		            	showAnim: 'show',
		            	showMonthAfterYear: true
		        	};
		        	
		        	$.datepicker.setDefaults($.datepicker.regional['en']);
				}
			});
			
			if("${userInfo.lang == '1'}"){
				$.datepicker.regional['ko'] = {
	            	closeText: '닫기',
	            	prevText: '이전달',
	            	nextText: '다음달',
	            	currentText: '오늘',
	            	monthNames: ['1월', '2월', '3월', '4월', '5월', '6월',
	            	'7월', '8월', '9월', '10월', '11월', '12월'],
	            	monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월',
	            	'7월', '8월', '9월', '10월', '11월', '12월'],
	            	dayNames: ['일', '월', '화', '수', '목', '금', '토'],
	            	dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
	            	dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
	            	weekHeader: 'Wk',
	            	dateFormat: 'yy-mm-dd',
	            	firstDay: 0,
	            	isRTL: false,
	            	duration: 200,
	            	showAnim: 'show',
	            	showMonthAfterYear: true
	        	};
	        	
	        	$.datepicker.setDefaults($.datepicker.regional['ko']);
			} else {
				$.datepicker.regional['en'] = {
		            dateFormat: 'yy-mm-dd',
	    	        firstDay: 0,
	        	    isRTL: false,
	            	duration: 200,
	            	showAnim: 'show',
	            	showMonthAfterYear: true
	        	};
	        	
	        	$.datepicker.setDefaults($.datepicker.regional['en']);
			}
			
			function DateFormat(obj) {
	            var yy = String(obj.getFullYear()).substring(0, 4);
	            var mm;
	            var dd;
	            
	            if (String(obj.getMonth() + 1).length == 1) {
	                mm = "0" + (obj.getMonth() + 1);
	            } else {
					mm = obj.getMonth() + 1;
	            }
	            
	            if (String(obj.getDate()).length == 1) {
	                dd = "0" + obj.getDate();
	            } else {
	                dd = obj.getDate();
	            }
	            
	            var date = String(yy) + "-" + String(mm) + "-" + String(dd);
	            
	            return date;
	        }

	        function MakeAttachList() {
	            var xmlhttp = createXMLHttpRequest();
	            var xmldom = createXmlDom();
	            var str = "";
	            var i=0;
	            var pos = 0;
	            var filename = "";
	            var filepath = "";

	            xmlhttp.open("POST", "/ezCommunity/getItemAttachments.do?itemID=" + strItemID, false);
	            xmlhttp.send();

	            xmldom.async = false;
	            xmldom.preserveWhiteSpace = true;
	            xmldom = loadXMLString(xmlhttp.responseText);
	            xmlhttp = null;
				
	            var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");

	            str += "<LISTVIEWDATA><HEADERS><HEADER><NAME><spring:message code='ezCommunity.t1135' /></NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME><spring:message code='ezCommunity.t1136'/></NAME><WIDTH>50</WIDTH></HEADER></HEADERS><ROWS>";
			
	            for(i=0;i<xmldomNodes.length;i++) {
	                filepath = SelectSingleNodeValue(xmldomNodes[i], "FilePath");
	                filename = filepath.substr(89, filepath.length - 88);
	                filepath = "/Upload_Community/" + filepath;		
	                str += "<ROW><CELL>";	
	                str += "<VALUE>" + filename + "</VALUE>";
	                str += "<DATA1>" + filepath + "</DATA1>";
	                str += "<DATA2>" + SelectSingleNodeValue(xmldomNodes[i], "FilePath") + "</DATA2>";
	                str += "<DATA3></DATA3>";
	                str += "<DATA4></DATA4>";
	                str += "<DATA5>Y</DATA5>";
	                str += "<DATA6>" + SelectSingleNodeValue(xmldomNodes[i], "FileSize2") + "</DATA6>";
	                str += "</CELL>";
	                str += "<CELL><VALUE></VALUE>";
	                str += "</CELL></ROW>";
	            }
	            
	            str += "</ROWS></LISTVIEWDATA>";
	            return str;
	        }

	        function GetStartDate() {
	            var pReservationTime = "";
	            
	            if ($('#Sdatepicker').val() && document.getElementById("chk_reservation").checked) {
	                if ($('#Stimepicker').val()) {
	                    pReservationTime = $('#Sdatepicker').val() + " " + $('#Stimepicker').val() + ":00";
	                } else {
	                    pReservationTime = $('#Sdatepicker').val() + " 00:00:00";
	                }
	            }
	            
	            return pReservationTime;
	    	}

		    function GetEndDate() {
		        var pEndDateTime;
		        
		        if (document.getElementById("ChkPermanence").checked) {
		            pEndDateTime = "9999-12-30 23:59:59"
		        } else {
		            if ((pMode == "modify" || pMode == "temp") && $('#Edatepicker').val().substring(0, 4) != "9999") {
		                pEndDateTime = $('#Edatepicker').val() + strEndDate.substring(10, 19);
		            } else {
		                pEndDateTime = $('#Edatepicker').val() + strNow.substring(10, 19);
		            }
		        }
		        
		        return pEndDateTime;
		    }
	
		    function SaveItem() {
		        unloadflag ="1";
		        if(MHTLoadComplete != "true") {
		            alert("<spring:message code='ezCommunity.t1138'/>");		
		            return;
		        }
							
		        var strXML = "";
		        var newID = "";
		        var pStartDate = GetStartDate();
		        var pEndDate = GetEndDate();
	
		        if (document.getElementById("chk_reservation").checked && pStartDate == "")  {
		            alert("<spring:message code='ezCommunity.t1139'/>");
		            return;
		        }
							
		        if (pStartDate != "" && pStartDate < strNow) {
		            alert("<spring:message code='ezCommunity.t1140'/>");
		            return;
		        }
	
		        if (pEndDate != "" && pEndDate < strNow) {
		            alert("<spring:message code='ezCommunity.t1141'/>");
		            return;
		        }
							
		        if (pStartDate != "" && pEndDate != "" && pEndDate < pStartDate) {
		            alert("<spring:message code='ezCommunity.t1142'/>");
		            return;
		        }
	
		        if (document.getElementById("txtTitle").value == "") {
		            alert("<spring:message code='ezCommunity.t1143'/>");
		            txtTitle.focus();
		            return;				
		        }
							
		        if (gubun == "2" && document.getElementById('txtPassWord').value == "") {
		            alert("<spring:message code='ezCommunity.t1144'/>");
		            txtPassWord.focus();
		            return;
		        }
							
		        if (pStartDate == "" && pReservedItem == "TRUE") {
		            strParentWriteDate = "";
		        }
	
		        newID = "{" + GetGUID().toUpperCase() + "}";
		        var xmlDom = createXmlDom();
		        var xmlhttp = createXMLHttpRequest();
							
	
	
		        var objNode, objSubNode, objDataNode;
		        objNode = createNodeInsert(xmlDom, objNode, "NODES");
		        objSubNode = createNodeAndAppandNode(xmlDom, objNode,objSubNode, "NODE");
		        
		        if(pMode != "modify") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMID", newID);
		        } else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMID", strItemID);
		        }
	
		        var importance = "";
		        if(chkEmergent.checked) {
		            importance = "1";
	
		        } else {
		            importance = "0";
		        }
		        
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "BOARDID", pBoardID);
		        
		        if (gubun != "2") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERID", SSUserID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME", SSUserName);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME2", SSUserName2);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTID", SSDeptID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME", MakeXMLString(SSDeptName));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME2", MakeXMLString(SSDeptName2));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYID", SSCompanyID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME", MakeXMLString(SSCompanyName));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME2", MakeXMLString(SSCompanyName2));
		        } else {
		            var nickname = txtNickName.value;
		            
		            if (nickname == "") {
		            	nickname = "<spring:message code='ezCommunity.t929'/>";
		            }
		            
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERID", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME", MakeXMLString(nickname));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME2", MakeXMLString(nickname));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTID", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME2", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYID", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME2", "");
		        }
	
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "IMPORTANCE", importance);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TITLE", MakeXMLString(document.getElementById("txtTitle").value));
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "STARTDATE", pStartDate);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ENDDATE", pEndDate);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ABSTRACT",  MakeXMLString(document.getElementById("txtAbstract").value));
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ATTACHMENTS", MakeXMLString(AttachFileList()));
	
		        if(pMode == "new" || pUrl != "") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", newID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", "1");
		        } else if(pMode == "modify" && pReservedItem == "") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", strUpperItemIDTree);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", strParentWriteDate);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", strItemLevel);	
		        } else if(pMode == "modify" && pReservedItem == "true") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", strUpperItemIDTree);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", pStartDate);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", strItemLevel);		
		        } else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", strUpperItemIDTree);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", strParentWriteDate);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", strItemLevel);
		        }
	
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "FILEPATH", pUploadFilePath);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE1", "");
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE2", "");
		        
		        if (gubun != "2") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE3", strUserRank);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE32", strUserRank2);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE4", strUserPhone);
		        } else {
	
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE3", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE32", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE4", "");
		        }
		        
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE5", "");		
		        var obj = GetBODY(document.getElementById('docContent')).getElementsByTagName("TD")
		        
		        for (i = 0; i < obj.length; i++) {
		            if (obj[i].free == "") {
		            	obj[i].removeAttribute('free');
		            }
		            
		            if (obj[i].className == "FIELD") {
		            	obj[i].removeAttribute('className');
		            }
		        }
	
		        if (pDocID != "") {
		        	message.SetEditorContent(message.GetEditorContent() + "<hr><br/><div contenteditable='false' >" + GetBODY(document.getElementById('docContent')).innerHTML) + "</div>";
		        }
		            
		        JSleep(1000);
		        var strBody = message.GetEditorContent();
		        
		        if (trim_Cross(strBody) != "" || pDocID == "") {
		            strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + EmbedContentIntoXML(strBody) + "</BODY>" + "</HTML>");
		        } else {
		            if (pDocID == "") {
		            	strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + EmbedContentIntoXML(strBody) + "</BODY>" + "</HTML>");
		            } else {
		                var tempstr = strBody + "<hr><br/>" + GetBODY(document.getElementById('docContent')).innerHTML;
		                strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + EmbedContentIntoXML(tempstr) + "</BODY>" + "</HTML>");
		            }
		        }
		        
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "CONTENT", strBody);	
	
		        if (gubun == "2") {
		        	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DOCPASSWORD", Crypt_Encrytion(document.getElementById('txtPassWord').value));
		        } else {
		        	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DOCPASSWORD","");
		        }
												
		        xmlhttp.open("POST", "/ezCommunity/saveItem.do?mode="+ pMode , false);
		        xmlhttp.send(xmlDom);					

		        if (getNodeText(GetChildNodes(loadXMLString(xmlhttp.responseText))[0]) == "OK") {
		            xmlhttp = null;
		            xmldom = null;
		            if (document.getElementById("chk_reservation").checked == false) {										
		                if (strItemID == "") {
		                    xmlhttp = createXMLHttpRequest();
		                    xmlhttp.open("POST", "/ezCommunity/sendPostNoticeMail.do?boardID=" + pBoardID + "&itemID=" + newID, false);
		                    xmlhttp.send();
		                    xmlhttp = null;
		                }
		                
		                if (pMode == "reply") {
		                    xmlhttp = createXMLHttpRequest();
		                    xmlhttp.open("POST", "/ezCommunity/sendReplyNoticeMail.do?boardID=" + pBoardID + "&itemID=" + newID + "&itemTreeID=" + strUpperItemIDTree, false);
		                    xmlhttp.send();
		                    xmlhttp = null;
		                }
		                
		                alert("<spring:message code='ezCommunity.t282'/>");
					} else {
		                alert("<spring:message code='ezCommunity.t1150'/>" + pStartDate.substr(0, 16) + "<spring:message code='ezCommunity.t1151'/>");
		            }
		            
		            try {
		                window.opener.location.reload(true);
		            } catch(e) {
		            }
		            
		            window.close();		
		        } else {
		            alert("<spring:message code='ezCommunity.t283'/>" + getNodeText(loadXMLString(xmlhttp.responseText)));
		        }
		        
		        xmlhttp = null;
		        xmldom = null;
		    }
	
		    function JSleep(sTime) {
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "aspx/userSleep.aspx?time=" + sTime, false);
		        xmlhttp.send();
		        xmlhttp = null;
		    }
	
		    function ReplaceText( orgStr, findStr, replaceStr ) {
		        var re = new RegExp( findStr, "gi" );
		        return ( orgStr.replace( re, replaceStr ) );
		    }
	
		    function MakeXMLString(str) {
		        str = ReplaceText(str, "&", "&amp;");
		        str = ReplaceText(str, "<", "&lt;");
		        str = ReplaceText(str, ">", "&gt;");
		        return str;
		    }
	
		    function btn_PostDate_Clear() {
		        if(strStartDate  == "") {
		        	settime = "${startDateTime}";
		        } else {
		        	settime = strStartDate;
		        }
		        
		        NowDate = new Date(settime.substring(0, 4), settime.substring(5, 7), settime.substring(8, 10), settime.substring(11, 13), settime.substring(14, 16));
		        NowDate.setMonth(NowDate.getMonth() - 1);
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', NowDate);
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
		    }
	
		    function ChkPermanent() {
		        if (document.getElementById("ChkPermanence").checked) {
		            document.getElementById("Makedate").style.display = "none";
		        } else {
		            document.getElementById("Makedate").style.display = "";
		            
		            if(strEndDate != "") {
		                if(strEndDate.substring(0, 4) == "9999") {
		                    var NowDate2 = new Date();
		                    NowDate2.setMonth(NowDate2.getMonth() + 1);
		                    $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		                    $("#Edatepicker").datepicker('setDate', NowDate2);
		                } else {
		                    var NowDate = new Date(strEndDate.substring(0, 4), strEndDate.substring(5, 7), strEndDate.substring(8, 10), strEndDate.substring(11, 13), strEndDate.substring(14, 16));
		                    NowDate.setMonth(NowDate.getMonth() - 1);
	
		                    $("#Edatepicker").datepicker('setDate', NowDate);
		                }
		            }
		        }
		    }
	
		    function Reservation_onclick() {
		        if (document.getElementById("chk_reservation").checked == true)  {
		            document.getElementById("reservation_date").style.display = "";
		        } else {
		            document.getElementById("reservation_date").style.display = "none";
		        }
		    }
						
		    function PreviewItem() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 720) / 2;
		        var pLeft = (pwidth - 765) / 2;
							
		        window.open("BoardItemPreView.aspx?gubun=" + gubun, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");	
		    }
					
		    function AddDate(pDate,  pDays) {
		        var dt = new Date(pDate);
		        dt.setDate(dt.getDate() + pDays);
		        return dt;
		    }
						
		    function AutoAddtoExpireDate() {
		        var temp = ExpireDays;
		        if (temp == -1) temp = 30;
							
		        idDatepicker.vtLocalEndDate = AddDate(idDatepicker.vtLocalDate, temp);			
		    }
						
		    function LoadFromPC() {
		        if(gubun!="3") {
		            pModeOld = "loadpc";		   
		            var returnValue = pzFormProc.FileOpenDlg("");
		            
		            if( returnValue==false ) {						
		                pModeOld = "";
		            }
		        }	
		    }
	
		    function SelectBoard() {
		        var url	= "BoardSelect_Cross.aspx";
		        var feature = "status:no;dialogWidth:340px;dialogHeight:656px;help:no;scroll:no;edge:sunken";
		        feature = feature + GetShowModalPosition(340, 656);
		        var ret = window.showModalDialog(url, "", feature);	
							
		        if (typeof(ret) == "undefined") {
		        	return "";
		        }
		        
		        return ret;			
		    }
						
		    function InsertMailInfo() {
		        var strQuery = "<URL>" + pUrl + "</URL>";
						 	
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("POST", "/myoffice/ezEmail/remote/mail_interread.aspx", false);
		        xmlHTTP.send(strQuery);
	
		        if (xmlHTTP.status == 200) {
		            document.getElementById('txtTitle').value = "<spring:message code='ezCommunity.t1152'/>" + getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("SUBJECT").item(0));
	
		            var Content = "<P>&nbsp;<br></P><br><DIV><br><br>-----<B>[&nbsp;<spring:message code='ezCommunity.t1153'/></B>-----</DIV><DIV><B><spring:message code='ezCommunity.t411'/></B>" + getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("DATE").item(0)) + "</DIV>";
		            
		            if (getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("COMMENT").item(0)) != "") {
		                Content = Content + "<DIV><B><spring:message code='ezCommunity.t1155'/></B>" + ReplaceText(getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("FROMNAME").item(0)), "\\\"", "");
		                Content = Content + "  (" + getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("COMMENT").item(0)) + ") </DIV>";
					} else {
						Content = Content + "<DIV><B><spring:message code='ezCommunity.t1155'/></B>" + ReplaceText(ReplaceText(getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("FROMNAME").item(0)), "<", "&lt"), ">", "&gt;") + "</DIV>";
					}
		            
		            Content = Content + "<DIV><B><spring:message code='ezCommunity.t885'/></B>" + getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("SUBJECT").item(0)) + "</DIV><P><br><br>" + getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("HTMLDESCRIPTION").item(0)) + "</P>";
		            Content = ReplaceText(Content, "id=doctitle", "");
		            Content = ReplaceText(Content, "id=\"doctitle\"", "");
		            Content = ReplaceText(Content, "id=\'doctitle\'", "");
		            message.SetEditorContent(Content);
	
		            var ret = "";
								
		            while (ret == "") {
		                ret = SelectBoard();
		                
		                while (ret == "") {
		                    if (confirm("<spring:message code='ezCommunity.t1156'/>")) {
								return -1;
							}
		                    
							ret = SelectBoard();
						}
					}

                    pBoardID = ret;
                    GetBoardInfo();
                    InitializeSettings();
		
                    if (loadXMLString(xmlHTTP.responseText).getElementsByTagName("ATTACHMENT").length > 0) {
						var attachHTTP = createXMLHttpRequest();
						var filefullpath = "";
						var fileList = "";
						
						for (var i = 0; i < loadXMLString(xmlHTTP.responseText).getElementsByTagName("ATTACHMENT").length; i++) {
						    FileName = getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("ATTACHMENT").item(i));
						    FileURL = getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("ATTACHMENTURL").item(i));
						    ItemID = getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("ITEMID").item(0));
						    attachHTTP.open("POST", document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/remote/mail_downloadattachfile.aspx?mode=Attach&ID=" + encodeURIComponent(ItemID) + "&ATTID=" + encodeURIComponent(FileURL) + "&filepath=" + pUploadFilePath + "\\" + pBoardID + "\\UploadFile" + "&NewGuid=" + NewGuid, false);
						    attachHTTP.send();
						    
						    filefullpath = pUploadFilePath + "\\" + pBoardID + "\\UploadFile\\" + NewGuid + "_" + FileName;
						    var fileHTTP = createXMLHttpRequest();
						    fileHTTP.open("POST", "interASP/getFileSize.aspx?filepath=" + encodeURIComponent(filefullpath), false);
						    fileHTTP.send();
						    
						    var size = fileHTTP.responseText;
						    
						    strXML += "<NODE>";
						    strXML += "<PUPLOADSN><![CDATA[" + NewGuid + "_" + FileName + "]]></PUPLOADSN>";
						    strXML += "<RESULTUPLOADA><![CDATA[" + "true" + "]]></RESULTUPLOADA>";
						    strXML += "<PFILENAME><![CDATA[" + FileName + "]]></PFILENAME>";
						    strXML += "<FILESIZE><![CDATA[" + size + "]]></FILESIZE>";
						    strXML += "<FILELOCATION><![CDATA[" + filefullpath + "]]></FILELOCATION>";
						    strXML += "</NODE>";
						}
						
						strXML += "</NODES></ROOT>";
						returnvalue(strXML);
					}
				}
			}
						
			function InsertDocInfo() {
			    var ret = "";		
			    
			    while (ret == "") {
			        ret = SelectBoard();
			
			        while (ret == "") {
			            if (confirm("<spring:message code='ezCommunity.t1156'/>")) {
			            	return -1;
			        	}
			        
			        ret = SelectBoard();
			    	}
				}

			    pBoardID = ret;
			    GetBoardInfo();
			    InitializeSettings();
			
			    if (pUrl.toLowerCase().indexOf(".mht") > -1) {
			        var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/common/downloadattach.aspx?filepath=" + escape(pUrl) + "&filename=test.mht";
			        document.getElementById('docContent').src = "/myoffice/CKEditor/MHTtoHTML_Content.aspx?href=" + fullPath;
			        
			        if (gubun == "3") {
			            document.getElementById('docContent').style.height = "220px";
			        }
			        
			        document.getElementById("docTR").style.display = "";
			    }
			    
			    var xmlHTTP = createXMLHttpRequest();
			    var xmlpara = createXmlDom();
			    var xmlstring = "<DocID>" + pDocID + "</DocID>";
			    xmlpara = loadXMLString(xmlstring);
			    
			    if ("${userInfo_approvalG}" == "NO") {
			    	xmlHTTP.open("POST", "/myoffice/ezApproval/formContainer/aspx/aprattachMail.aspx", false);
			    } else {
			    	xmlHTTP.open("POST", "/myoffice/ezApprovalG/formContainer/aspx/aprattachMail.aspx", false);
			    }
				
			    xmlHTTP.send(xmlpara);
			    
			    if (xmlHTTP.status == 200) {
			        var xmldom = createXmlDom();
			        xmldom = loadXMLString(xmlHTTP.responseText);
			        document.getElementById("txtTitle").value = "<spring:message code='ezCommunity.t1160'/>" + getNodeText(GetElementsByTagName(xmldom, "DOCTITLE")[0]);
			    }
			}
						
			function GetBoardInfo() {
			    var xmlhttp_boardinfo = createXMLHttpRequest();
			    xmlhttp_boardinfo.open("POST", "aspx/GetBoardInfo.aspx?BoardID=" + pBoardID, false);
			    xmlhttp_boardinfo.send();
			
			    if (xmlhttp_boardinfo.status == 200) {
			        pBoardName = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "BOARDNAME")[0]);
			        AttachLimit = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "ATTACHLIMIT")[0]);
			        ExpireDays = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "EXPIREDAYS")[0]);
			        gubun = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "GUBUN")[0]);
			    }
			
			    xmlhttp_boardinfo = null;			
			}
						
            function InitializeSettings() {
                document.getElementById('tdBoardName').innerHTML = pBoardName;
	
                if (ExpireDays == "-1") {
                    document.getElementById('ChkPermanence').checked = true;
                    document.getElementById('Makedate').style.display = "none";
                } else {
                    document.getElementById('ChkPermanence').checked = false;
                    document.getElementById('Makedate').style.display = "";
                    idDatepicker.vtLocalEndDate(AddDate(idDatepicker.vtLocalDate(), parseInt(ExpireDays)));
                }
            }

            function Title_onkeyDown(e) {
                if (window.event) {
                    if (e.keyCode != 9) {
                    	return;
                    }
                } else {
                    if (e.which != 9) {
                    	return;
                    }
                }
            }
						
            function ConvMakeXMLString(str) {
                str = ReplaceText(str, "&amp;", "&");
                str = ReplaceText(str, "&lt;", "<");
                str = ReplaceText(str, "&gt;", ">");
                str = ReplaceText(str, "&quot;", "\"");
                return str;
            }
	
            function DocumentComplete() {
            	if (flag == false) {
	                flag = true;
	                
	                if (pMode == "new" || pModeOld == "loadpc") {
	                    document.getElementById("txtTitle").focus();
	                    message.SetEditorContent("");
	                } else {
						if (pUrl == "") {
	                        var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(strContentLocation);
	                        
	                        if (pMode == "reply") {
	                            var htmlData = message.SetEditorContentURL2(fullPath);
	                            htmlData = ReplaceText(htmlData, "class=&quot;FIELD&quot;", "");
	                            htmlData = ReplaceText(htmlData, "class=FIELD", "");
	                            htmlData = "<body free>" + htmlData + "</body>";
	                            
	                            if (gubun != "2") {
	                            	htmlData = "<br><br>-----<B>[&nbsp;<spring:message code='ezCommunity.t1161'/></B>-----<br><B><spring:message code='ezCommunity.t1162'/></B>" + strWriteDate + "<br><B><spring:message code='ezCommunity.t1163'/></B>" + strWriterName + "(" + strWriterTitle + "," + strWriterDeptName + "," + strWriterCompanyName + ")<br><B><spring:message code='ezCommunity.t885'/></B>" + "${strOrgTitle}" + "<br><br>" + htmlData;
	                            } else {
	                            	htmlData = "<br><br>-----<B>[&nbsp;<spring:message code='ezCommunity.t1161'/></B>-----<br><B><spring:message code='ezCommunity.t1162'/></B>" + strWriteDate + "<br><B><spring:message code='ezCommunity.t1163'/></B>" + strWriterFakeName + "<br><B><spring:message code='ezCommunity.t885'/>" + "${strOrgTitle}" + "<br><br>" + htmlData;
	                            }
	                            
	                            message.SetEditorContent(htmlData);
	                        } else {
	                            message.SetEditorContentURL(fullPath);
	                        }
	                    } else {
	                        if (pDocID == "") {
	                            if (InsertMailInfo() == -1) {
	                            	window.close();
	                            }
	                        } else {
	                            if (InsertDocInfo() == -1) {
	                            	window.close();
	                            }
	                        }
	                    }
	                }
	                
                    MHTLoadComplete = "true";
                }
			}
	
            function FieldsAvailable() {
            }

            function btn_AttachSelect_onclick() {
                document.getElementById('mode').value = "ATT";
                document.form.file1.click();
            }
            
            function btn_AttachAdd_onclick() {
                document.getElementById("boardid").value = pBoardID;
                document.getElementById("maxsize").value = parseInt(AttachLimit) * 1024 * 1024;
                document.getElementById("cnt").value = document.getElementById("form").file1.files.length;
                var frm = document.getElementById('form');
                frm.action = "aspx/upload.aspx";
                frm.submit();
                document.form.file1.value = "";
            }
	
            function returnvalue(strXML) {
                var xml = loadXMLString(strXML);
                var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
                var extFlag = false;
                
                for (var i = 0; i < nodes.length; i++) {
                    if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
                        if (getNodeText(GetChildNodes(nodes[i])[3]) == 0) {
                            alert(getNodeText(GetChildNodes(nodes[i])[2]) + strLang6);
                            return;
                        }
                    } else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
                        alert(strLang27 + AttachLimit + "MB" + strLang28);
                        return;
                    } else if(getNodeText(GetChildNodes(nodes[i])[1]) == "denied") {
                        extFlag = true;                            
                    } else {
                        alert(getNodeText(GetChildNodes(nodes[i])[2]) + strLang6 + "\n\n" + result);
                        return;
                    }
                }
                
                if(extFlag) {
                	alert(strLang75);
                }

                AttachFileInfo(strXML);

                document.getElementById("file1").type = "text";
                document.getElementById("file1").type = "file";
            }
		</script>
	</head>
	<body class = "popup" style = "height: 100%">
		<table class="layout">
	        <tr>
	            <td style="height: 20px">
	                <div id="menu">
	                    <ul>
	                        <li><span onclick="SaveItem();"><spring:message code='ezCommunity.t155'/></span></li>
	                        <li><span onclick="PreviewItem();"><spring:message code='ezCommunity.t1167'/></span></li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li><span onclick="window.close();"><spring:message code='ezCommunity.t21'/></span></li>
	                    </ul>
	                </div>
	                
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	                    selToggleList(document.getElementById("close"), "ul", "li", "0");
	                </script>
	                
	            </td>
	        </tr>
	        <tr>
	            <td style="height: 20px;">
	                <table class="content">
	                    <tr>
	                        <th><spring:message code='ezCommunity.t1168'/></th>
	                        <td id="tdBoardName">${pBoardName }</td>
	                    </tr>
	                    
	                    <c:choose>
	                    	<c:when test="${(mode == 'new' || reservedItem == 'true' || url != '') && gubun != '2' }">
	                    		<tr id="tdReservationDate">
	                    	</c:when>
	                    	<c:otherwise>
	                    		<tr id="tdReservationDate" style="DISPLAY: none">
	                    	</c:otherwise>
	                    </c:choose>
	                    
	                        <th><spring:message code='ezCommunity.t1169'/></th>
	                        <td>
	                        	<c:choose>
	                        		<c:when test="${reservedItem == 'true' }">
	                        			<input type="checkbox" id="chk_reservation" onclick="Reservation_onclick()" checked><spring:message code='ezCommunity.t913'/>
	                        		</c:when>
	                        		<c:otherwise>
	                        			<input type="checkbox" id="chk_reservation" onclick="Reservation_onclick()"><spring:message code='ezCommunity.t913'/>
	                        		</c:otherwise>
	                        	</c:choose>
	                        	<span id="reservation_date">
		                        	<input type="text" id="Sdatepicker" style="width:80px;text-align:center" />
		                        	<input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" />
		                            <a class="imgbtn"><span onclick="btn_PostDate_Clear()" popuplocation='topright'><spring:message code='ezCommunity.t444'/></span></a>
		                        </span>
	                        </td>
	                    </tr>
	                    <tr id="tdEndDate">
	                        <th><spring:message code='ezCommunity.t384'/></th>
	                        <td>
	                        	<c:choose>
	                        		<c:when test="${(mode != 'modify' && boardInfo.expireDays =='-1') || (mode == 'modify' && fn:substring(strEndDate, 0, 4) == '9999') || url != '' }">
	                        			<span id="Chkbox"><input type="checkbox" id="ChkPermanence" name="ChkPermanence" onclick="return ChkPermanent()" checked><spring:message code='ezCommunity.t930'/></span>
	                        			<span id="Makedate"><input type="text" id="Edatepicker" style="width:80px;text-align:center"></span>
	                        		</c:when>
	                        		<c:otherwise>
	                        			<span id="Chkbox"><input type="checkbox" id="ChkPermanence" name="ChkPermanence" onclick="return ChkPermanent()"><spring:message code='ezCommunity.t930'/></span>
	                                	<span id="Makedate"><input type="text" id="Edatepicker" style="width:80px;text-align:center"></span>
	                        		</c:otherwise>
	                        	</c:choose>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezCommunity.t1171'/></th>
	                        <c:choose>
	                        	<c:when test="${strImportance == '1' }">
	                        		<td><input type="checkbox" id="chkEmergent" checked><spring:message code='ezCommunity.t1172'/></td>
	                        	</c:when>
	                        	<c:otherwise>
	                        		<td><input type="checkbox" id="chkEmergent"><spring:message code='ezCommunity.t1172'/></td>
	                        	</c:otherwise>
	                        </c:choose>
	                    </tr>
	                    
	                    <c:if test="${gubun == '2' }">
	                    	<tr>
		                        <th><spring:message code='ezCommunity.t1173'/></th>
		                        <td>
		                            <input type="text" id="txtNickName" style="WIDTH: 150px" maxlength="15" value="${strWriterName }">&nbsp;&nbsp;(<spring:message code='ezCommunity.t1174'/>
		                        </td>
		                    </tr>
		                    <tr>
		                        <th><spring:message code='ezCommunity.t1175'/></th>
		                        <td>
		                            <input type="password" id="txtPassWord" style="WIDTH: 150px" maxlength="15">&nbsp;&nbsp;(<spring:message code='ezCommunity.t1176'/>
		                        </td>
	                    	</tr>
	                    </c:if>
	                    
	                    <tr>
	                        <th><spring:message code='ezCommunity.t433'/></th>
	                        <td><input type="text" id="txtAbstract" style="WIDTH: 100%; box-sizing:border-box;-moz-box-sizing:border-box;word-break: break-all" value="" maxlength="100"></td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezCommunity.t124'/></th>
	                        <td><input type="text" id="txtTitle" style="WIDTH: 100%; box-sizing:border-box;-moz-box-sizing:border-box;word-wrap: break-word; word-break: break-all;" value="" maxlength="100" onkeydown="Title_onkeyDown(event)"></td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	        <tr>
	            <td style="height: 100%; vertical-align: top;" id="EdtorSize">
	            	<c:choose>
	            		<c:when test="${editor == 'TAGFREE' }">
	            			<iframe id="message" class="viewbox" name="message" src="TagFree_TFX_Editor.aspx" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
	            		</c:when>
	            		<c:when test="${editor =='DEXT' }">
	            			<iframe id="message" class="viewbox" name="message" src="DEXT_Editor.aspx" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
	            		</c:when>
	            		<c:otherwise>
	            			<iframe id="message" class="viewbox" name="message" src="/ezCommunity/ckEditor.do" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
	            		</c:otherwise>
	            	</c:choose>
	            </td>
	        </tr>
	        <tr id="docTR" style="display: none">
	            <td>
	                <div id="docContentBorder" style="border: #B6B6B6 1px solid; BACKGROUND-COLOR: white;">
	                    <iframe id="docContent" style="width: 100%; height: 100%;" frameborder="0"></iframe>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="padding-top: 10px; height: 20px; vertical-align: top;">
	                <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	                <form method="post" id="form" name="form" enctype="multipart/form-data" action="aspx/upload.aspx" target="ifrm" style="visibility: hidden;">
	                    <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple />
	                    <input type="hidden" name="boardid" id="boardid" />
	                    <input type="hidden" name="maxsize" id="maxsize" />
	                    <input type="hidden" name="mode" id="mode" />
	                    <input type="hidden" name="cnt" id="cnt" />
	                    <input type="hidden" name="mailgubun" id="mailgubun" />
	                </form>
	                <table class="file">
	                    <form name="multicheck">
	                        <tr>
	                            <th><spring:message code='ezCommunity.t933'/></th>
	                            <td class="pos1">
	                                <div id="lstAttachLink">&nbsp;</div>
	                            </td>
	                            <td class="pos2">
	                            	<a class="imgbtn"><span id="btn_AttachAdd" onclick="return btn_AttachSelect_onclick()"><spring:message code='ezCommunity.t1177'/></span></a><br>
	                                <a class="imgbtn"><span id="btn_AttachDel" onclick="return btn_AttachDel_onclick()"><spring:message code='ezCommunity.t1178'/></span></a>
	                            </td>
	                        </tr>
	                    </form>
	                </table>
	            </td>
	        </tr>
	        
	        <div id="txtAttachList"></div>
	    </table>
	    
	    <input id="publicModulus" value="${publicModulus }" type="hidden"/>
	    
	    <script type="text/javascript">
	        if("${gubun != '2'}") {
	            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 330 + "PX";
	        } else {
	            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 355 + "PX";
	        }
		</script>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/myoffice/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>