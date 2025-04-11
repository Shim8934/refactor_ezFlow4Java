<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title>mail_search</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/search_mail.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/newMail_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email.write.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/date_component.js')}"></script>
		<script  type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/datepicker.htc.js')}"></script>
		<script  type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/composeappt.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<script type="text/javascript">
		    var pUse_Editor = "${useEditor}";
			var g_servername = "${serverName}";	
			var g_expath = "exchange";
			var g_userID = "${userId}";
			var importanceColor = "#ff0000";
			var g_userLang = "${userLang}";
			var g_timezone = "${userTimeSet}";
			var offsetMin = "${offsetMin}";
		    var checkval = "f";
		    var m_strColorSelect = "#f1f8ff";
		    var m_strColorOver = "#f4f5f5";
		    var m_strColorDefault = "#ffffff";
		    var pNoneActiveX = "YES";
		    var useEncryptZipForEmail = "${useEncryptZipForEmail}";
		    var keywordFromList = "<c:out value='${keywordFromList}'/>";
			var searchCheck = "<c:out value='${searchCheck}'/>";
			var searchFromList = "<c:out value='${searchFromList}'/>";
			var searchCArray = new Array();
			var searchKArray = new Array();
			var shareId = "${shareId}";
			var startDate = "";
            var endDate = "";
			var listType = "searchList";
			var mailSearchPeriodSDate = "";
			var searchMode = true;
            var searchRequiredKeyword = [];
            var searchRequiredCategory = [];
            var searchRequirement = [];
		    
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
		    $(function () {
		        $("#Sdatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        $("#Edatepicker").datepicker({
		            changeMonth: true,
		            changeYear: true,
		            autoSize: true,
		            showOn: "both",
		            buttonImage: "/images/ImgIcon/calendar-month.png",
		            buttonImageOnly: true
		        });
		        
		        switch ("${mailSearchPeriod}") {
			        case 'oneWeek':
			        	mailSearchPeriodSDate = "-1w";
			        	break;
			        case 'oneMonth' :
			        	mailSearchPeriodSDate = "-1m";
			        	break;
			        case 'threeMonth' :
			        	mailSearchPeriodSDate = "-3m";
			        	break;
			        case 'sixMonth' :
			        	mailSearchPeriodSDate = "-6m";
			        	break;
			        case 'oneYear' :
			        	mailSearchPeriodSDate = "-1y";
			        	break;
			        default :
			        	mailSearchPeriodSDate = "-6m";
		        }
		        
		        var NowDate = utcDate2(offsetMin);
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', mailSearchPeriodSDate);
		        $("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Edatepicker").datepicker('setDate', NowDate);
		    });
		    
		    $(function () {
		        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
		            closeText: "<spring:message code='main.t3' />",
		            prevText: "<spring:message code='main.t0604' />",
		            nextText: "<spring:message code='main.t0605' />",
		            currentText: "<spring:message code='main.t0606' />",
		            monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
		                         "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
		                         "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
		                         "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
		            monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
		                              "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
		                              "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
		                              "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
		            dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
		                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
		                       "<spring:message code='main.t0627' />"],
		            dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
				                       "<spring:message code='main.t0627' />"],
		            dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
			                       "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
			                       "<spring:message code='main.t0627' />"],
		            weekHeader: "Wk",
		            dateFormat: "yy-mm-dd",
		            firstDay: 0,
		            isRTL: false,
		            duration: 200,
		            showAnim: "show",
		            showMonthAfterYear: true
		        };
		        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });
		    
		    window.onload = function() {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		        $("#Sdatepicker").datepicker('disable');
		        $("#Edatepicker").datepicker('disable');
		        
		        var inputkeyword = document.getElementsByName('prekeyword').item(0);
		        
		        if (searchFromList) {
		        	$("#moreSearch").css("display", ""); 
		        	$("#moreSearch2").css("display", ""); 
	        		var keyCode = document.getElementById("selectDetail1");
		       		if (searchCheck == 'SUBJECT') {
		       			keyCode.children[0].setAttribute("selected", "selected");
		       			prekeywordDetail1.value = keywordFromList;
		        	} else if (searchCheck == 'FROM') {
		        		keyCode.children[2].setAttribute("selected", "selected");
		        		prekeywordDetail1.value = keywordFromList;
			   	 	} else if (searchCheck == 'RECEIVE') {
			   	 		keyCode.children[3].setAttribute("selected", "selected");	
			   	 		prekeywordDetail1.value = keywordFromList;
			   	 	} else if (searchCheck == 'FILE') {
			   	 		keyCode.children[4].setAttribute("selected", "selected");	
			   	 		prekeywordDetail1.value = keywordFromList;
			   	 	} else if (searchCheck == 'ALL') {
			   	 		$("#moreSearch").css("display") == "none"
		        		var all = document.getElementById("select2");
		        		ALL.value = keywordFromList;
		        	}  

		       		setTimeout(set_searchKey, 1000);
		    	} else {
		    		$("#moreSearch").css("display", "none"); 
		    		$("#moreSearch2").css("display", "none"); 
		    	}
		        
		        if($("#moreSearch2").css("display") == "none"){   
			    	document.getElementById("resultTD").style.height = (document.documentElement.clientHeight - 361) + "px";
				} else {
				    if (document.documentElement.clientWidth < 837) {
					    document.getElementById("resultTD").style.height = (document.documentElement.clientHeight - 448) + "px";
					} else {
					    document.getElementById("resultTD").style.height = (document.documentElement.clientHeight -  430) + "px";
					}
				}
				
		        makePageSelPage();
		    }
		    
		    window.onresize = function () {
		    	if($("#moreSearch2").css("display") == "none"){   
			    	document.getElementById("resultTD").style.height = (document.documentElement.clientHeight - 361) + "px";
				} else {
					if (document.documentElement.clientWidth < 837) {
					    document.getElementById("resultTD").style.height = (document.documentElement.clientHeight - 495) + "px";
					} else {
					    document.getElementById("resultTD").style.height = (document.documentElement.clientHeight - 468) + "px";
					}
				}
		    }
		    
		    function search_keypress(evt)
			{	
		        var curevent = (typeof event == 'undefined' ? evt  : event)
		        if (curevent.keyCode == "13") {
					set_searchKey();
		        }
			}
		    function set_searchKey() {
		    	searchCArray = [];
		    	searchKArray = [];
		    	var usepostDate = document.getElementById("selectRange").value;
				if(usepostDate == "All"){
					this.usepostDate = false;	
				} else {
					this.usepostDate = true;
				}
		    	if (!TrimText(ALL.value)) {
                    if (TrimText(prekeywordDetail1.value).length == 1 || TrimText(prekeywordDetail2.value).length == 1 || TrimText(prekeywordDetail3.value).length == 1) {
                        alert("<spring:message code='ezSystem.yja01' />");
                        return;
                    }
		    		if( $("#moreSearch").css("display") != "none"){
			    		if (!TrimText(prekeywordDetail1.value) && !TrimText(prekeywordDetail2.value) && !TrimText(prekeywordDetail3.value) 
			    				&& !this.usepostDate) {
				    		alert(strLang254);
				            return;
			    		} 
		    		} else {
		    			if (!this.usepostDate) {
				    		alert(strLang254);
				            return;
		    			}
		    		}
		        } else {
		            if (TrimText(ALL.value).length == 1) {
                        alert("<spring:message code='ezSystem.yja01' />");
                        return;
                    }
	        		searchCArray.push("ALL");
	    			searchKArray.push(TrimText(ALL.value));
		        	document.getElementById("resultTD").setAttribute("curPage", 1);
		        }
		    	
        		if( $("#moreSearch").css("display") != "none"){
		        	if (prekeywordDetail1.value) {
		        		searchCArray.push(TrimText(selectDetail1.value));
		    			searchKArray.push(TrimText(prekeywordDetail1.value));
		        	} 
		        	if (prekeywordDetail2.value) {
		        		searchCArray.push(TrimText(selectDetail2.value));
		    			searchKArray.push(TrimText(prekeywordDetail2.value));
		        	} 
		        	if (prekeywordDetail3.value) {
		        		searchCArray.push(TrimText(selectDetail3.value));
		    			searchKArray.push(TrimText(prekeywordDetail3.value));
		        	} 
		        	searchCArray.push("ATTACHSTATUS");
		        	searchKArray.push(document.querySelector("input[name=attachment]:checked").value);
		        	
		        	searchCArray.push("ANDOR");
		        	searchKArray.push(document.querySelector("input[name=andor]:checked").value);
	        	}
	        	start_search();
		    }
			function document_onselectstart()
			{
				event.cancelBubble = true;
				event.returnValue = false;
			}
			
			function check_change(checkbox) {

		    	// mail list DomElement
		    	var mailListElement = resultTD.childNodes.item(0).childNodes.item(0);
		    	
		    	// 메일 리스트가 비어있다면 함수 종료 (검색결과 없음 또는 메일 없음)
		    	if (isEmptyMailList(mailListElement)) {
		    		return;
		    	}
		    	
		    	// tr 노드들 (메일 리스트의 전체 행)
		    	var mailNodes = mailListElement.childNodes;
		    	// tr 노드 (하나의 행)
		    	var mailNode;
		    	// tr 노드 개수
		    	var nodeCount = mailNodes.length;
		    	
		    	if (checkbox.checked) {
		        	
		            for (var i = 0; i < nodeCount; i++) {
		            	mailNode = mailNodes.item(i);
		            	
		            	mailNode.childNodes.item(0).childNodes.item(0).checked = true;
		            	mailNode.style.backgroundColor = m_strColorSelect;
		                //TODO: 테스트해보기 2016-06-02
		                // dhlee: modified so that existing elements aren't merged with new ones.
		                //listContentArry[listContentArry.length] = document.getElementById("MailList").childNodes.item(i).getAttribute("id");
		                listContentArry[i] = mailNode.getAttribute("id");
		            }
		        } else {
		        	
		            for (var i = 0; i < nodeCount; i++) {
		            	mailNode = mailNodes.item(i);
		            	
		            	mailNode.childNodes.item(0).childNodes.item(0).checked = false;
		            	mailNode.style.backgroundColor = m_strColorDefault;
		            }
		            
		            listContentArry = new Array();
		        }
			}
			
			// MailList id값을 가진 DomElement를 파라미터로 함
			// 메일 Row가 존재하지 않으면 true, 있다면 false
			function isEmptyMailList(mailListElement) {
				
				if (mailListElement === undefined || mailListElement === null) {
					return true;
				}
				
				if (mailListElement.childElementCount > 1) {
					return false;
				}
				
				var firstMailNode = mailListElement.childNodes.item(0);
				
				return firstMailNode.childElementCount === 1;
			}
		
			function new_mail_onclick() 
			{
			    var pheight = window.screen.availHeight;
			    var conHeight = pheight * 0.8;
			    var pwidth = window.screen.availWidth;
			    var conWidth = pwidth * 0.8;
			    if (conWidth > 1200)
			        conWidth = 1200;
			    var pTop = (pheight - conHeight) / 2;
			    var pLeft = (pwidth - 1200) / 2;
			    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
			    
			    var requestUrl = "/ezEmail/mailWrite.do?cmd=NEW";
			    
			    if (shareId != "") {
			    	requestUrl += "&shareId=" + encodeURIComponent(shareId);
			    }
			    
			    window.open(requestUrl, "", feature);
			}
			function reply_mail_onclick() 
			{
			    var selcheck;
			    var count = 0;
			    
			    if (GetChildNodes(resultTD).length == 0) {
			    	alert(strLang42);
			        return;
			    }
			    
				var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
				for (var i = 0; i < Rows.length; i++) {
				    if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
				        count++;
				        selcheck = Rows.item(i);
				    }
				}
				if (count == 0) 
				{
					alert(strLang42);
					return;
				}			
				else if (count > 1) 
				{
					alert(strLang44);
					return;
				}
			    var pheight = window.screen.availHeight;
			    var conHeight = pheight * 0.8;
			    var pwidth = window.screen.availWidth;
			    var conWidth = pwidth * 0.8;
			    if (conWidth > 1200)
			        conWidth = 1200;
			    var pTop = (pheight - conHeight) / 2;
			    var pLeft = (pwidth - 1200) / 2;
			    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
			    
				var requestUrl = "/ezEmail/mailWrite.do?URL=" + encodeURIComponent(selcheck.getAttribute("itemID")) + "&cmd=REPLY";
			    
			    if (shareId != "") {
			    	requestUrl += "&shareId=" + encodeURIComponent(shareId);
			    }
			    
			    window.open(requestUrl, "", feature);
			}
		
			function all_reply_mail_onclick() 
			{
			    var selcheck;
			    var count = 0;
			    
			    if (GetChildNodes(resultTD).length == 0) {
			    	alert(strLang42);
			        return;
			    }
			    
			    var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
			    for (var i = 0; i < Rows.length; i++) {
			        if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
			            count++;
			            selcheck = Rows.item(i);
			        }
			    }
				if (count == 0) 
				{
					alert(strLang42);
					return;
				}	
				else if (count > 1) 
				{
					alert(strLang44);
					return;
				}
			
			    var pheight = window.screen.availHeight;
			    var conHeight = pheight * 0.8;
			    var pwidth = window.screen.availWidth;
			    var conWidth = pwidth * 0.8;
			    if (conWidth > 1200)
			        conWidth = 1200;
			    var pTop = (pheight - conHeight) / 2;
			    var pLeft = (pwidth - 1200) / 2;
			    var feature = "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1";
			    
				var requestUrl = "/ezEmail/mailWrite.do?URL=" + encodeURIComponent(selcheck.getAttribute("itemID")) + "&cmd=REPLYALL";
			    
			    if (shareId != "") {
			    	requestUrl += "&shareId=" + encodeURIComponent(shareId);
			    }
			    
			    window.open(requestUrl, "", feature);
			}
		
			function transmission_mail_onclick() 
			{
				// 2025.02.13 김은실 : [국립암센터] 메일 전달 방식. 전달 시 메일 다수 선택 가능.
				var selchecks = [];

			    if (GetChildNodes(resultTD).length > 0) {
					var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;

					for (var i = 0; i < Rows.length; i++) {
						if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
							selchecks.push(Rows.item(i).getAttribute("itemID")); // "INBOX/4"
						}
					}
			    }

				forward_mail_call(selchecks, shareId); // 마지막 라인이라 return 필요없어서 생략.
			}
		    var mail_movecopy_cross_dialogArguments = new Array();
		    var selcheck;
			function move_mail_onclick() 
			{
			    selcheck = new Array();
			    var count = 0;
			    
			    if (GetChildNodes(resultTD).length == 0) {
			    	alert(strLang42);
			        return;
			    }
			    
			    if (resultTD.childNodes.item(0).childNodes.length > 0) {
			        var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
			        for (var i = 0; i < Rows.length; i++) {
			            if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
			                selcheck[count] = Rows.item(i);
			                count++;
			            }
			        }
			        if (count == 0) {
			            alert(strLang42);
			            return;
			        }
			        
			        var requestUrl = "/ezEmail/mailMoveCopy.do";
				    
				    if (shareId != "") {
				    	requestUrl += "?shareId=" + encodeURIComponent(shareId);
				    }
			        
			        if (CrossYN()) {
			            mail_movecopy_cross_dialogArguments[1] = move_mail_onclick_Complete;
			            mail_movecopy_cross_dialogArguments[2] = "CLOSE";
			            
			            var OpenWin = window.open(requestUrl, "mail_movecopy_cross", GetOpenWindowfeature(500, 700));
			            try { OpenWin.focus(); } catch (e) {console.log(e);}
			        }
			        else {
			            var feature = "dialogHeight:375px; dialogWidth:320px; status:no; help:no; edge:sunken";
			            feature = feature + GetShowModalPosition(320, 375);
			            
			            var moveUrl = window.showModalDialog(requestUrl, null, feature);
		
			            if (typeof (moveUrl) == "undefined")
			                return;
		
			            if (moveUrl["cmd"] == "MOVE") {
			                copyItemList(moveUrl["cmd"], moveUrl["url"], selcheck);
			                var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
			                for (var i = 0; i < Rows.length; i++) {
			                    if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
			                        Rows.item(i).childNodes.item(0).childNodes.item(0).checked = false;
			                        Rows.item(i).childNodes.item(0).childNodes.item(0).disabled = true;
			                        Rows.item(i).onclick = function () { return false; };
			                        Rows.item(i).onmouseover = function () { return false; }
			                        Rows.item(i).onmouseout = function () { return false; }
			                        //for (var RowCnt = 0; RowCnt < Rows.item(i).childNodes.length; RowCnt++) {
			                        Rows.item(i).style.backgroundColor = m_strColorDefault;
			                           // Rows.item(i).childNodes.item(RowCnt).disabled = true;
			                        //}
			                    }
			                }
			            }
			            else if (moveUrl["cmd"] == "COPY") {
			                copyItemList(moveUrl["cmd"], moveUrl["url"], selcheck);
			            }
		
			            listContentArry = new Array();
			        }
			    }
			}
		    function move_mail_onclick_Complete(moveUrl)
		    {
		        if (typeof (moveUrl) == "undefined")
		            return;
		
		        if (moveUrl["cmd"] == "MOVE") {
		            copyItemList(moveUrl["cmd"], moveUrl["url"], selcheck);
		            var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
		            for (var i = 0; i < Rows.length; i++) {
		                if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
		                    Rows.item(i).childNodes.item(0).childNodes.item(0).checked = false;
		                    Rows.item(i).childNodes.item(0).childNodes.item(0).disabled = true;
		                    Rows.item(i).onclick = function () { return false; };
		                    Rows.item(i).onmouseover = function () { return false; }
		                    Rows.item(i).onmouseout = function () { return false; }
		                    //for (var RowCnt = 0; RowCnt < Rows.item(i).childNodes.length; RowCnt++) {
		                        Rows.item(i).style.backgroundColor = m_strColorDefault;
		                        //Rows.item(i).childNodes.item(RowCnt).disabled = true;
		                    //}
		                }
		            }
		        }
		        else if (moveUrl["cmd"] == "COPY") {
		            copyItemList(moveUrl["cmd"], moveUrl["url"], selcheck);
		        }
		
		        listContentArry = new Array();
		    }
			function copyItemList(cmd, copyFolderID, selectedURL)
			{
			    var itemIDsarr = new Array();
		        for (i = 0; i < selectedURL.length; i++)
		        {
		            if (typeof (selectedURL[i].getAttribute("itemID")) != "undefined")
		            {
		                itemIDsarr[i] = selectedURL[i].getAttribute("itemID");
		            }
		        }
			    var itemIDs = itemIDsarr.join(',');
			    try 
			    {
		            g_copyItemHttp = createXMLHttpRequest();
		            var xmlDOM = createXmlDom();
		            var objNode;
		            createNodeInsert(xmlDOM, objNode, "DATA");
		            createNodeAndInsertText(xmlDOM, objNode, "CMD",cmd );
		            createNodeAndInsertText(xmlDOM, objNode, "UNIQUEID", itemIDs);
		            createNodeAndInsertText(xmlDOM, objNode, "FOLDERID",copyFolderID );
		            
		            var requestUrl = "/ezEmail/mailMoveCopyMessageS.do";
				    
				    if (shareId != "") {
				    	requestUrl += "?shareId=" + encodeURIComponent(shareId);
				    }
		            
		            g_copyItemHttp.open("POST", requestUrl, true);
		            g_copyItemHttp.onreadystatechange = event_copyItemList;
		            event_copyItemList.cmd = cmd;
		            g_copyItemHttp.send(xmlDOM);
		        }
		        catch (e) {
		            g_copyItemHttp = null;
		            if (cmd == "COPY")
		                alert(strLang52);
		            else if (cmd == "MOVE")
		                alert(strLang5);
		            else if (cmd == "BDELETE")
		                alert(strLang6);
		        }
			}
			function event_copyItemList() {
			    if (g_copyItemHttp != null && g_copyItemHttp.readyState == 4) { 
			        if (g_copyItemHttp.status < 200 || g_copyItemHttp.status > 300) {
			            g_copyItemHttp = null;
		
			            if (event_copyItemList.cmd == "COPY") {
			                alert(strLang52);
			            }
			            else if (event_copyItemList.cmd == "MOVE") {
			                alert(strLang5);
			            }
			            else if (event_copyItemList.cmd == "BDELETE") {
			                alert(strLang6);
			            }
			        }
			        else {
						if (g_copyItemHttp.responseText.indexOf("NO COPY processing failed.") > -1) {
			        		alert(strLang241);
						}
						else {
				            if (event_copyItemList.cmd == "COPY") {
				                alert(strLang53);
				                start_search();
				            }
				            else {
				                alert(strLang53.replace(strLang251, strLang252));
				                start_search();
				            }
						}
						g_copyItemHttp = null;
			        }
			    }
			}
		
			function deleteWork(bDel) {
			    if (GetChildNodes(resultTD).length == 0) {
			        alert(strLang42);
			        return;
			    }

				var selcheck = new Array();
				var count = 0;
				    
				var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
				for (var i = 0; i < Rows.length; i++) {
				    if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
				        selcheck[count] = Rows.item(i);
				        count++;
				    }
				}		

				if (count < 1) {
			        alert(strLang42);
			        return;
			    }
				
				var includeSecureMail = false;
				for (var i = 0; i < selcheck.length; i++) {
					if (selcheck[i].getAttribute("securemail") == "1") {
						includeSecureMail = true;
				    	break;
				    }
				}
				
				var strItemID = "";
				for(i=0; i < count; i++)
		        {
					var itemId = selcheck[i].getAttribute("itemid");
		            strItemID += itemId + ",";
			    }
				
			    if (includeSecureMail) {
		        	if (!confirm(strLangLHM19)) {
		        		return;
		        	}
		        }
	        	if (!confirm(strLang59)) {
	            	return;
	            }
				
				var xmlpara = createXmlDom();
			    var objNode;
			    xmlhttp_mailMoveDelete = createXMLHttpRequest();
			    createNodeInsert(xmlpara, objNode, "DATA");
			    createNodeAndInsertText(xmlpara, objNode, "UNIQUEID", strItemID);
			    createNodeAndInsertText(xmlpara, objNode, "FOLDERID", "");
			    
			    var requestUrl = "/ezEmail/mailDeleteS.do?cmd=BMOVE";
			    
			    if (shareId != "") {
			    	requestUrl += "&shareId=" + encodeURIComponent(shareId);
			    }
			    
			    xmlhttp_mailMoveDelete.open("POST", requestUrl, true);
			    xmlhttp_mailMoveDelete.send(xmlpara);
			    xmlhttp_mailMoveDelete.onreadystatechange = function () {
			    	if (xmlhttp_mailMoveDelete.readyState == 4) {
				    	if (xmlhttp_mailMoveDelete.status < 200 || xmlhttp_mailMoveDelete.status > 300)
						    alert('<spring:message code="ezEmail.t638" />');
						else {
						    alert('<spring:message code="ezEmail.t604" />');
						    listContentArry = new Array();
						    start_search();
						}
			    	}
			    } // onreadystatechange End
			}
			
			function delete_mail()
			{
			    var selcheck = new Array();
			    var count = 0;
			    
			    if (GetChildNodes(resultTD).length == 0) {
			    	alert(strLang42);
			        return;
			    }
			    
			    var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;
			    for (var i = 0; i < Rows.length; i++) {
			        if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
			            selcheck[count] = Rows.item(i);
			            count++;
			        }
			    }
				
				if (count == 0)
				{
					alert(strLang42);
					return;
				}
		
				var strItemID = "";
		
				if (confirm(strLang58)) {
					for(i=0; i < count; i++)
			        {
			            strItemID += selcheck[i].getAttribute("itemid") + ",";
				    }
					var xmlHTTP = createXMLHttpRequest();
			        var xmlDOM = createXmlDom();
			        var objNode;
			        createNodeInsert(xmlDOM, objNode, "DATA");
			        createNodeAndInsertText(xmlDOM, objNode, "UNIQUEID",strItemID );
			        
			        var requestUrl = "/ezEmail/mailDeleteS.do?cmd=BDELETE";
				    
				    if (shareId != "") {
				    	requestUrl += "&shareId=" + encodeURIComponent(shareId);
				    }
			        
					xmlHTTP.open("POST", requestUrl, false);
					xmlHTTP.send(xmlDOM);
					
					if (xmlHTTP.status < 200 || xmlHTTP.status > 300)
					    alert('<spring:message code="ezEmail.t638" />');
					else {
					    alert('<spring:message code="ezEmail.t604" />');
					    listContentArry = new Array();
					    start_search();
					}
				}
		        
			}
			
			var selcheck = new Array();
			var checkMailCnt;

            function mailbox_getUserKey() {
                var userKey = "";

                $.ajax({
                    type : "POST",
                    url : "/ezEmail/getUserKey.do",
                    async : false,
                    success : function(result) {
                        userKey = result;
                    }
                });

                return userKey;
            }

			function mail_export() {
				var exportType = "MAIL";
				if (listContentArry.length == 0){
					if (!confirm(strLangLS02)) {
                        return;
                    } else {
                        if (!confirm(strLangLS03)) {
                            return;
                        } else {
                            try {
                                setTimeout(function() {
                                searchedMailExportZip();
                                }, 1000);
                            } catch (e) {
                                console.log("searchedMailExportZip error!");
                            }
                        }
                    }
				} else {
                    var mailcount = listContentArry.length;
                    var count = 0;
                    var Rows = resultTD.childNodes.item(0).childNodes.item(0).childNodes;

                    for (var i = 0; i < Rows.length; i++) {
                        if (Rows.item(i).childNodes.item(0).childNodes.item(0).checked) {
                            selcheck[count] = Rows.item(i);
                            count++;
                            checkMailCnt = count;
                        }
                    }

                    if (checkMailCnt == 0 || checkMailCnt == null) {
                        alert(strLang42);
                        return;
                    } else {

                        if (useEncryptZipForEmail == "YES") {
                            mailExportOption_onClick(exportType);
                        } else {
                            mailExport_start();
                        }
                    }
				}
				// 20200428 조진호 - 메일 리스트에서 체크박스를 이용한 행위 뒤 체크박스가 풀리도록 추가
				if (listContentArry.length > 0) {
					for (var i = 1; i <= listContentArry.length; i++) {
						document.getElementById(listContentArry[listContentArry.length - i]).children[0].children[0].checked = false;
						document.getElementById(listContentArry[listContentArry.length - i]).style.background = m_strColorDefault;
					}
				}
				try {
					if (document.getElementById("Checkbox1") != null)
						document.getElementById("Checkbox1").checked = false;
				} catch (e) {console.log(e);}
			}
		
			function mailExport_start(pwd) {
				var encryptPw = "";
				var folderIdAndMessageIdList = new Object();
				
				if (typeof pwd != "undefined") {
					encryptPw = pwd;
				}
				
				if (checkMailCnt == 1 && encryptPw == "") {
					var parameters = "url=" + encodeURIComponent(selcheck[0].getAttribute("targetURL"));
					
				    if (shareId != "") {
				    	parameters += "&shareId=" + encodeURIComponent(shareId);
				    }
					
			    	var fullpath = "/ezEmail/mailExport.do?" + parameters;

			    	AttachDownFrame.location.href = fullpath;
			        AttachDownFrame.target = "_blank";
				} else {

					for (var i = 0; i < checkMailCnt; i++) {
			    		var folderIdAndMessageId = selcheck[i].getAttribute("targetURL").split("/");
			    		
			    		if (folderIdAndMessageIdList[folderIdAndMessageId[0]] == undefined) {
			    			folderIdAndMessageIdList[folderIdAndMessageId[0]] = folderIdAndMessageId[1];
			    		} else {
			    			folderIdAndMessageIdList[folderIdAndMessageId[0]] += "," + folderIdAndMessageId[1];
			    		}
			    	}

					var requestUrl = "/ezEmail/mailExportZip.do";
				    
				    if (shareId != "") {
				    	requestUrl += "?shareId=" + encodeURIComponent(shareId);
				    }
					
					ShowMailProgress();
			    	
			    	$.ajax({
						type : "POST",
						dataType : "text",
						async : true,
						url : requestUrl,
						data : folderIdAndMessageIdList,
						complete: function(){
							HiddenMailProgress();
						},
						success: function(result){
							if (result != "") {
						    	var fullpath = "/ezEmail/downloadMailZip.do?temp=" + result + "&encryptPw=" + encryptPw;
						    	
						    	if (shareId != "") {
						    		fullpath += "&shareId=" + encodeURIComponent(shareId);
							    }
						    	
						    	AttachDownFrame.location.href = fullpath;
						        AttachDownFrame.target = "_blank";
							} else {
								alert(strLang104);
							}
						}
					});
				}
				
				checkMailCnt = 0;
			}

            function HiddenMailProgressNew() {
                $('#progressNum').text('');
                document.getElementById("mailPanel").style.display = "none";
                document.getElementById("mailPanel").style.backgroundColor = "";
                document.getElementById("MailProgress").style.backgroundColor = "";
                document.getElementById("MailProgress").style.display = "none";
                document.getElementById("cancleProgressBtn").style.display = "none";
                parent.document.getElementById("left").contentWindow.hideProgress();

              <c:if test="${!isDotNetIntegration}">
                if (window.parent.frames["left"].useBottomFrameOnly == "NO") {
                    parent.parent.document.getElementById("topFrame").contentWindow.hideProgress();
                }
              </c:if>
            }

            function ShowMailProgressNew() {
                var CurrentHeight = document.body.clientHeight;
                var CurrenWidth = document.body.clientWidth;

                document.getElementById("mailPanel").style.display = "block";
                document.getElementById("mailPanel").style.opacity = 0.5;
                document.getElementById("mailPanel").style.background = "rgba(0,0,0,0.7)";
                document.getElementById("MailProgress").style.backgroundColor = "#ffffff";
                document.getElementById("MailProgress").style.top = (CurrentHeight / 2) + "px";
                document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 150 + "px";
                // IE 지원이 안되어 기존 것 유지, 아래 사용 시 리사이즈 자동처리 됨
                //document.getElementById("MailProgress").style.top = "50%";
                //document.getElementById("MailProgress").style.left = "50%";
                //document.getElementById("MailProgress").style.transform = "translate(calc(-50% - 110px), calc(-50% - 27px))"; // lnb width/2= 110, topmenu height/2 = 27
                document.getElementById("MailProgress").style.display = "";
                document.getElementById("cancleProgressBtn").style.display = "block";
                parent.document.getElementById("left").contentWindow.showProgress();
            }

            function ShowPercent(data) {
                $('#progressNum').text('');

                if (data == "uploading"){ // 리소스 정리예정
                    $('#progressNum').text("<spring:message code='ezEmail.kyj10' />");
                } else if (data == "dec") {
                    $('#progressNum').text("<spring:message code='ezEmail.kyj11' />");
                } else if (data == "enc") {
                    $('#progressNum').text("<spring:message code='ezEmail.kyj12' />");
                } else {
                    $('#progressNum').text("<spring:message code='ezEmail.kyj01' /> : " + data + " %");
                }
            }

            var pgSetTimeout;
            var pgSetTime = 2000;
            var psSetTimeFlag = false;

			/** @callback ProgressStateHandler
			 * @param {number} progress
			 * @param {string} state
			 * @param {string} stateDescription
			 * 메일함 작업 진행상황 체크 시마다 호출되는 핸들러 */

			/** @param {boolean} act 작동 시 true, 취소 시 false
			 * @param {string} userKey
			 * @param {ProgressStateHandler} stateHandler */
			function mailboxProgressFun(act, userKey, stateHandler) { // mailboxProgress start or stop
				psSetTimeFlag = act;
				if (act) {
					mailboxProgress(userKey, stateHandler);
				} else {
					clearTimeout(pgSetTimeout);
					mailboxProgressDel(socketUserkey);
				}
			}

			/** @param {string} userKey
			 * @param {ProgressStateHandler} stateHandler */
			function mailboxProgress(userKey, stateHandler) { // get mailbox Export or Import progress
                var uk = userKey;

                pgSetTimeout = setTimeout(function getMailboxProgress() {
                    if (!psSetTimeFlag) { return; }

                    $.ajax({
                        type : "POST",
                        url : "/ezEmail/getMailboxProgress.do",
                        data : {"userKey" : uk},
                        dataType : "json",
                        async : true,
                        success : function(data) {
                            if (!psSetTimeFlag) { return; }
                            var pg = data.progress;

                            if (pg > -1 && pg <= 100) {
                                ShowPercent(pg);
                            }
                            if (pg < 100) {
                                setTimeout(getMailboxProgress, pgSetTime);
                            }

							if (stateHandler) {
								stateHandler(pg, data.state, data.stateDescription);
							}
                        }, error : function(e) {
                            alert("error. " + e.status);
                        }
                    });
                }, pgSetTime)
            }

            function mailboxProgressDel(userKey) {
                $.ajax({
                    type : "POST",
                    url : "/ezEmail/delMailboxProgress.do",
                    data : {"userKey" : userKey}
                });
            }

            function cancleProgress(){
                HiddenMailProgressNew();
                mailboxProgressFun(false);
                // webSocket.close();
                location.reload();
            }

			function window_onbeforeprint()
			{
				normalblock.style.display = "none";
			}
		
			function window_onafterprint()
			{
				normalblock.style.display = "block";
			}
		    function HiddenContextMenu() {
		        document.getElementById("mailPanel").style.display = "none";
		        document.getElementById("ContextMenuDiv").style.display = "none";
		    }
		    function ContextMenuHidden() {
		    	if (document.getElementById("ContextMenuDiv") == null ){
		    		return;
		    	}
		        if (document.getElementById("ContextMenuDiv").style.display == "")
		            HiddenContextMenu();
		    }
		
		    var usepostDate = false;
		    function DateSearch_Click() {
		        if(usepostDate){
		            usepostDate = false;
		            $("#Sdatepicker").datepicker('disable');
		            $("#Edatepicker").datepicker('disable');
		        }
		        else {
		            usepostDate = true;
		            $("#Sdatepicker").datepicker('enable');
		            $("#Edatepicker").datepicker('enable');
		        }
		    }
		
		    var p_ListOrderObject;
		    var p_ListOrderOption;
		    var FirstClick = false;
		    function event_HeaderClick(obj) {
		        if (p_ListOrderObject != null) {
		            FirstClick = false;
		            if (p_ListOrderObject.childNodes.length > 1 && p_ListOrderObject.childNodes[1].nodeName == "IMG")
		                p_ListOrderObject.childNodes.item(1).outerHTML = "";
		        }
		        else
		            FirstClick = true;
		        p_ListOrderObject = obj;
		        p_ListOrderOption = p_ListOrderObject.getAttribute("orderoption");
		        if (p_ListOrderOption == "DESC")
		            p_ListOrderOption = "ASC";
		        else if (p_ListOrderOption == "ASC")
		            p_ListOrderOption = "DESC";
		        else
		            p_ListOrderOption = "DESC";
		
		        p_ListOrderObject.setAttribute("orderoption", p_ListOrderOption);
		
		        if (p_ListOrderObject.childNodes.length > 1 && p_ListOrderObject.childNodes[1].nodeName == "IMG") {
		            if (p_ListOrderOption == "DESC")
		                p_ListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortdown.gif");
		            else
		                p_ListOrderObject.childNodes[1].setAttribute("src", "/images/etc/view-sortup.gif");
		        }
		        else {
		            var _HeaderSpanimg = document.createElement("IMG");
		            if (p_ListOrderOption == "DESC")
		                _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortdown.gif");
		            else
		                _HeaderSpanimg.setAttribute("src", "/images/etc/view-sortup.gif");
		
		            _HeaderSpanimg.setAttribute("align", "absmiddle");
		            obj.appendChild(_HeaderSpanimg);
		        }
		        if (!FirstClick)
		            start_search();
		    }
		    
		    function addSearch() {
				if($("#moreSearch").css("display") == "none"){   
				    $("#moreSearch").css("display", "");   
				    $("#moreSearch2").css("display", "");   
				    if (document.documentElement.clientWidth < 837) {
					    document.getElementById("resultTD").style.height = (document.documentElement.clientHeight - 444) + "px";
					} else {
					    document.getElementById("resultTD").style.height = (document.documentElement.clientHeight - 468) + "px";
					}
				} else {  
				    $("#moreSearch").css("display", "none");   
				    $("#moreSearch2").css("display", "none");   
				    document.getElementById("resultTD").style.height = (document.documentElement.clientHeight - 361) + "px";
				} 
		    }
		    
		    function changeLangeEvent(){
		    	var usepostDate = document.getElementById("selectRange").value;
				if(usepostDate == "direct"){
					document.getElementById("datepickerData").style.display = "";
				    $("#Sdatepicker").datepicker('enable');
				    $("#Edatepicker").datepicker('enable');
				} else if(usepostDate == "All"){
					document.getElementById("datepickerData").style.display = "none";
				} else {
					document.getElementById("datepickerData").style.display = "";
				    $("#Sdatepicker").datepicker('disable');
				    $("#Edatepicker").datepicker('disable');
				}
				
				var today = new Date();
				switch(usepostDate) {
					case "oneWeek":
						$("#Sdatepicker").datepicker('setDate', '-7d');
						$("#Edatepicker").datepicker('setDate', today);
					break;
					case "oneMonth":
						$("#Sdatepicker").datepicker('setDate', '-1m');
						$("#Edatepicker").datepicker('setDate', today);
					break;
					case "threeMonth":
						$("#Sdatepicker").datepicker('setDate', '-3m');
						$("#Edatepicker").datepicker('setDate', today);
					break;
					case "sixMonth":
						$("#Sdatepicker").datepicker('setDate', '-6m');
						$("#Edatepicker").datepicker('setDate', today);
					break;
					case "oneYear":
						$("#Sdatepicker").datepicker('setDate', '-12m');
						$("#Edatepicker").datepicker('setDate', today);
					break;
				}
		    }
		</script>
	</head>
	
	<body style="overflow:auto" id="theBody" class="mainbody"> 
		<span id="normalblock"> </span>
		<h1><spring:message code="ezEmail.t641" /><c:if test="${shareName != null}"> - <c:out value="${shareName}" /></c:if></h1>
		<div id="mainmenu">
			<ul>
			  <c:if test="${shareId == null || sendPermission == 'Y'}">
			  <li class="important"><span onclick="new_mail_onclick()"><spring:message code="ezEmail.t510" /></span></li>
			  <li class="important"><span onClick="reply_mail_onclick()"><spring:message code="ezEmail.t511" /></span></li>
			  <li class="important"><span onClick="all_reply_mail_onclick()"><spring:message code="ezEmail.t512" /></span></li>
			  <li class="important"><span onClick="transmission_mail_onclick()"><spring:message code="ezEmail.t513" /></span></li>
			  </c:if>
			  <!-- <li style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" alt=""></li> -->
			  <li><span onClick="mail_export()"><spring:message code="ezEmail.t378" /></span></li>
			  <c:if test="${shareId == null || deletePermission == 'Y'}">
			  <li><span onClick="move_mail_onclick()"><spring:message code="ezEmail.t482" /></span></li>
			  <li><span onClick="delete_mail()"><spring:message code="ezEmail.t156" /></span></li>
			  <li><span class="icon16 icon16_delete" onClick="deleteWork()"></span></li>
			  </c:if>
			</ul>
		</div>  
		<table class="content" style="min-width:632px"> 
			<tbody>
			<tr style="height:100%;"> 
				<th nowrap ><spring:message code="ezEmail.t642" /></th>
				<td style="width:100%, padding:8px;">
					<div style="margin: 5px; padding: 3px;">
					    <select id="select2" style="height: 25px;margin-right: 5px;">
					    	<option value="ALL"><spring:message code="ezEmail.t643" /></option>      
						    <c:forEach var="folderName" items="${topLevelFolderNames}" varStatus="status">
						    <option value="${folderName}">
								<c:choose>
									<c:when test="${folderName eq 'INBOX'}">
										<spring:message code="ezEmail.t644" />
									</c:when>
									<c:when test="${folderName eq 'Sent'}">
										<spring:message code="ezEmail.t645" />
									</c:when>
									<c:when test="${folderName eq 'Drafts'}">
										<spring:message code="ezEmail.t646" />
									</c:when>
									<c:when test="${folderName eq 'Trash'}">
										<spring:message code="ezEmail.t647" />
									</c:when>
									<c:when test="${folderName eq 'Personal folder'}">
										<spring:message code="ezEmail.t648" />
									</c:when>
									<c:otherwise>
										${folderName}
									</c:otherwise>
								</c:choose>      	
						    </option>
						    </c:forEach>
					    </select>
				    	<input name="keyword" id="keyword" style="vertical-align: top; display: none;" onkeyup="return search_keypress(event)">
				    	<input name="prekeyword" id="ALL" style="vertical-align: top;height:25px; margin-right:5px;" onkeyup="return search_keypress(event)" placeholder=<spring:message code="ezEmail.t641" />>
				    	<a class="imgbtn imgbck" style="margin-left: 4px; height: 22px;">
					    	<span onclick="addSearch()" style="line-height: 22px; height: 22px;"><spring:message code="ezEmail.pyy02" /></span>
				    	</a>
			    	</div>
			    </td> 
			</tr>
			<tr style="height:100%;display:none;" id="moreSearch" > 
				<th nowrap><spring:message code="ezEmail.t642" /></th>
				<td style="width:100%, padding:8px;" >
					<div class="" style="margin-left: 1px;padding: 0px 3px 3px;margin-top: 3px;">
						<label for="and"><input class="optRdo" style="margin-top: 0px;" type="radio" name="andor" id="and" value="and" checked><span class="optSpan">AND</span></label>
						<label for="or"><input class="optRdo" style="margin-top: 0px;" type="radio" name="andor" id="or" value="or"><span class="optSpan">OR</span></label>
					</div>
			    	<div style="margin-bottom: 2px;margin-left: 5px; padding: 0px 3px 3px 3px;">
						<div style="display: inline-block; margin-right: 5px; margin-top:2px;">
							<select name="select" class="text" id="selectDetail1" style="height: 25px;margin-right: 5px;width: 86px;">
								<option selected value="SUBJECT"><spring:message code="ezEmail.t98" /></option> 
								<option value="CONTENT"><spring:message code="ezEmail.t649" /></option> 
								<option value="FROM"><spring:message code="ezEmail.t161" /></option> 
								<option value="RECEIVE"><spring:message code="ezEmail.t651" /></option> 
								<option value="FILE"><spring:message code="ezEmail.pyy12" /></option> 
							</select>
							<input name="prekeyword" id="prekeywordDetail1" style="vertical-align: top;height: 25px;" onkeyup="return search_keypress(event)">
						</div>
						<div style="display: inline-block; margin-right: 5px; margin-top:2px;">
							<select name="select" class="text" id="selectDetail2" style="height: 25px;margin-right: 3px;width: 86px;">
								<option value="SUBJECT"><spring:message code="ezEmail.t98" /></option> 
								<option selected value="CONTENT"><spring:message code="ezEmail.t649" /></option> 
								<option value="FROM"><spring:message code="ezEmail.t161" /></option> 
								<option value="RECEIVE"><spring:message code="ezEmail.t651" /></option> 
								<option value="FILE"><spring:message code="ezEmail.pyy12" /></option> 
	 						</select>
	 						<input name="prekeyword" id="prekeywordDetail2" style="vertical-align: top;height:25px" onkeyup="return search_keypress(event)">
	 					</div>
	 					<div style="display: inline-block;margin-right: 5px; margin-top:2px;">
	 						<select name="select" class="text" id="selectDetail3" style="height: 25px;margin-right: 3px;width: 86px;">
								<option value="SUBJECT"><spring:message code="ezEmail.t98" /></option> 
								<option value="CONTENT"><spring:message code="ezEmail.t649" /></option> 
								<option selected value="FROM"><spring:message code="ezEmail.t161" /></option> 
								<option value="RECEIVE"><spring:message code="ezEmail.t651" /></option> 
								<option value="FILE"><spring:message code="ezEmail.pyy12" /></option>  
						    </select>
						    <input name="prekeyword" id="prekeywordDetail3" style="vertical-align: top;height:25px" onkeyup="return search_keypress(event)">
						</div>
				    </div>
			    </td> 
			</tr>
			<!--  첨부파일 유무 -->
			<tr id="moreSearch2" style="display:none;">
		     	<th><spring:message code="ezEmail.pyy13" /></th>	
			    <td style="height: 40px;">
			    	<div class="" style="/* margin-bottom: 2px; */margin-left: 1px;padding: 0px 3px 3px;margin-top: 3px;">
						<label for="all"><input class="optRdo" style="margin-top: 0px;" type="radio" id="all" name="attachment" value="all" checked>
							<span class="optSpan"><spring:message code="ezEmail.pyy14" /></span></label>
						<label for="contain"><input class="optRdo" style="margin-top: 0px;" type="radio" id="contain" name="attachment" value="contain">
							<span class="optSpan"><spring:message code="ezEmail.pyy15" /></span></label>
						<label for="Ncontain"><input class="optRdo" style="margin-top: 0px;" type="radio" id="Ncontain" name="attachment" value="Ncontain">
							<span class="optSpan"><spring:message code="ezEmail.pyy16" /></span></label>
					</div>
			    </td>
			</tr>
			<!--  검색기간 -->
			<tr>
		     	<th><spring:message code="ezEmail.t653" /></th>	
			    <td style="height: 40px;">
			    	<div style="margin: 0px 5px 0px 5px;padding: 3px;">
						<select name="select" class="text" id="selectRange" onchange="changeLangeEvent()" style="height: 25px;margin-right: 5px;width: 86px;">
							<option value="oneWeek" <c:if test="${mailSearchPeriod == 'oneWeek'}">selected</c:if>><spring:message code="ezEmail.pyy17" /></option> 
							<option value="oneMonth" <c:if test="${mailSearchPeriod == 'oneMonth'}">selected</c:if>><spring:message code="ezEmail.pyy18" /></option> 
							<option value="threeMonth" <c:if test="${mailSearchPeriod == 'threeMonth'}">selected</c:if>><spring:message code="ezEmail.pyy19" /></option> 
							<option value="sixMonth" <c:if test="${mailSearchPeriod == 'sixMonth'}">selected</c:if>><spring:message code="ezEmail.ls001" /></option>
							<option value="oneYear" <c:if test="${mailSearchPeriod == 'oneYear'}">selected</c:if>><spring:message code="ezEmail.ls002" /></option>
							<option value="All">ALL</option>
							<option value="direct"><spring:message code="ezEmail.pyy20" /></option> 
						</select>
				    	<span id="datepickerData" style="display:none;"><input type="text" id="Sdatepicker" style="width:80px;text-align:center;margin-top:-5px;" readonly> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center;margin-top:-5px;" readonly></span>
			    	</div>
			    </td>
			</tr>
		</tbody></table>
		<div class="btnposition">
			<ul class="btnpositionUL" style="list-style: none;">
				<li class="on">
					<a class="imgbtn" style="height: 30px; vertical-align: middle;">
						<span onclick="set_searchKey()" style="height: 30px; vertical-align: middle; line-height: 30px;" onkeyup="return search_keypress(event)">
							<spring:message code="ezEmail.t37" />
						</span>
					</a>
				</li>
			</ul>
		</div>
		<h2 class="h2_dot"><spring:message code="ezEmail.t655" /><span id="resultCount"></span></h2>
		    
		<div id="printblock"> 
			<table id="mailHeader" class="mainlist" style="width:100%;table-layout:fixed;" >
				<tr> 
			        <th style="width: 26px; padding: 0px; color: black;padding-left:3px;" align="center" nowrap title><input type="checkbox" onClick="check_change(this)" id="Checkbox1"></th>
			        <th style="width: 24px; padding: 0px; color: black;padding-left:3px;cursor:pointer" align="center" nowrap title onclick="event_HeaderClick(this)" porp="importance" orderoption="ASC" ><img src="/images/ImgIcon/view-importance.gif" border="0"></th>
			        <th style="width: 26px; padding: 0px; color: black;cursor:pointer" align="center" nowrap title onclick="event_HeaderClick(this)" porp="view" orderoption="ASC"><img src="/images/ImgIcon/view-document.gif" border="0"></th>
			        <th style="width: 26px; padding: 0px; color: black;padding-left:1px;cursor:pointer" align="center" nowrap title onclick="event_HeaderClick(this)" porp="flag" orderoption="ASC"><img src="/images/ImgIcon/icon-flag.gif" border="0"></th>
			        <th style="width: 15px; padding: 0px; color: black;padding-left:4px;cursor:pointer" align="center" nowrap title onclick="event_HeaderClick(this)" porp="attach" orderoption="ASC"><img src="/images/newAttach.gif" border="0"></th>
					<th style="width:101px;cursor:pointer" align="left" valign="center" id="tofromname" onclick="event_HeaderClick(this)" porp="from" orderoption="ASC"><spring:message code="ezEmail.t656" /></th> 
					<th style="width:100%;cursor:pointer;overflow: hidden; text-overflow: ellipsis; white-space: nowrap;"  align="left" onclick="event_HeaderClick(this)" porp="subject" orderoption="ASC"><spring:message code="ezEmail.t556" /></th> 
					<th style="width:200px;cursor:pointer" align="left" id="tofromdate" onclick="event_HeaderClick(this)" porp="recevdate" orderoption="ASC"><spring:message code="ezEmail.t657" /></th> 
					<th style="width:120px;" align="left"><spring:message code="ezEmail.t658" /></th> 
					<th style="width:50px;cursor:pointer" align="left" onclick="event_HeaderClick(this)" porp="size" orderoption="ASC"><spring:message code="ezEmail.t617" /></th> 
				</tr> 
			</table>
			<div id="resultTD" style="height:600px; overflow-y:auto;" curPage="1" MaxPage="0" MaxCount="0">
			</div>
		</div>
		<div id="tblPageRayer" style="width:470px; margin:6px auto;"></div>
		
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" onclick="ContextMenuHidden();" ></div>
            <div style="width:200px; padding:20px 0; border-radius:8px; text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
                <img src="/images/email/progress_img.gif"/>
		    <div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
            <a class="btnposition" id="cancleProgressBtn" style="display: none; padding-top: 10px; width: 50px; height:20px;
                cursor:pointer; margin:0 auto;" onclick="cancleProgress();">
            <input type="button" value="<spring:message code="ezEmail.t39" />"/></a>
		</div>
		<div style="border:1px solid gray;width:450px;position:absolute;background-color:#ffffff;z-index:8000;text-align:center;display:none;" id="progressviewerRayer">
		    <iframe src="<spring:message code='main.kms4' />" style="width:450px;height:170px;border:none" id="progressviewer"></iframe>
		</div>
		<script type="text/javascript">
		    selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display:none"></iframe>
		<div class="layerpopup"  style="z-index: 10000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>