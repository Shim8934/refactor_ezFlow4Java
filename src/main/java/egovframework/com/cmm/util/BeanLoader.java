package egovframework.com.cmm.util;
import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.ServletContextAware;

@Component
public class BeanLoader implements ServletContextAware {
	@Autowired
	private BeanLogic beanLogic;

	private ServletContext servletContext;

	@Override
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;

	}

	@PostConstruct
	public void init() {
		servletContext.setAttribute("util", beanLogic);
	}
}
