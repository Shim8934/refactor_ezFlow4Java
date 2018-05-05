<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/fileFolderDrop.js"></script>
	<link rel="stylesheet" href="/css/Tab.css" type="text/css">
	<!-- date Picker -->
	
	<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
	<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
	<script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>
	
	<!-- time picker-->
	<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
	<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
	<script type="text/javascript" src="<spring:message code='ezWebFolder.e1'/>"></script>
	<script type="text/javascript" src="/js/ezWebFolder/pageNav.js"></script>
	<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	<script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/adminTable.js"></script>
	<link href="/js/jquery/jquery.modal.css" rel="stylesheet" type="text/css" />
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
		
		window.onresize = function () {
			var divList          = document.getElementById("dragDropArea");
			var reheight         = document.documentElement.clientHeight - 160;
			divList.style.height = reheight + "px";
		};
		
		document.onselectstart = function(){
			return false;
		}
		
		$(function() {
			document.getElementById("listcount").value = blockSize;
			renderFileList();
			window.onresize();
			
			// listoption 다른 곳 클릭시 숨김 처리
			var listOptionHidden = function(event) {
				if (document.getElementById("webfolderlistoptiondiv").getAttribute('mode') == "on"
						&& !document.getElementById("layer_Viewpopup").contains(event.target)) {
					optionHidden();
				}
			};
			
			document.addEventListener("click", listOptionHidden);
			parent.frames["left"].document.addEventListener("click", listOptionHidden);
			parent.parent.document.getElementById("topFrame").contentWindow.document.addEventListener("click", listOptionHidden);
			
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
		});
	    
	    function changeValue(value) {
	    	   searchFileType = value;
	    	   
	    	   if( value == "all" ) {
	    		   searchFileType = "";
	    	   }
	    	   
	    	   currentPage = 1;
	    	   refreshView();
	    }
	    
	    function renderFileList() {
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
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			})
			
		};
		
		function renderFileListElement(result) {
			var tableView = new TableView();
			tableView.setTableId("tblFileList");
			tableView.setTableType("deletedfile");
			tableView.setSelectedClass("bnkWebFolder2");
			tableView.setUnselectClass("bnkWebFolder");
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
	        $(".Sdatepicker").datepicker('setDate', "");
	        $(".Edatepicker").datepicker('setDate', "");
	
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
	        		   && $("#delStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
	                alert("<spring:message code='ezBoard.t192' />");// 검색조건을 입력하세요 
	                return;
	            }
	
	            if ($("#enrollStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "" && $("#enrollStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
	                alert("<spring:message code='ezBoard.t189' />");
	                return;
	            }
	            if ($("#enrollEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#enrollEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "") {
	                alert("<spring:message code='ezBoard.t189' />");
	                return;
	            }
	            if ($("#delStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "" && $("#delStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
	                alert("<spring:message code='ezBoard.t189' />");
	                return;
	            }
	            if ($("#delEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#delEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "") {
	                alert("<spring:message code='ezBoard.t189' />");
	                return;
	            }
	            if (new Date($("#enrollStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val()) > new Date($("#enrollEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val())) {
	                alert("<spring:message code='ezBoard.t191' />");
	                return;
	            }
	            if (new Date($("#delStartDate").datepicker({ dateFormat: 'yy-mm-dd' }).val()) > new Date($("#delEndDate").datepicker({ dateFormat: 'yy-mm-dd' }).val())) {
	                alert("<spring:message code='ezBoard.t191' />");
	                return;
	            }
	        }
	        else if (type == "quick") {
	            if (document.getElementById("txt_keyword").value == "") {
	                alert("<spring:message code='ezBoard.t192' />");
	                return;
	            }
	        }
	        searchOptionHidden();
	        renderFileList();
	    }
	    
   		function clickRow(e) {
			e.stopPropagation();
			e.preventDefault();
			var trElmt    = e.currentTarget;
			var inputElmt = trElmt.firstElementChild.firstElementChild;
			
			if (inputElmt.checked == true) {
				inputElmt.checked = false;
				trElmt.setAttribute("class", "bnkWebFolder2");
			}
			else {
				inputElmt.checked = true;
				trElmt.setAttribute("class", "bnkWebFolder2");
			}
		}
		
		function getChecked(event) {
			event.stopPropagation();
			var checkboxElmt = event.currentTarget;
			var trElmt       = checkboxElmt.parentElement.parentElement;
			trElmt.setAttribute("class", checkboxElmt.checked == true ? "bnkWebFolder2" : "bnkWebFolder");
		}
		
		function getCheckAll(obj) {
			var listInputs = document.getElementsByClassName("checkBnk");
			
			if (obj.checked == true) {
				for (var i = 0; i < listInputs.length; i++) {
					listInputs[i].checked = true;
					var trElmt            = listInputs[i].parentElement.parentElement;
					trElmt.setAttribute("class", "bnkWebFolder2");
				}
			}
			else {
				for (var i = 0; i < listInputs.length; i++) {
					var trElmt            = listInputs[i].parentElement.parentElement;
					listInputs[i].checked = false;
					trElmt.setAttribute("class", "bnkWebFolder");
				}
			}
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
	     	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"left\"].SearchOptionHidden()'></div>").appendTo(parent.frames["left"].document.body);        	
	     	
	     	var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
	     	
	     	$("#srarchpopup").css("left", popupX);
	     	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	     	
	     	$("#srarchpopup").modal();
	     	
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
   	    }
   	    else {
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
				}
				else {
					filesList.push(fileFolderId);
				}
			}
    	   
    	   showPanel(450, 150, "/ezWebFolder/permanentDeleteConfirm.do?fileList=" + filesList.toString() + "&folderList=" + folderList.toString());
       
	       parent.frames["left"].drawVolume();
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
    	        document.getElementById("iFramePanel").style.left = Position[1] + "px";
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
				}
				else {
					filesList.push(fileFolderId);
				}
			}
    	  
    		$.ajax ({
				type: "POST",
				async: true,
				url : "/ezWebFolder/restoreTrashCan.do",
				dataType: "json",
				data : {
					"fileList" : filesList.toString(),
					"folderList" :  folderList.toString()
				},
				success : function (data) {
					if (data.code == 1) {
						alert("<spring:message code = 'ezWebFolder.t289'/>");
					} else if (data.code == 4) {
						alert("<spring:message code = 'ezWebFolder.t290'/>");
					}

					refreshView();
				},
				error : function(error) {
						alert("<spring:message code = 'ezWebFolder.t292'/>");
				}
			})
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
				}
				else {
					filesList.push(fileFolderId);
				}
			}
    	   
    	   var OpenWin = window.open("/ezWebFolder/moveTrashCanManage.do?folderType=C&fileList=" + filesList.toString() + "&folderList=" + folderList.toString(), "", GetOpenWindowfeature(450, 470));
           try { OpenWin.focus(); } catch (e) { }
           
           parent.frames["left"].drawVolume();
       }
    </script>
</head>
<body class="mainbody">
    <h1><spring:message code='ezWebFolder.t269'/><span id="mailBoxInfo"></span></h1>
	<div id="mainmenu2">
		<ul>
			<li id=""><a onClick="restoreTrashCan()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t287'/></span></a></li>
			<li id=""><a onClick="moveTraschCan()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t282'/></span></a></li>
			<li id=""><a onClick="filePermanentDelete()"   style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t19'/></span></a></li>
			<li id="SearchOption" mode="off" onClick="doLayerPopup(this)"><a style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t123'/></span></a></li>
			<li id="right" style="float:right;"><spring:message code='ezWebFolder.t215'/><img src ="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="webfolderlistoptiondiv"></li>
			<li id="right" style="float:left;">
				<select class="select" id="idSelect" onchange="changeValue(this.value);" style="height: 29px; border-radius: 3px; padding: 0px; width: 85px">
					<option value="all" selected><spring:message code='ezWebFolder.t191'/></option>
					<option value="document"><spring:message code='ezWebFolder.t192'/></option>
					<option value="music"><spring:message code='ezWebFolder.t193'/></option>
					<option value="video"><spring:message code='ezWebFolder.t194'/></option>
					<option value="image"><spring:message code='ezWebFolder.t195'/></option>
					<option value="folder"><spring:message code='ezWebFolder.t213'/></option>
					<option value="zip"><spring:message code='ezWebFolder.t196'/></option>
				</select>
			</li>
		</ul>
	</div>
	
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu2"), "ul", "li", "0");
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
				<th width="20px"><input type="checkbox" onchange="getCheckAll(this);" id="_checkAll"></th>
				<th width="40px"><spring:message code='ezWebFolder.t188'/></th>
				<th width="160px"><spring:message code='ezWebFolder.t156'/></th>
				<th width="60px"><spring:message code='ezWebFolder.t157'/></th>
				<th width="120px"><spring:message code='ezWebFolder.t189'/></th>
				<th width="80px"><spring:message code='ezWebFolder.t190'/></th>
				<th width="80px"><spring:message code='ezWebFolder.t288'/></th>
				<th width="160px"><spring:message code='ezWebFolder.t199'/></th>
			</tr>
		</table>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
        <iframe style="border:none;" id="iFrameLayer"></iframe>
    </div>
    <div id="srarchpopup" class="popupwrap3" style="display:none;padding-top:20px;padding-bottom:20px;margin-bottom:70px">
		<div class="popupwrap4">
			<table class="content" style="margin-top:10px;">  
				<tr>
					<th class="layerHeader" colspan="2"><img src="/images/kr/left/left_mail.png" style="vertical-align: middle;padding-bottom:1px"/>&nbsp;<spring:message code='ezWebFolder.t10' /></th>
				</tr>
				<tr>
		           <th style="text-align:center"><spring:message code='ezWebFolder.t190' /></th>
		           <td>
		               <input type="text" class="Sdatepicker datepicker" id="enrollStartDate" style="width:80px;text-align:center" readonly="readonly">
		                ~
		               <input type="text" class="Edatepicker datepicker" id="enrollStartDate" style="width:80px;text-align:center" readonly="readonly">
		           </td>
				</tr>
				<tr>
		           <th style="text-align:center"><spring:message code='ezWebFolder.t288' /></th>
		           <td>
		               <input type="text" class="Sdatepicker" id="delStartDate" style="width:80px;text-align:center" readonly="readonly">
		                ~
		               <input type="text" class="Edatepicker" id="delEndDate" style="width:80px;text-align:center" readonly="readonly">
		           </td>
				</tr>
		        <tr>
		            <th style="text-align:center"><spring:message code='ezWebFolder.t152' /></th><!-- 확장자 -->
		            <td><input type="text" id="searchExt" style="width:98%" value="" name="searchExt"></td>
		        </tr>
		        <tr>
		            <th style="text-align:center"><spring:message code='ezWebFolder.t153' /></th><!-- 파일명 -->
		            <td><input type="text" id="searchFileName" style="width:98%" value="" name="searchFileName"></td>
		        </tr>  
		         <tr>
		            <th style="text-align:center"><spring:message code='ezWebFolder.t154' /></th><!-- 작성자 -->
		            <td><input type="text" id="searchCreateName" style="width:98%" value="" name="searchCreateName"></td>
		        </tr>    
			</table>
			<br/>
			<table style="width:100%">
				<tr>
					<td style="text-align:center;">
						<a class="imgbtn"><span onClick="search('basic')"><spring:message code='ezAddress.t142' /></span></a>
						<a class="imgbtn" rel="modal:close"><span onClick="searchOptionHidden()"><spring:message code='ezAddress.t11' /></span></a>
					</td>
				</tr>
			</table>
		</div>
	</div>	
	<div id="tblPageRayer"></div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="<spring:message code='main.kms4'/>" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>