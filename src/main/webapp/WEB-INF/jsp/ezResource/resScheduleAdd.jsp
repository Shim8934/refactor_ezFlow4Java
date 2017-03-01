<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<title><spring:message code="ezResource.t171"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezResource.e2"/>" type="text/css" />
		<script type="text/javascript" src="<spring:message code="ezResource.e1"/>"></script>
		<script type="text/javascript" src="/js/ezResource/Schedule_cross.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<!-- data picker-->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css"/>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css"/>
		<!-- time picker-->
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<script type="text/javascript">
			<%-- var g_DD = "<%=Request.QueryString["dd"]%>";
	    	var g_MM = "<%=Request.QueryString["mm"]%>";
	    	var g_YY = "<%=Request.QueryString["yy"]%>"; --%>
	    	var reFlag;
	    	var importanceVal;
	    	var g_fromStr		= "${fromStr}";
	    	var s_userID		= "${userInfo.id}";
	    	var ss_companyID	= "${userInfo.companyID}";
	    	var ss_deptNM		= "";
	    	var ss_ownerNM		= "";
	    	var lang = "${userInfo.primary}";
	    	
	    	if(lang == '2') {
	        	ss_deptNM		= "${userInfo.deptName2}"; 
	        	ss_ownerNM		= "${userInfo.displayName2}";
	    	} else  {
	        	ss_deptNM		= "${userInfo.deptName1}"; 
	        	ss_ownerNM		= "${userInfo.displayName1}";
	    	}
	    	
	    	var org_deptNM      = "${deptNm}";
	    	var org_ownerNM     = "${ownerNm}";
	    	var org_num			= "${num}";
	    	var org_ownerID		= "${ownerID}";
	    	var pnumVal			= "${pNum}";
	    	var writerIDVal		= "${writerID}";
	    	var cmd				= "${cmdStr}";
	    	var typeVal			= "${typeVal}";
	    	var startDateVal	= "${startDateVal}";
	    	var endDateVal		= "${endDateVal}";
	    	var gFlagVal		= "${gresFlag}";
	    	var uploadPath		= "${scheduleFilePath}";
	    	var org_companyID	= ss_companyID;
	    	var pAdminFg		= "${adminFg}";
	    	var nowDate         = "${nowDate}";
	    	var ApproveFlag     = "${approveFlag}";
	    	var SavedApproveFlag= "${saveApproveFlag}";
	    	var reFlagVal		= "${reFlag}";
	        var server_name = "${serverName}";
		    var allday_chk, onck = "1";	
	    	var sDT				="${startDateTime}";
	    	var eDT				="${endDateTime}";
	    	var flag = false;
	    	var startDateTimeRepeat = "${startDateTimeRepeat}";
	    	var endDateTimeRepeat = "${endDateTimeRepeat}";
	    	var brdName = "<c:out value='${brdName}' />";
	    	var resID = "${resID}";
	    	var ItemArray = new Array();
	    	var m_Arguments;
	    	var msgRtn = "";
	    	
	    	if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
	        	}
	    	}

		    window.onload = function () {
		        try {
	    	        m_Arguments = opener.schedule_add_ck_dialogArguments[0];
		        }
	        	catch (e) {
	            	try {
	                	m_Arguments = window.dialogArguments;
	            	} catch (e) {
		                m_Arguments = parent.schedule_add_ck_dialogArguments[0];
		            }        
	    	    }
	        	if (cmd == "mod") {
	        		document.getElementById("displayNM").innerHTML = "<a href=# onClick=MemberInfo_onClick('" + writerIDVal + "')>" + org_ownerNM + "</a> (" + org_deptNM + ")";	
	        	} else {
	        	document.getElementById("displayNM").innerHTML = "<a href=# onClick=MemberInfo_onClick('" + s_userID + "')>" + ss_ownerNM + "</a> (" + ss_deptNM + ")";
	        	}
	            
	        	if (cmd == "mod") {
	            	document.getElementById("importance1").value = "${importance}";
	        	}
	        	if (document.getElementById("AllDay").checked) {
		            document.getElementById("Stimepicker").style.display = "none";
		            document.getElementById("Etimepicker").style.display = "none";
	    	        onck = "0";
	        	}

	        	if (cmd == "add") {
		            document.title = "<spring:message code="ezResource.t171"/>";
		            document.getElementById("deletebtbn").style.display = "none";
	    	    } else {
	        	document.title = "<spring:message code="ezResource.t179"/>";
		        }
	            
		        var resultXML;
	    	    var xmlHttp = createXMLHttpRequest();
	        	var xmlpara = createXmlDom();
	        	var objNode;

	        	createNodeInsert(xmlpara, objNode, "PARAMETER");
	        	createNodeAndInsertText(xmlpara, objNode, "NUM", org_num);
	        	createNodeAndInsertText(xmlpara, objNode, "OWNERID", org_ownerID);
	        	createNodeAndInsertText(xmlpara, objNode, "GROUPID", "");
	        	createNodeAndInsertText(xmlpara, objNode, "companyID", org_companyID);

	        	if (document.getElementById("iReFlag").value == "1") {
	            	if (org_num != "" && org_ownerID != "") {
	                	xmlHttp.open("POST", "/ezResource/scheduleRepetitionProc.do?cmd=get", false);
	                	xmlHttp.send(xmlpara);

	                	resultXML = xmlHttp.responseXML;

	                	if (resultXML.xml != "") {
	                    	g_data["recurrence"] = getXmlString(resultXML);
	                	}
	            	}

	            	show_repetition_info();
	        	}

		        if (brdName != "" && resID  != "") {
		            ItemArray[0] = Array("${resID}");
	    	        ItemArray[1] = Array("<c:out value='${brdName}' />");

	        	    document.getElementById('itemList').innerHTML = "";
	            	document.getElementById('itemList').innerHTML = "${brdName}";
	        	}
		        
	        	if (cmd == "add") {
	            	var xmlHttp2 = createXMLHttpRequest();
	            	var xmlDoc2 = createXmlDom();
	
		            createNodeInsert(xmlDoc2, objNode, "PARAMETER");
	    	        createNodeAndInsertText(xmlDoc2, objNode, "RESID", "${resID}");

	        	    xmlHttp2.open("POST", "/ezResource/scheduleGetForm.do", false);
	            	xmlHttp2.send(xmlDoc2);

	            	result = xmlHttp2.responseText;

	            	if (result != "FALSE") {
	                	msgRtn = result;
	                	message.SetEditorContent(msgRtn);
	            	}
	        	}
	        	
	        	if (m_Arguments != undefined) {
	            	ItemArray[0] = m_Arguments[0];
	            	ItemArray[1] = m_Arguments[1];

		            document.getElementById('itemList').innerHTML = "";
		            
		            for (var i = 0 ; i < ItemArray[0].length ; i++) {
	                	if ((i + 1) < ItemArray[0].length) {
	                		document.getElementById('itemList').innerHTML = document.getElementById('itemList').innerHTML + ItemArray[1][i] + " ,  ";
	                	} else {
	                		document.getElementById('itemList').innerHTML = document.getElementById('itemList').innerHTML + ItemArray[1][i];
		                }	
		            }
		        }
		    }

		    $(function () {
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

	        	var uploadSDate = "${startDateTime2}";

	        	var sYear = uploadSDate.substring(0, 4);
				var sMonth = uploadSDate.substring(5, 7);
				var sDay = uploadSDate.substring(8, 10);
				var sHour = uploadSDate.substring(11, 13);
				var sMin = uploadSDate.substring(14, 16);

				var uploadEDate = "${endDateTime2}";
				var eYear = uploadEDate.substring(0, 4);
				var eMonth = uploadEDate.substring(5, 7);
				var eDay = uploadEDate.substring(8, 10);
				var eHour = uploadEDate.substring(11, 13);
				var eMin = uploadEDate.substring(14, 16);
				
	        	var SDate = new Date("");
	        	SDate.setFullYear(sYear, sMonth-1, sDay);
		        SDate.setHours(sHour, sMin, 0, 0);
	        	//SDate.setHours(SDate.getHours() - 9);
	        	
	        	var EDate = new Date();
		        EDate.setFullYear(eYear, eMonth-1, eDay);
		        EDate.setHours(eHour, eMin, 0, 0);
	        	//var EDate = new Date("${endDateTime2}");
	        	//EDate.setHours(EDate.getHours() - 9);

		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
	    	   	$('#Stimepicker').timepicker();
	        	$('#Stimepicker').timepicker('setTime', SDate);
	        	$('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });

	        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        	$("#Edatepicker").datepicker('setDate', EDate);
	        	$('#Etimepicker').timepicker();
	        	$('#Etimepicker').timepicker('setTime', EDate);
	        	$('#Etimepicker').timepicker({ 'timeFormat': 'H:i' });
	     	});
		    
		    if(lang == 1) {
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
		    } else {
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
		    
		    function DocumentComplete() {
		        if (cmd == "mod") {
	    	        message.SetEditorContent(sigBody.innerHTML);
	        	}

	        	if (cmd == "add") {
		            if (msgRtn != "") {
		                message.SetEditorContent(msgRtn);
	    	        }
		        }
	    	}

	    	function FieldsAvailable() {
	    	}

	    	function MemberInfo_onClick(pSelUserID) {
	        	if (pSelUserID != "") {
		            var feature = GetOpenPosition(420, 438);
		            window.open("/ezCommon/showPersonInfo.do?id=" + pSelUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	    	    }
	    	}	

	    	function display_time_Unshow() {
		        allday_chk = document.getElementById("AllDay").value;

		        if (allday_chk == "on") {

	    	        if (onck == "1") {
	        	        document.getElementById("Stimepicker").style.display = "none";
	            	    document.getElementById("Etimepicker").style.display = "none";
	                	onck = "0";
	                	return;
	            	}

	            	if (onck == "0") {
		                document.getElementById("Stimepicker").style.display = "";
		                document.getElementById("Etimepicker").style.display = "";
	    	            onck = "1";
	        	        return;
	            	}
	        	}

	        	if (allday_chk == "") {
		            document.getElementById("Stimepicker").style.display = "";
		            document.getElementById("Etimepicker").style.display = "";
	    	        onck = "1";
	        	}
		    }

		    function keyword_onkeydown() {
	    	    if (event.keyCode == 13) {
	    	    	Entry_onKeydown();	
	    	    }
		        return true;
		    }

		    var schedule_add_select_cross_dialogArguments = new Array();
	    	function Open_Select() {
	        	schedule_add_select_cross_dialogArguments[0] = ItemArray;
	        	schedule_add_select_cross_dialogArguments[1] = Open_Select_Complete;

		        DivPopUpShow(550, 435, "/ezResource/scheduleAddSelect.do");
		    }
	    	function Open_Select_Complete(retVal) {
	        	if (retVal == "close") {
	        	} else if (typeof (retVal) != "undefined" && retVal.length == 2) {
	            	ItemArray[0] = retVal[0];
	            	ItemArray[1] = retVal[1];

	            	document.getElementById('itemList').innerHTML = "";
	            	
	            	for (var i = 0 ; i < ItemArray[0].length ; i++) {
		                if ((i + 1) < ItemArray[0].length) {
		                	document.getElementById('itemList').innerHTML = document.getElementById('itemList').innerHTML + ItemArray[1][i] + " ,  ";	
		                } else {
	                		document.getElementById('itemList').innerHTML = document.getElementById('itemList').innerHTML + ItemArray[1][i];
	                	}
		            }
	        	}
	        	DivPopUpHidden();
	    	}

	    	function btn_Save() {
	        	var check = true;
	        	if (ItemArray[0].length == 0) {
	            	alert(unescape(strLang252));
	            	return;
	        	}
	        	for (var i = 0 ; i < ItemArray[0].length ; i++) {
	            	if (DupCheck(ItemArray[0][i]) == false) {
	                	alert(unescape("[" + ItemArray[1][i] + "] " + strLang248));
	                	check = false;
	            	}
	        	}

	        	if (check == true) {
	            	for (var i = 0 ; i < ItemArray[0].length ; i++) {
		                SaveSchedule_onClick("${cmdStr}", ItemArray[0][i]);
		            }
	    	    }
	        	return check;
	    	}

	    	function window_onUnload() {
	        	if (m_Arguments == undefined) {
		            if (window.opener != null && g_fromStr == "schedule" && trim(s_userID) != "") {
		                window.opener.btnRefresh_onclick();
	    	        } else if (window.opener != null && g_fromStr == "schedule2" && trim(s_userID) != "") {
	                	window.opener.parent.main.document.location.reload();
	            	} else if (window.opener != null && g_fromStr == "frame" && trim(s_userID) != "") {
	                	window.opener.document.all.iframeWin2.document.location.reload();
	            	} else if (window.opener != null && g_fromStr == "frame2" && trim(s_userID) != "") {
	                	window.opener.document.all.iframeWin.document.location.reload();
	            	} else if (window.opener != null && g_fromStr == "todaySchedule" && trim(s_userID) != "") {
	                	window.opener.location.reload();
	            	}
	        	}
	    	}

	    	window.onresize = function () {
		        document.getElementById("EdtorSize").style.height = document.body.clientHeight - 220 + "PX";
	    	}
		</script>
	</head>
	<xmp id="sigBody" style="display: none;">${content}</xmp>
	<body id="mainbodytag" class="popup" style="height: 100%;">
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<table id="normalScreen" class="layout">
			<tr>
    			<td style="height:20px">
      				<div id="menu">      
        				<ul>
        					<c:choose>
        						<c:when test="${typeVal ne 'Readonly'}">
        							<div id="menuTable1" >
          							<li><span onClick="btn_Save()"> <spring:message code="ezResource.t185"/></span></li>
          							<li><span onClick="print_onClick( false )"> <spring:message code="ezResource.t186"/></span></li>
          							<li id="deletebtbn"><span onClick="delSchedule_onClick('${num}','${ownerID}')"> <spring:message code="ezResource.t65"/></span></li>
          							
       								<c:if test="${typeVal ne 'Instance' && typeVal ne 'Readonly'}" >
       									<li><span id="Span2" name="ScheRep" id="ScheRep" name="ScheRep" onClick="Schedule_Repetition_onclick()"> <spring:message code="ezResource.t195"/></span></li>
       								</c:if>
          								
       								<c:if test="${strApproveFlag eq '1' && adminFg eq 'Y' && cmdStr eq 'mod'}" >
       									<c:choose>
       										<c:when test="${savedApproveFlag eq '1'}">
				    							<li><span  onClick="SetApproval_onClick('${cmdStr}', '0')"><spring:message code="ezResource.t190"/></span></li>
       										</c:when>
       										<c:otherwise>
				    							<li><span  onClick="SetApproval_onClick('${cmdStr}', '1')"><spring:message code="ezResource.t191"/></span></li>
       										</c:otherwise>
       									</c:choose>
        					 		</c:if> 
          							
	          						</div>          
	          						<div id="menuTable2" style='display:none'>								
	          							<li><span  onClick="btn_Save()"> <spring:message code="ezResource.t185"/></span></li>
	          							<li><span  onClick="print_onClick( true )"> <spring:message code="ezResource.t186"/></span></li>
	          							<li id="deletebtbn"><span onClick="delSchedule_onClick('${num}','${ownerID}')"> <spring:message code="ezResource.t65"/></span></li>
	          						</div>
        						</c:when>
        						<c:otherwise>
        							<li id="Table1" ><span onClick="print_onClick( false )"> <spring:message code="ezResource.t186"/></span></li>          
          							<li id="Table2" style='display:none'><span onClick="print_onClick( true )"> <spring:message code="ezResource.t186"/></span></li>
        						</c:otherwise>
        					</c:choose>
        				</ul>
      				</div>
      				<div id="close">
        				<ul>
          					<li><span onClick="window.close();"> <spring:message code="ezResource.t150"/></span></li>
        				</ul>
      				</div>
      				<table class="content" style="width:100%;">
        				<tr>
          					<th> <spring:message code="ezResource.t193"/></th>
          					<td colspan="3" style="width:100%"><div id="displayNM"> </div></td>
        				</tr>
        				
							
						<tr id="tr_Recur" <c:if test="${reFlag ne '1'}">style="display: none"</c:if>>
    						<th> <spring:message code="ezResource.t197"/></th>
    						<td colspan="3"><span id="AllDayDisplay"></span>
      							<select id="timeDisplay" name="timeDisplay" class="select" style="width: 95px; display: none">
	      							<option value="1" <c:if test="${timeDisplay eq '1'}">selected</c:if>><spring:message code="ezResource.t198"/></option>
									<option value="2" <c:if test="${timeDisplay eq '2'}">selected</c:if>><spring:message code="ezResource.t199"/></option>
									<option value="3" <c:if test="${timeDisplay eq '3'}">selected</c:if>><spring:message code="ezResource.t200"/></option>
									<option value="4" <c:if test="${timeDisplay eq '4'}">selected</c:if>><spring:message code="ezResource.t201"/></option> 
      							</select>
      			  			</td>
  						</tr>
				 		<script>
        		 	  		if (reFlagVal == "1") {
	                			strDspMod_1 = "style='display:none'";
                				strDspMod_2 = "";
            				} else {
	                			strDspMod_1 = "";
                				strDspMod_2 = "style='display:none'";
            				}	
            			</script>
					
	        			<tr id="tr_STime" ${strDspMod1}>
	          				<th> <spring:message code="ezResource.t197"/></th>
	          				<td width="100%" colspan="3" id="Td_StartDate" style="overflow:hidden;">
	          					<input type="checkbox" id="AllDay" <c:if test="${allDay eq '1'}">checked</c:if> onClick="display_time_Unshow()" /><spring:message code="ezResource.t211"/>
	          					<input type="text" id="Sdatepicker" style="width:80px;text-align:center"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center" />
	           						~
	           					<input type="text" id="Edatepicker" style="width:80px;text-align:center"><input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center" />
	          				</td>
	        			</tr>
				        <tr>
	       					<th> <spring:message code="ezResource.t213"/></th>
	       					<td style="width:160px" colspan="3">
	       						<select id="importance1" class="select">
   									<option value="1" <c:if test="${importance eq '1'}">selected</c:if>><spring:message code="ezResource.t214"/></option>
   									<option value="2" <c:if test="${importance eq '2'}">selected</c:if>><spring:message code="ezResource.t215"/></option>
   									<option value="3" <c:if test="${importance eq '3'}">selected</c:if>><spring:message code="ezResource.t216"/></option>
	         					</select>
	         				</td>
       						<th style="display: none"> <spring:message code="ezResource.t217"/></th>
		           			<td style="display: none"><input type="checkbox" style="display: none" id="PublicFlag" checked /><spring:message code="ezResource.t217"/></td>
		           			<th style="display: none"> <spring:message code="ezResource.t218"/></th>
		           			<td style="display: none">
		           				<select id="characterID" name="select" class="select">
		               				<option value="0" selected><spring:message code="ezResource.t219"/></option>
		             			</select>          
		         			</td>
			     		</tr>
	       				<tr style="display: none">
	         				<th> <spring:message code="ezResource.t222"/></th>
	         				<td colspan="3"><input type="text" id="loc" name="loc" value="${loc}" style="width: 100%" /></td>
	       				</tr>
	       				<tr style="display: none">
	         				<td><input type="checkbox" id="alertCheck" d  /><spring:message code="ezResource.t223"/></td>
	         				<td colspan="5">&nbsp;</td>
	       				</tr>
        
						<tr id="Span1">
	           				<th>
	           					<c:choose>
	           						<c:when test="${cmdStr eq 'mod'}">
	           							<spring:message code="ezResource.t374"/>
	           						</c:when>
	           						<c:otherwise>
	           							<a class="imgbtn"><span  id="Span1" name="ScheRep" onClick="javascript:return Open_Select()"><spring:message code="ezResource.t375"/></span></a>
	           						</c:otherwise>
	           					</c:choose>
	           				</th>
	           				<td colspan="7" id ="itemList" style="padding-left:4px;"></td>
						</tr>
						<tr>
	         				<th> <spring:message code="ezResource.t224"/></th>
	         				<td colspan="3"><input type="text" id="title" name="title" maxlength="25" value="${title}" style="width: 98%" />          </td>
	       				</tr>
      				</table>
      			</td>
  			</tr>
  			<tr>
	  			<td <c:if test="${noneActiveX eq 'YES'}">style="height:100%"</c:if>>
        			<table style="height:100%; width:100%">
        				<tr style="height:100%">
          					<td id="EdtorSize">
           						<div id="divCross" style="height: 100%;">
           							<c:choose>
           								<c:when test="${editor eq 'TAGFREE'}" >
           									<iframe id="Iframe1" class="viewbox"  name="message" src="/ezResource/tagFreeTFXEditor.do" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
           								</c:when>
           								<c:when test="${editor eq 'DEXT'}" >
           									<iframe id="Iframe1" class="viewbox"  name="message" src="/ezResource/dextEditor.do" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
           								</c:when>
           								<c:otherwise>
           									<iframe id="Iframe1" class="viewbox"  name="message" src="/ezResource/ckEditor.do" style="padding:0; height:97%; width:99.7%; overflow:auto;"></iframe>
           								</c:otherwise>
           							</c:choose>
           						</div>
				          </td>
        				</tr>

				      	<input type="hidden" id="iReFlag" value="${strIReFlagVal}" />
        				<input type="hidden" id="tmpReFlag" value="${strTmpReFlagVal}" />
        				<input type="hidden" id="gresFlag" value="${gresFlag}" />
        				<input type="hidden" id="num" value="${num}" />
        				<input type="hidden" id="pnum" value="${pNum}" />
        				<input type="hidden" id="ownerID" value="${ownerID}" />
        				<input type="hidden" id="writerID" value="${writerID}" /> 
      				</table>
      			</td>
  			</tr>
  			<tr style="display: none">
			    <td style="height:10px" class="pad1">
			    	<table class="file" id="attachTable">
			        	<tr>
							<th> <spring:message code="ezResource.t227"/></th>
							<td class="pos1">
								<div id="attachedFile" style="display: none; background-c	olor: white; width:350px; height: 60px; overflow: auto"> </div>
                  				<div id="divBody" style="background-color: white; width:350px; height: 60px; overflow: auto;"> </div>
                  			</td>
							
							<c:if test="${typeVal ne 'Readonly'}">
								<td style="width:75px" class="pos2"><a class="imgbtn"><span id="btn_AttachAdd" onClick="AttachAdd_onClick()"><spring:message code="ezResource.t228"/></span></a><br>
									<a class="imgbtn"><span  onClick="AttachDel_onClick()"><spring:message code="ezResource.t229"/></span></a>
								</td>
							</c:if>
  						</tr>
					</table>
				</td>
			</tr>
		</table>
		<div id="baseColor" style="background-color: #fff9e5; border-bottom: gray 1px inset; border-left: gray 1px inset; border-right: gray 1px inset; border-top: gray 1px inset;
		display: none; position: absolute">
  			<table style="height:0px; width:190px; border:0; border-collapse:collapse; border-spacing:0; padding:0px" >
    			<tr>
      				<td style="width:190px">
      					<table id="baseColorTable" style="border:0px; border-collapse:collapse; border-spacing:1px; padding:0px; border-right-color:#999999; width:220px" onclick="baseColorTable_onClick()">
          					<tr>
            					<td style="width:50px; background-color:#000000; height:12px" title="#000000"></td>
            					<td style="width:50px; background-color:#808080" title="#808080"></td>
            					<td style="width:50px; background-color:#800000" title="#800000"></td>
            					<td style="width:50px; background-color:#808000" title="#808000"></td>
            					<td style="width:50px; background-color:#008000" title="#008000"></td>
            					<td style="width:50px; background-color:#008080" title="#008080"></td>
            					<td style="width:50px; background-color:#000080" title="#000080"></td>
            					<td style="width:50px; background-color:#800080" title="#800080"></td>
          					</tr>
          					<tr>
            					<td style="width:50px; background-color:#ffffff; height:12px" title="#ffffff"></td>
            					<td style="width:50px; background-color:#C0C0C0" title="#C0C0C0"></td>
            					<td style="width:50px; background-color:#FF0000" title="#FF0000"></td>
            					<td style="width:50px; background-color:#FFFF00" title="#FFFF00"></td>
            					<td style="width:50px; background-color:#00FF00" title="#00FF00"></td>
            					<td style="width:50px; background-color:#00FFFF" title="#00FFFF"></td>
            					<td style="width:50px; background-color:#0000FF" title="#0000FF"></td>
            					<td style="width:50px; background-color:#FF00FF" title="#FF00FF"></td>
          					</tr>
        				</table>
        			</td>
    			</tr>
  			</table>
		</div>

	    <table id="printScreen" style="display: none; width:100%; border:0px; padding:10px;" class="layout">
  			<tr style="text-align:center">
    			<td style="vertical-align:top">
    				<table style="width:100%; border:0px; padding:1px; border-collapse:collapse; border-spacing:0px; " class="content2">
	      				<tr style="height:25px"> 
        					<th style="padding-left:10px" width="80"><spring:message code="ezResource.t193"/></th> 
        					<td style="padding-left:10px"> <div id="printOwner"></div></td> 
      					</tr> 
      					<tr style="height:25px"> 
	        				<th style="padding-left:10px"><spring:message code="ezResource.t213"/></th> 
        					<td style="padding-left:10px"> <div id="printImportance"></div></td> 
      					</tr> 
      					<tr style="height:25px"> 
	        				<th style="padding-left:10px"><spring:message code="ezResource.t197"/></th> 
        					<td style="padding-left:10px"> <div id="printDate"></div></td> 
      					</tr> 
      					<tr style="height:25px"> 
	        				<th style="padding-left:10px"><spring:message code="ezResource.t224"/></th> 
        					<td style="padding-left:10px"> <div id="printTitle"></div></td> 
      					</tr> 
      					<tr> 
	        				<td colspan="2"><div align="left" id="printDocument" style="PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; WIDTH: 100%;  PADDING-TOP: 5px"></div></td> 
      					</tr> 
   					</table>
   				</td>
  			</tr>
		</table>

		<xmp id="xmpEntryEmailList" style="display: none;"> ${entryList}</xmp>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
    	<script type="text/javascript">
	       	document.getElementById("EdtorSize").style.height = document.body.clientHeight - 220 + "PX";
    	</script>
	</body>
</html>