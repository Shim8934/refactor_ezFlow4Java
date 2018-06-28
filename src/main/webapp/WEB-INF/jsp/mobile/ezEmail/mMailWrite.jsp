<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="/js/jquery-ui/jquery-ui.min.js"></script>		
<script type="text/javascript" src="/js/jquery.mobile/jquery.mobile-1.4.5.min.js"></script>
<script type="text/javascript" src="/js/mobile/mEMail.js"></script>
<script type="text/javascript">

$(document).ready(function(){
	$("#signList option[value='${mailSignList.data.useFlag}']").attr("selected", true);
});

</script>
<title>Insert title here</title>
</head>
<body>
	<div class="btns">
	<div class="btn">
	<button onclick="cancelWirte();">취소</button>
	<button onclick="tempSave();">저장</button>
	</div>
	<div class ="btn_action">
	<button onclick="sendMail();">보내기</button>
	</div>
	</div>
	<div class="write_area">
		<div class="sender" style="display:;">
			<h4>보낸사람</h4>
			<div class="ip">
				<select id="sender_address"><option selected="">${sender}</option></select>
				<select id="sender_name"><option selected="">강민석</option></select>
			</div>
		</div>
		<div class="target">
			<h4><label for="to_write">받는사람</label></h4>
			<div class="ip">	
				<!-- <div class="objct"><a href="#"><em>dummy data</em></a></div> -->
				<input type="email" id="to_write" class="text stc" autocomplete="off" style="left:0px">
				<button class="bt_import" onclick="loadAddress()">
				<span class="u_hc">주소록 불러오기</span>
				</button>
			</div>
		</div>
		<div class="carboncopy">
			<h4><a id="toggleCc_btn" class="bt_more" onclick="mWrite.toggleCc(this);">참조<span class="u_hc">참조 입력 닫기</span></a></h4>
			<!-- [D] 닫았을 때
			<h4><a class="bt_more">참조<span class="u_hc">참조 입력 펼치기</span></a></h4></h4>
			-->
			<div class="cc_chk">
				<input type="checkbox" name="cc" id="cc1" class="checkbox" onclick="mWrite.clickSendToMe(this);"><label for="cc1">내게쓰기</label>
				<input type="checkbox" name="cc" id="cc2" class="checkbox" onclick="this.checked ? $Element(this).addClass('checked') : $Element(this).removeClass('checked')"><label for="cc2">개인별</label>
				<input type="checkbox" name="cc" id="cc3" class="checkbox" onclick="this.checked ? $Element(this).addClass('checked') : $Element(this).removeClass('checked')"><label for="cc3">중요<em>!</em></label>
			</div>
			<div id="cc_box" class="ccbox" style="display: none;">
				<h4><label for="cc_write">참조</label></h4>
				<div class="ip">					
					<input type="email" id="cc_write" style="left:0" class="text stc"><button class="bt_import" onclick="if(mWrite.checkIOS8(&quot;POPUP_ADDRESS&quot;)){return;};window.open(&quot;/m/address/list2?pageFrom=write&amp;target=cc&quot;);"><span class="u_hc">주소록 불러오기</span></button>
				</div>
				<div style="display:none" class="auto_lst" id="write_auto_lst_cc">
					<div class="addr_lst">
						<ul></ul>
					</div>
				</div>
			<div class="chk_del andrd" style="display: none;"><span>someone@naver.com</span><p class="btn_area"><button class="tx delete_obj_layer">삭제</button><button class="tx cancel_obj_layer">취소</button></p></div></div>
			<div id="bcc_box" class="ccbox" style="display: none;">
				<h4><label for="bcc_write">숨은참조</label></h4>
				<div class="ip">
					<input type="email" id="bcc_write" style="left:0px" class="text stc"><button class="bt_import" onclick="if(mWrite.checkIOS8(&quot;POPUP_ADDRESS&quot;)){return;};window.open(&quot;/m/address/list2?pageFrom=write&amp;target=bcc&quot;);"><span class="u_hc">주소록 불러오기</span></button>
				</div>
				<div style="display:none" class="auto_lst" id="write_auto_lst_bcc">
					<div class="addr_lst">
						<ul></ul>
					</div>
				</div>
			</div>
		</div>
		
		<div class="sign">
		<h4><label for="sbj">서명</label></h4>
		<select id="signList">
		<option value=1>${mailSignList.data.content1}</option>
		<option value=2>${mailSignList.data.content2}</option>
		<option value=3>${mailSignList.data.content3}</option>
		</select>
		</div>
		<div class="subject">
			<h4><label for="sbj">제목</label></h4>
			<div class="ip"><input type="text" value="" id="subject" name="subject" class="text"></div>
		</div>
		
		<textarea id=textbody name=textbody placeholder="내용을 입력해 주세요." cols="30" rows="7"></textarea>
		
		<div class="attach">
			<h4>첨부파일</h4>
			<div class="slct">
			<button id="upload_btn" onclick="upload()")>파일</button>
			</div>
		</div>
		
	</div>
</body>
</html>