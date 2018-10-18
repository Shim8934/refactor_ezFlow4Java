<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>portalPortlets</title>
	<link rel="stylesheet"  href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/default.css')}" />
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/thumbnailGrid/component.css')}" />
	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/jquery-ui.css')}" />
	<style type="text/css">
	/* main media query */
@media only screen and (min-width :1921px) {
	.box_shadow{ width:483px; float:left;}
}

@media only screen and (max-width :1920px) and (min-width :1686px) { 
	.section_main .mainLayout_right_move{  width:33.3%;}
	.section_main .mainLayout_right{  width:33.3%;}
	.section_main .mainLayout_left{ width:33.3%;}
	.section_main .mainLayout_middle{ width:33.3%;}
	.box_shadow{ width:32%; float:left;}
	.bannerText{ padding:73px 18px 0px 0px;}
}

@media only screen and (max-width :1685px) and (min-width :1280px) {
	.section_main .mainLayout_right_move{ width:50%;}
	.section_main .mainLayout_right{ clear:both; width:50%;}
	.section_main .mainLayout_left{ width:50%;}
	.section_main .mainLayout_middle{ width:50%;}
	.box_shadow{width:48%; float:left;}
	.vote{ margin:0px 2px; float:left; overflow:hidden;}
	.stats_graph{ float:left; overflow:hidden;}
	.groupware_banner{ float:left; margin-top:0px}
	
}

@media only screen and (max-width : 1279px) {
	.box_shadow {width:410px; float:left;}
}
body {
    min-width: 520px;
  }
  .column {
    width: 1820px;
    padding-bottom: 100px;
  }
  .portlet {
  	width:30%;
  	postion: relative;
    margin: 0 1em 1em 0;
    padding: 0.3em;
    display : inline-block;
    vertical-align : top;
  }
  .portlet-header {
    padding: 0.2em 0.3em;
    margin-bottom: 0.5em;
    position: relative;
  }
  .portlet-toggle {
    position: absolute;
    top: 50%;
    right: 0;
    margin-top: -8px;
  }
  .portlet-content {
    padding: 0.4em;
    clear:both;
  }
  .portlet-placeholder {
    border: 1px dotted black;
    margin: 0 1em 1em 0;
    height: 50px;
  }
  .col-container {
    width: 100%;
	}
	.col {
	    padding: 16px;
	}
	</style>
	<script type="text/javascript">
	$( function() {
	    $( ".column .col-container" ).sortable({
	      handle: ".portlet-header",
	      cancel: ".portlet-toggle",
	      placeholder: "portlet"
	    });
	 
	    $( ".portlet" )
	      .addClass( "ui-widget ui-widget-content ui-helper-clearfix ui-corner-all" )
	      .find( ".portlet-header" )
	      .addClass( "ui-widget-header ui-corner-all" )
	      .prepend( "<span class='ui-icon ui-icon-minusthick portlet-toggle'></span>");
	 
		$( ".portlet-toggle" ).on( "click", function() {
			var icon = $( this );
			icon.toggleClass( "ui-icon-minusthick ui-icon-plusthick" );
			icon.closest( ".portlet" ).find( ".portlet-content" ).toggle();
		  
			var thisOrder = icon.attr('data');
			var thisShare = thisOrder / 3;
			var thisRest = thisOrder % 3;
			var otherOrder = "";
			
			for (var int = 0; int < 9; int++) {
				otherOrder =$('#portlet'+i+1).attr('data');
				
				/* if ((otherOrder / 3) === thisShare && (ortherOrder % 3) */
			}
			
			
		});
	  } );
	</script>
</head>
	
<body class="mainbody" marginwidth="0" marginheight="0">
	<h1>포틀릿 관리</h1>
	<div id="mainmenu">
		<span><b>회사 선택  : </b></span>
		<select>
			<option>sample</option>
			<option>sample2</option>
		</select>
		<ul style="margin-top: 15px;">
			<li id="portletAdd"><span>포틀릿 추가</span></li>
			<li id="portletDel"><span>포틀릿 삭제</span></li>
			<li id="portletOrderSave"><span>순서저장</span></li>
			<li id="portletOrderReset"><span>포틀릿 순서 초기화</span></li>
		</ul>
	</div>
	
	<h1># 드래그 앤 드롭을 하고 순서저장 버튼을 누르면 기본 포틀릿 순서를 지정할 수 있습니다.</h1>
	<br>
			
	<div class="column">
	<ul class="col-container">
		<li class="portlet col" id="portlet1" data="por1">
			<div class="portlet-header">게시판1</div>
			<div class="portlet-content">
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>게시판설정  : </b>공지사항<button>설정</button></div>
			</div>
		</li>
		<li class="portlet col" id="portlet2" data="por2">
			<div class="portlet-header">게시판2</div>
			<div class="portlet-content">
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>게시판설정  : </b>공지사항<button>설정</button></div>
			</div>
		</li>
		<li class="portlet col" id="portlet3" data="por3">
			<div class="portlet-header">게시판3</div>
			<div class="portlet-content">
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>게시판설정  : </b>공지사항<button>설정</button></div>
			</div>
		</li>
		<li class="portlet col" id="portlet4" data="por4">
			<div class="portlet-header">게시판4</div>
			<div class="portlet-content">
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>게시판설정  : </b>공지사항<button>설정</button></div>
			</div>
		</li>
		<li class="portlet col" id="portlet5" data="por5">
			<div class="portlet-header">게시판5</div>
			<div class="portlet-content">
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>게시판설정  : </b>공지사항<button>설정</button></div>
			</div>
		</li>
		<li class="portlet col" id="portlet6" data="por6">
			<div class="portlet-header">게시판6</div>
			<div class="portlet-content">
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>게시판설정  : </b>공지사항<button>설정</button></div>
			</div>
		</li>
		<li class="portlet col" id="portlet7" data="por7">
			<div class="portlet-header">게시판7</div>
			<div class="portlet-content">
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>게시판설정  : </b>공지사항<button>설정</button></div>
			</div>
		</li>
		<li class="portlet col" id="portlet8" data="por8">
			<div class="portlet-header">게시판8</div>
			<div class="portlet-content">
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>게시판설정  : </b>공지사항<button>설정</button></div>
			</div>
		</li>
		<li class="portlet col" id="portlet9" data="por9">
			<div class="portlet-header">게시판9</div>
			<div class="portlet-content">
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>포틀릿 사용  : </b></div>
				<div><b>게시판설정  : </b>공지사항<button>설정</button></div>
			</div>
		</li>
	</ul>
		
	</div> 
 
 
 
 
</body>
	
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>

<!-- thumbGrid opensource -->
<script type="text/javascript" src="${util.addVer('/js/thumbnailGrid/modernizr.custom.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/thumbnailGrid/grid.js')}"></script>

</html>