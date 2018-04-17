<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAttitude.t39' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezAttitude.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	
		<script type="text/javascript">
			var companyId = "${companyId}";
			var typeId = "${typeInfo.typeId}";
			var saveMode = "";
			
	        window.onload = window_onload;
	        function window_onload() {
	            //수정모드일 때
	            if(typeId != "") {
	            	saveMode = "modify";
	            	
	            	//파일경로
	            	var imgFilePath = "${typeInfo.imgPath}";
	            } else {
	    			typeId = "<c:out value = '${typeId}' />";
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

			function OK_Click() {
				var imgPath = $('#preview').attr('src');
				var idx = imgPath.lastIndexOf('/');
				imgPath = imgPath.substr(idx+1);
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
		        		imgPath : imgPath
		        	},
		        	success : function(result) {
		        			alert('추가하였습니다.');
		        			window.opener.company_change();
							window.close();
		        	},
		        	error : function() {
		        		alert('추가하는 도중 에러 발생');
		        	}
		        });
			}
			
			function close_Click() {
				window.close();
			}
			
		</script>
	</head>
	<body class="popup">
	    <div id="menu">
	        <ul>
	            <li><span onclick="OK_Click()"><spring:message code='ezAttitude.t16' /></span></li>
	        </ul>
	    </div>
	    <div id="close">
	        <ul>
	            <li><span onclick="close_Click()">닫기</span></li>
	        </ul>
	    </div>
		<table class="content"> 
  			<tr> 
    			<th><spring:message code='ezAttitude.t40' /></th> 
    			<td style="padding:0">
    				<table width="100%">
			        	<tr class="primary">
<%-- 			          		<th><c:out value = '${langPrimary}' /></th> --%>
			          		<th><spring:message code='ezAttitude.t41' /></th>
			          		<td><input id="typeName" type="text" style="width:98%" value="<c:out value = '${typeInfo.typeName}' />"></td>
			        	</tr>
			        	<tr class="secondary">
<%-- 			          		<th><c:out value = '${langSecondary}' /></th> --%>
			          		<th><spring:message code='ezAttitude.t42' /></th>
			          		<td><input id="typeName2" type="text" style="width:98%" value="<c:out value = '${typeInfo.typeName2}' />"></td>
			        	</tr>
    				</table>
    			</td> 
  			</tr>
  			<tr>
  				<th><spring:message code='ezAttitude.t43' /></th>
  				<td style="">
  					<table width="100%;">
  						<tr>
	  						<td style="width:20%;">
	  							<a class="imgbtn" style="background:none;">
	  								<span onclick="btnimagefile_onclick()">파일추가</span>
	  							</a>
	  						</td>
	  						<td style="width:40%">
	  							<img id="preview" name="preview" src="${typeinfo.imgpath}" width="16px;" height="16px;" alt="" border="0" style="display: block;">
	  						</td>
	  						<td>
	  							★ 아이콘 크기 : 16px * 16px
	  						</td>
	  					</tr>
  					</table>
  				</td>
  			</tr>
		</table> 
		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezAttitude/iconUpload.do" target="ifrm" style="width: 1px; height: 1px;display:none">
        	<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="false" />
    	</form>
	</body>
</html>