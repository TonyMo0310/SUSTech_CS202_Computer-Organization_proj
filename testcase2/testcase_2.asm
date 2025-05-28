.data
main_prompt:  .asciz "Enter 3-bit mode (000 to 111): "
case0_prompt: .asciz "\n[Case0] Enter 8-bit binary: "
case0_orig:   .asciz "\nOriginal: "
case0_rev:    .asciz "\nReversed: "
case1_prompt: .asciz "\n[Case1] Enter 8-bit binary: "
case1_input:  .asciz "\nInput number (binary): "
case1_result: .asciz "\nPalindrome: "
case1_error:  .asciz "\nInvalid input! Please enter 8-bit binary\n"
case2_prompt1:.asciz "\n[Case2] Enter first number (8-bit binary): "
case2_prompt2:.asciz "[Case2] Enter second number (8-bit binary): "
case2_out1:   .asciz "\nFirst number integer: "
case2_out2:   .asciz "\nSecond number integer: "
case3_prompt1:.asciz "\n[Case3] Enter first number (8-bit binary): "
case3_prompt2:.asciz "[Case3] Enter second number (8-bit binary): "
case3_sum:    .asciz "\nSum: "
prompt4:      .asciz "Enter 4-bit binary (e.g. 1010): "
prompt5:      .asciz "Enter 8-bit binary: "
error_msg:    .asciz "Invalid input! Please enter 4-bit binary\n"
newline:      .asciz "\n"
case6_prompt: .asciz "\n[Case6] Enter 20-bit binary: "
case6_output: .asciz "\nHexadecimal output: 0x"
hex_digits:   .asciz "0123456789ABCDEF"
case7_prompt: .asciz "\n[Case7] Enter 8-bit binary: "
case7_output: .asciz "\nResult: "
case7_error:  .asciz "\nInvalid input! Please enter 8-bit binary\n"

main_buffer:  .space 4
buffer:       .space 9
num1:         .half 0
num2:         .half 0
input_buf:    .space 6
output_buf:   .space 9
bin_buf:      .space 21
hex_buf:      .space 9

.text
.globl main

main:
    # Display prompt
    la a0, main_prompt
    li a7, 4
    ecall

    # Read 3-bit mode
    li a7, 5
    ecall

    li t0, 0
    beq a0, t0, run_case0
    li t0, 1
    beq a0, t0, run_case1
    li t0, 2
    beq a0, t0, run_case2
    li t0, 3
    beq a0, t0, run_case3
    li t0, 4
    beq a0, t0, run_case4
    li t0, 5
    beq a0, t0, run_case5
    li t0, 6
    beq a0, t0, run_case6
    li t0, 7
    beq a0, t0, run_case7

    j exit

exit:
    li a7, 10
    ecall

run_case0:
    jal case0
    j exit
run_case1:
    jal case1
    j exit
run_case2:
    jal case2
    j exit
run_case3:
    jal case3
    j exit
run_case4:
    jal case4
    j exit
run_case5:
    jal case5
    j exit
run_case6:
    jal case6
    j exit
run_case7:
    jal case7
    j exit

# ------------------------- Case0 Logic (Bit Reversal) -------------------------
case0:
    addi sp, sp, -4
    sw ra, 0(sp)

    # Prompt for 8-bit input
    la a0, case0_prompt
    li a7, 4
    ecall

    la a0, bin_buf
    li a1, 9
    li a7, 8
    ecall

    jal convert_binary
    mv s0, a0               # Save original number

    # Output original number
    la a0, case0_orig
    li a7, 4
    ecall
    mv a0, s0
    jal bin8_to_string
    la a0, output_buf
    li a7, 4
    ecall
    la a0, newline
    li a7, 4
    ecall

    # Reverse bits
    mv a0, s0
    jal reverse_bits
    mv s0, a0

    # Output reversed number
    la a0, case0_rev
    li a7, 4
    ecall
    mv a0, s0
    jal bin8_to_string
    la a0, output_buf
    li a7, 4
    ecall
    la a0, newline
    li a7, 4
    ecall

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# ------------------------- Case1 Logic (Palindrome Check) -------------------------
case1:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw s0, 0(sp)            # Save s0 to preserve across calls

    # Prompt for 8-bit input
    la a0, case1_prompt
    li a7, 4
    ecall

    la a0, bin_buf
    li a1, 9
    li a7, 8
    ecall

    # Validate input
    mv a0, a0               # a0 = bin_buf
    jal validate_8bit_input
    bnez a1, case1_error1   # If a1 != 0, invalid input

    # Convert input to binary
    la a0, bin_buf
    jal convert_binary
    mv s0, a0               # Save input number

    # Debug: Output input number
    la a0, case1_input
    li a7, 4
    ecall
    mv a0, s0
    jal bin8_to_string
    la a0, output_buf
    li a7, 4
    ecall
    la a0, newline
    li a7, 4
    ecall

    # Check if palindrome
    mv a0, s0
    jal is_palindrome
    mv s0, a0               # 1 if palindrome, 0 if not

    # Output result as string
    la a0, case1_result
    li a7, 4
    ecall
    mv a0, s0
    jal bin8_to_string      # Convert 0 or 1 to string
    la a0, output_buf
    li a7, 4
    ecall
    la a0, newline
    li a7, 4
    ecall

    lw ra, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 8
    ret

case1_error1:
    la a0, case1_error
    li a7, 4
    ecall
    lw ra, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 8
    ret

# ------------------------- Case2 Logic -------------------------
case2:
    addi sp, sp, -8
    sw ra, 4(sp)
    sw s0, 0(sp)
    
    # Prompt for first number
    la a0, case2_prompt1
    li a7, 4
    ecall
    
    la a0, buffer
    li a1, 9
    li a7, 8
    ecall
    
    jal convert_binary
    slli s0, a0, 4
    sh s0, num1, t0
    
    # Prompt for second number
    la a0, case2_prompt2
    li a7, 4
    ecall
    
    la a0, buffer
    li a1, 9
    li a7, 8
    ecall
    
    jal convert_binary
    slli a0, a0, 4
    sh a0, num2, t0
    
    # Display results
    la a0, case2_out1
    li a7, 4
    ecall
    lhu a0, num1
    jal convert
    mv a0, a0
    li a7, 1
    ecall
    
    la a0, case2_out2
    li a7, 4
    ecall
    lhu a0, num2
    jal convert
    mv a0, a0
    li a7, 1
    ecall
    
    lw ra, 4(sp)
    lw s0, 0(sp)
    addi sp, sp, 8
    ret

# ------------------------- Case3 Logic -------------------------
case3:
    addi sp, sp, -12
    sw ra, 8(sp)
    sw s0, 4(sp)
    sw s1, 0(sp)
    
    # Prompt and process first number
    la a0, case3_prompt1
    li a7, 4
    ecall
    la a0, buffer
    li a1, 9
    li a7, 8
    ecall
    jal validate_8bit_input
    bnez a1, case3_error
    
    la a0, buffer
    jal convert_binary
    jal convert
    mv s0, a0
    
    # Prompt and process second number
    la a0, case3_prompt2
    li a7, 4
    ecall
    la a0, buffer
    li a1, 9
    li a7, 8
    ecall
    jal validate_8bit_input
    bnez a1, case3_error
    
    la a0, buffer
    jal convert_binary
    jal convert
    mv s1, a0
    
    # Display sum
    la a0, case3_sum
    li a7, 4
    ecall
    add a0, s0, s1
    li a7, 1
    ecall
    la a0, newline
    li a7, 4
    ecall
    
    lw ra, 8(sp)
    lw s0, 4(sp)
    lw s1, 0(sp)
    addi sp, sp, 12
    ret

case3_error:
    la a0, case1_error
    li a7, 4
    ecall
    lw ra, 8(sp)
    lw s0, 4(sp)
    lw s1, 0(sp)
    addi sp, sp, 12
    ret

# ------------------------- Case4 Logic -------------------------
case4:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a0, prompt4
    li a7, 4
    ecall

    jal read_binary_input
    bnez a1, case4_error

    mv s1, a0
    jal crc4
    slli s1, s1, 4
    or a0, s1, a1
    jal bin8_to_string

    la a0, output_buf
    li a7, 4
    ecall

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

case4_error:
    la a0, error_msg
    li a7, 4
    ecall
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# ------------------------- Case5 Logic (CRC-4, Mode 5) -------------------------
case5:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a0, prompt5
    li a7, 4
    ecall

    la a0, bin_buf
    li a1, 9
    li a7, 8
    ecall

    jal convert_binary
    mv s0, a0
    srli a0, s0, 4
    jal crc4
    andi s1, s0, 0x0F

    beq a1, s1, crc_valid
    li a0, 0
    j print_crc_result
crc_valid:
    li a0, 1
print_crc_result:
    li a7, 1
    ecall
    la a0, newline
    li a7, 4
    ecall

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# ------------------------- Case6 Logic (20-bit Binary to Hex) -------------------------
case6:
    addi sp, sp, -12
    sw ra, 8(sp)
    sw s0, 4(sp)
    sw s1, 0(sp)

    # Prompt for 20-bit binary input
    la a0, case6_prompt
    li a7, 4
    ecall

    # Read 20-bit binary string
    la a0, bin_buf
    li a1, 21           # 20 bits + null terminator
    li a7, 8
    ecall

    # Validate and convert 20-bit binary input
    mv a0, a0
    jal validate_20bit_input
    bnez a1, case6_error

    la a0, bin_buf
    jal convert_20bit_binary
    mv s0, a0           # Save 20-bit number

    # Shift left by 12 to append 12 zeros
    slli s0, s0, 12

    # Convert to hexadecimal string
    la a0, case6_output
    li a7, 4
    ecall

    mv a0, s0
    jal bin32_to_hex
    la a0, hex_buf
    li a7, 4
    ecall

    la a0, newline
    li a7, 4
    ecall

    lw ra, 8(sp)
    lw s0, 4(sp)
    lw s1, 0(sp)
    addi sp, sp, 12
    ret

case6_error:
    la a0, case1_error
    li a7, 4
    ecall
    lw ra, 8(sp)
    lw s0, 4(sp)
    lw s1, 0(sp)
    addi sp, sp, 12
    ret

# ------------------------- Case7 Logic (JAL/JALR Test, Mode 7) -------------------------
case7:
    addi sp, sp, -12
    sw ra, 8(sp)
    sw s0, 4(sp)
    sw s1, 0(sp)

    # Prompt for 8-bit binary input
    la a0, case7_prompt
    li a7, 4
    ecall

    # Read 8-bit binary string
    la a0, bin_buf
    li a1, 9
    li a7, 8
    ecall

    # Validate input
    mv a0, a0
    jal validate_8bit_input
    bnez a1, case7_error1

    # Convert input to binary
    la a0, bin_buf
    jal convert_binary
    mv s0, a0           # Save original number in s0 (instead of zero register)
    mv s1, a0           # Save copy for comparison

    # Perform JAL to add_one_jal
    jal ra, add_one_jal
    mv s0, a0           # Update s0 with result from add_one_jal

    # Prepare for JALR
    la t0, add_one_jalr # Load address of add_one_jalr
    jalr ra, t0, 0      # Jump to add_one_jalr
    mv s0, a0           # Update s0 with result from add_one_jalr

    # Check if jumps were successful (s0 should be s1 + 2)
    addi t0, s1, 2
    beq s0, t0, case7_success

    # If jumps failed, output original number
    mv a0, s1
    j case7_output1

case7_success:
    # If jumps succeeded, output number + 2
    mv a0, s0

case7_output1:
    # Output result as 8-bit binary string
    la a0, case7_output
    li a7, 4
    ecall
    mv a0, s0
    jal bin8_to_string
    la a0, output_buf
    li a7, 4
    ecall
    la a0, newline
    li a7, 4
    ecall

    lw ra, 8(sp)
    lw s0, 4(sp)
    lw s1, 0(sp)
    addi sp, sp, 12
    ret

case7_error1:
    la a0, case7_error
    li a7, 4
    ecall
    lw ra, 8(sp)
    lw s0, 4(sp)
    lw s1, 0(sp)
    addi sp, sp, 12
    ret

# ------------------------- Add One (JAL Target) -------------------------
add_one_jal:
    addi a0, a0, 1      # Add 1 to input
    ret

# ------------------------- Add One (JALR Target) -------------------------
add_one_jalr:
    addi a0, a0, 1      # Add 1 to input
    ret

# ------------------------- Binary Conversion Function -------------------------
convert_binary:
    mv t2, a0               # Use buffer address from a0
    li t0, 0
    li t1, 8                # Process 8 bits
cloop:
    lbu t3, (t2)
    beqz t3, cdone
    addi t2, t2, 1
    xori t3, t3, 0x30       # Convert '0'/'1' to 0/1
    slli t0, t0, 1
    or t0, t0, t3
    addi t1, t1, -1
    bnez t1, cloop
cdone:
    mv a0, t0
    ret

# ------------------------- Convert Function -------------------------
convert:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw t0, 8(sp)
    sw t1, 4(sp)
    sw t2, 0(sp)

    # Extract sign, exponent, and mantissa
    srli t0, a0, 7          # Sign bit (bit 7)
    andi t0, t0, 1          # t0 = sign (0 or 1)
    srli t1, a0, 4          # Exponent (bits 4-6)
    andi t1, t1, 0x7        # t1 = exponent (0 to 7)
    andi t2, a0, 0xF        # Mantissa (bits 0-3, lower 4 bits are 0)
    
    # Compute mantissa: 1 + (mantissa_bits / 16)
    li a0, 16               # Base for mantissa (2^4)
    mul t2, t2, a0         # Shift mantissa left by 4 (simulate 1.mantissa)
    addi t2, t2, 16        # Add implicit 1 (1.0 = 16 in fixed-point)
    
    # Adjust exponent: exponent - bias (bias = 3)
    addi t1, t1, -3        # t1 = exponent - 3
    
    # Compute value: mantissa * 2^exponent
    mv a0, t2
    mv t3, t1
    beqz t3, skip_shift     # Skip shift if exponent is 0
    bgtz t3, positive_shift
    neg t3, t3             # Make shift amount positive
    srl a0, a0, t3         # Right shift for negative exponent
    j apply_sign
positive_shift:
    sll a0, a0, t3         # Left shift for positive exponent
skip_shift:
apply_sign:
    # Apply sign
    beqz t0, pos
    neg a0, a0
pos:
    # Convert to integer (truncate toward zero)
    # Since we used fixed-point (mantissa * 16), divide by 16
    srai a0, a0, 4         # Divide by 16 to get integer part
    
    lw ra, 12(sp)
    lw t0, 8(sp)
    lw t1, 4(sp)
    lw t2, 0(sp)
    addi sp, sp, 16
    ret

# ------------------------- Read Binary Input -------------------------
read_binary_input:
    la a0, input_buf
    li a1, 5
    li a7, 8
    ecall

    la t0, input_buf
    li a0, 0
    li t2, 4
rbi_loop:
    lbu t1, 0(t0)
    beqz t1, rbi_fail
    li t4, 10
    beq t1, t4, rbi_fail
    li t3, 0x30
    blt t1, t3, rbi_fail
    li t3, 0x31
    bgt t1, t3, rbi_fail
    slli a0, a0, 1
    addi t1, t1, -0x30
    or a0, a0, t1
    addi t0, t0, 1
    addi t2, t2, -1
    bnez t2, rbi_loop
    andi a0, a0, 0xF
    li a1, 0
    ret
rbi_fail:
    li a1, 1
    ret

# ------------------------- Binary to String -------------------------
bin8_to_string:
    la t0, output_buf
    li t1, 8
    mv t2, a0
b2s_loop:
    srli t3, t2, 7
    andi t3, t3, 0x1
    addi t3, t3, 0x30
    sb t3, 0(t0)
    slli t2, t2, 1
    addi t0, t0, 1
    addi t1, t1, -1
    bnez t1, b2s_loop
    sb zero, 0(t0)
    ret

# ------------------------- CRC-4 Function -------------------------
crc4:
    andi a0, a0, 0xF
    slli a0, a0, 4
    li t0, 0x13
    li t1, 8
    li a1, 0
crc_loop:
    slli a1, a1, 1
    srli t2, a0, 7
    or a1, a1, t2
    slli a0, a0, 1
    andi a0, a0, 0xFF
    andi t2, a1, 0x10
    beqz t2, crc_skip
    xor a1, a1, t0
crc_skip:
    addi t1, t1, -1
    bnez t1, crc_loop
    andi a1, a1, 0xF
    ret

# ------------------------- Reverse Bits Function -------------------------
reverse_bits:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw t0, 8(sp)
    sw t1, 4(sp)
    sw t2, 0(sp)

    mv t0, a0
    li t1, 0
    li t2, 8
rev_loop:
    andi t3, t0, 0x1
    slli t1, t1, 1
    or t1, t1, t3
    srli t0, t0, 1
    addi t2, t2, -1
    bnez t2, rev_loop
    mv a0, t1

    lw ra, 12(sp)
    lw t0, 8(sp)
    lw t1, 4(sp)
    lw t2, 0(sp)
    addi sp, sp, 16
    ret

# ------------------------- Is Palindrome Function -------------------------
is_palindrome:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw t0, 8(sp)
    sw t1, 4(sp)
    sw a0, 0(sp)            # Save a0 to preserve across jal

    mv t0, a0
    jal reverse_bits
    mv t1, a0
    lw a0, 0(sp)            # Restore original a0
    beq t0, t1, pal_true
    li a0, 0
    j pal_exit
pal_true:
    li a0, 1
pal_exit:
    lw ra, 12(sp)
    lw t0, 8(sp)
    lw t1, 4(sp)
    addi sp, sp, 16
    ret

# ------------------------- Validate 8-bit Input -------------------------
validate_8bit_input:
    mv t0, a0               # Buffer address
    li a0, 0                # Result
    li t2, 8                # Process 8 bits
v8_loop:
    lbu t1, 0(t0)
    beqz t1, v8_fail        # Null terminator too early
    li t4, 10
    beq t1, t4, v8_done     # Newline means end of input
    li t3, 0x30
    blt t1, t3, v8_fail     # Less than '0'
    li t3, 0x31
    bgt t1, t3, v8_fail     # Greater than '1'
    addi t0, t0, 1
    addi t2, t2, -1
    bnez t2, v8_loop
v8_done:
    beqz t2, v8_success     # Exactly 8 bits processed
v8_fail:
    li a1, 1                # Invalid input
    ret
v8_success:
    li a1, 0                # Valid input
    ret

# ------------------------- Validate 20-bit Input -------------------------
validate_20bit_input:
    mv t0, a0               # Buffer address
    li a0, 0                # Result
    li t2, 20               # Process 20 bits
v20_loop:
    lbu t1, 0(t0)
    beqz t1, v20_fail       # Null terminator too early
    li t4, 10
    beq t1, t4, v20_done    # Newline means end of input
    li t3, 0x30
    blt t1, t3, v20_fail    # Less than '0'
    li t3, 0x31
    bgt t1, t3, v20_fail    # Greater than '1'
    addi t0, t0, 1
    addi t2, t2, -1
    bnez t2, v20_loop
v20_done:
    beqz t2, v20_success    # Exactly 20 bits processed
v20_fail:
    li a1, 1                # Invalid input
    ret
v20_success:
    li a1, 0                # Valid input
    ret

# ------------------------- Convert 20-bit Binary -------------------------
convert_20bit_binary:
    mv t2, a0               # Buffer address
    li t0, 0                # Result
    li t1, 20               # Process 20 bits
c20_loop:
    lbu t3, 0(t2)
    beqz t3, c20_done
    addi t2, t2, 1
    xori t3, t3, 0x30       # Convert '0'/'1' to 0/1
    slli t0, t0, 1
    or t0, t0, t3
    addi t1, t1, -1
    bnez t1, c20_loop
c20_done:
    mv a0, t0
    ret

# ------------------------- 32-bit Binary to Hex -------------------------
bin32_to_hex:
    la t0, hex_buf
    la t4, hex_digits
    li t1, 8                # Process 8 hex digits (32 bits)
    mv t2, a0               # Input number
b32h_loop:
    srli t3, t2, 28         # Get highest 4 bits
    andi t3, t3, 0xF
    add t5, t4, t3          # Get hex digit from hex_digits
    lbu t3, 0(t5)
    sb t3, 0(t0)            # Store hex digit
    slli t2, t2, 4          # Shift left by 4
    addi t0, t0, 1
    addi t1, t1, -1
    bnez t1, b32h_loop
    sb zero, 0(t0)          # Null terminate
    ret