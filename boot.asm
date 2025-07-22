ORG 0x7c00                 ; It's a fake offset for the assembler — the binary starts at 0, but the CPU will load and run it from address 0x7C00.
BITS 16                    ; All instructions and registers will be interpreted as 16-bit (AX, BX, SI, etc.).

start:
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