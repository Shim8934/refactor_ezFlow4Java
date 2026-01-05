var strLang1 = "The attendance time is already registered.";
var strLang2 = "Informasi tambahan terkait ketidakhadiran dan keterlambatan sudah terdaftar.";
var strLang3 = "Pendaftaran gagal.";
var strLang4 = "ditetapkan sebagai hari libur sehingga informasi perjalanan tidak dapat direkam.";
var strLang5 = "Daftar waktu kehadiran terlebih dahulu.";
var strLang6 = "Waktu Habis sudah terdaftar.";
var strLang7 = "Tidak ada wewenang.";

var strLang8 = "tidak dapat memasukkan waktu kehadiran.";
var strLang9 = "Ketidakhadiran";
var strLang10 = "setengah hari kecuali hari libur";
var strLang11 = "Ada input kehadiran untuk hal-hal lain. \nApakah Anda yakin ingin memasukkan waktu absensi?";
var strLang12 = "Pendaftaran telah dibatalkan.";


function GetLocalTime(Offset , pDateTime)
{

	var VBDate = pDateTime.substring(0,4)+"-"+pDateTime.substring(5,7)+"-"+pDateTime.substring(8,10)+" "+ pDateTime.substring(11,13)+":"+pDateTime.substring(14,16)+":"+pDateTime.substring(17,19)
	var pOffset = Offset.split("|")[1];
	var pOffsetHour = pOffset.split(":")[0];
	var pOffsetMinute = pOffset.split(":")[1];

	pDateTime = GetTimeCalcu(VBDate , Number(pOffsetHour) , Number(pOffsetMinute))
	return pDateTime;
	var szYear = pDateTime.substring(0,4);
	var szMonth = pDateTime.substring(5,7);
	var szDay = pDateTime.substring(8,10);
	var szHr = Number(pDateTime.substring(11,13)) //+ Number(pOffsetMinute);
	var szMin = Number(pDateTime.substring(14,16))// + Number(pOffsetMinute);
	var szSec = pDateTime.substring(17,19)
	var ibjD = new Date();

	ibjD.setFullYear(szYear ,szMonth , szDay );
	ibjD.setHours(szHr ,szMin , szSec );
	
	var rYear = ibjD.getFullYear();
	var rMonth = addzero(ibjD.getMonth());
	var rDate = addzero(ibjD.getDate());
	var rHour = addzero(ibjD.getHours());
	var rMin = addzero(ibjD.getMinutes());
	var rSec = addzero(ibjD.getSeconds());	

	//javascript 31 보정
	if (szDay =="31" && (Number(pDateTime.substring(11,13)) + Number(pOffsetHour) < 24))
	{
		rMonth = addzero(Number(rMonth) -1) ;
		rDate = 31 ;		
	}
	
	return rYear + "-" + rMonth + "-" + rDate + "T" + rHour+ ":" +rMin + ":" + rSec;
}

function ReversGetLocalTime(Offset , pDateTime)
{
//	var pOffset = Offset.split("|")[1];
//	var pOffsetHour = pOffset.split(":")[0];
//	var pOffsetMinute = pOffset.split(":")[1];
//	
//	var szYear = pDateTime.substring(0,4);
//	var szMonth = pDateTime.substring(5,7);
//	var szDay = pDateTime.substring(8,10);
//	var szHr = Number(pDateTime.substring(11,13)) - Number(pOffsetHour);
//	var szMin = Number(pDateTime.substring(14,16)) - Number(pOffsetMinute);
//	var szSec = pDateTime.substring(17,19)
//	var ibjD = new Date();	
//	
//	ibjD.setFullYear(szYear ,szMonth , szDay);
//	
//	
//	ibjD.setHours(szHr ,szMin , szSec );	
//	var rYear = ibjD.getFullYear();
//	var rMonth = addzero(ibjD.getMonth());
//	var rDate = addzero(ibjD.getDate());
//	var rHour = addzero(ibjD.getHours());
//	var rMin = addzero(ibjD.getMinutes());
//	var rSec = addzero(ibjD.getSeconds());	
	
	//javascript 31 보정
//	if (szDay =="31" && rDate =="01")
//	{
//		rMonth = addzero(Number(rMonth) -1) ;
//		rDate = 31 ;		
//	}
	
	var pOffset = Offset.split("|")[1];     // 병진 수정 20071127 (위에주석처리)
	var pOffsetHour = pOffset.split(":")[0];

	var pOffsetMinute = pOffset.split(":")[1];
	
	var szYear = pDateTime.substring(0,4);
	var szMonth = pDateTime.substring(5,7);
	var szDay = pDateTime.substring(8,10);

	var szHr = Number(pDateTime.substring(11,13)) //- Number(pOffsetHour);  병진수정 mail_write.aspx 에 _UserTimeset 잘못된 값을 가져와 수정 20071127

	var szMin = Number(pDateTime.substring(14,16)) - Number(pOffsetMinute);
	var szSec = pDateTime.substring(17,19)
	var ibjD = new Date();	
	
	//ibjD.setFullYear(szYear ,szMonth - 1 , szDay);
	// 수정(2007.12.06) : 월 셋팅 부분 수정 바텍오류수정한거적용 유병진
	ibjD.setFullYear(szYear, Number(szMonth)-1, szDay);
	
	ibjD.setHours(szHr ,szMin , szSec );	
	var rYear = ibjD.getFullYear();
	//var rMonth = addzero(ibjD.getMonth() + 1);
	// 수정(2007.12.06) : 월 셋팅 부분 수정 바텍오류수정한거적용 유병진
	var rMonth = addzero(ibjD.getMonth()+1);
	var rDate = addzero(ibjD.getDate());
	var rHour = addzero(ibjD.getHours());
	var rMin = addzero(ibjD.getMinutes());
	var rSec = addzero(ibjD.getSeconds());	
	
	//javascript 31 보정
	if (szDay =="31" && rDate =="01")
	{
		rMonth = addzero(Number(rMonth) -1) ;
		rDate = 31 ;		
	}
	
	return rYear + "-" + rMonth + "-" + rDate + " " + rHour+ ":" +rMin + ":" + rSec;
}
function addzero(arg)
{
	if (arg < 10)
	{
		arg = "0" + arg;
	}
	return arg

}
function folderdisnameChange(pFolderPath)
{
	var FolderNameKo = new Array( "받은 편지함" ,  "보낸 편지함" ,  "임시 보관함" ,  "지운 편지함" ,  "개인편지함" );
	var FolderNameEn = new Array("Inbox", "Sent Items", "Drafts", "Deleted Items", "PERSONAL");
	var DispName = new Array(strLang68, strLang69, strLang70, strLang4, strLang71);
	
	var ArrayPath = pFolderPath.split("/")
	for (var j=0; j<5; j++)
	{
		if (ArrayPath[0] == FolderNameEn[j]) pFolderPath = pFolderPath.replace(ArrayPath[0] , DispName[j])
		if (ArrayPath[0] == FolderNameKo[j]) pFolderPath = pFolderPath.replace(ArrayPath[0] , DispName[j])
	}
	return pFolderPath
}
