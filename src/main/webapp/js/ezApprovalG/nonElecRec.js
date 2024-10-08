/*
 * 2018-06-11 천성준
 * 비전자 문서 js 생성 
 */

var bSpecialFlag = "0";
var g_arrSCName = new Array();
var g_CodeInfoXml;
var g_RecTypeCode;
var g_CabID = "";
var g_TaskCode;
/*
 * 비전자문서 기본 이닛s
 * */
function nonElecRecInit() {
	InitCode();
	nonElecRecSusinInit();
	nonElecRecInfoInit();
}
/*
 * 등록구분 불러오는 메소드
 * */
function InitCode() {
    var result = "";
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getCodeList.do",
		data : {
			companyID : CompanyID
		},
		success: function(xml){
			result = loadXMLString(xml);
		}        			
	});
    
    g_CodeInfoXml = getXmlString(result);
    if (SelectSingleNodeValue(result, "RESULT") == "FALSE") {
        alert(strLang615);
    }
    else {
        var nodesRegType = SelectNodes(result, "CODELIST/REGISTERTYPE/CODE");
        InitCodeSelectBox(nodesRegType, selRegisterType);

        g_NodesRcdgAVType = SelectNodes(result, "CODELIST/RECORDINGAVTYPE/CODE");
        g_NodesPhotoAVType = SelectNodes(result, "CODELIST/PHOTOAVTYPE/CODE");
        
        document.getElementById("selRegisterType").selectedIndex = 1; // 일반문서 접수로 고정
        document.getElementById("selRegisterType").disabled = "disabled"; // 변경불가능
        
        selRegisterType_onchange();
    }
}
/*
 * 수신처를 직접 디비에 넣어서 불러오는 형식으로 만듬
 * */
function nonElecRecSusinInit() {
	if (pIniGubun == "1") {
		$.ajax({
	       type : "POST",
	       dataType : "text",
	       async : false,
	       url : "/ezApprovalG/nonElecRecSusinInit.do",
	       data : {
	               docID  : pDocID
	       }});
	}
}
/*
 * 등록구분에 따라 입력폼이 나타나고 없어지는 메소드
 * */
function selRegisterType_onchange() {
   var val = selRegisterType.value;

   if (val == "5" || val == "6") {
	   divAudioVisualDummy.style.display = "none";
	   divAudioVisual.style.display = "";
	   trDeliveryNo.style.display = "none";
	   trOriginSN.style.display = "none";
	   trAprMemberTitle.style.display = "";
	   g_VisualAudioFlag = "1";

	   if (val == 5) {
	       InitAVTypeTD(g_NodesPhotoAVType, tdAVType, "");
	   } else if (val == 6) {
		   InitAVTypeTD(g_NodesRcdgAVType, tdAVType, "");
	   }
   } else {
	   divAudioVisualDummy.style.display = "";
	   divAudioVisual.style.display = "none";
	   g_VisualAudioFlag = "0";

	   if (val == "1" || val == "3" || val == "5" || val == "6") {
		   trDeliveryNo.style.display = "none";
		   trOriginSN.style.display = "none";
		   trAprMemberTitle.style.display = "";
	   } else if (val == "2" || val == "4") {
		   //trDeliveryNo.style.display = ""; //2018-07-19 천성준 - 문서과배부번호 안보이게 주석처리
		   trOriginSN.style.display = "";
		   trAprMemberTitle.style.display = "none";
	   } else {
	       //trDeliveryNo.style.display = ""; //2018-07-19 천성준 - 문서과배부번호 안보이게 주석처리
		   trOriginSN.style.display = "";
		   trAprMemberTitle.style.display = "";
	   }
   }
}
/*
 * 입력한 기록물 정보 가져와서 XML로 만드는 작업
 * */
function getNonElecRecInfo() {
	var rtnXml = createXmlDom();
	var Root, objItem, objData;
	Root = createNodeInsert(rtnXml, Root, "NONELECRECINFO");
	objItem = createNodeAndAppandNode(rtnXml, Root, objItem, "NONELECREC");
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "DEPTCODE", arr_userinfo[4]);
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "DEPTNAME", arr_userinfo[15]);
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "DEPTNAME2", arr_userinfo[16]);
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "REGISTERTYPE", selRegisterType.value);
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "REGISTERDATE", GetRegisterDate()); // 등록일자
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "REGISTERYEAR", GetRegisterYear()); // 등록연도
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "TITLE", txtTitle.value);
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "APRMEMBERTITLE", txtAprMemberTitle.value);
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "APRMEMBERTITLE2", txtAprMemberTitle.value);
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "DRAFTERNAME", txtDrafter.value);
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "DRAFTERNAME2", txtDrafter.value);
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "EXECUTEDATE", GetExecuteDate()); // 시행일자
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "RECEIPTMEMBER", txtReceiptMember.value);
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "RECEIPTMEMBER2", txtReceiptMember.value);
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "SENDINGMEMBER", "");
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "DELIVERYNO", txtDeliveryNo.value); // 문서과 배부번호
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "ORIGINREGSN", txtOriginSN.value); // 생산기관 등록번호
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "ELECTRONICRECFLAG", GetElectronicRecFlag());
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETID", trim_Cross(g_CabID));
	
	// 시청각 기록물일 경우 추가정보 저장
	if (selRegisterType.value == "5" || selRegisterType.value == "6") {
		createNodeAndAppandNodeText(rtnXml, objItem, objData, "AUDIOVISUALRECINFO", GetAVTypeCode());
		createNodeAndAppandNodeText(rtnXml, objItem, objData, "SUMMARY",txtSummary.value);
	}
	
	// 분리첨부 있을 시 저장
	if (g_SepAttachLVXml != "") {
		var objSPXml = createXmlDom();
        	objSPXml = loadXMLString(g_SepAttachLVXml);
        	
		var Rows, Row, Value, node, i;
		var oRows = SelectNodes(objSPXml, "LISTVIEWDATA/ROWS/ROW");
		
		node = createNodeAndAppandNode(rtnXml, objItem, node, "SEPERATEATTACH");
	    if (oRows.length > 0) {
	    	Rows = createNodeAndAppandNode(rtnXml, node, Rows, "ROWS");
	        for (i = 0; i < oRows.length; i++) {
	        	Row = createNodeAndAppandNode(rtnXml, Rows, Row, "ROW");
	        	Value = createNodeAndAppandNodeText(rtnXml, Row, Value, "SEPNO", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[0])[0]));
	        	Value = createNodeAndAppandNodeText(rtnXml, Row, Value, "SEPREGTYPE", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[0])[2]));
	        	Value = createNodeAndAppandNodeText(rtnXml, Row, Value, "SEPTITLE", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[1])[0]));
	        	Value = createNodeAndAppandNodeText(rtnXml, Row, Value, "SEPNUMOFPAGE", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[4])[0]));
	        	
	        	// 분리첨부 시청각 기록물일경우 추가저장
	        	if (getNodeText(GetChildNodes(GetChildNodes(oRows[i])[0])[2]) == "5" || getNodeText(GetChildNodes(GetChildNodes(oRows[i])[0])[2]) == "6") {
	        		Value = createNodeAndAppandNodeText(rtnXml, Row, Value, "SEPRECORDTYPE", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[5])[0]));
	        		Value = createNodeAndAppandNodeText(rtnXml, Row, Value, "SEPSUMMARY", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[6])[0]));
	        	} else {
	        		Value = createNodeAndAppandNodeText(rtnXml, Row, Value, "SEPRECORDTYPE", "");
	        		Value = createNodeAndAppandNodeText(rtnXml, Row, Value, "SEPSUMMARY", "");
	        	}
	        	
	        	Value = createNodeAndAppandNodeText(rtnXml, Row, Value, "CABINETID", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[0])[1]));
	        }
	    }
	} else {
		createNodeAndAppandNodeText(rtnXml, objItem, objData, "SEPERATEATTACH", "");
	}
	
	// 특수목록 Flag (1=true 0=false)
	createNodeAndAppandNodeText(rtnXml, objItem, objData, "SPECIALCATALOGFLAG", bSpecialFlag);
	
	var objSI, objSC, objData,cataloginfo;
    objSI = createNodeAndAppandNode(rtnXml, objItem, objSI, "SPECIALCATALOGINFO");
    
    // 특수목록이 존재할경우
    if (bSpecialFlag == "1") {
    	cataloginfo = createNodeAndAppandNode(rtnXml, objSI, objSC, "SCNAME");
        objData = createNodeAndAppandNodeText(rtnXml, cataloginfo, objData, "LIST1", g_arrSCName[0]);
        objData = createNodeAndAppandNodeText(rtnXml, cataloginfo, objData, "LIST2", g_arrSCName[1]);
        objData = createNodeAndAppandNodeText(rtnXml, cataloginfo, objData, "LIST3", g_arrSCName[2]);
        
        if (g_szSCListXml != "") {
            var i;
            var objSCXml = createXmlDom();
            objSCXml = loadXMLString(g_szSCListXml);
            var oRows = SelectNodes(objSCXml, "LISTVIEWDATA/ROWS/ROW");
            if (oRows.length > 0) {
                for (i = 0; i < oRows.length; i++) {
                	objSC = createNodeAndAppandNode(rtnXml, objSI, objSC, "SCDATA");
                    var objSN = createNodeAndAppandNodeText(rtnXml, objSC, objSN, "SN", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[0])[0]));
                    if (GetChildNodes(oRows[i])[1])
                        createNodeAndAppandNodeText(rtnXml, objSC, objSN, "LIST1", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[1])[0]));
                    else
                        createNodeAndAppandNodeText(rtnXml, objSC, objSN, "LIST1", "");
                    if (GetChildNodes(oRows[i])[2])
                        createNodeAndAppandNodeText(rtnXml, objSC, objSN, "LIST2", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[2])[0]));
                    else
                        createNodeAndAppandNodeText(rtnXml, objSC, objSN, "LIST2", "");
                    if (GetChildNodes(oRows[i])[3])
                        createNodeAndAppandNodeText(rtnXml, objSC, objSN, "LIST3", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[3])[0]));
                    else
                        createNodeAndAppandNodeText(rtnXml, objSC, objSN, "LIST3", "");
                }
            }
        }
    }
		createNodeAndAppandNodeText(rtnXml, objItem, objData, "DOCATTACHNAME", filename.value);	
	
	return getXmlString(rtnXml);
}
/*
 * 결재정보를 나갔다 들어왔을때 다시 데이터를 세팅 해주는 메소드
 * */
function nonElecRecInfoInit() {
	var NonElecXML = createXmlDom();
	NonElecXML = loadXMLString(nonElecRecInfoXml);
	
	// 등록일자 초기값 삽입 (현재시각)
    var offset = new Date().getTimezoneOffset() * 60000;
    regDateTime = new Date(Date.now() - offset).toISOString();
    document.getElementById("regDate").value = regDateTime.substring(0, 10);
    document.getElementById("regTime").value = regDateTime.substring(11, 16);
	
	if (nonElecRecInfoXml == "") {
	    return;
	}
	
	if (SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") != "") {
		document.getElementById("selRegisterType").selectedIndex = SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") - 1;
	} else {
		document.getElementById("selRegisterType").selectedIndex = "0";
	}
	
	if (pIniGubun == "11" || pIniGubun == "6") {
		document.getElementById("selRegisterType").disabled = true;
	}
	
	document.getElementById("txtTitle").value = SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "TITLE");
	document.getElementById("txtAprMemberTitle").value = SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "APRMEMBERTITLE");
	document.getElementById("txtDrafter").value = SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DRAFTERNAME");
	document.getElementById("txtReceiptMember").value = SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "RECEIPTMEMBER");
	document.getElementById("txtDeliveryNo").value = SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DELIVERYNO"); // 문서과 배부번호
	document.getElementById("txtOriginSN").value = SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "ORIGINREGSN"); // 생산기관 등록번호
	document.getElementById("exeDate").value = SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "EXECUTEDATE"); // 시행일자
	
	// 등록일자
	if (SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERDATE") != "") {
	    var regDateTime = SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERDATE");
	    document.getElementById("regDate").value = regDateTime.substring(0, 10);
        document.getElementById("regTime").value = regDateTime.substring(11, 16);
	}
	
	selRegisterType_onchange();
	
	// 시청각 기록물일경우 추가정보 세팅
	if (SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") == "5" || SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "REGISTERTYPE") == "6") {
		document.getElementById("txtSummary").value = SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "SUMMARY");
		
		var audioArray = SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "AUDIOVISUALRECINFO").split(",");
		var colAVType = document.getElementsByName("chkAVType");
		
	    for (j = 0; j < audioArray.length; j++) {
	    	for (i = 0; i < colAVType.length; i++) {
	    		if (audioArray[j] == colAVType[i].value) {
	    			colAVType[i].checked = true;
	    			break;
	    		}
	    	}
	    }
	}
	
	if (SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DOCATTACHNAME").length > 0){
		document.getElementById("filename").value = SelectSingleNodeValue(NonElecXML.documentElement.childNodes[0], "DOCATTACHNAME");
	}
	
}
/*
 * .hwp 전용  ret값 받아서 결재양식에 데이터 뿌려주는 메소드
 * */
function setNonElecRecInfo(ret) {
	if (isIE()) {
		var objNodes, count;
		var title = "";
		var xmldom = new ActiveXObject("Microsoft.XMLDOM");
		xmldom.async = false;
		xmldom.loadXML(ret);
		
		if( xmldom.xml == "" ) return;
		if( xmldom.documentElement.childNodes.length == 0 ) return;
		
		if (HwpCtrl.CheckFieldExist("nonElecRec_RegType"))
			HwpCtrl.SetFieldText("nonElecRec_RegType", "");
		
		if (HwpCtrl.CheckFieldExist("nonElecRec_Title"))
			HwpCtrl.SetFieldText("nonElecRec_Title", "");
		
		if (HwpCtrl.CheckFieldExist("nonElecRec_RegDate"))
			HwpCtrl.SetFieldText("nonElecRec_RegDate", "");
		
		if (HwpCtrl.CheckFieldExist("nonElecRec_ExeDate"))
			HwpCtrl.SetFieldText("nonElecRec_ExeDate", "");
		
		if (HwpCtrl.CheckFieldExist("nonElecRec_SepAttachYN"))
			HwpCtrl.SetFieldText("nonElecRec_SepAttachYN", "");
		
		if (HwpCtrl.CheckFieldExist("doctitle"))
			HwpCtrl.SetFieldText("doctitle", "");
		
		if (HwpCtrl.CheckFieldExist("docnumber"))
			HwpCtrl.SetFieldText("docnumber", "");
		
		if (HwpCtrl.CheckFieldExist("nonElecRec_sendingDept"))
			HwpCtrl.SetFieldText("nonElecRec_sendingDept", "");
			
		objNodes = xmldom.selectNodes("NONELECRECINFO/NONELECREC");
		
		HwpCtrl.SetFieldText("nonElecRec_Title", getNodeText(objNodes.item(0).childNodes(6)));				//기록물제목
		HwpCtrl.SetFieldText("nonElecRec_RegDate", getNodeText(objNodes.item(0).childNodes(4)));			//등록일자
		HwpCtrl.SetFieldText("nonElecRec_ExeDate", getNodeText(objNodes.item(0).childNodes(11)));			//시행일자
		HwpCtrl.SetFieldText("nonElecRec_RegType", regTypePicker(getNodeText(objNodes.item(0).childNodes(3)))); //등록구분
		HwpCtrl.SetFieldText("doctitle", getNodeText(objNodes.item(0).childNodes(6)) + " " + title);		//문서제목
		HwpCtrl.SetFieldText("docnumber", getNodeText(objNodes.item(0).childNodes(16)));			//문서번호
		HwpCtrl.SetFieldText("nonElecRec_sendingDept", getNodeText(objNodes.item(0).childNodes(12)));		//발신기관
		
		//분리첨부 건수
		objNodes = xmldom.selectNodes("NONELECRECINFO/NONELECREC/SEPERATEATTACH/ROWS/ROW");
		count = objNodes.length;
		if (count > 0) {
			HwpCtrl.SetFieldText("nonElecRec_SepAttachYN", count + " 건");
		} else {
			HwpCtrl.SetFieldText("nonElecRec_SepAttachYN", "X");
		}
	} else {
		return
	}
}

// 웹한글기안기 전용
function setNonElecRecInfo_whwp(ret) {
	var objNodes, count;
	var title = "";
	var xmldom = createXmlDom();
	xmldom.async = false;
	xmldom = loadXMLString(ret);
	
	if( xmldom.xml == "" ) return;
	if( xmldom.documentElement.childNodes.length == 0 ) return;
	
	if (message.FieldExist("nonElecRec_RegType"))
		message.PutFieldText("nonElecRec_RegType", "");
	
	if (message.FieldExist("nonElecRec_Title"))
		message.PutFieldText("nonElecRec_Title", "");
	
	if (message.FieldExist("nonElecRec_RegDate"))
		message.PutFieldText("nonElecRec_RegDate", "");
	
	if (message.FieldExist("nonElecRec_ExeDate"))
		message.PutFieldText("nonElecRec_ExeDate", "");
	
	if (message.FieldExist("nonElecRec_SepAttachYN"))
		message.PutFieldText("nonElecRec_SepAttachYN", "");
	
	if (message.FieldExist("doctitle"))
		message.PutFieldText("doctitle", "");
	
	if (message.FieldExist("docnumber"))
		message.PutFieldText("docnumber", "");
	
	if (message.FieldExist("nonElecRec_sendingDept"))
		message.PutFieldText("nonElecRec_sendingDept", "");
		
	objNodes = SelectNodes(xmldom, "NONELECRECINFO/NONELECREC");
	
	message.PutFieldText("nonElecRec_Title", getNodeText(objNodes[0].childNodes[6]));				//기록물제목
	message.PutFieldText("nonElecRec_RegDate", getNodeText(objNodes[0].childNodes[4]));			//등록일자
	message.PutFieldText("nonElecRec_ExeDate", getNodeText(objNodes[0].childNodes[11]));			//시행일자
	message.PutFieldText("nonElecRec_RegType", regTypePicker(getNodeText(objNodes[0].childNodes[3]))); //등록구분
	message.PutFieldText("doctitle", getNodeText(objNodes[0].childNodes[6]) + " " + title);		//문서제목
	message.PutFieldText("docnumber", getNodeText(objNodes[0].childNodes[16]));			//문서번호
	message.PutFieldText("nonElecRec_sendingDept", getNodeText(objNodes[0].childNodes[12]));		//발신기관
	
	//분리첨부 건수
	objNodes = SelectNodes(xmldom, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/ROWS/ROW");
	count = objNodes.length;
	if (count > 0) {
		message.PutFieldText("nonElecRec_SepAttachYN", count + " 건");
	} else {
		message.PutFieldText("nonElecRec_SepAttachYN", "X");
	}
}

// MHT양식 비전자문서 전용
function setNonElecRecInfo_mht(ret) {
	var objNodes;
	var objNodesSep;
	var count;
	var title = "";
	var xmldom = createXmlDom();
	xmldom.async = false;
	xmldom = loadXMLString(ret);
	
	if( xmldom.xml == "" ) return;
	if( xmldom.documentElement.childNodes.length == 0 ) return;
	
	objNodes = SelectNodes(xmldom, "NONELECRECINFO/NONELECREC");
	var fields = message.GetFieldsList();
	
	field = message.GetListItem(fields, "nonElecRec_RegType"); // 등록구분
     if (field) {
         setNodeText(field, regTypePicker(getNodeText(objNodes[0].childNodes[3])));
     }
     
     field = message.GetListItem(fields, "nonElecRec_Title"); // 기록물제목
     if (field) {
    	 setNodeText(field, getNodeText(objNodes[0].childNodes[6]));
     }
     
     field = message.GetListItem(fields, "nonElecRec_RegDate"); // 등록일자
     if (field) {
    	 setNodeText(field, getNodeText(objNodes[0].childNodes[4]));
     }
     
     field = message.GetListItem(fields, "nonElecRec_ExeDate"); // 시행일자
     if (field) {
    	 setNodeText(field, getNodeText(objNodes[0].childNodes[11]));
     }
     
     field = message.GetListItem(fields, "nonElecRec_SepAttachYN"); // 분리첨부 건수
     if (field) {
    	 objNodesSep = SelectNodes(xmldom, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/ROWS/ROW");
    	 count = objNodesSep.length;
    	 if (count > 0) {
    		 	setNodeText(field, count + " 건");
    	 } else {
    		 	setNodeText(field, "X");
    	 }
     }
     
     field = message.GetListItem(fields, "doctitle"); // 문서제목
     if (field) {
    	 setNodeText(field, getNodeText(objNodes[0].childNodes[6]) + " " + title);
     }
     
     field = message.GetListItem(fields, "docnumber"); // 문서번호
     if (field) {
    	 setNodeText(field,  getNodeText(objNodes[0].childNodes[16]));
     }
     
     field = message.GetListItem(fields, "nonElecRec_sendingDept"); // 발신기관
     if (field) {
    	 setNodeText(field, getNodeText(objNodes[0].childNodes[12]));
     }
}

/*
 * 등록 타입에 맞게 데이터 맵핑
 * */
function regTypePicker(regType) {	
	var rtnVal = "";
	
	switch(regType) {
	case "1" :
		rtnVal = "일반문서 생산/발송";
		break;
	case "2" :
		rtnVal = "일반문서 접수";
		break;
	case "3" :
		rtnVal = "도면류 생산/발송";
		break;
	case "4" :
		rtnVal = "도면류 접수";
		break;
	case "5" :
		rtnVal = "사진/필름류";
		break;
	case "6" :
		rtnVal = "녹음/동영상류";
		break;
	case "7" :
		rtnVal = "카드류 생산/발송";
		break;
	case "8" :
		rtnVal = "카드류 이첩발송";
		break;
	}
	
	return rtnVal;
}

/*
 * 비전자문서 결재양식 문서보기 시, 호출됨 (return : 비전자 기록물 정보 xml)
 * */
function getNonElecInfoSusinInit() {
	try {
    	var result = "";
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getNonElecInfoSusinInit.do",
    		data : {
    			docID : pOrgDocID
    		},
    		success: function(xml){
    			result = loadXMLString(xml.replace(/null/gi,""));
    		}        			
    	});
        
        getNonElecInfoSusinInit_complete(result);
        
	} catch (e) {
		alert("getNonElecInfoSusin() :: " + e.description);
	}
}

/*
 * 기록물정보xml, 분리첨부xml 가공
 * */
function getNonElecInfoSusinInit_complete(result) {
	nonElecRecInfoXml = getXmlString(result); // 기록물정보 xml
	
	var InfoXml = loadXMLString(GetLVHearderXml());
	var Rows = InfoXml.childNodes[0].childNodes[1];
	var selRow, Row, Cell, Value, Data, node, i;
	var oRows = SelectNodes(result, "NONELECRECINFO/NONELECREC/SEPERATEATTACH/ROWS/ROW");
	
    if (oRows.length > 0) {
        for (i = 0; i < oRows.length; i++) {
        	Row = createNodeAndAppandNode(InfoXml, Rows, Row, "ROW");
        	Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
        	node = createNodeAndAppandNodeText(InfoXml, Cell, node, "VALUE", SelectSingleNodeValue(oRows[i], "SEPNO"));
        	
        	createNodeAndAppandNodeText(InfoXml, Cell, node, "DATA1", SelectSingleNodeValue(oRows[i], "SEPCABINETID"));
        	createNodeAndAppandNodeText(InfoXml, Cell, node, "DATA2", SelectSingleNodeValue(oRows[i], "SEPREGTYPE"));
        	createNodeAndAppandNodeText(InfoXml, Cell, node, "DATA3", SelectSingleNodeValue(oRows[i], "SEPRECORDTYPE"));
        	
        	Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
        	createNodeAndAppandNodeText(InfoXml, Cell, node, "VALUE", SelectSingleNodeValue(oRows[i], "SEPTITLE"));
        	Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
    		createNodeAndAppandNodeText(InfoXml, Cell, node, "VALUE", getCabTitle(SelectSingleNodeValue(oRows[i], "SEPCABINETID")));
        	Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
        	createNodeAndAppandNodeText(InfoXml, Cell, node, "VALUE", regTypePicker(SelectSingleNodeValue(oRows[i], "SEPREGTYPE")));
        	Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
        	createNodeAndAppandNodeText(InfoXml, Cell, node, "VALUE", SelectSingleNodeValue(oRows[i], "SEPNUMOFPAGE"));
        	Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
        	createNodeAndAppandNodeText(InfoXml, Cell, node, "VALUE", SelectSingleNodeValue(oRows[i], "SEPRECORDTYPE"));
        	Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
        	createNodeAndAppandNodeText(InfoXml, Cell, node, "VALUE", SelectSingleNodeValue(oRows[i], "SEPSUMMARY"));
        }
        nonSepAttachLVXml = getXmlString(InfoXml); // 분리첨부 xml
    }
}
/*
 * 분리첨부 전용 헤더 세팅 메소드
 * */
function GetLVHearderXml() {
    var oList, ListViewData, Headers, Header, HName, HWidth, Rows, node;

    oList = createXmlDom();
    ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA"); 	

    Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
    createNodeAndAppandNodeText(oList, Header, node, "NAME", "순번");
    createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "40");

    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
    createNodeAndAppandNodeText(oList, Header, node, "NAME", "제목");
    createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "200");

    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
    createNodeAndAppandNodeText(oList, Header, node, "NAME", "기록물철명");
    createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "150");

    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");    
    createNodeAndAppandNodeText(oList, Header, node, "NAME", "등록구분");
    createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "120");

    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
    createNodeAndAppandNodeText(oList, Header, node, "NAME", "쪽수");
    createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "40");

    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
    createNodeAndAppandNodeText(oList, Header, node, "NAME", "시청각기록물 형태");
    createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "120");

    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
    createNodeAndAppandNodeText(oList, Header, node, "NAME", "시청각기록물 내용요약");
    createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "200");

    Rows = createNodeAndAppandNode(oList, ListViewData, Rows, "ROWS");

    return getXmlString(oList);
}
/*
 * 특수목록 전용 헤더 세팅 메소드
 * */
function GetSCHearderXml() {
	var oList, ListViewData, Headers, Header, HName, HWidth, Rows, node;

    oList = createXmlDom();
    ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA"); 	

    Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
    Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
    createNodeAndAppandNodeText(oList, Header, node, "NAME", "순번");
    createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "30");
    
    for (i = 0; i < g_arrSCName.length; i++) {
    	Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
    	createNodeAndAppandNodeText(oList, Header, node, "NAME", g_arrSCName[i]);
    	createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "120");
    }

    Rows = createNodeAndAppandNode(oList, ListViewData, Rows, "ROWS");
    
    return getXmlString(oList);
}
/*
 * 캐비넷 아이디 세팅
 * */
function setCabInfoInit() {
	var List = new ListView();
	List.LoadFromID("DivTaskSCateList");
	var MyList = new ListView();
	MyList.LoadFromID("DivMyTaskSCateList");
	
	var totalRows = List.GetSelectedRows();
	var MyRows = MyList.GetSelectedRows();
	
	if (MyRows.length > 0) {
		rtnValue = GetAttribute(MyRows[0], "DATA1");
		g_CabID = rtnValue;
	} else if (totalRows.length > 0) {
		rtnValue = GetAttribute(totalRows[0], "DATA1");
		g_CabID = rtnValue;
	}
	
	if (g_CabID != "" && g_CabID != "nonElecRecTempCabinet" && g_CabID != "null") {
		var CabXml = GetCabinetClassInfo(g_CabID);
		
		if (pIniGubun == "6") {
			setCabInfo(CabXml);
	    }
	    
	    InitCabClassInfo2(CabXml);
	    //InitRegisterType();
	    InitSCInputBox();
	    InitSCListXML();
	} else {
		g_SepAttachLVXml = g_SepAttachLVXml.replace(/nonElecRecTempCabinetName/gi, "").replace(/nonElecRecTempCabinet/gi, "");
	}

	if (doctitle != null) {
		document.getElementById("txtTitle").value = doctitle;
	}
}
/*
 * 비전자문서 임시 캐비넷 아이디 -> 선택 캐비넷 아이디 변경 메소드
 * */
function nonElecRecTempCabSwitch(nonElecRecInfoXml) {
	if (pGubun == "11") {
		try {
		$.ajax({
	       type : "POST",
	       dataType : "text",
	       async : false,
	       url : "/ezApprovalG/nonElecRecTempCabSwitch.do",
	       data : {
	             docID  : pDocID,
	             orgDocID : pOrg_orgDocID,
	             xml : nonElecRecInfoXml
	       }});
		} catch(e) {
			alert("nonElecRecTempCabSwitch() error! " + e.description);
		}
	}
}
/*
 * 캐비넷 xml에서 각 정보들 불러와서 세팅해주는 메소드
 * */
function setCabInfo(CabXml) {
	if (CabXml != "" && CabXml != null && g_CabID != "") {
		/* 철이름 */
		tdCabinetName.innerHTML =  SelectSingleNodeValue(CabXml.documentElement, "TITLE");
		/* 형태 */
		tdCabinetType.innerHTML = SelectSingleNodeValue(CabXml.documentElement, "CABCLASSNO");
		/* 연번 */
		tdCabinetSN.innerHTML = SelectSingleNodeValue(CabXml.documentElement, "REGSN");
		/* 권호수 */
		tdCabinetVolNo.innerHTML = SelectSingleNodeValue(CabXml.documentElement, "DISPCABCLASSNO").split("(")[1].substring(0,3);
		
		g_SepAttachLVXml = g_SepAttachLVXml.replace(/nonElecRecTempCabinetName/gi, "");
	}
}

function getCabTitle(CabID) {
	var rtnVal = "";
	
	var CabXml = GetCabinetClassInfo(CabID);
	if (CabXml != "" && CabXml != null) {
		rtnVal = SelectSingleNodeValue(CabXml.documentElement, "TITLE");
	}
	
	return rtnVal;
}

function GetCabinetClassInfo(pCabID) {
    var result = "";
    
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getCabinetInfo.do",
		data : {
			cabinetID : pCabID,
			companyID : companyID,
			strType   : 1
		},
		success: function(xml){
			result = xml;
			
			var dataNodes = GetChildNodes(loadXMLString(result));
		    var rtnXml = getNodeText(dataNodes[0]);

		    if (rtnXml == "FALSE") {
		        alert(strLang483);
		    }
		},
		error : function() {
			alert(strLang483);
		}
	});
    
    return loadXMLString(result);
}

var g_szSCListXml = "";
var AddSpecialCatalog_Cross_dialogArguments = new Array();
function btnAddSpecialCatalog_onclick() {
    var para = new Array();
    para[0] = g_szSCListXml;
    para[1] = g_arrSCName[0];
    para[2] = g_arrSCName[1];
    para[3] = g_arrSCName[2];
    var url = "/ezApprovalG/insSpecialList.do";
    var rtn;
    AddSpecialCatalog_Cross_dialogArguments[0] = para;
    AddSpecialCatalog_Cross_dialogArguments[1] = btnAddSpecialCatalog_onclick_Complete;
    var OpenWin;
    
        OpenWin = window.open(url, "AddSpecialCatalog_Cross", GetOpenWindowfeature(500, 435));

    try { OpenWin.focus(); } catch (e) { }
}

function btnAddSpecialCatalog_onclick_Complete(rtn) {
	   DivPopUpHidden();
	   if (rtn[0] == "TRUE") {
	        g_szSCListXml = rtn[1];
	    }
}
/*
 * 특수목록 전용 xml 가공 메소드
 * */
function InitSCListXML() {
	var NonElecXML = createXmlDom();
	NonElecXML = loadXMLString(nonElecRecInfoXml);
	
	var InfoXml = loadXMLString(GetSCHearderXml());
	var Rows = InfoXml.childNodes[0].childNodes[1];
	var selRow, Row, Cell, Value, Data, node, i;
	var oRows = SelectNodes(NonElecXML, "NONELECRECINFO/NONELECREC/SPECIALCATALOGINFO/ROWS/ROW");
	
    if (oRows.length > 0) {
        for (i = 1; i < oRows.length; i++) {
        	Row = createNodeAndAppandNode(InfoXml, Rows, Row, "ROW");
        	Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
        	node = createNodeAndAppandNodeText(InfoXml, Cell, node, "VALUE", SelectSingleNodeValue(oRows[i], "SERIALNO").trim());
        	Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
        	node = createNodeAndAppandNodeText(InfoXml, Cell, node, "VALUE", SelectSingleNodeValue(oRows[i], "SC1"));
        	Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
        	node = createNodeAndAppandNodeText(InfoXml, Cell, node, "VALUE", SelectSingleNodeValue(oRows[i], "SC2"));
        	Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
        	node = createNodeAndAppandNodeText(InfoXml, Cell, node, "VALUE", SelectSingleNodeValue(oRows[i], "SC3"));
        }
        
        g_szSCListXml = getXmlString(InfoXml); // 특수목록 xml
    }
}

function InitCabClassInfo2(objCabInfoXml) {
	bSpecialFlag = objCabInfoXml.getElementsByTagName("SCFLAG")[0].textContent;
    if (bSpecialFlag == "1")
    {
        tdSpecialFlag.innerHTML = "Y";
//        InitSCInfo_Mod(SelectSingleNodeNew(objCabInfoXml, "RESULT/SCINFO"));
    }
    else {
        tdSpecialFlag.innerHTML = "N";
        btnAddSC.style.display = "none";
    }
    
    g_RecTypeCode = objCabInfoXml.getElementsByTagName("RECTYPE")[0].textContent;
    g_arrSCName[0] = objCabInfoXml.getElementsByTagName("LIST1")[0].textContent;
    g_arrSCName[1] = objCabInfoXml.getElementsByTagName("LIST2")[0].textContent;
    g_arrSCName[2] = objCabInfoXml.getElementsByTagName("LIST3")[0].textContent;
  
}

function InitSCInputBox() {
    if (bSpecialFlag == "1")
    {
        btnAddSC.style.display = "";
        tdSpecialFlag.innerHTML = strLang652;
    }
    else {
        btnAddSC.style.display = "none";
        tdSpecialFlag.innerHTML = strLang622;
    }
}

// 일단 이쪽부턴 사용안하지만 필요할것 같아서 놔둠 ↓↓↓↓↓↓↓↓
/*function InitCabinetInfo(g_CabListXml) {
    var CabXml = createXmlDom();
    CabXml = loadXMLString(g_CabListXml);
 
    g_CabID = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "CABINETID");
    g_TaskCode = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "TASKCODE");
    tdCabinetName.innerHTML = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "CABINETNAME");
    tdCabinetSN.innerHTML = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "CABINETSN");
    tdCabinetType.innerHTML = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "RECTYPE");
    tdCabinetVolNo.innerHTML = SelectSingleNodeValue(CabXml.documentElement.childNodes[0], "CABINETVOLNO");
    
    InitCabClassInfo(GetCabinetClassInfo(g_CabID));
    InitRegisterType();
    InitSCInputBox();
}

function InitRegisterType() {
    selRegisterType.innerHTML = "";

    var RegTypeCodeXml = createXmlDom();
    var Root, objNode;
    var objCodeInfo = createXmlDom();
    objCodeInfo = loadXMLString(g_CodeInfoXml);
    Root = createNodeInsert(RegTypeCodeXml, Root, "REGISTERTYPE");
    
    switch (g_RecTypeCode) {
 
        case "1":

            if (ListTypeFlag == "10") {
            	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[1]);
            }
            else if (ListTypeFlag == "11") {
            	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[0]);
            }
            else {
                
        	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[0]);
        	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[0]);
            }
            break;

        case "2":
            if (ListTypeFlag == "10") {
            	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[3]);
            }
            else if (ListTypeFlag == "11") {
            	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[2]);;
            }
            else {
        	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[2]);
        	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[2]);
            }
            break;

        case "3":
        	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[4]);
            break;

        case "4":
        	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[5]);
            break;

        case "5":

            if (ListTypeFlag == "10" || ListTypeFlag == "0") {
            	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[6]);
            }

            if (ListTypeFlag == "11" || ListTypeFlag == "0") {
            	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[6]);
            } else {
        	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[6]);
        	Root.appendChild(objCodeInfo.getElementsByTagName("REGISTERTYPE")[0].childNodes[6]);
            }
            break;
    }
    InitCodeSelectBox(RegTypeCodeXml.documentElement.childNodes, selRegisterType);

    selRegisterType_onchange();
}

function RegisterRecord() {
    var pRegType = selRegisterType.value;

    var xmlpara = createXmlDom();   

    var objRoot = createNodeInsert(xmlpara, objRoot, "DATA");   
    
    var objNode, catalognode, cataloginfo, objSC, objSCNode;
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "MANUALFLAG", "1");
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DEPTCODE", arr_userinfo[4]);   
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DEPTNAME", arr_userinfo[15]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DEPTNAME2", arr_userinfo[16]);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "REGISTERTYPE", selRegisterType.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "REGISTERDATE", GetRegisterDate());
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "REGISTERYEAR", GetRegisterYear());
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "TITLE", txtTitle.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "NUMOFPAGE", txtTotalPage.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "APRMEMBERTITLE", txtAprMemberTitle.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "APRMEMBERTITLE2", txtAprMemberTitle.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DRAFTERNAME", txtDrafter.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DRAFTERNAME2", txtDrafter.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "EXECUTEDATE", GetExecuteDate());
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "RECEIPTMEMBER", txtReceiptMember.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "RECEIPTMEMBER2", txtReceiptMember.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "SENDINGMEMBER", "");
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DELIVERYNO", txtDeliveryNo.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "ORIGINREGSN", txtOriginSN.value);
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "ELECTRONICRECFLAG", GetElectronicRecFlag());
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "CABINETID", trim_Cross(g_CabID));
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "SPECIALREC", GetSpecialRecInfo());
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "PUBLICCODE", GetPublicCode());
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "LIMITRANGE", txtLimitRange.value);
    if (ListTypeFlag == "1") {
        if (pRegType == "2" || pRegType == "4")
        {
            objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DOCTYPE", "2");
        }
        else if (pRegType == "8")
        {
            objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DOCTYPE", "1");
        }
        else {
		    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DOCTYPE", "0");
        }
    }
    else if (ListTypeFlag == "10") {
        objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DOCTYPE", "2");
    }
    else if (ListTypeFlag == "11") {
        objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DOCTYPE", "1");
    }

    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "SPECIALCATALOGFLAG", bSpecialFlag);

    if (pRegType == "5" || pRegType == "6")
    {
        objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "VISUALAUDIOFLAG", g_VisualAudioFlag);
        objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "VISUALAUDIODESC", txtSummary.value);
        objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "VISUALAUDIOTYPE", GetAVTypeCode());
    }

    var objSI, objSC, objData,cataloginfo;
    objSI = createNodeAndAppandNode(xmlpara, objRoot, objSI, "SPECIALCATALOGINFO");
    if (bSpecialFlag == "1")
    {
    	cataloginfo = createNodeAndAppandNode(xmlpara, objSI, objSC, "SCNAME");
        objData = createNodeAndAppandNodeText(xmlpara, cataloginfo, objData, "LIST1", g_arrSCName[0]);
        objData = createNodeAndAppandNodeText(xmlpara, cataloginfo, objData, "LIST2", g_arrSCName[1]);
        objData = createNodeAndAppandNodeText(xmlpara, cataloginfo, objData, "LIST3", g_arrSCName[2]);
        if (g_szSCListXml != "")
        {
            var i;
            var objSCXml = createXmlDom();
            objSCXml = loadXMLString(g_szSCListXml);
            var oRows = SelectNodes(objSCXml, "LISTVIEWDATA/ROWS/ROW");
            if (oRows.length > 0) {
                for (i = 0; i < oRows.length; i++) {
                	objSC = createNodeAndAppandNode(xmlpara, objSI, objSC, "SCDATA");
                    var objSN = createNodeAndAppandNodeText(xmlpara, objSC, objSN, "SN", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[0])[0]));
                    if (GetChildNodes(oRows[i])[1])
                        createNodeAndAppandNodeText(xmlpara, objSC, objSN, "LIST1", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[1])[0]));
                    else
                        createNodeAndAppandNodeText(xmlpara, objSC, objSN, "LIST1", "");
                    if (GetChildNodes(oRows[i])[2])
                        createNodeAndAppandNodeText(xmlpara, objSC, objSN, "LIST2", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[2])[0]));
                    else
                        createNodeAndAppandNodeText(xmlpara, objSC, objSN, "LIST2", "");
                    if (GetChildNodes(oRows[i])[3])
                        createNodeAndAppandNodeText(xmlpara, objSC, objSN, "LIST3", getNodeText(GetChildNodes(GetChildNodes(oRows[i])[3])[0]));
                    else
                        createNodeAndAppandNodeText(xmlpara, objSC, objSN, "LIST3", "");
        }
    }
        }
    }
    var SepXml = GetSepAttParamXml();
    xmlpara.documentElement.appendChild(SepXml.documentElement);

    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "COMPANYID", CompanyID);   
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "DOCID", pDocID);   
    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "LANGTYPE", UserLang); 
    
    var AttachFlag = '0';
    if (document.all.lstAttachLink.innerHTML != "")
        AttachFlag = '1';

    objNode = createNodeAndAppandNodeText(xmlpara, objRoot, objNode, "ATTACHFLAG", AttachFlag);

    xmlhttp.open("POST", "/ezApprovalG/registerRecord.do", false);
    xmlhttp.send(xmlpara);

    var rtnXml = xmlhttp.responseXML;
    if (xmlhttp != null && xmlhttp.readyState == 4) {
		if (xmlhttp.status == 200 && getNodeText(GetChildNodes(rtnXml)[0]) == "TRUE") {
			return true;
		} else {
			alert(strLang677);
            return false;
		}
	}
}
var selectcabinet_cross_dialogArguments = new Array();
function btnChangeCabinet_onclick() {
    var para = new Array();
    para[0] = g_CabID;
    var url = "/ezApprovalG/selectCabinet.do?initFlag=1";

    selectcabinet_cross_dialogArguments[0] = para;
    selectcabinet_cross_dialogArguments[1] = btnChangeCabinet_onclick_Complete;

    DivPopUpShow(975, 500, url);

}

function btnChangeCabinet_onclick_Complete(rtn) {
    DivPopUpHidden();
    if (rtn[0] == "TRUE") {
        g_CabListXml = rtn[1];
        InitCabinetInfo(g_CabListXml);
    }
}*/
// 이쪽까지 사용 안함 ↑↑↑↑↑

// 이쪽은 사용 함 ↓↓↓↓↓↓↓
function InitAVTypeTD(nodeXml, objTD1, objTD2) {
    var szHtm1 = "";
    var szHtm2 = "";
    var i;
    szHtm1 = "<div style=\"width:100%;height:90px;overflow:auto;\">";

    for (i = 0; i < nodeXml.length; i++) {
        if (i % 2 == 0) {
            szHtm1 += "<input type='checkbox' name='chkAVType' id='chkAVType' style=\"height:13px;width:13px;padding:0px;margin:0px;vertical-align:top;\" value='" +

                    getNodeText(GetChildNodes(nodeXml[i])[0]) + "'><span>&nbsp;" +
					getNodeText(GetChildNodes(nodeXml[i])[1]) + "</span><br>";
        }
        else {
            szHtm2 += "<input type='checkbox' name='chkAVType' id='chkAVType' style=\"height:13px;width:13px;padding:0px;margin:0px;vertical-align:top;\" value='" +
                    getNodeText(GetChildNodes(nodeXml[i])[0]) + "'><span>&nbsp;" +
					getNodeText(GetChildNodes(nodeXml[i])[1]) + "</span><br>";
        }
    }
    objTD1.innerHTML = szHtm1 + szHtm2 + "</div>";
}

function GetAVTypeCode() {
    var colAVType = document.getElementsByName("chkAVType");
    var rtnStr = "";
    for (i = 0; i < colAVType.length; i++) {
        if (colAVType[i].checked) {
            if (rtnStr == "")
                rtnStr += colAVType[i].value;
            else
                rtnStr += "," + colAVType[i].value;
        }
    }
    return rtnStr;
}

function GetRegisterDate() {
    if (regDate.value != "" && regTime.value != "") {
        return regDate.value + " " + regTime.value;
    } else {
        return "";
    }
}

function GetRegisterYear() {
    if (regDate.value != "")
        return regDate.value.substring(0, 4);
    else
        return "";
}

function GetExecuteDate() {
    if (exeDate.value != "") {
        return exeDate.value;
    } else {
        return "";
    }
}

function GetElectronicRecFlag() {
    if (document.getElementsByName("rdoElectronicFlag")[0].checked)
        return "1";
    else if (document.getElementsByName("rdoElectronicFlag")[1].checked)
        return "2";
}

function RemoveEndNonElecRecDoc(DocID) {
	$.ajax({
       type : "POST",
       dataType : "text",
       async : false,
       url : "/ezApprovalG/setNonElecRecDocDel.do",
       data : {
               docID  : DocID
       }});
}

function RemoveSusinNonElecRecDoc(DocID) {
	$.ajax({
       type : "POST",
       dataType : "text",
       async : false,
       url : "/ezApprovalG/susinNonElecRecDocDel.do",
       data : {
               docID  : DocID
       },
		success: function(result) {
			if (result == "TRUE") {
				alert("삭제되었습니다.");
				window.close();
			} else if (result == "FALSE") {
				alert("삭제 실패했습니다.");
				return;
			}
		},
		error : function() {
			alert("삭제 중 에러가 발생했습니다.");
			return;
		}
	});
}

function checkNonElecRec(orgDocID) {
	var rtnVal;
	$.ajax({
	       type : "POST",
	       dataType : "text",
	       async : false,
	       url : "/ezApprovalG/checkNonElecRec.do",
	       data : {
	    	   orgDocID  : orgDocID
	       },
	       success: function(result) {
	    	   if (result == "TRUE") {
	    		   rtnVal = true;
	    	   } else {
	    		   rtnVal = false;
	    	   }
	       },
	       error: function() {
	    	   alert("checkNonElecRec Error!!");
	    	   rtnVal = false;
	       }
	});
	
	return rtnVal;
}

