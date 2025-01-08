<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<frameset cols="${leftFrameWidth},*" frameborder="0" border="0" frameSpacing="0" id="frameset">
		<frame src="/ezApprovalG/apprGLeft.do?listType=${listType}" name="left" marginwidth="0"	marginheight="0" scrolling="auto" frameborder="0" noresize>
		<frame src="" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
	</frameset>
</html>