var ezapropinion_cross_dialogArguments = new Array();
function OpenInformationUI(pInformationContent, FunctionName)
{
	var parameter = pInformationContent;
	var url = "/ezCommunity/ezAPROPINION.do";
	if (CrossYN()) {
		ezapropinion_cross_dialogArguments[0] = parameter;
		ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		ezapropinion_cross_dialogArguments[2] = FunctionName;
		
		var popUpW = 325;
		var popUpH = 200;
		
	    if (MACSAFARIYN())
	        popUpH = popUpH + 50;
	    
	    var left = (screen.width / 2) - (popUpW / 2);
	    var top = (screen.height / 2) - (popUpH / 2);
	    
	    var feature = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + "px ,top=" + top + "px, status = no, toolbar=no, menubar=no,location=yes";
	    var result = window.open(url, "ezAPROPINION", feature);
	}
	else {
	    var feature = "status:no;dialogWidth:330px;dialogHeight:207px;help:no;scroll:no;edge:sunken";
	    var RtnVal = window.showModalDialog(url, parameter, feature);
	    return RtnVal;
	}
}

function OpenInformationUI_Complete(RtnVal, Complete_Function) {
    if (RtnVal)
        Complete_Function(RtnVal);
}

var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezCommunity/ezAprAlert.do";

    ezapralert_cross_dialogArguments[0] = parameter;
    if (CompleteFunction != undefined) {
        ezapralert_cross_dialogArguments[1] = CompleteFunction;
    } else {
        ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
    }
    DivPopUpShow(330, 205, url);
}

function OpenAlertUI_Complete() {
    DivPopUpHidden();
}
function make_searchstring(orgStr)
{
	//return ReplaceText(ReplaceText(ReplaceText(ReplaceText(orgStr, "'", "''"), "\\[", "[[]"), "%", "[%]"), "_", "[_]");
	return ReplaceText(ReplaceText(ReplaceText(ReplaceText(ReplaceText(orgStr, "&", "[&]"), "'", "''"), "\\[", "[[]"), "%", "[%]"), "_", "[_]");
}

function make_searchstring2(orgStr)
{
	return ReplaceText(ReplaceText(ReplaceText(ReplaceText(orgStr, "&", "[&]"), "\\[", "[[]"), "%", "[%]"), "_", "[_]");
}

function ReplaceText( orgStr, findStr, replaceStr )
{
	var re = new RegExp( findStr, "gi" );
	return ( orgStr.replace( re, replaceStr ) );
}

function S4() {
    return ((CustomRandom() * 0x10000) | 0).toString(16).substring(1);
}

function GetGUID() {
    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
}

function CustomRandom() {
    var now = new Date();
    var seed = now.getMilliseconds();
    return Math.random(seed) + 1;
}
