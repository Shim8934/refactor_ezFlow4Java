function escapenew(str)
{
	if (str == undefined)
		return "";

	var ret = escape(ReplaceText(str, "·", "_kaoni_special_1_"));
	ret = ReplaceText(ReplaceText(ret, "_kaoni_special_1_", "%A1%A4"), "\\+", "%2B");
	return ret;
}

function ReplaceText(orgStr, findStr, replaceStr)
{
	var re = new RegExp(findStr, "gi");
	return (orgStr.replace(re, replaceStr));
}

// 수정(2005.06.29) : & 문자 처리
function MakeXMLString(pOrgString)
{
	return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
}
