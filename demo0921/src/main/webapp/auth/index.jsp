<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.example.demo.vo.MemberVO" %>
<% 
	int s_cnt = 0;
	if(session.getAttribute("s_cnt")!=null){
		s_cnt = (Integer)session.getAttribute("s_cnt");		
	}
	String smem_id = (String)session.getAttribute("smem_id");
	String smem_name = (String)session.getAttribute("smem_name");
	out.print(smem_id+", "+smem_name);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>인증처리 - 쿠키와 세션</title>
<%@ include file="../common/easyui_common.jsp"%>
<style type="text/css">
		a {
	  		text-decoration: none;
	  		color: green;
		}
</style>
<script type="text/javascript">
	let gm_no;
	let to_id; // 받는 사람 아이디 - 사용자가 입력하는 것이 아니라 쪽지쓰기 row에서 자동으로 담기
	let to_name; // 받는 사람 이름
// 함수 선언은 head태그 안에서 한다
// common-easyui_common.jsp

		function memberUpdate(){
			//alert("수정");
		}

		function login(){
			const mem_id = $("#mem_id").val();
			const mem_pw = $("#mem_pw").val();
			location.href="/member/login?mem_id="+mem_id+"&mem_pw="+mem_pw;
		}
		
		function logout(){
			location.href="./logout.jsp";
		}
		
		function recieveMemoList(){
			$("#dg_receiveMemoList").datagrid({
			method:"get"
			,url:"/memo/receiveMemoList?to_id=<%=smem_id%>"
			,onSelect: function(index, row){
				gm_no = row.NO;
			}
		});
		$("#d_member").hide();
		$("#d_memberInsert").hide();
		$("#d_receiveMemoList").show();
		$("#d_sendMemoList").hide();
		}
		
		function sendMemoList(){
			$("#dg_sendMemoList").datagrid({
				method:"get"
				,url:"/memo/sendMemoList?from_id=<%=smem_id%>"
				,onSelect: function(index, row){
					gm_no = row.NO;
				}
			});
			$("#d_member").hide();
			$("#d_memberInsert").hide();
			$("#d_receiveMemoList").hide();
			$("#d_sendMemoList").show();
		}
		
		// 순서지향적인, 절차지향적인 코딩 -> 모듈화 -> 비동기처럼 처리하기(연습 - await, async)
		function memberList(){
			//alert('회원목록 호출 성공');
			//alert($("#_easyui_textbox_input4").val());
			let type = null;
			let keyword = null;
			if($("#_easyui_textbox_input4").val()!=null && $("#_easyui_textbox_input4").val().length>0){
				type = "mem_id";
				keyword = $("#_easyui_textbox_input4").val();
			}
			else if($("#_easyui_textbox_input5").val()!=null && $("#_easyui_textbox_input5").val().length>0){
				type = "mem_name";
				keyword = $("#_easyui_textbox_input5").val();
			}
			// before
			// 아래 코드는 클라이언트 측에 같이 다운로드가 완료된 상태에서 처리가 된다 - 결정이 되었다.
			// jeasyUI datagrid에서도 get방식과 post방식 지원 - 차이점
			// url속성에 XXX.jsp가 오면 표준 서블릿인 HttpServlt이 관여하는 것이고
			// XXX.pj로 요청하면 ActionSupport가 관여하는 것이다.

			//setTimeout(function(){ 
				$("#dg_member").datagrid({
					// 오라클 서버에서 요청한 결과를 myBatis를 사용하면 자동으로 컬럼명이 대문자
					// 단 List<XXVO>형태라면 그땐 소문자가 맞다.
				method:"get"
				,url:"/member/jsonMemberList?type="+type+"&keyword="+keyword // 응답페이지는 JSON포맷의 파일이어야함(html이 아니라)
				,onSelect: function(index, row){
					to_id = row.MEM_ID; // data grid 선택시 해당 row의 id 담기
					to_name = row.MEM_NAME; // data grid 선택시 해당 row의 이름 담기
					console.log(to_id+" , "+to_name);
				}
				,onDblClickCell: function(index,field,value){
						//console.log(index+", "+field+", "+value);
						if("BUTTON" == field){
							alert("쪽지쓰기");
						}
					}
				});
			//}, 100);
			$("#d_member").show();
			$("#d_memberInsert").hide();
			$("#d_receiveMemoList").hide();
			$("#d_sendMemoList").hide();
		}
		function memberInsert(){
			alert('회원등록 호출 성공');
			$("#d_member").hide();
			$("#d_memberInsert").show();
		}
		function memoForm(){
			console.log("memoForm 호출");
			$("#dlg_memo").dialog({
				title: "쪽지 쓰기",
				href:"/memo/memoForm.jsp?to_id="+to_id+"&to_name="+to_name,
				modal: true,
				closed: true
			});
			$("#dlg_memo").dialog('open');
		}
		function memberDelete(){
			alert('회원삭제 호출 성공');
		}
		function memoSend(){
			console.log("쪽지 보내기");
			$("#f_memo").submit();
		}
		function memoFormClose(){
			$("#dlg_memo").dialog('close');			
		}
		function memoContent(){
			console.log("쪽지내용보기");
			$("#dlg_memoContent").dialog({
				title: "쪽지 내용 확인",
				// 쪽지 내용을 DB에서 꼭 가져와야 하나요?
				// 목록을 가져올 때 가지고 있다가 출력해도 되지 않을까?(오라클 경유를 안해도 됨)
				// 기준 : 쪽지내용 확인 후 read_yn을 Y로 업데이트 해야되니까 DB에서 가져와야함
				// 한 건을 조회한 후에 그 자료구조가 null이 아닐 때만 업데이트 해야됨
				// 만일 500번이 일어나면 진행이 안되어야 한다.
				// 이 기능을 구현하는데 있어서 컨트롤계층에 메소드부터 호출이 되어야 하는 건지
				// 아니면 로직클래스에 메소드 호출만으로도 충분한지 고민해보기 -> 객체주입관계와 메소드 선언을 결정함
				// 설계자는 기능 담당자가 구현해야하는 페이지 이름과 메소드, 그리고 파라미터와 리턴타입 모두를
				// 다 정해놓고 담당자는 메소드 안에 기능 구현만 하도록 할 것
				href:"/memo/memoContent?no="+gm_no,
				modal: true,
				closed: true
			});
			$("#dlg_memoContent").dialog('open');
		}
		// 하나를 바꾸면 다른 관련된 코드들도 모두 찾아서 변경해야 한다.
		// 대체로 반복되는 코드이고 어렵지는 않은데 귀찮다.
		// 또한 에러가 발생할 수도 있다.
		// 유지보수 업무를 담당하고 있다고 가정
		// 가능하다면 최소한의 코드만 수정하고 유지보수가 이루어질 수 있도록 코딩하기
		function memoContentClose(){
			// recieveMemoList();
			// SPA는 과연 옳은 선택이였을까?
			location.href="/auth/index.jsp"; // URL이 변경 -> 기존에 요청이 끊어지고 새로운 요청 - 세션이나 쿠키가 바뀐다.
			/* setTimeout(function(){
				location.reload();
				},1000); */
			$("#dlg_memoContent").dialog('close');			
		}
	</script>
</head>
<body>
<script>
	// DOM트리가 다 그려진거니?  yes
	// DOM트리가 그려졌을 때 - 준비되었을 때 - ready
	$(document).ready(function() {
		// 시점

		$("#d_member").hide();
		$("#d_memberInsert").hide();
		$("#d_receiveMemoList").hide();
		$("#d_sendMemoList").hide();
		$("#mem_id").textbox('setValue','apple');
		$("#mem_pw").textbox('setValue','123');

	});
</script>
	<div style="margin: 20px 0;"></div>
	<div class="easyui-layout" style="width: 1000px; height: 500px;">
		<div data-options="region:'south',split:true" style="height: 50px;"></div>
		<div data-options="region:'west',split:true" title="KH정보교육원"
			style="width: 200px;">
	<% 
	if(smem_name == null){  	
	%>
			<!--################# 로그인 영역 시작 #################-->
			<div style="margin: 10px 0;"></div>
			<div id="d_login" align="center">
				<div style="margin: 3px 0;"></div>
				<input id="mem_id" name="mem_id" class="easyui-textbox" />
				<script type="text/javascript">
			$('#mem_id').textbox({
				iconCls:'icon-man',
				iconAlign: 'right',
				prompt:'아이디'
			});
			</script>
				<div style="margin: 3px 0;"></div>
				<input id="mem_pw" name="mem_pw" class="easyui-passwordbox" />
				<script type="text/javascript">
			$('#mem_pw').passwordbox({
				iconAlign: 'right',
				prompt:'비밀번호'
			});
			</script>
				<div style="margin: 3px 0;"></div>
				<a id="btn_login" href="javascript:login()"
					class="easyui-linkbutton" data-options="iconCls:'icon-man'">
					로그인 </a> <a id="btn_member" href="javascript:memberShip()"
					class="easyui-linkbutton" data-options="iconCls:'icon-add'">
					회원가입 </a>
			</div>
			<!--################# 로그인 영역 끝 #################-->
			<% 
	}else{
%>
			<!--################ 로그아웃 영역 시작 ###############-->
			<div id="d_logout" align="center">
				<div id="d_ok">
					<%=smem_name%>님 환영합니다.
					<br />
					읽지 않은 쪽지 수 : <%=s_cnt %> 통
				</div>
				<div style="margin: 3px 0"></div>
				<a id="btn_logout" href="javascript:logout()"
					class="easyui-linkbutton" data-options="iconCls:'icon-cancel'">
					로그아웃 </a> <a id="btn_member" href="javascript:memberUpdate()"
					class="easyui-linkbutton" data-options="iconCls:'icon-edit'">
					정보수정 </a>
			</div>
			<!--################ 로그아웃 영역 끝 ###############-->
<% 
	} /////////////// end of 로그아웃
%>
			<!--################ 메뉴 영역 시작 ###############-->
			<div style="margin: 20px 0;"></div>
<% 
	if(smem_id != null){
%>
			<ul id="tre_gym" class="easyui-tree" style="margin: 0 6px">
				<li data-options="state:'closed'">
					<span>회원관리</span>
					<ul>
						<li>
							<a href="javascript:memberList()">회원목록</a>
						</li>
						<li>
							<a href="javascript:memberInsert()">회원등록</a>
						</li>
						<li>
							<a href="javascript:memberDelete()">회원삭제</a>
						</li>
					</ul>
				</li>
				<li data-options="state:'closed'">
					<span>쪽지관리</span>
					<ul>
						<li>
							<a href="javascript:recieveMemoList()">받은쪽지함</a>
						</li>
						<li>
							<a href="javascript:sendMemoList()">보낸쪽지함</a>
						</li>
					</ul>
				</li>
				<li data-options="state:'closed'">
					<span>게시판</span>
					<ul>
						<li>1:1</li>
						<li>공지사항</li>
						<li>Q&A</li>
					</ul>
				</li>
			</ul>
<% 
	}
%>
			<!--################ 메뉴 영역 끝 ###############-->
		</div>
		<div data-options="region:'center',title:'TerrGYM System',iconCls:'icon-ok'">
		<!-- [[ 회원관리{회원목록, 회원등록, 회원삭제} ]] -->
			<div id="d_member">
			<div style="margin: 5px 0;"></div>
			Home > 회원관리 > 회원목록
			<hr>
			<div style="margin: 20px 0;"></div>
			<!-- [[ 조건 검색 화면 ]] -->
			<div style="margin: 20px 0;">
			아이디 : <input id="search_id" name="search_id" class="easyui-textbox" style="width:110px">
			&nbsp;&nbsp;&nbsp;
			이 름 : <input id="search_name" name="search_name" class="easyui-textbox" style="width:110px">
			</div>
			<!-- [[ 조회|입력|수정|삭제 버튼 ]] -->
			<div style="margin: 5px 0;">
			<a id="btn" href="javascript:memberList()" class="easyui-linkbutton" data-options="iconCls:'icon-search'">조회</a>
			<a id="btn" href="javascript:memberInsert()" class="easyui-linkbutton" data-options="iconCls:'icon-add'">입력</a>
			<a id="btn" href="javascript:memberUpdate()" class="easyui-linkbutton" data-options="iconCls:'icon-edit'">수정</a>
			<a id="btn" href="javascript:memberDelete()" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">삭제</a>
			</div>
			<!-- [[ 회원목록 출력 ]] -->
			<table id="dg_member" class="easyui-datagrid" style="width:700px;height:250px"
            	data-options="singleSelect:true,collapsible:true,method:'get'">
	        	<thead>
		            <tr>
		                <th data-options="field:'MEM_ID',width:80, align:'center'">아이디</th>
		                <th data-options="field:'MEM_NAME',width:100, align:'center'">이름</th>
		                <th data-options="field:'MEM_ADDRESS',width:370,align:'left'">주소</th>
		                <th data-options="field:'BUTTON',width:80,align:'center'"></th>
		            </tr>
	        	</thead>
    		</table>
			<!-- <div id="dg_member"></div> -->
			
			</div>
			<div id="d_memberInsert">
			<div style="margin: 5px 0;"></div>
			Home > 회원관리 > 회원등록
			<hr>
			<div style="margin: 20px 0;"></div>
			<div>회원등록화면 보여주기</div>
			</div>
	<!-- ======================================================================= 
			              [ 받은 쪽지함 ] - 읽지 않은 쪽지 수, to_id == smem_id
			====================================================================-->
			<div id="d_receiveMemoList">
				<div style="margin: 5px 0;"></div>
				Home > 쪽지관리 > 받은쪽지함
				<hr>
				<table id="dg_receiveMemoList" class="easyui-datagrid" style="width:600px;height:250px"
            	data-options="singleSelect:true,collapsible:true,method:'get'">
	        	<thead>
		            <tr>
		                <th data-options="field:'NO',width:80, align:'center'">번호</th>
		                <th data-options="field:'FROM_ID',width:100, align:'center'">보낸사람ID</th>
		                <th data-options="field:'MEM_NAME',width:100,align:'left'">보낸사람 이름</th>
		                <th data-options="field:'READ_YN',width:100,align:'left'">개봉여부</th>
		                <th data-options="field:'BUTTON',width:80,align:'center'">버튼</th>
		            </tr>
	        	</thead>
    		</table>
				<div id="dlg_memoContent" footer="#btn_memoContent" class="easyui-dialog" 
					title="쪽지확인" data-options="modal:true,closed:true" 
					style="width: 600px; height: 400px; padding: 10px">
				<div id="btn_memoContent" align="right">
					<a href="javascript:memoContentClose()" class="easyui-linkbutton" iconCls="icon-clear">닫기</a>
				</div>
			</div>
			</div>
	<!-- ======================================================================== 
			              [ 보낸 쪽지함 ]
			====================================================================-->
			<div id="d_sendMemoList">
				<div style="margin: 5px 0;"></div>
				Home > 쪽지관리 > 보낸쪽지함
				<hr>
			</div>
			
			
		<!-- [[ 쪽지관리{받은 쪽지함, 보낸쪽지함} ]] -->
			<div id="dlg_memo" footer="#btn_memo" class="easyui-dialog" title="쪽지쓰기" data-options="modal:true,closed:true" style="width: 600px; height: 400px; padding: 10px">
				<div id="btn_memo" align="right">
					<a href="javascript:memoFormClose()" class="easyui-linkbutton" iconCls="icon-clear">닫기</a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>