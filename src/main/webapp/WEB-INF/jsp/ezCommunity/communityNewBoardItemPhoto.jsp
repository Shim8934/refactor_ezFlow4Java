<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<c:choose>
			<c:when test="${pMode == 'new'}">
				<title><spring:message code = 'ezCommunity.t1128' /></title>
			</c:when>

			<c:otherwise>
				<title><spring:message code = 'ezCommunity.t1130' /></title>
			</c:otherwise>
		</c:choose>
		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="${util.addVer('ezCommunity.i1', 'msg')}">
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/ConvertSaveImage.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/AttachMain_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/AttachItem_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/datepicker.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/composeappt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		
		<script type="text/javascript">
			var pUploadFilePath = "<c:out value = '${pUploadPath}' />";
			var pBoardID = "<c:out value = '${boardInfo.boardID}' />";
			var pBoardName = "<c:out value = '${boardInfo.boardName}' />";
			var pMode = "<c:out value = '${pMode}'/>";
			var MHTLoadComplete = "";
			var SSUserID = "<c:out value = '${userInfo.id}' />";
			var SSUserName = "<c:out value = '${userInfo.displayName1}' />";
			var SSUserName2 = "<c:out value = '${userInfo.displayName2}' />";
			var SSDeptID = "<c:out value = '${userInfo.deptID}' />";
			var SSDeptName = "<c:out value = '${userInfo.deptName1}' />";
			var SSDeptName2 = "<c:out value = '${userInfo.deptName2}' />";
			var SSCompanyID = "<c:out value = '${userInfo.companyID}' />";
			var SSCompanyName = "<c:out value = '${userInfo.companyName1}' />";
			var SSCompanyName2 = "<c:out value = '${userInfo.companyName2}' />";
			var strUserRank = "<c:out value = '${userInfo.title1}' />";
			var strUserRank2 = "<c:out value = '${userInfo.title2}' />";
			var strItemID = "<c:out value = '${item.itemID}' />";
			var strParentWriteDate = "<c:out value = '${item.parentWriteDate}' />";
			var strStartDate = "<c:out value = '${item.startDate}' />";
			var strAttachments = "<c:out value = '${item.attachments}' />";
			var strContentLocation = "<c:out value = '${item.contentLocation}' />";
			var strUpperItemIDTree = "<c:out value = '${item.upperItemIDTree}' />";
			var strItemLevel = "<c:out value = '${item.itemLevel}' />";
			
			var pAttachListXml = "";			
			var AttachLimit = "<c:out value = '${boardInfo.attachSizeLimit}' />";			
			var ExpireDays = "<c:out value = '${expireDays}' />";
			var PhotoBoard = "Y";
		    var flag = false;
		    var attachFileNameMaxLength = Number("${attachFileNameMaxLength}");
		    var endDateTime = "<c:out value = '${endDateTime}' />"
		    
		    window.onresize = function () {
		        document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 160 + "PX";
		    }
		    
		    window.onload = function () {
		        if (pMode == "modify" && strAttachments != "") {
		            pAttachListXml = MakeAttachList();
		            RealImageName(pAttachListXml);
		        }
		        		        
		        if (pMode == "modify") {												
		            document.getElementById("txtTitle").value  = ConvMakeXMLString("<c:out value = '${item.title}' />");
			        document.getElementById("txtPhotoFile").value = ConvMakeXMLString("<c:out value = '${item.extensionAttribute4}' />");
		            document.getElementById("file1").multiple = false;
		        }
		    }
	
		    function RealImageName(ret) {
		        try {
		            pAttachListXml = ret;
		            var xmlAttach = createXmlDom();
		            xmlAttach = loadXMLString(ret);
		            var objAttachNodes = SelectNodes(xmlAttach, "LISTVIEWDATA/ROWS/ROW/CELL/VALUE");
		            document.getElementById("txtPhotoFile").value = getNodeText(objAttachNodes[0]);
		        }
		        catch (e) {
		            alert("RealImageName :: " + e.description);
		        }
		    }
	
		    function MakeAttachList() {
		        var xmlhttp = createXMLHttpRequest();
		        var xmldom = createXmlDom();
		        var str = "";
		        var i=0;
		        var pos = 0;
		        var filename = "";
		        var filepath = "";
	
		        xmlhttp.open("POST", "/ezCommunity/getItemAttachments.do?itemID=" + strItemID, false);
		        xmlhttp.send();
	
		        xmldom.async = false;
		        xmldom.preserveWhiteSpace = true;
		        xmldom = loadXMLString(xmlhttp.responseText);
		        xmlhttp = null;
					
		        var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
	
		        str += "<LISTVIEWDATA><HEADERS><HEADER><NAME><spring:message code = 'ezCommunity.t1135' /></NAME><WIDTH>100</WIDTH></HEADER><HEADER><NAME><spring:message code = 'ezCommunity.t1136' /></NAME><WIDTH>50</WIDTH></HEADER></HEADERS><ROWS>";
				
		        for(i=0;i<xmldomNodes.length;i++) {
		            str += "<ROW><CELL>";	
		            str += "<VALUE>" + MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "FileName")) + "</VALUE>";
		            str += "<DATA1>" + MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "FileName")) + "</DATA1>";
		            str += "<DATA2>" + MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "FilePath")) + "</DATA2>";
		            str += "<DATA3></DATA3>";
		            str += "<DATA4></DATA4>";
		            str += "<DATA5>Y</DATA5>";
		            str += "<DATA6>" + MakeXMLString(SelectSingleNodeValue(xmldomNodes[i], "FileSize2")) + "</DATA6>";
		            str += "</CELL>";
		            str += "<CELL><VALUE></VALUE>";
		            str += "</CELL></ROW>";
		        }
		        
		        str += "</ROWS></LISTVIEWDATA>";
		        
		        return str;
		    }

		    /* 2018-05-11 홍승비 - 포토게시물 수정 시 만료일 로직 변경 */
		    function GetEndDate() {
		        var pEndDateTime;
		        
		        if (ExpireDays == "-1") {
		            pEndDateTime = "9999-12-30 23:59:59";
		        } else {
		            pEndDateTime = endDateTime.substring(0, 10) + " 23:59:59";
		        }
		        
		        return pEndDateTime;
		    }
	
		    /* 2018-05-10 홍승비 - 게시물 저장 시 JSleep 함수 미사용 */
		    function SaveItem() {
		    	var strArray = document.getElementById('txtPhotoFile').value.split('.'); 
		    	var mimeType = strArray[strArray.length-1].toLowerCase();
		    	if (mimeType != "gif" && mimeType != "jpg" && mimeType != "png" && mimeType != "jpeg") {
		    		alert(strLang85);
		    		return;
		    	} 

		        if(MHTLoadComplete != "true") {
		            alert("<spring:message code = 'ezCommunity.t1138' />");
		            return;
		        }
		        
		        var strXML = "";
		        var newID = "";
		        var pStartDate = strStartDate;
		        var pEndDate = GetEndDate();

		        if (document.getElementById("txtTitle").value == "") {
		            alert("<spring:message code = 'ezCommunity.t1143' />");
		            txtTitle.focus();	            
		            return;				
		        }
							
		        if (pAttachListXml == "" || document.getElementById("txtPhotoFile").value == "") {
		            alert("<spring:message code = 'ezCommunity.t1199' />");            
		            return;	
		        }
		        
		        if (typeof (pAttachListXml) != "string") {
		        	var xmldomNodes = SelectNodes(pAttachListXml,"LISTVIEWDATA/ROWS/ROW");
            		
    		        for (var i=xmldomNodes.length; i>0; i--) {
    		            newID += "{" + GetGUID().toUpperCase() + "}";
    		        }
		        }
		        
		        var xmlDom = createXmlDom();
		        var xmlhttp = createXMLHttpRequest();
							
		        var objNode, objSubNode, objDataNode;
		        objNode = createNodeInsert(xmlDom, objNode, "NODES");
		        objSubNode = createNodeAndAppandNode(xmlDom, objNode,objSubNode, "NODE");
		        
		        if (pMode != "modify") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMID", newID);
		        } else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMID", strItemID);
		        }
		        
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "BOARDID", pBoardID);	        
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERID", SSUserID);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME", SSUserName);
	 	        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "WRITERNAME2", SSUserName2);
	            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTID", SSDeptID);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME", SSDeptName);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DEPTNAME2", SSDeptName2);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYID", SSCompanyID);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME", SSCompanyName);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "COMPANYNAME2", SSCompanyName2);		        
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "IMPORTANCE", "0");
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "TITLE", MakeXMLString(document.getElementById("txtTitle").value));
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "STARTDATE", pStartDate);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ENDDATE", pEndDate);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ABSTRACT",  MakeXMLString(""));
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ATTACHMENTS", MakeXMLString(AttachFileList_Photo()));
	
		        if (pMode == "new") {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", newID);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", "");
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", "1");
		        } else {
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "UPPERITEMIDTREE", strUpperItemIDTree);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "PARENTWRITEDATE", strParentWriteDate);
		            createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "ITEMLEVEL", strItemLevel);
		        }
		        
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "FILEPATH", pUploadFilePath);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE1", "");
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE2", "");
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE3", strUserRank);
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE32", strUserRank2);
           	    createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE4", MakeXMLString(GetFileName()));
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "EXTENSIONATTRIBUTE5", MakeXMLString(GetSmallUrl()));
		        
			  	var strBody = message.GetEditorContent();
			    
		       	if (trim_Cross(strBody) != "") {
			   		strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + EmbedContentIntoXML(strBody) + "</BODY>" + "</HTML>");
			   	} else {
			    	strBody = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + EmbedContentIntoXML(strBody) + "</BODY>" + "</HTML>");
			  	}
		        
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "CONTENT", strBody);	
		        createNodeAndAppandNodeText(xmlDom, objSubNode, objDataNode, "DOCPASSWORD","");	
												
		        xmlhttp.open("POST", "/ezCommunity/saveItemPhoto.do?mode="+ pMode , false);
		        xmlhttp.send(xmlDom);
							
		        if (xmlhttp.responseText == "OK") {
		            xmlhttp = null;
		            xmlDom = null;

	                alert("<spring:message code = 'ezCommunity.t282' />");
	                document.getElementById("menu").style.display = "none";
		            
		            window.close();		
		        } else {
		            alert("<spring:message code = 'ezCommunity.t283' />");
		        }
				window.opener.location.reload(true);
		        
		        xmlhttp = null;
		        xmlDom = null;
		    }

		    function ReplaceText( orgStr, findStr, replaceStr ) {
		        var re = new RegExp( findStr, "gi" );	        
		        return ( orgStr.replace( re, replaceStr ) );
		    }
	
		    function MakeXMLString(str) {
		        str = ReplaceText(str, "&", "&amp;");
		        str = ReplaceText(str, "<", "&lt;");
		        str = ReplaceText(str, ">", "&gt;");		        
		        return str;
		    }
		    
		    function Title_onkeyDown(e) {
		        if (window.event) {
		            if (e.keyCode != 9) {
		                return;
		            }
		        } else {
		            if (e.which != 9) {
		                return;
		            }
		        }
		    }
						
		    function ConvMakeXMLString(str) {
		        str = ReplaceText(str, "&amp;", "&");
		        str = ReplaceText(str, "&lt;", "<");
		        str = ReplaceText(str, "&gt;", ">");
		        str = ReplaceText(str, "&quot;", "\"");
		        return str;
		    }
		    
		    function Editor_Complete() {	    	
		        if (flag == false) {
		            flag = true;

		            if (pMode == "new") {
		                document.getElementById("txtTitle").focus();
		                message.SetEditorContent("");
		            } else {
		            	var fullPath = strContentLocation;
		             	message.SetEditorContentURL(fullPath);  
		            }
		            
		            MHTLoadComplete = "true";
		        }
		    }
	
		    function returnvalue(strXML) {
		        var xml = loadXMLString(strXML);
		        var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
		        
		        for (i = 0; i < nodes.length; i++) {
		            if (SelectSingleNodeValue(nodes[i], "RESULTUPLOADA") == "true") {
		                if (SelectSingleNodeValue(nodes[i], "FILESIZE") == 0) {
		                    alert(strLang6);                    
		                    return;
		                }
		                
		                if (document.getElementById('mode').value == "PHOTO") {
		                    document.getElementById('txtPhotoFile').value = SelectSingleNodeValue(nodes[i], "PFILENAME");
		                }
		            } else if (SelectSingleNodeValue(nodes[i], "RESULTUPLOADA") == "overflow") {
		                alert(strLang8 + AttachLimit + "MB" + strLang9);		                
		                return;
		            } else {
		                alert(filename + " <spring:message code = 'ezCommunity.lhj08' />" + "\n\n" + result);
		            }
		        }
		        
		        AttachFileInfo(strXML);
		    }
		    
		    function GetSmallUrl() {
		        var xmldom_attachlist = createXMLHttpRequest();
		        var strRet = "";
		        var filepath = "";
		        
				xmldom_attachlist = pAttachListXml;

		        if(xmldom_attachlist == false) {
		            xmldom_attachlist = null;		            
		            return "";
		        }
		        
		        var xmldomNodes = GetElementsByTagName(xmldom_attachlist,"DATA2");
		        
		        for(i=0; i<xmldomNodes.length; i++) {
		            filepath = getNodeText(xmldomNodes[i]);
		            
		            if(filepath.indexOf(pBoardID) != -1) {
		                var idx = filepath.lastIndexOf("/");
		                
		                if(idx != -1) {
		                    strRet +=  filepath.substr(0, idx+1) + "s_" + filepath.substr(idx+1) +  ";";
		                }
		            } else {
		                strRet += "tempUploadFile/s_" + getNodeText(xmldomNodes[i]) +  ";";
		            }
		        }
							
		        xmldom_attachlist = null;
		        return strRet;
		    }
		    
		    function GetFileName() {
		        var strRet = "";
		        
		        if (typeof (pAttachListXml) == "string") {
		       		pAttachListXml = pAttachListXml;
		        }
		        
		        if (getXmlString(pAttachListXml) == "") {
		            return "";
		        }
		        // 2018-02-14 천성준
		        if (pMode != "modify"){
			        var xmldomNodes = GetElementsByTagName(pAttachListXml, "DATA1");
		            strRet += getNodeText(xmldomNodes.item(0));
			        return strRet;
		        } else {
		        	strRet = document.getElementById("txtPhotoFile").value;
		        	return strRet;
		        }
		    }
		</script>
		
	</head>
	<body class="popup" style="height:100%">
		<table class="layout">
	 		<tr>
	    		<td style="height:20px">
	    			<div id="menu">
		        		<ul>
		          			<li><span  onClick="SaveItem();"><spring:message code = 'ezCommunity.t155' /></span></li>
		        		</ul>
	      			</div>
	      			<div id="close">
	        			<ul>
	          				<li><span  onClick="window.close();"></span></li>
	        			</ul>
	      			</div>
	      			
	      			<script type="text/javascript">
						selToggleList(document.getElementById("menu"), "ul", "li", "0");
					</script>
				</td>
	  		</tr>
	  		<tr>
	    		<td style="height:20px;">
	    			<table class="content">
						<tr>
	          				<th><spring:message code = 'ezCommunity.t1168' /></th>
	          				<td colspan="2" id="tdBoardName"><c:out value = '${boardInfo.boardName}' /></td>
	        			</tr>
				        <tr>
          					<th><spring:message code = 'ezCommunity.t124' /></th>
          					<td colspan ="2"><INPUT type="text" id="txtTitle" style="WIDTH:100%;word-wrap:break-word;word-break:break-all;" value="" maxlength=100 onKeyDown="Title_onkeyDown(event)"></td>
				        </tr>
				        <tr>
            				<th><spring:message code = 'ezCommunity.t1218' /></th>
			                <td class="pos1"><INPUT type="text" id="txtPhotoFile" style="WIDTH:100%" readonly="readonly" ></td>
							<td class="pos2"><a class="imgbtn imgbck"><span id="btn_AttachAdd" onClick="return btn_PhotoAttachAdd_onclick()" ><spring:message code = 'ezCommunity.t1177' /></span></a></td>
      					</tr>
      				</table>
      			</td>
			</tr>
			<tr>
    			<td style="height:100%" id="EdtorSize">
	    			<iframe id="message" class="viewbox"  name="message" src="/ezEditor/selectEditor.do" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto; margin-top:-1px"></iframe>
    			</td>
  			</tr>
		</table>
		
		<div id="txtAttachList"></div>
		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/ezCommunity/upload.do">
			<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="display:none" />
			<input type="hidden" name="boardID" id="boardID" />
			<input type="hidden" name="maxSize" id="maxSize" />
			<input type="hidden" name="mode" id="mode" />
			<input type="hidden" name="cnt" id="cnt" />
		</form>
		
		<script type="text/javascript">
			document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 160 + "PX";
		</script>
	</body>
</html>
