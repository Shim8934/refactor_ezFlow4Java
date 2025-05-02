<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezOrgan.t238" /></title>
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
		    var ReturnFunction;
		    var RetValue;
	    	var imageName="";
	    	var userPhoto = "";
	    	var picNone = "/images/default_pic.jpg";
	    	
			$(document).ready(function(){
				try {
		            RetValue = parent.personpicture_cross_dialogArguments[0];
		            ReturnFunction = parent.personpicture_cross_dialogArguments[1];
		            userPhoto = parent.personpicture_cross_dialogArguments[2];
		            if(userPhoto != ""){
		            	if(CrossYN()){
							preview.src = "";
							preview.style.visibility = "hidden";
							preview.src = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + userPhoto;
							preview.style.visibility = "visible";
							preview.setAttribute('onerror', "this.src='" + picNone + "'");
						} else {
							preview.src = "";
							preview.style.visibility = "hidden";
							preview.src = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + userPhoto;
							preview.style.visibility = "visible";
							preview.setAttribute('onerror', "this.src='" + picNone + "'");
						}
		            }
		            else {
		            	preview.src = "";
						preview.style.visibility = "hidden";
						preview.src = picNone;
						preview.style.visibility = "visible";
		            }
		        }catch(e){
		            try {
		                RetValue = opener.personpicture_cross_dialogArguments[0];
		                ReturnFunction = opener.personpicture_cross_dialogArguments[1];
		                userPhoto = opener.personpicture_cross_dialogArguments[2];
		                if(userPhoto != ""){
			            	if(CrossYN()){
							    preview.src = "";
								preview.style.visibility = "hidden";
								preview.src = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + userPhoto;
								preview.style.visibility = "visible";
								preview.setAttribute('onerror', "this.src='" + picNone + "'");
							} else {
								preview.src = "";
								preview.style.visibility = "hidden";
								preview.src = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + userPhoto;
								preview.style.visibility = "visible";
								preview.setAttribute('onerror', "this.src='" + picNone + "'");
							}
			            }
		                else {
			            	preview.src = "";
							preview.style.visibility = "hidden";
							preview.src = picNone;
							preview.style.visibility = "visible";
			            }
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
			});
			
			function btnimagefile_onclick(ocx_file){
			    try {
			    	if(CrossYN()){
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
			            var RemotePath =document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/admin/ezOrgan/signImageUploadIe9.do?mode=PICTURE&userID=" + RetValue;
			            var nCount = document.all.EzHTTPTrans.StartUpload(RemotePath,"",RetValue,"","");
			            if (nCount == 0)
			            {
			                alert(imgName + "<spring:message code='ezOrgan.t135'/>");
			                return false;
			            }
			            for (var i = 0; i < nCount; i++) {
				            var fileinfo = EzHTTPTrans.GetReturn(i);
					        var infos = fileinfo.split('/')	;  
					        var pfileName = infos[0].substr(infos[0].lastIndexOf("\\")+1);
					        var fileName = infos[1];
			            }
			            fileupafter(fileName.substr(3,infos[1].length));
			    	}
				}catch(e){
					alert(e.discription);
				}
			}
			
			function fileupafter(value) {
	    		imagefile.value = value;
			}
			
			function imgtemp_onclick() {
	            if (document.form.file1.value != "") {
	            	if (document.getElementById("form").file1.files.length > 1) {
			            alert("<spring:message code='ezOrgan.x0001' />");
			        }
	            	
	            	var file1val = document.getElementById("file1").value;
					var exIndex = file1val.lastIndexOf('.');
				    var extension = file1val.substring(exIndex+1, file1val.length);
				    var check = false;
				    check = compareExtension(check, extension);
				    
				    if (!check) {
		    		    alert("<spring:message code='ezPersonal.t206'/>" + " <spring:message code='ezPersonal.t200'/>");
		        		document.getElementById("file1").value = "";
		    		}
					/* 2021-12-09 홍승비 - 사원 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 (실제 파일 업로드 이전에 ajax로 체크) */
					else if (checkImgExtension(extension) == "UPLOAD_EXT_ERROR") {
						document.getElementById("file1").value = "";
						alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
					}
					else {
			            var fd = new FormData();		            
			            fd.append("file1", document.getElementById("form").file1.files[0]);
			          
			            xhr = new XMLHttpRequest();
			            xhr.addEventListener("load", uploadComplete, false);
			            imageName = document.getElementById("form").file1.files[0].name;
			            xhr.open("POST", "/admin/ezOrgan/signImageUpload.do?mode=PICTURE&userID=" + RetValue);
			            xhr.send(fd);
		    		}
	            	
	            }
	        }
			
			function uploadComplete() {		        
		        if(xhr.responseText == "UPLOAD_ERROR"){
		        	alert("<spring:message code='ezBoard.hyj02' />");
		        	
		        	document.getElementById("file1").value = "";
		        	document.getElementById("tempFilePath").value = "";
		        }else{
		        	document.getElementById("tempFilePath").value = xhr.responseText;
		        	document.getElementById("imagefile").value = imageName;
		        }
		        
		        if(CrossYN()){
				    if (document.form.file1.value != "") {
				        preview.src = "";
						preview.style.visibility = "hidden";
						preview.src = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + document.getElementById("tempFilePath").value;
						preview.style.visibility = "visible";
					}
				} else {
					if(imagefile.value != "")
					{
						preview.src = "";
						preview.style.visibility = "hidden";
						preview.src = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + document.getElementById("imagefile").value;
						preview.style.visibility = "visible";
					}
				}
		        //returnvalue(xhr.responseText);
		    }
			
			function imgConfirm_onclick(obj) {
				if(CrossYN()){
					if (document.getElementById("form").file1.files.length == 0) {
			            alert("<spring:message code='ezOrgan.x0002' />");
			            return;
			        }
					var fileName = document.getElementById("tempFilePath").value;
				} else {
					var fileName = document.getElementById("imagefile").value;
				}
				
				/* 관리자가 사용자 프로필 이미지 수정후 저장시, temp파일 지우고 cn.jpg형식으로 수정  */
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezOrgan/saveUserImagebyTemp.do",
					data : {parentCn : "", cn : RetValue, prop : "", extensionAttribute2 : fileName},
					success : function(resultMap){
						var data = JSON.parse(resultMap);
						var status = data.status;
						if(status != "OK"){
							alert("<spring:message code='ezOrgan.t119' />");
						}else{
							if (ReturnFunction != null){
				                ReturnFunction(data.fileName, fileName);
							}else{
				                window.returnValue = data.fileName;
							}
				            window.close();
						}
					},
					error : function(){
						alert("<spring:message code='ezOrgan.t269' />");
					}
				});
			}
			
			function close_Click() {
			    //if(CrossYN()){
			    parent.DivPopUpHidden();
			    /* }else{
			        window.close();
			    } */
			}
			
			function divImageFile_onclick() {
				if(CrossYN()){
				    if (document.form.file1.value != "") {
				        preview.src = "";
						preview.style.visibility = "hidden";
						preview.src = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + document.getElementById("tempFilePath").value;
						preview.style.visibility = "visible";
					}
				} else {
					if(imagefile.value != "")
					{
						preview.src = "";
						preview.style.visibility = "hidden";
						preview.src = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + document.getElementById("imagefile").value;
						preview.style.visibility = "visible";
					}
				}
			}
	    </script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezOrgan.t240' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="close_Click()"></span></li>
            </ul>
        </div>
		<table class="content" style="height: 140px;"> 
			<tr>
		    	<th style="min-width:119px; height:128px;"><img <spring:message code='ezOrgan.i6' />></th>
		    	<td style="padding:5px">
		    	<c:if test="${!isCrossBrowser}">
		    	 	   <SCRIPT type="text/javascript">EzHTTPTrans_ActiveX("EzHTTPTrans");</SCRIPT>
		    	 </c:if>
		    		<spring:message code='ezOrgan.t241' /><br/>
		      		119*128px<spring:message code='ezOrgan.t10000' />
		      		<br/>
			  		<%-- <a class="imgbtn imgbck" style="margin-top:5px"><span onClick="divImageFile_onclick()"><spring:message code='ezOrgan.t244' /></span></a> --%>
			  	</td>
		  	</tr>
		</table>
		<table class="content" style="margin-top:7px"> 
			<tr>
		    	<th><spring:message code='ezOrgan.t245' /></th>
		    	<td width="100%">		    
		    		<input id=imagefile name=imagefile style=" WIDTH: 80%" readonly="readonly" />
		    		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		    		<form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm" >
		  				<input type="file" name="file1" id="file1" style="width: 1px; height: 1px; display:none;" onchange="imgtemp_onclick()" multiple="false" accept="image/*"/>
		    			<input type="hidden" name="mode" id="mode" />
		    			<input type="hidden" name="tempFilePath" id="tempFilePath" />
		    		</form>
					<a class="imgbtn imgbck" style="height: 22px; margin-bottom: 0px;"><span id="btnimagefile" onClick="btnimagefile_onclick()" style="width:25px; line-height: 23px; justify-content: center; display: flex;"><spring:message code='ezOrgan.t101' /></span></a>
				</td>
		  	</tr>
		</table>
		<div class="btnpositionNew">
		    <a class="imgbtn"><span onClick="imgConfirm_onclick();"><spring:message code='ezOrgan.t246' /></span></a>
		</div>		
	</body>
</html>