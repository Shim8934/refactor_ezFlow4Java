package egovframework.ezEKP.ezDoc24.service.impl;

import java.util.List;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezDoc24.dao.EzDoc24DAO;
import egovframework.ezEKP.ezDoc24.service.EzDoc24Service;
import egovframework.ezEKP.ezDoc24.vo.EzDoc24VO;
import egovframework.let.user.login.vo.LoginVO;

@Service("EzDoc24Service")
public class EzDoc24ServiceImpl extends EgovFileMngUtil implements EzDoc24Service {
	private static final Logger logger = LoggerFactory.getLogger(EzDoc24ServiceImpl.class);

	@Autowired
	private EzDoc24DAO ezDoc24Dao;

	@Autowired
	private EzCommonService commonService;

	@Autowired
	private EzApprovalGService ezApprovalGService;
	
	@Override
	public String getDoc24List() throws Exception {
		logger.debug("getDoc24List started");
		List<EzDoc24VO> doc24List = ezDoc24Dao.getDoc24List();
		StringBuilder sb = new StringBuilder("<TREEVIEWDATA><NODE><VALUE>문서24</VALUE><ISLEAF>FALSE</ISLEAF>");
		sb.append("<SETNODEICONBYNAME>DOC24</SETNODEICONBYNAME><EXPANDED>TRUE</EXPANDED><NODES>");
		if(doc24List != null) {
			for(int i = 0; i < doc24List.size(); i++) {
				sb.append("<NODE>");
				sb.append("<VALUE>" + doc24List.get(i).getCmpnynm() + "</VALUE>");
				sb.append("<CN>" + doc24List.get(i).getOrgcd() + "</CN>");
				sb.append("<DATA1>" + doc24List.get(i).getOrgcd() + "</DATA1>");
				sb.append("<DATA2>doc24=" + doc24List.get(i).getCmpnynm() + "</DATA2>");
				sb.append("<SETNODEICONBYNAME>DOC24</SETNODEICONBYNAME>");
				sb.append("<DISPLAYNAME>" + doc24List.get(i).getCmpnynm() + "</DISPLAYNAME>");
				sb.append("<DISPLAYNAME1>" + doc24List.get(i).getCmpnynm() + "</DISPLAYNAME1>");
				sb.append("<DISPLAYNAME2>" + doc24List.get(i).getCmpnynm() + "</DISPLAYNAME2>");
				sb.append("<sendernm>" + doc24List.get(i).getSendernm() + "</sendernm>");
				sb.append("<adres>" + doc24List.get(i).getAdres() + "</adres>");
				sb.append("<bizrno>" + doc24List.get(i).getBizrno() + "</bizrno>");
				sb.append("<ISLEAF>TRUE</ISLEAF>");
				if(!"N".equals(doc24List.get(i).getDeleteflag())) {
					sb.append("<DATA3>N</DATA3>");
					sb.append("<SETTEXTCOLORBYNAME>N</SETTEXTCOLORBYNAME>");
				}else {
					sb.append("<DATA3>Y</DATA3>");
					
				}
//				sb.append("<orgcd>" + doc24List.get(i).getOrgcd() + "</orgcd>");
//				sb.append("<cmpnynm>" + doc24List.get(i).getCmpnynm() + "</cmpnynm>");
//				sb.append("<sendernm>" + doc24List.get(i).getSendernm() + "</sendernm>");
//				sb.append("<adres>" + doc24List.get(i).getAdres() + "</adres>");
//				sb.append("<bizrno>" + doc24List.get(i).getBizrno() + "</bizrno>");
//				sb.append("<deleteflag>" + doc24List.get(i).getDeleteflag() + "</deleteflag>");
				sb.append("</NODE>");
			}
		}
		sb.append("</NODES></NODE></TREEVIEWDATA>");
		logger.debug("getDoc24List ended");
		return sb.toString();
	}

	@Override
	public String getDoc24Detail(String orgcn) throws Exception {
		
		String resultPost = null;
        try
        {
        	LoginVO userInfo = new LoginVO();
        	userInfo.setTenantId(0);
        	userInfo.setCompanyID("");
        	userInfo.setLang("1");
        	// 타겟이 되는 웹페이지 URL
        	String url = ezApprovalGService.getOptionInfo("D24", "001", userInfo, "CODE");
        	String apiKey = ezApprovalGService.getOptionInfo("D24", "002", userInfo, "CODE");
        	
        	if(apiKey == null || url == null || apiKey.equals("") || url.equals("")) {
        		return null;
        	}

            HttpHeaders headers = new HttpHeaders();
    		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
    		headers.set("ContentType", "application/x-www-form-urlencoded");
    		headers.set("API_KEY", apiKey);

    		MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
    		map.add("orgCd", orgcn);
    		
    		HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map, headers);
    		
    		RestTemplate rest = new RestTemplate();
    		
    		ResponseEntity<JSONObject> result = rest.postForEntity(url, entity, JSONObject.class);
    		
    		JSONObject resultBody = result.getBody();
    		
    		resultPost = resultBody.toString();

        }
        catch (Exception e)
        {
            logger.error(e.getMessage(), e);
        }

        return resultPost;
	}

}
