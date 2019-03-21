var VS='void main(){\n'+
' gl_Position=vec4(0.0,0.0,0.0,1.0);\n'+//设置坐标
'gl_PointSize=10.0;\n'+//设置尺寸
'}\n';

var FS='void main(){\n'+
' gl_FragColor=vec4(1.0,0.0,0.0,1.0);\n'+ //设置颜色
'}\n';




function main(){
	var canvas=document.getElementById('example');
	if(!canvas){
		console.log('没有canvas');
		return false;
	}
	console.log('有canvas');
	debugger;
	var gl=getWebGLContext(canvas);
	if(!gl){
		console.log('初始化GL环境出错');
		return false;
	}
    
    if(!initShaders(gl,VS,FS)){
    	console.log('初始化Shader环境出错');
		return false;
    }


	gl.clearColor(0.0,0.0,0.0,1.0);
	gl.clear(gl.COLOR_BUFFER_BIT);

	gl.drawArrays(gl.POINTS,0,1);




	// gl.drawColor(1.0,0.0,0.0,1.0);
	// gl.drawPoint(0,0,0,10);

}