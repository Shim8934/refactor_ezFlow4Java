function close_onclick() {
    if (!confirm("" + strLang8 + ""))
        window.close();
    else
        save_task();
}
	
function show_personinfo(userid) {
    if (userid == "0")
        userid = creatorid;

    var feature = GetOpenPosition(420, 450);
    window.open("/myoffice/common/ShowPersonInfo.aspx?id=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
}

function GetOpenPosition(popUpW, popUpH) {
    var heigth = window.screen.availHeight;
    var width = window.screen.availWidth;
    var left = 0;
    var top = 0;

    var pleftpos;
    pleftpos = parseInt(width) - popUpW;
    heigth = parseInt(heigth) - popUpH;
    width = parseInt(width) - pleftpos;

    left = pleftpos / 2;
    top = heigth / 2;

    var feature = ",left=" + left + ",top=" + top;
    return feature
}
					
function save_task() {
    var sDate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
    var eDate = new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());

    if (sDate > eDate) {
        alert(strLang_1);
        return;
    }
    if (document.getElementById("TextTitle").value == "") {
        alert("" + strLang9 + "");
        document.getElementById("TextTitle").focus();
        return;
    }

    if (document.getElementById("taskstatusSelect").value != 3 && document.getElementById("TextCompleteDate").value != "") {
        alert("" + strLang10 + "");
        document.getElementById("TextCompleteDate").focus();
        return;
    }

    if (!check_length(document.getElementById("TextTitle").value, 100, "" + strLang11 + "")) return;
    if (!check_length(document.getElementById("TextCompleteDate").value, 20, "" + strLang12 + "")) return;

    var xmlDom = createXmlDom();
    var xmlHTTP = createXMLHttpRequest();

    var objRoot, objNode, attachnode, shobjnode;
    objNode = createNodeInsert(xmlDom, objNode, "DATA");
    createNodeAndInsertText(xmlDom, objNode, "TASKID", taskid);
    createNodeAndInsertText(xmlDom, objNode, "OWNERID", userid);
    createNodeAndInsertText(xmlDom, objNode, "CREATORID", userid);
    createNodeAndInsertText(xmlDom, objNode, "CREATORNAME", username);
    createNodeAndInsertText(xmlDom, objNode, "CREATORNAME2", username2);
    createNodeAndInsertText(xmlDom, objNode, "HASSHARE", hasshare);
    createNodeAndInsertText(xmlDom, objNode, "TASKSTATUS", document.getElementById("taskstatusSelect").value);
    createNodeAndInsertText(xmlDom, objNode, "COMPLETERATE", document.getElementById("completerateSelect").value);
    createNodeAndInsertText(xmlDom, objNode, "COMPLETEDATE", document.getElementById("TextCompleteDate").value);
    createNodeAndInsertText(xmlDom, objNode, "IMPORTANCE", document.getElementById("importantSelect").value);

    if (repetition == "") {
        createNodeAndInsertText(xmlDom, objNode, "STARTDATE", $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00");
        createNodeAndInsertText(xmlDom, objNode, "ENDDATE", $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59");
    }
    else {

        var sdate, edate;

        if (g_sdate == null) {
            startdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
            enddate = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
            sdate = new Date(startdate.substring(0, 4), parseInt(startdate.substring(5, 7)) - 1, startdate.substring(8, 10));
            edate = new Date(enddate.substring(0, 4), parseInt(enddate.substring(5, 7)) - 1, enddate.substring(8, 10));
        }
        else {
            sdate = new Date(g_sdate.substring(0, 4), parseInt(g_sdate.substring(5, 7)) - 1, g_sdate.substring(8, 10));
            edate = new Date(g_edate.substring(0, 4), parseInt(g_edate.substring(5, 7)) - 1, g_edate.substring(8, 10));
        }

        createNodeAndInsertText(xmlDom, objNode, "STARTDATE", sdate.getFullYear() + "-" + (parseInt(sdate.getMonth()) + 1) + "-" + sdate.getDate() + " 00:00");
        createNodeAndInsertText(xmlDom, objNode, "ENDDATE", edate.getFullYear() + "-" + (parseInt(edate.getMonth()) + 1) + "-" + edate.getDate() + " 23:59");
    }
    createNodeAndInsertText(xmlDom, objNode, "REPETITION", repetition);
    createNodeAndInsertText(xmlDom, objNode, "TITLE", document.getElementById("TextTitle").value);



    var linkColl = document.getElementById("tbContentElement").Editor.DOM.body.getElementsByTagName("A");
    for (var i = 0; i < linkColl.length; i++)
        linkColl.item(i).target = "_blank";

    createNodeAndInsertText(xmlDom, objNode, "CONTENT", document.getElementById("tbContentElement").DocumentHTML);

    if (taskid == "") {
        createNodeAndInsertText(xmlDom, objNode, "CONTENTPATH", "");
    }
    else {
        createNodeAndInsertText(xmlDom, objNode, "CONTENTPATH", content);
    }


    var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
    ezUtil.UseUTF8 = true;

    var fileNameList = form1.EzHTTPTrans.FileListAll().split("\\");

    var list = createNodeAndAppandNode(xmlDom, objNode, list, "ATTACHLIST");
    for (var i = 0 ; i < fileNameList.length - 1 ; i++) {
        var fileInfo = form1.EzHTTPTrans.GetfilePath(i);
        var fileName = fileNameList[i];
        var fileSize = form1.EzHTTPTrans.GetFileSize(i);

        createNodeAndAppandNodeText(xmlDom, list, attachnode, "ATTACH", fileInfo.substring(fileInfo.lastIndexOf("/"), fileInfo.length) + "/" + fileName + "/" + fileSize);
    }

    var sharelist = createNodeAndAppandNode(xmlDom, objNode, sharelist, "SHARELIST");
    if (g_share != null) {
        for (var i = 0; i < g_share["id"].length; i++) {
            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHARERID", g_share["id"][i]);
            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHARERNAME1", g_share["name1"][i]);
            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHARERNAME2", g_share["name2"][i]);
            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHARERDEPTNAME", g_share["deptname"][i]);
            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHARERDEPTNAME2", g_share["deptname2"][i]);
        }
    }
    var personlist = createNodeAndAppandNode(xmlDom, objNode, personlist, "PERSONLIST");

    if (taskType == 1) {
        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONID", userid);
        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONNAME1", username);
        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONNAME2", username2);
        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONDEPTNAME", deptname);
        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONDEPTNAME2", deptname2);
    }
    else {
        var person = "";

        if (g_person != null) {
            if (g_person["id"].length > 1) { alert("" + strLang41 + ""); return; }
            for (var i = 0; i < g_person["id"].length; i++) {
                createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONID", g_person["id"][i]);
                createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONNAME1", g_person["name1"][i]);
                createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONNAME2", g_person["name2"][i]);
                createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONDEPTNAME", g_person["deptname"][i]);
                createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONDEPTNAME2", g_person["deptname2"][i]);

                if (person != "")
                    person += ", ";
                person += g_person["name"][i] == "" ? g_person["deptname"][i] : g_person["name"][i];
            }
        }
        if (person == "" || person == null) {
            alert("" + strLang57 + "");
            return;
        }
    }

    createNodeAndInsertText(xmlDom, objNode, "TASKTYPE", taskType);

    xmlHTTP.open("POST", "/myoffice/ezTask/remote/task_save.aspx", false);
    xmlHTTP.send(xmlDom);

    if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
        alert("" + strLang13 + "");
    else {
        alert("" + strLang14 + "");

        try { window.opener.document.Script.RefreshView() } catch (e) { }
        window.close();
    }
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

function manage_share(type) {
    switch (type) {
        case 1:
//            var rtn = window.showModalDialog("/ezTask/taskSelectAttendatn.do?type=P&title=" + encodeURI(strLang15) + "", g_person, "dialogHeight:655px; dialogWidth:970px; status:no; scroll:no; help:no; edge:sunken");
        	var rtn = window.showModalDialog("/ezTask/taskSelectAttendant.do", g_person, "dialogHeight:655px; dialogWidth:970px; status:no; scroll:no; help:no; edge:sunken");
        	if (typeof (rtn) != "undefined") {
                if (rtn["id"].length > 1) {
                    alert(strLang54);
                    return;
                }
                if (g_share != null) {
                    for (var i = 0; i < g_share["email"].length; i++) {
                        if (rtn["email"][0] == g_share["email"][i]) {
                            alert(rtn["name"][0] + strLang55);
                            return;
                        }
                    }
                }
                g_person = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

                if (rtn["id"].length == 0) {
                    setNodeText(document.getElementById("personlist"), "");
                    return;
                }

                setNodeText(document.getElementById("personlist"), rtn["name"][0]);

                g_person["name"] = rtn["name"];
                g_person["id"] = rtn["id"];
                g_person["deptname"] = rtn["deptname"];
                g_person["name1"] = rtn["name1"];
                g_person["name2"] = rtn["name2"];
                g_person["deptname2"] = rtn["deptname2"];
                g_person["email"] = rtn["email"];
            }
            break;
        case 2:
//            var rtn = window.showModalDialog("/myoffice/ezTask/task_select_entity_Cross.aspx?title=" + encodeURI(strLang15) + "", g_share, "dialogHeight:655px; dialogWidth:970px; status:no; scroll:no; help:no; edge:sunken");
        	var rtn = window.showModalDialog("/ezTask/taskSelectAttendant.do", g_person, "dialogHeight:655px; dialogWidth:970px; status:no; scroll:no; help:no; edge:sunken");
        	if (typeof (rtn) != "undefined") {
                g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

                setNodeText(document.getElementById("sharelist"), "");

                var j = 0;
                for (var i = 0; i < rtn["id"].length; i++) {
                    if (g_person != null && g_person["email"][0] == rtn["email"][i]) {
                        alert(rtn["name"][i] + strLang56);
                    }
                    else {
                        if (getNodeText(document.getElementById("sharelist")) == "")
                            setNodeText(document.getElementById("sharelist"), rtn["name"][i]);
                        else
                            setNodeText(document.getElementById("sharelist"), getNodeText(document.getElementById("sharelist")) + ", " + rtn["name"][i]);

                        g_share["name"][j] = rtn["name"][i];
                        g_share["id"][j] = rtn["id"][i];
                        g_share["deptname"][j] = rtn["deptname"][i];
                        g_share["name1"][j] = rtn["name1"][i];
                        g_share["name2"][j] = rtn["name2"][i];
                        g_share["deptname2"][j] = rtn["deptname2"][i];
                        g_share["email"][j] = rtn["email"][i];
                        j++;
                    }
                }
            }
            break;
    }
}

function on_keydown(type)
{
	if (window.event.keyCode == "13")
	    check_name(type);
}

function check_name(type)
{
    var name = "";
    if (type == 1) {
        name = document.getElementById("personinput").value;
        list = document.getElementById("personlist").innerHTML;
        name = ReplaceText(name, ",", ";");
        var names = name.split(";");

        if (names.length > 1 || list != "") {
            alert("담당자는한명");
            return;
        }
    }
    else {
        name = document.getElementById("receiverinput").value;
        name = ReplaceText(name, ",", ";");
        var names = name.split(";");
    }

	for (var i=0; i<names.length; i++)
	{
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
			xmlHTTP.open("POST","/myoffice/ezOrgan/OrganInfo/GetSearchList.aspx",false);
			xmlHTTP.send(xmlDOM.xml);

			if (xmlHTTP.statusText != "OK")
			{
				alert("" + strLang16 + "" + xmlHTTP.statusText);
				xmlDOM = null;
				xmlHTTP = null;
				continue;
			}
			else
			{
			    xmlDOM = loadXMLString(xmlHTTP.responseText);
				adCount = xmlDOM.getElementsByTagName("ROW").length;
			}
		} catch(e) 
		{
			alert("" + strLang16 + "" + e.description);
			xmlDOM = null;
			xmlHTTP = null;
			continue;
		}

		if (adCount == 0)
		{
			alert("'" + names[i] + "' " + strLang17 + "");
			continue;
		}
		else if (adCount == 1)
		{
		    if (type == 1) {
		        if (g_person == null)
		            g_person = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

		        if (getNodeText(xmlDOM.getElementsByTagName("DATA2").item(0)) != userid) {
		            var length = g_person["name"].length;
		            for (var j = 0; j < length; j++)
		                if (g_person["id"][j] == getNodeText(xmlDOM.getElementsByTagName("DATA2").item(0))) {
		                    alert("" + strLang18 + "");
		                    return;
		                }
		        }
		        else {
		            alert("" + strLang20 + "");
		            return;
		        }

		        g_person["name"][length] = getNodeText(xmlDOM.getElementsByTagName("VALUE").item(3));
		        g_person["id"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA2").item(0));
		        g_person["deptname"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA7").item(0));
		        g_person["name1"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA5").item(0));
		        g_person["name2"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA6").item(0));
		        g_person["deptname2"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA8").item(0));
		        g_person["email"][i] = getNodeText(xmlDOM.getElementsByTagName("VALUE").item(4));
		        setNodeText(document.getElementById("personlist"), g_person["name"][length]);
		    }
		    else {
		        if (g_share == null)
		            g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

		        if (getNodeText(xmlDOM.getElementsByTagName("DATA2").item(0)) != userid) {
		            var length = g_share["name"].length;
		            for (var j = 0; j < length; j++)
		                if (g_share["id"][j] == getNodeText(xmlDOM.getElementsByTagName("DATA2").item(0))) {
		                    alert("" + strLang18 + "");
		                    return;
		                }
		        }
		        else {
		            alert("" + strLang20 + "");
		            return;
		        }

		        g_share["name"][length] = getNodeText(xmlDOM.getElementsByTagName("VALUE").item(3));
		        g_share["id"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA2").item(0));
		        g_share["deptname"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA7").item(0));
		        g_share["name1"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA5").item(0));
		        g_share["name2"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA6").item(0));
		        g_share["deptname2"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA8").item(0));
		        g_share["email"][i] = getNodeText(xmlDOM.getElementsByTagName("VALUE").item(4));

		        if (length == 0)
		            setNodeText(document.getElementById("sharelist"), g_share["name"][length]);
		        else
		            setNodeText(document.getElementById("sharelist"), getNodeText(document.getElementById("sharelist")) + ", " + g_share["name"][length]);
		    }
		}
		else 
		{
			var rgParams = new Array();
			rgParams["addrBook"] = xmlDOM;
			rgParams["name"] = "";
			rgParams["id"] = "";
			rgParams["deptname"] = "";
			rgParams["name1"] = "";
			rgParams["name2"] = "";
			rgParams["deptname2"] = "";
			rgParams["email"] = "";
			
			window.showModalDialog("/myoffice/ezTask/htm/checkName_Cross.aspx", rgParams, "dialogHeight:350px; dialogWidth:610px; status:no;scroll:no; help:no; edge:sunken");

			if (rgParams["name"] != "")
			{
			    if (type == 1) {
			        if (g_person == null)
			            g_person = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

			        if (rgParams["id"] != userid) {
			            for (var j = 0; j < g_person["id"].length; j++)
			                if (g_person["id"][j] == rgParams["id"]) {
			                    alert("" + strLang18 + "");
			                    return;
			                }
			        }
			        else {
			            alert("" + strLang20 + "");
			            return;
			        }

			        var length = g_person["name"].length;
			        g_person["name"][length] = rgParams["name"];
			        g_person["id"][length] = rgParams["id"];
			        g_person["deptname"][length] = rgParams["deptname"];
			        g_person["name1"][length] = rgParams["name1"];
			        g_person["name2"][length] = rgParams["name2"];
			        g_person["deptname2"][length] = rgParams["deptname2"];
			        g_person["email"][i] = rgParams["email"];
			        setNodeText(document.getElementById("personlist"), g_person["name"][length]);
			    }
			    else {
			        if (g_share == null)
			            g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

			        if (rgParams["id"] != userid) {
			            for (var j = 0; j < g_share["id"].length; j++)
			                if (g_share["id"][j] == rgParams["id"]) {
			                    alert("" + strLang18 + "");
			                    return;
			                }
			        }
			        else {
			            alert("" + strLang20 + "");
			            return;
			        }

			        var length = g_share["name"].length;
			        g_share["name"][length] = rgParams["name"];
			        g_share["id"][length] = rgParams["id"];
			        g_share["deptname"][length] = rgParams["deptname"];
			        g_share["name1"][length] = rgParams["name1"];
			        g_share["name2"][length] = rgParams["name2"];
			        g_share["deptname2"][length] = rgParams["deptname2"];
			        g_share["email"][i] = rgParams["email"];
			        if (length == 0)
			            setNodeText(document.getElementById("sharelist"), g_share["name"][length]);
			        else
			            setNodeText(document.getElementById("sharelist"), getNodeText(document.getElementById("sharelist")) + ", " + g_share["name"][length]);
			    }
			}
		}
	}
    if(type == 1)
        document.getElementById("personinput").value = "";
	else
        document.getElementById("receiverinput").value = "";
}
	
var g_progresswin;
var g_fileList;
var g_fileNameList = new Array();
var g_fileInfoList = new Array();

function attach_Add(ocx_file)
{
	var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	ezUtil.UseUTF8 = true;
	
	if(!ocx_file)
    {
        var file = ezUtil.OpenLoadDlgMultiNew("All Files (*.*)\0*.*\0Microsoft Office Files\0*.doc;*.xls;*.ppt;*.pst;*.mdb;\0Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0Text Files\0*.txt;*.csv;\0Archive Files\0*.zip;*.rar;*.cab;*.alz;*.tar\0Executable Files\0*.exe;*.com;*.bat;\0\0", "")

        if (!file)
            return;

        g_fileList = file.split("|");
	}
	else
	{
	    g_fileList = ocx_file.split("|");
	}

	var fileSize = 0;

	for (var i = 0; i < g_fileList.length - 1; i++) {	 
	    fileSize += ezUtil.GetFileSize(g_fileList[i]);
	}

	ezUtil = null;

	if (fileSize > 5 * 1024 * 1024)
	{
		alert("" + strLang21 + "");
		return;
	}
    
	var fileName = "";
    form1.EzHTTPTrans.AddUploadFile("","");
	for (var i=0; i<g_fileList.length-1; i++)
	{
		try 
		{
			if (i > 0)
				status_change(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\")+1) + "" + strLang22 + "" + (i+1) + "/" + (g_fileList.length-1));

            form1.EzHTTPTrans.AddUploadFile(g_fileList[i], "N");
		} 
		catch (e) 
		{
			try {
			} catch(e) {}

			alert(g_fileList[i] + " " + strLang24 + "" + "\n\n" + e.number + " - " + e.description);
			return;
		}	
	}
	
	var RemotePath = document.location.protocol+"//" + document.location.hostname + "/myoffice/ezTask/remote/task_uploadfile.aspx";
	var nCount = form1.EzHTTPTrans.StartUpload(RemotePath,"/Upload_DocManagement","DocManagement" , "","");

    if (nCount == 0)
	{
	    alert(g_fileList[0] + strLang23);
	    return false;
	}
	var newFileName = new Array();
	var fileSize = new Array();
	var localFilePath = new Array();
	var extCheck = new Array();
	var extFlag = false;
    for (var i = 0; i < nCount; i++)
	{
        var fileinfo = form1.EzHTTPTrans.GetReturn(i);
		var infos = fileinfo.split('/');
		localFilePath[i] = infos[0];		
		var fileName = infos[0].substr(infos[0].lastIndexOf("\\") + 1);
		extCheck[i] = infos[1];
		newFileName[i] = infos[2];
		fileSize[i] = infos[4];
		
		if (extCheck[i] == "denied")
		    extFlag = true;

		if (fileName.length > 1000)
		{			
			alert(g_fileList[i] + " " + strLang23 + "");
			return;
		}
		else
		{
			g_fileInfoList[i] = newFileName[i] + "/" + fileName + "/" + infos[3];
			g_fileNameList[i] = fileName;
		}
    }
    if (extFlag)
        alert(strLang58);

	var attachText = "";
	for (var i = 0; i < g_fileList.length - 1; i++) {
	    if (extCheck[i] == "OK") {
	        form1.EzHTTPTrans.InsertFileList(g_fileNameList[i], localFilePath[i], "N", "N", fileSize[i]);
	        form1.EzHTTPTrans.InsertFileInfo(newFileName[i]);
	    }
	}
}

function show_progress(fileinfo) {
    g_progresswin = window.showModelessDialog("/myoffice/ezTask/task_progress.aspx?fileinfo=" + escape(fileinfo), "", "dialogWidth=390px; dialogHeight:170px; center:yes; status:no; help:no; edge:sunken");
}

function status_change(fileinfo) {
    try {
        g_progresswin.document.Script.fileinfo_change(fileinfo);
    } catch (e) { }
}

function attach_Delete() {
    document.getElementById("EzHTTPTrans").DeleteFileList();
}

function restore_deleted()
{
	if (repetitiondel == "")
	{
		alert("" + strLang25 + "");
		return;
	}
	
	if (!confirm("" + strLang26 + ""))
		return;
		
	var xmlDom = createXmlDom();
	var xmlHTTP = createXMLHttpRequest();
		
	var objNode;
	createNodeInsert(xmlDom, objNode, "DATA");
	createNodeAndInsertText(xmlDom, objNode, "DATA", taskid);
	
	xmlHTTP.open("POST", "/myoffice/ezTask/remote/task_restore_delete.aspx", false);
	xmlHTTP.send(xmlDom);

	if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
		alert("" + strLang27 + "");
	else
	{
		alert("" + strLang28 + "");
		
		try { window.opener.document.Script.RefreshView() } catch(e) {}
		repetitiondel = "";
		show_repetition_info();
	}	
}

var g_sdate = null;
var g_edate = null;
function config_repeat()
{
	var args = new Array();
	if (g_sdate == null)
	{
	    args["SDATE"] = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	    args["EDATE"] = $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val();
	}
	else
	{
		args["SDATE"] = g_sdate;
		args["EDATE"] = g_edate;
	}
		
	args["REPETITION"] = repetition;
	
	var rtn = window.showModalDialog("/myoffice/ezTask/htm/task_repetition_Cross.aspx", args, "dialogHeight:450px; dialogWidth:460px; status:no;scroll:no;help:no;edge:sunken");
	
	if (typeof(rtn) != "undefined")
	{
		if (rtn["REPETITION"] == "")
		{
			repetition = "";
			document.getElementById("periodblock").style.display = "";
			document.getElementById("repeatblock").style.display = "none";
			document.getElementById("repeatinfo").innerHTML = "&nbsp;";
		}
		else
		{
			g_sdate = rtn["SDATE"];
			g_edate = rtn["EDATE"];
			repetition = rtn["REPETITION"];
			show_repetition_info();
		}
	}
}

function show_repetition_info()
{
	document.getElementById("periodblock").style.display = "none";
	document.getElementById("repeatblock").style.display = "";
			
	var info = repetition.split("|");
	var repeatinfo = "" + strLang29 + "";
	
	switch (info[2])
	{
		case "0":
			repeatinfo += "" + strLang30 + "";
			break;
		case "1":
			repeatinfo += "" + strLang31 + "";
			break;
		case "2":
			repeatinfo += "" + strLang32 + "";
			break;
		case "3":
			repeatinfo += "" + strLang33 + "";
			break;
	}
	
	if (repetitiondel != "")
		repeatinfo += ", " + strLang34 + "" + repetitiondel + " " + strLang35 + "";
		
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
		alert(fieldname + "" + strLang36 + "" + maxlength + "" + strLang37 + "");
		return false
	}

	return true;
}

DECMD_SETFONTSIZE = 5045;
OLECMDEXECOPT_DODEFAULT = 0;

var g_originalHTML = null;
var flag = false;
function pzFormProc_DocumentComplete()
{
	if (flag == false) 
	{
	    var URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(content);
	    objMHT.sync = true;
	    var strMht = objMHT.DownloadURL(URL);
	    objMHT.mhtData = strMht;
	    objMHT.filterIn();
	    document.getElementById("tbContentElement").editor.DOM.body.style.fontFamily = strLang38;
	    document.getElementById("tbContentElement").Editor.Dom.body.style.fontSize = "10pt";
	    var htmlData = objMHT.htmlData;
	    document.getElementById("tbContentElement").Editor.Dom.body.innerHTML = htmlData;

	    var FormProc = document.getElementById("tbContentElement").object;
	    document.getElementById("tbContentElement").MHTMLSave = 1;
	    FormProc.Editor.DOM.body.setAttribute("free", "");
	    MHTLoadComplete = "true";
	    document.getElementById("tbContentElement").SetFontInfo(strLang38, 10);
	}
}

function pzFormProc_FieldsAvailable()
{
    document.getElementById("tbContentElement").ShowWorkingDlg("", false);
}

function ModifyAttachOCX(forfilelist)
{
    var arrFiles = forfilelist.split("/");
    
    for(var i = 0; i<arrFiles.length-1 ; i++)
    {
        var fileInfo = arrFiles[i].split("|");
        form1.EzHTTPTrans.InsertFileList(fileInfo[1], document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/downloadattach.aspx?filename="+escape(fileInfo[1])+"&filepath="+escape("/Upload_Task/File/" + fileInfo[0],"N","N",fileInfo[2]) +"&regData="+clientInformation.systemLanguage,"N","N",fileInfo[2]);
	    form1.EzHTTPTrans.InsertFileInfo(fileInfo[0]);
    }
}