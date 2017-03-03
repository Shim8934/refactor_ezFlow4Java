<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<script  type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script  type="text/javascript" src="/js/ckEditor/ckeditor.js"></script>
		<script  type="text/javascript" src="/js/XmlHttpRequest.js"  ></script>
		<script  type="text/javascript">
		
		    CKEDITOR.on( 'instanceReady', function( ev )
		    {
			    ExecuteCommand("maximize");
			    parent.DocumentComplete();
		    });
		    
		    // Setdata 후 실행 함수.
		    CKEDITOR.on( 'afterSetData', function( ev )
		    {
		    	parent.FieldsAvailable();
		    });
			
			function SetEditorContent(strHtml){
			    //CKEDITOR.instances.editor1.insertHtml(strHtml);
			    CKEDITOR.instances.editor1.setData(strHtml);
			}

			function GetEditorContent(){
			    return CKEDITOR.instances.editor1.getData();
			}
			
			// 에디터 커맨드 실행
		    function ExecuteCommand(commandName){
			    var oEditor = CKEDITOR.instances.editor1;
		     
			    if ( oEditor.mode == 'wysiwyg' )
			    {
				    oEditor.execCommand( commandName );
			    }
		    }
		</script>
	</head>
	<body>
		<textarea cols="80" id="editor1" name="editor1" rows="10"></textarea>
		<script type="text/javascript">CKEDITOR.replace( 'editor1', {fullPage : false} );</script>
		<script type="text/javascript">
			CKEDITOR.config.font_defaultLabel = "<spring:message code='main.t246' />";
		    CKEDITOR.config.font_names = "<spring:message code='main.t0620' />" + CKEDITOR.instances.editor1.config.font_names;
		    CKEDITOR.config.language = "<spring:message code='main.t0619' />";
		</script>
	</body>
</html>