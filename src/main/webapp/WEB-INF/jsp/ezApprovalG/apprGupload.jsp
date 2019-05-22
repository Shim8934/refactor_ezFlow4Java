<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<body>
<form name="result" id="result">
    <input type="hidden" name="returnCode" id="returnCode" value="" />
    <script language="javascript" type="text/javascript">
        window.parent.frames.returnvalue("<c:out value='${resultUpload}'/>", "<c:out value='${fileName}'/>", "<c:out value='${fileLocation}'/>", "<c:out value='${fileSize}'/>");        
    </script>
</form>
</body>
</html>