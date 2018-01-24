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
			var blockSize   = 10;
			var searchStr   = "";
	    	var searchOpt   = "";
			var currentPage = null;
			var totalUsers	= null;
			var totalPages  = null;
			var strLang39	= "<spring:message code = 'ezWebFolder.t135'/>";
			var strLang40 	= "<spring:message code = 'ezWebFolder.t136'/>";
			var strLang41   = "<spring:message code = 'ezWebFolder.t137'/>";
			var strLang42   = "<spring:message code = 'ezWebFolder.t138'/>";
			
        	window.onresize = function () {
				var divList = document.getElementById("mainSetting");				
				var reheight = document.documentElement.clientHeight - 190;	
				
				if (reheight < 500) {
					divList.style.height = "500px";	
				}
				else {
					divList.style.height = reheight + "px";		
				}
			};
			
			window.onload = function() {
				search_Set("1");
				preProcessing();								
			}	
			
			function preProcessing() {
				var divList = document.getElementById("mainSetting");
				var reheight = document.documentElement.clientHeight - 190;
				divList.style.height = reheight + "px";
			}			
		    
		    function openSearchPanel() {
		    	$("#searchPanel").toggle("1000");
		    	document.getElementById("inputSearch").value = "";
		    	document.getElementById("searchOption").options[0].selected = 'selected';		    			    		    	
		    }
		    
		    function makePageSelPage(){
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + "<span style='color:#017BEC;'> " + totalUsers + " </span>" + strLang42 + "]";
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var pageNum = currentPage;
		        
		        if (totalPages > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg' onClick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPages > blockSize) {
		            if (pageNum > blockSize) {
		                strtext = "<span class='btnimg' onClick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
		            PagingHTML += strtext;
		        }
		        
		        var MaxNum;
		        var i;
		        var startNum = (parseInt((pageNum - 1) / blockSize) * blockSize) + 1;
		        
		        if (totalPages >= (startNum + parseInt(blockSize))) {
		            MaxNum = (startNum + parseInt(blockSize)) - 1;
		        }
		        else {
		            MaxNum = totalPages;
		        }
		        
		        for (i = startNum; i <= MaxNum; i++) {
		            if (i == pageNum) {
		                strtext = "<span class='on'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		            else {
						strtext = "<span onClick='goToPageByNum(" + i + ")'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        
		        if (totalPages > blockSize) {
		        	if (totalPages >= parseInt(((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1)) {
		        	    strtext = "<span class='ptxt' onClick='return selafterBlock_one()'>" + strLang40 + "</span>";
		        	    strtext = strtext + "<span class='btnimg' onClick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
		                PagingHTML += strtext;
		        	}
		        	else {
		                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
		                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
		                PagingHTML += strtext;
		        	}
		        }
		        else {
		            strtext = "<span class='ptxt' onClick='return selafterBlock_one()'>" + strLang40 + "</span>";
		            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPages > 1 && totalPages != 1 && (totalPages != pageNum)) {
		            strtext = "<span class='btnimg' onClick='return goToPageByNum(" + totalPages + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        
		        PagingHTML += "</div>";
		        td_Create1(PagingHTML);
		    }
		    
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		    
		    function goToPageByNum(Value){
		    	currentPage = Value;
		        makePageSelPage();
		        search_Set(currentPage);
		    }
		    
		    function selbeforeBlock(){
		        var pageNum = parseInt(currentPage);
		        pageNum = ((parseInt(pageNum / blockSize) - 1) * blockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    
		    function selbeforeBlock_one(){
		        var pageNum = parseInt(currentPage);
		        if(parseInt(pageNum - 1) > 0)
		            goToPageByNum(parseInt(pageNum - 1));
		        else
		            return;
		    }
		    
		    function selafterBlock(){
		        var pageNum = parseInt(currentPage);
		        pageNum = ((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    
		    function selafterBlock_one(){
		        var pageNum = parseInt(currentPage);
		        if(parseInt(pageNum + 1) <= totalPages)
		            goToPageByNum(parseInt(pageNum + 1));
		        else
		            return;
		    }	    
		    
		    function search_Set(pPage) {		    	
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getCapacities.do",
					data: {
						"currentPage" : pPage,
						"searchStr"	  : searchStr,
						"searchOpt"	  : searchOpt,
						"companyId"   : document.getElementById("companyList").value
					},
					dataType: "JSON",
					async: true,
					success : function(data) {				
						var result = data.capacityList;		
						totalUsers = data.totalUsers;
						totalPages = data.totalPages;
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
				var tableList = document.getElementById("tblFileStorage");
		    	
		    	while (tableList.rows.length > 1) {
		    		tableList.deleteRow(1);
		    	}
		    	
		    	if (result.length == 0) {		    	
		    		var trElmt = document.createElement("tr");
		    		var tdElmt = document.createElement("td");
		    		tdElmt.setAttribute("colspan", "8");
		    		tdElmt.setAttribute("align", "center");
		    		tdElmt.setAttribute("bgcolor", "#FFFFFF");
		    		tdElmt.innerHTML = "Data not found!";
		    		
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
		    			var tdElmt7 = document.createElement("td");
		    			var tdElmt8 = document.createElement("td");
		    			
		    			trElmt.setAttribute("class", "bnkWebFolder");
		    			
		    			var inputElmt = document.createElement("input");
		    			inputElmt.setAttribute("type", "checkbox");
		    			inputElmt.setAttribute("value", "0");
		    			inputElmt.onchange = function() {getChecked(this);};		    			
		    			tdElmt1.appendChild(inputElmt);
		    			
		    			tdElmt2.setAttribute("style","overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
		    			tdElmt2.textContent = result[i]["companyName"];
		    			
		    			tdElmt3.setAttribute("style","overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
		    			tdElmt3.textContent = result[i]["departmentName"];
		    			
		    			tdElmt4.setAttribute("style","overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
		    			tdElmt4.textContent = result[i]["userName"];
		    			
		    			tdElmt5.setAttribute("style","overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;");
		    			tdElmt5.textContent = result[i]["jobTitle"];
		    			
		    			tdElmt6.setAttribute("style","text-align: center;");
		    			tdElmt6.textContent = result[i]["totalUsed"];
		    			
		    			tdElmt7.setAttribute("style","text-align: center;");
		    			tdElmt7.textContent = result[i]["totalCapacity"];
		    			
		    			tdElmt8.setAttribute("style","white-space:nowrap; text-align:center;");
		    			
		    			var span = document.createElement("span");
				        span.className = "workProgressBar";				 			        
				        span.innerHTML += "<span class='bar' usedrate='rategrogressBar" + i + "'></span>&nbsp;";			        

						var span2 = document.createElement("span");
				        span2.style.display = "inline-block";
				        span.appendChild(span2);	        				        				        
				        tdElmt8.appendChild(span);
				        
				        trElmt.appendChild(tdElmt1);
				        trElmt.appendChild(tdElmt2);
				        trElmt.appendChild(tdElmt3);
				        trElmt.appendChild(tdElmt4);
				        trElmt.appendChild(tdElmt5);
				        trElmt.appendChild(tdElmt6);
				        trElmt.appendChild(tdElmt7);
				        trElmt.appendChild(tdElmt8);
				        tableList.appendChild(trElmt);
				        
				        initProgressBar("rategrogressBar" + i, "3", result[i]["usedRate"]);
		    		}
		    	}
		    }
		    
		    function initProgressBar(barID, color, completerate) {
				if (completerate == '0') {
					duration = 0;
				} else {
					duration = 500;
				}

				if (color == '1') {
					$(".bar[usedrate='" + barID + "']").find("div[class=percentCount]").css("color", delayColor);
					$(".bar[usedrate='" + barID + "']").LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: delayColor,
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '70%',
						duration : duration
					});
				} else if (color == '2') {
					$(".bar[usedrate='" + barID + "']").LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: completeColor,
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '70%',
						duration : duration
					});
				} else {
					$(".bar[usedrate='" + barID + "']").LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: '#3498db',
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '70%',
						duration : duration
					});
				}
			}
		    
		    function change() {
		    	searchStr = "";
		    	searchOpt = "";
		    	search_Set("1");
		    }
		    
		    function startSearch() {
		    	var inputVal = document.getElementById("inputSearch").value;
		    	
		    	if (!inputVal.replace(/\s/g,'')) {
		    		alert("입력하세요.");
		    		document.getElementById("inputSearch").value = "";
		    		document.getElementById("inputSearch").focus;
		    		return;
		    	}
		    	
		    	searchStr = inputVal;
		    	searchOpt = document.getElementById("searchOption").value;
		    	openSearchPanel();
		    	search_Set("1");
		    }

	    </script>
	</head>
	<body class="mainbody">
	   <h1>
	   		<spring:message code='ezWebFolder.t103' />
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
	   
	   <div style="position: relative; height: 27px; margin-bottom: 10px;">
	   		<div style="position: relative;">
	   			<a id="btnSearch" class="webfolderBttn2" onClick="openSearchPanel();"><span><spring:message code='ezWebFolder.t123' /></span></a>
	   			<img src="/images/i_bar.gif" style="margin-left: 2px;" />
	   			<a id="btnRefresh" class="webfolderBttn2" onClick="change();"><span><spring:message code='ezWebFolder.t139' /></span></a>
	   			<div id="searchPanel" style="position: absolute; top: 37px; left: 0px; height: 80px; width: 500px; border: 1px solid #666666; z-index: 10; background-color: #f2f2f2; display: none;">
	   				<div style="margin: 10px;">
		   				<table style="border-collapse: collapse; width: 100%;">
		   					<tr>
		   						<th style="width: 100px; min-width: 100px;">검색대상</th>
		   						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 358px; width: 358px;">
		   							<select id="searchOption" style="margin-left: 10px;">
		   								<option value="deptName">부서명</option>
							   			<option value="userName">사용자</option>
		   							</select>
		   							<input id="inputSearch" type="text" style="width: 270px; height: 23px; margin: 2px 5px; padding: 0px 5px; border-radius: 3px; border: 1px solid #ccc;">
		   						</td>
		   					</tr>
		   					<tr>
		   						<td colspan="2">
		   							<div style="margin: 9px 50px 9px 160px;">
		   								<a class="webfolderBttn"><span onclick="startSearch();">검색</span></a>
			   							<a class="webfolderBttn"><span onclick="openSearchPanel();">취소</span></a>
		   							</div>
		   						</td>
		   					</tr>
		   				</table>
	   				</div>
	   			</div>
	   		</div>	   		
	   		<div style="position: absolute; top: 0px; right: 2px; height: 27px;">	   			
   				<span style="height: 20px; line-height: 20px; display: inline; font-size: 14px;">용량 설정:</span>
   				<input id="storageVal" type="text" style="width: 100px; height: 27px; border-radius: 5px; border: 1px solid #b3b3b3; margin-right: 3px; padding-left: 5px;"  placeholder="용량GB"/>
   				<a id="btnChange" class="webfolderBttn2" onClick="changeStorageVal();"><span><spring:message code='ezWebFolder.t124' /></span></a>
   				<a id="btnBack" class="webfolderBttn2" onClick="changeToDefault();"><span><spring:message code='ezWebFolder.t125' /></span></a>   						
	   		</div>	   	 	
	   </div>
	   
	   <div id="mainSetting" style="margin: 10px 0px;">
	   		<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileStorage">
	   			<tr>
	   				<th width="10px"><input type="checkbox" onchange="getCheckAll(this);"></th>
					<th width="80px" style="">회사명</th>
					<th width="80px" style="">부서명</th>
					<th width="200px" style="">사용자</th>
					<th width="40px" style="">직급</th>
					<th width="80px" style="text-align: center;">사용량</th>
					<th width="80px" style="text-align: center;">총용량</th>
					<th width="60px" style="text-align: center;">사용률</th>
	   			</tr>	   			
	   		</table>
	   </div>
	   
	   <div id="tblPageRayer"></div>
	</body>
</html>