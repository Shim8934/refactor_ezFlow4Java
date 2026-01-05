<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>${clubVO.c_ClubName } <spring:message code = 'ezCommunity.t495' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
			span.filename1 {	
			    vertical-align: middle;
			    position: absolute;
			    margin-top: 15px;
			    width: 94px;
			    white-space: nowrap;
			    text-overflow: ellipsis;
			    overflow: hidden;
			}
			span.filename2 {
				vertical-align: middle;
			    position: absolute;
			    margin-top: 15px;
			    width: 370px;
			    white-space: nowrap;
			    text-overflow: ellipsis;
			    overflow: hidden;
			}
			img.prev {
				position:relative;
				z-index:0;
				float:right;
				height:36px;
				margin-top:3px;
				margin-right:2px;
				margin-bottom:3px;
			}
			img.del {
				position:absolute;
				z-index:1;
				float:right;
				margin-right:2px;
				cursor:pointer;
				right:0;
				top:2px;
			}
			.radioTypeText {
				vertical-align:text-bottom;
			    margin-bottom:2px;
			    display:inline-block;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
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
                	document.getElementById("delLogo").style.display = "";
                }
		        if (thumbsrc.indexOf("default_logo_empty") > -1) {
		        	document.getElementById("thumbprev").src = "/images/ezCommunity/logo/" + thumbsrc, "C_LOGO_THUMBNAIL";
                } else {
                	document.getElementById("thumbprev").src = "/ezCommunity/getCommunityThumInfo.do?type=COMMUNITYTHUM&fileName=" + thumbsrc, "C_LOGO_THUMBNAIL";
                	document.getElementById("delThumb").style.display = "";
                }
		        document.getElementById("logoprev").style.display = "";
		        document.getElementById("thumbprev").style.display = "";		        
		    }
			
		    function cancle_onclick() {
		        if (!confirm("<spring:message code = 'ezCommunity.t449' />")) {
				        return;
				 }
		        image.reset();
		        window.location.reload(true);
			}
		    
		  	function close_onclick() {
		    	image.reset();
		    	parent.parent.window.close();
		  	}
				
			function go() {
				image.submit();
		   	}

		    // 로고, 베너 등록 시 이미지 파일 확장자가 아닐 때 비교하는 함수 추가_2013.01.30
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
				
			 	/* 2020-01-13 홍승비 - 확장자 체크 부분 수정 */
			 	var check = "false";
		        var extension = logoFile.name.substring(logoFile.name.lastIndexOf(".") + 1, logoFile.name.length);
		        check = compareExtension(check, extension);
		        
		        if (check == "false") {
	                tempLogoPath = "";
	                document.getElementById("filename1").innerText = "";
					image.reset();
	                alert("<spring:message code ='ezCommunity.lhj03' />");
	                return;
	            }
		        
		        /* 2021-12-08 홍승비 - 커뮤니티 상단/썸네일 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 */
                if (checkImgExtension(extension) == "UPLOAD_EXT_ERROR") {
					tempLogoPath = "";
 	                document.getElementById("filename1").innerText = "";
					image.reset();
					alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
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
					 	document.getElementById("filename1").innerText = logoFile.name;
					 	
			            if (tempLogoPath != "") { // 상단이미지 미리보기, 디폴트 로고값 해제
			          		document.getElementById("logoprev").src = tempLogoPath;
			          		document.getElementById("logoprev").style.display = "";
			          		document.getElementById("delLogo").style.display = "";
			          		document.getElementById("defaultLogo").value = "";
			            } else {
			                image.reset();
			            }
		       		}
		       	});
		    }
	
		    // 2018-04-11 썸네일 추가 및 미리보기
		    function thumb_onpropertychange() {
				var thumbFile = $("#thumb")[0].files[0];
				
				if (thumbFile == null) {
					return ;
				}
				
				/* 2020-01-13 홍승비 - 확장자 체크 부분 수정 */
				var check = "false";
	            var extension = thumbFile.name.substring(thumbFile.name.lastIndexOf(".") + 1, thumbFile.name.length);
	            check = compareExtension(check, extension);
	            
	            if (check == "false") {
					tempThumbPath = "";
					document.getElementById("filename2").innerText = "";
					image.reset();
	                alert("<spring:message code ='ezCommunity.lhj03' />");
	                return;
	            }
				
				/* 2021-12-08 홍승비 - 커뮤니티 상단/썸네일 이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 */
                if (checkImgExtension(extension) == "UPLOAD_EXT_ERROR") {
					tempThumbPath = "";
					document.getElementById("filename2").innerText = "";
					image.reset();
					alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
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
			            document.getElementById("filename2").innerText = thumbFile.name;
			            
			            if (tempThumbPath != "") { // 썸네일 이미지 미리보기, 디폴트 썸네일값 해제
			          		document.getElementById("thumbprev").src = tempThumbPath;
			          		document.getElementById("thumbprev").style.display = "";
			          		document.getElementById("delThumb").style.display = "";
			          		document.getElementById("defaultThumb").value = "";
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
		        
		        /* 2018-05-10 홍승비 - 디폴트 로고인 경우 타입에 맞추어 로고 변경하도록 수정 */
		        if (document.getElementById("logoprev").src.indexOf("default_logo_") > -1) {
		    	   	document.getElementById("logoprev").src =  "/images/ezCommunity/logo/default_logo_" + checkValue + ".png";
		           	document.getElementById("defaultLogo").value = "default_logo_" + checkValue + ".png";
		        }
		    }
		        
		    function btn_AttachSelect_onclick() {
		        document.getElementById("logo").click();
		    }
		    function btn_AttachSelectThumb_onclick() {
		        document.getElementById("thumb").click();
		    }
		    
		    /* 2018-05-16 홍승비 - 등록한 로고, 썸네일 이미지 제거 기능 추가 */
		    function attachDelLogo() {
			   	document.getElementById("filename1").innerText = "";
		       	document.getElementById("logo").value = "";
		       	document.getElementById("delLogo").style.display = "none";
		       	document.getElementById("logoprev").src = "/images/ezCommunity/logo/default_logo_" + checkValue + ".png";
		       	document.getElementById("defaultLogo").value = "default_logo_" + checkValue + ".png";
		    }
			function attachDelThumb() {
				document.getElementById("filename2").innerText = "";
				document.getElementById("thumb").value = "";
				document.getElementById("delThumb").style.display = "none";
		       	document.getElementById("thumbprev").src = "/images/ezCommunity/logo/default_logo_empty.png";
		       	document.getElementById("defaultThumb").value = "default_logo_empty.png";
		    }
			
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code = 'ezCommunity.t2012' /></h1>
    	<div class="subtxt" style="color:#666"><spring:message code = 'ezCommunity.t497' /></div>
    	<form enctype="multipart/form-data" method="post" name="image" action="/ezCommunity/adminLogoOk.do">
	        <input type="hidden" name="code" id="code" value="<c:out value = '${code}' />">
	        <input type="hidden" name="type" id="Type" value="">
	        <input type="hidden" name="defaultLogo" id="defaultLogo" value="">
	        <input type="hidden" name="defaultThumb" id="defaultThumb" value="">
	        <table class="content" style="margin-top:5px">
	            <tr>
	                <th style="line-height:16px; padding-top:3px; text-align:center;"><spring:message code='ezCommunity.jjh03' /><br>(894 * 100)</th>
	                <td>
	                    <a class="imgbtn" style="vertical-align:middle; margin-top:10px; margin-bottom:0px;"><span id="btn_AttachAdd_logo" onclick="return btn_AttachSelect_onclick()"><spring:message code = 'ezCommunity.t1177' /></span></a>
	                    <span class="filename1" id="filename1"></span>
	                    <input type="file" id="logo" name="logo" accept="image/*" onchange="return logo_onpropertychange()" style="display:none">
	                    <span style="position:relative; display:inline-block; float:right;"><img class="prev" id="logoprev" src="" style="width:321.84px;"><img class="del"  id="delLogo" src="/images/i_comm_delete.png" style="display:none;" onclick="attachDelLogo()"></span>
	                </td>
	            </tr>
	            <tr>
	                <th style="line-height:16px; padding-top:3px; text-align:center;"><spring:message code='ezCommunity.jjh02' /><br>(198 * 140)</th>
	                <td>
	                    <a class="imgbtn" style="vertical-align:middle; margin-top:10px; margin-bottom:0px;"><span id="btn_AttachAdd_thumb" onclick="return btn_AttachSelectThumb_onclick()"><spring:message code = 'ezCommunity.t1177' /></span></a>
	                    <span class="filename2" id="filename2"></span>
	                    <input type="file" id="thumb" name="thumb" accept="image/*" onchange="return thumb_onpropertychange()" style="display:none">
	                    <span style="position:relative; display:inline-block; float:right;"><img class="prev" id="thumbprev" src="" style="width:50.4px;"><img class="del"  id="delThumb" src="/images/i_comm_delete.png" style="display:none;" onclick="attachDelThumb()"></span>
	                </td>
	            </tr>
	        </table>
	        <br/><br/>
	  	  	<div class="subtxt" style="color:#666"><spring:message code = 'ezCommunity.t2013' /></div>
	   	 	<table style="width:100%;">
		        <tr style="height:190px;">
		            <td>
		                <img src="/images/ezCommunity/cop_type5.png" style="width:300px;height:180px;cursor:pointer;" id="type5" onclick="radioClick(this,'img')"/>
		            </td>
		            <td>
		                <img src="/images/ezCommunity/cop_type2.png" style="width:300px;height:180px;cursor:pointer;" id="type2" onclick="radioClick(this,'img')"/>
		            </td>
		        </tr>
		        <tr style="height:20px;text-align:center;">
		            <td>
						<div class="custom_radio"><input id="radType1" type="radio" name="radType" value="type5" onclick="radioClick(this, 'rad')" checked="checked"/><label for="radType1"><span>Type1</span></label></div>
		            </td>
		            <td>
						<div class="custom_radio"><input id="radType2" type="radio" name="radType" value="type2" onclick="radioClick(this, 'rad')"/><label for="radType2"><span>Type2</span></label></div>
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
						<div class="custom_radio"><input id="radType3" type="radio" name="radType" value="type3" onclick="radioClick(this, 'rad')"/><label for="radType3"><span>Type3</span></label></div>
		            </td>
		            <td>
						<div class="custom_radio"><input id="radType4" type="radio" name="radType" value="type4" onclick="radioClick(this, 'rad')"/><label for="radType4"><span>Type4</span></label></div>
		            </td>
		        </tr>
	    	</table>
	 	  	<br/><br/><br/>
	    	<div class="btnposition btnpositionNew">
	        	<a class="imgbtn" name="Submit2" onclick="go()"><span><spring:message code = 'ezCommunity.t20' /></span></a>
	        	<a class="imgbtn" name="Submit3" onclick="cancle_onclick()"><span><spring:message code = 'ezCommunity.t109' /></span></a>
	        	<a class="imgbtn" name="Submit4" onclick="close_onclick()"><span><spring:message code = 'ezCommunity.t21' /></span></a>
	       </div>
    	</form>
	</body>
</html>