var g_progresswin;
var g_fileList;
var pAttachListXml="";


var AttachProgressFlag = false;
var fileArray = new Array();
function Append_AttachAdd(ocx_file) {
    fileArray[fileArray.length] = ocx_file;
    if (!AttachProgressFlag) {
        btn_AttachAdd_onclick(ocx_file)
    }
}

// 2009.03.12 : Drag&Drop 기능 추가
function btn_AttachAdd_onclick(ocx_file)
{

    if (AttachProgressFlag)
        return;

    AttachProgressFlag = true;

	var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	ezUtil.UseUTF8 = true;

	// 2009.03.12 : Drag&Drop 기능 추가
	if(!ocx_file)
    {
        //var file = ezUtil.OpenLoadDlgMultiNew("", "");
        var file = ezUtil.OpenLoadDlgMultiNew("All Files (*.*)\0*.*\0Microsoft Office Files\0*.doc;*.xls;*.ppt;*.pst;*.mdb;\0Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0Text Files\0*.txt;*.csv;\0Archive Files\0*.zip;*.rar;*.cab;*.alz;*.tar\0Executable Files\0*.exe;*.com;*.bat;\0\0", "")
	    if (!file)
		    return;

	    g_fileList = file.split("|");
	}
	else
	{
	    g_fileList = ocx_file.split("|");
	}
	
	var fileSize = 0;

	for (var i = 0; i < g_fileList.length - 1; i++) {
	    if (ezUtil.GetFileSize(g_fileList[i]) == 0) {
	        alert("" + strLang1 + "");
	        return;
	    }
	    fileSize += ezUtil.GetFileSize(g_fileList[i]);
	}
	
	ezUtil = null;

	//게시판별로 설정되어 있는 첨부용량 제한
	if (fileSize > parseInt(AttachLimit) * 1024 * 1024){
		alert("" + strLang27 + "" + AttachLimit + "MB" + strLang28 + "");
		return;
	}

	var fileNamelist = "";
	var fileName = "";

	show_progress(g_fileList[0].substr(g_fileList[0].lastIndexOf("\\")+1) + "" + strLang3 + "" + 1 + "/" + (g_fileList.length-1));
}
function show_progress(fileinfo){
// 2009.03.12 : Drag&Drop 기능 추가
	beginAttachAdd();
}
function beginAttachAdd()
{
    // 2009.03.23 : EzHTTPTrans 기능 추가
    document.all.EzHTTPTrans.AddUploadFile("","");

	for (var i=0; i<g_fileList.length-1; i++)
	{
		try
		{
			document.all.EzHTTPTrans.AddUploadFile(g_fileList[i], "N");
		}
		catch (e)
		{
			if (e.number == -2147352567)
				alert("" + strLang5 + "");
			else 
				alert(g_fileList[i] + " " + strLang6 + "" + "\n\n" + e.number + " - " + e.description);

			return;
		}	
	}
	
	// 2009.03.23 : EzHTTPTrans 기능 추가
	var RemotePath = document.location.protocol+"//" + document.location.hostname + "/myoffice/ezCommunity/aspx/Item_AttachFile.aspx";
	var nCount = document.all.EzHTTPTrans.StartUpload(RemotePath,"/Upload_Community",pBoardID , "","");
	var resultText = "";
	for (var i = 0; i < nCount; i++)
	{
	    var attachFileResult = document.all.EzHTTPTrans.GetReturn(i);
	    // 201007 : Drag&Drop 실행, attachFilePath 추가
	    var attachFilePath = attachFileResult.substr(0, attachFileResult.indexOf("/"));
	    var attachFilename = attachFileResult.substr(attachFileResult.indexOf("/")+1);
	    attachFilename = attachFilename.substr(0, attachFilename.lastIndexOf("/"));

	    if (attachFilename.substr(0, 2) == "OK") {
	        var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	        ezUtil.UseUTF8 = true;
	        fileSize = ezUtil.GetFileSize(g_fileList[i]);
	        ezUtil = null;

	        var Result = attachFilename.substr(3, attachFilename.length - 3)

	        var gfileName = "";
	        gfileName = replace(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\") + 1), "+", "%2b");
	        gfileName = replace(gfileName, ";", "%3b");
	        AttachFileInfo(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\") + 1), Result.substr(Result.lastIndexOf("/") + 1), fileSize + "Bytes", Result, fileSize, attachFilePath);
	    }
	    else if (attachFilename == "denied") {
	        resultText = resultText + attachFilename + "|";
	    }
	    else
	    {
	        alert(g_fileList[i] + " " + strLang11 + "");
	        AttachProgressFlag = false;
	        return;
	    }
	}

	AttachProgressFlag = false;
	if (fileArray.length != 0) {
	    fileArray.splice(0, 1);
	    if (fileArray[0] != undefined) {
	        btn_AttachAdd_onclick(fileArray[0]);
	    }
	}


    if (resultText.indexOf('denied') > -1)
        alert(strLang75);
}

function status_change(fileinfo)
{
	try
	{
		g_progresswin.document.Script.fileinfo_change(fileinfo);
	} catch(e) {}
}

function btn_ImgDel_onclick() {
	try{
  
		var j = 0 ;
		var multi_cnt = document.singlecheck.elements.length;

		for (var i=0; i < multi_cnt; i++){
			var ele = document.singlecheck.elements[i];
			if ( ele.name == "fileImgSelect" && ele.checked )
				j ++ ;
		}
	
		if (j){
			var pInformationContent = "" + strLang29 + "";
			var Ans = confirm(pInformationContent);
		
			if(Ans){
				var pAttachDelSN;
				var pAttachDelFileName;
				var is_newfile;
				var pNewNodeName = "";	// " + strLang30 + "
				var Rtnval;
			
				for (var k=0; k < multi_cnt; k++){
					var mod_ele = document.singlecheck.elements[k];
					
					if ( mod_ele.name == "fileImgSelect" && mod_ele.checked ){
						pAttachDelFileName = mod_ele.value;
						is_newfile = mod_ele.newfile;
						pNewNodeName = pNewNodeName + pAttachDelFileName + "*)[_-";
					
						Rtnval = "TRUE";
					}
				}
			
				if (Rtnval == "TRUE"){
					// iframe 및 각종변수 설정 변경

					DelAttachFileAtList( pNewNodeName );
				
					var Rtnxml = new ActiveXObject("Microsoft.XMLDOM");
					Rtnxml.loadXML(pAttachImgListXml);
					var objImgAttachNodes = Rtnxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
				
					var pTotalRowsLen = objImgAttachNodes.length;

					if (pTotalRowsLen == 0){
						ImgAppendFileAttachInfo("");
					}
					else{
						var pstrXML = APRAttachXMLParsing();
						ImgAppendFileAttachInfo(pstrXML);					
					}
				}
				else{
					var pAlertContent = "" + strLang31 + "";
					
				}
			}
		}
	}catch(ErrMsg){alert(ErrMsg.description);}
}




function btn_AttachDel_onclick() {
    try {
        var j = 0;
        var filelist = multicheck.EzHTTPTrans.FileListAll();
        var Arrfilelist = filelist.split("\\")

        for (var i = 0; i < Arrfilelist.length - 1; i++) {
            if (multicheck.EzHTTPTrans.GetFileChecked(i) == "Y")
                j++;
        }

        if (j) {
            var pInformationContent = "" + strLang32 + "";
            var Ans = confirm(pInformationContent);

            if (Ans) {
                var pAttachDelSN;
                var pAttachDelFileName;
                var is_newfile;
                var pNewNodeName = "";
                var Rtnval;

                for (var k = 0; k < Arrfilelist.length - 1; k++) {
                    if (multicheck.EzHTTPTrans.GetFileChecked(k) == "Y") {
                        var pFilePath = multicheck.EzHTTPTrans.GetfilePath(k);
                        pAttachDelFileName = pFilePath;
                        is_newfile = multicheck.EzHTTPTrans.GetFileInfo2(k);
                        pNewNodeName = pNewNodeName + pAttachDelFileName + "*)[_-";
                        Rtnval = "TRUE";
                    }
                }
                multicheck.EzHTTPTrans.DeleteFileList();
                var filelist = multicheck.EzHTTPTrans.DelfileList();

                if (Rtnval == "TRUE") {
                    // iframe 및 각종변수 설정 변경
                    DelAttachFileAtList(pNewNodeName);

                    var Rtnxml = new ActiveXObject("Microsoft.XMLDOM");
                    Rtnxml.loadXML(pAttachListXml);
                    var objAttachNodes = Rtnxml.selectNodes("LISTVIEWDATA/ROWS/ROW");

                    var pTotalRowsLen = objAttachNodes.length;

                    if (pTotalRowsLen == 0)
                        AppendFileAttachInfo("");
                    else {
                        var pstrXML = APRAttachXMLParsing();
                    }
                }
                else {
                    var pAlertContent = "" + strLang31 + "";
                    alert(pAlertContent);
                }
            }
        }
    }
    catch (ErrMsg) { alert(ErrMsg.description); }
}

function btn_AttachSaveSure_onclick(){
	try{
		window.close();
	}catch(ErrMsg){alert(ErrMsg.description);}
}




//============================================================================================
//	첨부업로드 성공후 호출되는 함수: 첨부문서 ADD XML Parsing Function
//============================================================================================
// 201007 : Drag&Drop 실행, pAttatchFilePath 추가
function AttachFileInfo(pfilename, pSaveFileName, pfilesize, pfilelocation, pAttachFileSize, pAttatchFilePath)
{
	try{
		if(pfilename == "Error"){
			var pAlertContent = "" + strLang33 + "";
			alert(pAlertContent);
			
			return;
		}
		else if (pfilename == "FileOverFlowMsg"){
			
			pfilename = "";
		}
		else{
		    // 201007 : Drag&Drop 실행, pAttatchFilePath 추가
			AddAttachFileInfoXmlParsing(pfilename, pSaveFileName, pfilesize, pfilelocation, pAttachFileSize, pAttatchFilePath)
		}

	}catch(ErrMsg){alert(ErrMsg.description);}
}




// ==============================================
// ListView에서 첨부파일 선택시 호출  Function
// ==============================================
function ATTACHonSelChange_onclick(){
	try{
	}catch(ErrMsg){alert(ErrMsg.description);}
}




function chkFileNMFilter(cur_ExtName){
	var SpeCha = new Array( "." , "" + strLang34 + "", "," , "&");
    var StrSpeCha="";
    var plength = SpeCha.length;
    var i;
    var chkflag = true; 

    for(i=0;i<plength;i++){
		StrSpeCha = StrSpeCha  +  SpeCha[i] + " ";
    }
    StrSpeCha = StrSpeCha + "\\ / : *  ?  \" <> ";

    var s = cur_ExtName.lastIndexOf("\\");
    var e = cur_ExtName.lastIndexOf(".");

    if(s == -1)
        cur_ExtName = ""
    else
        cur_ExtName = cur_ExtName.substring(s+1,e)
 
	for(i=0;i<plength;i++){
		alert(cur_ExtName.indexOf(SpeCha[i]));

		if(cur_ExtName.indexOf(SpeCha[i]) > 0){
			chkflag = false;  
			break;
        }
    }
 
	if(!chkflag){
        alert("" + strLang35 + "" + StrSpeCha);
	}
 
    return chkflag;
}

function getAttachList(){
	try{
		var objRoot;
		var objNode;
    
		var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
		var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
       
		objRoot = xmlpara.createNode(1,"PARAMETER","");
		xmlpara.appendChild(objRoot);
    
		objNode = xmlpara.createNode(1, "pBoardID", "");
		objNode.text = pBoardID;
		xmlpara.documentElement.appendChild(objNode)
	
		objNode = xmlpara.createNode(1, "pItemID", "");
		objNode.text = pItemNo;
		xmlpara.documentElement.appendChild(objNode);
	
		objNode = xmlpara.createNode(1, "STRPARA", "");	
		objNode.text = pCompanyID;
		xmlpara.documentElement.appendChild(objNode);
  
		xmlhttp.open ("Post","Call_ItemAttachList.aspx",false);
		xmlhttp.send(xmlpara);
    
		var Resultxml = xmlhttp.responseXML; 
		objRoot = Resultxml.documentElement;
    
		var ret = Resultxml.xml
	
  		if(objRoot != null){
  			pAttachListXml  = ret;
			AppendFileAttachInfo(ret);
		}
	}catch(ErrMsg){alert(ErrMsg.description);}
}

function AppendFileAttachInfo(ret) {
    try {
        pAttachListXml = ret;

        if (PhotoBoard == "Y") return;

        var xmlAttach = new ActiveXObject("Microsoft.XMLDOM");
        xmlAttach.loadXML(ret);

        var objAttachNodes = xmlAttach.selectNodes("LISTVIEWDATA/ROWS/ROW");

        var strAttach = "";

        for (i = 0 ; i < objAttachNodes.length ; i++) {
            var realFilePath = objAttachNodes(i).childNodes.item(0).childNodes.item(1).text;
            var realFileNM = objAttachNodes(i).childNodes.item(0).childNodes.item(2).text;
            var is_newfile = objAttachNodes(i).childNodes.item(0).childNodes.item(5).text;
            realFileNM = ReplaceText(realFileNM, "'", "&apos;")

            if (is_newfile != "DEL") {
                var strName = replace(objAttachNodes(i).childNodes.item(0).childNodes.item(0).text, "%3b", ";");
                strName = replace(strName, "%2b", "+");
                document.all.EzHTTPTrans.InsertFileList(strName, document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/downloadattach.aspx?filename=" + escape(strName) + "&filepath=" + escape(realFilePath) + "&regData=" + clientInformation.systemLanguage, "N", "N", objAttachNodes(i).childNodes.item(0).childNodes.item(6).text);
                document.all.EzHTTPTrans.InsertFileInfo(realFileNM);
            }
        }
        AppendFileAttachInfo_List(ret);
    }
    catch (e) { alert("AppendFileAttachInfo :: " + e.description); }
}

function AppendFileAttachInfo_List(ret)
{
	try
	{
		// 20070228  포토게시판은 해당 내용 건너 뜀
		if(PhotoBoard == "Y") return; 

		var xmlAttach = new ActiveXObject("Microsoft.XMLDOM");
		xmlAttach.loadXML(ret);

		var objAttachNodes = xmlAttach.selectNodes("LISTVIEWDATA/ROWS/ROW");

	    lstAttachLink.innerHTML = "";
	    var strAttach = "";
	    strPreViewAttach = "";
	    rep = /'/g;
		
	    var j = 690;

	    for (i = 0 ; i < objAttachNodes.length ; i++ )
	    {
		    var realFileNM = objAttachNodes(i).childNodes.item(0).childNodes.item(2).text;
		    var is_newfile = objAttachNodes(i).childNodes.item(0).childNodes.item(5).text;
		    var IncodFileNM = escape(objAttachNodes(i).childNodes.item(0).childNodes.item(1).text);
		    realFileNM = ReplaceText(realFileNM, "'", "&apos;")
			
		    if (is_newfile != "DEL"){

			    strAttach = strAttach + "<input type='checkbox' name='fileSelect' newfile='" + objAttachNodes(i).childNodes.item(0).childNodes.item(5).text + "' value='" + realFileNM + "'>";
			    strAttach = strAttach + "<img src='/images/email/mail_006.gif'> <a href='#' target='_self'>" 
			    strAttach = strAttach + objAttachNodes(i).childNodes.item(0).childNodes.item(0).text + "&nbsp;</a><br>"
		    }
	    }
	    lstAttachLink.innerHTML = strAttach;
	}
	catch(e){alert("AppendFileAttachInfo :: " + e.description);}
}

function AttachFileList()
{
	var xmldom_attachlist = new ActiveXObject("Microsoft.XMLDOM");
	var strRet = "";
	var filepath = "";
	
	if(xmldom_attachlist.loadXML(pAttachListXml) == false) {
		xmldom_attachlist = null;	
		return "";
	}
	
	var xmldomNodes = xmldom_attachlist.selectNodes("LISTVIEWDATA/ROWS/ROW/CELL/DATA2");
	
	for(i=0;i<xmldomNodes.length;i++)
	{
		filepath = xmldomNodes.item(i).text;
		if(filepath.indexOf(pBoardID) != -1) {
			strRet += filepath + ";";
			//strRet += filepath + "|";
		} else {
		    //strRet += pBoardID + "/UploadFile/" + xmldomNodes.item(i).text + ";"
		    strRet += "TempUploadFile/" + xmldomNodes.item(i).text + ";"
			//strRet += pBoardID + "/UploadFile/" + xmldomNodes.item(i).text + "|"
		}
	}
	
	xmldom_attachlist = null;
	
	return strRet;
}

function btn_PhotoAttachAdd_onclick(){
	var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	var file = "";
	if(pMode == "modify")	// " + strLang36 + "
	{
		file = ezUtil.OpenLoadDlg("" + strLang37 + "", "");
		if(file != "")
		{	
			file = file + "|";
		} 
		
	}	
	else
	{
		file = ezUtil.OpenLoadDlgMultiNew("" + strLang37 + "", "");
	}
	

	if (!file)
		return;
		
	pAttachListXml = "";
	
	g_fileList = file.split("|");
	var fileSize = 0;
		
	if(pMode != "modify")
	{
		if(g_fileList.length > 6)
		{
			alert("" + strLang38 + "")
			return;
		}
	}
	
	

	for (var i=0; i<g_fileList.length-1; i++){
		if (ezUtil.GetFileSize(g_fileList[i]) == 0){
			alert("" + strLang1 + "");
			return;
		}
		//[2006.06.20] 파일명의 길이가 111byte를 초과할 경우 오류메시지 처리.
		var temp = ezUtil.ExtractFileName(g_fileList[i]);
		
		if( temp.length > 111 )
		{
			alert("" + strLang39 + "");
			return;
		}
		
		//2006.11.28 포토게시판은 게시물 건당 첨부파일 용량을 체크한다.
		fileSize = ezUtil.GetFileSize(g_fileList[i]); 		
		
		//게시판별로 설정되어 있는 첨부용량 제한
		if (fileSize > parseInt(AttachLimit) * 1024 * 1024){
			alert("" + strLang27 + "" + AttachLimit + "MB" + strLang28 + "");
			return;
		}			
	}
	
	ezUtil = null;

	

	var fileNamelist = "";
	var fileName = "";
	
	show_progress_photo(g_fileList[0].substr(g_fileList[0].lastIndexOf("\\")+1) + "" + strLang3 + "" + 1 + "/" + (g_fileList.length-1));
}


function show_progress_photo(fileinfo)
{
// 2009.03.12 : Drag&Drop 기능 추가
//	g_progresswin = window.showModelessDialog("show_progress.aspx?fileinfo=" + escape(fileinfo), "", "dialogWidth=390px; dialogHeight:175px; center:yes; status:no; help:no; edge:sunken"); 
//	for( ;window.g_progresswin.document.readyState!="complete";) ;// 2011.02.16 IE9 지원안함.
	
	beginAttachAdd_Photo();
}


function beginAttachAdd_Photo()
{
    // 2009.03.23 : EzHTTPTrans 기능 추가
    document.all.EzHTTPTrans.AddUploadFile("","");

    for (var i=0; i<g_fileList.length-1; i++)
    {
		try
		{
		    // 2009.03.12 : Drag&Drop 기능 추가
//			if (i > 0)
//			{
//				status_change(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1) + "" + strLang3 + "" + (i+1) + "/" + (g_fileList.length-1));
//			}
			
			// 2009.03.23 : EzHTTPTrans 기능 추가
			document.all.EzHTTPTrans.AddUploadFile(g_fileList[i], "N");

            //2009.03.23 : 업로드 컴퍼넌트 교체 작업
//			var ezUtil = new ActiveXObject("EzUtil.MiscFunc");
//			pAttachGUID = ezUtil.GetGUID();
//			ezUtil = null;
//			
//			oPoster.Clear();
//			
//			//[070518]_첨부 한글가능하도록 추가
//			oPoster.UseUTF8 = true;
//			
//			oPoster.AddFormData("mode", "send");
//			oPoster.AddFile("attachfile", g_fileList[i], 0);
//			oPoster.Host = server_name;
//			
//			// 2009 : SSL적용
//			if(window.location.protocol.toLowerCase() == "http:")
//				oPoster.Protocol = 0;
//			else
//				oPoster.Protocol = 1;
//			
//			oPoster.PostURL = "/myoffice/ezCommunity/aspx/Item_AttachFile_Photo.aspx?boardid=" + pBoardID + "&uploadsn=" + pAttachGUID;
//			oPoster.Post();

//            if (oPoster.Response.substr(0, 2) != "OK"){
//				try {
//					txtPhotoFile.value = "";
//					hide_progress();	
//									
//				} catch(e) {}
//				//alert(g_fileList[i] + " 을 업로드 중 에러가 발생했습니다.\n\n서버측 오류");
//				alert(g_fileList[i] + " " + strLang40 + "");
//				txtPhotoFile.value = "";
//				return;
//			}else{
//				var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");	
//				ezUtil.UseUTF8 = true;
//				fileSize = ezUtil.GetFileSize(g_fileList[i]); 		
//				txtPhotoFile.value = ezUtil.ExtractFileName(g_fileList[i]);	//2006.10.20 " + strLang41 + "	
//				ezUtil = null;
//							

//			
//				var Result = oPoster.Response.substr(3, oPoster.Response.length-3)
//				AttachFileInfo(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1), Result.substr(Result.lastIndexOf("/")+1), fileSize + "Bytes", Result, fileSize)
//			}
		}
		catch (e) {
		    // 2009.03.12 : Drag&Drop 기능 추가
//			try {
//				hide_progress();
//			} catch(e) {}
			if (e.number == -2147352567)
				alert("" + strLang5 + "");
			else 
				alert(g_fileList[i] + " " + strLang6 + "" + "\n\n" + e.number + " - " + e.description);

			return;
		}	
	}
	
	// 2009.03.23 : EzHTTPTrans 기능 추가
	var RemotePath = document.location.protocol+"//" + document.location.hostname + "/myoffice/ezCommunity/aspx/Item_AttachFile_Photo.aspx";
	var nCount = document.all.EzHTTPTrans.StartUpload(RemotePath,"/Upload_Community",pBoardID , "","");
	
	for (var i = 0; i < nCount; i++)
	{
	    var attachFileResult = document.all.EzHTTPTrans.GetReturn(i);
	    // 201007 : Drag&Drop 실행, attachFilePath 추가
        var attachFilePath = attachFileResult.substr(0, attachFileResult.indexOf("/"));
	    var attachFilename = attachFileResult.substr(attachFileResult.indexOf("/")+1);
	    attachFilename = attachFilename.substr(0, attachFilename.lastIndexOf("/"));

	    if (attachFilename.substr(0, 2) != "OK")
	    {
		    try
		    {
		        txtPhotoFile.value = "";
		        // 2009.03.12 : Drag&Drop 기능 추가
			    //hide_progress();
		    }
		    catch(e)
		    {
		    }
		    
		    alert(g_fileList[i] + " " + strLang24 + "");
		    txtPhotoFile.value = "";
		    return;
	    }
	    else
	    {
		    var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	        ezUtil.UseUTF8 = true;
		    fileSize = ezUtil.GetFileSize(g_fileList[i]);
		    txtPhotoFile.value = ezUtil.ExtractFileName(g_fileList[i]);	//2006.10.20 " + strLang25 + "
		    ezUtil = null;

		    var Result = attachFilename.substr(3, attachFilename.length-3)
		    
		    //AttachFileInfo(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1), Result.substr(Result.lastIndexOf("/")+1), fileSize + "Bytes", Result, fileSize)
		    var gfileName="";
		    gfileName = replace(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1), "+", "%2b");
		    gfileName = replace(gfileName, ";", "%3b");
		    // 201007 : Drag&Drop 실행, attachFilePath 추가
		    AttachFileInfo(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1), Result.substr(Result.lastIndexOf("/")+1), fileSize + "Bytes", Result, fileSize, attachFilePath);
	    }
	}

    // 2009.03.12 : Drag&Drop 기능 추가
//	try {
//		g_progresswin.close();
//	} catch(e) {}

}

//string형 일때 사용
function replace(str,s,d)
{
	var i=0;
	i = str.indexOf(s);

	while(i > -1)
	{
		str = str.substr(0,i) + d + str.substr(i+s.length,str.length);
		i = str.indexOf(s);
	}
	return str;
}

function AttachFileList_Photo()
{
	var xmldom_attachlist = new ActiveXObject("Microsoft.XMLDOM");
	var strRet = "";
	var filepath = "";
	
	if(xmldom_attachlist.loadXML(pAttachListXml) == false) {
		xmldom_attachlist = null;	
		return "";
	}
	
	var xmldomNodes = xmldom_attachlist.selectNodes("LISTVIEWDATA/ROWS/ROW/CELL/DATA2");
	
	for(i=0;i<xmldomNodes.length;i++)
	{
		filepath = xmldomNodes.item(i).text;
		if(filepath.indexOf(pBoardID) != -1) {
			strRet += filepath + ";";
		} else {
		    strRet += "TempUploadFile/" + xmldomNodes.item(i).text + ";"
			//strRet += pBoardID + "/UploadFile/" + xmldomNodes.item(i).text + ";";
		}
	}
	
	xmldom_attachlist = null;
	
	
	return strRet;
}

