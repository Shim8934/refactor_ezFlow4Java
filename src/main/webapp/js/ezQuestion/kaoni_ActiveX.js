// 20090316 EzHTTPTrans 기능 추가
function EzHTTPTrans_ActiveX(idName){
	document.writeln('<object classid="clsid:BE4A5C56-B0FF-4A4C-AA95-D44BA796B1B7" id="'+idName+'" width=0 height=0></object>');
}

// 20090316 Drag & Drop 기능 추가
function EzHTTPTrans_ActiveX2(idName){
    document.writeln('<object classid="clsid:BE4A5C56-B0FF-4A4C-AA95-D44BA796B1B7" id="'+idName+'" style="HEIGHT: 100%;  WIDTH: 100%" ></object>');
}

function ezQuestion_ActiveX(url, type) {
    var _MSIE = 'MSIE';
	var useragentstr = navigator.userAgent;
	if (useragentstr.indexOf(_MSIE) != -1) {
	    if (type == "3") {
	        document.writeln("<embed id='obj' src='" + url + "' width='405' height='350' autoStart='1'/>");
	    }
	    else if (type == "1")
	    { }
	    else {
	        document.writeln("<object id='oMpf' classid='clsid:6bf52a52-394a-11d3-b153-00c04f79faa6' type='application/x-oleobject' width='405' height='150'>");
	        document.writeln("<param name='autoStart' value='true'/>");
	        document.writeln("<param name='URL' value='" + url + "'/>");
	        document.writeln("<param name='EnableContextMenu' value='0'/>");
	        document.writeln("<param name='InvokeURLs' value='0'/>");
	        document.writeln("</object>");
	    }
	}
	else {
	    url = "/Common/DownloadAttach_Question.aspx?filename=&filepath=" + escape(url);
	    if (type == "3") {
	        document.writeln("<EMBED TYPE=\"application/x-mplayer2\" SRC=\"" + url + "\" NAME=\"MediaPlayer\" WIDTH=\"405\" HEIGHT=\"350\">");
	    }
	    else if (type == "1")
	    { }
	    else {
	        document.writeln("<EMBED TYPE=\"application/x-mplayer2\" SRC=\"" + url + "\" NAME=\"MediaPlayer\" WIDTH=\"405\" HEIGHT=\"150\">");
	    }
        document.writeln("<param name=\"ShowControls\" value=\"1\">");
        document.writeln("<param name=\"ShowPositionControls\" value=\"0\">");
        document.writeln("<param name=\"ShowGotoBar\" value=\"true\">");
        document.writeln("<param name=\"ShowDisplay\" value=\"true\">");
        document.writeln("<param name=\"ShowStatusBar\" value=\"true\">");
        document.writeln("</EMBED>");
	}
}