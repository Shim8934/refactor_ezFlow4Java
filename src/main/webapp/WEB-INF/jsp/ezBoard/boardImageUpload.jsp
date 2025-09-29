<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t5000'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
		    var guid = "{" + GetGUID() + "}";
		    var tempfilename;
		    var savefilename;
		    var g_xmlhttp;
		    function SliderImage() {
	            if (CrossYN())
	                document.getElementById("file1").click();
	            else {
	                var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
	                var filepath = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx\0All Files (*.*)\0*.*\0\0", "");
	                if (filepath == "") return;
	
	                var strBase64 = ezUtil.DownloadToBase64(filepath);
	                ezUtil = null;
	
	                var ezUtil = new ActiveXObject("ezUtil.ImageFunc");
	                var temp = ezUtil.GetImageSize(filepath);
	                ezUtil = null;
	
	                imageWidth = temp.split("*")[0];
	                imageHeight = temp.split("*")[1];
	
	                document.getElementById("imagewidth").value = imageWidth;
	                document.getElementById("imageheight").value = imageHeight;
	
	                tempfilename = filepath.substr(filepath.lastIndexOf("\\") + 1);
	                var strXML = "<IMAGE><OLDFILENAME>" + tempfilename + "</OLDFILENAME><FILENAME>" + guid + "</FILENAME><DATA>" + strBase64 + "</DATA></IMAGE>";
	
	                g_xmlhttp = createXMLHttpRequest();
	                g_xmlhttp.open("POST", "/myoffice/ezBoardSTD/interASP/upload_backimage.aspx", true);
	                g_xmlhttp.onreadystatechange = changeSliderImage_end;
	                g_xmlhttp.send(strXML);
	            }
		    }
		
		    function changeSliderImage_end() {
		        if (g_xmlhttp.readyState != 4)
		        	return;
		        UploadSliderImage.src = "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=BOARDBACKGROUND&ATTID=" + g_xmlhttp.responseText;
		        savefilename = g_xmlhttp.responseText;
		    }
		
		    function btn_AttachAdd_onclick() {
				var file1val = document.getElementById("file1").value;
		        var exIndex = file1val.lastIndexOf('.');
				var extension = file1val.substring(exIndex+1, file1val.lenght);
		        var check = false;
		        check = compareExtension(check, extension);	
		        
		        if (!check) {
		        	document.getElementById("file1").value = "";
		        	savefilename = "";
		        	alert("<spring:message code ='ezBoard.hsbImg01' />");
					return;
		        }
		
		        var fd = new FormData();
	            fd.append("file1", document.getElementById("form").file1.files[0]);
	            
	            xhr = new XMLHttpRequest();
	            xhr.addEventListener("load", UploadComplete, false);
	            xhr.open("POST", "/ezBoard/uploadBackImage.do");
	            xhr.send(fd);

		    }
		    var fileinfo = new Array();
		    function UploadComplete() {
		    	filepath = xhr.responseText;
		        fileinfo = filepath.split("|!|");
		        UploadSliderImage.src = fileinfo[0];
		        UploadSliderImage.style.display = "";
		        var widthOrigin = fileinfo[1];
				var heightOrigin = fileinfo[2];				
				var per = 720 / widthOrigin;
				var height = Math.floor(heightOrigin * per);

		        savefilename = fileinfo[0];
		        document.getElementById("imagewidth").value = "720";
		        document.getElementById("imageheight").value = height;
		    }
		
		    function compareExtension(check, extension) {
		        var filterExtension = new Array("jpe", "jpg", "jpeg", "gif", "png", "bmp", "ico", "svg", "svgz", "tif", "tiff", "ai", "drw", "pct", "psp", "xcf", "psd", "raw");
		        for (var i = 0; i < filterExtension.length; i++) {
		            if (extension.toLowerCase() == filterExtension[i]) {
		                check = true;
		                break;
		            }
		        }
		        return check;
		    }
		
		    function btnSave_click() {
		        if (document.getElementById("imagewidth").value < 1 || isNaN(document.getElementById("imagewidth").value) || document.getElementById("imageheight").value < 1 || isNaN(document.getElementById("imageheight").value)) {
		            return;
		        }
		        if (document.getElementById("UploadSliderImage").src.indexOf("fileroot") == -1) {
		            return;
		        }
		        fileinfo[0] = savefilename;
		        fileinfo[1] = document.getElementById("imagewidth").value;
		        fileinfo[2] = document.getElementById("imageheight").value;
		
		        window.opener.backgroundImgUpload_After(fileinfo);
		        window.close();
		    }
		
		    function S4() {
		        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
		    }
		
		    function GetGUID() {
		        return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
		    }
		
		    window.onload = function () {
		        try {
		            document.getElementById("file1").multiple = false;
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
		            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126) {
		                return false;
		            }
		            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
		                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
		                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
		                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
		                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
		                return false;
		        };
		    }
		
		    function imgdisplay() {
		        UploadSliderImage.style.display = "";
		    }
		</script>
	</head>
	<body class="popup" style="overflow:hidden">
	    <h1 style="margin-bottom:5px"><spring:message code='ezBoard.t5000'/></h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
	    <table style="width:100%" id="toggle_tbl1" class="content">
			<tr>
				<th>
					<a class="imgbtn"><span onclick="SliderImage()"><spring:message code='ezBoard.t5001'/></span></a>
				</th>
				<td colspan="3">
					<table style="width:471px;height:217px" border="0">
						<tr>
							<td id="tdNormalImage" style="width:467px;height:200px">
								<img id="UploadSliderImage" src="" onload ="imgdisplay()" style="width:467px;height:200px;display:none">
							</td>
						</tr>
					</table>
				</td>
			</tr>
	        <tr>
	            <th><spring:message code='ezBoard.t5002'/></th>
	            <td>&nbsp;<input type="text" id="imagewidth" readonly style="cursor:default; background-color:#f8f8fa;" />&nbsp;px</td>
	            <th><spring:message code='ezBoard.t5003'/></th>
	            <td>&nbsp;<input type="text" id="imageheight" />&nbsp;px</td>
	        </tr>
		</table>
	    <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="btnSave_click();"><spring:message code='ezBoard.t98'/></span></a>
	    </div>
	    <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	     <form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm" style="display:none;">
	        <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" accept="image/*" />
	        <input type="hidden" name="boardid" id="boardid" />
	        <input type="hidden" name="maxsize" id="maxsize" />
	        <input type="hidden" name="mode" id="mode" value="SLIDERIMAGE"/>
	        <input type="hidden" name="cnt" id="cnt" />
	        <input type="hidden" name="mailgubun" id="mailgubun" />
	    </form>
	</body>
</html>