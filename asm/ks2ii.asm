assume cs:code
code segment
    start:mov ax,0
          mov es,ax
          mov di,200h

          mov ax,cs
          mov ds,ax
          mov si,offset int19
          mov cx,offset int19_e - offset int19

          mov ax,offset rst - offset int19
          add ax,200h
          mov [si+2],ax
          mov ax,offset stt - offset int19
          add ax,200h
          mov [si+4],ax

          mov ax,offset showt - offset int19
          add ax,200h
          mov [si+6],ax
          mov ax,offset sett - offset int19
          add ax,200h
          mov [si+8],ax

          cld
          rep movsb

          nop
          nop

          cli
          mov word ptr es:[19h*4],200h
          mov word ptr es:[19h*4+2],0
          sti

          mov ax,4c00h
          int 21h

    int19:jmp short s
       dw 0,0,0,0   ;�洢�ӳ����ַ
       dw 0,0ffffh  ;��һ���ӳ�����Ҫת���ĵ�ַ
       dw 7c00h,0   ;�ڶ����ӳ�����Ҫ�ĵ�ַ
        s:push bx
          push ds

          mov bl,ah
          mov bh,0
          add bx,bx

          mov ax,cs
          mov ds,ax
          call word ptr [bx+202h]

          pop ds
          pop bx
          iret

      rst:ret
      stt:ret

    showt:ret

    sett:jmp near ptr st_st     ;ת��ָ�λ�Ʋ���Ϊ2B
         db 128 dup (0)
         dw 0,0
   st_st:push bx
         push dx
         push bp
         push si

         mov dh,13               ;������ַ�����ʾ���к��к�
         mov dl,16
         mov bx,offset sett - offset int19
         add bx,203h            ;bxָ��洢�ַ������׵�ַ
         mov bp,bx
         add bp,128        ;bpָ��洢�ӳ����ַ���ڴ��
         mov si,0

         mov ax,offset set_cur - offset int19
         add ax,200h
         mov ds:[bp],ax
         mov ax,offset show_char - offset int19
         add ax,200h
         mov ds:[bp+2],ax

         pushf            ;��IF��־����Ϊ��ʱ����19h�ж��У�if=0����������ж��޷���Ӧ
         pop ax
         or ax,0200h
         push ax
         popf

 lpgetch:mov ah,0
         int 16h
         cmp al,20h
         jb nchar
         push bx
         mov bh,0
         call word ptr ds:[bp]
         mov bx,0042h
         call word ptr ds:[bp+2]
         pop bx
         mov [bx][si],al
         inc si
         inc dl
         cmp dl,80
         jne lpgetch
         inc dh
         mov dl,16
         jmp short lpgetch
   nchar:cmp al,1ch
         je enter
         cmp al,0eh
         je bksp
         jmp short lpgetch

    bksp:cmp si,0
         je lpgetch
         dec si
         dec dl
         cmp dl,16
         jnb del_ch
         dec dh
         mov dl,79
 del_ch:push bx
        mov bh,0
        call word ptr ds:[bp]
        mov bx,0007h
        mov al,0
        call word ptr ds:[bp+2]
        pop bx
        jmp short lpgetch
  enter:mov byte ptr [bx][si],0


set_over:pushf         ;��ʾʱ�������������¹ر�IF
         pop ax
         and ax,0fdffh
         push ax
         popf
         pop si
         pop bp
         pop dx
         pop bx
         ret

 set_cur:push ax   ;���ù��
         push dx
         mov ah,2
         int 10h
         pop dx
         pop ax
         ret

show_char:push ax   ;��괦��ʾ�ַ�
          push cx
          push dx

          mov cx,1
          mov ah,9
          int 10h

          pop dx
          pop cx
          pop ax
          ret

  int19_e:nop

code ends
end start
