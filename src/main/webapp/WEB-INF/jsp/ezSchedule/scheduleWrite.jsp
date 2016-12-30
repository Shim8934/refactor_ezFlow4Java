<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezSchedule.t357' /></title>
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
        <link rel="stylesheet" href="/css/ezSchedule/Tab.css" type="text/css" />
	    
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
	    <script type="text/javascript" src="/js/ezSchedule/schedule_write_Cross.js?ver=1.9"></script>
		<script type="text/javascript" src="/js/ezSchedule/Calendar/TabMenu.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>

		<!-- data picker-->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>

		<!-- time picker-->
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
        <c:if test="${isCrossBrowser != true}">
        <script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
        </c:if>  

	    <script type="text/javascript">
		    var userId			= "${userInfo.id}";
		    var userName		= "${userInfo.displayName1}";
		    var userName2		= "${userInfo.displayName2}";

		    var scheduleId		= "${scheduleId}";
		    var scheduleType	= "${scheduleType}";
		    var dateType		= "${scheduleInfo.dateType}";
		    var hasAttach		= "${hasAttach}";
		    var strAttendant	= "${strAttendant}";
		    var strAttach 		= "${strAttach}";
		    var deptID			= "${userInfo.deptID}";
		    var deptName		= "${userInfo.deptName}";
		    var companyID		= "${userInfo.companyID}";

		    var repetition		= "${repetition}";
		    var pattern			= "${pattern}";
		    var changeKey		= "${changeKey}";
		    //		    var strLabelOwner	= "${strLabelOwner}";

		    var otherId = "${otherId}";
		    var startDate = "${startDate}";
		    var endDate = "${endDate}";
		    var content = "${content}";
		    var contentPath = "${contentPath}";
		    var isPublic = "${isPublic}";
		    var importance = "${importance}";
		    var repetitionDel = "${repetitionDel}";
		    var recurringLabelText = "${recurringLabelText}";
		    var startDateStringOrgin = "${startDateStringOrgin}";
		    var endDateStringOrgin = "${endDateStringOrgin}";
		    var pageFrom = "${pageFrom}";
		    var timeCheckString = "<spring:message code='ezSchedule.t60' />";
		    var deptName = "${userinfo.DeptName}";
		    var attendantName = "${attendantName}";
		    var attendantEmail = "${attendantEmail}";
		    var useExchangePims = "${useExchangePims}";
		    var noneActiveX = "${noneActiveX}";
		    var pCompanyAdmin = "${companyAdmin}";
		    var pDeptAdmin = "${deptAdmin}";
		    var use_exchange_pims = "${useExchange}";
		    
		    document.onselectstart = function () { return false; };
		    
		    window.onload = function () {
		        if (scheduleId != "" && otherId == "" && (scheduleType != "1" && scheduleType != "6")) {
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

		        if (scheduleId != "") {
		            document.getElementById("importantSelect").value = importance;
		            document.getElementById("publicSelect").value = ispublic;
	                document.getElementById("HolderEdit").style.display = "visible";
	                document.getElementById("HolderEdit2").style.display = "visible";
	                document.getElementById("HolderWrite").style.display = "none";
	                document.getElementById("receiverTr1").style.display = "none";
	                document.getElementById("receiverTr2").style.display = "none";
	                document.getElementById("HolderWriteTr1").style.display = "none";
	                document.getElementById("HolderWriteTr2").style.display = "none";

	                if (scheduleType == "7")
                    {
		                document.getElementById("HolderEdit2").style.display = "none";
                    }

		            if (dateType == "1") {
		                document.getElementById("alldaycheck").checked = false;
		                allday_change();
		            }
		            else if (dateType == "3" && pattern == "0") {
		                document.getElementById("alldaycheck").checked = false;
		                allday_change();
		                document.getElementById("periodblock").style.display = "";
		                document.getElementById("repeatblock").style.display = "none";
		                show_repetition_info();
		            }

		            if (repetition != "" && pattern == "1") {
		                show_repetition_info();
		                document.getElementById("repeatinfo").textContent = recurringLabelText;
		                document.getElementById("periodblockTR").style.display = "none";
		            }
		            
                    // 참석자 정보를 가져온다.
                    if ("${scheduleInfo}" != null && "${scheduleInfo.hasAttendant}" == "Y")
                    {
						document.getElementById("LabelAttendant").textContent = strAttendant;
                    }

                    // 첨부 정보를 가져온다.
                    if (hasAttach == "Y")
                    {
                    	setAttachFileInfo(strAttach);
                    }
                    
                    if ("${scheduleInfo.dateType}" == "3" && "${scheduleInfo.pattern}" == "1")
                    {
    	                document.getElementById("HolderRepetition").style.display = "visible";                    	
                    }
                    
    		        document.getElementById("TextLocation").Text = "${scheduleInfo.location}";
    		        document.getElementById("TextTitle").Text = "${scheduleInfo.title}";
    		        document.getElementById("LabelOwner").Text = "${strLabelOwner}";
		        }	
		        // scheduleId == ""
		        else
		        { 
		        	if (dateType == "1") {
		                document.getElementById("alldaycheck").checked = false;
		                allday_change();
		            }

		        	var userName, deptName, compName;
		        	if ("${userInfo.primary}" == "1")
	        		{
	        			userName = "${userInfo.displayName1}";
	        			deptName = "${userInfo.deptName1}";
	        			compName = "${userInfo.companyName1}";
	        		}
		        	else
	        		{
	        			userName = "${userInfo.displayName2}";
	        			deptName = "${userInfo.deptName2}";
	        			compName = "${userInfo.companyName2}";
	        		}
		        	
		        	var optUser = document.createElement("option");
		        	optUser.value = "1" + ";;" + "${userInfo.id}";
		        	optUser.innerHTML = "<spring:message code='ezSchedule.t372'/>" + userName;
		        	document.getElementById("ListOwnerID").appendChild(optUser);
		        	
		        	var optDept = document.createElement("option");
		        	optDept.value = "2" + ";;" + "${userInfo.deptID}";
		        	optDept.innerHTML = "<spring:message code='ezSchedule.t373'/>" + deptName;
		        	document.getElementById("ListOwnerID").appendChild(optDept);
		        	
		        	var optComp = document.createElement("option");
		        	optComp.value = "3" + ";;" + "${userInfo.companyID}";
		        	optComp.innerHTML ="<spring:message code='ezSchedule.t374'/>" + compName;
		        	document.getElementById("ListOwnerID").appendChild(optComp);
		        	
                    // 20110408 본부 일정은 표준이 아니므로 제외
//		        	var optHead = document.createElement("option");
//		        	optHead.value = "4" + ";;" + "${userInfo.companyID}";
//		        	optHead.innerHTML ="<spring:message code='ezSchedule.t995'/>" + userInfo.HQ;
//		        	document.getElementById("ListOwnerID").appendChild(optHead);

					<c:forEach items="${groupList}" var = "item" >
			        	var optGroup = document.createElement("option");
			        	optGroup.value = "3" + ";;" + "${item.groupId}";
			        	optGroup.innerHTML ="<spring:message code='ezSchedule.t375'/>" + "${item.groupName}";
			        	document.getElementById("ListOwnerID").appendChild(optGroup);
					</c:forEach>
		        }

		        document.getElementById("publicSelect").disabled = true;
		        if (scheduleType == "1" || scheduleType == "6")
		            document.getElementById("publicSelect").disabled = false;

		        if (scheduleId == "")
		            ListOwnerID_Change();

		        if (hasAttach == "Y") {
		            setAttachFileInfo(strAttach);
		        }

		        try{
		            if (document.getElementById("TextTitle").value == "")
		                document.getElementById("TextTitle").focus();
		        }
		        catch (e) { }

		        g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "jikwe": new Array(), "phone": new Array() };

		        var idx = 0;
				<c:forEach items="${attendantList}" var = "item" >
		            g_attendant["id"][i] = "${item.attendantId}";
		            g_attendant["name1"][i] = "${item.attendantName}";
					idx += 1;
				</c:forEach>
//		        for (var i = 0; i < attendantname.split("&").length - 1; i++) {
//		            g_attendant["id"][i] = attendantemail.split("&")[i];
//		            g_attendant["name1"][i] = attendantname.split("&")[i];
//		        }
		    }

		    // pSelectTab이 어디서 왔는지 확인해야 한다.
		    window.onresize = function () {
		        switch (pSelectTab) {
		            case "schedule1":
		                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 395 + "PX";
		                break;
		            case "schedule2":
		                if(document.getElementById("receiverTr1").style.display == "none")
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 305 + "PX";
		                else
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 365 + "PX";
		                break;
		            case "schedule3":
		                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 335 + "PX";
		                break;
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
		        var SDate = new Date("${uploadSDate}");
		        SDate.setHours(SDate.getHours() - 9);
		        var EDate = new Date("${uploadEDate}");
		        EDate.setHours(EDate.getHours() - 9);
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

		    if ("${userInfo.lang}" == "1") {
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
		    
		    var g_originalHTML = null;
		    function DocumentComplete() {
		        if ((scheduleType == "1" || scheduleType == "6") && "${content}" != "") {
		            if (g_originalHTML == null) {
		                message.SetEditorContent("${content}")
		                g_originalHTML = message.GetEditorContent();
		            }
		        } else {
		            if ("${contentPath}" != "") {
		                var fullPath = "${contentPath}";
		                message.SetEditorContentURL(fullPath);
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
		                if (document.getElementById("receiverTr1").style.display == "none")
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 305 + "PX";
		                else
		                    document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 365 + "PX";
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
		        save_schedule();
		    }
		    
		    // 구현 필요
		    function Editor_Complete() {
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

		        if (scheduleId == "") {
		            printOwner = document.getElementById("ListOwnerID").options[document.getElementById("ListOwnerID").selectedIndex].textContent;
		            printAttendant = document.getElementById("receiverlist").textContent;
		        }
		        else {
		            printOwner = document.getElementById("LabelOwner").textContent;
		            printAttendant = document.getElementById("LabelAttendant").textContent;
		        }

		        printIsPublic = document.getElementById("publicSelect").options[document.getElementById("publicSelect").selectedIndex].textContent;
		        printImportance = document.getElementById("importantSelect").options[document.getElementById("importantSelect").selectedIndex].textContent;
		        printRepetition = document.getElementById("repeatinfo").textContent;

		        if (repetition == "") {
		            if (document.all("alldaycheck").checked == true)
		                printDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " ~ " + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " (" + "<spring:message code='ezSchedule.t280' />";
		            else
		                printDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val() + " ~ " + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
		        }
		        else
		            printDate = "<spring:message code='ezSchedule.t343' />";

		        printLocation = document.getElementById("TextLocation").value;
		        printTitle = document.getElementById("TextTitle").value;

		        document.getElementById("tempattachdiv").innerHTML = dadiframe.document.getElementById("lstAttachLink").innerHTML;

		        var tmeptr = document.getElementById("tempattachdiv").getElementsByTagName("TR");

		        document.getElementById("printAttach").innerHTML = "";
		        for (var i = 1; i < tmeptr.length; i++) {
		            var span = document.createElement("SPAN");
		            var input = document.createElement("INPUT");
		            input.type = "checkbox";

		            var img = document.createElement("IMG");
		            img.src = "/images/email/mail_006.gif";

		            var a = document.createElement("A");

		            if (CrossYN()) {
		                var filename = GetChildNodes(tmeptr[i])[1].textContent;
		                var filesize = GetChildNodes(tmeptr[i])[2].textContent;
		            }
		            else {
		                var filename = GetChildNodes(tmeptr[i])[1].innerText;
		                var filesize = GetChildNodes(tmeptr[i])[2].innerText;
		            }
		            a.innerHTML = filename + " (" + filesize + ")";

		            var br = document.createElement("BR");

		            span.appendChild(input);
		            span.appendChild(img);
		            span.appendChild(a);
		            span.appendChild(br);

		            document.getElementById("printAttach").appendChild(span);
		        }
		        printAttach = document.getElementById("printAttach").innerHTML;

		        printDocument = message.GetEditorContent();

		        var params = { 'type': 'NEW', 'printOwner': printOwner, 'printAttendant': printAttendant, 'printIsPublic': printIsPublic, 'printImportance': printImportance, 'printRepetition': printRepetition, 'printDate': printDate, 'printLocation': printLocation, 'printTitle': printTitle, 'printAttach': printAttach, 'printDocument': printDocument };
		        post_to_url("schdule_ContentsPirnt.aspx", params, "post");
		    }

	        function post_to_url(path, params, method) {
	            method = method || "post";

	            var pheight = window.screen.availHeight;
	            var conHeight = pheight * 0.8;
	            var pwidth = window.screen.availWidth;
	            var conWidth = pwidth * 0.8;
	            if (conWidth > 890)
	                conWidth = 890;
	            var pTop = (pheight - conHeight) / 2;
	            var pLeft = (pwidth - 890) / 2;

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
	    </script>
	</head>

	<body class="popup" style="overflow:hidden;">
	    <form method="post">
	        <div id="main_body">
	            <table id="normalScreen" class="layout">
	                <tr>
	                    <td style="height: 20px">
	                        <div id="menu">
	                            <ul id="menuTable">
	
	                                <li><span onclick="checkupload()"><spring:message code='ezSchedule.t358'/></span></li>
	                                <c:if test="${scheduleId == ''}">
	                                	<li><span onclick="check_name()"><spring:message code='ezSchedule.t53'/></span></li>
									</c:if>
	                                <li><span onclick="Print_onClick()"><spring:message code='ezSchedule.t217'/></span></li>
	                                <li class="bar" style="background: none; border: 0; padding-left: 0; padding-right: 0; cursor: default; color: #fff; padding-top: 4px;">
	                                    <img src="/images/pbar.gif"><spring:message code='ezSchedule.t310'/></li>
	                                <li id="menuTable" class="sel" style="background: none; border: none; padding-top: 4px; padding-right: 4px;">
	
	                                    <select id="importantSelect" name="importantSelect">
	                                        <option value='1'><spring:message code='ezSchedule.t325'/></option>
	                                        <option value='2' selected><spring:message code='ezSchedule.t326'/></option>
	                                        <option value='3'><spring:message code='ezSchedule.t327'/></option>
	                                    </select>
	
	                                </li>
	                                <li class="bar" style="margin: 1 0 0 0; background: none; border: 0; padding-left: 0; padding-right: 0; cursor: default; color: #fff; padding-top: 4px;">
	                                    <img src="/images/pbar.gif"><spring:message code='ezSchedule.t309'/></li>
	                                <li id="menuTable" class="sel" style="background: none; border: none; padding-top: 4px;">
	
	                                    <select id="publicSelect" name="publicSelect">
	                                        <option value='Y'><spring:message code='ezSchedule.t359'/></option>
	                                        <option value='N' selected><spring:message code='ezSchedule.t360'/></option>
	                                    </select>
	
	                                </li>
	                                <!--
	              <asp:PlaceHolder ID="HolderRepetition" runat="server" Visible="false">
	                <li><span onClick="restore_deleted()" title="<spring:message code='ezSchedule.t361'/>"><spring:message code='ezSchedule.t362'/></span></li>
	              </asp:PlaceHolder>
	              -->
	                            </ul>
	                        </div>
	                        <div id="close">
	                            <ul>
	                                <li><span onclick="window.close()"><spring:message code='ezSchedule.t16'/></span></li>
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
	                                <c:if test="${scheduleId == ''}">
		                                <p id="show3"><span divname="schedule3" id="1tab3"><spring:message code='ezSchedule.t1032'/></span></p>
		                            </c:if> 
	                            </div>
	                        </div>
	                        <div id="tabShecdule">
	                            <!--일정작성-->
	                            <div id="schedule1">
	                                <table class="content">
                                        <tr id="HolderEdit" style="display: none">
                                            <th><spring:message code='ezSchedule.t363'/></th>
                                            <td colspan="2">
                                                <span ID="LabelOwner" style="OVERFLOW-Y: auto; PADDING-TOP: 2px height:19px;"></span></td>
<!--                                                 <asp:Label ID="LabelOwner" Style="OVERFLOW-Y: auto; PADDING-TOP: 2px" runat="server" Height="19"></asp:Label></td> -->
                                        </tr>
	
                                        <tr id="HolderWrite">
                                            <th><spring:message code='ezSchedule.t363'/></th>
                                            <td colspan="2">
                                            	<select name="ListOwnerID" id="ListOwnerID" onchange="ListOwnerID_Change()" style="height:20px;"></select></td>
                                        </tr>

	                                    <tr>
	                                        <th><spring:message code='ezSchedule.t365'/></th>
	                                        <td colspan="2">
	                                        	<input name="TextLocation" type="text" maxlength="50" id="TextLocation" style="width:98%;" /></td>
	                                    </tr>
	                                    <tr>
	                                        <th><spring:message code='ezSchedule.t366'/></th>
	                                        <td colspan="2">
	                                        	<input name="TextTitle" type="text" maxlength="100" id="TextTitle" style="width:98%;" /></td>
	                                    </tr>
	                                    <tr id="periodblockTR">
	                                        <th><spring:message code='ezSchedule.t368'/></th>
	                                        <td colspan="2"><span id="periodblock">
	                                            <input name="checkbox" type="checkbox" id="alldaycheck" onclick="allday_change()" value="1" checked>
	                                             <spring:message code='ezSchedule.t369'/>
	                                           <input type="text" id="Sdatepicker" style="width:80px;text-align:center"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;display:none" />
	                                            ~
	                                            <input type="text" id="Edatepicker" style="width:80px;text-align:center"><input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;display:none" />
	                                            </span>
	                                            <span id="repeatblock" style="DISPLAY: none"><spring:message code='ezSchedule.t343'/></span>
	                                        </td>
	                                    </tr>
	                                </table>
	                            </div>
	                            <!--일정반복-->
	                            <div id="schedule2" style="display: none">
	                                <table class="content">
	                                    <tr id="repeateTR">
	                                        <th><a href="#" class="imgbtn"><span onclick="config_repeat()"><spring:message code='ezSchedule.t367'/></span></a></th>
	                                        <td class="pos1">
	                                            <div id="repeatinfo" style="OVERFLOW-Y: auto; PADDING-TOP: 2px; HEIGHT: 19px; width: 565px">&nbsp;</div>
	                                        </td>
	                                        <td class="pos2"></td>
	                                    </tr>
	
                                        <tr id="HolderEdit2" style="display: none;">
                                            <th><spring:message code='ezSchedule.t163'/></th>
                                            <td colspan="2">
                                                <span ID="LabelAttendant" Style="OVERFLOW-Y: auto; PADDING-TOP: 2px height=19px"></span></td>
                                        </tr>

                                        <tr id="receiverTr1">
                                            <th rowspan="2"><a href="#" id="imgbutton" class="imgbtn"><span id="clickbtn" onclick="manage_attendant()"><spring:message code='ezSchedule.t364'/></span></a></th>
                                            <td class="pos1">
                                                <input name="Input" id="receiverinput" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" onkeyup="return on_keydown(event)"></td>
                                            <td class="pos2"></td>
                                        </tr>
                                        <tr id="receiverTr2">
                                            <td colspan="2">
                                                <div id="receiverlist" style="OVERFLOW-Y: auto; HEIGHT: 17px"></div>
                                            </td>
                                        </tr>
	                                </table>
	                            </div>
	                            <!--자원설정-->
	                            <div id="schedule3" style="display: none">
	                                <table class="content">
                                        <tr ID="HolderWriteTr1">
                                            <th><a href="#" id="resourcebutton" class="imgbtn"><span id="resourcebtn" onclick="manage_resource()"><spring:message code='ezSchedule.t1101'/></span></a></th>
                                            <td class="pos1">
                                                <div id="resourcelist" style="OVERFLOW-Y: auto; PADDING-TOP: 2px; HEIGHT: 19px; width: 565px"></div>
                                            </td>
                                            <td class="pos2"></td>
                                        </tr>

                                        <tr ID="HolderWriteTr1">
                                            <th><a href="#" class="imgbtn"><span onclick="config_repeat_resource()"><spring:message code='ezSchedule.t1102'/></span></a></th>
                                            <td class="pos1">
                                                <div id="resourcerepeatinfo" style="OVERFLOW-Y: auto; PADDING-TOP: 2px; HEIGHT: 19px; width: 565px">&nbsp;</div>
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
	                    	<c:choose>
	                            <c:when test="${editor == 'TAGFREE'}">
		                            <iframe id="message" class="viewbox" name="message" src="TagFree_TFX_Editor.aspx" style="padding:0; height:100%; width:100%;overflow:auto;"></iframe>
		                        </c:when>
	                            <c:when test="${editor == 'DEXT'}">
		                            <iframe id="message" class="viewbox" name="message" src="DEXT_Editor.aspx" style="padding:0; height:100%; width:100%;overflow:auto;"></iframe>
		                        </c:when>
		                        <c:otherwise>
		                            <iframe id="message" class="viewbox" name="message" src="/ezBoard/ckEditor.do" style="padding:0; height:100%; width:100%;overflow:auto;"></iframe>
		                        </c:otherwise>
	                        </c:choose>
	                    </td>
	                </tr>
	                <tr>
	                    <td>
	                        <br />
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
                <input type="hidden" id="iReFlag" value="${strIReFlagVal}"/>
	        </div>
	        <div id="tempattachdiv" style="display:none"></div>
	        <script type="text/javascript">
	            selToggleList(document.getElementById("menu"), "ul", "li", "0");
	            selToggleList(document.getElementById("close"), "ul", "li", "0");
	            Tab1_NewTabIni("tab1");
	        </script>
	    <script type="text/javascript">
	        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 395 + "PX";
	    </script>
	    </form>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="/blank.htm" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>
