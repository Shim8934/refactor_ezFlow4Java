package egovframework.let.utl.fcc.service;

import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.core.Core;
import org.apache.logging.log4j.core.LogEvent;
import org.apache.logging.log4j.core.appender.rewrite.RewritePolicy;
import org.apache.logging.log4j.core.config.plugins.Plugin;
import org.apache.logging.log4j.core.config.plugins.PluginFactory;
import org.apache.logging.log4j.core.impl.Log4jLogEvent;
import org.apache.logging.log4j.message.SimpleMessage;

import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Stream;

@Plugin(name = "SQLRewriter", category = Core.CATEGORY_NAME, elementType = "rewritePolicy", printObject = true)
public class SQLRewriter implements RewritePolicy{
    private final static ConcurrentHashMap<String, String> pstmMap = new ConcurrentHashMap<>();
    private final static ConcurrentHashMap<String, String> paramMap = new ConcurrentHashMap<>();

    @Override
    public LogEvent rewrite(LogEvent event) {
        String message = event.getMessage().getFormattedMessage();

        String pstm = StringUtils.substringBefore(message, "}").trim().replace("{pstm-", "");
        message = StringUtils.substringAfter(message, "}").trim();
        Log4jLogEvent.Builder builder = new Log4jLogEvent.Builder(event);

        if (message.startsWith("Executing Statement: ")) {
            pstmMap.put(pstm, message.replace("Executing Statement: ", "").trim());
            builder.setLevel(Level.OFF);
        } else if (message.startsWith("Parameters: ")) {
            paramMap.put(pstm, message.replace("Parameters: ", "").trim());
            builder.setLevel(Level.OFF);
        } else if (message.startsWith("Types: ")) {
            String sql = pstmMap.remove(pstm);
            String para = paramMap.remove(pstm);
            if (sql != null && para != null) {
                String preStr = "{pstm-" + pstm + "} ";
                try {
                    String query = preStr + "Query: " + createQuery(sql, para, message.replace("Types: ", "").trim());
                    builder.setMessage(new SimpleMessage(query));
                } catch (Exception e) {
                    SimpleMessage message1 = new SimpleMessage(preStr + "Executing Statement: " + sql + "\r\n " +
                            preStr + "Parameters: [" + para + "]\r\n " +
                            preStr + "Types: [" + message + "]");
                    builder.setMessage(message1);
                }
            }
        }

        return builder.build();
    }

    private String createQuery(String sql, String para, String types) {
        para = para.substring(0, para.length() - 1).substring(1);
        types = types.substring(0, types.length() - 1).substring(1);

        if (StringUtils.isBlank(para)) return sql.replaceAll("\\s+", " ");

        Queue<String> qQuery = Stream.of(sql.split("\\?", -1))
                .collect(LinkedList::new, LinkedList::add, LinkedList::addAll);

        Queue<String> qPara = Stream.of(para.split(",", -1))
                .map(str -> str.startsWith(" ") ? str.substring(1) : str)
                .collect(LinkedList::new, LinkedList::add, LinkedList::addAll);

        Queue<String> qTypes = Stream.of(types.split(",", -1))
                .collect(LinkedList::new, LinkedList::add, LinkedList::addAll);

        StringBuilder result = new StringBuilder();

        if (!qPara.isEmpty() && qPara.size() != qTypes.size()) {
            throw new RuntimeException("Parameter count does not match Parameter Type count");
        }

        while(!qPara.isEmpty()) {
            String param = qPara.poll();
            boolean isNum = qTypes.poll().trim().equals("java.lang.Integer");
            result.append(qQuery.poll().replaceAll("\\s+", " ")).append(" ");
            if (isNum) {
                result.append(param);
            } else {
                result.append("'").append(param).append("'");
            }

            result.append(" /**P*/ ");
        }

        result.append(qQuery.poll());
        return result.toString();
    }

    @PluginFactory
    public static SQLRewriter createPolicy() {
        return new SQLRewriter();
    }
}
