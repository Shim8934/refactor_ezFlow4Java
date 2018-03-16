<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code="ezLadder.t009" /></title>
		<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css">
		<link rel="stylesheet" href="<spring:message code='ezLadder.e2' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezLadder/string_component.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladderSetting.js"></script>
		<script type="text/javascript" src="/js/ezLadder/ladder.js"></script>
		
		<style type="text/css">
			td, tr {
				border: 1px solid gray;
			}
		
		</style>
		
		<script type="text/javascript">
			var ret_value;
			var ret_func;
			var ret_group = [];
			var ret_user = [];
			
			$(function() {
				try {
					ret_value = parent.ladder_add_bmuser_dialogArguments[0];
					ret_func = parent.ladder_add_bmuser_dialogArguments[1];
				} catch (e) {
	                try {
	                	ret_value = opener.ladder_add_bmuser_dialogArguments[0];
						ret_func = opener.ladder_add_bmuser_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
				
				init_setting();
				
				$("#setBMgroup").on("click", function() {
					console.log("set");
					ret_group = ["add", "0", $("#bmname").val()];
					ret_user = [ret_value["id"], ret_value["name"], ret_value["name2"]];
					ret_func(ret_group, ret_user);
					
					parent.DivPopUpHidden();	
				});
				
				$("#popupclose").on("click", function() {
					console.log("close");
					ret_group[0] = "cancle";
					ret_func(ret_group);
					
					parent.DivPopUpHidden();
					
				});
			});	
			
			function init_setting() {
				console.log("init");
				
				var html = "";
				var len = ret_value["id"].length;
				
				for(var i = 0; i < len; i++) {
					html += "<tr>";
					html += "<td>" + ret_value["name"][i] + "</td>";
					html += "<td>" + ret_value["deptname"][i] + "</td>";
					html += "</tr>";
				}
				
				$("#userlist").append(html);
			}
		</script>
		
		<title>BM Group name popup</title>
	</head>
	<body class="popup">
		<h1 id="h1Title" style="height: 20px;">사다리 즐겨찾기 그룹 추가</h1>
		<div class="wrap">
			<table>
				<thead>
					<tr>
						<td>이름</td>
						<td>부서</td>
					</tr>
				</thead>
				<tbody id="userlist">
					<tr>
						<td><input type="text" id="bmname" /></td>
					</tr>
				</tbody>
			</table>
			<div id="setBMgroup" style="display: inline-block; padding: 20px; border: 1px solid black">등록버튼</div>
			<div id="popupclose" style="display: inline-block; padding: 20px; border: 1px solid black">취소버튼</div>
		</div>
	</body>
</html>