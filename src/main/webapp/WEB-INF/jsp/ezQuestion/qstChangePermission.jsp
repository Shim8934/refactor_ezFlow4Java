<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezQuestion.t181" /></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezQuestion/common.js"></script>
		
		<!-- data picker-->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css"/>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css"/>
		
		<!-- time picker-->
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<script language="JavaScript" type="text/javascript">
			var g_Dateinit = true;
			var L_SearchStartDt = "${qstUserPollItemVO.pollStartDate}";
			var L_SearchEndDt = "${qstUserPollItemVO.pollEndDate}";
			var FixMonth=Array(0,1,2,3,4,5,6,7,8,9,10,11,12);
			var FixDay = Array(0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
			var flgClose=true;
			var public_result_flg = "${qstListVO.publicResultFlg}";
			var multi_response_flg = "${qstListVO.multiResponseFlg}";
	    	var g_windowReference = null;
	    	document.onselectstart = function () { return false; };
	    	window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
	    	        document.body.style.WebkitUserSelect = 'none';
	        	    document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
	    	    }
	        	Save_OK_chk();
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
	        	var NowDate = new Date("${uploadSDate}");
	        	var NowDate2 = new Date("${uploadEDate}");

	        	NowDate.setHours(NowDate.getHours() - 9);
	        	NowDate2.setHours(NowDate2.getHours() - 9);
	        	$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        	$("#Sdatepicker").datepicker('setDate', NowDate);
	        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        	$("#Edatepicker").datepicker('setDate', NowDate2);
	    	});
	    	<%-- <% if(userinfo.lang.Equals("1")){%> --%>
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
	    	<%-- <%}else {%> --%>
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
	    	<%-- <%}%> --%>
	    	function Date_calcu(Year) {
		        if ((Year % 4) && Year % 100 || !(Year % 400)) {
		            return true;
		        } else {
	        	    FixDay[2] = 29;
	    	    }
	    	}
	    	function AddDate(vaddday, vyear, vmonth, vday) {
		        var vyear = parseInt(vyear);
		        var vmonth = parseInt(vmonth);
	    	    var vday = parseInt(vday);
	        	var ttldate = parseInt(vaddday) + vday
	        	Date_calcu(vyear)
	        	while (FixDay[vmonth] < ttldate) {
		            if (vmonth < 13) {
		                ttldate -= FixDay[vmonth];
	    	            vmonth += 1;
	        	    } else {
		                vyear += 1;
	    	            Date_calcu(vyear);
	        	        vmonth -= 1;
	            	}
	        	}
	        	return String(vyear) + String(vmonth) + String(ttldate);
	    	}
	    	function Next() {
		        var szAnonymity, szOpenResult, szMultiResponse;
		        var index = document.getElementById("set_anonymity").selectedIndex;
	    	    szAnonymity = document.getElementById("set_anonymity")[index].value;
	        	index = document.getElementById("set_openResult").selectedIndex;
	        	szOpenResult = document.getElementById("set_openResult")[index].value;
	        	index = document.getElementById("set_MultiResponse").selectedIndex;
	        	szMultiResponse = document.getElementById("set_MultiResponse")[index].value;
	        	L_SearchStartDt = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	        	L_SearchEndDt = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	        	if (form_check() == false) {
	        		return;
	        	} else {
		            document.getElementById("hidStartDate").value = L_SearchStartDt + " 00:00:00";
		            document.getElementById("hidEndDate").value = L_SearchEndDt + " 23:59:59";
	    	        document.frmCreate.submit();
	        	}
	    	}
	    	function IsNumeric(vdata) {
		        var num = "0123456789";
		        var returnValue = true;
	    	    for (var i = 0 ; i < vdata.length; i++) {
	        	    if (-1 == num.indexOf(vdata.charAt(i))) {
	            	    returnValue = false;
		                break;
		            } else {
	        	        returnValue = true;
	    	        }
	        	}
	        	return returnValue;
	    	}
	    	function form_check() {
		        if (trim_Cross(document.getElementById("txtSubject").value) == "" || trim_Cross(document.getElementById("txtSubject").value) == "[<spring:message code='ezQuestion.t428' />") {
		            alert("<spring:message code='ezQuestion.t185' />");
	    	        document.getElementById("txtSubject").focus();
	        	    return false;
	        	}
	        	if (trim_Cross(document.getElementById("txtContent").value) == "") {
		            alert("<spring:message code='ezQuestion.t186' />");
		            document.getElementById("txtContent").focus();
	    	        return false;
	        	}
	        	if (document.getElementById("txtContent").value.length > 127) {
		            alert("<spring:message code='ezQuestion.t430' />");
		            return false;
	    	    }
	        	//if (document.getElementById("set_Target").selectedIndex == 1) {
	        	//    if (document.getElementById("select_YN").value != "YES") {
	        	//        alert("<spring:message code='ezQuestion.t432' />");
	        	//        return false;
	        	//    }
	        	//}
	        	if (trim_Cross(document.getElementById("txtExpiredate").value) == "") {
		            document.getElementById("hidExpiredate").value = '';
		            document.getElementById("txtExpiredate").value = '';
	    	    } else {
	            	var rtnValue = IsNumeric(trim_Cross(document.getElementById("txtExpiredate").value));
	            	if (!rtnValue) {
		                alert("<spring:message code='ezQuestion.t187' />");
		                document.getElementById("txtExpiredate").value = "";
	    	            document.getElementById("txtExpiredate").focus();
	        	        return false;
	            	}
	        	}
	        	L_SearchStartDt = L_SearchStartDt.substring(0, 10);
	        	L_SearchEndDt = L_SearchEndDt.substring(0, 10);
	        	if (trim_Cross(document.getElementById("txtExpiredate").value) != "") {
		            var PollEndDate = L_SearchEndDt
		            var tempE = PollEndDate.split("-");
	    	        var szEYear = tempE[0];
	        	    var szEMonth = tempE[1];
	            	var szEDay = tempE[2];
	            	var DisplayDueDate = AddDate(trim_Cross(document.getElementById("txtExpiredate").value), szEYear, szEMonth, szEDay);

		            PollEndDate = szEYear + szEMonth + szEDay;
		        }

	    	    var m_PostDate = "${mPostDate}";
	        	var m_PollStartDate = L_SearchStartDt;
	        	var tempS = m_PollStartDate.split("-");
	        	var szSYear = tempS[0];
	        	var szSMonth = tempS[1];
	        	var szSDay = tempS[2];
	        	m_PollStartDate = szSYear + szSMonth + szSDay
	        	if (m_PostDate > m_PollStartDate) {
		            alert("<spring:message code='ezQuestion.t199' />");
		            document.getElementById("idDatepicker").focus();
	    	        return false;
	        	}
	    	}
	    	function fun_cancel() {
		        menuQst_List();
		    }
	    	function fun_OK() {
	        	if (document.getElementById("RangeXMLStr").value == "" && document.getElementById("hidTarget").value == "1") {
		            alert("<spring:message code='ezQuestion.t432' />");
		            return;
	    	    }
	        	if (form_check() == false) {
	            	return;
	        	} else {
	            	document.getElementById("hidStartDate").value = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00";
	            	document.getElementById("hidEndDate").value = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59:59";
	            	document.frmCreate.submit();
	        	}
	    	}
	    	function PollEnd() {
		        var StatusEnd = "${qstUserPermissionVO.endFlg}";
		        if (StatusEnd == "1") {
	    	        alert("<spring:message code='ezQuestion.t203' />");
	        	    return;
	        	}
		        
	        	var m_PostDate = "${mPostDate}";
	        	if (L_SearchStartDt.length > 10) {
	            	L_SearchStartDt = L_SearchStartDt.substring(0, 10);
	        	}
	        	var m_PollStartDate = L_SearchStartDt;
	        	var tempS = m_PollStartDate.split("-");
	        	var szSYear = tempS[0];
	        	var szSMonth = tempS[1];
	        	var szSDay = tempS[2];
	        	m_PollStartDate = szSYear + szSMonth + szSDay;
	        	if (m_PollStartDate > m_PostDate) {
		            alert("<spring:message code='ezQuestion.t204' />");
		            return;
	    	    }
	        	if (confirm("<spring:message code='ezQuestion.t205' />")) {
	            	document.frmEndPoll.submit();
	        	}
	    	}
			var g_BrdID = "${qstListVO.brdID}";
	    	function menuQst_List() {
		        var szUrl = "qstList.do?${ReceveStr2}";
		        window.location.href = szUrl;
	    	}
	    	function menu_SelectRange() {
		        var item_no = document.getElementById("item_no").value;
		        var szUrl = "/ezQuestion/rangeSelect.do?brd_id=5&item_no=" + item_no;
	    	    if ((g_windowReference == null) || (g_windowReference.closed == true)) {
	        	    if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
	            	    var feature = GetOpenPosition(560, 630);
	                	g_windowReference = window.open(szUrl, "SelectRange", "height=630,width=560,resizable=no,center=yes" + feature);
	            	} else {
		                var feature = GetOpenPosition(560, 700);
		                g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes " + feature);
	    	        }
	        	}
	    	}
	    	function closeWindow() {
	        	if ((g_windowReference != null) && (g_windowReference.closed == false)) {
	            	g_windowReference.close();
	            	g_windowReference = null;
	        	}
	    	}
	    	function GetRangeValue() {
		        return document.getElementById("RangeXMLStr").value;
		    }
		</script>
		<script ID="clientEventHandlersJS" type="text/javascript">
			function set_anonymity_onchange() {
				var idx = document.getElementById("set_anonymity").selectedIndex;
				document.getElementById("hidanonymity").value = document.getElementById("set_anonymity")[idx].value;	
			}
			function set_MultiResponse_onchange() {
				var idx = document.getElementById("set_MultiResponse").selectedIndex;
				document.getElementById("hidMultiResponse").value = document.getElementById("set_MultiResponse")[idx].value;
			}
			function set_openResult_onchange() {
				var idx = document.getElementById("set_openResult").selectedIndex;
				document.getElementById("hidopenResult").value = document.getElementById("set_openResult")[idx].value;
			}
			function set_Target_onchange() {
				var idx = document.getElementById("set_Target").selectedIndex;
				document.getElementById("hidTarget").value = document.getElementById("set_Target")[idx].value;
			}
			function Save_OK_chk() {
	    		var ResultYN = '${resultYN}';
	    		if (ResultYN == "True") {
	        		document.getElementById("set_anonymity").disabled = true;
	        		document.getElementById("set_Target").disabled = true;
	        		document.getElementById("aLinkbtn").style.display = "none";
	    		}
	    		var tmpChk = '${saveFlg}'
	    		if (tmpChk == "OK") {
	        		alert("<spring:message code='ezQuestion.t212' />");
	        		menuQst_List();
	    		}
			}
    		function updateParent(_element, _value, _Type) {
        		var elementRef = document.getElementsByName(_element);
        		if (elementRef.length > 0) {
            		switch (_Type) {
                		case "selectedIndex":
                    		elementRef[0].selectedIndex = _value;
                    		break;
                		case "value":
                    		elementRef[0].value = _value;
                    		break;
            		}
        		}
    		}
		</script>
	</head>
	<body class="mainbody">
		<form method="post" action="/ezQuestion/callChangePermission.do" name="frmCreate" id="frmCreate"> 
        	<input type="hidden" value="${receveStr2}" name="Receve_str2" id="Receve_str2" /> 
        	<h1><spring:message code='ezQuestion.t213' /></h1>
        	<div id="mainmenu">
            	<ul>
                	<li><span onclick="menuQst_List()"><spring:message code='ezQuestion.t130' /></span></li>
                	<li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif"></li>
                	<li><span onclick="PollEnd()"><spring:message code='ezQuestion.t214' /></span></li>
            	</ul>
        	</div>
        	<script type="text/javascript">
	            selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
    	    </script>
        	<table class="content">     
            	<tr> <!------------설문조사 기간 ----------------> 
                	<th><spring:message code='ezQuestion.t216' /></th> 
                	<td style="width:100%">
                    	<input type="text" id="Sdatepicker" style="width:80px;text-align:center"> ~
                  	<input type="text" id="Edatepicker" style="width:80px;text-align:center">
                	</td> 
            	</tr> 
            	<tr> 
                	<th><spring:message code='ezQuestion.t231' /></th> <!----------설문 공개기간 -----------------> 
                	<td>
                    	<spring:message code='ezQuestion.t232' />
                    	<input style="WIDTH: 50px" type="text" maxLength="4" value="${qstUserPollItemVO.postTerm}" name="txtExpiredate" id="txtExpiredate"/> 
                    	<input type="hidden" id="hidExpiredate" value="0" name="hidden" /> 
                    	<spring:message code='ezQuestion.t233' />
                    	<%-- <% if (int.Parse(post_term)==0) { %> --%> 
                    	(<spring:message code='ezQuestion.t234' />
                    	<%-- <% } %>  --%>
                	</td> 
            	</tr> 
            	<tr> <!-------------각종 설문 옵션 -----------------> 
                	<th><spring:message code='ezQuestion.t236' /></th> 
                	<td style="border-right:medium none; text-overflow:ellipsis; white-space:nowrap">
	                    <spring:message code='ezQuestion.t237' />
    	                <select onchange="return set_anonymity_onchange()" name="set_anonymity" id="set_anonymity">
    	                	<c:choose>
    	                		<c:when test="${qstUserPermissionVO.publicFlg eq '0'}"> 
            	            		<option value="0" selected="selected"><spring:message code='ezQuestion.t238' /></option> 
                	        		<option value="1"><spring:message code='ezQuestion.t239' /></option>
								</c:when>                	        		 
                    	    	<c:otherwise>
                    	    		<option value="0"><spring:message code='ezQuestion.t238' /></option> 
                        			<option value="1" selected="selected"><spring:message code='ezQuestion.t239' /></option>
                    	    	</c:otherwise> 
                        	</c:choose> 
                    	</select> 
                    	<spring:message code='ezQuestion.t240' />
                    	<select onchange="return set_MultiResponse_onchange()" name="set_MultiResponse" id="set_MultiResponse">
                    		<c:choose>  
	                        	<c:when test="${qstUserPermissionVO.multiResponseFlg eq '0'}">  
    	                    		<option value="1"><spring:message code='ezQuestion.t241' /></option> 
        	                		<option value="0" selected="selected"><spring:message code='ezQuestion.t242' /></option>
        	                	</c:when> 
            	            	<c:otherwise>
                	        		<option value="1" selected="selected"><spring:message code='ezQuestion.t241' /></option> 
                    	    		<option value="0"><spring:message code='ezQuestion.t242' /></option>
                    	    	</c:otherwise> 
                        	</c:choose>  
                    	</select>&nbsp;&nbsp;&nbsp;
                    	<spring:message code='ezQuestion.t243' />
                    	<select onchange="return set_openResult_onchange()" name="set_openResult" id="set_openResult">
                    		<c:choose>   
	                        	<c:when test="${qstUserPermissionVO.publicResultFlg eq '0'}">
    	                    		<option value="1"><spring:message code='ezQuestion.t244' /></option> 
        	                		<option value="0" selected="selected"><spring:message code='ezQuestion.t245' /></option>
        	                	</c:when>	 
            	            	<c:otherwise>
                	        		<option value="1" selected="selected"><spring:message code='ezQuestion.t244' /></option> 
                    	    		<option value="0"><spring:message code='ezQuestion.t245' /></option> 
                        	</c:otherwise> 
						</c:choose>                        	
                    	</select> 
                    	<select id="importance" name="importance" style="DISPLAY:none">
                    		<c:choose> 
                    			<c:when test="${qstUserPollItemVO.itemImp eq '1'}">
			                        <option value="1"  selected><spring:message code='ezQuestion.t246' /></option>
	    		                    <option value="2"><spring:message code='ezQuestion.t247' /></option>
	            		            <option value="3"><spring:message code='ezQuestion.t248' /></option> 
        	                	</c:when>
        	                	<c:when test="${qstUserPollItemVO.itemImp eq '2'}">
			                        <option value="1"><spring:message code='ezQuestion.t246' /></option>
	    		                    <option value="2" selected><spring:message code='ezQuestion.t247' /></option>
	            		            <option value="3"><spring:message code='ezQuestion.t248' /></option> 
        	                	</c:when>
        	                	<c:when test="${qstUserPollItemVO.itemImp eq '3'}">
			                        <option value="1"><spring:message code='ezQuestion.t246' /></option>
	    		                    <option value="2"><spring:message code='ezQuestion.t247' /></option>
	            		            <option value="3" selected><spring:message code='ezQuestion.t248' /></option> 
        	                	</c:when>
        	                </c:choose> 
            	        </select>
                	</td> 
            	</tr> 
            	<tr> <!----------- 설문 응답자 범위(전체/선정) --------------> 
	                <th><spring:message code='ezQuestion.t250' /></th> 
    	            <td>
        	            <select style="WIDTH: 100px; FONT-FAMILY: '<spring:message code='ezQuestion.t105' />'" onchange="return set_Target_onchange()" name="set_Target" id="set_Target">
        	            	<c:choose> 
        	            		<c:when test="${qstUserPermissionVO.responseRange eq '0'}">
                	        		<option value="0" selected="selected"><spring:message code='ezQuestion.t251' /></option> 
                    	    		<option value="1"><spring:message code='ezQuestion.t252' /></option>
                    	    	</c:when> 
                        	 	<c:otherwise>
                        			<option value="0"><spring:message code='ezQuestion.t251' /></option> 
                        			<option value="1" selected="selected"><spring:message code='ezQuestion.t252' /></option>
                        		</c:otherwise> 
                        	</c:choose>
                    	</select> 
                    	<a id="aLinkbtn" class="imgbtn"><span id="aLink" <%-- <% if (!ResultYN) { Response.Write("onclick='menu_SelectRange()' "); } %> --%>><spring:message code='ezQuestion.t253' /></span></a>
                	</td> 
            	</tr> 
            	<tr> <!----------- 설문제목 -------------> 
	                <th><spring:message code='ezQuestion.t255' /></th> 																																							<!-- 	//자바단에서 replace해주기 -->		
    	            <td><input type="text" maxlength="500" name="txtSubject" id="txtSubject" style="FONT-SIZE:9pt;  WIDTH:99%;  FONT-FAMILY:'<spring:message code='ezQuestion.t105' />'" value="${qstUserPollItemVO.title}"> </td> 
        	    </tr>
            	<tr>    <!----------- 설문취지 ------------------> 
	                <th><spring:message code='ezQuestion.t257' /></th> 
    	            <td><textarea name="txtContent" id="txtContent" style="WIDTH: 99%; FONT-FAMILY: '<spring:message code='ezQuestion.t105' />'" rows="10" cols="">${qstUserPollItemVO.content}</textarea></td> 
        	    </tr> 
        	</table> 
        	<div class="btnposition">
            	<a class="imgbtn"><span onclick="fun_OK();"><spring:message code='ezQuestion.t37' /></span></a>
            	<a class="imgbtn"><span onclick="fun_cancel();"><spring:message code='ezQuestion.t38' /></span></a>
        	</div>
        	<div id="hidField" style="display:none">
	            <input type="hidden" name="brd_id" id="brd_id" value="${qstListVO.brdID}" /> 
    	        <input type="hidden" name="item_no" id="item_no" value="${qstUserPollItemVO.itemNo}" /> 
        	    <input type="hidden" name="hidanonymity" id="hidanonymity" value="${qstUserPermissionVO.publicFlg}" /> 
            	<input type="hidden" name="hidopenResult" id="hidopenResult" value="${qstUserPermissionVO.publicResultFlg}" /> 
            	<input type="hidden" name="hidMultiResponse" id="hidMultiResponse" value="${qstUserPermissionVO.multiResponseFlg}" /> 
            	<input type="hidden" name="hidendpoll" id="hidendpoll" value="${qstUserPermissionVO.endFlg}" /> 
            	<input type="hidden" name="brd_id2" id="brd_id2" value="${qstListVO.brdID}" /> 
            	<input type="hidden" name="brd_nm" id="brd_nm" value="${ezQuestionVO.brdNm}" /> 
            	<input type="hidden" name="brd_postterm" id="brd_postterm" value="${ezQuestionVO.brdPostterm}" />        
            	<input type="hidden" name="hidStartDate" id="hidStartDate" value="${qstUserPollItemVO.pollStartDate}" />
            	<input type="hidden" name="item_no2" id="item_no2" value="${qstUserPollItemVO.itemNo}" />        
            	<input type="hidden" name="hidEndDate" id="hidEndDate" value="${qstUserPollItemVO.pollEndDate}" />
            	<input type="hidden" name="hidTarget" id="hidTarget" value="${qstUserPermissionVO.responseRange}" /> 
            	<input type="hidden" name="select_YN" id="select_YN" />
            	<input type="hidden" name="RangeXMLStr" id="RangeXMLStr" value="<%-- <%= Server.HtmlEncode(_SB.ToString()) %> --%>" />
        	</div>
		</form> 
    	<form name="frmEndPoll" action="/ezQuestion/callEndPoll.do" method="post"> 
        	<input type="hidden" value="${qstListVO.brdID}" name="brd_id"/> 
        	<input type="hidden" value="${qstListVO.itemNo}" name="item_no" /> 
        	<input type="hidden" value="1" name="hidEndPoll" /> 
        	<input type="hidden" value="${receve}" name="Receve_str2" /> 
		</form> 	
	</body>
</html>