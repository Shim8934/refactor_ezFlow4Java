var SignType = new Array();
var SignName = new Array();
var SignContent = new Array();
var s = "";

	function getGyulJeDate() {
	    try {
	    	var result = "";
	    	
	        $.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		url : "/ezApprovalG/getDate.do",
	    		data : {
	    			getDate : ""
	    		},
	    		success: function(text){
	    			result = text;
	    		}        			
	    	});
	
	        return result;
	
	    } catch (e) {
	        alert("getGyulJeDate : " + e.description);
	    }
	}

	function btnWhoKyul_onclick() {
	    var pInformationContent = strLangSpjj30;
	    OpenInformationUI(pInformationContent, WhoKyul_onclick_Complete);
	}

	function WhoKyul_onclick_Complete(RtnVal) {
	    if (RtnVal) {
	        if (checkPwdFlag == "Y") {
	        	chk_Passwd2(pUserID);
	        } else {
	        	WhoKyul_Complete("OK");
	        }
	    } else {
	    	DivPopUpHidden();
	    } 
	}

	function WhoKyul_Complete(RtnVal) {
	    if (RtnVal == "False") {
	        var pAlertContent = strLang581;
	        OpenAlertUI(pAlertContent);
	        return;
	    } else if (RtnVal == "cancel") {
	        var pAlertContent = strLang582;
	        OpenAlertUI(pAlertContent);
	        return;
	    }
	
	    var RtnVal = getGyulJeDate();
	    var CurrentDate = RtnVal.split(".");
	    s = CurrentDate[1] + "." + CurrentDate[2];
	
	    var xmlSignInfo = createXmlDom();
	    xmlSignInfo = GetSignInfoWK();
	
	    if (CrossYN()) {
	        var ReceiveSN = trim_Cross(xmlSignInfo.getElementsByTagName("RECEIVESN")[0].childNodes[0].nodeValue);
	        var SignSN = xmlSignInfo.getElementsByTagName("SIGNSN")[0].childNodes[0].nodeValue;
	    }
	    else {
	        var ReceiveSN = getNodeText(xmlSignInfo.getElementsByTagName("RECEIVESN").item(0));
	        var SignSN = getNodeText(xmlSignInfo.getElementsByTagName("SIGNSN").item(0));
	    }
	    MappingSign(ReceiveSN, SignSN);       
	}


	function SetWhoKyulFlag() {
		var result = "";
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/setWhoKyulUpdate.do",
    		data : {
    			docID : pDocID,
    			userID : pUserID
    		},
    		success: function(text) {
    			result = text;
        	},
        	error : function() {
        		alert("오류 발생");
        	}
    	});
        
	    return result;
	}

	function GetSignInfoWK() {
		var result = "";
	    $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getWhoKyulSignInfo.do",
    		data : {
    			docID : pDocID,
    			userID : pUserID
    		},
    		success: function(text) {
    			result = loadXMLString(text);
        	},
        	error : function() {
        		alert("오류발생");
        	}
    	});
	    
	    return result;
	}

	function SignSave() {
	    if (SignContent.length > 0) {
	        var xmlhttp = createXMLHttpRequest();
	        var xmlpara = createXmlDom();
	
	        
	        var objNode;
	        objNode = createNodeInsert(xmlpara, objNode, "SIGNINFOS");
	
	        var i;
	        for (i = 0; i < SignContent.length; i++) {
	            var objSub;
	            objSub = createNodeAndAppandNode(xmlpara, objNode, objSub, "SIGNINFO");
	
	            var objSub2;
	            createNodeAndAppandNodeText(xmlpara, objSub, objSub2, "DOCID", pDocID);
	            createNodeAndAppandNodeText(xmlpara, objSub, objSub2, "SIGNTYPE", SignType[i]);
	            createNodeAndAppandNodeText(xmlpara, objSub, objSub2, "SIGNNAME", SignName[i]);
	            createNodeAndAppandNodeText(xmlpara, objSub, objSub2, "CONTENT", SignContent[i]);
	            createNodeAndAppandNodeText(xmlpara, objSub, objSub2, "ORGCOMPANYID", orgCompanyID);
	        }
	        xmlhttp.open("Post", "/ezApprovalG/setSignInfo.do", false);
	        xmlhttp.send(xmlpara);
	    }
	}

	var aprsign1_cross_dialogArguments = new Array();
	function openSingUI() {
	var result = "";
    var ret = "";
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/getSignRequest.do",
    		data : {
    			userID : pUserID
    		},
    		success: function(xml){
    			result = loadXMLString(xml);
    		}        			
    	});

        var SignNodeList;

        SignNodeList = SelectNodes(result, "LISTVIEWDATA/ROWS/ROW");

        //if (SignNodeList.length != 0) {
            var parameter = pUserID;

            aprsign1_cross_dialogArguments[0] = parameter;
            aprsign1_cross_dialogArguments[1] = openSignUI_Complete;

            DivPopUpShow(350, 310, "/ezApprovalG/aprSign.do");
        /*
		}
	    else {
	        if (CrossYN()) {
	            openSignUI_Complete("NAME");
	        }
	        else {
	            ret = "NAME";
	        }
	    }
		*/
	
	    if (ret == null)
	        ret = "NAME";
	    return ret;
	}

	var ezchkpasswd_cross_dialogArguments = new Array();
	function chk_Passwd2(pPwd) {

	    ezchkpasswd_cross_dialogArguments[0] = pUserID;
	    ezchkpasswd_cross_dialogArguments[1] = WhoKyul_Complete;

	    DivPopUpShow(350, 225, "/ezApprovalG/ezchkPasswd.do");
	}
	
  