<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1'/>" type="text/css">
		<link href="/css/previewmail.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezBoard/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezBoard/PreviewItem.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>
		<!-- data picker-->
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
		
	    <style>
	    	#layer_Viewpopup { 
			z-index:1000; 
			margin:0px; 
			padding:0px;
			}
			#layer_Viewpopup .popupwrap1 {
				border:1px solid #555a64;
				padding:0px;
				margin:0px;
				
			}
			#layer_Viewpopup .shadow {
				height:2px;
				background:#d7d7d7;
				
			}
			#layer_Viewpopup .popupwrap2 {
				border:2px solid #e5e5e5;
				padding:10px;
				
			}
			#layer_Viewpopup .btn_area { border-top:1px solid #e5e5e5; margin:10px 0px 0px 0px; padding:10px 0px 0px;}
			
			#layer_Viewpopup .popupwrap3 {
				position:relative;
				padding:10px;
				background:url("../images/kr/cm/popup_layerbg.gif") repeat-x;
			}
			#layer_Viewpopup .popupwrap3 h1 {
				font-size:13px;margin:0px 0px 10px 0px;height:24px; line-height:15px; padding:0px;color:#fff; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;
			}
			#MailListRayer tr:not(.selectTR):hover{
				background-color: rgb(244,245,245);
			}
			.selectTR{
				background-color: rgb(233, 241, 255);
			}
	    </style>
	    
		<script  type="text/javascript">
			var listType = "${listType}";
			var typeId = "${typeId}";
			var pAdminType  = "n";
			var currentPage = 1;
			var listCnt = "${journalEnv.listCnt}";
			var pPreviewShow_HOW = "${journalEnv.viewenv}";
			var searchWriter = "";
			var searchTitle = "";
			var searchFormName = "";
			var searchStartDate = "";
			var searchEndDate = "";
			var orderNum; 
			var orderHow;
			var PreviewH_Move = false;
			var PreviewW_Move = false;
			var isPreviewChange = false;
			var g_bPrevShow=false;
			var selobj=null;
			var onclickFlag = false;
			var previewType = "TEXT";
		    var clickPreviweType = "TEXT";
		    var CurrentHeight = 0;
		    var CurrenWidth = 0;
		    var pMailListHeightW = 0;
		    var pMailPreHeightW = 0;
		    var pMailListDiv = 0;
		    var pMailPreVDiv = 0;
		    var pMailListWidthH = 0;
		    var pMailPreWidthH = 0;
		    var pMailListDiv_H = 0;
		    var pMailPreVDiv_H = 0;
		    var normal=null;
			
			window.onresize = function ()
		    {
		        MailOptionHidden();
		        journalPreviewRayerChange(pPreviewShow_HOW)
// 		        Window_resize();
		    };
			
			//업무일지 리스트 뿌리기
			function setJournalList(){
				var url = "/ezJournal/journalList.do";
				var jsonParam={};
				jsonParam["listType"]=listType;
				jsonParam["formId"]=$("#formId").val();
				jsonParam["typeId"]=typeId;
				jsonParam["currentPage"]=currentPage;
				jsonParam["listCnt"]=listCnt;
				jsonParam["deptId"]=$("#dept").val();
				jsonParam["writerName"]=searchWriter;
				jsonParam["journalTitle"]=searchTitle;
				jsonParam["formName"]=searchFormName;
				jsonParam["startDate"]=searchStartDate;
				jsonParam["endDate"]=searchEndDate;
				jsonParam["orderNum"]=orderNum;
				jsonParam["orderHow"]=orderHow;
				
				$.ajax({
	   				type:"post",
	   				contentType:'application/json',
	   				dataType:"html",
	   				data:JSON.stringify(jsonParam),
	   				url:url,
	   				success: function(result){
	   					$("#MailListRayer").html(result);
	   					journalPreviewRayerChange("${journalEnv.viewenv}");
	   					setInitOrder();
	   				}
	   			});
			}
			
			//표현 리스트 갯수 변경시
			function goToPageByListCnt(elem){
				listCnt = $(elem).val();
				$.ajax({
	   				type:"post",
	   				data:{listCnt:listCnt},
	   				url:"/ezJournal/saveJournalEnv.do",
	   				success: function(result){
	   					setJournalList();
	   				}
	   			});
			}
			
			//페이지 번호에 의한 셋팅
			function goToPageByNum(page){
				currentPage=page;
				setJournalList();
			}
			
			//양식명에 의한 셋팅
			function goToPageByFormName(){
				currentPage=1;
				searchWriter = "";   
				searchTitle = "";    
				searchFormName = ""; 
				searchStartDate = "";
				searchEndDate = "";  
				setJournalList();
			}
			
			//검색에 의한 셋팅
			function goToPageBySearch(){
				searchWriter = document.getElementById("searchWriter").value;   
				searchTitle = document.getElementById("searchTitle").value;    
				searchFormName = document.getElementById("searchFormName").value;
				searchStartDate = document.getElementById("Sdatepicker").value;
				searchEndDate = document.getElementById("Edatepicker").value;
				setJournalList();
				BoardSearchOptionHidden();
				SearchOptionHidden();
			}
			
			//상세검색 레이어팝업
			function doLayerPopup(obj) {
				$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
	        	
	        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	        	
	        	$("#srarchpopup").css("left", popupX);
	        	
				$("#srarchpopup").modal();
// 		        if (obj.getAttribute("mode") == "off") {
// 		            document.getElementById("layer_popup").style.left = "10px";
// 		            if (pAdminType == "y")
// 		                document.getElementById("layer_popup").style.top = "56px";
// 		            else
// 		                document.getElementById("layer_popup").style.top = "100px";
// 		            document.getElementById("layer_popup").style.display = "";           
// 		            obj.setAttribute("mode", "on");
// 		        }
// 		        else {
// 		            BoardSearchOptionHidden();
// 		        }
		    }
			function btn_PostDate_Clear() {
		        $("#Sdatepicker").val("");
		        $("#Edatepicker").val("");
		
		    }
			function BoardSearchOptionHidden() {
				btn_PostDate_Clear();
				document.getElementById("searchWriter").value = "";
				document.getElementById("searchFormName").value = "";
		        document.getElementById("searchTitle").value = "";
		        document.getElementById("layer_popup").style.display = "none";
		        document.getElementById("SearchOption").setAttribute("mode", "off");
		        SearchOptionHidden();
		    }
			
			//부서에 의한 페이지 세팅
			function goToPageByDeptId(){
				currentPage=1;
				searchWriter = "";   
				searchTitle = "";    
				searchFormName = ""; 
				searchStartDate = "";
				searchEndDate = "";  
				setFormName();
				setJournalList()
			}
			
			//tr선택시
			function selectedTR(elem){
				var parent = $(elem).parent();
				$("#BoardList tr").removeClass("selectTR");
				$("#BoardList tr").find("input[type='checkbox']").removeProp("checked");
	   			$(parent).addClass("selectTR");
	   			$(parent).find("input[type='checkbox']").prop("checked","true");
	   			if (pPreviewShow_HOW=='W' || pPreviewShow_HOW=='H') {
					
				}
			}
			
			//서렉트박스 전체선택 혹은 해제
			function selectedAllTR(elem){
				if($(elem).is(":checked")){
					 $('input:checkbox[name="journalCheckbox"]').each(function() {
						 $(this).prop("checked","true");
						 $(this).parent().parent().addClass("selectTR");
					 });
				} else {
					 $('input:checkbox[name="journalCheckbox"]').each(function() {
						 $(this).removeProp("checked","true");
						 $(this).parent().parent().removeClass("selectTR");
					 });
				}
			}
			
			//양식명 세럭트박스 만들기
			function setFormName(){
				var url = "/ezJournal/journalListMainFormList.do?typeId="+typeId;
				if(listType == "department"){
					url += "&deptId="+$("#dept").val();
				}
				$.ajax({
	   				type:"post",
	   				dataType:"json",
	   				url:url,
	   				success: function(data){
	   					var opts="<option value=''>양식선택</option>";
	   					$(data).each(function(){
	   						opts +="<option value="+this.formId+">"+this.formName+"</option>";
	   					})
	   					$("#formId").html(opts);
	   				}
	   			});
			}
	        	
	        function SearchOptionHidden() {
	        	$.modal.close();
	        }	        
	        function ShowQuickAddres() {
	        	if (useAnyoneEdit != "YES") {
		        	if (deptAdmin != "Y" && pFolderType == "D") {
		                alert("<spring:message code='ezAddress.t999900003' />");
		                return;
		            }
		            else if (compAdmin != "Y" && pFolderType == "C") {
		                alert("<spring:message code='ezAddress.t999900004' />");
		                return;
		            }
	        	}	        	
	        	
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
	        	
	        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	        	
	        	$("#addpopup").css("left", popupX);
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	
	        	$("#addpopup").modal();
	        }	
			
			function savePreviewRayer(viewHow){
				$.ajax({
	   				type:"post",
	   				data:{viewenv:viewHow},
	   				url:"/ezJournal/saveJournalEnv.do",
	   				success: function(result){
	   					journalPreviewRayerChange(viewHow);
	   				}
	   			});
			}
			

			//분할보기 설정
			function journalPreviewRayerChange(pGubun) {
				pGubun = pGubun.trim();

				if (pGubun == "OFF")
					pGubun = "NONE";
				try {
					if (document.getElementById("previewmail_bar_h") != null)
						document.getElementById("previewmail_bar_h").style.cursor = "w-resize";

					isPreviewChange = true;
					if (pGubun == "NONE") {
						pPreviewShow_HOW = "OFF";
						document.getElementById("PreviewRayerW").style.display = "none";
						document.getElementById("PreviewRayerH").style.display = "none";
						CurrentHeight = document.documentElement.clientHeight - 110;
						document.getElementById("MailListRayer").style.height = CurrentHeight
								+ "px";
						document.getElementById("MailListRayer").style.width = "100%";
						document.getElementById("divList").style.height = (CurrentHeight - 50)
								+ "px";
						g_bPrevShow = false;
					} else if (pGubun == "W") {
						pMailListDiv = 50;
						pMailPreVDiv = 50;

						document.getElementById("MailListRayer").style.display = "inline-block";
						document.getElementById("PreviewRayerW").style.display = "block";
						document.getElementById("PreviewRayerH").style.display = "none";

						CurrenWidth = document.documentElement.clientWidth - 10;
						CurrentHeight = document.documentElement.clientHeight - 152;
						document.getElementById("ResizeBarH").style.height = CurrentHeight
								+ "px";
						document.getElementById("ResizeBarW").style.width = (CurrenWidth - 10)
								+ "px";
						pMailListHeightW = parseInt(CurrentHeight
								* (pMailListDiv / 100));
						pMailPreHeightW = parseInt(CurrentHeight
								* (pMailPreVDiv / 100));

						document.getElementById("MailListRayer").style.width = "100%";
						document.getElementById("PreviewRayerW").style.width = "100%";
						document.getElementById("MailListRayer").style.height = pMailListHeightW
								+ "px";
						document.getElementById("divList").style.height = (pMailListHeightW - 50)
								+ "px";
						document.getElementById("PreviewRayerW").style.height = (pMailPreHeightW + 45)
								+ "px";

						document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 95)
								+ "px";
						pPreviewShow_HOW = "W";
						pMailListDiv = Math
								.round((pMailListHeightW / CurrentHeight) * 100);
						pMailPreVDiv = Math
								.round((pMailPreHeightW / CurrentHeight) * 100);

						document.getElementById("Preview_HeaderW").style.display = "";
						document.getElementById("Preview_HeaderH").style.display = "none";
						g_bPrevShow = true;
						ifrmPreViewW.document
								.getElementById("ifrmviewEmptyText").innerText = "<spring:message code='ezBoard.t10022' />";
					} else if (pGubun == "H") {
						pMailListDiv_H = 50;
						pMailPreVDiv_H = 50;

						if (parent.document.getElementById("tab1")) {
							CurrenWidth = document.documentElement.clientWidth + 7;
						} else {
							CurrenWidth = document.documentElement.clientWidth - 20;
						}
						CurrentHeight = document.documentElement.clientHeight - 151;
						pMailListWidthH = parseInt(CurrenWidth
								* (pMailListDiv_H / 100));
						pMailPreWidthH = parseInt(CurrenWidth
								* (pMailPreVDiv_H / 100)) - 3;

						document.getElementById("MailListRayer").style.display = "inline-block";
						document.getElementById("PreviewRayerW").style.display = "none";
						document.getElementById("PreviewRayerH").style.display = "inline-block";

						if (CurrenWidth < (pMailListWidthH + pMailPreWidthH)) {
							if (pMailListWidthH > parseInt(CurrenWidth * 0.40)) {
								pMailListWidthH = pMailListWidthH
										- ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
							} else {
								pMailPreWidthH = pMailPreWidthH
										- ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
							}
						}

						document.getElementById("ResizeBarH").style.height = CurrentHeight
								+ "px";
						document.getElementById("ResizeBarW").style.width = CurrenWidth
								+ "px";
						document.getElementById("MailListRayer").style.height = CurrentHeight
								+ "px";
						document.getElementById("PreviewRayerH").style.height = CurrentHeight
								+ "px";
						document.getElementById("MailListRayer").style.width = pMailListWidthH
								+ "px";
						document.getElementById("divList").style.height = (CurrentHeight - 50)
								+ "px";

						document.getElementById("divList").style.overflow = "auto";
						document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70)
								+ "px";
						document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 10)
								+ "px";
						document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 68)
								+ "px";
						pPreviewShow_HOW = "H";
						pMailListDiv_H = Math
								.round((pMailListWidthH / CurrenWidth) * 100);
						pMailPreVDiv_H = Math
								.round((pMailPreWidthH / CurrenWidth) * 100);

						document.getElementById("Preview_HeaderW").style.display = "none";
						document.getElementById("Preview_HeaderH").style.display = "";

						g_bPrevShow = true;
						ifrmPreViewH.document
								.getElementById("ifrmviewEmptyText").innerText = "<spring:message code='ezBoard.t10022' />";
					}
					MailOptionHidden();
					PreviewMode_ChangeBtn();
					isPreviewChange = false;
				} catch (e) {
				}
			}

			$(function() {
				$("#Sdatepicker").datepicker({
					changeMonth : true,
					changeYear : true,
					autoSize : true,
					showOn : "both",
					buttonImage : "/images/ImgIcon/calendar-month.gif",
					buttonImageOnly : true
				});
				$("#Edatepicker").datepicker({
					changeMonth : true,
					changeYear : true,
					autoSize : true,
					showOn : "both",
					buttonImage : "/images/ImgIcon/calendar-month.gif",
					buttonImageOnly : true
				});

				$("#Sdatepicker")
						.datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Sdatepicker").datepicker('setDate', "");

				$("#Edatepicker")
						.datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Edatepicker").datepicker('setDate', "");
			});
			
			//정렬에 의한 리스트 셋팅
			function setListOrder(elem){
				orderNum = $(elem).attr("order");
				orderHow = $(elem).attr("sort");
				if(orderHow==null){
					orderHow='asc';
				} else if(orderHow == 'asc'){
					orderHow='desc';
				} else if(orderHow == 'desc'){
					orderHow='asc';
				}
				setJournalList();
			}
			function setInitOrder(){
				$("#BoardList_TH th").each(function (){
					if(orderNum==$(this).attr("order")){
						if(orderHow == 'asc'){
							$(this).attr("sort","asc");
							$(this).append(' <img src="/images/etc/view-sortdown.gif" align="absmiddle">');
						} else if(orderHow == 'desc'){
							$(this).attr("sort","desc");
							$(this).append(' <img src="/images/etc/view-sortup.gif" align="absmiddle">');
						}
					}
				})
			}

			function writejournal() {
				//	var feature = GetOpenWindowfeature(820, 880).replace("resizable=no","resizable=yes"); 
				var feature = GetOpenPosition(820, 850);
				var typeId = "ezJournal.t05";
				var Openwin = window
						.open(
								"/ezJournal/journalNewItem.do?typeId=" + typeId
										+ "&mode=new",
								"",
								"width=820, height=850, status=no, toolbar=no, menubar=no, location=no, resizable=1"
										+ feature);
				Openwin.focus();
			}
			
			function checkedCheckbox(elem){
				if($(elem).is(":checked")){
					$(elem).prop("checked","true");
					$(elem).parent().parent().addClass("selectTR");
				} else {
					$(elem).removeProp("checked");
					$(elem).parent().parent().removeClass("selectTR");
				}
			}

			$(document).ready(function() {
				setJournalList();
			});
		</script>
	</head>
	<body class="mainbody" style="overflow:auto;" onmousemove="MailPreviewResize(event);" onmouseup="MailPreviewEnd(event);">
			<c:choose>
				<c:when test="${listType eq 'department' }">
					<h1><spring:message code='ezJournal.t49'/>
				</c:when>
				<c:when test="${listType eq 'mine' }">
					<h1><spring:message code='ezJournal.t50'/>
				</c:when>
				<c:when test="${listType eq 'recv' }">
					<h1><spring:message code='ezJournal.t51'/>
				</c:when>
				<c:when test="${listType eq 'temp' }">
					<h1><spring:message code='ezJournal.t52'/>
				</c:when>
			</c:choose>
			<c:if test="${typeId ne null && typeId ne 'undefined' }">
				 - <spring:message code='${typeId }'/>
			</c:if>
			<span style="float:right;font-weight:normal;color:black;">
			  <c:if test="${listType eq 'department' or listType eq 'mine' or listType eq 'recv' }">
	          <input name="searchKey" id="Radio1" type="radio" value="journalTitle" checked style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;"><label for="Radio1">&nbsp;<spring:message code='ezBoard.t208' /></label>
			  </c:if>
			  <c:if test="${listType eq 'department' or listType eq 'recv' }">
			  <input name="searchKey" id="Radio2" type="radio" value="journalWriter" style="margin:0px;padding:0px;width:13px;height:13px;vertical-align:middle;"><label for="Radio2">&nbsp;<spring:message code='ezJournal.t34' /></label>
			  </c:if>
			  &nbsp;
			  <c:if test="${listType eq 'department' or listType eq 'mine' or listType eq 'recv' }">
			  <input id="SearchValue" style="width:150px;" onkeypress=""/> 
	          <a href="#"><img src="../../images/sub/bsearch.gif" border="0" style="vertical-align:middle" onClick="search('quick')"></a>
			  </c:if>
	        </span>
		</h1>
		<div id="mainmenu">
		  <ul>
		  	<c:if test="${listType eq 'department' or listType eq 'mine' }">
	       	 <li><span onClick="writejournal()"><spring:message code='ezJournal.t57' /></span></li>
		  	</c:if>
		  	<c:if test="${listType eq 'department' or listType eq 'recv' }">
	       	 <li><span onClick=""><spring:message code='ezJournal.t58' /></span></li>
		  	</c:if>
		  	<c:if test="${listType eq 'temp' }">
	       	 <li><span onClick=""><spring:message code='ezJournal.t107' /></span></li>
		  	</c:if>
		  	<c:if test="${listType eq 'temp' or listType eq 'recv' or listType eq 'mine'}">
	       	 <li><span onClick=""><spring:message code='ezJournal.t108' /></span></li>
		  	</c:if>
		  	<c:if test="${listType eq 'department' or listType eq 'recv' or listType eq 'mine'}">
	       	 <li><span id="SearchOption" onClick="doLayerPopup(this);" mode="off"><spring:message code='ezJournal.t59' /></span></li>
	       	 <li><span onClick=""><spring:message code='ezJournal.t60' /></span></li>
		  	</c:if>
	        <c:if test="${listType eq 'department'}">
		        <li style="background:none">
		            <select id="dept" onchange="goToPageByDeptId();">
		            	<c:forEach items="${deptList}" var="dept">
		                <option value="${dept.deptId}" <c:if test="${dept.mine eq 'yes' }">selected</c:if>>${dept.deptName }</option>
		            	</c:forEach>
		            </select>
		        </li>
	        </c:if>
	        <c:if test="${listType eq 'department' or listType eq 'mine'}">
		        <li style="background:none">
		            <select id="formId" onchange="goToPageByFormName();">
		            </select>
		        </li>
	        </c:if>
				<li style="">
				</li>
		        <li id="right">
					<img src="/images/kr/cm/btn_noframe.gif"     width="22" height="20" class="btnimg" id="PreViewNone"   status="off" onclick="savePreviewRayer('NONE')">
					<img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="PreViewBottom" status="off" onclick="savePreviewRayer('W')">
					<img src="/images/kr/cm/btn_leftframe.gif"   width="22" height="20" class="btnimg" id="PreViewleft"   status="off" onclick="savePreviewRayer('H')">
		        	<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);" />
		        </li>         
		  </ul>
		</div>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		    <div id="layer_Viewpopup" style="width: 250px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
		        <div class="popupwrap1">
		            <div class="popupwrap2">
		                <table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
		                    <caption></caption>
		                    <colgroup>
		                        <col style="width: 80px;">
		                        <col>
		                    </colgroup>
		                    <tr>
		                        <th><spring:message code='ezBoard.t10021' /></th>
		                        <td>
		                            <select id="listcount" style="WIDTH: 40px; height: 20px;" onchange="goToPageByListCnt(this);">
		                            	<c:forEach begin="1" end="5" varStatus="status">
		                            		<c:choose>
		                            		<c:when test="${journalEnv.listCnt eq  status.index*10}">
				                                <option selected value="${status.index * 10 }">${status.index * 10 }</option>
		                            		</c:when>
		                            		<c:otherwise>
				                                <option value="${status.index * 10 }">${status.index * 10 }</option>
		                            		</c:otherwise>
		                            		</c:choose>
		                            	</c:forEach>
		                            </select>    
		                        </td>
		                    </tr>
		                </table>
		            </div>
		        </div>
		        <div class="shadow">
		        </div>
		    </div>
		
			<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="mailPanel"></div>
		    <div style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
		    <div style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarW"></div>
			
		    <span id="MailListRayer" style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: inline-block;">
		        
		    </span>
		    
<!-- 		    보기설정을 다르게 했을때 보여주는 화면 -->
		    <span id="PreviewRayerH" style="border:0px solid red; width:500px; height:100%; overflow:hidden; vertical-align:top; display:none; margin-left:-5px;">
		        <span class="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor: w-resize; display: inline-block;">
		            <p class="hbar_dotted">
		                <img src="/images/prevview_hbar_dotted.gif">
		            </p>
		        </span>
		        <span id="PreContent_RayerH" style="position: absolute; border: 0px solid blue;">
		            <span style="width: 100%; height: 100px; display: block;">
		                <span class="previewmail_info" style="display: block; width: 100%;">
		                    <div id="Preview_HeaderH" style="border-bottom: solid 1px #dadada; width: 100%; display: none;">
		                    </div>
		                </span>
		                
		                <iframe id="ifrmPreViewH" name="ifrmPreViewH" src="/blank.htm" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
		            </span>
		        </span>
		    </span>
		
		    <span id="PreviewRayerW" style="border: 0px solid red; width: 100%; height: 300px; overflow: hidden; display: none;">
		        <span onmousedown="PreviewW_onMouserDown(event);" style="cursor: s-resize; width: 100%; display: list-item;" class="previewmail_bar" name="PreviewBar" id="PreviewBar">
		            <img src="/images/prevview_bar_dotted.gif">
		        </span>
		        <span id="PreContent_RayerW" style="display: block;">
		            <span style="width: 100%; height: 100px; display: block;">
		                <span class="previewmail_info" style="display: block; width: 100%;">
		                    <div id="Preview_HeaderW" style="border-bottom: solid 1px #dadada; display: none;">
		                    </div>
		                </span>
		                
		                <iframe id="ifrmPreViewW" name="ifrmPreViewW" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: 0px solid black; z-index: 0;"></iframe>
		            </span>
		        </span>
		    </span>
		    <div id="ListInfo" style="display:none"></div>

	<div class="jquery-modal blocker current" id="layer_popup" style="display:none;">
		<div id="srarchpopup" class="popupwrap1 modal" style="padding-top: 20px; padding-bottom: 20px; margin-bottom: 70px; left: 297.5px; display: inline-block;">
			<table class="content">
					<c:if test="${listType ne 'mine' }">
					<tr>
						<th style="text-align: center"><spring:message code='ezJournal.t34' /></th>
						<td><input type="text" id="searchWriter" style="width: 98%" value=""></td>
					</tr>
					</c:if>
					<tr>
						<th style="text-align: center"><spring:message code='ezBoard.t208' /></th>
						<td><input type="text" id="searchTitle" style="width: 98%" value=""></td>
					</tr>
					<tr>
						<th style="text-align: center"><spring:message code='ezJournal.t22' /></th>
						<td><input type="text" id="searchFormName" style="width: 98%" value=""></td>
					</tr>
					<tr>
						<th style="text-align: center"><spring:message code='ezBoard.t210' /></th>
						<td><input type="text" id="Sdatepicker"
							style="width: 80px; text-align: center" readonly="readonly">
							~ <input type="text" id="Edatepicker"
							style="width: 80px; text-align: center" readonly="readonly">
						</td>
					</tr>
				</table>
				<br />
				<table style="width: 100%">
					<tr>
						<td style="text-align: center;">
							<a class="imgbtn"><span onClick="goToPageBySearch()"><spring:message code='ezBoard.t188' /></span></a> 
							<a class="imgbtn"><span onClick="BoardSearchOptionHidden()"><spring:message code='ezBoard.t15' /></span></a>
						</td>
					</tr>
				</table>
			<a href="#close-modal" rel="modal:close" class="close-modal ">Close</a>
		</div>
	</div>
	<c:if test="${listType eq 'department' or listType eq 'mine' }">
		<script type="text/javascript">
			setFormName();
		</script>
	</c:if>
	</body>
</html>