<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPortal.t990001'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code='ezPortal.i2'/>" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezPersonal/controls/ListView_list.js"></script>
		<script type="text/javascript">
		var mode = "${mode}";
        var pKeyCode = "${pKeyCode}";
        var TopHeight = "${themeTopHeight}";
        var pNoneActiveX = "${noneActiveX}";
        var ReturnFunction;
        window.onload = function () {
            try {
                ReturnFunction = parent.themeinfo_dialogArguments[1];
            } catch (e) {
                try {
                    ReturnFunction = opener.themeinfo_dialogArguments[1];
                } catch (e) {
                    
                }
            }

            DisplayHeightOption();
            if (mode != "new")
                txtNormalImage.style.display = "";

            toggle_menu(1);
            if (window.dialogArguments != "" && mode != "new") {
                ArgQuickID = window.dialogArguments;
            }
            try {
                var ua = navigator.userAgent;
                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
                    KeEventControl(document.getElementById("Title1"));
                    KeEventControl(document.getElementById("Title2"));
                    KeEventControl(document.getElementById("Title3"));
                    KeEventControl(document.getElementById("Title4"));
                    KeEventControl(document.getElementById("txtURL"));
                }
            }
            catch (e)
            { }
        }
        function KeEventControl(obj) {
            useragt = navigator.userAgent.toUpperCase();
            if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0)
            {
                useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
                if (parseInt(useragt) > 5) {
                    return;
                }
            }
            obj.onkeydown = function () {
                if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
                    return false;
                if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
                        parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
                        parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
                        parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
                        parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
                    return false;
            };
        }
        function btn_cancel() {
            if (ReturnFunction != null)
                ReturnFunction();

            window.close();
        }
        function SaveTheme() {
            if (document.getElementById("Title1").value.trim() == "") {
                document.getElementById("Title1").focus();
                alert("<spring:message code='ezPortal.t990004'/>");
                return;
            }
            if (document.getElementById("TopURL").value == "") {
                alert("<spring:message code='ezPortal.t990005'/>"); return;
            }
            if (document.getElementById("MainURL").value == "") {
                alert("<spring:message code='ezPortal.t990006'/>"); return;
            }

            if (document.getElementById("Title2").value.trim() == "") {
                document.getElementById("Title2").value = document.getElementById("Title1").value + "_en";
            }
            if (document.getElementById("Title3").value.trim() == "") {
                document.getElementById("Title3").value = document.getElementById("Title1").value + "_ja";
            }
            if (document.getElementById("Title4").value.trim() == "") {
                document.getElementById("Title4").value = document.getElementById("Title1").value + "_zh";
            }
            SaveTheme_onClick();
        }
        function SaveTheme_onClick() {
            var xmlpara = createXmlDom();
            var objNode;
            var objNode2;
            var objNode3;
            objNode = createNodeInsert(xmlpara, objNode, "DATA");
            if(mode != "new")
                createNodeAndInsertText(xmlpara, objNode, "THEMEID", pKeyCode);

            createNodeAndInsertText(xmlpara, objNode, "DISPLAYNAME", document.getElementById("Title1").value);
            createNodeAndInsertText(xmlpara, objNode, "DISPLAYNAME2", document.getElementById("Title2").value);
            createNodeAndInsertText(xmlpara, objNode, "DISPLAYNAME3", document.getElementById("Title3").value);
            createNodeAndInsertText(xmlpara, objNode, "DISPLAYNAME4", document.getElementById("Title4").value);
            createNodeAndInsertText(xmlpara, objNode, "IMAGEPATH", document.getElementById("txtNormalImage").src);
            createNodeAndInsertText(xmlpara, objNode, "TOPURL", document.getElementById("TopURL").value);
            createNodeAndInsertText(xmlpara, objNode, "MAINURL", document.getElementById("MainURL").value);
            createNodeAndInsertText(xmlpara, objNode, "TOPHEIGHT", document.getElementById("TopHeight")[document.getElementById("TopHeight").selectedIndex].value);
            createNodeAndInsertText(xmlpara, objNode, "MODE", mode);
            xmlhttp = null;
            xmlhttp = createXMLHttpRequest();
            xmlhttp.open("POST", "/admin/ezPortal/saveThemeInfo.do", false);
            xmlhttp.send(xmlpara);
            if (xmlhttp != null && xmlhttp.readyState == 4) {
                if (xmlhttp.statusText == "OK") {
                    alert("<spring:message code='ezPortal.t121'/>"); 

                    if (ReturnFunction != null)
                        ReturnFunction();

                    window.close();
                }
                else {
                    alert("<spring:message code='ezPortal.t243'/>" + xmlhttp.responseText);
                }
            }
        }
        function SelectID() {
            var config = "status:false;dialogWidth:690px;dialogHeight:630px;scroll:no;status:no;edge:sunken" + GetShowModalPosition(690, 630);
            var ret = window.showModalDialog("/myoffice/ezPortal/Admin/edit/OrganAdmin/SelectTarget.aspx", "", config);

            if (typeof (ret) != "undefined") {
                newAccessID.value = ret.split(";")[0];
                newAccessName.value = ret.split(";")[1];
            }

        }
        var ImageState = "";
        function changeNormalImage() {
            //if (CrossYN() || (pNoneActiveX=="YES")) {
                ImageState = "Normal";
                document.getElementById('mode').value = "PHOTO";
                document.form.file1.click();
            //}
            /*else {
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

                g_xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                g_xmlhttp.open("POST", "/myoffice/ezPortal/admin/edit/UploadMenuImage.aspx?mode=Theme", true);
                g_xmlhttp.onreadystatechange = changeNormalImage_end;
                g_xmlhttp.send(strXML);
            }*/
        }
        function changeNormalImage_end() {
            if (g_xmlhttp.readyState != 4) return;
            txtNormalImage.src = g_xmlhttp.responseText;
            txtNormalImage.style.display = "";
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
                frm.action = "/admin/ezPortal/portletImageUpload.do?mode=Theme";
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
                            if (navigator.userAgent.indexOf("Firefox") != -1) {
                            	txtNormalImage.src = "/files/upload_portal/" + getNodeText(GetChildNodes(nodes[i])[4]);
                            } else {
                                txtNormalImage.src = "/files/upload_portal/" + getNodeText(GetChildNodes(nodes[i])[4]);
                            }
                            txtNormalImage.style.display = "";
                        }
                        else {
                            if (navigator.userAgent.indexOf("Firefox") != -1) {
                                txtOverImage.src = "/files/upload_portal/" + getNodeText(GetChildNodes(nodes[i])[4]);
                            }else {
                                txtOverImage.src = "/files/upload_portal/" + getNodeText(GetChildNodes(nodes[i])[4]);
                            }
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
        function toggle_menu(pIndex) {
            switch (pIndex.toString()) {
                case "1":
                    menu_1.src = "/images/tap_portal01o.gif";
                    //menu_2.src = "/images/tap_portal02.gif";
                    document.getElementById("Rolllayer").style.display = "none";
                    document.getElementById("infolayer").style.display = "";
                    break;
                case "2":
                    menu_1.src = "/images/tap_portal01.gif";
                    //menu_2.src = "/images/tap_portal02o.gif";
                    document.getElementById("Rolllayer").style.display = "";
                    document.getElementById("infolayer").style.display = "none";
                    break;
            }
        }
        function removeNormalImage() {
            txtNormalImage.style.display = "none";
            txtNormalImage.src = "";
            g_Dirty = true;
        }
        function DisplayHeightOption() {
            document.getElementById("TopHeight").innerHTML = "";

            var DisplayTopHeight = 50;
            for (var i = 0; i < 11; i++) {
                var option = document.createElement("OPTION");
                option.value = DisplayTopHeight;
                option.textContent = DisplayTopHeight + "px";

                if (DisplayTopHeight == TopHeight)
                    option.selected = true;

                document.getElementById("TopHeight").appendChild(option);
                DisplayTopHeight += 10;
            }
        }
        function close_onclick() {
            if (ReturnFunction != null)
                ReturnFunction();

            window.close();
        }
		</script>
	</head>
	<body class="popup">
		<div id="menu">
  			<ul>
    			<li><span onClick="SaveTheme()"><spring:message code='ezPortal.t62'/></span></li>
  			</ul>
		</div>
		<div id="close">
  			<ul>
    			<li><span onClick="close_onclick()"><spring:message code='ezPortal.t8'/></span></li>
  			</ul>
		</div>
		<div id="tabnav">
  			<ul>
    			<li id="menu_1"><span onClick="toggle_menu(1)" ><spring:message code='ezPortal.t86'/></span></li>
    			<%--<li id="menu_2"><span onClick="toggle_menu(2)"><%=RM.GetString("t87")%></span></li>--%>
  			</ul>
			<script type="text/javascript">
    			selToggleList(document.getElementById("menu"), "ul", "li", "0");
    			selToggleList(document.getElementById("close"), "ul", "li", "0");
    			selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
			</script>
		</div>
		<%
			String mode = (String)request.getParameter("mode"); 
		%>
		<div id="infolayer">
    		<table class="content" style="height:300px;width:100%;">
        		<tr>
            		<th style="text-align:center"><spring:message code='ezPortal.t7'/></th>
            		<td colspan="2" style="padding:0px;">
                		<table style="width:100%">
                    		<tr class="primary">
                        		<th style="width:16%"><spring:message code='ezPortal.t403'/></th>
                        		<td style="border-bottom:1px solid #b6b6b6;">
                            		<input name="Input" id="Title1" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" <%if(mode.equals("new")){%> value=""<%}else{ %> value="${themeNm1}" <%} %>/></td>
                    		</tr>
                    		<tr class="secondary">
                        		<th style="width:16%"><spring:message code='ezPortal.t404'/></th>
                        		<td style="border-bottom:1px solid #b6b6b6;">
                            		<input type="text" id="Title2" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;"  <%if(mode.equals("new")){%> value=""<%}else{ %> value="${themeNm2}" <%} %> /></td>
                    		</tr>
                    		<tr class="secondary">
                        		<th style="width:16%"><spring:message code='ezPortal.t4093'/></th>
                        		<td style="border-bottom:1px solid #b6b6b6;">
                            		<input type="text" id="Title3" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;"  <%if(mode.equals("new")){%> value=""<%}else{ %> value="${themeNm3}" <%} %> /></td>
                    		</tr>
                    		<tr class="secondary">
                        		<th style="width:16%"><spring:message code='ezPortal.t4094'/></th>
                        		<td>
                            		<input type="text" id="Title4" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;"  <%if(mode.equals("new")){%> value=""<%}else{ %> value="${themeNm4}" <%} %> /></td>
                    		</tr>
                	</table>
            	</td>
        	</tr>
           	<tr>
            	<th style="text-align: center"><spring:message code='ezPortal.t990002'/></th>
            	<td colspan="2" style="padding:0px;">
	                <table style="width: 100%">
    	                <tr class="secondary">
        	                <th style="width:16%;border-top:0px;">URL</th>
            	            <td style="border-bottom:1px solid #b6b6b6;">
                	            <input type="text" id="TopURL" style="WIDTH: 100%; -moz-box-sizing: border-box; box-sizing: border-box;" <%if (mode.equals("new")) {%> value="" <%} else { %> value="${themeTopURL}" <%} %> />
                    	    </td>
                    	</tr>
                    	<tr class="secondary">
	                        <th style="width:16%">HEIGHT</th>
    						<td>
	                            <select id="TopHeight"></select>
    	                    </td>
                    	</tr>
                	</table>
            	</td>
        	</tr>
        	<tr>
            	<th style="text-align: center"><spring:message code='ezPortal.t990003'/></th>
            	<td colspan="2" style="padding:0px;">
	                <table style="width: 100%">
    	                <tr class="secondary">
        	                <th style="width:16%;border-top:0px;">URL</th>
            	            <td>
                	            <input type="text" id="MainURL" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" <%if(mode.equals("new")){%> value=""<%}else{ %> value="${themeMainURL}" <%} %> />
                    	    </td>
                    	</tr>
                	</table>
            	</td>
        	</tr>
        	<tr>
            	<th style="text-align:center"><spring:message code='ezPortal.t202'/></th>
            	<td colspan="2">
	                <div>
    	                <table style="width:100%;">
        	                <tr>
							    <td id="tdNormalImage" style="width:100%;height:250px;vertical-align:middle;text-align:center;">
								    <img id="txtNormalImage" <%if(mode.equals("new")){%> src=""<%}else{ %> src="${themeImage}" <%} %> style="display:none;vertical-align:middle;text-align:center;">
                    	            <p></p><div>(<spring:message code='ezPortal.t990012'/>)</div>
							    </td>
						    	<td style="border-left:1px solid #B6B6B6;" align="center">
							    	<a class="imgbtn" style="margin-left:2px;"><span onclick="changeNormalImage()">
									    <spring:message code='ezPortal.t66'/><br />
								    </span></a><a class="imgbtn" style="margin-left:2px;"><span onclick="removeNormalImage()">
									    <spring:message code='ezPortal.t990008'/>
								    </span></a>
							    </td>
                       		 </tr>
                    	</table>
                	</div>
            	</td>
        	</tr>
    	</table>
	</div>
	<div id="Rolllayer">
    	<div style="width:100%;height:280px;overflow-x:hidden;overflow-y:auto;border:1px solid #B6B6B6;">
	        <table class="content">
    	        <tr>
					<th style="width:150px;" class="pstitle"><spring:message code='ezPortal.t91'/></th>
					<th style="width:50%;" class="pstitle"><spring:message code='ezPortal.t92'/></th>
					<th style="width:80px;" class="pstitle"><spring:message code='ezPortal.t93'/></th>
					<th style="width:80px;" class="pstitle"><spring:message code='ezPortal.t94'/></th>
					<th style="width:80px;">&nbsp;</th>
            	</tr>
		   		<%-- <tr>
		    		<td style="width:150px;">${result.accessID}</td>
		    		<td style="width:50%;"><${result.accessName}</td>
		    		<td style="text-align:center;width:80px;">
		    			<c:choose>
		    				<c:when test="${result.editRight == '2'}">
		    					<spring:message code='ezPortal.t95'/>
		    				</c:when>
		    				<c:otherwise>
		    					<spring:message code='ezPortal.t96'/>
		    				</c:otherwise>
		    			</c:choose>
		    		</td>
		    		<td style="text-align:center;width:80px;">
		    			<c:choose>
		    				<c:when test="${result.viewRight == '2'}">
		    					<spring:message code='ezPortal.t95'/>
		    				</c:when>
		    				<c:otherwise>
		    					<spring:message code='ezPortal.t96'/>
		    				</c:otherwise>
		    			</c:choose>
		    		</td>
		    		<td style="width:70px;text-align:center;">
               			<a class="imgbtn"><span onClick="DeleteRight('${result.accessID}')"><spring:message code='ezPortal.t67'/></span></a>
					</td>
			    </tr> --%>
       		</table>
        </div>
        <br />
        <table class="content">
			<tr>
            	<th><spring:message code='ezPortal.t91'/></th>
                <td>
                    <table>
                	    <tr>
							<td><input type="text" id="newAccessID" style="width:99%" readonly> </td>
							<td>
	                            <a class="imgbtn"><span onClick="SelectID()"><spring:message code='ezPortal.t45'/></span></a>
							</td>
						</tr>
                    </table>
                </td>
            </tr>
            <tr>
                <th><spring:message code='ezPortal.t92'/></th>
                <td ><input type="text" id="newAccessName" style="width:99%" readonly></td>
            </tr>
            <tr>
                <th><spring:message code='ezPortal.t93'/></th>
                <td style="text-align:center;">
                    <input type="radio" name="SelectEditRight" value="1" checked> <spring:message code='ezPortal.t97'/>
				    <input type="radio" name="SelectEditRight" value="2"> <spring:message code='ezPortal.t95'/>
                </td>
            </tr>
            <tr>
			<th ><spring:message code='ezPortal.t94'/></th>
			<td style="text-align:center;">
				<input type="radio" name="SelectViewRight" value="1" checked> <spring:message code='ezPortal.t97'/>
				<input type="radio" name="SelectViewRight" value="2"> <spring:message code='ezPortal.t95'/>
			</td>
		</tr>
	     <tr style="display:none" >
	       <td><input type="text" id="AccessDeptName" style="display:none"></td>
	     </tr>
        </table>
	    <div class="btnposition" id="toggle_tbl3_3">
            <a class="imgbtn"><span onclick="AddRight()"><spring:message code='ezPortal.t62'/></span></a>
            <a class="imgbtn"><span onclick="close_onclick();"><spring:message code='ezPortal.t12'/></span></a>
	    </div>
	</div>
	</body>
	<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	<form method="post" id="form" name="form" enctype="multipart/form-data" action="/admin/ezPortal/portletImageUpload.do?mode=menu" target="ifrm" style ="display:none">
 	   <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="true" />
	    <input type="hidden" name="boardid" id="boardid" />
	    <input type="hidden" name="maxsize" id="maxsize" />
	    <input type="hidden" name="mode" id="mode" value="PHOTO"/>
	    <input type="hidden" name="cnt" id="cnt" />
	    <input type="hidden" name="mailgubun" id="mailgubun" />
	</form>
</html>