/*
Copyright (c) 2003-2009, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

(function()
{
	function removeRawAttribute( $node, attr )
	{
		if ( CKEDITOR.env.ie )
			$node.removeAttribute( attr );
		else
			delete $node[ attr ];
	}

    var cellNodeRegex = /^(?:td|th)$/;

    function getSelectedCells( selection )
	{
		// Walker will try to split text nodes, which will make the current selection
		// invalid. So save bookmarks before doing anything.
		var bookmarks = selection.createBookmarks();

		var ranges = selection.getRanges();
		var retval = [];
		var database = {};

		function moveOutOfCellGuard( node )
		{
			// Apply to the first cell only.
			if ( retval.length > 0 )
				return;

			// If we are exiting from the first </td>, then the td should definitely be
			// included.
			if ( node.type == CKEDITOR.NODE_ELEMENT && cellNodeRegex.test( node.getName() )
					&& !node.getCustomData( 'selected_cell' ) )
			{
				CKEDITOR.dom.element.setMarker( database, node, 'selected_cell', true );
				retval.push( node );
			}
		}

		for ( var i = 0 ; i < ranges.length ; i++ )
		{
			var range = ranges[ i ];

			if ( range.collapsed )
			{
				// Walker does not handle collapsed ranges yet - fall back to old API.
				var startNode = range.getCommonAncestor();
				var nearestCell = startNode.getAscendant( 'td', true ) || startNode.getAscendant( 'th', true );
				if ( nearestCell )
					retval.push( nearestCell );
			}
			else
			{
				var walker = new CKEDITOR.dom.walker( range );
				var node;
				walker.guard = moveOutOfCellGuard;

				while ( ( node = walker.next() ) )
				{
					// If may be possible for us to have a range like this:
					// <td>^1</td><td>^2</td>
					// The 2nd td shouldn't be included.
					//
					// So we have to take care to include a td we've entered only when we've
					// walked into its children.

					var parent = node.getParent();
					if ( parent && cellNodeRegex.test( parent.getName() ) && !parent.getCustomData( 'selected_cell' ) )
					{
						CKEDITOR.dom.element.setMarker( database, parent, 'selected_cell', true );
						retval.push( parent );
					}
				}
			}
		}

		CKEDITOR.dom.element.clearAllMarkers( database );

		// Restore selection position.
		selection.selectBookmarks( bookmarks );

		return retval;
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
	
	function insertColumn( selection, insertBefore )
	{
		// Get the cell where the selection is placed in.
		var startElement = selection.getStartElement();
		var cell = startElement.getAscendant( 'td', true ) || startElement.getAscendant( 'th', true );

		if ( !cell )
			return;

		// Get the cell's table.
		var table = cell.getAscendant( 'table' );
		var cellIndex = cell.$.cellIndex;

		// Loop through all rows available in the table.
		for ( var i = 0 ; i < table.$.rows.length ; i++ )
		{
			var $row = table.$.rows[ i ];

			// If the row doesn't have enough cells, ignore it.
			if ( $row.cells.length < ( cellIndex + 1 ) )
				continue;

			cell = new CKEDITOR.dom.element( $row.cells[ cellIndex ].cloneNode( false ) );

			if ( !CKEDITOR.env.ie )
				cell.appendBogus();

			// Get back the currently selected cell.
			var baseCell = new CKEDITOR.dom.element( $row.cells[ cellIndex ] );
			if ( insertBefore )
				cell.insertBefore( baseCell );
			else
				cell.insertAfter( baseCell );
		}
	}


	var _Table_ColAddRCmd =
	{
		exec : function( editor )
		{
			var selection = editor.getSelection();
//			var tag_id = selection.getSelectedElement();
//			alert(tag_id);
			insertColumn( selection );
			
		}
	};

	var pluginName = '_Table_ColAddR';

	// Register a plugin named "_Table_ColAddR".
	CKEDITOR.plugins.add( pluginName,
	{
		init : function( editor )
		{
		    var lang = editor.lang.table;
		    
			editor.addCommand( pluginName, _Table_ColAddRCmd );
			editor.ui.addButton( '_Table_ColAddR',
				{
					label : lang._Table_ColAddR,
					command: pluginName,
					icon: this.path + "insertcolumnright.gif"
				});
		}
	});
})();
