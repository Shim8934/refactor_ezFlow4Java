<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<link rel="stylesheet" href="/css/default_kr.css" type="text/css"/>
    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    <script type="text/javascript" src="/js/mouseeffect.js"></script>
    <script type="text/javascript" src="/js/Common.js"></script>
    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
    <script type="text/javascript">
    	function company_change(){
    		
    	}
    </script>
	</head>
<body>
	<body class="mainbody">
	    <h1>사용자별 근태관리</h1>
		<div id="mainmenu">
			<ul>
	        	<li style="background: none;">
				<span style="border: none;"><b>회사선택</b></span>
				</li>
				<li>
				<select name="ListCompany" id="ListCompany" onchange="company_change()" style="margin-top:4px; padding-right:40px;">
					<option>회사</option>
	      		</select>
	      		</li>
	      	</ul>
	  	</div>
	  	<div id="mainmenu">
	  		<ul class="on">
	  			<li class="off"><span onclick="">추가/변경</span></li>
	  			<li class="off"><span onclick="">검색</span></li>
	  		</ul>
	  	</div>
		<table class="mainlist" style="width:100%;">
			<thead>
				<tr>
					<th style="width:20px;"><input type="checkbox" style="margin: 0px; padding: 0px; width:13px; height: 13px;"/></th>
					<th style="width:29px;">NO</th>
					<th style="width:300px">이름</th>
					<th style="width:200px">직위</th>
					<th style="width:400px">부서</th>
					<th style="width:600px">근무시간</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td colspan="6" style="text-align:center">등록된 정보가 없습니다.</td>
				</tr>
			</tbody>
		</table>
	</body>
</body>
</html>