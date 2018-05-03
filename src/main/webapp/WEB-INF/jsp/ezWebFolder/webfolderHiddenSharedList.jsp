<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>"   type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezWebFolder.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/fileFolderDrop.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/pageNav.js"></script>
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
		<link rel="stylesheet" href="/js/jquery/jquery.modal.css" type="text/css" />
		<!-- module -->
		<script type="text/javascript" src="/js/ezWebFolder/context/row-selector.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/context/share.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/context/favorite.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/context/search.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/selectUsers.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/popup.js"></script>
		<script type="text/javascript">
			var file 		 = new Array();
			var primary      = "<c:out value='${primary}'/>";
			var strShared1	= messages.strLang2;
			var strShared2	= messages.strLang3;
			var strErr		= messages.strLang4;
			var appType     = "user";
			var userName = "${userInfo.userName}";
			var currentPage = 1;
			var totalPages = 0 ;
			var totalRows = 0 ;
			var blockSize = 0;
			var filelist = [];
			var strSuccess  = "<spring:message code = 'ezWebFolder.t27'/>";
			var pStart = 0;
			var pEnd = 10;
			var folderId = "${folderId}";
			var folderType = "${folderType}";
			var fileCnt ;
			var fldCnt;
			var originalPath = "";
			
			// fileList 브라우저 화면 크기 변했을때 유동적화면 변화
			window.onresize = function () {
				var divList          = document.getElementById("dragDropArea");
				var reheight         = document.documentElement.clientHeight - 220;
				divList.style.height = reheight + "px";
			};
			
			document.onselectstart = function() {
				return false;
			}
			
			$(function () {
				$('#upload').css('display','none');
				pEnd= pStart + blockSize;
				getFileList(folderId);
				
				searchContext.setSearchStartEventHandler(function() {
					getFileList(folderId);
				});
				
				searchContext.setFileTypeChangeEventHandler(function() {
					getFileList(folderId);
				})
				
				window.onresize();
		     });
			
			function getFileList(pPage) {
				searchRequirement = searchContext.getCurrentRequirement();
				
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/getHiddenSharedList.do",
					data: {
						"pageNum" : pPage,
					},
					dataType: "JSON",
					async: true,
					success : function(result) {
						if (result.status == "ok") {
							var data = result.data;
							currentPage = pPage;
							totalPages  = data.totalPage;
							fileRows    = data.fileCount;
							folderRows  = data.folderCount;
							totalRows   = data.totalCount;
							
							makePageSelPage();
							renderData(data.list);
							checkedArr = [];
							
							document.getElementById("mailBoxInfo").innerHTML = " - [<spring:message code='ezWebFolder.t276'/> <span style='color:#017BEC;'>" 
								+ folderRows + "</span> " + messages.strLang11 + " / " + "<spring:message code='ezWebFolder.t277'/>" + " <span style='color:#017BEC;'>" + fileRows +" </span>" + messages.strLang11 + "]";
						} else {
							alert("<spring:message code='ezWebFolder.t134'/>" + " - errorCode : " + result.code);
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
			
			function renderData(result) {
				var tableList = document.getElementById("tblFileList");
				document.getElementById("_checkAll").checked = false;
				
				while (tableList.rows.length > 1) {
					tableList.deleteRow(1);
				}
				
				if (result == null || result.length == 0) {
					var trElmt = document.createElement("tr");
					var tdElmt = document.createElement("td");
					tdElmt.setAttribute("colspan", "10");
					tdElmt.setAttribute("align", "center");
					tdElmt.setAttribute("bgcolor", "#FFFFFF");
					tdElmt.innerHTML = messages.strLang12;
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
						
						setTextOverflowEllipsis(tdElmt4, tdElmt5, tdElmt6, tdElmt7, tdElmt8, tdElmt9, tdElmt10);
						setTextAlignCenter(tdElmt2, tdElmt3, tdElmt5, tdElmt10);
						
						trElmt.setAttribute("class", "bnkWebFolder");
						trElmt.setAttribute("targetId", result[i]["fileId"]);
						trElmt.setAttribute("targetType", result[i]["folderFileType"] == 'D' ? 'D' : 'F');
						trElmt.addEventListener("click", function(event) { rowContext.onRowClick(this); });
						
						if (result[i]["folderFileType"] != 'D') {
							trElmt.addEventListener("dblclick", function(event) {downloadFileByDbClick(event);});
						}
						
						var inputElmt = document.createElement("input");
						inputElmt.setAttribute("type", "checkbox");
						inputElmt.setAttribute("value", result[i]["fileId"]);
						inputElmt.setAttribute("class", "checkBnk");
						inputElmt.addEventListener("change", function(event) { event.stopPropagation(); rowContext.onCheckboxChange(this); });
						inputElmt.addEventListener("click", function(event) { event.stopPropagation(); });
						inputElmt.addEventListener("dblclick", function(event) { event.stopPropagation(); });
						
						tdElmt1.appendChild(inputElmt);
						
						var faImgElmt = document.createElement("img");
						faImgElmt.setAttribute("class", "none-drag");
						faImgElmt.addEventListener("click", function() { favoriteContext.onImageClick(this); });
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
						
						tdElmt5.setAttribute("style", "text-align:center;");
						if (result[i]["folderFileType"] == 'F') {
							tdElmt5.textContent = getFileSize(result[i]["fileSize"]);
						} else {
							tdElmt5.textContent = "-";
						}
						
						tdElmt6.textContent = result[i]["createName"];
						tdElmt7.textContent = result[i]["createDate"].substring(0, 10);
						tdElmt8.textContent = result[i]["updateDate"].substring(0, 10);
						
						if (result[i]["folderFileType"] == 'F') {
							tdElmt9.textContent = result[i]["folderPath"];
						} else {
							tdElmt9.textContent = result[i]["folderPath"].slice(0, -(result[i]["fileName"].length + 1));
						}
						
						tdElmt10.textContent = result[i]["sharerName"];
						
// 						if(result[i]["typeId"] == "folder") {
// 							trElmt.ondblclick = function() {
// 								getFileList(this.getAttribute("targetId"));
// 							};
// 						}
						
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
			
			function setTextOverflowEllipsis() {
				var element;
				argumentsLength = arguments.length;
				
				for (var i = 0; i < argumentsLength; i++) {
					element = arguments[i];
					element.style.overflow = "hidden";
					element.style.textOverflow = "ellipsis";
					element.style.whiteSpace = "nowrap";
				}
			}
			
			function setTextAlignCenter() {
				var element;
				argumentsLength = arguments.length;
				
				for (var i = 0; i < argumentsLength; i++) {
					element = arguments[i];
					element.style.textAlign = "center";
				}
			}
			
			function goToPageByNum(Value) {
		    	currentPage = Value;
		        pStart = (blockSize * (currentPage)) - blockSize;
		        pEnd = blockSize;
		        getFileList(folderId);
		    }
			
			function doLayerPopup(obj) {
		        var searchRequirement = searchContext.getCurrentRequirement();
		        clearDatepicker();
		        
		        $('#searchExt').val(searchRequirement.extension);               
	            $('#searchFileName').val(searchRequirement.name);
	            $('#searchCreateName').val(searchRequirement.creatorName);
	            $('#Sdatepicker').val(searchRequirement.startDate);
	            $('#Edatepicker').val(searchRequirement.endDate);
		    
		        /* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
		        var leftBody = parent.frames["left"].document.body;
		        leftBody.style.overflow = "hidden";
	        	$("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"].searchOptionHidden();document.body.style.overflow=\"auto\";'></div>").appendTo(leftBody);        	
	        	var popupX = parent.document.body.clientWidth / 2 - (500 / 2) - 220;
	        	
	        	$("#srarchpopup").css("left", popupX);
	        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        	
	        	$("#srarchpopup").modal();
		    }
			
			
			function optionView(obj){
		   		 if (obj.getAttribute("mode") == "off") {
		   	        document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 260 + "px";
//		    	        if(pAdminType == "y")
		   	            document.getElementById("layer_Viewpopup").style.top = "130px";
//		    	        else
//		    	            document.getElementById("layer_Viewpopup").style.top = "100px";
		   	        document.getElementById("layer_Viewpopup").style.display = "";
		   	        obj.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
		   	        obj.setAttribute("mode", "on");
		   	    } else {
		   	        optionHidden();
		   	    }
		   	}
	       
			function refreshView() {
				getFileList(folderId);
			}
			
			function getSelectedFoldersAndFiles() {
				var selectedRows = rowContext.getSelectedRows();
				var selectedLength = selectedRows.length;
				
				if (selectedLength <= 0) {
					alert(messages.strLang5);
					return undefined;
				}
				
				var files  = [];
				var folders = [];
				var rowInfo;
				
				for (var i = 0; i < selectedLength; i++) {
					rowInfo = rowContext.getRowInfo(selectedRows[i]);
					
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
	       
			function showSharedList() {
				location.href = "/ezWebFolder/webfolderSharedList.do";
			}
		</script>
	</head>
	<body class="mainbody">
		<h1>
			공유폴더
			<span id="mailBoxInfo"></span>
		</h1>
		
		<div style="height:40px;">
			<span style="font-size: 24px;font-weight: bold;font-weight: bold; display: block; float: left;" id ="originalPath" ></span>
		</div>
		
		<div id="mainmenu">
			<ul>
				<li id=""><a onClick="showSharedList()" style="margin-top: 3px;"><span>돌아가기</span></a></li>
				<li id=""><a onClick="shareContext.showShare()" style="margin-top: 3px;"><span>숨김취소</span></a></li>
				<li id="right" style="float:right;">
					<label for="webfolderlistoptiondiv"><spring:message code='ezWebFolder.t215'/></label>
					<img src ="/images/kr/cm/btn_arrow_down.gif" mode="off" id="webfolderlistoptiondiv" onclick="optionView(this);">
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
		
		<div id="dragDropArea" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)" style="margin: 10px 0px;">
			<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileList">
				<tr>
					<th width="20px"><input type="checkbox" onchange="rowContext.selectAll(this.checked)" id="_checkAll"></th>
					<th style="width: 18px; text-align: center;"><img class="none-drag" src='/images/ImgIcon/icon-flag.gif'/></th><!-- 즐겨찾기 -->
					<th style="width: 30px; text-align: center;"><spring:message code='ezWebFolder.t188'/></th><!-- 유형 -->
					<th style="width: 29%;"><spring:message code='ezWebFolder.t156'/></th><!-- 이름 -->
					<th style="width: 6%; text-align: center;"><spring:message code='ezWebFolder.t157'/></th><!-- 파일크기 -->
					<th style="width: 7%;"><spring:message code='ezWebFolder.t189'/></th><!-- 게시자 -->
					<th style="width: 9%;"><spring:message code='ezWebFolder.t190'/></th><!-- 등록일 -->
					<th style="width: 9%;"><spring:message code='ezWebFolder.t198'/></th><!-- 갱신일 -->
					<th style="width: 25%;"><spring:message code='ezWebFolder.t199'/></th><!-- 위치 -->
					<th style="width: 6%; text-align: center;">공유한 사람</th><!-- 공유한 사람 -->
				</tr>
			</table>
		</div>
		
		<input id="file" type="file" onchange="onDrop()" multiple="multiple" style="width:1px; height:1px; display:none;"/>
		<input type="hidden" onclick="fileupload()"/>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
		<div class="layerpopup" style="z-index:2000; position:absolute; display:none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4'/>" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		<div id="tblPageRayer"></div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery.modal.js"></script>
	</body>
</html>