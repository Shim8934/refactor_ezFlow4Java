<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>shared_mailbox_list</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
			.mainlist tr td {
				padding:0px;
			}
			.mainlist_free tr th {
				border-top:0px;
			}
			.mainlist_free tr td:first-child {
				padding-left:10px;
			}
			.mainlist_free tr th:first-child {
				padding-left:10px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var companyId = "${userCompany}";
			var userComId = "${userCompany}";
			var searchFlag = false;
			var selectList_ChangeFlag = false;
			var selectTR_Data1;
			
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
		    };
		    
		    window.onload = function () {
		        if (document.all("ListCompany") != null && document.all("ListCompany").length == 0) {
		            alert("<spring:message code='ezEmail.t49' />");
		        } else {
		        	companyChange();
		        }
		        
		        var searchInput = $("#searchInputWrap input");
		        var searchBtn = $("#searchInputWrap .imgbtn");
		        var searchInputW = $("#searchInputWrap").width() - searchBtn.outerWidth() - 11;
		        searchInput.width(searchInputW + "px");
		    }
		    
		    function companyChange() {
		    	companyId = document.all("ListCompany") == null ? companyId : document.all("ListCompany").value;
		    	document.getElementsByClassName("shared_boxesTable")[0].style.display = "none";
		        
		    	$.ajax({
	    			url: "/admin/ezEmail/getSharedMailboxList.do",
	    			type: "POST",
	    			async: false,
	    			dataType: 'text',
	    			data: {'compId' : companyId},
	    			success: function(result) {
	    				if (result === "NO_PERMISSION") {
	    					alert("<spring:message code='ezOrgan.t302' />");
	    				} else if (result === "ERROR") {
	    					alert("<spring:message code='ezEmail.sharedMailbox07' />");
	    				} else {
	    					var resultXml = loadXMLString(result);
	    					var headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
	    		            var xmlRtn = resultXml.documentElement.getElementsByTagName("ROWS")[0];
	    					
	    		            if (CrossYN()) {
	    		                var Node = headerData.importNode(xmlRtn, true);
	    		                headerData.documentElement.appendChild(Node);
	    		            } else {
	    		                headerData.documentElement.appendChild(xmlRtn);
	    		            }
	
	    		            // 리스트 총 개수
	    		            var listCount = headerData.getElementsByTagName("ROWS")[0].childElementCount;
	    		            document.getElementById("listCount").innerHTML = listCount;
	    		            
	    		            document.getElementById("sharedMailboxList").innerHTML = "";
	    		            var pUserList = new ListView();
	    		            pUserList.SetID("sharedMailbox");
	    		            pUserList.SetRowOnDblClick("modSharedMailbox");
	    		            pUserList.SetRowOnClick("viewSharedMailboxInfo");
	    		            pUserList.SetSelectFlag(false);
	    		            pUserList.SetHeightFree(true);
	    		            pUserList.DataSource(headerData);
	    		            pUserList.DataBind("sharedMailboxList");
	    		            
	    		            selectList_Change2();
	    				}
	    			},
	    			error: function(err) {
	    				alert("<spring:message code='ezEmail.sharedMailbox07' />");
	    			}
	    		})
		    }
		
		    var xmlHTTP = createXMLHttpRequest();
		    
		    function viewSharedMailboxInfo() {
		        var listview = new ListView();
		        listview.LoadFromID("sharedMailbox");
		        var shareId = GetAttribute(listview.GetSelectedRows()[0], "DATA1");
		        
		        $.ajax({
	    			url: "/admin/ezEmail/getSharedMailboxInfo.do",
	    			type: "POST",
	    			async: false,
	    			dataType: 'json',
	    			data: {'shareId' : shareId},
	    			success: function(result) {
	    				if (result.resultCode === "OK") {
	    					
	    					document.getElementById("sharedMailTitleTH").getElementsByTagName("th")[0].innerHTML = "▒ <spring:message code='ezEmail.sharedMailbox08' />";
	    			        document.getElementById("sharedMailTitleTB").getElementsByTagName("span")[0].innerHTML= "<spring:message code='ezOrgan.t91' /> : " + result.sharedMailboxInfo.shareMail;
	    			        document.getElementById("sharedMailListTH").getElementsByTagName("th")[0].innerHTML = "▒ <spring:message code='ezEmail.sharedMailbox06' />";
	    			        document.getElementById("sharedMailListTB").innerHTML = "";
		                
		                	var TR = '<tr><td>';
		                		TR += '<ul class="layoutUL">';
		                		TR += '<li class="layoutRight"><span class="$managePermission"><spring:message code="ezEmail.sharedMailbox25" /></span></li>';
		                		TR += '<li class="layoutRight"><span class="$sendPermission"><spring:message code="ezEmail.sharedMailbox17" /></span></li>';
	                			TR += '<li class="layoutRight"><span class="$deletePermission"><spring:message code="ezEmail.sharedMailbox16" /></span></li>';
	                			TR += '<li class="layoutNone"><span class="$shared_boxesText" style="cursor:pointer;" onclick="showMember(this)" id="$userId">$userName</span></li>';
			                	TR += '</ul>';
	                            TR += '</td></tr>';

	                        result.sharedMailboxInfo.userList.forEach(function(vo, index) {
	    			        	var TRTemp = TR;
	    			        	var manageClass = vo.managePermission == 'Y' ? 'shared_boxesText_1' : 'shared_boxesText_2';
	    			        	var sendClass = vo.sendPermission == 'Y' ? 'shared_boxesText_1' : 'shared_boxesText_2';
	    			        	var deleteClass = vo.deletePermission == 'Y' ? 'shared_boxesText_1' : 'shared_boxesText_2';
	    			        	
	    			        	TRTemp = TRTemp.replace('$userId', vo.userId);
	    			        	TRTemp = TRTemp.replace('$userName', vo.userName + " (" + vo.deptName + ")");
	    			        	TRTemp = TRTemp.replace('$managePermission', manageClass);
	    			        	TRTemp = TRTemp.replace('$sendPermission', sendClass);
	    			        	TRTemp = TRTemp.replace('$deletePermission', deleteClass);
	    			        	
	    			        	$("#sharedMailListTB").append(TRTemp);
				    		});

	    			    	document.getElementsByClassName("shared_boxesTable")[0].style.display = "table";
	    				} else if (result.resultCode === "NO_PERMISSION") {
	    					alert("<spring:message code='ezOrgan.t302' />");
	    				} else {
	    					alert("<spring:message code='ezEmail.sharedMailbox07' />");
	    				}
	    			},
	    			error: function(err) {
	    				alert("<spring:message code='ezEmail.sharedMailbox07' />");
	    			}
	    		})
		    }
		
		    function showMember(obj) {
		        var pheight = window.screen.availHeight;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - 450) / 2;
		        var pLeft = (pwidth - 420) / 2;
		        window.open("/ezCommon/showPersonInfo.do?id=" + obj.id + "&dept=", "", "height=450px,width=420px, top=" + pTop.toString() + ", left=" + pLeft.toString() + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		    }

		    function delSharedMailbox() {
		        var listview = new ListView();
		        listview.LoadFromID("sharedMailbox");
		
		        var xmlDom = createXmlDom();
		        var xmlHTTP = createXMLHttpRequest();
		
		        var objNode = "";
		        createNodeInsert(xmlDom, objNode, "DATA");
		
		        var selectedCount = listview.GetSelectedRows().length;
		        
		        if (selectedCount > 0) {
		        	var shareName = listview.GetSelectedRows()[0].innerText;
		        	var shareId = listview.GetSelectedRows()[0].getAttribute("DATA1");
		        	
			        if (confirm("[" + shareName + "] <spring:message code='ezEmail.sharedMailbox22' />")) {
			        	if (confirm("<spring:message code='ezEmail.sharedMailbox23' />")) {
			        		$.ajax({
				    			url: "/admin/ezEmail/delSharedMailbox.do",
				    			type: "POST",
				    			async: false,
				    			dataType: 'json',
				    			data: {'shareId' : shareId},
				    			success: function(result) {
				    				if (result.resultCode === "OK") {
				    					alert("<spring:message code='ezEmail.sharedMailbox24' />");
				    				} else if (result.resultCode === "NO_PERMISSION") {
				    					alert("<spring:message code='ezOrgan.t302' />");
				    				} else {
				    					alert("<spring:message code='ezEmail.sharedMailbox07' />");
				    				}
				    				
				    				//companyChange();
				    				selectList_Change();
				    			},
				    			error: function(err) {
				    				alert("<spring:message code='ezEmail.sharedMailbox07' />");
				    				companyChange();
				    			}
				        	})
			        	}
			        }
		        } else {
		        	alert("<spring:message code='ezEmail.sharedMailbox20' />");
		        }
		    }
		    
		    var sharedMailboxDialogArguments = new Array();
		    
		    function addSharedMailbox() {
		        var feature = "dialogHeight:670px; dialogWidth:1080px; scroll:no;status:no; help:no; edge:sunken";
		        feature = feature + GetShowModalPosition(1080, 670);
		        
		        if (CrossYN()) {
		            sharedMailboxDialogArguments[0] = addSharedMailboxComplete;
		            var OpenWin = window.open("/admin/ezEmail/showAddSharedMailbox.do?compId=" + companyId, "", GetOpenWindowfeature(1080, 670));
		            try { OpenWin.focus(); } catch (e) {console.log(e);}
		        } else {
		            var rtnValue = window.showModalDialog("/admin/ezEmail/showAddSharedMailbox.do?compId=" + companyId, feature);
		            if (typeof (rtnValue) != "undefined") {
		                companyChange();
		            }
		        }
		    }
		    
		    function addSharedMailboxComplete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
		            companyChange();
		        }
		    }
		    
		    function modSharedMailbox() {
		        var pUserList = new ListView();
		        pUserList.LoadFromID("sharedMailbox");
		
		        var selnode = pUserList.GetSelectedRows();
		        
		        if (selnode == "") {
		            alert("<spring:message code='ezEmail.sharedMailbox20' />");
		            return;
		        }
		        
		        var shareId = selnode[0].getAttribute("DATA1");
		        var feature = "dialogHeight:690px; dialogWidth:1080px; scroll:no;status:no; help:no; edge:sunken";
		        feature = feature + GetShowModalPosition(1080, 690);
		        
		        if (CrossYN()) {
		        	sharedMailboxDialogArguments[0] = modSharedMailboxComplete;
		            var OpenWin = window.open("/admin/ezEmail/showAddSharedMailbox.do?shareId=" + encodeURIComponent(shareId) + "&compId=" + encodeURIComponent(companyId), "", GetOpenWindowfeature(1080, 690));
		            try { OpenWin.focus(); } catch (e) {console.log(e);}
		        } else {
		            var rtnValue = window.showModalDialog("/admin/ezEmail/showAddSharedMailbox.do?shareId=" + encodeURIComponent(shareId) + "&compId=" + encodeURIComponent(companyId), feature);
		            
		            if (typeof (rtnValue) != "undefined") {
		                companyChange();
		            }
		        }
		    }
		    
		    function modSharedMailboxComplete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
		        	selectList_Change();
		        }
		    }
		    
			var inputpassword_dialogArguments = new Array();
		    
			function mod_password() {
				var pUserList = new ListView();
		        pUserList.LoadFromID("sharedMailbox");
		        var selnode = pUserList.GetSelectedRows();
		        
		        if (selnode == "") {
		            alert("<spring:message code='ezEmail.sharedMailbox20' />");
		            return;
		        }

				userComId = document.getElementById("ListCompany").value;

		        inputpassword_dialogArguments[0] = strLangSharedMailbox02;
		        inputpassword_dialogArguments[1] = mod_password_Complete;
		        var OpenWin = window.open("/admin/ezOrgan/inputPassword.do?companyId=" + userComId, "InputPassword", GetOpenWindowfeature(467, 185));
		        try { OpenWin.focus(); } catch (e) {console.log(e);}
			}
			
		    function mod_password_Complete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
		        	var pUserList = new ListView();
			        pUserList.LoadFromID("sharedMailbox");
			        var selnode = pUserList.GetSelectedRows();
			        var shareId = selnode[0].getAttribute("DATA1");
			        
		            $.ajax({
		            	type : "POST",
		            	dataType : "xml",
		            	url : "/admin/ezOrgan/changePassword.do",
		            	async : false,
		            	data : {password : rtnValue, cn : shareId},
		            	success : function(result) {
		            		alert(strLangSharedMailbox03);
		            	},
		            	error : function() {
		            		alert("<spring:message code='ezOrgan.t41' />");
		            	}
		            });
	            }
		    }
		    
		    function search_click() {
				var searchType = document.getElementById("searchType").value;
		    	var searchValue = document.getElementById("searchValue").value;
		    	searchValue = searchValue.replaceAll(" ","") == "" ? "" : searchValue;
		    	searchFlag = true;
		    	
		    	if (searchValue == "") {
		    		alert("<spring:message code='ezEmail.t10' />");
		    		companyChange();
		    		return;
		    	}
		    	
		    	$.ajax({
					type : "post",
					dataType: 'text',
					data : {"searchType":searchType, "searchValue":searchValue, "compId":companyId},
					url : "/admin/ezEmail/getSharedMailboxListSearchByItem.do",
					success: function(result) {
	    				if (result === "NO_PERMISSION") {
	    					alert("<spring:message code='ezOrgan.t302' />");
	    				} else if (result === "ERROR") {
	    					alert("<spring:message code='ezEmail.sharedMailbox07' />");
	    				} else {
	    			    	document.getElementsByClassName("shared_boxesTable")[0].style.display = "none";
	    					var resultXml = loadXMLString(result);
	    					var headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
	    		            var xmlRtn = resultXml.documentElement.getElementsByTagName("ROWS")[0];
	    					
	    		            if (CrossYN()) {
	    		                var Node = headerData.importNode(xmlRtn, true);
	    		                headerData.documentElement.appendChild(Node);
	    		            } else {
	    		                headerData.documentElement.appendChild(xmlRtn);
	    		            }
	
	    		            // 리스트 총 개수
	    		            var listCount = headerData.getElementsByTagName("ROWS")[0].childElementCount;
	    		            document.getElementById("listCount").innerHTML = listCount;
	    		            
	    		            document.getElementById("sharedMailboxList").innerHTML = "";
	    		            var pUserList = new ListView();
	    		            pUserList.SetID("sharedMailbox");
	    		            pUserList.SetRowOnDblClick("modSharedMailbox");
	    		            pUserList.SetRowOnClick("viewSharedMailboxInfo");
	    		            pUserList.SetSelectFlag(false);
	    		            pUserList.SetHeightFree(true);
	    		            pUserList.DataSource(headerData);
	    		            pUserList.DataBind("sharedMailboxList");
	    		            
	    		            selectList_Change2();
	    				}
	    			},
	    			error: function(err) {
	    				alert("<spring:message code='ezEmail.sharedMailbox07' />");
	    			}
		    	});
		    }
		    
		    function selectList_Change() {
		    	selectList_ChangeFlag = true;
		    	selectTR_Data1 = $("#sharedMailbox tr[selected=true]")[0].getAttribute("data1");
		    	
		    	if (searchFlag == true && document.getElementById("searchValue").value != "") {
		    		search_click();
		    	} else {
		    		companyChange();
		    	}
		    }
		    function selectList_Change2() {
		    	if (selectList_ChangeFlag) {
		    		selectList_ChangeFlag = false;
			    	var reListTR_ = $("#sharedMailbox tr[data1='" + selectTR_Data1 + "']")[0];
					reListTR_ = typeof reListTR_ != "undefined"  ? reListTR_.getAttribute("id") : "";
					
			    	if (selectTR_Data1 != "" && reListTR_ != "") {
			    		tr_select(reListTR_, "sharedMailbox", viewSharedMailboxInfo);
			    	}
		    	}
		    }
		    
		    function mail_manage(){
		    	var listview = new ListView();
		        listview.LoadFromID("sharedMailbox");
		        
		        if (listview.GetSelectedRows().length == 0) {
					alert("<spring:message code='ezEmail.sharedMailbox20' />");
					return;
				}

		        var selectId = GetAttribute(listview.GetSelectedRows()[0],"DATA1");
		        var url = "/admin/ezOrgan/configEmail.do?id=" + selectId + "&type=share" + "&companyId=" + companyId;
			    window.open(url , "", "height=315px,width=462px,status=no,toolbar=no,menubar=no,location=no,resizable=1" + GetOpenPosition(462, 315));
			}
		</script>
	</head>
	<body class="mainbody">
		<xml id="listviewheader" style="display:none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezEmail.sharedMailbox02' /></NAME>
		        <WIDTH>70</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		
		<h1>
			<spring:message code='ezEmail.sharedMailbox01' />
			<span class="title_bar"><img src="/images/name_bar.gif"></span>
			<select name="ListCompany" id="ListCompany" class="companySelect" onchange="companyChange()" style="margin-bottom:10px;">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
	      	</select>
		</h1>
		
		<div id="mainmenu">
			<ul>
				<li><span onClick="addSharedMailbox()"><spring:message code='ezEmail.sharedMailbox03' /></span></li>
		    	<li><span onClick="modSharedMailbox()"><spring:message code='ezEmail.sharedMailbox04' /></span></li>
		      	<li><span onClick="delSharedMailbox()"><spring:message code='ezEmail.sharedMailbox05' /></span></li>
		      	<li><span onClick="mod_password()"><spring:message code='ezOrgan.t231' /></span></li>
		      	<li><span onClick="mail_manage()"><spring:message code='ezOrgan.t91' /></span></li>
		    </ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<div style="width:825px;">
		<!-- 검색 -->
		<div style="border: 1px solid #e8e8e8; WIDTH:100%; height: 34px; box-sizing: border-box; line-height: 33px; margin-bottom:3px;">
			<div id="jobTotalInfoRayer" style="display: inline-block;">
				<span>&nbsp;[<spring:message code='main.t252'/> <span class="txt_color" style="font-weight:bold;" id="listCount"></span> <spring:message code='ezSystem.kyj2'/>]</span>
			</div>
			<div id="userSearchRayer" style="float:right; display: inline-block;">
				<div style="display: inline-block; float:left;">
				<select id="searchType" style="height: 26px; width: 143px;">
					<option value="displayname"><spring:message code='ezEmail.sharedMailbox18' /></option> <!-- 공유사서함 이름 -->
					<option value="groupID"><spring:message code='ezEmail.sharedMailbox19' /></option> <!-- 공유사서함 ID -->
					<option value="memberName"><spring:message code='ezEmail.ksaSharedMailbox25' /></option> <!-- 공유자 이름 -->
					<option value="memberID"><spring:message code='ezEmail.ksaSharedMailbox26' /></option> <!-- 공유자 ID -->
				</select>
				</div>
				<div id="searchInputWrap" style="display: inline-block;box-sizing: border-box; padding-right: 2px;width: 518px;padding-left: 5px;">
					<input id="searchValue" onkeypress="if(event.keyCode==13) {search_click(); return false;}" autocomplete="off" style="height: 26px; border: 1px solid #cbcbcb; margin-top:2px;">
					<a class="imgbtn" style="vertical-align:middle; height: 24.5px; box-sizing: border-box; margin-top: -4px;">
						<span onclick="search_click()" style="height: 100%;"><spring:message code="ezStatistics.t36" /></span>
					</a>
				</div>
			</div>
		</div>
		<table class="mainlist" style="width:100%;">
	    	<colgroup>
	    		<col width="37%"/>
	    		<col width="63%"/>
	    	</colgroup>
			<tr>
				<td style="vertical-align:top; border-bottom:0;">
					<div style="width:100%; height:400px; overflow-y:auto; border-color:#dbdbda; border-width:1px; border-style:solid;">
						<div id="sharedMailboxList"></div>      
					</div>
				</td>
				<td style="vertical-align:top; border-bottom:0;">
					<div style="margin-left:5px; height:400px; border-color:#dbdbda; border-width:1px; border-style:solid; ">
						<div id="sharedMailboxUser" style="width:100%; height:100%; overflow-y:auto; box-sizing: border-box;">
							<table class="shared_boxesTable" style="display:none">
								<thead id="sharedMailTitleTH">
					                <tr>
					                    <th></th>
					                </tr>
				                </thead>
				           		<tbody id="sharedMailTitleTB">
					                <tr>
					                    <td>
					                        <ul class="layoutUL">
					                            <li class="layoutNone"><span class="shared_boxesText"></span></li>
					                        </ul>
					                    </td>
					                </tr>
				                </tbody>
				           		<thead id="sharedMailListTH">
				                <tr>
				                    <th></th>
				                </tr>
				                </thead>
					            <tbody id="sharedMailListTB">
					            </tbody>
				            </table>
						</div>
					</div>
				</td>
			</tr>
		</table>
		</div>
	</body>
</html>



