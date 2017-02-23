<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPersonal.t4465'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<!-- data picker-->
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	    <link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<script type="text/javascript">
			var deptid = "${deptID}";
			var userid = "${userID}";
			var startdate = "${startDate}";
			var enddate = "${endDate}";
			var orguserid = "${userInfo.id}";
			var BReason = "${bReason}";
			var gIsAppoint = "1";
			var gIsProxyUser = false;
			var proxydeptid = "${proxyDeptID}";
			var proxyuserid = "${proxyUserID}";
			var proxystartdate = "";
		    var proxyenddate = "";
		    var Roll = "${userInfo.rollInfo}";
		
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        if (startdate == "" && enddate == "") {
		            var nowDate = new Date();
		
		            $("#Sdatepicker").datepicker('setDate', nowDate);
		            $("#Edatepicker").datepicker('setDate', nowDate);
		
		            idDatepicker_Temp = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		            D2_Temp = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        }
		        if (startdate != "") {
		            var nowDate = new Date(startdate.substring(0, 4), startdate.substring(5, 7), startdate.substring(8, 10), startdate.substring(11, 13), startdate.substring(14, 15));
		            var nowDate2 = new Date(enddate.substring(0, 4), enddate.substring(5, 7), enddate.substring(8, 10), enddate.substring(11, 13), enddate.substring(14, 15));
		            nowDate.setMonth(nowDate.getMonth() - 1);
		            nowDate2.setMonth(nowDate2.getMonth() - 1);
		            $("#Sdatepicker").datepicker('setDate', nowDate);
		            $("#Edatepicker").datepicker('setDate', nowDate2);
		            document.getElementById("absentreason").value = BReason;            
		            gIsAppoint = "1";
		        }
		        if (proxystartdate != "") {
		            gIsProxyUser = true;
		        }
		
		        Sel_Change();
		    };
			
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
		        $('#Stimepicker').timepicker();
		        $('#Stimepicker').timepicker({ 'timeFormat': 'H:i' });
		
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $('#Etimepicker').timepicker();
		        $('#Etimepicker').timepicker({ 'timeFormat': 'H:i' });
		    });
		    
		    if ("${userInfo.lang}" == "1") {
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
		
			function DateFormat(obj)
			{
		 	    var yy = String(obj.getFullYear()).substring(0,4);
		 	    if (String(obj.getMonth()+1).length == 1) {
		  	    var mm = "0" + (obj.getMonth()+1); }
		 	    else {
		  	    var mm = obj.getMonth()+1;
		 	    }
		 	    if (String(obj.getDate()).length == 1) {
		  	    var dd = "0" + obj.getDate(); }
		 	    else {
		  	    var dd = obj.getDate();
		 	    }
		 	    var date = String(yy) +"-"+ String(mm) +"-"+ String(dd);
		 	    return date;
			}
			var selectperson_cross_dialogArguments = new Array();
			var type_Complete;
			var NoneActiveX = "YES";
			function select_person(type) {
			    type_Complete = type;
			    if (CrossYN() || NoneActiveX == "YES") {
			        selectperson_cross_dialogArguments[1] = select_person_Complete;
			        var OpenWin = window.open("/ezPersonal/selectPerson.do?type=" + type, "SelectPerson_cross", GetOpenWindowfeature(660, 535));
			        try { OpenWin.focus(); } catch (e) { }
			    }
			    else {
			        var rtnValue = window.showModalDialog("/ezPersonal/selectPerson.do?type=" + type, "",
		                "dialogHeight:535px;dialogwidth:660px;dialogleft:100px;dialogtop:100px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(660, 535));
		
			        if (typeof (rtnValue) != "undefined" && type == "") {
			            userid = rtnValue.split(":")[0];
			            document.getElementById("TextName").value = rtnValue.split(":")[1];
			            deptid = rtnValue.split(":")[2];
			        }
			        if (typeof (rtnValue) != "undefined" && type == "Proxy") {
			            proxyuserid = rtnValue.split(":")[0];
			            document.getElementById("TextProxyName").value = rtnValue.split(":")[1];
			            proxydeptid = rtnValue.split(":")[2];
			        }
			    }
			}
			function select_person_Complete(rtnValue) {
			    if (typeof (rtnValue) != "undefined" && type_Complete == "") {
			        userid = rtnValue.split(":")[0];
			        document.getElementById("TextName").value = rtnValue.split(":")[1];
			        deptid = rtnValue.split(":")[2];
			    }
			    if (typeof (rtnValue) != "undefined" && type_Complete == "Proxy") {
			        proxyuserid = rtnValue.split(":")[0];
			        document.getElementById("TextProxyName").value = rtnValue.split(":")[1];
			        proxydeptid = rtnValue.split(":")[2];
			    }
			}
		
		    function check_enddate() {
		        if (!gIsAppoint && document.getElementById("TextName").value == "")
		            return false;
		        var initdate = "${initDate}";
		        var strCurrDate = initdate.substr(0, 10);
		        var strStartDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        var strEndDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		        if (new Date(strCurrDate) > new Date(strStartDate)) {
		            alert("<spring:message code='ezPersonal.t14'/>");
		            return true;
		        }
		        else if (new Date(strCurrDate) > new Date(strEndDate)) {
		            alert("<spring:message code='ezPersonal.t15'/>");
		            return true;
		        }
		        else
		            return false;
		    }
		    function OK_Click() {
		        if (check_enddate()) {
		            return;
		        }
		
		        if (gIsAppoint != '2') {
		            if (document.getElementById("TextName").value != "" && document.getElementById("absentreason").value != "<spring:message code='ezPersonal.t35'/>") {
		                alert("<spring:message code='ezPersonal.t36'/>");
		                return;
		            }
		        }
				var pProxy = "";
				var pBujae = "";
		        // 대리 결재자 지정
		        if (document.getElementById("TextName").value != "")
		        {
		            if (orguserid.toLowerCase() == userid.toLowerCase()) {
		                alert("<spring:message code='ezPersonal.t16'/>");
		                return;
		            }
		            pBujae = userid + ":" + document.getElementById("TextName").value + ":" + deptid + ":" + $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00/00:" + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23/59";
		        }
		        else if (document.getElementById("absentreason").value != "<spring:message code='ezPersonal.t35'/>") {
		        	pBujae = "" + ":" + "" + ":" + "" + ":" + $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00/00:" + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23/59:" + document.getElementById("absentreason").value;
		            gIsAppoint = "2";
		        }
		        else {
		            pBujae = "";
		            gIsAppoint = "3";
		        }
		
		        // 대리 수신 담당자 지정
		        if (Roll.toLowerCase().indexOf("a=1;") > -1) {
		            if (document.getElementById("TextProxyName").value != "") {
		            	pProxy = proxyuserid + ":" + document.getElementById("TextProxyName").value + ":" + proxydeptid + ":" + $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00/00:" + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23/59";
		                gIsAppoint = "1";
		            }
		            else
		                pProxy = "";
		        }
		        else
		            pProxy = "";

		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPersonal/saveBujae.do",
		    		data : {
		    				buJae  : pBujae,
		    				proxy  : pProxy
		    				},
		    		success: function(text){
			            if (gIsAppoint == "1") {
			                alert("<spring:message code='ezPersonal.t00002'/>"); // 대리 결재자 지정
			            }
			            else if (gIsAppoint == "2") {
			                alert("<spring:message code='ezPersonal.t40'/>"); // 부재사유 설정
			            }
			            else if (gIsAppoint == "3") {
			                alert("<spring:message code='ezPersonal.t41'/>"); // 설정 해제 
			            }
			            window.location.reload(false);
		    		},
		    		error: function(){
			            if (gIsAppoint == "1") {
			                alert("<spring:message code='ezPersonal.t37'/>");
			            }
			            else if (gIsAppoint == "2") {
			                alert("<spring:message code='ezPersonal.t38'/>");
			            }
			            else if (gIsAppoint == "3") {
			                alert("<spring:message code='ezPersonal.t39'/>");
			            }
		    		}
		    	});
		    }
		
		    function Sel_Change()
		    {
		        if (document.getElementById("absentreason").value == "<spring:message code='ezPersonal.t35'/>") {
		            document.getElementById("TR_Appoint").style.display = "";
		        }
		        else {
		            document.getElementById("TR_Appoint").style.display = "none";
		            document.getElementById("TextName").value = "";
		        }
		    }
		</script>
	</head>
	<body>
		<form id="ManageBujae" method="post">
		    <br/>
			 <span class="txt">
						<spring:message code='ezPersonal.t55'/><br>
						<spring:message code='ezPersonal.t56'/><br>
						<spring:message code='ezPersonal.t57'/><br>
			            <spring:message code='ezPersonal.t58'/></span><br/>
			<br/>
			<table class="content" style="width:650px;">
				<tr> 
				<th><spring:message code='ezPersonal.t22'/></th>
					<td>
						<table>
							<tr>
								<td>
									<input type="text" id="Sdatepicker" style="width:80px;text-align:center">
		                            ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center">
							<tr style="DISPLAY:none">
								<td>
									<input id='_T1' class='datepicker_time' readonly="true" style="PADDING-RIGHT: 3px; PADDING-LEFT: 3px; PADDING-BOTTOM: 0px; WIDTH: 73px; PADDING-TOP: 2px">
									<IMG border="0" height="16" id="img_StartTime" src="/images/i_time.gif"
										style="CURSOR: pointer; POSITION: relative;vertical-align:middle" width="16"> <input id='_T2' class='datepicker_time' readonly="true" style="PADDING-RIGHT: 3px; PADDING-LEFT: 3px; PADDING-BOTTOM: 0px; WIDTH: 100px; PADDING-TOP: 2px">
									<IMG border="0" height="16" id="img_EndTime" src="/images/i_time.gif"
										style="CURSOR: pointer; POSITION: relative;vertical-align:middle" width="16">
								</td>
							</tr>
						</table>	  </td>
				</tr>        
				<tr id="TR_Appoint">
					<th><spring:message code='ezPersonal.t31'/></th>
					<td>
						<input type="text" name="TextName" id="TextName" Width="120" value="${textName}" ReadOnly />
						&nbsp;<a class="imgbtn" style="vertical-align:middle"><span onclick="gIsAppoint = '1';select_person('')"><spring:message code='ezPersonal.t32'/></span></a> 
		                <a class="imgbtn" style="vertical-align:middle"><span onClick="gIsAppoint = '2';document.getElementById('TextName').value='';"><spring:message code='ezPersonal.t33'/></span></a>
					</td>
				</tr>
				<c:if test="${fn:indexOf(fn:toLowerCase(userInfo.rollInfo), 'a=1;') > -1}">
				    <tr>
			            <th><spring:message code='ezPersonal.t399'/></th>
					    <td>
					    <input type="text" name="TextProxyName" id="TextProxyName" value="${textProxyName}" Width="120" ReadOnly />
						    &nbsp;<a class="imgbtn" style="vertical-align:middle"><span onclick="gIsProxyUser = true;select_person('Proxy')"><spring:message code='ezPersonal.t32'/></span></a> 
			                <a class="imgbtn" style="vertical-align:middle"><span onClick="gIsProxyUser = false;document.getElementById('TextProxyName').value=''"><spring:message code='ezPersonal.t33'/></span></a>
					    </td>
				    </tr>
				</c:if>
				<tr>
					<th><spring:message code='ezPersonal.t42'/></th>
					<td>
						<SELECT id="absentreason" onchange="return Sel_Change();"><!-- ezOrgan, ezPersonal 등 resource b1~b12 통일함 -->
							<OPTION selected value="<spring:message code='ezPersonal.t35'/>"></OPTION>
							<OPTION value="b1"><spring:message code='ezPersonal.b1'/></OPTION>
							<OPTION value="b2"><spring:message code='ezPersonal.b2'/></OPTION>
							<OPTION value="b3"><spring:message code='ezPersonal.b3'/></OPTION>
							<OPTION value="b4"><spring:message code='ezPersonal.b4'/></OPTION>
							<OPTION value="b5"><spring:message code='ezPersonal.b5'/></OPTION>
							<OPTION value="b6"><spring:message code='ezPersonal.b6'/></OPTION>
							<OPTION value="b7"><spring:message code='ezPersonal.b7'/></OPTION>
							<OPTION value="b8"><spring:message code='ezPersonal.b8'/></OPTION>
							<OPTION value="b9"><spring:message code='ezPersonal.b9'/></OPTION>
							<OPTION value="b10"><spring:message code='ezPersonal.b10'/></OPTION>
							<OPTION value="b11"><spring:message code='ezPersonal.b11'/></OPTION>
							<OPTION value="b12"><spring:message code='ezPersonal.b12'/></OPTION>
						</SELECT>
					</td>
				</tr>
						</table>
		            <br>
		 
		  <br/>
		  <div style="width:650px;text-align:center">
		    <a class="imgbtn" onClick="OK_Click()"><span><spring:message code='ezPersonal.t34'/></span></a>
		    <a class="imgbtn" onClick="window.location.reload(false)"><span><spring:message code='ezPersonal.t13'/></span></a>
		  </div>
		</form>
	</body>
</html>