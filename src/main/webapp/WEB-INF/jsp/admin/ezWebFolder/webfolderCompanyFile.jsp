<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/duplicate-file.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/capacity.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/adminTable.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/adminFile.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezWebFolder/selectUsers.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.js')}"></script>
		<script type="text/javascript">
			var strLang39  = "<spring:message code='ezWebFolder.t135'/>";
			var strLang40  = "<spring:message code='ezWebFolder.t136'/>";
			var strLang41  = "<spring:message code='ezWebFolder.t137'/>";
			var strLang42  = "<spring:message code='ezWebFolder.t138'/>";
			var strNoData  = "<spring:message code='ezWebFolder.t144'/>";
			var strLang38  = "<spring:message code='ezWebFolder.t108'/>";
			var strLang37  = "<spring:message code='ezWebFolder.t115'/>";
			var strLang36  = "<spring:message code='ezWebFolder.t163'/>";
			var strLang35  = "<spring:message code='ezWebFolder.t164'/>";
			var strLang34  = "<spring:message code='ezWebFolder.t184'/>";
			var strError   = "<spring:message code='ezWebFolder.t134'/>";
			var strSuccess = "<spring:message code='ezWebFolder.t27' />";
			var resultErr1 = "<spring:message code='ezWebFolder.t306'/>";
			var resultErr2 = "<spring:message code='ezWebFolder.t305'/>";
			var resultErr3 = "<spring:message code='ezWebFolder.t300'/>";
			var resultErr4 = "<spring:message code='ezWebFolder.t249'/>";
			var resultErr5 = "<spring:message code='ezWebFolder.t250'/>";
			var resultErr6 = "<spring:message code='ezWebFolder.kes014'/>";
			var _selectedCell = null;
			var _cellInfo        = {};
			var sortColumn = null;
			var sortType = null;
			var strLang43  = "<spring:message code='ezWebFolder.t308'/>";
			var containsReplyFiles = [];
			var contextClickedTr = null;
			var uploadLimit = <c:out value="${uploadLimit}" />;
			var selectXhr         	= null;
			var authListUser		= [];
			var strictAuthList		= [];
			var addUser    			= [];
			var deleteUser    		= [];
			var subFolderType 		= "0";
			var userManager = {
					targetId: "",
					targetType: ""
			};
			var uploadIng = false;
			var uploadIngStatusMessage = "<spring:message code='uploadIngStatusMessage'/>";
			
			capacity.setFolderIdProvider(function() {
				return "<c:out value='${folderId}'/>";
			});
			
			$(function () {
				$.datepicker.regional["<spring:message code='main.t0619' />"] = {
					closeText: "<spring:message code='main.t3' />",
					prevText: "<spring:message code='main.t0604' />",
					nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
					monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					             "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					             "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					             "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					                  "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					                  "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					                  "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					           "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
					           "<spring:message code='main.t0627' />"],
					dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					                "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					                "<spring:message code='main.t0627' />"],
					dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					              "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					              "<spring:message code='main.t0627' />"],
					weekHeader: "Wk",
					dateFormat: "yy-mm-dd",
					firstDay: 0,
					isRTL: false,
					duration: 200,
					showAnim: "show",
					showMonthAfterYear: true
				};
				
				$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
				
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
				
				// listoption 클릭 이벤트
				document.getElementById("webfolderlistoptiondiv").addEventListener("click", function(event) {
					event.stopPropagation();
					optionView(event.target);
				});
				
				var listHeader = document.getElementsByClassName("headListClick");
				for(var i = 0 ; i <listHeader.length; i++) {
					listHeader[i].addEventListener("click", function(event) {
						sortByHeader(this);
					});
				}
				
				document.getElementById("listCount").addEventListener("change", function() {
					optionHidden();
					pagination.setListSize(this.value);
					refreshView();
				});

				document.body.addEventListener("click", hideContextMenu, true);
				document.getElementById("dragDropArea").addEventListener("scroll", hideContextMenu);
			});
			
			function openSearchPanel() {
				var searchPanel = document.getElementById("searchPanel");
				if (searchPanel.style.display == "none") {
					window.parent.frames["left"].document.getElementById("bnkBlockLeft").style.display = "";
					document.getElementById("mailPanel").style.display                              = "";
					var position              = getPosition(516, 247);
					searchPanel.style.top     = position[0] + "px";
					searchPanel.style.right   = position[1] + "px";
					searchPanel.style.display = "";
				}
				else {
					closeAllPopups();
				}
				
				$("#Sdatepicker").datepicker('setDate', "");
				$("#Edatepicker").datepicker('setDate', "");
				document.getElementById("fileExtVal").value                = "";
				document.getElementById("fileNameVal").value               = "";
				document.getElementById("fileCreatorVal").value            = "";
				document.getElementById("fileTypeVal").options[0].selected = 'selected';
			}
			
			function closeAllPopups() {
				window.parent.frames["left"].document.getElementById("bnkBlockLeft").style.display = "none";
				document.getElementById("mailPanel").style.display                                 = "none";
				document.getElementById("searchPanel").style.display                               = "none";
				
				if (document.getElementById("ui-datepicker-div")) {
					document.getElementById("ui-datepicker-div").style.display = "none";
				}
				
				DivPopUpHidden();
			}
			
			function getPosition(popUpW, popUpH) {
				var returnValue = new Array();
				var heigth      = window.parent.document.documentElement.clientHeight;
				if (heigth == 0) {heigth = window.parent.document.body.clientHeight;}
				
				var width = window.parent.document.documentElement.clientWidth;
				if (width == 0) {width = window.parent.document.body.clientWidth;}
				
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				
				if (heigth < (popUpH + 50)) {
					returnValue[0] = (heigth / 2);
				}
				else {
					returnValue[0] = (heigth / 2) - 50;
				}
				
				returnValue[1] = pleftpos / 2;
				return returnValue;
			}
			
			function sortByHeader(cell) {
				var column = cell.getAttribute("data-column");
				
				if (!column) {return;}
				
				if (_selectedCell != null) {
					var orderOption = cell.getAttribute("orderoption") == "DESC" ? "ASC" : "DESC";
					cell.setAttribute("orderoption", orderOption);
					
					if (cell.cellIndex != _selectedCell) {
						var lastSelectedCell = document.getElementById("BoardList_THEAD").rows[0].cells[_selectedCell];
						lastSelectedCell.removeChild(lastSelectedCell.lastElementChild);
						var spanElmt = document.createElement("span");
						cell.appendChild(spanElmt);
					}
					
					var spanImg       = cell.lastElementChild;
					spanImg.className = orderOption == "DESC" ? "spanDown" : "spanUp";
				} else {
					cell.setAttribute("orderoption", "DESC");
					var spanElmt       = document.createElement("span");
					spanElmt.className = "spanDown";
					cell.appendChild(spanElmt);
				}
				
				_selectedCell = cell.cellIndex;
				
				var order     = cell.getAttribute("orderoption");
				this.sortType = order;
				this.sortColumn = column;
				search_Set(currentPage);
			}
			
			/* function optionHidden() {
		 	    document.getElementById("layer_Viewpopup").style.display = "none";
		 	    document.getElementById("webfolderlistoptiondiv").setAttribute("mode", "off");
		 	    document.getElementById("webfolderlistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");
		 	}
			function optionView(obj) {
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
		   	} */
			
	        function leftFolderCPMV(functionType, folderList, toTargetId) {
				closeAllPopup();
				window.close();
	        }

			// 메일의 콘텍스트 메뉴를 그대로 들고옴
			function openContextMenu(event) {
				if (document.getElementById("contextMenuDiv").style.display == "") {
					hideContextMenu();
				}
				if (!event)
					event = window.event;
				
				event.stopPropagation();
				event.preventDefault();
				contextClickedTr = event.currentTarget;
				
				var EventMouseX = event.clientX;
				var EventMouseY = event.clientY;
				
				var listsizeheight = document.documentElement.clientHeight;
				var listsizewidth = document.documentElement.clientWidth;
				
				var target = event.target ? event.target : event.srcElement;
				var targetTag = target.tagName;
				var EventDivSize = EventMouseY + $("#contextMenuDiv").height() + 70;

				if (listsizeheight < EventDivSize) {
					var Div_ = EventDivSize - listsizeheight;
					EventMouseY = EventMouseY - Div_;
				}
				
				EventDivSize = EventMouseX + 140;
				if (listsizewidth < EventDivSize) {
					var Div_ = EventDivSize - listsizewidth;
					EventMouseX = EventMouseX - Div_;
				}

				document.getElementById("contextMenuDiv").style.left = EventMouseX + "px";
				document.getElementById("contextMenuDiv").style.top = EventMouseY + "px";
				document.getElementById("contextMenuDiv").style.display = "";
			}

			function hideContextMenu() {
				document.getElementById("contextMenuDiv").style.display = "none";
				if (window.contextClickedTr) {
					setTimeout(function() {
						contextClickedTr = null;
					}, 0);
				}
			}
			
			function unidocsWebViewer(event){
				event.stopPropagation();
				event.preventDefault();
				var trElmt = event.currentTarget;
				var fileId = trElmt.getAttribute("_fileId");
				
				 var json = {
						"folderId" : folderId,
						"fileId" : fileId, 
						"adminPage" : "admin"
				};
				openLeftPanel();
				document.getElementById("webFolderRightPanel").style.display = "block";
				document.getElementById("webFolderRightPanel").style.background = "rgba(0,0,0,0.5)";
				showProgress();
				
				$.ajax({
					type:"POST",
					async: true,
					url : "/ezWebFolder/webfolderFileDownForUnidocs.do",
					data : JSON.stringify(json),
					contentType: "application/json; charset=UTF-8",
					dataType: "JSON",
					success : function (result) {
						hideProgress();
						document.getElementById("webFolderRightPanel").style.display = "none";
						closeLeftPanel();
						if (result.status == "OK"){
							var unidocsUrl = result.url + result.encData;
							window.open(unidocsUrl, '_blank'); 
						} else if (result.code == -1) {
							alert("<spring:message code='webfolder.wfjob.notsupport' />");
						} else {
							alert("<spring:message code='ezWebFolder.t305' />");
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t305' />");
						closeLeftPanel();
						hideProgress();
						document.getElementById("webFolderRightPanel").style.display = "none";
					}
				});
			}
			function getUsersPage_manager() {
				authListUser = [];			
				addUser      = [];
				deleteUser   = [];
				var url 	 = "";
				if (selectXhr) {
					selectXhr.abort();
				}
//				var trElmt = event.currentTarget;
				var filesList = getCheckedRowInfo();

				if (filesList == null) {
					alert(messages.strLang5);
					return;
				}

				if (filesList.length > 1) {
					alert(messages.strLang39);
					return;
				}
				
				var targetId = filesList.toString();
				var targetType = "f";

				url = "/admin/ezWebFolder/getFileUsers.do";
				
				data = {
					"fileId"	: targetId,
					"folderId"	: targetId,
					"folderManager" : "${folderManager}"
				}

				// global
				userManager.targetId = targetId;
				userManager.targetType = targetType;

				selectXhr = $.ajax({
					type: "POST",
					url: url,
					data: data,
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;
						
						switch(code) {
							case 0:
								var folderUsers = data.folderUsers;
								if(folderUsers != null && folderUsers.length != 0) {
									for (var i = 0; i < folderUsers.length ; i++) {
										if(folderUsers[i]["folderManager"]) {
											continue;
										}
										var auth         		= {};
										auth["userId"]   		= folderUsers[i]["userId"];
										auth["userName"] 		= "<spring:message code='main.t0619' />" == "ko" ? folderUsers[i]["displayName1"] : folderUsers[i]["displayName2"];
										auth["userType"]   		= folderUsers[i]["userType"];
										auth["subdeptPermitted"]= folderUsers[i]["subdeptPermitted"];
										auth["sn"] 		 		= i;
										auth["folderManager"]	= folderUsers[i]["folderManager"];
										auth["displayDeptName"] = "<spring:message code='main.t0619' />" == "ko" ? folderUsers[i]["displayDeptName1"] : folderUsers[i]["displayDeptName2"];
										authListUser.push(auth);
									}
									strictAuthList 		= authListUser;
								}
								menu_SelectRange("${companyId}", 0);
								break;
							case 1:
								alert("<spring:message code='ezWebFolder.t306'/>");
								break;
							case 2:
								alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 3:
								alert("<spring:message code='ezWebFolder.t300' />");
								break;
						}
					},
					error : function(error) {
						if (error.statusText == "abort") {
							return;
						}

						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					},
					complete: function() {
						selectXhr = null;
					}
				});
			}
			function convertJSONToJSONStr(obj) {
				var returnStr = obj;
				if (typeof returnStr != "string") {
					var tmp = obj.length == 0 ? [] : obj;
					returnStr = JSON.stringify(tmp);
				}
				
				return returnStr;
			}
			function saveChanges_manager(returnMsg) { // returnMsg == ture ? return message : alert message;
				if(addUser.length == 0 && deleteUser.length == 0) {
					return;
				}
				
				var strAuthListUser = (typeof authListUser == "string")? authListUser : JSON.stringify(authListUser);
				var ajaxData = {
						"currFolderId"  : folderId,
						"targetId"   	: userManager.targetId,
						"targetType" 	: userManager.targetType,
						"folderUsers" 	: strAuthListUser,
						"addUser" 		: convertJSONToJSONStr(addUser),
						"deleteUser" 	: convertJSONToJSONStr(deleteUser),
						"subFolderType"	: subFolderType,
						"folderManager" : "${folderManager}"
					};
					var reMsg = "";
				
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/changeUserFileORFolder.do",
					data: ajaxData,
					dataType: "JSON",
					async: false,
					success: function(data) {
						var code = data.code;
						
						switch(parseInt(code)) {
							case 0: 
								reMsg = "<spring:message code='ezWebFolder.t182'/>";
								//alert("<spring:message code='ezWebFolder.t182'/>");
								break;
							case 1:
								reMsg = "<spring:message code='ezWebFolder.t306'/>";
								//alert("<spring:message code='ezWebFolder.t306'/>");
								break;
							case 2:
								reMsg = "<spring:message code='ezWebFolder.t305'/>";
								//alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 3:
								reMsg = "<spring:message code='ezWebFolder.t300' />";
								//alert("<spring:message code='ezWebFolder.t300' />");
								break;
							case 8:
								reMsg = messages.resultErrDuplicateRename;
								//alert(messages.resultErrDuplicateRename);
								break;
						}
					},
					error: function (xhr, status, e){
						reMsg = "<spring:message code='ezWebFolder.t134'/>";
						//alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});

				
				if (returnMsg) {
					return reMsg;
				} else {
					alert(reMsg);
				}
			}
		</script>
	</head>
	<body class="mainbody" onload="init('comp');" onresize="preProcessing();" onkeydown="keyPressPanel(event);">
		<h1>
			<spring:message code='ezWebFolder.t127'/>
			<span id="mailBoxInfo"></span>
			<div id="capacity-wrapper">
				<div class="progressbar">
					<div id="capacity-bar" class="proggress"></div>
				</div>
				<span id="capacity-percent"></span>
			</div>
		</h1>
		<div id="companySelect" style="margin-left: 5px;">
			<span><b><spring:message code='ezWebFolder.t129'/></b></span>
			<select id="companyList">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</div>
		
		<div id="mainmenu" style="position: relative; margin-left: 5px;">
			<ul>
				<li id="" class="important" onclick="fileDownload();"><span><spring:message code='ezWebFolder.t161'/></span></li>
				<!-- root에서 파일업로드 되도록하려면 아래를 주석  -->
<%-- 				<c:if test="${level != '0'}"> --%>
				<li id="uploadBttn" class="important" onclick="fileUpload();"><span><spring:message code='ezWebFolder.t160'/></span></li>
<%-- 				</c:if> --%>
				<c:if test="${usePreview}">
					<li id="previewButton"><span onclick="filePreview()"><spring:message code='main.t4009' /></span></li>
				</c:if>
				<li id="" onclick="fileRename();"><span><spring:message code='ezWebFolder.t508'/></span></li>
				<li id="moveButton" onclick="fileMove();"><span><spring:message code='ezWebFolder.t120'/></span></li>
				<c:if test="${useVersionHistory}">
					<li><span onclick="openFileVersionHistory()"><spring:message code='webfolder.version.button' /></span></li>
				</c:if>
				<li id="userManagerBtn"><span onclick="getUsersPage_manager()"><spring:message code='ezWebFolder.kes013' /></span></li>
				<li id="SearchOption" mode="off" onclick="openSearchPanel();"><span class="icon16 icon16_search"></span></li>
				<li><span class="icon16 icon16_delete" onclick="fileDelete();"></span></li>
				<li><span class="icon16 icon16_refresh" onclick="refreshView();"></span></li>
				<li id="">
					<select id="fileTypeSelect" onchange="search_Set('1');">
						<option value="1" selected><spring:message code='ezWebFolder.t191'/></option>
						<option value="2"         ><spring:message code='ezWebFolder.t192'/></option>
						<option value="3"         ><spring:message code='ezWebFolder.t193'/></option>
						<option value="4"         ><spring:message code='ezWebFolder.t194'/></option>
						<option value="5"         ><spring:message code='ezWebFolder.t195'/></option>
						<option value="6"         ><spring:message code='ezWebFolder.t196'/></option>
						<option value="7"         ><spring:message code='ezWebFolder.t311'/></option>
					</select>
				</li>
				<div class="sub_frameIcon" style="float:right" id="wfOptionDiv">
					<div class="sub_frameIconUL02">
					  	<p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="webfolderlistoptiondiv"></span></p>  
					</div>
				</div>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			setParameter("<c:out value='${folderId}'/>", "<c:out value='${primary}'/>", "company", "<c:out value='${rootFolder}'/>", "<c:out value='${level}'/>");
		</script>
		
		<div id="searchPanel" class="wfSearchPanel popupwrap3 modal" style="margin-bottom: 70px; display: none; width:537px;">
		<div class="popupJQLayer" >
			<div class="title"><spring:message code='ezWebFolder.t21'/></div>
			<div id = "wfSearchCloseBttn" class="wfClose" onclick="openSearchPanel();"><ul><li><span></span></li></ul></div>
				<table class="content wftable">
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t151'/></th>
						<td class="wfSearchTd"><input type="text" id="Sdatepicker" style="width:80px; text-align:center" readonly="readonly">&nbsp;~&nbsp;<input type="text" id="Edatepicker" style="width:80px; text-align:center" readonly="readonly"></td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t152'/></th>
						<td class="wfSearchTd"><input id="fileExtVal" type="text" style="height: 23px;"></td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t153'/></th>
						<td class="wfSearchTd"><input id="fileNameVal" type="text" style="height: 23px;"></td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t154'/></th>
						<td class="wfSearchTd"><input id="fileCreatorVal" type="text" style="height: 23px;"></td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t188'/></th>
						<td class="wfSearchTd">
							<select id="fileTypeVal">
								<option value="1" selected><spring:message code='ezWebFolder.t191'/></option>
								<option value="2"         ><spring:message code='ezWebFolder.t192'/></option>
								<option value="3"         ><spring:message code='ezWebFolder.t193'/></option>
								<option value="4"         ><spring:message code='ezWebFolder.t194'/></option>
								<option value="5"         ><spring:message code='ezWebFolder.t195'/></option>
								<option value="6"         ><spring:message code='ezWebFolder.t196'/></option>
								<option value="7"         ><spring:message code='ezWebFolder.t311'/></option>
							</select>
						</td>
					</tr>
				</table>
			<div class="wfdivBttn">
				<a class="webfolderBttn"><span><spring:message code='ezWebFolder.t123'/></span></a>
				<a class="webfolderBttn" style="display:none"><span><spring:message code='ezWebFolder.t112'/></span></a>
			</div>
		</div>
		</div>
		
		<div id="progress-wrp" style="display: none; margin-left: 5px;">
			<div class="progress-bar"></div ><div class="status">0%</div>
		</div>
		
		<div style="width:100%;"id ="tblFileList1_div">
			<div style="margin:0px 0px 0px !important;min-width: 700px;" >
				<table class="mainlist" style="width:100%"  id="tblFileList1">
					<thead id ="BoardList_THEAD">
						<tr>
							<th class="wfFilecheck" style="text-align: center; "><div class="custom_checkbox"><input type="checkbox"></div></th>
							<th headers="ft" class="wfFileType		headListClick" data-column="FILETYPE_ICON" style="text-align: center; "><spring:message code='ezWebFolder.t188'/></th>
							<th headers="fn" class="wfFileName		headListClick" data-column="FILE_NAME" ><spring:message code='ezWebFolder.t156'/></th>
							<th headers="fs" class="wfFileSize		headListClick" data-column="FILE_SIZE" style="text-align: center; " ><spring:message code='ezWebFolder.t157'/></th>
							<th headers="un" class="wfFileCreator	headListClick" data-column="CREATE_NAME1" ><spring:message code='ezWebFolder.t189'/></th>
							<th headers="cd" class="wfFileAdminDate	headListClick" data-column="CREATE_DATE" ><spring:message code='ezWebFolder.t190'/></th>
							<th headers="ud" class="wfFileAdminDate	headListClick" data-column="UPDATE_DATE" ><spring:message code='ezWebFolder.t198'/></th>
							<th              class="wfFilePath		" data-column="FILE_PATH" ><spring:message code='ezWebFolder.t199'/></th>
							<th headers="dt" class="wfFileDownload	headListClick" data-column="DOWN_COUNT" style="text-align: center;"><spring:message code='ezWebFolder.t200'/></th>
						</tr>
					</thead>
				</table>
				<div id="dragDropArea"  style="overflow-y:auto;white-space:nowrap;" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)">
					<table class="mainlist" style="width: 100%;margin:0px 0px 0px !important; white-space:nowrap;" id="tblFileList">
				
					</table>
				</div>
			</div>
		</div>
		
		<input id="file" type="file" multiple="multiple"/>
		<iframe name="AttachDownFrame" id="AttachDownFrame"></iframe>
		<div class="wfFogPanel" style="display: none;" id="mailPanel" tabindex="0">&nbsp;</div>
		<div class="layerpopup wfPopup" style="display: none;" id="iFramePanel"><iframe src="" style="border:none;" id="iFrameLayer"></iframe></div>
		
		<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
			<img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
		</div>
		
		<div id="tblPageRayer"></div>
		<!-- 파일 리스트 10~ 50 선택 -->
	    <div id="layer_Viewpopup" style="width: 250px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
	        <div class="popupwrap1">	
	            <div class="popupwrap2">
	                <table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
	                    <caption></caption>
	                    <colgroup>
	                        <col style="width: 90px;">
	                        <col>
	                    </colgroup>
	                    <tr>
	                        <th><spring:message code='ezBoard.t10021' /></th>
	                        <td>
	                            <select id="listCount" class="wfListCnt">
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
		<%@ include file="/WEB-INF/jsp/ezWebFolder/component/downloadOptionPopup.jsp" %>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:5000;display:none;" id="webFolderRightPanel">&nbsp;</div>
		<div id="contextMenuDiv" style="position: absolute; z-index: 6000; display: none;">
			<table cellpadding="2" cellspacing="1" border="0" class="popuplist">
				<tbody>
					<c:if test="${usePreview}">
					<tr id="previewMenu">
						<td onclick="filePreview();" onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor: pointer; background-color: rgb(255, 255, 255);">
							<span style="font-size: 12px; width: 100%; display: inline-block;"><img src="/images/icon_preview.png" align="absmiddle" hspace="5"><spring:message code='main.t4009' /></span>
						</td>
					</tr>
					</c:if>
					<tr id="moveMenu">
						<td onclick="fileMove();" onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor: pointer; background-color: rgb(255, 255, 255);">
							<span style="font-size: 12px; width: 100%; display: inline-block;"><img src="/images/ImgIcon/move.gif" align="absmiddle" hspace="5"><spring:message code='ezWebFolder.t251' /></span>
						</td>
					</tr>
					<c:if test="${useVersionHistory}">
					<tr>
						<td onclick="openFileVersionHistory();" onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor: pointer; background-color: rgb(255, 255, 255);">
							<span style="font-size: 12px; width: 100%; display: inline-block;"><img src="/images/ImgIcon/options.gif" align="absmiddle" hspace="5"><spring:message code='webfolder.version.button' /></span>
						</td>
					</tr>
					</c:if>
					<tr>
						<td onclick="refreshView();" onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor: pointer; background-color: rgb(255, 255, 255);">
							<span style="font-size: 12px; width: 100%; display: inline-block;"><img src="/images/ImgIcon/recur.gif" align="absmiddle" hspace="5"><spring:message code='ezWebFolder.t139' /></span>
						</td>
					</tr>
					<tr id ="folderManagerTR">
						<td onclick="getUsersPage_manager();" onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor: pointer; background-color: rgb(255, 255, 255);">
							<span style="font-size: 12px; width: 100%; display: inline-block;"><img src="/images/ImgIcon/options.gif" align="absmiddle" hspace="5"><spring:message code='ezWebFolder.kes013' /></span>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/pageNav.js')}"></script>
	</body>
</html>
