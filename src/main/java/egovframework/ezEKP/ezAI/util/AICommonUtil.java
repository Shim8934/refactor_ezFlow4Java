package egovframework.ezEKP.ezAI.util;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Properties;
import java.util.Scanner;
import java.util.stream.StreamSupport;

@Component
public class AICommonUtil {
    private static final Logger logger = LoggerFactory.getLogger(AICommonUtil.class);

    @Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
    
    @Autowired
    private Properties config;

    /**
     * AI 사용 여부 조회
     */
    public boolean checkUseAI(int tenantId) throws Exception {
        return "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useAI", tenantId));
    }

    public String getAIAttachSize(int tenantId) throws Exception {
        return ezCommonService.getTenantConfig("aiAttachMBSize", tenantId);
    }

    /**
     * ezAI 자체 apiKey (LLM/SLM의 key와 다른 것임)
     * ezEKP - ezAI 서버와의 통신에서 필요함
     * 2025-05-21 사용 안하고 config에 저장하기로 함
     * @return apiKey
     * @throws Exception
     */
    public String getEzAIApiKey() throws Exception {
        logger.debug("getEzAIApiKey started.");
        
        URL url = new URL(config.getProperty("config.ezAIUrl") + "/api/apikey");
        String targetName = "ezFlow";// config

        // HTTP 연결 설정 및 요청
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        connection.setRequestProperty("X-API-Key", "THE_MASTER_KEY");

        // 응답 상태 확인
        if (connection.getResponseCode() != 200) {
            throw new IOException("API 호출 실패: " + connection.getResponseCode());
        }

        // 응답 읽기
        String response;
        try (Scanner scanner = new Scanner(connection.getInputStream()).useDelimiter("\\A")) {
            response = scanner.hasNext() ? scanner.next() : "";
        }

        // JSON 처리 및 API 키 추출
        JSONArray keys = new JSONArray(response);
        return StreamSupport.stream(keys.spliterator(), false)
                .map(obj -> (JSONObject) obj)
                .filter(obj -> targetName.equals(obj.getString("name")))
                .map(obj -> obj.getString("key"))
                .findFirst()
                .orElseThrow(() -> new IOException("API 키를 찾을 수 없습니다."));
    }

    public String getPersonalTimezone(String userId, int tenantId) throws Exception {
        logger.debug("getPersonalTimezone started. userId={}", userId);
        
        String personalTimezone = "";
        //TODO: TBL_USERLOCALINFO에 유효한 timezone 값 세팅 필요, 2차 시에 진행하기로 함
        personalTimezone = "Asia/Seoul";
        
        return personalTimezone;
    }

    public String getLangFromNum(String langNum) throws Exception {
        if (langNum == null || langNum.trim().isEmpty()) {
            return "ko";
        }

        switch (langNum) {
            case "1": return "ko";
            case "2": return "en";
            case "3": return "ja";
            case "4": return "zh";
            default: return "ko";
        }
    }
}
