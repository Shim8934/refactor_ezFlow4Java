var g_progresswin;
var g_fileList;
var pAttachListXml="";
var pMode="";
var AttachLimit="";
var pBoardID="";
var PhotoBoard="";

var AttachProgressFlag = false;
var fileArray = new Array();
function Append_AttachAdd(ocx_file) {
    fileArray[fileArray.length] = ocx_file;
    if (!AttachProgressFlag) {
        btn_AttachAdd_onclick(ocx_file)
    }
}

function btn_AttachAdd_onclick(ocx_file)
{
    if (AttachProgressFlag)
        return;

    AttachProgressFlag = true;

	var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	ezUtil.UseUTF8 = true;

	if(!ocx_file)
    {
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

	if (fileSize > parseInt(AttachLimit) * 1024 * 1024){
		alert("" + strLang27 + "" + AttachLimit + "MB" + strLang28 + "");
		AttachProgressFlag = false;
		return;
	}

	var fileNamelist = "";
	var fileName = "";

	show_progress(g_fileList[0].substr(g_fileList[0].lastIndexOf("\\")+1) + "" + strLang3 + "" + 1 + "/" + (g_fileList.length-1));
}
function show_progress(fileinfo){
	beginAttachAdd();
}
function beginAttachAdd()
{
    document.all.EzHTTPTrans.AddUploadFile("","");

	for (var i=0; i<g_fileList.length-1; i++)
	{
		try
		{
			document.all.EzHTTPTrans.AddFilename(encodeURIComponent(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1)));
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
	
	var RemotePath = document.location.protocol+"//" + document.location.hostname + ":" + location.port + "/ezCommunity/itemAttachFile.do";
	var nCount = document.all.EzHTTPTrans.StartUpload(RemotePath,"/upload_Community",pBoardID , "","");
	var resultText = "";
	for (var i = 0; i < nCount; i++)
	{
	    var attachFileResult = document.all.EzHTTPTrans.GetReturn(i);
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
	    } else if (attachFilename == "denied") {
	        resultText = resultText + attachFilename + "|";
	    } else {
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
				var pNewNodeName = "";
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
					DelAttachFileAtList( pNewNodeName );
				
					var Rtnxml = createXmlDom();
					Rtnxml = loadXMLString(pAttachImgListXml);
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
                    DelAttachFileAtList(pNewNodeName);

                    var Rtnxml = createXmlDom();
                    Rtnxml = loadXMLString(pAttachListXml);
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
			AddAttachFileInfoXmlParsing(pfilename, pSaveFileName, pfilesize, pfilelocation, pAttachFileSize, pAttatchFilePath)
		}

	}catch(ErrMsg){alert(ErrMsg.description);}
}

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
    
		var xmlpara = createXmlDom();
		var xmlhttp = createXMLHttpRequest();
       
		var objRoot, objNode
		objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
		objNode = createNodeAndInsertText(xmlpara, objNode, "pBoardID", pBoardID);
		objNode = createNodeAndInsertText(xmlpara, objNode, "pItemID", pItemNo);
		objNode = createNodeAndInsertText(xmlpara, objNode, "STRPARA", pCompanyID);
		
		xmlhttp.open ("Post","Call_ItemAttachList.aspx",false);
		xmlhttp.send(xmlpara);
    
		var Resultxml = loadXMLString(xmlhttp.responseText);
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

        var xmlAttach = createXmlDom();
        xmlAttach = loadXMLString(ret);

        var objAttachNodes = xmlAttach.selectNodes("LISTVIEWDATA/ROWS/ROW");

        var strAttach = "";

        for (i = 0 ; i < objAttachNodes.length ; i++) {
            var realFilePath = getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(1));
            var realFileNM = getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(2));
            var is_newfile = getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(5));
            realFileNM = ReplaceText(realFileNM, "'", "&apos;")

            if (is_newfile != "DEL") {
                var strName = replace(getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(0)), "%3b", ";");
                strName = replace(strName, "%2b", "+");
                document.all.EzHTTPTrans.InsertFileList(strName, document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?fileName=" + encodeURIComponent(strName) + "&filePath=" + encodeURIComponent(realFilePath) + "&regData=" + clientInformation.systemLanguage, "N", "N", getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(6)));
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
		if(PhotoBoard == "Y") return; 

		var xmlAttach = createXmlDom();
		xmlAttach = loadXMLString(ret);

		var objAttachNodes = xmlAttach.selectNodes("LISTVIEWDATA/ROWS/ROW");

	    lstAttachLink.innerHTML = "";
	    var strAttach = "";
	    strPreViewAttach = "";
	    rep = /'/g;
		
	    var j = 690;

	    for (i = 0 ; i < objAttachNodes.length ; i++ )
	    {
	        var realFileNM = getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(2));
	        var is_newfile = getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(5));
	        var IncodFileNM = encodeURIComponent(getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(1)));
		    realFileNM = ReplaceText(realFileNM, "'", "&apos;")
			
		    if (is_newfile != "DEL"){

		        strAttach = strAttach + "<input type='checkbox' name='fileSelect' newfile='" + getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(5)) + "' value='" + realFileNM + "' style='vertical-align:middle;'>";
			    strAttach = strAttach + getNodeText(objAttachNodes(i).childNodes.item(0).childNodes.item(0)) + "&nbsp;</a><br>"
		    }
	    }
	    lstAttachLink.innerHTML = strAttach;
	}
	catch(e){alert("AppendFileAttachInfo :: " + e.description);}
}

function AttachFileList()
{
    var xmldom_attachlist = createXmlDom();
	var strRet = "";
	var filepath = "";
	
	if (loadXMLString(pAttachListXml) == false) {
		xmldom_attachlist = null;	
		return "";
	}
	
	xmldom_attachlist = loadXMLString(pAttachListXml)
	var xmldomNodes = xmldom_attachlist.selectNodes("LISTVIEWDATA/ROWS/ROW/CELL/DATA2");
	
	for(i=0;i<xmldomNodes.length;i++)
	{
	    filepath = getNodeText(xmldomNodes.item(i));
		if(filepath.indexOf(pBoardID) != -1) {
			strRet += filepath + ";";
		} else {
		    strRet += "tempUploadFile/" + getNodeText(xmldomNodes.item(i)) + ";"
		}
	}
	
	xmldom_attachlist = null;
	
	return strRet;
}

function btn_PhotoAttachAdd_onclick(){
	var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	var file = "";
	if(pMode == "modify")
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

		var temp = ezUtil.ExtractFileName(g_fileList[i]);
		
		if( temp.length > 111 )
		{
			alert("" + strLang39 + "");
			return;
		}
		
		fileSize = ezUtil.GetFileSize(g_fileList[i]); 		
		
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
	beginAttachAdd_Photo();
}


function beginAttachAdd_Photo()
{
    document.all.EzHTTPTrans.AddUploadFile("","");

    for (var i=0; i<g_fileList.length-1; i++)
    {
		try
		{
			document.all.EzHTTPTrans.AddFilename(encodeURIComponent(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1)));
			document.all.EzHTTPTrans.AddUploadFile(g_fileList[i], "N");
		}
		catch (e) {
			if (e.number == -2147352567)
				alert("" + strLang5 + "");
			else 
				alert(g_fileList[i] + " " + strLang6 + "" + "\n\n" + e.number + " - " + e.description);

			return;
		}	
	}
	
	var RemotePath = document.location.protocol+"//" + document.location.hostname + ":" + location.port + "/ezCommunity/itemAttachFilePhoto.do";
	var nCount = document.all.EzHTTPTrans.StartUpload(RemotePath,"/upload_Community",pBoardID , "","");
	
	for (var i = 0; i < nCount; i++)
	{
	    var attachFileResult = document.all.EzHTTPTrans.GetReturn(i);
        var attachFilePath = attachFileResult.substr(0, attachFileResult.indexOf("/"));
	    var attachFilename = attachFileResult.substr(attachFileResult.indexOf("/")+1);
	    attachFilename = attachFilename.substr(0, attachFilename.lastIndexOf("/"));

	    if (attachFilename.substr(0, 2) != "OK")
	    {
		    try
		    {
		        txtPhotoFile.value = "";
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
		    txtPhotoFile.value = ezUtil.ExtractFileName(g_fileList[i]);
		    ezUtil = null;

		    var Result = attachFilename.substr(3, attachFilename.length-3)
		    
		    var gfileName="";
		    gfileName = replace(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1), "+", "%2b");
		    gfileName = replace(gfileName, ";", "%3b");
		    AttachFileInfo(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1), Result.substr(Result.lastIndexOf("/")+1), fileSize + "Bytes", Result, fileSize, attachFilePath);
	    }
	}
}

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
    var xmldom_attachlist = createXmlDom();
	var strRet = "";
	var filepath = "";
	
	if (typeof (pAttachListXml) == "string")
		xmldom_attachlist = loadXMLString(pAttachListXml);
	else
		xmldom_attachlist = loadXMLString(getXmlString(pAttachListXml));	    

	if (getXmlString(pAttachListXml) == "") {
		return "";
	}

	var xmldomNodes = xmldom_attachlist.selectNodes("LISTVIEWDATA/ROWS/ROW/CELL/DATA2");
	
	for(i=0;i<xmldomNodes.length;i++)
	{
	    filepath = getNodeText(xmldomNodes.item(i));
		if(filepath.indexOf(pBoardID) != -1) {
			strRet += filepath + ";";
		} else {
		    strRet += "tempUploadFile/" + getNodeText(xmldomNodes.item(i)) + ";"
		}
	}
	
	xmldom_attachlist = null;
	return strRet;
}