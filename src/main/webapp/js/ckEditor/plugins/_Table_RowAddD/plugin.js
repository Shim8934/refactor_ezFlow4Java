/*
Copyright (c) 2003-2009, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

(function()
{
 	function clearRow( $tr )
	{
		// Get the array of row's cells.
		var $cells = $tr.cells;

		// Empty all cells.
		for ( var i = 0 ; i < $cells.length ; i++ )
		{
			$cells[ i ].innerHTML = '';

			if ( !CKEDITOR.env.ie )
				( new CKEDITOR.dom.element( $cells[ i ] ) ).appendBogus();
		}
	}


    function insertRow( selection, insertBefore )
	{
		// Get the row where the selection is placed in.
		var row = selection.getStartElement().getAscendant( 'tr' );
		if ( !row )
			return;

		// Create a clone of the row.
		var newRow = row.clone( true );

		// Insert the new row before of it.
		newRow.insertBefore( row );

		// Clean one of the rows to produce the illusion of inserting an empty row
		// before or after.
		clearRow( insertBefore ? newRow.$ : row.$ );
	}


	var _Table_RowAddDCmd =
	{
		exec : function( editor )
		{
			var selection = editor.getSelection();
			insertRow( selection, false );
			
		}
	};

	var pluginName = '_Table_RowAddD';

	// Register a plugin named "_Table_RowAddD".
	CKEDITOR.plugins.add( pluginName,
	{
		init : function( editor )
		{
		    var lang = editor.lang.table;
		    
			editor.addCommand( pluginName, _Table_RowAddDCmd );
			editor.ui.addButton( '_Table_RowAddD',
				{
					label : lang._Table_RowAddD,
					command: pluginName,
					icon: this.path + "insertrowbelow.gif"
				});
		}
	});
})();
