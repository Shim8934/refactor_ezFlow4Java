package egovframework.ezEKP.ezTeams.web;

import egovframework.ezEKP.ezTeams.service.EzTeamsService;
import egovframework.ezEKP.ezOrgan.web.EzOrganController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMethod;
import java.util.HashMap;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;

@Controller
public class EzTeamsController {
    
    private static final Logger logger = LoggerFactory.getLogger(EzOrganController.class);

    @Resource(name = "EzTeamsService")
    private EzTeamsService ezTeamsService;
    
    @RequestMapping("/ezTeams/getPresenceList.do")
    @ResponseBody
    public void getPresenceList (HttpServletRequest request, HttpServletResponse response) throws Exception {
        logger.debug("getPresenceList started");

        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        String requestXml = sb.toString();
        String resultXml = ezTeamsService.getPresenceList(requestXml);

        response.setContentType("text/xml; charset=UTF-8");
        response.getWriter().write(resultXml);
        logger.debug("getPresenceList ended");
    }

    @RequestMapping(value = "/ezTeams/refreshAuthTokens.do", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, String> refreshAuthTokens (HttpServletRequest request) throws Exception {
        logger.debug("refreshAuthToken started");
        Map<String, String> tokenMap = new HashMap<>();
        try {
            String publicAppToken = ezTeamsService.getToken("publicapp");
            String delegatedToken = ezTeamsService.getToken("delegated");

            tokenMap.put("publicAppToken", publicAppToken);
            tokenMap.put("delegatedToken", delegatedToken);

        } catch (Exception e) {
            logger.error("Token refresh failed", e);
        }
        logger.debug("refreshAuthToken ended.");
        return tokenMap;
    }
    
}
