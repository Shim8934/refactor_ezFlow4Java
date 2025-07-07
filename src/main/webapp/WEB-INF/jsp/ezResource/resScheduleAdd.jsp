<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<title><spring:message code="ezResource.t171"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/Schedule_cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
		<!-- data picker-->
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
		<!-- time picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript">
			<%-- var g_DD = "<%=Request.QueryString["dd"]%>";
	    	var g_MM = "<%=Request.QueryString["mm"]%>";
	    	var g_YY = "<%=Request.QueryString["yy"]%>"; --%>
	    	var dayView = "<c:out value='${dayView}'/>";
	    	if (!dayView) {
	    		dayView = 0;
	    	}
	    	var reFlag; 
	    	var importanceVal;
	    	var g_fromStr		= "<c:out value='${fromStr}'/>";
	    	var s_userID		= "${userInfo.id}";
	    	var ss_companyID	= "${userInfo.companyID}";
	    	var ss_deptNM		= "";
	    	var ss_ownerNM		= "";
	    	var lang = "${userInfo.primary}";
	    	var deptID = "${userInfo.deptID}";
	    	
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
	    	var cmd				= "<c:out value='${cmdStr}'/>";
	    	var typeVal			= "${typeVal}";
	    	var startDateVal	= "<c:out value='${startDateVal}'/>";
	    	var endDateVal		= "<c:out value='${endDateVal}'/>";
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
	    	var sDT2				="${startDateTime2}";
	    	var eDT2				="${endDateTime2}";
	    	var flag = false;
	    	var startDateTimeRepeat = "${startDateTimeRepeat}";
	    	var endDateTimeRepeat = "${endDateTimeRepeat}";
	    	var brdName = "${brdName}";
	    	var resID = "${resID}";
	    	var ItemArray = new Array();
	    	var m_Arguments;
	    	var msgRtn = "";
	    	var SdateNow = ""; 
	    	var EdateNow = ""; 
	    	var allDay = "${allDay}";//"1":하루종일
	    	var timeSelect = false;
	    	var userDisplayName2 = "${userInfo.displayName2}";
	    	var repetition = "";
	    	var offSetMin = "<c:out value='${offSetMin}'/>";
			// 반복예약허용 Flag
			var repeatFlag       = "${repeatFlag}";
	    	
	    	// 메인페이지의 onload실행과 initLoad함수의 실행 속도 차이로 setTimeout함수 사용
	    	var onloadflag = false;
	    	
	    	if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
	        	}
	    	}

		    window.onload = function () {
		        try {
	    	        m_Arguments = opener.schedule_add_ck_dialogArguments[0];
		       } catch (e) {
	            	try {
	            		m_Arguments = window.dialogArguments;
	            	} catch (e) {
	            		m_Arguments = parent.schedule_add_ck_dialogArguments[0];
		            }        
	    	    } 
	        	if (cmd == "mod") {
	        		document.getElementById("displayNM").innerHTML = "<a onClick=MemberInfo_onClick('" + writerIDVal + "','" +deptID + "')>" + org_ownerNM + "</a> (" + org_deptNM + ")";	
	        	} else {
	        	document.getElementById("displayNM").innerHTML = "<a onClick=MemberInfo_onClick('" + s_userID + "','" + deptID + "')>" + ss_ownerNM + "</a> (" + ss_deptNM + ")";
	        	}
	            
	        	if (cmd == "mod") {
	        		/* 2018-07-10 김민성 - 자원 수정시 특수문자 처리 */
	            	document.getElementById("importance1").value = "${importance}";
					document.getElementById("title").value = ConvMakeXMLString(ReplaceHTML('<c:out value="${title}" escapeXml="false"/>'));
	            	document.getElementById("loc").value = ConvMakeXMLString("<c:out value='${loc}'/>");
	            	
	            	if(allDay == "1") {
	            		document.getElementById("AllDay").checked = true;
	            	}
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
	    	        ItemArray[1] = Array("${brdName}");

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
	            	}
	            	
	            	onloadflag = true;
	        	}

	        	if (m_Arguments != undefined) {
	            	ItemArray[0] = m_Arguments[0];
	            	ItemArray[1] = m_Arguments[1];

		            document.getElementById('itemList').innerHTML = "";

		            for (var i = 0 ; i < ItemArray[0].length; i++) {
	                	if ((i + 1) < ItemArray[0].length) {
	                		document.getElementById('itemList').innerHTML = document.getElementById('itemList').innerHTML + ItemArray[1][i] + " ,  ";
	                	} else {
	                		document.getElementById('itemList').innerHTML = document.getElementById('itemList').innerHTML + ItemArray[1][i];
		                }	
		            }
		        }
	        	
	        	if(cmd == "mod") {
	        		if(sDT.substring(14,19) == "00:00" && eDT.substring(14,19) == "23:59") {
	        			document.getElementById("AllDay").checked = true;	        			
	        			display_time_Unshow();
	        		}
	        	}
		    }
			
		    window.onresize = function () {
				mobileDistinction();
				
				var editorFrame = document.getElementById('Iframe1');
				var editorTd = document.getElementById('EdtorSize');
				
				editorFrame.style.height = editorTd.style.height;
				
	    	}
		    
		    window.onunload = function () {
		        // try {
		        //     m_Arguments = opener.schedule_add_ck_dialogArguments[0];
		        //     opener.close();
		        // }
		        // catch (e) {
		        // }
		    }
		    
		    $(function () {
	    	    $("#Sdatepicker").datepicker({
	        	    changeMonth: true,
	            	changeYear: true,
	            	autoSize: true,
	            	showOn: "both",
	            	buttonImage: "/images/ImgIcon/calendar-month.png",
	            	buttonImageOnly: true,
	            	onSelect : function(dateText, inst) {
		            	var startD = new Date(inst.lastVal);
		            	var endD = new Date($("#Edatepicker").datepicker().val());
		            	var dateDiff = (endD - startD)/1000/24/60/60;
		            	
		            	var nowSDate = dateText.split('-');
		            	var nowSDate2 = new Date(nowSDate[0], nowSDate[1]-1, nowSDate[2]);
		            	nowSDate2.setDate(nowSDate2.getDate() + dateDiff);

		            	$("#Edatepicker").datepicker('setDate', nowSDate2);
		            }
	        	});
	        	$("#Edatepicker").datepicker({
	            	changeMonth: true,
	            	changeYear: true,
	            	autoSize: true,
	            	showOn: "both",
	            	buttonImage: "/images/ImgIcon/calendar-month.png",
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
				
	        	SdateNow = SDate;
	        	EdateNow = EDate;
	        	
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
		    
		    $(function () {
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
		    
		    function Editor_Complete() {
		        if (cmd == "mod") {
	    	        message.SetEditorContent(sigBody.innerHTML);
	        	}

	        	if (cmd == "add") {
	                message.SetEditorContent(msgRtn);
		        }
	    	}

	    	function FieldsAvailable() {
	    	}

	    	function MemberInfo_onClick(pSelUserID, deptID) {
	        	if (pSelUserID != "") {
		            var feature = GetOpenPosition(420, 450);
		            window.open("/ezCommon/showPersonInfo.do?id=" + pSelUserID +"&dept=" + deptID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
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
	    	            //2018-08-29 김보미 - 수정시 하루종일 체크 해제시 현재시간으로 나오게 변경
	    	            if (allDay == "1" && !timeSelect) {
		    	            setNowTime();
	    	            }
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
	    	
	    	var doubleSubmitFlag = false;
	    	function doubleSubmitCheck(){
	    	    if(doubleSubmitFlag){
	    	        return doubleSubmitFlag;
	    	    }else{
	    	        doubleSubmitFlag = true;
	    	        return false;
	    	    }
	    	}
	    	
	    	var SaveScheduleId = "";
	    	function btn_Save() {
			try {
				if(doubleSubmitCheck()) return;
			
	        	var check = true;
				// 반복예약허용 유무 체크
				if (repeatFlag != '1' && (g_data["recurrence"] || g_data["repetition"])) {
					check = false;
				}

				if (!check) {
					alert("<spring:message code="ezResource.lyj04"/>");
					return;
				}

	        	if (ItemArray[0].length == 0) {
	            	alert(strLang252);
	            	return;
	        	}
	        	/* 2018.02.22 김기하  #11624 */
    			
	        	var ssDate = $("#Sdatepicker").datepicker().val();
	        	var eeDate = $("#Edatepicker").datepicker().val();
	        	var ssTime = $("#Stimepicker").timepicker({ 'timeFormat': 'H:i' }).val();
	        	var eeTime = $("#Etimepicker").timepicker({ 'timeFormat': 'H:i' }).val();
	        	
	        	if(ssDate == "" || eeDate == "" || ssTime == "" || eeTime == ""){
	        		$("#Sdatepicker").datepicker("setDate", SdateNow);
	        		$("#Edatepicker").datepicker("setDate", EdateNow);
	        		$("#Stimepicker").timepicker("setTime", SdateNow);
	        		$("#Etimepicker").timepicker("setTime", EdateNow);
	        			        	
		        	alert(strLang139);
		        	return;
	        	}
	        	
	        	for (var i = 0 ; i < ItemArray[0].length ; i++) {
	            	if (DupCheck(ItemArray[0][i]) == false) {
	                	alert("[" + ItemArray[1][i] + "] " + strLang248);
	                	check = false;
	            	}
	        	}
	        	
	        	/* 2018.03.23 서주연 - #12125 버그 해결위해 경고창 띄우는 부분 여기로 이동 */
	        	if (ApproveFlag == "1" && SavedApproveFlag == "1" && pAdminFg != "Y" && cmd == "mod") {
	        		alert("" + strLang132 + "");
	        		return;
	        	}
	        	
	        	SessionCheck();
	        	
	        	if(trim_Cross(document.getElementById("title").value) == "" ) {
	        		alert("" + strLang138 + "");
	        		return;
	        	}
	        	
	        	// 일반/하루종일
	        	if(!document.getElementById("AllDay").checked) {
	        		if( !CheckStartEndDateTime() ) {
	        			alert("" + strLang139 + "");			
	        			return;
	        		}
	        	} else {
	        		if (!AllDayCheckStartEndDateTime()) {
	        			// 2018-10-02 김민성 - 자원 반복예약 시 회수 설정 시 끝날짜 무시하도록 수정
	        			// 2020-04-15 장세원 - 자원 하루종일 예약시 종료일이 시작일 전일경우 return
	        			if($("#EndTimeSet").checked == true || $("#EndTimeSet").checked == undefined) {		
		        			alert("" + strLang139 + "");			
		        			return;
	        			}
	        		}
	        	}
	        	
	        	// 자신의 일정인지 체크
	        	if ( cmd == "mod" ) {
	        		// 관리자가 아닌 경우
	        		if (CheckAdmin() == false && OwnerCheck() == false) {
	        			alert("" + strLang140 + "");
	        			return;
	        		}
	        	}

	        	if (check == true) {
	            	if (cmd == "add") {
	            		// 일정관리 동시 등록
		            	if(document.getElementById("useSchedule").checked == true) {
		            		// 일정 > 이전날짜 등록기능 자원예약시에도 적용
		            		if (CheckPreviously()) {
		            			alert(strLang340);
		            			return;
		            		} else {
		            			SaveScheduleId = saveSchedule();
		            		}
		            	}
	            	}
	            	
	            	for (var i = 0 ; i < ItemArray[0].length ; i++) {
		                SaveSchedule_onClick(cmd, ItemArray[0][i]);
		            }
	            	
	            	// 2019-04-19 김민성 - 자원 동시에 예약 시 모든 자원 예약 후 화면 새로고침 되도록 수정
	            	if (!setApprovFlag) {
	            		/* 2021-09-07 홍승비 - 자원예약 및 수정동작 완료 시 알러트 메세지 표출 (타 모듈과 동일하게) */
	            		if (cmd == "add" || cmd == "mod") {
	            			alert(strLangHSB01);
	            		}
	        		    window_onUnload();
	        		    window.close();
	        		}
	    	    }
	        	return check;
			} catch (e) {
				console.log(e);
			} finally {
				doubleSubmitCancel();
			}
	    	}

            function doubleSubmitCancel() {
                setTimeout(function() {
                    doubleSubmitFlag = false;
                }, 500);
            }
            
	    	function CheckPreviously() {
	    	    var rtv = false;

	    	    $.ajax({
	    			type : "GET",
	    			dataType : "text",
	    			async : false,
	    			cache : false,
	    			url : "/ezSchedule/scheduleGetRegi.do",
	    			data : {
	    				COMPANYID  : ss_companyID		    			
	    			},
	    			success: function(text) {
	    				if (text == "2") {		// 1일때 사용, 2일때 사용안함
	    					if ($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() < utcDate(offSetMin)) {					
	    						rtv = true;
	    					}
	    				}
	    			}
	    	    });

	    	    return rtv;    
	    	}
	    	
	    	function saveSchedule() {
	    		var pageFrom = "";
	    		var xmlHTTP = createXMLHttpRequest();
	    		var xmlDom = createXmlDom();    
	    		var objNode, objRow, objRows;

	    		objNode = createNodeInsert(xmlDom, objNode, "DATA");
	    		createNodeAndInsertText(xmlDom, objNode, "SCHEDULEID", "");
	    		createNodeAndInsertText(xmlDom, objNode, "OWNERID", s_userID);
	    		createNodeAndInsertText(xmlDom, objNode, "OWNERNAME", ss_ownerNM);
	    		createNodeAndInsertText(xmlDom, objNode, "OWNERNAME2", userDisplayName2);
	    		createNodeAndInsertText(xmlDom, objNode, "CREATORID", s_userID);
	    		createNodeAndInsertText(xmlDom, objNode, "CREATORNAME", ss_ownerNM);
	    		createNodeAndInsertText(xmlDom, objNode, "CREATORNAME2", userDisplayName2);
	    		//createNodeAndInsertText(xmlDom, objNode, "CHANGEKEY", "1");
	    		createNodeAndInsertText(xmlDom, objNode, "SCHEDULETYPE", "1");
	    		createNodeAndInsertText(xmlDom, objNode, "IMPORTANCE", document.getElementById("importance1").value);
	    		createNodeAndInsertText(xmlDom, objNode, "ISPUBLIC", "N");
	    		createNodeAndInsertText(xmlDom, objNode, "REPETITION", repetition);
				createNodeAndInsertText(xmlDom, objNode, "TITLE", document.getElementById("title").value);
	    		createNodeAndInsertText(xmlDom, objNode, "LOCATION", "");
	    		createNodeAndInsertText(xmlDom, objNode, "CONTENTPATH", "");
	    		
	    		objRow = createNodeAndAppandNode(xmlDom, objNode, objRow, "ATTENDANTLIST");
                if (g_attendant != null) {
                    for (var i=0; i<g_attendant["id"].length; i++) {
                        createNodeAndAppandNodeText(xmlDom, objRow, objRows , "ATTENDANTID", g_attendant["id"][i]);
                        createNodeAndAppandNodeText(xmlDom, objRow, objRows , "ATTENDANTNAME1", g_attendant["name1"][i]);
                        createNodeAndAppandNodeText(xmlDom, objRow, objRows , "ATTENDANTNAME2", g_attendant["name2"][i]);
                        createNodeAndAppandNodeText(xmlDom, objRow, objRows , "ATTENDANTDEPTNAME", g_attendant["deptname"][i]);
                        createNodeAndAppandNodeText(xmlDom, objRow, objRows , "ATTENDANTDEPTNAME2", g_attendant["deptname2"][i]);
                    }
                }
	    		
	    		var Doc_ContentHtml = document.createElement("DIV");
	    	    var strBody = message.GetEditorContent();
	    	    Doc_ContentHtml.innerHTML = strBody;
	    	    strBody = HTMLtoMHT_MakeTag(Doc_ContentHtml);
	    	    
	    	    var htmlConv = Signature_ImagePathConvert(strBody);
	    		try {
	    			htmlConv = ConvertHTMLtoMHT(htmlConv);
	    		} catch (e) {
	    			//alert(strLangHSB1);
	    			return;
	    		}
	    	    createNodeAndInsertText(xmlDom, objNode, "CONTENT", pidCryptUtil.encodeBase64(htmlConv, 64));
	    		/* var content = "";
				content = message.GetEditorContent();
	    		createNodeAndInsertText(xmlDom, objNode, "CONTENT", content); */
	    		
	    		var objNode4,objNode5,objNode6;
	    		if (document.getElementById("AllDay").checked == true) {
	    		    objNode4 = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";
	    		    objNode5 = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59:00";
	    			objNode6 = "2";
	    		} else {
	    		    objNode4 = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
	    		    objNode5 = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
	    			objNode6 = "1";
	    		}
	    		
	    		if(repetition != "") {
	    			objNode6 = "3";
	    		}
	    		createNodeAndInsertText(xmlDom, objNode, "DATETYPE", objNode6);
	    		createNodeAndInsertText(xmlDom, objNode, "STARTDATE", objNode4);
	    		createNodeAndInsertText(xmlDom, objNode, "ENDDATE", objNode5);

	    		xmlHTTP.open("POST", "/ezSchedule/scheduleSave.do?pageFrom=" + pageFrom, false);
	    		xmlHTTP.send(xmlDom);
	    		
	    		return trim(xmlHTTP.responseText);
	    	}

	    	function window_onUnload() {
	        	if (m_Arguments == undefined) {
		            if (window.opener != null && g_fromStr == "schedule" && trim(s_userID) != "") {
		            	try {
			                window.opener.btnRefresh_onclick();
		            	} catch (e) {}
	    	        } else if (window.opener != null && g_fromStr == "schedule2" && trim(s_userID) != "") {
		            	try {
		                	window.opener.parent.main.document.location.reload();
		            	} catch (e) {}
	            	} else if (window.opener != null && g_fromStr == "frame" && trim(s_userID) != "") {
		            	try {
		                	window.opener.document.all.iframeWin2.document.location.reload();
		            	} catch (e) {}
	            	} else if (window.opener != null && g_fromStr == "frame2" && trim(s_userID) != "") {
		            	try {
		                	window.opener.document.all.iframeWin.document.location.reload();
		            	} catch (e) {}
	            	} else if (window.opener != null && g_fromStr == "todaySchedule" && trim(s_userID) != "") {
		            	try {
		                	window.opener.location.reload();
		            	} catch (e) {}
	            	}
	        	} else {
					if (window.opener != null && window.opener.name == "left" && g_fromStr == "schedule" && trim(s_userID) != "") {
		            	try {
			                window.opener.parent.right.btnRefresh_onclick();
		            	} catch (e) {}
					}
				}
	    	}

            //2018-08-28 김보미 - 현재시간으로 설정
	    	function setNowTime() {
	        	var now = new Date();
	        	
	        	//시작시간
	        	var startTime;
	        	var hour = now.getHours();
	        	var time = now.getMinutes();
	        	
	        	if (parseInt(time) < 30) {
	        		startTime = hour + ":00:00";
	        	} else {
	        		startTime = hour + ":30:00";
	        	}
	        	
	        	//종료시간
	        	var endTime;
	        	now.setMinutes(now.getMinutes() + 30);
	        	
	        	hour = now.getHours();
	        	time = now.getMinutes();
	        	
	        	if (parseInt(time) < 30) {
	        		endTime = hour + ":00:00";
	        	} else {
	        		endTime = hour + ":30:00";
	        	}
	        	
	        	$('#Stimepicker').timepicker('setTime', startTime);
	        	$('#Etimepicker').timepicker('setTime', endTime);
	    	}
            
	        $(document).on('click', ".ui-timepicker-list li", function() {
	        	timeSelect = true;
	        })
	        
	        function KeEventControl(obj) {
	            if ((window.event.keyCode >= 48 && window.event.keyCode <= 57) || (window.event.keyCode >= 96 && window.event.keyCode <= 105)) {
	                return false;
	            }
	            else obj.value = obj.value.replace(/[\a-zㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
	        }
	        
		    /* 2022-07-29 홍승비 - 자원예약 수정 시 특수문자 처리 */
		    function ConvMakeXMLString(str) {
		        str = ReplaceText(str, "&lt;", "<");
		        str = ReplaceText(str, "&gt;", ">");
		        str = ReplaceText(str, "&#039;", "'");
		        str = ReplaceText(str, "&#034;", "\"");
		        str = ReplaceText(str, "&#92;", "\\");
		  	    str = ReplaceText(str, "&amp;", "&");	    
		        return str;
		    }
	        
            function useScheduleOnclick() {
                if ($("#useSchedule").is(":checked")) {
                    $("#attendantTr").show();
                } else {
                    $("#attendantTr").hide();
                }
            }
		    
		    var g_attendant = null;
            var schedule_select_attendant_dialogArguments = new Array();
            function manage_attendant() {
                var StartTime = $("#Sdatepicker").datepicker({dateFormat: 'yy-mm-dd'}).val()
                var EndTime = $("#Edatepicker").datepicker({dateFormat: 'yy-mm-dd'}).val()
            
                schedule_select_attendant_dialogArguments[0] = g_attendant;
                schedule_select_attendant_dialogArguments[1] = manage_attendant_Complete;
            
                GetOpenWindow("/ezSchedule/scheduleSelectAttendant.do?title=" + encodeURI("<spring:message code='ezSchedule.t234'/>") + "&StartTime=" + StartTime + "&EndTime=" + EndTime + "&ownerid=" + s_userID, "schedule_select_attendant", 970, 655);
            }
            
            function manage_attendant_Complete(rtn) {
                if (typeof (rtn) != "undefined") {
                    g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "jikwe": new Array(), "phone": new Array() };
                    document.getElementById("receiverinput").innerText = "";
                    
                    var receiverList = "";
                    for (var i = 0; i < rtn["id"].length; i++) {
                        if (i != 0) {
                            receiverList += ", ";
                        }
                        receiverList += rtn["name"][i];
                      
                        g_attendant["name"][i] = rtn["name"][i];
                        g_attendant["id"][i] = rtn["id"][i];
                        g_attendant["deptname"][i] = rtn["deptname"][i];
                        g_attendant["name1"][i] = rtn["name1"][i];
                        g_attendant["name2"][i] = rtn["name2"][i];
                        g_attendant["deptname2"][i] = rtn["deptname2"][i];
                        g_attendant["jikwe"][i] = rtn["jikwe"][i];
                        g_attendant["phone"][i] = rtn["phone"][i];
                    }
                    document.getElementById("receiverinput").innerText = receiverList;
                }
            }
		</script>
	</head>
	<xmp id="sigBody" style="display: none;">${content}</xmp>
	<body id="mainbodytag" class="popup" style="height: 97%; overflow: hidden;">
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<table id="normalScreen" class="layout">
			<tr>
    			<td style="height:20px">
      				<div id="menu">      
        				<ul>
        					<c:choose>
        						<c:when test="${typeVal ne 'Readonly'}">
        							<div id="menuTable1" >
	        							<!-- 2018-05-30 구해안 그룹웨어 모듈 '등록','저장후닫기' => '저장'으로 통일  ezResource.t185 => t114 -->
	          							<li><span onClick="btn_Save()"> <spring:message code="ezResource.t114"/></span></li>
	          							<li id="deletebtbn" style="display:none"><span class="icon16 popup_icon16_delete" onClick="delSchedule_onClick('${num}','${ownerID}')"></span></li>
	          							
	       								<c:if test="${typeVal ne 'Instance' && typeVal ne 'Readonly' && repeatFlag ne '0'}" >
	       									<li><span id="Span2" name="ScheRep" id="ScheRep" name="ScheRep" onClick="Schedule_Repetition_onclick()"> <spring:message code="ezResource.t195"/></span></li>
	       								</c:if>
	
	       								<c:if test="${approveFlag eq '1' && adminFg eq 'Y' && cmdStr eq 'mod'}" >
	       									<c:choose>
	       										<c:when test="${saveApproveFlag eq '1'}">
					    							<li><span  onClick="SetApproval_onClick('${cmdStr}', '0')"><spring:message code="ezResource.t190"/></span></li>
	       										</c:when>
	       										<c:otherwise>
					    							<li><span  onClick="SetApproval_onClick('${cmdStr}', '1')"><spring:message code="ezResource.t191"/></span></li>
	       										</c:otherwise>
	       									</c:choose>
	        					 		</c:if>
	        					 		<li><span class="icon16 popup_icon16_print" onClick="print_onClick( false )"></span></li>
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
          					<li><span onClick="window.close();"></span></li>
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
	          					<div class="custom_checkbox"><input type="checkbox" id="AllDay" <c:if test="${allDay eq '1' && dayView ne 0}">checked</c:if> onClick="display_time_Unshow()" /></div><spring:message code="ezResource.t211"/>
	          					<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
	          					<input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);" onmousedown="return false"/>
	           						~
	           					<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
	           					<input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);" onmousedown="return false"/>
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
		           			<td style="display: none"><div class="custom_checkbox"><input type="checkbox" style="display: none" id="PublicFlag" checked /></div><spring:message code="ezResource.t217"/></td>
		           			<th style="display: none"> <spring:message code="ezResource.t218"/></th>
		           			<td style="display: none">
		           				<select id="characterID" name="select" class="select">
		               				<option value="0" selected><spring:message code="ezResource.t219"/></option>
		             			</select>          
		         			</td>
			     		</tr>
	       				<tr style="display: none">
	         				<th> <spring:message code="ezResource.t222"/></th>
	         				<td colspan="3"><input type="text" id="loc" name="loc" value="" style="width: 100%" /></td>
	       				</tr>
	       				<tr style="display: none">
	         				<td><div class="custom_checkbox"><input type="checkbox" id="alertCheck" d  /></div><spring:message code="ezResource.t223"/></td>
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
							<td colspan="3"><input type="text" id="title" name="title" maxlength="100"  style="width: 100%" value="<c:out value='${title}' escapeXml="false"/>" /></td>		<!-- 2018-07-13 김민성 - 자원예약 이름 글자수 제한 25->100자로 변경 -->
	       				</tr>
	       				<c:if test="${useSchedule && cmdStr eq 'add'}">
	       				<tr>
	         				<th><spring:message code="ezSchedule.t214"/></th>
	         				<td colspan="3"><div class="custom_checkbox"><input type="checkbox" id="useSchedule" name="useSchedule" onclick="useScheduleOnclick()"></div></td>
	       				</tr>
	       				<tr id="attendantTr" style="display:none;">
	         				<th><spring:message code="ezSchedule.t163"/></th>
	         				<td colspan="3">
	         				    <span id="clickbtn" class="imgbtn" style="padding: 0px 10px;" onclick="manage_attendant()"><spring:message code="ezSchedule.t364"/></span>
	         				    <!-- <input type="text" id="receiverinput" /> -->
	         				    <span id="receiverinput" style="vertical-align:middle; margin-left: 5px;"></span>
                            </td>
	       				</tr>
	       				</c:if>
      				</table>
      			</td>
  			</tr>
  			<tr>
	  			<td id="EdtorSize" style="vertical-align:top;height:100%;">
					<iframe id="Iframe1" class="viewbox" name="message" src="/ezEditor/selectEditor.do?type=RESOURCE" style="padding: 0; width: 100%; overflow: auto; margin-top: -1px"></iframe>
	      			
	      			<input type="hidden" id="iReFlag" value="${strIReFlagVal}" />
       				<input type="hidden" id="tmpReFlag" value="${strTmpReFlagVal}" />
       				<input type="hidden" id="gresFlag" value="${gresFlag}" />
       				<input type="hidden" id="num" value="${num}" />
       				<input type="hidden" id="pnum" value="${pNum}" />
       				<input type="hidden" id="ownerID" value="${ownerID}" />
       				<input type="hidden" id="writerID" value="${writerID}" />
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

	    <table id="printScreen" style="display: none;">
  			<tr style="text-align:center">
    			<td style="vertical-align:top">
    				<table style="width:100%; border:0px; padding:1px; border-collapse:collapse; border-spacing:0px; " class="content2">
	      				<tr style="height:25px"> 
        					<th style="padding-left:10px" width="80"><spring:message code="ezResource.t193"/></th> 
        					<td style="padding-left:10px"> <div id="printOwner"></div></td> 
      					</tr> 
      					<tr style="height:25px"> 
	        				<th style="padding-left:10px"><spring:message code="ezResource.t197"/></th> 
        					<td style="padding-left:10px"> <div id="printDate"></div></td> 
      					</tr>
      					<tr style="height:25px"> 
	        				<th style="padding-left:10px"><spring:message code="ezResource.t213"/></th> 
        					<td style="padding-left:10px"> <div id="printImportance"></div></td> 
      					</tr> 
      					<tr>
		            		<th style="padding-left:10px"><spring:message code='ezResource.t374' /></th>
		            		<td style="padding-left:10px;"> <div id="printItem"></div></td>
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
		</script>
    	<script type="text/javascript">
    			if(cmd == "add") {
		   	    	 document.getElementById("Iframe1").style.height = document.documentElement.clientHeight - 240 + "PX";
		    	}
		    	else {
		    		document.getElementById("Iframe1").style.height = document.documentElement.clientHeight - 220 + "PX";
		    	}
				
				function mobileDistinction() {
	   				var  userAgent = navigator.userAgent.toLowerCase();
					
					if (/iphone|ipod|ipad|android.*mobile/i.test(userAgent) || /tablet|ipad|android/i.test(userAgent) || navigator.maxTouchPoints > 4) {
						if (window.innerWidth > window.innerHeight) {
							document.getElementById("EdtorSize").style.height = 436 + "PX";
							document.getElementById("Iframe1").style.height = 436 + "PX";
						}
					}
				}
				
				mobileDistinction();
    	</script>
	</body>
</html>