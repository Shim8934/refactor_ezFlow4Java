<?php
header("Content-Type: text/html; charset=utf-8");
try{
	// 원시데이터를 json형태로 가져오기
	$jsonBuffer = urldecode(file_get_contents('php://input'));
	$jsonObj = json_decode($jsonBuffer, true);		
	//print_r($jsonObj);
	
	// DocType 생성
	//$doc = new DomDocument('1.0', 'UTF-8');	 // 미사용
	$implementation = new DOMImplementation();
	$dtd = $implementation->createDocumentType("configuration");	
	$doc = $implementation->createDocument("", "",  $dtd);	
	$doc->encoding = "UTF-8";
	//$doc->standalone = false;
	$doc->preserveWhiteSpace = false;
	$doc->formatOutput = true;
		
	// 최상위 노드네임 생성
	$rootEleName = "edit";
	// X-Free Editor(env.xml)
	if($jsonObj[0]["solution"] == "xfeEnv"){
		$rootEleName = "edit";
	}
	// Active Designer
	else if($jsonObj[0]["solution"] == "ad"){
		
	}
	// X-Free Uploader(config.xml)
	else if($jsonObj[0]["solution"] == "xfuConfig"){
		$rootEleName = "xFreeUploaderConfig";
	}
	// X-Free Uploader(다국어xml)
	else if($jsonObj[0]["solution"] == "xfuLanguage"){
		$rootEleName = "xFreeUploader";
	}
	
	// 루트정보 생성
	$rootEle = $doc->createElement($rootEleName);
	$doc->appendChild($rootEle);
	
	// 자식노드를 생성
	for($i=0; $i<count($jsonObj); $i++){
		$emtpyRow = $doc->createComment("");
		
		// X-Free Editor(env.xml)
		if($jsonObj[0]["solution"] == "xfeEnv"){
			
			// 데이터 유효성 체크 후 세팅
			// 빈값이 넘어오는 경우 ""로 넘기지 못하고 세팅하면 서버오류가 발생하기에 아래와 같이 분기처리가 필요		
			// env.xml의 항목추가시 "apply"키값을 제외한 새로운 attribute 항목이 존재한다면 아래와 같이 변수추가 필요함.			
			$strRemark = isset($jsonObj[$i]["remark"])? $jsonObj[$i]["remark"]:"";
			$strNodename = isset($jsonObj[$i]["nodename"])? $jsonObj[$i]["nodename"]:"";
			$strData = isset($jsonObj[$i]["data"])? $jsonObj[$i]["data"]:"";
			$strApply = isset($jsonObj[$i]["apply"])? $jsonObj[$i]["apply"]:"";
			$strStyle = isset($jsonObj[$i]["style"])? $jsonObj[$i]["style"]:"";
			$strAction = isset($jsonObj[$i]["action"])? $jsonObj[$i]["action"]:"";
			$strWidth = isset($jsonObj[$i]["width"])? $jsonObj[$i]["width"]:"";
			$strHeight = isset($jsonObj[$i]["height"])? $jsonObj[$i]["height"]:"";
			$strColor = isset($jsonObj[$i]["color"])? $jsonObj[$i]["color"]:"";
			$strSize = isset($jsonObj[$i]["size"])? $jsonObj[$i]["size"]:"";
			$strType = isset($jsonObj[$i]["type"])? $jsonObj[$i]["type"]:"";
			$strRepeat = isset($jsonObj[$i]["repeat"])? $jsonObj[$i]["repeat"]:"";
			$strTime = isset($jsonObj[$i]["time"])? $jsonObj[$i]["time"]:"";
			$strLeft = isset($jsonObj[$i]["left"])? $jsonObj[$i]["left"]:"";
			$strAlert = isset($jsonObj[$i]["a_lert"])? $jsonObj[$i]["a_lert"]:"";
			$strState = isset($jsonObj[$i]["state"])? $jsonObj[$i]["state"]:"";
			
			// 아래와 같이 env.xml의 항목의 구성 중에서 통일된 패턴끼리 분기처리 시도함...
			
			// FontFamilyValue / FontSizeValue / LineHeightValue / LetterSpacingValue
			if($strNodename == "FontFamilyValue" || $strNodename == "FontSizeValue" || $strNodename == "LineHeightValue" || $strNodename == "LetterSpacingValue"){
				
				// 주석정보가져오기
				$comment = $doc->createComment($strRemark);
				
				// 데이터가져오기
				$nodename = $doc->createElement($strNodename, $strData);
				
				// attribute가져오기
				$nodename->setAttribute("apply", $strApply);
				$nodename->setAttribute("style", $strStyle);
				$nodename->setAttribute("width", $strWidth);
				
				// xml노드 추가
				$rootEle->appendChild($comment);											// 주석넣기
				$rootEle->appendChild($nodename);											// 데이터 넣기	
			}
			
			// LimitImageSize
			else if($strNodename == "LimitImageSize"){
				
				// 주석정보가져오기
				$comment = $doc->createComment($strRemark);						
				
				// 데이터가져오기				
				$nodename = $doc->createElement($strNodename, $strData);		
				
				// attribute가져오기
				$nodename->setAttribute("apply", $strApply);
				$nodename->setAttribute("width", $strWidth);
				$nodename->setAttribute("height", $strHeight);
				
				// xml노드 추가
				$rootEle->appendChild($comment);											// 주석넣기
				$rootEle->appendChild($nodename);											// 데이터 넣기	
			}
			
			// TableCellParagraph
			else if($strNodename == "TableCellParagraph"){
				
				// 주석정보가져오기
				$comment = $doc->createComment($strRemark);						
				
				// 데이터가져오기				
				$nodename = $doc->createElement($strNodename, "");				
				
				// attribute가져오기
				$nodename->setAttribute("apply", $strApply);
				$nodename->setAttribute("style", $strStyle);
								
				// xml노드 추가
				$rootEle->appendChild($comment);											// 주석넣기
				$rootEle->appendChild($nodename);											// 데이터 넣기	
			}
			
			// SetInitParagraphStyle
			else if($strNodename == "SetInitParagraphStyle"){
				
				// 주석정보가져오기
				$comment = $doc->createComment($strRemark);						
				
				// 데이터가져오기
				$nodename = $doc->createElement($strNodename, "");								
				
				// attribute가져오기
				$nodename->setAttribute("apply", $strApply);
				$nodename->setAttribute("action", $strAction);
				$nodename->setAttribute("style", $strStyle);
								
				// xml노드 추가
				$rootEle->appendChild($comment);											// 주석넣기
				$rootEle->appendChild($nodename);											// 데이터 넣기	
			}
			
			// ShowVerticalLine
			else if($strNodename == "ShowVerticalLine"){
				
				// 주석정보가져오기
				$comment = $doc->createComment($strRemark);						
				
				// 데이터가져오기
				$nodename = $doc->createElement($strNodename, "");								
				
				// attribute가져오기
				$nodename->setAttribute("apply", $strApply);
				$nodename->setAttribute("left", $strLeft);
				$nodename->setAttribute("color", $strColor);
				$nodename->setAttribute("style", $strStyle);
								
				// xml노드 추가
				$rootEle->appendChild($comment);											// 주석넣기
				$rootEle->appendChild($nodename);											// 데이터 넣기	
			}
			
			// ShowGrid
			else if($strNodename == "ShowGrid"){
				
				// 주석정보가져오기
				$comment = $doc->createComment($strRemark);
				
				// 데이터가져오기				
				$nodename = $doc->createElement($strNodename, $strData);		
				
				// attribute가져오기
				$nodename->setAttribute("apply", $strApply);
				$nodename->setAttribute("color", $strColor);
				$nodename->setAttribute("size", $strSize);
				$nodename->setAttribute("type", $strType);
				$nodename->setAttribute("repeat", $strRepeat);
								
				// xml노드 추가
				$rootEle->appendChild($comment);											// 주석넣기
				$rootEle->appendChild($nodename);											// 데이터 넣기	
			}
			
			// IndentSize
			else if($strNodename == "IndentSize"){
				
				// 주석정보가져오기
				$comment = $doc->createComment($strRemark);
				
				// 데이터가져오기
				$nodename = $doc->createElement($strNodename, $strData);	
				
				// attribute가져오기
				$nodename->setAttribute("apply", $strApply);
				$nodename->setAttribute("type", $strType);
				
				// xml노드 추가
				$rootEle->appendChild($comment);											// 주석넣기
				$rootEle->appendChild($nodename);											// 데이터 넣기	
			}
			
			// AutoSave
			else if($strNodename == "AutoSave"){
				
				// 주석정보가져오기
				$comment = $doc->createComment($strRemark);
				
				// 데이터가져오기
				$nodename = $doc->createElement($strNodename, $strData);
				
				// attribute가져오기
				$nodename->setAttribute("apply", $strApply);
				$nodename->setAttribute("time", $strTime);
				
				// xml노드 추가
				$rootEle->appendChild($comment);											// 주석넣기
				$rootEle->appendChild($nodename);											// 데이터 넣기	
			}
			
			// AutoSave
			else if($strNodename == "ShowRuler"){
				
				// 주석정보가져오기
				$comment = $doc->createComment($strRemark);
				
				// 데이터가져오기
				$nodename = $doc->createElement($strNodename, $strData);
				
				// attribute가져오기
				$nodename->setAttribute("apply", $strApply);
				$nodename->setAttribute("state", $strState);
				
				// xml노드 추가
				$rootEle->appendChild($comment);											// 주석넣기
				$rootEle->appendChild($nodename);											// 데이터 넣기	
			}
			
			// ExceptionTagType
			else if($strNodename == "ExceptionTagType"){
				
				// 주석정보가져오기
				$comment = $doc->createComment($strRemark);
				
				// 데이터가져오기
				$nodename = $doc->createElement($strNodename, "");
				
				// attribute가져오기
				$nodename->setAttribute("apply", $strApply);
				
				// xml노드 추가
				$rootEle->appendChild($comment);											// 주석넣기
				$rootEle->appendChild($nodename);											// 데이터 넣기	
				
				// xml하위노드 추가
				$nodeArr = explode(",", $strData);
				for($na=0; $na<count($nodeArr); $na++){
					$nodename2 = $doc->createElement("nodeName", $nodeArr[$na]);
					$nodename->appendChild($nodename2);											// 데이터 넣기	
				}
			}
			
			// ReplaceExpression
			else if($strNodename == "ReplaceExpression"){
				
				//$strObjData = isset($jsonObj[$i]["objData"])? $jsonObj[$i]["objData"]:"";
				
				// 주석정보가져오기
				$comment = $doc->createComment($strRemark);
				
				// 데이터가져오기		
				$nodename = $doc->createElement($strNodename, "");
				
				// attribute가져오기
				$nodename->setAttribute("apply", $strApply);
				$nodename->setAttribute("alert", $strAlert);
				
				// xml노드 추가
				$rootEle->appendChild($comment);											// 주석넣기
				$rootEle->appendChild($nodename);											// 데이터 넣기
				
				// xml하위노드 추가
				$jsonDataObj = $jsonObj[$i]["objData"];
				$arrKeysArr = array_keys($jsonDataObj);
				$arrValuesArr = array_values($jsonDataObj);
				
				for($na=0; $na<count($arrKeysArr); $na++){
					$nodename2 = $doc->createElement("findExpression", $arrKeysArr[$na]);
					$nodename2->setAttribute("Replace", $arrValuesArr[$na]);								// attribute가져오기
					$nodename->appendChild($nodename2);													// 데이터 넣기	
				}					
			}
			
			// 위의 분기문과는 다르게 apply attribute키값과 데이터값 2가지만 존재하는 기본적인 경우에만 자동처리.
			else{
				
				// 주석정보가져오기
				$comment = $doc->createComment($strRemark);						
				
				// 데이터가져오기
				$nodename = $doc->createElement($strNodename, $strData);		
				
				// attribute가져오기
				$nodename->setAttribute("apply", $strApply);								
				
				// xml노드 추가
				$rootEle->appendChild($comment);											// 주석넣기
				$rootEle->appendChild($nodename);											// 데이터 넣기		
			}
			// 아래는 각 노드별로 시각적인 구분을 위해 empty row 추가
			$rootEle->appendChild($emtpyRow);
		}
		// Active Designer
		else if($jsonObj[0]["solution"] == "ad"){
			
		}
		// X-Free Uploader(config.xml)
		else if($jsonObj[0]["solution"] == "xfuConfig"){
			// 데이터 유효성 체크 후 세팅
			$strRemark = isset($jsonObj[$i]["remark"])? $jsonObj[$i]["remark"]:"";
			$strNodename = isset($jsonObj[$i]["nodename"])? $jsonObj[$i]["nodename"]:"";
			$strData = isset($jsonObj[$i]["data"])? $jsonObj[$i]["data"]:"";
			$strApply = isset($jsonObj[$i]["apply"])? $jsonObj[$i]["apply"]:"";
			
			$comment = $doc->createComment($strRemark);						// 주석정보가져오기
			$nodename = $doc->createElement($strNodename, $strData);		// 데이터가져오기
			$nodename->setAttribute("apply", $strApply);								// attribute가져오기			
			
			
			// xml노드 추가			
			$rootEle->appendChild($comment);											// 주석넣기
			$rootEle->appendChild($nodename);											// 데이터 넣기
			$rootEle->appendChild($emtpyRow);
		}
		// X-Free Uploader(다국어xml)
		else if($jsonObj[0]["solution"] == "xfuLanguage"){
			// 데이터 유효성 체크 후 세팅
			$strNodename = isset($jsonObj[$i]["key"])? $jsonObj[$i]["key"]:"";
			$strData = isset($jsonObj[$i]["data"])? $jsonObj[$i]["data"]:"";
			
			$nodename = $doc->createElement($strNodename, $strData);		// 데이터가져오기	
			
			
			// xml노드 추가			
			$rootEle->appendChild($nodename);											// 데이터 넣기			
		}		
	}
	
	// XML형식으로 조합
	$xmlcode = $doc->saveXML();
	$xmlcode = str_replace("<!---->", " ", $xmlcode);
	
	// 결과 출력하기
	echo $xmlcode;
	
	$serverPath = $_SERVER['DOCUMENT_ROOT'];	// 호스트 루트경로
	$savePath = $jsonObj[0]["savePath"];					// 파일저장 하위경로
	
	// 파일저장
	file_put_contents($serverPath.$savePath, $xmlcode);
}catch(Exception $e) {
    echo $e;
}
?>