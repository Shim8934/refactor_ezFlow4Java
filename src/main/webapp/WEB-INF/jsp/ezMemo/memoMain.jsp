<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
		<title></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezMemo.c1', 'msg')}" type="text/css">
		<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.css')}">
		<link rel="stylesheet" href="${util.addVer('/css/ezMemo/memo.css')}">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/font-awesome-4.7.0/css/font-awesome.min.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezMemo/memo.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezMemo.e1', 'msg')}"></script>
		<!-- data picker-->
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
		<!-- time picker-->
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
	</head>
	<script type="text/javascript">
		var memoList;
		var folderId =  "<c:out value='${folderId}' />";
		var topHeight = "100";
		var useDate;
		var fontSize;
		var memoColor;
		var defaultColor;
		var listType = 0;		// 정렬 보기 방식 선택
		var moveFlag = 0;		// 전체 메모일때 이동 보여주고, 아닐때 안보여줌
		var folders;
    	var searchInput;
		var startDate;
		var endDate;
		var dayArray = ["<spring:message code='main.t00052'/>", "<spring:message code='main.t00053'/>", "<spring:message code='main.t00054'/>", "<spring:message code='main.t00055'/>", "<spring:message code='main.t00056'/>", "<spring:message code='main.t00057'/>", "<spring:message code='main.t00058'/>"];
		window.onunload = Window_onunload;
		
	 	window.onresize = function () {
	 		/* 메모리스트 size 변경 */
	        var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
	        document.getElementById("bodyFrame").style.height = MainHeight + "px";
	        
	        /* 검색 레이어 팝업 위치 변경 */
	        var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
			$("#srarchpopup").css("left", popupX);		
			
			MailOptionHidden();
	 	}
	 	
	 	window.onbeforeunload = function() {
			
		};
	 	
		window.onload = function() {
			var MainHeight = document.documentElement.clientHeight - parseInt(topHeight);
	        document.getElementById("bodyFrame").style.height = MainHeight + "px";

			getMemoSortable();
			getMemoConfig();
			getFolderList();
			getMemoList();
			addremove();		// 메모지 이벤트 추가
			
			$($(window.parent.frames['left'].document)).mouseup(function (e) {
	    		MailOptionHiddenOutside(e);
	    	});
	    	
	    	$(parent.document).mouseup(function (e) {
	    		MailOptionHiddenOutside(e);
	    	});
	    	
	    	$(document).mouseup(function (e) {
	    		MailOptionHiddenOutside(e);
	    	});

	    }
		
		function getMemoSortable() {
			$("#boardMemoList").sortable({
	        	 containment: '#bodyFrame',
       		 	opacity : 0.5,
	        	 update : function (event, ui) {
	        		 if($("#orderOption").val() == 1) {
	        			 var compareElId; 
		        		 var clickedItem = ui.item;
		        		 var clickedItemId = clickedItem.attr("id");
		        		 
		        		 var draggedElId = clickedItemId.replace("memo", "");
		        		 
		        		 if (clickedItem.prev().attr("id") != undefined) {
		        			 if (clickedItem.next().attr("orders") == undefined || parseInt(clickedItem.attr("orders")) > parseInt(clickedItem.prev().attr("orders")) && parseInt(clickedItem.attr("orders")) > parseInt(clickedItem.next().attr("orders"))) {
		        				 
								compareElId = clickedItem.prev().attr("id").replace("memo", "");
		        			 } else {
		        				 
								compareElId = clickedItem.next().attr("id").replace("memo", "");
		        			 }
		        			
		        		 	
		        		 } else if (clickedItem.next().attr("id") != undefined) {
		        			 if (clickedItem.prev().attr("orders") == undefined || parseInt(clickedItem.attr("orders")) < parseInt(clickedItem.prev().attr("orders")) && parseInt(clickedItem.attr("orders")) < parseInt(clickedItem.next().attr("orders"))) {
		        				 
									compareElId = clickedItem.next().attr("id").replace("memo", "");
			        			 } else {
			        				 
									compareElId = clickedItem.prev().attr("id").replace("memo", "");
			        			 }
		        		 }
		        		 
		        		 $.ajax({
		        			type : "POST",
		        			data : {
		        				draggedElId : draggedElId,
		        				compareElId : compareElId
		        			},
		        			dataType : "JSON",
		        			url : "/ezMemo/reOrder.do",
		        			success : function(result) {
		        				
		        				if (result.status == 1) {
			        				//getMemoList();
			        				parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
		        				}
		        			}
		        		 });
		        		 
		        	 }
	        	 }
	        });
		}
		
		function getMemoConfig() {
			$.ajax({
				type : "GET",
				dataType : "json",
				async : false,
   				url : '/ezMemo/getMemoConfig.do',
   				success : function(result){
					fontSize = result.memoConfigVO.font_size;
					useDate = result.memoConfigVO.use_date;
					defaultColor = result.memoConfigVO.default_color;
				}
   			});
		}
		
		function getFolderList() {
			$.ajax({
				type : "GET",
				dataType : "json",
				async : false,
   				url : '/ezMemo/getMemoFoldersInfo.do',
   				success : function(result){
   					var opts = "<option value='0'><spring:message code='ezLadder.t011'/></option>";;
   					$(result.folders).each(function() {
   						var folderName = this.folder_name;
   						if (folderName.length > 11) {
   							folderName = folderName.substr(0, 10);
   							folderName += "...";
   						}
   						opts += "<option value=" + this.folder_id + ">" + folderName + "</option>";
   					})
   					$("#memoType").html(opts);
   				}
   			});
		}
		
		function getMemoList(type) {
			var orderOption = $("#orderOption").val();
			folderId = $("#memoType").val();
			
			if(type=="search") {
				searchInput = $("#searchTitle").val();
				startDate = $("#Sdatepicker").val();
				endDate = $("#Edatepicker").val();

				if(searchInput == "" && startDate == "" && endDate == "") {
					 alert("<spring:message code='ezBoard.t192' />");
		             return;
				}
				if(startDate != "" && endDate == "") {
					alert("<spring:message code='ezSystem.x0035' />");	
	                return;
				}
				if(startDate == "" && endDate != "") {
					alert("<spring:message code='ezSystem.x0036' />");	
	                return;
				}
				if(startDate > endDate) {
					alert("<spring:message code='ezBoard.t191' />");
	                return;
				}
				
				if (searchInput.indexOf("%") != -1) {
		            alert("'%'" + "<spring:message code='ezTask.jsh08' />");
		            return;
		        }
				
				BoardSearchOptionHidden();
			}
			else if(type=="folder") {
				checkOpt="off";
				searchInput = "";
				startDate = "";
				endDate = "";
			}
			
			$.ajax ({
 			   	url : '/ezMemo/getMemoList.do',
 			   	type : 'POST',
                dataType : 'json',
                data : { 
                	searchInput : searchInput,
                	startDate : startDate,
                	endDate : endDate,
                	folderId : folderId,
                	orderOption : orderOption
                },
                cache: false,
                success: function(result) {
                	memoColor = result["colorList"].split(";");
                	memoList = result["memoList"];
                	
					loadMemoList();
					setMemoCount(memoList.length);
					
					addremove();
			     },
	             error : function() {
	                	
	             }
			});
		}
		
		function setMemoCount(memoCount) {
			var str = " - [" + "<spring:message code='ezJournal.t54' />"
			+ "<span style='color:#017BEC;'> " + memoCount + " </span>"
			+ "<spring:message code='ezJournal.t55' />" + "]";
			$("#mailBoxInfo").html(str);
		}
		
		var checkOpt="off";
		function allClick() {
			// 체크 박스 모두 체크
			if(checkOpt == "off") {
				$("input[name=memo]:checkbox").each(function() {
					$(this).prop("checked", true);
				});
				checkOpt = "true";
			} else {
				$("input[name=memo]:checkbox").each(function() {
					$(this).prop("checked", false);
				});
				checkOpt = "off";
			}
		}
		
		// 메모 추가
		function newMemo() {
			$.ajax ({
 			   	url : '/ezMemo/memoWrite.do',
 			   	type : 'POST',
                dataType : 'json',
                data : { 
                	folderId : folderId
                },  
                cache: false,
                success: function(result) {
                	$(".memo_add").remove();

                	var memo = result["memo"];
                	insertMemo(memo);
                	setMemoCount($(".memoLay").length);
                	addremove();
                	parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
                },
                error : function() {
                	
                }
			});
		}
	    
	    // 메모 색상 변경
	    function modifyMemoColor(obj, idx) {
	    	var memoId = obj.attr("id").replace("memo", "");
	    	
	    	$.ajax ({
 			   	url : '/ezMemo/memoColorModify.do',
 			   	type : 'POST',
                dataType : 'json',
                data : { 
                	memoId : memoId,
                	colorId : idx
                },  
                cache: false,
                success: function(result) {
                	parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
                },
                error : function() {
                	
                }
			}); 
	    }
	    
		// 메모 내용 변경	    
	    function modifyMemo(obj) {
			var memoId = obj.getAttribute("memoid");
			var afterContents = $(".memoText[memoid=" + memoId + "]").val();

		    	$.ajax ({
	 			   	url : '/ezMemo/memoModify.do',
	 			   	type : 'POST',
	                dataType : 'json',
	                data : { 
	                	memoId : memoId,
	                	contents : afterContents
	                },  
	                cache: false,
	                success: function(result) {
	                	parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
	                },
	                error : function() {
	                	
	                }
				}); 
	    }
	    
	    // 메모 삭제
	    function DeleteItem_onclick() {
	    	var memo_ids = [];
	    	
			$(":checkbox[name=memo]:checked").each(function(){
				memo_ids.push($(this).val());
			});
			
			if (memo_ids.length == 0) {
	        	alert("<spring:message code='ezMemo.t0043' />");
	            return;
	        }
	    	
	    	if(confirm("<spring:message code='ezMemo.t0023'/>")) {
		    	$.ajax ({
	 			   	url : '/ezMemo/memoDelete.do',
	 			   	type : 'POST',
	                dataType : 'json',
	                data : { 
	                	memo_ids : memo_ids.join()
	                },  
	                cache: false,
	                success: function(result) {
	                	$(":checkbox[name=memo]:checked").each(function(){
	                		$("#memo"+$(this).val()).remove();
	        			});
	        			var memoLength = $("#boardMemoList .memoLay").length;
		            	if (memoLength == 0) {
		            		addEmptyMemo();
		            	}
	                	setMemoCount(memoLength);
	                	parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
	                },
	                error : function() {
	                	
	                }
				});
	    	}
	    	else {

	    	}
	    }
	    
	 // 모달 삭제 || 메모지 삭제
	    function modalDelete(memoId) {
	    	$.ajax ({  	
		        	url : '/ezMemo/memoDelete.do',
		 			type : 'POST',
		            dataType : 'json',
		            data : { 
		               	memo_ids : memoId
		            },  
		            async:false,
		            cache: false,
		            success: function(result) {
		            	$("#memo"+memoId).remove();
		            	var memoLength = $("#boardMemoList .memoLay").length;
		            	if (memoLength == 0) {
		            		addEmptyMemo();
		            	}
		            	setMemoCount(memoLength);
		            	parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
		            },
		            error : function() {
		                	
		            }
			});
	    }
	    
	 // 메모 숨김 처리
	    function memoDisplayChange() {	
			var memo_ids = [];
	    	var checkList = [];
			
			$(":checkbox[name=memo]:checked").each(function(){
				checkList.push($(this).val());
				if($(this).attr("display") == 0){
					memo_ids.push($(this).val());
					$(this).attr("display", "1");
					$(this).parent().parent().attr("style", "opacity : 0.5");
				} 
			});
			
			if (checkList.length == 0) {
	        	alert("<spring:message code='ezMemo.t0043' />");
	            return;
	        }
			
			if(memo_ids.length != 0) {
		    	$.ajax ({
		 			  url : '/ezMemo/memo-display.do',
		 			  type : 'POST',
		              dataType : 'json',
		              data : { 
		                memo_ids : memo_ids.join(),
		                display : 1
		              },  
		              cache: false,
		              success: function(result) {
		                parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
		              },
		              error : function() {
		            	  
		              }
				}); 
			}
	    	
	    	checkOpt = "true";
            allClick();
	    }
	    
	 // 메모 나타내기 처리
		function memoDisplayChange2() {		
			var memo_ids = [];
			var checkList = [];
			
			$(":checkbox[name=memo]:checked").each(function(){
				checkList.push($(this).val());
				if($(this).attr("display") == 1){
					memo_ids.push($(this).val());
					$(this).attr("display", "0");
					$(this).parent().parent().attr("style", "");
				} 
			});
			
			if (checkList.length == 0) {
	        	alert("<spring:message code='ezMemo.t0043' />");
	            return;
	        }
			
			if(memo_ids.length != 0) {
		    	$.ajax ({
		 			  url : '/ezMemo/memo-display.do',
		 			  type : 'POST',
		              dataType : 'json',
		              data : { 
		                memo_ids : memo_ids.join(),
		                display : 0
		              },  
		              cache: false,
		              success: function(result) {
		                parent.parent.getMemoList();			// 간이 메모의 리스트 새로고침
		              },
		              error : function() {
		                	
		              }
				}); 
			}
			
			checkOpt = "true";
            allClick();
	    }
	    
	  // 상세검색 레이어팝업
		function doLayerPopup() {
			btn_PostDate_Clear();
			$("#searchTitle").val('');
			
			$("<div id='blockLeft' class='blockLeft' style='position:fixed; width:100%;height:100%; overflow:hidden;' onclick='parent.frames[\"right\"].BoardSearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);
	    	parent.frames["left"].document.body.style.overflow = "hidden";
	    	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	    	$("#srarchpopup").css("left", popupX);
	    	$("#srarchpopup").modal();
	  }
	  
		var monthMsg = "<spring:message code='ezBoard.t218' />";
	    var monthStr = monthMsg.split(";");		    
	    var dayMsg = "<spring:message code='ezBoard.t216' />";
	    var dayStr = dayMsg.split(";");
	    
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

			$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			$("#Sdatepicker").datepicker('setDate', "");

			$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			$("#Edatepicker").datepicker('setDate', "");
			
			$.datepicker.regional["ko"] = {
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
		        $.datepicker.setDefaults($.datepicker.regional["ko"]);
		});
		
		// 레이어 팝업 생성된 상태에서 뒤로가기 이벤트 처리
		function Window_onunload() {
			if (parent.frames["left"]) {
        		if (parent.frames["left"].document.getElementById("blockLeft")) {
        			$(parent.frames["left"].document.body).css("overflow", "");
        	    	$(parent.frames["left"].document.getElementById("blockLeft")).remove();
        		}
        	}
		}
		
		var inputNameDlg_cross_dialogArguments = new Array();
		function memoMove() {
			var memo_ids = [];
			
			$(":checkbox[name=memo]:checked").each(function(){
				memo_ids.push($(this).val());
			});
			
			if (memo_ids.length == 0) {
	        	alert("<spring:message code='ezMemo.t0043' />");
	            return;
	        }
			
			var target = document.getElementById("memoType");
			
			inputNameDlg_cross_dialogArguments[0] = memo_ids.join();
		    inputNameDlg_cross_dialogArguments[1] = target.options[target.selectedIndex].text;
			
			var OpenWin = window.open("/ezMemo/memoFolderManage.do", "", GetOpenWindowfeature(500, 500));
            try { OpenWin.focus(); } catch (e) { }
		}
	</script>
	<body class="mainbody" style="overflow: hidden;" marginwidth="0" marginheight="0">
		<h1><spring:message code='ezMemo.t001'/><span id="mailBoxInfo"></span></h1>
		<div id="mainmenu">
		  <ul>
		        <li><span onclick="newMemo()"><spring:message code='ezMemo.t0014'/></span></li>
		        <li><span onClick="allClick()"><spring:message code='ezMemo.t0013'/></span></li>
		        <li><span onClick="DeleteItem_onclick()"><spring:message code='ezMemo.t0015'/></span></li>
		        <li><span onClick="doLayerPopup(this);"><spring:message code='ezMemo.t0016'/></span></li>
		        <li><span onClick="memoMove()"><spring:message code='ezMemo.t0022'/></span></li>
		        <li><span onClick="memoDisplayChange()"><spring:message code='ezMemo.t0017'/></span></li>
		        <li><span onClick="memoDisplayChange2()"><spring:message code='ezMemo.t0024'/></span></li>
		        <li><span onClick="refresh_onclick()"><spring:message code='ezMemo.t0018'/></span></li> 
		        <li><select id="memoType" style="height: 20px; width:175px;" onchange="getMemoList('folder')"></select></li>
		        <li id="right" class="off">
		        	<img src="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="maillistoptiondiv" onclick="MailOptionView(this);">
		        </li>
		  </ul>
		</div>
		<div style="width:100%; border-bottom: 1px solid #e8e8e8;"></div>
		<div id="bodyFrame" style="width:100%; overflow-y:auto; ">
 		 	<table class="mainlist" style="width:100%;">
 		 		<div id="boardMemoList">
		 		</div>
 		 	</table>
 		 </div>
 		<div style="width:100%; border-top: 1px solid #e8e8e8;"></div>
 	<div class="jquery-modal blocker current" id="layer_popup" style="display: none;">
 		 <div id="srarchpopup" class="popupwrap1 modal" style="margin-bottom: 70px; left: 297.5px; display: inline-block;">
			<div class="popupJQLayer">
				<div class="title"><spring:message code='ezMemo.t001' /><spring:message code='ezMemo.t0016' /></div>
				<div id="close">
		            <ul>
		                <li><a rel="modal:close"><span onclick="BoardSearchOptionHidden()"></span></a></li>
		            </ul>
		        </div>
				<table class="content">
					<tr>
						<th style="text-align: center">
							<spring:message code='ezBoard.garm01' />
						</th>
						<td>
							<input type="text" onfocus="this.value=''" onkeypress="if(event.keyCode==13){getMemoList('search'); return false;}" id="searchTitle" style="width: 100%;  margin-left: 0px;">
						</td>
					</tr>
					<tr>
						<th style="text-align: center">
							<spring:message code='ezBoard.t210' />
						</th>
						<td>
							<input type="text" id="Sdatepicker" style="width: 80px; text-align: center; margin-left: 0px;" readonly="readonly">
							~ 
							<input type="text" id="Edatepicker" style="width: 80px; text-align: center; margin-left: 0px;" readonly="readonly">
						</td>
					</tr>
				</table>
				<table style="width: 100%">
					<tr>
						<td style="text-align: center;">
							<div class="btnpositionLayer">
								<a class="imgbtn"><span onClick="btn_PostDate_Clear()"><spring:message code='ezBoard.t220' /></span></a>
								<a class="imgbtn"><span onClick="getMemoList('search');"><spring:message code='ezBoard.t188' /></span></a>
							</div>	
						</td>
					</tr>
				</table>
			</div>	
		</div>
	</div>
	
	<div id="layer_Viewpopup" style="width: 200px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
		<div class="popupwrap1">
			<div class="popupwrap2">
				<table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
					<caption></caption>
					<colgroup>
						<col style="width: 80px;">
						<col>
					</colgroup>
					<tr>
						<th><spring:message code='ezEmail.t99000035' /></th>
						<td>
							<select id="orderOption" style="WIDTH: 80px; height: 20px;" onchange="getMemoList();">
								<option value="1"><spring:message code='ezMemo.t0019'/></option>
                       		    <option value="2"><spring:message code='ezMemo.t0020'/></option>
                           		<option value="3"><spring:message code='ezMemo.t0021'/></option>
							</select>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="shadow"></div>
	</div>
	
	</body>
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	</script>
</html>