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

      rst:jmp dword ptr ds:[20ah]
          ret
      stt:mov ax,0
          mov es,ax
          mov bx,7c00h
          mov al,1
          mov ch,0
          mov cl,1
          mov dh,0
          mov dl,80h
          mov ah,2
          int 13h
          jmp dword ptr ds:[20eh]
          ret

    showt:jmp short showst
          db 9,8,7,4,2,0
          db '// ::',0
          dw  0,0       ;�洢ԭ��9���жϴ������Ķε�ַ��ƫ�Ƶ�ַ
          dw  0         ;esc������ѭ����ĵ�ַ
   showst:push ax       ;��ʾʱ����ӳ�����Ҫʵ�ֶ�F1����esc������Ӧ��������Ҫ�ڴ��ӳ�����
          push bx       ;�����趨9�ż����жϴ�����򡣴˳��������Ҫ�ָ�ԭ�ȵ��жϴ������
          push cx
          push si
          push di
          push ds
          push es

          mov ax,cs  ;cs=0
          mov ds,ax  ;ds=0
          mov ax,0b800h
          mov es,ax
          mov bh,42h
          mov di,720h
          mov si,offset showt- offset int19
          add si,202h

          mov ax,si
          add ax,12
          mov bp,ax    ;bp����Ѱַԭ�ȵ�9���жϴ������ĵ�ַ

          push ds:[36]    ;����ԭ��9���жϴ���������ڵ�ַ
          pop ds:[bp]
          push ds:[38]
          pop ds:[bp+2]

          push cs     ;�����µ�9���жϴ�������ַ
          pop ds:[38]
          mov ax,offset int9 - offset int19
          add ax,200h
          mov ds:[36],ax

          mov ax,offset showover - offset int19
          add ax,200h
          mov ds:[bp+4],ax        ;����esc����ת�����ĵ�ַ

          pushf            ;��IF��־����Ϊ��ʱ����19h�ж��У�if=0����������ж��޷���Ӧ
          pop ax
          or ax,0200h
          push ax
          popf

 refresht:mov si,bp    ;���������ˣ����ڰ���F1����û���⣬��Ϊ��������᷵�ص��жϵ�λ�ü���ִ�С�
          sub si,12
          mov di,720h    ;������esc��ȴҪ��ת��һ����λ��ִ�С����õķ�����ֱ����ջ���޸�iretִ�з��صĵ�ַIP
          mov cx,6  ;���ǿ��±������жϵĳ���Σ�ѭ����ʾʱ��ĳ�������push si��push di��ջ����
      lpt:mov al,[si] ;���ѹջ������esc�жϣ�����ȷʵ��������showover��ִ�С����������ղ�ѹ���si��di��δ
          out 70h,al ;��ջ�����Ǳ�����ԭ��ջ�б�������ݳ�ջ����Ȼ��������󣬳���Ҳ�޷���ȷ�ص�int19����������
          in al,71h  ;��˵��������push��pop�кܴ���ܲ���ԡ������������ʹ��ջ������si��di��
          push ax
          push cx
          mov cl,4
          shr al,cl
          pop cx
          add al,30h
          mov bl,al
          mov es:[di],bx
          pop ax
          and al,0fh
          add al,30h
          mov bl,al
          mov es:[di+2],bx

          mov bl,[si+6]
          mov es:[di+4],bx

          inc si
          add di,6
          loop lpt
          jmp short refresht

 showover:pushf         ;��ʾʱ�������������¹ر�IF
          pop ax
          and ax,0fdffh
          push ax
          popf
          pop es
          pop ds
          pop di
          pop si
          pop cx
          pop bx
          pop ax

          ret

    int9:push ax
         push bp
         in al,60h

         pushf
         call dword ptr ds:[bp]

         cmp al,3bh  ;F1��
         je sf1
         cmp al,1    ;esc��
         je sesc
         jmp short int9ok
     sf1:inc bh
         jmp short int9ok
    sesc:push ds:[bp]
         push ds:[bp+2]
         pop ds:[38]
         pop ds:[36]

         mov ax,ds:[bp+4]

         mov bp,sp
         mov [bp+4],ax
  int9ok:pop bp
         pop ax
         iret

     sett:ret

  int19_e:nop

code ends
end start
