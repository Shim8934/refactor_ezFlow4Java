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
	<script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>
	
	<!-- time picker-->
	<link rel="stylesheet" type="text/css" href="/js/jquery/timeControls/jquery.timepicker.css" />
	<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/pageNav.js"></script>
	<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	<script type="text/javascript" src="/js/ezWebFolder/bnk.js" ></script>
    <script type="text/javascript">
   		var userInfo = {
   			lang:		"${userInfo.lang}"
    	};
    	
		var strErr		= "<spring:message code = 'ezWebFolder.t107'/>";
		var strLang39	= "<spring:message code = 'ezWebFolder.t135'/>";
		var strLang40 	= "<spring:message code = 'ezWebFolder.t136'/>";
		var strLang41   = "<spring:message code = 'ezWebFolder.t137'/>";
		var strLang42   = "<spring:message code = 'ezWebFolder.t138'/>";
		
		var currentPage = "1";
		var totalPages = 0 ;
		var totalRows = 0 ;
		var blockSize = ${listCount};
		var pStart = 0;
		var pEnd =10;
		var fileCnt = 0;
		var folderCnt = 0;
		var checkedArr	= [];
		var folderArr = [];
		var trashCanList = [];
		var searchFileType = "";
		
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
			document.getElementById("listcount").value = blockSize;
			renderFileList();
			window.onresize();
			$('#idSelect').ddslick({
				onSelected: function(selectedElmt){
					//callback function: do something with selectedData;
					document.getElementById("idSelect").value = selectedElmt.selectedData["value"];
					changeValue(document.getElementById("idSelect").value);
				}
			});
	    };
	    
	    function changeValue(value) {
	    	   searchFileType = value;
	    	   if( value == "all" ) {
	    		   searchFileType = "";
	    	   }
	    	   currentPage = 1;
	    	   refreshView();
	    }
	    
	    // 폴더관리
	    function openfolderManage() {
        	var popupWindow = window.open("/ezWebFolder/folderManage.do", "", GetOpenWindowfeature(500, 500));
            try { popupWindow.focus(); } catch (e) { }
        }
	    
	    function renderFileList() {
			$.ajax ({
				type: "POST",
				async: false,
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
					document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + " 파일 수 " + "<span style='color:#017BEC;'>" 
					+ fileCnt +"</span>"+", " +strLang41 + " 폴더 수 " + "<span style='color:#017BEC;'>" + folderCnt +" </span>" + strLang42 + "]";
				},
				error : function(error) {
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			})
			
		};
		
		function renderFileListElement(result) {
			document.getElementById("_checkAll").checked = false;
			var tableList = document.getElementById("tblFileList");
			
			while (tableList.rows.length > 1) {
				tableList.deleteRow(1);
			}
			
			if (result == null || result.length == 0) {
				var trElmt = document.createElement("tr");
				var tdElmt = document.createElement("td");
				
				tdElmt.setAttribute("colspan", "8");
				tdElmt.setAttribute("align", "center");
				tdElmt.setAttribute("bgcolor", "#FFFFFF");
				tdElmt.innerHTML = "<spring:message code='ezWebFolder.t144' />";
				tdElmt.setAttribute("id", "nodataRow");
				
				trElmt.appendChild(tdElmt);
				tableList.appendChild(trElmt);
			} else {
				var len = result.length;
				var resultElement;
				
				for (var i = 0; i < len; i++) {
					resultElement = result[i];
					
					var trElement  = document.createElement("tr");
					
					var tdCheckbox		= document.createElement("td");
					var tdFavoriteIcon	= document.createElement("td");
					var tdFileIcon		= document.createElement("td");
					var tdName			= document.createElement("td");
					var tdSize			= document.createElement("td");
					var tdCreator		= document.createElement("td");
					var tdCreateDate	= document.createElement("td");	
					var tdUpdateDate	= document.createElement("td");	
					var tdAbsolutePath	= document.createElement("td");	
					
					trElement.setAttribute("class", "bnkWebFolder");
					trElement.setAttribute("targetid", resultElement["trashCanId"]);
					trElement.setAttribute("targetPath", resultElement["trashCanPath"]);
					
					var inputElmt = document.createElement("input");
					inputElmt.setAttribute("type", "checkbox");
					inputElmt.setAttribute("value", resultElement["trashCanId"]);
					inputElmt.setAttribute("ext", resultElement["trashCanExt"]);
					inputElmt.setAttribute("class", "checkBnk");			
					inputElmt.addEventListener("change", function() {getChecked(this);});
					
					tdCheckbox.appendChild(inputElmt);
					
					var fileIconElmt = document.createElement("img");
					fileIconElmt = document.createElement("img");
					fileIconElmt.setAttribute("class", "webFolderImg");
					fileIconElmt.src = resultElement["trashCanIconUrl"];
					
					tdFileIcon.appendChild(fileIconElmt);
					
					tdName.textContent = resultElement["trashCanName"];
					tdSize.textContent = getFileSize(resultElement["trashCanSize"]);
					
					if (userInfo.lang == "1") {
						tdCreator.textContent = resultElement["createName1"];
					} else {
						tdCreator.textContent = resultElement["createName2"];
					}
					
					tdUpdateDate.textContent = resultElement["updateDate"].substring(0, 10);
					tdCreateDate.textContent = resultElement["createDate"].substring(0, 10);
					tdAbsolutePath.textContent = resultElement["trashCanPath"];
					
					if(result[i]["trashCanType"] == "folder") {
						trElement.ondblclick = function() {
							dbClickFunction(this);							
						};
					}
					
					trElement.appendChild(tdCheckbox);
					trElement.appendChild(tdFileIcon);
					trElement.appendChild(tdName);
					trElement.appendChild(tdSize);
					trElement.appendChild(tdCreator);
					trElement.appendChild(tdCreateDate);
					trElement.appendChild(tdUpdateDate);
					trElement.appendChild(tdAbsolutePath);
					
					tableList.appendChild(trElement);
				}
			} 
		}
		
		function dbClickFunction(obj) {
			var folderId2 = obj.getAttribute("_fileId");
			getFileList(folderId2);
			
		}
		
	   	$(function() {
	        $(".Sdatepicker").datepicker({
	            changeMonth: true,
	            changeYear: true,
	            autoSize: true,
	            showOn: "both",
	            buttonImage: "/images/ImgIcon/calendar-month.gif",
	            buttonImageOnly: true
	        });
	        
	        $(".Edatepicker").datepicker({
	            changeMonth: true,
	            changeYear: true,
	            autoSize: true,
	            showOn: "both",
	            buttonImage: "/images/ImgIcon/calendar-month.gif",
	            buttonImageOnly: true
	        });
	
	        $(".Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $(".Sdatepicker").datepicker('setDate', "");
	
	        $(".Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $(".Edatepicker").datepicker('setDate', "");
	     });
	   	
	   	// 날짜 초기화 버튼
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
	    
	   	// TODO : 여기서부터 코드 정리하면서 내려가서 list 뿌리기 
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
	    	} else {
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
    	   } else {	    		   
    		   var pos = null;
    		   checkedArr.map(function(obj, index) { if(obj["userId"] == newUser["userId"]) { pos = index; return true; }}).filter(isFinite);

    		   if (pos != -1) {
    			   obj.parentElement.parentElement.setAttribute("style", "");
    			   checkedArr.splice(pos, 1);
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
    	   if (checkedArr.length <= 0 && folderArr.length <= 0) {
    		   alert("<spring:message code = 'ezWebFolder.t108'/>");
    		   return;
    	   }
    	   
	       var checkedFileList = checkedArr[0];
	       var checkedFolderList = folderArr[0];
	       
    	   for (var i = 1; i < checkedArr.length; i++) {
    		   checkedFileList = checkedFileList + "," + checkedArr[i];	    			
    	   }
    	   
    	   for (var i = 1; i < folderArr.length; i++) {
    		   checkedFolderList = checkedFolderList + "," + folderArr[i];
    	   }
    	   
    	   showPanel(450, 150, "/ezWebFolder/permanentDeleteConfirm.do?fileList=" + checkedFileList + "&folderList=" + checkedFolderList);
       }
       
       function getChecked(obj) {
    	   var id = obj.getAttribute("value");
    	   if (obj.checked == true) {
    		   if (obj.getAttribute("ext") == "folder"){
    			   folderArr.push(id);
    		   } else {
	    		   checkedArr.push(id);
    		   }
    	   }
       }
       
       function getCheckAll(obj) {
    	   var listInputs = document.getElementsByClassName("checkBnk");
    	   
    	   checkedArr = [];
    	   folderArr = [];
    	   if (obj.checked == true) {
    		   for (var i = 0; i < listInputs.length; i++) {
	    			listInputs[i].checked = true;
	    			if (listInputs[i].getAttribute("ext") == 'folder') {
	    				folderArr.push(listInputs[i].value);
	    			} else {
		    			checkedArr.push(listInputs[i].value);	    		
	    			}
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
    	   if (checkedArr.length <= 0 && folderArr.length <= 0) {
    		   alert("<spring:message code = 'ezWebFolder.t108'/>");
    		   return;
    	   }
    	   
	       var checkedFileList = checkedArr[0];
	       var checkedFolderList = folderArr[0];
	       
    	   for (var i = 1; i < checkedArr.length; i++) {
    		   checkedFileList = checkedFileList + "," + checkedArr[i];	    			
    	   }
    	   
    	   for (var i = 1; i < folderArr.length; i++) {
    		   checkedFolderList = checkedFolderList + "," + folderArr[i];
    	   }
    	   
    		$.ajax ({
				type: "POST",
				async: false,
				url : "/ezWebFolder/restoreTrashCan.do",
				dataType: "json",
				data : {
					"fileList" : checkedFileList,
					"folderList" :checkedFolderList
				},
				success : function (data) {
					alert('복원이 완료 되었습니다.');
					refreshView();
				},
				error : function(error) {
					alert("복원을 실패하였습니다. 선택한 파일 및 폴더의 상위 폴더가 존재하지 않습니다.");
				}
			})
       }
       
       function moveTraschCan() {
    	   if (checkedArr.length <= 0 && folderArr.length <= 0) {
    		   alert("<spring:message code = 'ezWebFolder.t108'/>");
    		   return;
    	   }
    	   
	       var checkedFileList = checkedArr[0];
	       var checkedFolderList = folderArr[0];
	       
    	   for (var i = 1; i < checkedArr.length; i++) {
    		   checkedFileList = checkedFileList + "," + checkedArr[i];	    			
    	   }
    	   
    	   for (var i = 1; i < folderArr.length; i++) {
    		   checkedFolderList = checkedFolderList + "," + folderArr[i];
    	   }
    	   
    	   var OpenWin = window.open("/ezWebFolder/folderManage.do?folderType="+folderType, "", GetOpenWindowfeature(600, 550));
           try { OpenWin.focus(); } catch (e) { }
           
    		$.ajax ({
				type: "POST",
				async: false,
				url : "/ezWebFolder/moveTrashCan.do",
				dataType: "json",
				data : {
					"fileList" : checkedFileList,
					"folderList" :checkedFolderList
				},
				success : function (data) {
					alert('이동을 완료하였습니다..');
					refreshView();
				},
				error : function(error) {
					alert("이동을 실패하였습니다." + error);
				}
			})
    	   
       }
    </script>
</head>
<body class="mainbody">
    <h1>휴지통   <span id="mailBoxInfo"></span></h1>
	<div id="mainmenu2">
		<ul>
			<li id=""><a onClick="restoreTrashCan()" style="margin-top: 3px;"><span>복원</span></a></li>
			<li id=""><a onClick="moveTraschCan()" style="margin-top: 3px;"><span>이동</span></a></li>
			<li id=""><a onClick="filePermanentDelete()"   style="margin-top: 3px;"><span>영구삭제</span></a></li>
			<li id="SearchOption" mode="off" onClick="doLayerPopup(this)"><a style="margin-top: 3px;"><span>검색</span></a></li>
			<li id="right" style="float:right;">보기설정&nbsp;<img src ="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="webfolderlistoptiondiv"  onclick="optionView(this);"></li>
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
				<th width="40px" ><spring:message code='ezWebFolder.t188'/></th>
				<th width="160px"><spring:message code='ezWebFolder.t156'/></th>
				<th width="60px" ><spring:message code='ezWebFolder.t157'/></th>
				<th width="120px"><spring:message code='ezWebFolder.t189'/></th>
				<th width="80px" >삭제일</th>
				<th width="80px" ><spring:message code='ezWebFolder.t190'/></th>
				<th width="160px"><spring:message code='ezWebFolder.t199'/></th>
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
    
    <div id="layer_popup" style="width:700px;position:absolute;left:0px;top:0px;background-color:#ffffff;display:none;">
          <div class="popupwrap1">
            <div class="popupwrap2">
		        <table class="content">  
			        <tr>
			           <th style="text-align:center"><spring:message code='ezWebFolder.t190' /></th>
			           <td>
			               <input type="text" class="Sdatepicker" id="enrollStartDate" style="width:80px;text-align:center" readonly="readonly">
			                ~
			               <input type="text" class="Edatepicker" id="enrollEndDate" style="width:80px;text-align:center" readonly="readonly">
			           </td>
			       </tr>
			        <tr>
			           <th style="text-align:center">삭제일</th>
			           <td>
			               <input type="text" class="Sdatepicker" id="delStartDate" style="width:80px;text-align:center" readonly="readonly">
			                ~
			               <input type="text" class="Edatepicker" id="delEndDate" style="width:80px;text-align:center" readonly="readonly">
			           </td>
			       </tr>
			       
			        <tr>
			            <th style="text-align:center">확장자</th>
			            <td><input type="text" id="searchExt" style="width:100%" value=""></td>
			        </tr>
			        <tr>
			            <th style="text-align:center">파일명</th>
			            <td><input type="text" id="searchFileName" style="width:100%" value=""></td>
			        </tr>  
			         <tr>
			            <th style="text-align:center">작성자</th>
			            <td><input type="text" id="searchCreateName" style="width:100%" value=""></td>
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