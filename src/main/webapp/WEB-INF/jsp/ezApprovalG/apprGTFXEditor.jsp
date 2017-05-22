<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <title></title>
	    <script  type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/tfxEditor/js/xfe_main.js"></script>
		<script  type="text/javascript" src="/js/XmlHttpRequest.js"  ></script>
	    <script type="text/javascript">
	    	//TODO: Set_CellLocked, Get_BodyUnlock
	    
	        function SetEditorContent(Data) {
	            try {
	            	xfe.setHtmlValue(Data);
	                //Set_CellLocked();
	            } catch (e) { }
	        }
	        function GetEditorContent() {
	            try {
	            	return xfe.getBodyValue();
	                //return Get_BodyUnlock(xfe.getBodyValue());
	            } catch (e) { return ""; }
	        }
	
	        /* function Get_BodyUnlock(HtmlBody) {
	            var Div_Body = document.createElement("DIV");
	            Div_Body.innerHTML = HtmlBody;
	            var TDRows = Div_Body.getElementsByTagName("*");
	            for (var i = 0; i < TDRows.length; i++) {
	                if (TDRows[i].getAttribute("contenteditable") != null) {
	                    TDRows[i].removeAttribute("contenteditable");
	                }
	            }
	            return Div_Body.innerHTML;
	        }
	
	        function Set_CellLocked() {
	            for (var i = 0; i < CKEDITOR.instances.editor1.document.$.getElementsByTagName("*").length; i++) {
	            	if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].closest('.cke_editable, .cke_editable_themed, .cke_contents_ltr, .cke_show_borders') == null) {
	            		if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].tagName == "TD") {
		                    if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].getAttribute("free") == null) {
		                        CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].setAttribute("contenteditable", "false")
		                    }
		                    else if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].getAttribute("free") != null) {
		                        CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].setAttribute("contenteditable", "true")
		                    }
		                }
		                else if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].tagName == "TABLE") {
		                    if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].getAttribute("free") == null) {
		                        CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].setAttribute("contenteditable", "false")
		                    }
		                    else if (CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].getAttribute("free") != null) {
		                        CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].setAttribute("contenteditable", "true")
		                    }
		                }
	            	}
	            }
	        } */
	    </script>
	</head>
	<body style="margin: 0px; padding: 0px;" id="xfe">
	    <script type="text/javascript">
	    	var userLang = "${userInfo.lang}";
	    	var lang = "";
	    	
	    	switch (userLang) {
		    	case "1": 
		    		lang = "korean";
		    		break;
		    	case "2": 
		    		lang = "english";
		    		break;
		    	case "3": 
		    		lang = "japanese";
		    		break;
		    	case "4": 
		    		//중국어 간체 (번체는 chinese_t)
		    		lang = "chinese_s";
		    		break;
		    	default :
		    		lang = "korean";
		    		break;
	    	}
	    	
	    	var initFontFamilyMenu = "<spring:message code='main.t0620' />".split(";");
	    	var uploadFilePath = "/ezCommon/tfxUpload.do";
	    	var uploadPasteContentsPath = "/ezCommon/tfxSimpleUpload.do";
	    	
	        xfe = new XFE({
	        	lang : lang,
	            basePath : "/js/tfxEditor",
	            width : "100%",
	            height : parseInt("${height}") - 120 + "px",
	            initFontFamilyMenu : initFontFamilyMenu,
	            initFontFamily : "<spring:message code='main.t246' />",
	            initFontSize : "13px",
	            skin : "classic",
	            uploadFilePath : uploadFilePath,
	            uploadPasteContentsPath : uploadPasteContentsPath
	        });
	        
	        xfe.render('xfe');
	        
	        window.onload = parent.Editor_Complete();
	    </script>
	</body>
</html>