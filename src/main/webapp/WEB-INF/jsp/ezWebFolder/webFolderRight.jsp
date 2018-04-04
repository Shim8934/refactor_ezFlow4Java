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
<!-- 	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script> -->
	<link rel="stylesheet" href="/css/Tab.css" type="text/css">
	<!-- date Picker -->
	
	<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
	<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
	<script type="text/javascript" src="/js/ezOrgan/ListView_list.js"                   ></script>
	
	<!-- time picker-->
	<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
	<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/pageNav.js"></script>
	<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
    <script type="text/javascript">
    	var xhr  		= new XMLHttpRequest();
    	var file 		= new Array();
		var currFolderId = ""; //Just for test
		var primary      = "<c:out value='${primary}'/>";
		var strShared1	= "<spring:message code = 'ezWebFolder.t105'/>";
		var strShared2	= "<spring:message code = 'ezWebFolder.t106'/>";
		var strErr		= "<spring:message code = 'ezWebFolder.t107'/>";
		var checkedArr	= [];
		var userId = "${userInfo.userId}";
		var userName = "${userInfo.userName}";
		var currentPage = "1";
		var totalPages = 0 ;
		var totalRows = 0 ;
		var blockSize = 10;
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
			pEnd= pStart + blockSize;
			getFileList(folderId);
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
	    		alert(folderId+"가 없음");
	    		return;
	    	}
	    	folderId = a;
			$.ajax ({
				type:"POST",
				async: false,
				url : "/ezWebFolder/fileList.do",
				data : { 
					 "folderId"   : folderId,
					 "folderType" : folderType,
					 "currPage"   : currentPage,
// 					 "totalPages" : totalPages,
					 "listCount"  : blockSize,
// 					 "totalCount" : totalRows,
					 "pStart" : pStart,
					 "pEnd" : pEnd,
					 "searchExt" : $('#searchExt').val(),
					 "searchFileName" : $('#searchFileName').val(),
					 "searchCreateName" : $('#searchCreateName').val()
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
// 					$("#originalPath").text(originalPath); 
					$('#tblFileList tr td').parent().remove();
					renderData(filelist);
					makePageSelPage();
					namePath(folderPath,originalPath);
					document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + " 파일 수 " + "<span style='color:#017BEC;'>" 
						+ fileCnt +"</span>"+", " +strLang41 + " 폴더 수 " + "<span style='color:#017BEC;'>" + fldCnt +" </span>" + strLang42 + "]";
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
				detailName.onclick = function() {getFileList(this.id)};
				detailName.textContent = path[i];
				detailName.setAttribute("style", "font-size:22px; ");
				
				nameTag.appendChild(detailName);
				var imgElmt = document.createElement("img");
				imgElmt.setAttribute("style", "height: 18px; width: 18px; display: inline-block;");
				imgElmt.src = "/images/webfolder/arrow.png";
				
				if (i != path.length - 2) {
					nameTag.appendChild(imgElmt);
				}	
			}
			
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
				tdElmt.setAttribute("colspan", "9");
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
					var tdElmt10 = document.createElement("td");
					var tdElmt11 = document.createElement("td");
					
					trElmt.setAttribute("class", "bnkWebFolder");
					trElmt.setAttribute("_fileId", result[i]["fileId"]);
					trElmt.setAttribute("_filePath", result[i]["filePath"]);
					
					var inputElmt = document.createElement("input");
					inputElmt.setAttribute("type", "checkbox");
					inputElmt.setAttribute("value", result[i]["fileId"]);
					inputElmt.setAttribute("class", "checkBnk");			
					inputElmt.onchange = function(e){getChecked(this);};
					tdElmt1.appendChild(inputElmt);
					
					var fileIconElmt = document.createElement("img");
					fileIconElmt.setAttribute("class", "webFolderImg");
					if (result[i]["favouriteStatus"] == "0") {
						fileIconElmt.src = "/images/webfolder/favourite.png";
						tdElmt2.appendChild(fileIconElmt);
					}
					else {
						fileIconElmt.src = "/images/webfolder/favourite2.png";
						tdElmt2.appendChild(fileIconElmt);
					}
					
					
					var fileIconElmt = document.createElement("img");
					fileIconElmt.setAttribute("class", "webFolderImg");
					fileIconElmt.src = result[i]["fileIconUrl"];
					tdElmt3.appendChild(fileIconElmt);
					
					tdElmt4.textContent = result[i]["fileName"];
					tdElmt5.textContent = getFileSize(result[i]["fileSize"]);
					
					if (primary == "1") {
						tdElmt6.textContent = result[i]["createName1"];
					}
					else {
						tdElmt6.textContent = result[i]["createName2"];
					}
					
					tdElmt7.textContent = result[i]["createDate"].substring(0, 10);
					tdElmt8.textContent = result[i]["updateDate"].substring(0, 10);
					tdElmt9.textContent = result[i]["filePosition"];
					tdElmt10.textContent = result[i]["downloadCnt"];
					tdElmt10.setAttribute("style","text-align: center;");
					
					if (result[i]["fileShareStatus"] == "1") {
						tdElmt11.textContent = "공유중";
					}
					else {
						tdElmt11.textContent = "";
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
					trElmt.appendChild(tdElmt11);
					tableList.appendChild(trElmt);
					
				}
			} 
		}
		
		function dbClickFunction(obj) {
			var folderId2 = obj.getAttribute("_fileId");
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
	        pStart = (blockSize * (currentPage))- blockSize;
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
	        }
	        else if (type == "quick") {
	            if (document.getElementById("txt_keyword").value == "") {
	                alert("<spring:message code='ezBoard.t192' />");
	                return;
	            }
	        }
	        searchOptionHidden();
// 	        MakeSubCondition();
	        getFileList(folderId);
	    }
   		function clickRow(obj, e) {
	        e.stopPropagation();
	        e.preventDefault();
	    	
	    	var inputElmt = obj.firstElementChild.firstElementChild;
	    	var newUser = {};
		    newUser["userId"]      = obj.getAttribute("userId");
		    newUser["usedAmount"]  = obj.getAttribute("usedAmount");
	    	
	    	if (inputElmt.checked == true) {
	    		inputElmt.checked = false;
	    		
	    		var pos = null;
    		    checkedArr.map(function(obj, index) { if(obj["userId"] == newUser["userId"]) { pos = index; return true; }}).filter(isFinite);

    		    if (pos != -1) {
    			   obj.setAttribute("style", "");
    			   checkedArr.splice(pos, 1);
    		    }		    		
	    	}
	    	else {
	    		inputElmt.checked = true;
	    		checkedArr.push(newUser);
	    		obj.setAttribute("style", "background-color: #e9f1ff;");
	    	}
	    }
	    
	    function getChecked(obj, event) {		       
	       event.stopPropagation();
	       
	       var newUser = {};
	       newUser["userId"]      = obj.getAttribute("userId");
	       newUser["usedAmount"]  = obj.getAttribute("usedAmount");		       
	        	   
    	   if (obj.checked == true) {
    		   checkedArr.push(newUser);
    		   obj.parentElement.parentElement.setAttribute("style", "background-color: #e9f1ff;");
    	   }
    	   else {	    		   
    		   var pos = null;
    		   checkedArr.map(function(obj, index) { if(obj["userId"] == newUser["userId"]) { pos = index; return true; }}).filter(isFinite);

    		   if (pos != -1) {
    			   obj.parentElement.parentElement.setAttribute("style", "");
    			   checkedArr.splice(pos, 1);
    		   }
    	   }
       }
	    
	   function getCheckAll(obj) {
    	   var listInputs = document.getElementsByClassName("checkBnk");
    	   
    	   checkedArr = [];
    	   if (obj.checked == true) {
    		   for (var i = 0; i < listInputs.length; i++) {
	    			listInputs[i].checked = true;
	    			var newUser = {};
		 		    newUser["userId"]      = listInputs[i].getAttribute("userId");
		 		    newUser["usedAmount"]  = listInputs[i].getAttribute("usedAmount");			 		    		
		 		    listInputs[i].parentElement.parentElement.setAttribute("style", "background-color: #e9f1ff;");
	    			checkedArr.push(newUser);	    		
	    		}		    	
    	   }
    	   else {
    		   for (var i = 0; i < listInputs.length; i++) {
    			    listInputs[i].parentElement.parentElement.setAttribute("style", "");
	    			listInputs[i].checked = false;	    				    		
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
	        }
	        else {
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
//    	        if(pAdminType == "y")
   	            document.getElementById("layer_Viewpopup").style.top = "130px";
//    	        else
//    	            document.getElementById("layer_Viewpopup").style.top = "100px";
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
    	   if (checkedArr.length <= 0) {
    		   alert("<spring:message code = 'ezWebFolder.t108'/>");
    		   return;
    	   }
    	   
	    	var checkedList = checkedArr[0];
	    	
    		for (var i = 1; i < checkedArr.length; i++) {
    			checkedList = checkedList + "," + checkedArr[i];	    			
    		}
    		
    		var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + checkedList;
        	        	
            AttachDownFrame.location.href = downloadUrl;
    	   
       }
       
       function fileUpload() {
    	   document.getElementById("file").click();
    	   refreshView();
       }
       
       function refreshView() {
    	   console.log("Run here!");
    	   getFileList(folderId);
       }
       
       function fileDelete() {
    	   if (checkedArr.length <= 0) {
    		   alert("<spring:message code = 'ezWebFolder.t108'/>");
    		   return;
    	   }
    	   
	       var checkedList = checkedArr[0];
	    	
    	   for (var i = 1; i < checkedArr.length; i++) {
    	   	   checkedList = checkedList + "," + checkedArr[i];	    			
    	   }
    	   
    	   $.ajax({
				type: "POST",
				url: "/ezWebFolder/checkPermission.do",
				data: {
					"fileList" : checkedList
				},
				dataType: "JSON",
				async: true,
				success : function(data) {
					var result = data.resultValue;
					
					if (result != "ok") {
						alert("<spring:message code='ezWebFolder.t243'/>");
					}
					else {
						DivPopUpShow(450, 150, "/ezWebFolder/deleteConfirm.do?fileList=" + checkedList);
					}
					refreshView();
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});
    	   
    	   //DivPopUpShow(450, 150, "/ezWebFolder/deleteConfirm.do?fileList=" + checkedList);
       }
       
       function fileRename() {
    	   if (checkedArr.length <= 0) {
    		   alert("<spring:message code = 'ezWebFolder.t108'/>");
    		   return;
    	   }
    	   
    	   if (checkedArr.length > 1) {
    		   alert("<spring:message code = 'ezWebFolder.t115'/>");
    		   return;
    	   }
    	   
	       var fileId = checkedArr[0];
    	   
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
					}
					else {
						DivPopUpShow(450, 180, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
					}
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			});
	       
    	   //DivPopUpShow(450, 180, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
       }
       
       function fileMove() {
    	   if (checkedArr.length <= 0) {
    		   alert("<spring:message code = 'ezWebFolder.t108'/>");
    		   return;
    	   }
    	   
			var checkedList = checkedArr[0];
			
			for (var i = 1; i < checkedArr.length; i++) {
				checkedList = checkedList + "," + checkedArr[i];
			}
			
			DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?fileList=" + checkedList);
       }
       
       function getChecked(obj) {
    	   var id = obj.getAttribute("value");
    	   if (obj.checked == true) {
    		   checkedArr.push(id);
    	   }
    	   else {
    		   var pos = checkedArr.indexOf(id);
	    		
    		   if (pos != -1) {
    			   checkedArr.splice(pos, 1);
    		   }
    	   }
       }
       
       function getCheckAll(obj) {
    	   var listInputs = document.getElementsByClassName("checkBnk");
    	   
    	   checkedArr = [];
    	   if (obj.checked == true) {
    		   for (var i = 0; i < listInputs.length; i++) {
	    			listInputs[i].checked = true;
	    			checkedArr.push(listInputs[i].value);	    		
	    		}		    	
    	   }
    	   else {
    		   for (var i = 0; i < listInputs.length; i++) {
	    			listInputs[i].checked = false;	    				    		
	    		}
    	   }
       }
       function changeCount(value) {
    	   blockSize = value;
    	   currentPage = 1;
    	   getFileList(folderId);
       }
       
    </script>
</head>
<body class="mainbody">
    <h1>
	   		웹폴더
	   		<span id="mailBoxInfo"></span>
	</h1>
	<div style="height:40px;">
		<span style="font-size: 24px;font-weight: bold;font-weight: bold; display: block; float: left;" id ="originalPath"></span>
	</div>
	<div id="mainmenu">
		<ul>
			<li id=""><a onClick="fileDownload()" style="margin-top: 3px;"><span>파일다운로드</span></a></li>
			<li id=""><a onClick="fileUpload()"   style="margin-top: 3px;"><span>파일업로드</span></a></li>
			<li id=""><a onClick="fileDelete()"   style="margin-top: 3px;"><span>파일삭제</span></a></li>
			<li id=""><a onClick="fileRename()"   style="margin-top: 3px;"><span>파일명변경</span></a></li>
			<li id=""><a onClick="fileMove()"     style="margin-top: 3px;"><span>파일이동/복사</span></a></li>
			<li id=""><img src="/images/i_bar.gif"></li>
			<li id=""><a onClick=""     style="margin-top: 3px;"><span>즐겨찾기 추가</span></a></li>
			<li id=""><a onClick=""     style="margin-top: 3px;"><span>즐겨찾기 해제</span></a></li>
			<li id=""><img src="/images/i_bar.gif"></li>
			<li id="SearchOption" mode="off" onClick="doLayerPopup(this)"><a style="margin-top: 3px;"><span>검색</span></a></li>
			<li id=""><img src="/images/i_bar.gif"></li>
			<li id=""><a onClick="folder_Manage()"style="margin-top: 3px;"><span>폴더관리</span></a></li>
			<li id=""><a onClick="refreshView()"style="margin-top: 3px;"><span>새로고침</span></a></li>
			<li id="right" style="float:right;">보기설정&nbsp;<img src ="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="webfolderlistoptiondiv"  onclick="optionView(this);"></li>
			<li id="right" style="float:right;">
				<select class ="select" id ="idSelect" onchange="IDChange()" style="background-image:url(/images/webfolder/pdf.png);
				 background-position: right;margin-right:30px; width:100px;background-repeat: no-repeat;">
					<option selected>전체</option>
					<option style="background-image:url(/images/webfolder/pdf.png);
				 background-position: right;margin-right:30px; width:100px;background-repeat: no-repeat;">문서</option>
					<option>음악</option>
					<option>영상</option>
					<option>그림</option>
					<option>폴더</option>
					<option>압축파일</option>
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
                            <select id="listcount" style="WIDTH: 40px; height: 20px;" onchange="changeCount(this.value);">
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
				<th width="20px" ><input type="checkbox" onchange="getCheckAll(this);" id="_checkAll"></th>
				<th width="40px" >즐겨찾기</th>
				<th width="40px" ><spring:message code='ezWebFolder.t188'/></th>
				<th width="160px"><spring:message code='ezWebFolder.t156'/></th>
				<th width="60px" ><spring:message code='ezWebFolder.t157'/></th>
				<th width="120px"><spring:message code='ezWebFolder.t189'/></th>
				<th width="80px" ><spring:message code='ezWebFolder.t190'/></th>
				<th width="80px" ><spring:message code='ezWebFolder.t198'/></th>
				<th width="160px"><spring:message code='ezWebFolder.t199'/></th>
				<th width="60px" ><spring:message code='ezWebFolder.t200'/></th>
				<th width="40px" >공유상태</th>
			</tr>
			
		</table>
	</div>
	<input id="file" type="file" onchange="onDrop()" multiple="multiple" style="width: 1px; height: 1px; display:none" /> 
	<input type="hidden" onclick="fileupload()"/>
	<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
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
			            <th style="text-align:center">확장자</th>
			            <td><input type="text" id="searchExt" style="width:98%" value="" name="searchExt"></td>
			        </tr>
			        <tr>
			            <th style="text-align:center">파일명</th>
			            <td><input type="text" id="searchFileName" style="width:98%" value="" name="searchFileName"></td>
			        </tr>  
			         <tr>
			            <th style="text-align:center">작성자</th>
			            <td><input type="text" id="searchCreateName" style="width:98%" value="" name="searchCreateName"></td>
			        </tr>    
			       
		   		 </table>
			    <br />
			    <table style="width:100%">
			        <tr>
			            <td style="text-align:center;">
			                <a class="imgbtn"><span onClick="btn_PostDate_Clear()"><spring:message code='ezBoard.t220' /></span></a><!-- 날짜초기화 -->
			                <a class="imgbtn"><span onClick="search('basic')"><spring:message code='ezBoard.t188' /></span></a><!-- 검색 -->
			                <a class="imgbtn"><span onClick="searchOptionHidden()"><spring:message code='ezBoard.t15' /></span></a><!-- 취소 -->
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
		<iframe src="<spring:message code='main.kms4'/>" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>