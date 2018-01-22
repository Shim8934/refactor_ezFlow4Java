<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	   	<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	    <link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
   		<script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>	
		<script type="text/javascript" >        
			var topid = "<c:out value='${companyID}'/>";
			
			window.onload = function () {
		        
		    }
			
			
	    </script>
	</head>
	<body class="mainbody">	
	   <h1><spring:message code='ezWebFolder.t126' /></h1>
	   <div id="companySelect" style="margin: 10px 0px;">
	   		<span style="font-size: 16px; display:inline-block; height: 21px; vertical-align: middle;"><b>회사 선택: </b></span>
	   		<select id="companyList" style="font-size: 13px; border-radius: 3px; height: 25px; display:inline-block;">
	   			<option>가온아이</option>
	   			<option>리딩</option>
	   			<option>아추 저죽은행</option>
	   			<option>테스트1</option>
	   			<option>테스트2</option>
	   		</select>
	   </div>
	   
	   <div style="height: 450px; width: 100%;">
	   		<table style="border-collapse: collapse; width: 100%;">
	   			<tr>
	   				<td style="width: 350px; min-width: 350px;">
	   					<div style="width: 350px; height: 450px; border: 1px solid #666666;"></div>
	   				</td>
	   				<td>
	   					<div style="width: 500px; height: 450px; border: 1px solid #cccccc; margin-left: 10px;">
	   						<table>
	   							<tr>
	   								<td>
		   								<div style="margin: 100px 20px 20px 20px;">
		   									<span>폴더명: </span>
		   									<input type="text" style="height: 25px; border-radius: 3px; border: 1px solid #666; width: 200px; margin-left: 2px;">
		   								</div>
	   								</td>
	   							</tr>
	   							<tr>
	   								<td>
	   									<div style="margin: 10px 20px;">
	   										<span>구성원:</span>
	   										<span>오픈솔루션팀, 경영지원팀</span>
	   									</div>
	   								</td>
	   							</tr>
	   							<tr>
	   								<td>
	   									<div style="margin: 20px 20px 100px 20px;">
	   										<a class="webfolderBttn2"><span onclick="">조직도</span></a>
	   									</div>
	   								</td>
	   							</tr>
	   							<tr>
	   								<td>
	   									<div style="margin: 0px 141px;">
	   										<a class="webfolderBttn"><span onclick="">저장</span></a>
		   									<a class="webfolderBttn"><span onclick="">하위폴더</span></a>
		   									<a class="webfolderBttn"><span onclick="">삭제</span></a>
	   									</div>
	   								</td>
	   							</tr>
	   						</table>
	   					</div>
	   				</td>
	   			</tr>	   			
	   		</table>
	   		
	   </div>
	</body>
</html>