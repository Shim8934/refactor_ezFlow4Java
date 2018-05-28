function OpenCheckUI() {
    return "NONE";
}

function getPasswdEnd() {
    var url = "/myoffice/ezApprovalG/enforce/cert.aspx";
	var feature = "status:no;dialogWidth:420px;dialogHeight:350px;help:no;scroll:no"
	var param = true;
	var ret = window.showModalDialog(url,param,feature);
		
    if (ret[0]) {
		encodePass = ret[1];
		encodePath = ret[2];	
	}		
	return ret[0];
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
    pbody = removeTags(pbody, '<caption><img><i><b><u><sub><sup><p><ul><ol><table><tr><td>');

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
	var re = /&nbsp;/g; 
	var BodyStr = "<content>" + newSTR.replace(re,"&amp;nbsp;") + "</content>";
	
	BodyStr = BodyStr.replace(/: '/g,":");
	BodyStr = BodyStr.replace(/'' /g,"' ");
	BodyStr = BodyStr.replace(/''>/g,"'>");
	BodyStr = BodyStr.replace(/'; /g,"; ");
	BodyStr = BodyStr.replace(/<br>/g,"");
    
    BodyStr = BodyStr.replace(/<BR>/g, "");
    BodyStr = BodyStr.replace(/class=hstyle0/g, "");
    BodyStr = BodyStr.replace(/''font-size:'/g, "'font-size:");
    
    BodyStr = BodyStr.replace(/''margin-bottom:'/g, "'margin-bottom:");
    BodyStr = BodyStr.replace(/='>/g, "=''>");
    BodyStr = BodyStr.replace(/=''/g, "='");
    BodyStr = BodyStr.replace(/:'  '/g, ":");
    
    //BodyStr = BodyStr.replace(/width="(.*?)[0-9]*/ig, " $&mm");
    //BodyStr = BodyStr.replace(/width='(.*?)[0-9]*/ig, " $&mm");
    //BodyStr = BodyStr.replace(/hight="(.*?)[0-9]*/ig, " $&mm");
    //BodyStr = BodyStr.replace(/hight='(.*?)[0-9]*/ig, " $&mm");
    
    BodyStr = BodyStr.replace(/(\?(\w)*?\w=)((')(\w*?)['])/ig, "$1$5$4");

    BodyStr = BodyStr.replace(/\n|\r|\t/g, "");

	//var xmlpara = createXmlDom();
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

function setNodeTextHwp(node, value) {
    if (typeof (node.innerText) == "undefined") {
        node.text = value;
    } else {
        node.innerText = value;
    }
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
	
	//sihangXML = createXmlDom();
    //var sihangXML;
	//sihangXML.async = false;
	//sihangXML.load("/xml/ezApprovalG/pubdocsample.xml");
	var xmlhttp;
	xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	xmlhttp.open("GET", "/xml/ezApprovalG/pubdocsample.xml", false);
    xmlhttp.send();
    
    var xmlDoc;
    xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
    xmlDoc.async = "false";
    xmlDoc.loadXML(xmlhttp.responseText);
    
    sihangXML = loadXMLFile("/xml/ezApprovalG/pubdocsample.xml");
	var eNodes = xmlDoc;
    //var eNodes = 
 
    var Nodes = eNodes.selectNodes("head/organ");
    if (HwpCtrl.CheckFieldExist("organ")) {
        //setNodeText(Nodes.item(0) , HwpCtrl.GetFieldText("organ"));
    	//HwpCtrl.SetFieldText(Nodes(0), HwpCtrl.GetFieldText("organ"));
        HwpCtrl.SetFieldText("organ", getNodeText(Nodes(0)));
    	
    } else {
        //setNodeText(Nodes(0) , "");
    	HwpCtrl.SetFieldText("", getNodeText(Nodes(0)));
	}
	
	var Nodes = eNodes.selectNodes("head/receiptinfo/recipient");
    if (HwpCtrl.CheckFieldExist("recipients")) {
        if (trim(HwpCtrl.GetFieldText("recipients")) == "") {
			//Nodes(0).setAttribute("refer", "false");
			SetAttribute(Nodes(0),"refer","false");
            if (HwpCtrl.CheckFieldExist("recipient")) {
                tempNode = eNodes.selectNodes("head/receiptinfo/recipient/rec");
                //setNodeText(tempNode(0) , HwpCtrl.GetFieldText("recipient"));
                HwpCtrl.SetFieldText(HwpCtrl.GetFieldText("recipient"), getNodeText(tempNode(0)));
			}
        } else {
			Nodes(0).setAttribute("refer", "true");	
            tempNode = eNodes.selectNodes("head/receiptinfo/recipient/rec");
            //setNodeText(tempNode(0) , HwpCtrl.GetFieldText("recipients").replace(strLang177, ""));
            
            HwpCtrl.SetFieldText(HwpCtrl.GetFieldText("recipients").replace(strLang177, ""), getNodeText(tempNode(0)));
            
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
        //setNodeText(Nodes(0) , HwpCtrl.GetFieldText("doctitle"));
    	HwpCtrl.SetFieldText(HwpCtrl.GetFieldText("doctitle"), getNodeText(Nodes(0)));
    } else {
        setNodeText(Nodes(0) , "");
	}

	var Nodes = eNodes.selectNodes("body");	
    if (attachbodyPath != "") {
		//Nodes(0).setAttribute("separate", "true");
    	SetAttribute(Nodes(0),"separate","true");
    } else {
		//Nodes(0).setAttribute("separate", "false");
    	SetAttribute(Nodes(0),"separate","false");
	}
	
	//var Nodes = eNodes.selectNodes("body");	
    var Nodes = eNodes.getElementsByTagName("body");
    if (HwpCtrl.CheckFieldExist("body")) {
		var strBody = GetHTMLBody(HwpCtrl.GetCloneData("body", "HTML"));
		var pBody = Encode(strBody);
		
        if (pBody == "</ERROR>") {
            alert("본문에 잘못된 내용이 포함되어 있습니다.\n(이미지, 스타일속성 등을 포함할 수 없습니다.)");
            return;
        }

		var re = /vAlign=center/g;
		pBody = pBody.replace(re,"vAlign=middle");
		
		pBody = covBody(pBody); 
        Nodes[0].appendChild(pBody);
    } else {
        setNodeText(Nodes(0) , "");
	}
	
	var Nodes = eNodes.selectNodes("foot/sendername");
    if (HwpCtrl.CheckFieldExist("chief")) {
        //setNodeText(Nodes(0) , HwpCtrl.GetFieldText("chief"));
    	HwpCtrl.SetFieldText(HwpCtrl.GetFieldText("chief"), getNodeText(Nodes(0)));
    } else {
        setNodeText(Nodes(0) , "");
	}

	var Nodes = eNodes.selectNodes("foot/seal");
    if (NostampFlag) {
		//Nodes(0).setAttribute("omit", "true");
    	SetAttribute(Nodes(0),"omit","true");
    } else {
        if (HwpCtrl.CheckFieldExist("sealsign")) {
			sealPath = GetDocumentElement(HwpCtrl, "surl");
            if (sealPath != "") {
				//Nodes(0).setAttribute("omit", "false");
            	SetAttribute(Nodes(0),"omit","false");
				var tempNode2 = sihangXML.createNode(1,"img","")
				Nodes(0).appendChild(tempNode2)
				
				var len = sealPath.lastIndexOf("/");
				var filelength = sealPath.length - (len + 1);  
				
				sealName = sealPath.substr(len + 1,filelength);
				/*tempNode2.setAttribute("src",sealName)
                tempNode2.setAttribute("alt", strLang178);
				tempNode2.setAttribute("height", GetDocumentElement(HwpCtrl, "sheight").toString() + "mm");
				tempNode2.setAttribute("width", GetDocumentElement(HwpCtrl, "swidth").toString() + "mm");*/
				
				SetAttribute(tempNode2,"src",sealName);
				SetAttribute(tempNode2,"alt",strLang178);
				SetAttribute(tempNode2,"height",GetDocumentElement(HwpCtrl, "sheight").toString() + "mm");
				SetAttribute(tempNode2,"width",GetDocumentElement(HwpCtrl, "swidth").toString() + "mm");
			}
		}
	}

	//var Nodes = eNodes.selectNodes("foot/approvalinfo");
    sihangXML = loadXMLFile("/xml/ezApprovalG/pubdocsample.xml");
    var eNodes = sihangXML.documentElement;
    var Nodes = eNodes.getElementsByTagName("approvalinfo");
	var LineNode = getLineInfo();
	var SignSN = 1;
	psignCount = 1;
	var DekyulFlag = false;
	var LineNodes = SelectNodes(LineNode, "APPROVALINFO/APPROVAL");
	
   /* for (i = 0; i < LineNode.documentElement.childNodes.length; i++) {
        if (getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("TYPE")) != strLang3) {
			var tempNode2 = sihangXML.createNode(1,"approval","");
			Nodes(0).appendChild(tempNode2);
			tempNode2.setAttribute("order", getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("ORDER")));
			
			var tempNode3 = sihangXML.createNode(1,"signposition","");
			tempNode2.appendChild(tempNode3);
			if (getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("OPINION")) == "YES")
			    setNodeText(tempNode3 , getNodeText(LineNode.documentElement.childNodes(i).selectSingleNode("SIGNPOSITION")) + "(" + strLang5);
			else
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
	} */
	
	for (i = 0; i < LineNodes.length; i++) {
        if (getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)) != strLang3) {
            var tempNode2;
            tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "approval", "");
            tempNode2.setAttribute("order", getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)));

            var tempNode3;
            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "signposition", "");
            if (getNodeText(LineNodes.item(i).getElementsByTagName("OPINION").item(0)) == "YES")
                setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("SIGNPOSITION").item(0)));
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
            }
            else {
                if (HwpCtrl.CheckFieldExist("sign" + SignSN)) {
                	var signPath = GetDocumentElement(HwpCtrl, "sign" + SignSN);
                    if (signPath != "") {
                        var imageflag = true;
                        for (j = 0; j < field.childNodes.length; j++) {
                            if (imageflag && field.childNodes.item(j).tagName == "IMG") {
                                var tempNode3;
                                tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "signimage", "");

                                var tempNode4;
                                tempNode4 = createNodeAndAppandNodeText(sihangXML, tempNode3, tempNode4, "img", "");

                                var signPath = imageflag && GetAttribute(field.childNodes.item(j),"spath");
                                var len = signPath.lastIndexOf("/");
                                var filelength = signPath.length - (len + 1);
                                var signName = signPath.substr(len + 1, filelength);
                                tempNode4.setAttribute("src", signName)
                                tempNode4.setAttribute("alt", strLang179)
                                tempNode4.setAttribute("height", Conversion(field.childNodes.item(j).height).toString() + "mm")
                                tempNode4.setAttribute("width", Conversion(field.childNodes.item(j).width).toString() + "mm")

                                psignName[psignCount] = signName;
                                psignPath[psignCount] = signPath;
                                psignCount = psignCount + 1;
                                imageflag = false;
                            }
                        }
                        var tempNode3;
                        tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
                        setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));
                    }
                    else {
                        var tempNode3;
                        tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
                        setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));
                    }
                }
                else {
                    var tempNode3;
                    tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "name", "");
                    setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("NAME").item(0)));

                }
                var tempNode3;
                tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "date", "");

                if (getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)) == "final" || DekyulFlag)
                    setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("DATE").item(0)));
            }
            SignSN = SignSN + 1;
        }
    }

    for (i = 0; i < LineNode.documentElement.childNodes.length; i++) {
		var SignSN = 1;
		if (getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)) == strLang3) {
			/*var tempNode2 = sihangXML.createNode(1,"assist","");
			Nodes(0).appendChild(tempNode2);
			tempNode2.setAttribute("order",getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/ORDER").item(i)))*/
			var tempNode2;
            tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "assist", "");
            tempNode2.setAttribute("order", getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)));
			
			/*var tempNode3 = sihangXML.createNode(1,"signposition","");
			tempNode2.appendChild(tempNode3);
			if (getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/OPINION").item(i)) == "YES")
			    setNodeText(tempNode3 , getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/SIGNPOSITION").item(i)) + "(" + strLang5);
			else
			    setNodeText(tempNode3 , getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/SIGNPOSITION").item(i)));*/
            var tempNode3;
            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "signposition", "");
            if (getNodeText(LineNodes.item(i).getElementsByTagName("OPINION").item(0)) == "YES")
                setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)));
            else
                setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("ORDER").item(0)));
            
			/*var tempNode3 = sihangXML.createNode(1,"type","");
			tempNode2.appendChild(tempNode3);
			setNodeText(tempNode3 , getNodeText(LineNode.selectNodes("APPROVALINFO/APPROVAL/TYPE").item(i)));*/
            var tempNode3;
            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "type", "");
            setNodeText(tempNode3, getNodeText(LineNodes.item(i).getElementsByTagName("TYPE").item(0)));
            
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
	
	//var Nodes = eNodes.selectNodes("foot/processinfo/regnumber");
    var Nodes = eNodes.getElementsByTagName("regnumber");
    if (HwpCtrl.CheckFieldExist("docnumber")) {

        setNodeText(Nodes(0) , HwpCtrl.GetFieldText("docnumber"));
        Nodes.item(0).setAttribute("regnumbercode", getNodeText(pDocInfoXML.getElementsByTagName("DOCNUMCODE").item(0)));
        
		//var regnumbercode;
		//regnumbercode = getNodeText(pDocInfoXML.documentElement.childNodes(32));
		//Nodes(0).setAttribute("regnumbercode", regnumbercode);
    } else {
        setNodeText(Nodes(0) , "");
		Nodes(0).setAttribute("regnumbercode", "");
	}
	
	//var Nodes = eNodes.selectNodes("foot/processinfo/enforcedate");
    var Nodes = eNodes.getElementsByTagName("enforcedate");
    if (HwpCtrl.CheckFieldExist("enforcedate")) {
        setNodeText(Nodes(0) , HwpCtrl.GetFieldText("enforcedate"));
    } else {
        setNodeText(Nodes(0) , "");
	}

	//var Nodes = eNodes.selectNodes("foot/processinfo");
    var Nodes = eNodes.getElementsByTagName("processinfo");
    if (HwpCtrl.CheckFieldExist("receiptnumber")) {
		/*var tempNode2 = sihangXML.createNode(1,"receipt","");
		Nodes(0).appendChild(tempNode2);*/
    	var tempNode2;
        tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "receipt", "");
    	
		/*var tempNode3 = sihangXML.createNode(1,"number","");
		tempNode2.appendChild(tempNode3);*/
        var tempNode3;
        tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "number", "");
		setNodeText(tempNode3 , HwpCtrl.GetFieldText("receiptnumber"));

		/*var tempNode3 = sihangXML.createNode(1,"date","");
		tempNode2.appendChild(tempNode3);*/
		var tempNode3;
        tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "date", "");
		
        if (HwpCtrl.CheckFieldExist("receiptdate")) {
            setNodeText(tempNode3 , HwpCtrl.GetFieldText("receiptdate"));
		}
	}

	//var Nodes = eNodes.selectNodes("foot/sendinfo");
    var Nodes = eNodes.getElementsByTagName("sendinfo");
    if (HwpCtrl.CheckFieldExist("zipcode")) {
		/*var tempNode2 = sihangXML.createNode(1,"zipcode","");
		Nodes(0).appendChild(tempNode2);*/
    	var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "zipcode", "");
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("zipcode"));
    } else {
		/*var tempNode2 = sihangXML.createNode(1,"zipcode","");
		Nodes(0).appendChild(tempNode2);*/
    	var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "zipcode", "");
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("zipcode"));
		setNodeText(tempNode2 , "");
	}
	
	//var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("address")) {
		/*var tempNode2 = sihangXML.createNode(1,"address","");
		Nodes(0).appendChild(tempNode2);*/
    	var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "address", "");
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("address"));
    } else {
		/*var tempNode2 = sihangXML.createNode(1,"address","");
		Nodes(0).appendChild(tempNode2);*/
    	var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "address", "");
		setNodeText(tempNode2 , "");
	}

	//var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("homepage")) {
		/*var tempNode2 = sihangXML.createNode(1,"homeurl","");
		Nodes(0).appendChild(tempNode2);*/
    	var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "homeurl", "");
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("homepage"));
	}
	
	//var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("telephone")) {
		/*var tempNode2 = sihangXML.createNode(1,"telephone","");
		Nodes(0).appendChild(tempNode2);*/
    	var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "telephone", "");
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("telephone"));
    } else {
		/*var tempNode2 = sihangXML.createNode(1,"telephone","");
		Nodes(0).appendChild(tempNode2);*/
    	var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "telephone", "");
		setNodeText(tempNode2 , "");
	}
	
	//var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("fax")) {
		/*var tempNode2 = sihangXML.createNode(1,"fax","");
		Nodes(0).appendChild(tempNode2);*/
    	var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "fax", "");
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("fax"));
    } else {
		/*var tempNode2 = sihangXML.createNode(1,"fax","");
		Nodes(0).appendChild(tempNode2);*/
    	var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "fax", "");
		setNodeText(tempNode2 , "");
	}
	
	//var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("email")) {
		/*var tempNode2 = sihangXML.createNode(1,"email","");
		Nodes(0).appendChild(tempNode2);*/
    	var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "email", "");
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("email"));
	}
	
	//var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("publication")) {
		/*var tempNode2 = sihangXML.createNode(1,"publication","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , HwpCtrl.GetFieldText("publication"));
		tempNode2.setAttribute("code", getNodeText(pDocInfoXML.documentElement.childNodes(27)));*/
    	var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "publication", "");
	    tempNode2.setAttribute("code", getNodeText(pDocInfoXML.getElementsByTagName("PUBLICITYCODE").item(0)));
	    setNodeText(tempNode2 , HwpCtrl.GetFieldText("publication"));
    } else {
		/*var tempNode2 = sihangXML.createNode(1,"publication","");
		Nodes(0).appendChild(tempNode2);
		setNodeText(tempNode2 , "");
		tempNode2.setAttribute("code", getNodeText(pDocInfoXML.documentElement.childNodes(27)));*/
		var tempNode2;
	    tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "publication", "");
	    tempNode2.setAttribute("code", getNodeText(pDocInfoXML.getElementsByTagName("PUBLICITYCODE").item(0)));
	    setNodeText(tempNode2 , "");
	}

	//var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("symbol")) {
		symbolPath = GetDocumentElement(HwpCtrl, "symbolurl");
        if (symbolPath != "") {
				var tempNode3 = sihangXML.createNode(1,"symbol","");
				Nodes(0).appendChild(tempNode3);
				var tempNode2 = sihangXML.createNode(1,"img","")
            tempNode3.appendChild(tempNode2);
				
				var len = symbolPath.lastIndexOf("/");
				var filelength = symbolPath.length - (len + 1);  
				symbolName = symbolPath.substr(len + 1,filelength);
				tempNode2.setAttribute("src",symbolName);
				tempNode2.setAttribute("alt",strLang180);
				
            var tempSize = GetHTMLBody(HwpCtrl.GetCloneData("symbol", "HTML"));
            var tmpDiv = document.createElement("div");
            tmpDiv.innerHTML = tempSize;
            //var tmpH = PixelToMillimeter(GetAttribute(tmpDiv.childNodes[0].childNodes[0].childNodes[0],'height'));
            //var tmpW = PixelToMillimeter(GetAttribute(tmpDiv.childNodes[0].childNodes[0].childNodes[0],'width'));
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

	//var Nodes = eNodes.selectNodes("foot/sendinfo");
    if (HwpCtrl.CheckFieldExist("logo")) {
		logoPath = GetDocumentElement(HwpCtrl, "logourl");
		
        if (logoPath != "") {
					var tempNode3 = sihangXML.createNode(1,"logo","");
					Nodes(0).appendChild(tempNode3);
					var tempNode2 = sihangXML.createNode(1,"img","")
					tempNode3.appendChild(tempNode2)
					
					var len = logoPath.lastIndexOf("/");
					var filelength = logoPath.length - (len + 1);  
					logoName = logoPath.substr(len + 1,filelength);
					tempNode2.setAttribute("src",logoName)
					tempNode2.setAttribute("alt", strLang181)
					
            var tempSize = GetHTMLBody(HwpCtrl.GetCloneData("logo", "HTML"));
            var tmpDiv = document.createElement("div");
            tmpDiv.innerHTML = tempSize;
            //var tmpH = PixelToMillimeter(GetAttribute(tmpDiv.childNodes[0].childNodes[0].childNodes[0],'height'));
            //var tmpW = PixelToMillimeter(GetAttribute(tmpDiv.childNodes[0].childNodes[0].childNodes[0], 'width'));
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
		//var Nodes = eNodes.selectNodes("foot");
    	var Nodes = eNodes.getElementsByTagName("foot");
		/*var tempNode2 = sihangXML.createNode(1,"campaign","");
		Nodes(0).appendChild(tempNode2);*/
    	var tempNode2;
        tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "campaign", "");

		/*var tempNode3 = sihangXML.createNode(1,"headcampaign","");
		tempNode2.appendChild(tempNode3);		*/
        var tempNode3;
        tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "headcampaign", "");
		setNodeText(tempNode3 , HwpCtrl.GetFieldText("headcampaign"));
		
        if (HwpCtrl.CheckFieldExist("footcampaign")) {
			/*var tempNode3 = sihangXML.createNode(1,"footcampaign","");
			tempNode2.appendChild(tempNode3);		
			setNodeText(tempNode3 , HwpCtrl.GetFieldText("footcampaign"));*/
        	var tempNode3;
            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "footcampaign", HwpCtrl.GetFieldText("footcampaign"));
		}		
    } else {
        if (HwpCtrl.CheckFieldExist("footcampaign")) {
			//var Nodes = eNodes.selectNodes("foot");
        	var Nodes = eNodes.getElementsByTagName("foot");
			/*var tempNode2 = sihangXML.createNode(1,"campaign","");
			Nodes(0).appendChild(tempNode2);*/
        	var tempNode2;
            tempNode2 = createNodeAndAppandNodeText(sihangXML, Nodes.item(0), tempNode2, "campaign", "");
        	
			/*var tempNode3 = sihangXML.createNode(1,"footcampaign","");
			tempNode2.appendChild(tempNode3);		
			setNodeText(tempNode3 , HwpCtrl.GetFieldText("footcampaign"));*/
            var tempNode3;
            tempNode3 = createNodeAndAppandNodeText(sihangXML, tempNode2, tempNode3, "footcampaign", HwpCtrl.GetFieldText("footcampaign"));
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
	
	/*var result = true;
	var sihangXML2 = sihangXML.xml;
	var strtempxml = sihangXML2;
	
	var re = /&amp;nbsp;/g; 
    var strtempxml = strtempxml.replace(re, "&nbsp;");
	var re = /strong>/g; 
    var strtempxml = strtempxml.replace(re, "b>");
	
	var objSaveTmp = new ActiveXObject("EzUtil.MiscFunc"); 
    objSaveTmp.SaveTextToFile("c:\\" + pDocID + "pubdoc.xml", "<?xml version=\"1.0\" encoding=\"euc-kr\"?><?xml-stylesheet type=\"text/xsl\" href=\"siheng.xsl\"?><!DOCTYPE pubdoc SYSTEM \"pubdoc.dtd\">" + strtempxml);
	objSaveTmp = null;
    FileUpload(pDocID + "pubdoc.xml", "/Upload_ApprovalG/" + companyID + "/sendXML/" + pDocID + "pubdoc.xml", "c:\\" + pDocID + "pubdoc.xml");
	
	arrDelFiles[arrDelFiles.length] = "c:\\" + pDocID + "pubdoc.xml";
	
	var xmlhttp = createXMLHttpRequest();
	var xmlPubDocCheck = createXmlDom();
	
	var objRoot = xmlPubDocCheck.createNode(1,"PARAMETER","");
	xmlPubDocCheck.appendChild(objRoot);
	
	var objNode = xmlPubDocCheck.createNode(1, "XMLPATH", "");
	setNodeText(objNode , "/Upload_ApprovalG/" + companyID + "/sendXML/" + pDocID + "pubdoc.xml");
	xmlPubDocCheck.documentElement.appendChild(objNode);
	
	xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/checkPubDocXML.aspx", false);
	xmlhttp.send(xmlPubDocCheck);
	
    if (xmlhttp.responseText != "0") {
        alert("파서오류(pubdoc) : " + "/Upload_ApprovalG/" + companyID + "/sendXML/" + pDocID + "pubdoc.xml" + ", " + xmlhttp.responseText);
		return false;
	}
	
    
    if (sendCNT[0] > 0) {

		var rtnXML = makeExtinfo(sihangXML,newDocID, "GPKI");
        if (encodePath == "NONE_Enc_SEND") {
			var rtnFileName = encodeDN(rtnXML);
			var objSave = new ActiveXObject("EzUtil.MiscFunc"); 
			ContentXML = objSave.LoadTextFromFile("c:\\" + rtnFileName)
			objSave = null;
			ContentXML = ContentXML.replace("<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">", "");
			var xmlContent = createXmlDom();
			xmlContent.loadXML(ContentXML);
			result = sendExtDoc(xmlContent);
        } else {
			var rtnFileName = encodeDN(rtnXML);
			result = encodeUP(rtnFileName);
		}
	}
	
    
    if (sihangXML.xml == "")
        sihangXML.loadXML(sihangXML2);

    if (sendCNT[1] > 0) {
        var rtnXML = makeExtinfo(sihangXML, newDocID, "SEND");
		var rtnFileName = encodeDN(rtnXML);
		var objSave = new ActiveXObject("EzUtil.MiscFunc"); 
		ContentXML = objSave.LoadTextFromFile("c:\\" + rtnFileName)
		ContentXML = ContentXML.replace("<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">", "");
		var xmlContent = createXmlDom();
		xmlContent.loadXML(ContentXML);
		result = sendExtDoc(xmlContent);
	}
		
    if (result) {
		return true;
    } else {
		var pAlertContent = strLang185;
		OpenAlertUI(pAlertContent);
		return false;
	}*/
    
    var SaveDocHTTp = createXMLHttpRequest();
    SaveDocHTTp.open("POST", "/ezApprovalG/simsaGUpload.do?docID=" + pDocID, false);
    SaveDocHTTp.send(getXmlString(sihangXML));
     
    if (SaveDocHTTp.responseText == "OK") {
    	
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
            var pAlertContent = strLang185;
            OpenAlertUI(pAlertContent);
            return false;
        } else {
            var rtnXML = makeExtinfo(sihangXML, newDocID, "SEND");
            var resultXml = encodeDN(rtnXML);
            ContentXML = resultXml.split('::')[1];
            ContentXML = ContentXML.replace("<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">", "");
            result = sendExtDoc(ContentXML);
            if (result) {
            	return true;
            } else {
            	return false;
            }
        }
    }
}

function FileUpload(pFileName, pURL, localPath) {
	oPoster.Clear();
	oPoster.UseUTF8 = true;
	oPoster.AddFormData("DocID", pFileName);
	oPoster.AddFormData("UploadPath", pURL);
	oPoster.AddFile("UploadFile", localPath, 0);

	oPoster.Host = document.location.hostname;
	oPoster.PostURL = "/myoffice/ezApprovalG/ezAPRATTACH/aspx/upload_file.aspx";
	
    if (window.location.protocol == "http:")
        oPoster.Protocol = 0;
    else
        oPoster.Protocol = 1;
	oPoster.Post();
	var rtnVal = oPoster.Response;
	
    if (rtnVal == "SUCCESS") {
		return true;	
	}	
    else {
		return false;
	}
}

function makeExtinfo(psihangXML, newDocID, mode) {
	var ExtSNodes, Nodes, Nodes2, strTO, i;
	var isfirst;
    
	/*var ExtXML =  createXmlDom();
	ExtXML.async = false;
	ExtXML.load("/myoffice/ezApprovalG/enforce/packXML.xml");*/
	
  try {
	var ExtXML = loadXMLFile("/xml/ezApprovalG/packXML.xml");
	//var objSave = new ActiveXObject("EzUtil.MiscFunc"); 
	var eNodes = ExtXML.documentElement;
	var Nodes = psihangXML.documentElement;
	
        
	//var Nodes = eNodes.selectNodes("header/send-orgcode");
	//setNodeText(Nodes(0) , companyID);
	var Nodes = SelectNodes(eNodes, "send-orgcode");
    setNodeText(Nodes[0], companyID);
        
	//var Nodes = eNodes.selectNodes("header/send-id");
	//setNodeText(Nodes(0) , companyID);
    Nodes = SelectNodes(eNodes, "send-id");
    setNodeText(Nodes[0],companyID);
        
	/*var Nodes = eNodes.selectNodes("header/send-name");
	setNodeText(Nodes(0) , objSave.EncodeBase64(companyName));*/
    Nodes = SelectNodes(eNodes, "send-name");
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
	
	/*var Nodes = eNodes.selectNodes("header/receive-id");
	setNodeText(Nodes(0) , strTO);

        
	var Nodes = eNodes.selectNodes("header/date");
	setNodeText(Nodes(0) , "");

        
	var Nodes = eNodes.selectNodes("header/title");
	setNodeText(Nodes(0) , objSave.EncodeBase64(getNodeText(pDocInfoXML.documentElement.childNodes(7))));

        
	var Nodes = eNodes.selectNodes("header/doc-id");
	setNodeText(Nodes(0) , pOrgDocID);
	
        
	var Nodes = eNodes.selectNodes("header/doc-type");
	if (pAprType == strLang186 )
		Nodes(0).setAttribute("type", "resend");
	else
		Nodes(0).setAttribute("type", "send");*/
        
    Nodes = SelectNodes(eNodes, "receive-id");
    setNodeText(Nodes[0], strTO);

    Nodes = SelectNodes(eNodes, "date");
    setNodeText(Nodes[0], "");

    Nodes = SelectNodes(eNodes, "title");
    setNodeText(Nodes[0], getNodeText(GetChildNodes(GetChildNodes(pDocInfoXML)[0])[7]));

    Nodes = SelectNodes(eNodes, "doc-id");
    setNodeText(Nodes[0], pOrgDocID);

    Nodes = SelectNodes(eNodes, "doc-type");
    if (pAprType == strLang186)
        SetAttribute(Nodes[0], "type", "resend")            
    else
        SetAttribute(Nodes[0], "type", "send");    
        
	/*Nodes(0).setAttribute("dept", objSave.EncodeBase64(getNodeText(pDocInfoXML.documentElement.childNodes(17))));
        
	Nodes(0).setAttribute("name", objSave.EncodeBase64(getNodeText(pDocInfoXML.documentElement.childNodes(14))));*/
    SetAttribute(Nodes[0], "dept", getNodeText(GetChildNodes(GetChildNodes(pDocInfoXML)[0])[17]));
    SetAttribute(Nodes[0], "name", getNodeText(GetChildNodes(GetChildNodes(pDocInfoXML)[0])[14]));
        
	/*var Nodes = eNodes.selectNodes("header/send-gw");
	setNodeText(Nodes(0) , objSave.EncodeBase64("ezFlow2000/G"));*/
    Nodes = SelectNodes(eNodes, "send-gw");
    setNodeText(Nodes[0], "ezFlow2000/G");
        
	/*var Nodes = eNodes.selectNodes("header/dtd-version");
	setNodeText(Nodes(0) , "2.0");

        
	var Nodes = eNodes.selectNodes("header/xsl-version");
	setNodeText(Nodes(0) , "2.0");
	
	var Nodes = eNodes.selectNodes("contents");
	var tempNode = sihangXML.createNode(1,"content","");
	Nodes(0).appendChild(tempNode);
	tempNode.setAttribute("content-role", "pubdoc");
	tempNode.setAttribute("filename", objSave.EncodeBase64("pubdoc.xml"));
	tempNode.setAttribute("content-transfer-encoding", "base64");
	tempNode.setAttribute("content-type", "text/xml");
    tempNode.setAttribute("charset", "euc-kr");*/
    Nodes = SelectNodes(eNodes, "dtd-version");
    setNodeText(Nodes[0], "2.0");

    Nodes = SelectNodes(eNodes, "xsl-version");
    setNodeText(Nodes[0], "2.0");

    Nodes = SelectNodes(eNodes, "contents");

    var tempNode = createNode(sihangXML, "content");
    Nodes[0].appendChild(tempNode);

    SetAttribute(tempNode, "content-role", "pubdoc");
    SetAttribute(tempNode, "filename", "pubdoc.xml");
    SetAttribute(tempNode, "content-transfer-encoding", "base64");
    SetAttribute(tempNode, "content-type", "text/xml");
    SetAttribute(tempNode, "charset", "");
    
	/*var strtempxml = psihangXML.xml;
	var re = /&amp;nbsp;/g; 
	var strtempxml = strtempxml.replace(re,"&nbsp;")
	var re = /strong>/g; 
	var strtempxml = strtempxml.replace(re,"b>")

	setNodeText(tempNode , objSave.EncodeBase64("<?xml version=\"1.0\" encoding=\"euc-kr\"?><?xml-stylesheet type=\"text/xsl\" href=\"siheng.xsl\"?><!DOCTYPE pubdoc SYSTEM \"pubdoc.dtd\">" + strtempxml));
	
        
        if (sealName != "") {
		var Nodes = eNodes.selectNodes("contents");
		var tempNode = sihangXML.createNode(1,"content","");
		Nodes(0).appendChild(tempNode);
		tempNode.setAttribute("content-role", "seal");
		tempNode.setAttribute("filename", objSave.EncodeBase64(sealName));
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
		tempNode.setAttribute("filename", objSave.EncodeBase64(attachName[i]));
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
		tempNode.setAttribute("filename", objSave.EncodeBase64(attachxmlName));
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
		tempNode.setAttribute("filename", objSave.EncodeBase64(attachxslName));
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
		tempNode.setAttribute("filename", objSave.EncodeBase64(psignName[i]));
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
		tempNode.setAttribute("filename", objSave.EncodeBase64(symbolName));
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
		tempNode.setAttribute("filename", objSave.EncodeBase64(logoName));
		tempNode.setAttribute("content-transfer-encoding", "base64");
		tempNode.setAttribute("content-type", "");
		tempNode.setAttribute("charset", "euc-kr");
		setNodeText(tempNode , logoPath.replace(pDomainName, ""));
	}	*/	
    
    var strtempxml = getXmlString(psihangXML);
    var re = /&amp;nbsp;/g;
    var strtempxml = strtempxml.replace(re, "&nbsp;")
    var re = /strong>/g;
    var strtempxml = strtempxml.replace(re, "b>")
    
    setNodeText(tempNode, "<?xml version=\"1.0\" encoding=\"euc-kr\"?><?xml:stylesheet type=\"text/xsl\" href=\"siheng.xsl\"?><!DOCTYPE pubdoc SYSTEM \"pubdoc.dtd\">" + strtempxml);

    if (sealName != "") {
        var Nodes = SelectNodes(eNodes, "contents");
        var tempNode = createNode(sihangXML, "content"); 
        Nodes[0].appendChild(tempNode);

        SetAttribute(tempNode, "content-role", "seal");
        SetAttribute(tempNode, "filename", sealName); // btoa
        SetAttribute(tempNode, "content-transfer-encoding", "base64");
        SetAttribute(tempNode, "content-type", "");
        SetAttribute(tempNode, "charset", "UTF-8");
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

        SetAttribute(tempNode, "filename", attachName[i]); // btoa
        SetAttribute(tempNode, "content-transfer-encoding", "base64");
        SetAttribute(tempNode, "content-type", "");
        SetAttribute(tempNode, "charset", "");
        setNodeText(tempNode, attachPath[i].replace(pDomainName, ""));                        
    }

    if (attachxmlPath != "") {
        var Nodes = SelectNodes(eNodes, "contents"); 
        var tempNode = createNode(sihangXML, "content");
        Nodes[0].appendChild(tempNode);

        SetAttribute(tempNode, "content-role", "attach_xml");
        SetAttribute(tempNode, "filename", attachxmlName); // btoa
        SetAttribute(tempNode, "content-transfer-encoding", "base64");
        SetAttribute(tempNode, "content-type", "html/xml");
        SetAttribute(tempNode, "charset", "");
        setNodeText(tempNode, attachxmlPath.replace(pDomainName, ""));
    }

    if (attachxslPath != "") {
        var Nodes = SelectNodes(eNodes, "contents");
        var tempNode = createNode(sihangXML, "content");
        Nodes[0].appendChild(tempNode);

        SetAttribute(tempNode, "content-role", "attach_xsl");
        SetAttribute(tempNode, "filename", attachxslName); // btoa
        SetAttribute(tempNode, "content-transfer-encoding", "base64");
        SetAttribute(tempNode, "content-type", "html/xsl");
        SetAttribute(tempNode, "charset", "");
        setNodeText(tempNode, attachxslPath.replace(pDomainName, ""));
    }

    for (i = 1; i < psignCount; i++) {
        var Nodes = SelectNodes(eNodes, "contents");
        var tempNode = createNode(sihangXML, "content");
        Nodes[0].appendChild(tempNode);

        SetAttribute(tempNode, "content-role", "sign");
        SetAttribute(tempNode, "filename", psignName[i]); // btoa
        SetAttribute(tempNode, "content-transfer-encoding", "base64");
        SetAttribute(tempNode, "content-type", "");
        SetAttribute(tempNode, "charset", "");
        setNodeText(tempNode, psignPath[i].replace(pDomainName, ""));
    }

    if (symbolName != "") {
        var Nodes = SelectNodes(eNodes, "contents"); 
        var tempNode = createNode(sihangXML, "content");
        Nodes[0].appendChild(tempNode);

        SetAttribute(tempNode, "content-role", "symbol");
        SetAttribute(tempNode, "filename", symbolName); // btoa
        SetAttribute(tempNode, "content-transfer-encoding", "base64");
        SetAttribute(tempNode, "content-type", "");
        SetAttribute(tempNode, "charset", "");
        setNodeText(tempNode, symbolPath.replace(pDomainName, ""));
    }

    if (logoName != "") {
        var Nodes = SelectNodes(eNodes, "contents");
        var tempNode = createNode(sihangXML, "content");
        Nodes[0].appendChild(tempNode);

        SetAttribute(tempNode, "content-role", "logo");
        SetAttribute(tempNode, "filename", logoName); // btoa
        SetAttribute(tempNode, "content-transfer-encoding", "base64");
        SetAttribute(tempNode, "content-type", "");
        SetAttribute(tempNode, "charset", "");
        setNodeText(tempNode, logoPath.replace(pDomainName, ""));
    }
    
	return ExtXML;
	
  } catch(e) {
	alert("makeExtinfo : " + e.description);
  }
}

var i = 0;
/*function sendExtDoc(ExtXML) {
    try {
		i = i + 1;
		var objSaveTmp = new ActiveXObject("EzUtil.MiscFunc"); 
		objSaveTmp.SaveTextToFile("c:\\" + pDocID + i + "pack.xml", "<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">" + ExtXML.xml);
		objSaveTmp = null;
		FileUpload(pDocID + i + "pack.xml", "/Upload_ApprovalG/" + companyID + "/sendXML/" + pDocID + i + "pack.xml", "c:\\" + pDocID + i + "pack.xml")
		
		
		arrDelFiles[arrDelFiles.length] = "c:\\" + pDocID + i + "pack.xml";
		
		
		var xmlhttp = createXMLHttpRequest();
		var xmlPubDocCheck = createXmlDom();
		
		var objRoot = xmlPubDocCheck.createNode(1,"PARAMETER","");
		xmlPubDocCheck.appendChild(objRoot);
		
		var objNode = xmlPubDocCheck.createNode(1, "XMLPATH", "");
		setNodeText(objNode , "/Upload_ApprovalG/" + companyID + "/sendXML/" + pDocID + i + "pack.xml");
		xmlPubDocCheck.documentElement.appendChild(objNode);
		
		xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/checkPubDocXML.aspx", false);
		xmlhttp.send(xmlPubDocCheck);
		
        if (xmlhttp.responseText != "0") {
			alert("" + strLang187 + "" + xmlPubDocCheck.parseError.reason);
			return false;
		}
		
		
        xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/sendMsg.aspx", false);
		xmlhttp.send(ExtXML);	
		return true;
	}
    catch (e) {
		return false;
	}
}*/
function sendExtDoc(ExtXML) {
	try {
		i = i + 1;		
		
	    $.ajax({
			type : "POST",
			dataType : "text",
			async : false,
			url : "/ezApprovalG/sendMsg.do",
			data : {
				xmlData : "<?xml version=\"1.0\" encoding=\"euc-kr\"?><!DOCTYPE pack SYSTEM \"pack.dtd\">" + ExtXML ,
				xmlPath : pDocID + i + "pack.xml"
			},
			success: function(xml){
				result = xml;
			} ,
			error : function () {
				return false;
			}       			
		});
		
	    if (result == "OK") {
	    	return true;
	    }
	} catch(e) {
		return false;
	}
}

/*function encodeDN(ExtXML) {
	var xmlhttp = createXMLHttpRequest();
	xmlhttp.open("POST", "/myoffice/ezApprovalG/enforce/aspx/sendMsg2.aspx", false);
	xmlhttp.send(ExtXML);
	
	var emlName = xmlhttp.responseText;
	
    try {
		var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
		ezUtil.UseUTF8 = true;
		var result = ezUtil.DownloadToFile(pDomainName + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape("/Upload_ApprovalG/" + companyID + "/ExDocSendMsg/" + emlName), "c:\\" + emlName);
		ezUtil = null;
		
		return emlName;
	}
    catch (e) {
		return emlName;
	}
}*/
function encodeDN(ExtXML) {
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/sendMsg2.do",
		data : {
			extXML : getXmlString(ExtXML)
		},
		success: function(xml){
			result = xml;
		}        			
	});
	return result;
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
	
	
	arrDelFiles[arrDelFiles.length] = "c:\\content.xml";
	
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
				
				
				arrDelFiles[arrDelFiles.length] = "C:\\upload.p7m";
				
				
				var NewContents = makePKIHeader(GPKIContent);
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
	
	var ExtXML =  createXmlDom();
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