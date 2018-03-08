<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<title><spring:message code='ezBoard.t293' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1' />" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezBoard/common.js"></script>
		<script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<script type="text/javascript" src="/js/Common.js" ></script>
		<script  type="text/javascript">
		</script>
	</head>
	<body class="popup" style="overflow:hidden; height:100%;">
		<table class="layout" style="height:100%">
		  <tr>
		    <td style="vertical-align: top; height: 10px;">
		      <div id="menu">
		        <ul>
		        	<c:choose>
		        		<c:when test="${boardID == '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}'}">
		        			<c:if test="${guBun != '3'}">
		        				<c:if test = "${boardPropertyVO.oneLineReply == '1'}">
		        					<li ID='btn_One_Line_Reply'><span id="commentCount" onclick='btn_One_Line_Reply_Onclick()'><spring:message code='ezBoard.t81'/>[${commentCount}]</span></li>
		        				</c:if>
			        			<li ID='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezBoard.t88' /></span></li>
		        			</c:if>
		        		</c:when>
		        		<c:when test="${pReservedItem == 'true'}">
		        			<li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
		                    <li ID='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezBoard.t89' /></span></li>
		        			<c:if test="${guBun != '3'}">
		        			</c:if>
		        		</c:when>
		        		<c:when test="${apprFlag == 'N'}">
		        			<li><span onClick="Appr_onclick('Y')"><spring:message code='ezBoard.t999005' /></span></li>
		                    <li><span onClick="Appr_onclick('C')"><spring:message code='ezBoard.t999014' /></span></li>
		                    	<c:if test="${boardItem.writerID == userInfo.id}">
			                        <li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
			                        <li ID='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezBoard.t89' /></span></li>
		                    	</c:if>
		        		</c:when>
		        		<c:when test="${apprFlag == 'C'}">
		        			<li><span onClick="btn_Modify_Onclick()"><spring:message code='ezBoard.t999021' /></span></li>
		        		</c:when>
		        		<c:when test="${apprFlag == 'W'}">
		        			<li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
		                    <li ID='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezBoard.t89' /></span></li>
		        		</c:when>
		        		<c:otherwise>
		        			<c:choose>
			        			<c:when test="${guBun == '2'}">
			        				<c:choose>
				        				<c:when test="${guBun != '3'}">
					        				<c:if test = "${boardPropertyVO.oneLineReply == '1'}">
					        					<li ID='btn_One_Line_Reply'><span id="commentCount" onclick='btn_One_Line_Reply_Onclick()'><spring:message code='ezBoard.t81' />[${commentCount}]</span></li>
					        				</c:if>
				        					<li ID='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezBoard.t88' /></span></li>
				        				</c:when>
			        				</c:choose>
			        				<li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
			                        <li ID='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezBoard.t89' /></span></li>
			                        <c:if test="${guBun != '3'}">
			                        	<li ID='btn_Move' ><span onclick='mail_boarditem()' ><spring:message code='ezBoard.t317' /></span></li>
			                        	<li ID='btn_Print'><span onclick='btn_Print_Onclick()'><spring:message code='ezBoard.t318' /></span></li>
			                        </c:if>
			        			</c:when>
			        			<c:when test="${boardItem.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK'}">
			        				<c:if test="${guBun != '3'}">
				        				<c:if test = "${boardPropertyVO.oneLineReply == '1'}">
				        					<li ID='btn_One_Line_Reply'><span id="commentCount" onclick='btn_One_Line_Reply_Onclick()'><spring:message code='ezBoard.t81' />[${commentCount}]</span></li>
				        				</c:if>
			        					<li ID='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezBoard.t88' /></span></li>
			        				</c:if>
			        				<li ID='btn_Modify'><span onclick='btn_Modify_Onclick()'><spring:message code='ezBoard.t316' /></span></li>
			                        <li ID='btn_Delete'><span onclick='btn_Delete_Onclick()'><spring:message code='ezBoard.t89' /></span></li>
			                        <c:if test="${guBun != '3'}">
			                        	<c:if test="${guBun != '2'}">
					                        <li ID='btn_Move'><span onclick='btn_Copy_Onclick()' ><spring:message code='ezBoard.t274' /></span></li>
								            <%--게시물이동추가--%>
								            <li><span onClick="btn_Move_Onclick()"><spring:message code='ezBoard.t134' /></span></li>
			                        	</c:if>
			                      		<li ID='btn_Move' ><span onclick='mail_boarditem()' ><spring:message code='ezBoard.t317' /></span></li>
			                    	</c:if>
			                    	<c:if test="${guBun != '2'}">
			                        	<li ID='btn_Move'><span onclick='ReaderList()' ><spring:message code='ezBoard.t320' /></span></li>
			                    	</c:if>
			                    	<c:if test="${guBun != '3'}">
			                        	<li ID='btn_Print'><span onclick='btn_Print_Onclick()'><spring:message code='ezBoard.t318' /></span></li>
			                        </c:if>
			        			</c:when>
			        			<c:otherwise>
			        				<c:if test="${guBun != '3'}">
				        				<c:if test = "${boardPropertyVO.oneLineReply == '1'}">
				        					<li ID='btn_One_Line_Reply'><span id="commentCount" onclick='btn_One_Line_Reply_Onclick()'><spring:message code='ezBoard.t81' />[${commentCount}]</span></li>
				        				</c:if>
				                        <li ID='btn_Reply'><span onclick='btn_Reply_Onclick()'><spring:message code='ezBoard.t88' /></span></li>
				                        <li ID='btn_Move' style="display:none;"><span onclick='mail_boarditem()' ><spring:message code='ezBoard.t317' /></span></li>
				                        <c:if test="${guBun != '2'}">
				                        </c:if>
				                        <li ID='btn_Move' style="display:none;"><span onclick='ReaderList()' ><spring:message code='ezBoard.t320' /></span></li>
				                        <li ID='btn_Print'><span onclick='btn_Print_Onclick()'><spring:message code='ezBoard.t318' /></span></li>
				                    </c:if>
			        			</c:otherwise>
		        			</c:choose>
		        		</c:otherwise>
		        	</c:choose>
		        	<c:if test="${useEzKMS == 'YES' && apprFlag != 'N' && apprFlag != 'C' && apprFlag != 'W'}">
		        		<c:if test="${boardItem.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK'}">
		        			<li  ID='btn_KMS' style="display:none;"><span onclick='ToKMS()'>KMS <spring:message code='ezBoard.t321' /></span></li>
		        		</c:if>
		        	</c:if>
		        	<c:if test="${(boardItem.writerID == userInfo.id || boardInfo.boardAdmin_FG == 'true' || boardInfo.boardGroupAdmin_FG == 'OK') && apprFlag != 'N' && apprFlag != 'C' && apprFlag != 'W'}">
		        		<li ID='Retrans'><span onclick='btn_Retrans_Onclick()'><spring:message code='ezBoard.t10100' /></span></li>
		        	</c:if>
		        </ul>
		      </div>    
		      <div id="close">
		        <ul>
		          <li><span onClick="btnClose_onclick()"><spring:message code='ezBoard.t12' /></span></li>
		        </ul>
		      </div>
			<script type="text/javascript">
				selToggleList(document.getElementById("menu"), "ul", "li", "0");
				selToggleList(document.getElementById("close"), "ul", "li", "0");
			</script>
		    </td>
		    </tr>
		    <tr>
		    <c:choose>
				<c:when test="${guBun != '3'}">
					<td style="vertical-align: top; height: 10px;">
					<table class="content2" style="width:100%;">
						<!-- 게시자  -->
						<tr>
							<th style="width:10%;"><spring:message code='ezBoard.t223' /></th>
							<c:choose>
								<c:when test="${guBun != '2'}">
									<td id="WriteUserNM" style="width:40%; white-space:nowrap">
										<div style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;cursor:pointer" onclick='OpenUserInfo("${boardItem.writerID}")'>
											<c:out value="${boardItem.writerName}"/>
										</div>
									</td>
								</c:when>
								<c:otherwise>
									<td id="WriteUserNM" style="width:40%; white-space:nowrap">
										<div style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;">
											<c:out value="${boardItem.writerName}"/>
										</div>
									</td>
								</c:otherwise>
							</c:choose>
						<!-- 게시자 end -->
						<c:choose>
							<c:when test="${guBun != '2'}">
								<!-- 부서 -->
									<th style="width:10%;"><spring:message code='ezBoard.t322' /></th>
									<c:choose>
										<c:when test="${guBun != '2'}">
											<td id="User_DeptNM" style="width:40%; white-space:nowrap"><span>${boardItem.writerDeptName}</span></td>
										</c:when>
										<c:otherwise>
											<td id="User_DeptNM" style="width:40%; white-space:nowrap"><span>&nbsp;</span> </td>
										</c:otherwise>
									</c:choose>
						</tr>
								<!-- 부서 end -->
								<!-- 직위 -->
								<tr>
									<th><spring:message code='ezBoard.t290' /></th>
									<c:choose>
										<c:when test="${guBun != '2'}">
											<td id="User_JobTitle"><span>${boardItem.extensionAttribute3}</span> </td>
										</c:when>
										<c:otherwise>
											<th id="User_JobTitle"><span>&nbsp; </span> </th>
										</c:otherwise>
									</c:choose>
								<!-- 직위 end -->
								<!-- 전화번호 -->
									<th><spring:message code='ezBoard.t38' /></th>
									<c:choose>
										<c:when test="${guBun != '2'}">
											<td id="Telephone"><span>${boardItem.extensionAttribute4} </span> </td>
										</c:when>
										<c:otherwise>
											<td id="Telephone"><span>&nbsp; </span> </td>
										</c:otherwise>
									</c:choose>
								</tr>
								<!-- 전화번호 end -->
								<!-- 게시일 -->
								<tr>
									<th><spring:message code='ezBoard.t224' /></th>
									<td id="PostDate" style = "white-space:nowrap; padding-right:5px">
										<div style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;">${boardItem.writeDate}</div>
									</td>
									<!-- 게시일 end -->
									<!-- 게시 종료일 -->
								<th><spring:message code='ezBoard.t288' /></th>
								<c:set var="code287" value="<spring:message code='ezBoard.t287' />"/>
								<c:choose>
									<c:when test="${boardItem.endDate.substring(0,4) == '9999'}">
										<td id="EndDate" style="padding-right:5px;  white-space:nowrap">
											<div style="vertical-align:middle;width:100px;overflow-y:auto; display:ruby-text-container;"><spring:message code='ezBoard.t287' /></div>
										</td>
									</c:when>
									<c:otherwise>
										<td id="EndDate" style="padding-right:15px;  white-space:nowrap">
											<div style="vertical-align:middle;overflow-y:auto; display:ruby-text-container;">${boardItem.endDate.split(' ')[0]}</div>
										</td>
									</c:otherwise>
								</c:choose>
							</tr>
							<!-- 게시 종료일 end -->
							</c:when>
							<c:otherwise>
								<th style="width:10%"><spring:message code='ezBoard.t224' /></th>
									<td id="PostDate" style="width:120px; white-space:nowrap; padding-right:5px">
										<div style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;">${boardItem.writeDate}</div>
									</td>
									<!-- 게시일 end -->
							</tr>
							<!-- 게시 종료일 -->
							<tr>
								<th><spring:message code='ezBoard.t288' /></th>
								<c:set var="code287" value="<spring:message code='ezBoard.t287' />"/>
								<c:choose>
									<c:when test="${boardItem.endDate.substring(0,4) == '9999'}">
										<td colspan="3" id="EndDate" style="padding-right:5px; width:120px; white-space:nowrap">
											<div style="vertical-align:middle;width:100px;overflow-y:auto; display:ruby-text-container;"><spring:message code='ezBoard.t287' /></div>
										</td>
									</c:when>
									<c:otherwise>
										<td colspan="3" id="EndDate" style="padding-right:15px; width:120px; white-space:nowrap">
											<div style="vertical-align:middle;width:100px;overflow-y:auto; display:ruby-text-container;">${boardItem.endDate.split(' ')[0]}</div>
										</td>
									</c:otherwise>
								</c:choose>
							</tr>
							<!-- 게시 종료일 end -->
							</c:otherwise>
						</c:choose>
							
							
						<c:if test="${boardAttrCount > 0}">
							<c:forEach var="boardAttr" items="${boardAttr}">
								<tr>
									<c:choose>
										<c:when test="${extenLang == '1'}">
							                <th>${boardAttr.colName1}</th>
										</c:when>
										<c:otherwise>
							                <th>${boardAttr.colName2}</th>
										</c:otherwise>
									</c:choose>
					                <td colspan="5">
					                	<c:choose>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute6'}">
					                			${boardItem.extensionAttribute6}
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute7'}">
					                			${boardItem.extensionAttribute7}
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute8'}">
					                			${boardItem.extensionAttribute8}
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute9'}">
					                			${boardItem.extensionAttribute9}
					                		</c:when>
					                		<c:when test="${boardAttr.tableCol == 'extensionAttribute10'}">
					                			${boardItem.extensionAttribute10}
					                		</c:when>
					                		<c:otherwise></c:otherwise>
					                	</c:choose>
					                </td>
					            </tr>
							</c:forEach>
						</c:if>
					<!-- 제목 -->	
			        <tr>
			          <th><spring:message code='ezBoard.t323' /></th>
			             <td width="100%" id="cTitle" style="WORD-WRAP: break-word;word-break:break-all; line-height:16px;" colspan=5>
			             	<div style="overflow-y:auto;WIDTH: 100%; vertical-align: middle"><c:out value="${boardItem.title}"/></div>
			             </td>
			        </tr>
			        <!-- 제목 end -->
			      </table>
			    </td>
			    </c:when>
			    <c:otherwise>
				    <td style="vertical-align: top; height: 80px;">
				        <table style="width:100%" class="content">
				        <tr>
				          <th><spring:message code='ezBoard.t223' /></th>
				          <td id="WriteUserNM" style="white-space:nowrap; width:100%;"><div style="OVERFLOW-Y:auto;WIDTH:100%;cursor:pointer;HEIGHT:16px; vertical-align:middle;" onclick='OpenUserInfo("${boardItem.writerID}")'><c:out value="${boardItem.writerName}"/></div>
				          <th><spring:message code='ezBoard.t289' /></th>
				          <td id="User_DeptNM" style="padding-right:10px; white-space:nowrap; width:100px;">${boardItem.writerDeptName}</td>
				          <th><spring:message code='ezBoard.t290' /></th>
				          <td id="User_JobTitle" style="padding-right:10px; white-space:nowrap; width:100px;">${boardItem.extensionAttribute3}</td>
				        </tr>
				        <tr>
				          <th><spring:message code='ezBoard.t291' /></th>
				          <td style="width:100%;" id="cTitle" colSpan="5"><div id="title" style="OVERFLOW-Y: auto; PADDING-LEFT: 5px; WIDTH: 100%; HEIGHT: 16px; vertical-align:middle;"><c:out value="${boardItem.title}"/></div></td>
				        </tr>
				      </table>
				    </td>
			    </c:otherwise>
		  </c:choose>
		  </tr>
		  <tr>
		  <c:choose>
			  <c:when test="${guBun != '3'}">
			    <td class="pad1" id="pad1" style="vertical-align: top; height:460px;">
			        <iframe id="message" class="viewbox" name="message" style="padding:0; width:100%; height:495px; overflow:auto; border:1px solid #b6b6b6"></iframe>
			    </td>
			  </c:when>
			  <c:otherwise>
			    <td class="pad1">
			        <div id="ItemOverflow">
			           <iframe id="message" name="message"  style="padding: 0;width:100%; overflow:auto;"></iframe>
			        </div>
			    </td>
			  </c:otherwise>
		  </c:choose>
		  </tr>
		  <c:choose>
			  <c:when test="${boardPropertyVO.oneLineReply == '1'}">
			  <tr>
			  <c:choose>
				  <c:when test="${guBun != '3'}">
				    <td class="pad1" style="vertical-align: top;">
				        <table class="file">
				        <tr>
				          <th><spring:message code='ezBoard.t292' /></th>
				            <td>
				            	<div style="text-align:left; OVERFLOW: auto; HEIGHT: 50px; background-color:white" id="lstAttachLink" ></div>
				            </td>
				        <td class="pos2">
				        <a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
				        <a class="imgbtn"><span onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a> 
				        </td>
				        <td id="ItemLevel" style="display:none"></td>
				        </tr>
				      </table>
				    </td>
				  </c:when>
				  <c:otherwise>
				    <td class="pad1" style="vertical-align: top; DISPLAY:none;">
				        <table class="file">
				        <tr>
				          <th><spring:message code='ezBoard.t292' /></th>
				          <td class="pos2">
				          	  <div style="OVERFLOW:auto;HEIGHT:50px;BACKGROUND-COLOR:white; text-align:left" id="lstAttachLink"></div>
				          </td>
				          <td class="pos2">
				              <a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
				              <a class="imgbtn"><span onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a>
				          </td>
				          <td id="Td1"></td>
				        </tr>
				      </table>
				    </td>
				  </c:otherwise>
			  </c:choose>
			  </tr>
			  </c:when>
			  <c:otherwise>
			  	<c:choose>
				  	<c:when test="${guBun != '3'}">
				 	<tr>
					    <td class="pad1" style="vertical-align: top; ">
					        <table class="file">
					        <tr>
					          <th><spring:message code='ezBoard.t292' /></th>
			                     <td >
					            <div id="lstAttachLink" style="OVERFLOW:auto;HEIGHT:50px;background-color:white; text-align:left"></div>
					          </td>
					          <td class="pos2">
					             <a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
					             <a class="imgbtn"><span onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a>
					          </td>
					          <td id="Td2" style="display:none"></td>
					        </tr>
					      </table>
					    </td>
					</tr>
					</c:when>
					<c:otherwise>
					  <tr style="DISPLAY:none">
					    <td class="pad1" style="vertical-align: top;">
					        <table class="file">
					        <tr>
					          <th><spring:message code='ezBoard.t292' /></th>
		                      <td class="pos2">
					            <div id="lstAttachLink" style="OVERFLOW:auto;HEIGHT:50px;BACKGROUND-COLOR:white; text-align:left"></div></td>
	  				          <td class="pos2">'
					          <a class="imgbtn"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
					          <a class="imgbtn"><span onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a>
					          </td>
					          <td id="Td3"></td>
					        </tr>
					      </table>
					    </td> 
					  </tr>
					</c:otherwise>
				</c:choose>
			  </c:otherwise>
		  </c:choose>
		  <c:if test="${adjacentItemsEnableFlag == '1' && showAdjacent == '1'}">
			  <tr>
			    <td style="vertical-align: top;">
			        <table class="content">
			        <tr>
			          <th><spring:message code='ezBoard.t327' /></th>
			          <c:choose>
				          <c:when test="${adjacentItem.previousItemID == ''}">
					          <td width="100%">
				          </c:when>
				          <c:otherwise>
					          <td style="cursor:pointer" width="100%">
				          </c:otherwise>
			          </c:choose>
			          <div align="left" style="overflow-y:auto;width: 100%; height:18px" onClick="OpenItem('${adjacentItem.previousItemID}')">${adjacentItem.previousTitle}</div>
			        </tr>
			        <tr>
			          <th><spring:message code='ezBoard.t328' /></th>
			          <c:choose>
			          	<c:when test="${adjacentItem.nextItemID == ''}">
				          <td>
			          	</c:when>
			          	<c:otherwise>
				          <td style="cursor:pointer">
			          	</c:otherwise>
			          </c:choose>
			            <div align="left" style="overflow-y:auto;width: 100%; height:18px" onClick="OpenItem('${adjacentItem.nextItemID}')">${adjacentItem.nextTitle}</div>
			        </tr>
			      </table>
			    </td>
			  </tr>
		  </c:if>
		</table>
		<input id="publicModulus" value="${publicModulus}" type="hidden"/>
	    <input id="publicExponent" value="${publicExponent}" type="hidden"/>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>