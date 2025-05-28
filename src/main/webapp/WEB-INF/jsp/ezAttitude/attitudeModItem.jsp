<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezAttitude.t28'/></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
        <link rel="stylesheet" href="${util.addVer('/css/ezSchedule/Tab.css')}" type="text/css" />
        <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/pidcrypt_util.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezSchedule/schedule_write_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezSchedule/Calendar/TabMenu.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<!-- data picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
        <script type="text/javascript">
	        var userid = "<c:out value='${data.writerId}'/>";
	        var username = "<c:out value='${data.writerName}'/>";
	        var username2 = "<c:out value='${data.writerName2}'/>";
	        var attid = "<c:out value='${data.attitudeId}'/>";
	        var content = "<c:out value='${data.content}'/>";
	        var contentpath = "${contentPath}";
	        var startDateStringOrgin = "<c:out value='${startDateStringOrgin}'/>";
	        var endDateStringOrgin = "<c:out value='${endDateStringOrgin}'/>";
	        var pageFrom = "<c:out value='${pageFrom}'/>";
	        var timecheckstring = "<spring:message code='ezSchedule.t60' />";
	        var companyID = "<c:out value='${companyID}'/>";
	        var deptName = "<c:out value='${deptName}'/>";
	        var deptID = "<c:out value='${deptID}'/>";
	        var offSetMin = "<c:out value='${offSetMin}'/>";
		    var timeCheck = false;
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		    }
		    
		    window.onresize = function () {   	
                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 200 + "PX";
		    }

		    $(function () {
		        $("#Cdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        
		        $("#Odatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        
				var uploadSDate = "${data.startDate}";
				var sYear = uploadSDate.substring(0, 4);
				var sMonth = uploadSDate.substring(5, 7);
				var sDay = uploadSDate.substring(8, 10);
				var sHour = uploadSDate.substring(11, 13);
				var sMin = uploadSDate.substring(14, 16);

		        var SDate = new Date();
		        SDate.setFullYear(sYear, sMonth-1, sDay);
		        SDate.setHours(sHour, sMin, 0, 0);
		        
		        $("#Cdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Cdatepicker").datepicker('setDate', SDate);
		        $('#Ctimepicker').timepicker();
		        $('#Ctimepicker').timepicker('setTime', SDate);
		        $('#Ctimepicker').timepicker({ 'timeFormat': 'H:i' });
		        
		        var uploadEDate = "${data.startDate}";
				var eYear = uploadEDate.substring(0, 4);
				var eMonth = uploadEDate.substring(5, 7);
				var eDay = uploadEDate.substring(8, 10);
				var eHour = uploadEDate.substring(11, 13);
				var eMin = uploadEDate.substring(14, 16);

		        var EDate = new Date();
		        EDate.setFullYear(eYear, eMonth-1, eDay);
		        EDate.setHours(eHour, eMin, 0, 0);
		        
		        $("#Odatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Odatepicker").datepicker('setDate', EDate);
		        $('#Otimepicker').timepicker();
		        $('#Otimepicker').timepicker('setTime', EDate);
		        $('#Otimepicker').timepicker({ 'timeFormat': 'H:i' });
		    });
		    
		    var monthMsg = "<spring:message code='ezAttitude.t139' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezAttitude.t140' />";
		    var dayStr = dayMsg.split(";");
		    
		    $(function () {
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
		        
		        $("#Cdatepicker").datepicker('disable');
		        $("#Odatepicker").datepicker('disable');
		    });
		    
		    var g_originalHTML = null;
		    function Editor_Complete() {
				message.SetEditorContent('${data.content}');
		    }

		    function save() {
				var obj = new Object();
		    	
			    var cDate = $("#Cdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
			    var cYear = cDate.split("-")[0];
			    var cMonth = cDate.split("-")[1];
			    var cDay = cDate.split("-")[2];
			    var chour, cminute;
			    var ctime = $('#Ctimepicker').val()
			    var oDate = $("#Odatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
			    var oYear = oDate.split("-")[0];
			    var oMonth = oDate.split("-")[1];
			    var oDay = oDate.split("-")[2];
			    var ohour, ominute;
			    var otime = $('#Otimepicker').val() 
			    var timeValid = /^(2[0-3]|[01][0-9]):?([0-5][0-9])$/;
				
			    if ("${data.startDate}".substring(0,10) != cDate && "${data.typeId}" == "A02") {
			    	alert("<spring:message code='ezAttitude.t205'/>");
			    	return;
			    }
			    
			    if (!timeValid.test(ctime) || !timeValid.test(otime)) {
			    	alert("<spring:message code='ezAttitude.t170'/>");
			    	return;
			    }
			    
			    if (ctime == otime) {
			    	alert("<spring:message code='ezAttitude.t80'/>");
			    	return;
			    }
			    
		    	obj.attId = attid;
		    	obj.originDate = oDate + " " + otime + ":00";
		    	obj.changeDate = cDate + " " + ctime + ":00";
		    	obj.content = message.GetEditorContent();
		    	
			    $.ajax({
					type : 'post',
				    url : '/ezAttitude/saveAttModApp.do',
				    data : obj,
				    dataType : "text",
				    error: function(xhr, status, error){
				    	alert("<spring:message code='ezAttitude.t175'/>")
				    },
				    success : function(json){
				    	if(json == "success") {
				    		alert("<spring:message code='ezAttitude.t174'/>");	
				    	} else {
				    		alert("<spring:message code='ezAttitude.t175'/>");
				    	}
			            try {
			            	window.opener.getAttitudeMainList();
			            	//신청갯수 refresh
			            	window.opener.parent.frames["left"].leftCount();
			            } catch (e) { 
// 			            	window.opener.att_refresh();
			            }
			            window.close();
				    }
			    });
		    }
	    </script>
	</head>

	<body class="popup" style="overflow:hidden;">
	    <form method="post">
	        <div id="main_body">
	            <table id="normalScreen" class="layout">
	                <tr>
	                    <td style="height: 20px">
	                        <div id="menu">
	                        	<ul id="menuTable">	
	                                <li class="sel"><h1 style="padding:0px; margin-top:-5px;"><spring:message code='ezAttitude.t28'/></h1></li>
	                            </ul>
	                        </div>
	                        <div id="close">
	                            <ul>
	                                <li><span onclick="window.close()"></span></li>
	                            </ul>
	                        </div>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="height: 20px">
	                        <div id="tabShecdule" style="margin-top:5px">
	                            <div id="schedule1">
	                                <table class="content">
                                        <tr id="HolderWrite">
                                            <th><spring:message code='ezAttitude.t134'/></th>
                                            <td colspan="2" readonly>
                                            	<c:out value='${data.typeName}' />
<!--                                             	다국어 작업 -->
                                            </td>
                                        </tr>
	                                    <tr>
	                                        <th><spring:message code='ezAttitude.t206'/></th>
	                                        <td colspan="2">
	                                        	<input type="text" id="Odatepicker" style="width:80px;text-align:center"><input id="Otimepicker" disabled readonly="readonly" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" />
	                                        </td>
	                                    </tr>
	                                    <tr id="periodblockTR">
	                                        <th><spring:message code='ezAttitude.t207'/></th>
	                                        <td colspan="2">
	                                        	<span id="periodblock">
	                                           		<input type="text" id="Cdatepicker" style="width:80px;text-align:center"><input id="Ctimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" />
	                                            </span>
	                                        </td>
	                                    </tr>
<!-- 	                                    <tr> -->
<!-- 	                                        <th>승인상태</th> -->
<%--                                         	<c:if test="${data.apprStatus == 0}"> --%>
<!-- 								          		<td colspan="2">진행</td>	 -->
<%-- 								          	</c:if> --%>
<%-- 								          	<c:if test="${data.apprStatus == 1}"> --%>
<!-- 								          		<td colspan="2">승인</td>	 -->
<%-- 								          	</c:if> --%>
<%-- 								          	<c:if test="${data.apprStatus == 2}"> --%>
<!-- 								          		<td colspan="2">반려</td>	 -->
<%-- 								          	</c:if> --%>
<!-- 	                                    </tr> -->
	                                </table>
	                            </div>
	                        </div>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="vertical-align:top;height:100%;" id="EdtorSize">
		                    <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding:0; height:100%; width:100%; overflow:auto; margin-top:-1px"></iframe>
	                    </td>
	                </tr>
	            </table>
	            <div class="btnpositionNew" id="menuTable">
					<a class="imgbtn"><span onclick="save()"><spring:message code='ezAttitude.t213'/></span></a>
	            </div>
	        </div>
	        <script type="text/javascript">
		        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 200 + "PX";
		    </script>
	    </form>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>