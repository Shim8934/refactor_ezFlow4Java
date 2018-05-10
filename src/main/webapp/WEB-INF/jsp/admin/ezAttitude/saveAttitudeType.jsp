<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			<c:choose>
				<c:when test="${typeInfo.typeId ne null }">
					<spring:message code='ezAttitude.t39' />
				</c:when>
				<c:otherwise>
					<spring:message code='ezAttitude.t33' />
				</c:otherwise>
			</c:choose>
		</title>
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
				var typeName = $('#typeName').val();
				var typeName2 = $('#typeName2').val();
				
				if (typeName == "") {
					alert('휴가유형명을 입력해주세요');
					return;
				}
				
				//태그 적용 안되게 하기
				typeName = ReplaceText(ReplaceText(ReplaceText(typeName, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
				
				if (typeName2) {
					typeName2 = ReplaceText(ReplaceText(ReplaceText(typeName2, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
				}
				
				$.ajax({
		        	type : "POST",
		        	url : "/admin/ezAttitude/saveAttitudeType.do",
		        	async : false,
		        	data : {
		        		companyId : companyId,
		        		typeId : typeId,
		        		saveMode : saveMode,
		        		typeName : typeName,
		        		typeName2 : typeName2
		        	},
		        	success : function(result) {
		        			alert('저장되었습니다.');
		        			window.opener.company_change();
							window.close();
		        	},
		        	error : function() {
		        		alert('저장하는 도중 에러 발생');
		        	}
		        });
			}
			
			function close_Click() {
				window.close();
			}
			
		</script>
	</head>
	<body class="popup">
		<h1>
			<c:choose>
				<c:when test="${typeInfo.typeId ne null }">
					<spring:message code='ezAttitude.t39' />
				</c:when>
				<c:otherwise>
					<spring:message code='ezAttitude.t33' />
				</c:otherwise>
			</c:choose>
		</h1>
		<table class="content"> 
  			<tr> 
    			<th><spring:message code='ezAttitude.t35' /></th> 
    			<td style="padding:0">
    				<table width="100%">
			        	<tr class="primary">
			          		<th><spring:message code='ezAttitude.t41' /></th>
			          		<td><input id="typeName" type="text" style="width:100%" value="${typeInfo.typeName}"></td>
			        	</tr>
			        	<tr class="secondary">
			          		<th><spring:message code='ezAttitude.t42' /></th>
			          		<td><input id="typeName2" type="text" style="width:100%" value="${typeInfo.typeName2}"></td>
			        	</tr>
    				</table>
    			</td> 
  			</tr>
  			<!-- 아이콘을 하려 했던 부분 -->
<!--   			<tr> -->
<%--   				<th><spring:message code='ezAttitude.t43' /></th> --%>
<!--   				<td style=""> -->
<!--   					<table width="100%;"> -->
<!--   						<tr> -->
<!-- 	  						<td style="width:20%;"> -->
<!-- 	  							<a class="imgbtn" style="background:none;"> -->
<!-- 	  								<span onclick="btnimagefile_onclick()">파일추가</span> -->
<!-- 	  							</a> -->
<!-- 	  						</td> -->
<!-- 	  						<td style="width:40%"> -->
<%-- 	  							<img id="preview" name="preview" src="${typeInfo.imgPath}" width="16px;" height="16px;" alt="" border="0" style="display: block;"> --%>
<!-- 	  						</td> -->
<!-- 	  						<td> -->
<!-- 	  							★ 아이콘 크기 : 16px * 16px -->
<!-- 	  						</td> -->
<!-- 	  					</tr> -->
<!--   					</table> -->
<!--   				</td> -->
<!--   			</tr> -->
		</table>
		<div class="btnposition">
	        <a class="imgbtn"><span onclick="OK_Click();" >저장</span></a>
	        <a class="imgbtn"><span onclick="close_Click();">취소</span></a>      
	    </div>
		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezAttitude/iconUpload.do" target="ifrm" style="width: 1px; height: 1px;display:none">
        	<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="false" />
    	</form>
	</body>
</html>