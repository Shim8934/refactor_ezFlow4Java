<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/jquery-ui/jquery-ui.min.js"></script>		
<script type="text/javascript" src="/js/jquery.mobile/jquery.mobile-1.4.5.min.js"></script>
<script type="text/javascript" src="/js/mobile/mEMail.js"></script>
<link rel="stylesheet" href="http://code.jquery.com/mobile/1.0/jquery.mobile-1.0.min.css" />
<title>Insert title here</title>
</head>
<body>

	<select id="filter">
		<option value="">모두보기</option>
		<option value="isImportantOnly">중요 메일</option>
		<option value="isUnreadOnly">읽지 않은 메일</option>
	</select>
		
	<table>
      <th>name</th>
      <th>fullName</th>
      <th>unReadCount</th>
      <th>hasSub</th>
      <c:forEach items="${folderList}" var="folder">
        <tr>
          <td><c:out value="${folder.name}" /><td>
          <td><c:out value="${folder.fullName}" /><td>
          <td onclick="getMail('${folder.fullName}')"><c:out value="${folder.unReadCount}" /><td>
          <td onclick="getSubFolder('${folder.fullName}')"><c:out value="${folder.hasSub}" /><td>
        </tr>
      </c:forEach>
    </table>
    <div id="con">
    </div>
</body>
</html>