<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('ezAttitude.i1', 'msg')}" type="text/css"/>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
	    <script type="text/javascript">
	    	//var companyId = "<c:out value="${companyId}" />";
	    	var userDeptId;
	    	var userDeptName;
	    
	    	$(document).ready(function(){

   			});
	    	
		</script>
	</head>
	<body class="popup">
	    <h1>
	    	사용내역확인
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table class="content">
			<div class="timecheck_info">
		    	<dl class="timeInfo" style="position:static">
		        	<dt class="timeInfoPic">	
						<img src="/images/kr/main/bestEmployee_pic_none.png" width="48px" height="48px">
<%-- 						<c:choose> --%>
<%-- 							<c:when test="${not empty userInfo.userFileUrl }"> --%>
<%-- 								<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${userInfo.userFileUrl }" width="48px" height="48px"> --%>
<%-- 							</c:when> --%>
<%-- 							<c:otherwise> --%>
<!-- 								<img src="/images/kr/main/bestEmployee_pic_none.png" width="48px" height="48px"> -->
<%-- 							</c:otherwise> --%>
<%-- 						</c:choose> --%>
		        	</dt>
		            <dd class="timeInfoText"><span>${userName }</span><span>${userTitle }</span><span style="color:#aaa9a9">${userDeptName }</span></dd>
		        </dl>
		        <dl class="timeIcconDL">
		        	<dt class="timeIconDT"><img src="/images/ImgIcon/late_icon.png"></dt>
		            <dd class="timeIconDD">지각 <span class="timeCountR" id="FA02">0</span></dd>
		        </dl>
		        <dl class="timeIcconDL">
		        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_day.png"></dt>
		            <dd class="timeIconDD">연차 <span class="timeCountR" id="FA11">0</span></dd>
		        </dl>
		        <dl class="timeIcconDL">
		        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_am.png"></dt>
		            <dd class="timeIconDD">오전반차 <span class="timeCountR" id="FA12">0</span></dd>
		        </dl>
		        <dl class="timeIcconDL">
		        	<dt class="timeIconDT"><img src="/images/ImgIcon/break_pm.png"></dt>
		            <dd class="timeIconDD">오후반차 <span class="timeCountR" id="FA13">0</span></dd>
		        </dl>
		    </div>
	    </table>
	    <br/>
	    <!-- 리스트 -->
		<div style="width: 100%; height: 100%;">
            <table class="mainlist" style="width: 100%;">
                <tr>
                    <th style="width: 50%; padding-left:15px;"><span><spring:message code='ezAttitude.t9' /></span></th>
                    <th style="width: 25%; text-align: center;"><span><spring:message code='ezAttitude.t193' /></span></th>
                    <th style="width: 25%; text-align: center;"><span><spring:message code='ezAttitude.t194' /></span></th>
                </tr>
            </table>
            <div id="contentlist" name="contentlist" style="height: 160px; overflow-y: auto;">
                <table class="mainlist" style="width: 100%;">
                    <tr>
                        <td colspan="3" style="text-align: center;"><spring:message code='ezAttitude.t130' /></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="saveAuthDept();" ><spring:message code='ezAttitude.t16' /></span></a>
	    </div>
	</body>
</html>

