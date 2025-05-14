package egovframework.ezEKP.ezAI.service;

import egovframework.ezEKP.ezAI.vo.AIPayloadVO;
import egovframework.ezEKP.ezAI.vo.AICommandVO;

public interface EzAIService {
    AIPayloadVO convertToAPIRequest(AICommandVO request);
}
