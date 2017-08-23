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
			/* 필요하면 주석제거하고 하나씩 빼쓰자
	        var importance = "${taskInfoVO.importance }";
	        var personContentpath = "${taskInfoVO.personContentPath }"; */
	        
	        $(document).ready(function() {
	        	if (taskstatus == '4') {
					$('#taskProgressBar').LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: '#FF0000',
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '100%'
					});
				} else {
					$('#taskProgressBar').LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: '#3498db',
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '100%'
					});
				}
	        	
	        	/* 진행상태 변경시 */
	        	$("#taskStatus").change(function() {
					alert($(this).val());
					alert($(this).children("option:selected").text());
				});
	        	
	        	/* 완료율 변경시 */
	        	$("#completeRate").change(function() {
					alert($(this).val());
					alert($(this).children("option:selected").text());
				});
	        });
	        
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
						alert("<spring:message code='ezTask.t102' />");
						//progressBar refresh시켜야함
					},
					error : function(jqXHR, textStatus, errorThrown) {
						
					}
				});
				
				close_onclick();
	        }
	        
	        function close_onclick() {
	        	parent.DivPopUpHidden();
	        }
		</script>
	</head>
	<body class="popup">
		<div id="main_body">
			<div id="menu">
				<ul>
					<li><span onClick="taskUpdateInstance()"><spring:message code='ezTask.t96' /></span></li>
				</ul>
			</div>
			
			<div id="close">
				<ul>
					<li><span onClick="close_onclick()"><spring:message code='ezTask.t9' /></span></li>
				</ul>
			</div>
			
			<table style="width:100%;">
				<tr>
					<td>
						<div id="taskProgressBar"></div>
					</td>
				</tr>
				<tr>
					<td style = "text-align: center;">
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
						<select id = "taskStatus">
							<option value = "1">시작안함</option>
							<option value = "2">진행중</option>
							<option value = "3">완료</option>
							<option value = "4">지연</option>
						</select>						
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>