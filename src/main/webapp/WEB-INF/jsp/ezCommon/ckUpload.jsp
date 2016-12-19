<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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
