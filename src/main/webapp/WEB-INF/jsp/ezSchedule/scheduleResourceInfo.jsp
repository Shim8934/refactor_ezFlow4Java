<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	    <link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>        
		<script>
			var g_currentDate;
		    var g_orgUserID = "<c:out value='${userInfo.id}'/>";
		    var s_date, e_date;
	
		    window.onload = function () {
		        try {
		            RetValue = opener.schedule_resource_info_cross_dialogArguments[0];
		            ReturnFunction = opener.schedule_resource_info_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.schedule_resource_info_cross_dialogArguments[0];
		                ReturnFunction = opener.schedule_resource_info_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        var Para = RetValue;
	
		        if (typeof (Para) != "undefined" && Para != null) {
		            s_date = Para["startTime"];
		            e_date = Para["endTime"];
	
		            if (s_date == "") {
		                s_date = getToday();
		                var curDateArr = s_date.split("-");
	
		                if (curDateArr.length > 0) {
		                    s_date = curDateArr[0] + "-" + DateChange(curDateArr[1]) + "-" + DateChange(curDateArr[2]);
		                }
		            }
	
		            if (e_date == "") {
		                e_date = getToday();
	
		                curDateArr = e_date.split("-");
	
		                if (curDateArr.length > 0) {
		                    e_date = curDateArr[0] + "-" + DateChange(curDateArr[1]) + "-" + DateChange(curDateArr[2]);
		                }
		            }
	
		            g_currentDate = s_date;
	
		            if (Para["entryList"]["id"].length > 0) {
		                for (var i = 0 ; i < Para["entryList"]["id"].length; i++) {
		                    var entryID = Para["entryList"]["id"][i];
		                    var entryName = Para["entryList"]["name"][i];
		                    CreateEmptyInputLine();
		                    var objTrNode = GetChildNodes(GetChildNodes(entryList)[0])[GetChildNodes(GetChildNodes(entryList)[0]).length - 2];
		                    var listNode = GetChildNodes(GetChildNodes(GetChildNodes(GetChildNodes(objTrNode)[1])[0])[0])[0];
	
		                    GetChildNodes(objTrNode)[0].innerHTML = entryName;
		                    GetChildNodes(objTrNode)[0].id = entryID;
	
		                    DisplayScheduleList(listNode, entryID);
		                }
		            }
		        } else {
		            var sysDate = new Date();
	
		            s_date = sysDate.getFullYear() + "-" + (parseInt(sysDate.getMonth()) + 1) + "-" + sysDate.getDate();	
		            e_date = sysDate.getFullYear() + "-" + (parseInt(sysDate.getMonth()) + 1) + "-" + sysDate.getDate();
	
		            g_currentDate = s_date;
		        }	
		        DisplayCurrentDate();
	
		        GetChildNodes(entryList)[0].removeChild(GetChildNodes(entryList)[0].lastChild);
		    }
	
		    function getDateFormate(s_date) {
		        if (parseInt(s_date.split('-')[1]) < 10) {
		            s_date = s_date.split('-')[0] + "-0" + s_date.split('-')[1] + "-" + s_date.split('-')[2];
		        }
	
		        if (parseInt(s_date.split('-')[2]) < 10) {
		            s_date = s_date.split('-')[0] + "-" + s_date.split('-')[1] + "-0" + s_date.split('-')[2];
		        }
		        return s_date;
		    }
	
		    function btnClose_onClick() {
		        window.close();
		    }
		    
		    function dateMove_onClick(interval) {
		        tmpCurrDate = add_DATEs(g_currentDate, parseInt(interval));
		        g_currentDate = tmpCurrDate;
		        updateScheduleOfSelectedUsers();
		    }
		    
		    function changeScheduleList() {
		        g_currentDate = returnStartDateOfIdDatepicker();
	
		        updateScheduleOfSelectedUsers();
		    }
		    
		    function updateScheduleOfSelectedUsers() {
		        var i;
	
		        DisplayCurrentDate();
	
		        for (i = 0 ; i < GetChildNodes(GetChildNodes(entryList)[0]).length ; i++) {
		            var trNode = GetChildNodes(GetChildNodes(entryList)[0])[i];
	
		            if (GetChildNodes(trNode)[0].id != "") {
		                var listNode = GetChildNodes(GetChildNodes(GetChildNodes(GetChildNodes(trNode)[1])[0])[0])[0];
		                var userID = GetChildNodes(trNode)[0].id;
	
		                listNode.title = "";
	
		                for (j = 0 ; j < GetChildNodes(listNode).length ; j++) {
	
		                    GetChildNodes(listNode)[j].style.backgroundColor = "#e9e9e9";
		                    GetChildNodes(listNode)[j].style.paddingTop = "2";
		                }	
		                DisplayScheduleList(listNode, userID)
		            }
		        }
		    }
		    
		    function DisplayCurrentDate() {
		        var curDateArr = g_currentDate.split("-");
		        if (s_date == e_date) {
		            currDate.innerHTML = "<b>" + curDateArr[0] + "<spring:message code='ezSchedule.t125' />" + curDateArr[1] + "<spring:message code='ezSchedule.t126' />" + curDateArr[2] + "<spring:message code='ezSchedule.t127' />" + "</b>";
		        } else {
		            currDate.innerHTML = "<b>" + curDateArr[0] + "<spring:message code='ezSchedule.t125' />" + curDateArr[1] + "<spring:message code='ezSchedule.t126' />" + curDateArr[2] + "<spring:message code='ezSchedule.t127' />" + "</b> ( " + s_date + " ~ " + e_date + " )";
		        }
		    }
		    
		    function DisplayScheduleList(objTrNode, ownerID) {
		        var xmlHttp = createXMLHttpRequest();
		        var xmlDoc = createXmlDom();
		        var resultXML = createXmlDom();
		        var objRoot;
	
		        createNodeInsert(xmlDoc, objRoot, "PARAMETER");
		        createNodeAndInsertText(xmlDoc, objRoot, "STARTDATETIME", g_currentDate);
		        createNodeAndInsertText(xmlDoc, objRoot, "ENDDATETIME", g_currentDate);
		        createNodeAndInsertText(xmlDoc, objRoot, "APP", "1");

		        xmlHttp.open("POST", "/ezResource/scheduleGet.do?cmd=get" + "&resID=" + ownerID + "&pType=", false);
		        xmlHttp.send(xmlDoc);
	
		        resultXML = loadXMLString(xmlHttp.responseText);
	
		        if (typeof (resultXML) != "undefined" && getXmlString(resultXML) != "") {
		            var objNodes1 = resultXML.getElementsByTagName("dtstart")
		            var objNodes2 = resultXML.getElementsByTagName("dtend");
		            var objNodes3 = resultXML.getElementsByTagName("alldayevent");
		            var objNodes4 = resultXML.getElementsByTagName("subject");	
	
		            var titleStr = "";
		            var i;
	
		            for (i = 0 ; i < objNodes1.length ; i++) {
		                if (getNodeText(objNodes1[i]).substring(0, 10) <= g_currentDate && getNodeText(objNodes2[i]).substring(0, 10) >= g_currentDate) {
		                    var s_hour = getNodeText(objNodes1[i]).substring(11, 13);
		                    var s_minute = getNodeText(objNodes1[i]).substring(14, 16);
		                    var e_hour = getNodeText(objNodes2[i]).substring(11, 13);
		                    var e_minute = getNodeText(objNodes2[i]).substring(14, 16);
	
		                    var allday = getNodeText(objNodes3[i]);
		                    if (allday == "1") {
	
		                        for (var n = 0 ; n < GetChildNodes(objTrNode).length ; n++) {
		                            GetChildNodes(objTrNode)[n].style.backgroundColor = "#D4B96C";
		                        }	
		                        titleStr += "[<spring:message code='ezSchedule.t128' />] ";
		                    }
		                    else {
		                        var cnt = ((parseInt(e_hour) * 60) + parseInt(e_minute) - (parseInt(s_hour) * 60) - parseInt(s_minute)) / 30;
		                        var s_cnt = parseInt(s_hour) * 2;
	
		                        if (parseInt(s_minute) == 30) {
		                            s_cnt++;
		                            cnt++;
		                        }
	
		                        var start = 0; var end = GetChildNodes(objTrNode).length;
	
		                        var curDate = g_currentDate.split('-')[0] + Right(g_currentDate.split('-')[1], 2, "0") + Right(g_currentDate.split('-')[2], 2, "0")
		                        var sNodeDate = getNodeText(objNodes1[i]).substr(0, 10).replace("-", "").replace("-", "");
		                        var eNodeDate = getNodeText(objNodes2[i]).substr(0, 10).replace("-", "").replace("-", "");
	
		                        if (curDate == sNodeDate && curDate < eNodeDate) {
		                            start = s_cnt;
		                        }
		                        else if (curDate > sNodeDate && curDate < eNodeDate) {
		                            start = 0;
		                            end = GetChildNodes(objTrNode).length;
		                        }
		                        else if (curDate > sNodeDate && curDate <= eNodeDate) {
		                            end = (parseInt(s_hour) * 2 + cnt);
	
		                        }
		                        else if (curDate == sNodeDate && curDate == eNodeDate) {
		                            start = s_cnt;
		                            end = (parseInt(s_hour) * 2 + cnt);
		                        }
	
		                        for (var j = start; j < end; j++) {
		                            GetChildNodes(objTrNode)[j].style.backgroundColor = "#D4B96C";
		                        }
	
		                        titleStr += "[" + ChangeTime(s_hour, s_minute) + "~" + ChangeTime(e_hour, e_minute) + "] ";
		                    }
	
		                    titleStr += getNodeText(objNodes4[i]);
	
		                    if (i < objNodes1.length - 1) {
		                        titleStr += "\n";
		                    }
		                }	
		            }
	
		            objTrNode.title = titleStr;
		        }
		    }
	
		    function Right(str, n, appendStr) {
		        if (n <= 0)
		            return "";
		        else if (n > String(str).length) {
		            var iLen = String(str).length;
		            return appendStr + String(str).substring(iLen, iLen - n);
		        }
		        else {
		            return str;
		        }
		    }
	
		    function ChangeTime(h, n) {
		        var reVal = "";
	
		        h = parseInt(h);
	
		        if (h == 0) {
		            reVal = "<spring:message code='ezSchedule.t129' />" + n;
		        }
		        else if (h == 12) {
		            reVal = "<spring:message code='ezSchedule.t130' />" + String(h) + ":" + n;
		        }
		        else if (h < 12) {
		            reVal = "<spring:message code='ezSchedule.t131' />" + String(h) + ":" + n;
		        }
		        else if (h > 12) {
		            h -= 12;
		            reVal = "<spring:message code='ezSchedule.t130' />" + String(h) + ":" + n;
		        }	
		        return reVal;
		    }
	
		    function DateChange(pDate) {
		        if (parseInt(pDate) < 10)
		            tmpSDate = "0" + String(parseInt(pDate));
		        else
		            tmpSDate = pDate;
	
		        return tmpSDate;
		    }
	
		    function CreateEmptyInputLine() {
		        var oCloneNode = GetChildNodes(GetChildNodes(entryList)[0])[GetChildNodes(GetChildNodes(entryList)[0]).length - 1].cloneNode(true)
	
		        GetChildNodes(entryList)[0].appendChild(oCloneNode);
		    }
		    
		    function add_DATEs(dateformat, dates) {
		        var int_millisecond = 1;
		        var int_second = 1000 * int_millisecond;
		        var int_minute = 60 * int_second;
		        var int_hour = 60 * int_minute;
		        var int_day = 24 * int_hour;
		        var YY_form = Number(dateformat.substring(0, 4));
		        var MM_form = Number(dateformat.substring(5, 7)) - 1;
		        var DD_form = Number(dateformat.substring(8, 10));
	
		        var date = new Date(YY_form, MM_form, DD_form);
		        var date_milliseconds = date.valueOf();
		        var add_milliseconds = dates * int_day;
		        var ret_date = new Date(date_milliseconds + add_milliseconds);
		        var year = ret_date.getFullYear();
		        var month = ret_date.getMonth() + 1;
		        var day = ret_date.getDate();
		        if (month < 10) {
		            month = "0" + month;
		        }
		        if (day < 10) {
		            day = "0" + day;
		        }
	
		        return ("" + year + "-" + month + "-" + day);
		    }
	
		    function getToday() {
		        var date = new Date();
		        var year = date.getFullYear();
		        var month = date.getMonth() + 1;
		        var day = date.getDate();
		        if (month < 10) {
		            month = "0" + month;
		        }
		        if (day < 10) {
		            day = "0" + day;
		        }
	
		        return ("" + year + "-" + month + "-" + day);
		    }
		</script>
	</head>
	
	<body class="popup" style="overflow:hidden" >
	    <h1><spring:message code='ezSchedule.t1106' /></h1>
	    <div id="close">
	    	<ul>
	        	<li><span onClick="window.close()"><spring:message code='ezSchedule.t16' /></span></li>
	      	</ul>
	    </div>

    	<table class="nobox">
	        <tr>
				<td>
		        	<table style="padding-top:5px; border:1px; width:100%; border-collapse:collapse; border-spacing:5; padding:0; text-align:center">
		            	<tr>
	                    	<td style="text-align:center">
	                        	<img onClick="dateMove_onClick( '-1' )" style="cursor:pointer" src="/images/etc/calendar_prev.gif" />
	                        	<span id="currDate"></span>
	                        	<img onClick="dateMove_onClick( '1' )" style="cursor:pointer" src="/images/etc/calendar_next.gif" />
	                        </td>
			            	<td style="width:60px"><img <spring:message code='ezSchedule.i1' />/></td>
	                	</tr>
	              	</table>
	              	<table style="margin-bottom:2px; border:0; border-collapse:collapse; border-spacing:0; padding:0; width:663px">
		            	<tr>
			            	<td style="vertical-align:top"><img src="/images/i_timetable.gif" style="width:672px; height:33px" /></td>
		            	</tr>
	              	</table>
	              	<div style="BORDER: #b6b6b6 1px solid; overflow-Y: scroll; WIDTH: 670px; HEIGHT: 300px; BACKGROUND-IMAGE:  url(/images/i_timetable_bg.gif);">
						<table style="border:0; border-collapse:collapse; border-spacing:0; padding:0; width:650px; text-align:left">
	                   		<tr>
	                     		<td>
	                        		<div style ="background-color:none;BORDER:#FFFFFF 0px solid;OVERFLOW:auto;TEXT-ALIGN:left;HEIGHT:300px;">
	                         			<table style="border:0; border-collapse:collapse; border-spacing:0; padding:0; width:650px" id="entryList">
	                           				<tr>
	                             				<td style="PADDING-TOP:2px;BACKGROUND-COLOR:#e9e9e9;border-collapse:collapse;border-bottom: solid 1px #b6b6b6; width:102px; height:25px; text-align:center"id="" deptid=""></td>
	                             				<td style="padding-left:9px;border-collapse:collapse; border-bottom: solid 1px #dadada" >
	                                				<table style="border:0; border-collapse:collapse; border-spacing:1; padding:0;">
	                                 					<tr>
															<td style="BACKGROUND-COLOR: #f2f2f2; height:11px; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
															<td style="BACKGROUND-COLOR: #f2f2f2; width:11px"></td>
	                                 					</tr>
	                               					</table>
	                             				</td>
	                           				</tr>
	                         			</table>
	                    			</div>
	                  			</td>
	                		</tr>
	              		</table>
	            	</div>
	          	</td>
	        </tr>
	    </table>
    	<script type="text/javascript">
	    	selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
	</body>
</html>