<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">	    
        <script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>        
        <script type="text/javascript" src="<spring:message code='ezSchedule.e1' />"></script>
        <style>
		    .printcontent, .printcontent th, .printcontent td {
			    border-collapse: collapse;
			    empty-cells: show;
			    padding:0;margin:0;
			    font-size:12px;
			    font-family: 'Gulim', 'arial', 'verdana';
		    }
		    .printcontent th{
			    white-space: nowrap;
			    word-break: keep-all;
			    word-wrap: normal;
			    color: #666;
			    background-color:#f3f3f3;
			    border:1px solid #b6b6b6;
			    padding:2px 10px;
		        text-align:center;
		        width:50px;
		    }
		    P { MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm }
		   .printcontent th, .popuplist th{
			height:23px;
		    }
		    .printcontent{border:1px solid #b6b6b6;margin:0;}
		    .printcontent td, .file td, .file2 td, .popuplist td {
			    padding:0px 2px 0px 2px;
			    background: #FFF;
			    border:1px solid #b6b6b6;
			    height:29px;
			    word-break:break-all;			
		    }		
		    .printcontent td {
			    width: 100%;
		    }		
		    .printcontent input { vertical-align:middle;}
		</style>	
		<script>
			function btnPrint_onClick() {
		        window.self.focus();
		        window.self.print();
		    }
	
		    window.onload = function () {
		        var checks = printAttach.getElementsByTagName("input");
		        for (var i = 0; i < checks.length; i++)
		            checks.item(i).style.display = "none";
	
		        var tableColl = printDocument.getElementsByTagName("TABLE");
		        for (var i = 0; i < tableColl.length; i++) {
		            if (String(tableColl.item(i).borderColorDark).toLowerCase() == "#ffffff") {
		                tableColl.item(i).style.borderCollapse = "collapse";
		                tableColl.item(i).borderColorDark = "black";
		            }
		        }
		        btnPrint_onClick();
		    }
		</script>
	</head>	
	<body scroll="auto">
		<div id="printScreen" style="padding-top:10px; padding-left:5px;">
			<table class="printcontent">
				<c:if test="${type == 'NEW'}">
	          	<tr>
	            	<th><spring:message code='ezSchedule.t363' /></th>
	              	<td>
	                	<div id="printOwner">${printOwner}</div>
	              	</td>
	          	</tr>
	          	</c:if>
	          	<c:if test="${type != 'NEW'}">
	            <tr>
	                <th style="white-space:nowrap"><spring:message code='ezSchedule.t161' /></th>
	                <td>
	                    <div id="printCreator">${printCreator}</div>
	                </td>
	            </tr>
	            <tr>
	                <th style="width:80px; white-space:nowrap"><spring:message code='ezSchedule.t306' /></th>
	                <td>
	                    <div>
	                        <div id="printCreateDate">${printCreateDate}</div>                    
	                    </div>
	                </td>
	            </tr>
	          	</c:if>
	          	<c:if test="${printAttendant != ''}">	          
	          	<tr>
	            	<th><spring:message code='ezSchedule.t163' /></th>
	              	<td>
	                	<div id="printAttendant">${printAttendant}</div>
	              	</td>
	          	</tr>
	          	</c:if>
	          	<tr>
	            	<th><spring:message code='ezSchedule.t309' /></th>
	              	<td>
	                	<div id="printIsPublic">${printIsPublic}</div>
	              	</td>
	          	</tr>
	          	<tr>
	            	<th><spring:message code='ezSchedule.t310' /></th>
	              	<td>
	                	<div id="printImportance">${printImportance}</div>
	              	</td>
	          	</tr>
				<tr>
				    <th><spring:message code='ezSchedule.t318' /></th>
				    <td>
				        <div id="printDate">${printDate}</div>
				    </td>
				</tr>
				<tr>
				    <th><spring:message code='ezSchedule.t273' /></th>
				    <td>
				        <div id="printLocation">${printLocation}</div>
				    </td>
				</tr>
				<tr>
				    <th><spring:message code='ezSchedule.t272' /></th>
				    <td>
				        <div id="printTitle">${printTitle}</div>
				    </td>
				</tr>
				<tr>
				    <th><spring:message code='ezSchedule.t319' /></th>
				    <td>
				        <div id="printAttach" style="padding-top:5px; padding-bottom:5px">${printAttach}</div>
				    </td>
				</tr>            
	      	</table>
			<div id="printDocument" style="border:1px solid #b6b6b6; margin-top:2px; padding-right:5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; PADDING-TOP: 5px; WIDTH: 95.7%; position: absolute;font-size:12px;font-family:Gulim">${printDocument}</div>
		</div>
	</body>
</html>