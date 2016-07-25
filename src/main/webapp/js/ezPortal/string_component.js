

// orgStr 의 문자열 중에 findStr 에 해당하는 문자열을 replaceStr 로 바꿉니다.
// 이 때 findStr 에는 정규식에 해당하는 문자열 경우 "\\" + findStr 형식으로 주어야 합니다.
function ReplaceText( orgStr, findStr, replaceStr )
{
	var re = new RegExp( findStr, "gi" );
	
	return ( orgStr.replace( re, replaceStr ) );
}

// 만약 var text = "<body> test is good </body>" 라는 문장에서 <body/> 사이의 문장만을 
// 가져오고 싶으면

function ExtractBetweenPattern( orgStr, firstPattern, lastPattern )
{
	var sIndex, eIndex;
	var copyStr = new String( orgStr );
	var retStr = "", subStr;
	
	var regFExp = new RegExp( firstPattern, "i" );
	var regEExp = new RegExp( lastPattern, "i" );
	
	var loop = 0;

	sIndex = copyStr.search( regFExp );
	
	if( sIndex == -1 )
	  return orgStr;
		
	copyStr = copyStr.substr( sIndex + firstPattern.length );

	eIndex = copyStr.search( regEExp );
	
	if ( eIndex == -1 ) {
		return copyStr;
	}
	
	retStr = copyStr.substr( 0, eIndex );
	
	return retStr;
}

// 만약 var text = "test is good( deltext )" 라는 문장에서 양괄호를 포함해서 삭제를 하고 싶으면
// ReplacePattern( text, "\\(", "\\)" ) 라고 하면 됩니다. 
function RemoveBetweenPattern( orgStr, firstPattern, lastPattern )  
{
	var sIndex, eIndex;
	var copyStr = new String( orgStr );
	var retStr = "", subStr;
	
	var regFExp = new RegExp( firstPattern, "i" );
	var regEExp = new RegExp( lastPattern, "i" );
	
	var loop = 0;

	do {
		// 우선 firstPattern 을 찾습니다.
		sIndex = copyStr.search( regFExp );
		if ( sIndex == -1 ) {
			retStr += copyStr;
			break;
		}
		
		// 발견된 문자열까지의 문자열을 발췌합니다.
		retStr += copyStr.substr( 0, sIndex );
		
		eIndex = copyStr.search( regEExp );
		if ( eIndex == -1 ) {
			retStr += copyStr.substr( sIndex );
			break;
		}
		
		copyStr = copyStr.substr( eIndex + 1 );		
		
	} while ( true );
	
	return retStr;
}

function RemoveBackSlash( orgStr )
{
	var copyStr = new String( orgStr );
	
	copyStr = ReplaceText( copyStr, "\\\\\\\\", "&backslash;" );
	copyStr = ReplaceText( copyStr, "\\\\", "" );
	copyStr = ReplaceText( copyStr, "&backslash;", "\\" );
	
	return copyStr;
}

// 주어진 str 문자열중에 Number 에 해당하는 문자를 제외하고 모든 것을 제거합니다.
function extractNumber( str )
{
	var Num;
	var strNum = "";
	var strIndex;

	for ( strIndex = 0; strIndex < str.length; strIndex ++ ) {
		if ( str.charAt(strIndex) == ' ' ) continue;
		Num = Number( str.charAt( strIndex ) );
		if ( isNaN( Num ) ) continue;
		strNum += String( Num );
	}

	return strNum;
}

// 텍스트 앞뒤의 공백문자를 제거합니다.
function TrimText( orgStr )
{
	var copyStr = "";
	var strIndex;

	// 앞의 공백을 제거합니다.
	for ( strIndex = 0; strIndex < orgStr.length; strIndex ++ ) {
		if ( orgStr.charAt(strIndex) == ' ' ) continue;
		else {
			copyStr = orgStr.substr( strIndex );
			break;
		}
	}
	
	// 뒤의 공백을 제거합니다.
	
	for (strIndex = copyStr.length - 1; strIndex >= 0; strIndex -- ) {
		if ( copyStr.charAt(strIndex) == ' ' ) 
		{
		continue;
		}
		else {
			copyStr = copyStr.substr( 0, strIndex + 1 );
			break;
		}
	}
	
	return copyStr;
}

// 주어진 10진수 숫자를 주어진 16진법으로 변환한 문자열로 돌려줍니다.

function convertRadix16( orgNum )
{
	var copyNum;
	
	// 음수 이면
	
	if ( orgNum < 0 ) {
		orgNum = -orgNum;
		copyNum = 65536 - orgNum;
		return copyNum.toString(16);
	} 
	
	return orgNum.toString(16);
}

// 주어진 16진수 숫자를 10진법으로 변환해 문자열로 돌려줍니다.
function convertRadix10( orgHex )
{
	var copyNum = String( orgHex );
	var i;
	var tempVal = 0;
	var retVal = 0;
	
	for ( i = 0; i < copyNum.length; i ++ ) {
		tempVal = HexToDec( copyNum.charAt(i) );
		tempVal = tempVal * Math.pow( 16, copyNum.length - i - 1 );
		retVal += tempVal;
	}
	
	return retVal;
}

// 주어진 길이의 포맷으로 문자열을 반환합니다.
// 예:
//   var retVal = makeString( 10, "0", "19" ); // retVal = "0000000019";
function makeString( strLen, empCh, custStr )
{
	var index;
	var szEmpty = "";
	
	for ( index = custStr.length; index < strLen; index ++ ) {
		szEmpty	+= empCh;
	}
	
	return( szEmpty + custStr );
}

// HEX 문자를 10 진수값으로 변환해서 돌려줍니다.
function HexToDec( orgHex )
{
	var numVal = Number( orgHex );
	var chVal = String( orgHex ).toUpperCase();
	
	if ( isNaN( numVal ) ) {
		switch ( chVal ) {
		case "A":
			numVal = 10;
			break;
			
		case "B":
			numVal = 11;
			break;
			
		case "C":
			numVal = 12;
			break;
			
		case "D":
			numVal = 13;
			break;
			
		case "E":
			numVal = 14;
			break;
			
		case "F":
			numVal = 15;
			break;
		}
	}
	
	return numVal;
}

// findText 문자열이 발견되기 이전까지의 문자열을 건너뜁니다.
// 대소문자 구분하지 않음
function CutBeforeText( orgText, findText )
{
	var tempStr = new String( orgText );
	var findStr = new String( findText );
	
	tempStr = tempStr.toUpperCase();
	findStr = findStr.toUpperCase();
	var indexPos = tempStr.indexOf( findStr );
	return ( orgText.substr( indexPos + findText.length ) );	
}

// 마지막 인덱스부터 시작해서 findText 문자열이 발견되기 이전까지의 문자열을 건너뜁니다.
function CutAfterText( orgText, findText )
{
	var indexPos = orgText.lastIndexOf( findText );
	return ( orgText.substr( 0, indexPos ) );	
}

// 파일명에 적합한 내용으로 변환합니다.
function ToValidFileName( orgName, bForSave )
{
	var tempName = new String( orgName );

	tempName = ReplaceText( tempName, "\\%", "%25" );
	tempName = ReplaceText( tempName, ":", "%3A" );
	tempName = ReplaceText( tempName, "\\|", "%7C" );
	tempName = ReplaceText( tempName, "\\\\", "_xf8fe_" );
	
	if ( bForSave == true ) {
		tempName = ReplaceText( tempName, "\\/", "_xf8ff_" );
		tempName = ReplaceText( tempName, "\\*", "%2A" );
	}
	
	tempName = ReplaceText( tempName, "\\<", "%3C" );
	tempName = ReplaceText( tempName, "\\>", "%3E" );
	
	tempName = ReplaceText( tempName, "\\?", "%3F" );
	tempName = ReplaceText( tempName, "_x003F_", "%3F" );
	tempName = ReplaceText( tempName, "\\\"", "%22" );

	tempName = ReplaceText( tempName, "_x007E_", "~" );
	tempName = ReplaceText( tempName, "\\*", "%2A");

	return tempName;
}

// UTF8 인코딩된 문자열에서 파일명에 적합한 내용으로 변환합니다.
function ToValidFileNameUTF8( orgName )
{
	var tempName = new String( orgName );
	
	tempName = ReplaceText( tempName, "\\%25", "%2525" );
	tempName = ReplaceText( tempName, "\\%3A", "%253A" );
	tempName = ReplaceText( tempName, "\\%7c", "%257C" );
	
	tempName = ReplaceText( tempName, "\\%3f", "%253F" );
	
	tempName = ReplaceText( tempName, "\\%22", "%2522" );
	
	tempName = ReplaceText( tempName, "\\%7e", "%257E" );
	
	return tempName;
}

// 파일명에 적합한 내용으로 변환합니다.
function ToValidFileNameForPhysical(orgName)
{
	var tempName = new String( orgName );

	tempName = ReplaceText( tempName, "_x007E_", "~" );
	tempName = ReplaceText( tempName, "\\*", "%2A");

	return tempName;
}

// 이미지 첨부시 인코드된 형태로 변경하는 함수입니다.
function EncodeForFileName(orgName)
{
	var tempName = new String(orgName);

	tempName = ReplaceText( tempName, " ", "%20");
	
	return tempName;
}

// XML 에서 사용하는 문자들을 Entity Reference로 변경합니다.
function ConvertCharToEntityReference(szData)
{
	if(typeof(szData) == "undefined" || szData == null || szData == "") return "";
	
	var tempStr = new String(szData);
	
	tempStr = ReplaceText(tempStr, "&", "&amp;");	
	tempStr = ReplaceText(tempStr, "<", "&lt;");
	tempStr = ReplaceText(tempStr, ">", "&gt;");
	
	return tempStr;
}

// Entity Reference로 문자로 변경합니다.
function ConvertEntityReferenceToChar(szData)
{
	if(typeof(szData) == "undefined" || szData == null || szData == "") return "";
	
	var tempStr = new String(szData);
	
	tempStr = ReplaceText(tempStr, "&gt;", ">");	
	tempStr = ReplaceText(tempStr, "&lt;", "<");
	tempStr = ReplaceText(tempStr, "&amp;", "&");

	return tempStr;
}

function ConvertStringForASP(szData)
{
	if(typeof(szData) == "undefined" || szData == null || szData == "") return "";
	
	var tempStr = new String(szData);
	
	tempStr = ReplaceText(tempStr, "\\\\", "\\\\");	
	tempStr = ReplaceText(tempStr, "\\\"", "\\\"");
	tempStr = ReplaceText(tempStr, "\\n", "\\n");
	tempStr = ReplaceText(tempStr, "\\r", "\\r");
	
	return tempStr;
}

function ConvertStringForHTML(szData)
{
	if(typeof(szData) == "undefined" || szData == null || szData == "") return "";
	
	var tempStr = new String(szData);
	
	tempStr = ReplaceText(tempStr, "&", "&amp;");	
	tempStr = ReplaceText(tempStr, "<", "&lt;");
	tempStr = ReplaceText(tempStr, ">", "&gt;");
	tempStr = ReplaceText(tempStr, " ", "&nbsp;");
	
	return tempStr;	
}

function ConvertHTMLForString(szData)
{
	if(typeof(szData) == "undefined" || szData == null || szData == "") return "";
	
	var tempStr = new String(szData);
	
	tempStr = ReplaceText(tempStr, "&amp;", "&");	
	tempStr = ReplaceText(tempStr, "&lt;", "<");
	tempStr = ReplaceText(tempStr, "&gt;", ">");
	tempStr = ReplaceText(tempStr, "&nbsp;", " ");
	tempStr = ReplaceText(tempStr, "&quot;", "\"");

	return tempStr;	
}

//     c%20%ec%86%8c%ea%b0%9c%253A%20%ec%95%84%ec%8b%b8  %7e   %7e   %7e   %20%ec%84%b1%ea%b3%b5%7e%7e.html
// OWA C%20%EC%86%8C%EA%B0%9C%253A%20%EC%95%84%EC%8B%B8  %257E %257E %257E %20%EC%84%B1%EA%B3%B5%257E%257E.html

// 제목
 
function ProperTitle( orgStr )
{
	var first = orgStr.indexOf( " " );
	var retVal = orgStr;
	if ( orgStr.length > 30 && ( first == -1 || first > 30 ) ) {
		retVal = orgStr.substr( 0, 30 ) + "...";
	}
	
	return retVal;
}

function MakeXMLString(pOrgStr)
{
	pOrgStr = ReplaceText(pOrgStr, "&", "&amp;");
	pOrgStr = ReplaceText(pOrgStr, "<", "&lt;");
	pOrgStr = ReplaceText(pOrgStr, ">", "&gt;");
	return pOrgStr;
}

function ReplaceValidString(pOrgStr)
{
	pOrgStr = MakeXMLString(pOrgStr);
	pOrgStr = ReplaceText(pOrgStr, "\"", "");
	pOrgStr = ReplaceText(pOrgStr, "\'", "");
	return pOrgStr;
}


