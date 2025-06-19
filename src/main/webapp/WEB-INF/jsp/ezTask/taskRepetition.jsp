<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezTask.t21' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		<!-- 2018-05-16 구해안 스케쥴의 strLang 참조-->
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		
		<style>
			select {
				height : 20px;
			}
		</style>
		
		<script type="text/javascript">
		
		    var ReturnFunction;
		    var m_dialogArguments;
		    var lang = "<c:out value='${userInfo.lang}'/>";
		    window.onload = function () {
		        try {
		            m_dialogArguments = parent.task_repetition_cross_dialogArguments[0];
		            ReturnFunction = parent.task_repetition_cross_dialogArguments[1];
		        }
		        catch (e) {
		            m_dialogArguments = window.dialogArguments;
		        }
		
		        if (m_dialogArguments["EDATE"] != $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() || m_dialogArguments["SDATE"] != $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()) {
		            $("#Sdatepicker").datepicker('setDate', m_dialogArguments["SDATE"]);
		            $("#Edatepicker").datepicker('setDate', m_dialogArguments["EDATE"]);
		        }
		
		        var repetition = m_dialogArguments["REPETITION"];
		        
		
		        if (repetition != "") {
		            var info = repetition.split("|");
		            
					var m_objStartTime = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
		    		
		    		var iDateNumber = m_objStartTime.getDate();
		            var iWeekdayNumber = m_objStartTime.getDay();
		            var iMonthNumber = m_objStartTime.getMonth();
		
		            switch (info[0]) {
		                case "-1":
		                    range1.checked = true;
		                    break;
		                case "0":
		                    range3.checked = true;
		                    break;
		                default:
		                    range2.checked = true;
		                    list_ReCount.value = info[0];
		                    break;
		            }
		
		            if (info[1] == "1")
		                alldaycheck.checked = true;
		
		            showMainPattern(info[2]);
		
		            switch (info[2]) {
		                case "0":
		                    mpDaily.checked = true;
		                    if (info[3] == "0")
		                        id0D2.checked = true;
		                    else {
		                        id0D1.checked = true;
		                        txt_De.value = info[3];
		                    }
		                    break;
		                case "1":
		                    mpWeekly.checked = true;
		                    txt_We.value = info[3];
		                    for (var i = 0; i < info[4].length; i++) {
		                        var idx = parseInt(info[4].substr(i, 1));
		                        daytable.getElementsByTagName("input").item(idx).checked = true;
		                    }
		                    break;
		                case "2":
		                    mpMonthly.checked = true;
		                    if (info[3] == "1") {
		                        idOM1.checked = true;
		                        list_MonthInterval.value = info[4];
		                        list_MonthlyDays.value = info[5];
		                        
		                        var nEach = parseInt(iDateNumber / 7);
					            document.getElementById("list_MonthlyEach").selectedIndex = nEach;
					            SetWeekdayDropDown(list_MonthlyDay, iWeekdayNumber);
		                    }
		                    else {
		                        id0M2.checked = true;
		                        list_MonthInterval2.value = info[4];
		                        list_MonthlyEach.value = info[5];
		                        list_MonthlyDay.value = info[6];
		                        
		                        document.getElementById("list_MonthlyDays").value = iDateNumber;
		                    }
		                    
							document.getElementById("list_YearlyDays").value = iDateNumber;
				            
				            document.getElementById("list_Month").selectedIndex = iMonthNumber;
				            document.getElementById("list_Month2").selectedIndex = iMonthNumber;
				            
				            var nEach = parseInt(iDateNumber / 7);
				            document.getElementById("list_YearlyEach").selectedIndex = nEach;
				            SetWeekdayDropDown(list_YearlyDay, iWeekdayNumber);
		                    break;
		                case "3":
		                    mpYearly.checked = true;
		                    if (info[3] == "1") {
		                        optY1.checked = true;
		                        list_Month.value = info[4];
		                        list_YearlyDays.value = info[5];
		
		                        if (info[6] == "2")
		                            moonday.checked = true;
		                        
								document.getElementById("list_Month2").selectedIndex = iMonthNumber;
		    					
		    					var nEach = parseInt(iDateNumber / 7);
					            document.getElementById("list_YearlyEach").selectedIndex = nEach;
					            
					            SetWeekdayDropDown(list_YearlyDay, iWeekdayNumber);
		                    }
		                    else {
		                        optY2.checked = true;
		                        list_Month2.value = info[4];
		                        list_YearlyEach.value = info[5];
		                        list_YearlyDay.value = info[6];
		                        
		                        document.getElementById("list_Month").selectedIndex = iMonthNumber;
		    					 
		    					document.getElementById("list_YearlyDays").value = iDateNumber;
		                    }
							document.getElementById("list_MonthlyDays").value = iDateNumber;
		    				
		    				document.getElementById("list_MonthlyEach").selectedIndex = nEach;
		    				SetWeekdayDropDown(list_MonthlyDay, iWeekdayNumber);
		          	  }
		            
		            if(info[2] == "0" || info[2] == "1") {
			    		SetWeekdayDropDown(list_MonthlyDay, iWeekdayNumber);
			            SetWeekdayDropDown(list_YearlyDay, iWeekdayNumber);
			            
			            document.getElementById("list_MonthlyDays").value = iDateNumber;
			            document.getElementById("list_YearlyDays").value = iDateNumber;
		
			            document.getElementById("list_Month").selectedIndex = iMonthNumber;
			            document.getElementById("list_Month2").selectedIndex = iMonthNumber;
		
			            var nEach = parseInt(iDateNumber / 7);
			            document.getElementById("list_MonthlyEach").selectedIndex = nEach;
			            document.getElementById("list_YearlyEach").selectedIndex = nEach;
		    		}
		            
		            if(info[2] != "1") {
		            	daytable.getElementsByTagName("input").item(iWeekdayNumber).checked = true;
		            }
		        }
		        else {
		    		try {
		                m_objStartTime = new Date(m_dialogArguments["SDATE"].split(' ')[0].split('-')[0], parseInt(RetValue["SDATE"].split(' ')[0].split('-')[1]) - 1, RetValue["SDATE"].split(' ')[0].split('-')[2], RetValue["SDATE"].split(' ')[1].split(':')[0], RetValue["SDATE"].split(' ')[1].split(':')[1], 0, 0);
		            } catch (e) {
		                m_objStartTime = new Date(m_dialogArguments["SDATE"]);
		            }  
		    	
		            var iDateNumber = m_objStartTime.getDate();
		            var iWeekdayNumber = m_objStartTime.getDay();
		            var iMonthNumber = m_objStartTime.getMonth();
		            
		            daytable.getElementsByTagName("input").item(iWeekdayNumber).checked = true;

                    list_MonthlyDays.value = iDateNumber;
		            
		    		SetWeekdayDropDown(list_MonthlyDay, iWeekdayNumber);
		            SetWeekdayDropDown(list_YearlyDay, iWeekdayNumber);
		            
		            var nEach = parseInt(iDateNumber / 7);
		            document.getElementById("list_MonthlyEach").selectedIndex = nEach;
		            document.getElementById("list_YearlyEach").selectedIndex = nEach;
		            
		            document.getElementById("list_MonthlyDays").value = iDateNumber;
		            document.getElementById("list_YearlyDays").value = iDateNumber;
		            
		            document.getElementById("list_Month").selectedIndex = iMonthNumber;
		            document.getElementById("list_Month2").selectedIndex = iMonthNumber;
		    	}
		    }
		    
		    function SetWeekdayDropDown(ddDay, value)
		    {
		    	var iList;
		    	var iLength = ddDay.length;
		        
		    	for (iList = 0; iList < iLength; iList++)
		    	{  
		    		if (ddDay[iList].value == value)
		    		{ 
		    			ddDay[iList].selected = true;
		    			
		    			return;
		    		}
		    	}						
		    	return;
		    }
			
		    /*2018-05-16 구해안 취소버튼 수정*/
		    function cancel_click(){
		    	parent.DivPopUpHidden();
		        window.close();
		    }
		    /*2018-05-16 구해안 일정관리를 참조하여 년 월 일 가져오는 함수 작성*/
		    function getPickerDate()
		    {
		        var rtnString = "";
		        if(document.getElementsByName("optRangeEnd")[0].checked == true)
		        {
		            var sdate = "";		            
	                var sDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	                var sYear = sDate.split("-")[0];
	                var sMon = sDate.split("-")[1] -1;
	                var sDay = sDate.split("-")[2];		              
	               
	                sdate = new Date(sYear, sMon, sDay);
		            
		            rtnString = makeTermDate(sdate) + " ~ " + strLang46;	          
		            
		            return rtnString;
		        }
		        else if(document.getElementsByName("optRangeEnd")[1].checked == true)
		        {
	
		            var sdate = "";	            
	                var sDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	                var sYear = sDate.split("-")[0];
	                var sMon = sDate.split("-")[1] -1;
	                var sDay = sDate.split("-")[2];		               
	
		            sdate = new Date(sYear, sMon, sDay);
		           
		            rtnString = makeTermDate(sdate) + " ~ " + list_ReCount.value + strLang47;
		        
		            return rtnString;
		        }
		        else if(document.getElementsByName("optRangeEnd")[2].checked == true)
		        {
		            var sdate = "";
		            var edate = "";
		           
	                var sDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	                var sYear = sDate.split("-")[0];
	                var sMon = sDate.split("-")[1] -1;
	                var sDay = sDate.split("-")[2];		                

	                var eDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	                var eYear = eDate.split("-")[0];
	                var eMon = eDate.split("-")[1] -1;
	                var eDay = eDate.split("-")[2];	

	                sdate = new Date(sYear, sMon, sDay);
	                edate = new Date(eYear, eMon, eDay);		           
		            
		            rtnString = makeTermDate(sdate) + " ~ " + makeTermDate(edate);
	
		            return rtnString;
		        }				 
		    }
			/*2018-05-16 구해안 버튼 클릭시 taskWrite의 반복설정 text에 자세하게 설정한 정보를 보이게 수정, 일정관리를 참조하였으며 시간,분은 제외하고 년, 월, 일만 반영하도록 수정*/
		    function ok_click() {
		        var rtn = new Array();
		        rtn["SDATE"] = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        rtn["EDATE"] = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		
		        var repetition = "";
		
		        var startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()
		    	var endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()
		        var startYear = startDate.split("-")[0];
		    	var endYear = endDate.split("-")[0];
		    	var startMonth = startDate.split("-")[1];
		    	var endMonth = endDate.split("-")[1];
		    	var startDay = startDate.split("-")[2];
		    	var endDay = endDate.split("-")[2];
		    	var stime = $('#Stimepicker').val()		        
		       
				/*2018-05-16 구해안 라디오 버튼 끝날자 미선택시에도 조건체크 걸리는 것 수정*/
		        if (startYear > endYear || (startYear == endYear && parseInt(startMonth) > parseInt(endMonth)) || (startYear == endYear && parseInt(startMonth) == parseInt(endMonth) && parseInt(startDay) > parseInt(endDay))) {
		    	    if (document.getElementsByName("optRangeEnd")[2].checked == true) {
		    	        alert("<spring:message code='ezTask.t22' />");		
		    	        return;
		    	    }
		    	}
		        if (document.getElementsByName("optRangeEnd")[2].checked == false) {
		        	if (startYear > endYear || (startYear == endYear && parseInt(startMonth) > parseInt(endMonth)) || (startYear == endYear && parseInt(startMonth) == parseInt(endMonth) && parseInt(startDay) > parseInt(endDay))) {
		        		radioCheck = true;
		        	}
		        }
		        
		        var scheduleTerm = "";	
		        var recurString = "";	
		        
		        scheduleTerm = getPickerDate();
		        
		        if (range1.checked == true)
		            repetition = "-1";
		        else if (range2.checked == true) {
		            if (list_ReCount.value == parseInt(list_ReCount.value) && parseInt(list_ReCount.value) > 0)
		                repetition = parseInt(list_ReCount.value);
		            else {
		                alert("<spring:message code='ezTask.t23' />");
		                list_ReCount.focus();
		                return;
		            }
		        }
		        else
		            repetition = "0";
		
		        if (alldaycheck.checked == true)
		            repetition += "|1";
		        else
		            repetition += "|0";
		
		        if (mpDaily.checked == true) {
		            repetition += "|0";
		
		            if (id0D2.checked == true){
		                repetition += "|0";
		            	recurString = strLang45;
		            }
		            else {
		                if (txt_De.value == parseInt(txt_De.value) && parseInt(txt_De.value) > 0)
		                    repetition += "|" + parseInt(txt_De.value);
		                else {
		                    alert("<spring:message code='ezTask.t24' />");
		                    txt_De.focus();
		                    return;
		                }
		                if(txt_De.value == "1"){
		                    recurString = strLang34;						
		    			}
		    			else{
		    			    recurString = txt_De.value + strLang81;						
		    			}
		            }
		        }
		        else if (mpWeekly.checked == true) {
		            repetition += "|1";
		
		            if (txt_We.value == parseInt(txt_We.value) && parseInt(txt_We.value) > 0)
		                repetition += "|" + parseInt(txt_We.value);
		            else {
		                alert("<spring:message code='ezTask.t25' />");
		                txt_We.focus();
		                return;
		            }
		
		            var days = "";
		            var checks = daytable.getElementsByTagName("input");
		            for (var i = 0; i < checks.length; i++)
						if (checks.item(i).checked == true){
		                	
		                    days += checks.item(i).value;
		                    recurString = recurString + getDaystring(i);
							
		    		        recurString = recurString + ","			
		                }
		            var index = recurString.lastIndexOf(",");
		    		recurString	= recurString.substring(0,recurString.length-1);
		            if (days == "") {
		                alert("<spring:message code='ezTask.t26' />");
		                return;
		            }
		
		            repetition += "|" + days
		            
		            if(txt_We.value == "1")
		    		{
		    		    recurString = strLang35 + " " + recurString;
		    		}
		    		else
		    		{
		    		    recurString = txt_We.value + strLang82 + " " + recurString;
		    		}
		        }
		        else if (mpMonthly.checked == true) {
		            repetition += "|2";
		
		            if (idOM1.checked == true) {
		                repetition += "|1";
		
		                if (list_MonthInterval.value == parseInt(list_MonthInterval.value) && parseInt(list_MonthInterval.value) > 0)
		                    repetition += "|" + parseInt(list_MonthInterval.value);
		                else {
		                    alert("<spring:message code='ezTask.t27' />");
		                    list_MonthInterval.focus();
		                    return;
		                }
		
		                if (list_MonthlyDays.value == parseInt(list_MonthlyDays.value) && parseInt(list_MonthlyDays.value) > 0 &&
		                    parseInt(list_MonthlyDays.value) < 32)
		                    repetition += "|" + parseInt(list_MonthlyDays.value);
		                else {
		                    alert("<spring:message code='ezTask.t28' />");
		                    list_MonthlyDays.focus();
		                    return;
		                }

		                if(list_MonthInterval.value == 1){
		    			    recurString = strLang36 + " " + list_MonthlyDays.value + strLang80;
		    			}
		    			else{
		    			    recurString = list_MonthInterval.value + strLang83 + " " + list_MonthlyDays.value + strLang80;						
		    			}
		            }
		            else {
		                repetition += "|2";
		
		                if (list_MonthInterval2.value == parseInt(list_MonthInterval2.value) && parseInt(list_MonthInterval2.value) > 0)
		                    repetition += "|" + parseInt(list_MonthInterval2.value);
		                else {
		                    alert("<spring:message code='ezTask.t27' />");
		                    list_MonthInterval2.focus();
		                    return;
		                }
		
		                repetition += "|" + list_MonthlyEach.value;
		                repetition += "|" + list_MonthlyDay.value;

		                if(list_MonthInterval2.value == 1){
		    			    recurString = strLang36 + " " + getOdinalString(parseInt(list_MonthlyEach.value)) + " " + getFullDaystring(parseInt(list_MonthlyDay.value));
		    			} else {					
		    			    recurString =  list_MonthInterval2.value + strLang83 + " " + getOdinalString(parseInt(list_MonthlyEach.value)) + " " + getFullDaystring(parseInt(list_MonthlyDay.value));					
		    			}
		            }
		        }
		        else {
		            repetition += "|3";
		            recurString = strLang37;
		            if (optY1.checked == true) {
		                repetition += "|1";
		                repetition += "|" + list_Month.value;
						
		                recurString = recurString + " " + getMonthString(parseInt(list_Month.value)) + " " + list_YearlyDays.value + strLang80;	
		                
		                var enddate0;
		                var errorMeg;
		
		                if (list_Month.value == "2") {
		                    enddate0 = "30";
		                    errorMeg = "<spring:message code='ezTask.t237' />"
		
		                }
		                else if (list_Month.value == "4" || list_Month.value == "6" || list_Month.value == "9" || list_Month.value == "11") {
		                    enddate0 = "31";
		                    errorMeg = "<spring:message code='ezTask.t238' />"
		                }
		                else {
		                    enddate0 = "32";
		                    errorMeg = "<spring:message code='ezTask.t28' />"
		                }
		
		
		
		                if (list_YearlyDays.value == parseInt(list_YearlyDays.value) && parseInt(list_YearlyDays.value) > 0 &&
		                    parseInt(list_YearlyDays.value) < enddate0)
		                    repetition += "|" + parseInt(list_YearlyDays.value);
		                else {
		
		                    alert(errorMeg);
		                    list_YearlyDays.focus();
		                    return;
		                }
		
		
		
		                if (moonday.checked == true)
		                    repetition += "|2";
		                else
		                    repetition += "|1";
		            }
		            else {
		                repetition += "|2";
		                repetition += "|" + list_Month2.value;
		                repetition += "|" + list_YearlyEach.value;
		                repetition += "|" + list_YearlyDay.value;
		                
		                recurString = recurString + " " + getMonthString(parseInt(list_Month2.value)) + " " + getOdinalString(parseInt(list_YearlyEach.value)) + " " + getFullDaystring(parseInt(list_YearlyDay.value));
		            }
		        }
		
		        rtn["REPETITION"] = repetition;
		        /*2018-05-16 구해안 task_write_cross */
		        rtn["REPDISPLAY"] = strLang33 + " " + recurString + ", " + strLang79 + " : " + scheduleTerm;
		        
		        if (ReturnFunction != null){
		            window.parent.timeCheck = true;
		    		ReturnFunction(rtn);
		    	    parent.DivPopUpHidden();
		        }
		        else{
		            window.returnValue = rtn;
			        window.close();
		        }		        
		    }
					
		    function remove_click() {
		    	//2018.05.23 구해안 반복 일정 취소 시 시가 기준 점 기존으로 변경(스케쥴 참고)
		    	window.parent.timeCheck = false;
		        var rtn = new Array();
		        rtn["SDATE"] = "";
		        rtn["EDATE"] = "";
		        rtn["REPETITION"] = "";
		
		        if (ReturnFunction != null)
		            ReturnFunction(rtn);
		        else
		            window.returnValue = rtn;
		        parent.DivPopUpHidden();
		        window.close();
		    }
		    function showMainPattern(idx) {
		        for (var x = 0; x < 4; x++) {
		            document.getElementById('divRecurPatterns' + x).style.display = "none";
		        }
		        document.getElementById('divRecurPatterns' + idx).style.display = "";
		    }
		    document.onkeydown = function (evt) {
		        var e = evt;
		        if (e == null) e = window.event;
		        if (new RegExp(/Safari/).test(navigator.userAgent) && navigator.userAgent.indexOf("Chrome") == -1) {
		            if ((e.keyCode > 47) && (e.keyCode < 58))
		            {
		                e.preventDefault();
		            }
		            else if ((e.keyCode > 95) && (e.keyCode < 106))
		            {
		                e.preventDefault();
		            }
		            else if ((e.keyCode > 64) && (e.keyCode < 91))
		            {
		                e.preventDefault();
		            }
		            else if ((e.keyCode == 106) ||
		                (e.keyCode == 107) ||
		                (e.keyCode == 109) ||
		                (e.keyCode == 110) ||
		                (e.keyCode == 111) ||
		                (e.keyCode == 186) ||
		                (e.keyCode == 187) ||
		                (e.keyCode == 188) ||
		                (e.keyCode == 189) ||
		                (e.keyCode == 190) ||
		                (e.keyCode == 191) ||
		                (e.keyCode == 192) ||
		                (e.keyCode == 219) ||
		                (e.keyCode == 220) ||
		                (e.keyCode == 221) ||
		                (e.keyCode == 222))
		            {
		                e.preventDefault();
		            }
		            else if ((e.keyCode == 229))
		            {
		                e.returnValue = false;
		            }
		        }
		    }
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		    });
		    if(lang == "1"){
			    $(function () {
			        $.datepicker.regional['ko'] = {
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
		    function makeTermDate(pdate)
		    {
		        var date = new Date(pdate);
		        var dateYear = date.getFullYear();
		        var dateMonth = (parseInt(date.getMonth()) + 1) 
		        var dateDay = date.getDate();
		        
		        if(dateMonth < 10)
		        {
		            dateMonth = "0" + dateMonth;
		        }
		        
		        if(dateDay < 10)
		        {
		            dateDay = "0" + dateDay;
		        }
	
		        return dateYear + "-" + dateMonth + "-" + dateDay;
		    }
	
		    function getDaystring(cnt)
		    {			
		        var rtnString = "";
		        switch (cnt)
		    	{
		    		case 0:					   
		    			rtnString = strLang48;
		    			break;
		    		case 1:
		    			rtnString = strLang49;
		    			break;
		    		case 2:
		    			rtnString = strLang50;
		    			break;
		    		case 3:
		    			rtnString = strLang51;
		    			break;
		    		case 4:
		    			rtnString = strLang52;
		    			break;
		    		case 5:
		    			rtnString = strLang53;
		    			break;
		    		case 6:
		    			rtnString = strLang54;
		    			break;	
		    	}				
		    	return " " + rtnString;
		    }
		    function getMonthString(cnt)
		    {					
		        var rtnString = "";
		        switch (cnt)
		    	{				
		    		case 1:
		    			rtnString = strLang67;
		    			break;
		    		case 2:
		    			rtnString = strLang68;
		    			break;
		    		case 3:
		    			rtnString = strLang69;
		    			break;
		    		case 4:
		    			rtnString = strLang70;
		    			break;
		    		case 5:
		    			rtnString = strLang71;
		    			break;
		    		case 6:
		    			rtnString = strLang72;
		    			break;	
		    		case 7:
		    		    rtnString = strLang73;
		    		    break;	
		    		case 8:
		    		    rtnString = strLang74;
		    		    break;	
		    		case 9:
		    		    rtnString = strLang75;
		    		    break;	
		    		case 10:
		    		    rtnString = strLang76;
		    		    break;	
		    		case 11:
		    		    rtnString = strLang77;
		    		    break;	
		    		case 12:
		    		    rtnString = strLang78;
		    		    break;	
		    	}
		    	return rtnString;
		    }
		    function getFullDaystring(cnt)
		    {
		        var rtnString = "";
		        switch (cnt)
		    	{
		    		case 0:
		    			rtnString = strLang60;
		    			break;
		    		case 1:
		    			rtnString = strLang61;
		    			break;
		    		case 2:
		    			rtnString = strLang62;
		    			break;
		    		case 3:
		    			rtnString = strLang63;
		    			break;
		    		case 4:
		    			rtnString = strLang64;
		    			break;
		    		case 5:
		    			rtnString = strLang65;
		    			break;
		    		case 6:
		    			rtnString = strLang66;
		    			break;	
		    	}
		    	return rtnString;
		    }
		    function getOdinalString(cnt)
		    {			
		        var rtnString = "";
		        switch (cnt)
		    	{					
		    		case 1:
		    			rtnString = strLang55;
		    			break;
		    		case 2:
		    			rtnString = strLang56;
		    			break;
		    		case 3:
		    			rtnString = strLang57;
		    			break;
		    		case 4:
		    			rtnString = strLang58;
		    			break;
		    		case 5:
		    			rtnString = strLang59;
		    			break;					
		    	}
		    	return rtnString;
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezTask.t21' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="cancel_click()"></span></li>
            </ul>
        </div>
		<div id="TB_Promise" style="display:none">
			<h2><spring:message code='ezTask.t29' /></h2>
			<table class="content">
				<tr>
					<th><spring:message code='ezTask.t30' /></th>
					<td><input readonly ="true" type="text" id='_T1' class="textarea">
					<label FOR="btnT1"> <img id='btnT1' popupLocation='bottomleft' src="/images/i_scheduler.gif" width="19" height="15" style="cursor:pointer"> </label>
					<input type="checkbox" value="1" id="alldaycheck" checked>
					<spring:message code='ezTask.t31' /></td>
				</tr>
				<tr>
					<th><spring:message code='ezTask.t32' /></th>
					<td><input readonly ="true" id='_T2' type="text" class="textarea" style="width:100px">
					<label FOR="btnT2"> <img id='btnT2' popupLocation='bottomleft' src="/images/i_scheduler.gif" width="19" height="15" style="cursor:pointer"> </label></td>
				</tr>
			</table>
		</div>
		<h2 style="margin:0px;padding:0px"><spring:message code='ezTask.t33' /></h2>
		<table class="popuplist" style="width:100%;margin-bottom:10px">
			<tr>
				<td style="padding-left:5px">
					<input id="mpDaily" type="radio" name="optMainPattern" value="radiobutton" style="margin:0px 0px 0px 0px;vertical-align:middle;" onClick='showMainPattern(0);'>
					<label for="mpDaily" style="vertical-align:middle;"><spring:message code='ezTask.t34' /></label>
					<input id="mpWeekly" type="radio" name="optMainPattern" value="radiobutton" style="margin:0px 0px 0px 0px;vertical-align:middle;" checked onClick='showMainPattern(1);'>
					<label for="mpWeekly" style="vertical-align:middle;"><spring:message code='ezTask.t35' /></label>
					<input id="mpMonthly" type="radio" name="optMainPattern" value="radiobutton" style="margin:0px 0px 0px 0px;vertical-align:middle;" onClick='showMainPattern(2);'>
					<label for="mpMonthly" style="vertical-align:middle;"><spring:message code='ezTask.t36' /></label>
					<input id="mpYearly" type="radio" name="optMainPattern" value="radiobutton" style="margin:0px 0px 0px 0px;vertical-align:middle;" onClick='showMainPattern(3);'>
					<label for="mpYearly" style="vertical-align:middle;"><spring:message code='ezTask.t37' /></label>
				</td>
			</tr>
			<tr>
				<td style="height:80px;">
					<div id='divRecurPatterns0' style="display:none;padding-left:5px;">
						<input id="id0D1" type="radio" name="optDaily" style="margin:0px 0px 0px 0px;vertical-align:middle;" checked>
						<label for="txt_De" style="vertical-align:middle;"><spring:message code='ezTask.t41' />&nbsp;
						<input name="text" type="text" id="txt_De" style="Width:40px;height:18px;text-align: center;" onFocus='window.document.all["optDaily"][0].checked=true;' value="1" maxlength='3'>
						&nbsp;<spring:message code='ezTask.t39' /></label>
						<br>
						<br>
						<input id="id0D2" type="radio" name="optDaily" style="margin:0px 0px 0px 0px;vertical-align:middle;">
						<label for="id0D2" style="vertical-align:middle;"><spring:message code='ezTask.t40' /></label>
					</div>
					<div id='divRecurPatterns1'>&nbsp;<spring:message code='ezTask.t41' />
						<label for="txt_We">
						<input id="txt_We" type="text" name="textfield222" class="textarea" style="width:50px;height:18px;text-align: center;" value="1">
						<spring:message code='ezTask.t42' /></label>
						<table id="daytable" style="margin-top:3px">
							<tr>
								<td style="height:0px;"><input type="checkbox" name="day" value="0" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t43' /></span></td>
								<td style="height:0px;"><input type="checkbox" name="day" value="1" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t44' /></span></td>
								<td style="height:0px;"><input type="checkbox" name="day" value="2" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t45' /></span></td>
								<td style="height:0px;"><input type="checkbox" name="day" value="3" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t46' /></span></td>
							</tr>
							<tr>
								<td style="height:0px;"><input type="checkbox" name="day" value="4" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t47' /></span></td>
								<td style="height:0px;"><input type="checkbox" name="day" value="5" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t48' /></span></td>
								<td style="height:0px;"><input type="checkbox" name="day" value="6" style="vertical-align:middle">
								<span style="vertical-align:middle"><spring:message code='ezTask.t49' /></span></td>
								<td style="height:0px;">&nbsp;</td>
							</tr>
						</table>
					</div>
					<div  id='divRecurPatterns2' style="display:none;padding-left:5px;">
						<input type="radio" name='optMonthly' id="idOM1" style="margin:0px 0px 0px 0px;vertical-align:middle;" checked>
						<label for="idOM1" style="vertical-align:middle"><spring:message code='ezTask.t50' />&nbsp;</label>
						<input name="Input" id="list_MonthInterval" style="Width:40px;text-align: center;" onFocus='window.document.all["optMonthly"][0].checked=true;' value="1" maxlength="3">
						&nbsp;<spring:message code='ezTask.t51' />
						<input name="Input" id="list_MonthlyDays" style="Width:40px;text-align: center;" onFocus='window.document.all["optMonthly"][0].checked=true;' maxlength="2">
						&nbsp;<spring:message code='ezTask.t52' /><br><br>
						<input id="id0M2" type="radio" name='optMonthly' style="margin:0px 0px 0px 0px;vertical-align:middle;">
						<label for="id0M2" style="vertical-align:middle"><spring:message code='ezTask.t53' />&nbsp;</label>
						<input name="Input" id="list_MonthInterval2" style="Width:40px;text-align: center;" onFocus='window.document.all["optMonthly"][1].checked=true;' value="1" maxlength="3">
						&nbsp;<spring:message code='ezTask.t51' />
						<select name="select" id="list_MonthlyEach" onFocus='window.document.all["optMonthly"][1].checked=true;'>
							<option value="1"><spring:message code='ezTask.t54' /></option>
							<option value="2"><spring:message code='ezTask.t55' /></option>
							<option value="3"><spring:message code='ezTask.t56' /></option>
							<option value="4"><spring:message code='ezTask.t57' /></option>
							<option value="5"><spring:message code='ezTask.t58' /></option>
						</select>
						<select name="select" id="list_MonthlyDay" onFocus='window.document.all["optMonthly"][1].checked=true;'>
							<option value="0"><spring:message code='ezTask.t43' /></option>
							<option value="1"><spring:message code='ezTask.t44' /></option>
							<option value="2"><spring:message code='ezTask.t45' /></option>
							<option value="3"><spring:message code='ezTask.t46' /></option>
							<option value="4"><spring:message code='ezTask.t47' /></option>
							<option value="5"><spring:message code='ezTask.t48' /></option>
							<option value="6"><spring:message code='ezTask.t49' /></option>
						</select>
						&nbsp;<spring:message code='ezTask.t60' />
					</div>
					<div id='divRecurPatterns3' style="display:none;padding-left:5px;"><input id="optY1" type="radio" name="optYearly" value="radiobutton" style="margin:0px 0px 0px 0px;vertical-align:middle;" checked>
						<label for="optY1" style="vertical-align:middle"><spring:message code='ezTask.t50' />&nbsp;</label>
						<select name="select" id="list_Month" onFocus='window.document.all["optYearly"][0].checked=true;'>
							<option value="1"><spring:message code='ezTask.t225' /></option>
							<option value="2"><spring:message code='ezTask.t226' /></option>
							<option value="3"><spring:message code='ezTask.t227' /></option>
							<option value="4"><spring:message code='ezTask.t228' /></option>
							<option value="5"><spring:message code='ezTask.t229' /></option>
							<option value="6"><spring:message code='ezTask.t230' /></option>
							<option value="7"><spring:message code='ezTask.t231' /></option>
							<option value="8"><spring:message code='ezTask.t232' /></option>
							<option value="9"><spring:message code='ezTask.t233' /></option>
							<option value="10"><spring:message code='ezTask.t234' /></option>
							<option value="11"><spring:message code='ezTask.t235' /></option>
							<option value="12"><spring:message code='ezTask.t236' /></option>
						</select>
						<input name="Input" class="text" id="list_YearlyDays" style="Width:40px;text-align: center;" onFocus='window.document.all["optYearly"][0].checked=true;' maxlength="2">
						&nbsp;<spring:message code='ezTask.t62' />
						<c:if test="${userInfo.lang == 1}" >
							<input type="checkbox" value="1" id="moonday" style="margin:0px 0px 2px 0px;vertical-align:middle;display:none;">
							<%-- <spring:message code='ezTask.t63' /> --%><br>
						</c:if>
						<c:if test="${userInfo.lang != 1}" >
							<input type="checkbox" value="1" id="moonday" style="margin:0px 0px 2px 0px;vertical-align:middle;display:none;">
						</c:if>
						<br>
						<input id="optY2" type="radio" name="optYearly" value="radiobutton" style="margin:0px 0px 0px 0px;vertical-align:middle;">          
						<label for="optY2" style="vertical-align:middle"><spring:message code='ezTask.t53' />&nbsp;</label>
						<select name="select" id="list_Month2" onFocus='window.document.all["optYearly"][1].checked=true;'>
							<option value="1"><spring:message code='ezTask.t225' /></option>
							<option value="2"><spring:message code='ezTask.t226' /></option>
							<option value="3"><spring:message code='ezTask.t227' /></option>
							<option value="4"><spring:message code='ezTask.t228' /></option>
							<option value="5"><spring:message code='ezTask.t229' /></option>
							<option value="6"><spring:message code='ezTask.t230' /></option>
							<option value="7"><spring:message code='ezTask.t231' /></option>
							<option value="8"><spring:message code='ezTask.t232' /></option>
							<option value="9"><spring:message code='ezTask.t233' /></option>
							<option value="10"><spring:message code='ezTask.t234' /></option>
							<option value="11"><spring:message code='ezTask.t235' /></option>
							<option value="12"><spring:message code='ezTask.t236' /></option>
						</select>
						<select name="select" id="list_YearlyEach" onFocus='window.document.all["optYearly"][1].checked=true;'>
							<option value="1"><spring:message code='ezTask.t54' /></option>
							<option value="2"><spring:message code='ezTask.t55' /></option>
							<option value="3"><spring:message code='ezTask.t56' /></option>
							<option value="4"><spring:message code='ezTask.t57' /></option>
							<option value="5"><spring:message code='ezTask.t58' /></option>
						</select>
						<select name="select" id="list_YearlyDay" onFocus='window.document.all["optYearly"][1].checked=true;'>
							<option value="0"><spring:message code='ezTask.t43' /></option>
							<option value="1"><spring:message code='ezTask.t44' /></option>
							<option value="2"><spring:message code='ezTask.t45' /></option>
							<option value="3"><spring:message code='ezTask.t46' /></option>
							<option value="4"><spring:message code='ezTask.t47' /></option>
							<option value="5"><spring:message code='ezTask.t48' /></option>
							<option value="6"><spring:message code='ezTask.t49' /></option>
						</select>
						&nbsp;<spring:message code='ezTask.t60' />
					</div>
				</td>
			</tr>
		</table>
		<h2><spring:message code='ezTask.t64' /></h2>
		<!-- 2018-05-16 구해안 테이블 UI수정 (좌측 td rowspan="4"주고 통합 및 용어, 위치 변경 하고 시작일 추가)-->
		<table class="content">
			<tr>
		    	<th align="right" rowspan="4">&nbsp;&nbsp;&nbsp;<spring:message code='ezTask.t65' />&nbsp;&nbsp;&nbsp;</th>
		    	<td width="100%">		    		
		    		<div style="height:25px;margin-top:5px">
		    			<span style="margin-left: 5px;" class="repeatRange"><spring:message code='ezTask.t121' /></span>
		    			<input type="text" id="Sdatepicker" style="width:80px;text-align:center;margin-left:3px;margin-bottom:1px;" readonly="readonly">
		    		</div>
		    	</td>
		  	</tr>
		  	<tr>
		  		<td>
		  		<div style="height:25px;">
		  			<input type="radio" name="optRangeEnd" id="range1" value="-1" checked style="vertical-align:middle;margin-top:3px"><span><spring:message code='ezTask.t73' /></span>
		  		</div>
		  		</td>
		  	</tr>
		  	<tr>
		    	<td>
		    		<div style="height:32px;">
						<input type="radio" id="range2" name="optRangeEnd" value="1" style="vertical-align:middle;margin-top:5px"><span><spring:message code='ezTask.t74' /></span>
						<input id="list_ReCount" maxlength="3" onFocus="range2.checked = true" size="4" value='10'>
						<span style="vertical-align:middle"><spring:message code='ezTask.t75' /></span>
					</div>
		      	</td>
		  	</tr>
		  	<tr>
		    	<td>
		    		<input id="range3" type="radio" name="optRangeEnd" value="0" style="margin-top:0px"><span style="vertical-align:middle"><spring:message code='ezTask.t76' /></span>
					<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">		    		
		    	</td>
		  	</tr>
		</table>		
		<div class="btnposition btnpositionNew">
			<a class="imgbtn" onClick="ok_click()" ><span><spring:message code='ezTask.t19' /></span></a>
			<a class="imgbtn" onClick="remove_click()" ><span><spring:message code='ezTask.t77' /></span></a>
		</div>
	</body>
</html>