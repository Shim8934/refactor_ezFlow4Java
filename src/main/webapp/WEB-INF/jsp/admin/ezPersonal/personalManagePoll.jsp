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
				ifrmPreViewW.document.getElementById("ifrmviewEmptyText").innerText = "선택된 설문이 없습니다.";
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
	            checkFlag = false;
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
				th.innerHTML = "<input type='checkbox' id = 'checkAll'></input>";
				
				cnt = acList.children[1].childElementCount;
				
				var i = 0;
				for(i;i<cnt;i++) {
					var seq = acList.children[1].children[i].children[0].innerHTML;
					acList.children[1].children[i].children[0].innerHTML = "<input type='checkbox' name='checks' class='checks' id='" + seq + "' value='" + seq +"'></input>";
				}
				checkboxHeaderClick();
			}
			
			var checkFlag = false;
			function checkboxHeaderClick() {
				$("#checkAll").click(function(){
					if(checkFlag){
						checkFlag = false;
						$(".checks").prop("checked",false);
						$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");
					}else {
						checkFlag = true;
						$(".checks").prop("checked",true);
						$("#contentlist tr td").css("background-color", "rgb(228, 232, 236)");
					}
				});
			}
			
			
			var itemseq;
			function PollList_onClick(obj) {
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
		            var AddPoll_Cross = window.open("/admin/ezPersonal/addPoll.do", "AddPoll_Cross", GetOpenWindowfeature(450, 500));
		            try { AddPoll_Cross.focus(); } catch (e) {
		            }
		        } else {
		            rtnValue = window.showModalDialog("/admin/ezPersonal/addPoll.do", document.getElementById("ListCompany").value, "dialogHeight:500px;dialogwidth:430px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + GetShowModalPosition(430, 500));
		
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
	
	        function del_poll(poll_number) {
		    	//2018-09-06  김보미 - rownumber추가
	            /*if (!confirm(poll_number + "<spring:message code = 'ezPersonal.t236' />")) {
	                return;
	            }*/
		        var row_number = $("tr[data1=" + poll_number + "] td:eq(0)").text();
		        if (!confirm(row_number + "<spring:message code = 'ezPersonal.t159' />")) {
		            return;
		        }
	            
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezPersonal/delPoll.do",
	            	async : false,
	            	data : {itemSeq : poll_number},
	            	dataType : "text",
	            	success : function(result) {
	            		if (result != "OK") {
	            			alert("<spring:message code = 'ezPersonal.t237' />");
	            		} else {
	            			alert("<spring:message code = 'ezPersonal.t238' />");
	            			
	    	                if (document.getElementById("rowdata") != null && typeof (document.getElementById("rowdata").length) == "undefined" && page != 1) {
	    	                    pagemove(-1);
	    	                } else {
	    	                    makelist();
	    	                }
	            		}
	            	}
	            });
	        }
	        
			var pollList = "";
			function delete_poll() {
				var delCnt = 0;
				$("input:checkbox[name='checks']").each(function(){
					if($(this).is(":checked")) {
						pollList += this.value + ";"
						delCnt = delCnt + 1;
					}
				});
				
				if(!pollList) {
					alert("선택된 설문이 없습니다.");
					return;
				}
				 
				/*	if() {	// 진행중인 설문 삭제 할지 check // return; 	} 	*/
				
				// TotalCount
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
		        document.getElementById("mailBoxInfo").innerHTML = " &nbsp;[" + strLang1 + "<span style='color:#017BEC;'> " + TotalCount + " </span>" + strLang4 + "]";
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
			function windowResize()
			{
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
				} else if ( isPreview == 1) {
					doc.getElementById("contentlist").style.height = height + "px";
					doc.getElementById("contentlist").style.overflow = "auto";
					doc.getElementById("previewH").style.height = height + 47 + "px";
					doc.getElementById("previewmail_bar_h").style.height = height + 47 + "px";
					doc.getElementById("ifrmPreViewH").style.height = height + 47 + "px";
				} else {
					doc.getElementById("contentlist").style.height = height/2 + "px";
					doc.getElementById("contentlist").style.overflow = "auto";
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
					case "W" :
						isPreview = 1;
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
				var botImage = doc.getElementById("PreViewBottom");
				var leftImage = doc.getElementById("PreViewleft");
				
				noneImage.src = "/images/kr/cm/btn_noframe.gif";
				botImage.src = "/images/kr/cm/btn_bottomframe.gif";
				leftImage.src = "/images/kr/cm/btn_leftframe.gif";
				
				switch(previewNum) {
					case 0 :
						noneImage.src = "/images/kr/cm/btn_onnoframe.gif";
						break;
					case 1 :
						botImage.src = "/images/kr/cm/btn_onbottomframe.gif";
						break;
					case 2 :
						leftImage.src = "/images/kr/cm/btn_onleftframe.gif";
						break;
				}
			}
			
			
			// 미리보기창 show
			function setPreview(previewNum) {
				var conlistH = conH
				var doc = window.document;
				var mainView = doc.getElementById("mainView");
				var previewH = doc.getElementById("previewH");
				var previewW = doc.getElementById("previewW");
				var PreviewRayerH = doc.getElementById("PreviewRayerH");
				var PreviewRayerW = doc.getElementById("PreviewRayerW");
				var contentlistH = doc.getElementById("contentlist");
				var previewmail_bar_h = doc.getElementById("previewmail_bar_h");
				
				switch(previewNum) {
				case 0 :
					previewH.style.display = "none";
					previewW.style.display = "none";
					mainView.style.width = "100%";
					doc.getElementById("contentlist").style.height = conlistH + "px";					
					break;
				case 1 :
					previewW.style.display = "none";
					doc.getElementById("contentlist").style.height = conlistH + "px";
					mainView.style.width = "70%";
					previewH.style.width = "30%";
					previewH.style.height = conlistH + 47 + "px";
					previewH.style.display = "";
					previewmail_bar_h.style.height = conlistH + 47 + "px";
					PreviewRayerH.style.display = "";
					doc.getElementById("ifrmPreViewH").style.height = conlistH + 47 + "px";
					break;
				case 2 :
					previewH.style.display = "none";
					mainView.style.width = "100%";
					doc.getElementById("contentlist").style.height = conlistH/2 + "px";
					previewW.style.height = conlistH/2 + "px";
					previewW.style.display = "inline-block";
					PreviewRayerW.style.display = "";
					doc.getElementById("ifrmPreViewW").style.height = conlistH/2 + "px";
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
				
				
				if(isPreview == 1) {
					// 가로 모드
					doc.getElementById('Preview_HeaderH').style.display ="inline-block";
					doc.getElementById('Preview_HeaderH').title = pollVO.pollTitle;
					doc.getElementById('PreH_sub_subject').innerHTML = pollVO.pollTitle;
					PrevViewFormH.itemSeq.value = itemseq;
					PrevViewFormH.submit();
					// PreH_subject
				} else if(isPreview == 2) {
					// 세로 모드
					doc.getElementById('Preview_HeaderW').style.display ="inline-block";
					doc.getElementById('Preview_HeaderW').title = pollVO.pollTitle;
					doc.getElementById('PreW_sub_subject').innerHTML = pollVO.pollTitle;
					PrevViewFormW.itemSeq.value = itemseq;
					PrevViewFormW.submit();
				} else {
					// none 모드
				}
			}
			
		</script>
	</head>
	<body class = "mainbody">
		<xml id="listviewheader" style="display: none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<WIDTH>40</WIDTH>
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
					<li class="important"><span onclick="add_poll()"><spring:message code = 'ezPersonal.t235' /></span></li>
					<li><span onclick="delete_poll()">삭제</span></li>
					<li id="right">
						<img src="/images/kr/cm/btn_noframe.gif" width="22" height="20" class="btnimg" id="PreViewNone" onclick="PreviewRayerChange('NONE')">
						<img src="/images/kr/cm/btn_bottomframe.gif" width="22" height="20" class="btnimg" id="PreViewBottom" onclick="PreviewRayerChange('W')">
						<img src="/images/kr/cm/btn_leftframe.gif" width="22" height="20" class="btnimg" id="PreViewleft" onclick="PreviewRayerChange('H')">
					</li>
				</ul>
			</div>
			
			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
			</script>
			<div class="mainView" id="mainView" style="width:100%;float:left">
				<div id="contentlist" style="width:100%; overflow: auto;">
					<table class="mainlist" style="width: 100%;">
						<div id="AccessList" style="BORDER: 0; WIDTH: 100%"></div>
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
									<p class="mail_title" style="margin-left: 0px; color: #333333; font-weight: bold; font-size: 12px; margin: 0px 0px 5px 0px; clear: both; padding: 0px 0px 0px 0px; height: 36px; line-height: 37px;">
										<span class="icon_btn" style="margin-left:13px;"><span onclick="CircularReadOpen();" style="cursor: pointer; padding-right: 5px;">
											<img src="/images/kr/cm/btn_newpopup.gif" alt="" border="0"></span></span><span id="PreH_subject"><span id="PreH_sub_subject" class="title_blodtxt"></span></span>
									</p>
									<span class="mail_date" style="margin-right: 10px; display: inline-block;"><span id="PreH_date"><span id="PreH_sub_date" style="display: none;"></span></span></span>
								</div>
							</span>
							<iframe id="ifrmPreViewH" name="ifrmPreViewH" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
						</span>
					</span>
				</span>
			</div>
			
			<div class="previewW" id="previewW" style="width:100%; display:inline-block;">
				<span id="PreviewRayerW" style="border:0px solid red; width:500px; height:100%; overflow:hidden; vertical-align:top; ">
					<span style="width:100%; display:inline-block; border:1px solid #e8e8e8; border-left:0px; border-right:0px; height:3px;" class="previewmail_bar" name="PreviewBar" id="PreviewBar">
					</span>
					<span id="PreContent_RayerW" style="position:border: 0px solid blue; width:99%;">
						<span style="width: 100%; height: 100px; display: block;">
							<span class="previewmail_info" style="display: block; width: 100%;">
								<div id="Preview_HeaderW" style="border-bottom: solid 1px #e8e8e8; width: 100%; background-color: #f1f3f5; margin-top: -3px; display: none;">
									<p class="mail_title" style="margin-left: 0px; color: #333333; font-weight: bold; font-size: 12px; margin: 0px 0px 5px 0px; clear: both; padding: 0px 0px 0px 0px; height: 36px; line-height: 37px;">
										<span class="icon_btn" style="margin-left: 13px;"><span onclick="CircularReadOpen();" style="cursor: pointer; padding-right: 5px;">
											<img src="/images/kr/cm/btn_newpopup.gif" alt="" border="0"></span></span><span id="PreW_subject"><span id="PreW_sub_subject" class="title_blodtxt"></span></span>
									</p>
									<span class="mail_date" style="margin-right: 10px; display: inline-block;"><span id="PreW_date"><span id="PreW_sub_date" style="display: none;"></span></span></span>
								</div>
							</span>
							<iframe id="ifrmPreViewW" name="ifrmPreViewW" src="<spring:message code='main.kms4' />" frameborder="0" style="width: 100%; height: 100%; border: solid 0px green; display: inline-block;"></iframe>
						</span>
					</span>
				</span>
			</div>
		</form>
		
		<form name="PrevViewFormH" action="pollResult.do" method="get" target="ifrmPreViewH" >
			<input  type="hidden" name="itemSeq" value="">
			<input  type="hidden" name="flag" value="preview">
		</form>
		<form name="PrevViewFormW" action="pollResult.do" method="post" target="ifrmPreViewW">
			<input  type="hidden"  name="itemSeq" value="">
			<input  type="hidden" name="flag" value="preview">
		</form>
	</body>
</html>