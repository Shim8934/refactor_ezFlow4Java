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
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
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
		    var isSecureMail = "${isSecureMail}";
		    var useReSend = "${useReSend}";
		    var sentDateMsg = "${sentDateMsg}"; // 전달, 회신 시 보낸 시간
		    
		    window.onresize = window_onresize;
		    
			function window_onload()
			{
			    window_onresize();
				
				var g_szRootFolderName = g_paramURL.split('/');
			    
			    if (useReSend == "YES" && sentItems.toUpperCase() == "TRUE") {
		    		$('#liReSend').css('display', 'block');
		    	} 
			    
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
				
		        mailPrevSentDateChk();
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
			    var url = document.location.protocol+"//" + document.location.hostname + "/myoffice/ezEmail/remote/delivershow.aspx?Mode=new&messageid="+ encodeURIComponent(messageid) + "&mailsender="+ encodeURIComponent(g_fromEmail);	
			    var feature = "status:no;dialogWidth:780px;dialogHeight:290px;help:no;scroll:no;edge:sunken";
			    feature = feature + GetShowModalPosition(780, 290);
			    window.showModalDialog(url, "", feature);
			
			}
			
			function ITSM_send()
			{
			    try 
		        {                 	 
		            window.open("/myoffice/ezPortal/SSO/SSO_Link.aspx?TYPE=ITSMAPPDOC&DOCTITLE=" + encodeURIComponent(g_itsmtitle) + "&EMAIL=" + encodeURIComponent(ITSMEmail) + "&NAME=" + encodeURIComponent(ITSMName) + "&DEPT=", '', '');
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
		    	var currHeight = $(".content tbody tr:nth-child(2)").outerHeight();
		    	var heightForChange = "";
		        if(MsgToGotHidden.style.display=="none")
		        {
		        	MsgToGotHidden.style.display = "";
		            obj.src ="/images/cllps.gif";
		            heightForChange = $(".content tbody tr:nth-child(2)").outerHeight()-currHeight;
		            $("#message").outerHeight($("#message").outerHeight() - heightForChange );
		        }
		        else
		        {
		        	MsgToGotHidden.style.display = "none";
		            obj.src ="/images/expnd.gif";
		            heightForChange = $(".content tbody tr:nth-child(2)").outerHeight()-currHeight;
		            $("#message").outerHeight($("#message").outerHeight() - heightForChange );
		        }
		    }
		    function ShowHiddenCc(obj)
		    {
		    	var currHeight = $(".content tbody tr:nth-child(3)").outerHeight();
		    	var heightForChange = "";
		        if(MsgCCGotHidden.style.display=="none")
		        {
		            MsgCCGotHidden.style.display = "";
		            obj.src ="/images/cllps.gif";
		            heightForChange = $(".content tbody tr:nth-child(3)").outerHeight()-currHeight;
		            $("#message").outerHeight($("#message").outerHeight() - heightForChange );
		        }
		        else
		        {
		            MsgCCGotHidden.style.display = "none";    
		            obj.src ="/images/expnd.gif";
		            heightForChange = $(".content tbody tr:nth-child(3)").outerHeight()-currHeight;
		            $("#message").outerHeight($("#message").outerHeight() - heightForChange );
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
		    
			function GetOpenWindowfeatureNoScrollbar(popUpW, popUpH) {
			
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
				var feature = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=no";
				return feature;
			}
		    
            // 닷넷 게시판 선택 모듈을 호출하는 경우엔 Cross Origin(서로 도메인이 다름)으로 인해 opener를 통한 NewItem_onclick_Complete에
            // 직접적 접근이 허용되지 않아 window.postMessage와 Message Event Listener를 사용함
            <c:if test="${dotNetIntegration == 'YES'}">
            window.addEventListener("message", function(e) {
                var ret = new Array();

                // 사용자가 선택한 게시판의 ID가 리턴됨
                ret = e.data;
                
                NewItem_onclick_Complete(ret);
            });
            </c:if>
		    
		    // 메일읽기창에서 '게시' 버튼을 누를 때 호출됨		    
		    function NewItem_onclick() {
		        if (CrossYN()) {
		            writeboardselect_modal_dialogArguments[1] = NewItem_onclick_Complete;
		            		            		           
		            <c:if test="${dotNetIntegration == 'YES'}">
		            // IE가 window.postMessage를 Cross Origin에서 지원하지 않는 관계로 동일 사이트의 윈도우를
		            // 띄운 후 그 안에서 iframe으로 처리해야 한다.
		            var OpenWin = window.open("/ezBoard/writeBoardSelectModalDotNet.do", "WriteBoardSelect_Modal", GetOpenWindowfeatureNoScrollbar(458, 660));		            
		            </c:if>
		            
		            <c:if test="${dotNetIntegration != 'YES'}">
		            // 자체 게시판 선택 모듈을 호출하는 경우
		            var OpenWin = window.open("/ezBoard/writeBoardSelectModal.do", "WriteBoardSelect_Modal", GetOpenWindowfeature(458, 660));
		            </c:if>
		            
		            try { OpenWin.focus(); } catch (e) { }
		        }
		        else {
		            var wWeight = "458";
		            var wHeight = "660";
		
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		
		            var left = (width - wWeight) / 2;
		            var top = (heigth - wHeight) / 2;
		            var ret = window.showModalDialog("/ezBoard/writeBoardSelectModal.do", "",
		                "DialogHeight:660px;DialogWidth:458px;status:no;help:no;edge:sunken,top=" + top + ",left = " + left);
		
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
		                        window.open("/ezBoard/boardNewItem.do?mode=new1&boardID=" + pBoardID + "&url=" + encodeURIComponent(g_paramURL), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                    }
		                    else {
		                    	window.open("/ezBoard/boardNewItem.do?mode=new1&boardID=" + pBoardID + "&url=" + encodeURIComponent(g_paramURL), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
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
		                    <c:if test="${dotNetIntegration == 'YES'}">
		                    window.open("${dotNetUrl}/myoffice/ezBoardSTD/NewBoardItem_Cross.aspx?BoardID=" + pBoardID + "&url=" + encodeURIComponent(g_paramURL), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                    </c:if>
				            <c:if test="${dotNetIntegration != 'YES'}">		                    
		                    window.open("/ezBoard/boardNewItem.do?mode=new1&boardID=" + pBoardID + "&url=" + encodeURIComponent(g_paramURL), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
		                    </c:if>
		                else {
	                        window.open("/ezBoard/boardNewItem.do?mode=new1&boardID=" + pBoardID + "&url=" + encodeURIComponent(g_paramURL), "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
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
		    
		    function secureInfo_onClick() {
		    	DivPopUpShow(550, 500, "/ezEmail/secureMailInfo.do?url=" + encodeURIComponent(g_paramURL));
		    }
		    
		    function reSend_onClick() {
		        var pURI = "/ezEmail/mailWrite.do?cmd=RESEND&URL=" + encodeURIComponent(g_paramURL);
		        var newwin = GetOpenWindow(pURI, "", 890, 840, "yes");
		        newwin.focus();
		    }
		    
			function addRelatedCabinet() {
				//* moon 2018.07.26
				window.open("/ezCabinet/cabinetAddRelated.do?module=email", "addRelated", getOpenWindowfeature(480, 370));
			}
			
			function getOpenWindowfeature(popUpW, popUpH) {
				var heigth   = window.screen.availHeight;
				var width    = window.screen.availWidth;
				var left     = 0;
				var top      = 0;
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				left         = pleftpos / 2;
				top          = heigth / 2;
				var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=yes";
				return feature;
			}
			
		    function mailPrevSentDateChk() {
		    	if (sentDateMsg != "") { // 전달 및 회신시 보낸시각
		    		var sentDateHeight = $(".sentDateStr").innerHeight();
		    		sentDateHeight = (Math.ceil(sentDateHeight/10) * 10);
		    		
		    		var messageH = $("#message").height();
		    		$("#message").height(messageH - sentDateHeight);
		    	}
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
		                    <li id="liReSend" style="display: none;"><span id="btnReSend" onClick="reSend_onClick()"><spring:message code="ezEmail.kyj19" /></span></li>
		                    <li><span id="btnPrint" onClick="btnPrint_onClick()"><spring:message code="ezEmail.t546" /></span></li>
		                    <li><span id="btnMove" onClick="move_onClick()"><spring:message code="ezEmail.t482" /></span></li>
		                    <li><span id="btnDelete" onClick="delete_mail()"><spring:message code="ezEmail.t95" /></span></li>
		                    <li id="PcSave"><span id="btnSave" onClick="download_mail()">PC <spring:message code="ezEmail.t48" /></span></li>
		                    <li id="BoardItem"><span id="btnBoard" onClick="NewItem_onclick()"><spring:message code="ezEmail.t548" /></span></li>
		                    <li id="HolderSent"><span id="btnReceiveList" onClick="receiveCheck_onClick()"><spring:message code="ezEmail.t516" />/<spring:message code="ezEmail.t549" /></span></li>
		                    <li><span id="btnBookmark" onClick="toggle_flag()"><spring:message code="ezEmail.t550" /></span></li>
		                    <li id="HolderElse"><span id="btnViewWeb" onClick="view_original()"><spring:message code="ezEmail.t551" /></span></li>          
		                    <c:if test="${useCabinet == 'YES'}">
		                    	<li><span id="addCabinet" onclick="addRelatedCabinet()"><spring:message code='ezCabinet.t01'/></span></li>
		                    </c:if>
		                    <c:if test="${isSecureMail == true}">
		                    	<li><span id="btnSecureInfo" onClick="secureInfo_onClick()"><spring:message code="ezEmail.lhm44" /></span></li>
		                    </c:if>
		                    <c:if test="${pnFlag=='Y'}">
			                    <li id="iprev"><span id="btnpre" onclick="get_mail('prev')" style="padding-top:0px;"><img src="/images/ImgIcon/prev.gif" alt="<spring:message code='ezEmail.t1000' />"  /></span></li>
			                    <li id="inext" ><span id="btnnext" onclick="get_mail('next')" style="padding-top:0px;"><img src="/images/ImgIcon/next.gif" alt="<spring:message code='ezEmail.t1001' />" /></span></li>
		                    </c:if>
		                </ul>
		            </div>
		            <div id="close"><ul><li><span onClick="OnBtnClose()"></span></li></ul></div>	
		        </td> 
		    </tr>  
		    <tr> 
		        <td>
		            <table class="content">
		                <tr>
		                    <th><spring:message code="ezEmail.t161" /></th>
		                    <td class="pos1" style="vertical-align:middle;">
		                        <DIV id="MsgToPut" onMouseOver="this.style.color='#006BB6'" title="${fromEmail}" style="CURSOR: pointer; padding-left: 5px; vertical-align: middle;" onMouseOut="this.style.color='#393939'">	
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
		                    <td style="border-right:0px;">
		                        <div id="ReceiveDate" style="OVERFLOW-Y: auto;padding-top:2px;padding-left:5px;padding-right:5px; width:150px;"> 
		                        <span id="LabelReceiveDate">${dateStr}</span> 
		                        </div>
		                    </td>
		                    <td nowrap class="pos2" id="btnInsertAddr">
		                    	<a href="#" style="margin-right:5px;"><span onClick="func_addaddr()" id="btn_addaddr"><img src="/images/email/icon_address_add.png" style="border:0px" /></span></a>
		                    	<a href="#" style="margin-right:5px;"><span onClick="func_reject()" id="btn_reject"><img src="/images/email/icon_mail_refusal.png" style="border:0px" /></span></a>
		                    </td>
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
		        <iframe  id="message" name="message" frameborder="0" style="width:100%;height:100%;BORDER:#ddd 1px solid; background:#fff;" ></iframe>
		        </td>
		    </tr>
		</table>
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			
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
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
