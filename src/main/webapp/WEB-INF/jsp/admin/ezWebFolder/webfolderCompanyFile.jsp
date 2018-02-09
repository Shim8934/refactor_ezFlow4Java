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
			var blockSize    = 10;
			var currentPage  = null;
			var totalRows	 = null;
			var totalPages   = null;
			var primary	     = "<c:out value='${primary}'/>";
			var strLang39	 = "<spring:message code = 'ezWebFolder.t135'/>";
			var strLang40 	 = "<spring:message code = 'ezWebFolder.t136'/>";
			var strLang41    = "<spring:message code = 'ezWebFolder.t137'/>";
			var strLang42    = "<spring:message code = 'ezWebFolder.t138'/>";
			var startDateStr = "";
			var endDateStr	 = "";
			var fileExtStr	 = "";
			var fileNameStr	 = "";
			var userNameStr  = "";
			var fileTypeStr  = "";
			var folderId	 = "<c:out value='${folderId}'/>";			
			
        	window.onresize = function () {
				var divList          = document.getElementById("mainSetting");				
				var reheight         = document.documentElement.clientHeight - 170;	
				divList.style.height = reheight + "px";
			};
			
			window.onload = function () {
				$("#Sdatepicker").datepicker({
		        	changeMonth: true,
		        	changeYear: true,
		        	autoSize: true,
		        	showOn: "both",
		        	buttonImage: "/images/ImgIcon/calendar-month.gif",
		        	buttonImageOnly: true,
		        	dateFormat: "yy-mm-dd"
		    	});
				
				$("#Edatepicker").datepicker({
			        changeMonth: true,
		    	    changeYear: true,
		        	autoSize: true,
		        	showOn: "both",
		        	buttonImage: "/images/ImgIcon/calendar-month.gif",
		        	buttonImageOnly: true,
		        	dateFormat: "yy-mm-dd"
		    	});
				
				search_Set("1");
				preProcessing();
		    }
			
			function preProcessing() {
				var divList          = document.getElementById("mainSetting");
				var reheight         = document.documentElement.clientHeight - 170;
				divList.style.height = reheight + "px";
			}	
		    
		    function openSearchPanel() {
		    	$("#searchPanel").toggle("1000");
		    	
		        $("#Sdatepicker").datepicker('setDate', "");
		        $("#Edatepicker").datepicker('setDate', "");
		        document.getElementById("fileExtVal").value = "";
		        document.getElementById("fileNameVal").value = "";
		        document.getElementById("fileCreatorVal").value = "";
		    }
		    
		    function search_Set(pPage) {	    	
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getFileList.do",
					data: {
						"currentPage" : pPage,
						"startDate"   : startDateStr,
						"endDate"     : endDateStr,
						"fileExt"     : fileExtStr,
						"fileName"    : fileNameStr,
						"userName"    : userNameStr,
						"fileType"	  : fileTypeStr,
						"folderId"    : folderId
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var result  = data.fileList;
						totalRows   = data.totalRows;
						totalPages  = data.totalPages;
						currentPage = pPage;
						
						makePageSelPage();							
						renderData(result);						
					},
	 				error : function(error) {
						alert("<spring:message code='ezWebFolder.t134' />" + error);
					}
				});			
			}
		    
		    function renderData(result) {
				var tableList = document.getElementById("tblFileList");
		    	
		    	while (tableList.rows.length > 1) {
		    		tableList.deleteRow(1);
		    	}
		    	
		    	if (result == null || result.length == 0) {		    	
		    		var trElmt = document.createElement("tr");
		    		var tdElmt = document.createElement("td");
		    		tdElmt.setAttribute("colspan", "9");
		    		tdElmt.setAttribute("align", "center");
		    		tdElmt.setAttribute("bgcolor", "#FFFFFF");
		    		tdElmt.innerHTML = "<spring:message code='ezWebFolder.t144' />";
		    		
		    		trElmt.appendChild(tdElmt);
		    		tableList.appendChild(trElmt);
		    	}
		    	else {		    		
		    		/* var len = result.length;
		    		for (var i = 0; i < len; i++) {
		    			var trElmt  = document.createElement("tr");
		    			var tdElmt1 = document.createElement("td");
		    			var tdElmt2 = document.createElement("td");
		    			var tdElmt3 = document.createElement("td");
		    			var tdElmt4 = document.createElement("td");
		    			var tdElmt5 = document.createElement("td");
		    			var tdElmt6 = document.createElement("td");
		    			var tdElmt7 = document.createElement("td");	
		    			var tdElmt8 = document.createElement("td");	
		    			var tdElmt9 = document.createElement("td");
		    			
		    			trElmt.setAttribute("class", "bnkWebFolder");
		    			tdElmt1.textContent = result[i]["fileType"];		    			
		    			
		    			tdElmt2.setAttribute("style","overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
		    			tdElmt2.textContent = result[i]["fileName"];		    			
		    			
		    			tdElmt3.textContent = result[i]["fileSize"];
		    			
		    			tdElmt4.setAttribute("style","overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
		    			
		    			if (primary == "1") {
		    				tdElmt4.textContent = result[i]["createName1"];
		    			}
		    			else {
		    				tdElmt4.textContent = result[i]["createName2"];
		    			}	    			
		    			
		    			switch(result[i]["logType"]) {
		    				case "C":
		    					tdElmt5.textContent = "<spring:message code='ezWebFolder.t160' />";
		    					break;
		    				case "D":
		    					tdElmt5.textContent = "<spring:message code='ezWebFolder.t161' />";
		    					break;
		    				case "U":
		    					tdElmt5.textContent = "<spring:message code='ezWebFolder.t162' />";
		    					break;
		    				case "R":
		    					tdElmt5.textContent = "<spring:message code='ezWebFolder.t111' />";
		    					break;
		    			}
		    			
		    			tdElmt6.setAttribute("style","text-align: center; overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
		    			tdElmt6.textContent = result[i]["createDate"].substring(0, 19);

				        trElmt.appendChild(tdElmt1);
				        trElmt.appendChild(tdElmt2);
				        trElmt.appendChild(tdElmt3);
				        trElmt.appendChild(tdElmt4);
				        trElmt.appendChild(tdElmt5);
				        trElmt.appendChild(tdElmt6);
				        tableList.appendChild(trElmt);
		    		}
		    		*/
		    	} 
		    }
		    
		    function startSearch() {
		    	var sDateVal    = document.getElementById("Sdatepicker").value;
		    	var eDateVal    = document.getElementById("Edatepicker").value;
		    	var fileExtVal  = document.getElementById("fileExtVal").value;
		    	var fileNameVal = document.getElementById("fileNameVal").value;
		    	var userNameVal = document.getElementById("fileCreatorVal").value;
		    	var fileTypeVal = document.getElementById("fileTypeSelect").value;
		    	
		    	if (!sDateVal && !eDateVal && !fileExtVal && !fileNameVal && !userNameVal) {
		    		alert("<spring:message code='ezWebFolder.t163' />");					
		    		return;
		    	}
		    	
		    	if ((!sDateVal && eDateVal) || (sDateVal && !eDateVal)) {
		    		alert("You must provide both start date and end date!");
		    		return;
		    	}
		    	
		    	if (sDateVal && eDateVal) {
		    		if (sDateVal > eDateVal) {
		    			alert("<spring:message code='ezWebFolder.t164' />");
		    			return;
		    		}
		    	}
		    	
				startDateStr = sDateVal;
			    endDateStr	 = eDateVal;
				fileExtStr	 = fileExtVal;
				fileNameStr	 = fileNameVal;
				userNameStr  = userNameVal;
				fileTypeStr  = fileTypeVal;
		    	
		    	openSearchPanel();
		    	search_Set("1");
		    }
		    
		    function change() {
				startDateStr = "";
			    endDateStr	 = "";
				fileExtStr	 = "";
				fileNameStr	 = "";
				userNameStr  = "";
		    	search_Set("1");
		    }
		    
	    </script>
	</head>
	<body class="mainbody">	
	   <h1>
	   		<spring:message code='ezWebFolder.t127' />
	   		<span id="mailBoxInfo"></span>
	   </h1>
	   <div id="companySelect" style="margin: 10px 0px;">
	   		<span style="font-size: 16px; display:inline-block; height: 21px; vertical-align: middle;"><b>회사 선택: </b></span>
	   		<select id="companyList" style="font-size: 13px; border-radius: 3px; height: 25px; display:inline-block;" onchange="change();">
				<c:forEach var="item" items="${list}">
		        	<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
		        </c:forEach>
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
				<select style="height: 27px; border-radius: 3px;" id="fileTypeSelect">
					<option value="1">전체 </option>
					<option value="2">문서 </option>
					<option value="3">음악</option>
					<option value="4">영상</option>
					<option value="5">그림</option>					
					<option value="6">압축파일</option>
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
 						<a class="webfolderBttn"><span onclick="openSearchPanel();">취소</span></a>
					</div>
  			</div>
 	   </div>
		
 
	   
	   <div id="mainSetting" style="margin: 10px 0px;">
	   		<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileList">
	   			<tr>
	   				<th width="10px"><input type="checkbox" onchange="getCheckAll(this);"></th>
					<th width="40px" style="text-align: center;">유형</th>
					<th width="160px" style="text-align: center;">이름</th>
					<th width="60px" style="text-align: center;">파일크기</th>
					<th width="120px" style="text-align: center;">게시자</th>
					<th width="80px" style="text-align: center;">등록일</th>
					<th width="80px" style="text-align: center;">갱신일</th>
					<th width="80px" style="text-align: center;">위치</th>
					<th width="60px" style="text-align: center;">다운로드횟수</th>
	   			</tr>
	   			<!-- <tr class="bnkWebFolder">
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
	   			</tr> -->
	   		</table>
	   </div>
	    <div id="tblPageRayer"></div>
	   <script type="text/javascript" src="/js/ezWebFolder/pageNav.js"></script>
	</body>
</html>