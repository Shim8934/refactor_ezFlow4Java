<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>타이틀</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var companyId = "${companyId}";
			var typeId = "${typeInfo.typeId}";
			var saveMode = "";
			var formHtmlList = ${formList};
// 			var formHtmlList = "<c:out value = '${formList}' />";
			
	        window.onload = window_onload;
	        function window_onload() {
	            //수정모드일 때
	            if(typeId != "") {
	            	saveMode = "modify";
	            	
	            	//파일경로
	            	var imgFilePath = "${typeInfo.imgPath}";
	            	if (imgFilePath != "/images/default_pic.jpg") {
		            	var idx = imgFilePath.lastIndexOf("=");
		            	imgFilePath = imgFilePath.substring(idx+1);
		            	$('#imagefile').val(imgFilePath);
	            	}
	            	
	            	$('#formSelect').val("<c:out value = '${typeInfo.formId}' />").prop('selected', true);
	            	$('#formSelect').prop("disabled", true);
	            } else {
	    			typeId = "<c:out value = '${typeId}' />";
	    			
	            	$('#formSelect').val(0).prop('selected', true);
	            }
	        }
	        
//파일******************************************************************************
			function btnimagefile_onclick() {
	    		$("#file1").click();
			}
			
			function btn_AttachAdd_onclick() {
			    var extension = $("#file1").val().split('.');
			    var check = false;
			    check = compareExtension(check, extension[1]);

			    if (!check) {
	    		    alert("사진이미지" + " 파일을 선택하십시오.");
	        		$("#file1").value = "";
	    		} else {
	    			var frm = document.getElementById('form');
		    		
	    			var typeIdInput = document.createElement("input");
	    			typeIdInput.setAttribute("type", "hidden");
	    			typeIdInput.setAttribute("name", "typeId");
	    			typeIdInput.setAttribute("value", typeId);
	    			frm.appendChild(typeIdInput);
	    			
	    			var companyIdInput = document.createElement("input");
	    			companyIdInput.setAttribute("type", "hidden");
	    			companyIdInput.setAttribute("name", "companyId");
	    			companyIdInput.setAttribute("value", companyId);
	    			frm.appendChild(companyIdInput);
		    		
		    		frm.submit();
		    		$("#file1").val("");
		    		$("#preview").attr("src","");
	    		}
			}
			
			function compareExtension(check, imgext) {
	    		var filterExtension = new Array("jpe", "jpg", "jpeg", "gif", "png", "bmp", "ico", "svg", "svgz", "tif", "tiff", "ai", "drw", "pct", "psp", "xcf", "psd", "raw");
	    		for (var i = 0; i < filterExtension.length; i++) {
	        		if (imgext.toLowerCase() == filterExtension[i]) {
	            		check = true;
	            		break;
	        		}
	    		}
	    		return check;
			}
//여기까지 파일	    
	
			function form_change() {
				var formValue = $('#formSelect').val();
				var formHtml = "";
// 				alert(typeof(formHtmlList));	
				$.each(formHtmlList, function(idx, formInfo) {
					if (formInfo.formId == formValue) {
						formHtml = formInfo.formHtml;
					}
				})


				$('#preForm').html(formHtml);
			}

			function OK_Click() {
				$.ajax({
		        	type : "POST",
		        	url : "/admin/ezAttitude/saveAttitudeType.do",
		        	async : false,
		        	data : {
		        		companyId : companyId,
		        		typeId : typeId,
		        		saveMode : saveMode,
		        		typeName : $('#typeName').val(),
		        		typeName2 : $('#typeName2').val(),
		        		imgPath : $('#imagefile').val(),
		        		formId : $('#formSelect').val()
		        	},
		        	success : function (result) {
		        			window.opener.company_change();
							window.close();
		        	}
		        });
			}
			
		</script>
	</head>
	<body class = "popup">
<%-- 		<xmp id="sigBody" style="display:none;"><c:out value = '${personalPopupVO.content}' /></xmp>  --%>
		<h1>근태유형추가/수정</h1>
		<table class="content"> 
  			<tr> 
    			<th>유형명</th> 
    			<td style="padding:0">
    				<table width="100%">
			        	<tr class="primary">
<%-- 			          		<th><c:out value = '${langPrimary}' /></th> --%>
			          		<th>한글</th>
			          		<td><input id="typeName" type="text" style="width:98%" value="<c:out value = '${typeInfo.typeName}' />"></td>
			        	</tr>
			        	<tr class="secondary">
<%-- 			          		<th><c:out value = '${langSecondary}' /></th> --%>
			          		<th>영문</th>
			          		<td><input id="typeName2" type="text" style="width:98%" value="<c:out value = '${typeInfo.typeName2}' />"></td>
			        	</tr>
			    	</table>
    			</td> 
  			</tr>
  			<tr>
  				<th>
  					<a class="imgbtn" style="background:none; height:25px; padding-top: 4px;"><span onclick="btnimagefile_onclick()">아이콘등록</span></a>
  				</th>
  				<td style="height:45px;">
  					<table width="100%;">
  						<tr>
	  						<td style="width:88%">사진크기는 ~이하로 해주세요!</td>
	  						<td rowspan="2" style="padding-top: 2px;">
	  							<img id="preview" name="preview" src="${typeInfo.imgPath}" width="40px;" height="40px;" alt="" border="0">
	  						</td>
	  					</tr>
  						<tr>
	  						<td colspan="2" width="70%"><input type="text" id="imagefile" name="imagefile" value="" style="width:88%"></td>
	  					</tr>
  					</table>
  				</td>
  			</tr>
  			<tr> 
    			<th>html폼</th> 
    			<td>
					<select id="formSelect" style="width:80px;" onchange="form_change()">
						<c:forEach var="item" items="${formList}">
							<option value="<c:out value='${item.formId}'/>"><c:out value='${item.formName}'/></option>
						</c:forEach>
					</select> 
				</td> 
  			</tr>
  			<tr> 
    			<th>양식 미리보긩</th>     
    			<td id="preForm" style="padding:0px; height:320px"></td>
  			</tr>
		</table> 
		<div class="btnposition"> 
		    <a class="imgbtn"><span onclick="OK_Click()">확인</span></a>
		    <a class="imgbtn"><span onclick="window.close()">취소</span></a>
		</div>
		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezAttitude/iconUpload.do" target="ifrm" style="width: 1px; height: 1px;display:none">
        	<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="false" />
    	</form>
<!-- 		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	 -->
<!-- 		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel"> -->
<%-- 			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe> --%>
<!-- 		</div> -->
	</body>
</html>