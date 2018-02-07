<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
<script type="text/javascript" charset="utf8"
	src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.3/jstree.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	$(function() {
		$('#tree-container').jstree();
		$('#jstree_demo_div').on("changed.jstree", function (e, data) {
			  console.log(data.selected);
			});
	})
	$(function () { $('#jstree_demo_div').jstree(); });
	
</script>
</head>
<body>
	<div class="well jstree jstree-2 jstree-default" id="treeview_json" role="tree" aria-multiselectable="true" tabindex="0"
		aria-activedescendant="4" aria-busy="false">
		<ul class="jstree-container-ul jstree-children" role="group">
			<li role="treeitem" aria-selected="true" aria-level="1" aria-labelledby="1_anchor" aria-expanded="true" id="1"
				class="jstree-node  jstree-last jstree-open">
			<i class="jstree-icon jstree-ocl" role="presentation"></i>
			<a class="jstree-anchor jstree-clicked" href="google.com" tabindex="-1" id="1_anchor">
			<i class="jstree-icon jstree-themeicon" role="presentation"></i>
			<font style="vertical-align: inherit;">
			<font style="vertical-align: inherit;">전자 제품</font></font></a>
			<ul role="group" class="jstree-children" style="">
					<li role="treeitem" aria-selected="false" aria-level="2"
						aria-labelledby="2_anchor" aria-expanded="true" id="2"
						class="jstree-node jstree-open"><i class="jstree-icon jstree-ocl" role="presentation"></i><a
						class="jstree-anchor" href="google.com" tabindex="-1" id="2_anchor">
						<i class="jstree-icon jstree-themeicon" role="presentation"></i><font style="vertical-align: inherit;"><font
								style="vertical-align: inherit;">변하기 쉬운</font></font></a>
					<ul role="group" class="jstree-children" style="">
							<li role="treeitem" aria-selected="false" aria-level="3"
								aria-labelledby="7_anchor" id="7"
								class="jstree-node  jstree-leaf"><i
								class="jstree-icon jstree-ocl" role="presentation"></i><a
								class="jstree-anchor" href="google.com" tabindex="-1"
								id="7_anchor"><i class="jstree-icon jstree-themeicon"
									role="presentation"></i><font style="vertical-align: inherit;"><font
										style="vertical-align: inherit;">삼성</font></font></a></li>
							<li role="treeitem" aria-selected="false" aria-level="3"
								aria-labelledby="8_anchor" id="8"
								class="jstree-node  jstree-leaf jstree-last"><i
								class="jstree-icon jstree-ocl" role="presentation"></i><a
								class="jstree-anchor" href="google.com" tabindex="-1"
								id="8_anchor"><i class="jstree-icon jstree-themeicon"
									role="presentation"></i><font style="vertical-align: inherit;"><font
										style="vertical-align: inherit;">사과</font></font></a></li>
						</ul></li>
					<li role="treeitem" aria-selected="false" aria-level="2"
						aria-labelledby="3_anchor" aria-expanded="true" id="3"
						class="jstree-node  jstree-last jstree-open"><i
						class="jstree-icon jstree-ocl" role="presentation"></i><a
						class="jstree-anchor" href="google.com" tabindex="-1"
						id="3_anchor"><i class="jstree-icon jstree-themeicon"
							role="presentation"></i><font style="vertical-align: inherit;"><font
								style="vertical-align: inherit;">휴대용 퍼스널 컴퓨터</font></font></a>
					<ul role="group" class="jstree-children" style="">
							<li role="treeitem" aria-selected="false" aria-level="3"
								aria-labelledby="4_anchor" id="4"
								class="jstree-node  jstree-leaf"><i
								class="jstree-icon jstree-ocl" role="presentation"></i><a
								class="jstree-anchor" href="google.com" tabindex="-1"
								id="4_anchor"><i class="jstree-icon jstree-themeicon"
									role="presentation"></i><font style="vertical-align: inherit;"><font
										style="vertical-align: inherit;">건반</font></font></a></li>
							<li role="treeitem" aria-selected="false" aria-level="3"
								aria-labelledby="5_anchor" aria-expanded="false" id="5"
								class="jstree-node  jstree-closed"><i
								class="jstree-icon jstree-ocl" role="presentation"></i><a
								class="jstree-anchor" href="google.com" tabindex="-1"
								id="5_anchor"><i class="jstree-icon jstree-themeicon"
									role="presentation"></i><font style="vertical-align: inherit;"><font
										style="vertical-align: inherit;">컴퓨터 주변기기</font></font></a></li>
							<li role="treeitem" aria-selected="false" aria-level="3"
								aria-labelledby="11_anchor" id="11"
								class="jstree-node  jstree-leaf jstree-last"><i
								class="jstree-icon jstree-ocl" role="presentation"></i><a
								class="jstree-anchor" href="google.com" tabindex="-1"
								id="11_anchor"><i class="jstree-icon jstree-themeicon"
									role="presentation"></i><font style="vertical-align: inherit;"><font
										style="vertical-align: inherit;">작은 골짜기</font></font></a></li>
						</ul></li>
				</ul></li>
		</ul>
	</div>
	<ul>
		<li>Electronics
			<ul>
				<li>Mobile
					<ul>
						<li>Samsung</li>
						<li>Apple</li>
					</ul>
				</li>
				<li>Laptop
					<ul>
						<li>Dell</li>
						<li>Computer Peripherals
							<ul>
								<li>Printers</li>
								<li>Monitor</li>
							</ul>
						</li>
						<li>Keyboard</li>
					</ul>
				</li>
			</ul>
		</li>
	</ul>
	</div>
</body>
</html>