<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabRelatedFile">
		<h1><spring:message code="ezCabinet.t87"/></h1>
		
		<div id="cabMgClose" class="cabClose"><ul><li><span><spring:message code='ezCabinet.t66'/></span></li></ul></div>
		
		<div class="cabRlSearch">
			<div>
				<input type="text" placeholder="<spring:message code='ezCabinet.t88'/>">
				<a class="cabBttn"><span><spring:message code='ezCabinet.t49'/></span></a>
			</div>
		</div>
		<div class="cabRlMain">
			<div class="cabRlTreeMain">
				<div class="cabRlTreeDiv">
					<div id="folderTree" style="width: 100%; height: 100%; overflow: auto; white-space: nowrap; padding: 5px 0px 0px 5px;">
						<div>
							<img id="3" src="/images/OrganTree_cross/minus.gif" class="webfolderMinus">
							<img class="webfolderImg" src="/images/webfolder/fldr.png">
							<span class="spanName" name="3" level="0" fldname1="(주)가온아이" fldname2="Kaoni, Inc." style="color: rgb(0, 74, 135); font-weight: bold;">(주)가온아이</span>
							<div>
								<div>
									<img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif">
									<img id="84" src="/images/OrganTree_cross/plus.gif" class="webfolderPlus">
									<img class="webfolderImg" src="/images/webfolder/fldr.png">
									<span class="spanName" name="84" level="1" fldname1="aa" fldname2="eee">aa</span>
								</div>
								<div>
									<img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif">
									<img id="91" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg">
									<img class="webfolderImg" src="/images/webfolder/fldr.png">
									<span class="spanName" name="91" level="1" fldname1="ewew" fldname2="ewtwet">ewew</span>
								</div>
								<div>
									<img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif">
									<img id="86" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg">
									<img class="webfolderImg" src="/images/webfolder/fldr.png">
									<span class="spanName" name="86" level="1" fldname1="gdsgs" fldname2="sdgsdg">gdsgs</span>
								</div>
								<div>
									<img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif">
									<img id="90" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg">
									<img class="webfolderImg" src="/images/webfolder/fldr.png">
									<span class="spanName" name="90" level="1" fldname1="hhh" fldname2="hhhh">hhh</span>
								</div>
								<div>
									<img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif">
									<img id="89" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg">
									<img class="webfolderImg" src="/images/webfolder/fldr.png">
									<span class="spanName" name="89" level="1" fldname1="ooo" fldname2="oiooo">ooo</span>
								</div>
								<div>
									<img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif">
									<img id="87" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg">
									<img class="webfolderImg" src="/images/webfolder/fldr.png">
									<span class="spanName" name="87" level="1" fldname1="ttt" fldname2="ttt">ttt</span>
								</div>
								<div>
									<img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif">
									<img id="82" src="/images/OrganTree_cross/minus.gif" class="webfolderMinus">
									<img class="webfolderImg" src="/images/webfolder/fldr.png">
									<span class="spanName" name="82" level="1" fldname1="공통파일" fldname2="공통파일">공통파일</span>
									<div>
										<div>
											<img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif">
											<img class="webfolderImg" src="/images/OrganTree_cross/dot_continue.gif">
											<img id="85" src="/images/OrganTree_cross/dot_continue.gif" class="webfolderImg">
											<img class="webfolderImg" src="/images/webfolder/fldr.png">
											<span class="spanName" name="85" level="2" fldname1="eee" fldname2="eeee">eee</span>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="cabRlSelect">
					<div class="rlSelectTtl">캐비넷 리스트</div>
					<div class="rlSelectTblDiv">
						<table class="rlSelectTbl">
							<tr>
								<th class="thType">타임</th>
								<th>제목</th>
							</tr>
							<tr>
								<td><img src="/images/webfolder/document.png"></td>
								<td>리소스 관련</td>
							</tr>
							<tr>
								<td><img src="/images/webfolder/document.png"></td>
								<td>QC 관련</td>
							</tr>
						</table>
					</div>
					<div id="tblPageRayer" style="height: 10px;"></div>
				</div>
			</div>
			<div class="cabRlBttnDiv">
				<div>
					<img src="/images/arr_right.gif">
					<img src="/images/arr_left.gif" >
				</div>
			</div>
			<div class="cabRlSelected">
				<div class="rlSelectTtl">선택된 문서</div>
				<div class="rlSelectTblDiv">
					<table class="rlSelectTbl">
						<tr>
							<th class="thType">타임</th>
							<th>제목</th>
						</tr>
						<tr>
							<td><img src="/images/webfolder/document.png"></td>
							<td>리소스 관련</td>
						</tr>
						<tr>
							<td><img src="/images/webfolder/document.png"></td>
							<td>QC 관련</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		
		<div class="cabdivBttn" id="cabAddBttn">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		<script type="text/javascript">
			
		</script>
	</body>
</html>

