<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezBoard.t75" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
	    <script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<script type="text/javascript" language="javascript">
			$(document).ready(function(){			
				$.ajax({
					type :	"POST",
	            	dataType : "text",			
					url: "/admin/ezBoard/getBackGroundImage.do",
					data : { type: "ALL", backgroundID: "" },
					success: function(result){		
						var _html = "";
			            try{
			                var XmlNode = "";
			                var XmlNodeText = "";
			                XmlNodeText = result;
			                XmlNode = loadXMLString(XmlNodeText);
			                var countValue = 0;
			                _html = "<table class='mainlist' style='width:100%;'>";
			                
			                if (SelectNodes(XmlNode, "DATA/ROW").length > 0) {
			                    //if (CrossYN()) {
			                        for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
			                            var _Value;
			                            var tempi = i + 1;
			                            _html += "<tr id = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "SAVEFILENAME")[0].textContent + "' backgroundid = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "BACKGROUNDID")[0].textContent + "' priority = '" + tempi
			                                  + "' imgwidth = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "WIDTH")[0].textContent + "' imgheight = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HEIGHT")[0].textContent
			                                  + "' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);' ondblclick='event_dbclick(this);'>"
			                            if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISUSE")[0].textContent == "1")
			                                _html += "<td style='width:8%;padding-left:5px;'><input type='checkbox' name = 'checkbox' checked = true onclick='event_statuschange(this);'></td>";
			                            else
			                                _html += "<td style='width:8%;padding-left:5px;'><input type='checkbox' name = 'checkbox' onclick='event_statuschange(this);'></td>";
	
			                            _html += "<td style='width:60%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ORGFILENAME")[0].textContent + "</td>";
			                            _html += "<td style='width:32%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "REGDATE")[0].textContent + "</td>";
			                            _html += "</tr>";
			                            _html += "</html>";
			                            if (SelectNodes(XmlNode, "DATA").length == 0)
			                                document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'> " + "ㅊ" + "</td></tr></table>";
			                            else
			                                document.getElementById("contentlist").innerHTML = _html;
			                        }
			                    //}
			                    /*else {
			                        for (var i = 0; i < SelectNodes(XmlNode, "DATA/ROW").length; i++) {
			                            var _Value;
			                            var tempi = i + 1;
			                            _html += "<tr id = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "SAVEFILENAME")[0].text + "' backgroundid = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "BACKGROUNDID")[0].text + "' priority = '" + tempi
			                                  + "' imgwidth = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "WIDTH")[0].text + "' imgheight = '" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "HEIGHT")[0].text
			                                  + "' onmouseover='event_Mover(this);' onmouseout='event_Mout(this);' onclick='event_click(this);' ondblclick='event_dbclick(this);'>";
			                            if (GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ISUSE")[0].text == "1")
			                                _html += "<td style='width:8%;padding-left:5px;'><input  type='checkbox' name = 'checkbox' checked = true onclick='event_statuschange(this);'></td>";
			                            else
			                                _html += "<td style='width:8%;padding-left:5px;'><input type='checkbox' name = 'checkbox' onclick='event_statuschange(this);'></td>";
	
			                            _html += "<td style='width:60%;color:gray;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "ORGFILENAME")[0].text + "</td>";
			                            _html += "<td style='width:32%; white-space:nowrap; text-overflow:ellipsis; overflow:hidden;'>" + GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "REGDATE")[0].text + "</td>";
			                            _html += "</tr>";
			                            _html += "</html>";
			                            if (SelectNodes(XmlNode, "DATA").length == 0)
			                                document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'> " + strLang53 + "</td></tr></table>";
			                        else
			                            document.getElementById("contentlist").innerHTML = _html;
			                    	}
				                }*/
				            }else {
				                    document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'> " + strLang53 + "</td></tr></table>";
				            }	
				        }catch (e) {
				            document.getElementById("contentlist").innerHTML = "<table class='mainlist' style='width:100%;'><tr><td align='center'>" + strLang53 + "</td></tr></table>";
				        }	
					}
				});
			});
			
			function event_Mover(obj) {
				if (obj != _RowObject) {
			    	obj.childNodes.item(0).style.backgroundColor = "#EDEDED";
			        obj.childNodes.item(1).style.backgroundColor = "#EDEDED";
			        obj.childNodes.item(2).style.backgroundColor = "#EDEDED";
				}
			}
		    function event_Mout(obj) {
		        if (obj != _RowObject) {
		            obj.childNodes.item(0).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(1).style.backgroundColor = "#FFFFFF";
		            obj.childNodes.item(2).style.backgroundColor = "#FFFFFF";
		        }
		    }
		    var tempid = "";
		    var tempfilepath = "";
		    var _RowObject = null;
		    
		    function event_click(obj) {
		        if (_RowObject != null) {
		            _RowObject.childNodes.item(0).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(1).style.backgroundColor = "#ffffff";
		            _RowObject.childNodes.item(2).style.backgroundColor = "#ffffff";
		        }
		        _RowObject = obj;
		        obj.childNodes.item(0).style.backgroundColor = "#DBE1E7";
		        obj.childNodes.item(1).style.backgroundColor = "#DBE1E7";
		        obj.childNodes.item(2).style.backgroundColor = "#DBE1E7";
		        tempid = obj.getAttribute("backgroundid");
		        MakeDescription(obj.id);
		    }
		    
		    function event_statuschange(check) {
		        var j = 0;
		        var use = 0;
		        
		        for (var i = 0; i < document.getElementsByName("checkbox").length; i++) {
		            if (document.getElementsByName("checkbox")[i].checked)
		                j++;
		        }
		        if (j > 9) {
		            alert("<spring:message code='ezBoard.t5004'/>");
		            check.checked = false;
		        }
		        if (check.checked){
		        	use = 1;
		        }else{
		        	use = 0;
		        }
		        
		        $.ajax({
		        	type: "POST",
		        	dataType: "text",
		        	url: "/admin/ezBoard/statusChangeBackGroundImage.do",
		        	data: { backgroundID : check.parentElement.parentElement.getAttribute("backgroundid"), isUse : use, mode : "U"},
		        	success: function(result){
       		
		        	}
		        });
		    }

		    function event_dbclick(clickitem) {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 330) / 2;
		        var pLeft = (pwidth - 610) / 2;
		        var imgwidth = document.getElementById("backimage").width;
		        var imgheight = document.getElementById("backimage").height;

		        window.open("/admin/ezBoard/selectBackGroundImage.do?type=UPT&backgroundID=" + clickitem.getAttribute("backgroundid") + "&width=" + imgwidth + "&height=" + imgheight, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=385,width=610,top=" + pTop + ",left=" + pLeft, "");
		    }
		    
		    function MakeDescription(filepath) {
		        tempfilepath = filepath;
		        document.getElementById("imagediv").style.display = "";
		        var width = document.getElementById(filepath).getAttribute("imgwidth");
		        var height = document.getElementById(filepath).getAttribute("imgheight");
		        var filepath = "<spring:eval expression='@config.getProperty(\"upload_board.BOARDBACKGROUND\")' />" + "/S_" + filepath;
		        document.getElementById("ContentDescription").innerHTML = "<img id='backimage' src = '" + filepath + "' width = '" + width + "' height = '" + height + "' />";
		    }
		    
		    function Reload() {
		        window.location.reload(false);
		    }
		    
		    function Priority_UP() {
		        if (navigator.userAgent.indexOf("MSIE") != -1) {
		            if (_RowObject == null) {
		                alert("<spring:message code='ezBoard.t5005'/>");
		                return;
		            }
		            var ChangeRow = null;
		            for (var i = 0; i < _RowObject.parentNode.childNodes.length - 1; i++) {
		                if (_RowObject.parentNode.childNodes.item(i) == _RowObject) {
		                    if (i == 0) {
		                        return;
		                    }
		                    ChangeRow = i - 1;        		                    
		                    if (event_ChangePriority(_RowObject.getAttribute("backgroundid"), _RowObject.getAttribute("priority"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("backgroundid"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("priority"))){
		                        swapNodes(_RowObject, _RowObject.parentNode.childNodes.item(ChangeRow));
		                    }
		                    break;
		                }
		            }
		        }else if (navigator.userAgent.indexOf("MSIE") == -1) {
		            if (_RowObject == null) {
	               		alert("<spring:message code='ezBoard.t5005'/>");
	                    return;
	                }
	                var ChangeRow = null;
	                for (var i = 0; i < _RowObject.parentNode.children.length ; i++) {
	                    if (_RowObject.parentNode.children.item(i) == _RowObject) {
	                        if (i == 0) {
	                            return;
	                        }
	                        ChangeRow = i - 1;
	                        if (event_ChangePriority(_RowObject.getAttribute("backgroundid"), _RowObject.getAttribute("priority"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("backgroundid"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("priority"))) {
	                            swapNodes(_RowObject, _RowObject.parentNode.children.item(ChangeRow));
	                        }
	                        break;
	                    }
	                }
	            }
		    }
		    
		    function Priority_DOWN() {
		        if (_RowObject == null) {
		            alert("<spring:message code='ezBoard.t5005'/>");
		            return;
		        }
		        var ChangeRow = null;
		        for (var i = 0; i < _RowObject.parentNode.childNodes.length - 1; i++) {
		            if (_RowObject.parentNode.childNodes.item(i) == _RowObject) {
		                if (i == _RowObject.parentNode.childNodes.length - 1) {
		                    return;
		                }
		                ChangeRow = i + 1;
		                if (event_ChangePriority(_RowObject.getAttribute("backgroundid"), _RowObject.getAttribute("priority"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("backgroundid"), _RowObject.parentNode.childNodes.item(ChangeRow).getAttribute("priority")))
		                    swapNodes(_RowObject, _RowObject.parentNode.childNodes.item(ChangeRow));
		                break;
		            }
		        }
		    }
		    
		    function event_ChangePriority(A_itemid, A_priority, B_itemid, B_priority) {
		    	var status;
		        
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	async : false,
		        	url : "/admin/ezBoard/statusChangeBackGroundImage.do",
		        	data : { backgroundID : A_itemid+"/"+B_itemid, isUse : B_priority+"/"+A_priority, mode : 'P' },
		        	success : function(){
		        		status = "Y";
		        	},
		        	error : function(){
		        		status = "N";
		        	}
		        });
		        
		        if(status == "Y"){
		        	return true;
		        }else{
		        	return false;
		        }
		    }
		    
		    function swapNodes(item1, item2) {
		        var itemtmp = item1.cloneNode(1);
		        var parent = item1.parentNode;
		        item2 = parent.replaceChild(itemtmp, item2);
		        item1.setAttribute("priority", item2.getAttribute("priority"));
		        item2.setAttribute("priority", itemtmp.getAttribute("priority"));
		        parent.replaceChild(item2, item1);
		        parent.replaceChild(item1, itemtmp);
		        itemtmp = null;
		    }
		    
		    function sliderdelete() {
		        if (tempid == "") {
		        	alert("<spring:message code='ezBoard.t5005'/>");
		           	return;
		        }
		        if (!confirm("<spring:message code='ezBoard.t197'/>"))
		            return;

				$.ajax({
					type : "POST",
		        	dataType : "text",
		        	async : false,
		        	url : "/admin/ezBoard/deleteBackGroundImage.do",
		        	data : { backgroundID : tempid, saveFileName : tempfilepath },
		        	success : function(){
		        		window.location.reload(false);	
		        	}
				});		      
		    }
		    
		    function btn_Select() {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 330) / 2;
		        var pLeft = (pwidth - 610) / 2;
		        window.open("/admin/ezBoard/selectBackGroundImage.do?type=NEW", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=385,width=610,top=" + pTop + ",left=" + pLeft, "");
		    }
	    </script>
	</head>
	<body class="mainbody">		
		<h1><spring:message code="ezBoard.t5006"/></h1>
		<div id="mainmenu">
	    	<ul>
	        	<li><span id ="NEW" onclick="btn_Select(this)"><spring:message code="ezBoard.t321"/></span></li>
	        	<li><span onclick="sliderdelete();"><img src="/images/ImgIcon/delete.gif"   style="margin-top:-2px;"  /><spring:message code="ezBoard.t89"/></span></li>
	        	<li><span onclick="Reload();"><img src="/images/ImgIcon/recur.gif"    style="margin-top:-2px;"  /><spring:message code="ezBoard.t205"/></span></li>
	        	<li><span onclick="Priority_UP();"><img src="/images/ImgIcon/prev.gif"  style="margin-top:-2px;" alt="<spring:message code='ezBoard.t493'/>"/></span></li>
	        	<li><span onclick="Priority_DOWN();"><img src="/images/ImgIcon/next.gif"  style="margin-top:-2px;" alt="<spring:message code='ezBoard.t494'/>" /></span></li>
	    	</ul>
	    </div>
	    <table style="width:750px;height:385px;" border="0">
        	<tr>
        		<td style="vertical-align:top">
              		<div style="border:1px solid #dbdbda;width:435px;height:385px;">
                		<table class="mainlist" style="width:100%;">
                    		<tr>
                        		<th style="width:8%;"><span><spring:message code="ezBoard.t496"/></span></th>
                        		<th style="width:60%;"><span><spring:message code="ezBoard.t5008"/></span></th>
                        		<th style="width:32%;"><span><spring:message code="ezBoard.t5007"/></span></th>
                    		</tr>
                		</table>
              			<div id="contentlist" name="contentlist" style="height:365px;overflow-y:auto;">
                			<table class="mainlist" style="width:100%;">
                    			<tr>
                        			<td style="text-align:center;">
                           				<img src="/images/email/progress_img.gif" />
                        			</td>
                    			</tr>
                			</table>
              			</div>
              		</div>
            	</td>
            	<td style="vertical-align:top;width:100%;height:100%">
              		<div id="imagediv" style="border:1px solid #dbdbda;margin:0px 5px 5px 5px;display:none">
                		<div id="ContentDescription" style="margin-top:1px;margin:5px 5px 5px 5px;"></div>
	              </div>
            	</td>
        	</tr>
      	</table>
	</body>
</html>