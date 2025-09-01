<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="width:100%;">
	<head>
		<title><spring:message code="ezPoll.t229" /></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezPoll/sort.css')}" type="text/css">	
		
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPoll/stomp.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPoll/sockjs.min.js')}"></script>				
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
				
		<script type="text/javascript">	
			var strLang39		  = "<spring:message code = 'ezPoll.t167'/>";
			var strLang40 		  = "<spring:message code = 'ezPoll.t168'/>";
			var strLang41 		  = "<spring:message code = 'ezPoll.t169'/>";
			var strLang42 		  = "<spring:message code = 'ezPoll.t170'/>";
			var currentPage		  = "<c:out value='${currPage}'/>";
			var totalPages 		  = "<c:out value='${totalPages}'/>";
		    var totalQuestions 	  = "<c:out value='${totalQuestions}'/>";
		    var blockSize 		  = 10;
		    var status_processing = "<spring:message code = 'ezPoll.t101'/>";
		    var status_finish 	  = "<spring:message code = 'ezPoll.t102'/>";
			var brdID			  = "<c:out value='${brdID}'/>";
			var primary 		  = "<c:out value='${primary}'/>";
			var searchParam	  	  = "<c:out value='${strSearch}'/>";
			var radioBttn		  = "<c:out value='${mode}'/>";
			var userID 			  = "<c:out value='${userID}'/>";
			var seeCheck 		  = "<c:out value='${seeCheck}'/>";
			//var deleteBttn 	  = "<c:out value='${deleteBttn}'/>";
			var checkedArr		  = [];					
			var chkDelete		  = 0;
			var tenantId		  =  "<c:out value='${tenantID}'/>";
			var admin 			  = "<c:out value='${adminPrivilege}'/>";
			var stompClient 	  = null;
		    
		    window.onunload = function() {
    		    if (stompClient !== null) {
    		        stompClient.disconnect();
    		    }
        	}; 
        	
        	window.onresize = function () {
				var divList = document.getElementById("divList");				
				var reheight = document.documentElement.clientHeight - 170;	

				if (reheight < 500) {
					divList.style.height = "500px";	
				}
				else {
					divList.style.height = reheight + "px";		
				}
			};
		   
			window.onload = function() {
				preProcessing();				
				makePageSelPage();
				getConnect();
				paginationProcess();
				creatorResultAlert();
				
				/* 2020-02-05 홍승비 - 현재 진입한 투표 리스트 종류에 맞는 좌측메뉴가 하이라이트되도록 수정 */
				selectPollMenuNode("<c:out value='${pollType}'/>");
			}
			
			function getConnect() {
			    var socket = new SockJS('/hello');
			    stompClient = Stomp.over(socket);
			    stompClient.connect({}, function (frame) {
			        stompClient.subscribe('/reply/qstDeleteForTenant' + tenantId, function (updatedInfo) {			       
			        	var ret = JSON.parse(updatedInfo.body).result;	
						if (ret == "DELETED"){
							//reload page
							var _params = getParameters();
		    				var szUrl = "/ezPoll/pollList.do?brdID=" + brdID + _params;
							//document.location.href = "/ezPoll/pollList.do?brdID=6&paging=" + currentPage;
		    				document.location.href = szUrl;
						}
				    });
			    });
			}
			
			function preProcessing() {
				var divList = document.getElementById("divList");				
				var reheight = document.documentElement.clientHeight - 170;	
				divList.style.height = reheight + "px";				
				
				//Uncheck all checkboxes after reload for firefox
		    	$(':checkbox:checked').removeAttr('checked');
			}
		    
		    function menuQst_DetailUserInfo(pUserID, pDeptID) {
		    	 var feature = GetOpenPosition(420, 450);
		         window.open("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }	
		    
		    function menu_Search() {
		    	var checkSeeAll = 0;
		    	var search_str = "";
		    	var mode = document.getElementById("selectType").value;
		    	var pollType = $("input[name=processCheck]:checked").val(); //2017-12-22
		    	//if ($("input[name=searchCheck]:checked").val() == ) {}
		    	
/* 		    	if ($('#seeAll').is(':checked')) {
		    		checkSeeAll = 1;
		    	}	 */
		    	
		    	if (document.getElementById("searchInput").value != null) {
		    		search_str = document.getElementById("searchInput").value;
		    	}
		    	
		        var szUrl = "/ezPoll/pollList.do?brdID=" + brdID + "&search=" + search_str + "&see=" + checkSeeAll + "&mode=" + mode + "&currPage=" + currentPage + "&pollType=" + pollType;
		        window.location.href = szUrl;
		    }
		    
		    function getCheckAll(t) {
		    	var listInputs = document.getElementsByClassName("checkBnk");
		    	
		    	if ($(t).is(':checked')) {      		
		    		for (var i = 0; i < listInputs.length; i++) {
		    			listInputs[i].checked = true;
		    			checkedArr.push(listInputs[i].value);
		    			
		    			var creator = "creator" + listInputs[i].value;
		    			
						if (document.getElementById(creator).value != userID && admin == 0) {
							chkDelete = 1;
						}		    		
		    		}		    		
		    	}
		    	else {
		    		for (var i = 0; i < listInputs.length; i++) {
		    			listInputs[i].checked = false;		    			    		
		    		}	
		    		
		    		checkedArr = [];
		    		chkDelete = 0;
		    	}

		    }
		    
		    function getChecked(t) {			    	
		    	if ($(t).is(':checked')) {    				    		
		    		checkedArr.push($(t).val());
		    		var creator = "creator" + $(t).val();
		    		
					if (document.getElementById(creator).value != userID && admin == 0) {
						chkDelete = 1;
					}		    		
		    	}
		    	else {
		    		var test = checkedArr.indexOf($(t).val());
		    		chkDelete = 0;
		    		
		    		if (test != -1) {
		    			checkedArr.splice(test, 1);
		    		}
		    		
		    		for (var i = 0; i < checkedArr.length; i++) {
		    			var creator = "creator" + checkedArr[i];
			    		
						if (document.getElementById(creator).value != userID && admin == 0) {
							chkDelete = 1;
						}		    				
		    		}
		    	}
		    }
		    
		    function menu_Hide() {
		    	if (checkedArr.length == 0) {
		            alert('<spring:message code="ezPoll.t242" />');
		            return;
		    	}
		    	
		    	var _params = getParameters();	
		    	var checkedList = checkedArr[0];
		    	
	    		for (var i = 1; i < checkedArr.length; i++) {
	    			checkedList = checkedList + "," + checkedArr[i];	    			
	    		}
	    		
	    		var szUrl = "/ezPoll/pollList.do?brdID=" + brdID + "&hide=" + checkedList + _params; 		
	    		window.location.href = szUrl;
		    }
		    
		    function selectCheck() {
		    	var _params = getParameters();
		    	var szUrl = "/ezPoll/pollList.do?brdID=" + brdID + _params; 
		    	window.location.href = szUrl;
		    	goToPageByNum(1); //필터 라디오버튼을 누를 경우 1페이지로 선택하게 함.
		    }
		    
		    function getParameters() {
		    	var checkSeeAll = 0;
		    	var _searchPrm = document.getElementById("searchInput").value;
		    	var mode1 = document.getElementById("selectType").value;
		    	var pollType = $("input[name=processCheck]:checked").val(); //2017-12-22
				
		    	/* if (document.getElementById("seeAll").checked) {
		    		checkSeeAll = 1;
		    	}	 */
		    	
		    	return "&see=" + checkSeeAll + "&currPage=" + currentPage + "&mode=" + radioBttn + "&search=" + searchParam + "&mode1=" + mode1 + "&searchN=" + _searchPrm + "&pollType=" + pollType; //2017-12-22

		    }
		    
 		    function menu_Show() {
		    	if (checkedArr.length == 0) {
		            alert('<spring:message code="ezPoll.t243"/>');
		            return;
		    	}	
		    	var _params = getParameters();
		    	var checkedList = checkedArr[0];
		    	
	    		for (var i = 1; i < checkedArr.length; i++) {	    			
	    			checkedList = checkedList + "," + checkedArr[i];	    			
	    		}
	    		
	    		var szUrl = "/ezPoll/pollList.do?brdID=" + brdID + "&listQst=" + checkedList + _params;
		    	window.location.href = szUrl;		    	
		    }
 		    
 		    function menu_Insert() {
 		    	window.parent.document.querySelector("iframe[name=right]").src = "/ezPoll/pollCreate.do?brdID=6";
 		    }
		    
		    function menu_Delete() {
		    	if (checkedArr.length == 0) {
		            alert('<spring:message code="ezPoll.t239"/>');
		            return;
		    	}

		    	if (chkDelete == 1) {
		            alert('<spring:message code="ezPoll.t141"/>');
		            return;
		    	}	
		    	
	    		var feature = GetOpenPosition(420, 438);
		    	var checkedList = checkedArr[0];
		    	//var id = "tlt" + checkedArr[0];		
		    	//var qstTitleList = document.getElementById(id).innerHTML;
		    	
	    		for (var i = 1; i < checkedArr.length; i++) {	    			
	    			checkedList = checkedList + "," + checkedArr[i];
	    			//qstTitleList = qstTitleList + "," + document.getElementById("tlt" + checkedArr[i]).innerHTML;
	    		}
	    		
	    		//qstTitleList = encodeURIComponent(qstTitleList);

		        //var w = window.open("/ezPoll/confirmDeleteQuestion.do?brdID=" + brdID + "&listQst=" + checkedList + "&listQstContent=" + qstTitleList, "", "height=310px,width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		        var w = window.open("/ezPoll/confirmDeleteQuestion.do?brdID=" + brdID + "&listQst=" + checkedList, "", "height=310px,width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		        w.focus();
		    }
		    
/* 		    function popupClosing() {    	
		    	document.location.href = "/ezPoll/pollList.do?brdID=6";
		    } */
		    
		    function title_OnClick(pReceve) {
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezPoll/checkPoll.do",
		    		data : {
		    			qstId : pReceve
		    			
		    		},
		    		success: function(data) {	
						var result = JSON.parse(data).result;					
						
						if (result == "Normal") {
							var list_params = "";
							var checkSeeAll = 0;
					    	var _searchPrm = document.getElementById("searchInput").value;
					    	var mode1 = document.getElementById("selectType").value;
					    	var pollType = $("input[name=processCheck]:checked").val(); //2017-12-22
					    	
/* 					    	if (document.getElementById("seeAll").checked) {
					    		checkSeeAll = 1;
					    	} */
					    	
					    	list_params += currentPage + "," + checkSeeAll + "," + radioBttn + "," + mode1 + "," + pollType;
							
							document.location.href = "/ezPoll/pollVote.do?brdId=" + brdID + "&qstId=" + pReceve + "&params=" + list_params + "&search=" + searchParam + "&searchN=" + _searchPrm;
						}
						else {
							alert("<spring:message code = 'ezPoll.t233'/>");
							var _params = getParameters();
			            	document.location.href = "/ezPoll/pollList.do?brdID=6" + _params;
						}
			        },
			        error: function(error) {
			        	//alert(error);
			        }
		    	});
		    }
		    
		    function check_key(event) {
		    	if (event.which == 13) {
		    		menu_Search();
		    	}
		    }
		    
			function makePageSelPage(){
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        document.getElementById("mailBoxInfo").innerHTML = "&nbsp;<span class='txt_color'>" + totalQuestions + "</span>";
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var pageNum = currentPage;
		        
		        if (totalPages > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg first' onClick= 'return goToPageByNum(1)'></span>";
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg first disabled'></span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPages > blockSize) {
		            if (pageNum > blockSize) {
		                strtext = "<span class='btnimg prev' onClick= 'return selbeforeBlock()'></span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span class='btnimg prev disabled'></span>";
		                PagingHTML += strtext;
		            }
		        }
		        else {
		            strtext = "<span class='btnimg prev disabled'></span>";
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
		        
		        if(MaxNum == 0){
		        	PagingHTML += "<span class='on'>1</span>"
		        } else {
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
		        }
		        
		        if (totalPages > blockSize) {
		        	if (totalPages >= parseInt(((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1)) {
		        	    strtext = "";
		        	    strtext = strtext + "<span class='btnimg next' onClick='return selafterBlock()'></span>";
		                PagingHTML += strtext;
		        	}
		        	else {
		                strtext = "";
		                strtext = strtext + "<span class='btnimg next disabled'></span>";
		                PagingHTML += strtext;
		        	}
		        }
		        else {
		            strtext = "";
		            strtext = strtext + "<span class='btnimg next disabled'></span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPages > 1 && totalPages != 1 && (totalPages != pageNum)) {
		            strtext = "<span class='btnimg last' onClick='return goToPageByNum(" + totalPages + ")'></span>";
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg last disabled'></span>";
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
		    	var g_BrdID = "6";		    	
		    	var _params = getParameters();
		    	
				if (pPage != "" && pPage != "0" && parseInt(pPage) > 0 && parseInt(pPage) <= parseInt(totalPages)) {
					var szUrl = "/ezPoll/pollList.do?brdID=" + g_BrdID + _params;			
					window.location.href = szUrl;
				}
			}
		    
		    function creatorResultAlert(){
		    	var resultFirst = "${resultFirst}" + "";
		    	if(resultFirst === "2"){
					setTimeout(function() {
			    		alert("<spring:message code = 'ezPoll.hdp08'/>");
					}, 100);
		    	}
		    }
		    
		    //목록 버튼 눌렀을 때, 해당 필터와 페이지로 보여주기 위함.
		    function paginationProcess(){
		    	var pollType = "<c:out value='${pollType}'/>";
				var gotoList = ${gotoList};
				if(gotoList === 1){
					pollType = pollType == 0 ? 1 : pollType;
					document.querySelector("input[value='"+ pollType +"']").checked = true;
				}
		    }
		    
		    /* 2020-02-05 홍승비 - pollType에 따라서 좌측메뉴의 하이라이트를 변경하는 함수 */
		    function selectPollMenuNode(pollType) {
				var leftFrame = window.parent.document.getElementsByName("left")[0].contentWindow.document;
				var selectedPollMenu = $(leftFrame).find(".node_selected[pollid='" + pollType +"']");
				
				if (selectedPollMenu.length == 0) { // 현재 투표 리스트 타입과 선택된 좌측메뉴가 다른 경우에만 진행
	        		$(leftFrame).find(".node_selected").attr("class","node_normal");
	        		$(leftFrame).find(".node_normal[pollid='" + pollType +"']").attr("class","node_selected");
				}
		    }
		    
		</script>
	</head>
	<body class="mainbody" style="min-width: 750px;">
		<h1 id="pollMainName">
		<c:choose>
			<c:when test="${pollType eq '2' }">
				<spring:message code="ezPoll.psb256"/>
			</c:when>
			<c:when test="${pollType eq '1' }">
				<spring:message code="ezPoll.hdp18"/>
			</c:when>
			<c:when test="${pollType eq '4' }">
				<spring:message code="ezPoll.psb257"/>
			</c:when>
			<c:when test="${pollType eq '3' }">
				<spring:message code="ezPoll.psb258"/>
			</c:when>
		</c:choose>
			<span id="mailBoxInfo"></span>
			<span class="searchForm">
				<select id="selectType" class="text">
					<c:if test="${mode1 != 'wri'}">
						<option name="searchCheck" id="radio1" value="sub" selected> <span><spring:message code="ezPoll.t106"/></span>
						<option name="searchCheck" id="radio2" value="wri" > <span><spring:message code="ezPoll.t107"/></span>
					</c:if>
					<c:if test="${mode1 == 'wri'}">
						<option name="searchCheck" id="radio1" value="sub" > <span><spring:message code="ezPoll.t106"/></span>
						<option name="searchCheck" id="radio2" value="wri" selected> <span><spring:message code="ezPoll.t107"/></span>
					</c:if>
				</select>
					<!-- <input type="text" name="searchInput" id="searchInput" style="height:25px; padding:0px 6px; border:1px solid #d0d0d0;" > -->					
					<%-- <a class="pollImgbtn" onClick="menu_Search()" ><span style="height: 23px;"><spring:message code="ezPoll.t227"/></span></a> --%>
					<input type="text" class="searchinputBox" style="height: 27px !important; border : 1px solid #cbcbcb !important;" name="searchInput" id="searchInput" onkeypress="check_key(event);" value="<c:out value='${strSearch1}'/>">
					<a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onclick="menu_Search()"></a>
			</span>
		</h1>
		<div id="mainmenu">
			<ul>
<%-- 				<li>
					<input type="text" name="searchInput" id="searchInput" style="height:25px; padding:0px 6px; border:1px solid #d0d0d0; border-radius:3px;" >
					<a class="pollImgbtn" onClick="menu_Search()" style="margin-top: 3px;"><span><spring:message code="ezPoll.t227"/></span></a>
				</li> --%>
				<li class="important" id="btnInsert"><span onClick="menu_Insert()"><spring:message code="ezPoll.t144"/></span></li>
				<li id="btnDel" style="display: ${(deleteBttn == 1 || adminPrivilege == 1) ? 'block' : 'none'}"><span class="icon16 icon16_delete" onClick="menu_Delete()"></span></li>
				<%--<li id="btnHid"><a onClick="menu_Hide()" style="margin-top: 3px;"><span><spring:message code="ezPoll.t203"/></span></a></li>
				<li><a onClick="menu_Show()" style="margin-top: 3px;"><span ><spring:message code="ezPoll.t204"/></span></a></li>				
				<li><input id="seeAll" type="checkbox" style="float:left; margin:6px 4px 0px 5px;"><spring:message code="ezPoll.t205" /></li> --%>
				<li style="display:none; float:right; font-weight:normal; color:black; padding-right: 5px; border:0px; background: white;">
					<input id="btnRadio1" type="radio" name="processCheck" style="vertical-align:middle; padding-right: 20px;" onclick="selectCheck()" value="3" ${pollType == '3'? 'checked' : ''} >
					<label for="btnRadio1"><spring:message code='ezPoll.t145' /></label>					
				</li>
				<li style="display:none; float:right; font-weight:normal; color:black; border:0px; background: white;">
					<input id="btnRadio2" type="radio" name="processCheck" style="vertical-align:middle;" onclick="selectCheck()" value="2" ${pollType == '2'? 'checked' : ''}>
					<label for="btnRadio2"><spring:message code='ezPoll.t146' /></label>					
				</li>
				<li style="display:none; float:right; font-weight:normal; color:black; border:0px; background: white;">
					<input id="btnRadio4" type="radio" name="processCheck" style="vertical-align:middle;" onclick="selectCheck()" value="4" ${pollType == '4'? 'checked' : ''}>
					<label for="btnRadio4"><spring:message code='ezPoll.t251' /></label>		
				</li>
				<li style="display:none; float:right; font-weight:normal; color:black; border:0px; background: white;">
					<input id="btnRadio3" type="radio" name="processCheck" style="vertical-align:middle;" onclick="selectCheck()" value="1" ${pollType == '1'? 'checked' : ''}>
					<label for="btnRadio3"><spring:message code='ezPoll.t237' /></label>		
				</li>
				
			</ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>	
			 
		<div class="div_scroll" style="width:100%; height:500px; overflow: auto" id="divList">
			<table id="QstList" class="mainlist" style="width:100%;"> 
			    <tr> 
					<th width="20px" align="center"> <%-- <spring:message code="ezPoll.t105"/> --%>
						<input type="checkbox" id="checkAll" style="margin: 0px; padding: 0px; width: 13px; height: 13px;" onchange="javascript:getCheckAll(this)">
					</th> 
<!-- 					<th width="20px"><img src="/images/ImgIcon/view-importance.gif" border="0"></th> -->
					<th width="400px"><spring:message code="ezPoll.t106"/></th> 
					<th width="60px"><spring:message code="ezPoll.t104"/></th> 					
					<th width="90px"><spring:message code="ezPoll.t107"/></th> 
					<th width="60px"><spring:message code="ezPoll.t108"/></th>
					<th width="80px"><spring:message code="ezPoll.t160"/></th> 
					<th width="80px"><spring:message code="ezPoll.t161"/></th> 
					<th width="60px"><spring:message code="ezPoll.t109"/></th>			
			    </tr>
			 	<c:forEach var="list" items="${list}"> 
			        <tr id="${list.qstId}" class="white">
			        	<td style="padding:0"> <input type="checkbox" class="checkBnk" id="qstCheck+<c:out value ="${list.qstId}" />+" value=<c:out value="${list.qstId}" />  onchange="javascript:getChecked(this)"></td>
			        	
<!-- 			        	<td>			        	 -->
<%-- 							<c:if test="${list.isHidden == 1}"> --%>
<!-- 								<img src="/images/ImgIcon/icon-highimportance.gif" border="0"> -->
<%-- 							</c:if>						 --%>
<!-- 			        	</td> -->
			        	 
			          	<td id="tlt<c:out value ="${list.qstId}" />" style="overflow: hidden; cursor: pointer; text-overflow: ellipsis; white-space: nowrap;" title="<c:out value ="${list.title}"/>" onClick="title_OnClick('<c:out value ="${list.qstId}"/>')" >
				          	<c:out value ="${list.title}"/>
				          	<c:if test="${list.cmtCnt > 0}">
				          		<span class="voteCmtCnt">[<c:out value ="${list.cmtCnt}"/>]</span>
				          	</c:if>
			          	</td>
			          	
			          	<%-- Question status --%>
						<c:if test="${list.status == 0}">
							<td><spring:message code="ezPoll.t145"/></td>
						</c:if>
						<c:if test="${list.status == 1}">
							<td><spring:message code="ezPoll.t146"/></td>
						</c:if>
						<c:if test="${list.status == 2}">
							<td><spring:message code="ezPoll.t251"/></td>
						</c:if>
						
			          	<%-- Creator --%>
		          		<c:choose>
							<c:when test="${primary == '1'}">
								<td> <a id="test<c:out value ="${list.qstId}" />" style="cursor:pointer" onClick="menuQst_DetailUserInfo('${list.creator}','${list.creatorDept}')"> ${list.creatorName1} </a> </td>
							</c:when>
							<c:otherwise>
								<td> <a id="test<c:out value ="${list.qstId}" />" style="cursor:pointer" onClick="menuQst_DetailUserInfo('${list.creator}','${list.creatorDept}')"> ${list.creatorName2} </a> </td>
							</c:otherwise>
						</c:choose>	
			          	
			          	<%-- CreatorID --%>
			          	<td style="display:none"><input type="text" id="creator<c:out value ="${list.qstId}" />" value=<c:out value="${list.creator}"/> style="display:none"> </td>
			          	
			          	<%-- Target --%>
			          	<c:if test="${list.target == 0}">
			          		<td><spring:message code = 'ezPoll.t237'/></td>	
			          	</c:if>
			          	<c:if test="${list.target == 1}">
			          		<td><spring:message code = 'ezPoll.t238'/></td>	
			          	</c:if> 
			          	
			          	<%-- Start date--%>
			          	<c:set var="pollStartDate" value="${list.startDate}"/>
			          	<td> ${fn:substring(pollStartDate,0,10) } </td>
			          	
			          	<%-- End date--%>
			          	<c:set var="pollEndDate" value="${list.endDate}"/>
			          	<td> ${fn:substring(pollEndDate,0,10) } </td>			          	
			          	
			          	<%-- Secret setting --%>
			          	<c:if test="${list.secretVote == 0}">
			          		<td><spring:message code = 'ezPoll.t240'/></td>	
			          	</c:if>
			          	<c:if test="${list.secretVote == 1}">
			          		<td><spring:message code = 'ezPoll.t111'/></td>	
			          	</c:if>			          	

			        </tr>
		        </c:forEach>
		        
			    <c:if test="${list.size() == 0}"> 
			        <tr> 
						<td colspan="8" align="center"  bgcolor="#FFFFFF"> <spring:message code="ezPoll.t241" /></td>
		       		</tr> 
		        </c:if> 
			</table> 
			<div style="display:none">
				<input type="text" name="hiddenSeeAll" id="hiddenSeeAll" value="" style="display:none">
			</div>
		</div>
		 
		<div id="tblPageRayer"></div>
	</body>
</html>