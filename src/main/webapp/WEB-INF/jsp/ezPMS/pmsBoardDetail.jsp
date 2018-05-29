<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css">
	<link rel="stylesheet" href="/css/ezPMS/default/style.min.css" type="text/css" />
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	<script type="text/javascript">
		// 첨부파일 모두 선택
		function attach_SelectAll() {
			var checkboxes = document.getElementById('lstAttachLink').getElementsByTagName("input");
			for(var i = 0; i < checkboxes.length; i++) {
				checkboxes.item(i).checked = true;
			}
		}
		
		function attach_Download() {
			var checkboxes = $("input:checked");
			var i = 0;
			
			if(!checkboxes.length) {
				alert("파일을 선택해주십시오.");
			}
			
			var link = document.createElement('a');
			$(link).attr("display", "none");
			$(link).attr("href", "/ezPMS/downloadFile.do?filePath=" + checkboxes.eq(i).attr("data-filepath") 
													 + "&fileName=" + checkboxes.eq(i).attr("data-filename"));
			link.click();
													 
			var process = setInterval(function() {
				i++;
				
				if(i < checkboxes.length) {
					$(link).attr("href", "/ezPMS/downloadFile.do?filePath=" + checkboxes.eq(i).attr("data-filepath") 
							 + "&fileName=" + checkboxes.eq(i).attr("data-filename"));
					link.click();
				} else {
					clearInterval(process);
				}
			}, 1000);
		}
		
		function deleteBoard() {
			if(confirm("정말 삭제하시겠습니까?") == true) {
				var items = new Array();
				items.push('${board.itemId}');
				opener.deleteBoardAction(items);
			}	
		}
	</script>
</head>
<body class="popup" style="height: 99%;">
	<table class="layout" style="width: 100%">
		<tr>
			<td style="height: 20px">
				<div id="menu">
					<ul>
						<li><span>답변</span></li>
						<li><span>수정</span></li>
						<li><span onclick="deleteBoard()">삭제</span></li>
						<li><span>복사</span></li>
						<li><span>이동</span></li>
						<li><span>메일로 발송</span></li>
						<li><span>조회자 정보</span></li>
						<li><span>인쇄</span></li>
						<li><span>재전송</span></li>
						<li style="float: right;"><span onclick="window.close()">닫기</span></li>
					</ul>
				</div>
			</td>
		</tr>
		<tr>
			<td>
				<table class="content" style="width:100%;">
					<tr>
						<th>게시자</th>
						<td style="width: 50%">${board.writerName}</td>
						<th>부&nbsp;&nbsp;서</th>
						<td>${board.writerDeptName}</td>
					</tr>
					<tr>
						<th>직&nbsp;&nbsp;위</th>
						<td style="width: 50%">${board.writerPosition}</td>
						<th>전화번호</th>
						<td>${board.mobileNumber}</td>
					</tr>
					<tr>
						<th>작업이름</th>
						<td style="width: 50%">
							<c:choose>
								<c:when test="${board.taskName ne null}">
									${board.taskName}
								</c:when>
								<c:otherwise>
									${board.groupName}
								</c:otherwise>
							</c:choose>
						
						</td>
						<th>게시일</th>
						<td>${fn:substring(board.writeDate, 0, 19)}</td>
						
					</tr>
					<tr>
						<th>제&nbsp;&nbsp;목</th>
						<td colspan="3">${board.title}</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td class="pad1" id="pad1" style="vertical-align: top; height: 100%;">
				<div style="padding:0; width:100%; height:100%; overflow:auto; border:1px solid #d1d1d1">
					${board.writeContent}
				</div>
			</td>
		</tr>
		<tr>
			<td style="vertical-align: top; paddin-top: 5px;">
				<table class="file">
					<tr class="pos1">
						<th>첨부파일</th>
						<td>
							<div id="lstAttachLink" style="OVERFLOW: auto; HEIGHT: 50px; background-color: white; text-align: left">
								<c:forEach items="${board.fileList }" var="file">
									<div style="margin-top: 3px; height: 20px">
										<input type="checkbox" data-filename="${file.fileName}" data-filepath="${file.filePath}">
										<img src="/images/${file.fileType}.png"/>&nbsp; 
										<a href="/ezPMS/downloadFile.do?filePath=${file.filePath}&fileName=${file.fileName}">${file.fileName}&nbsp;(${file.fileTransSize})</a>
										<br>
									</div>
								</c:forEach>
							</div>
						</td>
						<td class="pos2" style="white-space: normal; overflow: hidden;">
							<a class="imgbtn"><span style="width: 57px;" onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a>
							<br /> 
							<a class="imgbtn"><span style="width: 57px;" onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>