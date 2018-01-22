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
	    <link rel="stylesheet" href="/css/jquery.lineProgressbar.css" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>	    
	    <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>
	    <script type="text/javascript" src="/js/ezTask/jquery.lineProgressbar.js"></script>
		<script type="text/javascript" >
			var topid = "<c:out value='${topid}'/>";
			
		 	document.onselectstart = function(){
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA"){
		            return false;
		        }else{
		            return true;
		        }
		    };
		    
		    function openSearchPanel() {
		    	$("#searchPanel").toggle("1000");
		    }
		    
	    </script>
	</head>
	<body class="mainbody">
	   <h1><spring:message code='ezWebFolder.t128' /></h1>
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
	   
	   <div style="height: 27px; margin-bottom: 10px;">
	   		<div style="position: relative;">
	   			<a id="btnSearch" class="webfolderBttn2" onClick="openSearchPanel();"><span><spring:message code='ezWebFolder.t123' /></span></a>
	   			<div id="searchPanel" style="position: absolute; top: 37px; left: 0px; height: 80px; width: 500px; border: 1px solid #666666; z-index: 10; background-color: #f2f2f2; display: none;">
	   				<div style="margin: 10px;">
		   				<table style="border-collapse: collapse; width: 100%;">
		   					<tr>
		   						<th style="width: 100px; min-width: 100px;">검색대상</th>
		   						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 358px; width: 358px;">
		   							<select style="margin-left: 10px;">
		   								<option>부서명</option>
							   			<option>사용자</option>
		   							</select>
		   							<input type="text" style="width: 270px; height: 23px; margin: 2px 5px; padding: 0px 5px; border-radius: 3px; border: 1px solid #ccc;">
		   						</td>
		   					</tr>
		   					<tr>
		   						<td colspan="2">
		   							<div style="margin: 9px 50px 9px 160px;">
		   								<a class="webfolderBttn"><span onclick="">검색</span></a>
			   							<a class="webfolderBttn"><span onclick="">취소</span></a>
		   							</div>
		   						</td>
		   					</tr>
		   				</table>
	   				</div>
	   			</div>
	   		</div> 	 	
	   </div>
	   
	   <div id="mainSetting" style="margin: 10px 0px;">
	   		<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileStorage">
	   			<tr>	   				
					<th width="100px" style="text-align: center;">형태</th>
					<th width="100px" style="text-align: center;">이름</th>
					<th width="100px" style="text-align: center;">파일크기</th>
					<th width="100px" style="text-align: center;">수행자</th>
					<th width="100px" style="text-align: center;">수행사항</th>
					<th width="100px" style="text-align: center;">날짜</th>					
	   			</tr>
	   			<tr class="bnkWebFolder">
					<td style="text-align: center;">파일</td>
					<td style="text-align: center;">간단파일.jsp</td>
					<td style="text-align: center;">100.24KB</td>
					<td style="text-align: center;">박예연</td>
					<td style="text-align: center;">파일 삭제</td>
					<td style="text-align: center;">2018-01-12 12:10:45</td>
	   			</tr>
	   		</table>
	   </div>
	</body>
</html>