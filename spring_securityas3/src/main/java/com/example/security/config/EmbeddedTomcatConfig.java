package com.example.security.config;

import org.apache.catalina.connector.Connector;
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class EmbeddedTomcatConfig {

    @Bean
    public WebServerFactoryCustomizer<TomcatServletWebServerFactory> tomcatCustomizer() {
        return factory -> {
            factory.addAdditionalTomcatConnectors(createHttpConnector());  // HTTP 커넥터 추가
        };
    }

    // HTTP 커넥터 생성
    private Connector createHttpConnector() {
        Connector connector = new Connector(TomcatServletWebServerFactory.DEFAULT_PROTOCOL);
        connector.setPort(8081);  // HTTP 포트를 8081로 설정 (충돌 방지)
        connector.setScheme("http");  // HTTP로 설정
        connector.setSecure(false);  // HTTPS가 아님
        connector.setRedirectPort(8443);  // HTTPS 포트로 리디렉션
        return connector;
    }
}
