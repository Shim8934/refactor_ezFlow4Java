

function ReplaceText(orgStr, findStr, replaceStr)
{
	var re = new RegExp( findStr, "gi" );
	
	return ( orgStr.replace( re, replaceStr ) );
}

function ExtractBetweenPattern( orgStr, firstPattern, lastPattern )
{
	var sIndex, eIndex;
	var copyStr = new String( orgStr );
	var retStr = "", subStr;
	
	var regFExp = new RegExp( firstPattern, "i" );
	var regEExp = new RegExp( lastPattern, "i" );
	
	var loop = 0;

	sIndex = copyStr.search( regFExp );
	if ( sIndex == -1 ) {
		return orgStr;
	}
	
	copyStr = copyStr.substr( sIndex + firstPattern.length );

	eIndex = copyStr.search( regEExp );
	if ( eIndex == -1 ) {
		return copyStr;
	}
	
	retStr = copyStr.substr( 0, eIndex );
	
	return retStr;
}

function RemoveBetweenPattern( orgStr, firstPattern, lastPattern )  
{
	var sIndex, eIndex;
	var copyStr = new String( orgStr );
	var retStr = "", subStr;
	
	var regFExp = new RegExp( firstPattern, "i" );
	var regEExp = new RegExp( lastPattern, "i" );
	
	var loop = 0;

	do {
		sIndex = copyStr.search( regFExp );
		if ( sIndex == -1 ) {
			retStr += copyStr;
			break;
		}
		
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

function TrimText( orgStr )
{
	var copyStr = "";
	var strIndex;

	for ( strIndex = 0; strIndex < orgStr.length; strIndex ++ ) {
		if ( orgStr.charAt(strIndex) == ' ' ) continue;
		else {
			copyStr = orgStr.substr( strIndex );
			break;
		}
	}
	
	for ( strIndex = copyStr.length - 1; strIndex >= 0; strIndex -- ) {
		if ( copyStr.charAt(strIndex) == ' ' ) continue;
		else {
			copyStr = copyStr.substr( 0, strIndex + 1 );
			break;
		}
	}
	
	return copyStr;
}

function convertRadix16( orgNum )
{
	var copyNum;
	
	if ( orgNum < 0 ) {
		orgNum = -orgNum;
		copyNum = 65536 - orgNum;
		return copyNum.toString(16);
	} 
	
	return orgNum.toString(16);
}

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

function makeString( strLen, empCh, custStr )
{
	var index;
	var szEmpty = "";
	
	for ( index = custStr.length; index < strLen; index ++ ) {
		szEmpty	+= empCh;
	}
	
	return( szEmpty + custStr );
}

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
function CutBeforeText( orgText, findText )
{
	var tempStr = new String( orgText );
	var findStr = new String( findText );
	
	tempStr = tempStr.toUpperCase();
	findStr = findStr.toUpperCase();
	var indexPos = tempStr.indexOf( findStr );
	return ( orgText.substr( indexPos + findText.length ) );	
}

function CutAfterText( orgText, findText )
{
	var indexPos = orgText.lastIndexOf( findText );
	return ( orgText.substr( 0, indexPos ) );	
}

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

function ToValidFileNameForPhysical(orgName)
{
	var tempName = new String( orgName );

	tempName = ReplaceText( tempName, "_x007E_", "~" );
	tempName = ReplaceText( tempName, "\\*", "%2A");

	return tempName;
}

function EncodeForFileName(orgName)
{
	var tempName = new String(orgName);

	tempName = ReplaceText( tempName, " ", "%20");
	
	return tempName;
}

function ConvertCharToEntityReference(szData)
{
	if(typeof(szData) == "undefined" || szData == null || szData == "") return "";
	
	var tempStr = new String(szData);
	
	tempStr = ReplaceText(tempStr, "&", "&amp;");	
	tempStr = ReplaceText(tempStr, "<", "&lt;");
	tempStr = ReplaceText(tempStr, ">", "&gt;");
	
	return tempStr;
}

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

function ProperTitle( orgStr )
{
	var first = orgStr.indexOf( " " );
	var retVal = orgStr;
	if ( orgStr.length > 30 && ( first == -1 || first > 30 ) ) {
		retVal = orgStr.substr( 0, 30 ) + "...";
	}
	
	return retVal;
}

