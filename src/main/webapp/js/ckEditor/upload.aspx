<%@ Page Language="C#" AutoEventWireup="true" Inherits="XFREEUpload" CodeFile="upload.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>TSE UPLOAD</title>
		<script type="text/javascript">
			window.onload = function()
			{
				var strImagePath = document.getElementById("divImagePath").value;
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
<body>
    <form id="form1" runat="server">
    <div>
        <input type="hidden" id="divContentType"  runat="server" />
        <input type="hidden" id="divImagePath" runat="server" />
        <br />
    </div>
    </form>
</body>
</html>
