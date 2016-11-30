<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<c:choose>
			<c:when test="${pMode == 'new' || pUrl != ''}">
				<title><spring:message code = 'ezCommunity.t1128' /></title>
			</c:when>
			
			<c:when test="${pMode == 'reply' }">
				<title><spring:message code = 'ezCommunity.t1129' /></title>
			</c:when>
			
			<c:otherwise>
				<title><spring:message code = 'ezCommunity.t1130' /></title>
			</c:otherwise>
		</c:choose>
		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1'/>"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<c:if test="${isCrossBrowser == true}">
			<script type="text/javascript" src="/js/ezCommunity/ConvertSaveImage.js"></script>
			<script type="text/javascript" src="/js/ezCommunity/AttachMain_CK.js"></script>
			<script type="text/javascript" src="/js/ezCommunity/AttachItem_CK.js"></script>
		</c:if>
		
		<c:if test="${isCrossBrowser != true}">
			<script type="text/javascript" src="/js/ezCommunity/AttachMain.js"></script>
			<script type="text/javascript" src="/js/ezCommunity/AttachItem.js"></script>
			<script type="text/javascript" src="/js/ezCommunity/kaoni_ActiveX.js"></script>
		</c:if>
		
		<script type="text/javascript" src="/js/ezCommunity/datepicker.htc.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/composeappt.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		
		<script type="text/javascript">
			var pUploadFilePath = "<c:out value = '${pUploadPath}' />";
			pBoardID = "<c:out value = '${boardInfo.boardID}' />";
			var pBoardName = "<c:out value = '${boardInfo.boardName}' />";
			pMode = "<c:out value = '${pMode}'/>";
			var pModeOld = "";
			var MHTLoadComplete = "";
			var SSUserID = "<c:out value = '${userInfo.id}' />";
			var SSUserName = "<c:out value = '${userInfo.displayName1}' />";
			var SSUserName2 = "<c:out value = '${userInfo.displayName2}' />";
			var SSDeptID = "<c:out value = '${userInfo.deptID}' />";
			var SSDeptName = "<c:out value = '${userInfo.deptName1}' />";
			var SSDeptName2 = "<c:out value = '${userInfo.deptName2}' />";
			var SSCompanyID = "<c:out value = '${userInfo.companyID}' />";
			var SSCompanyName = "<c:out value = '${userInfo.companyName1}' />";
			var SSCompanyName2 = "<c:out value = '${userInfo.companyName2}' />";
	
			var strItemID = "<c:out value = '${item.itemID}' />";
			var strWriterName = "<c:out value = '${item.writerName}' />";
			var strWriterDeptName = "<c:out value = '${item.writerDeptName}' />";
			var strWriterCompanyName = "<c:out value = '${item.writerCompanyName}' />";		
			var strWriteDate = "<c:out value = '${item.writeDate}' />";
			var strParentWriteDate = "<c:out value = '${item.parentWriteDate}' />";
			var strImportance = "<c:out value = '${item.importance}' />";
			var strStartDate = "<c:out value = '${item.startDate}' />";
			var strEndDate = "<c:out value = '${item.endDate}' />";
			var strAttachments = "<c:out value = '${item.attachments}' />";
			var strContentLocation = "<c:out value = '${item.contentLocation}' />";
			var strUpperItemIDTree = "<c:out value = '${item.upperItemIDTree}' />";
			var strItemLevel = "<c:out value = '${item.itemLevel}' />";
			var strWriterTitle = "<c:out value = '${extensionAttribute3}' />";
			
			pAttachListXml = "";
			
			AttachLimit = "<c:out value = '${boardInfo.attachSizeLimit}' />";
			var pReservedItem = "<c:out value = '${pReservedItem}' />";
			
			var strUserRank = "<c:out value = '${userInfo.title1}' />";
			var strUserRank2 = "<c:out value = '${userInfo.title2}' />";
			var strUserPhone = "<c:out value = '${userInfo.phone}' />";
						
			var strNow = "<c:out value = '${strNow}' />";		
			var ExpireDays = "<c:out value = '${expireDays}' />";		
			var gubun = "<c:out value = '${boardInfo.gubun}' />";		
			var pUrl = "<c:out value = '${pUrl}' />";
			var pDocID = "<c:out value = '${pDocID}' />";
			var unloadflag = "0";
		    PhotoBoard = "Y";
// 		    var _hasattach = "<c:out value = '${_hasattach}' />";
// 		    var NewGuid = "<c:out value = '${NewGuid}' />";
		    var flag = false;
		    
		    window.onresize = function () {
		        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 150 + "PX";
		    }
		    
		    window.onload = function () {
		        initdatepicker();
		        
		        if(navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1){
		            document.getElementById("file1").multiple = false;
		        }
	
		        if (pReservedItem != "true")  {
		        	document.getElementById("reservation_date").style.display = "none";
		        }
							
		        if(pMode == "modify" && strAttachments != "") {
		            pAttachListXml = MakeAttachList();
		            RealImageName(pAttachListXml);
		        }
					
		        if(pMode == "new") {
		            btn_PostDate_Clear();
		        } else {
		            if (pReservedItem != "true") {
		            	document.getElementById("idDatepicker").value = "";
		            }
		        }
		        
		        if (ExpireDays == -1) {
		        	document.getElementById('Makedate').style.display = "none";
		        }
		        
		        if( pMode == "modify") {												
		            document.getElementById("txtTitle").value  = ConvMakeXMLString("<c:out value = '${item.title}' />");
		            document.getElementById("txtAbstract").value = ConvMakeXMLString("<c:out value = '${item.absTract}' />");
			        document.getElementById("txtPhotoFile").value = ConvMakeXMLString("<c:out value = '${item.extensionAttribute4}' />");
		            document.getElementById("file1").multiple = false;
		        }
							
		        if (pMode == "reply") {
		            document.getElementById("txtTitle").value = ConvMakeXMLString("<c:out value = '${item.title}' />");
		        }
							
		        if(pReservedItem != "true") {
		            var nowDate = new Date();
		            var weekstr="<spring:message code = 'ezCommunity.t440' />";
		            var arry = weekstr.split(";");
		            document.getElementById("idDatepicker").value = DateFormat(nowDate)+" ("+arry[nowDate.getDay()]+")";
		            
		            if (document.getElementById("_T1").value == "") {
		                document.getElementById("_T1").value = "<spring:message code = 'ezCommunity.t436' />"+" 12:00";
		            }
		            
		            idDatepicker_Temp = document.getElementById("idDatepicker").value;
		            _T1_Temp = document.getElementById("_T1").value;
		        }
		    }
	
		    function RealImageName(ret) {
		        try {
		            pAttachListXml = ret;
		            var xmlAttach = createXmlDom();
		            xmlAttach = loadXMLString(ret);
		            var objAttachNodes = SelectNodes(xmlAttach, "LISTVIEWDATA/ROWS/ROW/CELL/VALUE");
		            document.getElementById("txtPhotoFile").value = getNodeText(objAttachNodes[0]);
		        }
		        catch (e) {
		            alert("RealImageName :: " + e.description);
		        }
		    }
	
		    function initdatepicker() {
		        var idDatepicker = new datepicker('idDatepicker', 'idDatepicker');
		        idDatepicker.attachEvent('datechange', onStartDateChanged);
		        idDatepicker.attachEvent('enddatechange', onEndDateChanged);
		        idDatepicker.attachEvent('timechange', onStartTimeChanged);
		        idDatepicker.attachEvent('endtimechange', onEndTimeChanged);
		        idDatepicker.elemDateButtons = "img_StartCalDisp;img_EndCalDisp";
		        idDatepicker.elemDateInputs = "idDatepicker;_D2";
		        idDatepicker.elemTimeButtons = "img_StartTime;img_EndTime";
		        idDatepicker.elemTimeInputs = "_T1;_T2";
		        idDatepicker.popupType = "both";
		        idDatepicker.pickerDateFormat = "[yyyy]<spring:message code = 'ezCommunity.t435' />";
		        idDatepicker.pickerTimeFormat = "[tt] [h]:[mm]";
		        idDatepicker.inputDateFormat = "[yyyy]-[MM]-[dd] ([ddd])";
		        idDatepicker.inputTimeFormat = "[tt] [h]:[mm]";
		        idDatepicker.firstDayOfWeek = "0";
		        idDatepicker.textAM = "<spring:message code = 'ezCommunity.t436' />";
		        idDatepicker.textPM = "<spring:message code = 'ezCommunity.t437' />";
		        idDatepicker.textDecimal = ".";
		        idDatepicker.textHoursAbbrev = "<spring:message code = 'ezCommunity.t438' />";
		        idDatepicker.textMustSpecifyValidTime = "<spring:message code = 'ezCommunity.t439' />";
		        idDatepicker.daynameLetters = "<spring:message code = 'ezCommunity.t440' />";
		        idDatepicker.daynamesShort = "<spring:message code = 'ezCommunity.t440' />";
		        idDatepicker.daynamesLong = "<spring:message code = 'ezCommunity.t441' />";
		        idDatepicker.monthnamesShort = "1;2;3;4;5;6;7;8;9;10;11;12";
		        idDatepicker.monthnamesLong = "1<spring:message code = 'ezCommunity.t442' />";
		        idDatepicker.isoDateUTF = "<c:out value = '${startDateTime}' />";
		        idDatepicker.isoEndDateUTF = "<c:out value = '${endDateTime}' />";
		        idDatepicker.ready();
		    }
	
		    function DateFormat(obj) {
		        var yy = String(obj.getFullYear()).substring(0, 4);
		        
		        if (String(obj.getMonth() + 1).length == 1) {
		            var mm = "0" + (obj.getMonth() + 1);
		        } else {
		            var mm = obj.getMonth() + 1;
		        }
		        
		        if (String(obj.getDate()).length == 1) {
		            var dd = "0" + obj.getDate();
		        } else {
		            var dd = obj.getDate();
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
	
		        str += "<LISTVIEWDATA><HEADERS><HEADER><NAME><spring:message code = 'ezCommunity.t1135' /></NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME><spring:message code = 'ezCommunity.t1136' /></NAME><WIDTH>50</WIDTH></HEADER></HEADERS><ROWS>";
				
		        for(i=0;i<xmldomNodes.length;i++) {
		            filepath = SelectSingleNodeValue(xmldomNodes[i], "FilePath");
		            filename = MakeXMLString(filepath.substr(89, filepath.length - 88));
		            filepath = MakeXMLString("/upload_Community/" + filepath);
		            
		            str += "<ROW><CELL>";	
		            str += "<VALUE>" + "<c:out value = '${item.extensionAttribute4}' />" + "</VALUE>";
		            str += "<DATA1>" + "<c:out value = '${item.extensionAttribute4}' />" + "</DATA1>";
		            str += "<DATA2>" + MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "FilePath")) + "</DATA2>";
		            str += "<DATA3></DATA3>";
		            str += "<DATA4></DATA4>";
		            str += "<DATA5>Y</DATA5>";
		            str += "<DATA6>" + MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "FileSize2")) + "</DATA6>";
		            str += "</CELL>";
		            str += "<CELL><VALUE></VALUE>";
		            str += "</CELL></ROW>";
		        }
		        
		        str += "</ROWS></LISTVIEWDATA>";
		        
		        return str;
		    }
	
		    function GetStartDate() {
		        var pReservationTime = "";
		        
		        if (document.getElementById("idDatepicker").value && document.getElementById("chk_reservation").checked) {
		            if (document.getElementById("_T1").value) {
		                var pDateSplit = document.getElementById("_T1").value.split(" ");
		                var cTime = pDateSplit[1].split(":");
												
		                if (document.getElementById("_T1").value.substring(0, 2) == "<spring:message code = 'ezCommunity.t436' />") {				
		                    if ( cTime[0] < 10 ) {
		                        pReservationTime = "0" + document.getElementById("_T1").value.substring(3, 8);
		                    } else if( cTime[0] == "12") {
		                        pReservationTime = "00" + document.getElementById("_T1").value.substring(5, 8);
		                    } else {
		                        pReservationTime = document.getElementById("_T1").value.substring(3, 8);
		                    }
		                } else {
		                    if ( cTime[0] < 10 ) {
		                        pReservationTime = idDatepicker.startHours() + ":" + document.getElementById("_T1").value.substring(5, 7);
		                    } else {
		                        pReservationTime = idDatepicker.startHours() + ":" + document.getElementById("_T1").value.substring(6, 8);
		                    }
		                }
		                
		                pReservationTime = document.getElementById("idDatepicker").value.substring(0, 10) + " " + pReservationTime + ":00";
		            } else {
		                pReservationTime = document.getElementById("idDatepicker").value.substring(0, 10) + " 00:00:00";
		            }
		        }
		        return pReservationTime;
		    }
	
		    function GetEndDate() {
		        var pEndDateTime;
		        
		        if (document.getElementById("ChkPermanence").checked) {
		            pEndDateTime = "9999-12-30 23:59:59";
		        } else {
		            if (pMode == "modify" && document.getElementById("_D2").value.substring(0, 4) != "9999") {
		                pEndDateTime = document.getElementById("_D2").value.substring(0, 10) + strEndDate.substring(10, 19);
		            } else {
		                pEndDateTime = document.getElementById("_D2").value.substring(0, 10) + strNow.substring(10, 19);
		            }
		        }
		        
		        return pEndDateTime;
		    }
	
		    function SaveItem() {
		        unloadflag ="1";

		        if(MHTLoadComplete != "true") {
		            alert("<spring:message code = 'ezCommunity.t1138' />");
		            
		            return;
		        }
		        
		        var strXML = "";
		        var newID = "";
		        var pStartDate = GetStartDate();
		        var pEndDate = GetEndDate();
	
		        if (document.getElementById("chk_reservation").checked && pStartDate == "") {
		            alert("<spring:message code = 'ezCommunity.t1139' />");
		            
		            return;
		        }
							
		        if (pStartDate != "" && pStartDate < strNow) {
		            alert("<spring:message code = 'ezCommunity.t1140' />");
		            
		            return;
		        }
	
		        if (pEndDate != "" && pEndDate < strNow) {
		            alert("<spring:message code = 'ezCommunity.t1141' />");
		            
		            return;
		        }
							
		        if (pStartDate != "" && pEndDate != "" && pEndDate < pStartDate) {
		            alert("<spring:message code = 'ezCommunity.t1142' />");
		            
		            return;
		        }
	
		        if (document.getElementById("txtTitle").value == "") {
		            alert("<spring:message code = 'ezCommunity.t1143' />");
		            txtTitle.focus();
		            
		            return;				
		        }
							
		        if(pAttachListXml == "" || document.getElementById("txtPhotoFile").value == "") {
		            alert("<spring:message code = 'ezCommunity.t1199' />");
		            
		            return;	
		        }
	
		        if (pStartDate == "" && pReservedItem == "TRUE") {
		            strParentWriteDate = "";
		        }
		        
		        if (typeof (pAttachListXml) == "string") {
		        	<c:if test="${isCrossBrowser != true}">
			        	var parser = new DOMParser();
			        	pAttachListXml = parser.parseFromString(pAttachListXml, "text/xml");
			            parser = null;
			            
			            newID += "{" + GetGUID().toUpperCase() + "};";
	            	</c:if>
		        } else {
		        	var xmldomNodes = SelectNodes(pAttachListXml,"LISTVIEWDATA/ROWS/ROW");
            		
    		        for(var i=xmldomNodes.length; i>0; i--) {
    		            newID += "{" + GetGUID().toUpperCase() + "};";
    		        }
		        }
		        
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
		        }
		        
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "IMPORTANCE", importance);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TITLE", MakeXMLString(document.getElementById("txtTitle").value));
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "STARTDATE", pStartDate);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ENDDATE", pEndDate);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ABSTRACT",  MakeXMLString(document.getElementById("txtAbstract").value));
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ATTACHMENTS", MakeXMLString(AttachFileList_Photo()));
	
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
            	    createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE4", MakeXMLString(GetFileName()));
		        }
							
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE5", MakeXMLString(GetSmallUrl()));
							
		        var obj = GetBODY(document.getElementById('docContent')).getElementsByTagName("TD");
		        
		        for (var i = 0; i < obj.length; i++) {
		            if (obj[i].free == "") {
		                obj[i].removeAttribute('free');
		            }
		            
		            if (obj[i].className == "FIELD") {
		                obj[i].removeAttribute('className');
		            }
		        }
		        
		        <c:if test="${isCrossBrowser != true}">
			        if (pDocID != "") {
			            message.SetEditorContent(message.SetEditorContent(message.GetEditorContent() + "<hr>" + docContent.document.body.innerHTML));
			        }
			        
			        JSleep(1000);
			        var strBody = message.GetEditorContent();
			        
		        	strBody = ConvertHTMLtoMHT(message.GetEditorContent());
	        	</c:if>
	        	<c:if test="${isCrossBrowser == true}">
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
	        	</c:if>
		        
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "CONTENT", strBody);	
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DOCPASSWORD","");	
												
		        xmlhttp.open("POST", "/ezCommunity/saveItemPhoto.do?mode="+ pMode , false);
		        xmlhttp.send(xmlDom);
							
		        if (xmlhttp.responseText == "OK") {
		            xmlhttp = null;
		            xmlDom = null;

		            //Mail 부분
		            if (document.getElementById("chk_reservation").checked == false) {
		            	//2016-06-29 이효진 Mail부분
		                /* if (strItemID == "") {
		                    xmlhttp = createXMLHttpRequest();
		                    xmlhttp.open("POST", "aspx/SendPostNoticeMail.aspx?BoardID=" + pBoardID + "&ItemID=" + newID, false);
		                    xmlhttp.send();
		                    xmlhttp = null			
		                }
		                
		                if (pMode == "reply") {
		                    xmlhttp = createXMLHttpRequest();
		                    xmlhttp.open("POST", "aspx/SendReplyNoticeMail.aspx?BoardID=" + pBoardID + "&ItemID=" + newID + "&ItemTreeID=" + strUpperItemIDTree, false);
		                    xmlhttp.send();
		                    xmlhttp = null;
		                } */
		                
		                alert("<spring:message code = 'ezCommunity.t282' />");
		            } else {
		                alert("<spring:message code = 'ezCommunity.t1150' />" + pStartDate.substr(0, 16) + "<spring:message code = 'ezCommunity.t1151' />");
		            }
		            
		            try {
						window.opener.location.reload(true);
		            } catch(e) {
		            }
		            
		            window.close();		
		        } else {
		            alert("<spring:message code = 'ezCommunity.t283' />" + xmlhttp.responseText);
		        }
		        
		        xmlhttp = null;
		        xmlDom = null;
		    }
	
		    function JSleep(sTime) {
				var start = new Date().getTime();
		        
		        while (new Date().getTime() < start + sTime) {
		        };
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
		        idDatepicker.setIsoDateUTC("<c:out value = '${startDateTime}' />", "<c:out value = '${startDateTime}' />");
		    }
	
		    function ChkPermanent() {
		        if (document.getElementById("ChkPermanence").checked) {
		            document.getElementById("Makedate").style.display = "none";
		        } else {
		            document.getElementById("Makedate").style.display = "";
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
							
		        window.open("BoardItemPreView_Cross.aspx?gubun=" + gubun, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");	
		    }
					
		    function AddDate(pDate,  pDays) {
		        var dt = new Date(pDate);
		        dt.setDate(dt.getDate() + pDays);
		        
		        return dt;
		    }
						
		    function AutoAddtoExpireDate() {
		        var temp = ExpireDays;
		        
		        if (temp == -1) {
		        	temp = 30;
		        }
							
		        idDatepicker.vtLocalEndDate = AddDate(idDatepicker.vtLocalDate, temp);			
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
		            document.getElementById('txtTitle').value = "<spring:message code = 'ezCommunity.t1152' />" + getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("SUBJECT").item(0));
	
		            var Content = "<P>&nbsp;<br></P><br><DIV><br><br>-----<B>[&nbsp;<spring:message code = 'ezCommunity.t1153' /></B>-----</DIV><DIV><B><spring:message code = 'ezCommunity.t411' /></B>" + getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("DATE").item(0)) + "</DIV>";
		            
		            if (getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("COMMENT").item(0)) != "") {
		                Content = Content + "<DIV><B><spring:message code = 'ezCommunity.t1155' /></B>" + ReplaceText(getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("FROMNAME").item(0)), "\\\"", "");
		                Content = Content + "  (" + getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("COMMENT").item(0)) + ") </DIV>";
		            } else {
		                Content = Content + "<DIV><B><spring:message code = 'ezCommunity.t1155' /></B>" + ReplaceText(ReplaceText(getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("FROMNAME").item(0)), "<", "&lt"), ">", "&gt;") + "</DIV>";
		            }
	
		            Content = Content + "<DIV><B><spring:message code = 'ezCommunity.t885' /></B>" + getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("SUBJECT").item(0)) + "</DIV><P><br><br>" + getNodeText(loadXMLString(xmlHTTP.responseText).getElementsByTagName("HTMLDESCRIPTION").item(0)) + "</P>";
	
		            Content = ReplaceText(Content, "id=doctitle", "");
		            Content = ReplaceText(Content, "id=\"doctitle\"", "");
		            Content = ReplaceText(Content, "id=\'doctitle\'", "");
		            message.SetEditorContent(Content);
	
		            var ret = "";
								
		            while (ret == "") {
		                ret = SelectBoard();
									
		                while (ret == "") {
		                    if (confirm("<spring:message code = 'ezCommunity.t1156' />")) {
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
		                    attachHTTP.open("POST", document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/remote/mail_downloadattachfile.aspx?mode=Attach&ID=" + encodeURIComponent(ItemID) + "&ATTID=" + encodeURIComponent(FileURL) + "&filepath=" + pUploadFilePath + "\\" + pBoardID + "\\uploadFile" + "&NewGuid=" + NewGuid, false);
		                    attachHTTP.send();
		                    filefullpath = pUploadFilePath + "\\" + pBoardID + "\\uploadFile\\" + NewGuid + "_" + FileName;
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
						
		    <%-- function InsertDocInfo() {
		        var ret = "";
		        
		        while (ret == "") {
		            ret = SelectBoard();
									
		            while (ret == "") {
		                if (confirm("<spring:message code = 'ezCommunity.t1156' />")) {
		                    return -1;
		                }
		                
		                ret = SelectBoard();
		            }
		        }
	
		        pBoardID = ret;
		        GetBoardInfo();
		        InitializeSettings();
						
		        if (pUrl.toLowerCase().indexOf(".mht") > -1) {
		            var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/common/downloadattach.aspx?filepath=" + encodeURIComponent(pUrl) + "&filename=test.mht";
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
		        
		        if ("<%=UserInfo_ApprovalG%>" == "NO") {
		            xmlHTTP.open("POST", "/myoffice/ezApproval/formContainer/aspx/aprattachMail.aspx", false);
		        } else {
		            xmlHTTP.open("POST", "/myoffice/ezApprovalG/formContainer/aspx/aprattachMail.aspx", false);
		        }
		        
		        xmlHTTP.send(xmlpara);
		        
		        if (xmlHTTP.status == 200) {
		            var xmldom = createXmlDom();
		            xmldom = loadXMLString(xmlHTTP.responseText);
		            document.getElementById("txtTitle").value = "<spring:message code = 'ezCommunity.t1160' />" + getNodeText(GetElementsByTagName(xmldom, "DOCTITLE")[0]);
		        }
		    } --%>
						
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
		                    var fullPath = strContentLocation;
		                    
		                    if (pMode == "reply") {
		                        var htmlData = message.SetEditorContentURL2(fullPath);
		                        htmlData = ReplaceText(htmlData, "class=&quot;FIELD&quot;", "");
		                        htmlData = ReplaceText(htmlData, "class=FIELD", "");
		                        htmlData = "<body free>" + htmlData + "</body>";
	                            htmlData = "<br><br>-----<B>[&nbsp;<spring:message code = 'ezCommunity.t1161' /></B>-----<br><B><spring:message code = 'ezCommunity.t1162' /></B>" + strWriteDate + "<br><B><spring:message code = 'ezCommunity.t1163' /></B>" + strWriterName + "(" + strWriterTitle + "," + strWriterDeptName + "," + strWriterCompanyName + ")<br><B><spring:message code = 'ezCommunity.t885' /></B>" + "<c:out value = '${item.title}' />" + "<br><br>" + htmlData;
		                        
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
		    
		    function returnvalue(strXML) {
		        var xml = loadXMLString(strXML);
		        var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
		        
		        for (i = 0; i < nodes.length; i++) {
		            if (SelectSingleNodeValue(nodes[i], "RESULTUPLOADA") == "true") {
		                if (SelectSingleNodeValue(nodes[i], "FILESIZE") == 0) {
		                    alert(strLang6);
		                    
		                    return;
		                }
		                
		                if (document.getElementById('mode').value == "PHOTO") {
		                    document.getElementById('txtPhotoFile').value = SelectSingleNodeValue(nodes[i], "PFILENAME");
		                }
		            } else if (SelectSingleNodeValue(nodes[i], "RESULTUPLOADA") == "overflow") {
		                alert(strLang8 + AttachLimit + "MB" + strLang9);
		                
		                return;
		            } else {
		                alert(filename + " <spring:message code = 'ezCommunity.lhj08' />" + "\n\n" + result);
		            }
		        }
		        
		        AttachFileInfo(strXML);
		    }
		    
		    function GetSmallUrl() {
		        var xmldom_attachlist = createXMLHttpRequest();
		        var strRet = "";
		        var filepath = "";
		        
				<c:if test="${isCrossBrowser == true}">
					xmldom_attachlist = pAttachListXml;
				</c:if>
				
				<c:if test="${isCrossBrowser != true}">
					xmldom_attachlist = loadXMLString(getXmlString(pAttachListXml));
				</c:if>
		        
		        if(xmldom_attachlist == false) {
		            xmldom_attachlist = null;
		            
		            return "";
		        }
		        
		        var xmldomNodes = GetElementsByTagName(xmldom_attachlist,"DATA2");
		        
		        for(i=0; i<xmldomNodes.length; i++) {
		            filepath = getNodeText(xmldomNodes[i]);
		            
		            if(filepath.indexOf(pBoardID) != -1) {
		                var idx = filepath.lastIndexOf("/");
		                
		                if(idx != -1) {
		                    strRet +=  filepath.substr(0, idx+1) + "s_" + filepath.substr(idx+1) +  ";";
		                }
		            } else {
		                strRet += "tempUploadFile/s_" + getNodeText(xmldomNodes[i]) +  ";";
		            }
		        }
							
		        xmldom_attachlist = null;

		        return strRet;
		    }
		    
		    function GetFileName() {
		        var strRet = "";
		        
		        if (typeof (pAttachListXml) == "string") {
		        	<c:if test="${isCrossBrowser == true}">
		        		pAttachListXml = pAttachListXml;
					</c:if>
					
					<c:if test="${isCrossBrowser != true}">
						pAttachListXml = loadXMLString(getXmlString(pAttachListXml));
					</c:if>
		            
		        }
		        //else
		        //    pAttachListXml = loadXMLString(getXmlString(pAttachListXml));
		        if (getXmlString(pAttachListXml) == "") {
		            return "";
		        }
		        
		        var xmldomNodes = GetElementsByTagName(pAttachListXml, "DATA1");
		        
		        for (i = 0; i < xmldomNodes.length; i++) {
		            strRet += getNodeText(xmldomNodes.item(i)) + ";";
		        }
		        
		        return strRet;
		    }
		</script>
		
	</head>
	<body class="popup" style="height:100%">
		<table class="layout">
	 		<tr>
	    		<td style="height:20px">
	    			<div id="menu">
		        		<ul>
		          			<li><span  onClick="SaveItem();"><spring:message code = 'ezCommunity.t155' /></span></li>
		          			<li style="display:none"><span  onClick="PreviewItem();"><spring:message code = 'ezCommunity.t1167' /></span></li>
		        		</ul>
	      			</div>
	      			<div id="close">
	        			<ul>
	          				<li><span  onClick="window.close();"><spring:message code = 'ezCommunity.t21' /></span></li>
	        			</ul>
	      			</div>
	      			
	      			<script type="text/javascript">
						selToggleList(document.getElementById("menu"), "ul", "li", "0");
						selToggleList(document.getElementById("close"), "ul", "li", "0");
					</script>
				</td>
	  		</tr>
	  		<tr>
	    		<td style="height:20px;">
	    			<table class="content">
						<tr>
	          				<th><spring:message code = 'ezCommunity.t1168' /></th>
	          				<td colspan="2" id="tdBoardName"><c:out value = '${boardInfo.boardName}' /></td>
	        			</tr>
			 
	        			<tr id="tdReservationDate" style="DISPLAY:none">
	          				<th><spring:message code = 'ezCommunity.t1169' /></th>
	          				<td>
	          					<c:choose>
	          						<c:when test="${pReservedItem == 'true' }">
	          							<input type="checkbox" id="chk_reservation" onClick="Reservation_onclick()" checked><spring:message code = 'ezCommunity.t913' />
	          						</c:when>
	          						
	          						<c:otherwise>
	          							<input type="checkbox" id="chk_reservation" onClick="Reservation_onclick()"><spring:message code = 'ezCommunity.t913' />
	          						</c:otherwise>
	          					</c:choose>
	          					
	            				<span id="reservation_date">
	            					<input readonly="readonly" type="text" class="datepicker" id="idDatepicker" />   
	            					<img id="img_StartCalDisp" src="/images/i_scheduler.gif" width="19" height="15" align="absMiddle" style="CURSOR: pointer; POSITION: relative" tabindex="0" popupLocation="bottomright"  forcemarginleft="-40"  forceMarginTop="30">&nbsp;&nbsp;&nbsp;
	            					<input type="text" id='_T1' class='datepicker_time' name="textfield22522" readonly="readonly">
	            					<img id="img_StartTime" src="/images/i_time.gif" width="17" height="16" align="absMiddle" style="CURSOR: pointer; POSITION: relative" popupLocation="bottomright"  forcemarginleft="-40"  forceMarginTop="30">&nbsp;
	            					<a class="imgbtn"><span onClick="btn_PostDate_Clear()" popupLocation='topright'><spring:message code = 'ezCommunity.t444' /></span></a>
	            				</span>
	            			</td>
	        			</tr>
	        			<tr id="tdEndDate" style="DISPLAY:none">
	          				<th><spring:message code = 'ezCommunity.t384' /></th>
	          				<td>
	          					<c:choose>
	          						<c:when test="${(pMode != 'modify' && boardInfo.expireDays == '-1') || (pMode == 'modify' && fn:substring(strEndDate, 0, 4) == '9999') || (pUrl != '')}">
	          							<span id="Chkbox">
			            					<input type="checkbox" id="ChkPermanence" name="ChkPermanence" onClick="return ChkPermanent()" checked>
			            					<spring:message code = 'ezCommunity.t930' />
			            				</span>
			            				<span id="Makedate">
			            					<input type="text" id='_D2' class='datepicker_date' name="txtPermanence" readonly="readonly">
							            	<img id="img_EndCalDisp" src="/images/i_scheduler.gif" width="19" height="15" align="absMiddle" style="CURSOR: pointer; POSITION: relative" popuplocation='bottomright' tabindex="0" popupLocation='topright' forcemarginleft="-40"  forceMarginTop="30">
							            	<input id='_T2' type="hidden" class='datepicker_time' readonly="readonly" name="hidden">
							            	<img align="middle" border="0" height="20" id="img_EndTime" src="../../images/arrow_right.gif" style="DISPLAY: none; POSITION: relative" width="20" popupLocation='bottomright'>
							            </span>		
	          						</c:when>
	          						
	          						<c:otherwise>
	          							<span id="Chkbox">
								            <input type="checkbox" id="ChkPermanence" name="ChkPermanence" onClick="return ChkPermanent()">
				            				<spring:message code = 'ezCommunity.t930' />
				            			</span>
				            			<span id="Makedate">
								            <input type="text" id='_D2' class='datepicker_date' name="txtPermanence" readonly>
								            <img id="img_EndCalDisp" src="/images/i_scheduler.gif" width="19" height="16" align="absMiddle" style="CURSOR: pointer; POSITION: relative" popuplocation='bottomright' tabindex="0" popupLocation='topright'>
								            <input id='_T2' type="hidden" class='datepicker_time' readonly name="hidden">
								            <img align="middle" border="0" height="20" id="img_EndTime" src="../../images/arrow_right.gif" style="DISPLAY: none; CURSOR: pointer; POSITION: relative" width="20" popupLocation='bottomright'>
								        </span>
	          						</c:otherwise>
	          					</c:choose>
	          				</td>
	        			</tr>
	        			<tr style="display:none">
	          				<th><spring:message code = 'ezCommunity.t1171' /></th>
	          				
	          				<c:choose>
	          					<c:when test="${item.importance == '1' }">
	          						<td>
			          					<INPUT type="checkbox" id="chkEmergent" checked>
			            				<spring:message code = 'ezCommunity.t1172' />
			            			</td>
	          					</c:when>
	          					
	          					<c:otherwise>
	          					<td>
		          					<INPUT type="checkbox" id="chkEmergent">
		            				<spring:message code = 'ezCommunity.t1172' />
		            			</td>
	          					</c:otherwise>
	          				</c:choose>

	        			</tr>
	        			
	        			<c:if test="${boardInfo.gubun == '2' }">
	        				<tr style="display:none">
					        	<th><spring:message code = 'ezCommunity.t1173' /></th>
					          	<td><INPUT type=text id="txtNickName" style="WIDTH:150px" maxlength=15 value="<c:out value = '${writerName}' />">&nbsp;&nbsp;(<spring:message code = 'ezCommunity.t1174' /></td>
					        </tr>
					        <tr style="display:none">
					        	<th><spring:message code = 'ezCommunity.t1175' /></th>
					          	<td><INPUT type="password" id="txtPassWord" style="WIDTH:150px" maxlength="15">&nbsp;&nbsp;(<spring:message code = 'ezCommunity.t1176' /></td>
					        </tr>
	        			</c:if>
	        
        				<tr style="display:none">
          					<th><spring:message code = 'ezCommunity.t433' /></th>
          					<td><INPUT type="text" id="txtAbstract"  style="WIDTH:100%;word-break:break-all" value="" maxlength=100></td>
				        </tr>
				        <tr>
          					<th><spring:message code = 'ezCommunity.t124' /></th>
          					<td colspan ="2"><INPUT type="text" id="txtTitle" style="WIDTH:100%;word-wrap:break-word;word-break:break-all;" value="" maxlength=100 onKeyDown="Title_onkeyDown(event)"></td>
				        </tr>
				        <tr>
            				<th><spring:message code = 'ezCommunity.t1218' /></th>
            				<c:choose>
			                	<c:when test="${isCrossBrowser != true}">
			                		<script type="text/javascript">EzHTTPTrans_ActiveX("EzHTTPTrans");</script>
			                		<td class="pos1"><INPUT type="text" id="txtPhotoFile" style="WIDTH:100%" readonly="readonly" ></td>
									<td class="pos2"><a class="imgbtn"><span id="btn_AttachAdd" onClick="return btn_PhotoAttachAdd_onclick()" ><spring:message code = 'ezCommunity.t1177' /></span></a></td>
									<div id="lstAttachLink" style="display:none;OVERFLOW:auto;HEIGHT:50px;">&nbsp;</div>
			                	</c:when>
			                	<c:otherwise>
			                		<td class="pos1"><INPUT type="text" id="txtPhotoFile" style="WIDTH:100%" readonly="readonly" ></td>
									<td class="pos2"><a class="imgbtn"><span id="btn_AttachAdd" onClick="return btn_PhotoAttachAdd_onclick()" ><spring:message code = 'ezCommunity.t1177' /></span></a></td>
			                	</c:otherwise>
		                	</c:choose>
	                	
							
      					</tr>
      				</table>
      			</td>
			</tr>
			<tr>
    			<td style="padding-bottom:10px;height:100%" id="EdtorSize">
	    			<c:choose>
	    				<c:when test="${editor == 'TAGFREE' }">
	    					<iframe id="message" class="viewbox"  name="message" src="TagFree_TFX_Editor.aspx" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	    				</c:when>
	    				
	    				<c:when test="${editor == 'DEXT' }">
	    					<iframe id="message" class="viewbox"  name="message" src="DEXT_Editor.aspx" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	    				</c:when>
	    				
	    				<c:otherwise>
	    					<iframe id="message" class="viewbox"  name="message" src="/ezCommunity/ckEditor.do" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
	    				</c:otherwise>
	    			</c:choose>
    			</td>
  			</tr>
  			<tr id="docTR" style="display:none">
    			<td>
    				<div id="docContentBorder" style="border:#B6B6B6 1px solid; BACKGROUND-COLOR: white; ">
        				<iframe id="docContent" style="width:100%;height:100%;" frameborder="0"></iframe>
      				</div>
      			</td>
  			</tr>
		</table>
		
		<div id="txtAttachList"></div>
   		<iframe name="ifrm" src="about:blank" style="display:none"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezCommunity/upload.do" target="ifrm" >
			<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width:1px; height:1px;" multiple="true" />
			<input type="hidden" name="boardID" id="boardID" />
			<input type="hidden" name="maxSize" id="maxSize" />
			<input type="hidden" name="mode" id="mode" />
			<input type="hidden" name="cnt" id="cnt" />
			<input type="hidden" name="mailGubun" id="mailGubun" />
		</form>
		
		<script type="text/javascript">
		    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 150 + "PX";
		</script>
	</body>
</html>