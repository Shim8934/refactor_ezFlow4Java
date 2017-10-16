<%@page contentType="text/html;charset=utf-8" %>
<%@include file = "manager_util.jsp"%>
<%@include file = "./include/session_check.jsp"%>
<%
	String fileRealFolder = "";
	String ContextPath = request.getContextPath();
	String urlPath = rootFolderPath(request.getRequestURI());
	urlPath = urlPath.substring(0, urlPath.indexOf("manage/jsp"));

	ServletContext context = getServletConfig().getServletContext();
	fileRealFolder = context.getRealPath(urlPath);

	//2013.08.26 [2.0.5.23] mwhong tomcat8.0 에서 getRealPath가 null을 리턴하여 수정
	if(fileRealFolder == null && urlPath != null && ContextPath != null){
		fileRealFolder = context.getRealPath(urlPath.substring(ContextPath.length()));
	}

	if (ContextPath != null && !ContextPath.equals("") && !ContextPath.equals("/")){
		File tempFileRealDIR = new File(fileRealFolder);
		if(!tempFileRealDIR.exists()){
			if (urlPath != null && urlPath.indexOf(ContextPath) != -1){
				String rename_image_temp = urlPath.substring(ContextPath.length());
				fileRealFolder = context.getRealPath(rename_image_temp);
			}
		}
	}

	if (fileRealFolder.lastIndexOf(File.separator) != fileRealFolder.length() - 1){
		fileRealFolder = fileRealFolder + File.separator;
	}

	String url = xmlUrl(fileRealFolder);
	Element root = configXMlLoad(url);
	Hashtable settingValue = childValueList(root);

	String encodingStyleValue = "";
	String EncodingValue = "";

	if (settingValue.get("UploadFileNameType") != null){
		String FileNameType = (String)settingValue.get("UploadFileNameType");
	
		if (FileNameType != ""){
			if(FileNameType.indexOf(",")!= -1){
				String FileNameTypeArr[] = FileNameType.split(",");
				encodingStyleValue = FileNameTypeArr[0];
				if(FileNameTypeArr.length > 1) EncodingValue = FileNameTypeArr[1];
			}
			else{
				encodingStyleValue = FileNameType;
			}
		}
	}

	String userAddMenuList = "";
	
	if(settingValue.get("AddMenuCheck").equals("true")){
		if(settingValue.get("AddMenu") != ""){
			List addMenuListValue = (List)settingValue.get("AddMenu");
			for(int i=0; i<addMenuListValue.size(); i++){
				if(userAddMenuList.equals("")) userAddMenuList = (String)addMenuListValue.get(i);
				else userAddMenuList += "|" + (String)addMenuListValue.get(i);
			}
		}
	}
	
	if (settingValue.get("AccessibilityOption") == null  || settingValue.get("AccessibilityOption") == "" ) settingValue.put("AccessibilityOption", "0");
	if (settingValue.get("UploadFileSubDir") == null || settingValue.get("UploadFileSubDir") == "") settingValue.put("UploadFileSubDir", "true");
	
	//CE3 추가된 요소들
	if (settingValue.get("UploadFileExtBlockList") == null|| settingValue.get("UploadFileExtBlockList") == "") settingValue.put("UploadFileExtBlockList", "0|jsp,exe,php");
	if (settingValue.get("UploadImageFileExtBlockList") == null|| settingValue.get("UploadImageFileExtBlockList") == "") settingValue.put("UploadImageFileExtBlockList", "0|gif,jpeg,jpg,png,bmp");
	if (settingValue.get("AttributeBlockList") == null || settingValue.get("AttributeBlockList") == "") settingValue.put("AttributeBlockList", "0|onclick,onerror");
	if (settingValue.get("TagBlockList") == null || settingValue.get("TagBlockList") == "") settingValue.put("TagBlockList", "0|iframe,meta");
	if (settingValue.get("FontColor") == null || settingValue.get("FontColor") == "") settingValue.put("FontColor", "#000000");
	if (settingValue.get("FontSizeList") == null || settingValue.get("FontSizeList") == "") settingValue.put("FontSizeList", "7.5pt,8pt,9pt,10pt,11pt,12pt,14pt,16pt,18pt,20pt,22pt,24pt,26pt,28pt,36pt");
	if (settingValue.get("LineHeightList") == null || settingValue.get("LineHeightList") == "") settingValue.put("LineHeightList", "100%,120%,140%,150%,160%,180%,200%");
	if (settingValue.get("IndentPaddingValue") == null || settingValue.get("IndentPaddingValue") == "") settingValue.put("IndentPaddingValue", "40");
	if (settingValue.get("ImgLineColor") == null || settingValue.get("ImgLineColor") == "") settingValue.put("ImgLineColor", "#000000");
	if (settingValue.get("TableLineColor") == null || settingValue.get("TableLineColor") == "") settingValue.put("TableLineColor", "#000000");
	if (settingValue.get("TableBGColor") == null || settingValue.get("TableBGColor") == "") settingValue.put("TableBGColor", "#FFFFFF");
	
	if (settingValue.get("DefaultFont") == null || settingValue.get("DefaultFont") == "") settingValue.put("DefaultFont", "");
	if (settingValue.get("DefaultFontSize") == null || settingValue.get("DefaultFontSize") == "") settingValue.put("DefaultFontSize", "");
	if (settingValue.get("Placeholder") == null || settingValue.get("Placeholder") == "") settingValue.put("Placeholder", "");

	// BlockList 적용 체크(적용:UploadFileExtBlockListChecked, 목록:UploadFileExtBlockListTextarea)
	String[] UploadFileExtBlockListArr;
	if (settingValue.get("UploadFileExtBlockList") != null && settingValue.get("UploadFileExtBlockList").toString().indexOf("|") != -1) {
		UploadFileExtBlockListArr = settingValue.get("UploadFileExtBlockList").toString().split("\\|");
		settingValue.put("UploadFileExtBlockListChecked", ("0".equals(UploadFileExtBlockListArr[0]) ? "" : " checked=\"checked\" ")) ;
		
		if(UploadFileExtBlockListArr.length > 1){
			settingValue.put("UploadFileExtBlockListTextarea", UploadFileExtBlockListArr[1]);
		}else{
			settingValue.put("UploadFileExtBlockListTextarea", "");
		}
		
	}

	String[] UploadImageFileExtBlockListArr;
	if (settingValue.get("UploadImageFileExtBlockList") != null && settingValue.get("UploadImageFileExtBlockList").toString().indexOf("|") != -1) {
		UploadImageFileExtBlockListArr = settingValue.get("UploadImageFileExtBlockList").toString().split("\\|");
		settingValue.put("UploadImageFileExtBlockListChecked", ("0".equals(UploadImageFileExtBlockListArr[0]) ? "" : " checked=\"checked\" ")) ;
		
		if(UploadImageFileExtBlockListArr.length > 1){
			settingValue.put("UploadImageFileExtBlockListTextarea", UploadImageFileExtBlockListArr[1]);
		}else{
			settingValue.put("UploadImageFileExtBlockListTextarea", "");
		}
		
	}

	String[] AttributeBlockListArr;
	if (settingValue.get("AttributeBlockList") != null && settingValue.get("AttributeBlockList").toString().indexOf("|") != -1) {
		AttributeBlockListArr = settingValue.get("AttributeBlockList").toString().split("\\|");
		settingValue.put("AttributeBlockListChecked", ("0".equals(AttributeBlockListArr[0]) ? "" : " checked=\"checked\" ")) ;
		
		if(AttributeBlockListArr.length > 1){
			settingValue.put("AttributeBlockListTextarea", AttributeBlockListArr[1]);
		}else{
			settingValue.put("AttributeBlockListTextarea", "");
		}	
	}
	
	String[] TagBlockListArr;
	if (settingValue.get("TagBlockList") != null && settingValue.get("TagBlockList").toString().indexOf("|") != -1) {
		TagBlockListArr = settingValue.get("TagBlockList").toString().split("\\|");
		settingValue.put("TagBlockListChecked", ("0".equals(TagBlockListArr[0]) ? "" : " checked=\"checked\" ")) ;
		
		if(TagBlockListArr.length > 1){
			settingValue.put("TagBlockListTextarea", TagBlockListArr[1]);
		}else{
			settingValue.put("TagBlockListTextarea", "");
		}	
	}
	
	//줄바꾸기설정
	settingValue.put("ReturnKeyActionBRChecked", ("false".equals(settingValue.get("ReturnKeyActionBR")) ? "" : " checked=\"checked\" ")) ;

	// 아이콘 비활성화
	/*
	String[] DisableToolbarButtonsArr;
	if (settingValue.get("DisableToolbarButtons") != null && settingValue.get("DisableToolbarButtons").toString().indexOf("|") != -1) {
		DisableToolbarButtonsArr = settingValue.get("DisableToolbarButtons").toString().split("\\|");
		settingValue.put("DisableToolbarButtonsChecked", ("0".equals(DisableToolbarButtonsArr[0]) ? "" : " checked=\"checked\" ")) ;
		
		if(DisableToolbarButtonsArr.length > 1){
			settingValue.put("DisableToolbarButtonsLists", DisableToolbarButtonsArr[1]);
		}
		
	}
*/
	//템플릿 설정//////////////////////////////////////////////////////
	String[] TemplateListArr;
	TemplateListArr = new String[1];
	if (settingValue.get("Template") != null && settingValue.get("Template").toString().indexOf(",") != -1) {
		TemplateListArr = settingValue.get("Template").toString().split(",");
	}else if(settingValue.get("Template") != null) {
		
		TemplateListArr[0] = settingValue.get("Template").toString();
	}
	///////////////////////////////////////////////////////////////////
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<title>Namo CrossEditor : Admin</title>
	<script type="text/javascript">var pe_rZ="pe_Do"; </script>
	<script type="text/javascript" src="../../lib/jquery-1.7.2.min.js"> </script>
	<script type="text/javascript">var ce$=$.noConflict(true); </script>
	<script type="text/javascript" src="../manage_common.js"> </script>
	<script type="text/javascript" language="javascript" src="../../js/namo_cengine.js"> </script>
	<script type="text/javascript" language="javascript" src="../manager.js"> </script>
	<script type="text/javascript" src="../jscolor/jscolor.js"> </script>
	<link type="text/css" rel="stylesheet" href="../../css/namose_general.css" />
	<link type="text/css" rel="stylesheet" href="../css/common.css" />
	<style>.icon{margin:1px 1px 1px 1px;padding:0px;width:18px;height:18px;cursor:pointer;}</style>
</head>

<body>

<%@include file = "../include/top.html"%>

<form method="post" id="adminSetForm" name="adminSetForm" action="manager_proc.jsp" onsubmit="return pe_H();">



<div id="pe_aqR">
	<table class="pe_qy">
		<tr>
			<td class="pe_fM">

				<table id="Info">
					<tr>
						<td style="padding:0 0 0 10px;height:30px;text-align:left">
						<font style="font-size:14pt;color:#3e77c1;font-weight:bold;text-decoration:none;"><span id="pe_Ep"></span></font></td>
						<td id="InfoText"><span id="pe_vg"></span></td>
					</tr>
					<tr>
						<td colspan="2"><img id="pe_yY" src="../images/title_line.jpg" alt="" /></td>
					</tr>
				</table>

				<table class="pe_kh">
					<tr>
						<td class="pe_arK">				
							<ul>
								<li class="pe_jw pe_BB"><input type="button" id="setting_base" value="" style="width:110px;height:28px;" class="pe_rc pe_eD" /></li>
								<li class="pe_jw"><input type="button" id="setting_edit" value="" style="width:110px;height:28px;" class="pe_rc pe_eD" /></li>
								<li class="pe_jw"><input type="button" id="setting_view" value="" style="width:110px;height:28px;" class="pe_rc pe_eD" /></li>
								<li class="pe_jw"><input type="button" id="setting_ab" value="" style="width:110px;height:28px;" class="pe_rc pe_eD" /></li>
							</ul>
						
						</td>
					</tr>
					<tr>
						<td class="pe_iU pe_hn"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_JG"></span></font></td>
					</tr>
				</table>

			</td>
		</tr>
		
		<tr>
			<td class="pe_fM">
				<div id="pe_Jx">
					<table class="pe_oz">
						<tr>
							<td>
								<table class="pe_cO"><tr><td class="pe_ft" colspan="3"></td></tr>
								</table>
							 
								<table class="pe_cO">
								
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Dv"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='WebServerOS' id='WebServerOS' class="inputSelectStyle">
												<option value=''></option>
												<option value='WINDOW' <% if(settingValue.get("WebServerOS").equals("WINDOW")) out.println("selected=\"selected\"");%>>WINDOW</option>
												<option value='LINUX' <% if(settingValue.get("WebServerOS").equals("LINUX"))out.println("selected=\"selected\"");%>>LINUX</option>
												<option value='UNIX' <% if(settingValue.get("WebServerOS").equals("UNIX")) out.println("selected=\"selected\"");%>>UNIX</option>
											</select>
										</td>
									</tr>
									
									<tr>
										<td class = "pe_dR" colspan="3"></td>
									</tr>

									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_EE"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='WebServerInfo' id='WebServerInfo' class="inputSelectStyle">
												<option value=''></option>
												<option value='IIS' <% if(settingValue.get("WebServerInfo").equals("IIS")) out.println("selected=\"selected\"");%>>IIS</option>
												<option value='Apache' <% if(settingValue.get("WebServerInfo").equals("Apache"))out.println("selected=\"selected\"");%>>Apache</option>
												<option value='Tomcat' <% if(settingValue.get("WebServerInfo").equals("Tomcat")) out.println("selected=\"selected\"");%>>Tomcat</option>
												<option value='Resin' <% if(settingValue.get("WebServerInfo").equals("Resin")) out.println("selected=\"selected\"");%>>Resin</option>
												<option value='Jeus' <% if(settingValue.get("WebServerInfo").equals("Jeus")) out.println("selected=\"selected\"");%>>Jeus</option>
												<option value='WebLogic' <% if(settingValue.get("WebServerInfo").equals("WebLogic")) out.println("selected=\"selected\"");%>>WebLogic</option>
												<option value='WebSphere' <% if(settingValue.get("WebServerInfo").equals("WebSphere")) out.println("selected=\"selected\"");%>>WebSphere</option>
												<option value='iPlanet' <% if(settingValue.get("WebServerInfo").equals("iPlanet")) out.println("selected=\"selected\"");%>>iPlanet</option>
											</select>
										</td>
									</tr>
									
									<tr>
										<td class = "pe_dR" colspan="3"></td>
									</tr>
									
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Ei"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='WebLanguage' id='WebLanguage' class="inputSelectStyle">
												<option value=''></option>
												<option value='ASP' <% if(settingValue.get("WebLanguage").equals("ASP")) out.println("selected=\"selected\"");%>>ASP</option>
												<option value='JSP' <% if(settingValue.get("WebLanguage").equals("JSP")) out.println("selected=\"selected\"");%>>JSP</option>
												<option value='PHP' <% if(settingValue.get("WebLanguage").equals("PHP")) out.println("selected=\"selected\"");%>>PHP</option>
												<option value='ASP.NET' <% if(settingValue.get("WebLanguage").equals("ASP.NET")) out.println("selected=\"selected\"");%>>ASP.NET</option>
												<option value='SERVLET' <% if(settingValue.get("WebLanguage").equals("SERVLET")) out.println("selected=\"selected\"");%>>SERVLET</option>
											</select>
										</td>
									</tr>
									
									<tr>
										<td class = "pe_dR" colspan="3"></td>
									</tr>
									
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_zH"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<input type="text" id="ImageSavePath" class="pe_iK" name="ImageSavePath" value="<%=settingValue.get("ImageSavePath")%>" /> ex) http:// www.mysite.com/image
										</td>
									</tr>
									
									<tr>
										<td class = "pe_dR" colspan="3"></td>
									</tr>

									<% if (settingValue.get("UploadFileNameType") != null){ %>
									
									<div id="pe_UO">
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Dz"></span></b></td>
										<td class="pe_dp"></td>
										<td >
											<table class="pe_cO">
												<tr>
													<td class="pe_cf"> &nbsp;&nbsp;
														<input type="radio" name="encodingStyle" id="pe_Gp" value="real" /><span id="pe_Db"></span>
														<input type="hidden" id="UploadFileNameType" name="UploadFileNameType" value="" />
													</td>
												</tr>
												<tr>
													<td class = "pe_dR" colspan="3"></td>
												</tr>
												<tr>
													<td class="pe_cf"> &nbsp;&nbsp;
													<input type="radio" name="encodingStyle" id="pe_LE" value="trans" /><span id="pe_Da"></span>
													</td>
												</tr>
												<tr>
													<td class = "pe_dR" colspan="3"></td>
												</tr>
												<tr>
													<td class="pe_cf"> &nbsp;&nbsp;
														<input type="radio" name="encodingStyle" id="pe_Lp" value="random" /><span id="pe_JI"></span>
													</td>
												</tr>
											</table>
										</td>
									</tr>

									<tr>
										<td class = "pe_dR" colspan="3"></td>
									</tr>
									</div>

									<% } %>

									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_HD"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf"> &nbsp;
											<input type="hidden" id="UploadFileSubDir" name ="UploadFileSubDir" value="<%=settingValue.get("UploadFileSubDir")%>" />
											<input type="radio" id="pe_AQ" name="pe_Mi" value="true" /><label for="pe_AQ"><span id="pe_HL"></span></label>&nbsp;&nbsp;
											<input type="radio" id="pe_zg" name="pe_Mi" value="false" /><label for="pe_zg"><span id="pe_Ib"></span></label>
										</td>
									</tr>

									<tr>
										<td class = "pe_dR" colspan="3"></td>
									</tr>

									
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_AJ"></span></b></td>
										<td class="pe_dp"></td>
										<td >
											<table class="pe_cO">
												<tr>
													<td >&nbsp;&nbsp;<span id="pe_zn"></span></td>
													<td class="pe_dp"></td>
													<td class="pe_cf"><input type="text" id="Width" name="Width" class="pe_kB" maxlength="10" value="<%=settingValue.get("Width")%>" />
													px</td>
												</tr>
												<tr>
													<td class = "pe_dR" colspan="3"></td>
												</tr>
												<tr>
													<td >&nbsp;&nbsp;<span id="pe_AG"></span></td>
													<td class="pe_dp"></td>
													<td class="pe_cf"><input type="text" id="Height" name="Height" class="pe_kB" maxlength="10" value="<%=settingValue.get("Height")%>" /> px
													</td>
												</tr>	
											</table>
										</td>
									</tr>
								</table>

								<table class="pe_cO"><tr><td class="pe_ft" colspan="3"></td></tr>
								</table>
											
							</td>
						</tr>
						<tr>
							<td class="pe_iU pe_hn"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_EU"></span></font></td>
						</tr>

						<tr>
							<td>
						
								<table class="pe_cO"><tr><td class="pe_ft" colspan="3"></td></tr>
								</table>

								<table class="pe_cO">
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_GK"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='SetFocus' id='SetFocus' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("SetFocus").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("SetFocus").equals("false")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_It"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='LineHeight' id='LineHeight' class="inputSelectStyle">
												<option value=''></option>
												<option value='100%' <% if(settingValue.get("LineHeight").equals("100%")) out.println("selected=\"selected\"");%>>100%</option>
												<option value='120%' <% if(settingValue.get("LineHeight").equals("120%")) out.println("selected=\"selected\"");%>>120%</option>
												<option value='140%' <% if(settingValue.get("LineHeight").equals("140%")) out.println("selected=\"selected\"");%>>140%</option>
												<option value='160%' <% if(settingValue.get("LineHeight").equals("160%")) out.println("selected=\"selected\"");%>>160%</option>
												<option value='180%' <% if(settingValue.get("LineHeight").equals("180%")) out.println("selected=\"selected\"");%>>180%</option>	
												<option value='200%' <% if(settingValue.get("LineHeight").equals("200%")) out.println("selected=\"selected\"");%>>200%</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_GO"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='UnloadWarning' id='UnloadWarning' class="inputSelectStyle">
												<option value='false' <% if(settingValue.get("UnloadWarning").equals("false")) out.println("selected=\"selected\"");%>>false</option>
												<option value='true' <% if(settingValue.get("UnloadWarning").equals("true")) out.println("selected=\"selected\"");%>>true</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_HS"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='SetDebug' id='SetDebug' class="inputSelectStyle">
												<option value='false' <% if(settingValue.get("SetDebug").equals("false")) out.println("selected=\"selected\"");%>>false</option>
												<option value='true' <% if(settingValue.get("SetDebug").equals("true")) out.println("selected=\"selected\"");%>>true</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Jp"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='HTMLTabByTableLock' id='HTMLTabByTableLock' class="inputSelectStyle">
												<option value='false' <% if(settingValue.get("HTMLTabByTableLock").equals("false")) out.println("selected=\"selected\"");%>>false</option>
												<option value='true' <% if(settingValue.get("HTMLTabByTableLock").equals("true")) out.println("selected=\"selected\"");%>>true</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Jz"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='HTMLTabContents' id='HTMLTabContents' class="inputSelectStyle">
												<option value='html' <% if(settingValue.get("HTMLTabContents").equals("html")) out.println("selected=\"selected\"");%>>html</option>
												<option value='body' <% if(settingValue.get("HTMLTabContents").equals("body")) out.println("selected=\"selected\"");%>>body</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_He"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='AllowContentScript' id='AllowContentScript' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("AllowContentScript").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("AllowContentScript").equals("false")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Ig"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='AllowContentIframe' id='AllowContentIframe' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("AllowContentIframe").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("AllowContentIframe").equals("false")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Iz"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='CharSet' id='CharSet' class="inputSelectStyle">
												<option value=''></option>
												<option value='auto' <% if(settingValue.get("CharSet").equals("auto")) out.println("selected=\"selected\"");%>></option>
												<option value='utf-8' <% if(settingValue.get("CharSet").equals("utf-8")) out.println("selected=\"selected\"");%>>utf-8</option>
												<option value='euc-kr' <% if(settingValue.get("CharSet").equals("euc-kr")) out.println("selected=\"selected\"");%>>euc-kr</option>
												<option value='ks_c_5601-1987' <% if(settingValue.get("CharSet").equals("ks_c_5601-1987")) out.println("selected=\"selected\"");%>>ks_c_5601-1987</option>
												<option value='ms949' <% if(settingValue.get("CharSet").equals("ms949")) out.println("selected=\"selected\"");%>>ms949</option>
												<option value='iso-8859-1' <% if(settingValue.get("CharSet").equals("iso-8859-1")) out.println("selected=\"selected\"");%>>iso-8859-1</option>
												<option value='iso-8859-2' <% if(settingValue.get("CharSet").equals("iso-8859-2")) out.println("selected=\"selected\"");%>>iso-8859-2</option>
												<option value='euc-jp' <% if(settingValue.get("CharSet").equals("euc-jp")) out.println("selected=\"selected\"");%>>euc-jp</option>
												<option value='shift_jis' <% if(settingValue.get("CharSet").equals("shift_jis")) out.println("selected=\"selected\"");%>>shift_jis</option>
												<option value='gb2312' <% if(settingValue.get("CharSet").equals("gb2312")) out.println("selected=\"selected\"");%>>gb2312</option>
												<option value='gbk' <% if(settingValue.get("CharSet").equals("gbk")) out.println("selected=\"selected\"");%>>gbk</option>
												<option value='big5' <% if(settingValue.get("CharSet").equals("big5")) out.println("selected=\"selected\"");%>>big5</option>
												<option value='big5-hkscs' <% if(settingValue.get("CharSet").equals("big5-hkscs")) out.println("selected=\"selected\"");%>>big5-hkscs</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_BA"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<input type="text" id="DocBaseURL" name="DocBaseURL" class="pe_iK" value="<%=settingValue.get("DocBaseURL")%>" /> ex) http://www.mysite.com/doc.html 
										</td>
									</tr>
									
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>

									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_PN"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='ResizeBar' id='ResizeBar' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("ResizeBar").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("ResizeBar").equals("false")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>


									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Qn"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='Menu' id='Menu' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("Menu").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("Menu").equals("false")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_IJ"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='QuickMenu' id='QuickMenu' class="inputSelectStyle">
												<option value='true' <% if(settingValue.get("QuickMenu").equals("true")) out.println("selected=\"selected\"");%>>true</option>
												<option value='false' <% if(settingValue.get("QuickMenu").equals("false")) out.println("selected=\"selected\"");%>>false</option>
											</select>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>


									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_yQ"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='pe_uk' id='pe_uk' class="inputSelectStyle">
												<option value='' <% if(settingValue.get("ServerUrl").equals("")) out.println("selected=\"selected\"");%>></option>
												<option value='1' <% if(settingValue.get("ServerUrl").equals("1")) out.println("selected=\"selected\"");%>>domain</option>
												<option value='2' <% if(settingValue.get("ServerUrl").equals("2")) out.println("selected=\"selected\"");%>>absolute</option>
											</select>
										</td>
									</tr>
								
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									
								</table>

								
							
							</td>
						</tr> 						
						<tr>
							<td class="pe_iU pe_hn"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_HH"></span></font></td>
						</tr>

						<tr>
							<td>
								<table class="pe_cO"><tr><td class="pe_ft" colspan="3"></td></tr>
								</table>
								
								<table class="pe_cO">

									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_wj"><span id="pe_xR"></span></b></td>
										<td class="pe_dp"></td>
										<td>
											<table class="pe_cO">
												<input type="hidden" name="UploadImageFileExtBlockList" value="<%=settingValue.get("UploadImageFileExtBlockList")%>" />
												<tr>
													<td class="pe_cf"><input type="checkbox" id="UploadImageFileExtBlockListChecked" <%=settingValue.get("UploadImageFileExtBlockListChecked")%>/><span id="pe_mz"></span></td>
												</tr>
												<tr>
													<td class="pe_cf"><textarea id="UploadImageFileExtBlockListTextarea" cols="70" rows="2"><%=settingValue.get("UploadImageFileExtBlockListTextarea")%></textarea><br /><span id="pe_zv"></span></td>
												</tr>	
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_wj"></span></b></td>
										<td class="pe_dp"></td>
										<td>
											<table class="pe_cO">
												<input type="hidden" name="UploadFileExtBlockList" value="<%=settingValue.get("UploadFileExtBlockList")%>" />
												<tr>
													<td class="pe_cf"><input type="checkbox" id="UploadFileExtBlockListChecked" <%=settingValue.get("UploadFileExtBlockListChecked")%>/><span id="pe_mz"></span></td>
												</tr>
												<tr>
													<td class="pe_cf"><textarea id="UploadFileExtBlockListTextarea" cols="70" rows="2"><%=settingValue.get("UploadFileExtBlockListTextarea")%></textarea><br /><span id="pe_zv"></span></td>
												</tr>	
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>

									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_GS"></span></b></td>
										<td class="pe_dp"></td>
										<td >
											<table class="pe_cO">
												<input type="hidden" name="AttributeBlockList" value="<%=settingValue.get("AttributeBlockList")%>" />
												<tr>
													<td class="pe_cf"><input type="checkbox" id="AttributeBlockListChecked" <%=settingValue.get("AttributeBlockListChecked")%>/><span id="pe_mz"></span></td>
												</tr>
												<tr>
													<td class="pe_cf"><textarea id="AttributeBlockListTextarea" cols="70" rows="2"><%=settingValue.get("AttributeBlockListTextarea") %></textarea><br /><span id="pe_tt"></span></td>
												</tr>	
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Hw"></span></b></td>
										<td class="pe_dp"></td>
										<td >
											<table class="pe_cO">
												<input type="hidden" name="TagBlockList" value="<%=settingValue.get("TagBlockList")%>" />
												<tr>
													<td class="pe_cf"><input type="checkbox" id="TagBlockListChecked" <%=settingValue.get("TagBlockListChecked")%>/><span id="pe_mz"></span></td>
												</tr>
												<tr>
													<td class="pe_cf"><textarea id="TagBlockListTextarea" cols="70" rows="2"><%=settingValue.get("TagBlockListTextarea") %></textarea><br /><span id="pe_tt"></span></td>
												</tr>	
											</table>
										</td>
									</tr>

									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
								</table>
								
							</td>
						</tr>

												
						

					</tr> 						
						<tr>
							<td class="pe_iU pe_hn"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_IC"></span></font></td>
						</tr>

						<tr>
							<td>
								<table class="pe_cO"><tr><td class="pe_ft" colspan="3"></td></tr>
								</table>
								
								<table class="pe_cO" >
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_GU"></span></b></td>
										<td class="pe_dp"></td>
										<td>
											<table class="pe_cO">
												<input type="hidden" name="Template" id="Template" value="<%=settingValue.get("Template")%>" />
												<tr>
													<td class="pe_cf"><input type="button" id="pe_azT" value="+" onClick="pe_E(this)"/></td>
													<td class="pe_cf">&nbsp;</td>
													<td class="pe_cf">&nbsp;</td>
												</tr>
												<tr style="background-color:#B2EBF4;">
													<td class="pe_cf"><b>Title</b></td>
													<td class="pe_cf"><b>URL</b></td>
													<td class="pe_cf"><b>Encoding</b></td>
												</tr>
						
											<%	
											
											for(int i=0; i<TemplateListArr.length ; i++){
												String templateName;
												String templateUrl;
												String templateEncoding;
												if(TemplateListArr[i] == null || TemplateListArr[i] == ""){
													templateName = "";
													templateUrl = "";
													templateEncoding = "";
												}else{
													templateName = TemplateListArr[i].split("\\|")[0];
													templateUrl = TemplateListArr[i].split("\\|")[1];							
													templateEncoding = TemplateListArr[i].split("\\|")[2];

													%>
														<tr>
															<td><input type="text"  name="pe_NX"  value="<%=templateName %>" style="width:100px"/></td>
															<td><input type="text"  name="pe_Sy"  value="<%=templateUrl %>" style="width:320px"/></td>
															<td><input type="text"  name="pe_SF"  value="<%=templateEncoding %>" style="width:90px"/><input type="button" value="-" onclick="pe_V(this)"/></td>
						
														</tr>
													<% 
												}
												
											
											}
											%>
											</table>
										</td>
									</tr>


									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
								</table>
								
							</td>
						</tr>

						
						
					</table>
				</div>	
				
			</td>
		</tr>	
		
		

		<tr>
			<td class="pe_fM">
				<div id="pe_Li">
					<table class="pe_oz">
						<tr>
							<td>
								<table class="pe_cO"><tr><td class="pe_ft" colspan="3"></td></tr>
								</table>
								
								<table class="pe_cO">
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_GX"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<table>
											<tr>
											<td>
											<input type="text" id="pe_Mq" class="color{hash:true,valueElement:'FontColor',pickerFaceColor:'transparent',pickerFace:3,pickerBorder:0,pickerInsetColor:'black'}" style="width:20px;"></td>
											<td><input id="FontColor" name="FontColor" value="<%=settingValue.get("FontColor") %>"></td>
											<td style="padding-left:0px">
											<ul style="width:140px;">
											<li class="pe_eL">
											<input type="button" class="pe_ec pe_eD" value="default" style="width:80px;height:26px;" onclick="document.getElementById('pe_Mq').color.fromString('#000000');">
											</li>
											</ul></td>
											</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Ke"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
										<textarea name="FontSizeList" id="FontSizeList" cols="70" rows="2"><%=settingValue.get("FontSizeList") %></textarea></td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Iw"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
										<textarea name="LineHeightList" id="LineHeightList" cols="70" rows="2"><%=settingValue.get("LineHeightList") %></textarea>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Iv"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<input type="text" id="IndentPaddingValue" name="IndentPaddingValue" class="inputStyleChange" maxlength="3" value="<%=settingValue.get("IndentPaddingValue") %>" style="width:30px;" /> px 
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<input type="hidden" name="ReturnKeyActionBR">
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_JC"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf"><input type="checkbox" id="ReturnKeyActionBRChecked" <%=settingValue.get("ReturnKeyActionBRChecked")%>/><label for="ReturnKeyActionBR"><span id="pe_JS"></span></label></td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>

									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Nn"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<input type="text" id="DefaultFont" name="DefaultFont" class="inputStyleChange" maxlength="30" value="<%=settingValue.get("DefaultFont") %>" style="width:170px;" /> 
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Nk"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<input type="text" id="DefaultFontSize" name="DefaultFontSize" class="inputStyleChange" maxlength="5" value="<%=settingValue.get("DefaultFontSize") %>" style="width:30px;" />
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Me"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<input type="text" id="Placeholder" name="Placeholder" class="inputStyleChange" maxlength="200" value="<%=settingValue.get("Placeholder") %>" style="width:443px;" /> 
										</td>
									</tr>

									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>


								</table>


								<table class="pe_cO">
									<tr>
										<td class="pe_iU pe_hn"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_xR"></span></font></td>
									</tr>

									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_HV"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<table>
											<tr>
											<td>
											<input type="text" id="pe_PT" class="color{hash:true,valueElement:'ImgLineColor',pickerFaceColor:'transparent',pickerFace:3,pickerBorder:0,pickerInsetColor:'black'}" style="width:20px;"></td>
											<td><input id="ImgLineColor" name="ImgLineColor" value="<%=settingValue.get("ImgLineColor") %>"></td>
											<td style="padding-left:0px">
											<ul style="width:140px;">
											<li class="pe_eL">
											<input type="button" class="pe_ec pe_eD" value="default" style="width:80px;height:26px;" onclick="document.getElementById('pe_PT').color.fromString('#000000');">
											</li>
											</ul></td>
											</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
								</table>



								<table class="pe_cO">				
									<tr>
										<td class="pe_iU pe_hn"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_HJ"></span></font></td>
									</tr>

									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Io"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<table>
											<tr>
											<td>
											<input type="text" id="pe_PG" class="color{hash:true,valueElement:'TableLineColor',pickerFaceColor:'transparent',pickerFace:3,pickerBorder:0,pickerInsetColor:'black'}" style="width:20px;"></td>
											<td><input id="TableLineColor" name="TableLineColor" value="<%=settingValue.get("TableLineColor") %>"></td>
											<td style="padding-left:0px">
											<ul style="width:140px;">
											<li class="pe_eL">
											<input type="button" class="pe_ec pe_eD" value="default" style="width:80px;height:26px;" onclick="document.getElementById('pe_PG').color.fromString('#000000');">
											</li>
											</ul></td>
											</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Ih"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<table>
											<tr>
											<td>
											<input type="text" id="pe_Lj" class="color{hash:true,valueElement:'TableBGColor',pickerFaceColor:'transparent',pickerFace:3,pickerBorder:0,pickerInsetColor:'black'}" style="width:20px;"></td>
											<td><input id="TableBGColor" name="TableBGColor" value="<%=settingValue.get("TableBGColor") %>"></td>
											<td style="padding-left:0px">
											<ul style="width:140px;">
											<li class="pe_eL">
											<input type="button" class="pe_ec pe_eD" value="default" style="width:80px;height:26px;" onclick="document.getElementById('pe_Lj').color.fromString('#FFFFFF');">
											</li>
											</ul></td>
											</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
								</table>

	
											
							</td>
						</tr>
					</table>
				</div>	
			</td>
		</tr>

		
		
		<tr>
			<td class="pe_fM">
				<div id="pe_LO">
					<table class="pe_oz">
						<tr>
							<td>
								<table class="pe_cO"><tr><td class="pe_ft" colspan="3"></td></tr>
								</table>
								 
								<table class="pe_cO">
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_HG"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<% out.println(skinDirectory(fileRealFolder, (String)settingValue.get("Skin"))); %>
										</td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_MR"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<% out.println(iconColorSelect((String)settingValue.get("IconColor"))); %>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Bm"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<input type="text" id="Css" name="Css" class="pe_iK" value="<%=settingValue.get("Css")%>" />  ex) http://www.mysite.com/common.css 
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Jt"></span></b>
											<input type="hidden" id="UserSkinColor" name="UserSkinColor" value="<%=settingValue.get("UserSkinColor")%>" />
										</td>
											
										<td class="pe_dp"></td>
										<td >
											<table class="pe_cO">
												<tr>
													<td class="pe_pI">&nbsp;&nbsp;<span id="pe_Ha"></span></td>
													<td class="pe_dp"></td>
													<td class="pe_cf">
														<input type="text" id="outlinecolor" name="outlinecolor" class="pe_pC" value="" />  ex) #000000 or black 
													</td>
												</tr>
												<tr>
													<td class="pe_dR" colspan="3"></td>
												</tr>
												
												<tr>
													<td class="pe_pI">&nbsp;&nbsp;<span id="pe_Ho"></span></td>
													<td class="pe_dp"></td>
													<td class="pe_cf">
														<input type="text" id="innerlineColor" name="innerlineColor" class="pe_pC" value="" />
													</td>
												</tr>
												<tr>
													<td class="pe_dR" colspan="3"></td>
												</tr>
												<tr>
													<td class="pe_pI">&nbsp;&nbsp;<span id="pe_Hq"></span></td>
													<td class="pe_dp"></td>
													<td class="pe_cf">
														<input type="text" id="skinfontColor" name="skinfontColor" class="pe_pC" value="" />
													</td>
												</tr>
												<tr>
													<td class="pe_dR" colspan="3"></td>
												</tr>
												<tr>
													<td class="pe_pI">&nbsp;&nbsp;<span id="pe_ER"></span></td>
													<td class="pe_dp"></td>
													<td class="pe_cf">
														<input type="text" id="toolbarBackgroundColor" name="toolbarBackgroundColor" class="pe_pC" value="" />
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Hx"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<input type="hidden" id="CreateTab" name ="CreateTab" value="<%=settingValue.get("CreateTab")%>" />
											<input type="checkbox" id="pe_yM" name="pe_qs" value="0" /><label for="pe_yM"><span id="wysiwyg"></span></label>&nbsp;&nbsp;
											<input type="checkbox" id="pe_vR" name="pe_qs" value="1" /><label for="pe_vR"><span id="html"></span></label>&nbsp;&nbsp;
											<input type="checkbox" id="pe_yR" name="pe_qs" value="2" /><label for="pe_yR"><span id="preview"></span></label>
										</td>
									</tr>
								</table>
									
								<table class="pe_cO"><tr><td class="pe_ft" colspan="3"></td></tr>
								</table>
							</td>
						</tr>

						<tr>
							<td class="pe_iU pe_hn"><font style="font-size:9pt;color:#FF9F4B;font-weight:bold;"><span id="pe_Fk"></span></font></td>
						</tr>
						<tr>
							<td>
								<table class="pe_cO"><tr><td class="pe_ft" colspan="3"></td></tr>
								</table>
									
								<table class="pe_cO">
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Ja"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<select name='UserToolbar' id='UserToolbar' class="inputSelectStyle">
												<option value='false' <% if(settingValue.get("UserToolbar").equals("false")) out.println("selected=\"selected\"");%>>false</option>
												<option value='true' <% if(settingValue.get("UserToolbar").equals("true")) out.println("selected=\"selected\"");%>>true</option>
											</select>
											<input type="hidden" id="CreateToolbar" name="CreateToolbar" value="<%=settingValue.get("CreateToolbar")%>" >
											<input type="hidden" id="Name" name="Name" value="<%=settingValue.get("Name")%>">
											<input type="hidden" id="Logo" name="Logo" value="<%=settingValue.get("Logo")%>">
											<input type="hidden" id="Help" name="Help" value="<%=settingValue.get("Help")%>">
											<input type="hidden" id="Info" name="Info" value="<%=settingValue.get("Info")%>">
											<input type="hidden" id="UserAddMenu" name="UserAddMenu" value="<%=userAddMenuList%>" />
											<input type="hidden" id="AddMenuCheck" name="AddMenuCheck" value="<%=settingValue.get("AddMenuCheck")%>" />
											<input type="hidden" id="Tab" name="Tab" value="" />

											<input type="hidden" id="UploadFileViewer" name="UploadFileViewer" value="<%=settingValue.get("UploadFileViewer")%>" />
											<input type="hidden" id="UploadFileSizeLimit" name="UploadFileSizeLimit" value="<%=settingValue.get("UploadFileSizeLimit")%>" />
											<input type="hidden" id="ProfanityStr" name="ProfanityStr" value="<%=settingValue.get("ProfanityStr")%>" />
											<input type="hidden" id="Csslist" name="Csslist" value="<%=settingValue.get("Csslist")%>" />
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
										
								</table>	
							</td>		
						</tr>			
					</table>

					<div id="pe_EW">
						<table class="pe_kh">
							<tr>
								<td>
									<table class="pe_cO">
										<tr>
											<td class="pe_dR" colspan="5"></td>
										</tr>
										<tr>
											<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_GY"></span></b></td>
											<td class="pe_dp"></td>
											<td>
												<table class="pe_cO">
													<tr>
														<td class="pe_qt" >&nbsp;&nbsp;<span id="pe_Kn"></span></td>
														<td class="pe_dp"></td>
														<td class="pe_cf">
															<input type="text" id="AdminPageUserMenuIdInput" name="AdminPageUserMenuIdInput" class="pe_iK" value="" /> 
														</td>
													</tr>
													<tr>
														<td class="pe_dR" colspan="3"></td>
													</tr>
													<tr>
														<td class="pe_qt">&nbsp;&nbsp;<span id="pe_Kg"></span></td>
														<td class="pe_dp"></td>
														<td class="pe_cf">
															<input type="radio" name="AdminPageUserMenuPlayKindRadio" id="pe_BR" value="function" /><label for="pe_BR"><span id="pe_Hr"></span></label>&nbsp;&nbsp;<input type="radio" name="AdminPageUserMenuPlayKindRadio" id="pe_Bv" value="plugin" /><label for="pe_Bv"><span id="pe_Jy"></span></label>
														</td>
													</tr>
													<tr>
														<td class="pe_dR" colspan="3"></td>
													</tr>
													<tr>
														<td class="pe_qt">&nbsp;&nbsp;<span id="pe_Hf"></span></td>
														<td class="pe_dp"></td>
														<td class="pe_cf" height="50px">
															<input type="text" id="AdminPageUserMenuButtonImgPathInput" name="AdminPageUserMenuButtonImgPathInput" class="pe_iK" value="" />
															<br/>ex) http://www.mysite.com/image/MenuIcon.jpg
														</td>
													</tr>
													<tr>
														<td class="pe_dR" colspan="3"></td>
													</tr>
													<tr>
														<td class="pe_qt">&nbsp;&nbsp;<span id="pe_Jf"></span></td>
														<td class="pe_dp"></td>
														<td class="pe_cf">	
															<input type="text" id="AdminPageUserMenuTitleInput" name="AdminPageUserMenuTitleInput" class="pe_iK" value="" />
														</td>
													</tr>
												</table>
											</td>
											<td class="pe_dp"></td>
											<td style="text-align:center;vertical-align:middle;"><input type="button" id="pe_yh" value="" class="" style="width:60px;height:60px;"/>
											</td>
										</tr>
										<tr>
											<td class="pe_dR" colspan="5"></td>
										</tr>
										<tr>
											<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Kq"></span></b></td>
											<td class="pe_dp"></td>
											<td class="pe_cf" colspan="2">
												<div id="pe_akJ">&nbsp;</div>
											</td>
										</tr>
										<tr>
											<td class="pe_dR" colspan="5"></td>
										</tr>
									</table>	
								</td>		
							</tr>
						</table>
					</div>
		
					<div id = "pe_cO">
						
						<table class="pe_kh">	
							<tr>
								<td id="pe_Kw" class="pe_hn">
									
									<table>
										<tr>
											<td id="pe_ash">
												<span id="pe_Is"></span>: <br>
												<div id="pe_Tv" >
													<span id="pe_vx"></span> <br> 
													<span id="pe_CZ"></span><br>
													<span id="pe_vO"></span><br>
												</div>
											</td>
											<td id="pe_alG">
											<span id="pe_Ie"></span>:<br>
												<div id="pe_Qo" ></div>
											</td> 
											<td valign="bottom">
												<ul style="margin:0 auto;width:340px;">
													<li class="pe_eL">
														<input type="button" id="spacebar" value="" class="pe_ec pe_eD" style="width:80px;height:26px;" />
													</li>
													<li class="pe_eL"><input type="button" id="space" value="" class="pe_ec pe_eD" style="width:68px;height:26px;"></li>
													<li class="pe_eL"><input type="button" id="enter" value="" class="pe_ec pe_eD" style="width:66px;height:26px;"></li>
												</ul>
											</td>
										</tr>
										<tr>
											<td colspan="3">
												<br />
												<span id="pe_Iy"></span>
											</td>
										</tr>	
									</table>							
								</td>
							</tr>
							<tr>
								<td>
									<table class="pe_cO">
										<tr><td class="pe_ft" colspan="3"></td></tr>
									</table>
								</td>
							</tr>
						</table>	
				
						<table id="pe_fR" class="pe_kh">
							
							<tr>
								<td id="pe_Kw" class="pe_hn">
									<span id="preview"></span>:<br>
									<div id="pe_Us"></div>
									<br />
									<span id="pe_Hy"></span>
								</td>
							</tr>
						</table>
						
					
					
					

					</div>
				</div>	

			</td>
		</tr>
		<tr>
			<td class="pe_fM">
				<div id="pe_Ks">
					<table class="pe_oz">
						<tr>
							<td>
								<table class="pe_cO"><tr><td class="pe_ft" colspan="3"></td></tr>
								</table>
								 
								<table class="pe_cO">
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_Ff"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<input type="text" id="DocTitle" name="DocTitle" class="pe_iK" value="<%=settingValue.get("DocTitle")%>" />
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
									<tr>
										<td class="pe_cV">&nbsp;&nbsp;&nbsp;&nbsp;<b><span id="pe_GW"></span></b></td>
										<td class="pe_dp"></td>
										<td class="pe_cf">
											<input type="hidden" id="AccessibilityOption" name ="AccessibilityOption" value="<%=settingValue.get("AccessibilityOption")%>" />
											<input type="radio" id="pe_CJ" name="pe_vE" value="0" /><label for="pe_CJ"><span id="pe_HC"></span></label>&nbsp;&nbsp;
											<input type="radio" id="pe_BL" name="pe_vE" value="1" /><label for="pe_BL"><span id="pe_Hp"></span></label>&nbsp;&nbsp;
											<input type="radio" id="pe_zk" name="pe_vE" value="2" /><label for="pe_zk"><span id="pe_Ix"></span></label>
										</td>
									</tr>
									<tr>
										<td class="pe_dR" colspan="3"></td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
</table>

<table class="pe_qy">
	<tr id="pe_GJ">
		<td id="pe_Gf">
			<ul style="margin:0 auto;width:170px;">
				<li class="pe_eL">
					<input type="submit" id="pe_Bg" value="" class="pe_ec pe_eD" style="width:66px;height:26px;" />
				</li>
				<li class="pe_eL"><input type="button" id="pe_tE" value="" class="pe_ec pe_eD" style="width:66px;height:26px;"></li>
			</ul>
		</td>
	</tr>
</table>
	
</div>


<input type="hidden" id="DisplayLoadingBar" name="DisplayLoadingBar" value="<%=settingValue.get("DisplayLoadingBar")%>" />
<input type="hidden" id="CanvasWidth" name="CanvasWidth" value="<%=settingValue.get("CanvasWidth")%>" />
<input type="hidden" id="CanvasHeight" name="CanvasHeight" value="<%=settingValue.get("CanvasHeight")%>" />

</form>
<%@include file = "../include/bottom.html"%>
<script>var webPageKind='<%=detectXSSEx(session.getAttribute("webPageKind").toString())%>';var encodingStyleChecked='<%=encodingStyleValue%>';topInit();managerInit('<% if(detectXSSEx(request.getParameter("Tab")) != null) out.print(detectXSSEx(request.getParameter("Tab")));%>'); </script>

</body> 
</html>