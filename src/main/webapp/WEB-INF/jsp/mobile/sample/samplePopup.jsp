<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>    	
	</head>
	<body>	    
		<!-- layer popup -->	   
	    <div id="popupAlert" class="ui-content" style="min-width: 255px; max-width: 285px; height:70px; text-align:center" data-role="popup" data-overlay-theme="b" data-transition="pop">
		    <a href="#" data-rel="back" data-role="button" data-theme="b" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a>
		    <p>
				<a href="#" id="popupContent" data-rel="back" data-icon="alert" data-theme="a" data-role="button" style="max-width:95%;min-height:30px;font-weight:normal;background-color:#f2f2f2;font-size:12px;padding-top:20px"><spring:message code='main.jjs02'/></a>
			</p>			
		</div>
	    <div id="popupMailMove" class="ui-content" style="min-width: 255px; max-width: 285px; text-align:center" data-role="popup" data-overlay-theme="b" data-transition="pop">
		    <a href="#" data-rel="back" data-role="button" data-theme="b" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a>
		    <div>
				<fieldset data-role="controlgroup">					
					<div>
				        <input name="radio-choice-v-2" id="radio-choice-v-2a" type="radio" value="off">
				        <label for="radio-choice-v-2a">KT MANAGED</label>
				        <input name="radio-choice-v-2" id="radio-choice-v-2b" type="radio" value="off">
				        <label for="radio-choice-v-2b">프리텔레콤</label>
				        <input name="radio-choice-v-2" id="radio-choice-v-2c" type="radio" value="other">
				        <label for="radio-choice-v-2c">오픈솔루션팀함</label>
			        </div>
			    </fieldset>
			</div>			
		</div>		
		<div id="popupMailSearch" class="ui-content" style="min-width: 255px; max-width: 285px; text-align:center" data-role="popup" data-overlay-theme="b" data-transition="pop">
		    <a href="#" data-rel="back" data-role="button" data-theme="b" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a>
		    <div>		    	
				<input name="search-1" id="search-1" type="search" placeholder="search mail..">
				<a class="ui-btn" href="#">검 색</a>
			</div>			
		</div>
	    <!-- layer popup -->	
	</body>	
</html>