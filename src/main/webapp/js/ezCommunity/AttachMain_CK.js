var g_progresswin;
var g_fileList;
var pAttachListXml="";

/*  2023-02-21 홍승비 - 첨부파일의 사이즈 총합을 계산하여 업로드 제한하도록 수정 (게시판 모듈과 통일) */
var uploadedFileSize = 0; // 첨부파일 사이즈의 총합 계산용 전역변수
var attachMove = "N";
var strRetNew = "";

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
       			document.form.file1.value = "";
       			alert(strLang84 + attachFileNameMaxLength + strLangLHM01);
       			return;
       		}
       		else { // 새롭게 추가된 모든 첨부파일들을 루프하며 사이즈를 합산
       			tempFileSize += parseInt(file.size);
       		}
       	});
       	
		// 현재 첨부된 파일과 기존 첨부된 파일의 사이즈 총합을 비교
		if ((tempFileSize + uploadedFileSize) / 1024 / 1024 > parseInt(AttachLimit)) {
			document.form.file1.value = ""; // 첨부 실패 시 첨부를 시도한 파일 리스트 초기화
			alert(strLang27 + AttachLimit + strLang28);
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
				returnvalue(data); // 업로드 성공 후 첨부파일 사이즈 총합 갱신 (내부적으로 initAttachFileSize 함수 호출)
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
function btn_AttachDel_onclick() {
	try {
		
	    var multi_cnt = document.getElementsByName("fileSelect").length;
	    var j = 0;
	    
	    for (var i = 0; i < multi_cnt; i++) {
	        if (document.getElementsByName("fileSelect")[i].checked) {
	            j++;
	        }
	    } 	
	    
	    if (j) {
	        var pInformationContent = "" + strLang32 + "";
		    var Ans = confirm(pInformationContent);
		    
		    if (Ans) {
			    var pAttachDelSN;
			    var pAttachDelFileName;
			    var is_newfile;
			    var pNewNodeName = "";	// " + strLang15 + "
			    var Rtnval;
			    
			    for (var k = 0; k < multi_cnt; k++) {
			    	var fileSelectNode = document.getElementsByName("fileSelect")[k];
		            if (fileSelectNode.checked) {
		            	/*fileSelectNode.parentNode.removeChild(fileSelectNode.nextSibling);*/
						var checkNodes = fileSelectNode.parentNode.parentNode.querySelectorAll('td');
						for (var j=0 ; j < checkNodes.length; j++) {
							if (checkNodes[j].childNodes[0].nodeName != 'INPUT') {
								checkNodes[j].remove();
							}
						}
		            	pAttachDelFileName = fileSelectNode.value;
		                is_newfile = GetAttribute(fileSelectNode, "newfile");
		                pNewNodeName = pNewNodeName + pAttachDelFileName + "*)[_-";
		                
		                Rtnval = "TRUE";
		            }
		        }
                
			    if (Rtnval == "TRUE") {
				    // iframe 및 각종변수 설정 변경
			        DelAttachFileAtList(pNewNodeName);
			        AppendFileAttachInfo(pAttachListXml);
					showAttachInnerNotice();
			        
//				    if (pAttachListXml == "")
//					    AppendFileAttachInfo("");
//				    else
//				    {
//					    var pstrXML = APRAttachXMLParsing();					    
//					    AppendFileAttachInfo(pstrXML);
//					   
//				    }
			    }
			    else {
			        var pAlertContent = "" + strLang31 + "";
				    alert(pAlertContent);
			    }
		    }
	    } else {
	    	var pAlertContent = "" + strLang89 + "";
	    	alert(pAlertContent);
	    }
	}
	catch(ErrMsg) {
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
        var div = document.createElement("div");
        div.className = "custom_checkbox"
		var input = document.createElement("input");
		input.type = "checkbox";
		input.id = "checkboxall";
		input.onclick = function () { checkall(); };
		div.appendChild(input);
		objTh.appendChild(div);
		objTr.appendChild(objTh);

		var objTh2 = document.createElement("TH");
		objTh2.style.width = "87%";
		objTh2.textContent = strLang22;
		objTr.appendChild(objTh2);

		var objTh3 = document.createElement("TH");
		objTh3.style.width = "13%";
		objTh3.textContent = strLang24;
		objTr.appendChild(objTh3);

		oTable.appendChild(objTr);
		document.getElementById("lstAttachLink").appendChild(oTable);

		var objP = document.createElement("p");
		objP.id = "attachInnerNotice";
		objP.className = "attachInnerNotice_p_off";

		var objSpan = document.createElement("span");
		objSpan.innerText = strLangMJS01;
		objSpan.className = "attachInnerNotice_span";

		objP.appendChild(objSpan);

		document.getElementById("lstAttachLink").appendChild(objP);
		
	    var strAttach = "";
	    strPreViewAttach = "";
	    rep = /'/g;

	    var j = 690;


	    for (i = 0; i < objAttachNodes.length; i++) {
	        var realFileNM = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[1]);
	        var ServerFile = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[2]);
	        var is_newfile = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]);
//	        var IncodFileNM = escape(getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[1]));
	        var fileSize = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[6]);
	        realFileNM = ReplaceText(realFileNM, "'", "&apos;");
	        
	        /* 2020-03-17 홍승비 - 커뮤니티 게시물 첨부파일(특수문자 존재 시) 수정, 삭제 불가능 오류 수정 */
	        if (is_newfile != "DEL") {
	        	/* 2023-08-16 홍승비 - 첨부파일 사이즈 계산을 위한 실제 바이트단위 파일사이즈 realfilesize 속성 추가 */
	            /*strAttach += "<input type='checkbox' name='fileSelect' newfile='" + is_newfile + "' value=\"" + MakeXMLString(ServerFile) + "\" realfilesize='" + fileSize + "' style='vertical-align:middle;'>";
	            strAttach += getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[0]).replace(/%2b/gi, "+").replace(/%3b/gi, ";") + "&nbsp;</a>&nbsp;<br>"*/
				objTr = document.createElement("TR");
				objTr.setAttribute("DATA2", ServerFile);
				objTr.setAttribute("newfile", is_newfile);
				objTr.setAttribute("value", MakeXMLString(ServerFile));
				objTr.setAttribute("realfilesize", fileSize);
				objTr.setAttribute("draggable", true);
				objTr.setAttribute("_fileIndex", i);

				var objTd = document.createElement("TD");
				objTd.style.textAlign = "center";
                
                var div = document.createElement("div");
                div.className = "custom_checkbox";
				var input = document.createElement("input");
				input.type = "checkbox";
				input.name = "fileSelect";
				input.setAttribute("value", MakeXMLString(ServerFile));

				div.appendChild(input);
				objTd.appendChild(div);
				objTr.appendChild(objTd);

				var objTd2 = document.createElement("TD");

				objTd2.innerHTML = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[0]);
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

				document.getElementById("filelist").appendChild(objTr);
			}
	    }
	    /*document.getElementById("lstAttachLink").innerHTML = strAttach;*/
	    
	    /* 2023-08-16 홍승비 - 커뮤니티 게시물 첨부파일 초기 로딩 및 추가, 삭제 시 > 첨부파일 사이즈의 총합을 계산하여 uploadedFileSize 전역변수에 설정 */
	    initAttachFileSize();
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
	
    callMoveAttachFileOrder(pAttachListXml);
	if (attachMove == "N") {
		return strRet;
	} else {
		return strRetNew;
	}
		
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

function checkall() {
	var filecnt = document.getElementById("filelist").childNodes.length;

	for (var i = 1; i < filecnt; i++) {
		if (document.getElementById("checkboxall").checked == true) {
			document.getElementById("filelist").childNodes[i].querySelector("input[type=checkbox]").checked = true;
		}
		else {
			document.getElementById("filelist").childNodes[i].querySelector("input[type=checkbox]").checked = false;
		}
	}
}

function onDragEnter(evt) {
	evt.dataTransfer.dropEffect = "copy";
	evt.stopPropagation();
	evt.preventDefault();
}
function onDragOver(evt) {
	evt.dataTransfer.dropEffect = "copy";
	evt.stopPropagation();
	evt.preventDefault();
}

function onDrop(evt) {
	file = new Array;

	if (evt != undefined) {
		evt.stopPropagation();
		evt.preventDefault();
	}

	if (isfileup) {
		alert(strLang258);
		return;
	}

	var filelist;

	if (evt == undefined) {
		filelist = document.getElementById("file").files;
	}
	else {
		filelist = evt.dataTransfer.files;
	}

	var tempfilesize = 0;
	var filecnt = file.length;

	for (var i = 0; i < filelist.length; i++) {
		if (filelist[i].size / 1024 / 1024 > 5) {
			alert(messageCode3);
			return;
		}
		else {
			file[filecnt + i] = filelist[i];
			tempfilesize += filelist[i].size;
		}
	}

	uploadedFileSize += tempfilesize;
	fileupload("drag");

	//같은 파일을 업로드 할 때, onchange 이벤트가 발생하지 않아 아래부분 추가. 2018-12-19 홍대표
	if (CrossYN()) {

		if (navigator.userAgent.search('Trident') != -1) { //IE 11
			document.getElementById("file").type = "text";
			document.getElementById("file").type = "file";
		} else {
			document.getElementById("file").value = "";
		}

	} else {
		document.getElementById("file").type = "text";
		document.getElementById("file").type = "file";
	}
}

function fileupload(evtType) {

/*	document.getElementById("boardID").value = pBoardID;
	document.getElementById("maxSize").value = parseInt(AttachLimit) * 1024 * 1024;
	document.getElementById("cnt").value = document.getElementById("form").file1.files.length;*/
	
	var fd = new FormData();
	var tempFileSize = 0;
	
	var tempFiles = evtType != undefined && evtType === "drag" ? file : $('#file1')[0].files;
	var returnYN = false;

	$.each(tempFiles, function(i, file) {
		if (MakeXMLString(file.name).length > attachFileNameMaxLength) {
			document.form.file1.value = "";
			alert(strLang84 + attachFileNameMaxLength + strLangLHM01);
			returnYN = true;
			return;
		}
		else { // 새롭게 추가된 모든 첨부파일들을 루프하며 사이즈를 합산
			tempFileSize += parseInt(file.size);
		}
	});
	
	if (returnYN == true) {
	    return;
	}

	// 현재 첨부된 파일과 기존 첨부된 파일의 사이즈 총합을 비교
	if ((tempFileSize + uploadedFileSize) / 1024 / 1024 > parseInt(AttachLimit)) {
		document.form.file1.value = ""; // 첨부 실패 시 첨부를 시도한 파일 리스트 초기화
		alert(strLang27 + AttachLimit + strLang28);
		return;
	}
	else {
		for (var i = 0; i < file.length; i++) {
			fd.append('file-' + i, file[i]);
		}
	}

	fd.append("boardID", pBoardID);
	fd.append("maxSize", parseInt(AttachLimit) * 1024 * 1024);
	fd.append("mode", "ATT");
	fd.append("cnt", document.getElementById("form").file1.files.length);
	isfileup = true;
	xhr.upload.addEventListener("progress", uploadProgress, false);
	xhr.addEventListener("load", uploadComplete, false);
	xhr.addEventListener("error", uploadFailed, false);
	xhr.addEventListener("abort", uploadCanceled, false);
	xhr.open("POST", "/ezCommunity/upload.do");
	xhr.send(fd);
	document.getElementById('progdiv').style.display = "inline-block";
}

function uploadComplete(evt) {
	xhr.removeEventListener("load", uploadComplete);
	document.getElementById('prog_bar').style.width = "0%";
	document.getElementById('prog_num').innerHTML = "0";
	document.getElementById('progdiv').style.display = "none";
	window.parent.returnvalue(xhr.responseText);

	var strRet = "";
	var pBoardID = window.parent.pBoardID;
	var filecnt = document.getElementById("filelist").childNodes.length;

	/* 2021-04-29 홍승비 - 새로운 첨부파일 업로드 완료 후, 파일경로(DATA2) 속성을 갱신하도록 수정 */
	for (var i = 0; i < filecnt - 1; i++) {
		var filepath = document.getElementById("filelist").childNodes[i + 1].getAttribute("DATA2");
		if (filepath.indexOf(pBoardID) != -1) {
			strRet += filepath + "|";
		} else {
			var tempUploadFileStr = '';
			if (filepath.split('/')[0]  != "tempUploadFile") {
				tempUploadFileStr = 'tempUploadFile/';
			}
			strRet += tempUploadFileStr + filepath + "|";
			document.getElementById("filelist").childNodes[i + 1].setAttribute("DATA2", tempUploadFileStr + filepath);
		}
	}
	window.parent.attachxml = strRet;
	isfileup = false;

	if (CrossYN()) {
		document.getElementById("file").value = "";
	} else {
		document.getElementById("file").type = "text";
		document.getElementById("file").type = "file";
	}
}

function uploadFailed(evt) {
	alert(messageCode1);
}

function uploadCanceled(evt) {
	alert(messageCode2);
}

function uploadProgress(evt) {
	if (evt.lengthComputable) {
		var percentComplete = Math.round(evt.loaded * 100 / evt.total);
		document.getElementById('prog_bar').style.width = percentComplete + "%";
		document.getElementById('prog_num').innerHTML = percentComplete;
	}
}

function setAttachSortable() {
	$("#lstAttachLink").multipleSortable({
		items : "tr[data2]",
		opacity: 0.3,
		start : function(event, elem) {
			$("#lstAttachLink tr").removeClass("multiple-sortable-selected");
			$("#lstAttachLink tr").removeClass("ui-sortable-helper");
		},
		click : function(event) {
			$("#lstAttachLink tr").removeClass("multiple-sortable-selected");
			$("#lstAttachLink tr").removeClass("ui-sortable-helper");
		},
		stop : function(event, elem) {
		}
	});
}

function showAttachInnerNotice() {
	var fileCnt = document.querySelectorAll("#filelist tr[data2]").length;
	if (fileCnt > 0) {
		document.getElementById("attachInnerNotice").className = "attachInnerNotice_p_off";
	} else {
		document.getElementById("attachInnerNotice").className = "attachInnerNotice_p_on";
	}
}

function callMoveAttachFileOrder(attachxml) {
	var tmpFileList = document.querySelectorAll("#filelist tr[_fileindex]");
	if(tmpFileList.length > 0) {
		moveAttachFileOrder(tmpFileList, attachxml);
	}
}

function moveAttachFileOrder(fileList, attachxml) {
	var fileIdxArr = [].map.call(fileList, function(fileNode){
		return fileNode.getAttribute("_fileindex");
	});

	for (var i = 0; i < fileIdxArr.length; i++) {
		if (i != fileIdxArr[i]) {
			saveAttachFileOrder();
			break;
		}
	}
}

function saveAttachFileOrder(){
	var pBoardID = pBoardID;
	var filecnt = document.getElementById("filelist").childNodes.length;

	for (var i = 1; i < filecnt; i++) {
		var filepath = document.getElementById("filelist").childNodes[i].getAttribute("DATA2");
		if (filepath.indexOf(pBoardID) != -1) {
			strRetNew += filepath + "|";
		}
		else if (filepath.indexOf("tempUploadFile") != -1)
		{
			strRetNew += filepath + "|";
		}
		else {
			strRetNew += pBoardID + "/uploadFile/" + filepath + "|";
		}
	}
	attachMove = "Y";
	return strRetNew;
}