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

	pDocInfoXML = loadXMLString(result);
}

function getLineInfo() {
    var xmlpara = createXmlDom();
	var xmlhttp = createXMLHttpRequest();

	var objNode;
	createNodeInsert(xmlpara, objNode, "PARAMETERS"); 
	createNodeAndInsertText(xmlpara, objNode, "DocID", pOrgDocID);

	xmlhttp.open("Post","/ezApprovalG/getLineInfo.do",false);
	xmlhttp.send(xmlpara);
	
    return loadXMLString(xmlhttp.responseText);
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
    var pxToMm = function(str, p1, p2, p3, offset, s){
    	return p1 + (p2 * 0.264583) + "mm";
    }
    
    BodyStr = BodyStr.replace(/[^-]height='height:\d+'/ig, "");
    BodyStr = BodyStr.replace(/([^-]height:)(\d+)([\w?]*)/ig, pxToMm).replace(/(width:)(\d+)([\w?]*)/ig, pxToMm);
    BodyStr = BodyStr.replace(/(border-)(left|right|top|bottom):[\w\d\s#.(),]*;/g, "");
    
    BodyStr = BodyStr.replace(/(\?(\w)*?\w=)((')(\w*?)['])/ig, "$1$5$4");
    BodyStr = BodyStr.replace(/\n|\r|\t/g, "");
    
    var xmlpara = loadXMLString(BodyStr);
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
	
    if (message.FieldExist("opinions")) {
        if (message.FieldExist("body")) {
        	message.AppendFieldText("body", "<br><br>", false, true);
        	message.AppendFieldText("body", message.GetFieldText("opinions"), false);
        	message.SetFieldText("opinions", "");
		}
	}
	
	sihangXML = loadXMLFile("/xml/ezApprovalG/pubdocsample.xml");
	
	var eNodes = sihangXML.documentElement;
	
	var Nodes = eNodes.getElementsByTagName("organ");
    if (message.FieldExist("organ")) {
        setNodeText(Nodes.item(0) , message.GetFieldText("organ"));
    } else {
        setNodeText(Nodes.item(0) , "");
	}
	
	var Nodes = eNodes.getElementsByTagName("recipient");
    if (message.FieldExist("recipients")) {
        if (trim(message.GetFieldText("recipients")) == "") {
        	SetAttribute(Nodes[0], "refer", "false");
            if (message.FieldExist("recipient")) {
                tempNode = eNodes.getElementsByTagName("rec");
                setNodeText(tempNode.item(0) , message.GetFieldText("recipient"));
			}
        } else {
        	SetAttribute(Nodes[0], "refer", "true");
            tempNode = eNodes.getElementsByTagName("rec");
            setNodeText(tempNode.item(0) , message.GetFieldText("recipients").replace(strLang177, ""));
		}
	}
	
	var Nodes = eNodes.getElementsByTagName("receiptinfo");
    if (message.FieldExist("refer")) {
        if (trim(message.GetFieldText("refer")) != "") {
        	var objChildNodes;
			createNodeAndAppandNodeText(sihangXML, Nodes.item(0), objChildNodes, "via", trim_Cross(message.GetFieldText("refer")));
		}
	}
	
	var Nodes = eNodes.getElementsByTagName("title");
    if (message.FieldExist("doctitle")) {
        setNodeText(Nodes.item(0), trim_Cross(message.GetFieldText("doctitle")));
    } else {
        setNodeText(Nodes.item(0), "");
	}

	var Nodes = SelectNodes(eNodes, "body");
    if (attachbodyPath != "") {
    	SetAttribute(Nodes[0], "separate", "true");
    } else {
    	SetAttribute(Nodes[0], "separate", "false");	
	}
	
    var Nodes = SelectNodes(eNodes, "body");	
    if (message.FieldExist("body")) {
    	var strBody = HtmlBody;
		var pBody = Encode(strBody);
		
        if (pBody == "</ERROR>") {
            alert("본문에 잘못된 내용이 포함되어 있습니다.\n(이미지, 스타일속성 등을 포함할 수 없습니다.)");
            return;
        }

		var re = /vAlign=center/g;
		pBody = pBody.replace(re,"vAlign=middle");
		
		var rtnNodes = covBody(pBody);
        Nodes[0].appendChild(rtnNodes);
    } else {
        setNodeText(Nodes[0] , "");
	}
	
	var Nodes = eNodes.getElementsByTagName("sendername");
    if (message.FieldExist("chief")) {
    	setNodeText(Nodes.item(0), trim_Cross(message.GetFieldText("chief")));
    } else {
    	setNodeText(Nodes.item(0), "");
	}

    if (message.FieldExist("sealsign")) {
        sealPath = GetDocumentElement("surl", false);
        if (sealPath != "") {
	        var Nodes = eNodes.getElementsByTagName("seal");
            if (NostampFlag) {
                SetAttribute(Nodes[0], "omit", "true");
            } else {
                SetAttribute(Nodes[0], "omit", "false");
            }
            
            var tempNode2; 
            tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "img", "")
            
            var len = sealPath.lastIndexOf("/");
            var filelength = sealPath.length - (len + 1);  
            
            sealName = sealPath.substr(len + 1, filelength);
            SetAttribute(tempNode2, "src", trim_Cross(sealName));
            SetAttribute(tempNode2, "alt", strLang178);
            SetAttribute(tempNode2, "height", GetDocumentElement("sheight", false) + "mm");
            SetAttribute(tempNode2, "width", GetDocumentElement("swidth", false) + "mm");
        }
    }

	var Nodes = eNodes.getElementsByTagName("approvalinfo");
	var LineNode = getLineInfo();
	var SignSN = 1;
	psignCount = 1;
	var DekyulFlag = false;

	var LineNodes = SelectNodes(LineNode, "APPROVAL");
    for (i = 0; i < LineNodes.length; i++) {
        if (getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)) != strLang3) {
        	var tempNode2;
			tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "approval", "");
			SetAttribute(tempNode2, "order", getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)));

			var tempNode3;
			tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "signposition", "");
			if (getNodeText(LineNodes.item(i).getElementsByTagName("OPINION").item(0)) == "YES")
				setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("SIGNPOSITION").item(0)) + "(" + strLang5);
			else
				setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("SIGNPOSITION").item(0)));

			var tempNode3;
			tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "type", "");
			setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)));

			if (getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)) == strLang7)
				DekyulFlag = true;
			
			if ((getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)) == strLang6) && (DekyulFlag)) {
				var tempNode3;
				tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
				setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));

				tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "date", "");
			} else {
                if (message.FieldExist("sign" + SignSN)) {
					var signPath = GetDocumentElement("sign" + SignSN, false);
							
                    if (!!signPath) {
                    	var tempNode3;
						tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "signimage", "");

						var tempNode4;
						tempNode4 = createNodeAndAppandNodeText(sihangXML, tempNode3, tempNode4, "img", "");
						
						var len = signPath.lastIndexOf("/");
						var filelength = signPath.length - (len + 1);  
						var signName = signPath.substr(len + 1,filelength);

						SetAttribute(tempNode4, "src", sealName);
						SetAttribute(tempNode4, "alt", strLang179);
								
						// 웹한글기안기는 GetCloneData 비동기 호출 필요하여 symbolurl에 Attribute에서 가져옴
                        /*var tempSize = GetHTMLBody(message.GetCloneData("sign" + SignSN, "HTML"));
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
                            tempNode4.setAttribute("height", tmpH + "mm");*/
						SetAttribute(tempNode4, "width", signwidth + "mm"); 
						SetAttribute(tempNode4, "height", signheight + "mm");
								
						psignName[psignCount] = signName;
						psignPath[psignCount] = signPath;
						psignCount = psignCount + 1;

					}
                    var tempNode3;
					tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
					setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));
                } else {
                	var tempNode3;
					tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
					setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));
				}
				
                var tempNode3;
				tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "date", "");
				
				if (getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)) == "final" || DekyulFlag) {
					setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("DATE").item(0)));
				} else
				    setNodeText(tempNode3, "");
			}			
			SignSN = SignSN + 1;
		}
	}

    for (i = 0; i < LineNodes.length; i++) {
		var SignSN = 1;
		if (getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)) == strLang3) {
			var tempNode2;
			tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "assist", "");
			SetAttribute(tempNode2, "order", getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)));

			/*var tempNode3 = sihangXML.createNode(1,"signposition","");
			tempNode2.appendChild(tempNode3);
//			if (getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/OPINION").item(i)) == "YES")
//			    setNodeText(tempNode3 , getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/SIGNPOSITION").item(i)) + "(" + strLang5);
//			else
//			    setNodeText(tempNode3 , getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/SIGNPOSITION").item(i)));

			setNodeText(tempNode3 , getNodeText(LineNode.getElementsByTagName("APPROVALINFO/APPROVAL/SIGNPOSITION").item(i)));*/
			var tempNode3;
			tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "signposition", "");
			
			var tempNode3;
			tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "type", "");
			setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)));
			

            if (message.FieldExist("habyuisign" + SignSN)) {
				var signPath = GetDocumentElement("habyuisign" + SignSN, false);
				
                if (signPath != "") {
                	var tempNode3;
					tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "signimage", "");

					var tempNode4;
					tempNode4 = createNodeAndAppandNodeText(sihangXML, tempNode3, tempNode4, "img", "");
					
					var len = signPath.lastIndexOf("/");
					var filelength = signPath.length - (len + 1);  
					var signName = signPath.substr(len + 1,filelength);
					
					tempNode4.setAttribute("src",signName);
					tempNode4.setAttribute("alt", strLang179 );

					// 웹한글기안기는 GetCloneData 비동기 호출 필요하여 symbolurl에 Attribute에서 가져옴
					//var tempSize = GetImgSize(GetHTMLBody(message.GetCloneData("habyuisign" + SignSN, "HTML")));
					
                    /*var tempSize = GetHTMLBody(message.GetCloneData("habyuisign" + SignSN, "HTML"));
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
                        tempNode4.setAttribute("height", tmpH + "mm");*/
					SetAttribute(tempNode4, "width", signwidth + "mm");
					SetAttribute(tempNode4, "height", signheight + "mm");
					
					psignName[psignCount] = signName;
					psignPath[psignCount] = signPath;
					psignCount = psignCount + 1;
                } else {
                	var tempNode3;
					tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
					setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));
				}
            } else {
            	var tempNode3;
				tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
				setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));
			}
			
            var tempNode3;
			tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "date", "");
			
			SignSN = SignSN + 1;
		}
	}
	
	var Nodes = eNodes.getElementsByTagName("regnumber");
    if (message.FieldExist("docnumber")) {

    	setNodeText(Nodes[0], trim_Cross(message.GetFieldText("docnumber")));
		
		var regnumbercode;
		regnumbercode = getNodeText(pDocInfoXML.documentElement.childNodes[32]);
		// regnumbercode 에 유통코드 붙이기 위해 추가  : 유통코드 + 일련번호
		var relayRegnumberCode = companyID + regnumbercode.substring(regnumbercode.length - 6, regnumbercode.length);
		
		SetAttribute(Nodes[0], "regnumbercode", relayRegnumberCode);
    } else {
    	setNodeText(Nodes[0], "");
		SetAttribute(Nodes[0], "regnumbercode", "");
	}
	
	var Nodes = eNodes.getElementsByTagName("enforcedate");
    if (message.FieldExist("enforcedate")) {
    	setNodeText(Nodes.item(0), trim_Cross(message.GetFieldText("enforcedate")));
    } else {
    	setNodeText(Nodes.item(0), "");
	}

	var Nodes = eNodes.getElementsByTagName("processinfo");

	var Nodes = eNodes.getElementsByTagName("sendinfo");
    if (message.FieldExist("zipcode")) {
    	var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "zipcode", "");
		setNodeText(tempNode2, trim_Cross(message.GetFieldText("zipcode")));
    } else {
    	var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "zipcode", "");
		setNodeText(tempNode2, "");
	}
	
	var Nodes = eNodes.getElementsByTagName("sendinfo");
    if (message.FieldExist("address")) {
    	var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "address", "");
		setNodeText(tempNode2, trim_Cross( message.GetFieldText("address")));
    } else {
    	var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "address", "");
		setNodeText(tempNode2, "");
	}

	var Nodes = eNodes.getElementsByTagName("sendinfo");
    if (message.FieldExist("homepage")) {
    	var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "homeurl", "");
		setNodeText(tempNode2, trim_Cross(message.GetFieldText("homepage")));
	}
	
	var Nodes = eNodes.getElementsByTagName("sendinfo");
    if (message.FieldExist("telephone")) {
    	var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "telephone", "");
		setNodeText(tempNode2, trim_Cross(message.GetFieldText("telephone")));
    } else {
    	var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "telephone", "");
		setNodeText(tempNode2,  "");
	}
	
	var Nodes = eNodes.getElementsByTagName("sendinfo");
    if (message.FieldExist("fax")) {
    	var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "fax", "");
		setNodeText(tempNode2, trim_Cross(message.GetFieldText("fax")));
    } else {
    	var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "fax", "");
		setNodeText(tempNode2, "");
	}
	
	var Nodes = eNodes.getElementsByTagName("sendinfo");
    if (message.FieldExist("email")) {
    	var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "email", "");
		setNodeText(tempNode2, trim_Cross(message.GetFieldText("email")));
	}
	
	var Nodes = eNodes.getElementsByTagName("sendinfo");
    if (message.FieldExist("publication")) {
    	var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "publication", "");
		SetAttribute(tempNode2, "code", getNodeText(pDocInfoXML.getElementsByTagName("PUBLICITYCODE").item(0)));
		setNodeText(tempNode2, trim_Cross( message.GetFieldText("publication")));	
    } else {
    	var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "publication", "");
		setNodeText(tempNode2, "");
		SetAttribute(tempNode2, "code", getNodeText(pDocInfoXML.getElementsByTagName("PUBLICITYCODE").item(0)));
	}

	var Nodes = eNodes.getElementsByTagName("sendinfo");
	//한글기안기 심볼, 로고 이미지 경로 하드코딩 추후 유동적으로 사용할 수 있도록 수정필요 2019-11-25 홍대표.
	//로고와 심볼 파일을 ex) fileroot/0/files/upload_approvalG\Top/ 에 위치시킴
	SetDocumentElement("symbolurl", "");
    if (message.FieldExist("symbol")) {
		symbolName = GetDocumentElement("symbolurl", false);
		
        if (symbolName != "") {
        	var tempNode2;
			tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "symbol", "");

			var tempNode3;
			tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "img", "");
			
			symbolPath = approvalRoot + symbolName;
			tempNode3.setAttribute("src", symbolName);
			tempNode3.setAttribute("alt", strLang180);
				
			// 웹한글기안기는 GetCloneData 비동기 호출 필요하여 symbolurl에 Attribute에서 가져옴
            /*var tempSize = GetHTMLBody(message.GetCloneData("symbol", "HTML"));
            var tmpDiv = document.createElement("div");
            tmpDiv.innerHTML = tempSize;
            var tmpH = PixelToMillimeter(GetAttribute(tmpDiv.getElementsByTagName("IMG")[0], 'height'));
            var tmpW = PixelToMillimeter(GetAttribute(tmpDiv.getElementsByTagName("IMG")[0], 'width'));*/
			
			var docinfo = message.GetDocumentInfo(true);
			var infoXml = loadXMLString(docinfo);
			var node = GetElementsByTagName(infoXml, "symbolurl");
			var tmpW = GetAttribute(node[0], "width");
			var tmpH = GetAttribute(node[0], "height");
			
			if (tmpW == null || tmpW == "")
				SetAttribute(tempNode3, "width", "29.13mm");
			else
				SetAttribute(tempNode3, "width", tmpW + "mm");

			if (tmpH == null || tmpH == "")
				SetAttribute(tempNode3, "height", "5.93mm");				
			else
				SetAttribute(tempNode3, "height", tmpH + "mm");
		}
	}

	var Nodes = eNodes.getElementsByTagName("sendinfo");
	//한글기안기 심볼, 로고 이미지 경로 하드코딩 추후 유동적으로 사용할 수 있도록 수정필요 2019-11-25 홍대표.
	//로고와 심볼 파일을 ex) fileroot/0/files/upload_approvalG\Top/ 에 위치시킴
	SetDocumentElement("logourl", "logo.png");
    if (message.FieldExist("logo")) {
		logoName = GetDocumentElement("logourl", false);
		
        if (logoName != "") {
        	var tempNode2;
			tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "logo", "");
			
			var tempNode3;
			tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "img", "");
			
			logoPath = approvalRoot + logoName;
			SetAttribute(tempNode3, "src", logoName);
			SetAttribute(tempNode3, "alt", strLang181);
					
			// 웹한글기안기는 GetCloneData 비동기 호출 필요하여 symbolurl에 Attribute에서 가져옴
            /*var tempSize = GetHTMLBody(message.GetCloneData("logo", "HTML"));
            var tmpDiv = document.createElement("div");
            tmpDiv.innerHTML = tempSize;
            var tmpH = PixelToMillimeter(GetAttribute(tmpDiv.getElementsByTagName("IMG")[0], 'height'));
            var tmpW = PixelToMillimeter(GetAttribute(tmpDiv.getElementsByTagName("IMG")[0], 'width'));*/
			
			var docinfo = message.GetDocumentInfo(true);
			var infoXml = loadXMLString(docinfo);
			var node = GetElementsByTagName(infoXml, "logourl");
			var tmpW = GetAttribute(node[0], "width");
			var tmpH = GetAttribute(node[0], "height");

			if (tmpW == null || tmpW == "")
				SetAttribute(tempNode3, "width", "19.05mm");
			else
				SetAttribute(tempNode3, "width", tmpW + "mm");

			if (tmpH == null || tmpH == "")
				SetAttribute(tempNode3, "height", "8.68mm");
			else
				SetAttribute(tempNode3, "height", tmpH + "mm");
		}
	}
	
    if (message.FieldExist("headcampaign")) {
    	var Nodes = eNodes.getElementsByTagName("foot");
		var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "campaign", "");

		var tempNode3;
		tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "headcampaign", "");
		setNodeText(tempNode3, message.GetFieldText("headcampaign"));
		
        if (message.FieldExist("footcampaign")) {
        	var tempNode3;
			tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "footcampaign", trim_Cross(message.GetFieldText("footcampaign")));
		}		
    } else {
        if (message.FieldExist("footcampaign")) {
        	var tempNode2;
			tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "campaign", "");

			var tempNode3;
			tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "footcampaign", trim_Cross(message.GetFieldText("footcampaign")));
		}
	}

	
    if (attachName.length > 0) {
    	var tempNode2;
		tempNode2 = createNodeAndAppandNodeText(sihangXML, eNodes, tempNode2, "attach", "");
		
		var i;
        for (i = 0; i < attachName.length; i++) {
        	var tempNode3;
			tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "title", attachName[i]);
		}
	}
	
	var sihangXML2 = sihangXML;
	var strtempxml = getXmlString(sihangXML2);
	
	var re = /&amp;nbsp;/g; 
    var strtempxml = strtempxml.replace(re, "&nbsp;");
    var re = /&nbsp;/g;
    strtempxml = strtempxml.replace(re, " ");
	var re = /strong>/g; 
    var strtempxml = strtempxml.replace(re, "b>");
    var re = /\r|\n|\t/g;
	strtempxml = strtempxml.replace(re, "");
	var re = /\"/g;
	strtempxml = strtempxml.replace(re, "'");
	strtempxml = strtempxml.replace(/​/g, "");
	strtempxml = strtempxml.trim();
	sihangXML = loadXMLString(strtempxml);
	
    var SaveDocHTTp = createXMLHttpRequest();
    SaveDocHTTp.open("POST", "/ezApprovalG/simsaGUpload.do?docID=" + pDocID, false);
    SaveDocHTTp.send(sihangXML);
    
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
    
	var ExtXML = loadXMLFile("/xml/ezApprovalG/packXML.xml");
	
  try {
	var eNodes = ExtXML.documentElement;
	var Nodes = psihangXML.documentElement;
	
        
	var Nodes = SelectNodes(eNodes, "header/send-orgcode");
	setNodeText(Nodes[0], companyID);
	
	var Nodes = SelectNodes(eNodes, "header/send-id");
	setNodeText(Nodes[0], companyID);
	
	var Nodes = SelectNodes(eNodes, "header/send-name");
	setNodeText(Nodes[0], companyName);
	
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
	
        
	var Nodes = SelectNodes(eNodes, "header/receive-id");
	setNodeText(Nodes[0], strTO);
        
	var Nodes = SelectNodes(eNodes, "header/date");
	setNodeText(Nodes[0], "");
        
	var Nodes = SelectNodes(eNodes, "header/title");
	setNodeText(Nodes[0], getNodeText(GetChildNodes(GetChildNodes(pDocInfoXML)[0])[7]));
        
	var Nodes = SelectNodes(eNodes, "header/doc-id");
	setNodeText(Nodes[0], pOrgDocID);
        
	var Nodes = SelectNodes(eNodes, "header/doc-type");
	if (pAprType == strLang186)
		SetAttribute(Nodes[0], "type", "resend");
	else
		SetAttribute(Nodes[0], "type", "send");

        
	SetAttribute(Nodes[0], "dept", getNodeText(GetChildNodes(GetChildNodes(pDocInfoXML)[0])[17]));
        
	SetAttribute(Nodes[0], "name", getNodeText(GetChildNodes(GetChildNodes(pDocInfoXML)[0])[14]));

        
	var Nodes = SelectNodes(eNodes,"header/send-gw");
	setNodeText(Nodes[0], "ezFlow2000/G");

        
	var Nodes = SelectNodes(eNodes, "header/dtd-version");
	setNodeText(Nodes[0], "2.0");

        
	var Nodes = SelectNodes(eNodes, "header/xsl-version");
	setNodeText(Nodes[0], "2.0");
	
	var Nodes = eNodes.getElementsByTagName("contents");
	var tempNode = createNode(sihangXML, "content");
	Nodes[0].appendChild(tempNode);
	
	SetAttribute(tempNode, "content-role", "pubdoc");
	SetAttribute(tempNode, "filename", "pubdoc.xml");
	SetAttribute(tempNode, "content-transfer-encoding", "base64");
	SetAttribute(tempNode, "content-type", "text/xml");
	SetAttribute(tempNode, "charset", "euc-kr");
	
	var strtempxml = getXmlString(psihangXML);
	var re = /&amp;nbsp;/g; 
	var strtempxml = strtempxml.replace(re,"&nbsp;")
	var re = /strong>/g; 
	var strtempxml = strtempxml.replace(re,"b>")
    strtempxml = strtempxml.replace(/&amp;/g, "&amp;amp;").replace(/&lt;/g, "&amp;lt;").replace(/&gt;/g, "&amp;gt;");
	setNodeText(tempNode , "<?xml version=\"1.0\" encoding=\"euc-kr\"?><?xml-stylesheet type=\"text/xsl\" href=\"siheng.xsl\"?><!DOCTYPE pubdoc SYSTEM \"pubdoc.dtd\">" + strtempxml);
	
        
    if (sealName != "") {
    	var Nodes = SelectNodes(eNodes, "contents");
		var tempNode = createNode(sihangXML, "content");
		Nodes[0].appendChild(tempNode);
		
		SetAttribute(tempNode, "content-role", "seal");
		SetAttribute(tempNode, "filename", sealName);
		SetAttribute(tempNode, "content-transfer-encoding", "base64");
		SetAttribute(tempNode, "content-type", "");
		SetAttribute(tempNode, "charset", "euc-kr");
		setNodeText(tempNode, sealPath.replace(pDomainName, ""));
	}	
	
        
    for (i = 0; i < attachName.length; i++) {
    	var Nodes = SelectNodes(eNodes, "contents");
    	var tempNode = createNode(sihangXML, "content");
		Nodes[0].appendChild(tempNode);
		if (attachType[i] == "Y")
			SetAttribute(tempNode, "content-role", "attach_body");
		else
			SetAttribute(tempNode, "content-role", "attach");
		
		SetAttribute(tempNode, "filename", attachName[i]);
		SetAttribute(tempNode, "content-transfer-encoding", "base64");
		SetAttribute(tempNode, "content-type", "");
		SetAttribute(tempNode, "charset", "euc-kr");
		setNodeText(tempNode, attachPath[i]);
	}
	
    if (attachxmlPath != "") {
    	var Nodes = SelectNodes(eNodes, "contents");
		var tempNode = createNode(sihangXML, "content");
		Nodes[0].appendChild(tempNode);
		
		SetAttribute(tempNode, "content-role", "attach_xml");
		SetAttribute(tempNode, "filename", attachxmlName);
		SetAttribute(tempNode, "content-transfer-encoding", "base64");
		SetAttribute(tempNode, "content-type", "html/xml");
		SetAttribute(tempNode, "charset", "euc-kr");
		setNodeText(tempNode, attachxmlPath);
	}

    if (attachxslPath != "") {
    	var Nodes = SelectNodes(eNodes, "contents");
		var tempNode = createNode(sihangXML, "content");
		Nodes[0].appendChild(tempNode);
		
		SetAttribute(tempNode, "content-role", "attach_xsl");
		SetAttribute(tempNode, "filename", attachxslName);
		SetAttribute(tempNode, "content-transfer-encoding", "base64");
		SetAttribute(tempNode, "content-type", "html/xsl");
		SetAttribute(tempNode, "charset", "euc-kr");
		setNodeText(tempNode, attachxslPath);
	}
		
        
    for (i = 1; i < psignCount; i++) {
    	var Nodes = SelectNodes(eNodes, "contents");
		var tempNode = createNode(sihangXML, "content");
		Nodes[0].appendChild(tempNode);
		
		SetAttribute(tempNode, "content-role", "sign");
		SetAttribute(tempNode, "filename", psignName[i]);
		SetAttribute(tempNode, "content-transfer-encoding", "base64");
		SetAttribute(tempNode, "content-type", "");
		SetAttribute(tempNode, "charset", "euc-kr");
		setNodeText(tempNode, psignPath[i]);
	}
	
        
    if (symbolName != "") {
    	var Nodes = SelectNodes(eNodes, "contents");
		var tempNode = createNode(sihangXML, "content");
		Nodes[0].appendChild(tempNode);
		
		SetAttribute(tempNode, "content-role", "symbol");
		SetAttribute(tempNode, "filename", symbolName);
		SetAttribute(tempNode, "content-transfer-encoding", "base64");
		SetAttribute(tempNode, "content-type", "");
		SetAttribute(tempNode, "charset", "euc-kr");
		setNodeText(tempNode, symbolPath.replace(pDomainName, ""));
	}	
        
    if (logoName != "") {
    	var Nodes = SelectNodes(eNodes, "contents");
		var tempNode = createNode(sihangXML, "content");
		Nodes[0].appendChild(tempNode);
		
		SetAttribute(tempNode, "content-role", "logo");
		SetAttribute(tempNode, "filename", logoName);
		SetAttribute(tempNode, "content-transfer-encoding", "base64");
		SetAttribute(tempNode, "content-type", "");
		SetAttribute(tempNode, "charset", "euc-kr");
		setNodeText(tempNode, logoPath.replace(pDomainName, ""));
	}			
	return ExtXML;
	
  } catch(e) {
	alert("makeExtinfo : " + e);
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
	
	var ExtXML = createXmlDom();
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