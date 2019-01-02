<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
        <link rel="stylesheet" href="${util.addVer('/css/olstyle_nonIE.css')}" type="text/css" />
        <link rel="stylesheet" href="${util.addVer('ezSchedule.e3', 'msg')}" type="text/css" />
        <link rel="stylesheet" href="${util.addVer('/css/ezSchedule/Calendar_cross.css')}" type="text/css" />  
        <link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
        <script type="text/javascript">
        	var UserOffset = "<c:out value='${pOffset}'/>";
        </script>      
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
		
		</style>
		<script type="text/javascript">		    
			var timeZoneStr = "<c:out value='${timeZoneStr}'/>";
			var receivecount = "<c:out value='${receiveCount}'/>";
			var groupcount = "<c:out value='${groupCount}'/>";
			var userid = "<c:out value='${userInfo.id}'/>";
		    var deptid = "<c:out value='${userInfo.deptID}'/>";
		    var uselang = "<c:out value='${userInfo.lang}'/>";
			var deptadmin = "<c:out value='${deptAdmin}'/>";
			var companyadmin = "<c:out value='${companyAdmin}'/>";
			var idtype = "<c:out value='${idType}'/>";
		    var otherid = "<c:out value='${otherId}'/>";
		    var groupid = "<c:out value='${groupId}'/>";
			var secretaryxml = "";
			var groupxml = "${groupXmlTemp}";
			var sharexml = "";
		    var idlist = "${idList}";
		    var pDisplaySTime = "<c:out value='${startTime}'/>";
		    var pDisplayETime = "<c:out value='${endTime}'/>";
		    var pDefaultview = "<c:out value='${defaultView}'/>";
		    var pStartday = "<c:out value='${startDay}'/>";
		    var pUse_Editor = "<c:out value='${useEditor}'/>";
		    var LunarUse = false;		    
		    var primaryLang = "<c:out value='${userInfo.primary}'/>";		// 2018-12-26 김민성 - 일정관리 기념일 다국어 처리
		    select_memorialDays(uselang);
		    
		    /* 2018-08-11 장진혁 - 레이어팝업 생성된 상태에서 backspace 누를시 왼쪽프레임 부분 딤 처리 없애기 */
	        window.onunload = function () {
	        	if (parent.frames["left"]) {
	        		if (parent.frames["left"].document.getElementById("blockLeft")) {
	        			$(parent.frames["left"].document.body).css("overflow", "");
	        	    	$(parent.frames["left"].document.getElementById("blockLeft")).remove();
	        		}
	        	} else if (parent.frames["attitude_menu"]) {
	        		if (parent.frames["attitude_menu"].document.getElementById("blockLeft")) {
	        	    	$(parent.frames["attitude_menu"].document.getElementById("blockLeft")).remove();
	        		}
	        	}
	        	      
	        	if (parent.parent.frames["left"]) {
	        		if (parent.parent.frames["board_menu"]) {  		  
	        			$(parent.parent.frames["board_menu"].document.body).css("overflow", "");
	        			$(parent.parent.frames["board_menu"].document.getElementById("blockLeft")).remove();
	        			$(parent.parent.frames["board_main"].document.getElementById("blockTop")).remove();
	        		} else if (parent.parent.frames["left"].document.getElementById("blockLeft")) {  		  
	        			$(parent.parent.frames["left"].document.body).css("overflow", "");
	        			$(parent.parent.frames["left"].document.getElementById("blockLeft")).remove();
	        			$(parent.parent.frames["right"].document.getElementById("blockTop")).remove();
	        		}
	        	}
	        }
		    
		    function schedule_get_holiday() {		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : true,
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
			                    } else {                   	
			                        yearmemorialDays.push(new yearmemorialDay(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME")[0].textContent, GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYNAME2")[0].textContent,
			                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(0, 4),
			                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(5, 7),
			                            GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HOLIDAYDATE")[0].textContent.substring(0, 10).substring(8, 10), issolar, holiday));
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
		    
		    window.onresize = resize;
		    document.onselectstart = function () { return false; };
		    function disablelayer() {
		        newlayer.style.display = "none";
		    }		    
		    
		    function schedule_get_lunaruse() {
		    	if (uselang != 3) {
				    $.ajax({
			    		type : "POST",
			    		dataType : "text",
			    		async : false,
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

		    var schedule_receive_attendant_cross_dialogArguments = new Array();

		    window.onload = function () {    	
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        if (pDefaultview == 2) {
		            typeCal = 0
		            // 2018-06-07 구해안 미니 호출 부분 주석처리
		            parent.frames["left"].typeCal = 0

		        } else if (pDefaultview == 1) {
		            typeCal = 1
		            parent.frames["left"].typeCal = 1
		        } else if (pDefaultview == 0) {
		            typeCal = 2
		            parent.frames["left"].typeCal = 2
		        }

		        if (pStartday == 1)
		            DefaultView = 1
		        else
		            DefaultView = 0            
       
				if (receivecount != "0") {
					parent.frames["left"].document.body.style.overflow = "hidden";
		            schedule_receive_attendant_cross_dialogArguments[0] = this;
		            schedule_receive_attendant_cross_dialogArguments[1] = windowonload_Complete;
		           
		            DivPopUpShow(730,370,"/ezSchedule/scheduleReceiveAttendant.do");
		        	
		            $("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%'></div>").appendTo(parent.frames["left"].document.body);        	
		        	var popupX = parent.document.body.clientWidth/2 - (730/2) - 220;
		        	$("#iFramePanel").css("left", popupX);

		            try { OpenWin.focus(); } catch (e) { }
		        } else {
		            windowonload_Complete("empty");
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
		    function windowonload_Complete(ret) {
		    	DivPopUpHidden();
		    	
		    	if(ret != "empty") { 
		    		$(parent.frames["left"].document.getElementById("blockLeft")).remove();
		    	}
		        
		    	if (groupcount != "0") {
		    		parent.frames["left"].document.body.style.overflow = "hidden";
		            schedule_receive_member_dialogArguments[0] = this;
		            schedule_receive_member_dialogArguments[1] = windowonload_Complete2;
		            
		            DivPopUpShow(730,370,"/ezSchedule/scheduleReceiveMember.do");
		            
		            $("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%'></div>").appendTo(parent.frames["left"].document.body);        	
		        	var popupX = parent.document.body.clientWidth/2 - (730/2) - 220;
		        	$("#iFramePanel").css("left", popupX);
		        	
		            try { OpenWin.focus(); } catch (e) { }
		        } else {
		            windowonload_Complete2("empty");
		        }
		    }

		    function windowonload_Complete2(ret) {
		    	schedule_get_lunaruse();
		    	DivPopUpHidden();
		    	
		    	if(ret != "empty") { 
		    		$(parent.frames["left"].document.getElementById("blockLeft")).remove();
		    	}
              
		    	var xmldom = createXmlDom();

		    	// 2018-06-08 구해안 셀렉트박스 미사용으로 주석처리
		        /* if (groupxml != "") {
		            var groupxmldom = loadXMLString(groupxml);
   
		            for (var i = 0; i < groupxmldom.getElementsByTagName("GROUPID").length; i++) {
		                var lastindex = idSelect.length;
		                var newoption = new Option("<spring:message code='ezSchedule.t204'/>" + " " + getNodeText(groupxmldom.getElementsByTagName("GROUPNAME")[i]), getNodeText(groupxmldom.getElementsByTagName("GROUPID")[i]));
		                idSelect.options[lastindex] = newoption;
                    }
                } */
                //alert('windowonload_Complete2');
		        
                if (otherid != "") {
                    secretarySelect.value = otherid;
                }
                
                if (ret == "success" ) {
	                parent.frames["left"].leftRefresh();
                }
                resize();
		    }
			
			//2018-10-18 김혜정 ics 파일 기간 설정을 위해 추가
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
				
				$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Sdatepicker").datepicker('setDate', "");
			
				$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Edatepicker").datepicker('setDate', "");
				
				var monthMsg = "<spring:message code='ezSchedule.t110' />";
				var monthStr = monthMsg.split(";");
				var dayMsg = "<spring:message code='ezSchedule.t108' />";
				var dayStr = dayMsg.split(";");
				
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

		        if (repeatcount == "Y") {	        	
		            schedule_read_confirm_cross_dialogArguments[0] = "";
		            schedule_read_confirm_cross_dialogArguments[1] = ReadSchedule_Complete;
		            GetOpenWindow("/ezSchedule/scheduleReadConfirm.do", "schedule_read_confirm_Cross", 400, 170);
		        } else {		        	
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 670) / 2;
		            var pLeft = (pwidth - 790) / 2;
		            window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&otherid=" + encodeURIComponent(otherid) + "&repeatcount=" + repeatcount + "&date=" + date + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + ret, "",
                                "height = 670px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=no");
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
		            window.open("/ezSchedule/scheduleRead.do" + "?id=" + encodeURIComponent(scheduleid) + "&otherid=" + encodeURIComponent(otherid) + "&repeatcount=" + repeatcount + "&date=" + date + "&type=" + scheduletype + "&datetype=" + datetype + "&pattern=" + ret, "",
					            "height = 670px, width = 790px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ",  status = no, toolbar=no, menubar=no,location=no, resizable=no");
		        } else {
		            return;
		        }
		    }
			
		    function WriteSchedule() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 760) / 2;
		        var pLeft = (pwidth - 790) / 2;
		        
		        if (otherid == "") {
		        	// 2018-06-08 구해안 셀렉트박스 미사용으로 주석처리
		            /* var index = idSelect.selectedIndex;
		            if (index == -1)
		                index = 0; */
					var index = 0;
		           /*  if (idSelect.options[idSelect.selectedIndex].onlyread == "1")
		                index = 0; */
                    
		            var feature = GetOpenPosition(790, 760);
		            //if (CrossYN()) {
		                window.open("/ezSchedule/scheduleWrite.do?defaultid=" + index, "", "height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            /* } else {
		                if (pUse_Editor == "" || pUse_Editor == "CK") {
		                    window.open("schedule_write.aspx?defaultid=" + index, "",
						        "height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		                }
		                else {
		                    window.open("schedule_write_IE.aspx?defaultid=" + index, "",
						        "height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		                }
		            } */
		        } else {
		            /* var type = GetAttribute(secretarySelect.options[secretarySelect.selectedIndex], "type") == "user" ? "6" : "8"; */

		            var feature = GetOpenPosition(790, 760);
		            //if (CrossYN()) {
		                window.open("/ezSchedule/scheduleWrite.do?otherid=" + encodeURIComponent(otherid) + "&type=" + type + "&othername=" + encodeURIComponent(secretarySelect.options[secretarySelect.selectedIndex].innerHTML) + "&datetype=2", "",
						    "height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            /* } else {
		                if (pUse_Editor == "" || pUse_Editor == "CK") {
		                    window.open("schedule_write.aspx?otherid=" + escape(otherid) + "&type=" + type + "&othername=" + escape(getNodeText(secretarySelect.options[secretarySelect.selectedIndex])) + "&datetype=2", "",
						    "height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		                else {
		                    window.open("schedule_write_IE.aspx?otherid=" + escape(otherid) + "&type=" + type + "&othername=" + escape(getNodeText(secretarySelect.options[secretarySelect.selectedIndex])) + "&datetype=2", "",
						    "height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		            } */
		        }
		    }
			
		    function WriteDateSchedule(e) {
		        var srcEl;

		        if (CrossYN()) {		            
		            srcEl = e;
		        } else {
		            srcEl = window.event.srcElement;
		        }

		        var sdate, edate, datetype;

		        // 2018-11-09 김민성 - 일보기/주보기일 때 종일일정 클릭시 시간 종일로 변경
		        // 일보기, 주보기의 시간대 클릭
		        if (GetAttribute(srcEl, "dispDate") == null || GetAttribute(srcEl, "dispDate") == "") {
		            datetype = "1";
		            sdate = GetAttribute(srcEl, "dispTime");
		            edate = sdate.replace(":00:", ":30:");
		        } 
		        // 월보기 클릭
		        else if(GetAttribute(srcEl, "id").indexOf("ALL") < 0) {
		        	datetype = "1";
		        	// 시간데이터가 없는 경우 임의 시간
		        	sdate = GetAttribute(srcEl, "dispDate") + " 00:00:00";
		            edate = GetAttribute(srcEl, "dispDate") + " 23:59:00";
		        }
		        // 일보기, 주보기의 종일일정 클릭
		        else {
		            datetype = "2";
		            sdate = GetAttribute(srcEl, "dispDate") + " 00:00:00";
		            edate = GetAttribute(srcEl, "dispDate") + " 23:59:00";
		        }

		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 760) / 2;
		        var pLeft = (pwidth - 790) / 2;
		        
		        if (otherid == "") {
		            /* var index = idSelect.selectedIndex;
		            if (index == -1) */
		            var index = 0;

		            var feature = GetOpenPosition(790, 760);
		            //if (CrossYN()) {
		                window.open("/ezSchedule/scheduleWrite.do?defaultid=" + index + "&datetype=" + datetype + "&sdate=" + encodeURIComponent(sdate) + "&edate=" + encodeURIComponent(edate), "",
						"height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            /* } else {
		                if (pUse_Editor == "" || pUse_Editor == "CK") {
		                    window.open("schedule_write.aspx?defaultid=" + index + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		                else {
		                    window.open("schedule_write_IE.aspx?defaultid=" + index + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		            } */

		        } else {
		            var type = GetAttribute(secretarySelect.options[secretarySelect.selectedIndex], "type") == "user" ? "6" : "8";
		            var feature = GetOpenPosition(790, 760);
		            
		            //if (CrossYN()) {
		                window.open("/ezSchedule/scheduleWrite.do?otherid=" + encodeURIComponent(otherid) + "&type=" + type + "&othername=" + encodeURIComponent(secretarySelect.options[secretarySelect.selectedIndex].innerHTML) + "&datetype=" + datetype + "&sdate=" + encodeURIComponent(sdate) + "&edate=" + encodeURIComponent(edate), "",
						"height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            /* } else {
		                if (pUse_Editor == "" || pUse_Editor == "CK") {
		                    window.open("schedule_write.aspx?otherid=" + escape(otherid) + "&type=" + type + "&othername=" + escape(getNodeText(secretarySelect.options[secretarySelect.selectedIndex])) + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		                else {
		                    window.open("schedule_write_IE.aspx?otherid=" + escape(otherid) + "&type=" + type + "&othername=" + escape(getNodeText(secretarySelect.options[secretarySelect.selectedIndex])) + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		            } */
		        }
		    }
		    function WriteDateSchedule_left(obj) {
		        var sdate, edate, datetype;
                datetype = "2";
                sdate = GetAttribute(obj, "dispDate") + " 00:00:00";
                edate = GetAttribute(obj, "dispDate") + " 23:59:00";

		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 760) / 2;
		        var pLeft = (pwidth - 790) / 2;
		        
		        if (otherid == "") {
		            var index = idSelect.selectedIndex - 1;
		            if (index == -1)
		                index = 0;

		            var feature = GetOpenPosition(790, 760);
		            //if (CrossYN()) {
		                window.open("/ezSchedule/scheduleWrite.do?defaultid=" + index + "&datetype=" + datetype + "&sdate=" + encodeURIComponent(sdate) + "&edate=" + encodeURIComponent(edate), "",
						"height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            /* } else {
		                if (pUse_Editor == "" || pUse_Editor == "CK") {
		                    window.open("schedule_write.aspx?defaultid=" + index + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		                else {
		                    window.open("schedule_write_IE.aspx?defaultid=" + index + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		            } */
		        } else {
		            var feature = GetOpenPosition(790, 760);
		            
		            //if (CrossYN()) {
		                window.open("/ezSchedule/scheduleWrite.do?otherid=" + encodeURIComponent(otherid) + "&othername=" + encodeURIComponent(secretarySelect.options[secretarySelect.selectedIndex].innerHTML) + "&datetype=" + datetype + "&sdate=" + encodeURIComponent(sdate) + "&edate=" + encodeURIComponent(edate), "",
						"height = 830px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		            /* } else {
		                if (pUse_Editor == "" || pUse_Editor == "CK") {
		                    window.open("schedule_write.aspx?otherid=" + escape(otherid) + "&othername=" + escape(getNodeText(secretarySelect.options[secretarySelect.selectedIndex])) + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		                else {
		                    window.open("schedule_write_IE.aspx?otherid=" + escape(otherid) + "&othername=" + escape(getNodeText(secretarySelect.options[secretarySelect.selectedIndex])) + "&datetype=" + datetype + "&sdate=" + escape(sdate) + "&edate=" + escape(edate), "",
						"height = 760px, width = 790px,top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		                }
		            } */
		        }
		    }
				
		    function ViewChange(szCmd) {
		    	var chk_str = parent.frames["left"].document.getElementById('chk_str').value;
		        switch (szCmd.toUpperCase()) {
		            case "DAY":
		                typeCal = 2;
		                // 2018-06-08 구해안 미니달력 미사용으로 주석처리
		                parent.frames["left"].typeCal = 2;

		                if (g_selTDID != null && g_selTDID != "") {
		                    sDate = new Date(g_selTDID.substring(7, 11), parseInt(g_selTDID.substring(12, 14)) - 1, parseInt(g_selTDID.substring(15, 17)));
		                }
		              	// 2018-06-08 구해안 미니달력 미사용으로 주석처리
		                /* parent.frames["left"].sDate = sDate;
		                var ItemID = "TDMINI_" + sDate.getFullYear() + "-" + leadingZeros(sDate.getMonth() + 1, 2) + "-" + leadingZeros(sDate.getDate(), 2) + "_Day";

		                var item = parent.frames["left"].document.getElementById(ItemID);
		                if (item)
		                    item.onclick();
		                else */
		                CalendarView("Calendar",chk_str);
		                
		                break;
		                
		            case "WEEK":
		                typeCal = 1;
		                // 2018-06-08 구해안 미니달력 미사용으로 주석처리
		                parent.frames["left"].typeCal = 1;

		                if (g_selTDID != null && g_selTDID != "") {
		                    sDate = new Date(g_selTDID.substring(7, 11), parseInt(g_selTDID.substring(12, 14)) - 1, parseInt(g_selTDID.substring(15, 17)));
		                }
		                //2018-06-08 구해안 미니달력 미사용으로 주석처리
		                /* parent.frames["left"].sDate = sDate;
		                var ItemID = "TDMINI_" + sDate.getFullYear() + "-" + leadingZeros(sDate.getMonth() + 1, 2) + "-" + leadingZeros(sDate.getDate(), 2) + "_Day";

		                var item = parent.frames["left"].document.getElementById(ItemID);
		                if (item)
		                    item.onclick();
		                else */
		                    CalendarView("Calendar",chk_str);
		                
		                break;

		            case "MONTH":
		                typeCal = 0;
		                // 2018-06-08 구해안 미니달력 미사용으로 주석처리
		                parent.frames["left"].typeCal = 0;
		                /* var ItemID = "TDMINI_" + sDate.getFullYear() + "-" + leadingZeros(sDate.getMonth() + 1, 2) + "-" + leadingZeros(sDate.getDate(), 2) + "_Day";

		                var item = parent.frames["left"].document.getElementById(ItemID);
		                if (item)
		                    item.onclick(); */

		                CalendarView("Calendar",chk_str);		                
		                break;
		        }
		        /* 2018-02-01 김보미 - 일정관리 타이틀 고정. */
		        //DateChange(szCmd);

		    }

		    function DateChange(szCmd) {
		        switch (szCmd) {
		            case "DAY":
		                szCmd = "<spring:message code='ezSchedule.t140' />";
		                break;
		            case "WEEK":
		                szCmd = "<spring:message code='ezSchedule.t141' />";
		                break;
		            case "MONTH":
		                szCmd = "<spring:message code='ezSchedule.t142' />";
		                break;
		        }

		        titleimg.innerHTML = szCmd;

		    }
			
		    function RefreshView() {
		    	var chk_str = parent.frames["left"].document.getElementById('chk_str').value;
		    	CalendarView('Calendar',chk_str);
		        /* if (parent.frames["left"].document.getElementById("iYear")) {
		            parent.frames["left"].CalendarMiniView("CalendarMini");
		            parent.frames["left"].CalendarMiniDataSource();
		        } */
		    }
		    // 2018-06-08 구해안 라디오 미사용으로 IDChange() 주석처리
		    /* function IDChange() {
		        if (idSelect.value == "GOOGLE") {
		            parent.frames["left"].idtype = idSelect.value;
		            parent.frames["left"].idlist = "";
		            parent.frames["left"].CalendarMiniView("CalendarMini")
		            window.location.href = "/ezSchedule/scheduleMain.do?idtype=" + idSelect.value;
		        } else {
		            if (idSelect.value != "T" && idSelect.value != "P" && idSelect.value != "D" && idSelect.value != "C") {
		                parent.frames["left"].idtype = idSelect.value;
		                parent.frames["left"].idlist = "G";
		                parent.frames["left"].groupid = idSelect.value;
		                parent.frames["left"].CalendarMiniView("CalendarMini");
		                parent.frames["left"].schedule_get_holiday();
		                window.location.href = "/ezSchedule/scheduleMain.do?idtype=G&groupid=" + idSelect.value;
		            }		         
		            else {        	
		                parent.frames["left"].idtype = idSelect.value;
		                parent.frames["left"].idlist = "";
		                parent.frames["left"].CalendarMiniView("CalendarMini");
		                parent.frames["left"].schedule_get_holiday();
		                window.location.href = "/ezSchedule/scheduleMain.do?idtype=" + idSelect.value;
		            }
		        }
		    } */
		    // 2018-06-08 구해안 라디오 미사용으로 IDClick() 주석처리
		    /* function IDClick(type) {
		        parent.frames["left"].idtype = type;
		        document.getElementById("idSelect").value = type;
		        parent.frames["left"].idlist = "";
		        parent.frames["left"].CalendarMiniView("CalendarMini");
		        parent.frames["left"].schedule_get_holiday();
		        window.location.href = "/ezSchedule/scheduleMain.do?idtype=" + type;
		    } */
		    //2018-06-08 구해안 셀릭트 미사용으로 SecretaryChange() 주석처리
		    /* function SecretaryChange() {
		        if (secretarySelect.value == "")
		            window.location.href = "/ezSchedule/scheduleMain.do";
		        else {
		            var type = GetAttribute(secretarySelect.options[secretarySelect.selectedIndex], "type") == "user" ? "6" : "8";
		            window.location.href = "/ezSchedule/scheduleMain.do?idtype=" + type + "&otherid=" + encodeURIComponent(secretarySelect.value);
		        }
		        parent.frames["left"].idtype = type;
		        parent.frames["left"].idlist = encodeURIComponent(secretarySelect.value);
		        parent.frames["left"].CalendarMiniView("CalendarMini");
		        parent.frames["left"].CalendarMiniDataSource();
		    } */
			
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
                    window.open("/ezSchedule/schedulePrint.do?idlist=" + encodeURIComponent(idlist) + "&date=" + date + "&view=" + view + "&APP=" + idtype + "&groupid=" + groupid, "", "height = 660px, width = 837px, status = no, toolbar=no, menubar=no, location=no, resizable=0" + feature);
                else
                    window.open("/ezSchedule/schedulePrint.do?idlist=" + encodeURIComponent(idlist) + "&date=" + date + "&view=" + view + "&APP=" + idtype, "", "height = 660px, width = 837px, status = no, toolbar=no, menubar=no, location=no, resizable=0" + feature);
            }
			
            var schedule_repetition_del_dialogArugment = new Array();
            function DeleteSchedule() {
                if (sScheduleID == null) {
                    alert("<spring:message code='ezSchedule.t207' />");
                    return;
                }

                if (sOwnerID != userid && sOwnerID != otherid && sCreatorID != userid && sCreatorID != otherid &&
					sModifierID != userid && sModifierID != userid && (sScheduleType != "2" || deptadmin != "Y" || sOwnerID != deptid) &&
					(sScheduleType != "3" || companyadmin != "Y") || sIsReadOnly == "Y") {
                    alert("<spring:message code='ezSchedule.t208' />");
                    return;
                }

                if (!confirm("<spring:message code='ezSchedule.t209' />"))
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
                        alert("<spring:message code='ezSchedule.t212' />");
                    else {
                        alert("<spring:message code='ezSchedule.t213' />");
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
		                alert("<spring:message code='ezSchedule.t212' />");

                        }
                        else {
                            alert("<spring:message code='ezSchedule.t213' />");
                            delFlag = true;
                            RefreshView();
                        }
		        }
		        sScheduleID = null;
		    }

		    function show_personinfo(userid) {
		        var feature = GetOpenPosition(420, 450);
		        window.open("/ezCommon/showPersonInfo.do?id=" + userid, "",
				    "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }

		    function open_schedule(scheduleid) {
		        var feature = GetOpenPosition(790, 670);
		        window.open("/ezSchedule/scheduleRead.do?id=" + encodeURIComponent(scheduleid), "",
					"height = 670px, width = 790px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }

		    function ShowSchedule() {
		        showDiv.style.display = 'none';
		    }
			
		    function EditSchedule(scheduleid, e) {
		        var eAppt;
		        var event = document.getElementById(e);

		        eAppt = event;


		        var scheduleid = GetAttribute(eAppt, "ScheduleID");
		        var schedulechangekey = GetAttribute(eAppt, "ScheduleChangeKey");
		        var scheduletype = GetAttribute(eAppt, "ScheduleType");

		        var repeatcount = GetAttribute(eAppt, "RepeatCount");
		        var date = GetAttribute(eAppt, "StartDate").substr(0, 10);

		        showId.value = scheduleid;
		        showChangeKey.value = schedulechangekey;
		        showLocation.innerHTML = GetAttribute(eAppt, "Location");
		        showTitle.value = GetAttribute(eAppt, "Subject");
		        showType.value = scheduletype;

		        if (eAppt.DateType == 2)
		            showTime.innerHTML = strLang39;
		        else
		            showTime.innerHTML = GetAttribute(eAppt, "dtstartDisplay") + " - " + GetAttribute(eAppt, "dtendDisplay");

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
		            if (!confirm("<spring:message code='ezSchedule.t209' />"))
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
		                alert("<spring:message code='ezSchedule.t212' />");
		            else {
		                alert("<spring:message code='ezSchedule.t213' />");
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
			    : (CrossYN()) ?
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
			    }).call(this, v_dateTime, hourNum, minuteNum);
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
		    /* $(document).on('click','.ui-datepicker-trigger', function() { $('.ui-datepicker-month').css('display','none') }); */
		    
		    $('.ui-datepicker-trigger').click(function(){
		    	$('.ui-datepicker-month').css('display','none');
		    });
			
			function doLayerPopup(obj) {
				//Clear data
				document.getElementById("Sdatepicker").value = "";
				document.getElementById("Edatepicker").value = "";
				
				$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);
				var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
				$("#importPopup").css("left", popupX);
				$("#importPopup").modal();
			}
			
			function crossImport() {
				var sDate = document.getElementById("Sdatepicker").value;
				var eDate = document.getElementById("Edatepicker").value;
				
				if ((!sDate && !eDate)) {alert(strLangKHJ1); return;}
				if ((!sDate && eDate))  {alert(strLangKHJ2); return;}
				if ((sDate && !eDate))  {alert(strLangKHJ3); return;}
				if (sDate && eDate)     {if (sDate > eDate) {alert(strLangKHJ4); return;}}
				
				document.getElementById("file1").click();
			}
			
			function btn_AttachAdd_onclick() {
				var tempname = document.form.file1.value;
				if (tempname == "") {
					return;
				}
				
				var last = tempname.split(".").length;
				var extension = tempname.split(".")[last - 1];
				
				if (extension.toUpperCase() != "ICS") {
					alert("<spring:message code='ezAddress.t179' />");
					return;
				}
				
				//setNodeText(document.getElementById("loadtxt"), "<spring:message code='ezAddress.t5000' />");
				document.getElementById("loadingLayer").style.display = "";
				document.getElementById("loadingLayer").style.top = (document.documentElement.clientHeight / 2) - 90 + "px";
				document.getElementById("loadingLayer").style.left = (document.documentElement.clientWidth / 2) - 160 + "px";
				
				var format = "";
				var formatRadio = document.getElementsByName('importFormat');
				
				for (var i = 0; i < formatRadio.length; i++) {
					if (formatRadio[i].checked) {
						format = formatRadio[i].value;
						break;
					}
				}
				
				//startDate, endDate
				var startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
				var endDate   = $('#Edatepicker').datepicker({ dateFormat: 'yy-mm-dd' }).val();
				
				var frm = document.getElementById('form');
				frm.action = "/ezSchedule/icsImport.do?format=" + encodeURIComponent(format) + "&startDate=" + encodeURIComponent(startDate) + "&endDate=" + encodeURIComponent(endDate);
				frm.submit();
				SearchOptionHidden();
			}
			function SearchOptionHidden() {
				$.modal.close();
			}
			
			function selectLastYear() {
				$("#Sdatepicker").datepicker('setDate', "-1Y");
				$('#Edatepicker').datepicker('setDate', new Date());
			}
			
			function selectLastSixMonths() {
				$("#Sdatepicker").datepicker('setDate', "-6M");
				$('#Edatepicker').datepicker('setDate', new Date());
			}
			
			function selectLastMonths() {
				$("#Sdatepicker").datepicker('setDate', "-1M");
				$('#Edatepicker').datepicker('setDate', new Date());
			}
			
			function selectThisYear(){
				var now = new Date();
				$("#Sdatepicker").datepicker('setDate', new Date(now.getFullYear(), 0, 1));
				$('#Edatepicker').datepicker('setDate', new Date(now.getFullYear(), 12, 0));
			}
			
			function UploadComplete(result) {
				document.form.file1.value = "";
				document.getElementById("loadingLayer").style.display = "none";
				
				if (result == "OK") {
					alert(strLangKHJ5);
				} else if (result == "ERROR") {
					alert(strLangKHJ6);
				} else {
					alert(strLangKHJ7);
				}
				RefreshView();
			}
	    </script>
	</head>
	<body class="mainbody" style="overflow: auto; margin-bottom:0px">
        <h1 id="titleimg">${defaultTitle}</h1>
        <div id="mainmenu">
            <ul>
            	<li><span id="pn_img" onClick="WriteSchedule()"><spring:message code='ezSchedule.t214'/></span></li>
            	<li><span onClick="PrintSchedule()"><spring:message code='ezSchedule.t217'/></span></li>
              	<li><span onClick="RefreshView()"><spring:message code='ezSchedule.t218'/></span></li>              	
		      	<!-- <li style="background:none; padding-right:2px; cursor:default;"><img src="/images/i_bar.gif" alt=""/></li> -->
		      	<li><span onclick='ViewChange("DAY");'><spring:message code='ezSchedule.t140'/></span></li>
              	<li><span onclick='ViewChange("WEEK");'><spring:message code='ezSchedule.t141'/></span></li>
              	<li><span onclick='ViewChange("MONTH");'><spring:message code='ezSchedule.t142'/></span></li>              	
              	<!-- 2018-06-08 구해안 상단 셀렉트박스 및 라디오버튼 미사용으로 삭제 및 bar 이미지 삭제 -->
              	<%-- <li style="background:none; padding-right:2px; cursor:default;"><img src="/images/i_bar.gif" alt=""/></li>
              	<li style="background:none; padding:0; cursor:default;">
              		<select class="select" id="idSelect" onChange="IDChange()" style="width:140px">
						<option value="T"><spring:message code='ezSchedule.t220'/></option>
						<option value="P" selected><spring:message code='ezSchedule.t221'/></option>
						<option value="D"><spring:message code='ezSchedule.t222'/></option>
						<option value="C"><spring:message code='ezSchedule.t223'/></option>									            
					</select>
				</li>
              	<li style="background:none; padding:0; cursor:default;">
              		<select class="select" onChange="SecretaryChange()" id="secretarySelect" name="secretarySelect" style="width:140px">
						<option value="" selected><spring:message code='ezSchedule.t224'/></option>
						${shareList}
					</select>
				</li>
				<li onClick="IDClick('T')" style="background:none;cursor:pointer;margin-left:7px"><span style="display:inline-block; width:11px; height:11px; border:1px solid #ccc; background:#fff; overflow:hidden; margin:7px 0px 0px 0px; padding:0; vertical-align:middle;border-radius:2px;"></span>&nbsp;<spring:message code='ezSchedule.t220'/></li>
	            <li onClick="IDClick('P')" style="background:none;cursor:pointer;margin-left:7px"><span style="display:inline-block; width:11px; height:11px; border:1px solid #017ddf; background:#018bfa; overflow:hidden; margin:7px 0px 0px 0px; padding:0; vertical-align:middle;border-radius:2px;"></span>&nbsp;<spring:message code='ezSchedule.t221'/></li>
	            <li onClick="IDClick('D')" style="background:none;cursor:pointer"><span style="display:inline-block; width:11px; height:11px; border:1px solid #049c37; background:#01b43f; overflow:hidden; margin:7px 0px 0px 0px; padding:0; vertical-align:middle;border-radius:2px;"></span>&nbsp;<spring:message code='ezSchedule.t222'/></li>
	            <li onClick="IDClick('C')" style="background:none;cursor:pointer"><span style="display:inline-block; width:11px; height:11px; border:1px solid #e01662; background:#ff1c71; overflow:hidden; margin:7px 0px 0px 0px; padding:0; vertical-align:middle;border-radius:2px;"></span>&nbsp;<spring:message code='ezSchedule.t223'/></li>
                <li style="background:none;cursor:text"><span style="display:inline-block; width:11px; height:11px; border:1px solid #ccc31f; background:#e9de13; overflow:hidden; margin:7px 0px 0px 0px; padding:0; vertical-align:middle;border-radius:2px;"></span>&nbsp;<spring:message code='main.t00022'/></li>
                 --%>
                 <!-- 2018-10-17 김혜정  ics 파일 가져오기 기능 구현을 위해 임시로 가져오기 버튼 추가 -->
                <c:if test="${useScheduleIcs == 'YES'}">
                	<li><span onclick="doLayerPopup(this)">가져오기</span></li>
                </c:if>
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
			</tr>
		</table>                
		<br/>
		<div id="showDiv" style="display:none;position:absolute;background-color:white;">
			<table style="width:200px;height:60px;margin:1px;border:1px solid #ddd" class="popuplist" >
				<tr>    
		            <th style="height:20px; width:30%" align=center><img src="/images/bt_edit.gif" onclick="showUpdate('EDIT')" style="cursor: pointer;" />&nbsp;
		            	<img src="/images/bt_del.gif" onclick="showUpdate('DEL')" style="cursor: pointer;"/>
		            </th>
		            <td style="width:70%"><input type="text" id="showTitle" /><input type="hidden" id="showId" />
		            	<input type="hidden" id="showChangeKey" /><input type="hidden" id="showType" />
		            </td>
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
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div id="importPopup" class="popupwrap1" style="display:none;margin-bottom:70px;vertical-align:middle">
			<div class="popupJQLayer">
				<div class="title">iCalendar <spring:message code='ezEmail.t407' /></div>
				<div id="close">
					<ul>
						<li><a rel="modal:close"><span onclick="SearchOptionHidden()"></span></a></li>
					</ul>
				</div>
				<h2 style="font-weight: normal;margin-top:5px">▒&nbsp;<spring:message code='ezSchedule.khj01' /></h2>
				<table class="content" style="width:100%;margin-top:5px;">
					<tr>
						<th style="text-align:center"><spring:message code='ezSchedule.khj02' /></th>
						<td>
							<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
							~
							<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"> 
						</td>
					</tr>
					<tr>
						<th style="text-align:center"><spring:message code='ezSchedule.khj03' /></th>
						<td>
							<a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="selectLastYear()"><spring:message code='ezSchedule.khj04' /></span></a>
							<a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="selectLastSixMonths()"><spring:message code='ezSchedule.khj05' /></span></a>
							<a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="selectLastMonths()"><spring:message code='ezSchedule.khj06' /></span></a>
							<a class="imgbtn imgbck" style="vertical-align:middle"><span onclick="selectThisYear()"><spring:message code='ezSchedule.khj07' /></span></a>
						</td>
					</tr>
				</table>
				<br />
				<table style="width:100%">
					<tr>
						<td style="text-align:center;">
							<div class="btnpositionLayer">
								<a class="imgbtn"><span onClick="crossImport()"><spring:message code='main.t4004' /></span></a>
							</div>	
						</td>
					</tr>
				</table>
			</div>
		</div>
		<span class="loading_layer" style="z-index:6000;position:absolute;top:300px;left:200px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><span id="loadtxt"><spring:message code='ezOrgan.t1000' /></span></span></span>
		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm">
			<input type="file" name="file1" id="file1" accept=".ics" onchange="btn_AttachAdd_onclick()" style="display: none"/>
		</form>
	</body>
</HTML>