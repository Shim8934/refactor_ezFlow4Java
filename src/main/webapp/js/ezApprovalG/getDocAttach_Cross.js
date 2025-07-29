var bAttachProcess = false;
var tempIfrm = null;
function AttachProcess(e) {
    if (!e) {
        return;
    }

    bAttachProcess = true;
    e.preventDefault();

    var target = e.target;
    var href = target.getAttribute("href");

    var ifrm = document.createElement("iframe");
    ifrm.setAttribute("src", href);
    ifrm.setAttribute("id", "tempDownFrame");
    ifrm.style.display = "none";

    document.body.appendChild(ifrm);

    tempIfrm = ifrm;
}

function removeTempFrame() {
    if (!!tempIfrm) {
        document.body.removeChild(tempIfrm);
        tempIfrm = null;
    }
}

function DocFileAttach_Click(obj) {
    var regData = "";

    if (document.all)
        regData = navigator.systemLanguage;
    else if (document.layers)
        regData = navigator.systemLanguage;
    else if (document.getElementById) {
        if (navigator && navigator.systemLanguage)
            regData = navigator.systemLanguage.substr(0, 2);
        else {
            if (typeof clientInformation != 'undefined')
                regData = clientInformation.systemLanguage;
            else
                regData = "";
        }
    }
    else {
        if (typeof clientInformation != 'undefined') {
            if (clientInformation && clientInformation.systemLanguage)
                regData = clientInformation.systemLanguage;
        }
    }
    var filename = obj.getAttribute("AttachFilename");
    var filepath = obj.getAttribute("AttachFilepath");
    var openLocation = "/myoffice/Common/DownloadAttach.aspx?filename=" + filename + "&filepath=" + filepath + "&regData=" + regData;
    ifrmDownload.location.href = openLocation;
}

function trim(str) {
    return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}
/**
 * 첨부파일 정보 추출
 * */
function setAttachInfo(tempDocID, INGFlag, attachTag) {
    attachTag.innerHTML = "";
    
    /* 2022-01-17 홍승비 - 일괄기안 시 안별 iframe 내부에 접근해야 하므로 분기처리 */
    var isDraftAllPage = "N";
    var docAttachTag = ""; // 문서첨부영역 분리
    var parentHasAttachAry = new Array(); // 부모창의 일반첨부여부 배열
    var parentHasDocAttachAry = new Array(); // 부모창의 문서첨부여부 배열
    var currIdx = 0; // 현재 선택된 안의 인덱스 (1안부터 시작, 최대 10)
    
    // 일괄기안 부모페이지에서 접근
    var tempHref = document.location.href;
    if (tempHref.indexOf("ezApprovalG/draftuiAll_WHWP.do") > -1 || tempHref.indexOf("ezApprovalG/approvuiAll_WHWP.do") > -1) {
    	isDraftAllPage = "Y";
    	attachTag = document.getElementById(attachTag.id);
    	docAttachTag = document.getElementById(attachTag.id + "Doc");
    	parentHasAttachAry = pHasAttachYNAry;
    	parentHasDocAttachAry = pHasDocAttachYNAry;
    	currIdx = currentTabIdx;
    }
    // 일괄기안 자식페이지에서 접근
    else if (tempHref.indexOf("ezApprovalG/draftContentAll_WHWP.do") > -1 || tempHref.indexOf("ezApprovalG/approvContentAll_WHWP.do") > -1
                || parent.location.href.indexOf("ezApprovalG/draftuiAll_WHWP.do") > -1 || parent.location.href.indexOf("ezApprovalG/approvuiAll_WHWP.do") > -1) {
    	isDraftAllPage = "Y";
    	attachTag = parent.document.getElementById(attachTag.id);
    	docAttachTag = parent.document.getElementById(attachTag.id + "Doc");
    	parentHasAttachAry = parent.pHasAttachYNAry;
    	parentHasDocAttachAry = parent.pHasDocAttachYNAry;
    	currIdx = frameNum;
    }
    // 기본 접근
    else {
    	docAttachTag = document.getElementById(attachTag.id + "Doc");
    }

	if (docAttachTag != undefined && docAttachTag != null) {
		docAttachTag.innerHTML = "";
	}
	
    var url = "";
	var result = "";
	
	if (INGFlag != "TMP" && INGFlag != "END_RECORD" && INGFlag != "APR_RECORD") {
    	   $.ajax({
    			type : "POST",
    			dataType : "text",
    			async : false,
    			url : "/ezApprovalG/getLineMode.do",
    			data : {
    					docID : tempDocID, // pDocID 대신 함수 호출 시의 tempDocID 파라미터를 사용하도록 수정
    					orgCompanyID : orgCompanyID
    			},
    			success: function(xml){
    				INGFlag = xml;
    			}        			
    	  });
	} else {
		INGFlag = INGFlag.substring(0,3);
	}
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getTotalAttachInfo.do",
		data : {
			docID : tempDocID,
			mode : INGFlag,
			orgCompanyID : orgCompanyID
		},
		success: function(xml){
			result = xml;
		}        			
	});
    var xmldom = createXmlDom();

    xmldom =loadXMLString(result);
    var xmlRtn = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
    if (xmlRtn.length > 0) {
        var strAttach = "";
        var strDocAttach = "";
        var rep = /'/g;
        for (i = 0; i < xmlRtn.length; i++) {
            var Row = xmlRtn[i];
            var Cell = GetChildNodes(Row);

            // 일반 파일 첨부
            if (SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA4") == "File" || SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA4") == strLang1136) {
                var IncodFileNM = encodeURIComponent(SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA1"));
                var filename = encodeURIComponent(getNodeText(GetChildNodes(xmlRtn[i])[1]));
                var filepath = IncodFileNM.replace(rep, "&#39;");
                var xmlFileName = MakeXMLString(getNodeText(GetChildNodes(xmlRtn[i])[1])); // 특문처리를 거쳐서 실제 파일명과 파일경로을 표출
                var xmlFilePath = MakeXMLString(SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA1"));
                var strTarget = "target='_blank'";
                var fileImage = "";
                var strFileExt = filename.substr(filename.lastIndexOf('.')).toLowerCase();

                if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
                   strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
                   strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
                   strFileExt == ".xlsx" || strFileExt == ".rtf") {
                    strTarget = "target=''";
                }

                if (strFileExt.indexOf(".jpg") != -1 || strFileExt.indexOf(".jpeg") != -1 || strFileExt.indexOf(".bmp") != -1 || strFileExt.indexOf(".gif") != -1 || strFileExt.indexOf(".png") != -1 || strFileExt.indexOf(".tif") != -1 || strFileExt.indexOf(".tiff") != -1)
                    fileImage = "/images/image.png";
                else if (strFileExt.indexOf(".doc") != -1 || strFileExt.indexOf(".docx") != -1)
                    fileImage = "/images/doc.png";
                else if (strFileExt.indexOf(".xls") != -1 || strFileExt.indexOf(".xlsx") != -1)
                    fileImage = "/images/xls.png";
                else if (strFileExt.indexOf(".ppt") != -1 || strFileExt.indexOf(".pptx") != -1 || strFileExt.indexOf(".pps") != -1 || strFileExt.indexOf(".ppsx") != -1)
                    fileImage = "/images/ppt.png";
                else if (strFileExt.indexOf(".txt") != -1)
                    fileImage = "/images/txt.png";
                else if (strFileExt.indexOf(".zip") != -1)
                    fileImage = "/images/zip.png";
                else if (strFileExt.indexOf(".pdf") != -1)
                    fileImage = "/images/pdf.png";
                else if (strFileExt.indexOf(".ecm") != -1)
                    fileImage = "/images/ecm.png";
                //확장자가 hwp인 파일을 첨부할 경우 아래아한글 아이콘이 나타나도록 수정. 2019-10-25 홍대표
                else if (strFileExt.indexOf(".hwp") != -1)
                	fileImage = "/images/hwp.png";
                else
                    fileImage = "/images/attach-small.gif";

                if (CrossYN())
                    strTarget = "target=\''";

                var protocol = window.location.protocol;
                var serverName = window.location.hostname;

                /* 2020-11-18 홍승비 - 선택 및 다중 다운로드를 위한 체크박스 추가, 파일 아이콘 위치 정렬 */
                strAttach = strAttach + "<span style='display:inline-block;'><div class='custom_checkbox'><input type='checkbox' name='fileSelect' fileName=\"" + xmlFileName + "\" filepath=\"" + xmlFilePath +"\"><label>";
                strAttach = strAttach + "<a href= /ezApprovalG/downloadAttach.do?fileName=" + filename + "&docID=" + tempDocID + "&docStatus=" + INGFlag + "&docAttachSN=" + SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA2") + "&filePath=" + filepath + " onclick='AttachProcess(event)'>";
                //strAttach = strAttach + "<a href='/myoffice/Common/downloadattach.aspx?filename=" + filename + "&filepath=" + filepath + "' " + strTarget + "' onclick='AttachProcess()'>";

                strAttach = strAttach + "<IMG SRC='" + fileImage + "' border='0' style='vertical-align:middle; padding-right: 3px;'>";
                strAttach = strAttach + MakeXMLString(getNodeText(GetChildNodes(xmlRtn[i])[1])) + "</a></label></div>";
                
                // 2023-05-25 조수빈 - 첨부파일 미리보기 아이콘 추가
                if (typeof useAprFilePrvw !== 'undefined' && useAprFilePrvw == "1") {
                	strAttach += "<span class='icon_rbtn2' style='margin-left : 10px;' title=\"" + strLangJSBAP01 + "\" onclick=\"attachFile_Preview('" + filepath + "', '" + encodeURIComponent(filename) + "');\"><img src='/images/icon_preview.png' width='16' height='16' style='vertical-align:middle; cursor:pointer;'></span>";
				}
                
                if (SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "ISBIGATTACH") == "Y") { // 대용량첨부파일 표시
                	strAttach = strAttach + " <font style='color:blue'>[" + strLangHSBAt02 + "]</font> &nbsp;</span>";
                } else {
                	strAttach = strAttach + " &nbsp;</span>";
                }
                
                /* 2020-11-17 홍승비 - 일반첨부와 문서첨부 영역의 분리 */
                attachTag.innerHTML = strAttach + "<iframe frameborder=\"0\" id=\"ifrmDownload\" name=\"ifrmDownload\" src=\"about:blank\" width=\"0\" height=\"0\"></iframe>";
                
                // 일괄기안용 일반첨부 플래그 부여
                if (isDraftAllPage == "Y") {
                	parentHasAttachAry[currIdx] = "Y";
                }
            }
            // 문서첨부
            else {
                var FilePath = trim_Cross(SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA1"));
                var FileExt = getOriginalFileExtension(FilePath);
                var isKlibFile = FilePath.lastIndexOf(".ezd") === FilePath.length - 4;
            	var FileDocID = trim_Cross(FilePath.substr(FilePath.length - (isKlibFile ? 28: 24), 20).toLowerCase());
                var FileName = escapeHtml(trim_Cross(getNodeText(GetChildNodes(xmlRtn[i])[1])));
                var OpenLocation = "";
                if (FileDocID == "" && FilePath == "") {
                	strDocAttach = strDocAttach + "<a style='cursor:pointer' onclick=\"OpenAttachAlertUI('" + strLang260 + "')\">";
                	strDocAttach = strDocAttach + "<IMG SRC='/images/attach-small.gif' border='0'>";
                    strDocAttach = strDocAttach + FileName + "</a> &nbsp; ";
                } else if (FileExt == "hwp") {
                	//2018-09-12 천성준 - mht결재문서에 hwp문서를 문서첨부 하고 IE가 아닌 chrome으로 mht결재문서를 문서보기 하면 알럿이 뜨면서 첨부파일 정보가 공백이 되어서 IE검사 주석처리함. 대신 문서보기 하단 문서첨부를 클릭해서 열때 hwp이면 IE검사를 하게 로직 추가함
                	/*if (isIE()) {
                		openLocation = "/ezApprovalG/ezViewEnd_HWP.do?docID=" + escapenew(FileDocID) +
                		"&docHref=" + escapenew(FilePath) + "&formID=&orgDocid=";
                		strAttach = strAttach + "<a style='cursor:pointer' onclick=\"openAttachView('" + openLocation + "', '', 973, 570)\">";
                		strAttach = strAttach + "<IMG SRC='/images/attach-small.gif' border='0'>";
                		strAttach = strAttach + getNodeText(GetChildNodes(xmlRtn[i])[1]) + "</a> &nbsp; ";
                    } else {
                    	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
                    	alert(pAlertContent);
                        
                        return;
                    }*/ 
                	if (useWebHWP == "NO") {
	                	if (isIE()) {
		                	openLocation = "/ezApprovalG/ezViewEnd_HWP.do?docID=" + escapenew(FileDocID) + "&docHref=" + escapenew(FilePath) + "&formID=&orgDocid=";
	                	} else {
	                    	var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	                    	alert(pAlertContent);
	                        
	                        return;
	                    }
                	} else {
                		openLocation = "/ezApprovalG/ezViewEnd_WHWP.do?docID=" + escapenew(FileDocID) + "&docHref=" + escapenew(FilePath) + "&formID=&orgDocid=&docAttachParent=" + escapenew(tempDocID);
                	}
                	strDocAttach = strDocAttach + "<a style='cursor:pointer' onclick=\"openAttachView('" + openLocation + "', '', 973, 570)\">";
                	strDocAttach = strDocAttach + "<IMG SRC='/images/attach-small.gif' border='0'>";
                	strDocAttach = strDocAttach + FileName + "</a> &nbsp; ";
                	
                } else {
                    openLocation = "/ezApprovalG/contDocView.do";
                    openLocation = openLocation + "?docID=" + escapenew(FileDocID) + "&docHref=" + escapenew(FilePath) + "&formID=&orgDocID=&docAttachParent=" + escapenew(tempDocID);
                    strDocAttach = strDocAttach + "<a style='cursor:pointer' onclick=\"openAttachView('" + openLocation + "', '', 973, 570)\">";
                    strDocAttach = strDocAttach + "<IMG SRC='/images/attach-small.gif' border='0'>";
                    strDocAttach = strDocAttach + FileName + "</a> &nbsp; ";
                }
                
                /* 2020-11-17 홍승비 - 일반첨부와 문서첨부 영역의 분리 */
                docAttachTag.innerHTML = strDocAttach + "<iframe frameborder=\"0\" id=\"ifrmDownload\" name=\"ifrmDownload\" src=\"about:blank\" width=\"0\" height=\"0\"></iframe>";
                
                // 일괄기안용 문서첨부 플래그 부여
                if (isDraftAllPage == "Y") {
                	parentHasDocAttachAry[currIdx] = "Y";
                }
            }
        }
        
        try {
            pHasAttachYN = "Y";
        } catch (e) { }
    }
    else {
        try {
            pHasAttachYN = "N";
            
            // 일괄기안용 일반첨부, 문서첨부 플래그 부여
            if (isDraftAllPage == "Y") {
            	parentHasAttachAry[currIdx] = "N";
            	parentHasDocAttachAry[currIdx] = "N";
            }
        } catch (e) { }
    }
}

// 2023-05-26 조수빈 - 결재문서 첨부파일 미리보기
function attachFile_Preview(filePath, fileOrgName) {
	$.ajax({
		type : "GET",
		url: "/ezApprovalG/attachItemPreview.do",
		data : {
			pFilePath : filePath,
			fileName : fileOrgName
		},
		success : function(result){
			if (result != "") {
				window.open(result, '_blank', GetOpenWindowfeature(1100, 950));
			} else {
				alert(strLang223);
			}
		},
		error : function(error){
			alert(strLang223);
			console.log(error);
		}
	})
}




function getOriginalFileExtension(filePath) {
	var pathLength = filePath.length;
	var lastIndexOfDot = filePath.lastIndexOf(".");

	if (lastIndexOfDot < 0) {
		return "";
	}

	var ext = trim_Cross(filePath.substr(lastIndexOfDot + 1, filePath.length).toLowerCase());

	if (ext === "ezd") {
		return getOriginalFileExtension(filePath.substr(0, lastIndexOfDot));
	}

	return ext;
}

function openAttachView(wfileLocation, wName, wWeigth, wHeigth) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;
        var left = 0;
        var top = 0;

        if (window.screen.width > 800) {
            var pleftpos;
            pleftpos = parseInt(width) - wWeigth;
            heigth = parseInt(heigth) - 30;
            width = parseInt(width) - pleftpos;
            left = (pleftpos / 2) + 30;
            top = 30;
        }
        else {
            heigth = parseInt(heigth) - 30;
            width = parseInt(width) - 10;
        }
        //2018-09-12 천성준 - 결재문서 문서보기 시, 첨부파일 중 hwp문서첨부를 열때 IE인지 검사하는 로직 추가
        if (wfileLocation.toLowerCase().indexOf(".hwp") > -1) {
        	if(useWebHWP == "NO") {
	        	if (isIE()) {
	        		window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
	        	} else {
	        		var pAlertContent = "한글양식은 IE에서만 볼 수 있습니다.";
	            	alert(pAlertContent);
	                return;
	        	}
        	} else {
        		window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
        	}
        } else {
        	window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
        }
    } catch (e) {
        alert("openAttachView :: " + e.description);
    }
}

// START
var ezapralert_cross_dialogArguments = new Array();
function OpenAttachAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN()) {
        ezapralert_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
        DivPopUpShow(330, 205, url);
    }
}
function OpenAlertUI_Complete() {
    DivPopUpHidden();
}
// END

/* 2020-11-18 홍승비 - 전자결재 첨부파일 모두선택 함수 */
function attach_SelectAll() {
	var attachChkBoxs = $("#lstAttachLink").find("input:checkbox");
	
	if (attachChkBoxs.length > 0) {
		attachChkBoxs.each(function() {
			this.checked = true;
		});
	}
}

/* 2020-11-18 홍승비 - 전자결재 첨부파일 다중 다운로드 함수 (체크한 파일이 2개 이상이라면 zip으로 다운로드) */
function attach_Download() {
    var checkedFiles = $("#lstAttachLink").find("input:checkbox[name='fileSelect']:checked");
    var checkedFilesLength = checkedFiles.length;
    var filePath = ""; // 전체파일경로
    var filePaths = ""; // 각 파일의 저장경로 (/fileroot/...)
	var fileNames = ""; // 파일이름
	
	if (checkedFilesLength == 1) { // 하나만 저장하는 경우
		checkedFiles.next()[0].click();
	}
	else if (checkedFilesLength > 1) { // 여러개는 zip으로 저장
		for (var i = 0; i < checkedFilesLength; i++) {
			filePaths += GetAttribute(checkedFiles.get(i), "filepath") + ":::"; // 각 파일의 상대경로 (/fileroot/.../....../파일명) + 구분자
			fileNames += GetAttribute(checkedFiles.get(i), "fileName") + ":::"; // 각 파일의 이름 + 구분자
		}
		
		var $frm = $("<form></form>");
    	$frm.attr("action", "/ezApprovalG/downloadAttachAll.do");
    	$frm.attr("method", "post");
    	$frm.appendTo("body");
    	
    	// 서버단의 HttpServletRequest가 이스케이프 문자를 해석하므로, 다시 한 번 인코딩을 진행하여 값을 전달 
    	param1 = $("<input type='hidden' value=\"" + MakeXMLString(filePaths) + "\" name='filePaths' />");
    	param2 = $("<input type='hidden' value=\"" + MakeXMLString(fileNames) + "\" name='fileNames' />");
    	
    	$frm.append(param1).append(param2);
    	$frm.submit();
	}
	else { // 체크된 파일 없음
		alert(strLangHSBAt12);
		return;
	}
}

function escapeHtml(text) {
    var map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        '"': '&#034;',
        "'": '&#039;'
    };

    return text.replace(/[&<>"']/g, function(m) { return map[m]; });
}

/**
 * 2023-04-20 홍승비 - 일괄기안 문서 전용 첨부파일 정보 추출 함수 분리 (자식 프레임 최초 로딩 시에만 동작, 화면단에 첨부파일 영역 그리는 로직 제거)
 * */
function setAttachInfoAll(tempDocID, INGFlag, attachTag) {
    attachTag.innerHTML = "";
    
    var docAttachTag = ""; // 문서첨부영역 분리
    var parentHasAttachAry = new Array(); // 부모창의 일반첨부여부 배열
    var parentHasDocAttachAry = new Array(); // 부모창의 문서첨부여부 배열
    
    // 부모창에서 받은 첨부파일 정보를 그대로 맵핑하는 함수이므로, 일괄기안 자식 프레임에서만 호출함 (currIdx 대신 frameNum 사용)
	attachTag = parent.document.getElementById(attachTag.id);
	docAttachTag = parent.document.getElementById(attachTag.id + "Doc");
	parentHasAttachAry = parent.pHasAttachYNAry;
	parentHasDocAttachAry = parent.pHasDocAttachYNAry;
    
	if (docAttachTag != undefined && docAttachTag != null) {
		docAttachTag.innerHTML = "";
	}
	
    var xmldom = createXmlDom();
    xmldom = loadXMLString(parent.pAttachInfoAry[frameNum]);
    
    var xmlRtn = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
    
    if (xmlRtn.length > 0) {
        for (i = 0; i < xmlRtn.length; i++) {
        	// 해당 함수는 일괄기안의 각 자식 프레임 최초 로딩 시에만 동작하므로, 화면단에 첨부파일 정보를 그리는 작업은 제외한다.
        	// 각 안 클릭(selTab) 시 화면단에 첨부파일 UI 그리는 작업은 기존 함수(setAttachInfo)가 담당함
        	
            // 일반 파일 첨부
            if (SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA4") == "File" || SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA4") == strLang1136) {
                // 일괄기안용 일반첨부 플래그 부여
                parentHasAttachAry[frameNum] = "Y";
            }
            // 문서첨부
            else {
                // 일괄기안용 문서첨부 플래그 부여
                parentHasDocAttachAry[frameNum] = "Y";
            }
        }
        try {
            pHasAttachYN = "Y";
        } catch (e) { console.log(e); }
    }
    else {
        try {
            pHasAttachYN = "N";
            
            // 일괄기안용 일반첨부, 문서첨부 플래그 부여
        	parentHasAttachAry[frameNum] = "N";
        	parentHasDocAttachAry[frameNum] = "N";
        } catch (e) { console.log(e); }
    }
}
