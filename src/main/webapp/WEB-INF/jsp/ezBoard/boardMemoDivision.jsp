<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezMemo.t0040" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    	<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
    	<link rel="stylesheet" href="/css/Tab.css" type="text/css" />	
    	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	</head>
		<body style="margin-left: 10px; margin-right: 10px;">
			<br/>	
    		<%-- <h2><spring:message code="ezMemo.t0040" /></h2>
    		<span class="txt">▒ <spring:message code="ezMemo.t002" /></span>   
    		<br />
    		<span class="txt">▒ <spring:message code="ezMemo.t003" /></span>
        	<br />
        	<span class="txt">▒ <spring:message code="ezMemo.t004" /></span>
        	<br /> --%>
     
			<div id="mainmenu" style="width: 750px;">
			    <ul>
			        <li style=><span onClick="add_onclick()"><spring:message code='ezMemo.t0027' /></span></li>
			        <li style=><span onClick="modify_onclick()"><spring:message code='ezMemo.t0028' /></span></li>
			        <li style=><span onClick="delete_onclick()"><spring:message code='ezMemo.t0029' /></span></li>
			    </ul>
			</div>
        	<table style="width: 450px; height: 385px;">
		        <tr>
		            <td>
		                <div style="border: 1px solid #dbdbda; border-top:0px; width: 450px; height: 385px; display: inline-table;">
		                    <table class="mainlist" style="width: 100%;">
		                    	<colgroup><col width='7%' /><col width='55%' /><col width='25%' /><col width='13%' /></colgroup>
		                        <tr>
									<th><input id="checkboxAll" type="checkbox" onclick="selectAll()"></th>
		                            <th><spring:message code='ezMemo.t0041' /></th>
		                            <th><spring:message code='ezMemo.t0042' /></th>
		                        	<th></th>
		                        </tr>
		                    </table>
		                    <div id="contentlist" style="height: 365px; overflow-y: auto;">
		                        <table id="memoFolderList" class="mainlist" style="width: 100%;">
		                        </table>
		                    </div>
		                </div>
		            </td>
		        </tr>
		    </table>
		</body>
</html>