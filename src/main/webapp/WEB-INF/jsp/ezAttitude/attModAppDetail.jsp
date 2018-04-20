<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>근태관리</title>
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
        <link rel="stylesheet" href="/css/ezSchedule/Tab.css" type="text/css" />
        <link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css" type="text/css" >
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/rsa/pidcrypt_util.js"></script>
	    <script type="text/javascript" src="/js/ezSchedule/schedule_write_Cross.js"></script>
		<script type="text/javascript" src="/js/ezSchedule/Calendar/TabMenu.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
		<!-- data picker-->		
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<!-- time picker-->		
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
        <script type="text/javascript">
        	var userId = "${userId}";
	        var writerid = "<c:out value='${data.writerId}'/>";
	        var username = "<c:out value='${data.writerName}'/>";
	        var username2 = "<c:out value='${data.writerName2}'/>";
	        var attid = "<c:out value='${data.attitudeId}'/>";
	        var content = '${data.content}';
	        var contentpath = "${contentPath}";
	        var startDateStringOrgin = "<c:out value='${startDateStringOrgin}'/>";
	        var endDateStringOrgin = "<c:out value='${endDateStringOrgin}'/>";
	        var pageFrom = "<c:out value='${pageFrom}'/>";
	        var timecheckstring = "<spring:message code='ezSchedule.t60' />";
	        var companyID = "<c:out value='${companyID}'/>";
	        var deptName = "<c:out value='${deptName}'/>";
	        var deptID = "<c:out value='${deptID}'/>";
	        var offSetMin = "<c:out value='${offSetMin}'/>";
	        var adminFlag = "<c:out value='${adminFlag}'/>";
		    var timeCheck = false;
		    
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        
		        var doc = document.getElementById('message').contentWindow.document;
				doc.open();
				doc.write(content);
				doc.close();
				
				console.log(writerid);
				console.log(userId);
		    }
		    
		    window.onresize = function () {   	
                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 185 + "PX";
		    }
		    
		    function modify() {
		    	window.location.href = "/ezAttitude/attModAppMod.do?attModId=" + attid;
		    }
		    
		    function del() {
		    	
		    	var obj = new Object();
		    	
		    	obj.idList = attid; 
				
			    $.ajax({
					type : 'post',
				    url : '/ezAttitude/delAttModApp.do',
				    data : obj,
				    dataType : "text",
				    error: function(xhr, status, error){
				    	alert("삭제 중 오류 발생")
				    },
				    success : function(json){
						alert("삭제되었습니다.");
						window.close();
			            try {
			                window.opener.att_refresh();
			            } catch (e) { }
				    }
			    });
		    }
		    
		    function modApprove() { 
		    	var obj = new Object();
		    	
			    obj.idList = attid;
			    obj.changeStatus = "appr";
				
			    $.ajax({
					type : 'post',
				    url : '/ezAttitude/changeAttModApp.do',
				    data : obj,
				    dataType : "text",
				    error: function(xhr, status, error){
				    	ajaxRunning = false;
				    	alert("승인 중 오류 발생")
				    },
				    success : function(json){
				    	alert("승인되었습니다.");
						window.close();
			            try {
			                window.opener.att_refresh();
			            } catch (e) { }
				    }
			    });
		    }
		    
		  	//반려
		    function modReturn() {
				var obj = new Object();
		    	
			    obj.idList = attid;
			    obj.changeStatus = "ret";
				
			    $.ajax({
					type : 'post',
				    url : '/ezAttitude/changeAttModApp.do',
				    data : obj,
				    dataType : "text",
				    error: function(xhr, status, error){
				    	ajaxRunning = false;
				    	alert("반려 중 오류 발생")
				    },
				    success : function(json){
				    	alert("반려되었습니다.");
						window.close();
			            try {
			                window.opener.att_refresh();
			            } catch (e) { }
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
	                            	<c:if test="${adminFlag == 'true'}">
	                            	<li><span onclick="modApprove()">승인</span></li>
	                                <li><span onclick="modReturn()">반려</span></li>
	                            	</c:if>
	                            	<c:if test="${adminFlag == 'true' && userId == data.writerId}">
	                            	<li style="background:none; padding-right:2px; padding-left:3px;" class="off"><img src="/images/i_bar.gif" alt=""></li>
	                            	</c:if>
<!-- 	                            	본인의 수정신청일 경우에만 수정 삭제. 관리자 권환과는 무관-->
	                            	<c:if test="${userId == data.writerId}">
	                            	<li><span onclick="modify()">수정</span></li>
	                            	</c:if>
	                            	<c:if test="${adminFlag == 'true' || userId == data.writerId}">
	                            	<li><span onclick="del()">삭제</span></li>
	                            	</c:if>
	                            </ul>
	                        </div>
	                        <div id="close">
	                            <ul>
	                                <li><span onclick="window.close()"><spring:message code='ezSchedule.t16'/></span></li>
	                            </ul>
	                        </div>
	                    </td>
	                </tr>
	                <tr>
	                    <td style="height: 20px">
	                        <div id="tabShecdule">
	                            <div id="schedule1">
	                                <table class="content">
                                        <tr id="HolderWrite">
                                            <th>구분</th>
                                            <td colspan="2" readonly>
                                            	<c:out value='${data.typeName}' />
<!--                                             	다국어 작업 -->
                                            </td>
                                        </tr>
	                                    <tr>
	                                        <th>기존시각</th>
	                                        <td colspan="2">
	                                        	<c:out value='${data.originDate}' />
	                                        </td>
	                                    </tr>
	                                    <tr id="periodblockTR">
	                                        <th>변경시각</th>
	                                        <td colspan="2">
                                           		<c:out value='${data.changeDate}' />
	                                        </td>
	                                    </tr>
	                                    <tr>
	                                        <th>승인상태</th>
                                        	<c:if test="${data.apprStatus == 0}">
								          		<td colspan="2">진행</td>	
								          	</c:if>
								          	<c:if test="${data.apprStatus == 1}">
								          		<td colspan="2">승인</td>	
								          	</c:if>
								          	<c:if test="${data.apprStatus == 2}">
								          		<td colspan="2">반려</td>	
								          	</c:if>
	                                    </tr>
	                                </table>
	                            </div>
	                        </div>
	                    </td>
	                </tr>
	                <tr>
		                <td class="pad1" style="vertical-align: top; height: 100%" id="messagetd">
		                    <iframe id="message" style="border: #ddd 1px solid; padding-left: 5px; overflow: auto;width: 99.1%; padding-top: 6px; height: 600px; background-color: white"></iframe>	                    
		                </td>
	            	</tr>
	            </table>
	        </div>
	    </form>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>
