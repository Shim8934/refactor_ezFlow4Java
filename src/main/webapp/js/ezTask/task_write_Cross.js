function close_onclick() {
    if (!confirm("" + strLang8 + "")) {
		parent.DivPopUpHidden();
		window.close();
    } else {
        save_task();
    }
}

function show_personinfo(userid) {
    if (userid == "0")
        userid = creatorid;

    var heigth = window.screen.availHeight;
	var width = window.screen.availWidth;
	var left = (width - 420) / 2;
	var top = (heigth - 450) / 2;
	window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
}

function taskstatus_change() {
    var rate = document.getElementById("completerateSelect").value;
    var status = document.getElementById("taskstatusSelect").value;

    if (status == "3") {
        document.getElementById("completerateSelect").value = "100";
        return;
    }

    if (status == "1") {
        document.getElementById("completerateSelect").value = "0";
        return;
    }

    if (rate == "100") {
        document.getElementById("completerateSelect").value = "10";
        return;
    }
}

function rate_change() {
    var rate = document.getElementById("completerateSelect").value;
    var status = document.getElementById("taskstatusSelect").value;

    if (rate == "100") {
        document.getElementById("taskstatusSelect").value = "3";
        return;
    }

    if (rate == "0") {
        if (status == "3")
            document.getElementById("taskstatusSelect").value = "1";
        return;
    }

    if (status == "1" || status == "3")
        document.getElementById("taskstatusSelect").value = "2";
}

var task_select_entity_cross_dialogArguments = new Array();
var m_type;
function manage_share(type) {
    switch (type) {
        case 1:
            m_type = 1;
            task_select_entity_cross_dialogArguments[0] = g_person;
            task_select_entity_cross_dialogArguments[1] = manage_share_Complete;
            var OpenWin = window.open("/ezTask/taskSelectEntity.do?type="+ type + "", "taskSelectEntity", GetOpenWindowfeature(970, 655));
            try { OpenWin.focus(); } catch (e) { }
            break;
        case 2:
            m_type = 2;
            task_select_entity_cross_dialogArguments[0] = g_share;
            task_select_entity_cross_dialogArguments[1] = manage_share_Complete;
            var OpenWin = window.open("/ezTask/taskSelectEntity.do?type="+ type + "", "taskSelectEntity", GetOpenWindowfeature(970, 655));
            try { OpenWin.focus(); } catch (e) { }
            break;
    }
}

function manage_share_Complete(retVal) {
    switch (m_type) {
        case 1:
            if (typeof (retVal) != "undefined") {
                if (retVal["id"].length > 1) {
                    alert(strLang54);
                    return;
                }

                if (retVal["id"][0] == userid) {
                	alert("" + strLang20 + "");
                	retVal = null;
                	
                	return;
                }

                if (g_share != null) {
                    for (var i = 0; i < g_share["email"].length; i++) {
                        if (retVal["email"][0] == g_share["email"][i]) {
                            alert(retVal["name"][0] + strLang55);
                            return;
                        }
                    }
                }

                g_person = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

                if (retVal["id"].length == 0) {
                    setNodeText(document.getElementById("personlist"), "");
                    return;
                }

                if (primary == 1) {
                	setNodeText(document.getElementById("personlist"), retVal["name"][0] + " (" + retVal["deptname"][0] + ")");                	
                } else {
                	setNodeText(document.getElementById("personlist"), retVal["name2"][0] + " (" + retVal["deptname2"][0] + ")");
                }

                g_person["name"][0] = retVal["name"][0];
                g_person["id"][0] = retVal["id"][0];
                g_person["name1"][0] = retVal["name1"][0];
                g_person["name2"][0] = retVal["name2"][0];
                g_person["deptname"][0] = retVal["deptname"][0];
                g_person["deptname2"][0] = retVal["deptname2"][0];
                g_person["email"][0] = retVal["email"][0];
            }
            break;
        case 2:
            if (typeof (retVal) != "undefined") {
                g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

                setNodeText(document.getElementById("sharelist"), "");

                var j = 0;
                for (var i = 0; i < retVal["id"].length; i++) {
                    if (g_person != null && g_person["email"][0] == retVal["email"][i]) {
                        alert(retVal["name"][i] + strLang56);
                    } else {
                        if (getNodeText(document.getElementById("sharelist")) == "") {
                        	if (primary == 1) {
                        		setNodeText(document.getElementById("sharelist"), retVal["name"][i] + " (" + retVal["deptname"][i] + ")");                        		
                        	} else {
                        		setNodeText(document.getElementById("sharelist"), retVal["name2"][i] + " (" + retVal["deptname2"][i] + ")");
                        	}
                        } else {
                        	if (primary == 1) {
                        		setNodeText(document.getElementById("sharelist"), getNodeText(document.getElementById("sharelist")) + ", " + retVal["name"][i] + " (" + retVal["deptname"][i] + ")");                        		
                        	} else {
                        		setNodeText(document.getElementById("sharelist"), getNodeText(document.getElementById("sharelist")) + ", " + retVal["name2"][i] + " (" + retVal["deptname2"][i] + ")");
                        	}
                        }

                        g_share["name"][j] = retVal["name"][i];
                        g_share["id"][j] = retVal["id"][i];
                        g_share["name1"][j] = retVal["name1"][i];
                        g_share["name2"][j] = retVal["name2"][i];
                        g_share["deptname"][j] = retVal["deptname"][i];
                        g_share["deptname2"][j] = retVal["deptname2"][i];
                        g_share["email"][j] = retVal["email"][i];
                        j++;
                    }
                }
                break;
            }
    }
}


function on_keydown(evt) {
    if (window.event) {
        if (evt.keyCode != 13)
            return;
    }
    else {
        if (evt.which != 13)
            return;
    }
    if (CrossYN()) {
        evt.preventDefault();

    }
    else {
        evt.returnValue = false;
    }
    check_name();
}

var retcheck = "";
//어디에쓰는거지
function check_name() {
    var name = document.getElementById("shareInput").value;
    name = ReplaceText(name, ",", ";");

    var names = name.split(";");

    for (var i = 0; i < names.length; i++) {
        names[i] = TrimText(names[i]);

        if (names[i] == "")
            continue;

        var adCount = 0;
        var xmlHTTP = createXMLHttpRequest();
        var xmlDOM = createXmlDom();
        var objNode;
        createNodeInsert(xmlDOM, objNode, "DATA");
        createNodeAndInsertText(xmlDOM, objNode, "SEARCH", "displayname::" + names[i]);
        createNodeAndInsertText(xmlDOM, objNode, "CELL", "company;description;title;displayname;mail");
        createNodeAndInsertText(xmlDOM, objNode, "PROP", "displayname;description");
        createNodeAndInsertText(xmlDOM, objNode, "TYPE", "user");

        try {
            xmlHTTP.open("POST", "/myoffice/ezOrgan/OrganInfo/GetSearchList.aspx", false);
            xmlHTTP.send(xmlDOM);

            if (xmlHTTP.statusText != "OK") {
                alert("" + strLang16 + "" + xmlHTTP.statusText);
                xmlDOM = null;
                xmlHTTP = null;
                continue;
            }
            else {
                xmlDOM = loadXMLString(xmlHTTP.responseText);
                adCount = xmlDOM.getElementsByTagName("ROW").length;
            }
        } catch (e) {
            alert("" + strLang16 + "" + e.description);
            xmlDOM = null;
            xmlHTTP = null;
            continue;
        }

        if (adCount == 0) {
            alert("'" + names[i] + "' " + strLang17 + "");
            continue;
        }
        else if (adCount == 1) {
            if (g_share == null)
                g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

            if (xmlDOM.getElementsByTagName("DATA2").item(0).text != userid) {
                var length = g_share["name"].length;
                for (var j = 0; j < length; j++)
                    if (g_share["id"][j] == getNodeText(xmlDOM.getElementsByTagName("DATA2")[0])) {
                        alert("" + strLang18 + "");
                        return;
                    }
            }
            else
            {
                alert("" + strLang20 + "");
                return;
            }
            var nodes = SelectNodes(xmlDOM, "LISTVIEWDATA/ROWS/ROW/CELL");
            g_share["name"][length] = getNodeText(GetChildNodes(nodes[3])[0]);
            g_share["name1"][length] = getNodeText(GetChildNodes(nodes[0])[5]);
            g_share["name2"][length] = getNodeText(GetChildNodes(nodes[0])[6]);
            g_share["id"][length] = getNodeText(GetChildNodes(nodes[0])[2]);
            g_share["deptname"][length] = getNodeText(GetChildNodes(nodes[0])[7]);
            g_share["deptname2"][length] = getNodeText(GetChildNodes(nodes[0])[8]);
            g_share["email"][length] = getNodeText(GetChildNodes(nodes[4])[0]);
            if (length == 0) {
                setNodeText(document.getElementById("receiverlist"), g_share["name"][length]);
            }
            else {
                setNodeText(document.getElementById("receiverlist"), getNodeText(document.getElementById("receiverlist")) + ", " + g_share["name"][length]);
            }
        }
        else {
            document.nameValue.addrBook.value = getXmlString(xmlDOM);
            document.nameValue.name.value = "";
            document.nameValue.id.value = "";
            document.nameValue.deptname.value = "";
            document.nameValue.name1.value = "";
            document.nameValue.name2.value = "";
            document.nameValue.deptname2.value = "";
            document.nameValue.email.value = "";

            var formaction = document.getElementById("nameValue");
            if (navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1) {
                var feature = GetOpenPosition(610, 300);
                retcheck = window.open("", "child", "width=610,height=300" + feature);
            }
            else {
                var feature = GetOpenPosition(610, 350);
                retcheck = window.open("", "child", "width=610,height=350" + feature);
            }

            formaction.target = "child";
            formaction.action = "/myoffice/ezTask/htm/checkName_Cross.aspx";
            formaction.submit();
        }
    }
    document.getElementById("shareInput").value = "";
}

var g_progresswin;
var g_fileList;
var g_fileNameList = new Array();
var g_fileInfoList = new Array();

function show_progress(fileinfo) {
    g_progresswin = window.showModelessDialog("/myoffice/ezTask/task_progress.aspx?fileinfo=" + escape(fileinfo), "", "dialogWidth=390; dialogHeight:170; center:yes; status:no; help:no; edge:sunken");
}

function status_change(fileinfo) {
    try {
        g_progresswin.document.Script.fileinfo_change(fileinfo);
    } catch (e) { }
}

function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");

    return (orgStr.replace(re, replaceStr));
}

function TrimText(orgStr) {
    var copyStr = "";
    var strIndex;
    for (strIndex = 0; strIndex < orgStr.length; strIndex++) {
        if (orgStr.charAt(strIndex) == ' ') continue;
        else {
            copyStr = orgStr.substr(strIndex);
            break;
        }
    }
    for (strIndex = copyStr.length - 1; strIndex >= 0; strIndex--) {
        if (copyStr.charAt(strIndex) == ' ') continue;
        else {
            copyStr = copyStr.substr(0, strIndex + 1);
            break;
        }
    }

    return copyStr;
}

function check_length(chkstr, maxlength, fieldname) {
    var length = 0;
    var i;

    length = chkstr.length;

    if (length > maxlength) {
        alert(fieldname + "" + strLang36 + "" + maxlength + "" + strLang37 + "");
        return false
    }

    return true;
}

function save_task() {
	if (document.getElementById("TextTitle").value == "" || $.trim($("#TextTitle").val()) == "") {
    	alert(strLang9);
        document.getElementById("TextTitle").focus();
        return;
    }

    var startdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
    var enddate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();

    if (startdate > enddate) {
    	alert(strLang45);
        return;
    }

    tasktype = $(":input:radio[name=tasktypesel]:checked").val();
    importance = $(":input:radio[name=important]:checked").val();

    var sharelist = document.getElementById("sharelist").innerHTML;
	var shareList2 = document.getElementById("shareList2").innerHTML;
	var shareID = document.getElementById("shareID").innerHTML;
	var shareDept = document.getElementById("shareDept").innerHTML;
	var shareDept2 = document.getElementById("shareDept2").innerHTML;
	
	var taskPersonList = document.getElementById("personlist").innerHTML;
	var taskpersonList2 = document.getElementById("personList2").innerHTML;
	var taskpersonID = document.getElementById("personID").innerHTML;
	var taskpersonDept = document.getElementById("personDept").innerHTML;
	var taskpersonDept2 = document.getElementById("personDept2").innerHTML;
	
	var memo = "";

	if (sharelist != "") {
		hasshare = "Y";
	} else {
		hasshare = "N";
	}

    if (!check_length($("#TextTitle").val(), 100, "" + strLang11 + "")) {
    	return;
    }

    if (taskid == "") {
    	contentPath = "";
    }
    
    var shareList = new Array();
    
    if (hasshare == "Y") {
    	for (var i = 0; i < g_share["id"].length; i++) {
    		var share = {"sharerID" : g_share["id"][i],
    				"sharerName" : g_share["name"][i],
    	    		"sharerName2" : g_share["name2"][i],
    	    		"sharerDeptName" : g_share["deptname"][i],
    	    		"sharerDeptName2" : g_share["deptname2"][i],
    	    		"sharerEmail" : g_share["email"][i]};
    		shareList.push(share);
    	}
    }

    if (tasktype == 1) {
        personID =  userid;
        personName = username;
        personName2 = username2;
        personDeptName = deptname;
        personDeptName2 = deptname2;
    } else {
        if (g_person != null) {
        	personID =  g_person["id"][0];
            personName = g_person["name"][0];
            personName2 = g_person["name2"][0];
            personDeptName = g_person["deptname"][0];
            personDeptName2 = g_person["deptname2"][0];
        } else {
        	alert(strLang57);
        	return;
        }
    }
    
    var strBody = message.GetEditorContent();
    strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() +  "<BODY>" + EmbedContentIntoXML(strBody) + "</BODY>" + "</HTML>");
    
	var listtable = dadiframe.document.getElementById("filelist");
	var filelist = GetChildNodes(listtable);
	var fileList = "";
	var fileName = "";
	var fileSize = "";
	
	for (var i = 0; i < filelist.length - 1; i++) {	    
		if (i == 0) {
			fileList = GetAttribute(filelist[i + 1], "data");
			fileName = GetAttribute(filelist[i + 1], "data2");
			fileSize = GetAttribute(filelist[i + 1], "data3");
		} else {
			fileList += "," + GetAttribute(filelist[i + 1], "data");
			fileName += "," + GetAttribute(filelist[i + 1], "data2");
			fileSize += "," + GetAttribute(filelist[i + 1], "data3");
		}
	}
	
	if (fileList.length > 0) {
		hasattach = "Y";
	} else {
		hasattach = "N";
	}
	
	if (useTodoMemo == 'YES') {
		memo = $("#TextMemo").val();
	} else {
		memo = "";
	}

	data = {
			taskID : taskid,
			ownerID : userid,
			creatorID : userid,
			creatorName : username,
			creatorName2 : username2,
			personID : personID,
	        personName : personName,
	        personName2 : personName2,
	        personDeptName : personDeptName,
	        personDeptName2 : personDeptName2,
			hasShare : hasshare,
			taskType : tasktype,
			importance : importance,
			startDate : startdate + " 00:00:00",
			endDate : enddate + " 23:59:59",
			title : document.getElementById("TextTitle").value,
			content : strBody,
			contentPath : contentPath,
			hasAttach : hasattach,
			fileList : fileList,
			fileName : fileName,
			fileSize : fileSize,
			shareList : shareList,
			memo : memo
		};
	
    $.ajax({
    	type : "POST",
		url : "/ezTask/taskSave.do",
		dataType : "json",
		contentType: "application/json; charset=UTF-8",
		data : JSON.stringify(data),
		success : function(result) {
			try {
				window.opener.RefreshView();
			} catch (e) { }
			
	        parent.DivPopUpHidden();
	        parent.location.reload();
	        window.close();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			alert(strLang13);
		}
    });
}

function EmbedContentIntoXML(bodyhtml) {
    var tempDiv = document.createElement("DIV");
    tempDiv.innerHTML = bodyhtml;

    var imgColl = tempDiv.getElementsByTagName("IMG");
    for (var i = 0; i < imgColl.length; i++) {
        if (imgColl.item(i).src.toLowerCase().indexOf("upload_common") > 0) {
            var OrgSrc = imgColl.item(i).src;
            var ImgHeight = "0";
            var ImgWidth = "0";
            if (imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/) == null) {
                if (imgColl.item(i).style.width != "")
                    ImgWidth = imgColl.item(i).style.width.replace("px", "");
                if (imgColl.item(i).style.height != "")
                    ImgHeight = imgColl.item(i).style.height.replace("px", "");
            }
            else {
                var result = imgColl.item(i).outerHTML.toLowerCase().match(/width="?([^>'"]+)['"]/);
                if (result.length == 2)
                    ImgWidth = result[1];
                var result = imgColl.item(i).outerHTML.toLowerCase().match(/height="?([^>'"]+)['"]/);
                if (result.length == 2)
                    ImgHeight = result[1];
            }
            ConvertSaveImageFile(OrgSrc, ImgWidth, ImgHeight);
        }
    }
    var BodyHTMLContent = HTMLtoMHT_MakeTag(tempDiv);
    return bodyhtml;
}

function ConvertSaveImageFile(pUrl, pImgWidth, pImgHeight) {
	$.ajax({
		url : "/ezCommon/convertSaveImage.do",
		type : "POST",
		async : false,
		data : {
			"url" : encodeURIComponent(pUrl),
			"height" : pImgHeight,
			"width" : pImgWidth,
			"type" : 2
		}
	});
}

function setAttachFileInfo(strXML) {
	if (strXML == "ERROR") {
        alert(strLang24);
        return;
    }
    var xml = loadXMLString(strXML);

    try {
        var strAttach = "";
        strPreViewAttach = "";
        var listtable;

        listtable = dadiframe.document.getElementById("filelist");
        dadiframe.document.getElementById("lstAttachLink").appendChild(listtable);

        var extCheck = false;
        for (i = 0; i < SelectNodes(xml, "ROOT/NODES/DATA").length; i++) {
            var newFileName = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA")[i]);
            var pFileName = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA2")[i]);
            var fileSize = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA3")[i]);

            if (getNodeText(SelectNodes(xml, "ROOT/NODES/DATA4")[i]) == "OK") {
            	objTr = document.createElement("TR");
                objTr.setAttribute("DATA", newFileName);
                objTr.setAttribute("DATA2", pFileName);
                objTr.setAttribute("DATA3", fileSize);

                var objTd = document.createElement("TD");
                objTd.style.textAlign = "center";

                var input = document.createElement("input");
                input.type = "checkbox";
                input.name = "fileSelect";

                objTd.appendChild(input);
                objTr.appendChild(objTd);

                var objTd2 = document.createElement("TD");

                objTd2.setAttribute("NAME", "fileName");
                objTd2.innerHTML = pFileName;
                objTd2.style.wordWrap = "break-word";
                objTr.appendChild(objTd2);

                var fileSize = parseInt(fileSize);

                if (fileSize / 1024 / 1024 > 1) {
                    fileSize = (Math.floor(parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
                }
                else if (fileSize / 1024 > 1) {
                    fileSize = parseInt(fileSize / 1024) + "KB";
                }
                else {
                    fileSize = fileSize + "B";
                }

                var objTd3 = document.createElement("TD");
                setNodeText(objTd3, fileSize);
                objTr.appendChild(objTd3);

                dadiframe.document.getElementById("filelist").appendChild(objTr);
            }
            else
                extCheck = true;          
        }
        if (extCheck)
            alert(strLang58);
    }
    catch (e) { alert("returnvalue :: " + e.description); }
}

function save_taskWork() {
    var content = message.GetEditorContent();
    content = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + EmbedContentIntoXML(content) + "</BODY>" + "</HTML>");

    if (taskid == "") {
    	personContentpath = "";
    }
    
    var listtable = dadiframe.document.getElementById("filelist");
	var filelist = GetChildNodes(listtable);
	var fileList = "";
	var fileName = "";
	var fileSize = "";
	
	for (var i = 0; i < filelist.length - 1; i++) {	    
		if (i == 0) {
			fileList = GetAttribute(filelist[i + 1], "data");
			fileName = GetAttribute(filelist[i + 1], "data2");
			fileSize = GetAttribute(filelist[i + 1], "data3");
		} else {
			fileList += "," + GetAttribute(filelist[i + 1], "data");
			fileName += "," + GetAttribute(filelist[i + 1], "data2");
			fileSize += "," + GetAttribute(filelist[i + 1], "data3");
		}
	}

	if (fileList.length > 0) {
		personAttach = "Y";
	} else {
		personAttach = "N";
	}
	
	$.ajax({
    	type : "POST",
		url : "/ezTask/taskWorkSave.do",
		dataType : "json",
		data : {
			taskID : taskid,
			content : content,
			attachList : fileList,
			fileName : fileName,
			fileSize : fileSize,
			personAttach : personAttach,
			contentPath : personContentpath
		},
		success : function(result) {
			parent.load_bodyhtml2(result.personContentPath);
			parent.getTaskWorkAttachList();
			parent.DivPopUpHidden();
	        window.close();
		},
		error : function(jqXHR, textStatus, errorThrown) {
			
		}
    });
}