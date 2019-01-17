<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezWebFolder.i1', 'msg')}"   type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/adminTable.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
		<script type="text/javascript" >
			var blockSize    = 10;
			var currentPage  = null;
			var totalRows    = null;
			var totalPages   = null;
			var primary      = "<c:out value='${primary}'/>";
			var strLang39    = "<spring:message code='ezWebFolder.t135'/>";
			var strLang40    = "<spring:message code='ezWebFolder.t136'/>";
			var strLang41    = "<spring:message code='ezWebFolder.t137'/>";
			var strLang42    = "<spring:message code='ezWebFolder.t138'/>";
			var strActType1  = "<spring:message code='ezWebFolder.t160'/>";
			var strActType2  = "<spring:message code='ezWebFolder.t161'/>";
			var strActType3  = "<spring:message code='ezWebFolder.t162'/>";
			var strActType4  = "<spring:message code='ezWebFolder.t111'/>";
			var strActType5  = "<spring:message code='ezWebFolder.t19' />";
			var strActType6  = "<spring:message code='ezWebFolder.t287'/>";
			var strActType7  = "<spring:message code='ezWebFolder.t121'/>";
			var strActType8  = "<spring:message code='ezWebFolder.t122'/>";
			var strNoData    = "<spring:message code='ezWebFolder.t144'/>";
			var startDateStr = "";
			var endDateStr   = "";
			var fileExtStr   = "";
			var fileNameStr  = "";
			var userNameStr  = "";
			var actTypeStr   = "";
			var tableView    = new TableView();
			
			window.onload = function () {
				closeAllPopup();
				document.onselectstart = function() {return false;}
				
				tableView.setTableId("tblFileList");
				tableView.setTabledHeader("tblFileList1");
				tableView.setTableType("filelog");
				tableView.setSelectedClass("bnkWebFolder2");
				tableView.setUnselectClass("bnkWebFolder");
				tableView.setCallBack(refreshView);
				
				$("#Sdatepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.png",
					buttonImageOnly: true,
					dateFormat: "yy-mm-dd"
				});
				
				$("#Edatepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.png",
					buttonImageOnly: true,
					dateFormat: "yy-mm-dd"
				});
				
				search_Set("1");
				preProcessing();
			}
			
			window.onbeforeunload = function() {
				closeAllPopup();
			}
			
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
				
				document.getElementById("listCount").addEventListener("change", function() {
					optionHidden();
					pagination.setListSize(this.value);
					refreshView();
				});
				scroll();
				
			});
			
			function preProcessing() {
				var divList          = document.getElementById("dragDropArea");
				var reheight         = document.documentElement.clientHeight - 215;
				divList.style.height = reheight + "px";
				scroll();
			}
			
			function keyPressPanel(e) {
				if (e.which == 27 && document.getElementById("mailPanel").style.display == "") {openSearchPanel();}
			}
			
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
				document.getElementById("actionType").options[0].selected  = 'selected';
			}
			
			function closeAllPopups() {
				window.parent.frames["left"].document.getElementById("bnkBlockLeft").style.display = "none";
				document.getElementById("mailPanel").style.display                                 = "none";
				document.getElementById("searchPanel").style.display                               = "none";
				
				if (document.getElementById("ui-datepicker-div")) {
					document.getElementById("ui-datepicker-div").style.display = "none";
				}
			}
			
			function search_Set(pPage) {
				var orderInf = tableView.getOrderInfo();
				var listCnt  = document.getElementById("listCount").value;
				showProgress();
				
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getFileLogs.do",
					data: {
						"currentPage" : pPage,
						"startDate"   : startDateStr,
						"endDate"     : endDateStr,
						"fileExt"     : fileExtStr,
						"fileName"    : fileNameStr,
						"userName"    : userNameStr,
						"actionType"  : actTypeStr,
						"column"      : orderInf.col ? orderInf.col : "",
						"order"       : orderInf.ord ? orderInf.ord : "",
						"fileType"    : document.getElementById("fileTypeSelect").value,
						"listCntSize" : listCnt,
						"companyId"   : document.getElementById("companyList").value
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						hideProgress();
						var code = data.code;
						
						switch(code) {
							case 0: 
								var result  = data.fileLogList;
								totalRows   = data.totalRows;
								totalPages  = data.totalPages;
								currentPage = pPage;
								
								makePageSelPage();
								renderData(result);
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
						hideProgress();
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				});
			}
			
			function renderData(result) {
				tableView.setDataSource(result);
				tableView.renderTable();
				scroll();
			}
			
			function startSearch() {
				var sDateVal    = document.getElementById("Sdatepicker").value;
				var eDateVal    = document.getElementById("Edatepicker").value;
				var fileExtVal  = document.getElementById("fileExtVal").value;
				var fileNameVal = document.getElementById("fileNameVal").value;
				var userNameVal = document.getElementById("fileCreatorVal").value;
				var fileTypeIdx = document.getElementById("fileTypeVal").selectedIndex;
				var actTypeVal  = document.getElementById("actionType").value;
				
				/* if (!sDateVal && !eDateVal && !fileExtVal && !fileNameVal && !userNameVal) {
					alert("<spring:message code='ezWebFolder.t163'/>");
					return;
				} */
				
				if (sDateVal != "" && eDateVal == "") {
					alert("<spring:message code='ezWebFolder.t308' />");
					return;
				}
				
				if (eDateVal != "" && sDateVal == "") {
					alert("<spring:message code='ezWebFolder.t309' />");
					return;
				}
				
				if (sDateVal && eDateVal) {
					if (sDateVal > eDateVal) {
						alert("<spring:message code='ezWebFolder.t164'/>");
						return;
					}
				}
				
				document.getElementById("fileTypeSelect").selectedIndex = fileTypeIdx;
				
				startDateStr = sDateVal;
				endDateStr   = eDateVal;
				fileExtStr   = fileExtVal.replace(/\s/g,'');
				fileNameStr  = fileNameVal;
				userNameStr  = userNameVal;
				actTypeStr   = actTypeVal.replace(/\s/g,'');
				
				openSearchPanel();
				search_Set("1");
			}
			
			function change() {
				tableView.clearHeaders();
				startDateStr = "";
				endDateStr   = "";
				fileExtStr   = "";
				fileNameStr  = "";
				userNameStr  = "";
				actTypeStr   = "";
				search_Set("1");
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
			
			function refreshView() {
				search_Set(currentPage);
			}
			
			function excelExport() {
				var orderInf = tableView.getOrderInfo();
				
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/exportFileLogs.do",
					data: {
						"startDate"   : startDateStr,
						"endDate"     : endDateStr,
						"fileExt"     : fileExtStr,
						"fileName"    : fileNameStr,
						"userName"    : userNameStr,
						"actionType"  : actTypeStr,
						"column"      : orderInf.col ? orderInf.col : "",
						"order"       : orderInf.ord ? orderInf.ord : "",
						"fileType"    : document.getElementById("fileTypeSelect").value,
						"companyId"   : document.getElementById("companyList").value
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								var url = "/admin/ezWebFolder/downloadExcel.do?fileName=" + data.path;
								AttachDownFrame.location.href = url;
								break;
							case 1:
								alert("<spring:message code='ezWebFolder.t306'/>");
								break;
							case 2:
								alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 3:
								alert("<spring:message code='ezWebFolder.t300'/>");
								break;
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				});
			}

			function optionHidden() {
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
		   	}
		   	
			function scroll() {
				var BoardList_BODYHeight = document.getElementById("dragDropArea").clientHeight;
				var BoardListDivHeight = document.getElementById("tblFileList").clientHeight;
				
				 if (BoardList_BODYHeight > BoardListDivHeight) {
					if ($("#tblFileList1 tr th#forScroll").length > 0) {
						$("#tblFileList1 tr th#forScroll").remove();
					}
				} else {
					if ($("#tblFileList1 tr th#forScroll").length < 1) {
						$("#tblFileList1 tr th#forScroll").remove();
						$("#tblFileList1 tr").append("<th></th>");
						
							var lastTh = $("#tblFileList1 tr th").last();
							lastTh.attr("id", "forScroll");
							lastTh.css("width", "15px");
							
					}
				}
				 
				/*var lastTh = $("#BoardList_TH th").last();
				if (lastTh.attr("id") == null) {
					lastTh.css("display", "none");
				}*/
			}
			
		</script>
	</head>
	<body class="mainbody" onresize="preProcessing();" onkeydown="keyPressPanel(event);">
		<h1>
			<spring:message code='ezWebFolder.t128'/>
			<span id="mailBoxInfo"></span>
		</h1>
		<div id="companySelect" style="margin: 10px 0px 10px 5px;">
			<span style="font-size: 12px; display: inline-block; vertical-align: middle;"><b><spring:message code='ezWebFolder.t129'/></b></span>
			<select id="companyList" style="font-size: 12px; height: 20px; display: inline-block;" onchange="change();">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</div>
		
		<div id="mainmenu2" style="position: relative; margin-left: 5px;">
			<ul>
				<li id=""><a id="btnSearch"  style="margin-top: 3px;" onClick="openSearchPanel();"><span><spring:message code='ezWebFolder.t123' /></span></a></li>
				<li id=""><a id="btnRefresh" style="margin-top: 3px;" onClick="refreshView();"    ><span><spring:message code='ezWebFolder.t139' /></span></a></li>
				<li id=""><a id="btnSave"    style="margin-top: 3px;" onClick="excelExport();"    ><span><spring:message code='ezStatistics.t1003'/></span></a></li>
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
				<li style="float:right;"><img src ="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="webfolderlistoptiondiv" /></li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu2"), "ul", "li", "0");
		</script>
		
		<div id="searchPanel" class="popup wfSearchPanel" style="display: none;">
			<h1><spring:message code='ezWebFolder.t24'/></h1> 
			<div class="wfClose" onclick="openSearchPanel();"><ul><li><span></span></li></ul></div>
			<div style="margin: 10px 0px 15px;">
				<table class="content wftable">
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t151'/></th>
						<td>
							<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">&nbsp;~&nbsp;<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
						</td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t152'/></th>
						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
							<input id="fileExtVal" type="text" style="height: 23px; width: 200px;">
							<select style="height: 25px; padding: 0px; width: 85px;" id="fileTypeVal">
								<option value="1" selected><spring:message code='ezWebFolder.t191'/></option>
								<option value="2"         ><spring:message code='ezWebFolder.t192'/></option>
								<option value="3"         ><spring:message code='ezWebFolder.t193'/></option>
								<option value="4"         ><spring:message code='ezWebFolder.t194'/></option>
								<option value="5"         ><spring:message code='ezWebFolder.t195'/></option>
								<option value="6"         ><spring:message code='ezWebFolder.t196'/></option>
							</select>
						</td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t153'/></th>
						<td class="wfSearchTd">
							<input id="fileNameVal" type="text" style="height: 23px;">
						</td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t154'/></th>
						<td class="wfSearchTd">
							<input id="fileCreatorVal" type="text" style="height: 23px;">
						</td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t158'/></th>
						<td>
							<select style="height: 25px; padding: 0px; width: 85px;" id="actionType">
								<option value="M" selected><spring:message code='ezWebFolder.t191'/></option>
								<option value="C"         ><spring:message code='ezWebFolder.t160'/></option>
								<option value="D"         ><spring:message code='ezWebFolder.t161'/></option>
								<option value="U"         ><spring:message code='ezWebFolder.t162'/></option>
								<option value="R"         ><spring:message code='ezWebFolder.t111'/></option>
								<option value="P"         ><spring:message code='ezWebFolder.t19' /></option>
								<option value="RE"        ><spring:message code='ezWebFolder.t287'/></option>
							</select>
						</td>
					</tr>
				</table>
			</div>
			<div class="wfdivBttn">
				<a class="webfolderBttn"><span onclick="startSearch();"    ><spring:message code='ezWebFolder.t123'/></span></a>
				<a class="webfolderBttn"><span onclick="openSearchPanel();"><spring:message code='ezWebFolder.t112'/></span></a>
			</div>
		</div>
		
		<div style="width:100%;"id ="tblFileList1_div">
			<div style="margin:0px 0px 0px !important;min-width: 700px;" >
				<table class="mainlist" style="width:100%"  id="tblFileList1">
					<thead id ="BoardList_THEAD">
						<tr>
							<th headers="ft" class="wfFileType" style="text-align: center;"><spring:message code='ezWebFolder.t188'/></th>
							<th headers="fn" class="wfFileLogName"><spring:message code='ezWebFolder.t156'/></th>
							<th headers="fs" class="wfFileFavoriteSize"><spring:message code='ezWebFolder.t157'/></th>
							<th headers="un" class="wfFileLogMember" ><spring:message code='ezWebFolder.t339'/></th>
							<th headers="at" class="wfActive" ><spring:message code='ezWebFolder.t158'/></th>
							<th headers="ad" class="wfFileLogDate" style="text-align: center;"><spring:message code='ezWebFolder.t159'/></th>
						</tr>
					</thead>
				</table>
				<div id="dragDropArea"  style="overflow-y:auto;white-space:nowrap;" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)">
					<table class="mainlist" style="width: 100%;margin:0px 0px 0px !important; white-space:nowrap;" id="tblFileList">
				
					</table>
				</div>
			</div>
		</div>
		
		<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
			<img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
		</div>
		
		<div id="tblPageRayer"></div>
		<iframe name="AttachDownFrame" id="AttachDownFrame"></iframe>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel" onclick="closeAllPopups();">&nbsp;</div>
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
		<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/pageNav.js')}"></script>
	</body>
</html>
