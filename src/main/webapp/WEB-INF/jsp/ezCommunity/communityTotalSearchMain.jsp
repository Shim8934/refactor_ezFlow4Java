<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>main_page</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>		
		<script type="text/javascript">
			var CurPage = "";
			var totalPage = "";
			var period = "<c:out value='${period}'/>";
			var category = "<c:out value='${subject}'/>";
			var keyword = "<c:out value='${keyword}'/>";
			//2018-10-16 김보미 - 프로그래스바
			var startTime = "";
			var endTime = "";
			
			window.onload = function() {
				var subject = document.getElementById("search").value;
				var liElements = document.getElementsByTagName("li");

				for (var i = 0; i < liElements.length; i++) {
					var liValue = liElements[i].getAttribute("value");
					
					if (liValue == subject) {
						liElements[i].classList.add('active');
						break; 
					}
				}

				totalSearchResult();
			};
			
			function totalSearch() {
				keyword = document.getElementById("keyword").value;
				category = document.getElementById("search").value;

				if (keyword.trim() == "") {
					alert("<spring:message code='ezCommunity.lyj103'/>");
					return;
				}

				if (keyword.trim().length < 2) {
					alert("<spring:message code='ezCommunity.lyj104'/>");
					return;
				}

				var specialCharPattern = /[!@#$%^&*(),.?":{}|<\\]/;
				if (specialCharPattern.test(keyword)) {
					alert("<spring:message code='ezCommunity.lyj101'/>");
					return;
				}

				viewContent(category);
				totalSearchResult();
			}

			function key_down(e) {
				if (e.keyCode == "13") {
					totalSearch();
				}
			}

			function totalSearchResult() {
				ShowMailProgress();

				$.ajax({
					type : "POST",
					async : false,
					url : "/ezCommunity/totalSearchMainResult.do",
					dataType : "json",
					data : {
						subject : category,
						keyword : keyword,
						period : period,
						goToPage : CurPage
					},
					success : function(result) {
						totalSearchResult_after(result);
					},
					error : function(e) {
						console.log(e);
					},
					complete: function() {
						endTime = new Date();
						var timeDiff = endTime - startTime;
						timeDiff /= 1000;
						var seconds = (timeDiff % 60).toFixed(1);

						if (seconds <= 0.5) {
							seconds = 500 - (timeDiff * 1000);
							setTimeout(function() {
								HiddenMailProgress();
							}, seconds);
						} else {
							HiddenMailProgress();
						}
					}
				});
			}
			
			function totalSearchResult_after(result) {
				var xmldoc = loadXMLString(result.strXML);
				var listXML = "";
				var cntKey = "";
				var maxCount = 3;
				var clubCount = 0;
				var masterCount = 0;
				var boardCount = 0;

				if (result.subject != "ALL") {
					CurPage = result.curPage;
					totalPage = result.totalPage;
					document.getElementById("tblPageRayer").style.display = "";
					makePageSelPage();
				} else {
					document.getElementById("tblPageRayer").style.display = "none";
				}

				switch (result.subject) {
					case "ALL" :
						cntKey = "TotalCnt";
						break;
					case "CLUB" :
						cntKey = "CommCnt";
						break;
					case "BOARD":
						cntKey = "ItemCnt";
						break;
					case "MASTER":
						cntKey = "MasterCnt";
						break;
				}

				var count = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE4")[0], cntKey);
				listXML += "<span class='result_txt'><spring:message code='ezCommunity.lyj105'/><span> " + count + "</span></span>";

				if (result.subject == "CLUB" || result.subject == "ALL") {
					if (SelectNodes(xmldoc,"NODES/NODE2").length > 0) {
						for (var i = 0; i < SelectNodes(xmldoc,"NODES/NODE2").length; i++) {
							if ((result.subject != "ALL" || clubCount < maxCount)) { // 전체 탭에서는 3개씩만 표출
								var commName = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE2")[i], "CommName"));
								var commCode = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE2")[i], "CommCode");
								var permit = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE2")[i], "Permit");
								var commDesc = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE2")[i], "CommDesc"));
								var masterName = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE2")[i], "MasterName"));
								var regDate = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE2")[i], "RegDate");
								var memberCnt = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE2")[i], "MemberCnt");
								var itemCnt = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE2")[i], "ItemCnt");

								commName = highlightKeyword(commName, result.keyword);
								commDesc = highlightKeyword(commDesc, result.keyword);

								if (i < 1) {
									listXML += "<div class='result_list_head'>";
									if (result.subject == "ALL" && SelectNodes(xmldoc,"NODES/NODE2").length > 3) {
										listXML += "<h4><spring:message code='ezCommunity.t1529'/><div class='moreView'>";
										listXML += "<a href='javascript:void(0);' onclick='viewContent(\"CLUB\")'><spring:message code='ezCommunity.lyj108'/></a>";
										listXML += "<img src='/images/arr_right.gif'></div></h4>";
									} else {
										listXML += "<h4><spring:message code='ezCommunity.t1529'/></h4>";
									}
								} else {
									listXML += "<div class='result_list'>";
								}
								listXML += "<div class='result_list_cont'><div class='result_list_cont_L'>";
								listXML += "<div class='result_list_title'><a href='javascript:void(0);' onclick='commOpen(\"" + commCode + "\", \"" + permit + "\")' ><span>" + commName + "</span></a></div>";
								listXML += "<div class='result_list_desc'><span>" + commDesc + "</span></div>";
								listXML += "<div class='result_list_etc'><img src='/images/i_master.gif' align='absmiddle'>" + masterName + "<span>|</span><spring:message code='ezCommunity.t78'/> : " + regDate + "</div></div>";
								listXML += "<div class='result_list_cont_R'><div style='margin-bottom: 3px;'><img src='../images/kr/community/categoryBox_iconLineup.gif'><span>" + memberCnt + "</span></div>";
								listXML += "<div><img src='../images/kr/community/categoryBox_iconPost.gif'><span>" + itemCnt + "</span></div></div></div></div></div>";
							}
							clubCount++;
						}
					} else {
						listXML += "<div class='result_list_head' style='height:150px;'><h4><spring:message code='ezCommunity.t1529'/></h4>";
						listXML += "<div class='empty'><span><spring:message code='ezCommunity.lyj106'/></span></div></div>";
					}
				}

				if (result.subject == "BOARD" || result.subject == "ALL") {
					if (result.subject != "ALL") {
						listXML += "<a class='itemBtn" + (result.period == "recent" ? "" : " itemActive") + "' period='before' href='javascript:void(0);' onclick='itemList(\"before\")'>";
						listXML += "<span><spring:message code='ezCommunity.lyj109'/></span></a>";
						listXML += "<a class='itemBtn" + (result.period == "recent" ? " itemActive" : "") + "' period='recent' href='javascript:void(0);' onclick='itemList(\"recent\")' style='margin-right:4px;'>";
						listXML += "<span><spring:message code='ezCommunity.lyj110'/></span></a>";
					}

					if (SelectNodes(xmldoc,"NODES/NODE1").length > 0) {
						for (var j = 0; j < SelectNodes(xmldoc,"NODES/NODE1").length; j++) {
							if ((result.subject != "ALL" || boardCount < maxCount)) { // 전체 탭에서는 3개씩만 표출
								var itemID = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE1")[j], "ItemID");
								var boardID = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE1")[j], "BoardID");
								var writerName = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE1")[j], "WriterName"));
								var writeDate = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE1")[j], "WriteDate");
								var title = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE1")[j], "Title"));
								var content = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE1")[j], "Content"));
								var photoContent = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE1")[j], "PhotoContent"));
								var gubun = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE1")[j], "Gubun");
								var c_Code = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE1")[j], "Code");
								var clubName = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE1")[j], "ClubName"));

								title = highlightKeyword(title, result.keyword);

								if (j < 1) {
									listXML += "<div class='result_list_head'>";
									if (result.subject == "ALL" && SelectNodes(xmldoc,"NODES/NODE1").length > 3) {
										listXML += "<h4><spring:message code='ezCommunity.lyj102'/><div class='moreView'>";
										listXML += "<a href='javascript:void(0);' onclick='viewContent(\"BOARD\")'><spring:message code='ezCommunity.lyj108'/></a>";
										listXML += "<img src='/images/arr_right.gif'></div></h4>";
										listXML += "<div class='result_list_noti'><span>[<spring:message code='ezCommunity.lyj112'/>]</span></div>";
									} else {
										listXML += "<h4><spring:message code='ezCommunity.lyj102'/></h4>";
									}
								} else {
									listXML += "<div class='result_list'>";
								}
								listXML += "<div><div class='result_list_title'><a href='javascript:void(0);' onclick='itemOpen(\"" + itemID + "\", \"" + boardID + "\", \"" + c_Code + "\", \"" + gubun + "\")' ><span>" + title + "</span></a></div>";
								listXML += "<div class='result_list_desc'><span>" + (gubun == "3" ? photoContent : content) + "</span></div>";
								listXML += "<div class='result_list_etc'><img src='/images/pencil.png' style='margin-bottom:3px;' align='absmiddle'>" + writerName + "<span>|</span><spring:message code='ezCommunity.lyj111'/> " + writeDate + "<span>|</span>" + clubName + "</div></div>";
								listXML += "</div></div></div></div>";
							}
							boardCount++;
						}
					} else {
						listXML += "<div class='result_list_head' style='height:150px;'><h4><spring:message code='ezCommunity.lyj102'/></h4>";
						if (result.subject == "ALL") {
							listXML += "<div class='result_list_noti'><span>[<spring:message code='ezCommunity.lyj112'/>]</span></div>";
						}
						listXML += "<div class='empty'><span><spring:message code='ezCommunity.lyj106'/></span></div></div>";
					}
				}

				if (result.subject == "MASTER" || result.subject == "ALL") {
					if (SelectNodes(xmldoc,"NODES/NODE3").length > 0) {
						for (var y = 0; y < SelectNodes(xmldoc,"NODES/NODE3").length; y++) {
							if ((result.subject != "ALL" || masterCount < maxCount)) { // 전체 탭에서는 3개씩만 표출
								var commName = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE3")[y], "CommName"));
								var commCode = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE3")[y], "CommCode");
								var commDesc = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE3")[y], "CommDesc"));
								var masterName = MakeXMLString(SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE3")[y], "MasterName"));
								var regDate = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE3")[y], "RegDate");
								var permit = SelectSingleNodeValue(SelectNodes(xmldoc, "NODES/NODE3")[y], "Permit");

								masterName = highlightKeyword(masterName, result.keyword);

								if (y < 1) {
									listXML += "<div class='result_list_head'>";

									if (result.subject == "ALL" && SelectNodes(xmldoc,"NODES/NODE3").length > 3) {
										listXML += "<h4><spring:message code='ezCommunity.t9'/><div class='moreView'>";
										listXML += "<a href='javascript:void(0);' onclick='viewContent(\"MASTER\")'><spring:message code='ezCommunity.lyj108'/></a>";
										listXML += "<img src='/images/arr_right.gif'></div></h4>";
									} else {
										listXML += "<h4><spring:message code='ezCommunity.t9'/></h4>";
									}
								} else {
									listXML += "<div class='result_list'>";
								}
								listXML += "<div><div class='result_list_title'><a href='javascript:void(0);' onclick='commOpen(\"" + commCode + "\", \"" + permit + "\")' ><span>" + commName + "</span></a></div>";
								listXML += "<div class='result_list_desc'><span>" + commDesc + "</span></div>";
								listXML += "<div class='result_list_etc'><img src='/images/i_master.gif' align='absmiddle'>" + masterName + "<span>|</span><spring:message code='ezCommunity.t78'/> : " + regDate + "</div></div></div></div></div>";
							}
							masterCount++;
						}
					} else {
						listXML += "<div class='result_list_head' style='height:150px;'><h4><spring:message code='ezCommunity.t9'/></h4>";
						listXML += "<div class='empty'><span><spring:message code='ezCommunity.lyj106'/></span></div></div>";
					}
				}

				$("#tapContent").html(listXML);
			}

			function viewContent(cate, element) { // 탭 선택, 더 많은 결과보기
				// 탭을 선택할때 class명을 변경함.
				var allLis = document.querySelectorAll('.tab-menu li');
				
				allLis.forEach(li => {
					li.classList.remove('active');
				});

				if (element == undefined) {
					element = $('.tab-menu li[value="' + cate + '"]');
					element.addClass('active')
				} else {
					element.classList.add('active');
				}
				
				// 탭을 변경할 경우 selectbox의 option도 변경됨.
				var selectVal = document.getElementById('search');
				selectVal.value = cate;

				category = cate;
				CurPage = 1;
				totalSearchResult();
			}
			
			function commOpen(code, userLevel) {
				GetOpenWindow("/ezCommunity/commHome/popupCommHome.do?code=" + encodeURIComponent(code) + "&userLevel=" + userLevel, "", 1300, 900);
			}

			function itemOpen(itemID, boardID, code, gubun) {
				if (gubun == "3") {
					GetOpenWindow("/ezCommunity/boardItemViewPhoto.do?itemID=" + encodeURIComponent(itemID) + "&boardID=" + encodeURIComponent(boardID) + "&code=" + encodeURIComponent(code), "", 750, 721);
				} else {
					GetOpenWindow("/ezCommunity/boardItemView.do?itemID=" + encodeURIComponent(itemID) + "&boardID=" + encodeURIComponent(boardID) + "&code=" + encodeURIComponent(code) + "&showAdjacent=1", "", 750, 721);
				}
			}
			
			function itemList(periodVal) { // 기간 검색
				period = periodVal;
				CurPage = 1;
				totalSearchResult();
			}

			function highlightKeyword(text, keyword) { // 키워드 굵게 처리
				if (!text || !keyword) {
					return text;
				}

				if (text.toLowerCase().includes(keyword.toLowerCase())) {
					var regex = new RegExp(keyword, "gi");
					return text.replace(regex, function(match) {
						return "<b>" + match + "</b>";
					});
				}
				return text;
			}

            var BlockSize = 10;
            function td_Create1(strtext) { 
                document.getElementById("tblPageRayer").innerHTML = strtext;
            }

            function makePageSelPage() {
                var strtext;
                var PagingHTML = "";
                document.getElementById("tblPageRayer").innerHTML = "";
                strtext = "<div class='pagenavi'>";
                PagingHTML += strtext;
                var pageNum = CurPage;
				
                if (totalPage > 1 && pageNum != 1) {
                    strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
                    PagingHTML += strtext;
                } else {
                    strtext = "<span class='btnimg first disabled'></span>"
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

				if (MaxNum == 0) {
					PagingHTML += "<span class=\"on\">" + 1 + "</span>";
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

            function goToPageByNum(Value) {
                CurPage = Value;
                // makePageSelPage(Value);
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
				
				if( parseInt(pageNum + 1) <= totalPage) {
					goToPageByNum(parseInt(pageNum + 1));
				} else {
					return;
				}
            }

            function movePage(newPage) {
				CurPage = newPage;
				
				category = document.getElementsByClassName("active")[0].getAttribute("value");

				if (category == "BOARD") {
					period = document.getElementsByClassName("itemBtn itemActive")[0].getAttribute("period");
				}

                if(parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
					totalSearchResult();
                }
            }

			function ShowMailProgress() {
				startTime = new Date();
				CurrenWidth = document.body.clientWidth;

				document.getElementById("mailPanel").style.display = "";
				document.getElementById("MailProgress").style.top = "350px";
				document.getElementById("MailProgress").style.left = (CurrenWidth / 2) - 100 + "px";
				document.getElementById("MailProgress").style.display = "";
			}

			function HiddenMailProgress() {
				document.getElementById("mailPanel").style.display = "none";
				document.getElementById("MailProgress").style.display = "none";
			}

			function MakeXMLString(str) {
				str = ReplaceText(str, "&", "&amp;");
				str = ReplaceText(str, "<", "&lt;");
				str = ReplaceText(str, ">", "&gt;");
				return str;
			}

			function returnHome() {
				window.location.href = "/ezCommunity/mainPage.do";
			}
		</script>
	</head>
	<body class="mainbody" style="margin:20px 15px; min-width:1040px; padding:0 10px 10px;">
		<div>
			<div class="community_searchBox">
				<div class="community_totalSearch">
					<dl>
						<dt class="selectbox">
							<select id="search" name="select">
								<option value="ALL" <c:if test="${subject == 'ALL'}">selected</c:if>><spring:message code='ezCommunity.lyj100'/></option>
								<option value="CLUB" <c:if test="${subject == 'CLUB'}">selected</c:if>><spring:message code='ezCommunity.t1529'/></option>
								<option value="BOARD" <c:if test="${subject == 'BOARD'}">selected</c:if>><spring:message code='ezCommunity.lyj102'/></option>
								<option value="MASTER" <c:if test="${subject == 'MASTER'}">selected</c:if>><spring:message code='ezCommunity.t9'/></option>
							</select>
						</dt>
						<dt class="searchinput"><input id="keyword" name="keyword" onkeydown="key_down(event)" type="text" value="<c:out value='${keyword}'/>"></dt>
						<dd onclick="totalSearch()" class="btn_search"><spring:message code='ezCommunity.t31'/></dd>
						<dd onclick="returnHome()" class="btn_CommHome"><spring:message code='ezCommunity.t1529'/> <spring:message code='ezNewPortal.t033'/></dd>
					</dl>
				</div>
			</div>
			
			<ul class="tab-menu">
				<li onclick="viewContent('ALL', this)" value="ALL"><spring:message code='ezCommunity.lyj100'/></li>
				<li onclick="viewContent('CLUB', this)" value="CLUB"><spring:message code='ezCommunity.t1529'/></li>
				<li onclick="viewContent('BOARD', this)" value="BOARD"><spring:message code='ezCommunity.lyj102'/></li>
				<li onclick="viewContent('MASTER', this)" value="MASTER"><spring:message code='ezCommunity.t9'/></li>
			</ul>

			<div id="tapContent"></div>

			<div id="tblPageRayer"></div>

			<div style="width:100%;height:100%;position:absolute;top:0;left:0;display:none;z-index:5000;" id="mailPanel" >&nbsp;</div>
			<div style="width: 200px; height: 110px; border-radius: 8px; text-align: center; vertical-align: middle; z-index: 9000; position: absolute; top: 350px; left: 726.5px; display: none;" id="MailProgress">
			<img src="/images/email/progress_img.gif" style="padding-top:20px;">
			<div id="progressNum" style="padding-top:10px;vertical-align: middle; font-weight: bold; font-size: 1.2em;"></div>
			</div>
		</div>
	</body>
</html>
