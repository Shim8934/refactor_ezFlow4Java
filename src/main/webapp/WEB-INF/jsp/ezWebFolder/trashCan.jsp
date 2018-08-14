<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('ezWebFolder.i1', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
	<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/Tab.css")%>" type="text/css">

	<!-- date Picker -->
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/js/jquery/dateControls/jquery.ui.all.css")%>">
	<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/js/jquery/dateControls/demos.css")%>">
	<script type="text/javascript" src="${util.addVer('/js/ezOrgan/ListView_list.js')}"></script>
	
	<!-- time picker-->
	<link rel="stylesheet" type="text/css" href="<%=CommonUtil.addVer(application, "/js/jquery/timeControls/jquery.timepicker.css")%>" />
	<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
	<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/pageNav.js')}"></script>
	<link rel="stylesheet" href="<%=CommonUtil.addVer(application, "/css/ezWebFolder/webfolder.css")%>" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/adminTable.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
	<link href="<%=CommonUtil.addVer(application, "/js/jquery/jquery.modal.css")%>" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
   		var lang = ${userInfo.lang};
		var strErr		= "<spring:message code = 'ezWebFolder.t107'/>";
		var strLang39	= "<spring:message code = 'ezWebFolder.t135'/>";
		var strLang40 	= "<spring:message code = 'ezWebFolder.t136'/>";
		var strLang41   = "<spring:message code = 'ezWebFolder.t137'/>";
		var strLang42   = "<spring:message code = 'ezWebFolder.t138'/>";
		var strNoData   = "<spring:message code = 'ezWebFolder.t144'/>";
		
		var currentPage = 1;
		var totalPages = 0 ;
		var totalRows = 0 ;
		var blockSize = ${listCount};
		var pStart = 0;
		var pEnd =10;
		var fileCnt = 0;
		var folderCnt = 0;
		var trashCanList = [];
		var searchFileType = "";
		var enrollStartDate = "";
		var enrollEndDate = "";
		var delStartDate = "";
		var delEndDate = "";
		var searchExt = "";               
        var searchFileName = "";
        var searchCreateName = "";
        var tableView = new TableView();
		
		window.onresize = function () {
			var reheight = document.documentElement.clientHeight - 170;
			document.getElementById("dragDropArea").style.height = reheight + "px";
		};
		
		document.onselectstart = function() {return false;};
		
		window.onbeforeunload = function() {
			hiddenPanel();
			searchOptionHidden();
		}
		
		window.onload = function() {
			hiddenPanel();
			tableView.setTableId("tblFileList");
			tableView.setTableType("deletedfile");
			tableView.setSelectedClass("bnkWebFolder2");
			tableView.setUnselectClass("bnkWebFolder");
			tableView.setCallBack(refreshView);
			
			document.getElementById("listcount").value = blockSize;
			renderFileList();
			window.onresize();
			
			// listoption 다른 곳 클릭시 숨김 처리
			var listOptionHidden = function(event) {
				if (document.getElementById("webfolderlistoptiondiv").getAttribute('mode') == "on"
						&& !document.getElementById("layer_Viewpopup").contains(event.target)
						&& event.target.id !== "webfolderlistoptiondiv") {
					optionHidden();
				}
			};
			
			document.addEventListener("mouseup", listOptionHidden, true);
			parent.frames["left"].document.addEventListener("mouseup", listOptionHidden, true);
			parent.parent.document.getElementById("topFrame").contentWindow.document.addEventListener("mouseup", listOptionHidden, true);
			
			// listoption 클릭 이벤트
			document.getElementById("webfolderlistoptiondiv").addEventListener("click", function(event) {
				event.stopPropagation();
				optionView(event.target);
			});
			
			document.getElementById("listcount").addEventListener("change", function(event) {
				optionHidden();
				blockSize = this.value;
				currentPage = 1;
				renderFileList();
			});
	        
	        $(".datepicker").datepicker({
	            changeMonth: true,
	            changeYear: true,
	            autoSize: true,
	            showOn: "both",
	            buttonImage: "/images/ImgIcon/calendar-month.gif",
	            buttonImageOnly: true
	        });
	
	        $(".datepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $(".datepicker").datepicker('setDate', "");
	        
	        var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
		    
	        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
	        	closeText: "<spring:message code='main.t3' />",
	            prevText: "<spring:message code='main.t0604' />",
	            nextText: "<spring:message code='main.t0605' />",
				currentText: "<spring:message code='main.t0606' />",
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
	        
	        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		}
	    
	    function changeValue(value) {
	    	   searchFileType = value;
	    	   currentPage = 1;
	    	   refreshView();
	    }
	    
	    function renderFileList() {
	    	var orderInf = tableView.getOrderInfo();
	    	showProgress();
	    	
			$.ajax ({
				type: "POST",
				async: true,
				url : "/ezWebFolder/getTrashCanList.do",
				dataType: "json",
				data : {
					"currPage"   : currentPage,
					"searchExt" : $('#searchExt').val(),
					"searchFileName" : $('#searchFileName').val(),
					"searchCreateName" : $('#searchCreateName').val(),
					"enrollStartDate" : $('#enrollStartDate').val(),
					"enrollEndDate" : $('#enrollEndDate').val(),
					"delStartDate" : $('#delStartDate').val(),
					"delEndDate" : $('#delEndDate').val(),
					"searchFileType" : searchFileType,
					"column"         : orderInf.col ? orderInf.col : "",
					"order"          : orderInf.ord ? orderInf.ord : "",
					"listCount" : blockSize
				},
				success : function (data) {
					result = data.data;
					
					trashCanList = result.trashCanList;
					fileCnt = result.fileCnt;
					folderCnt = result.folderCnt;
					currentPage = result.currPage;
					totalPages = result.totalPages;
					totalRows = result.totalRows;
					
					if (fileCnt == null) {
						fileCnt = 0;
					}
					
					if (folderCnt == null) {
						folderCnt = 0;
					}
					
					$('#tblFileList tr td').remove();
					renderFileListElement(trashCanList);
					makePageSelPage();
					document.getElementById("mailBoxInfo").innerHTML = " - [ 폴더 " + "<span style='color:#017BEC;'>" 
					+ folderCnt +" </span>"+ strLang42 +" / 파일 " + "<span style='color:#017BEC;'>" + fileCnt +" </span>" + strLang42 + "]";
					hideProgress();
				},
				error : function(error) {
					hideProgress();
// 					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			})
			
		};
		
		function renderFileListElement(result) {
			tableView.setDataSource(result);
			tableView.renderTable();
		}
		
		function setStyles(elements, excutor) {
			var length = elements.length;
			
			for (var i = 0; i < length; i++) {
				excutor(elements[i].style);
			}
		}
		
	   	function btn_PostDate_Clear() {
	        $(".datepicker").datepicker('setDate', "");
	    }
	    
	    function goToPageByNum(Value){
	    	currentPage = Value;
	        pStart = (blockSize * (currentPage))- blockSize;
	        pEnd = blockSize;
	        renderFileList();
	    }
	    
   		function search(type) {
	        if (type == "basic") {
				if ($("#searchExt").val() == "" && $("#searchFileName").val() == "" && $("#searchCreateName").val() == "" && $("#enrollStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" 
				  && $("#enrollEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#delStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() == ""  
				  && $("#delEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
				     alert("<spring:message code='ezWebFolder.t163' />");// 검색조건을 입력하세요 
				     return;
				 }
				
				 if ($("#enrollStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "" && $("#enrollEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
				     alert("<spring:message code='ezWebFolder.t308' />");
				     return;
				 }
				 
				 if ($("#enrollEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "" && $("#enrollStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
				     alert("<spring:message code='ezWebFolder.t309' />");
				     return;
				 }
				 
				 if ($("#delStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "" && $("#delEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
				     alert("<spring:message code='ezWebFolder.t308' />");
				     return;
				 }
				 
				 if ($("#delEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "" && $("#delStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
				     alert("<spring:message code='ezWebFolder.t309' />");
				     return;
				 }
				 
				 if (new Date($("#enrollStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val()) > new Date($("#enrollEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val())) {
				     alert("<spring:message code='ezWebFolder.t164' />");
				     return;
				 }
				 
				 if (new Date($("#delStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val()) > new Date($("#delEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val())) {
				     alert("<spring:message code='ezWebFolder.t164' />");
				     return;
				 }
	        } else if (type == "quick") {
	            if (document.getElementById("txt_keyword").value == "") {
	                alert("<spring:message code='ezWebFolder.t163' />");
	                return;
	            }
	        }
	        
	        searchOptionHidden();
	        renderFileList();
	    }
	    
   	   function doLayerPopup(obj) {
			optionHidden();
			btn_PostDate_Clear();
		    $('#enrollStartDate').val(enrollStartDate);
		    $('#enrollEndDate').val(enrollEndDate) ;
		    $('#delStartDate').val(delStartDate);
		    $('#delEndDate').val(delEndDate) ;
		    $('#searchExt').val(searchExt);               
		    $('#searchFileName').val(searchFileName) ;
		    $('#searchCreateName').val(searchCreateName);
		    
	        /* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
			var leftBody = parent.frames["left"].document.body;
			leftBody.style.overflow = "hidden";
	     	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].searchOptionHidden()'></div>").appendTo(leftBody);        	
	     	
	     	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	     	
	     	$("#searchpopup").css("left", popupX);
	     	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */

	     	$("#searchpopup").modal();
        	$("#searchpopup").off("modal:close").on("modal:close", function() {
        		parent.frames["left"].document.body.style.overflow = "auto";
        	});
	    }
   	   
	    function searchOptionHidden() {
	    	$.modal.close();
	        document.getElementById("SearchOption").setAttribute("mode", "off");
	    }
   	   
		function optionView(obj){
			if (obj.getAttribute("mode") == "off") {
			    document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 260 + "px";
				document.getElementById("layer_Viewpopup").style.top = "100px";
				document.getElementById("layer_Viewpopup").style.display = "";
				obj.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
				obj.setAttribute("mode", "on");
			} else {
				optionHidden();
			}
		}
   	   
	 	function optionHidden() {
			document.getElementById("layer_Viewpopup").style.display = "none";
			document.getElementById("webfolderlistoptiondiv").setAttribute("mode", "off");
			document.getElementById("webfolderlistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");    
	 	}
         
		function refreshView() {
			renderFileList();
			window.parent.frames["left"].drawVolume();
		}
       
		function filePermanentDelete() {
			var listOfChecked = document.getElementsByClassName("bnkWebFolder2");
    	   
			if (listOfChecked.length <= 0) {
				alert("<spring:message code = 'ezWebFolder.t295'/>");
				return;
			}
	   	   
		   	var filesList  = [];
			var folderList = [];
			
			for (var i = 0; i < listOfChecked.length; i++) {
				var fileFolderId = listOfChecked[i].getAttribute("targetid");
				
				if (listOfChecked[i].getAttribute("ext") == 'folder') {
					folderList.push(fileFolderId);
				} else {
					filesList.push(fileFolderId);
				}
			}
			
			showPanel(450, 250, "/ezWebFolder/permanentDeleteConfirm.do?fileList=" + filesList.toString() + "&folderList=" + folderList.toString());
			refreshView();
		}

		function changeCount(value) {
			blockSize = value;
			currentPage = 1;
			renderFileList();
		}
       
		function showPanel(popUpW, popUpH, URL) {
			try {
				var Position = DivPopUpPosition(popUpW, popUpH);
				
				document.getElementById("iFrameLayer").src = URL;
				document.getElementById("iFramePanel").style.top = Position[0] + "px";
				document.getElementById("iFramePanel").style.right = Position[1] + "px";
				document.getElementById("iFramePanel").style.height = popUpH + "px";
				document.getElementById("iFrameLayer").style.width = popUpW + "px";
				document.getElementById("iFrameLayer").style.height = popUpH + "px";
				document.getElementById("mailPanel").style.display = "";
				document.getElementById("iFramePanel").style.display = "";
				parent.frames["left"].showPanel();
			} catch (e) {}
		}
       
		function hiddenPanel () {
			try {
				document.getElementById("mailPanel").style.display = "none";
				document.getElementById("iFramePanel").style.display = "none";
				document.getElementById("iFrameLayer").src = "/blank.htm";
				parent.frames["left"].hiddenPanel();
			} catch (e) {}
		}
		
		function restoreTrashCan() {
			var listOfChecked = document.getElementsByClassName("bnkWebFolder2");
    	   
			if (listOfChecked.length <= 0) {
				alert("<spring:message code = 'ezWebFolder.t295'/>");
				return;
			}
	   	   
		   	var filesList  = [];
			var folderList = [];
			
			for (var i = 0; i < listOfChecked.length; i++) {
				var fileFolderId = listOfChecked[i].getAttribute("targetid");
				
				if (listOfChecked[i].getAttribute("ext") == 'folder') {
					folderList.push(fileFolderId);
				} else {
					filesList.push(fileFolderId);
				}
			}
    	  
    		$.ajax ({
				type: "POST",
				async: false,
				url : "/ezWebFolder/restoreTrashCan.do",
				dataType: "json",
				data: {
					"fileList": filesList.toString(),
					"folderList":  folderList.toString()
				},
				success : function (data) {
					if (data.code == 0) {
						alert("<spring:message code = 'ezWebFolder.t289'/>");
					} else if (data.code == 2) {
					   alert("<spring:message code = 'ezWebFolder.t292'/>");
					} else if (data.code == 3) {
						alert("<spring:message code = 'ezWebFolder.t28'/>");
					} else if (data.code == 4) {
						alert("<spring:message code = 'ezWebFolder.t290'/>");
					}
				},
				error : function(error) {
					alert(messages.strLang7 + error);
				}
			});
    		
			refreshView();
		}
       
		function moveTraschCan() {
			var listOfChecked = document.getElementsByClassName("bnkWebFolder2");
		 	   
			if (listOfChecked.length <= 0) {
				alert("<spring:message code = 'ezWebFolder.t295'/>");
				return;
			}
		 	   
			var filesList  = [];
			var folderList = [];
		
			for (var i = 0; i < listOfChecked.length; i++) {
				var fileFolderId = listOfChecked[i].getAttribute("targetid");
				
				if (listOfChecked[i].getAttribute("ext") == 'folder') {
					folderList.push(fileFolderId);
				} else {
					filesList.push(fileFolderId);
				}
			}
		 	   
			var openWin = window.open("/ezWebFolder/moveTrashCanManage.do?folderType=C&fileList=" + filesList.toString() + "&folderList=" + folderList.toString(), "", GetOpenWindowfeature(460, 490));
			try { openWin.focus(); } catch (e) {}
			   
		    refreshView();
		}
    </script>
</head>
<body class="mainbody">
    <h1><spring:message code='ezWebFolder.t269'/><span id="mailBoxInfo"></span></h1>
	<div id="mainmenu">
		<ul>
			<li><span onClick="restoreTrashCan()"><spring:message code='ezWebFolder.t287'/></span></li>
			<li><span onClick="moveTraschCan()"><spring:message code='ezWebFolder.t282'/></span></li>
			<li><span onClick="filePermanentDelete()"><spring:message code='ezWebFolder.t19'/></span></li>
			<li id="SearchOption" mode="off" onClick="doLayerPopup(this)"><span><spring:message code='ezWebFolder.t123'/></span></li>
			<li id="right" style="float:right;"><img src ="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="webfolderlistoptiondiv"></li>
			<!-- <li><img src="/images/i_bar.gif"></li> -->
			<li id="right" style="float:left; height: 28px;">
				<select class="select" id="idSelect" onchange="changeValue(this.value);">
					<option value=""><spring:message code='ezWebFolder.t191'/></option>
					<option value="document"><spring:message code='ezWebFolder.t192'/></option>
					<option value="music"><spring:message code='ezWebFolder.t193'/></option>
					<option value="video"><spring:message code='ezWebFolder.t194'/></option>
					<option value="image"><spring:message code='ezWebFolder.t195'/></option>
					<option value="folder"><spring:message code='ezWebFolder.t213'/></option>
					<option value="zip"><spring:message code='ezWebFolder.t196'/></option>
					<option value="unknown"><spring:message code='ezWebFolder.t311'/></option>
				</select>
			</li>
		</ul>
	</div>
	
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	</script>
 	
    <div id="progress-wrp" style="display: none;">
    	<div class="progress-bar"></div ><div class="status">0%</div>
    </div>
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
                            <select id="listcount" style="width: 40px; height: 20px;">
                                <option value="10">10</option>
                                <option value="20">20</option>
                                <option value="30">30</option>
                                <option value="40">40</option>
                                <option value="50">50</option>
                            </select>    
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="shadow">
        </div>
 	</div>
 	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id=""></div>
    <div style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
    <div style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarW"></div>
	<div id="dragDropArea" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)" style="margin: 10px 0px;overflow:auto;">
		<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileList">
			<tr>
				<th width="20px" ><input type="checkbox"></th>
				<th headers="ft" style="text-align: center; width: 20px;"><spring:message code='ezWebFolder.t188'/></th>
				<th headers="fn" style="width: 30%;"><spring:message code='ezWebFolder.t156'/></th>
				<th headers="fs" style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap; text-align: center; word-wrap: normal; width :6%;" ><spring:message code='ezWebFolder.t157'/></th>
				<th headers="un" style="width: 7%"><spring:message code='ezWebFolder.t189'/></th>
				<th headers="cd" style="width: 10%"><spring:message code='ezWebFolder.t190'/></th>
				<th headers="dd" style="width: 10%"><spring:message code='ezWebFolder.t288'/></th>
				<th              style="width: 25%"><spring:message code='ezWebFolder.t199'/></th>
			</tr>
		</table>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
        <iframe style="border:none;" id="iFrameLayer"></iframe>
    </div>
    <div id="searchpopup" class="popupwrap3" style="display:none;margin-bottom:70px">
		<div class="popupJQLayer" style="padding-top:6px">
			<div class="title"><spring:message code='ezWebFolder.t10' /><spring:message code='ezWebFolder.t123' /></div>
			<div id="close">
	            <ul>
	                <li><a rel="modal:close"><span onclick="searchOptionHidden()"></span></a></li>
	            </ul>
	        </div>	
			<table class="content" style="margin-top:10px;">
				<tr>
		           <th style="text-align:center"><spring:message code='ezWebFolder.t190' /></th>
		           <td>
		               <input type="text" class="datepicker" id="enrollStartDate" style="width:80px;text-align:center" readonly="readonly">
		                ~
		               <input type="text" class="datepicker" id="enrollEndDate" style="width:80px;text-align:center" readonly="readonly">
		           </td>
				</tr>
				<tr>
		           <th style="text-align:center"><spring:message code='ezWebFolder.t288' /></th>
		           <td>
		               <input type="text" class="datepicker" id="delStartDate" style="width:80px;text-align:center" readonly="readonly">
		                ~
		               <input type="text" class="datepicker" id="delEndDate" style="width:80px;text-align:center" readonly="readonly">
		           </td>
				</tr>
		        <tr>
		            <th style="text-align:center"><spring:message code='ezWebFolder.t152' /></th><!-- 확장자 -->
		            <td><input type="text" id="searchExt" style="width:99%" value="" name="searchExt"></td>
		        </tr>
		        <tr>
		            <th style="text-align:center"><spring:message code='ezWebFolder.t153' /></th><!-- 파일명 -->
		            <td><input type="text" id="searchFileName" style="width:99%" value="" name="searchFileName"></td>
		        </tr>  
		         <tr>
		            <th style="text-align:center"><spring:message code='ezWebFolder.t154' /></th><!-- 작성자 -->
		            <td><input type="text" id="searchCreateName" style="width:99%" value="" name="searchCreateName"></td>
		        </tr>    
			</table>
			<br/>
			<table style="width:100%">
				<tr>
					<td style="text-align:center;">
						<div class="btnpositionLayer">
							<a class="imgbtn"><span onClick="search('basic')"><spring:message code='ezWebFolder.t123' /></span></a>
						</div>	
					</td>
				</tr>
			</table>
		</div>
	</div>	
	<div id="tblPageRayer"></div>
	
	<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
		<img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
	</div>
		
	
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="<spring:message code='main.kms4'/>" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>
