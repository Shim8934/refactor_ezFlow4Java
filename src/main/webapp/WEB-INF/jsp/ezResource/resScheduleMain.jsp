<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t241" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link type="text/css" rel="stylesheet" href="${util.addVer('/css/Tab.css')}" />
		<link type="text/css" rel="stylesheet" href="${util.addVer('/css/olstyle_nonIE.css')}" />
		<link type="text/css" rel="stylesheet" href="${util.addVer('/css/Calendar_cross.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/CalendarDataPro_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/CalendarView_Cross.js')}"></script>		
		<%-- <script type="text/javascript" src="${util.addVer('/js/ezResource/CalendarMini_Cross.js')}"></script> --%>
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/calendar_cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Holiday.js')}"></script>
		<!-- data picker-->
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}"/>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/monthpicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}"/>
		<!-- modal -->
		<link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
		<style>
			#resourceDataTable tr td {
				border : 1px solid #ccc;				
			}
						
			#resourceDataTable tr td{
				padding-left : 7px;
			}
			
			#resourceDataTable tr th{
				font-weight: normal;
			}
			/* 2018-06-13 구해안 추가 */
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
			.mainmenuTab {
				margin : 0px 15px 11px 15px;
			}
			
			.calendar_week .td_list {
				overflow: visible !important
			}
		</style>
		<script type="text/javascript">
		var timeZoneStr = "${timeZoneStr}";
	    var pAdminFg = "${adminFg}";
	    var pBrd_Access = "${brdAccess}";
	    
	    /* 2018-10-01 김민성 - 접근 권한 없는 경우 메시지 출력 수정 */
	    if(pAdminFg == "") {
	    	var msg = "<spring:message code='ezResource.t58' />";
	        window.location.href = "/ezResource/nonResList.do?msg=" + encodeURIComponent(msg);
	    }
	    var pUserID    = "${userInfo.id}";
	    var pCompanyID = "${userInfo.companyID}";
	    var getLang = "<c:out value='${userInfo.lang}'/>";
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
	    var pStartday = "${startDay}";
	    var lunarUseFlag = "${lunarUseFlag}";
	    var LunarUse = false;
	    var dayView = 0;
	    var returnFlag = "${returnFlag}";
	    
	    document.onselectstart = function () { return false; };
	    
	    /* select_memorialDays("${userInfo.lang}"); */
	    
	    var xmlhttp2 = createXMLHttpRequest();
	    function schedule_get_holiday() {
	        xmlhttp2 = createXMLHttpRequest();
	        xmlhttp2.open("GET", "/ezSchedule/scheduleGetHoliday.do?COMPANYID=VIEW", true);
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
	            xmlhttp2 = null;
	            CalendarView("Calendar");	            
	           
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
	    }
		
	    function schedule_get_lunaruse() {
	        xmlhttp = createXMLHttpRequest();
	        var xmlDom = createXmlDom();
	        var objNode;

	        var xmlpara = createXmlDom();
	        var objNode;
	        createNodeInsert(xmlpara, objNode, "DATA");
	        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", "${userInfo.companyID}");

	        xmlhttp.open("GET", "/ezSchedule/scheduleGetLunarUse.do", true);
	        xmlhttp.onreadystatechange = event_schedule_get_lunaruse;
	        xmlhttp.send(xmlpara);
	    }

	    /* 2019-01-02 김민성 - ajax 데이터 중복 로드되는 현상 수정 */
	    function event_schedule_get_lunaruse() {
	    	if (xmlhttp == null || xmlhttp.readyState != 4)
	            return;
	    	if (xmlhttp.status >= 200 && xmlhttp.status < 300) {
		       if (getLang == 1) {
			       if (xmlhttp.responseText == "0" || xmlhttp.responseText == "1") {
			            LunarUse = true;
			       }
			       else {
			        	LunarUse = false;
			       }
			       schedule_get_holiday();
		       } else {
		    	   schedule_get_holiday();
		       }
	    	}
	    }
	    
	    var agent = navigator.userAgent.toLowerCase(); 
	    window.onload = function () {
	    	//2018-06-05 팝업창으로 정보 이동하여 ResourceInfo height 수정하는 부분 삭제
	    	
	 		var divH = document.getElementById("divExplain")
			if(divH){
				divH.style.height = document.documentElement.clientHeight - 618 + "px";
				divH.style.minHeight = "0px";			
			} 
	        var resDiv = document.getElementById("ResDiv");
	        if(resDiv){//ie에서의 패딩 조절
	        	if (!CrossYN() || agent.search( "trident" ) > -1 ) {
				resDiv.style.padding = "1.8px 5px 0px 5px";
				}	
	        }
	        var resDivTable = document.getElementById("ResDivTable");
	        if(resDivTable){//ie에서의 스크롤 우측 마진 조절
				if (!CrossYN() || agent.search( "trident" ) > -1 ) {
					resDivTable.style.marginRight = "0.1px";
				}
	        }
	        
	        if (typeCal == "2") {
	            var w = document.documentElement.clientHeight - 278;
	        } else if (typeCal == "1") {
	            var w = document.documentElement.clientHeight - 308;
	        }

	        var objDiv = document.getElementById('CalDiv');
	        if (objDiv) {
	            objDiv.style.height = w + "px";
	        }
	    	
	    	if (pStartday == 1) {
	            DefaultView = 1;
	    	} else {
	            DefaultView = 0;
	    	}
	    	
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
	    
	    function Window_resize() {
	        if (typeCal == "2") {
	            var w = document.documentElement.clientHeight - 278;
	        } else if (typeCal == "1") {
	            var w = document.documentElement.clientHeight - 308;
	        }

	        var objDiv = document.getElementById('CalDiv');
	        if (objDiv) {
	            objDiv.style.height = w + "px";
	        }

// 	        var objRInfo = document.getElementById('ResourceInfo');
// 	        if (objRInfo) {
// 	            objRInfo.style.height = document.documentElement.clientHeight - 376 + "px";
// 	        }
	    }

	    function btnDel_onclick() {
	        DeleteAppointment();
	        return;
	    }

	    function btnRefresh_onclick() {

	        RefreshMessageList();
	        /*CalendarMiniView("CalendarMini");*/
	    }

	    function j_MoveToSelectedDate(j_kind, j_movNum, j_dateStr) {
	        var returnStr = v_MoveToSelectedDate(j_kind, j_movNum, j_dateStr);
	        return returnStr;
	    }

	    function allday_OnDateChange() {
	    }

	    function MemberInfo_onClick(pSelUserID) {
	        if (pSelUserID != "") {
	            var feature = GetOpenPosition(420, 450);
	            window.open("/ezCommon/showPersonInfo.do?id=" + pSelUserID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        }
	    }

	    function newSchedule_onclick(e) {
	    	if(ApproveFlag == 2) {
	    		alert(strLang336);
	    		return;
	    	}
	    	
	        var srcEl;

	        if (CrossYN()) {
	            srcEl = e.currentTarget;
	        } else {
	            srcEl = window.event.srcElement;
	        }
	        var selsd = "", seled = "";
	        
			/* 2018.03.23 서주연 - #12114 */
	        if (GetAttribute(srcEl,"dispDate") == null || GetAttribute(srcEl, "dispDate") == "") {
	            if (GetAttribute(srcEl,"dispTime") != null) {

	                selsd = GetAttribute(srcEl,"dispTime");
	                
	            	// 2020-01-28 김민성 - 일보기/주보기에서 단위 시간 체크 추가
	                if (selsd != null && selsd != "") { 
			            var seledSplit = selsd.split(" ")[1].split(":");
			            seled = selsd.replace(selsd.split(" ")[1], seledSplit[0] + ":" + leadingZeros(seledSplit[1]*1+30, 2) + ":" + seledSplit[2]);
	                }
	            }
	        } else {
	            selsd = GetAttribute(srcEl, "dispDate");
            	seled = GetAttribute(srcEl, "dispDate");
	        }
			//2018-09-13 천성준 - #13590
	        if (selsd == "" && seled == "") {
	        	var date = new Date();
	        	var year = date.getFullYear();	//2018
	        	var month = leadingZeros(date.getMonth()+1,2);	//0~11
	        	var day = leadingZeros(date.getDate(),2); 		//1~31
	        	
	        	selsd = year + "-" + month + "-" + day;
	        	seled = year + "-" + month + "-" + day;
	        }
	       
	        var feature = GetOpenPosition(820, 700);
	        if (CrossYN() || pNoneActiveX == "YES") {
	        	window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + selsd + "&seled=" + seled + "&dayView="+ dayView +"&ownerID=${resID}", "", "width=820, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        } else {
                window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + selsd + "&seled=" + seled + "&dayView="+ dayView +"&ownerID=${resID}", "", "width=770, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        }
	    }

	    function btnApprov_list() {
	        window.location.href = "/ezResource/scheduleApprovList.do?resID=" + pBrdid + "&type=Admin&startDate=" + sStartDate + "&endDate=" + sEndDate;
	    }
	    
	    function btnMyApprov_list() {
	        window.location.href = "/ezResource/scheduleApprovList.do?resID=" + pBrdid + "&type=User&startDate=" + sStartDate + "&endDate=" + sEndDate;
	    }

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
                window.open("/ezResource/scheduleManageForm.do?resID=${resID}&brdName=" + encodeURIComponent("${brdNm}"), "", "width=700px, height=700px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
            } else {
                window.open("/ezResource/scheduleManageForm.do?resID=${resID}&brdName=" + encodeURIComponent("${brdNm}"), "", "width=700, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
            }
        }
		//2018-06-05 구해안 showres 함수 추가
		function showRes(val01) {
    		$.ajax({
				type : "GET",
				dataType : "json",
				async : false,
				url : "/ezResource/scheduleResourceData.do",
				data : { 
					resourceId   : val01						
				},
				success: function(result){
					// 2018-10-29 김민성 - 자원 정보 레이어 팝업 관리자 리스트, 관리자 정보 조회, 등록일 정보 추가
					var ownerID = result.resBrd.ownerID;
					var subOwner = result.ownerList;
					var strOwnerList = "";
					var subOwner1 = "";
					
					for(var i=0; i<subOwner.length; i++) {
						strOwnerList += "<span onclick=\"OpenUserInfo('" + subOwner[i].cn + "','" + subOwner[i].department + "')\">"+subOwner[i].displayName+"</span>";
						if(i != subOwner.length-1) {
							strOwnerList += ", ";
						}
					}
					//$("#ownerDept").html(subOwner1);
					$("#ownerInfo").html(strOwnerList);
					
					if (result.primary == "1") {						
						//$("#ownerInfo").html(result.resBrd.ownerNm);
						//$("#ownerInfo").attr("onclick", "OpenUserInfo('"+subOwner[0].cn +"','" + subOwner[0].department+ "')");
						$("#ownerNm").attr("ownerID", ownerID);
						//$("#ownerDept").html(result.resBrd.ownDeptNm);
						$("#brdNm").html(result.resBrd.brdNm);
					} else {
						//$("#ownerInfo").html(result.resBrd.ownerNm2);
						//$("#ownerInfo").attr("onclick", "OpenUserInfo('"+subOwner[0].cn +"','" + subOwner[0].department+ "')");
						$("#ownerNm").attr("ownerID", ownerID);
						//$("#ownerDept").html(result.resBrd.ownDeptNm2);
						$("#brdNm").html(result.resBrd.brdNm2);
					}
					
					
					$("#ownerCall").html(MakeXMLString(result.resBrd.ownerCall));
					$("#resLocation").html(MakeXMLString(result.resBrd.resLocation));
					
					var approveFlag = result.resBrd.approveFlag;
					
					if (approveFlag == "1") {
						$("#approveFlag").html("<spring:message code='ezResource.t272'/>");
					} else if (approveFlag == "0") {
						$("#approveFlag").html("<spring:message code='ezResource.t273'/>");
					} else {
						$("#approveFlag").html("<spring:message code='ezSchedule.t404'/>");
					}
					
					var returnFlag = result.resBrd.returnFlag;
					
					if (returnFlag == "0") {
						$("#returnFlag").html("<spring:message code='ezResource.kmsr12'/>");
					} else {
						$("#returnFlag").html("<spring:message code='ezResource.kmsr13'/>");
					}

					// 반복예약허용 Flag
					var repeatFlag = result.resBrd.repeatFlag;

					if (repeatFlag == "1") {
						$("#repeatFlag").html("<spring:message code="ezResource.lyj02"/>");
					} else {
						$("#repeatFlag").html("<spring:message code="ezResource.lyj03"/>");
					}
					
					$("#resDate").html(result.resBrd.makeDate);
					
					var resbrdExc = "";
					if (result.resBrd.brdExplain != null) {
						resbrdExc = MakeXMLString(result.resBrd.brdExplain);
					}
					
					$("#brdExplain").html(resbrdExc);
					
					if(result.attachList1 != null) {
						document.getElementById("preview1").src = "/ezResource/getResourceThumbnailInfo.do?brdID=" + ResID + "&fileName=" + encodeURIComponent(result.attachList1);
						document.getElementById("preview1").width = 200;
						document.getElementById("preview1").height = 200;
					}
					
					if(result.attachList2 != null) {
						document.getElementById("preview2").src = "/ezResource/getResourceThumbnailInfo.do?brdID=" + ResID + "&fileName=" + encodeURIComponent(result.attachList2);
						document.getElementById("preview2").width = 200;
						document.getElementById("preview2").height = 200;
					}
					
					/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
		        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
		        	
		        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 270;
		        	
		        	$("#ResourceInfo").css("left", popupX);
		        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
					
					$("#ResourceInfo").modal();
				}, 
				error: function() {
					
				}
			});	    		
        }
		
		function SearchOptionHidden() {
        	$.modal.close();
        }
		
		// 18-10-19 김민성 - 작성자 이름 클릭 시 사원정보보기 팝업
		function OpenUserInfo(userID, deptID) {
        	var feature = "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1";
            feature = feature + GetOpenPosition(420, 450);
            window.open("/ezCommon/showPersonInfo.do?id=" + userID + "&dept=" + deptID, "", feature);
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
		
		function btnOccupancy_list() {
			parent.frames["left"].document.body.style.overflow = "hidden";
    		var url = "/ezResource/resourceOccupancy.do";
    		DivPopUpShow(800, 540, url);
    		$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%'></div>").appendTo(parent.frames["left"].document.body);
		}
		function resClose_onclick() {
			DivPopUpHidden();
			$(parent.frames["left"].document.getElementById("blockLeft")).remove();
		}
		// 2024-08-20 유길상 - 자원관리 즐겨찾기 관리 팝업
		var fvMangeWindow;
		function fvManageWindowOpen() {
			event.stopPropagation();
			if (fvMangeWindow) {
				fvMangeWindow.focus();
			} else {
				fvMangeWindow = window.open("/ezResource/resFavoriteManage.do?brdId=${resID}", "config", GetOpenWindowfeature(600, 425));
				fvMangeWindow.focus();
				var winTimer;
				winTimer = setInterval(function() {
		            if (fvMangeWindow.closed !== false) {
		                clearInterval(winTimer);
		                fvMangeWindow = null;
		                parent.frames['left'].location.reload();
		            }
		        }, 500);
			}
		}
        
        function RefreshView() {
            RefreshMessageList();
        }
    </script>
	
	</head>
	<!-- 2018-06-13 구해안 우측 여백수정 -->
	<!-- 2018-07-13 김민성 - 자원명 길 경우 ellipsis -->
	<body class="mainbody" style="overflow: auto; margin-bottom:0px;padding-right: 6px; ovverflow-x: scroll; min-width: 950px;" id="BodyTop">
		<h1 style="text-overflow:ellipsis;overflow:hidden;white-space:nowrap;" title="${brdNm}"><span id="titleimg"></span> <c:out value='${brdNm}' /></h1>
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none; overflow: hidden;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		<div id="mainmenu">
            <ul class="on">
            	<li class="important"><span id="pn_img" onClick="newSchedule_onclick(event)"><spring:message code='ezResource.t171'/></span></li>
            	<li><span onclick='showRes(${resID});'><spring:message code='ezResource.t142'/></span></li>
            	<c:if test="${adminFg eq 'Y'}" >
    				<li><span onClick="btnform_onclick();"><spring:message code='ezResource.t378'/></span></li>
    				<%-- <c:if test="${approveFlag eq '1'}" > --%>
    					<li id="approvlist"><span onClick="btnApprov_list();"><spring:message code='ezResource.kmsr33'/></span></li>
    				<%-- </c:if> --%>
    			</c:if>
    			<c:if test="${approveFlag ne 2 }">
    				<li id="myApprovlist"><span onClick="btnMyApprov_list();"><spring:message code='ezResource.kmsr34'/></span></li>
    			</c:if>
    			<c:if test="${adminCKFlag eq 'Y'}" >
    				<li id="occupancylist"><span onClick="btnOccupancy_list();"><spring:message code='ezResource.kwc03'/></span></li>
    			</c:if>
    			<li id="fav_manage" onClick="fvManageWindowOpen();"><span><spring:message code='ezResource.resFav.ygs02'/></span></li>
            </ul>
		</div>
		<div class="calendar_pagenav" style='left: max(50%, 550px);'>
	        <ul class="contentlayout">
	            <li class="contentlayout_left" id="preM"></li>
	            <li class="contentlayout_right" id="preN"></li>
	            <li class="contentlayout_none"><span class="spanText" id="calTitle"></span>
	            </li>
	        </ul>
	    </div>
	    <div class="mainmenuTab">
	    	<ul class="mainmenuTabUL_left"> 
	    		<li><img src="../images/ezResource/state_approval.gif" class="icon"><spring:message code='ezResource.t191'/></li>
	    		<c:if test="${approveFlag eq 1 }">
		    		<li><img src="../images/ezResource/state_approvalPending.gif" class="icon"><spring:message code='ezResource.kmsr21'/></li>
		    		<li><img src="../images/ezResource/state_approvalrefuse.gif" class="icon"><spring:message code='ezResource.kmsr22'/></li>
		    	</c:if>
	    		<li><img src="../images/ezResource/state_rental.gif" class="icon"><spring:message code='ezResource.kmsr23'/></li>
	    		<c:if test="${returnFlag eq 0 }">
	    			<li><img src="../images/ezResource/state_return.gif" class="icon"><spring:message code='ezBoard.t345'/></li>
	    		</c:if>
	    		<c:if test="${returnFlag eq 1 }">
		    		<li><img src="../images/ezResource/state_return.gif" class="icon"><spring:message code='ezResource.kmsr24'/></li>
		    		<li><img src="../images/ezResource/state_noreturn.gif" class="icon"><spring:message code='ezResource.kmsr25'/></li>
		    	</c:if>
	    	</ul>
	        <ul class="mainmenuTabUL">
	            <li id="dayView" class="off"><span onclick='onViewDate("DAY");'><spring:message code='ezSchedule.t140'/></span></li><li id="weekView" class="off"><span onclick='onViewDate("WEEK");'><spring:message code='ezSchedule.t141'/></span></li><li id="monView" class="on"><span onclick='onViewDate("MONTH");'><spring:message code='ezSchedule.t142'/></span></li>
	        </ul>
	    </div>
		<%-- <div id="mainmenu">
  			<ul>
    			<li><span id="pn_img" onClick="newSchedule_onclick(event)"><spring:message code='ezResource.t171'/></span></li>
    			<!-- 2018-06-05 구해안 자원정보 버튼 추가 및 resinfo 정보 popup으로 수정 -->
    			<li><span onclick='showRes(${resID});'><spring:message code='ezResource.t142'/></span></li>
    			<c:if test="${adminFg eq 'Y'}" >
    				<li><span onClick="btnform_onclick();"><spring:message code='ezResource.t378'/></span></li>
    				<c:if test="${approveFlag eq '1'}" >
    					<li id="approvlist"><span onClick="btnApprov_list();"><spring:message code='ezResource.t1000'/></span></li>
    				</c:if>
    			</c:if>
    			<!-- <li style="background:none; padding-right:2px; cursor:default;"><img src="/images/i_bar.gif" alt=""/></li> -->
    			<li><span onclick='onViewDate("DAY");'><spring:message code='ezResource.t251'/></span></li>
    			<li><span onclick='onViewDate("WEEK");'><spring:message code='ezResource.t253'/></span></li>
    			<li><span onclick='onViewDate("MONTH");'><spring:message code='ezResource.t255'/></span></li>
    			<!-- 2018-06-05 구해안 허가,비허가 오른쪽으로 ui 수정 -->
				<li style="background:none;float:right;cursor:default"><img src="/images/calendar/icon_resource_no.png" style="vertical-align:middle">&nbsp;<spring:message code='ezResource.t370'/></li>
    			<li style="background:none;float:right;cursor:default">&nbsp;<img src="/images/calendar/icon_resource_ok.png" style="vertical-align:middle">&nbsp;<spring:message code='ezResource.t369'/></li>
  			</ul>  			
		</div> --%>
		<script type="text/javascript">
    		//selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<table>   
			<tr>
				<td style="vertical-align:top;width:100%;">
					<div  style="vertical-align:top;" id="Calendar"></div>
				</td>
				<!-- 2018-06-04 구해안 mini+info td 삭제 -->				
			</tr>
		</table>	
		<!-- 2018-06-04 구해안 resinfo display:none 으로 추가 -->
		<!-- 2018-07-13 김민성 - 자원명 길 경우 ellipsis -->
		<div id="ResourceInfo" style="display: none; max-width: 700px">
			<div class="popupJQLayer" style="padding-top:6px">
				<div class="title" id="brdNm" style="overflow:hidden; text-overflow:ellipsis; width:650px; white-space:nowrap; margin-bottom:2px;" title="${brdNm }"></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span></span></a></li>
		            </ul>
		        </div>
	        	<table id="resourceDataTable" style="width:680px; display: table-cell;/* margin-top:10px; */">
					<tr>
						<th style="width: 100px; height:30px; background-color: #fafafa"><spring:message code='ezResource.t153'/></th>
						<td style="width: 500px;" colspan="2"><span id="ownerNm"><span id="ownerInfo" style="cursor:pointer"></span></span></td>
					</tr>
					<%-- <tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.rkms01'/></th>
						<td><span id="ownerDept" style="cursor:pointer"></span></td>
					</tr> --%>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t155'/></th>
						<td colspan="2"><span id="ownerCall"></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code="ezResource.max.ygs02"/></th>
						<td colspan="2"><span id="resMaxUserCnt">${resMaxUserCnt}<spring:message code="ezResource.max.ygs03"/></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t148'/></th>
						<td colspan="2" style="word-break:break-all;" id="resLocation"><%-- ${resLocation} --%></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code="ezResource.max.ygs01"/></th>
						<td colspan="2"><span id="resMaxDate">${resMaxDate}<c:if test="${not empty resMaxDate}"><spring:message code="ezResource.max.ygs04"/></c:if></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code="ezResource.lyj01"/></th>
						<td colspan="2" id="repeatFlag"></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t149'/></th>
						<td colspan="2" id="approveFlag"></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.kmsr11'/></th>
						<td colspan="2" id="returnFlag"></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezBoard.t5007'/></th>
						<td colspan="2"><span id="resDate"></span></td>
					</tr>
					<tr>
						<th style="height:200px;background-color: #fafafa"><spring:message code="ezPortal.t202"/></th>
						<td style="width:39%; border-right: 0"><img id="preview1" name="preview" src="/images/default_pic.jpg" width="120" height="120" alt="" border="0" style="margin-left: auto; margin-right: auto; display: block; border-right: 0px;"></td>
						<td style="border-left: 0"><img id="preview2" name="preview" src="/images/default_pic.jpg" width="120" height="120" alt="" border="0" style="margin-left: auto; margin-right: auto; display: block;"></td>
					</tr>
					<tr>
						<th style="height:100px;background-color: #fafafa"><spring:message code='ezResource.t271'/></th>
						<td colspan="2"><div style="overflow-y: auto; height: 100px; word-break:break-all; white-space:pre-wrap;" id="brdExplain"></div></td>
					</tr>
	         	</table>
	         </div>	
        </div>
	</body>
</html>