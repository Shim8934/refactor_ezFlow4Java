<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/ConvertSaveImage.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
		<script type="text/javascript" language="javascript">			
			var pBoardId = "<c:out value='${boardID}'/>";
	        var pcheckForm = "<c:out value='${checkForm}'/>";
	        
	        function DocumentComplete() {	        	
                if (pcheckForm.toUpperCase() == "TRUE") {
                	var fullPath = "";
                	$.ajax({
    					type : "POST",
    					dataType : "text",
    					async : false,
    					url : "/ezBoard/getContentInfo.do",	        			
    					data : { type : "BOARDFORM", docID: pBoardId },
    					success: function(result){    						
    						fullPath = result;

    						var htmlData = message.SetEditorContentURL2(fullPath);              
    	                    message.SetEditorContent(htmlData);
    					}        			
    				});
                    
                }
		    }
	        function saveForm() {
	            var FormText = EmbedContentIntoXML(message.GetEditorContent());
	            FormText = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + FormText + "</BODY>" + "</HTML>");
		            
	            $.ajax({
	            	type : "POST",
	            	dataType : "text",
	            	url : "/admin/ezBoard/saveForm.do",
	            	async : false,
	            	data : {boardID : pBoardId, formContent : FormText},
	            	success : function(result){
	            		alert("<spring:message code='ezBoard.t79' />");
	            	}	
	            });
	        }
	        function cancel() {
	            window.location.reload(true);
	        }
	    </script>
	</head>
	<body>
		<table class="content" style="width:790px;height:600px;margin-top:10px;">
			<tr>
				<td style="height:600px">                   
				    <iframe id="message" class="viewbox" name="message" src="/ezBoard/ckEditor.do" style="padding: 0; height: 100%; width: 100%; overflow: auto; border:0px;"></iframe>
				</td>
			</tr>
        <tr style="display:none">
            <td>
                <iframe id="docContent" style="width: 100%; height: 100%;"></iframe>
            </td>
        </tr>
		</table>
	    <div style="width:780px;text-align:center;margin-top:5px;">
	        <a class="imgbtn"><span onclick="saveForm()"><spring:message code="ezBoard.t98" /></span></a>
	        <a class="imgbtn"><span onclick="cancel()"><spring:message code="ezBoard.t15" /></span></a>
	    </div>
	</body>	
</html>