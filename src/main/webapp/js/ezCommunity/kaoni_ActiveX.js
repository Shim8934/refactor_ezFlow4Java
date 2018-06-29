function toolbar_ActiveX()
{
	document.writeln("<OBJECT data='/myoffice/ezCommunity/Editor/ToolbarScriptlet.aspx' id='editBox' style='HEIGHT:25; WIDTH: 100%; background-Color:#D1DBE2' type='text/x-scriptlet' VIEWASTEXT> </OBJECT>");
}

function FormProc_ActiveX()
{
	document.writeln("<object width='100%' height='320' classid='clsid:75C3B556-E712-42CD-9B21-CF5B86CC7425' id='tbContentElement' style='BORDER-BOTTOM: #7b833d 0px; BORDER-LEFT: #7b833d 0px; BORDER-RIGHT: #7b833d 0px; BORDER-TOP: #7b833d 0px; WIDTH: 100%;' VIEWASTEXT> ");
	document.writeln("<param name='ActivateApplets' value='0'> ");
	document.writeln("<param name='ActivateActiveXControls' value='-1'> ");
	document.writeln("<param name='ActivateDTCs' value='-1'> ");
	document.writeln("<param name='ShowDetails' value='0'> ");
	document.writeln("<param name='ShowBorders' value='0'> ");
	document.writeln("<param name='Appearance' value='1'> ");
	document.writeln("<param name='Scrollbars' value='-1'> ");
	document.writeln("<param name='ScrollbarAppearance' value='1'> ");
	document.writeln("<param name='SourceCodePreservation' value='-1'> ");
	document.writeln("<param name='AbsoluteDropMode' value='0'> ");
	document.writeln("<param name='SnapToGrid' value='0'> ");
	document.writeln("<param name='SnapToGridX' value='50'> ");
	document.writeln("<param name='SnapToGridY' value='50'> ");
	document.writeln("<param name='UseDivOnCarriageReturn' value='1'> ");
	document.writeln("</object>");
}

function toolbar_ActiveX2()
{
	document.writeln("<OBJECT data='/myoffice/ezCommunity/Editor/ToolbarScriptlet.aspx' id=editBox style='HEIGHT:25; WIDTH: 100%; background-Color:#D1DBE2' type=text/x-scriptlet VIEWASTEXT> </OBJECT>");
}

function FormProc_ActiveX_Board(idName,stratMode, width, height)
{
    document.writeln('<OBJECT classid="CLSID:999C3A80-04F3-44B7-8815-36ADF2319B98" id='+ idName + ' style="HEIGHT: '+height+'; WIDTH: '+width+'" VIEWASTEXT>');
    document.writeln('<PARAM NAME="StartMode" VALUE="' + stratMode + '">');
    document.writeln('<PARAM NAME="SpellVal" VALUE="' + FormProcSpelling + '"></OBJECT>');
}

function FormProc_ActiveX2()
{
	document.writeln("<object width='100%' height=300 classid=clsid:75C3B556-E712-42CD-9B21-CF5B86CC7425 id=tbContentElement style='BORDER-BOTTOM: #7b833d 0px; BORDER-LEFT: #7b833d 0px; BORDER-RIGHT: #7b833d 0px; BORDER-TOP: #7b833d 0px; WIDTH: 100%;' VIEWASTEXT> ");
	document.writeln("<param name='ActivateApplets' value='0'> ");
	document.writeln("<param name='ActivateActiveXControls' value='-1'> ");
	document.writeln("<param name='ActivateDTCs' value='-1'> ");
	document.writeln("<param name='ShowDetails' value='0'> ");
	document.writeln("<param name='ShowBorders' value='0'> ");
	document.writeln("<param name='Appearance' value='1'> ");
	document.writeln("<param name='Scrollbars' value='-1'> ");
	document.writeln("<param name='ScrollbarAppearance' value='1'> ");
	document.writeln("<param name='SourceCodePreservation' value='-1'> ");
	document.writeln("<param name='AbsoluteDropMode' value='0'> ");
	document.writeln("<param name='SnapToGrid' value='0'> ");
	document.writeln("<param name='SnapToGridX' value='50'> ");
	document.writeln("<param name='SnapToGridY' value='50'> ");
	document.writeln("<param name='UseDivOnCarriageReturn' value='1'> ");
	document.writeln("</object>");
}

function EzHTTPTrans_ActiveX(idName){
	document.writeln('<object classid="clsid:BE4A5C56-B0FF-4A4C-AA95-D44BA796B1B7" id="'+idName+'" width=0 height=0></object>');
}

function EzHTTPTrans_ActiveX2(idName){
    document.writeln('<object classid="clsid:BE4A5C56-B0FF-4A4C-AA95-D44BA796B1B7" id="'+idName+'" style="HEIGHT: 125%;  WIDTH: 100%" ></object>');
}