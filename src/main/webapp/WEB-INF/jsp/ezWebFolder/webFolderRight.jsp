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
	<script type="text/javascript" src="/js/ezWebFolder/pageNav.js"></script>
	<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
	<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	<!-- module -->
	<script type="text/javascript" src="/js/ezWebFolder/rowModule.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/favoriteModule.js"></script>
    <script type="text/javascript">
    	var file 		 = new Array();
		var primary      = "<c:out value='${primary}'/>";
		var strShared1	= "<spring:message code = 'ezWebFolder.t105'/>";
		var strShared2	= "<spring:message code = 'ezWebFolder.t106'/>";
		var strErr		= "<spring:message code = 'ezWebFolder.t107'/>";
		var appType     = "user";
		var userName = "${userInfo.userName}";
		var currentPage = "1";
		var totalPages = 0 ;
		var totalRows = 0 ;
		var blockSize = 0;
		var filelist = [];
		var strLang39	= "<spring:message code = 'ezWebFolder.t135'/>";
		var strLang40 	= "<spring:message code = 'ezWebFolder.t136'/>";
		var strLang41   = "<spring:message code = 'ezWebFolder.t137'/>";
		var strLang42   = "<spring:message code = 'ezWebFolder.t138'/>";
		var pStart = 0;
		var pEnd =10;
		var folderId = "${folderId}";
		var folderType = "${folderType}";
		var fileCnt ;
		var fldCnt;
		var originalPath = "";
		var folderPath = "";
		var pathArr = [];
		var pathArr2 = [];
		var searchFileType = "";
		var searchExt ="";
		var searchFileName = "";
		var searchCreateName = "";
		var searchStartDate = "";
		var searchEndDate = "";
		var folderUpp = "";
		
		// fileList 브라우저 화면 크기 변했을때 유동적화면 변화
		window.onresize = function () {
			var divList          = document.getElementById("dragDropArea");
			var reheight         = document.documentElement.clientHeight - 220;
			divList.style.height = reheight + "px";
		};
		
		document.onselectstart = function(){
			return false;
		}
		
		// fileList 화면 
		window.onload = function () {
			$('#upload').css('display','none');
			$('#idSelect').ddslick({
				onSelected: function(selectedElmt){
					//callback function: do something with selectedData;
					document.getElementById("idSelect").value = selectedElmt.selectedData["value"];
					changeValue(document.getElementById("idSelect").value);
				}
			});
			
			pEnd= pStart + blockSize;
// 			getFileList(folderId);
			var divList          = document.getElementById("dragDropArea");
			var reheight         = document.documentElement.clientHeight - 220;
			divList.style.height = reheight + "px";
	    };
	    
	    // 폴더관리
	    function folder_Manage() {
        	var OpenWin = window.open("/ezWebFolder/folderManage.do", "", GetOpenWindowfeature(500, 500));
            try { OpenWin.focus(); } catch (e) { }
        }
	    
	    
	    function getFileList(a){
	    	if(folderId == "") {
	    		alert("<spring:message code='ezWebFolder.t270'/>");
	    		return;
	    	}
	    	folderId = a;
			$.ajax ({
				type:"POST",
				async: false,
				url : "/ezWebFolder/fileList.do",
				data : { 
					 "folderId"   		: folderId,
					 "folderType" 		: folderType,
					 "currPage"   		: currentPage,
					 "listCount"  		: blockSize,
					 "pStart" 			: pStart,
					 "searchExt" 		: searchExt,
					 "searchFileName" 	: searchFileName,
					 "searchCreateName" : searchCreateName,
					 "searchFileType" 	: searchFileType,
					 "searchStartDate" 	: searchStartDate,
					 "searchEndDate" 	: searchEndDate
					},
				dataType: "JSON",
				success : function (data) {
					result = data.data;
					
					currentPage = result.currPage;
					totalRows = result.totalRows;
					fileCnt = result.fileCnt;
					fldCnt = result.fldCnt;
					
					blockSize = result.listCount;
					totalPages = result.totalPages;
					filelist = result.fileList;
					folderPath = result.folderPath;
					originalPath = result.originalPath;
					folderUpp = result.folderUpp;
					var dragDropAreaElmt = document.getElementById("dragDropArea");
					
					if (folderUpp != 'root') {
						$('#upload').css('display','inline');
						dragDropAreaElmt.ondragenter = function(e) {onDragEnter(e)};
						dragDropAreaElmt.ondragover  = function(e) {onDragOver(e)};
						dragDropAreaElmt.ondrop      = function(e) {onDrop(e)};
					} else {
						dragDropAreaElmt.ondragenter = null;
						dragDropAreaElmt.ondragover  = null;
						dragDropAreaElmt.ondragover  = null;
					}
					
// 					$("#originalPath").text(originalPath); 
					$('#tblFileList tr td').parent().remove();
					renderData(filelist);
					
					makePageSelPage();
					namePath(folderPath,originalPath);
					document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + " <spring:message code='ezWebFolder.t277'/>" + "<span style='color:#017BEC;'>" 
						+ fileCnt +"</span>"+", " +strLang41 + " <spring:message code='ezWebFolder.t276'/> " + "<span style='color:#017BEC;'>" + fldCnt +" </span>" + strLang42 + "]";
					$("#listcount").val(blockSize).prop("selected", true);
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134' />" + error);
				}
			})
			
		};
		
		// originalPath 는 한글 path
		// folderPath 는 숫자 
		function namePath(folderPath,originalPath) {
			var orginalPathElmt = document.getElementById("originalPath");
			path = originalPath.split("/");
			originPath = folderPath.split("|");
			$('#originalPath').empty();
			var nameTag = document.createElement("span");
			orginalPathElmt.appendChild(nameTag);
			for ( var i = 1; i< path.length - 1; i++) {
				var detailName = [];
				detailName = document.createElement("span");
				
				detailName.className = "aName";
				detailName.id = originPath[i];
				detailName.onclick = function() {
					nameFileList(this.id);
				};

				detailName.textContent = path[i] ;
				detailName.setAttribute("style", "font-size:22px; ");
				nameTag.appendChild(detailName);
				if(path.length ==3) {
					detailName = document.createElement("span");
					detailName.textContent =  "   * 해당 폴더는 하위폴더의 모든 파일을 보여줍니다.";
					detailName.setAttribute("style", "font-size:12px; ");
					nameTag.appendChild(detailName);
				}
				var imgElmt = document.createElement("img");
				imgElmt.setAttribute("style", "height: 18px; width: 18px; display: inline-block;");
				imgElmt.src = "/images/webfolder/arrow.png";
				
				
				
				
				if (i != path.length - 2) {
					nameTag.appendChild(imgElmt);
				}	
			}
			
		}
		
		function nameFileList(param) {
			searchFileType = "";  
			searchExt ="";        
			searchFileName = "";  
			searchCreateName = "";
			searchEndDate = "";
			searchStartDate = "";
			getFileList(param);
			$('#idSelect').ddslick('select', {index: 0 });
		}
		
		function renderData(result) {
			document.getElementById("_checkAll").checked = false;
			var tableList = document.getElementById("tblFileList");
			
			while (tableList.rows.length > 1) {
				tableList.deleteRow(1);
			}
			
			if (result == null || result.length == 0) {
				var trElmt = document.createElement("tr");
				var tdElmt = document.createElement("td");
				tdElmt.setAttribute("colspan", "10");
				tdElmt.setAttribute("align", "center");
				tdElmt.setAttribute("bgcolor", "#FFFFFF");
				tdElmt.innerHTML = "<spring:message code='ezWebFolder.t144' />";
				tdElmt.setAttribute("id", "nodataRow");
				
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
					var tdElmt9 = document.createElement("td");
// 					var tdElmt10 = document.createElement("td");
					var tdElmt10 = document.createElement("td");
					
					trElmt.setAttribute("class", "bnkWebFolder");
					trElmt.setAttribute("targetId", result[i]["fileId"]);
					trElmt.setAttribute("targetType", result[i]["fileTypeName"] == 'folder' ? 'folder' : 'file');
					trElmt.addEventListener("click", function(event) { rowModule.onRowClick(this); });
					
					var inputElmt = document.createElement("input");
					inputElmt.setAttribute("type", "checkbox");
					inputElmt.setAttribute("value", result[i]["fileId"]);
					inputElmt.setAttribute("class", "checkBnk");
					inputElmt.addEventListener("change", function(event) { event.stopPropagation(); rowModule.onCheckboxChange(this); });
					inputElmt.addEventListener("click", function(event) { event.stopPropagation(); });
					inputElmt.addEventListener("dblclick", function(event) { event.stopPropagation(); });
					
					tdElmt1.appendChild(inputElmt);
					
					var faImgElmt = document.createElement("img");
					faImgElmt.setAttribute("class", "noneDrag");
					faImgElmt.addEventListener("click", function() { favoriteModule.onImageClick(this); });
					faImgElmt.addEventListener("dblclick", function(event) { event.stopPropagation(); });
					
					if (result[i]["favouriteStatus"] == "0") {
						faImgElmt.src = "/images/ImgIcon/view-flag.gif";
					} else {
						faImgElmt.src = "/images/ImgIcon/icon-flag.gif";
						trElmt.setAttribute("favorite", "");
					}
					
					tdElmt2.appendChild(faImgElmt);
					
					var fileIconElmt = document.createElement("img");
					fileIconElmt.setAttribute("class", "webFolderImg");
					fileIconElmt.src = result[i]["fileIconUrl"];
					tdElmt3.appendChild(fileIconElmt);
					
					tdElmt4.textContent = result[i]["fileName"];
					tdElmt5.textContent = getFileSize(result[i]["fileSize"]);
					
// 					if (primary == "1") {
						tdElmt6.textContent = result[i]["createName1"];
// 					}
// 					else {
// 						tdElmt6.textContent = result[i]["createName2"];
// 					}
					
					tdElmt7.textContent = result[i]["createDate"].substring(0, 10);
					tdElmt8.textContent = result[i]["updateDate"].substring(0, 10);
					tdElmt9.textContent = result[i]["filePosition"];
// 					tdElmt10.textContent = result[i]["downloadCnt"];
// 					tdElmt10.setAttribute("style","text-align: center;");
					
					if (result[i]["fileShareStatus"] == "1") {
						tdElmt10.textContent = "<spring:message code='ezWebFolder.t105' />";
					}
					else {
						tdElmt10.textContent = "";
					}
					
					if(result[i]["typeId"] == "folder") {
						//trElmt.setAttribute("value", result[i]["fileId"]);
						trElmt.ondblclick = function() {
							//var val = $(this).attr('value');
							dbClickFunction(this);							
						};
					}
					
					trElmt.appendChild(tdElmt1);
					trElmt.appendChild(tdElmt2);
					trElmt.appendChild(tdElmt3);
					trElmt.appendChild(tdElmt4);
					trElmt.appendChild(tdElmt5);
					trElmt.appendChild(tdElmt6);
					trElmt.appendChild(tdElmt7);
					trElmt.appendChild(tdElmt8);
					trElmt.appendChild(tdElmt9);
					trElmt.appendChild(tdElmt10);
					
					tableList.appendChild(trElmt);
				}
			} 
		}
		
		function dbClickFunction(obj) {
			var folderId2 = obj.getAttribute("targetId");
			getFileList(folderId2);
		}
		
	   	$(function () {
	        $("#Sdatepicker").datepicker({
	            changeMonth: true,
	            changeYear: true,
	            autoSize: true,
	            showOn: "both",
	            buttonImage: "/images/ImgIcon/calendar-month.gif",
	            buttonImageOnly: true
	        });
	        $("#Edatepicker").datepicker({
	            changeMonth: true,
	            changeYear: true,
	            autoSize: true,
	            showOn: "both",
	            buttonImage: "/images/ImgIcon/calendar-month.gif",
	            buttonImageOnly: true
	        });
	
	        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#Sdatepicker").datepicker('setDate', "");
	
	        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $("#Edatepicker").datepicker('setDate', "");
	     });
	   	
	   	// 날짜 초기화 버튼
	   	function btn_PostDate_Clear() {
	        $("#Sdatepicker").datepicker('setDate', "");
	        $("#Edatepicker").datepicker('setDate', "");
	
	    }
	    
	    function goToPageByNum(Value){
	    	currentPage = Value;
	        pStart = (blockSize * (currentPage)) - blockSize;
	        pEnd = blockSize;
	        getFileList(folderId);
	    }
	    
	   	// TODO : 여기서부터 코드 정리하면서 내려가서 list 뿌리기 
   		function search(type) {
	        if (type == "basic") {
	
	           if ($("#searchExt").val() == "" && $("#searchFileName").val() == "" && $("#searchCreateName").val() == "" && $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
	                alert("<spring:message code='ezBoard.t192' />");// 검색조건을 입력하세요 
	                return;
	            }
	
	            if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "") {
	                alert("<spring:message code='ezBoard.t189' />");
	                return;
	            }
	            
	            if ($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() == "" && $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() != "") {
	                alert("<spring:message code='ezBoard.t189' />");
	                return;
	            }
	            
	            if (new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val()) > new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val())) {
	                alert("<spring:message code='ezBoard.t191' />");
	                return;
	            }
	            
	            searchExt = $('#searchExt').val();               
	            searchFileName = $('#searchFileName').val();     
	            searchCreateName = $('#searchCreateName').val(); 
	            searchStartDate = $('#Sdatepicker').val(); 
	            searchEndDate = $('#Edatepicker').val(); 
	        } else if (type == "quick") {
	            if (document.getElementById("txt_keyword").value == "") {
	                alert("<spring:message code='ezBoard.t192' />");
	                return;
	            }
	        }
	        searchOptionHidden();
// 	        MakeSubCondition();
	        getFileList(folderId);
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
			} else {
				for (var i = 0; i < listInputs.length; i++) {
					var trElmt            = listInputs[i].parentElement.parentElement;
					listInputs[i].checked = false;
					trElmt.setAttribute("class", "bnkWebFolder");
				}
			}
		}
		
		function doLayerPopup(obj) {
	        btn_PostDate_Clear();
	        document.getElementById("searchExt").value = "";
	        document.getElementById("searchFileName").value = "";
	        document.getElementById("searchCreateName").value = "";
	    
	        if (obj.getAttribute("mode") == "off") {
	            document.getElementById("layer_popup").style.left = "10px";
// 	            if (pAdminType == "y")
// 	                document.getElementById("layer_popup").style.top = "56px";
// 	            else
	                document.getElementById("layer_popup").style.top = "100px";
	            document.getElementById("layer_popup").style.display = "";           
	            obj.setAttribute("mode", "on");
	        } else {
	        	searchOptionHidden();
	        }
	    }
		
	    function searchOptionHidden() {
	        document.getElementById("layer_popup").style.display = "none";
	        document.getElementById("SearchOption").setAttribute("mode", "off");
	    }
   	   
	    function optionView(obj){
	   		 if (obj.getAttribute("mode") == "off") {
	   	        document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 260 + "px";
//	    	        if(pAdminType == "y")
	   	            document.getElementById("layer_Viewpopup").style.top = "130px";
//	    	        else
//	    	            document.getElementById("layer_Viewpopup").style.top = "100px";
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
	 	
       function fileDownload() {
			var selected = getSelectedFoldersAndFiles();
			
			if (selected === undefined) {
				return;
			}
    		
    		var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + selected.files.toString() + "&folderList=" + selected.folders.toString();
			
			AttachDownFrame.location.href = downloadUrl;
       }
       
       function fileUpload() {
    	   document.getElementById("file").click();
    	   refreshView();
       }
       
       function refreshView() {
    	   getFileList(folderId);
       }
       
       function fileDelete() {
			var selected = getSelectedFoldersAndFiles();
			
			if (selected === undefined) {
				return;
			}
			
			if (selected.folders.length > 0) {
				alert("<spring:message code = 'ezWebFolder.t20'/>");
				return;
			}
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/checkPermission.do",
				data: {
					"fileList" : selected.files.toString()
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var result = data.resultValue;
					
					if (result != "ok") {
						alert("<spring:message code='ezWebFolder.t243'/>");
					} else {
						DivPopUpShow(450, 150, "/ezWebFolder/deleteConfirm.do?fileList=" + selected.files.toString());
					}
					
					refreshView();
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});
		}
		
		function fileRename() {
			var selected = getSelectedFoldersAndFiles();
			
			if (selected === undefined) {
				return;
			}
			
			if (selected.folders.length > 0) {
				alert("<spring:message code = 'ezWebFolder.t20'/>");
				return;
			}
			
			if (selected.files.length > 1) {
				alert("<spring:message code = 'ezWebFolder.t115'/>");
				return;
			}
			
			var fileId = selected.files[0];
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/checkPermission.do",
				data: {
					"fileId" : fileId
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var result = data.resultValue;
					
					if (result != "ok") {
						alert("<spring:message code='ezWebFolder.t243'/>");
					} else {
						DivPopUpShow(450, 180, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
					}
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});
		}
		
		function fileMove() {
			var selected = getSelectedFoldersAndFiles();
			
			if (selected === undefined) {
				return;
			}
			
			if (selected.folders.length > 0) {
				alert("<spring:message code = 'ezWebFolder.t20'/>");
				return;
			}
			
			DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?fileList=" + selected.files.toString());
		}
		
		function getSelectedFoldersAndFiles() {
			var selectedRows = rowModule.getSelectedRows();
			var selectedLength = selectedRows.length;
			
			if (selectedLength <= 0) {
				alert("<spring:message code = 'ezWebFolder.t108'/>");
				return undefined;
			}
			
			var files  = [];
			var folders = [];
			var rowInfo;
			
			for (var i = 0; i < selectedLength; i++) {
				rowInfo = rowModule.getRowInfo(selectedRows[i]);
				
				if (rowInfo.type === 'D') {
					folders.push(rowInfo.id);
				} else {
					files.push(rowInfo.id);
				}
			}
			
			return {
				folders : folders,
				files : files
			}
		}
		
       function changeCount(value) {
    	   blockSize = value;
    	   currentPage = 1;
    	   pStart = 0;
    	   refreshView();
       }
       
       function changeValue(value) {
    	   searchFileType = value;
    	   if( value == "all" ) {
    		   searchFileType = ""
    	   };
    	   currentPage = 1;
    	   refreshView();
       }
       
    </script>
</head>
<body class="mainbody">
    <h1>
	   		웹폴더
	   		<span id="mailBoxInfo"></span>
	</h1>
	<div style="height:40px;">
		<span style="font-size: 24px;font-weight: bold;font-weight: bold; display: block; float: left;" id ="originalPath" ></span>
	</div>
	<div id="mainmenu2">
		<ul>
			<li id=""><a onClick="fileDownload()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t186'/></span></a></li>
			<li id="upload"><a onClick="fileUpload()"   style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t187'/></span></a></li>
			<li id=""><a onClick="fileDelete()"   style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t274'/></span></a></li>
			<li id=""><a onClick="fileRename()"   style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t273'/></span></a></li>
			<li id=""><a onClick="fileMove()"     style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t275'/></span></a></li>
			<li id=""><img src="/images/i_bar.gif"></li>
			<li id=""><a onClick="favoriteModule.onCheckAllClick()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t281'/></span></a></li>
<%-- 			<li id=""><a onClick=""     style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t272'/></span></a></li> --%>
			<li id=""><img src="/images/i_bar.gif"></li>
			<li id="SearchOption" mode="off" onClick="doLayerPopup(this)"><a style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t123'/></span></a></li>
			<li id=""><img src="/images/i_bar.gif"></li>
<!-- 			<li id=""><a onClick="folder_Manage()"style="margin-top: 3px;"><span>폴더관리</span></a></li> -->
			<li id=""><a onClick="refreshView()"style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t139'/></span></a></li>
			<li id="right" style="float:right;"><span><spring:message code='ezWebFolder.t215'/></span><img src ="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="webfolderlistoptiondiv"  onclick="optionView(this);"></li>
			<li id="right" style="float:right;">
				<select class="select" id="idSelect" onchange="idChange(this.value);" style="width:100px; display:none;">
					<option value="all" data-imagesrc="/images/webfolder/allTypes.png"  selected><spring:message code='ezWebFolder.t191'/></option><!-- 전체 -->
					<option value="document" data-imagesrc="/images/webfolder/msWord.png"       ><spring:message code='ezWebFolder.t192'/></option><!-- 문서 -->
					<option value="music" data-imagesrc="/images/webfolder/mp3.png"      ><spring:message code='ezWebFolder.t193'/></option><!-- 음악 -->
					<option value="video" data-imagesrc="/images/webfolder/mp4.png"      ><spring:message code='ezWebFolder.t194'/></option><!-- 영상 -->
					<option value="image" data-imagesrc="/images/webfolder/jpg.png"      ><spring:message code='ezWebFolder.t195'/></option><!-- 그림 -->
					<option value="folder" data-imagesrc="/images/webfolder/fldr.png"    ><spring:message code='ezWebFolder.t213'/></option><!-- 폴더 -->
					<option value="zip" data-imagesrc="/images/webfolder/zip.png"        ><spring:message code='ezWebFolder.t196'/></option><!-- 압축파일 -->
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
    <!-- 파일 리스트 10~ 50 선택 -->
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
                            <select id="listcount" style="width: 40px; height: 20px;" onchange="changeCount(this.value);">
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
	
	<div id="dragDropArea" style="margin: 10px 0px;overflow:auto;">
		<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileList">
			<tr>
				<th width="20px"><input type="checkbox" onchange="rowModule.selectAll(this.checked)" id="_checkAll"></th>
				<th width="40px"><img src='/images/ImgIcon/icon-flag.gif'/></th><!-- 즐겨찾기 -->
				<th width="40px"><spring:message code='ezWebFolder.t188'/></th><!-- 유형 -->
				<th width="240px"><spring:message code='ezWebFolder.t156'/></th><!-- 이름 -->
				<th width="60px"><spring:message code='ezWebFolder.t157'/></th><!-- 파일크기 -->
				<th width="80px"><spring:message code='ezWebFolder.t189'/></th><!-- 게시자 -->
				<th width="80px"><spring:message code='ezWebFolder.t190'/></th><!-- 등록일 -->
				<th width="80px"><spring:message code='ezWebFolder.t198'/></th><!-- 갱신일 -->
				<th width="210px"><spring:message code='ezWebFolder.t199'/></th><!-- 위치 -->
				<th width="40px"><spring:message code='ezWebFolder.t278'/></th><!-- 공유상태 -->
			</tr>
			
		</table>
	</div>
	<input id="file" type="file" onchange="onDrop()" onclick="this.value = null;" multiple="multiple" style="width: 1px; height: 1px; display:none" /> 
	<input type="hidden" onclick="fileupload()"/>
	<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
        <iframe src="" style="border:none;" id="iFrameLayer"></iframe>
    </div>
    
    <span id="mailBoxInfo"></span>
    <div id="layer_popup" style="width:700px;position:absolute;left:0px;top:0px;background-color:#ffffff;display:none;">
          <div class="popupwrap1">
            <div class="popupwrap2">
		        <table class="content">  
			        <tr>
			           <th style="text-align:center"><spring:message code='ezBoard.t210' /></th>
			           <td>
			               <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
<!-- 			               <img class="ui-datepicker-trigger" src="/images/ImgIcon/calendar-month.gif" alt title> -->
			                ~
			               <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
<!-- 			               <img class="ui-datepicker-trigger" src="/images/ImgIcon/calendar-month.gif" alt title>  -->
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
			    <br />
			    <table style="width:100%">
			        <tr>
			            <td style="text-align:center;">
			                <a class="imgbtn"><span onClick="btn_PostDate_Clear()"><spring:message code='ezWebFolder.t279' /></span></a><!-- 날짜초기화 -->
			                <a class="imgbtn"><span onClick="search('basic')"><spring:message code='ezWebFolder.t123' /></span></a><!-- 검색 -->
			                <a class="imgbtn"><span onClick="searchOptionHidden()"><spring:message code='ezWebFolder.t112' /></span></a><!-- 취소 -->
			            </td>
			        </tr>
			    </table>
	           </div>
	         </div>
	        
	        <div class="shadow">
	        </div>
		</div>
	<div id="tblPageRayer"></div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
	</div>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/bnk.js"                         ></script>
</body>
</html>