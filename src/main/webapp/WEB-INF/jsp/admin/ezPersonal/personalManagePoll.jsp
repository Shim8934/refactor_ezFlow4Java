<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/admin/adminManagePoll.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezPersonal.h1', 'msg')}"></script>
		<link rel="stylesheet" href="${util.addVer('main.e4', 'msg')}" type="text/css" />
		<script type="text/javascript">
			var totalCount = "";
			var progressPollFlag = "";
			var TotalCount;
			var totalPage = "";
			var BlockSize = 10;
			var pageNum = 1;
			var PageSize = 15;
			var progressPollFlag = "false";
			var progressSDate = "";
			var progressEDate = "";
			var strLang1 = "<spring:message code = 'ezPersonal.t10002' />";
			var strLang2 = "<spring:message code = 'ezPersonal.t10000' />";
			var strLang3 = "<spring:message code = 'ezPersonal.t10001' />";
			var strLang4 = "<spring:message code = 'ezPersonal.t223' />";
			var strLang5 = "<spring:message code = 'ezQuestion.t312' />";
			var blankstr = "<spring:message code = 'main.kms4' />";

			window.onload = function () {
				ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = strLanghyh2;
			}

			document.onselectstart = function () {
				if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
					return false;
				} else {
					return true;
				}
			};

			$(document).ready(function() {
				if (document.getElementById("ListCompany").length == 0) {
					alert("<spring:message code = 'ezPersonal.t106' />");
				}
				else {
					changeCompany();
				}
				getLightPollConfig();
				makelist();
				setFucntion();
				windowResize();
			});

			//2018-08-06 김보미 - 페이지 위치 고정
			$(window).on("resize", function(){
				 windowResize();
			});
		</script>
		<style type="text/css">
			.mainbody {overflow:hidden;}
		</style>
	</head>
	<body class = "mainbody">
		<xml id="listviewheader" style="display: none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<WIDTH>30</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezPersonal.t166' /></NAME>
						<WIDTH>70</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezPersonal.t240' /></NAME>
						<WIDTH></WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezPersonal.t241' /></NAME>
						<WIDTH>150</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezPersonal.t242' /></NAME>
						<WIDTH>150</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezPersonal.hyh5' /></NAME>
						<WIDTH>70</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		
		<form method="post">
			<h1><spring:message code = 'ezPersonal.hyh1' /><span id="mailBoxInfo"></span>
		    	<span class="title_bar"><img src="/images/name_bar.gif"></span>
				<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp"/>
			</h1>
			<div id="mainmenu">
				<ul style="margin-top:15px">	            	
					<li class="important"><span id="add"><spring:message code = 'ezPersonal.hyh2' /></span></li>
					<li><span id="mod"><spring:message code = 'ezPersonal.hyh3' /></span></li>
					<li><span class="icon16 icon16_delete" id="del"></span></li>
					<div class="sub_frameIcon" style="float:right;">	
						<div class="sub_frameIconUL" style="width:100% !important;">
							<p class="frameIconLI"><span class="icon16 btn_noframe" id="PreViewNone" onclick="PreviewRayerChange('NONE')"></span></p>
							<p class="frameIconLI"><span class="icon16 btn_leftframe" id="PreViewleft" onclick="PreviewRayerChange('H')"></span></p>
						</div>
					</div>
				</ul>
			 </div>
			
			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
			
			<div class="mainView" id="mainView" style="float:left">
				<div id="contentlist" style="width:100%; overflow: auto;">
					<table class="mainlist" style="width: 100%;">
						<div id="AccessList" style="border: 0; width: 100%"></div>
					</table>
				</div>
				<div id="tblPageRayer"></div>
			</div>
			<div class="previewH" id="previewH" style="float:right;">
				<span id="PreviewRayerH" style="border:0px solid red; height:100%; overflow:hidden; vertical-align:top;  margin-left:0px;">
					<span id="previewmail_bar_h" class="previewmail_bar_h" style="display: inline-block; border: 1px solid #e5e5e5; border-top:0px !important; border-bottom:0px !important;">
						<p class="hbar_dotted" style="width:5px">
						</p>
					</span>
					<span id="PreContent_RayerH" style="position: absolute; border: 0px solid blue; width:550px;">
						<span style="width: 100%; display: block;">
							<span class="previewmail_info" style="display: block; width: 100%; border-top: 1px solid #e8e8e8; height:83%;">
								<div id="Preview_HeaderH" style="border-bottom: solid 1px #e8e8e8; width: 100%; visibility: hidden;">
									<p class="mail_title" style="margin-left: 0px; color: #333333; font-weight: bold; font-size: 12px; margin: 0px 0px 5px 0px; clear: both; padding: 6px 0px 1px 0px; height: 24px; line-height: 35px;">
										<span class="icon_btn" style="margin-left:8px;"><span onclick="showPollPage();" style="cursor: pointer; padding-right: 5px;">
											<img src="/images/kr/cm/btn_newpopup.gif" alt="" border="0"></span></span><span id="PreH_subject"><span id="PreH_sub_subject" style="position:absolute;margin-top:-6px;width: 430px;display: inline-block;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" class="title_blodtxt"></span></span>
										<span class="mail_date" style="margin-right: 10px; display: inline-block; float:right;margin-top:-7px;"><span id="PreH_date" style="font-weight:normal;"><span id="PreH_sub_date" style="display: none;"></span></span></span>
									</p>
								</div>
							</span>
							<iframe id="ifrmPreViewH" name="ifrmPreViewH" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
						</span>
					</span>
				</span>
			</div>
		</form>
		
		<form name="PrevViewFormH" action="/ezPersonal/pollResult.do" method="get" target="ifrmPreViewH" >
			<input  type="hidden" name="itemSeq" value="">
			<input  type="hidden" name="flag" value="preview">
		</form>
	</body>
</html>