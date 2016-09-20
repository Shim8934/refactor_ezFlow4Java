<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<title><spring:message code='ezEmail.t353' /></title>
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/string_component.js"></script>
		<script type="text/javascript" src="/js/ezEmail/Controls_cross/datepicker.htc.js"></script>
		<script type="text/javascript" src="/js/ezEmail/Controls_cross/composeappt.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<!-- data picker-->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<!-- time picker-->
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<script type="text/javascript">
	
			var g_timezone = "${userTimeSet}";
		    var nowDateTime = "${setLocalTime}";
		    var NonActiveX = "${nonActiveX}";
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.gif",
		            buttonImageOnly: true
		        });
		        var NowDate = new Date();
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker('setTime', new Date());
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
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
		    
		    var RetValue;
		    var ReturnFunction;
		    var CancelFunction;
		    var isDivPopUp = false;
		    window.onload = function () {
		        var rgParams;
		        try {
		            RetValue = parent.letteroption_cross_dialogArguments[0];
		            ReturnFunction = parent.letteroption_cross_dialogArguments[1];
		            CancelFunction = parent.letteroption_cross_dialogArguments[2];
		            isDivPopUp = true;
		            rgParams = RetValue;
		        } catch (e) {
		            try {
		                RetValue = opener.letteroption_cross_dialogArguments[0];
		                ReturnFunction = opener.letteroption_cross_dialogArguments[1];
		                CancelFunction = opener.letteroption_cross_dialogArguments[2];
		                rgParams = RetValue;
		            } catch (e) { rgParams = dialogArguments; }
		        }
		
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            if (NonActiveX == "YES") {
		                document.getElementById("importantid").selectedIndex = parseInt(rgParams.important);
		                document.getElementById("postTypeid").selectedIndex = parseInt(rgParams.postType);
		                document.getElementById("bodyType").selectedIndex = parseInt(rgParams.bodyType);
		            }
		            else {
		                important.selectedIndex = parseInt(rgParams["important"]);
		                postType.selectedIndex = parseInt(rgParams["postType"]);
		                bodyType.selectedIndex = parseInt(rgParams["bodyType"]);
		            }
		        }
		        else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            document.getElementById("importantid").selectedIndex = parseInt(rgParams.important);
		            document.getElementById("postTypeid").selectedIndex = parseInt(rgParams.postType);
		            document.getElementById("bodyType").selectedIndex = parseInt(rgParams.bodyType);
		        }
		
		
		        if (rgParams["replySendTime"] == "1") {
		            document.getElementById("responseSendid").checked = true;
		        }
		        else {
		            document.getElementById("responseSendid").checked = false;
		        }
		
		        if (rgParams["replyReadTime"] == "1" || rgParams["replyReadTime"] == "2") {
		            responseReadType.value = rgParams["replyReadTime"];
		            document.getElementById("responseReadid").checked = true;
		        }
		        else {
		            document.getElementById("responseReadid").checked = false;
		        }
		
		
		        var tmpStr = "";
		        tmpStr = rgParams["delaySendDate"];
		        if (rgParams["delaySendDate"] != "") {
		            document.getElementById("deliverySend").checked = true;
		            tmpStr = rgParams["delaySendDate"];
		            var SetDate = new Date(tmpStr.replace(/-/gi, "/"))
		            $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		            $("#Sdatepicker").datepicker('setDate', SetDate);
		            $('#Stimepicker').timepicker('setTime', SetDate);
		            $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
		        }
		        else {
		            document.getElementById("Stimepicker").disabled = true;
		            $("#Sdatepicker").datepicker('disable');
		        }
		    }
		    
		    function cancel() {
		        if (ReturnFunction != null) {
		            if (deliverySend.checked == true && RetValue["replyReadTime"] == "2") {
		                deliverySend.checked = false;
		                alert("<spring:message code='ezEmail.t354' />");
		            }
		            if (!isDivPopUp)
		                window.close();
		            else
		                CancelFunction();
		        }
		        else
		            window.close();
		    }
		
		    if (!CrossYN() && NonActiveX == "NO") {
		        window.onunload = function () {
		            if (deliverySend.checked == true && dialogArguments["replyReadTime"] == "2") {
		                deliverySend.checked = false;
		                alert("<spring:message code='ezEmail.t354' />");
		            }
		        }
		    }
		
		    function responseSend_onClick() {
		        if (CrossYN() || NonActiveX == "YES") {
		            if (document.getElementById("responseSendid").checked == true)
		                RetValue["replySendTime"] = "1";
		            else
		                RetValue["replySendTime"] = "0";
		        }
		        else {
		            if (document.getElementById("responseSendid").checked == true)
		                dialogArguments["replySendTime"] = "1";
		            else
		                dialogArguments["replySendTime"] = "0";
		        }
		    }
		
		    function responseRead_onClick() {
		        if (CrossYN() || NonActiveX == "YES") {
		            if (document.getElementById("responseReadid").checked == true) {
		                RetValue["replyReadTime"] = document.getElementById("responseReadType").value
		                document.getElementById("responseReadid").disabled = false;
		            }
		            else {
		                RetValue["replyReadTime"] = "0";
		            }
		        }
		        else {
		            if (document.getElementById("responseReadid").checked == true) {
		                dialogArguments["replyReadTime"] = document.getElementById("responseReadType").value
		                document.getElementById("responseReadid").disabled = false;
		            }
		            else {
		                dialogArguments["replyReadTime"] = "0";
		            }
		        }
		    }
		
		    function msgCCDisplay_onClick() {
		        if (CrossYN() || NonActiveX == "YES") {
		            RetValue["showMsgCC"] = msgCCDisplay.checked;
		            if (typeof (RetValue["tagMsgCC"]) != "undefined") {
		                if (msgCCDisplay.checked == true) {
		                    RetValue["tagMsgCC"].style.display = "block";
		                    RetValue["tagMsgCCu"].style.display = "block";
		
		                    if (typeof (RetValue["tagMsgCC2"]) != "undefined" && RetValue["tagMsgCC2"] != null)
		                        RetValue["tagMsgCC2"].style.display = "block";
		                }
		                else {
		                    RetValue["tagMsgCC"].style.display = "none";
		                    RetValue["tagMsgCCu"].style.display = "none";
		
		                    if (typeof (RetValue["tagMsgCC2"]) != "undefined" && RetValue["tagMsgCC2"] != null)
		                        RetValue["tagMsgCC2"].style.display = "none";
		                }
		            }
		        }
		        else {
		            dialogArguments["showMsgCC"] = msgCCDisplay.checked;
		            if (typeof (dialogArguments["tagMsgCC"]) != "undefined") {
		                if (msgCCDisplay.checked == true) {
		                    dialogArguments["tagMsgCC"].style.display = "block";
		                    dialogArguments["tagMsgCCu"].style.display = "block";
		
		                    if (typeof (dialogArguments["tagMsgCC2"]) != "undefined" && dialogArguments["tagMsgCC2"] != null)
		                        dialogArguments["tagMsgCC2"].style.display = "block";
		                }
		                else {
		                    dialogArguments["tagMsgCC"].style.display = "none";
		                    dialogArguments["tagMsgCCu"].style.display = "none";
		
		                    if (typeof (dialogArguments["tagMsgCC2"]) != "undefined" && dialogArguments["tagMsgCC2"] != null)
		                        dialogArguments["tagMsgCC2"].style.display = "none";
		                }
		            }
		        }
		    }
		
		    function msgBCCDisplay_onClick() {
		        if (CrossYN() || NonActiveX == "YES") {
		            RetValue["showMsgBCC"] = msgBCCDisplay.checked;
		            if (typeof (RetValue["tagMsgBCC"]) != "undefined") {
		                if (msgBCCDisplay.checked == true) {
		                    RetValue["tagMsgBCC"].style.display = "block";
		                    RetValue["tagMsgBCCu"].style.display = "block";
		
		                    if (typeof (RetValue["tagMsgBCC2"]) != "undefined" && RetValue["tagMsgBCC2"] != null)
		                        RetValue["tagMsgBCC2"].style.display = "block";
		                }
		                else {
		                    RetValue["tagMsgBCC"].style.display = "none";
		                    RetValue["tagMsgBCCu"].style.display = "none";
		
		                    if (typeof (RetValue["tagMsgBCC2"]) != "undefined" && RetValue["tagMsgBCC2"] != null)
		                        RetValue["tagMsgBCC2"].style.display = "none";
		                }
		            }
		        }
		        else {
		            dialogArguments["showMsgBCC"] = msgBCCDisplay.checked;
		            if (typeof (dialogArguments["tagMsgBCC"]) != "undefined") {
		                if (msgBCCDisplay.checked == true) {
		                    dialogArguments["tagMsgBCC"].style.display = "block";
		                    dialogArguments["tagMsgBCCu"].style.display = "block";
		
		                    if (typeof (dialogArguments["tagMsgBCC2"]) != "undefined" && dialogArguments["tagMsgBCC2"] != null)
		                        dialogArguments["tagMsgBCC2"].style.display = "block";
		                }
		                else {
		                    dialogArguments["tagMsgBCC"].style.display = "none";
		                    dialogArguments["tagMsgBCCu"].style.display = "none";
		
		                    if (typeof (dialogArguments["tagMsgBCC2"]) != "undefined" && dialogArguments["tagMsgBCC2"] != null)
		                        dialogArguments["tagMsgBCC2"].style.display = "none";
		                }
		            }
		        }
		    }
		
		    function important_onChange() {
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            dialogArguments["important"] = important.selectedIndex.toString();
		        }
		        else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            RetValue["important"] = document.getElementById("importantid").selectedIndex.toString();
		        }
		    }
		
		    function postType_onChange() {
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            dialogArguments["bodyType"] = postType.selectedIndex.toString();
		        }
		        else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            RetValue["bodyType"] = document.getElementById("bodyType").selectedIndex.toString();
		        }
		    }
		
		    function GetStartDate() {
		        var pReservationTime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
		        pReservationTime = pReservationTime.replace(/-/gi, "/");
		        return pReservationTime;
		    }
		
		    function confirm() {
		        if (CrossYN() || NonActiveX == "YES") {
		            RetValue["bodyType"] = document.getElementById("bodyType").selectedIndex.toString();
		            RetValue["important"] = document.getElementById("importantid").selectedIndex.toString();
		
		            if (document.getElementById("responseSendid").checked == true)
		                RetValue["replySendTime"] = "1";
		            else
		                RetValue["replySendTime"] = "0";
		
		            if (document.getElementById("responseReadid").checked == true) {
		                RetValue["replyReadTime"] = document.getElementById("responseReadType").value
		                document.getElementById("responseReadid").disabled = false;
		            }
		            else {
		                RetValue["replyReadTime"] = "0";
		            }
		        }
		        else {
		            dialogArguments["important"] = document.getElementById('important').selectedIndex.toString();
		            dialogArguments["bodyType"] = document.getElementById('postType').selectedIndex.toString();
		
		            if (document.getElementById("responseSendid").checked == true)
		                dialogArguments["replySendTime"] = "1";
		            else
		                dialogArguments["replySendTime"] = "0";
		
		            if (document.getElementById("responseReadid").checked == true) {
		                dialogArguments["replyReadTime"] = document.getElementById("responseReadType").value
		                document.getElementById("responseReadid").disabled = false;
		            }
		            else {
		                dialogArguments["replyReadTime"] = "0";
		            }
		        }
		
		        if (deliverySend.checked == true) {
		            var now = new Date();
		            var nowmonth = now.getMonth() + 1;
		            var pTime = now.getFullYear() + "/" + nowmonth + "/" + now.getDate() + " " + now.getHours() + ":" + now.getMinutes();
		            if (GetStartDate() != "" && Date.parse(GetStartDate()) < Date.parse(pTime)) {
		                alert("<spring:message code='ezEmail.t356' />");
		                return;
		            }
		        }
		
		        if (CrossYN() || NonActiveX == "YES") {
		            if (deliverySend.checked == true) {
		                RetValue["delaySendDate"] = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
		            }
		            else
		                RetValue["delaySendDate"] = "";
		
		            RetValue["bodyType"] = bodyType.selectedIndex.toString();
		        }
		        else {
		            if (deliverySend.checked == true) {
		                dialogArguments["delaySendDate"] = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
		            }
		            else
		                dialogArguments["delaySendDate"] = "";
		
		            dialogArguments["bodyType"] = bodyType.selectedIndex.toString();
		        }
		
		        if (CrossYN() || NonActiveX == "YES") {
		            if (deliverySend.checked == true && RetValue["replyReadTime"] == "2") {
		                alert("<spring:message code='ezEmail.t354' />");
		                return;
		            }
		        }
		        else {
		            if (deliverySend.checked == true && dialogArguments["replyReadTime"] == "2") {
		                alert("<spring:message code='ezEmail.t354' />");
		                return;
		            }
		        }
		
		        if (ReturnFunction != null)
		            ReturnFunction(RetValue);
		        else
		            window.close();
		    }
		
		    function SecurityMail_onClick() {
		        if (CrossYN()) {
		            if (SecurityMail.checked == true)
		                RetValue["SecurityMail"] = "Security";
		            else
		                RetValue["SecurityMail"] = "Normal";
		        }
		        else {
		            if (SecurityMail.checked == true)
		                dialogArguments["SecurityMail"] = "Security";
		            else
		                dialogArguments["SecurityMail"] = "Normal";
		        }
		    }
		
		    function ReservedSend(obj) {
		        if (obj.checked) {
		            document.getElementById("Stimepicker").disabled = false;
		            $("#Sdatepicker").datepicker('enable');
		        } else {
		            document.getElementById("Stimepicker").disabled = true;
		            $("#Sdatepicker").datepicker('disable');
		        }
		    }
		</script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1><spring:message code='ezEmail.t353' /></h1>
		<h2><spring:message code='ezEmail.t358' /></h2>
		<table style="width:100%;" class="content">
		  <tr>
		    <th><spring:message code='ezEmail.t359' /></th>
		    <td><select name="important" style="Width:100px;" onChange="" id="importantid">
		        <option><spring:message code='ezEmail.t360' /></option>
		        <option 1><spring:message code='ezEmail.t361' /></option>
		        <option><spring:message code='ezEmail.t362' /></option>
		      </select>
		    </td>
		  </tr>
		  <tr style="display:none">
		    <th><spring:message code='ezEmail.t363' /></th>
		    <td><select name="postType" style="Width:100px;" onChange="" id="postTypeid">
		        <option 1><spring:message code='ezEmail.t361' /></option>
		        <option><spring:message code='ezEmail.t364' /></option>
		        <option><spring:message code='ezEmail.t365' /></option>
		        <option><spring:message code='ezEmail.t366' /></option>
		      </select>
		    </td>
		  </tr>
		  <tr>
		    <th><spring:message code='ezEmail.t367' /></th>
		    <td><select id="bodyType" style="Width:100px;" onChange="" NAME="bodyType">
		        <option 1>HTML</option>
		        <option>Plain Text</option>
		      </select>
		    </td>
		  </tr>
		  <tr style="display:none;">
		    <th><spring:message code='ezEmail.t749' /></th>
		    <td colspan="3"><input type="checkbox" name="SecurityMail" value="checkbox" onClick="SecurityMail_onClick()"><spring:message code='ezEmail.t750' /></td>
		  </tr>
		</table>
		<br>
		<h2><spring:message code='ezEmail.t368' /></h2>
		<table style="width:100%;" class="content">
		  <tr>
		    <td><input type="checkbox" name="responseSend" value="checkbox" onClick="" id = "responseSendid">
		     <span style="vertical-align:middle;"> <spring:message code='ezEmail.t369' /></span></td>
		  </tr>
		  <tr>
		    <td><input type="checkbox" name="responseRead" value="checkbox" onClick="" id = "responseReadid">
		      <span style="vertical-align:middle;"><spring:message code='ezEmail.t370' /> </span>
		      <c:choose>
		      	<c:when test="${outMailReadCheck}">
					<select id="responseReadType" onChange="">
		      			<option value="1" selected><spring:message code='ezEmail.t371' /></option>
		      			<option value="2"><spring:message code='ezEmail.t372' /></option>
		      		</select>
				</c:when>
		      	<c:otherwise>
		      		<select id="responseReadType" onChange="" disabled>
		      			<option value="1" selected><spring:message code='ezEmail.t371' /></option>
		      		</select>
		      	</c:otherwise>
		      </c:choose>
		    </td>
		  </tr>
		</table>
		<br>
		<h2> <spring:message code='ezEmail.t373' /></h2>
		<table class="content" style="border-top:none;width:100%;">
		  <tr>
		    <td><input type="checkbox" value="1" id="deliverySend" onclick="ReservedSend(this);">
		      <spring:message code='ezEmail.t374' />
		      <input type="text" id="Sdatepicker" style="width:80px;text-align:center"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" />
		  </tr>
		</table>
		<div class="btnposition">
		   <a class="imgbtn" onClick="confirm()" ><span><spring:message code='ezEmail.t38' /></span></a>
		   <a class="imgbtn" onClick="cancel()" ><span><spring:message code='ezEmail.t39' /></span></a>
		</div>
	</body>
</html>



