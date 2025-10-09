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
			var isAdmin = ${isAdmin};
			var testObj = {};
			var type = "";
			var useExternalMailServer = "<c:out value='${useExternalMailServer}'/>";
			var exportingExcel = false;
			var itemseq; // 2023-07-31 전인하 - 변수 선언부분을 상단으로 변경 (not undefined 에러 방지)

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

			// 2023-06-26 남진구 - '조직도>겸직관리>엑셀 내려받기'
			function excelExport() {
				if (exportingExcel) {
					return;
				}

				showProgress();
				exportingExcel = true;

				$.ajax({
					type: "POST",
					url: "/admin/ezOrgan/exportFileLogs.do",
					data: {
						"selectedId"  : "",
						companyID : document.getElementById("ListCompany").value,
						isPermissionsList : "Y"
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;

						switch(code) {
							case 0:
								var url = "/admin/ezOrgan/downloadExcel.do?fileName=" + encodeURIComponent(data.path);
								AttachDownFrame.location.href = url;
								break;
							case 1:
								alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 2:
								alert("<spring:message code='ezWebFolder.t300'/>");
								break;
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				}).complete(function() {
					hideProgress();
					exportingExcel = false;
				});
			}

			function showProgress() {
				// $('#progressPanel').width() = 220, $('#loadingLayer').width() = 168
				var leftSize = (window.innerWidth - 388)/2 + "px"
				document.getElementById("loadingLayer").style.left = leftSize;

				document.getElementById("progressPanel").style.display = "";
				document.getElementById("loadingLayer").style.display = "";

				parent.document.getElementById("left").contentWindow.showProgress();
			}

			function hideProgress() {
				document.getElementById("progressPanel").style.display = "none";
				document.getElementById("loadingLayer").style.display = "none";

				parent.document.getElementById("left").contentWindow.hideProgress();
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
		                // 2019-01-09 황윤호 (권한관리 Db클릭 메서드 안쓰기로 함)
		                //listview.SetRowOnDblClick("PermissionsDb_View");
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
			
			function Permissions_View(obj) {
				var className = window.event.target.getAttribute('class');
				if(className === 'checks') {
					return;
				}

				var doc = window.document;
				// 2023-08-11 전인하 - 겸직/사용자 별 권한 설정 기능 - 각 체크박스의 id값 달라짐에 따라 id값 사용부 수정
				itemseq = document.getElementById(obj).childNodes[0].childNodes[0].getAttribute("id");
				if(itemseq == "0") {
					return;
				}

				// 2023-08-08 이사라 - 체크박스 id에 '.' 이 들어가는 경우 link로 인식하여 체크되지 않는 오류 수정
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
				var th = doc.getElementById("lvPermissionList_TH_0");
				var acList = doc.getElementById("lvPermissionList");
				
				th.innerHTML = "<input type= 'checkbox' id = 'checkAll' onchange= 'checkboxHeaderClick()'></input>";
				
				cnt = acList.children[1].childElementCount;
				
				var noItemsChk = acList.children[1].children[0].getAttribute("id");
				
				if (cnt <= 1 && noItemsChk == "lvPermissionList_TR_noItems") {
					return;
				}
				
				var i = 0;
				for (i; i < cnt; i++) {
					var seq = acList.children[1].children[i].children[0].innerHTML;
					
					// 2023-07-20 전인하 - 관리자 > 조직도 > 권한관리 > 겸직/사용자별로 권한 설정 기능
					// 리스트에서  CN이 PK로 쓰이지 않음에 따라(한 사용자에 대해 겸직별로 다양한 권한 부여 가능) 고유아이디 생성, 부여
					acList.children[1].children[i].children[0].innerHTML = "<input type='checkbox' name='checks' class='checks' id='" 
					+ seq + "_" + i
					+ "' value='" 
					+ seq 
					+ "' onchange='inputFunc(event," + seq + "_" + i + ")'></input>";
				} 
			}
			
			var checkFlag = false;
			function checkboxHeaderClick() {
				var doc = window.document;
				var acList = doc.getElementById("lvPermissionList");
				// 데이터가 있을 경우에만
				if(acList.children[1].children[0].id !== 'lvPermissionList_TR_noItems'){
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
				    // 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 리스트 체크박스 동작 개선
				    // 체크된 tr들을 등록/삭제/메일발송 팝업으로 넘길 때 userID와 deptID 데이터를 동시에 넘김
				    var tempObj = document.getElementById(this.id).parentNode.parentNode;
					if($(this).is(":checked")){
						rowList.push(tempObj.getAttribute("data1") + ";" + tempObj.getAttribute("data6") + ";" + tempObj.getAttribute("data7")); // this: userId, data6: deptId, data7 : jobId
					}
				});
			}
			
			function inputFunc(event) {
				checkItems();
				
                // 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 리스트 체크박스 동작 개선
                // 체크된 TR의 배경 음영이 비정상동작하는 것을 수정
                
                var permissionListObj = document.getElementById("lvPermissionList").childNodes[1].childNodes;
                for (var i = 0; i < permissionListObj.length; i++) {
                    var tempPermissionObj = permissionListObj[i].getAttribute("data1") + ";" + permissionListObj[i].getAttribute("data6") + ";" + permissionListObj[i].getAttribute("data7");
                    if (rowList.includes(tempPermissionObj)) {
                        $("#" + permissionListObj[i].id + " td").css("background-color", "rgb(241, 248, 255)");
                        $("#" + permissionListObj[i].childNodes[1].childNodes[1]).prop("checked", true);
                    } else {
                        $("#" + permissionListObj[i].id + " td").css("background-color", "rgb(255, 255, 255)");
                        $("#" + permissionListObj[i].childNodes[1].childNodes[1]).prop("checked", false);
                    }
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
				var mail = doc.getElementById("email");
				
				add.addEventListener("click", Permissions_Add);
				del.addEventListener("click", Choose_Del);
				if(useExternalMailServer == 'NO')
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
		        rowList = [];
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
		            try { OpenWin.focus(); } catch (e) {console.log(e);}
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
				var dataList5 = new Array();
				// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 권한 삭제 동작 변수에 deptid, jobid 리스트 추가
				var dataList6 = new Array(); // deptId
				var dataList7 = new Array(); // jobId

				$("input[name='checks']:checked").each(function(){
					dataList.push(this.parentElement.parentElement.getAttribute("DATA1"));
					dataList2.push(this.parentElement.parentElement.getAttribute("DATA2"));
					dataList3.push(this.parentElement.parentElement.getAttribute("DATA3"));
					dataList4.push(this.parentElement.parentElement.getAttribute("DATA5"));
					dataList6.push(this.parentElement.parentElement.getAttribute("DATA6"));
					if (this.parentElement.parentElement.getAttribute("DATA7") == '') { // jobId가 없음 - 원직일 경우
					    dataList7.push('empty');
					} else {
					    dataList7.push(this.parentElement.parentElement.getAttribute("DATA7"));
					}
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
							dataList5.push(dataList2[i]);	// 2022-01-20 이사라 - 변경하는 권한을 추출하기 위해 값 전체 컨트롤러에 넘김
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
							dataList5.push(tempDelType);	// 2022-01-20 이사라 - 변경하는 권한
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
							extensionAttribute1: dataList2,
							permissionChType : dataList5,
							dept : dataList6,
							job : dataList7,
							mode : mode
						},
						success : function(result){
						    Permissions_List();
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
				
		    	GetOpenWindow("/admin/ezOrgan/chooseDeletege.do?type=" + encodeURIComponent(types),"chooseDeletege", 600, 210);
		    }
		    
		    /* function choose_Del_complete(data) {
		    	console.log(data);
		    	Permissions_Del(data);
		    } */

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
		    	<spring:message code='ezOrgan.t00005' /><span id="mailBoxInfo"></span>
		    	<span class="title_bar"><img src="/images/name_bar.gif"></span>
		    	<select class="companySelect" id="ListCompany" onchange="company_change()">
	            	<c:forEach var="item" items="${list}">
	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	            	</c:forEach>
	            </select>
	            
	            <span class="searchForm">
	            	<select id="searchType" class="text"; style="width:80px;height: 27px; margin-right: 0px; border: 1px solid #cbcbcb;">
						<option selected="" value="displayname"><spring:message code='ezOrgan.t67' /></option>
						<option value="cn"><spring:message code='ezOrgan.t218' /></option>
						<option value="title"><spring:message code='ezOrgan.t69' /></option>
						<option value="description"><spring:message code='ezOrgan.t68' /></option>
						<option value="mail"><spring:message code = 'ezOrgan.t91' /></option>
						<option value="telephonenumber"><spring:message code='ezOrgan.t95' /></option>
						<option value="company"><spring:message code= 'ezOrgan.t123' /></option>
					</select>
					
					<input id="searchValue" class="searchinputBox" onkeypress="if(event.keyCode==13) {searchList(); return false;}" onfocus="clearSearchVal();" style="ime-mode: active;height: 27px;border: 1px solid #cbcbcb;">
					<a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onclick="searchList()"></a>
	            </span>
		    </h1>
		    <div id="mainmenu">
		        <ul style="margin-top:15px;">
		            <li class="important"><span id="add"><spring:message code='ezOrgan.mse3' /></span></li>
		            <!-- <li style="padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
		            <%-- <li><span onClick="Permissions_Del('ALL')"><spring:message code='ezOrgan.t00009' /></span></li> --%>
		            <!-- <li><span class="icon16 icon16_delete" onClick="Permissions_Del('MOD')"></span></li> -->
		            <li><span class="icon16 icon16_delete" id="del"></span></li>
		            <!-- <li style="padding-right:2px; cursor: default;"><img src="/images/i_bar.gif" alt=""></li> -->
		            <c:if test="${ useExternalMailServer eq 'NO'}">
		            <li id="email"><span class="icon16 icon16_mail_gray"></span></li>
		            </c:if>
					<li id="btnSave"><span onClick="excelExport()"><spring:message code='ezStatistics.t1003' /></span></li>
		        </ul>
		    </div>
		    <script type="text/javascript">
		        selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");        
		    </script>
		    <div class="portlet_tabpart01" style="padding-bottom:3px; width:100%;">
		    <%-- 2023-09-18 전인하 - 웹폴더 권한 코드를 f로 변경, 결재조회관리자 권한코드를 q로 변경, 전체 권한 코드를 주석으로 남김 --%>
		    <%-- 권한을 추가할 권한코드는 알파벳 한자리로 작성하여야 합니다. 2자리 이상으로 작성할 경우, 끝자리가 서로 같은 권한이 잘못 부여되는 오류동작을 일으킵니다. --%>
		    <%-- c:전체관리자 / k:회사관리자 / g:부서관리자 / a:수발신담당자 / i:심사자 / n:게시관리자 / l:설문관리자 / w:업무담당자 / m:기록물관리책임자 / q:결재조회관리자 / f:웹폴더관리자 / e:근태관리자 --%>
		        <div class="portlet_tabnew01_top" id="tab1">
	                <p id="Permission_sub1"><span divname="c" id="1tab1"><spring:message code='ezOrgan.t291' /></span></p>
	                <p id="Permission_sub2"><span divname="k" id="1tab2"><spring:message code='ezOrgan.t293' /></span></p>
	                <p id="Permission_sub3"><span divname="g" id="1tab3"><spring:message code='ezOrgan.t295' /></span></p>
	                <c:if test="${packageType == 'standard'}">
	                	<p id="Permission_sub4"><span divname="a" id="1tab4"><spring:message code='ezOrgan.t292' /></span></p>
		                <p id="Permission_sub5" <c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><span divname="i" id="1tab5"><spring:message code='ezOrgan.t294' /></span></p>
	                </c:if>
	                <c:if test="${packageType != 'mail' and useBoard == 'YES'}">
		                <p id="Permission_sub6"><span divname="n" id="1tab6"><spring:message code='ezOrgan.t297' /></span></p>
	                </c:if>
	                <c:if test="${packageType == 'standard'}">
	                    <c:if test="${useSurvey == 'YES'}">
		                <p id="Permission_sub7"><span divname="l" id="1tab7"><spring:message code='ezOrgan.t296' /></span></p>
		                </c:if>
		                <p id="Permission_sub8" <c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><span divname="w" id="1tab8"><spring:message code='ezOrgan.t301' /></span></p>
		                <p id="Permission_sub9" <c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><span divname="m" id="1tab9"><spring:message code='ezOrgan.t300' /></span></p>
		                <c:if test="${approvalForDoc == 'Y'}">
		                	<p id="Permission_sub10"><span divname="q" id="1tab10"><spring:message code='ezOrgan.lhj1' /></span></p>
		                </c:if>
		                <c:if test="${useWebfolder == 'YES'}">
		                <p id="Permission_sub11"><span divname="f" id="1tab11"><spring:message code='ezOrgan.t303' /></span></p>
		                </c:if>
		                <p id="Permission_sub12" <c:if test="${use_attitude != 'YES'}">style="display:none;"</c:if>><span divname="e" id="1tab12"><spring:message code='ezOrgan.kbm01' /></span></p>
		                <p id="Permission_sub13"><span divname="v" id="1tab13"><spring:message code='ezOrgan.lhr01' /></span></p>
		                <%--2023-02-10 홍승비 - 표준모듈 기준으로 일상감사, 준법지원인 기능 사용하지 않음 --%>
		                <%-- <p id="Permission_sub13" <c:if test="${approvalFlag == 'S'}">style="display:none;"</c:if>><span divname="s" id="1tab13"><spring:message code='ezOrgan.t9904' /></span></p> --%>
	                </c:if>
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
		<iframe name="AttachDownFrame" id="AttachDownFrame" style="display:none"></iframe>
		<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="progressPanel">&nbsp;</div>
		<span class="loading_layer" style="z-index:6000;position:absolute;top:350px;left:350px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t680' /></span></span>
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>
