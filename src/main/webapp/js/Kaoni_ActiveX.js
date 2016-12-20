function ezIcd_ActiveX(idName)
{
	document.writeln('<OBJECT id="' + idName + '" style="DISPLAY: none" codeBase="/ezIcd2.cab#version=1,0,2,5" data="data:application/x-oleobject;base64,GvFdR8IrqUGKl+mJ4CPlFwADAADYEwAA2BMAAA=="')
	document.writeln('classid="CLSID:475DF11A-2BC2-41A9-8A97-E989E023E517" VIEWASTEXT></OBJECT>');
}

function FormProc_ActiveX(idName,stratMode)
{
	document.writeln('<OBJECT classid=CLSID:999C3A80-04F3-44B7-8815-36ADF2319B98 id='+ idName + ' style="HEIGHT: 100%" width="100%" VIEWASTEXT>');
	document.writeln('<PARAM NAME="StartMode" VALUE="' + stratMode + '">');
	document.writeln('<PARAM NAME="SpellVal" VALUE="' + FormProcSpelling + '"></OBJECT>');
}


function FormProc_ActiveX3(idName, stratMode, width) {
    document.writeln('<OBJECT classid="CLSID:999C3A80-04F3-44B7-8815-36ADF2319B98" id=' + idName + ' style="HEIGHT: 100%; WIDTH: ' + width + '" VIEWASTEXT>');
    document.writeln('<PARAM NAME="StartMode" VALUE="' + stratMode + '">');
    document.writeln('<PARAM NAME="SpellVal" VALUE="' + FormProcSpelling + '"></OBJECT>');
}

function ezUtil_ActiveX(idName)
{
	document.writeln('<OBJECT id=' + idName + ' style="WIDTH: 0px; HEIGHT: 0px" classid=clsid:B8E6A1B2-67A4-4CA4-8098-7C4D9F7E05C2></OBJECT>');
}

function ezTreeView_ActiveX(idName)
{
	document.writeln('<object classid="clsid:35609FBF-EE92-472F-B72A-599B70D21F9E" id="' + idName + '" style="HEIGHT: 0px; WIDTH: 0px; display:none;" VIEWASTEXT></object>');
}

function ezListView_ActiveX(idName)
{
	document.writeln('<object classid="clsid:F8E93A35-2D04-4E2C-A04D-87947594C674" height="0"  id="' + idName + '"  width="0" style="DISPLAY: none"></object>');
}

function ezToolBar_ActiveX(idName, dataPath)
{
	document.writeln('<OBJECT data="' + dataPath + '" id="' + idName + '" style="HEIGHT: 100%; WIDTH: 100%; background-Color:#D1DBE2" type="text/x-scriptlet" VIEWASTEXT></OBJECT>');
}

function ezDhtmlEditor_ActiveX(idName)
{
	document.writeln('<OBJECT width="100%" height="100%" classid="clsid:2D360201-FFF5-11D1-8D03-00A0C959BC0A" id="' + idName + '" style="BORDER-BOTTOM: #7b833d 0px; BORDER-LEFT: #7b833d 0px; BORDER-RIGHT: #7b833d 0px; BORDER-TOP: #7b833d 0px; WIDTH: 100%" VIEWASTEXT>');
	document.writeln('<PARAM NAME="ActivateApplets" VALUE="0">');
	document.writeln('<PARAM NAME="ActivateActiveXControls" VALUE="-1">');
	document.writeln('<PARAM NAME="ActivateDTCs" VALUE="-1">');
	document.writeln('<PARAM NAME="ShowDetails" VALUE="0">');
	document.writeln('<PARAM NAME="ShowBorders" VALUE="0">');
	document.writeln('<PARAM NAME="Appearance" VALUE="1">');
	document.writeln('<PARAM NAME="Scrollbars" VALUE="-1">');
	document.writeln('<PARAM NAME="ScrollbarAppearance" VALUE="1">');
	document.writeln('<PARAM NAME="SourceCodePreservation" VALUE="-1">');
	document.writeln('<PARAM NAME="AbsoluteDropMode" VALUE="0">');
	document.writeln('<PARAM NAME="SnapToGrid" VALUE="0">');
	document.writeln('<PARAM NAME="SnapToGridX" VALUE="50">');
	document.writeln('<PARAM NAME="SnapToGridY" VALUE="50">');
	document.writeln('<PARAM NAME="UseDivOnCarriageReturn" VALUE="1">');
	document.writeln('</OBJECT>');
}

function ezOPoster_ActiveX(idName)
{
	document.writeln('<OBJECT id="' + idName + '" TABINDEX="-1" STYLE="display:none;" CLASSID="CLSID:19E224CA-6992-425C-8006-8FA6FD2BD9E5"></OBJECT>');
}

function ezHwpCtrl_ActiveX(idName, startMode, statusBar, toolBar, menuBar)
{
	document.writeln('<OBJECT id="' + idName + '" height="100%" width="100%" align=center STYLE="LEFT: 0px; TOP: 0px" CLASSID="CLSID:1D50E26E-E51E-4153-93DD-D08745457090" VIEWASTEXT>');
	document.writeln('<PARAM NAME="StartMode" VALUE="' + startMode + '">');
	document.writeln('<PARAM NAME="StatusBar" VALUE="' + statusBar + '">');
	
	if( toolBar != "" )
		document.writeln('<PARAM NAME="ToolBar" VALUE="' + toolBar + '">');
	
	if( menuBar != "" )
		document.writeln('<PARAM NAME="MenuBar" VALUE="' + menuBar + '">');
	
	document.writeln('</OBJECT>');
}

function ezHwpCtrl_ActiveX2(idName, startMode, statusBar, toolBar, menuBar, width, height)
{
	document.writeln('<OBJECT id="' + idName + '" height="' + height + '" width="' + width + '" align=center STYLE="LEFT: 0px; TOP: 0px" CLASSID="CLSID:1D50E26E-E51E-4153-93DD-D08745457090" VIEWASTEXT>');
	document.writeln('<PARAM NAME="StartMode" VALUE="' + startMode + '">');
	document.writeln('<PARAM NAME="StatusBar" VALUE="' + statusBar + '">');
	
	if( toolBar != "" )
		document.writeln('<PARAM NAME="ToolBar" VALUE="' + toolBar + '">');
	
	if( menuBar != "" )
		document.writeln('<PARAM NAME="MenuBar" VALUE="' + menuBar + '">');
	
	document.writeln('</OBJECT>');
}

function ezCert_ActiveX(idName)
{
	document.writeln('<OBJECT id="' + idName + '" classid=CLSID:84BD92FA-A636-4D76-8B7B-657592E61483 style="HEIGHT: 260px" width=400 VIEWASTEXT>')
	document.writeln('<PARAM NAME="_ExtentX" VALUE="10583"><PARAM NAME="_ExtentY" VALUE="6879"></OBJECT>');
}

function ezQuestion_ActiveX(url, type)
{
	if( type == "3" )
	{
		document.writeln("<embed id='obj' src='" + url + "' width='392' height='340' autoStart='1'/>");
	}
	else
	{
		document.writeln("<object id='oMpf' classid='clsid:6bf52a52-394a-11d3-b153-00c04f79faa6' type='application/x-oleobject' width='392' height='45'>");
		document.writeln("<param name='autoStart' value='true'/>");
		document.writeln("<param name='URL' value='" + url + "'/>");
		document.writeln("<param name='EnableContextMenu' value='0'/>");
		document.writeln("<param name='InvokeURLs' value='0'/>");
		document.writeln("</object>");
	}
}

function ezWordCtrl_ActiveX(idName, width, height, version, extentx, extenty, stockprops)
{
	document.writeln("<OBJECT id=\"" + idName + "\" style=\"HEIGHT:" + height + "\" width=\"" + width + "\" classid=\"CLSID:9F7DCFE6-E95C-48F1-A3F6-C5431FD8C96A\">");
	document.writeln("<PARAM NAME=\"_Version\" VALUE=\"" + version + "\">");
	document.writeln("<PARAM NAME=\"_ExtentX\" VALUE=\"" + extentx + "\">");
	document.writeln("<PARAM NAME=\"_ExtentY\" VALUE=\"" + extenty + "\">");
	document.writeln("<PARAM NAME=\"_StockProps\" VALUE=\"" + stockprops + "\">");
	document.writeln("</OBJECT>");
}

function EzHTTPTrans_ActiveX(idName){
	document.writeln('<object classid="clsid:BE4A5C56-B0FF-4A4C-AA95-D44BA796B1B7" id="'+idName+'" width=0 height=0></object>');
}

function EzHTTPTrans_ActiveX2(idName){
    document.writeln('<object classid="clsid:BE4A5C56-B0FF-4A4C-AA95-D44BA796B1B7" id="'+idName+'" style="HEIGHT: 100%;  WIDTH: 100%" ></object>');
}
