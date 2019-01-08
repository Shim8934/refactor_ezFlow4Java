<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			수정내역확인
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
		<link rel="stylesheet" href="${util.addVer('ezAttitude.i1', 'msg')}" type="text/css"/>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
		<style>
			table.content {
				width:100%;
				table-layout:fixed;
				white-space:nowrap;
				overflow:hidden;
			}
	    	table.content tr:not(.tr_noItems) td {
	    		table-layout : fixed;
	    		overflow : hidden;
	    		white-space : nowrap;
	    		text-overflow : ellipsis;
	    		text-align:center;
	    	}
	    </style>
	    <script type="text/javascript">	
	    	$(document).ready(function(){
   			});
	    	
	    	function CheckUploadFileSize(objFile) {
    	 		var nMaxSize = 10 * 1024 * 1024; // 10 MB
	    		var nFileSize = objFile.files[0].size;

		    	if (nFileSize > nMaxSize) {
		    		alert("파일용량은 10mb를 초과할 수 없습니다.\n" + nFileSize + " byte");
		    		objFile.outerHTML = objFile.outerHTML;
		    	}
	    	}

	    	function CheckuploadFileExt(objFile) {
	    		var strFilePath = objFile.value;

	    	 	var strExt = strFilePath.split('.').pop().toLowerCase();

	    	 	if ($.inArray(strExt, ["xls"]) == -1) {
	    	  		alert("허용하지 않는 확장자");
	    	  		objFile.outerHTML = objFile.outerHTML;
	    	 	}
	    	}

	    	//전체 연차 등록/수정
	    	function annualExcelUpload() {
	    		if($("[name=excelFile]").val() == null || $("[name=excelFile]").val() == "") {
	                alert("파일을 먼저 선택해주세요.");
	                return;
	            }
	    		if($("[name=changeReason]").val() == null || $("[name=changeReason]").val() == "") {
	                alert("수정사유를 입력해주세요.");
	                return;
	            }
	    		
	    		var form = $("#cForm")[0];
	    		var formData = new FormData(form);

				$.ajax({
	   				type:"post",
	   				url:"/admin/ezAttitude/annualExcelUpload.do",
	   				processData: false,
	   				contentType: false,
	   				data: formData,
	   				dataType: "json",
					success : function(data) {
	            		if (data.status+"" == "ok") {
	            			alert(data.data+"");
	            			opener.getAnnualList();
	   						window.close();
	            		} else {
	            			alert("<spring:message code='ezAttitude.t175' />");
	            		}
	            	},
	   				error : function() {
	   					alert("<spring:message code='ezAttitude.t175' />");
	   				}
	   			});
	   		}
	    	
		</script>
	</head>
	<body class="popup">
	    <h1>
	    	수정내역확인
	    </h1>
	    <div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
        <div>
       	<form name="cForm" id="cForm" method="post" onsubmit="return false;" enctype="multipart/form-data">
        <table class="content">
        	<tr>
	            <th style="width:100px; text-align:center">업로드 파일</th>
	            <td>
	        		<input name="excelFile" id="excelFile" type="file" style="width:100%;padding-bottom: 5px;" accept=".xls" onchange="CheckUploadFileSize(this); CheckuploadFileExt(this);">
	            </td>
	        </tr>
        	<tr>
	            <th style="width:100px; text-align:center">수정사유</th>
	            <td>
        			<input name="changeReason" id="changeReason" type="text"  style="width:100%;text-align:left;padding-bottom: 5px;" value="">
	            </td>
	        </tr>
        </table>
        		<input name="companyId" id="companyId" type="hidden" value="${companyId}">
        		<input name="flagCheck" id="flagCheck" type="hidden" value="change">
        </form>
        </div>
        <div class="btnposition btnpositionNew">
	        <a class="imgbtn"><span onclick="annualExcelUpload();" ><spring:message code='ezAttitude.t16' /></span></a>
	    </div>
	</body>
</html>