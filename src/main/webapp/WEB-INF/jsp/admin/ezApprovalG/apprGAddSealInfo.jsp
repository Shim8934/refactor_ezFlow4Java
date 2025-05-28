<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1255' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			var pSealName = "";
	        var pSealPath = "";
	        var pSealWidth = "";
	        var pSealHeight = "";
	        var pRegUserID = "";
	        var pRegUserName = "";
	        var pCompanyID = "";
	        var fileName = "";
		    var dirPath = "";
	        var ret = new Array("");
	        var RetValue;
	        var ReturnFunction;
	        
	        window.onload = function () {
	            try {
	                try {
	                    RetValue = parent.AddSealInfo_dialogArguments[0];
	                    ReturnFunction = parent.AddSealInfo_dialogArguments[1];
	                } catch (e) {
	                    try {
	                        RetValue = opener.AddSealInfo_dialogArguments[0];
	                        ReturnFunction = opener.AddSealInfo_dialogArguments[1];
	                    } catch (e) {
	                        RetValue = window.dialogArguments;
	                    }
	                }
	                
	                pRegUserID = RetValue[0];
	                pRegUserName = RetValue[1];
	                pCompanyID = RetValue[2];
	                	                
	                $("#tbRegUser").html(pRegUserName);
	                $("#companyID").val(pCompanyID);
	                
	                ret[0] = "cancel";
	                ret[1] = "";
	                ret[2] = pSealName;
	                ret[3] = pSealPath;
	                ret[4] = pSealWidth;
	                ret[5] = pSealHeight;
	                
	                try {
	                    window.returnValue = ret;
	                } catch (e) { }
	
	
	            } catch (e) {
	                alert("window_onload : " + e.description);
	            }
	        }
	        
	        function btnOK_onclick() {
	        	pSealName = $("#tbSealName").val();
		        if (pSealName == "") {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1256' />";
		            OpenAlertUI(pInformationString);
		            
		            return;
		        }

		        if (pSealPath == "") {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1257' />";
		            OpenAlertUI(pInformationString);
		            
		            return;
		        }
	
		        pSealWidth = $("#tbSealWidth").val();
		        if (pSealWidth == "") {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1258' />";
		            OpenAlertUI(pInformationString);
		            
		            return;
		        }
		        
		        pSealHeight = $("#tbSealHeight").val();
		        if (pSealHeight == "") {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1259' />";
		            OpenAlertUI(pInformationString);
		            
		            return;
		        }
	
		        ret[0] = "OK";
		        ret[1] = "";
		        ret[2] = pSealName;
		        ret[3] = pSealPath;
		        ret[4] = pSealWidth;
		        ret[5] = pSealHeight;
		
		        if (ReturnFunction != null) {
		            ReturnFunction(ret);
		        } else {
		            window.returnValue = ret;
		        }
		
		        window.close();
		    }
	        
		    function btnCancel_onclick() {
		        window.close();
		    }
		    
		    function btnFileUp_onclick() {
		        document.form.file1.click();
		    }
		    
		    function btnDisplay_onclick() {
		        pSealWidth = $("#tbSealWidth").val();
		        pSealHeight = $("#tbSealHeight").val();
		
		        if (pSealWidth == "" || pSealHeight == "" || pSealPath == "") {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1260' />";
		            OpenAlertUI(pInformationString);
		            return;
		        }
		        
		        document.getElementById("SIGNVIEW").innerHTML = "";
		        var Img = document.createElement("IMG");
		        Img.style.width = pSealWidth + "mm";
		        Img.style.height = pSealHeight + "mm";
		        Img.src = pSealPath;
		        SIGNVIEW.appendChild(Img);
		    }
		
		    var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent) {
		        if (CrossYN()) {
		            ezapralert_cross_dialogArguments[0] = pAlertContent;
		            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            //var ezAPRALERT_Cross = window.open("/ezApprovalG/ezAprAlert.do", "ezAPRALERT_Cross", GetOpenWindowfeature(330, 205));
		            var url = "/ezApprovalG/ezAprAlert.do";
		            DivPopUpShow(330, 205, url);
		        } else {
		            var parameter = pAlertContent;
		            var url = "/ezApprovalG/ezAPRALERT.do";
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		    }
		    
		    function OpenAlertUI_Complete() {
		    	DivPopUpHidden();
		    }
		    
		    window.onbeforeunload = function () {
		    	if ((ret[0] == "cancel") && (pSealPath != "")) {
		        	$.ajax({
		        		type : "POST",
		        		url : "/admin/ezApprovalG/sealDelete.do",
		        		async : false,
		        		data : {dirPath : dirPath, fileName : fileName},
		        		success : function(result) {

		        		},
		        		error : function() {
// 		        			"FALSE" 
		        		}
		        	});
		        }
		    }
			
		    /* 2020-02-26 홍승비 - 관인 이미지 업로드 시 파일 확장자 체크 */
		    function btn_AttachAdd_onclick() {
		        if (document.form.file1.value != "") {
					var frm = document.getElementById('form');
		            var form = new FormData(frm);
		            var msg = "";
		            
		            var file1val = document.getElementById("file1").value;
			        var exIndex = file1val.lastIndexOf('.');
					var extension = file1val.substring(exIndex+1, file1val.lenght);
			        var check = false;
			        check = compareExtension(check, extension);	
		            
			        if (!check) {
			        	document.getElementById("file1").value = "";
			        	OpenAlertUI("<spring:message code ='ezBoard.hsbImg01' />");
			        	return;
			        }
			        else {
			        	$.ajax({
			        		type : "POST",
			        		url : "/admin/ezApprovalG/sealImageUpload.do",
			        		dataType : "json",
			        		data : form,
			            	processData : false,
			            	contentType : false,
			        		success : function(result) {
			        			fileName = result["fileName"];
			            		dirPath = result["path"];
			            		msg = result["msg"];
			            		
			            		try {
			            			if (msg == "UPLOAD_EXT_ERROR") {
										var pInformationString = "<spring:message code = 'ezAttitude.t260' />";
										OpenAlertUI(pInformationString);
										
										return;
			            			}
			            			
				            		if (fileName.length > 1000) {
				                        var pInformationString = imgName + "<spring:message code = 'ezApprovalG.t1246' />";
				                        OpenAlertUI(pInformationString);
				                        
				                        return;
				                    }
			            		} catch (e) {
			                        var pInformationString = imgName + "<spring:message code = 'ezApprovalG.t1247' />" + "\n\n" + e.number + " - " + e.description;
			                        OpenAlertUI(pInformationString);
			                        
			                        return;
			                    }
			            		
			            		pSealPath = dirPath + fileName;
			            		var fileinfo = document.getElementById("file1").value.substring(document.getElementById("file1").value.lastIndexOf("\\") + 1, document.getElementById("file1").value.length);
					            document.getElementById("filename").value = fileinfo;
			        		}
			        	});
			        }
		        }
		    }
		
		    function returnvalue(strXML) {
		        var xml = loadXMLString(strXML);
		        var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
		        
		        if (getNodeText(GetChildNodes(nodes[0])[1]) == "true") {
		            var fileinfo = document.getElementById("file1").value.substring(document.getElementById("file1").value.lastIndexOf("\\") + 1, document.getElementById("file1").value.length);
		            document.getElementById("filename").value = fileinfo;
		            fileName = getNodeText(GetChildNodes(nodes[0])[4]);
		        }
		        
		        pSealPath = "/${userInfo.tenantId}/files/upload_approvalG/sealImg/" + fileName;
		    }
		    
		    function showKeyCode(event) {
				event = event || window.event;
				var keyID = (event.which) ? event.which : event.keyCode;
				//숫자패드 모두(48~57, 96~105), 방향키(37~40), 백슬러쉬(8), 딜리트(46), Tab(9)만 포함
				if( ( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ) || ( keyID >=37 && keyID <= 40 ) || keyID == 46 || keyID == 8 || keyID == 9) {
					return;
				} else {
					return false;
				}
			}
		    
		    /* 2020-02-26 홍승비 - 이미지파일 확장자체크 추가 */
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
		    
		</script>
	</head>
	<body class="popup">
		<div id="menu">
	        <ul>
	        	<li><span onClick="return btnOK_onclick()" ><spring:message code = 'ezApprovalG.t1261' /></span></li>
	        </ul>
		</div>
		<div id="close">
			<ul>
				<li><span onClick="window.close()" ></span></li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		</script>
	
		<table class="content">
	  		<tr> 
	    		<th><spring:message code = 'ezApprovalG.t1262' /></th>
	    		<td id="SealName"> 
	    			<input type="text" id="tbSealName" name="tbSealName" style="width:100%;">
	    		</td>
	    	</tr>
	    	<tr>
				<th><spring:message code = 'ezApprovalG.t00010' /></th>
				<td style="vertical-align:middle;">
					<input type="text" readonly id="filename" style="width:177px;">
	        		<a class="imgbtn imgbck"><label for="file1"><span><spring:message code = 'ezApprovalG.t1251' /></span></label></a>
	        		<a class="imgbtn imgbck" ><span onClick="btnDisplay_onclick()"><spring:message code = 'ezApprovalG.t1252' /></span></a>
	    		</td>
	  		</tr>
	  		<tr> 
	    		<th><spring:message code = 'ezApprovalG.t1263' /></th>
	    		<td id="SealSize"> 
	      			<input type="text" value="30" id="tbSealWidth" style="width:40px" onkeydown="return showKeyCode(event)" maxlength="3">mm&nbsp;*
	      			<input type="text" value="30" id="tbSealHeight" style="width:40px" onkeydown="return showKeyCode(event)" maxlength="3">mm 
	      		</td>
	  		</tr>
	  		<tr> 
	    		<th><spring:message code = 'ezApprovalG.t1254' /></th>
	    		<td id="tbRegUser"> </td>
	  		</tr>
	  		<tr>
	  			<td id="SIGNVIEW" colspan="2" style="text-align:center; padding-top:5px; padding-bottom:5px;"></td>
	  		</tr>
		</table>
		
		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		
	    <form style="display: none;" method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm">
	        <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" accept="image/*">
	        <input type="hidden" name="mode" id="mode" />
	        <input type="hidden" name="companyID" id="companyID" />
	    </form>
	</body>
	<c:if test="${!isCrossBrowser}">
	    <script type="text/javascript">EzHTTPTrans_ActiveX("EzHTTPTrans");</script>
	</c:if>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</html>
