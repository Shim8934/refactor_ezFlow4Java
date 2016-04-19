<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezBoard.t320'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript">
		    
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            ReturnFunction = parent.item_readlist_cross_dialogArguments[1];
		        } catch (e) {
		
		        }
		    };
		    function show_info(userid) {
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 500) / 2;
		        var top = (heigth - 400) / 2;
		        window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		    }
		    function close_onclick() {
		        if (ReturnFunction != null)
		            ReturnFunction();
		        else
		            window.close();
		    }
		</script>
	</head>
	<body class="popup">
		<form method="post" >
		  <h1><spring:message code='ezBoard.t320'/></h1>
		  <div id="close">
		    <ul>
		      <li onClick="close_onclick()"><span><spring:message code='ezBoard.t12'/></span></li>
		    </ul>
		  </div>
		  <script type="text/javascript">
		    selToggleList(document.getElementById("close"), "ul", "li", "0");
		  </script>
		  <h2><spring:message code='ezBoard.t356'/></h2>
		  <div class="box" >
		    <table style="width:100%" class="popuplist">
		    	<c:forEach var="list" items="${boardReadList}">
		    		<tr>
				        <td style="white-space:nowrap">[ ${list.readDate} ]</td>
				        <td style="cursor:pointer; white-space:nowrap" onClick="show_info('${list.userID}');"><b style="color:black"> ${list.userName} </b>( ${list.userID} )</td>
				        <td style="white-space:nowrap; color:#168501">${list.userDeptName}</td>
				        <td style="width:100%; white-space:nowrap; color:#737373">${list.userTitle}</td>
		      		</tr>
		    	</c:forEach>
		    </table>
		  </div>
		</form>
	</body>
</html>