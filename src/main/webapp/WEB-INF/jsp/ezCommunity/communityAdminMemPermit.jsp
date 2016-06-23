<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezCommunity.t447' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		
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
				var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
			}
	
			function MM_preloadImages() {
				var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
				var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
				if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
			}
	
			function MM_findObj(n, d) {
				var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
				d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
				if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
				for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document); return x;
			}
	
			function MM_swapImage() {
				var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
				if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
			}
			
			function okno(a,b,c,d, userName) {
				if (a == "ok") {
					var result = confirm(userName+"<spring:message code = 'ezCommunity.t546' />");
					
					if (result) {
						document.location.href="/ezCommunity/adminOkNo.do?flag="+a+"&cID="+b+"&code="+c+"&goToPage="+d;
					}
				} else {
					var result = confirm(userName + "<spring:message code = 'ezCommunity.t547' />");
					
					if (result) {
						document.location.href="/ezCommunity/adminOkNo.do?flag="+a+"&cID="+b+"&code="+c+"&goToPage="+d;
					}
				}
			}
	
			function openinfo(a,b,c) {
			    var feature = "dialogHeight:490px; dialogWidth:425px; status:no; help:no; scroll:no";
			    feature = feature + GetShowModalPosition(425, 490);
			    var Para = window.showModalDialog("/ezCommon/showPersonInfo.do?id=" + b, null, feature);
			}
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code = 'ezCommunity.t548' /></h1>
		<br>
		<br>
 		<div class="subtxt">
 			<spring:message code = 'ezCommunity.t549' />
 			<span class="point"><c:out value = '${postCount}' /></span>
 			<spring:message code = 'ezCommunity.t511' />
 		</div>
 		
		<table class="mainlist" style="width:100%" >
  			<tr>
			    <th style="width:40px"><spring:message code = 'ezCommunity.t32' /></th>
			    <th ><spring:message code = 'ezCommunity.t10' /></th>
			    <th style="width:60px;"><spring:message code = 'ezCommunity.t550' /></th>
			    <th style="width:60px"><spring:message code = 'ezCommunity.t551' /></th>
  			</tr>
			<span id="idSpan">${idSpanValue }</span>
		</table>
		<br>
	</body>
</html>