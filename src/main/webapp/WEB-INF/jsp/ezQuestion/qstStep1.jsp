<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>STEP1</title>
		<meta name="vs_defaultClientScript" content="JavaScript" />
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5" />
		<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezQuestion/common.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<!-- data picker-->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css"/>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css"/>
		<!-- time picker-->
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<script type="text/javascript">
			var L_SearchStartDt = "${uploadSDate}";
	    	var L_SearchEndDt = "${uploadEDate}";
			var FixMonth=Array(0,1,2,3,4,5,6,7,8,9,10,11,12);
			var FixDay=Array(0,31,28,31,30,31,30,31,31,30,31,30,31);
			var g_windowReference = null;
			
			//현재 시간 구하는 함수
			Date.prototype.yyyymmdd = function() {
			    var yyyy = this.getFullYear().toString();
			    var mm = (this.getMonth() + 1).toString();
			    var dd = this.getDate().toString();
			    return yyyy + (mm[1] ? mm : '0'+mm[0]) + (dd[1] ? dd : '0'+dd[0]);
			}
			
			window.onload = function () {
		    	document.getElementById("txtSubject").focus();
			}
			
			function Datepicker_DateInit() {
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
			    if (document.getElementById("hidStartDate").value != "") {
			        var NowDate = new Date(document.getElementById("hidStartDate").value.substring(0, 4), document.getElementById("hidStartDate").value.substring(5, 7) - 1, document.getElementById("hidStartDate").value.substring(8, 10));
		    	    var NowDate2 = new Date(document.getElementById("hidEndDate").value.substring(0, 4), document.getElementById("hidEndDate").value.substring(5, 7) - 1, document.getElementById("hidEndDate").value.substring(8, 10));
		        	$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        	$("#Sdatepicker").datepicker('setDate', NowDate);
		        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        	$("#Edatepicker").datepicker('setDate', NowDate2);
		    	} else {
		        	var NowDate = new Date();
		        	$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        	$("#Sdatepicker").datepicker('setDate', NowDate);
		        	$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        	$("#Edatepicker").datepicker('setDate', NowDate);
		    	}
			});
	    	   
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
	            	document.frmCreate.txtSubject = encodeURIComponent(document.frmCreate.txtSubject); 
	            	document.frmCreate.txtContent = encodeURIComponent(document.frmCreate.textContent); 
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
		            } else{
		            	returnValue = true;
		            }
		        }
		        return returnValue;
		    }
	    	
		    function form_check() {
		        if (trim_Cross(document.getElementById("txtSubject").value) == "" || trim_Cross(document.getElementById("txtSubject").value) == "[<spring:message code="ezQuestion.t185" />") {
		            alert('<spring:message code="ezQuestion.t185" />');
		            
		            document.getElementById("txtSubject").focus();
		            return false;
		        }
		        if (trim_Cross(document.getElementById("txtContent").value) == "") {
		        	alert('<spring:message code="ezQuestion.t186" />');
		            document.getElementById("txtContent").focus();
		            return false;
		        }
		        if (document.getElementById("txtContent").value.length > 127) {
		        	alert('<spring:message code="ezQuestion.t430" />');
		            return false;
		        }
		        if (document.getElementById("set_Target").selectedIndex == 1) {
		            if (document.getElementById("select_YN").value != "YES") {
		            	alert('<spring:message code="ezQuestion.t432" />');
		                return false;
		            }
		        }
		        if (trim_Cross(document.getElementById("txtExpiredate").value) == "") {
		            document.getElementById("hidExpiredate").value = '0';
		            document.getElementById("txtExpiredate").value = '0';
		        } else {
		            var rtnValue = IsNumeric(trim_Cross(document.getElementById("txtExpiredate").value));
		            if (!rtnValue) {
		            	alert('<spring:message code="ezQuestion.t187" />');
		                document.getElementById("txtExpiredate").value = "";
		                document.getElementById("txtExpiredate").focus();
		                return false;
		            }
		        }
		        L_SearchStartDt = L_SearchStartDt.substring(0, 10);
		        L_SearchEndDt = L_SearchEndDt.substring(0, 10);
		
		        if (L_SearchStartDt > L_SearchEndDt) {
		        	alert('<spring:message code="ezQuestion.t448" />');
		            return false;
		        }
		
		        if (trim_Cross(document.getElementById("txtExpiredate").value) != "") {
		            var PollEndDate = L_SearchEndDt
		            var tempE = PollEndDate.split("-");
		            var szEYear = tempE[0];
		            var szEMonth = tempE[1];
		            var szEDay = tempE[2];
		            var DisplayDueDate = AddDate(trim_Cross(document.getElementById("txtExpiredate").value), szEYear, szEMonth, szEDay);
		
		            PollEndDate = szEYear + szEMonth + szEDay;
		        }
		        
		        var m_PostDate = new Date().yyyymmdd(); 
		        var m_PollStartDate = L_SearchStartDt;
		        var tempS = m_PollStartDate.split("-");
		        var szSYear = tempS[0];
		        var szSMonth = tempS[1];
		        var szSDay = tempS[2];
		        m_PollStartDate = szSYear + szSMonth + szSDay
		        if (m_PostDate > m_PollStartDate) {
		        	alert("<spring:message code='ezQuestion.t199'/>");
		            return false;
		        }
		    }
		    function fun_cancel() {
		        if (confirm("<spring:message code='ezQuestion.t434'/>")) {
		            menuQst_List();
		        }
		    }
		    function menuQst_List() {
		         if(CrossYN()) {
					var szUrl = "/ezQuestion/qstList.do?brdID=${brdID}&brdNm=${brdNm}&brdPostterm=${brdPostterm}"; 
		         } else {
		        	var szUrl = "/ezQuestion/qstList.do?brdID=${brdID}&brdNm=${brdNm}&brdPostterm=${brdPostterm}";
		        }
		        window.location.href = szUrl; 
		    } 
		    function menu_SelectRange() {
		         if (CrossYN()) {
		            var item_no = document.getElementById("item_no").value;
		
		            if (CrossYN()) {
		            	var szUrl = "/ezQuestion/qstRangeSelect.do?brdID=5&itemNo=" + item_no;
		            } else {
		            	var szUrl = "/ezQuestion/qstRangeSelect.do?brdID=5&itemNo=" + item_no;
		            }
		                
		            var _MSIE = 'MSIE';
		            var useragentstr = navigator.userAgent;
		            if (useragentstr.indexOf(_MSIE) != -1) {
		                var szParam = "dialogHeight:705px;dialogWidth:562px;edge:sunken;status:no;resizable:no;help:no;center:yes;scroll:no" + GetShowModalPosition(562, 705);
		                var rv = window.showModalDialog(szUrl, document.getElementById("RangeXMLStr").value, szParam);
		                if (rv[0] == "OK") {
		                    document.getElementById("set_Target").selectedIndex = 1;
		                    document.getElementById("hidTarget").value = "1";
		                    document.getElementById("select_YN").value = "YES";
		                    document.getElementById("RangeXMLStr").value = rv[1];
		                } else if (rv[0] == "NO") {
		                    document.getElementById("set_Target").selectedIndex = 0;
		                    document.getElementById("hidTarget").value = "0";
		                    document.getElementById("selectYN").value = "NO";
		                    document.getElementById("RangeXMLStr").value = "";
		                }
		            } else {
		                if ((g_windowReference == null) || (g_windowReference.closed == true)) {
		                    if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
		                        var feature = GetOpenPosition(560, 730);
		                        g_windowReference = window.open(szUrl, "SelectRange", "height=730,width=560,resizable=no,center=yes" + feature);
		                    } else {
		                        var feature = GetOpenPosition(730, 700);
		                        g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes" + feature);
		                    }
		                }
		                g_windowReference.focus();
		            }
		        } else {
		            menu_SelectRange_IE();
		        } 
		    }
		    function menu_SelectRange_IE() {
		        var item_no = document.all("item_no").value;
		         var szUrl = "/ezQuestion/qstRangeSelect.do?brdID=5&itemNo=" + item_no; 
		        if ((g_windowReference == null) || (g_windowReference.closed == true)) {
		            if (window.navigator.userAgent.indexOf("Safari") > 0 && window.navigator.userAgent.indexOf("Chrome") == -1) {
		                var feature = GetOpenPosition(560, 630);
		                g_windowReference = window.open(szUrl, "SelectRange", "height=630,width=560,resizable=no,center=yes" + feature);
		            } else {
		                var feature = GetOpenPosition(560, 700);
		                g_windowReference = window.open(szUrl, "SelectRange", "height=700,width=560,resizable=no,center=yes" + feature);
		            }
		        }
		        g_windowReference.focus();
		    }
		    function closeWindow() {
		        if ((g_windowReference != null) && (g_windowReference.closed == false)) {
		            g_windowReference.close();
		            g_windowReference = null;
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
		    function set_Target_onchange() {
		        var index = document.getElementById("set_Target").selectedIndex;
		        document.getElementById("hidTarget").value = index;
		    }
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
			function GetRangeValue()
			{
			    return document.getElementById("RangeXMLStr").value;
			}
			
		</script>
	</head>
	<body class="mainbody"> 
		<form id="frmCreate" method="post" action="/ezQuestion/qstStep2.do" name="frmCreate"> 
	        <h1><spring:message code="ezQuestion.t436" /></h1>
	        <div id="mainmenu">
	            <ul>
	                <li><span onclick="menuQst_List()"><spring:message code="ezQuestion.t130"/></span></li>
	            </ul>
	        </div>
	        <script type="text/javascript">
		        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	        </script>
	        
	        <h2><spring:message code="ezQuestion.t437" /></h2>
	        <table class="content"> 
	            <tr>    <!------------설문조사 기간 ----------------> 
	                <th><spring:message code="ezQuestion.t216" /></th> 
	                <td>
	                   <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~
	                  <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
	                </td> 
	            </tr> 
	            <tr>        <!----------설문 공개기간 -----------------> 
	                <th><spring:message code="ezQuestion.t231" /></th> 
	                <td>
	                    <spring:message code="ezQuestion.t232" />
	                    <input type="text" name="txtExpiredate" id="txtExpiredate" style="FONT-SIZE:9pt;  WIDTH:50px" maxlength="4" /> 
	                    <input type="hidden" id="hidExpiredate" value="0"> 
	                    <spring:message code="ezQuestion.t440" />
	                </td> 
	            </tr> 
	            <tr> <!-------------각종 설문 옵션 -----------------> 
	                <th><spring:message code="ezQuestion.t236" /></th> 
	                <td style="border-right:medium none; white-space:nowrap">
	                    <spring:message code="ezQuestion.t237" />
	                    <select name="setAnonymity" id="set_anonymity" onChange="return set_anonymity_onchange()"> 
	                      <option value="0" selected="selected"><spring:message code="ezQuestion.t238" /></option> 
	                      <option value="1"><spring:message code="ezQuestion.t239" /></option> 
	                    </select>
	                    <div style="display:none">
	                        <!-- hidden타입 사용시 크롬등에서 history.back()시 이전값을 캐쉬하지 않아 text타입으로 변경 -->
	                        <input type="text" name="hidAnonymity" id="hidanonymity" value="0" style="display:none"> 
	                        <input type="text" name="hidOpenResult" id="hidopenResult" value="1" style="display:none"> 
	                        <input type="text" name="hidMultiResponse" id="hidMultiResponse" value="0" style="display:none"> 
	                        <input type="text" name="hidTarget" id="hidTarget" value="0" style="display:none"> 
	                        <input type="text" name="brdID" id="brd_id" value="${qstStep1VO.brdID}" style="display:none"> 
	                        <input type="text" name="brdNm" id="brd_nm" value="${qstStep1VO.brdNm}" style="display:none"> 
	                        <input type="text" name="brdPostterm" id="brd_postterm" value="${qstStep1VO.brdPostterm}" style="display:none"> 
	                        <input type="text" name="itemNo" id="item_no" style="display:none"> 
	                        <input type="text" name="hidStartDate" id="hidStartDate" style="display:none"> 
	                        <input type="text" name="hidEndDate" id="hidEndDate" style="display:none">
	                        <input type="text" name="selectYN" id="select_YN" style="display:none">
	                        <input type="text" name="RangeXMLStr" id="RangeXMLStr" style="display:none">
	                    </div>
	                    <spring:message code="ezQuestion.t240" />
	                    <select name="setMultiResponse" id="set_MultiResponse" onChange="return set_MultiResponse_onchange()"> 
	                      <option value="1"><spring:message code="ezQuestion.t241" /></option> 
	                      <option value="0" selected="selected"><spring:message code="ezQuestion.t242" /></option> 
	                    </select> 
	                    
	                    &nbsp;&nbsp;&nbsp;
	                    <spring:message code="ezQuestion.t243" />
	                    <select name="setOpenResult" id="set_openResult"  onChange="return set_openResult_onchange()"> 
	                      <option value="1" selected="selected"><spring:message code="ezQuestion.t244" /></option> 
	                      <option value="0"><spring:message code="ezQuestion.t245" /></option> 
	                    </select> 
	                    
	                    <select id="importance" name="importance" style="DISPLAY:none"> 
	                      <option value="1"><spring:message code="ezQuestion.t246" /></option> 
	                      <option value="2" selected="selected"><spring:message code="ezQuestion.t247" /></option> 
	                      <option value="3"><spring:message code="ezQuestion.t248" /></option> 
	                    </select>
	                </td> 
	            </tr> 
	            <tr>     <!----------- 설문 응답자 범위(전체/선정) --------------> 
	                <th><spring:message code="ezQuestion.t441" /></th> 
	                <td>
	                    <select name="setTarget" id="set_Target" onchange="return set_Target_onchange()"> 
	                        <option value="0" selected="selected"><spring:message code="ezQuestion.t251" /></option> 
	                        <option value="1"><spring:message code="ezQuestion.t252" /></option> 
	                    </select> 
	                    <a class="imgbtn"><span onclick="menu_SelectRange();"><spring:message code="ezQuestion.t253" /></span></a>
	                </td> 
	            </tr> 
	            <tr> <!----------- 설문제목 -------------> 
	                <th><spring:message code="ezQuestion.t255" /></th> 
	                <td><input type="text" maxlength="100" name="txtSubject" style="WIDTH:100%;" maxlength = "250" id="txtSubject" /></td> 
	            </tr> 
	            <tr> 
	                <th><spring:message code="ezQuestion.t257" /></th> 
	                <td><textarea name="txtContent" id="txtContent" style="WIDTH:99.85%; padding:0px; resize:none; overflow:auto;" rows="10" cols="" maxlength="250"></textarea></td> 
	            </tr>
	        </table> 
	        <div class="btnposition">
	            <a class="imgbtn" name="Submit" onclick="javascript:Next();" ><span><spring:message code="ezQuestion.t442" /></span></a>
	            <a class="imgbtn" name="Submit2" onclick="javascript:fun_cancel();" ><span><spring:message code="ezQuestion.t269" /></span></a>
	        </div>
	    </form> 
	</body>
</html>