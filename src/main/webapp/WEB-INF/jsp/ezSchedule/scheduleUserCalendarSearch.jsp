<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${util.addVer('/css/olstyle_nonIE.css')}" type="text/css" />
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
    <link rel="stylesheet" href="${util.addVer('/css/ezSchedule/Calendar_cross.css')}" type="text/css" />
    <link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="${util.addVer('/js/Holiday.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <!-- 2018-11-05 김혜정 -->
    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/CalendarDataPro_Cross.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/CalendarView_Cross.js')}"></script>
    <!-- data picker-->
    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
    <%-- <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script> --%>
    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
    <!-- 2018-06-12 구해안 -->
    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/monthpicker.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
    <style type="text/css">
        .ui-monthpicker>.ui-datepicker-header>.ui-datepicker-title>.ui-datepicker-year{
            margin: 0 auto;
        }

        .ui-monthpicker>.ui-datepicker-header>.ui-datepicker-title>.ui-datepicker-month {
            display: none;
        }

        .ui-monthpicker td span {
            padding: 5px;
            cursor: pointer;
            text-align: center;
        }
        .chk_noneDisplay {
            display:none;
        }
        .mainmenuLayout { position: relative; }
        .mainmenuLayout_calendar { position: relative; }
        .calendar_pagenav { position: relative; left: 50%; top:20px; width: 269px; margin-left: -134px; }
        .calendar_pagenav .spanText { display: block !important; text-align: center; font-size:18px; white-space:nowrap; text-overflow:ellipsis; overflow:hidden; letter-spacing:-1px;}
        .mainmenuTab {position:relative;margin: 30px 15px 11px 15px;}
        .mainmenuTab .mainmenuTabUL { text-align: center; padding: 0px 0px 0px 1px; margin: 0px; }
        .mainmenuTab .mainmenuTabUL li { display: inline-block; }
        .mainmenuTab .mainmenuTabUL li span { display: inline-block; height:31px; line-height:29px; padding: 0px 21px; margin: 0px 1px 0px 1px; text-align: center; font-size: 14px;color: #BABEC7; cursor: pointer; background: #fff; border:1px solid #BABEC7; box-sizing:border-box; border-radius: 3px;}
        .mainmenuTab .mainmenuTabUL li:hover span { position: relative; background: #f1f8ff; color: #0470E4; border:1px solid #3d8fea; box-sizing:border-box; }
        .mainmenuTab .mainmenuTabUL li.on span { position: relative; background: #fff; color: #0470E4; border:1px solid #388CE5; box-sizing:border-box; border-radius: 3px;}
        .mainmenuTab .mainmenuTabUL li.on span:hover{background: #f1f8ff; color: #0470E4; }
        .calendar_layout {position: absolute;left: 90%;top:15px;width: 269px;margin-left: -134px;}

        .IDcontainer  {
            display : inline;
            padding : 0px;
            margin-left: 0px;
            position: relative;
        }

        .checkmark {
            position: absolute;
            top: 0;
            left: 2px;
            height: 20px;
            width: 20px;
            background-color: #eee;
            border-radius:3px;
        }

        /* When the checkbox is checked, add a blue background */
        .IDcontainer input:checked ~ .checkmark { background-color: #ccc; }

        .checkmark:after { content: ""; display: none; }

        .IDcontainer input:checked ~ .checkmark:after { display: block; }

        .IDcontainer .checkmark:after {position:relative; width: 3px; height: 6px; margin:4px auto 0px auto; border: solid white; border-width: 0 2px 2px 0; -webkit-transform: rotate(45deg); -ms-transform: rotate(45deg); transform: rotate(45deg); }
    </style>

    <script type="text/javascript">
        var UserOffset = "<c:out value='${pOffset}'/>";
        var timeZoneStr = "<c:out value='${timeZoneStr}'/>";
        var uselang = "<c:out value='${userInfo.lang}'/>";
        var otherid = "<c:out value='${otherId}'/>";
        var pDisplaySTime = "<c:out value='${startTime}'/>";
        var pDisplayETime = "<c:out value='${endTime}'/>";
        var pDefaultview = "<c:out value='${defaultView}'/>";
        var pStartday = "<c:out value='${startDay}'/>";
        var pUse_Editor = "<c:out value='${useEditor}'/>";
        var publicIds = "";
        var LunarUse = false;
        var primaryLang = "<c:out value='${userInfo.primary}'/>";
        var g_bMobileExtra = false;       // 모바일 외부 서버 여부 (내/외부 네트워크 분리 환경에서만 설정) (true: 외부서버, false: 해당 없음)
        var isCalendarView = true;
        var g_entity = null;
        var resultUserID = "<c:out value='${resultUserID}'/>";
        var resultCompanyID = "<c:out value='${resultCompanyID}'/>";
        var resultDeptName = "<c:out value='${resultDeptName}'/>";
        var resultDeptID = "<c:out value='${resultDeptID}'/>";
        var chk_usersearch = "UserSearch";
        var jsonPersonalScheConfigList = "<c:out value='${jsonPersonalScheConfigList}'/>";
        var personalScheConfigList = JSON.parse(decodeHtml(jsonPersonalScheConfigList));

        window.onload = function () {
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                document.body.style.MozUserSelect = 'none';
                document.body.style.WebkitUserSelect = 'none';
                document.body.style.khtmlUserSelect = 'none';
                document.body.style.oUserSelect = 'none';
                document.body.style.UserSelect = 'none';
            }

            if (pDefaultview == 2) {
                typeCal = 0;
            } else if (pDefaultview == 1) {
                typeCal = 1;
            } else if (pDefaultview == 0) {
                typeCal = 2;
            }

            windowonload_Complete("empty");
        }

        window.onresize = resize;
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

        document.onselectstart = function () { return false; };

        function windowonload_Complete(ret) {
            if(ret != "empty") {
                $(parent.frames["left"].document.getElementById("blockLeft")).remove();
            }
            schedule_get_lunaruse();
            resize();
        }

        function schedule_get_lunaruse() {
            if (uselang == 1) {
                $.ajax({
                    type : "GET",
                    dataType : "text",
                    async : false,
                    cache : false,
                    url : "/ezSchedule/scheduleGetLunarUse.do",
                    data : {
                        COMPANYID  : "${userInfo.companyID}"
                    },
                    success: function(text) {
                        if (text == "0") {
                            LunarUse = true;
                        } else if(text == "1") {
                            LunarUse = true;
                        } else {
                            LunarUse = false;
                        }
                        schedule_get_holiday();
                    }
                });
            } else {
                schedule_get_holiday();
            }
        }

        function schedule_get_holiday() {
            $.ajax({
                type : "GET",
                dataType : "text",
                async : true,
                cache : false,
                url : "/ezSchedule/scheduleGetHoliday.do",
                data : {
                    COMPANYID  : "VIEW"
                },
                success: function(text){
                    XmlNodeText = text;
                    XmlNode = loadXMLString(XmlNodeText);

                    for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
                        if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISUSE")[0].textContent == "1") {
                            var issolar;
                            var holiday;
                            var holidayFlag;

                            if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISSOLAR")[0].textContent == "1") {
                                issolar = "1";
                            } else {
                                issolar = "2";
                            }

                            if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREST")[0].textContent == "1") {
                                holiday = true;
                            } else {
                                holiday = false;
                            }

                            if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYFLAG")[0].textContent == "Y") {
                                holidayFlag = "Y";
                            } else {
                                holidayFlag = "D";
                            }

                            var repetition = GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYREPEAT")[0].textContent;

                            if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISREPEAT")[0].textContent == "1") {
                                memorialDays.push(new memorialDay(escapeHtml(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent), escapeHtml(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent),
                                    GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
                                    GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday, holidayFlag, repetition));
                            } else {
                                yearmemorialDays.push(new yearmemorialDay(escapeHtml(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent), escapeHtml(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent),
                                    GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(0, 4),
                                    GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
                                    GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday, holidayFlag, repetition));
                            }
                        }
                    }
                    CalendarView("Calendar");

                    //2018-06-12 구해안 datepicker localization
                    $.datepicker.regional["<spring:message code='main.t0619' />"] = {
                        closeText: "<spring:message code='main.t3' />",
                        prevText: "<spring:message code='main.t0604' />",
                        nextText: "<spring:message code='main.t0605' />",
                        currentText: "<spring:message code='main.t0606' />",
                        monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />",
                            "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
                            "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />",
                            "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
                        monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />",
                            "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
                            "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />",
                            "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
                        dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />",
                            "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
                            "<spring:message code='main.t0627' />"],
                        dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />",
                            "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
                            "<spring:message code='main.t0627' />"],
                        dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />",
                            "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
                            "<spring:message code='main.t0627' />"],
                        weekHeader: "Wk",
                        dateFormat: "yy-mm-dd",
                        firstDay: 0,
                        isRTL: false,
                        duration: 200,
                        showAnim: "show",
                        showMonthAfterYear: true
                    };
                    $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
                }
            });
        }

        var schedule_read_confirm_cross_dialogArguments = new Array();
        var srcEl;
        function ReadSchedule(e) {
            srcEl = document.getElementById(e);
            var repeatcount = GetAttribute(srcEl, "RepeatCount");
            var datetype = GetAttribute(srcEl, "DateType");
            var scheduletype = GetAttribute(srcEl, "ScheduleType");
            var scheduleid = GetAttribute(srcEl, "ScheduleID");
            var repeatcount = GetAttribute(srcEl, "RepeatCount");
            var date = GetAttribute(srcEl, "StartDate").substring(0, 10);
            var ret = "0";
            if (scheduleid.indexOf("GOOGLE") > -1)
                date = GetAttribute(srcEl, "StartDate") + "|" + srcEl.getAttribute;

            if (scheduleid.indexOf("collaboration") > -1) // 협업 일정
                scheduleReadUrl = getRedirectScheduleDetailUrl(encodeURIComponent(scheduleid.replace("collaboration:", "")), date, repeatcount, 10);

            if (repeatcount == "Y") {
                schedule_read_confirm_cross_dialogArguments[0] = "";
                schedule_read_confirm_cross_dialogArguments[1] = ReadSchedule_Complete;
                GetOpenWindow("/ezSchedule/scheduleReadConfirm.do", "schedule_read_confirm_Cross", 400, 170);
            } else {
                var pheight = window.screen.availHeight;
                var pwidth = window.screen.availWidth;
                var pTop = (pheight - 670) / 2;
                var pLeft = (pwidth - 790) / 2;
                if(scheduletype == 2 || scheduletype == 3) {
                    window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&otherid=" + encodeURIComponent(otherid) + "&repeatcount=" + repeatcount + "&date=" + date + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + ret + "&chk_usersearch=" + chk_usersearch, "",
                        "height = 640px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=1");
                } else if(scheduletype == 4) { // 협업
                    window.open(scheduleReadUrl, "", "height = 670px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=1");
                }else {
                    window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&otherid=" + encodeURIComponent(otherid) + "&repeatcount=" + repeatcount + "&date=" + date + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + ret + "&chk_usersearch=" + chk_usersearch, "",
                        "height = 670px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=1");
                }
            }
        }

        function ReadSchedule_Complete(ret) {
            if (ret == "0" || ret == "1") {
                var datetype = GetAttribute(srcEl, "DateType");
                var scheduletype = GetAttribute(srcEl, "ScheduleType");
                var scheduleid = GetAttribute(srcEl, "ScheduleID");
                var repeatcount = GetAttribute(srcEl, "RepeatCount");
                var date = GetAttribute(srcEl, "StartDate").substring(0, 10);
                if (scheduleid.indexOf("GOOGLE") > -1)
                    date = GetAttribute(srcEl, "StartDate") + "|" + GetAttribute(srcEl, "EndDate");

                var pheight = window.screen.availHeight;
                var pwidth = window.screen.availWidth;
                var pTop = (pheight - 660) / 2;
                var pLeft = (pwidth - 790) / 2;
                if(scheduletype == 2 || scheduletype == 3) {
                    window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&otherid=" + encodeURIComponent(otherid) + "&repeatcount=" + repeatcount + "&date=" + date + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + ret + "&chk_usersearch=" + chk_usersearch, "",
                        "height = 640px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=1");
                }
                else {
                    window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&otherid=" + encodeURIComponent(otherid) + "&repeatcount=" + repeatcount + "&date=" + date + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + ret + "&chk_usersearch=" + chk_usersearch, "",
                        "height = 670px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=1");
                }
            } else {
                return;
            }
        }

        function ViewChange(szCmd) {
            var chk_str = "";
            switch (szCmd.toUpperCase()) {
                case "DAY":
                    typeCal = 2;
                    $("#monView").attr("class","off");
                    $("#weekView").attr("class","off");
                    $("#dayView").attr("class","on");

                    if (g_selTDID != null && g_selTDID != "") {
                        sDate = new Date(g_selTDID.substring(7, 11), parseInt(g_selTDID.substring(12, 14)) - 1, parseInt(g_selTDID.substring(15, 17)));
                    }

                    CalendarView("Calendar",chk_str);
                    break;

                case "WEEK":
                    typeCal = 1;
                    $("#monView").attr("class","off");
                    $("#weekView").attr("class","on");
                    $("#dayView").attr("class","off");

                    if (g_selTDID != null && g_selTDID != "") {
                        sDate = new Date(g_selTDID.substring(7, 11), parseInt(g_selTDID.substring(12, 14)) - 1, parseInt(g_selTDID.substring(15, 17)));
                    }

                    CalendarView("Calendar",chk_str);
                    break;

                case "MONTH":
                    typeCal = 0;
                    $("#monView").attr("class","on");
                    $("#weekView").attr("class","off");
                    $("#dayView").attr("class","off");

                    CalendarView("Calendar",chk_str);
                    break;
            }
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

            if (!GetAttribute(srcEl, "ScheduleID"))
                srcEl = srcEl.parentElement.parentElement.parentElement;

            sScheduleID = GetAttribute(srcEl, "ScheduleID");
            sScheduleChangeKey = GetAttribute(srcEl, "ScheduleChangeKey");
            sParentID = GetAttribute(srcEl, "ParentID");
            sOwnerID = GetAttribute(srcEl, "OwnerID");
            sCreatorID = GetAttribute(srcEl, "CreatorID");
            sModifierID = GetAttribute(srcEl, "ModifierID");
            sScheduleType = GetAttribute(srcEl, "ScheduleType");
            sImportance = GetAttribute(srcEl, "Importance");
            sIsReadOnly = GetAttribute(srcEl, "IsReadOnly");
            sDateType = GetAttribute(srcEl, "DateType");
            sSubject = GetAttribute(srcEl, "Subject");
            sLocation = GetAttribute(srcEl, "Location");
            sRepeatCount = GetAttribute(srcEl, "RepeatCount");
        }

        function MouseOverSchedule() {
            sTitle = event.title;
            sWriter = event.writer;
            sDuration = event.duration;
        }

        //검색대상자선정
        var schedule_select_entity_dialogArguments = new Array();
        function select_entity() {
            schedule_select_entity_dialogArguments[0] = g_entity;
            schedule_select_entity_dialogArguments[1] = select_entity_Complete;
            var OpenWin = GetOpenWindow("/ezSchedule/scheduleSelectEntity.do?title=" + encodeURIComponent("<spring:message code='ezSchedule.kmh02' />"), "scheduleSelectEntity", 970, 655);
            try {} catch (e) { }
        }

        function select_entity_Complete(rtn) {
            if (typeof (rtn) != "undefined") {
                g_entity = { "id": new Array(), "name": new Array(), "deptname": new Array(), "deptid": new Array(), "companyid": new Array()};
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
                    g_entity["deptname"][i] = rtn["deptname"][i]
                    g_entity["deptid"][i] = rtn["deptid"][i];
                    g_entity["companyid"][i] = rtn["companyid"][i];

                }
                window.open("/ezSchedule/scheduleUserCalendarSearch.do?SearchName=" + encodeURIComponent(g_entity.name[0])+ "&SearchUserId=" + encodeURIComponent(g_entity.id[0]) + "&SearchDeptName=" + encodeURIComponent(g_entity.deptname[0]) + "&SearchDeptId=" + encodeURIComponent(g_entity.deptid[0])+ "&SearchCompanyId=" + encodeURIComponent(g_entity.companyid[0]) , "right");
            }
        }

        function chk_scheduleCSS() {
            if(typeCal == 0){
                $("input[name=chk_schedule]").each(function(index){
                    var chk_eachVal1 = $(this).val();
                    var chk_type=$(this).data("schedule-type");

                    $('.td_list td[ownerid = "'+chk_eachVal1+'"][scheduletype = "'+chk_type+'"]').each(function(index, value){
                        $(value).addClass('chk_noneDisplay');
                    });
                });
                $("input[name=chk_schedule]:checked").each(function(index) {
                    var test = $(this).val();
                    var chk_type=$(this).data("schedule-type");

                    $('.td_list td[ownerid = "'+test+'"][scheduletype = "'+chk_type+'"]').each(function(index, value){
                        $(value).removeClass('chk_noneDisplay');
                    });
                });
            }else if(typeCal == 1) {
                $("input[name=chk_schedule]").each(function(index){
                    var chk_eachVal1 = $(this).val();
                    var chk_type=$(this).data("schedule-type");

                    $('div[ownerid = "'+chk_eachVal1+'"][scheduletype = "'+chk_type+'"]').each(function(index, value){
                        $(value).addClass('chk_noneDisplay');
                    });
                });
                $("input[name=chk_schedule]:checked").each(function(index) {
                    var test = $(this).val();
                    var chk_type=$(this).data("schedule-type");

                    $('div[ownerid = "'+test+'"][scheduletype = "'+chk_type+'"]').each(function(index, value){
                        $(value).removeClass('chk_noneDisplay');
                    });
                });
            }else{
                $("input[name=chk_schedule]").each(function(index){
                    var chk_eachVal1 = $(this).val();
                    var chk_type=$(this).data("schedule-type");

                    $('div[ownerid = "'+chk_eachVal1+'"][scheduletype = "'+chk_type+'"]').each(function(index, value){
                        $(value).addClass('chk_noneDisplay');
                    });
                });
                $("input[name=chk_schedule]:checked").each(function(index) {
                    var test = $(this).val();
                    var chk_type=$(this).data("schedule-type");

                    $('div[ownerid = "'+test+'"][scheduletype = "'+chk_type+'"]').each(function(index, value){
                        $(value).removeClass('chk_noneDisplay');
                    });
                });
            }
        }

        function chk_all(){
            if($('#select-all').is(":checked")) {
                $('.checkSelect').each(function() {
                    $(this).prop('checked',true);
                });
                /* chk_IDchange(); */
                chk_DisplayChange();
                chk_DisplayChange2();
            } else {
                $('.checkSelect').each(function() {
                    $(this).prop('checked',false);
                });
                /* chk_IDchange(); */
                chk_DisplayChange();
                chk_DisplayChange2();
            }
        }

        function chk_DisplayChange() {
            if (isCalendarView) {
                var chk_str =  "";
                var chk_total = $("input[name=chk_schedule]:checked").length;
                var chk_fullLength = $("input[name=chk_schedule]").length;

                if (typeCal == 0) {
                    $("input[name=chk_schedule]").each(function(index){
                        var chk_eachVal1 = $(this).val();
                        var chk_type=$(this).data("schedule-type")

                        if (chk_type == "10") {
                            $('.td_list td[scheduletype = "'+chk_type+'"]').each(function(index, value){
                                $(value).addClass('chk_noneDisplay');
                            });
                        } else {
                            $('.td_list td[ownerid = "'+chk_eachVal1+'"][scheduletype = "'+chk_type+'"]').each(function(index, value){
                                $(value).addClass('chk_noneDisplay');
                            });
                        }
                    });
                    $("input[name=chk_schedule]:checked").each(function(index) {
                        var test = $(this).val();
                        var chk_type = $(this).data("schedule-type");

                        if (chk_type == "10") {
                            $('.td_list td[scheduletype = "' + chk_type + '"]').each(function (index, value) {
                                $(value).removeClass('chk_noneDisplay');
                            });
                        } else {
                            $('.td_list td[ownerid = "' + test + '"][scheduletype = "' + chk_type + '"]').each(function (index, value) {
                                $(value).removeClass('chk_noneDisplay');
                            });
                        }
                    });
                } else if (typeCal == 1) {
                    $("input[name=chk_schedule]").each(function(index){
                        var chk_eachVal1 = $(this).val();
                        var chk_type = $(this).data("schedule-type");

                        if (chk_type == "10") {
                            $('div[scheduletype = "' + chk_type + '"]').each(function (index, value) {
                                $(value).addClass('chk_noneDisplay');
                            });
                        } else {
                            $('div[ownerid = "' + chk_eachVal1 + '"][scheduletype = "' + chk_type + '"]').each(function (index, value) {
                                $(value).addClass('chk_noneDisplay');
                            });
                        }
                    });
                    $("input[name=chk_schedule]:checked").each(function(index) {
                        var test = $(this).val();
                        var chk_type = $(this).data("schedule-type");

                        if (chk_type == "10") {
                            $('div[scheduletype = "' + chk_type + '"]').each(function (index, value) {
                                $(value).removeClass('chk_noneDisplay');
                            });
                        } else {
                            $('div[ownerid = "' + test + '"][scheduletype = "' + chk_type + '"]').each(function (index, value) {
                                $(value).removeClass('chk_noneDisplay');
                            });
                        }
                    });
                } else {
                    $("input[name=chk_schedule]").each(function(index){
                        var chk_eachVal1 = $(this).val();
                        var chk_type = $(this).data("schedule-type");

                        if (chk_type == "10") {
                            $('div[scheduletype = "' + chk_type + '"]').each(function (index, value) {
                                $(value).addClass('chk_noneDisplay');
                            });
                        } else {
                            $('div[ownerid = "' + chk_eachVal1 + '"][scheduletype = "' + chk_type + '"]').each(function (index, value) {
                                $(value).addClass('chk_noneDisplay');
                            });
                        }
                    });
                    $("input[name=chk_schedule]:checked").each(function(index) {
                        var test = $(this).val();
                        var chk_type = $(this).data("schedule-type");

                        if (chk_type == "10") {
                            $('div[scheduletype = "' + chk_type + '"]').each(function (index, value) {
                                $(value).removeClass('chk_noneDisplay');
                            });
                        } else {
                            $('div[ownerid = "' + test + '"][scheduletype = "' + chk_type + '"]').each(function (index, value) {
                                $(value).removeClass('chk_noneDisplay');
                            });
                        }
                    });
                }

                if(chk_total > 0 && chk_total < chk_fullLength) {
                    $('#select-all').prop('checked',false);
                } else if(chk_total == chk_fullLength) {
                    $('#select-all').prop('checked',true);
                } else if(chk_total == 0){
                    chk_str += $('#select-all').val();
                }
            }
        }

        function chk_DisplayChange2(obj) {
            if (isCalendarView) {
                var chk_str =  "";
                var chk_total = $("input[name=chk_schedule]:checked").length;
                var chk_fullLength = $("input[name=chk_schedule]").length;

                var chk_type = 4;//$("input[name=chk_schedule]").data("schedule-type");
                if (typeCal == 0) {
                    $('.td_list td[scheduletype = "'+chk_type+'"]').each(function(index, value){
                        $(value).toggleClass('chk_noneDisplay');
                    });
                } else {
                    $('div[scheduletype = "'+chk_type+'"]').each(function(index, value){
                        $(value).toggleClass('chk_noneDisplay');
                    });
                }
            }

            if(chk_total > 0 && chk_total < chk_fullLength) {
                $('#select-all').prop('checked',false);
            } else if(chk_total == chk_fullLength) {
                $('#select-all').prop('checked',true);
            } else if(chk_total == 0){
                chk_str += $('#select-all').val();
            }
        }

        function scrollTopTime() {
            $("#CalDiv").scrollTop($(".today").eq(0).position().top);
        }

        function escapeHtml(text) {
            var map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };

            return text.replace(/[&<>"']/g, function(m) { return map[m]; });
        }
        function Write() {
        }
        function MultiSelectEnd(){
        }
    </script>
</head>
<body class="mainbody" style="overflow: auto; margin-bottom:0px; min-width: 950px;">
<h1 id="titleimg">${defaultTitle}</h1>
<table class="content">
    <tr>
        <th style="white-space:nowrap">
            <spring:message code='ezSchedule.t290' />
        </th>
        <td style="width:10px;border-right:none">
            <a class="imgbtn imgbck">
                <span onClick="select_entity();"><spring:message code='ezSchedule.t291' /></span>
            </a>
        </td>
        <td style="border-left:none; width:80px;">
            <div id="searchlist" style="OVERFLOW-Y: auto; width:100px; text-align: center">${SearchName}</div>
        </td>
        <td id= "calSearch"style="width:100%;">
            <%--모든 일정--%>
            <label class="IDcontainer" onchange="chk_all()">
                <input type="checkbox" checked="checked" name="select-all" id="select-all" value="chkAllFalse" style="left:0px; vertical-align:-5px;">
                <span class="checkmark" style="background:rgb(125, 125, 125);"></span>
                <span class="list_text"><spring:message code='ezSchedule.t220'/></span>
            </label>
            <%--개인 일정--%>
            <label class="IDcontainer" onchange="chk_DisplayChange()">
                <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="1" value="${resultUserID}" class="checkSelect" style="vertical-align:-5px;">
                <span class="checkmark" style="background:rgb(1, 138, 249);"></span>
                <span class="list_text"><spring:message code='ezSchedule.t221'/></span>
            </label>
            <%--부서 일정--%>
            <label class="IDcontainer" onchange="chk_DisplayChange()">
                <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="2" value="${resultDeptID }" class="checkSelect" style="vertical-align:-5px;">
                <span class="checkmark" style="background:rgb(1, 179, 63);"></span>
                <span class="list_text"><spring:message code='ezSchedule.t222'/></span>
            </label>
            <%--회사 일정--%>
            <label class="IDcontainer" onchange="chk_DisplayChange()">
                <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="3" value="${resultCompanyID }" class="checkSelect" style="vertical-align:-5px;">
                <span class="checkmark" style="background:rgb(254, 28, 113);"></span>
                <span class="list_text"><spring:message code='ezSchedule.t223'/></span>
            </label>
            <c:if test='${!empty groupList}'>
                    <c:forEach var="group" items="${groupList}">
                            <label class="IDcontainer" onchange="chk_DisplayChange()">
                                <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="7" value="${group.groupId }" class="checkSelect" style="vertical-align:-5px;">
                                <span class="checkmark" style="background-color: ${group.groupColor };"></span>
                                <span class="list_text"><spring:message code='ezSchedule.t375'/>${fn:escapeXml(group.groupName)}</span>
                            </label>
                    </c:forEach>
            </c:if>
            <%--임원 일정--%>
            <label class="IDcontainer" onchange="chk_DisplayChange()">
                <input type="checkbox" checked="checked" name="chk_schedule" data-schedule-type="10" value="${resultUserID }" class="checkSelect" style="vertical-align:-5px;">
                <span class="checkmark" style="background:rgb(255, 174, 0);"></span>
                <span class="list_text"><spring:message code='ezSchedule.lyj14'/></span>
            </label>
        </td>
    </tr>
</table>
<div class="calendar_pagenav" style="max(50%, 300px)">
    <ul class="contentlayout">
        <li class="contentlayout_left" id="preM"></li>
        <li class="contentlayout_right" id="preN"></li>
        <li class="contentlayout_none"><span class="spanText" id="calTitle"></span>
        </li>
    </ul>
</div>
<div class="mainmenuTab">
    <ul class="mainmenuTabUL">
        <li id="dayView" class="${defaultView == '0' ? 'on' : 'off' }"><span onclick='ViewChange("DAY");'><spring:message code='ezSchedule.t140'/></span></li><li id="weekView" class="${defaultView == '1' ? 'on' : 'off' }"><span onclick='ViewChange("WEEK");'><spring:message code='ezSchedule.t141'/></span></li><li id="monView" class="${defaultView == '2' ? 'on' : 'off' }"><span onclick='ViewChange("MONTH");'><spring:message code='ezSchedule.t142'/></span></li>
    </ul>
</div>
<table>
    <tr>
        <td style="vertical-align:top;width:100%;">
            <DIV  style="vertical-align:top;" id="Calendar"></DIV>
        </td>
        <td style="vertical-align:top;width:10px">&nbsp;</td>
    </tr>
</table>
<br/>
</body>
</HTML>