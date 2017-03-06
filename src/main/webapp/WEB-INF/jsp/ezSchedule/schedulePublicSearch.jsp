<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSchedule.t286' /></title>
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
	    var g_entity = null;
	    var startdate = "<c:out value='${startDate}' />";
		var enddate = "<c:out value='${endDate}' />";
		var idlist = "<c:out value='${idList}' />";
		var namelist = "<c:out value='${nameList}' />";
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
	        
	        if (idlist != "") {
	            var list1 = idlist.split(",");
	            var list2 = namelist.split(",");

	            g_entity = { "id": new Array(), "name": new Array(), "deptname": new Array() };

	            for (var i = 0; i < list1.length; i++) {
	                if (i == 0)
	                    document.getElementById("searchlist").innerHTML = list2[i];
	                else
	                    document.getElementById("searchlist").innerHTML += ", " + list2[i];

	                g_entity["name"][i] = list2[i];
	                g_entity["id"][i] = list1[i];
	                g_entity["deptname"][i] = "";
	            }
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
	        if (g_entity == null || g_entity["id"].length == 0) {
	            alert("<spring:message code='ezSchedule.t287' />");
	            return;
	        }

	        sdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	        edate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	        
	        if (sdate > edate) {
	        	alert("<spring:message code='ezResource.dateChk' />");
	        	return;
	        }

	        var idlist = "";
	        var namelist = "";

	        for (var i = 0; i < g_entity["id"].length; i++) {
	            idlist += g_entity["id"][i];
	            namelist += g_entity["name"][i];
	            
	            if (i < g_entity["id"].length-1) {
	                idlist += ",";
	                namelist += ",";
	            }
	        }       
	        window.location.href = "/ezSchedule/schedulePublicSearch.do?sdate=" + sdate + "&edate=" + edate + "&idlist=" + idlist + "&namelist=" + encodeURIComponent(namelist);
	    }

	    var schedule_select_entity_dialogArguments = new Array();
	    function select_entity() {
	        schedule_select_entity_dialogArguments[0] = g_entity;
	        schedule_select_entity_dialogArguments[1] = select_entity_Complete;
	        var OpenWin = GetOpenWindow("/ezSchedule/scheduleSelectEntity.do?title=" + encodeURIComponent("<spring:message code='ezSchedule.t288' />"), "scheduleSelectEntity", 970, 655);
	        try { OpenWin.focus(); } catch (e) { }
	    }

	    function select_entity_Complete(rtn) {
	        if (typeof (rtn) != "undefined") {
	            g_entity = { "id": new Array(), "name": new Array(), "deptname": new Array() };
	            document.getElementById("searchlist").innerHTML = "";

	            if (rtn["id"].length == 0)
	                return;

	            for (var i = 0; i < rtn["id"].length; i++) {
	                if (i == 0)
	                    document.getElementById("searchlist").innerHTML = rtn["name"][i];
	                else
	                    document.getElementById("searchlist").innerHTML += ", " + rtn["name"][i];

	                g_entity["name"][i] = rtn["name"][i];
	                g_entity["id"][i] = rtn["id"][i];
	                g_entity["deptname"][i] = rtn["deptname"][i];
	            }
	        }
	    }
		
	    function open_schedule(scheduleid, repeatcount, date, scheduletype, ownerid, dateType) {
	        date = date.substring(0, 10);

	        if (scheduletype == "<spring:message code='ezSchedule.t281' />") {
	            scheduletype = "1";
	        }

	        else if (scheduletype == "<spring:message code='ezSchedule.t12' />") {
	            scheduletype = "2";
	        }

	        else if (scheduletype == "<spring:message code='ezSchedule.t11' />") {
	            scheduletype = "3";
	        }

	        var feature = GetOpenPosition(760, 660);
	        window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&repeatcount=" + repeatcount + "&type=" + scheduletype + "&ownerid=" + ownerid + "&date=" + date + "&datetype=" + dateType, "",
				"height = 660px, width = 760px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	    }

	    
	    function RefreshView() {
	        window.location.href = "/ezSchedule/schedulePublicSearch.do?sdate=" + startdate + "&edate=" + enddate + "&idlist=" + idlist + "&namelist=" + encodeURIComponent(namelist);
	    }
		
	    function onmouseOver(elem) {
	        elem.style.color = "blue";
	        elem.style.backgroundColor = "#ECF3BA";
	    }

	    function onmouseOut(elem) {
	        elem.style.color = "";
	        elem.style.backgroundColor = "#FFFFFF";
	    }
		</script>
	</head>
	<body class="mainbody"> 
		<form method="post"> 
			<h1><spring:message code='ezSchedule.t289' /></h1>
			<table class="content">
				<tr>
			    	<th style="white-space:nowrap"><spring:message code='ezSchedule.t290' /></th>
			    	<td style="width:20px;border-right:none">
			    		<a href="#" class="imgbtn">
			    			<span onClick="select_entity();"><spring:message code='ezSchedule.t291' /></span>
			    		</a>
			    	</td>
			        <td style="border-left:none">
			        	<div id="searchlist" style="OVERFLOW-Y: auto;padding-left:3px"></div>
			        </td>
			  	</tr>
			  	<tr>
			    	<th style="white-space:nowrap"> <spring:message code='ezSchedule.t292' /></th>
			    	<td colspan="2">
			       		<input type="text" id="Sdatepicker" style="width:80px;text-align:center" /> ~ 
			       		<input type="text" id="Edatepicker" style="width:80px;text-align:center"/>
						<a href="#" class="imgbtn">
							<span onClick="search()"><spring:message code='ezSchedule.t24' /></span>
						</a>
					</td>
				</tr>		
			</table>
			<br/>
			<h2 class="h2_dot">
		 		<spring:message code='ezSchedule.t295'/>&nbsp;<span class="point">${fn:length(scheduleList)}</span>&nbsp;<span id="resultCount"></span><spring:message code='ezSchedule.t296'/>
		    </h2>
			<table class="mainlist" style="table-layout:fixed;width:100%"> 
				<tr>
			    	<th colspan=2 style="padding:0 2px; width:30px"><img src="/images/i_important.gif"></th>      
			    	<th style="width:50px"><spring:message code='ezSchedule.t270' /></th>
			    	<th style="width:80px"><spring:message code='ezSchedule.t271' /></th>
			    	<th style="width:80px"><spring:message code='ezSchedule.t161' /></th>
			    	<th style="width:60%"><spring:message code='ezSchedule.t272' /></th>
			    	<th style="width:140px"><spring:message code='ezSchedule.t273' /></th>
			    	<th style="width:140px"><spring:message code='ezSchedule.t274' /></th>
			    	<th style="width:140px"><spring:message code='ezSchedule.t275' /></th>
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
		    	<c:if test="${fn:length(scheduleList) == 0 && idList != null}">
		    	<tr> 
		        	<td colspan="9" style="text-align:center"><spring:message code='ezSchedule.t297'/></td> 
		      	</tr>
		      	</c:if>
			</table>		
		</form> 
	</body>
</html>

