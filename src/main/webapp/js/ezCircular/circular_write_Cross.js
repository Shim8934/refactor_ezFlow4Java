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

/*var SaveScheduleId = "";
function save_schedule()
{
    if (scheduleid == "") {
        var selectValue = document.getElementById("ListOwnerID").options[document.getElementById("ListOwnerID").selectedIndex].value.split(';;')[1];
        if (selectValue == companyID) {
            if (pCompanyAdmin != "Y") {
                alert(strLang1000);
                return;
            }
        }
        else if (selectValue == deptID) {
            if (pCompanyAdmin != "Y" && pDeptAdmin != "Y") {
                alert(strLang1001);
                return;
            }
        }
    }
    if(!check_time())
    {
        alert(timecheckstring);
        return;
    }
    
    if (CheckPreviously()) {
        alert(strLang272);
        return;
    }
    
	if (scheduleid == "") check_name();
	
	if (document.getElementById("TextTitle").value == "")
	{
	    alert(strLang9);
	    Tab1_MouseClick(document.getElementById("1tab1"));
		document.getElementById("TextTitle").focus();
		return;
	}

	if (!check_length(document.getElementById("TextTitle").value, 250, strLang10)) return;
	if (!check_length(document.getElementById("TextLocation").value, 50, strLang11)) return;
	
	var resDate = "";
	if (tmpReFlag == "0" && $.trim(repetition) != "") {
		var sdate, edate;
		
		if (g_sdate == null)
		{
		    sdate = new Date(startDateStringOrgin.substring(0, 4), parseInt(startDateStringOrgin.substring(5, 7)) -1, startDateStringOrgin.substring(8, 10), startDateStringOrgin.substring(11, 13), startDateStringOrgin.substring(14, 16), startDateStringOrgin.substring(17, 19));
		    edate = new Date(endDateStringOrgin.substring(0, 4), parseInt(endDateStringOrgin.substring(5, 7)) - 1, endDateStringOrgin.substring(8, 10), endDateStringOrgin.substring(11, 13), endDateStringOrgin.substring(14, 16), endDateStringOrgin.substring(17, 19));
		    if (isNaN(sdate)) {
		        sdate = new Date(startDateStringOrgin);
		        edate = new Date(endDateStringOrgin);
		    }
        }
		else
		{
			sdate = new Date(g_sdate.trim());
			edate = new Date(g_edate.trim());

			if (isNaN(sdate)) {
			    sdate = new Date(ReplaceText(g_sdate, "-", "/"));
			    edate = new Date(ReplaceText(g_edate, "-", "/"));
			}
		}
		
		resDate = getFirstDateInfo(sdate, edate);
		
		if (resDate == "") {
			return;
		}
	}
	
	var ResourceSaveResult = false;
	if (scheduleid == "") {
	    if (document.getElementById("resourcelist")) {	    	
	        if (trim(document.getElementById("resourcelist").innerHTML) != "") {
	            ResourceSaveResult = resource_Check(resDate);
	            if (!ResourceSaveResult)
	                return;
	        }
	    }
	}

    var ownerid = "";
    var ownername = "";
    var ownername2 = "";

    if (scheduleid == "")
	{
        ownerid = document.getElementById("ListOwnerID").options[document.getElementById("ListOwnerID").selectedIndex].value;
		ownerid = ownerid.split(";;")[1];

	    ownername = getNodeText(document.getElementById("ListOwnerID").options[document.getElementById("ListOwnerID").selectedIndex]);

	    if (ownername.indexOf("-") > -1)
	        ownername = ownername.split(" - ")[1];
	    else if (ownername.indexOf("]") > -1)
	        ownername = ownername.split("]")[1];	    
	    
        ownername2 = ownername;
    }
	var xmlHTTP = createXMLHttpRequest();
	var xmlDom = createXmlDom();    
	var objNode, objRow, objRows, objRowRow;

	objNode = createNodeInsert(xmlDom, objNode, "DATA");
	createNodeAndInsertText(xmlDom, objNode, "SCHEDULEID", scheduleid);
	createNodeAndInsertText(xmlDom, objNode, "OWNERID", scheduleid != null ? ownerid : "");
	createNodeAndInsertText(xmlDom, objNode, "OWNERNAME", scheduleid != null ? ownername : "");
	createNodeAndInsertText(xmlDom, objNode, "OWNERNAME2", ownername2);
	createNodeAndInsertText(xmlDom, objNode, "CREATORID", userid);
	createNodeAndInsertText(xmlDom, objNode, "CREATORNAME", username);
	createNodeAndInsertText(xmlDom, objNode, "CREATORNAME2", username2);
	createNodeAndInsertText(xmlDom, objNode, "CHANGEKEY", changekey);
	createNodeAndInsertText(xmlDom, objNode, "SCHEDULETYPE", scheduletype);
	
	var patternType = "";
	if (scheduleid != "") {
	    if (repetition != "" && pattern == "0")
	    {
	        createNodeAndInsertText(xmlDom, objNode, "PATTERN", "3");
	    }
	    else
	    {
	        createNodeAndInsertText(xmlDom, objNode, "PATTERN", pattern);
	    }
	    patternType = scheduletype;
	}
	else {
	    var ownerids = document.getElementById("ListOwnerID").options[document.getElementById("ListOwnerID").selectedIndex].value;

	    switch (ownerids.split(";;")[0]) {
	        case "1": //개인일정
	            patternType = "1";
	            break;
	        case "2": //부서일정
	            patternType = "2";
	            break;
	        case "3": //회사일정
	            patternType = "3";
	            break;
	        case "4": //본사일정
	            patternType = "4";
	            break;
	        case "5": //공유일정
	            patternType = "5";
	            break;
	        case "6": //비서일정
	            patternType = "6";
	            break;
	        case "7": //그룹일정
	            patternType = "7";
	            break;
	        case "8": //겸직일정
	            patternType = "8";
	            break;
	    }
	    setNodeText(xmlDom.getElementsByTagName("SCHEDULETYPE")[0], patternType)
	}
	createNodeAndInsertText(xmlDom, objNode, "IMPORTANCE", document.getElementById("importantSelect").value);
	createNodeAndInsertText(xmlDom, objNode, "ISPUBLIC", document.getElementById("publicSelect").value);
	createNodeAndInsertText(xmlDom, objNode, "OTHERID", scheduleid == "" ? ownerid : otherid);
	createNodeAndInsertText(xmlDom, objNode, "REPETITION", repetition);
	createNodeAndInsertText(xmlDom, objNode, "TITLE", document.getElementById("TextTitle").value);
	createNodeAndInsertText(xmlDom, objNode, "LOCATION", document.getElementById("TextLocation").value);

	var tempdiv = document.createElement("DIV");
	tempdiv.innerHTML = message.GetEditorContent();
	var linkColl = tempdiv.getElementsByTagName("A");
	for (var i = 0; i < linkColl.length; i++)
	{
	    linkColl[i].target = "_blank";
	}

	if (scheduleid == "")
	    createNodeAndInsertText(xmlDom, objNode, "CONTENTPATH", "");
	else {
	    if (contentpath == "")
	        createNodeAndInsertText(xmlDom, objNode, "CONTENTPATH", content);
	    else
	        createNodeAndInsertText(xmlDom, objNode, "CONTENTPATH", contentpath);
	}	
   
    var Doc_ContentHtml = document.createElement("DIV");
    var strBody = message.GetEditorContent();
    Doc_ContentHtml.innerHTML = strBody;
    strBody = HTMLtoMHT_MakeTag(Doc_ContentHtml);

    createNodeAndInsertText(xmlDom, objNode, "CONTENT", pidCryptUtil.encodeBase64(ConvertHTMLtoMHT(Signature_ImagePathConvert(strBody)), 64));

	if ($.trim(repetition) == "")
	{		
	    if (document.getElementById("alldaycheck").checked == true)
		{
			createNodeAndInsertText(xmlDom, objNode, "DATETYPE", "2");
			createNodeAndInsertText(xmlDom, objNode, "STARTDATE", $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00");
			createNodeAndInsertText(xmlDom, objNode, "ENDDATE", $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59");
		}
		else
		{
	        var stime = $('#Stimepicker').val()
			var etime = $('#Etimepicker').val()
			
			createNodeAndInsertText(xmlDom, objNode, "DATETYPE", "1");
			createNodeAndInsertText(xmlDom, objNode, "STARTDATE", $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + stime);
			createNodeAndInsertText(xmlDom, objNode, "ENDDATE", $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + etime);
		}
	}
	else
	{
		var sdate, edate;
		
		if (g_sdate == null)
		{
		    sdate = new Date(startDateStringOrgin.substring(0, 4), parseInt(startDateStringOrgin.substring(5, 7)) -1, startDateStringOrgin.substring(8, 10), startDateStringOrgin.substring(11, 13), startDateStringOrgin.substring(14, 16), startDateStringOrgin.substring(17, 19));
		    edate = new Date(endDateStringOrgin.substring(0, 4), parseInt(endDateStringOrgin.substring(5, 7)) - 1, endDateStringOrgin.substring(8, 10), endDateStringOrgin.substring(11, 13), endDateStringOrgin.substring(14, 16), endDateStringOrgin.substring(17, 19));
		    if (isNaN(sdate)) {
		        sdate = new Date(startDateStringOrgin);
		        edate = new Date(endDateStringOrgin);
		    }
        }
		else
		{
			sdate = new Date(g_sdate.trim());
			edate = new Date(g_edate.trim());

			if (isNaN(sdate)) {
			    sdate = new Date(ReplaceText(g_sdate, "-", "/"));
			    edate = new Date(ReplaceText(g_edate, "-", "/"));
			}
		}
        
		createNodeAndInsertText(xmlDom, objNode, "DATETYPE", "3");
		createNodeAndInsertText(xmlDom, objNode, "STARTDATE", sdate.getFullYear() + "-" + (parseInt(sdate.getMonth()) + 1) + "-" + sdate.getDate() + " " + sdate.getHours() + ":" + sdate.getMinutes());
		createNodeAndInsertText(xmlDom, objNode, "ENDDATE", edate.getFullYear() + "-" + (parseInt(edate.getMonth()) + 1) + "-" + edate.getDate() + " " + edate.getHours() + ":" + edate.getMinutes());
	}

	if (endDateStringOrgin != "" && edate != undefined) {
	    createNodeAndInsertText(xmlDom, objNode, "ENDORGINDATE", edate.getFullYear() + "-" + (parseInt(edate.getMonth()) + 1) + "-" + edate.getDate() + " " + edate.getHours() + ":" + edate.getMinutes());
	}
	else
	    createNodeAndInsertText(xmlDom, objNode, "ENDORGINDATE", "");

	objRow = createNodeAndAppandNode(xmlDom, objNode, objRow, "ATTACHLIST");
	
	var listtable = dadiframe.document.getElementById("filelist");
	var filelist = GetChildNodes(listtable);

	for (var i = 0; i < filelist.length - 1; i++) {	    
	    createNodeAndAppandNodeText(xmlDom, objRow, objRows, "ID", GetAttribute(filelist[i + 1], "attid"));
	    createNodeAndAppandNodeText(xmlDom, objRow, objRows, "ATTACH", GetAttribute(filelist[i + 1], "fileinfo"));
	}	
	objRow = createNodeAndAppandNode(xmlDom, objNode, objRow, "ATTENDANTLIST");
	
	if (g_attendant != null)
	{
		for (var i=0; i<g_attendant["id"].length; i++)
		{
			createNodeAndAppandNodeText(xmlDom, objRow, objRows , "ATTENDANTID", g_attendant["id"][i]);
			createNodeAndAppandNodeText(xmlDom, objRow, objRows , "ATTENDANTNAME1", g_attendant["name1"][i]);
			createNodeAndAppandNodeText(xmlDom, objRow, objRows , "ATTENDANTNAME2", g_attendant["name2"][i]);
			createNodeAndAppandNodeText(xmlDom, objRow, objRows , "ATTENDANTDEPTNAME", g_attendant["deptname"][i]);
			createNodeAndAppandNodeText(xmlDom, objRow, objRows , "ATTENDANTDEPTNAME2", g_attendant["deptname2"][i]);
		}
	}
	
	xmlHTTP.open("POST", "/ezSchedule/scheduleSave.do?pageFrom=" + pageFrom, false);
	xmlHTTP.send(xmlDom);

	if (xmlHTTP.status != 200) {
	    if (xmlHTTP.responseText.indexOf("OK") == -1) {
	        if (xmlHTTP.responseText == "XSS")
	            alert(strLang116);
	        else
	            alert(strLang17);
	    }
	}
	else {		
	    if (ResourceSaveResult) {	    	
	        SaveScheduleId = trim(xmlHTTP.responseText);	        
	        if (SaveScheduleId != "") {
	            var rntVal = resource_save(resDate);
	            if (rntVal != "OK") {
	                alert(strLang255);
	                return;
	            }
	        }
	    }
	    alert(strLang18);
	    try { window.opener.RefreshView() } catch (e) { }

	    window.close();
	}
}*/

/*function CheckPreviously() {
    var rtv = false;

    $.ajax({
		type : "GET",
		dataType : "text",
		async : false,
		url : "/ezSchedule/scheduleGetRegi.do",
		data : {
			COMPANYID  : companyID		    			
		},
		success: function(text) {
			if (text == "1") {
				if ($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() < utcDate(offSetMin)) {					
		            rtv = true;
				}
			}
		}
    });

    return rtv;    
}*/

/*function checkFontInfo(str)
{
	if (str == "")
        str = "<P> </P>"
		
    if((str.substring(0,3)).toUpperCase() == "<P>")
    {
        str = "<FONT size=2 face=" + strLang2 + ">" + str + "</FONT>";
    }
    return str;
}*/
var g_attendant = null;
var schedule_select_attendant_dialogArguments = new Array();
function _manage_attendant() {
    check_name("attendant");
}

function manage_attendant_after() {
    schedule_select_attendant_dialogArguments[0] = g_attendant;
    schedule_select_attendant_dialogArguments[1] = manage_attendant_Complete;

    GetOpenWindow("/ezCircular/circularSelectAttendant.do", "schedule_select_attendant", 970, 680);
}

function manage_attendant_Complete(rtn) {
    if (typeof (rtn) != "undefined") {
        g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "jikwe": new Array(), "phone": new Array() };
        document.getElementById("receiverlist").innerHTML = "";
        
        for (var i = 0; i < rtn["id"].length; i++) {
            if (i == 0) {
            	document.getElementById("receiverlist").innerHTML = rtn["name1"][i];
            	document.getElementById("receiverID").innerHTML = rtn["id"][i];
            	document.getElementById("receiverlist2").innerHTML = rtn["name2"][i];
            } else {
            	document.getElementById("receiverlist").innerHTML += ", " + rtn["name1"][i];
            	document.getElementById("receiverID").innerHTML += ", " + rtn["id"][i];
            	document.getElementById("receiverlist2").innerHTML += ", " + rtn["name2"][i];
            }

            g_attendant["name"][i] = rtn["name"][i];
            g_attendant["id"][i] = rtn["id"][i];
            g_attendant["deptname"][i] = rtn["deptname"][i];
            g_attendant["name1"][i] = rtn["name1"][i];
            g_attendant["name2"][i] = rtn["name2"][i];
            g_attendant["deptname2"][i] = rtn["deptname2"][i];
            g_attendant["jikwe"][i] = rtn["jikwe"][i];
            g_attendant["phone"][i] = rtn["phone"][i];

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

    var name = document.getElementById("receiverinput").value;
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
            if (g_attendant == null)
                g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array() };

            if (getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]) != userid) {
                var length = g_attendant["name"].length;

                for (var j = 0; j < length; j++) {
                    if (g_attendant["id"][j] == getNodeText(xmlDOM.getElementsByTagName("DATA2")[0])) {
                        alert(strLang22);
                        return;
                    }
                }
            } else {
                alert(strLang24);
                return;
            }

            g_attendant["name"][length] = getNodeText(GetChildNodes(SelectNodes(xmlDOM, "LISTVIEWDATA/ROWS/ROW")[0])[3])
            g_attendant["id"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]);
            g_attendant["deptname"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA7")[0]);
            g_attendant["name1"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA5")[0]);
            g_attendant["name2"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA6")[0]);
            g_attendant["deptname2"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA8")[0]);

            if (length == 0) {
            	document.getElementById("receiverlist").innerHTML = g_attendant["name"][length];
            	document.getElementById("receiverlist2").innerHTML = g_attendant["name2"][length];            	
            }
            else {
            	document.getElementById("receiverlist").innerHTML += ", " + g_attendant["name"][length];
            	document.getElementById("receiverlist2").innerHTML += ", " + g_attendant["name2"][length];
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
    document.getElementById("receiverinput").value = "";
    i = 0;
    if (checknametype != "")
        manage_attendant_after();
}

function check_name_Complete(rgParams) {
    DivPopUpHidden();
    if (rgParams["name"] != "") {
        if (g_attendant == null)
            g_attendant = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array() };

        if (rgParams["id"] != userid) {
            var length = g_attendant["name"].length;
            for (var j = 0; j < length; j++) {
                if (g_attendant["id"][j] == rgParams["id"]) {
                    alert(strLang22);
                    return;
                }
            }
        }
        else {
            alert(strLang24);
            return;
        }

        var length = g_attendant["name"].length;

        g_attendant["name"][length] = rgParams["name"];
        g_attendant["id"][length] = rgParams["id"];
        g_attendant["deptname"][length] = rgParams["deptname"];
        g_attendant["name1"][length] = rgParams["name1"];
        g_attendant["name2"][length] = rgParams["name2"];
        g_attendant["deptname2"][length] = rgParams["deptname2"];

        if (length == 0)
            document.getElementById("receiverlist").innerHTML = g_attendant["name"][length];
        else
            document.getElementById("receiverlist").innerHTML += ", " + g_attendant["name"][length];

        if (i != namelength)
            check_name();
    }
    if (i == namelength) {
        i = 0;
        document.getElementById("receiverinput").value = "";
    }
    if (checknametype != "")
        manage_attendant_after();
}
var g_progresswin;
var g_fileList;
var g_fileNameList = new Array();
var g_fileInfoList = new Array();

/*function show_progress(fileinfo)
{
    var feature = GetShowModalPosition(390, 170);
    g_progresswin = window.showModelessDialog("/ezSchedule/scheduleProgress.do?fileinfo=" + escape(fileinfo), "", "dialogWidth=390px; dialogHeight:170px; center:yes; status:no; help:no; edge:sunken" + feature);
}*/

/*function status_change(fileinfo)
{
	try {
		g_progresswin.document.Script.fileinfo_change(fileinfo);
	} catch(e) {}
}*/

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

/*function allday_change()
{
    if (document.getElementById("alldaycheck").checked == true)
	{
        document.getElementById("Stimepicker").style.display = "none";
        document.getElementById("Etimepicker").style.display = "none";
	}
	else
	{
        document.getElementById("Stimepicker").style.display = "";
        document.getElementById("Etimepicker").style.display = "";
	}
}*/

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

//function ListOwnerID_Change()
//{
//    var pListOwnerID = document.getElementById("ListOwnerID").value;
//	var pListOwnerID =  pListOwnerID.split(";;")[0];
//	
//	if (pListOwnerID != "1") {
//	    receiverlist.innerHTML = "";
//	    document.getElementById("publicSelect").disabled = true;
//	    document.getElementById("publicSelect").value = "Y";
//	    g_attendant = null;
//	}
//	else {
//	    document.getElementById("publicSelect").disabled = false;
//	    document.getElementById("publicSelect").value = "N";
//	}
//    //6 : 비서(대리인) 비서일 경우 참석자 초대 가능
//	if (pListOwnerID == "1" || pListOwnerID == "6") {
//	    document.getElementById("publicSelect").value = "N";
//	    document.getElementById("publicSelect").disabled = false;
//	    document.getElementById("receiverinput").disabled = false;
//	    document.getElementById("imgbutton").disabled = false;
//	    document.getElementById("imgbutton").style.display = "";
//	    document.getElementById("receiverTr1").style.display = "";
//	    document.getElementById("receiverTr2").style.display = "";
//	}
//	else {
//	    document.getElementById("publicSelect").value = "Y";
//	    document.getElementById("receiverinput").disabled = true;
//	    document.getElementById("imgbutton").disabled = true;
//	    document.getElementById("imgbutton").style.display = "none";
//	    document.getElementById("receiverTr1").style.display = "none";
//	    document.getElementById("receiverTr2").style.display = "none";
//	}
//}

/*var g_resource = new Array();
var ApproveFlag = "0";
var typeVal = "";
var tmpReFlag = "0";
function manage_resource()
{
    var StartTime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
    var EndTime = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();

    schedule_repetition_cross_dialogArguments[0] = g_resource;
    schedule_repetition_cross_dialogArguments[1] = manage_resource_Complete;

    if (CrossYN()) {
        DivPopUpShow(550, 450, "/ezSchedule/scheduleSelectResource.do?StartTime=" + StartTime + "&EndTime=" + EndTime);
    } else {    	
        var rtn = window.showModalDialog("/ezSchedule/scheduleSelectResource.do?StartTime=" + StartTime + "&EndTime=" + EndTime, g_resource, "dialogHeight:440px; dialogWidth:550px; status:no; scroll:no; help:no; edge:sunken");

        if (typeof (rtn) != "undefined" && rtn.length == 2) {
            if (rtn[0].length == 0 && rtn[1].length == 0) {
                var xmlHttp = createXMLHttpRequest();
                var xmlDoc = createXmlDom();

                var objRoot = xmlDoc.createNode(1, "PARAMETER", "");
                xmlDoc.appendChild(objRoot);

                var objNode1 = xmlDoc.createNode(1, "NUM", "");
                objNode1.text = "";
                objRoot.appendChild(objNode1);

                var objNode2 = xmlDoc.createNode(1, "OWNERID", "");
                objNode2.text = "";
                objRoot.appendChild(objNode2);
                if (g_data["recurrence"] != "") {
                    g_data["recurrence"] = "";
                    g_data["recur_del"] = xmlDoc.xml;
                }
                document.getElementById("resourcerepeatinfo").innerHTML = "";
            }


            g_resource = new Array();
            g_resource[0] = rtn[0];
            g_resource[1] = rtn[1];

            document.all("resourcelist").innerText = "";

            for (var i = 0; i < g_resource[0].length; i++) {
                if (i == 0)
                    document.all("resourcelist").innerText = g_resource[1][i];
                else
                    document.all("resourcelist").innerText += ", " + g_resource[1][i];
            }
        }
    }
}*/

/*var g_data = new Array();
function manage_resource_Complete(rtn) {
    if (rtn[0].length == 0 && rtn[1].length == 0) {
        var xmlHttp = createXMLHttpRequest();
        var xmlDoc = createXmlDom();
        var objNode;

        createNodeInsert(xmlDoc, objNode, "PARAMETER");
        createNodeAndInsertText(xmlDoc, objNode, "NUM", "");
        createNodeAndInsertText(xmlDoc, objNode, "OWNERID", "");
        if (g_data["recurrence"] != "") {
            g_data["recurrence"] = "";
            g_data["recur_del"] = xmlDoc.xml;

        }
        document.getElementById("resourcerepeatinfo").innerHTML = "";
    }
    g_resource[0] = rtn[0];
    g_resource[1] = rtn[1];

    document.getElementById("resourcelist").innerHTML = "";

    for (var i = 0; i < g_resource[0].length; i++) {
        if (i == 0)
            document.getElementById("resourcelist").innerHTML = g_resource[1][i];
        else
            document.getElementById("resourcelist").innerHTML += ", " + g_resource[1][i];
    }
}*/
/*var resourcexmlDoc;
function config_repeat_resource() {
    if (g_resource.length > 0) {
        if (g_resource[0].length == 0) {
            alert(strLang109);
            return;
        }
    }
    else {
        alert(strLang109);
        return;
    }

    var resultXML;
    var xmlHttp = createXMLHttpRequest();
    resourcexmlDoc = createXmlDom();
    var objNode;

    createNodeInsert(resourcexmlDoc, objNode, "PARAMETER");
    createNodeAndInsertText(resourcexmlDoc, objNode, "NUM", "");
    createNodeAndInsertText(resourcexmlDoc, objNode, "OWNERID", "");
    
    if(pattern == "1")
	{
    	g_data["startTime"] = startDateStringOrgin;
    	g_data["endTime"] = endDateStringOrgin; 
	}
	else
	{
	    if (g_sdate == null)
	    {
	    	g_data["startTime"] = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
	    	g_data["endTime"] = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
		    
	    }
	    else
	    {    	    
	    	g_data["startTime"] = g_sdate;
	    	g_data["endTime"] = g_edate; 	        		   
		} 	   
	}
    
    g_data["ftDay"] = "";

    var pAlldaycheck = "";

    if (document.getElementById("alldaycheck").checked == true)
        pAlldaycheck = "1";
    else
        pAlldaycheck = "0";

    g_data["alldaycheck"] = pAlldaycheck;
    
    schedule_repetition_cross_dialogArguments[0] = g_data;
    schedule_repetition_cross_dialogArguments[1] = config_repeat_resource_Complete;

    DivPopUpShow(450, 540, "/ezResource/scheduleRepetition.do");
}

function config_repeat_resource_Complete(rgParams) {
    DivPopUpHidden();
    
    if (typeof (rgParams) == "undefined" || (typeof (rgParams) == "number" && rgParams == -1)) return;

    if (typeof (rgParams) == "number" && rgParams == 0) {
        if (g_data["recurrence"] != "") {
            g_data["recurrence"] = "";
            g_data["str"] = "";
            g_data["recur_del"] = resourcexmlDoc.xml;
        }
        document.getElementById("resourcerepeatinfo").innerHTML = "";
        tmpReFlag = "0";
    }
    else {
        g_data["recurrence"] = rgParams["xml"];
        g_data["str"] = rgParams["str"];
        g_data["startTime"] = rgParams["startTime"];
        g_data["endTime"] = rgParams["endTime"];
        
        document.getElementById("resourcerepeatinfo").innerHTML = g_data["str"];
        tmpReFlag = "1";
    }
}*/

/*function resource_Check(resDate) {
    var check = true;

    if (g_resource[0].length == 0) {
        alert(strLang109);
        return;
    }
    for (var i = 0; i < g_resource[0].length; i++) {
        if (DupCheck(g_resource[0][i], resDate) == false) {
            alert("[" + g_resource[1][i] + "] " + strLang108);
            check = false;
        }
    }
    return check;
}

function resource_save(resDate) {
    var check = true;
    
    if (g_resource[0].length == 0) {
        alert(strLang109);
        return;
    }
    
    for (var i = 0; i < g_resource[0].length; i++) {
		if (DupCheck(g_resource[0][i], resDate) == false) {
            alert("[" + g_resource[1][i] + "] " + strLang108);
            check = false;
        }
    }
    
    var saveResult = "";

    if (check == true) {
		for (var i = 0; i < g_resource[0].length; i++) {
		    saveResult = SaveSchedule_onClick('add', g_resource[0][i], resDate);
		}
    }
    return saveResult;
}*/

/*function DupCheck(resItemID, resDate) {
    var STime = "";
    var ETime = "";
    var allday = false;
    if (resDate != "") {
    	var dateArr = resDate.split("|");
    	
    	if (dateArr[0] == "allday") {
    		STime = dateArr[1] + " 00:00";
    		ETime = dateArr[1] + " 23:59";
    		allday = true;
    	} else {
    		STime = dateArr[0];
    		ETime = dateArr[1];
    	}
    	
    } else {
    	
    	if (document.getElementById("alldaycheck").checked == true) {
            STime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00";
            ETime = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59";
            allday = true;
        } else {
            STime = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
            ETime = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
        }
    	
    }
    
    return !isUsingResource(resItemID, STime, ETime, companyID, "", "add", allday);
}*/

/*function isUsingResource(pResID, pSTime, pETime, pCompanyID, pNum, pCmd, pAllDay) {
    var xmlHTTP = createXMLHttpRequest();
    var xmlDOM = createXmlDom();
    var objNode;
    
    createNodeInsert(xmlDOM, objNode, "DATA");
    createNodeAndInsertText(xmlDOM, objNode, "RESID", pResID);
    createNodeAndInsertText(xmlDOM, objNode, "STIME", pSTime);
    createNodeAndInsertText(xmlDOM, objNode, "ETIME", pETime);
    createNodeAndInsertText(xmlDOM, objNode, "COMPANYID", pCompanyID);
    createNodeAndInsertText(xmlDOM, objNode, "NUM", pNum);
    createNodeAndInsertText(xmlDOM, objNode, "CMD", pCmd);
    createNodeAndInsertText(xmlDOM, objNode, "APPROVE", ApproveFlag);
    
    if (tmpReFlag == "1") { //자원 반복예약
    	var xmlDOMrec = createXmlDom();
		xmlDOMrec = loadXMLString(g_data["recurrence"]);
		
		if(CrossYN()) {
	        var xmlRtn = xmlDOMrec.documentElement;
	        var Node = xmlDOM.importNode(xmlRtn, true);
            xmlDOM.documentElement.appendChild(Node);
	    } else {
	         var xmlRtn = xmlDOMrec.documentElement;
             xmlDOM.documentElement.appendChild(xmlRtn);
	    }
		
		xmlDOMrec = null;
    } else { // 자원 반복예약이 아닐 때에는 allday 따로 넣어줘야함.
    	if (pAllDay) {
    		createNodeAndInsertText(xmlDOM, objNode, "allday", ApproveFlag);
    	}
    }
    
    xmlHTTP.open("POST", "/ezResource/timeDupCheck.do", false);
    xmlHTTP.send(xmlDOM);

    var rtnValue = xmlHTTP.responseText;

    xmlDOM = null;
    xmlHTTP = null;

    if (rtnValue == "False") {
    	return false;
    } else {
    	return true;
    }
}*/

/*function SaveSchedule_onClick(cmd, resItem, resDate) {
	if (resDate == "") {
		if (!document.getElementById("alldaycheck").checked) {
	        if (!CheckStartEndDateTime()) {
	            alert("" + strLang139 + "");
	            return;
	        }
	    }
	    else {
	        if (!AllDayCheckStartEndDateTime()) {
	            alert("" + strLang139 + "");
	            return;
	        }
	    }
	} else {
		var dateArr = resDate.split("|");
		if (dateArr[0] != "allday") {
			if (dateArr[0] >= dateArr[1]) {
				alert("" + strLang139 + "");
	            return;
			}
		}
	}
    
	if (cmd == "mod") {
        if (CheckAdmin() == false && OwnerCheck() == false) {
            alert("" + strLang140 + "");
            return;
        }
    }

    attachSave = true;

    var xmlHttp = createXMLHttpRequest();
    var xmlDoc = createXmlDom();
    var resultXML = createXmlDom();
    var objNode;

    createNodeInsert(xmlDoc, objNode, "PARAMETER");
    createNodeAndInsertText(xmlDoc, objNode, "TITLE", document.getElementById("TextTitle").value);
    createNodeAndInsertText(xmlDoc, objNode, "LOC", "");
    createNodeAndInsertText(xmlDoc, objNode, "T_DISPLAY", "1");

    var objNode4, objNode5, objNode6, objNode7;
    if (tmpReFlag == "0") {
    	if (resDate == "") { // 일반예약
    	    if (document.getElementById("alldaycheck").checked == true) {
    	    	objNode4 = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00";
    	    	objNode5 = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59";
    	    	objNode6 = "1";
    	    } else {
    	    	objNode4 = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Stimepicker').val();
    	    	objNode5 = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " " + $('#Etimepicker').val();
    	    	objNode6 = "0";
    	    }
        } else { // 일반예약(일정반복)
        	var dateArr = resDate.split("|");
        	if (dateArr[0] == "allday") {
        		objNode4 = dateArr[1] + " 00:00";
        		objNode5 = dateArr[1] + " 23:59";
        		objNode6 = "1";
        	} else {
        		objNode4 = dateArr[0];
        		objNode5 = dateArr[1];
        		objNode6 = "0";
        	}
        }
    } else { // 반복예약
    	
    	var xmlDom = createXmlDom();
    	xmlDom = loadXMLString(g_data["recurrence"]);
		
    	var node = SelectSingleNode(xmlDom, "recurrence");
    	objNode4 = getNodeText(SelectSingleNode(node, "startDateTime"));
    	objNode5 = getNodeText(SelectSingleNode(node, "endDateTime"));
		
		if (getNodeText(SelectSingleNode(node, "allday")) == "true") {
			objNode6 = "1";
		} else {
			objNode6 = "0";
		}
    }
    
    createNodeAndInsertText(xmlDoc, objNode, "STARTDATETIME", objNode4);
    createNodeAndInsertText(xmlDoc, objNode, "ENDDATETIME", objNode5);
    createNodeAndInsertText(xmlDoc, objNode, "ALLDAY", objNode6);
    createNodeAndInsertText(xmlDoc, objNode, "ALERT", "");
    createNodeAndInsertText(xmlDoc, objNode, "CONTENT", message.GetEditorContent());
    createNodeAndInsertText(xmlDoc, objNode, "WRITERID", userid);
    createNodeAndInsertText(xmlDoc, objNode, "IMPORTANCE1", document.getElementById("importantSelect").value);
    createNodeAndInsertText(xmlDoc, objNode, "ENTRY", "");
    createNodeAndInsertText(xmlDoc, objNode, "REFLAG", tmpReFlag);
    createNodeAndInsertText(xmlDoc, objNode, "GRESFLAG", "");
    createNodeAndInsertText(xmlDoc, objNode, "NUM", "");
    createNodeAndInsertText(xmlDoc, objNode, "PNUM", "");
    createNodeAndInsertText(xmlDoc, objNode, "OWNERID", resItem);
    createNodeAndInsertText(xmlDoc, objNode, "ATTACHFILES", "");
    createNodeAndInsertText(xmlDoc, objNode, "companyID", companyID);
    createNodeAndInsertText(xmlDoc, objNode, "characterID", "");
    createNodeAndInsertText(xmlDoc, objNode, "typeVal", typeVal);
    createNodeAndInsertText(xmlDoc, objNode, "deptNM", replaceSingleQuotation(deptName));
    createNodeAndInsertText(xmlDoc, objNode, "ownerNM", replaceSingleQuotation(username));

    var objNode23;
    if (ApproveFlag == "1") {
        if (cmd == "add")
            objNode23 = "0";
        else {
            if (reFlagVal == "1" && tmpReFlag == "0")
                objNode23 = "0";
            else
                objNode23 = SavedApproveFlag;
        }
    }
    else {
        objNode23 = "1";
    }
    createNodeAndInsertText(xmlDoc, objNode, "APPROVE", objNode23);
    createNodeAndInsertText(xmlDoc, objNode, "SCHEDULEID", SaveScheduleId);

    xmlHttp.open("POST", "/ezResource/scheduleAddOk.do?cmd=" + cmd + "&type=" + typeVal, false);
    xmlHttp.send(getXmlString(xmlDoc));

    var returnStr, p_num, p_ownerID;

    resultXML = xmlHttp.responseXML;

    var result = "OK";

    if (typeof (resultXML) != "undefined" && getXmlString(resultXML) != "") {
    	if (tmpReFlag != "0") {
            var objNodes = SelectNodes(resultXML, "RTN_DATA")[0];
            p_num = getNodeText(GetChildNodes(objNodes)[0]);
            p_ownerID = getNodeText(GetChildNodes(objNodes)[1]);

            if (p_num == "undefined") {
                p_num = resultXML.getElementsByTagName("NUM")[0].textContent;
                p_ownerID = resultXML.getElementsByTagName("OWNERID")[0].textContent;
            }

            SaveRepetition(p_num, resItem);
        }
    	
        xmlHttp = null;
        if (cmd == "add" && objNode23 == "0") {
            xmlHttp = createXMLHttpRequest();
            xmlHttp.open("POST", "/ezResource/sendMail.do", false);
            xmlHttp.send(xmlDoc.xml);
            xmlHttp = null;
        }
        
    } else {
        alert("" + strLang110 + "");
        result = "ERROR";
    }
    return result;
}*/

/*function SaveRepetition(org_num, org_ownerID) {
    var xmlHttp = createXMLHttpRequest();
    xmlHttp.open("POST", "/ezResource/scheduleRepetitionProc.do?cmd=add&num=" + org_num + "&ownerID=" + org_ownerID, false);
    xmlHttp.send(g_data["recurrence"]);

    var res = xmlHttp.responseText;

    if (trim(res) == "NO") {
        alert("" + strLang112 + "");
        return;
    }
}*/

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
        var lstAttachLink = dadiframe.document.getElementById("lstAttachLink");
        lstAttachLink.insertBefore(listtable, lstAttachLink.firstChild);        
        dadiframe.document.getElementById("attachInnerNotice").className = "attachInnerNotice_p_off";

        var extCheck = false;
        for (i = 0; i < SelectNodes(xml, "ROOT/NODES/DATA").length; i++) {
            var newFileName = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA")[i]);
            var pFileName = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA2")[i]);
            var fileSize = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA3")[i]);
            var attid = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA4")[i]);

            if (getNodeText(SelectNodes(xml, "ROOT/NODES/DATA5")[i]) == "OK") {
                objTr = document.createElement("TR");
                //2018-07-06 김보미
                //objTr.setAttribute("DATA2", newFileName + ";" + fileSize);
                objTr.setAttribute("DATA", newFileName);//UUID
                objTr.setAttribute("DATA2", pFileName);//파일명
                objTr.setAttribute("DATA3", fileSize);//파일사이즈
                objTr.setAttribute("draggable", true);
                objTr.setAttribute("_fileIndex", i);

                var objTd = document.createElement("TD");
                objTd.style.textAlign = "center";

                var input = document.createElement("input");
                input.type = "checkbox";
                input.name = "fileSelect";
    	        var oDiv = document.createElement("div");
    	        oDiv.className = "custom_checkbox";

    	        oDiv.appendChild(input);
                objTd.appendChild(oDiv);
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
    //var BodyHTMLContent = Make_BodyHTMLContent(tempDiv.innerHTML);
    var BodyHTMLContent = HTMLtoMHT_MakeTag(tempDiv);
    MakeXmlNode(xmlDoc, rootNode, "CONTENT", BodyHTMLContent);
}

/*function Signature_ImagePathConvert(tbContent) {
    var tempDiv = document.createElement("DIV");
    tempDiv.innerHTML = tbContent;
    var imgColl = tempDiv.getElementsByTagName("IMG");
    var OrgBody = tbContent;
    for (var i = 0; i < imgColl.length; i++) {
        if (imgColl.item(i).src.indexOf("file:///") == 0) {
            var OrgSrc = imgColl.item(i).src;
            var NewSrc = ConvertSaveImageFile(OrgSrc);
            OrgBody = OrgBody.replace(OrgSrc, NewSrc);
        }
    }
    return OrgBody;
}*/
/*function ConvertSaveImageFile(filename) {
    filename = unescape(filename);
    filename = ReplaceText(filename, "file:///", "");

    var fileExt = filename.substr(filename.length - 3).toLowerCase();
    var result = false;
    var ezUtil = new ActiveXObject("ezUtil.MiscFunc.1");
    ezUtil.UseUTF8 = true;
    if (fileExt == "bmp") {
        var imageGUID = ezUtil.GetGUID();

        var newfilename = filename.substr(0, filename.lastIndexOf("/") + 1) + imageGUID + ".png";
        var imageUtil = new ActiveXObject("ezUtil.ImageFunc");

        result = imageUtil.ConvertImageFormat(filename, newfilename, "image/png");

    }

    if (result == true)
        filename = newfilename;

    var fullpath = filename;
    var encodedText = ezUtil.DownloadToBase64(fullpath);

    if (result == true)
        ezUtil.DeleteFile(filename);

    var XmlHttp = createXMLHttpRequest();
    var xmlDom = createXmlDom();
    var objNode;
    createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "IMAGECONTENT", encodedText);
    createNodeAndInsertText(xmlDom, objNode, "IMAGEEXT", fileExt);
    try {
        XmlHttp.open("POST", "/myoffice/Common/ImageToSaveFile_Stream.aspx", false);
        XmlHttp.send(xmlDom);
        return XmlHttp.responseText;
    }
    catch (e) { }
}*/
function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");
    return (orgStr.replace(re, replaceStr));
}

/*function getFirstDateInfo(startDate, endDate) {
	var returnValue = "";
	
	var xmlHTTP = createXMLHttpRequest();
	var xmlDom = createXmlDom();    
	var objNode;

	objNode = createNodeInsert(xmlDom, objNode, "DATA");
	
	createNodeAndInsertText(xmlDom, objNode, "STARTDATE", startDate.getFullYear() + "-" + setLength((parseInt(startDate.getMonth()) + 1)) + "-" + setLength(startDate.getDate()) + " " + setLength(startDate.getHours()) + ":" + setLength(startDate.getMinutes()));
	createNodeAndInsertText(xmlDom, objNode, "ENDDATE", endDate.getFullYear() + "-" + setLength((parseInt(endDate.getMonth()) + 1)) + "-" + setLength(endDate.getDate()) + " " + setLength(endDate.getHours()) + ":" + setLength(endDate.getMinutes()));
	createNodeAndInsertText(xmlDom, objNode, "REPETITION", repetition);
	
	xmlHTTP.open("POST", "/ezSchedule/getFirstScheduleDate.do", false);
	xmlHTTP.send(xmlDom);

	if (xmlHTTP.status != 200) {
	    if (xmlHTTP.responseText.indexOf("OK") == -1) {
	    	alert(strLang17);
	    }
	}
	else {
		returnValue = xmlHTTP.responseText;
	}
	
	return returnValue;
}*/

function setLength(num) {
    if (num < 10) {
        num = "0" + num;
    }
    return num;
}

//언젠간 쓰일지도 모를 repetition->g_data["recurrence"] 변환 함수
/*function makeResRepetition(startDate, endDate) {
	var info = repetition.split("|");
	
	var recurrenceDom = createXmlDom();
    var objNode;
    createNodeInsert(recurrenceDom, objNode, "recurrence");
	
    switch (Number(info[0])) {
    case -1: 
		createNodeAndInsertText(recurrenceDom, objNode, "endRecurType", 0);
		break;
    case 0: 
		createNodeAndInsertText(recurrenceDom, objNode, "endRecurType", 1);
		break;
    default: 
		createNodeAndInsertText(recurrenceDom, objNode, "endRecurType", 2);
    	createNodeAndInsertText(recurrenceDom, objNode, "instances", info[0]);
    
		break;
    }
    
    if (Number(info[1]) == 1) {
    	createNodeAndInsertText(recurrenceDom, objNode, "allday", "true");
    }
    
	switch (Number(info[2])) {
	case 0: //매일
		createNodeAndInsertText(recurrenceDom, objNode, "frequency", 4);
		
		if (Number(info[3]) == 0) { //매일(평일)
			createNodeAndInsertText(recurrenceDom, objNode, "selType", 1);
			createNodeAndInsertText(recurrenceDom, objNode, "interval", 1);
			createNodeAndInsertText(recurrenceDom, objNode, "daysOfWeek", "1,2,3,4,5,");
		} else {
			createNodeAndInsertText(recurrenceDom, objNode, "selType", 0);
			createNodeAndInsertText(recurrenceDom, objNode, "interval", info[3]);
		}
		
		break;
	case 1: //매주
		createNodeAndInsertText(recurrenceDom, objNode, "frequency", 5);
		createNodeAndInsertText(recurrenceDom, objNode, "selType", 1);
		createNodeAndInsertText(recurrenceDom, objNode, "interval", info[3]);
		
		var daysOfWeek = "";
		for (var i=0; i<info[4].length; i++) {
			daysOfWeek += info[4].charAt(i) + ",";
		}
		createNodeAndInsertText(recurrenceDom, objNode, "daysOfWeek", daysOfWeek);
		
		break;
	case 2: //매월
		createNodeAndInsertText(recurrenceDom, objNode, "frequency", 6);
		
		if (Number(info[3]) == 1) { //날짜
			createNodeAndInsertText(recurrenceDom, objNode, "selType", 0);
			createNodeAndInsertText(recurrenceDom, objNode, "interval", info[4]);
			createNodeAndInsertText(recurrenceDom, objNode, "daysOfMonth", info[5]);
			
		} else { //요일(info[3] == "2")
			createNodeAndInsertText(recurrenceDom, objNode, "selType", 1);
			createNodeAndInsertText(recurrenceDom, objNode, "interval", info[4]);
			
			var byPosition = info[5];
			if (Number(byPosition) == 5) {
				byPosition = "-1";
			}
			createNodeAndInsertText(recurrenceDom, objNode, "byPosition", byPosition);
			createNodeAndInsertText(recurrenceDom, objNode, "daysOfWeek", info[6]);
		}
		
		break;
	case 3: //매년
		createNodeAndInsertText(recurrenceDom, objNode, "frequency", 7);
		
		if (Number(info[3]) == 1) { //날짜
			createNodeAndInsertText(recurrenceDom, objNode, "selType", 0);
			createNodeAndInsertText(recurrenceDom, objNode, "monthsOfYear", info[4]);
			createNodeAndInsertText(recurrenceDom, objNode, "daysOfMonth", info[5]);
			
		} else { //요일(info[3] == "2")
			createNodeAndInsertText(recurrenceDom, objNode, "selType", 1);
			createNodeAndInsertText(recurrenceDom, objNode, "monthsOfYear", info[4]);
			
			var byPosition = info[5];
			if (Number(byPosition) == 5) {
				byPosition = "-1";
			}
			createNodeAndInsertText(recurrenceDom, objNode, "byPosition", byPosition);
			createNodeAndInsertText(recurrenceDom, objNode, "daysOfWeek", info[6]);
		}
		
		break;
	}
	
	createNodeAndInsertText(recurrenceDom, objNode, "startDateTime", startDate);
	createNodeAndInsertText(recurrenceDom, objNode, "endDateTime", endDate);
	
	g_data["recurrence"] = getXmlString(recurrenceDom);
}*/