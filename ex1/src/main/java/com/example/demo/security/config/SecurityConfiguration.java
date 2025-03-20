package com.example.demo.security.config;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
@Configuration
@EnableWebSecurity
public class SecurityConfiguration {
	@Autowired
	DataSource dataSource;
	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{
		//'/a/*->a의 모든 권한  '/a/**->a밑의 모든 권한
		http.csrf().disable().authorizeHttpRequests()
		// /imgs/아래의 모든 요청, /css/아래의 모든 요청 허용
		.requestMatchers("/error/**","/css/**","/upload/**","/WEB-INF/**").permitAll()
		.requestMatchers("/").permitAll()
		.requestMatchers("/index/**").permitAll()
		.requestMatchers("/signup").permitAll()
		.requestMatchers("/signupResult").permitAll()
		.requestMatchers("/idcheck").permitAll()
		.requestMatchers("/field.html").permitAll()
		.requestMatchers("/booklist.html").permitAll()
		.requestMatchers("/bookdetail.html").permitAll()
		.requestMatchers("/goDetailSearch").permitAll()
		.requestMatchers("/detailSearch").permitAll()
		.requestMatchers("/goIsbnSearch").permitAll()
		.requestMatchers("/searchByTitleCat").permitAll()
		.requestMatchers("/eventlist").permitAll()
		.requestMatchers("/eventdetail").permitAll()
		.requestMatchers("/qna").permitAll()
		.requestMatchers("/getcoupon").permitAll()
		
		.requestMatchers("/secondfa").authenticated()
//		.requestMatchers("/secondfa").hasRole("MEMBER")
		
		.requestMatchers("/myInfo").hasRole("MEMBER")
		.requestMatchers("/qnawrite").hasRole("MEMBER")
		.requestMatchers("/qnawriteform").hasRole("MEMBER")
		.requestMatchers("/qnaDelete").hasRole("MEMBER")
		.requestMatchers("/qnadetail").hasRole("MEMBER")	
		.requestMatchers("/myCoupon").hasRole("MEMBER")
		.requestMatchers("/order/**").hasRole("MEMBER")
		.requestMatchers("/gogenretest").hasRole("MEMBER")
		.requestMatchers("/showprefresult").hasRole("MEMBER")
		.requestMatchers("/cart").hasRole("MEMBER")
		.requestMatchers("/jjimlist").hasRole("MEMBER")
		
		.requestMatchers("/preftest").hasRole("MEMBER")
		.requestMatchers("/savepreference").hasRole("MEMBER")
		.requestMatchers("/myPrefBookList").hasRole("MEMBER")
		.requestMatchers("/goNewPrefTest").hasRole("MEMBER")
		.requestMatchers("/removeJjim").hasRole("MEMBER")
		.requestMatchers("/mypage/modify").hasRole("MEMBER")
		.requestMatchers("/qnalist").hasRole("MEMBER")
		.requestMatchers("/qnawrite").hasRole("MEMBER")
		.anyRequest().authenticated();//나머지 요청은 모두 보안 검사를 진행
		
		http.formLogin().loginPage("/login/securityLogin.html") //보안검사에 만든 로그인 창 설정
		.loginProcessingUrl("/securityLogin")
		.defaultSuccessUrl("/index")
		.permitAll();
//		http.formLogin().loginPage("/secondfa")
//		.loginProcessingUrl("/secondfa")
//		.defaultSuccessUrl("/secondfaSuccess",true)
//		.permitAll();
		http.logout().logoutUrl("/logout")//일반 로그아웃의 매핑은 spring과 동일
		.logoutSuccessUrl("/index").permitAll();
		return http.build();
	}
	@Primary
	@Bean
	public AuthenticationManagerBuilder configureGlobal(AuthenticationManagerBuilder auth) throws Exception {		
		String queryForId = "select user_id, password, enabled from users where user_id=?";
		String queryForAuth = "select u.user_id, a.auth from users u, authorities a "
				+ "where u.user_id = a.user_id and a.user_id=?";
		auth.jdbcAuthentication().dataSource(dataSource)
		.passwordEncoder(passwordEncoder())
		.usersByUsernameQuery(queryForId)
		.authoritiesByUsernameQuery(queryForAuth);
		return auth;
	}
	@Bean
	public PasswordEncoder passwordEncoder() {//암호화 
		return new BCryptPasswordEncoder();//BCrypt방식으로 암호와
	}
}