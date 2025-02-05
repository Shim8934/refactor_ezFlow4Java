<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1">
	</head>
	<frameset rows="0,*" frameborder="0" border="0">
		<frame src="" name="white" marginwidth="0" marginheight="0" scrolling="no" frameborder="0">
			<frameset cols="${leftFrameWidth},*" frameborder="0" border="0" id="frameset">
				<frame src="/ezCabinet/cabinetLeft.do" name="left" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" noresize>
				<frame name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" noresize>
			</frameset>
	</frameset>
</html>
