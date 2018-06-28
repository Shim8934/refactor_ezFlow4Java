// 숫자 체크
function is_num(data)
{
	var temp = "";
	var nLen = data.length;
	for( var i = 0 ; i < nLen ; i++)
	{
		temp = data.substring(i, i+1);
		if( temp < "0" || temp > "9" )
			return false;
	}
	return true;
}

// 숫자 체크
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
		alert("?낅젰?섏떊 ?꾨뱶???댁슜? " + pSize + " byte 源뚯?留??낅젰??媛?ν빀?덈떎.");
		pObj.focus();
		return false;
	}
	else
		return true;
}

// 그달의 마지막날을 가져온다 (날짜만 리턴)
// pStr = 200406
function getLastDay(pStr)
{
	var pYear  = parseInt(pStr.substring(0, 4), 10);
	var pMonth = parseInt(pStr.substr(4, 2), 10);
	
	var oDate = new Date(pYear, pMonth, 1-1);
	var strLastDay = new String(oDate.getDate());
	
	return strLastDay;
}
