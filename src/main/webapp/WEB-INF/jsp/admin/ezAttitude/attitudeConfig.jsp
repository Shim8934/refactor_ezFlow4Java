<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>attitudeConfig</title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/Common.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript">
	        $(document).ready(function(){
		        if (document.getElementById("ListCompany").length == 0) {
		            alert("");
		        } else {
		            document.getElementById("ListCompany").selectedIndex = 0;
		            company_change();
		        }
	        });
	    </script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code='ezAttitude.t10' /></h1>
		<div id="mainmenu">
			<ul>
	        	<li style="background: none;">
				<span style="border: none;"><b><spring:message code='ezAttitude.t15' /></b></span>
				</li>
				<li>
				<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-bottom:10px">
					<option>회사1</option>
					<option>회사2</option>
	      		</select>
	      		</li>
	      		<li><span onclick="save_config()"><spring:message code='ezAttitude.t16' /></span></li>
	      	</ul>
	  	</div>
		<table class="content" style="width:500px">
			<tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					<spring:message code='ezAttitude.t17' />
	            </th>
	            <td style="width: 500px; text-align:left; padding-left: 5px;">
	            	<input type="text" style="width:50px;"/><spring:message code='ezAttitude.t18' /><input type="text" style="width:50px;"/><spring:message code='ezAttitude.t19' /> ~ <input type="text" style="width:50px;"/><spring:message code='ezAttitude.t18' /><input type="text" style="width:50px;"/><spring:message code='ezAttitude.t19' />
	            </td>
	        </tr>
	        <tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					<spring:message code='ezAttitude.t20' />
	            </th> 
	            <td style="width: 500px; text-align:left">
	            	<input type="checkbox" name="day_chk" value=""/><spring:message code='ezAttitude.t21' />
	            	<input type="checkbox" name="day_chk" value=""/><spring:message code='ezAttitude.t22' />
	            	<input type="checkbox" name="day_chk" value=""/><spring:message code='ezAttitude.t23' />
	            	<input type="checkbox" name="day_chk" value=""/><spring:message code='ezAttitude.t24' />
	            	<input type="checkbox" name="day_chk" value=""/><spring:message code='ezAttitude.t25' />
	            	<input type="checkbox" name="day_chk" value=""/><spring:message code='ezAttitude.t26' />
	            	<input type="checkbox" name="day_chk" value=""/><spring:message code='ezAttitude.t27' />
	            </td>
	        </tr>
	        <tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					<spring:message code='ezAttitude.t28' />
	            </th>
	            <td style="width: 500px; text-align:left">
	            	<input type="radio" name="attitude_mod_appl" value="1"/><spring:message code='ezAttitude.t29' />
	            	<input type="radio" name="attitude_mod_appl" value="0"/><spring:message code='ezAttitude.t30' />
	            </td>
	        </tr>
	        <tr style="height:30px;">
	        	<th style="width: 70px; text-align:center">
					<spring:message code='ezAttitude.t31' />
	            </th>
	            <td style="width: 500px; text-align:left">
	            	<input type="radio" name="close_date_attitude" value="1"/><spring:message code='ezAttitude.t29' />
	            	<input type="radio" name="close_date_attitude" value="0"/><spring:message code='ezAttitude.t30' />
	            </td>
	        </tr>
		</table>
	</body>
</html>
