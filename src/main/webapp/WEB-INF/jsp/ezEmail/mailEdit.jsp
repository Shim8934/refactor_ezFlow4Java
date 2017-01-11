<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%;">
	<head>
	    <title><spring:message code='ezEmail.t660' /></title>
	    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/string_component.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/encode_component.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/newMail_Cross.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/AttachMain_CK.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/AttachItem_CK.js"></script>
        <c:if test="${isCrossBrowser != true}">
        <script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
        </c:if>  
		<script>
			var g_szAuthor = "";
			var g_szExchange = "exchange";
			var g_cmd = "${cmd}";
		    var Org_cmd = "${cmd}";
			var g_servername = "${serverName}";
			var g_myemail = "${userInfo.mail}";
			var g_szUserID = "${userInfo.cn}";
			var g_companyID = "${userInfo.physicalDeliveryOfficeName}";
			var tid = "${tenantId}";
			var g_senderinfo = "${senderInfo}";
			var g_eImportance = "${importance}";                                      
			var g_ePostType = "${postType}";                                          
			var g_url = "${url}";
			var g_unread = "${unread}";
			var m_rgParams4PostOption = new Array();
			var g_myname = "${userInfo.displayName}";
			var g_bDirty = false;
			var m_addrBook = null;
			var g_bSended = false;
			var objMHT;
			var g_SendFrom = "${sendFrom}";
			var g_charset = "utf-8";
			var g_encoding = "BASE64";
			var g_font = "<spring:message code='ezEmail.t409' />";
			var g_showdisplay = "${showDisplay}";
			var g_simplemimeencoding = "7bit";
			var g_simplemime = "";
			var g_xmldoc = createXMLHttpRequest();
			var useMultiLangMail = "${useMultiLangMail}";
			var g_isFormat = false;
			var g_DisplayNamePrintable = "${displayNamePrintable}";
			var g_showEnglishDisplay = "";
			var g_charsetCheck = "${charsetCheck}";
			var g_use_ApprovalG = "${userInfoApprovalG}";
			var g_ReSendFlag = "${reSendFlag}";
			var BigSizeAttachMBSize = "${bigSizeMailAttachLimit}";
			var totBigSizeAttachMBSize = "${totBigSizeMailAttachLimit}";	
			var totSizeAttachMBSize = "${mailAttachLimit}";			
			var BigSizeAttachSize = BigSizeAttachMBSize * 1024 * 1024;
			var totBigSizeAttachSize = totBigSizeAttachMBSize * 1024 * 1024;
			var totSizeAttachSize = totSizeAttachMBSize * 1024 * 1024;
			var FBigSizeAttachSize = parseInt(BigSizeAttachSize);
			var FtotBigSizeAttachSize = parseInt(totBigSizeAttachSize);
			var FtotSizeAttachSize = parseInt(totSizeAttachSize);
			var BigSizeMailAttachDelDay = "${bigSizeMailAttachDelDate}";
			var charsetControlFlag = "${userLang}";
			var userTimezone = "${userTimeset}";
			var isPrimary = "${userPrimary}";
			var initFlag = false;
		    var gg_cmd = "${cmdOwn}";
		    var gg_url = "${urlOwn}";
		    var g_newid = "${newwindowid}";
		    var FileUploadtype = "${fileUploadType}";
		    var iseachMail = "false";
		    var individualmailuser = "${individualMailUser}";
		    var pSecurity = "${pSecurity}";
		    var InnerDomain = "${mailInnerDomain}";
		    var inMailColor = "${inMailColor}";
		    var outMailColor = "${outMailColor}";
		    var docHref = "${docHref}";
		    var pTime= "${pReservedSaveTime}";
		    var isReserve = "YES";
		    var pCDOMessageId = "${pCDOMessageID}";
		    var pUse_Editor = "${useEditor}";
		    var GroupplusImg ="/images/ImgIcon/groupplus.gif";
		    var GroupminImg ="/images/ImgIcon/groupmin.gif";
		    var bigtrue = 0;
		    var isClosedSave = false;
		    var filedate = "${stateName}";
		    var folderDate = "${folderDate}";
		    var _pBigAttachDownloadDay = "${pBigAttachDownloadDay}";
		    var _pBigAttachDownloadPeriod = "${pBigAttachDownloadPeriod}";
			function window_onload()
			{
	            if (!CrossYN()) {
	                document.all.EzHTTPTrans.SetBigLang = "${userLang}" == "1" ? 1 : 0;
	                EzHTTPTrans.UseDbCl = true;
	                
	                var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
	                ezUtil.UseUTF8 = true;              
	            }
			    
				if (useMultiLangMail == "1") LoadLanguageConfig();
				
				if (g_unread == "1")
				{
					try {
						window.opener.document.Script.refreshUnreadCount()
					} catch (e) {}
				}
			    if (pSecurity == "Security")
			    {
			        pSecurity = "3";
			    }   
		        if(document.getElementById("xmpSubject").outerText != "")
		            document.getElementsByName("eSubject")[0].value = document.getElementById("xmpSubject").outerText; // 추가 
		
				eFrom.value = xmpFrom.innerHTML;
				document.getElementsByName("importantSelect")[0].selectedIndex = g_eImportance;
				m_rgParams4PostOption["important"] = g_eImportance;
				m_rgParams4PostOption["postType"] = g_ePostType;
				m_rgParams4PostOption["replySendTime"] = "0";
				m_rgParams4PostOption["replyReadTime"] = "1";
				m_rgParams4PostOption["delaySendDate"] = "${pReservedSaveTime}";
				m_rgParams4PostOption["showMsgCC"] = true;
				m_rgParams4PostOption["showMsgBCC"] = true;
				m_rgParams4PostOption["tagMsgCC"] = MsgCC_TR;
				m_rgParams4PostOption["tagMsgCCu"] = MsgCC_TRu;
				m_rgParams4PostOption["tagMsgBCC"] = MsgBCC_TR;
				m_rgParams4PostOption["tagMsgBCCu"] = MsgBCC_TRu;
				m_rgParams4PostOption["EachMail"] = iseachMail;
				m_rgParams4PostOption["SecurityMail"] = pSecurity;
		        if(xmpTo.innerHTML != "")
		        {
				    var splitAddr = getEmailAddressList(xmpTo.innerHTML);
				    
				    addReceiverFromList(0, splitAddr);
				}
				if(xmpCc.innerHTML != "")
				{
				    splitAddr = getEmailAddressList(xmpCc.innerHTML);
				    addReceiverFromList(1, splitAddr);
				}
				if(xmpBcc.innerHTML != "")
				{
				    splitAddr = getEmailAddressList(xmpBcc.innerHTML);
				    addReceiverFromList(2, splitAddr); 
				    document.getElementById("BccViewer").childNodes.item(0).src = GroupminImg;
				    document.getElementById("MsgBCC_TRu").style.display = "";
				    document.getElementById("MsgBCC_TR").style.display = "";
				    document.getElementById("BccViewer").setAttribute("status","on");
		        }
				Subject_ReApply();	
				window.onresize();
				g_bDirty = false;
				
				if (g_charsetCheck == "0")
				{
					if (confirm("<spring:message code='ezEmail.t665' />"))
					{
							location.href = location.href + "&attach=1";
					}
				}
				
		            
		        
			    if (document.getElementById("AttachXmlList").innerHTML != "") {
			        AddAttachFileInfoXmlParsing(document.getElementById("AttachXmlList").innerHTML);
			    }
		
		        
		        MailSignLoad();
		        Simple_Choice();
			}
			
		    window.onresize = function()
			{
	            if (document.getElementById("BccViewer").getAttribute("status") == "off") {
	                <c:if test="${isCrossBrowser == true}">
	                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 400 + "PX";
	                </c:if>
	                <c:if test="${isCrossBrowser != true}">
	                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 307 + "PX";
	                </c:if>             
	            }
	            else {
	                <c:if test="${isCrossBrowser == true}">
	                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 460 + "PX";
	                </c:if>
	                <c:if test="${isCrossBrowser != true}">
	                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 367 + "PX";
	                </c:if>             
	            }
			}
		    window.onbeforeunload = function()
			{
				var retVal = "";
				var LoopCnt = 0;
				JSleep(1);
				while(g_saveHttp != null)
				{
					JSleep(500);
					
					if(LoopCnt > 10)
					{
						break;
					}
					
					LoopCnt++;
				}
				
				delDrafts();
			}
			
			function JSleep(sTime)
			{
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("GET", "remote/userSleep.aspx?time=" + sTime + "&newid="+g_newid, false);
				xmlhttp.send();
				xmlhttp = null;
			}
		
			function window_close()
			{
				var retVal = "";
				var LoopCnt = 0;
				while(g_saveHttp != null)
				{
					JSleep(500);
					
					if(LoopCnt > 10)
					{
						break;
					}
					
					LoopCnt++;
				}
				delDrafts();
				window.close();
			}
			function delDrafts()
			{
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("GET", "/ezEmail/delDrafts.do?itemid=" + encodeURIComponent(g_url) + "&delid=" + filedate, false);
				xmlhttp.send();
				xmlhttp = null;
			}
			var printFrom = "";
			var printTo = "";
			var printCC = "";
			var printBCC = "";
			var printSubject = "";
			var printFile = "";
			var printContent = "";
			
			
			function LoadLanguageConfig()
			{
			    var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("GET", "/js/ezEmail/Controls/" + charsetControlFlag +"/language_config.xml", false);
				xmlhttp.send();
				g_xmldoc = loadXMLString(xmlhttp.responseText);
				xmlhttp = null;
		
				g_charset = getNodeText(g_xmldoc.getElementsByTagName("charset")[0]);
				g_encoding = getNodeText(g_xmldoc.getElementsByTagName("content-transfer-encoding")[0]);
				g_font = getNodeText(g_xmldoc.getElementsByTagName("font")[0]);
				//g_showdisplay = getNodeText(g_xmldoc.getElementsByTagName("show-displayname")[0]);
				g_simplemimeencoding = getNodeText(g_xmldoc.getElementsByTagName("simple-mime-content-transfer-encoding")[0]);
				g_simplemime = "0";
			}
		
			function LoadFormat_onClick()
			{
			    var strFileName = window.showModalDialog("mail_FormatList_cross.aspx", "", "dialogHeight:467px; dialogWidth:460px; status:no; help:no; edge:sunken");
			    if (typeof(strFileName) == "undefined") return;
				
		
			    var fullPath = document.location.protocol + "//" + document.location.hostname + "/Email_Formats/" + strFileName;
			    var xmpMailSign = "";
			    try{
			        xmpMailSign = message.EditorElementHTML("MailSign","2");
			    }catch(e){}
			    message.SetEditorContentURL_Format(fullPath);
			    message.SetEditorContent(message.GetHtmlValue()  + xmpMailSign);
			}
			var CurrentSing = "0";
			function MailSignSel()
			{
			    var tempDiv = document.createElement("DIV");
			    try{
			        tempDiv.innerHTML = message.GetHtmlValue();;
			        if(tempDiv.document.getElementById('MailSign')==null)
			            tempDiv.innerHTML =  tempDiv.innerHTML + "<DIV id='MailSign'></div>";
		
			        var tempSignDiv = document.createElement("DIV");
			        tempSignDiv.innerHTML = tempDiv.document.getElementById('MailSign').outerHTML;
			        var SingRayerContent="";
			        if(g_cmd == "NEW" || g_cmd == "EDIT")
			        {        
			            tempDiv.document.getElementById('MailSign').outerHTML = "";
			            if(CurrentSing == "0")
			            {
			                SingRayerContent = tempSignDiv.document.getElementById('MailSign').innerHTML;
			                tempSignDiv.document.getElementById('MailSign').innerHTML = "";
			            }
			            message.SetEditorContent(removeoniondiv(tempDiv).outerHTML+ SingRayerContent + 
		                                         tempSignDiv.document.getElementById('MailSign').outerHTML);
			        }
			        else
			        {
			            tempDiv.document.getElementById('MailSign').outerHTML = "";
			            var Orgcontentdiv = tempDiv.document.getElementById('ORGMAIL_CONTENT').outerHTML;
			            tempDiv.document.getElementById('ORGMAIL_CONTENT').outerHTML = "";
			            if(CurrentSing == "0")
			            {
			                SingRayerContent = tempSignDiv.document.getElementById('MailSign').innerHTML;
			                tempSignDiv.document.getElementById('MailSign').innerHTML = "";
			            }
		
			            message.SetEditorContent(removeoniondiv(tempDiv).outerHTML + SingRayerContent +  
		                                         tempSignDiv.document.getElementById('MailSign').outerHTML + Orgcontentdiv);
		            
			        }
			    }catch(e){}
			    tempDiv.innerHTML = message.GetHtmlValue();
			    switch(SelMailSign.value)
			    {
			        case "0" : tempDiv.document.getElementById('MailSign').innerHTML = "";CurrentSing = "0";
			            break;
			        case "1" : tempDiv.document.getElementById('MailSign').innerHTML = xmpMailSign1.innerHTML; CurrentSing = "1";
			            break;
			        case "2" : tempDiv.document.getElementById('MailSign').innerHTML = xmpMailSign2.innerHTML; CurrentSing = "2";
			            break;
			        case "3" : tempDiv.document.getElementById('MailSign').innerHTML = xmpMailSign3.innerHTML; CurrentSing = "3";
			            break;    
			    }
			    message.SetEditorContent(tempDiv.innerHTML);
			    tempDiv = null;
			}
			function removeoniondiv(currnode)
			{
			    var nextnode = null;
			    if (currnode.childNodes.length == 1 && currnode.firstChild.nodeName.toLowerCase() == 'div')
			    {
			        nextnode = currnode.firstChild;
			    }
			    if (nextnode == null)
			    {
			        return currnode;
			    }
			    
			    return removeoniondiv(nextnode);
			}
			function MailSignLoad()
			{	
			    SelMailSign.value = "${mailSignSel}";
			}
			function setEachMail()
			{
			    if(chkeachmail.checked)
			    {
			        iseachMail = "true";
			    }
			    else
			    {
			        iseachMail = "false";
			    }
			    
			    m_rgParams4PostOption["EachMail"] = iseachMail;
			}
			function new_Address()
		    {
			    var type = "config";
			    var receiverData = new Array();
			    receiverData["window"] = this;
			    window.showModalDialog("/ezEmail/mailNewReceiverChoose.do?defaultwin=&type=" + type, receiverData, "dialogHeight:655px;dialogWidth:970px; status:no; help:no; edge:sunken");
		        Simple_Choice();
		    }
		    function Simple_Choice()
		    {  
		        document.all("SelectToAddress").innerHTML = "";
		        document.all("SelectCcAddress").innerHTML = "";
		        document.all("SelectBCCAddress").innerHTML = "";
		        newoption1 = new Option(strLang199, strLang199);
		        CCnewoption1 = new Option(strLang199, strLang199);
		        BCCnewoption1 = new Option(strLang199, strLang199);
			    document.all("SelectToAddress").options[0] = newoption1;
			    document.all("SelectToAddress").options[0].selected =  true;
			    document.all("SelectCcAddress").options[0] = CCnewoption1;
			    document.all("SelectCcAddress").options[0].selected =  true;
			    document.all("SelectBCCAddress").options[0] = BCCnewoption1;
			    document.all("SelectBCCAddress").options[0].selected =  true;
			    Add_xmlhttp = createXMLHttpRequest();
		        Add_xmlhttp.open("Post","/ezEmail/mailGetAddress.do",true);
		        Add_xmlhttp.onreadystatechange = Simple_Choice_complete;
		        Add_xmlhttp.send("");     
		       			
		    }
		    function Simple_Choice_complete() {
		        try {
		        	var gubunCount = 1;
		        	
			        if (Add_xmlhttp == null || Add_xmlhttp.readyState != 4) {
						return;
			        }
			
					if (Add_xmlhttp.status >=200 && Add_xmlhttp.status < 300) {
						if (!CrossYN()) {
		                    var xmlDom = loadXMLString(Add_xmlhttp.responseText);
		                    var objNodes = xmlDom.selectNodes("NewDataSet/Table");
		                    for (var count = 0; count < objNodes.length; count++) {
		                        lastindex = document.all("SelectToAddress").length;
		                        newoption = new Option(objNodes(count).selectSingleNode("NAME").text, objNodes(count).selectSingleNode("NAME").text + ";" + objNodes(count).selectSingleNode("EMAIL").text);
		                        CCnewoption = new Option(objNodes(count).selectSingleNode("NAME").text, objNodes(count).selectSingleNode("NAME").text + ";" + objNodes(count).selectSingleNode("EMAIL").text);
		                        BCCnewoption = new Option(objNodes(count).selectSingleNode("NAME").text, objNodes(count).selectSingleNode("NAME").text + ";" + objNodes(count).selectSingleNode("EMAIL").text);
		                        document.getElementById("SelectToAddress").options[lastindex] = newoption;
		                        document.getElementById("SelectCcAddress").options[lastindex] = CCnewoption;
		                        document.getElementById("SelectBCCAddress").options[lastindex] = BCCnewoption;
		                    }
		                }
		                else if (CrossYN()) {
		                    var xmlDom = loadXMLString(Add_xmlhttp.responseText);
		                    var Nodeslength = xmlDom.childNodes.item(0).childElementCount;
		                    for (var count = 0; count < Nodeslength; count++) {
		                        //lastindex = document.all("SelectToAddress").length;
		                        lastindex = document.getElementById("SelectToAddress").childNodes.length;
		                        
	                            newoption = new Option(xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(0).textContent, xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(0).textContent + ";" + xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(1).textContent);
	                            CCnewoption = new Option(xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(0).textContent, xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(0).textContent + ";" + xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(1).textContent);
	                            BCCnewoption = new Option(xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(0).textContent, xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(0).textContent + ";" + xmlDom.childNodes.item(0).childNodes.item(count).childNodes.item(1).textContent);

	                            gubunCount = gubunCount + 2;
		                        document.getElementById("SelectToAddress").options[lastindex] = newoption;
		                        document.getElementById("SelectCcAddress").options[lastindex] = CCnewoption;
		                        document.getElementById("SelectBCCAddress").options[lastindex] = BCCnewoption;
		                    }
		                } 
					}
				} catch(e) {
					alert(e.message);
				}
				Add_xmlhttp = null;
		    }
			function simple_select(Type,obj)
		    {   
		        switch(Type)
			    {
				    case "TO":
					    SimpleEmailAddress(SelectToAddress.value, MsgToGot, 0);
					    break;
				    case "CC":
					    SimpleEmailAddress(SelectCcAddress.value, MsgCCGot, 1);
					    break;			
				    case "BCC":
					    SimpleEmailAddress(SelectBCCAddress.value, MsgBCCGot, 2);
					    break;
					default:
				        break;			
			    }
			    obj.item(0).selected=true;
		    }
		    function SimpleEmailAddress(formName, validDIV, iType)
		    {   
		        if(formName != "")
		        {
			        var mailArr = String(formName).split(";");
			        var mailName = ReplaceText(mailArr[0], " ", "");
			        var pemail = ReplaceText(mailArr[1], " ", "");
			        var newElem;
		
		
			        newElem = PrepareMailTag( iType, "email", mailName, pemail, "");
				    var IsInsert = CheckMailReceiver(newElem);
		    		
				    if(!IsInsert)
				    {
			            validDIV.appendChild( newElem );
			        }
			        formName = "";
			        g_bDirty = true;
			    }	
		    	
			    return true;
		    }
		    function MailBCCView(obj)
		    {
		        if(obj.getAttribute("status") == "off")
		        {
		            obj.childNodes.item(0).src = GroupminImg;
		            document.getElementById("MsgBCC_TRu").style.display = "";
		            document.getElementById("MsgBCC_TR").style.display = "";
		            obj.setAttribute("status","on");
		        }
		        else
		        {
		            obj.childNodes.item(0).src = GroupplusImg;
		            document.getElementById("MsgBCC_TRu").style.display = "none";
		            document.getElementById("MsgBCC_TR").style.display = "none";
		            obj.setAttribute("status","off");
		        }
	            if (document.getElementById("BccViewer").getAttribute("status") == "off") {
	                <c:if test="${isCrossBrowser == true}">
	                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 400 + "PX";
	                </c:if>
	                <c:if test="${isCrossBrowser != true}">
	                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 307 + "PX";
	                </c:if>             
	            }
	            else {
	                <c:if test="${isCrossBrowser == true}">
	                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 460 + "PX";
	                </c:if>
	                <c:if test="${isCrossBrowser != true}">
	                document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 367 + "PX";
	                </c:if>             
	            }		        
		    }
		    function ReserverdMail_Save()
		    {
		            var xmlhttp_1 = createXMLHttpRequest();
		            var strQuery = "<DATA><MESSAGEID>"+pCDOMessageId+"</MESSAGEID></DATA>";
		            xmlhttp_1.open("POST", "/ezEmail/reservedMailCheck.do", false);
		            xmlhttp_1.send(strQuery);
		            if(xmlhttp_1.responseText == "<DATA>MAIL-EXISTS</DATA>")
		                Send_onClick();
		            else
		                alert(strLang243);
		
		        try {
		            window.opener.window.close();
		        } catch (e) {
		    
		        }
		    }
		    function DownloadAttach(DownloadUrl) {
		        AttachDownFrame.location.href = DownloadUrl;
		    }
		    var DragDropAttachObjetLoading = false;
		    
		    function DragObjectComplet() {
		        var pAttachListXml = document.getElementById("AttachXmlList").innerHTML;
		        DragDropAttachObjetLoading = true;
		        var AttachRows = SelectNodes(pAttachListXml, "LISTVIEWDATA/ROWS/ROW")
		        if (AttachRows.length > 0)
		            AppendFileAttachInfo(pAttachListXml);
		    }
		    function DownloadAttach(DownloadUrl) {
		        AttachDownFrame.location.href = DownloadUrl;
		    }
		    function Editor_Complete(){
		        DocumentComplete();
		    }
		    function DocumentComplete() {
		        if(initFlag == false)
		        {
		            pzFormProc_DocumentComplete();
		            initFlag = true;
		        }
		    }
		    function returnvalue(strXML) {
		        pAttachXml = loadXMLString(strXML);
		        var nodes = SelectNodes(pAttachXml, "ROOT/NODES/NODE");
		        for (i = 0; i < nodes.length; i++) {
		            if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
		                if (getNodeText(GetChildNodes(nodes[i])[3]) == 0)       //filesize
		                {
		                    alert(strLang89); return;
		                }
		            }
		            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
		                alert(strLang168 + AttachLimit + "MB" + strLang169);
		                return;
		            }
		            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "denied") {
		                alert(strLang323);
		            }
		            else {
		                alert(filename + strLang85 + "\n\n" + result);
		            }
		        }
		        AttachFileInfo(strXML);
		    }
		
		    function FileUpdateAfter(strXML) {
		        tempXML = strXML;
		        pAttachXml = loadXMLString(strXML);
		        var nodes = SelectNodes(pAttachXml, "ROOT/NODES/NODE");
		        var xmlDoc = createXmlDom();
		        var objNode;
		        var objRow;
		        var objRows;
		        var objRowRow;
		        objNode = createNodeInsert(xmlDoc, objNode, "DATA");
		        createNodeAndInsertText(xmlDoc, objNode, "CMD", "ADD");
		        createNodeAndInsertText(xmlDoc, objNode, "URL", g_url);
		        objRow = createNodeAndAppandNode(xmlDoc, objNode, objRow, "FILELIST");
		        for (var i = 0; i < nodes.length; i++) {
		            if (getNodeText(GetChildNodes(nodes[i])[1]) != "denied") {
		                objRows = createNodeAndAppandNode(xmlDoc, objRow, objRows, "FILE");
		                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "NAME", getNodeText(GetChildNodes(nodes[i])[2]));
		                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "PATH", getNodeText(GetChildNodes(nodes[i])[4]));
		                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "BIG", getNodeText(GetChildNodes(nodes[i])[5]));
		                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "SIZE", getNodeText(GetChildNodes(nodes[i])[3]));
		                createNodeAndAppandNodeText(xmlDoc, objRows, objRowRow, "ITEMID", "Y");
		            }
		        }
		        xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezEmail/mailInterAttachCK.do", false);
		        xmlhttp.send(xmlDoc);
		        var aitem;
		        var xmlReturnValue = createXmlDom();
		        var objNode;
		        var objRow;
		        var objRows;
		        objNode = createNodeInsert(xmlReturnValue, objNode, "DATA");
		        if (xmlhttp.status == "200") {
		        	if (xmlhttp.responseText.indexOf("NO APPEND failed.") > -1) {
		        		alert(strLang241);
		        	}
		        	else {
			            xmlDoc = loadXMLString(xmlhttp.responseText);
			
			            if (CrossYN())
			                g_url = xmlDoc.getElementsByTagName("URL").item(0).textContent;
			            else
			                g_url = xmlDoc.getElementsByTagName("URL").item(0).text;
			            var filelist = SelectNodes(xmlDoc, "DATA/FILELIST/FILE");
			            for (var i = 0; i < filelist.length; i++) {
			                filename = SelectSingleNodeValue(filelist[i], "NAME");
			                path = SelectSingleNodeValue(filelist[i], "PATH");
			                big_yn = SelectSingleNodeValue(filelist[i], "BIG");
			                size = SelectSingleNodeValue(filelist[i], "SIZE");
			                attid = SelectSingleNodeValue(filelist[i], "ITEMID");
			                aitem = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/remote/mail_ReadAttach_Ews.aspx?mode=Attach&ID=" + escape(g_url) + "&ATTID=" + escape(attid);
			                if (big_yn == "Y") {
			                    bigtrue = bigtrue + 1;
			                    aitem = document.location.protocol + "//" + document.location.hostname + "/Common/DownloadAttach_Common.aspx?fileid=" + escape(path) + "&filedate=" + escape(attid.split('\\')[0]);
			                }
			                else {
			                    aitem = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezEmail/remote/mail_ReadAttach_Ews.aspx?mode=Attach&ID=" + escape(g_url) + "&ATTID=" + escape(attid);
			                }
			                objRows = createNodeAndAppandNode(xmlReturnValue, objNode, objRows, "ROW");
			                createNodeAndAppandNodeText(xmlReturnValue, objRows, objRow, "FILEPATH", path);
			                createNodeAndAppandNodeText(xmlReturnValue, objRows, objRow, "URL", aitem);
			                createNodeAndAppandNodeText(xmlReturnValue, objRows, objRow, "BIG", big_yn);
			                createNodeAndAppandNodeText(xmlReturnValue, objRows, objRow, "ITEMID", attid);
			            }
		        	}
		        }
		        else {
		            alert(xmlhttp.status + " : " + strLang241);
		        }
		        return xmlReturnValue;
		    }
		
		</script>
        <c:if test="${isCrossBrowser != true}">
        <script language="javascript" for="EzHTTPTrans" event="AttachAddFile(filename)">  
            attach_Add(filename);
        </script>
        <script LANGUAGE="javascript" FOR="EzHTTPTrans" EVENT="DbClListFile(mPath,mUserlist)">
            if(mPath != "")
                DownloadAttach(mPath);
        </script>
        </c:if>  
	</head>
	<body id="parentBody" class="popup" onload="javascript:window_onload()">
		<div id="main_body">
		  <table id="normalScreen" class="layout">
		    <tr>
		      <td style="height:20px;">
		      	<div id="menu">
		          <ul>
		            <li><span onClick="ReserverdMail_Save()"><spring:message code='ezEmail.t48' /></span></li>
		            <li style="display:none;"><span onClick="Save_onClick('tempsave')"><spring:message code='ezEmail.t48' /></span></li>
		            <li style="display:none;"><span onClick="Print_onClick()"><spring:message code='ezEmail.t546' /></span></li>
		            <li style="display:none;"><span onClick="LoadFormat_onClick()"><spring:message code='ezEmail.t824' /></span></li>
		            <li><span onClick="NameCertify_onClick()"><spring:message code='ezEmail.t331' /></span></li>
		              <li><span onClick="Option_onClick('M')" id="Span1"><spring:message code='ezEmail.t353' /></span></li>
		            <li class="bar" style="background:none; border:0;padding-left:5px;padding-right:0;padding-top:4px;cursor:default;">
		                 <img src="/images/pbar.gif" align="absmiddle"></li> 
					<li id="menuTable" class="sel" style="background:none; border:none;padding:4px 0 2px 0; margin:0; vertical-align:top;">
		              <select name="importantSelect" id="importantSelect" onChange="important_change()">
		                <option><spring:message code='ezEmail.t360' /></option>
		                <option selected="selected"><spring:message code='ezEmail.t361' /></option>
		                <option><spring:message code='ezEmail.t362' /></option>
		              </select>
		            </li>
		            <li style="display:none;" class="sel" style="background:none; border:none; padding:0 5px">${strSelectHtml}</li>&nbsp;&nbsp;
		            <li class="bar" style="background:none; border:0;padding-left:0;padding-right:0;cursor:default; display:none;"><img src="/images/pbar.gif" align="absmiddle"></li>                        
		            
		            <li style="display:none;">
		                <select id="SelMailSign" onchange="MailSignSel()">
		                    <option value='0' selected><spring:message code='ezEmail.t825' /></option>
		                    <option value='1'><spring:message code='ezEmail.t826' /></option>
		                    <option value='2'><spring:message code='ezEmail.t827' /></option>
		                    <option value='3'><spring:message code='ezEmail.t828' /></option>
		                </select>
		                </li>
					<li class="bar" style="background:none; border:0;padding-left:10px;padding-right:0;cursor:default;display:none;" nowrap="nowrap"><input  type="checkbox" style="display:inline;" id="chkeachmail" onclick="setEachMail()" /><spring:message code='ezEmail.t748' /></li>
		                
		          </ul>
		        </div>
		        <div id="close">
		          <ul>
		            <li><span onClick="window_close()"><spring:message code='ezEmail.t63' /></span></li>
		          </ul>
		        </div></td>
		    </tr>
		    <tr>
		      <td height="20">
		      	<table class="popuplist" style="width:100%">
		          <tr id="MsgTo_TR">
		            <th rowspan="2">
		            	<a href="#" class="imgbtn"><span onClick="SelectReceiver_onClick('To')"><spring:message code='ezEmail.t66' /></span></a>
		                <div style="font-weight:normal; "><INPUT id="toMe" onclick="MailToMe_Onclick();" value="" type="checkbox" name="toMe"/>
		                <label for="toMe" style="margin-left:-3px; cursor:pointer" ><spring:message code='ezEmail.t99000010' /></label></div>
		            </th>
		            <td style="width:76%"><input type="text" name="MsgTo" id="MsgTo" onKeyPress="return on_keydown()" onblur="onblurOnRecipientInputField(this.value)" TABINDEX="1" style="WIDTH:99%;ime-mode:active;"></td>
		            <td style="width:100px;BORDER-LEFT: #ffffff 1px solid;">
		                <select id="SelectToAddress" style="WIDTH:100px" onchange="simple_select('TO',this)">
		                </select>
		            </td>
		            <td style="width:200px;BORDER-LEFT: #ffffff 1px solid;" ><a class="imgbtn"><span onClick="new_Address()"><spring:message code='ezEmail.t832' /></span></a></td>
		          </tr>
		          <tr>
		            <td colspan="3"><div id="MsgToGot" style="OVERFLOW-Y: auto; HEIGHT: 17px" class="viewtxt"></div></td>
		          </tr>
		          <tr id="MsgCC_TR">
		            <th rowspan="2"  ><a href="#" class="imgbtn"><span onClick="SelectReceiver_onClick('CC')"><spring:message code='ezEmail.t594' /></span></a>
		                <div onclick="MailBCCView(this);" style="cursor:pointer;" status="off" id="BccViewer"><img src="/images/ImgIcon/groupplus.gif" align="absmiddle"/><span><spring:message code='ezEmail.t562' /></span></div>
		            </th>
		            <td style="width:76%"><input type="text" name="MsgCC" id="MsgCC" onKeyPress="return on_keydown()" onblur="onblurOnRecipientInputField(this.value)" TABINDEX="2" style="WIDTH:99%"></td>
		            <td style="width:100px;BORDER-LEFT: #ffffff 1px solid;">
		                <select id="SelectCcAddress" style="WIDTH:100px" onchange="simple_select('CC',this)">
		                </select>
		            </td>
		            <td style="width:200px;BORDER-LEFT: #ffffff 1px solid;" ><a class="imgbtn"><span onClick="new_Address()"><spring:message code='ezEmail.t832' /></span></a></td>
		          </tr>
		          <tr id="MsgCC_TRu">
		            <td colspan="3"><div id="MsgCCGot" style="OVERFLOW-Y: auto; HEIGHT: 17px" class="viewtxt"></div></td>
		          </tr>
		          <tr id="MsgBCC_TR" style="display:none;">
		            <th rowspan="2" ><a href="#" class="imgbtn"><span onClick="SelectReceiver_onClick('BCC')"><spring:message code='ezEmail.t562' /></span></a></th>
		            <td style="width:76%"><input type="text" name="MsgBCC" id="MsgBCC"onKeyPress="return on_keydown()" onblur="onblurOnRecipientInputField(this.value)" TABINDEX="3" style="WIDTH:99%"></td>
		            <td style="width:100px;BORDER-LEFT: #ffffff 1px solid;">
		                <select id="SelectBCCAddress" style="WIDTH:100px" onchange="simple_select('BCC',this)">
		                </select>
		            </td>
		            <td style="width:200px;BORDER-LEFT: #ffffff 1px solid;" ><a class="imgbtn"><span onClick="new_Address()"><spring:message code='ezEmail.t832' /></span></a></td>
		          </tr>
		          <tr id="MsgBCC_TRu" style="display:none;">
		            <td colspan="3"><div id="MsgBCCGot" style="OVERFLOW-Y: auto; HEIGHT: 17px" class="viewtxt"></div></td>
		          </tr>
		          <tr>
		            <th style="text-align:center"><spring:message code='ezEmail.t98' /></th>
		            <td colspan="3"><input id="eSubject" name="eSubject" onKeyUp="Subject_ReApply()" type="text" value="${encodedSubject}" TABINDEX="4" style="WIDTH:99%"></td>
		          </tr>
		        </table>
		        <div id="messageBody" mbody="${body}" style="DISPLAY:none"></div>
		        <xmp id="xmpTo" style="DISPLAY:none">${to}</xmp>
		        <xmp id="xmpCc" style="DISPLAY:none">${cc}</xmp>
		        <xmp id="xmpBcc" style="DISPLAY:none">${bcc}</xmp>
		        <xmp id="xmpFrom" style="DISPLAY:none">${from}</xmp>
		        <xmp id="xmpSubject" style="DISPLAY:none">${subject}</xmp>
		        <xmp id="xmpMailSign1" style="DISPLAY:none"></xmp>
		        <xmp id="xmpMailSign2" style="DISPLAY:none"></xmp>
		        <xmp id="xmpMailSign3" style="DISPLAY:none"></xmp>
		      </td>
		    </tr>
		    <tr>
		      <td style="height:380px;" id="EdtorSize">
				  <table width="100%" height="100%"> 
			          <tr> 
			            <td style="height:100%;">
			            	<c:choose> 
								<c:when test="${useEditor == 'TAGFREE'}">
									<iframe id="message" frameborder="0" class="viewbox" src="TagFree_TFX_Editor.aspx" name="message" style="border:none; padding:0; height:100%; width:100%; overflow:auto;"></iframe>
								</c:when>
								<c:when test="${useEditor == 'DEXT'}">
									<iframe id="message" frameborder="0" class="viewbox" src="DEXT_Editor.aspx" name="message" style="border:none; padding:0; height:100%; width:100%; overflow:auto;"></iframe>
								</c:when>
								<c:otherwise>
									<iframe id="message" frameborder="0" class="viewbox" src="/ezEmail/mailCKEditor.do" name="message" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
								</c:otherwise>
							</c:choose>
			            </td> 
			          </tr> 
			          <!-- <asp:PlaceHolder ID="HolderDocSend" Runat="server" Visible="false"> 
			            <tr> 
			                <td height="150">
			                    <div id="docContentBorder" style="border:#B6B6B6 1px solid; BACKGROUND-COLOR: white; margin-top:5px;"> 
			                       <iframe id="docContent" style="height:150px; width:100%" frameborder="0" ></iframe> 
			                    </div>
			                </td> 
			            </tr> 
			          </asp:PlaceHolder>  -->
			      </table>
		      </td>
		    </tr>
		      <tr style="display:none;">
		        <td style="padding-top: 0px">
		            <table class="file">
		                <tr>
		                    <td>
		                       <div id="attachedfileDIV" style="display:none;"></div>
		                    </td>
		                </tr>
		            </table>
		        </td>
		        </tr>
                <c:if test="${isCrossBrowser == true}">          
		        <tr>
		            <td style="padding-top: 10px;height:20px;vertical-align:middle;">
		                <span style="color:#3a76c3;font-weight:bold;height:15px;display:inline-block;"><img src="/images/i_urgency.gif" />&nbsp;${pAttachWarning}</span>
		                <iframe id="dadiframe" name="dadiframe" style="width:100%;border:0px" frameborder="0" src="/ezEmail/dragAndDrop.do"></iframe>
		            </td>
		        </tr>
                </c:if>
                <c:if test="${isCrossBrowser != true}">
                <tr>
                    <td height="20" style="padding-top: 10px;">
                        <span style="color: #3a76c3; font-weight: bold; height: 15px; display: inline-block;">
                            <img src="/images/i_urgency.gif" align="absmiddle" />&nbsp;${pAttachWarning}</span>
                        <table class="file" id="attachTable">
                            <tr>
                                <th><spring:message code='ezEmail.t557' /></th>
                                <td class="pos1">                                
                                    <script type="text/javascript">EzHTTPTrans_ActiveX2("EzHTTPTrans","100%", "20");</script>                                
                                </td>
                                <td class="pos2">
                                    <a href="#" class="imgbtn"><span id="btn_AttachAdd" onclick="attach_Add()"><spring:message code='ezEmail.t677' /></span></a>
                                    <br>
                                    <a href="#" class="imgbtn"><span id="btn_bigAttachAdd" onclick="bigattach_Add()"><spring:message code='ezEmail.t663' /></span></a>
                                    <br>                                    
                                    <a href="#" class="imgbtn"><span id="btn_AttachDel" onclick="attach_Delete()"><spring:message code='ezEmail.t678' /></span></a></td>
                            </tr>
                        </table>
                    </td>
                </tr>            
                </c:if>                
		  </table>
		</div>
		<div id="sendScreen" style="display:none;">
		<div class="popup_noti">
			<div class="popup_noti_title" style="height:10px;"><span class="tl"> </span>  <span class="tr"> </span></div>
		 	<div class="popup_noti_content">
		       <div  style="padding:10px;">
		      <table>
		        <tr>
		          <td  class="mimg" style=" width:100px;"></td>
		          <td  class="ctxt" >
		          <div><spring:message code='ezEmail.t679' /></div>
		                    <div style="margin-top:3px;"><spring:message code='ezEmail.t680' /></div>
		                    <img src="/images/kr/cm/progress_img.gif" style="vertical-align:middle;margin-top:5px;"/>
		          </td>
		        </tr>
		 </table>
		 	</div>
		    </div>
		<div class="popup_noti_bottom">  	 
		<span class="bl"> </span> <span class="br"></span></div>
		</div>
		</div>
		
		<iframe id="iframeWin" style="DISPLAY:none" src="/uploadform.htm"></iframe>
		<input id="eFrom" type="hidden" name="eFrom" style="display:none;">
		<input type="hidden" name="eImportant" style="display:none;">
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		    <iframe name="ifrm" src="about:blank" style="display:none"></iframe>
		     <form method="post" id="form" name="form" enctype="multipart/form-data" action="../ezEmail/remote/mail_interuploadX_CK.aspx?timestamp=${stateName}" target="ifrm" style="display:none;" >
		        <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width:1px; height:1px;" multiple="true" />
		        <input type="hidden" name="maxsize" id="maxsize" />
		        <input type="hidden" name="cnt" id="cnt" />
		        <input type="hidden" name="newguid" id="newguid" />
		        <input type="hidden" name="newid" id="newid" />
		        <input type="hidden" name="bigmaxsize" id="bigmaxsize" />
		        <input type="hidden" name="changesize" id="changesize" />
		        <input type="hidden" name="txtName" id="txtName" />
		        <input type="hidden" name="endDay" id="endDay" />
		    </form>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.7);display:none;" id="mailPanel">&nbsp;</div>
		<span class="loading_layer" style="z-index:6000;position:absolute;top:400px;left:300px;display:none;" id="loadingLayer"><span class="right" style="display: inline-block;"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t679' /><spring:message code='ezEmail.t680' /></span></span>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
			<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>  
			<form id="Form1" name="form1" runat="server" style="display:none;"></form>
		</div>
        <c:if test="${isCrossBrowser == true}">       
        <script type="text/javascript">
            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 400 + "PX";
        </script>
        </c:if>
        <c:if test="${isCrossBrowser != true}">       
        <script type="text/javascript">
            document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 307 + "PX";
        </script>
        </c:if>                    
	</body>
	<xmp id="AttachXmlList" style="display:none;">${attachCK}</xmp>
</html>



