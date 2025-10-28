<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezTask/circularProgressBar.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezTask.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/AttachItem_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/AttachMain_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/circularProgressBar.js')}"></script>
		
		<script type="text/javascript">
			var userid = "<c:out value='${userInfo.id }'/>";
	        var taskid = "<c:out value='${taskInfoVO.taskID }'/>";
	        var taskstatus = "<c:out value='${taskInfoVO.taskStatus }'/>";
	        var completerate = "<c:out value='${taskInfoVO.completeRate }'/>";
	        var creatorid = "<c:out value='${taskInfoVO.creatorID }'/>";
	        var personid = "<c:out value='${taskInfoVO.personID }'/>";
	        var delayColor = "<c:out value='${delayColor }'/>";
	        var completeColor = "<c:out value='${completeColor }'/>";	
	        var tasktype = "<c:out value = '${taskInfoVO.taskType}' />";
	        var repeatCount = "<c:out value = '${repeatCount}' />";
	        var realDate = "<c:out value = '${realDate}' />";
	        var duration = 500;
			/* 필요 시 주석 제거 후 사용
	        var importance = "${taskInfoVO.importance }";
	        var personContentpath = "${taskInfoVO.personContentPath }"; */
	        
	        $(document).ready(function() {
	        	
	        	initProgressBar(completerate);	        	        	
        	
	        	if (taskstatus == '1') {
// 	        		$("#taskStatus").attr("disabled", true);
	        	} else if (taskstatus == '2') {
	        		$("#taskStatus").attr("checked", false);
	        	} else if (taskstatus == '3') {	        		
	        		$("#taskStatus").attr("disabled", true);
	        	} else if (taskstatus == '4') {
	        		$("#taskStatus").attr("checked", true);
	        	}
	        	
	        	/* 18-05-03 김민성 - 완료율 0% 지연여부 체크 비활성화 */
	        	if (completerate == '0' || completerate == '100') {
	        		$("#taskStatus").attr("disabled", true);
	        	}
				
				$("#completeRate").val(completerate);
	        	
	        	/* 진행상태 변경시 */
	        	$("#taskStatus").change(function() {
					if ($("#taskStatus").is(":checked")) {
						taskstatus = 4;
					} else {
						taskstatus = 2;
					}
					
					initProgressBar($("#completeRate").val());
				});
	        	
	        	/* 완료율 변경시 잘안되서 일단 주석*/
	        	$("#completeRate").change(function() {
	        		if ($("#taskStatus").is(":checked")) {
	        			if ($("#completeRate").val() == "0") {
							$("#taskStatus").attr("checked", false);
 							$("#taskStatus").attr("disabled", true);
	        				taskstatus = 1;
						} else if ($("#completeRate").val() == "100") {
							$("#taskStatus").attr("checked", false);
							$("#taskStatus").attr("disabled", true);
							taskstatus = 3;
						} else {
							taskstatus = 4;
							$("#taskStatus").removeAttr("disabled");
						}
	        		} else {			
	        			//지연안된거
	        			if ($("#completeRate").val() == "0") {
	        				$("#taskStatus").removeAttr("disabled");
 	        				$("#taskStatus").attr("disabled", true);
	        				taskstatus = 1;
						} else if ($("#completeRate").val() == "100") {
							$("#taskStatus").attr("disabled", true);
							taskstatus = 3;
						} else {
							$("#taskStatus").removeAttr("disabled");
							taskstatus = 2;
						}
	        		}
	        		
					initProgressBar($("#completeRate").val());
			    	completerate = $("#completeRate").val();
				});
	        });
	        
	        /* progressBar 조회 */
	        /* 2018-04-24 김민성 - 업무 완료율 100%시 색상 조정 */
			function initProgressBar(completerate) {
				if (taskstatus == '4') {
					$('.taskProgressBar').circleProgress({
						value: ((completerate*1) / 100),
						fill: {color: delayColor},
						size: 135
					}).on('circle-animation-progress', function(event, progress) {
						$(this).find('strong').html(completerate + '%');
						if (completerate == 0) {
							$(this).find('strong').css("color", delayColor);
						} else {
							$(this).find('strong').css("color", "");
						}
					});
				} else if (taskstatus == '3' || completerate == '100') {
					$('.taskProgressBar').circleProgress({
						value: ((completerate*1) / 100),
						fill: {color: completeColor},
						size: 135
					}).on('circle-animation-progress', function(event, progress) {
						$(this).find('strong').html(completerate + '%');
						$(this).find('strong').css("color", "");
					});
				} else {
					$('.taskProgressBar').circleProgress({
						value: ((completerate*1) / 100),
						fill: {color: '#3498db'},
						size: 135
					}).on('circle-animation-progress', function(event, progress) {
						$(this).find('strong').html(completerate + '%');
						$(this).find('strong').css("color", "");
					});
				}
			}
	        
	        /* 진행상태 저장 스크립트*/
			function taskUpdateInstance() {
				$.ajax({
					type : "POST",
					url : "/ezTask/updateTaskStatus.do",
					dataType : "json",
					data : {
						taskID : taskid,
						taskStatus : taskstatus,
						completeRate : completerate,
						tasktype : tasktype,
						repeatCount	 : repeatCount,
						realDate : realDate
					},
					success : function(result) {
						alert("<spring:message code='ezTask.t150' />");
						
						try { window.opener.RefreshView() } catch (e) { }
						close_onclick();
						parent.initProgressBar(taskstatus, $("#completeRate").val());
						
						if(tasktype == "4" || tasktype == "5" || tasktype == "6") {
							parent.updateStatusOnce(taskstatus, realDate);
						}
						
						parent.RefreshView();
					},
					error : function(jqXHR, textStatus, errorThrown) {
						
					}
				});
	        }
	        
	        function close_onclick() {
	        	parent.DivPopUpHidden();
	        }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezTask.lhj01' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="close_onclick()"></span></li>
            </ul>
        </div>
		<div id="main_body">
			<div class='txt'>
				<div style="margin-top:7px;">▒ <spring:message code = 'ezTask.lhj03' /></div>
				<div style="margin-top:7px;">▒ <spring:message code = 'ezTask.lhj04' /></div>
				<div style="margin-top:7px;">▒ <spring:message code = 'ezTask.lhj05' /></div>
			</div>			
			<br />			
			<div class="circles" style="text-align: center;">
				<div class="taskProgressBar circle">
					<strong></strong>
				</div>
			</div>			
			<br />				
			<table class="content" style="width:100%;">
				<tr>
					<th>
						<spring:message code = 'ezTask.t120' />
					</th>
					<td>
						<select id = "completeRate">
							<option value = "0">0%</option>
							<option value = "10">10%</option>
							<option value = "20">20%</option>
							<option value = "30">30%</option>
							<option value = "40">40%</option>
							<option value = "50">50%</option>
							<option value = "60">60%</option>
							<option value = "70">70%</option>
							<option value = "80">80%</option>
							<option value = "90">90%</option>
							<option value = "100">100%</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>
						<spring:message code = 'ezTask.t164' />
					</th>
					<td>
						<%-- <checkbox id = "taskStatus"> --%>
						<div class="custom_checkbox">
							<input type="checkbox" id="taskStatus" />
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="btnposition btnpositionNew">
	    	<a class="imgbtn" onclick="taskUpdateInstance()"><span><spring:message code='ezTask.t19' /></span></a>
		</div>
	</body>
</html>