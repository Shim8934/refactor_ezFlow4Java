package egovframework.let.utl.rest.callback;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.client.ClientHttpRequest;
import org.springframework.http.converter.GenericHttpMessageConverter;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.web.client.RequestCallback;

/** Import the inner class of RestTemplate */
public class AcceptHeaderRequestCallback implements RequestCallback {

	protected final Logger logger = LoggerFactory.getLogger(getClass());
	protected final List<HttpMessageConverter<?>> messageConverters;
	protected final Type responseType;

	protected AcceptHeaderRequestCallback(List<HttpMessageConverter<?>> messageConverters, Type responseType) {
		this.messageConverters = messageConverters;
		this.responseType = responseType;
	}

	@Override
	public void doWithRequest(ClientHttpRequest request) throws IOException {
		if (responseType != null) {
			Class<?> responseClass = null;

			if (responseType instanceof Class) {
				responseClass = (Class<?>) responseType;
			}

			List<MediaType> allSupportedMediaTypes = new ArrayList<MediaType>();
			for (HttpMessageConverter<?> converter : messageConverters) {
				if (responseClass != null) {
					if (converter.canRead(responseClass, null)) {
						allSupportedMediaTypes.addAll(getSupportedMediaTypes(converter));
					}
				} else if (converter instanceof GenericHttpMessageConverter) {
					GenericHttpMessageConverter<?> genericConverter = (GenericHttpMessageConverter<?>) converter;

					if (genericConverter.canRead(responseType, null, null)) {
						allSupportedMediaTypes.addAll(getSupportedMediaTypes(converter));
					}
				}

			}
			if (!allSupportedMediaTypes.isEmpty()) {
				MediaType.sortBySpecificity(allSupportedMediaTypes);
				if (logger.isDebugEnabled()) {
					logger.debug("Setting request Accept header to {}", allSupportedMediaTypes);
				}
				request.getHeaders().setAccept(allSupportedMediaTypes);
			}
		}
	}

	private List<MediaType> getSupportedMediaTypes(HttpMessageConverter<?> messageConverter) {
		List<MediaType> supportedMediaTypes = messageConverter.getSupportedMediaTypes();
		List<MediaType> result = new ArrayList<MediaType>(supportedMediaTypes.size());

		for (MediaType supportedMediaType : supportedMediaTypes) {
			if (supportedMediaType.getCharset() != null) {
				supportedMediaType = new MediaType(supportedMediaType.getType(), supportedMediaType.getSubtype());
			}

			result.add(supportedMediaType);
		}

		return result;
	}

}
