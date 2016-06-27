<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript">
	alert("${diviTitle}");
	
	//다른 브라우져에서 .item(1).을 못찾아서 수정
	//window.opener.parent.frames.item(1).location.reload();
	window.opener.parent.frames[1].location = "/admin/ezCommunity/admitCom.do";
	
	self.close();
</script>