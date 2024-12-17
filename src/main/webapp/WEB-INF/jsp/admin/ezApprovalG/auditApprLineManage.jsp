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
			var pUse_Editor = "<c:out value='${use_editor}'/>";
			var totalCnt = 0;
			var CurPage = 1;
			var totalPage = 0;
			var pageSize = 15;
			var BlockSize = 10;
			var testObj = {};
			var type = "";

			document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	        
	        var topid = "";
	        var Tab1_flag = true;
	        var DelType = "AD0001";
	        var type = "AD0001";
	    	
			$(document).ready(function() {
				getAuditApprLineList($('#tab1').find('span[class=tabon]').attr('auditApprLineId'));
				windowResize();
			});

			function searchList() {
				getAuditApprLineList($('#tab1').find('span[class=tabon]').attr('auditApprLineId'));
			}
			
			function company_change() {
				clearSearchVal();
				getAuditApprLineList($('#tab1').find('span[class=tabon]').attr('auditApprLineId'));
		    }
		    
			function getAuditApprLineList(auditApprLineId) {
		        
				var attrArray = new Array();
				var propArray = new Array();
				
	        	attrArray.push("userId");
	        	attrArray.push("deptId");
	        	attrArray.push("auditApprLineId");
	        	attrArray.push("orderBy");
	        	
				propArray.push("orderBy");
				propArray.push("userId");
	        	propArray.push("userNm");
	        	propArray.push("position");
	        	propArray.push("deptNm");
	        	propArray.push("mail");
	        	propArray.push("telephoneNumber");
	        	propArray.push("company");
				
				$.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezOrgan/getAuditApprLineList.do",		        	
		        	data : {
		        		companyID : document.getElementById("ListCompany").value,
		        		type : type,
		        		pageNum : "1",
		        		pageSize : "15",
		        		searchType : document.getElementById("searchType").value,
		        		searchValue : document.getElementById("searchValue").value,
		        		auditApprLineId : auditApprLineId,
		        		propArray : JSON.stringify(propArray),
		        		attrArray : JSON.stringify(attrArray),
		        		value : "userId"
		        	},
		        	success : function(xml){
		        		console.log('xml:');
		        		console.log(xml);
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
		                listview.SetID("lvAuditApprLineList");
		                listview.SetMulSelectable(false);
		                listview.SetRowOnClick("auditApprLineList_View");
		                listview.SetHeightFree(true);
		                listview.DataSource(headerData);
		                listview.DataBind("AdminListView");
		                checkbox_header();
		                
		                var a = document.getElementById("lvAuditApprLineList_TR_0");
		                
		                if (a== null || a == "") {
		                	
		                } else {
		                	a.style.backgroundColor = "rgb(255, 255, 255)";
		                	a.setAttribute("selected", "false");
		                	$("#lvAuditApprLineList_TR_0").mouseout(function(){
		                		$("#lvAuditApprLineList_TR_0").css("background-color", "rgb(255, 255, 255)");
		                	});
		                }
		                rowListSelect();
		                checkItems();
		                makePageSelPage();
		                setFucntion();
		        	},
		        	error : function(error){
		        	    alert("<spring:message code='ezOrgan.t2' />" + error);
		        	}
		        });
		    }
			
			function auditApprLineList_View(obj) {
				var className = window.event.target.getAttribute('class');
				if(className === 'checks') {
					return;
				}

				var doc = window.document;
				itemseq = document.getElementById(obj).getAttribute("DATA1");
				if(itemseq == "0") {
					return;
				}

				
				if(checkFlag) {
					if($("#"+itemseq).prop("checked")) {
						$("#" + obj + " td").css("background-color", "rgb(255, 255, 255)");
						$("#" + itemseq).prop("checked", false);
					} else {
						$("#" + obj + " td").css("background-color", "rgb(241, 248, 255)");
						$("#" + itemseq).prop("checked", true);
					}
				} else {
					$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");
					$(".checks").prop("checked",false);
					if($("#" + itemseq).is(":checked")) {
						$("#" + obj + " td").css("background-color", "rgb(255, 255, 255)");
						$("#" + itemseq).prop("checked", false);
					} else {
						$("#" + obj + " td").css("background-color", "rgb(241, 248, 255)");
						$("#" + itemseq).prop("checked", true);
					}
				}

				checkItems();
			} 
			
			var cnt;
			function checkbox_header() {
				var doc = window.document;
				var th = doc.getElementById("lvAuditApprLineList_TH_0");
				var acList = doc.getElementById("lvAuditApprLineList");
				
				th.innerHTML = "<input type= 'checkbox' id = 'checkAll' onchange= 'checkboxHeaderClick()'></input>";
				
				cnt = acList.children[1].childElementCount;
				
				var noItemsChk = acList.children[1].children[0].getAttribute("id");
				
				if (cnt <= 1 && noItemsChk == "lvAuditApprLineList_TR_noItems") {
					return;
				}
				
				var i = 0;
				for (i; i < cnt; i++) {
					var seq = acList.children[1].children[i].children[0].innerHTML;
					
					acList.children[1].children[i].children[0].innerHTML = "<input type='checkbox' name='checks' class='checks' id='" 
					+ seq 
					+ "' value='" 
					+ seq 
					+ "' onchange=inputFunc(event,'"
					+ seq + "')></input>";
				} 
			}
			
			var checkFlag = false;
			function checkboxHeaderClick() {
				var doc = window.document;
				var acList = doc.getElementById("lvAuditApprLineList");
				// 데이터가 있을 경우에만
				if(acList.children[1].children[0].id !== 'lvAuditApprLineList_TR_noItems'){
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
						rowList.push(this.value);
					}
				});
			}
			
			function inputFunc(event, itemseq) {
				checkItems();
				
				$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");

				for (var i = 0; i < rowList.length; i++) {
					var objID = $("#" + rowList[i])[0].parentNode.parentNode.id;
					$("#" + objID + " td").css("background-color", "rgb(241, 248, 255)");
					$("#" + rowList[i]).prop("checked", true);
				}
			}
			
			var itemseq;
			
			
		    function td_Create1(strtext) {
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
		            getAuditApprLineList($('#tab1').find('span[class=tabon]').attr('auditApprLineId'));
		        }
		    }
			
			function makePageSelPage() {
				checkFlag = false;
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        document.getElementById("mailBoxInfo").innerHTML = "&nbsp;<span class='txt_color'>" + totalCnt + "</span>";
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
		        td_Create1(PagingHTML);
		    }
			
			//추가, 삭제, 메일 버튼을 선택하는 함수
			function setFucntion() {
				var doc  = window.document;
				var add  = doc.getElementById("add");
				var del  = doc.getElementById("del");
				
				add.addEventListener("click", auditApprLineAdd);
				del.addEventListener("click", Choose_Del);
			}
			
			var Tab1_SelectID = "";
		    function Tab1_MouserOver(obj) {
		    	//checkFlag = false;
		        obj.className = "tabover";
		    }
		    
		    function Tab1_MouserOut(obj) {
		        if (Tab1_SelectID != obj.id) {
		            obj.className = "";
		        }
		    }
		    
		    function Tab1_MouseClick(obj) {
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null) {
		                document.getElementById(Tab1_SelectID).className = "";
		            }
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);
		        }
		    }
		    
		    var clickTabID = "1tab1";
		    function ChangeTab(obj) {
		    	console.log('runs ChangeTab!');
		        var pSelectTab = obj.getAttribute("auditApprLineId");
		        clickTabID = obj.id;
		        DelType = pSelectTab;
		        type = pSelectTab + "=1";

		        CurPage = 1;
		        checkFlag = false;
		        clearSearchVal();
		        rowList = [];
		        getAuditApprLineList(pSelectTab);
		    }
			
			function Tab1_NewTabIni(pTabNodeID) {
		        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
		            if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };;

		                    if (Tab1_flag) {
		                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
		                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
		                        Tab1_flag = false;
		                    }
		                }
		            }
		        }
		    }
			
			var auditAppr_check_dialogArguments = new Array();
		    var auditApprLineAdd = function() {
		        var listview = new ListView();
		        listview.LoadFromID("lvAuditApprLineList");
		        var Params = new Array();
		        var result = "";
		        var url = "";
		        
		        url += "/admin/ezApprovalG/auditApprLineManagePop.do?companyID=" + document.getElementById("ListCompany").value;
	            url += "&auditApprLineId=" + encodeURI($('#tab1').find('span[class=tabon]').attr('auditApprLineId'));
	            url += "&title=" + encodeURI($('#tab1').find('span[class=tabon]').text());
		        
		        if (CrossYN()) {
		            auditAppr_check_dialogArguments[0] = Params;
		            auditAppr_check_dialogArguments[1] = auditApprLineAdd_Complete;
		            var OpenWin = window.open(url, "auditApprLineManagePop", GetOpenWindowfeature(1015, 620));
		            try { OpenWin.focus(); } catch (e) { }
		        } else {
		            window.showModalDialog(url, Params, "dialogHeight:580px; dialogWidth:970px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(1015, 620));
		            clearSearchVal();
		            getAuditApprLineList($('#tab1').find('span[class=tabon]').attr('auditApprLineId'));
		        }
		    }
		    
		    function auditApprLineAdd_Complete() {
		    	clearSearchVal();
		    	getAuditApprLineList($('#tab1').find('span[class=tabon]').attr('auditApprLineId'));
		    }
		    
		    function clearSearchVal () {
		    	$("#searchValue").val("");
		    }
		    
            //2018-08-06 김보미 - 페이지 위치 고정
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
		    
		    var delete_confirm_cross_dialogArguments;
		    var Choose_Del = function() {
		    	
		    	var delUserArray = new Array();
		    	var insUserArray = new Array();
		    	var index = 0;
		    	var isValid = false;
		    	
		    	$.each($('#lvAuditApprLineList tbody tr'), function(i, item) {
		    		var delUserObj = new Object();
			    	var insUserObj = new Object();
		    		var checkBox = $(this).find('input[type=checkbox]');
		    		
		    		if($(checkBox).is(':checked')) {
		    			isValid = true;
		    			delUserObj.userId = $(checkBox).val();
		    			delUserArray.push(delUserObj);
		    		} else {
		    			index++;
		    			insUserObj.userId = $(checkBox).val();
		    			insUserObj.deptId = $(this).attr('deptId');
		    			insUserObj.orderBy = index;
		    			insUserArray.push(insUserObj);
		    		}
		    	});
		    	
		    	if(!isValid) {
		    		alert('<spring:message code="ezAdmin.auditApprLine.08"/>');
		    		return;
		    	}
		    	
		    	$.ajax({
	            	type : "POST"
	            	,dataType : "text"
	            	,url : "/admin/ezApprovalG/auditApprListPrc.do"
	            	,async : false
	            	,data : {
	            		auditApprLineId : $('#tab1').find('span[class=tabon]').attr('auditApprLineId')
	            		,insUserArray : JSON.stringify(insUserArray)
	            	},
	            	success : function(result) {
	            		alert('<spring:message code="ezAdmin.auditApprLine.11"/>');
	            	},
	            	error : function() {
	            		alert('<spring:message code="ezAdmin.auditApprLine.10"/>');
	            	}
	            });
		    	getAuditApprLineList($('#tab1').find('span[class=tabon]').attr('auditApprLineId'));
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
						<NAME><spring:message code='ezAdmin.auditApprLine.05' /></NAME>
						<WIDTH>90</WIDTH>
						<STYLE>border-top:0px;</STYLE>
					</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t218' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t67' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t69' /></NAME>
		        		<WIDTH>9%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t68' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t91' /></NAME>
		        		<WIDTH>20%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t95' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t123' /></NAME>
		        		<WIDTH>10%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
	
	    <form id="Form1" method="post">
		    <h1>
		    	<spring:message code='ezAdmin.auditApprLine.01' />
		    	<span id="mailBoxInfo"></span>
		    	<span class="title_bar"><img src="/images/name_bar.gif"></span>
		    	<select class="companySelect" id="ListCompany" onchange="company_change()">
	            	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
	            </select>
	            
	            <span class="searchForm" style="display:none;">
	            	<select id="searchType" class="text" style="width:80px;height: 27px; margin-right: 0px; border: 1px solid #cbcbcb;">
						<option selected="" value="displayname"><spring:message code='ezOrgan.t67' /></option>
						<option value="cn"><spring:message code='ezOrgan.t218' /></option>
						<option value="title"><spring:message code='ezOrgan.t69' /></option>
						<option value="description"><spring:message code='ezOrgan.t68' /></option>
						<option value="mail"><spring:message code = 'ezOrgan.t91' /></option>
						<option value="telephonenumber"><spring:message code='ezOrgan.t95' /></option>
						<option value="company"><spring:message code= 'ezOrgan.t123' /></option>
					</select>
					
					<input id="searchValue" class="searchinputBox"; onkeypress="if(event.keyCode==13) {searchList(); return false;}" onfocus="clearSearchVal();" style="display:none;">
					<a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onclick="searchList()"></a>
	            </span>
		    </h1>
		    <div id="mainmenu">
		        <ul style="margin-top:15px;">
		            <li class="important"><span id="add"><spring:message code='ezOrgan.mse3' /></span></li>
		            <li><span class="icon16 icon16_delete" id="del"></span></li>
		        </ul>
		    </div>
		    <script type="text/javascript">
		        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");        
		    </script>
		    <div class="portlet_tabpart01" style="padding-bottom:3px; width:100%;">
		        <div class="portlet_tabpart01_top" id="tab1">
	                <p id="auditApprLine_sub1"><span auditApprLineId="AD0001" id="1tab1"><spring:message code='ezAdmin.auditApprLine.02' /></span></p>
	                <p id="auditApprLine_sub2"><span auditApprLineId="AD0002" id="1tab2"><spring:message code='ezAdmin.auditApprLine.03' /></span></p>
	                <p id="auditApprLine_sub3"><span auditApprLineId="AD0003" id="1tab3"><spring:message code='ezAdmin.auditApprLine.04' /></span></p>
		        </div>
		    </div>
			<div id="contentlist" style="width:100%; overflow: auto;">
			    <div class="listview" style="border-left:0px;border-right:0px;border-bottom:1px">
			        <div id="AdminListView" style="border: 0px solid #ddd; Width: 100%; Height:540px; /* overflow-x: auto; */ BACKGROUND-COLOR: white; /* overflow-y:auto; */"></div>
			    </div>
			</div>
		    <div id="tblPageRayer" style="Width:100%;text-align:center;"></div>
		</form>         
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>
