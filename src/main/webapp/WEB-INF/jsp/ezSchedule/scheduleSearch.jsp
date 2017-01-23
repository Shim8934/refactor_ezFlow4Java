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
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>	    
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
	    <script type="text/javascript">
			var startdate = "<c:out value='${startDate}' />";
			var enddate = "<c:out value='${endDate}' />";
			var filter = "<c:out value='${filter}' />";
			var keyword = "<c:out value='${keyword}' />";
			var offSetMin = "<c:out value='${offSetMin}' />";

		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        if (startdate != "") {
		            document.getElementById("usedate").checked = true;
		            document.getElementById('keyword').value = keyword;
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
		        var SDate;
		        var EDate;
		        
		        if (startdate != "") {	
		            SDate = new Date(startdate);
		            EDate = new Date(enddate);
		        } else {
		            SDate = utcDate(offSetMin);
		            EDate = utcDate(offSetMin);		            
		        }
		        
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
		
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', EDate);
		    });
		    
		    $(function () {
		    	if("${lang == '1'}") {
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
		    	}
			    if("${lang != '1'}") {
		    		$.datepicker.regional['en'] = {
			            dateFormat: 'yy-mm-dd',
			            firstDay: 0,
			            isRTL: false,
			            duration: 200,
			            showAnim: 'show',
			            showMonthAfterYear: true
			        };
			        $.datepicker.setDefaults($.datepicker.regional['en']);
			    }
		    });
		
		    function search() {
		        if (document.getElementById("keyword").value == "" && document.getElementById("usedate").checked == false) {
		            alert("<spring:message code='ezSchedule.t346'/>");
		            document.getElementById("keyword").focus();
		            return;
		        }
		
		        var sdate = "";
		        var edate = "";
		        var keyword = "";
		        var filter = "ScheduleID=ScheduleID";		        
		
		        if (document.getElementById("usedate").checked) {
		            sdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		            edate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        }
			
		        if (document.getElementById("keyword").value != "") {
		            filter = document.getElementsByName("search_field")[0].value;
		            keyword = document.getElementById("keyword").value;
		        }
		        
		        window.location.href = "/ezSchedule/scheduleSearch.do?sdate=" + sdate + "&edate=" + edate + "&filter=" + encodeURIComponent(filter) + "&keyword=" + encodeURIComponent(keyword);
		    }
		
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
			
		    function open_schedule(scheduleid, repeatcount, date, scheduletype, datetype, recurring) {
		        date = date.substring(0, 10);
		
		        if (scheduletype == "<spring:message code='ezSchedule.t281'/>") {
		            scheduletype = "1";
		        }
		
		        else if (scheduletype == "<spring:message code='ezSchedule.t12'/>") {
		            scheduletype = "2";
		        }
		
		        else if (scheduletype == "<spring:message code='ezSchedule.t11'/>") {
		            scheduletype = "3";
		        }
		
		        var feature = GetOpenPosition(770, 660);
		        if (recurring == "1") {
		            window.open("schedule_read_Cross.aspx" + "?id=" + encodeURIComponent(scheduleid) + "&repeatcount=Y" + "&date=" + date + "&type=" + scheduletype + "&datetype=" + datetype + "&recurring=" + recurring + "&pageFrom=search&pattern=0", "",
							    "height = 660px, width = 770px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		        }
		        else {
		            window.open("schedule_read_Cross.aspx" + "?id=" + encodeURIComponent(scheduleid) + "&repeatcount=" + repeatcount + "&type=" + scheduletype + "&date=" + date + "&datetype=" + datetype + "&recurring=" + recurring + "&pattern=0", "",
					            "height = 656px, width = 770px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		        }
		    }
			
		    function RefreshView() {
		        window.location.href = "schedule_search_Cross.aspx?sdate=" + startdate + "&edate=" + enddate + "&filter=" + escape(filter) + "&keyword=" + escape(keyword);
		    }
			
		    function onmouseOver(elem) {
		        elem.style.color = "blue";
		        elem.style.backgroundColor = "#ECF3BA";
		    }
		
		    function onmouseOut(elem) {
		        elem.style.color = "";
		        elem.style.backgroundColor = "#FFFFFF";
		    }
			
		    function search_keypress(evt) {
		        var evtKeyCode = (window.event) ? event.keyCode : evt.which;
		
		        if (evtKeyCode == "13") {
		            search();
		        }
		    }
		</script>
	</head>
	<body class="mainbody"> 
		<form method="post"> 
			<h1><spring:message code='ezSchedule.t347'/></h1> 
		  	<table style="width:100%" class="content">  
		    	<tr> 
		      		<th><spring:message code='ezSchedule.t348'/></th> 
		      		<td style="width:100%">
		      			<select name="search_field" style="WIDTH: 70px"> 
		          			<option value="title"selected><spring:message code='ezSchedule.t272'/></option> 
		          			<option value="location"><spring:message code='ezSchedule.t273'/></option> 
		        		</select> 
		        		<input type="text" id="keyword" size="21" value="${keyword}" onkeypress="return search_keypress(event)" /> 
		        		<a href="#" class="imgbtn"><span onClick="search()"><spring:message code='ezSchedule.t24'/></span></a>
		        	</td> 
		    	</tr> 
		    	<tr height="55px"> 
		      		<th><spring:message code='ezSchedule.t349'/></th>
		      		<td>
		      			<input type="checkbox" value="1" id="usedate" /><spring:message code='ezSchedule.t350'/>
		            	<input type="text" id="Sdatepicker" style="width:80px;text-align:center" /> ~
		      			<input type="text" id="Edatepicker" style="width:80px;text-align:center" />
		          		<div style="margin-top:9px">&nbsp;(<spring:message code='ezSchedule.t351'/></div> 
		          		<!-- <tr style="DISPLAY:none"> 
		            		<td colspan="2">
		                    	<span id="T_st">
		                      		<input id='_T1' class='datepicker_time' readonly type="text" style="PADDING-RIGHT:3px;PADDING-LEFT:3px;PADDING-BOTTOM:0px;WIDTH:73px;PADDING-TOP:2px" />
					          		<img id='img_StartTime' style=" cursor: pointer;" popupLocation='bottomright'  forcemarginleft='-40'  forceMarginTop='-10' src="/images/i_time.gif" width="19" height="15" align="absmiddle" hspace="2" />
					          	</span>
		        				<input id='_T2' class='datepicker_time' readonly type="text" style="PADDING-RIGHT:3px;PADDING-LEFT:3px;PADDING-BOTTOM:0px;WIDTH:73px;PADDING-TOP:2px" />
					          	<img id='img_EndTime' style=" cursor: pointer;" popupLocation='bottomright'  forcemarginleft='-40'  forceMarginTop='-10' src="/images/i_time.gif" width="19" height="15" align="absmiddle" hspace="2" />
					        </td> 
			          	</tr> -->
			  		</td>
			  	</tr>
		  	</table> 
		 	<br/>
		 	<h2 class="h2_dot">
		 		<spring:message code='ezSchedule.t295'/>&nbsp;<span class="point">${fn:length(scheduleList)}</span>&nbsp;<span id="resultCount"></span><spring:message code='ezSchedule.t296'/>
		    </h2>		
		  	<table class="mainlist" style="table-layout:fixed;width:100%">
		    	<tr> 
		      		<th colspan=2 style="width:30px; text-align:center; padding:0 2px"><img src="/images/i_important.gif" style="width:12px; height:9px"></th>      
		      		<th style="width:50px"><spring:message code='ezSchedule.t270'/></th> 
		      		<th style="width:80px"><spring:message code='ezSchedule.t271'/></th> 
		      		<th style="width:80px"><spring:message code='ezSchedule.t161'/></th> 
		      		<th style="width:60%"><spring:message code='ezSchedule.t272'/></th>
		      		<th style="width:140px"><spring:message code='ezSchedule.t273'/></th> 
		      		<th style="width:140px"><spring:message code='ezSchedule.t274'/></th> 
		      		<th style="width:140px"><spring:message code='ezSchedule.t275'/></th> 
		    	</tr>
		    	<c:forEach var="item" items="${scheduleList}">
		    	<tr style="cursor:pointer;padding:0" onClick="open_schedule('${item.scheduleId}','REPEATCOUNT','${item.startDate}','${item.scheduleType}','${item.dateType}','')" bgcolor=#ffffff>
		    		<td colspan=2 style="padding:0 2px;width:30px">
		    			<c:if test="${item.importance == '1'}"><img src='/images/calendar/i_l.png' width='13' height='13'/></c:if>
		    			<c:if test="${item.importance == '2'}">&nbsp;</c:if>
		    			<c:if test="${item.importance == '3'}"><img src='/images/calendar/i_h.png' width='13' height='13'/></c:if>
		    		</td>
		    		<td style="width:50px">
		    			<c:if test="${item.scheduleType == '1'}"><spring:message code='ezSchedule.t281'/></c:if>
		    			<c:if test="${item.scheduleType == '2'}"><spring:message code='ezSchedule.t12'/></c:if>
		    			<c:if test="${item.scheduleType == '3'}"><spring:message code='ezSchedule.t11'/></c:if>
		    			<c:if test="${item.scheduleType == '4'}"><spring:message code='ezSchedule.t282'/></c:if>
		    			<c:if test="${item.scheduleType == '7'}"><spring:message code='ezSchedule.t282'/></c:if>		    			
		    		</td>
		    		<c:if test="${primary == '1'}">
		    			<td style="width:80px">${item.ownerName}</td> 
		              	<td style="width:80px">${item.creatorName}</td>
		    		</c:if>
		    		<c:if test="${primary != '1'}">
		    			<td style="width:80px">${item.ownerName2}</td> 
		            	<td style="width:80px">${item.creatorName2}</td>
		    		</c:if>
		    		<td style="width:60%">${item.title}</td> 
	          		<td style="width:140px">${item.location}</td>		         
	            	<td style="width:140px">	            		
	            		<c:if test="${item.dateType == '2'}">${fn:substring(item.startDate,0,10)} (<spring:message code='ezSchedule.t280'/></c:if>
	            		<c:if test="${item.dateType != '2'}">${fn:substring(item.startDate,0,16)}</c:if>	            		
	            	</td> 
	            	<td style="width:140px">
	            		<c:if test="${item.dateType == '2'}">${fn:substring(item.endDate,0,10)} (<spring:message code='ezSchedule.t280'/></c:if>
	            		<c:if test="${item.dateType != '2'}">${fn:substring(item.endDate,0,16)}</c:if>	
	            	</td>
		    	</tr>
		    	</c:forEach>
		    	<c:if test="${fn:length(scheduleList) == 0}">
		    	<tr> 
		        	<td colspan="9" style="text-align:center"><spring:message code='ezSchedule.t297'/></td> 
		      	</tr>
		      	</c:if>
		  	</table>		
		</form> 
	</body>
</html>

