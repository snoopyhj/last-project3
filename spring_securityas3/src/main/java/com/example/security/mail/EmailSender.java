package com.example.security.mail;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailSender {

    public static void main(String[] args) {
        String to = "jho87190944@gmail.com"; // 받는 사람의 이메일 주소
        String from = "jho8719@naver.com"; // 보내는 사람의 이메일 주소
        String password = "5G3TYJW8JZ34"; // 보내는 사람의 이메일 계정 비밀번호
        String host = "smtp.naver.com"; // Naver 메일 서버 호스트 이름

        // SMTP 프로토콜 설정
        Properties props = new Properties();
        props.setProperty("mail.smtp.host", host);
        props.setProperty("mail.smtp.port", "465");
        props.setProperty("mail.smtp.auth", "true");
        props.setProperty("mail.smtp.ssl.enable", "true"); // SSL 사용 설정

        // 보내는 사람 계정 정보 설정
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            // 메일 내용 작성
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            msg.setSubject("메일 제목");
            msg.setText("메일 내용");

            // 메일 보내기
            Transport.send(msg);
            System.out.println("메일이 성공적으로 발송되었습니다!");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
