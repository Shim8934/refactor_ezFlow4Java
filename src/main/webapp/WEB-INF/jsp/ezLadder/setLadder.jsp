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
		<link rel="stylesheet" href="<spring:message code='ezLadder.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			
			
			function makeLadder() {
				var ladData = new Object();
				var ladObj = new Object();
				var ladLineObj = new Object();
				var ladLineArr = new Array();
				
				ladObj.title = $('#title').val();
				ladObj.type = '1';
				
				$('.lineInfo').each(function(index) { // 나중에 진짜 조직도에서 가져온 정보로 바꿔야함
					ladLineObj.userId = $('.userId:eq('+index+')').text();
					ladLineObj.userName = $('.userName:eq('+index+')').text();
					ladLineObj.userName2 = $('.userName2:eq('+index+')').text();
					ladLineObj.item = $('.item:eq('+index+')').text(); 
					ladLineArr.push(ladLineObj);
					ladLineObj = {};
				});
				
				ladData.lineList = ladLineArr;
				ladData.ladInfo = ladObj;
				
				var ladDataStr = JSON.stringify(ladData);
				
				//ladData.title = $('#title').val();
				
				$.ajax({
					type : 'POST',
					url : '/ezLadder/setLadder.do',
					data : { ladData : ladDataStr },
					dataType : 'json',
					success : function(result) {
						console.log('-');
					}
					
				});
				
				/* jQuery.ajaxSettings.traditional = true;
				
				var userId = new Array();
				var userName = new Array();
				var userName2 = new Array();
				var item = new Array();
				
				$('.lineInfo').each(function(index) { // 나중에 진짜 조직도에서 가져온 정보로 바꿔야함
					userId.push($('.userId:eq('+index+')').text());
					userName.push($('.userName:eq('+index+')').text());
					userName2.push($('.userName2:eq('+index+')').text());
					item.push($('.item:eq('+index+')').text());
				});
				
				$.ajax({
					type : 'POST',
					url : '/ezLadder/setLadder.do',
					data : {'title' : $('#title').val(),
							'userId' : userId,
							'userName' : userName,
							'userName2' : userName2,
							'item' : item},
					dataType : 'json',
					success : function(result) {
						console.log(result.testresult);
					}
				}); */
			}
			
			function addUser() { // 조직도 떠서 직원정보 가져오도록 수정
				var html = '';
				
				html += '<div class="lineInfo">';
				html += '<span class="userId">유저id '+$('.lineInfo').length+', </span>';
				html += '<span class="userName">유저이름 '+$('.lineInfo').length+', </span>';
				html += '<span class="userName2">유저이름2 '+$('.lineInfo').length+', </span>';
				html += '<span class="item">아이템 '+$('.lineInfo').length+'</span>';
				html += '</div>';
				
				$('#ladderLineBox').append(html);
				
				
			}

		</script>
	</head>
	<body>
		<table>
			<tr>
				<td><input type="text" id="title" value="제목"></td>
				<td><span id="secretFlag">비밀글</span></td>
			</tr>
			<tr>
				<td><input type="text" id="addUserBox" value="참여자"></td>
				<td>
					<div>
						<span class="type">꽝</span>
						<span class="type">돈</span>
						<span class="type">순서</span>
						<span class="type">직접</span>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2"><span id="lineCnt">선갯수</span></td>
			</tr>
			<tr>
				<td colspan="2">
					<span id="addUserButton" onClick="addUser()">참여자추가</span>
					<div id="ladderLineBox">
					</div>
				</td>
			</tr>
		</table>
		
		<span id="makeLadGame" onClick="makeLadder()"><h3>만들기</h3></span>
		
		
	</body>
</html>