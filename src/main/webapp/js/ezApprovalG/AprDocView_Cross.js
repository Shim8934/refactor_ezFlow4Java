var apropinion_cross_dialogArguments = new Array();
function openOpinionViewUI() {
    var parameter = new Array();
    parameter[0] = pDocID;
    parameter[1] = pOpinionType;    
    parameter[2] = "";
    parameter[3] = "";
    parameter[6] = pDocState;
    //양식 확장자 가져오는 값 전송. 중간에 값 껴들수 있어서 그냥 99로 생성
    parameter[99] = ext;
    
    apropinion_cross_dialogArguments[0] = parameter;
    apropinion_cross_dialogArguments[1] = openOpinionViewUI_Complete;

    DivPopUpShow(530, 520, "/ezApprovalG/aprOpinion.do");
}

function openOpinionViewUI_Complete() {
    DivPopUpHidden();
}

function openOpinionUI_New(pOpinionType, CompleteFunction) {
	try {
		var parameter = new Array();
		parameter[0] = pDocID;		//DOCID
		parameter[1] = pOpinionType;//OPINIONTYPE NAME
		parameter[2] = "";			//DRAFTFLAG 
		parameter[3] = pDocState;	//DOCSTATE
		parameter[4] = orgCompanyID;//ORGCOMPANYID
		parameter[99] = ext;		//EXT
		
		apropinion_cross_dialogArguments[0] = parameter;
		if (typeof(CompleteFunction) != "undefined") {
			apropinion_cross_dialogArguments[1] = CompleteFunction; 
		} else {
			apropinion_cross_dialogArguments[1] = openOpinionUI_New_Complete;
		}
		
		DivPopUpShow(530, 520, "/ezApprovalG/aprOpinionNew.do");
	} catch (e) {
		alert("openOpinionUI_New ::: " + e.description);
	}
}
function openOpinionUI_New_Complete(ret) {
	try {
		DivPopUpHidden();
	} catch (e) {
		alert("openOpinionUI_New_Complete ::: " + e.description);
	}
}

//Form Processor 문서정보를 Load하는 함수
function LoadpzFormDocInfo() {
    flag = true;

    pDocID = DocID;
    pDocHref = DocHref;
    pOpinionFlag = OpinionFlag;

    pListTypeValue = ListTypeValue;

    if (pListTypeValue == "4" || pListTypeValue == "97")
        pListSusin = ListSusin;

    if (pDocHref != "") {
        message.Set_EditorContentURL(pDocHref);
        if (pMode == "TMP") {
          	setAttachInfo(DocID, "TMP", lstAttachLink); // 임시 저장 첨부파일 리스트 출력
        } else {
        	setAttachInfo(pDocID, "APR", lstAttachLink);
        }               
        GetExchInfo();

        if (pHasOpinion == "Y") {
            var pInformationContent = strLang837 + "<br> " + strLang838;
            var Ans = OpenInformationUI(pInformationContent, LoadpzFormDocInfo_Complete);
        }
    }
}

function LoadpzFormDocInfo_Complete(Ans) {
    DivPopUpHidden();
    if (Ans) {
        //openOpinionViewUI();
    	if (ListTypeValue == "99") { // 회람수신함 및 공람할문서의 경우, 문서보기 페이지에서도 의견 작성 가능
	        openOpinionUI_New("");
        } else {
        	openOpinionUI_New("Show");
        }
    }
}

var ezapralert_cross_dialogArguments = new Array();
function OpenAlertUI(pAlertContent, CompleteFunction) {
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
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
}

function OpenAlertUI_Complete() {
    DivPopUpHidden();
}


var ezapropinion_cross_dialogArguments = new Array();
function OpenInformationUI(pInformationContent, CompleteFunction) {
    var parameter = pInformationContent;
    var url = "/ezApprovalG/ezAprOpinion.do";
    if (CrossYN()) {
        ezapropinion_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapropinion_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
        DivPopUpShow(330, 205, url);
    }
    else {
        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
        feature = feature + GetShowModalPosition(330, 205);
        var RtnVal = window.showModalDialog(url, parameter, feature);
    }
    return RtnVal;
}

function OpenInformationUI_Complete() {
    DivPopUpHidden();
}   


function setMenuBar(id, flag) {
    var strCmd, display_Value;

    if (flag) 
        display_Value = "";
    else
        display_Value = "none";

    strCmd = id + ".style.display='" + display_Value + "'";
    eval(strCmd);

    strCmd = id + "1.style.display='" + display_Value + "'";
    eval(strCmd);

    strCmd = id + "2.style.display='" + display_Value + "'";
    eval(strCmd);
}

var ezaprhistory_cross_dialogArguments = new Array();
function getHistory() {
	//회람 변경내역 볼 시 원본 내역을 봐야 하기 때문에 변경
	if (pDocState == strDocState15) {
		var URL = "/ezApprovalG/ezAprHistory.do?docID=" + pOrgDocID + "&ext=" + "mht";
	} else {
		var URL = "/ezApprovalG/ezAprHistory.do?docID=" + pDocID + "&ext=" + "mht";
	}

    ezaprhistory_cross_dialogArguments[0] = "";
    ezaprhistory_cross_dialogArguments[1] = getHistory_Complete;

    DivPopUpShow(740, 450, URL);
}

function getHistory_Complete() {
    DivPopUpHidden();
}

function checkDeptAndCabinetId() {
    var result;
    $.ajax({
        type : "POST",
        dataType : "text",
        async : false,
        url : "/ezApprovalG/checkDeptAndCabinetId.do",
        data : {
                orgDeptId : arr_userinfo[4],
                orgCabinetId : ""
        },
        success : function(text){
            result = text;
        }
    });
    return result;
}
function checkAprState() {
    var result = "";
    
    if (approvalFlag == "S") {
        $.ajax({
            type : "POST",
            dataType : "text",
            async : false,
            url : "/ezApprovalG/checkAprState.do",
            data : {
                docID : pDocID,
                docState : pDocState,
                userID : '',
                aprMemberSN : "1",
                orgCompanyID : orgCompanyID
            },
            success : function(text) {
                result = text;
            }
        });
    }
    
    return result == "FALSE" ? true : false;
}
function getDocRecevState() {
    try {
        var result = "FALSE";
        
        $.ajax({
            type : "POST",
            dataType : "text",
            async : false,
            url : "/ezApprovalG/getDocState.do",
            data : {
                docID : pDocID,
                deptID: arr_userinfo[4]
            },
            success: function(text){
                result = text;
            }
        });
        
        return result;
    } catch (e) {
        alert("getDocRecevState :: " + e.description);
    }
}
function setCabinetHeSong(pDocSN) {
    try {
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/setCabinetHesong.do",
    		data : {
    			docID : pDocID,
    			deptID  : arr_userinfo[4],
    			deptName : arr_userinfo[15],
    			deptName2 : arr_userinfo[16],
    			userName : arr_userinfo[11],
    			userName2 : arr_userinfo[12],
    			docSN     : pDocSN
    		},
    		success: function(xml){
    			result = xml;
    		}, error: function() {
                return false;
    		}			
    	});
        
        if (result == "TRUE")
            return true;
        else
            return false;
    }
    catch (e) {
        alert("setCabinetHeSong :: " + e.description);
        return false;
    }
}
function setHeSongDocInfo() {
    try {
        var result = "";
        
        if (pDocState === "012") {
            var objRoot;
            var objNode;
            
            var xmlpara = createXmlDom();
            var xmlhttp = createXMLHttpRequest();
            createNodeInsert(xmlpara, objNode, "ASSIGN");
            
            createNodeAndInsertText(xmlpara, objNode, "pDocID", pDocID);
            createNodeAndInsertText(xmlpara, objNode, "pAprMemberDeptID", arr_userinfo[4]);
            createNodeAndInsertText(xmlpara, objNode, "pAprMemberID", pUserID);
            
            //receivesn 받아올 곳 찾기 전까진 1로 고정.
            createNodeAndInsertText(xmlpara, objNode, "pReceiveSN", "1");

            xmlhttp.open("POST", "/ezApprovalG/setHeSongHapyuiDocInfo.do", false);
            xmlhttp.send(xmlpara);
            
            if (xmlhttp != null && xmlhttp.readyState == 4) {
                if (xmlhttp.status == 200) {
                    var pAlertContent = strLang878;
                    OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
                    return true;
                } else {
                    var pAlertContent = strLang740;
                    OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
                    return false;
                }
            }
        } else {
            var docState = "RECEIVE";
            // if (pAprState == strAprState15) {
            // 	docState = "REACK";
            // } else {
            // 	docState = "RECEIVE";
            // }
            
            $.ajax({
                type : "POST",
                dataType : "text",
                async : false,
                url : "/ezApprovalG/setHeSongDocInfo.do",
                data : {
                    docID : pDocID,
                    receiveSN : "1",
                    deptID  : arr_userinfo[4],
                    docState : pDocState,
                    userID : pUserID,
                    userName : arr_userinfo[11],
                    userName2 : arr_userinfo[12]
                },
                success: function(xml){
                    result = loadXMLString(xml);
                }, error: function() {
                    var pAlertContent = strLang740;
                    OpenAlertUI(pAlertContent);
                    return false;
                }			
            });
    
            var RtnVal = getNodeText(result.documentElement);
            
            if (RtnVal == "TRUE") {
                   var pAlertContent = strLang741;
                   OpenAlertUI(pAlertContent, OpenAlertUI_Close_Complete);
                   
                   //2019-05-02 김보미 : 근태관리 연동양식일 경우 추가 - 회송
                    if (document.getElementById('message').contentWindow.document.getElementById('attitude_annual_conn')) {       	
                        $.ajax({
                            type : 'POST',
                            dataType : 'json',
                            async : true,
                            url : '/ezAttitude/approvalGConn.do',
                            data : {
                                status : 'delete',
                                docId : pOrgDocID,
                                type : 'hesong'
                            },
                            success : function(result) {
                            },
                            error : function() {
                            }
                        });				
                    }
                   
                   return true;
            }
        }
    }
    catch (e) {
        alert("setHeSongDocInfo :: " + e.description);
        return false;
    }
}

function OpenAlertUI_Close_Complete() {
    btnClose_onclick();
}