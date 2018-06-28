
var g_AmPm = new Array(strLang14, strLang15);
var g_Day = new Array( strLang16, strLang17, strLang18, strLang19, strLang20, strLang21, strLang22 );

function GetPrevDate( curDate )
{
	var prevDate = new Date();
	
	prevDate.setYear( curDate.getYear() );
	prevDate.setDate(1);
	prevDate.setMonth( curDate.getMonth() );
	prevDate.setDate( curDate.getDate() - 1 );
	
	return prevDate;
}

function GetNextDate( curDate )
{
	var nextDate = new Date();
	
	nextDate.setYear( curDate.getYear() );
	nextDate.setDate(1);
	nextDate.setMonth( curDate.getMonth() );
	nextDate.setDate( curDate.getDate() + 1 );
	
	return nextDate;
}

function GetNextWeekDate( curDate )
{
	var nextWDate = new Date();
	
	nextWDate.setYear( curDate.getYear() );
	nextWDate.setDate(1);
	nextWDate.setMonth( curDate.getMonth() );
	nextWDate.setDate( curDate.getDate() + 6 );
	
	return nextWDate;
}

function CvDate( szDtTime )
{		
	var szDate = szDtTime;
	var szSubStr = szDtTime.substring( 5, 7 );

	if ( szSubStr.charAt(0) == "0" ) szSubStr = szSubStr.charAt(1);
	
	var objDate = new Date();
	objDate.setUTCFullYear( szDate.substring( 0, 4 ) );
	objDate.setUTCMonth( Number( szSubStr ) - 1 );
	objDate.setUTCDate( szDate.substring( 8, 10 ) );
	objDate.setUTCHours( szDate.substring( 11, 13 ) );
	objDate.setUTCMinutes( szDate.substring( 14, 16 ) );
	objDate.setUTCSeconds( szDate.substring( 17, 19 ) );
	objDate.setUTCMilliseconds( 0 );
	
	var cvtDate = objDate.toLocaleString(); 
		
	if ( cvtDate.indexOf( strLang23 ) != -1 && cvtDate.indexOf( strLang17 ) != -1 )
	{
		cvtDate = cvtDate.replace(strLang24, "-");
		cvtDate = cvtDate.replace(strLang25, "-");
		cvtDate = cvtDate.replace(strLang26, " (");
		cvtDate = cvtDate.replace(strLang27, ")");
		
		return cvtDate;
	}
	else
	{	
		var szAmPm = strLang14;
		var timePart = objDate.getHours();
		
		if ( parseInt( timePart ) > 11 )
		{
			szAmPm = strLang15;
			timePart = ( parseInt( timePart ) - 12 );
		}
		
		return mfFormatDate(objDate,"yyyy-MM-dd") + " (" + g_Day[ objDate.getDay() ] + ") " + szAmPm + " " + timePart + ":" 
		 + szDate.substring( 14, 16 )
		 + ":" + szDate.substring( 17, 19 );
	}
}

function UTCtoString( szDate )
{
	var dateobj, datetext;
	dateobj = new Date( szDate );

	datetext = dateobj.getFullYear() + "-" + Number( dateobj.getMonth() + 1 ) + "-" + dateobj.getDate();
	datetext += " " + "(" + g_Day[  dateobj.getDay() ] + ")";

	datetext += " " + makeString( 2, "0", dateobj.getHours() ) + ":" + makeString( 2, "0", dateobj.getMinutes() );
	
	return datetext;
}


function mfFormatDate(objD,szFormat)
{	
	if ( -1 < szFormat.search(/M/g) )
	{
		iX = objD.getMonth()+1;
		szFormat = szFormat.replace(/MM/g, iX<10 ? "0"+iX : iX );
		szFormat = szFormat.replace(/M/g, iX);
	}
	if ( -1 < szFormat.search(/d/g) )
	{
		iX = objD.getDay();
		iX = objD.getDate();
		szFormat = szFormat.replace(/dd/g, iX>9?iX:"0"+iX);
		szFormat = szFormat.replace(/d/g, iX);
	}
	if ( -1 < szFormat.search(/y/g) )
	{
		var iY = objD.getFullYear();
		var iY2 = iY%100;

		szFormat = szFormat.replace(/yyy+/g, iY);
		szFormat = szFormat.replace(/y+/g, iY2>9?iY2:"0"+iY2);
	}
	if ( -1 < szFormat.search(/h/g) ) 
	{
		iX=objD.getHours();
		if (iX>12) iX -= 12;
		if (iX==0) iX=12;
		szFormat =	szFormat.replace(/hh/g, iX>9?iX:"0"+iX);
		szFormat =	szFormat.replace(/h/g, iX);
	}
	if ( -1 < szFormat.search(/H/g) ) 
	{
		iX=objD.getHours();
		szFormat =	szFormat.replace(/HH/g, iX>9?iX:"0"+iX);
		szFormat =	szFormat.replace(/H/g, iX);
	}
	if ( -1 < szFormat.search(/m/g) )
	{
		iX=objD.getMinutes();
		szFormat =	szFormat.replace(/mm/g, iX>9?iX:"0"+iX);
		szFormat =	szFormat.replace(/m/g, iX);
	}
	if ( -1 < szFormat.search(/s/g) )
	{
		iX=objD.getSeconds();
		szFormat =	szFormat.replace(/ss/g, iX>9?iX:"0"+iX);
		szFormat =	szFormat.replace(/s/g, iX);
	}
	if (-1 < szFormat.search(/t/g))
	{
		iX=objD.getHours();
		szFormat =	szFormat.replace(/tt/g, (iX>11)?m_szPMtext:m_szAMtext);
		szFormat =	szFormat.replace(/t/g, (iX>11)?m_szPMtext:m_szAMtext);
	}

	return(szFormat);
}


