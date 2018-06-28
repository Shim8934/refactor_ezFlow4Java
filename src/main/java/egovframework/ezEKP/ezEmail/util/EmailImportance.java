package egovframework.ezEKP.ezEmail.util;

/**
 * <strong>메일 중요도</strong>
 * 
 * @author jwseo99
 * @since 2018.03.02
 * @see RFC-822 문서의 확장판 RFC-2156 문서에 정의된<br>
 *      Impotance 헤더 필드의 값을 열거.<br>
 * <br>
 *      low (5) / normal (3) / high (1)
 *
 * */
public enum EmailImportance {
	LOW("5"), NORMAL("3"), HIGH("1");

	private String priority;

	private EmailImportance(String priority) {
		this.priority = priority;
	}

	/**
	 * @return Importance 헤더 값을 반환 (RFC-2156 준수)<br>
	 * <br>
	 *         LOW = <strong>"low"</strong><br>
	 *         NORMAL = <strong>"normal"</strong><br>
	 *         HIGH = <strong>"high"</strong>
	 * */
	public String getMappingValue() {
		return this.toString().toLowerCase();
	}

	/**
	 * @return X-Priority 헤더 값을 반환 (jmocha 메일에서의 중요도)<br>
	 * <br>
	 *         LOW = <strong>"5"</strong><br>
	 *         NORMAL = <strong>"3"</strong><br>
	 *         HIGH = <strong>"1"</strong>
	 * */
	public String getPriority() {
		return priority;
	}
}
