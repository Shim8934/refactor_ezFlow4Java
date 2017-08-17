document.write("<script type='text/javascript' src='/js/jquery/jquery-1.11.3.min.js'></script>");

function close_onclick()
{
	if (!confirm(strLang8))
		window.close();
	else
		save_schedule();
}
	
function show_personinfo(userid)
{
	if (userid == "0")
		userid = creatorid;
	else if (userid == "1")
		userid = modifierid;
		
	var heigth = window.screen.availHeight;
	var width = window.screen.availWidth;
	var left = (width - 420) / 2;
	var top = (heigth - 450) / 2;
	window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
}

function check_time() {
    var startDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
    var endDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();

    var startYear = startDate.split("-")[0];
    var startMonth = startDate.split("-")[1];
    var startDay = startDate.split("-")[2];
    var endYear = endDate.split("-")[0];
    var endMonth = endDate.split("-")[1];
    var endDay = endDate.split("-")[2];
    var stime = $('#Stimepicker').val()

    var shour, sminute;
    var ehour, eminute;

    shour = stime.split(":")[0];
    sminute = stime.split(":")[1];

    var etime = $('#Etimepicker').val()

    ehour = etime.split(":")[0];
    eminute = etime.split(":")[1];

    if (startYear > endYear || (startYear == endYear && parseInt(startMonth) > parseInt(endMonth)) || (startYear == endYear && parseInt(startMonth) == parseInt(endMonth) && parseInt(startDay) > parseInt(endDay))) {
        return false;
    }
    else if (startYear > endYear || (startYear == endYear && parseInt(startMonth) > parseInt(endMonth)) || (startYear == endYear && parseInt(startMonth) == parseInt(endMonth) && parseInt(startDay) == parseInt(endDay))) {
        if (document.getElementById("alldaycheck").checked == false) {
            if (shour > ehour || (shour == ehour && sminute >= eminute)) {
                return false;
            }
            else
                return true;
        }
        return true;
    }
    
    return true;
}

var g_share = null;
var schedule_select_attendant_dialogArguments = new Array();
function _manage_attendant() {
    check_name("attendant");
}

function manage_attendant_after() {
    schedule_select_attendant_dialogArguments[0] = g_share;
    schedule_select_attendant_dialogArguments[1] = manage_attendant_Complete;

    GetOpenWindow("/ezTask/taskSelectAttendant.do", "", 970, 680);
}

function manage_attendant_Complete(rtn) {
    if (typeof (rtn) != "undefined") {
        g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "jikwe": new Array(), "phone": new Array() };
        document.getElementById("shareList").innerHTML = "";
        
        for (var i = 0; i < rtn["id"].length; i++) {
            if (i == 0) {
            	document.getElementById("shareList").innerHTML = rtn["name"][i];
            	document.getElementById("shareID").innerHTML = rtn["id"][i];
            	document.getElementById("shareList2").innerHTML = rtn["name1"][i];
            	document.getElementById("shareDept").innerHTML = rtn["deptname"][i];
            	document.getElementById("shareDept2").innerHTML = rtn["deptname2"][i];
            } else {
            	document.getElementById("shareList").innerHTML += ", " + rtn["name"][i];
            	document.getElementById("shareID").innerHTML += ", " + rtn["id"][i];
            	document.getElementById("shareList2").innerHTML += ", " + rtn["name1"][i];
            	document.getElementById("shareDept").innerHTML += ", " + rtn["deptname"][i];
            	document.getElementById("shareDept2").innerHTML += ", " + rtn["deptname2"][i];
            }

            g_share["name"][i] = rtn["name"][i];
            g_share["id"][i] = rtn["id"][i];
            g_share["deptname"][i] = rtn["deptname"][i];
            g_share["name1"][i] = rtn["name1"][i];
            g_share["name2"][i] = rtn["name2"][i];
            g_share["deptname2"][i] = rtn["deptname2"][i];
            g_share["jikwe"][i] = rtn["jikwe"][i];
            g_share["phone"][i] = rtn["phone"][i];

        }
    }
}

function _on_keydown(e)
{
	if (e.keyCode == "13")
		check_name();
}

var checkname_cross_dialogArguments = new Array();
var i = 0;
var namelength = 0;
var checknametype = "";
function check_name(type) {
    if (type != undefined)
        checknametype = type;
    else
        checknametype = "";

    var name = document.getElementById("shareInput").value;
    name = ReplaceText(name, ",", ";");

    var names = name.split(";");
    namelength = names.length;

    for (; i < names.length; i++) {
        names[i] = TrimText(names[i]);

        if (names[i] == "")
            continue;

        var adCount = 0;        
        var xmlDOM = createXmlDom();
        
        $.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/ezOrgan/getSearchList.do",
    		data : {
    			search : "displayName::" + names[i],
    			cell   : "company;description;title;displayName;mail",
    			prop   : "displayName;description",
    			type   : "user"
    		},
    		success: function(xml){
    			xmlDOM = loadXMLString(xml);
                adCount = xmlDOM.getElementsByTagName("ROW").length;    			
    		}    		
    	});

        if (adCount == 0) {
            alert("'" + names[i] + "'" + strLang21);
            continue;
        } else if (adCount == 1) {
            if (g_share == null)
                g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array() };

            if (getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]) != userid) {
                var length = g_share["name"].length;

                for (var j = 0; j < length; j++) {
                    if (g_share["id"][j] == getNodeText(xmlDOM.getElementsByTagName("DATA2")[0])) {
                        alert(strLang22);
                        return;
                    }
                }
            } else {
                alert(strLang24);
                return;
            }

            g_share["name"][length] = getNodeText(GetChildNodes(SelectNodes(xmlDOM, "LISTVIEWDATA/ROWS/ROW")[0])[3])
            g_share["id"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]);
            g_share["deptname"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA7")[0]);
            g_share["name1"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA5")[0]);
            g_share["name2"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA6")[0]);
            g_share["deptname2"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA8")[0]);

            if (length == 0) {
            	document.getElementById("shareList").innerHTML = g_share["name"][length];
            	document.getElementById("shareList2").innerHTML = g_share["name2"][length];            	
            }
            else {
            	document.getElementById("shareList").innerHTML += ", " + g_share["name"][length];
            	document.getElementById("shareList2").innerHTML += ", " + g_share["name2"][length];
            }
        } else {
            var rgParams = new Array();
            rgParams["addrBook"] = xmlDOM;
            rgParams["name"] = "";
            rgParams["id"] = "";
            rgParams["deptname"] = "";
            rgParams["name1"] = "";
            rgParams["name2"] = "";
            rgParams["deptname2"] = "";

            checkname_cross_dialogArguments[0] = rgParams;       
            checkname_cross_dialogArguments[1] = check_name_Complete;
            DivPopUpShow(610, 293, "/ezSchedule/checkName.do");
            i++;
            return;
        }
    }
    document.getElementById("shareInput").value = "";
    i = 0;
    if (checknametype != "")
        manage_attendant_after();
}

function check_name_Complete(rgParams) {
    DivPopUpHidden();
    if (rgParams["name"] != "") {
        if (g_share == null)
            g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array() };

        if (rgParams["id"] != userid) {
            var length = g_share["name"].length;
            for (var j = 0; j < length; j++) {
                if (g_share["id"][j] == rgParams["id"]) {
                    alert(strLang22);
                    return;
                }
            }
        }
        else {
            alert(strLang24);
            return;
        }

        var length = g_share["name"].length;

        g_share["name"][length] = rgParams["name"];
        g_share["id"][length] = rgParams["id"];
        g_share["deptname"][length] = rgParams["deptname"];
        g_share["name1"][length] = rgParams["name1"];
        g_share["name2"][length] = rgParams["name2"];
        g_share["deptname2"][length] = rgParams["deptname2"];

        if (length == 0)
            document.getElementById("shareList").innerHTML = g_share["name"][length];
        else
            document.getElementById("shareList").innerHTML += ", " + g_share["name"][length];

        if (i != namelength)
            check_name();
    }
    if (i == namelength) {
        i = 0;
        document.getElementById("shareInput").value = "";
    }
    if (checknametype != "")
        manage_attendant_after();
}
var g_progresswin;
var g_fileList;
var g_fileNameList = new Array();
var g_fileInfoList = new Array();

function attach_Delete()
{
    var checks = document.getElementById("attachedfileDIV").all.tags("input");
	
	for (var i=0; i<checks.length; i++)
	{
		if (checks.item(i).checked == true)
		{
			if(checks.length == 1) 
			{
				checks.item(i).parentElement.innerHTML = "&nbsp;";
			}
			else
			{
				checks.item(i).parentElement.parentElement.removeChild(checks.item(i).parentElement);
			}
			i--;
		}
	}
}		

var g_sdate = null;
var g_edate = null;
var schedule_repetition_cross_dialogArguments = new Array();
function config_repeat()
{	
	var args = new Array();	
	if(pattern == "1")
	{
	    args["SDATE"] = startDateStringOrgin;
	    args["EDATE"] = endDateStringOrgin; 
	}
	else
	{
	    if (g_sdate == null)
	    {
	        args["SDATE"] = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
	        args["EDATE"] = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
		    
	    }
	    else
	    {    	    
	        args["SDATE"] = g_sdate;
	        args["EDATE"] = g_edate; 	        		   
		} 	   
	}
	args["REPETITION"] = repetition;

	schedule_repetition_cross_dialogArguments[0] = args;
	schedule_repetition_cross_dialogArguments[1] = config_repeat_Complete;

	DivPopUpShow(450, 542, "/ezSchedule/scheduleRepetition.do");
}

function config_repeat_Complete(rtn) {
    if (rtn["REPETITION"] == "") {
        repetition = "";
        document.getElementById("periodblock").style.display = "";
        document.getElementById("repeatblock").style.display = "none";
        document.getElementById("repeatinfo").innerHTML = "&nbsp;";
    }
    else {
        g_sdate = rtn["SDATE"];
        g_edate = rtn["EDATE"];
        repetition = rtn["REPETITION"];
        show_repetition_info();
        document.getElementById("repeatinfo").innerHTML = rtn["REPDISPLAY"];
    }
}

function show_repetition_info()
{
    document.getElementById("periodblock").style.display = "none";
    document.getElementById("repeatblock").style.display = "";
	var info = repetition.split("|");
	var repeatinfo = strLang33;
	
	switch (info[2])
	{
		case "0":
			repeatinfo += strLang34;
			break;
		case "1":
			repeatinfo += strLang35;
			break;
	    case "2":
	        {
	            repeatinfo += strLang36;

	            repeatinfo += " ";
	            for (var i = 0; i < info[4].length; i++) {
	                var idx = info[4].substr(i, 1);
	                switch (idx) {
	                    case "0":
	                        repeatinfo += strLang48;
	                        break;
	                    case "1":
	                        repeatinfo += strLang49;
	                        break;
	                    case "2":
	                        repeatinfo += strLang50;
	                        break;
	                    case "3":
	                        repeatinfo += strLang51;
	                        break;
	                    case "4":
	                        repeatinfo += strLang52;
	                        break;
	                    case "5":
	                        repeatinfo += strLang53;
	                        break;
	                    case "6":
	                        repeatinfo += strLang54;
	                        break;
	                }
	            }
	        }
			break;
		case "3":
			repeatinfo += strLang37;
			break;
	}	

	repeatinfo += ", " + strLang38;
	
	if (info[1] == "1")
		repeatinfo += strLang39;
	else
	{
		var sdate, edate;
		if (g_sdate == null)
		{	
		    var sDate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		    var sYear = sDate.split("-")[0];
		    var sMon = sDate.split("-")[1];
		    var sDay = sDate.split("-")[2];
		    var sTime = $('#Stimepicker').val();
		    var sHour = sTime.split(":")[0];
		    var sMin = sTime.split(":")[1];


		    var eDate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
		    var eYear = eDate.split("-")[0];
		    var eMon = eDate.split("-")[1];
		    var eDay = eDate.split("-")[2];
		    var eTime = $('#Etimepicker').val();
		    var eHour = eTime.split(":")[0];
		    var eMin = eTime.split(":")[1];

		    sdate = sYear + "-" + sMon + "-" + sDay + " " + sHour + ":" + sMin;
		    edate = eYear + "-" + eMon + "-" + eDay + " " + eHour + ":" + eMin;
		}
		else
		{
			sdate = new Date(g_sdate);
			edate = new Date(g_edate);
			sdate = sdate.getFullYear() + "-" + (parseInt(sdate.getMonth()) + 1) + "-" + sdate.getDate() + " " + sdate.getHours() + ":" + sdate.getMinutes();
		    edate = edate.getFullYear() + "-" + (parseInt(edate.getMonth()) + 1) + "-" + edate.getDate() + " " + edate.getHours() + ":" + edate.getMinutes();
		}
        
        var reStartHour = sdate.split(" ")[1].split(":")[0];
		var reEndHour = edate.split(" ")[1].split(":")[0];
		
		var reStartMinute = sdate.split(" ")[1].split(":")[1];
		reStartMinute = reStartMinute.length==1?reStartMinute+"0":reStartMinute;
		var reEndMinute = edate.split(" ")[1].split(":")[1];
		reEndMinute = reEndMinute.length==1?reEndMinute+"0":reEndMinute;
        
        if( Number(reStartHour) < 12)   
        { 
			repeatinfo += "" + strLang1 + " "; 			
		}
        else    
        { 
			repeatinfo += "" + strLang2 + " "; 
			reStartHour = Number(reStartHour)-12; 
		}        
                
        repeatinfo += reStartHour + ":" + reStartMinute + "" + " ~ " + "";
        
        if(Number(reEndHour) < 12)   
        { 
			repeatinfo += "" + strLang1 + " "; 
		}
        else
        {
			repeatinfo += "" + strLang2 + " ";
			reEndHour = Number(reEndHour)-12;
		}
        
        repeatinfo += reEndHour + ":" + reEndMinute;
	}
	document.getElementById("repeatinfo").innerHTML = repeatinfo;
}

function ReplaceText( orgStr, findStr, replaceStr )
{
	var re = new RegExp( findStr, "gi" );
	
	return ( orgStr.replace( re, replaceStr ) );
}

function TrimText( orgStr )
{
	var copyStr = "";
	var strIndex;

	for ( strIndex = 0; strIndex < orgStr.length; strIndex ++ ) {
		if ( orgStr.charAt(strIndex) == ' ' ) continue;
		else {
			copyStr = orgStr.substr( strIndex );
			break;
		}
	}
	for ( strIndex = copyStr.length - 1; strIndex >= 0; strIndex -- ) {
		if ( copyStr.charAt(strIndex) == ' ' ) continue;
		else {
			copyStr = copyStr.substr( 0, strIndex + 1 );
			break;
		}
	}
	return copyStr;
}

function check_length(chkstr, maxlength, fieldname)
{
	var length = 0;
	var i;

    length = chkstr.length;

	if (length > maxlength)
	{
		alert(fieldname + strLang43 + maxlength + "" + strLang44 + "");
		return false;
	}
	return true;
}

function CheckStartEndDateTime() {
    var start = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
    var end = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();

    if (start >= end)
        return false;
    else
        return true;
}

function AllDayCheckStartEndDateTime() {
    var start = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + "00:00";
    var end = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + "00:00";

    if (start > end)
        return false;
    else
        return true;
}

function TimeRevision(szTime) {
    if (parseInt(szTime) == 0)
        return szTime = "00";

    return szTime
}

function CheckTimeRevision(szTime) {
    if (parseInt(szTime) == 0) {
        szTime = "00";
    }
    else if (parseInt(szTime) > 0 && parseInt(szTime) < 10) {
        szTime = "0" + szTime;
    }

    return szTime
}

function replaceSingleQuotation(reStr) {
    reStr = reStr.replace(/'/g, "''");
    return reStr;
}

function trim(parm_str) {
    return rtrim(ltrim(parm_str));
}

function ltrim(parm_str) {
    str_temp = parm_str;

    while (str_temp.length != 0) {
        if (str_temp.substring(0, 1) == " ") {
            str_temp = str_temp.substring(1, str_temp.length);
        }
        else {
            return str_temp;
        }
    }
    return str_temp;
}

function rtrim(parm_str) {
    str_temp = parm_str;

    while (str_temp.length != 0) {
        int_last_blnk_pos = str_temp.lastIndexOf(" ");

        if ((str_temp.length - 1) == int_last_blnk_pos) {
            str_temp = str_temp.substring(0, str_temp.length - 1);
        }
        else {
            return str_temp;
        }
    }
    return str_temp;
}

function setAttachFileInfo(strXML) {
    if (strXML == "ERROR") {
        alert(strLang28);
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
            var attid = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA4")[i]);

            if (getNodeText(SelectNodes(xml, "ROOT/NODES/DATA5")[i]) == "OK") {
                objTr = document.createElement("TR");
                objTr.setAttribute("DATA2", newFileName + ";" + fileSize);

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
            alert(strLang267);
    }
    catch (e) { alert("returnvalue :: " + e.description); }
}

function GetEncodeTextNew(pUrl) {
    var XmlHttp = createXMLHttpRequest();
    var xmlDom = createXmlDom();
    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "URL", encodeURIComponent(pUrl));
    try {
        XmlHttp.open("POST", "/myoffice/ezSchedule/remote/LoadMailImage.aspx", false);
        XmlHttp.send(xmlDom);
        return XmlHttp.responseText;
    }
    catch (e) { }
}

function GetEncodeTextNew_LinkedSystem(pUrl) {
    var XmlHttp = createXMLHttpRequest();
    var xmlDom = createXmlDom();
    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "URL", encodeURIComponent(pUrl));
    try {
        XmlHttp.open("POST", pUrl + "&type=1", false);
        XmlHttp.send(xmlDom);
        return XmlHttp.responseText;
    }
    catch (e) { }
}

function EmbedImageIntoXML(xmlDoc, rootNode) {
    var tempDiv = document.createElement("DIV");
    tempDiv.innerHTML = message.GetEditorContent();
    var imgColl = tempDiv.getElementsByTagName("IMG");

    for (var i = 0; i < imgColl.length; i++) {
        var newformname = "";
        var encodedText
        if (imgColl.item(i).src.toLowerCase().indexOf("upload_common") > 0)
            encodedText = GetEncodeTextNew(imgColl.item(i).src);
        else {
            encodedText = GetEncodeTextNew_LinkedSystem(imgColl.item(i).src);
        }
        var formname = imgColl.item(i).src.substr(imgColl.item(i).src.lastIndexOf("/") + 1)
        var OrgHteml = imgColl.item(i).outerHTML;

        imgColl.item(i).setAttribute("src", formname);
        imgColl.item(i).removeAttribute("embedding");
        imgColl.item(i).outerHTML = imgColl.item(i).outerHTML.replace("src=\"" + formname + "\"", "src=\"" + formname + "\" embedding=\"1\" ")
        //imgColl.item(i).setAttribute("embedding", "1");

        if (CrossYN())
            GetElementsByTagName(xmlDoc, "CONTENT")[0].textContent = GetElementsByTagName(xmlDoc, "CONTENT")[0].textContent.replace(OrgHteml, imgColl.item(i).outerHTML);
        else
            GetElementsByTagName(xmlDoc, "CONTENT")[0].text = GetElementsByTagName(xmlDoc, "CONTENT")[0].text.replace(OrgHteml, imgColl.item(i).outerHTML);

        MakeXmlNode(xmlDoc, rootNode, "IMAGENAME", formname);
        MakeXmlNode(xmlDoc, rootNode, "IMAGECONTENT", encodedText);
    }

    if (CrossYN())
        GetElementsByTagName(xmlDoc, "CONTENT")[0].textContent = pidCryptUtil.encodeBase64(GetElementsByTagName(xmlDoc, "CONTENT")[0].textContent, 64);
    else
        GetElementsByTagName(xmlDoc, "CONTENT")[0].text = pidCryptUtil.encodeBase64(GetElementsByTagName(xmlDoc, "CONTENT")[0].text, 64);
}
function MakeXmlNode(xmldoc, root, key, value) {
    var childNode = xmldoc.createElement(key);
    try {
        var cDataNode = xmldoc.createCDATASection(String(value));
        childNode.appendChild(cDataNode);
    }
    catch (e) {
        childNode.text = String(value);
    }
    root.appendChild(childNode);
}

function EmbedContentIntoXML(xmlDoc, rootNode) {
    var tempDiv = document.createElement("DIV");
    tempDiv.innerHTML = message.GetEditorContent();
    var imgColl = tempDiv.getElementsByTagName("IMG");

    for (var i = 0; i < imgColl.length; i++) {
        if (typeof (imgColl.item(i).srcorg) != "undefined" && imgColl.item(i).src.toLowerCase().indexOf(document.location.protocol + "//") == 0) {

            imgColl.item(i).src = ReplaceText(imgColl.item(i).srcorg, "%25", "");
            imgColl.item(i).removeAttribute("srcorg");
        }
        else if (typeof (imgColl.item(i).srcorgEmbedImage) != "undefined" && imgColl.item(i).src.toLowerCase().indexOf(document.location.protocol + "//") == 0) {
            imgColl.item(i).src = ReplaceText(imgColl.item(i).srcorgEmbedImage, "%25", "");
            imgColl.item(i).removeAttribute("srcorgEmbedImage");
        }
            // HTTPS:// 은 0~8 임
        else if (imgColl.item(i).src.substr(0, 7) == "file://" || (imgColl.item(i).embedding == 1 && imgColl.item(i).src.substr(0, 7) == document.location.protocol + "//") || (imgColl.item(i).embedding == 1 && imgColl.item(i).src.substr(0, 8) == document.location.protocol + "//")) {
            if (typeof (imgColl.item(i).srcorg) != "undefined")
                imgColl.item(i).removeAttribute("srcorg");

            //수정 (2010. 5. 3) : 아래 경로 수정
            if (imgColl.item(i).src.indexOf("mode=inlineimage") > 0) {
                imgColl.item(i).src = imgColl.item(i).src.split("&")[1].split("%")[0].replace("ATTID=", "");
            }
        }
    }

    var BodyHTMLContent = HTMLtoMHT_MakeTag(tempDiv);
    MakeXmlNode(xmlDoc, rootNode, "CONTENT", BodyHTMLContent);
}

function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");
    return (orgStr.replace(re, replaceStr));
}

function setLength(num) {
    if (num < 10) {
        num = "0" + num;
    }
    return num;
}
