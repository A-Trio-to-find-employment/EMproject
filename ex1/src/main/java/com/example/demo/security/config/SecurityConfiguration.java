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
		.requestMatchers("/error/**","/css/**","/upload/**","/WEB-INF/**").permitAll()// /imgs/아래의 모든 요청, /css/아래의 모든 요청 허용
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
		
		
		
		
		
		
		
		
		.requestMatchers("/secondfa").hasRole("MEMBER")
		.requestMatchers("/eventlist").hasRole("MEMBER")
		.requestMatchers("/qna").hasRole("MEMBER")
		.requestMatchers("/myInfo").hasRole("MEMBER")
//		.requestMatchers("/index*").permitAll()
//		.requestMatchers("/imgs/**","/css/**","/upload/**").permitAll()// /imgs/아래의 모든 요청, /css/아래의 모든 요청 허용
//		.requestMatchers("/home/**").permitAll( )//home으로 시작하는 모든 요청 허용
//		.requestMatchers("/board/**").permitAll()
//		.requestMatchers("/notice/**").permitAll()
//		.requestMatchers("/entry/**").permitAll()
//		
//		.requestMatchers("/item/itemList.html").permitAll()
//		.requestMatchers("/item/detail.html").permitAll()
//		.requestMatchers("/item/search.html").permitAll()
//		.requestMatchers("/image/imageList.html").permitAll()
//		.requestMatchers("/image/readImage.html").permitAll()
//		.requestMatchers("/login/**").permitAll()
//		.requestMatchers("/admin/findpage.html").hasRole("ADMIN")
//		.requestMatchers("/admin/deliverymenu.html").hasRole("ADMIN")//배송상태 변경은 관리자 권한만 허용
//		.requestMatchers("/nation/inputNation.html").hasRole("ADMIN")//원산지 등록은 관리자 권한만 허용
//		.requestMatchers("/item/entry.html").hasRole("ADMIN")//상품 등록은 관리자 권한만 허용
//		.requestMatchers("/notice/inputForm.html").hasRole("ADMIN")//공지사항 쓰기는 관리자 권한만 허용
//		.requestMatchers("/notice/formform.html").hasRole("ADMIN")//공지사항 쓰기는 관리자 권한만 허용
//		.requestMatchers("/mypage/index.html").hasRole("MEMBER")//마이페이지는 호원권한만 허용
//		.requestMatchers("/board/write.html").hasRole("MEMBER")//게시글쓰기는 회원권한만 허용
//		.requestMatchers("/cart/show.html").hasRole("MEMBER")//장바구니 보기는 회원권한만 허용
//		.requestMatchers("/image/imageWrite.html").hasRole("MEMBER")//이미지 게시글 쓰기는 회원권한만 허용
		.anyRequest().authenticated();//나머지 요청은 모두 보안 검사를 진행
		
//		http.formLogin();//보안검사에 spring자체 로그인 창 설정
		http.formLogin().loginPage("/login/securityLogin.html") //보안검사에 만든 로그인 창 설정
//		/securityLogin.html"
		.loginProcessingUrl("/securityLogin")
//		.usernameParameter("user_id") 
//        .passwordParameter("password") 
		.defaultSuccessUrl("/index")
		.permitAll();
//		http.formLogin();
		
		http.logout().logoutUrl("/logout")//일반 로그아웃의 매핑은 spring과 동일
		.logoutSuccessUrl("/index").permitAll();
		
		return http.build();
	}
	//계정과 암호 처리
	//1. 계정과 암호를 메모리에서
	//2. 계정과 암호를 스피링 시큐리티의 기본DB테이블에서 불러온다
	//3. 계정과 암호를 개발자가 만든 DB테이블에서 불러온다
	//2.
	@Primary   //3개의 BEAN중 가장 먼저 실행해라
	@Bean
	public AuthenticationManagerBuilder configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
		
		String queryForId = "select user_id, password, enabled from users where user_id=?";
		String queryForAuth = "select u.user_id, a.auth from users u, authorities a "
				+ "where u.user_id = a.user_id and a.user_id=?";
		auth.jdbcAuthentication().dataSource(dataSource)	//테이블을 쓰겠다
		.passwordEncoder(passwordEncoder())
		.usersByUsernameQuery(queryForId)
		.authoritiesByUsernameQuery(queryForAuth);
		return auth;
	}
//	@Bean
//	public AuthenticationManager authenticationManager(HttpSecurity http) throws Exception {
//	    return http.getSharedObject(AuthenticationManagerBuilder.class)
//	        .jdbcAuthentication()
//	        .dataSource(dataSource)
//	        .passwordEncoder(passwordEncoder())
//	        .usersByUsernameQuery("select user_id, password, enabled from users where user_id=?")
//	        .authoritiesByUsernameQuery("select u.user_id, a.auth from users u, authorities a "
//	                + "where u.user_id = a.user_id and a.user_id=?")
//	        .and()
//	        .build();
//	}
	@Bean
	public PasswordEncoder passwordEncoder() {//암호화 
		return new BCryptPasswordEncoder();//BCrypt방식으로 암호와
	}
}