<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="/css/theme01.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/theme1/CalendarMini_Cross.js"></script>
		<script type="text/javascript">
			 //달력 관련
	        var strLang5 = "<spring:message code='main.t00052'/>;<spring:message code='main.t00053'/>;<spring:message code='main.t00054'/>;<spring:message code='main.t00055'/>;<spring:message code='main.t00056'/>;<spring:message code='main.t00057'/>;<spring:message code='main.t00058'/>"
	        var strLang6 = "<spring:message code='main.t00053'/>;<spring:message code='main.t00054'/>;<spring:message code='main.t00055'/>;<spring:message code='main.t00056'/>;<spring:message code='main.t00057'/>;<spring:message code='main.t00058'/>;<spring:message code='main.t00052'/>"
	        var strLang7 = "<spring:message code='main.t00048'/>";
	        var strLang8 = "<spring:message code='main.t00049'/>";
	        var xmlSchedulehttp = createXMLHttpRequest();
	        var selDate = "";
	        var nowDate = new Date();
	        var nowDay = (nowDate.getFullYear()) + "-" + leadingZeros((nowDate.getMonth() + 1), 2) + "-" + leadingZeros(nowDate.getDate(), 2);
	
	        var strLang1 = "<spring:message code='main.t00026'/>";
	        var strLang2 = "<spring:message code='main.t10100'/>";
	        var strLang3 = "<spring:message code='main.t10101'/>";
	
	        window.onload = function () {
	            CalendarMiniView("CalenderMini");
	            CalendarMiniDataSource();
	            getScheduleUserList(nowDay);
	
	            try { top.onresize() } catch (e) { }
	        }
	        //일정관리 관련
	        function getScheduleUserList(date) {
	            selDate = date;
	            document.getElementById("seldate_span").innerHTML = date.split("-")[0] + "." + date.split("-")[1] + "." + date.split("-")[2];
	            var xmlpara = createXmlDom();
	
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "pSelectDate", date);
	            createNodeAndInsertText(xmlpara, objNode, "MODE", "P");
	
	
	            xmlSchedulehttp = null;
	            xmlSchedulehttp = createXMLHttpRequest();
	            xmlSchedulehttp.open("POST", "/myoffice/ezSchedule/schedule_newwebpartlist.aspx", true);
	            xmlSchedulehttp.onreadystatechange = getScheduleUserList_after;
	            xmlSchedulehttp.send(xmlpara);
	        }
	        function getScheduleUserList_after() {
	
	            if (xmlSchedulehttp == null || xmlSchedulehttp.readyState != 4) return;
	
	            try {
	                var xmldom = createXmlDom();
	                xmldom = xmlSchedulehttp.responseXML;
	                var count = 1;
	                try {
	                    document.getElementById("scheduleDate1").innerHTML = "";
	                    document.getElementById("scheduleTitle1").innerHTML = "";
	                    document.getElementById("scheduleDate2").innerHTML = "";
	                    document.getElementById("scheduleTitle2").innerHTML = "";
	                    document.getElementById("scheduledl1").style.display = "";
	                    document.getElementById("scheduledl2").style.display = "";
	                    if (document.getElementById("nodata_div") != null) {
	                        document.getElementById("nodata_div").style.display = "none";
	                    }
	                } catch (e) { }
	
	
	                for (var i = 0; i < xmldom.getElementsByTagName("ROW").length; i++) {
	
	                    var SCHEDULEID = getNodeText(xmldom.getElementsByTagName("SCHEDULEID").item(i));
	                    var SCHEDULETYPE = getNodeText(xmldom.getElementsByTagName("SCHEDULETYPE").item(i));
	                    var DATETYPE = getNodeText(xmldom.getElementsByTagName("DATETYPE").item(i));
	                    var REPEATCOUNT = getNodeText(xmldom.getElementsByTagName("REPEATCOUNT").item(i));
	                    var STARTDATE = getNodeText(xmldom.getElementsByTagName("STARTDATE").item(i));
	                    var ENDDATE = getNodeText(xmldom.getElementsByTagName("ENDDATE").item(i));
	                    var TITLE = getNodeText(xmldom.getElementsByTagName("TITLE").item(i));
	
	                    document.getElementById("scheduleDate" + count).innerHTML = "";
	                    document.getElementById("scheduleTitle" + count).innerHTML = "";
	                    var _span1 = document.createElement("span");
	                    _span1.className = "bg_calendar01L";
	
	                    var _span2 = document.createElement("span");
	                    _span2.className = "bg_calendar01R";
	                    _span2.innerHTML = strLang2;
	
	                    _span1.appendChild(_span2);
	
	                    document.getElementById("scheduleDate" + count).appendChild(_span1);
	                    if (DATETYPE == "1") {
	                        if (ENDDATE.substring(0, ENDDATE.indexOf(" ")) != STARTDATE.substring(0, STARTDATE.indexOf(" "))) {
	                            document.getElementById("scheduleDate" + count).innerHTML += makeScheduleWrite(STARTDATE, ENDDATE);
	                        }
	                        else {
	                            document.getElementById("scheduleDate" + count).innerHTML += STARTDATE.substring(0, STARTDATE.lastIndexOf(":")) + " ~ " + ENDDATE.substring(ENDDATE.indexOf(" ") + 1, ENDDATE.indexOf(" ") + 6);
	                        }
	                    }
	                    else {
	                        if (ENDDATE.substring(0, ENDDATE.indexOf(" ")) != STARTDATE.substring(0, STARTDATE.indexOf(" "))) {
	                            document.getElementById("scheduleDate" + count).innerHTML += selDate + " " + strLang3;
	                        }
	                        else {
	                            document.getElementById("scheduleDate" + count).innerHTML += STARTDATE.substring(0, STARTDATE.lastIndexOf(" ")) + " " + strLang3;
	                        }
	                    }
	
	
	                    document.getElementById("scheduleTitle" + count).innerHTML = TITLE;
	                    document.getElementById("scheduleTitle" + count).style.cursor = "pointer";
	                    document.getElementById("scheduleTitle" + count).onclick = new Function("open_schedule('" + SCHEDULEID + "','" + SCHEDULETYPE + "','" + DATETYPE + "','" + REPEATCOUNT + "','" + STARTDATE + "')")
	                    count++;
	
	                }
	                if (xmldom.getElementsByTagName("ROW").length <= 0) {
	                    document.getElementById("scheduledl1").style.display = "none";
	                    document.getElementById("scheduledl2").style.display = "none";
	
	                    if (document.getElementById("nodata_div") != null) {
	                        document.getElementById("nodata_div").style.display = "";
	                    }
	                    else {
	                        var _div = document.createElement("DIV");
	                        _div.className = "nodata_h";
	                        _div.id = "nodata_div";
	
	                        var _p = document.createElement("span");
	                        var _p2 = document.createElement("span");
	                        _p2.innerHTML = strLang1;
	
	                        var _image = document.createElement("img");
	                        _image.src = "/images/kr/theme01/main/nodata_gray.png";
	                        _p.appendChild(_image);
	
	                        _div.appendChild(_p);
	                        _div.appendChild(_p2);
	                        document.getElementById("calendar_list").appendChild(_div);
	                        document.getElementById("calendar_list").style.borderBottom = "1px solid #efeeee";
	                    }
	                }
	            }
	            catch (e) {
	            }
	        }
	
	        var selDate;
	        function makeScheduleWrite(sDate, eDate) {
	            var rtnValue = "";
	            if (sDate.substring(0, sDate.indexOf(" ")) == selDate) {
	                rtnValue = selDate + sDate.substring(sDate.indexOf(" "), sDate.lastIndexOf(":")) + " ~ " + "24:00";
	            }
	            else if (eDate.substring(0, eDate.indexOf(" ")) == selDate) {
	                rtnValue = selDate + " 00:00" + " ~ " + eDate.substring(eDate.indexOf(" "), eDate.lastIndexOf(":"));
	            }
	            else {
	                rtnValue = selDate + " 00:00" + " ~ " + "24:00";
	            }
	            return rtnValue;
	        }
	
	        function open_schedule(scheduleid, scheduletype, datetype, repeatcount, date) {
	            date = date.substr(0, 10);
	
	            var wWeight = "760";
	            var wHeight = "660";
	            var heigth = window.screen.availHeight;
	            var width = window.screen.availWidth;
	            var left = (width - wWeight) / 2;
	            var top = (heigth - wHeight) / 2;
	
	            //PNO-3
	            if (CrossYN())
	                window.open("/myoffice/ezSchedule/schedule_read_Cross.aspx" + "?id=" + encodeURIComponent(scheduleid) + "&type=" + scheduletype + "&datetype=" + datetype + "&repeatcount=" + repeatcount + "&date=" + date + "&pattern=0", "",
	                    "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            else
	                window.open("/myoffice/ezSchedule/schedule_read.aspx" + "?id=" + encodeURIComponent(scheduleid) + "&type=" + scheduletype + "&datetype=" + datetype + "&repeatcount=" + repeatcount + "&date=" + date + "&pattern=0", "",
	                    "top = " + top + ", left = " + left + ",height = " + wHeight + "px, width = " + wWeight + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            //PNO-3 END
	        }

		</script>
	</head>
	<body>
		<!-- calendar -->
		<div id="CalenderMini"></div>
		<div class="calendar_list" id="calendar_list" style="height:140px;">
			<p><span id="seldate_span"></span> <spring:message code='main.t203'/></p>
	    	<dl id="scheduledl1">
	    		<dt style="height:20px;" id="scheduleDate1"></dt>
	        	<dd id="scheduleTitle1" style="height:20px;"></dd>
	    	</dl>
	    	<dl id="scheduledl2">
	    		<dt style="height:20px;" id="scheduleDate2"></dt>
	        	<dd id="scheduleTitle2" style="height:20px;"></dd>
	    	</dl>
		</div>
		<!-- //calendar -->
	</body>
</html>