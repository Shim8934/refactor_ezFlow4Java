<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1241' /></title>
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
		    var pDeptID = "";
		    var fileName = "";
		    var dirPath = "";
		    var ret = new Array("");
		    var ezapralert_cross_dialogArguments = new Array();
		    var ReturnFunction;
		    
		    $(document).ready(function(){
		    	try {

	                try {
	                    RetValue = parent.AddDeptSealInfo_dialogArguments[0];
	                    ReturnFunction = parent.AddDeptSealInfo_dialogArguments[1];
	                } catch (e) {
	                    try {
	                        RetValue = opener.AddDeptSealInfo_dialogArguments[0];
	                        ReturnFunction = opener.AddDeptSealInfo_dialogArguments[1];
	                    } catch (e) {
	                        RetValue = window.dialogArguments;
	                    }
	                }
	                pRegUserID = RetValue[0];
	                pRegUserName = RetValue[1];
	                pDeptID = RetValue[2];
	                pCompanyID = RetValue[3];
	                
	                $("#tbRegUser").html(pRegUserName);
	                $("#companyID").val(pCompanyID);
	                $("#deptID").val(pDeptID);

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
	            
	            
		        /* try {
		        	para = opener.AddDeptSealInfo_dialogArguments[0];
		        	ReturnFunction = opener.AddDeptSealInfo_dialogArguments[1];
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
		        } */
		    });
		    
		    function btnOK_onclick() {
		    	pSealName = $("#tbSealName").val();
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
	
		        pSealWidth = $("#tbSealWidth").val();
		        if (pSealWidth == "") {
		            var pInformationString = "<spring:message code = 'ezApprovalG.t1244' />";
		            OpenAlertUI(pInformationString);
		            
		            return;
		        }
	
		        pSealHeight = $("#tbSealHeight").val();
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
		        pSealWidth = $("#tbSealWidth").val();
		        pSealHeight = $("#tbSealHeight").val();
		
		        if (pSealWidth == "" || pSealHeight == "" || pSealPath == "") {
		            var pInformationString = "<spring:message code = 'ezApprovalG.pgb13' />";
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
		        		
		        		},
		        		error : function() {
// 		        			"FALSE";
		        		}
		        	});
				}
		    }
		    
		    /* 2020-02-26 홍승비 - 관인 이미지 업로드 시 파일 확장자 체크 */
		    function btn_AttachAdd_onclick() {
		        if (document.form.file1.value != "") {
		            var frm = document.getElementById('form');
		            var form = new FormData(frm);
		            
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
			            	type :'POST',
			            	url : "/admin/ezApprovalG/sealImageUpload.do",
			            	dataType : 'json',
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
		  		<li><span onClick="return btnOK_onclick()" ><spring:message code = 'ezApprovalG.t1249' /></span></li>
			</ul>
		</div>
		<div id="close"><ul><li><span onClick="window.close()" ></span></li></ul></div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		</script>
		
		<table class="content">
		  	<tr> 
		    	<th><spring:message code = 'ezApprovalG.t1250' /></th>
		    	<td id="SealName">
		    		<input type="text" name="tbSealName" id="tbSealName" style="width: 100%">
		      		<%-- <iframe name="ifrm" id="ifrm" src="about:blank" style="display:none"></iframe>
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
		    	</td> --%>
		  	</tr>
		  	<tr>
	            <th><spring:message code = 'ezApprovalG.t00010' /></th>
	            <td style="vertical-align:middle;">
	                <input type="text" readonly id="filename" style="width:180px;">
	                <a class="imgbtn imgbck"><label for="file1"><span><spring:message code = 'ezApprovalG.t1251' /></span></label></a>
	                <a class="imgbtn imgbck"><span onclick="return btnDisplay_onclick()"><spring:message code = 'ezApprovalG.t1252' /></span></a>
	            </td>
	        </tr>
		  	<tr> 
		    	<th><spring:message code = 'ezApprovalG.t1253' /></th>
		    	<td id="SealSize"> 
			    	<input type="text" id = "tbSealWidth" name="tbSealWidth" style="width:40px" onkeydown="return showKeyCode(event)" maxlength="3">mm&nbsp;*
			      	<input type="text" id = "tbSealHeight" name="tbSealHeight" style="width:40px" onkeydown="return showKeyCode(event)" maxlength="3">mm
			    </td>
		  	</tr>
		  	<tr> 
		    	<th><spring:message code = 'ezApprovalG.t1254' /></th>
		    	<td  id="tbRegUser"> </td>
		  	</tr>
		  	<tr>
	            <td colspan="2" style="text-align:center; padding-top:5px; padding-bottom:5px;">
	            	<div id="SIGNVIEW" style="width:405px;height:195px;overflow:auto;"></div>
	            </td>
	        </tr>
		</table>
		
		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
	    <form style="display: none;" method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm">
	        <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" accept="image/*">
	        <input type="hidden" name="mode" id="mode" />
	        <input type="hidden" name="companyID" id="companyID" />
	        <input type="hidden" name="deptID" id="deptID" />
	    </form>
		<!-- <div class="nobox" id="Div2" name="sealsign" style="width: 410px; margin-top: 5px">
       		<div id="SIGNVIEW" class="IMAGEVIEW" style="Width:100%; Height:180px; overflow-y:scroll;overflow-x:scroll" align=center valign=middle>
       			<img id="signimage" alt="" src="" />
       		</div>
       	</div> -->	
	</body>
</html>