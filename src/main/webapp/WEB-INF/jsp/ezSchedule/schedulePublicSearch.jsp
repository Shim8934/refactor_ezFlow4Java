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
	        }
	        else {
	            SDate = new Date();
	            EDate = new Date();
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
	        if (g_entity == null || g_entity["id"].length == 0) {
	            alert("<spring:message code='ezSchedule.t287' />");
	            return;
	        }

	        sdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	        edate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();

	        var idlist = "";
	        var namelist = "";

	        for (var i = 0; i < g_entity["id"].length; i++) {
	            if (i == 0) {
	                idlist = g_entity["id"][i];
	                namelist = g_entity["name"][i];
	            }
	            else {
	                idlist += "," + g_entity["id"][i];
	                namelist += "," + g_entity["name"][i];
	            }
	        }

	        window.location.href = "schedule_public_search_Cross.aspx?sdate=" + sdate + "&edate=" + edate + "&idlist=" + idlist + "&namelist=" + escape(namelist);
	    }

	    var schedule_select_entity_dialogArguments = new Array();
	    function select_entity() {
	        schedule_select_entity_dialogArguments[0] = g_entity;
	        schedule_select_entity_dialogArguments[1] = select_entity_Complete;
	        var OpenWin = GetOpenWindow("/myoffice/ezSchedule/schedule_select_entity.aspx?title=" + encodeURI("<spring:message code='ezSchedule.t288' />"), "schedule_select_entity", 970, 655);
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
	        window.open("schedule_publicread_Cross.aspx" + "?id=" + encodeURIComponent(scheduleid) + "&repeatcount=" + repeatcount + "&type=" + scheduletype + "&ownerid=" + ownerid + "&date=" + date + "&datetype=" + dateType, "",
				"height = 660px, width = 760px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	    }

	    
	    function RefreshView() {
	        window.location.href = "schedule_public_search_Cross.aspx?sdate=" + startdate + "&edate=" + enddate + "&idlist=" + idlist + "&namelist=" + escape(namelist);
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
			        	<div id="searchlist" style="OVERFLOW-Y: auto;"></div>
			        </td>
			  	</tr>
			  	<tr>
			    	<th style="white-space:nowrap"> <spring:message code='ezSchedule.t292' />
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
			<h2 class="h2_dot"><spring:message code='ezSchedule.t295' />
				<span class="point"></span><span id="resultCount"></span><spring:message code='ezSchedule.t296' />
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
			  <%-- <asp:Repeater ID="ListSchedule" Runat="server">
			    <ItemTemplate>
			      <tr style="cursor:pointer;padding:0" onClick="open_schedule('<%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("SCHEDULEID").InnerText %>','<%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("REPEATCOUNT").InnerText %>','<%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("STARTDATE").InnerText %>','<%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("SCHEDULETYPE").InnerText %>','<%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("OWNERID").InnerText %>' ,'<%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("DATETYPE").InnerText %>')">
			        <td colspan=2 style="padding:0 2px; white-space:nowrap"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("IMPORTANCE").InnerText %> </td>          
			        <td style="white-space:nowrap;overflow:hidden; text-overflow:ellipsis;"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("SCHEDULETYPE").InnerText %> </td>
			        <td style="white-space:nowrap;overflow:hidden; text-overflow:ellipsis;">
			        <%if(userinfo.primary == "1") { %>
			        <%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("OWNERNAME").InnerText) %> 
			        <% } else%>
			        <%{ %>
			          <%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("OWNERNAME2").InnerText) %> 
			        <%} %>
			        </td>
			        <td style="white-space:nowrap;overflow:hidden; text-overflow:ellipsis;">
			        <%if(userinfo.primary == "1"){ %>
			          <%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("CREATORNAME").InnerText) %>
			          <%} else%>
			        <%{ %>
			          <%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("CREATORNAME2").InnerText) %>
			        <%} %>
			         </td>
			        <td style="white-space:nowrap;overflow:hidden; text-overflow:ellipsis;"><%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("TITLE").InnerText) %></td>
			        <td style="white-space:nowrap;overflow:hidden; text-overflow:ellipsis;"><%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("LOCATION").InnerText) %> </td>
			        <td style="white-space:nowrap;overflow:hidden; text-overflow:ellipsis;"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("STARTDATE").InnerText %> </td>
			        <td style="white-space:nowrap;overflow:hidden; text-overflow:ellipsis;"><%# ((System.Xml.XmlElement)Container.DataItem).SelectSingleNode("ENDDATE").InnerText %> </td>
			      </tr>
			    </ItemTemplate>
			  </asp:Repeater> --%>			  
			    <tr>
			      <td colspan="9" style="text-align:center"><spring:message code='ezSchedule.t297' /></td>
			    </tr>			  
			</table>		
		</form> 
	</body>
</html>

