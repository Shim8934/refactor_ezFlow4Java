package egovframework.ezEKP.ezDoc24.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezDoc24.service.EzDoc24Service;
import egovframework.let.utl.fcc.service.JsonUtil;

@Controller
public class EzDoc24Controller {
	private static final Logger logger = LoggerFactory.getLogger(EzDoc24Controller.class);

	@Autowired
	private EzDoc24Service ezDoc24Service;	
	/**
	 * 문서24 List 조회 함수
	 */
	@RequestMapping(value = "/ezApprovalG/ezDoc24/getDoc24List.do", method = RequestMethod.GET, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getDoc24List() throws Exception{
		logger.debug("getDoc24List Started.");

		String strXML = ezDoc24Service.getDoc24List();

		logger.debug("getDoc24List Ended.");
		return strXML;
	}

	/**
	 * 문서24 상세정보 조회 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezApprovalG/ezDoc24/getDoc24Detail.do", method = RequestMethod.GET, produces = "text/xml;charset=utf-8")
	public String getDoc24Detail(String orgcn, Model model) throws Exception{
		logger.debug("getDoc24Detail Started.");
        String jsonData = ezDoc24Service.getDoc24Detail(orgcn);
        if(jsonData == null || jsonData.equals("")) {
        	jsonData = "{\"header\": {\"code\": \"LNK000000\",\"message\": \"성공\"},\"result\": [\"cmpnyNm\": \"문서24테스트_법인2\",    \"zip\": \"03171\",    \"senderNm\": \"문서24테스트_법인1\",    \"detailAdres\": \"문서24\",    \"adres\": \"서울특별시 종로구 세종대로 209 (세종로)\",    \"fxnum\": \"02-0000-0000\",    \"telnum\": \"02-6006-5024\",    \"jurirno\": \"\",    \"bizrno\": \"000-00-00000\",    \"orgCd\": \"M999999\"  ]}";            
        }
        if (jsonData != null && !"".equals(jsonData.trim())) {
        	Map<String,Object> map = JsonUtil.JsonToMap(jsonData);
        	if (((Map<String, Object>)map.get("header")).get("code").toString().equals("LNK000000")) {
        		 List<Map<String, String>> dataTmp = (List<Map<String, String>>)map.get("result");
        		 Map<String, String> data = dataTmp.get(0);
				 
				 if(data != null) {
					model.addAttribute("cmpnyNm"	 ,data.get("cmpnyNm")    );      
					model.addAttribute("zip"         ,data.get("zip")        );
					model.addAttribute("senderNm"    ,data.get("senderNm")   );
					model.addAttribute("detailAdres" ,data.get("detailAdres"));
					model.addAttribute("adres"       ,data.get("adres")      );
					model.addAttribute("fxnum"       ,data.get("fxnum")      );
					model.addAttribute("telnum"      ,data.get("telnum")     );
					model.addAttribute("jurirno"     ,data.get("jurirno")    );
					model.addAttribute("bizrno"      ,data.get("bizrno")     );
					model.addAttribute("orgCd"       ,data.get("orgCd")      );
				 }
			 
   			 } else {
   				 logger.debug("********************  수신처 상세정보 가져오기 작업 실패 ********************");
   				 logger.debug("err code : " + ((Map<String, Object>) map.get("header")).get("code").toString() + ", message : " + ((Map<String, Object>) map.get("header")).get("message").toString());
				 logger.debug("********************  수신처 상세정보 가져오기 작업 실패 ********************"); 
   			 }
   		}else {
   			logger.debug("********************  수신처 상세정보 가져오기 작업 실패 ********************");
   		}
		logger.debug("getDoc24Detail Ended.");
		return "ezDoc24/ezDoc24Detail";
	}
	
}
