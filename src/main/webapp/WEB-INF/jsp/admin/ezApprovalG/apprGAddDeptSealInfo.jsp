<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1241' /></title>
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
		    var pDeptID = "";
		    var fileName = "";
		    var dirPath = "";
		    var ret = new Array("");
		    var ezapralert_cross_dialogArguments = new Array();
		    var ReturnFunction;
		    
		    $(document).ready(function(){
		        try {
		        	para = opener.ezaddSeal_cross_dialogArguments[0];
		        	ReturnFunction = opener.ezaddSeal_cross_dialogArguments[1];
		            pRegUserID = para[0];
		            pRegUserName = para[1];
		            pDeptID = para[2];
		            pCompanyID = para[3];
		            tbRegUser.innerText = pRegUserName;
	
		            ret[0] = "cancel";
		            ret[1] = "";
		            ret[2] = pSealName;
		            ret[3] = pSealPath;
		            ret[4] = pSealWidth;
		            ret[5] = pSealHeight;
		            ReturnFunction(ret);
		            
		            document.getElementById("companyID").value = pCompanyID;
		            document.getElementById("deptID").value = pDeptID;
		        } catch (e) {
		            alert("window_onload : " + e.description);
		        }
		    });
		    
		    function btnOK_onclick() {
		    	pSealName = document.getElementById("tbSealName").value;
		        if (pSealName == "") {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1242' />";
		            OpenAlertUI(pInformationString);
		            
		            return;
		        }
	
		        if (pSealPath == "") {
					var pInformationString = "<spring:message code = 'ezApprovalG.t1243' />";
		            OpenAlertUI(pInformationString);
		            
		            return;
		        }
	
		        pSealWidth = tbSealWidth.value;
		        if (pSealWidth == "") {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1244' />";
		            OpenAlertUI(pInformationString);
		            
		            return;
		        }
	
		        pSealHeight = tbSealHeight.value;
		        if (pSealHeight == "") {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1245' />";
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
		        /* var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
		        var imgName = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx\0All Files (*.*)\0*.*\0\0", "")
		        var ezUtil = null;
	
		        if (imgName == "") {
		            return;
		        }
		        
		        var fileName = "";
	
		        try {
		            oPoster.Clear();
		            oPoster.UseUTF8 = true;
		            oPoster.AddFormData("mode", "send");
		            oPoster.AddFile("attachfile", imgName, 0);
		            oPoster.AddFormData("pCompanyID", pCompanyID);
		            oPoster.AddFormData("pDeptID", pDeptID);
		            oPoster.Host = "<c:out value = '${serverName}' />";
		            oPoster.PostURL = "/myoffice/ezApprovalG/ezSealInfo/aspx/DeptSealUpload.aspx";
		            if (window.location.protocol == "http:")
		                oPoster.Protocol = 0;
		            else
		                oPoster.Protocol = 1;
		            oPoster.Post();
	
		            fileName = oPoster.Response;
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
		        
		        pSealPath = "/Upload_ApprovalG/SealImg/" + fileName; */
		        
		    	document.form.file1.click();
		    }
		    
		    function btnDisplay_onclick() {
		        pSealWidth = tbSealWidth.value;
		        pSealHeight = tbSealHeight.value;
	
		        if (pSealWidth == "" || pSealHeight == "" || pSealPath == "") {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1248' />";
		            OpenAlertUI(pInformationString);
		            
		            return;
		        }
		        
		        if(CrossYN()){
                	document.getElementById("signimage").style.width = pSealWidth + "mm";
	                document.getElementById("signimage").style.height = pSealHeight + "mm";
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
		        		url : "/admin/ezApprovalG/deptSealDelete.do",
		        		async : false,
		        		data : {dirPath : dirPath, fileName : fileName},
		        		success : function(result) {
		        			if (result == "FALSE") {
		        				//임시저장된 관인파일 삭제 실패
		        			}
		        		}
		        	});
		        }
		    };
		    
		    function btn_AttachAdd_onclick() {
		        if (document.form.file1.value != "") {
		            var frm = document.getElementById('form');
		            var form = new FormData(frm);
		            $.ajax({
		            	type :'POST',
		            	url : "/admin/ezApprovalG/deptSealUpload.do",
		            	async : false,
		            	dataType : 'json',
		            	data : form,
		            	processData : false,
		            	contentType : false,
		            	success : function(result) {
		            		fileName = result["fileName"];
		            		tbSealWidth.value = result["width"];
		            		tbSealHeight.value = result["height"];
		            		dirPath = result["path"];
		            		
		            		try {
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
		            	}
		            });
		            
		            document.form.file1.value = "";
		        }
		    }
		</script>
	</head>
	<body class="popup">		
		<div id="menu">
			<ul>
		  		<li><span onClick="return btnOK_onclick()" ><spring:message code = 'ezApprovalG.t1249' /></span></li>
			</ul>
		</div>
		<div id="close"><ul><li><span onClick="window.close()" ><spring:message code = 'ezApprovalG.t64' /></span></li></ul></div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		
		<table class="content">
		  	<tr> 
		    	<th><spring:message code = 'ezApprovalG.t1250' /></th>
		    	<td id="SealName"> 
		      		<iframe name="ifrm" id="ifrm" src="about:blank" style="display:none"></iframe>
		      		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/admin/ezApprovalG/deptSealUpload.do" target="ifrm">                    
	            		<input type="text" name="tbSealName" id = "tbSealName" />
			            <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 0px; height: 0px; "/>
			            <input type="hidden" name="boardID" id="boardid" />
			            <input type="hidden" name="maxSize" id="maxsize" />
			            <input type="hidden" name="mailGubun" id="mailgubun" />
			            <input type="hidden" name="deptID" id="deptID" />
			            <input type="hidden" name="companyID" id="companyID" />
			        </form>
		        	<a class="imgbtn"><span onclick="return btnFileUp_onclick()"><spring:message code = 'ezApprovalG.t1251' /></span></a>
		        	<a class="imgbtn"><span onclick="return btnDisplay_onclick()"><spring:message code = 'ezApprovalG.t1252' /></span></a>
		    	</td>
		  	</tr>
		  	<tr> 
		    	<th><spring:message code = 'ezApprovalG.t1253' /></th>
		    	<td id="SealSize"> 
			    	<input type="text" name="tbSealWidth" style="width:40px">mm&nbsp;*
			      	<input type="text" name="tbSealHeight" style="width:40px">mm
			    </td>
		  	</tr>
		  	<tr> 
		    	<th><spring:message code = 'ezApprovalG.t1254' /></th>
		    	<td  id="tbRegUser"> </td>
		  	</tr>
		</table>
		
		<div class="nobox" id="Div2" name="sealsign" style="width: 410px; margin-top: 5px">
       		<div id="SIGNVIEW" class="IMAGEVIEW" style="Width:100%; Height:180px; overflow-y:scroll;overflow-x:scroll" align=center valign=middle>
       			<img id="signimage" alt="" src="" />
       		</div>
       	</div>	
	</body>
</html>