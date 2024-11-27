/**
	@파일명 : remarkMsgObj.js
	@만든이 : nckim
	@파일내용
	[주석 및 설명 메시지 관리]
	-- json형식으로 구성되어 있기에 편집시 무조건 콤마(,)와 쌍따옴표 처리를 올바로 해야 합니다.
	0번째 : 웹상에서 보여질 메시지(태그 적용 가능)
	1번째 : XML상에서 보여질 주석 메시지(개행처리는 \r\n\t)
*/
objRemark = {
	xfeEnv: {		
		ShowTab: [
			"<span>에디터 하단 Tab 설정</span>@"+
			"<ul>"+
				"<li><b>디자인(기본)</b> : 디자인</li>"+
				"<li><b>HTML</b> : Source</li>"+
				"<li><b>미리보기</b> : Preview</li>"+
				"<li><b>텍스트</b> : Text (XFE 3.0 이상 지원)</li>"+
			"</ul>", 
			
			"하단 탭 설정. \r\n\t"+
			"design : 디자인(기본)\r\n\t"+
			"source : HTML\r\n\t"+
			"preview : 미리보기\r\n\t"+
			"text : 텍스트(XFE 3.0 이상 지원)"
		],
		FontSize: [
			"<span>기본 폰트 사이즈 설정</span>", 
			
			"기본 폰트 사이즈 설정"
		],
		FontFamily: [
			"<span>기본 폰트 설정</span>", 
			
			"기본 폰트 설정"
		],
		StyleSheetLink: [
			"<span>스타일 시트 참조</span>", 
			
			"스타일 시트 참조"
		],
		ServerSide: [
			"<span>서버 전송 방식 설정</span>@"+
			"<span>▶ false : 기본값 적용</span><br /><br />"+
			"<ul >"+
				"<li><b>jsp </b>: 서버가 JAVA 환경인 경우 (기본값)</li>"+
				"<li><b>php </b>: 서버가 PHP 환경인 경우</li>"+
				"<li><b>asp </b>: 서버가 ASP 환경인 경우</li>"+
				"<li><b>aspx </b>: 서버가 닷넷 환경인 경우</li>"+
			"</ul>", 
			
			"기본 동작 언어 설정\r\n\t"+
			"jsp : 서버가 JAVA환경인 경우 세팅\r\n\t"+
			"php : 서버가 PHP환경인 경우 세팅\r\n\t"+
			"asp : 서버가 ASP환경인 경우 세팅\r\n\t"+
			"aspx : 서버가 닷넷환경인 경우 세팅"
		],
		LetterSpacing: [
			"<span>기본 글자 간의 간격 설정 (DefaultStyleCSS 설정 시, 무시)</span>", 
			
			"글자간의 간격 기본 설정(DefaultStyleCSS 설정 시, 무시) "
		],
		Language: [
			"<span>기본 언어 설정</span>@"+
			"<span>▶ false : 기본값 적용</span><br /><br />"+
			"<ul><li><b>korean </b>: 한국어 (기본값)</li>"+
				"<li><b>english </b>: 영어</li>"+
				"<li><b>chinese_s </b>: 중국어-간체</li>"+
				"<li><b>chinese_t</b> : 중국어-번체</li>"+
				"<li><b>japanese </b>: 일본어</li>"+
			"</ul>", 
			
			"기본 언어 설정. false 일 경우 korean.\r\n\t"+
			"korean : 한국어 세팅\r\n\t"+
			"english : 영어 세팅\r\n\t"+
			"chinese_s : 중국어(간체) 세팅\r\n\t"+
			"chinese_t : 중국어(번체) 세팅\r\n\t"+
			"japanese : 일본어 세팅"
		],
		DefaultStyleCSS: [
			"<span>기본 적용 스타일 설정</span>", 
			
			"기본 적용 스타일 설정을 합니다."
		],
		FontFamilyValue: [
			"<span>글씨체 목록 관리 설정</span><br /><br />"+
			"<span>▶ false : 기본값 적용</span><br /><br />"+
			"<ul>"+
				"<li><b>width</b> : <br /><span>- 값이 0 이상일 경우, 툴바 메뉴의 넓이를 설정값으로 적용</span> <br /><span>- 값이 0 일 경우, 120 (기본값) 적용</span></li><br />"+
				"<li><b>style </b>: <span>base / button</span><br /><span>- base : 기본 select 객체로 적용 </span><br /><span>- button : 글꼴, 사이즈는 div 로 만든 콤보 박스 </span><br /></li>"+
			"</ul>", 
			
			"글꼴, 글자크기, 글자간격, 줄간격 메뉴의 값들을 설정 합니다.\r\n\t"+
			"apply 가 false 일 경우 기본 값들이 적용 됩니다.\r\n\t"+
			"width : 값이 0 이상일 경우 해당 툴바 메뉴의 넓이를 설정값으로 적용. 단위 px \r\n\t"+
			"0 일 경우 기본 사이즈 적용.\r\n\t"+
			"기본 사이즈 FontFamilyValue : 120, FontSizeValue : 54, LetterSpacingValue : 82, LineHeightValue : 70 \r\n\t"+
			"style : 값이 base 일 경우 기본 select 객체로 적용. button 일 경우 글꼴, 사이즈는 div combo box. 줄간격, 글자 간격은 버튼 적용. base 사용 권장."
		],
		FontSizeValue: [
			"<span>글자크기 목록 관리 설정</span><br /><br />"+
			"<span>▶ false : 기본값 적용</span><br /><br />"+
			"<ul>"+
				"<li><b>width</b> : <br /><span>- 값이 0 이상일 경우, 툴바 메뉴의 넓이를 설정값으로 적용</span> <br /><span>- 값이 0 일 경우, 54 (기본값) 적용</span></li><br />"+
				"<li><b>style </b>: <span>base / button</span><br /><span>- base : 기본 select 객체로 적용 </span><br /><span>- button : 글꼴, 사이즈는 div 로 만든 콤보 박스 </span><br /></li>"+
			"</ul>", 
			
			"글자 크기 목록 관리 설정"
		],
		LineHeightValue: [
			"<span>줄 간격 목록 관리 설정</span><br /><br />"+
			"<span>▶ false : 기본값 적용</span><br /><br />"+
			"<ul>"+
				"<li><b>width</b> : <br /><span>- 값이 0 이상일 경우, 툴바 메뉴의 넓이를 설정값으로 적용</span> <br /><span>- 값이 0 일 경우, 70 (기본값) 적용</span></li><br />"+
				"<li><b>style </b>: <span>base / button</span><br /><span>- base : 기본 select 객체로 적용 </span><br /><span>- button : 글꼴, 사이즈는 div 로 만든 콤보 박스 </span><br /></li>"+
			"</ul>", 
			
			"줄 간격 목록 관리 설정"
		],
		LetterSpacingValue: [
			"<span>글자 간격 목록 관리 설정</span><br /><br />"+
			"<span>▶ false : 기본값 적용</span><br /><br />"+
			"<ul>"+
				"<li><b>width</b> : <br /><span>- 값이 0 이상일 경우, 툴바 메뉴의 넓이를 설정값으로 적용</span> <br /><span>- 값이 0 일 경우, 82 (기본값) 적용</span></li><br />"+
				"<li><b>style </b>: <span>base / button</span><br /><span>- base : 기본 select 객체로 적용 </span><br /><span>- button : 글꼴, 사이즈는 div 로 만든 콤보 박스 </span><br /></li>"+
			"</ul>", 
				
			"글자 간격 목록 관리 설정"
		],
		Charset: [
			"<span>에디터 로드시 기본적으로 charset Meta 태그가 들어가도록 설정.</span>@"+
			"<span>▶ false : 기본값 적용. Meta 태그는 생성 되지 않습니다.</span><br /><br />"+
			"<span>▶ 에디터 내부의 HEAD 태그 안에 Meta 로 charset 이 설정 됩니다.</span><br /><br />"+
			"<span>▶ setHtmlValue 를 사용하여 데이터를 넣거나 하단 탭 이동시에도 charset Meta 태그가 없는 경우 자동으로 추가 됩니다.</span>",
							
			"에디터 로드시 기본적으로 charset Meta 태그가 들어가도록 설정. \r\n\t"+
			"apply : false 일 경우 Meta 태그는 생성 되지 않습니다. \r\n\t"+
			"에디터 내부의 HEAD 태그 안에 Meta 로 charset 이 설정 됩니다. \r\n\t"+
			"setHtmlValue 를 사용하여 데이터를 넣거나 하단 탭 이동시에도 charset Meta 태그가 없는 경우 자동으로 추가 됩니다."
		],
		LimitImageSize: [
			"<span>이미지 업로드 시, 사이즈 설정</span>@"+
			"<span>▶ 이미지 업로드 시, width 와 height 값을 체크하여 기준값을 초과할 경우 기준값으로 설정합니다.</span><br />"+
			"<span>▶ 설정값이 없거나 0 일 경우, 체크하지 않습니다.</span><br />"+
			"<span style='color: rgb(255, 0, 0);'>▶ 해당 기능은 브라우저의 종류 또는 환경 및 버전에 따라 동작하지 않을 수 있습니다.</span>", 
			
			"이미지를 업로드 할 경우 width 와 height 를 체크하여 기준 값을 초과 할 경우 기준 값으로 설정. \r\n\t"+
			"설정값이 없거나 0 일 경우 체크하지 않습니다. 사이즈 단위 px \r\n\t"+
			"해당 기능은 브라우저의 종류 또는 환경 및 버전에 따라 동작하지 않을 수 있습니다."
		],
		UploadPastedImage: [
			"<span>이미지 붙여넣기 / Drag&amp;Drop 경우, 브라우저에서 처리되는 base64 형태의 데이터 사용 설정</span>@"+
			"<ul>"+
				"<li><b>on </b>: 업로드 처리</li>"+
				"<li><b>off </b>: 별도의 처리를 하지 않음 (base64 형태)</li>"+
			"</ul><br />"+
			"<span>▶ true - on 일 경우, 업로드를 처리하는 upload_contents.[php|aspx|asp|jsp] 파일의 경로를 확인해야 합니다.</span>", 
			
			"이미지를 붙여 넣거나 Drag&Drop 할 경우 브라우저에서 처리 되는 base64 형태의 데이터를 사용 할 것인지 설정. \r\n\t"+
			"on : 이미지를 붙여 넣거나 Drag&Drop 을 할 때 업로드 처리. \r\n\t"+
			"off : 이미지를 붙여 넣거나 Drag&Drop 을 할 때 별도의 처리를 하지 않음. (base64 형태) \r\n\t"+
			"true - on 일 경우 업로드를 처리하는 upload_contents.[php|aspx|asp|jsp] 파일의 경로를 확인 해야 합니다."
		],
		InsertImageAsBase64: [
			"<span>에디터의 이미지 삽입 기능을 통하여 이미지 삽입 시, 이미지를 업로드 처리하지 않고 base64 데이터 형태로 넣어주는 설정</span>@"+
			"<span>▶ 기본 설정 : false</span><br />"+
			"<span>▶ IE 10 이상, FileReader 를 지원하는 브라우저에서만 사용 가능합니다.</span>", 
			
			"툴바의 이미지 삽입 버튼을 눌러 이미지를 넣을 때 이미지를 업로드 처리 하지 않고 base64 데이터 형태로 넣어주는 설정\r\n\t"+
			"IE 10 이상, FileReader 를 지원하는 브라우저에서만 사용 가능합니다"
		],
		TableBorderCollapse: [
			"<span>Table 태그에 border-collapse 스타일이 없을 경우, 기본으로 설정</span>@"+
			"<span>▶ Output 데이터에 적용됩니다.</span><br />"+
			"<span style='color: rgb(255, 0, 0);'>▶ Table 태그에 border-collapse 스타일이 없을 경우, 테이블의 테두리가 부분적으로 굵게 나타나는 경우가 있습니다.</span>", 
			
			"Table 태그에 border-collapse 스타일이 없을 경우  기본적으로 설정. \r\n\t"+
			"Table 태그에 border-collapse 스타일이 없을 경우 테이블의 테두리가 부분적으로 굵게 나타나는 경우가 있습니다. \r\n\t"+
			"Output 데이터에 적용 됩니다."
		],
		RemoveTableBorderCollapse: [
			"<span>작성된 문서의 모든 Table 태그의 border-collapse 스타일 제거 설정</span>", 
			
			"작성된 문서의 모든 Table 태그의 border-collapse 스타일을 제거 해줍니다. \r\n\t"+
			"TableBorderCollapse < RemoveTableBorderCollapse"
		],
		ActiveHyperLink: [
			"<span>디자인 탭에서 하이퍼 링크를 클릭했을 경우, 동작이 되도록 설정</span>@"+
			"<span>▶ false :</span><br/>"+
			"<span> &nbsp;&nbsp;&nbsp;- 동작하지 않으며, 일반 편집 가능</span><br />"+
			"<span> &nbsp;&nbsp;&nbsp;- Ctrl + 마우스 왼쪽 클릭으로 링크 동작 가능</span>", 
			
			"디자인 탭에서 하이퍼 링크를 클릭했을 때 동작이 되도록 설정. \r\n\t"+
			"false 일 경우 클릭 했을 때 동작하지 않으며, 일반 편집 가능. \r\n\t"+
			"false 일 경우 Ctrl + 마우스 왼쪽 클릭으로 링크 동작 가능."
		],
		TableCellParagraph: [
			"<span>Table 복사 / 붙여넣기 시, TD 태그 안에 P 태그가 없을 경우 P 태그를 생성하게 설정</span>@"+
			"<span>▶ 기본 설정 : true</span><br />"+
			"<span>▶ style : 생성되는 P 태그에 style 을 설정해줄 경우 추가</span><br />"+
			"<span style='color: rgb(255, 0, 0);'>▶ TD 태그 안에 P 태그가 없을 경우 브라우저에 따라 커서의 위치가 이상하게 보일 수 있습니다.</span>", 
			
			"Table 을 복사해서 붙여 넣을 때 Td 태그 안에 P 태그가 없을 경우 P 태그를 생성하게 설정. \r\n\t"+
			"Td 태그 안에 P 태그가 없을 경우 브라우저에 따라 커서의 위치가 이상하게 보일 수 있습니다. \r\n\t"+
			"기본 설정 true \r\n\t"+
			"style : 생성되는 P 태그에 style 을 설정 해줄 경우 추가."
		],
		SetInitFontStyle: [
			"<span>에디터에서 출력되거나 입력되는 모든 데이터에서 P 태그를 체크해 기본 글꼴 및 사이즈를 설정</span>@"+
			"<span>▶ 기본 설정 : true</span><br />"+
			"<span>▶ 에디터에서 작성한 내용이 저장 후 외부의 글꼴 또는 사이즈의 영향을 받을 때, P 태그에 inline style 로 지정하는 것을 권장합니다.</span>", 
			
			"에디터에서 출력 되거나 입력되는 모든 데이터에서 P 태그를 체크해 기본 글꼴 및 사이즈를 설정 해줍니다. \r\n\t"+
			"에디터에서 작성한 내용이 저장 후 외부의 글꼴 또는 사이즈의 영향을 받을 때 P 태그에 inline style 로 지정하는 것을 권장. \r\n\t"+
			"기본 설정 true"
		],
		SetInitFontStyleInDiv: [
			"<span>에디터에서 출력되는 데이터에서 DIV 태그를 체크해 기본 글꼴 및 사이즈를 설정 해줍니다.</span>@"+
			"<span>▶ 기본 설정 : false</span><br />"+
			"<span>▶ DIV 태그는 레이아웃을 처리하고 P 태그로 문단을 처리할 때 사용하는 것을 권장하기 때문에 부득이한 경우 해당 설정 값으로 DIV 에도 기본 글꼴과 사이즈를 설정 할 수 있게 추가합니다.</span><br />"+
			"<span>▶ DIV 태그는 P 태그와 다르게 output 되는 데이터에만 적용 해줍니다.</span>", 
			
			"에디터에서 출력되는 데이터에서 DIV 태그를 체크해 기본 글꼴 및 사이즈를 설정 해줍니다. \r\n\t"+
			"DIV 태그는 레이아웃을 처리 하고 P 태그로 문단을 처리할때 사용하는 것을 권장하기 때문에 \r\n\t"+
			"부득이한 경우 해당 설정 값으로 DIV 에도 기본 글꼴과 사이즈를 설정 할 수 있게 추가합니다. \r\n\t"+
			"DIV 태그는 P 태그와 다르게 output 되는 데이터에만 적용 해줍니다.\r\n\t"+
			"기본 설정 false"
		],
		SetInitParagraphStyle: [
			"<span>에디터에 데이터가 입력 또는 출력될 때 모든 P 태그를 체크해 설정한 스타일이 inline style 로 추가되게 해줍니다.</span>@"+
			"<span>▶ 기본 설정 : false</span><br />"+
			"<span>▶ 기존에 P 태그에 있는 inline style 의 뒤쪽에 추가되기 때문에 동일한 스타일이 중복될 경우 설정한 스타일이 적용됩니다.</span><br /><br />"+
			"<ul>"+
				"<li><b>action </b>: <br/>"+
				"- out : getBodyValue, getHtmlValue 를 사용해 에디터에서 데이터가 출력될 때 적용<br />"+
				"- in : setBodyValue, setHtmlValue 를 사용해 에디터에 데이터를 입력할 때 적용. 에디터 하단의 HTML 탭에 입력 후 디자인 탭으로 이동 시 적용<br />"+
				"- both : 에디터에 데이터가 입력 또는 출력될 때 모두 적용"+
				"</li>"+
				"<li><b>style </b>: 적용하고자 하는 style 입력"+
				"</li>"+
			"</ul>",
			
			"에디터에 데이터가 입력 또는 출력 될때 모든 P 태그를 체크해 설정한 스타일이 inline style 로 추가되게 해줍니다. \r\n\t"+
			"기존에 P 태그에 있는 inline style 의 뒤쪽에 추가 되기 때문에 동일한 스타일이 중복 될 경우 설정 한 스타일이 적용 됩니다.\r\n\t"+
			"apply : 해당 기능 사용 설정. 기본 설정 false\r\n\t"+
			"action : out, in, both  설정 가능.\r\n\t"+
			"out : getBodyValue, getHtmlValue 를 사용해 에디터에서 데이터가 출력 될때 적용.\r\n\t"+
			"in : setBodyValue, setHtmlValue 를 사용해 에디터에 데이터를 입력 할 때 적용.  에디터 하단의 HTML 탭에 입력 후 디자인 탭으로 이동시 적용.\r\n\t"+
			"both : 에디터에 데이터가 입력 또는 출력 될때 모두 적용.\r\n\t"+
			"style : 적용 하고자 하는 style"
		],
		ShowGrid: [
			"<span>Grid Line 표시 설정 (XFE 2.5 이상 지원)</span>@"+
			"<ul>"+
				"<li><b>color </b>: red / blue / green / orange / lime</li>"+
				"<li><b>size </b>: A3 / A4 / B4</li>"+
				"<li><b>type </b>:<br />- 적용하려는 grid 이름 (미 설정 시, 기본 grid 파일 적용)<br />- 이름 앞에 xfe_grid_ subfix 추가 권장 <br />- ex) : xfe_grid_test</li>"+
				"<li><b>repeat </b>:<br />- 반복 설정 <br />- repeat (기본값) / repeat-x / repeat-y / no-repeat</li>"+
			"</ul>", 
			
			"Grid Line 을 표시 해준다. \r\n\t"+
			"XFE 2.5 이상에서만 제공. \r\n\t"+
			"현재 테스트 중이라 A4, red 만 가능. \r\n\t"+
			"color : red, blue, green, orange, lime \r\n\t"+
			"size : A3, A4, B4 \r\n\t"+
			"type : 적용 하려는 grid 이름. 미 설정시 기본 grid 파일 적용. \r\n\t"+
			"이름 앞에 xfe_grid_   subfix 추가 권장.  ex) : xfe_grid_test \r\n\t"+
			"repeat : 반복 설정. 기본값 repeat.  repeat-x, repeat-y, no-repeat, repeat"
		],
		ShowVerticalLine: [
			"<span>세로 가이드라인 표시 설정 (XFE 3.0 이상 지원)</span>@" +
			"<span>▶ 세로 가이드라인은 작성 영역의 가로 스크롤을 따라 이동하지 않고 정해진 위치에 고정됩니다.</span><br/>"+
			"<span>▶ 본문 내용 및 스크롤의 위치에 따라 이동을 원하는 경우 ShowGrid 설정을 사용하시기 바랍니다.</span><br/><br/>"+
			"<ul>" + 
				"<li><b>left </b>: 에디터의 작성영역 왼쪽을 기준으로 위치 설정</li>" + 
				"<li><b>color </b>: 색상명 또는 헥사코드, RGB 색상으로 선 색상 설정</li>" + 
				"<li><b>style </b>: solid, dotted, dashed 중 선 종류 설정</li>" + 
			"</ul>", 
			
			"세로 가이드라인 표시 설정 (XFE 3.0 이상 지원). \r\n\t"+
			"세로 가이드 라인은 작성 영역의 가로 스크롤을 따라 이동하지 않고 정해진 위치에 고정 됩니다.\r\n\t"+
			"가로 스크롤이 생겨 이동이 되어도 가이드 라인은 움직이지 않습니다.\r\n\t"+
			"본문 내용 및 스크롤의 위치에 따라 이동을 원하는 경우 ShowGrid 설정을 사용하시기 바랍니다."+
			"left : 위치를 설정. 에디터의 작성영역 왼쪽을 기준으로 설정. 단위 px\r\n\t"+
			"color : 선의 색상 설정. 색상명 또는 헥사코드, RGB 색상으로  설정 가능.\r\n\t"+
			"style : 선의 종류 설정. solid, dotted, dashed 설정 가능.\r\n\t"
			
		],
		HideMobileToolbar: [
			"<span>모바일에서의 툴바 설정</span>@"+
			"<span>▶ 기본 설정 : false</span><br />"+
			"<span>▶ 모바일 환경에서는 에디터의 툴바를 조절 할 수 없습니다.</span><br />"+
			"<span>▶ 모바일 환경에서는 동작 할 수 있는 최소한의 툴바만 나타납니다.</span><br />"+
			"<span>▶ 모바일 환경에서 툴바를 숨기고 쓰기 영역만을 표시할 때 설정합니다.</span><br />"+
			"<span style='color: rgb(255, 0, 0);'>▶ 해당 설정은 모바일 환경에서만 적용됩니다.</span>", 
			
			"모바일 환경에서는 에디터의 툴바를 조절 할 수 없습니다. \r\n\t"+
			"모바일 환경에서는 동작 할 수 있는 최소한의 툴바만 나타납니다. \r\n\t"+
			"모바일 환경에서 툴바를 숨기고 쓰기 영역만을 표시할 때 설정합니다. \r\n\t"+
			"해당 설정은 모바일 환경에서만 적용 됩니다. \r\n\t"+
			"Default : false;"
		],
		TableDefaultWidth: [
			"<span>에디터에서 생성하는 표의 기본 너비 값을 설정</span>", 
			
			"에디터에서 생성하는 표의 기본 너비 값을 설정 \r\n\t단위 : px"
		],
		TableLeftMargin: [
			"<span>Table 태그에 margin-left 값을 기본적으로 설정</span>", 
			
			"Table 태그에 margin-left 값을  기본적으로 설정 \r\n\t단위 : px"
		],
		ShowZeroBorder: [
			"<span>엑셀 등에서 표를 복사/붙여넣기 하는 경우, border 값이 0 인 테두리를 디자인 탭에서 표시할지 여부 설정</span>@"+
			"<span>▶ border 값이 0 인 테두리를 옅은 색으로 표시하여 사용자가 편리하게 편집할 수 있도록 도와주는 기능입니다.</span><br />"+
			"<span style='color: rgb(255, 0, 0);'>▶ 디자인 탭에서만 보여지며, output 데이터 등에는 적용되지 않습니다.</span>", 
			
			"엑셀 등에서 표를 복사해서 붙여 넣을 경우 border 값이 0 인 테두리를 디자인 탭에서 표시 할지 여부를 설정한다. \r\n\t"+
			"border 값이 0 인 테두리를 옅은 색으로 표시하여 사용자가 편리하게 편집할 수 있도록 도와주는 기능 \r\n\t"+
			"디자인 탭에서만 보여지며 output 데이터 등에는 적용되지 않는다."
		],
		IndentSize: [
			"<span>들여쓰기 기능의 사이즈 설정</span>@"+
			"<ul>"+
				"<li><b>type</b> : margin / text<br /><span>- margin / text-indent 속성으로 적용 할 것인지 설정</span></li>"+
				"<li><b>data</b><br/><span>- 기본값 : 40 (단위 px)</span><br /><span>- 설정값은 숫자만 입력 가능</span></li>"+
			"</ul>", 
			
			"들여쓰기 기능의 사이즈를 설정. \r\n\t"+
			"기본값 : 40px \r\n\t"+
			"기본 단위 : px \r\n\t"+
			"설정값은 숫자만 설정 하여야 하며, 단위는 px 로 적용 됩니다. \r\n\t"+
			"type : margin, text \r\n\t"+
			"들여쓰기를 margin 으로 적용 할 것인지 text-indent 로 적용 할 것인지 설정."
		],
		HyperLinkTarget: [
			"<span>링크 삽입 기능을 사용하여 링크를 설정할 때, 기본 target 설정</span>@"+
			"<ul>"+
				"<li><b>값</b> : _blank / _parent / _self / _top</li>"+
			"</ul>", 
			
			"에디터의 링크 삽입 기능을 사용하여 링크를 설정 할때 나타나는 다이어로그에 기본 target 을 설정해줍니다. \r\n\t"+
			"값 : _blank, _parent, _self, _top 를 설정 할 수 있습니다."
		],
		ToolbarIconSize: [
			"<span>툴바의 Icon 사이즈 설정</span>@"+
			"<span>▶ 기본 설정 : false (22px)</span><br />"+
			"<span>▶ 가로, 세로 동일하게 적용</span><br />"+
			"<span>▶ 기본값으로 설정하여 사용하시길 권장합니다.</span><br />"+
			"<span>▶ icon 의 사이즈는 이미지의 사이즈를 줄이는 것이 아닌 img 태그에 사이즈를 설정하는 기능입니다.</span><br />"+
			"<span style='color: rgb(255, 0, 0);'>▶ img 태그의 사이즈를 줄이게 되면 icon 이 깨져 보이거나 흐리게 보일 수 있습니다.</span><br />", 
			
			"툴바의 Icon 사이즈를 설정 \r\n\t"+
			"가로, 세로 동일하게 적용. 단위 : px \r\n\t"+
			"false 일 경우 기본으로 적용. 22px \r\n\t"+
			"notice : icon 의 사이즈는 이미지의 사이즈를 줄이는 것이 아닌 img 태그에 사이즈를 설정하는 기능입니다. \r\n\t"+
			"img 태그의 사이즈를 줄이게 되면 icon 이 깨져보이거나 흐리게 보일 수 있습니다. \r\n\t"+
			"기본 값으로 설정하여 사용하시길 권장 해드립니다."
		],
		SubMenuBar: [
			"<span>Sub Menu Bar 기능 사용 여부 설정</span>@"+
			"<span>▶ 사용자가 텍스트를 Drag 할 경우, 커서 근처에 메뉴바가 나타납니다.</span>", 
			
			"Sub Menu Bar 기능을 사용할지 설정 \r\n\t"+
			"사용자가 텍스트를 Drag 선택 할 경우, 커서 근처에 메뉴바가 나타납니다."
		],
		HtmlSourceRange: [
			"<span>HTML 탭에서 보여지는 Source 의 범위 설정</span>@"+
			"<span>▶ html / body 설정 가능합니다.</span><br /><br />"+
			"<ul>"+
				"<li><b>html </b>: html 태그까지 모두 표시</li>"+
				"<li><b>body </b>: body 내부의 내용만 표시</li>"+
			"</ul>", 
			
			"HTML 탭에서 보여지는 Source 의 범위를 설정 \r\n\t"+
			"html, body 설정 가능. \r\n\t"+
			"html : html 태그까지 모두 표시.body : body 내부의 내용만 표시"
		],
		ApplyTabSpace: [
			"<span>디자인 탭 영역에서 Tab 키를 이용한 띄어쓰기 기능 사용 설정</span>@"+
			"<span>▶ 기본값 : 4 (true 설정 시, 공백 수)</span><br />"+
			"<span>▶ false : 사용자가 Tab 키를 누를 때, 하단 탭의 다음 객체로 포커스 이동</span>", 
			
			"에디터의 디자인 탭 영역에서 Tab 키를 이용한 띄어쓰기 기능 사용을 설정. \r\n\t"+
			"false 일 경우 다음 객체로 포커스 이동. (하단 탭) \r\n\t"+
			"기본값 : 4,  Tab 키 이용 공백 수를 설정."
		],
		MarkupLanguageFormat: [
			"<span>Output MarkupLanguage 포맷 형식인 html, xhtml 로 설정</span>@"+
			"<span>▶ false : html 기본 포맷 적용</span><br />"+
			"<span>▶ 하단 탭 이동, 데이터 호출 등에서 설정한 포맷 값으로 적용됩니다.</span>", 
			
			"Output MarkupLanguage 포맷형식 \r\n\t"+
			"html, xhtml 로 설정 가능 \r\n\t"+
			"apply 값이 false 일 경우 기본 포맷 적용. html 기본 포맷 \r\n\t"+
			"하단 탭 이동, 데이터 호출 등에서 설정 한 포맷 값으로 적용."
		],
		PasteExcelAsImage : [
			"<span>크롬/파이어폭스에서 엑셀 데이터를 복사/붙여넣기 시, 이미지로 붙여 넣을지 HTML 데이터로 붙여 넣을지 메세지가 나타나는 기능 설정</span>@"+
			"<span>▶ false : 메세지가 나타나지 않고 HTML 데이터로 붙여넣기 됨</span><br />"+
			"<span>▶ 기본적으로 메세지가 나타나고 데이터를 선택 가능합니다.</span><br />"+
			"<span style='color: rgb(255, 0, 0);'>▶ XFE 3.0 이상에서만 동작합니다.</span>",
			
			"크롬, 파이어폭스에서 엑셀 데이터를 복사해서 붙여 넣기 할 경우\r\n\t"+
			"이미지로 붙여 넣을지 HTML 데이터로 붙여 넣을지 메세지가 나타나는 기능 설정.\r\n\t"+
			"기본적으로 메세지가 나타나고 데이터를 선택 가능.\r\n\t"+
			"false 로 설정 할 경우 메세지가 나타나지 않고 HTML 데이터로 붙여 넣기 됨\r\n\t"+
			"해당 기능은 3.0 이상에서만 동작함. "
		],
		SourceBreakLine: [
			"<span>에디터의 HTML 작성 영역에서 HTML 소스가 작성 영역의 가로 사이즈를 벗어 날 경우 자동을 줄바꿈이 되도록 처리.</span>@"+
			"<span>▶ false : 줄바꿈이 되지 않고 HTML 작성 영역에 가로 스크롤이 생성 됩니다.</span>",
			
			"에디터의 HTML 작성 영역에서 HTML 소스가 작성 영역의 가로 사이즈를 벗어 날 경우 자동을 줄바꿈이 되도록 처리.\r\n\t"+
			"apply 값이 false 일 경우 줄바꿈이 되지 않고 HTML 작성 영역에 가로 스크롤이 생성 됩니다."
		],
		RemoveSpanWrapper: [
			"<span>span 태그가 p 태그나 div 태그를 감싸고 있으면 해당 위치에서 모음과 자음이 분리되는 브라우저 버그 발생. IE11</span>@"+
			"<span>▶ true : 에디터에 들어오는 데이터를 체크하여 span 태그가 p 태그 또는 div 태그를 감싸고 있는 경우 해당 span 태그를 제거 처리합니다.</span><br />"+
			"<span>▶ span 태그가 block 형태의 태그를 감싸는 것은 웹표준에 맞지 않기 때문에 제거 권장.</span><br />"+
			"<span>▶ span 태그의 스타일이 감싸고 있는 데이터에 모두 영향을 주기 때문에 제거 권장.</span>",
			
			"span 태그가 p 태그나 div 태그를 감싸고 있으면 해당 위치에서 모음과 자음이 분리되는 브라우저 버그 발생. IE11\r\n\t"+
			"span 태그가 block 형태의 태그를 감싸는 것은 웹표준에 맞지 않기 때문에 제거 권장.\r\n\t"+
			"span 태그의 스타일이 감싸고 있는 데이터에 모두 영향을 주기 때문에 제거 권장.\r\n\t"+
			"apply 가 true 일 경우 에디터에 들어오는 데이터를 체크하여 span 태그가 p 태그 또는 div 태그를 감싸고 있는 경우 해당 span 태그를 제거 처리합니다"
		],
		RemoveWhiteSpaceStyle: [
			"<span>td 에 white-space 가 nowrap 로 들어가 있는 경우 표의 너비가 글자 입력에 따라 늘어난다</span>@"+
			"<span>▶ 기본 설정 : false</span><br />"+
			"<span>▶ 해당 동작을 원하지 않을 경우 제거 처리를 해주는 기능을 추가.</span><br />"+
			"<span>▶ 다른 문서에도 영향을 줄 수 있기 때문에 처리 하지 않는 것을 권장하며, 특별한 경우를 위해 설정 추가.</span>",
			
			"td 에 white-space 가 nowrap 로 들어가 있는 경우 표의 너비가 글자 입력에 따라 늘어난다. \r\n\t"+
			"해당 동작을 원하지 않을 경우 제거 처리를 해주는 기능을 추가. \r\n\t"+
			"다른 문서에도 영향을 줄 수 있기 때문에 처리 하지 않는 것을 권장하며, 특별한 경우를 위해 설정 추가."
		],
		AutoSave: [
			"<span>자동 저장 기능 설정</span>@"+
			"<ul>"+
				"<li><b>time </b>:<br /><span>- 자동으로 저장할 시간 설정</span><br /><span>- 최소 저장 가능 시간 : 1분</span><br /><span>- 기본 설정 : 5분</span></li>"+
			"</ul><br />"+
			"<span>▶ 최대 10개의 데이터를 저장하며, 초과 시 제일 처음 저장된 데이터가 삭제되고 새로운 데이터가 추가됩니다.</span><br />"+
			"<span style='color: rgb(255, 0, 0);'>▶ XFE 3.0 이상에서만 동작합니다.</span>", 
			
			"자동 저장 기능 설정. \r\n\t"+
			"자동 저장 기능 제공 버전 : 3.0 이상 \r\n\t"+
			"apply : 자동 저장 기능 사용 여부 설정. \r\n\t"+
			"time : 자동으로 저장할 시간 설정. 분 단위로 설정. \r\n\t"+
			"최소 저장 단위는 1 분이며, 기본 설정은 5 분 \r\n\t"+
			"최대 10개의 데이터를 저장하며, 초과시 제일 처음 저장 된 데이터가 삭제되고 새로운 데이터가 추가 됩니다."
		],
		SizeBar: [
			"<span>에디터의 높이를 조절할 수 있는 기능 사용 설정</span>@"+
			"<span>▶ 기본 설정 : false</span><br />"+
			"<span>▶ 에디터의 하단에 Size Bar 가 생성되며, 높이만 조절 가능합니다.</span><br />"+
			"<span style='color: rgb(255, 0, 0);'>▶ XFE 3.0 이상에서만 동작합니다.</span>", 
			
			"에디터의 높이를 조절할 수 있는 기능을 사용합니다. \r\n\t"+
			"에디터의 하단에 Size Bar 가 생성이 되며, 높이만 조절이 가능합니다. \r\n\t"+
			"해당 기능은 3.0 버전 이상에서만 제공됩니다. \r\n\t"+
			"기본 설정 false"
		],
		ShowRuler: [
			"<span>에디터의 눈금자 기능을 사용합니다.</span>@"+
			"<span>▶ apply : 기능 사용 여부를 설정. true 일 경우 눈금자 기능 사용</span><br />"+
			"<span>▶ state : 기능 사용 시 기본적으로 눈금자를 보이게 할 것인지 설정. on 일 경우 보임. apply 값이 true 일 경우에만 동작함.</span><br />"+
			"<span>▶ 3.0 버전 이상에서만 제공되는 기능.</span><br />"+
			"<span>▶ IE 브라우저의 경우 10 버전 이상이어야 동작함.</span>", 
			
			"에디터의 눈금자 기능을 사용합니다. \r\n\t"+
			"apply : 기능 사용 여부를 설정. true 일 경우 눈금자 기능 사용. \r\n\t"+
			"state : 기능 사용 시 기본적으로 눈금자를 보이게 할 것인지 설정. on 일 경우 보임. apply 값이 true 일 경우에만 동작함. \r\n\t"+
			"3.0 버전 이상에서만 제공되는 기능. \r\n\t"+
			"IE 브라우저의 경우 10 버전 이상이어야 동작함."
		],
		InvalidCheckLevel: [
			"<span>웹표준 Level 설정</span>@"+
			"<span>▶ 0 / 1 / 2 값을 설정할 수 있으며, 값이 높을수록 체크 Level 이 높아집니다.</span><br /><br />"+
			"<ul>"+
				"<li><b>0 (Normal)</b> : 기본값</li>"+
				"<li><b>1 (Row)</b> : 테이블, 이미지 등의 텍스트/캡션 값 등을 체크</li>"+
				"<li><b>2 (High)</b> : Low 의 내용 포함 및 HTML 탭을 사용할 수 없으며, draw table 기능 및 외부 동영상, 플래쉬 기능 제한</li>"+
			"</ul>", 
			
			"웹표준 Level 을 설정. \r\n\t"+
			"0, 1, 2 값을 설정해 줄 수 있으며, 값이 높을 수록 체크 Level 이 높아집니다. \r\n\t"+
			"0 : 기본값, Normal \r\n\t"+
			"1 : 테이블, 이미지 등의 텍스트 값 및 캡션 값 등을 체크. Low \r\n\t"+
			"2 : Low 의 내용 포함 및 HTML 탭을 사용 할 수 없으며, draw table 기능 및 외부 동영상, 플래쉬 기능 제한. High"
		],
		ExceptionTagType: [
			"<span>HTML 값을 가져올 때 설정해놓은 태그들이 제거된 값을 출력할 수 있도록 설정</span><br /><br />"+
			"<span>▶ 하단 탭 이동시에도 제거됩니다.</span><br /><br />"+
			"<span>▶ 제거할 태그의 항목을 추가하거나 삭제할 수 있습니다.</span>", 
			
			"HTML 값을 가져올때 설정해놓은 태그들이 제거된 값을 출력해줌. \r\n\t"+
			"하단 탭 이동시에도 제거됨. \r\n\t"+
			"nodeName :제거할 태그"
		],
		ReplaceExpression: [
			"<span>본문 내용(Text/HTML) 중 특정 문자를 설정된 문자로 치환하는 기능 설정</span><br /><br />"+
			"<span>▶ 탭을 이동하거나 HTML 값을 출력할 때 치환 처리됩니다.</span><br /><br />"+
			"<ul>"+
				"<li><b>findExpression </b>: 찾을 문자</li>"+
				"<li><b>Replace </b>: 치환할 문자</li>"+
			"</ul>", 
			
			"에디터 내의 본문 내용(Text + HTML)중 특정 문자를 설정된 문자로 치환해준다. \r\n\t"+
			"findExpression : 찾을 문자. , Replace : 치환 할 문자. \r\n\t"+
			"탭을 이동하거나 HTML 값을 Output 할 때 치환 처리 됨."
		],
		UploadFilePath: [
			"<span>에디터의 이미지, 플래쉬 등의 파일을 업로드할 때, 처리할 서버파일 및<br />경로 설정</span>", 
			
			"에디터의 이미지, 플래쉬 등의 파일을 업로드 할때 처리 할 서버파일과 경로를 설정합니다."
		],
		UploadPasteContentsPath: [
			"<span>단일 이미지를 붙여 넣을 경우, 처리하는 서버파일 및 경로 설정</span>@"+
			"<span style='color: rgb(255, 0, 0);'>▶ HTML5 기능을 지원하는 브라우저에서만 동작합니다.</span>", 
			
			"단일 이미지를 붙여넣을 경우 처리하는 서버파일과 경로를 설정합니다. \r\n\t"+
			"HTML5 기능을 지원하는 브라우저에서만 동작합니다."
		]
	},
	ad: {
		Priority: [
			"true이면 설정 파일의 옵션 값이 클라이언트의 옵션 값(각 클라이언트 레지스트리에 저장된 값)에 우선. (기본적으로 false) <br/>▶ 현재 이 값은 쓰이지 않으며, 설정 파일에서 초기값을 가져 옵니다. ", 
			""
		],
		Product: ["", ""],
		HelpURL: ["Help URL", "Help URL"],
		Destributor: ["배포자", "배포자"],
		Name: ["제품 명", "제품 명"],
		UI: ["", ""],
		Edit: ["", ""],
		Mime: ["", ""],
		System: ["", ""],
		MarkupLanguage: [
			"Output MarkupLanguage 포맷형식 < html, xml >", 
			""
		]
	},
	xfuConfig: {
		main : [
			"apply 가 false 일 경우 기본 값들이 적용 됩니다.", 
			"apply 가 false 일 경우 기본 값들이 적용 됩니다. "
		],
		selectMode: [
			"<p>업로드/다운로드 기능을 선택합니다. </p>"+
			"<p><ul>"+
				"<li><b>upload </b>: 업로드모드</li>"+
				"<li><b>download </b>: 다운로드모드</li>"+
				"<li><b>hybrid </b>: 하이브리드모드</li>"+
			"</ul></p>", 
			
			"업로드/다운로드 기능을 선택합니다.\r\n\t"+
			"upload : 업로드모드\r\n\t"+
			"download : 다운로드모드\r\n\t"+
			"hybrid : 하이브리드모드"
		],
		listStyle: [
			"<p>업로드 파일목록 화면형식을 지정할 수 있습니다.</p>"+
			"<p><ul>"+
				"<li><b>list </b>: 파일리스트 형식</li>"+
				"<li><b>icon </b>: 아이콘뷰 형식</li>"+
			"</ul></p>", 
			
			"업로드 파일목록 화면형식을 지정할 수 있습니다. \r\n\t"+
			"list : 파일리스트 형식\r\n\t"+
			"icon : 아이콘뷰 형식"
		],
		filePath: [
			"업로드 및 다운로드 받게될 디렉토리 경로를 지정합니다.", 
			"업로드 및 다운로드 받게될 디렉토리 경로를 지정합니다. "
		],
		thumbnail: [
			"<p>업로드 기능 중에 파일목록 리스트에 이미지 파일이 첨부시 미리보게 할지 여부를 지정합니다.</p>"+
			"<p><ul>"+
				"<li><b>true </b>: 썸네일 아이콘에 이미지 보여짐</li>"+
				"<li><b>false </b>: 썸네일 아이콘에 기본 이미지 보여짐</li>"+
			"</ul></p>", 
			
			"업로드 기능 중에 파일목록 리스트에 이미지 파일이 첨부시 미리보게 할지 여부를 지정합니다. "
		],
		maxCount: [
			"첨부파일 최대 개수를 지정합니다 (Number)", 
			"첨부파일 최대 개수를 지정합니다 (Number) "
		],
		singleMaxSize: [
			"첨부파일 건별 최대 용량을 지정합니다 (단위 MB)", 
			"첨부파일 건별 최대 용량을 지정합니다 (단위 MB) "
		],
		totalMaxSize: [
			"첨부파일 건별 최대 누적 용량을 지정합니다 (단위 MB)", 
			"첨부파일 건별 최대 누적 용량을 지정합니다 (단위 MB) "
		],
		bodyHeight: [
			"첨부리스트 높이를 지정합니다. (단위 px)", 
			"첨부리스트 높이를 지정합니다. (단위 px) "
		],
		bodyWidth: [
			"첨부파일 리스트의 너비(width)를 지정합니다.", 
			"첨부파일 리스트의 너비(width)를 지정합니다. "
		],
		dropMsg: [
			"Drag & Drop 영역 중간에 보여지는 메시지를 입력합니다.", 
			"Drag & Drop 영역 중간에 보여지는 메시지를 입력합니다. "
		],
		readyMsg: [
			"Progress Bar 영역 중간에 보여지는 준비 메시지를 입력합니다.", 
			"Progress Bar 영역 중간에 보여지는 준비 메시지를 입력합니다. "
		],
		btnPos: [
			"<p>버튼영역 위치를 지정합니다.</p>"+
			"<p><ul>"+
				"<li><b>up </b>: 버튼위치가 위쪽으로 배치</li>"+
				"<li><b>down </b>: 버튼위치가 아래쪽으로 배치</li>"+
			"</ul></p>", 
			
			"버튼영역 위치를 지정합니다. \r\n\t"+
			"up : 버튼위치가 위쪽으로 배치\r\n\t"+
			"down : 버튼위치가 아래쪽으로 배치"
		],
		bgColor: [
			"테마배경색상을 지정합니다. (타이틀 영역 배경, 하단 디테일 영역 배경)", 
			"테마배경색상을 지정합니다. (타이틀 영역 배경, 하단 디테일 영역 배경) "
		],
		dropMsgColor: [
			"Drag & Drop 영역 중간에 보여지는 메시지의 글자색상을 지정합니다.", 
			"Drag & Drop 영역 중간에 보여지는 메시지의 글자색상을 지정합니다. "
		],
		fontColor: [
			"테마글자색상을 지정합니다 (타이틀 영역 글자색, 하단 디테일 영역 글자색)", 
			"테마글자색상을 지정합니다 (타이틀 영역 글자색, 하단 디테일 영역 글자색) "
		],
		proBarColor: [
			"프로그래스바 배경색을 지정합니다.", 
			"프로그래스바 배경색을 지정합니다."
		],
		lineColor: [
			"컴포넌트 전체 선 색상을 지정합니다.", 
			"컴포넌트 전체 선 색상을 지정합니다."
		],
		highlightColor: [
			"항목에 마우스 오버시 배경색상을 지정합니다.", 
			"항목에 마우스 오버시 배경색상을 지정합니다."
		],
		fontSize: [
			"전체 글자크기를 지정할 수 있습니다.", 
			"전체 글자크기를 지정할 수 있습니다."
		],
		fileExt: [
			"업로드를 허용하는 파일확장자 들을 나열합니다. <br/> 콤마(,)구분으로 설정해야 합니다.", 
			"업로드를 허용하는 파일확장자 들을 나열합니다.\r\n\t콤마(,)구분으로 설정해야 합니다."
		],
		blackListFileExt: [
			"업로드를 허용 못하게 하는 파일확장자 들을 나열합니다. <br/> 콤마(,)구분으로 설정해야 합니다.", 
			"업로드를 허용 못하게 하는 파일확장자 들을 나열합니다.\r\n\t콤마(,)구분으로 설정해야 합니다. "
		],
		serverType: [
			"<p>서버 전송 방식 false 일 경우 jsp. </p>"+
			"<p><ul>"+
				"<li><b>jsp </b>: 서버가 JAVA환경인 경우 세팅</li>"+
				"<li><b>php </b>: 서버가 PHP환경인 경우 세팅</li>"+
				"<li><b>aspx </b>: 서버가 닷넷환경인 경우 세팅</li>"+
			"</ul></p>", 
			
			"서버 전송 방식 false 일 경우 jsp.\r\n\t"+
			"jsp : 서버가 JAVA환경인 경우 세팅\r\n\t"+
			"php : 서버가 PHP환경인 경우 세팅\r\n\t"+
			"aspx : 서버가 닷넷환경인 경우 세팅"
		],
		Language: [
			"<p>기본 언어 설정. false 일 경우 korean. </p>"+
			"<p><ul>"+
				"<li><b>korean </b>: 한국어 세팅</li>"+
				"<li><b>english </b>: 영어 세팅</li>"+
				"<li><b>chinese_s </b>: 중국어(간체) 세팅</li>"+
				"<li><b>chinese_t </b>: 중국어(번체) 세팅</li>"+
				"<li><b>japanese </b>: 일본어 세팅</li>"+
			"</ul></p>", 
			
			"기본 언어 설정. false 일 경우 korean.\r\n\t"+
			"korean : 한국어 세팅\r\n\t"+
			"english : 영어 세팅\r\n\t"+
			"chinese_s : 중국어(간체) 세팅\r\n\t"+
			"chinese_t : 중국어(번체) 세팅\r\n\t"+
			"japanese : 일본어 세팅"
		]
	}
};