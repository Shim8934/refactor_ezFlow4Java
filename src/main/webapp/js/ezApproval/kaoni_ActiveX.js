function ezIcd_ActiveX(idName)
{
	document.writeln('<OBJECT id="' + idName + '" style="DISPLAY: none" codeBase="/ezIcd2.cab#version=1,0,0,13" data="data:application/x-oleobject;base64,GvFdR8IrqUGKl+mJ4CPlFwADAADYEwAA2BMAAA=="')
	document.writeln('classid="CLSID:475DF11A-2BC2-41A9-8A97-E989E023E517" VIEWASTEXT></OBJECT>');
}

function FormProc_ActiveX(idName,stratMode)
{
	document.writeln('<OBJECT classid=CLSID:999C3A80-04F3-44B7-8815-36ADF2319B98 id='+ idName + ' style="HEIGHT: 100%; width=100%" VIEWASTEXT>');
	document.writeln('<PARAM NAME="StartMode" VALUE="' + stratMode + '">');
	document.writeln('<PARAM NAME="SpellVal" VALUE="' + FormProcSpelling + '"></OBJECT>');
}

function FormProc_ActiveX2(idName,stratMode, width, height)
{
	document.writeln('<OBJECT classid="CLSID:999C3A80-04F3-44B7-8815-36ADF2319B98" id='+ idName + ' style="HEIGHT: '+height+'; WIDTH: '+width+'" VIEWASTEXT>');
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



function DirectSign_ActiveX(idName,width, height)
{	
	
	document.writeln('<OBJECT id='+ idName + ' width='+width+' height='+height+' border=1 classid=CLSID:13F49D22-7625-4947-BE80-999C0C122483></OBJECT>'); 
}


function EzHTTPTrans_ActiveX(idName){
	document.writeln('<object classid="clsid:BE4A5C56-B0FF-4A4C-AA95-D44BA796B1B7" id="'+idName+'" width=0 height=0></object>');
}


function EzHTTPTrans_ActiveX2(idName){
    document.writeln('<object classid="clsid:BE4A5C56-B0FF-4A4C-AA95-D44BA796B1B7" id="'+idName+'" style="HEIGHT: 100%;  WIDTH: 100%" ></object>');
}
