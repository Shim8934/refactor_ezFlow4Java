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
	   	<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css"/>
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css"/>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>	    
	    <script type="text/javascript" src="/js/ezOrgan/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>
	    <script type="text/javascript" src="/js/ezTask/jquery.lineProgressbar.js"></script>
	    <script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
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
					url: "/admin/ezWebFolder/getFileLogs.do",
					data: {
						"currentPage" : pPage,
						"startDate"   : startDateStr,
						"endDate"     : endDateStr,
						"fileExt"     : fileExtStr,
						"fileName"    : fileNameStr,
						"userName"    : userNameStr,
						"companyId"   : document.getElementById("companyList").value
					},
					dataType: "JSON",
					async: true,
					success : function(data) {				
						var result  = data.fileLogList;		
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
				var tableList = document.getElementById("tblFileHistory");
		    	
		    	while (tableList.rows.length > 1) {
		    		tableList.deleteRow(1);
		    	}
		    	
		    	if (result == null || result.length == 0) {		    	
		    		var trElmt = document.createElement("tr");
		    		var tdElmt = document.createElement("td");
		    		tdElmt.setAttribute("colspan", "6");
		    		tdElmt.setAttribute("align", "center");
		    		tdElmt.setAttribute("bgcolor", "#FFFFFF");
		    		tdElmt.innerHTML = "<spring:message code='ezWebFolder.t144' />";
		    		
		    		trElmt.appendChild(tdElmt);
		    		tableList.appendChild(trElmt);
		    	}
		    	else {		    		
		    		var len = result.length;
		    		for (var i = 0; i < len; i++) {
		    			var trElmt  = document.createElement("tr");
		    			var tdElmt1 = document.createElement("td");
		    			var tdElmt2 = document.createElement("td");
		    			var tdElmt3 = document.createElement("td");
		    			var tdElmt4 = document.createElement("td");
		    			var tdElmt5 = document.createElement("td");
		    			var tdElmt6 = document.createElement("td");		    			
		    			
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
		    	}
		    }
		    
		    function startSearch() {
		    	var sDateVal    = document.getElementById("Sdatepicker").value;
		    	var eDateVal    = document.getElementById("Edatepicker").value;
		    	var fileExtVal  = document.getElementById("fileExtVal").value;
		    	var fileNameVal = document.getElementById("fileNameVal").value;
		    	var userNameVal = document.getElementById("fileCreatorVal").value;
		    	
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
		   	<spring:message code='ezWebFolder.t128' />
		   	<span id="mailBoxInfo"></span>
	   </h1>
	   <div id="companySelect" style="margin: 10px 0px;">
	   		<span style="font-size: 16px; display:inline-block; height: 21px; vertical-align: middle;"><b><spring:message code='ezWebFolder.t129' /></b></span>
	   		<select id="companyList" style="font-size: 13px; border-radius: 3px; height: 25px; display:inline-block;" onchange="change();">
				<c:forEach var="item" items="${list}">
		        	<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
		        </c:forEach>
	   		</select>
	   </div>
	   
	   <div style="height: 27px; margin-bottom: 10px;">
	   		<div style="position: relative;">
	   			<a id="btnSearch" class="webfolderBttn2" onClick="openSearchPanel();"><span><spring:message code='ezWebFolder.t123' /></span></a>
	   			<img src="/images/i_bar.gif" style="margin-left: 2px;" />
	   			<a id="btnRefresh" class="webfolderBttn2" onClick="change();"><span><spring:message code='ezWebFolder.t139' /></span></a>
	   			<div id="searchPanel" style="position: absolute; top: 37px; left: 0px; height: 180px; width: 514px; border: 1px solid #666666; z-index: 10; background-color: #f2f2f2; display: none;">
					<div style="margin: 10px;">
		   				<table class="content" style="border-collapse: collapse; width: 100%;">
		   					<tr>
		   						<th style="width: 100px; min-width: 100px; text-align: center;"><spring:message code='ezWebFolder.t151' /></th>
		   						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
		   							<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
				                	~
				               		<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">				
		   						</td>
		   					</tr>
							<tr>
								<th style="width: 100px; min-width: 100px; text-align: center;"><spring:message code='ezWebFolder.t152' /></th>
		   						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
									<input id="fileExtVal" type="text" style="height: 23px; width: 200px;">
		   						</td>
							</tr>
							<tr>
								<th style="width: 100px; min-width: 100px; text-align: center;"><spring:message code='ezWebFolder.t153' /></th>
		   						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
		   							<input id="fileNameVal" type="text" style="height: 23px; width: 200px;">
		   						</td>
							</tr>
							<tr>
								<th style="width: 100px; min-width: 100px; text-align: center;"><spring:message code='ezWebFolder.t154' /></th>
		   						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
		   							<input id="fileCreatorVal" type="text" style="height: 23px; width: 200px;">
		   						</td>
							</tr>
		   				</table>
	  					<div style="margin: 12px 50px 12px 180px;">
							<a class="webfolderBttn"><span onclick="startSearch();"    ><spring:message code='ezWebFolder.t123' /></span></a>
	 						<a class="webfolderBttn"><span onclick="openSearchPanel();"><spring:message code='ezWebFolder.t112' /></span></a>
						</div>
  					</div>
	   			</div>
	   		</div> 	 	
	   </div>
	   
	   <div id="mainSetting" style="margin: 10px 0px; height:500px; overflow: auto;">
	   		<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileHistory">
	   			<tr>	   				
					<th width="40px"  ><spring:message code='ezWebFolder.t155' /></th>
					<th width="160px" ><spring:message code='ezWebFolder.t156' /></th>
					<th width="40px"  ><spring:message code='ezWebFolder.t157' /></th>
					<th width="160px" ><spring:message code='ezWebFolder.t154' /></th>
					<th width="60px"  ><spring:message code='ezWebFolder.t158' /></th>
					<th width="140px" style="text-align: center;"><spring:message code='ezWebFolder.t159' /></th>			
	   			</tr>
	   		</table>
	   </div>
	   
	   <div id="tblPageRayer"></div>
	   <script type="text/javascript" src="/js/ezWebFolder/pageNav.js"></script>
	</body>
</html>