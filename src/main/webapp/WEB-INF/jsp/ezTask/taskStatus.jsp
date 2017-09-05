<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html">
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezTask.e2' />" type="text/css">
		<link rel="stylesheet" href="/css/jquery.lineProgressbar.css" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezTask.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezTask/AttachItem_CK.js"></script>
		<script type="text/javascript" src="/js/ezTask/AttachMain_CK.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezTask/jquery.lineProgressbar.js"></script>
		
		<script type="text/javascript">
			var userid = "${userInfo.id }";
	        var taskid = "${taskInfoVO.taskID }";
	        var parentid = "${taskInfoVO.parentID }";
	        var taskstatus = "${taskInfoVO.taskStatus }";
	        var completerate = "${taskInfoVO.completeRate }";
	        var creatorid = "${taskInfoVO.creatorID }";
	        var personid = "${taskInfoVO.personID }";
	        var delayColor = "${delayColor }";
	        var duration = 500;
			/* 필요하면 주석제거하고 하나씩 빼쓰자
	        var importance = "${taskInfoVO.importance }";
	        var personContentpath = "${taskInfoVO.personContentPath }"; */
	        
	        $(document).ready(function() {
	        	initProgressBar(taskstatus, completerate)
	        	
				$("#taskStatus").val(taskstatus);
				$("#completeRate").val(completerate);
	        	
	        	/* 진행상태 변경시 */
	        	$("#taskStatus").change(function() {
					if ($("#taskStatus").val() == "1") {
						$("#completeRate").val("0");
					} else if ($("#taskStatus").val() == "2") {
						if (taskstatus != "4") {
							$("#completeRate").val(completerate);
						}
					} else if ($("#taskStatus").val() == "3") {
						$("#completeRate").val("100");
					}
					
					initProgressBar($("#taskStatus").val(), $("#completeRate").val());
					
					if ($("#taskStatus").val() == 2 || $("#taskStatus").val() == 4) {
						taskstatus = $("#taskStatus").val();
					}
				});
	        	
	        	/* 완료율 변경시 잘안되서 일단 주석*/
	        	$("#completeRate").change(function() {
	        		if ($("#completeRate").val() == "0") {
						$("#taskStatus").val("1");
					} else if ($("#completeRate").val() == "100" && taskstatus != "4") {
						$("#taskStatus").val("3");
					} else {
						if (taskstatus == "2" || taskstatus == "4") {
							$("#taskStatus").val(taskstatus);
						}
					}
				
					initProgressBar($("#taskStatus").val(), $("#completeRate").val());
			    	completerate = $("#completeRate").val();
				});
	        });
	        
	        /* progressBar 조회 */
			function initProgressBar(taskstatus, completerate) {
				if (completerate == '0') {
					duration = 0;
				} else {
					duration = 500;
				}
				
				if (taskstatus == '4') {
					$('#taskProgressBar').LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: delayColor,
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '100%',
						duration : duration
					});
				} else {
					$('#taskProgressBar').LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: '#3498db',
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '100%',
						duration : duration
					});
				}
			}
	        
	        /* 진행상태 저장 스크립트*/
			function taskUpdateInstance() {
				var id = taskid;
				if (parentid != "0") {
				    id = parentid;
				}
				
				$.ajax({
					type : "POST",
					url : "/ezTask/updateTaskStatus.do",
					dataType : "json",
					data : {
						taskID : id,
						taskStatus : $("#taskStatus").val(),
						completeRate : $("#completeRate").val()
					},
					success : function(result) {
						//alert("<spring:message code='ezTask.t150' />");
						
						try { window.opener.RefreshView() } catch (e) { }
						close_onclick();
						parent.initProgressBar($("#taskStatus").val(), $("#completeRate").val());
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
		<div id="main_body">
			<div id="close">
				<ul>
					<li><span onClick="close_onclick()"><spring:message code='ezTask.t9' /></span></li>
				</ul>
			</div>
			
			<div class='txt'>
				<div>▒ <spring:message code = 'ezTask.lhj03' /></div>
				<br/>
				<div>▒ <spring:message code = 'ezTask.lhj04' /></div>
				<br/>
				<div>▒ <spring:message code = 'ezTask.lhj05' /></div>
				<br />
				<div>▒ <spring:message code = 'ezTask.lhj06' /></div>
				<br />
			</div>
			
			
			
			<div id="taskProgressBar"></div>
			
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
						<select id = "taskStatus">
							<option value = "1"><spring:message code="ezTask.t97" /></option>
							<option value = "2"><spring:message code="ezTask.t98" /></option>
							<option value = "3"><spring:message code="ezTask.t99" /></option>
							<option value = "4"><spring:message code="ezTask.t100" /></option>
						</select>
					</td>
				</tr>
			</table>
		</div>
		<div class="btnposition">
	    	<a class="imgbtn" onclick="taskUpdateInstance()"><span><spring:message code='ezTask.t19' /></span></a>
	    	<a class="imgbtn" onclick="close_onclick();"><span><spring:message code='ezTask.t20' /></span></a>
		</div>
	</body>
</html>