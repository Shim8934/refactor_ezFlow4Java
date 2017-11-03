/**
 * @license Copyright (c) 2003-2017, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here.
	// For complete reference see:
	// http://docs.ckeditor.com/#!/api/CKEDITOR.config

	// The toolbar groups arrangement, optimized for two toolbar rows.
	config.toolbarGroups = [
		{ name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
		{ name: 'others' ,     groups: [ 'links' ] },
		{ name: 'paragraph',   groups: [ 'list', 'align' ] },
		{ name: 'insert' },
		'/',
		{ name: 'tables',      groups: [ 'table','tablerow','tablecolumn', 'tablecell','tablecellmergesplit' ] },		
		'/',
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		{ name: 'styles' },		
		{ name: 'colors' },
		{ name: 'document',	   groups: [ 'mode', 'document', 'doctools' ] }
	];

	config.uploadUrl = "/ezEditor/ckSimpleUpload.do";	
	config.extraPlugins = "_Insert_Image,pastefromexcel,tabletoolstoolbar";
    config.line_height = "0.5;1;1.5;2;2.5;3;3.5;4;4.5;5";
    config.allowedContent = true;    
    /*config.specialChars = ['!', '&quot;', '#', '$', '%', '&amp;', "'", '(', ')', '*', '+', '-', '.', '/', ':', ';', '&lt;', '=', '&gt;', '?', '@', '[', ']', '^', '_', '`', 
                           '{', '|', '}', '~', "&euro;", "&lsquo;", "&rsquo;", "&ldquo;", "&rdquo;", "&ndash;", "&mdash;", "&iexcl;", "&cent;", "&pound;", "&curren;", "&yen;", 
                           "&brvbar;", "&sect;", "&uml;", "&copy;", "&ordf;", "&laquo;", "&not;", "&reg;", "&macr;", "&deg;", "&sup2;", "&sup3;", "&acute;", "&micro;", "&para;", 
                           "&middot;", "&cedil;", "&sup1;", "&ordm;", "&raquo;", "&frac14;", "&frac12;", "&frac34;", "&iquest;", "&Agrave;", "&Aacute;", "&Acirc;", "&Atilde;", 
                           "&Auml;", "&Aring;", "&AElig;", "&Ccedil;", "&Egrave;", "&Eacute;", "&Ecirc;", "&Euml;", "&Igrave;", "&Iacute;", "&Icirc;", "&Iuml;", "&ETH;", "&Ntilde;", 
                           "&Ograve;", "&Oacute;", "&Ocirc;", "&Otilde;", "&Ouml;", "&times;", "&Oslash;", "&Ugrave;", "&Uacute;", "&Ucirc;", "&Uuml;", "&Yacute;", "&THORN;", 
                           "&szlig;", "&agrave;", "&aacute;", "&acirc;", "&atilde;", "&auml;", "&aring;", "&aelig;", "&ccedil;", "&egrave;", "&eacute;", "&ecirc;", "&euml;", 
                           "&igrave;", "&iacute;", "&icirc;", "&iuml;", "&eth;", "&ntilde;", "&ograve;", "&oacute;", "&ocirc;", "&otilde;", "&ouml;", "&divide;", "&oslash;", 
                           "&ugrave;", "&uacute;", "&ucirc;", "&uuml;", "&yacute;", "&thorn;", "&yuml;", "&OElig;", "&oelig;", "&#372;", "&#374", "&#373", "&#375;", "&sbquo;", 
                           "&#8219;", "&bdquo;", "&hellip;", "&trade;", "&#9658;", "&bull;", "&rarr;", "&rArr;", "&hArr;", "&diams;", "&asymp;"] */
    config.skin = 'moonocolor';
    config.specialChars = ['&larr;', '&uarr;', '&rarr;', '&darr;', '&harr;', '&#8597', '&#8598', '&#8599', '&#8600', '&#8601', '&#8606', '&#8607', '&#8608', '&#8609', '&lArr;', '&uArr;', '&rArr;',  
                           '&dArr;', '&hArr;', '&laquo;', '&raquo;', '&#8560', '&#8561', '&#8562', '&#8563', '&#8564', '&#8565', '&#8566', '&#8567', '&#8568', '&#8569', '&#8570', '&#8571', '&#8544',  
                           '&#8545', '&#8546', '&#8547', '&#8548', '&#8549', '&#8550', '&#8551', '&#8552', '&#8553', '&#8554', '&#8555', '&#8251', '&#162', '&#163', '&#164', '&#165', '&#169', 
                           '&#188', '&#189', '&#190', '&#8728', '&#8729', '&#8226', '&#8727', '&#8734', '&#8800', '&#8804', '&#8805', '&#8834', '&#8835', '&#8836', '&#8837', '&#8838', '&#8839',
                           '&#8840', '&#8841', '&#8862', '&#8863', '&#8864', '&#8865', '&#8882', '&#8883', '&#8988', '&#8989', '&#8990', '&#8991', '&#9632', '&#9633', '&#9650', '&#9651', '&#9654', 
                           '&#9655', '&#9660', '&#9661', '&#9664', '&#9665', '&#9670', '&#9671', '&#9672', '&#9673', '&#9733', '&#9734', '&#9829', '&#9825', '&#9792', '&#9794', '&#8228', '&#8229', 
                           '&#8230', '&#9312', '&#9313', '&#9314', '&#9315', '&#9316', '&#9317', '&#9318', '&#9319', '&#9320', '&#9321', '&#9332', '&#9333', '&#9334', '&#9335', '&#9336', '&#9337',
                           '&#9338', '&#9339', '&#9340', '&#9341', '&#9398', '&#9399', '&#9400', '&#9401', '&#9402', '&#9403', '&#9404', '&#9405', '&#9406', '&#9407', '&#9408', '&#9409', '&#9410', 
                           '&#9411', '&#9412', '&#9413', '&#9414', '&#9415', '&#9416', '&#9417', '&#9418', '&#9419', '&#9420', '&#9421', '&#9422', '&#9423', '&#9424', '&#9425', '&#9426', '&#9427', 
                           '&#9428', '&#9429', '&#9430', '&#9431', '&#9432', '&#9433', '&#9434', '&#9435', '&#9436', '&#9437', '&#9438', '&#9439', '&#9440', '&#9441', '&#9442', '&#9443', '&#9444', 
                           '&#9445', '&#9446', '&#9447', '&#9448', '&#9449'];
    
	config.removeButtons = 'Image,Subscript,Superscript,Styles,Unlink,Anchor,Format';
	config.format_tags = 'p;h1;h2;h3;pre';
	config.removeDialogTabs = 'link:advanced;image:Link;image:advanced;image:Upload';
	config.colorButton_colors =
	    '000,800000,8B4513,2F4F4F,008080,000080,4B0082,696969,' +
	    'B22222,A52A2A,DAA520,006400,40E0D0,0000CD,800080,808080,' +
	    'F00,FF8C00,FFD700,008000,0FF,00F,EE82EE,A9A9A9,' +
	    'FFA07A,FFA500,FFFF00,00FF00,AFEEEE,ADD8E6,DDA0DD,D3D3D3,' +
	    'FFF0F5,FAEBD7,FFFFE0,F0FFF0,F0FFFF,F0F8FF,E6E6FA,FFF';	
	
};