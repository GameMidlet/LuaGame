function main(){
	var canvas=document.getElementById('example');
	if(!canvas){
		console.log('没有canvas');
		return false;
	}
	console.log('有canvas');

	var ctx=canvas.getContext('2d');//获取绘制二维图形的绘图上下文

	ctx.fillStyle='rgba(0,0,255,1.0)';//填充颜色
	ctx.fillRect(100,100,400,400);//填充矩形
}