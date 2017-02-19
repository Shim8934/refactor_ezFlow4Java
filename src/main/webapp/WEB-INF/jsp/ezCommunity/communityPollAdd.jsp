<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head></head>
		<title>poll_add</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<link rel="stylesheet" href="/css/community.css" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/datepicker.htc.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<!-- data picker -->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css"/>
        <script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
        <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
        <script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="/js/jquery/dateControls/demos.css"/>
		<!-- time picker -->
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css"/>
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		
		
		<script type="text/javascript">
			var code = "<c:out value = '${code}' />";
	        var ExpireDays = "N";
	        var pSelType = "<c:out value = '${pSelType}' />";
	        var pSelRes1 = "<c:out value = '${pSelRes1}' />";
	        var pSelRes2 = "<c:out value = '${pSelRes2}' />";
	        var StartDateTime = "<c:out value = '${pStartDate}' />";
	        var EndDateTime = "<c:out value = '${pEndDate}' />";
	            
	        window.onload = function () {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            //initdatepicker();
	            //if (ExpireDays == "N") document.all.Makedate.style.display = "none";
	
	            if ("${pState}" == 'PREV') {
	                var pselType = document.getElementById('selType');
	                for (var i = 0; i < pselType.options.length; i++) {
	                    if (pselType.options[i].value == pSelType) {
				            pselType.selectedIndex = i;
				            break;
				        }
				    }
	                
	                var selRes1 = document.getElementById('selRes1');
	                for (var i = 0; i < selRes1.options.length; i++) {
	                    if (selRes1.options[i].value == pSelRes1) {
	                        selRes1.selectedIndex = i;
	                        break;
	                    }
	                }
	                
	                if (CrossYN()) {
	                	document.getElementById('selRes2').textContent = pSelRes2;
	                } else {
	                    document.getElementById('selRes2').innerText = pSelRes2;
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
	            
	            var SDate = new Date(StartDateTime);
	            var EDate = new Date(EndDateTime);
	            $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	            $("#Sdatepicker").datepicker('setDate', SDate);
	            //$('#Stimepicker').timepicker();
	            //$('#Stimepicker').timepicker('setTime', SDate);
	            //$('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
	
	            $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	            $("#Edatepicker").datepicker('setDate', EDate);
	            //$('#Etimepicker').timepicker();
	            //$('#Etimepicker').timepicker('setTime', EDate);
	            //$('#Etimepicker').timepicker({ 'timeFormat': 'H:i' });
	        });
	        
	        if ("${userInfo.lang}" == '1') {
		        $(function () {
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
		        });
	    	} else {
		        $(function () {
		            $.datepicker.regional['en'] = {
		                dateFormat: 'yy-mm-dd',
		                firstDay: 0,
		                isRTL: false,
		                duration: 200,
		                showAnim: 'show',
		                showMonthAfterYear: true
		            };
		            $.datepicker.setDefaults($.datepicker.regional['en']);
		        });
	        }
	        
	        function trim(val) {
	            s = val.split(" ", val.length);
	            return s.join("");
	        }
	        
	        function selRes2_onkeydown() {
	            poll_add.selRes1.selectedIndex = 0;
	            poll_add.selType.selectedIndex = 0;
	        }
	
	        function selRes1_onchange() {
	            poll_add.selRes2.value = "";
	        }
	
	        function selType_onchange() {
	            if (poll_add.selType.selectedIndex == 2) {
	                poll_add.selRes1.selectedIndex = 0;
	                poll_add.selRes2.value = "";
	                document.getElementById("selRes1").disabled = true;
	                document.getElementById("selRes2").disabled = true;
	            } else {
	                document.getElementById("selRes1").disabled = false;
	                document.getElementById("selRes2").disabled = false;
	            }
	        }
	        
	        function endDate() {
				var now   = new Date();
				var day   = parseInt(poll_edit.startPollDay.value, 10);
				var month = parseInt(poll_edit.startPollMonth.value, 10) - 1;
				var year  = parseInt(poll_edit.startPollYear.value, 10);	
				var year2 = parseInt(poll_edit.startPollYear.value, 10);
										
				switch (poll_edit.relatePollDay.value) {
					case "1<spring:message code='ezCommunity.t591' />" :
						endDateSetting(year2, month, day + 7);
						break;
					case "2<spring:message code='ezCommunity.t591' />" :
						endDateSetting(year2, month, day + 14);
						break;
					case "3<spring:message code='ezCommunity.t591' />" :
						endDateSetting(year2, month, day + 21);
						break;
					case "4<spring:message code='ezCommunity.t591' />" :
						endDateSetting(year2, month, day + 28);
						break;
				}
			}

	        function endDateSetting(y, m, d) {
	            var tovot = new Date(y, m, d);
	            var day = parseInt(tovot.getDate());
	            var month = parseInt(tovot.getMonth()) - 1;
	            var year = parseInt(tovot.getFullYear());

	            poll_add.endPollYear.value = year;
	            poll_add.endPollMonth.value = "0" + month;
	            poll_add.endPollDay.value = day;

	            day = day - 1;
	            eval("poll_add.endPollMonth.options[" + (month + 1) + "].selected = true;");
	            eval("poll_add.endPollDay.options[" + day + "].selected = true;");
	        }
	        
	        function poll_send() {
	            if (form_check() == false) {
	            	return;
	            } else {
	            	poll_add.submit();
	            }
	        }

	        function form_check() {
	            document.getElementById("startPollYear").value = $("#Sdatepicker").datepicker({ dateFormat: 'yy' }).val().substring(0, 4);
	            document.getElementById("startPollMonth").value = $("#Sdatepicker").datepicker({ dateFormat: 'mm' }).val().substring(5, 7);// document.getElementById("idDatepicker").value.substring(5, 7);
	            document.getElementById("startPollDay").value = $("#Sdatepicker").datepicker({ dateFormat: 'dd' }).val().substring(8, 10);// document.getElementById("idDatepicker").value.substring(8, 10);

	            document.getElementById("endPollYear").value = $("#Edatepicker").datepicker({ dateFormat: 'yy' }).val().substring(0, 4);// document.getElementById("_D2").value.substring(0, 4);
	            document.getElementById("endPollMonth").value = $("#Edatepicker").datepicker({ dateFormat: 'mm' }).val().substring(5, 7);// document.getElementById("_D2").value.substring(5, 7);
	            document.getElementById("endPollDay").value = $("#Edatepicker").datepicker({ dateFormat: 'dd' }).val().substring(8, 10);// document.getElementById("_D2").value.substring(8, 10);

	            var nowdate = new Date();
	            var nowmonth = nowdate.getMonth() + 1;
	            nowmonth = nowmonth < 10 ? "0" + nowmonth : nowmonth;
	            var nowdateDay = nowdate.getDate();
	            nowdateDay = nowdateDay < 10 ? "0" + nowdateDay : nowdateDay;
	            var nowdate2 = nowdate.getFullYear() + "-" + nowmonth + "-" + nowdateDay;

	            if ($("#Edatepicker").datepicker({ dateFormat: 'yy' }).val().substring(0, 10) < nowdate2) {
	                alert("<spring:message code='ezCommunity.t595' />");
	                return false;
	            }

	            if (trim(poll_add.pollSubject.value) == "") {
                    alert("<spring:message code='ezCommunity.t592' />");
                    poll_add.pollSubject.value = "";
                    poll_add.pollSubject.focus();
                    return false;
                }
	            
                if (ByteLength(poll_add.pollSubject.value) > 200) {
                    alert("<spring:message code='ezCommunity.t593' />");
                    poll_add.pollSubject.focus();
                    return false;
                }

                if ((poll_add.selType[poll_add.selType.selectedIndex].value != "3") && (poll_add.selRes1[poll_add.selRes1.selectedIndex].value == "0") && (poll_add.selRes2.value == "")) {
                    alert("<spring:message code='ezCommunity.t594' />");
                    poll_add.selRes1.focus();
                    return false;
                }

                return true;
            }
	        
            function poll_reload() {
                window.location.reload();
                document.all("pollSubject").value = "";
            }
            function cancel_click() {
                window.location.href = "/ezCommunity/pollMain.do?code=" + code;
            }

            function ByteLength(str) {
                var i = 0
                var strlen = 0
                for (i = 0 ; i < str.length ; i++) {
                    //if (str.charCodeAt(i) > 255) {
                    //    strlen = strlen + 2;
                    //}
                    //else {
                        strlen = strlen + 1;
                    //}
                }
                return (strlen);
            }

            var FixMonth = Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
            var FixSDay = Array(0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
            var FixEDay = Array(0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

            function selsyear_onchange() {
                var Year = poll_add.startPollYear.value;

                if ((Year % 4) && Year % 100 || !(Year % 400))
                    return true;
                else
                    FixSDay[2] = 29;
            }

            function selsday_onchange() {
                var Month = parseInt(poll_add.startPollMonth.value);
                var Date = parseInt(poll_add.startPollDay.value);

                if (FixSDay[Month] < Date) {
                    alert("<spring:message code='ezCommunity.t595' />");
                    poll_add.startPollDay.selectedIndex = 0;
                    poll_add.startPollDay.focus();
                }
            }

            function selsmonth_onchange() {
                var Month = parseInt(poll_add.startPollMonth.value);

                for (var j = poll_add.startPollDay.options.length; j >= 0; j--) {
                    poll_add.startPollDay.remove(j);
                }

                for (var i = 0; i < FixSDay[Month]; i++) {
                    var option = document.createElement("option");
                    option.innerText = i + 1;
                    option.value = i + 1;

                    poll_add.startPollDay.appendChild(option);
                }
            }

            function seleyear_onchange() {
                if (poll_add.startPollYear.value == "" || poll_add.startPollMonth.value == "" || poll_add.startPollDay.value == "") {
                    alert("<spring:message code='ezCommunity.t596' />");
                    poll_add.endPollYear.selectedIndex = 0;
                    poll_add.startPollYear.focus();
                    return;
                }

                var Year = poll_add.endPollYear.value;

                if ((Year % 4) && Year % 100 || !(Year % 400)) {
                	return true;
                } else {
                    FixEDay[2] = 29;
                }
            }

            function selemonth_onchange() {
                var Month = parseInt(poll_add.endPollMonth.value);

                for (var j = poll_add.endPollDay.options.length; j >= 0; j--) {
                    poll_add.endPollDay.remove(j);
                }

                for (var i = 0; i < FixEDay[Month]; i++) {
                    var option = document.createElement("option");
                    option.innerText = i + 1;
                    option.value = i + 1;

                    poll_add.endPollDay.appendChild(option);
                }
            }

            function seleday_onchange() {
                var Month = parseInt(poll_add.endPollMonth.value);
                var Date = parseInt(poll_add.endPollDay.value);

                if (FixEDay[Month] < Date) {
                    alert("<spring:message code='ezCommunity.t595' />");
                    poll_add.endPollDay.selectedIndex = 0;
                    poll_add.endPollDay.focus();
                }
            }
            function selRes2_onchange(p_selRes2) {
                if (p_selRes2.value == "") return;

                var intV = p_selRes2.value;
                intV = intV.replace(/,/g, "");
                if (intV != parseInt(intV)) {
                    poll_add.selRes2.value = "";
                    poll_add.selRes2.focus();
                    alert("<spring:message code='ezCommunity.t597' />");
                }
            }

            function AutoAddtoExpireDate() {
                var temp = ExpireDays;
                if (temp == -1) temp = 0;
            }

            function AddDate(pDate, pDays) {
                var dt = new Date(pDate);
                dt.setDate(dt.getDate() + pDays);
                return dt;
            }

            function ismaxlength(obj) {
                var mlength = 200;
                if (obj.value.length > mlength) {
                    alert("<spring:message code='ezCommunity.lhj02' />");
                    obj.value = obj.value.substring(0, mlength);
                }
            }
		</script>
		
	</head>
	<body class = "cmhome_body">
		<h1 class="type1_h1"><spring:message code='ezCommunity.t598' /></h1>
    	<br/>
    	<br/>
    	
	    <table class="content">
	        <form action="/ezCommunity/pollAddOk.do" method="post" name="poll_add" id="polladd">
	            <input type="hidden" name="mode" value="write">
	            <input type="hidden" name="code" value="<c:out value = '${code }' />">
	            <input type="hidden" name="answerViewType" value="<c:out value = '${answerViewType }' />">
	            <input type="hidden" name="startPollYear" id="startPollYear" value="">
	            <input type="hidden" name="startPollMonth" id="startPollMonth" value="">
	            <input type="hidden" name="startPollDay" id="startPollDay" value="">
	            <input type="hidden" name="endPollYear" id="endPollYear" value="">
	            <input type="hidden" name="endPollMonth" id="endPollMonth" value="">
	            <input type="hidden" name="endPollDay" id="endPollDay" value="">
	            
	            <tr>
	                <th><spring:message code='ezCommunity.t599' /></th>
	                <td><textarea id="pollSubject" name="pollSubject" style="width: 98%; height: 130px" runat="server" onkeyup="ismaxlength(this)" value = "${pSubject}"></textarea></td>
	            </tr>
	            <tr>
	                <th><spring:message code='ezCommunity.t600' /></th>
	                <td>
	                    <select id="selType" name="selType" onchange="return selType_onchange()" style="font-size: 13px;vertical-align: middle;text-align: center;height: 18px;cursor: pointer;">
	                        <option value="1"><spring:message code='ezCommunity.t601' />
	                        <option value="2"><spring:message code='ezCommunity.t602' />
	                        <option value="3"><spring:message code='ezCommunity.t603' />
	                    </select>
	                    <select id="selRes1" name="selRes1" onchange="return selRes1_onchange()" style="font-size: 13px;vertical-align: middle;text-align: center;height: 18px;cursor: pointer;">
	                    	<option value="0">[<spring:message code='ezCommunity.t604' />
	                        <option value="1">[<spring:message code='ezCommunity.t605' />
	                        <option value="2">[<spring:message code='ezCommunity.t606' />
	                        <option value="3">[<spring:message code='ezCommunity.t607' />
							<option value="11">Yes/No
	          				<option value="12"><spring:message code='ezCommunity.t608' />
	              			<option value="13"><spring:message code='ezCommunity.t609' />
	                  		<option value="14"><spring:message code='ezCommunity.t610' />
	                    </select>
	                    
	                    <input type="text" id="selRes2" name="selRes2" onkeydown="return selRes2_onkeydown()" onchange="selRes2_onchange(this);" size="5" maxlength="3">
	                    <spring:message code='ezCommunity.t611' />
					</td>
	            </tr>
	            <tr>
	                <th rowspan="1"><spring:message code='ezCommunity.t612' /></th>
	                <td><input type="text" id="Sdatepicker" style="width:80px;text-align:center" > ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center" ></td>
	            </tr>
	        </form>
	    </table>
    
	    <div class="btnposition">
	        <a class="imgbtn" name="Submit" id="outok" onclick="poll_send();"><span><spring:message code='ezCommunity.t613' /></span></a>
	        <a class="imgbtn" name="Submit2" id="outcancel" onclick="cancel_click();"><span><spring:message code='ezCommunity.t246' /></span></a>
	    </div>
	</body>
</html>