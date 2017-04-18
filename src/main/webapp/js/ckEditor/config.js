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
		{ name: 'forms' },		
		{ name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ] },
		{ name: 'document',	   groups: [ 'mode', 'document', 'doctools' ] },
		{ name: 'tools' },
		'/',
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },		
		{ name: 'styles' },
		{ name: 'colors' }		
	];

	config.filebrowserUploadUrl = "/ezCommon/ckSimpleUpload.do";	
	config.extraPlugins = "_Insert_Image,lineheight,pastefromexcel";
    config.line_height = "0.5;1;1.5;2;2.5;3;3.5;4;4.5;5";
    config.allowedContent = true;
    //config.font_defaultLabel = '맑은 고딕';
	//config.font_names = '맑은 고딕; 돋움; 굴림; 궁서; 바탕;' +  CKEDITOR.config.font_names;
    config.specialChars = ['!', '&quot;', '#', '$', '%', '&amp;', "'", '(', ')', '*', '+', '-', '.', '/', ':', ';', '&lt;', '=', '&gt;', '?', '@', '[', ']', '^', '_', '`', '{', '|', '}', '~', "&euro;", "&lsquo;", "&rsquo;", "&ldquo;", "&rdquo;", "&ndash;", "&mdash;", "&iexcl;", "&cent;", "&pound;", "&curren;", "&yen;", "&brvbar;", "&sect;", "&uml;", "&copy;", "&ordf;", "&laquo;", "&not;", "&reg;", "&macr;", "&deg;", "&sup2;", "&sup3;", "&acute;", "&micro;", "&para;", "&middot;", "&cedil;", "&sup1;", "&ordm;", "&raquo;", "&frac14;", "&frac12;", "&frac34;", "&iquest;", "&Agrave;", "&Aacute;", "&Acirc;", "&Atilde;", "&Auml;", "&Aring;", "&AElig;", "&Ccedil;", "&Egrave;", "&Eacute;", "&Ecirc;", "&Euml;", "&Igrave;", "&Iacute;", "&Icirc;", "&Iuml;", "&ETH;", "&Ntilde;", "&Ograve;", "&Oacute;", "&Ocirc;", "&Otilde;", "&Ouml;", "&times;", "&Oslash;", "&Ugrave;", "&Uacute;", "&Ucirc;", "&Uuml;", "&Yacute;", "&THORN;", "&szlig;", "&agrave;", "&aacute;", "&acirc;", "&atilde;", "&auml;", "&aring;", "&aelig;", "&ccedil;", "&egrave;", "&eacute;", "&ecirc;", "&euml;", "&igrave;", "&iacute;", "&icirc;", "&iuml;", "&eth;", "&ntilde;", "&ograve;", "&oacute;", "&ocirc;", "&otilde;", "&ouml;", "&divide;", "&oslash;", "&ugrave;", "&uacute;", "&ucirc;", "&uuml;", "&yacute;", "&thorn;", "&yuml;", "&OElig;", "&oelig;", "&#372;", "&#374", "&#373", "&#375;", "&sbquo;", "&#8219;", "&bdquo;", "&hellip;", "&trade;", "&#9658;", "&bull;", "&rarr;", "&rArr;", "&hArr;", "&diams;", "&asymp;"]
    config.skin = 'moonocolor';
    //config.fontSize_defaultLabel = '12px';
    //config.format_p = { element: 'p', attributes: { 'font-size': '12px' } };
	//Remove some buttons provided by the standard plugins, which are
	//not needed in the Standard(s) toolbar.
	config.removeButtons = 'Image,Underline,Subscript,Superscript';
	// Set the most common block elements.
	config.format_tags = 'p;h1;h2;h3;pre';
	// Simplify the dialog windows.
	config.removeDialogTabs = 'image:advanced;link:advanced';
};