ORG 0
BITS 16                    ; All instructions and registers will be interpreted as 16-bit (AX, BX, SI, etc.).

_start:
    jmp short start
    nop

times 33 db 0              ; Some BIOS implementations look for BIOS Parameter Block values when we test our bootloader
                           ; with USB. To overcome that issues we fill 33 bytes representing those values with 0.

handle_zero:
    mov ah, 0eh
    mov al, 'A'
    mov bx, 0x00
    int 0x10
    iret

start:
    jmp 0x7c0:step2

step2:
    cli
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti

    mov word[ss:0x00], handle_zero
    mov word[ss:0x02], 0x7c0
    int 0

    mov si, message
    call print
    jmp $

print:
    mov bx, 0
.loop:
    lodsb                  ; LOaD String Byte — it reads the next character from message and advances SI to the next character.
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10                ; BIOS video services interrupt — More info at https://www.ctyme.com/intr/int.htm.
    ret


message: db "Hello, World", 0
times 510-($ - $$) db 0     ; Filling up 510 bytes.
dw 0xAA55                   ; Boot signature. Intel is little-endian.