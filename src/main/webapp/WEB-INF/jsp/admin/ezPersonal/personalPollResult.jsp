<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t246' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var ReturnFunction;
			$(document).ready(function () {
			    try {
			        ReturnFunction = opener.PollResult_Cross_dialogArguments[1];
			    } catch (e) {}
			});
			
			function close_btn() {
			    if(ReturnFunction!= null)
			        ReturnFunction();
			    window.close();
			}
		</script>
	</head>
	<body class = "popup" style = "overflow:hidden">
		<h1>Quick Poll</h1>
		<div id="close">
			<ul>
				<li><span onClick="close_btn()"><spring:message code = 'ezPersonal.t10' /></span></li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		 
		<table>
			<tr>
		    	<td>
		        	<div class="question" style="overflow-y:auto;width:375px">
			        	<p><spring:message code = 'ezPersonal.t2000' />:</p>
		                <span><c:out value = '${subject}' /></span>
		            </div>
		        </td>
		    </tr>
			<tr style="height:100%">
		    	<td>
	 				<div id="receivelist" style="OVERFLOW-X: hidden; padding:10px;overflow-y:auto;height:225px;width:410px" class="box">
	 					<x:parse var = "resultXML" xml = "${result}"/>
	 					<x:forEach select="$resultXML/DATA/ROW" var="xml">
	 						<span class="txt">
	 							<b><x:out select="$xml/TITLE"/></b>
	 							(<b><x:out select="$xml/COUNT"/></b><spring:message code = 'ezPersonal.t247' /> <span class = "point"><x:out select="$xml/PERCENT"/></span>%)
	 						</span>
	 						<table style="border:1px solid #c9c9c9;width:100%;height:12px;background-image:url(/images/quickpoll_bg.gif);">
	 							<tr>
	 								<c:set var="percent">
	 									<x:out select = '$xml/PERCENT' />
	 								</c:set>
	 								
 									<td style="width:<c:out value='${percent * 4}' />px;background-color:#68bbef"></td>
                                 	<td style="width:<c:out value='${400 - percent * 4}' />px;"></td>
                              	</tr> 
	 						</table>
	 					</x:forEach>
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>