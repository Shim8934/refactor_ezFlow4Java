<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1255' /></title>
		<style>
			DIV.IMAGEVIEW {behavior: url("SealView.htc") }
		</style>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
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
		    var ezapralert_cross_dialogArguments = new Array();
		    var ReturnFunction;
		    
		    $(document).ready(function(){
		        try {
		        	para = opener.ezapralert_cross_dialogArguments[0];
		        	ReturnFunction = opener.ezapralert_cross_dialogArguments[1];
		            pRegUserID = para[0];
		            pRegUserName = para[1];
		            pCompanyID = para[2];
		            tbRegUser.innerText = pRegUserName;
	
		            ret[0] = "cancel";
		            ret[1] = "";
		            ret[2] = pSealName;
		            ret[3] = pSealPath;
		            ret[4] = pSealWidth;
		            ret[5] = pSealHeight;
		            ReturnFunction(ret);
		            
		            document.getElementById("companyID").value = pCompanyID;
		        } catch (e) {
		            alert("window_onload : " + e.description);
		        }
		    });
		    
		    function btnOK_onclick() {
		        pSealName = document.getElementById("tbSealName").value;
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
	
		        pSealWidth = document.getElementsByName("tbSealWidth")[0].value;
		        if (pSealWidth == "") {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1258' />";
		            OpenAlertUI(pInformationString);
		            
		            return;
		        }
	
		        pSealHeight = document.getElementsByName("tbSealHeight")[0].value;
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
		        
		        ReturnFunction(ret);
		        window.close();
		    }
		    
		    function btnCancel_onclick() {
		        window.close();
		    }
		    
		    function btnFileUp_onclick() {
		        document.form.file1.click();
		    }
		    
		    function btnDisplay_onclick() {
		        pSealWidth = document.getElementsByName("tbSealWidth")[0].value;
		        pSealHeight = document.getElementsByName("tbSealHeight")[0].value;
	
		        if (pSealWidth == "" || pSealHeight == "" || pSealPath == "") {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1260' />";
		            OpenAlertUI(pInformationString);
		            
		            return;
		        }
		        
		        if(CrossYN()){
                	document.getElementById("signimage").style.width = pSealWidth + "px";
	                document.getElementById("signimage").style.height = pSealHeight + "px";
	                document.getElementById("signimage").src = "/ezCommon/downloadAttach.do?filePath=" + pSealPath;
                } else {
                	SIGNVIEW.AddImage(pSealPath, pSealWidth, pSealHeight);
                }
		    }
		    
		    function OpenAlertUI(pAlertContent) {
		        ezapralert_cross_dialogArguments[0] = pAlertContent;
		        var ezAPRALERT_Cross = window.open("/ezApprovalG/ezAprAlert.do", "ezAPRALERT", GetOpenWindowfeature(330, 205));
		        try { ezAPRALERT_Cross.focus(); } catch (e) { }
		    }
		    
		    window.onbeforeunload = function () {
		        if ((ret[0] == "cancel") && (pSealPath != "")) {
		        	$.ajax({
		        		type : "POST",
		        		url : "/admin/ezApprovalG/sealDelete.do",
		        		async : false,
		        		data : {dirPath : dirPath, fileName : fileName},
		        		success : function(result) {
		        			if (result == "FALSE") {
		        				//임시저장된 관인파일 삭제 실패
		        			}
		        		}
		        	});
		        }
		    }
		    
		    function btn_AttachAdd_onclick() {
		        if (document.form.file1.value != "") {
		            var frm = document.getElementById('form');
		            var form = new FormData(frm);
		            $.ajax({
		            	type :'POST',
		            	url : "/admin/ezApprovalG/sealUpload.do",
		            	async : false,
		            	dataType : 'json',
		            	data : form,
		            	processData : false,
		            	contentType : false,
		            	success : function(result) {
		            		fileName = result["fileName"];
		            		document.getElementsByName("tbSealWidth")[0].value = result["width"];
		            		document.getElementsByName("tbSealHeight")[0].value = result["height"];
		            		dirPath = result["path"];
		            		
		            		try {
			            		if (fileName.length > 1000) {
			                        var pInformationString = imgName + "<spring:message code = 'ezApprovalG.t1246' />";
			                        OpenAlertUI(pInformationString);
			                        alert(fileName);
			                        
			                        return;
			                    }
		            		} catch (e) {
		                        var pInformationString = imgName + "<spring:message code = 'ezApprovalG.t1247' />" + "\n\n" + e.number + " - " + e.description;
		                        OpenAlertUI(pInformationString);
		                        
		                        return;
		                    }
		            		
		            		pSealPath = dirPath + fileName;
		            	}
		            });
		            
		            document.form.file1.value = "";
		        }
		    }
		    
		    function showKeyCode(event) {
				event = event || window.event;
				var keyID = (event.which) ? event.which : event.keyCode;
				//숫자패드 모두, 방향키, 백슬러쉬, 딜리트만 포함
				if( ( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ) || ( keyID >=37 && keyID <= 40 ) || keyID == 46 || keyID == 8) {
					return;
				} else {
					return false;
				}
			}
		</script>
	</head>
	<body class="popup">
		<div id="menu">
	        <ul>
	        	<li><span onClick="return btnOK_onclick()" ><spring:message code = 'ezApprovalG.t1261' /></span></li>
	        </ul>
		</div>
		<div id="close"><ul><li><span onClick="window.close()" ><spring:message code = 'ezApprovalG.t64' /></span></li></ul></div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
	
		<table width="410" class="content">
	  		<tr> 
	    		<th><spring:message code = 'ezApprovalG.t1262' /></th>
	    		<td id="SealName"> 
	        		<iframe name="ifrm" id="ifrm" src="about:blank" style="display:none"></iframe>        
	        		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/admin/ezApprovalG/sealUpload.do" target="ifrm">                    
	            		<input type="text" name="tbSealName" id = "tbSealName" />
			            <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 0px; height: 0px; "/>
			            <input type="hidden" name="boardID" id="boardid" />
			            <input type="hidden" name="maxSize" id="maxsize" />
			            <input type="hidden" name="mailGubun" id="mailgubun" />
			            <input type="hidden" name="companyID" id="companyID" />
			        </form>
	        		<a class="imgbtn" ><span onClick="btnFileUp_onclick()"><spring:message code = 'ezApprovalG.t1251' /></span></a>
	        		<a class="imgbtn" ><span onClick="btnDisplay_onclick()"><spring:message code = 'ezApprovalG.t1252' /></span></a>
	    		</td>
	  		</tr>
	  		<tr> 
	    		<th><spring:message code = 'ezApprovalG.t1263' /></th>
	    		<td id="SealSize"> 
	      			<input type="text" name="tbSealWidth" style="width:40px" onkeydown="return showKeyCode(event)" maxlength="3">mm&nbsp;*
	      			<input type="text" name="tbSealHeight" style="width:40px" onkeydown="return showKeyCode(event)" maxlength="3">mm 
	      		</td>
	  		</tr>
	  		<tr> 
	    		<th><spring:message code = 'ezApprovalG.t1254' /></th>
	    		<td id="tbRegUser"> </td>
	  		</tr>
		</table>
			<div class="nobox" id="Div2" name="sealsign" style="width: 410px; margin-top: 5px">
				<div id="SIGNVIEW" class="IMAGEVIEW" style="Width:100%; Height:180px; overflow-y:scroll;overflow-x:scroll" align=center valign=middle>
        			<img id="signimage" alt="" src="" style=/>
        		</div>
        	</div>
        	
			<!-- <div class="nobox" id="Div1" name="sealsign" style="width: 410px; margin-top: 5px">
        		<div id="SIGNVIEW" class="IMAGEVIEW" style="Width:100%; Height:180px; overflow-y:scroll;overflow-x:scroll" align=center valign=middle></div>
        	</div> -->
	</body>
</html>