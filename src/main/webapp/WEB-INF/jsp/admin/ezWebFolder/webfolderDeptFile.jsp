<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezWebFolder.i1', 'msg')}"   type="text/css">
		<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/adminTable.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/adminFile.js')}"></script>
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
				
			});

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
		</script>
	</head>
	<body class="mainbody" onload="init('dept');" onresize="preProcessing();" onkeydown="keyPressPanel(event);">
		<h1>
			<spring:message code='ezWebFolder.t220'/>
			<span id="mailBoxInfo"></span>
		</h1>
		<div id="companySelect" style="margin-left: 5px;">
			<span><b><spring:message code='ezWebFolder.t129'/></b></span>
			<select id="companyList">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</div>
		
		<div id="mainmenu2" style="position: relative; margin-left: 5px;">
			<ul>
				<li id=""><a><span><spring:message code='ezWebFolder.t186'/></span></a></li>
				<c:if test="${level != '0'}">
					<li id="uploadBttn"><a><span><spring:message code='ezWebFolder.t187'/></span></a></li>
				</c:if>
				<li id=""><a><span><spring:message code='ezWebFolder.t117'/></span></a></li>
				<li id=""><a><span><spring:message code='ezWebFolder.t118'/></span></a></li>
				<li id=""><a><span><spring:message code='ezWebFolder.t120'/></span></a></li>
				<li id=""><a><span><spring:message code='ezWebFolder.t123'/></span></a></li>
				<li id=""><a><span><spring:message code='ezWebFolder.t139'/></span></a></li>
				<li id="">
					<select id="fileTypeSelect">
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
			setParameter("<c:out value='${folderId}'/>", "<c:out value='${primary}'/>", "dept", "", "<c:out value='${level}'/>");
		</script>
		
		<div id="searchPanel" class="wfSearchPanel" style="display:none;">
			<div style="margin: 20px;">
				<table class="content wftable">
					<tr>
						<th class="layerHeader" colspan="2"><img src="/images/webfolder/left_webfolder.png" style="vertical-align: middle;padding-bottom:1px" width="16px">&nbsp;<spring:message code='ezWebFolder.t22'/></th>
					</tr>
					<tr>
						<td class="wfSearchTh2" colspan="2"></td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t151'/></th>
						<td class="wfSearchTd"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">&nbsp;~&nbsp;<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"></td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t152'/></th>
						<td class="wfSearchTd"><input id="fileExtVal" type="text" style="height: 23px; width: 200px;"></td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t153'/></th>
						<td class="wfSearchTd"><input id="fileNameVal" type="text" style="height: 23px; width: 200px;"></td>
					</tr>
					<tr>
						<th class="wfSearchTh"><spring:message code='ezWebFolder.t154'/></th>
						<td class="wfSearchTd"><input id="fileCreatorVal" type="text" style="height: 23px; width: 200px;"></td>
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
					<a class="webfolderBttn"><span><spring:message code='ezWebFolder.t112'/></span></a>
				</div>
			</div>
			<span class="wfCloseBttn"></span>
		</div>
		
		<div id="progress-wrp" style="display: none; margin-left: 5px;">
			<div class="progress-bar"></div ><div class="status">0%</div>
		</div>
		
		<div id="dragDropArea" style="margin-left: 5px;">
			<table class="mainlist wftablefile" style="width: 100%; text-algin: center;" id="tblFileList">
				<tr>
					<th width="20px" ><input type="checkbox"></th>
					<th headers="ft" style="text-align: center; width: 20px;"><spring:message code='ezWebFolder.t188'/></th>
					<th headers="fn" style="width: 30%;"><spring:message code='ezWebFolder.t156'/></th>
					<th headers="fs" style="text-align: center; width: 6%;" ><spring:message code='ezWebFolder.t157'/></th>
					<th headers="un" style="width: 7%;"><spring:message code='ezWebFolder.t189'/></th>
					<th headers="cd" style="width: 10%;"><spring:message code='ezWebFolder.t190'/></th>
					<th headers="ud" style="width: 10%;"><spring:message code='ezWebFolder.t198'/></th>
					<th              style="width: 25%;"><spring:message code='ezWebFolder.t199'/></th>
					<th headers="dt" width="70px" style="text-align: center;"><spring:message code='ezWebFolder.t200'/></th>
				</tr>
				
			</table>
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
