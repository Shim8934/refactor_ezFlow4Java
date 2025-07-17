<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html ondragover="bodydragover(event)">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		
		<%-- 2022-12-01 이유정 - 수정 또는 신규 작성에 따라 다르게 title 부여 --%>
		<c:choose>
			<c:when test="${scheduleId != ''}">
				<title><spring:message code='ezSchedule.lyjSm001' /></title>
			</c:when>
			<c:otherwise>
				<title><spring:message code='ezSchedule.t357' /></title>
			</c:otherwise>
		</c:choose>
		
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
        <link rel="stylesheet" href="${util.addVer('/css/ezSchedule/Tab.css')}" type="text/css" />
        <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/schedule_write_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/TabMenu.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<!-- data picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
        <script type="text/javascript">
	        var userid = "<c:out value='${userId}'/>";
	        var username = "<c:out value='${userName}'/>";
	        var username2 = "<c:out value='${userName2}'/>";
	        var otherid = "<c:out value='${otherId}'/>";
	        var scheduleid = "<c:out value='${scheduleId}'/>";
	        var datetype = "<c:out value='${dateType}'/>";
	        var startdate = "<c:out value='${startDate}'/>";
	        var enddate = "<c:out value='${endDate}'/>";
	        var content = "<c:out value='${content}'/>";
	        var contentpath = "${contentPath}";
	        var ispublic = "<c:out value='${isPublic}'/>";
	        var importance = "<c:out value='${importance}'/>";
	        var repetition = "<c:out value='${repetition}'/>";
	        if(repetition==" "){
	        	repetition = "";
	        }
	        var scheduletype = "<c:out value='${scheduleType}'/>";
	        var changekey = "<c:out value='${changeKey}'/>";
	        var pattern = "<c:out value='${pattern}'/>";
	        var recurringLabelText = "<c:out value='${recurringLabelText}'/>";
	        var startDateStringOrgin = "<c:out value='${startDateStringOrgin}'/>";
	        var endDateStringOrgin = "<c:out value='${endDateStringOrgin}'/>";
	        var pageFrom = "<c:out value='${pageFrom}'/>";
	        var timecheckstring = "<spring:message code='ezSchedule.t60' />";
	        var companyID = "<c:out value='${companyID}'/>";
	        var deptName = "<c:out value='${deptName}'/>";
	        var deptID = "<c:out value='${deptID}'/>";
	        var hasattach = "<c:out value='${hasAttach}'/>";	        	        
	        var pCompanyAdmin = "<c:out value='${pCompanyAdmin}'/>";
	        var pDeptAdmin = "<c:out value='${pDeptAdmin}'/>";
	        var offSetMin = "<c:out value='${offSetMin}'/>";
	        var useAnyoneEdit = "<c:out value='${useAnyoneEdit}'/>";
	        var repeatCount = "<c:out value='${repeatCount}'/>";
	        var repStartDate = "<c:out value='${repStartDate}'/>";
		    var timeCheck = false;
		    var timeSelect = false;
		    // 2023-08-09 전인하 - 일정관리 > 부서관리자 겸직 권한이 있을 시, 부서관리자 권한이 있는 겸직의 부서 일정 작성/수정 기능 
		    var permissionBasisDeptYN = "<c:out value='${permissionBasisDeptYN}'/>"; // 겸직/사용자 기준 권한부여 옵션 여부
		    var adminDeptListTemp = "<c:out value='${AdminDeptList}'/>"; // 부서관리자 권한이 존재하는 부서 id string
		    var adminDeptList = adminDeptListTemp.split(";").filter(Boolean);
			var chkPublic = "<c:out value='${chkSchedulePublic}'/>"; // 개인일정 작성시 공개/비공개값 설정가능 여부
		    var showtop = "<c:out value='${showtop}'/>";
		    var lang = "<c:out value='${lang}'/>";

		    /* 20203-09-22 한태훈 - 초대 일정 수정시 참석자에게 메일 보내는 용도 */
			var modAttendIdList = [];
			var modAttendName1List = [];
			var modAttendName2List = [];
		    
		    /* 20203-09-22 한태훈 - 초대 일정 수정시 참석자에게 메일 보내는 용도 */
			var modAttendIdList = [];
			var modAttendName1List = [];
			var modAttendName2List = [];
		    
		    window.onload = function () {
		    	
		    	setListOwnerID();
		    	
		        if (scheduleid != "" && otherid == "" && (scheduletype != "1" && scheduletype != "6")) {
		            document.getElementById("1tab2").innerHTML = "<spring:message code='ezSchedule.t1031' />";
		            if (document.getElementById("MsgTo_TR"))
		                document.getElementById("MsgTo_TR").style.display = "none";
		        }

		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        // 상단표시로 바로 작성할 때
                if (showtop == 'Y') {
                    document.getElementById("topcheck").checked = true;
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
		        if (scheduleid != "") {
		            document.getElementById("importantSelect").value = importance;
		            document.getElementById("publicSelect").value = ispublic;	                
	                document.getElementById("HolderWrite").style.display = "none";
	                document.getElementById("receiverTr1").style.display = "none";
	                document.getElementById("receiverTr2").style.display = "none";
	                document.getElementById("HolderWriteTr1").style.display = "none";
	                document.getElementById("HolderWriteTr2").style.display = "none";

                    if (scheduletype != '1') {
                    	if(document.getElementById("HolderEdit2") != null){
							document.getElementById("HolderEdit2").style.display = "none";
						}
                    } else {
						// chkPublic이 OFF일 경우 비공개가 기본값임.
						if (chkPublic == "OFF") {
							document.getElementById("publicSelect").disabled = true;
							document.getElementById("publicSelect").value = "N";
						}
					}

	                /* if (scheduletype == "7") {
		                //document.getElementById("HolderEdit2").style.display = "none";
                    } */ 

		            if (datetype == "1") {
		                document.getElementById("alldaycheck").checked = false;
		                allday_change();
		            } else if (datetype == "3" && pattern == "0") {
		                document.getElementById("alldaycheck").checked = false;
		                allday_change();
		                document.getElementById("periodblock").style.display = "";
		                document.getElementById("repeatblock").style.display = "none";
		                /* 2021-11-25 홍승비 - 일정완료 체크박스 표출에 대응하도록 기간TD의 스타일 조정 */
		                if(document.title == 'Modify'){
		                document.getElementById("periodblockTD").style.width = "40%";
		                }else{
		                document.getElementById("periodblockTD").style.width = "60%";
		                }
		                show_repetition_info();
		            } else if(datetype == "2") {
		            	document.getElementById("alldaycheck").checked = true;
		            	allday_change();
		            }

		            if ($.trim(repetition) != "" && pattern == "1") {
		                show_repetition_info();
		                document.getElementById("repeatinfo").textContent = recurringLabelText;
		                document.getElementById("periodblockTR").style.display = "none";
		            }                   
		        } else if (datetype != ""){ 
		        	if (datetype == "2") {
		                document.getElementById("alldaycheck").checked = true;
		           } 
		                allday_change();
		        } else {
		        	//document.getElementById("alldaycheck").checked = false;
	                allday_change();
		        }

		        document.getElementById("publicSelect").disabled = true;
		        if ((scheduletype == "1" && chkPublic == "ON") || scheduletype == "6")
		            document.getElementById("publicSelect").disabled = false;

		        if (scheduleid == "")
		            ListOwnerID_Change();

		        if (hasattach == "Y") {
		            setAttachFileInfo("${strAttach}");
		        }

		        /*if(ispublic != "") {
		        	document.getElementById("publicSelect").value = ispublic;
		        }*/

		        try{
		            if (document.getElementById("TextTitle").value == "")
		                document.getElementById("TextTitle").focus();
		        }
		        catch (e) { }

		        g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "jikwe": new Array(), "phone": new Array() };
     
		        /* for (var i = 0; i < attendantname.split("&").length - 1; i++) {
		            g_attendant["id"][i] = attendantemail.split("&")[i];
		            g_attendant["name1"][i] = attendantname.split("&")[i];
		        } */
		        
		        if (document.getElementById("iReFlag")) {
		        	tmpReFlag = document.getElementById("iReFlag").value;
		        }
		        
		        //수정시 저장된 일정시간으로 설정
		         if (scheduleid != "") {
		        setDate();
		         }
		    }

		    window.onresize = function () {
		        switch (pSelectTab) {
		            case "schedule1":
		                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 395 + "PX";
						mobileDistinction();
		                break;
		            case "schedule2":
		                if (document.getElementById("receiverTr1").style.display == "none" && document.getElementById("HolderEdit2").style.display == "none") {
                            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 305 + "PX";
                        } else if ((document.getElementById("receiverTr1").style.display == "none" && document.getElementById("HolderEdit2").style.display != "none") || document.getElementById("receiverTr1").style.display != "none" && document.getElementById("HolderEdit2").style.display == "none") {
                            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 335 + "PX";
						} else {
                            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 365 + "PX";
                        }
						mobileDistinction();
		                break;
		            case "schedule3":
		                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 335 + "PX";
						mobileDistinction();
		                break;
		        }
		    }
		    
		    window.onbeforeunload = function () {
		        try {
		    		window.opener.openerCalendarMiniView("CalendarMini");	    		
		    		window.opener.openerCalendarMiniDataSource();
		        } catch (e) { console.log(e) }
		        
		        var date = window.opener.selDate;
	    		if(date == "") date = window.opener.nowDay;
		        try {
		    		// 정주환 포틀릿 일정추가후 불변요청
		            window.opener.getScheduleList(date, "P");
		        } catch (e) { console.log(e)}
		        
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

				setDate();
		    });
		    
		    function setDate() {
				var uploadSDate = "${UploadSDate}";
				var sYear = uploadSDate.substring(0, 4);
				var sMonth = uploadSDate.substring(5, 7);
				var sDay = uploadSDate.substring(8, 10);
				var sHour = uploadSDate.substring(11, 13);
				var sMin = uploadSDate.substring(14, 16);
							
				var uploadEDate = "${UploadEDate}";
				var eYear = uploadEDate.substring(0, 4);
				var eMonth = uploadEDate.substring(5, 7);
				var eDay = uploadEDate.substring(8, 10);
				var eHour = uploadEDate.substring(11, 13);
				var eMin = uploadEDate.substring(14, 16);
				
				if(uploadEDate.substring(11, 16) == "00:00") {
					eDay--;
				}
				
		        var SDate = new Date();
		        SDate.setFullYear(sYear, sMonth-1, sDay);
		        SDate.setHours(sHour, sMin, 0, 0);
		        
		        var EDate = new Date();
		        EDate.setFullYear(eYear, eMonth-1, eDay);
		        EDate.setHours(eHour, eMin, 0, 0);
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
		    }
		    
		    var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
		    
		    $(function () {
		        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
		        	closeText: "<spring:message code='main.t3' />",
		            prevText: "<spring:message code='main.t0604' />",
		            nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
		            monthNames: monthStr,
		            monthNamesShort: monthStr,
		            dayNames: dayStr,
		            dayNamesShort: dayStr,
		            dayNamesMin: dayStr,
		            weekHeader: 'Wk',
		            dateFormat: 'yy-mm-dd',
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: 'show',
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });
		    
		    var g_originalHTML = null;
		    function Editor_Complete() {
		        if ((scheduletype == "1" || scheduletype == "6") && $.trim("${content}") != "") {
		            if (g_originalHTML == null) {
		                message.SetEditorContent("${content}")
		                g_originalHTML = message.GetEditorContent();
		            }
		        } else {
		            if ("${contentPath}" != "") {
		                var fullPath = "${contentPath}";
		                message.SetEditorContentURL(fullPath);		                
		            } else {
		            	message.SetEditorContent("");
		            }
		        }
		    }

		    var bool = false;
		    var bool2 = false;
		    var bool3 = false;
		    var pSelectTab = "schedule1";
		    function ChangeTab(obj) {
		        for (var i = 0; i < document.getElementById("tabShecdule").children.length; i++) {
		            document.getElementById("tabShecdule").children[i].style.display = "none";
		        }
		        pSelectTab = obj.getAttribute("divname");
		        document.getElementById(pSelectTab).style.display = "";

		        switch (pSelectTab) {
		            case "schedule1":
		                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 395 + "PX";
		                break;
		            case "schedule2":
		            	if(document.getElementById("HolderEdit2")) {		// 일정 수정 창
	                        if (document.getElementById("receiverTr1").style.display == "none" && document.getElementById("HolderEdit2").style.display == "none") {
	                            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 305 + "PX";
	                        } else if ((document.getElementById("receiverTr1").style.display == "none" && document.getElementById("HolderEdit2").style.display != "none") || document.getElementById("receiverTr1").style.display != "none" && document.getElementById("HolderEdit2").style.display == "none") {
	                            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 335 + "PX";
	                        } else {
	                            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 365 + "PX";
	                        }
		            	}
		            	else {			// 일정 작성 창
		            		if(document.getElementById("receiverTr1").style.display == "none")
		            			document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 305 + "PX";
		            		else
		            			document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 365 + "PX";
		            	}
		                break;
		            case "schedule3":
		                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 335 + "PX";
		                break;
		        }
		    }

		    function DisabledTab() {
		        for (var i = 0; i < document.getElementById("tabShecdule").children.length; i++) {
		            document.getElementById("tabShecdule").children[i].style.display = "none";
		        }
		    }
		    
		    function FieldsAvailable() {
		    }

		    function checkupload() {
		        var isfileup;
		        isfileup = dadiframe.isfileup;
		        if (isfileup) {
		            alert(strLang258);
		            return;
		        }		        
		        
		        /* if (specialChk(document.getElementById("TextLocation").value) || specialChk(document.getElementById("TextTitle").value)) {
		    		alert("<spring:message code='ezResource.special' />");
		    		return;
		    	} */
		        
		        save_schedule(pageFrom);
		    }
		   
		    function Print_onClick() {
		        var printOwner = "";
		        var printAttendant = "";
		        var printIsPublic = "";
		        var printImportance = "";
		        var printRepetition = "";
		        var printDate = "";
		        var printLocation = "";
		        var printTitle = "";
		        var printAttach = "";
		        var printDocument = "";

		        if (scheduleid == "") {
		            printOwner = document.getElementById("ListOwnerID").options[document.getElementById("ListOwnerID").selectedIndex].textContent;
		            printAttendant = document.getElementById("receiverlist").textContent;
		        } else {
		        	if (document.getElementById("LabelOwner")) {
		            	printOwner = document.getElementById("LabelOwner").textContent;
		        	}
		        	if (document.querySelector("#LabelAttendant span")) {
		            	printAttendant = document.querySelector("#LabelAttendant span").textContent;
		        	}
		        }

		        printIsPublic = document.getElementById("publicSelect").options[document.getElementById("publicSelect").selectedIndex].textContent;
		        printImportance = document.getElementById("importantSelect").options[document.getElementById("importantSelect").selectedIndex].textContent.split(" ")[1];
		        printRepetition = document.getElementById("repeatinfo").textContent;

		        if ($.trim(repetition) == "") {
		            if (document.all("alldaycheck").checked == true)
		                printDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " ~ " + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " (" + "<spring:message code='ezSchedule.t280' />";
		            else
		                printDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val() + " ~ " + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
		        } else {
		        	printDate = $("#repeatinfo").text()
		        }

		        printLocation = document.getElementById("TextLocation").value;
		        printTitle = document.getElementById("TextTitle").value;

		        document.getElementById("tempattachdiv").innerHTML = dadiframe.document.getElementById("lstAttachLink").innerHTML;

		        var tmeptr = document.getElementById("tempattachdiv").getElementsByTagName("TR");

		        document.getElementById("printAttach").innerHTML = "";
		        for (var i = 1; i < tmeptr.length; i++) {
		            var span = document.createElement("SPAN");
		            var input = document.createElement("INPUT");
		            var oDiv = document.createElement("DIV");
		            input.type = "checkbox";

		            var img = document.createElement("IMG");
		            img.src = "/images/email/mail_006.gif";

		            var a = document.createElement("A");

		            if (CrossYN()) {
		                var filename = GetChildNodes(tmeptr[i])[1].textContent;
		                var filesize = GetChildNodes(tmeptr[i])[2].textContent;
		            } else {
		                var filename = GetChildNodes(tmeptr[i])[1].innerText;
		                var filesize = GetChildNodes(tmeptr[i])[2].innerText;
		            }
		            a.innerHTML = filename + " (" + filesize + ")";

		            var br = document.createElement("BR");

		            oDiv.appendChild(input);
		            span.appendChild(oDiv);
		            span.appendChild(img);
		            span.appendChild(a);
		            span.appendChild(br);

		            document.getElementById("printAttach").appendChild(span);
		        }
		        printAttach = document.getElementById("printAttach").innerHTML;

		        printDocument = message.GetEditorContent();

		        var params = { 'type': 'NEW', 'printOwner': printOwner, 'printAttendant': printAttendant, 'printIsPublic': printIsPublic, 'printImportance': printImportance, 'printRepetition': printRepetition, 'printDate': printDate, 'printLocation': printLocation, 'printTitle': printTitle, 'printAttach': printAttach, 'printDocument': printDocument };
		        post_to_url("/ezSchedule/scheduleContentsPrint.do", params, "post");
		    }

	        function post_to_url(path, params, method) {
	            method = method || "post";

	            var pheight = window.screen.availHeight;
	            var conHeight = pheight * 0.8;
	            var pwidth = window.screen.availWidth;
	            var conWidth = pwidth * 0.8;
	            if (conWidth > 790) {
	                conWidth = 790;
	            }
	            if (conHeight > 670) {
	            	conHeight = 670;
	            }
	            var pTop = (pheight - conHeight) / 2;
	            var pLeft = (pwidth - 790) / 2;

	            var title = "Print";
	            var status = "toolbar=no,directories=no,scrollbars=no,resizable=no,status=no,menubar=no,width=" + conWidth + "px, height=" + conHeight + "px, top=" + pTop.toString() + ",left=" + pLeft.toString();
	            window.open("", title, status);

	            var form = document.createElement("form");
	            form.setAttribute("method", method);
	            form.setAttribute("target", title);
	            form.setAttribute("action", path);
	            
	            for (var key in params) {
	                var hiddenField = document.createElement("input");
	                hiddenField.setAttribute("type", "hidden");
	                hiddenField.setAttribute("name", key);
	                hiddenField.setAttribute("value", params[key]);
	                form.appendChild(hiddenField);
	            }
	            document.body.appendChild(form);
	            form.submit();
	        }
	        
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
			
	        function bodydragover(evt) {
		        evt.dataTransfer.dropEffect = "none";
		        evt.stopPropagation();
		        evt.preventDefault();
		    }
	        
	        function KeEventControl(obj) {
	            if ((window.event.keyCode >= 48 && window.event.keyCode <= 57) || (window.event.keyCode >= 96 && window.event.keyCode <= 105)) {
	                return false;
	            }
	            else obj.value = obj.value.replace(/[\a-zㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
	        }
	        
	        /* 2021-11-25 홍승비 - 반복일정 일정완료 체크박스 제어 함수 (체크박스는 하나만 체크 가능) */
	        function completeFG_change(objID) {
	        	if (objID == "completeFG_one") { // 단일 일정
	        		document.getElementById("completeFG_repOne").checked = false;
	        		document.getElementById("completeFG_repAll").checked = false;
	        	} else if (objID == "completeFG_repOne") { // 현재 반복일정
	        		document.getElementById("completeFG_one").checked = false;
	        		document.getElementById("completeFG_repAll").checked = false;
	        	} else if (objID == "completeFG_repAll") { // 전체 반복일정
	        		document.getElementById("completeFG_one").checked = false;
	        		document.getElementById("completeFG_repOne").checked = false;
	        	}
	        }
	        
			function mobileDistinction() {
   				var  userAgent = navigator.userAgent.toLowerCase();
				
				if (/iphone|ipod|ipad|android.*mobile/i.test(userAgent) || /tablet|ipad|android/i.test(userAgent) || navigator.maxTouchPoints > 4) {
					if (window.innerWidth > window.innerHeight) {
						document.getElementById("EdtorSize").style.height = 436 + "PX";
					}
				}
			}
			
			function setListOwnerID() {
				var schOwnInfoList = "<c:out value='${schOwnInfoListToJson}'/>";
				var decodedString = new DOMParser().parseFromString(schOwnInfoList, "text/html").documentElement.textContent;
				decodedString = JSON.parse(decodedString);
				
			    var selElem = document.getElementById("ListOwnerID");

			    while (selElem.firstChild) {
			    	selElem.removeChild(selElem.firstChild);
			    }

			    for (var i = 0; i < decodedString.length; i++) {
			        var item = decodedString[i];
			        var scheduleTag = "";
			        
			        if (item.scheduleType == 1) {
			        	scheduleTag = "<spring:message code='ezSchedule.t372'/>" + " ";
			        } else if (item.scheduleType == 2) {
			        	scheduleTag = "<spring:message code='ezSchedule.t373'/>" + " ";
			        } else if (item.scheduleType == 3) {
			        	scheduleTag = "<spring:message code='ezSchedule.t374'/>" + " ";
			        } else if (item.scheduleType == 7) {
			        	scheduleTag = "<spring:message code='ezSchedule.t375'/>" + " ";
			        } else if (item.scheduleType == 10) {
			        	scheduleTag = "<spring:message code='ezSchedule.lyj14'/>" + " - ";
			        	
			        }
			        
			        var value = item.scheduleType + ";;" + item.ownerId + ";;" + item.ownerName + ";;" + item.ownerName2;
			        var text = scheduleTag + (lang == 1 ? item.ownerName : item.ownerName2);
			        
			        var option = document.createElement("option");
			        option.value = value;
			        option.textContent = text;
			        
			        selElem.appendChild(option);
			    }
			}
	    </script>
	</head>

	<body class="popup scheduleWrite" style="overflow:hidden;">
	    <form method="post">
	        <div id="main_body">
	            <table id="normalScreen" class="layout">
	                <tr>
	                    <td style="height: 20px">
	                        <div id="menu">
	                            <ul id="menuTable">	
	                                <li><span onclick="checkupload()"><spring:message code='ezSchedule.t157'/></span></li>
	                                <%-- <c:if test="${scheduleId == ''}">
	                                	<li><span onclick="check_name()"><spring:message code='ezSchedule.t53'/></span></li>
									</c:if> --%>
	                                <li><span class="icon16 popup_icon16_print" onclick="Print_onClick()"></span></li>
	                            </ul>
	                            <ul style="float:right;margin-right:50px">        
	                                <li id="menuTable" class="sel" style="background: none; border: none;">	
	                                    <select id="importantSelect" name="importantSelect">
	                                        <option value='1'><spring:message code='ezSchedule.t310'/> <spring:message code='ezSchedule.t325'/></option>
	                                        <option value='2' selected><spring:message code='ezSchedule.t310'/> <spring:message code='ezSchedule.t326'/></option>
	                                        <option value='3'><spring:message code='ezSchedule.t310'/> <spring:message code='ezSchedule.t327'/></option>
	                                    </select>	
	                                </li>
	                                <li id="menuTable" class="sel" style="background: none; border: none;">	
	                                    <select id="publicSelect" name="publicSelect">
	                                        <option value='Y'><spring:message code='ezSchedule.t359'/></option>
	                                        <option value='N' selected><spring:message code='ezSchedule.t360'/></option>
	                                    </select>	
	                                </li>	              
	                            </ul>
	                        </div>
	                        <div id="close">
	                            <ul>
	                                <li><span onclick="window.close()"></span></li>
	                            </ul>
	                        </div>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="height: 20px">
	                        <div class="portlet_tabpart03">
	                            <div class="portlet_tabpart03_top" id="tab1">
	                                <p id="show1"><span divname="schedule1" id="1tab1"><spring:message code='ezSchedule.t214'/></span></p>
	                                <p id="show2"><span divname="schedule2" id="1tab2"><spring:message code='ezSchedule.t9990002'/></span></p>
	                                <c:if test="${scheduleId == '' && checkResourceTab == true && !isDotNetIntegration}">
		                                <p id="show3"><span divname="schedule3" id="1tab3"><spring:message code='ezSchedule.t1032'/></span></p>
		                            </c:if> 
	                            </div>
	                        </div>
	                        <div id="tabShecdule">
	                            <!--일정작성-->
	                            <div id="schedule1">
	                                <table class="content">
	                                	<c:if test="${scheduleId != ''}">
                                        <tr id="HolderEdit">
                                            <th><spring:message code='ezSchedule.t363'/></th>
                                            <td colspan="3" id="LabelOwner">
                                                ${strLabelOwner}
                                                <div class="custom_checkbox">
	                                                <input type="checkbox" id="topcheck" value="1" style="margin-left:20px;"> <label for="topcheck"><spring:message code='ezSchedule.kwc01'/></label>
                                                </div>
                                            </td>
                                        </tr>
                                        </c:if>
                                        <tr id="HolderWrite">
                                            <th><spring:message code='ezSchedule.t363'/></th>
                                            <td colspan="3">
                                            	<select name="ListOwnerID" id="ListOwnerID" onchange="ListOwnerID_Change()" style="height:24px;"></select>
                                                <div class="custom_checkbox">
	                                            	<input type="checkbox" id="topcheck" value="1"> <label for="topcheck"><spring:message code='ezSchedule.kwc01'/></label>
                                                </div>
                                            </td>
                                        </tr>
	                                    <tr>
	                                        <th><spring:message code='ezSchedule.t365'/></th>
	                                        <td colspan="3">
	                                        	<input name="TextLocation" type="text" maxlength="50" id="TextLocation" style="width:100%;" value="<c:out value='${scheduleInfo.location}' />" />
	                                        </td>
	                                    </tr>
	                                    <tr>
	                                        <th><spring:message code='ezSchedule.t366'/></th>
	                                        <td colspan="3">
	                                        	<input name="TextTitle" type="text" maxlength="100" id="TextTitle" style="width:100%;" value="<c:out value='${scheduleInfo.title}' />" />
	                                        </td>
	                                    </tr>
	                                    <tr id="periodblockTR">
	                                        <th><spring:message code='ezSchedule.t368'/></th>
	                                        <td id="periodblockTD" <c:if test="${scheduleId != ''}">style="width:80%;"</c:if>>
	                                        	<span id="periodblock">
		                                        	<div class="custom_checkbox">
		                                            	<input name="checkbox" type="checkbox" id="alldaycheck" onclick="allday_change()" value="1">
														<label for="alldaycheck"><spring:message code='ezSchedule.t369'/></label>
		                                            </div>
	                                           		<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
	                                           		<input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);" onmousedown="return false"/>
	                                            	~
	                                            	<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
	                                            	<input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" onkeypress="return KeEventControl(this);" onkeydown="return KeEventControl(this);" onkeyup="return KeEventControl(this);" onmousedown="return false"/>
	                                            </span>
	                                            <span id="repeatblock" style="DISPLAY: none"><spring:message code='ezSchedule.t343'/></span>
	                                        </td>
	                                        <%-- 2021-11-23 홍승비 - 일정완료 체크박스 추가 (단일, 반복일정 대응) --%>
	                                        <c:if test="${scheduleId != ''}">
											<th><spring:message code='ezSchedule.HSBCp01'/></th>
	                                        <td>
												<%-- 단일일정 수정 시 --%>
	                                        	<span id="completeFG_oneSpan" <c:if test="${dateType != '1' && dateType != '2'}">style="display:none;"</c:if>>
													<div class="custom_checkbox">	
	                                            		<input name="checkbox" type="checkbox" id="completeFG_one" <c:if test="${completeFG == 'Y' && dateType != '3'}">checked</c:if>>
														<label for="completeFG_one"><spring:message code='ezSchedule.HSBCp02'/></label>
	                                        		</div>
	                                            </span>
	                                            <%-- 반복일정 수정 시 (2021-11-25 기준으로 수정 시 pattern값은 0으로만 전달됨. 반복일정 수정 시 단일/전체 선택 기능이 없기 때문) --%>
                                            	<span id="completeFG_repOneSpan" <c:if test="${dateType != '3' || pattern != '0'}">style="display:none;"</c:if>>
                                            		<div class="custom_checkbox">
                                            			<input name="checkbox" type="checkbox" id="completeFG_repOne" onclick="completeFG_change(this.id)" <c:if test="${completeFG == 'Y' && isAllRep == 'N' && dateType == '3'}">checked</c:if>>
                                            		</div>
                                            		<spring:message code='ezSchedule.HSBCp03'/>
                                            	</span>
                                            	<span id="completeFG_repAllSpan" <c:if test="${dateType != '3' || pattern != '0'}">style="display:none;"</c:if>>
                                            		<div class="custom_checkbox">
                                            			<input name="checkbox" type="checkbox" id="completeFG_repAll" onclick="completeFG_change(this.id)" <c:if test="${completeFG == 'Y' && isAllRep == 'Y' && dateType == '3'}">checked</c:if>>
                                            		</div>
                                            		<spring:message code='ezSchedule.HSBCp04'/>
                                            	</span>
	                                        </td>
	                                        </c:if>
	                                    </tr>
	                                </table>
	                            </div>
	                            <!--일정반복-->
	                            <div id="schedule2" style="display: none">
	                                <table class="content">
	                                    <tr id="repeateTR">
	                                        <th><a class="imgbtn"><span onclick="config_repeat()"><spring:message code='ezSchedule.t367'/></span></a></th>
	                                        <td class="pos1">
	                                            <div id="repeatinfo" style="height: 100%; width: 100%; vertical-align: middle; display: table-cell;">&nbsp;</div>
	                                        </td>
	                                        <td class="pos2"></td>
	                                    </tr>
	                                    <c:if test="${scheduleId != '' && scheduleType != '7'}">
                                        <tr id="HolderEdit2">
                                            <th><spring:message code='ezSchedule.t163'/></th>
                                            <td colspan="2">
                                            	<div style="overflow-y: auto; height: 100%; width: 100%; vertical-align: middle; display: table-cell;" id="LabelAttendant">                                                
													<c:forEach var="item" items="${attendantList}" varStatus="status">
														<script>
															modAttendIdList.push('${item.attendantId}');
															modAttendName1List.push('${item.attendantName}');
															modAttendName2List.push('${item.attendantName2}');
														</script>                                		  		
			                                	 		<span title="<spring:message code='ezSchedule.t162'/>" style="cursor:pointer" onclick="show_personinfo('${item.attendantId}')">
			                                	 			<c:if test="${lang == '1'}"><c:out value="${item.attendantName}" /></c:if>
			                                	 			<c:if test="${lang != '1'}"><c:out value="${item.attendantName2}" /></c:if>
		                                    				<c:if test="${item.status == '1'}">(<spring:message code='ezSchedule.t251' />)</c:if>
			                                				<c:if test="${item.status == '2'}">(<spring:message code='ezSchedule.t168' />)</c:if>
			                                				<c:if test="${item.status == '3'}">(<spring:message code='ezSchedule.t169' />)</c:if>
			                                				<c:if test="${item.status != '1' && item.status != '2' && item.status != '3'}">(<spring:message code='ezSchedule.t166' />)</c:if>
			                                				<c:if test="${fn:length(attendantList) != status.count}">,</c:if>	                                				                                		
		                                    			</span>
			                                		</c:forEach>
			                                	</div>	
											</td>
                                        </tr>
                                        </c:if>
                                        <tr id="receiverTr1">
                                            <th rowspan="2"><a id="imgbutton" class="imgbtn"><span id="clickbtn" onclick="manage_attendant()"><spring:message code='ezSchedule.t364'/></span></a></th>
                                            <td class="pos1">
                                                <input name="Input" id="receiverinput" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" onkeyup="return on_keydown(event)">
											</td>
                                            <td class="pos2"></td>
                                        </tr>
                                        <tr id="receiverTr2">
                                            <td colspan="2">
                                                <div id="receiverlist" style="OVERFLOW-Y: auto; HEIGHT: 20px"></div>
                                            </td>
                                        </tr>
	                                </table>
	                            </div>
	                            <!--자원설정-->
	                            <div id="schedule3" style="display: none">
	                                <table class="content">
                                        <tr ID="HolderWriteTr1">
                                            <th><a id="resourcebutton" class="imgbtn"><span id="resourcebtn" onclick="manage_resource()"><spring:message code='ezSchedule.t1101'/></span></a></th>
                                            <td class="pos1">
                                                <div id="resourcelist" style="height: 100%; width: 100%; vertical-align: middle; display: table-cell;"></div>
                                            </td>
                                            <td class="pos2"></td>
                                        </tr>
                                        <tr ID="HolderWriteTr2">
                                            <th><a class="imgbtn"><span onclick="config_repeat_resource()"><spring:message code='ezSchedule.t1102'/></span></a></th>
                                            <td class="pos1">
                                                <div id="resourcerepeatinfo" style="height: 100%; width: 100%; vertical-align: middle; display: table-cell;">&nbsp;</div>
                                            </td>
                                            <td class="pos2"></td>
                                        </tr>
	                                </table>
	                            </div>
	                        </div>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="vertical-align:top;height:100%;" id="EdtorSize">
		                    <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding:0; height:100%; width:100%; overflow:auto; margin-top:-1px"></iframe>
	                    </td>
	                </tr>
	                <tr>
	                    <td>
	                        <iframe id="dadiframe" name="dadiframe" style="width:100%;height:100%;border:0px" src="/ezSchedule/scheduleDragAndDrop.do"></iframe>
	                    </td>
	                </tr>
	            </table>
	        </div>
	        <div id="printScreen" style="DISPLAY: none">
	            <table cellspacing="0" cellpadding="0">
	                <tr>
	                    <td width="80"><spring:message code='ezSchedule.t363'/></td>
	                    <td>
	                        <div id="printOwner"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <td><spring:message code='ezSchedule.t163'/></td>
	                    <td>
	                        <div id="printAttendant"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <td><spring:message code='ezSchedule.t309'/></td>
	                    <td>
	                        <div id="printIsPublic"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <td><spring:message code='ezSchedule.t310'/></td>
	                    <td>
	                        <div id="printImportance"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <td><spring:message code='ezSchedule.t367'/></td>
	                    <td>
	                        <div id="printRepetition"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <td><spring:message code='ezSchedule.t318'/></td>
	                    <td>
	                        <div id="printDate"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <td><spring:message code='ezSchedule.t273'/></td>
	                    <td>
	                        <div id="printLocation"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <td><spring:message code='ezSchedule.t272'/></td>
	                    <td>
	                        <div id="printTitle"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <td width="60"><spring:message code='ezSchedule.t319'/></td>
	                    <td width="420">
	                        <div id="printAttach"></div>
	                    </td>
	                </tr>
	                <tr>
	                    <td colspan="2">
	                        <div align="left" id="printDocument" style="PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; WIDTH: 100%; PADDING-TOP: 5px"></div>
	                    </td>
	                </tr>
	            </table>                
	        </div>
	        <div id="tempattachdiv" style="display:none"></div>
	        <script type="text/javascript">
	            selToggleList(document.getElementById("menu"), "ul", "li", "0");
	            Tab1_NewTabIni("tab1");
	        </script>
		    <script type="text/javascript">
		        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 395 + "PX";
				mobileDistinction();
		    </script>
	    </form>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>
