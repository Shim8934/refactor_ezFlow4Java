<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>mail_filter</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/newMail_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/Newemail.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript">
			var mailAddressSearchOrder = "${mailAddressSearchOrder}";
			var mailAddressCount = "";
			var folderList = '${folderList}';
			var selectFolderName = "";
			var selectFolderId = "";
			var selectFolderNameSpl = "";
			var shareId = "${shareId}";
			var trashBoxURL = "${pDeleteBoxID}";
			var g_firstOpen = true;
			var CurrentHeight = 0;
		    var CurrenWidth = 0;
		    var protocol = window.location.protocol;
			var useEncryptZipForEmail = "${useEncryptZipForEmail}";
			var host = defineHost(protocol) + window.location.host + '/websocket/${userId}';
			var userId = '${userId}';
			var folderDep = "";
			var dec = "decrypt";
			var uploading = "uploading";
			
			function defineHost(protocol){
	    		var host = "";

	    		if (protocol == "https:") {
			    	host = 'wss://';
			    } else {
			    	host = 'ws://';
			    }
	    		
		    	return host;
		    }
			document.onselectstart = function() {
				return false;
			};
			$(document).ready(function() { 
				if (navigator.userAgent.indexOf('Firefox') != -1) {
					document.body.style.MozUserSelect = 'none';
					document.body.style.WebkitUserSelect = 'none';
					document.body.style.khtmlUserSelect = 'none';
					document.body.style.oUserSelect = 'none';
					document.body.style.UserSelect = 'none';
				}
				requestFolderList();
			});
			
			function requestFolderList(){
				$.ajax({
					type : "GET",
					dataType : "text",
					async : true,
					url : "/ezEmail/folderQuotaList.do",
					cache: false,
					data : { userId : userId, shareId : shareId },
					success : function(result) {
						folderList = JSON.parse(result);
		 				makeMailFolderList(folderList);
						detailView(shareId);
					},
					error : function(error) {
						console.log(error);
					}
				});
			}
			
			function makeMailFolderList(){
				CurrentHeight = document.body.clientHeight;
		        CurrenWidth = document.body.clientWidth;
				var allFolderCount = folderList.length;
				var allunReadCount = 0;
				var allMailCount = 0;
				var _html = "";
				try {
					_html += '<tr id="header">' 
					+ '<th style="width:300px;" ><spring:message code="ezEmail.pyy03" /></th>'
					+ '<th style="width:100px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:center;"><spring:message code="ezEmail.pyy04" /></th>' 
					+ '<th style="width:180px;min-width:120px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:center;"><spring:message code="ezEmail.pyy05" /></th>'
					+ '<th style="width:400px;min-width:400px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:center;"><spring:message code="ezEmail.pyy06" /></th>'  
					+ '</tr>';
			    	
			    	for (var i = 0; i < folderList.length; i++) {
		    			var mailboxNameSpl = folderList[i].mailboxChangeName.split(".");	
		    			var imgLength = "";
		    			if (mailboxNameSpl.length > 1){
		    				imgLength += '<span class="folderdepth_' + mailboxNameSpl.length + '"> </span>';
		    			}
		    			var y = Number(mailboxNameSpl["length"])-1;
		    			var mailbox = folderList[i].mailboxId;
		    			var folderName = folderList[i].mailboxName;
		    			imgLength += mailboxNameSpl[y];
			    		_html += "<tr id='mailBoxId_" + folderList[i].mailboxId + "' data-id='" + mailbox
			    			+ "' data-caption='" + mailboxNameSpl[y] + "' data-realFolderName='"+folderName+"' data-folderMailCnt='"+folderList[i].mailCount+"' data-folderDep='" + mailboxNameSpl.length + "'> ";
			    		_html += "<td style='width:100%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;'>" 
			    			+ imgLength + "</td>";
			    		_html += "<td style='width:100%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;text-align:center;'>" 
			    			+ folderList[i].notReadCount + "/" + folderList[i].mailCount + "</td>";
			    		_html += "<td style='white-space:nowrap; text-overflow:ellipsis; overflow:hidden;text-align:center;'>" 
			    			+ folderList[i].mailboxQuota + "</td>";
			    			
			    		if (mailboxNameSpl["length"] > 1){
				    		_html += "<td style='width:100%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;'>" 
				    			+ "<a class='imgbtn imgbck mr3' style='margin-left:3px'><span style='text-align:center;' onclick=folderIdSelect('"+mailbox+"');mailbox_exportUp();><spring:message code='ezEmail.kyj04' /></span></a>"
				    			+ "<a class='imgbtn imgbck mr3' style='margin-left:3px'><span style='text-align:center;' onclick=folderIdSelect('"+mailbox+"');mail_import_onclick();><spring:message code='ezEmail.kyj05' /></span></a>" // 메일 가져오기
				    			+ "<a class='imgbtn imgbck mr3' style='margin-left:3px'><span style='text-align:center;' onclick=folderIdSelect('"+mailbox+"');add_onclickUp();><spring:message code='ezEmail.t308' /></span></a>"
				    			+ "<a class='imgbtn imgbck mr3' style='margin-left:3px'><span style='text-align:center;' onclick=folderIdSelect('"+mailbox+"');modify_onclickUp(); "
				    				+ "folderIdSelect('"+ mailbox +"');><spring:message code='ezEmail.t149' /></span></a>"
				    			+ "<a class='imgbtn imgbck mr3' style='margin-left:3px'><span style='text-align:center;' onclick=folderIdSelect('"+mailbox+"');delete_onclick();><spring:message code='ezEmail.pyy08' /></span></a>"
				    			+ "<a class='imgbtn imgbck mr3' style='margin-left:3px'><span style='text-align:center;' onclick=folderIdSelect('"+mailbox+"');delete_mail_onclick();><spring:message code='ezEmail.pyy09' /></span></a>"
				    			+ "<a class='imgbtn imgbck mr3' style='margin-left:3px'><span style='text-align:center;' onclick=folderIdSelect('"+mailbox+"');folder_ReadChange('R');><spring:message code='ezEmail.jyh01' /></span></a></td></tr>";
			    		} else {
							_html += "<td style='width:100%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;'>"
				    			+ "<a class='imgbtn imgbck mr3' style='margin-left:3px'><span style='text-align:center;' onclick=folderIdSelect('"+mailbox+"');mailbox_exportUp();><spring:message code='ezEmail.kyj04' /></span></a>"
				    			+ "<a class='imgbtn imgbck mr3' style='margin-left:3px'><span style='text-align:center;' onclick=folderIdSelect('"+mailbox+"');mail_import_onclick();><spring:message code='ezEmail.kyj05' /></span></a>" // 메일 가져오기
				    			+ "<a class='imgbtn imgbck mr3' style='margin-left:3px'><span style='text-align:center;' onclick=folderIdSelect('"+mailbox+"');add_onclickUp();><spring:message code='ezEmail.t308' /></span></a>"
				    			+ "<a class='imgbtn imgbck mr3' style='margin-left:3px'><span style='text-align:center;' onclick=folderIdSelect('"+mailbox+"');delete_mail_onclick();><spring:message code='ezEmail.pyy09' /></span></a>"
				    			+ "<a class='imgbtn imgbck mr3' style='margin-left:3px'><span style='text-align:center;' onclick=folderIdSelect('"+mailbox+"');folder_ReadChange('R');><spring:message code='ezEmail.jyh01' /></span></a></td></tr>";
			    		}
			    		allunReadCount += Number(folderList[i].notReadCount); 
			    		allMailCount += Number(folderList[i].mailCount);   
			    	}
			    	_html += "<tr>";	
			    	_html +="<td style='white-space:nowrap; text-overflow:ellipsis; overflow:hidden;text-align:center;'>"
			    		+ "<spring:message code='ezEmail.pyy07' />&nbsp;" + allFolderCount + "</td>";
			    	_html +="<td style='white-space:nowrap; text-overflow:ellipsis; overflow:hidden;text-align:center;'>"
			    		+ allunReadCount + "/" + allMailCount + "</td>";
			    	_html +="<td style='white-space:nowrap; text-overflow:ellipsis; overflow:hidden;text-align:center;' colspan='2'>"
			    		+ "<div class='graph_used'><dl><dt id='capacity' ></dt><dt><span class='color' id='used_cap'></span><span id='used_per'></span></dt>"
// 			    		+ "<spring:message code='main.t00045' /><span class='mail_spaceText'>&nbsp;<span class='userPer' id='usePer'></span>"
			    		+ "<dd class='graph' id='graphBar' style='display:none;'><span class='bar' id='bar'></span></dd><dd class='graph_text' id='graph_text'></dd></div></td></tr>";
			    		
			    	document.getElementById("tbody").innerHTML = _html;
				} catch (e) {
		            document.getElementById("tbody").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'>" + strLang202 + "</td></tr></table>";
		            mailAddressCount = 0;
		            console.log(e);
				}
			}
			
			function folderNameSelect(id){
				var ele = document.getElementById("mailBoxId_" + id);
				selectFolderName = ele.getAttribute('data-realFolderName');
			}
			function folderIdSelect(folderId){
				selectFolderId = folderId;
				var splFolder = "mailBoxId_" + folderId;
				var ele = document.getElementById(splFolder);
				selectFolderNameSpl = ele.getAttribute('data-caption');
				selectFolderName = ele.getAttribute('data-realFolderName');
				folderDep = ele.getAttribute('data-folderDep');
			}
			
			function mailbox_exportUp(){
				var splFolder = "mailBoxId_" + selectFolderId;
				var ele = document.getElementById(splFolder);
				var folderMailCnt = ele.getAttribute('data-folderMailCnt');
				if (folderMailCnt === null || typeof folderMailCnt === "undefined") {
					console.log('folderTotalCount is null or undefined');
					return;
				} else if (folderMailCnt < 1) {
					alert("<spring:message code='ezEmail.kyj13' />");
					return;
				}

				parent.parent.document.getElementsByName("right")[0].contentWindow
				.DivPopUpShow(500, 300, "/ezEmail/folderExportPeriod.do?"
						+ "folderName=" + encodeURIComponent(selectFolderName)
						+ "&folderNameSql=" + encodeURIComponent(selectFolderNameSpl)
						+ "&folderMailCnt=" + (folderMailCnt));
				//parent.parent.document.getElementsByName("right")[0].contentWindow.mailbox_export(selectFolderName, selectFolderNameSpl, folderMailCnt);
			}
			function add_onclickUp(){
				// 하위 편지함 5개까지 생성가능 top편지함의 하위편지함이 1레벨로 생각
                if (folderDep > 5) {
                   alert("<spring:message code='ezEmail.ksaMailBox01' />");
                   return;
                }
				parent.parent.document.getElementsByName("right")[0].contentWindow.add_onclick(selectFolderName, selectFolderNameSpl);
			}
			function modify_onclickUp(){
				parent.parent.document.getElementsByName("right")[0].contentWindow.modify_onclick(selectFolderName, selectFolderNameSpl);
			}
		    
		    function delete_onclick() {
		    	ShowMailProgress();
		    	if (selectFolderName == -1) {
		            alert("<spring:message code='ezEmail.t158' />");
		            HiddenMailProgress();
		            return;
		        }
		        if (checkTopLevelFolder(selectFolderName)) {
		        	alert("<spring:message code='ezEmail.t460' />");
		        	HiddenMailProgress();
		            return;
		        }
		    	
		        
		        var deleteURL = selectFolderName;
		        
		        //편지함 영구삭제
		        if (deleteURL.indexOf(trashBoxURL) == 0) {
		            if (confirm("<spring:message code='ezEmail.t461' />")) {
		            	var result = mail_make_folder("DEL", deleteURL, "", "");
		            	
		                if (result != "OK") {
		                    alert("<spring:message code='ezEmail.t462' />");
		                    HiddenMailProgress();
		                    return;
		                }
		            }
		        }
		        //편지함 지운편지함으로 이동
		        else {
		            if (confirm("<spring:message code='ezEmail.t463' />")) {
		                var result = mail_make_folder("MOVE", deleteURL, trashBoxURL, "");
		                
		                if (result != "OK") {
			            	if (result == "ALREADY_EXISTS") {
			            		alert("<spring:message code='ezEmail.lhm04' />");
			            	} else {
			            		alert("<spring:message code='ezEmail.t464' />");
			            	}
			            	HiddenMailProgress();
			                return;
			            }
		                
		            }
		        }
		        requestFolderList();
		        HiddenMailProgress();
		        if(parent.parent.frames["left"].configFlag == "false") {
		        	parent.parent.frames["left"].mailbox_treeview_reload();
		        }
		    }
		    // 메일함 비우기
		    function delete_mail_onclick() {
		        var trashBoxURL = "${pDeleteBoxID}";
		        var deleteURL = selectFolderName;
		        ShowMailProgress();
		        
		        var mailConfigFrame = parent.parent.document.getElementsByName("right")[0].contentWindow;
		        mailConfigFrame.showDim();
		        
		        
		      	//지운편지함의 메일 영구삭제
		        if (deleteURL == trashBoxURL) {
		            if (confirm("<spring:message code='ezEmail.t470' />")) {
		                delete_mail(deleteURL, true, "");
		            } else {
		            	HiddenMailProgress();
				        mailConfigFrame.hiddenDim();
		            }
		        }
		      	//편지함의 메일 지운편지함으로 이동
		        else {
		            if (confirm("<spring:message code='ezEmail.t475' />")) {
		                delete_mail(deleteURL, false, trashBoxURL);
		            } else {
		            	HiddenMailProgress();
				        mailConfigFrame.hiddenDim();
		            }
		        }
		    }
		 	// 메일함 비우기
		    function delete_mail(szURL, bDelete, destURL) {
		    	xmlHTTP2 = createXMLHttpRequest();
		        var xmlDOM = createXmlDom();
		        var objNode;
		        
		        if (bDelete) {
		            deltype = "MAILREALDEL";
		        } else {
		            deltype = "MAILDEL";
		        }
		        
		        createNodeInsert(xmlDOM, objNode, "DATA");
		        createNodeAndInsertText(xmlDOM, objNode, "URL", szURL);
		        createNodeAndInsertText(xmlDOM, objNode, "DESTINATION", destURL);
		        createNodeAndInsertText(xmlDOM, objNode, "CMD", deltype);
		        
		        var requestUrl = "/ezEmail/mailMakeFolder.do";
		        
		        if (shareId != "") {
		        	requestUrl += "?shareId=" + encodeURIComponent(shareId);
	            }
		        
		        xmlHTTP2.open("POST", requestUrl, true);
		        xmlHTTP2.onreadystatechange = delete_mail_complete;
		        xmlHTTP2.send(xmlDOM);
		        
		        
		    }
		 	
		    function delete_mail_complete() {
				if (xmlHTTP2 != null && deltype != null && xmlHTTP2.readyState == 4) {
					var href =selectFolderName;
					var mailConfigFrame = parent.parent.document.getElementsByName("right")[0].contentWindow;
					
		            //지운편지함의 메일 영구삭제
		            if (deltype == "MAILREALDEL") {
		            	if (xmlHTTP2.status >= 200 && xmlHTTP2.status < 300) {
							if (xmlHTTP2.responseText == "OK") {
								alert("<spring:message code='ezEmail.t473' />");

					    	} else {
					    		alert("<spring:message code='ezEmail.t472' />");
					    	}
					    } else {
					    	alert("<spring:message code='ezEmail.t472' />");
					    }
		            }
		            //편지함의 메일 지운편지함으로 이동
					else {
						if (xmlHTTP2.status >= 200 && xmlHTTP2.status < 300) {
							if (xmlHTTP2.responseText == "OK" || xmlHTTP2.responseText === "MAIL_NOT_EXISTS") {
								// 이미 비워져있는 상태도 성공 처리
								alert("<spring:message code='ezEmail.t478' />");
		            		} else if (xmlHTTP2.responseText.indexOf("NO COPY processing failed.") > -1) {
		            			alert(strLang241);
		            		} else {
		            			alert("<spring:message code='ezEmail.t477' />");
		            		}
						} else {
		            		alert("<spring:message code='ezEmail.t477' />");
		            	}
		            }
		            
		        }
				requestFolderList();
				HiddenMailProgress();
				mailConfigFrame.hiddenDim();
		    }
            
		    
		  //편지함 모두 읽기
		    function folder_ReadChange(pGubun){
		    	ShowMailProgress();
		    	var xmlHTTP = createXMLHttpRequest();
	            var href = selectFolderName
	            var isRead = "FALSE";
	            
	            if (pGubun == "R") {
	            	isRead = "TRUE";
	            }
	            
	            var requestUrl = "/ezEmail/folderSetReadChange.do?url=" + encodeURIComponent(href) + "&isRead=" + isRead;
	            
	            if (shareId != "") {
	            	requestUrl += "&shareId=" + encodeURIComponent(shareId);
	            }
	            try {
		            xmlHTTP.open("POST",requestUrl, false);
		            xmlHTTP.send();
	            } catch(e){
	            	console.log(e);
	            }
	            requestFolderList();
	            HiddenMailProgress();
	            if(parent.parent.frames["left"].configFlag == "false") {
		        	parent.parent.frames["left"].mailbox_treeview_reload();
		        }
		    }
		  
		 
            
			function mailbox_delete() {
				ShowMailProgress();
			   try {
		    	   var folderPath = selectFolderName;
		    	   
		    	   var trashBoxURL = "${pDeleteBoxID}";
			        
			      	//지운편지함의 메일 영구삭제
			        if (folderPath == trashBoxURL) {
			            if (confirm("<spring:message code='ezEmail.t470' />")) {
				            if (confirm("<spring:message code='ezEmail.ksa03' />")) {
				                delete_mail(folderPath, true, "");
				            }
			            }
			        }
			      	//편지함의 메일 지운편지함으로 이동  
			        else {
			            if (confirm("<spring:message code='ezEmail.t475' />")) {
			            	if (confirm("<spring:message code='ezEmail.ksa04' />")) {
				                delete_mail(folderPath, false, trashBoxURL);	
			            	}
			            }
			        }
			      	
			   } catch (e) {
				   console.log("mailbox_delete error!");
			   }
		   }
           
		    function HiddenContextMenu() {
		    	parent.frames["right"].parent.frames["left"].document.getElementById("mailPanel").style.display = "none";
		    }
		    function ContextMenuHidden() {
		        
		        if (parent.parent.frames["left"].document.getElementById("mailPanel").style.display == "")
		        	HiddenContextMenu();
		        
		        if (parent.parent.frames["left"].document.getElementById("folderMenuDiv").style.display == "") {
		        	parent.parent.frames["left"].document.getElementById("mailPanel").style.display = "none";
		        	parent.parent.frames["left"].document.getElementById("folderMenuDiv").style.display = "none";
		        }
		    }
		    
		 // 2016-12-28 이효민 추가
			function checkTopLevelFolder(nodeIdx) {
				var folderUrl = nodeIdx;
				if (folderUrl.indexOf(".") > -1) {
					return false;
				} else {
					return true;
				}
			}
		 
			 //TODO: copy일때 비동기로 처리하도록 함수 따로 만들어야함.
		    function mail_make_folder(szCMD, szURL, destURL, szName) {
		    	var xmlHTTP = createXMLHttpRequest();
		        var xmlDOM = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDOM, objNode, "DATA");
		        createNodeAndInsertText(xmlDOM, objNode, "CMD", szCMD);
		        createNodeAndInsertText(xmlDOM, objNode, "URL", szURL);
		        createNodeAndInsertText(xmlDOM, objNode, "DESTINATION", destURL);
		        createNodeAndInsertText(xmlDOM, objNode, "NAME", szName);
		        
				var requestUrl = "/ezEmail/mailMakeFolder.do";
		        
		        if (shareId != "") {
		        	requestUrl += "?shareId=" + encodeURIComponent(shareId);
	            }
		        
		        xmlHTTP.open("POST", requestUrl, false);
		        xmlHTTP.send(xmlDOM);
		        
		        if (xmlHTTP.status >= 200 && xmlHTTP.status < 300) {
		            return xmlHTTP.responseText;
		        } else {
		            return "ERROR";
		        }
		    }
			
		 // 수정 수아 재은
	        function detailView(shareId) {
	        	
	        	var requestUrl = "/ezEmail/mailGetUse.do";
	        	
	        	if (typeof(shareId) != "undefined" && shareId != "") {
	            	requestUrl += "?shareId=" + encodeURIComponent(shareId);
	            }
	        	
                $.ajax({
                    url: requestUrl,
                    type: "POST",
                    dataType: "xml",
                    error : function(error) {
                        console.log(error);
                    },
                    success : function(xml_http) {
                       var result = xml_http;
                 	   var totalVolume = ""; 
                 	   var useVolume = "";
                 	   var percent = "";
                 	            
                 	   if (CrossYN()) { 
                 	        totalVolume = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[0].textContent;
                 	        useVolume = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[1].textContent; 
                 	        percent = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].textContent;                    
                 	   } else { 
                 	        totalVolume = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[0].text;
                 	        useVolume = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[1].text; 
                 	        percent = GetChildNodes(SelectNodes(result, "DATA/ROW")[0])[2].text;
                 	   }

                 	   //뿌려주기
                 	   $("#bar").css({
                 	       "width" : percent + "%"
                 	   });                 	                   
                 	   //$("#useVol").html(useVolume + "<span>/ " + totalVolume + "</span>");
                 	   $("#capacity").text("<spring:message code='main.t00045' />");
                 	   $("#used_cap").text(useVolume);
                 	   $("#used_per").text("("+percent+"%)");
                 	   $("#graphBar").css("display","");
                 	   $("#graph_text").text(totalVolume);
                 	   
                 	   //용량 체크(색깔로)
                 	   if (percent >= 80) {
                 		  $("#bar").addClass("danger");
                 	   } else if (percent >= 70) {
                 		  $("#bar").addClass("warning");
                 	   } else {
							$("#bar").removeClass();
							$("#bar").addClass("bar");
                 	   }               		   
                    }
                });        	    
	        }	        
		 
		// 2024.08.12 한슬기 : 메일 환경설정 > 편지함관리 > 가져오기 추가
		function mail_import_onclick() {
			document.getElementById("file1").click();
		}
		 
		function mailbox_attach_import(pwd, tempId, userkey){
			// 파일 포맷 체크
			if (pwd == "" || typeof pwd == "undefined") {
        		tempname =	document.importMailboxform.file1.value;
				
        		if (tempname == "") {
					return;
				}
        		
				var last = tempname.split(".").length;
				var extension = tempname.split(".")[last - 1];

				if (extension.toUpperCase() != "ZIP") {
					// 파일의 포맷이 올바르지 않습니다.
					alert("<spring:message code='ezEmail.lhm34' />");

					return;
				}
			}
			
			var splFolder = "mailBoxId_" + selectFolderId;
			var element = document.getElementById(splFolder);
		
           	var folderPath = element.getAttribute("data-realfoldername");
			
			var mailConfigFrame = parent.parent.document.getElementsByName("right")[0].contentWindow;
			var frm = document.getElementById("importMailboxform");
			mailConfigFrame.mailbox_attach_import(pwd, tempId, userkey, folderPath, frm);
			
		}
		 
        function mailboxImportComplete(result, tempId, userkey) {
        	
        	var mailConfigFrame = parent.parent.document.getElementsByName("right")[0].contentWindow;
        	mailConfigFrame.HiddenMailProgressNew();
        	mailConfigFrame.mailboxProgressFun(false);
			
			if (result == "NOTSUPPORT"){ // 암호화된 파일 지원하지 않음
				alert("<spring:message code='ezEmail.kyj08' />");
				document.importMailboxform.file1.value = "";
			}
			
			if (result == "ERROR") { // 에러발생
				alert("<spring:message code='ezEmail.lhm35' />");
				document.importMailboxform.file1.value = "";
			}
			
			if (result == "ABORT") { // marformd 에러  
				alert("<spring:message code='ezEmail.kyj15' />");
				document.importMailboxform.file1.value = "";
			}
			
			if (result == "ZEROEML") { // eml파일이 없을 경우
				alert("<spring:message code='ezEmail.kyj16' />");
				document.importMailboxform.file1.value = "";
			}

			if (result == "NO_APPEND") { // 메일용량 초과시
				alert("<spring:message code='ezEmail.ksa16' />");
				document.importMailboxform.file1.value = "";
			}
			
			if (result == "OK") {
				document.importMailboxform.file1.value = "";
			}
			
			requestFolderList();
			
		}
     	// 2024.08.12 한슬기 : 메일 환경설정 > 편지함관리 > 가져오기 추가 end
		
		</script>
	</head>
	<body style="margin-left:10px;margin-right:10px;" id="mainmenu"> 
		<form method="post"> 
			<br>
		    <span class="txt">▒&nbsp; <spring:message code='ezEmail.pyy10' /></span><br />
		    <span class="txt">▒&nbsp; <spring:message code='ezEmail.pyy11' /></span><br />
			<br>
			<table class="popuplist" style="width:1000px;">
				<tbody id="tbody">
					<tr id="header"> 
						<th style="width:450px;" ><spring:message code='ezEmail.pyy03' /></th> <!-- 편지함 이름 ezEmail.pyy03 -->
						<th style="width:100px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:center;"><spring:message code='ezEmail.pyy04' /></th> <!-- 읽지않음/총메일 ezEmail.pyy04-->
						<th style="width:120px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:center;"><spring:message code='ezEmail.pyy05' /></th> <!-- 용량 ezEmail.pyy05 -->
						<th style="width:400px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:center;"><spring:message code='ezEmail.pyy06' /></th> <!-- 관리 ezEmail.pyy06 --> 
					</tr>
				</tbody>
			</table>
		</form> 
		
		<!-- 가져오기 -->
		<iframe name="importMailboxIframe" src="about:blank" style="display: none"></iframe>
		<form method="post" id="importMailboxform" name="importMailboxform" enctype="multipart/form-data" target="importMailboxIframe">
	        <input type="file" name="file1" id="file1" accept=".zip" onchange="mailbox_attach_import()" style="display: none"/>
	    </form>
		
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" onclick="" oncontextmenu="event_listContextMenuAndId(event); return false;">&nbsp;
		</div>
		
		<div style="width:200px;height:100px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
		    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
		</div>
		
		
		
	</body>
	
</html>

