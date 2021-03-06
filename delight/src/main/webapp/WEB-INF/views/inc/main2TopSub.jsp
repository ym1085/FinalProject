<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
	var ctx = "/delight";
	
	$(function(){
		$("form[name=frm123]").submit(function(){
			var email=$("#email").val();
			var cnt=email.search("@");
			var idxo=email.indexOf("@");
			var sub=email.substring(idxo+1);
			
			if($("#name").val().length<1){
				alert("이름을 입력해주세요");
				$("#name").focus();
				event.preventDefault();
			}else if(email.length<1){
				alert("이메일 을 입력해주세요");
				$("#email").focus();
				event.preventDefault();
			}else if(cnt==-1 && email!=''){
				alert("올바르지않는 이메일형식입니다.");
				$("#email").focus();
				event.preventDefault();
			}else if(email!='' && sub==''){
				alert("올바르지않는 이메일형식입니다.");
				$("#email").focus();
				event.preventDefault();
			}else if($("#hp").val().length<1){
				alert("핸드폰 번호 를 입력해주세요");
				$("#hp").focus();
				event.preventDefault();
			}else if($("#title").val().length<1){
				alert("제목을 입력해주세요");
				$("#title").focus();
				event.preventDefault();
			}else if($("#content").val().length<1){
				alert("내용을 입력해주세요");
				$("#content").focus();
				event.preventDefault();
			}else{
				event.preventDefault();
    			$.ajax({
    				type:"post",
    				url:"<c:url value='/inqueryWrite.do'/>",
    				data:$("form[name=frm123]").serializeArray(),
    				success:function(res){
    					if(res=='Y'){
      						$("#title").val("");
    						$("#content").val("");
    						if(!confirm("문의가등록되었습니다.문의내역으로 이동하시겠습니까?")){
    							event.preventDefault();
    						}else{
    							location="<c:url value='/member/myinqueryList.do' />";
    						}  
    					}else if(res=='N'){
    						alert("문의가발송되었습니다.");
     						$("#name").val("");
    						$("#email").val("");
    						$("#hp").val("");
    						$("#title").val("");
    						$("#cotent").val(""); 
    					} 
    				},
    				error:function(xhr, status, error){
    					alert("Error : "+status+", "+ error);
    				}
    			});	
			}
		});
	
		$("#buymembershipButton").click(function(){
			window.open(ctx+"/member/mymemberShip.do","맴버십 구입",
			"width=600,height=500,left=400,top=150,location=yes,resizable=yes");
		}); 
		
	});
</script>
<style type="text/css">
	div.inqinfo1 {
    	font-size: 0.9em;
    	margin-left: 22px;
    	margin-bottom: 11px;
	}
	div.inqinfo1>.inqinfospan {
    	color: red;
    	font-weight: bold;
	}
	button.btn.btn-success.btn-lg {
    width: 120px;
    margin-top: 5px;
	}
	
	button.btn.btn-secondary.btn-lg {
	    width: 120px;
	    margin-top: 5px;
	}
	/* 구매권 구매 버튼 */
	#buymembershipButton{
		background-color: red;
    	border-color: red;
    	margin-top: 4px;
    	width: 85px;
	}
	
	#q2 p{
		color:#FFFFFF!important;
	}
</style>
    <!-- 로그인 안된경우 (시작)-->
			<c:if test="${empty sessionScope.userid }">
				<div id="q1">
					<button type="button" class="btn btn-success btn-lg"
					onClick="location.href='<c:url value="/login/login.do" />'">로그인</button>
					<button type="button" class="btn btn-secondary btn-lg"
					onClick="location.href='<c:url value="/member/nonesecList.do" />'">예매내역</button>
				</div>
				<div id="q2">
					<button type="button" class="btn btn-secondary btn-lg" id="topLogin"
					onClick="location.href='<c:url value="/member/register.do" />'">회원가입</button>
				</div>
			<div id="q3">
			<ul>
				<li>문의하기</li>
			</ul>
			<div style="border: 1px dotted white; width: 100%; margin-top: 11%;"></div>
			</div>
			<div class="inqinfo1">
			<span class="inqinfospan">*문의답변은 이메일로 발송해드립니다<br>(회원일경우 문의내역에서도 확인가능)</span>
			</div>
			<form name="frm123">
				<div class="right_list">
					<input style="color:white;" type="text" id="name" placeholder="이름" name="username"><br>
					<input style="color:white;" type="text" id="email" placeholder="이메일" name="email"><br>
					<input style="color:white;" type="text" id="hp" placeholder="연락처(- 같이입력해주세요)" name="hp"><br>
					<input style="color:white;" type="text" id="title" placeholder="제목" name="inqueryTitle"><br>
					<textarea style="color:white;" rows="20" cols="32" id="content" placeholder="내용" name="inqueryContent"></textarea>
				</div>
				<input type="submit" class="btn btn-secondary btn-lg" value="보내기" id="SideQnA">
			</form>
			</c:if>
			<!-- 로그인 안된경우 (끝)-->
			
			<!-- 로그된경우 (시작)-->
			<c:if test="${!empty sessionScope.userid }">
				<br>
				<div id="q2" style="color: white;">
					<p><span style="font-weight: bold;font-size: 1.4em;color:white">*${memberVo.username }</span> 님 어서오세요.</p><br>
					<p>*마일리지 : <fmt:formatNumber value="${memberVo.mileagePoint }" pattern="#,###" /> 원</p>
					<p>*멤버십 등급 : ${memberVo.gradeName }</p>
					<p>*가입일 : <fmt:formatDate value="${memberVo.joinDate }" pattern="yyyy-MM-dd"/></p>
					
					<c:if test="${empty memberShipMap['NAME'] }">
						<div id="buymembershipParent" style="overflow: hidden; text-align: center; padding-left: 25%;">
							<p id="buymembership1" style="float: left;">*회원권  : </p>
							<button id="buymembershipButton" style="font-size: 12px; color:white; float: left;">회원권 구매</button>
						</div>
					</c:if>
					
					<c:if test="${!empty memberShipMap['NAME'] }">
						<div id="buymembershipParent2">
							<p id="buymembership3">*회원권  : ${memberShipMap['NAME']}</p>
							<p id="buymembership4">
								<%-- <c:set var="stDate" value="${memberShipMap['START_DATE']}"/> --%>
								*기간  : <%-- ${memberShipMap['START_DATE']} --%>
								<fmt:parseDate value="${memberShipMap['START_DATE']}" var='start_date' pattern='yyyy-MM-dd'/>
								<fmt:formatDate value="${start_date}" pattern="yyyy-MM-dd"/>
								~
								<fmt:parseDate value="${memberShipMap['END_DATE']}" var='end_date' pattern='yyyy-MM-dd'/>
								<fmt:formatDate value="${end_date}" pattern="yyyy-MM-dd"/>
							</p>
						</div>
					</c:if>
				</div>
			
				<div id="q1">
					<button type="button" class="btn btn-success btn-lg"
					onClick="location.href='<c:url value="/member/myPage.do" />'">마이페이지</button>
					<button type="button" class="btn btn-success btn-lg"
					onClick="location.href='<c:url value="/member/edit.do" />'">회원정보수정</button>
					<button type="button" class="btn btn-secondary btn-lg"
					onClick="location.href='<c:url value="/login/logout.do" />'">로그아웃</button>
					<button type="button" class="btn btn-secondary btn-lg"
					onClick="location.href='<c:url value="/member/pwdChange.do" />'">비밀번호변경</button>
				</div>
				
			<div id="q3">
			<ul>
				<li style="color:white;">문의하기</li>
			</ul>
			<div style="border: 1px dotted white; width: 100%; margin-top: 11%;"></div>
			</div>
			<div class="inqinfo1">
			<span class="inqinfospan">*문의답변은 이메일로 발송해드립니다<br>(회원일경우 문의내역에서도 확인가능)</span>
			</div>
			<form name="frm123">
				<div class="right_list">
					<input style="color:white;" type="text" id="name" placeholder="이름" name="username" value="${memberVo.username }"><br>
					<input style="color:white;" type="text" id="email" placeholder="이메일" name="email" value="${memberVo.email1 }@${memberVo.email2}"><br>
					<input style="color:white;" type="text" id="hp" placeholder="연락처(- 같이입력해주세요)" name="hp" maxlength="13" value="${memberVo.hp1 }-${memberVo.hp2 }-${memberVo.hp3 }"><br>
					<input style="color:white;" type="text" id="title" placeholder="제목" name="inqueryTitle"><br>
					<textarea style="color:white;" rows="20" cols="32" id="content" placeholder="내용" name="inqueryContent"></textarea>
				</div>
				<input type="submit" class="btn btn-secondary btn-lg" value="보내기" id="SideQnA">
				</form>
			</c:if>
			<!-- 로그된경우 (끝)-->