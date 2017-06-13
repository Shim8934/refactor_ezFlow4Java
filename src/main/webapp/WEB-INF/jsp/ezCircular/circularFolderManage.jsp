<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>회람문서함 관리</title>
        <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="<spring:message code='main.lhm02' />" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezCircular/email_tree.js"></script>
		<script type="text/javascript" src="/js/ezEmail/Controls_cross/treeview.htc.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/string_component_utf8.js"></script>
		<script type="text/javascript" src="/js/ezEmail/js_cross/encode_component.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
			var lang = "${userinfo.lang}";
			var PostTreeView = null;
			var treeconfig = "";
			var EventCheck = false;
			var CurrentHeight = 0;
			var CurrenWidth = 0;
			
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };
		    
		    window.onunload = function () {
		        if(ReturnFunction != null)
			        ReturnFunction(EventCheck);
			}
		    
			var ReturnFunction;
			window.onload = function () {
			    CurrentHeight = document.body.clientHeight;
			    CurrenWidth = document.body.clientWidth;
			    try {
			        ReturnFunction = opener.mail_foldermanage_Cross_dialogArguments[1];
			    } catch (e) { }
                PostTreeView = new TreeView('PostTreeView', 'PostTreeView');
//                 PostTreeView.attachEvent('requestdata', requestdata);
//                 PostTreeView.attachEvent('nodedblclick', function () { PostTreeView.toggle(PostTreeView.selectedIndex()) });
                var xmlHTTP = createXMLHttpRequest();
                xmlHTTP.open("GET", "/xml/common/organtree_config2.xml", false);
                xmlHTTP.send();
                var treeconfig;
                if (CrossYN()) {
                    treeconfig = new DOMParser().parseFromString(xmlHTTP.responseText, "text/xml");
                }
                else
                    treeconfig = xmlHTTP.responseXML;

                PostTreeView.config(treeconfig);
                PostTreeView.source("<tree><nodes>" + get_childXML("", true, false) + "</nodes></tree>");
                PostTreeView.update();
            }
//             function requestdata(event) {
//                 if (!event) event = window.event;
//                 var nodeIdx = event.nodeIdx;
//                 if (typeof nodeIdx == 'undefined' && arguments.length > 0) {
//                     nodeIdx = arguments[0].nodeIdx;
//                 }
//                 var childxml = get_childXML(PostTreeView.getvalue(nodeIdx, "href"), false, false)
//                 PostTreeView.putchildxml(nodeIdx, childxml);
//             }
            
            var inputNameDlg_cross_dialogArguments = new Array();
            function add_onclick() {
// 			    if (PostTreeView.selectedIndex() == -1) {
// 			        alert("<spring:message code='ezEmail.t158' />");
// 			        return;
// 			    }
			    
			    inputNameDlg_cross_dialogArguments[0] = onclick_Complete;
			    inputNameDlg_cross_dialogArguments[1] = DivPopUpHidden;
			    inputNameDlg_cross_dialogArguments[2] = "";
			    
			    DivPopUpShow(330, 150, "/ezCircular/circularInputName.do");
			}
// 		    function add_onclick_Complete(szName) {
// 		        DivPopUpHidden();
// 		        location.reload();
// 		        if (typeof (szName) == "undefined" || szName.trim() == "") {
// 		            return;
// 		        }
// 		        else if (checkBadFolderName(szName)) {
// 		            return;
// 		        }
		        
// 		        var szURL = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
// 		        var result = mail_make_folder("NEW", szURL, "", szName);
// 		        if (result != "OK") {
// 		            if (result == "ALREADY_EXISTS") {
// 		                alert("<spring:message code='ezEmail.t456' />");
// 		            } else {
// 		                alert("<spring:message code='ezEmail.t457' />");
// 		            }
// 		            return;
// 		        }
		        
// 		        var childxml = get_childXML(PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), false, false);
//                 PostTreeView.putchildxml(PostTreeView.selectedIndex(), childxml);
                
// 		        EventCheck = true;
// 		    }
		    
		    function modify_onclick() {
		        if (PostTreeView.selectedIndex() == -1) {
		            alert("<spring:message code='ezEmail.t158' />");
		            return;
		        }
		        
		        inputNameDlg_cross_dialogArguments[0] = onclick_Complete;
		        inputNameDlg_cross_dialogArguments[1] = DivPopUpHidden;
		        inputNameDlg_cross_dialogArguments[2] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
		        
		        DivPopUpShow(330, 150, "/ezCircular/circularInputName.do");
		    }
		    
		    function onclick_Complete(szName) {
		    	DivPopUpHidden();
		        location.reload();
		    }
// 		    function modify_onclick_Complete(szName) {
// 		        DivPopUpHidden();
// 		        if (typeof (szName) == "undefined" || szName.trim() == "" || szName == PostTreeView.getvalue(PostTreeView.selectedIndex(), "caption")) {
// 		            return;
// 		        }
// 		        if (checkBadFolderName(szName)) {
// 		            return;
// 		        }

// 		        var result = mail_make_folder("MODIFY", PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), "", szName);
		        
// 		        if (result != "OK") {
// 		        	if (result == "ALREADY_EXISTS") {
// 		        		alert("<spring:message code='ezEmail.lhm05' />");
// 		        	} else {
// 		        		alert("<spring:message code='ezEmail.t459' />");
// 		        	}
// 		        	return;
// 		        }
		        
// 		        LoadAddressTree(PostTreeView.selectedIndex());
// 		        EventCheck = true;
// 		    }
		    
// 		    var mail_movecopy_cross_dialogArguments = new Array();
// 		    function move_onclick() {
// 		        if (PostTreeView.selectedIndex() == -1) {
// 		            alert("<spring:message code='ezEmail.t158' />");
// 		            return;
// 		        }
// 		        else if (checkTopLevelFolder(PostTreeView.selectedIndex())) {
// 		        	alert("<spring:message code='ezEmail.t465' />");
// 		            return;
// 		        }
		        
// 		        mail_movecopy_cross_dialogArguments[1] = move_onclick_Complete;
// 		        mail_movecopy_cross_dialogArguments[2] = DivPopUpHidden;
// 		        DivPopUpShow(320, 375,"/ezEmail/mailMoveCopy.do");
// 		    }
// 		    function move_onclick_Complete(moveUrl) {
// 		        DivPopUpHidden();
// 		        if (typeof (moveUrl) == "undefined") {
// 		            return;
// 		        }

// 		        var oldUrl = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
// 		        var szURL = moveUrl["url"];

// 		        if (moveUrl["url"] == oldUrl) {
// 		            alert("<spring:message code='ezEmail.t466' />");
// 		            return;
// 		        }

// 		        if (szURL.indexOf(oldUrl) == 0) {
// 		            alert("<spring:message code='ezEmail.t467' />");
// 		            return;
// 		        }
		        
// 		        if (moveUrl["cmd"] == "MOVE") {
// 		            var result = mail_make_folder("MOVE", oldUrl, szURL, "");
		            
// 		            if (result != "OK") {
// 		            	if (result == "ALREADY_EXISTS") {
// 		            		alert("<spring:message code='ezEmail.lhm03' />");
// 		            	} else {
// 		            		alert("<spring:message code='ezEmail.t468' />");
// 		            	}
// 		                return;
// 		            }
// 		        }
// 		        else if (moveUrl["cmd"] == "COPY") {
// 		            var result = mail_make_folder("COPY", oldUrl, szURL, "");
		            
// 		            if (result != "OK") {
// 		            	if (result == "ALREADY_EXISTS") {
// 		            		alert("<spring:message code='ezEmail.lhm03' />");
// 		            	} else if (result.indexOf("NO COPY processing failed.") > -1) {
// 		            		alert(strLang241);
// 		            	} else {
// 		            		alert("<spring:message code='ezEmail.t469' />");
// 		            	}
// 		            	return;
// 		            }
// 		        }
		        
// 		        LoadAddressTree(moveUrl["idx"]);
// 		        EventCheck = true;
// 		    }
		    
		    function delete_onclick() {
		    	if (PostTreeView.selectedIndex() == -1) {
		            alert("<spring:message code='ezEmail.t158' />");
		            return;
		        }
		    	
		        var deleteFolder = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");

				if (confirm("삭제하시겠습니까?")) {
					$.ajax({
						method : "POST",
						dataType : "text",
						async : false,
						url : "/ezCircular/circularDeleteFolder.do",
						data : {
							deleteFolder : deleteFolder 
						},
						success : function() {
							alert("삭제하였습니다.");
							location.reload();
						},
						error : function() {
							alert("에러발생");
						}
					})
				}
		    }

// 			function checkBadFolderName(szName) 
// 			{
// 				var szBadChars = /[\<\>\~\#\%\&\*\+\|\\\.\/]/g;
// 				var szChangedName = szName.replace(szBadChars, "");
// 				if(szChangedName != szName)
// 				{
// 					alert("<spring:message code='ezEmail.t479' />< ~ # % & * + | \\ . / >)<spring:message code='ezEmail.t480' />");
// 					return true;
// 				}
// 				return false;
// 			}
			
			//TODO: copy일때 비동기로 처리하도록 함수 따로 만들어야함.
// 		    function mail_make_folder(szCMD, szURL, destURL, szName) {
// 		    	var xmlHTTP = createXMLHttpRequest();
// 		        var xmlDOM = createXmlDom();
// 		        var objNode;
// 		        createNodeInsert(xmlDOM, objNode, "DATA");
// 		        createNodeAndInsertText(xmlDOM, objNode, "CMD", szCMD);
// 		        createNodeAndInsertText(xmlDOM, objNode, "URL", szURL);
// 		        createNodeAndInsertText(xmlDOM, objNode, "DESTINATION", destURL);
// 		        createNodeAndInsertText(xmlDOM, objNode, "NAME", szName);
		        
// 		        xmlHTTP.open("POST", "/ezEmail/mailMakeFolder.do", false);
// 		        xmlHTTP.send(xmlDOM);
		        
// 		        if (xmlHTTP.status >= 200 && xmlHTTP.status < 300) {
// 		            return xmlHTTP.responseText;
// 		        } else {
// 		            return "ERROR";
// 		        }
// 		    }
			
		    var xmlHTTP2 = null;
		    var deltype = null;
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
		        
		        xmlHTTP2.open("POST", "/ezEmail/mailMakeFolder.do", true);
		        xmlHTTP2.onreadystatechange = delete_mail_complete;
		        xmlHTTP2.send(xmlDOM);
		        
		        ShowMailProgress();
		    }

		    function delete_mail_complete() {
		        if (xmlHTTP2 != null && deltype != null && xmlHTTP2.readyState == 4) {
		            HiddenMailProgress();
		            
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
		            		if (xmlHTTP2.responseText == "OK") {
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
		    }
		    
// 			function LoadAddressTree(idx) {
// 		        PostTreeView.config(treeconfig);
// 		        PostTreeView.source("<tree><nodes>" + get_childXML("", true, false) + "</nodes></tree>");
// 		        PostTreeView.update();
// 		        PostTreeView.toggle(idx);
// 		    }
			
			// 2016-12-28 이효민 추가
// 			function checkTopLevelFolder(nodeIdx) {
// 				var folderUrl = PostTreeView.getvalue(nodeIdx, "href");
// 				if (folderUrl.indexOf(".") > -1) {
// 					return false;
// 				} else {
// 					return true;
// 				}
// 			}
			
// 			function HiddenMailProgress() {
// 			    document.getElementById("mailPanel").style.display = "none";
// 			    document.getElementById("MailProgress").style.display = "none";
// 			}
// 			function ShowMailProgress() {
// 			    //document.getElementById("mailPanel").style.display = "";
// 			    document.getElementById("MailProgress").style.top = (CurrentHeight / 2) + "px";
// 			    document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
// 			    document.getElementById("MailProgress").style.display = "";
// 			}
        </script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1 style="margin-bottom:0px;">회람문서함 관리</h1>
		<div id="close">
		  <ul>
		    <li><span onClick="window.close()">닫기</span></li>
		  </ul>
		</div>
		<div style="margin-bottom:5px;">
		    <a class="imgbtn"><span onClick="add_onclick()" style="text-align:center;">추가</span></a>
		    <a class="imgbtn"><span onClick="modify_onclick()" style="text-align:center;">수정</span></a>
		    <a class="imgbtn"><span onClick="delete_onclick()" style="text-align:center;">삭제</span></a>
		</div>
		<table class="popuplist" style="width:100%">
		  <tr>
		    <td>
		        <div style="height:400px;width:100%;overflow-x:auto;overflow-y:auto;background-color:#FFFFFF;padding-left:2px;padding-top:5px;" id="PostTreeView">
				</div>
		    </td>
		  </tr>
		</table>
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
		    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
		</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		    <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>