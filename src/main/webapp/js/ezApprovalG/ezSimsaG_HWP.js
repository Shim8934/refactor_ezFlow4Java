function OpenCheckUI() {
    return "NONE";
}

function GetEndDocInfo() {
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getEndDocInfo.do",
		data : {
			docID : pOrgDocID
		},
		success: function(xml){
			result = xml;
		}        			
	});

    var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
    xmlDoc.async = "false";
    xmlDoc.loadXML(result);
    
	pDocInfoXML = xmlDoc;
}

function getLineInfo() {
    var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
	createNodeAndInsertText(xmlpara, objNode, "DocID", pOrgDocID);

	xmlhttp.open("Post","/ezApprovalG/getLineInfo.do",false);
	xmlhttp.send(xmlpara);
	
    var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
    xmlDoc.async = "false";
    xmlDoc.loadXML(xmlhttp.responseText);
    
    return xmlDoc;
}

function sendExt() {
	var orgHTML;
	var sihangDate = "";
	var field;
	var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();
    var xmlRtn;	
		
	var chkFlag = chkToInfo();
    if (!chkFlag) {
		return false;
	}

    if (sendCNT[0] > 0) {
        if (!getPasswdEnd()) {
			return false;
		}
	}
	
	if (makeXML(pDocID))		
		return true;
	else
		return false;
}

function covBody(pbody) {
    pbody = removeTags(pbody, '<caption><img><i><b><u><sub><sup><br><p><span><ul><ol><table><tbody><tr><td>');

	var compSTR, subcompSTR, compChar, startIdx, findIdx, nextIdx, endIdx;
	var i, strgt, startflag;
	startflag = false;
    tmpSTR = pbody;
    
    startIdx = 1;
    endIdx = tmpSTR.length;
    
    i = 0;
    startflag = false;
    strgt = false;
    compChar = '"';
    newSTR = "";

    while (i < endIdx) {
        compSTR = tmpSTR.substr(i, 1);
        //strgt = false;
        
        if(compSTR == "<") strgt = true;
        if(compSTR == ">") strgt = false;
            
        if (!startflag) {
            if (compSTR == "=" && strgt) {
                i = i + 1
                subcompSTR = tmpSTR.substr(i,1);
                if(compSTR == "<") strgt = true;
                if(compSTR == ">") strgt = false;
                                
                if (subcompSTR != compChar && strgt) {
                    newSTR = newSTR + compSTR.toLowerCase() + "'" + subcompSTR.toLowerCase();
                    startflag = true;
                }
                else {
                    if (strgt) {
						if(subcompSTR == compChar) subcompSTR = "'";
                        newSTR = newSTR + compSTR.toLowerCase() + subcompSTR.toLowerCase();
                    }
                    else
                        newSTR = newSTR + compSTR + subcompSTR;
                }
            }                    
            else {
                if (strgt) {
                    if(compSTR == compChar) compSTR = "'";
                    newSTR = newSTR + compSTR.toLowerCase();
                    
                }
                else
                    newSTR = newSTR + compSTR;
            }    
            i = i + 1;
        }
        else {
            if (compSTR == " " || compSTR == ">") {
                if (strgt) {
					if(compSTR == compChar) compSTR = "'";
                    newSTR = newSTR + "'" + compSTR.toLowerCase() + " ";
                }
                else
                    newSTR = newSTR + "'" + compSTR + " ";
                startflag = false
            }
            else {
                if (strgt) {
					if(compSTR == compChar) compSTR = "'";
                    newSTR = newSTR + compSTR.toLowerCase();
                }
                else
                    newSTR = newSTR + compSTR;
            }
            i = i + 1
        }
	}
    
    // html 태그를 모두 뽑아내기 위한 정규식
    var tagRegexp = /<[/]?([^> ]*)[^>]*>/g;
    
    // 첫번째 html 태그를 매치함
    var tagMatch = tagRegexp.exec(newSTR);
    // tag 전체 문자열
    var tagLabel = "";
    // tag 이름
    var tagName = "";
    
    var tagInfo, lastTagInfo;
    var startTagStack = [];
    // 홀태그 스택
    var oddTagStack = [];
    
    while (tagMatch != null) {
    	tagLabel = tagMatch[0];
    	tagName = tagMatch[1];
    	// 닫힌 태그
    	if (tagLabel.indexOf('/') === 1) {
    		lastTagInfo  = startTagStack.pop();
    		
    		if (lastTagInfo === undefined) {
    			continue;
    		}
    		
			// 홀태그를 뒤에 /> 로 되도록 함으로서 xml 파싱시에 에러가 나지 않도록 한다.
			// 왜 홀태그를 따로 정규식으로 가져오지 않냐면 가끔 p 태그가 닫히지 않는 경우도 있기 때문이다.
			// 정규식으로 닫히지 않는 태그를 가져오는건 힘들 것 같기 때문에 직접 검사하도록 구현함
			
			// 마지막 열리는 태그랑 닫히는 태그가 이름이 맞을 때 까지
			while (lastTagInfo.name !== tagName) {
				oddTagStack.push(lastTagInfo);
				lastTagInfo = startTagStack.pop();
			}
    	} else {
    		// 열린 태그
    		startTagStack.push({
    			name: tagName,
    			endIndex: tagMatch.index + tagLabel.length - 1
    		});
    	}
    	
    	tagMatch = tagRegexp.exec(newSTR);
    }
    
    while (startTagStack.length > 0) {
    	oddTagStack.unshift(startTagStack.pop());
    }
    
    oddTagStack.sort(function(aTag, bTag) {
    	return aTag.endIndex - bTag.endIndex;
    });
    
    while (oddTagStack.length > 0) {
    	tagInfo = oddTagStack.pop();
    	newSTR = [newSTR.slice(0, tagInfo.endIndex), '/', newSTR.slice(tagInfo.endIndex)].join('');
    }
    
	var re = /&nbsp;/g; 
	var BodyStr = "<content>" + newSTR.replace(re,"&amp;nbsp;") + "</content>";
	
	//스타일 속성안에 요소가 아무것도 없을 경우 파싱 에러 처리 2019-11-25 홍대표
    BodyStr = BodyStr.replace(/style=''/g, "");
	
	BodyStr = BodyStr.replace(/: '/g,":");
	BodyStr = BodyStr.replace(/'' /g,"' ");
	BodyStr = BodyStr.replace(/''>/g,"'>");
	BodyStr = BodyStr.replace(/'; /g,"; ");
    BodyStr = BodyStr.replace(/class=hstyle0/g, "");
    BodyStr = BodyStr.replace(/''font-size:'/g, "'font-size:");
    
    BodyStr = BodyStr.replace(/''margin-bottom:'/g, "'margin-bottom:");
    BodyStr = BodyStr.replace(/='>/g, "=''>");
    BodyStr = BodyStr.replace(/=''/g, "='");
    BodyStr = BodyStr.replace(/:'  '/g, ":");
    BodyStr = BodyStr.replace(/:'  /g, ":");
    BodyStr = BodyStr.replace(/';'/g, ";'");
    
    //2018-09-14 홍대표	 불필요한 속성과 단위 변경.
    var pxToMm = function(str, p1, p2, offset, s){
    	return p1 + (p2 * 0.264583) + "mm";
    }
    
    BodyStr = BodyStr.replace(/[^-]height='height:\d+'/ig, "");
    BodyStr = BodyStr.replace(/([^-]height:)(\d+[\w?]*)/ig, pxToMm).replace(/(width:)(\d+[\w?]*)/ig, pxToMm);
    BodyStr = BodyStr.replace(/(border-)(left|right|top|bottom):[\w\d\s#.(),]*;/g, "");
    
    BodyStr = BodyStr.replace(/(\?(\w)*?\w=)((')(\w*?)['])/ig, "$1$5$4");
    BodyStr = BodyStr.replace(/\n|\r|\t/g, "");
    
	var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
	xmlpara.async = false;
    xmlpara.loadXML(BodyStr)
	var bodyNodes = xmlpara.documentElement;
    
	return bodyNodes;
}

function removeTags(input, allowed) {
    allowed = (((allowed || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join('');
    var tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi, commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;
    return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
        return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
    });
}
function makeXML(newDocID) {
	GetEndDocInfo();
	
	var tempNode;
	
    if (HwpCtrl.CheckFieldExist("opinions")) {
        if (HwpCtrl.CheckFieldExist("body")) {
			HwpCtrl.AppendFieldText("body", "<br><br>", false, true);
			HwpCtrl.AppendFieldText("body", HwpCtrl.GetFieldText("opinions"), false);
			HwpCtrl.SetFieldText("opinions", "");
		}
	}
	
	sihangXML = new ActiveXObject("Microsoft.XMLDOM");
	sihangXML.async = false;
	sihangXML.load("/xml/ezApprovalG/pubdocsample.xml");
	
	var eNodes = sihangXML.documentElement;
	
	var Nodes = eNodes.selectNodes("head/organ");
    if (HwpCtrl.CheckFieldExist("organ")) {
        setNodeText(Nodes(0) , HwpCtrl.GetFieldText("organ"));
    } else {
        setNodeText(Nodes(0) , "");
	}
	
	var Nodes = eNodes.selectNodes("head/receiptinfo/recipient");
    if (HwpCtrl.CheckFieldExist("recipients")) {
        if (trim(HwpCtrl.GetFieldText("recipients")) == "") {
			Nodes(0).setAttribute("refer", "false");
            if (HwpCtrl.CheckFieldExist("recipient")) {
                tempNode = eNodes.selectNodes("head/receiptinfo/recipient/rec");
                setNodeText(tempNode(0) , HwpCtrl.GetFieldText("recipient"));
			}
        } else {
			Nodes(0).setAttribute("refer", "true");	
            tempNode = eNodes.selectNodes("head/receiptinfo/recipient/rec");
            setNodeText(tempNode(0) , HwpCtrl.GetFieldText("recipients").replace(strLang177, ""));
		}
	}
	
	var Nodes = eNodes.selectNodes("head/receiptinfo");
    if (HwpCtrl.CheckFieldExist("refer")) {
        if (trim(HwpCtrl.GetFieldText("refer")) != "") {
            var tempNode2 = sihangXML.createNode(1, "via", "");
			Nodes(0).appendChild(tempNode2)
			setNodeText(tempNode2 , HwpCtrl.GetFieldText("refer"));
		}
	}
	
	var Nodes = eNodes.selectNodes("body/title");
    if (HwpCtrl.CheckFieldExist("doctitle")) {
        setNodeText(Nodes(0) , HwpCtrl.GetFieldText("doctitle"));
    } else {
        setNodeText(Nodes(0) , "");
	}

	var Nodes = eNodes.selectNodes("body");	
    if (attachbodyPath != "") {
		Nodes(0).setAttribute("separate", "true");	
    } else {
		Nodes(0).setAttribute("separate", "false");	
	}
	
	var Nodes = eNodes.selectNodes("body");	
    if (HwpCtrl.CheckFieldExist("body")) {
    	var strBody = HwpCtrl.GetCloneData("body", "HTML");
		var pBody = Encode(strBody);
		
        if (pBody == "</ERROR>") {
            alert("본문에 잘못된 내용이 포함되어 있습니다.\n(이미지, 스타일속성 등을 포함할 수 없습니다.)");
            return;
        }

		var re = /vAlign=center/g;
		pBody = pBody.replace(re,"vAlign=middle");
		
		var rtnNodes = covBody(pBody);
        Nodes(0).appendChild(rtnNodes);
    } else {
        setNodeText(Nodes(0) , "");
	}
	
	var Nodes = eNodes.selectNodes("foot/sendername");
    if (HwpCtrl.CheckFieldExist("chief")) {
        setNodeText(Nodes(0) , HwpCtrl.GetFieldText("chief"));
    } else {
        setNodeText(Nodes(0) , "");
	}

	var Nodes = eNodes.selectNodes("foot/seal");
    if (NostampFlag) {
		Nodes(0).setAttribute("omit", "true");
    } else {
        if (HwpCtrl.CheckFieldExist("sealsign")) {
			sealPath = GetDocumentElement(HwpCtrl, "surl");
            if (sealPath != "") {
				Nodes(0).setAttribute("omit", "false");
				var tempNode2 = sihangXML.createNode(1,"img","")
				Nodes(0).appendChild(tempNode2)
				
				var len = sealPath.lastIndexOf("/");
				var filelength = sealPath.length - (len + 1);  
				
				sealName = sealPath.substr(len + 1,filelength);
				tempNode2.setAttribute("src",sealName)
                tempNode2.setAttribute("alt", strLang178);
				tempNode2.setAttribute("height", GetDocumentElement(HwpCtrl, "sheight").toString() + "mm");
				tempNode2.setAttribute("width", GetDocumentElement(HwpCtrl, "swidth").toString() + "mm");
			}
		}
	}

	var Nodes = eNodes.selectNodes("foot/approvalinfo");
	var LineNode = getLineInfo();
	var SignSN = 1;
	psignCount = 1;
	var DekyulFlag = false;

    for (i = 0; i < LineNode.documentElement.childNodes.length; i++) {
        if (getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("TYPE")) != strLang3) {
			var tempNode2 = sihangXML.createNode(1,"approval","");
			Nodes(0).appendChild(tempNode2);
			tempNode2.setAttribute("order", getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("ORDER")));
			
			var tempNode3 = sihangXML.createNode(1,"signposition","");
			tempNode2.appendChild(tempNode3);
//			if (getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("OPINION")) == "YES")
//			    setNodeText(tempNode3 , getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("SIGNPOSITION")) + "(" + strLang5);
//			else
//			    setNodeText(tempNode3 , getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("SIGNPOSITION")));

			    setNodeText(tempNode3 , getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("SIGNPOSITION")));
			
			var tempNode3 = sihangXML.createNode(1,"type","");
			tempNode2.appendChild(tempNode3);
			setNodeText(tempNode3 , getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("TYPE")));
			
			if (getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("TYPE")) == strLang7 )
				DekyulFlag = true;
			
			if ((getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("TYPE")) == strLang6) && (DekyulFlag)) {
				var tempNode3 = sihangXML.createNode(1,"name","");
				tempNode2.appendChild(tempNode3);
				setNodeText(tempNode3 , getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("NAME")));
				
				var tempNode3 = sihangXML.createNode(1,"date","");
				tempNode2.appendChild(tempNode3);
				setNodeText(tempNode3 , "");
            } else {
                if (HwpCtrl.CheckFieldExist("sign" + SignSN)) {
					var signPath = GetDocumentElement(HwpCtrl, "sign" + SignSN);
							
                    if (signPath != "") {
						var tempNode3 = sihangXML.createNode(1,"signimage","");
						tempNode2.appendChild(tempNode3);

						var tempNode4 = sihangXML.createNode(1,"img","");
						tempNode3.appendChild(tempNode4);
						
						var len = signPath.lastIndexOf("/");
						var filelength = signPath.length - (len + 1);  
						var signName = signPath.substr(len + 1,filelength);

						tempNode4.setAttribute("src",signName);
						tempNode4.setAttribute("alt",strLang179);
								
                        
                        var tempSize = GetHTMLBody(HwpCtrl.GetCloneData("sign" + SignSN, "HTML"));
                        var tmpDiv = document.createElement("div");
                        tmpDiv.innerHTML = tempSize;
                        //var tmpH = PixelToMillimeter(GetAttribute(tmpDiv.childNodes[0].childNodes[0].childNodes[0],'height'));
                        //var tmpW = PixelToMillimeter(GetAttribute(tmpDiv.childNodes[0].childNodes[0].childNodes[0], 'width'));
                        var tmpH = PixelToMillimeter(GetAttribute(tmpDiv.getElementsByTagName("IMG")[0], 'height'));
                        var tmpW = PixelToMillimeter(GetAttribute(tmpDiv.getElementsByTagName("IMG")[0], 'width'));


                        if (tmpW == null || tmpW == "")
							tempNode4.setAttribute("width", "21.63mm");
						else
                            tempNode4.setAttribute("width", tmpW + "mm");
								
                        if (tmpH == null || tmpH == "")
							tempNode4.setAttribute("height", "10.17mm");
						else
                            tempNode4.setAttribute("height", tmpH + "mm");
								
						psignName[psignCount] = signName;
						psignPath[psignCount] = signPath;
						psignCount = psignCount + 1;

					}
					var tempNode3 = sihangXML.createNode(1,"name","");
					tempNode2.appendChild(tempNode3);
					setNodeText(tempNode3 , getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("NAME")));
                } else {
					var tempNode3 = sihangXML.createNode(1,"name","");
					tempNode2.appendChild(tempNode3);
					setNodeText(tempNode3 , getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("NAME")));
				}
				
				var tempNode3 = sihangXML.createNode(1,"date","");
				tempNode2.appendChild(tempNode3);
				
				if (getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("ORDER")) == "final" || DekyulFlag) {
				    var tempDate = LineNode.documentElement.childNodes(i).selectSingleNode("DATE").text;
				    setNodeText(tempNode3, tempDate);
				} else
				    setNodeText(tempNode3, "");
			}			
			SignSN = SignSN + 1;
		}
	}

    for (i = 0; i < LineNode.documentElement.childNodes.length; i++) {
		var SignSN = 1;
		if (getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/TYPE").item(i)) == strLang3) {
			var tempNode2 = sihangXML.createNode(1,"assist","");
			Nodes(0).appendChild(tempNode2);
			tempNode2.setAttribute("order",getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/ORDER").item(i)))

			var tempNode3 = sihangXML.createNode(1,"signposition","");
			tempNode2.appendChild(tempNode3);
//			if (getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/OPINION").item(i)) == "YES")
//			    setNodeText(tempNode3 , getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/SIGNPOSITION").item(i)) + "(" + strLang5);
//			else
//			    setNodeText(tempNode3 , getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/SIGNPOSITION").item(i)));

			setNodeText(tempNode3 , getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/SIGNPOSITION").item(i)));
			
			var tempNode3 = sihangXML.createNode(1,"type","");
			tempNode2.appendChild(tempNode3);
			setNodeText(tempNode3 , getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/TYPE").item(i)));
			

            if (HwpCtrl.CheckFieldExist("habyuisign" + SignSN)) {
				var signPath = GetDocumentElement(HwpCtrl, "habyuisign" + SignSN);
				
                if (signPath != "") {
					var tempNode3 = sihangXML.createNode(1,"signimage","");
					tempNode2.appendChild(tempNode3);

					var tempNode4 = sihangXML.createNode(1,"img","");
					tempNode3.appendChild(tempNode4);
					
					var len = signPath.lastIndexOf("/");
					var filelength = signPath.length - (len + 1);  
					var signName = signPath.substr(len + 1,filelength);
					
					tempNode4.setAttribute("src",signName);
					tempNode4.setAttribute("alt", strLang179 );

					//var tempSize = GetImgSize(GetHTMLBody(HwpCtrl.GetCloneData("habyuisign" + SignSN, "HTML")));
					
                    var tempSize = GetHTMLBody(HwpCtrl.GetCloneData("habyuisign" + SignSN, "HTML"));
                    var tmpDiv = document.createElement("div");
                    tmpDiv.innerHTML = tempSize;
                    //var tmpH = PixelToMillimeter(GetAttribute(tmpDiv.childNodes[0].childNodes[0].childNodes[0],'height'));
                    //var tmpW = PixelToMillimeter(GetAttribute(tmpDiv.childNodes[0].childNodes[0].childNodes[0], 'width'));
                    var tmpH = PixelToMillimeter(GetAttribute(tmpDiv.getElementsByTagName("IMG")[0], 'height'));
                    var tmpW = PixelToMillimeter(GetAttribute(tmpDiv.getElementsByTagName("IMG")[0], 'width'));


                    if (tmpW == null || tmpW == "")
						tempNode4.setAttribute("width", "21.63mm");
					else
                        tempNode4.setAttribute("width", tmpW + "mm");
					
                    if (tmpH == null || tmpH == "")
						tempNode4.setAttribute("height", "10.17mm");
					else
                        tempNode4.setAttribute("height", tmpH + "mm");
					
					psignName[psignCount] = signName;
					psignPath[psignCount] = signPath;
					psignCount = psignCount + 1;
                } else {
					var tempNode3 = sihangXML.createNode(1,"name","");
					tempNode2.appendChild(tempNode3);
					setNodeText(tempNode3 , getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/NAME").item(i)));	
				}
            } else {
				var tempNode3 = sihangXML.createNode(1,"name","");
				tempNode2.appendChild(tempNode3);
				setNodeText(tempNode3 , getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/NAME").item(i)));	
			}
			
			var tempNode3 = sihangXML.createNode(1,"date","");
			tempNode2.appendChild(tempNode3);
			setNodeText(tempNode3 , "");
			
			SignSN = SignSN + 1;
		}
	}
	
	var Nodes = eNodes.selectNodes("foot/processinfo/regnumber");
    if (HwpCtrl.CheckFieldExist("docnumber")) {

        setNodeText(Nodes(0) , HwpCtrl.GetFieldText("docnumber"));
		
		var regnumbercode;
		regnumbercode = getNodeText(pDocInfoXML.documentElement.childNodes(32));
		// regnumbercode 에 유통코드 붙이기 위해 추가  : 유통코드 + 일련번호
		var relayRegnumberCode = companyID + regnumbercode.substring(regnumbercode.length - 6, regnumbercode.length);
		
		Nodes(0).setAttribute("regnumbercode", relayRegnumberCode);
    } else {
        setNodeText(Nodes(0) , "");
		Nodes(0).setAttribute("regnumbercode", "");
	}
	
	var Nodes = eNodes.selectNodes("foot/processinfo/enforcedate");
    if (HwpCtrl.CheckFieldExist("enforcedate")) {
        setNodeText(Nodes(0) , HwpCtrl.GetFieldText("enforcedate"));
    } else {
        setNodeText(Nodes(0) , "");
	}

	var Nodes = eNodes.selectNodes("foot/processinfo");
    if (HwpCtrl.CheckFieldExist("receiptnumber")) {
//		var tempNode2 = sihangXML.createNode(1,"receipt","");
//		Nodes(0).appendChild(tempNode2);
//
//		var tempNode3 = sihangXML.createNode(1,"number","");
//		tempNode2.appendChild(tempNode3);
//		setNodeText(tempNode3 , HwpCtrl.GetFieldText("receiptnumber"));
//
//		var tempNode3 = sihangXML.createNode(1,"date","");
//		tempNode2.appendChild(tempNode3);
//
//        if (HwpCtrl.CheckFieldExist("receiptdate")) {
//            setNodeText(tempNode3 , HwpCtrl.GetFieldText("receiptdate"));
//		}
	}

	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("zipcode")) {
		var tempNode2 = sihangXML.createNode(1,"zipcode","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("zipcode"));
    } else {
		var tempNode2 = sihangXML.createNode(1,"zipcode","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , "");
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("address")) {
		var tempNode2 = sihangXML.createNode(1,"address","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("address"));
    } else {
		var tempNode2 = sihangXML.createNode(1,"address","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , "");
	}

	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("homepage")) {
		var tempNode2 = sihangXML.createNode(1,"homeurl","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("homepage"));
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("telephone")) {
		var tempNode2 = sihangXML.createNode(1,"telephone","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("telephone"));
    } else {
		var tempNode2 = sihangXML.createNode(1,"telephone","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , "");
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("fax")) {
		var tempNode2 = sihangXML.createNode(1,"fax","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("fax"));
    } else {
		var tempNode2 = sihangXML.createNode(1,"fax","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , "");
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("email")) {
		var tempNode2 = sihangXML.createNode(1,"email","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("email"));
	}
	
	var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("publication")) {
		var tempNode2 = sihangXML.createNode(1,"publication","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("publication"));
		tempNode2.setAttribute("code", getNodeText(pDocInfoXML.documentElement.childNodes(27)));		
    } else {
		var tempNode2 = sihangXML.createNode(1,"publication","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , "");
		tempNode2.setAttribute("code", getNodeText(pDocInfoXML.documentElement.childNodes(27)));		
	}

	var Nodes = eNodes.selectNodes("foot/sendinfo");
	//한글기안기 심볼, 로고 이미지 경로 하드코딩 추후 유동적으로 사용할 수 있도록 수정필요 2019-11-25 홍대표.
	//로고와 심볼 파일을 ex) fileroot/0/files/upload_approvalG\Top/ 에 위치시킴
	SetDocumentElement(HwpCtrl, "symbolurl", "symbol.gif");
    if (HwpCtrl.CheckFieldExist("symbol")) {
		symbolName = GetDocumentElement(HwpCtrl, "symbolurl");
		
        if (symbolName != "") {
			var tempNode3 = sihangXML.createNode(1,"symbol","");
			Nodes(0).appendChild(tempNode3);
			var tempNode2 = sihangXML.createNode(1,"img","")
			tempNode3.appendChild(tempNode2);
			
			symbolPath = approvalRoot + symbolName;
			tempNode2.setAttribute("src", symbolName);
			tempNode2.setAttribute("alt", strLang180);
				
            var tempSize = GetHTMLBody(HwpCtrl.GetCloneData("symbol", "HTML"));
            var tmpDiv = document.createElement("div");
            tmpDiv.innerHTML = tempSize;
            var tmpH = PixelToMillimeter(GetAttribute(tmpDiv.getElementsByTagName("IMG")[0], 'height'));
            var tmpW = PixelToMillimeter(GetAttribute(tmpDiv.getElementsByTagName("IMG")[0], 'width'));

            if (tmpW == null || tmpW == "")
				tempNode2.setAttribute("width", "29.13mm");
			else
                tempNode2.setAttribute("width", tmpW + "mm");
				
            if (tmpH == null || tmpH == "")
				tempNode2.setAttribute("height", "5.93mm");
			else
                tempNode2.setAttribute("height", tmpH + "mm");
		}
	}

	var Nodes = eNodes.selectNodes("foot/sendinfo");
	//한글기안기 심볼, 로고 이미지 경로 하드코딩 추후 유동적으로 사용할 수 있도록 수정필요 2019-11-25 홍대표.
	//로고와 심볼 파일을 ex) fileroot/0/files/upload_approvalG\Top/ 에 위치시킴
	SetDocumentElement(HwpCtrl, "logourl", "logo.png");
    if (HwpCtrl.CheckFieldExist("logo")) {
		logoName = GetDocumentElement(HwpCtrl, "logourl");
		
        if (logoName != "") {
			var tempNode3 = sihangXML.createNode(1,"logo","");
			Nodes(0).appendChild(tempNode3);
			var tempNode2 = sihangXML.createNode(1,"img","")
			tempNode3.appendChild(tempNode2)
			
			logoPath = approvalRoot + logoName;
			tempNode2.setAttribute("src", logoName)
			tempNode2.setAttribute("alt", strLang181)
					
            var tempSize = GetHTMLBody(HwpCtrl.GetCloneData("logo", "HTML"));
            var tmpDiv = document.createElement("div");
            tmpDiv.innerHTML = tempSize;
            var tmpH = PixelToMillimeter(GetAttribute(tmpDiv.getElementsByTagName("IMG")[0], 'height'));
            var tmpW = PixelToMillimeter(GetAttribute(tmpDiv.getElementsByTagName("IMG")[0], 'width'));


            if (tmpW == null || tmpW == "")
				tempNode2.setAttribute("width", "19.05mm");
			else
                tempNode2.setAttribute("width", tmpW + "mm");
					
            if (tmpH == null || tmpH == "")
				tempNode2.setAttribute("height", "8.68mm");
			else
                tempNode2.setAttribute("height", tmpH + "mm");
		}
	}
	
    if (HwpCtrl.CheckFieldExist("headcampaign")) {
		var Nodes = eNodes.selectNodes("foot");
		var tempNode2 = sihangXML.createNode(1,"campaign","");
		Nodes(0).appendChild(tempNode2);

		var tempNode3 = sihangXML.createNode(1,"headcampaign","");
		tempNode2.appendChild(tempNode3);		
		setNodeText(tempNode3 , HwpCtrl.GetFieldText("headcampaign"));
		
        if (HwpCtrl.CheckFieldExist("footcampaign")) {
			var tempNode3 = sihangXML.createNode(1,"footcampaign","");
			tempNode2.appendChild(tempNode3);		
			setNodeText(tempNode3 , HwpCtrl.GetFieldText("footcampaign"));
		}		
    } else {
        if (HwpCtrl.CheckFieldExist("footcampaign")) {
			var Nodes = eNodes.selectNodes("foot");
			var tempNode2 = sihangXML.createNode(1,"campaign","");
			Nodes(0).appendChild(tempNode2);

			var tempNode3 = sihangXML.createNode(1,"footcampaign","");
			tempNode2.appendChild(tempNode3);		
			setNodeText(tempNode3 , HwpCtrl.GetFieldText("footcampaign"));
		}
	}

	
    if (attachName.length > 0) {
        tempNode = sihangXML.createNode(1, "attach", "");
        eNodes.appendChild(tempNode);
		
		var i;
        for (i = 0; i < attachName.length; i++) {
			var subNode;
			subNode = sihangXML.createNode(1,"title","")
			tempNode.appendChild(subNode);
			setNodeText(subNode , attachName[i]);
		}
	}
	
	var sihangXML2 = sihangXML.xml;
	var strtempxml = sihangXML2;
	
	var re = /&amp;nbsp;/g; 
    var strtempxml = strtempxml.replace(re, "&nbsp;");
	var re = /strong>/g; 
    var strtempxml = strtempxml.replace(re, "b>");
	
    var SaveDocHTTp = createXMLHttpRequest();
    SaveDocHTTp.open("POST", "/ezApprovalG/simsaGUpload.do?docID=" + pDocID, false);
    SaveDocHTTp.send(strtempxml);
    
    if (SaveDocHTTp.responseText == "OK") {
    	var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezApprovalG/checkPubDocXML.do",
    		data : {
    			xmlPath :  "/sendXML/" + pDocID + "pubdoc.xml"
    		},
    		success: function(xml){
    			result = xml;
    		}
    	});
    	
    	if (result != "OK") {
    		alert("파서오류(pubdoc) : " + "/sendXML/" + pDocID + "pubdoc.xml" + ", " + result);
    		return false;
    	}
    	
    	//GPKI는 개발안됨
    	if (sendCNT[0] > 0) {
    		var rtnXML = makeExtinfo(sihangXML,newDocID, "GPKI");
    		if (encodePath == "NONE_Enc_SEND") {
                result = sendExtDoc(rtnXML);
    		} else {
    			var rtnFileName = encodeDN(rtnXML);
    			result = encodeUP(rtnFileName);
    		}
    	}
    	
    	
    	if (sihangXML.xml == "")
    		sihangXML.loadXML(sihangXML2);
    	
    	if (sendCNT[1] > 0) {
            var rtnXML = makeExtinfo(sihangXML, newDocID, "SEND");
            result = sendExtDoc(rtnXML);
    	}
    	
    	if (result) {
    		return true;
    	} else {
    		var pAlertContent = strLang185;
    		OpenAlertUI(pAlertContent);
    		return false;
    	}
    }
    
}

function makeExtinfo(psihangXML, newDocID, mode) {
	var ExtSNodes, Nodes, Nodes2, strTO, i;
	var isfirst;
	
    
	var ExtXML =  new ActiveXObject("Microsoft.XMLDOM");
	ExtXML.async = false;
	ExtXML.load("/xml/ezApprovalG/packXML.xml");
	
  try {
	var eNodes = ExtXML.documentElement;
	var Nodes = psihangXML.documentElement;
	
        
	var Nodes = eNodes.selectNodes("header/send-orgcode");
	setNodeText(Nodes(0) , companyID);
	
        
	var Nodes = eNodes.selectNodes("header/send-id");
	setNodeText(Nodes(0) , companyID);
	
        
	var Nodes = eNodes.selectNodes("header/send-name");
	setNodeText(Nodes(0) , companyName);
	
	isfirst = true;
    if (mode == "GPKI") {
        for (i = 0; i < isGPKI.length; i++) {
            if (isGPKI[i] == "Y") {
                if (isfirst) {
					strTO = BaseURL[i];
					isfirst = false;	
                } else {
					strTO = strTO + ";" + BaseURL[i];
				}		
			}	
        }
    } else {
        for (i = 0; i < isGPKI.length; i++) {
            if (isGPKI[i] == "N") {
                if (isfirst) {
					strTO = BaseURL[i];
					isfirst = false;	
                } else {
                    strTO = strTO + ";" + BaseURL[i];
				}
			}
		}
	}
	
        
	var Nodes = eNodes.selectNodes("header/receive-id");
	setNodeText(Nodes(0) , strTO);

        
	var Nodes = eNodes.selectNodes("header/date");
	setNodeText(Nodes(0) , "");

        
	var Nodes = eNodes.selectNodes("header/title");
	setNodeText(Nodes(0) , getNodeText(pDocInfoXML.documentElement.childNodes(7)));

        
	var Nodes = eNodes.selectNodes("header/doc-id");
	setNodeText(Nodes(0) , pOrgDocID);
	
        
	var Nodes = eNodes.selectNodes("header/doc-type");
	if (pAprType == strLang186 )
		Nodes(0).setAttribute("type", "resend");
	else
		Nodes(0).setAttribute("type", "send");

        
	Nodes(0).setAttribute("dept", getNodeText(pDocInfoXML.documentElement.childNodes(17)));
        
	Nodes(0).setAttribute("name", getNodeText(pDocInfoXML.documentElement.childNodes(14)));

        
	var Nodes = eNodes.selectNodes("header/send-gw");
	setNodeText(Nodes(0) , "ezFlow2000/G");

        
	var Nodes = eNodes.selectNodes("header/dtd-version");
	setNodeText(Nodes(0) , "2.0");

        
	var Nodes = eNodes.selectNodes("header/xsl-version");
	setNodeText(Nodes(0) , "2.0");
	
	var Nodes = eNodes.selectNodes("contents");
	var tempNode = sihangXML.createNode(1,"content","");
	Nodes(0).appendChild(tempNode);
	tempNode.setAttribute("content-role", "pubdoc");
	tempNode.setAttribute("filename", "pubdoc.xml");
	tempNode.setAttribute("content-transfer-encoding", "base64");
	tempNode.setAttribute("content-type", "text/xml");
        tempNode.setAttribute("charset", "euc-kr");
	
	var strtempxml = psihangXML.xml;
	var re = /&amp;nbsp;/g; 
	var strtempxml = strtempxml.replace(re,"&nbsp;")
	var re = /strong>/g; 
	var strtempxml = strtempxml.replace(re,"b>")

	setNodeText(tempNode , "<?xml version=\"1.0\" encoding=\"euc-kr\"?><?xml-stylesheet type=\"text/xsl\" href=\"siheng.xsl\"?><!DOCTYPE pubdoc SYSTEM \"pubdoc.dtd\">" + strtempxml);
	
        
    if (sealName != "") {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		tempNode.setAttribute("content-role", "seal");
		tempNode.setAttribute("filename", sealName);
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , sealPath.replace(pDomainName, ""));
	}	
	
        
    for (i = 0; i < attachName.length; i++) {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		if (attachType[i] == "Y")
			tempNode.setAttribute("content-role", "attach_body");
		else
			tempNode.setAttribute("content-role", "attach");
		tempNode.setAttribute("filename", attachName[i]);
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , attachPath[i]);
	}
	
    if (attachxmlPath != "") {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		tempNode.setAttribute("content-role", "attach_xml");
		tempNode.setAttribute("filename", attachxmlName);
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "html/xml");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , attachxmlPath);
	}

    if (attachxslPath != "") {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		tempNode.setAttribute("content-role", "attach_xsl");
		tempNode.setAttribute("filename", attachxslName);
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "html/xsl");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , attachxslPath);	
	}
		
        
    for (i = 1; i < psignCount; i++) {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		tempNode.setAttribute("content-role", "sign");
		tempNode.setAttribute("filename", psignName[i]);
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , psignPath[i]);
	}
	
        
    if (symbolName != "") {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		tempNode.setAttribute("content-role", "symbol");
		tempNode.setAttribute("filename", symbolName);
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , symbolPath.replace(pDomainName, ""));
	}	
        
    if (logoName != "") {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		tempNode.setAttribute("content-role", "logo");
		tempNode.setAttribute("filename", logoName);
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , logoPath.replace(pDomainName, ""));
	}			
	return ExtXML;
	
  } catch(e) {
	alert("makeExtinfo : " + e.description);
  }
}

function encodeUP(emlName) {
	var ouCodes;
	var rtnVal = true;
	
	
	showProgress(strLang744);
	
	var objSave = new ActiveXObject("EzUtil.MiscFunc"); 
	ContentXML = objSave.LoadTextFromFile("c:\\" + emlName)

	ContentXML = ContentXML.replace("<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">", "");

    var xmlContent = createXmlDom();
	xmlContent.loadXML(ContentXML);
	
	var ContentsView = xmlContent.selectSingleNode("pack/contents");
	var ContentText = "";
    for (i = 0; i < ContentsView.childNodes.length; i++) {
		ContentText = ContentText + ContentsView.childNodes(i).xml;
	}
	objSave.SaveTextToFile("c:\\content.xml", ContentText);
	
	
    if (ObjGPKI.Parse("c:\\content.xml")) {
		var i = 0;
		ouCodes = "";
		
		var strTO;
		var isfirst = true;
		
        for (i = 0 ; i < isGPKI.length; i++) {
            if (isGPKI[i] == "Y") {
				ouCodes = ouCodes + BaseURL[i] + ";";
				
                if (isfirst) {
					strTO = AddInfo[i];
					isfirst = false;	
                } else {
                    strTO = strTO + "," + AddInfo[i];
				}
			}
		}
		
		
		var xmlhttp = createXMLHttpRequest();
		xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/getServerTime.aspx", false);
		xmlhttp.send();
		
        if (is_Enc == "ENC") {
			
            if (ObjGPKI.Encode(encodePath, ouCodes, encodePass, xmlhttp.responseText)) {
				var dday = ObjGPKI.errorMsg
                if (ObjGPKI.FailCertList != "") {
					var tempFailList = ObjGPKI.FailCertList;
					var isfirst = true;
					var TempRecvList = "";
                    for (i = 0; i < isGPKI.length; i++) {
                        if (tempFailList.indexOf(BaseURL[i]) >= 0) {
							isGPKI[i] = "N"
                            if (isfirst) {
								TempRecvList = AddInfo[i];
								isfirst = false;
                            } else {
								TempRecvList = TempRecvList + ", " + AddInfo[i];
							}													
							sendCNT[0] = sendCNT[0] - 1;
							sendCNT[1] = sendCNT[1] + 1;
						}
					}
					var pAlertContent = strLang189 + "" + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
				}
				
				ObjGPKI.WriteResultFile("C:\\upload.p7m");
				var GPKIContent = objSave.DownloadToBase64("C:\\upload.p7m");
				
				
				var NewContents = makePKIHeader(GPKIContent);
				// 2018-08-25 sendExtDoc 함수 변경됨(클라이언트에서 Content를 넘겨주지 않고 서버에서 읽어서 처리). GPKI쪽 개발 시 참고!
				rtnVal = sendExtDoc(NewContents);
            } else {
                if (ObjGPKI.FailCertList != "") {
					var tempFailList = ObjGPKI.FailCertList;
					var isfirst = true;
					var TempRecvList = "";
                    for (i = 0; i < isGPKI.length; i++) {
                        if (tempFailList.indexOf(BaseURL[i]) >= 0) {
							isGPKI[i] = "N"
                            if (isfirst) {
								TempRecvList = AddInfo[i];
								isfirst = false;
                            } else {
								TempRecvList = TempRecvList + ", " + AddInfo[i];
							}													
							sendCNT[0] = sendCNT[0] - 1;
							sendCNT[1] = sendCNT[1] + 1;
						}
					}
					var pAlertContent = strLang189 + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
                } else {
					var pAlertContent = strLang191 + ObjGPKI.errorMsg;
					OpenAlertUI(pAlertContent);				
					rtnVal = false;
				}
			}
        } else if (is_Enc == "SIGN") {
			
            if (ObjGPKI.EncodeBySign(encodePath, ouCodes, encodePass, xmlhttp.responseText)) {
				var dday = ObjGPKI.errorMsg
                if (ObjGPKI.FailCertList != "") {
					var tempFailList = ObjGPKI.FailCertList;
					var isfirst = true;
					var TempRecvList = "";
                    for (i = 0; i < isGPKI.length; i++) {
                        if (tempFailList.indexOf(BaseURL[i]) >= 0) {
							isGPKI[i] = "N"
                            if (isfirst) {
								TempRecvList = AddInfo[i];
								isfirst = false;
                            } else {
								TempRecvList = TempRecvList + ", " + AddInfo[i];
							}													
							sendCNT[0] = sendCNT[0] - 1;
							sendCNT[1] = sendCNT[1] + 1;
						}
					}
					var pAlertContent = strLang189 + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
				}
				
				ObjGPKI.WriteResultFile("C:\\upload.p7m");
				var GPKIContent = objSave.DownloadToBase64("C:\\upload.p7m");
				
				
				var NewContents = makePKIHeader(GPKIContent);
				// 2018-08-25 sendExtDoc 함수 변경됨(클라이언트에서 Content를 넘겨주지 않고 서버에서 읽어서 처리). GPKI쪽 개발 시 참고!
				rtnVal = sendExtDoc(NewContents);
            } else {
                if (ObjGPKI.FailCertList != "") {
					var tempFailList = ObjGPKI.FailCertList;
					var isfirst = true;
					var TempRecvList = "";
                    for (i = 0; i < isGPKI.length; i++) {
                        if (tempFailList.indexOf(BaseURL[i]) >= 0) {
							isGPKI[i] = "N"
                            if (isfirst) {
								TempRecvList = AddInfo[i];
								isfirst = false;
                            } else {
								TempRecvList = TempRecvList + ", " + AddInfo[i];
							}													
							sendCNT[0] = sendCNT[0] - 1;
							sendCNT[1] = sendCNT[1] + 1;
						}
					}
					var pAlertContent = strLang189 + TempRecvList + "]" + strLang190;
					OpenAlertUI(pAlertContent);
                } else {
					var pAlertContent = strLang191 + ObjGPKI.errorMsg;
					OpenAlertUI(pAlertContent);
					rtnVal = false;
				}
			}
        } else {
			var pAlertContent = strLang192 + "<br>" + strLang193;
			OpenAlertUI(pAlertContent);
			rtnVal = false;
		}
    } else {

	}
	
	hideProgress();
	
	return rtnVal;
}

function makePKIHeader(psihangXML) {
	var ExtSNodes, Nodes, Nodes2, strTO, i;
	var isfirst;
	
	var ExtXML =  new ActiveXObject("Microsoft.XMLDOM");
	ExtXML.async = false;
	ExtXML.load("/myoffice/ezApprovalG/enforce/packXML.xml");
	
  try {	
	var objSave = new ActiveXObject("EzUtil.MiscFunc"); 
	var eNodes = ExtXML.documentElement;
	var Nodes = psihangXML.documentElement;
	

	var Nodes = eNodes.selectNodes("header/send-orgcode");
	setNodeText(Nodes(0) , companyID);
	
	var Nodes = eNodes.selectNodes("header/send-id");
	
	setNodeText(Nodes(0) , companyID);

	var Nodes = eNodes.selectNodes("header/send-name");
	
	setNodeText(Nodes(0) , objSave.EncodeBase64(companyName));
	
	isfirst = true;
        for (i = 0; i < isGPKI.length; i++) {
            if (isGPKI[i] == "Y") {
                if (isfirst) {
				strTO = BaseURL[i];
				isfirst = false;	
			}
			else
				strTO = strTO + ";" + BaseURL[i];
		}		
	}	
	
	var Nodes = eNodes.selectNodes("header/receive-id");
	setNodeText(Nodes(0) , strTO);

	var Nodes = eNodes.selectNodes("header/date");
	setNodeText(Nodes(0) , "");

	var Nodes = eNodes.selectNodes("header/title");
	setNodeText(Nodes(0) , objSave.EncodeBase64(getNodeText(pDocInfoXML.documentElement.childNodes(7))));

	var Nodes = eNodes.selectNodes("header/doc-id");
	
	
	setNodeText(Nodes(0) , pOrgDocID);

	var Nodes = eNodes.selectNodes("header/doc-type");
	if (pAprType == strLang186)
		Nodes(0).setAttribute("type", "resend");
	else
		Nodes(0).setAttribute("type", "send");
	Nodes(0).setAttribute("dept", objSave.EncodeBase64(getNodeText(pDocInfoXML.documentElement.childNodes(17))));
	Nodes(0).setAttribute("name", objSave.EncodeBase64(getNodeText(pDocInfoXML.documentElement.childNodes(14))));

	var Nodes = eNodes.selectNodes("header/send-gw");
	
	setNodeText(Nodes(0) , objSave.EncodeBase64("ezFlow2000/G"));

	var Nodes = eNodes.selectNodes("header/dtd-version");
	setNodeText(Nodes(0) , "2.0");

	var Nodes = eNodes.selectNodes("header/xsl-version");
	setNodeText(Nodes(0) , "2.0");
	

	var Nodes = eNodes.selectNodes("contents");
	var tempNode = sihangXML.createNode(1,"content","");
	Nodes(0).appendChild(tempNode);
	tempNode.setAttribute("content-role", "gpki");
	tempNode.setAttribute("filename", objSave.EncodeBase64("smime.p7m"));
	tempNode.setAttribute("content-transfer-encoding", "base64");
	if(is_Enc == "ENC")
		tempNode.setAttribute("content-type", "application/gcc-mime;smime-type=signedandenveloped-data;");
	else
            tempNode.setAttribute("content-type", "application/gcc-mime;smime-type=signed-data;");
	tempNode.setAttribute("charset", "euc-kr");
	setNodeText(tempNode , psihangXML);

	return ExtXML;
	
  } catch(e) {
	alert("makePKIHeader : " + e.description);
  }
}

function trim(parm_str) {
	return rtrim(ltrim(parm_str));
}
function ltrim(parm_str) {
	str_temp = parm_str ;
	while (str_temp.length != 0) {
		if (str_temp.substring(0, 1) == " ") {
			str_temp = str_temp.substring(1, str_temp.length) ;
		} else {
			return str_temp ;
		}
	}
return str_temp ;
}
function rtrim(parm_str) {
	str_temp = parm_str ;
	while (str_temp.length != 0) {
		int_last_blnk_pos = str_temp.lastIndexOf(" ");
		if ((str_temp.length - 1) == int_last_blnk_pos) {
			str_temp = str_temp.substring(0, str_temp.length - 1);
		} else {
			return str_temp;
		}
	}
return str_temp;
}