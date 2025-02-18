<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<title><spring:message code='ezEmail.lhm63' /></title>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/Newemail.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/datepicker.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/composeappt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<!-- data picker-->
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		
		<script type="text/javascript">
			var offsetMin = "${offsetMin}";
			
		    $(function () {
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
		        
		        var NowDate = utcDate2(offsetMin);
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', NowDate);
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
		    
		    function changeLangeEvent(){
		    	var today = utcDate2(offsetMin);
		    	var usepostDate = document.getElementById("selectRange").value;
				if(usepostDate == "direct"){
					document.getElementById("datepickerData").style.display = "";
				    $("#Sdatepicker").datepicker('enable');
				    $("#Edatepicker").datepicker('enable');
				    $(".ui-datepicker-trigger").style="margin-left:5px;margin-top:0px;margin-bottom:3px;vertical-align:middle;cursor:pointer";
				} else if(usepostDate == "all"){
				    $("#Sdatepicker").datepicker('disable');
				    $(".ui-datepicker-trigger").style="opacity: 0.5; cursor: default;";
				    $("#Edatepicker").datepicker('disable');
				} else {
				    $("#Sdatepicker").datepicker('disable');
				    $(".ui-datepicker-trigger").style="opacity: 0.5; cursor: default;";
				    $("#Edatepicker").datepicker('disable');
				}
		    }
		    
		    function confirm() {
		    	var range = $("#selectRange option:selected").val();
		    	var location = parent.parent.document.getElementsByName("right")[0].contentWindow;
		    	
		    	try {
			    	if(range == "direct"){
			    		var startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";
				        var endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";

						if (startDate > endDate) {
							alert("<spring:message code='ezAttitude.t132'/>");
							location.DivPopUpHidden();
						} else {
							location.DivPopUpHidden();
							location.mailbox_export("${folderName}", "${folderNameSql}", "${folderMailCnt}" , true, startDate, endDate);
						}
			    		
			    	} else if(range == "all"){
			    		location.DivPopUpHidden();
			    		location.mailbox_export("${folderName}", "${folderNameSql}", "${folderMailCnt}", false, "", "");
			    	}
		    	} catch (e) {
		    		alert("error");
		    		location.DivPopUpHidden();
		    	}
		    }
			
			function cancel() {
				parent.parent.document.getElementsByName("right")[0].contentWindow.DivPopUpHidden();
		    }
		</script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1><spring:message code='ezEmail.kyj04' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="cancel()"></span></li>
            </ul>
        </div>
		<table style="width:100%;" class="content">
		  <tr>
		  	<th><spring:message code='ezEmail.ls007' /></th>
			<td style="height: 35px;">
		    	<div style="margin: 0px 5px 0px 5px;padding: 3px;">
					<select name="select" class="text" id="selectRange" onchange="changeLangeEvent()" style="height: 25px;margin-right: 5px;width: 86px;">
						<option value="direct"><spring:message code="ezEmail.pyy20" /></option>
						<option value="all">ALL</option>
					</select>
			    	<span id="datepickerData">
			    		<input type="text" id="Sdatepicker" style="width:80px;text-align:center;margin-top:-5px;" readonly> ~ 
			    		<input type="text" id="Edatepicker" style="width:80px;text-align:center;margin-top:-5px;" readonly>
			    	</span>
		    	</div>
		    </td>
		  </tr>
		</table>
		<br>
		<span><spring:message code='ezEmail.ls008' /></span><br>
		<span><spring:message code='ezEmail.ls009' /></span><br>
		
		<div class="btnposition btnpositionNew">
		   <a class="imgbtn" onClick="confirm()" ><span><spring:message code='ezEmail.t38' /></span></a>
		</div>
	</body>
</html>



