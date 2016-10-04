<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t00008'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
	    <script type="text/javascript">
	
	        var pDocID = "${docID}";
	        var pType = "${type}";
	        var ReturnFunction;
	        window.onload = function ()
	        {
	            try {
	                ReturnFunction = parent.totalsavefileinfo_dialogArguments[1];
	            } catch (e) {
	                try {
	                    ReturnFunction = opener.totalsavefileinfo_dialogArguments[1];
	                } catch (e) {
	                }
	            }
	
	        	var result = "";
	        	
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : false,
	        		url : "/ezApprovalG/getTotalDoc.do",
	        		data : {
	        			docID : pDocID,
	        			mode : pType
	        		},
	        		success: function(text){
	        			result = text;
	        		}
	        	});
	        	
	            if (result != "") {
	                var attSN = 1;
	                var docAttach = loadXMLString(result);
	                for (var i = 0; i < SelectNodes(docAttach, "ROW").length; i++) {
	                    var TR = document.createElement("TR");
	                    var TD1 = document.createElement("TD");
	                    var TD2 = document.createElement("TD");
	                    var CHECK = document.createElement("INPUT");
	                    var IMG = document.createElement("IMG");
	                    var SPAN = document.createElement("SPAN");
	                    CHECK.id = "chk_" + i;
	                    CHECK.type = "checkbox";
	                    CHECK.value = getNodeText(SelectNodes(docAttach, "FILEPATH")[i]);
	                    CHECK.setAttribute("DATA1", getNodeText(SelectNodes(docAttach, "TYPE")[i]));
	                    CHECK.setAttribute("DATA2", getNodeText(SelectNodes(docAttach, "FILENAME")[i]));
	                    CHECK.onclick = function () { CheckBoxClick(this); };
	                    TR.ondblclick = function () { FileDown(this); };
	                    TR.style.cursor = "pointer";
	                    TR.setAttribute("FILEPATH", getNodeText(SelectNodes(docAttach, "FILEPATH")[i]));
	                    TR.setAttribute("DATA1", getNodeText(SelectNodes(docAttach, "TYPE")[i]));
	                    TR.setAttribute("DATA2", getNodeText(SelectNodes(docAttach, "FILENAME")[i]));
	                    if (getNodeText(SelectNodes(docAttach, "TYPE")[i]) == "ATT") {
	                        TR.setAttribute("DATA3", attSN);
	                        attSN++;
	                    }
	                    TD1.style.width = "30px";
	                    TD1.appendChild(CHECK);
	                    TD2.style.textAlign = "left";
	                    TD2.style.overflow = "hidden";
	                    TD2.style.textOverflow = "ellipsis";
	                    TD2.style.whiteSpace = "nowrap";
	                    switch (getNodeText(SelectNodes(docAttach, "TYPE")[i]))
	                    {
	                        case "DOC":
	                            IMG.src = "/images/appdoc.png";
	                            break;
	                        case "ATT":
	                            IMG.src = "/images/attach.png";
	                            break;
	                        case "ATTDOC":
	                            IMG.src = "/images/attdoc.png";
	                            break;
	                    }
	                    IMG.style.display = "inline-block";
	                    SPAN.style.paddingLeft = "5px";
	                    SPAN.style.height = "16px";
	                    SPAN.style.verticalAlign = "middle";
	                    SPAN.style.paddingTop = "5px";
	                    SPAN.id = "spn_title";
	                    if (new RegExp(/Firefox/).test(navigator.userAgent))
	                        SPAN.innerHTML = getNodeText(SelectNodes(docAttach, "FILENAME")[i]).replace(/&amp;/gi, "&");
	                    else
	                        SPAN.innerText = getNodeText(SelectNodes(docAttach, "FILENAME")[i]).replace(/&amp;/gi, "&");
	
	                    TD2.appendChild(IMG);
	                    TD2.appendChild(SPAN);
	                    TD1.style.height = "20px";
	                    TD2.style.height = "20px";
	                    TR.appendChild(TD1);
	                    TR.appendChild(TD2);
	                    table_filelist.appendChild(TR);
	                }                
	            }            
	        };
	
	        function FileDown(obj) {
	            var pSourcePath = obj.getAttribute("FILEPATH").split('.')[1];
	            var pDocID_mht = obj.getAttribute("FILEPATH").substring(obj.getAttribute("FILEPATH").lastIndexOf("/") + 1, obj.getAttribute("FILEPATH").length).split('.')[0];
	            if (obj.getAttribute("DATA1") == "ATT")
	                AttachDownFrame.location.href = "/ezApprovalG/downloadAttach.do?type=APPROVALG&docID=" + pDocID + "&docStatus=" + pType + "&docAttachSN=" + obj.getAttribute("DATA3");
	            else if (obj.getAttribute("DATA1") == "ATTDOC") {
	                AttachDownFrame.location.href = "/ezApprovalG/downloadAttach.do?type=APPROVALGMHT&fileName=" + encodeURI(obj.getAttribute("DATA2") + "." + pSourcePath) + "&docID=" + pDocID_mht + "&docStatus=END";
	            }
	            else {
	                AttachDownFrame.location.href = "/ezApprovalG/downloadAttach.do?type=APPROVALGMHT&fileName=" + encodeURI(obj.getAttribute("DATA2") + "." + pSourcePath) + "&docID=" + pDocID_mht + "&docStatus=" + pType;
	            }
	        }
	
	        function btn_OK()
	        {
	            if (strTypeInfo == "")
	            {
	                alert(strLang584);
	                return;
	            }
	            var xmlhttp = createXMLHttpRequest();
	            var xmlpara = createXmlDom();
	            var xmlstring = "<DATA>";
	            xmlstring += "<PDOCID>" + pDocID + "</PDOCID>";
	            xmlstring += "<PTITLE>" + ReplaceText(document.getElementById('spn_title').innerHTML, "\n", "") + "</PTITLE>";
	            xmlstring += "<PTYPEINFO>" + strTypeInfo + "</PTYPEINFO>";
	            xmlstring += "<PPATHINFO><![CDATA[" + strPathInfo.replace("&amp;", "&") + "]]></PPATHINFO>";
	            xmlstring += "<PFILEINFO><![CDATA[" + ReplaceText(strFileName, "\n", "") + "]]></PFILEINFO>";
	            xmlstring += "</DATA>";
	
	            xmlpara = loadXMLString(xmlstring);
	
	            xmlhttp.open("Post", "/ezApprovalG/saveTotalDoc.do", false);
	            xmlhttp.send(xmlpara);
	            var URL = xmlhttp.responseText;

	            AttachDownFrame.location.href = "/ezApprovalG/downloadAttach.do?filePath=" + encodeURIComponent(URL);
	        }
	
	        var strPathInfo = "";
	        var strTypeInfo = "";
	        var strFileName = "";
	        function CheckBoxClick(obj)
	        {
	            document.getElementById('cbx_all').checked = false;
	            if (obj.checked) {
	                obj.parentElement.parentElement.style.backgroundColor = "#DBE1E7";
	                strPathInfo = strPathInfo + obj.value + "|||";
	                strTypeInfo = strTypeInfo + GetAttribute(obj, "data1") + "|||";
	                strFileName = strFileName + GetAttribute(obj, "data2") + "|||";
	            }
	            else {
	                obj.parentElement.parentElement.style.backgroundColor = "#FFFFFF";
	                strPathInfo = strPathInfo.replace(obj.value + "|||", '');
	                strTypeInfo = strTypeInfo.replace(GetAttribute(obj, "data1") + "|||", '');
	                strFileName = strFileName.replace(GetAttribute(obj, "data2") + "|||", '');
	            }
	        }
	        
	        function HeaderCheckBoxClick(obj) {
	            var count = GetChildNodes(document.getElementById('table_filelist')).length;
	            if (!CrossYN())
	                count = count - 1;
	            if (obj.checked) {
	                for (var i = 0; i < count ; i++) {
	
	                    document.getElementById('chk_' + i).checked = true;
	                    if (CrossYN())
	                        GetChildNodes(document.getElementById('table_filelist'))[i].style.backgroundColor = "#DBE1E7";
	                    else {
	                        GetChildNodes(GetChildNodes(document.getElementById('table_filelist'))[i + 1])[0].style.backgroundColor = "#DBE1E7";
	                        GetChildNodes(GetChildNodes(document.getElementById('table_filelist'))[i + 1])[1].style.backgroundColor = "#DBE1E7";
	                    }
	
	                    strPathInfo += document.getElementById('chk_' + i).value + "|||";
	                    strTypeInfo += GetAttribute(document.getElementById('chk_' + i), "data1") + "|||";
	                    strFileName += GetAttribute(document.getElementById('chk_' + i), "data2") + "|||";
	                }
	            }
	            else {
	                for (var i = 0; i < count ; i++) {
	                    document.getElementById('chk_' + i).checked = false;
	
	                    if (CrossYN())
	                        GetChildNodes(document.getElementById('table_filelist'))[i].style.backgroundColor = "#FFFFFF";
	                    else {
	                        GetChildNodes(GetChildNodes(document.getElementById('table_filelist'))[i + 1])[0].style.backgroundColor = "#FFFFFF";
	                        GetChildNodes(GetChildNodes(document.getElementById('table_filelist'))[i + 1])[1].style.backgroundColor = "#FFFFFF";
	                    }
	
	                    strPathInfo = "";
	                    strTypeInfo = "";
	                    strFileName = "";
	                }
	            }
	        }
	        function window_close() {
	            if (ReturnFunction != null)
	                ReturnFunction();
	            window.close();
	        }
	    </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.t00008'/></h1>
	    <h2>&nbsp;&nbsp;※ <spring:message code='ezApprovalG.t00009'/></h2>
	    <table class="mainlist" style="width: 550px; margin-left: 5px;">
	        <tr>
	            <th style="width:30px;"><input id="cbx_all" type="checkbox" onclick="return HeaderCheckBoxClick(this);" value="all" /></th>
	            <th><spring:message code='ezApprovalG.t00010'/></th>
	        </tr>                
	    </table>
	    <div style="overflow-y:auto; overflow-x:auto; height:250px;">
	        <table class="mainlist" id="table_filelist" style="width: 550px; margin-left: 5px;">
	        </table>
	    </div>
	    <br />
	     <div align="center">
	        <a class="imgbtn"><span style="width: 40px; text-align: center;" onclick="btn_OK()"><spring:message code='ezApprovalG.t1760'/></span></a>
	        <a class="imgbtn"><span style="width: 40px; text-align: center;" onclick="window_close()"><spring:message code='ezApprovalG.t1761'/></span></a>
	    </div>
	    <iframe name="AttachDownFrame" id="AttachDownFrame" src="about:blank" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display: none"></iframe>
	</body>
</html>