<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>admin_memberlist</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		
		<c:if test="${sysopCheck != '1' }">
			<spring:message code = 'ezCommunity.t447' />
			<%
				if (true) {
					return;
				}
			 %>
		</c:if>
		
		<script type="text/javascript">
			function MM_swapImgRestore() { 
				var i,x,a=document.MM_sr;
				
				for (i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) {
					x.src=x.oSrc;
				}
			}
	
			function MM_preloadImages() { 
				var d=document;
				
				if (d.images) { 
					if (!d.MM_p) {
						d.MM_p=new Array();
					}
					
					var i,j=d.MM_p.length,a=MM_preloadImages.arguments;
					for(i=0; i<a.length; i++) {
						if (a[i].indexOf("#")!=0){ 
							d.MM_p[j]=new Image;
							d.MM_p[j++].src=a[i];
						}
					}
				}
			}
	
			function MM_findObj(n, d) { 
				var p,i,x;
				
				if (!d) {
					d=document;
				}
				
				if ((p=n.indexOf("?"))>0&&parent.frames.length) {
					d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);
				}
				
				if (!(x=d[n])&&d.all) {
					x=d.all[n];
				}
				
				for (i=0;!x&&i<d.forms.length;i++) {
					x=d.forms[i][n];
				}
				
				for(i=0;!x&&d.layers&&i<d.layers.length;i++) {
					x=MM_findObj(n,d.layers[i].document);
				}
				
				return x;
			}
	
			function MM_swapImage() {
				var i,j=0,x,a=MM_swapImage.arguments; 
				document.MM_sr=new Array; 
				for(i=0;i<(a.length-2);i+=3) {
					if ((x=MM_findObj(a[i]))!=null) {
						document.MM_sr[j++]=x;
						
						if(!x.oSrc) {
							x.oSrc=x.src; x.src=a[i+2];
						}
					}
				}
			}
	
			function sendit() {
			    if( document.getElementById("ser").value == "" ) {
					alert("<spring:message code = 'ezCommunity.t504' />");
					return;
				} else {
					document.member.submit();
				}
			}
		</script>
		
	</head>
	<body class="mainbody">
		<c:choose>
			<c:when test="${mode == 'master'}">
				<h1><spring:message code = 'ezCommunity.t494' /></h1>
			</c:when>
			
			<c:otherwise>
				<h1><spring:message code = 'ezCommunity.t505' /></h1>
			</c:otherwise>
		</c:choose>
		
		<br>
		<br>
		
		<form method="post" name="member" action="/ezCommunity/adminMemberList.do?code=<c:out value = '${code}' />&mode=<c:out value = '${mode}' />">
			<div class="point">
		  
			  	<c:choose>
					<c:when test="${mode == 'master'}">
						<spring:message code = 'ezCommunity.t506' />
					</c:when>
					
					<c:otherwise>
						<spring:message code = 'ezCommunity.t507' />
					</c:otherwise>
				</c:choose>
		    
		  	</div>
		  
		  	<table class="content" style="margin-top:5px" >
				<tr>
					<th><spring:message code = 'ezCommunity.t31' /></th>
					<td>
						<input type="radio" name="flag" value="id" style="margin:0px 0px 3px 3px">
		        		<label style="vertical-align:middle"><spring:message code = 'ezCommunity.t508' /></label>
		        		<input type="radio" name="flag" value="name" checked style="margin:0px 0px 3px 3px">
		        		<label style="vertical-align:middle"><spring:message code = 'ezCommunity.t509' /></label>
		        		<input name="ser" id ="ser" type="text">
		        		<a class="imgbtn"><span onClick="javascript:sendit();"><spring:message code = 'ezCommunity.t31' /></span></a>
		        	</td>
		    	</tr>
		  	</table>
		</form>
		
		<br>
		
		<div class="subtxt">
			<spring:message code = 'ezCommunity.t510' /><span class="point"><c:out value = '${postCount}' /></span><spring:message code = 'ezCommunity.t511' />
		</div>
		
		<table class="mainlist" style ="width:100%">
			<tr>
			    <th style="width:40px;"><spring:message code = 'ezCommunity.t32' /></th>
			    <th  style="width:120px;"><spring:message code = 'ezCommunity.t10' /></th>
			    <th ><spring:message code = 'ezCommunity.t512' /></th>
		  	</tr>
		  	<span id=idSpan>${idSpanValue }</span>
		</table>
	</body>
</html>