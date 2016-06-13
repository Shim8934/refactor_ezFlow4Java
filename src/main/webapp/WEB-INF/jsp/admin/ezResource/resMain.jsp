<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<frameset cols="200,*" frameborder="no" border="0" framespacing="0">
		<frame src="${crossPage}" name="board_menu" scrolling="auto" marginwidth="0" marginheight="0" frameborder="0" noresize>
        <frame src="gwBoardListManagelistCenter.do" name="board_main" scrolling="auto" marginwidth="0" marginheight="0" frameborder="0">
	</frameset>
	<noframes>
		<body>
		</body>
	</noframes>    
</html>
