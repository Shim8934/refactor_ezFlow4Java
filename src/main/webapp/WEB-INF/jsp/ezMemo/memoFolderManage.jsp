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
			
			var selId="";
			var selFolderId="";
			var selFolderName="";
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
		     	if(selFolderName === "") {
		     		alert("<spring:message code='ezMemo.t0038' />");
		     		return;
		     	}
		        inputNameDlg_cross_dialogArguments[0] = onclick_Complete;
		        inputNameDlg_cross_dialogArguments[1] = DivPopUpHidden;
		        inputNameDlg_cross_dialogArguments[2] = selFolderName
		        inputNameDlg_cross_dialogArguments[3] = selFolderId;
    
		        DivPopUpShow(330, 200, "/ezMemo/memoInputName.do");
		    }
		    
		    function onclick_Complete(szName) {
		    	DivPopUpHidden();
		    }
		    
		    function delete_onclick() {
		    	if(selFolderName === "") {
		     		alert("<spring:message code='ezMemo.t0038' />");
		     		return;
		     	} 
		    	if (confirm("<spring:message code='ezMemo.t0039' />")) {
		    		url = "/ezMemo/memoFolderAction.do?folder_id=" + selFolderId;
            		method = "delete";
		    	} else {
		    	    return;
		    	}
		    
		    	
		    	$.ajax({
		    		method : "POST",
					dataType : "text",
					async : false,
					url : url,
					data : {
						"folder_name" : selFolderName,
						"methodType" : method
					},
					success: function(){
						memoFoldersInfo();
					}     			
				});
		    }
		    
		    function close_onclick() {
		    	window.close();
		    }
		    
		    function memoFoldersInfo() {
		    	selFolderId="";
				selFolderName="";
		    	$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
					url : "/ezMemo/getMemoFoldersInfo.do",
					success: function(result){
						var html="";
						var folderList = result["folders"];
						$('.memoNode').remove();
						$('.node').remove();
							
						folderList.forEach(function(list, index){
							html+="<div class='memoNode' id='folder" + list.folder_id + "'>";
							html+="<img border='0' src='/images/OrganTree_cross/dot_end.gif' style='width: 18px; height: 18px;'>";
							html+="<img src='/images/ImgIcon/icon_approval.gif' style='width:18px;height:19px;'>";
							html+="<span style='width:100%;height:21px; line-height:21px; font-size:12px;cursor:pointer;' class='node' data1='" + list.folder_name+ "' data2='" + list.folder_id + "' id='folderCount" + index +"'>" + list.folder_name + "</span></div>";
						});
						$('.memoFolders').append(html);
					}     			
				});
		    	opener.memoFoldersInfo();
		    	memoFolderClickE();
		    }
		    
		    function memoFolderClickE() {
		  		$(".node").click(function(){
					if(selId!==""){
						$("#"+selId).css("font-weight", "normal");
					}
					    	
					selId = $(this).attr('id');
					selFolderName = $(this).attr('data1');
					selFolderId = $(this).attr('data2');
					$(this).css("font-weight", "bold");
				});
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
		        	<div style="height:348px;width:100%;overflow-x:auto;overflow-y:auto;background-color:#FFFFFF;padding-left:2px;padding-top:5px;" id="PostTreeView">
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