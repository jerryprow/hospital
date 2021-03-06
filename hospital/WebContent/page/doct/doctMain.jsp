<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<base href="<%=basePath%>">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="css/myCss.css" type="text/css" />
<link rel="stylesheet" href="layui/css/layui.css">
<style type="text/css">
html .layui-layer-demo{background-color:#eee;}
.layui-layer-demo .layui-layer-title{border:none; background-color:#2f4056; color:#fff;}

</style>
<title>就诊信息系统</title>
</head>
<body>
	doctMain
	</div>
	<!-- <iframe align="bottom" src="page/doct/doctFoot.jsp" width="100%" height="2%"></iframe> -->
</body>
<script src="js/jquery.min.js"></script>
<script src="js/myJs.js"></script>
<script type="text/javascript" src="layui/layui.all.js"></script>
<script>
//准备接诊  将医生的接诊状态修改为0 
	function readyScan(obj){
		var doctId=${doctSessionId};
		$.ajax({
			url:'doct_readyScan',
			data:{ 'doct.doctId': doctId
			},
			type:'POST',
			dataType:'JSON',	
			success:function(map){
				if(map.msg=='success'){
					layui.use('layer', function() {
						var layer = layui.layer;
					layer.msg('开始接诊啦~');
					});
				}
				else if(map.msg='fail'){
					layui.use('layer', function() {
						var layer = layui.layer;
						var appoints = map.appoints;
						console.log(appoints);
						var cont = '';
						$.each(appoints,function(key,appoint){
							var startDate ='';
							if(appoint.udStartDate != null){
							var date = new Date(appoint.udStartDate);
							console.log(appoint.udStartDate);
							startDate=  date.getFullYear() + '/' +date.getMonth() + '/' + date.getDate() +' ' + date.getHours() +':' + date.getMinutes()
							}else{
								startDate = '--'
							}
							cont = cont + '<div class="layui-form-item">'
							+'<label class="layui-form-label">信息ID：</label> '
										+'<label class="layui-form-label" id="label-userAge">'+ appoint.udId + '</label></div>'
										
										+ '<div class="layui-form-item">'
							+'<label class="layui-form-label">排队序号：</label> '
										+'<label class="layui-form-label" id="label-userAge">'+ appoint.udNo + '</label></div>'
							
										+ '<div class="layui-form-item">'
							+'<label class="layui-form-label">开始时间：</label> '
										+'<label class="layui-form-label" id="label-userAge">'+startDate+ '</label></div>'
							
										+ '<div class="layui-form-item">'
							+'<label class="layui-form-label">姓名：</label> '
										+'<label class="layui-form-label" id="label-userAge">'+ appoint.user.userRealName + '</label></div>'
										+ '<div class="layui-form-item">'
							+'<div class="layui-input-block">'
							+'<button class="layui-btn" onclick="endWatch('+appoint.udId+')">立即结束会诊</button></div></div>'
						})
						layer.open({
							  title : '您还有未完结的就诊：',
							  type: 1,
							  skin: 'layui-layer-demo', //样式类名
							  closeBtn: 0, //不显示关闭按钮
							  anim: 1,
							  shadeClose: true, //开启遮罩关闭
							  content: cont ,
							  area :['300px','300px']
							});
					});
				}
					
			},
			error:function(){
				layui.use('layer', function() {
					var layer = layui.layer;
					layer.msg('出错啦~请重试.');
				});
				
			}
		})
	}

	function endWatch(udId){
		var doctId=${doctSessionId};	
		$.ajax ({
			url:'doct_endWatch',
			type:'POST',
			data:{
				'appoint.udId':udId,
				'doct.doctId':doctId
			},
			success:function(msg){
				layui.use('layer', function() {
					var layer = layui.layer;
					layer.close(layer.index);
					layer.msg('结束会诊成功~');
					$(".layui-btn layui-btn-fluid").css("display", "block");
					$("#formDivId").css("display", "none");
					
				});
			},
			error :function(){
				layui.use('layer', function() {
					var layer = layui.layer;
					layer.msg('出错啦~请重试.');
				});
			}
		})	;
	}
	
	function confirmScan(obj) {//确认扫描
		var doctId=${doctSessionId};
		var sexi = '';
		var age='';
		var userBackup='';
		var dateNow = new Date();
	$.ajax({
		url:'doct_vertifyRecord',
		data:{
			'doct.doctId':doctId
		},
		type:'POST',
		async:true,
		dataType:'JSON',
		success:function(appoint){
			if(appoint!=null){
			$(obj).css("display", "none");
			$("#formDivId").css("display", "block");
			$("#ud_code").attr("value",appoint.udCode);
			$("#label-userRealName").html(appoint.user.userRealName);
			if(appoint.user.userSex =='M'){
				sexi='男';
			}else{
				sexi='女';
			}
			age= (dateNow-appoint.user.userBirthday)/365/24/60/60/1000 +1;
			$("#label-userSex").html(sexi);
			$("#label-userAge").html(Math.floor(age));
			$("#label-userRealName").html(appoint.user.userRealName);
			console.log(appoint.user.userBackup ==undefined );
			userBackup = appoint.user.userBackup ==undefined ? '暂无' : appoint.user.userBackup;			
			$("#label-userBackup").html(userBackup);
			$("#userHistoryBtn").attr("onclick","userHistory("+appoint.user.userId+","+doctId+")");
			}else{
				layui.use('layer', function() {
					var layer = layui.layer;
					layer.msg("没有找到数据 请重新扫码确认");
				});
			}
		}
	});
	}
	//查看该用户的挂号历史
	function userHistory(userId,doctId){
		console.log(userId,doctId);
	}
	
	function showMyInfo(doctId) {
		layui.use('layer', function() {
			var layer = layui.layer;
			layer_show(800, 600, '基本资料', 'doct_showDoctInfo?doct.doctId='
					+ doctId);
		});
	};
	function toChangePwd() {
		layui.use('layer', function() {
			var layer = layui.layer;
			layer_show(500, 400, '修改密码', 'page/doct/doctPwd.jsp');
		});
	}

	layui.use('element', function() {
		var element = layui.element;

	});

	layui.use('form', function() {
		var form = layui.form;
		//监听提交
		form.on('submit(comitResult)', function(data) {		
			$.ajax({
				url:'doct_comitResult',
				data:{
					data:JSON.stringify(data.field)
				},
				type:'POST',
				dataType:'JSON',
				success:function(msga){
				 	layui.use('layer', function() {
				 		var msg = msga=='success' ? '提交成功！幸苦了~':'提交失败！再检查下~';	
				 						 		
				  	layer.msg(msg);
					});
				 //将当前的输入框隐藏准备接下一个人	
				},
				error:function(){
					layui.use('layer', function() {
						layer.msg('提交错误，请检查');
						});
				}
				
			})
			return false;
		});
	});
</script>
</html>