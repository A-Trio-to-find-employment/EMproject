<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>    
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지 2차 인증</title>
	<link rel="stylesheet" type="text/css" href="/css/style.css">	
	
<style>
		.sidebar { float: left; width: 20%; border: 1px solid #ddd; box-sizing: border-box; padding: 20px; text-align: left; }
        .sidebar h3 { border-bottom: 1px solid #ccc; padding-bottom: 10px; }
        .sidebar ul { list-style: none; padding: 0; }
        .sidebar li { margin: 10px 0; }
        .container { margin-left: 25%; padding: 20px; }
        .secondfa { margin-top: 50px; }
        .secondfa input { display: block; margin: 10px auto; padding: 10px; width: 300px; }
        .secondfa button { padding: 10px 20px; margin-top: 20px; cursor: pointer; }
		
			/* 책 아이콘 버튼 스타일 */
	.book-icon-button {
	    background-color: white; /* 버튼 배경색을 하얀색으로 설정 */
	    color: #FF6F61; /* 텍스트 색상 주황색 */
	    border: none; /* 테두리 제거 */
	    border-radius: 50%; /* 원형 모양 */
	    padding: 30px; /* 크기를 키움 */
	    font-size: 32px; /* 책 아이콘 크기 키움 */
	    font-weight: bold;
	    cursor: pointer;
	    position: fixed;
	    bottom: 30px;
	    right: 30px;
	    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3); /* 그림자 추가 */
	    transition: all 0.3s ease-in-out;
	    z-index: 9999;
	    animation: pulse 1.5s infinite; /* 버튼에 애니메이션 효과 */
	    display: flex;
	    justify-content: center;
	    align-items: center;
	}
	
	/* 책 아이콘 버튼 hover 상태 */
	.book-icon-button:hover {
	    transform: scale(1.2); /* 마우스 hover 시 버튼 크기 증가 */
	    box-shadow: 0 15px 30px rgba(0, 0, 0, 0.4); /* 버튼 그림자 더 강조 */
	    background-color: #FF6F61; /* hover 시 버튼 배경색을 주황색으로 변경 */
	    color: white; /* hover 시 텍스트 색을 하얀색으로 변경 */
	    animation: none; /* hover 시 애니메이션 비활성화 */
	}
	
	/* 책 아이콘 버튼 포커스 시 스타일 */
	.book-icon-button:focus {
	    outline: none;
	    box-shadow: 0 0 20px 5px rgba(255, 255, 255, 0.7);
	}
	
	/* 책 이미지 카드 스타일 */
	.recent-viewed-item {
	    display: inline-block;
	    margin: 10px;
	    padding: 15px;
	    background-color: #f0f0f0;
	    border-radius: 10px;
	    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
	    text-align: center;
	    transition: all 0.3s ease;
	    width: 180px;  /* 일정한 카드 크기 */
	    height: 240px; /* 일정한 카드 높이 */
	    position: relative; /* X 버튼을 카드 내에 위치시키기 위한 설정 */
	}
	
	/* X 버튼 스타일 */
	.recent-viewed-item .remove-btn {
	    position: absolute;
	    top: 10px;
	    right: 10px;
	    background-color: #FF6F61;
	    color: white;
	    border: none;
	    border-radius: 50%;
	    width: 25px;
	    height: 25px;
	    font-size: 16px;
	    font-weight: bold;
	    cursor: pointer;
	    transition: all 0.3s ease;
	}
	
	.recent-viewed-item .remove-btn:hover {
	    background-color: #FF3D2A;
	}
	
	/* 책 이미지 스타일 */
	.recent-viewed-item img {
	    border-radius: 10px;
	    width: 100%;
	    height: 180px; /* 이미지의 높이를 일정하게 설정 */
	    object-fit: cover; /* 이미지를 일정 비율로 맞추기 위해 cover 사용 */
	    transition: all 0.3s ease;
	}
	
	/* 모달 스타일 */
	.modal {
	    display: none;
	    position: fixed;
	    z-index: 1;
	    right: 0; /* 오른쪽으로 위치 */
	    top: 0;
	    width: 40%; /* 모달 너비 */
	    height: 100%;
	     background-color: rgba(255, 255, 255, 0);  /* 배경을 투명하게 설정 */
	    overflow: auto;
	    transition: all 0.3s ease;
	}
	
	/* 모달 내용 박스 스타일 */
	.modal-content {
	    background-color: #fff;
	    margin: 15% auto;
	    padding: 30px;
	    border-radius: 10px;
	    width: 90%; /* 모달 내용 너비 */
	    max-width: 400px;
	    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
	    animation: fadeIn 0.5s ease-in-out;
	}
	
	/* 모달 닫기 버튼 스타일 */
	.close-btn {
	    color: #333;
	    font-size: 30px;
	    font-weight: bold;
	    position: absolute;
	    top: 10px;
	    right: 20px;
	    cursor: pointer;
	    transition: all 0.2s ease;
	}
	
	.close-btn:hover {
	    color: #FF6F61;
	}
	
	/* 모달 애니메이션 */
	@keyframes fadeIn {
	    0% {
	        opacity: 0;
	        transform: translateY(-50px);
	    }
	    100% {
	        opacity: 1;
	        transform: translateY(0);
	    }
	}
	
	@keyframes pulse {
	    0% {
	        transform: scale(1);
	        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
	    }
	    50% {
	        transform: scale(1.1);
	        box-shadow: 0 15px 30px rgba(0, 0, 0, 0.4);
	    }
	    100% {
	        transform: scale(1);
	        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
	    }
	}
</style>
</head>
<body>
    <div class="sidebar">
        <ul>            
           <li><a href="#" onclick="requireSecondFactor(event)">주문내역/배송조회</a></li>
            <li><a href="#" onclick="requireSecondFactor(event)">쿠폰조회</a></li>
            <li><a href="#" onclick="requireSecondFactor(event)">리뷰 관리</a></li>
            <li><a href="#" onclick="requireSecondFactor(event)">회원 정보</a></li>
            <li><a href="#" onclick="requireSecondFactor(event)">선호도 조사</a></li>
            <li><a href="#" onclick="requireSecondFactor(event)">선호도 조사 결과</a></li>
            <li><a href="#" onclick="requireSecondFactor(event)">장바구니</a></li>
            <li><a href="#" onclick="requireSecondFactor(event)">찜 목록</a></li>
        </ul>
        <p><strong><a href="#" onclick="requireSecondFactor(event)">나의 1:1 문의내역</a></strong></p>
    </div>

	 <div class="container">
	        
	        <h2>마이페이지에 들어가려면 2차 인증을 해주시기 바랍니다.</h2>
	        <div class="secondfa">
				<form action="/secondfa" method="post">
					<label for="username">아이디 </label>
			        <input type="text" id="username" name="username" required><br>
			
			        <label for="password">비밀번호 </label>
			        <input type="password" id="password" name="password" required><br>
					<table>
						<td align="center"><input type="submit" value="확 인"/></td>
						<td align="center"><input type="reset" value="취 소"/></td>
					</table>
				</tr>
			</table>
		</form>
      	</div>
    </div>
    <script>
        function toggleDropdown() {
            var dropdown = document.getElementById("categoryDropdown");
            dropdown.style.display = (dropdown.style.display === "block") ? "none" : "block";
        }

        // 다른 곳 클릭하면 드롭다운 닫힘
        document.addEventListener("click", function(event) {
            var dropdown = document.getElementById("categoryDropdown");
            var categoryLink = document.querySelector(".nav div a");

            if (!dropdown.contains(event.target) && event.target !== categoryLink) {
                dropdown.style.display = "none";
            }
        });
        function requireSecondFactor(event) {
            // 로그인된 상태에서 2차 인증이 완료되지 않았다면
            var isAuthenticated = ${sessionScope.loginUser != null};
            if (isAuthenticated) {
                var secondFactor = confirm("2차 인증이 필요합니다. 인증을 완료한 후 계속 진행할 수 있습니다.");
                if (!secondFactor) {
                    event.preventDefault(); // 인증을 하지 않으면 링크 이동을 막음
                }
            } else {
                alert("로그인 후 이용할 수 있습니다.");
            }
        }
    </script>
        <script type="text/javascript">
 // 팝업 모달 열기
    function openModal() {
        document.getElementById("recentBooksModal").style.display = "block";
    }

    // 팝업 모달 닫기
    function closeModal() {
        document.getElementById("recentBooksModal").style.display = "none";
    }

    // 페이지 외부 클릭 시 팝업 닫기 (모달 외부 클릭 시 닫히도록)
    window.onclick = function(event) {
        var modal = document.getElementById("recentBooksModal");
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
    </script>
    
</body>
</html>