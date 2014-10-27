jmp near start 

;声明数据
mytext 	db 	'L',0x07,'a',0x07,'b',0x07,'e',0x07,'l' ,0x07,\
		' ',0x07,'o',0x07 ,'f',0x07,'f',0x07,'s',0x07,'e',0x07,'t',0x07,':',0x07
;获得字符串长度
;mytext_len 	equ 	$-mytext
;预留5个位置保存number每一位
number 	db 	0,0,0,0,0


start :

; 设置段寄存器 ds 为0x7c00 . 附加段寄存器es 为0xb800 使用movsb 或者movsw 指令复制字符串

	mov ax , 0x7c0
	mov ds , ax 

	mov ax , 0xb800
	mov es , ax 

	cld
	mov cx , (number-mytext)/2

	mov si , mytext
	mov di , 0

	rep movsw 

; 完成复制
; 将number 的值 放置到es对应的后面

	mov cx , 5 			; 循环次数
	mov ax , number  		
	mov si , 10 			;除数
	mov bx , number 		;用来向number 里写数据

digit :
	xor dx , dx 			;高位置零
	div si 				
	mov [bx] , dl 			;将余数放置bx中 即number 占位的地方 dx 保存余数
	inc bx
	loop digit

;循环结束后 , number就被倒置在占位区
	
;然后我们需要将值再放在es 对应的显存的位置, 注意顺序是倒序的

	mov bx ,number
	mov si , 4
show :
	mov al , [bx+si] 		;
	add al , 0x30  			;转换为ascii
	mov ah , 0x04 			;设置前景色 , 背景色 等
	mov [es:di] , ax 		;将转换完的值放在对应位置
	add di , 2  			;di 自增 2 
	dec si 				;倒计数--

	jns show 			;如果si 为正 , 继续执行循环

	mov word [es:di],0x0744

	jmp  $

times 	510-($-$$) 	db 	0
			db 	0x55,0xaa



