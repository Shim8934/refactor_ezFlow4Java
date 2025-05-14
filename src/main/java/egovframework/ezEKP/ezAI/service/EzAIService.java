package egovframework.ezEKP.ezAI.service;

import egovframework.ezEKP.ezAI.vo.AIPayloadVO;
import egovframework.ezEKP.ezAI.vo.AICommandRequestVO;

public interface EzAIService {
    AIPayloadVO convertToAPIRequest(AICommandRequestVO request);
}
