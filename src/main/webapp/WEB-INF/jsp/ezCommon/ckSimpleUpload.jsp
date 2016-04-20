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
					var fileinfo = "";
					if (strImagePath != undefined && strImagePath != "")
					{
						fileinfo = strImagePath.split("|!|");
				        if (parent.message != null) {
				            if (parent.message.Insert_ImageCmd_Complete != undefined)
				                parent.message.Insert_ImageCmd_Complete(fileinfo);
				            else if (parent.message2 != null && parent.message2.Insert_ImageCmd_Complete != undefined)
				                parent.message2.Insert_ImageCmd_Complete(fileinfo);
				            else
				                parent.message.iframe_content.Insert_ImageCmd_Complete(fileinfo);
				        }
				        else if (parent.tbContentElement != null)
				            parent.tbContentElement.Insert_ImageCmd_Complete(fileinfo);
				
				        window.returnValue = fileinfo;
					} else {
						alert("에러발생");
					}
				};
			</script>
	</head>
</html>
