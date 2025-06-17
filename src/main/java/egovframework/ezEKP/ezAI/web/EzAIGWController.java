package egovframework.ezEKP.ezAI.web;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAI.service.EzAIService;
import egovframework.ezEKP.ezAI.util.AICommonUtil;
import egovframework.ezEKP.ezAI.vo.AIPayloadVO;
import egovframework.ezEKP.ezAI.vo.AICommandVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import com.fasterxml.jackson.core.JsonParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Nullable;
import javax.annotation.Resource;
import javax.net.ssl.HttpsURLConnection;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

@Controller
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
    public void streamAiResponse(@CookieValue("loginCookie") String loginCookie, @Nullable @RequestBody AICommandVO aiCommandVO, HttpServletResponse response) {
        logger.debug("streamAiResponse started.");
        
        //  1차 개발: JSON 형태 응답 반환
        response.setContentType("application/json;charset=UTF-8");
        //TODO: 2차 개발 때 SSE 형태로 수정시 아래 주석 해제
        //response.setContentType("text/event-stream;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpsURLConnection conn = null;

        try (ServletOutputStream clientOut = response.getOutputStream()) {
            // 사용자 정보, AIRequestVO 빌드
            LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
            
            String lang = aiCommonUtil.getLangFromNum(userInfo.getLang());
            String timezone = aiCommonUtil.getPersonalTimezone(userInfo.getId(), userInfo.getTenantId());
         
            // frontend에서 받아오는 모든 param AIPayloadVO로 mapping
            AIPayloadVO aiPayloadVO = ezAIService.convertToAPIRequest(aiCommandVO);
           
            // 사용자 정보 locale에 mapping
            Map<String, String> localeMap = new HashMap<>();
            localeMap.put("lang", lang);
            localeMap.put("timezone", timezone);

            aiPayloadVO.setLocale(localeMap);
            
            // AI 서버로 호출
            ObjectMapper objectMapper = createConfiguredMapper();
            URL url = new URL(config.getProperty("config.ezAIUrl") + "/api/command");
            String apiKey = config.getProperty("config.apiKey");

            conn = (HttpsURLConnection) url.openConnection();
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
            
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
                 PrintWriter writer = new PrintWriter(new OutputStreamWriter(clientOut, StandardCharsets.UTF_8), true)) {
                
                // 1차 개발: JSON 형태 응답 반환
                String inputLine;
                StringBuilder content = new StringBuilder();
    
                while ((inputLine = reader.readLine()) != null) {
                    content.append(inputLine);
                }
                
                logger.debug("Response: " + content.toString());
                
                // 응답 처리
                clientOut.write(content.toString().getBytes(StandardCharsets.UTF_8));
                clientOut.flush(); // 클라이언트로 전송
                // 1차 개발: JSON 형태 응답 반환 끝

                //TODO: 2차 개발 때 SSE 형태로 수정시 아래 주석 해제
                /*
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.isEmpty()) {
                        writer.println();
                    } else {
                        writer.println("data: " + line);
                    }
                    writer.flush(); // 줄마다 강제 전송
                }
                 */
            }
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

    /**
     *  본 코드는 모듈 내 iframe으로 slide창을 띄우기 위해 작성, 필요여부 검토 중으로 현재 1차 개발에서는 사용하지 않음
     */
    @GetMapping("/aiSlide.do")
    public String getAISlide(@CookieValue("loginCookie") String loginCookie, Model model) {
        // 사용자 정보
        LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);

        try {
            // AI 첨부파일 이름 최대 길이 - 기존 메일과 동일한 값 사용
            String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
            // AI 사용여부 확인
            boolean useAI = aiCommonUtil.checkUseAI(userInfo.getTenantId());
            // AI 챗봇 첨부파일 최대용량
            String aiAttachMBSize = ezCommonService.getTenantConfig("aiAttachMBSize", -99); // 모든 테넌트 공통 값

            model.addAttribute("useAI", useAI);
            model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
            model.addAttribute("aiAttachMBSize", aiAttachMBSize);

        } catch (Exception e) {
            logger.error("AI 슬라이드 설정 로딩 중 오류 발생", e);
            // 에러 처리 로직 추가
            model.addAttribute("useAI", false); // 기본값 설정
            model.addAttribute("errorMessage", "AI 설정을 불러오는 중 오류가 발생했습니다.");
        }

        return "ezAI/aiSlide";
    }
}
