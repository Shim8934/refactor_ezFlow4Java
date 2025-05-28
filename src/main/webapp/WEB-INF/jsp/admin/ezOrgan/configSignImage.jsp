<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t185" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.form.js')}"></script>
	    <c:if test="${!isCrossBrowser}">
	      	<script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachMain.js')}"></script>
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachItem.js')}"></script>
		    <script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
	    </c:if>
	    <c:if test="${isCrossBrowser}">
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachMain_CK.js')}"></script>
		    <script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachItem_CK.js')}"></script>
	    </c:if>
		<script type="text/javascript" language="javascript">
			var userid = "<c:out value='${userID}'/>";
		    var SignImageSize = "<c:out value='${signImageSize}'/>";
		    var SignPath = "<c:out value='${signPath}'/>";
			
			$(document).ready(function(){
				GetSignInfo();
			});
			
			function GetSignInfo(){				
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/getEntryInfo.do",
					async : false,
					data : {cn : userid, prop : "extensionAttribute3", pMode : "user" },
					success : function(xml){
						result=loadXMLString(xml);
						xmlDom = result;
			            var signinfo = SelectSingleNodeValueNew(xmlDom,"DATA/EXTENSIONATTRIBUTE3");
						imagelist = signinfo.split(";");

						var length = signlist.length;
						for (var i=0; i<length; i++){
							signlist.options[0] = null;
						}
						if (signinfo != "" && trim(signinfo).replace('\n', '') != ""){
							for (var i=0; i<imagelist.length; i++){
								var newoption = new Option("<spring:message code='ezOrgan.t186' />" + i, imagelist[i]);
								signlist.options[i] = newoption;
							}
						}
					},
					error : function(){
						alert("<spring:message code='ezOrgan.t187' />");
					}
				});
			}			
			function trim(str){
		        while (str && str.indexOf(" ") == 0){
		            str = str.substring(1);
		        }
		        while (str && str.lastIndexOf(" ") == str.length - 1){
		            str = str.substring(0, str.length - 1);
		        }
		        return str;
		    }
			function sign_change() {
				/* if(SignPath == "APPROVAL"){
		        	signimage.innerHTML = "<img src=" + window.document.location.protocol + "//" + window.document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=" + SignPath + "&FILENAME=" + signlist.value + " width=50 height=50>";
				}else{
					signimage.innerHTML = "<img src=" + window.document.location.protocol + "//" + window.document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=" + SignPath + "&FILENAME=" + signlist.value + " width=50 height=50>";
				} */				
				var imgSrc = "/admin/ezOrgan/getApprovalSignInfo.do?type="+SignPath+"&fileName="+encodeURI(signlist.value);
				signimage.innerHTML = "<img src="+imgSrc+" width=50 height=50 />";
		    }			
			
			function add_sign(ocx_file) {
				if (CrossYN()) {
		        	document.getElementById('mode').value = "PHOTO";
		        	document.form.file1.click();
				} else {
					var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
					var imgName = "";
					
					if(!ocx_file)
	                {
	                    imgName = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0All Files (*.*)\0*.*\0\0", "");
	                    
	                    if (!imgName)
	                        return;
		            }
		            else
		            {
		                imgName = ocx_file.split("|");
		            }
		            
					var ezUtil = null;
					var fileNamelist = "";
					var fileName = "";

					 document.all.EzHTTPTrans.AddUploadFile("","");
	                
					try {
					    
						 document.all.EzHTTPTrans.AddUploadFile(imgName, "N");                   
					}
					catch (e) 
					{
						alert(imgName + "<spring:message code='ezOrgan.t135'/>" + "\n\n" + e.number + " - " + e.description);
						return;
					}	
					
				     if (SignPath == "APPROVALGSIGN") {
			            	mode = "GLOGO";
			            } else {
			            	mode = "LOGO";
			            }
				     
		            var RemotePath =document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/admin/ezOrgan/signImageUploadIe9.do?mode="+mode+"&userID=" + userid;
		            var nCount = document.all.EzHTTPTrans.StartUpload(RemotePath,"",userid,"","");
		            
		            if (nCount == 0)
		            {
		                alert(imgName + "<spring:message code='ezOrgan.t135'/>");
		                return false;
		            }
		            
		            var fileinfo = EzHTTPTrans.GetReturn(i);	
			        var infos = fileinfo.split('/')	;  
			        var pfileName = infos[0].substr(infos[0].lastIndexOf("\\")+1);
			        var fileName = infos[1];
			        
			        if (fileName.substr(0, 2) != "OK") {
				        alert(imgName + "<spring:message code='ezOrgan.t135'/>");
				        return;
			        } else{
			        	
			        var imagelist = "";
					for (var i = 0; i < signlist.length; i++)
					    imagelist += signlist.options[i].value + ";";
					if (imagelist == "")
					    imagelist = fileName.substr(3,infos[1].length);
					else
					    imagelist += fileName.substr(3,infos[1].length);
			        
					$.ajax({
						type : "POST",
						dataType : "text",
						url : "/admin/ezOrgan/saveUserInfo.do",
						data : {parentCn : "", cn : userid, prop : "", extensionAttribute3 : encodeURI(imagelist)},
						success : function(result){
							if(result != "OK"){
								alert("<spring:message code='ezOrgan.t119' />");
							}else{
								GetSignInfo();
							}
						},
						error : function(){
							alert("<spring:message code='ezOrgan.t269' />");
						}
					});
			        }
				}
		    }
			function del_sign()	{
				if (signlist.selectedIndex == -1) {
					alert("<spring:message code='ezOrgan.t188' />");
					return;
				}

				if (!confirm("'" + signlist.options[signlist.selectedIndex].text + "'<spring:message code='ezOrgan.t130' />")) {
					return;
				}
				
				var imagelist = "";
				for (var i=0; i<signlist.length; i++) {
					if (i != signlist.selectedIndex) {
						if (imagelist != "") {
							imagelist += ";" + signlist.options[i].value;
						} else {
							imagelist = signlist.options[i].value;
						}
					}
				}
				
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/saveUserInfo.do",
					data : {parentCn : "", cn : userid, prop : "", extensionAttribute3 : imagelist},
					success : function(result){
						if(result != "OK"){
							alert("<spring:message code='ezOrgan.t189' />");
						}else{
							alert("<spring:message code='ezOrgan.t190' />");
							signimage.innerHTML ="<B><spring:message code='ezOrgan.t191' /></B>";
							GetSignInfo();
						}
					},
					error : function(){
						alert("<spring:message code='ezOrgan.t189' />");
					}
				});			   
			}			
			function btn_AttachAdd_onclick(obj) {
				var mode = "";
		        if (document.form.file1.value != "") {
		        	// TODO : 2016-04-22 장진혁과장 --우선적으로 서명 1개만 등록할 수 있도록 구현
		            if (document.getElementById('mode').value == "PHOTO") {
		                if (document.getElementById("form").file1.files.length > 1) {
				            alert("<spring:message code='ezOrgan.x0001' />");
				        }
		            }
		            var file1val = document.getElementById("file1").value;
		            var exIndex = file1val.lastIndexOf(".");
		            var extension = file1val.substring(exIndex+1, file1val.lenght);
		            var check = false;
		            check = compareExtension(check, extension);

		            if (!check) {
		                document.getElementById("file1").value = "";
		                alert("<spring:message code='main.t4000'/>");
		                return;
		            }
		            /* 2021-12-09 홍승비 - 서명 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 (실제 파일 업로드 이전에 ajax로 체크) */
					if (checkImgExtension(extension) == "UPLOAD_EXT_ERROR") {
						document.getElementById("file1").value = "";
						alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
						return;
					}
		            
		            var fd = new FormData();
		            
		            var file =  document.getElementById("form").file1.files;
		            for (var i = 0; i < file.length; i++) {
		                fd.append("file1", file[i]);
		            }
		            
// 		         	// TODO : 2016-04-22 장진혁과장 --우선적으로 서명 1개만 등록할 수 있도록 구현
// 		            fd.append("file1", document.getElementById("form").file1.files[0]);
		            
		            xhr = new XMLHttpRequest();
		            xhr.addEventListener("load", uploadComplete, false);
		            
		            if (SignPath == "APPROVALGSIGN") {
		            	mode = "GLOGO";
		            } else {
		            	mode = "LOGO";
		            }
		            
		            xhr.open("POST", "/admin/ezOrgan/signImageUpload.do?mode="+mode+"&userID=" + userid);
		            xhr.send(fd);
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
		    
			function uploadComplete() {		        
		        if(xhr.responseText.split("/")[0] == "UPLOAD_ERROR"){
		        	alert("<spring:message code='ezBoard.hyj02' />");
		        	
		        	document.getElementById("file1").value = "";
		        	document.getElementById("tempFilePath").value = "";
		        }else{
		        	document.getElementById("tempFilePath").value = xhr.responseText.split("/")[0];		        			        	
		        	var fileName = encodeURI(xhr.responseText.split("/")[0]);
		            
		        	var imagelist = "";
		            for (var i = 0; i < signlist.length; i++)
		                imagelist += signlist.options[i].value + ";";

		            if (imagelist == "")
		                imagelist = fileName;
		            else
		                imagelist += fileName;
		            
					$.ajax({
						type : "POST",
						dataType : "text",
						url : "/admin/ezOrgan/saveUserInfo.do",
						data : {parentCn : "", cn : userid, prop : "", extensionAttribute3 : imagelist},
						success : function(result){
							if(result != "OK"){
								alert("<spring:message code='ezOrgan.t119' />");
							}else{
								GetSignInfo();
							}
						},
						error : function(){
							alert("<spring:message code='ezOrgan.t269' />");
						}
					});
		        }		      
		    }
	    </script>
	    <c:if test="${!isCrossBrowser}">
	      <script type="text/javascript" FOR="EzHTTPTrans" EVENT="AttachAddFile(filename)">
	        add_sign(filename);
        </script>
        </c:if>
	</head>
	<body class="popup"> 
		<h1><spring:message code='ezOrgan.t194' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<table class="popuplist" style="width:100%;"> 
			<tr> 
		    	<th><spring:message code='ezOrgan.t195' /></th> 
		    	<th><h2><spring:message code='ezOrgan.t140' /></h2></th> 
		  	</tr> 
		  	<tr> 
		    	<td style="padding:3px; width: 50%;"> 
		    		 <c:if test="${!isCrossBrowser}">
		    	 	   <SCRIPT type="text/javascript">EzHTTPTrans_ActiveX("EzHTTPTrans");</SCRIPT>
		    	 	 </c:if>
		    		<select id="signlist" size="10" style="overflow:auto;width:100%;height:150px;border:0px;background:none;" onChange="sign_change()"> </select>
		    	</td> 
		    	<td id="signimage" style="width:150px;height:150px;text-align:center" class="point"><spring:message code='ezOrgan.t191' /></td> 
		  	</tr> 
		</table> 
		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm">
			<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px; display: none;" accept="image/*" />
			<input type="hidden" name="mode" id="mode" />
			<input type="hidden" name="tempFilePath" id="tempFilePath" />
		</form>		
		<div class="btnpositionNew">
		    <a class="imgbtn" onClick="add_sign()"><span><spring:message code='ezOrgan.t141' /></span></a>
		    <a class="imgbtn" onClick="del_sign()"><span><spring:message code='ezOrgan.t142' /></span></a>
		</div>		
	</body>
</html>