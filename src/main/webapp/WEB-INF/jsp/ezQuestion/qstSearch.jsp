<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezQuestion.t270" /></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		
		<!-- data picker-->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css"/>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css"/>
		
		<!-- time picker-->
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<!-- <script src="//code.jquery.com/jquery-1.12.0.min.js"></script> -->
		<style>
		</style>
		<script language="JavaScript" type="text/javascript">
			//현재 시간 구하는 함수
			Date.prototype.yyyymmdd = function() {
		    	var yyyy = this.getFullYear().toString();
		    	var mm = (this.getMonth() + 1).toString();
		    	var dd = this.getDate().toString();
		    	return yyyy +"-"+ (mm[1] ? mm : '0'+mm[0]) +"-"+ (dd[1] ? dd : '0'+dd[0]);
			}
			var time = new Date();
			var g_Dateinit = false;
			var L_SearchStartDt = new Date().yyyymmdd();
			var L_SearchEndDt = new Date().yyyymmdd(); 
			var FixMonth=Array(0,1,2,3,4,5,6,7,8,9,10,11,12);
			var FixDay=Array(0,31,28,31,30,31,30,31,31,30,31,30,31)
			document.onselectstart = function () { return false; };
			window.onload = function () {
		    	if (navigator.userAgent.indexOf('Firefox') != -1) {
		        	document.body.style.MozUserSelect = 'none';
		        	document.body.style.WebkitUserSelect = 'none';
		        	document.body.style.khtmlUserSelect = 'none';
		        	document.body.style.oUserSelect = 'none';
		        	document.body.style.UserSelect = 'none';
		    	}
		    	document.getElementById("txtSubject").focus();
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

			    var NowDate = new Date();
			    $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			    $("#Sdatepicker").datepicker('setDate', NowDate);
		    	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		    	$("#Edatepicker").datepicker('setDate', NowDate);
			});
    	
    	if ("${userinfo.lang}" == 1) {
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
    	
    	function Date_calcu(Year) {   
	        if((Year%4) && Year%100 || !(Year%400)) {
    	        return true;
	        } else {
	            FixDay[2]=29;
        	}
    	}
    	function AddDate(vaddday,vyear,vmonth,vday) {
        	var vyear=parseInt(vyear);	
        	var vmonth=parseInt(vmonth);
        	var vday=parseInt(vday);
        	var ttldate=parseInt(vaddday) + vday
        	Date_calcu(vyear)
        	while (FixDay[vmonth] < ttldate  ) {
            	if (vmonth < 13) {
                	ttldate-=FixDay[vmonth];
                	vmonth+=1;
            	} else {
                	vyear+=1;
                	Date_calcu(vyear);	
                	vmonth-=1;
            	}  
        	}
        	return String(vyear)+String(vmonth)+String(ttldate);
    	}
    	function menuQst_List() {
        	if(CrossYN()) {
        		var szUrl = "qstList.do?brdID=${pBrdID}"
        	} else {
            	var szUrl = "qstList.do?brdID=${pBrdID}"
        	}
        	window.location.href = szUrl;	
    	}
    	function form_check() {
        	if (trim_Cross(document.getElementById("txtSubject").value) == "") {
            	alert("<spring:message code='ezQuestion.t415' />");
            	document.getElementById("txtSubject").focus();
            	return false;
        	}
        	if( L_SearchStartDt.length == 0 ) {
            	alert("<spring:message code='ezQuestion.t416' />")
            	return false;
        	}
        	if( L_SearchEndDt.length == 0 ) {
            	alert("<spring:message code='ezQuestion.t417' />")
            	return false;
        	}
        	L_SearchStartDt = L_SearchStartDt.substring(0, 10)
        	L_SearchEndDt = L_SearchEndDt.substring(0, 10)
        	var m_PollStartDate = L_SearchStartDt;
        	var m_PollEndDate = L_SearchEndDt;
        	var tempS = m_PollStartDate.split("-");
        	var szSYear		= tempS[0];
        	var szSMonth	= tempS[1];
        	var szSDay		= tempS[2];
        	var tempE = m_PollEndDate.split("-");
        	var szEYear		= tempE[0];
        	var szEMonth	= tempE[1];
        	var szEDay		= tempE[2];
        	m_PollStartDate = szSYear + szSMonth + szSDay;
        	m_PollEndDate = szEYear + szEMonth + szEDay;
        	if (m_PollStartDate > m_PollEndDate ) {
            	alert("<spring:message code='ezQuestion.t420' />");
            	return false;
        	}
    	}
    	function ReplaceText( orgStr, findStr, replaceStr ) {
        	var re = new RegExp( findStr, "gi" );
        	return ( orgStr.replace( re, replaceStr ) );
    	}
    	function menu_Search() {
        	var pReservationTime;		
        	var pEndReservationTime;
        	if (form_check() == false) {
        		return;
        	} else {
            	document.getElementById("hidStartDate").value = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
            	document.getElementById("hidEndDate").value = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
            	pReservationTime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
            	var strSearch = "title=" + encodeURI((document.getElementById("txtSubject").value), "'", "'");
            	strSearch += "&responseRange=" + encodeURI($(":input:radio[name=setRange]:checked").val());
            	strSearch += "&pollStartDate=" + encodeURI(document.getElementById("hidStartDate").value);
            	strSearch += "&pollEndDate=" + encodeURI(document.getElementById("hidEndDate").value);

            	var szUrl = "";			    
            	if(CrossYN()) {
                	szUrl = "qstList.do?brdID=${pBrdID}&" + strSearch
            	} else {
                	szUrl = "qstList.do?brdID=${pBrdID}&" + strSearch
            	}
            	window.location.href = szUrl;
        	}	
    	}
    	function setRangeValue(idx) {
        	if( document.getElementsByName("setRange")[idx].checked ) {
            	document.getElementsByName("hidRange").value = document.getElementsByName("setRange")[idx].value;
        	}
    	}
		</script>
	</head>
	<body class="mainbody">
		<form method="post" action="/ezQuestion/qstSearch.do" >
  			<h1><spring:message code='ezQuestion.t300' /></h1>
  			<div id="mainmenu">
    			<ul>
      				<li><span onclick="menuQst_List()"><spring:message code='ezQuestion.t130' /></span></li>
    			</ul>
  			</div>
  			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
  			<h2> <spring:message code='ezQuestion.t421' /></h2>
  			<table class="content">
    			<tr>
      				<th><spring:message code='ezQuestion.t422' /></th>
      				<td style="width:100%">
        				<input type="radio" name="setRange" value="2" onclick="setRangeValue(0)" style="vertical-align:-2px;" checked>
        					<spring:message code='ezQuestion.t423' />
        				<input type="radio" name="setRange" value="0" onclick="setRangeValue(1)" style="vertical-align:-2px;">
        					<spring:message code='ezQuestion.t424' />
        				<input type="radio" name="setRange" value="1" onclick="setRangeValue(2)" style="vertical-align:-2px;">
        					<spring:message code='ezQuestion.t252' />
        				<input type="hidden" id="brd_id" name="brdID" value="${pBrdID}">
        				<input type="hidden" id="hidRange" name="hidRange" value="2">
        				<input type="hidden" id="hidTitle" name="hidTitle">
        				<input type="hidden" id="hidStartDate" name="hidStartDate">
        				<input type="hidden" id="hidEndDate" name="hidEndDate">
    			</tr>
    			<tr>
      				<th><spring:message code='ezQuestion.t255' /></th>
      				<td><input type="text" style="width:100%" size="9" id="txtSubject" name="txtSubject">
      				</td>
    				</tr>
    			<tr>
      				<th ><spring:message code='ezQuestion.t216' /></th>
      				<td>
            			<input type="text" id="Sdatepicker" style="width:80px;text-align:center"> ~
            			<input type="text" id="Edatepicker" style="width:80px;text-align:center">
       				</td>
    			</tr>            
  		</table>
  		<div class="btnposition"> 
  			<a class="imgbtn">
  				<span onclick="menu_Search()"><spring:message code='ezQuestion.t34' /></span>
  			</a>
  		</div>
		</form>
	</body>
</html>