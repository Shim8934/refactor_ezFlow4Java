<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezPersonal.t147' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/dhtml.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			var compid = "";
			var itemseq = "<c:out value = '${personalNoticeVO.itemSeq}' />";
			var flag = false;
			var ReturnFunction;
			
			window.onload = function () {
			    try {
			        compid = opener.AddNotice_dialogArguments[0];
			        ReturnFunction = opener.AddNotice_dialogArguments[1];
			    } catch (e) {
			        compid = window.dialogArguments;
			    }
	
				try {
					var ua = navigator.userAgent;
					if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
						var input = document.getElementsByTagName("input");
						for (var i = 0; i < input.length; i++) {
							if(input[i].getAttribute("type") == "text")
								KeEventControl(input[i]);
						}
					}
				} catch (e) {
					
				}
			}
			
		    function OK_Click() {
		        if (compid == "") {
		            return;
		        }
		        
		        if (specialChk(document.getElementById("Title").value)) {
		    		alert("<spring:message code='ezResource.special' />");
		    		return;
		    	}
			    
		        if (document.getElementById("Title").value == "" || document.getElementById("Title2").value == "") {
		            alert("<spring:message code = 'ezPersonal.t148' />");
		            return;
				}
	
		        if (get_length(document.getElementById("Title").value) > 250 || get_length(document.getElementById("Title2").value) > 250) {
		            alert("<spring:message code = 'ezPersonal.t149' />");
		            return;
		        }
		        
		        var strBody = message.GetEditorContent();
		        $.ajax({
		        	type : "POST",
		        	url : "/admin/ezPersonal/saveNotice.do",
		        	async : false,
		        	data : { companyID : compid, title : Title.value, title2 : Title2.value, content : strBody, itemSeq : itemseq },
		        	dataType : "text",
		        	success : function (result) {
		        		if (result != "OK") {
		        			alert("<spring:message code = 'ezPersonal.t150' />");
		        		} else {
		        			alert("<spring:message code = 'ezPersonal.t151' />");
				            
					        if (ReturnFunction != null) {
					            ReturnFunction("");
					            window.close();
					        } else {
					            window.returnValue = "";
					            window.close();
					        }
		        		}
		        	}
		        });
		    }
	
		    function html_edit() {
		        var rtnValue = window.showModalDialog("/myoffice/ezEmail/htm/html_edit.aspx", message.GetEditorContent(), "dialogHeight:480px; dialogWidth:538px; status:no; scroll:no; help:no; edge:sunken" + GetShowModalPosition(538, 480));
		        if (typeof(rtnValue) != "undefined") {
		            message.SetEditorContent(rtnValue);
		        }
		    }

		    function get_length(chkstr) {
		        var length = 0;
		        var i;

		        for (i=0; i<chkstr.length; i++) {
		            if (chkstr.charCodeAt(i) > 256) {
		                length = length + 2;
		            } else {
		                length++;
		            }
		        }
		        
		        return length;
		    }
		    
		    function btn_Close() {
		        if (CrossYN()) {
		            try {opener.add_notice_Complete("");} catch (e) {}
		        }
		        
		        window.close();
		    }
		    
		    function Editor_Complete() {
			    message.SetEditorContent("${personalNoticeVO.content}");
		    }
		</script>
	</head>
	<body class="popup" >
		<h1><spring:message code = 'ezPersonal.t153' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="btn_Close()"></span></li>
            </ul>
        </div>
		<table class="content">
			<tr>
		    	<th><spring:message code = 'ezPersonal.t154' /></th>
		    	<td width="100%" style="padding:0">
		    		<table width="100%">
		        		<tr class="primary">
		          			<th>${langPrimary}</th>
		          			<td><input name="Input" id=Title style="WIDTH:99%" value="<c:out value = '${personalNoticeVO.title}' />"></td>
		        		</tr>
		        		<tr class="secondary">
		          			<th>${langSecondary}</th>
		          			<td><input type="text" id=Title2 style="WIDTH:99%" value="<c:out value = '${personalNoticeVO.title2}' />"></td>
		        		</tr>
		      		</table>
		      	</td>
			</tr>
			<tr>
		    	<th><spring:message code = 'ezPersonal.t155' /></th>
		    	<td style="width:auto;padding:0;border:0;">
		        	<iframe id="message" class="viewbox"  name="message" src="/ezEditor/selectEditor.do" style="padding:0; height:340px; width:100%; overflow:auto;"></iframe>
		    	</td>
		  	</tr>
		</table>
		
		<div class="btnposition">
			<%-- <a class="imgbtn"><span onclick="html_edit()">HTML<spring:message code = 'ezPersonal.t156' /></span></a> --%>
		    <a class="imgbtn"><span onclick="OK_Click()"><spring:message code = 'ezPersonal.t12' /></span></a>
		</div>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>