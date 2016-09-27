<%@page import="org.jasypt.commons.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPortal.t110'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezPortal/string_component.js"></script>
		<script type="text/javascript">
		var imageWidth = "${imageWidth}";
		var imageHeight = "${imageHeight}";
		var g_xmlhttp = createXMLHttpRequest();
		var g_xmlhttp2 = createXMLHttpRequest();
		var uid = "${uID}";
		var imguid = "${imageUID}";
		var g_Dirty = false;
		var pageid = "${pageID}";
		var pmode = "${mode}";
		var parentuid = "${parentUID}";
		var pSkin = "1";   // 기본설정에선 모두 스킨1만 설정
		var g_bSaved = false;
		var menuindex = "${menuIndex}";
		var pNoneActiveX = "${noneActiveX}";
		
		window.onload = function() {
			toggle_menu(menuindex);
		}
		
	    window.onbeforeunload = function() {
			if (g_bSaved == true)
			{
				try{
					window.opener.location.reload();
				} catch(e) {}
			}
			// 신규이면서 저장하지 않은 경우 저장된 정보 삭제
			else if (pmode == "new" && g_bSaved == false)
			{
				Delete();
			}
		}
		
		// 삭제
		function Delete() {
		    var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/removeMenuItem.do?pageID=" + pageid + "&uID=" + uid + "&parentUID=" + parentuid, false);
			xmlhttp.send();
			xmlhttp = null;
		}
		
		function Save() {
		    var strXML = "<DATA>";

		    if (pmode == "new") {
		        if (txtNormalImage.src.indexOf("/files/upload_portal") == -1 && txtOverImage.src.indexOf("/files/upload_porta") > -1) {
		            alert("<spring:message code='ezPortal.t10000'/>");
		            return;
		        }
		    }

			var normalImgPath = txtNormalImage.src.substr(txtNormalImage.src.indexOf("/files/upload_portal"));
			var overImgPath = txtOverImage.src.substr(txtOverImage.src.indexOf("/files/upload_portal"));
alert(normalImgPath);
			if (normalImgPath.indexOf("/files/upload_portal") == -1) normalImgPath = "";
			if (overImgPath.indexOf("/files/upload_portal") == -1) overImgPath = "";
			
			strXML += "<DISPLAYNAME>" + ReplaceValidString(txtDisplayName.value) + "</DISPLAYNAME>";
			strXML += "<DISPLAYNAME2>" + ReplaceValidString(txtDisplayName2.value) + "</DISPLAYNAME2>";
			strXML += "<NORMALIMAGE>" + normalImgPath + "</NORMALIMAGE>";
			strXML += "<OVERIMAGE>" + overImgPath + "</OVERIMAGE>";
			//if (CrossYN()) {
			    if (imageWidth == "") {
			        strXML += "<IMAGEWIDTH>" + document.getElementById("txtNormalImage").width + "</IMAGEWIDTH>";
			        strXML += "<IMAGEHEIGHT>" + document.getElementById("txtNormalImage").height + "</IMAGEHEIGHT>";
			    }
			    else if (imageWidth != document.getElementById("txtNormalImage").width) {
			        strXML += "<IMAGEWIDTH>" + document.getElementById("txtNormalImage").width + "</IMAGEWIDTH>";
			        strXML += "<IMAGEHEIGHT>" + document.getElementById("txtNormalImage").height + "</IMAGEHEIGHT>";
			    }
			    else {
			        strXML += "<IMAGEWIDTH>" + imageWidth + "</IMAGEWIDTH>";
			        strXML += "<IMAGEHEIGHT>" + imageHeight + "</IMAGEHEIGHT>";
			    }
			/*}
			else {
			    strXML += "<IMAGEWIDTH>" + imageWidth + "</IMAGEWIDTH>";
			    strXML += "<IMAGEHEIGHT>" + imageHeight + "</IMAGEHEIGHT>";
			}*/
			    
			strXML += "<LINKURL>" + ReplaceValidString(txtLinkURL.value) + "</LINKURL>";
			strXML += "<LINKLOCATION>" + ReplaceValidString(txtLinkLocation.value) + "</LINKLOCATION>";
			strXML += "<UID>" + uid + "</UID>";
			strXML += "<IMGUID>" + imguid + "</IMGUID>";
			strXML += "<WINDOWOPTION>" + ReplaceValidString(txtWindowOption.value) + "</WINDOWOPTION>";
			strXML += "<SKIN>" + pSkin + "</SKIN>";
			strXML += "</DATA>";

			var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/saveMenuItem.do?pageID=" + pageid, false);
			xmlhttp.send(strXML);
			xmlhttp = null;
			
			alert("<spring:message code='ezPortal.t84'/>");
			g_bSaved = true;
			
			location.href = "/admin/ezPortal/menuItemEdit.do?pageID=" + pageid + "&mode=edit&uID=" + uid + "&menuIndex=1";
		}
	    
		function removeNormalImage() {
			txtNormalImage.style.display = "none";
			txtNormalImage.src = "";			
			g_Dirty = true;
		}

		function removeOverImage() {
			txtOverImage.style.display = "none";
			txtOverImage.src = "";			
			g_Dirty = true;
		}
		
		function SubMenus() {
		    window.open("/admin/ezPortal/subMenuItemsEdit.do?uID=" + uid + "&pageID=" + pageid, "", "height = 356px, width = 390px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(390, 356));
		}
		
		function toggle_menu(pIndex) {
			/*
			for (var i=0; i<document.all.tags("table").length; i++)
			{
				if (document.all.tags("table").item(i).id == "" || document.all.tags("table").item(i).id == "undefined") continue;
				if (document.all.tags("table").item(i).id.substr(0, 10) == "toggle_tbl")
				{
					if (document.all.tags("table").item(i).id == "toggle_tbl" + pIndex.toString())
						document.all.tags("table").item(i).style.display = "block";
					else
						document.all.tags("table").item(i).style.display = "none";
				}
			}
			*/
			
			if (pmode == "new" && g_bSaved == false) {
				if (pIndex.toString() != "1") {
					alert("<spring:message code='ezPortal.t83'/>");
					return;
				}
			}
			
			// 이미지 변경
			switch(pIndex.toString()) {
				case "1":
					menu_1.src = "/images/tap_portal01o.gif";
					menu_2.src = "/images/tap_portal02.gif";
					menu_3.src = "/images/tap_portal03.gif";
					saevbtn.style.display = "";
					toggle_tbl1.style.display = "";
					idbr.style.display = "none";
					idbr2.style.display = "none";
					toggle_tbl2_1.style.display = "none";
					toggle_tbl2_2.style.display = "none";
					toggle_tbl2_3.style.display = "none";
					toggle_tbl3_1.style.display = "none";
					toggle_tbl3_2.style.display = "none";
					toggle_tbl3_3.style.display = "none";
					break;
				case "2":
					menu_1.src = "/images/tap_portal01.gif";
					menu_2.src = "/images/tap_portal02o.gif";
					menu_3.src = "/images/tap_portal03.gif";
					saevbtn.style.display = "none";
					idbr.style.display = "";
					idbr2.style.display = "none";
					toggle_tbl1.style.display = "none";
					toggle_tbl2_1.style.display = "";
					toggle_tbl2_2.style.display = "";
					toggle_tbl2_3.style.display = "";
					toggle_tbl3_1.style.display = "none";
					toggle_tbl3_2.style.display = "none";
					toggle_tbl3_3.style.display = "none";
					break;
				case "3":
					menu_1.src = "/images/tap_portal01.gif";
					menu_2.src = "/images/tap_portal02.gif";
					menu_3.src = "/images/tap_portal03o.gif";
					saevbtn.style.display = "none";
					idbr.style.display = "none";
					idbr2.style.display = "";
					toggle_tbl1.style.display = "none";
					toggle_tbl2_1.style.display = "none";
					toggle_tbl2_2.style.display = "none";
					toggle_tbl2_3.style.display = "none";
					toggle_tbl3_1.style.display = "";
					toggle_tbl3_2.style.display = "";
					toggle_tbl3_3.style.display = "";
					break;
			}
		}
		
		function RemoveParameter(pParamName) {
			if(!confirm("<spring:message code='ezPortal.t54'/>")) return;
			
			var tempuid = imguid;
			if (tempuid == "") tempuid = uid;
			
			var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/removeParameter.do?mode=2&uID=" + tempuid + "&paramName=" + pParamName, false);
			xmlhttp.send();
			xmlhttp = null;
			
			g_bSaved = true;
			
			location.href = "/admin/ezPortal/menuItemEdit.do?pageID=" + pageid + "&mode=edit&uID=" + uid + "&menuIndex=2";
		}
		
		function CheckDuplicate(paramname) {
			for (var i=0; i<document.all.tags("input").length; i++)
			{
				if (typeof(document.all.tags("input").item(i).utype) == "undefined") continue;
				if (document.all.tags("input").item(i).value.toLowerCase() == paramname) return true;
			}
			return false;
		}
		
		
		function AddParameter() {
			var paramname = ReplaceValidString(newParamName.value);
			var paramvalue = ReplaceValidString(newParamValue.value);
			var paramtype = ReplaceValidString(SelectParamType.value);
			if (paramname == "") 
			{
				alert("<spring:message code='ezPortal.t111'/>");
				return;
			}
			var tempuid = imguid;
			if (tempuid == "") tempuid = uid;

			var strXML = "<DATA>";
			strXML += "<UID>" + tempuid + "</UID>";
			strXML += "<PARAMNAME>" + paramname + "</PARAMNAME>";
			strXML += "<PARAMVALUE>" + paramvalue + "</PARAMVALUE>";
			strXML += "<PARAMTYPE>" + paramtype + "</PARAMTYPE>";
			strXML += "</DATA>";
			
			var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/addParameter.do?mode=2", false);
			xmlhttp.send(strXML);
			xmlhttp = null;
			
			g_bSaved = true;
			
			location.href = "/admin/ezPortal/menuItemEdit.do?pageID=" + pageid + "&mode=edit&uID=" + uid + "&menuIndex=2";
		}
		
		function AddRight() {
			if (newAccessID.value == "")
			{
				alert("<spring:message code='ezPortal.t85'/>");
				return;
			}
			
			// 1: 불가, 2: 가능
			var editRight = "1";
			var viewRight = "1";
			
			if (document.getElementsByName("SelectEditRight")[1].checked == true)
				editRight = "2";
			
			if (document.getElementsByName("SelectViewRight")[1].checked == true)
				viewRight = "2";
			
			var strXML = "<DATA>";
			strXML += "<UID>" + uid + "</UID>";
			strXML += "<ACCESSID>" + newAccessID.value + "</ACCESSID>";
			// 수정(2007.07.11) : 부서명 & 처리
			strXML += "<ACCESSNAME><![CDATA[" + newAccessName.value + "]]></ACCESSNAME>";			
			strXML += "<EDIT_RIGHT>" + editRight + "</EDIT_RIGHT>";
			strXML += "<VIEW_RIGHT>" + viewRight + "</VIEW_RIGHT>";
			strXML += "</DATA>";
			
			var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/addRight.do", false);
			xmlhttp.send(strXML);
			xmlhttp = null;
			
			g_bSaved = true;
			
			location.href = "/admin/ezPortal/menuItemEdit.do?pageID=" + pageid + "&mode=edit&uID=" + uid + "&menuIndex=3";
		}
	    var selecttarget_dialogArguments = new Array();
		function SelectID() {
		    var config = "status:false;dialogWidth:690px;dialogHeight:630px;scroll:no;status:no;edge:sunken" + GetShowModalPosition(690, 630);
		    if (CrossYN()) {
		        selecttarget_dialogArguments[1] = SelectID_Complete;
		        var OpenWin = window.open("/admin/ezPortal/selectTarget.do", "SelectTarget", GetOpenWindowfeature(690, 630));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    else {
		        var ret = window.showModalDialog("/admin/ezPortal/selectTarget.do", "", config);

		        if (typeof (ret) != "undefined") {
		            newAccessID.value = ret.split(";")[0];
		            newAccessName.value = ret.split(";")[1];
		        }
		    }
		}
		
		function SelectID_Complete(ret) {
		    if (typeof (ret) != "undefined") {
		        newAccessID.value = ret.split(";")[0];
		        newAccessName.value = ret.split(";")[1];
		    }
		}

		function DeleteRight(pAccessID)
		{
			if(!confirm("<spring:message code='ezPortal.t54'/>")) return;
			
			var strXML = "<DATA>";
			strXML += "<UID>" + uid + "</UID>";
			strXML += "<ACCESSID>" + pAccessID + "</ACCESSID>";
			strXML += "</DATA>";
			
			var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/removeACL.do", false);
			xmlhttp.send(strXML);
			xmlhttp = null;
			
			g_bSaved = true;
			
			location.href = "/admin/ezPortal/menuItemEdit.do?pageID=" + pageid + "&mode=edit&uID=" + uid + "&menuIndex=3";
		}
		
		// 지정된 값인 경우에만 작성 가능하도록 설정
		function Param_Change()
		{
			if (SelectParamType.value != "0")
				newParamValue.disabled = true;
			else
				newParamValue.disabled = false;
		}
		var ImageState = "";
		function changeNormalImage() {
		        ImageState = "Normal";
		        document.getElementById('mode').value = "PHOTO";
		        document.form.file1.click();
		}
		function changeNormalImage_end() {
		    if (g_xmlhttp.readyState != 4) return;
		    txtNormalImage.src = g_xmlhttp.responseText;
		    txtNormalImage.style.display = "";
		    g_Dirty = true;
		}

		function changeOverImage() {
		        ImageState = "Over";
		        document.getElementById('mode').value = "PHOTO";
		        document.form.file1.click();
		  
		}
		function changeOverImage_end() {
		    if (g_xmlhttp2.readyState != 4) return;
		    txtOverImage.src = g_xmlhttp2.responseText;
		    txtOverImage.style.display = "";
		    g_Dirty = true;
		}

		function btn_AttachAdd_onclick() {
		    if (document.form.file1.value != "") {
		        if (document.getElementById('mode').value == "PHOTO") {
		            if (document.getElementById("form").file1.files.length < 2) {
		            }
		            else
		                alert("<spring:message code='ezPortal.t414'/>");
		        }
		        document.getElementById("cnt").value = document.getElementById("form").file1.files.length;
		        var frm = document.getElementById('form');
		        frm.action = "/admin/ezPortal/portletImageUpload.do?mode=Menu";
		        frm.submit();
		        document.form.file1.value = "";
		    }

		}
		function returnvalue(strXML) {

		    var xml = loadXMLString(strXML);
		    var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
		    for (i = 0; i < nodes.length; i++) {
		        if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
		            if (getNodeText(GetChildNodes(nodes[i])[3]) == 0) {
		                alert(strLang6);
		                return;
		            }
		            if (document.getElementById('mode').value == "PHOTO") {
		                if (ImageState == "Normal") {
		                    if (navigator.userAgent.indexOf("Firefox") != -1)
		                        txtNormalImage.src = "/files/upload_portal/" + getNodeText(GetChildNodes(nodes[i])[4]);
		                    else
		                        txtNormalImage.src = "/files/upload_portal/" + getNodeText(GetChildNodes(nodes[i])[4]);
		                    txtNormalImage.style.display = "";
		                }
		                else {
		                    if (navigator.userAgent.indexOf("Firefox") != -1)
		                        txtOverImage.src = "/files/upload_portal/" + getNodeText(GetChildNodes(nodes[i])[4]);
		                    else
		                        txtOverImage.src = "/files/upload_portal/" + getNodeText(GetChildNodes(nodes[i])[4]);
		                    txtOverImage.style.display = "";
		                }
		            }
		        }
		        else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
		            alert(strLang8 + AttachLimit + "MB" + strLang9);
		            return;
		        }
		        else {
		            alert(filename + "<spring:message code='ezPortal.t990007'/>" + "\n\n" + result);
		        }
		    }
		}
		</script>
	</head>
	 <body class="popup" style ="overflow:auto">
	<div id="menu">
		<ul>
			<li id ="saevbtn"><span onclick="Save()"><spring:message code='ezPortal.t62'/></span></li>
            <c:if test="${mode == 'edit'}">
            	<li id ="Li1"><span onclick="SubMenus()"><spring:message code='ezPortal.t216'/></span></li>
            </c:if>
		</ul>
	</div>
	<div id="close">
		<ul>
			<li><span onclick="window.close()">
				<spring:message code='ezPortal.t8'/>
			</span></li>
		</ul>
	</div>
	<div id="tabnav">
		<ul>
			<li id="menu_1"><span onclick="toggle_menu(1)">
				<spring:message code='ezPortal.t86'/>
			</span></li>
			<li id="menu_2"><span onclick="toggle_menu(2)">
				<spring:message code='ezPortal.t113'/>
			</span></li>
			<li id="menu_3"><span onclick="toggle_menu(3)">
				<spring:message code='ezPortal.t87'/>
			</span></li>
		</ul>
	</div>	
	<table width="500" id="toggle_tbl1" class="content">
		<tr>
			<th>
				<spring:message code='ezPortal.t88'/>
			</th>
			<td>
			    <table>
                    <tr class="primary">
	                    <th>${langPrimary}</th>
	                    <td><input type="text" id="txtDisplayName" style="width: 100%" value="${displayName}"></td>	
                    </tr>
                    <tr class="secondary">
	                    <th>${langSecondary}</th>
	                    <td><input type="text" id="txtDisplayName2" style="width:100%" value="${displayName2}"></td>	
                    </tr>
                </table>
			</td>
		</tr>
		<%String imageWidth = (String)request.getParameter("imageWidth"); %>
		<% if (imageWidth != null && !imageWidth.equals("")) { %>
		<tr>
			<th>
				Normal image
			</th>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
					<%String normalImagePath = (String)request.getParameter("normalImagePath"); %>
						<% if (normalImagePath != null && !normalImagePath.trim().equals("")) { %>
							<td id="tdNormalImage">
							&nbsp;<img id="txtNormalImage" src="<%= normalImagePath %>"></td>
						<% } else { %>
						<td id="tdNormalImage">
							&nbsp;<img id="txtNormalImage" src="" style="display: none"></td>
						<% } %>
						<td width="100%" align="center" nowrap>
							<a class="imgbtn"><span onclick="changeNormalImage()">
								<spring:message code='ezPortal.t66'/>
							</span></a><a class="imgbtn"><span onclick="removeNormalImage()" style="width: 20px">
								<spring:message code='ezPortal.t67'/>
							</span></a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<th>
				Over image
			</th>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
					<%String overImagePath = (String)request.getParameter("overImagePath"); %>
						<% if (overImagePath != null && !overImagePath.trim().equals("")) { %>
						<td>
							&nbsp;<img id="txtOverImage" src="<%= overImagePath %>"></td>
						<% } else { %>
						<td id="tdOverImage">
							&nbsp;<img id="txtOverImage" src="" style="display: none"></td>
						<% } %>
						<td width="100%" align="center" nowrap>
							<a class="imgbtn"><span onclick="changeOverImage()">
								<spring:message code='ezPortal.t66'/>
							</span></a><a class="imgbtn"><span onclick="removeOverImage()" style="width: 20px">
								<spring:message code='ezPortal.t67'/>
							</span></a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='ezPortal.t68'/>
			</th>
			<td>
				<input type="text" id="txtLinkURL" style="width: 100%" value="${linkURL}"></td>
		</tr>
		<tr>
			<th>
				<spring:message code='ezPortal.t89'/>
			</th>
			<td>
				<input type="text" id="txtLinkLocation" style="width: 100%" value="${linkLocation}"></td>
		</tr>
		<tr>
			<th>
				<spring:message code='ezPortal.t90'/>
			</th>
			<td>
				<input type="text" id="txtWindowOption" style="width: 100%" value="${windowOption}"></td>
		</tr>
		<% } else { %>
		<tr>
			<th>
				Normal image
			</th>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td id="tdNormalImage">
							&nbsp;<img id="txtNormalImage" src="" style="display: none"></td>
						<td width="100%" align="center" nowrap>
							<a class="imgbtn"><span onclick="changeNormalImage()">
								<spring:message code='ezPortal.t66'/>
							</span></a><a class="imgbtn"><span onclick="removeNormalImage()" style="width: 20px">
								<spring:message code='ezPortal.t67'/>
							</span></a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<th>
				Over image
			</th>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td id="tdOverImage">
							&nbsp;<img id="txtOverImage" src="" style="display: none"></td>
						<td width="100%" align="center" nowrap>
							<a class="imgbtn"><span onclick="changeOverImage()">
								<spring:message code='ezPortal.t66'/>
							</span></a><a class="imgbtn"><span onclick="removeOverImage()" style="width: 20px">
								<spring:message code='ezPortal.t67'/>
							</span></a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='ezPortal.t68'/>
			</th>
			<td>
				<input type="text" id="txtLinkURL" style="width: 100%" value="${linkURL}"></td>
		</tr>
		<tr>
			<th>
				<spring:message code='ezPortal.t89'/>
			</th>
			<td>
				<input type="text" id="txtLinkLocation" style="width: 100%" value="${linkLocation}"></td>
		</tr>
		<tr>
			<th>
				<spring:message code='ezPortal.t90'/>
			</th>
			<td>
				<input type="text" id="txtWindowOption" style="width: 100%" value="${windowOption}"></td>
		</tr>
		<% } %>
	</table>
	<table id="toggle_tbl2_1" width="500" class="popuplist" style="display: none;">
		<tr>
			<th width="85">
				<spring:message code='ezPortal.t115'/>
			</th>
			<th>
				<spring:message code='ezPortal.t116'/>
			</th>
			<th width="70">
			</th>
		</tr>
		<%-- <% for (int i = 0; i < xmldom_param.GetElementsByTagName("UID_").Count; i++)
	 { %>
		<% if (xmldom_param.GetElementsByTagName("PARAMTYPE").Item(i).InnerText == "0")
	 { %>
		<tr>
			<td>
				<%= xmldom_param.GetElementsByTagName("PARAMNAME").Item(i).InnerText %>
			</td>
			<td>
				<%= xmldom_param.GetElementsByTagName("PARAMVALUE").Item(i).InnerText %>
			</td>
			<td align="center">
				<a class="imgbtn"><span onclick="RemoveParameter('<%= xmldom_param.GetElementsByTagName("PARAMNAME").Item(i).InnerText %>')"
					style="width: 20px">
					<spring:message code='ezPortal.t67'/>
				</span></a>
			</td>
		</tr>
		<% }
	 else
	 { %>
		<tr>
			<td>
				<%= xmldom_param.GetElementsByTagName("PARAMNAME").Item(i).InnerText %>
			</td>
			<td>
				<%= xmldom_param.GetElementsByTagName("DESCRIPTION").Item(i).InnerText %>
			</td>
			<td align="center">
				<a class="imgbtn"><span onclick="RemoveParameter('<%= xmldom_param.GetElementsByTagName("PARAMNAME").Item(i).InnerText %>')"
					style="width: 20px">
					<spring:message code='ezPortal.t67'/>
				</span></a>
			</td>
		</tr>
		<% } %>
		<% } %> --%>
		${paramHtml}
	</table>
    <br id ="idbr" />
	<table id="toggle_tbl2_2" width="500" class="popuplist" style="display: none;">
		<tr>
			<th>
				<spring:message code='ezPortal.t117'/>
			</th>
			<td>
				<input type="text" id="newParamName" style="width: 100%"></td>
		</tr>
		<tr>
			<th>
				<spring:message code='ezPortal.t118'/>
			</th>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="125">
							<select id="SelectParamType" onchange="Param_Change()">
								<c:forEach items="${paramType}" var="item">
              						<option value="${item.paramType}"><spring:message code='ezPortal.${item.shortName}'/></option>
              					</c:forEach>
							</select>
						</td>
						<td>
							<input type="text" id="newParamValue" style="width: 100%"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<table id="toggle_tbl2_3" style="display: none; margin-top: 10px;" width="510" border="0"
		cellspacing="0" cellpadding="0">
		<tr>
			<td align="center">
                <a class="imgbtn"><span onclick="AddParameter()"><spring:message code='ezPortal.t62'/></span></a>
			</td>
		</tr>
	</table>
	<table id="toggle_tbl3_1" width="500" class="popuplist" style="display: none">
		<tr>
			<th width="80">
				<spring:message code='ezPortal.t91'/>
			</th>
			<th width="80">
				<spring:message code='ezPortal.t92'/>
			</th>
			<th width="80">
				<spring:message code='ezPortal.t93'/>
			</th>
			<th width="80">
				<spring:message code='ezPortal.t94'/>
			</th>
			<th>
				&nbsp;</th>
		</tr>
	
		<c:forEach items="${aclList}" var="item">
  	  <tr>
    	<td>${item.accessID}</td>
    	<td>${item.accessName}</td>
    	<td>
    	<c:choose>
    		<c:when test="${item.edit_Right == 2}">
    			<spring:message code='ezPortal.t95'/>
    		</c:when>
    		<c:otherwise>
    			<spring:message code='ezPortal.t96'/>
    		</c:otherwise>
    	</c:choose>
    	</td>
    	<td>
    	<c:choose>
    		<c:when test="${item.view_Right == 2}">
    			<spring:message code='ezPortal.t95'/>
    		</c:when>
    		<c:otherwise>
    			<spring:message code='ezPortal.t96'/>
    		</c:otherwise>
    	</c:choose>
    	</td>
    	<td align="center">
				<a class="imgbtn"><span onclick="DeleteRight('${item.accessID}')" style="width: 20px">
					<spring:message code='ezPortal.t67'/>
				</span></a>
			</td>
  	</tr>
  </c:forEach>
		
	</table>
	<br id ="idbr2">
	<table id="toggle_tbl3_2" width="500" class="popuplist" style="display: none">
		<tr>
			<th width="70">
				<spring:message code='ezPortal.t91'/>
			</th>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<input type="text" id="newAccessID" style="width: 100%" readonly>
						</td>
						<td width="39" align="center">
							<a class="imgbtn"><span onclick="SelectID()" style="width: 20px">
								<spring:message code='ezPortal.t45'/>
							</span></a>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='ezPortal.t92'/>
			</th>
			<td>
				<input type="text" id="newAccessName" style="width: 100%" readonly></td>
		</tr>
		<tr>
			<th>
				<spring:message code='ezPortal.t93'/>
			</th>
			<td>
				<input type="radio" name="SelectEditRight" value="1" checked>
					<spring:message code='ezPortal.t97'/>
				<input type="radio" name="SelectEditRight" value="2">
					<spring:message code='ezPortal.t95'/>
			</td>
		</tr>
		<tr>
			<th>
				<spring:message code='ezPortal.t94'/>
			</th>
			<td>
				<input type="radio" name="SelectViewRight" value="1" checked>
					<spring:message code='ezPortal.t97'/>
				<input type="radio" name="SelectViewRight" value="2">
					<spring:message code='ezPortal.t95'/>
			</td>
		</tr>
	</table>
	<div class="btnposition" id="toggle_tbl3_3" style="display: none">
        <a class="imgbtn"><span onclick="AddRight()"><spring:message code='ezPortal.t62'/></span></a>
        <input onclick="window.close();" style ="display:none" type="button" value="<spring:message code='ezPortal.t12'/>">
	</div>
    <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
                    <form method="post" id="form" name="form" enctype="multipart/form-data" action="/admin/ezPortal/portletImageUpload.do?mode=Menu" target="ifrm" style ="display:none">
                        <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="true" />
                        <input type="hidden" name="boardid" id="boardid" />
                        <input type="hidden" name="maxsize" id="maxsize" />
                        <input type="hidden" name="mode" id="mode" value="PHOTO"/>
                        <input type="hidden" name="cnt" id="cnt" />
                        <input type="hidden" name="mailgubun" id="mailgubun" />
                    </form>
	<script type="text/javascript">
    selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
	selToggleList(document.getElementById("menu"), "ul", "li", "0");
	selToggleList(document.getElementById("close"), "ul", "li", "0");
	</script>

</body>
</html>