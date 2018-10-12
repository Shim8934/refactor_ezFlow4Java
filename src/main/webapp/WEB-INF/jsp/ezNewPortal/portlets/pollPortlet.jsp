<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type='text/javascript'>

var pollPortletLoadFunc = function () {
	
}

pollPortletLoadFunc();

</script>
</head>
<body>
<div class="layDiv">
	<dl class="portlet_title sortablePortlet">
		<dt class="portletText">투표 (1)</dt>
		<dd class="portletPlus" id="votePlus"><img src="/images/ezNewPortal/portlet_Plus.png"></dd>
	</dl>
<p class="voteTitle">"다섯개 후보 등록"</p><p class="voteBtn">참여</p>
	<ul class="voteList">
		<li class="voteList_01"><div class="voteT"><span class="Vnum">1</span><span class="Vtext">하이</span></div><div class="percent" id="percent1">100%</div><div class="voteGraph" id="divGraph1"> <span id="graph1" style="width :100%"></span></div></li>
		<li class="voteList_02"><div class="voteT"><span class="Vnum">2</span><span class="Vtext">헬로</span></div><div class="percent" id="percent2">0%</div><div class="voteGraph" id="divGraph2"> <span id="graph2" style="width :0%"></span></div></li>
		<li class="voteList_03"><div class="voteT"><span class="Vnum">3</span><span class="Vtext">안녕</span></div><div class="percent" id="percent3">0%</div><div class="voteGraph" id="divGraph3"> <span id="graph3" style="width :0%"></span></div></li>
		<li class="voteList_04"><div class="voteT"><span class="Vnum">4</span><span class="Vtext">봉쥬르</span></div><div class="percent" id="percent4">0%</div><div class="voteGraph" id="divGraph4"> <span id="graph4" style="width :0%"></span></div></li>
	</ul>
</div>
</body>
</html>