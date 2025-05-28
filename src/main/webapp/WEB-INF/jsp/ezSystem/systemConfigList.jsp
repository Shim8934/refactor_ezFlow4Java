<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <style>
	    .mainlist_free tr td:first-child {
	    		padding-left:10px;
	    		height:25px;
	    }
	    .mainlist_free tr th:first-child {
	    		padding-left:10px;
	    }
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" language="javascript">
			var totalCnt = 0;
			var CurPage = 1;
			var totalPage = 0;
			var pageSize = 15;
			var BlockSize = 10;
			var isAdmin = ${isAdmin};
			var type = "";
			var lang = ${lang};
			
			document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        var strLang13 = "<spring:message code='ezSystem.w005'/>";
	        var strLang15 = "<spring:message code='ezSystem.w006'/>";
	        var strLang16 = "<spring:message code='ezSystem.w015'/>";
	        
	    	
			$(document).ready(function() {
				if (isAdmin) {
					type = 'c=1';
					makeConfigTypeList();
					SystemConfig_List('ALL');
				}

				//2018-08-06 김보미 - 페이지 위치 고정
				windowResize();
			});

			function searchList() {
				CurPage = 1;
				SystemConfig_List();
			}
			
			function showProgress() {
				// $('#progressPanel').width() = 220, $('#loadingLayer').width() = 168
				var leftSize = (window.innerWidth - 388)/2 + "px"
				document.getElementById("loadingLayer").style.left = leftSize;

				document.getElementById("progressPanel").style.display = "";
				document.getElementById("loadingLayer").style.display = "";

				parent.document.getElementById("lef").contentWindow.showProgress();
			}

			function hideProgress() {
				document.getElementById("progressPanel").style.display = "none";
				document.getElementById("loadingLayer").style.display = "none";

				parent.document.getElementById("lef").contentWindow.hideProgress();
			}

			function SystemConfig_List(typeCode) {
				if (typeCode == null) {
					typeCode = document.querySelector('#configType').value;
				}
				
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezSystem/getSystemConfigList.do",		        	
		        	data : {companyID : companySelectID, typeCode : typeCode, pageNum : CurPage, pageSize : pageSize, searchType : "displayname", searchValue : document.getElementById("searchValue").value},
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

		                document.getElementById("AdminListView").innerHTML = "";

		                var listview = new ListView();
		                listview.SetID("lvSystemConfigList");
		                listview.SetMulSelectable(false);
		                listview.SetRowOnClick("ListViewNodeClick");
		                listview.SetRowOnDblClick("ListViewNodeDblClick");
		                listview.SetHeightFree(true);
		                listview.DataSource(headerData);
		                listview.DataBind("AdminListView");
		                checkbox_header();
		                
		                var a = document.getElementById("lvSystemConfigList_TR_0");
		                
		                if (a== null || a == "") {
		                	
		                } else {
		                	a.style.backgroundColor = "rgb(255, 255, 255)";
		                	a.setAttribute("selected", "false");
		                	$("#lvSystemConfigList_TR_0").mouseout(function(){
		                		$("#lvSystemConfigList_TR_0").css("background-color", "rgb(255, 255, 255)");
		                	});
		                }
		                rowListSelect();
		                checkItems();
		                makePageSelPage();
		                setFunction();
		        	},
		        	error : function(error){
		        	    alert(strLang16);
		        	}
		        });		        
		    }
			
			function ListViewNodeClick(obj) {
				var className = window.event.target.getAttribute('class');
				if(className === 'checks') {
					return;
				}

				var doc = window.document;
				itemseq = document.getElementById(obj).getAttribute("DATA1");
				if(itemseq == "0") {
					return;
				}

				itemNode = document.getElementById(obj).firstChild.firstChild;
				if(checkFlag) {
					if(itemNode.checked == true) {
						$("#" + obj + " td").css("background-color", "rgb(255, 255, 255)");
						itemNode.checked = false;
					} else {
						$("#" + obj + " td").css("background-color", "rgb(241, 248, 255)");
						itemNode.checked = true;
					}
				} else {
					$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");
					$(".checks").prop("checked",false);
					if(itemNode.checked == true) {
						$("#" + obj + " td").css("background-color", "rgb(255, 255, 255)");
						itemNode.checked = false;
					} else {
						$("#" + obj + " td").css("background-color", "rgb(241, 248, 255)");
						itemNode.checked = true;
					}
				}

				checkItems();
			} 
			
			var cnt;
			function checkbox_header() {
				var doc = window.document;
				var th = doc.getElementById("lvSystemConfigList_TH_0");
				var acList = doc.getElementById("lvSystemConfigList");
				
				th.innerHTML = "<input type= 'checkbox' id = 'checkAll' onchange= 'checkboxHeaderClick()'></input>";
				
				cnt = acList.children[1].childElementCount;
				
				var noItemsChk = acList.children[1].children[0].getAttribute("id");
				
				if (cnt <= 1 && noItemsChk == "lvSystemConfigList_TR_noItems") {
					return;
				}
				
				var i = 0;
				for (i; i < cnt; i++) {
					var seq = acList.children[1].children[i].children[0].innerHTML;
					
					acList.children[1].children[i].children[0].innerHTML = "<input type='checkbox' name='checks' class='checks' id='" 
					+ seq 
					+ "' value='" 
					+ seq 
					+ "' onchange='inputFunc(event)'></input>";
				} 
			}
			
			var checkFlag = false;
			function checkboxHeaderClick() {
				var doc = window.document;
				var acList = doc.getElementById("lvSystemConfigList");
				if(acList.children[1].children[0].id !== 'lvSystemConfigList_TR_noItems'){
					if (checkFlag) {
						checkFlag = false;
						$(".checks").prop("checked", false);
						$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");
					} else {
						checkFlag = true;
						$(".checks").prop("checked", true);
						$("#contentlist tr td").css("background-color", "rgb(241, 248, 255)");
					}
					checkItems();
				}
			}
			
			var rowList = new Array();
			function checkItems() {
				rowList = [];
				$("input:checkbox[name='checks']").each(function(){
					if($(this).is(":checked")){
						rowList.push(this);
					}
				});
			}
			
			function inputFunc(event) {
				checkItems();
				
				$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");

				for (var i = 0; i < rowList.length; i++) {
					var objID = rowList[i].parentNode.parentNode.id;
					$("#" + objID + " td").css("background-color", "rgb(241, 248, 255)");
					rowList[i].checked = true;
				}
			}
			
			var itemseq;
			
			
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
		            SystemConfig_List();
		        }
		    }
			
			function makePageSelPage() {
				checkFlag = false;
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
			
			function setFunction() {
				var doc  = window.document;
				var add  = doc.getElementById("add");
				var del  = doc.getElementById("del");
				var typeEdit = doc.getElementById("typeEdit");
				var deleteBlock = doc.getElementById("deleteBlock");
				
				add.addEventListener("click", addSystemConfig);
				del.addEventListener("click", delSystemConfig);
				typeEdit.addEventListener("click", editConfigType);
				deleteBlock.addEventListener("click", disableDelete);
			}
			
			var add_systemconfig_dialogArguments = new Array();
		    var addSystemConfig = function() {
		        var listview = new ListView();
		        listview.LoadFromID("lvSystemConfigList");
		        var Params = new Array();
		        var result = "";
		       
		        if (CrossYN()) {
		        	add_systemconfig_dialogArguments[0] = Params;
		        	add_systemconfig_dialogArguments[1] = addSystemconfigComplete;
		            var OpenWin = window.open("/admin/ezSystem/addSystemConfig.do?companyID=" + companySelectID, "Add_SystemConfig", GetOpenWindowfeature(700, 800));
		            try { OpenWin.focus(); } catch (e) { }
		        } else {
		            window.showModalDialog("/admin/ezSystem/addSystemConfig.do?companyID=" + companySelectID, Params, "dialogHeight:800px; dialogWidth:700px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(700, 800));
		        }
		    }
		    
		    function addSystemconfigComplete() {
		    	clearSearchVal();
		        checkFlag = false;
		        SystemConfig_List();
		    }

		    function clearSearchVal () {
		    	$("#searchValue").val("");
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
		    
		    var delSystemConfig = function() {
		    	var delConfirm = confirm("<spring:message code = 'ezSystem.config.hth27' />");
		    	
		    	if (!delConfirm) {
		    		return;
		    	}
		    	
		    	var dataList = new Array();
				
		    	var deleteBlockList = [];
				$("input[name='checks']:checked").each(function(){
					var isDeleteBlock = this.parentElement.parentElement.getAttribute("DATA9");
					if (isDeleteBlock.toUpperCase() == "N") {
						dataList.push(this.parentElement.parentElement.getAttribute("DATA1"));
					} else {
						deleteBlockList.push(this.parentElement.parentElement.getAttribute("DATA1"));
					}
				});
				
				if (dataList.length == 0 && deleteBlockList.length == 0) {
					alert(strLang13);
					return;
				}
				
				if (dataList.length == 0 && deleteBlockList.length > 0) {
					alert("<spring:message code = 'ezSystem.config.hth35' />");
					return;
				}
				
				if (deleteBlockList.length > 0) {
					alert("<spring:message code = 'ezSystem.config.hth36' />");
				}
				
				jQuery.ajaxSettings.traditional = true;
				
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezSystem/deletesyStemConfig.do",
					async : false,
					data : {
						CODE : dataList,
						companyID : companySelectID
					},
					success : function(result) {
						if (result != "OK") {
							alert(strLang16);
							return;
						}
						alert("<spring:message code = 'ezSystem.config.hth25' />");
						checkFlag = false;
						clearSearchVal();
						SystemConfig_List();
					},
					error : function(){
						alert(strLang16);
					}
				});
		    }
		    
			// 등록, 수정 , 삭제 후 rowSelect 선택 method
			function rowListSelect() {
				var len = rowList.length;
				for (var i = 0; i < len; i++) {
					var tempItemSeq = rowList.pop();
					if (document.getElementById(tempItemSeq) != null) {
						$("#" + tempItemSeq).prop("checked", true);
						var tempID = $("#" + tempItemSeq)[0].parentNode.parentNode.id;
						$("#" + tempID + " td").css("background-color",
								"rgb(241, 248, 255)");
					}
				}

				if (checkFlag) {
					$("#checkAll").prop("checked", true);
				} else {
					$("#checkAll").prop("checked", false);
				}
			}
		    
		    function ListViewNodeDblClick(pListView) {
		    	var listview = new ListView();
		        listview.LoadFromID("lvSystemConfigList");
		
		        var Params = new Array();
		        var tr = listview.GetSelectedRows();
		        if (tr.length != 0) {
		            var pCode = tr[0].getAttribute("DATA1");
		            if (pCode != "") {
		            	if (CrossYN()) {
		            		add_systemconfig_dialogArguments[0] = Params;
		            		add_systemconfig_dialogArguments[1] = addSystemconfigComplete;
				            var OpenWin = window.open("/admin/ezSystem/addSystemConfig.do?CODE=" + pCode + "&companyID=" + companySelectID, "Add_SystemConfig", GetOpenWindowfeature(700, 800));
				            try { OpenWin.focus(); } catch (e) { }
				        } else {
				            window.showModalDialog("/admin/ezSystem/addSystemConfig.do?CODE=" + pCode + "&companyID=" + companySelectID, Params, "dialogHeight:800px; dialogWidth:700px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(700, 800));
				        }
		            }
		        }
	        }
		    
		    function changeCompany(companyID) {
		    	document.querySelector('#searchValue').value = "";
		    	makeConfigTypeList();
		    	SystemConfig_List();
		    }
		    
		    function makeConfigTypeList() {
		    	configSelect = document.querySelector('#configType');
		    	while (configSelect.options.length > 0) {
		    		configSelect.remove(0);
		    	}
		    	$.ajax({
					type : "GET",
					dataType : "text",
					url : "/admin/ezSystem/getSystemConfigTypeList.do",
					async : false,
					data : {
						companyID : companySelectID,
						mode : "ALL"
					},
					success : function(result) {
						result = loadXMLString(result);
						var xmldom = result;
						var xmlRows = xmldom.documentElement.getElementsByTagName("ROWS")[0].getElementsByTagName("ROW");
				    	var allOption = document.createElement("option");
				    	allOption.value = "ALL";
				    	allOption.text = "<spring:message code = 'ezSystem.ls06' />";
				    	configSelect.appendChild(allOption);
						for (var i = 0; i < xmlRows.length; i++) {
							var typeCode = xmlRows[i].getElementsByTagName("CELL")[0].getElementsByTagName("VALUE")[0].textContent;
							var typeName = "";
							if(lang == "1"){
								typeName = xmlRows[i].getElementsByTagName("CELL")[1].getElementsByTagName("VALUE")[0].textContent;
							} else {
								typeName = xmlRows[i].getElementsByTagName("CELL")[2].getElementsByTagName("VALUE")[0].textContent;
							}
							
							var optionElement = document.createElement("option");
							optionElement.value = typeCode;
		                    optionElement.text = typeName;
		                    configSelect.appendChild(optionElement);
						}
						
						configSelect.onchange = function () {
							clearSearchVal();
							CurPage = 1;
							SystemConfig_List();
						}
				    	
					},
					error : function(){
						alert(strLang16);
					}
				});
		    }
		    
		    var system_type_dialogArguments = [];
		    function editConfigType() {
		    	var Params = new Array();
		    	if (CrossYN()) {
		            system_type_dialogArguments[0] = Params;
		            system_type_dialogArguments[1] = editConfigType_complete;
		            var OpenWin = window.open("/admin/ezSystem/editSystemConfigType.do?companyID=" + companySelectID, "editType", GetOpenWindowfeature(1000, 520));
		            try { OpenWin.focus(); } catch (e) { }
		        } else {
		            window.showModalDialog("/admin/ezSystem/editSystemConfigType.do?companyID=" + companySelectID + "&companyID=" + companySelectID, Params, "dialogHeight:520px; dialogWidth:1000px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(1000, 520));
		        }
		    }
		    
		    function editConfigType_complete() {
		    	makeConfigTypeList();
		    	SystemConfig_List();
		    }
		    
		    function disableDelete() {
				var delConfirm = confirm("<spring:message code = 'ezSystem.config.hth33' />");
		    	
		    	if (!delConfirm) {
		    		return;
		    	}
		    	
		    	var dataList = new Array();

				$("input[name='checks']:checked").each(function(){
					dataList.push(this.parentElement.parentElement.getAttribute("DATA1"));
				});
				
				if (dataList.length == 0) {
					alert(strLang13);
					return;
				}
				
				jQuery.ajaxSettings.traditional = true;
				
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezSystem/disableDeleteSystemConfig.do",
					async : false,
					data : {
						CODE : dataList,
						companyID : companySelectID
					},
					success : function(result) {
						if (result != "OK") {
							alert(strLang16);
							return;
						}
						alert("<spring:message code = 'ezSystem.config.hth34' />");
						checkFlag = false;
						clearSearchVal();
						SystemConfig_List();
					},
					error : function(){
						alert(strLang16);
					}
				});
				
		    }
	    </script>
	</head>
	<body class="mainbody">
	    <xml id="listviewheader" style="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		    	    <HEADER>
						<WIDTH>24</WIDTH>
						<STYLE>border-top:0px;</STYLE>
					</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezSystem.w001' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
						<NAME><spring:message code='ezSystem.config.hth07' /></NAME>
						<WIDTH>15%</WIDTH>
						<STYLE>border-top:0px;</STYLE>
					</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezSystem.w002' /></NAME>
		        		<WIDTH>20%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezSystem.w003' /></NAME>
		        		<WIDTH>20%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezSystem.w004' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezSystem.config.hth26' /></NAME>
		        		<WIDTH>10%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code = 'ezSystem.config.hth32' /></NAME>
		        		<WIDTH>5%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
	
	    <form id="Form1" method="post">
		    <h1>
		    	SYSTEM CONFIG
	            <span class="searchForm">
					<input id="searchValue" class="searchinputBox" onkeypress="if(event.keyCode==13) {searchList(); return false;}" onfocus="clearSearchVal();" style="ime-mode: active;height: 27px;border: 1px solid #cbcbcb;">
					<a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onclick="searchList()"></a>
	            </span>
	            <jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp"/>
	            <span class="title_bar"><img src="/images/name_bar.gif"></span>
	            <label for="configType" style="display: none;"></label>
				<select class="companySelect" id="configType"></select>
		    </h1>
		    
		    <div id="mainmenu">
		        <ul style="margin-top:15px;">
		            <li class="important"><span id="add"><spring:message code='ezOrgan.mse3' /></span></li>
		            <li><span class="" id="del"><spring:message code='ezSystem.jhy05'/></span></li>
		            <li><span id="typeEdit"><spring:message code='ezSystem.config.hth10'/></span>
		            <li><span id="deleteBlock"><spring:message code='ezSystem.config.hth32'/></span>
		        </ul>
		    </div>
			<div id="contentlist" style="width:100%; overflow: auto;">
			    <div class="listview" style="border-left:0px;border-right:0px;border-bottom:1px">
			        <div id="AdminListView" style="border: 0px solid #ddd; Width: 99.75%; Height:540px; /* overflow-x: auto; */ BACKGROUND-COLOR: white; /* overflow-y:auto; */"></div>
			    </div>
			</div>
		    <div id="tblPageRayer" style="Width:100%;text-align:center;"></div>
		</form>
		<iframe name="AttachDownFrame" id="AttachDownFrame" style="display:none"></iframe>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="progressPanel">&nbsp;</div>
		<span class="loading_layer" style="z-index:6000;position:absolute;top:350px;left:350px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t680' /></span></span>
	</body>
</html>
