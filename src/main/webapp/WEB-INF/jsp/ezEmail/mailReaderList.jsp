<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezEmail.t566' /></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<style>
			@media print {
				#TabDiv{ display: none; }
				.imgbtn{ display: none; }
				.btnposition { display: none; }
				input[type=checkbox] {display: none;}
				#contentlist { height: auto !important; }
			}
			
		</style>
	    <script>
	        var _url = decodeURIComponent("<c:out value='${url}'/>");
	        var isReadDelete = "${isReadDelete}";
	        var shareId = "<c:out value='${shareId}'/>";
	        var docWidth = window.outerWidth;
	        var docHeight = window.outerHeight;
	        
	        document.onselectstart = function () { return false; };

	        /* function ReSend(pEmail) { 
	            var pEmail = pEmail.getAttribute("EMAIL");
	            
	            if (pEmail.indexOf("(") > -1) {
	                alert("<spring:message code='ezEmail.t567' />");
	                return;
	            }
	            try {
	                window.opener.ReSend(_url, pEmail);
	            } catch (e) {
	                console.log(e);
	            }
	        } */
	     	// 2024.05.24 한슬기 : 수신자이름 추가 및 파라미터 이름 변경 
	        function ReSend(pSendData) {
	            var pEmail = pSendData.getAttribute("EMAIL");
	            var pReaderName = pSendData.getAttribute("READERNAME");
	            
	            if (pEmail.indexOf("(") > -1) {
	                alert("<spring:message code='ezEmail.t567' />");
	                return;
	            }
	            try {
	            	// 수신자 이름 추가
	                window.opener.ReSend(_url, pEmail, pReaderName);
	            } catch (e) {
	            }
	        }

	        var g_xmlHttp;
	        function MailCancel(pGubun) {
	            var xmlDom = createXmlDom();
	            g_xmlHttp = createXMLHttpRequest();
	
	            var objNode;
	            createNodeInsert(xmlDom, objNode, "DATA");
	            createNodeAndInsertText(xmlDom, objNode, "URL", _url);
	            if (pGubun == "EACH") {
	                var pMailAddress = "";
	                for (var RowCnt = 0; RowCnt < MailList.childNodes.length; RowCnt++) {
	                    if (MailList.childNodes.item(RowCnt).childNodes.item(0).childNodes.length > 0) {
	                        if (MailList.childNodes.item(RowCnt).childNodes.item(0).childNodes.item(0).checked) {
	                            if (pMailAddress == "")
	                                pMailAddress = MailList.childNodes.item(RowCnt).getAttribute("_mailaddress");
	                            else
	                                pMailAddress += "|!|" + MailList.childNodes.item(RowCnt).getAttribute("_mailaddress");
	                        }
	                    }
	                }
	                if (pMailAddress != "")
	                    createNodeAndInsertText(xmlDom, objNode, "EMAILADDRESS", encodeURIComponent(pMailAddress));
	                else {
	                    alert(strLangLHM11);
	                    return;
	                }
	            }
	            
	            var requestUrl = "/ezEmail/mailCancelSend.do" + "?gubun=" + encodeURIComponent(pGubun);
	            
	        	if (typeof(shareId) != "undefined" && shareId != "") {
	        		requestUrl += "&shareId=" + encodeURIComponent(shareId);
	        	}
	            
	            g_xmlHttp.open("POST", requestUrl, true);
				showDim();
	            g_xmlHttp.onreadystatechange = mail_cancelsend_after;
	            g_xmlHttp.send(xmlDom);
	        }

	        function mail_cancelsend_after() {
	            if (g_xmlHttp != null && g_xmlHttp.readyState == 4) {
	                var szStatus = g_xmlHttp.status;
	                switch (szStatus) {
	                    case 200:
	                        if (g_xmlHttp.responseText == "OK") {
	                            alert(strLang146);
	                            Get_MailReceiverList();
	                        }
	                        else {
	                            alert(g_xmlHttp.responseText)
	                        }
	                        break;
	                }
	            }
				hideDim();
	        }

	        window.onload = function () {
	            document.getElementById("1tab1").setAttribute("class", "tabon");
	            Tab1_SelectID = "1tab1";
	            Get_MailReceiverList();
	        }

	        function Refresh() {
	            Get_MailReceiverList();
	        }

	        var xmlhttp_MailReceiverList;
	        var MailReceiverListXML;

	        function Get_MailReceiverList() {
				showDim();
	            document.getElementById("HeaderAllCheckBox").checked = false;
	            MailReceiverListXML = null;
	            xmlhttp_MailReceiverList = null;
	            var strQuery = "<MESSAGEID>" + decodeURIComponent(_url) + "</MESSAGEID>";
	            var requestUrl = "/ezEmail/mailGetReceiveList.do";
	            
	        	if (typeof(shareId) != "undefined" && shareId != "") {
	        		requestUrl += "?shareId=" + encodeURIComponent(shareId);
	        	}
	            
	            xmlhttp_MailReceiverList = createXMLHttpRequest();
	            xmlhttp_MailReceiverList.open("POST", requestUrl, true);
	            xmlhttp_MailReceiverList.onreadystatechange = event_xmlhttp_MailReceiverList_Complete;
	            xmlhttp_MailReceiverList.send(strQuery);
	        }

	        function event_xmlhttp_MailReceiverList_Complete() {
	            if (xmlhttp_MailReceiverList != null && xmlhttp_MailReceiverList.readyState == 4) {
	                if (xmlhttp_MailReceiverList.status >= 200 && xmlhttp_MailReceiverList.status < 300) {
	                    MailReceiverListXML = xmlhttp_MailReceiverList.responseXML;
	                    xmlhttp_MailReceiverList = null;
	                    ChangeTab(document.getElementById(Tab1_SelectID));
	                }
	            }
	        }

	        var Tab1_SelectID = "";
	        function Tab1_MouserOver(obj) {
	            obj.className = "tabover";
	        }

	        function Tab1_MouserOut(obj) {
	            if (Tab1_SelectID != obj.id)
	                obj.className = "";
	        }

	        function Tab1_MouseClick(obj) {
	            obj.className = "tabon";

	            if (obj.id != Tab1_SelectID) {

	            	if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
	                    document.getElementById(Tab1_SelectID).className = "";
	
	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                ChangeTab(obj);
	            }
	        }

	        function Tab1_NewTabIni(pTabNodeID) {
	            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	                if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
	                    if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };;
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };;
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };;
	
	                        if (i == 0) {
	                            document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
	                            Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
	                        }
	
	                    }
	                }
	            }
	        }
	        
	        function MakeListInfoHTML(pGubun) {
	            document.getElementById("HeaderAllCheckBox").checked = false;
	            var GetListInfo_ContentObject = document.getElementById("MailList");
	            // while (GetListInfo_ContentObject.childNodes.length > 0) {
	            //     GetListInfo_ContentObject.removeChild(GetListInfo_ContentObject.childNodes.item(0));
	            // }

				GetListInfo_ContentObject.innerHTML = "";

				var fragment = document.createDocumentFragment();
				
	            var XmlRows = SelectNodes(MailReceiverListXML, "DATA/ROW");
	            XmlRows = sortNode(XmlRows, "READDATE", "UNREAD", "DESC"); // READDATE 컬럼 기준 UNREAD가 아닌것 정렬 (내림차순으로)
	            
	            var Subject = getNodeText(SelectNodes(MailReceiverListXML, "DATA/SUBJECT")[0]);
	            document.title = "<spring:message code='ezEmail.t566' />" + "( " + Subject + " )";
				
				var XmlRowsArray = Array.from(XmlRows);
				
				var readerList =  XmlRowsArray.map(row => ({
					ReadDate: SelectSingleNodeValue(row, "READDATE"),
					EmailAddress: SelectSingleNodeValue(row, "READEREMAIL"),
					CancelStatus: trim_Cross(SelectSingleNodeValue(row, "CANCEL")),
	                // 2024.05.24 한슬기 : 수신자이름 사용하기위해 변경
					readerName: ReplaceText(SelectSingleNodeValue(row, "READERNAME"), "&", "&amp;")
				}));

				readerList.forEach(reader => {
					if (reader.EmailAddress == '') {
						return;
					}
					
	                var TR = document.createElement("TR");
	                var TD1 = document.createElement("TD");
	                var TD2 = document.createElement("TD");
	                var TD3 = document.createElement("TD");
	                var TD4 = document.createElement("TD");
	                var TD5 = document.createElement("TD");
	
	                TR.setAttribute("_mailaddress", reader.EmailAddress);
	                TD1.style.width = "14px";

					if((reader.ReadDate =="UNREAD" && reader.CancelStatus == "") || (isReadDelete == "YES" && (reader.CancelStatus == "" || reader.CancelStatus == 2))) {
	                    var TD1_Sub = document.createElement("INPUT");
	                    TD1_Sub.type = "checkbox";
	                    TD1_Sub.style.margin = "0px";
	                    TD1_Sub.style.padding = "0px";
	                    TD1_Sub.style.width = "13px";
	                    TD1_Sub.style.height = "13px";
	                    TD1.appendChild(TD1_Sub);
	                }
	                //TD2.innerHTML = ReplaceText(SelectSingleNodeValue(XmlRows[i], "READERNAME"), "&", "&amp;");
					
					TD2.innerHTML = reader.readerName;
					
	                TD2.style.width = "92px";
	                TD2.style.overflow = "hidden";
	                TD2.style.textOverflow = "ellipsis";
	                TD2.style.whiteSpace = "nowrap";
	                TD3.innerHTML = reader.EmailAddress
	                TD3.style.width = "212px";
	                TD3.style.overflow = "hidden";
	                TD3.style.textOverflow = "ellipsis";
	                TD3.style.whiteSpace = "nowrap";

	                if (reader.ReadDate == "UNREAD" || (reader.CancelStatus != "" && reader.CancelStatus != "2")) {
	                    TD4_ATag = document.createElement("A");
	                    TD4_ATag.className = "imgbtn";
	                    TD4_Span = document.createElement("SPAN");
	                    TD4_Span.innerHTML = "<spring:message code='ezEmail.t569' />";
	                    TD4_Span.setAttribute("EMAIL", reader.EmailAddress);
	                    TD4_Span.setAttribute("READERNAME", reader.readerName); // 수신자 이름
	                    TD4_Span.onclick = function () { ReSend(this); };
	                    TD4_ATag.appendChild(TD4_Span);
	                    TD4.appendChild(TD4_ATag);
	                }
	                else {
	                    TD4.innerHTML = reader.ReadDate;
	                }

	                TD4.style.width = "142px";
	                TD4.style.overflow = "hidden";
	                TD4.style.textOverflow = "ellipsis";
	                TD4.style.whiteSpace = "nowrap";
	                TD5.innerHTML = reader.CancelStatus == "" ? "" : reader.CancelStatus == "0" ? strLang325 : reader.CancelStatus == "1" ? strLang326 : reader.CancelStatus == "2" ? strLang327 : reader.CancelStatus == "3" ? strLang328 : "";
	                TD5.style.width = "80px";
	                TR.appendChild(TD1);
	                TR.appendChild(TD2);
	                TR.appendChild(TD3);
	                TR.appendChild(TD4);
	                TR.appendChild(TD5);

	                if (pGubun == "ALL") {
						fragment.appendChild(TR);
	                }
	                else if (pGubun == "READ" && reader.ReadDate != "UNREAD") {
						fragment.appendChild(TR);
	                }
	                else if (pGubun == "UNREAD" && reader.ReadDate == "UNREAD") {
						fragment.appendChild(TR);
	                }
	                else if (pGubun == "CANCEL" && reader.CancelStatus != "") {
						fragment.appendChild(TR);
	                }
	            });

				GetListInfo_ContentObject.appendChild(fragment);
				
	            if ($("#contentlist").height() < $("#MailList").height()){
	            	if ($("#Table1 tbody tr th#scrollTh").length < 1) {
	            		$("#Table1 tbody tr").append('<th id="scrollTh" style="width:10px"></th>');	
	            	}
	            	if ($("#Table1 tbody tr th:nth-child(3)").width() == 212) {
	            		$("#Table1 tbody tr th:nth-child(3)").width(214)
	            	}
	            } else {
	            	if ($("#Table1 tbody tr th#scrollTh").length > 0) {
	            		$("#Table1 tbody tr th#scrollTh").remove();
	            	}
	            	if ($("#Table1 tbody tr th:nth-child(3)").width() == 214) {
	            		$("#Table1 tbody tr th:nth-child(3)").width(212)
	            	}
	            }
				hideDim();
	        }

	        function event_listCheckboxclick(obj) {
	            if (obj.checked) {
	                for (var RowCnt = 0; RowCnt < MailList.childNodes.length; RowCnt++) {
	                    if (MailList.childNodes.item(RowCnt).childNodes.item(0).childNodes.length > 0) {
	                        MailList.childNodes.item(RowCnt).childNodes.item(0).childNodes.item(0).checked = true;
	                    }
	                }
	            }
	            else {
	                for (var RowCnt = 0; RowCnt < MailList.childNodes.length; RowCnt++) {
	                    if (MailList.childNodes.item(RowCnt).childNodes.item(0).childNodes.length > 0) {
	                        MailList.childNodes.item(RowCnt).childNodes.item(0).childNodes.item(0).checked = false;
	                    }
	                }
	            }
	        }

	        function ChangeTab(obj) {
	            var pSelectTab = obj.getAttribute("divname");
	            switch (pSelectTab) {
	                case "ALL":
	                    MakeListInfoHTML(pSelectTab);
	                    break;
	                case "READ":
	                    MakeListInfoHTML(pSelectTab);
	                    break;
	                case "UNREAD":
	                    MakeListInfoHTML(pSelectTab);
	                    break;
	                case "CANCEL":
	                    MakeListInfoHTML(pSelectTab);
	                    break;
	            }
	        }

	        function Window_Print() {
	            window.print();
	        }
	        
	        window.onresize = function(){
	        	// resizeTo(docWidth, docHeight);
	        }
			
			function showDim(){
				document.getElementById('dimPanel').style.display = 'flex';
				document.getElementById('MailProgress').style.display = '';
			}
			
			function hideDim(){
				document.getElementById('dimPanel').style.display = 'none';
				document.getElementById('MailProgress').style.display = 'none';
			}
			
	    </script>
	</head>
	<body scroll="no" class="popup">
	    <form id="Form1" method="post">
	        <div id="menu">
	            <ul id="normalScreen">
	                <h1 style="line-height: 30px;"><spring:message code='ezEmail.t568' /></h1>
	            </ul>
	        </div>
	        <div id="close">
	            <ul>
	                <li><span onclick="window.close()"></span></li>
	            </ul>
	        </div>
	        <div class="portlet_tabpart01" id="TabDiv">
	        	<div style="margin-bottom: 7px;">
					<span>※ <spring:message code='ezEmail.ksa14' /></span>
				</div>
	        	
	            <div class="portlet_tabpart01_top" id="tab1">
	                <p id="MailEnv_sub1"><span divname="ALL" id="1tab1"><spring:message code='ezEmail.t588' /></span></p>
	                <p id="MailEnv_sub2"><span divname="READ" id="1tab2"><spring:message code='ezEmail.t99000072' /></span></p>
	                <p id="MailEnv_sub3"><span divname="UNREAD" id="1tab3"><spring:message code='ezEmail.t99000073' /></span></p>
	                <p id="MailEnv_sub4"><span divname="CANCEL" id="1tab4"><spring:message code='ezEmail.t549' /></span></p>
	            </div>
	        </div>
	        <span id="MailListRayer" style="border: 0px solid blue; width: 500px; height: 100%; vertical-align: top; overflow: hidden;">
	            <table style="width: 100%; border: 1px solid #ddd;" id="MailHeader" class="mainlist">
	                <table style="width: 100%; border: 1px solid #ddd;" id="Table1" class="mainlist">
	                    <tr>
	                        <th style="width: 14px;">
	                            <input type="checkbox" id="HeaderAllCheckBox" style="margin: 0px; padding: 0px; width: 13px; height: 13px;" onclick="event_listCheckboxclick(this);"></th>
	                        <th style="width: 92px; text-align: left;"><spring:message code='ezEmail.t31' /></th>
	                        <th style="width: 212px; text-align: left;"><spring:message code='ezEmail.t1019' /></th>
	                        <th style="width: 142px; text-align: left;"><spring:message code='ezEmail.t99000074' /></th>
	                        <th style="width: 82px; text-align: left;"><spring:message code='ezEmail.t99000075' /></th>
	                    </tr>
	                </table>
	            </table>
	            <div id="contentlist" name="contentlist" style="border: 0px solid blue; height: 315px; width: 100%; overflow-y: auto;overflow-x:hidden;" >
	                <table class="mainlist" style="width: 100%;" id="MailList">
	                </table>
	            </div>
	        </span>
	        <div class="btnposition btnpositionNew"> 
			    <a class="imgbtn" onClick="Refresh()" ><span><spring:message code='ezEmail.t515' /></span></a>
			    <a class="imgbtn" onClick="MailCancel('ALL')" ><span><spring:message code='ezEmail.t588' /><spring:message code='ezEmail.t549' /></span></a>
			    <a class="imgbtn" onClick="MailCancel('EACH')" ><span><spring:message code='ezEmail.t549' /></span></a>
			    <a class="imgbtn" onClick="Window_Print()" ><span><spring:message code='ezEmail.t546' /></span></a>
			</div>
	    </form>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:5000;display:none;background:rgba(0,0,0,0.5);align-items: center;justify-content: center;" id="dimPanel">
			<div style="height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:relative;" id="MailProgress">
				<img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
			</div>
		</div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("menu"), "ul", "li", "0");
	        Tab1_NewTabIni("tab1");
	    </script>
	</body>
</html>