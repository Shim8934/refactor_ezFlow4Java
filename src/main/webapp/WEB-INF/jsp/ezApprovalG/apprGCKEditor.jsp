<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <title></title>
	    <script  type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script  type="text/javascript" src="/js/ckEditor/ckeditor.js"></script>
		<script  type="text/javascript" src="/js/XmlHttpRequest.js"  ></script>
	    <script type="text/javascript">
	        CKEDITOR.on('instanceReady', function (ev) {
	            parent.Editor_Complete();
	        });
	        CKEDITOR.on('afterSetData', function (ev) {
	        });
	        function SetEditorContent(Data) {
	            try {
	                CKEDITOR.instances.editor1.editable().setHtml(Data);
	                Set_CellLocked();
	            } catch (e) { }
	        }
	        function GetEditorContent() {
	            try {
	                return Get_BodyUnlock(CKEDITOR.instances.editor1.getData());
	            } catch (e) { return ""; }
	        }
	        function GetBodyText() {
	            try {
	                return CKEDITOR.instances.editor1.document.getBody().$.outerText;
	            }
	            catch (e)
	            { }
	        }
	
	        function GetEditorSelectedText() {
	            var editor = CKEDITOR.instances["editor1"];
	            var selection = editor.getSelection();
	            var selectedContent;
	
	            if (selection.getType() == CKEDITOR.SELECTION_ELEMENT) {
	                selectedContent = selection.getSelectedElement().getAttribute("alt");
	                alert(selectedContent);
	            }
	            else if (selection.getType() == CKEDITOR.SELECTION_TEXT) {
	                selectedContent = selection.getSelectedText();
	            }
	
	            return selectedContent;
	        }
	
	        function Get_BodyUnlock(HtmlBody) {
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
	        function Set_ElementByIDValue(name, value) {
	            try {
	                CKEDITOR.instances.editor1.document.$.getElementById(name).textContent = value;
	            } catch (e) { }
	        }
	        function Get_ElementByIDValue(name) {
	            try {
	                return CKEDITOR.instances.editor1.document.$.getElementById(name).textContent;
	            } catch (e) { }
	        }
	
	        function Set_Size(width, height) {
	            CKEDITOR.instances.editor1.resize(0, height);
	        }
	        function Set_CellLocked() {
	            for (var i = 0; i < CKEDITOR.instances.editor1.document.$.getElementsByTagName("*").length; i++) {
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
	    </script>
	</head>
	<body style="margin: 0px; padding: 0px;">
	    <textarea cols="80" id="editor1" name="editor1" rows="10"></textarea>
	    <script type="text/javascript">CKEDITOR.replace('editor1', { fullPage: false });</script>
	    <script type="text/javascript">
	        CKEDITOR.config.enterMode = CKEDITOR.ENTER_P;
	        CKEDITOR.config.height = parseInt("${height}") - 120 + "px";
	        if ("${userInfo.lang}" == "1") {
	            CKEDITOR.config.font_defaultLabel = '굴림';
	            CKEDITOR.config.font_names = '맑은 고딕; 돋움; 굴림; 궁서; 바탕;' + CKEDITOR.instances.editor1.config.font_names;
	            CKEDITOR.config.language = "ko";
	        } else if ("${userInfo.lang}" == "2") {  
	            CKEDITOR.config.font_defaultLabel = 'Gulim';
	            CKEDITOR.config.font_names = 'Malgun Gothic; Dotum; Gulim; Gungsuh; Batang;' + CKEDITOR.instances.editor1.config.font_names;
	            CKEDITOR.config.language = "en";
	        } else if ("${userInfo.lang}" == "3") { 
	            CKEDITOR.config.font_defaultLabel = 'Gulim';
	            CKEDITOR.config.font_names = 'Malgun Gothic; Dotum; Gulim; Gungsuh; Batang;' + CKEDITOR.instances.editor1.config.font_names;
	            CKEDITOR.config.language = "ja";
	        } else {
	            CKEDITOR.config.font_defaultLabel = 'Gulim';
	            CKEDITOR.config.font_names = 'Malgun Gothic; Dotum; Gulim; Gungsuh; Batang;' + CKEDITOR.instances.editor1.config.font_names;
	            CKEDITOR.config.language = "zh";
	        }
	    </script>
	</body>
</html>