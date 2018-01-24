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
	    <link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css"/>
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css"/>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
   		<script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>	
   		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script src="/js/jquery-ui/jquery-ui.js"></script>	
		<script type="text/javascript" >        
			var topid = "<c:out value='${companyID}'/>";
			
			window.onload = function () {
				$("#Sdatepicker").datepicker({
		        	changeMonth: true,
		        	changeYear: true,
		        	autoSize: true,
		        	showOn: "both",
		        	buttonImage: "/images/ImgIcon/calendar-month.gif",
		        	buttonImageOnly: true,
		        	/*onSelect: function(dateText, inst) {
		            	dateCompare(dateText, SDate);
		            } */
		    	});
				
				$("#Edatepicker").datepicker({
			        changeMonth: true,
		    	    changeYear: true,
		        	autoSize: true,
		        	showOn: "both",
		        	buttonImage: "/images/ImgIcon/calendar-month.gif",
		        	buttonImageOnly: true
		    	});	
		    }
			
		    function openSearchPanel() {
		    	$("#searchPanel").toggle("1000");
		    }
		    
		    function fileSearchCancel() {
		        $("#Sdatepicker").datepicker('setDate', "");
		        $("#Edatepicker").datepicker('setDate', "");
		        document.getElementById("fileExtVal").value = "";
		        document.getElementById("fileNameVal").value = "";
		        document.getElementById("fileCreatorVal").value = "";
		        document.getElementById("searchPanel").style.display = "none";
		    }
	    </script>
	</head>
	<body class="mainbody">	
	   <h1><spring:message code='ezWebFolder.t127' /></h1>
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
	   
	   <div id="mainmenu" style="position: relative;">
			<ul>
				<li id=""><a onClick="fileDownload()" 	 style="margin-top: 3px;"><span>파일다운로드</span></a></li>
				<li id=""><a onClick="fileUpload()"   	 style="margin-top: 3px;"><span>파일업로드</span></a></li>
				<li id=""><a onClick="fileDelete()"   	 style="margin-top: 3px;"><span>파일삭제</span></a></li>
				<li id=""><a onClick="fileRename()"   	 style="margin-top: 3px;"><span>파일명변경</span></a></li>
				<li id=""><a onClick="fileMove()"     	 style="margin-top: 3px;"><span>파일이동/복사</span></a></li>
				<li id=""><a onClick="openSearchPanel()" style="margin-top: 3px;"><span>검색</span></a></li>
			</ul>
			<div style="position: absolute; top: 0px; right: 10px;">
				<select style="height: 27px; border-radius: 3px;">
					<option>전체 </option>
					<option>문서 </option>
					<option>음악</option>
					<option>영상</option>
					<option>그림</option>
					<option>폴더</option>
					<option>압축파일</option>
				</select>
			</div>
			   							
	   </div>
	   
	   	<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<div id="searchPanel" style="position: fixed; top: 132px; left: 200px; height: 180px; width: 514px; border: 1px solid #666666; z-index: 10; background-color: #f2f2f2; display: none;">
  			<div style="margin: 10px;">
   				<table class="content" style="border-collapse: collapse; width: 100%;">
   					<tr>
   						<th style="width: 100px; min-width: 100px; text-align: center;">검색 기간</th>
   						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
   							<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
		                	~
		               		<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">				
   						</td>
   					</tr>
					<tr>
						<th style="width: 100px; min-width: 100px; text-align: center;">확장자</th>
   						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
							<input id="fileExtVal" type="text" style="height: 23px; width: 200px;">
   						</td>
					</tr>
					<tr>
						<th style="width: 100px; min-width: 100px; text-align: center;">파일명</th>
   						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
   							<input id="fileNameVal" type="text" style="height: 23px; width: 200px;">
   						</td>
					</tr>
					<tr>
						<th style="width: 100px; min-width: 100px; text-align: center;">작성자</th>
   						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
   							<input id="fileCreatorVal" type="text" style="height: 23px; width: 200px;">
   						</td>
					</tr>
   				</table>
  					<div style="margin: 12px 50px 12px 180px;">
						<a class="webfolderBttn"><span onclick="">검색</span></a>
 						<a class="webfolderBttn"><span onclick="fileSearchCancel();">취소</span></a>
					</div>
  			</div>
 	   </div>
		
 
	   
	   <div id="mainSetting" style="margin: 10px 0px;">
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