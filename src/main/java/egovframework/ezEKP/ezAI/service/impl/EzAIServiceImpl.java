package egovframework.ezEKP.ezAI.service.impl;

import egovframework.ezEKP.ezAI.service.EzAIService;
import egovframework.ezEKP.ezAI.vo.AIPayloadVO;
import egovframework.ezEKP.ezAI.vo.AICommandRequestVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@Service
public class EzAIServiceImpl implements EzAIService {
    private static final Logger logger = LoggerFactory.getLogger(EzAIServiceImpl.class);

    @Override
    public AIPayloadVO convertToAPIRequest(AICommandRequestVO requestVO) {
        logger.debug("Converting AICommandRequestVO to AIPayloadVO: {}", requestVO);

        if (requestVO == null) {
            logger.error("AICommandRequestVO is null");
            throw new IllegalArgumentException("Request is null");
        }

        AIPayloadVO payloadVO = new AIPayloadVO();

        // 서비스 및 기능 설정
        payloadVO.setService(requestVO.getService());
        payloadVO.setFunction(requestVO.getFunction());

        // input_data 처리 (List<Map<String, Object>>에서 List<Object>로 변환)
        if (requestVO.getInput_data() != null) {
            List<Object> inputDataList = new ArrayList<>();
 
            for (Map<String, Object> item : requestVO.getInput_data()) {
                inputDataList.add(item);
            }

            payloadVO.setInput_data(inputDataList);
        }

        // options 처리 - 직접 JSON의 최상위 옵션을 사용
        if (requestVO.getOptions() != null && !requestVO.getOptions().isEmpty()) {
            payloadVO.setOptions(new HashMap<>(requestVO.getOptions()));
            logger.debug("Set options from requestVO.options: {}", requestVO.getOptions());
        }
        // 옵션이 없거나 비어있으면 command로부터 생성
        else if (requestVO.getCommand() != null) {
            Map<String, String> options = new HashMap<>();
            options.put("command", requestVO.getCommand());
            payloadVO.setOptions(options);
            logger.debug("Created options from command: {}", options);
        }

        logger.debug("Converted AIPayloadVO: {}", payloadVO);
        return payloadVO;
    }
}
