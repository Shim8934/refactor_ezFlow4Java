// 입력필드의 길이 체크
function CheckLen(pObj, pSize)
{
	var ch;
	var count = 0;
	var nlen = pObj.value.length;
	for(var k=0; k<nlen; k++)
	{
		ch = pObj.value.charAt(k);
		if(escape(ch).length > 4)
			count+= 2;
		else
			count++;
	}
	
	if (parseInt(count) > parseInt(pSize))
	{
		alert(strLang244 + pSize + " bytes " + strLang245);
		pObj.focus();
		return false;
	}
	else
		return true;
}