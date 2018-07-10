<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <style type="text/css">
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
		 <span class="previewmail_info" style="border: none; display: block; width: 100%;">
			<div id="Preview_HeaderH" style="text-align:left; border-bottom: 1px solid #e8e8e8; width: 100%;">
	            <p class="mail_title" style="margin-left: 0px;">
	                <span class="icon_btn"><span onclick="goJournalDetail(this);" id="${journal.journalId}" style="cursor: pointer; padding-right: 5px;">
	                    <img src="/images/kr/cm/btn_newpopup.gif" alt="" border="0"></span></span><span id="PreH_subject"><span id="PreH_sub_subject" class="title_blodtxt" title="<c:out value='${journal.journalTitle }'/>"><c:out value='${journal.journalTitle }'/></span></span>
	            </p>
	            <span class="mail_date" style="margin-right: 10px; display: inline-block;"><span id="PreH_date"><c:out value='${fn:substring(journal.journalDate, 0, 16) }'/></span></span>
	            <dl class="mail_item">
	                <dt>게시자:
	                    <span style="display: inline-block"><span onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style="cursor:pointer" onclick="OpenUserInfo('${journal.writerId}');"><c:out value='${journal.writerName }'/></span></span>
	                </dt>
	            </dl>
	        </div>
         </span>
		<iframe src="" class="journalPreviewContentIframe" style="text-align:center; padding:0; width:100%; height:100%; overflow:auto; border:none;">
		</iframe>
	</body>
</html>