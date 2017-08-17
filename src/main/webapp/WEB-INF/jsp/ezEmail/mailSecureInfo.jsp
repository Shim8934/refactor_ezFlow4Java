<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css">
		<title>보안정보</title>
		<script type="text/javascript" src="/js/ezEmail/lang/ezEmail_ko.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/string_component.js"></script>
		<script type="text/javascript" src="/js/ezEmail/Controls_cross/datepicker.htc.js"></script>
		<script type="text/javascript" src="/js/ezEmail/Controls_cross/composeappt.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<!-- data picker-->
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<!-- time picker-->
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<script type="text/javascript">
			var offsetMin = "${offsetMin}";
		    
		    function confirm() {
		    	parent.DivPopUpHidden();
		    }
		</script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1>보안정보</h1>
		<span>※ 보낸편지함에서 해당 보안메일을 삭제하면 열람 불가능합니다.</span><br/>
		<br/>
		
		<h2>보안정보</h2>
		<table style="width:100%;" class="content">
		  <tr>
		    <th>보안메일 암호</th>
		    <td>${secureInfo.password}</td>
		  </tr>
		  <tr>
		    <th>열람 허용 횟수</th>
	    	<c:if test="${secureInfo.maxReadCount == '0'}">
	    		<td>무제한</td>
	    	</c:if>
		    <c:if test="${secureInfo.maxReadCount != '0'}">
	    		<td>${secureInfo.maxReadCount}회</td>
	    	</c:if>
		  </tr>
		  <tr>
		  	<th>열람 허용 기간</th>
		  	<c:if test="${secureInfo.maxReadDate == null}">
	    		<td>무제한</td>
	    	</c:if>
		    <c:if test="${secureInfo.maxReadDate != null}">
	    		<td>${secureInfo.maxReadDate} 까지</td>
	    	</c:if>
		  </tr>
		</table>
		<br/>
		
		<h2>수신자별 열람정보</h2>
		<table style="width:100%;">
		  <tr>
			<th>수신자</th>
			<th width="60px">열람 횟수</th>
			<th width="150px">최근 열람 시각</th>
		  </tr>
		</table>
		
		<div style="width:100%;height:200px;overflow-y:scroll;margin:0;padding:0;border-left:1px solid #b6b6b6;border-bottom:1px solid #b6b6b6;">
			<table style="width:100%;text-align:center">
				<c:forEach var="vo" items="${secureReaderList}">
					<tr>
						<td>${vo.reader}</td>
						<td width="60px">${vo.readCount}</td>
						<td width="150px">${vo.readDate}</td>
					</tr>
				</c:forEach>
			</table>
		</div>
		
		<div class="btnposition">
		   <a class="imgbtn" onClick="confirm()" ><span>확인</span></a>
		</div>
	</body>
</html>