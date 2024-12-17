<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	    
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/ConvertSaveImage.js')}"></script>
		<script type="text/javascript" language="javascript">			
			var pBoardId = "<c:out value='${boardID}'/>";
	        var pcheckForm = "<c:out value='${checkForm}'/>";
	        var editor = "<c:out value='${use_Editor}'/>";
	        var fullPath = "";
	        
	        /* 2020-02-10 홍승비 - 관리자 > 게시판 > 양식 설정 진입 시 상단 메뉴명 변경되도록 수정 */
	        $(document).ready(function(){
	        	parent.document.getElementsByTagName("h1")[0].innerHTML = "<spring:message code='ezBoard.t999026'/>";
			});
	        
	        function Editor_Complete() {
                if (pcheckForm.toUpperCase() == "TRUE") {
                	$.ajax({
    					type : "POST",
    					dataType : "text",
    					async : false,
    					url : "/ezBoard/getContentInfo.do",	        			
    					data : { type : "BOARDFORM", docID: pBoardId },
    					success: function(result){    						
    						fullPath = result;
    						
    						if (editor != "HWP") {
    							var htmlData = message.GetEditorContentURL(fullPath);              
    		                    message.SetEditorContent(htmlData);	
    						} else {
    							var URL;
    		                    URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(fullPath);
    		                    message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
    						}
    					}
    				});
                } else {
                    URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezApprovalG/downloadAttachForHwp.do?filePath=" + escape(fullPath);
                    message.Open(URL, "", "", function (res) { FieldsAvailable(res.result) }, null);
                }
		    }
	        function saveForm() {
	            if (editor != "HWP") {
	            	var FormText = EmbedContentIntoXML(message.GetEditorContent());
		            
		            /* 2019-04-01 홍승비 - MHT파일 변환 및 저장 시 예외처리 추가 */
		            try {
		            	FormText = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + FormText + "</BODY>" + "</HTML>");
		            } catch (e) {
		            	alert("<spring:message code='ezCommunity.lhj04'/>");
	      				return;
		            }
		            
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
	            } else {
	            	GetHTML(saveHWP);
	            }
	        	
	        }
	        function cancel() {
	            window.location.reload(true);
	        }
	        
	        function FieldsAvailable(isTrue) {
	        	if (isTrue) {
	        		if (fullPath == "") {
	        			message.SetMargin(3000);
	        		}
	        		message.EditMode(1);
            		message.SetViewProperties(2, 100);
		            message.ScrollPosInfo(0, 0);
		            message.ShowToolBar(true);
		            message.ShowRibbon(true);
		            message.FoldRibbon(true);
		            window.onresize();
	        	}
	        }
	        window.onresize = function () {
				if (editor == "HWP") {
					var mHeight = document.getElementById("formContent").clientHeight - 16 + "px";
		       		message.Resize(mHeight);
				}
		    };
		    
		    function GetHTML(callback) {
			    message.GetTextFile("HWP", "", function (data) { callback(data); });
			}
		    
		    function saveHWP(html) {
		    	$.ajax({
	            	type : "POST",
	            	dataType : "text",
	            	url : "/admin/ezBoard/saveForm.do",
	            	async : false,
	            	data : {boardID : pBoardId, formContent : html},
	            	success : function(result){
	            		alert("<spring:message code='ezBoard.t79' />");
	            	}	
	            });
		    }
	    </script>
	</head>
	<body class="tabbody" style="overflow:auto;">
		<table class="content" style="width:790px;height:450px;margin-top:10px;border:0;">
			<tr>
				<td id="formContent" style="height:450px;border:0;">                   
				    <c:if test="${use_Editor ne 'HWP'}">
				    	<iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 100%; width: 100%; overflow: auto; border:0px;"></iframe>
				    </c:if>
				    <c:if test="${use_Editor eq 'HWP'}">
				    	<iframe id="message" class="viewbox" name="message" src="/ezBoard/WHWPEditor.do" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
				    </c:if>
				</td>
			</tr>
        <tr style="display:none">
            <td>
                <iframe id="docContent" style="width: 100%; height: 100%;"></iframe>
            </td>
        </tr>
		</table>
	    <div style="width:774px;" class="btnpositionJsp">
	        <a class="imgbtn"><span onclick="saveForm()"><spring:message code="ezBoard.t98" /></span></a>
	        <a class="imgbtn"><span onclick="cancel()"><spring:message code="ezBoard.t15" /></span></a>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0); display: none;" id="mailPanel">&nbsp;</div>	
	    <div class="layerpopup" style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border: none;" id="iFrameLayer"></iframe>
	    </div>
	</body>	
</html>