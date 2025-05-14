package egovframework.ezEKP.ezAI.web;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAI.service.EzAIService;
import egovframework.ezEKP.ezAI.util.AICommonUtil;
import egovframework.ezEKP.ezAI.vo.AIPayloadVO;
import egovframework.ezEKP.ezAI.vo.AICommandRequestVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import com.fasterxml.jackson.core.JsonParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

@RestController
@RequestMapping("/ezAI")
public class EzAIGWController {
    private static final Logger logger = LoggerFactory.getLogger(EzAIGWController.class);

    @Autowired
    private Properties config;

    @Autowired
    private CommonUtil commonUtil;

    @Autowired
    private AICommonUtil aiCommonUtil;

    @Autowired
    private EzAIService ezAIService;
    
    @Autowired
    private EzCommonService ezCommonService;
    
    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;

    @PostMapping("/ai/stream.do")
    @ResponseBody
    public void streamAiResponse(@CookieValue("loginCookie") String loginCookie, @Nullable @RequestBody AICommandRequestVO aiCommandRequestVO, HttpServletResponse response) {
        logger.debug("streamAiResponse started.");

        response.setContentType("text/event-stream;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpURLConnection conn = null;

        try (ServletOutputStream clientOut = response.getOutputStream()) {
            // 사용자 정보, AIRequestVO 빌드
            LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
            
            String lang = userInfo.getLang();
            String timezone = aiCommonUtil.getPersonalTimezone(userInfo.getId(), userInfo.getTenantId());
         
            // frontend에서 받아오는 모든 param AIPayloadVO로 mapping
            AIPayloadVO aiPayloadVO = ezAIService.convertToAPIRequest(aiCommandRequestVO);
           
            // 사용자 정보 locale에 mapping
            Map<String, String> localeMap = new HashMap<>();
            localeMap.put("lang", lang);
            localeMap.put("timezone", timezone);

            aiPayloadVO.setLocale(localeMap);
            
            // AI 서버로 호출
            ObjectMapper objectMapper = createConfiguredMapper();
            URL url = new URL(config.getProperty("config.ezAIUrl") + "/api/command");
            String apiKey = aiCommonUtil.getEzAIApiKey();

            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            //TODO: 2차 개발 때 SSE 형태로 수정시 아래 주석 해제
            //conn.setRequestProperty("Accept", "text/event-stream");
            conn.setRequestProperty("X-API-Key", apiKey); // API 키 추가 "CUdGiuHFLNzNUg5JDxJHn70/E4oyh2H4rN6pxw2PZSw8OGt+QsmpZU6pLrl8XfuMV2ORIA/pPiUw35qY7buvvA=="
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                // aiPayloadVO를 body 키로 감싸기
                Map<String, Object> payloadMap = objectMapper.convertValue(aiPayloadVO, Map.class);
                Map<String, Object> requestWrapper = new HashMap<>();
                requestWrapper.put("body", payloadMap);

                objectMapper.writeValue(os, requestWrapper);
                os.flush();
            }

            int responseCode = conn.getResponseCode();
            logger.debug("AI response code: {}", responseCode);

            if (responseCode != 200) {
                throw new IOException("AI server responded with code: " + responseCode);
            }

            // testdev : 1차 push 개발코드
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            String inputLine;
            StringBuilder content = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }

            // 응답 처리 (여기서는 예시로 출력만 함)
            logger.debug("Response: " + content.toString());
            
            //TODO: 2차 개발 때 SSE 형태로 수정시 아래 주석 해제
            /*try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
                 PrintWriter writer = new PrintWriter(new OutputStreamWriter(clientOut, StandardCharsets.UTF_8), true)) {

                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.isEmpty()) {
                        writer.println();
                    } else {
                        writer.println("data: " + line);
                    }
                    writer.flush(); // 줄마다 강제 전송
                }

            }*/
        } catch (Exception e) {
            logger.error("AI stream error", e);

            //TODO: 2차 개발 때 SSE 적용 시 아래 코드로 진행
            /*if (!response.isCommitted()) {
                try {
                    // 클라이언트에게 SSE 에러 이벤트 전송
                    ServletOutputStream clientOut = response.getOutputStream();
                    PrintWriter writer = new PrintWriter(new OutputStreamWriter(clientOut, StandardCharsets.UTF_8), true);
                    writer.println("event: error");
                    writer.println("data: " + e.getMessage());
                    writer.println();
                    writer.flush();
                } catch (IOException ioException) {
                    logger.error("Error writing SSE error event", ioException);
                }
            }*/
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    private ObjectMapper createConfiguredMapper() {
        ObjectMapper objectMapper = new ObjectMapper();
        // 대소문자 구분 없이 매핑 (JSON 필드와 Java 필드 이름 일치시)
        objectMapper.configure(MapperFeature.ACCEPT_CASE_INSENSITIVE_PROPERTIES, true);
        // 알 수 없는 속성 무시
        objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        // 제어 문자 허용
        objectMapper.configure(JsonParser.Feature.ALLOW_UNQUOTED_CONTROL_CHARS, true);
        return objectMapper;
    }
}
