package egovframework.ezEKP.ezEmail.web;

import java.io.IOException;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@ServerEndpoint(value = "/websocket/{getID}")
public class EzEmailWebSocketController {
	
	private static final Logger logger = LoggerFactory.getLogger(EzEmailWebSocketController.class);
		
	// 웹소켓 커넥션은 인스턴스가 싱글톤이 아니기 때문에 힙에 생성되는 1개의 인스턴스 Map을 공유할 수 있도록 Static으로 선언하였다. 
	private static Map<String, Session> sessionMap = new ConcurrentHashMap<>();
	
	/**
	 * 웹소켓 처음 커넥션 맺을 때 호출되는 함수
	 */
    @SuppressWarnings("unchecked")
	@OnOpen
    public void handleOpen(Session session, @PathParam("getID") String getID){
    	logger.debug("[WebSocket] handleOpen started. onOpen called. WebSocket Connected.");
    	
    	// 세션에 연결한 유저ID에 고유문자를 붙여서 메세지전송 대상의 유저를 구별하는 유일한 값을 부여한다.
    	UUID uuid = UUID.randomUUID();
    	String userkey = getID + String.valueOf(uuid);
        
    	// 특정유저의 세션을 Map에 보관한다.
        sessionMap.put(userkey, session);
        session = sessionMap.get(userkey);
        
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("status", "start");
        jsonObj.put("userkey", userkey);
        
        String jsonStr = jsonObj.toJSONString();
        
        try {
        	// 클라이언트 연결을 확인하고 시작을 알린다.(유저의 고유문자를 전송)
        	this.handleMessage(jsonStr, session);
        } catch (RuntimeException e) {
        	logger.debug("[WebSocket] handleOpen error occured.");
        	logger.error(e.getMessage(), e);
        } catch (Exception e) {
        	logger.debug("[WebSocket] handleOpen error occured.");
        	logger.error(e.getMessage(), e);
        }
        
        logger.debug("[Websocket] userKey="+ userkey + ", sessionId=" + session.getId() + ", sessionInfo=" + session.getBasicRemote());
        logger.debug("[Websocket] sessionMap size=" + sessionMap.size() + ", this=" + this);
        logger.debug("[WebSocket] handleOpen ended.");
    }

    /**
     * 웹소켓 클라이언트와 메세지 송수신시 호출되는 함수
     */
	@SuppressWarnings("unchecked")
	@OnMessage
    public void handleMessage(String jsonStr, Session session) throws Exception{
		JSONObject sendObj = new JSONObject();
		JSONObject recObj = new JSONObject();
		JSONParser jsonParser = new JSONParser();
		
		recObj = (JSONObject) jsonParser.parse(jsonStr);
		String userkey = (String) recObj.get("userkey");
		
		if ( recObj.get("status").equals("start")) {
			session = sessionMap.get(userkey);
			sendObj.put("status", "transferStart");
			sendObj.put("userkey", userkey);
			jsonStr = sendObj.toJSONString();
			session.getBasicRemote().sendText(jsonStr);
		} else if (recObj.get("status").equals("progress") || recObj.get("status").equals("end")) {
			session.getBasicRemote().sendText(jsonStr);
		}
    }

    /**
     * 웹소켓 커넥션 종료시 호출 함수
     */
    @OnClose
    public void handleClose(Session session) throws IOException{
    	logger.debug("[WebSocket] handleClose started. onClose called. WebSocket Disconnected." + session.getId());
    	
    	for (String userkey : sessionMap.keySet()) {
    		Session tempSession = sessionMap.get(userkey);
    		if (session == tempSession) {
    			logger.debug("userkey=" + userkey + " session is found" );
    			sessionMap.remove(userkey);
    			break;
    		}
    	}
    	
    	logger.debug("[WebSocket] sessionMap size=" + sessionMap.size());
    	logger.debug("[WebSocket] handleClose ended.");
    }

    /**
     * 웹소켓 커넥션 에러시 호출 함수
     * @param e
     */
    @OnError
    public void handleError(Throwable e){
        logger.error(e.getMessage(), e);
    }    
	
}
