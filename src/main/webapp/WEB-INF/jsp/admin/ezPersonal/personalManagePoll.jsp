<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezPersonal.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			var totalCount = "";
			var progressPollFlag = "";
			var TotalCount;
			var totalPage = "";
			var BlockSize = 10;
			var pageNum = 1;
			var PageSize = 15;
			var progressPollFlag = "false";
			
			var strLang1 = "<spring:message code = 'ezPersonal.t10002' />";
			var strLang2 = "<spring:message code = 'ezPersonal.t10000' />";
			var strLang3 = "<spring:message code = 'ezPersonal.t10001' />";
			var strLang4 = "<spring:message code = 'ezPersonal.t223' />";
			var strLang5 = "<spring:message code = 'ezQuestion.t312' />";
	
			window.onload = function () {
				ifrmPreViewH.document.getElementById("ifrmviewEmptyText").innerText = "선택된 설문이 없습니다.";
			}
			
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
		        }
			};
			
			$(document).ready(function() {
				if (document.getElementById("ListCompany").length == 0) {
					alert("<spring:message code = 'ezPersonal.t106' />");
				}
				else {
				//    document.getElementById("ListCompany").selectedIndex = 0;
				}
				getLightPollConfig();
				makelist();
				//2018-08-06 김보미 - 페이지 위치 고정
				windowResize();
			});
			
	        function makelist() {
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezPersonal/managePollList.do",
	            	dataType : "text",
	            	data : {companyID : encodeURIComponent(document.getElementById("ListCompany").value), page : pageNum},
	            	success : function (result) {
	            		event_PollList(loadXMLString(result));
	            	}
	            });
	        }


			function event_PollList(result) {
				try {
					document.getElementById("AccessList").innerHTML = "";
					var xmldom = result
					var headerData = createXmlDom();
					headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());

					if (CrossYN()) {
						var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
						var Node = headerData.importNode(xmlRtn, true);
						headerData.documentElement.appendChild(Node);
					} else {
						var xmlRtn = result.documentElement.getElementsByTagName("ROWS")[0];
						headerData.documentElement.appendChild(xmlRtn);
					}

					var listview = new ListView();
					listview.SetID("AccessListView");
					listview.SetSelectFlag(false);
					listview.SetMulSelectable(true);
					listview.SetRowOnClick("PollList_onClick");
					listview.SetRowOnDblClick("PollList_onDblclick");
					listview.DataSource(headerData);
					listview.DataBind("AccessList");
					//listview.DataSource(xmldom);
					listview.RowDataBind();
					checkbox_header();
					xmldomNode = null;

					if (CrossYN() && navigator.userAgent.indexOf("Trident/7.0") < 0) {
						TotalCount = parseInt(SelectSingleNodeValueNew(xmldom, "TOTALCNT"));
						pageNum = parseInt(SelectSingleNodeValueNew(xmldom, "CURPAGE"));
					} else if (navigator.userAgent.indexOf("Trident/7.0") > 0) {
						//IE11일때 추가
						TotalCount = parseInt(SelectSingleNodeValueNew(xmldom.documentElement, "TOTALCNT"));
						pageNum = parseInt(SelectSingleNodeValueNew(xmldom.documentElement, "CURPAGE"));
					} else {
						TotalCount = parseInt(SelectSingleNodeValueNew(xmldom.documentElement, "TOTALCNT"));
						pageNum = parseInt(SelectSingleNodeValueNew(xmldom.documentElement, "CURPAGE"));
					}

					//2018-08-02 김보미 - 데이터가 없을 때
					if (TotalCount == null || TotalCount == 0) {
						var TR_noItems = "<tr id='Poll_TR_noItems'><td style='text-align: center;' colspan='6'>" + strLang5 + "</td></tr>";
						$("#AccessListView tbody").eq(0).html(TR_noItems);
					}

					totalPage = Math.ceil(new Number(TotalCount / PageSize));

					if (CrossYN()) {
						progressPollFlag = SelectSingleNodeValueNew(xmldom, "PROFLAG");
					} else {
						progressPollFlag = SelectSingleNodeValueNew(xmldom.documentElement, "PROFLAG");
					}
					rowListSelect();
					checkItems();
					makePageSelPage();
				} catch (e) {
				}
			}


			// xml data -> input checkbox
			var cnt;
			function checkbox_header() {
				var doc = window.document;
				var th = doc.getElementById("AccessListView_TH_0");
				var acList = doc.getElementById("AccessListView");
				th.innerHTML = "<input type='checkbox' id = 'checkAll' onchange='checkboxHeaderClick()'></input>";
				
				cnt = acList.children[1].childElementCount;
				
				var i = 0;
				for(i;i<cnt;i++) {
					var seq = acList.children[1].children[i].children[0].innerHTML;
					var jinhangFlag = acList.children[1].children[i].children[5].innerHTML;
					acList.children[1].children[i].children[0].innerHTML = "<input type='checkbox' name='checks' class='checks' id='" + seq + "' value='" + seq +"'></input>";
					if(jinhangFlag == 1) {
						acList.children[1].children[i].children[5].innerHTML = "<img src='/images/admin/inuse.png' border='0' class='jinhang'>";
					} else {
						acList.children[1].children[i].children[5].innerHTML = "<img src='/images/admin/inuse_end.png' border='0' class='jinhang'>";
					}
				}
			}


			var checkFlag = false;
			function checkboxHeaderClick() {
				if(checkFlag){
					checkFlag = false;
					$(".checks").prop("checked",false);
					$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");
				}else {
					checkFlag = true;
					$(".checks").prop("checked",true);
					$("#contentlist tr td").css("background-color", "rgb(228, 232, 236)");
				}
				checkItems();
			}


			var rowList = new Array();
			function checkItems() {
				rowList = [];
				$("input:checkbox[name='checks']").each(function(){
					if($(this).is(":checked")) {
						rowList.push(this.value);
					}
				});
			}
			
			
			function rowListSelect() {
				var len = rowList.length;
				for(var i=0; i<len; i++) {
					var tempItemSeq = rowList.pop();	
					if(document.getElementById(tempItemSeq) != null) {
						$("#" + tempItemSeq).prop("checked", true);
						var tempID = $("#" + tempItemSeq)[0].parentNode.parentNode.id;
						$("#" + tempID + " td").css("background-color", "rgb(228, 232, 236)");
					}
				}
				
				if(checkFlag) {
					$("#checkAll").prop("checked",true);
				} else {
					$("#checkAll").prop("checked",false);
				}
			}
			
			var itemseq;
			function PollList_onClick(obj) {
				var doc = window.document;
				itemseq = document.getElementById(obj).getAttribute("DATA1");
				if(itemseq == "0") {
					return;
				}
				
				if(checkFlag) {
					var color = $("#" + obj + " td").css("background-color");
					if(color === "rgb(228, 232, 236)") {
						$("#" + obj + " td").css("background-color", "rgb(255, 255, 255)");
						$("#" + itemseq).prop("checked", false);
					} else {
						$("#" + obj + " td").css("background-color", "rgb(228, 232, 236)");
						$("#" + itemseq).prop("checked", true);
					}
				} else {
					$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");
					$(".checks").prop("checked",false);
					if($("#" + itemseq).is(":checked")) {
						$("#" + obj + " td").css("background-color", "rgb(255, 255, 255)");
						$("#" + itemseq).prop("checked", false);
					} else {
						$("#" + obj + " td").css("background-color", "rgb(228, 232, 236)");
						$("#" + itemseq).prop("checked", true);
					}
				}
				
				checkItems();
				doc.getElementById("ifrmPreViewH").style.display = "";
				showPreview(isPreview, itemseq);
			}
		    
		    function PollList_onDblclick(obj) {
		        var itemseq = document.getElementById(obj).getAttribute("DATA1");
		        if (itemseq == "0") {
		            return;
		        }
		        
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 455) / 2;
		        var top = (heigth - 400) / 2;
		
		        checkItems();
		        window.open("/ezPersonal/pollResult.do?itemSeq=" + itemseq, "", "height=400px,width=455px, status = no, toolbar=no, menubar=no,location=no, resizable=0,top=" + top + ",left = " + left);
		    }
		    
		    
		    function company_change() {
		        makelist();
		    }
		    
		    var addpoll_cross_dialogArguments = new Array();
		    function add_poll() {
		        if (totalCount != "0" && progressPollFlag == "true") {
		            if (!confirm("<spring:message code = 'ezPersonal.t234' />")) {
		                return;
		            }
		        }
		        
		        if (CrossYN()) {
		            addpoll_cross_dialogArguments[0] = document.getElementById("ListCompany").value;
		            addpoll_cross_dialogArguments[1] = add_poll_Complete;
		            var AddPoll_Cross = window.open("/admin/ezPersonal/addPoll.do", "AddPoll_Cross", GetOpenWindowfeature(450, 550));
		            try { AddPoll_Cross.focus(); } catch (e) {
		            }
		        } else {
		            rtnValue = window.showModalDialog("/admin/ezPersonal/addPoll.do", document.getElementById("ListCompany").value, "dialogHeight:550px;dialogwidth:450px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(430, 550));
		
		            if (typeof (rtnValue) != "undefined") {
		                company_change();
		            }
		        }
		    }
	
	        function add_poll_Complete(rtv) {
	            if (typeof (rtv) != "undefined") {
	                company_change();
	            }
	        }
			
			
			var pollList = "";
			function delete_poll() {
				var delCnt = 0;
				var inUseFlag = false;
				$("input:checkbox[name='checks']").each(function(){
					if($(this).is(":checked")) {
						pollList += this.value + ";"
						delCnt = delCnt + 1;
						var tempUse = $(this)[0].parentNode.parentNode.children[5].innerHTML;
						if(tempUse === "1") {
							inUseFlag = true;
						}
					}
				});

				if(!pollList) {
					alert("선택된 설문이 없습니다.");
					return;
				}

				// 삭제 여부 확인
				if(inUseFlag) {
					if (!confirm("진행중인 설문을 삭제하시겠습니까?")){
						return;
					}
				} else {
					if (!confirm("설문을 삭제하시겠습니까?")){
						return;
					}
 				}

				$.ajax({
					type : "POST",
					url : "/admin/ezPersonal/delPoll.do",
					async : false,
					data : {"pollList" : pollList},
					dataType : "text",
					success : function(result) {
						if (result == "OK") {
							alert("<spring:message code = 'ezPersonal.t238' />");
							// 페이지가 1보다 크고, data가 없을 경우
							if((cnt - delCnt == 0) && pageNum > 1) {
								pageNum = pageNum -1 ;
							}
							itemseq=0;
							showPreview(isPreview, 0);
							rowList = [];
							makelist();
						} else {
							alert("<spring:message code = 'ezPersonal.t237' />");
						}
					}
				});
				pollList = "";
			}
			
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		    
		    function makePageSelPage() {
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span style='color:#017BEC;'>" + TotalCount + "</span>";
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        
		        if (totalPage > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' ></span>";
		            PagingHTML += strtext;
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' ></span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' ></span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
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
		        
		        //2018-08-02 김보미 - 데이터가 하나도 없을때 디폴트 페이징
	            if (i == 1) {
	            	strtext = "<span class='on'>" + i + "</span>";
                    PagingHTML += strtext;
	            }
		        
		        if (totalPage > BlockSize) {
		            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
		                strtext = "";
		                strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif' ></span>";
		                PagingHTML += strtext;
		            } else {
		                strtext = "";
		                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
		                PagingHTML += strtext;
		            }
		        } else {
		            strtext = "";
		            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
		            PagingHTML += strtext;
		        }
		        
		        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		            strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' ></span>";
		            PagingHTML += strtext;
		        } else {
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' ></span>";
		            PagingHTML += strtext;
		        }
		        
		        PagingHTML += "</div>";
		        td_Create1(PagingHTML);
		    }
		    
		    function goToPageByNum(Value) {
		        pageNum = Value;
		        makePageSelPage();
		        makelist();
		    }
		    
		    function selbeforeBlock() {
		        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    
		    function selbeforeBlock_one() {
		        if (parseInt(pageNum - 1) > 0) {
		            goToPageByNum(parseInt(pageNum - 1));
		        } else {
		            return;
		        }
		    }
		    
		    function selafterBlock() {
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    
		    function selafterBlock_one() {
		        if (parseInt(pageNum + 1) <= totalPage) {
		            goToPageByNum(parseInt(pageNum + 1));
		        } else {
		            return;
		        }
		    }
		    
		    function selNum(pselNum) {
		        pageNum = pselNum;
		        makelist();
		    }
		    
		    function selNext() {
		        pageNum = pageNum + 1;
		        makelist();
		    }
		    
		    function selPrev() {
		        pageNum = pageNum - 1;
		        makelist();
		    }
		    
		    function td_Create(strtext) {
		        tblPageNum.innerHTML = tblPageNum.innerHTML + strtext;
		    }
		    
            //2018-08-06 김보미 - 페이지 위치 고정
		    $(window).on("resize", function(){
	            windowResize();
	        });
		    
			var conH;
			function windowResize() {
				var doc = window.document;
				var mainView = doc.getElementById("mainView");
				var height = doc.documentElement.clientHeight - 122 - document.getElementById("mainmenu").clientHeight;
				if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
					height = height - 30;
				}
				
				conH = height;
				if(isPreview == 0) {
					doc.getElementById("contentlist").style.height = height + "px";
					doc.getElementById("contentlist").style.overflow = "auto";
				} else if ( isPreview == 2) {
					doc.getElementById("contentlist").style.height = height + "px";
					doc.getElementById("contentlist").style.overflow = "auto";
					doc.getElementById("previewH").style.height = height + 47 + "px";
					doc.getElementById("previewmail_bar_h").style.height = height + 47 + "px";
					doc.getElementById("ifrmPreViewH").style.height = height + 47 + "px";
				}
			}
			
			// 빠른 설문 config 조회
			var isPreview = 0;
			function getLightPollConfig() {
				$.ajax({
					type : "POST",
					dataType : "json",
					aysnc : false,
					url : "/admin/ezPersonal/getLightPollConfig.do",
					success : function(result) {
						isPreview = result["configVO"].isPreview;
						changeImg(isPreview);
						setPreview(isPreview);
					}, error: function(xhr, option, error){
						isPreview = 0;
					}
				});
			}
			
			
			// 빠른 설문 config 업데이트
			var isPreview = 0;
			function PreviewRayerChange(direction) {
				var temp = isPreview;
				switch(direction)
				{
					case "NONE" : 
						isPreview = 0;
						break;
					case "H" :
						isPreview = 2;
						break;
				}
							  
				$.ajax({
					type : "POST",
					dataType : "text",
					data : {isPreview : isPreview},
					aysnc : false,
					url : "/admin/ezPersonal/setLightPollConfig.do",
					success : function(result) {
						changeImg(isPreview);
						setPreview(isPreview);
					}, error: function(xhr, option, error){
						isPreview = temp;
					}
				});
			}
			
			
			// 미리보기 버튼 교체
			function changeImg(previewNum) {
				var doc = window.document;
				var noneImage = doc.getElementById("PreViewNone");
				var leftImage = doc.getElementById("PreViewleft");
				
				noneImage.className = "icon16 btn_noframe";
				leftImage.className = "icon16 btn_leftframe";
				
				switch(previewNum) {
					case 0 :
						noneImage.className = "icon16 btn_onnoframe";
						
						break;
					case 2 :
						leftImage.className = "icon16 btn_onleftframe";
						break;
				}
			}
			
			
			// 미리보기창 show
			function setPreview(previewNum) {
				var conlistH = conH
				var doc = window.document;
				var mainView = doc.getElementById("mainView");
				var previewH = doc.getElementById("previewH");
				var PreviewRayerH = doc.getElementById("PreviewRayerH");
				var contentlistH = doc.getElementById("contentlist");
				var previewmail_bar_h = doc.getElementById("previewmail_bar_h");
				
				switch(previewNum) {
				case 0 :
					previewH.style.display = "none";
					mainView.style.width = "100%";
					doc.getElementById("contentlist").style.height = conlistH + "px";					
					break;
				case 2 :
					doc.getElementById("contentlist").style.height = conlistH + "px";
					mainView.style.width = "70%";
					previewH.style.width = "30%";
					previewH.style.height = conlistH + 47 + "px";
					previewH.style.display = "";
					previewmail_bar_h.style.height = conlistH + 47 + "px";
					PreviewRayerH.style.display = "";
					if(itemseq!=0) {
						doc.getElementById("ifrmPreViewH").style.display = "";
					}
					doc.getElementById("ifrmPreViewH").style.height = conlistH + 47 + "px";
					break;
				}
				
				// row가 선택 되어 있다면
				if(itemseq) {
					showPreview(isPreview, itemseq);
				}
			}
			
			
			function showPreview(isPreview, itemseq) {
				var doc = window.document;
				var pollVO;
				var pollResultVO;
				
				if(itemseq!=0){
					$.ajax({
						type: "POST",
						dataType: "json",
						async: false,
						url: "/admin/ezPersonal/getPollItem.do",
						data: {itemseq: itemseq},
						success: function(result) {
							pollVO = result["pollVO"];
							personResultVO = result["pollResultVO"];
						}
					});
				} 
				
				
				if(itemseq == 0) {
					doc.getElementById('Preview_HeaderH').style.display ="none";
					doc.getElementById("ifrmPreViewH").style.display = "none";
				} else {
					if(isPreview == 2) {
						// 세로 모드
						doc.getElementById('Preview_HeaderH').style.display ="inline-block";
						doc.getElementById('Preview_HeaderH').title = pollVO.pollTitle;
						doc.getElementById('PreH_sub_subject').innerHTML = pollVO.pollTitle;
						PrevViewFormH.itemSeq.value = itemseq;
						PrevViewFormH.submit();
					}
				}
			}
			
		</script>
		<style>
			.jinhang {
				width: 16px;
				height: 16px;
				margin-left: 15px;
				margin-top: 5px;
			}
		</style>
	</head>
	<body class = "mainbody">
		<xml id="listviewheader" style="display: none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<WIDTH>20</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezPersonal.t166' /></NAME>
						<WIDTH>40</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezPersonal.t240' /></NAME>
						<WIDTH></WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezPersonal.t241' /></NAME>
						<WIDTH>100</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code = 'ezPersonal.t242' /></NAME>
						<WIDTH>100</WIDTH>
					</HEADER>
					<HEADER>
						<NAME>진행여부</NAME>
						<WIDTH>60</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		
		<form method="post">
			<h1>Quick Poll<span id="mailBoxInfo"></span>
				<select class="companySelect" id="ListCompany" onChange="company_change()">
					<c:forEach var="item" items="${list}">
						<option value="<c:out value='${item.cn}'/>" ${item.cn == companyId ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
					</c:forEach>
				</select>
			</h1>
			<div id="mainmenu">
				<ul style="margin-top:15px">	            	
					<li class="important"><span onclick="add_poll()">등록</span></li>
					<li><span onclick="delete_poll()">삭제</span></li>
					<div class="sub_frameIcon" style="float:right;">	
						<div class="sub_frameIconUL" style="width:100% !important;">
							<p class="frameIconLI"><span class="icon16 btn_noframe" id="PreViewNone" onclick="PreviewRayerChange('NONE')"></span></p>
							<p class="frameIconLI"><span class="icon16 btn_leftframe" id="PreViewleft" onclick="PreviewRayerChange('H')"></span></p>
						</div>
					</div>
			 </div>
				</ul>
			</div>
			
			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
			<div class="mainView" id="mainView" style="width:100%;float:left">
				<div id="contentlist" style="width:100%; overflow: auto;">
					<table class="mainlist" style="width: 100%;">
						<div id="AccessList" style="border: 0; width: 100%"></div>
					</table>
				</div>
				<div id="tblPageRayer"></div>
			</div>
			
			<div class="previewH" id="previewH" style="width:29%; float:right;">
				<span id="PreviewRayerH" style="border:0px solid red; width:500px; height:100%; overflow:hidden; vertical-align:top;  margin-left:0px;">
					<span id="previewmail_bar_h" class="previewmail_bar_h" style="display: inline-block; border: 1px solid #e5e5e5; border-top:0px !important; border-bottom:0px !important;">
						<p class="hbar_dotted" style="width:5px">
						</p>
					</span>
					<span id="PreContent_RayerH" style="position: absolute; border: 0px solid blue; width:29%;">
						<span style="width: 100%; height: 100px; display: block;">
							<span class="previewmail_info" style="display: block; width: 100%; border-top: 1px solid #e8e8e8; ">
								<div id="Preview_HeaderH" style="border-bottom: solid 1px #e8e8e8; width: 100%; display: none;">
									<p class="mail_title" style="margin-left: 0px; color: #333333; font-weight: bold; font-size: 12px; margin: 0px 0px 5px 0px; clear: both; padding: 10px 0px 0px 0px; height: 36px; line-height: 37px;">
										<span class="icon_btn" style="margin-left:13px;"><span onclick="CircularReadOpen();" style="cursor: pointer; padding-right: 5px;">
											<img src="/images/kr/cm/btn_newpopup.gif" alt="" border="0"></span></span><span id="PreH_subject"><span id="PreH_sub_subject" style="position:absolute; margin-top:-6px;" class="title_blodtxt"></span></span>
									</p>
									<span class="mail_date" style="margin-right: 10px; display: inline-block;"><span id="PreH_date"><span id="PreH_sub_date" style="display: none;"></span></span></span>
								</div>
							</span>
							<iframe id="ifrmPreViewH" name="ifrmPreViewH" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
						</span>
					</span>
				</span>
			</div>
		</form>
		
		<form name="PrevViewFormH" action="/ezPersonal/pollResult.do" method="get" target="ifrmPreViewH" >
			<input  type="hidden" name="itemSeq" value="">
			<input  type="hidden" name="flag" value="preview">
		</form>
	</body>
</html>