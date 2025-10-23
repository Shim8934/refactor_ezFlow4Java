<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
		<c:choose>
			<c:when test="${type == 'UPT'}">
				<spring:message code="ezBoard.HSBBg01" />
			</c:when>
			<c:otherwise>
				<spring:message code="ezBoard.t5000" />
			</c:otherwise>
		</c:choose>
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style>
			.content td, .file td, .file2 td{
				width: 50%;
			}
		</style>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>    
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.form.js')}"></script>
		<script type="text/javascript" language="javascript">
			var pSaveFileData = new FormData(); // 저장버튼 클릭 시 전달할 파일 폼데이터
			var pSaveFileName = "";
			
			$(document).ready(function(){				
				if("<c:out value='${fileName}'/>" != "") { // 등록된 이미지 수정 시 기본 설정 (type : UPT)
					var path = "<c:out value='${filePath}'/>" + "/S_" + "<c:out value='${fileName}'/>";
					document.getElementById("imagewidth").value = "720";
		            document.getElementById("imageheight").value = "<c:out value='${height}'/>";
					document.getElementById("UploadSliderImage").style.display = "";
					document.getElementById("UploadSliderImage").src = path;
					
					pSaveFileData = new FormData(document.getElementById("form"));
				}
			});
			
			function S4() {
		        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
		    }

		    function GetGUID() {
		        return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
		    }
			
			function SliderImage() {		     
				document.getElementById("file1").click();
			}
			
			function btn_AttachAdd_onclick() {
				var file1val = document.getElementById("file1").value;
		        var exIndex = file1val.lastIndexOf(".");
				var extension = file1val.substring(exIndex+1, file1val.lenght);
				var filetxt = file1val.substring(file1val.lastIndexOf("\\")+1, file1val.lenght);
				var check = false;
		        check = compareExtension(check, extension);		         
		        
		        // IE에서 파일의 변경 이벤트 중복 감지 대응
		        if (file1val == "") {
		        	 document.getElementById("file1").value = "";
		        	 document.getElementById("saveFileName").value = "";
		        	 return false;
		        }
		        if (!check) {
		        	 document.getElementById("file1").value = "";
		        	 document.getElementById("saveFileName").value = "";
		        	 alert("<spring:message code='main.t4000'/>");
		        	 return false;
		        }
				/* 2021-12-08 홍승비 - 게시판 배경이미지 업로드 시 서버단에서도 이미지 확장자 체크 진행 (실제 파일 업로드 이전에 ajax로 체크) */
				if (checkImgExtension(extension) == "UPLOAD_EXT_ERROR") {
					document.getElementById("file1").value = "";
					document.getElementById("saveFileName").value = "";
					alert("<spring:message code ='ezAttitude.t260' />"); // 허용하지 않는 확장자입니다.
					return false;
				}
				
		        var guid = "{" + GetGUID() + "}";
		        document.form.guid.value = guid;
		        
		        $('#form').ajaxSubmit({
		        	type : 'POST',
					dataType : 'text',
		        	url : "/admin/ezBoard/uploadBackGroundImage.do",
					success : function(result) {
						var splitData = result.split(",");						
						var filePath = splitData[0];
						var fileName = splitData[1];
						var widthOrigin = splitData[2].split("/")[0];
						var heightOrigin = splitData[2].split("/")[1];				
						var per = 720 / widthOrigin;
						var height = Math.floor(heightOrigin * per);
						
						document.getElementById("UploadSliderImage").style.display = "";
						document.getElementById("UploadSliderImage").src = filePath + "/S_" + fileName;
						document.getElementById("imagewidth").value = "720";
			            document.getElementById("imageheight").value = height;
			            document.getElementById("saveFileName").value = fileName;	
			            document.getElementById("filetxt").value = filetxt;
			            
			            /* 2021-10-13 홍승비 - 배경이미지 업로드 성공 시, 실제로 저장 버튼을 눌렀을 때 서버로 전송할 파일 데이터를 저장 (현재의 form 데이터를 기록) */
			            pSaveFileData = new FormData(document.getElementById("form"));
			            pSaveFileName = fileName;
					},
					error : function(){
						alert("upload error");		
					}
		        });		
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
			
			function btnSave_click(){
				// 신규 이미지 추가 > 파일 등록 취소 시 onchange가 동작하여 saveFileName값이 공백이 되므로, 업로드 성공 시 pSaveFileName에 저장한 값을 사용
				if (pSaveFileName == "" && document.getElementById("type").value != "UPT") {
					alert("<spring:message code='main.t4000'/>");
		            return;
		        }
				if (document.getElementById("imagewidth").value < 1 || isNaN(document.getElementById("imagewidth").value) 
						|| document.getElementById("imageheight").value < 1 || isNaN(document.getElementById("imageheight").value)) {
					alert("<spring:message code='main.t4001'/>");
		            return;
		        }
				
				 // 서버로 전달할 파일데이터의 가로, 세로값 최종 설정
				pSaveFileData.append("pWidth", document.getElementById("imagewidth").value);
				pSaveFileData.append("pHeight", document.getElementById("imageheight").value);
				
				// backgroundID 최종 설정
				if ($("#backgroundID").val() == "") {
					var guid = "{" + GetGUID() + "}";
					$("#backgroundID").val(guid);
					pSaveFileData.append("pBackgroundID", guid);
				} else {
					pSaveFileData.append("pBackgroundID", $("#backgroundID").val());
				}
				
				$.ajax({
					type : "POST",
					async : true,
					data : pSaveFileData,
					contentType : false, // 일반 텍스트로 구분할지 여부
				    processData : false, // 데이터 객체 문자열 치환 여부
					url : "/admin/ezBoard/saveBackGroundImage.do",					
					success : function() {
						 alert("<spring:message code='ezBoard.t79'/>");
						 
						 try {
					         window.opener.GetBackGroundImage();
						 } catch (e) {
							 try {
								 window.opener.location.reload(false);
							 } catch (e) { }
						 }
						 
				         window.close();
					}
				});
			}
			
	    </script>
	</head>
	<body class="popup" style="overflow:hidden">
		<c:choose>
			<c:when test="${type == 'UPT'}">
				<h1><spring:message code="ezBoard.HSBBg01" /></h1>
			</c:when>
			<c:otherwise>
				<h1><spring:message code="ezBoard.t5000" /></h1>
			</c:otherwise>
		</c:choose>
		<div id="close">
            <ul>
                <li><span onclick="return window.close();"></span></li>
            </ul>
        </div>
		<table style="width:100%" id="toggle_tbl1" class="content">
			<tr>
				<th style='text-align:center;'>
					<spring:message code="ezBoard.t5011"/>
				</th>
				<td colspan="3">
					<table style="width:100%;height:217px" border="0">
						<tr>
							<td id="tdNormalImage" style="width:100%;height:200px">
								<img id="UploadSliderImage" src="" style="width:100%;height:200px;display:none" />								
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<form id="form" name="form" style="width:1px;height:1px" enctype="multipart/form-data">
			<tr>
				<th><spring:message code="ezBoard.t5001"/></th>
				<td colspan="3">					
					<input type="file" name="file1" id="file1" style="width:85%;margin-left:3px; display:none;" onchange="btn_AttachAdd_onclick()" accept="image/*"/>
					<input type="text" name="filetxt" id="filetxt" style="width:50%;cursor:default;"
					 readonly onclick="SliderImage()"/>
					<a class="imgbtn imgbck" style="height:22px"><span onclick="SliderImage();"><spring:message code="ezBoard.t5010"/></span></a>
					<input type="hidden" name="backgroundID" id="backgroundID" value="<c:out value='${backgroundID}'/>"/>
					<input type="hidden" name="saveFileName" id="saveFileName" />
					<input type="hidden" name="guid" />
					<input type="hidden" name="type" id ="type"  value="<c:out value='${type}'/>" /> 
				</td>
			</tr>
	        <tr>
	            <th><spring:message code="ezBoard.t5002"/></th>
	            <td><input type="text" name="width" id="imagewidth" readonly style="cursor:default; background-color:#f8f8fa;"/>&nbsp;px</td>
	            <th><spring:message code="ezBoard.t5003"/></th>
	            <td><input type="text" name="height" id="imageheight" />&nbsp;px</td>
	        </tr>
	        </form>	
		</table>
	    <div class="btnpositionNew">	    	
	        <a class="imgbtn"><span onclick="btnSave_click();"><spring:message code="ezBoard.t98"/></span></a>
	    </div>	    
	</body>
</html>