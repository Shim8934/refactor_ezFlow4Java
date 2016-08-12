<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<HEAD>
<title></title>
<script language="javascript" type="text/javascript" src="/js/ckEditor/ckeditor.js"></script>
<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
<script language="javascript" type="text/javascript">
    var XmlBodyATT  = createXmlDom();

    CKEDITOR.on( 'instanceReady', function( ev )
    {
	    ExecuteCommand("maximize");
        parent.DocumentComplete();
    });
    
    // Setdata 후 실행 함수.
    CKEDITOR.on( 'afterSetData', function( ev )
    {
        for (var i = 0 ; i < GetChildNodes(XmlBodyATT).length ; i++)
	    {
            BodySetAttribute(getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i],"NODENAME")), getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i],"NODEVALUE")))
	    }
	    parent.FieldsAvailable();	    
    });
	
	// 웹에디터에 내용 삽입(MHT 파일 url 받음)
	function SetEditorContentURL(url)
	{
	    var tempXML = createXmlDom();
        var XmlBodyDATA = createXmlDom();
	    var tempStr = "";
	    tempStr = ConvertMHTtoHTML(url);
	    tempXML = loadXMLString(tempStr);
	    
	    XmlBodyATT  = GetElementsByTagName(tempXML, 'BODYATTS')[0];
	    XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
	    CKEDITOR.instances.editor1.setData(getNodeText(XmlBodyDATA));
	}
	
	function BodySetAttribute(name, Value)
    {
	    CKEDITOR.instances.editor1.document.$.body.setAttribute(name, Value, 0);
    }
    
	function SetEditorContent(strHtml)
	{
	    CKEDITOR.instances.editor1.setData(strHtml);
	}

	function GetEditorContent()
	{
	    return CKEDITOR.instances.editor1.document.$.body.outerHTML;
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
    
    function GetFieldsList()
    {
	    var FieldsList = new Array();
        var FieldCount=0;
        var count=0;
        var i=0;
    	
        count = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*").length;
        
        for( i=0; i<count; i++)
        {
	        if(CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].className == "FIELD")
	        {
		        var tmp = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i];
		        
	            if(!tmp.FieldID)
	                tmp.FieldID = tmp.id;
	                
		        FieldsList[FieldCount] = tmp;
		        FieldCount++;
	        }
        }
        return FieldsList;
    }

    //CKEDITOR
    function GetTagList(strTagName)
    {
        var TagsList = new Array();
        var TagCount=0;
        var count=0;
        var i=0;
    	
        count = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*").length;

        for( i=0; i<count; i++)
        {   
	        if(CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].tagName == strTagName)
	        {
		        TagsList[TagCount] = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i];
		        TagCount++;
	        }
        }
        return TagsList;
    }
    
    function GetBODY()
    {
        var BODYTag;
        var count=0;
        var i=0;
    	
        count = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*").length;		

        for( i=0; i<count; i++)
        {   
            if(CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].tagName == 'BODY')
            {
		        BODYTag = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i];
    	    }
        }
        return BODYTag;
    }

    function GetListItem(pList, str)
    {
        for( i=0; i<pList.length; i++)
        {
	        if(pList[i].id == str)
	           return pList[i];
        }
    }

    function deleteRows( selectionOrRow )
	{
		if ( selectionOrRow instanceof CKEDITOR.dom.selection )
		{
			var cells = getSelectedCells( selectionOrRow );
			var rowsToDelete = [];

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

    function BodySetAttribute(name, Value)
    {
        CKEDITOR.instances.editor1.document.$.body.setAttribute(name, Value, 0);
    }
	
</script> 
</HEAD>

<body>
<textarea cols="80" id="editor1" name="editor1" rows="10"></textarea>
<script type="text/javascript">CKEDITOR.replace( 'editor1', {fullPage : false} );</script>
<script type="text/javascript">

//CKEDITOR.event.prototype.on( 'configLoaded', function(){});
// js\_source\core\config.js
CKEDITOR.config.language = 'ko'; // default : ko, en, ja, zh
//CKEDITOR.config.defaultLanguage = 'ko'; // default : en, ko, ja, zh, it
CKEDITOR.config.enterMode = CKEDITOR.ENTER_P; // CKEDITOR.ENTER_P, CKEDITOR.ENTER_BR, CKEDITOR.ENTER_DIV
CKEDITOR.config.shiftEnterMode = CKEDITOR.ENTER_P; // CKEDITOR.ENTER_BR, CKEDITOR.ENTER_P, CKEDITOR.ENTER_DIV
CKEDITOR.config.docType = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >'; // <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
CKEDITOR.config.fullPage = true; // false, true
CKEDITOR.config.height = '63em'; // 200
CKEDITOR.config.theme = 'default'; // default
CKEDITOR.config.skin = 'v2'; // kama, office2003, v2
CKEDITOR.config.width = '100%'; // 100%, 200, 400

//CKEDITOR.config.toolbarCanCollapse = false;

// js\_source\plugins\toolbar\plugin.js
CKEDITOR.config.toolbar = 'Empty'; // Full, Basic, Empty, Admin, Editor

// js\_source\plugins\colorbutton\plugin.js
CKEDITOR.config.colorButton_enableMore = false; // false, true

// js\_source\plugins\dialog\plugin.js
CKEDITOR.config.dialog_backgroundCoverColor = 'white'; // white, 'rgb(255, 254, 253)'
CKEDITOR.config.dialog_backgroundCoverOpacity = 0.5; // 0.5, 0.7
CKEDITOR.config.dialog_magnetDistance = 20; // 20, 30

// js\_source\plugins\editingblock\plugin.js
CKEDITOR.config.startupMode = 'wysiwyg';// wysiwyg, source

// js\_source\plugins\resize\plugin.js
CKEDITOR.config.resize_enabled = false; // true, false

// js\_source\plugins\toolbar\plugin.js
CKEDITOR.config.toolbarLocation = 'top'; // top, bottom
</script>
<%--<div id="txtContent" name="txtContent">121</div>--%>
<%--<a id='AGoTop' style='position:absolute;display:none' href='#gotop'></a>
<a id='AGoDown' style='position:absolute;display:none' href='#godown'></a>--%>
</body>
</HTML>