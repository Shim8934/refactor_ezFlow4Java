<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>테마/프레임 미리보기</title>
<link rel="stylesheet" href="${util.addVer('ezPortal.i2', 'msg')}" type="text/css" />
<style type="text/css">
.preview img {width:829px; height:600px;}
.preview {text-align:center;}
</style>
</head>
<body class="popup">
<h1>테마/프레임 미리보기</h1>
<p># 테마와 기본 프레임 설정이 적용된 미리보기 화면 입니다.</p>
<div class="preview">
	<img alt="theme${themeId }_frame${frameId}" src="/images/ezNewPortal/themeImg/img_theme${themeId }_frame${frameId}.GIF">
</div>
</body>
</html>