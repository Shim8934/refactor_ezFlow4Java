<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>schedule_main</title>
        <link rel="stylesheet" href="/css/olstyle_nonIE.css" type="text/css" />
        <link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
        <link rel="stylesheet" href="/css/ezSchedule/Calendar_cross.css" type="text/css" />

		<script type="text/javascript" src="/js/Holiday.js"></script>
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
	    <script type="text/javascript" src="/js/ezSchedule/Calendar/CalendarDataPro_Cross.js?ver=1.2"></script>
	    <script type="text/javascript" src="/js/ezSchedule/Calendar/CalendarView_Cross.js?ver=1.3"></script>
    	
		<script type="text/javascript">
		    var userOffset = "${pOffset}";
			var timeZoneStr = "${timeZoneStr}";
			var receivecount = "${receiveCount}";
			var groupcount = "${groupCount}>";
			var userid = "${userInfo.id}";
		    var deptid = "${userInfo.deptID}";
		    var uselang = "${userInfo.lang}";
			var deptadmin = "${deptAdmin}";
			var companyadmin = "${companyAdmin}";
			var idtype = "${idType}";
		    var otherid = "${otherId}";
		    var groupid = "${groupId}";
			var secretaryxml = "${secretaryXml}";
			var groupxml = "${groupXmlTemp}";
			var sharexml = "${shareXml}";
		    var idlist = "${idList}";

		    var pDisplaySTime = "${startTime}";
		    var pDisplayETime = "${endTime}";
		    var pDefaultview = "${defaultView}";
		    var pStartday = "${startDay}";
		    var pUse_Editor = "${useEditor}";

		    var xmlhttp2 = createXMLHttpRequest();
		    function schedule_get_holiday() {
		        xmlhttp2 = createXMLHttpRequest();
		        var xmlDom = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "COMPANYID", "VIEW");
		        xmlhttp2.open("POST", "/ezSchedule/scheduleGetHoliday.do", true);
		        xmlhttp2.onreadystatechange = event_schedule_get_holiday;
		        xmlhttp2.send(xmlDom);
		    }

		    function event_schedule_get_holiday() {
		        if (xmlhttp2 == null || xmlhttp2.readyState != 4)
		            return;
		        if (xmlhttp2.status >= 200 && xmlhttp2.status < 300) {
		            XmlNodeText = xmlhttp2.responseText;
		            XmlNode = loadXMLString(XmlNodeText);
		            for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
		                if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISUSE")[0].textContent == "1") {
		                    var issolar;
		                    var holiday;
		                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0].textContent == "1")
		                        issolar = "1";
		                    else
		                        issolar = "2";
		                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0].textContent == "1")
		                        holiday = true;
		                    else
		                        holiday = false;
		                    if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0].textContent == "1") {
		                        memorialDays.push(new memorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
                                    GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
                                    GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday));
		                    }
		                    else {
		                        yearmemorialDays.push(new yearmemorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
                                    GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(0, 4),
                                    GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
                                    GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday));
		                    }
		                }
		            }
		            xmlhttp2 = null;
		            CalendarView("Calendar");
		        }
		    }

		    window.onresize = resize;
		    document.onselectstart = function () { return false; };
		    function disablelayer() {
		        newlayer.style.display = "none";
		    }

		    var schedule_receive_attendant_cross_dialogArguments = new Array();

		    window.onload = function () {
		        schedule_get_holiday();
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        if (pDefaultview == 2) {
		            typeCal = 0
		            parent.frames["left"].typeCal = 0

		        }
		        else if (pDefaultview == 1) {
		            typeCal = 1
		            parent.frames["left"].typeCal = 1
		        }
		        else if (pDefaultview == 0) {
		            typeCal = 2
		            parent.frames["left"].typeCal = 2
		        }

		        if (pStartday == 1)
		            DefaultView = 1
		        else
		            DefaultView = 0

				<c:forEach items="${hqList}" var = "item" >
					var hqOpt = document.createElement("option");
					hqOpt.value = "${item.value}";
					hqOpt.text  = "${item.text}";
					document.getElementById("idSelect").add(hqOpt);
				</c:forEach>

				<c:forEach items="${hqList}" var = "item" >
					var secOpt = document.createElement("option");
					secOpt.value = "${item.value}";
					secOpt.text  = "${item.text}";
					document.getElementById("secretarySelect").add(secOpt);
				</c:forEach>

				if (receivecount != "0") {
		            schedule_receive_attendant_cross_dialogArguments[0] = this;
		            schedule_receive_attendant_cross_dialogArguments[1] = windowonload_Complete;
		            var OpenWin = window.open("/myoffice/ezSchedule/schedule_receive_attendant_cross.aspx", "schedule_select_attendant", GetOpenWindowfeature(730, 420));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            windowonload_Complete();
		        }
		    }

		    // aspx.cs에 있던 함수. 2016/08/22 by kgs
            function GetLangData(strLang)
            {
                if (strLang == "1")
                    return "";
                else
                    return strLang;
            }
		    
		    var schedule_receive_member_dialogArguments = new Array();
		    function windowonload_Complete() {
		        if (groupcount != "0") {
		            schedule_receive_member_dialogArguments[0] = this;
		            schedule_receive_member_dialogArguments[1] = windowonload_Complete2;
		            var OpenWin = window.open("/myoffice/ezSchedule/schedule_receive_member.aspx", "schedule_receive_member", GetOpenWindowfeature(730, 420));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            windowonload_Complete2();
		        }
		    }

		    function windowonload_Complete2() {
                  var xmldom = createXmlDom();

		        if (groupxml != "") {
		            var groupxmldom = loadXMLString(groupxml);

		            for (var i = 0; i < groupxmldom.getElementsByTagName("GROUPID").length; i++) {
		                var lastindex = idSelect.length;
		                var newoption = new Option("<spring:message code='ezSchedule.t204'/>" + getNodeText(groupxmldom.getElementsByTagName("GROUPNAME")[i]), getNodeText(groupxmldom.getElementsByTagName("GROUPID")[i]));
		                idSelect.options[lastindex] = newoption;
                    }
                }

		        if ("${_UseGoogleCalrendar}" == "YES" && "${pFlag}" == "Y") {
		            if ("${pGoogleID}" != null) {
                        var lastindex = idSelect.length;
                        var newoption = new Option("<spring:message code='ezSchedule.t400'/>", "GOOGLE");
		                idSelect.options[lastindex] = newoption;
                    }
                }

                if (sharexml != "") {
                    var sharexmldom = loadXMLString(sharexml);

                    for (var i = 0; i < xmldom.getElementsByTagName("OWNERID").length; i++) {
                        var lastindex = idSelect.length;
                        var newoption = new Option("<spring:message code='ezSchedule.t205'/>" + getNodeText(sharexmldom.getElementsByTagName("OWNERNAME")[i]), getNodeText(sharexmldom.getElementsByTagName("OWNERID")[i]));

                        if (getNodeText(sharexmldom.getElementsByTagName("SHAREPERMISSION")[i]) == "R")
                            newoption.onlyread = "1";

                        idSelect.options[lastindex] = newoption;
                    }
                }

		        if (idtype == "G")
		            idSelect.value = groupid;
		        else {
		            if (idtype != "") {
		                if (idtype == "6" || idtype == "8")
		                    idSelect.value = "T";
		                else
		                    idSelect.value = idtype;
		            }
		        }
		        
                if (otherid != "") {
                    secretarySelect.value = otherid;
                }

                var secretaryxmldom = loadXMLString(secretaryxml);

                alert(useprimary);
                for (var i = 0; i < secretaryxmldom.getElementsByTagName("USERID").length; i++) {
                    var lastindex = secretarySelect.length;
                    var newoption = new Option(getNodeText(secretaryxmldom.getElementsByTagName("USERNAME" + GetLangData("${userinfo.primary}"))[i]), getNodeText(secretaryxmldom.getElementsByTagName("USERID")[i]));
                    secretarySelect.options[lastindex] = newoption;

                    if (getNodeText(secretaryxmldom.getElementsByTagName("USERID")[i]) == otherid)
                        secretarySelect.selectedIndex = lastindex;
                }
                //if (parent.frames["left"].document.getElementById("iYear"))
                //    parent.frames["left"].CalendarMiniDataSource();

                resize();
		    }

		    var schedule_read_confirm_cross_dialogArguments = new Array();
		    var srcEl;
		    function ReadSchedule(e) {
		        srcEl = document.getElementById(e);
		        var repeatcount = srcEl.getAttribute("RepeatCount");
		        var datetype = srcEl.getAttribute("DateType");
		        var scheduletype = srcEl.getAttribute("ScheduleType");
		        var scheduleid = srcEl.getAttribute("ScheduleID");
		        var repeatcount = srcEl.getAttribute("RepeatCount");
		        var date = srcEl.getAttribute("StartDate").substring(0, 10);
		        var ret = "0";
		        if (scheduleid.indexOf("GOOGLE") > -1)
		            date = srcEl.getAttribute("StartDate") + "|" + srcEl.getAttribute;

		        if (repeatcount == "Y") {
		            schedule_read_confirm_cross_dialogArguments[0] = "";
		            schedule_read_confirm_cross_dialogArguments[1] = ReadSchedule_Complete;
		            GetOpenWindow("schedule_read_confirm_Cross.aspx", "schedule_read_confirm_Cross", 400, 170);
		        }
		        else {
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 660) / 2;
		            var pLeft = (pwidth - 770) / 2;
		            window.open("schedule_read_Cross.aspx" + "?id=" + encodeURIComponent(scheduleid) + "&otherid=" + escape(otherid) + "&repeatcount=" + repeatcount + "&date=" + date + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + ret, "",
                                "height = 660px, width = 770px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=no");
		        }
		    }

		    function ReadSchedule_Complete(ret) {
		        if (ret == "0" || ret == "1") {
		            var datetype = srcEl.getAttribute("DateType");
		            var scheduletype = srcEl.getAttribute("ScheduleType");
		            var scheduleid = srcEl.getAttribute("ScheduleID");
		            var repeatcount = srcEl.getAttribute("RepeatCount");
		            var date = srcEl.getAttribute("StartDate").substring(0, 10);
		            if (scheduleid.indexOf("GOOGLE") > -1)
		                date = srcEl.getAttribute("StartDate") + "|" + srcEl.getAttribute("EndDate");

		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 660) / 2;
		            var pLeft = (pwidth - 770) / 2;
		            window.open("schedule_read_Cross.aspx" + "?id=" + encodeURIComponent(scheduleid) + "&otherid=" + escape(otherid) + "&repeatcount=" + repeatcount + "&date=" + date + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + ret, "",
					            "height = 660px, width = 770px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=no");
		        }
		        else {
		            return;
		        }
		    }
			
		    function WriteSchedule() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 760) / 2;
		        var pLeft = (pwidth - 790) / 2;
		        if (otherid == "") {
		            var index = idSelect.selectedIndex;
		            if (index == -1)
		                index = 0;

		            if (idSelect.options[idSelect.selectedIndex].onlyread == "1")
		                index = 0;
                    
		            var feature = GetOpenPosition(790, 760);
		            if (CrossYN() || pNoneActiveX == "YES") {
		                window.open("/ezSchedule/scheduleWrite.do?defaultid=" + index, "", "height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            }
		            else {
		                if (pUse_Editor == "" || pUse_Editor == "CK") {
		                    window.open("schedule_write.aspx?defaultid=" + index, "",
						        "height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		                }
		                else {
		                    window.open("schedule_write_IE.aspx?defaultid=" + index, "",
						        "height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		                }
		            }

		        }
		        else {

		            var type = GetAttribute(secretarySelect.options[secretarySelect.selectedIndex], "type") == "user" ? "6" : "8";

		            var feature = GetOpenPosition(790, 760);
		            if (CrossYN() || pNoneActiveX == "YES") {
		                window.open("schedule_write_Cross.aspx?otherid=" + escape(otherid) + "&type=" + type + "&othername=" + escape(secretarySelect.options[secretarySelect.selectedIndex].innerHTML) + "&datetype=2", "",
						    "height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            }
		            else {
		                if (pUse_Editor == "" || pUse_Editor == "CK") {
		                    window.open("schedule_write.aspx?otherid=" + escape(otherid) + "&type=" + type + "&othername=" + escape(secretarySelect.options[secretarySelect.selectedIndex].innerText) + "&datetype=2", "",
						    "height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		                else {
		                    window.open("schedule_write_IE.aspx?otherid=" + escape(otherid) + "&type=" + type + "&othername=" + escape(secretarySelect.options[secretarySelect.selectedIndex].innerText) + "&datetype=2", "",
						    "height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		            }

		        }
		    }
			
		    function WriteDateSchedule(e) {
		        var srcEl;

		        if (CrossYN()) {
		            //srcEl = e.currentTarget ;
		            srcEl = e;
		        }
		        else {
		            srcEl = window.event.srcElement;
		        }

		        var sdate, edate, datetype;

		        if (srcEl.getAttribute("dispDate") == null) {
		            datetype = "1";
		            sdate = srcEl.getAttribute("dispTime");
		            edate = sdate.replace(":00:", ":30:");
		        }
		        else {
		            datetype = "2";
		            sdate = srcEl.getAttribute("dispDate") + " 00:00:00";
		            edate = srcEl.getAttribute("dispDate") + " 23:59:00";
		        }
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 760) / 2;
		        var pLeft = (pwidth - 790) / 2;
		        if (otherid == "") {
		            var index = idSelect.selectedIndex;
		            if (index == -1)
		                index = 0;

		            var feature = GetOpenPosition(790, 760);
		            if (CrossYN() || pNoneActiveX == "YES") {
		                window.open("schedule_write_Cross.aspx?defaultid=" + index + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            }
		            else {
		                if (pUse_Editor == "" || pUse_Editor == "CK") {
		                    window.open("schedule_write.aspx?defaultid=" + index + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		                else {
		                    window.open("schedule_write_IE.aspx?defaultid=" + index + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		            }

		        }
		        else {

		            var type = GetAttribute(secretarySelect.options[secretarySelect.selectedIndex], "type") == "user" ? "6" : "8";
		            var feature = GetOpenPosition(790, 760);
		            if (CrossYN() || pNoneActiveX == "YES") {
		                window.open("schedule_write_Cross.aspx?otherid=" + escape(otherid) + "&type=" + type + "&othername=" + escape(secretarySelect.options[secretarySelect.selectedIndex].innerHTML) + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            }
		            else {
		                if (pUse_Editor == "" || pUse_Editor == "CK") {
		                    window.open("schedule_write.aspx?otherid=" + escape(otherid) + "&type=" + type + "&othername=" + escape(secretarySelect.options[secretarySelect.selectedIndex].innerText) + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		                else {
		                    window.open("schedule_write_IE.aspx?otherid=" + escape(otherid) + "&type=" + type + "&othername=" + escape(secretarySelect.options[secretarySelect.selectedIndex].innerText) + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		            }

		        }
		    }
		    function WriteDateSchedule_left(obj) {
		       
		        var sdate, edate, datetype;
                datetype = "2";
		        sdate = obj.getAttribute("dispDate") + " 00:00:00";
		        edate = obj.getAttribute("dispDate") + " 23:59:00";

		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 760) / 2;
		        var pLeft = (pwidth - 790) / 2;
		        if (otherid == "") {
		            var index = idSelect.selectedIndex - 1;
		            if (index == -1)
		                index = 0;

		            var feature = GetOpenPosition(790, 760);
		            if (CrossYN() || pNoneActiveX == "YES") {
		                window.open("schedule_write_Cross.aspx?defaultid=" + index + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            }
		            else {
		                if (pUse_Editor == "" || pUse_Editor == "CK") {
		                    window.open("schedule_write.aspx?defaultid=" + index + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		                else {
		                    window.open("schedule_write_IE.aspx?defaultid=" + index + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		            }

		        }
		        else {
		            var feature = GetOpenPosition(790, 760);
		            if (CrossYN() || pNoneActiveX == "YES") {
		                window.open("schedule_write_Cross.aspx?otherid=" + escape(otherid) + "&othername=" + escape(secretarySelect.options[secretarySelect.selectedIndex].innerHTML) + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            }
		            else {
		                if (pUse_Editor == "" || pUse_Editor == "CK") {
		                    window.open("schedule_write.aspx?otherid=" + escape(otherid) + "&othername=" + escape(secretarySelect.options[secretarySelect.selectedIndex].innerText) + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		                else {
		                    window.open("schedule_write_IE.aspx?otherid=" + escape(otherid) + "&othername=" + escape(secretarySelect.options[secretarySelect.selectedIndex].innerText) + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		            }

		        }
		    }
				
		    function ViewChange(szCmd) {
		        switch (szCmd.toUpperCase()) {
		            case "DAY":
		                typeCal = 2;
		                parent.frames["left"].typeCal = 2;

		                if (g_selTDID != null && g_selTDID != "") {
		                    sDate = new Date(g_selTDID.substring(7, 11), parseInt(g_selTDID.substring(12, 14)) - 1, parseInt(g_selTDID.substring(15, 17)));
		                }

		                parent.frames["left"].sDate = sDate;
		                var ItemID = "TDMINI_" + sDate.getFullYear() + "-" + leadingZeros(sDate.getMonth() + 1, 2) + "-" + leadingZeros(sDate.getDate(), 2) + "_Day";

		                var item = parent.frames["left"].document.getElementById(ItemID);
		                if (item)
		                    item.onclick();
		                else
		                    CalendarView("Calendar");

		                break;
		                // 주보기		
		            case "WEEK":
		                typeCal = 1;
		                parent.frames["left"].typeCal = 1;

		                if (g_selTDID != null && g_selTDID != "") {
		                    sDate = new Date(g_selTDID.substring(7, 11), parseInt(g_selTDID.substring(12, 14)) - 1, parseInt(g_selTDID.substring(15, 17)));
		                }

		                parent.frames["left"].sDate = sDate;
		                var ItemID = "TDMINI_" + sDate.getFullYear() + "-" + leadingZeros(sDate.getMonth() + 1, 2) + "-" + leadingZeros(sDate.getDate(), 2) + "_Day";

		                var item = parent.frames["left"].document.getElementById(ItemID);
		                if (item)
		                    item.onclick();
		                else
		                    CalendarView("Calendar");
		                break;

		            case "MONTH":
		                typeCal = 0;
		                parent.frames["left"].typeCal = 0;
		                var ItemID = "TDMINI_" + sDate.getFullYear() + "-" + leadingZeros(sDate.getMonth() + 1, 2) + "-" + leadingZeros(sDate.getDate(), 2) + "_Day";

		                var item = parent.frames["left"].document.getElementById(ItemID);
		                if (item)
		                    item.onclick();

		                CalendarView("Calendar");

		                break;
		        }
		        DateChange(szCmd);

		    }

		    function DateChange(szCmd) {
		        switch (szCmd) {
		            case "DAY":
		                szCmd = <spring:message code='ezSchedule.t140'/>;
		                break;
		            case "WEEK":
		                szCmd = <spring:message code='ezSchedule.t141'/>;
		                break;
		            case "MONTH":
		                szCmd = <spring:message code='ezSchedule.t142'/>;
		                break;
		        }

		        alert(szCmd);
		        titleimg.innerHTML = szCmd;

		    }
			
		    function RefreshView() {
		        CalendarView('Calendar');
		        if (parent.frames["left"].document.getElementById("iYear")) {
		            parent.frames["left"].CalendarMiniView("CalendarMini");
		            parent.frames["left"].CalendarMiniDataSource();
		        }
		    }
			
		    function IDChange() {
		        if (idSelect.value == "GOOGLE") {
		            parent.frames["left"].idtype = idSelect.value;
		            parent.frames["left"].idlist = "";
		            parent.frames["left"].CalendarMiniView("CalendarMini")
		            window.location.href = "schedule_main_Cross.aspx?idtype=" + idSelect.value;
		        }
		        else {
		            if (idSelect.value != "T" && idSelect.value != "P" && idSelect.value != "D" && idSelect.value != "C") {
		                parent.frames["left"].idtype = idSelect.value;
		                parent.frames["left"].idlist = "G";
		                parent.frames["left"].groupid = idSelect.value;
		                parent.frames["left"].CalendarMiniView("CalendarMini")
		                window.location.href = "schedule_main_Cross.aspx?idtype=G&groupid=" + idSelect.value;
		            }		         
		            else {
		                parent.frames["left"].idtype = idSelect.value;
		                parent.frames["left"].idlist = "";
		                parent.frames["left"].CalendarMiniView("CalendarMini")
		                window.location.href = "schedule_main_Cross.aspx?idtype=" + idSelect.value;
		            }
		        }
		    }

		    function IDClick(type) {
		        parent.frames["left"].idtype = type;
		        document.getElementById("idSelect").value = type;
		        parent.frames["left"].idlist = "";
		        parent.frames["left"].CalendarMiniView("CalendarMini")
		        window.location.href = "schedule_main_Cross.aspx?idtype=" + type;
		    }

		    function SecretaryChange() {
		        if (secretarySelect.value == "")
		            window.location.href = "schedule_main_Cross.aspx";
		        else {
		            var type = secretarySelect.options[secretarySelect.selectedIndex].getAttribute("type") == "user" ? "6" : "8";
		            window.location.href = "schedule_main_Cross.aspx?idtype=" + type + "&otherid=" + escape(secretarySelect.value);
		        }
		        parent.frames["left"].idtype = type;
		        parent.frames["left"].idlist = escape(secretarySelect.value);
		        parent.frames["left"].CalendarMiniView("CalendarMini");
		        parent.frames["left"].CalendarMiniDataSource();
		    }
			
			var sScheduleID, sScheduleChangeKey, sParentID, sOwnerID, sCreatorID, sModifierID, sScheduleType, sImportance;
			var sIsReadOnly, sDateType, sSubject, sLocation, sRepeatCount;
            var sTitle,sWriter, sDuration;

            function SelectSchedule(e) {
                var srcEl;

                if (CrossYN()) {
                    srcEl = e;
                }
                else {
                    srcEl = window.event.srcElement;
                }

                if (!srcEl.getAttribute("ScheduleID"))
                    srcEl = srcEl.parentElement.parentElement.parentElement;

                sScheduleID = srcEl.getAttribute("ScheduleID");
                sScheduleChangeKey = srcEl.getAttribute("ScheduleChangeKey");
                sParentID = srcEl.getAttribute("ParentID");
                sOwnerID = srcEl.getAttribute("OwnerID");
                sCreatorID = srcEl.getAttribute("CreatorID");
                sModifierID = srcEl.getAttribute("ModifierID");
                sScheduleType = srcEl.getAttribute("ScheduleType");
                sImportance = srcEl.getAttribute("Importance");
                sIsReadOnly = srcEl.getAttribute("IsReadOnly");
                sDateType = srcEl.getAttribute("DateType");
                sSubject = srcEl.getAttribute("Subject");
                sLocation = srcEl.getAttribute("Location");
                sRepeatCount = srcEl.getAttribute("RepeatCount");
            }

            function MouseOverSchedule() {
                sTitle = event.title;
                sWriter = event.writer;
                sDuration = event.duration;
            }
			
			
            function PrintSchedule() {
                var year = sStartDate.split("-")[0];
                var month = sStartDate.split("-")[1];
                var day = sStartDate.split("-")[2];
                var view = typeCal;
                var date = year + "-" + month + "-" + day;
                if (idlist == "")
                    idlist = idtype;
                var feature = GetOpenPosition(837, 660);
                if (idlist == "G")
                    window.open("schedule_print.aspx?idlist=" + escape(idlist) + "&date=" + date + "&view=" + view + "&APP=" + idtype + "&groupid=" + groupid, "", "height = 660px, width = 837px, status = no, toolbar=no, menubar=no, location=no, resizable=0" + feature);
                else
                    window.open("schedule_print.aspx?idlist=" + escape(idlist) + "&date=" + date + "&view=" + view + "&APP=" + idtype, "", "height = 660px, width = 837px, status = no, toolbar=no, menubar=no, location=no, resizable=0" + feature);
            }
			
            var schedule_repetition_del_dialogArugment = new Array();
            function DeleteSchedule() {
                if (sScheduleID == null) {
                    alert("<spring:message code='ezSchedule.t207'/>");
                    return;
                }

                if (sOwnerID != userid && sOwnerID != otherid && sCreatorID != userid && sCreatorID != otherid &&
					sModifierID != userid && sModifierID != userid && (sScheduleType != "2" || deptadmin != "Y" || sOwnerID != deptid) &&
					(sScheduleType != "3" || companyadmin != "Y") || sIsReadOnly == "Y") {
                    alert("<spring:message code='ezSchedule.t208'/>");
                    return;
                }

                if (!confirm("<spring:message code='ezSchedule.t209'/>"))
                    return;

                if (sRepeatCount == "Y") {
                    schedule_repetition_del_dialogArugment[0] = "";
                    schedule_repetition_del_dialogArugment[1] = DeleteSchedule_Complete;
                    window.open("/myoffice/ezSchedule/htm/schedule_repetition_del.aspx", "schedule_repetition_del", GetOpenWindowfeature(390, 235));
                }
                else {
                    var xmlHTTP = createXMLHttpRequest();
                    var xmlDom = createXmlDom();

                    var objNode;
                    createNodeInsert(xmlDom, objNode, "DATA");
                    createNodeAndInsertText(xmlDom, objNode, "SCHEDULEID", sScheduleID);
                    createNodeAndInsertText(xmlDom, objNode, "SCHEDULETYPE", sScheduleType);
                    createNodeAndInsertText(xmlDom, objNode, "OTHERID", otherid);
                    createNodeAndInsertText(xmlDom, objNode, "DATETYPE", sDateType);
                    createNodeAndInsertText(xmlDom, objNode, "PATTERN", "0");
                    createNodeAndInsertText(xmlDom, objNode, "REPEATCOUNT", sRepeatCount);

                    xmlHTTP.open("POST", "remote/schedule_delete.aspx", false);
                    xmlHTTP.send(xmlDom);

                    if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
                        alert("<spring:message code='ezSchedule.t212'/>");
                    else {
                        alert("<spring:message code='ezSchedule.t213'/>");
                        RefreshView();
                    }
                    sScheduleID = null;
                }
            }

		    function DeleteSchedule_Complete(rgParams) {
		        if (rgParams["CancelOpen"] == true || rgParams["InstanceType"] == "")
		            return;

		        if (rgParams["InstanceType"] == "Instance" || rgParams["InstanceType"] == "Master") {
		            var xmlHTTP = createXMLHttpRequest();
		            var xmlDom = createXmlDom();

		            var objNode;
		            createNodeInsert(xmlDom, objNode, "DATA");
		            createNodeAndInsertText(xmlDom, objNode, "SCHEDULEID", sScheduleID);
		            createNodeAndInsertText(xmlDom, objNode, "SCHEDULETYPE", sScheduleType);
		            createNodeAndInsertText(xmlDom, objNode, "DATETYPE", "3");

		            if (rgParams["InstanceType"] == "Instance") {
		                createNodeAndInsertText(xmlDom, objNode, "PATTERN", 0);
		            }
		            else if (rgParams["InstanceType"] == "Master") {
		                createNodeAndInsertText(xmlDom, objNode, "PATTERN", 1);
		            }
		            createNodeAndInsertText(xmlDom, objNode, "OTHERID", otherid);
		            createNodeAndInsertText(xmlDom, objNode, "REPEATCOUNT", sRepeatCount);


		            xmlHTTP.open("POST", "remote/schedule_delete.aspx", false);
		            xmlHTTP.send(xmlDom);

		            if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
		                alert("<spring:message code='ezSchedule.t212'/>");

                        }
                        else {
                            alert("<spring:message code='ezSchedule.t213'/>");
                            delFlag = true;
                            RefreshView();
                        }
		        }
		        sScheduleID = null;
		    }

		    function show_personinfo(userid) {
		        var feature = GetOpenPosition(420, 450);
		        window.open("/myoffice/common/ShowPersonInfo.aspx?id=" + userid, "",
				    "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }

		    function open_schedule(scheduleid) {
		        var feature = GetOpenPosition(770, 660);
		        window.open("schedule_read_Cross.aspx?id=" + encodeURIComponent(scheduleid), "",
					"height = 660px, width = 770px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }

		    function ShowSchedule() {
		        showDiv.style.display = 'none';
		    }
			
		    function EditSchedule(scheduleid, e) {
		        var eAppt;
		        var event = document.getElementById(e);

		        eAppt = event;


		        var scheduleid = eAppt.getAttribute("ScheduleID");
		        var schedulechangekey = eAppt.getAttribute("ScheduleChangeKey");
		        var scheduletype = eAppt.getAttribute("ScheduleType");

		        var repeatcount = eAppt.getAttribute("RepeatCount");
		        var date = eAppt.getAttribute("StartDate").substr(0, 10);

		        showId.value = scheduleid;
		        showChangeKey.value = schedulechangekey;
		        showLocation.innerHTML = eAppt.getAttribute("Location");
		        showTitle.value = eAppt.getAttribute("Subject");
		        showType.value = scheduletype;

		        if (eAppt.DateType == 2)
		            showTime.innerHTML = strLang39;
		        else
		            showTime.innerHTML = eAppt.getAttribute("dtstartDisplay") + " - " + eAppt.getAttribute("dtendDisplay");

		        showDiv.style.display = 'none';

		        if (showDiv.style.display == 'block') {
		            if (scheduleid == showId.value) {
		                showDiv.style.display = 'none';
		                return;
		            }
		        }

		        var ex_obj = document.getElementById('showDiv');
		        this.x = event.clientX + (document.documentElement.scrollLeft ? document.documentElement.scrollLeft : document.body.scrollLeft);
		        this.y = event.clientY + (document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop);

		        ex_obj.style.left = x;
		        ex_obj.style.top = y + 10;
		        ex_obj.style.display = 'block';
		    }
			
		    function showUpdate(cmd) {
		        if (showId.value == "") {
		            return;
		        }

		        if (cmd != "EDIT") {
		            if (!confirm("<spring:message code='ezSchedule.t209'/>"))
		                return;
		        }

		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDom = createXmlDom();

		        var objNode;
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "SCHEDULEID", showId.value);
		        createNodeAndInsertText(xmlDom, objNode, "SCHEDULECHANGEKEY", showChangeKey.value);
		        createNodeAndInsertText(xmlDom, objNode, "SCHEDULETYPE", showType.value);
		        createNodeAndInsertText(xmlDom, objNode, "TITLE", showTitle.value);
		        createNodeAndInsertText(xmlDom, objNode, "COMMAND", cmd);

		        xmlHTTP.open("POST", "remote/schedule_SimpleEdit.aspx", false);
		        xmlHTTP.send(xmlDom);

		        if (cmd == "EDIT") {
		            if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
		                alert(strLang17);
		            else {
		                alert(strLang18);
		                RefreshView();
		            }
		        }
		        else {
		            if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
		                alert("<spring:message code='ezSchedule.t212'/>");
		            else {
		                alert("<spring:message code='ezSchedule.t213'/>");
		                RefreshView();
		            }
		        }

		        showTitle.value = "";
		        showId.value = "";
		        showChangeKey.value = "";
		        showType.value = "";
		        showLocation.innerHTML = "";
		        showTime.innerHTML = "";
		        showDiv.style.display = "none";
		        return;
		    }

		    function j_MoveToSelectedDate(j_kind, j_movNum, j_dateStr) {
		        var returnStr = v_MoveToSelectedDate(j_kind, j_movNum, j_dateStr);
		        return returnStr;
		    }
            
		    function resize() {

		        if (typeCal == "2")
		            var w = document.documentElement.clientHeight - 275;
		        else if (typeCal == "1")
		            var w = document.documentElement.clientHeight - 305;
		        else
		            return;

		        var objDiv = document.getElementById('CalDiv');
		        if (objDiv) {
		            objDiv.style.height = w + "px";
		        }
		    }
            
		    function newSchedule_onclick(e) {
		        var srcEl;

		        if (CrossYN()) {
		            srcEl = e.currentTarget;
		        }
		        else {
		            srcEl = window.event.srcElement;
		        }

		        var selsd = "", seled = "";

		        if (srcEl.dispDate == null) {
		            if (srcEl.dispTime != null) {
		                selsd = idCalendarControl.fullyear() + "-" + v_AppendZero(idCalendarControl.month() + 1) + "-" + v_AppendZero(idCalendarControl.day()) + " " + srcEl.dispTime;
		                seled = selsd.replace(":00:", ":30:");
		            }
		        }
		        else {
		            selsd = srcEl.dispDate;
		            seled = srcEl.dispDate;
		        }

		        WriteSchedule();
		    }

        </script>
		
	<script type="text/javascript">
	
	    function v_MoveToSelectedDate(v_kind, v_movNum, v_dateStr) {
	        var tmpdt = new Date(v_dateStr);
	        switch (v_kind) {
	            case 'd':
	                tmpdt.setDate(tmpdt.getDate() + v_movNum);
	                break;
	            case 'm':
	                tmpdt.setMonth(tmpdt.getMonth() + v_movNum);
	                break;
	            case 'y':
	                tmpdt.setFullYear(tmpdt.getFullYear() + v_movNum);
	                break;
	        }

	        return tmpdt.getFullYear().toString(10) + '-' + (tmpdt.getMonth() + 1).toString() + '-' + tmpdt.getDate().toString(10) + ' ' + tmpdt.toTimeString().substring(0, 8);
	    }

	    function v_GetChangedDateTime2_nonIE(v_dateTime, hourNum, minuteNum) {
	        return (navigator.userAgent.indexOf('Firefox') != -1) ?
    (function (v_dateTime, hourNum, minuteNum) {
        var dt = new Date(v_dateTime);  // v_dateTime : UTC 형태 yyyy-MM-ddTHH:mm:ss.fffZ

        var offset = dt.getTimezoneOffset(); // 분

        var dt2 = new Date(dt.getTime() + (offset + (hourNum * 60) + minuteNum) * 60 * 1000);

        return dt2.getFullYear().toString(10) + '-' + v_AppendZero(dt2.getMonth() + 1) + '-' + v_AppendZero(dt2.getDate()) + ' ' + dt2.toTimeString().substring(0, 8);
    }).call(this, v_dateTime, hourNum, minuteNum)
    : (navigator.userAgent.indexOf('MSIE') == -1) ?
    (function (v_dateTime, hourNum, minuteNum) {
        var dt = new Date(
        Date.UTC(
        parseInt(v_dateTime.substring(0, 4), 10), // yyyy
        parseInt(v_dateTime.substring(5, 7), 10) - 1, // MM
        parseInt(v_dateTime.substring(8, 10), 10), // dd
        parseInt(v_dateTime.substring(11, 13), 10), // HH
        parseInt(v_dateTime.substring(15, 17), 10), // mm
        parseInt(v_dateTime.substring(18, 20), 10), // ss
        parseInt(v_dateTime.substring(21, 24), 10) // fff
        ))

        var offset = dt.getTimezoneOffset(); // 분

        var dt2 = new Date(dt.getTime() + (offset + (hourNum * 60) + minuteNum) * 60 * 1000);

        return dt2.getFullYear().toString(10) + '-' + v_AppendZero(dt2.getMonth() + 1) + '-' + v_AppendZero(dt2.getDate()) + ' ' + dt2.toTimeString().substring(0, 8);
    }).call(this, v_dateTime, hourNum, minuteNum)
    :
    (function (v_dateTime, hourNum, minuteNum) {
    }).call(this, v_dateTime, hourNum, minuteNum)
	        ;
	    }

	    function v_AppendZero(v_str) {
	        if (isNaN(v_str)) {
	            switch (v_str.toString().length) {
	                case 0:
	                    return "00";
	                case 1:
	                    return "0" + v_str.toString();
	                default:
	                    return v_str.toString();
	            }
	        }

	        if (v_str < 10) {
	            return "0" + v_str.toString();
	        }

	        return v_str.toString();
	    }
    
    </script>

    <script type="text/vbscript">
    
    Public Function v_MoveToSelectedDate( v_kind, v_movNum, v_dateStr )
	    dim returnStr
	    Select Case v_kind
		    Case "d" :
			    returnStr = DateAdd("d", v_movNum, v_dateStr)
		    Case "m" :
			    returnStr = DateAdd("m", v_movNum, v_dateStr)
		    Case "y" :
			    returnStr = DateAdd("yyyy", v_movNum, v_dateStr)
	    End Select
    	
	    returnStr = DatePart("yyyy", returnStr) & "-" & DatePart("m", returnStr) & "-" & DatePart("d", returnStr) & " " & DatePart("h", returnStr) & ":00:00"
	    v_MoveToSelectedDate = returnStr
    End Function
	
    Public Function v_GetChangedDateTime( v_dateTime )
	    dim returnStr, y, m, d, h, n, s

	    returnStr = CDate(v_dateTime)
	    returnStr = DateAdd( "h", 9, returnStr )

	    y = DatePart("yyyy", returnStr)
	    m = DatePart("m", returnStr)
	    d = DatePart("d", returnStr)
	    h = DatePart("h", returnStr)
	    n = DatePart("n", returnStr)
	    s = DatePart("s", returnStr)

	    v_dateTime = y & "-" & v_AppendZero(m) & "-" & v_AppendZero(d) & " "
	    v_dateTime = v_dateTime & v_AppendZero(h) & ":" & v_AppendZero(n) & ":" & v_AppendZero(s)

	    v_GetChangedDateTime = v_dateTime
    End Function

    Public Function v_GetChangedDateTime2( v_dateTime, hourNum, minuteNum )
	    dim returnStr, y, m, d, h, n, s

	    returnStr = CDate(v_dateTime)
	    returnStr = DateAdd( "h", hourNum, returnStr )
	    returnStr = DateAdd( "n", minuteNum, returnStr )
    	
	    y = DatePart("yyyy", returnStr)
	    m = DatePart("m", returnStr)
	    d = DatePart("d", returnStr)
	    h = DatePart("h", returnStr)
	    n = DatePart("n", returnStr)
	    s = DatePart("s", returnStr)
    	
	    v_dateTime = y & "-" & v_AppendZero(m) & "-" & v_AppendZero(d) & " "
	    v_dateTime = v_dateTime & v_AppendZero(h) & ":" & v_AppendZero(n) & ":" & v_AppendZero(s)
    	
	    v_GetChangedDateTime2 = v_dateTime
    End Function

    Public Function v_GetChangedDateTime( v_dateTime )
	    dim returnStr, y, m, d, h, n, s
    	
	    returnStr = CDate(v_dateTime)
	    returnStr = DateAdd( "h", 9, returnStr )
    	
	    y = DatePart("yyyy", returnStr)
	    m = DatePart("m", returnStr)
	    d = DatePart("d", returnStr)
	    h = DatePart("h", returnStr)
	    n = DatePart("n", returnStr)
	    s = DatePart("s", returnStr)
    	
	    v_dateTime = y & "-" & v_AppendZero(m) & "-" & v_AppendZero(d) & " "
	    v_dateTime = v_dateTime & v_AppendZero(h) & ":" & v_AppendZero(n) & ":" & v_AppendZero(s)
    	
	    v_GetChangedDateTime = v_dateTime
    End Function

    Public Function v_AppendZero( v_str )
	    if Len(v_str) = 0 then
		    v_str = "00"
	    elseif Len(v_str) = 1 then
		    v_str = "0" & v_str
	    end if
    	
	    v_AppendZero = v_str
	End Function
	
	</script>
		
	</HEAD>
	<body class="mainbody"  style=" overflow: auto">
        <h1 id="titleimg">${defaultTitle}</h1>
        <div id="mainmenu"  >
            <ul>
              <li><span id="pn_img" onClick="WriteSchedule()"><spring:message code='ezSchedule.t214'/></span></li>
              <li><span onclick='ViewChange("DAY");'><spring:message code='ezSchedule.t140'/></span></li>
              <li><span onclick='ViewChange("WEEK");'><spring:message code='ezSchedule.t141'/></span></li>
              <li><span onclick='ViewChange("MONTH");'><spring:message code='ezSchedule.t142'/></span></li>
		      <li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
              <li><span onClick="PrintSchedule()"><spring:message code='ezSchedule.t217'/></span></li>
              <li><span onClick="RefreshView()"><spring:message code='ezSchedule.t218'/></span></li>
              <li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li>
              <li style="background:none;padding:0"><select class="select" id="idSelect" onChange="IDChange()" style="width:140px">
									            <option value="T"><spring:message code='ezSchedule.t220'/></option>
									            <option value="P" selected><spring:message code='ezSchedule.t221'/></option>
									            <option value="D"><spring:message code='ezSchedule.t222'/></option>
									            <option value="C"><spring:message code='ezSchedule.t223'/></option>									            
								            </select></li>
              <li style="background:none;padding:0;"><select class="select" onChange="SecretaryChange()" id="secretarySelect" name="secretarySelect">
									            <option value="" selected><spring:message code='ezSchedule.t224'/></option>
								            </select></li>
								            <li onClick="IDClick('P')" style="background:none;cursor:pointer"><span style="display:inline-block; width:11px; height:11px; border:1px solid #017ddf; background:#018bfa; overflow:hidden; margin:7px 0px 0px 0px; padding:0; vertical-align:middle;"></span>&nbsp;<spring:message code='ezSchedule.t221'/></li>
								            <li onClick="IDClick('D')" style="background:none;cursor:pointer"><span style="display:inline-block; width:11px; height:11px; border:1px solid #049c37; background:#01b43f; overflow:hidden; margin:7px 0px 0px 0px; padding:0; vertical-align:middle;"></span>&nbsp;<spring:message code='ezSchedule.t222'/></li>
								            <li onClick="IDClick('C')" style="background:none;cursor:pointer"><span style="display:inline-block; width:11px; height:11px; border:1px solid #e01662; background:#ff1c71; overflow:hidden; margin:7px 0px 0px 0px; padding:0; vertical-align:middle;"></span>&nbsp;<spring:message code='ezSchedule.t223'/></li>
            </ul>
        </div>

        <script type="text/javascript">
            selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
        </script>

        <table>   
                <tr>
                    <td style="vertical-align:top;width:100%;">
                        <DIV  style="vertical-align:top;" id="Calendar"></DIV>
                    </td>
                    <td style="vertical-align:top;width:10px">&nbsp;</td>
</tr></table>
                
		<br />
		<div id="showDiv" style="display:none;position:absolute;background-color:white;">
		    <table style="width:200px;height:60px;margin:1px;border:1px solid #b6b6b6" class="popuplist" >
		        <tr>    
		            <th style="height:20px; width:30%" align=center><img src="/images/bt_edit.gif" onclick="showUpdate('EDIT')" style="cursor: pointer;" />&nbsp;
		            <img src="/images/bt_del.gif" onclick="showUpdate('DEL')" style="cursor: pointer;"/>
		            </th>
		            <td style="width:70%"><input type="text" id="showTitle" /><input type="hidden" id="showId" /><input type="hidden" id="showChangeKey" /><input type="hidden" id="showType" /> </td>
		        </tr>
		        <tr>    
		            <th style="height:20px; width:30%; text-align:center"><spring:message code='ezSchedule.t313'/></th>
		            <td style="width:70%" id="showLocation"></td>
		        </tr>
		        <tr>    
		            <th style="height:20px; width:30%" align=center><spring:message code='ezSchedule.t312'/></th>
		            <td style="width:70%" id="showTime"></td>
		        </tr>
		    </table>
		</div>
	</body>
</HTML>