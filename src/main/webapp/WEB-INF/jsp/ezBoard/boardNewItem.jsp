<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
	<head>
		<c:choose>
			<c:when test="${mode == 'new' || mode == 'boardAttach' || mode == 'boardContent' || url != ''}">
			    <title><spring:message code='ezBoard.t368' /></title>
			</c:when>
			<c:when test="${mode == 'reply'}">
			    <title><spring:message code='ezBoard.t369' /></title>
			</c:when>
			<c:otherwise>
			    <title><spring:message code='ezBoard.t370' /></title>
			</c:otherwise>
		</c:choose>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezBoard.i1' />" type="text/css">
	    <link rel="stylesheet" href="/css/Tab.css" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/datepicker.htc.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/composeappt.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/ConvertSaveImage.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
	    <c:if test="${!isCrossBrowser}">
		    <script type="text/javascript" src="/js/ezBoard/AttachMain.js?ver_0.52"></script>
		    <script type="text/javascript" src="/js/ezBoard/AttachItem.js?ver_0.52"></script>
		    <script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
	    </c:if>
	    <c:if test="${isCrossBrowser}">
		    <script type="text/javascript" src="/js/ezBoard/AttachMain_CK.js"></script>
		    <script type="text/javascript" src="/js/ezBoard/AttachItem_CK.js"></script>
	    </c:if>
	    <script type="text/javascript" src="/js/rsa/pidcrypt.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
		<script type="text/javascript" src="/js/rsa/asn1.js"></script>
		<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
		<script type="text/javascript" src="/js/rsa/prng4.js"></script>
		<script type="text/javascript" src="/js/rsa/rng.js"></script>
		<script type="text/javascript" src="/js/rsa/rsa.js"></script>
	    <!-- data picker-->
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	    <link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
	    <script type="text/javascript">
		    var pUploadFilePath = "${uploadFilePath}";
		    var pBoardID = "${boardID}";
		    var pBoardName = "${boardInfo.boardName}";
		    var pMode = "${mode}";
		    var orgMode = "${mode}";
		    var pModeOld = "";
		    var MHTLoadComplete = "";
		    var SSUserID = "${userInfo.id}";
			var SSUserName = "${userInfo.displayName1}";
		    var SSUserName2 = "${userInfo.displayName2}";
		    var SSDeptID = "${userInfo.deptID}";
		    var SSDeptName = "${userInfo.deptName1}";
		    var SSDeptName2 = "${userInfo.deptName2}";
		    var SSCompanyID = "${userInfo.companyID}";
		    var SSCompanyName = "${userInfo.companyName1}";
		    var SSCompanyName2 = "${userInfo.companyName2}";
		    var strItemID = "${itemID}";
		    var strWriterID = "${boardListVO.writerID}";
		    var strWriterName = "${boardListVO.writerName}";
		    var strWriterDeptName = "${boardListVO.writerDeptName}";
		    var strWriterCompanyName = "${boardListVO.writerCompanyName}";
		    var strWriteDate = "${boardListVO.writeDate}";
		    var strParentWriteDate = "${boardListVO.parentWriteDate}";
		    var strImportance = "${boardListVO.importance}";
		    var strStartDate = "${boardListVO.startDate}";
		    var strEndDate = "${boardListVO.endDate}";
		    var strAttachments = "${boardListVO.attachments}";
		    var strContentLocation = "${boardListVO.contentLocation}";
		    var strUpperItemIDTree = "${boardListVO.upperItemIDTree}";
		    var strItemLevel = "${boardListVO.itemLevel}";
		    var strWriterTitle = "${boardListVO.extensionAttribute3}";
		    var strWriterFakeName = "${strWriterFakeName}";
		    var pAttachListXml = "";
		    var AttachLimit = "${boardInfo.attachSizeLimit}";
			var pReservedItem = "${reservedItem}";
		    var strUserRank = "${userInfo.title1}";
		    var strUserRank2 = "${userInfo.title2}";
		    var strUserPhone = "${userInfo.phone}";
		    var strNow = "${strNow}";
		    var ExpireDays = "${expireDays}";
		    var ExpireItem = "${expireItem}";
		    var gubun = "${boardInfo.guBun}";
		    var pUrl = "${url}";
		    var pDocID = "${docID}";
		    var PhotoBoard = "";
		    var flag = false;
		    var _hasattach = "${hasAttach}";
		    var BoardAdmin_FG = "${boardInfo.boardAdmin_FG}";
		    var BoardGroupAdmin_FG = "${boardInfo.boardGroupAdmin_FG}";
		    var idDatepicker_Temp = "";
		    var _T1_Temp = "";
		    if (!"${isCrossBrowser}") {
			    var objMHT = new ActiveXObject("MhtFormat.Convert");
			    var objMHTRead = new ActiveXObject("MhtFormat.Convert");
		    } 
		    
		    var NewGuid = "${newGuid}";
			var mgubun = "";
			var attachxml = "";
			var pBoardType = "${boardType}";
		    var saveItemBoardId = "";
		    var SelBoard = false;
		    var pcheckForm = "${checkForm}";
		    var pUseBackGround = "${useBackGround}";
		    var FirstFlag = false;
		    var rsa = new RSAKey();
		    window.onload = function () {
		        if (pUseBackGround == "TRUE") {
		            document.getElementById("pUseBackGroundTR").style.display = "";
		            GetBackGroundImage();
		        }
		        else{
		            document.getElementById("pUseBackGroundTR").style.display = "none";
		        }
				rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
				
				if (!"${isCrossBrowser}") {
			        document.all.EzHTTPTrans.SetBigLang = "${userInfo.lang}" == "1" ? 1 : 0;
			        document.all.EzHTTPTrans.UseDbCl = true;
				}
				
			    if (pMode == "reply")
			        if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) {
			            document.getElementById("file1").multiple = false;
			        }
			    if (gubun != "3") {
			        PhotoBoard = "N";
			    }
			    else {
			        PhotoBoard = "Y";
			    }
	
			    if (pReservedItem != "true") document.getElementById("reservation_date").style.display = "none";
			    if ((pMode == "modify" || pMode == "temp" || pMode == "boardContent" || pMode == "boardAttach") && strAttachments != "") {
			        pAttachListXml = MakeAttachList();
			        if (gubun != "3") {
			            AppendFileAttachInfo(pAttachListXml);
			            if ("${isCrossBrowser}") {
				            if (typeof (pAttachListXml) == "string")
				                pAttachListXml = loadXMLString(pAttachListXml);
				            else
				                pAttachListXml = loadXMLString(getXmlString(pAttachListXml));
				
				            var objAttachNodes = SelectNodes(pAttachListXml, "LISTVIEWDATA/ROWS/ROW");
	
				            for (var i = 0; i < objAttachNodes.length; i++) {
				                if (pMode == "boardContent" || pMode == "boardAttach"){
				                    attachxml += getNodeText(SelectNodes(objAttachNodes[0], "DATA2")[i]) + ";";
				                }else{
				                    attachxml += getNodeText(SelectNodes(objAttachNodes[0], "DATA2")[i]) + ";";
				                }
				            }
			            }
			        }
			        else {
			            RealImageName(pAttachListXml);
			        }
			    }
			    if (pMode == "new") {
			        btn_PostDate_Clear();
			    } else {
			        if (pReservedItem != "true") {
			        	$("#Sdatepicker").datepicker('setDate', "");
			        }

			        if(pMode != "boardContent" && pMode != "boardAttach")
			        {
			            //추가항목
			            try {
			            	if("${fn:length(boardAttributeListVO)}" > 0){
			    				var colType = new Array();
			    				var tableCol = new Array();
			    				
			    				<c:forEach items="${boardAttributeListVO}" var = "item" >
			    					colType.push("${item.colType}");
			    					tableCol.push("${item.tableCol}");
			    				</c:forEach>
			    				
			    				for (var i = 0; i < colType.length;i++){
			            			if(colType[i] == "radio") {
			            				SetRadioVal(tableCol[i], getExtensionValue(ConvMakeXMLString(tableCol[i])));
			            			} else if(colType[i] == "text") {
			            				document.getElementById(tableCol[i]).value = getExtensionValue(ConvMakeXMLString(tableCol[i]));
			            			} else if(colType[i] == "check") {
			            				SetCheckVal(tableCol[i], getExtensionValue(ConvMakeXMLString(tableCol[i])));
			            			}
			    				}
			            	}
			            }
			            catch (e) { }
			        }
			    }
			        
			    if (ExpireDays == -1 || ExpireItem == "YES") {
			    	document.getElementById('Makedate').style.display = "none";
			    }
			    if (pMode == "modify" || pMode == "temp") {
			        document.getElementById("txtTitle").value = ConvMakeXMLString("${strTitle}");
				    document.getElementById("txtAbstract").value = ConvMakeXMLString("${boardListVO.ABSTRACT}");
				    if (gubun == "3") {
				        document.getElementById("txtPhotoFile").value = ConvMakeXMLString("${boardListVO.extensionAttribute4}");
				    }
			        if (gubun == "2") {
			            document.getElementById("txtNickName").value = ConvMakeXMLString(strWriterFakeName);
			        }
			    }
			    if (pMode == "reply") {
			        document.getElementById("txtTitle").value = ConvMakeXMLString("${strTitle}");
				}
			    if (pReservedItem != "true") {
			        //var nowDate = new Date();
			        //if ($('#Stimepicker').val == "") {
			        //    if (nowDate.getMinutes() <= 30) {
			        //        $("#Sdatepicker").datepicker('setTime', nowDate.getHours() + ":" + "30");
			        //    }
			        //    else {
			        //        $("#Sdatepicker").datepicker('setTime', nowDate.getHours() + ":" + "00");
			        //    }
				    //}
			    }
			    FirstFlag = true;
			    ChkPermanent();
			    FirstFlag = false;
			    try {
			        if (document.getElementById("txtTitle").value == "")
			            if (OpenWin == null)
			                document.getElementById("txtTitle").focus();
			    }
			    catch (e) { }
		    };
		    window.onresize = function () {
		        switch (pSelectTab) {
		            case "MailEnv_div1":
		                if ("${boardInfo.guBun}" == "2")
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 350 + "PX";
		                else if ("${docID}" != "")
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 500 + "PX";
		                else
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 320 + "PX";
		                break;
		            case "MailEnv_div3":
		                {
		                    if (pUseBackGround == "TRUE") {
		                        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 430 + "PX";
		                        if ("${docID}" != "")
		                            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 600 + "PX";
		                    }
		                    else
		                        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 350 + "PX";
		                    break;
		                }
		            default:
		                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 320 + "PX";
		                break;
		        }
		    };
		
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        var settime = "${startDateTime}";
		        var NowDate = new Date(settime.substring(0, 4), settime.substring(5, 7), settime.substring(8, 10), settime.substring(11, 13), settime.substring(14, 16));
		        NowDate.setMonth(NowDate.getMonth() - 1);
		
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', NowDate);
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
		
		        $("#Sdatepicker2").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
       
		        if (ExpireDays != -1) {
			        var utcDate = new Date(strNow.substring(0, 10));
			        utcDate.setDate(utcDate.getDate() + Number(ExpireDays));
		        } else {
			        var utcDate = new Date(strNow.substring(0, 10));
			        utcDate.setMonth(utcDate.getMonth() + 1);
		        }
		        
		        $("#Sdatepicker2").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker2").datepicker('setDate', utcDate);
		    });
		    if("${userInfo.lang}" == "1"){
		        $(function () {
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
		        });
		    }else{
		        $(function () {
		            $.datepicker.regional['en'] = {
		                dateFormat: 'yy-mm-dd',
		                firstDay: 0,
		                isRTL: false,
		                duration: 200,
		                showAnim: 'show',
		                showMonthAfterYear: true
		            };
		            $.datepicker.setDefaults($.datepicker.regional['en']);
		        });
		    }
		    
		    function DateFormat(obj) {
		        var yy = String(obj.getFullYear()).substring(0, 4);
		        if (String(obj.getMonth() + 1).length == 1) {
		            var mm = "0" + (obj.getMonth() + 1);
		        }
		        else {
		            var mm = obj.getMonth() + 1;
		        }
		        if (String(obj.getDate()).length == 1) {
		            var dd = "0" + obj.getDate();
		        }
		        else {
		            var dd = obj.getDate();
		        }
		        var date = String(yy) + "-" + String(mm) + "-" + String(dd);
		        return date;
		    }
		    function RealImageName(ret) {
		        try {
		            pAttachListXml = ret;
		            var xmlAttach = createXmlDom();
		            xmlAttach = loadXMLString(ret);
		            var objAttachNodes = SelectNodes(xmlAttach, "LISTVIEWDATA/ROWS/ROW");
		            document.getElementById("txtPhotoFile").value = SelectSingleNodeValue(objAttachNodes[0], "CELL/VALUE");
		        }
		        catch (e) {
		            alert("RealImageName :: " + e.description);
		        }
		    }
		    function MakeAttachList() {
		        var xmldom = createXmlDom();
		        var str = "";
		        var i = 0;
		        var filename = "";
		        var filepath = "";
		        var resText = "";
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezBoard/getItemAttachments.do",	        			
					data : { itemID : strItemID, 
							 mode   : pMode,
							 conLocation : strContentLocation,
							 title  : "${strTitle}"
						   },
					success: function(result){
						resText = result;
					}        			
				});	
		        xmldom.async = false;
		        xmldom.preserveWhiteSpace = true;
		        xmldom = loadXMLString(resText);
		        xmlhttp = null;
		        var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
		        str += "<LISTVIEWDATA><HEADERS><HEADER><NAME>"+"<spring:message code='ezBoard.t375' />"+"</NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME>"+"<spring:message code='ezBoard.t376' />"+"</NAME><WIDTH>50</WIDTH></HEADER></HEADERS><ROWS>";
		        for (i = 0; i < xmldomNodes.length; i++) {
		            filepath = SelectSingleNodeValue(xmldomNodes[i], "FilePath");
		            filename = MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "FileName"));
		            
		            str += "<ROW><CELL>";
		            str += "<VALUE>" + filename + "</VALUE>";
		            str += "<DATA1>" + "${boardListVO.extensionAttribute4}".substring(0, "${boardListVO.extensionAttribute4}".length - 1) + "</DATA1>";
		            str += "<DATA2>" + MakeXMLString(filepath) + "</DATA2>";
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
		        if ($('#Sdatepicker').val() && document.getElementById("chk_reservation").checked) {
		            if ($('#Stimepicker').val()) {
		                pReservationTime = $('#Sdatepicker').val() + " " + $('#Stimepicker').val() + ":00";
		            }
		            else {
		                pReservationTime = $('#Sdatepicker').val() + " 00:00:00";
		            }
		        }
		        return pReservationTime;
		    }
		    function GetEndDate() {
		        var pEndDateTime;
		        if (document.getElementById("ChkPermanence").checked) {
		            pEndDateTime = "9999-12-30 23:59:59";
		        } else {
		            if ((pMode == "modify" || pMode == "temp") && $('#Sdatepicker2').val().substring(0, 4) != "9999") {
		                pEndDateTime = $('#Sdatepicker2').val() + strEndDate.substring(10, 19);
		            }
		            else {
		                pEndDateTime = $('#Sdatepicker2').val() + strNow.substring(10, 19);
		            }
		        }
		        return pEndDateTime;
		    }
		    function SaveItem(pMode) {
		        if (pBoardID == "") {
		            if (!SelBoard) {
		                alert("<spring:message code='ezBoard.t173' />");
		                return;
		            }
		        }
		        if (MHTLoadComplete != "true") {
		            alert("<spring:message code='ezBoard.t368' />");
		            return;
		        }
		
		        //추가항목
				var must = new Array();
				var colType = new Array();
				var colName1 = new Array();
				var tableCol = new Array();
				
				<c:forEach items="${boardAttributeListVO}" var = "item" >
					colType.push("${item.colType}");
					must.push("${item.must}");
					colName1.push("${item.colName1}");
					tableCol.push("${item.tableCol}");
				</c:forEach>
				
				for (var i = 0; i < colType.length;i++){
					if(must[i] == "Y"){
		        		if(colType[i] == "radio"){
		        			if(GetRadioVal(tableCol[i]) == ""){
		        				Tab1_MouseClick(document.getElementById("1tab1"));
	                            alert(colName1[i] + strLang79);
	                            return;
		        			}
		        		}else if(colType[i] == "text"){
		        			if(document.getElementById(tableCol[i]).value == ""){
		        				Tab1_MouseClick(document.getElementById("1tab1"));
	                            alert(colName1[i] + strLang79);
	                            return;
		        			}
		        		}else if(colType[i] == "check"){
		        			if(GetCheckVal(tableCol[i]) == ""){
		        				Tab1_MouseClick(document.getElementById("1tab1"));
	                            alert(colName1[i] + strLang79);
	                            return;
		        			}
		        		}
		        	}	
				}

		        var newID = "";
		        var pStartDate = GetStartDate();
		        var pEndDate = GetEndDate();
		        
		        if (document.getElementById("ChkPermanence").checked == false) {
		            var configEndDate = Number(ReplaceText("${endDateTime}", "-", ""));
		            var currEndDate = Number(ReplaceText(pEndDate.substring(0, 10), "-", ""));
		            var currReserveDate = Number(ReplaceText(pStartDate.substring(0, 10), "-", ""));
		            if (configEndDate < currEndDate) {
		                alert("<spring:message code='ezBoard.t382' />" + "${endDateTime}" + "<spring:message code='ezBoard.t383' />");
		                return;
		            }
		            if (currEndDate < currReserveDate) {
		                alert("<spring:message code='ezBoard.t384' />" + pEndDate.substring(0, 10) + " <spring:message code='ezBoard.t383' />");
		                return;
		            }
		        }
		        if (document.getElementById("chk_reservation").checked && pMode == "temp") {
		            alert("<spring:message code='ezBoard.t00029' />");
		            return;
		        }
		        if (document.getElementById("chk_reservation").checked && pStartDate == "") {
		            alert("<spring:message code='ezBoard.t385' />");
		            return;
		        }
		        if (pStartDate != "" && pStartDate < strNow) {
		            alert("<spring:message code='ezBoard.t386' />");
		            return;
		        }
		        if (pEndDate != "" && pEndDate < strNow) {
		            alert("<spring:message code='ezBoard.t387' />");
		            return;
		        }
		        if (pStartDate != "" && pEndDate != "" && pEndDate < pStartDate) {
		            alert("<spring:message code='ezBoard.t389' />");
		            return;
		        }
		        if (document.getElementById("txtTitle").value == "") {
		            alert("<spring:message code='ezBoard.t390' />");
		            Tab1_MouseClick(document.getElementById("1tab1"));
		            document.getElementById("txtTitle").focus();
		            return;
		        }
		        if (gubun == "2" && document.getElementById('txtPassWord').value == "") {
		            alert("<spring:message code='ezBoard.t391' />");
		            Tab1_MouseClick(document.getElementById("1tab1"));
		            txtPassWord.focus();
		            return;
		        }
		        if (gubun == "3" && (pAttachListXml == "" || document.getElementById("txtPhotoFile").value == "")) {
		            alert("<spring:message code='ezBoard.t454' />");
		            return;
		        }
		        if (pStartDate == "" && pReservedItem == "TRUE") {
		            strParentWriteDate = "";
		        }
		        newID = "{" +NewGuid+ "}";
		        var xmlDom = createXmlDom();
		        var xmlhttp = createXMLHttpRequest();

		        var objNode = null, objSubNode = null, objDataNode = null;
		        objNode = createNodeInsert(xmlDom, objNode, "NODES");
		        objSubNode = createNodeAndAppandNode(xmlDom, objNode, objSubNode, "NODE");

		        if (gubun != "3") {
		            if (pMode != "modify") {
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMID", newID);
		            } else {
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMID", strItemID);
		            }
		        }
		        
		        var importance = "";
		        if (document.getElementById('chkEmergent').checked) {
		            importance = "1";
		        } else {
		            importance = "0";
		        }
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "BOARDID", pBoardID);
		        if (gubun != "2") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERID", SSUserID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME", MakeXMLString(SSUserName));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME2", MakeXMLString(SSUserName2));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTID", SSDeptID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME", MakeXMLString(SSDeptName));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME2", MakeXMLString(SSDeptName2));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYID", SSCompanyID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME", MakeXMLString(SSCompanyName));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME2", MakeXMLString(SSCompanyName2));
		        }
		        else {
		            var nickname = document.getElementById("txtNickName").value;
		            if (nickname == "") nickname = "<spring:message code='ezBoard.t286' />";

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
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TITLE", document.getElementById("txtTitle").value);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "STARTDATE", pStartDate);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ENDDATE", pEndDate);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ABSTRACT", document.getElementById("txtAbstract").value);
		        
		        if (CrossYN()) {
		            if (attachxml != "") {
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ATTACHMENTS", attachxml);
		            } else {
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ATTACHMENTS", "");
		            }
		        } else {
	            	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ATTACHMENTS", MakeXMLString(AttachFileList()));
		        }

		        if (pMode == "new" || pMode == "boardContent" || pMode == "boardAttach" || pUrl != "" || orgMode == "temp") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", newID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TOPWRITERID", SSUserID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", "1");
		        } else if ((pMode == "modify" || pMode == "temp") && pReservedItem == "") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", strUpperItemIDTree);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TOPWRITERID", strWriterID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", strParentWriteDate);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", strItemLevel);
		        } else if ((pMode == "modify" || pMode == "temp") && pReservedItem == "true") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", strUpperItemIDTree);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TOPWRITERID", strWriterID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", pStartDate);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", strItemLevel);
		        } else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", strUpperItemIDTree);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TOPWRITERID", strWriterID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", strParentWriteDate);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", strItemLevel);
		        }

		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "FILEPATH", pUploadFilePath);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE1", "");

		        if (gubun != "3" && document.getElementById('noticePost').checked) {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE2", "1");
		        }
		        else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE2", "");
		        }

		        if (gubun != "2") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE3", strUserRank);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE32", strUserRank2);
		            if (gubun != "3") {
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE4", strUserPhone);
		            }
		            else {
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE4", MakeXMLString(GetFileName()));
		            }
		        }
		        else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE3", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE32", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE4", "");
		        }

		        if (gubun != "3") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE5", "");
		        }
		        else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE5", MakeXMLString(GetSmallUrl()));
		        }
		        var obj = GetBODY(document.getElementById('docContent')).getElementsByTagName("TD");
		        for (var i = 0; i < obj.length; i++) {
		            if (obj[i].free == "")
		                obj[i].removeAttribute('free');
		            if (obj[i].className == "FIELD")
		                obj[i].removeAttribute('className');
		        }
		        if (pDocID != "")
		            message.SetEditorContent(message.GetEditorContent() + "<hr><br/><div contenteditable='false' >" + GetBODY(document.getElementById('docContent')).innerHTML) + "</div>";
		        
		        setTimeout(JSleep, 1000);

		        var strBody = message.GetEditorContent();
		        if (trim_Cross(strBody) != "" || pDocID == "") {
		            strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + EmbedContentIntoXML(strBody).replace("&amp;", "&") + "</BODY>" + "</HTML>");
		        }
		        else {
		            if (pDocID == "")
		                strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + EmbedContentIntoXML(strBody) + "</BODY>" + "</HTML>");
		            else {
		                var tempstr = strBody + "<hr><br/>" + GetBODY(document.getElementById('docContent')).innerHTML;
		                strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + EmbedContentIntoXML(tempstr) + "</BODY>" + "</HTML>");
		            }
		        }

		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "CONTENT", strBody.replace(/\r\n/g, "@r!n@"));

		        if (gubun == "2")
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DOCPASSWORD", rsa.encrypt(document.getElementById('txtPassWord').value));
		        else
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DOCPASSWORD", "");

		        if (pMode != "new" && pMode != "reply" && pMode != "temp" && pMode != "boardContent" && pMode != "boardContent" && pReservedItem == false) {
		            if (document.getElementById("readCount") != undefined && document.getElementById("readCount").checked)
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "READCOUNTFLAG", "Y");
		            else
		                createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "READCOUNTFLAG", "N");
		        }
		        else
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "READCOUNTFLAG", "N");

		        
				var colType = new Array();
				var tableCol = new Array();
				
				<c:forEach items="${boardAttributeListVO}" var = "item" >
					colType.push("${item.colType}");
					tableCol.push("${item.tableCol}");
				</c:forEach>
				
				for (var i = 0; i < colType.length;i++){
		        	if(colType[i] == "radio") {
		        		createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, tableCol[i].toUpperCase() ,GetRadioVal(tableCol[i]));
		        	} else if(colType[i] == "text") {
		        		createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, tableCol[i].toUpperCase() ,document.getElementById(tableCol[i]).value);
		        	} else if(colType[i] == "check") {
		        		createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, tableCol[i].toUpperCase() ,GetCheckVal(tableCol[i]));
		        	}
				}

		        xmlhttp.open("POST", "/ezBoard/saveItem.do?mode=" + pMode + "&guBun=" + gubun, false);
		        xmlhttp.send(xmlDom);
				if (getNodeText(GetChildNodes(loadXMLString(xmlhttp.responseText))[0]) == "OK") {
		            xmlhttp = null;
		            xmlDom = null;
		            if (orgMode == "temp") {
		                var xmlDom = createXmlDom();
		                var xmlhttp = createXMLHttpRequest();
		
		                xmlhttp.open("POST", "/ezBoard/deleteTempItem.do", false);
		                xmlhttp.send(strItemID);
		            }
		
		            if (pMode != "temp") {
		                if (document.getElementById("chk_reservation").checked == false) {
		                    if (strItemID == "") {
		                        xmlhttp = createXMLHttpRequest();
		                        xmlhttp.open("POST", "/ezBoard/sendPostNotiMail.do?boardID=" + pBoardID + "&itemID=" + newID, false);
		                        xmlhttp.send();
		                        xmlhttp = null;
		                    }
		                    if (pMode == "reply") {
		                        xmlhttp = createXMLHttpRequest();
		                        xmlhttp.open("POST", "/ezBoard/sendReplyNoticeMail.do?boardID=" + pBoardID + "&itemID=" + newID + "&itemTreeID=" + strUpperItemIDTree, false);
		                        xmlhttp.send();
		                        xmlhttp = null;
		                    }
		                    alert("<spring:message code='ezBoard.t399' />");
		                } else {
		                    alert("<spring:message code='ezBoard.t400' />" + pStartDate.substr(0, 16) + "<spring:message code='ezBoard.t401' />");
		                }
		                
		                if ("${boardInfo.apprMail_FG}" == "Y") {
		                    xmlhttp = createXMLHttpRequest();
		
		                    if (pMode != "modify") {
		                        xmlhttp.open("POST", "/ezBoard/sendApprNoticeMail.do?boardID=" + pBoardID + "&itemID=" + newID, false);
		                    } else {
		                        xmlhttp.open("POST", "/ezBoard/sendApprNoticeMail.do?boardID=" + pBoardID + "&itemID=" + strItemID, false);
		                    }
		                        
		                    xmlhttp.send();
		                    xmlhttp = null;
		                }
		            }
		            else {
		                alert("<spring:message code='ezBoard.t10033' />");
		            }
		            
		            try {
						window.opener.leftCountRf();
					} catch (e) {
					}
					
		            try {
			            if (window.parent != null && window.parent.SuccessBoard != undefined) {
			                try {
			                    window.parent.SuccessBoard();
			                }
			                catch (e) {
			                }
			            }
			            else if (window.opener != null && window.opener.SuccessBoard != undefined) {
			                try {
			                    window.opener.SuccessBoard();
			                }
			                catch (e) {
			                }
			            }
			            else {
			                try {
			                    if (typeof (window.parent.SuccessBoard) == null || typeof (window.parent.SuccessBoard) == "undefined") {
			                        try {
			                            var checkboard = window.parent.location.toString();
			                            if (checkboard.indexOf("mailReadContent.do") < 0)
			                                window.opener.location.reload(false);
			                        } catch (e) {
			
			                        }
			                    }
			                }
			                catch (e) { }
			                if (pMode == "boardContent" || pMode == "boardAttach") {
			                    try {
			                        if (typeof (window.parent.parent.SuccessBoard) == null || typeof (window.parent.parent.SuccessBoard) == "undefined") {
			                            var checkboard = window.parent.location.toString();
			                            if (checkboard.indexOf("mailReadContent.do") < 0)
			                                window.parent.parent.location.reload(false);
			                        }
			                    }
			                    catch (e) { }
			                }
			
			                try {
			                    window.opener.opener.location.reload(false);
			                } catch (e) {
			
			                }
			            }
					} catch (e) {
					}

		            window.close();
		        } else {
		            if (getNodeText(GetChildNodes(loadXMLString(xmlhttp.responseText))[0]) == "XSS")
		                alert("<spring:message code='ezBoard.t00001' />");
		            else if (getNodeText(loadXMLString(xmlhttp.responseText)) == "INACCESSIBLE")
		                alert(strLang73);
		            else
		                alert("<spring:message code='ezBoard.t403' />" + getNodeText(loadXMLString(xmlhttp.responseText)));
		        }
		        xmlhttp = null;
		        xmlDom = null;
		    	
		    }
		    function JSleep() {
		    	return;
		    }
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		    function MakeXMLString(str) {
		        str = ReplaceText(str, "&", "&amp;");
		        str = ReplaceText(str, "<", "&lt;");
		        str = ReplaceText(str, ">", "&gt;");
		        return str;
		    }
		    function btn_PostDate_Clear() {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        var settime = "${startDateTime}";
		        var NowDate = new Date(settime.substring(0, 4), settime.substring(5, 7), settime.substring(8, 10), settime.substring(11, 13), settime.substring(14, 16));
		        NowDate.setMonth(NowDate.getMonth() - 1);
		
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', NowDate);
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
		    }
		    function ChkPermanent() {
		        if (pBoardType != "SELECT") {
		            if (ExpireDays != -1) {
		                if(!FirstFlag) {
		                    alert("<spring:message code='ezBoard.t405' />");
		                }
		
		                document.getElementById("ChkPermanence").checked = false;
		                return;
		            }
		            if (document.getElementById("ChkPermanence").checked) {
		                document.getElementById("Makedate").style.display = "none";
		            } else {
		            	document.getElementById("Makedate").style.display = "";
		                if (strEndDate != "") {
		                    if (strEndDate.substring(0, 4) == "9999") {
		                        $("#Sdatepicker2").datepicker({
		                            changeMonth: true,
		                            changeYear: true,
		                            autoSize: true,
		                            showOn: "both",
		                            buttonImage: "/images/ImgIcon/calendar-month.gif",
		                            buttonImageOnly: true
		                        });
		                        var NowDate2 = new Date();
		                        NowDate2.setMonth(NowDate2.getMonth() + 1);
		                        $("#Sdatepicker2").datepicker("option", "dateFormat", "yy-mm-dd");
		                        $("#Sdatepicker2").datepicker('setDate', NowDate2);
		                    }
		                    else {
		                        var NowDate = new Date(strEndDate.substring(0, 4), strEndDate.substring(5, 7), strEndDate.substring(8, 10), strEndDate.substring(11, 13), strEndDate.substring(14, 16));
		                        NowDate.setMonth(NowDate.getMonth() - 1);
		                        $("#Sdatepicker2").datepicker('setDate', NowDate);
		                    }
		                }
		            }
		        }
		    }
		    function Reservation_onclick() {
		        if (document.getElementById("chk_reservation").checked == true) {
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
		        if (gubun != "2")
		            window.open("/ezBoard/boardItemPreView.do?guBun=" + gubun + "&boardID=" + pBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=772,top=" + pTop + ",left=" + pLeft, "");
		        else {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                window.open("/ezBoard/boardItemPreView.do?guBun=" + gubun + "&boardID=" + pBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=640,width=772,top=" + pTop + ",left=" + pLeft, "");
		            }
		            else {
		                window.open("/ezBoard/boardItemPreView.do?guBun=" + gubun + "&boardID=" + pBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=690,width=772,top=" + pTop + ",left=" + pLeft, "");
		            }
		        }
		    }
		    function AddDate(pDate, pDays) {
		        var dt = new Date(pDate);
		        dt.setDate(dt.getDate() + pDays);
		        return dt;
		    }
		    function AutoAddtoExpireDate() {
		        var temp = ExpireDays;
		        if (temp == -1) temp = 30;
		
		        idDatepicker.vtLocalEndDate = AddDate(idDatepicker.vtLocalDate, temp);
		    }
		    var BoardSelect_Cross_dialogArgument = new Array();
		    var OpenWin = null;
		    function SelectBoard(CompleteFunction) {
		        BoardSelect_Cross_dialogArgument[0] = "";
		        BoardSelect_Cross_dialogArgument[1] = CompleteFunction;
		        var url = "/ezBoard/boardSelect.do";
		
		        OpenWin = window.open(url, "BoardSelect_Cross", GetOpenWindowfeature(352, 700));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		
		    var MailxmlHTTP = createXMLHttpRequest();
		    function InsertMailInfo() {
		        var _newGuid = "{" + NewGuid + "}";
		        var strQuery = "<DATA><URL>" + pUrl + "</URL><NEWGUID>" + _newGuid + "</NEWGUID><ATTACHLIMIT>" + AttachLimit + "</ATTACHLIMIT></DATA>";
		        var FileName = "";
		        var FileURL = "";
		        var ItemID = "";
		        MailxmlHTTP.open("POST", "/ezEmail/mailReadBoard.do", false);
		
		        MailxmlHTTP.send(strQuery);
		        if (MailxmlHTTP.status == 200) {
		            var mailXml = loadXMLString(MailxmlHTTP.responseText);
		            document.getElementById('txtTitle').value = "<spring:message code='ezBoard.t409' />" + getNodeText(mailXml.getElementsByTagName("SUBJECT").item(0));
		            var Content = "<P>&nbsp;<br></P><br><DIV><br><br>-----<B>[&nbsp;"+"<spring:message code='ezBoard.t410' />"+"</B>-----</DIV><DIV><B>"+"<spring:message code='ezBoard.t411' />"+"</B>" + getNodeText(mailXml.getElementsByTagName("DATE").item(0)) + "</DIV>";
		            if (getNodeText(mailXml.getElementsByTagName("COMMENT").item(0)) != "") {
		                Content = Content + "<DIV><B>"+"<spring:message code='ezBoard.t412' /></B>" + ReplaceText(getNodeText(mailXml.getElementsByTagName("FROMNAME").item(0)), "\\\"", "");
		                Content = Content + "  (" + getNodeText(mailXml.getElementsByTagName("COMMENT").item(0)) + ") </DIV>";
		            }
		            else
		                Content = Content + "<DIV><B>"+"<spring:message code='ezBoard.t412' />"+"</B>" + ReplaceText(ReplaceText(getNodeText(mailXml.getElementsByTagName("FROMNAME").item(0)), "<", "&lt"), ">", "&gt;") + "</DIV>";
		
		            Content = Content + "<DIV><B>"+"<spring:message code='ezBoard.t413' />"+"</B>" + getNodeText(mailXml.getElementsByTagName("SUBJECT").item(0)) + "</DIV><P><br><br>" + getNodeText(mailXml.getElementsByTagName("HTMLDESCRIPTION").item(0)) + "</P>";
		            Content = ReplaceText(Content, "id=doctitle", "");
		            Content = ReplaceText(Content, "id=\"doctitle\"", "");
		            Content = ReplaceText(Content, "id=\'doctitle\'", "");
		            message.SetEditorContent(Content);
		            
		            if (mailXml.getElementsByTagName("OVERSIZE").length > 0) {
	            		alert(strLang8 + AttachLimit + "MB" + strLang9);
	            	} else {
			            if (mailXml.getElementsByTagName("ROOT").length) {
		            		mgubun = "M";
			                
			                attachxml = getNodeText(mailXml.getElementsByTagName("ATTACH").item(0));
			                var strXML = getXmlString(mailXml.getElementsByTagName("ROOT").item(0));
			                returnvalue(strXML);
			            }
	            	}
		        }
		    }
		    
		    /* 2017-01-11 이효민사원 - 사용안함 
		    function InsertMailInfo_Complete(ret) {
		        OpenWin.close();
		        if (ret == "") {
		            if (confirm("<spring:message code='ezBoard.t414' />")) {
		                window.close();
		            }
		            else {
		                OpenWin = null;
		                SelectBoard(InsertMailInfo_Complete);
		                return;
		            }
		        }
		        if (typeof (ret) == "undefined") return "";
		
		        pBoardID = ret;
		        GetBoardInfo();
		        InitializeSettings();
		
		        if (pcheckForm.toUpperCase() == "TRUE") {
		            var tempHtml = message.GetEditorContent();
		            var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=BOARDFORM&DOCID=" + pBoardID;
		            var htmlData = message.SetEditorContentURL2(fullPath);
		            message.SetEditorContent(htmlData + tempHtml);
		        }
		
		        if (pUseBackGround.toUpperCase() == "TRUE") {
		            document.getElementById("pUseBackGroundTR").style.display = "";
		            GetBackGroundImage();
		        }
		        else
		            document.getElementById("pUseBackGroundTR").style.display = "none";
		
		
		        var mailXml = loadXMLString(MailxmlHTTP.responseText);
		        if (mailXml.getElementsByTagName("ATTACHMENT").length > 0) {
		            mgubun = "M";
		            var attachHTTP = createXMLHttpRequest();
		            var filefullpath = "";
		            var strXML = "<ROOT><NODES>";
		            for (var i = 0; i < mailXml.getElementsByTagName("ATTACHMENT").length; i++) {
		                FileName = getNodeText(mailXml.getElementsByTagName("ATTACHMENT").item(i));
		                FileURL = getNodeText(mailXml.getElementsByTagName("ATTACHMENTURL").item(i));
		                ItemID = getNodeText(mailXml.getElementsByTagName("ITEMID").item(0));
		                attachHTTP.open("POST", document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/remote/mail_downloadattachfile.aspx?mode=Attach&ID=" + encodeURIComponent(ItemID) + "&ATTID=" + encodeURIComponent(FileURL) + "&filepath=" + pUploadFilePath + "\\" + pBoardID + "\\uploadFile" + "&newGuid=" + NewGuid, false);
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
		    } */
		    
		     /*
		    function InsertDocInfo() {
		        var ret = "";
		        document.getElementById("docTR").style.display = "";
		        ret = SelectBoard(InsertDocInfo_Complete);
		    }
		    */
		
	        function InsertDocInfo() {
	            if (OpenWin != null) {
	                OpenWin.close();
	                if (ret == "") {
	                    if (confirm("<spring:message code='ezBoard.t414' />")) {
	                        window.close();
	                    }
	                    else {
	                        OpenWin = null;
	                        SelectBoard(InsertDocInfo_Complete);
	                        return;
	                    }
	                }
	
	                if (typeof (ret) == "undefined") return "";
	                pBoardID = ret;
	            }
		        GetBoardInfo();
		        InitializeSettings();
		
		        if (pcheckForm.toUpperCase() == "TRUE") {
		            var tempHtml = message.GetEditorContent();
		            var fullPath = "";
                	$.ajax({
    					type : "POST",
    					dataType : "text",
    					async : false,
    					url : "/ezBoard/getContentInfo.do",	        			
    					data : { type : "BOARDFORM", 
    							 docID: pBoardID
    						   },
    					success: function(result){
    						fullPath = result;
    					}        			
    				});	
		            var htmlData = message.SetEditorContentURL2(fullPath);
		            message.SetEditorContent(htmlData + tempHtml);
		        }
		
		        if (pUseBackGround.toUpperCase() == "TRUE") {
		            document.getElementById("pUseBackGroundTR").style.display = "";
		            GetBackGroundImage();
		        }
		        else
		            document.getElementById("pUseBackGroundTR").style.display = "none";
		
		
		        if (pUrl.toLowerCase().indexOf(".mht") > -1) {
		            var fullPath = encodeURI(pUrl);
		            var tempXML = createXmlDom();
		            var XmlBodyATT = createXmlDom();
		            var XmlBodyDATA = createXmlDom();
		            var tempStr = "";
		            tempStr = ConvertMHTtoHTML(fullPath);
		            tempXML = loadXMLString(tempStr);
		            XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
		            XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
		            var htmlData = getNodeText(XmlBodyDATA);
		
		            if (gubun == "3") {
		                document.getElementById('docContent').style.height = "220px";
		            }
		            document.getElementById("docTR").style.display = "";
		
		            var TDRows;
		            if (CrossYN()) {
		                docContent.document.body.innerHTML = htmlData.replace(/(<p)/igm, '<div').replace(/<\/p>/igm, '</div>');
		                docContent.document.body.getElementsByTagName("TABLE").item(0).align = "center";
		                TDRows = docContent.document.getElementsByTagName("TD");
		            }
		            else {
		                docContent.document.body.innerHTML = htmlData.replace(/(<p)/igm, '<div').replace(/<\/p>/igm, '</div>');
		                docContent.document.body.getElementsByTagName("TABLE").item(0).align = "center";
		                TDRows = docContent.document.getElementsByTagName("TD");
		            }
		            for (var i = 0; i < TDRows.length; i++) {
		                if (TDRows.item(i).outerHTML.indexOf("class=FIELD") > 0) {
		                    if (TDRows.item(i).childNodes.length == 0) {
		                        if (TDRows.item(i).outerHTML.indexOf("><\/TD>") > 0) {
		                            TDRows.item(i).innerHTML = "&nbsp;";
		                        }
		                    }
		                }
		            }
		        }
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlpara = createXmlDom();
		        var xmlstring = "<DocID>" + pDocID + "</DocID>";
		        xmlpara = loadXMLString(xmlstring);
		        if (pUrl.toLowerCase().indexOf("/upload_approval/") > -1)
		            xmlHTTP.open("POST", "/ezApprovalG/aprAttachMail.do", false);
		        else
		            xmlHTTP.open("POST", "/ezApprovalG/aprAttachMail.do", false);
		        xmlHTTP.send(xmlpara);
		        if (xmlHTTP.status == 200) {
		            var xmldom = createXmlDom();
		            xmldom = loadXMLString(xmlHTTP.responseText);
		            document.getElementById("txtTitle").value = "<spring:message code='ezBoard.t420' />" + getNodeText(GetElementsByTagName(xmldom, "DOCTITLE")[0]);
		            var xmlHTTP2 = createXMLHttpRequest();
		            var xmldom2 = createXmlDom();
		            if (SelectNodes(xmldom, "ATTACHNAME").length > 0) {
		                var xmlstring = "<DATA><BOARDID>" + pBoardID + "</BOARDID><ROWS>";
		                for (var i = 0; i < SelectNodes(xmldom, "ATTACHNAME").length; i++) {
		                    var temppath = getNodeText(SelectNodes(xmldom, "ATTACHFILEHREF")[i]);
		                    temppath = temppath.substring(34, temppath.length);
		                    var orgfile = temppath.split("/");
		                    orgfile = orgfile[orgfile.length - 1];
		                    xmlstring += "<ROW><FILENAME><![CDATA[" + getNodeText(SelectNodes(xmldom, "ATTACHNAME")[i]) + "]]></FILENAME>";
		                    xmlstring += "<FILEPATH>" + temppath + "</FILEPATH>";
		                    xmlstring += "<ORGFILEPATH>" + orgfile + "</ORGFILEPATH>";
		                    if (pUrl.toLowerCase().indexOf("/upload_approval/") > -1)
		                        xmlstring += "<TYPE>APPROVAL</TYPE>";
		                    else
		                        xmlstring += "<TYPE>APPROVALG</TYPE>";
		                    xmlstring += "<FILESIZE>" + getNodeText(SelectNodes(xmldom, "ATTACHFILESIZE")[i]) + "</FILESIZE></ROW>";
		                }
		                if (pUrl.toLowerCase().indexOf(".hwp") > -1) {
		                    xmlstring += "<ROW><FILENAME>" + "<spring:message code='ezBoard.t419' />".split(".")[0] + "</FILENAME>";
		                    if (pUrl.toLowerCase().indexOf("/upload_approval/") > -1) {
		                        xmlstring += "<FILEPATH>" + pUrl.split("upload_approval")[1] + "</FILEPATH>";
		                        xmlstring += "<TYPE>APPROVAL</TYPE>";
		                    }
		                    else {
		                        xmlstring += "<FILEPATH>" + pUrl.split("upload_approvalG")[1] + "</FILEPATH>";
		                        xmlstring += "<TYPE>APPROVALG</TYPE>";
		                    }
		                    xmlstring += "<ORGFILEPATH>" + "<spring:message code='ezBoard.t419' />" + "</ORGFILEPATH>";
		                    xmlstring += "<FILESIZE>0</FILESIZE></ROW>";
		                }
		                xmlstring += "</ROWS></DATA>";
		                xmldom2 = loadXMLString(xmlstring);
		                xmlHTTP.open("POST", "/ezBoard/uploadApprovFile.do", false);
		                xmlHTTP.send(xmldom2);
		                returnvalue(xmlHTTP.responseText);
		
		                var xml = loadXMLString(xmlHTTP.responseText);
		                var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
		                var strRet = "";
		                for (i = 0; i < nodes.length; i++) {
		                    var filepath = getNodeText(GetChildNodes(nodes[i])[0]);
		                    strRet += "tempUploadFile/" + filepath + ";";
		                }
		                attachxml = strRet;
		            }
		        }
		    }
		    function GetBoardInfo() {
		        var xmlhttp_boardinfo = createXMLHttpRequest();
		        xmlhttp_boardinfo.open("POST", "/ezBoard/getBoardInfo.do?boardID=" + pBoardID, false);
		        xmlhttp_boardinfo.send();
		        if (xmlhttp_boardinfo.status == 200) {
		            pBoardName = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "BOARDNAME")[0]);
		            AttachLimit = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "ATTACHLIMIT")[0]);
		            ExpireDays = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "EXPIREDAYS")[0]);
		            gubun = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "GUBUN")[0]);
		            pcheckForm = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "FORM")[0]);
		            pUseBackGround = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "BACKIMAGE")[0]);
		        }
		        xmlhttp_boardinfo = null;
		    }
		    function InitializeSettings() {
		        document.getElementById('BoardSpan').innerHTML = pBoardName;
		        if (ExpireDays == "-1") {
		            document.getElementById('ChkPermanence').checked = true;
		            document.getElementById('Makedate').style.display = "none";
		        }
		        else {
		            document.getElementById('ChkPermanence').checked = false;
		            document.getElementById('Makedate').style.display = "";
		            //idDatepicker.vtLocalEndDate(AddDate(idDatepicker.vtLocalDate(), parseInt(ExpireDays)));
		        }
		    }
		    function Title_onkeyDown(e) {
		        if (window.event) {
		            if (e.keyCode != 9)
		                return;
		        }
		        else {
		            if (e.which != 9)
		                return;
		        }
		    }
		    function ConvMakeXMLString(str) {
		        str = ReplaceText(str, "&amp;", "&");
		        str = ReplaceText(str, "&lt;", "<");
		        str = ReplaceText(str, "&gt;", ">");
		        str = ReplaceText(str, "&quot;", "\"");
		        str = ReplaceText(str, "&#39;", "'");
		        return str;
		    }
		    function GetSmallUrl() {
		        var strRet = "";
		        var filepath = "";
		        if (typeof (pAttachListXml) == "string")
		            pAttachListXml = loadXMLString(pAttachListXml);
		        else
		            pAttachListXml = loadXMLString(getXmlString(pAttachListXml));
		
		        if (getXmlString(pAttachListXml) == "") {
		            return "";
		        }
		        var xmldomNodes = GetElementsByTagName(pAttachListXml, "DATA2");
		        for (var i = 0; i < xmldomNodes.length; i++) {
		            filepath = getNodeText(xmldomNodes[i]);
		            if (filepath.indexOf(pBoardID) != -1) {
		                var idx = filepath.lastIndexOf("/");
		                if (idx != -1) {
		                    strRet += filepath.substr(0, idx + 1) + "s_" + filepath.substr(idx + 1) + ";";
		                }
		            } else {
		                strRet += pBoardID + "/uploadFile/s_" + getNodeText(xmldomNodes.item(i)) + ";";
		            }
		        }
		        xmldom_attachlist = null;
		        return strRet;
		    }
		    function GetFileName() {
		        var strRet = "";
		        if (typeof (pAttachListXml) == "string")
		            pAttachListXml = loadXMLString(pAttachListXml);
		        else
		            pAttachListXml = loadXMLString(getXmlString(pAttachListXml));
		        if (getXmlString(pAttachListXml) == "") {
		            return "";
		        }
		        var xmldomNodes = GetElementsByTagName(pAttachListXml, "DATA1");
		        for (var i = 0; i < xmldomNodes.length; i++) {
		            strRet += getNodeText(xmldomNodes.item(i)) + ";";
		        }
		        return strRet;
		    }
		    function DocumentComplete() {
		        if (flag == false) {
		            flag = true;
		            if (pMode == "new" || pModeOld == "loadpc" || pMode == "boardAttach") {
		                if (pcheckForm.toUpperCase() == "TRUE") {
		                	var fullPath = "";
		                	$.ajax({
		    					type : "POST",
		    					dataType : "text",
		    					async : false,
		    					url : "/ezBoard/getContentInfo.do",	        			
		    					data : { type : "BOARDFORM", 
		    							 docID: pBoardID
		    						   },
		    					success: function(result){
		    						fullPath = result;
		    					}        			
		    				});	
		                    var htmlData = message.SetEditorContentURL2(fullPath);
		                    message.SetEditorContent(htmlData);
		                }else {
		                    if (OpenWin == null){
		                        document.getElementById("txtTitle").focus();
		                    }
		                    message.SetEditorContent("<p></p>");
		                }
		            } else {
		                if (pUrl == "") {
		                    var fullPath = strContentLocation;
		                    if (pMode == "reply") {
		                        var htmlData = message.SetEditorContentURL2(fullPath);
		                        htmlData = ReplaceText(htmlData, "class=&quot;FIELD&quot;", "");
		                        htmlData = ReplaceText(htmlData, "class=FIELD", "");
		                        htmlData = ReplaceText(htmlData, "&amp;", "&");
		                        htmlData = ReplaceText(htmlData, "&lt;", "<");
		                        htmlData = ReplaceText(htmlData, "&gt;", ">");
		                        
		                        htmlData = "<body free>" + htmlData + "</body>";
		                        if (gubun != "2"){
		                            htmlData = "<br><br>-----<B>[&nbsp;"+"<spring:message code='ezBoard.t423' />"+"</B>-----<br><B>"+"<spring:message code='ezBoard.t424' />"+"</B>" + strWriteDate + "<br><B>"+"<spring:message code='ezBoard.t425' />"+"</B>" + strWriterName + "(" + strWriterTitle + "," + strWriterDeptName + "," + strWriterCompanyName + ")<br><B>"+"<spring:message code='ezBoard.t413' />"+"</B>" + "${boardListVO.title}" + "<br><br>" + htmlData;
		                        }else{
		                            htmlData = "<br><br>-----<B>[&nbsp;"+"<spring:message code='ezBoard.t423' />"+"</B>-----<br><B>"+"<spring:message code='ezBoard.t424' />"+"</B>" + strWriteDate + "<br><B>"+"<spring:message code='ezBoard.t425' />"+"</B>" + strWriterFakeName + "<br><B><spring:message code='ezBoard.t413' /></B>" + "${boardListVO.title}" + "<br><br>" + htmlData;
		                        }
		                        message.SetEditorContent(htmlData);
		                    }else {
		                        message.SetEditorContentURL(fullPath);
		                    }
		                } else {
		                    if (pDocID == "") {
		                        if (InsertMailInfo() == -1) window.close();
		                    }else {
		                        if (InsertDocInfo() == -1) window.close();
		                    }
		                }
		            }
		            MHTLoadComplete = "true";
		        }
		    }
		
		    function btn_AttachSelect_onclick() {
		        document.getElementById('mode').value = "ATT";
		        document.form.file1.click();
		    }
		    
		    var fileSize = 0;
		    function returnvalue(strXML) {
		        var xml = loadXMLString(strXML);
		        var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
		        var extFlag = false;        
		        for (var i = 0; i < nodes.length; i++) {
		            if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
		                if (getNodeText(GetChildNodes(nodes[i])[3]) == 0) {
		                    alert(strLang6);
		                    return;
		                }
		                if (document.getElementById('mode').value == "PHOTO")
		                    document.getElementById('txtPhotoFile').value = getNodeText(GetChildNodes(nodes[i])[2]);
		            }
		            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "denied")
		                extFlag = true;
		            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
		                alert(strLang8 + AttachLimit + "MB" + strLang9);
		                return;
		            }
		            else {
		                alert("<spring:message code='ezCommunity.lhj08'/>" + "\n\n" + result);
		            }
		        }
		        if (extFlag)
		            alert(strLang54);
		
		        if (dadiframe.document.getElementById("lstAttachLink") == null)
		            setTimeout(function () { AttachFileInfo(strXML); }, 500);
		        else
		            AttachFileInfo(strXML);
		    }
		    
		    var firstnode = true;
		    function Tab1_NewTabIni(pTabNodeID) {
		        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
		            if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
		
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };;
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };;
		                    document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };;
		                    if (firstnode) {
		                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).className = "tabon";
		                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).id;
		                        firstnode = false;
		                    }
		
		                }
		            }
		        }
		    }
		    var Tab1_SelectID = "";
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
		    function Tab1_MouserOut(obj) {
		        if (Tab1_SelectID != obj.id)
		            obj.className = "";
		    }
		    function Tab1_MouseClick(obj) {
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
		                document.getElementById(Tab1_SelectID).className = "";
		
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
		    var pSelectTab;
		    function ChangeTab(obj) {
		        
		        pSelectTab = obj.getAttribute("divname");
		        switch (pSelectTab) {
		            case "MailEnv_div1":
		                document.getElementById("tab01").style.display = "";
		                document.getElementById("tab02").style.display = "none";
		                if ("${boardInfo.guBun}" == "2")
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 350 + "PX";
		                else if ("${docID}" != "")
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 500 + "PX";
		                else
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 320 + "PX";
		                break;
		            case "MailEnv_div3":
		                document.getElementById("tab01").style.display = "none";
		                document.getElementById("tab02").style.display = "";
		                if (pUseBackGround == "TRUE") {
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 430 + "PX";
		                    if ("${docID}" != "")
		                        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 600 + "PX";
		                }
		                else
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 350 + "PX";
		
		        }
		        
		    }
		    function bodydragover(evt) {
		        evt.dataTransfer.dropEffect = "none";
		        evt.stopPropagation();
		        evt.preventDefault();
		    }
		    var writeboardselect_modal_dialogArguments = new Array();
		    function NewItem_onclick() {
		        if (CrossYN()) {
		            writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
		            var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(345, 660));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
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
		                GetBoardInfo();
		                if (ret[2] == "3" || ret[2] == "4") {
		                    if (!confirm("<spring:message code='ezBoard.t10053' />"))
		                        return;
		                    else {
		                        document.location.href = "/ezBoard/newBoardItemPhoto.do?boardID=" + ret[0] + "&mode=new&bType=SELECT";
		                        return;
		                    }
		                }
		                else if (ret[2] == "2") {
		                    if (!confirm("<spring:message code='ezBoard.t10054' />"))
		                        return;
		                    else {
		                        document.location.href = "/ezBoard/newBoardItem.do?boardID=" + ret[0] + "&mode=new&boardNM=" + ret[1] + "&bType=SELECT";
		                        return;
		                    }
		                }
		                document.getElementById("BoardSpan").innerHTML = ret[1];
		                InitializeSettings();
		                ChkPermanent();
		                pBoardType = "";
		                
		                if (pcheckForm.toUpperCase() == "TRUE") {
		                	var fullPath = "";
		                	$.ajax({
		    					type : "POST",
		    					dataType : "text",
		    					async : false,
		    					url : "/ezBoard/getContentInfo.do",	        			
		    					data : { type : "BOARDFORM", 
		    							 docID: pBoardID
		    						   },
		    					success: function(result){
		    						fullPath = result;
		    					}        			
		    				});	
		                	
		                    var htmlData = message.SetEditorContentURL2(fullPath);
		                    message.SetEditorContent(htmlData);
		                }
		                else {
		                    if (OpenWin == null)
		                        document.getElementById("txtTitle").focus();
		                    message.SetEditorContent("<p></p>");
		                }
		
		                if (pUseBackGround.toUpperCase() == "TRUE") {
		                    document.getElementById("pUseBackGroundTR").style.display = "";
		                    GetBackGroundImage();
		                }
		                else
		                    document.getElementById("pUseBackGroundTR").style.display = "none";
		
		                SelBoard = true;
		            }
		        }
		    }
		    
	        function NewItem_onclick_Complete(ret) {
	            if (typeof (ret) != "undefined") {
	                pBoardID = ret[0];
	                GetBoardInfo();
	                if (ret[2] == "3" || ret[2] == "4") {
	                    if (!confirm("<spring:message code='ezBoard.t10053' />"))
	                        return;
	                    else {
	                        document.location.href = "/ezBoard/newBoardItemPhoto.do?boardID=" + ret[0] + "&mode=new&bType=SELECT";
	                        return;
	                    }
	                }
	                else if (ret[2] == "2") {
	                    if (!confirm("<spring:message code='ezBoard.t10054' />"))
	                        return;
	                    else {
	                        document.location.href = "/ezBoard/NewBoardItem.do?boardID=" + ret[0] + "&mode=new&boardName=" + ret[1] + "&bType=SELECT";
	                        return;
	                    }
	                }
	                pBoardID = ret[0];
	                document.getElementById("BoardSpan").innerHTML = ret[1];
	                InitializeSettings();
	                ChkPermanent();
	                pBoardType = "";
	
	                if (pcheckForm.toUpperCase() == "TRUE") {
	                	var fullPath = "";
	                	$.ajax({
	    					type : "POST",
	    					dataType : "text",
	    					async : false,
	    					url : "/ezBoard/getContentInfo.do",	        			
	    					data : { type : "BOARDFORM", 
	    							 docID: pBoardID
	    						   },
	    					success: function(result){
	    						fullPath = result;
	    					}        			
	    				});	
	                    var htmlData = message.SetEditorContentURL2(fullPath);
	                    message.SetEditorContent(htmlData);
	                }
	                else {
	                    if (OpenWin == null)
	                        document.getElementById("txtTitle").focus();
	                    message.SetEditorContent("<p></p>");
	                }
	
	                if (pUseBackGround.toUpperCase() == "TRUE") {
	                    document.getElementById("pUseBackGroundTR").style.display = "";
	                    GetBackGroundImage();
	                }
	                else
	                    document.getElementById("pUseBackGroundTR").style.display = "none";
	                SelBoard = true;
	            }
	        }
		
		    var backxmlhttp = null;
		    function GetBackGroundImage() {
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/admin/ezBoard/getBackGroundImage.do",	        			
					data : { type : "USE", 
							 backGroundID: ""
						   },
					success: function(resultXml){
						event_Get_listComplite(resultXml);
					}        			
				});	
		    }
		
		    function event_Get_listComplite(resultXml) {
	            var backxml = loadXMLString(resultXml);
	            var i;
	            for (i = 0; i < SelectNodes(backxml, "DATA/ROW").length; i++) {
	                if (i == 5) {
	                    var br = document.createElement("BR");
	                    document.getElementById("backgroundtd").appendChild(br);
	                }
	                var span = document.createElement("SPAN");
	                span.setAttribute("imgwidth", getNodeText(SelectNodes(SelectNodes(backxml, "DATA/ROW")[0], "WIDTH")[i]));
	                span.setAttribute("imgheight", getNodeText(SelectNodes(SelectNodes(backxml, "DATA/ROW")[0], "HEIGHT")[i]));
	                span.setAttribute("filemane", getNodeText(SelectNodes(SelectNodes(backxml, "DATA/ROW")[0], "SAVEFILENAME")[i]));
	
	                var input = document.createElement("INPUT");
	                input.style.verticalAlign = "top";
	                input.style.marginTop = "10px";
	                input.name = "backradio";
	                input.type = "radio";
	                input.onchange = function () { backgroundimagechange(); };
	
	                var img = document.createElement("IMG");
	                var filepath = getNodeText(SelectNodes(SelectNodes(backxml, "DATA/ROW")[0], "SAVEFILENAME")[i]);
		                img.width = 108;
	                
	                if (navigator.userAgent.indexOf("Chrome") != -1) {
		                img.width = 103;
	                }
	                
	                img.height = 30;
	                img.src = "<spring:eval expression='@commonUtil.getUploadPath(\"upload_board.BOARDBACKGROUND\", \"${userInfo.tenantId}\")' />" + "/S_" + filepath;
	                img.onclick = function () { GetChildNodes(this.parentElement)[0].click(); };
	                img.style.cursor = "pointer";
	
	                span.appendChild(input);
	                span.appendChild(img);
	
	                document.getElementById("backgroundtd").appendChild(span);
	            }
	            if (i == 5) {
	                var br = document.createElement("BR");
	                document.getElementById("backgroundtd").appendChild(br);
	            }
	            var span = document.createElement("SPAN");
	            var input = document.createElement("INPUT");
	            input.style.verticalAlign = "top";
	            input.style.marginTop = "10px";
	            input.name = "backradio";
	            input.type = "radio";
	            input.onchange = function () { backgroundimagechange(); };
	
	            var label = document.createElement("LABEL");
	            label.style.display = "inline-block";
	            label.style.verticalAlign = "top";
	            label.style.marginTop = "10px";
	            label.style.marginBottom = "5px";
	
	            label.innerHTML = "<spring:message code='ezBoard.t5009' />";
	            label.onclick = function () { GetChildNodes(this.parentElement)[0].click(); };
	            label.style.cursor = "pointer";
	
	            span.appendChild(input);
	            span.appendChild(label);
	
	            document.getElementById("backgroundtd").appendChild(span);
	
	            var a = document.createElement("A");
	            a.className = "imgbtn";
	            a.style.verticalAlign = "top";
	            a.style.marginTop = "5px";
	            a.style.marginLeft = "10px";
	
	            var span = document.createElement("SPAN");
	            span.innerHTML = "<spring:message code='ezBoard.t5010' />";
	            span.onclick = function () { BackImageUp(); };
	
	            a.appendChild(span);
	            document.getElementById("backgroundtd").appendChild(a);
		    }
		
		    function backgroundimagechange() {
		        for (var i = 0; i < document.getElementsByName("backradio").length; i++) {
		            if (document.getElementsByName("backradio")[i].checked) {
		                var Table = document.createElement("TABLE");
		                var Tr = document.createElement("TR");
		                var Td = document.createElement("TD");
		                Tr.appendChild(Td);
		                Table.appendChild(Tr);
		                Td.innerHTML = message.GetEditorContent();
		                var temp = Td.getElementsByTagName("TD");
		
		                Td.id = "imagediv";
		                Td.style.verticalAlign = "top";
		                Td.style.fontSize = "10pt";
		                Td.style.lineHeight = "20px";
		                Td.style.wordBreak = "break-all";
		                Td.setAttribute("free", "");
		
		                if (document.getElementsByName("backradio")[i].parentNode.getAttribute("filemane") != null) {
		                    Td.style.backgroundImage = "URL(<spring:eval expression='@commonUtil.getUploadPath(\"upload_board.BOARDBACKGROUND\", \"${userInfo.tenantId}\")'/>" + "/S_" + document.getElementsByName("backradio")[i].parentNode.getAttribute("filemane") + ")";
		                    Table.style.width = document.getElementsByName("backradio")[i].parentNode.getAttribute("imgwidth") + "px";
		                    Table.style.height = document.getElementsByName("backradio")[i].parentNode.getAttribute("imgheight") + "px";
		                }
		                else {
		                    for (var j = 0; j < temp.length; j++) {
		                        if (temp[j].id == "imagediv") {
		                            message.SetEditorContent(temp[j].innerHTML);
		                            break;
		                        }
		                    }
		                    break;
		                }
		                if (temp.length > 0) {
		                    for (var j = 0; j < temp.length; j++) {
		                        if (temp[j].id == "imagediv") {
		                            Td.innerHTML = temp[j].innerHTML;
		                            message.SetEditorContent(Table.outerHTML);
		                            break;
		                        }
		                    }
		                }
		                message.SetEditorContent(Table.outerHTML);
		            }
		        }
		    }
		
		    function BackImageUp() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 330) / 2;
		        var pLeft = (pwidth - 610) / 2;
		        window.open("/admin/ezBoard/selectBackGroundImage.do?type=NEW", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=385,width=610,top=" + pTop + ",left=" + pLeft, "");
		    }
		
	        //추가항목 관련 Function 추가
	        function SetRadioVal(pObjectName, p_strVal) {
	            var RadioBtns = document.getElementsByName(pObjectName);
	            var i;
	            for (i = 0; i < RadioBtns.length; i++) {
	                if (RadioBtns[i].value == p_strVal) { 
	                	RadioBtns[i].checked = true; 
	                	break; 
	                }
	            }
	        }
	
	        //추가항목 관련 Function 추가
	        function GetRadioVal(pObjectName) {
	            var RadioBtns = document.getElementsByName(pObjectName);
	            var strReturn = "";
	            var i;
	            for (i = 0; i < RadioBtns.length; i++) {
	                if (RadioBtns[i].checked) { strReturn = RadioBtns[i].value; break; }
	            }
	            return strReturn;
	        }
	
	        function GetCheckVal(pObjectName) {
	            var chkBoxes = document.getElementsByName(pObjectName);
	            var strReturn = "";
	            var i, j;
	            for (i = 0; i < chkBoxes.length; i++) {
	                if(chkBoxes[i].checked){
	                    strReturn = strReturn + chkBoxes[i].value + ",";
	                }
	            }
	            return (strReturn.length==0) ? "":strReturn.substr(0, strReturn.length-1);
	        }
	
	        function SetCheckVal(pObjectName, p_strVal) {
	            var chkBoxes = document.getElementsByName(pObjectName);
	            var strCheckVals = p_strVal.split(",");
	            var i, j;
	            for (i = 0; i < chkBoxes.length; i++) {
	                for (j = 0; j < strCheckVals.length; j++) {
	                    if (chkBoxes[i].value == strCheckVals[j]) {
	                        chkBoxes[i].checked = true; break;
	                    }
	                }
	            }
	        }
	        
	        function getExtensionValue(tableCol) {
	        	var retValue = "";
	        	
	        	if (tableCol == "extensionAttribute6") {
	        		retValue = "${boardListVO.extensionAttribute6}"; 
				} else if (tableCol == "extensionAttribute7") {
					retValue = "${boardListVO.extensionAttribute7}";
				} else if (tableCol == "extensionAttribute8") {
					retValue = "${boardListVO.extensionAttribute8}";
				} else if (tableCol == "extensionAttribute9") {
					retValue = "${boardListVO.extensionAttribute9}";
				} else if (tableCol == "extensionAttribute10") {
					retValue = "${boardListVO.extensionAttribute10}";
				}
	        	
	        	return retValue;
	        }
	    </script>
	    <c:if test="${!isCrossBrowser}">
	   		<script type="text/javascript" FOR="EzHTTPTrans" EVENT="AttachAddFile(filename)">
			    Append_AttachAdd(filename);
			</script>
	    </c:if>
	</head>
	<body class="popup" style="height: 97%;" ondragover="bodydragover(event)">
	    <table class="layout" style="width: 100%;">
	        <tr>
	            <td style="height: 20px">
	                <div id="menu">
	                    <ul>
	                    	<c:choose>
	                    		<c:when test="${mode == 'temp'}">
			                        <li><span onclick="SaveItem('save');"><spring:message code='ezBoard.t429' /></span></li>
	                    		</c:when>
	                    		<c:otherwise>
			                        <li><span onclick="SaveItem('${mode}');"><spring:message code='ezBoard.t429' /></span></li>
	                    		</c:otherwise>
	                    	</c:choose>
	                    	<c:if test="${boardInfo.guBun != '3'}">
		                        <li><span onclick="PreviewItem();"><spring:message code='ezBoard.t431' /></span></li>
	                    	</c:if>
	                    	<c:if test="${boardInfo.guBun != '2' && (mode != 'modify' && mode != 'reply')}">
		                        <li><span onclick="SaveItem('temp');"><spring:message code='ezBoard.t10034' /></span></li>
	                    	</c:if>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li><span onclick="window.close();"><spring:message code='ezBoard.t12' /></span></li>
	                    </ul>
	                </div>
	                <script type="text/javascript">
	                    selToggleList(document.getElementById("menu"), "ul", "li", "0");
	                    selToggleList(document.getElementById("close"), "ul", "li", "0");
	                </script>
	            </td>
	        </tr>
        	<c:choose>
        		<c:when test="${boardInfo.guBun != '3'}">
	        <tr style="height: 20px">
	            <td>
	                <div class="portlet_tabpart03">
	                    <div class="portlet_tabpart03_top" id="tab1">
	                        <p id="MailEnv_sub1"><span divname="MailEnv_div1" id="1tab1"><spring:message code='ezBoard.t273' /></span></p>
	                        <p id="MailEnv_sub3"><span divname="MailEnv_div3" id="1tab3"><spring:message code='ezBoard.t60' /></span></p>
	                    </div>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="height: 20px">
	                <table class="content" id="tab01">
	                    <tr>
	                        <th>
	                        	<c:choose>
	                        		<c:when test="${boardType != 'SELECT'}">
			                            <spring:message code='ezBoard.t111' />
	                        		</c:when>
	                        		<c:otherwise>
			                            <a class="imgbtn" onclick="NewItem_onclick()"><span><spring:message code='ezBoard.t171' /></span></a>
	                        		</c:otherwise>
	                        	</c:choose>
	                        </th>
	                        <td id="tdBoardName" style="width: 300px">
	                        	<c:choose>
	                        		<c:when test="${boardType != 'SELECT'}">
			                            <span id="BoardSpan">
			                                ${boardInfo.boardName} 
			                            </span>
	                        		</c:when>
	                        		<c:otherwise>
	                        			<c:choose>
	                        				<c:when test="${boardID == ''}">
					                            <span id="BoardSpan"><spring:message code='ezBoard.t57' /></span>
	                        				</c:when>
	                        				<c:otherwise>
					                            <span id="BoardSpan">${boardInfo.boardName}</span>
	                        				</c:otherwise>
	                        			</c:choose>
	                        		</c:otherwise>
	                        	</c:choose>
	                        </td>
	                        <th><spring:message code='ezBoard.t434' /></th>
	                        <c:choose>
	                        	<c:when test="${importance == '1'}">
			                        <td style="width: 300px"><span style="line-height: 20px; height: 20px; display: inline-block;">
			                            <input type="checkbox" id="chkEmergent" checked></span><span style="line-height: 21px; height: 12px; display: inline-block;"><spring:message code='ezBoard.t435' /></span>
	                        	</c:when>
	                        	<c:otherwise>
			                        <td style="width: 300px"><span style="line-height: 20px; height: 20px; display: inline-block;">
			                            <input type="checkbox" id="chkEmergent"></span><span style="line-height: 21px; height: 12px; display: inline-block;"><spring:message code='ezBoard.t435' /></span>
	                        	</c:otherwise>
	                        </c:choose>
	                            <!-- // 20090913 : 게시판 공지게시 기능 -->
	                            <c:choose>
	                            	<c:when test="${mode != 'reply'}">
	                            		<c:choose>
	                            			<c:when test="${boardInfo.guBun != '2' && (boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'true') && boardListVO.extensionAttribute2 == '1'}">
									              &nbsp;<span style="line-height: 20px; height: 20px; display: inline-block;"><input type="checkbox" id="noticePost" checked /></span><span style="line-height: 21px; height: 12px; display: inline-block;"><spring:message code='ezBoard.t483' /></span>
	                            			</c:when>
	                            			<c:when test="${boardInfo.guBun != '2' && (boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'true')}">
									              &nbsp;<span style="line-height: 20px; height: 20px; display: inline-block;"><input type="checkbox" id="noticePost" /></span><span style="line-height: 21px; height: 12px; display: inline-block;"><spring:message code='ezBoard.t483' /></span>
	                            			</c:when>
	                            			<c:otherwise>
									              &nbsp;<input type="checkbox" style="display: none" id="noticePost" />
	                            			</c:otherwise>
	                            		</c:choose>
	                            	</c:when>
	                            	<c:otherwise>
		                                &nbsp;<input type="checkbox" style="display: none" id="noticePost" />
	                            	</c:otherwise>
	                            </c:choose>
								<c:if test="${mode != 'new' && mode != 'boardContent' && mode != 'boardAttach' && mode != 'temp' && reservedItem == '' }">
						              &nbsp;<span style="line-height: 20px; height: 20px; display: inline-block;"><input type="checkbox" id="readCount" /></span><span style="line-height: 21px; height: 12px; display: inline-block;"><spring:message code='ezBoard.t00002' /></span>
								</c:if>	
		                        </td>
	                    </tr>
             <!-- 추가 항목이 있을 경우 -->
             			<c:forEach var="boardAttributeVO" items="${boardAttributeListVO}" step="1" varStatus="status">
             				<tr>
             					<c:choose>
             						<c:when test="${extenLang == 1}">
		             					<th>${boardAttributeVO.colName1}</th>
             						</c:when>
             						<c:otherwise>
             							<th>${boardAttributeVO.colName2}</th>
             						</c:otherwise>
             					</c:choose>
             					<c:choose>
             						<c:when test="${boardAttributeVO.colType == 'radio'}">
						                <td colspan="3">
						                	<c:forEach begin="0" end="${fn:length(fn:split(boardAttributeVO.value, '|')) - 1}" step="1" varStatus="status">
							                    <input type="radio" name="${boardAttributeVO.tableCol}" value="${fn:split(boardAttributeVO.value, '|')[status.index]}" />${fn:split(boardAttributeVO.value, '|')[status.index]}
						                	</c:forEach>
						                </td>
             						</c:when>
             						<c:when test="${boardAttributeVO.colType == 'text'}">
						                <td colspan="3">
						                    <input type="text" id='${boardAttributeVO.tableCol}' name='${boardAttributeVO.tableCol}'  style="width:43%"/>
						                </td>
             						</c:when>
             						<c:when test="${boardAttributeVO.colType == 'check'}">
						                <td colspan="3">
						                	<c:forEach begin="0" end="${fn:length(fn:split(boardAttributeVO.value, '|')) - 1}" step="1" varStatus="status">
							                    <input type="checkbox" name="${boardAttributeVO.tableCol}" value="${fn:split(boardAttributeVO.value, '|')[status.index]}" />${fn:split(boardAttributeVO.value, '|')[status.index]}
						                	</c:forEach>
						                </td>
             						</c:when>
             					</c:choose>
             				</tr>
             			</c:forEach>
	          <!-- 추가 항목이 있을 경우 끝--> 
	                    <tr>
	                        <th><spring:message code='ezBoard.t208' /></th>
	                        <td colspan="3">
	                            <input type="text" id="txtTitle" style="WIDTH: 98%; word-wrap: break-word; word-break: break-all;" value="" maxlength="100" onkeydown="Title_onkeyDown(event)"></td>
	                    </tr>
	                    <c:if test="${boardInfo.guBun == '2'}">
		                    <tr>
		                        <th><spring:message code='ezBoard.t438' /></th>
		                        <td colspan="3">
		                            <input type="password" id="txtPassWord" style="WIDTH: 150px" maxlength="15">&nbsp;&nbsp;(<spring:message code='ezBoard.t439' /></td>
		                    </tr>
	                    </c:if>
	                </table>
	                <table id="tab02" class="content" style="display: none;">
	                	<c:choose>
	                		<c:when test="${(mode== 'new' || reservedItem == 'true' || url != '') && boardInfo.guBun != '2'}">
			                    <tr id="tdReservationDate">
	                		</c:when>
	                		<c:otherwise>
			                    <tr id="tdReservationDate" style="DISPLAY: none">
	                		</c:otherwise>
	                	</c:choose>
	                        <th><spring:message code='ezBoard.t432' /></th>
	                        <td>
	                        	<c:choose>
	                        		<c:when test="${reservedItem == 'true'}">
			                            <span style="line-height: 20px; height: 20px; display: inline-block;">
			                                <input type="checkbox" id="chk_reservation" onclick="Reservation_onclick()" checked></span><span style="line-height: 21px; height: 12px; display: inline-block; margin-top: 3px;"><spring:message code='ezBoard.t276' /></span>
	                        		</c:when>
	                        		<c:otherwise>
			                            <span style="line-height: 20px; height: 20px; display: inline-block;">
			                                <input type="checkbox" id="chk_reservation" onclick="Reservation_onclick()"></span><span style="line-height: 21px; height: 12px; display: inline-block;"><spring:message code='ezBoard.t276' /></span>
	                        		</c:otherwise>
	                        	</c:choose>
	                            <span id="reservation_date"></span>
	                            <input type="text" id="Sdatepicker" style="width:80px;text-align:center"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" />
	
	                                   &nbsp;<a class="imgbtn"><span onclick="btn_PostDate_Clear()" popuplocation='topright'><spring:message code='ezBoard.t220' /></span></a></td>
	                    </tr>
	                    <tr id="tdEndDate">
	                        <th><spring:message code='ezBoard.t156' /></th>
	                        <td>
	                        	<c:choose>
	                        		<c:when test="${(mode != 'modify' && boardInfo.expireDays == '-1') || ((mode == 'modify' || mode == 'temp') && fn:substring(boardListVO.endDate, 0, 4) == '9999') || (url != '') }">
			                            <span id="Chkbox">
			                                <span style="line-height: 20px; height: 20px; display: inline-block;">
			                                    <input type="checkbox" id="ChkPermanence" name="ChkPermanence" onclick="return ChkPermanent()" checked></span><span style="line-height: 21px; height: 12px; display: inline-block; margin-top: 3px;"><spring:message code='ezBoard.t433' /></span>
			                            </span>
			                            <span id="Makedate">
			                                <input type="text" id="Sdatepicker2" style="width:80px;text-align:center">
			                            </span>
	                        		</c:when>
	                        		<c:otherwise>
			                            <span id="Chkbox" style="display: inline-block;">
			                                <span style="line-height: 20px; height: 20px; display: inline-block;">
			                                    <input type="checkbox" id="ChkPermanence" name="ChkPermanence" onclick="return ChkPermanent()"></span><span style="line-height: 21px; height: 12px; display: inline-block;"><spring:message code='ezBoard.t433' /></span>
			                            </span>
			                            <span id="Makedate">
			                                <input type="text" id="Sdatepicker2" style="width:80px;text-align:center">
			                            </span>
	                        		</c:otherwise>
	                        	</c:choose>
	                        </td>
	                    </tr>
	                    <c:if test="${boardInfo.guBun == '2'}">
		                    <tr>
		                        <th><spring:message code='ezBoard.t436' /></th>
		                        <td>
		                            <input type="text" id="txtNickName" style="WIDTH: 150px" maxlength="15" value="${boardListVO.writerName}">&nbsp;&nbsp;(<spring:message code='ezBoard.t437' /></td>
		                    </tr>
	                    </c:if>
	                    <tr>
	                        <th><spring:message code='ezBoard.t209' /></th>
	                        <td>
	                            <input type="text" id="txtAbstract" style="WIDTH: 95%; word-break: break-all" value="" maxlength="100"></td>
	                    </tr>
	                     
	                    <tr id="pUseBackGroundTR" style="display:none;" height="80px">
	                      <th><spring:message code='ezBoard.t5011' /></th>
	                      <td colspan="3" id="backgroundtd" style="padding-top:5px"></td>
	                    </tr>
	                    
	                </table>
	            </td>
	            </c:when>
	            <c:otherwise>
	            <td>
	                <table class="content">
	                    <tr>
	                        <th><spring:message code='ezBoard.t111' /></th>
	                        <td id="tdBoardName" style="width: 100%" colspan="2">${boardInfo.boardName}</td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezBoard.t208' /></th>
	                        <td style="vertical-align: middle" colspan="2">
	                            <input type="text" id="txtTitle" style="WIDTH: 95%; word-wrap: break-word; word-break: break-all;" value="" maxlength="100" onkeydown="Title_onkeyDown(event)"></td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezBoard.t459' /></th>
	                        <td class="pos1">
	                            <input type="text" id="txtPhotoFile" style="WIDTH: 100%" readonly="true"></td>
	                        <td class="pos2"><a class="imgbtn"><span id="btn_AttachAdd" onclick="return btn_PhotoAttachAdd_onclick()"><spring:message code='ezBoard.t440' /></span></a></td>
	                    </tr>
	                    <tr id="tdReservationDate" style="DISPLAY: none">
	                        <th><spring:message code='ezBoard.t432' /></th>
	                        <td style="width: 100%" colspan="2">
	                            <table style="width: 100%;" border="0">
	                                <tr>
	                                    <td>
	                                    	<c:choose>
	                                    		<c:when test="${reservedItem == 'true'}">
			                                        <span style="line-height: 20px; height: 20px; display: inline-block;">
			                                            <input type="checkbox" id="chk_reservation" onclick="Reservation_onclick()" checked></span><span style="line-height: 21px; height: 12px; display: inline-block; margin-top: 3px;"><spring:message code='ezBoard.t276' /></span>
	                                    		</c:when>
	                                    		<c:otherwise>
			                                        <span style="line-height: 20px; height: 20px; display: inline-block;">
			                                            <input type="checkbox" id="chk_reservation" onclick="Reservation_onclick()"></span><span style="line-height: 21px; height: 12px; display: inline-block; margin-top: 3px;"><spring:message code='ezBoard.t276' /></span>
	                                    		</c:otherwise>
	                                    	</c:choose>
	                                    </td>
	                                    <td id="reservation_date">
	                                        <input type="text" id="Sdatepicker" style="width:80px;text-align:center"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" />
	                                        &nbsp;<img src="/images/btn_date.gif" border="0" style="CURSOR: pointer; width: 75px; height: 20px; vertical-align: middle" onclick="btn_PostDate_Clear()" popuplocation='topright'>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                    <tr id="tdEndDate" style="DISPLAY: none">
	                        <th><spring:message code='ezBoard.t156' /></th>
	                        <td style="padding-top: 0; padding-bottom: 0px" colspan="2">
	                            <table border="0">
	                                <tr>
	                                	<c:choose>
	                                		<c:when test="${(mode != 'modify' && boardInfo.expireDays == '-1') || ((mode == 'modify' || mode == 'temp') && fn:substring(boardListVO.endDate, 0, 4) == '9999') || (url != '') }">
			                                    <td style="width: 90px; white-space: nowrap" id="Chkbox">
			                                        <input type="checkbox" id="ChkPermanence" name="ChkPermanence" onclick="return ChkPermanent()" checked><spring:message code='ezBoard.t433' /></td>
			                                    <td id="Makedate">
			                                        <input type="text" id="Sdatepicker2" style="width:80px;text-align:center">&nbsp;&nbsp;
			                                    </td>
	                                		</c:when>
	                                		<c:otherwise>
			                                    <td style="width: 90px; white-space: nowrap" id="Chkbox">
			                                        <input type="checkbox" id="ChkPermanence" name="ChkPermanence" onclick="return ChkPermanent()"><spring:message code='ezBoard.t433' /></td>
			                                    <td id="Makedate">
			                                        <input type="text" id="Sdatepicker2" style="width:80px;text-align:center">&nbsp;&nbsp; </td>
	                                		</c:otherwise>
	                                	</c:choose>
	                                    <td>&nbsp;</td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                    <tr style="display: none">
	                        <th><spring:message code='ezBoard.t434' /></th>
	                        <c:choose>
	                        	<c:when test="${importance == '1'}">
			                        <td style="vertical-align: middle" colspan="2">
			                            <input type="checkbox" id="chkEmergent" checked><spring:message code='ezBoard.t435' /></td>
	                        	</c:when>
	                        	<c:otherwise>
			                        <td style="vertical-align: middle" colspan="2">
			                            <input type="checkbox" id="chkEmergent"><spring:message code='ezBoard.t435' /></td>
	                        	</c:otherwise>
	                        </c:choose>
	                    </tr>
	                    <c:if test="${boardInfo.guBun == '2'}">
		                    <tr style="display: none">
		                        <th><spring:message code='ezBoard.t436' /></th>
		                        <td style="vertical-align: middle" colspan="2">
		                            <input type="text" id="txtNickName" style="WIDTH: 100px" maxlength="15" value="${boardListVO.writerName}">
		                            &nbsp;&nbsp;(<spring:message code='ezBoard.t437' /></td>
		                    </tr>
		                    <tr style="display: none">
		                        <th><spring:message code='ezBoard.t438' /></th>
		                        <td style="vertical-align: middle" colspan="2">
		                            <input type="password" id="txtPassWord" style="WIDTH: 100px" maxlength="15">
		                            &nbsp;&nbsp;(<spring:message code='ezBoard.t439' /></td>
		                    </tr>
	                    </c:if>
	                    <tr style="display: none">
	                        <th><spring:message code='ezBoard.t209' /></th>
	                        <td style="vertical-align: middle" colspan="2">
	                            <input type="text" id="txtAbstract" style="WIDTH: 95%; word-break: break-all" value="" maxlength="100"></td>
	                    </tr>
	                </table>
	            </td>
	            </c:otherwise>
        	</c:choose>
	        </tr>
	        <c:choose>
	        	<c:when test="${boardInfo.guBun != '3'}">
			        <tr>
			            <td style="vertical-align: top; height: 100%" class="pad2" id="EdtorSize">
			                <table style="width: 100%; height: 100%">
			                    <tr>
			                        <td style="vertical-align: top; height: 100%" >
		                                <iframe id="message" class="viewbox" name="message" src="/ezBoard/ckEditor.do" style="padding: 0px; width: 100%; overflow: auto;"></iframe>
			                        </td>
			                    </tr>
			                </table>
			            </td>
			        </tr>
	        	</c:when>
	        	<c:otherwise>
			        <tr>
			            <td style="vertical-align: top; height: 100%" id="EdtorSize">
			                <iframe id="message" class="viewbox" name="message" src="/ezBoard/ckEditor.do" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
			            </td>
			        </tr>
	        	</c:otherwise>
	        </c:choose>
	        <tr id="docTR" style="display: none">
	            <td>
	                <div id="docContentBorder" style="border: #B6B6B6 1px solid; BACKGROUND-COLOR: white; margin-top: 5px;">
	                    <iframe id="docContent" name="docContent" style="width: 100%; height: 100%;"></iframe>
	                </div>
	            </td>
	        </tr>
	    	<c:if test="${!isCrossBrowser}">
				<c:choose>
					<c:when test="${boardInfo.guBun != '3'}">
				      <tr>
				        <td height="20" valign="top" style="padding-top:10px">
				          <table class="file" style="height:100px">
				            <form name="multicheck">
				              <tr>
				                <th><spring:message code='ezBoard.t292' /></th>
				                <td class="pos1" style="height:100px">                
				                    <SCRIPT type="text/javascript">EzHTTPTrans_ActiveX2("EzHTTPTrans", "100%", "100%");</SCRIPT>
				                    <div id="lstAttachLink" style="display:none">&nbsp;</div>                
				                </td>
				                <td class="pos2"><a class="imgbtn"><span id="btn_AttachAdd" onClick="return btn_AttachAdd_onclick()"><spring:message code='ezBoard.t440' /></span></a><br><a class="imgbtn"><span id="btn_AttachDel" onClick="return btn_AttachDel_onclick()"><spring:message code='ezBoard.t441' /></span></a></td>
				              </tr>
				            </form>
				          </table>
				        </td>
				      </tr>
					</c:when>
					<c:otherwise>
						<SCRIPT type="text/javascript">EzHTTPTrans_ActiveX("EzHTTPTrans");</SCRIPT>
					</c:otherwise>
				</c:choose>
	    	</c:if>
	    	<c:if test="${isCrossBrowser}">
				<c:choose>
					<c:when test="${boardInfo.guBun != '3'}">
				        <tr>
				            <td style="height: 146px">
				                <br />
				                <iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px" src="/ezBoard/dragAndDrop.do"></iframe>
				                <input type="hidden" name="mode" id="mode" />
				            </td>
				        </tr>
					</c:when>
				</c:choose>
	    	</c:if>
	    </table>
	    <input id="publicModulus" value="${publicModulus}" type="hidden"/>
	    <input id="publicExponent" value="${publicExponent}" type="hidden"/>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
	<script type="text/javascript">
	//사용안되는듯 2017-01-11 파악
// 	    function SelectBoard2() {
// 	        var url = "BoardSelect2.aspx";
// 	        var feature = "status:no;dialogWidth:352px;dialogHeight:700px;help:no;scroll:no;edge:sunken";
// 	        feature = feature + GetShowModalPosition(352, 700);
// 	        var ret = window.showModalDialog(url, "", feature);
	
// 	        if (typeof (ret) == "undefined") return "";
// 	        return ret;
// 	    }
	</script>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
	<script type="text/javascript">
	    if ("${boardInfo.guBun}" == "2") {
	        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 350 + "PX";
	    } else if("${docID}" != "") {
	        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 500 + "PX";
	    } else {
	        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 320 + "PX";
	    }
	</script>
</html>