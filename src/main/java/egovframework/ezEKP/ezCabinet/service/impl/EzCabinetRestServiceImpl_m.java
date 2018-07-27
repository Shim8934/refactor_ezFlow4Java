package egovframework.ezEKP.ezCabinet.service.impl;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService_m;

@Service
public class EzCabinetRestServiceImpl_m implements EzCabinetRestService_m {
	@Autowired
	private Properties config;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetRestServiceImpl_m.class);
	
	@Override
	public JSONObject saveRelatedApproval(HttpServletRequest request, String userId, String divContent) {
		Map<String, Object> param = new HashMap<String, Object>();
		return null;
	}
	
}

