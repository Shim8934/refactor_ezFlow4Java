<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezSchedule.t357' /></title>
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
        <link rel="stylesheet" href="/css/ezSchedule/Tab.css" type="text/css" />
        <link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
	    <script type="text/javascript" src="/js/ezSchedule/schedule_write_Cross.js"></script>
		<script type="text/javascript" src="/js/ezSchedule/Calendar/TabMenu.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
		<!-- data picker-->		
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
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
		    var timeCheck = false;
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		    }
		    
		    window.onresize = function () {   	
                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 185 + "PX";
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
				
		        var SDate = new Date();
		        SDate.setFullYear(sYear, sMonth-1, sDay);
		        SDate.setHours(sHour, sMin, 0, 0);
		        
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', SDate);
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });

		    });
		    
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
		            }
		        }
		    }

		    var bool = false;
		    var bool2 = false;
		    var bool3 = false;
		    
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
		        
		        save_schedule();
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
		        	if (document.getElementById("LabelAttendant")) {
		            	printAttendant = document.getElementById("LabelAttendant").textContent;
		        	}
		        }

		        printIsPublic = document.getElementById("publicSelect").options[document.getElementById("publicSelect").selectedIndex].textContent;
		        printImportance = document.getElementById("importantSelect").options[document.getElementById("importantSelect").selectedIndex].textContent;
		        printRepetition = document.getElementById("repeatinfo").textContent;

		        if ($.trim(repetition) == "") {
		            if (document.all("alldaycheck").checked == true)
		                printDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		            else
		                printDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
		        } else {
		            printDate = "<spring:message code='ezSchedule.t343' />";
		        }

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
		            } else {
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
		        post_to_url("/ezSchedule/scheduleContentsPrint.do", params, "post");
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
	                                <li><span onclick="checkupload()">수정</span></li>
	                                <li><span onclick="Print_onClick()">삭제</span></li>
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
	                        <div id="tabShecdule">
	                            <div id="schedule1">
	                                <table class="content">
                                        <tr id="HolderWrite">
                                            <th>구분</th>
                                            <td colspan="2" readonly>
                                            </td>
                                        </tr>
	                                    <tr>
	                                        <th>출근시각</th>
	                                        <td colspan="2">
	                                        	<c:out value='${scheduleInfo.location}' />
	                                        </td>
	                                    </tr>
	                                    <tr id="periodblockTR">
	                                        <th>변경시각</th>
	                                        <td colspan="2">
	                                        	<span id="periodblock">
	                                           		<input type="text" id="Sdatepicker" style="width:80px;text-align:center" disabled readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" />
	                                            </span>
	                                            <span id="repeatblock" style="DISPLAY: none"><spring:message code='ezSchedule.t343'/></span>
	                                        </td>
	                                    </tr>
	                                    <tr>
	                                        <th>승인상태</th>
	                                        <td colspan="2">
	                                        	<c:out value='${scheduleInfo.title}' />
	                                        </td>
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
		    <script type="text/javascript">
		        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 210 + "PX";
		    </script>
	    </form>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>
