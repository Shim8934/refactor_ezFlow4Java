/*
Copyright (c) 2003-2009, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
function Insert_ImageCmd_Complete(rtn) {
    if (rtn == undefined)
        return;
    var imgSrc = rtn[0];
    var imgWidth = rtn[1];
    var imgHeight = rtn[2];
    CKEDITOR.instances.editor1.insertHtml('<img src=\"' + imgSrc + '\" width=\"' + imgWidth + '\"  height=\"' + imgHeight + '\" />')
}

(function()
{
	var _Insert_ImageCmd =
	{
		exec : function( editor )
		{
		    var selection = editor.getSelection();
		    if (!CrossYN()) {
		        var rtn = showModalDialog("/ezCommon/ckImageUpload.do", this, "dialogHeight:400px; dialogWidth:470px; status:no;scroll:no; help:no; edge:sunken");
		        if (rtn == undefined)
		            return;
		        var imgSrc = rtn[0];
		        var imgWidth = rtn[1];
		        var imgHeight = rtn[2];
		        CKEDITOR.instances.editor1.insertHtml('<img src=\"' + imgSrc + '\" width=\"' + imgWidth + '\"  height=\"' + imgHeight + '\" />')
		    }
		    else if (parent.document.location.href.toLowerCase().indexOf("/ezemail/mailsignatureck.do") > -1) {
		    	if (parent.document.getElementById("mailPanel") != null)
		            parent.DivPopUpShow(470, 400, "/ezEmail/ckImageUpload.do");
		        else
		            parent.parent.DivPopUpShow(470, 400, "/ezEmail/ckImageUpload.do");
		    }
		    else {
		        if (parent.document.getElementById("mailPanel") != null)
		            parent.DivPopUpShow(470, 400, "/ezCommon/ckImageUpload.do");
		        else
		            parent.parent.DivPopUpShow(470, 400, "/ezCommon/ckImageUpload.do");
		    }
		}
	};

	var pluginName = '_Insert_Image';

	// Register a plugin named "_Insert_Image".
	CKEDITOR.plugins.add( pluginName,
	{
		init : function( editor )
		{
		    var lang = editor.lang;
		    
			editor.addCommand( pluginName, _Insert_ImageCmd );
			editor.ui.addButton( '_Insert_Image',
				{
				    label: lang.common.image,
					command : pluginName
				});
		}
	});
})();
