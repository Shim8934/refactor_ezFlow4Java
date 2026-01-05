<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <style type="text/css">
	    	.attachedfile {
			    margin: 0;
			}
	    </style>
	    <script type="text/javascript">
	        var nowZoom = 100;
	        var maxZoom = 200;
	        var minZoom = 80;
	        
	        function Bigger() {
                if (nowZoom < maxZoom) {
                    nowZoom += 10;
                } else {
                    return;
                }
                $('.journalPreviewContentIframe').contents().find('.txtContent').css("zoom",nowZoom + "%");
	        }
	
	        function Smaller() {
                if (nowZoom > minZoom) {
                    nowZoom -= 10;
                } else {
                    return;
                }
                $('.journalPreviewContentIframe').contents().find('.txtContent').css("zoom",nowZoom + "%");
	        }
	    </script>
	</head>
	<body>		
		<div class="previewmail">
			<div class="previewmail_info" style="border: none; display: block; width: 100%;">
				<dl class="previewmailDL" id="Preview_HeaderH">
					<dt class="prepic">
						<c:choose>
							<c:when test="${not empty journal.userImage }">
								<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${journal.userImage }" onerror="this.src='/images/kr/main/bestEmployee_pic_none.png'" width="55px" height="55px">
							</c:when>
							<c:otherwise>
								<img src="/images/kr/main/bestEmployee_pic_none.png" width="55px" height="55px">
							</c:otherwise>
						</c:choose>
					</dt>
					<dd class="pretext">
						<ul class="pretextUL">
							<li class="preSubject"><span class="popup_open" id="${journal.journalId}" onclick="goJournalDetail(this);"><img src="/images/kr/cm/btn_newpopup.gif"  title="<spring:message code='ezEmail.t99000001' />" alt="<spring:message code="ezEmail.t99000001" />"></span><span class="subjectText" id="PreH_subject"><span class="subjectText" id="PreH_sub_subject" title="<c:out value='${journal.journalTitle }'/>"><c:out value='${journal.journalTitle }' /></span></span></li>
							<li class="preT_list"><span class="t_left"><span class="cblack"><spring:message code="ezJournal.t34" /></span> : <span id="PreH_MailReceiver" onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style="cursor:pointer" onclick="OpenUserInfo('${journal.writerId}');"><c:out value='${journal.writerName }'/></span></span><span class="t_right"><span class="cblack"><spring:message code="ezJournal.t35" /> : </span><span id="PreH_date"><c:out value='${fn:substring(journal.journalDate, 0, 16) }'/></span></span></li>
							
						</ul>
					</dd>
				</dl>
	        </div>
		</div>
		<iframe src="" class="journalPreviewContentIframe" style="text-align:center; padding:0; width:100%; height:100%; overflow:auto; border:none;"></iframe>
	</body>
</html>