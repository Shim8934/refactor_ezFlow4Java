<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e2', 'msg')}" type="text/css">	    
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
			var isAdmin = "<c:out value='${isAdmin}'/>";
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
	        var DelType = "c";
	        var type = "c=1";
	    	
			$(document).ready(function() {
			    if (isAdmin) {
			    	type = 'c=1';
			        Permissions_List();
			    } else {
		            document.getElementById("Permission_sub1").style.display = "none";
		            document.getElementById("1tab2").click();
		            type = 'k=1';
		            Permissions_List();			        
			    }
			    
			    //2018-08-06 김보미 - 페이지 위치 고정
			    windowResize();
			});
			
			function searchList() {
				CurPage = 1;
				Permissions_List();
			}
			
			function company_change() {
				clearSearchVal();
				Permissions_List();
		    }
		    
			function Permissions_List() {
		        $.ajax({
		        	type : "POST",
		        	dataType : "text",
		        	url : "/admin/ezOrgan/getPermissionsList.do",		        	
		        	data : {companyID : document.getElementById("ListCompany").value, type : type, pageNum : CurPage, pageSize : pageSize, searchType : document.getElementById("searchType").value, searchValue : document.getElementById("searchValue").value},
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
		                listview.SetID("lvPermissionList");
		                listview.SetMulSelectable(false);
		                listview.SetRowOnClick("Permissions_View");
		                listview.SetRowOnDblClick("PermissionsDb_View");
		                listview.SetHeightFree(true);
		                listview.DataSource(headerData);
		                listview.DataBind("AdminListView");
		                checkbox_header();
		                
		                var a = document.getElementById("lvPermissionList_TR_0");
		                
		                if (a== null || a == "") {
		                	
		                } else {
		                	a.style.backgroundColor = "rgb(255, 255, 255)";
		                	a.setAttribute("selected", "false");
		                	$("#lvPermissionList_TR_0").mouseout(function(){
		                		$("#lvPermissionList_TR_0").css("background-color", "rgb(255, 255, 255)");
		                	});
		                }
		                checkItems();
		                makePageSelPage();
		                setFucntion();
		        	},
		        	error : function(error){
		        	    alert("<spring:message code='ezOrgan.t2' />" + error);
		        	}
		        });		        
		    }
			
			function Permissions_View(obj) {
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
				var th = doc.getElementById("lvPermissionList_TH_0");
				var acList = doc.getElementById("lvPermissionList");
				
				th.innerHTML = "<input type= 'checkbox' id = 'checkAll' onchange= 'checkboxHeaderClick()'></input>";
				
				cnt = acList.children[1].childElementCount;
				
				var i = 0;
				for (i; i < cnt; i++) {
					var seq = acList.children[1].children[i].children[0].innerHTML;
					
					if (seq == "데이터가 없습니다.") {
						
					} else {
						acList.children[1].children[i].children[0].innerHTML = "<input type='checkbox' name='checks' class='checks' id='" 
						+ seq 
						+ "' value='" 
						+ seq 
						+ "' onchange='inputFunc(event,"
						+ seq + ")'></input>";
					}
				} 
			}
			
			var checkFlag = false;
			function checkboxHeaderClick() {
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
			
			
			function PermissionsDb_View() {
				
		        var listview = new ListView();
		        listview.LoadFromID("lvPermissionList");

		        if (listview.GetSelectedRows().length == 0) {
		            alert(strLang13);
		            return;
		        }
		        
		        var id = listview.GetSelectedRows()[0].getAttribute("DATA1");

		        if (CrossYN()) {
		            var OpenWin = window.open("/admin/ezOrgan/permissionsCheck.do?userID=" + encodeURI(id) + "&companyID=" + document.getElementById("ListCompany").value + "&DelType="+encodeURI(DelType) + "&type="+encodeURI(type), "Permissions_Check", GetOpenWindowfeature(1000, 620));
		            try { OpenWin.focus(); } catch (e) { }
		        } else {
		            window.showModalDialog("/admin/ezOrgan/permissionsCheck.do?userID=" + encodeURI(id) + "&companyID=" + document.getElementById("ListCompany").value + "&DelType="+encodeURI(DelType) + "&type="+encodeURI(type), "", "dialogHeight:580px; dialogWidth:970px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(1000, 620));
		        } 
				
		    }
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
		            Permissions_List();
		        }
		    }
			
			function makePageSelPage() {
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        document.getElementById("mailBoxInfo").innerHTML = "&nbsp;<span style='color:#017BEC;'>" + totalCnt + "</span>";
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var pageNum = CurPage;
		        
		        if (totalPage > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' /></span>";
		            PagingHTML += strtext;
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' /></span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' /></span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' /></span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' /></span>";
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
		                strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' /></span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "";
		                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' /></span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "";
		            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' /></span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		            strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' /></span>";
		            PagingHTML += strtext;
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' /></span>";
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
				var mail = doc.getElementById("email");
				
				add.addEventListener("click", Permissions_Add);
				del.addEventListener("click", Choose_Del);
				mail.addEventListener("click", email_onclick);
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
		        var pSelectTab = obj.getAttribute("divname");
		        clickTabID = obj.id;
		        DelType = pSelectTab;
		        type = pSelectTab + "=1";

		        CurPage = 1;
		        checkFlag = false;
		        clearSearchVal();
		        Permissions_List();
		    }
			
			function Tab1_NewTabIni(pTabNodeID) {
		        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
		            if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab1_MouserOver(this); };;
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab1_MouserOut(this); };;
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
			
			var permissions_check_dialogArguments = new Array();
		    var Permissions_Add = function() {
		        var listview = new ListView();
		        listview.LoadFromID("lvPermissionList");
		        var Params = new Array();
		        var result = "";
		       
		        if (CrossYN()) {
		            permissions_check_dialogArguments[0] = Params;
		            permissions_check_dialogArguments[1] = Permissions_Add_Complete;
		            var OpenWin = window.open("/admin/ezOrgan/permissionsCheck.do?companyID=" + document.getElementById("ListCompany").value + "&DelType="+encodeURI(DelType) + "&type="+encodeURI(type), "Permissions_Check", GetOpenWindowfeature(1000, 620));
		            try { OpenWin.focus(); } catch (e) { }
		        } else {
		            window.showModalDialog("/admin/ezOrgan/permissionsCheck.do?companyID=" + document.getElementById("ListCompany").value + "&DelType="+encodeURI(DelType) + "&type="+encodeURI(type), Params, "dialogHeight:580px; dialogWidth:970px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(1000, 620));
		            clearSearchVal();
		            Permissions_List();
		        }
		    }
		    
		    function Permissions_Add_Complete() {
		    	clearSearchVal();
		        Permissions_List();
		    }

			function Permissions_Del(mode) {			
 
				var dataList = new Array();
				var dataList2 = new Array();
				var dataList3 = new Array();
				var dataList4 = new Array();

				$("input[name='checks']:checked").each(function(){
					dataList.push(this.parentElement.parentElement.getAttribute("DATA1"));
					dataList2.push(this.parentElement.parentElement.getAttribute("DATA2"));
					dataList3.push(this.parentElement.parentElement.getAttribute("DATA3"));
					dataList4.push(this.parentElement.parentElement.getAttribute("DATA5"));
				}); 
				
				
				/* // 선택된 사원이 없을 경우
				if (dataList.length == 0) {
					alert(strLang13);
					return;
				} */

				/* // 권한 전체삭제
				var cData = "";
				if (mode == "ALL") {
					cData = "["+dataList3+"]" + strLang19 + " " + "<spring:message code='ezAddress.t362' />" + strLang20;
				} else {
					cData = "["+dataList3+"]" + strLang19 + document.getElementById(clickTabID).innerText + " " + strLang20;
				} */

				//if (confirm(cData)) {
					for (var i =0; i< dataList.length; i++) {
						if (mode == "ALL") {
							dataList2[i] = "";
						} else {
							var tempDelType = DelType;
							var DelValue = tempDelType + "=1";

							if (tempDelType == "") {
								tempDelType = "c=0";
							} else {
								tempDelType = tempDelType + "=0";
							}
							dataList2[i] = dataList2[i].replace(DelValue, tempDelType);
						}
					}

					jQuery.ajaxSettings.traditional = true; 

					$.ajax({
						type : "POST",
						dataType : "text",
						url : "/admin/ezOrgan/saveUserPermissionInfo.do",
						async : false,
						data : {
							cn : dataList, 
							extensionAttribute1: dataList2
						},
						success : function(result){
							if (mode == "ALL") {
								alert(strLang21);
								Permissions_List();
							} else {
								alert(strLang22);
								Permissions_List();
							}
						},
						error : function(){
							alert(strLang15);
						}
					});
				//}
				
			}

		    var email_onclick = function() {

		        /* var listview = new ListView();
		        listview.LoadFromID("lvPermissionList"); */
		        
		        var dataList3 = new Array();
				var dataList4 = new Array();
				
				$("input[name='checks']:checked").each(function(){
					dataList3.push(this.parentElement.parentElement.getAttribute("DATA3"));
					dataList4.push(this.parentElement.parentElement.getAttribute("DATA4"));
				});

		        /* if (listview.GetSelectedRows().length == 0) {
		            alert(strLang13);
		            return;
		        } */
		        
		     // 선택된 사원이 없을 경우
				if (dataList3.length == 0) {
					alert(strLang13);
					return;
				}

		        var pheight = window.screen.availHeight;
		        var conHeight = pheight * 0.8;
		        var pwidth = window.screen.availWidth;
		        var pTop = (pheight - conHeight) / 2;
		        var pLeft = (pwidth - 890) / 2;
		        var MsgTo = new Array();

		        for (var i =0; i<dataList3.length; i++) {
			        MsgTo[i] = "\"" + dataList3[i]+ "\" <" +dataList4[i]+ ">";
		        }
		        console.log(MsgTo);
		        /* 2017-01-02 이효민사원
		        if (CrossYN() || pNoneActiveX == "YES") {
		            window.open("/myoffice/ezEmail/mail_write_Cross.aspx?cmd=NEW&msgTo=" + encodeURIComponent(MsgTo), "",
		                           "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		        }
		        else {
		            if (pUse_Editor == "")
		                window.open("/myoffice/ezEmail/mail_write.aspx?cmd=NEW&msgTo=" + encodeURIComponent(MsgTo), "",
		                                "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		            else {
		                window.open("/myoffice/ezEmail/mail_write_IE.aspx?cmd=NEW&msgTo=" + encodeURIComponent(MsgTo), "",
		                            "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
		            }
		        } */
		        window.open("/ezEmail/mailWrite.do?cmd=NEW&msgto=" + encodeURIComponent(MsgTo), "",
                        "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = 890px, status = no, toolbar=no, menubar=no,location=no, resizable=1"); 
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
		    	var dataList = new Array();
				var dataList2 = new Array();
				var dataList3 = new Array();
				var dataList4 = new Array();
				var types = document.getElementById(clickTabID).innerText;

				$("input[name='checks']:checked").each(function(){
					dataList.push(this.parentElement.parentElement.getAttribute("DATA1"));
					dataList2.push(this.parentElement.parentElement.getAttribute("DATA2"));
					dataList3.push(this.parentElement.parentElement.getAttribute("DATA3"));
					dataList4.push(this.parentElement.parentElement.getAttribute("DATA5"));
				});
				
				testObj.dataList = dataList;
				testObj.dataList2 = dataList2;
				testObj.dataList3 = dataList3;
				testObj.dataList4 = dataList4;
				typeStyle = types;

				// 선택된 사원이 없을 경우
				if (dataList.length == 0) {
					alert(strLang13);
					return;
				}
				
		    	GetOpenWindow("/admin/ezOrgan/chooseDeletege.do","chooseDeletege", 600, 200);
		    }
		    
		    /* function choose_Del_complete(data) {
		    	console.log(data);
		    	Permissions_Del(data);
		    } */
		    
	    </script>
	</head>
	<body class="mainbody">
	    <xml id="listviewheader" style="display:none">
			<LISTVIEWDATA>
		    	<HEADERS>
		    	    <HEADER>
						<WIDTH>5%</WIDTH>
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
		        		<WIDTH>10%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t68' /></NAME>
		        		<WIDTH>15%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t91' /></NAME>
		        		<WIDTH>25%</WIDTH>
		        		<STYLE>border-top:0px;</STYLE>
		      		</HEADER>
		      		<HEADER>
		        		<NAME><spring:message code='ezOrgan.t95' /></NAME>
		        		<WIDTH>10%</WIDTH>
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
		    	<spring:message code='ezOrgan.t00005' /><span id="mailBoxInfo"></span>
		    	<select class="companySelect" id="ListCompany" onchange="company_change()">
	            	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
	            </select>
		    </h1>
		    <div id="mainmenu">
		        <ul style="margin-top:15px;">
		            <li class="important"><span id="add"><spring:message code='ezOrgan.mse3' /></span></li>
		            <!-- <li style="padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
		            <%-- <li><span onClick="Permissions_Del('ALL')"><spring:message code='ezOrgan.t00009' /></span></li> --%>
		            <!-- <li><span class="icon16 icon16_delete" onClick="Permissions_Del('MOD')"></span></li> -->
		            <li><span class="icon16 icon16_delete" id="del"></span></li>
		            <!-- <li style="padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
		            <li id="email"><span class="icon16 icon16_mail_gray"></span></li>
		            <span style="float: right; font-weight: normal; color: black; clear:inherit;margin-left:1px">
		            	<select id="searchType" style="width:80px;">
							<option selected="" value="displayname"><spring:message code='ezOrgan.t67' /></option>
							<option value="cn"><spring:message code='ezOrgan.t218' /></option>
							<option value="title"><spring:message code='ezOrgan.t69' /></option>
							<option value="description"><spring:message code='ezOrgan.t68' /></option>
							<option value="mail"><spring:message code = 'ezOrgan.t91' /></option>
							<option value="telephonenumber"><spring:message code='ezOrgan.t95' /></option>
							<option value="company"><spring:message code= 'ezOrgan.t123' /></option>
						</select>
						
						<input id="searchValue" onkeypress="if(event.keyCode==13) {searchList(); return false;}" onfocus="clearSearchVal();" style="height: 29px;border: 1px solid #cbcbcb; border-right:0px;">
						<a style="float: right"><img src="/images/bsearch_new.gif" border="0" onclick="searchList()" style="height:29px;"></a>
		            </span>
		        </ul>
		    </div>
		    <script type="text/javascript">
		        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");        
		    </script>
		    <div class="portlet_tabpart01" style="padding-bottom:3px; width:100%;">
		        <div class="portlet_tabpart01_top" id="tab1">
	                <p id="Permission_sub1"><span divname="c" id="1tab1"><spring:message code='ezOrgan.t291' /></span></p>
	                <p id="Permission_sub2"><span divname="k" id="1tab2"><spring:message code='ezOrgan.t293' /></span></p>
	                <p id="Permission_sub3"><span divname="g" id="1tab3"><spring:message code='ezOrgan.t295' /></span></p>
	                <p id="Permission_sub4"><span divname="a" id="1tab4"><spring:message code='ezOrgan.t292' /></span></p>
	                <p id="Permission_sub5" <c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><span divname="i" id="1tab5"><spring:message code='ezOrgan.t294' /></span></p>
	                <p id="Permission_sub6"><span divname="n" id="1tab6"><spring:message code='ezOrgan.t297' /></span></p>
	                <p id="Permission_sub7"><span divname="l" id="1tab7"><spring:message code='ezOrgan.t296' /></span></p>
	                <p id="Permission_sub8" <c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><span divname="w" id="1tab8"><spring:message code='ezOrgan.t301' /></span></p>
	                <p id="Permission_sub9" <c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><span divname="m" id="1tab9"><spring:message code='ezOrgan.t300' /></span></p>
	                <c:if test="${approvalForDoc == 'Y'}">
	                	<p id="Permission_sub10"><span divname="f" id="1tab10"><spring:message code='ezOrgan.lhj1' /></span></p>
	                </c:if>
	                <c:if test="${useWebfolder == 'YES'}">
	                <p id="Permission_sub11"><span divname="wf" id="1tab11"><spring:message code='ezOrgan.t303' /></span></p>
	                </c:if>
	                <p id="Permission_sub12" <c:if test="${use_attitude != 'YES'}">style="display:none;"</c:if>><span divname="wa" id="1tab12"><spring:message code='ezOrgan.kbm01' /></span></p>
		        </div>
		    </div>
		    <!-- 2018-08-06 김보미 - 페이지 위치 고정 -->
<!-- 		    <div class="listview" style="Width:100%;"> -->
<!-- 		        <div id="AdminListView" style="border: 0px solid #ddd; Width: 100%; Height:540px; /* overflow-x: auto; */ BACKGROUND-COLOR: white; /* overflow-y:auto; */"></div> -->
<!-- 		    </div> -->
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