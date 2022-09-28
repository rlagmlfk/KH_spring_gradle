<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="../common/easyui_common.jsp" %>
<style>
	#d_detail {
		position: absolute;
	}
</style>
<script type="text/javascript">
	function startMethod(td){
		$.ajax({
			  method: "GET",
			  url: "./pictureInfo.jsp?p_no=2",
			  success:function(result) { // result -> searchResult.jsp -> html태그들이다.
			    console.log(result); // JSON포맷
				}////// end of success
			  ,error:function(e){
					$("#d_search").text(e.responseText); // 에러메시지 출력됨 - 힌트 - 디버깅
				}
		}); /////// end of ajax
	}
	function clearMethod(){
		document.getElementById("d_detail").innerHTML="";
		//$("#d_detail").html("");
	}
</script>
</head>
<body>
	<table border="1">
		<thead>
			<th colspan="2">그림목록</th>
		</thead>
		<tbody>
			<tr>
				<td align="center"><img src="../images/picture1.jpg" width="50px" height="50px"/></td>
				<td id="1" onmouseover="startMethod(this)" onmouseout="clearMethod()">추상화1</td>
			</tr>
			<tr>
				<td align="center"><img src="../images/picture2.jpg" width="50px" height="50px"/></td>
				<td id="1" onmouseover="startMethod(this)" onmouseout="clearMethod()">추상화2</td>
			</tr>
			<tr>
				<td align="center"><img src="../images/picture3.jpg" width="50px" height="50px"/></td>
				<td id="1" onmouseover="startMethod(this)" onmouseout="clearMethod()">추상화3</td>
			</tr>
			<tr>
				<td align="center"><img src="../images/picture4.jpg" width="50px" height="50px"/></td>
				<td id="1" onmouseover="startMethod(this)" onmouseout="clearMethod()">추상화4</td>
			</tr>
		</tbody>
	</table>
	<div id="d_detail"></div>
</body>
</html>