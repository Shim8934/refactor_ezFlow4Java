<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t241" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<link type="text/css" rel="stylesheet" href="/css/Tab.css" />
		<link type="text/css" rel="stylesheet" href="/css/olstyle_nonIE.css" />
		<link type="text/css" rel="stylesheet" href="/css/Calendar_cross.css" />
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezResource/CalendarDataPro_Cross.js"></script>
		<script type="text/javascript" src="/js/ezResource/CalendarView_Cross.js"></script>
		<script type="text/javascript" src="/js/ezResource/CalendarMini_Cross.js"></script>
		<script type="text/javascript" src="<spring:message code='ezResource.e1'/>"></script>
		<script type="text/javascript" src="/js/ezResource/calendar_cross.js"></script>
		<script type="text/javascript" src="/js/Holiday.js"></script>
		<script type="text/javascript">
		var timeZoneStr = "${timeZoneStr}";
	    var pAdminFg = "${adminFg}";
	    var pBrd_Access = "${brdAccess}";
	    
	    if(pAdminFg == "") {
	        window.location.href = "/ezResource/nonResList.do?msg=" + pBrd_Access;
	    }
	    var pUserID    = "${userInfo.id}";
	    var pCompanyID = "${userInfo.companyID}";
	    var ApproveFlag     = "${approveFlag}";
	    var brd_NM = "<c:out value='${brdNm}' />";
	    var ResID = "${resID}";
	    var pDisplaySTime = "${displaySTIME}";
	    var pDisplayETime = "${displayETIME}";
		var uselang = "${userInfo.primary}";  
		var folder_Url = "/ezResource/scheduleGet.do";
	    var p_Type = "";
	    var pBrdid = "${resID}";
	    var title_name = new Array();
	    title_name[0] = pBrdid + "/" + "<c:out value='${brdNm}' />";
	    var pUse_Editor = "${useEditor}";
	    var pNoneActiveX = "${nonActiveX}";
	    var pStartday = "7";
	    var LunarUse = false;
	    
	    document.onselectstart = function () { return false; };
		
	    select_memorialDays("${userInfo.lang}");
	    
	    var xmlhttp2 = createXMLHttpRequest();
	    function schedule_get_holiday() {
	        xmlhttp2 = createXMLHttpRequest();
	        xmlhttp2.open("POST", "/ezSchedule/scheduleGetHoliday.do?COMPANYID=VIEW", true);
	        xmlhttp2.onreadystatechange = event_schedule_get_holiday;
	        xmlhttp2.send();
	    }

	    function event_schedule_get_holiday() {
	        if (xmlhttp2 == null || xmlhttp2.readyState != 4)
	            return;
	        if (xmlhttp2.status >= 200 && xmlhttp2.status < 300) {
	            XmlNodeText = xmlhttp2.responseText;
	            XmlNode = loadXMLString(XmlNodeText);
	            for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
	                if (getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISUSE")[0]) == "1") {
	                    var issolar;
	                    var holiday;
	                    if (getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0]) == "1")
	                        issolar = "1";
	                    else
	                        issolar = "2";
	                    if (getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0]) == "1")
	                        holiday = true;
	                    else
	                        holiday = false;
	                    if (getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0]) == "1") {
	                        memorialDays.push(new memorialDay(getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0]), getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0]),
	                            getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0]).substring(0, 10).substring(5, 7),
	                            getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0]).substring(0, 10).substring(8, 10), issolar, holiday));
	                    }
	                    else {
	                        yearmemorialDays.push(new yearmemorialDay(getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0]), getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0]),
	                            getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0]).substring(0, 10).substring(0, 4),
	                            getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0]).substring(0, 10).substring(5, 7),
	                            getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0]).substring(0, 10).substring(8, 10), issolar, holiday));
	                    }
	                }
	            }
	            xmlhttp2 = null;
	            CalendarMiniView("CalendarMini");
	            CalendarView("Calendar");
	        }
	    }
		
	    function schedule_get_lunaruse() {
	        xmlhttp = createXMLHttpRequest();
	        var xmlDom = createXmlDom();
	        var objNode;

	        var xmlpara = createXmlDom();
	        var objNode;
	        createNodeInsert(xmlpara, objNode, "DATA");
	        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", "${userInfo.companyID}");

	        xmlhttp.open("POST", "/ezSchedule/scheduleGetLunarUse.do", true);
	        xmlhttp.onreadystatechange = event_schedule_get_lunaruse;
	        xmlhttp.send(xmlpara);
	    }

	    function event_schedule_get_lunaruse() {
	        if (xmlhttp == null || xmlhttp.readyState != 4)
	            return;

	        if (xmlhttp.responseText == "0")
	            LunarUse = true;
	        else if (xmlhttp.responseText == "1")
	            LunarUse = true;
	        else
	            LunarUse = false;

	        schedule_get_holiday();
	    }
	    
	    window.onload = function () {
	    	if (pStartday == 1)
	            DefaultView = 1;
	        else
	            DefaultView = 0;
	    	
	        schedule_get_lunaruse();     
	        if (navigator.userAgent.indexOf('Firefox') != -1) {
	            document.body.style.MozUserSelect = 'none';
	            document.body.style.WebkitUserSelect = 'none';
	            document.body.style.khtmlUserSelect = 'none';
	            document.body.style.oUserSelect = 'none';
	            document.body.style.UserSelect = 'none';
	        }
	        
	        Window_resize();
	    }
	    window.onresize = Window_resize;
	    
	    function Window_resize() {
	        if (typeCal == "2")
	            var w = document.documentElement.clientHeight - 278;
	        else if (typeCal == "1")
	            var w = document.documentElement.clientHeight - 308;

	        var objDiv = document.getElementById('CalDiv');
	        if (objDiv)
	            objDiv.style.height = w + "px";

	        var objRInfo = document.getElementById('ResourceInfo');
	        if (objRInfo)
	            objRInfo.style.height = document.documentElement.clientHeight - 376 + "px";
	    }

	    function btnDel_onclick() {
	        DeleteAppointment();
	        return;
	    }

	    function btnRefresh_onclick() {

	        RefreshMessageList();
	        CalendarMiniView("CalendarMini");
	    }

	    function j_MoveToSelectedDate(j_kind, j_movNum, j_dateStr) {
	        var returnStr = v_MoveToSelectedDate(j_kind, j_movNum, j_dateStr);
	        return returnStr;
	    }

	    function allday_OnDateChange() {
	    }

	    function MemberInfo_onClick(pSelUserID) {
	        if (pSelUserID != "") {
	            var feature = GetOpenPosition(420, 438);
	            window.open("/ezCommon/showPersonInfo.do?id=" + pSelUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        }
	    }

	    function newSchedule_onclick(e) {
	        var srcEl;

	        if (CrossYN()) {
	            srcEl = e.currentTarget;
	        } else {
	            srcEl = window.event.srcElement;
	        }
	        var selsd = "", seled = "";

	        if (GetAttribute(srcEl,"dispDate") == null) {
	            if (GetAttribute(srcEl,"dispTime") != null) {

	                selsd = GetAttribute(srcEl,"dispTime");
	                seled = selsd.replace(":00:", ":30:");
	            }
	        } else {
	            selsd = GetAttribute(srcEl,"dispDate");
            	seled = GetAttribute(srcEl,"dispDate");
	        }
	        var feature = GetOpenPosition(820, 700);
	        if (CrossYN() || pNoneActiveX == "YES") {
	        	window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + selsd + "&seled=" + seled + "&dayView=&ownerID=${resID}&brdName=" + encodeURIComponent("<c:out value='${brdNm}' />"), "", "width=820, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        } else {
	            if (pUse_Editor == "" || pUse_Editor == "CK") {
	                window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + selsd + "&seled=" + seled + "&dayView=&ownerID=${resID}&brdName=" + encodeURIComponent("<c:out value='${brdNm}' />"), "", "width=770, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	            } else {
	                window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + selsd + "&seled=" + seled + "&dayView=&ownerID=${resID}&brdName=" + encodeURIComponent("<c:out value='${brdNm}' />"), "", "width=770, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	            }
	        }
	    }

	    function btnApprov_list() {
	        window.location.href = "/ezResource/scheduleApprovList.do?resID=" + pBrdid + "&startDate=" + sStartDate + "&endDate=" + sEndDate;
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
	                var dt = new Date(v_dateTime);

	                var offset = dt.getTimezoneOffset(); // 분

	                var dt2 = new Date(dt.getTime() + (offset + (hourNum * 60) + minuteNum) * 60 * 1000);

	                return dt2.getFullYear().toString(10) + '-' + v_AppendZero(dt2.getMonth() + 1) + '-' + v_AppendZero(dt2.getDate()) + ' ' + dt2.toTimeString().substring(0, 8);
	            }).call(this, v_dateTime, hourNum, minuteNum)
	            : (CrossYN()) ?
	            (function (v_dateTime, hourNum, minuteNum) {
	                var dt = new Date(
	                Date.UTC(
	                parseInt(v_dateTime.substring(0, 4), 10),
	                parseInt(v_dateTime.substring(5, 7), 10) - 1,
	                parseInt(v_dateTime.substring(8, 10), 10),
	                parseInt(v_dateTime.substring(11, 13), 10),
	                parseInt(v_dateTime.substring(14, 16), 10),
	                parseInt(v_dateTime.substring(17, 19), 10),
	                parseInt(v_dateTime.substring(20, 23), 10)
	                ))

	                var offset = dt.getTimezoneOffset();

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
	        
	        function btnform_onclick() {
	            var feature = GetOpenPosition(700, 700);
	            if (CrossYN() || pNoneActiveX == "YES") {
	                window.open("/ezResource/scheduleManageForm.do?resID=${resID}&brdName=" + encodeURIComponent("<c:out value='${brdNm}' />"), "", "width=700px, height=700px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	            } else {
	                if (pUse_Editor == "" || pUse_Editor == "CK") {
	                    window.open("/ezResource/scheduleManageForm.do?resID=${resID}&brdName=" + encodeURIComponent("<c:out value='${brdNm}' />"), "", "width=700, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	                } else {
	                    window.open("/ezResource/scheduleManageForm.dor?resID=${resID}&brdName=" + encodeURIComponent("<c:out value='${brdNm}' />"), "", "width=700, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	                }
	            }
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
	</head>
	<body class="mainbody" style="overflow: auto;" id="BodyTop">
		<h1><span id="titleimg"></span> <c:out value='${brdNm}' /></h1>
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div id="mainmenu">
  			<ul>
    			<li><span id="pn_img" onClick="newSchedule_onclick(event)"><spring:message code='ezResource.t171'/></span></li>
    			<li><span onclick='onViewDate("DAY");'><spring:message code='ezResource.t251'/></span></li>
    			<li><span onclick='onViewDate("WEEK");'><spring:message code='ezResource.t253'/></span></li>
    			<li><span onclick='onViewDate("MONTH");'><spring:message code='ezResource.t255'/></span></li>
    			<c:if test="${adminFg eq 'Y'}" >
    				<li><span onClick="btnform_onclick();"><spring:message code='ezResource.t378'/></span></li>
    				<c:if test="${approveFlag eq '1'}" >
    					<li id="approvlist"><span onClick="btnApprov_list();"><spring:message code='ezResource.t1000'/></span></li>
    				</c:if>
    			</c:if>
    			<li style="background:none;cursor:default"><img src="/images/calendar/icon_resource_ok.png" style="vertical-align:middle">&nbsp;<spring:message code='ezResource.t369'/></li>
				<li style="background:none;cursor:default"><img src="/images/calendar/icon_resource_no.png" style="vertical-align:middle">&nbsp;<spring:message code='ezResource.t370'/></li>
  			</ul>
		</div>
		<script type="text/javascript">
    		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<table>   
			<tr>
				<td style="vertical-align:top;width:100%;">
					<div  style="vertical-align:top;" id="Calendar"></div>
				</td>
				<td style="vertical-align:top;width:10px">&nbsp;</td>
				<td id="calTD2" style="vertical-align:top;width:220px">
					<div id="CalendarMini"></div>
					<table id="ResourceInfo" name="ResourceInfo" style="width:218px; border-collapse:collapse; border-spacing:0px; margin-top:10px;border:1px solid #b6b6b6">
						<tr>
							<td height="30" bgcolor="#EFEFEF" class="subtxt" style="padding-left: 7px;border-bottom:1px solid #b6b6b6; color:#000;"><img src="/images/icon/check.gif" hspace="1" align="absmiddle"> <spring:message code='ezResource.t271'/></td>
						</tr>
						<tr>
							<td style="padding: 5px; vertical-align:top">
								<table style="height:100%">
									<tr>
										<td style="height:24px"><img src="/images/main/portlet_dot01.gif"> <b><spring:message code='ezResource.t153'/></b> :<a href="#" onClick="MemberInfo_onClick('${ownerID}')"> ${ownerNm}(${ownerPosition}) </a> </td>
									</tr>
									<tr>
										<td style="height:24px"><img src="/images/main/portlet_dot01.gif"> <b><spring:message code='ezResource.t151'/></b> :  ${ownerDeptNm} </td>
									</tr>
									<tr>
										<td style="height:24px"><img src="/images/main/portlet_dot01.gif"> <b><spring:message code='ezResource.t148'/></b></td>
									</tr>
									<tr>
										<td style="padding:2px 10px; word-break:break-all; height:20px">${resLocation}</td>
									</tr>
									<tr>
										<td style="height:24px"><img src="/images/main/portlet_dot01.gif"> <b><spring:message code='ezResource.t149'/></b></td>
									</tr>
									<tr>
										<td style="padding-left:10px; height:24px">
											<c:choose>
												<c:when test="${approveFlag eq 1}">
													<spring:message code='ezResource.t272'/>
												</c:when>
												<c:otherwise>
													<spring:message code='ezResource.t273'/>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<td style="height:24px"><img src="/images/main/portlet_dot01.gif"> <b><spring:message code='ezResource.t271'/></b></td>
									</tr>
									<tr>
										<td style="padding:2px 10px"><div style="overflow: auto; height: 100%;word-break:break-all"><c:out value='${brdExplain}' /></div></td>
									</tr>
								</table>
	                    	</td>
               			</tr>
           			</table>
				</td>
			</tr>
		</table>
	</body>
</html>