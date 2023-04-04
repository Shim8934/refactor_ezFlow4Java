var g_progresswin;
var g_fileList;
var pAttachListXml="";

/*  2023-02-21 홍승비 - 첨부파일의 사이즈 총합을 계산하여 업로드 제한하도록 수정 (게시판 모듈과 통일) */
var uploadedFileSize = 0; // 첨부파일 사이즈의 총합 계산용 전역변수

function btn_AttachAdd_onclick() {
	document.getElementById("boardID").value = pBoardID;
    document.getElementById("maxSize").value = parseInt(AttachLimit) * 1024 * 1024;
    document.getElementById("cnt").value = document.getElementById("form").file1.files.length;
    
    if (document.getElementById("cnt").value > 0) {
    	var formData = new FormData();
    	
    	/* 2021-12-09 홍승비 - 포토게시판에 사진 첨부 시, 페이지 및 서버단의 확장자 체크 추가 */
    	if (document.getElementById('mode').value == "PHOTO") {
    		  var filename = document.getElementById("form").file1.files[0].name;
              var extension = filename.substring(filename.lastIndexOf(".") + 1, filename.length);
              var check = "false";
              check = compareExtension(check, extension);
              
              if (check == "false") {
            	  document.form.file1.value = "";
                  alert(filename + strLang40);
                  return;
              }
              
              if (checkImgExtension(extension) == "UPLOAD_EXT_ERROR") {
            	  document.form.file1.value = "";
            	  alert(srtLangHSBEx01); // 허용하지 않는 확장자입니다.
            	  return ;
              }
    	}
    	
    	var tempFileSize = 0;
    	
    	// 특수문자 파싱 이후 파일명 길이를 기준으로 체크
       	$.each($('#file1')[0].files, function(i, file) {
       		if (MakeXMLString(file.name).length > attachFileNameMaxLength) {
       			alert(strLang84 + attachFileNameMaxLength + strLangLHM01);
       			return;
       		}
       		else { // 새롭게 추가된 모든 첨부파일들을 루프하며 사이즈를 합산
       			tempFileSize += parseInt(file.size);
       		}
       	});
       	
		// 현재 첨부된 파일과 기존 첨부된 파일의 사이즈 총합을 비교
		if ((tempFileSize + uploadedFileSize) / 1024 / 1024 > parseInt(AttachLimit)) {
			alert(strLang27 + AttachLimit + "MB" + strLang28);
			return;
		}
		else {
			$.each($('#file1')[0].files, function(i, file) {
				formData.append('file-' + i, file);
			});
		}
       	
       	formData.append('mode',  document.getElementById('mode').value);
       	formData.append("boardID", document.getElementById("boardID").value);
       	formData.append("maxSize", document.getElementById("maxSize").value);
       	formData.append("cnt", document.getElementById("cnt").value);
       	
		$.ajax({
			url : "/ezCommunity/upload.do",
			type : "POST",
			processData : false,
			contentType : false,
			data : formData,
			success : function(data){
				returnvalue(data);
				uploadedFileSize += tempFileSize; // 업로드 성공 후 첨부파일 사이즈 총합 갱신
			}
		});
       	
        document.form.file1.value = "";
    }
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

					DelAttachFileAtList(pNewNodeName);
				
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



/* 2023-02-21 홍승비 - 첨부파일 삭제 시 사이즈 계산 로직 추가 */
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
	        var pInformationContent = "" + strLang32 + "";
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
			    	var fileSelectNode = document.getElementsByName("fileSelect")[k];
		            if (fileSelectNode.checked) 
		            {
		            	fileSelectNode.parentNode.removeChild(fileSelectNode.nextSibling);
		            	pAttachDelFileName = fileSelectNode.value;
		                is_newfile = GetAttribute(fileSelectNode, "newfile");
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
			        var pAlertContent = "" + strLang31 + "";
				    alert(pAlertContent);
			    }
		    }
	    }else{
		    	var pAlertContent = "" +strLang89 + "";
		    	alert(pAlertContent);
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
//}

function AttachFileInfo(resultXML) {
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
            } else if (getNodeText(GetChildNodes(nodes[i])[1]) == "FileOverFlowMsg") {
            	setNodeText(GetChildNodes(nodes[i])[2],""); //filename               
            }
            
        }
        // 2010.07.06 : Drag&Drop 실행, attachFilePath 추가
        AddAttachFileInfoXmlParsing(resultXML);

    }
    catch (ErrMsg)
    {
        alert(ErrMsg.description); 
    }
}
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

function AppendFileAttachInfo(ret)
{
	try {
	    if (typeof (ret) == "string") {
	        pAttachListXml = loadXMLString(ret);
	    } else {
	        pAttachListXml = loadXMLString(getXmlString(ret));
	    }
	    
		// 20070228  포토게시판은 해당 내용 건너 뜀
		if(PhotoBoard == "Y") return;

		var objAttachNodes = SelectNodes(pAttachListXml, "LISTVIEWDATA/ROWS/ROW");


		//lstAttachLink.innerHTML = "";
		document.getElementById("lstAttachLink").innerHTML = "";
		
	    var strAttach = "";
	    strPreViewAttach = "";
	    rep = /'/g;

	    var j = 690;


	    for (i = 0; i < objAttachNodes.length; i++) {
	        var realFileNM = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[1]);
	        var ServerFile = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[2]);
	        var is_newfile = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]);
//	        var IncodFileNM = escape(getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[1]));
	        realFileNM = ReplaceText(realFileNM, "'", "&apos;");
	        
	        /* 2020-03-17 홍승비 - 커뮤니티 게시물 첨부파일(특수문자 존재 시) 수정, 삭제 불가능 오류 수정 */
	        if (is_newfile != "DEL") {
	            strAttach += "<input type='checkbox' name='fileSelect' newfile='" + getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]) + "' value=\"" + MakeXMLString(ServerFile) + "\" style='vertical-align:middle;'>";
	            strAttach += getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[0]).replace(/%2b/gi, "+").replace(/%3b/gi, ";") + "&nbsp;</a>&nbsp;<br>"
	        }
	    }
	    document.getElementById("lstAttachLink").innerHTML = strAttach;
		
	}
	catch(e){alert("AppendFileAttachInfo :: " + e.description);}
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
                //strRet += filepath + ";";
            	strRet += filepath + "|"; //baonk added
            } else {
                //strRet += pBoardID + "/UploadFile/" + getNodeText(xmldomNodes[i]) + ";"
                //strRet += "tempUploadFile/" + getNodeText(xmldomNodes[i]) + ";";
            	strRet += "tempUploadFile/" + getNodeText(xmldomNodes[i]) + "|"; //baonk added
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
//				status_change(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1) + "" + strLang10 + "" + (i+1) + "/" + (g_fileList.length-1));
//			}

            // 201007 : AddFilename 추가, 자음+한자 특수기호 처리
            document.all.EzHTTPTrans.AddFilename(encodeURIComponent(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1)));
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
//			    oPoster.Protocol = 0;
//            else
//            	oPoster.Protocol = 1;

			//			oPoster.PostURL = "/myoffice/ezBoardSTD/interASP/Item_AttachFile_Photo.aspx?boardid=" + pBoardID + "&uploadsn=" + pAttachGUID;
//			oPoster.Post();

//            if (oPoster.Response.substr(0, 2) != "OK"){
//				try {
//					txtPhotoFile.value = "";
//					hide_progress();	
//									
//				} catch(e) {}
//				//alert(g_fileList[i] + " 을 업로드 중 에러가 발생했습니다.\n\n서버측 오류");
//				alert(g_fileList[i] + " " + strLang24 + "");
//				txtPhotoFile.value = "";
//				return;
//			}else{
//				var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");	
//        	    ezUtil.UseUTF8 = true;
//				fileSize = ezUtil.GetFileSize(g_fileList[i]); 		
//				txtPhotoFile.value = ezUtil.ExtractFileName(g_fileList[i]);	//2006.10.20 " + strLang25 + "	
//				ezUtil = null;

//				var Result = oPoster.Response.substr(3, oPoster.Response.length-3)
//				AttachFileInfo(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1), Result.substr(Result.lastIndexOf("/")+1), fileSize + "Bytes", Result, fileSize)
//			}
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
		    //strRet += filepath + ";";
			strRet += filepath + "|"; //baonk added
		} else {
		    //strRet += pBoardID + "/UploadFile/" + getNodeText(xmldomNodes[i]) +";";
		    //strRet += "tempUploadFile/" + getNodeText(xmldomNodes[i]) + ";"
			strRet += "tempUploadFile/" + getNodeText(xmldomNodes[i]) + "|"; //baonk added
		}
	}
	
	return strRet;
}




