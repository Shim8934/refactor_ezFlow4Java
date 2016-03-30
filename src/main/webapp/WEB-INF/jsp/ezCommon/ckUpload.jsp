<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			<title>TSE UPLOAD</title>
			<script type="text/javascript">
				window.onload = function()
				{
					var strImagePath = "${imgPath}";
					if (strImagePath != undefined && strImagePath != "")
					{
					    var strLocation = strImagePath;
					    parent.UploadComplete(strLocation);
					} else {
						alert("에러발생");
					}
				};
			</script>
	</head>
</html>
