<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
	<c:if test="${mode eq 'pickup'}">
	<title><spring:message code='ezWebFolder.t522' /></title>
	</c:if>
	<c:if test="${mode eq 'upload'}">
	<title><spring:message code='ezWebFolder.kes064' /></title>
	</c:if>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>	
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/pageNav.js')}"></script>
	<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
	<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"/>
	<!-- datepicker -->
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
	<!-- module -->
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/row-selector.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/favorite.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/search.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/selectUsers.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
	<style>
		.wfFileFavorite .wfFileCreator .wfFilePath .wfFileShare {
			display:none;
		}
		.wfFilecheck 		{min-width:10px; width:5%;}
		.wfFileType 		{min-width:10px; width:7%;}
		.wfFileName 		{min-width:10px; width:59%;}
		.wfFileSize 		{min-width:10px; width:12%;}
		.wfFileUpdateDate 	{min-width:10px; width:15%;}
	</style>	
    <script type="text/javascript">
		// el
		var userName = "${userInfo.userName}";
		var folderInfo = '${folderInfo}';
		var allFileFlag = "${allFileFlag}";
		var parentId = "${parentId}";
		var mode = "${mode}";
		// jstl
		var uploadLimit = "<c:out value='${uploadLimit}' />";	// pickup.jsp에서 쓰는 것은 아니지만, (parent.js-drop.js에서 사용.) controller를 거쳐 값을 받아와야 하므로 parent.jsp에서 부르기 보단(팝업시에는 다양해짐.) pickup.jsp에서 불러서 → parent에 전해주는것이 나을것이라 생각. 기능상 통일되기도 한다.
		var folderId = "<c:out value='${folderId}'/>";
		// : message
		var strShared1	= messages.strLang2;
		var strShared2	= messages.strLang3;
		var strErr		= messages.strLang4;
		var strSuccess  = "<spring:message code='ezWebFolder.t27' />";
		var resultErr1 = "<spring:message code='ezWebFolder.t306'/>";
		var resultErr2 = "<spring:message code='ezWebFolder.t305'/>";
		var resultErr3 = "<spring:message code='ezWebFolder.t300'/>";
		var resultErr4 = "<spring:message code='ezWebFolder.t249'/>";
		var resultErr5 = "<spring:message code='ezWebFolder.t250'/>";
		var springMonthMsg = "<spring:message code='ezSchedule.t110' />";
		var springDayMsg = "<spring:message code='ezSchedule.t108' />";
		var springLang = "<spring:message code='main.t0619' />";
		var springCloseText = "<spring:message code='main.t3' />";
		var springPrevText = "<spring:message code='main.t0604' />";
		var springNextText = "<spring:message code='main.t0605' />";
		var springCurrentText = "<spring:message code='main.t0606' />";
		var springError1 = "<spring:message code='ezWebFolder.t306' />";
		var springError2 = "<spring:message code='ezWebFolder.t305' />";
		var springError3 = "<spring:message code='ezWebFolder.t300' />";
		var springSharedMsg = "<spring:message code='ezWebFolder.t214' /> ";
		var springConfirmError1NotFiles = "<spring:message code='ezWebFolder.t108' />";
		var springConfirmError2Encrypted = "<spring:message code='webfolder.encrypted.approve.attach' />";
	</script>
	<!-- webfolderFilePickup -->
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/webfolderFilePick.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/webfolderFilePickup.js')}"></script>
	<c:if test="${mode eq 'upload'}">
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/webfolderFileUpload.js')}"></script>
	</c:if>
</head>

	<body style="overflow:hidden;" class="popup">
		<c:if test="${mode eq 'pickup'}">
		<h1><spring:message code='ezWebFolder.t522' /></h1>
		</c:if>
		<c:if test="${mode eq 'upload'}">
		<h1><spring:message code='ezWebFolder.kes064' /></h1>
		</c:if>
		<div id="close">
            <ul>
                <li><span onclick="cancel()"></span></li>
            </ul>
        </div>
		<select class="select" id="taskRootFolder" onchange="getFileList(this.value)" style="margin-top: -6px;margin-left: 6px; max-width: 400px;">
		</select>
		<div class="custom_radio" style="position: absolute; top: 54px; right: 10px;">
			<input name="treeType" id="radio1" type="radio" value="C" checked onclick="radioOnclick('C');"><label for="radio1"><span><spring:message code='ezWebFolder.t233'/></span></label>
			<input name="treeType" id="radio2" type="radio" value="D"         onclick="radioOnclick('D');"><label for="radio2"><span><spring:message code='ezWebFolder.t234'/></span></label>
			<input name="treeType" id="radio3" type="radio" value="U"         onclick="radioOnclick('U');"><label for="radio3"><span><spring:message code='ezWebFolder.t235'/></span></label>
			<input name="treeType" id="radio4" type="radio" value="S"         onclick="radioOnclick('S');"><label for="radio4"><span><spring:message code='ezWebFolder.t266'/></span></label>
		</div>
	<div id="pageArea">
		<div style="height:40px;">
			<div style="font-size: 24px;font-weight: bold;font-weight: bold; padding: 8px 4px 0px;" id ="originalPath" ></div>
		</div>
		<div id="mainmenu">
			<ul>
				<input type="text" id="searchFileName"  onkeyup="enterkey(this)" style="float:left;margin-right:3px;margin-left:5px;height:31px !important;" value="" name="searchFileName" placeholder="<spring:message code='ezWebFolder.t523' />">
<!-- 				<input type="text" id="searchFileName" style="float:left;margin-right:3px;height:31px;" value="" name="searchFileName" placeholder="파일명 검색"> -->
				<li id="SearchOption" mode="off" onclick="search('basic')"><span class="icon16 icon16_search"></span></li>
				<li><span class="icon16 icon16_refresh" onclick="refreshView()"></span></li>
				<li style="float:left;">
					<select class="select" id="idSelect" onchange="onFileTypeChange(this.value)">
						<option value=""><spring:message code='ezWebFolder.t191' /></option>
						<option value="document"><spring:message code='ezWebFolder.t192' /></option>
						<option value="music"><spring:message code='ezWebFolder.t193' /></option>
						<option value="video"><spring:message code='ezWebFolder.t194' /></option>
						<option value="image"><spring:message code='ezWebFolder.t195' /></option>
						<option value="folder"><spring:message code='ezWebFolder.t213' /></option>
						<option value="zip"><spring:message code='ezWebFolder.t196' /></option>
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
	 	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id=""></div>
	    <div style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
	    <div style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarW"></div>
		<div style="width:100%;"id ="tblFileList1_div">
			<div style="margin:0px 0px 0px !important;" >
				<table class="mainlist" style="width:100%"  id="tblFileList1">
					<thead id ="BoardList_THEAD">
						<tr>
							<th class="wfFilecheck " style="text-align: center;" ><input type="checkbox" onchange="rowContext.selectAll(this.checked)" id="_checkAll" style="display:none;"></th>
							<th class="wfFileType 		headListClick" style="text-align: center;" headers="TYPE_ICON"><spring:message code='ezWebFolder.t188'/></th><!-- 유형 -->
							<th class="wfFileName 		headListClick" headers="FILE_NAME"><spring:message code='ezWebFolder.t156'/></th><!-- 이름 -->
							<th class="wfFileSize 		headListClick" style="text-align: center;" headers="FILE_SIZE"><spring:message code='ezWebFolder.t157'/></th><!-- 파일크기 -->
							<th class="wfFileUpdateDate headListClick" headers="UPDATE_DATE"><spring:message code='ezWebFolder.t198'/></th><!-- 갱신일 -->
						</tr>
					</thead>
				</table>
				<div id="dragDropArea"  style="overflow-y:auto;white-space:nowrap;height:295px;">
					<table class="mainlist" style="width: 100%;margin:0px 0px 0px !important; white-space:nowrap;" id="tblFileList">
				
					</table>
				</div>
			</div>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	    <span id="mailBoxInfo"></span>
		<div id="tblPageRayer"></div>
    </div>
	<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
	    <img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
	</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
	</div>
	<div class="btnposition btnpositionNew">
		<a id="btnConfirm" class="imgbtn" onClick="confirm()" ><span><spring:message code='ezWebFolder.t116'/></span></a>
	</div>
	</body>
</html>