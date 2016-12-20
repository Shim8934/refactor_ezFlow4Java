<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<body>
<form name="result" id="result">
    <input type="hidden" name="returnCode" id="returnCode" value="" />
    <script language="javascript" type="text/javascript">
        window.parent.frames.returnvalue("${resultUpload}", "${fileName}", "${fileLocation}", "${fileSize}");        
    </script>
</form>
</body>
</html>