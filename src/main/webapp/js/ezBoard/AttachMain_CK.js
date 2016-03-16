var g_progresswin;
var g_fileList;
var pAttachListXml="";


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

function status_change(fileinfo){
	try {
		g_progresswin.document.Script.fileinfo_change(fileinfo);
	} catch(e) {}
}

function btn_ImgDel_onclick(){
	try{
  
		var j = 0 ;
		var multi_cnt = document.singlecheck.elements.length;

		for (var i=0; i < multi_cnt; i++){
			var ele = document.singlecheck.elements[i];
			if ( ele.name == "fileImgSelect" && ele.checked )
				j ++ ;
		}
	
		if (j){
			var pInformationContent = "" + strLang14 + "";
			var Ans = confirm(pInformationContent);
		
			if(Ans){
				var pAttachDelSN;
				var pAttachDelFileName;
				var is_newfile;
				var pNewNodeName = "";	// " + strLang15 + "
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
					var pAlertContent = "" + strLang16 + "";
					
				}
			}
		}
	}catch(ErrMsg){alert(ErrMsg.description);}
}




function btn_AttachDel_onclick()
{
	try
	{
	   
	    var multi_cnt = document.getElementsByName("fileSelect").length;

	    var j = 0;

	    for (var i = 0; i < multi_cnt; i++) {
	        if (document.getElementsByName("fileSelect")[i].checked) {
	            j++;
	        }
	    } 	
      

	    if (j)
	    {
		    var pInformationContent = "" + strLang17 + "";
		    var Ans = confirm(pInformationContent);
		
		    if(Ans)
		    {
			    var pAttachDelSN;
			    var pAttachDelFileName;
			    var is_newfile;
			    var pNewNodeName = "";	// " + strLang15 + "
			    var Rtnval;


			    for (var k = 0; k < multi_cnt; k++) 
		        {

		            if (document.getElementsByName("fileSelect")[k].checked) 
		            {
		                pAttachDelFileName = document.getElementsByName("fileSelect")[k].value;
		                is_newfile = GetAttribute(document.getElementsByName("fileSelect")[k], "newfile");
		                pNewNodeName = pNewNodeName + pAttachDelFileName + "*)[_-";

		                Rtnval = "TRUE";
		            }  
		        }
                
			
			    if (Rtnval == "TRUE")
			    {
				    // iframe 및 각종변수 설정 변경
			        DelAttachFileAtList(pNewNodeName);

			        AppendFileAttachInfo(pAttachListXml);		
				
//				    if (pAttachListXml == "")
//					    AppendFileAttachInfo("");
//				    else
//				    {
//					    var pstrXML = APRAttachXMLParsing();					    
//					    AppendFileAttachInfo(pstrXML);
//					   
//				    }
			    }
			    else
			    {
				    var pAlertContent = "" + strLang16 + "";
				    alert(pAlertContent);
			    }
		    }
	    }
	}
	catch(ErrMsg)
	{
	    alert(ErrMsg.description);
    }
}

function btn_AttachSaveSure_onclick()
{
	try
	{
		window.close();
	}catch(ErrMsg){alert(ErrMsg.description);}
}




//============================================================================================
//	첨부업로드 성공후 호출되는 함수: 첨부문서 ADD XML Parsing Function
//============================================================================================
// 2010.07.06 : Drag&Drop 실행, pAttatchFilePath 추가
//function attachfileinfo(result, prealfilename, psavefilename, pfilesize)
//{
//	try{
//	    if (result == "error")
//		{
//			var palertcontent = "" + strlang18 + "";
//			alert(palertcontent);
//			
//			return;
//		}
//		else if (result == "fileoverflowmsg") {
//			
//			pfilename = "";
//		}
//		else
//		{
//		    // 2010.07.06 : drag&drop 실행, attachfilepath 추가
//		    addattachfileinfoxmlparsing(prealfilename, psavefilename, pfilesize)
//		}

//	}catch(errmsg){alert(errmsg.description);}
//}btn_PhotoAlbumAttachAdd_onclick

/* 2016-03-16 NODEJS 관련 스크립트 주석/ 장진혁
 * function AttachFileInfo(resultXML) {

    var xml = loadXMLString(resultXML);
    var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
    var i = 0;
    try {
        for (i = 0; i < nodes.length; i++)
        {
            if (getNodeText(GetChildNodes(nodes[i])[1]) == "Error") {
                var pAlertContent = "" + strLang18 + "";
                alert(pAlertContent);

                return;
            }
            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "FileOverFlowMsg") {

                getNodeText(GetChildNodes(nodes[i])[2]) = ""; //filename
            }
            
        }
        // 2010.07.06 : Drag&Drop 실행, attachFilePath 추가
        AddAttachFileInfoXmlParsing(resultXML);

    }
    catch (ErrMsg)
    {
        alert(ErrMsg.description); 
    }
}*/
// ==============================================
// ListView에서 첨부파일 선택시 호출  Function
// ==============================================
function ATTACHonSelChange_onclick(){
	try{
	}catch(ErrMsg){alert(ErrMsg.description);}
}




function chkFileNMFilter(cur_ExtName){
	var SpeCha = new Array( "." , "" + strLang19 + "", "," , "&");
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
        alert("" + strLang20 + "" + StrSpeCha);
	}
 
    return chkflag;
}

function AppendFileAttachInfo(ret) {
    try {
        if (typeof (ret) == "string")
            pAttachListXml = loadXMLString(ret);
        else
            pAttachListXml = loadXMLString(getXmlString(ret));

        var objAttachNodes = SelectNodes(pAttachListXml, "LISTVIEWDATA/ROWS/ROW");

        var strAttach = "";
        strPreViewAttach = "";
        rep = /'/g;

        var j = 690;

        dadiframe.document.getElementById("lstAttachLink").innerHTML = "";

        var oTable = document.createElement("TABLE");
        oTable.style.width = "100%";
        oTable.id = "filelist";
        oTable.className = "sublist";

        var objTr = document.createElement("TR");

        var objTh = document.createElement("TH");
        var ua = navigator.userAgent;
        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1 && ua.indexOf("Macintosh") == -1) {
            objTh.style.width = "24px";
        }
        else
            objTh.style.width = "15px";
        var input = document.createElement("input");
        input.type = "checkbox";
        input.id = "checkboxall";
        input.onclick = function () { dadiframe.checkall(); };
        objTh.appendChild(input);
        objTr.appendChild(objTh);

        var objTh2 = document.createElement("TH");
        objTh2.style.width = "87%";
        objTh2.textContent = strLang1;
        objTr.appendChild(objTh2);

        var objTh3 = document.createElement("TH");
        objTh3.textContent = strLang3;
        objTh3.style.width = "13%";
        objTr.appendChild(objTh3);

        oTable.appendChild(objTr);
        dadiframe.document.getElementById("lstAttachLink").appendChild(oTable);

        for (i = 0; i < objAttachNodes.length; i++) {
            var realFileNM = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[1]);
            var ServerFile = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[2]);
            var is_newfile = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]);
            var fileSize = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[6]);
            realFileNM = ReplaceText(realFileNM, "'", "&apos;")

            if (is_newfile != "DEL") {
                objTr = document.createElement("TR");
                objTr.setAttribute("DATA2", ServerFile);
                objTr.setAttribute("NEWFILE", getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]));

                var objTd = document.createElement("TD");
                objTd.style.textAlign = "center";

                var input = document.createElement("input");
                input.type = "checkbox";
                input.name = "fileSelect";

                objTd.appendChild(input);
                objTr.appendChild(objTd);

                var objTd2 = document.createElement("TD");

                objTd2.innerHTML = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[0]).replace(/%2b/gi,"+").replace(/%3b/gi,";");
                objTr.appendChild(objTd2);

                var objTd3 = document.createElement("TD");

                if (fileSize / 1024 / 1024 > 1) {
                    fileSize = (Math.floor(parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
                }
                else if (fileSize / 1024 > 1) {
                    fileSize = parseInt(fileSize / 1024) + "KB";
                }
                else {
                    fileSize = fileSize + "B";
                }

                objTd3.textContent = fileSize;
                objTr.appendChild(objTd3);

                dadiframe.document.getElementById("filelist").appendChild(objTr);
            }
        }
    }
    catch (e) { alert("AppendFileAttachInfo :: " + e.description); }
}

function AttachFileList() {
    try {
        var strRet = "";
        var filepath = "";
        if (getXmlString(pAttachListXml) == "") {
            return "";
        }

        var xmldomNodes = GetElementsByTagName(pAttachListXml, "DATA2");

        for (i = 0; i < xmldomNodes.length; i++) {
            filepath = getNodeText(xmldomNodes[i]);
            if (filepath.indexOf(pBoardID) != -1) {
                strRet += filepath + ";";
            } else {
            strRet += pBoardID + "/UploadFile/" + getNodeText(xmldomNodes[i]) + ";"
            }
        }
    }
    catch (e) {
    }
	xmldom_attachlist = null;	
	return strRet;
}

function btn_PhotoAttachAdd_onclick(){
    document.getElementById('mode').value = "PHOTO";
    document.form.file1.click();
}


function show_progress_photo(fileinfo)
{
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
            // 201007 : AddFilename 추가, 자음+한자 특수기호 처리
            document.all.EzHTTPTrans.AddFilename(encodeURIComponent(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1)));
			// 2009.03.23 : EzHTTPTrans 기능 추가
			document.all.EzHTTPTrans.AddUploadFile(g_fileList[i], "N");			
		}
		catch (e)
		{
		    // 2009.03.12 : Drag&Drop 기능 추가
//			try {
//				hide_progress();
//			} catch(e) {}
			if (e.number == -2147352567)
				alert("" + strLang12 + "");
			else 
				alert(g_fileList[i] + " " + strLang13 + "" + "\n\n" + e.number + " - " + e.description);

			return;
		}	
	}
	
	// 2009.03.23 : EzHTTPTrans 기능 추가
	var RemotePath = document.location.protocol+"//" + document.location.hostname + "/myoffice/ezBoardSTD/interASP/Item_AttachFile_Photo.aspx";
	var nCount = document.all.EzHTTPTrans.StartUpload(RemotePath,"/Upload_BoardSTD",pBoardID , "","");
	
	for (var i = 0; i < nCount; i++)
	{
	    var attachFileResult = document.all.EzHTTPTrans.GetReturn(i);
        // 2010.07.06 : Drag&Drop 실행, attachFilePath 추가
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

		    // 2010.07.06 : Drag&Drop 실행, attachFilePath 추가
		    AttachFileInfo(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1), Result.substr(Result.lastIndexOf("/")+1), fileSize + "Bytes", Result, fileSize, attachFilePath)		    
	    }
	}

    // 2009.03.12 : Drag&Drop 기능 추가
//	try
//	{
//		g_progresswin.close();
//	} catch(e) {}
}

//PhotoAlbum
function btn_PhotoAlbumAttachAdd_onclick(file) {

    var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
    ezUtil.UseUTF8 = true;

    if (!file)
        return;

    pAttachListXml = "";

    g_fileList = file.split("|");

    var fileSize = 0;

    for (var i = 0; i < g_fileList.length - 1; i++) {
        if (ezUtil.GetFileSize(g_fileList[i]) == 0) {
            alert("" + strLang6 + "");
            return;
        }
        //[2006.06.20] 파일명의 길이가 111byte를 초과할 경우 오류메시지 처리.
        var temp = ezUtil.ExtractFileName(g_fileList[i]);

        if (temp.length > 111) {
            alert("" + strLang7 + "");
            return;

        }
        //2006.11.28 포토게시판은 게시물 건당 첨부파일 용량을 체크한다.
        fileSize = ezUtil.GetFileSize(g_fileList[i]);

        //게시판별로 설정되어 있는 첨부용량 제한
        if (fileSize > parseInt(AttachLimit) * 1024 * 1024) {
            alert("" + strLang8 + "" + AttachLimit + "MB" + strLang9 + "");
            return;
        }
    }

    ezUtil = null;

    var fileNamelist = "";
    var fileName = "";

    show_progress_photo(g_fileList[0].substr(g_fileList[0].lastIndexOf("\\") + 1) + "" + "를 업로드 중입니다. " + "" + 1 + "/" + (g_fileList.length - 1));
}



function AttachFileList_Photo()
{
	var strRet = "";
	var filepath = "";

	if (typeof (pAttachListXml) == "string")
	    pAttachListXml = loadXMLString(pAttachListXml);
	else
	    pAttachListXml = loadXMLString(getXmlString(pAttachListXml));	    

	if (getXmlString(pAttachListXml) == "") {
		return "";
	}

	var xmldomNodes = GetElementsByTagName(pAttachListXml, "DATA2");
	
	for(i=0;i<xmldomNodes.length;i++)
	{
	    filepath = getNodeText(xmldomNodes[i]);
		if(filepath.indexOf(pBoardID) != -1) {
		    strRet += filepath + ";";
		} else {
		    if (saveItemBoardId != "" && saveItemBoardId == pBoardID )
		        strRet += pBoardID + "/UploadFile/" + getNodeText(xmldomNodes[i]) + ";";
		    else
		        strRet += saveItemBoardId + "/UploadFile/" + getNodeText(xmldomNodes[i]) + ";";
		}
	}
	
	return strRet;
}


