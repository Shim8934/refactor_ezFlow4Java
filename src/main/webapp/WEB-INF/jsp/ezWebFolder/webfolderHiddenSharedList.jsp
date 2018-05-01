<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" href="/css/organ_tree.css"                       type="text/css" />
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>"   type="text/css" />
		<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css"            type="text/css" />
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css" />
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css"         type="text/css" />
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"                ></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"                          ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"                             ></script>
		<script type="text/javascript" src="/js/ezOrgan/TreeView.js"                        ></script>
		<script type="text/javascript" src="/js/ezOrgan/ListView_list.js"                   ></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"        ></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"      ></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/fileFolderDrop.js"              ></script>
		<script type="text/javascript" src="/js/jquery-ui/jquery-ui.js"                     ></script>
		<script type="text/javascript" src="/js/ezWebFolder/pageNav.js"                     ></script>
		<script type="text/javascript">
			var blockSize    = 10;
			var currentPage  = 1;
			var totalPages   = 1;
			var totalRows    = 0;
			var fileRows     = 0;
			var folderRows   = 0;
			var primary      = "<c:out value='${primary}'/>";
			var strLang39    = "<spring:message code='ezWebFolder.t135'/>";
			var strLang40    = "<spring:message code='ezWebFolder.t136'/>";
			var strLang41    = "<spring:message code='ezWebFolder.t137'/>";
			var strLang42    = "<spring:message code='ezWebFolder.t138'/>";
			var startDateStr = "";
			var endDateStr   = "";
			var fileExtStr   = "";
			var fileNameStr  = "";
			var userNameStr  = "";
			var folderId     = "<c:out value='${folderId}'/>";
			var checkedArr   = [];
			var folderType   = "company";
			var rootFolder   = "<c:out value='${rootFolder}'/>";
			
			window.onresize = function () {
				var divList          = document.getElementById("dragDropArea");
				var reheight         = document.documentElement.clientHeight - 170;
				divList.style.height = reheight + "px";
			};
			
			window.onload = function () {
				getHiddenSharedList(1);
				preProcessing();
			}
			
			function preProcessing() {
				var divList          = document.getElementById("dragDropArea");
				var reheight         = document.documentElement.clientHeight - 170;
				divList.style.height = reheight + "px";
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
						var tdElmt10 = document.createElement("td");
						
						trElmt.setAttribute("class", "bnkWebFolder");
						trElmt.setAttribute("_fileId", result[i]["fileId"]);
						trElmt.setAttribute("_filePath", result[i]["folderPath"]);
						trElmt.onclick = function(event) {clickRow(this, event)};
						
						var inputElmt = document.createElement("input");
						inputElmt.setAttribute("type", "checkbox");
						inputElmt.setAttribute("value", result[i]["shareId"]);
						inputElmt.setAttribute("class", "checkBnk");
						inputElmt.onchange = function(e){getChecked(this)};
						tdElmt1.appendChild(inputElmt);
						
						var faImgElmt = document.createElement("img");
						if (result[i]["favouriteStatus"] == "0") {
							faImgElmt.src = "/images/ImgIcon/view-flag.gif";
						}
						else {
							faImgElmt.src = "/images/ImgIcon/icon-flag.gif";
						}
						tdElmt2.appendChild(faImgElmt);
						
						var fileIconElmt = document.createElement("img");
						fileIconElmt.setAttribute("class", "webfolderImg");
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
			
			function clickRow(obj, e) {
				e.stopPropagation();
				e.preventDefault();
				
				var inputElmt = obj.firstElementChild.firstElementChild;
				var id        = inputElmt.getAttribute("value");
				
				if (inputElmt.checked == true) {
					inputElmt.checked = false;
					
					var pos = checkedArr.indexOf(id);
					
					if (pos != -1) {
						checkedArr.splice(pos, 1);
						obj.setAttribute("style", "");
					}
				}
				else {
					inputElmt.checked = true;
					checkedArr.push(id);
					obj.setAttribute("style", "background-color: #e9f1ff;");
				}
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
			
			function refreshView() {
				getHiddenSharedList(currentPage);
			}
			
			function optionView(obj){
				if (obj.getAttribute("mode") == "off") {
					document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 165 + "px";
					document.getElementById("layer_Viewpopup").style.top = "96px";
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
			
			function getUserSimpleListStr(userListStr) {
				var result = "";
				var userArr = userListStr.split(",");
				var userArrSize = userArr.length;
				
				if (userArrSize == 1) {
					result = userArr[0];
				} else if (userArrSize > 1) {
					result = userArr[0] + " 외 " + (userArrSize - 1) + "명(팀)";
				}
				
				return result;
			}
			
			function changeCount(value) {
				blockSize = value;
				currentPage = 1;
				pStart = 0;
				refreshView();
			}
		
			function showShare() {
				if (checkedArr.length <= 0) {
					alert("<spring:message code='ezWebFolder.t108'/>");
					return;
				}
				
				var jsonStr = JSON.stringify(checkedArr);
				
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/showShare.do",
					contentType : "application/json; charset=UTF-8",
					data: jsonStr,
					dataType: "JSON",
					async: true,
					success : function(result) {
						if (result.status == "ok") {
							refreshView();
						} else {
							alert("<spring:message code='ezWebFolder.t134'/>" + " - errorCode : " + result.code);
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
			
			function getHiddenSharedList(pPage) {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/getHiddenSharedList.do",
					data: {
						"pageNum"           : pPage,
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
								+ folderRows + "</span> " + strLang42 + " / " + "<spring:message code='ezWebFolder.t277'/>" + " <span style='color:#017BEC;'>" + fileRows +" </span>" + strLang42 + "]";
						} else {
							alert("<spring:message code='ezWebFolder.t134'/>" + " - errorCode : " + result.code);
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
			
			function showSharedList() {
				location.href = "/ezWebFolder/webfolderSharedList.do";
			}
		</script>
	</head>
	<body class="mainbody">
		<h1>
			공유숨김목록
			<span id="mailBoxInfo"></span>
		</h1>
		
		<div id="mainmenu" style="position: relative;">
			<ul>
				<li id=""><a onClick="showSharedList()" style="margin-top: 3px;"><span>돌아가기</span></a></li>
				<li id=""><a onClick="showShare()" style="margin-top: 3px;"><span>숨김취소</span></a></li>
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
		
		<div id="dragDropArea" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)" style="margin: 10px 0px;">
			<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileList">
				<tr>
					<th width="30px"><input type="checkbox" onchange="getCheckAll(this);" id="_checkAll"></th>
					<th width="30px"><img src='/images/ImgIcon/icon-flag.gif' /></th><!-- 즐겨찾기 -->
					<th width="30px"><spring:message code='ezWebFolder.t188'/></th><!-- 유형 -->
					<th width="50%"><spring:message code='ezWebFolder.t156'/></th><!-- 이름 -->
					<th width="70px" style="text-align:center;">크기</th><!-- 크기 -->
					<th width="100px"><spring:message code='ezWebFolder.t189'/></th><!-- 게시자 -->
					<th width="100px"><spring:message code='ezWebFolder.t190'/></th><!-- 등록일 -->
					<th width="100px"><spring:message code='ezWebFolder.t198'/></th><!-- 갱신일 -->
					<th width="50%"><spring:message code='ezWebFolder.t199'/></th><!-- 위치 -->
					<th width="110px">공유자</th><!-- 공유자 -->
				</tr>
			</table>
		</div>
		
		<div id="layer_Viewpopup" style="width: 150px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
			<div class="popupwrap1">	
				<div class="popupwrap2">
					<table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
						<caption></caption>
	                    <colgroup>
	                        <col style="width: 80px;">
	                        <col>
	                    </colgroup>
						<tr>
							<th><spring:message code='ezBoard.t10021'/></th>
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
			<div class="shadow"></div>
		</div>
		
		<div class="layerpopup" style="z-index:2000; position:absolute; display:none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4'/>" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div id="tblPageRayer"></div>
	</body>
</html>