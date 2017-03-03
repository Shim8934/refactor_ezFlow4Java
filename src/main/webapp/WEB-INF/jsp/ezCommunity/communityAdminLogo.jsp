<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>${clubVO.c_ClubName } <spring:message code = 'ezCommunity.t495' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var checkValue = "type1";
			var CopType = "<c:out value = '${clubVO.c_Type}' />";
			
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

		        //image.reset();
		        window.location.reload();
		        image.reset();
		        if (window.parent.parent.opener != null)
				    window.parent.parent.opener.location.reload();
				}
		    
		        function close_onclick() {
		            if(window.parent.parent.opener != null) {
		                window.parent.parent.opener.location.reload();
		            }
		            
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
				            
				            document.getElementById("filename").innerText = logoFile.name;
				            
				            var extension = logoFile.name.split('.');
				            check = compareExtension(check, extension[1]);
				            
				            if (check == "false") {
				                alert("<spring:message code ='ezCommunity.lhj03' />");
				                tempLogoPath = "";
				            }
				            
				            if (tempLogoPath != "") {
				                window.parent.parent.opener.coplogo.src = tempLogoPath;
				                window.parent.parent.opener.coplogo.style.visibility = "visible";
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
			            
			            document.getElementById("filename").innerHTML = fileName;
			            
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
				</c:if>
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code = 'ezCommunity.t2012' /></h1>
    	<div class="subtxt"><spring:message code = 'ezCommunity.t497' /></div> <br />
    	<form enctype="multipart/form-data" method="post" name="image" action="/ezCommunity/adminLogoOk.do">
	        <input type="hidden" name="code" id="code" value="<c:out value = '${code}' />">
	        <input type="hidden" name="type" id="Type" value="">
	        <input type="hidden" name="imageSrc" id="imageSrc" value="">
	        <div class="subtxt">
	            <spring:message code = 'ezCommunity.t500' /><br>
	        </div>
	        <table class="content">
	            <tr>
	                <th><spring:message code = 'ezCommunity.t1529' /> <spring:message code = 'ezCommunity.t498' /></th>
	                <td>
	                    <c:if test="${isCrossBrowser == true}">
	                    	<a class="imgbtn"><span id="btn_AttachAdd_logo" onclick="return btn_AttachSelect_onclick()"><spring:message code = 'ezCommunity.t1177' /></span></a>
	                    	<span id="filename" style="vertical-align:middle"></span>
	                    	<input type="file" id="logo" name="logo" accept="image/*" onchange="return logo_onpropertychange()" style="display:none">
	                    </c:if>
	                    <c:if test="${isCrossBrowser == false}">
	                    	<a class="imgbtn"><span id="btn_AttachAdd_logo" onclick="return btn_AttachAdd_onclick()"><spring:message code = 'ezCommunity.t1177' /></span></a>
	                    	<span id="filename" style="vertical-align:middle"></span>
	                    	<input type="file" id="logo" name="logo" accept="image/*" style="display:none">
	                    </c:if>
	                </td>
	            </tr>
	        </table>
	        <br>
	
	    <div class="subtxt"><spring:message code = 'ezCommunity.t2013' /></div> <br />
	    <table style="width:100%;">
	        <tr style="height:200px;">
	            <td>
	                <img src="/images/ezCommunity/cop_type1.png" style="width:300px;height:180px;cursor:pointer;" id="type1" onclick="radioClick(this,'img')"/>
	            </td>
	            <td>
	                <img src="/images/ezCommunity/cop_type2.png" style="width:300px;height:180px;cursor:pointer;" id="type2" onclick="radioClick(this,'img')"/>
	            </td>
	        </tr>
	        <tr style="height:50px;text-align:center;">
	            <td>
	                <input type="radio" name="radType" value="type1" onclick="radioClick(this, 'rad')" style="cursor:pointer;margin-bottom:30px" checked="checked"/>Type1
	            </td>
	            <td>
	                <input type="radio" name="radType" value="type2" onclick="radioClick(this, 'rad')" style="cursor:pointer;margin-bottom:30px"/>Type2
	            </td>
	        </tr>
	        <tr style="height:200px;">
	            <td>
	                <img src="/images/ezCommunity/cop_type3.png" style="width:300px;height:180px;cursor:pointer;" id="type3" onclick="radioClick(this,'img')"/>
	            </td>
	            <td>
	                <img src="/images/ezCommunity/cop_type4.png" style="width:300px;height:180px;cursor:pointer;" id="type4" onclick="radioClick(this,'img')"/>
	            </td>
	        </tr>
	        <tr style="height:50px;text-align:center;">
	            <td>
	                <input type="radio" name="radType" value="type3" onclick="radioClick(this, 'rad')" style="cursor:pointer;margin-bottom:30px"/>Type3
	            </td>
	            <td>
	                <input type="radio" name="radType" value="type4" onclick="radioClick(this, 'rad')" style="cursor:pointer;margin-bottom:30px"/>Type4
	            </td>
	        </tr>
	        <tr style="height:200px;">
	            <td>
	                <img src="/images/ezCommunity/cop_type5.png" style="width:300px;height:180px;cursor:pointer;" id="type5" onclick="radioClick(this,'img')"/>
	            </td>
	            <td>
	            </td>
	        </tr>
	        <tr style="height:50px;text-align:center;">
	            <td>
	                <input type="radio" name="radType" value="type5" onclick="radioClick(this, 'rad')" style="cursor:pointer;margin-bottom:30px"/>Type5
	            </td>
	            <td>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	            <a class="imgbtn" name="Submit" onclick="javascript:pre_onclick();" style="display: none"><span><spring:message code = 'ezCommunity.t502' /></span></a>
	            <a class="imgbtn" name="Submit2" onclick="javascript:go();"><span><spring:message code = 'ezCommunity.t245' /></span></a>
	            <a class="imgbtn" name="Submit3" onclick="javascript:cancle_onclick();"><span><spring:message code = 'ezCommunity.t246' /></span></a>
	            <a class="imgbtn" name="Submit4" onclick="close_onclick()"><span><spring:message code = 'ezCommunity.t21' /></span></a>
	        </div>
    	</form>
	</body>
</html>