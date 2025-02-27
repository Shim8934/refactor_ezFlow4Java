<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezBoard/PreviewItem.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezJournal/journal_script.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
<!-- data picker-->
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
<link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
<!-- time picker-->
<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>

<style>
#layer_Viewpopup {
	z-index: 1000;
	margin: 0px;
	padding: 0px;
}

#layer_Viewpopup .btn_area {
	border-top: 1px solid #e5e5e5;
	margin: 10px 0px 0px 0px;
	padding: 10px 0px 0px;
}

#layer_Viewpopup .popupwrap3 {
	position: relative;
	padding: 10px;
	background: url("../images/kr/cm/popup_layerbg.gif") repeat-x;
}

#layer_Viewpopup .popupwrap3 h1 {
	font-size: 13px;
	margin: 0px 0px 10px 0px;
	height: 24px;
	line-height: 15px;
	padding: 0px;
	color: #fff;
	white-space: nowrap;
	text-overflow: ellipsis;
	overflow: hidden;
}

#MailListRayer tr:not (.selectTR ):hover {
	background-color: rgb(244, 245, 245);
}

#basicFormList td:not (.selectTD ):hover {
	background-color: rgb(244, 245, 245);
}

.selectTR {
	background-color: #f1f8ff;
}

.selectTD {
	background-color: #f1f8ff;
}

#journalListBody #journalList tr<c:if test="${listType ne 'temp' }">.noView</c:if> td {
	font-weight: bold;
}
</style>

<script type="text/javascript">
			var listType = "<c:out value='${listType}'/>";
			var typeId = "<c:out value='${typeId}'/>";
			var pAdminType  = "n";
			var currentPage = 1;
			var listCnt = "${journalEnv.listCnt}";
			var pPreviewShow_HOW = "${journalEnv.viewenv}";
			var searchWriter = "";
			var searchTitle = "";
			var searchFormName = "";
			var searchContent = "";
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
		    var pMailListDiv = "${100-journalEnv.previewWcontent}";
		    var pMailPreVDiv = "${journalEnv.previewWcontent}";
		    var pMailListWidthH = 0;
		    var pMailPreWidthH = 0;
		    var pMailListDiv_H = "${100-journalEnv.previewHcontent}";
		    var pMailPreVDiv_H = "${journalEnv.previewHcontent}";
		    var normal=null;
		    var onPreview=false;
		    var sumFormId;
		    var sumTypeId;
		    var journalIdList = [];
		    var replyJournalTitle;
			
			window.onresize = function () {
// 		        MailOptionHidden();
// 		        journalPreviewRayerChange(pPreviewShow_HOW);
// 		        var textContentSize;
// 				textContentSize = $("#PreviewRayerH").height() - 55;
// 				$("#Preview_ContentH").css("height", textContentSize);
// 				textContentSize = $("#PreviewRayerW").height() - 80;
// 				$("#Preview_ContentW").css("height", textContentSize);
		        Window_resize();
		    };
		    
			document.onselectstart = function () { return false; };
		    window.onload = function () {
		    	if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		    };
		    
	        /* 2018-08-11 장진혁 - 레이어팝업 생성된 상태에서 backspace 누를시 왼쪽프레임 부분 딤 처리 없애기 */
	        window.onunload = function () {
	        	if (parent.frames["left"]) {
	        		if (parent.frames["left"].document.getElementById("blockLeft")) {
	        			$(parent.frames["left"].document.body).css("overflow", "");
	        	    	$(parent.frames["left"].document.getElementById("blockLeft")).remove();
	        		}
	        	} else if (parent.frames["attitude_menu"]) {
	        		if (parent.frames["attitude_menu"].document.getElementById("blockLeft")) {
	        	    	$(parent.frames["attitude_menu"].document.getElementById("blockLeft")).remove();
	        		}
	        	}
	        	      
	        	if (parent.parent.frames["left"]) {
	        		if (parent.parent.frames["board_menu"]) {  		  
	        			$(parent.parent.frames["board_menu"].document.body).css("overflow", "");
	        			$(parent.parent.frames["board_menu"].document.getElementById("blockLeft")).remove();
	        			$(parent.parent.frames["board_main"].document.getElementById("blockTop")).remove();
	        		} else if (parent.parent.frames["left"].document.getElementById("blockLeft")) {  		  
	        			$(parent.parent.frames["left"].document.body).css("overflow", "");
	        			$(parent.parent.frames["left"].document.getElementById("blockLeft")).remove();
	        			$(parent.parent.frames["right"].document.getElementById("blockTop")).remove();
	        		}
	        	}
	        }		    
		    
		    function Window_resize() {
		        try {
		        	document.getElementById("layer_popup").style.left = document.documentElement.clientWidth - 260 + "px";
		            document.getElementById("layer_popup").style.top = "100px";

		            if (!isPreviewChange) {
		            	
		            	/* 단암 일정사이즈 이하로 width가 줄어도 좌우 미리보기 유지 
		                if (parseInt(document.documentElement.clientWidth) < 1000) {
		                	document.getElementById("PreViewleft").style.display = "none";
		                	pPreviewShow_HOW = "W";
		                }
		                else {
		                    document.getElementById("PreViewleft").style.display = "";
		                } */
		            	
		                if (pPreviewShow_HOW == "W") {
		                	if (pMailListDiv == 0 || pMailPreVDiv == 0) {
		                        pMailListDiv = 50; pMailPreVDiv = 50;
		                    }
		                    document.getElementById("MailListRayer").style.display = "inline-block";
		                    document.getElementById("PreviewRayerW").style.display = "block";
		                    document.getElementById("PreviewRayerH").style.display = "none";

		                    CurrenWidth = document.documentElement.clientWidth - 10;
		                    CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
		                    document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
		                    document.getElementById("ResizeBarW").style.width = (CurrenWidth + 10) + "px";
		                    pMailListHeightW = parseInt(CurrentHeight * (pMailListDiv / 100));
		                    pMailPreHeightW = parseInt(CurrentHeight * (pMailPreVDiv / 100));
		                    document.getElementById("MailListRayer").style.width = "100%";
		                    document.getElementById("PreviewRayerW").style.width = "100%";
		                    document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
		                    
							document.getElementById("divList").style.height = (pMailListHeightW - 62) + "px";
							document.getElementById("journalListBody").style.height = (pMailListHeightW - 100) + "px";
							document.getElementById("PreviewRayerW").style.height = (pMailPreHeightW + 45)+ "px";
							document.getElementById("Preview_ContentW").style.height = (pMailPreHeightW - $(".previewmail").eq(1).height()) + "px";
							
		                    document.getElementById("PreW_subject").style.width = (CurrenWidth - 185) + "px";
		                }
		                else if (pPreviewShow_HOW == "H") {
		                	if (pMailListDiv_H == 0 || pMailPreVDiv_H == 0) {
		                        pMailListDiv_H = 50; pMailPreVDiv_H = 50;
		                    }
		                	
		                    document.getElementById("MailListRayer").style.display = "inline-block";
		                    document.getElementById("PreviewRayerW").style.display = "none";
		                    document.getElementById("PreviewRayerH").style.display = "inline-block";

		                    CurrenWidth = document.documentElement.clientWidth - 20;
		                    CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
		                    pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
		                    pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;

		                    if (pMailListWidthH <= parseInt(CurrenWidth * 0.40)) {
		                        var ChangeListWidthDiv = parseInt(CurrenWidth * 0.40) - pMailListWidthH;
		                        pMailListWidthH = parseInt(CurrenWidth * 0.40);
		                        pMailPreWidthH = pMailPreWidthH - ChangeListWidthDiv;
		                    }
		                    
		                    document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
		                    document.getElementById("ResizeBarW").style.width = CurrenWidth + "px";
		                    document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
		                    document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
		                    document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
		                    
		                    document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
							document.getElementById("journalListBody").style.height = (CurrentHeight - 100) + "px";
		                    
		                    document.getElementById("PreviewRayerH").style.width = pMailPreWidthH + "px";
							document.getElementById("Preview_ContentH").style.height = (CurrentHeight - $(".previewmail").eq(0).height()) + "px";
		                    document.getElementById("PreContent_RayerH").style.width = pMailPreWidthH - 5 + "px";
		                    if(document.getElementById("PreH_subject")!=null){
			                    document.getElementById("PreH_subject").style.width = (pMailPreWidthH - 155) + "px";
		                    }
		                    
		                    /* 좌우 리사이징 시 round로 인해 비율의 합이 100%가 되지 않아
		                       오른쪽 끝에 여백이 발생하여 제거함
		                    pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
		                    pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);
		                    */
		                    
		                    // 화면 폭이 일정 크기보다 작아지면 헤더 구성을 변경한다.
		                    // 중요도, 책갈피, 첨부파일, 크기 컬럼을 제거한다.
		                    if (pMailListWidthH < 470) {
		                        BasicViewHeaderChange(true);
		                    } else {
		                        BasicViewHeaderChange(false);
		                    }
		                }
		                else if (pPreviewShow_HOW == "OFF") {
		                    document.getElementById("PreviewRayerW").style.display = "none";
		                    document.getElementById("PreviewRayerH").style.display = "none";
		                    CurrentHeight = document.documentElement.clientHeight - 110 - (document.getElementById("mainmenu").clientHeight - 28);
		                    document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
		                    document.getElementById("MailListRayer").style.width = "100%";
		                    
		                    if (navigator.userAgent.indexOf('Firefox') != -1)
		                        document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
		                    else
		                        document.getElementById("contentlist").style.height = (CurrentHeight - 100) + "px";
		                }
		            }            
		        } catch (e) { }
		    }
			
			//업무일지 리스트 뿌리기
			function setJournalList() {
				var url = "/ezJournal/journalList.do";
				var jsonParam={};
				jsonParam["listType"] = listType;
				jsonParam["formId"] = $("#formId").val();
				jsonParam["typeId"] = typeId;
				jsonParam["currentPage"] = currentPage;
				jsonParam["listCnt"] = listCnt;
				jsonParam["deptId"] = $("#dept").val();
				jsonParam["writerName"] = searchWriter;
				jsonParam["journalTitle"] = searchTitle;
				jsonParam["formName"] = searchFormName;
				jsonParam["journalText"] = searchContent;
				jsonParam["startDate"] = searchStartDate;
				jsonParam["endDate"] = searchEndDate;
				jsonParam["orderNum"] = orderNum;
				jsonParam["orderHow"] = orderHow;
				
				$.ajax({
	   				type : "post",
	   				contentType : 'application/json',
	   				dataType : "html",
	   				data : JSON.stringify(jsonParam),
	   				url : url,
	   				success: function(journalList){
	   					$("#MailListRayer").html(journalList);
	   					journalPreviewRayerChange(pPreviewShow_HOW);
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
	   				success: function(){
	   					setJournalList();
	   				}
	   			});
			}
			
			//페이지 번호에 의한 셋팅
			function goToPageByNum(page){
				currentPage = page;
				setJournalList();
			}
			
			//양식명에 의한 셋팅
			function goToPageByFormName() {
				currentPage = 1;
				searchWriter = "";   
				searchTitle = "";    
				searchFormName = ""; 
				searchStartDate = "";
				searchEndDate = "";  
				setJournalList();
				onPreview = false;
				journalPreviewRayerChange(pPreviewShow_HOW);
			}
			
			//검색에 의한 셋팅
			function goToPageBySearch() {
				
				if (listType == "mine") {
					if ($("#searchTitle").val().trim() == "" && $("#searchContent").val().trim() == "" && $("#searchFormName").val().trim() == "" 
						&& $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
	               		alert("<spring:message code='ezJournal.t190' />");
	                	return;
		            }
				} else {
					if ($("#searchTitle").val().trim() == "" && $("#searchContent").val().trim() == "" && $("#searchFormName").val().trim() == "" && $("#searchWriter").val().trim() == "" 
						&& $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
	               		alert("<spring:message code='ezJournal.t190' />");
	                	return;
		            }
				}
	            if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
	        		alert("<spring:message code='ezJournal.t191' />");	
	                return;
	            }
	            if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "") {
	                alert("<spring:message code='ezJournal.t192' />");
	                return;
	            }
	            if (new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()) > new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val())) {
	                alert("<spring:message code='ezJournal.t193' />");
	                return;
	            }
				
				if(document.getElementById("searchWriter")){
					searchWriter = document.getElementById("searchWriter").value;   
				}
				searchTitle = document.getElementById("searchTitle").value;    
				searchFormName = document.getElementById("searchFormName").value;
				searchContent = document.getElementById("searchContent").value;
				searchStartDate = document.getElementById("Sdatepicker").value;
				searchEndDate = document.getElementById("Edatepicker").value;
				currentPage = 1;
				setJournalList();
				BoardSearchOptionHidden();
			}
			
			function quickSearch() {
// 				var searchFlag = $("input[type='radio'][name='searchKey']:checked").val();
				var searchFlag = $("#searchKey").val();
				searchWriter = "";
				searchTitle = "";
				
				if(searchFlag == 'journalWriter'){
					searchWriter = $("#searchValue").val().trim();
				
					if (searchWriter == "") {
						alert("<spring:message code='ezJournal.t190' />");
	                	return;
					}
					setJournalList();
					//2019-06-05 김보미 - 검색후 검색어 초기화 되던것 주석처리
// 					$("#searchValue").val("");
				
				} else if(searchFlag == 'journalTitle'){
					searchTitle = $("#searchValue").val().trim();
				
					if (searchTitle == "") {
						alert("<spring:message code='ezJournal.t190' />");
	                	return;
					}
					setJournalList();
// 					$("#searchValue").val("");
				}
			}
			
			//상세검색 레이어팝업
			function doLayerPopup() {
				$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].BoardSearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
	        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	        	$("#srarchpopup").css("left", popupX);
				$("#srarchpopup").modal(
// 						{
// 					  escapeClose: false,
// 					  clickClose: false,
// 					  showClose: false
// 					}
						);
	        	
// 	        	$(".jquery-modal").on('hide', function(e){
// 					BoardSearchOptionHidden();
// 				});
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
			
			window.onbeforeunload = BoardSearchOptionHidden;
			
			function BoardSearchOptionHidden() {
				btn_PostDate_Clear();
				if(document.getElementById("searchWriter")){
					document.getElementById("searchWriter").value = "";
				}
				document.getElementById("searchFormName").value = "";
				document.getElementById("searchContent").value = "";
		        document.getElementById("searchTitle").value = "";
		        document.getElementById("layer_popup").style.display = "none";
		        if(document.getElementById("SearchOption")){
			        document.getElementById("SearchOption").setAttribute("mode", "off");
		        }
		        $.modal.close();
		    }
			
			function sumSearchOptionHidden() {
		        document.getElementById("selectSumJournal").style.display = "none";
		        $("#basicFormList").html("");
		        sumFormId = "";
		        sumTypeId = "";
		        journalIdList = [];
		        $.modal.close();
		    }
			
			//확인완료
			function doViewJournal(){
				$('input:checkbox[name="journalCheckbox"]:checked').each(function() {
					 var sumJournalId = $(this).parent().parent().attr("id");
					 journalIdList.push(sumJournalId);
				 });
				 
				if (journalIdList.length == 0) {
					alert("<spring:message code='ezJournal.t148'/>");
					return;
				}
				
				$.ajax ({
					type : "POST",
	   				dataType : "text",
					url : "/ezJournal/journalViewCheck.do",
					data : {
						journalIdList : JSON.stringify(journalIdList)
					},
					success : function() {
						if(listType == 'recv'){
							parent.left.setRecvCount();
							setRecvCount();
						}
						setJournalList();
					},
					error : function() {
					}
				});
			}
			
			//취합양식 선택 레이어팝업
			function doSelectSumJournal() {
				var basicFormFlag = true;
				var selects = $(".selectTR");
				selects.each(function(){
					
					if($(this).attr("formStatus") != 'basic'){
						basicFormFlag = false;
					}
				});
				if(selects.length == 0){
					alert("<spring:message code='ezJournal.t148'/>");
					return;
				}
				if(basicFormFlag){
					var url = "/ezJournal/getFormList.do";
					$.ajax({
		   				type : "post",
		   				dataType : "json",
		   				url : url,
		   				success: function(forms){
// 		   					var trs = "<tr><th style='text-align: center;'><spring:message code='ezJournal.t72' /></th></tr>";
							var trs = "";
		   					$(forms).each(function(){
		   						trs += "<tr onclick='sumFormClick(this);' ondblclick='writeSumJournal();' style='cursor:pointer;' sumTypeId=" + this.typeId + " sumFormId=" + this.formId + "><td>" + this.formName + "</td></tr>";
		   					})
	   						$("#basicFormList").html(trs);
		   				}
		   			});
					
					$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].sumSearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
		        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 150;
		        	$("#sumpopup").css("left", popupX);
					$("#sumpopup").modal(
// 							{
// 						  escapeClose: false,
// 						  clickClose: false,
// 						  showClose: false
// 						}
							);
					
// 					$("#sumpopup").on('hide', function(e){
// 						sumSearchOptionHidden();
// 					});
				} else{
					alert("<spring:message code='ezJournal.t146' />");
				}
		    }
			
			//취합하기
			function writeSumJournal(){
				journalIdList.length = 0;
				if(sumFormId != null && sumFormId != undefined && sumFormId != ""){
					 $('input:checkbox[name="journalCheckbox"]:checked').each(function() {
						 var sumJournalId = $(this).parent().parent().attr("id");
						 journalIdList.push(sumJournalId);
					 });
				 	var feature = GetOpenPosition(820, 850);
					var Openwin = window.open("/ezJournal/journalWrite.do?typeId=" + sumTypeId + "&mode=sum", "",
									"width=820, height=850, status=no, toolbar=no, menubar=no, location=no, resizable=1"
										+ feature);
					Openwin.focus();
					document.getElementById("selectSumJournal").style.display = "none";
			        $("#basicFormList").html("");
			        sumTypeId = "";
				//	sumFormId = "";
			        $.modal.close();
				} else {
					alert("<spring:message code='ezJournal.t71' />");
				}
			} 
			
			//취합양식 한개 선택시
			function sumFormClick(elem){
				var parentElem = $(elem).parent();
				$(parentElem).find("td").removeClass("selectTD");
				sumFormId = $(elem).attr("sumFormId");
				sumTypeId = $(elem).attr("sumTypeId");
				$(elem).find("td").addClass("selectTD");
			}
			
			//부서에 의한 페이지 세팅
			function goToPageByDeptId(){
				currentPage = 1;
				searchWriter = "";   
				searchTitle = "";    
				searchFormName = ""; 
				searchContent = ""; 
				searchStartDate = "";
				searchEndDate = "";  
				setFormName();
				setJournalList();
				onPreview = false;
				journalPreviewRayerChange(pPreviewShow_HOW);
			}
			
			//tr선택시
			function selectedTR(elem){
// 				onPreview = false;
				var parentElem = $(elem).parent();
				$("#journalList tr").removeClass("selectTR");
				$("#journalList tr").find("input[type='checkbox']").removeProp("checked");
	   			$(parentElem).addClass("selectTR");
	   			var vc = $(parentElem).find(".viewCount");
	   			$(parentElem).find("input[type='checkbox']").prop("checked","true");
	   			var journalId=$(parentElem).attr("id");
// 	   			if (pPreviewShow_HOW == 'W' || pPreviewShow_HOW == 'H') {
		   			if($(parentElem).hasClass("noView") && (pPreviewShow_HOW == 'W' || pPreviewShow_HOW == 'H')){
		   				if($(parentElem).attr("mine") == 'N'){
		   	   				$(vc).text(parseInt($(vc).text())+1);
		   				}
			   			$(parentElem).removeClass("noView");
		   			}
		   			
// 	   				$("#ifrmPreViewH").attr("src","/ezJournal/journalPreview.do?journalId="+journalId);
					$.ajax({
		   				type : "post",
		   				dataType : "html",
		   				data : {journalId : journalId},
		   				url : "/ezJournal/journalPreview.do",
		   				success : function(journal){
							$("#Preview_ContentW").html(journal);
							$("#Preview_ContentH").html(journal);
							$(".journalPreviewContentIframe").attr("src","/ezJournal/journalDetailContent.do?journalId=" + journalId+"&journalType=p&pPreviewShow_HOW="+pPreviewShow_HOW);
							if(listType == 'recv'){
								parent.left.setRecvCount();
// 								setJournalList();
								setRecvCount();
								$(parentElem).find("td:eq(1)").find("img").attr("src", "/images/ImgIcon/icon-msg-read.gif");
							}
// 							var textContentSize;
// 							textContentSize = $("#PreviewRayerH").height()-$(".previewmail_info").height();
// 							$("#Preview_ContentH").css("height", textContentSize);
// 							textContentSize = $("#PreviewRayerW").height()-$(".previewmail_info").height()-50;
// 							$("#Preview_ContentW").css("height", textContentSize);
							if(document.getElementById("PreH_subject")!=null){
			                    document.getElementById("PreH_subject").style.width = (pMailPreWidthH - 155) + "px";
		                    }
// 		   					ifrmPreViewW.document.getElementById("ifrmviewEmptyText").innerHTML =data.journalContent;
// 		   					ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerHTML =data.journalContent;
							Window_resize();
		   				}
		   			});
// 				}
			}
			
			//체크박스 전체선택 혹은 해제
			function selectedAllTR(elem) {
				if($(elem).is(":checked")) {
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
			function setFormName() {
				var url = "/ezJournal/getFormList.do?typeId=" + typeId;
				if(listType == "department" || listType == "mine"){
					url += "&deptId=";
					url += $("#dept").length > 0 ? $("#dept").val() : "";
				}
				$.ajax({
	   				type : "post",
	   				dataType : "json",
	   				url : url,
	   				success : function(forms){
	   					var opts = "<option value=''><spring:message code='ezJournal.t76'/></option>";
	   					$(forms).each(function() {
	   						opts += "<option value=" + this.formId + ">" + this.formName + "</option>";
	   					})
	   					$("#formId").html(opts);
						resizableMenu();
	   				}
	   			});
			}
	        	
	        function ShowQuickAddres() {
	        	if (useAnyoneEdit != "YES") {
		        	if (deptAdmin != "Y" && pFolderType == "D") {
		                alert("<spring:message code='ezJournal.t194' />");
		                return;
		            }
		            else if (compAdmin != "Y" && pFolderType == "C") {
		                alert("<spring:message code='ezJournal.t195' />");
		                return;
		            }
	        	}	        	
	        	
	        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
	        	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	        	$("#addpopup").css("left", popupX);
	        	$("#addpopup").modal();
	        }	
			
			function savePreviewRayer(viewHow){
				$.ajax({
	   				type : "post",
	   				data : {viewenv : viewHow},
	   				url : "/ezJournal/saveJournalEnv.do",
	   				success : function() {
	   					journalPreviewRayerChange(viewHow);
	   					Window_resize();
	   				}
	   			});
			}
			function saveJournalEnv(){
				$.ajax({
	   				type : "post",
	   				data : {"previewWcontent" : pMailPreVDiv, 
	   						"previewHcontent" : pMailPreVDiv_H
	   					   },
	   				url : "/ezJournal/saveJournalEnv.do",
	   				success : function(){
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
						document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
						document.getElementById("MailListRayer").style.width = "100%";
						document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
						document.getElementById("journalListBody").style.height = (CurrentHeight - 100) + "px";
						g_bPrevShow = false;
						onPreview=false;
// 						$("#Preview_ContentH").html("<dl class='nodata_sIcon' style='margin-top:70px;'><dt><img src='/images/kr/main/noData_sIcon.png'></dt><dd><spring:message code='ezJournal.t91' /></dd></dl>");
// 						$("#Preview_ContentW").html("<dl class='nodata_sIcon' style='margin-top:70px;'><dt><img src='/images/kr/main/noData_sIcon.png'></dt><dd><spring:message code='ezJournal.t91' /></dd></dl>");
					} else if (pGubun == "W") {
						document.getElementById("MailListRayer").style.display = "inline-block";
						document.getElementById("PreviewRayerW").style.display = "block";
						document.getElementById("PreviewRayerH").style.display = "none";

						CurrenWidth = document.documentElement.clientWidth - 10;
						CurrentHeight = document.documentElement.clientHeight - 154;
						document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
						document.getElementById("ResizeBarW").style.width = (CurrenWidth - 10) + "px";
						pMailListHeightW = parseInt(CurrentHeight * (pMailListDiv / 100));
						pMailPreHeightW = parseInt(CurrentHeight * (pMailPreVDiv / 100));

						document.getElementById("MailListRayer").style.width = "100%";
						document.getElementById("PreviewRayerW").style.width = "100%";
						document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
						document.getElementById("divList").style.height = (pMailListHeightW - 62) + "px";
						document.getElementById("journalListBody").style.height = (pMailListHeightW - 100) + "px";
						document.getElementById("PreviewRayerW").style.height = (pMailPreHeightW + 45)+ "px";

// 						document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 95) + "px";
						pPreviewShow_HOW = "W";
						pMailListDiv = Math.round((pMailListHeightW / CurrentHeight) * 100);
						pMailPreVDiv = Math.round((pMailPreHeightW / CurrentHeight) * 100);

// 						document.getElementById("Preview_HeaderW").style.display = "";
// 						document.getElementById("Preview_HeaderH").style.display = "none";
						g_bPrevShow = true;
						
// 						if(onPreview == false){
// 							$("#Preview_ContentH").html("<dl class='nodata_sIcon' style='margin-top:70px;'><dt><img src='/images/kr/main/noData_sIcon.png'></dt><dd><spring:message code='ezJournal.t91' /></dd></dl>");
// 							$("#Preview_ContentW").html("<dl class='nodata_sIcon' style='margin-top:70px;'><dt><img src='/images/kr/main/noData_sIcon.png'></dt><dd><spring:message code='ezJournal.t91' /></dd></dl>");
// 						}
						onPreview = true;
					} else if (pGubun == "H") {
						if (parent.document.getElementById("tab1")) {
							CurrenWidth = document.documentElement.clientWidth + 7;
						} else {
							CurrenWidth = document.documentElement.clientWidth - 20;
						}
						CurrentHeight = document.documentElement.clientHeight - 120;
						pMailListWidthH = parseInt(CurrenWidth * (pMailListDiv_H / 100));
						pMailPreWidthH = parseInt(CurrenWidth * (pMailPreVDiv_H / 100)) - 3;

						document.getElementById("MailListRayer").style.display = "inline-block";
						document.getElementById("PreviewRayerW").style.display = "none";
						document.getElementById("PreviewRayerH").style.display = "inline-block";

						if (CurrenWidth < (pMailListWidthH + pMailPreWidthH)) {
							if (pMailListWidthH > parseInt(CurrenWidth * 0.40)) {
								pMailListWidthH = pMailListWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
							} else {
								pMailPreWidthH = pMailPreWidthH - ((pMailListWidthH + pMailPreWidthH) - CurrenWidth);
							}
						}

						document.getElementById("ResizeBarH").style.height = CurrentHeight + "px";
						document.getElementById("ResizeBarW").style.width = CurrenWidth + "px";
						document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
						document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
						document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
						document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
						document.getElementById("journalListBody").style.height = (CurrentHeight - 100) + "px";

// 						document.getElementById("divList").style.overflow = "auto";
						document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
						document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 5) + "px";
// 						document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 68) + "px";
						pPreviewShow_HOW = "H";
						pMailListDiv_H = Math.round((pMailListWidthH / CurrenWidth) * 100);
						pMailPreVDiv_H = Math.round((pMailPreWidthH / CurrenWidth) * 100);

// 						document.getElementById("Preview_HeaderW").style.display = "none";
// 						document.getElementById("Preview_HeaderH").style.display = "";

						g_bPrevShow = true;
						
// 						if(onPreview == false){
// 							$("#Preview_ContentH").html("<dl class='nodata_sIcon' style='margin-top:70px;'><dt><img src='/images/kr/main/noData_sIcon.png'></dt><dd><spring:message code='ezJournal.t91' /></dd></dl>");
// 							$("#Preview_ContentW").html("<dl class='nodata_sIcon' style='margin-top:70px;'><dt><img src='/images/kr/main/noData_sIcon.png'></dt><dd><spring:message code='ezJournal.t91' /></dd></dl>");
// 						}
						onPreview = true;
					}
					
					MailOptionHidden();
					PreviewMode_ChangeBtn();
					isPreviewChange = false;
				} catch (e) { 	}
			}
			
			function journalListScroll(){
				var thWidth = document.getElementById("journalListHead").clientWidth - document.getElementById("journalList").clientWidth;
				if(thWidth > 0){ 
					$("#BoardList_TH").append('<th style=width:8px;></th>');
				} 
			}

			$(function() {
				
				$("#Sdatepicker").datepicker({
					changeMonth : true,
					changeYear : true,
					autoSize : true,
					showOn : "both",
					buttonImage : "/images/ImgIcon/calendar-month.png",
					buttonImageOnly : true
				});
				
				$("#Edatepicker").datepicker({
					changeMonth : true,
					changeYear : true,
					autoSize : true,
					showOn : "both",
					buttonImage : "/images/ImgIcon/calendar-month.png",
					buttonImageOnly : true
				});

				$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Sdatepicker").datepicker('setDate', "");

				$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Edatepicker").datepicker('setDate', "");
			});
			
			var monthMsg = "<spring:message code='ezJournal.t196' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezJournal.t197' />";
		    var dayStr = dayMsg.split(";");
		    
		    $(function () {
		        $.datepicker.regional["<spring:message code='ezJournal.t198' />"] = {
		        	monthNames: monthStr,
		            monthNamesShort: monthStr,
		            dayNames: dayStr,
		            dayNamesShort: dayStr,
		            dayNamesMin: dayStr,
		            weekHeader: 'Wk',
		            dateFormat: 'yy-mm-dd',
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: 'show',
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='ezJournal.t198' />"]);
		    });			
			
			//정렬에 의한 리스트 셋팅
			function setListOrder(elem){
				
				orderNum = $(elem).attr("order");
				orderHow = $(elem).attr("sort");
				
				if(orderHow == null){
					orderHow='asc';
				} else if(orderHow == 'asc'){
					orderHow='desc';
				} else if(orderHow == 'desc'){
					orderHow='asc';
				}
				
				setJournalList();
			}
			function setInitOrder(){
				
				$("#BoardList_TH th").each(function () {
				
					if(orderNum == $(this).attr("order")) {
						if(orderHow == 'asc'){
							$(this).attr("sort","asc");
							$(this).append(' <img src="/images/etc/view-sortdown.gif" align="absmiddle">');
						} else if(orderHow == 'desc'){
							$(this).attr("sort","desc");
							$(this).append(' <img src="/images/etc/view-sortup.gif" align="absmiddle">');
						}
					}
				});
				journalListScroll();
			}

			// 일지작성
			function writejournal() {
				//	var feature = GetOpenWindowfeature(820, 880).replace("resizable=no","resizable=yes"); 
				var feature = GetOpenPosition(820, 850);
				var Openwin = window.open("/ezJournal/journalWrite.do?typeId=" + typeId + "&mode=new", "",
								"width=820, height=850, status=no, toolbar=no, menubar=no, location=no, resizable=1" + feature);
				Openwin.focus();
			}
			
			function checkedCheckbox(elem) {
				if($(elem).is(":checked")) {
					$(elem).prop("checked","true");
					$(elem).parent().parent().addClass("selectTR");
				} else {
					$(elem).removeProp("checked");
					$(elem).parent().parent().removeClass("selectTR");
				}
			}
			
			// 임시보관함에서 일지수정버튼
			function modifyJournal() {
				var journalId = $("input:checkbox[name='journalCheckbox']:checked");
				
				if (journalId.length > 1) {
					alert("<spring:message code='ezJournal.t158'/>");
				} else if (journalId.length == 0) {
					alert("<spring:message code='ezJournal.t148'/>");
				} else {
					typeId = journalId.parent().parent().attr("typeId");
					journalId = journalId.parent().parent().attr("id");
					var feature = GetOpenPosition(820, 850);
					var Openwin = window.open("/ezJournal/journalWrite.do?typeId=" + typeId + "&journalId=" + journalId + "&mode=temp", "",
									"width=820, height=850, status=no, toolbar=no, menubar=no, location=no, resizable=1" + feature);
					Openwin.focus();
				}
			}
			
			// 일지삭제
			function deleteJournal() {
				journalIdList = [];
				 $('input:checkbox[name="journalCheckbox"]:checked').each(function() {
					 journalIdList.push($(this).parent().parent().attr("id"));
				 });
				  
				if (journalIdList.length == 0) {
					alert("<spring:message code='ezJournal.t148'/>");
					return;
				}
				
				for (var i = 0; i < journalIdList.length; i++) {
					if ($("#" + journalIdList[i]).attr("mine") == "N" && listType != "recv") {
						alert("<spring:message code='ezJournal.t199'/>");
						return;
					}
				}
				if (confirm("<spring:message code='ezJournal.t139'/>")) {
					$.ajax ({
						type : "POST",
						dataType : "text",
						async : "false",
						url : "/ezJournal/journalDelete.do",
						data : {
							listType : listType,
							journalId : JSON.stringify(journalIdList)
						},
						success : function() {
							alert("<spring:message code='ezJournal.t138'/>");
							setJournalList();
							$("#Preview_ContentH").html("<dl class='nodata_sIcon' style='margin-top:70px;'><dt><img src='/images/kr/main/noData_sIcon.png'></dt><dd><spring:message code='ezJournal.t91' /></dd></dl>");
							$("#Preview_ContentW").html("<dl class='nodata_sIcon' style='margin-top:70px;'><dt><img src='/images/kr/main/noData_sIcon.png'></dt><dd><spring:message code='ezJournal.t91' /></dd></dl>");
						},
						error : function() {
							alert("<spring:message code='ezJournal.t149'/>");
						}
					});
				}
			}

			$(document).ready(function() {
				setJournalList();
		    	
		    	$($(window.parent.frames['left'].document)).mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(parent.document).mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(document).mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(window.frames['ifrmPreViewH']).mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	
		    	$(window.frames['ifrmPreViewW']).mouseup(function (e) {
		    		MailOptionHiddenOutside(e);
		    	});
		    	$("#Preview_ContentH").html("<dl class='nodata_sIcon' style='margin-top:70px;'><dt><img src='/images/kr/main/noData_sIcon.png'></dt><dd><spring:message code='ezJournal.t91' /></dd></dl>");
				$("#Preview_ContentW").html("<dl class='nodata_sIcon' style='margin-top:70px;'><dt><img src='/images/kr/main/noData_sIcon.png'></dt><dd><spring:message code='ezJournal.t91' /></dd></dl>");

// 				if(pPreviewShow_HOW=='H'){
// 					PreviewH_Move = true;
// 				} else if(pPreviewShow_HOW=='W'){
// 					PreviewW_Move = true;
// 				}
// 				journalPreviewResize();
			});
			
			/* 2021-01-21 홍승비 - 미리보기 영역 열려있지 않은 경우, 제목 클릭 시 원클릭으로 업무일지 읽기팝업창 표출 */
			function goJournalDetailOneClick(obj){
				if (document.getElementById("PreviewRayerH").style.display == "none" && document.getElementById("PreviewRayerW").style.display == "none") {
					goJournalDetail(obj.parentElement); // parentElem은 현재 td 엘리먼트의 상위 tr 태그
				}
			}
		</script>
</head>
<body class="mainbody" style="overflow: hidden;" onmousemove="journalPreviewResize(event);" onmouseup="journalPreviewEnd(event);">
	<c:choose>
		<c:when test="${listType eq 'department' }">
			<h1><spring:message code='ezJournal.t49' />	
		</c:when>
		<c:when test="${listType eq 'mine' }">
			<h1><spring:message code='ezJournal.t50' />	
		</c:when>
		<c:when test="${listType eq 'recv' }">
			<h1><spring:message code='ezJournal.t51' />
		</c:when>
		<c:when test="${listType eq 'temp' }">
			<h1><spring:message code='ezJournal.t52' />
		</c:when>
	</c:choose>
	<c:if test = "${typeId ne null && typeId ne 'undefined' }">
		 - <spring:message code='${typeId }' />
	</c:if>
	<c:choose>
		<c:when test="${listType eq 'recv' }">
			<span id="mailBoxInfo">&nbsp;<span id="recvCount" class='txt_color'></span> / <span id="totalCount"></span></span>
		</c:when>
		<c:otherwise>
			<span id="mailBoxInfo">&nbsp;<span id="totalCount" class='txt_color'></span></span>
		</c:otherwise>
	</c:choose>
	<span class="searchForm">
		<select id="searchKey" class="text" name="searchKey" style="height: 27px; margin-right: 0px; border: 1px solid #cbcbcb; width: 80px;">    
           	<option value="journalTitle"><spring:message code='ezJournal.t56' /></option>
			<c:if test="${listType eq 'department' or listType eq 'recv' }">
	       		<option value="journalWriter"><spring:message code='ezJournal.t34' /></option>
       		</c:if>
       	</select>
		<input id="searchValue" class="searchinputBox" style="height: 27px !important;border: 1px solid #cbcbcb;" onfocus="journalKeywordClear(this);" onkeypress="if(event.keyCode==13) {quickSearch(); return false;}">
		<a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onclick="quickSearch()"></a>
	</span>
	</h1>
	<div id="mainmenu">
		<ul>
			<!-- 		  	일지쓰기 -->
			<c:if test="${listType eq 'department' or listType eq 'mine' }">
				<li class="important" onClick="writejournal()"><span><spring:message code='ezJournal.t57' /></span></li>
			</c:if>
			<!-- 		  	확인완료 -->
			<c:if test="${listType eq 'recv' }">
				<li onClick="doViewJournal();"><span><spring:message code='ezJournal.t58' /></span></li>
			</c:if>
			<!-- 		  	읽음표시 -->
			<c:if test="${listType eq 'department' or listType eq 'mine'}">
				<li onClick="doViewJournal();"><span><spring:message code='ezJournal.t58' /></span></li>
			</c:if>
			<!-- 		  	수정 -->
			<c:if test="${listType eq 'temp' }">
				<li onClick="modifyJournal()"><span><spring:message code='ezJournal.t107' /></span></li>
			</c:if>
			<c:if test="${listType eq 'department' or listType eq 'recv' or listType eq 'mine'}">
				<!-- 		  	취합 -->
				<li onClick="doSelectSumJournal();"><span><spring:message code='ezJournal.t60' /></span></li>
				<li onClick="doLayerPopup(this)"><span class="icon16 icon16_search switchIcon" id="SearchOption" onClick="doLayerPopup(this);" mode="off"></span><span class="iconTexts"><spring:message code='ezJournal.t43'/></span></li>
			</c:if>
			<li onClick="deleteJournal()"><span class="icon16 icon16_delete switchIcon"></span><span class="iconTexts" onClick="DeleteItem_onclick()"><spring:message code='ezJournal.t108'/></span></li>
			<c:if test="${listType eq 'department'}">
				<li style="background: none"><select id="dept" onchange="goToPageByDeptId();" style="height:29px;">
					<c:forEach items="${deptList}" var="dept">
						<option value="${dept.deptId}"
							<c:if test="${dept.deptId eq userDept}">selected</c:if>>${dept.deptName }
						</option>
					</c:forEach>
				</select></li>
			</c:if>
			<c:if test="${listType eq 'department' or listType eq 'mine'}">
				<li style="background: none"><select id="formId" onchange="goToPageByFormName();" style="height:29px;"></select></li>
			</c:if>
			<!-- <li id="right">
				<img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" status="off" onclick="savePreviewRayer('NONE')">
				<img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="PreViewBottom" status="off" onclick="savePreviewRayer('W')"> 
				<img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" status="off" onclick="savePreviewRayer('H')"> 
				<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);" />
			</li> -->
			<div class="sub_frameIcon" style="float:right">	
				<div class="sub_frameIconUL">
				   	<p class="frameIconLI"><span class="icon16 btn_noframe" id="PreViewNone" onclick="savePreviewRayer('NONE')"></span></p>
				    <p class="frameIconLI"><span class="icon16 btn_bottomframe" id="PreViewBottom" onclick="savePreviewRayer('W')"></span></p>
				    <p class="frameIconLI"><span class="icon16 btn_leftframe" id="PreViewleft" onclick="savePreviewRayer('H')"></span></p>
				</div>
				<div class="sub_frameIconUL02">
				  	<p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="maillistoptiondiv" onclick="MailOptionView(this);"></span></p>  
				</div>
			</div>
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
						<th><spring:message code='ezJournal.t68' /></th>
						<td><select id="listcount" style="WIDTH: 40px; height: 20px;" onchange="goToPageByListCnt(this);">
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
						</select></td>
					</tr>
				</table>
			</div>
		</div>
		<div class="shadow"></div>
	</div>

	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id="mailPanel"></div>
	<div style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
	<div style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarW"></div>

	<span id="MailListRayer" style="border: 0px solid blue; vertical-align: top; overflow: hidden; display: inline-block;">
	</span>

	<!-- 		    보기설정을 다르게 했을때 보여주는 화면 -->
	<span id="PreviewRayerH" style="border: 0px solid red; width: 500px; height: 100%; overflow: hidden; vertical-align: top; display: none; margin-left: -5px;">
		<span class="previewmail_bar_h" onmousedown="PreviewH_onMouserDown(event);" style="cursor: w-resize; display: inline-block;">
			<p class="hbar_dotted">
				<img src="/images/prevview_hbar_dotted.gif">
			</p>
		</span> 
		<span id="PreContent_RayerH" style="position: absolute; border: 0px solid blue;"> 
			<span style="width: 100%; height: 100px; display: block;">
				<div id="Preview_ContentH" style="text-align: center; border-top: 1px solid #e8e8e8;"></div>
			</span>
		</span>
	</span>

	<span id="PreviewRayerW" style="border: 0px solid red; width: 100%; height: 300px; overflow: hidden; display: none;">
		<span onmousedown="PreviewW_onMouserDown(event);" style="cursor: s-resize; width: 100%; display: list-item;" class="previewmail_bar" name="PreviewBar" id="PreviewBar"> 
			<img src="/images/prevview_bar_dotted.gif">
		</span>		 
		<span id="PreContent_RayerW" style="display: block;border-top:1px solid #e6e6e6"> 
			<span style="width: 100%; height: 100px; display: block;">
				<div id="Preview_ContentW" style="text-align: center;"></div>
			</span>
		</span>
	</span>
	<div id="ListInfo" style="display: none"></div>

	<div class="jquery-modal blocker current" id="layer_popup" style="display: none;">
		<div id="srarchpopup" class="popupwrap1 modal" style="margin-bottom: 70px; left: 297.5px; display: inline-block;">
			<div class="popupJQLayer">
				<div class="title"><spring:message code='ezJournal.t1' /><spring:message code='ezJournal.t43' /></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="BoardSearchOptionHidden()"></span></a></li>
		            </ul>
		        </div>
				<table class="content">
					<c:if test="${listType ne 'mine' }">
						<tr>
							<th style="text-align: center">
								<spring:message code='ezJournal.t34' />
							</th>
							<td>
								<input type="text" onfocus="journalKeywordClear(this);" onkeypress="if(event.keyCode==13){goToPageBySearch(); return false;}" id="searchWriter" style="width: 98%" value="">
							</td>
						</tr>
					</c:if>
					<tr>
						<th style="text-align: center">
							<spring:message code='ezJournal.t56' />
						</th>
						<td>
							<input type="text" onfocus="journalKeywordClear(this);" onkeypress="if(event.keyCode==13){goToPageBySearch(); return false;}" id="searchTitle" style="width: 98%" value="">
						</td>
					</tr>
					<tr>
						<th style="text-align: center">
							<spring:message code='ezJournal.t201' />
						</th>
						<td>
							<input type="text" onfocus="journalKeywordClear(this);" onkeypress="if(event.keyCode==13){goToPageBySearch(); return false;}" id="searchContent" style="width: 98%" value="">
						</td>
					</tr>
					<tr>
						<th style="text-align: center">
							<spring:message code='ezJournal.t22' />
						</th>
						<td>
							<input type="text" onfocus="journalKeywordClear(this);" onkeypress="if(event.keyCode==13){goToPageBySearch(); return false;}" id="searchFormName" style="width: 98%" value="">
						</td>
					</tr>
					<tr>
						<th style="text-align: center">
							<spring:message code='ezJournal.t66' />
						</th>
						<td>
							<input type="text" id="Sdatepicker" style="width: 80px; text-align: center" readonly="readonly">
							~ 
							<input type="text" id="Edatepicker" style="width: 80px; text-align: center" readonly="readonly">
						</td>
					</tr>
				</table>
				<br />
				<table style="width: 100%">
					<tr>
						<td style="text-align: center;">
							<div class="btnpositionLayer">
								<a class="imgbtn"><span onClick="goToPageBySearch()"><spring:message code='ezJournal.t43' /></span></a>
							</div>	
						</td>
					</tr>
				</table>
			</div>	
		</div>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0, 0, 0, 0.5); display: none;" id="mailPanel_sub">&nbsp;</div>
	<div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel_sub">
		<iframe src="<spring:message code='ezJournal.t185' />" style="border: none;" id="iFrameLayer_sub"></iframe>
	</div>
	<div class="jquery-modal blocker current" id="selectSumJournal" style="display: none;">
		<div id="sumpopup" class="popupwrap1 modal" style="text-align: center; width: 300px; margin-bottom: 70px; left: 500px; display: inline-block;">
			<%-- 			<h1 style="margin-bottom:0px; padding-top:3px; height:40px; background-color: #0470e4; color:#fff; font-family: malgun-gothic;"><spring:message code='ezJournal.t70' /></h1> --%>
			<div class="popupJQLayer">
				<div class="title" style="text-align:left"><spring:message code='ezJournal.t70' /></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="sumSearchOptionHidden()"></span></a></li>
		            </ul>
		        </div>
				<table class="mainlist" id="basicFormList" style="width: 100%; border: 1px solid #ddd !important; border-top: none;">
					<!-- 				<tr> -->
					<%-- 					<th style="margin-bottom:0px; padding-top:3px; height:40px; background-color: #0470e4; color:#fff; font-family: malgun-gothic; text-align: center; border:1px solid #0470e4; font-size:18px; font-weight: bold;"><spring:message code='ezJournal.t70' /></th> --%>
					<!-- 				</tr>			 -->
				</table>
				<table style="width: 100%">
					<tr>
						<td style="text-align: center;">
							<div class="btnpositionLayer">
								<a class="imgbtn"><span onClick="writeSumJournal();"><spring:message code='ezJournal.t60' /></span></a>
							</div>	
						</td>
					</tr>
				</table>
			</div>	
		</div>
	</div>

	<script type="text/javascript">
	function journalPreviewEnd(e) {
	    if (PreviewW_Move || PreviewH_Move) {
	        document.getElementById("ResizeBarH").style.display = "none";
	        document.getElementById("ResizeBarW").style.display = "none";
	        document.getElementById("mailPanel").style.display = "none";
	        
	        if (PreviewH_Move) {
	            var newPos_H = parseInt(document.getElementById("ResizeBarH").style.left) - 10;
	            
	            if (pMailListWidthH > newPos_H) {
	                pMailPreWidthH = pMailPreWidthH + (pMailListWidthH - newPos_H);
	                pMailListWidthH = newPos_H;
	            } else {
	                pMailPreWidthH = CurrenWidth - newPos_H;
	                pMailListWidthH = newPos_H;
	            }
	            
// 	            document.getElementById("ifrmPreViewH").style.display = "";
	            document.getElementById("Preview_ContentH").style.display = "";
	            document.getElementById("MailListRayer").style.height = CurrentHeight + "px";
	            document.getElementById("PreviewRayerH").style.height = CurrentHeight + "px";
	            document.getElementById("MailListRayer").style.width = pMailListWidthH + "px";
	            document.getElementById("divList").style.height = (CurrentHeight - 62) + "px";
	            document.getElementById("journalListBody").style.height = (CurrentHeight - 100) + "px";
	            document.getElementById("PreviewRayerH").style.width = (pMailPreWidthH - 70) + "px";
	            document.getElementById("PreContent_RayerH").style.width = (pMailPreWidthH - 10) + "px";
// 	            document.getElementById("ifrmPreViewH").style.height = (CurrentHeight - 80) + "px";
	            document.getElementById("Preview_ContentH").style.height = (CurrentHeight - 65) + "px";
	            if(document.getElementById("PreH_subject")!=null){
                    document.getElementById("PreH_subject").style.width = (pMailPreWidthH - 155) + "px";
                }
	            pMailListDiv_H = (pMailListWidthH / CurrenWidth) * 100;
	            pMailPreVDiv_H = (pMailPreWidthH / CurrenWidth) * 100;

	        } else if (PreviewW_Move) {
	            var newPos_W = parseInt(document.getElementById("ResizeBarW").style.top) - 90;
	            if (pMailListHeightW > newPos_W) {
	                pMailPreHeightW = pMailPreHeightW + (pMailListHeightW - newPos_W);
	                pMailListHeightW = newPos_W;
	            } else {
	                pMailPreHeightW = CurrentHeight - newPos_W;
	                pMailListHeightW = newPos_W;
	            }
// 	            document.getElementById("ifrmPreViewW").style.display = "";
	            document.getElementById("Preview_ContentW").style.display = "";
	            document.getElementById("MailListRayer").style.width = "100%";
	            document.getElementById("PreviewRayerW").style.width = "100%";
	            document.getElementById("MailListRayer").style.height = pMailListHeightW + "px";
	            document.getElementById("divList").style.height = (pMailListHeightW - 62) + "px";
	            document.getElementById("journalListBody").style.height = (pMailListHeightW - 100) + "px";
	            document.getElementById("PreviewRayerW").style.height = (pMailPreHeightW + 45) + "px";

//                 document.getElementById("ifrmPreViewW").style.height = (pMailPreHeightW - 95) + "px";
                document.getElementById("Preview_ContentW").style.height = (pMailPreHeightW - 95) + "px";
	            pMailListDiv = (pMailListHeightW / CurrentHeight) * 100;
	            pMailPreVDiv = (pMailPreHeightW / CurrentHeight) * 100;
	        }
	        PreviewH_Move = false;
	        PreviewW_Move = false;
	        saveJournalEnv();
	    }
	}

	//미리보기화면 사이즈 조절
	function journalPreviewResize(e) {
	    if (PreviewH_Move) {
	        curevent = (typeof event == 'undefined' ? e : event);
	        var minSize = parseInt(200);
	        var maxSize = parseInt(document.documentElement.clientWidth - 200);
	        if (curevent.clientX > maxSize || curevent.clientX < minSize) {
	        	journalPreviewEnd(e);
	        } else {
	            var newPos_H = curevent.clientX;

	            if (newPos_H < parseInt(CurrenWidth * 0.40)) {
	                newPos_H = parseInt(CurrenWidth * 0.40);
	                SmallSizeList = true;
	            }
	            else if (newPos_H > parseInt(CurrenWidth * 0.65)) {
	                newPos_H = parseInt(CurrenWidth * 0.65);
	            }

	            if (newPos_H > parseInt(CurrenWidth * 0.40))
	                SmallSizeList = false;

	            document.getElementById("ResizeBarH").style.left = newPos_H + "px";
	        }
	    } else if (PreviewW_Move) {
	        curevent = (typeof event == 'undefined' ? e : event);
	        var minSize = parseInt(100);
	        var maxSize = parseInt(document.documentElement.clientHeight - 100);

	        if (curevent.clientY > maxSize || curevent.clientY < minSize) {
	        	journalPreviewEnd(e);
	        } else {
	            var newPos_W = curevent.clientY;
	            
	            if (newPos_W < (parseInt(CurrentHeight * 0.25) + 90)) {
	                newPos_W = parseInt(CurrentHeight * 0.25) + 90;
	            } else if (newPos_W > (parseInt(CurrentHeight * 0.65) + 90)) {
	                newPos_W = (parseInt(CurrentHeight * 0.65) + 90);
	            }
	            
	            document.getElementById("ResizeBarW").style.top = newPos_W + "px";
	        }
	    }
	}
	
	function PreviewH_onMouserDown(e) {
	    curevent = (typeof event == 'undefined' ? e : event);

	    var newPos_H = curevent.clientX;

	    if (newPos_H < parseInt(CurrenWidth * 0.40)) {
	        newPos_H = parseInt(CurrenWidth * 0.40);
	    }
	    else if (newPos_H > parseInt(CurrenWidth * 0.65)) {
	        newPos_H = parseInt(CurrenWidth * 0.65);
	    }

	    document.getElementById("ResizeBarH").style.left = newPos_H + "px";
	    document.getElementById("ResizeBarH").style.display = "";
	    document.getElementById("mailPanel").style.display = "";
	    PreviewH_Move = true;
	}
	function PreviewW_onMouserDown(e) {
	    curevent = (typeof event == 'undefined' ? e : event);

	    var newPos_W = curevent.clientY;

	    if (newPos_W < (parseInt(CurrentHeight * 0.25) + 90)) {
	        newPos_W = parseInt(CurrentHeight * 0.25) + 90;
	    }
	    else if (newPos_W > (parseInt(CurrentHeight * 0.65) + 90)) {
	        newPos_W = (parseInt(CurrentHeight * 0.65) + 90);
	    }

	    document.getElementById("ResizeBarW").style.top = newPos_W + "px";
	    document.getElementById("ResizeBarW").style.display = "";
	    document.getElementById("mailPanel").style.display = "";
	    PreviewW_Move = true;
	}
	
	//유저정보
	function OpenUserInfo(pUserID) {
		var result = GetOpenWindow("/ezCommon/showPersonInfo.do?id=" + pUserID, "UserInfo", 420, 450, "NO");
	}
	
	 //일지 상세화면
	function goJournalDetail(elem){
		var vc = $(elem).find(".viewCount");
		if($(elem).hasClass("noView")){
			if($(elem).attr("mine") == 'N'){
   				$(vc).text(parseInt($(vc).text()) + 1);
			}
   			$(elem).removeClass("noView");
		}
// 	 	var pheight = window.sc reen.availHeight;
//         var pwidth = window.screen.availWidth;
//         var pTop = (pheight - 720) / 2;
//         var pLeft = (pwidth - 765) / 2;
		var journalId = $(elem).attr("id");
		var feature = GetOpenPosition(820, 850);
		var Openwin;
		if (listType === "temp") {
			var typeId = $(elem).attr("typeId");
			Openwin = window.open("/ezJournal/journalWrite.do?typeId=" + typeId + "&journalId=" + journalId + "&mode=temp", "",
							"width=820, height=850, status=no, toolbar=no, menubar=no, location=no, resizable=1"
								+ feature);
			Openwin.focus();
		} else {
			Openwin = window.open("/ezJournal/journalDetail.do?journalId=" + journalId + "&pPreviewShow_HOW=D", "",
					"width=820, height=850, status=no, toolbar=no, menubar=no, location=no, resizable=1"
					+ feature);
			Openwin.focus();
			if(listType == 'recv'){
				$(elem).find("td:eq(1)").find("img").attr("src", "/images/ImgIcon/icon-msg-read.gif");
			}
		}
	}
	 
	 function quickReply(journalId,journalTitle){
		 replyJournalTitle = journalTitle;
// 		var heigth = window.screen.availHeight;
//         var width = window.screen.availWidth;
//         var left = (width - 500) / 2;
//         var top = (heigth - 300) / 2;
//         var szHref = "/ezJournal/journalReply.do?journalId="+journalId;
//         DivPopUpShow_sub(520, 420, szHref);
		 DivPopUpShow_sub($('body').prop('scrollWidth') * 0.6, $('body').prop('scrollHeight') * 0.6, "/ezJournal/journalReply.do?journalId=" + journalId);
	 }
	 
	function setTotalCount(totalCount) {
		if (!totalCount) {
			totalCount = 0;
		}
		$("#totalCount").text(totalCount);
	}
	
	function setRecvCount() {
		$.ajax({
			type:"post",
			url:"/ezJournal/leftRecvCount.do",
			success: function(data){
				if(!data){
					$("#recvCount").text("0");
				}else{
					$("#recvCount").text(data);
				}
			}
		});
    }
	<c:if test="${listType eq 'department' or listType eq 'mine' }">
		setFormName();
	</c:if>
	<c:if test="${listType eq 'recv' }">
		setRecvCount();
	</c:if>
	</script>
</body>
</html>