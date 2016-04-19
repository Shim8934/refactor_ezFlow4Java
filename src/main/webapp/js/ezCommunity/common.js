function OpenInformationUI(pInformationContent)
{
	var parameter = pInformationContent;
	var url = "/myoffice/ezCommunity/htm/ezAPROPINION.aspx";
	var feature = "status:no;dialogWidth:330px;dialogHeight:207px;help:no;scroll:no;edge:sunken";
	var RtnVal = window.showModalDialog(url,parameter,feature);
	return RtnVal;
}
function OpenAlertUI(pAlertContent)
{
	var parameter = pAlertContent;
	var url = "/myoffice/ezCommunity/htm/ezAPRALERT.aspx";
	var feature = "status:no;dialogWidth:330px;dialogHeight:207px;help:no;scroll:no;edge:sunken";
	var RtnVal = window.showModalDialog(url,parameter,feature);
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
