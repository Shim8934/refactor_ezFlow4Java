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
		
		    function search() {		    	
		    	if (specialChk(document.getElementById("keyword").value)) {
		    		alert("<spring:message code='ezResource.special' />");
		    		return;
		    	}
		    	
		        if (document.getElementById("keyword").value == "") {
		            alert("<spring:message code='ezSchedule.t346'/>");
		            document.getElementById("keyword").focus();
		            return;
		        }
		        		
		        var sdate = "";
		        var edate = "";
		        var keyword = "";
		        var strSearch = "";
		        var filter = "ScheduleID=ScheduleID";		        
		
	            sdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	            edate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();

		        if (sdate > edate) {
		        	alert("<spring:message code='ezResource.dateChk' />");
		        	return;
		        }
			
		        if (document.getElementById("keyword").value != "") {
		            filter = document.getElementsByName("search_field")[0].value;
		            keyword = document.getElementById("keyword").value;
		        }

		        window.location.href = "/ezCircular/circularSearchView.do?sdate=" + sdate + "&edate=" + edate + "&filter=" + encodeURIComponent(filter) + "&keyword=" + keyword;
		    }
			
		    var usepostDate = false;
		    function DateSearch_Click() {
		        if(usepostDate){
		            usepostDate = false;
		            $("#Sdatepicker").datepicker('disable');
		            $("#Edatepicker").datepicker('disable');
		        }
		        else {
		            usepostDate = true;
		            $("#Sdatepicker").datepicker('enable');
		            $("#Edatepicker").datepicker('enable');
		        }
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
		            window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&repeatcount=Y" + "&date=" + date + "&type=" + scheduletype + "&datetype=" + datetype + "&recurring=" + recurring + "&pageFrom=search&pattern=0", "",
							    "height = 670px, width = 770px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		        }
		        else {
		            window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&repeatcount=" + repeatcount + "&type=" + scheduletype + "&date=" + date + "&datetype=" + datetype + "&recurring=" + recurring + "&pattern=0", "",
					            "height = 670px, width = 770px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		        }
		    }
			
		    function RefreshView() {
		        window.location.href = "/ezCircular/circularSearchView.do?sdate=" + startdate + "&edate=" + enddate + "&filter=" + encodeURIComponent(filter) + "&keyword=" + encodeURIComponent(keyword);
		    }
			
		    function onmouseOver(elem) {
		        elem.style.color = "blue";
		        elem.style.backgroundColor = "rgb(233, 241, 244)";
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
			<h1>회람판 검색</h1> 
		  	<table style="width:100%" class="content">  
		    	<tr> 
		      		<th>검색조건</th> 
		      		<td style="width:100%">
		      			<select name="search_field" id="search_field" style="WIDTH: 130px"> 
		          			<option value="circularNew"selected>신규회람판</option> 
		          			<option value="circularComplete">확인완료회람판</option>
		          			<option value="circularMy">작성한회람판</option>
		          			<option value="circularTemp">임시회람판</option>
		          			<option value="circularFolder">회람문서함</option> 
		        		</select>
		        		<input type="text" id="keyword" size="21" value="${keyword}" onkeypress="return search_keypress(event)" /> 
		        		<a href="#" class="imgbtn"><span onClick="search()">검색</span></a>
		        	</td> 
		    	</tr> 
		    	<tr> 
		      		<th>검색기간</th>
		      		<td>
						<input type="checkbox" value="1" id="usepostdate" style="display:none;"><a class="imgbtn"><span onclick="DateSearch_Click();">검색기간 사용</span></a>
		            	<input type="text" id="Sdatepicker" style="width:80px;text-align:center" /> ~
		      			<input type="text" id="Edatepicker" style="width:80px;text-align:center" />
			  		</td>
			  	</tr>
		  	</table> 
		 	<br/>
		 	<h2 class="h2_dot">
		 		<spring:message code='ezSchedule.t295'/>&nbsp;<span class="point">${totalCount}</span>&nbsp;<span id="resultCount"></span><spring:message code='ezSchedule.t296'/>
		    </h2>		
		  	<table class="mainlist" style="table-layout:fixed;width:100%">
		    	<tr> 
		      		<th style="width:20px; padding: 0px; color: black;padding-left:3px;" nowrap title><input type="checkbox" onClick="check_change(this)" id="Checkbox1"></th>
			        <th style="width:18px; padding: 0px; color: black;padding-left:3px;cursor:pointer;text-align:center" nowrap title onclick="event_HeaderClick(this)" porp="importance" orderoption="ASC" ><img src="/images/ImgIcon/view-importance.gif" border="0"></th>
			        <th style="width:18px; padding: 0px; color: black;cursor:pointer;text-align:center" nowrap title onclick="event_HeaderClick(this)" porp="attach" orderoption="ASC"><img src="/images/newAttach.gif" border="0"></th>
					<th style="width:80px;cursor:pointer;text-align:center" id="tofromname" onclick="event_HeaderClick(this)" porp="from" orderoption="ASC">상태</th> 
					<th style="width:350px;cursor:pointer" align="left" onclick="event_HeaderClick(this)" porp="subject" orderoption="ASC">제목</th> 
					<th style="width:120px;cursor:pointer" align="left" id="tofromdate" onclick="event_HeaderClick(this)" porp="recevdate" orderoption="ASC">작성자</th> 
					<th style="width:150px;" align="left">작성일</th> 
					<th style="width:100px;cursor:pointer;text-align:center" onclick="event_HeaderClick(this)" porp="size" orderoption="ASC">확인</th>
					<th style="width:150px;cursor:pointer" align="left" onclick="event_HeaderClick(this)" porp="size" orderoption="ASC">확인일</th> 
		    	</tr>
		    	<c:forEach var="item" items="${list}">
<%-- 		    	<tr style="cursor:pointer;padding:0" onClick="open_schedule('${item.scheduleId}','${item.repeatCount}','${item.startDate}','${item.scheduleType}','${item.dateType}','')" bgcolor=#ffffff> --%>
		    	<tr style="cursor:pointer;padding:0" bgcolor=#ffffff>
		    		<td style="width:20px"><input type="checkbox" onClick="check_change(this)"></td>
		    		<td style="width:18px; padding: 0px; color: black;padding-left:3px;cursor:pointer;text-align:center">
		    			<c:if test="${item.importance == '0'}">&nbsp;</c:if>
		    			<c:if test="${item.importance == '1'}"><img src='/images/ImgIcon/view-importance.gif'/></c:if>
		    		</td>
		    		<td style="width:18px; padding: 0px; color: black;cursor:pointer;text-align:center">
		    			<c:if test="${item.importance == '0'}">&nbsp;</c:if>
		    			<c:if test="${item.importance == '1'}"><img src='/images/newAttach.gif'/></c:if>
		    		</td>
		    		<td style="width:80px;cursor:pointer;text-align:center">
		    			<c:if test="${item.status == '0'}">진행</c:if>
		    			<c:if test="${item.status == '1'}">종료</c:if>
		    			<c:if test="${item.status == '2'}">임시</c:if>
		    		</td>
		    		<td style="width:350px" align="left">${item.title}</td> 
	          		<td style="width:120px" align="left">${item.memberID}</td>		         
	            	<td style="width:150px" align="left">${item.regDate}</td>
	            	<td style="width:100px;cursor:pointer;text-align:center">${item.confirmStatus}</td>
	            	<td style="width:150px;cursor:pointer" align="left">${item.confirmDate}</td>
		    	</tr>
		    	</c:forEach>		    	
		    	<c:if test="${totalCount == 0 && keyword != null && startDate != null}">
			    	<tr> 
			        	<td colspan="9" style="text-align:center">검색 결과가 없습니다.</td> 
			      	</tr>
		      	</c:if>
		  	</table>		
		</form> 
	</body>
</html>

