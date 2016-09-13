<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var guid = "{" + GetGUID() + "}";
		    var tempfilename;
		    var g_xmlhttp;
		    var sliderid = "<c:out value = '${sliderid}' />";
		    var ReturnFunction;
		    var pNoneActiveX = "YES";
		    function SliderImage() {
		        if (CrossYN() || pNoneActiveX == "YES") {
		            document.getElementById("file1").click();
		        } else {
// 		            var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
// 		            var filepath = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0All Files (*.*)\0*.*\0\0", "");
// 		            if (filepath == "") return;
	
// 		            var strBase64 = ezUtil.DownloadToBase64(filepath);
// 		            ezUtil = null;
	
// 		            var ezUtil = new ActiveXObject("ezUtil.ImageFunc");
// 		            var temp = ezUtil.GetImageSize(filepath);
// 		            ezUtil = null;
	
// 		            imageWidth = temp.split("*")[0];
// 		            imageHeight = temp.split("*")[1];
// 		            tempfilename = filepath.substr(filepath.lastIndexOf("\\") + 1);
// 		            var strXML = "<IMAGE><OLDFILENAME>" + tempfilename + "</OLDFILENAME><FILENAME>" + guid + "</FILENAME><DATA>" + strBase64 + "</DATA></IMAGE>";
	
// 		            g_xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
// 		            g_xmlhttp.open("POST", "aspx/UploadSliderImage.aspx?mode=SLIDERIMAGE", true);
// 		            g_xmlhttp.onreadystatechange = changeSliderImage_end;
// 		            g_xmlhttp.send(strXML);
		        }
		    }
	
		    function changeSliderImage_end() {
		        if (g_xmlhttp.readyState != 4) {
		        	return;
		        }
	
		        UploadSliderImage.src = g_xmlhttp.responseText;
		    }
	
		    function btn_AttachAdd_onclick() {
		        var extension = document.getElementById("file1").value.split('.');
		        var check = false;
		        check = compareExtension(check, extension[1]);
	
		        if (!check) {
		            alert("<spring:message code = 'ezPersonal.t206' />" + " <spring:message code = 'ezPersonal.t200' />");
		            document.getElementById("file1").value = "";
		        }
	
		        
		        var frm = document.getElementById('form');
	            var form = new FormData(frm);
		        
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/saveSliderImage.do",
		        	async : false,
		        	data : form,
		        	processData : false,
	            	contentType : false,
		        	success : function (result) {
		        		retrunvalue(result);
		        	}
		        });
		        document.form.file1.value = "";
		    }
		    
		    var xml;
		    function retrunvalue(result) {
		        xml = result;
		        var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
		        for (var i = 0; i < nodes.length; i++) {
		            if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
		                if (getNodeText(GetChildNodes(nodes[i])[3]) == 0) {
		                    alert(strLang6);
		                    return;
		                }
		                
		                if (navigator.userAgent.indexOf("Firefox") != -1) {
		                    UploadSliderImage.src = getNodeText(GetChildNodes(nodes[i])[4]);
		                } else {
		                    UploadSliderImage.src = getNodeText(GetChildNodes(nodes[i])[4]);
		                }
		                
		                UploadSliderImage.style.display = "";
		            } else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
		                alert(strLang8 + AttachLimit + "MB" + strLang9);
		                return;
		            } else {
		                alert(filename + " <spring:message code = 'ezPersonal.lhj01' />" + "\n\n" + result);
		            }
		        }
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
		        if (document.getElementById("txtDisplayName").value == "") {
		            alert("<spring:message code = 'ezPersonal.t1027' />");
		            return;
		        } else if (document.getElementById("txtDisplayName2").value == "") {
		            alert("<spring:message code = 'ezPersonal.t1027' />");
		            return;
		        } else if (document.getElementById("UploadSliderImage").src.indexOf("upload_portal") == -1) {
		            alert("<spring:message code = 'ezPersonal.t20000' /> ");
		            return;
		        }
		        
		        var strXML = "";
		        var SliderImgPath = UploadSliderImage.src.substr(UploadSliderImage.src.indexOf("/Upload_Portal"));
		        
		        if (sliderid == "") {
		            strXML += "<DATA><SLIDERID>" + guid + "</SLIDERID>";
		            strXML += "<MODE>NEW</MODE>";
		        } else {
		            strXML += "<DATA><SLIDERID>" + sliderid + "</SLIDERID>";
		            strXML += "<MODE>MOD</MODE>";
		        }
		        
		        strXML += "<DISPLAYNAME>" + txtDisplayName.value + "</DISPLAYNAME>";
		        strXML += "<DISPLAYNAME2>" + txtDisplayName2.value + "</DISPLAYNAME2>";
		        
		        if (CrossYN()) {
		            strXML += "<FILENAME>" + getNodeText(SelectNodes(xml, "ROOT/NODES/NODE/PFILENAME")[0]) + "</FILENAME>";
		        } else {
		            strXML += "<FILENAME>" + tempfilename + "</FILENAME>";
		        }
		        
		        strXML += "<SLIDERIMAGE>" + SliderImgPath + "</SLIDERIMAGE></DATA>";
	
		        var xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "aspx/SaveSlider.aspx", false);
		        xmlhttp.send(strXML);
		        
		        if (xmlhttp.responseText == "OK") {
		            alert("<spring:message code = 'ezPersonal.t191' />");
		            
		            if (ReturnFunction != null) {
		                ReturnFunction();
		            }
		            
		            window.close();
		            
		        } else {
		            alert("<spring:message code = 'ezPersonal.t192' />");
		        }
		        
		        xmlhttp = null;
		    }
	
		    function S4() {
		        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
		    }
	
		    function GetGUID() {
		        return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
		    }
	
		    $(document).ready(function () {
		        try {
		            ReturnFunction = parent.selectimage_dialogArguments[1];
		        } catch (e) {
		            try {
		                ReturnFunction = opener.selectimage_dialogArguments[1];
		            } catch (e) {
	
		            }
		        }
		        
		        try {
		            var ua = navigator.userAgent;
		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		                KeEventControl(document.getElementById("txtDisplayName"));
		                KeEventControl(document.getElementById("txtDisplayName2"));
		            }
		        } catch (e) { }
		        
		        if (sliderid != "") {
	/* 	            g_xmlhttp = null;
		            g_xmlhttp = createXMLHttpRequest();
	
		            var xmlDom = createXmlDom();
		            var objNode;
		            g_xmlhttp.open("POST", "aspx/GetSlider.aspx?item=" + sliderid + "", true);
		            g_xmlhttp.onreadystatechange = event_Get_itemComplite;
		            g_xmlhttp.send(xmlDom);
		             */
		            $.ajax({
			        	type : "POST",
			        	url : "/admin/ezPersonal/getSlider.do",
			        	async : false,
			        	data : {item : sliderid},
			        	success : function (result) {
			        		event_Get_itemComplite(result);
			        	}
			        });
		            
		        }
		    });
		    
		    function event_Get_itemComplite(result) {
		        /* if (g_xmlhttp == null || g_xmlhttp.readyState != 4) {
		            return;
		        } */
		        
		        /* if (g_xmlhttp.status >= 200 && g_xmlhttp.status < 300) { */
		            var xml = result;
		            document.getElementById("txtDisplayName").value = getNodeText(SelectSingleNodeNew(xml, "DATA/ROW/SLIDERNAME"));
		            document.getElementById("txtDisplayName2").value = getNodeText(SelectSingleNodeNew(xml, "DATA/ROW/SLIDERNAME2"));
		            document.getElementById("UploadSliderImage").src = getNodeText(SelectSingleNodeNew(xml, "DATA/ROW/IMAGEPATH"));
		            document.getElementById("UploadSliderImage").style.display = "";
		         /*    g_xmlhttp = null;
		        } */
		    }
		    function KeEventControl(obj) {
		        useragt = navigator.userAgent.toUpperCase();
		        
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) {
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
		                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32) {
		            	return false;
		            }
		        };
		    }
	
		    function imgdisplay() {
		        UploadSliderImage.style.display = "";
		    }
		</script>
	</head>
	<body class = "popup" style = "overflow:hidden">
		<h1><spring:message code = 'ezPersonal.t20001' /></h1>
	    <h2><spring:message code = 'ezPersonal.t20002' /></h2>
	    <table style="width:500px" id="toggle_tbl1" class="content">
			<tr>
				<th>
					<spring:message code = 'ezPersonal.t304' />
				</th>
				<td>
				    <table>
	                    <tr class="primary">
		                    <th><spring:message code = 'ezPersonal.s81' /></th>
		                    <td><input type="text" id="txtDisplayName" style="width: 100%"></td>	
	                    </tr>
	                    <tr class="secondary">
		                    <th><spring:message code = 'ezPersonal.s82' /></th>
		                    <td><input type="text" id="txtDisplayName2" style="width:100%"></td>	
	                    </tr>
	                </table>
				</td>
			</tr>
			<tr>
				<th>
					<a class="imgbtn"><span onclick="SliderImage()"><spring:message code = 'ezPersonal.t20003' /></span></a>
				</th>
				<td>
					<table style="width:471px;height:217px" border="0">
						<tr>
							<td id="tdNormalImage" style="width:467px;height:200px">
								<img id="UploadSliderImage" src="" onload ="imgdisplay()" style="width:467px;height:200px;display:none">
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	    <div class="btnposition">
	        <a href="#" class="imgbtn"><span onclick="btnSave_click();"><spring:message code = 'ezPersonal.t34' /></span></a>
	        <a href="#" class="imgbtn"><span onclick="return window.close();"><spring:message code = 'ezPersonal.t13' /></span></a>
	    </div>
	    <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	     <form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm" style="width:1px;height:1px">
	        <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="false" />
	        <input type="hidden" name="boardid" id="boardid" />
	        <input type="hidden" name="maxsize" id="maxsize" />
	        <input type="hidden" name="mode" id="mode" value="sliderImage"/>
	        <input type="hidden" name="cnt" id="cnt" />
	        <input type="hidden" name="mailgubun" id="mailgubun" />
	    </form>
	</body>
</html>