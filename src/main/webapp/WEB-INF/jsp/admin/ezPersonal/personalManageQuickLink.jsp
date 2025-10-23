<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style>
			<c:if test="${useJapanese != 'YES'}">.JPN { display: none; }</c:if>
			<c:if test="${useChinese != 'YES'}">.CHN { display: none; }</c:if>
			<c:if test="${useIndonesian != 'YES'}">.IDN { display: none; }</c:if>
		</style>
		<link rel="stylesheet" href="${util.addVer('main.e4', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/default.css')}" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/component.css')}" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezPersonal.h1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/admin/adminManageQuickLink.js')}"></script>
		<script type="text/javascript">
			var xmlhttp = null;
			var userLang = '<c:out value="${lang}"/>';
			var mode;                         //new, modify
			var guid;
			var langs = ["KOR"
							, "ENG"
							<c:if test="${useJapanese == 'YES'}"> , "JPN"</c:if>
							<c:if test="${useChinese == 'YES'}"> , "CHN"</c:if>
							<c:if test="${useIndonesian == 'YES'}"> , "IDN"</c:if>
						];
			
			document.onselectstart = function () {
	        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	            return false;
	        else
	            return true;
			};
			$(document).ready(function() {
				makeList();
			});
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezPersonal.khj1"/>
			<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp"/>
		</h1>
		<!-- 빠른 링크 리스트 영역 -->
		<div class="admin_quicklink">
			<ul id="mainlist"></ul>
			<ul>
				<li class="linkDetails" id="linkLiNew" style="display:none;">
					<div class="admin_quickList" id="linkDetailsNew">
						<dl class="admin_menuDL">
							<dt class="admin_menuTit"><spring:message code="ezPersonal.khj1"/> <spring:message code="ezPersonal.t105"/> ・<spring:message code="ezPersonal.t169"/></dt>
							<dd id="close" class="admin_menuX" onclick="btn_close()"></dd>
						</dl>
						<div class="admin_menu_content">
							<table class="quickTable01" border="0" cellpadding="0" cellspacing="0">
								<tr class="KOR">
									<th class="quickLinkTH"><spring:message code="ezPersonal.t304"/>(<c:out value="${lang_primary }"/>)</th>
									<td class="menuInput"><input type="text" name="Input" id="KOR" class="admin_input" maxlength="50"></td>
								</tr>
								<tr class="ENG">
									<th class="quickLinkTH"><spring:message code="ezPersonal.t304"/>(<c:out value="${lang_secondary }"/>)</th>
									<td class="menuInput"><input type="text" name="Input" id="ENG" class="admin_input" maxlength="50"></td>
								</tr>
								<tr class="JPN">
									<th class="quickLinkTH"><spring:message code="ezPersonal.t304"/>(<c:out value="${lang_tertiary }"/>)</th>
									<td class="menuInput"><input type="text" name="Input" id="JPN" class="admin_input" maxlength="50"></td>
								</tr>
								<tr class="CHN">
									<th class="quickLinkTH"><spring:message code="ezPersonal.t304"/>(<c:out value="${lang_quaternary }"/>)</th>
									<td class="menuInput"><input type="text" name="Input" id="CHN" class="admin_input" maxlength="50"></td>
								</tr>
								<tr class="IDN">
									<th class="quickLinkTH"><spring:message code="ezPersonal.t304"/>(<c:out value="${lang_Senary }"/>)</th>
									<td class="menuInput"><input type="text" name="Input" id="IDN" class="admin_input" maxlength="50"></td>
								</tr>
								<tr>
									<th class='quickLinkTH'>URL <span class='Ared'>*</span></th>
									<td class='menuInput'><input type='text' id='txtURL' class='admin_input' maxlength='512'></td>
								</tr>
								<tr>
									<th class="quickLinkTH"><spring:message code="ezNewportal.openType"/></th>
									<td class="menuInput">
										<select class="admin_select" id="popSize" onchange="popChange();">
											<option value="chk_Full">FULL</option>
											<option value="chk_Size">SIZE</option>
										</select>
									</td>
								</tr>
								<tr>
									<th class="quickLinkTH"><spring:message code="ezPersonal.t262"/></th>
									<td class="menuInput">
										<span id="div_Size">Width <input type="text" id="txt_Width" class="popInput" style="width:50px;" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" disabled> Height <input type="text" id="txt_Height" class="popInput" style="width:50px;" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" disabled></span>
									</td>
								</tr>
							</table>
							<table class="quickTable02" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<th class="quickLinkTH02"><spring:message code = "ezPersonal.t1023" /> Type <span class="Ared">*</span><span style="font-size: 12px; font-weight: normal;"> <spring:message code = "ezPersonal.imgSize" /></span><span class="adminPlusBtn" onclick="CreateType()"><img src="/images/admin/adminPlus.png"></span></th>
								</tr>
								<tr>
									<td class="quickTD">
										<div>
											<c:set var="codes" value="A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P" />
											<c:forEach var="code" items="${fn:split(codes, ',')}" varStatus="var">
												<dl class="quickIcon_link">
													<dt class="quickIcon_linkDT">
														<img src="/images/admin/photo${var.index + 1}.png" id="${code}" />
													</dt>
													<dd class="quickIcon_linkDD">
														<input name="linktypeOption" type="radio" value="${code}" <c:if test="${code == 'A'}">checked</c:if> />
													</dd>
												</dl>
											</c:forEach>
											<dl class="quickIcon_link" id="typeLink" style="display: none;">
												<dt id="typeImg" class="quickIcon_linkDT"></dt>
												<dd class="quickIcon_linkDD">
													<input name="linktypeOption" type="radio" value="Z" id="Z">
												</dd>
											</dl>
										</div>
									</td>
								</tr>
							</table>
							<table class="quickTable02" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<th class="quickLinkTH02"><spring:message code = "ezPersonal.t1019" /><span class="adminPlusBtn" onclick="regit()"><img src="/images/admin/adminPlus.png"></span></th>
								</tr>
								<tr>
									<td class="quickTD">
										<div class="listview" id="AccessList" style="border:0px;"></div>
									</td>
								</tr>
							</table>
							<div class='bottomBtn'>
								<a class='btnA'><span id='btn_OK' onclick="SaveQuickLink()"><spring:message code="ezPersonal.t34"/></span></a>
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>	
		<input type="hidden" id="quickUserLang" value="<c:out value='${userLang}'/>">
		<input type="hidden" id="quickUserPrimanry" value="<c:out value='${userPrimanryLang}'/>">
		<!-- 빠른 링크 추가 영역 -->
		<xml id="listviewheader" style="display: none;"></xml>
		<iframe name="ifrm" src="about:blank" style="display: none;"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/admin/ezPersonal/typeImageUpload.do?guid=" target="ifrm" style ="display:none">
			<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" accept=".jpg, .gif, .png" />
			<input type="hidden" name="boardid" id="boardid" />
			<input type="hidden" name="maxsize" id="maxsize" />
			<input type="hidden" name="mode" id="mode" value="PHOTO"/>
			<input type="hidden" name="cnt" id="cnt" />
			<input type="hidden" name="guid" id="guid"  />
			<input type="hidden" name="mailgubun" id="mailgubun" />
		</form>
	</body>
</html>