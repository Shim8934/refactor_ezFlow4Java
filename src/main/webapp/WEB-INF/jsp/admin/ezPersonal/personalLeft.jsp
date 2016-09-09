<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='main.e15'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		
		<script type="text/javascript">
// 		어디서 쓰는지
// 			function btnModify_click() {
// 				rtnValue = window.showModalDialog("link/CompanyLink_Modify.asp", "", "dialogHeight:460px;dialogwidth:390px;dialogleft:100px;dialogtop:100px;status:no;toolbar:no;location:no;scroll:no;edge:sunken");
// 			}
	
			function goPage(idx) {
				var url = "";
			    switch (idx) {
			        case 1:
			            url = "/admin/ezPersonal/manageNotice.do";
			            break;

			        case 2:
			            if (CrossYN())
			                url = "/myoffice/ezPersonal/Link/ManageCompanyLink_Cross.aspx";
			            else {
			                url = "/myoffice/ezPersonal/Link/ManageCompanyLink.aspx";
			            }
			            break;

			        case 3:
			            url = "/admin/ezPersonal/managePoll.do";
			            break;

			        case 4:
			            url = "/admin/ezPersonal/managePopup.do";
			            break;

			        case 5:
			            url = "/myoffice/ezPersonal/SuperPersonal/ManageSuperPersonal.aspx";
			            break;

			        case 6:
			            url = "/myoffice/ezPersonal/WebPart/ManageWebPart.aspx";
			            break;

			        case 7:
			            url = "/myoffice/ezPersonal/WebPart/EmployeeofMonth.aspx";
			            break;

			        case 8:
			            url = "/admin/ezPersonal/manageQuickLink.do";
			            break;

			        case 9:
			            url = "/myoffice/ezPersonal/SliderImage/wp_sliderimages.aspx";
			            break;
			    }
				parent.frames["right"].location.href = url;
			}
		</script>
	</head>
	<body class="leftbody" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
		<div id="left">
			<div class="left_admin" title="<spring:message code = 'main.t7' />"><spring:message code = 'main.t7' /></div>   
		  	<h2>
		  		<span onClick="goPage(1)" style="display:inline-block;width:100%"><spring:message code = 'main.t65' /></span>
		    	<ul></ul>
			</h2>

			<c:if test="${usePortal != 'YES' }">
				<h2><span onClick="goPage(6)" style="display:inline-block;width:100%"><spring:message code = 'main.t66' /></span>
					<ul></ul>
				</h2>
			</c:if>
			
			<%--<span>
			<h2><span onClick="goPage(2)">Family Site</span>
			  <ul>
			  </ul>
			</h2>
			</span>--%>
			
			<h2><span onClick="goPage(8)" style="display:inline-block;width:100%">Quick Link</span>
				<ul></ul>
			</h2>
		  
		  	<h2><span onClick="goPage(3)" style="display:inline-block;width:100%">Quick Poll</span>
		    	<ul></ul>
			</h2>
			
		  	<h2><span onClick="goPage(4)" style="display:inline-block;width:100%"><spring:message code = 'main.t67' /></span>
		    	<ul></ul>
		  	</h2>
		  	
		  	<h2><span onClick="goPage(7)" style="display:inline-block;width:100%;"><spring:message code = 'main.t68' /></span>
		  		<ul></ul>
		  	</h2>
		  	
		  	<h2><span onClick="goPage(9)" style="display:inline-block;width:100%;"><spring:message code = 'main.t10000' /></span>
		  		<ul></ul>
		  	</h2>
		  	
		  	<%-- <c:if test="${useKMS == 'YES' }">
				<h2><span onClick="goPage(5)" style="display:inline-block;width:100%"><spring:message code = 'main.t68' /></span>
					<ul></ul>
				</h2>
			</c:if> --%>
		</div>
		
		<script type="text/javascript">
			initToggleList(document.getElementById("left"), "h2", "ul", "li");
		</script>
	</body>
</html>