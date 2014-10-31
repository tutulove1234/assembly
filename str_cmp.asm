;ecx 表示计数 , eax 放置字符串1 地址 , ebx 放置字符串2 地址
;比较字节时 , 尽量使用al bl 等8bit的寄存器使用 

[section .data]

string1 	db 	"hello",0
string1_len 	equ 	$-string1
string2 	db 	"hello0",0
string2_len 	equ 	$-string2

SYS_CALL 	equ 	0x80

[section .text]
global main 
main :

	mov 	eax , string1_len
	mov 	ebx , string2_len
	cmp 	eax , ebx
	
	jne 	exit_not_equ
	
	mov ecx , 0 
loop_c:	mov byte al , [string1 +ecx]
	mov byte bl , [string2 +ecx]
	
	cmp byte  al , bl
	jne exit_not_equ
	
	inc ecx
	cmp byte al , 0
	jne loop_c
;相等时候返回0 
exit_equ :
	mov eax , 1
	mov ebx , 0

	int SYS_CALL
;不相等的时候 , 返回1
exit_not_equ :
	mov eax , 1
	mov ebx , 1
	
	int SYS_CALL
