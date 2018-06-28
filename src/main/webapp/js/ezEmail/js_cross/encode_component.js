
function toUTF8( szInput )
{
	var wch, x, uch = "", szRet = "";

	for ( x = 0; x < szInput.length; x ++ ) {
	
		wch = szInput.charCodeAt( x );
		
		if ( !( wch & 0xFF80 ) ) {
			szRet += "%" + wch.toString(16);
		} else if ( !( wch & 0xF000 ) )	{
			uch = "%" + ( wch >> 6 | 0xC0 ).toString(16) + 
				  "%" + ( wch & 0x3F | 0x80 ).toString(16);
			szRet += uch;
		} else {
			uch = "%" + ( wch >> 12 | 0xE0 ).toString(16) + 
				  "%" + ( ( ( wch >> 6 ) & 0x3F ) | 0x80 ).toString(16) +
				  "%" + ( wch & 0x3F | 0x80 ).toString(16);

			szRet += uch; 
		}
	}
	
	return ( szRet );
}

function encodeUTF8Encode( szInput )
{
	return ( toUTF8( szInput ) );
}

function decodeUTF8Encode( szInput )
{
	var i;
	var ch, uch, code, uVal;
	var szRet = "";
	
	var wch1 = 0, wch2 = 0, wch3 = 0;
	var wstep = 0;
	var uch1, uch2, uch3;
	
	for ( i = 0; i < szInput.length; i ++ ) {
		ch = szInput.charAt( i );
		uch = "";
		
		if ( ch == '%' ) {
			uch += szInput.charAt( ++i );
			uch += szInput.charAt( ++i );
		} else {
			szRet += ch;
			continue;
		}
		
		uVal = convertRadix10( uch );
		if ( uVal <= 125 ) {
			szRet += String.fromCharCode( uVal );
		} else {

			switch ( wstep ) {
			case 0:
				wch1 = uVal;
				wstep = 1;
				break;
			
			case 1:
				wch2 = uVal;
				wstep = 2;
				break;
				
			case 2:
				wch3 = uVal;
				wstep = 0;
				
				uch1 = wch3 & 0x7F;
				uch2 = ( wch2 & 0x7F ) << 6;
				uch3 = ( wch1 & 0x1F ) << 12;
				
				szRet += String.fromCharCode( uch1 + uch2 + uch3 );
			
			default:
				wstep = 0;				
			}
		}
	}
	
	return szRet;
}

function toUTF8DontChangeOneByte(szInput)
{
	var wch,x,uch="",szRet="";

	for (x=0; x<szInput.length; x++)
	{
		wch=szInput.charCodeAt(x);
		
		if (!(wch & 0xFF80))
		{
			szRet += szInput.substr(x, 1)
		}
		else if (!(wch & 0xF000))
		{
			uch = "%" + (wch>>6 | 0xC0).toString(16) + 
				  "%" + (wch & 0x3F | 0x80).toString(16);
			szRet += uch; 
		}
		else
		{
			uch = "%" + (wch >> 12 | 0xE0).toString(16) + 
				  "%" + (((wch >> 6) & 0x3F) | 0x80).toString(16) +
				  "%" + (wch & 0x3F | 0x80).toString(16);
			szRet += uch; 
		}
	}
	return(szRet);
}

function encodeUrl(url)
{
	var encodedURL;
	
	if(typeof(url) == "undefined") 
	{
		alert(strLang72);
		return;
	}
	
	var re = /%/g;
	url = url.replace( re, "%per" );
	
	re = /\*/g;
	url =url.replace( re, "%star" );
	
	re = /%/g;		
	encodedURL = url.replace(re, "*");
	
	return encodedURL;
}

function decodeUrl( url )
{
	var decodedURL;
	
	if ( typeof( url ) == "undefined" ) {
		alert( strLang73 );
		return;
	}
	
	var re = /\*/g;
	decodedURL = url.replace( re, "%" );
	
	re = /%star/g;
	decodedURL = decodedURL.replace( re, "*" );
	
	re = /%per/g;
	decodedURL = decodedURL.replace( re, "%" );
	
	return decodedURL;
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

