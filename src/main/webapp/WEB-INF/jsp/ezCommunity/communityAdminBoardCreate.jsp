<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>BoardCreate</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var ParentBoardID = "${parentBoardID}";
			var BoardGroupID = "${boardGroupID}";
			var BoardID = "${boardID}";
			var code = "${code}";
			var iMenuNum = 2;
			
			function hasSpecialCharacters(str) {
				for(var i=0; i<str.length; i++) {
		            if(str.charCodeAt(i) == 40 || str.charCodeAt(i) == 41 || str.charCodeAt(i) == 91 || str.charCodeAt(i) == 93 || str.charCodeAt(i) == 38 || str.charCodeAt(i) == 47) {
		            } else {
					    if (str.charCodeAt(i) >= 33 & str.charCodeAt(i) <= 47) {
					    	return true;
					    }
					    
					    if (str.charCodeAt(i) >= 58 & str.charCodeAt(i) <= 59) {
					    	return true;
					    }
					    
					    if (str.charCodeAt(i) >= 60 & str.charCodeAt(i) <= 64) {
					    	return true;
					    }
					    
					    if (str.charCodeAt(i) >= 91 & str.charCodeAt(i) <= 95) {
					    	return true;
					    }
					    
					    if (str.charCodeAt(i) >= 123 & str.charCodeAt(i) <= 125) {
					    	return true;
					    }
					}
				}
				return false;			
			}
			
			String.prototype.trim = function() {
				return this.replace(/(^\s*)|(\s*$)/g, "");
			}
	
			function Save() {
				txtNewName.value = txtNewName.value.trim();
				txtNewName2.value = txtNewName2.value.trim();
	
				if(txtNewName2.value == "" || txtNewName2.value == null) {
				    txtNewName2.value = txtNewName.value;
				}
				
				if (txtNewName.value == "") {
					alert("<spring:message code='ezCommunity.t320' />");
					return;
				}
				
				if (hasSpecialCharacters(txtNewName.value)) {
					alert("<spring:message code='ezCommunity.t321' />");
					return;
				}
				
			    if (hasSpecialCharacters(txtNewName2.value)) {
			        alert("<spring:message code='ezCommunity.t321' />");
			        return;
			    }
					
			    var xmlhttp = createXMLHttpRequest();
			    xmlhttp.open("POST", "aspx/CreateBoard.aspx?boardID=" + "{" + GetGUID().toUpperCase() + "}" + "&boardName=" + escape(txtNewName.value) + "&boardName2=" + escape(txtNewName2.value) + "&parentBoardID=" + BoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code, false);
				xmlhttp.send();
				xmlhttp = null;
	
				alert("<spring:message code='ezCommunity.t322' />");
				
			    if (CrossYN()) {
			        window.parent.frames[0].location.href = "/myOffice/ezcommunity/commhome/admin/admin_left.aspx?" + "code="+code+"&clickboard=Y&boardID=" + BoardGroupID;
			    } else {
			        window.parent.frames.item(0).location.href = "/myOffice/ezcommunity/commhome/admin/admin_left.aspx?" + "code=" + code + "&clickboard=Y&boardID=" + BoardGroupID;
			    }
			}
			
			function OpenRightMenu(pIndex) {
				if (BoardID == "" && pIndex == 6) {
					alert("<spring:message code='ezCommunity.t289' />");
					return;
				}
	
				curMenuIndex = pIndex;
	
				if (BoardID == "" && pIndex != 9 && pIndex != 7 && pIndex != 6) {
					alert("<spring:message code='ezCommunity.t289' />");
					return;
				}
				
				if (BoardID == ParentBoardID && pIndex != 1 && pIndex != 2 && pIndex != 3 && pIndex != 4 && pIndex != 9 && pIndex != 7 && pIndex != 6) {
					alert("<spring:message code='ezCommunity.t290' />");
					return;
				}
	
				switch(pIndex) {
					case 1:		
						window.location.href = "BoardProperty.aspx?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
						break;
					case 2:		
					    window.location.href = "BoardCreate.aspx?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
						break;
					case 3:		
						window.location.href = "BoardACL.aspx?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
						break;
				    case 4:
				        window.location.href = "BoardOrder.aspx?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
						break;
				    case 5:		
				        if (BoardID == BoardGroupID) {
				            alert("<spring:message code='ezCommunity.t377' />");
				        } else {
				            window.location.href = "BoardMove.aspx?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
				        }
				        
				        break;
					case 6:		
						window.location.href = "BoardDelete.aspx?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
						break;
					case 7:		
						window.location.href = "SearchBoardItem.aspx?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
						break;
					case 9:		
						window.location.href = "BoardGroupCreate.aspx?boardID=" + BoardID + "&parentBoardID=" + ParentBoardID + "&boardGroupID=" + BoardGroupID + "&code=" + code;
						break;
						
					default:
						break;		
				}
			}
			
			/* function searchBoard_onclick() {
			    var feature = "DialogHeight:470px;DialogWidth:340px;status:no;help:no;edge:sunken";
			    feature = feature + GetShowModalPosition(340, 470);
			    var ret = window.showModalDialog("/myoffice/ezCommunity/class_admin/Board/SearchBoard.aspx", "", feature);
			    
				if(typeof(ret) == "undefined") {
				} else {
					var spans = TopBoardsList.all.tags("span");
					
					for (var i=0; i<spans.length; i++) {
						if(spans.item(i).id == ret[1]) {
							loadTreeViewByPath(spans.item(i), ret[0], ret[1], ret[2], ret[3]);
						}
					}
				}
			}
	
			function loadTreeViewByPath(pObjSpan, pBoardID, pBoardGroupID, pBoardName, pParentBoardID) {
				var divs = TopBoardsList.all.tags("DIV");
				
				for (var i=0; i<divs.length; i++) {
					if(divs.item(i).parentElement.parentElement.id == "TreeArea") {
						divs.item(i).parentElement.parentElement.style.display = "none";
					}
				}
	
				pObjSpan.parentElement.parentElement.nextSibling.style.display = "";
				var TreeCtrl = pObjSpan.parentElement.parentElement.nextSibling.firstChild.firstChild;
				
				TreeCtrl.server = SS_ServerName;
				TreeCtrl.config = xmlDom_treeview;
				TreeCtrl.source = GetBoardTreeByPath(pBoardID, pBoardGroupID);
				TreeCtrl.update();
	
				SelectedBoardID = pBoardID;
				SelectedBoardName = pBoardName;
				SelectedBoardParentBoardID = pParentBoardID;
				SelectedBoardGroupID = pBoardGroupID;
	
				window.location.href = "BoardProperty.aspx?BoardID=" + SelectedBoardID;
			} */
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezCommunity.t323' /></h1>
		
		<div id="mainmenu">
			<ul>
			    <li><span onClick="OpenRightMenu(1)"><spring:message code='ezCommunity.t291' /></span></li>
			    <li><span onClick="OpenRightMenu(9)"><spring:message code='ezCommunity.t297' /></span></li>
			    <li><span onClick="OpenRightMenu(2)"><spring:message code='ezCommunity.t324' /></span></li>
			    <li><span onClick="OpenRightMenu(4)"><spring:message code='ezCommunity.t294' /></span></li>
			    <li><span onClick="OpenRightMenu(5)"><spring:message code='ezCommunity.t295' /></span></li>
			    <li><span onClick="OpenRightMenu(6)"><spring:message code='ezCommunity.t208' /></span></li>
			    <li><span onClick="OpenRightMenu(7)"><spring:message code='ezCommunity.t296' /></span></li>
			    <li style="display:none"><span onClick="OpenRightMenu(3)"><spring:message code='ezCommunity.t293' /></span></li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<table class="content" >
			<tr> 
			    <th><spring:message code='ezCommunity.t325' /></th> 
			    <td colspan="2"><b class="point">${parentBoardName}</b></td> 
			</tr> 
			<tr> 
			    <th><spring:message code='ezCommunity.t326' /></th> 
			    <td colspan="2" style="padding:0">
			    	<table style="width:100%">
						<tr class="primary">
				        	<th>${lang_Primary]</th>
				        	<td><input type="text" id ="txtNewName" name="txtNewName" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;"></td>
		        		</tr>
		        		<tr class="secondary">
							<th>${lang_Secondary}</th>
							<td><input type="text" id ="txtNewName2" name="txtNewName2" style="WIDTH:100%;box-sizing:border-box;-moz-box-sizing:border-box;"></td>
						</tr>
		      		</table>
				</td> 
			</tr> 
			<tr style="display:none"> 
			    <th rowspan="2">URL</th> 
			    <td style="width:70px;white-space:nowrap;"><input type="radio" name="radiobutton" value="radiobutton"><spring:message code='ezCommunity.t327' /></td> 
			    <td><input type="text" name="textfield2" style="width:100%"></td> 
		  	</tr>
		  	<tr style="display:none"> 
		    	<td colspan="2"><input type="radio" name="radiobutton" value="radiobutton"><spring:message code='ezCommunity.t328' /></td> 
		  	</tr> 
		</table> 
		
		<div class="btnposition">
		      <a class="imgbtn" onClick="Save()"><span><spring:message code='ezCommunity.t108' /></span></a>
		      <a class="imgbtn" onclick="window.location.reload(false)"><span><spring:message code='ezCommunity.t109' /></span></a>
		</div>
	</body>
</html>