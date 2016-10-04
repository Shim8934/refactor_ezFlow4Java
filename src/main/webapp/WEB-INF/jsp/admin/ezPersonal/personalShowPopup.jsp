<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t157' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<style type="text/css">
			P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm }
		    .Line {
		        background: url('/images/kr/cm/popup_bg.gif') repeat-x left top;
		    }
		    .Line h1{
				font-size:11pt;
				font-weight:bold;
				color:#fff;
				height:44px;
				margin-left:15px;
				margin-bottom:8px;
				line-height:36px;
		    }
		</style>

		<script type="text/javascript">
			$(document).ready(function() {
				popupcontent.style.height = document.documentElement.clientHeight - 136 + "px";
			});
	
			function setCookie(name, value, expiredays) {
				var todayDate = new Date();
				todayDate.setDate( todayDate.getDate() + expiredays );
				document.cookie = name + "=" + encodeURIComponent( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
			}
	
			function closepopup() {
				setCookie("POPUP_${itemSeq}", "1", 1); 
				window.close();
			}
		</script>
	
	</head>
	<body class = "popup_notice">
		<!--  popup 
				해더 사이즈 : 33px;
		    	bottom 사이즈 : 49px;
				본문 내용 위아래 여백 : 54px;

				총 height 사이즈 : 136px;
		 -->
		<form style="height:100%;">
		<div class="bg_noticeCR">
		    <div class="bg_noticeCL">
		        <div class="bg_noticeTR">
		            <div class="bg_noticeTL">
		                <div class="bg_noticeBR">
		                    <div class="bg_noticeBL">
		                        <div class="popup_noticeLayout">
		                       		<h1><c:out value = '${title}' /></h1>
		                           	<div class="popup_noticeList">
		                            	<dl class="noticeListBox" id="popupcontent"> <!-- 여기 height 값을 바꾸시면 됩니다. -->
		                                	<dt><img src="/images/kr/cm/img_notice.gif" width="68" height="68" alt="공지사항"></dt>
		                                    <dd>${content}</dd>
		                                </dl>
		                            </div>
		                            <div class="notice_btn">
		                            	<p class="btn_checkbox">
		                                    <input type="checkbox" name="checkbox" class="inp_noticeCheck" id="inp_noticeCheck" onClick="closepopup()" /> 
		                                    <label for="inp_noticeCheck"><spring:message code = 'ezPersonal.t267' /></label></p>
		                                <p class="btn_style01"><span onclick=window.close() ><spring:message code = 'ezPersonal.t10' /> </span></p>
		                            </div> 
		                      </div>
		                    </div>	
		                </div>
		            </div>
		        </div>	
		    </div>
		</div>
		</form>
		<!--  //popup -->
	</body>
</html>