; Initialize
MOV R0, #0      ; R0 = Fib(0)
MOV R2, #1      ; R2 = Fib(1)
MOV R3, R1      ; R3 = n
SUB R3, #2      ; R3 = n - 2

BEQ R3, #0, END ; if R3 == 0, jump to END (n == 2, which means Fib(0) or Fib(1))
ADDI R0, R2, #0 ; R0 = R2 (copy Fib(1) to R0)

; Main loop for n > 1
LOOP:
ADD R4, R0, R2  ; R4 = R0 + R2 (next Fibonacci number)
MOV R0, R2      ; move the previous Fib(1) to Fib(0)
MOV R2, R4      ; update the last computed Fibonacci to be the new Fib(1)
SUBI R3, R3, #1 ; decrement counter
BNE R3, #0, LOOP; continue loop if R3 != 0

; Finish
END:
HLT
