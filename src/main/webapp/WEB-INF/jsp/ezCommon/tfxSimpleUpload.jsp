<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>XFE UPLOAD</title>
		<script type="text/javascript">
			window.onload = function()
			{
				if ("${resultCode}" == "1") {
					alert("<spring:message code='ezBoard.hyj02'/>");
					return;
				} else if ("${resultCode}" == "2") {
					alert("<spring:message code='main.t4000'/>");
					return;
				}
				
				var strImagePath = document.getElementById("divImagePath").innerHTML;
				var root_id = "${sRootId}";
				
				if (strImagePath != undefined && strImagePath != "")
				{
					var str = '<img src="' + strImagePath + '">';
					
					var range = null;
					
					if(parent._xfe_object[root_id].xfeStackObject.xfeFocusoutRange) {
				    	range = parent._xfe_object[root_id].xfeStackObject.xfeFocusoutRange;
				    } else {
				    				    
					    if(parent.xfeBrowserFlag.isIE()){
					    	
					        if(parent.xfeBrowserFlag.getBrowserVersion() < 11) {
					            range = parent._xfe_object[root_id].xfeStackObject.xfeDocument.selection.createRange();    
					        } else {
					            if(parent._xfe_object[root_id].xfeRangeHandler.getDesignDocumentSelection().rangeCount > 0) {
					            	range = parent._xfe_object[root_id].xfeRangeHandler.getDesignDocumentSelection().getRangeAt(0);
				            	} else {
				            		range = parent._xfe_object[root_id].xfeStackObject.xfeSavedLastRange;
				            	}
					        }			                        
					        
					    } else {
					    	
					        if(parent._xfe_object[root_id].xfeStackObject.xfeDocument.getSelection) {				                 
					             if(parent._xfe_object[root_id].xfeRangeHandler.getDesignDocumentSelection().rangeCount > 0) {
					            	range = parent._xfe_object[root_id].xfeRangeHandler.getDesignDocumentSelection().getRangeAt(0);
				            	} else {
				            		range = parent._xfe_object[root_id].xfeStackObject.xfeSavedLastRange;
				            	}
					        }               
					    }				
				    }
					
				    parent._xfe_object[root_id].xfeContentsHandler.insertHTML(str, range);
					
				}
		
			};
		</script>
	</head>
	<body>		
		<div id="divImagePath">${sUploadedPath}</div>				
	</body>
</html>