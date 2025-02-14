<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t183' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
	        var ReturnFunction;

	        /* 2018-08-25 홍승비 - 상단 head로 분리된 스타일시트 삽입 스크립트 제거 */
	        window.onload = function () {
	            try {
	                ReturnFunction = opener.personpicture_cross_dialogArguments[1];
	                
	                // 2025-02-14 조수빈 - 기존 등록된 이미지 나타나지 않는 결함 수정 (#154694)
	                if (window.opener.document.getElementById('myimg')) {
		                document.getElementById('preview').src = window.opener.document.getElementById('myimg').src;
	                }
	            } catch (e) {
	            }
	        }
	        
	    	function imgConfirm_onclick() {
	        	var doc = iframe.document;
	        	var form = doc.all("logoform");

	        	if (form != null) {
		            var input = form.imagefile;
	            	input = form.imagefile;
	            	if (input.value != "") {
		                if (CheckExt(input.value))
	                    	form.submit();
	                	else
		                    alert("<spring:message code='ezPersonal.t202'/>\n119(width) * 128(height) <spring:message code='ezPersonal.t203'/>\n<spring:message code='ezPersonal.t204'/>");
	        		} else {
	            		alert("<spring:message code='ezPersonal.t200'/>");
			    		return;
					}
	    		}
			}

	        function NotifyResult(filename) {
	            if (ReturnFunction!= null)
	                ReturnFunction(filename);
	            else
	                window.returnValue = filename;
	            window.close();
	        }

			function btnimagefile_onclick() {
	    		document.getElementById("file1").click();
			}

			function divImageFile_onclick() {
	    		if (imagefile.value != "") {
	        		preview.src = "";
	        		preview.style.visibility = "hidden";
			        preview.src = imagefile.value;
	        		preview.style.visibility = "visible";
	    		}
			}

			function CheckExt(pValue) {
	    		var dot = pValue.lastIndexOf(".");
	    		var ext = pValue.substring(dot).toLowerCase();

			    if (ext != ".jpg" && ext != ".gif")
	    		    return false;
	    		else
	        		return true;
			}

			function fileupafter() {
	    		imagefile.value = this.value;
			}

			/* 2018-12-04 홍승비 - 사원이미지 추가 직후 스크립트 오류 수정 */
// 			function btn_AttachAdd_onclick() {
// 				if (document.form.file1.value != "") {
					
// 					var file1val = document.getElementById("file1").value;
// 					var exIndex = file1val.lastIndexOf('.');
// 				    var extension = file1val.substring(exIndex+1, file1val.length);
// 				    var check = false;
// 				    check = compareExtension(check, extension);
	
// 				    if (!check) {
// 		    		    alert("<spring:message code='ezPersonal.t206'/>" + " <spring:message code='ezPersonal.t200'/>");
// 		        		document.getElementById("file1").value = "";
// 		    		} else {
// 		    			var frm = document.getElementById('form');
// 			    		frm.action = "/ezPersonal/photoUploadByUser.do";
// 			    		frm.submit();
// 			    		document.form.file1.value = "";
// 		    		}
// 				}
// 			}
			function btn_AttachAdd_onclick() { //사진 선택시 임시 저장
				if (document.form.file1.value != "") {
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
		    			var frm = document.getElementById('form');
			    		frm.action = "/ezPersonal/tempPhotoUploadByUser.do";
			    		frm.submit();
			    		document.form.file1.value = "";
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
			
			function cancel_onclick() {
	    		if (ReturnFunction != null)
	        		ReturnFunction();
	    		else
	        		window.returnValue = "OK";
	    		window.close();
			}
			
			function btnOk_onclick() { //저장
				if (document.getElementById("imagefile").value == "") {
					alert("<spring:message code='ezPersonal.t200'/>");
					return;
				}
				
				if (confirm("<spring:message code='ezPersonal.psb02'/>")) {
					var fileName = document.getElementById("imagefile").value;
					fileName = fileName.substr(fileName.lastIndexOf("/") + 1);
					
					// 2024.09.02 한슬기 : 저장 버튼을 여러 번 누를 경우 오류 발생. 저장버튼 누르면 이미지등록, 저장버튼 비활성화.
					var saveButton = document.getElementsByClassName("imgbtn");
					
					for (var i = 0; i < saveButton.length; i++){
						saveButton[i].style.pointerEvents = "none";
						saveButton[i].style.backgroundColor = "#cccccc"; 
						saveButton[i].style.color = "#666666";
					}
					
			        $.ajax({
			    		type : "POST",
			    		url : "/ezPersonal/photoUploadByUser.do",
			    		data : {
				    			fileName: fileName
			    		},
			    		success: function(){
			    			
			    			cancel_onclick();
			    		}        			
			    	});
				}
			}
		</script>
	</head>
	<body class="popup">
    	<h1><spring:message code='ezPersonal.t183'/></h1>
    	<div id="close">
        	<ul>
            	<li><span onclick="cancel_onclick()"></span></li>
        	</ul>
    	</div>
	    <table class="content">
    	    <tr>
        	    <th width="119" height="128" nowrap>
        	    <c:choose>
        	    	<c:when test="${userLang eq '1'}">
                		<img id="preview" name="preview" src="/images/default_pic.jpg" width="119" height="128" alt="" border="0">
        	    	</c:when>
        	    	<c:when test="${userLang eq '2'}">
                		<img id="preview" name="preview" src="/images_en/default_pic.jpg" width="119" height="128" alt="" border="0">
        	    	</c:when>
        	    	<c:when test="${userLang eq '3'}">
                		<img id="preview" name="preview" src="/images_ja/default_pic.jpg" width="119" height="128" alt="" border="0">
        	    	</c:when>
        	    	<c:otherwise>
                		<img id="preview" name="preview" src="/images_en/default_pic.jpg" width="119" height="128" alt="" border="0">
        	    	</c:otherwise>
        	    </c:choose>
        	    <%-- <%String userLang = (String)request.getAttribute("userLang"); %>
           	    <% if (userLang.equals("1")) { %>
               		<img id="preview" name="preview" src="/images/default_pic.jpg" width="119" height="128" alt="" border="0">
               	<%} else { %>
               		<img id="preview" name="preview" src="/images_en/default_pic.jpg" width="119" height="128" alt="" border="0">
               	<% } %> --%>
            	</th>
            	<td style="padding: 5px"><spring:message code='ezPersonal.t202'/><br>
                	119(width) * 128(height)<spring:message code='ezPersonal.t100001'/><br><br>
            	</td>
        	</tr>
    	</table>
    	<br>
    	<table class="content">
        	<tr>
            	<th><a class="imgbtn"><span id="btnimagefile" onclick="btnimagefile_onclick()"><spring:message code='ezPersonal.t20003'/></span></a></th>
            	<td class="pos1" colspan="2">
	                <input id="imagefile" name="imagefile" style="WIDTH: 100%">
				</td>
			</tr>
    	</table>
    	<div class="btnpositionNew">
			<a class="imgbtn"><span onclick="return btnOk_onclick()"><spring:message code='ezPersonal.t34'/></span></a>
		</div>
    	<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
    	<form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezPersonal/photoUploadByUser.do" target="ifrm" style="width: 1px; height: 1px;display:none">
        	<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="false" accept="image/*"/>
    	</form>
	</body>
</html>