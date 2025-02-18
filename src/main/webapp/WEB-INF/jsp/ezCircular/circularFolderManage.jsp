<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCircular.t9'/></title>
        <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/email_tree.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component_utf8.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var PostTreeView = null;
			var treeconfig = "";
			var listCount = "";
			var EventCheck = false;
			var CurrentHeight = 0;
			var CurrenWidth = 0;
			
		    document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    };

			var ReturnFunction;
			window.onload = function () {
			    CurrentHeight = document.body.clientHeight;
			    CurrenWidth = document.body.clientWidth;
			    
			    try {
			        ReturnFunction = opener.mail_foldermanage_Cross_dialogArguments[1];
			    } catch (e) { }
			    
                PostTreeView = new TreeView('PostTreeView', 'PostTreeView');
                
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
			
            var inputNameDlg_cross_dialogArguments = new Array();
            
            function add_onclick() {
			    inputNameDlg_cross_dialogArguments[0] = onclick_Complete;
			    inputNameDlg_cross_dialogArguments[1] = DivPopUpHidden;
			    inputNameDlg_cross_dialogArguments[2] = "";
			    inputNameDlg_cross_dialogArguments[3] = "";
			    
			    DivPopUpShow(330, 200, "/ezCircular/circularInputName.do");
			}
            
		    function modify_onclick() {
		        if (PostTreeView.selectedIndex() == -1) {
		            alert("<spring:message code='ezCircular.t103' />");
		            return;
		        }
		        
		        inputNameDlg_cross_dialogArguments[0] = onclick_Complete;
		        inputNameDlg_cross_dialogArguments[1] = DivPopUpHidden;
		        inputNameDlg_cross_dialogArguments[2] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
		        inputNameDlg_cross_dialogArguments[3] = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
    
		        DivPopUpShow(330, 200, "/ezCircular/circularInputName.do");
		    }
		    
		    function onclick_Complete(szName) {
		    	DivPopUpHidden();
		    	opener.LoadEmailTree();
		    	
		    	$.ajax({
            		type : "POST",
            		url : "/ezCircular/getCircularFolderList.do",
            		async : false,
            		dataType : "text",
            		success : function(result) {
            			$("#PostTreeView").html("");
            			$("#PostTreeView").html(result);
	            		
            			PostTreeView = new TreeView('PostTreeView', 'PostTreeView');
                        
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
	        	});
		    }
		    
		    function delete_onclick() {
		    	var deleteFolder = "";
		    	
		    	if (PostTreeView.selectedIndex() == -1) {
		            alert("<spring:message code='ezCircular.t103' />");
		            return;
		        }

		        deleteFolder = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");

		        checkFolderList(deleteFolder); // 문서함에 회람이 있는지 없는지 확인

		        if (listCount > 0) {
		        	alert("<spring:message code='ezCircular.t194' />");
		        } else {
					if (confirm("<spring:message code='ezCircular.t46' />")) {
						$.ajax({
							method : "POST",
							dataType : "text",
							async : false,
							url : "/ezCircular/circularDeleteFolder.do",
							data : {
								deleteFolder : deleteFolder 
							},
							success : function() {
								onclick_Complete();
							},
							error : function() {
								alert("<spring:message code='ezCircular.t102' />");
							}
						})
					}		        	
		        }
		    }
		    
		    function checkFolderList(deleteFolder) {
		    	$.ajax({
		    		method : "POST",
		    		dataType : "json",
		    		async : false,
		    		url : "/ezCircular/circularCheckFolder.do",
		    		data : {
		    			deleteFolder : deleteFolder
		    		},
		    		success : function(result) {
		    			listCount = result.deleteListCount;
		    		}
		    	})
		    }

		    function close_onclick() {
		    	window.close();
		    }
        </script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1 style="margin-bottom:0px;"><spring:message code='ezCircular.t9' /></h1>
		<div id="close">
			<ul>
		    	<li><span onClick="close_onclick()"></span></li>
		  	</ul>
		</div>		
		<table class="popuplist" style="width:100%;margin-top:5px">
			<tr>
		    	<td>
		        	<div style="height:390px;width:100%;overflow-x:auto;overflow-y:auto;background-color:#FFFFFF;padding-left:2px;padding-top:5px;" id="PostTreeView">
					</div>
		    	</td>
		  	</tr>
		</table>
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn"><span onClick="add_onclick()" style="text-align:center;"><spring:message code='ezCircular.t77' /></span></a>
		    <a class="imgbtn"><span onClick="modify_onclick()" style="text-align:center;"><spring:message code='ezCircular.t29' /></span></a>
		    <a class="imgbtn"><span onClick="delete_onclick()" style="text-align:center;"><spring:message code='ezCircular.t30' /></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
		    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
		</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		    <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>