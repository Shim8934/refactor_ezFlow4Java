<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezMemo.t0026'/></title>
        <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezCircular.c1', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/email_tree.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview.htc.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component_utf8.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			
	

			var ReturnFunction;
			window.onload = function () {
			    CurrentHeight = document.body.clientHeight;
			    CurrenWidth = document.body.clientWidth;
			    memoFoldersInfo();
            }
			
            var inputNameDlg_cross_dialogArguments = new Array();
            
            function add_onclick() {
			    inputNameDlg_cross_dialogArguments[0] = onclick_Complete;
			    inputNameDlg_cross_dialogArguments[1] = DivPopUpHidden;
			    inputNameDlg_cross_dialogArguments[2] = "";
			    inputNameDlg_cross_dialogArguments[3] = "";
			    
			    DivPopUpShow(330, 200, "/ezMemo/memoInputName.do");
			}
            
		    function modify_onclick() {
		     
		        inputNameDlg_cross_dialogArguments[0] = onclick_Complete;
		        inputNameDlg_cross_dialogArguments[1] = DivPopUpHidden;
		        inputNameDlg_cross_dialogArguments[2] = "";//PostTreeView.getvalue(PostTreeView.selectedIndex(), "foldername");
		        inputNameDlg_cross_dialogArguments[3] = "";// PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
    
		        DivPopUpShow(330, 200, "/ezMemo/memoInputName.do");
		    }
		    
		    function onclick_Complete(szName) {
		    	DivPopUpHidden();
		    	opener.LoadEmailTree();
		    	
		    	$.ajax({
            		type : "POST",
            		url : "/ezCircular/getCircularFolderList.do",
            		async : false,
            		dataType : "json",
            		data : {},
            		success : function(result) {
            			$("#PostTreeView").html("");
	            		
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
		    	
		    }
		    
		   

		    function close_onclick() {
		    	window.close();
		    }
		    
		    function memoFoldersInfo() {
		    	$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
					url : "/ezMemo/getMemoFoldersInfo.do",
					success: function(result){
						var html="";
						var folderList = result["folders"];
						$('.memoNode').remove();
							
						folderList.forEach(function(list, index){
							html+="<div class='memoNode' id='folder" + list.folder_id + "'>";
							html+="<img border='0' src='/images/OrganTree_cross/dot_end.gif' style='width: 18px; height: 18px;'>";
							html+="<img src='/images/ImgIcon/icon_approval.gif' style='width:18px;height:19px;'>";
							html+="<span style='width:100%;height:21px; line-height:21px; font-size:12px;' class='node'>" + list.folder_name + "<span id='folderCount" + index +"'></span></span></div>";
						});
						$('.memoFolders').append(html);
					}     			
				});
		    	opener.memoFoldersInfo();
		    }
        </script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1 style="margin-bottom:0px;"><spring:message code='ezMemo.t0026' /></h1>
		<div id="close">
			<ul>
		    	<li><span onClick="close_onclick()"></span></li>
		  	</ul>
		</div>		
		<table class="popuplist" style="width:100%;margin-top:5px">
			<tr>
		    	<td>
		        	<div style="height:390px;width:100%;overflow-x:auto;overflow-y:auto;background-color:#FFFFFF;padding-left:2px;padding-top:5px;" id="PostTreeView">
		        		<div class="memoFolders"></div>
					</div>
		    	</td>
		  	</tr>
		</table>
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn"><span onClick="add_onclick()" style="text-align:center;"><spring:message code='ezMemo.t0027' /></span></a>
		    <a class="imgbtn"><span onClick="modify_onclick()" style="text-align:center;"><spring:message code='ezMemo.t0028' /></span></a>
		    <a class="imgbtn"><span onClick="delete_onclick()" style="text-align:center;"><spring:message code='ezMemo.t0029' /></span></a>
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