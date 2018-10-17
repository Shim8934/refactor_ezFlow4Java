<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
		<%-- <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script src="${util.addVer('/js/jquery/raphael.2.1.0.min.js')}"></script>
		<script src="${util.addVer('/js/jquery/justgage.1.0.1.min.js')}"></script>	 --%>	
		<script type="text/javascript">
		    
	    var pUserID = "${userInfo.id}";
	    var companyID = "${userInfo.companyID}";
	    var strLang1_NewApprMail = "<spring:message code='main.t00026' />";
	    var mailPercent = "${mailPercent}";
	    
	    function open_mail(url) {
	        var pheight = window.screen.availHeight;
	        var conHeight = pheight * 0.8;
	        var pwidth = window.screen.availWidth;
	        var conWidth = pwidth * 0.8;
	        if (conWidth > 890)
	            conWidth = 890;
	        var pTop = (pheight - conHeight) / 2;
	        var pLeft = (pwidth - 890) / 2;

	        var newwin;
	        var pURI = "/ezEmail/mailRead.do?URL=" + encodeURIComponent(url) + "&PNFlag=N&CONTENTCLASS=";

	        newwin = window.open(pURI, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        newwin.focus();
	        getMailGraph();
	    }
	
	    function Mailmore_btnClick() {
	        window.open("/ezEmail/mailMain.do", "main");
	    }
		    
		</script>
	</head>
<body>
	<div class="layDIV">
        <dl class="portlet_title sortablePortlet">
            <dt class="portletText"><spring:message code='main.t00038' /></dt>
            <dd class="portletPlus" onclick="Mailmore_btnClick()"><img src="/images/kr/main/portlet_Plus.png"></dd>
            <dd class="mailGraph">
                <p class="mGraph"><span id="mGraphSpan"></span></p>
                <span class="mGraph_text" id="UseMailBox">
                ${mailboxDetail }
                <span>${mailboxQuotaStr }</span>
                </span>
            </dd>
        </dl>
		<ul id="MailList" class="portlet_list">
		  <c:choose>
		  	<c:when test="${empty mailList }">
				<dl class='nodata'>
			  	<dt><img src='/images/kr/main/nodata.png'></dt>
			  	<dd>데이터 없음</dd>
				</dl>
		  	</c:when>
			<c:otherwise>
				<c:forEach var="mail" begin="0" end="4" items="${mailList}" varStatus="i">
					<li class="${mail.readClass}" onclick="open_mail('${mail.href}')">
						<span class='txt'>${mail.subject }</span>
						<span class='date'>${mail.receivedDateStr }</span>
						<span class='name'>${mail.sender }</span>
					</li>
				</c:forEach>
			</c:otherwise>
		</c:choose>	     
		</ul>
          	
         <%-- <c:if test="">
          <dl class='nodata'>"
            	<dt><img src='/images/kr/main/nodata.png'></dt>
            	<dd>데이터 없음</dd>
          </dl>
         </c:if> --%>
     </div>
</body>
</html>
