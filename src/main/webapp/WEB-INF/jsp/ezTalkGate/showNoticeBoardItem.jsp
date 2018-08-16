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
</STYLE>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/css/ezTalkGate/site.css')}" type="text/css">
</head>
<body class="popup">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" style="position: fixed;" >
  <tr height="43px">
    <td height="43px" valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="43px">
        <tr>
          <td width="14" height="43" background="/images/ezTalkGate/left_top.gif"></td>
          <td background="/images/ezTalkGate/message_top_bg.gif" valign="bottom">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" height="38px">
              <tr>
                <td valign="top" background="/images/ezTalkGate/title_notice.gif" style="background-repeat:no-repeat; padding-left:48px; padding-top:13px; font-weight:bold; color:#20407D" ><spring:message code="ezBoard.t483" /> </td>
                <td width="40" align=center onClick="javascript:window.close()" style="cursor:hand; color:#20407D" onmouseover="this.style.color='#CB5000'" onmouseout="this.style.color='#20407D'" ><spring:message code="ezBoard.t12" /></td>
              </tr>
          	</table>
          </td>
          <td width="14"><img src="/images/ezTalkGate/right_top.gif" width="14" height="43px"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr height="*">
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%" style="position: relative;">
        <tr>
          <td width="14"><img src="/images/ezTalkGate/left_bg.gif" width="14" height="102%"></td>
          <td valign="top" style="border:1px solid #596FA1; padding:3px" style="position: relative;" >
	          <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="3">
			    <tr height="40">
	              <td colspan="4" bgcolor="#E8EDF9" style="border:1px solid #A7BAE4" >&nbsp;<b><spring:message code="ezEmail.t556" /> : <c:out value='${boardItem.title}' /></b></td>
	            </tr>
	            <tr height="1">
	              <td colspan="4" bgcolor="#ffffff"></td>
	            </tr>
	            <tr valign="middle" bgcolor="#F5F5F5" height="25">
	              <td width="150">&nbsp;<spring:message code="ezBoard.t223" /> | <c:out value='${boardItem.writerName}' /><font color="#333399"></font></td>
	              <td align="center" width="150"><spring:message code="ezBoard.t5007" /> | <c:out value='${boardItem.writeDate}' /><font color="#333399"></font> </td>
	              <td width="150" align="center" style="display:none"><spring:message code="ezCommunity.t173" /> | <font color="#333399"></font></td>
	              <td align="center">&nbsp;</td>
	            </tr>
	            <tr height="1">
	              <td colspan="4" bgcolor="#D0D0D0"></td>
	            </tr>
	            <tr height="*">
	              <td colspan="4" bgcolor="#ffffff" width="100%" valign="top">             
	                <iframe id=iframeWin SCROLLING=auto src="showNoticeBoardItemContent.do?itemId=${boardItem.itemID}&href=${boardItem.contentLocation}" 
	                	width="100%" height="100%" FRAMEBORDER=0></iframe>
	              </td>
	            </tr>
	          </table>
          </td>
          <td width="14"><img src="/images/ezTalkGate/right_bg2.jpg" width="14" height="102%"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr height="8px" style="position: relative;"> 
    <td height="8px"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td background="/images/ezTalkGate/chat_bottom_left.jpg" style="background-position:left bottom" width="27" height="8"></td>
          <td align="right" valign="bottom" background="/images/ezTalkGate/chat_bottombg.jpg" style="background-position:bottom">&nbsp;</td>
          <td background="/images/ezTalkGate/chat_bottom_right.jpg" width="27"  style="background-position:right bottom"></td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>