<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>업무관리기본설정</title>
		<link rel="stylesheet" href="<spring:message code='ezTask.e2' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
			function save_info() {
				var listCount = $("#listcount").val();
				var selectTaskStatus = $("#selectTaskStatus").val();

				$.ajax({
					type : "POST",
					url : "/ezTask/taskSaveGeneral.do",
					dataType : "json",
					data : {
						listCount : listCount,
						selectTaskStatus : selectTaskStatus
					},
					success : function() {
						alert("<spring:message code='ezTask.t89' />");
					},
					error : function() {
						alert("<spring:message code='ezTask.t992' />");
					}
				});
			}
		</script>
	</head>
	
	<body style="margin-left:10px;overflow:hidden;">
		<form method="post" runat="server">
			<br />
			<h2 class="h2_dot">리스트 개수와 업무관리에서 보이는 기본 탭을 선택할 수 있습니다.</h2> 
			<p>
			<table class="content" style="width:240px;margin-left:15px;">
				<tr>
                	<th>리스트개수</th>
                		<td>
                    		<select id="listcount" name="pListCount" style="WIDTH: 100px">
                				<option value='10' ${taskGeneralVO.listCount == '10' ? 'selected' : ''}>10</option>
								<option value='20' ${taskGeneralVO.listCount == '20' ? 'selected' : ''}>20</option>
                      			<option value='30' ${taskGeneralVO.listCount == '30' ? 'selected' : ''}>30</option>
                      			<option value='40' ${taskGeneralVO.listCount == '40' ? 'selected' : ''}>40</option>
                      			<option value='50' ${taskGeneralVO.listCount == '50' ? 'selected' : ''}>50</option>
                   			</select>
                    	개
                    	</td>
            	</tr>
            	<tr>
                	<th>업무구분</th>
                		<td>
                			<select id="selectTaskStatus" name="pSelectTask" style="WIDTH: 100px">
                				<option value="taskprog" ${taskGeneralVO.selectTaskStatus == 'taskprog' ? 'selected' : ''}><spring:message code='ezTask.t2007' /></option>
                				<option value="taskdictate" ${taskGeneralVO.selectTaskStatus == 'taskdictate' ? 'selected' : ''}><spring:message code='ezTask.t2008' /></option>
                			</select>
                		</td>
            	</tr>
			</table>
			<br />
			<div align="center" style="width:265px;">
				<a class="imgbtn" onClick="save_info()"><span><spring:message code='ezTask.t96' /></span></a>
				<a class="imgbtn" onClick="window.location.reload(false)"><span><spring:message code='ezTask.t20' /></span></a>
			</div>
		</form>
	</body>
</html>