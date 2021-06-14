package egovframework.let.utl.rest.callback;

import java.io.IOException;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.ClientHttpRequest;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

/** Import the inner class of RestTemplate */
public class HttpEntityRequestCallback extends AcceptHeaderRequestCallback {

	private final HttpEntity<?> requestEntity;

	public HttpEntityRequestCallback(RestTemplate restTemplate, Object requestBody) {
		super(restTemplate.getMessageConverters(), null);
		if (requestBody instanceof HttpEntity) {
			this.requestEntity = (HttpEntity<?>) requestBody;
		} else if (requestBody != null) {
			this.requestEntity = new HttpEntity<Object>(requestBody);
		} else {
			this.requestEntity = HttpEntity.EMPTY;
		}
	}

	@Override
	@SuppressWarnings("unchecked")
	public void doWithRequest(ClientHttpRequest httpRequest) throws IOException {
		super.doWithRequest(httpRequest);
		if (!requestEntity.hasBody()) {
			HttpHeaders httpHeaders = httpRequest.getHeaders();
			HttpHeaders requestHeaders = requestEntity.getHeaders();
			if (!requestHeaders.isEmpty()) {
				httpHeaders.putAll(requestHeaders);
			}
			if (httpHeaders.getContentLength() == -1) {
				httpHeaders.setContentLength(0L);
			}
		} else {
			Object requestBody = requestEntity.getBody();
			Class<?> requestType = requestBody.getClass();
			HttpHeaders requestHeaders = requestEntity.getHeaders();
			MediaType requestContentType = requestHeaders.getContentType();
			for (HttpMessageConverter<?> messageConverter : messageConverters) {
				if (messageConverter.canWrite(requestType, requestContentType)) {
					if (!requestHeaders.isEmpty()) {
						httpRequest.getHeaders().putAll(requestHeaders);
					}
					if (logger.isDebugEnabled()) {
						if (requestContentType != null) {
							logger.debug("Writing [" + requestBody + "] as \"" + requestContentType +
									"\" using [" + messageConverter + "]");
						} else {
							logger.debug("Writing [" + requestBody + "] using [" + messageConverter + "]");
						}

					}
					((HttpMessageConverter<Object>) messageConverter).write(
							requestBody, requestContentType, httpRequest);
					return;
				}
			}
			String message = "Could not write request: no suitable HttpMessageConverter found for request type [" +
					requestType.getName() + "]";
			if (requestContentType != null) {
				message += " and content type [" + requestContentType + "]";
			}
			throw new RestClientException(message);
		}
	}

}
