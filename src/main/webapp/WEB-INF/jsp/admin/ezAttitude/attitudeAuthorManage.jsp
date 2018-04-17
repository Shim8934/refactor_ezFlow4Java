<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="<spring:message code='ezSchedule.e3' />" type="text/css" />
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css" />		
		<script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>	    
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>		
	    <script type="text/javascript">			
// 			document.onselectstart = function () {
// 	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
// 	            return false;
// 	        else
// 	            return true;
// 			};
			
	        window.onload = function() {
	           
	        }
		</script>
	</head>
	<body class="mainbody">
	    <h1>근태권한관리</h1>
	    <div id="mainmenu">
		    <ul>
		        <li><span onClick="author_new()">권한추가</span></li>
		        <li><span onClick="author_delete()">권한삭제</span></li>
		    </ul>
		</div>
	    <br />
	    <table style="width: 750px; height: 385px;" >
            <tr>
                <td>
                    <div style="border: 1px solid #dbdbda;border-top:0px; width: 750px; height: 396px;">
                        <table class="mainlist" style="width: 100%;">
                            <tr>
                                <th style="width: 38%;"><span><spring:message code='ezSchedule.t999' /></span></th>
                                <th style="width: 32%;"><span><spring:message code='ezSchedule.t12' /></span></th>
                                <th style="width: 30%;"><span><spring:message code='ezSchedule.t205' /><spring:message code='ezSchedule.t12' /></span></th>
                            </tr>
                        </table>
                        <div id="contentlist" name="contentlist" style="height: 365px; overflow-y: auto;">
                            <table class="mainlist" style="width: 100%;">
                                <tr>
                                    <td style="text-align: center;">
                                        <img src="/images/email/progress_img.gif" />
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
</html>

