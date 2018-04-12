<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>${clubVO.c_ClubName } <spring:message code = 'ezCommunity.t495' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<style>
		span.filename1{	
		    vertical-align: middle;
		    position: absolute;
		    margin-top: 15px;
		    width: 94px;
		    white-space: nowrap;
		    text-overflow: ellipsis;
		    overflow: hidden;
		}
		span.filename2{
			vertical-align: middle;
		    position: absolute;
		    margin-top: 15px;
		    width: 370px;
		    white-space: nowrap;
		    text-overflow: ellipsis;
		    overflow: hidden;
		}
		img.prev{
			float:right;
			height:36px;
			margin-top:3px;
			margin-right:2px;
			margin-bottom:3px;
		}
		
		</style>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var checkValue = "type1";
			var CopType = "<c:out value = '${clubVO.c_Type}' />";
			var logosrc = "${clubVO2.c_Logo}";
			var thumbsrc = "${clubVO2.c_Logo_Thumbnail}";

			window.onload = function () {				
		        if (CopType != null) {
		            var imgCnt = document.getElementsByName("radType").length;
		            
		            for (var i = 0; i < imgCnt; i++) {
		                if (document.getElementsByName("radType")[i].value == CopType) {
		                    document.getElementsByName("radType")[i].checked = true;
		                    checkValue = document.getElementsByName("radType")[i].value;
		                }
		            }
		        }
		        
		        if (logosrc.indexOf("default_logo_") > -1) {
		        	document.getElementById("logoprev").src = "/images/ezCommunity/logo/" + logosrc, "C_LOGO";
                } else {
                	document.getElementById("logoprev").src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYLOGO&fileName=" + logosrc, "C_LOGO";
                }
		        if (thumbsrc.indexOf("default_logo_empty") > -1) {
		        	document.getElementById("thumbprev").src = "/images/ezCommunity/logo/" + thumbsrc, "C_LOGO_THUMBNAIL";
                } else {
                	document.getElementById("thumbprev").src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYTHUM&fileName=" + thumbsrc, "C_LOGO_THUMBNAIL";
                }
		        document.getElementById("logoprev").style.display = "";
		        document.getElementById("thumbprev").style.display = "";
		        
		        if (CrossYN()) {
		            document.getElementById("logo").style.width = "1px";
		            document.getElementById("logo").style.height = "1px";
		        } else {
		            document.getElementById("logo").style.position = "absolute";
		            document.getElementById("logo").style.filter = "alpha(opacity = 0)";
		            document.getElementById("logo").style.cursor = "pointer";

		            if (userLang == "1") {
		                document.getElementById("logo").style.left = "110px";
		                document.getElementById("logo").style.width = "75px";
		                document.getElementById("logo").style.height = "22px";
		            } else if (userLang == "2") {
		                document.getElementById("logo").style.left = "145px";
		                document.getElementById("logo").style.width = "50px";
		                document.getElementById("logo").style.height = "22px";
		            } else if (userLang == "3") {
		                document.getElementById("logo").style.left = "138px";
		                document.getElementById("logo").style.width = "95px";
		                document.getElementById("logo").style.height = "22px";
		            } else {
		                document.getElementById("logo").style.left = "90px";
		                document.getElementById("logo").style.width = "75px";
		                document.getElementById("logo").style.height = "22px";
		            }
		        }
		    }
			
		    function cancle_onclick() {
		        if (!confirm("<spring:message code = 'ezCommunity.t449' />")) {
				        return;
				    }
		        image.reset();
		        window.location.reload(true);
		//        if (window.parent.parent.opener != null)
			//	    window.parent.parent.opener.location.reload();
				}
		    
		        function close_onclick() {
/* 		            if(window.parent.parent.opener != null) {
		                window.parent.parent.opener.location.reload();
		            } */
		            image.reset();
		            parent.parent.window.close();
		        }
		        
				function pre_onclick() {
				    if (image.logo.value != "") {
				        if (window.parent.parent.opener != null) {
				            window.parent.parent.opener.coplogo.src = image.logo.value;
				            window.parent.parent.opener.coplogo.style.visibility = "visible";
				        }
				    }
				}
				
				function go() {
				    if(window.parent.parent.opener != null) {
				    	document.getElementById("imageSrc").value = window.parent.parent.opener.coplogo.src;
				    	<c:if test="${isCrossBrowser == true}">
							image.submit();
						</c:if>
				        <c:if test="${isCrossBrowser != true}">
				        	adminLogoUpload();
				        	adminThumbUpload();
				        	window.location.reload(true);
				        </c:if>
				    } else {
				    }
		        }

		        //로고, 베너 등록 시 이미지 파일 확장자가 아닐 때 비교하는 함수 추가_2013.01.30
		        function compareExtension(check, extension) {
		            var filterExtension = new Array("jpe", "jpg", "jpeg", "gif", "png", "bmp", "ico", "svg", "svgz", "tif", "tiff", "ai", "drw", "pct", "psp", "xcf", "psd", "raw");
		            
		            for (var i = 0; i < filterExtension.length; i++) {
		                if (extension.toLowerCase() == filterExtension[i]) {
		                    check = "true";
		                    break;
		                }
		            }
		            return check;
		        }

		        function logo_onpropertychange() {
					var logoFile = $("#logo")[0].files[0];
					
					if (logoFile == null) {
						return ;
					}
					
					formData = new FormData();
		        	formData.append('code', $("#code").val());
		        	formData.append('type', $("#Type").val());
		        	formData.append('logoFile', $("#logo")[0].files[0]);
		        	
		        	$.ajax({
		        		type : "POST",
		        		url : "/ezCommunity/adminLogoUpload.do",
		        		data : formData,
		        		cache : false,
		                async : false,
		                contentType : false,
		                processData : false,
		        		dataType : "json",
		        		success : function (result) {
		        			tempLogoPath = result["tempLogoPath"];
		        			
		        			var check = "false";
				            
				            document.getElementById("filename1").innerText = logoFile.name;
				            
				            var extension = logoFile.name.split('.');
				            check = compareExtension(check, extension[1]);
				            
				            if (check == "false") {
				                alert("<spring:message code ='ezCommunity.lhj03' />");
				                tempLogoPath = "";
				            }
				            
				            if (tempLogoPath != "") {
				          //상단이미지 미리보기
				          document.getElementById("logoprev").src = tempLogoPath;
				          document.getElementById("logoprev").style.display = "";
				            } else {
				                image.reset();
				            }
		        		}
		        	});
		        }
	
		        //2018-04-11 썸네일 추가 및 미리보기
		        function thumb_onpropertychange() {
					var thumbFile = $("#thumb")[0].files[0];
					
					if (thumbFile == null) {
						return ;
					}
					
					formData = new FormData();
		        	formData.append('code', $("#code").val());
		        	formData.append('type', $("#Type").val());
		        	formData.append('thumbFile', $("#thumb")[0].files[0]);
		        	
		        	$.ajax({
		        		type : "POST",
		        		url : "/ezCommunity/adminThumbUpload.do",
		        		data : formData,
		        		cache : false,
		                async : false,
		                contentType : false,
		                processData : false,
		        		dataType : "json",
		        		success : function (result) {
		        			tempThumbPath = result["tempThumbPath"];
		        			
		        			var check = "false";
				            
				            document.getElementById("filename2").innerText = thumbFile.name;
				            
				            var extension = thumbFile.name.split('.');
				            check = compareExtension(check, extension[1]);
				            
				            if (check == "false") {
				                alert("<spring:message code ='ezCommunity.lhj03' />");
				                tempThumbPath = "";
				            }
				            
				            if (tempThumbPath != "") {
				          //썸네일 이미지 미리보기
				          document.getElementById("thumbprev").src = tempThumbPath;
				          document.getElementById("thumbprev").style.display = "";
				            } else {
				                image.reset();
				            }
		        		}
		        	});
		        }
		        
		        function radioClick(obj, type) {
		            if (type == "img") {
		                var imgCnt = document.getElementsByName("radType").length;
		                
		                for (var i = 0; i < imgCnt; i++) {
		                    if (document.getElementsByName("radType")[i].value == obj.id) {
		                        document.getElementsByName("radType")[i].checked = true;
		                        checkValue = document.getElementsByName("radType")[i].value;
		                    }
		                }
		            } else {
		                checkValue = obj.value;
		            }
		            
		            document.getElementById("Type").value = checkValue;
		        }
		        
		        function btn_AttachSelect_onclick() {
		            document.getElementById("logo").click();
		        }
		        
		        function btn_AttachSelectThumb_onclick() {
		            document.getElementById("thumb").click();
		        }
		        
		        <c:if test="${isCrossBrowser == false}">
					var filesize = "";
					var filepath = "";
					var strBase64 = "";
			        function btn_AttachAdd_onclick() {
			            var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
			            filepath = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0All Files (*.*)\0*.*\0\0", "");
			            
			            if (filepath == "") return;
			            
			            strBase64 = ezUtil.DownloadToBase64(filepath);
			            filesize = ezUtil.getFileSize(filepath)
			            ezUtil = null;
		
			            var ezUtil = new ActiveXObject("ezUtil.ImageFunc");
			            var temp = ezUtil.GetImageSize(filepath);
			            ezUtil = null;
		
			            imageWidth = temp.split("*")[0];
			            imageHeight = temp.split("*")[1];
		
			            fileName = filepath.substr(filepath.lastIndexOf("\\") + 1);
			            
			            document.getElementById("filename1").innerHTML = fileName;
			            
			            var check = "false";
			            var extension = filepath.split('.');
			            check = compareExtension(check, extension[1]);

			            if (check == "false") {
			                alert("<spring:message code ='ezCommunity.lhj03' />");
			                logo = "";
			            }

			            if (filepath != "") {
			                window.parent.parent.opener.coplogo.src = filepath;
			                window.parent.parent.opener.coplogo.style.visibility = "visible";
			            } else {
			                image.reset();
			            }
			        }
			        
			        function btn_AttachAddThumb_onclick() {
			            var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
			            filepath = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0All Files (*.*)\0*.*\0\0", "");
			            
			            if (filepath == "") return;
			            
			            strBase64 = ezUtil.DownloadToBase64(filepath);
			            filesize = ezUtil.getFileSize(filepath)
			            ezUtil = null;
		
			            var ezUtil = new ActiveXObject("ezUtil.ImageFunc");
			            var temp = ezUtil.GetImageSize(filepath);
			            ezUtil = null;
		
			            imageWidth = temp.split("*")[0];
			            imageHeight = temp.split("*")[1];
		
			            fileName = filepath.substr(filepath.lastIndexOf("\\") + 1);
			            
			            document.getElementById("filename2").innerHTML = fileName;
			            
			            var check = "false";
			            var extension = filepath.split('.');
			            check = compareExtension(check, extension[1]);

			            if (check == "false") {
			                alert("<spring:message code ='ezCommunity.lhj03' />");
			                thumb = "";
			            }

			            if (filepath == "") {
			                image.reset();
			            }
			        }
			        
			        function adminLogoUpload() {
			        	var result;
			        	var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
			            
			            if (filepath == "") return;
			            
			            ezUtil = null;
		
			            var ezUtil = new ActiveXObject("ezUtil.ImageFunc");
			            var temp = ezUtil.GetImageSize(filepath);
			            ezUtil = null;
		
			            imageWidth = temp.split("*")[0];
			            imageHeight = temp.split("*")[1];
		
			            fileName = filepath.substr(filepath.lastIndexOf("\\") + 1);
			            
			           	$.ajax({
			            	type : "POST",
			            	url : "/ezCommunity/adminLogoUploadIE9.do",
			            	async : false,
			            	data : {
			            		fileName : fileName,
			            		fileData : strBase64,
			            		code : $("#code").val(),
			            		type : $("#Type").val(),
			            		imageSrc : $("#imageSrc").val()
			            	},
			            	dataType : "json",
			            	success : function(result) {
			            		if (result.result == true) {
			            			window.location.href = "/ezCommunity/adminLogoIE9Ok.do?code=" + $("#code").val();
			            		}
			            	}
			            });
			        }
			        function adminThumbUpload() {
			        	var result;
			        	var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
			            
			            if (filepath == "") return;
			            
			            ezUtil = null;
		
			            var ezUtil = new ActiveXObject("ezUtil.ImageFunc");
			            var temp = ezUtil.GetImageSize(filepath);
			            ezUtil = null;
		
			            imageWidth = temp.split("*")[0];
			            imageHeight = temp.split("*")[1];
		
			            fileName = filepath.substr(filepath.lastIndexOf("\\") + 1);
			            
			           	$.ajax({
			            	type : "POST",
			            	url : "/ezCommunity/adminThumbUploadIE9.do",
			            	async : false,
			            	data : {
			            		fileName : fileName,
			            		fileData : strBase64,
			            		code : $("#code").val(),
			            		type : $("#Type").val(),
			            		imageSrc : $("#imageSrc").val()
			            	},
			            	dataType : "json",
			            	success : function(result) {
			            		if (result.result == true) {
			            			window.location.href = "/ezCommunity/adminThumbIE9Ok.do?code=" + $("#code").val();
			            		}
			            	}
			            });
			        }
				</c:if>
				
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code = 'ezCommunity.t2012' /></h1>
    	<div class="subtxt" style="color:#666"><spring:message code = 'ezCommunity.t497' /></div>
    	<form enctype="multipart/form-data" method="post" name="image" action="/ezCommunity/adminLogoOk.do">
	        <input type="hidden" name="code" id="code" value="<c:out value = '${code}' />">
	        <input type="hidden" name="type" id="Type" value="">
	        <input type="hidden" name="imageSrc" id="imageSrc" value="">
	        <%-- <div class="subtxt">
	            <spring:message code = 'ezCommunity.t500' /><br>
	        </div> --%>
	        <table class="content" style="margin-top:5px">
	            <tr>
	                <th style="line-height:16px; padding-top:3px; text-align:center;"><spring:message code='ezCommunity.jjh03' /><br>(894 * 100)<%-- <spring:message code = 'ezCommunity.t1529' /><spring:message code = 'ezCommunity.t498' /> --%></th>
	                <td>
	                    <c:if test="${isCrossBrowser == true}">
	                    	<a class="imgbtn" style="vertical-align:middle; margin-top:10px; margin-bottom:0px;"><span id="btn_AttachAdd_logo" onclick="return btn_AttachSelect_onclick()"><spring:message code = 'ezCommunity.t1177' /></span></a>
	                    	<span class="filename1" id="filename1"></span>
	                    	<input type="file" id="logo" name="logo" accept="image/*" onchange="return logo_onpropertychange()" style="display:none">
	                    	<span><img class="prev" id="logoprev" src="" style="width:321.84px;"></span>
	                    </c:if>
	                    <c:if test="${isCrossBrowser == false}">
	                    	<a class="imgbtn" style="vertical-align:middle; margin-top:10px; margin-bottom:0px;"><span id="btn_AttachAdd_logo" onclick="return btn_AttachAdd_onclick()"><spring:message code = 'ezCommunity.t1177' /></span></a>
	                    	<span class="filename1" id="filename1"></span>
	                    	<input type="file" id="logo" name="logo" accept="image/*" style="display:none">
	                    	<span><img class="prev" id="logoprev" src="" style="width:321.84px;"></span>
	                    </c:if>
	                </td>
	            </tr>
	            <tr>
	                <th style="line-height:16px; padding-top:3px; text-align:center;"><spring:message code='ezCommunity.jjh02' /><br>(198 * 140)</th>
	                <td>
	                    <c:if test="${isCrossBrowser == true}">
	                    	<a class="imgbtn" style="vertical-align:middle; margin-top:10px; margin-bottom:0px;"><span id="btn_AttachAdd_thumb" onclick="return btn_AttachSelectThumb_onclick()"><spring:message code = 'ezCommunity.t1177' /></span></a>
	                    	<span class="filename2" id="filename2"></span>
	                    	<input type="file" id="thumb" name="thumb" accept="image/*" onchange="return thumb_onpropertychange()" style="display:none">
	                    	<span><img class="prev" id="thumbprev" src="" style="width:50.4px;"></span>
	                    </c:if>
	                    <c:if test="${isCrossBrowser == false}">
	                    	<a class="imgbtn" style="vertical-align:middle; margin-top:10px; margin-bottom:0px;"><span id="btn_AttachAdd_thumb" onclick="return btn_AttachAddThumb_onclick()"><spring:message code = 'ezCommunity.t1177' /></span></a>
	                    	<span class="filename2" id="filename2"></span>
	                    	<input type="file" id="thumb" name="thumb" accept="image/*" style="display:none">
	                    	<span><img class="prev" id="thumbprev" src="" style="width:50.4px;"></span>
	                    </c:if>
	                </td>
	            </tr>
	        </table>
	        <br/><br/>
	    <div class="subtxt" style="color:#666"><spring:message code = 'ezCommunity.t2013' /></div>
	    <table style="width:100%;">
	        <tr style="height:190px;">
	            <td>
	                <img src="/images/ezCommunity/cop_type1.png" style="width:300px;height:180px;cursor:pointer;" id="type1" onclick="radioClick(this,'img')"/>
	            </td>
	            <td>
	                <img src="/images/ezCommunity/cop_type2.png" style="width:300px;height:180px;cursor:pointer;" id="type2" onclick="radioClick(this,'img')"/>
	            </td>
	        </tr>
	        <tr style="height:20px;text-align:center;">
	            <td>
	                <input type="radio" name="radType" value="type1" onclick="radioClick(this, 'rad')" style="cursor:pointer;" checked="checked"/>Type1
	            </td>
	            <td>
	                <input type="radio" name="radType" value="type2" onclick="radioClick(this, 'rad')" style="cursor:pointer;"/>Type2
	            </td>
	        </tr>
	        <tr style="height:190px;">
	            <td>
	                <img src="/images/ezCommunity/cop_type3.png" style="width:300px;height:180px;cursor:pointer;padding-top:5px" id="type3" onclick="radioClick(this,'img')"/>
	            </td>
	            <td>
	                <img src="/images/ezCommunity/cop_type4.png" style="width:300px;height:180px;cursor:pointer;padding-top:5px" id="type4" onclick="radioClick(this,'img')"/>
	            </td>
	        </tr>
	        <tr style="height:20px;text-align:center;">
	            <td>
	                <input type="radio" name="radType" value="type3" onclick="radioClick(this, 'rad')" style="cursor:pointer;"/>Type3
	            </td>
	            <td>
	                <input type="radio" name="radType" value="type4" onclick="radioClick(this, 'rad')" style="cursor:pointer;"/>Type4
	            </td>
	        </tr>
	        <tr style="height:190px;">
	            <td>
	                <img src="/images/ezCommunity/cop_type5.png" style="width:300px;height:180px;cursor:pointer;padding-top:5px" id="type5" onclick="radioClick(this,'img')"/>
	            </td>
	            <td>
	            </td>
	        </tr>
	        <tr style="height:20px;text-align:center;">
	            <td>
	                <input type="radio" name="radType" value="type5" onclick="radioClick(this, 'rad')" style="cursor:pointer;"/>Type5
	            </td>
	            <td>
	            </td>
	        </tr>
	    </table>
	    <br/><br/><br/>
	    <div class="btnposition btnpositionNew">
	            <a class="imgbtn" name="Submit" onclick="javascript:pre_onclick();" style="display: none"><span><spring:message code = 'ezCommunity.t502' /></span></a>
	            <a class="imgbtn" name="Submit2" onclick="javascript:go();"><span><spring:message code = 'ezCommunity.t20' /></span></a>
	            <a class="imgbtn" name="Submit3" onclick="javascript:cancle_onclick();"><span><spring:message code = 'ezCommunity.t109' /></span></a>
	            <a class="imgbtn" name="Submit4" onclick="close_onclick()"><span><spring:message code = 'ezCommunity.t21' /></span></a>
	        </div>
    	</form>
	</body>
</html>