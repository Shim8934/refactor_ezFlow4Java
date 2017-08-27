<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<frameset rows="0,*" frameborder="0" border="0">
		<frame src="<spring:message code='main.kms4' />" name="white" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" />
	    <frameset cols="220,*" frameborder="0" border="0">
		    <frame src="/ezSchedule/scheduleLeft.do?funCode=${funCode}&subfunction=${subCode}" name="left" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" noresize />
            <frame src="<spring:message code='main.kms4' />" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" noresize />
	    </frameset>
    </frameset>
</html>