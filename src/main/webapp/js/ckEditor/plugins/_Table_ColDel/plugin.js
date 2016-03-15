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
	
    function deleteColumns( selectionOrCell )
	{
		if ( selectionOrCell instanceof CKEDITOR.dom.selection )
		{
			var colsToDelete = getSelectedCells( selectionOrCell );
			for ( var i = colsToDelete.length ; i >= 0 ; i-- )
			{
				if ( colsToDelete[ i ] )
					deleteColumns( colsToDelete[ i ] );
			}
		}
		else if ( selectionOrCell instanceof CKEDITOR.dom.element )
		{
			// Get the cell's table.
			var table = selectionOrCell.getAscendant( 'table' );

			// Get the cell index.
			var cellIndex = selectionOrCell.$.cellIndex;

			/*
			 * Loop through all rows from down to up, coz it's possible that some rows
			 * will be deleted.
			 */
			for ( i = table.$.rows.length - 1 ; i >= 0 ; i-- )
			{
				// Get the row.
				var row = new CKEDITOR.dom.element( table.$.rows[ i ] );

				// If the cell to be removed is the first one and the row has just one cell.
				if ( !cellIndex && row.$.cells.length == 1 )
				{
					deleteRows( row );
					continue;
				}

				// Else, just delete the cell.
				if ( row.$.cells[ cellIndex ] )
					row.$.removeChild( row.$.cells[ cellIndex ] );
			}
		}
	}


	var _Table_ColDelCmd =
	{
		exec : function( editor )
		{
			var selection = editor.getSelection();
//			var tag_id = selection.getSelectedElement();
//			alert(tag_id);
			deleteColumns( selection );
			
		}
	};

	var pluginName = '_Table_ColDel';

	// Register a plugin named "_Table_ColDel".
	CKEDITOR.plugins.add( pluginName,
	{
		init : function( editor )
		{
		    var lang = editor.lang.table;
		    
			editor.addCommand( pluginName, _Table_ColDelCmd );
			editor.ui.addButton( '_Table_ColDel',
				{
					label : lang._Table_ColDel,
					command: pluginName,
					icon: this.path + "deletecolumn.gif"
				});
		}
	});
})();
