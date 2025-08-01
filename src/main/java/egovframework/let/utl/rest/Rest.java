package egovframework.let.utl.rest;

import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URLEncoder;
import java.text.MessageFormat;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;
import org.springframework.util.StreamUtils;
import org.springframework.web.client.RequestCallback;
import org.springframework.web.client.ResponseExtractor;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.Gson;

import egovframework.let.utl.rest.callback.HttpEntityRequestCallback;
import org.springframework.web.util.WebUtils;

/** ezFlow 내부의 GW 와의 통신을 쉽게 하기 위한 유틸리티 */
@Component
public class Rest {

	private static final Logger logger = LoggerFactory.getLogger(Rest.class);

	/** GW 컨트롤러를 별도로 사용하는 모듈들이 나열된다. */
	public enum Module {
		ATTITUDE("config.attitudeGwServerURL"),
		CABINET("config.cabinetGwServerURL"),
		JOURNAL("config.journalGWServerURL"),
		LADDER("config.ladderGwServerURL"),
		MEMO("config.memoGwServerURL"),
		PORTAL("config.portalGwServerURL"),
		PMS("config.projectGWServerURL"),
		SURVEY("config.surveyGwServerURL"),
		WEBFOLDER("config.webFolderGwServerURL");

		private final String configKey;

		Module(String configKey) {
			this.configKey = configKey;
		}
	}

	private static final Gson GSON = new Gson();

	private final Properties config;

	private final RestTemplate restTemplate;

	private final String jgwServerUrl;

	@Autowired
	public Rest(Properties config, RestTemplate restTemplate) {
		this.config = config;
		this.restTemplate = restTemplate;
		this.jgwServerUrl = config.getProperty("config.JGwServerURL");
	}

	/** GW 호출을 위한 빌더를 반환한다. */
	public RestBuilder gateway(Module module, HttpServletRequest request) {
		return gateway(module, request.getServerName(), WebUtils.getCookie(request, "loginCookie").getValue());
	}

	/** GW 호출을 위한 빌더를 반환한다. */
	public RestBuilder gateway(Module module, String serverName) {
		return new RestBuilder(config.getProperty(module.configKey))
				.header("Accept", MediaType.APPLICATION_JSON_VALUE)
				.header("x-user-host", serverName);
	}

	public RestBuilder gateway(Module module, String serverName, String loginCookie) {
		return new RestBuilder(config.getProperty(module.configKey))
				.header("Accept", MediaType.APPLICATION_JSON_VALUE)
				.header("x-user-host", serverName)
				.header("x-login-cookie", loginCookie);
	}
	
	public RestBuilder jgw() {
		return new RestBuilder(jgwServerUrl)
				.post().header("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
	}

	public RestBuilder builder() {
		return new RestBuilder("");
	}

	/**
	 * 모바일 게이트웨이 Rest API 호출을 위한 빌더 클래스<br>
	 * 메소드는 기본적으로 GET 이며 Accept 및 x-user-host 헤더가 기본으로 들어간다.<br>
	 * Accept 헤더의 기본값은 application/json 이다.
	 */
	public class RestBuilder {

		@SuppressWarnings("serial")
		private class FormParam extends HashMap<String, Object> {

			@Override
			public String toString() {
				StringBuilder sb = new StringBuilder();
				for (Entry<String, Object> entry : entrySet()) {
					if (entry.getValue() instanceof Iterable) {
						//noinspection rawtypes
						for (Object eachValue : (Iterable) entry.getValue()) {
							if (sb.length() > 0) {
								sb.append('&');
							}
							try {
								sb.append(entry.getKey()).append('=').append(URLEncoder.encode(eachValue.toString(), "UTF-8"));
							} catch (UnsupportedEncodingException e) {
								logger.error(e.getMessage(), e);
							}
						}

						continue;
					}
					if (sb.length() > 0) {
						sb.append('&');
					}
					try {
						sb.append(entry.getKey()).append('=').append(URLEncoder.encode(entry.getValue().toString(), "UTF-8"));
					} catch (UnsupportedEncodingException e) {
						logger.error(e.getMessage(), e);
					}
				}
				return sb.toString();
			}

		}

		private final String prefixUrl;

		private String url;
		private HttpMethod method = HttpMethod.GET;
		private HttpHeaders headers = new HttpHeaders();
		private Map<String, Object[]> queryParams = new HashMap<>();
		private Object body = null;

		private RestBuilder() {
			prefixUrl = "";
		}

		private RestBuilder(String prefixUrl) {
			this.prefixUrl = prefixUrl;
		}

		/** URL을 설정한다. */
		public RestBuilder url(String url) {
			this.url = url;
			return this;
		}

		/**
		 * MessageFormat 형식으로 url을 설정한다.<br>
		 * ex) <code>url("rest/{0}/users/{1}", "ezWebfolder", "gisa1")</code>
		 */
		public RestBuilder url(String pattern, Object... arguments) {
			this.url = MessageFormat.format(pattern, arguments);
			return this;
		}

		/**
		 * GET 메소드로 설정한다.<br>
		 * 기본값이므로 사용하지 않아도 된다.
		 */
		@Deprecated
		public RestBuilder get() {
			method = HttpMethod.GET;
			return this;
		}

		/** POST 메소드로 설정한다. */
		public RestBuilder post() {
			method = HttpMethod.POST;
			return this;
		}

		/** PUT 메소드로 설정한다. */
		public RestBuilder put() {
			method = HttpMethod.PUT;
			return this;
		}

		/** DELETE 메소드로 설정한다. */
		public RestBuilder delete() {
			method = HttpMethod.DELETE;
			return this;
		}

		/**
		 * 헤더를 설정한다.<br>
		 * add가 아니라 set 개념이므로 유의한다.
		 */
		public RestBuilder header(String headerName, String headerValue) {
			headers.set(headerName, headerValue);
			return this;
		}

		/** 쿼리 파라미터를 추가한다. */
		public RestBuilder queryParam(String name, Object... values) {
			queryParams.put(name, values);
			return this;
		}

		/** 쿼리 파라미터를 추가한다. */
		public RestBuilder queryParams(Map<?, ?> map) {
			for (Map.Entry<?, ?> entry : map.entrySet()) {
				queryParams.put(entry.getKey().toString(), new Object[] { entry.getValue() });
			}

			return this;
		}

		/** body에 json 파라미터를 추가한다. */
		@SuppressWarnings("unchecked")
		public RestBuilder jsonParam(String name, Object value) {
			if (body == null) {
				body = new JSONObject();
			}

			if (body instanceof JSONObject) {
				((JSONObject) body).put(name, value);
			} else {
				throw new IllegalStateException("body already exists, not JSONObject");
			}

			return this;
		}

		/** body에 form 파라미터를 추가한다. */
		public RestBuilder formParam(String name, Object value) {
			if (body == null) {
				body = new FormParam();
			}

			if (body instanceof FormParam) {
				((FormParam) body).put(name, value);
			} else {
				throw new IllegalStateException("body already exists, not FormParam");
			}

			return this;
		}

		/**
		 * 기존의 body를 대체한다.<br>
		 * VO, Map, Collecton은 자동으로 json 형식으로 들어간다.
		 */
		public RestBuilder body(Object obj) {
			Assert.notNull(obj, "body must not be null");
			String jsonStr = GSON.toJson(obj);

			try {
				if (jsonStr.startsWith("{")) {
					obj = GSON.fromJson(jsonStr, JSONObject.class);
				} else if (obj instanceof Collection) {
					obj = jsonStr;
				}
			} catch (Exception ex) {logger.error(ex.getMessage(), ex);}

			body = obj;
			return this;
		}

		/** Rest API를 호출하여 결과를 JSONObject 인스턴스로 넘긴다. */
		public JSONObject exchangeBody() throws Exception {
			return (JSONObject) new JSONParser().parse(exchangeBody(String.class));
		}

		/** Rest API를 호출하여 결과를 T 타입의 인스턴스로 넘긴다. */
		public <T> T exchangeBody(Class<T> clazz) throws Exception {
			return exchange(clazz).getBody();
		}

		/** Rest API를 호출하여 결과를 Result 인스턴스로 넘긴다. */
		public Result exchangeResult() throws Exception {
			return exchangeBody(Result.class);
		}

		/** Rest API를 호출하여 결과를 JgwResult 인스턴스로 넘긴다. */
		public JgwResult exchangeJgwResult() throws Exception {
			return exchangeBody(JgwResult.class);
		}

		/**
		 * Rest API를 호출하여 결과를 ResponseEntity 인스턴스로 넘긴다.<br>
		 * 스테이터스 코드나 헤더를 참조해야하는 일이 있을 수 있어 exchangeBody 와 구분지었다.
		 */
		public ResponseEntity<JSONObject> exchange() throws Exception {
			return exchange(JSONObject.class);
		}

		/**
		 * Rest API를 호출하여 결과를 ResponseEntity 인스턴스로 넘긴다.
		 */
		public <T> ResponseEntity<T> exchange(Class<T> clazz) throws Exception {
			if (body instanceof FormParam) {
				body = body.toString();
			}

			HttpEntity<Object> entity = new HttpEntity<>(body, headers);
			return restTemplate.exchange(createUri(), method, entity, clazz);
		}

		/**
		 * Rest API를 호출하여 결과를 response.getOutputStream() 으로 스트리밍 해준다.<br>
		 * 해당 메소드는 파일 첨부 다운로드 API를 스트리밍하여 다운받아주는 상황 등에 사용한다.
		 */
		public void download(HttpServletResponse response) {
			headers.setAccept(Arrays.asList(MediaType.APPLICATION_OCTET_STREAM, MediaType.ALL));
			RequestCallback requestCallback = new HttpEntityRequestCallback(restTemplate, new HttpEntity<>(body, headers));
			ResponseExtractor<Void> responseExtractor = clientResponse -> {
				HttpHeaders clientHeaders = clientResponse.getHeaders();

				if (clientHeaders.containsKey("Content-Disposition")) {
					response.setHeader("Content-Disposition", clientHeaders.get("Content-Disposition").get(0));
				}

				MediaType contentType = clientHeaders.getContentType();

				if (contentType != null) {
					response.setContentType(contentType.toString());
				}

				StreamUtils.copy(clientResponse.getBody(), response.getOutputStream());

				return null;
			};
			restTemplate.execute(createUri(), method, requestCallback, responseExtractor);
		}

		private URI createUri() {
			UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(prefixUrl + url);
			queryParams.entrySet().forEach(entry -> builder.queryParam(entry.getKey(), entry.getValue()));
			return builder.build().encode().toUri();
		}

	}

}
