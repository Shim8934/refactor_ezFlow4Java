package egovframework.ezEKP.openAPI.web;

import egovframework.let.utl.fcc.service.CommonUtil;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class EzOpenAPIController {
    
    private static final Logger logger = LoggerFactory.getLogger(EzOpenAPIController.class);

    @Autowired
    private CommonUtil commonUtil;
    
    @RequestMapping(value = "/rest/openapi/logininfo", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
    public JSONObject loginCookieUserInfo(@RequestBody Map<String, Object> body) throws Exception {
        JSONObject result = new JSONObject();
        JSONObject data = new JSONObject();
        String loginCookie = (String) body.get("loginCookie");
        String status = "ok";
        int code = 0;
        
        try {
            String decryptedLoginCookie = commonUtil.getDecryptedLoginCookie(loginCookie);
            
            String timeZone = decryptedLoginCookie.split("///")[7];
            
            data.put("userId", decryptedLoginCookie.split("///")[1]);
            data.put("locale", decryptedLoginCookie.split("///")[5]);
            data.put("lang", decryptedLoginCookie.split("///")[6]);
            data.put("timeZone", timeZone.split("\\|")[1]);
            data.put("tenantId", decryptedLoginCookie.split("///")[8]);
            data.put("companyId", decryptedLoginCookie.split("///")[10]);
            
        } catch (Exception e) {
            logger.error(e.getMessage());
            status = "error";
            code = 1;
            data.put("message", e.getMessage());
        }
        result.put("status", status);
        result.put("code", code);
        result.put("data", data);
        
        return result;
    }
    
}