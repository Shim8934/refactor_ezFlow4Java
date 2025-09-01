<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript">
	    var mode = "${mode}";
	        $(function() {
	        	if (mode != "mail") {
	        		parent.document.querySelector("iframe[name=right]").src = "/ezPMS/pmsProjectListMain.do";
	        	}
	    
	        	$("#pmsSetting").click(function() {
	        		parent.document.querySelector("iframe[name=right]").src = "/ezPMS/pmsSetting.do";
	        	});
	        	
	        	/* 2023-06-15 황인경 - 디자인 개선 > 프로젝트 관리 > 좌측메뉴 > 트리구조 메뉴 선택 클래스 제어 */
	        	$("#myTask").click(function() {
	        		parent.document.querySelector("iframe[name=right]").src = "/ezPMS/pmsMyTask.do";
	        		$("#projectList").attr("class", "node_normal");
	        		$("#myTask").attr("class", "node_selected");
	        	});
	        	
	        	$("#projectList").click(function() {
	        		parent.document.querySelector("iframe[name=right]").src = "/ezPMS/pmsProjectListMain.do";
	        		$("#projectList").attr("class", "node_selected");
	        		$("#myTask").attr("class", "node_normal");
	        	})
	        });
	    </script>
	</head>
	<%-- 2023-06-15 황인경 - 디자인 개선 > 프로젝트관리 > 좌측메뉴 > style 수정 및 LNB 이미지 삭제, 태그 구조 수정  --%>
	<body class="newLeft">
	    <div id="left"  class="lnb pms_left" style="overflow: auto;">
	    	<div class="left_title" title="ezPMS">
	    		<span><spring:message code='ezPMS.t8' /></span>
	    		<span class="sub_iconLNB tree_leftconfig" title="ezPMS.t144" id="pmsSetting"></span>
	    	</div>
	    	<div class="webfolderListBox mCustomScrollbar _mCS_1" style="overflow: hidden; padding-right: 0px; height: 907px;">
	    		<div id="mCSB_1" class="mCustomScrollBox mCS-dark mCSB_vertical mCSB_inside" tabindex="0" style="max-height: 907px;">
	    			<div id="mCSB_1_container" class="mCSB_container mCS_y_hidden mCS_no_scrollbar_y" style="position:relative; top:0; left:0;" dir="ltr">
					    <ul class="lnbUL" style="background:#F8F9FB">
					    	<li><span class="node_selected" id="projectList" style="width:100%; display:inline-block; font-size: 14px;"><spring:message code='ezPMS.t8' /></span></li>
					    	<li><span class="node_normal" id="myTask" style="width:100%;display:inline-block; font-size: 14px;"><spring:message code='ezPMS.t142' /></span></li>
					    </ul>
					</div>
					<div id="mCSB_1_scrollbar_vertical" class="mCSB_scrollTools mCSB_1_scrollbar mCS-dark mCSB_scrollTools_vertical" style="display: none;">
						<div class="mCSB_draggerContainer">
							<div id="mCSB_1_dragger_vertical" class="mCSB_dragger" style="position: absolute; min-height: 30px; height: 0px; top: 0px;">
								<div class="mCSB_dragger_bar" style="line-height: 30px;"></div>
							</div>
							<div class="mCSB_draggerRail"></div>
						</div>
					</div>
				</div>
			</div>
			<div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="folderPanel" onclick="HiddenFolderMenu();">&nbsp;</div>
		    <div id="folderMenuDiv" style="position:absolute;top:180px;z-index:6000;display:none;">
			    <table cellpadding="2" cellspacing="1" border="0" style="width:130px;" class="popuplist">
				    <tbody>
					    <tr>
					        <td onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor:pointer;"><span onclick="allFile();HiddenFolderMenu();" style="font-size:12px;width:100%;display:inline-block;"><img src="/images/newAttach.gif" align="absmiddle" hspace="5">모든파일보기</span></td>
					    </tr>
			    	</tbody>
			    </table>
			</div>
		    <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:5000;display:none;" id="webFolderLeftPanel">&nbsp;</div>
		    <div id="bnkBlockLeft" class="blockLeft" style="width:100%; height:100%; display: none; z-index: 10;"></div>
	    </div>
<%-- 	<body class="leftbody">
	 	    <div id="left">
	 	    	<div class="left_pims" title="ezPMS"><span><spring:message code='ezPMS.t8' /></span></div> 
	 		    <h2 class="on"><span><spring:message code='ezPMS.t8' /></span></h2> 
	 		    <ul> 
	 		    	<li><span id="projectList" style="width:100%;display:inline-block;"><spring:message code='ezPMS.t8' /></span></li>
	 		    	<li><span id="myTask" style="width:100%;display:inline-block;"><spring:message code='ezPMS.t142' /></span></li>
	 		    </ul>
	 		    <h3><span id="pmsSetting" style="width:100%;display:inline-block;"><spring:message code='ezPMS.t144' /></span></h3>
			</div> --%>
	</body>
</html>