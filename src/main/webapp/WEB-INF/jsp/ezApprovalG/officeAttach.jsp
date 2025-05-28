<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head> 
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezApproval.t934'/></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')}">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/Common_Function.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
		
		<script type="text/javascript">
			var filelist;
			var isfileup = false;
			var converterServerURL = "${converterServerURL}";
			var imgDiv;
			
			function btnfileup() {   
		        if (!isfileup) {
		        	document.getElementById("file").click();       
		        }	                     
		    }
			
			function filechange(e) {                
	            onDrop();
	        }
			
			function onDrop(evt) {
	            if (evt != undefined) {
	                evt.stopPropagation();
	                evt.preventDefault();
	            }
	
	            if (evt == undefined) {
	                filelist = document.getElementById("file").files;
	            } else {
	                filelist = evt.dataTransfer.files;
	            }
	            
	            if(filelist.length > 1) {
	            	alert("<spring:message code='ezOrgan.x0001'/>");
	            	return;
	            }
	            
	            for (var i = 0; i < filelist.length; i++) {	            		             	
	                //파일명체크
	                var tmpFileName = ReplaceHTML(filelist[i].name);
	                
	                if (tmpFileName.indexOf(">") > -1 || tmpFileName.indexOf("<") > -1 || tmpFileName.indexOf("\"") > -1 ||
	                    tmpFileName.indexOf("/") > -1 || tmpFileName.indexOf("\\") > -1 || tmpFileName.indexOf(":") > -1 ||
	                    tmpFileName.indexOf("*") > -1 || tmpFileName.indexOf("|") > -1 || tmpFileName.indexOf("?") > -1) {
	                	alert("<spring:message code='ezApproval.t936'/>");
	                    return;
	                }
	
	                var FileFilter = /\.(doc|docx|ppt|pptx|xls|xlsx|pdf|jpg|jpeg|png|gif|bmp|txt|text|html|htm|hwp)$/i;
	                
	                if (!tmpFileName.match(FileFilter)) {
	                	alert("<spring:message code='ezApproval.t937'/>");
	                    return;
	                }
	            }           
	
	            fileupload();
	        }
			
			function fileupload() {
                
				isfileup = true;
				
				var formData = new FormData();
				formData.append("fileToUpload", filelist[0]); 			
				formData.append("docId", parent.pDocID);				
				formData.append("tenantId", parent.pTenantID);
				formData.append("companyId", parent.pCompanyID);
				formData.append("userId", parent.pUserID);
                				
                $("#loading").css("display", "");
                
				$.ajax({
					type : "post",
					data : formData,
					url : "/ezApprovalG/officeUpload.do",
					processData: false, 
					contentType: false,
					success : function(result) {
						$("#mailPanel", parent.document).css("display", "none");
						$("#layerpopup", parent.document).css("display", "none");
						setConvertedImg(result);
					},
					error : function() {
						alert("변환에 실패하였습니다.");
					},
					complete : function() {
						$("#loading").css("display", "none");
						isfileup = false;
					}
				});                            
            }
			
			function setConvertedImg(convertedImgInfo) {
	        	var divLength = parent.document.getElementById("message").contentWindow.document.getElementById("body").getElementsByClassName("divImg").length;
	        	if(divLength >0){
	        		$("#message").contents().find(".divImg").remove();
		        	var body = parent.document.getElementById("message").contentWindow.document.getElementById("body");
		        	var divImg = body.getElementsByClassName("divImg");
		        	$(divImg).remove();
	        	}
		        var div = document.createElement('div');
	        	$(div).addClass("divImg");
	        	$(div).css("overflow", "hidden");
	        	parent.document.getElementById("message").contentWindow.document.getElementById("body").appendChild(div);
	        	
	        	var imgURL = convertedImgInfo;
	        	
	        	// 2021-01-14 이혁진 이미지 URL 가공
	        	var pagesIndexOf = imgURL.indexOf("pages");
	        	var pagesURL = imgURL.substr(pagesIndexOf);
	        	var pagesIndexOf2 = pagesURL.indexOf("&");
	        	var pagesURL2 = pagesURL.substr(0, pagesIndexOf2);
	        	var pagesIndexOf3 = pagesURL2.indexOf("=")+1;
	        	var pages = pagesURL2.substr(pagesIndexOf3); // PDF 페이지 수
	        	
	        	var fileIndexOf = imgURL.indexOf("filename");  // 이미지 filenm을 for문에서 대입해서 넣어주기위해 이미지URL을 자르기 위한 index값
	        	var fileURL = imgURL.substr(fileIndexOf);
	        	var fileIndexOf2 = fileURL.indexOf(".png");
	        	
	        	var imgURLF = imgURL.substr(0, fileIndexOf); // 이미지URL 이미지 순서 정해지기 전
	        	var imgURLL = fileURL.substr(fileIndexOf2); // 이미지URL 이미지 순서 정해진 후
	        	
	        	var body = $(parent.document).find('body');
	        	var selectBox = body.find("#selectImg");
	        	$(selectBox).children('option').remove();
// 	        	$(selectBox).addClass('imgSelect');
	        	for(var i = 1; i <= pages; i++) {  		
	        		var imgSrc = document.createElement('img');
	        		var fileNm;
	        		
	        		if(i<10){
		        		fileNm = "filename=0000" + i;
	        		}else if(i<100){
	        			fileNm = "filename=000" + i;
	        		}else{
	        			fileNm = "filename=00" + i;
	        		}
	        		
	        		imgSrc.src = imgURLF + fileNm + imgURLL;
	        		imgSrc.style.width = "654px";
	        		imgSrc.style.border = "1px solid rgb(200, 200, 200)";
	        		imgSrc.style.boxSizing = "border-box";
	        		$(imgSrc).addClass("office-image");
	        		$(imgSrc).css("position", "relative");
	        		$(imgSrc).attr("z-index", 100);

        		
	        		imgDiv = document.createElement('div');   	        		
	        		$(imgDiv).css("overflow", "hidden");
	        		$(imgDiv).css("page-break-before", "always");
	        		$(imgDiv).css("text-align", "center");
	        		
	        		if(i>1){
	        			$(imgDiv).css("display", "none");
	        		}else{
	        			$(imgDiv).addClass("imgDiv");
	        		}
	        		
	        		
	        		if(i == pages) {
	        			$(imgDiv).css("page-break-after", "always");
	        		}
	        		imgDiv.appendChild(imgSrc);
	        		div.appendChild(imgDiv);
	        		
	        		if(i <= pages){
		        		$(selectBox).append("<option value='" + i + "'>" + i +" / "+pages+ " Page</option>");
	        		}
	        	}
	        	var imgMove = parent.document.getElementById("message").contentWindow.document.getElementById("body").getElementsByClassName("office-image");
// 		        	$(imgMove).draggable({
// 		        		scroll : false
// 	    	    	});
	        	}
			
			
		</script>
	</head>
	<body>
		<div>			
			<div class="popupJQLayer">
				<div class="title"><spring:message code='ezApproval.t934'/></div>
			</div>
			<div>
				<span style="margin-left: 12px; font-size: 15px;">
					※ <spring:message code='ezApproval.t935'/>
				</span>
				<a class="imgbtn" onclick="btnfileup()" style="vertical-align: middle; /*height: 15px;*/ padding: 3px 8px">
					<spring:message code='ezPortal.t45'/>
				</a>
			</div>	
					
		</div>
		<span id="loading" style="top: 50px; left: 200px; width: 100px; display: none; position: absolute;">
			<img src="/images/loading/loading_new.gif" style="width: 100px;">
		</span>
		<input id="file" type="file" onchange="filechange(event)" accept=".doc, .docx, .ppt, .pptx, .xls, .xlsx, .pdf, .jpg, .jpeg, .png, .gif, .bmp, .txt, .text, .html, .htm, .hwp" style="display:none;width:0px;height:0px;" />
	</body>
</html>