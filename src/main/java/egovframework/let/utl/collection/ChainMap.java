package egovframework.let.utl.collection;

import java.util.HashMap;

@SuppressWarnings("serial")
public class ChainMap<K, V> extends HashMap<K, V> {

	private ChainMap() {}

	public static ChainMap<String, Object> of(String key, Object value) {
		return new ChainMap<String, Object>().add(key, value);
	}

	public static <K, V> ChainMap<K, V> of(K key, V value) {
		return new ChainMap<K, V>().add(key, value);
	}

	public ChainMap<K, V> add(K key, V value) {
		put(key, value);
		return this;
	}

}
