<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <style type="text/css">
	    	.list {
	    		font-size:12px;
				font-family: 'Gulim', 'arial', 'verdana';
				text-decoration: none;
	    	}
	    </style>
	    <script type="text/javascript">
	        var nowZoom = 100;
	        var maxZoom = 200;
	        var minZoom = 80;
	
	        $(document).ready(function() { 
// 		    	$('.journalPreviewContentIframe').contents().find('body').html('<div style="text-align: left;"><img onclick="parent.Smaller();" style="cursor:pointer; margin:5px;" src="/images/minus.png"> <img onclick="parent.Bigger();" style="cursor:pointer; margin:5px; margin-left:-10px;" src="/images/plus.png"></div><div class="txtContent" id="journalContent" style="width:100%; text-align: center; height:10px;display:inline-block;"></div>');
// 		    	$('.journalPreviewContentIframe').contents().find('#journalContent').html('${journal.journalContent }');
		    	
// 		    	var $head = $(".journalPreviewContentIframe").contents().find("head");

// 		    	$head.append('<style type="text/css">p{margin-top:0px; margin-bottom:0px;}</style>');
	        });
// 	        window.onload = function (){
// // 		    	var journalContent = '<c:out value="${journal.journalContent }" />';
// 		    	$('#message').contents().find('body').html('<div style="text-align: left;"><img onclick="parent.Smaller();" style="cursor:pointer; margin:5px;" src="/images/minus.png"> <img onclick="parent.Bigger();" style="cursor:pointer; margin:5px; margin-left:-10px;" src="/images/plus.png"></div><div id="journalContent" style="height:10px;display:inline-block;"></div>');
// 		    	$('#message').contents().find('#journalContent').html('${journal.journalContent }');
// 		    }
	        
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
		 <span class="previewmail_info" style="display: block; width: 100%;">
			<div style="text-align:left; border-bottom: 1px solid rgb(218, 218, 218); width: 100%;">
	            <p class="mail_title" style="margin-left: 0px;">
	                <span class="icon_btn"><span onclick="goJournalDetail(this);" id="${journal.journalId}" style="cursor: pointer; padding-right: 5px;">
	                    <img src="/images/kr/cm/btn_newpopup.gif" alt="" border="0"></span></span><span id="PreH_subject"><span id="PreH_sub_subject" class="title_blodtxt">${journal.journalTitle }</span></span>
	            </p>
	            <span class="mail_date" style="margin-right: 10px; display: inline-block;"><span id="PreH_date">${journal.journalDate }</span></span>
	            <dl class="mail_item">
	                <dt>게시자:
	                    <span style="display: inline-block"><span onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style="cursor:pointer" onclick="OpenUserInfo('${journal.writerId}');">${journal.writerName }</span></span>
	                </dt>
	            </dl>
	        </div>
         </span>
<!-- 		<div style="overflow: auto; height: 300px;"> -->
			<iframe src="/ezJournal/journalDetailContent.do?journalId=${journal.journalId }" class="journalPreviewContentIframe" style="text-align:center; padding:0; width:100%; height:100%; overflow:auto; border:none;">
			</iframe>
<!-- 			<div style="height:100%; margin-left:5px; margin-right:5px; overflow: auto;"> -->
<!-- 				<div style="text-align: left;"> -->
<!-- 					<img onclick="Smaller();" style="cursor:pointer; margin:5px;" src="/images/minus.png"> -->
<!-- 			        <img onclick="Bigger();" style="cursor:pointer; margin:5px; margin-left:-10px;" src="/images/plus.png"> -->
<!-- 				</div> -->
<!-- 				<div class="txtContent" style="height:10px;display:inline-block;"> -->
<%-- 					${journal.journalContent } --%>
<!-- 				</div>     -->
<!-- 			</div> -->
<!-- 		</div> -->
	</body>
</html>