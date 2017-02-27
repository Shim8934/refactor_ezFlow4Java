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
		    });
		    
		    // Setdata 후 실행 함수.
		    CKEDITOR.on( 'afterSetData', function( ev )
		    {
		    });
			
			// 웹에디터에 내용 삽입(MHT 파일 url 받음)
			function SetEditorContentURL(url)
			{
			    var tempXML = createXmlDom();
			    var XmlBodyATT = createXmlDom();
			    var XmlBodyDATA = createXmlDom();
			    var tempStr = "";
			    tempStr = ConvertMHTtoHTML(url);
			    tempXML = loadXMLString(tempStr);

			    XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
			    XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];	    
			    CKEDITOR.instances.editor1.setData(getNodeText(XmlBodyDATA));
			}	
		
			// 웹에디터에 내용 삽입(MHT 파일 url 받음)
			function SetEditorContentURL2(url) {
			    var tempXML = createXmlDom();
			    var XmlBodyATT = createXmlDom();
			    var XmlBodyDATA = createXmlDom();
			    var tempStr = "";
			    tempStr = ConvertMHTtoHTML(url);
			    tempXML = loadXMLString(tempStr);

			    XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
			    XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
			    return getNodeText(XmlBodyDATA);
			}
			
			function SetEditorContent(strHtml)
			{
			    //CKEDITOR.instances.editor1.insertHtml(strHtml);
			    CKEDITOR.instances.editor1.setData(strHtml);
			}
		
			function GetEditorContent()
			{
			    return CKEDITOR.instances.editor1.getData();
			}
			
			// 에디터 커맨드 실행
		    function ExecuteCommand(commandName)
		    {
			    var oEditor = CKEDITOR.instances.editor1;
		     
			    if ( oEditor.mode == 'wysiwyg' )
			    {
				    oEditor.execCommand( commandName );
			    }
		   }        
		    
		    function deleteRows( selectionOrRow )
			{
				if ( selectionOrRow instanceof CKEDITOR.dom.selection )
				{
					var cells = getSelectedCells( selectionOrRow );
					var rowsToDelete = [];
		
					// Queue up the rows - it's possible and likely that we have duplicates.
					for ( var i = 0 ; i < cells.length ; i++ )
					{
						var row = cells[ i ].getParent();
						rowsToDelete[ row.$.rowIndex ] = row;
					}
		
					for ( i = rowsToDelete.length ; i >= 0 ; i-- )
					{
						if ( rowsToDelete[ i ] )
							deleteRows( rowsToDelete[ i ] );
					}
				}
				else if ( selectionOrRow instanceof CKEDITOR.dom.element )
				{
					var table = selectionOrRow.getAscendant( 'table' );
		
					if ( table.$.rows.length == 1 )
						table.remove();
					else
						selectionOrRow.remove();
				}
		    }
		
		    window.onload = function () {
		        parent.DocumentComplete();
		    };
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