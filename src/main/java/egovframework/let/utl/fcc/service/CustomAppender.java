package egovframework.let.utl.fcc.service;

import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import org.apache.logging.log4j.core.Appender;
import org.apache.logging.log4j.core.Core;
import org.apache.logging.log4j.core.Filter;
import org.apache.logging.log4j.core.Layout;
import org.apache.logging.log4j.core.LogEvent;
import org.apache.logging.log4j.core.appender.AbstractAppender;
import org.apache.logging.log4j.core.config.plugins.Plugin;
import org.apache.logging.log4j.core.config.plugins.PluginAttribute;
import org.apache.logging.log4j.core.config.plugins.PluginElement;
import org.apache.logging.log4j.core.config.plugins.PluginFactory;
import org.apache.logging.log4j.core.layout.PatternLayout;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Arrays;

@Plugin(name = "CustomAppender", category = Core.CATEGORY_NAME, elementType = Appender.ELEMENT_TYPE, printObject = true)
public class CustomAppender extends AbstractAppender {
    private static final Logger logger = LoggerFactory.getLogger(CustomAppender.class);
    private EzEmailUtil ezEmailUtil; // Added line.

    protected CustomAppender(String name, Filter filter,
                             Layout<? extends Serializable> layout, final boolean ignoreExceptions) { // Modified method signature to include EzEmailUtil.
        super(name, filter, layout, ignoreExceptions);
    }

    @Override
    public void append(LogEvent event) {
        LocalDateTime now = LocalDateTime.now();
        String threadName = event.getThreadName();
        String source = event.getSource() != null ? event.getSource().toString() : "";
        String message = event.getMessage().getFormattedMessage();
        StringBuilder sb = new StringBuilder();
        if (event.getThrown() != null) {
            Arrays.stream(event.getThrown().getStackTrace()).forEach(stackTraceElement -> sb.append(stackTraceElement.toString()).append("\r\n"));
        }
        String stackTrace = sb.toString();

        doAction(now, threadName, source, message, stackTrace);
    }

    @PluginFactory
    public static CustomAppender createAppender(
            @PluginAttribute("name") String name,
            @PluginElement("Layout") Layout<? extends Serializable> layout,
            @PluginElement("Filter") final Filter filter,
            @PluginAttribute("otherAttribute") String otherAttribute) {
        if (name == null) {
            LOGGER.error("No name provided for MyCustomAppenderImpl");
            return null;
        }
        if (layout == null) {
            layout = PatternLayout.createDefaultLayout();
        }
        return new CustomAppender(name, filter, layout, true);
    }

    // 실제로 로그에 따라 할 동작.
    private void doAction(LocalDateTime now, String threadName, String source, String message, String stackTrace) {
    }
}