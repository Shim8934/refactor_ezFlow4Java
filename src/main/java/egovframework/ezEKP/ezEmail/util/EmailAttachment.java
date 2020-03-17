package egovframework.ezEKP.ezEmail.util;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class EmailAttachment {
	private String name;
	private String contentType;
	private InputStream inputStream;

	public EmailAttachment(String name, InputStream inputStream) {
		this(name, null, inputStream);
	}

	public EmailAttachment(String name, String contentType, InputStream inputStream) {
		this.name = name;
		this.contentType = contentType;
		this.inputStream = inputStream;
	}

	public String getName() {
		return name;
	}

	public String getContentType() {
		return contentType;
	}

	public InputStream getInputStream() {
		return inputStream;
	}

	public static Builder builder() {
		return new Builder();
	}

	public static class Builder {
		private List<EmailAttachment> attachments = new ArrayList<>();

		private Builder() {}

		public Builder attach(String name, InputStream inputStream) {
			return attach(name, null, inputStream);
		}

		public Builder attach(String name, String contentType, InputStream inputStream) {
			attachments.add(new EmailAttachment(name, contentType, inputStream));

			return this;
		}

		public List<EmailAttachment> get() {
			return attachments;
		}
	}
}
