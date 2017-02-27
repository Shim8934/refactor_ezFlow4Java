<%@page import="org.jasypt.commons.CommonUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPortal.t61'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezPortal/functionLib.js"></script>
		<script type="text/javascript" src="/js/ezPortal/string_component.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript">
		var imageWidth = "${imageWidth}";
		var imageHeight = "${imageHeight}";
		var g_xmlhttp = createXMLHttpRequest();
		var pageid = "${pageID}";
		var uid = "${uID}";
		var g_Dirty = false;
		var pmode = "${mode}";
		var parentuid = "${parentUID}";
		var g_bSaved = false;
		var menuindex = "${menuIndex}";
		var pSkin = "1";   // 기본설정에선 모두 스킨1만 설정
		var pNoneActiveX = "${noneActiveX}";
	    window.onload = function() {
			toggle_menu(menuindex);
		}
		
		function toggle_menu(pIndex)
		{
			if (pmode == "new" && g_bSaved == false)
			{
				if (pIndex.toString() != "1")
				{
					alert("<spring:message code='ezPortal.t83'/>");
					return;
				}
			}
			
			// 이미지 변경
			switch(pIndex.toString()) {
				case "1":
					menu_1.src = "/images/tap_portal01o.gif";
					menu_3.src = "/images/tap_portal03.gif";
					toggle_tbl1.style.display = "";
					toggle_tbl3_1.style.display = "none";
					toggle_tbl3_2.style.display = "none";
					toggle_tbl3_3.style.display = "none";
					break;
				case "3":
					menu_1.src = "/images/tap_portal01.gif";
					menu_3.src = "/images/tap_portal03o.gif";
					toggle_tbl1.style.display = "none";
					toggle_tbl3_1.style.display = "";
					toggle_tbl3_2.style.display = "";
					toggle_tbl3_3.style.display = "";
					break;
			}
		}

		function changeNormalImage() {
			//2016-10-21 mode PHOTO -> Logo로 변경
			if (CrossYN()) {
				document.getElementById('mode').value = "Logo";
		        document.form.file1.click();	
			} else {
				 var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
			     var filepath = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0All Files (*.*)\0*.*\0\0", "");
			    if (filepath == "") return;

			    var strBase64 = ezUtil.DownloadToBase64(filepath);
			    ezUtil = null;

			    var ezUtil = new ActiveXObject("ezUtil.ImageFunc");
			    var temp = ezUtil.GetImageSize(filepath);
			    ezUtil = null;

			    imageWidth = temp.split("*")[0];
			    imageHeight = temp.split("*")[1];
		            
			    var strXML = "<IMAGE><OLDFILENAME>" + txtNormalImage.src.substr(txtNormalImage.src.lastIndexOf("/") + 1) + "</OLDFILENAME><FILENAME>" + filepath.substr(filepath.lastIndexOf("\\") + 1) + "</FILENAME><DATA>" + strBase64 + "</DATA></IMAGE>";
			    g_xmlhttp = createXMLHttpRequest();
			    g_xmlhttp.open("POST", "/admin/ezPortal/uploadMenuImage.do?mode=Logo", true);
			    g_xmlhttp.onreadystatechange = changeNormalImage_end;
			    g_xmlhttp.send(strXML);				
			}
	        
		}
		
		function changeNormalImage_end() {
			//if (g_xmlhttp.readystate != 4) return;
			txtNormalImage.src = g_xmlhttp.responseText;
			txtNormalImage.style.display = "";
			g_Dirty = true;
		}
			
		function removeNormalImage()
		{
			txtNormalImage.style.display = "none";
			txtNormalImage.src = "";
			g_Dirty = true;
		}
		
		function Save() {
			if (specialChk(document.getElementById("txtDisplayName").value) || specialChk(document.getElementById("txtDisplayName2").value) || specialChk(document.getElementById("txtNormalImage").value) || specialChk(document.getElementById("txtLinkURL").value) || specialChk(document.getElementById("txtLinkLocation").value) || specialChk(document.getElementById("txtWindowOption").value)) {
		    	alert("<spring:message code='ezResource.special' />");
		    	return;
		    }
			
			var strXML = "<DATA>";
			//var normalImgPath = txtNormalImage.src.substr(txtNormalImage.src.indexOf("/files/upload_portal"));
			var normalImgPath = txtNormalImage.src.substr(txtNormalImage.src.indexOf("${uploadPortalPath}"));
			//if (normalImgPath.indexOf("/files/upload_portal") == -1) normalImgPath = "";
			if (normalImgPath.indexOf("${uploadPortalPath}") == -1) normalImgPath = "";
			
			
			strXML += "<OLDFILENAME></OLDFILENAME>";
			strXML += "<DISPLAYNAME>" + ReplaceValidString(document.getElementById("txtDisplayName").value) + "</DISPLAYNAME>";
			strXML += "<DISPLAYNAME2>" + ReplaceValidString(document.getElementById("txtDisplayName2").value) + "</DISPLAYNAME2>";
			strXML += "<NORMALIMAGE>" + normalImgPath + "</NORMALIMAGE>";
			
			//strXML += "<IMAGEWIDTH>" + imageWidth + "</IMAGEWIDTH>";
			//strXML += "<IMAGEHEIGHT>" + imageHeight + "</IMAGEHEIGHT>";
			
			// 20071029 logo size fix
			strXML += "<IMAGEWIDTH>186</IMAGEWIDTH>";
			strXML += "<IMAGEHEIGHT>40</IMAGEHEIGHT>";
			
			strXML += "<LINKURL>" + ReplaceValidString(document.getElementById("txtLinkURL").value) + "</LINKURL>";
			strXML += "<LINKLOCATION>" + ReplaceValidString(document.getElementById("txtLinkLocation").value) + "</LINKLOCATION>";
			strXML += "<WINDOWOPTION>" + ReplaceValidString(document.getElementById("txtWindowOption").value) + "</WINDOWOPTION>";
			strXML += "<SKIN>" + pSkin + "</SKIN>";
			strXML += "</DATA>";
			
			var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/saveLogoImage.do?pageID=" + pageid + "&uID=" + uid + "&mode=SAVE", false);
			xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
			xmlhttp.send(strXML);
			
			alert("<spring:message code='ezPortal.t84'/>");
			g_bSaved = true;
			xmlhttp = null;
			
			location.href = "/admin/ezPortal/logoEdit.do?pageID=" + pageid + "&mode=edit&uID=" + uid + "&menuIndex=1";
		}
		
	    window.onbeforeunload = function() {
			// 신규이면서 저장한 경우 reload
			//if (pmode == "new" && g_bSaved == true)
			// 20071024 수정일때도 자동 리프레쉬 되어야 함
			if (g_bSaved == true)		 {
				try{
					window.opener.location.reload();
				} catch(e) {}
			}
			// 신규이면서 저장하지 않은 경우 저장된 정보 삭제
			else if (pmode == "new" && g_bSaved == false) {
				Delete("");
			}
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
		
		function AddRight()
		{
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
			xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
			xmlhttp.send(strXML);
			xmlhttp = null;
			
			g_bSaved = true;
			
			location.href = "/admin/ezPortal/logoEdit.do?pageID=" + pageid + "&mode=edit&uID=" + uid + "&menuIndex=3";
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
			xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
			xmlhttp.send(strXML);
			xmlhttp = null;
			
			g_bSaved = true;
			
			location.href = "/admin/ezPortal/logoEdit.do?pageID=" + pageid + "&mode=edit&uID=" + uid + "&menuIndex=3";
		}
		
		// 로고 삭제
		function Delete(pFileName) {
		    var xmlhttp = createXMLHttpRequest();
			xmlhttp.open("POST", "/admin/ezPortal/saveLogoImage.do?pageID=" + pageid + "&uID=" + uid + "&oldFileName=" + escape(pFileName) + "&mode=DEL", false);
			xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
			xmlhttp.send();
			xmlhttp = null;
		}

		function btn_AttachAdd_onclick() {
		    if (document.form.file1.value != "") {
		        if (document.getElementById('mode').value == "PHOTO") {
		            if (document.getElementById("form").file1.files.length < 2) {
		            }
		            else
		                alert("<spring:message code='ezPortal.t414'/>");
		        }

		        document.getElementById("cnt").value = $("input[name=file1]")[0].files[0].length;
		        var frm = document.getElementById('form');
		        frm.action = "/admin/ezPortal/portletImageUpload.do?mode=Logo";
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
		            //2016-10-21 mode PHOTO -> Logo로 변경
		            if (document.getElementById('mode').value == "Logo") {
		                if (navigator.userAgent.indexOf("Firefox") != -1)
		                    //txtNormalImage.src = "/files/upload_portal/" + getNodeText(GetChildNodes(nodes[i])[4]);
		                	txtNormalImage.src = "${uploadPortalPath}" + getNodeText(GetChildNodes(nodes[i])[4]);
		                else
		                    //txtNormalImage.src = "/files/upload_portal/" + getNodeText(GetChildNodes(nodes[i])[4]);
		                	txtNormalImage.src = "${uploadPortalPath}" + getNodeText(GetChildNodes(nodes[i])[4]);
		                txtNormalImage.style.display = "";
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
	 <body class="popup">
		<div id="menu">
  			<ul>
    			<li><span onClick="Save()"><spring:message code='ezPortal.t62'/></span></li>
  			</ul>
		</div>	
		<div id="close">
  			<ul>
    			<li><span onClick="window.close()"><spring:message code='ezPortal.t8'/></span></li>
  			</ul>
		</div>
      	<div id="tabnav">
        	<ul>
          		<li id="menu_1"><span onclick="toggle_menu(1)"><spring:message code='ezPortal.t86'/></span></li>
          		<li id="menu_3"><span onclick="toggle_menu(3)"><spring:message code='ezPortal.t87'/></span></li>
        	</ul>
      </div>	
	  <!-- 로고 관련 설정 -->
		<table id="toggle_tbl1" width="500" class="content">
			<tr>
				<th width="100"><spring:message code='ezPortal.t88'/></th>
				<td>
			    	<table>
                    	<tr class="primary">
	                    	<th>${langPrimary}</th>
	                   		<td><input type="text" id="txtDisplayName" style="width:100%" value="${displayName}" maxLength="255"></td>	
                    	</tr>
                   		 <tr class="secondary">
	                    	<th>${langSecondary}</th>
	                    	<td><input type="text" id="txtDisplayName2" style="width:100%" value="${displayName2}" maxLength="255"></td>	
                    	</tr>
                	</table>
				</td>
			</tr>
			<tr>
				<th><spring:message code='ezPortal.t65'/></th> 
				<td><table width="100%"  border="0" cellspacing="0" cellpadding="0"> 
				<tr> 
					<%String imagePath = (String)request.getAttribute("imagePath"); %>
					<% if (imagePath != null && !imagePath.trim().equals("")) { %>
					<td id="tdNormalImage">&nbsp;<img id="txtNormalImage" src="${imagePath}" width=186 height=40 ></td>
					<% } else { %>
					<td id="tdNormalImage">&nbsp;<img id="txtNormalImage" src="" style="display:none" width=186 height=40 ></td>
					<% } %>

                    <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
                    <form method="post" id="form" name="form" enctype="multipart/form-data" action="/admin/ezPortal/portletImageUpload.do?mode=Logo" target="ifrm">
                        <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="true" />
                        <input type="hidden" name="boardid" id="boardid" />
                        <input type="hidden" name="maxsize" id="maxsize" />
                        <input type="hidden" name="mode" id="mode" value="Logo"/>
                        <input type="hidden" name="cnt" id="cnt" />
                        <input type="hidden" name="mailgubun" id="mailgubun" />
                    </form>

                    <td width="100%" align="center" nowrap><a class="imgbtn"><span onclick="changeNormalImage()"><spring:message code='ezPortal.t66'/></span></a><a class="imgbtn"><span onclick="removeNormalImage()" style="width:20px"><spring:message code='ezPortal.t67'/></span></a></td>
				</tr> 
			</table></td> 
		</tr> 
		<tr> 
			<th><spring:message code='ezPortal.t68'/></th> 
			<td><input type="text" name="txtLinkURL" id="txtLinkURL" style="width:100%" value="${linkURL}" maxLength="512"></td>
		</tr> 
		<tr> 
			<th><spring:message code='ezPortal.t89'/></th> 
			<td><input type="text" name="txtLinkLocation" id="txtLinkLocation" style="width:100%" value="${linkLocation}" maxLength="50"></td> 
		</tr>
		<tr>
			<th><spring:message code='ezPortal.t90'/></th>
			<td><input type="text" id="txtWindowOption" id="txtWindowOption" style="width:100%" value="${windowOption}" maxLength="150"></td>
		</tr>
  </table>
	
	<table id="toggle_tbl3_1" width="500" class="popuplist" style="display:none">
		<tr>
			<th width="80"><spring:message code='ezPortal.t91'/></th>
			<th width="80"><spring:message code='ezPortal.t92'/></th>
			<th width="80"><spring:message code='ezPortal.t93'/></th>
			<th width="80"><spring:message code='ezPortal.t94'/></th>
			<th>&nbsp;</th>
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
    	<td width="39" align="center"><a class="imgbtn"><span onClick="DeleteRight('${item.accessID}')" ><spring:message code='ezPortal.t67'/></span></a></td>
  	</tr>
  </c:forEach>
	</table>
	<br>
	<table id="toggle_tbl3_2" width="500" class="content" style="display:none">
		<tr>
			<th width="70"><spring:message code='ezPortal.t91'/></th>
			<td nowrap class="pos1"><input type="text" id="newAccessID" style="width:100%" readonly> </td>
			<td width="40" nowrap class="pos2"><a class="imgbtn"><span onClick="SelectID()"><spring:message code='ezPortal.t45'/></span></a></td>			
		</tr>
		<tr>
			<th><spring:message code='ezPortal.t92'/></th>
			<td colspan="2"><input type="text" id="newAccessName" style="width:100%" readonly></td>
		</tr>
		<tr style="display:none">
			<th><spring:message code='ezPortal.t93'/></th>
			<td colspan="2">
				<input type="radio" name="SelectEditRight" value="1" checked> <spring:message code='ezPortal.t97'/>
				<input type="radio" name="SelectEditRight" value="2"> <spring:message code='ezPortal.t95'/>			</td>
		</tr>
		<tr>
			<th><spring:message code='ezPortal.t94'/></th>
			<td colspan="2">
				<input type="radio" name="SelectViewRight" value="1" checked> <spring:message code='ezPortal.t97'/>
				<input type="radio" name="SelectViewRight" value="2"> <spring:message code='ezPortal.t95'/>			</td>
		</tr>
	</table>

<div class="btnposition" id="toggle_tbl3_3" style="display:none">
    <a class="imgbtn"><span onClick="AddRight()"><spring:message code='ezPortal.t62'/></span></a>
    <a class="imgbtn"><span onClick="window.close();"><spring:message code='ezPortal.t12'/></span></a>
</div>	

<script type="text/javascript">
    selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
	selToggleList(document.getElementById("menu"), "ul", "li", "0");
	selToggleList(document.getElementById("close"), "ul", "li", "0");
</script>	
  </body>
</html>