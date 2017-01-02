<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<%
		String userApprovalG = (String)request.getAttribute("userApprovalG");
		String userLang = (String)request.getAttribute("userLang");
		%>
		<section  class="body_bg1">
			<article id="appr_article" class="appr_mail">
				<div class="tab">
    				<ul>
    					<li><img src="/images/<spring:message code='main.t00025' />/main/tab_appro.gif" onclick="change_article('appr')" width="50" height="115"></li>
     					<li><img src="/images/<spring:message code='main.t00025' />/main/tab_mail.gif" onclick="change_article('mail')" width="50" height="115"></li>
    				</ul>
    			</div>
    			<!-- graph -->
    			<section class="apprgraph">
    				<div class="apprgraph_area">
    					<dl>
    						<dt><spring:message code='main.t00006' /></dt>
    							<dd>
    								<div class="nomal_count">
        								<span id="SIXHGAP" runat="server">0</span>
        							</div>
     							</dd>
    					</dl>
    					<dl>
    						<dt><spring:message code='main.t00007' /></dt>
    						<dd>
    							<div class="nomal_count">
        							<span id="ONEDGAP" runat="server">0</span>
        						</div>
        					</dd>
    					</dl>
    					<dl>
    						<dt><spring:message code='main.t00008' /></dt>
    						<dd>
    							<div class="nomal_count">
        							<span id="SEVENDGAP" runat="server">0</span>
        						</div>
        					</dd>
    					</dl>
    					<dl>
    						<dt><spring:message code='main.t00009' /></dt>
    						<dd>
    							<div class="nomal_count">
        							<span id="ONEMGAP" runat="server">0</span>
        						</div>
        					</dd>
    					</dl>
    					<dl>
    						<%if(userLang != "3"){ %>
    							<dt><spring:message code='main.t00010' /></dt>
    						<%}else{%>
    							<dt style="font-size:8pt"><spring:message code='main.t00010' /></dt>
    						<%} %>
    						<dd>
    							<div class="point_count">
        							<span id="OTHER" runat="server">000</span>
        						</div>
        					</dd>
    					</dl>
    				</div>
    			</section>
     			<!-- /graph -->
    			<!-- list -->
  				<section class="portletbox appr_mailbox"  style="">
          			<div class="title">
          				<span class="tr"></span>
            			<!-- tab -->
            			<dl class="portlet_tab">
              				<dt id="doingTab" onclick="apprChangeTab(this)"  class="on"><span><spring:message code='main.t00003' /><span id="doingCNT" class="tab_num" runat="server">(0)</span></span></dt>
              				<dt id="rejectTab" onclick="apprChangeTab(this)" ><span><spring:message code='main.t00004' /><span id="rejectCNT" class="tab_num" runat="server">(0)</span></span></dt>
              				<dt id="draftTab" onclick="apprChangeTab(this)"><span><spring:message code='main.t00005' /><span id="draftCNT" class="tab_num" runat="server">(0)</span></span></dt>
            			</dl>
            			<!-- /tab -->
            			<span class="btn_more"><img onclick="Appmore_btnClick()" src="/images/<spring:message code='main.t00025' />/main/btn_more02.gif" width="35" height="20" alt="더보기"></span>
            		</div>
          			<div id ="ApprList" class="appr_mailcont">            
              			<ul class="listtype_txt">
            	<%-- 			<%if(pExist) { %>
            					<asp:Repeater ID="ApprListRepeater" runat="server">  
                					<ItemTemplate>
                    					<li id="DocListArray_TR_<%# (Container.ItemIndex) %>"
                         				onclick="opendocview('<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("DOCID")[0].InnerText %>',
                        				'<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("HREF")[0].InnerText %>',
                        				'<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("APRMEMBERID")[0].InnerText %>',
                        				'<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("APRMEMBERNAME")[0].InnerText %>',
                        				'<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("APRMEMBERDEPTID")[0].InnerText %>',
                        				'<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("DOCSTATE")[0].InnerText %>',
                        				'<%# ((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("FUNCTIONTYPE")[0].InnerText %>')">

                        				<span class='txt'><%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("DOCTITLE")[0].InnerText) %></span> 
                        				<span class='date'><%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("STARTDATE")[0].InnerText).Substring(0, 
                                           Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("STARTDATE")[0].InnerText).Length-3) %></span> 
                        				<span class='name'><%# Server.HtmlEncode(((System.Xml.XmlElement)Container.DataItem).GetElementsByTagName("WRITERNAME")[0].InnerText) %></span>
                    					</li>
                					</ItemTemplate>   
            					</asp:Repeater>
            				<%} else {%>
                				<div class='nodata_portlet '>
                					<p><img src='/images/<spring:message code='main.t00025' />/main/nodata_white.gif' width='107' height='70'></p>
                					<p><spring:message code='main.t00026' /></p>
                				</div>
            				<%} %> --%>
            			</ul>
          			</div>
        		</section>
 				<!-- list -->
 				<div class="guide"><span class="lb"></span><span class="rb"></span></div>
			</article>

    		<article id="mail_article" style="display:none;" class="appr_mail">
				<div class="tab">
    				<ul>
     					<li><img src="/images/<spring:message code='main.t00025' />/main/tab_appr.gif" onclick="change_article('appr')" width="50" height="115"></li>
     					<li><img src="/images/<spring:message code='main.t00025' />/main/tab_mailo.gif" onclick="change_article('mail')" width="50" height="115"></li>    
    				</ul>
    			</div>
    			<!-- graph -->
    			<section class="apprgraph">
    				<div class="mailgraph_area">
    					<p class="title"><img src="/images/<spring:message code='main.t00025' />/main/mail_graphtitle.gif" alt="<spring:message code='main.t00011' />" width="146" height="28"></p>
    					<p class="graphimg"><img id="mailquateimg" src="/images/<spring:message code='main.t00025' />/main/mailgraph/g000.gif" width="146" height="114"></p>
    					<ul>
    						<li><spring:message code='main.t00012' /><strong id="UseMailBox" class="rtxt"></strong></li>
    						<li><spring:message code='main.t00013' /><strong id="MailBoxSize"></strong></li>
    					</ul>
  					</div>
    			</section>
     			<!-- /graph -->
    			<!-- list -->
  				<section class="portletbox appr_mailbox"  style="">
          			<div class="title">
          				<span class="tr"></span>
            				<!-- tab -->
            				<dl class="portlet_tab">
              					<dt  class="on"><span><spring:message code='main.t00014' /><span id="InBoxCNT" class="tab_num">(0)</span></span></dt>
				            </dl>
            				<!-- /tab -->
            				<span class="btn_more"><img onclick="Mailmore_btnClick()" src="/images/<spring:message code='main.t00025' />/main/btn_more02.gif" width="35" height="20" alt="more"></span>
            		</div>
          			<div id="MailList" class="appr_mailcont"></div>
        		</section>
 				<!-- list -->
 				<div class="guide"><span class="lb"></span><span class="rb"></span></div>
			</article>
		</section>
		
		<link href="/css/main.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1' />"></script>
		<script type="text/javascript">
	    var arr_userinfo = new Array();
	    arr_userinfo[0] = "user";
	    arr_userinfo[1] = "${userInfo.id}";
	    arr_userinfo[2] = "${userInfo.displayName1}";
	    arr_userinfo[3] = "${userInfo.title1}";
	    arr_userinfo[4] = "${userInfo.deptID}";
	    arr_userinfo[5] = "${userInfo.deptName1}";
	    arr_userinfo[6] = "${userInfo.jikChek}";
	    arr_userinfo[8] = "${userInfo.email}";  
	    var pUserID = arr_userinfo[1];
	    var companyID = "${userInfo.companyID}";
	    var pListTypeValue = "1";
	    var strLang1_NewApprMail = "<spring:message code='main.t00026' />";
	    var pUse_Editor = "${useEditor}";
	    var pUse_IE11Browser = "${useIE11Browser}";
	    var pNoneActiveX = "${noneActiveX}";
	    document.onselectstart = function () { return false; };
	    function window_onload_NewApprMail() {
	        if (navigator.userAgent.indexOf('Firefox') != -1) {
	            document.body.style.MozUserSelect = 'none';
	            document.body.style.WebkitUserSelect = 'none';
	            document.body.style.khtmlUserSelect = 'none';
	            document.body.style.oUserSelect = 'none';
	            document.body.style.UserSelect = 'none';
	        }
	        getApprGraph();
	        try { top.onresize() } catch (e) { }
	    }

	    function change_article(flag)
	    {
	        if (flag == "appr") {
	            document.getElementById("appr_article").style.display = "";
	            document.getElementById("mail_article").style.display = "none";
	        }
	        else {
	            document.getElementById("appr_article").style.display = "none";
	            document.getElementById("mail_article").style.display = "";
	            getMailGraph();
	        }
	    }

	    var xmlhttp_getApprGraph_NewApprMail = createXMLHttpRequest();
	    function getApprGraph() {
<%-- 	        var xmlpara = createXmlDom();

	        var objNode;
	        createNodeInsert(xmlpara, objNode, "PARAMETER");
	        createNodeAndInsertText(xmlpara, objNode, "pListTypeName", pListTypeValue);
	        createNodeAndInsertText(xmlpara, objNode, "pDocTypeName", "A01000");
	        createNodeAndInsertText(xmlpara, objNode, "pUserID", pUserID);
	        createNodeAndInsertText(xmlpara, objNode, "pUserDeptID", arr_userinfo[4]);
	        createNodeAndInsertText(xmlpara, objNode, "pPageSize", "1000");
	        createNodeAndInsertText(xmlpara, objNode, "pPageNum", "1");
	        createNodeAndInsertText(xmlpara, objNode, "companyID", companyID);
	        createNodeAndInsertText(xmlpara, objNode, "orderCell", "");
	        createNodeAndInsertText(xmlpara, objNode, "orderOption", "");
	        createNodeAndInsertText(xmlpara, objNode, "SearchQuery", "");
	        createNodeAndInsertText(xmlpara, objNode, "SubQuery", "");

	        xmlhttp_getApprGraph_NewApprMail = null;
	        xmlhttp_getApprGraph_NewApprMail = createXMLHttpRequest();
	        
	        if ("<%=userApprovalG%>" == "YES")
	            xmlhttp_getApprGraph_NewApprMail.open("POST", "/ezApprovalG/getPortletAprDocList.do", true);
	        else
	            xmlhttp_getApprGraph_NewApprMail.open("POST", "/myoffice/ezApproval/aspx/getportletaprdoclist.aspx", true);
	        xmlhttp_getApprGraph_NewApprMail.onreadystatechange = getDocList_after;
	        xmlhttp_getApprGraph_NewApprMail.send(xmlpara); --%>
        	if ("<%=userApprovalG%>" == "YES") {
        	      $.ajax({
      	        	type : "POST",
      	        	dataType : "text",
      	        	url : "/ezApprovalG/getPortletAprDocList.do",
      	        	data : {
      	        		pListTypeName   : pListTypeValue, 
      	        		pDocTypeName 	 : "A01000", 
      	        		pUserID 	 : pUserID, 
      	        		pUserDeptID 	 : arr_userinfo[4], 
      	        		pPageSize : "1000",
      	        		pPageNum : "1",
      	        		companyID : companyID,
      	        		orderCell : "",
      	        		orderOption : "",
      	        		searchQuery : "",
      	        		subQuery : ""
      	        	},
      	        	success : function(xml){		        		
      	        		getDocList_after(loadXMLString(xml));
      	        	},
      	        	error : function(error){
      	        		alert("<spring:message code='ezBoard.t22'/>" + error);	
      	        	}
      	        });
        	} else {
        		 $.ajax({
       	        	type : "POST",
       	        	dataType : "text",
       	        	url : "/ezApproval/getPortletAprDocList.do",
       	        	data : {
       	        		pListTypeName   : pListTypeValue, 
       	        		pDocTypeName 	 : "A01000", 
       	        		pUserID 	 : pUserID, 
       	        		pUserDeptID 	 : arr_userinfo[4], 
       	        		pPageSize : "1000",
       	        		pPageNum : "1",
       	        		companyID : companyID,
       	        		orderCell : "",
       	        		orderOption : "",
       	        		searchQuery : "",
       	        		subQuery : ""
       	        	},
       	        	success : function(xml){
       	        		getDocList_after(loadXMLString(xml));
       	        	},
       	        	error : function(error){
       	        		alert("<spring:message code='ezBoard.t22'/>" + error);	
       	        	}
       	        });	
        	}
	    }

	    function getDocList_after(xml) {

	        if (xml == null) return;

	        try {
	            document.getElementById("ApprList").innerHTML = "";
	          
	            var xmldom = createXmlDom();
	            xmldom = xml;

	                var listHTML = "";
	                if (pListTypeValue == "1") {
	                    document.getElementById("doingCNT").innerHTML = "(" + getNodeText(xmldom.getElementsByTagName("TOTALCNT1").item(0)) + ")";
	                    document.getElementById("draftCNT").innerHTML = "(" + getNodeText(xmldom.getElementsByTagName("TOTALCNT2").item(0)) + ")";
	                    document.getElementById("rejectCNT").innerHTML = "(" + getNodeText(xmldom.getElementsByTagName("TOTALCNT3").item(0)) + ")";

	                    document.getElementById("SIXHGAP").innerHTML = getNodeText(xmldom.getElementsByTagName("SIXHGAP").item(0));
	                    document.getElementById("ONEDGAP").innerHTML = getNodeText(xmldom.getElementsByTagName("ONEDGAP").item(0));
	                    document.getElementById("SEVENDGAP").innerHTML = getNodeText(xmldom.getElementsByTagName("SEVENDGAP").item(0));
	                    document.getElementById("ONEMGAP").innerHTML = getNodeText(xmldom.getElementsByTagName("ONEMGAP").item(0));
	                    document.getElementById("OTHER").innerHTML = getNodeText(xmldom.getElementsByTagName("OTHER").item(0));
	                }

	                if (xmldom.getElementsByTagName("CELL").length > 0)
	                {
	                    listHTML = "<ul class=\"listtype_txt \">";
	                    for (var i = 0; i < xmldom.getElementsByTagName("CELL").length; i++)
	                    {
	                        var DOCTITLE = getNodeText(xmldom.getElementsByTagName("DOCTITLE").item(i));
	                        var WRITERNAME = getNodeText(xmldom.getElementsByTagName("WRITERNAME").item(i));
	                        var STARTDATE = getNodeText(xmldom.getElementsByTagName("STARTDATE").item(i));

	                        var DOCID = getNodeText(xmldom.getElementsByTagName("DOCID").item(i));
	                        var HREF = getNodeText(xmldom.getElementsByTagName("HREF").item(i));
	                        var APRMEMBERID = getNodeText(xmldom.getElementsByTagName("APRMEMBERID").item(i));
	                        var APRMEMBERNAME = getNodeText(xmldom.getElementsByTagName("APRMEMBERNAME").item(i));
	                        var APRMEMBERDEPTID = getNodeText(xmldom.getElementsByTagName("APRMEMBERDEPTID").item(i));
	                        var DOCSTATE = getNodeText(xmldom.getElementsByTagName("DOCSTATE").item(i));
	                        var FUNCTIONTYPE = getNodeText(xmldom.getElementsByTagName("FUNCTIONTYPE").item(i));
	                        listHTML += "<li onclick=\"opendocview('" + DOCID + "','" + HREF + "','" + APRMEMBERID + "','" + APRMEMBERNAME + "','" + APRMEMBERDEPTID + "','" + DOCSTATE + "','" + FUNCTIONTYPE + "')\"><span class='txt'>" + DOCTITLE + "</span> <span class='date'>" + STARTDATE.substring(0, STARTDATE.length - 3) + "</span> <span class='name'>" + WRITERNAME + "</span></li>";
	                     }                                 


	                    listHTML += "</ul>";
	                }
	                else
	                {
	                    listHTML = "<div class='nodata_portlet '>";
	                    listHTML += "<p><img src='/images/<spring:message code='main.t00025' />/main/nodata_white.gif' width='107' height='70'></p>";
	                    listHTML += "<p>" + strLang1_NewApprMail + "</p></div>";
	                }
	                document.getElementById("ApprList").innerHTML = listHTML;
	          
	        }
	        catch (e) {
	        }
	    }

	    function opendocview(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType) {
	        var openLocation = "";

	        if ("<%=userApprovalG%>" == "YES")
	        {
	            if (pListTypeValue != "2") {
	                if (pFunctionType == "004" || pFunctionType == "006" || pFunctionType == "015") {
	                    if (pDocState == "012" || pDocState == "014" || pDocState == "018") {
	                        OpenReceiveDraftUI(pDocID, pHref, "REDRAFT");
	                    }
	                    else {
	                        openApprDraftUI("REDRAFT", pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType);
	                    }
	                }
	                else
	                    openApprovUI(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType);
	            }
	            else {
	                openViewDocInfo(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType);

	            }
	        }
	        else {
	            if (pListTypeValue != "2") {
	                if (pFunctionType == strAprState4 || pFunctionType == strAprState6 || pFunctionType == strAprState15) {
	                    if (pDocState == strDocState12 || pDocState == strDocState14 || pDocState == strDocState18) {
	                        var pDraftFlag = "REDRAFT";
	                        if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "doc") {
	                            openLocation = "/myoffice/ezApproval/ezViewWord/ezDeptRecevUI_word.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                        }
	                        else if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
	                            openLocation = "/myoffice/ezApproval/ezViewHWP/ezDeptRecevUI_HWP.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                        }
	                        else {
	                            <% if (request.getHeader("User-Agent").indexOf("MSIE") > -1 || request.getHeader("User-Agent").indexOf("Trident") > -1)
	                               {%>
	                            var openLocation = "";
	                            if (pUse_Editor == "TAGFREE" || pUse_Editor == "NAMO")
	                                openLocation = "/myoffice/ezApproval/ReceivUI/recev_TFI.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                            else {
	                                if(pUse_IE11Browser == "CK")
	                                    openLocation = "/myoffice/ezApproval/ReceivUI/recev_IE.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                                else
	                                    openLocation = "/myoffice/ezApproval/ReceivUI/recev.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                            }
	                            <%} else { %>
	                                openLocation = "/myoffice/ezApproval/ReceivUI/recev_Cross.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                            <%}%>
	                        }
	                    }
	                    else if (pDocState == strDocState11) {
	                        if (arr_userinfo[4] != pAprMemberDeptID) {
	                            var pAlertContent = "<spring:message code='main.t2200' />";
	                            alert(pAlertContent);
	                            return;
	                        }

	                        var pDraftFlag = "REDRAFT";
	                        var openLocation = "";

	                        if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "doc") {
	                            openLocation = "/myoffice/ezApproval/ezViewWord/ezRecevUI_word.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                        }
	                        else if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
	                            openLocation = "/myoffice/ezApproval/ezViewHWP/ezRecevUI_HWP.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                        }
	                        else {
	                            
	                            <% if (request.getHeader("User-Agent").indexOf("MSIE") > -1 || request.getHeader("User-Agent").indexOf("Trident") > -1)
	                               {%>
	                            if (pUse_Editor == "TAGFREE" || pUse_Editor == "NAMO")
	                                openLocation = "/myoffice/ezApproval/ReceivUI/recev_end_TFI.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                            else {
	                                if (pUse_IE11Browser == "CK")
	                                    openLocation = "/myoffice/ezApproval/ReceivUI/recev_end_IE.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                                else
	                                    openLocation = "/myoffice/ezApproval/ReceivUI/recev_end.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                            }
	                            <%} else { %>
	                                openLocation = "/myoffice/ezApproval/ReceivUI/Recev_End_Cross.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	                            <%}%>
	                        }
	                    }
	                    else {
	                        if (arr_userinfo[4] != pAprMemberDeptID) {
	                            var pAlertContent = "<spring:message code='main.t2200' />";
	                            alert(pAlertContent);
	                            return;
	                        }

	                        var pDraftFlag = "REDRAFT";
	                        var tempDocState = strDocState1;
	                        var SusinSn = "0";
	                        if (pDocState == strDocState11) {
	                            tempDocState = strDocState11;
	                            SusinSn = "1";
	                        }

	                        var AprState = strAprState4;
	                        if (pFunctionType == strAprState6)
	                            AprState = strAprState6;

	                        if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "doc") {
	                            openLocation = "/myoffice/ezApproval/ezViewWord/ezDraftUI_word.aspx?formURL=" + escape(pHref) + "&DraftFlag=" + escape(pDraftFlag) + "&formDocType=";
	                            openLocation = openLocation + "&susinSN=" + escape(SusinSn) + "&DocState=" + escape(tempDocState) + "&ListType=1&AprState=" + escape(AprState);
	                            openLocation = openLocation + "&isTmpDoc=";
	                        }
	                        else if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
	                            if (CrossYN()) {
	                                openLocation = "/myoffice/ezApproval/ezViewHWP/ezDraftUI_HWP_Cross.aspx?formURL=" + escape(pHref) + "&DraftFlag=" + escape(pDraftFlag) + "&formDocType=";
	                                openLocation = openLocation + "&susinSN=" + escape(SusinSn) + "&DocState=" + escape(tempDocState) + "&ListType=1&AprState=" + escape(AprState);
	                                openLocation = openLocation + "&isTmpDoc=";
	                            }
	                            else {
	                                openLocation = "/myoffice/ezApproval/ezViewHWP/ezDraftUI_HWP.aspx?formURL=" + escape(pHref) + "&DraftFlag=" + escape(pDraftFlag) + "&formDocType=";
	                                openLocation = openLocation + "&susinSN=" + escape(SusinSn) + "&DocState=" + escape(tempDocState) + "&ListType=1&AprState=" + escape(AprState);
	                                openLocation = openLocation + "&isTmpDoc=";
	                            }
	                        }
	                        else {
	                            if (CrossYN() || pNoneActiveX == "YES") {
	                                openLocation = "/myoffice/ezApproval/DraftUI/Draftui_Cross.aspx?formURL=" + escape(pHref) + "&DraftFlag=" + escape(pDraftFlag) + "&formDocType=";
	                                openLocation = openLocation + "&susinSN=" + escape(SusinSn) + "&DocState=" + escape(tempDocState) + "&ListType=1&AprState=" + escape(AprState);
	                                openLocation = openLocation + "&isTmpDoc=";
	                            }
	                            else {
	                                if (pUse_Editor == "")
	                                    openLocation = "/myoffice/ezApproval/DraftUI/Draftui.aspx?formURL=" + escape(pHref) + "&DraftFlag=" + escape(pDraftFlag) + "&formDocType=";
	                                else {
	                                    openLocation = "/myoffice/ezApproval/DraftUI/Draftui_IE.aspx?formURL=" + escape(pHref) + "&DraftFlag=" + escape(pDraftFlag) + "&formDocType=";
	                                }
	                                openLocation = openLocation + "&susinSN=" + escape(SusinSn) + "&DocState=" + escape(tempDocState) + "&ListType=1&AprState=" + escape(AprState);
	                                openLocation = openLocation + "&isTmpDoc=";
	                            }
	                        }
	                    }
	                }
	                else {
	                    if (arr_userinfo[4] != pAprMemberDeptID) {
	                        var pAlertContent = "<spring:message code='main.t2200' />";
	                        alert(pAlertContent);
	                        return;
	                    }

	                    if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "doc") {
	                        var openLocation = "/myoffice/ezApproval/ezViewWord/ezAproveUI_word.aspx?DocID=" + escape(pDocID);
	                        openLocation = openLocation + "&uID=" + escape(pAprMemberID) + "&uName=" + escape(pAprMemberName);
	                        openLocation = openLocation + "&uDeptID=" + escape(pAprMemberDeptID);
	                    }
	                    else if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
	                        var openLocation;
	                        if (CrossYN())
	                            openLocation = "/myoffice/ezApproval/ezViewHWP/ezAproveUI_HWP_Cross.aspx?DocID=" + escape(pDocID);
	                        else
	                            openLocation = "/myoffice/ezApproval/ezViewHWP/ezAproveUI_HWP.aspx?DocID=" + escape(pDocID);
	                        openLocation = openLocation + "&uID=" + escape(pAprMemberID) + "&uName=" + escape(pAprMemberName);
	                        openLocation = openLocation + "&uDeptID=" + escape(pAprMemberDeptID);
	                    }
	                    else {
	                        if (CrossYN() || pNoneActiveX == "YES") {
	                            var openLocation = "/myoffice/ezApproval/ApprovUI/ApprovUI_Cross.aspx?DocID=" + escape(pDocID);
	                            openLocation = openLocation + "&uID=" + escape(pAprMemberID) + "&uName=" + escape(pAprMemberName);
	                            openLocation = openLocation + "&uDeptID=" + escape(pAprMemberDeptID);
	                        }
	                        else {
	                            if (pUse_Editor == "")
	                                var openLocation = "/myoffice/ezApproval/ApprovUI/Approvui.aspx?DocID=" + escape(pDocID);
	                            else {
	                                var openLocation = "/myoffice/ezApproval/ApprovUI/Approvui_IE.aspx?DocID=" + escape(pDocID);
	                            }
	                            openLocation = openLocation + "&uID=" + escape(pAprMemberID) + "&uName=" + escape(pAprMemberName);
	                            openLocation = openLocation + "&uDeptID=" + escape(pAprMemberDeptID);
	                        }
	                    }
	                }
	            }
	            else {


	                if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "doc") {
	                    var openLocation = "/myoffice/ezApproval/ezViewWord/ezViewApr_Word.aspx?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref);
	                    openLocation = openLocation + "&OpinionFlag=&docState=&ListSusin=&odoc=&isOpinion=&ListType=2";
	                }
	                else if (pHref.substr(pHref.length - 3, pHref.length).toLowerCase() == "hwp") {
	                    var openLocation = "/myoffice/ezApproval/ezViewHWP/ezViewApr_HWP.aspx?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref);
	                    openLocation = openLocation + "&OpinionFlag=&docState=&ListSusin=&odoc=&isOpinion=&ListType=2";
	                }
	                else {
	                    <% if (request.getHeader("User-Agent").indexOf("MSIE") > -1 || request.getHeader("User-Agent").indexOf("Trident") > -1)
	                       {%>
	                    if (pUse_Editor == "TAGFREE" || pUse_Editor == "NAMO") {
	                        var openLocation = "/myoffice/ezApproval/AprDocView_TFI.aspx?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref);
	                        openLocation = openLocation + "&OpinionFlag=&docState=&ListSusin=&odoc=&isOpinion=&ListType=2";
	                    }
	                    else {
	                        if (pUse_IE11Browser == "CK")
	                            var openLocation = "/myoffice/ezApproval/AprDocView_IE.aspx?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref);
	                        else
	                            var openLocation = "/myoffice/ezApproval/AprDocView.aspx?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref);

	                        openLocation = openLocation + "&OpinionFlag=&docState=&ListSusin=&odoc=&isOpinion=&ListType=2";
	                    }
	                    <%} else { %>
	                    var openLocation = "/myoffice/ezApproval/aprDocView_Cross.aspx?DocID=" + escape(pDocID) + "&DocHref=" + escape(pHref);
	                    openLocation = openLocation + "&OpinionFlag=&docState=&ListSusin=&odoc=&isOpinion=&ListType=2";
	                    <%}%>
	                }
	            }
	            openwindow(openLocation);
	        }
	        
	    }

	    function openViewDocInfo(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType) {
	        var pArgument = new Array();
	        var formURL = pHref;
	        var DocID = pDocID;
	        pArgument[0] = DocID;
	        pArgument[1] = formURL;
	        pArgument[2] = "";
	        pArgument[3] = pDocState;
	        pArgument[4] = "";
	        pArgument[5] = "";
	        pArgument[6] = "OPINION_SHOW";
	        pArgument[7] = "2";

	        var openLocation;
	        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
	            openLocation = "/myoffice/ezApprovalG/ezViewWord/ezViewApr_Word_Cross.aspx?DocID=" + escape(pArgument[0]) + "&DocHref=" + escape(pArgument[1]);
	            openLocation = openLocation + "&OpinionFlag=" + escape(pArgument[2]) + "&docState=" + escape(pArgument[3]) + "&ListSusin=" + escape(pArgument[4]) + "&odoc=" + escape(pArgument[5]);
	            openLocation = openLocation + "&isOpinion=" + escape(pArgument[6]);
	            openLocation = openLocation + "&ListType=" + escape(pArgument[7]);
	        }
	        else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
	            openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezViewApr_HWP_Cross.aspx?DocID=" + escape(pArgument[0]) + "&DocHref=" + escape(pArgument[1]);
	            openLocation = openLocation + "&OpinionFlag=" + escape(pArgument[2]) + "&docState=" + escape(pArgument[3]) + "&ListSusin=" + escape(pArgument[4]) + "&odoc=" + escape(pArgument[5]);
	            openLocation = openLocation + "&isOpinion=" + escape(pArgument[6]);
	            openLocation = openLocation + "&ListType=" + escape(pArgument[7]);
	        }
	        else {            
	            if (CrossYN()) {
	                openLocation = "/ezApprovalG/aprDocView.do?docID=";
	            }
	            else {
	                if (pUse_Editor == "TAGFREE" || pUse_Editor == "NAMO")
	                    openLocation = "/ezApprovalG/aprDocView.do?docID=";
	                else
	                {
	                    if (pUse_IE11Browser == "CK")
	                        openLocation = "/ezApprovalG/aprDocView.do?docID=";
	                    else
	                        openLocation = "/ezApprovalG/aprDocView.do?docID=";
	                }
	            }
	            openLocation = openLocation + escape(pArgument[0]) + "&docHref=" + escape(pArgument[1]);
	            openLocation = openLocation + "&opinionFlag=" + escape(pArgument[2]) + "&docState=" + escape(pArgument[3]) + "&ListSusin=" + escape(pArgument[4]) + "&odoc=" + escape(pArgument[5]);
	            openLocation = openLocation + "&isOpinion=" + escape(pArgument[6]);
	            openLocation = openLocation + "&listType=" + escape(pArgument[7]);
	        }

	        openwindow(openLocation, "", 880, 570);
	    }


	    function openApprDraftUI(pDraftFlag, pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType) {
	        var pArgument = new Array();
	        var formURL = pHref;
	        pArgument[0] = arr_userinfo[1];
	        pArgument[1] = pHref;
	        pArgument[2] = pDraftFlag;
	        pArgument[3] = "";

	        var openLocation = "";
	        var tempDocState = "001";
	        var SusinSn = "0";
	        if (pDocState == "011") {
	            tempDocState = "011";
	            SusinSn = "1";
	        }

	        var AprState = "004";
	        if (pFunctionType == "006")
	            AprState = "006";
	       
	        pArgument[4] = SusinSn;
	        pArgument[5] = tempDocState;
	        pArgument[6] = AprState;
	        pArgument[7] = "";


	        if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
	            openLocation = "/myoffice/ezApprovalG/ezViewWord/ezDraftUI_word_Cross.aspx?formURL=" + escape(pArgument[1]) + "&DraftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
	            openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&DocState=" + escape(pArgument[5]) + "&ListType=1&AprState=" + escape(pArgument[6]);
	            openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7])
	        }
	        else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "mht" || formExt == "MHT") {
	            
	            if (CrossYN()) {
	                openLocation = "/ezApprovalG/draftui.do?formURL=";
	            }
	            else {
	                if (pUse_Editor == "TAGFREE" || pUse_Editor == "NAMO")
	                    openLocation = "/ezApprovalG/draftui.do?formURL=";
	                else {
	                    if (pUse_IE11Browser == "CK")
	                        openLocation = "/ezApprovalG/draftui.do?formURL=";
	                    else
	                        openLocation = "/ezApprovalG/draftui.do?formURL=";
	                }
	            }

	            openLocation = openLocation + escape(pArgument[1]) + "&draftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
	            openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&docState=" + escape(pArgument[5]) + "&listType=1&aprState=" + escape(pArgument[6]);
	            openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]);
	        }
	        else {
	            if (CrossYN()) {
	                openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezDraftUI_HWP_Cross.aspx?formURL=" + escape(pArgument[1]) + "&DraftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
	                openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&DocState=" + escape(pArgument[5]) + "&ListType=1&AprState=" + escape(pArgument[6]);
	                openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]);
	            } else {
	                openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezDraftUI_HWP.aspx?formURL=" + escape(pArgument[1]) + "&DraftFlag=" + escape(pArgument[2]) + "&formDocType=" + escape(pArgument[3]);
	                openLocation = openLocation + "&susinSN=" + escape(pArgument[4]) + "&DocState=" + escape(pArgument[5]) + "&ListType=1&AprState=" + escape(pArgument[6]);
	                openLocation = openLocation + "&isTmpDoc=" + escape(pArgument[7]);
	            }
	        }

	        openwindow(openLocation, "", 890, 560);
	    }

	    function OpenReceiveDraftUI(pDocID, pURL, pDraftFlag) {
	        var openLocation;

	        if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "doc") {
	            openLocation = "/myoffice/ezApprovalG/ezViewWord/ezDeptRecevUI_word_Cross.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	        }
	        else if (pURL.substr(pURL.length - 3, pURL.length).toLowerCase() == "hwp") {
	            openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezDeptRecevUI_HWP_Cross.aspx?DocID=" + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	        }
	        else {

	            if (CrossYN()) {
	                openLocation = "/myoffice/ezApprovalG/ReceivUI/recev_CK.aspx?DocID=";
	            }
	            else {
	                if (pUse_Editor == "TAGFREE" || pUse_Editor == "NAMO")
	                    openLocation = "/myoffice/ezApprovalG/ReceivUI/recev_TFI.aspx?DocID=";
	                else {
	                    if (pUse_IE11Browser == "CK")
	                        openLocation = "/myoffice/ezApprovalG/ReceivUI/recev_IE.aspx?DocID=";
	                    else
	                        openLocation = "/myoffice/ezApprovalG/ReceivUI/recev.aspx?DocID=";
	                }
	            }

	            openLocation = openLocation + escape(pDocID) + "&DraftFlag=" + escape(pDraftFlag);
	        }
	        openwindow(openLocation, "receive", 880, 550);
	    }


	    function openApprovUI(pDocID, pHref, pAprMemberID, pAprMemberName, pAprMemberDeptID, pDocState, pFunctionType) {
	     
	            var pArgument = new Array();
	            pArgument[0] = pDocID;
	            pArgument[1] = pAprMemberID;
	            pArgument[2] = pAprMemberName;
	            pArgument[3] = pAprMemberDeptID;

	            var formURL = pHref;
	            if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "doc") {
	                openLocation = "/myoffice/ezApprovalG/ezViewWord/ezAproveUI_word_Cross.aspx?DocID=" + escape(pArgument[0]);
	                openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
	                openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=0";
	            }
	            else if (formURL.substr(formURL.length - 3, formURL.length).toLowerCase() == "hwp") {
	                openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezAproveUI_HWP_Cross.aspx?DocID=" + escape(pArgument[0]);
	                openLocation = openLocation + "&uID=" + escape(pArgument[1]) + "&uName=" + escape(pArgument[2]);
	                openLocation = openLocation + "&uDeptID=" + escape(pArgument[3]) + "&AllFlag=0";
	            }
	            else {                
	                if (CrossYN()) {
	                    openLocation = "/ezApprovalG/approvui.do?docID=";
	                }
	                else {
	                    if (pUse_Editor == "TAGFREE" || pUse_Editor == "NAMO")
	                        openLocation = "/ezApprovalG/approvui.do?docID=";
	                    else {
	                        if (pUse_IE11Browser == "CK")
	                            openLocation = "/ezApprovalG/approvui.do?docID=";
	                        else
	                            openLocation = "/ezApprovalG/approvui.do?docID=";
	                    }
	                }

	                openLocation = openLocation + escape(pArgument[0]);
	                openLocation = openLocation + "&id=" + escape(pArgument[1]) + "&name=" + escape(pArgument[2]);
	                openLocation = openLocation + "&deptID=" + escape(pArgument[3]) + "&allFlag=0";
	            }
	            openwindow(openLocation, "", 880, 550);       
	    }

	    function openwindow(wfileLocation) {
	        var height = window.screen.availHeight;
	        var width = window.screen.availWidth;
	        var left = 0;
	        var top = 0;

	        if (window.screen.width > 800) {
	            var pleftpos;
	            pleftpos = parseInt(width) - 967;
	            height = parseInt(height) - 30;
	            width = parseInt(width) - pleftpos;
	            left = pleftpos / 2;
	        }
	        else {
	            heigth = parseInt(height) - 30;
	            width = parseInt(width) - 10;
	        }
	        window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + height + ",width=" + width + ",top=" + top + ",left = " + left);
	    }

	    function apprChangeTab(obj)
	    {
	        switch (obj.id)
	        {
	            case "doingTab":
	                pListTypeValue = "1";
	                document.getElementById("doingTab").className = "on";
	                document.getElementById("rejectTab").className = "";
	                document.getElementById("draftTab").className = "";                
	                break;

	            case "rejectTab":
	                pListTypeValue = "4";
	                document.getElementById("doingTab").className = "";
	                document.getElementById("rejectTab").className = "on";
	                document.getElementById("draftTab").className = "";
	                break;

	            case "draftTab":
	                pListTypeValue = "2";
	                document.getElementById("doingTab").className = "";
	                document.getElementById("rejectTab").className = "";
	                document.getElementById("draftTab").className = "on";
	                break;
	        }
	        getApprGraph();
	    }

	    function Appmore_btnClick()
	    {
	        if ("<%=userApprovalG%>" == "YES")
	        {
	            if (pListTypeValue != "2")
	                window.open("/ezApprovalG/apprGMain.do?listType=1", "main");
	            else
	                window.open("/ezApprovalG/apprGMain.do?listType=2", "main");
	        }
	        else
	        {
	            if (pListTypeValue != "2")
	                window.open("/ezApprovalG/apprGMain.do?listType=1", "main");
	            else
	                window.open("/ezApprovalG/apprGMain.do?listType=2", "main");
	        }
	    }

	    var xmlhttp_getMailGraph_NewApprMail = createXMLHttpRequest();
	    function getMailGraph() {

	        var xmlpara = createXmlDom();

	        var objNode;
	        createNodeInsert(xmlpara, objNode, "PARAMETER");
	        createNodeAndInsertText(xmlpara, objNode, "pMailType", "1");       

	        //DisplayWaitStat();

	        xmlhttp_getMailGraph_NewApprMail = null;
	        xmlhttp_getMailGraph_NewApprMail = createXMLHttpRequest();
	        xmlhttp_getMailGraph_NewApprMail.open("POST", "/ezEmail/getPortletMailList.do", true);
	        xmlhttp_getMailGraph_NewApprMail.onreadystatechange = getMailList_after;
	        xmlhttp_getMailGraph_NewApprMail.send(xmlpara);
	    }

	    function getMailList_after() {

	        if (xmlhttp_getMailGraph_NewApprMail == null || xmlhttp_getMailGraph_NewApprMail.readyState != 4) return;

	        try {          

	            document.getElementById("MailList").innerHTML = "";
	            

	            var xmldom = createXmlDom();
	            xmldom = xmlhttp_getMailGraph_NewApprMail.responseXML;

	            
	            document.getElementById("InBoxCNT").innerHTML = "(" + getNodeText(xmldom.getElementsByTagName("TOTALCNT").item(0)) + ")";
	            document.getElementById("UseMailBox").innerHTML = getNodeText(xmldom.getElementsByTagName("MAILBOXDETAIL").item(0));// + " " + getNodeText(xmldom.getElementsByTagName("MAILPERCENT").item(0)) +"%";
	            var MailPercent = getNodeText(xmldom.getElementsByTagName("MAILPERCENT").item(0));
	            
	            if (MailPercent.length == 1)
	                MailPercent = "00" + MailPercent;
	            else if (MailPercent.length == 2)
	                MailPercent = "0" + MailPercent;

	            document.getElementById("mailquateimg").src = "/images/<spring:message code='main.t00025' />/main/mailgraph/g" + MailPercent + ".gif";
	            document.getElementById("MailBoxSize").innerHTML = getNodeText(xmldom.getElementsByTagName("MAILBOXSIZE").item(0));

	            var listHTML = "";
	            if (xmldom.getElementsByTagName("NODE").length > 0) {
	                var listHTML = "<ul class=\"listtype_txt \">";
	                for (var i = 0; i < xmldom.getElementsByTagName("NODE").length; i++) {
	                    var SUBJECT = getNodeText(xmldom.getElementsByTagName("SUBJECT").item(i));
	                    var SENDER = getNodeText(xmldom.getElementsByTagName("SENDER").item(i));
	                    var DATE = getNodeText(xmldom.getElementsByTagName("DATE").item(i));
	                    var HREF = getNodeText(xmldom.getElementsByTagName("HREF").item(i));
	                    listHTML += "<li onclick=\"open_mail('" + HREF + "')\"><span class='txt'>" + SUBJECT + "</span> <span class='date'>" + DATE.substring(0, DATE.length - 3) + "</span> <span class='name'>" + SENDER + "</span></li>";
	                }

	                listHTML += "</ul>";
	            }
	            else {
	                listHTML = "<div class='nodata_portlet '>";
	                listHTML += "<p><img src='/images/<spring:message code='main.t00025' />/main/nodata_white.gif' width='107' height='70'></p>";
	                listHTML += "<p>" + strLang1_NewApprMail + "</p></div>";
	            }

	            document.getElementById("MailList").innerHTML = listHTML;

	        }
	        catch (e) {
	        }
	    }

	    function open_mail(url) {        
	        var pheight = window.screen.availHeight;
	        var conHeight = pheight * 0.8;
	        var pwidth = window.screen.availWidth;
	        var conWidth = pwidth * 0.8;
	        if (conWidth > 890)
	            conWidth = 890;
	        var pTop = (pheight - conHeight) / 2;
	        var pLeft = (pwidth - 890) / 2;

	        var newwin;
	        var pURI;
	        if (navigator.userAgent.indexOf("MSIE") > -1) {
	            pURI = "/ezEmail/mailRead.do?URL=" + encodeURIComponent(url) + "&PNFlag=N&CONTENTCLASS=";
	        }
	        else {
	            pURI = "/ezEmail/mailRead.do?URL=" + encodeURIComponent(url) + "&PNFlag=N&CONTENTCLASS=";
	        }

	        newwin = window.open(pURI, "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	        newwin.focus();
	        getMailGraph();
	    }

	    function ReplaceText(orgStr, findStr, replaceStr) {
	        var re = new RegExp(findStr, "gi");
	        return (orgStr.replace(re, replaceStr));
	    }

	    function Mailmore_btnClick()
	    {
	        window.open("/ezEmail/mailMain.do", "main");
	    }
	    function refresh_onclick() {
	        change_article('mail');
	    }
	    function openergetDocInfo() {
	        if (document.getElementById("doingTab").className == "on") {
	            apprChangeTab(document.getElementById("doingTab"));
	        }
	        else if (document.getElementById("rejectTab").className == "on") {
	            apprChangeTab(document.getElementById("rejectTab"));
	        }
	        else {
	            apprChangeTab(document.getElementById("draftTab"));
	        }
	    }

	    window_onload_NewApprMail();
		
		</script>
	</head>	
</html>