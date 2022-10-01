masm
model medium
.data

mes db 'Enter cripting level: ','$'
mes1 db 'Do you wana cript, decript or exit the program(1, 2, 3): ','$'
error1 db 'You entered an unvalid cripting level.','$'
error2 db 'You cant cript the message anymore','$'
error3 db 'The message is in its origanal form it cant be decripted further','$'
error4 db 'The entered value is undefined','$'

count db 30h
criptLV db (?)
switcher dw (?)

decriptCode db 33 dup (' '), 33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126
  criptCode db 33 dup (' '), 49,61,94,54,80,122,53,97,90,33,99,89,92,85,44,34,74,123,107,69,111,86,100,63,70,47,108,52,87,104,124,60,43,62,71,64,40,117,98,56,55,65,39,38,58,102,59,120,35,73,36,81,37,45,79,68,121,84,88,82,114,126,106,76,51,95,116,72,77,118,83,48,112,75,101,119,105,125,110,113,96,42,46,93,50,67,66,109,91,103,57,78,115,41

crp2LV db 200 dup (0)

filename	db	'text.txt',0
point_fname	dd	filename
handeling dw 0

string db 200 dup (' ')
strSize dw (?)
char dw (?)

.stack	256
.code
main:
	mov ax, @data
	mov ds, ax
fileOpening:	
	mov dx, offset filename
	mov al,0h
	mov ah, 3dh
	int 21h
	mov handeling, ax

	mov ah, 3fh
	mov bx, handeling
	mov cx, 200
	mov dx, offset string
	int 21h
	mov strSize,ax

	mov ah,3eh
	mov bx, handeling
	int 21h

start:
	mov	ah,02h
	mov dl, 10
	int 21h
	
	mov	ah,09h
	mov	dx,offset mes
	int	21h	
	
	mov	ah,1h	
	int	21h	
	mov criptLV, al
	inc criptLV
	
	cmp criptLV, '1'
	jng miss
	cmp criptLV,'4'
	jng cript_decript
	
miss:
	mov	ah,02h
	mov dl, 10
	int 21h

	mov ah,09h
	mov	dl, offset error1
	int	21h	
	jmp start

cript_decript:
	
	mov ah,02h
	mov dl, 10
	int 21h
	
	mov	ah,09h
	mov	dx,offset mes1
	int	21h	
	
	mov	ah,1h	
	int	21h	
	
	cmp al, '1'
	je Cript
	cmp al, '2'
	je Decript
	cmp al, '3'
	je branch1
	
	mov	ah,02h
	mov dl, 10
	int 21h
	
	mov ah,09h
	mov dx,offset error4
	int 21h
	jmp cript_decript
	
Err_cript:
	mov	ah,02h
	mov dl, 10
	int 21h
	
	mov ah,09h
	mov dx,offset error2
	int 21h
	
	dec count
	jmp cript_decript
	
Err_decript:
	mov	ah,02h
	mov dl, 10
	int 21h
	
	mov ah,09h
	mov dx,offset error3
	int 21h
	
	inc count
	jmp cript_decript

branch1:
	jmp exit
	
Cript:
	inc count
	
	mov ah, criptLV
	cmp count, ah
	je Err_cript
	
	cmp count, '1'
	je Cript1
	
	cmp count, '2'
	je Cript2_branch1
	
	cmp count, '3'
	je Cript3_branch1
	
Decript:
	dec count
	cmp count, '/'
	je Err_decript
	
	cmp count, '0'
	je Decript1
	
	cmp count, '1'
	je Decript2_branch1
	
	cmp count, '2'
	je Decript3_branch1
	
Cript1:
	mov	ah,02h
	mov dl, 10
	int 21h
	
	xor si,si
	xor dx,dx
	mov cx,strSize
	lpstr_c1:
		mov dl,string[si]
		mov switcher,si
		mov si,dx
		mov dl, criptCode[si]
		mov si,switcher
		mov string[si], dl
		mov dl,string[si]
		mov ah,02h
		int 21h
		
		inc si
		loop lpstr_c1

	jmp cript_decript

Cript2_branch1:
	jmp Cript2
	
Cript3_branch1:
	jmp Cript3
	
Decript1:
	mov	ah,02h
	mov dl, 10
	int 21h
	
	xor si,si
	xor dx,dx
	mov cx,strSize
	lpstr_d1:
		mov dl,string[si]
		mov switcher,si
		mov si, 32
		loop1:
			inc si
			cmp dl,criptCode[si]
			jne loop1
		mov dl, decriptCode[si]
		mov si, switcher
		mov string[si],dl
		mov ah,02h
		int 21h
 
		
		inc si
		loop lpstr_d1
	
	jmp cript_decript


Decript2_branch1:
	 jmp Decript2

Decript3_branch1:
	jmp Decript3
Cript2:
	mov	ah,02h
	mov dl, 10
	int 21h
	
	xor dx,dx
	xor si,si
	mov cx,strSize
	lpstr_c2:
		mov dl,string[si]
		
		lowerer:
			cmp dl,0
			jle afterLowerer
			sbb dl, 13
			inc crp2LV[si]
			jmp lowerer
		afterLowerer:
		adc dl,46
		
		mov string[si],dl
		mov ah,02h
		int 21h
		
		inc si
		loop lpstr_c2
	
	jmp cript_decript
	
Decript2:
	mov	ah,02h
	mov dl, 10
	int 21h
	
	xor dx,dx
	xor si,si
	mov cx,strSize
	lpstr_d2:
		mov dl,string[si]
		
		Hightening:
			cmp crp2LV[si], 0
			jle afterHightening
			adc dl, 13
			dec crp2LV[si]
			jmp Hightening
		afterHightening:
		
		sbb dl,46
		mov string[si],dl
		mov ah,02h
		int 21h
		
		inc si
		loop lpstr_d2
	
	jmp cript_decript

Cript3:
	mov	ah,02h
	mov dl, 10
	int 21h
	
	xor dx,dx
	xor si,si
	mov cx,strSize
	lpstr_c3:
		mov dl,string[si]
		not dl
		
		mov string[si], dl
		mov ah,02h
		int 21h
		
		inc si
		loop lpstr_c3
	
	jmp cript_decript
	
Decript3:
	mov	ah,02h
	mov dl, 10
	int 21h
	
	xor dx,dx
	xor si,si
	mov cx,strSize
	lpstr_d3:
		mov dl,string[si]
		not dl
		
		mov string[si],dl
		mov ah,02h
		int 21h
		
		inc si
		loop lpstr_d3
	
	jmp cript_decript

exit:
	mov	ax,4c00h 
	int	21h
 end main