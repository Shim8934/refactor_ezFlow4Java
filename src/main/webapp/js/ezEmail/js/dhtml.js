
var DHTMLEditCtrlLoadFlag = false;

function ToolbarInit() 
{
	editBox.InitButton(); 
	SetToolbar();
	DHTMLEditCtrlLoadFlag = true;
}

function txt_col_nor_onclick()
{
	baseColor.style.positon = "absolute";
	baseColor.style.display = "block";
	baseColor.style.posTop = 70;
	baseColor.style.posLeft = 170;	
}

function baseColorTable_onClick()
{
	txt_col_change(event.srcElement.title);
	tbContentElement.focus();
}

function manyColorShow()
{
	var color = showModalDialog("/ezCommon/manyColor.do", null, "dialogHeight:290px; dialogWidth:286px; status:no;scroll:no; help:no; edge:sunken");
	
	if(typeof(color) != "undefined")
	{	
		txt_col_change(color);
		tbContentElement.focus();
	}
}

function txt_col_change(color) 
{
	if (color != null)
		tbContentElement.ExecCommand(DECMD_SETFORECOLOR,OLECMDEXECOPT_DODEFAULT, color);
}

DECMD_BOLD =                      5000
DECMD_COPY =                      5002
DECMD_CUT =                       5003
DECMD_DELETE =                    5004
DECMD_DELETECELLS =               5005
DECMD_DELETECOLS =                5006
DECMD_DELETEROWS =                5007
DECMD_FINDTEXT =                  5008
DECMD_FONT =                      5009
DECMD_GETBACKCOLOR =              5010
DECMD_GETBLOCKFMT =               5011
DECMD_GETBLOCKFMTNAMES =          5012
DECMD_GETFONTNAME =               5013
DECMD_GETFONTSIZE =               5014
DECMD_GETFORECOLOR =              5015
DECMD_HYPERLINK =                 5016
DECMD_IMAGE =                     5017
DECMD_INDENT =                    5018
DECMD_INSERTCELL =                5019
DECMD_INSERTCOL =                 5020
DECMD_INSERTROW =                 5021
DECMD_INSERTTABLE =               5022
DECMD_ITALIC =                    5023
DECMD_JUSTIFYCENTER =             5024
DECMD_JUSTIFYLEFT =               5025
DECMD_JUSTIFYRIGHT =              5026
DECMD_LOCK_ELEMENT =              5027
DECMD_MAKE_ABSOLUTE =             5028
DECMD_MERGECELLS =                5029
DECMD_ORDERLIST =                 5030
DECMD_OUTDENT =                   5031
DECMD_PASTE =                     5032
DECMD_REDO =                      5033
DECMD_REMOVEFORMAT =              5034
DECMD_SELECTALL =                 5035
DECMD_SEND_BACKWARD =             5036
DECMD_BRING_FORWARD =             5037
DECMD_SEND_BELOW_TEXT =           5038
DECMD_BRING_ABOVE_TEXT =          5039
DECMD_SEND_TO_BACK =              5040
DECMD_BRING_TO_FRONT =            5041
DECMD_SETBACKCOLOR =              5042
DECMD_SETBLOCKFMT =               5043
DECMD_SETFONTNAME =               5044
DECMD_SETFONTSIZE =               5045
DECMD_SETFORECOLOR =              5046
DECMD_SPLITCELL =                 5047
DECMD_UNDERLINE =                 5048
DECMD_UNDO =                      5049
DECMD_UNLINK =                    5050
DECMD_UNORDERLIST =               5051
DECMD_PROPERTIES =                5052


OLECMDEXECOPT_DODEFAULT =         0 
OLECMDEXECOPT_PROMPTUSER =        1
OLECMDEXECOPT_DONTPROMPTUSER =    2

DECMDF_NOTSUPPORTED =             0 
DECMDF_DISABLED =                 1 
DECMDF_ENABLED =                  3
DECMDF_LATCHED =                  7
DECMDF_NINCHED =                  11

DEAPPEARANCE_FLAT =               0
DEAPPEARANCE_3D =                 1 

OLE_TRISTATE_UNCHECKED =          0
OLE_TRISTATE_CHECKED =            1
OLE_TRISTATE_GRAY =               2

MENU_SEPARATOR =                  ""

var QueryStatusToolbarButtons = new Array();
var QueryStatusToolbarSelects = new Array();
var ContextMenu = new Array();

function QueryStatusItem(command, element) 
{
	this.command = command;
	this.element = element;
}

function SetToolbar()
{    
	var editDOM = editBox.doc;
     
	QueryStatusToolbarButtons[0] = new QueryStatusItem(DECMD_BOLD, editDOM.all["DECMD_BOLD"]);
	QueryStatusToolbarButtons[1] = new QueryStatusItem(DECMD_INDENT, editDOM.all["DECMD_INDENT"]);
	QueryStatusToolbarButtons[2] = new QueryStatusItem(DECMD_ITALIC, editDOM.all["DECMD_ITALIC"]);
	QueryStatusToolbarButtons[3] = new QueryStatusItem(DECMD_JUSTIFYLEFT, editDOM.all["DECMD_JUSTIFYLEFT"]);
	QueryStatusToolbarButtons[4] = new QueryStatusItem(DECMD_JUSTIFYCENTER, editDOM.all["DECMD_JUSTIFYCENTER"]);
	QueryStatusToolbarButtons[5] = new QueryStatusItem(DECMD_JUSTIFYRIGHT, editDOM.all["DECMD_JUSTIFYRIGHT"]);
	QueryStatusToolbarButtons[6] = new QueryStatusItem(DECMD_ORDERLIST, editDOM.all["DECMD_ORDERLIST"]);
	QueryStatusToolbarButtons[7] = new QueryStatusItem(DECMD_OUTDENT, editDOM.all["DECMD_OUTDENT"]);
	QueryStatusToolbarButtons[8] = new QueryStatusItem(DECMD_UNDERLINE, editDOM.all["DECMD_UNDERLINE"]);
	QueryStatusToolbarButtons[9] = new QueryStatusItem(DECMD_UNORDERLIST, editDOM.all["DECMD_UNORDERLIST"]);

	QueryStatusToolbarSelects[0] = new QueryStatusItem(DECMD_GETBLOCKFMT, editDOM.all["ParagraphStyle"]);
	QueryStatusToolbarSelects[1] = new QueryStatusItem(DECMD_GETFONTNAME, editDOM.all["FontName"]);
	QueryStatusToolbarSelects[2] = new QueryStatusItem(DECMD_GETFONTSIZE, editDOM.all["FontSize"]);

	ContextMenu[0] = new ContextMenuItem(strLang28, DECMD_CUT);
	ContextMenu[1] = new ContextMenuItem(strLang29, DECMD_COPY);
	ContextMenu[2] = new ContextMenuItem(strLang30, DECMD_PASTE);
	ContextMenu[3] = new ContextMenuItem(strLang31, DECMD_DELETE);
	ContextMenu[4] = new ContextMenuItem(MENU_SEPARATOR, 0);
	ContextMenu[5] = new ContextMenuItem(strLang32, DECMD_SELECTALL);
}


function tbContentElement_DocumentComplete(obj) {
    document.getElementById(obj).editor.DOM.body.setAttribute("free", "");
	document.getElementById(obj).editor.DOM.body.topMargin = "7px";
	document.getElementById(obj).editor.DOM.body.leftMargin = "7px";
	document.getElementById(obj).editor.DOM.charset = "utf-8";
	document.getElementById(obj).editor.DOM.body.setAttribute("free", " ");
	//retStyle = document.getElementById(obj).editor.DOM.createStyleSheet("", 0);
	//retStyle.addRule("P", "margin-top:2px; margin-bottom:2px;");
	var styleTag = document.getElementById(obj).editor.DOM.createElement("style");
	var head = document.getElementById(obj).editor.DOM.getElementsByTagName("head")[0];
	head.appendChild(styleTag);
	var sheet = styleTag.sheet ? styleTag.sheet : styleTag.styleSheet;
	if (sheet.insertRule) {
	    sheet.insertRule("P {margin-top:2px; margin-bottom:2px;}", 0);
	}
	else {
	    sheet.addRule("P", "margin-top:2px; margin-bottom:2px;", 0);
	}

    var eBody

    if (obj == "tbContentElement1")
        eBody = sigBody1.innerHTML;
    if (obj == "tbContentElement2")
        eBody = sigBody2.innerHTML;
    if (obj == "tbContentElement3")
        eBody = sigBody3.innerHTML;
	
	eBody = "<div style=\"font-family:" + strLang33+ "\"><div>" + eBody + "</div></div>";
	document.getElementById(obj).editor.DOM.body.innerHTML = eBody;
	var retVal = document.getElementById(obj).editor.DOM.body.createTextRange();
	retVal.collapse(true);
	retVal.select();
}
function tbContentElement_DocumentComplete2(obj) {
    document.getElementById(obj).editor.DOM.body.setAttribute("free", "");
    document.getElementById(obj).editor.DOM.body.topMargin = "7px";
    document.getElementById(obj).editor.DOM.body.leftMargin = "7px";
    document.getElementById(obj).editor.DOM.charset = "utf-8";
    document.getElementById(obj).editor.DOM.body.setAttribute("free", " ");
    //retStyle = document.getElementById(obj).editor.DOM.createStyleSheet("", 0);
    //retStyle.addRule("P", "margin-top:2px; margin-bottom:2px;");
    var styleTag = document.getElementById(obj).editor.DOM.createElement("style");
    var head = document.getElementById(obj).editor.DOM.getElementsByTagName("head")[0];
    head.appendChild(styleTag);
    var sheet = styleTag.sheet ? styleTag.sheet : styleTag.styleSheet;
    if (sheet.insertRule) {
        sheet.insertRule("P {margin-top:2px; margin-bottom:2px;}", 0);
    }
    else {
        sheet.addRule("P", "margin-top:2px; margin-bottom:2px;", 0);
    }

    var eBody

    if (obj == "tbContentElement1")
        eBody = document.getElementById("BujaeBody1").innerHTML;
    if (obj == "tbContentElement2")
        eBody = document.getElementById("BujaeBody2").innerHTML;
    //if (obj == "tbContentElement3")
    //    eBody = sigBody3.innerHTML;

    eBody = "<div style=\"font-family:" + strLang33 + "\"><div>" + eBody + "</div></div>";
    document.getElementById(obj).editor.DOM.body.innerHTML = eBody;
    var retVal = document.getElementById(obj).editor.DOM.body.createTextRange();
    retVal.collapse(true);
    retVal.select();
}

function tbContentElement_DisplayChanged()
{
	if (!DHTMLEditCtrlLoadFlag)
		return;

	try {
		var state;
       
		for (var i=0; i<QueryStatusToolbarButtons.length; i++) 
		{
			state = tbContentElement.QueryStatus(QueryStatusToolbarButtons[i].command);
			if (state == DECMDF_DISABLED || state == DECMDF_NOTSUPPORTED)
				editBox.TBSetState(QueryStatusToolbarButtons[i].element, "gray");
			else if (state == DECMDF_ENABLED  || state == DECMDF_NINCHED)
				editBox.TBSetState(QueryStatusToolbarButtons[i].element, "unchecked");
			else
				editBox.TBSetState(QueryStatusToolbarButtons[i].element, "checked");
		}
	 
		for (i=0; i<QueryStatusToolbarSelects.length; i++)
		{
			state = tbContentElement.QueryStatus(QueryStatusToolbarSelects[i].command);

			if (state == DECMDF_DISABLED || state == DECMDF_NOTSUPPORTED)
				QueryStatusToolbarSelects[i].element.disabled = true;
			else
			{
				QueryStatusToolbarSelects[i].element.disabled = false;
				var statevalue = tbContentElement.ExecCommand(QueryStatusToolbarSelects[i].command, OLECMDEXECOPT_DODEFAULT);				

				if (i==0)
				{
					for (var j=0; i<QueryStatusToolbarSelects[i].element.options.length; j++)
						if (QueryStatusToolbarSelects[i].element.options.item(j).value.substr(0, statevalue.length) == statevalue)
						{
							QueryStatusToolbarSelects[i].element.value = QueryStatusToolbarSelects[i].element.options.item(j).value;
							break;
						}
				}
				else
					QueryStatusToolbarSelects[i].element.value = statevalue;
			}
		}
	} catch(e) {}
}

function tbContentElement_ShowContextMenu() 
{
	var menuStrings = new Array();
	var menuStates = new Array();
	var state;
	var idx = 0;
	  
	for (var i=0; i<ContextMenu.length; i++) 
	{
		menuStrings[i] = ContextMenu[i].string;

		if (menuStrings[i] != MENU_SEPARATOR) 
			state = tbContentElement.QueryStatus(ContextMenu[i].cmdId);
		else
			state = DECMDF_ENABLED;

		if (state == DECMDF_DISABLED || state == DECMDF_NOTSUPPORTED) 
			menuStates[i] = OLE_TRISTATE_GRAY;
		else if (state == DECMDF_ENABLED || state == DECMDF_NINCHED)
			menuStates[i] = OLE_TRISTATE_UNCHECKED;
		else
			menuStates[i] = OLE_TRISTATE_CHECKED;
	}
	  
	tbContentElement.SetContextMenu(menuStrings, menuStates);
}

function tbContentElement_ContextMenuAction(itemIndex) 
{	  
	tbContentElement.ExecCommand(ContextMenu[itemIndex].cmdId, OLECMDEXECOPT_DODEFAULT);
}
	
function ContextMenuItem(string, cmdId) 
{
	this.string = string;
	this.cmdId = cmdId;
}

