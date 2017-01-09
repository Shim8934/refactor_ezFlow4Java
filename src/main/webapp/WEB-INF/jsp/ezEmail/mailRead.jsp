<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>${title}</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<style> 
			P { MARGIN-BOTTOM: 0mm; MARGIN-TOP: 0mm } 
		</style>
		<script type="text/javascript" src="/js/ezEmail/js_cross/reademail.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/string_component.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>
		<script type="text/javascript">	
		    var g_paramURL = "${url}";
			var g_expath = "exchange";
			var g_servername = ""; 
			var g_userID = "${ userinfo.EmailID }";
			var g_loginID = "${ userinfo.UserID }";
			var g_author = ""; 
			var g_exchNBName = "${ userinfo.ExchNBName }";
			var g_userName = "${ userinfo.DisplayName }";
			var g_fromEmail = "${fromEmail}";
		    var g_userLang = "${ userinfo.lang }";
			var g_rejectWord = "";
			var g_date = "${_date}";
			var g_notiSSO = "${ _notiSSO }";
			var searchPage = "${ _searchPage }";
			var usedMoveDel = "0";
			var messageid = "${ _messageid }";
			var g_useremail = "${ userinfo.Email }";
			var g_MailSpamURL = "${ _MailSpamURL }";
			var g_itsmtitle = "${ _MailTitle }";
			var _ITSMAdmin = "${ _ITSMAdmin }";
			var ITSMEmail = "${ _ITSMEmail }";
			var ITSMName = "${ _ITSMName }";
			var sentItems = "${isSentItems}";
			var IsSecurityMail = "Normal";
			var ReadCountCheck ="${pReadFlag}";
		    var IsAttach = "${pIsAttach}";
		    var pUse_Editor = "${Use_Editor}";
		    var pisDelete = "${isDelete}";
		    var pContentClass = "${pContentClass}";
		    var pNoneActiveX = "${NoneActiveX}";
		    window.onresize = window_onresize;
			function window_onload()
			{
			    window_onresize();
				if (g_notiSSO == "1")
				{
		            if(navigator.appVersion.indexOf("MSIE 6")>-1) 
		            { 
		                self.resizeTo(800,600); 
		            } 
		            else if(navigator.appVersion.indexOf("MSIE 7")>-1) 
		            { 
		                normalScreen.style.width="850"; 
		                normalScreen.style.height="650"; 
		            } 
		
					HideMenu();
			    }
			    
			    document.getElementById("PcSave").style.display = "none";
			    
			    form1.iptFolderPath.value = "${folderPath}";
		        form1.iptURL.value = "${uid}";
		        form1.submit();
		        
		        if(_ITSMAdmin == "Y")
		        {
		             btnITSM.style.display = "";
		        }
		        if (sentItems.toUpperCase() == "TRUE")
		        {
		        	document.getElementById("HolderSent").style.display = "";
		            document.getElementById("HolderElse").style.display = "none";
		            SentBcc.style.display = "";
		        } else {
		        	document.getElementById("HolderSent").style.display = "none";
		            document.getElementById("HolderElse").style.display = "";
		        }
		        
		        
		        try{
		            if(ReadCountCheck=="N")
		            {
		                opener.refreshUnreadCount();
		            }
		        } 
			    catch (e) { }
		
			}
		    function btnPrint_onClick()
		    {
		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var conWidth = pwidth * 0.8;
		        if (conWidth > 890)
		            conWidth = 890;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		
		        window.open("/ezEmail/mailPrint.do?URL=" + encodeURIComponent(g_paramURL), "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1, scrollbars=1");
		    }
			function window_onresize()
		    {
		        if (g_notiSSO == "1")
		            return;
		        if (document.getElementById('message').style.width != document.documentElement.clientWidth - 20)
		            if (document.body.clientWidth - 20 > 0)
		                document.getElementById('message').style.width = document.documentElement.clientWidth - 20;
		
		        if("${pIsCCFg}"!="N")
		            document.getElementById("message").style.height = document.documentElement.clientHeight - 220 + "px";
		        else
			        document.getElementById("message").style.height = document.documentElement.clientHeight - 190 + "px";
			}	
			
			function HideMenu()
			{
				btnReply.style.display = "none";
				btnAllReply.style.display = "none";
				btnForward.style.display = "none";
				btnMove.style.display = "none";
				btnDelete.style.display = "none";
				btnEncode.style.display = "none";
				btnBoard.style.display = "none";				
				btnBookmark.style.display = "none";
				btnViewWeb.style.display = "none";
				btn_KMS.style.display = "none";
				btnInsertAddr.style.display = "none";
			}
			
			function ToKMS()
			{
			    var url = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezKMS/kasset/KAssetConvert_Cross.aspx?Mode=new&Flag=email&url=" + encodeURIComponent(g_paramURL);
			    var OpenWin = window.open(url, "mail_foldermanage_Cross", GetOpenWindowfeature(800, 780));
			    try { OpenWin.focus(); } catch (e) { }
			}
			
			function OnBtnClose()
			{
			    if (g_notiSSO == "1")
					window.location = "btn:action|close";
				else
					window.close();
			}	
			
			function window_onbeforeunload()
			{
			   if(searchPage == "1" && usedMoveDel == "1")
			        opener.callback();
			}
			
			function deliver()
			{
			    var url = document.location.protocol+"//" + document.location.hostname + "/myoffice/ezEmail/remote/delivershow.aspx?Mode=new&messageid="+ encodeURI(messageid) + "&mailsender="+ encodeURI(g_fromEmail);	
			    var feature = "status:no;dialogWidth:780px;dialogHeight:290px;help:no;scroll:no;edge:sunken";
			    feature = feature + GetShowModalPosition(780, 290);
			    window.showModalDialog(url, "", feature);
			
			}
			
			function ITSM_send()
			{
			    try 
		        {                 	 
		            window.open("/myoffice/ezPortal/SSO/SSO_Link.aspx?TYPE=ITSMAPPDOC&DOCTITLE=" + encodeURI(g_itsmtitle) + "&EMAIL=" + encodeURI(ITSMEmail) + "&NAME=" + encodeURI(ITSMName) + "&DEPT=", '', '');
		        } 
		        catch(e) {}
			}
			
			function SecurityFG()
		    {
		        var xmlDOM = new ActiveXObject("Microsoft.XMLDOM");
		        var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
		    			
			    var objRoot = xmlDOM.createNode(1,"DATA","");
			    xmlDOM.appendChild(objRoot);
		    	
			    var objNode = xmlDOM.createNode(1, "URL", "");
			    objNode.text = "${_url}";
			    objRoot.appendChild(objNode);
		    	
			    xmlHTTP.open("POST", "/myoffice/ezEmail/remote/GetSecurity.aspx", false);
			    xmlHTTP.send(xmlDOM.xml);
		    	
			    IsSecurityMail = xmlHTTP.responseText;
		    }
		    function ShowHiddenTo(obj)
		    {
		        if(MsgToGotHidden.style.display=="none")
		        {
		            MsgToGotHidden.style.display = "";
		            obj.src ="/images/cllps.gif";
		        }
		        else
		        {
		            MsgToGotHidden.style.display = "none";
		            obj.src ="/images/expnd.gif";
		        }
		    }
		    function ShowHiddenCc(obj)
		    {
		        if(MsgCCGotHidden.style.display=="none")
		        {
		            MsgCCGotHidden.style.display = "";
		            obj.src ="/images/cllps.gif";
		        }
		        else
		        {
		            MsgCCGotHidden.style.display = "none";    
		            obj.src ="/images/expnd.gif";
		        }
		    }
		    function mtg_onClick(mtgid) {
		        var requestType = "";
		        switch (mtgid) {
		            case "ACCEPT":
		                requestType = "<spring:message code='ezEmail.t901' />";
		                break;
		            case "DECLINE":
		                requestType = "<spring:message code='ezEmail.t902' />";
		                break;
		            case "TENT":
		                requestType = "<spring:message code='ezEmail.t903' />";
		                break;
		        }
		
		        var g_saveHttp = createXMLHttpRequest();
		        var xmlDoc = createXmlDom();
		        var rootNode;
		        createNodeInsert(xmlDoc, rootNode, "DATA");
		        createNodeAndInsertText(xmlDoc, rootNode, "ITEMID", g_paramURL);
		        createNodeAndInsertText(xmlDoc, rootNode, "REQUEST", mtgid);
		        g_saveHttp.open("POST", "/myoffice/ezEmail/remote/mail_response_meeting.aspx", false);
		        g_saveHttp.setRequestHeader("Content-Type", "text/xml");
		        g_saveHttp.send(xmlDoc);
		        if (g_saveHttp.status >= 200 && g_saveHttp.status < 300) {
		            if (g_saveHttp.responseText == "OK") {
		                alert(requestType + strLang320);
		                window.opener.MailListRefresh();
		                OnBtnClose();
		            }
		            else
		                alert(strLang321);
		        }
		        else
		            alert(strLang321);
		        g_saveHttp = null;
		    }
		
		    var writeboardselect_modal_dialogArguments = new Array();
		    function NewItem_onclick() {
		        if (CrossYN()) {
		            writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
		            var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(345, 660));
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var wWeight = "345";
		            var wHeight = "660";
		
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		
		            var left = (width - wWeight) / 2;
		            var top = (heigth - wHeight) / 2;
		            var ret = window.showModalDialog("/ezBoard/writeBoardSelectModal.do", "",
		                "DialogHeight:660px;DialogWidth:345px;status:no;help:no;edge:sunken,top=" + top + ",left = " + left);
		
		            if (typeof (ret) != "undefined") {
		
		                var pheight = window.screen.availHeight;
		                var pwidth = window.screen.availWidth;
		                var pTop = (pheight - 720) / 2;
		                var pLeft = (pwidth - 765) / 2;
		
		                pBoardID = ret[0];
		
		                if (pBoardID == "" || typeof (pBoardID) == "undefined") {
		                    return;
		                }
		
		                if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4") {
		                    alert(strLang337);
		                }
		                else {
		                    if (CrossYN() || pNoneActiveX == "YES") {
		                        window.open("/myoffice/ezBoardSTD/NewBoardItem_Cross.aspx?BoardID=" + pBoardID + "&url=" + encodeURIComponent(g_paramURL), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                    }
		                    else {
		                        if (p_Use_IE11Browser == "CK") {
		                            window.open("/myoffice/ezBoardSTD/NewBoardItem_IE.aspx?BoardID=" + pBoardID + "&url=" + encodeURIComponent(g_paramURL), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                        }
		                        else {
		                            window.open("/myoffice/ezBoardSTD/NewBoardItem.aspx?BoardID=" + pBoardID + "&url=" + encodeURIComponent(g_paramURL), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                        }
		                    }
		                }
		            }
		        }
		    }
		
		    function NewItem_onclick_Complete(ret) {
		        if (typeof (ret) != "undefined") {
		            pBoardID = ret[0];
		
		            if (pBoardID == "" || typeof (pBoardID) == "undefined") {
		                return;
		            }
		
		            var pheight = window.screen.availHeight;
		            var pwidth = window.screen.availWidth;
		            var pTop = (pheight - 720) / 2;
		            var pLeft = (pwidth - 765) / 2;
		
		            if (ret[2] == "2" || ret[2] == "3" || ret[2] == "4") {
		                alert(strLang337);
		            }
		            else {
		                if (CrossYN() || pNoneActiveX == "YES")
		                    window.open("/myoffice/ezBoardSTD/NewBoardItem_Cross.aspx?BoardID=" + pBoardID + "&url=" + encodeURIComponent(g_paramURL), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                else {
		                    if (pUse_Editor == "")
		                        window.open("/myoffice/ezBoardSTD/NewBoardItem.aspx?BoardID=" + pBoardID + "&url=" + encodeURIComponent(g_paramURL), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                    else
		                        window.open("/myoffice/ezBoardSTD/NewBoardItem_IE.aspx?BoardID=" + pBoardID + "&url=" + encodeURIComponent(g_paramURL), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                }
		
		            }
		        }
		    }
		
		    function SuccessBoard() {
		        // 게시 완료 후 페이지 리로드 방지
		    }
		    
		    function reloadReadContent(url) {
		    	g_paramURL = url;
		    	form1.iptFolderPath.value = url.split('/')[0];
		        form1.iptURL.value = url.split('/')[1];
		        form1.submit();
		        window.opener.MailListRefresh();
		        window.opener.reloadReadContent(url);
		    }
		</script>
	</head>

	<body id="parentBody" class="popup" onload="javascript:window_onload()"   style="overflow:hidden;"> 
		<form method="post">
		<table id="normalScreen" class="layout"> 
		    <tr> 
		        <td height="20">
		            <div id="menu">
		                <ul>
		                    <li><span id="btnReply" onClick="reply_onClick()"><spring:message code="ezEmail.t511" /></span></li>
		                    <li><span id="btnAllReply" onClick="allreply_onClick()"><spring:message code="ezEmail.t512" /></span></li>
		                    <li><span id="btnForward" onClick="pass_onClick()"><spring:message code="ezEmail.t513" /></span></li>
		                    <li><span id="btnPrint" onClick="btnPrint_onClick()"><spring:message code="ezEmail.t546" /></span></li>
		                    <li><span id="btnMove" onClick="move_onClick()"><spring:message code="ezEmail.t482" /></span></li>
		                    <li><span id="btnDelete" onClick="delete_mail()"><spring:message code="ezEmail.t95" /></span></li>
		                    <li id="PcSave"><span id="btnSave" onClick="download_mail()">PC <spring:message code="ezEmail.t48" /></span></li>
		                    <li><span id="btnBoard" onClick="NewItem_onclick()"><spring:message code="ezEmail.t548" /></span></li>
		                    <li id="HolderSent"><span id="btnReceiveList" onClick="receiveCheck_onClick()"><spring:message code="ezEmail.t516" />/<spring:message code="ezEmail.t549" /></span></li>
		                    <li><span id="btnBookmark" onClick="toggle_flag()"><spring:message code="ezEmail.t550" /></span></li>
		                    <li id="HolderElse"><span id="btnViewWeb" onClick="view_original()"><spring:message code="ezEmail.t551" /></span></li>          
							<c:if test="${useEzKMS == 'YES'}">
								<li><span ID='btn_KMS' onclick='ToKMS()'>KMS</span></li>
							</c:if>
							<!--  <li id="btnITSM" style="display:none" onClick="ITSM_send()"><span >ITSM 이관</span></li> -->
		                    <c:if test="${pnFlag=='Y'}">
			                    <li id="iprev"><span id="btnpre" onclick="get_mail('prev')" style="padding-top:0px;"><img src="/images/ImgIcon/prev.gif" alt="<spring:message code='ezEmail.t1000' />"  /></span></li>
			                    <li id="inext" ><span id="btnnext" onclick="get_mail('next')" style="padding-top:0px;"><img src="/images/ImgIcon/next.gif" alt="<spring:message code='ezEmail.t1001' />" /></span></li>
		                    </c:if>
		                </ul>
		            </div>
		            <div id="close"><ul><li><span onClick="OnBtnClose()"><spring:message code="ezEmail.t63" /></span></li></ul></div>	
		        </td> 
		    </tr>  
		    <tr> 
		        <td>
		            <table class="content">
		                <tr>
		                    <th><spring:message code="ezEmail.t161" /></th>
		                    <td class="pos1" style="vertical-align:middle;">
		                        <DIV id="MsgToPut" onMouseOver="this.style.color='#006BB6'" title="<spring:message code='ezEmail.t553' />${fromEmail}" style="CURSOR: pointer; padding-left: 5px; vertical-align: middle;" onMouseOut="this.style.color='#393939'">	
			                        <a onClick="show_senderprofile()">					
			                            <span id="LabelFromName">${fromStr}</span>
			                            <span id="LabelSenderInfo"></span>	
			                        </a>					
		                        </DIV>
		                    </td>
		                    <th>
		                    <c:if test="${isSentItems == true}">
		                    <spring:message code="ezEmail.t704" />
		                    </c:if>		                    
		                    <c:if test="${isSentItems != true}">
		                    <spring:message code="ezEmail.t657" />
		                    </c:if>
		                    </th>
		                    <td style="border-right-color:#ffffff;">
		                        <div id="ReceiveDate" style="OVERFLOW-Y: auto;padding-top:2px;padding-left:5px;padding-right:5px; width:150px;"> 
		                        <span id="LabelReceiveDate">${dateStr}</span> 
		                        </div>
		                    </td>
		                    <td nowrap class="pos2" id="btnInsertAddr"><a href="#" class="imgbtn"><span onClick="func_addaddr('N')" id="btn_addaddr"><spring:message code="ezEmail.t554" /></span></a>
		                    <a href="#" class="imgbtn"><span onClick="func_reject()" id="btn_reject"><spring:message code="ezEmail.t270" /></span></a></td>
		                </tr>
		                <tr>
		                    <th><spring:message code="ezEmail.t66" /></th>
		                    <td colspan="4" style="OVERFLOW-Y:auto;">
		                    <div id="MsgToGot" style="padding-left:5px;"> 
		                    <span id="LabelTo">${toStr}</span> 
		                    </div> 
		                    <div id="MsgToGotHidden" style="margin-bottom:5px;display:none;padding-left:8px;padding-left:5px;"> 
		                    <span id="LabelToHidden">${toHiddenStr}</span> 
		                    </div>
		                    </td>
		                </tr>
		        
					<c:if test="${pIsCCFg != 'N'}">
		                <tr>
		                <th><spring:message code="ezEmail.t555" /></th>
		                <td colspan="4" style="OVERFLOW-Y:auto;height:100%;">
		                <div id="MsgCCGot" style="padding-left:5px;"> 
		                <span id="LabelCC">${ccStr}</span> 
		                </div>
		              
		                <div id="MsgCCGotHidden" style="margin-bottom:5px;display:none;padding-left:5px;"> 
		                <span id="LabelCCHidden">${ccHiddenStr}</span> 
		                </div>
		                </td>
		                </tr>
					</c:if>
		
		                <tr id="SentBcc" style="display:none">
		                <th><spring:message code="ezEmail.t562" /></th>
		                <td colspan="4"><div id="MsgBCCGot" style="padding-left:5px;"> 
		                <span id="LabelBCC">${bccStr}</span>
		                </div></td>
		                </tr>
		       
		        
		                <tr>
		                <th><spring:message code="ezEmail.t556" /></th>
		                <td colspan="4"><div id="mailSubject" style="OVERFLOW-Y: auto;padding-left:5px;"> 
		                <span id="LabelSubject">${subject}</span>
		                </div></td>
		                </tr>
		            </table>
		        </td>
		    </tr>
		    <tr>
		        <td class="pad1">
		        <iframe  id="message" name="message" frameborder="0" style="width:100%;height:100%;BORDER:#b6b6b6 1px solid; background:#fff;" ></iframe>
		        </td>
		    </tr>
		</table>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
			if("${pIsCCFg}"!="N") {
				document.getElementById("message").style.height = document.documentElement.clientHeight - 220 + "px";
			} else {
		    	document.getElementById("message").style.height = document.documentElement.clientHeight - 190 + "px";
			}
		</script>
		</form>
		<form name="form1" action="mailReadContent.do" method="post" target="message" >
			<input  type="hidden" id="iptFolderPath"  name="iptFolderPath" value="">
		    <input  type="hidden" id="iptURL"  name="iptURL" value="">
		    <input  type="hidden" id="iSecurity"  name="iSecurity" value="">
		</form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
