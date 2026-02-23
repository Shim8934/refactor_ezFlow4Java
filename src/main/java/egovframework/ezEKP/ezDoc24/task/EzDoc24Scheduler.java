package egovframework.ezEKP.ezDoc24.task;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezDoc24.dao.EzDoc24DAO;
import egovframework.ezEKP.ezEmail.task.EzEmailScheduler;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.JsonUtil;

@Component
public class EzDoc24Scheduler {

	private static final Logger logger = LoggerFactory.getLogger(EzDoc24Scheduler.class);

	@Autowired
	private EzApprovalGService ezApprovalGService;
	
	@Autowired
	private EzEmailScheduler ezEmailScheduler;

	@Resource(name="ezDoc24DAO")
	private EzDoc24DAO ezDoc24Dao;
	
	@SuppressWarnings("unchecked")
	@Scheduled(cron = "0 0 5 * * ?")
	public void doc24Scheduler() throws Exception {
		logger.debug("doc24Scheduler started.");
		
		if (!ezEmailScheduler.preScheduler("ezapprovalg_doc24Scheduler")) {
			logger.debug("doc24Scheduler ended.");
			return;
		}

		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			Calendar cal = Calendar.getInstance();
			
			String dateString = sdf.format(cal.getTime()); 
					
			String jsonData = GetRecData(dateString);
			
			if (jsonData == null || jsonData.equals("")) {
				jsonData = GetSampleRecData();
			}
			if (jsonData != null && !"".equals(jsonData.trim())) {
				 Map<String,Object> map = JsonUtil.JsonToMap(jsonData);
		
				 if (((Map<String, Object>)map.get("header")).get("code").toString().equals("LNK000000")) {
					 List<Map<String, Object>> datas = (List<Map<String, Object>>)map.get("result");
					 
					 if(datas != null) {
						 for(int i = 0; i < datas.size(); i++) {
							 boolean InsertFlag = false;
							 Map<String, Object> data = (Map<String, Object>) datas.get(i);
							 InsertFlag = SetRecParameterInfo(data);
							 if(InsertFlag) {
								 logger.debug("수신처 DB 성공  - 수신처 코드 : " + data.get("orgCd") + ", 사업장명 : " + data.get("cmpnyNm"), "");
							 }else {
								 logger.debug("수신처 DB 실패  - 수신처 코드 : " + data.get("orgCd") + ", 사업장명 : " + data.get("cmpnyNm"), "");
							 }
						 }
					 }
					 
				 }else {
					 logger.debug("********************  수신처 데이터 가져오기 작업 실패 ********************"); 
					 logger.debug("err code : " + ((Map<String, Object>) map.get("header")).get("code").toString() + ", message : " + ((Map<String, Object>) map.get("header")).get("message").toString());
					 logger.debug("********************  수신처 데이터 가져오기 작업 실패 ********************"); 
				 }
			}else {
				logger.debug("********************  수신처 데이터 가져오기 작업 실패 ********************");
			}
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("doc24Scheduler ended.");
	}
	protected boolean SetRecParameterInfo(Map<String, Object> data) {
		boolean retCheck = false;
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			String orgCd = data.get("orgCd").toString();
			map.put("orgCd", data.get("orgCd"));
			map.put("cmpnyNm", data.get("cmpnyNm"));
			map.put("senderNm", data.get("senderNm"));
			map.put("bizrno", data.get("bizrno"));
			map.put("adres", data.get("adres"));
			map.put("deleteFlag", data.get("deleteFlag"));
			map.put("updateDe", data.get("updateDe"));
			map.put("deleteDe", data.get("deleteDe"));
			
			String checkId = ezDoc24Dao.checkId(map);
			
			if(orgCd.equals(checkId)) {
				if(ezDoc24Dao.updateDept(map) > 0) {
					retCheck = true;
				}
			}else {
				if(ezDoc24Dao.insertDept(map) == null) {
					retCheck = true;
				}
			}
		}catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return retCheck;
	}

	private String GetRecData(String CurDate) {
		String resultPost = null;
        try {
        	LoginVO userInfo = new LoginVO();
        	userInfo.setTenantId(0);
        	userInfo.setCompanyID("");
        	userInfo.setLang("1");
        	// 타겟이 되는 웹페이지 URL
        	String url = ezApprovalGService.getOptionInfo("D24", "003", userInfo, "CODE");
        	String apiKey = ezApprovalGService.getOptionInfo("D24", "002", userInfo, "CODE");
        	StringBuilder postParams = new StringBuilder();
        	if(url == null || apiKey == null || url.equals("") || apiKey.equals("")) {
        		return null;
        	}

            HttpHeaders headers = new HttpHeaders();
    		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
    		headers.set("ContentType", "application/x-www-form-urlencoded");
    		headers.set("API_KEY", apiKey);
    		
    		MultiValueMap<String, String> map= new LinkedMultiValueMap<String, String>();
    		map.add("batchDay", CurDate);
    		map.add("deleteFlag", "Y");
    		
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

	private String GetSampleRecData() throws IOException {
		File file = new File("C:/Users/NC443/Desktop/업무/문서24 (커스터마이징 내역서 및 사용자 메뉴얼, 소스) (2019-01-16)/NetModule/Source/Tool/ReceptDailyBatch/ReceptDailyBatch/json1.json");
		String result = "";
        if (file.exists()) {
        	InputStreamReader isr = null;
        	BufferedReader br = null;
        	OutputStreamWriter osw = null;
        	
        	try {
	        	isr = new InputStreamReader(new FileInputStream(file));
	        	br = new BufferedReader(isr);
	        	int read = 0;
	        	
				while ((read = br.read()) != -1) {
					result += (char)read;
				}
				
        	} catch(Exception e) {
        		logger.error(e.getMessage(), e);
        	} finally {
        		if (br != null) {
        			br.close();
        		}
        		
        		if (isr != null) {
        			isr.close();
        		}
        		
        		if (osw != null) {
        			osw.close();
        		}
        	}	        	
        }
        return result;
	}

}
