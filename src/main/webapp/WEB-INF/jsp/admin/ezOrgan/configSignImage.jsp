<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezOrgan.t185" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">		
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>	    
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var userid = "${userID}";
		    var SignImageSize = "${signImageSize}";
		    var SignPath = "${signPath}";
			
			$(document).ready(function(){
				GetSignInfo();
			});
			
			function GetSignInfo(){				
				$.ajax({
					type : "POST",
					dataType : "xml",
					url : "/admin/ezOrgan/getEntryInfo.do",
					async : false,
					data : {cn : userid, prop : "extensionAttribute3", pMode : "user" },
					success : function(result){
						xmlDom = result;
			            var signinfo = SelectSingleNodeValueNew(xmlDom,"DATA/EXTENSIONATTRIBUTE3");
						imagelist = signinfo.split(";");

						var length = signlist.length;
						for (var i=0; i<length; i++){
							signlist.options[0] = null;
						}
						if (signinfo != "" && trim(signinfo).replace('\n', '') != ""){
							for (var i=0; i<imagelist.length; i++){
								var newoption = new Option("<spring:message code='ezOrgan.t186' />" + i, imagelist[i]);
								signlist.options[i] = newoption;
							}
						}
					},
					error : function(){
						alert("<spring:message code='ezOrgan.t187' />");
					}
				});
			}			
			function trim(str){
		        while (str && str.indexOf(" ") == 0){
		            str = str.substring(1);
		        }
		        while (str && str.lastIndexOf(" ") == str.length - 1){
		            str = str.substring(0, str.length - 1);
		        }
		        return str;
		    }
			function sign_change() {
				/* if(SignPath == "APPROVAL"){
		        	signimage.innerHTML = "<img src=" + window.document.location.protocol + "//" + window.document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=" + SignPath + "&FILENAME=" + signlist.value + " width=50 height=50>";
				}else{
					signimage.innerHTML = "<img src=" + window.document.location.protocol + "//" + window.document.location.hostname + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=" + SignPath + "&FILENAME=" + signlist.value + " width=50 height=50>";
				} */
				
				var imgSrc = "/admin/ezOrgan/getSignImage.do?type="+SignPath+"&fileName="+encodeURI(signlist.value);
				signimage.innerHTML = "<img src="+imgSrc+" width=50 height=50 />";
		    }
			function btn_AttachAdd_onclick(obj) {
		        if (document.form.file1.value != "") {
		            //if (document.getElementById('mode').value == "PHOTO") {
		                //if (document.getElementById("form").file1.files.length < 2) {
		                //}
		                //else
		                //    alert("한개의 파일만 업로드 가능합니다.");
		            //}
		            var frm = document.getElementById('form');
		            frm.action = "/myoffice/ezOrgan/admin/signImange_upload_Cross.aspx?mode=Logo&userID=" + userid;
		            frm.submit();
		            document.form.file1.value = "";
		        }

		    }
			function add_sign(ocx_file) {
		        document.getElementById('mode').value = "PHOTO";
		        document.form.file1.click();
		    }
			function del_sign()
			{
				if (signlist.selectedIndex == -1)
				{
					alert("<spring:message code='ezOrgan.t188' />");
					return;
				}

				if (!confirm("'" + signlist.options[signlist.selectedIndex].innerText + "'<spring:message code='ezOrgan.t130' />"))
					return;

			    var xmlHTTP = createXMLHttpRequest();
			    var xmlDom = createXmlDom();
		        var xmlPara = createXmlDom();
		        var objRoot, objNode, subNode;

			    var objNode;
			    createNodeInsert(xmlDom, objNode, "DATA");
			    createNodeAndInsertText(xmlDom, objNode, "PARENTCN", "");
			    createNodeAndInsertText(xmlDom, objNode, "CN", userid);
		        objRoot =createNodeAndInsertText(xmlDom, objNode, "PROP", "");

				var imagelist = "";
				for (var i=0; i<signlist.length; i++)
				{
					if (i != signlist.selectedIndex)
					{
						if (imagelist != "")
							imagelist += ";" + signlist.options[i].value;
						else
							imagelist = signlist.options[i].value;
					}
				}

		        createNodeAndAppandNodeText(xmlPara, objRoot, subNode, "extensionAttribute3", imagelist);

				xmlHTTP.open("POST", "SaveUserInfo.aspx", false);
				xmlHTTP.send(xmlDom);
						
				if (xmlHTTP.status == 200 )
				{
					if ( SelectSingleNodeValueNew(xmlHTTP.responseXML,"DATA") != "OK")
						alert("<spring:message code='ezOrgan.t189' />");
					else
					{
						alert("<spring:message code='ezOrgan.t190' />");
						signimage.innerHTML ="<B><spring:message code='ezOrgan.t191' /></B>";
						GetSignInfo();
					}
				}
				else
					alert("<spring:message code='ezOrgan.t189' />");
			}
	    </script>
	</head>
	<body class="popup"> 
		<h1><spring:message code='ezOrgan.t194' /></h1>		 
		<table class="popuplist"> 
			<tr> 
		    	<th><spring:message code='ezOrgan.t195' /></th> 
		    	<th><h2><spring:message code='ezOrgan.t140' /></h2></th> 
		  	</tr> 
		  	<tr> 
		    	<td> 
		    		<select id="signlist" size="10" style="width:150px;height:150px" onChange="sign_change()"> </select>
		    	</td> 
		    	<td id="signimage" style="width:150px;height:150px;text-align:center" class="point"><spring:message code='ezOrgan.t191' /></td> 
		  	</tr> 
		</table> 
		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/myoffice/ezOrgan/admin/signImange_upload_Cross.aspx?mode=Logo" target="ifrm">
			<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" />
			<input type="hidden" name="mode" id="mode" />
		</form>		
		<div class="btnposition">
		    <a class="imgbtn" onClick="add_sign()"><span><spring:message code='ezOrgan.t141' /></span></a>
		    <a class="imgbtn" onClick="del_sign()"><span><spring:message code='ezOrgan.t142' /></span></a>
		    <a class="imgbtn" onClick="window.close()"><span><spring:message code='ezOrgan.t143' /></span></a>
		</div>		
	</body>
</html>