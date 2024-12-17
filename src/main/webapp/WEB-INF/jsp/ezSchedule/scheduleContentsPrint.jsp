<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">	 
		<title><spring:message code='ezApprovalG.pjj03'/></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
        <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>        
        <script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
        <style>
		    .printcontent, .printcontent th, .printcontent td {
			    border-collapse: collapse;
			    empty-cells: show;
			    padding:0;margin:0;
			    font-size:12px;
		    }
		    .printcontent th{
			    white-space: nowrap;
			    word-break: keep-all;
			    word-wrap: normal;
			    color: #666;
			    background-color:#f8f8f8;
			    border:1px solid #ddd;
			    padding:2px 10px;
		        text-align:center;
		        width:50px;
		    }
		    P { MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm }
		   .printcontent th, .popuplist th{
			height:23px;
		    }
		    .printcontent{border:1px solid #ddd;margin:0;}
		    .printcontent td, .file td, .file2 td, .popuplist td {
			    padding:0px 2px 0px 2px;
			    background: #FFF;
			    border:1px solid #ddd;
			    height:29px;
			    word-break:break-all;			
		    }		
		    .printcontent input { vertical-align:middle;}
		    .printdocument{
		     	border:1px solid #ddd;
		     	margin:10px 0px 10px 0px;
		     	padding:10px 10px 5px 10px; 
		     	line-height:1.3;
		     	min-height:362px; 
		     	font-size:12px;
		    }
		    //
		    /* 2018-08-09 김보미 - 테이블 중앙정렬 */
			th { width:10%; text-align: center; }
			td { width:40%; }
		</style>	
		<script>
			//2018-08-09 김보미 - 일본어시에 폰트 다르게
			var locale = "<c:out value = '${locale}' />";
			 
			function btnPrint_onClick() {
		        window.self.focus();
		        window.self.print();
		    }
	
		    window.onload = function () {
		    	//2018-08-09 김보미 - 일본어시에 폰트 다르게
		    	var font = "malgun gothic, arial, verdana";
		    	if (locale == "ja") {
		    		font = "Meiryo UI, ＭＳ Ｐゴシック, Arial, Helvetica, sans-serif";
		    	}
				document.getElementsByClassName("printcontent")[0].style.fontFamily = font;

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
		<div id="printScreen" style="padding:10px 10px 10px 10px;">
			<table class="printcontent" style="width:100%;">
				<c:if test="${type == 'NEW'}">
	          	<tr>
	          		<!-- 2018-08-09 김보미 - 테이블 중앙정렬 위해 width값 제거 -->
<%-- 	            <th style="min-width:49px;"><spring:message code='ezSchedule.t363' /></th> --%>
	            	<th><spring:message code='ezSchedule.t363' /></th>
<!-- 	            <td style="width:280px;"> -->
	              	<td>
	                	<div id="printOwner" style="min-width:280px;"><c:out value='${printOwner}'/></div>
	              	</td>
<%-- 	            <th style="min-width:49px; white-space:nowrap"><spring:message code='ezSchedule.jjh06' /></th> --%>
	              	<th style="white-space:nowrap"><spring:message code='ezSchedule.jjh06' /></th>
<!-- 	            <td  style="width:100%;"> -->
	                <td>
	                    <div id="printCreateDate" style="min-width:260px;"><c:out value='${printCreateDate}'/></div>                    
	                </td>
	          	</tr>
	          	</c:if>
	          	<c:if test="${type != 'NEW'}">
	            <tr>
<%-- 	            <th style="min-width:49px; white-space:nowrap"><spring:message code='ezSchedule.jjh05' /></th> --%>
	                <th style="white-space:nowrap"><spring:message code='ezSchedule.jjh05' /></th>
<!-- 	            <td style="width:280px;"> -->
	                <td>
	                    <div id="printCreator" style="min-width:280px;"><c:out value='${printCreator}'/></div>
	                </td>
<%-- 	            <th style="min-width:49px; white-space:nowrap"><spring:message code='ezSchedule.jjh06' /></th> --%>
	                <th style="white-space:nowrap"><spring:message code='ezSchedule.jjh06' /></th>
<!-- 	            <td style="width:100%;"> -->
	                <td>
	                    <div id="printCreateDate" style="min-width:260px;"><c:out value='${printCreateDate}'/></div>                    
	                </td>
	            </tr>
	          	</c:if>
	          	<tr>
	            	<th><spring:message code='ezSchedule.t309' /></th>
	              	<td>
	                	<div id="printIsPublic"><c:out value='${printIsPublic}'/></div>
	              	</td>
	              	<th><spring:message code='ezSchedule.jjh07' /></th>
	              	<td>
	                	<div id="printImportance"><c:out value='${printImportance}'/></div>
	              	</td>
	          	</tr>
	          	<c:if test="${printAttendant != ''}">	          
	          	<tr>
	            	<th><spring:message code='ezSchedule.t311' /></th>
	              	<td colspan="3">
	                	<div id="printAttendant" style="padding:2px 0px;"><c:out value='${printAttendant}'/></div>
	              	</td>
	          	</tr>
	          	</c:if>
				<tr>
				    <th><spring:message code='ezSchedule.t312' /></th>
				    <td>
				        <div id="printDate"><c:out value='${printDate}'/></div>
				    </td>
				    <th><spring:message code='ezSchedule.t313' /></th>
				    <td>
				    	<!-- 2018-07-09 김보미 - 태그적용 막기 -->
						<%-- <div id="printLocation">${printLocation}</div> --%>
						<div id="printTitle"><c:out value="${printLocation}" /></div>
				   </td>
				</tr>
				<tr>
				    <th><spring:message code='ezSchedule.t314' /></th>
				    <td colspan="3">
				        <div id="printTitle"><c:out value="${printTitle} " escapeXml="true" /></div>
				    </td>
				</tr>
			</table>
			
			<table class="printcontent" style="width:100%; border:0;">
				<tr>
					<td style="border:0; padding:0; width:100%;">
						<div class= "printdocument" id="printDocument">${printDocument}</div>
					</td>
				</tr>
			</table>
			
			<table class="printcontent" style="width:100%;">
				<tr>
				    <th><spring:message code='ezSchedule.t316' /></th>
				    <td style="width:100%;">
				        <div id="printAttach" style="padding-top:5px; padding-bottom:5px; min-height:42px;">${printAttach}</div>
				    </td>
				</tr>            
	      	</table>	
	      		
		</div>
	</body>
</html>