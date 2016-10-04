<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezEmail.t331' /></title>
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/string_component.js"></script>
		<script type="text/javascript" src="/js/Common.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/ListView_list.js"></script>
		<script>
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
		    var ReturnFunction;
		    var CancelFunction;
		    var Arguments;
		    function window_onload() {
		        try {
		            Arguments = parent.checkname_cross_dialogArguments[0];
		            ReturnFunction = parent.checkname_cross_dialogArguments[1];
		            CancelFunction = parent.checkname_cross_dialogArguments[2];
		        } catch (e) {
		            try {
		                Arguments = opener.checkname_cross_dialogArguments[0];
		                ReturnFunction = opener.checkname_cross_dialogArguments[1];
		                CancelFunction = opener.checkname_cross_dialogArguments[2];
		            } catch (e) { }
		        }
		        var emailaddress = "";
		        var listview = new ListView();
		        listview.SetID("DLList");
		        listview.SetSelectFlag(false);
		        listview.SetMulSelectable(true);
		        listview.SetRowOnDblClick("change_onClick");
		        var xmlpara = loadXMLString(listviewheader.innerHTML.toUpperCase());
		        listview.DataSource(xmlpara);
		        listview.DataBind("ListViewid");
		        listview.RowDataBind("")
		        if (ReturnFunction!=null) {
		            if (Arguments) {
		                var displayName = Arguments["g_DisplayName"];
		                emailaddress = Arguments["g_EmailAddress"];
		                if (navigator.userAgent.indexOf('Firefox') != -1) {
		                    unresolveName.innerHTML = displayName;
		                }
		                else {
		                    unresolveName.innerText = displayName;
		                }
		                Arguments["recipientTDData"] = "dontprocess";
		            }
		        }
		        else {
		            if (dialogArguments) {
		                var displayName = dialogArguments["g_DisplayName"];
		                emailaddress = dialogArguments["g_EmailAddress"];
		                if (navigator.userAgent.indexOf('Firefox') != -1) {
		                    unresolveName.innerHTML = displayName;
		                }
		                else {
		                    unresolveName.innerText = displayName;
		                }
		                dialogArguments["recipientTDData"] = "dontprocess";
		            }
		        }
				initializeReceiverList();
			}
		
			function initializeReceiverList()
			{
			    var count, length;
				var userAddr;
				var types, names, emails, hrefs;
				var szQueryUserName;
				
				var pparsingXML = "";
		        var pparsingXML2 = "";
		        if (ReturnFunction!=null)
		            userAddr = Arguments["addrBook"];
		        else
		            userAddr = dialogArguments["addrBook"];
		
				names = userAddr["name"];
				emails = userAddr["email"];
				hrefs = userAddr["href"];
				types = userAddr["type"];
				companys = userAddr["company"];	
				depts = userAddr["dept"];	
				titles = userAddr["title"];
				
				
				var xmlpara = createXmlDom();
				var objRoot, objNode, objSub, objSub2, objSub3, objSub4, objSub5, objSub6, objSub7, objSub8, objSub9, objSub10, objSub11;
				objRoot = createNodeInsert(xmlpara, objRoot, "LISTVIEWDATA2");
				objNode = createNodeAndAppandNode(xmlpara, objRoot, objNode, "ROWS");
				
				
				for(i=0; i < names.length; i++)
				{
					objSub = createNodeAndAppandNode(xmlpara, objNode, objSub, "ROW");
					objSub2 = createNodeAndAppandNode(xmlpara, objSub, objSub2, "CELL");
					createNodeAndAppandNodeText(xmlpara, objSub2, objSub7, "DATA1", names[i]);
					createNodeAndAppandNodeText(xmlpara, objSub2, objSub7, "DATA2", emails[i]);
					createNodeAndAppandNodeText(xmlpara, objSub2, objSub7, "DATA3", types[i]);
					createNodeAndAppandNodeText(xmlpara, objSub2, objSub7, "DATA4", hrefs[i]);
					createNodeAndAppandNodeText(xmlpara, objSub2, objSub7, "VALUE", companys[i]);
					objSub3 = createNodeAndAppandNode(xmlpara, objSub, objSub3, "CELL");
					createNodeAndAppandNodeText(xmlpara, objSub3, objSub8, "VALUE", depts[i]);
					objSub4 = createNodeAndAppandNode(xmlpara, objSub, objSub4, "CELL");
					createNodeAndAppandNodeText(xmlpara, objSub4, objSub9, "VALUE", titles[i]);
					objSub5 = createNodeAndAppandNode(xmlpara, objSub, objSub5, "CELL");
					createNodeAndAppandNodeText(xmlpara, objSub5, objSub10, "VALUE", names[i]);
					objSub6 = createNodeAndAppandNode(xmlpara, objSub, objSub6, "CELL");
					createNodeAndAppandNodeText(xmlpara, objSub6, objSub11, "VALUE", emails[i]);
					
				}
			    var listview = new ListView();
		        listview.SetID("DLList");
		        listview.SetSelectFlag(false);
		        listview.SetMulSelectable(true);
		        listview.SetRowOnDblClick("change_onClick");
				listview.DataSource(xmlpara);
				listview.RowDataBind();
			}
			
			function trim(str) 
		    {
		        var re = /^\s+|\s+$/g;
		        return str.replace(re, '');
		    }
			function change_onClick() 
			{
				var count1;
				var selectedItemCount;
				var selRow;
		
				var pListViewDL = new ListView();
				pListViewDL.LoadFromID("DLList");
		
				var arrRows = pListViewDL.GetSelectedRows();
		
				var listCount = arrRows.length;
		
				if (listCount == 0) 
		        {		
				    cancel_onClick();
					return;
		        }
				if (ReturnFunction!=null) {
				    Arguments["recipientTDData"] = "change";
				    Arguments["returnedRecipientType"] = new Array();
				    Arguments["returnedRecipientName"] = new Array();
				    Arguments["returnedRecipientEmail"] = new Array();
				    Arguments["returnedRecipientHref"] = new Array();
				}
				else {
				    dialogArguments["recipientTDData"] = "change";
				    dialogArguments["returnedRecipientType"] = new Array();
				    dialogArguments["returnedRecipientName"] = new Array();
				    dialogArguments["returnedRecipientEmail"] = new Array();
				    dialogArguments["returnedRecipientHref"] = new Array();
				}
			    var emailExistsCnt = 0;
			    for (count1 = 0; count1 < listCount; count1++) {
			        var isexists = arrRows[count1].getAttribute("data2") != "" && arrRows[count1].getAttribute("data2").lastIndexOf("@") > 1 || trim(arrRows[count1].getAttribute("data3")) == "mailgroup"; 
		            if (isexists)
		            {
		                if (ReturnFunction!=null) {
		                    Arguments["returnedRecipientType"][emailExistsCnt] = arrRows[count1].getAttribute("data3");
		                    Arguments["returnedRecipientName"][emailExistsCnt] = arrRows[count1].getAttribute("data1");
		                    Arguments["returnedRecipientEmail"][emailExistsCnt] = arrRows[count1].getAttribute("data2");
		                    Arguments["returnedRecipientHref"][emailExistsCnt] = arrRows[count1].getAttribute("data4");
		                }
		                else {
		                    dialogArguments["returnedRecipientType"][emailExistsCnt] = arrRows[count1].getAttribute("data3");
		                    dialogArguments["returnedRecipientName"][emailExistsCnt] = arrRows[count1].getAttribute("data1");
		                    dialogArguments["returnedRecipientEmail"][emailExistsCnt] = arrRows[count1].getAttribute("data2");
		                    dialogArguments["returnedRecipientHref"][emailExistsCnt] = arrRows[count1].getAttribute("data4");
		                }
					    emailExistsCnt++;
					}
			    }
			    if (ReturnFunction!=null)
			        ReturnFunction(Arguments);
		        else
				    window.close();
			}
		    function trim(str) 
		    {
		        var re = /^\s+|\s+$/g;
		        return str.replace(re, '');
		    }
			function delete_onClick()
		    {
			    if (ReturnFunction!=null) {
			        Arguments["recipientTDData"] = "delete";
			        ReturnFunction(Arguments);
			    }
			    else {
			        dialogArguments["recipientTDData"] = "delete";
			        window.close();
			    }
			}
		
			function cancel_onClick()
			{
			    if (ReturnFunction!=null) {
			        Arguments["recipientTDData"] = "dontprocess";
			        ReturnFunction(Arguments);
			    }
			    else {
			        dialogArguments["recipientTDData"] = "dontprocess";
			        window.close();
			    }
			}
		
			function check_presence() 
			{			    
			    /* var pMailList = new Array();
			    for(i=0; i<ListView.rows.length; i++) {
			        pMailList[i] = ListView.rows.item(i).childNodes[3].DATA3;
			    }
			    var pSIPUriList = getSIPUri("", pMailList.join(';').toString()).split(';');
			    pMailList = null;
			    
			    PresenceStatusInit();
				for(i=0; i<ListView.rows.length; i++) {
				    ListView.rows.item(i).cells(3).innerHTML = "<span><img src='/images/presence/unknown.gif' id= '" + GetGUID() + "type=smtp'  onload='PresenceControl(\"" + pSIPUriList[i] + "\",this);'/>" + ListView.rows.item(i).cells(3).innerHTML + "</span>";
				}	
				pSIPUriList = null;  */ 	   
			}
		</script>
	</head>
	<body class="popup" onload="javascript:window_onload()" style="overflow:hidden;">
		<xml id="listviewheader">
		<LISTVIEWDATA style="display: none;">
			<HEADERS>
					<HEADER>
						<TYPE>NONE</TYPE>
						<NAME><spring:message code='ezEmail.t333' /></NAME>
						<WIDTH>90</WIDTH>
						<SORTABLE>TRUE</SORTABLE>
						<RESIZIBLE>FALSE</RESIZIBLE>
						<MINSIZE>10</MINSIZE>
						<MAXSIZE>200</MAXSIZE>
						<NOWRAP>TRUE</NOWRAP>
					</HEADER>
		
					<HEADER>
						<NAME><spring:message code='ezEmail.t26' /></NAME>
						<WIDTH>100</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezEmail.t28' /></NAME>
						<WIDTH>70</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezEmail.t31' /></NAME>
						<WIDTH>100</WIDTH>
					</HEADER>
					<HEADER>
						<NAME>E-MAIL</NAME>
						<WIDTH>180</WIDTH>
					</HEADER>
			</HEADERS>
		</LISTVIEWDATA>
		</xml> 
	<h1><spring:message code='ezEmail.t331' /></h1>
	<div class="txt"><spring:message code='ezEmail.t335' /><br>
	      <spring:message code='ezEmail.t336' />
	  <br><br>
	  <spring:message code='ezEmail.t337' /><span class="point" id="unresolveName"><spring:message code='ezEmail.t338' /></span></div>
	<div class="listview" style="height:200px;overflow:auto"><div id="ListViewid" STYLE="border:0px;"></div></div>
	<div class="btnposition">
	    <a class="imgbtn" onClick="delete_onClick()" ><span><spring:message code='ezEmail.t95' /></span></a>
	    <a class="imgbtn" onClick="change_onClick()" ><span><spring:message code='ezEmail.t38' /></span></a>
	    <a class="imgbtn" onClick="cancel_onClick()" ><span><spring:message code='ezEmail.t39' /></span></a>
	</div>
	</body>
</html>



