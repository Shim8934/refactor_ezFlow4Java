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
		{ name: 'others' },
		{ name: 'insert' },				
		{ name: 'paragraph',   groups: [ 'list', 'align' ] },
		{ name: 'colors' },
		'/',
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		{ name: 'links' },
		{ name: 'styles' },		
		{ name: 'document',	   groups: [ 'mode', 'document', 'doctools' ] }
	];

	config.uploadUrl = "/ezCommon/ckSimpleUpload.do";	
	config.extraPlugins = "_Insert_Image,pastefromexcel";
    config.line_height = "0.5;1;1.5;2;2.5;3;3.5;4;4.5;5";
    config.allowedContent = true;    
    config.specialChars = ['!', '&quot;', '#', '$', '%', '&amp;', "'", '(', ')', '*', '+', '-', '.', '/', ':', ';', '&lt;', '=', '&gt;', '?', '@', '[', ']', '^', '_', '`', '{', '|', '}', '~', "&euro;", "&lsquo;", "&rsquo;", "&ldquo;", "&rdquo;", "&ndash;", "&mdash;", "&iexcl;", "&cent;", "&pound;", "&curren;", "&yen;", "&brvbar;", "&sect;", "&uml;", "&copy;", "&ordf;", "&laquo;", "&not;", "&reg;", "&macr;", "&deg;", "&sup2;", "&sup3;", "&acute;", "&micro;", "&para;", "&middot;", "&cedil;", "&sup1;", "&ordm;", "&raquo;", "&frac14;", "&frac12;", "&frac34;", "&iquest;", "&Agrave;", "&Aacute;", "&Acirc;", "&Atilde;", "&Auml;", "&Aring;", "&AElig;", "&Ccedil;", "&Egrave;", "&Eacute;", "&Ecirc;", "&Euml;", "&Igrave;", "&Iacute;", "&Icirc;", "&Iuml;", "&ETH;", "&Ntilde;", "&Ograve;", "&Oacute;", "&Ocirc;", "&Otilde;", "&Ouml;", "&times;", "&Oslash;", "&Ugrave;", "&Uacute;", "&Ucirc;", "&Uuml;", "&Yacute;", "&THORN;", "&szlig;", "&agrave;", "&aacute;", "&acirc;", "&atilde;", "&auml;", "&aring;", "&aelig;", "&ccedil;", "&egrave;", "&eacute;", "&ecirc;", "&euml;", "&igrave;", "&iacute;", "&icirc;", "&iuml;", "&eth;", "&ntilde;", "&ograve;", "&oacute;", "&ocirc;", "&otilde;", "&ouml;", "&divide;", "&oslash;", "&ugrave;", "&uacute;", "&ucirc;", "&uuml;", "&yacute;", "&thorn;", "&yuml;", "&OElig;", "&oelig;", "&#372;", "&#374", "&#373", "&#375;", "&sbquo;", "&#8219;", "&bdquo;", "&hellip;", "&trade;", "&#9658;", "&bull;", "&rarr;", "&rArr;", "&hArr;", "&diams;", "&asymp;"]
    config.skin = 'moonocolor';    
	config.removeButtons = 'Image,Underline,Subscript,Superscript,Styles,Unlink,Anchor';
	config.format_tags = 'p;h1;h2;h3;pre';
	config.removeDialogTabs = 'link:target;link:advanced;image:Link;image:advanced;image:Upload';
	config.colorButton_colors =
	    '000,800000,8B4513,2F4F4F,008080,000080,4B0082,696969,' +
	    'B22222,A52A2A,DAA520,006400,40E0D0,0000CD,800080,808080,' +
	    'F00,FF8C00,FFD700,008000,0FF,00F,EE82EE,A9A9A9,' +
	    'FFA07A,FFA500,FFFF00,00FF00,AFEEEE,ADD8E6,DDA0DD,D3D3D3,' +
	    'FFF0F5,FAEBD7,FFFFE0,F0FFF0,F0FFFF,F0F8FF,E6E6FA,FFF';	
};