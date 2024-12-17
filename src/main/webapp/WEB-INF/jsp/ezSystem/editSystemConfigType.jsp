<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>SYSTEM CONFIG <spring:message code = 'ezSystem.config.hth07' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="SHORTCUT ICON" href="${util.addVer('/images/favicon/favicon.png')}">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
		<script type="text/javascript">
			var companyID = "<c:out value='${companyID}' />";
			var ReturnFunction;
			var RetValue;
			var totalCnt = 0;
			var CurPage = 1;
			var totalPage = 0;
			var pageSize = 15;
			var BlockSize = 10;
			
			window.onload = window_onload;
			function window_onload() {
				try {
					RetValue = parent.system_type_dialogArguments[0];
					ReturnFunction = parent.system_type_dialogArguments[1];
				} catch (e) {
					try {
						RetValue = opener.system_type_dialogArguments[0];
						ReturnFunction = opener.system_type_dialogArguments[1];
					} catch (e) {
						RetValue = window.dialogArguments;
					}
				}
				systemType_List();
				
				try {
					var ua = navigator.userAgent;
					if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
						var input = document.getElementsByTagName("input");
						for (var i = 0; i < input.length; i++) {
							if (input[i].getAttribute("type") == "text")
							KeEventControl(input[i]);
						}
					}
				}
				catch (e)
				{ }
			}
			
			$(window).on("resize", function(){
	            windowResize();
	        });
		    
		    function windowResize() {
	        	var height = document.documentElement.clientHeight - 170 - document.getElementById("mainmenu").clientHeight;
	        	if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
	        		height = height - 30;
	        	}
	        	document.getElementById("contentlist").style.height = height + "px";
	        	document.getElementById("contentlist").style.overflow = "auto";
	        }

 			function closeEditConfigType() {
 				window.close();
 			}
 			
 			function KeEventControl(obj) {
		        useragt = navigator.userAgent.toUpperCase();
		        if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) {
		            useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
		            if (parseInt(useragt) > 5) {
		                return;
		            }
		        }
		        obj.onkeydown = function () {
		            if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
		                return false;
		            if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
		                    parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
		                    parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
		                    parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
		                    parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
		                return false;
		        };
		    }
 			
 			function systemType_List() {
		        $.ajax({
		        	type : "GET",
		        	dataType : "text",
		        	url : "/admin/ezSystem/getSystemConfigTypeList.do",		        	
		        	data : {companyID : companyID, pageNum : CurPage, pageSize : pageSize, searchValue : document.getElementById("searchType").value},
		        	success : function(xml){
		        		result=loadXMLString(xml);
		        		if (result.xml != "") {
		                    if (result.documentElement.getElementsByTagName("TOTALCNT")[0] != null) {
		                        totalCnt = getNodeText(result.documentElement.getElementsByTagName("TOTALCNT")[0]);
		                        totalPage = Math.ceil(new Number(totalCnt / pageSize));
		                    }
		                } else {
		                    totalCnt = 0;
		                    totalPage = 0;
		                }
		                var xmldom = result;
		                var headerData = createXmlDom();
		                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
		                
		                if (CrossYN()) {
		                    var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
		                    var Node = headerData.importNode(xmlRtn, true);
		                    headerData.documentElement.appendChild(Node);
		                } else {
		                    var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
		                    headerData.documentElement.appendChild(xmlRtn);
		                }

		                document.getElementById("typeListView").innerHTML = "";

		                var listview = new ListView();
		                listview.SetID("configTypeList");
		                listview.SetMulSelectable(true);
		                listview.SetCheckBoxFlag(true);
		                listview.SetSelectFlag(false);
		                listview.SetRowOnDblClick("TypeViewNodeDbClick");
		                listview.SetHeightFree(true);
		                listview.DataSource(headerData);
		                listview.DataBind("typeListView");
		                
		                var a = document.getElementById("configTypeList_TR_0");
		                
		                if (a== null || a == "") {
		                	
		                } else {
		                	
		                }
		                
		                makePageSelPage();
		        	},
		        	error : function(error){
		        	    alert("<spring:message code='ezSystem.w015'/>");
		        	}
		        });		        
		    }
 			
 			function searchList() {
				CurPage = 1;
				systemType_List();
			}
 			
 			function clearSearchVal () {
 		    	$("#searchValue").val("");
 		    }
 			
 			function makingPageArea(strtext) {
 		        document.getElementById("tblPageRayer").innerHTML = strtext;
 		    }
 			
 			function goToPageByNum(Value) {
 		        CurPage = Value;
 		        makePageSelPage();
 		        movePage(CurPage);
 		    }
 			
 			function selbeforeBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    
		    function selbeforeBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum - 1) > 0) {
		            goToPageByNum(parseInt(pageNum - 1));
		        } else {
		            return;
		        }
		    }
 			
 			function selafterBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    
		    function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum + 1) <= totalPage) {
		            goToPageByNum(parseInt(pageNum + 1));
		        } else {
		            return;
		        }
		    }
 			
 			function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		            CurPage = newPage;
		            systemType_List();
		        }
		    }
 			
 			function makePageSelPage() {
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var pageNum = CurPage;
		        
		        if (totalPage > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
		            PagingHTML += strtext;
		        } else {
		            strtext = "<span class='btnimg first disabled'></span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "<span class='btnimg prev disabled'></span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "<span class='btnimg prev disabled'></span>";
		            PagingHTML += strtext;
		        }
		        
		        var MaxNum;
		        var i;
		        var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
		        
		        if (totalPage >= (startNum + parseInt(BlockSize))) {
		            MaxNum = (startNum + parseInt(BlockSize)) - 1;
		        } else {
		            MaxNum = totalPage;
		        }
		        
		        for (i = startNum; i <= MaxNum; i++) {
		            if (i == pageNum) {
		                strtext = "<span class='on'>" + i + "</span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        
		        if (i == 1) {
		        	strtext = "<span class='on'>" + i + "</span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPage > BlockSize) {
		            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
		                strtext = "";
		                strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "";
		                strtext = strtext + "<span class='btnimg next disabled'></span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "";
		            strtext = strtext + "<span class='btnimg next disabled'></span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		            strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
		            PagingHTML += strtext;
		        } else {
		            strtext = "<span class='btnimg last disabled'></span>";
		            PagingHTML += strtext;
		        }
		        
		        PagingHTML += "</div>";
		        makingPageArea(PagingHTML);
		    }
 			
 			var add_configtype_dialogArguments =[];
 			function TypeViewNodeDbClick() {
 				var listview = new ListView();
		        listview.LoadFromID("configTypeList");
		
		        var Params = new Array();
		        var tr = listview.GetSelectedRows();
		        if (tr.length != 0) {
		        	var pCode = tr[0].getAttribute("DATA1");
		        	if (pCode != "") {
			        	if (CrossYN()) {
				            add_configtype_dialogArguments[0] = null;
				            add_configtype_dialogArguments[1] = addConfigType_complete;
				            var OpenWin = window.open("/admin/ezSystem/addSystemConfigType.do?companyID=" + companyID + "&typeCode=" + pCode, "Add_ConfigType", GetOpenWindowfeature(500, 250));
				            try { OpenWin.focus(); } catch (e) { }
				        } else {
				            window.showModalDialog("/admin/ezSystem/addSystemConfigType.do?companyID=" + companyID + "&typeCode=" + pCode, Params, "dialogHeight:250px; dialogWidth:500px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(500, 250));
				        }
		        	}
		        }
 			}
 			
 			function openAddConfigType() {
 				if (CrossYN()) {
		            add_configtype_dialogArguments[0] = null;
		            add_configtype_dialogArguments[1] = addConfigType_complete;
		            var OpenWin = window.open("/admin/ezSystem/addSystemConfigType.do?companyID=" + companyID, "Add_ConfigType", GetOpenWindowfeature(500, 250));
		            try { OpenWin.focus(); } catch (e) { }
		        } else {
		            window.showModalDialog("/admin/ezSystem/addSystemConfigType.do?companyID=" + companyID, Params, "dialogHeight:250px; dialogWidth:500px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(500, 250));
		        }
 			}
 			
 			function addConfigType_complete() {
 				clearSearchVal();
				systemType_List();
				if (ReturnFunction != null) {
					ReturnFunction("");
				} else {
					window.returnValue = "";
					try{
						window.opener.editConfigType_complete();
					} catch(e) {
					
					}
				}
 			}
 			
 			function deleteConfigTypes() {
 				var DocList = new ListView();
 				DocList.LoadFromID("configTypeList");
 				var selRows = DocList.GetSelectedRows();
 				if (selRows.length == 0) {
 					alert("<spring:message code = 'ezSystem.config.hth23' />");
 					return;
 				}
 				var typeCodes = [];
 				
 				for (var i = 0; i < selRows.length; i++) {
 					typeCodes.push(selRows[i].getAttribute("data1"))
 				}
 				
 				var param = {
					typeCodes : typeCodes,
					companyID : companyID
				}
 				var confirmDelete = confirm("<spring:message code = 'ezSystem.config.hth24' />");
 				if (!confirmDelete) {
 					return;
 				}
				$.ajax({
					url : "/admin/ezSystem/deleteSystemConfigType.do",
					type : "POST",
					contentType:"application/json",
					dataType : "text",
					async : false,
					data : JSON.stringify(param),
					success : function(result){
						alert("<spring:message code = 'ezSystem.config.hth25' />");
						clearSearchVal();
						systemType_List();
						if (ReturnFunction != null) {
							ReturnFunction("");
						} else {
							window.returnValue = "";
							try{
								window.opener.editConfigType_complete();
							} catch(e) {
							
							}
						}
					},
					error : function(){
						alert(strLang16);
					}
				});
				
			}
		</script>
	</head>
	<body class = "popup">
		<xml id="listviewheader" style="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezSystem.config.hth20' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezSystem.config.hth21' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezSystem.config.hth22' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezSystem.w011' /></NAME>
		        		<WIDTH>20%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezSystem.w004' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezSystem.config.hth26' /></NAME>
		        		<WIDTH>20%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
	
		<h1>
			SYSTEM CONFIG <spring:message code = 'ezSystem.config.hth07' /> 
			<span class="searchForm">
				<input id="searchType" class="searchinputBox" onkeypress="if(event.keyCode==13) {searchList(); return false;}" onfocus="clearSearchVal();" style="ime-mode: active;height: 27px;border: 1px solid #cbcbcb;">
				<a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onclick="searchList()"></a>
            </span>
		</h1>
		<div id="mainmenu">
	        <ul style="margin-top:15px;">
	            <li onclick="openAddConfigType()" class="important"><span id="add"><spring:message code='ezOrgan.mse3' /></span></li>
	            <li onclick="deleteConfigTypes()"><span class="" id="del"><spring:message code='ezSystem.jhy05'/></span></li>
	        </ul>
	    </div>
		<div id="contentlist" style="width:100%; overflow: auto;">
		    <div class="listview" style="border-left:0px;border-right:0px;border-bottom:1px">
		        <div id="typeListView" style="border: 0px solid #ddd; Width: 99.75%; Height:320px; /* overflow-x: auto; */ BACKGROUND-COLOR: white; /* overflow-y:auto; */"></div>
		    </div>
		</div>
		<div id="tblPageRayer" style="Width:100%;text-align:center;"></div>
		<div class="btnpositionNew"> 
		    <a class="imgbtn"><span onclick="closeEditConfigType()"><spring:message code = 'ezSystem.config.hth08' /></span></a>
	    </div>
	</body>
</html>