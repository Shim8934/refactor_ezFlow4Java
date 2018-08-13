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
		<!-- data picker-->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css"/>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/monthpicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css"/>
		<!-- modal -->
		<link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
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
		</style>
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
	    var pStartday = "${startDay}";
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
	        
			/* 2018.03.23 서주연 - #12114 */
	        if (GetAttribute(srcEl,"dispDate") == null || GetAttribute(srcEl, "dispDate") == "") {
	            if (GetAttribute(srcEl,"dispTime") != null) {

	                selsd = GetAttribute(srcEl,"dispTime");
	                
	                if (selsd != null) { 
	                	seled = selsd.replace(":00:", ":30:");
	                }
	            }
	        } else {
	            selsd = GetAttribute(srcEl, "dispDate");
            	seled = GetAttribute(srcEl, "dispDate");
	        }
	       
	        var feature = GetOpenPosition(820, 700);
	        if (CrossYN() || pNoneActiveX == "YES") {
	        	window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + selsd + "&seled=" + seled + "&dayView=&ownerID=${resID}", "", "width=820, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        } else {
                window.open("/ezResource/scheduleAdd.do?cmd=add&from=schedule&selsd=" + selsd + "&seled=" + seled + "&dayView=&ownerID=${resID}", "", "width=770, height=700, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
	        }
	    }

	    function btnApprov_list() {
	        window.location.href = "/ezResource/scheduleApprovList.do?resID=" + pBrdid + "&startDate=" + sStartDate + "&endDate=" + sEndDate;
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
				type : "POST",
				dataType : "json",
				async : false,
				url : "/ezResource/scheduleResourceData.do",
				data : { 
					resourceId   : val01						
				},
				success: function(result){
					if (result.primary == "1") {						
						$("#ownerNm").html(result.resBrd.ownerNm + " (" + result.resBrd.ownerPosition + ")");
						$("#ownerDept").html(result.resBrd.ownDeptNm);
						$("#brdNm").html(result.resBrd.brdNm);
					} else {
						$("#ownerNm").html(result.resBrd.ownerNm2 + " (" + result.resBrd.ownerPosition2 + ")");
						$("#ownerDept").html(result.resBrd.ownDeptNm2);
						$("#brdNm").html(result.resBrd.brdNm2);
					}
					
					$("#ownerCall").html(result.resBrd.ownerCall);
					$("#resLocation").html(result.resBrd.resLocation);						
					
					var approveFlag = result.resBrd.approveFlag;
					
					if (approveFlag == "1") {
						$("#approveFlag").html("<spring:message code='ezResource.t272'/>");
					} else {
						$("#approveFlag").html("<spring:message code='ezResource.t273'/>");
					}
					
					var resbrdExc = "";
					if (result.resBrd.brdExplain != null) {
						resbrdExc = result.resBrd.brdExplain.replace(/(?:\r\n|\r|\n)/g, '<br />');
					}
					
					$("#brdExplain").html(resbrdExc);
					
					/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
		        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
		        	
		        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
		        	
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
    </script>
	
	</head>
	<!-- 2018-06-13 구해안 우측 여백수정 -->
	<!-- 2018-07-13 김민성 - 자원명 길 경우 ellipsis -->
	<body class="mainbody" style="overflow: auto; margin-bottom:0px;padding-right: 6px;" id="BodyTop">
		<h1 style="text-overflow:ellipsis;overflow:hidden;white-space:nowrap;" title="${brdNm}"><span id="titleimg"></span> <c:out value='${brdNm}' /></h1>
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div id="mainmenu">
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
		</div>
		<script type="text/javascript">
    		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
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
		<div id="ResourceInfo" style="display: none">
			<div class="popupJQLayer" style="padding-top:6px">
				<div class="title" id="brdNm" style="overflow:hidden; text-overflow:ellipsis; width:450px; white-space:nowrap;" title="${brdNm }"></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span></span></a></li>
		            </ul>
		        </div>
	        	<table id="resourceDataTable" style="width:478px; margin-top:10px;">
					<tr>
						<th width="22%" style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t153'/></th>
						<td><span id="ownerNm"></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t151'/></th>
						<td><span id="ownerDept"></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t155'/></th>
						<td><span id="ownerCall"></span></td>
					</tr>
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t148'/></th>
						<td style="word-break:break-all;" id="resLocation"><%-- ${resLocation} --%></td>
					</tr>							
					<tr>
						<th style="height:30px;background-color: #fafafa"><spring:message code='ezResource.t149'/></th>
						<td id="approveFlag"></td>
					</tr>
					<tr>
						<th style="height:200px;background-color: #fafafa"><spring:message code='ezResource.t271'/></th>
						<td><div style="overflow: auto; height: 200px;word-break:break-all" id="brdExplain"></div></td>
					</tr>
	         	</table>
	         </div>	
        </div>
	</body>
</html>