<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><spring:message code="ezTalkGate.ldh002" /></title>
<link rel="stylesheet" href="${util.addVer('/css/ezTalkGate/ktb2b.css')}" type="text/css">
<STYLE> 
P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm }
ul{ list-style-type: circle; }
</STYLE>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/css/ezTalkGate/site.css')}" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="ffffff">
<table width="100%" border="0" cellspacing="0" cellpadding="5" bordercolorlight="#CCCCCC" bordercolordark="#FFFFFF">
  <tr>
    <td id="td_content" style="padding-left:7; padding-right:7; padding-top:15; padding-bottom:10; word-break:break-all; font-size:9pt;">
    ${htmlData}
    </td>
  </tr>
</table>
</body>
</html>