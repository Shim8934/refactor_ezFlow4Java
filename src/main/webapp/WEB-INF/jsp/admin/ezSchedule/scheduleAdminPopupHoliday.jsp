<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezSchedule.e3', 'msg')}" type="text/css" />		
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<style type="text/css">
			.ui-datepicker-month {
				padding-top: 1px; <%-- 2018-07-24 천성준 - (#13167) 월 표시 상단이 잘려보임 --%>
			}
		</style>
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>		
	    <title>
	    	<c:if test="${id == null}"><spring:message code='ezSchedule.t4004' /></c:if>
		    <c:if test="${id != null}"><spring:message code='ezSchedule.t4005' /></c:if>
	    </title>
	    <script type="text/javascript">
	    
		    var holidayid = "<c:out value='${id}'/>";		    
		    var issolar = "<c:out value='${isSolar}'/>";
		    var holidaydate = "<c:out value='${date}'/>";
		    var isrepeat = "<c:out value='${isRepeat}'/>";
		    var isrest = "<c:out value='${isRest}'/>";
		    var lang = "<c:out value='${lang}'/>";
		    var holidayType = "<c:out value='${holidayType}'/>";
		    var holidayRepeat = "<c:out value='${holidayRepeat}'/>";
		    var holidayFlag = "<c:out value='${holidayFlag}'/>";
	
		    window.onload = function () {
		        if (holidayid != "") {
		            document.getElementById("add").style.display = "none";
		            document.getElementById("mod").style.display = "";		            
	
		            if (issolar != "1")
		                document.getElementById("date2").checked = true;
	
		            if (isrepeat == "1")
		                document.getElementById("repeat").checked = true;
	
		            if (isrest == "1")
		                document.getElementById("rest").checked = true;
		        }
		        if (holidayFlag == 'D') {
		        	$('#pickDate2').prop("checked", true);
		        	showMainPattern(1);
		        	
		        	var info = holidayRepeat.split("|");
		        	
			        list_Month2.value = info[1];
					list_YearlyEach.value = info[2];
					list_YearlyDay.value = info[3];
		        }
		        
		        //음력 양력 숨기기
		        if (lang != "1")
	            	$(".onlyUseKo").css("display", "none");
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
		
		    <%-- 2018-07-24 천성준 저장/수정시, 특수문자 입력 가능하게 --%>
		    function save_holiday(type) {
		    	var holidayName = document.getElementById("holidayname").value.trim();
		    	var holidayName2 = document.getElementById("holidayname2").value.trim();
		    	var companyID = "";
		    	
		        if (holidayName == "") {
		            alert("<spring:message code='ezSchedule.t9990004' />");
		            return;
		        }        
		        		
		        if (holidayName2 == "")
		        	holidayName2 = holidayName;		            
		        
		        if (holidayType == "a") {
		        	companyID = document.getElementById("ListCompany")[document.getElementById("ListCompany").selectedIndex].value;
		        } else {
		        	companyID = "1";
		        }
		        
		        holidayFlag = $('input[name="pickDate"]:checked').val();
		        var holidayRepeat = "";
		        if (holidayFlag == "D") {
		        	holidayDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        	holidayRepeat = "";
		        } else {
			        var repetition = "";
		        	repetition += list_Month2.value;
					repetition += "|" + list_YearlyEach.value;
					repetition += "|" + list_YearlyDay.value;
					
					holidayRepeat = repetition;
					holidayDate = "0000-00-00 00:00:00";
		        }
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/admin/ezSchedule/scheduleSaveHoliday.do",
		    		data : {
		    			holidayName  : holidayName,	
		    			holidayName2 : holidayName2,
		    			isSolar : (document.getElementsByName("date")[0].checked ? "1" : "0"),
		    			holidayDate : holidayDate,
		    			isRepeat : (document.getElementById("repeat").checked ? "1" : "0"),
		    			isRest : (document.getElementById("rest").checked ? "1" : "0"),
		    			type : (type == 1 ? "0" : "1"),
		    			holidayID : (type == 1 ? "0" : holidayid),	
    					companyID : companyID,
    					holidayRepeat : holidayRepeat,
    					holidayFlag :holidayFlag 
		    		},
		    		success: function(text) {
		    			alert("<spring:message code='ezSchedule.t4012' />");
				        window.opener.schedule_get_holiday();				        
						window.close();
		    		}	    		
		        });
		    }
		    
		    function showMainPattern(idx) {
		        eAllPatterns = window.document.all['divRecurPatterns'];
		        
		        for (var x = 0; x < eAllPatterns.length; x++)
		        {
		            eAllPatterns[x].style.display = "none";
		        }
		        window.document.all['divRecurPatterns'][idx].style.display = "";
		    }
		</script>
	</head>
	<body class="popup" style="font-size:12px">
		<form id="Form1" method="post">
		    <h1>
		    	<c:if test="${id == null}"><spring:message code='ezSchedule.t4004' /></c:if>
		    	<c:if test="${id != null}"><spring:message code='ezSchedule.t4005' /></c:if>
		    </h1>
		    <div id="close">
	            <ul>
	                <li><span onclick="window.close()"></span></li>
	            </ul>
	        </div>
		    <table class="content">
		    	<tr>
		        	<th style="width: 80px; text-align:center"><spring:message code='ezSchedule.t9990003' /></th>
		            <td style="width: 240px; padding: 0">
		            	<table style="width:100%">
		                	<tr class="primary">
		                        <th><spring:message code='ezSchedule.t4013' /></th>
		                        <td>
		                            <input id="holidayname" type="text" style="width: 98%" maxlength="20" value="<c:out value='${name}' />" />
		                        </td>
		                    </tr>
		                    <tr class="secondary">
		                        <th><spring:message code='ezSchedule.t4014' /></th>
		                        <td>
		                            <input id="holidayname2" type="text" style="width: 98%" maxlength="40" value="<c:out value='${name2}' />" />
		                        </td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
		        <tr>
		            <th style="width:200px; text-align:center">양력/음력</th>
		            <td>
		            	<span class="onlyUseKo">
			                <input id="date" type="radio" name="date" checked style="margin:0px 0px 0px 4px" />
			                <label for="date"><spring:message code='ezSchedule.t4000' /></label>
			                <input id="date2" type="radio" name="date" style="margin:0px 0px 0px 4px" />
			                <label for="date2"><spring:message code='ezSchedule.t101' /></label>
		            	</span>
		            </td>
		        </tr>
		        <tr>
		            <th style="width:200px; text-align:center" rowspan="2">
		           		<spring:message code='ezSchedule.t4008' />
		            </th>
		            <td>
		            	<input id="pickDate" type="radio" name="pickDate" value="D" checked style="margin:0px 0px 0px 4px" onClick='showMainPattern(0);' />
		                <label for="pickDate">날짜</label>
		                <input id="pickDate2" type="radio" name="pickDate" value="Y" style="margin:0px 0px 0px 4px" onClick='showMainPattern(1);'/>
		                <label for="pickDate2">요일</label>
		            </td>
		        </tr>
		        <tr>
		            <td id='divRecurPatterns' >
		            	<div style="margin:3px 1px">
		                <input type="text" id="Sdatepicker" style="width: 80px; text-align: center" />
		                </div>
		            </td>
		            <td id='divRecurPatterns' style="display:none">
		            	<div style="margin:5px 1px">	
		            	<select name="select" id="list_Month2">
							<option value="1"><spring:message code='ezSchedule.t382' /></option>
							<option value="2"><spring:message code='ezSchedule.t383' /></option>
							<option value="3"><spring:message code='ezSchedule.t384' /></option>
							<option value="4"><spring:message code='ezSchedule.t385' /></option>
							<option value="5"><spring:message code='ezSchedule.t386' /></option>
							<option value="6"><spring:message code='ezSchedule.t387' /></option>
							<option value="7"><spring:message code='ezSchedule.t388' /></option>
							<option value="8"><spring:message code='ezSchedule.t389' /></option>
							<option value="9"><spring:message code='ezSchedule.t390' /></option>
							<option value="10"><spring:message code='ezSchedule.t391' /></option>
							<option value="11"><spring:message code='ezSchedule.t392' /></option>
							<option value="12"><spring:message code='ezSchedule.t393' /></option>
		            	</select>
		            	<select name="select" id="list_YearlyEach">
							<option value="1"><spring:message code='ezSchedule.t92' /></option>
							<option value="2"><spring:message code='ezSchedule.t93' /></option>
							<option value="3"><spring:message code='ezSchedule.t94' /></option>
							<option value="4"><spring:message code='ezSchedule.t95' /></option>
							<option value="5"><spring:message code='ezSchedule.t96' /></option>
		            	</select>
		            	<select name="select" id="list_YearlyDay">
		              		<option value="0"><spring:message code='ezSchedule.t81' /></option>
		              		<option value="1"><spring:message code='ezSchedule.t82' /></option>
		              		<option value="2"><spring:message code='ezSchedule.t83' /></option>
		              		<option value="3"><spring:message code='ezSchedule.t84' /></option>
		              		<option value="4"><spring:message code='ezSchedule.t85' /></option>
		              		<option value="5"><spring:message code='ezSchedule.t86' /></option>
		              		<option value="6"><spring:message code='ezSchedule.t87' /></option>
		            	</select>						
						</div>	
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
		        <c:if test="${holidayType eq 'a'}">
			        <tr>
			            <th style="width:200px; text-align:center"><spring:message code='ezSchedule.t2000' /></th>
			            <td>
			                <select id="ListCompany">${companySel}</select>               
			            </td>
			        </tr>
		        </c:if>
		    </table>
		    <div class="btnpositionNew">
		        <a class="imgbtn" id="add"><span onclick="save_holiday(1)" ><spring:message code='ezSchedule.t157' /></span></a>
		        <a class="imgbtn" id="mod" style="display:none"><span onclick="save_holiday(2)" ><spring:message code='ezSchedule.t302' /></span></a>
		    </div>
		</form>
	</body>
</html>

