/*
Copyright (c) 2003-2009, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

(function()
{
    var cellNodeRegex = /^(?:td|th)$/;
    
    function SetSelectTDLock(tableElt, columnNo)
	{
        var rows = tableElt.$.getElementsByTagName("TR"); 
       
        for (var i = 0; i < rows.length; i++) 
        { 
            for(var j=0; j<rows[ i ].cells.length; j++)
            {
                 var elementCel = rows[ i ].getElementsByTagName("TD")[ j ]; 
                 if(elementCel.style.backgroundColor == "#000000")
                 {
                    if(elementCel.getAttribute('free') == null)
                    {
                        elementCel.setAttribute('free', '');
                    }
                    else
                    {
                        elementCel.removeAttribute('free');
                    }
                 }
            }
        } 
	}
	
	function TDLock( selection )
	{
		// Get the cell where the selection is placed in.
		var startElement = selection.getStartElement();
		var cell = startElement.getAscendant( 'td', true ) || startElement.getAscendant( 'th', true );

        // Get the cell's table.
		var table = cell.getAscendant( 'table' );
		var cellIndex = cell.$.cellIndex;
		
		if ( !cell )
			return;
		if(cell.$.style.backgroundColor == "#000000")
		{
		    SetSelectTDLock(table, cellIndex);
		}
		else
		{
		    if(cell.hasAttribute('free'))
            {
                cell.removeAttribute('free');
            }
            else
            {
                cell.setAttribute('free', '');
            }
		}
	}
	
	var _Table_TDLockCmd =
	{
		exec : function( editor )
		{
			var selection = editor.getSelection();
      
			TDLock( selection );
			
		}
	};

	var pluginName = '_Table_TDLock';

	// Register a plugin named "_Table_TDLock".
	CKEDITOR.plugins.add( pluginName,
	{
		init : function( editor )
		{
		    var lang = editor.lang;
		    
			editor.addCommand( pluginName, _Table_TDLockCmd );
			editor.ui.addButton( '_Table_TDLock',
				{
					label : lang._Table_TDLock,
					command : pluginName
				});
		}
	});
})();
