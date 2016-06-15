<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t93" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezResource.e1' />" ></script>
		<script type="text/javascript" src="/js/ezResource/admin/gwAdmin.js" ></script>
		<script type="text/javascript" src="/js/ezResource/admin/gwBoardsInfo.js" ></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js" ></script>
		<style type="text/css">
    		.warningbox01 { width:540px; margin:0 auto; border:1px solid #cccaca; background:#e8e8e8;font-family:Gulim, Dotum,Verdana, Arial, Helvetica, sans-serif;}
    		.warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 20px 25px;}
    		.warnintxt01 { position:relative ;padding-bottom:10px;}
    		.warningimg { position:absolute; top:0px; left:0px;}
    		.warningdl { padding:10px 0px 5px 150px; margin:0px 0px 0px 0px;}
    		.warningdl dt { height:40px; margin-top:10px;text-align:left;}
    		.warningdl dd { padding:0px 0px 0px 5px; margin:0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left;}
    		.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}
		</style>
		<script type="text/javascript" id="clientEventHandlersJS" >
			g_UserID	= "${userInfo.id}";
			g_BrdID		= "${brdID}";

			var L_UpLevel	= "${upLevel}";
			var L_UpStep	= "${upStep}";
			var L_UpCount	= "${upCount}";
			var cAdmin		= "";
			var pUserID		= "${userInfo.id}";
			var pDeptID		= "${userInfo.deptID}";
			var pCompanyID	= "${selCompanyID}";

			document.onselectstart = function () {
				if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
					return false;
				} else {
					return true;
				}
			};

			function SetOrder(inc) {
		    	var SelectedNode = "";
		    	if (CrossYN()) {
			        SelectedNode = window.parent.frames["board_menu"].TreeView.selectedIndex();
		    	} else {
			        SelectedNode = parent.window.frames("board_menu").document.all("TreeView").selectedIndex;
		    	}
			
		    	if (SelectedNode == null && document.getElementById("BRDLIST").length == 0) {
					alert("<spring:message code="ezResource.t94" />");
					return;
				}
				
		    	var selectobj = document.getElementById("BRDLIST");
				var index = selectobj.selectedIndex;	
			
				if (index >= 0) {
					var newidx = index + inc;
		        
					if (newidx < 0 || newidx > selectobj.length || newidx == selectobj.length) {
						return;
					}	

					var curr_id, next_id;
					curr_id = selectobj.options[index].value;		
					next_id = selectobj.options[newidx].value;
				
					if( ChgStep_xmlhttp(inc, curr_id, next_id) ) {
						tmp = selectobj.options[index].value;		
						selectobj.options[index].value = selectobj.options[newidx].value;		
						selectobj.options[newidx].value = tmp;

						tmp = selectobj.options[index].text;
						selectobj.options[index].text = selectobj.options[newidx].text;
						selectobj.options[newidx].text = tmp;

						selectobj.options[newidx].selected = true;
					
						cmdSave_onclick();
					} else {
						alert("<spring:message code="ezResource.t95" />");
					}	
				}
			}

			function ChgStep_xmlhttp(p_Gubun, p_Curr_ID, p_Next_ID) {
				try {	
			    	var xmlhttp
			    	if (CrossYN()) {
			        	xmlhttp = createXMLHttpRequest();
			    	} else {
				        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
				    }
			    
					var szUrl ="/admin/ezResource/callBrdStep.do?gubun=" + p_Gubun;
					szUrl += "&userID=" + g_UserID + "&upperID=" + g_BrdID;
					szUrl += "&upLevel=" + L_UpLevel + "&currID=" + p_Curr_ID;
					szUrl += "&nextID=" + p_Next_ID + "&companyID=" + pCompanyID;

					xmlhttp.open("POST", szUrl, false);
					xmlhttp.send();
					var rv = xmlhttp.responseText;

					if( rv == "True")
						return(true);
					else
						return(false);
				    
				} catch(e) { 
				}
			}

		function cmdSave_onclick() {
				try {
			    	document.getElementById("BRDLIST").options[document.getElementById("BRDLIST").selectedIndex].selected = true;
				} catch(e) {
					return;
				}

				var SelectedNode = "";
				if (CrossYN()) {
				    SelectedNode = window.parent.frames["board_menu"].TreeView.selectedIndex();//parent.frames[1].TreeView.selectedIndex();

			    	window.parent.frames["board_menu"].document.getElementById("brdlists").setAttribute("value", document.getElementById("BRDLIST").selectedIndex);
			    	window.parent.frames["board_menu"].changeTree();
			    	window.parent.frames["board_menu"].TreeView.toggle(SelectedNode);
				} else {
				    SelectedNode = parent.window.frames("board_menu").document.all("TreeView").selectedIndex;

			    	parent.window.frames("board_menu").document.all("brdlists").value = BRDLIST.selectedIndex;
			    	parent.window.frames("board_menu").document.Script.changeTree();
			    	parent.window.frames("board_menu").document.all("TreeView").toggle(SelectedNode);
				}
			}
		</script>
	</head>
	<body class="mainbody">	
		<h1><spring:message code="ezResource.t25" /></h1>
    	<br>
    	<br>
    	<table class="content">
        	<tr>
            	<th>
                	<spring:message code="ezResource.t44" /></th>
            	<td>
                	${upNm}
                	<input type="hidden" id="UPPER_NM" name="UPPER_NM" value="${upNm}"></td>
        	</tr>
    	</table>
    	<br>
    	* <spring:message code="ezResource.t98" />
    	<br>
        
        <c:choose>
        	<c:when test="${intSubClsCnt <= 1}">
        		<!---------------------- 하위게시판이 없는 경우 ------------------------>
		    	<div id="EmptyMsg">
    				<div class="warningbox01" style="margin-top:100px;">
        				<div class="warningbox02" style="height:130px;width:auto">
  	        				<div class="warnintxt01" style="text-align:left">
	        					<span class="warningimg"><img src="/images/notify/warning02_resorce.gif" width="136" height="112"></span>
	        					<dl class="warningdl">
	        						<dd><spring:message code="ezResource.t103" /> </dd>
	        					</dl>
	        				</div>
	    				</div>
    				</div>
				</div>
			</c:when>
        	<c:otherwise>
        		<!---------------------- 하위게시판 리스트 ----------------------------->
				<table class="popuplist" style="width:100%">
        			<tr>
            			<td>
                			<select name="BRDLIST" size="10" id="BRDLIST" style="width: 100%; height: 150px">  ${subBrdLst } </select>
            			</td>
            			<td width="30" align="center">
                        	<img src="/images/arr_up.gif" vspace="2" style="cursor:pointer" onClick="javascript:SetOrder(-1)"><br>
                            <img src="/images/arr_down.gif" width="16" height="16" vspace="2" style="cursor:pointer" onClick="javascript:SetOrder(1)">         
						</td>
        			</tr>
				</table>        			
        	</c:otherwise>
        </c:choose>
    
		<%--<div class="btnposition"><input type="submit" name="cmdSave" value="<%=RM.GetString("t101")%>" language="javascript" onClick="return cmdSave_onclick()"></div>--%>
    	<!-- 게시판 트리에서 값을 넘겨받기위한 곳 ---->
    	<form name="brds">
        	<input type="hidden" id="proc" name="proc" value="STEP">
        	<input type="hidden" id="step_list" name="step_list" value="">
    	</form>
	</body>
</html>
<script type="text/javascript">
    try {
        if (CrossYN()) {
            document.getElementById("BRDLIST").selectedIndex = window.parent.frames["board_menu"].document.getElementById("brdlists").value;
        } else {
            BRDLIST.selectedIndex = parent.window.frames("board_menu").document.all("brdlists").value;
        }
    } catch (e) { }
</script>