<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezCircular.c1" />" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezCircular/circularComment.js"></script>
		
		<script type="text/javascript">
			var circularID = "${vo.circularID}";
			var circularUserID = "${vo.memberID}";
			var status = "${vo.status}";
			var userInfoID = "${userInfo.id}";
			
			$(document).ready(function(){
				getCircularComment();
				
				$("#searchValue").keypress(function(e) {
					if (e.keyCode == 13) {
						getCircularComment();
					}
				});
			});
		</script>
		
	</head>
	<body class="popup" style="overflow: hidden;">
		<h1>의견목록</h1>
		
		<div id="close">
			<ul>
				<li><span onclick="commentSendMail();">회람확인메일발송</span></li>
				<li><span onclick="closeCircularComment();"><spring:message code='ezResource.t150' /></span></li>
			</ul>
		</div>
		
		<script type="text/javascript" >
   			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		
		<table class="mainlist" style="width:103%;margin-left: -10px;margin-top:-10px;">
			<tr>
				<th style="width: 51.5px;border-top:0px">&nbsp;<img src="/images/search.png" align="middle"/>&nbsp;검색</th>
				<th style="text-align:right;border-top:0px">
					<select id = 'searchType'>
						<option value = 'circularUserID'>회람자</option>
						<option value = 'circularComment'>내용</option>
					</select>
					<input type='text' id='searchValue' />&nbsp;<a class='imgbtn'><span onclick="getCircularComment()">검색</span>&nbsp;</a>
				</th>
			</tr>			
		</table>
		
		<div style="height:500px;overflow-y: auto;">			
			<table id="circularUserList" style="width:100%;margin-top:15px;table-layout: fixed">
				<colgroup>
					<col width="15%" /><col width="72%" /><col width="13%" />
				</colgroup>
				<tr class="circularUser" style="height:40px;text-align:left">
					<th style="border-right:0px;background-color: #fafafa;border-color:#e2e2e2;text-align:left"><img src="/images/i_group.gif" align="middle"/>&nbsp;장진혁&nbsp;<img src="/images/modify2.gif" align="middle"/>&nbsp;&nbsp;&nbsp;&nbsp;2017-06-28 16:40</th>
					<th style="border-left:0px;text-align:right;background-color: #fafafa;border-color:#e2e2e2" colspan="2">
						확인완료
					</th>
				</tr>
				<tr class="circularComment" style="height:40px;text-align:left;border-top:1px solid #e2e2e2">
					<td style="padding-left:3px"><img src="/images/i_rep.gif" align="middle"/>&nbsp;&nbsp;장진혁</td>
					<td style="text-align:left;padding:10px;">안녕하세요. 장진혁입니다. 방갑습니다.&nbsp;(18:30)&nbsp;<img src="/images/comment_del.gif" align="middle"/></td>
					<td style="text-align:right;padding-right:8px">
						2017-06-28
					</td>
				</tr>
				<tr style="height:40px;text-align:left;border-top:1px solid #e2e2e2">
					<td style="padding-left:3px"><img src="/images/i_rep.gif" align="middle"/>&nbsp;&nbsp;장진혁</td>
					<td style="text-align:left;padding:10px;">안녕하세요. 장진혁입니다. 방갑습니다.&nbsp;(18:30)&nbsp;<img src="/images/comment_del.gif" align="middle"/></td>
					<td style="text-align:right;padding-right:8px">
						2017-06-28
					</td>
				</tr>
				<tr style="height:40px;text-align:left;border-top:1px solid #e2e2e2">
					<td style="padding-left:3px"><img src="/images/i_rep.gif" align="middle"/>&nbsp;&nbsp;장진혁</td>
					<td style="text-align:left;padding:10px;">안녕하세요. 장진혁입니다. 방갑습니다.&nbsp;(18:30)&nbsp;<img src="/images/comment_del.gif" align="middle"/></td>
					<td style="text-align:right;padding-right:8px">
						2017-06-28
					</td>
				</tr>
				<tr style="height:40px;text-align:left;border-top:1px solid #e2e2e2">
					<td style="padding-left:3px"><img src="/images/i_rep.gif" align="middle"/>&nbsp;&nbsp;장진혁</td>
					<td style="text-align:left;padding:10px;">안녕하세요. 장진혁입니다. 방갑습니다.&nbsp;(18:30)&nbsp;<img src="/images/comment_del.gif" align="middle"/></td>
					<td style="text-align:right;padding-right:8px">
						2017-06-28
					</td>
				</tr>
				<tr style="height:40px;text-align:left;border-top:1px solid #e2e2e2">
					<td style="padding-left:3px"><img src="/images/i_rep.gif" align="middle"/>&nbsp;&nbsp;장진혁</td>
					<td style="text-align:left;padding:10px;">안녕하세요. 장진혁입니다. 방갑습니다.&nbsp;(18:30)&nbsp;<img src="/images/comment_del.gif" align="middle"/></td>
					<td style="text-align:right;padding-right:8px">
						2017-06-28
					</td>
				</tr>
				<tr style="height:40px;text-align:left;border-top:1px solid #e2e2e2">
					<td style="padding-left:3px"><img src="/images/i_rep.gif" align="middle"/>&nbsp;&nbsp;장진혁</td>
					<td style="text-align:left;padding:10px;">안녕하세요. 장진혁입니다. 방갑습니다.&nbsp;(18:30)&nbsp;<img src="/images/comment_del.gif" align="middle"/></td>
					<td style="text-align:right;padding-right:8px">
						2017-06-28
					</td>
				</tr>
				<tr style="height:40px;text-align:left;border-top:1px solid #e2e2e2">
					<td style="padding-left:3px"><img src="/images/i_rep.gif" align="middle"/>&nbsp;&nbsp;김길동</td>
					<td style="text-align:left;padding:10px;">잘 읽었습니다.(19:30)</td>
					<td style="text-align:right;padding-right:8px;">
						2017-06-28
					</td>
				</tr>
				<tr style="height:40px;text-align:left;border-top:1px solid #e2e2e2">
					<td style="padding-left:3px"><img src="/images/i_rep.gif" align="middle"/>&nbsp;&nbsp;이경국</td>
					<td style="text-align:left;padding:10px">무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.무궁화 꽃이 피었습니다.&nbsp;(12:35)</td>
					<td style="text-align:right;padding-right:8px">
						2017-06-28
					</td>
				</tr>
				<tr style="height:40px;text-align:left;">
					<th style="border-right:0px;background-color: #fafafa;border-color:#e2e2e2;text-align:left"><img src="/images/i_group.gif" align="middle"/>&nbsp;김길동&nbsp;<img src="/images/modify2.gif" align="middle"/>&nbsp;&nbsp;&nbsp;&nbsp;2017-06-28 20:20</th>
					<th style="border-left:0px;text-align:right;background-color: #fafafa;border-color:#e2e2e2" colspan="2">
						확인완료
					</th>
				</tr>
				<tr style="height:40px;text-align:left;border-top:1px solid #e2e2e2">
					<td style="padding-left:3px"><img src="/images/i_rep.gif" align="middle"/>&nbsp;&nbsp;장진혁</td>
					<td style="text-align:left;padding:10px;">안녕하세요. 장진혁입니다. 방갑습니다.&nbsp;(18:30)&nbsp;<img src="/images/comment_del.gif" align="middle"/></td>
					<td style="text-align:right;padding-right:8px">
						2017-06-28 
					</td>
				</tr>
				<tr style="height:40px;text-align:left;border-top:1px solid #e2e2e2">
					<td style="padding-left:3px"><img src="/images/i_rep.gif" align="middle"/>&nbsp;&nbsp;김길동</td>
					<td style="text-align:left;padding:10px;">잘 읽었습니다.&nbsp;(17:20)</td>
					<td style="text-align:right;padding-right:8px;">
						2017-06-28
					</td>
				</tr>
				<tr style="height:40px;text-align:left">
					<th style="border-right:0px;background-color: #fafafa;border-color:#e2e2e2;text-align:left""><img src="/images/i_group.gif" align="middle"/>&nbsp;김구라&nbsp;<img src="/images/modify2.gif" align="middle"/></th>
					<th style="border-left:0px;text-align:right;background-color: #fafafa;border-color:#e2e2e2" colspan="2">
						미확인
					</th>
				</tr>
				<tr style="height:40px;text-align:left">
					<th style="border-right:0px;background-color: #fafafa;border-color:#e2e2e2;text-align:left""><img src="/images/i_group.gif" align="middle"/>&nbsp;이경국&nbsp;<img src="/images/modify2.gif" align="middle"/></th>
					<th style="border-left:0px;text-align:right;background-color: #fafafa;border-color:#e2e2e2" colspan="2">
						미확인
					</th>
				</tr>	
				<tr style="height:40px;text-align:left">
					<th style="border-right:0px;background-color: #fafafa;border-color:#e2e2e2;text-align:left""><img src="/images/i_group.gif" align="middle"/>&nbsp;김구라&nbsp;<img src="/images/modify2.gif" align="middle"/></th>
					<th style="border-left:0px;text-align:right;background-color: #fafafa;border-color:#e2e2e2" colspan="2">
						미확인
					</th>
				</tr>
				<tr style="height:40px;text-align:left">
					<th style="border-right:0px;background-color: #fafafa;border-color:#e2e2e2;text-align:left""><img src="/images/i_group.gif" align="middle"/>&nbsp;이경국&nbsp;<img src="/images/modify2.gif" align="middle"/></th>
					<th style="border-left:0px;text-align:right;background-color: #fafafa;border-color:#e2e2e2" colspan="2">
						미확인
					</th>
				</tr>
				<tr style="height:40px;text-align:left">
					<th style="border-right:0px;background-color: #fafafa;border-color:#e2e2e2;text-align:left""><img src="/images/i_group.gif" align="middle"/>&nbsp;김구라&nbsp;<img src="/images/modify2.gif" align="middle"/></th>
					<th style="border-left:0px;text-align:right;background-color: #fafafa;border-color:#e2e2e2" colspan="2">
						미확인
					</th>
				</tr>
				<tr style="height:40px;text-align:left">
					<th style="border-right:0px;background-color: #fafafa;border-color:#e2e2e2;text-align:left""><img src="/images/i_group.gif" align="middle"/>&nbsp;이경국&nbsp;<img src="/images/modify2.gif" align="middle"/></th>
					<th style="border-left:0px;text-align:right;background-color: #fafafa;border-color:#e2e2e2" colspan="2">
						미확인
					</th>
				</tr>	
				<tr style="height:40px;text-align:left">
					<th style="border-right:0px;background-color: #fafafa;border-color:#e2e2e2;text-align:left""><img src="/images/i_group.gif" align="middle"/>&nbsp;김구라&nbsp;<img src="/images/modify2.gif" align="middle"/></th>
					<th style="border-left:0px;text-align:right;background-color: #fafafa;border-color:#e2e2e2" colspan="2">
						미확인
					</th>
				</tr>
				<tr style="height:40px;text-align:left">
					<th style="border-right:0px;background-color: #fafafa;border-color:#e2e2e2;text-align:left""><img src="/images/i_group.gif" align="middle"/>&nbsp;이경국&nbsp;<img src="/images/modify2.gif" align="middle"/></th>
					<th style="border-left:0px;text-align:right;background-color: #fafafa;border-color:#e2e2e2" colspan="2">
						미확인
					</th>
				</tr>						
			</table>
		</div>
		<!-- <table class="mainlist" style="width:100%">
			<tr>
				<th style="width: 51.5px;">의견</th>
				<th style="text-align:right;">
					<select id = 'searchType'>
						<option value = 'circularUserID'>회람자</option>
						<option value = 'circularComment'>내용</option>
					</select>
					<input type='text' id='searchValue' /><a class='imgbtn'><span onclick="getCircularComment()">검색</span></a></th>
			</tr>
			<tr>
				<td style="width: 100%; border:0px;" colspan='2'>
					<table id="comments" style="width:100%">
						<tr>
							<td style="border:0px;">
								<table id="commentUserList" class="mainlist" style="width:100%"></table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table> -->
	</body>
</html>