<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">
		<script type="text/javascript">
		   	document.onselectstart = function () { return false; };
		   	
			window.onload = window_onload_Newside;
		    
		    function window_onload_Newside() {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }

		        try { top.onresize() } catch (e) { }
		    }
		    
		    function OpenUserInfo(pUserID) {
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 500) / 2;
		        var top = (heigth - 400) / 2;
		        window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		    }
		</script>
	</head>
	<body>
		<article class="bestEmployee">
        	<p class="emPic"><img src="${filePath}"></p>
            <dl class="emDL">
            	<dt class="emTit"><spring:message code='main.t68' /></dt>
                <dd class="emName">"${displayName}<c:if test="${title != ''}"> ${title}</c:if>"</dd>
                <dd class="emTeam">${description}</dd>
            </dl>
        </article>
		
		<%-- <section  class="body_bg1">
    		<article class="portlet_side">
        		<p class="title"><img src="/images/<spring:message code='main.t00025' />/main/side_title.gif" alt=""></p>
        		<div class="event"><img src="/images/<spring:message code='main.t00025' />/main/event.gif" width="155" height="179"></div>
        		<c:choose>
        			<c:when test="${result != null && result != ''}">
        				<div class="best">
        					<dl>
        						<dt><span class="icon"><img src="/images/<spring:message code='main.t00025' />/main/icon_best1.png" width="32" height="32"></span><spring:message code='main.t68' /></dt>
        						<dd class="photo"><img src="${filePath}" width="75" height="77"></dd>
        						<dd class="txt_name">
            						<span style="cursor:pointer" onclick="OpenUserInfo('${result.cn}')">
                						${displayName}
            						</span>
        						</dd>
        						<dd class="txt_part">${description}</dd>
        					</dl>
        				</div>
        			</c:when>
        			<c:otherwise>
        				<div class="best">
        					<dl>
        						<dt><span class="icon"><img src="/images/<spring:message code='main.t00025' />/main/icon_best1.png" width="26" height="28"></span><spring:message code='main.t68' /></dt>
        						<dd class="photo" style='margin-top:10px'><img src="/images/default_pic.png" width="61" height="64"></dd>
        						<dd class="txt_name"></dd>
        						<dd class="txt_part" style='margin-top:20px;font-weight: bold;color:#d0d0d0'><spring:message code='main.t00026' /></dd>        						
        					</dl>
        				</div>
        			</c:otherwise>
        		</c:choose>
    		</article>
		</section> --%>
	</body>
</html>