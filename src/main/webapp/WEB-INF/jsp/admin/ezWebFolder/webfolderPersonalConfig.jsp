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
		    
		    
	    </script>
	</head>
	<body class="mainbody">
	   <h1><spring:message code='ezWebFolder.t103' /></h1>
	   <div id="companySelect" style="margin: 10px 10px;">
	   		<span style="font-size: 16px; display:inline-block; height: 21px; vertical-align: middle;"><b>회사 선택: </b></span>
	   		<select id="companyList" style="font-size: 13px; border-radius: 3px; height: 25px; display:inline-block;">
	   			<option>가온아이</option>
	   			<option>리딩</option>
	   			<option>아추 저죽은행</option>
	   			<option>테스트1</option>
	   			<option>테스트2</option>
	   		</select>
	   </div>
	   
	   <div style="position: relative; height: 27px; margin-bottom: 10px;">
	   		<a id="btnSearch" class="webfolderBttn" onClick="openSearchPanel();"><span><spring:message code='ezWebFolder.t123' /></span></a>
	   		<div style="position: absolute; top: 0px; right: 12px; height: 27px;">	   			
   				<span style="height: 20px; line-height: 20px; display: inline; font-size: 14px;">용량 설정:</span>
   				<input id="storageVal" type="text" style="width: 100px; height: 27px; border-radius: 5px; border: 1px solid #b3b3b3; margin-right: 3px;"/>
   				<a id="btnChange" class="webfolderBttn" onClick="changeStorageVal();"><span><spring:message code='ezWebFolder.t124' /></span></a>
   				<a id="btnBack" class="webfolderBttn" onClick="changeToDefault();"><span><spring:message code='ezWebFolder.t125' /></span></a>
   				<select id="numberOfPage" style="height: 27px; margin-left: 5px; border-radius: 5px;">
   					<option>보기 설정</option>
		   			<option>10</option>
		   			<option>15</option>
		   			<option>20</option>
		   			<option>25</option>
   				</select>  			
	   		</div>	   	 	
	   </div>
	   
	   <div id="mainSetting" style="margin: 10px 10px;">
	   		<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileStorage">
	   			<tr>
	   				<th width="10px"><input type="checkbox" onchange="getCheckAll(this);"></th>
					<th width="120px" style="text-align: center;">회사명</th>
					<th width="120px" style="text-align: center;">부서명</th>
					<th width="120px" style="text-align: center;">사용자</th>
					<th width="40px" style="text-align: center;">직급</th>
					<th width="80px" style="text-align: center;">사용량</th>
					<th width="80px" style="text-align: center;">총용량</th>
					<th width="60px" style="text-align: center;">사용률</th>
	   			</tr>
	   			<tr class="bnkWebFolder">
		   			<td><input type="checkbox" onchange="getChecked(this);" value="0" class="checkBnk"></td>
					<td style="text-align: center;">가온아이</td>
					<td style="text-align: center;">오픈솔루션팀</td>
					<td style="text-align: center;">박예연</td>
					<td style="text-align: center;">사원</td>
					<td style="text-align: center;">200MB</td>
					<td style="text-align: center;">1.5GB</td>
					<td style="cursor:pointer; white-space:nowrap; text-align:center;">
						<span class="workProgressBar">
							<span class="bar" taskid="taskProgressBar0">
								<div class="progressbar" style="width: 70%; background-color: rgb(238, 238, 238); border-radius: 10px; display: inline-table;">
									<div class="proggress" style="background-color: rgb(52, 152, 219); height: 10px; border-radius: 10px; width: 20%;">
									</div>
								</div>
								<div class="percentCount">20%</div>
							</span>&nbsp;
							<span style="display: inline-block;">
							</span>
						</span>
					</td>
	   			</tr>
	   		</table>
	   </div>
	</body>
</html>