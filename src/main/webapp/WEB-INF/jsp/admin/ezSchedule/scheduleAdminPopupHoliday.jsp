<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />		
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>		
	    <script type="text/javascript">
		    var holidayid = "<c:out value='${id}'/>";
		    var name = "<c:out value='${name}'/>";
		    var name2 = "<c:out value='${name2}'/>";
		    var issolar = "<c:out value='${isSolar}'/>";
		    var holidaydate = "<c:out value='${date}'/>";
		    var isrepeat = "<c:out value='${isRepeat}'/>";
		    var isrest = "<c:out value='${isRest}'/>";
	
		    window.onload = function () {
		        if (holidayid != "") {
		            document.getElementById("add").style.display = "none";
		            document.getElementById("mod").style.display = "";
		            document.getElementById("holidayname").value = name;
		            document.getElementById("holidayname2").value = name2;
	
		            if (issolar != "1")
		                document.getElementById("date2").checked = true;
	
		            if (isrepeat == "1")
		                document.getElementById("repeat").checked = true;
	
		            if (isrest == "1")
		                document.getElementById("rest").checked = true;
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
		        var NowDate;
		        if (holidaydate != "") {
		            NowDate = new Date(holidaydate.substring(0, 4), holidaydate.substring(5, 7), holidaydate.substring(8, 10));
		            NowDate.setMonth(NowDate.getMonth() - 1);
		        }
		        else
		            NowDate = new Date();
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', NowDate);
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
		
		    function save_holiday(type) {
		    	if (specialChk(document.getElementById("holidayname").value) || specialChk(document.getElementById("holidayname2").value)) {
		    		alert("<spring:message code='ezResource.special' />");
		    		return;
		    	}
		    	
		        if (document.getElementById("holidayname").value.trim() == "") {
		            alert("<spring:message code='ezSchedule.t9990004' />");
		            return;
		        }
		        if (document.getElementById("holidayname2").value.trim() == "") {
		            alert("<spring:message code='ezSchedule.t9990004' />");
		            return;
		        }
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezSchedule/scheduleSaveHoliday.do",
		    		data : {
		    			holidayName  : MakeXMLString(document.getElementById("holidayname").value),	
		    			holidayName2 : MakeXMLString(document.getElementById("holidayname2").value),
		    			isSolar : (document.getElementsByName("date")[0].checked ? "1" : "0"),
		    			holidayDate : $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val(),
		    			isRepeat : (document.getElementById("repeat").checked ? "1" : "0"),
		    			isRest : (document.getElementById("rest").checked ? "1" : "0"),
		    			type : (type == 1 ? "0" : "1"),
		    			holidayID : (type == 1 ? "0" : holidayid),	
    					companyID : document.getElementById("ListCompany")[document.getElementById("ListCompany").selectedIndex].value		    			
		    		},
		    		success: function(text) {
		    			alert("<spring:message code='ezSchedule.t4012' />");
				        window.opener.schedule_get_holiday();				        
						window.close();
		    		}	    		
		        });
		    }
		</script>
	</head>
	<body class="popup" style="font-size:12px">
		<form id="Form1" method="post">
		    <h1><spring:message code='ezSchedule.t4004' /></h1>
		    <table class="content">
		    	<tr>
		        	<th style="width: 80px; text-align:center"><spring:message code='ezSchedule.t9990003' /></th>
		            <td style="width: 240px; padding: 0">
		            	<table style="width:100%">
		                	<tr class="primary">
		                        <th><spring:message code='ezSchedule.t4013' /></th>
		                        <td>
		                            <input id="holidayname" type="text" style="width: 98%" maxlength="20"/>
		                        </td>
		                    </tr>
		                    <tr class="secondary">
		                        <th><spring:message code='ezSchedule.t4014' /></th>
		                        <td>
		                            <input id="holidayname2" type="text" style="width: 98%" maxlength="40"/>
		                        </td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
		        <tr>
		            <th style="width:200px; text-align:center"><spring:message code='ezSchedule.t4008' /></th>
		            <td>
		                <input id="date" type="radio" name="date" checked style="margin:0px 0px 0px 4px" />
		                <label for="date"><spring:message code='ezSchedule.t4000' /></label>
		                <input id="date2" type="radio" name="date" style="margin:0px 0px 0px 4px" />
		                <label for="date2"><spring:message code='ezSchedule.t101' /></label>
		                <input type="text" id="Sdatepicker" style="width: 80px; text-align: center" />
		            </td>
		        </tr>
		        <tr>
		            <th style="width:200px; text-align:center"><spring:message code='ezSchedule.t4007' /></th>
		            <td>
		                <input id="repeat" type="checkbox" name="repeat" />
		            </td>
		        </tr>
		        <tr>
		            <th style="width:200px; text-align:center"><spring:message code='ezSchedule.t4009' /></th>
		            <td>
		                <input id="rest" type="checkbox" name="rest" />
		            </td>
		        </tr>
		        <tr>
		            <th style="width:200px; text-align:center"><spring:message code='ezSchedule.t2000' /></th>
		            <td>
		                <select id="ListCompany">${companySel}</select>               
		            </td>
		        </tr>
		    </table>
		    <div class="btnposition">
		        <a class="imgbtn" id="add"><span onclick="save_holiday(1)" ><spring:message code='ezSchedule.t157' /></span></a>
		        <a class="imgbtn" id="mod" style="display:none"><span onclick="save_holiday(2)" ><spring:message code='ezSchedule.t302' /></span></a>
		        <a class="imgbtn"><span onclick="window.close()"><spring:message code='ezSchedule.t5' /></span></a>      
		    </div>
		</form>
	</body>
</html>

