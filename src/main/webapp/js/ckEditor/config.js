/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
    // config.uiColor = '#AADC6E';
    //'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '_Insert_Image']
    if (config.toolbar == "NOIMAGE")
        config.toolbar = [['Bold', 'Italic', 'Underline', 'Strike', '-', 'TextColor', 'BGColor'], ['NumberedList', 'BulletedList', 'Outdent', 'Indent', 'ShowBlocks', '-', 'Table', 'Tabletools'], ['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'], '/', ['Styles', 'Format', 'Font', 'FontSize'], ['SpecialChar'], ['Undo', 'Redo', 'Link'], ['Source']];
    else if (config.toolbar == "NODRAGIMAGE")
        config.toolbar = [['Bold', 'Italic', 'Underline', 'Strike', '-', 'TextColor', 'BGColor'], ['NumberedList', 'BulletedList', 'Outdent', 'Indent', 'ShowBlocks', '-', 'Table', 'Tabletools'], ['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '_Insert_Image'], '/', ['Styles', 'Format', 'Font', 'FontSize'], ['SpecialChar'], ['Undo', 'Redo', 'Link'], ['Source']];
    else
        config.toolbar = [['Bold', 'Italic', 'Underline', 'Strike', '-', 'TextColor', 'BGColor'], ['NumberedList', 'BulletedList', 'Outdent', 'Indent', 'ShowBlocks', '-', 'Table', 'Tabletools'], ['JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '_Insert_Image', 'addImage'], '/', ['Styles', 'Format', 'Font', 'FontSize'], ['lineheight'], ['SpecialChar'], ['Undo', 'Redo', 'Link'], ['Source']];


    config.filebrowserUploadUrl = "/ezCommon/ckSimpleUpload.do";
    config.extraPlugins = "_Insert_Image,tableresize,imagepaste,simpleuploads";
    config.removePlugins = 'contextmenu,liststyle';
    config.allowedContent = true;
    //config.font_defaultLabel = '맑은 고딕';
	//config.font_names = '맑은 고딕; 돋움; 굴림; 궁서; 바탕;' +  CKEDITOR.config.font_names;
    config.specialChars = ['!', '&quot;', '#', '$', '%', '&amp;', "'", '(', ')', '*', '+', '-', '.', '/', ':', ';', '&lt;', '=', '&gt;', '?', '@', '[', ']', '^', '_', '`', '{', '|', '}', '~', "&euro;", "&lsquo;", "&rsquo;", "&ldquo;", "&rdquo;", "&ndash;", "&mdash;", "&iexcl;", "&cent;", "&pound;", "&curren;", "&yen;", "&brvbar;", "&sect;", "&uml;", "&copy;", "&ordf;", "&laquo;", "&not;", "&reg;", "&macr;", "&deg;", "&sup2;", "&sup3;", "&acute;", "&micro;", "&para;", "&middot;", "&cedil;", "&sup1;", "&ordm;", "&raquo;", "&frac14;", "&frac12;", "&frac34;", "&iquest;", "&Agrave;", "&Aacute;", "&Acirc;", "&Atilde;", "&Auml;", "&Aring;", "&AElig;", "&Ccedil;", "&Egrave;", "&Eacute;", "&Ecirc;", "&Euml;", "&Igrave;", "&Iacute;", "&Icirc;", "&Iuml;", "&ETH;", "&Ntilde;", "&Ograve;", "&Oacute;", "&Ocirc;", "&Otilde;", "&Ouml;", "&times;", "&Oslash;", "&Ugrave;", "&Uacute;", "&Ucirc;", "&Uuml;", "&Yacute;", "&THORN;", "&szlig;", "&agrave;", "&aacute;", "&acirc;", "&atilde;", "&auml;", "&aring;", "&aelig;", "&ccedil;", "&egrave;", "&eacute;", "&ecirc;", "&euml;", "&igrave;", "&iacute;", "&icirc;", "&iuml;", "&eth;", "&ntilde;", "&ograve;", "&oacute;", "&ocirc;", "&otilde;", "&ouml;", "&divide;", "&oslash;", "&ugrave;", "&uacute;", "&ucirc;", "&uuml;", "&yacute;", "&thorn;", "&yuml;", "&OElig;", "&oelig;", "&#372;", "&#374", "&#373", "&#375;", "&sbquo;", "&#8219;", "&bdquo;", "&hellip;", "&trade;", "&#9658;", "&bull;", "&rarr;", "&rArr;", "&hArr;", "&diams;", "&asymp;"]
    config.removeDialogTabs = 'table:advanced;tableProperties:advanced;image:advanced;image:Link';
    config.image_removeLinkByEmptyURL = false;
    config.skin = 'office2013';
    //config.fontSize_defaultLabel = '12px';
    //config.format_p = { element: 'p', attributes: { 'font-size': '12px' } };

    config.extraPlugins = "_Insert_Image,tableresize,imagepaste,simpleuploads,lineheight";
    config.line_height = "0.5;1;1.5;2;2.5;3;3.5;4;4.5;5";
};

//CKEDITOR.on('dialogDefinition', function (ev) {
//    var dialogName = ev.data.name;
//    var dialogDefinition = ev.data.definition;
    
//    if (dialogName === 'table') {
//        var infoTab = dialogDefinition.getContents('info');
//        var cellSpacing = infoTab.get('txtCellSpace');
//        cellSpacing['default'] = "0";
//        var cellPadding = infoTab.get('txtCellPad');
//        cellPadding['default'] = "0";
//        var border = infoTab.get('txtBorder');
//        border['default'] = "1";
//    }
//});
