package cn.sunnada.util.maputil;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;


public class NewMap<K, V> extends HashMap<K, V> {
	
	
	/*
	 * 根据value返回key
	 */
	public Object getKeyByValue(Object value) {
		
		Set set = this.entrySet(); //通过entrySet()方法把map中的每个键值对变成对应成Set集合中的一个对象
	    Iterator<Map.Entry<Object, Object>> iterator = set.iterator();
	    Object key = null;
	    while(iterator.hasNext()){
	        //Map.Entry是一种类型，指向map中的一个键值对组成的对象
	        Map.Entry<Object, Object> entry = iterator.next();
	        if(entry.getValue().equals(value)){
	            key = entry.getKey();
	        }
	    }
	    return key;
	}

}
