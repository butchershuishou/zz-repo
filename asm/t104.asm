assume cs:code,ds:data,ss:stack
data segment
      dw 12666,123,1,8,3,38
data ends
stack segment
      dw 128 dup (0)
stack ends
str segment
      db 32 dup (0)
str ends
code segment
   start:mov ax,str  ;�洢ת������ֽ�ds
         mov ds,ax

         mov ax,stack  ;ջss
         mov ss,ax
         mov sp,256

         mov ax,data   ;ԭʼ����es
         mov es,ax
         mov cx,6
         mov si,0   ;�ַ����׵�ַsi
         mov di,0    ;ԭʼ�����׵�ַdi

         mov dl,41  ;�к�
         mov dh,13  ;�к�
         push dx    ;��ջ����
    ;     mov cl,42h  ;��ɫ
    ;     call show_str
    ;     inc dl

      s0:mov ax,es:[di] ;�� ����ax
         call dtoc
         ;�����ӳ���ǰ׼��
         pop dx
         push cx
         push si

         mov si,0
         mov cl,42h
         ;�����ӳ���
         call show_str
         inc dh
         pop si
         pop cx
         push dx
         add di,2
         loop s0

         mov ax,4c00h
         int 21h

    dtoc:push bx
         push cx
         push dx
         push di

         mov dx,0
         mov bx,0
      s1:mov cx,10
         call divdw
         add cl,30h
         push cx
         inc bx

         mov cx,dx
         jcxz ok0
         jmp short s1
     ok0:mov cx,ax
         jcxz ok1
         jmp short s1
     ok1:mov di,si
         mov cx,bx
       m:pop dx
         mov [di],dl
         inc di
         loop m
         mov dl,0
         mov [di],dl

         pop di
         pop dx
         pop cx
         pop bx
         ret

    show_str:push bx
             push dx
             push es
             push di
             mov bx,cx
             mov ax,0b800h
             mov es,ax
             mov di,0
             mov ch,0

             mov al,160
             mul dh
             mov dh,0
             add ax,dx
             and ax,0fffeh   ;��֤��ʼ��ַ��ż���ֽڿ�ʼ
             mov di,ax

          s2:mov cl,[si]
             jcxz ok2

             mov es:[di],cl
             mov es:[di].1,bl

             inc si
             add di,2
             jmp short s2

         ok2:pop di
             pop es
             pop dx
             pop bx
             ret

     divdw:push bx
           mov bx,ax
           mov ax,dx
           mov dx,0
           div cx
           push ax
           mov ax,bx
           div cx
           mov cx,dx
           pop dx

           pop bx
           ret
code ends
end start
