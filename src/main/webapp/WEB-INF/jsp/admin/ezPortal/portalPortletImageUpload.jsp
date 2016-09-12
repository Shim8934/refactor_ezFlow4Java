<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
<form name="result" id="result">
    <input type=hidden name="returnCode" id="returnCode" value="" />
    <script language="javascript">
        window.parent.frames.returnvalue("${strXML}");
    </script>
</form>
</body>

</html>