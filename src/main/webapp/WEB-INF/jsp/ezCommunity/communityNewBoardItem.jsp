<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html ondragover="bodydragover(event)">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
			#lstAttachLink {
				height: 115px;
				border: 1px solid #d2d2d2;
			}

			.attachInnerNotice_p_on {
				text-align: center;
				margin: 10px 0 0 0;
			}

			.attachInnerNotice_p_off {
				display: none;
			}

			.attachInnerNotice_span {
				line-height: 55px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/ConvertSaveImage.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<c:if test="${isCrossBrowser == true}">
			<script type="text/javascript" src="${util.addVer('/js/ezCommunity/AttachMain_CK.js')}"></script>
			<script type="text/javascript" src="${util.addVer('/js/ezCommunity/AttachItem_CK.js')}"></script>
		</c:if>
		
		<c:if test="${isCrossBrowser != true}">
			<script type="text/javascript" src="${util.addVer('/js/ezCommunity/AttachMain.js')}"></script>
			<script type="text/javascript" src="${util.addVer('/js/ezCommunity/AttachItem.js')}"></script>
			<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
		</c:if>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/asn1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		
		<!-- data picker -->
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" />
		<!-- time picker -->
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery.multipleSortable.js')}"></script>
		
		<c:choose>
			<c:when test="${pMode == 'new' || pUrl != ''}">
				<title><spring:message code='ezCommunity.t1128' /></title>
			</c:when>
			<c:when test="${pMode == 'reply' }">
				<title><spring:message code='ezCommunity.t1129' /></title>
			</c:when>
			<c:otherwise>
				<title><spring:message code='ezCommunity.t1130' /></title>
			</c:otherwise>
		</c:choose>

		<script type="text/javascript">
			var userInfo = "<c:out value = '${userInfo}' />";
			var item = "<c:out value = '${item}' />";
			var pUploadFilePath = "<c:out value = '${pUploadFilePath}' />";
			var pBoardID = "<c:out value = '${boardInfo.boardID}' />";
			var pBoardName = "<c:out value = '${boardInfo.boardName}' />";
			var pMode = "<c:out value = '${pMode}' />";
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
		    var strStartDate = "<c:out value = '${startDateTime}' />";
		    var strEndDate = "<c:out value = '${endDate}' />";
		    var strAttachments = "<c:out value = '${item.attachments}' />";
		    var strContentLocation = "<c:out value = '${item.contentLocation}' />";
		    var strUpperItemIDTree = "<c:out value = '${item.upperItemIDTree}' />";
		    var strItemLevel = "<c:out value = '${item.itemLevel}' />";
		    var strWriterTitle = "<c:out value = '${item.extensionAttribute3}' />";
		    var strWriterFakeName = "<c:out value = '${strWriterFakeName}' />";
		    var pAttachListXml = "";
		    var AttachLimit = "<c:out value = '${boardInfo.attachSizeLimit}' />";
		    var pReservedItem = "<c:out value = '${pReservedItem}' />";
		    var strUserRank = "<c:out value = '${userInfo.title1}' />";
		    var strUserRank2 = "<c:out value = '${userInfo.title2}' />";
		    var strUserPhone = "<c:out value = '${userInfo.phone}' />";
		    var strNow = "<c:out value = '${strNow}' />";		
		    var ExpireDays = "<c:out value = '${boardInfo.expireDays}' />";		
		    var gubun = "<c:out value = '${boardInfo.gubun}' />";		
		    var pUrl = "<c:out value = '${pUrl}' />";
		    var pDocID = "<c:out value = '${pDocID}' />";
		    var PhotoBoard = "N";
		    var _hasattach = "<c:out value = '${hasAttach}' />";
		    var rsa = new RSAKey();
			var flag = false;
			var saveFlag = false;
			var clickFlag = false;
			var attachFileNameMaxLength = Number("${attachFileNameMaxLength}");
			var defaultFontAndSize  = "${defaultFontAndSize}";
			var mailShareId = "<c:out value = '${mailShareId}'/>";
			var mailFG_Post = "<c:out value = '${boardInfo.mailFG_Post}'/>"; // 게시알림
			var mailFG_Mod = "<c:out value = '${boardInfo.mailFG_Mod}'/>"; // 수정알림
			var editor = "<c:out value = '${editor}'/>";
			var isfileup = false;
			var xhr = new XMLHttpRequest();
			
			<c:if test="${isCrossBrowser != true}">
			    var objMHT = new ActiveXObject("MhtFormat.Convert");
			    var objMHTRead = new ActiveXObject("MhtFormat.Convert");
		    </c:if>
			
			window.onload = function () {
				<c:if test="${isCrossBrowser != true}">
			        document.all.EzHTTPTrans.SetBigLang = "${userInfo.lang}" == "1" ? 1 : 0;
			        document.all.EzHTTPTrans.UseDbCl = true;
				</c:if>
				
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
					
		        if(pMode == "new" || pMode == "new1") {
		            btn_PostDate_Clear();
		        } else {
		            if (pReservedItem != "true") {
		            	$("#Sdatepicker").datepicker('setDate', "");
		            }
		        }
		        
		        if (ExpireDays == "-1") {
		        	document.getElementById('Makedate').style.display = "none";
		        }
							
		        if( pMode == "modify") {
		            document.getElementById("txtTitle").value  = ConvMakeXMLString("<c:out value = '${item.title}' />");
		            document.getElementById("txtAbstract").value = ConvMakeXMLString("<c:out value = '${item.absTract}' />");
		            
		            if (strEndDate.substring(0,4) != "9999") {		
		            	document.getElementById("Edatepicker").value = ConvMakeXMLString("<c:out value = '${item.endDate}' />").substring(0,10);   	
		            }
		            
					if(pReservedItem == "true") {
						document.getElementById("Sdatepicker").value = ConvMakeXMLString("<c:out value = '${item.startDate}' />").substring(0,10);
						document.getElementById("Stimepicker").value = ConvMakeXMLString("<c:out value = '${item.startDate}' />").substring(11,16);
					}
		        }
							
		        if (pMode == "reply") {
		            document.getElementById("txtTitle").value = ConvMakeXMLString("<c:out value = '${item.title}' />");
		        }

		        InitializeSettings();
		        ChkPermanent();
		        rsa.setPublic(document.getElementById('publicModulus').value, document.getElementById('publicExponent').value);
				setAttachSortable();
		    }
			
			$(function(){
				$("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
				
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        	
		        var settime;
		        var NowDate;

	            settime = strStartDate;

		        NowDate = new Date(settime.substring(0, 4), settime.substring(5, 7), settime.substring(8, 10), settime.substring(11, 13), settime.substring(14, 16));
		        NowDate.setMonth(NowDate.getMonth() - 1);

		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', NowDate);
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });

		        var NowDate2 = new Date();
		        
		        if (ExpireDays != -1) { //영구만료가 아닌 경우에는 지정된 만료일을 더한 날짜가 기본으로 새로 게시될때 만료일이 나와야함
		        	NowDate2.setDate(NowDate2.getDate() + parseInt(ExpireDays));
		        } else {
		        	NowDate2.setMonth(NowDate2.getMonth() + 1);
		        }
		        
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', NowDate2);
		        
				$.datepicker.regional["<spring:message code='main.t0619' />"] = {
					closeText: "<spring:message code='main.t3' />",
					prevText: "<spring:message code='main.t0604' />",
					nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
					monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					             "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					             "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					             "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					                  "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					                  "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					                  "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					           "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
					           "<spring:message code='main.t0627' />"],
					dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					                "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					                "<spring:message code='main.t0627' />"],
					dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					              "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					              "<spring:message code='main.t0627' />"],
					weekHeader: "Wk",
					dateFormat: "yy-mm-dd",
					firstDay: 0,
					isRTL: false,
					duration: 200,
					showAnim: "show",
					showMonthAfterYear: true
				};
				
				$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
			});
			
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

	            xmlhttp.open("GET", "/ezCommunity/getItemAttachments.do?itemID=" + encodeURIComponent(strItemID), false);
	            xmlhttp.send();

	            xmldom.async = false;
	            xmldom.preserveWhiteSpace = true;
	            xmldom = loadXMLString(xmlhttp.responseText);
	            xmlhttp = null;
				
	            var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");

	            str += "<LISTVIEWDATA><HEADERS><HEADER><NAME><spring:message code='ezCommunity.t1135' /></NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME><spring:message code='ezCommunity.t1136'/></NAME><WIDTH>50</WIDTH></HEADER></HEADERS><ROWS>";
			
	            for(i=0;i<xmldomNodes.length;i++) {
		            filepath = SelectSingleNodeValue(xmldomNodes[i], "FilePath");
		            filename = MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "FileName"));
		            
	                str += "<ROW><CELL>";	
	                /* 2018-04-30 홍승비 - 커뮤니티 게시판 첨부파일명 특문처리 수정 */
	                str += "<VALUE><![CDATA[" + filename + "]]></VALUE>";
	                str += "<DATA1><![CDATA[" + filename + "]]></DATA1>";
	                str += "<DATA2>" + MakeXMLString(filepath) + "</DATA2>";
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
		            pEndDateTime = "9999-12-30 23:59:59";
		        } else {
		            if ((pMode == "modify" || pMode == "temp") && $('#Edatepicker').val().substring(0, 4) != "9999") {
		                pEndDateTime = $('#Edatepicker').val() + " 23:59:59";
		            } else {
		                pEndDateTime = $('#Edatepicker').val() + " 23:59:59";
		            }
		        }
		        
		        return pEndDateTime;
		    }
		    
		    function checkSaveItem() {
		    	if (saveFlag == true) {
		    		return ;
		    	}
		    }
	    
		    // 2018-02-13 천성준
		    function checkDoubleClick() {
		    	if (clickFlag) {
		    		return true;
		    	} else {
		    		return false;
		    	}
		    }	

		    function SaveItem() {
		    	checkSaveItem();
		    	
		    	if(checkDoubleClick()){
		    		return;
		    	}
		    	
		    	saveFlag == true;
		    	
		    	if (editor != "HWP") {
		    		if(MHTLoadComplete != "true") {
			            alert("<spring:message code='ezCommunity.t1138'/>");		
			            return;
			        }	
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
							
		        if (pStartDate == "" && pReservedItem == "true") {
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
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME", SSDeptName);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME2", SSDeptName2);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYID", SSCompanyID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME", SSCompanyName);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME2", SSCompanyName2);
		        } else {
		            var nickname = txtNickName.value;
		            
		            if (nickname == "") {
		            	nickname = "<spring:message code='ezCommunity.t929'/>";
		            }
		            
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERID", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME", encodeURIComponent(nickname));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME2", encodeURIComponent(nickname));
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTID", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME2", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYID", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME2", "");
		        }
	
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "IMPORTANCE", importance);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TITLE", encodeURIComponent(document.getElementById("txtTitle").value));
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "STARTDATE", pStartDate);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ENDDATE", pEndDate);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ABSTRACT",  encodeURIComponent(document.getElementById("txtAbstract").value));
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ATTACHMENTS", encodeURIComponent(AttachFileList()));
	
		        if(pMode == "new" || pMode == "new1" || pUrl != "") {
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
		        var obj = GetBODY(document.getElementById('docContent')).getElementsByTagName("TD");
		        
		        for (i = 0; i < obj.length; i++) {
		            if (obj[i].free == "") {
		            	obj[i].removeAttribute('free');
		            }
		            
		            if (obj[i].className == "FIELD") {
		            	obj[i].removeAttribute('className');
		            }
		        }
		        
		        if (editor != "HWP") {
		        	if (pDocID != "") {
			        	message.SetEditorContent(message.GetEditorContent() + "<hr><br/><div contenteditable='false' >" + GetBODY(document.getElementById('docContent')).innerHTML) + "</div>";
			        }

			        var strBody = message.GetEditorContent();
			        
			        /* 2019-04-02 홍승비 - MHT파일 변환 및 저장 시 예외처리 추가 */
			        try {
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
			        } catch (e) {
			        	alert("<spring:message code='ezCommunity.lhj04'/>");
	      				return;
			        }
			        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "CONTENT", strBody);
		        } else {
		        	hwpHtml = hwpHtml.replace(/&quot;/gi, "\'");
		        	if (hwpHtml.indexOf("url(\'/") > -1) {
		        		hwpHtml = hwpHtml.replace("url(\'/", "url(\'");
	      			}
		        	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "CONTENT", hwpHtml.replace(/\r\n/g, "@r!n@"));
		        }
		        
		        if (gubun == "2") {
		        	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DOCPASSWORD", rsa.encrypt(document.getElementById('txtPassWord').value));
		        } else {
		        	createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DOCPASSWORD","");
		        }
		        
		        xmlhttp.open("POST", "/ezCommunity/saveItem.do?mode="+ pMode , false);
		        xmlhttp.send(xmlDom);
		        
		        if (xmlhttp.responseText == "OK") {
		            xmlhttp = null;
		            xmlDom = null;
		            if (document.getElementById("chk_reservation").checked == false) {
		            	/* 2016-05-16 이효진 메일 알림기능
		                if (strItemID == "") {
		                    xmlhttp = createXMLHttpRequest();
		                    xmlhttp.open("POST", "/ezCommunity/sendPostNoticeMail.do?boardID=" + pBoardID + "&itemID=" + newID, false);
		                    xmlhttp.send();
		                    xmlhttp = null;
		                } */
		                
		                // 답변알림메일 발송 뒤 연결되는 동작이 없으므로 비동기(async : true) 처리
		                if (pMode == "reply") {
		                	$.ajax({
						    	type : "POST",
						    	url : "/ezCommunity/sendReplyNoticeMail.do",
						    	async : true,
						    	data : {boardID : pBoardID,
					    				itemID : newID,
					    				itemTreeID : strUpperItemIDTree},
						    	dataType : 'json',
						    	success : function (result) {
						    	}
						    });
		                }
		                
		                /* 2021-11-15 홍승비 - 게시판의 옵션에 따라 게시/수정 알림메일 발송 (비동기식, 백그라운드 동작) */
		                if (pMode == "new" && mailFG_Post == "Y") {
		                	sendCommBoardAlertMail(pMode, pBoardID, newID);
		                } else if (pMode == "modify" && mailFG_Mod == "Y") {
		                	sendCommBoardAlertMail(pMode, pBoardID, strItemID);
		                }
		                
		                alert("<spring:message code='ezCommunity.t282'/>");
					} else {
		                alert("<spring:message code='ezCommunity.t1150'/>" + pStartDate.substr(0, 16) + "<spring:message code='ezCommunity.t1151'/>");
		            }
		            
		            /* 2020-09-08 홍승비 - 메일 읽기 창에서 커뮤니티에 게시하는 경우, 새로고침 하지 않도록 수정 */
					if (window.opener.location.href.indexOf("ezEmail") == -1) {
						// 게시물 작성창을 게시물 리스트에서 호출한 경우, 부모창의 카운트 새로고침 추가
						if (window.opener.location.href.indexOf("ezCommunity/boardItemList.do") > -1 || window.opener.location.href.indexOf("ezCommunity/searchBoardItem.do") > -1) {
							try {
								var cntDom = window.opener.parent.document.getElementById("itemcnt");
								var code = window.opener.parent.code;
								if (typeof(cntDom) != "undefined" && cntDom != null && typeof(code) != "undefined" && code != null) {
									reloadLeftCount(code, cntDom);
								}
							} catch(e) {}
						}
						window.opener.location.reload(true);
						
						/* 2021-11-09 홍승비 - 커뮤니티 팝업홈의 좌측 게시판 신규 게시물 아이콘 갱신 */
						if (window.opener.parent.location.href.indexOf("ezCommunity/commHome/popupCommHome.do") > -1 && typeof(window.opener.parent.applyIsNewIconAll) == "function") {
							window.opener.parent.applyIsNewIconAll();
						}
					}
					saveFlag = false;
					
		            window.close();
				} else {
		            saveFlag = false;
		            alert("<spring:message code='ezCommunity.t283'/> " + xmlhttp.responseText);
		        }
		        
		        xmlhttp = null;
		        xmlDom = null;
		        clickFlag = true;
		    }
	
			 /* 2018-05-10 홍승비 - 게시물 저장 시 JSleep 함수 미사용 */
		  	/* function JSleep(sTime) {
		        var start = new Date().getTime();
		        
		        while (new Date().getTime() < start + sTime) {
		        };
		    } */

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
		    
		    /* 2018-04-30 홍승비 - 커뮤니티 게시물 수정, 답변 시 특수문자 처리 */
		    function ConvMakeXMLString(str) {
		        str = ReplaceText(str, "&lt;", "<");
		        str = ReplaceText(str, "&gt;", ">");
		        str = ReplaceText(str, "&#039;", "'");
		        str = ReplaceText(str, "&#034;", "\"");
		  	    str = ReplaceText(str, "&amp;", "&");	    
		  		str = ReplaceText(str, "&#92;", "\\");
		        return str;
		    }
	
		    function btn_PostDate_Clear() {
	        	settime = strStartDate;
		        
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
							
		        window.open("/ezCommunity/boardItemPreview.do?gubun=" + gubun, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=744,top=" + pTop + ",left=" + pLeft, "");	
		    }
					
		    function AddDate(pDate,  pDays) {
		        var dt = new Date(pDate);
		        dt.setDate(dt.getDate() + pDays);
		        return dt;
		    }
						
		    function AutoAddtoExpireDate() {
		        var temp = ExpireDays;
		        if (temp == "-1") temp = "30";
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
		        var url	= "/ezCommunity/boardSelect.do";
		        var feature = "status:no;dialogWidth:355px;dialogHeight:600px;help:no;scroll:no;edge:sunken";
		        feature = feature + GetShowModalPosition(355, 600);
		        var ret = window.showModalDialog(url, "", feature);	
							
		        if (typeof(ret) == "undefined") {
		        	return "";
		        }
		        
		        return ret;			
		    }
		    
		    /* 2020-09-08 홍승비 - 커뮤니티 게시판에 메일 게시 기능 활성화 */
			var MailxmlHTTP = createXMLHttpRequest();
		    function InsertMailInfo() {
		        var _newGuid = "{" + GetGUID().toUpperCase() + "}";
		        var strQuery = "<DATA><URL>" + pUrl + "</URL><NEWGUID>" + _newGuid + "</NEWGUID><ATTACHLIMIT>" + AttachLimit + "</ATTACHLIMIT></DATA>";
		        var FileName = "";
		        var FileURL = "";
		        var ItemID = "";
		        var requestUrl = "/ezEmail/mailReadBoard.do?itemType=community";
		        
		        if (typeof(mailShareId) != "undefined" && mailShareId != "") {
            		requestUrl += "&shareId=" + encodeURIComponent(mailShareId);
				}
		        
		        MailxmlHTTP.open("POST", requestUrl, false);
		        MailxmlHTTP.send(strQuery);
		        
		        if (MailxmlHTTP.status == 200) {
		            var mailXml = loadXMLString(MailxmlHTTP.responseText);
		            document.getElementById('txtTitle').value = "<spring:message code='ezBoard.t409' />" + getNodeText(mailXml.getElementsByTagName("SUBJECT").item(0));
		            var Content = "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
		            Content += "<p " + defaultFontAndSize + ">-----<B>[&nbsp;<spring:message code='ezBoard.t410' /></B>-----</p>";
		            Content += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t411' /></B>" + getNodeText(mailXml.getElementsByTagName("DATE").item(0)) + "</p>";
		            
		            if (getNodeText(mailXml.getElementsByTagName("COMMENT").item(0)) != "") {
		                Content += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t412' /></B>" + ReplaceText(getNodeText(mailXml.getElementsByTagName("FROMNAME").item(0)), "\\\"", "");
		                Content += "  (" + getNodeText(mailXml.getElementsByTagName("COMMENT").item(0)) + ") </p>";
		            } else {
		                Content += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t412' /></B>" + ReplaceText(ReplaceText(getNodeText(mailXml.getElementsByTagName("FROMNAME").item(0)), "<", "&lt"), ">", "&gt;") + "</p>";
		            }
		
		            Content += "<p " + defaultFontAndSize + "><B><spring:message code='ezBoard.t413' /></B>" + getNodeText(mailXml.getElementsByTagName("SUBJECT").item(0)) + "</p>";
		            Content += "<p " + defaultFontAndSize + "></p><p " + defaultFontAndSize + "></p>";
		            Content += "<p " + defaultFontAndSize + ">" + getNodeText(mailXml.getElementsByTagName("HTMLDESCRIPTION").item(0)) + "</p>";
		            Content = ReplaceText(Content, "id=doctitle", "");
		            Content = ReplaceText(Content, "id=\"doctitle\"", "");
		            Content = ReplaceText(Content, "id=\'doctitle\'", "");
			            
		            if (Content.indexOf("id=\"_BigAttachListHtml\"") != -1) {
		            	Content = ReplaceText(Content, "<td width=\"75%\"", "<td width=\"65%\"");
		            	Content = ReplaceText(Content, "<td width=\"30%\"", "<td width=\"35%\"");
		            }
		            
		            Content = '<div '+defaultFontAndSize+'>' + Content + '</div>';
			
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
            	
                document.getElementById('tdBoardName').innerHTML = "<c:out value='${multiBoardName}'/>";
                
                if (ExpireDays == "-1" && strEndDate.substring(0,4) == "9999" || ExpireDays == "-1" && (pMode == "new" || pMode == "new1")) {
                    document.getElementById('ChkPermanence').checked = true;
                    document.getElementById('Makedate').style.display = "none";
                } else {
                    document.getElementById('ChkPermanence').checked = false;
                    document.getElementById('Makedate').style.display = "";
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
						
            function Editor_Complete() {
            	if (editor != "HWP") {
            		if (flag == false) {
    	                flag = true;
    	                
    	                if (pMode == "new" || pModeOld == "loadpc") {
    	                    document.getElementById("txtTitle").focus();
    	                    message.SetEditorContent("");
    	                } else {
    						if (pUrl == "") {
    	                        var fullPath = strContentLocation;
    	                        
    	                        if (pMode == "reply") {
    	                            var htmlData = message.GetEditorContentURL(fullPath);
    	                            htmlData = ReplaceText(htmlData, "class=&quot;FIELD&quot;", "");
    	                            htmlData = ReplaceText(htmlData, "class=FIELD", "");
    	        		            
    	                            htmlData = "<body free>" + htmlData + "</body>";
    	                            
    	                            if (gubun != "2") {
    	                            	var tempWriteDate = strWriteDate;
    	                            	
    	                            	if(strParentWriteDate > strWriteDate) {
    	                            		tempWriteDate = strParentWriteDate;
    	                            	}
    	                            	
    	                            	var replyHeader = "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
    		                        	replyHeader += "<p " + defaultFontAndSize + ">-----<B>[&nbsp;<spring:message code='ezCommunity.t1161' /></B>-----</p>";
    		                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezCommunity.t1162' /></B>" + tempWriteDate + "</p>";
    		                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezCommunity.t1163' /></B>" + strWriterName + "(" + strWriterTitle + "," + strWriterDeptName + "," + strWriterCompanyName + ")</p>";
    		                        	// 2021-06-22 김은실 - htmlData 이후 => 에디터에 옮겨지면서, 특수문자<>와 영문 혼용 시 태그로 인식함. 특수코드로(&lt; 등) 보내면 -> 에디터에서 알아서 변경하기 때문에, 특수코드로 보내는 것이 나음. 
    		                        	//					에디터에 따라 다를 경우, 경우를 나눠 추가작업을 요망.
    		                        	// replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezCommunity.t885' /></B>" + ConvMakeXMLString("<c:out value = '${item.title}' />") + "</p>";
    		                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezCommunity.t885' /></B><c:out value = '${item.title}' /></p>";
    		                        	replyHeader += "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
    		                        	htmlData = replyHeader + htmlData;
    	                            
    	                            } else {
    	                            	var replyHeader = "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
    		                        	replyHeader += "<p " + defaultFontAndSize + ">-----<B>[&nbsp;<spring:message code='ezCommunity.t1161' /></B>-----</p>";
    		                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezCommunity.t1162' /></B>" + strWriteDate + "</p>";
    		                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezCommunity.t1163' /></B>" + strWriterName + "</p>";
    		                        	replyHeader += "<p " + defaultFontAndSize + "><B><spring:message code='ezCommunity.t885' /></B><c:out value = '${item.title}' /></p>";
    		                        	replyHeader += "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
    		                        	htmlData = replyHeader + htmlData;
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
    	                        }
    	                    }
    	                }
    	                MHTLoadComplete = "true";
                    }
            	} else {
            		var URL;
                    URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=";
                    message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
            	}
			}

            function btn_AttachSelect_onclick() {
                document.getElementById('mode').value = "ATT";
                document.form.file1.click();
            }
            
            function returnvalue(strXML) {
                var xml = loadXMLString(strXML);
                var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
                var extFlag = false;
                
                for (var i = 0; i < nodes.length; i++) {
                    if (SelectSingleNodeValue(nodes[i], "RESULTUPLOADA") == "true") {
                        if (SelectSingleNodeValue(nodes[i], "FILESIZE") == 0) {
                            alert(strLang1);
                            return;
                        }
                    } else if (SelectSingleNodeValue(nodes[i], "RESULTUPLOADA") == "overflow") {
                        alert(strLang27 + AttachLimit + strLang28);
                        return;
                    } else if(SelectSingleNodeValue(nodes[i], "RESULTUPLOADA") == "denied") {
                        extFlag = true;                            
                    } else {
//                         alert(getNodeText(GetChildNodes(nodes[i])[2]) + strLang6 + "\n\n" + result);
                        alert(SelectSingleNodeValue(nodes[i], "PFILENAME") + strLang6 + "\n\n");
                        return;
                    }
                }
                
                if(extFlag) {
                	alert(strLang75);
                }
                
                AttachFileInfo(strXML);
            }

	        function bodydragover(evt) {
		        evt.dataTransfer.dropEffect = "none";
		        evt.stopPropagation();
		        evt.preventDefault();
		    }
	        
	        /* 2021-05-03 홍승비 - 게시물 리스트에서 게시물을 등록한 경우, 커뮤니티 팝업홈 좌측 전체 게시물 개수 갱신 */
	        function reloadLeftCount(pCode, pCntDom) {
            	$.ajax({
			    	type : "GET",
			    	url : "/ezCommunity/getCommunityBoardItemCnt.do",
			    	async : false,
			    	data : {
			    		code : pCode
			    	},
			    	success : function (result) {
			    		pCntDom.innerText = result;
			    	}
			    });
	        }
	        
	        /* 2021-11-15 홍승비 - 게시판 메일알림 함수 추가, 비동기로 백그라운드 동작 */
	        function sendCommBoardAlertMail(pMode, pBoardID, pItemID) {
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezCommunity/sendCommBoardAlertMail.do",
					data : {
						mode : pMode,
						boardID : pBoardID,
						itemID : pItemID
					}
				});
	        }
	        
	        /* 2023-08-16 홍승비 - 현재 게시물의 첨부파일 사이즈 총합을 계산하여 uploadedFileSize 변수에 설정하는 함수 */
		    function initAttachFileSize() {
		    	uploadedFileSize = 0; // 첨부파일 사이즈 전역변수 초기화
		    	var attachListInput = $("#lstAttachLink input");
		    	
		    	$.each(attachListInput, function(index, item) {
		    		var pRealFileSize = item.getAttribute("realfilesize");
		    		
		    		if (typeof(pRealFileSize) != "undefined" && pRealFileSize != null) {
		    			uploadedFileSize += parseInt(item.getAttribute("realfilesize"));
		    		}
		    	});
		    }
	        
	        function FieldsAvailable(isTrue) {
	        	if (isTrue) {
	        		if (pMode == "new") {
            			message.SetMargin(3000);
            		}
	        		message.EditMode(1);
            		message.SetViewProperties(2, 100);
		            message.ScrollPosInfo(0, 0);
		            message.ShowToolBar(true);
		            message.ShowRibbon(true);
		            message.FoldRibbon(true);
		            window.onresize();
	        	}
	        }
	        
	        window.onresize = function () {
				var mHeight = document.getElementById("EdtorSize").clientHeight - 5 + "px";
								
				if (gubun != "2") {
					document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 335 + "PX";
					document.getElementById("message").style.height = document.documentElement.clientHeight - 335 + "PX";
				} else {
					document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 365 + "PX";
					document.getElementById("message").style.height = document.documentElement.clientHeight - 365 + "PX";
				}

				if (editor == "HWP") {
					message.Resize(mHeight);
				}

				mobileDistinction();
			};
		    
		    function SaveItemHWP() {
		    	GetHTML(before_saveItem);
		    }
		    
		    function GetHTML(callback) {
                ingFlag = true;
			    message.GetTextFile("HWP", "", function (data) { ingFlag = false; callback(data); });
			}
		    
		    var hwpHtml = "";
            function before_saveItem(html, pMode) {
            	hwpHtml = html;
            	SaveItem();
            }
            
            function Editor_Modify_Complete() {
		    	var URL;
                URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(strContentLocation);
                message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
		    }
	        
		</script>

		<script type="text/javascript" FOR="EzHTTPTrans" EVENT="AttachAddFile(filename)">
			Append_AttachAdd(filename);
		</script>
	</head>
	<body class="popup" style="height: 100%">
		<table class="layout">
			<tr>
				<td style="height: 20px">
					<div id="menu">
						<ul>
							<!-- 2018-05-30 구해안 그룹웨어 모듈 '등록','저장후닫기' => '저장'으로 통일  ezCommunity.t155 => t20 -->
							<c:if test="${editor ne 'HWP'}">
								<li><span onclick="SaveItem();"><spring:message	code='ezCommunity.t20' /></span></li>
							</c:if>
							<c:if test="${editor eq 'HWP'}">
								<li><span onclick="SaveItemHWP();"><spring:message	code='ezCommunity.t20' /></span></li>
							</c:if>
							<!-- 2017-12-27 장진혁 - 미리보기가 필요하지 않아 보임 주석처리함 -->
							<%-- <li><span onclick="PreviewItem();"><spring:message code='ezCommunity.t1167' /></span></li> --%>
						</ul>
					</div>
					<div id="close">
						<ul>
							<li><span onclick="window.close();"></span></li>
						</ul>
					</div> 
					<script type="text/javascript">
						selToggleList(document.getElementById("menu"), "ul", "li", "0");
					</script>
				</td>
			</tr>
			<tr>
				<td style="height: 20px;">
					<table class="content" style="width:100%">
						<tr>
							<th style="width:15%"><spring:message code='ezCommunity.t1168' /></th>
							<td style="width:85%" id="tdBoardName"><c:out value = "${multiBoardName}"/></td>
						</tr>
	
						<c:choose>
							<c:when
								test="${(pMode == 'new' || pReservedItem == 'true' || pUrl != '') && boardInfo.gubun != '2' }">
								<tr id="tdReservationDate">
							</c:when>
							<c:otherwise>
								<tr id="tdReservationDate" style="DISPLAY: none">
							</c:otherwise>
						</c:choose>
	
							<th><spring:message code='ezCommunity.t1169' /></th>
							<td>
								<!-- 2018-07-16 김보미 - 가운데 정렬을 위한 div -->
								<div style="height: 24px;vertical-align: middle;display: inline-block;">
									<div class="custom_checkbox">
										<c:choose>
											<c:when test="${pReservedItem == 'true' }">
												<input type="checkbox" id="chk_reservation" onclick="Reservation_onclick()" checked>
												<label for="chk_reservation"><spring:message code='ezCommunity.t913' /></label>
											</c:when>
											<c:otherwise>
												<input type="checkbox" id="chk_reservation" onclick="Reservation_onclick()">
												<label for="chk_reservation"><spring:message code='ezCommunity.t913' /></label>
											</c:otherwise>
										</c:choose> 
									</div>
									<span id="reservation_date">
										<input type="text" id="Sdatepicker" oninput="this.value=this.value.replace(/[^0-9.\-]/g, '').replace(/(\..*)\./g, '$1');" style="width: 80px; text-align: center" />
										<input id="Stimepicker" type="text" class="time" oninput="this.value=this.value.replace(/[^0-9.\:]/g, '').replace(/(\..*)\./g, '$1');" style="width: 43px; margin-left: 10px; text-align: center;" /> 
										<a class="imgbtn imgbck" style="margin-top: 2px;">
											<span onclick="btn_PostDate_Clear()" popuplocation='topright'><spring:message code='ezCommunity.t444' /></span>
										</a>
									</span>
								</div>
							</td>
						</tr>
						<tr id="tdEndDate">
							<th><spring:message code='ezCommunity.t384' /></th>
							<td>
								<div class="custom_checkbox">
									<c:choose>
										<c:when test="${(pMode != 'modify' && boardInfo.expireDays =='-1') || (pMode == 'modify' && fn:substring(item.endDate, 0, 4) == '9999') || pUrl != '' }">
											<span id="Chkbox">
												<input type="checkbox" id="ChkPermanence" name="ChkPermanence" onclick="return ChkPermanent()" checked>
												<label for="ChkPermanence" style="display: inline-block; padding-bottom: 3px;"><spring:message code='ezCommunity.t930' /></label>
											</span>
											<span id="Makedate"><input type="text" id="Edatepicker" readonly="readonly" style="width: 80px; text-align: center"></span>
										</c:when>
										<c:otherwise>
											<span id="Chkbox">
												<input type="checkbox" id="ChkPermanence" name="ChkPermanence" onclick="return ChkPermanent()">
												<label for="ChkPermanence"><spring:message code='ezCommunity.t930' /></label>
											</span>
											<span id="Makedate"><input type="text" id="Edatepicker" readonly="readonly" style="width: 80px; text-align: center"></span>
										</c:otherwise>
									</c:choose>
								</div>
							</td>
						</tr>
						<tr>
							<th><spring:message code='ezCommunity.t1171' /></th>
							<c:choose>
								<c:when test="${item.importance == '1' }">
									<td>
										<div class="custom_checkbox">
											<input type="checkbox" id="chkEmergent" checked>
											<label for="chkEmergent"><spring:message code='ezCommunity.t1172' /></label>
										</div>
									</td>
								</c:when>
								<c:otherwise>
									<td>
										<div class="custom_checkbox">
											<input type="checkbox" id="chkEmergent">
											<label for="chkEmergent"><spring:message code='ezCommunity.t1172' /></label>
										</div>
									</td>
								</c:otherwise>
							</c:choose>
						</tr>
	
						<c:if test="${boardInfo.gubun == '2' }">
							<tr>
								<th><spring:message code='ezCommunity.t1173' /></th>
								<td><input type="text" id="txtNickName" style="WIDTH: 150px"
									maxlength="15" value="${item.writerName }">&nbsp;&nbsp;(<spring:message
										code='ezCommunity.t1174' /></td>
							</tr>
							<tr>
								<th><spring:message code='ezCommunity.t1175' /></th>
								<td><input type="password" id="txtPassWord"
									style="WIDTH: 150px" maxlength="15">&nbsp;&nbsp;(<spring:message
										code='ezCommunity.t1176' /></td>
							</tr>
						</c:if>
	
						<tr>
							<th><spring:message code='ezCommunity.t433' /></th>
							<td><input class="inputText" type="text" id="txtAbstract" style="WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box; word-break: break-all"	value="" maxlength="100"></td>
						</tr>
						<tr>
							<th><spring:message code='ezCommunity.t124' /></th>
							<td><input class="inputText" type="text" id="txtTitle" style="WIDTH: 100%; box-sizing: border-box; -moz-box-sizing: border-box; word-wrap: break-word; word-break: break-all;" value="" maxlength="100" onkeydown="Title_onkeyDown(event)"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td style="height: 100%; vertical-align: top;" id="EdtorSize">
					<c:if test="${editor ne 'HWP'}">
						<iframe id="message" class="viewbox" name="message"
						src="/ezEditor/selectEditor.do"
						style="padding: 0; height: 100%; width: 100%; overflow: auto;margin-top:-1px;"></iframe>
					</c:if>
					<c:if test="${editor eq 'HWP'}">
						<iframe id="message" class="viewbox" name="message"
						src="/ezCommunity/WHWPEditor.do?type=${pMode}"
						style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
					</c:if>
				</td>
			</tr>
			<tr id="docTR" style="display: none">
				<td>
					<div id="docContentBorder"
						style="border: #ddd 1px solid; BACKGROUND-COLOR: white;">
						<iframe id="docContent" style="width: 100%; height: 100%;"
							frameborder="0"></iframe>
					</div>
				</td>
			</tr>
			<tr>
				<td style="height: 20px; vertical-align: top;">
	
					<c:choose>
						<c:when test="${isCrossBrowser != true}">
							<table class="file">
								<form name="multicheck">
									<div style="width:100%;white-space:nowrap;display:inline-block; height: 23px;">
										<div style="float:left">
											<a class="imgbtn imgbck" id="btn_AttachAdd" onclick="btn_AttachSelect_onclick()"><span><spring:message code='ezCommunity.t1177' /></span></a>
											<a class="imgbtn imgbck" id="btn_AttachDel" onclick="btn_AttachDel_onclick()"><span><spring:message code='ezCommunity.t1178' /></span></a>
										</div>
										<div id="progdiv" class="progarea" style="display:none">
											<P class="prog_bar"><span id="prog_bar" style="width:0%"></span></P> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
										</div>
									</div>
										<%--<th><spring:message code='ezCommunity.t141' /></th>--%>
									<div id="lstAttachLink" class="ui-sortable" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)" style="overflow:auto;">
										<table id="filelist" class="sublist" style="width: 100%;"><tr><th style="width: 15px;"><div class="custom_checkbox"><input type="checkbox" id="checkboxall"></div></th><th style="width: 87%;"><spring:message code='ezCommunity.t1135' /></th><th style="width: 13%;"><spring:message code='ezCommunity.t1136' /></th></tr></table>
										<p id="attachInnerNotice" class="attachInnerNotice_p_on"><span class="attachInnerNotice_span"><spring:message code='ezJournal.AttachMJS01' /></span></p></div>
									<input id="file" type="file" onchange="filechange(event)" multiple="" style="display:none">
									<input type="hidden" value="upload" onclick="fileupload()">
								</form>
							</table>
						</c:when>
						<c:otherwise>
							<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
							<form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm" style="visibility: hidden;">
								<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="multiple" />
								<input type="hidden" name="boardID" id="boardID" />
								<input type="hidden" name="maxSize" id="maxSize" />
								<input type="hidden" name="mode" id="mode" />
								<input type="hidden" name="cnt" id="cnt" />
								<input type="hidden" name="mailGubun" id="mailgubun" />
							</form>
									<div style="width:100%;white-space:nowrap;display:inline-block; height: 23px;">
										<div style="float:left">
											<a class="imgbtn imgbck" id="btn_AttachAdd" onclick="btn_AttachSelect_onclick()"><span><spring:message code='ezCommunity.t1177' /></span></a>
											<a class="imgbtn imgbck" id="btn_AttachDel" onclick="btn_AttachDel_onclick()"><span><spring:message code='ezCommunity.t1178' /></span></a>
										</div>
										<div id="progdiv" class="progarea" style="display:none">
											<P class="prog_bar"><span id="prog_bar" style="width:0%"></span></P> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
										</div>
									</div>
										<%--<th><spring:message code='ezCommunity.t141' /></th>--%>
											<div id="lstAttachLink" class="ui-sortable" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)" style="overflow:auto;">
												<table id="filelist" class="sublist" style="width: 100%;"><tr><th style="width: 15px;"><div class="custom_checkbox"><input type="checkbox" id="checkboxall"></div></th><th style="width: 87%;"><spring:message code='ezCommunity.t1135' /></th><th style="width: 13%;"><spring:message code='ezCommunity.t1136' /></th></tr></table>
												<p id="attachInnerNotice" class="attachInnerNotice_p_on"><span class="attachInnerNotice_span"><spring:message code='ezJournal.AttachMJS01' /></span></p></div>
											<input id="file" type="file" onchange="filechange(event)" multiple="" style="display:none">
											<input type="hidden" value="upload" onclick="fileupload()">
						</c:otherwise>
					</c:choose>	
				</td>
			</tr>	
			<div id="txtAttachList"></div>
		</table>

		<input id="publicModulus" value="${publicModulus }" type="hidden" />
		<input id="publicExponent" value="${publicExponent }" type="hidden" />

		<script type="text/javascript">
	    	<c:if test="${boardInfo.gubun != '2'}">
            	document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 335 + "PX";
	    	</c:if>

	    	<c:if test="${boardInfo.gubun == '2'}">
	            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 365 + "PX";
	    	</c:if>
			
			function mobileDistinction() {
   				var  userAgent = navigator.userAgent.toLowerCase();
				
				if (/iphone|ipod|ipad|android.*mobile/i.test(userAgent) || /tablet|ipad|android/i.test(userAgent) || navigator.maxTouchPoints > 4) {
					if (window.innerWidth > window.innerHeight) {
						document.getElementById("EdtorSize").style.height = 436 + "PX";
						document.getElementById("message").style.height = 436 + "PX";
					}
				}
			}
			
			mobileDistinction();
		</script>

		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0, 0, 0, 0.7); display: none;"	id="mailPanel">&nbsp;</div>
		<div class="layerpopup"	style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
