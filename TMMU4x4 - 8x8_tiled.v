`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2025 06:47:13 PM
// Design Name: 
// Module Name: TMMU4x4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//---------------------------L2 IR related----------------------------//
module L2_IR_Mem(R_data, W_data, addr, clk, IR_rd, IR_wr);
    parameter address_size = 8;
    parameter word_size = 16;
    parameter memory_size = 32;
    output [word_size-1:0] R_data;
    input [word_size-1:0] W_data;
    input [address_size-1:0] addr;
    input clk, IR_rd, IR_wr;
    reg [word_size-1:0] memory [memory_size-1:0];
    
    // need new instruction set
    initial begin
        memory[0] = 16'b0000000000000000; // Load ISA
        memory[1] = 16'b0001000001001000; // Read L2 Host Memory
        memory[2] = 16'b0010000000000000; // TPU work
        memory[3] = 16'b0011000000000000; // Write L2 Host Memory
//        memory[4] = 16'b0001000001001000; // Read L2 Host Memory
//        memory[5] = 16'b0010000000000000; // TPU work
//        memory[6] = 16'b0011000000000000; // Write L2 Host Memory
    end
    
    always @(posedge clk) begin
        if (IR_wr) begin
            memory[addr] <= W_data;
        end
    end
    
    assign R_data = memory[addr];
    
endmodule

module L2_IR_counter(IR_addr, IR_inc, IR_clr, clk);
    parameter word_size = 8;
    output reg [word_size-1:0] IR_addr;
    input  IR_inc, IR_clr, clk;
    
    always@(posedge clk or posedge IR_clr) begin
        if(IR_clr==1) IR_addr <= 8'b0; 
        else if (IR_inc == 1) IR_addr <= IR_addr + 1;
    end
    
endmodule

//----------------------L2 Host Memory related----------------------//
module L2_Host_Memory_InstructionSet(R_data, W_data, addr, clk, IR_rd, IR_wr, finished_sig);
    parameter address_size = 8;
    parameter word_size = 16;
    parameter memory_size = 256;
    output reg [word_size-1:0] R_data;
    output reg finished_sig;
    input [word_size-1:0] W_data;
    input [address_size-1:0] addr;
    input clk, IR_rd, IR_wr;
    reg [word_size-1:0] memory [memory_size-1:0];
    
//    // 20250210 before modify L1_Accumulator
//    // Initialize memory with specific values at specific addresses
//    initial begin
//        memory[0] = 16'b0000000000000000; // Read Host Mem (Activation b1)
//        memory[1] = 16'b0001000000000000; // Read Weight (from Weight DDR3) (Weight b1)
//        memory[2] = 16'b0010000000000000; // Computation with itr = 0 (Compute once) 
//        memory[3] = 16'b0011000101100100; // Activation (MaxVal Normalization)
//        memory[4] = 16'b0100000000000000; // write back Host Mem
//        memory[5] = 16'b0000000000000000; // Read Host Mem (Activation b2)
//        memory[6] = 16'b0010000000000000; // Computation with itr = 0 (Compute once) 
//        memory[7] = 16'b0011000101100100; // Activation
//        memory[8] = 16'b0100000000000000; // write back Host Mem
//        memory[9] = 16'b0001000000000000; // Read Weight (from Weight DDR3) (Weight b2)
//        memory[10] = 16'b0000000000000000; // Read Host Mem (Activation b3)
//        memory[11] = 16'b0010000000000000; // Computation with itr = 0 (Compute once) 
//        memory[12] = 16'b0011000101100100; // Activation
//        memory[13] = 16'b0100000000000000; // write back Host Mem 
//        memory[14] = 16'b0000000000000000; // Read Host Mem (Activation b4)
//        memory[15] = 16'b0010000000000000; // Computation with itr = 0 (Compute once) 
//        memory[16] = 16'b0011000101100100; // Activation
//        memory[17] = 16'b0100000000000000; // write back Host Mem
        
//        //-------------still need to think how to load the values between W and A-------------//
//        memory[18] = 16'b0001000000000000; // Read Weight (from Weight DDR3) for block 3
//        memory[19] = 16'b0010000000000000; // Computation with itr = 0 (Compute once) 
//        memory[20] = 16'b0011000101100100; // Activation
//        memory[21] = 16'b0100000000000000; // write back Host Mem
//        memory[22] = 16'b0010000000000000; // Computation with itr = 0 (Compute once) 
//        memory[23] = 16'b0011000101100100; // Activation
//        memory[24] = 16'b0100000000000000; // write back Host Mem
//        memory[25] = 16'b0001000000000000; // Read Weight (from Weight DDR3) for block 4
//        memory[26] = 16'b0010000000000000; // Computation with itr = 0 (Compute once) 
//        memory[27] = 16'b0011000101100100; // Activation
//        memory[28] = 16'b0100000000000000; // write back Host Mem
//        memory[29] = 16'b0010000000000000; // Computation with itr = 0 (Compute once) 
//        memory[30] = 16'b0011000101100100; // Activation
//        memory[31] = 16'b0100000000000000; // write back Host Mem
//        memory[32] = 16'b1111111111111111; // END instruction
//    end

    // Initialize memory with specific values at specific addresses
    initial begin
        memory[0] = 16'b0000000000000000; // Read Host Mem (Activation b1)
        memory[1] = 16'b0001000000000000; // Read Weight (from Weight DDR3) (Weight b1)
        memory[2] = 16'b0010000000000000; // Computation with itr = 0 (Compute once) 
        memory[3] = 16'b0000000000000000; // Read Host Mem (Activation b2)
        memory[4] = 16'b0010000000000000; // Computation with itr = 0 (Compute once)
        memory[5] = 16'b0001000000000000; // Read Weight (from Weight DDR3) (Weight b2)
        memory[6] = 16'b0000000000000000; // Read Host Mem (Activation b3)
        memory[7] = 16'b0010000000000000; // Computation with itr = 0 (Compute once) 
        memory[8] = 16'b0000000000000000; // Read Host Mem (Activation b4)
        memory[9] = 16'b0010000000000000; // Computation with itr = 0 (Compute once) 
        memory[10] = 16'b0000000000000000; // Read Host Mem (Activation b1)
        memory[11] = 16'b0000000000000000; // Read Host Mem (Activation b2)
        memory[12] = 16'b0000000000000000; // Read Host Mem (Activation b3)
        memory[13] = 16'b0001000000000000; // Read Weight (from Weight DDR3) (Weight b3)
        memory[14] = 16'b0000000000000000; // Read Host Mem (Activation b4)
        memory[15] = 16'b0000000000000000; // Read Host Mem (Activation b1)
        memory[16] = 16'b0010000000000000; // Computation with itr = 0 (Compute once)
        memory[17] = 16'b0000000000000000; // Read Host Mem (Activation b2)
        memory[18] = 16'b0010000000000000; // Computation with itr = 0 (Compute once)
        memory[19] = 16'b0000000000000000; // Read Host Mem (Activation b3)
        memory[20] = 16'b0000000000000000; // Read Host Mem (Activation b4)
        memory[21] = 16'b0001000000000000; // Read Weight (from Weight DDR3) (Weight b4)
        memory[22] = 16'b0000000000000000; // Read Host Mem (Activation b1)
        memory[23] = 16'b0000000000000000; // Read Host Mem (Activation b2)
        memory[24] = 16'b0000000000000000; // Read Host Mem (Activation b3)
        memory[25] = 16'b0010000000000000; // Computation with itr = 0 (Compute once)
        memory[26] = 16'b0000000000000000; // Read Host Mem (Activation b4)
        memory[27] = 16'b0010000000000000; // Computation with itr = 0 (Compute once)
        memory[28] = 16'b0011000101100100; // Activation (MaxVal Normalization)
        memory[29] = 16'b0100000000000000; // write back Host Mem (1/4)
        memory[30] = 16'b0011000101100100; // Activation (MaxVal Normalization)
        memory[31] = 16'b0100000000000000; // write back Host Mem (2/4)
        memory[32] = 16'b0011000101100100; // Activation (MaxVal Normalization)
        memory[33] = 16'b0100000000000000; // write back Host Mem (3/4)
        memory[34] = 16'b0011000101100100; // Activation (MaxVal Normalization)
        memory[35] = 16'b0100000000000000; // write back Host Mem (4/4)
        memory[36] = 16'b1111111111111111; // END instruction
        
//        /see how many times...maybe need to be (4 * Activation + 1 * Write back Host Mem) * 4
        
        
    end
    
    always @(posedge clk) begin
        if (IR_wr) begin
            memory[addr] <= W_data;
        end 
        else if (IR_rd) begin
            if (memory[addr] != 16'b1111111111111111) begin
                R_data <= memory[addr];
                finished_sig <= 0;  // Keep reading while instructions are valid
            end else begin
                finished_sig <= 1;  // Stop reading when an END instruction is detected
            end
        end
    end
    
endmodule

module L2_Host_Memory_Weight(R_data1, R_data2, R_data3, R_data4, R_data5, R_data6, R_data7, R_data8,
    R_data9, R_data10, R_data11, R_data12, R_data13, R_data14, R_data15, R_data16, 
    W_data, addr, clk, rd, wr,
    L2HM_counter_rst);
    parameter address_size = 8;
    parameter word_size = 8;
    parameter memory_size = 256;
    output reg [word_size-1:0] R_data1, R_data2, R_data3, R_data4, R_data5, R_data6, R_data7, R_data8; // read data to Tiled Systolic Data Setup Unit
    output reg [word_size-1:0] R_data9, R_data10, R_data11, R_data12, R_data13, R_data14, R_data15, R_data16; // read data to Tiled Systolic Data Setup Unit
    input [word_size-1:0] W_data; // write data from L2_Accumulator
    input [address_size-1:0] addr; // [8:0]
    input clk, rd, wr;
    input L2HM_counter_rst; 
    reg [word_size-1:0] memory [memory_size-1:0];
    reg [word_size-1:0] rd_counter; // for propogating data purpose

    // Initialize memory with specific values at specific addresses
    initial begin
        memory[0] = 8'b00000000; // 0
        memory[1] = 8'b00000001; // 1
        memory[2] = 8'b00000010; // 2
        memory[3] = 8'b00000011; // 3
        memory[4] = 8'b00000100; // 4
        memory[5] = 8'b00000101; // 5
        memory[6] = 8'b00000110; // 6
        memory[7] = 8'b00000111; // 7
        memory[8] = 8'b00001000; // 8
        memory[9] = 8'b00001001; // 9
        memory[10] = 8'b00001010; // 10
        memory[11] = 8'b00001011; // 11
        memory[12] = 8'b00001100; // 12
        memory[13] = 8'b00001101; // 13
        memory[14] = 8'b00001110; // 14
        memory[15] = 8'b00001111; // 15
        memory[16] = 8'b00010000; // 16
        memory[17] = 8'b00010001; // 17
        memory[18] = 8'b00010010; // 18
        memory[19] = 8'b00010011; // 19
        memory[20] = 8'b00010100; // 20
        memory[21] = 8'b00010101; // 21
        memory[22] = 8'b00010110; // 22
        memory[23] = 8'b00010111; // 23
        memory[24] = 8'b00011000; // 24
        memory[25] = 8'b00011001; // 25
        memory[26] = 8'b00011010; // 26
        memory[27] = 8'b00011011; // 27
        memory[28] = 8'b00011100; // 28
        memory[29] = 8'b00011101; // 29
        memory[30] = 8'b00011110; // 30
        memory[31] = 8'b00011111; // 31
        memory[32] = 8'b00100000; // 32
        memory[33] = 8'b00100001; // 33
        memory[34] = 8'b00100010; // 34
        memory[35] = 8'b00100011; // 35
        memory[36] = 8'b00100100; // 36
        memory[37] = 8'b00100101; // 37
        memory[38] = 8'b00100110; // 38
        memory[39] = 8'b00100111; // 39
        memory[40] = 8'b00101000; // 40
        memory[41] = 8'b00101001; // 41
        memory[42] = 8'b00101010; // 42
        memory[43] = 8'b00101011; // 43
        memory[44] = 8'b00101100; // 44
        memory[45] = 8'b00101101; // 45
        memory[46] = 8'b00101110; // 46
        memory[47] = 8'b00101111; // 47
        memory[48] = 8'b00110000; // 48
        memory[49] = 8'b00110001; // 49
        memory[50] = 8'b00110010; // 50
        memory[51] = 8'b00110011; // 51
        memory[52] = 8'b00110100; // 52
        memory[53] = 8'b00110101; // 53
        memory[54] = 8'b00110110; // 54
        memory[55] = 8'b00110111; // 55
        memory[56] = 8'b00111000; // 56
        memory[57] = 8'b00111001; // 57
        memory[58] = 8'b00111010; // 58
        memory[59] = 8'b00111011; // 59
        memory[60] = 8'b00111100; // 60
        memory[61] = 8'b00111101; // 61
        memory[62] = 8'b00111110; // 62
        memory[63] = 8'b00111111; // 63
        memory[64] = 8'b01000000; // 64
        memory[65] = 8'b01000001; // 65
        memory[66] = 8'b01000010; // 66
        memory[67] = 8'b01000011; // 67
        memory[68] = 8'b01000100; // 68
        memory[69] = 8'b01000101; // 69
        memory[70] = 8'b01000110; // 70
        memory[71] = 8'b01000111; // 71
        memory[72] = 8'b01001000; // 72
        memory[73] = 8'b01001001; // 73
        memory[74] = 8'b01001010; // 74
        memory[75] = 8'b01001011; // 75
        memory[76] = 8'b01001100; // 76
        memory[77] = 8'b01001101; // 77
        memory[78] = 8'b01001110; // 78
        memory[79] = 8'b01001111; // 79
        memory[80] = 8'b01010000; // 80
        memory[81] = 8'b01010001; // 81
        memory[82] = 8'b01010010; // 82
        memory[83] = 8'b01010011; // 83
        memory[84] = 8'b01010100; // 84
        memory[85] = 8'b01010101; // 85
        memory[86] = 8'b01010110; // 86
        memory[87] = 8'b01010111; // 87
        memory[88] = 8'b01011000; // 88
        memory[89] = 8'b01011001; // 89
        memory[90] = 8'b01011010; // 90
        memory[91] = 8'b01011011; // 91
        memory[92] = 8'b01011100; // 92
        memory[93] = 8'b01011101; // 93
        memory[94] = 8'b01011110; // 94
        memory[95] = 8'b01011111; // 95
        memory[96]  = 8'b01100000; // 96
        memory[97]  = 8'b01100001; // 97
        memory[98]  = 8'b01100010; // 98
        memory[99]  = 8'b01100011; // 99
        memory[100] = 8'b01100100; // 100
        memory[101] = 8'b01100101; // 101
        memory[102] = 8'b01100110; // 102
        memory[103] = 8'b01100111; // 103
        memory[104] = 8'b01101000; // 104
        memory[105] = 8'b01101001; // 105
        memory[106] = 8'b01101010; // 106
        memory[107] = 8'b01101011; // 107
        memory[108] = 8'b01101100; // 108
        memory[109] = 8'b01101101; // 109
        memory[110] = 8'b01101110; // 110
        memory[111] = 8'b01101111; // 111
        memory[112] = 8'b01110000; // 112
        memory[113] = 8'b01110001; // 113
        memory[114] = 8'b01110010; // 114
        memory[115] = 8'b01110011; // 115
        memory[116] = 8'b01110100; // 116
        memory[117] = 8'b01110101; // 117
        memory[118] = 8'b01110110; // 118
        memory[119] = 8'b01110111; // 119
        memory[120] = 8'b01111000; // 120
        memory[121] = 8'b01111001; // 121
        memory[122] = 8'b01111010; // 122
        memory[123] = 8'b01111011; // 123
        memory[124] = 8'b01111100; // 124
        memory[125] = 8'b01111101; // 125
        memory[126] = 8'b01111110; // 126
        memory[127] = 8'b01111111; // 127
        memory[128] = 8'b10000000; // 128
        memory[129] = 8'b10000001; // 129
        memory[130] = 8'b10000010; // 130
        memory[131] = 8'b10000011; // 131
        memory[132] = 8'b10000100; // 132
        memory[133] = 8'b10000101; // 133
        memory[134] = 8'b10000110; // 134
        memory[135] = 8'b10000111; // 135
        memory[136] = 8'b10001000; // 136
        memory[137] = 8'b10001001; // 137
        memory[138] = 8'b10001010; // 138
        memory[139] = 8'b10001011; // 139
        memory[140] = 8'b10001100; // 140
        memory[141] = 8'b10001101; // 141
        memory[142] = 8'b10001110; // 142
        memory[143] = 8'b10001111; // 143
        memory[144] = 8'b10010000; // 144
        memory[145] = 8'b10010001; // 145
        memory[146] = 8'b10010010; // 146
        memory[147] = 8'b10010011; // 147
        memory[148] = 8'b10010100; // 148
        memory[149] = 8'b10010101; // 149
        memory[150] = 8'b10010110; // 150
        memory[151] = 8'b10010111; // 151
        memory[152] = 8'b10011000; // 152
        memory[153] = 8'b10011001; // 153
        memory[154] = 8'b10011010; // 154
        memory[155] = 8'b10011011; // 155
        memory[156] = 8'b10011100; // 156
        memory[157] = 8'b10011101; // 157
        memory[158] = 8'b10011110; // 158
        memory[159] = 8'b10011111; // 159
        memory[160] = 8'b10100000; // 160
        memory[161] = 8'b10100001; // 161
        memory[162] = 8'b10100010; // 162
        memory[163] = 8'b10100011; // 163
        memory[164] = 8'b10100100; // 164
        memory[165] = 8'b10100101; // 165
        memory[166] = 8'b10100110; // 166
        memory[167] = 8'b10100111; // 167
        memory[168] = 8'b10101000; // 168
        memory[169] = 8'b10101001; // 169
        memory[170] = 8'b10101010; // 170
        memory[171] = 8'b10101011; // 171
        memory[172] = 8'b10101100; // 172
        memory[173] = 8'b10101101; // 173
        memory[174] = 8'b10101110; // 174
        memory[175] = 8'b10101111; // 175
        memory[176] = 8'b10110000; // 176
        memory[177] = 8'b10110001; // 177
        memory[178] = 8'b10110010; // 178
        memory[179] = 8'b10110011; // 179
        memory[180] = 8'b10110100; // 180
        memory[181] = 8'b10110101; // 181
        memory[182] = 8'b10110110; // 182
        memory[183] = 8'b10110111; // 183
        memory[184] = 8'b10111000; // 184
        memory[185] = 8'b10111001; // 185
        memory[186] = 8'b10111010; // 186
        memory[187] = 8'b10111011; // 187
        memory[188] = 8'b10111100; // 188
        memory[189] = 8'b10111101; // 189
        memory[190] = 8'b10111110; // 190
        memory[191] = 8'b10111111; // 191
        memory[192] = 8'b11000000; // 192
        memory[193] = 8'b11000001; // 193
        memory[194] = 8'b11000010; // 194
        memory[195] = 8'b11000011; // 195
        memory[196] = 8'b11000100; // 196
        memory[197] = 8'b11000101; // 197
        memory[198] = 8'b11000110; // 198
        memory[199] = 8'b11000111; // 199
        memory[200] = 8'b11001000; // 200
        memory[201] = 8'b11001001; // 201
        memory[202] = 8'b11001010; // 202
        memory[203] = 8'b11001011; // 203
        memory[204] = 8'b11001100; // 204
        memory[205] = 8'b11001101; // 205
        memory[206] = 8'b11001110; // 206
        memory[207] = 8'b11001111; // 207
        memory[208] = 8'b11010000; // 208
        memory[209] = 8'b11010001; // 209
        memory[210] = 8'b11010010; // 210
        memory[211] = 8'b11010011; // 211
        memory[212] = 8'b11010100; // 212
        memory[213] = 8'b11010101; // 213
        memory[214] = 8'b11010110; // 214
        memory[215] = 8'b11010111; // 215
        memory[216] = 8'b11011000; // 216
        memory[217] = 8'b11011001; // 217
        memory[218] = 8'b11011010; // 218
        memory[219] = 8'b11011011; // 219
        memory[220] = 8'b11011100; // 220
        memory[221] = 8'b11011101; // 221
        memory[222] = 8'b11011110; // 222
        memory[223] = 8'b11011111; // 223
        memory[224] = 8'b11100000; // 224
        memory[225] = 8'b11100001; // 225
        memory[226] = 8'b11100010; // 226
        memory[227] = 8'b11100011; // 227
        memory[228] = 8'b11100100; // 228
        memory[229] = 8'b11100101; // 229
        memory[230] = 8'b11100110; // 230
        memory[231] = 8'b11100111; // 231
        memory[232] = 8'b11101000; // 232
        memory[233] = 8'b11101001; // 233
        memory[234] = 8'b11101010; // 234
        memory[235] = 8'b11101011; // 235
        memory[236] = 8'b11101100; // 236
        memory[237] = 8'b11101101; // 237
        memory[238] = 8'b11101110; // 238
        memory[239] = 8'b11101111; // 239
        memory[240] = 8'b11110000; // 240
        memory[241] = 8'b11110001; // 241
        memory[242] = 8'b11110010; // 242
        memory[243] = 8'b11110011; // 243
        memory[244] = 8'b11110100; // 244
        memory[245] = 8'b11110101; // 245
        memory[246] = 8'b11110110; // 246
        memory[247] = 8'b11110111; // 247
        memory[248] = 8'b11111000; // 248
        memory[249] = 8'b11111001; // 249
        memory[250] = 8'b11111010; // 250
        memory[251] = 8'b11111011; // 251
        memory[252] = 8'b11111100; // 252
        memory[253] = 8'b11111101; // 253
        memory[254] = 8'b11111110; // 254
        memory[255] = 8'b11111111; // 255
    end
    
    always @(posedge clk or posedge L2HM_counter_rst) begin
        if (L2HM_counter_rst) begin
            rd_counter <= 0; 
        end else if (rd) begin
            rd_counter <= rd_counter + 1;    
        end
    end
    
    // Write operation (triggered on clock edge)
    always @(posedge clk) begin
        if (wr) begin
            memory[addr] <= W_data; // Write data to memory at specified address
        end
    end

    always @(posedge clk) begin
        if (rd) begin
            case (rd_counter)
                0: begin
                    R_data1  <= memory[0];
                    R_data2  <= memory[1];
                    R_data3  <= memory[2];
                    R_data4  <= memory[3];
                    R_data5  <= memory[4];
                    R_data6  <= memory[5];
                    R_data7  <= memory[6];
                    R_data8  <= memory[7];
                    R_data9  <= memory[8];
                    R_data10 <= memory[9];
                    R_data11 <= memory[10];
                    R_data12 <= memory[11];
                    R_data13 <= memory[12];
                    R_data14 <= memory[13];
                    R_data15 <= memory[14];
                    R_data16 <= memory[15];                
                end
                1: begin
                    R_data1  <= memory[16];
                    R_data2  <= memory[17];
                    R_data3  <= memory[18];
                    R_data4  <= memory[19];
                    R_data5  <= memory[20];
                    R_data6  <= memory[21];
                    R_data7  <= memory[22];
                    R_data8  <= memory[23];
                    R_data9  <= memory[24];
                    R_data10 <= memory[25];
                    R_data11 <= memory[26];
                    R_data12 <= memory[27];
                    R_data13 <= memory[28];
                    R_data14 <= memory[29];
                    R_data15 <= memory[30];
                    R_data16 <= memory[31];                
                end
                2: begin
                    R_data1  <= memory[32];
                    R_data2  <= memory[33];
                    R_data3  <= memory[34];
                    R_data4  <= memory[35];
                    R_data5  <= memory[36];
                    R_data6  <= memory[37];
                    R_data7  <= memory[38];
                    R_data8  <= memory[39];
                    R_data9  <= memory[40];
                    R_data10 <= memory[41];
                    R_data11 <= memory[42];
                    R_data12 <= memory[43];
                    R_data13 <= memory[44];
                    R_data14 <= memory[45];
                    R_data15 <= memory[46];
                    R_data16 <= memory[47];               
                end
                3: begin
                    R_data1  <= memory[48];
                    R_data2  <= memory[49];
                    R_data3  <= memory[50];
                    R_data4  <= memory[51];
                    R_data5  <= memory[52];
                    R_data6  <= memory[53];
                    R_data7  <= memory[54];
                    R_data8  <= memory[55];
                    R_data9  <= memory[56];
                    R_data10 <= memory[57];
                    R_data11 <= memory[58];
                    R_data12 <= memory[59];
                    R_data13 <= memory[60];
                    R_data14 <= memory[61];
                    R_data15 <= memory[62];
                    R_data16 <= memory[63];                
                end
                4: begin
                    R_data1  <= memory[64];
                    R_data2  <= memory[65];
                    R_data3  <= memory[66];
                    R_data4  <= memory[67];
                    R_data5  <= memory[68];
                    R_data6  <= memory[69];
                    R_data7  <= memory[70];
                    R_data8  <= memory[71];
                    R_data9  <= memory[72];
                    R_data10 <= memory[73];
                    R_data11 <= memory[74];
                    R_data12 <= memory[75];
                    R_data13 <= memory[76];
                    R_data14 <= memory[77];
                    R_data15 <= memory[78];
                    R_data16 <= memory[79];                
                end
                5: begin
                    R_data1  <= memory[80];
                    R_data2  <= memory[81];
                    R_data3  <= memory[82];
                    R_data4  <= memory[83];
                    R_data5  <= memory[84];
                    R_data6  <= memory[85];
                    R_data7  <= memory[86];
                    R_data8  <= memory[87];
                    R_data9  <= memory[88];
                    R_data10 <= memory[89];
                    R_data11 <= memory[90];
                    R_data12 <= memory[91];
                    R_data13 <= memory[92];
                    R_data14 <= memory[93];
                    R_data15 <= memory[94];
                    R_data16 <= memory[95];                
                end
                6: begin
                    R_data1  <= memory[96];
                    R_data2  <= memory[97];
                    R_data3  <= memory[98];
                    R_data4  <= memory[99];
                    R_data5  <= memory[100];
                    R_data6  <= memory[101];
                    R_data7  <= memory[102];
                    R_data8  <= memory[103];
                    R_data9  <= memory[104];
                    R_data10 <= memory[105];
                    R_data11 <= memory[106];
                    R_data12 <= memory[107];
                    R_data13 <= memory[108];
                    R_data14 <= memory[109];
                    R_data15 <= memory[110];
                    R_data16 <= memory[111];                
                end
                7: begin
                    R_data1  <= memory[112];
                    R_data2  <= memory[113];
                    R_data3  <= memory[114];
                    R_data4  <= memory[115];
                    R_data5  <= memory[116];
                    R_data6  <= memory[117];
                    R_data7  <= memory[118];
                    R_data8  <= memory[119];
                    R_data9  <= memory[120];
                    R_data10 <= memory[121];
                    R_data11 <= memory[122];
                    R_data12 <= memory[123];
                    R_data13 <= memory[124];
                    R_data14 <= memory[125];
                    R_data15 <= memory[126];
                    R_data16 <= memory[127];                
                end
                8: begin
                    R_data1  <= memory[128];
                    R_data2  <= memory[129];
                    R_data3  <= memory[130];
                    R_data4  <= memory[131];
                    R_data5  <= memory[132];
                    R_data6  <= memory[133];
                    R_data7  <= memory[134];
                    R_data8  <= memory[135];
                    R_data9  <= memory[136];
                    R_data10 <= memory[137];
                    R_data11 <= memory[138];
                    R_data12 <= memory[139];
                    R_data13 <= memory[140];
                    R_data14 <= memory[141];
                    R_data15 <= memory[142];
                    R_data16 <= memory[143];                
                end
                9: begin
                    R_data1  <= memory[144];
                    R_data2  <= memory[145];
                    R_data3  <= memory[146];
                    R_data4  <= memory[147];
                    R_data5  <= memory[148];
                    R_data6  <= memory[149];
                    R_data7  <= memory[150];
                    R_data8  <= memory[151];
                    R_data9  <= memory[152];
                    R_data10 <= memory[153];
                    R_data11 <= memory[154];
                    R_data12 <= memory[155];
                    R_data13 <= memory[156];
                    R_data14 <= memory[157];
                    R_data15 <= memory[158];
                    R_data16 <= memory[159];                
                end
                10: begin
                    R_data1  <= memory[160];
                    R_data2  <= memory[161];
                    R_data3  <= memory[162];
                    R_data4  <= memory[163];
                    R_data5  <= memory[164];
                    R_data6  <= memory[165];
                    R_data7  <= memory[166];
                    R_data8  <= memory[167];
                    R_data9  <= memory[168];
                    R_data10 <= memory[169];
                    R_data11 <= memory[170];
                    R_data12 <= memory[171];
                    R_data13 <= memory[172];
                    R_data14 <= memory[173];
                    R_data15 <= memory[174];
                    R_data16 <= memory[175];                
                end
                11: begin
                    R_data1  <= memory[176];
                    R_data2  <= memory[177];
                    R_data3  <= memory[178];
                    R_data4  <= memory[179];
                    R_data5  <= memory[180];
                    R_data6  <= memory[181];
                    R_data7  <= memory[182];
                    R_data8  <= memory[183];
                    R_data9  <= memory[184];
                    R_data10 <= memory[185];
                    R_data11 <= memory[186];
                    R_data12 <= memory[187];
                    R_data13 <= memory[188];
                    R_data14 <= memory[189];
                    R_data15 <= memory[190];
                    R_data16 <= memory[191];                
                end
                12: begin
                    R_data1  <= memory[192];
                    R_data2  <= memory[193];
                    R_data3  <= memory[194];
                    R_data4  <= memory[195];
                    R_data5  <= memory[196];
                    R_data6  <= memory[197];
                    R_data7  <= memory[198];
                    R_data8  <= memory[199];
                    R_data9  <= memory[200];
                    R_data10 <= memory[201];
                    R_data11 <= memory[202];
                    R_data12 <= memory[203];
                    R_data13 <= memory[204];
                    R_data14 <= memory[205];
                    R_data15 <= memory[206];
                    R_data16 <= memory[207];                
                end
                13: begin
                    R_data1  <= memory[208];
                    R_data2  <= memory[209];
                    R_data3  <= memory[210];
                    R_data4  <= memory[211];
                    R_data5  <= memory[212];
                    R_data6  <= memory[213];
                    R_data7  <= memory[214];
                    R_data8  <= memory[215];
                    R_data9  <= memory[216];
                    R_data10 <= memory[217];
                    R_data11 <= memory[218];
                    R_data12 <= memory[219];
                    R_data13 <= memory[220];
                    R_data14 <= memory[221];
                    R_data15 <= memory[222];
                    R_data16 <= memory[223];                
                end
                14: begin
                    R_data1  <= memory[224];
                    R_data2  <= memory[225];
                    R_data3  <= memory[226];
                    R_data4  <= memory[227];
                    R_data5  <= memory[228];
                    R_data6  <= memory[229];
                    R_data7  <= memory[230];
                    R_data8  <= memory[231];
                    R_data9  <= memory[232];
                    R_data10 <= memory[233];
                    R_data11 <= memory[234];
                    R_data12 <= memory[235];
                    R_data13 <= memory[236];
                    R_data14 <= memory[237];
                    R_data15 <= memory[238];
                    R_data16 <= memory[239];               
                end
                15: begin
                    R_data1  <= memory[240];
                    R_data2  <= memory[241];
                    R_data3  <= memory[242];
                    R_data4  <= memory[243];
                    R_data5  <= memory[244];
                    R_data6  <= memory[245];
                    R_data7  <= memory[246];
                    R_data8  <= memory[247];
                    R_data9  <= memory[248];
                    R_data10 <= memory[249];
                    R_data11 <= memory[250];
                    R_data12 <= memory[251];
                    R_data13 <= memory[252];
                    R_data14 <= memory[253];
                    R_data15 <= memory[254];
                    R_data16 <= memory[255];               
                end
                default: ; // no operation
            endcase
        end
    end

endmodule

module L2_Host_Memory_Activation(R_data1, R_data2, R_data3, R_data4, R_data5, R_data6, R_data7, R_data8,
    R_data9, R_data10, R_data11, R_data12, R_data13, R_data14, R_data15, R_data16, 
    W_data1, W_data2, W_data3, W_data4, W_data5, W_data6, W_data7, W_data8, 
    W_data9, W_data10, W_data11, W_data12, W_data13, W_data14, W_data15, W_data16,  
    addr, clk, rd, wr,
    L2HM_rd_counter_rst, L2HM_wr_counter_rst);
    parameter address_size = 8;
    parameter word_size = 8;
    parameter memory_size = 256;
    output reg [word_size-1:0] R_data1, R_data2, R_data3, R_data4, R_data5, R_data6, R_data7, R_data8; // read data to Tiled Systolic Data Setup Unit
    output reg [word_size-1:0] R_data9, R_data10, R_data11, R_data12, R_data13, R_data14, R_data15, R_data16; // read data to Tiled Systolic Data Setup Unit
    input [word_size-1:0] W_data1, W_data2, W_data3, W_data4, W_data5, W_data6, W_data7, W_data8; // write data from L2_Accumulator
    input [word_size-1:0] W_data9, W_data10, W_data11, W_data12, W_data13, W_data14, W_data15, W_data16; // write data from L2_Accumulator
    input [address_size-1:0] addr; // [8:0], probably for bigger hierarchy(L3)
    input clk, rd, wr;
    input L2HM_rd_counter_rst, L2HM_wr_counter_rst; 
    reg [word_size-1:0] memory [memory_size-1:0];
    reg [word_size-1:0] rd_counter; // for propogating data purpose
    reg [word_size-1:0] wr_counter; // for propogating data purpose

    // Initialize memory with specific values at specific addresses
    initial begin
        memory[0] = 8'b00000000; // 0
        memory[1] = 8'b00000001; // 1
        memory[2] = 8'b00000010; // 2
        memory[3] = 8'b00000011; // 3
        memory[4] = 8'b00000100; // 4
        memory[5] = 8'b00000101; // 5
        memory[6] = 8'b00000110; // 6
        memory[7] = 8'b00000111; // 7
        memory[8] = 8'b00001000; // 8
        memory[9] = 8'b00001001; // 9
        memory[10] = 8'b00001010; // 10
        memory[11] = 8'b00001011; // 11
        memory[12] = 8'b00001100; // 12
        memory[13] = 8'b00001101; // 13
        memory[14] = 8'b00001110; // 14
        memory[15] = 8'b00001111; // 15
        memory[16] = 8'b00010000; // 16
        memory[17] = 8'b00010001; // 17
        memory[18] = 8'b00010010; // 18
        memory[19] = 8'b00010011; // 19
        memory[20] = 8'b00010100; // 20
        memory[21] = 8'b00010101; // 21
        memory[22] = 8'b00010110; // 22
        memory[23] = 8'b00010111; // 23
        memory[24] = 8'b00011000; // 24
        memory[25] = 8'b00011001; // 25
        memory[26] = 8'b00011010; // 26
        memory[27] = 8'b00011011; // 27
        memory[28] = 8'b00011100; // 28
        memory[29] = 8'b00011101; // 29
        memory[30] = 8'b00011110; // 30
        memory[31] = 8'b00011111; // 31
        memory[32] = 8'b00100000; // 32
        memory[33] = 8'b00100001; // 33
        memory[34] = 8'b00100010; // 34
        memory[35] = 8'b00100011; // 35
        memory[36] = 8'b00100100; // 36
        memory[37] = 8'b00100101; // 37
        memory[38] = 8'b00100110; // 38
        memory[39] = 8'b00100111; // 39
        memory[40] = 8'b00101000; // 40
        memory[41] = 8'b00101001; // 41
        memory[42] = 8'b00101010; // 42
        memory[43] = 8'b00101011; // 43
        memory[44] = 8'b00101100; // 44
        memory[45] = 8'b00101101; // 45
        memory[46] = 8'b00101110; // 46
        memory[47] = 8'b00101111; // 47
        memory[48] = 8'b00110000; // 48
        memory[49] = 8'b00110001; // 49
        memory[50] = 8'b00110010; // 50
        memory[51] = 8'b00110011; // 51
        memory[52] = 8'b00110100; // 52
        memory[53] = 8'b00110101; // 53
        memory[54] = 8'b00110110; // 54
        memory[55] = 8'b00110111; // 55
        memory[56] = 8'b00111000; // 56
        memory[57] = 8'b00111001; // 57
        memory[58] = 8'b00111010; // 58
        memory[59] = 8'b00111011; // 59
        memory[60] = 8'b00111100; // 60
        memory[61] = 8'b00111101; // 61
        memory[62] = 8'b00111110; // 62
        memory[63] = 8'b00111111; // 63
        memory[64] = 8'b01000000; // 64
        memory[65] = 8'b01000001; // 65
        memory[66] = 8'b01000010; // 66
        memory[67] = 8'b01000011; // 67
        memory[68] = 8'b01000100; // 68
        memory[69] = 8'b01000101; // 69
        memory[70] = 8'b01000110; // 70
        memory[71] = 8'b01000111; // 71
        memory[72] = 8'b01001000; // 72
        memory[73] = 8'b01001001; // 73
        memory[74] = 8'b01001010; // 74
        memory[75] = 8'b01001011; // 75
        memory[76] = 8'b01001100; // 76
        memory[77] = 8'b01001101; // 77
        memory[78] = 8'b01001110; // 78
        memory[79] = 8'b01001111; // 79
        memory[80] = 8'b01010000; // 80
        memory[81] = 8'b01010001; // 81
        memory[82] = 8'b01010010; // 82
        memory[83] = 8'b01010011; // 83
        memory[84] = 8'b01010100; // 84
        memory[85] = 8'b01010101; // 85
        memory[86] = 8'b01010110; // 86
        memory[87] = 8'b01010111; // 87
        memory[88] = 8'b01011000; // 88
        memory[89] = 8'b01011001; // 89
        memory[90] = 8'b01011010; // 90
        memory[91] = 8'b01011011; // 91
        memory[92] = 8'b01011100; // 92
        memory[93] = 8'b01011101; // 93
        memory[94] = 8'b01011110; // 94
        memory[95] = 8'b01011111; // 95
        memory[96]  = 8'b01100000; // 96
        memory[97]  = 8'b01100001; // 97
        memory[98]  = 8'b01100010; // 98
        memory[99]  = 8'b01100011; // 99
        memory[100] = 8'b01100100; // 100
        memory[101] = 8'b01100101; // 101
        memory[102] = 8'b01100110; // 102
        memory[103] = 8'b01100111; // 103
        memory[104] = 8'b01101000; // 104
        memory[105] = 8'b01101001; // 105
        memory[106] = 8'b01101010; // 106
        memory[107] = 8'b01101011; // 107
        memory[108] = 8'b01101100; // 108
        memory[109] = 8'b01101101; // 109
        memory[110] = 8'b01101110; // 110
        memory[111] = 8'b01101111; // 111
        memory[112] = 8'b01110000; // 112
        memory[113] = 8'b01110001; // 113
        memory[114] = 8'b01110010; // 114
        memory[115] = 8'b01110011; // 115
        memory[116] = 8'b01110100; // 116
        memory[117] = 8'b01110101; // 117
        memory[118] = 8'b01110110; // 118
        memory[119] = 8'b01110111; // 119
        memory[120] = 8'b01111000; // 120
        memory[121] = 8'b01111001; // 121
        memory[122] = 8'b01111010; // 122
        memory[123] = 8'b01111011; // 123
        memory[124] = 8'b01111100; // 124
        memory[125] = 8'b01111101; // 125
        memory[126] = 8'b01111110; // 126
        memory[127] = 8'b01111111; // 127
        memory[128] = 8'b10000000; // 128
        memory[129] = 8'b10000001; // 129
        memory[130] = 8'b10000010; // 130
        memory[131] = 8'b10000011; // 131
        memory[132] = 8'b10000100; // 132
        memory[133] = 8'b10000101; // 133
        memory[134] = 8'b10000110; // 134
        memory[135] = 8'b10000111; // 135
        memory[136] = 8'b10001000; // 136
        memory[137] = 8'b10001001; // 137
        memory[138] = 8'b10001010; // 138
        memory[139] = 8'b10001011; // 139
        memory[140] = 8'b10001100; // 140
        memory[141] = 8'b10001101; // 141
        memory[142] = 8'b10001110; // 142
        memory[143] = 8'b10001111; // 143
        memory[144] = 8'b10010000; // 144
        memory[145] = 8'b10010001; // 145
        memory[146] = 8'b10010010; // 146
        memory[147] = 8'b10010011; // 147
        memory[148] = 8'b10010100; // 148
        memory[149] = 8'b10010101; // 149
        memory[150] = 8'b10010110; // 150
        memory[151] = 8'b10010111; // 151
        memory[152] = 8'b10011000; // 152
        memory[153] = 8'b10011001; // 153
        memory[154] = 8'b10011010; // 154
        memory[155] = 8'b10011011; // 155
        memory[156] = 8'b10011100; // 156
        memory[157] = 8'b10011101; // 157
        memory[158] = 8'b10011110; // 158
        memory[159] = 8'b10011111; // 159
        memory[160] = 8'b10100000; // 160
        memory[161] = 8'b10100001; // 161
        memory[162] = 8'b10100010; // 162
        memory[163] = 8'b10100011; // 163
        memory[164] = 8'b10100100; // 164
        memory[165] = 8'b10100101; // 165
        memory[166] = 8'b10100110; // 166
        memory[167] = 8'b10100111; // 167
        memory[168] = 8'b10101000; // 168
        memory[169] = 8'b10101001; // 169
        memory[170] = 8'b10101010; // 170
        memory[171] = 8'b10101011; // 171
        memory[172] = 8'b10101100; // 172
        memory[173] = 8'b10101101; // 173
        memory[174] = 8'b10101110; // 174
        memory[175] = 8'b10101111; // 175
        memory[176] = 8'b10110000; // 176
        memory[177] = 8'b10110001; // 177
        memory[178] = 8'b10110010; // 178
        memory[179] = 8'b10110011; // 179
        memory[180] = 8'b10110100; // 180
        memory[181] = 8'b10110101; // 181
        memory[182] = 8'b10110110; // 182
        memory[183] = 8'b10110111; // 183
        memory[184] = 8'b10111000; // 184
        memory[185] = 8'b10111001; // 185
        memory[186] = 8'b10111010; // 186
        memory[187] = 8'b10111011; // 187
        memory[188] = 8'b10111100; // 188
        memory[189] = 8'b10111101; // 189
        memory[190] = 8'b10111110; // 190
        memory[191] = 8'b10111111; // 191
        memory[192] = 8'b11000000; // 192
        memory[193] = 8'b11000001; // 193
        memory[194] = 8'b11000010; // 194
        memory[195] = 8'b11000011; // 195
        memory[196] = 8'b11000100; // 196
        memory[197] = 8'b11000101; // 197
        memory[198] = 8'b11000110; // 198
        memory[199] = 8'b11000111; // 199
        memory[200] = 8'b11001000; // 200
        memory[201] = 8'b11001001; // 201
        memory[202] = 8'b11001010; // 202
        memory[203] = 8'b11001011; // 203
        memory[204] = 8'b11001100; // 204
        memory[205] = 8'b11001101; // 205
        memory[206] = 8'b11001110; // 206
        memory[207] = 8'b11001111; // 207
        memory[208] = 8'b11010000; // 208
        memory[209] = 8'b11010001; // 209
        memory[210] = 8'b11010010; // 210
        memory[211] = 8'b11010011; // 211
        memory[212] = 8'b11010100; // 212
        memory[213] = 8'b11010101; // 213
        memory[214] = 8'b11010110; // 214
        memory[215] = 8'b11010111; // 215
        memory[216] = 8'b11011000; // 216
        memory[217] = 8'b11011001; // 217
        memory[218] = 8'b11011010; // 218
        memory[219] = 8'b11011011; // 219
        memory[220] = 8'b11011100; // 220
        memory[221] = 8'b11011101; // 221
        memory[222] = 8'b11011110; // 222
        memory[223] = 8'b11011111; // 223
        memory[224] = 8'b11100000; // 224
        memory[225] = 8'b11100001; // 225
        memory[226] = 8'b11100010; // 226
        memory[227] = 8'b11100011; // 227
        memory[228] = 8'b11100100; // 228
        memory[229] = 8'b11100101; // 229
        memory[230] = 8'b11100110; // 230
        memory[231] = 8'b11100111; // 231
        memory[232] = 8'b11101000; // 232
        memory[233] = 8'b11101001; // 233
        memory[234] = 8'b11101010; // 234
        memory[235] = 8'b11101011; // 235
        memory[236] = 8'b11101100; // 236
        memory[237] = 8'b11101101; // 237
        memory[238] = 8'b11101110; // 238
        memory[239] = 8'b11101111; // 239
        memory[240] = 8'b11110000; // 240
        memory[241] = 8'b11110001; // 241
        memory[242] = 8'b11110010; // 242
        memory[243] = 8'b11110011; // 243
        memory[244] = 8'b11110100; // 244
        memory[245] = 8'b11110101; // 245
        memory[246] = 8'b11110110; // 246
        memory[247] = 8'b11110111; // 247
        memory[248] = 8'b11111000; // 248
        memory[249] = 8'b11111001; // 249
        memory[250] = 8'b11111010; // 250
        memory[251] = 8'b11111011; // 251
        memory[252] = 8'b11111100; // 252
        memory[253] = 8'b11111101; // 253
        memory[254] = 8'b11111110; // 254
        memory[255] = 8'b11111111; // 255
    end
    
    always @(posedge clk or posedge L2HM_rd_counter_rst) begin
      if (L2HM_rd_counter_rst) begin
        rd_counter <= 0;
      end else if (rd) begin
        rd_counter <= rd_counter + 1;
        end
    end   
    
    always @(posedge clk or posedge L2HM_wr_counter_rst) begin
      if (L2HM_wr_counter_rst) begin
        wr_counter <= 0;
      end else if (wr) begin
        wr_counter <= wr_counter + 1;
        end
    end    
    
//    always @(posedge clk or posedge L2HM_rd_counter_rst or posedge L2HM_wr_counter_rst) begin
//        if (L2HM_rd_counter_rst) begin
//            rd_counter <= 0;
//        end else if (L2HM_wr_counter_rst) begin
//            wr_counter <= 0;
//        end else if (rd) begin
//            rd_counter <= rd_counter + 1;    
//        end else if (wr) begin
//            wr_counter <= wr_counter + 1;    
//        end 
//    end
    
    // Write operation (triggered on clock edge)
    always @(posedge clk) begin
        if (wr) begin
            case (wr_counter)
                0: begin
                    memory[0]  <= W_data1;
                    memory[1]  <= W_data2;
                    memory[2]  <= W_data3;
                    memory[3]  <= W_data4;
                    memory[4]  <= W_data5;
                    memory[5]  <= W_data6;
                    memory[6]  <= W_data7;
                    memory[7]  <= W_data8;
                    memory[8]  <= W_data9;
                    memory[9]  <= W_data10;
                    memory[10] <= W_data11;
                    memory[11] <= W_data12;
                    memory[12] <= W_data13;
                    memory[13] <= W_data14;
                    memory[14] <= W_data15;
                    memory[15] <= W_data16;                
                end
                1: begin
                    memory[16]  <= W_data1; 
                    memory[17]  <= W_data2; 
                    memory[18]  <= W_data3; 
                    memory[19]  <= W_data4; 
                    memory[20]  <= W_data5; 
                    memory[21]  <= W_data6; 
                    memory[22]  <= W_data7; 
                    memory[23]  <= W_data8; 
                    memory[24]  <= W_data9; 
                    memory[25]  <= W_data10; 
                    memory[26]  <= W_data11; 
                    memory[27]  <= W_data12; 
                    memory[28]  <= W_data13; 
                    memory[29]  <= W_data14; 
                    memory[30]  <= W_data15; 
                    memory[31]  <= W_data16;                
                end
                2: begin
                    memory[32]  <= W_data1;  
                    memory[33]  <= W_data2;  
                    memory[34]  <= W_data3;  
                    memory[35]  <= W_data4;  
                    memory[36]  <= W_data5;  
                    memory[37]  <= W_data6;  
                    memory[38]  <= W_data7;  
                    memory[39]  <= W_data8;  
                    memory[40]  <= W_data9;  
                    memory[41]  <= W_data10; 
                    memory[42]  <= W_data11; 
                    memory[43]  <= W_data12; 
                    memory[44]  <= W_data13; 
                    memory[45]  <= W_data14; 
                    memory[46]  <= W_data15; 
                    memory[47]  <= W_data16;               
                end
                3: begin
                    memory[48]  <= W_data1;  
                    memory[49]  <= W_data2;  
                    memory[50]  <= W_data3;  
                    memory[51]  <= W_data4;  
                    memory[52]  <= W_data5;  
                    memory[53]  <= W_data6;  
                    memory[54]  <= W_data7;  
                    memory[55]  <= W_data8;  
                    memory[56]  <= W_data9;  
                    memory[57]  <= W_data10; 
                    memory[58]  <= W_data11; 
                    memory[59]  <= W_data12; 
                    memory[60]  <= W_data13; 
                    memory[61]  <= W_data14; 
                    memory[62]  <= W_data15; 
                    memory[63]  <= W_data16;               
                end
                4: begin
                    memory[64]  <= W_data1;  
                    memory[65]  <= W_data2;  
                    memory[66]  <= W_data3;  
                    memory[67]  <= W_data4;  
                    memory[68]  <= W_data5;  
                    memory[69]  <= W_data6;  
                    memory[70]  <= W_data7;  
                    memory[71]  <= W_data8;  
                    memory[72]  <= W_data9;  
                    memory[73]  <= W_data10; 
                    memory[74]  <= W_data11; 
                    memory[75]  <= W_data12; 
                    memory[76]  <= W_data13; 
                    memory[77]  <= W_data14; 
                    memory[78]  <= W_data15; 
                    memory[79]  <= W_data16;               
                end
                5: begin
                    memory[80]  <= W_data1;  
                    memory[81]  <= W_data2;  
                    memory[82]  <= W_data3;  
                    memory[83]  <= W_data4;  
                    memory[84]  <= W_data5;  
                    memory[85]  <= W_data6;  
                    memory[86]  <= W_data7;  
                    memory[87]  <= W_data8;  
                    memory[88]  <= W_data9;  
                    memory[89]  <= W_data10; 
                    memory[90]  <= W_data11; 
                    memory[91]  <= W_data12; 
                    memory[92]  <= W_data13; 
                    memory[93]  <= W_data14; 
                    memory[94]  <= W_data15; 
                    memory[95]  <= W_data16;                
                end
                6: begin
                    memory[96]   <= W_data1;  
                    memory[97]   <= W_data2;  
                    memory[98]   <= W_data3;  
                    memory[99]   <= W_data4;  
                    memory[100]  <= W_data5;  
                    memory[101]  <= W_data6;  
                    memory[102]  <= W_data7;  
                    memory[103]  <= W_data8;  
                    memory[104]  <= W_data9;  
                    memory[105]  <= W_data10; 
                    memory[106]  <= W_data11; 
                    memory[107]  <= W_data12; 
                    memory[108]  <= W_data13; 
                    memory[109]  <= W_data14; 
                    memory[110]  <= W_data15; 
                    memory[111]  <= W_data16;                
                end
                7: begin
                    memory[112]  <= W_data1;  
                    memory[113]  <= W_data2;  
                    memory[114]  <= W_data3;  
                    memory[115]  <= W_data4;  
                    memory[116]  <= W_data5;  
                    memory[117]  <= W_data6;  
                    memory[118]  <= W_data7;  
                    memory[119]  <= W_data8;  
                    memory[120]  <= W_data9;  
                    memory[121]  <= W_data10; 
                    memory[122]  <= W_data11; 
                    memory[123]  <= W_data12; 
                    memory[124]  <= W_data13; 
                    memory[125]  <= W_data14; 
                    memory[126]  <= W_data15; 
                    memory[127]  <= W_data16;                
                end
                8: begin
                    memory[128]  <= W_data1;  
                    memory[129]  <= W_data2;  
                    memory[130]  <= W_data3;  
                    memory[131]  <= W_data4;  
                    memory[132]  <= W_data5;  
                    memory[133]  <= W_data6;  
                    memory[134]  <= W_data7;  
                    memory[135]  <= W_data8;  
                    memory[136]  <= W_data9;  
                    memory[137]  <= W_data10; 
                    memory[138]  <= W_data11; 
                    memory[139]  <= W_data12; 
                    memory[140]  <= W_data13; 
                    memory[141]  <= W_data14; 
                    memory[142]  <= W_data15; 
                    memory[143]  <= W_data16;                 
                end
                9: begin
                    memory[144]  <= W_data1;  
                    memory[145]  <= W_data2;  
                    memory[146]  <= W_data3;  
                    memory[147]  <= W_data4;  
                    memory[148]  <= W_data5;  
                    memory[149]  <= W_data6;  
                    memory[150]  <= W_data7;  
                    memory[151]  <= W_data8;  
                    memory[152]  <= W_data9;  
                    memory[153]  <= W_data10; 
                    memory[154]  <= W_data11; 
                    memory[155]  <= W_data12; 
                    memory[156]  <= W_data13; 
                    memory[157]  <= W_data14; 
                    memory[158]  <= W_data15; 
                    memory[159]  <= W_data16;                 
                end
                10: begin
                    memory[160]  <= W_data1;  
                    memory[161]  <= W_data2;  
                    memory[162]  <= W_data3;  
                    memory[163]  <= W_data4;  
                    memory[164]  <= W_data5;  
                    memory[165]  <= W_data6;  
                    memory[166]  <= W_data7;  
                    memory[167]  <= W_data8;  
                    memory[168]  <= W_data9;  
                    memory[169]  <= W_data10; 
                    memory[170]  <= W_data11; 
                    memory[171]  <= W_data12; 
                    memory[172]  <= W_data13; 
                    memory[173]  <= W_data14; 
                    memory[174]  <= W_data15; 
                    memory[175]  <= W_data16;                
                end
                11: begin
                    memory[176]  <= W_data1;  
                    memory[177]  <= W_data2;  
                    memory[178]  <= W_data3;  
                    memory[179]  <= W_data4;  
                    memory[180]  <= W_data5;  
                    memory[181]  <= W_data6;  
                    memory[182]  <= W_data7;  
                    memory[183]  <= W_data8;  
                    memory[184]  <= W_data9;  
                    memory[185]  <= W_data10; 
                    memory[186]  <= W_data11; 
                    memory[187]  <= W_data12; 
                    memory[188]  <= W_data13; 
                    memory[189]  <= W_data14; 
                    memory[190]  <= W_data15; 
                    memory[191]  <= W_data16;                
                end
                12: begin
                    memory[192]  <= W_data1;  
                    memory[193]  <= W_data2;  
                    memory[194]  <= W_data3;  
                    memory[195]  <= W_data4;  
                    memory[196]  <= W_data5;  
                    memory[197]  <= W_data6;  
                    memory[198]  <= W_data7;  
                    memory[199]  <= W_data8;  
                    memory[200]  <= W_data9;  
                    memory[201]  <= W_data10; 
                    memory[202]  <= W_data11; 
                    memory[203]  <= W_data12; 
                    memory[204]  <= W_data13; 
                    memory[205]  <= W_data14; 
                    memory[206]  <= W_data15; 
                    memory[207]  <= W_data16;                 
                end
                13: begin
                    memory[208]  <= W_data1;  
                    memory[209]  <= W_data2;  
                    memory[210]  <= W_data3;  
                    memory[211]  <= W_data4;  
                    memory[212]  <= W_data5;  
                    memory[213]  <= W_data6;  
                    memory[214]  <= W_data7;  
                    memory[215]  <= W_data8;  
                    memory[216]  <= W_data9;  
                    memory[217]  <= W_data10; 
                    memory[218]  <= W_data11; 
                    memory[219]  <= W_data12; 
                    memory[220]  <= W_data13; 
                    memory[221]  <= W_data14; 
                    memory[222]  <= W_data15; 
                    memory[223]  <= W_data16;                 
                end
                14: begin
                    memory[224]  <= W_data1;  
                    memory[225]  <= W_data2;  
                    memory[226]  <= W_data3;  
                    memory[227]  <= W_data4;  
                    memory[228]  <= W_data5;  
                    memory[229]  <= W_data6;  
                    memory[230]  <= W_data7;  
                    memory[231]  <= W_data8;  
                    memory[232]  <= W_data9;  
                    memory[233]  <= W_data10; 
                    memory[234]  <= W_data11; 
                    memory[235]  <= W_data12; 
                    memory[236]  <= W_data13; 
                    memory[237]  <= W_data14; 
                    memory[238]  <= W_data15; 
                    memory[239]  <= W_data16;             
                end
                15: begin
                    memory[240]  <= W_data1;  
                    memory[241]  <= W_data2;  
                    memory[242]  <= W_data3;  
                    memory[243]  <= W_data4;  
                    memory[244]  <= W_data5;  
                    memory[245]  <= W_data6;  
                    memory[246]  <= W_data7;  
                    memory[247]  <= W_data8;  
                    memory[248]  <= W_data9;  
                    memory[249]  <= W_data10; 
                    memory[250]  <= W_data11; 
                    memory[251]  <= W_data12; 
                    memory[252]  <= W_data13; 
                    memory[253]  <= W_data14; 
                    memory[254]  <= W_data15; 
                    memory[255]  <= W_data16;             
                end
                default: ; // no operation
            endcase
        end
    end

    always @(posedge clk) begin
        if (rd) begin
            case (rd_counter)
                0: begin
                    R_data1  <= memory[0];
                    R_data2  <= memory[1];
                    R_data3  <= memory[2];
                    R_data4  <= memory[3];
                    R_data5  <= memory[4];
                    R_data6  <= memory[5];
                    R_data7  <= memory[6];
                    R_data8  <= memory[7];
                    R_data9  <= memory[8];
                    R_data10 <= memory[9];
                    R_data11 <= memory[10];
                    R_data12 <= memory[11];
                    R_data13 <= memory[12];
                    R_data14 <= memory[13];
                    R_data15 <= memory[14];
                    R_data16 <= memory[15];                
                end
                1: begin
                    R_data1  <= memory[16];
                    R_data2  <= memory[17];
                    R_data3  <= memory[18];
                    R_data4  <= memory[19];
                    R_data5  <= memory[20];
                    R_data6  <= memory[21];
                    R_data7  <= memory[22];
                    R_data8  <= memory[23];
                    R_data9  <= memory[24];
                    R_data10 <= memory[25];
                    R_data11 <= memory[26];
                    R_data12 <= memory[27];
                    R_data13 <= memory[28];
                    R_data14 <= memory[29];
                    R_data15 <= memory[30];
                    R_data16 <= memory[31];                
                end
                2: begin
                    R_data1  <= memory[32];
                    R_data2  <= memory[33];
                    R_data3  <= memory[34];
                    R_data4  <= memory[35];
                    R_data5  <= memory[36];
                    R_data6  <= memory[37];
                    R_data7  <= memory[38];
                    R_data8  <= memory[39];
                    R_data9  <= memory[40];
                    R_data10 <= memory[41];
                    R_data11 <= memory[42];
                    R_data12 <= memory[43];
                    R_data13 <= memory[44];
                    R_data14 <= memory[45];
                    R_data15 <= memory[46];
                    R_data16 <= memory[47];               
                end
                3: begin
                    R_data1  <= memory[48];
                    R_data2  <= memory[49];
                    R_data3  <= memory[50];
                    R_data4  <= memory[51];
                    R_data5  <= memory[52];
                    R_data6  <= memory[53];
                    R_data7  <= memory[54];
                    R_data8  <= memory[55];
                    R_data9  <= memory[56];
                    R_data10 <= memory[57];
                    R_data11 <= memory[58];
                    R_data12 <= memory[59];
                    R_data13 <= memory[60];
                    R_data14 <= memory[61];
                    R_data15 <= memory[62];
                    R_data16 <= memory[63];                
                end
                4: begin
                    R_data1  <= memory[64];
                    R_data2  <= memory[65];
                    R_data3  <= memory[66];
                    R_data4  <= memory[67];
                    R_data5  <= memory[68];
                    R_data6  <= memory[69];
                    R_data7  <= memory[70];
                    R_data8  <= memory[71];
                    R_data9  <= memory[72];
                    R_data10 <= memory[73];
                    R_data11 <= memory[74];
                    R_data12 <= memory[75];
                    R_data13 <= memory[76];
                    R_data14 <= memory[77];
                    R_data15 <= memory[78];
                    R_data16 <= memory[79];                
                end
                5: begin
                    R_data1  <= memory[80];
                    R_data2  <= memory[81];
                    R_data3  <= memory[82];
                    R_data4  <= memory[83];
                    R_data5  <= memory[84];
                    R_data6  <= memory[85];
                    R_data7  <= memory[86];
                    R_data8  <= memory[87];
                    R_data9  <= memory[88];
                    R_data10 <= memory[89];
                    R_data11 <= memory[90];
                    R_data12 <= memory[91];
                    R_data13 <= memory[92];
                    R_data14 <= memory[93];
                    R_data15 <= memory[94];
                    R_data16 <= memory[95];                
                end
                6: begin
                    R_data1  <= memory[96];
                    R_data2  <= memory[97];
                    R_data3  <= memory[98];
                    R_data4  <= memory[99];
                    R_data5  <= memory[100];
                    R_data6  <= memory[101];
                    R_data7  <= memory[102];
                    R_data8  <= memory[103];
                    R_data9  <= memory[104];
                    R_data10 <= memory[105];
                    R_data11 <= memory[106];
                    R_data12 <= memory[107];
                    R_data13 <= memory[108];
                    R_data14 <= memory[109];
                    R_data15 <= memory[110];
                    R_data16 <= memory[111];                
                end
                7: begin
                    R_data1  <= memory[112];
                    R_data2  <= memory[113];
                    R_data3  <= memory[114];
                    R_data4  <= memory[115];
                    R_data5  <= memory[116];
                    R_data6  <= memory[117];
                    R_data7  <= memory[118];
                    R_data8  <= memory[119];
                    R_data9  <= memory[120];
                    R_data10 <= memory[121];
                    R_data11 <= memory[122];
                    R_data12 <= memory[123];
                    R_data13 <= memory[124];
                    R_data14 <= memory[125];
                    R_data15 <= memory[126];
                    R_data16 <= memory[127];                
                end
                8: begin
                    R_data1  <= memory[128];
                    R_data2  <= memory[129];
                    R_data3  <= memory[130];
                    R_data4  <= memory[131];
                    R_data5  <= memory[132];
                    R_data6  <= memory[133];
                    R_data7  <= memory[134];
                    R_data8  <= memory[135];
                    R_data9  <= memory[136];
                    R_data10 <= memory[137];
                    R_data11 <= memory[138];
                    R_data12 <= memory[139];
                    R_data13 <= memory[140];
                    R_data14 <= memory[141];
                    R_data15 <= memory[142];
                    R_data16 <= memory[143];                
                end
                9: begin
                    R_data1  <= memory[144];
                    R_data2  <= memory[145];
                    R_data3  <= memory[146];
                    R_data4  <= memory[147];
                    R_data5  <= memory[148];
                    R_data6  <= memory[149];
                    R_data7  <= memory[150];
                    R_data8  <= memory[151];
                    R_data9  <= memory[152];
                    R_data10 <= memory[153];
                    R_data11 <= memory[154];
                    R_data12 <= memory[155];
                    R_data13 <= memory[156];
                    R_data14 <= memory[157];
                    R_data15 <= memory[158];
                    R_data16 <= memory[159];                
                end
                10: begin
                    R_data1  <= memory[160];
                    R_data2  <= memory[161];
                    R_data3  <= memory[162];
                    R_data4  <= memory[163];
                    R_data5  <= memory[164];
                    R_data6  <= memory[165];
                    R_data7  <= memory[166];
                    R_data8  <= memory[167];
                    R_data9  <= memory[168];
                    R_data10 <= memory[169];
                    R_data11 <= memory[170];
                    R_data12 <= memory[171];
                    R_data13 <= memory[172];
                    R_data14 <= memory[173];
                    R_data15 <= memory[174];
                    R_data16 <= memory[175];                
                end
                11: begin
                    R_data1  <= memory[176];
                    R_data2  <= memory[177];
                    R_data3  <= memory[178];
                    R_data4  <= memory[179];
                    R_data5  <= memory[180];
                    R_data6  <= memory[181];
                    R_data7  <= memory[182];
                    R_data8  <= memory[183];
                    R_data9  <= memory[184];
                    R_data10 <= memory[185];
                    R_data11 <= memory[186];
                    R_data12 <= memory[187];
                    R_data13 <= memory[188];
                    R_data14 <= memory[189];
                    R_data15 <= memory[190];
                    R_data16 <= memory[191];                
                end
                12: begin
                    R_data1  <= memory[192];
                    R_data2  <= memory[193];
                    R_data3  <= memory[194];
                    R_data4  <= memory[195];
                    R_data5  <= memory[196];
                    R_data6  <= memory[197];
                    R_data7  <= memory[198];
                    R_data8  <= memory[199];
                    R_data9  <= memory[200];
                    R_data10 <= memory[201];
                    R_data11 <= memory[202];
                    R_data12 <= memory[203];
                    R_data13 <= memory[204];
                    R_data14 <= memory[205];
                    R_data15 <= memory[206];
                    R_data16 <= memory[207];                
                end
                13: begin
                    R_data1  <= memory[208];
                    R_data2  <= memory[209];
                    R_data3  <= memory[210];
                    R_data4  <= memory[211];
                    R_data5  <= memory[212];
                    R_data6  <= memory[213];
                    R_data7  <= memory[214];
                    R_data8  <= memory[215];
                    R_data9  <= memory[216];
                    R_data10 <= memory[217];
                    R_data11 <= memory[218];
                    R_data12 <= memory[219];
                    R_data13 <= memory[220];
                    R_data14 <= memory[221];
                    R_data15 <= memory[222];
                    R_data16 <= memory[223];                
                end
                14: begin
                    R_data1  <= memory[224];
                    R_data2  <= memory[225];
                    R_data3  <= memory[226];
                    R_data4  <= memory[227];
                    R_data5  <= memory[228];
                    R_data6  <= memory[229];
                    R_data7  <= memory[230];
                    R_data8  <= memory[231];
                    R_data9  <= memory[232];
                    R_data10 <= memory[233];
                    R_data11 <= memory[234];
                    R_data12 <= memory[235];
                    R_data13 <= memory[236];
                    R_data14 <= memory[237];
                    R_data15 <= memory[238];
                    R_data16 <= memory[239];               
                end
                15: begin
                    R_data1  <= memory[240];
                    R_data2  <= memory[241];
                    R_data3  <= memory[242];
                    R_data4  <= memory[243];
                    R_data5  <= memory[244];
                    R_data6  <= memory[245];
                    R_data7  <= memory[246];
                    R_data8  <= memory[247];
                    R_data9  <= memory[248];
                    R_data10 <= memory[249];
                    R_data11 <= memory[250];
                    R_data12 <= memory[251];
                    R_data13 <= memory[252];
                    R_data14 <= memory[253];
                    R_data15 <= memory[254];
                    R_data16 <= memory[255];               
                end
                default: ; // no operation
            endcase
        end
    end

endmodule

module Tiled_SDS_Unit( 
    R_data1, R_data2, R_data3, R_data4, R_data5, R_data6, R_data7, R_data8,
    R_data9, R_data10, R_data11, R_data12, R_data13, R_data14, R_data15, R_data16,
    W_data1, W_data2, W_data3, W_data4, W_data5, W_data6, W_data7, W_data8, 
    W_data9, W_data10, W_data11, W_data12, W_data13, W_data14, W_data15, W_data16, 
    rd, wr, tiled_computing_sig, zerofill_sig, matrix_compute_size, clk, rst);
    parameter address_size = 8;
    parameter word_size = 8;
    parameter matrix_size = 6;
    parameter memory_size = 64;
    output reg [word_size-1:0] R_data1, R_data2, R_data3, R_data4, R_data5, R_data6, R_data7, R_data8; // read data to L1 Host Memory
    output reg [word_size-1:0] R_data9, R_data10, R_data11, R_data12, R_data13, R_data14, R_data15, R_data16; // read data to L1 Host Memory
    input [word_size-1:0] W_data1, W_data2, W_data3, W_data4, W_data5, W_data6, W_data7, W_data8; // write data from L2 Host Memory
    input [word_size-1:0] W_data9, W_data10, W_data11, W_data12, W_data13, W_data14, W_data15, W_data16; // write data from L2 Host Memory
    input [matrix_size-1:0] matrix_compute_size; // Determine how big the matrix size we are going to compute (for tiled data reordering purpose)
    input rd, wr;
    input clk, rst;
    input tiled_computing_sig, zerofill_sig;
    reg [word_size-1:0] memory [memory_size-1:0];
    reg [word_size-1:0] rd_counter; // for propogating data purpose
    reg [word_size-1:0] wr_counter; // for propogating data purpose
    reg [matrix_size-1:0] matrix_compute_size_reg;
    reg tiled_computing_sig_reg, zerofill_sig_reg;
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_counter <= 0;
        end else if (rd) begin
            rd_counter <= rd_counter + 1;
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_counter <= 0;
        end else if (wr) begin
            wr_counter <= wr_counter + 1;
        end
    end
    
    always@(*) begin
        matrix_compute_size_reg = matrix_compute_size;
        tiled_computing_sig_reg = tiled_computing_sig;
        zerofill_sig_reg = zerofill_sig;
    end

    // Write operation (triggered on clock edge)
    always @(posedge clk) begin
        if (zerofill_sig_reg) begin // Fill the memory with all 0's first!!!
            for (i = 0; i < 64; i = i + 1) begin
                memory[i] <= 8'b00000000;
            end
//            memory[0]  <= 8'b00000000;
//            memory[1]  <= 8'b00000000;
//            memory[2]  <= 8'b00000000;
//            memory[3]  <= 8'b00000000;
//            memory[4]  <= 8'b00000000;
//            memory[5]  <= 8'b00000000;
//            memory[6]  <= 8'b00000000;
//            memory[7]  <= 8'b00000000;
//            memory[8]  <= 8'b00000000;
//            memory[9]  <= 8'b00000000;
//            memory[10] <= 8'b00000000;
//            memory[11] <= 8'b00000000;
//            memory[12] <= 8'b00000000;
//            memory[13] <= 8'b00000000;
//            memory[14] <= 8'b00000000;
//            memory[15] <= 8'b00000000;
//            memory[16] <= 8'b00000000;
//            memory[17] <= 8'b00000000;
//            memory[18] <= 8'b00000000;
//            memory[19] <= 8'b00000000;
//            memory[20] <= 8'b00000000;
//            memory[21] <= 8'b00000000;
//            memory[22] <= 8'b00000000;
//            memory[23] <= 8'b00000000;
//            memory[24] <= 8'b00000000;
//            memory[25] <= 8'b00000000;
//            memory[26] <= 8'b00000000;
//            memory[27] <= 8'b00000000;
//            memory[28] <= 8'b00000000;
//            memory[29] <= 8'b00000000;
//            memory[30] <= 8'b00000000;
//            memory[31] <= 8'b00000000;
//            memory[32] <= 8'b00000000;
//            memory[33] <= 8'b00000000;
//            memory[34] <= 8'b00000000;
//            memory[35] <= 8'b00000000;
//            memory[36] <= 8'b00000000;
//            memory[37] <= 8'b00000000;
//            memory[38] <= 8'b00000000;
//            memory[39] <= 8'b00000000;
//            memory[40] <= 8'b00000000;
//            memory[41] <= 8'b00000000;
//            memory[42] <= 8'b00000000;
//            memory[43] <= 8'b00000000;
//            memory[44] <= 8'b00000000;
//            memory[45] <= 8'b00000000;
//            memory[46] <= 8'b00000000;
//            memory[47] <= 8'b00000000;
//            memory[48] <= 8'b00000000;
//            memory[49] <= 8'b00000000;
//            memory[50] <= 8'b00000000;
//            memory[51] <= 8'b00000000;
//            memory[52] <= 8'b00000000;
//            memory[53] <= 8'b00000000;
//            memory[54] <= 8'b00000000;
//            memory[55] <= 8'b00000000;
//            memory[56] <= 8'b00000000;
//            memory[57] <= 8'b00000000;
//            memory[58] <= 8'b00000000;
//            memory[59] <= 8'b00000000;
//            memory[60] <= 8'b00000000;
//            memory[61] <= 8'b00000000;
//            memory[62] <= 8'b00000000;
//            memory[63] <= 8'b00000000;
        end
        if (wr) begin
            if (tiled_computing_sig_reg) begin
                case (matrix_compute_size_reg) // The range should be 5x5 ~ 8x8
                5: begin
                        case (wr_counter)
                        0: begin
                            memory[0]  <= W_data1;
                            memory[1]  <= W_data2;
                            memory[2]  <= W_data3;
                            memory[3]  <= W_data4;
                            memory[32] <= W_data5;
                            memory[4]  <= W_data6;
                            memory[5]  <= W_data7;
                            memory[6]  <= W_data8;
                            memory[7]  <= W_data9;
                            memory[36]  <= W_data10;
                            memory[8]  <= W_data11;
                            memory[9]  <= W_data12;
                            memory[10]  <= W_data13;
                            memory[11]  <= W_data14;
                            memory[40]  <= W_data15;
                            memory[12]  <= W_data16;
                        end
                        1: begin
                            memory[13]  <= W_data1;
                            memory[14]  <= W_data2;
                            memory[15]  <= W_data3;
                            memory[44]  <= W_data4;
                            memory[16]  <= W_data5;
                            memory[17]  <= W_data6;
                            memory[18]  <= W_data7;
                            memory[19]  <= W_data8;
                            memory[48]  <= W_data9;
                        end
                        default: ; // no operation
                        endcase
                    end
                6: begin
                        case (wr_counter)
                        0: begin
                            memory[0]  <= W_data1;
                            memory[1]  <= W_data2;
                            memory[2]  <= W_data3;
                            memory[3]  <= W_data4;
                            memory[32]  <= W_data5;
                            memory[33]  <= W_data6;
                            memory[4]  <= W_data7;
                            memory[5]  <= W_data8;
                            memory[6]  <= W_data9;
                            memory[7]  <= W_data10;
                            memory[36]  <= W_data11;
                            memory[37]  <= W_data12;
                            memory[8]  <= W_data13;
                            memory[9]  <= W_data14;
                            memory[10]  <= W_data15;
                            memory[11]  <= W_data16;
                        end
                        1: begin
                            memory[40]  <= W_data1;
                            memory[41]  <= W_data2;
                            memory[12]  <= W_data3;
                            memory[13]  <= W_data4;
                            memory[14]  <= W_data5;
                            memory[15]  <= W_data6;
                            memory[44]  <= W_data7;
                            memory[45]  <= W_data8;
                            memory[16]  <= W_data9;
                            memory[17]  <= W_data10;
                            memory[18]  <= W_data11;
                            memory[19]  <= W_data12;
                            memory[48]  <= W_data13;
                            memory[49]  <= W_data14;
                            memory[20]  <= W_data15;
                            memory[21]  <= W_data16;
                        end
                        2: begin
                            memory[22]  <= W_data1;
                            memory[23]  <= W_data2;
                            memory[52]  <= W_data3;
                            memory[53]  <= W_data4;
                        end
                        default: ; // no operation
                        endcase
                    end
                7: begin
                        case (wr_counter)
                        0: begin
                            memory[0]  <= W_data1;
                            memory[1]  <= W_data2;
                            memory[2]  <= W_data3;
                            memory[3]  <= W_data4;
                            memory[32]  <= W_data5;
                            memory[33]  <= W_data6;
                            memory[34]  <= W_data7;
                            memory[4]  <= W_data8;
                            memory[5]  <= W_data9;
                            memory[6]  <= W_data10;
                            memory[7]  <= W_data11;
                            memory[36]  <= W_data12;
                            memory[37]  <= W_data13;
                            memory[38]  <= W_data14;
                            memory[8]  <= W_data15;
                            memory[9]  <= W_data16;
                        end
                        1: begin
                            memory[10]  <= W_data1;
                            memory[11]  <= W_data2;
                            memory[40]  <= W_data3;
                            memory[41]  <= W_data4;
                            memory[42]  <= W_data5;
                            memory[12]  <= W_data6;
                            memory[13]  <= W_data7;
                            memory[14]  <= W_data8;
                            memory[15]  <= W_data9;
                            memory[44]  <= W_data10;
                            memory[45]  <= W_data11;
                            memory[46]  <= W_data12;
                            memory[16]  <= W_data13;
                            memory[17]  <= W_data14;
                            memory[18]  <= W_data15;
                            memory[19]  <= W_data16;
                        end
                        2: begin
                            memory[48]  <= W_data1;
                            memory[49]  <= W_data2;
                            memory[50]  <= W_data3;
                            memory[20]  <= W_data4;
                            memory[21]  <= W_data5;
                            memory[22]  <= W_data6;
                            memory[23]  <= W_data7;
                            memory[52]  <= W_data8;
                            memory[53]  <= W_data9;
                            memory[54]  <= W_data10;
                            memory[24]  <= W_data11;
                            memory[25]  <= W_data12;
                            memory[26]  <= W_data13;
                            memory[27]  <= W_data14;
                            memory[56]  <= W_data15;
                            memory[57]  <= W_data16;
                        end
                        3: begin
                            memory[58]  <= W_data1;
                        end
                        default: ; // no operation
                        endcase
                    end
                8: begin
                        case (wr_counter)
                        0: begin
                            memory[0]  <= W_data1;
                            memory[1]  <= W_data2;
                            memory[2]  <= W_data3;
                            memory[3]  <= W_data4;
                            memory[32]  <= W_data5;
                            memory[33]  <= W_data6;
                            memory[34]  <= W_data7;
                            memory[35]  <= W_data8;
                            memory[4]  <= W_data9;
                            memory[5]  <= W_data10;
                            memory[6]  <= W_data11;
                            memory[7]  <= W_data12;
                            memory[36]  <= W_data13;
                            memory[37]  <= W_data14;
                            memory[38]  <= W_data15;
                            memory[39]  <= W_data16;
                        end
                        1: begin
                            memory[8]  <= W_data1;
                            memory[9]  <= W_data2;
                            memory[10]  <= W_data3;
                            memory[11]  <= W_data4;
                            memory[40]  <= W_data5;
                            memory[41]  <= W_data6;
                            memory[42]  <= W_data7;
                            memory[43]  <= W_data8;
                            memory[12]  <= W_data9;
                            memory[13]  <= W_data10;
                            memory[14]  <= W_data11;
                            memory[15]  <= W_data12;
                            memory[44]  <= W_data13;
                            memory[45]  <= W_data14;
                            memory[46]  <= W_data15;
                            memory[47]  <= W_data16;
                        end
                        2: begin
                            memory[16]  <= W_data1;
                            memory[17]  <= W_data2;
                            memory[18]  <= W_data3;
                            memory[19]  <= W_data4;
                            memory[48]  <= W_data5;
                            memory[49]  <= W_data6;
                            memory[50]  <= W_data7;
                            memory[51]  <= W_data8;
                            memory[20]  <= W_data9;
                            memory[21]  <= W_data10;
                            memory[22]  <= W_data11;
                            memory[23]  <= W_data12;
                            memory[52]  <= W_data13;
                            memory[53]  <= W_data14;
                            memory[54]  <= W_data15;
                            memory[55]  <= W_data16;
                        end
                        3: begin
                            memory[24]  <= W_data1;
                            memory[25]  <= W_data2;
                            memory[26]  <= W_data3;
                            memory[27]  <= W_data4;
                            memory[56]  <= W_data5;
                            memory[57]  <= W_data6;
                            memory[58]  <= W_data7;
                            memory[59]  <= W_data8;
                            memory[28]  <= W_data9;
                            memory[29]  <= W_data10;
                            memory[30]  <= W_data11;
                            memory[31]  <= W_data12;
                            memory[60]  <= W_data13;
                            memory[61]  <= W_data14;
                            memory[62]  <= W_data15;
                            memory[63]  <= W_data16;
                        end
                        default: ; // no operation
                        endcase
                    end
                default: ;
                endcase
            end else begin // The matrix size that needs to be computed range from 1x1 ~ 4x4 (dont need tiled MM)
                case (matrix_compute_size_reg) // The range should be 1x1 ~ 4x4
                    1: begin // 1x1 matrix multiplication
                        case (wr_counter)
                        0: begin
                            memory[0]  <= W_data1;
                        end
                        1: begin
                            memory[16]  <= W_data1;
                        end
                        2: begin
                            memory[32]  <= W_data1;
                        end
                        3: begin
                            memory[48]  <= W_data1;
                        end
                        default: ; // no operation
                        endcase
                    end
                    2: begin // 2x2 matrix multiplication                           
                        case (wr_counter)                           
                        0: begin
                            memory[0]  <= W_data1; // see the order send by FIFO
                            memory[1]  <= W_data2;
                            memory[4]  <= W_data3;
                            memory[5]  <= W_data4;
                        end
                        1: begin
                            memory[16]  <= W_data1;
                            memory[17]  <= W_data2;
                            memory[20]  <= W_data3;
                            memory[21]  <= W_data4;
                        end
                        2: begin
                            memory[32]  <= W_data1;
                            memory[33]  <= W_data2;
                            memory[36]  <= W_data3;
                            memory[37]  <= W_data4;
                        end
                        3: begin
                            memory[48]  <= W_data1;
                            memory[49]  <= W_data2;
                            memory[52]  <= W_data3;
                            memory[53]  <= W_data4;
                        end
                        default: ; // no operation
                        endcase
                    end
                    3: begin // 3x3 matrix multiplication
                        case (wr_counter)
                        0: begin
                            memory[0]  <= W_data1; // see the order send by FIFO
                            memory[1]  <= W_data2;
                            memory[2]  <= W_data3;
                            memory[4]  <= W_data4;
                            memory[5]  <= W_data5;
                            memory[6]  <= W_data6;
                            memory[8]  <= W_data7;
                            memory[9]  <= W_data8;
                            memory[10]  <= W_data9;
                        end
                        1: begin
                            memory[16]  <= W_data1;
                            memory[17]  <= W_data2;
                            memory[18]  <= W_data3;
                            memory[20]  <= W_data4;
                            memory[21]  <= W_data5;
                            memory[22]  <= W_data6;
                            memory[24]  <= W_data7;
                            memory[25]  <= W_data8;
                            memory[26]  <= W_data9;
                        end
                        2: begin
                            memory[32]  <= W_data1;
                            memory[33]  <= W_data2;
                            memory[34]  <= W_data3;
                            memory[36]  <= W_data4;
                            memory[37]  <= W_data5;
                            memory[38]  <= W_data6;
                            memory[40]  <= W_data7;
                            memory[41]  <= W_data8;
                            memory[42]  <= W_data9;
                        end
                        3: begin
                            memory[48]  <= W_data1;
                            memory[49]  <= W_data2;
                            memory[50]  <= W_data3;
                            memory[52]  <= W_data4;
                            memory[53]  <= W_data5;
                            memory[54]  <= W_data6;
                            memory[56]  <= W_data7;
                            memory[57]  <= W_data8;
                            memory[58]  <= W_data9;
                        end
                        default: ; // no operation
                        endcase
                    end
                    4: begin
                        case (wr_counter)
                        0: begin
                            memory[0]  <= W_data1;
                            memory[1]  <= W_data2;
                            memory[2]  <= W_data3;
                            memory[3]  <= W_data4;
                            memory[4]  <= W_data5;
                            memory[5]  <= W_data6;
                            memory[6]  <= W_data7;
                            memory[7]  <= W_data8;
                            memory[8]  <= W_data9;
                            memory[9]  <= W_data10;
                            memory[10] <= W_data11;
                            memory[11] <= W_data12;
                            memory[12] <= W_data13;
                            memory[13] <= W_data14;
                            memory[14] <= W_data15;
                            memory[15] <= W_data16;  
                        end
                        1: begin
                            memory[16] <= W_data1;
                            memory[17] <= W_data2;
                            memory[18] <= W_data3;
                            memory[19] <= W_data4;
                            memory[20] <= W_data5;
                            memory[21] <= W_data6;
                            memory[22] <= W_data7;
                            memory[23] <= W_data8;
                            memory[24] <= W_data9;
                            memory[25] <= W_data10;
                            memory[26] <= W_data11;
                            memory[27] <= W_data12;
                            memory[28] <= W_data13;
                            memory[29] <= W_data14;
                            memory[30] <= W_data15;
                            memory[31] <= W_data16;  
                        end
                        2: begin
                            memory[32] <= W_data1;
                            memory[33] <= W_data2;
                            memory[34] <= W_data3;
                            memory[35] <= W_data4;
                            memory[36] <= W_data5;
                            memory[37] <= W_data6;
                            memory[38] <= W_data7;
                            memory[39] <= W_data8;
                            memory[40] <= W_data9;
                            memory[41] <= W_data10;
                            memory[42] <= W_data11;
                            memory[43] <= W_data12;
                            memory[44] <= W_data13;
                            memory[45] <= W_data14;
                            memory[46] <= W_data15;
                            memory[47] <= W_data16;  
                        end
                        3: begin
                            memory[48] <= W_data1;
                            memory[49] <= W_data2;
                            memory[50] <= W_data3;
                            memory[51] <= W_data4;
                            memory[52] <= W_data5;
                            memory[53] <= W_data6;
                            memory[54] <= W_data7;
                            memory[55] <= W_data8;
                            memory[56] <= W_data9;
                            memory[57] <= W_data10;
                            memory[58] <= W_data11;
                            memory[59] <= W_data12;
                            memory[60] <= W_data13;
                            memory[61] <= W_data14;
                            memory[62] <= W_data15;
                            memory[63] <= W_data16;  
                        end
                        default: ; // no operation
                        endcase
                end
                default: ; // no operation
                endcase
            end
        end
    end

    always @(posedge clk) begin
        if (rd) begin
            case (rd_counter)
                0: begin
                    R_data1  <= memory[0];
                    R_data2  <= memory[1];
                    R_data3  <= memory[2];
                    R_data4  <= memory[3];
                    R_data5  <= memory[4];
                    R_data6  <= memory[5];
                    R_data7  <= memory[6];
                    R_data8  <= memory[7];
                    R_data9  <= memory[8];
                    R_data10 <= memory[9];
                    R_data11 <= memory[10];
                    R_data12 <= memory[11];
                    R_data13 <= memory[12];
                    R_data14 <= memory[13];
                    R_data15 <= memory[14];
                    R_data16 <= memory[15];                
                end
                1: begin
                    R_data1  <= memory[16];
                    R_data2  <= memory[17];
                    R_data3  <= memory[18];
                    R_data4  <= memory[19];
                    R_data5  <= memory[20];
                    R_data6  <= memory[21];
                    R_data7  <= memory[22];
                    R_data8  <= memory[23];
                    R_data9  <= memory[24];
                    R_data10 <= memory[25];
                    R_data11 <= memory[26];
                    R_data12 <= memory[27];
                    R_data13 <= memory[28];
                    R_data14 <= memory[29];
                    R_data15 <= memory[30];
                    R_data16 <= memory[31];                
                end
                2: begin
                    R_data1  <= memory[32];
                    R_data2  <= memory[33];
                    R_data3  <= memory[34];
                    R_data4  <= memory[35];
                    R_data5  <= memory[36];
                    R_data6  <= memory[37];
                    R_data7  <= memory[38];
                    R_data8  <= memory[39];
                    R_data9  <= memory[40];
                    R_data10 <= memory[41];
                    R_data11 <= memory[42];
                    R_data12 <= memory[43];
                    R_data13 <= memory[44];
                    R_data14 <= memory[45];
                    R_data15 <= memory[46];
                    R_data16 <= memory[47];               
                end
                3: begin
                    R_data1  <= memory[48];
                    R_data2  <= memory[49];
                    R_data3  <= memory[50];
                    R_data4  <= memory[51];
                    R_data5  <= memory[52];
                    R_data6  <= memory[53];
                    R_data7  <= memory[54];
                    R_data8  <= memory[55];
                    R_data9  <= memory[56];
                    R_data10 <= memory[57];
                    R_data11 <= memory[58];
                    R_data12 <= memory[59];
                    R_data13 <= memory[60];
                    R_data14 <= memory[61];
                    R_data15 <= memory[62];
                    R_data16 <= memory[63];                
                end
                default: ; // no operation
            endcase
        end
    end

endmodule

//-------------------------------TPU4x4-------------------------------//
//------------------------Host Memory related------------------------//
module L1_Host_Memory_Weight(R_data, W_data, addr, clk, rd, wr, 
    W_data_from_TsdsU1, W_data_from_TsdsU2, W_data_from_TsdsU3, W_data_from_TsdsU4, W_data_from_TsdsU5, W_data_from_TsdsU6, W_data_from_TsdsU7, W_data_from_TsdsU8, 
    W_data_from_TsdsU9, W_data_from_TsdsU10, W_data_from_TsdsU11, W_data_from_TsdsU12, W_data_from_TsdsU13, W_data_from_TsdsU14, W_data_from_TsdsU15, W_data_from_TsdsU16, 
    W_wr_from_TsdsU, L1HW_counter_rst);
    parameter address_size = 6;
    parameter word_size = 8;
    parameter memory_size = 64;
    output reg [word_size-1:0] R_data; // read data to UB
    input [word_size-1:0] W_data; // write data from UB => useless!!! No Weights will be written back
    input [word_size-1:0] W_data_from_TsdsU1, W_data_from_TsdsU2, W_data_from_TsdsU3, W_data_from_TsdsU4, W_data_from_TsdsU5, W_data_from_TsdsU6, W_data_from_TsdsU7, W_data_from_TsdsU8; // write ACTIVATION data from Tiled SDS Unit to L1 Host Memory
    input [word_size-1:0] W_data_from_TsdsU9, W_data_from_TsdsU10, W_data_from_TsdsU11, W_data_from_TsdsU12, W_data_from_TsdsU13, W_data_from_TsdsU14, W_data_from_TsdsU15, W_data_from_TsdsU16; // write ACTIVATION data from Tiled SDS Unit to L1 Host Memory
    input W_wr_from_TsdsU; // write enable to allow data write from L2 Host Memory to L1 Host Memory
    input [address_size-1:0] addr; // [8:0]
    input clk, rd, wr, L1HW_counter_rst;
    reg [address_size-1:0] memory [memory_size-1:0];
    reg [word_size-1:0] counter; // for storing data purpose
    
    always @(posedge clk or posedge L1HW_counter_rst) begin
        if (L1HW_counter_rst) begin
            counter <= 0; 
        end else if (W_wr_from_TsdsU) begin
            counter <= counter + 1;    
        end
    end
    
    // Write operation (triggered on clock edge)
    always @(posedge clk) begin
        if (wr) begin
            memory[addr] <= W_data; // Write data to memory at specified address
        end else if (W_wr_from_TsdsU) begin
            case (counter)
                0: begin
                    memory[0]  <= W_data_from_TsdsU1;
                    memory[1]  <= W_data_from_TsdsU2;
                    memory[2]  <= W_data_from_TsdsU3;
                    memory[3]  <= W_data_from_TsdsU4;
                    memory[4]  <= W_data_from_TsdsU5;
                    memory[5]  <= W_data_from_TsdsU6;
                    memory[6]  <= W_data_from_TsdsU7;
                    memory[7]  <= W_data_from_TsdsU8;
                    memory[8]  <= W_data_from_TsdsU9;
                    memory[9]  <= W_data_from_TsdsU10;
                    memory[10] <= W_data_from_TsdsU11;
                    memory[11] <= W_data_from_TsdsU12;
                    memory[12] <= W_data_from_TsdsU13;
                    memory[13] <= W_data_from_TsdsU14;
                    memory[14] <= W_data_from_TsdsU15;
                    memory[15] <= W_data_from_TsdsU16;
                end
                1: begin
                    memory[16]  <= W_data_from_TsdsU1;
                    memory[17]  <= W_data_from_TsdsU2;
                    memory[18]  <= W_data_from_TsdsU3;
                    memory[19]  <= W_data_from_TsdsU4;
                    memory[20]  <= W_data_from_TsdsU5;
                    memory[21]  <= W_data_from_TsdsU6;
                    memory[22]  <= W_data_from_TsdsU7;
                    memory[23]  <= W_data_from_TsdsU8;
                    memory[24]  <= W_data_from_TsdsU9;
                    memory[25] <= W_data_from_TsdsU10;
                    memory[26] <= W_data_from_TsdsU11;
                    memory[27] <= W_data_from_TsdsU12;
                    memory[28] <= W_data_from_TsdsU13;
                    memory[29] <= W_data_from_TsdsU14;
                    memory[30] <= W_data_from_TsdsU15;
                    memory[31] <= W_data_from_TsdsU16;
                end
                2: begin
                    memory[32]  <= W_data_from_TsdsU1;
                    memory[33]  <= W_data_from_TsdsU2;
                    memory[34]  <= W_data_from_TsdsU3;
                    memory[35]  <= W_data_from_TsdsU4;
                    memory[36]  <= W_data_from_TsdsU5;
                    memory[37]  <= W_data_from_TsdsU6;
                    memory[38]  <= W_data_from_TsdsU7;
                    memory[39]  <= W_data_from_TsdsU8;
                    memory[40]  <= W_data_from_TsdsU9;
                    memory[41] <= W_data_from_TsdsU10;
                    memory[42] <= W_data_from_TsdsU11;
                    memory[43] <= W_data_from_TsdsU12;
                    memory[44] <= W_data_from_TsdsU13;
                    memory[45] <= W_data_from_TsdsU14;
                    memory[46] <= W_data_from_TsdsU15;
                    memory[47] <= W_data_from_TsdsU16;
                end
                3: begin
                    memory[48]  <= W_data_from_TsdsU1;
                    memory[49]  <= W_data_from_TsdsU2;
                    memory[50]  <= W_data_from_TsdsU3;
                    memory[51]  <= W_data_from_TsdsU4;
                    memory[52]  <= W_data_from_TsdsU5;
                    memory[53]  <= W_data_from_TsdsU6;
                    memory[54]  <= W_data_from_TsdsU7;
                    memory[55]  <= W_data_from_TsdsU8;
                    memory[56]  <= W_data_from_TsdsU9;
                    memory[57] <= W_data_from_TsdsU10;
                    memory[58] <= W_data_from_TsdsU11;
                    memory[59] <= W_data_from_TsdsU12;
                    memory[60] <= W_data_from_TsdsU13;
                    memory[61] <= W_data_from_TsdsU14;
                    memory[62] <= W_data_from_TsdsU15;
                    memory[63] <= W_data_from_TsdsU16;
                end
                default: ;
            endcase
        end 
    end

    always @(posedge clk) begin
        if (rd) begin
            R_data <= memory[addr];
        end
    end

endmodule

module L1_Host_Memory_Activation(tiled_computing_sig, R_data, W_data, rd_addr, wr_addr, clk, rd, wr, 
    A_data_from_TsdsU1, A_data_from_TsdsU2, A_data_from_TsdsU3, A_data_from_TsdsU4, A_data_from_TsdsU5, A_data_from_TsdsU6, A_data_from_TsdsU7, A_data_from_TsdsU8, 
    A_data_from_TsdsU9, A_data_from_TsdsU10, A_data_from_TsdsU11, A_data_from_TsdsU12, A_data_from_TsdsU13, A_data_from_TsdsU14, A_data_from_TsdsU15, A_data_from_TsdsU16, 
    A_wr_from_TsdsU, A_data_backto_L2_Accumu1, A_data_backto_L2_Accumu2, A_data_backto_L2_Accumu3, A_data_backto_L2_Accumu4, A_data_backto_L2_Accumu5, A_data_backto_L2_Accumu6, A_data_backto_L2_Accumu7, A_data_backto_L2_Accumu8, 
    A_data_backto_L2_Accumu9, A_data_backto_L2_Accumu10, A_data_backto_L2_Accumu11, A_data_backto_L2_Accumu12, A_data_backto_L2_Accumu13, A_data_backto_L2_Accumu14, A_data_backto_L2_Accumu15, A_data_backto_L2_Accumu16, 
    A_rd_backto_L2HM, L1HW_counter_rst
    );
    parameter address_size = 6;
    parameter word_size = 8;
    parameter memory_size = 64;
    input tiled_computing_sig;
    output reg [word_size-1:0] R_data; // read data to UB
    input [word_size-1:0] W_data; // write data from UB
    input [word_size-1:0] A_data_from_TsdsU1, A_data_from_TsdsU2, A_data_from_TsdsU3, A_data_from_TsdsU4, A_data_from_TsdsU5, A_data_from_TsdsU6, A_data_from_TsdsU7, A_data_from_TsdsU8; // write ACTIVATION data from Tiled SDS Unit to L1 Host Memory
    input [word_size-1:0] A_data_from_TsdsU9, A_data_from_TsdsU10, A_data_from_TsdsU11, A_data_from_TsdsU12, A_data_from_TsdsU13, A_data_from_TsdsU14, A_data_from_TsdsU15, A_data_from_TsdsU16; // write ACTIVATION data from Tiled SDS Unit to L1 Host Memory
    output reg [word_size-1:0] A_data_backto_L2_Accumu1, A_data_backto_L2_Accumu2, A_data_backto_L2_Accumu3, A_data_backto_L2_Accumu4, A_data_backto_L2_Accumu5, A_data_backto_L2_Accumu6, A_data_backto_L2_Accumu7, A_data_backto_L2_Accumu8; // read ACTIVATION data back to L2 Accumulator before store back to L2 Host Memory
    output reg [word_size-1:0] A_data_backto_L2_Accumu9, A_data_backto_L2_Accumu10, A_data_backto_L2_Accumu11, A_data_backto_L2_Accumu12, A_data_backto_L2_Accumu13, A_data_backto_L2_Accumu14, A_data_backto_L2_Accumu15, A_data_backto_L2_Accumu16; // read ACTIVATION data back to L2 Accumulator before store back to L2 Host Memory
    input A_rd_backto_L2HM; // read enable to allow data read back to L2 Host Memory
    input A_wr_from_TsdsU; // write enable to allow data write from L2 Host Memory to L1 Host Memory
    input [address_size-1:0] rd_addr, wr_addr; // [8:0]
    input clk, rd, wr, L1HW_counter_rst;
    reg [word_size-1:0] memory [memory_size-1:0];
    reg [word_size-1:0] wr_counter, rd_counter; // for storing data purpose
    
    always @(posedge clk or posedge L1HW_counter_rst) begin
        if (L1HW_counter_rst) begin
            wr_counter <= 0; 
            rd_counter <= 0;
        end else if (A_wr_from_TsdsU) begin
            wr_counter <= wr_counter + 1;    
        end else if (A_rd_backto_L2HM) begin
            rd_counter <= rd_counter + 1;    
        end
    end
    
    // Write operation (triggered on clock edge)
    always @(posedge clk) begin
        if (!tiled_computing_sig && wr) begin
            memory[wr_addr] <= W_data; // Write data to memory at specified address
        end else if (tiled_computing_sig && wr) begin
            case (wr_addr)
                0:  memory[0]  <= W_data;
                1:  memory[32] <= W_data;
                2:  memory[4]  <= W_data;
                3:  memory[36] <= W_data;
                4:  memory[1]  <= W_data;
                5:  memory[33] <= W_data;
                6:  memory[5]  <= W_data;
                7:  memory[37] <= W_data;
                8:  memory[2]  <= W_data;
                9:  memory[34] <= W_data;
                10: memory[6]  <= W_data;
                11: memory[38] <= W_data;
                12: memory[3]  <= W_data;
                13: memory[35] <= W_data;
                14: memory[7]  <= W_data;
                15: memory[39] <= W_data;
                16: memory[8]  <= W_data;
                17: memory[40] <= W_data;
                18: memory[12] <= W_data;
                19: memory[44] <= W_data;
                20: memory[9]  <= W_data;
                21: memory[41] <= W_data;
                22: memory[13] <= W_data;
                23: memory[45] <= W_data;
                24: memory[10] <= W_data;
                25: memory[42] <= W_data;
                26: memory[14] <= W_data;
                27: memory[46] <= W_data;
                28: memory[11] <= W_data;
                29: memory[43] <= W_data;
                30: memory[15] <= W_data;
                31: memory[47] <= W_data;
                32: memory[16] <= W_data;
                33: memory[48] <= W_data;
                34: memory[20] <= W_data;
                35: memory[52] <= W_data;
                36: memory[17] <= W_data;
                37: memory[49] <= W_data;
                38: memory[21] <= W_data;
                39: memory[53] <= W_data;
                40: memory[18] <= W_data;
                41: memory[50] <= W_data;
                42: memory[22] <= W_data;
                43: memory[54] <= W_data;
                44: memory[19] <= W_data;
                45: memory[51] <= W_data;
                46: memory[23] <= W_data;
                47: memory[55] <= W_data;
                48: memory[24] <= W_data;
                49: memory[56] <= W_data;
                50: memory[28] <= W_data;
                51: memory[60] <= W_data;
                52: memory[25] <= W_data;
                53: memory[57] <= W_data;
                54: memory[29] <= W_data;
                55: memory[61] <= W_data;
                56: memory[26] <= W_data;
                57: memory[58] <= W_data;
                58: memory[30] <= W_data;
                59: memory[62] <= W_data;
                60: memory[27] <= W_data;
                61: memory[59] <= W_data;
                62: memory[31] <= W_data;
                63: memory[63] <= W_data;
            endcase
        end else if (A_wr_from_TsdsU) begin
            case (wr_counter)
                0: begin
                    memory[0]  <= A_data_from_TsdsU1;
                    memory[1]  <= A_data_from_TsdsU2;
                    memory[2]  <= A_data_from_TsdsU3;
                    memory[3]  <= A_data_from_TsdsU4;
                    memory[4]  <= A_data_from_TsdsU5;
                    memory[5]  <= A_data_from_TsdsU6;
                    memory[6]  <= A_data_from_TsdsU7;
                    memory[7]  <= A_data_from_TsdsU8;
                    memory[8]  <= A_data_from_TsdsU9;
                    memory[9]  <= A_data_from_TsdsU10;
                    memory[10] <= A_data_from_TsdsU11;
                    memory[11] <= A_data_from_TsdsU12;
                    memory[12] <= A_data_from_TsdsU13;
                    memory[13] <= A_data_from_TsdsU14;
                    memory[14] <= A_data_from_TsdsU15;
                    memory[15] <= A_data_from_TsdsU16;
                    end
                1: begin
                    memory[16]  <= A_data_from_TsdsU1;
                    memory[17]  <= A_data_from_TsdsU2;
                    memory[18]  <= A_data_from_TsdsU3;
                    memory[19]  <= A_data_from_TsdsU4;
                    memory[20]  <= A_data_from_TsdsU5;
                    memory[21]  <= A_data_from_TsdsU6;
                    memory[22]  <= A_data_from_TsdsU7;
                    memory[23]  <= A_data_from_TsdsU8;
                    memory[24]  <= A_data_from_TsdsU9;
                    memory[25] <= A_data_from_TsdsU10;
                    memory[26] <= A_data_from_TsdsU11;
                    memory[27] <= A_data_from_TsdsU12;
                    memory[28] <= A_data_from_TsdsU13;
                    memory[29] <= A_data_from_TsdsU14;
                    memory[30] <= A_data_from_TsdsU15;
                    memory[31] <= A_data_from_TsdsU16;
                    end
                2: begin
                    memory[32]  <= A_data_from_TsdsU1;
                    memory[33]  <= A_data_from_TsdsU2;
                    memory[34]  <= A_data_from_TsdsU3;
                    memory[35]  <= A_data_from_TsdsU4;
                    memory[36]  <= A_data_from_TsdsU5;
                    memory[37]  <= A_data_from_TsdsU6;
                    memory[38]  <= A_data_from_TsdsU7;
                    memory[39]  <= A_data_from_TsdsU8;
                    memory[40]  <= A_data_from_TsdsU9;
                    memory[41] <= A_data_from_TsdsU10;
                    memory[42] <= A_data_from_TsdsU11;
                    memory[43] <= A_data_from_TsdsU12;
                    memory[44] <= A_data_from_TsdsU13;
                    memory[45] <= A_data_from_TsdsU14;
                    memory[46] <= A_data_from_TsdsU15;
                    memory[47] <= A_data_from_TsdsU16;
                    end
                3: begin
                    memory[48]  <= A_data_from_TsdsU1;
                    memory[49]  <= A_data_from_TsdsU2;
                    memory[50]  <= A_data_from_TsdsU3;
                    memory[51]  <= A_data_from_TsdsU4;
                    memory[52]  <= A_data_from_TsdsU5;
                    memory[53]  <= A_data_from_TsdsU6;
                    memory[54]  <= A_data_from_TsdsU7;
                    memory[55]  <= A_data_from_TsdsU8;
                    memory[56]  <= A_data_from_TsdsU9;
                    memory[57] <= A_data_from_TsdsU10;
                    memory[58] <= A_data_from_TsdsU11;
                    memory[59] <= A_data_from_TsdsU12;
                    memory[60] <= A_data_from_TsdsU13;
                    memory[61] <= A_data_from_TsdsU14;
                    memory[62] <= A_data_from_TsdsU15;
                    memory[63] <= A_data_from_TsdsU16;
                    end
                default: ;
            endcase
        end else if (A_rd_backto_L2HM) begin
            case (rd_counter)
                0: begin
                    A_data_backto_L2_Accumu1   <= memory[0];
                    A_data_backto_L2_Accumu2   <= memory[1];
                    A_data_backto_L2_Accumu3   <= memory[2];
                    A_data_backto_L2_Accumu4   <= memory[3];
                    A_data_backto_L2_Accumu5   <= memory[4];
                    A_data_backto_L2_Accumu6   <= memory[5];
                    A_data_backto_L2_Accumu7   <= memory[6];
                    A_data_backto_L2_Accumu8   <= memory[7];
                    A_data_backto_L2_Accumu9   <= memory[8];
                    A_data_backto_L2_Accumu10  <= memory[9];
                    A_data_backto_L2_Accumu11  <= memory[10];
                    A_data_backto_L2_Accumu12  <= memory[11];
                    A_data_backto_L2_Accumu13  <= memory[12];
                    A_data_backto_L2_Accumu14  <= memory[13];
                    A_data_backto_L2_Accumu15  <= memory[14];
                    A_data_backto_L2_Accumu16  <= memory[15];
                    end
                1: begin
                    A_data_backto_L2_Accumu1   <= memory[16];
                    A_data_backto_L2_Accumu2   <= memory[17];
                    A_data_backto_L2_Accumu3   <= memory[18];
                    A_data_backto_L2_Accumu4   <= memory[19];
                    A_data_backto_L2_Accumu5   <= memory[20];
                    A_data_backto_L2_Accumu6   <= memory[21];
                    A_data_backto_L2_Accumu7   <= memory[22];
                    A_data_backto_L2_Accumu8   <= memory[23];
                    A_data_backto_L2_Accumu9   <= memory[24];
                    A_data_backto_L2_Accumu10  <= memory[25];
                    A_data_backto_L2_Accumu11  <= memory[26];
                    A_data_backto_L2_Accumu12  <= memory[27];
                    A_data_backto_L2_Accumu13  <= memory[28];
                    A_data_backto_L2_Accumu14  <= memory[29];
                    A_data_backto_L2_Accumu15  <= memory[30];
                    A_data_backto_L2_Accumu16  <= memory[31];
                    end
                2: begin
                    A_data_backto_L2_Accumu1   <= memory[32];
                    A_data_backto_L2_Accumu2   <= memory[33];
                    A_data_backto_L2_Accumu3   <= memory[34];
                    A_data_backto_L2_Accumu4   <= memory[35];
                    A_data_backto_L2_Accumu5   <= memory[36];
                    A_data_backto_L2_Accumu6   <= memory[37];
                    A_data_backto_L2_Accumu7   <= memory[38];
                    A_data_backto_L2_Accumu8   <= memory[39];
                    A_data_backto_L2_Accumu9   <= memory[40];
                    A_data_backto_L2_Accumu10  <= memory[41];
                    A_data_backto_L2_Accumu11  <= memory[42];
                    A_data_backto_L2_Accumu12  <= memory[43];
                    A_data_backto_L2_Accumu13  <= memory[44];
                    A_data_backto_L2_Accumu14  <= memory[45];
                    A_data_backto_L2_Accumu15  <= memory[46];
                    A_data_backto_L2_Accumu16  <= memory[47];
                    end
                3: begin
                    A_data_backto_L2_Accumu1   <= memory[48];
                    A_data_backto_L2_Accumu2   <= memory[49];
                    A_data_backto_L2_Accumu3   <= memory[50];
                    A_data_backto_L2_Accumu4   <= memory[51];
                    A_data_backto_L2_Accumu5   <= memory[52];
                    A_data_backto_L2_Accumu6   <= memory[53];
                    A_data_backto_L2_Accumu7   <= memory[54];
                    A_data_backto_L2_Accumu8   <= memory[55];
                    A_data_backto_L2_Accumu9   <= memory[56];
                    A_data_backto_L2_Accumu10  <= memory[57];
                    A_data_backto_L2_Accumu11  <= memory[58];
                    A_data_backto_L2_Accumu12  <= memory[59];
                    A_data_backto_L2_Accumu13  <= memory[60];
                    A_data_backto_L2_Accumu14  <= memory[61];
                    A_data_backto_L2_Accumu15  <= memory[62];
                    A_data_backto_L2_Accumu16  <= memory[63];
                    end
                default: ;
            endcase
            end
        end

    always @(posedge clk) begin
        if (rd) begin
            R_data <= memory[rd_addr];
        end
    end

endmodule

//------------------------------IR related------------------------------//
module IR_Mem(R_data, W_data, addr, IR_wr_addr, clk, IR_rd, IR_wr);
    parameter address_size = 8;
    parameter word_size = 16;
    parameter memory_size = 64;
    output [word_size-1:0] R_data;
    input [word_size-1:0] W_data;
    input [address_size-1:0] addr, IR_wr_addr; // addr is from L1 Controller; IR_wr_addr is from L2 Controller
    input clk, IR_rd, IR_wr;
    reg [word_size-1:0] memory [memory_size-1:0];
    
    always @(posedge clk) begin
        if (IR_wr) begin
            memory[IR_wr_addr] <= W_data;
        end
    end
    assign R_data = memory[addr];
endmodule


module IR_counter(IR_addr, IR_inc, IR_clr, clk);
    parameter word_size = 8;
    output reg [word_size-1:0] IR_addr;
    input  IR_inc, IR_clr, clk;
    
    always@(posedge clk or posedge IR_clr) begin
        if(IR_clr==1) IR_addr <= 8'b0; 
        else if (IR_inc == 1) IR_addr <= IR_addr + 1;
    end
endmodule

//------------------------------Weight related------------------------------//
module Weight_DDR3(R_data, W_data, addr, clk, rd, wr);
    parameter address_size = 4;
    parameter word_size = 8;
    parameter memory_size = 64;
    output [word_size-1:0] R_data;
    input [word_size-1:0] W_data;
    input [address_size:0] addr; // [5:0]
    input clk, rd, wr;
    reg [word_size-1:0] memory [memory_size-1:0];

//    // Initialize memory with specific values at specific addresses
//    initial begin
//        memory[0] = 8'b00000001; // 1
//        memory[1] = 8'b00000010; // 2
//        memory[2] = 8'b00000011; // 3
//        memory[3] = 8'b00000100; // 4
//        memory[4] = 8'b00000101; // 5
//        memory[5] = 8'b00000110; // 6
//        memory[6] = 8'b00000111; // 7
//        memory[7] = 8'b00001000; // 8
//        memory[8] = 8'b00001001; // 9
//        memory[9] = 8'b00001010; // 10
//        memory[10] = 8'b00001011; // 11
//        memory[11] = 8'b00001100; // 12
//        memory[12] = 8'b00001101; // 13
//        memory[13] = 8'b00001110; // 14
//        memory[14] = 8'b00001111; // 15
//        memory[15] = 8'b00010000; // 16
//    end
    
    // Write operation (triggered on clock edge)
    always @(posedge clk) begin
        if (wr) begin
            memory[addr] <= W_data; // Write data to memory at specified address
        end
    end

    assign R_data = memory[addr];

endmodule

module Weight_interface(
    clk,
    reset,
    weight_in,
    push_time,
    push,
    pop,
    pop_complete,
    out1,
    out2,
    out3,
    out4
);

    // Parameters
    parameter Data_size = 8;
    parameter STACK_SIZE = 16;
    reg [Data_size-1:0] stack [STACK_SIZE-1:0]; // Stack to store weights
    reg [Data_size-1:0] count;              // Counter to track inputs and stack index
    input clk;
    input reset;
    input push, pop;
    input [Data_size-1:0] weight_in;            // Assuming 8-bit weights for simplicity
    input [Data_size-1:0] push_time;            // Signal to push weights into the stack
    output reg pop_complete;
    output reg [Data_size-1:0] out1;            // Output 1
    output reg [Data_size-1:0] out2;            // Output 2
    output reg [Data_size-1:0] out3;            // Output 3
    output reg [Data_size-1:0] out4;            // Output 4

    reg [Data_size-1:0] pushtime;
    // Pop sequence control
    reg [Data_size-1:0] pop_count; // Counter to control the pop sequence
    
    // Register pushtime to capture push_time input
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pushtime <= 5'b0;
        end else begin
            pushtime <= push_time;
        end
    end

    // Stack push phase
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0; // Reset the counter
        end else if (push) begin
            stack[count] <= weight_in; // Push the weight into the stack
            count <= count + 1;       // Increment the counter
        end else if (pop_complete) begin
            count <= 0; // Reset the counter
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pop_count <= 0;
            out1 <= 8'b0;
            out2 <= 8'b0;
            out3 <= 8'b0;
            out4 <= 8'b0;
            pop_complete <= 1'b0;
        end else if (pop) begin
            case (pop_count)
                0: begin
                    out4 <= stack[15];
                    out3 <= stack[14];
                    out2 <= stack[13];
                    out1 <= stack[12];
                    pop_complete <= 1'b0;
                end
                1: begin
                    out4 <= stack[11];
                    out3 <= stack[10];
                    out2 <= stack[9];
                    out1 <= stack[8];
                    pop_complete <= 1'b0;
                end
                2: begin
                    out4 <= stack[7];
                    out3 <= stack[6];
                    out2 <= stack[5];
                    out1 <= stack[4];
                    pop_complete <= 1'b0;
                end
                3: begin
                    out4 <= stack[3];
                    out3 <= stack[2];
                    out2 <= stack[1];
                    out1 <= stack[0];
                    pop_complete <= 1'b0;
                end
                4: begin
                    pop_complete <= 1'b1; // Indicate pop sequence is complete
                end
                default: begin
                    out1 <= 8'bx;
                    out2 <= 8'bx;
                    out3 <= 8'bx;
                    out4 <= 8'bx;
                end
            endcase
            pop_count <= pop_count + 1;
        end
    end

endmodule

module Weight_FIFO(clk, rst, buf_in, buf_out, wr_en, rd_en, buf_empty, buf_full, fifo_counter);
    
    parameter Data_size = 8;
    
    input clk, rst, wr_en, rd_en; // clock, reset, write_enable, read_enable
    input [7:0] buf_in; // input buffer
    output [7:0] buf_out; // output buffer
    output buf_empty, buf_full; // check whether buffer is empty or full
    output [7:0] fifo_counter; // check the fifo counter state(how many values had stored in the counter)
                               // must be one more byte
    
    reg [Data_size-1:0] buf_out;
    reg buf_empty, buf_full;
    reg [Data_size-1:0] fifo_counter;
    reg [3:0] rd_ptr, wr_ptr;
    reg [Data_size-1:0] buf_mem[63:0]; // [7:0] means int, and buffer memory [63:0] means we can store up to 64 values in the memory
    
    always @(fifo_counter) begin // check the buffer memory's storage state
        buf_empty = (fifo_counter==0);
        buf_full = (fifo_counter==64);
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            fifo_counter <= 0; //reset counter
        else if ( (!buf_full && wr_en) && (!buf_empty && rd_en) ) // if read and write is doing at the same time
            fifo_counter <= fifo_counter; // counter should remain the same
        else if ( !buf_full && wr_en ) // write one element into the memory
            fifo_counter <= fifo_counter + 1; // counter +1
        else if ( !buf_empty && rd_en ) // reading one element out from the memory
            fifo_counter <= fifo_counter - 1; // counter -1
        else
            fifo_counter <= fifo_counter; // counter stays
    end 
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            buf_out <= 0;
        else begin
            if(rd_en && !buf_empty)
                buf_out <= buf_mem[rd_ptr]; // read one element from the buffer memory
            else
                buf_out <= buf_out;
        end
    end
    
    always @(posedge clk) begin
        if(wr_en && !buf_full)
            buf_mem[wr_ptr] <= buf_in;// write one element into the buffer memory
        else
            buf_mem[wr_ptr] <= buf_mem[wr_ptr];
    end
    
    // pointer tracking 
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
        end
        else begin
            if(!buf_full && wr_en)// head pointer
                wr_ptr <= wr_ptr + 1;
            else
                wr_ptr <= wr_ptr;
            if(!buf_empty && rd_en)// tail pointer
                rd_ptr <= rd_ptr + 1;
            else
                rd_ptr <= rd_ptr;
        end
    end
    
endmodule

//------------------------------MMU related------------------------------//
module row_detector(
    rowsignal, weight_passtime
    );
    parameter BIT_WIDTH = 8;  // Parameter for bit width
    input [BIT_WIDTH-1:0] rowsignal; // for this PE to check what row it is located, 8-bit for expansion to 256x256 MMU
    output reg [BIT_WIDTH-1:0] weight_passtime;
    
    always @(*) begin
       weight_passtime = 8'b00000011 - rowsignal; // Adjust this to match your MMU row logic
    end    
    
endmodule


//--------------- WITH 16'hFFFF protection ---------------//
module systolic_cell(
    clk, rst, row_en, col_en, weight_pass, weight_passtime,
    weightloading, // control signal for the first row to make sure the weights are loaded successfully; 1: loading, 0: completed
    activation_input, weight_input, psum_input, 
    activation_output, sum_output, weight_output
);
    parameter BIT_WIDTH = 8;  // Parameter for bit width
    input [2*BIT_WIDTH-1:0] psum_input;  // Partial sum input
    input [BIT_WIDTH-1:0] activation_input; // Activation input
    input [BIT_WIDTH-1:0] weight_input;  // Weight input
    input [BIT_WIDTH-1:0] weight_passtime; // for PE to check how many times the weight should be passed
    input rst;  // Reset signal
    input clk;  // Clock signal
    input row_en;  // Row enable signal
    input col_en;  // Column enable signal
    input weight_pass;  // Weight pass signal
    output reg weightloading;
    output reg [BIT_WIDTH-1:0] activation_output; // Activation output
    output reg [2*BIT_WIDTH-1:0] sum_output;      // Sum output
    output reg [BIT_WIDTH-1:0] weight_output;     // Weight output

    reg [BIT_WIDTH-1:0] weight_passtime_reg;
    reg [BIT_WIDTH-1:0] weight_reg; // Store the weight in the reg
    reg [2*BIT_WIDTH-1:0] mac_out;  // Register to store MAC result
    
    // Combinational logic for MAC operation and output updates
    always @(*) begin
        // Default: pass through the input partial sum
        mac_out = psum_input;
        weight_passtime_reg = weight_passtime;
        
        // Perform MAC operation only if row and column are enabled
        if (row_en && col_en) begin
            mac_out = (activation_input * weight_reg) + psum_input;
            
            // **Saturation logic**: If the MAC result exceeds 16-bit max value, clamp it
            if (mac_out > 16'hFFFF) begin
                mac_out = 16'hFFFF; // Clamp to maximum value
            end
        end
    end

    // Sequential block for reset and final output
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            activation_output <= 1'b0;
            sum_output <= 1'b0;
            weight_reg <= 1'b0;
            weight_output <= 1'b0;       
        end else if (weight_pass) begin
            if (weight_passtime_reg > 0) begin
                weightloading <= 1'b1;
                weight_output <= weight_input;
                weight_passtime_reg <= weight_passtime_reg - 1;
            end else begin
                weightloading <= 1'b0;
                weight_reg <= weight_input;
                weight_output <= weight_input;
            end
        end else begin
            if (row_en && col_en) begin
                activation_output <= activation_input;
                sum_output <= mac_out; // **Apply saturation logic to sum_output**
            end else begin
                sum_output <= psum_input;
            end
        end
    end
endmodule


module MMU4x4(a1, a2, a3, a4, w1, w2, w3, w4, s_in1, s_in2, s_in3, s_in4, o1, o2, o3, o4, rst, clk, w_pass, weightload_complete, r1_en, r2_en, r3_en, r4_en, c1_en, c2_en, c3_en, c4_en, rowsignal1, rowsignal2, rowsignal3, rowsignal4);
    parameter BIT_WIDTH = 8;
    // declare inputs and outputs ports
    input [BIT_WIDTH-1:0] a1, a2, a3, a4;// activation inputs
    input [BIT_WIDTH-1:0] w1, w2, w3, w4;// weight line inputs
    input [2*BIT_WIDTH-1:0] s_in1, s_in2, s_in3, s_in4;// sum inputs
    input r1_en, r2_en, r3_en, r4_en, c1_en, c2_en, c3_en, c4_en; // row and colum input
    input [BIT_WIDTH-1:0] rowsignal1, rowsignal2, rowsignal3, rowsignal4;
    input clk, rst, w_pass;
    output wire [2*BIT_WIDTH-1:0] o1, o2, o3, o4; // activation_output
    output reg weightload_complete; // 1: complete, 0: still loading
    
    //internal wires
    // vertical conntect
    // wires for passing in sum  ([n-1]*n => 3x4=12)
    wire [2*BIT_WIDTH-1:0] s_11_21, s_21_31, s_31_41, s_12_22, s_22_32, s_32_42, s_13_23, s_23_33, s_33_43, s_14_24, s_24_34, s_34_44;
    // wires for passing weights
    wire [BIT_WIDTH-1:0]  w_11_21, w_21_31, w_31_41, w_12_22, w_22_32, w_32_42, w_13_23, w_23_33, w_33_43, w_14_24, w_24_34, w_34_44;
    
    // wires for passing activations
    // horizontal conntect
    wire [BIT_WIDTH-1:0] a_11_12, a_12_13, a_13_14, a_21_22, a_22_23, a_23_24, a_31_32, a_32_33, a_33_34, a_41_42, a_42_43, a_43_44;
    
    wire weightloading1, weightloading2, weightloading3, weightloading4; // weightloading control signal for the first row
    wire [BIT_WIDTH-1:0] weight_passtime1, weight_passtime2, weight_passtime3, weight_passtime4; // from row detector
    
    always @(*) begin
        if (weightloading1 || weightloading2 || weightloading3 || weightloading4) begin
            weightload_complete <= 1'b0; // Not complete if any cell in row 1 is still loading
        end else begin
            weightload_complete <= 1'b1; // Complete when all cells in row 1 are done loading
            end
        end 
    
    //--------------------------------ROW1--------------------------------//
    row_detector u1(
    .rowsignal(rowsignal1), .weight_passtime(weight_passtime1)
    );
    
    //--------------------------------ROW2--------------------------------//
    row_detector u2(
    .rowsignal(rowsignal2), .weight_passtime(weight_passtime2)
    );
    
    //--------------------------------ROW3--------------------------------//
    row_detector u3(
    .rowsignal(rowsignal3), .weight_passtime(weight_passtime3)
    );
    
    //--------------------------------ROW4--------------------------------//
    row_detector u4(
    .rowsignal(rowsignal4), .weight_passtime(weight_passtime4)
    );
    
    //--------------------------------COL 1--------------------------------//
    systolic_cell pe11(
    .clk(clk), .rst(rst), .row_en(r1_en), .col_en(c1_en), .weight_pass(w_pass), 
    .weight_passtime(weight_passtime1), .weightloading(weightloading1),
    .activation_input(a1), .weight_input(w1), .psum_input(s_in1), 
    .activation_output(a_11_12), .sum_output(s_11_21), .weight_output(w_11_21)
    );
    
    systolic_cell pe21(
    .clk(clk), .rst(rst), .row_en(r2_en), .col_en(c1_en), .weight_pass(w_pass), 
    .weight_passtime(weight_passtime2), .weightloading(weightloading2),
    .activation_input(a2), .weight_input(w_11_21), .psum_input(s_11_21), 
    .activation_output(a_21_22), .sum_output(s_21_31), .weight_output(w_21_31)
    );
    
    systolic_cell pe31(
    .clk(clk), .rst(rst), .row_en(r3_en), .col_en(c1_en), .weight_pass(w_pass),
    .weight_passtime(weight_passtime3), .weightloading(weightloading3), 
    .activation_input(a3), .weight_input(w_21_31), .psum_input(s_21_31), 
    .activation_output(a_31_32), .sum_output(s_31_41), .weight_output(w_31_41)
    );
    
    systolic_cell pe41(
    .clk(clk), .rst(rst), .row_en(r4_en), .col_en(c1_en), .weight_pass(w_pass),
    .weight_passtime(weight_passtime4), .weightloading(weightloading4), 
    .activation_input(a4), .weight_input(w_31_41), .psum_input(s_31_41), 
    .activation_output(a_41_42), .sum_output(o1), .weight_output()
    );
    
    
    //--------------------------------COL 2--------------------------------//
    systolic_cell pe12(
    .clk(clk), .rst(rst), .row_en(r1_en), .col_en(c2_en), .weight_pass(w_pass),
    .weight_passtime(weight_passtime1), .weightloading(), 
    .activation_input(a_11_12), .weight_input(w2), .psum_input(s_in2), 
    .activation_output(a_12_13), .sum_output(s_12_22), .weight_output(w_12_22)
    );
    
    systolic_cell pe22(
    .clk(clk), .rst(rst), .row_en(r2_en), .col_en(c2_en), .weight_pass(w_pass),
    .weight_passtime(weight_passtime2), .weightloading(), 
    .activation_input(a_21_22), .weight_input(w_12_22), .psum_input(s_12_22), 
    .activation_output(a_22_23), .sum_output(s_22_32), .weight_output(w_22_32)
    );
    
    systolic_cell pe32(
    .clk(clk), .rst(rst), .row_en(r3_en), .col_en(c2_en), .weight_pass(w_pass),
    .weight_passtime(weight_passtime3), .weightloading(),
    .activation_input(a_31_32), .weight_input(w_22_32), .psum_input(s_22_32), 
    .activation_output(a_32_33), .sum_output(s_32_42), .weight_output(w_32_42)
    );
    
    systolic_cell pe42(
    .clk(clk), .rst(rst), .row_en(r4_en), .col_en(c2_en), .weight_pass(w_pass), 
    .weight_passtime(weight_passtime4), .weightloading(),
    .activation_input(a_41_42), .weight_input(w_32_42), .psum_input(s_32_42), 
    .activation_output(a_42_43), .sum_output(o2), .weight_output()
    );
    
    //--------------------------------COL 3--------------------------------//
    systolic_cell pe13(
    .clk(clk), .rst(rst), .row_en(r1_en), .col_en(c3_en), .weight_pass(w_pass),
    .weight_passtime(weight_passtime1), .weightloading(), 
    .activation_input(a_12_13), .weight_input(w3), .psum_input(s_in3), 
    .activation_output(a_13_14), .sum_output(s_13_23), .weight_output(w_13_23)
    );
    
    systolic_cell pe23(
    .clk(clk), .rst(rst), .row_en(r2_en), .col_en(c3_en), .weight_pass(w_pass), 
    .weight_passtime(weight_passtime2), .weightloading(),
    .activation_input(a_22_23), .weight_input(w_13_23), .psum_input(s_13_23), 
    .activation_output(a_23_24), .sum_output(s_23_33), .weight_output(w_23_33)
    );
    
    systolic_cell pe33(
    .clk(clk), .rst(rst), .row_en(r3_en), .col_en(c3_en), .weight_pass(w_pass),
    .weight_passtime(weight_passtime3), .weightloading(), 
    .activation_input(a_32_33), .weight_input(w_23_33), .psum_input(s_23_33), 
    .activation_output(a_33_34), .sum_output(s_33_43), .weight_output(w_33_43)
    );
    
    systolic_cell pe43(
    .clk(clk), .rst(rst), .row_en(r4_en), .col_en(c3_en), .weight_pass(w_pass),
    .weight_passtime(weight_passtime4), .weightloading(),
    .activation_input(a_42_43), .weight_input(w_33_43), .psum_input(s_33_43), 
    .activation_output(a_43_44), .sum_output(o3), .weight_output()
    );
    
    //--------------------------------COL 4--------------------------------//
    systolic_cell pe14(
    .clk(clk), .rst(rst), .row_en(r1_en), .col_en(c4_en), .weight_pass(w_pass),
    .weight_passtime(weight_passtime1), .weightloading(), 
    .activation_input(a_13_14), .weight_input(w4), .psum_input(s_in4), 
    .activation_output(), .sum_output(s_14_24), .weight_output(w_14_24)
    );
    
    systolic_cell pe24(
    .clk(clk), .rst(rst), .row_en(r2_en), .col_en(c4_en), .weight_pass(w_pass), 
    .weight_passtime(weight_passtime2), .weightloading(),
    .activation_input(a_23_24), .weight_input(w_14_24), .psum_input(s_14_24), 
    .activation_output(), .sum_output(s_24_34), .weight_output(w_24_34)
    );
    
    systolic_cell pe34(
    .clk(clk), .rst(rst), .row_en(r3_en), .col_en(c4_en), .weight_pass(w_pass), 
    .weight_passtime(weight_passtime3), .weightloading(),
    .activation_input(a_33_34), .weight_input(w_24_34), .psum_input(s_24_34), 
    .activation_output(), .sum_output(s_34_44), .weight_output(w_34_44)
    );
    
    systolic_cell pe44(
    .clk(clk), .rst(rst), .row_en(r4_en), .col_en(c4_en), .weight_pass(w_pass), 
    .weight_passtime(weight_passtime4), .weightloading(),
    .activation_input(a_43_44), .weight_input(w_34_44), .psum_input(s_34_44), 
    .activation_output(), .sum_output(o4), .weight_output()
    );

endmodule

//------------------------------Other Computation related------------------------------//
//------------------------------before MMU------------------------------//
module unified_buffer(
    addr, // maybe for host memory to transfer data
    clk, 
    rd, // read_enable = 1, data goes from UB to SDS
    wr, // write_enable =1, data goes from NU to UB
    Host_rd, // Host_rd = 1, data goes from UB to L1_Host_Memory 
    Host_wr, // Host_wr = 1, data goes from L1_Host_Memory to UB
    Host_datain,
    Host_dataout,
    counter_rst, // reset the counter i for data storage address reorient
    data_in1, data_in2, data_in3, data_in4, // data in from NU
    // data out that goes to SDS
    data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7, data_out8, 
    data_out9, data_out10, data_out11, data_out12, data_out13, data_out14, data_out15, data_out16
    );
    parameter BIT_WIDTH = 8;
    parameter address_size = 4;
    parameter word_size = 8;
    parameter memory_size = 16;
    // input from normalization unit
    input [word_size-1:0] data_in1, data_in2, data_in3, data_in4;
    // output to sds
    output reg [word_size-1:0] data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7, data_out8, data_out9, data_out10, data_out11, data_out12, data_out13, data_out14, data_out15, data_out16;
    // input [word_size-1:0] W_data;
    input [address_size-1:0] addr;
    input counter_rst; // rst the counter i
    input clk;
    input rd, wr; // read to sds, write from normalization unit
    input Host_rd, Host_wr;
    input [word_size-1:0] Host_datain;
    output reg [word_size-1:0] Host_dataout;
    reg [word_size-1:0] memory [memory_size-1:0]; // 16
    
    reg [BIT_WIDTH-1:0] i;
    
    // Reset counter when counter_rst switches from 0 to 1
    always @(posedge clk) begin
        if (counter_rst) begin
            i <= 0;
        end 
        else begin
            i <= i + 1;
        end
    end
    
    // Memory write and read control
    always @(posedge clk) begin
        if (wr && !rd) begin
            case (i)
                3'd0: begin
                      memory[0] <= data_in1;
                      memory[1] <= data_in2;
                      memory[2] <= data_in3;
                      memory[3] <= data_in4;
                      end
                3'd1: begin
                      memory[4] <= data_in1;
                      memory[5] <= data_in2;
                      memory[6] <= data_in3;
                      memory[7] <= data_in4;
                      end
                3'd2: begin
                      memory[8] <= data_in1;
                      memory[9] <= data_in2;
                      memory[10] <= data_in3;
                      memory[11] <= data_in4;
                      end
                3'd3: begin
                      memory[12] <= data_in1;
                      memory[13] <= data_in2;
                      memory[14] <= data_in3;
                      memory[15] <= data_in4; // Final expected write to memory[15]
                      end
                default: ; // No action, ensuring no unintended overwrites
            endcase
        end 
        else if (rd && !wr) begin
            // Assign outputs based on memory values
            data_out1 <= memory[0];
            data_out2 <= memory[1];
            data_out3 <= memory[2];
            data_out4 <= memory[3];
            data_out5 <= memory[4];
            data_out6 <= memory[5];
            data_out7 <= memory[6];
            data_out8 <= memory[7];
            data_out9 <= memory[8];
            data_out10 <= memory[9];
            data_out11 <= memory[10];
            data_out12 <= memory[11];
            data_out13 <= memory[12];
            data_out14 <= memory[13];
            data_out15 <= memory[14];
            data_out16 <= memory[15];
        end else if (Host_wr) begin
            memory[addr] <= Host_datain;
        end else if (Host_rd) begin
            Host_dataout <= memory[addr];
        end   
    end

endmodule


module sds4x4(
    clk,
    counter_rst, sds_work,
    a0, a1, a2, a3, b0, b1, b2, b3, c0, c1, c2, c3, d0, d1, d2, d3,
    output1, output2, output3, output4
);
    parameter BIT_WIDTH = 8;  // Parameter for bit width
    // clock
    input clk;
    // counter reset signal (from control signal, reset the integer i used in this component)
    input counter_rst;
    input sds_work;
    //8 inputs, each contains 4 bits
    input [BIT_WIDTH-1:0] a0, a1, a2, a3, b0, b1, b2, b3, c0, c1, c2, c3, d0, d1, d2, d3;
    //256 outputs for the data rearrangement
    output reg [BIT_WIDTH-1:0] output1;
    output reg [BIT_WIDTH-1:0] output2;
    output reg [BIT_WIDTH-1:0] output3;
    output reg [BIT_WIDTH-1:0] output4;
    
    reg [BIT_WIDTH-1:0] i;
    
    // Reset counter when counter_rst switches from 0 to 1
    always @(posedge clk) begin
        if (counter_rst) begin
            i <= 0;
        end 
        else if (sds_work) begin
            i <= i + 1;
        end
    end

   // Output control based on the cycle counter
    always @(posedge clk) begin
        if (sds_work) begin
            case (i)
                3'd0: begin    
                    output1 <= a0;
//                    output2 <= 8'b0;
//                    output3 <= 8'b0;
//                    output4 <= 8'b0;
                end
                3'd1: begin
                    output1 <= b0;
                    output2 <= a1;
                    output3 <= 8'b0;
                    output4 <= 8'b0;
                end
                3'd2: begin
                    output1 <= c0;
                    output2 <= b1;
                    output3 <= a2;
                    output4 <= 8'b0;
                end
                3'd3: begin
                    output1 <= d0;
                    output2 <= c1;
                    output3 <= b2;
                    output4 <= a3;
                end
                3'd4: begin
                    output1 <= 8'b0;
                    output2 <= d1;
                    output3 <= c2;
                    output4 <= b3;
                end
                3'd5: begin
                    output1 <= 8'b0;
                    output2 <= 8'b0;
                    output3 <= d2;
                    output4 <= c3;
                end
                3'd6: begin
                    output1 <= 8'b0;
                    output2 <= 8'b0;
                    output3 <= 8'b0;
                    output4 <= d3;
                end
                default: begin
                    output1 <= 8'b0;
                    output2 <= 8'b0;
                    output3 <= 8'b0;
                    output4 <= 8'b0;
                end
            endcase
        end
    end
endmodule

module Activation_FIFO(clk, rst, buf_in, buf_out, wr_en, rd_en, buf_empty, buf_full, fifo_counter);

    parameter Data_size = 8;
    
    input clk, rst, wr_en, rd_en; // clock, reset, write_enable, read_enable
    input [7:0] buf_in; // input buffer
    output [7:0] buf_out; // output buffer
    output buf_empty, buf_full; // check whether buffer is empty or full
    output [7:0] fifo_counter; // check the fifo counter state(how many values had stored in the counter)
                               // must be one more byte
    
    reg [Data_size-1:0] buf_out;
    reg buf_empty, buf_full;
    reg [Data_size-1:0] fifo_counter;
    reg [3:0] rd_ptr, wr_ptr;
    reg [Data_size-1:0] buf_mem[63:0]; // [7:0] means int, and buffer memory [63:0] means we can store up to 64 values in the memory
    
    always @(fifo_counter) begin // check the buffer memory's storage state
        buf_empty = (fifo_counter==0);
        buf_full = (fifo_counter==64);
    end
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            fifo_counter <= 0; //reset counter
        else if ( (!buf_full && wr_en) && (!buf_empty && rd_en) ) // if read and write is doing at the same time
            fifo_counter <= fifo_counter; // counter should remain the same
        else if ( !buf_full && wr_en ) // write one element into the memory
            fifo_counter <= fifo_counter + 1; // counter +1
        else if ( !buf_empty && rd_en ) // reading one element out from the memory
            fifo_counter <= fifo_counter - 1; // counter -1
        else
            fifo_counter <= fifo_counter; // counter stays
    end 
    
    always @(posedge clk or posedge rst) begin
        if(rst)
            buf_out <= 0;
        else begin
            if(rd_en && !buf_empty)
                buf_out <= buf_mem[rd_ptr]; // read one element from the buffer memory
            else
                buf_out <= buf_out;
        end
    end
    
    always @(posedge clk) begin
        if(wr_en && !buf_full)
            buf_mem[wr_ptr] <= buf_in;// write one element into the buffer memory
        else
            buf_mem[wr_ptr] <= buf_mem[wr_ptr];
    end
    
    // pointer tracking 
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
        end
        else begin
            if(!buf_full && wr_en) begin// head pointer          
                wr_ptr <= wr_ptr + 1;
            end
            else
                wr_ptr <= wr_ptr;
            if(!buf_empty && rd_en) begin// tail pointer
                rd_ptr <= rd_ptr + 1;
            end
            else
                rd_ptr <= rd_ptr;
        end
    end
    
endmodule

//------------------------------After MMU------------------------------//
module Accumulator4x4(
    MMU_size,
    write_enable,
    read_enable,
    Acuumulator_sendto_AN_enable,
    Vecwise_out1, Vecwise_out2, Vecwise_out3, Vecwise_out4, Matwise_out, 
    in1, in2, in3, in4,
    out1, out2, out3, out4,
    accumulator_finish_storing,
    reset_accumulator_finish_storing,
    tiled_computing_sig, tiled_MM_storing_complete,
    clk, rst
);
    parameter BIT_WIDTH   = 8;   // Width of MMU_size
    parameter word_size   = 16;  // Each input is 16 bits wide (2*BIT_WIDTH)
    parameter memory_size = 4;   // Store up to 4 rows
    parameter tiled_MM_memory_size = 16;

    // I/O
    input [BIT_WIDTH-1:0] MMU_size;  
    input [word_size-1:0] in1, in2, in3, in4;
    input clk, rst;
    input write_enable, read_enable;
    input Acuumulator_sendto_AN_enable;
    input tiled_computing_sig;
    output reg [word_size-1:0] Vecwise_out1, Vecwise_out2, Vecwise_out3, Vecwise_out4, Matwise_out;
    output reg [word_size-1:0] out1, out2, out3, out4;
    output reg accumulator_finish_storing;
    input reset_accumulator_finish_storing;
    output reg tiled_MM_storing_complete;
    
    reg tiled_computing_sig_reg;
    reg [BIT_WIDTH-1:0] tiled_computing_storing_cycle_count;

    // Internal Memory Arrays (4 arrays x memory_size)
    reg [word_size-1:0] memory1 [memory_size-1:0];
    reg [word_size-1:0] memory2 [memory_size-1:0];
    reg [word_size-1:0] memory3 [memory_size-1:0];
    reg [word_size-1:0] memory4 [memory_size-1:0];
    
    // for Tiled MM Temp regs and Memory Arrays
    reg [word_size-1:0] Temp1, Temp2, Temp3, Temp4, Temp5, Temp6, Temp7, Temp8, Temp9, Temp10, Temp11, Temp12, Temp13, Temp14, Temp15, Temp16;
    reg [word_size-1:0] Temp17, Temp18, Temp19, Temp20, Temp21, Temp22, Temp23, Temp24, Temp25, Temp26, Temp27, Temp28, Temp29, Temp30, Temp31, Temp32;
    reg [word_size-1:0] TMM_memory1 [tiled_MM_memory_size-1:0];
    reg [word_size-1:0] TMM_memory2 [tiled_MM_memory_size-1:0];
    reg [word_size-1:0] TMM_memory3 [tiled_MM_memory_size-1:0];
    reg [word_size-1:0] TMM_memory4 [tiled_MM_memory_size-1:0];

    // Cycle counters for controlling storage
    reg [BIT_WIDTH-1:0] cycle_count1, cycle_count2, cycle_count3, cycle_count4, cycle_count5, cycle_count6, cycle_count7, cycle_count8; 

    // Read logic: read_index for reading out stored values  
    reg [word_size-1:0] round_counter;

    // Vectorwise and Matrixwise Maximums
    reg [word_size-1:0] Vectorwise_MaxVal_r1, Vectorwise_MaxVal_r2, Vectorwise_MaxVal_r3, Vectorwise_MaxVal_r4, Vectorwise_MaxVal_r5, Vectorwise_MaxVal_r6, Vectorwise_MaxVal_r7, Vectorwise_MaxVal_r8;
    reg [word_size-1:0] Matrixwise_MaxVal;

    // row_compare_index: track which row (0..3) is being compared
    reg [word_size-1:0] row_compare_index;
    
    // Column wise
    reg [word_size-1:0] compareVal1, compareVal2, compareVal3, compareVal4, compareVal5, compareVal6, compareVal7, compareVal8; // Compare Value for rowN in memory[N]
    reg [word_size-1:0] max_1or2, max_3or4, max_5or6, max_7or8, maxAll; // local compare signals
    // Row wise
    reg [word_size-1:0] max_row12, max_row34, max_row56, max_row78; // Compare row1 and 2, row3 and 4, to do the final comparison later for the Matrixwise MaxVal
    
    always @(*) begin
        tiled_computing_sig_reg = tiled_computing_sig;
    end
    
    //-------------------------------------------
    // 1) Write Logic + Vectorwise Compare
    //-------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            // Reset counters, flags, etc.
            cycle_count1 <= 0;
            cycle_count2 <= 0;
            cycle_count3 <= 0;
            cycle_count4 <= 0;
            cycle_count5 <= 0; // For Tiled MM purpose
            cycle_count6 <= 0;
            cycle_count7 <= 0;
            cycle_count8 <= 0;
            accumulator_finish_storing <= 1'b0;
            round_counter <= 0;
            tiled_computing_storing_cycle_count <= 0;
            tiled_MM_storing_complete <= 1'b0;

            // Reset comparison tracking
            row_compare_index   <= 0;
            Vectorwise_MaxVal_r1 <= 0;
            Vectorwise_MaxVal_r2 <= 0;
            Vectorwise_MaxVal_r3 <= 0;
            Vectorwise_MaxVal_r4 <= 0;
            Vectorwise_MaxVal_r5 <= 0; // For Tiled MM purpose
            Vectorwise_MaxVal_r6 <= 0;
            Vectorwise_MaxVal_r7 <= 0;
            Vectorwise_MaxVal_r8 <= 0;
            Matrixwise_MaxVal    <= 0;
            
        end else if (reset_accumulator_finish_storing) begin // rst accumulator_finish_storing
            accumulator_finish_storing <= 1'b0;
            cycle_count1 <= 0;
            cycle_count2 <= 0;
            cycle_count3 <= 0;
            cycle_count4 <= 0;
            cycle_count5 <= 0; // For Tiled MM purpose
            cycle_count6 <= 0;
            cycle_count7 <= 0;
            cycle_count8 <= 0;
        end else if (Acuumulator_sendto_AN_enable) begin
            round_counter <= round_counter + 1; // increment the round_counter for reading out to AN_Unit
        end else if (write_enable && !tiled_computing_sig_reg) begin
            // A) Increment cycle counters up to (MMU_size + offset)
            if (cycle_count1 < (MMU_size + 5)) cycle_count1 <= cycle_count1 + 1;
            if (cycle_count2 < (MMU_size + 6)) cycle_count2 <= cycle_count2 + 1;
            if (cycle_count3 < (MMU_size + 7)) cycle_count3 <= cycle_count3 + 1;
            if (cycle_count4 < (MMU_size + 8)) cycle_count4 <= cycle_count4 + 1;
            if (cycle_count5 < (MMU_size + 9)) cycle_count5 <= cycle_count5 + 1; // For Tiled MM purpose
            if (cycle_count6 < (MMU_size + 10)) cycle_count6 <= cycle_count6 + 1;
            if (cycle_count7 < (MMU_size + 11)) cycle_count7 <= cycle_count7 + 1;
            if (cycle_count8 < (MMU_size + 12)) cycle_count8 <= cycle_count8 + 1;
            

            // B) Store inputs into local memories
            if (cycle_count1 >= 5 && cycle_count1 < (5 + MMU_size)) 
                memory1[cycle_count1 - 5] <= in1;

            if (cycle_count2 >= 6 && cycle_count2 < (6 + MMU_size)) 
                memory2[cycle_count2 - 6] <= in2;

            if (cycle_count3 >= 7 && cycle_count3 < (7 + MMU_size)) 
                memory3[cycle_count3 - 7] <= in3;

            if (cycle_count4 >= 8 && cycle_count4 < (8 + MMU_size)) 
                memory4[cycle_count4 - 8] <= in4;

            // C) Check finish storing
            if ((cycle_count1 >= MMU_size + 4) &&
                (cycle_count2 >= MMU_size + 5) &&
                (cycle_count3 >= MMU_size + 6) &&
                (cycle_count4 >= MMU_size + 7)) 
            begin
                accumulator_finish_storing <= 1'b1;
            end
            
            end else if (write_enable && tiled_computing_sig_reg) begin
            case(tiled_computing_storing_cycle_count)
                0: begin
                    // A) Increment cycle counters up to (MMU_size + offset)
                    if (cycle_count1 < (MMU_size + 5)) cycle_count1 <= cycle_count1 + 1;
                    if (cycle_count2 < (MMU_size + 6)) cycle_count2 <= cycle_count2 + 1;
                    if (cycle_count3 < (MMU_size + 7)) cycle_count3 <= cycle_count3 + 1;
                    if (cycle_count4 < (MMU_size + 8)) cycle_count4 <= cycle_count4 + 1;
                    if (cycle_count5 < (MMU_size + 9)) cycle_count5 <= cycle_count5 + 1; // For Tiled MM purpose
                    if (cycle_count6 < (MMU_size + 10)) cycle_count6 <= cycle_count6 + 1;
                    if (cycle_count7 < (MMU_size + 11)) cycle_count7 <= cycle_count7 + 1;
                    if (cycle_count8 < (MMU_size + 12)) cycle_count8 <= cycle_count8 + 1;
                    
                    // B) Store inputs into local Tiled MM memories
                    case (cycle_count1)
                        5:  Temp1  <= in1;
                        6:  Temp5  <= in1;
                        7:  Temp9  <= in1;
                        8:  Temp13 <= in1;
                    endcase
                
                    case (cycle_count2)
                        6:  Temp2  <= in2;
                        7:  Temp6  <= in2;
                        8:  Temp10  <= in2;
                        9:  Temp14  <= in2;
                    endcase
                
                    case (cycle_count3)
                        7:  Temp3  <= in3;
                        8:  Temp7  <= in3;
                        9:  Temp11  <= in3;
                       10:  Temp15  <= in3;
                    endcase
                
                    case (cycle_count4)
                        8:  Temp4  <= in4;
                        9:  Temp8  <= in4;
                       10:  Temp12  <= in4;
                       11:  Temp16  <= in4;
                    endcase
                    
                    // C) Check finish storing
                    if ((cycle_count1 >= MMU_size + 4) &&
                        (cycle_count2 >= MMU_size + 5) &&
                        (cycle_count3 >= MMU_size + 6) &&
                        (cycle_count4 >= MMU_size + 7)) 
                    begin
                        accumulator_finish_storing <= 1'b1;
                        tiled_computing_storing_cycle_count <= tiled_computing_storing_cycle_count + 8'b00000001;
                        tiled_MM_storing_complete <= 1'b0;
                    end
                end
                1: begin
                    // A) Increment cycle counters up to (MMU_size + offset)
                    if (cycle_count1 < (MMU_size + 5)) cycle_count1 <= cycle_count1 + 1;
                    if (cycle_count2 < (MMU_size + 6)) cycle_count2 <= cycle_count2 + 1;
                    if (cycle_count3 < (MMU_size + 7)) cycle_count3 <= cycle_count3 + 1;
                    if (cycle_count4 < (MMU_size + 8)) cycle_count4 <= cycle_count4 + 1;
                    if (cycle_count5 < (MMU_size + 9)) cycle_count5 <= cycle_count5 + 1; // For Tiled MM purpose
                    if (cycle_count6 < (MMU_size + 10)) cycle_count6 <= cycle_count6 + 1;
                    if (cycle_count7 < (MMU_size + 11)) cycle_count7 <= cycle_count7 + 1;
                    if (cycle_count8 < (MMU_size + 12)) cycle_count8 <= cycle_count8 + 1;
                    
                    // B) Store inputs into local Tiled MM memories
                    case (cycle_count1)
                        5:  Temp17  <= in1;
                        6:  Temp21  <= in1;
                        7:  Temp25  <= in1;
                        8:  Temp29 <= in1;
                    endcase
                
                    case (cycle_count2)
                        6:  Temp18  <= in2;
                        7:  Temp22  <= in2;
                        8:  Temp26  <= in2;
                        9:  Temp30  <= in2;
                    endcase
                
                    case (cycle_count3)
                        7:  Temp19  <= in3;
                        8:  Temp23  <= in3;
                        9:  Temp27  <= in3;
                       10:  Temp31  <= in3;
                    endcase
                
                    case (cycle_count4)
                        8:  Temp20  <= in4;
                        9:  Temp24  <= in4;
                       10:  Temp28  <= in4;
                       11:  Temp32  <= in4;
                    endcase
                    
                    // C) Check finish storing
                    if ((cycle_count1 >= MMU_size + 4) &&
                        (cycle_count2 >= MMU_size + 5) &&
                        (cycle_count3 >= MMU_size + 6) &&
                        (cycle_count4 >= MMU_size + 7)) 
                    begin
                        accumulator_finish_storing <= 1'b1;
                        tiled_computing_storing_cycle_count <= tiled_computing_storing_cycle_count + 1;
                        tiled_MM_storing_complete <= 1'b0;
                    end
                end
                2: begin
                    // A) Increment cycle counters up to (MMU_size + offset)
                    if (cycle_count1 < (MMU_size + 5)) cycle_count1 <= cycle_count1 + 1;
                    if (cycle_count2 < (MMU_size + 6)) cycle_count2 <= cycle_count2 + 1;
                    if (cycle_count3 < (MMU_size + 7)) cycle_count3 <= cycle_count3 + 1;
                    if (cycle_count4 < (MMU_size + 8)) cycle_count4 <= cycle_count4 + 1;
                    if (cycle_count5 < (MMU_size + 9)) cycle_count5 <= cycle_count5 + 1; // For Tiled MM purpose
                    if (cycle_count6 < (MMU_size + 10)) cycle_count6 <= cycle_count6 + 1;
                    if (cycle_count7 < (MMU_size + 11)) cycle_count7 <= cycle_count7 + 1;
                    if (cycle_count8 < (MMU_size + 12)) cycle_count8 <= cycle_count8 + 1;
                    
                    // B) Store inputs into local Tiled MM memories
                    case (cycle_count1)
                        5:  TMM_memory1[0]   <= (in1  + Temp1  > 65535) ? 16'hFFFF : (in1  + Temp1);  
                        6:  TMM_memory1[4]   <= (in1  + Temp5  > 65535) ? 16'hFFFF : (in1  + Temp5);  
                        7:  TMM_memory1[8]   <= (in1  + Temp9  > 65535) ? 16'hFFFF : (in1  + Temp9);  
                        8:  TMM_memory1[12]  <= (in1  + Temp13  > 65535) ? 16'hFFFF : (in1  + Temp13);  
                    endcase
                
                    case (cycle_count2)
                        6:  TMM_memory1[1]   <= (in2  + Temp2  > 65535) ? 16'hFFFF : (in2  + Temp2);  
                        7:  TMM_memory1[5]   <= (in2  + Temp6  > 65535) ? 16'hFFFF : (in2  + Temp6);  
                        8:  TMM_memory1[9]   <= (in2  + Temp10  > 65535) ? 16'hFFFF : (in2  + Temp10);  
                        9:  TMM_memory1[13]  <= (in2  + Temp14  > 65535) ? 16'hFFFF : (in2  + Temp14);  
                    endcase
                
                    case (cycle_count3)
                        7:  TMM_memory1[2]   <= (in3  + Temp3  > 65535) ? 16'hFFFF : (in3  + Temp3);  
                        8:  TMM_memory1[6]   <= (in3  + Temp7  > 65535) ? 16'hFFFF : (in3  + Temp7);  
                        9:  TMM_memory1[10]  <= (in3  + Temp11  > 65535) ? 16'hFFFF : (in3  + Temp11);  
                       10:  TMM_memory1[14]  <= (in3  + Temp15  > 65535) ? 16'hFFFF : (in3  + Temp15);  
                    endcase
                
                    case (cycle_count4)
                        8:  TMM_memory1[3]   <= (in4  + Temp4  > 65535) ? 16'hFFFF : (in4  + Temp4);  
                        9:  TMM_memory1[7]   <= (in4  + Temp8  > 65535) ? 16'hFFFF : (in4  + Temp8);  
                       10:  TMM_memory1[11]  <= (in4  + Temp12  > 65535) ? 16'hFFFF : (in4  + Temp12);  
                       11:  TMM_memory1[15]  <= (in4  + Temp16  > 65535) ? 16'hFFFF : (in4  + Temp16);  
                    endcase
                    
                    // C) Check finish storing
                    if ((cycle_count1 >= MMU_size + 4) &&
                        (cycle_count2 >= MMU_size + 5) &&
                        (cycle_count3 >= MMU_size + 6) &&
                        (cycle_count4 >= MMU_size + 7)) 
                    begin
                        accumulator_finish_storing <= 1'b1;
                        tiled_computing_storing_cycle_count <= tiled_computing_storing_cycle_count + 1;
                        tiled_MM_storing_complete <= 1'b0;
                    end
                end
                3: begin
                    // A) Increment cycle counters up to (MMU_size + offset)
                    if (cycle_count1 < (MMU_size + 5)) cycle_count1 <= cycle_count1 + 1;
                    if (cycle_count2 < (MMU_size + 6)) cycle_count2 <= cycle_count2 + 1;
                    if (cycle_count3 < (MMU_size + 7)) cycle_count3 <= cycle_count3 + 1;
                    if (cycle_count4 < (MMU_size + 8)) cycle_count4 <= cycle_count4 + 1;
                    if (cycle_count5 < (MMU_size + 9)) cycle_count5 <= cycle_count5 + 1; // For Tiled MM purpose
                    if (cycle_count6 < (MMU_size + 10)) cycle_count6 <= cycle_count6 + 1;
                    if (cycle_count7 < (MMU_size + 11)) cycle_count7 <= cycle_count7 + 1;
                    if (cycle_count8 < (MMU_size + 12)) cycle_count8 <= cycle_count8 + 1;
                    
                    // B) Store inputs into local Tiled MM memories
                    case (cycle_count1)
                        5:  TMM_memory2[0]   <= (in1  + Temp17  > 65535) ? 16'hFFFF : (in1  + Temp17);  
                        6:  TMM_memory2[4]   <= (in1  + Temp21  > 65535) ? 16'hFFFF : (in1  + Temp21);  
                        7:  TMM_memory2[8]   <= (in1  + Temp25  > 65535) ? 16'hFFFF : (in1  + Temp25);  
                        8:  TMM_memory2[12]  <= (in1  + Temp29  > 65535) ? 16'hFFFF : (in1  + Temp29);  
                    endcase
                
                    case (cycle_count2)
                        6:  TMM_memory2[1]   <= (in2  + Temp18  > 65535) ? 16'hFFFF : (in2  + Temp18);  
                        7:  TMM_memory2[5]   <= (in2  + Temp22  > 65535) ? 16'hFFFF : (in2  + Temp22);  
                        8:  TMM_memory2[9]   <= (in2  + Temp26  > 65535) ? 16'hFFFF : (in2  + Temp26);  
                        9:  TMM_memory2[13]  <= (in2  + Temp30  > 65535) ? 16'hFFFF : (in2  + Temp30);  
                    endcase
                
                    case (cycle_count3)
                        7:  TMM_memory2[2]   <= (in3  + Temp19  > 65535) ? 16'hFFFF : (in3  + Temp19);  
                        8:  TMM_memory2[6]   <= (in3  + Temp23  > 65535) ? 16'hFFFF : (in3  + Temp23);  
                        9:  TMM_memory2[10]  <= (in3  + Temp27  > 65535) ? 16'hFFFF : (in3  + Temp27);  
                       10:  TMM_memory2[14]  <= (in3  + Temp31  > 65535) ? 16'hFFFF : (in3  + Temp31);  
                    endcase
                
                    case (cycle_count4)
                        8:  TMM_memory2[3]   <= (in4  + Temp20  > 65535) ? 16'hFFFF : (in4  + Temp20);  
                        9:  TMM_memory2[7]   <= (in4  + Temp24  > 65535) ? 16'hFFFF : (in4  + Temp24);  
                       10:  TMM_memory2[11]  <= (in4  + Temp28  > 65535) ? 16'hFFFF : (in4  + Temp28);  
                       11:  TMM_memory2[15]  <= (in4  + Temp32  > 65535) ? 16'hFFFF : (in4  + Temp32);  
                    endcase
                    
                    // C) Check finish storing
                    if ((cycle_count1 >= MMU_size + 4) &&
                        (cycle_count2 >= MMU_size + 5) &&
                        (cycle_count3 >= MMU_size + 6) &&
                        (cycle_count4 >= MMU_size + 7)) 
                    begin
                        accumulator_finish_storing <= 1'b1;
                        tiled_computing_storing_cycle_count <= tiled_computing_storing_cycle_count + 1;
                        tiled_MM_storing_complete <= 1'b0;
                    end
                end
                4: begin
                    // A) Increment cycle counters up to (MMU_size + offset)
                    if (cycle_count1 < (MMU_size + 5)) cycle_count1 <= cycle_count1 + 1;
                    if (cycle_count2 < (MMU_size + 6)) cycle_count2 <= cycle_count2 + 1;
                    if (cycle_count3 < (MMU_size + 7)) cycle_count3 <= cycle_count3 + 1;
                    if (cycle_count4 < (MMU_size + 8)) cycle_count4 <= cycle_count4 + 1;
                    if (cycle_count5 < (MMU_size + 9)) cycle_count5 <= cycle_count5 + 1; // For Tiled MM purpose
                    if (cycle_count6 < (MMU_size + 10)) cycle_count6 <= cycle_count6 + 1;
                    if (cycle_count7 < (MMU_size + 11)) cycle_count7 <= cycle_count7 + 1;
                    if (cycle_count8 < (MMU_size + 12)) cycle_count8 <= cycle_count8 + 1;
                    
                    // B) Store inputs into local Tiled MM memories
                    case (cycle_count1)
                        5:  Temp1  <= in1;
                        6:  Temp5  <= in1;
                        7:  Temp9  <= in1;
                        8:  Temp13 <= in1;
                    endcase
                
                    case (cycle_count2)
                        6:  Temp2  <= in2;
                        7:  Temp6  <= in2;
                        8:  Temp10  <= in2;
                        9:  Temp14  <= in2;
                    endcase
                
                    case (cycle_count3)
                        7:  Temp3  <= in3;
                        8:  Temp7  <= in3;
                        9:  Temp11  <= in3;
                       10:  Temp15  <= in3;
                    endcase
                
                    case (cycle_count4)
                        8:  Temp4  <= in4;
                        9:  Temp8  <= in4;
                       10:  Temp12  <= in4;
                       11:  Temp16  <= in4;
                    endcase
                    
                    // C) Check finish storing
                    if ((cycle_count1 >= MMU_size + 4) &&
                        (cycle_count2 >= MMU_size + 5) &&
                        (cycle_count3 >= MMU_size + 6) &&
                        (cycle_count4 >= MMU_size + 7)) 
                    begin
                        accumulator_finish_storing <= 1'b1;
                        tiled_computing_storing_cycle_count <= tiled_computing_storing_cycle_count + 1;
                        tiled_MM_storing_complete <= 1'b0;
                    end
                end
                5: begin
                    // A) Increment cycle counters up to (MMU_size + offset)
                    if (cycle_count1 < (MMU_size + 5)) cycle_count1 <= cycle_count1 + 1;
                    if (cycle_count2 < (MMU_size + 6)) cycle_count2 <= cycle_count2 + 1;
                    if (cycle_count3 < (MMU_size + 7)) cycle_count3 <= cycle_count3 + 1;
                    if (cycle_count4 < (MMU_size + 8)) cycle_count4 <= cycle_count4 + 1;
                    if (cycle_count5 < (MMU_size + 9)) cycle_count5 <= cycle_count5 + 1; // For Tiled MM purpose
                    if (cycle_count6 < (MMU_size + 10)) cycle_count6 <= cycle_count6 + 1;
                    if (cycle_count7 < (MMU_size + 11)) cycle_count7 <= cycle_count7 + 1;
                    if (cycle_count8 < (MMU_size + 12)) cycle_count8 <= cycle_count8 + 1;
                    
                    // B) Store inputs into local Tiled MM memories
                    case (cycle_count1)
                        5:  Temp17  <= in1;
                        6:  Temp21  <= in1;
                        7:  Temp25  <= in1;
                        8:  Temp29 <= in1;
                    endcase
                
                    case (cycle_count2)
                        6:  Temp18  <= in2;
                        7:  Temp22  <= in2;
                        8:  Temp26  <= in2;
                        9:  Temp30  <= in2;
                    endcase
                
                    case (cycle_count3)
                        7:  Temp19  <= in3;
                        8:  Temp23  <= in3;
                        9:  Temp27  <= in3;
                       10:  Temp31  <= in3;
                    endcase
                
                    case (cycle_count4)
                        8:  Temp20  <= in4;
                        9:  Temp24  <= in4;
                       10:  Temp28  <= in4;
                       11:  Temp32  <= in4;
                    endcase
                    
                    // C) Check finish storing
                    if ((cycle_count1 >= MMU_size + 4) &&
                        (cycle_count2 >= MMU_size + 5) &&
                        (cycle_count3 >= MMU_size + 6) &&
                        (cycle_count4 >= MMU_size + 7)) 
                    begin
                        accumulator_finish_storing <= 1'b1;
                        tiled_computing_storing_cycle_count <= tiled_computing_storing_cycle_count + 1;
                        tiled_MM_storing_complete <= 1'b0;
                    end
                end
                6: begin
                    // A) Increment cycle counters up to (MMU_size + offset)
                    if (cycle_count1 < (MMU_size + 5)) cycle_count1 <= cycle_count1 + 1;
                    if (cycle_count2 < (MMU_size + 6)) cycle_count2 <= cycle_count2 + 1;
                    if (cycle_count3 < (MMU_size + 7)) cycle_count3 <= cycle_count3 + 1;
                    if (cycle_count4 < (MMU_size + 8)) cycle_count4 <= cycle_count4 + 1;
                    if (cycle_count5 < (MMU_size + 9)) cycle_count5 <= cycle_count5 + 1; // For Tiled MM purpose
                    if (cycle_count6 < (MMU_size + 10)) cycle_count6 <= cycle_count6 + 1;
                    if (cycle_count7 < (MMU_size + 11)) cycle_count7 <= cycle_count7 + 1;
                    if (cycle_count8 < (MMU_size + 12)) cycle_count8 <= cycle_count8 + 1;
                    
                    // B) Store inputs into local Tiled MM memories
                    case (cycle_count1)
                        5:  TMM_memory3[0]   <= (in1  + Temp1  > 65535) ? 16'hFFFF : (in1  + Temp1);  
                        6:  TMM_memory3[4]   <= (in1  + Temp5  > 65535) ? 16'hFFFF : (in1  + Temp5);  
                        7:  TMM_memory3[8]   <= (in1  + Temp9  > 65535) ? 16'hFFFF : (in1  + Temp9);  
                        8:  TMM_memory3[12]  <= (in1  + Temp13  > 65535) ? 16'hFFFF : (in1  + Temp13);  
                    endcase
                
                    case (cycle_count2)
                        6:  TMM_memory3[1]   <= (in2  + Temp2  > 65535) ? 16'hFFFF : (in2  + Temp2);  
                        7:  TMM_memory3[5]   <= (in2  + Temp6  > 65535) ? 16'hFFFF : (in2  + Temp6);  
                        8:  TMM_memory3[9]   <= (in2  + Temp10  > 65535) ? 16'hFFFF : (in2  + Temp10);  
                        9:  TMM_memory3[13]  <= (in2  + Temp14  > 65535) ? 16'hFFFF : (in2  + Temp14);  
                    endcase
                
                    case (cycle_count3)
                        7:  TMM_memory3[2]   <= (in3  + Temp3  > 65535) ? 16'hFFFF : (in3  + Temp3);  
                        8:  TMM_memory3[6]   <= (in3  + Temp7  > 65535) ? 16'hFFFF : (in3  + Temp7);  
                        9:  TMM_memory3[10]  <= (in3  + Temp11  > 65535) ? 16'hFFFF : (in3  + Temp11);  
                       10:  TMM_memory3[14]  <= (in3  + Temp15  > 65535) ? 16'hFFFF : (in3  + Temp15);  
                    endcase
                
                    case (cycle_count4)
                        8:  TMM_memory3[3]   <= (in4  + Temp4  > 65535) ? 16'hFFFF : (in4  + Temp4);  
                        9:  TMM_memory3[7]   <= (in4  + Temp8  > 65535) ? 16'hFFFF : (in4  + Temp8);  
                       10:  TMM_memory3[11]  <= (in4  + Temp12  > 65535) ? 16'hFFFF : (in4  + Temp12);  
                       11:  TMM_memory3[15]  <= (in4  + Temp16  > 65535) ? 16'hFFFF : (in4  + Temp16);  
                    endcase
                    
                    // C) Check finish storing
                    if ((cycle_count1 >= MMU_size + 4) &&
                        (cycle_count2 >= MMU_size + 5) &&
                        (cycle_count3 >= MMU_size + 6) &&
                        (cycle_count4 >= MMU_size + 7)) 
                    begin
                        accumulator_finish_storing <= 1'b1;
                        tiled_computing_storing_cycle_count <= tiled_computing_storing_cycle_count + 1;
                        tiled_MM_storing_complete <= 1'b0;
                    end
                end
                7: begin
                    // A) Increment cycle counters up to (MMU_size + offset)
                    if (cycle_count1 < (MMU_size + 5)) cycle_count1 <= cycle_count1 + 1;
                    if (cycle_count2 < (MMU_size + 6)) cycle_count2 <= cycle_count2 + 1;
                    if (cycle_count3 < (MMU_size + 7)) cycle_count3 <= cycle_count3 + 1;
                    if (cycle_count4 < (MMU_size + 8)) cycle_count4 <= cycle_count4 + 1;
                    if (cycle_count5 < (MMU_size + 9)) cycle_count5 <= cycle_count5 + 1; // For Tiled MM purpose
                    if (cycle_count6 < (MMU_size + 10)) cycle_count6 <= cycle_count6 + 1;
                    if (cycle_count7 < (MMU_size + 11)) cycle_count7 <= cycle_count7 + 1;
                    if (cycle_count8 < (MMU_size + 12)) cycle_count8 <= cycle_count8 + 1;
                    
                    // B) Store inputs into local Tiled MM memories
                    case (cycle_count1)
                        5:  TMM_memory4[0]   <= (in1  + Temp17  > 65535) ? 16'hFFFF : (in1  + Temp17);  
                        6:  TMM_memory4[4]   <= (in1  + Temp21  > 65535) ? 16'hFFFF : (in1  + Temp21);  
                        7:  TMM_memory4[8]   <= (in1  + Temp25  > 65535) ? 16'hFFFF : (in1  + Temp25);  
                        8:  TMM_memory4[12]  <= (in1  + Temp29  > 65535) ? 16'hFFFF : (in1  + Temp29);  
                    endcase
                
                    case (cycle_count2)
                        6:  TMM_memory4[1]   <= (in2  + Temp18  > 65535) ? 16'hFFFF : (in2  + Temp18);  
                        7:  TMM_memory4[5]   <= (in2  + Temp22  > 65535) ? 16'hFFFF : (in2  + Temp22);  
                        8:  TMM_memory4[9]   <= (in2  + Temp26  > 65535) ? 16'hFFFF : (in2  + Temp26);  
                        9:  TMM_memory4[13]  <= (in2  + Temp30  > 65535) ? 16'hFFFF : (in2  + Temp30);  
                    endcase
                
                    case (cycle_count3)
                        7:  TMM_memory4[2]   <= (in3  + Temp19  > 65535) ? 16'hFFFF : (in3  + Temp19);  
                        8:  TMM_memory4[6]   <= (in3  + Temp23  > 65535) ? 16'hFFFF : (in3  + Temp23);  
                        9:  TMM_memory4[10]  <= (in3  + Temp27  > 65535) ? 16'hFFFF : (in3  + Temp27);  
                       10:  TMM_memory4[14]  <= (in3  + Temp31  > 65535) ? 16'hFFFF : (in3  + Temp31);  
                    endcase
                
                    case (cycle_count4)
                        8:  TMM_memory4[3]   <= (in4  + Temp20  > 65535) ? 16'hFFFF : (in4  + Temp20);  
                        9:  TMM_memory4[7]   <= (in4  + Temp24  > 65535) ? 16'hFFFF : (in4  + Temp24);  
                       10:  TMM_memory4[11]  <= (in4  + Temp28  > 65535) ? 16'hFFFF : (in4  + Temp28);  
                       11:  TMM_memory4[15]  <= (in4  + Temp32  > 65535) ? 16'hFFFF : (in4  + Temp32);  
                    endcase
                    
                    // C) Check finish storing
                    if ((cycle_count1 >= MMU_size + 4) &&
                        (cycle_count2 >= MMU_size + 5) &&
                        (cycle_count3 >= MMU_size + 6) &&
                        (cycle_count4 >= MMU_size + 7)) 
                    begin
                        accumulator_finish_storing <= 1'b1;
                        tiled_computing_storing_cycle_count <= tiled_computing_storing_cycle_count + 1;
                        tiled_MM_storing_complete <= 1'b1;
                    end
                end
            endcase
                    
            end else if (!write_enable) begin
            // If write_enable goes low, reset finish storing
            accumulator_finish_storing <= 1'b0;
//            tiled_computing_storing_cycle_count <= 0; // should not have this cuz when next_state = S_fetch, write_enable will be set to 0 (initial setting) and will cause this to be 0
            tiled_MM_storing_complete <= 1'b0;
        end
    end


    always @(posedge clk) begin
        if (accumulator_finish_storing && !tiled_computing_sig_reg) begin
    
            // A) Row-By-Row Compare
            if (row_compare_index < memory_size) begin
                if (cycle_count4 >= (8 + row_compare_index)) begin
                    // read memory for row_compare_index
                    compareVal1 = memory1[row_compare_index];
                    compareVal2 = memory2[row_compare_index];
                    compareVal3 = memory3[row_compare_index];
                    compareVal4 = memory4[row_compare_index];
    
                    max_1or2  = (compareVal1 > compareVal2)? compareVal1 : compareVal2;
                    max_3or4  = (compareVal3 > compareVal4)? compareVal3 : compareVal4;
                    maxAll    = (max_1or2 > max_3or4)? max_1or2 : max_3or4;
    
                    case(row_compare_index)
                      2'd0: Vectorwise_MaxVal_r1 <= maxAll;
                      2'd1: Vectorwise_MaxVal_r2 <= maxAll;
                      2'd2: Vectorwise_MaxVal_r3 <= maxAll;
                      2'd3: Vectorwise_MaxVal_r4 <= maxAll;
                    endcase
    
                    row_compare_index <= row_compare_index + 1;               
                 end
             end
             // B) Once all rows are done, do final matrixwise compare
             else if (row_compare_index == memory_size) begin
                 max_row12 = (Vectorwise_MaxVal_r1 > Vectorwise_MaxVal_r2)
                                 ? Vectorwise_MaxVal_r1 : Vectorwise_MaxVal_r2;
                 max_row34 = (Vectorwise_MaxVal_r3 > Vectorwise_MaxVal_r4)
                                 ? Vectorwise_MaxVal_r3 : Vectorwise_MaxVal_r4;
                 Matrixwise_MaxVal <= (max_row12 > max_row34)? max_row12 : max_row34;
                 end      
          end           
    end
    
    always @(posedge clk) begin
        if (tiled_computing_sig_reg && tiled_MM_storing_complete) begin
            // Iterate over 16 entries in each memory
            if (row_compare_index < memory_size + 12) begin
                    // Read the current values
                    compareVal1 = TMM_memory1[row_compare_index];
                    compareVal2 = TMM_memory2[row_compare_index];
                    compareVal3 = TMM_memory3[row_compare_index];
                    compareVal4 = TMM_memory4[row_compare_index];
    
                    // Find max in each memory individually
                    Vectorwise_MaxVal_r1 = (compareVal1 > Vectorwise_MaxVal_r1) ? compareVal1 : Vectorwise_MaxVal_r1;
                    Vectorwise_MaxVal_r2 = (compareVal2 > Vectorwise_MaxVal_r2) ? compareVal2 : Vectorwise_MaxVal_r2;
                    Vectorwise_MaxVal_r3 = (compareVal3 > Vectorwise_MaxVal_r3) ? compareVal3 : Vectorwise_MaxVal_r3;
                    Vectorwise_MaxVal_r4 = (compareVal4 > Vectorwise_MaxVal_r4) ? compareVal4 : Vectorwise_MaxVal_r4;
    
                    row_compare_index <= row_compare_index + 1;
                end
            // Compute final max when all rows are done
            else if (row_compare_index == 16) begin
                Matrixwise_MaxVal <= (Vectorwise_MaxVal_r1 > Vectorwise_MaxVal_r2) ?
                                    ((Vectorwise_MaxVal_r1 > Vectorwise_MaxVal_r3) ?
                                     ((Vectorwise_MaxVal_r1 > Vectorwise_MaxVal_r4) ? Vectorwise_MaxVal_r1 : Vectorwise_MaxVal_r4) :
                                     ((Vectorwise_MaxVal_r3 > Vectorwise_MaxVal_r4) ? Vectorwise_MaxVal_r3 : Vectorwise_MaxVal_r4))
                                    :
                                    ((Vectorwise_MaxVal_r2 > Vectorwise_MaxVal_r3) ?
                                     ((Vectorwise_MaxVal_r2 > Vectorwise_MaxVal_r4) ? Vectorwise_MaxVal_r2 : Vectorwise_MaxVal_r4) :
                                     ((Vectorwise_MaxVal_r3 > Vectorwise_MaxVal_r4) ? Vectorwise_MaxVal_r3 : Vectorwise_MaxVal_r4));
            end
        end
    end

    //-------------------------------------------
    // 2) Read Logic: Output stored values
    //-------------------------------------------
    always @(posedge clk) begin
        if (!tiled_computing_sig_reg && Acuumulator_sendto_AN_enable) begin
                Vecwise_out1 <= Vectorwise_MaxVal_r1;
                Vecwise_out2 <= Vectorwise_MaxVal_r2;
                Vecwise_out3 <= Vectorwise_MaxVal_r3;
                Vecwise_out4 <= Vectorwise_MaxVal_r4;
                Matwise_out  <= Matrixwise_MaxVal;
            case (round_counter)
                0: begin
                    out1 <= memory1[0];
                    out2 <= memory2[0];
                    out3 <= memory3[0];
                    out4 <= memory4[0];
                end
                1: begin
                    out1 <= memory1[1];
                    out2 <= memory2[1];
                    out3 <= memory3[1];
                    out4 <= memory4[1];
                end
                2: begin
                    out1 <= memory1[2];
                    out2 <= memory2[2];
                    out3 <= memory3[2];
                    out4 <= memory4[2];
                end
                3: begin
                    out1 <= memory1[3];
                    out2 <= memory2[3];
                    out3 <= memory3[3];
                    out4 <= memory4[3];
                end
            endcase
        end else if (tiled_computing_sig_reg && Acuumulator_sendto_AN_enable) begin
                Vecwise_out1 <= Vectorwise_MaxVal_r1;
                Vecwise_out2 <= Vectorwise_MaxVal_r2;
                Vecwise_out3 <= Vectorwise_MaxVal_r3;
                Vecwise_out4 <= Vectorwise_MaxVal_r4;
                Matwise_out  <= Matrixwise_MaxVal;
            case (round_counter)
                0: begin
                    out1 <= TMM_memory1[0];
                    out2 <= TMM_memory2[0];
                    out3 <= TMM_memory3[0];
                    out4 <= TMM_memory4[0];
                end
                1: begin
                    out1 <= TMM_memory1[1];
                    out2 <= TMM_memory2[1];
                    out3 <= TMM_memory3[1];
                    out4 <= TMM_memory4[1];
                end
                2: begin
                    out1 <= TMM_memory1[2];
                    out2 <= TMM_memory2[2];
                    out3 <= TMM_memory3[2];
                    out4 <= TMM_memory4[2];
                end
                3: begin
                    out1 <= TMM_memory1[3];
                    out2 <= TMM_memory2[3];
                    out3 <= TMM_memory3[3];
                    out4 <= TMM_memory4[3];
                end
                4: begin
                    out1 <= TMM_memory1[4];
                    out2 <= TMM_memory2[4];
                    out3 <= TMM_memory3[4];
                    out4 <= TMM_memory4[4];
                end
                5: begin
                    out1 <= TMM_memory1[5];
                    out2 <= TMM_memory2[5];
                    out3 <= TMM_memory3[5];
                    out4 <= TMM_memory4[5];
                end
                6: begin
                    out1 <= TMM_memory1[6];
                    out2 <= TMM_memory2[6];
                    out3 <= TMM_memory3[6];
                    out4 <= TMM_memory4[6];
                end
                7: begin
                    out1 <= TMM_memory1[7];
                    out2 <= TMM_memory2[7];
                    out3 <= TMM_memory3[7];
                    out4 <= TMM_memory4[7];
                end
                8: begin
                    out1 <= TMM_memory1[8];
                    out2 <= TMM_memory2[8];
                    out3 <= TMM_memory3[8];
                    out4 <= TMM_memory4[8];
                end
                9: begin
                    out1 <= TMM_memory1[9];
                    out2 <= TMM_memory2[9];
                    out3 <= TMM_memory3[9];
                    out4 <= TMM_memory4[9];
                end
                10: begin
                    out1 <= TMM_memory1[10];
                    out2 <= TMM_memory2[10];
                    out3 <= TMM_memory3[10];
                    out4 <= TMM_memory4[10];
                end
                11: begin
                    out1 <= TMM_memory1[11];
                    out2 <= TMM_memory2[11];
                    out3 <= TMM_memory3[11];
                    out4 <= TMM_memory4[11];
                end
                12: begin
                    out1 <= TMM_memory1[12];
                    out2 <= TMM_memory2[12];
                    out3 <= TMM_memory3[12];
                    out4 <= TMM_memory4[12];
                end
                13: begin
                    out1 <= TMM_memory1[13];
                    out2 <= TMM_memory2[13];
                    out3 <= TMM_memory3[13];
                    out4 <= TMM_memory4[13];
                end
                14: begin
                    out1 <= TMM_memory1[14];
                    out2 <= TMM_memory2[14];
                    out3 <= TMM_memory3[14];
                    out4 <= TMM_memory4[14];
                end
                15: begin
                    out1 <= TMM_memory1[15];
                    out2 <= TMM_memory2[15];
                    out3 <= TMM_memory3[15];
                    out4 <= TMM_memory4[15];
                end 
            endcase
        end
    end
endmodule


module Activation_Normalization_Unit4x4(
    tiled_computing_sig, AN_Unit_store_complete, func_select, VorM_MaxVal_sel, Nfactor_in, Acuumulator_sendto_AN_enable,
    in1, in2, in3, in4,
    Vecwise_in1, Vecwise_in2, Vecwise_in3, Vecwise_in4, Matwise_in,
    out1, out2, out3, out4,
    AN_Unit_work, rst, clk
);
    parameter BIT_WIDTH = 8;
    parameter word_size = 16;
    parameter memory_size = 4;
    parameter tiled_MM_memory_size = 16;
    input tiled_computing_sig;
    output reg AN_Unit_store_complete;
    input [2:0] func_select;
    input VorM_MaxVal_sel; // Vectorwise normalization or Matrixwise normalization
    input [BIT_WIDTH-1:0] Nfactor_in; // User defined normalization factor
    input Acuumulator_sendto_AN_enable;
    input [2*BIT_WIDTH-1:0] in1, in2, in3, in4;  // 16-bit inputs
    input [2*BIT_WIDTH-1:0] Vecwise_in1, Vecwise_in2, Vecwise_in3, Vecwise_in4, Matwise_in; // 16-bit inputs
    input AN_Unit_work, rst, clk;
    output reg [BIT_WIDTH-1:0] out1, out2, out3, out4; // 8-bit outputs
    // Intermediate signals for the activation unit output
    reg [2*BIT_WIDTH-1:0] act_out1, act_out2, act_out3, act_out4;
    reg tiled_computing_sig_reg;
        
    reg [word_size-1:0] TMM_memory1 [tiled_MM_memory_size-1:0];
    reg [word_size-1:0] TMM_memory2 [tiled_MM_memory_size-1:0];
    reg [word_size-1:0] TMM_memory3 [tiled_MM_memory_size-1:0];
    reg [word_size-1:0] TMM_memory4 [tiled_MM_memory_size-1:0];
    
    // Vectorwise and Matrixwise Maximums from Accumlator
    reg [2*BIT_WIDTH-1:0] Vectorwise_MaxVal_r1, Vectorwise_MaxVal_r2, Vectorwise_MaxVal_r3, Vectorwise_MaxVal_r4;
    reg [2*BIT_WIDTH-1:0] Matrixwise_MaxVal;
    reg VorM_MaxVal_sel_reg;
    reg [BIT_WIDTH-1:0] Nfactor_reg;
    // 24-bit temp results
    reg [2*BIT_WIDTH+8:0] temp24b_out1, temp24b_out2, temp24b_out3, temp24b_out4;
    
    //reg [BIT_WIDTH-1:0] store_cycle_count;
    reg [5:0] store_cycle_count;
    reg [5:0] readout_cycle_count;
    
    // Reset counter when counter_rst switches from 0 to 1
    always @(posedge clk) begin
        if (rst) begin
            store_cycle_count = 0;
//            AN_Unit_store_complete = 0;
        end else if (Acuumulator_sendto_AN_enable) begin
            store_cycle_count = store_cycle_count + 1;  
        end
    end
    
    always @(*) begin
        tiled_computing_sig_reg = tiled_computing_sig;
    end

    // Activation logic (combinational)
    always @(posedge clk) begin
        case (func_select)
            2'b01: begin
                // Placeholder for sigmoid logic (FUTURE WORK)
                act_out1 = in1;
                act_out2 = in2;
                act_out3 = in3;
                act_out4 = in4;
            end
            2'b10: begin
                // Placeholder for SoftMAX logic (FUTURE WORK)
                act_out1 = in1;
                act_out2 = in2;
                act_out3 = in3;
                act_out4 = in4;
            end
            2'b11: begin
                // Placeholder for other activation logic (FUTURE WORK)
                act_out1 = in1;
                act_out2 = in2;
                act_out3 = in3;
                act_out4 = in4;
            end
            default: begin // ReLU logic
                act_out1 = (in1[15] == 0) ? in1 : 16'b0; // Check MSB for sign
                act_out2 = (in2[15] == 0) ? in2 : 16'b0;
                act_out3 = (in3[15] == 0) ? in3 : 16'b0;
                act_out4 = (in4[15] == 0) ? in4 : 16'b0;
            end
        endcase
    end
    
    always @(posedge clk) begin
        if (rst) begin
            AN_Unit_store_complete = 0;
        end else if (AN_Unit_work) begin
            readout_cycle_count = readout_cycle_count + 1;
        end else if(Acuumulator_sendto_AN_enable && !tiled_computing_sig_reg) begin
            Vectorwise_MaxVal_r1 = Vecwise_in1;
            Vectorwise_MaxVal_r2 = Vecwise_in2;
            Vectorwise_MaxVal_r3 = Vecwise_in3;
            Vectorwise_MaxVal_r4 = Vecwise_in4;
            Matrixwise_MaxVal = Matwise_in;
        case (store_cycle_count) 
            0: begin
               TMM_memory1[0] = act_out1;
               TMM_memory2[0] = act_out2;
               TMM_memory3[0] = act_out3;
               TMM_memory4[0] = act_out4;
               AN_Unit_store_complete = 0;
            end
            1: begin
               TMM_memory1[0] = act_out1;
               TMM_memory2[0] = act_out2;
               TMM_memory3[0] = act_out3;
               TMM_memory4[0] = act_out4;
               AN_Unit_store_complete = 0;
            end
            2: begin
               TMM_memory1[0] = act_out1;
               TMM_memory2[0] = act_out2;
               TMM_memory3[0] = act_out3;
               TMM_memory4[0] = act_out4;
               AN_Unit_store_complete = 0;
            end
            3: begin
               TMM_memory1[1] = act_out1;
               TMM_memory2[1] = act_out2;
               TMM_memory3[1] = act_out3;
               TMM_memory4[1] = act_out4;
               AN_Unit_store_complete = 0;
            end         
            4: begin
               TMM_memory1[2] = act_out1;
               TMM_memory2[2] = act_out2;
               TMM_memory3[2] = act_out3;
               TMM_memory4[2] = act_out4;
               AN_Unit_store_complete = 0;
            end    
            5: begin
               TMM_memory1[3] = act_out1;
               TMM_memory2[3] = act_out2;
               TMM_memory3[3] = act_out3;
               TMM_memory4[3] = act_out4;
               AN_Unit_store_complete = 1;
               readout_cycle_count = 0;
            end      
        endcase        
        end else if (Acuumulator_sendto_AN_enable && tiled_computing_sig_reg) begin
            Vectorwise_MaxVal_r1 = Vecwise_in1;
            Vectorwise_MaxVal_r2 = Vecwise_in2;
            Vectorwise_MaxVal_r3 = Vecwise_in3;
            Vectorwise_MaxVal_r4 = Vecwise_in4;
            Matrixwise_MaxVal = Matwise_in;
        case (store_cycle_count) 
            0: begin
                TMM_memory1[0] = act_out1;
                TMM_memory2[0] = act_out2;
                TMM_memory3[0] = act_out3;
                TMM_memory4[0] = act_out4;
                AN_Unit_store_complete = 0;
            end
            1: begin
                TMM_memory1[0] = act_out1;
                TMM_memory2[0] = act_out2;
                TMM_memory3[0] = act_out3;
                TMM_memory4[0] = act_out4;
                AN_Unit_store_complete = 0;
            end
            2: begin
                TMM_memory1[0] = act_out1;
                TMM_memory2[0] = act_out2;
                TMM_memory3[0] = act_out3;
                TMM_memory4[0] = act_out4;
                AN_Unit_store_complete = 0;
            end
            3: begin
                TMM_memory1[1] = act_out1;
                TMM_memory2[1] = act_out2;
                TMM_memory3[1] = act_out3;
                TMM_memory4[1] = act_out4;
                AN_Unit_store_complete = 0;
            end
            4: begin
                TMM_memory1[2] = act_out1;
                TMM_memory2[2] = act_out2;
                TMM_memory3[2] = act_out3;
                TMM_memory4[2] = act_out4;
                AN_Unit_store_complete = 0;
            end
            5: begin
                TMM_memory1[3] = act_out1;
                TMM_memory2[3] = act_out2;
                TMM_memory3[3] = act_out3;
                TMM_memory4[3] = act_out4;
                AN_Unit_store_complete = 0;
            end
            6: begin
                TMM_memory1[4] = act_out1;
                TMM_memory2[4] = act_out2;
                TMM_memory3[4] = act_out3;
                TMM_memory4[4] = act_out4;
                AN_Unit_store_complete = 0;
            end
            7: begin
                TMM_memory1[5] = act_out1;
                TMM_memory2[5] = act_out2;
                TMM_memory3[5] = act_out3;
                TMM_memory4[5] = act_out4;
                AN_Unit_store_complete = 0;
            end
            8: begin
                TMM_memory1[6] = act_out1;
                TMM_memory2[6] = act_out2;
                TMM_memory3[6] = act_out3;
                TMM_memory4[6] = act_out4;
                AN_Unit_store_complete = 0;
            end
            9: begin
                TMM_memory1[7] = act_out1;
                TMM_memory2[7] = act_out2;
                TMM_memory3[7] = act_out3;
                TMM_memory4[7] = act_out4;
                AN_Unit_store_complete = 0;
            end
            10: begin
                TMM_memory1[8] = act_out1;
                TMM_memory2[8] = act_out2;
                TMM_memory3[8] = act_out3;
                TMM_memory4[8] = act_out4;
                AN_Unit_store_complete = 0;
            end
            11: begin
                TMM_memory1[9] = act_out1;
                TMM_memory2[9] = act_out2;
                TMM_memory3[9] = act_out3;
                TMM_memory4[9] = act_out4;
                AN_Unit_store_complete = 0;
            end
            12: begin
                TMM_memory1[10] = act_out1;
                TMM_memory2[10] = act_out2;
                TMM_memory3[10] = act_out3;
                TMM_memory4[10] = act_out4;
                AN_Unit_store_complete = 0;
            end
            13: begin
                TMM_memory1[11] = act_out1;
                TMM_memory2[11] = act_out2;
                TMM_memory3[11] = act_out3;
                TMM_memory4[11] = act_out4;
                AN_Unit_store_complete = 0;
            end
            14: begin
                TMM_memory1[12] = act_out1;
                TMM_memory2[12] = act_out2;
                TMM_memory3[12] = act_out3;
                TMM_memory4[12] = act_out4;
                AN_Unit_store_complete = 0;
            end
            15: begin
                TMM_memory1[13] = act_out1;
                TMM_memory2[13] = act_out2;
                TMM_memory3[13] = act_out3;
                TMM_memory4[13] = act_out4;
                AN_Unit_store_complete = 0;
            end
            16: begin
                TMM_memory1[14] = act_out1;
                TMM_memory2[14] = act_out2;
                TMM_memory3[14] = act_out3;
                TMM_memory4[14] = act_out4;
                AN_Unit_store_complete = 0;
            end
            17: begin
                TMM_memory1[15] = act_out1;
                TMM_memory2[15] = act_out2;
                TMM_memory3[15] = act_out3;
                TMM_memory4[15] = act_out4;
                AN_Unit_store_complete = 1;
                readout_cycle_count = 0;
            end        
        endcase                  
        end  
    end
    
    always @(*) begin
        VorM_MaxVal_sel_reg = VorM_MaxVal_sel;
        Nfactor_reg = Nfactor_in;
    end

    // NEW
    // Normalization logic (combinational)
    // 16-bit * 8-bit = 24-bit, then 24-bit / 16-bit = 8-bit
    always @(posedge clk) begin
        if (AN_Unit_work && tiled_computing_sig_reg) begin
            // if Tiled MM, then just shift right 8-bit for normalization now (better method remains future work!!!)
            case (readout_cycle_count)
                8'd0: begin
                    temp24b_out1 = (TMM_memory1[0] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[0] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[0] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[0] * Nfactor_reg);
                end
                8'd1: begin
                    temp24b_out1 = (TMM_memory1[0] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[0] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[0] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[0] * Nfactor_reg);
                end
                8'd2: begin
                    temp24b_out1 = (TMM_memory1[1] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[1] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[1] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[1] * Nfactor_reg);
                end
                8'd3: begin
                    temp24b_out1 = (TMM_memory1[2] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[2] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[2] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[2] * Nfactor_reg);
                end
                8'd4: begin
                    temp24b_out1 = (TMM_memory1[3] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[3] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[3] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[3] * Nfactor_reg);
                end
                8'd5: begin
                    temp24b_out1 = (TMM_memory1[4] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[4] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[4] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[4] * Nfactor_reg);
                end
                8'd6: begin
                    temp24b_out1 = (TMM_memory1[4] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[4] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[4] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[4] * Nfactor_reg);
                end
                8'd7: begin
                    temp24b_out1 = (TMM_memory1[4] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[4] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[4] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[4] * Nfactor_reg);
                end
                8'd8: begin
                    temp24b_out1 = (TMM_memory1[5] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[5] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[5] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[5] * Nfactor_reg);
                end
                8'd9: begin
                    temp24b_out1 = (TMM_memory1[6] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[6] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[6] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[6] * Nfactor_reg);
                end
                8'd10: begin
                    temp24b_out1 = (TMM_memory1[7] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[7] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[7] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[7] * Nfactor_reg);
                end
                8'd11: begin
                    temp24b_out1 = (TMM_memory1[8] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[8] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[8] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[8] * Nfactor_reg);
                end
                8'd12: begin
                    temp24b_out1 = (TMM_memory1[8] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[8] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[8] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[8] * Nfactor_reg);
                end
                8'd13: begin
                    temp24b_out1 = (TMM_memory1[8] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[8] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[8] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[8] * Nfactor_reg);
                end
                8'd14: begin
                    temp24b_out1 = (TMM_memory1[9] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[9] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[9] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[9] * Nfactor_reg);
                end
                8'd15: begin
                    temp24b_out1 = (TMM_memory1[10] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[10] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[10] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[10] * Nfactor_reg);
                end
                8'd16: begin
                    temp24b_out1 = (TMM_memory1[11] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[11] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[11] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[11] * Nfactor_reg);
                end
                8'd17: begin
                    temp24b_out1 = (TMM_memory1[12] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[12] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[12] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[12] * Nfactor_reg);
                end
                8'd18: begin
                    temp24b_out1 = (TMM_memory1[12] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[12] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[12] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[12] * Nfactor_reg);
                end
                8'd19: begin
                    temp24b_out1 = (TMM_memory1[12] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[12] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[12] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[12] * Nfactor_reg);
                end
                8'd20: begin
                    temp24b_out1 = (TMM_memory1[13] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[13] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[13] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[13] * Nfactor_reg);
                end
                8'd21: begin
                    temp24b_out1 = (TMM_memory1[14] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[14] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[14] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[14] * Nfactor_reg);
                end
                8'd22: begin
                    temp24b_out1 = (TMM_memory1[15] * Nfactor_reg);
                    temp24b_out2 = (TMM_memory2[15] * Nfactor_reg);
                    temp24b_out3 = (TMM_memory3[15] * Nfactor_reg);
                    temp24b_out4 = (TMM_memory4[15] * Nfactor_reg);
                end
            endcase
        
            // Normalize the output
            out1 = temp24b_out1 / Matrixwise_MaxVal;
            out2 = temp24b_out2 / Matrixwise_MaxVal;
            out3 = temp24b_out3 / Matrixwise_MaxVal;
            out4 = temp24b_out4 / Matrixwise_MaxVal;
    
        end else if (AN_Unit_work && !tiled_computing_sig_reg && !VorM_MaxVal_sel_reg) begin
                    case(readout_cycle_count) 
                    8'd0: begin
                        temp24b_out1 = (TMM_memory1[0] * Nfactor_reg);
                        temp24b_out2 = (TMM_memory2[0] * Nfactor_reg);
                        temp24b_out3 = (TMM_memory3[0] * Nfactor_reg);
                        temp24b_out4 = (TMM_memory4[0] * Nfactor_reg);
                        out1 = temp24b_out1 / Vectorwise_MaxVal_r1;
                        out2 = temp24b_out2 / Vectorwise_MaxVal_r1;
                        out3 = temp24b_out3 / Vectorwise_MaxVal_r1;
                        out4 = temp24b_out4 / Vectorwise_MaxVal_r1;             
                        end
                    8'd1: begin
                        temp24b_out1 = (TMM_memory1[0] * Nfactor_reg);
                        temp24b_out2 = (TMM_memory2[0] * Nfactor_reg);
                        temp24b_out3 = (TMM_memory3[0] * Nfactor_reg);
                        temp24b_out4 = (TMM_memory4[0] * Nfactor_reg);
                        out1 = temp24b_out1 / Vectorwise_MaxVal_r1;
                        out2 = temp24b_out2 / Vectorwise_MaxVal_r1;
                        out3 = temp24b_out3 / Vectorwise_MaxVal_r1;
                        out4 = temp24b_out4 / Vectorwise_MaxVal_r1;             
                        end
                    8'd2: begin
                        temp24b_out1 = (TMM_memory1[1] * Nfactor_reg);
                        temp24b_out2 = (TMM_memory2[1] * Nfactor_reg);
                        temp24b_out3 = (TMM_memory3[1] * Nfactor_reg);
                        temp24b_out4 = (TMM_memory4[1] * Nfactor_reg);
                        out1 = temp24b_out1 / Vectorwise_MaxVal_r2;
                        out2 = temp24b_out2 / Vectorwise_MaxVal_r2;
                        out3 = temp24b_out3 / Vectorwise_MaxVal_r2;
                        out4 = temp24b_out4 / Vectorwise_MaxVal_r2;  
                        end
                    8'd3: begin
                        temp24b_out1 = (TMM_memory1[2] * Nfactor_reg);
                        temp24b_out2 = (TMM_memory2[2] * Nfactor_reg);
                        temp24b_out3 = (TMM_memory3[2] * Nfactor_reg);
                        temp24b_out4 = (TMM_memory4[2] * Nfactor_reg);
                        out1 = temp24b_out1 / Vectorwise_MaxVal_r3;
                        out2 = temp24b_out2 / Vectorwise_MaxVal_r3;
                        out3 = temp24b_out3 / Vectorwise_MaxVal_r3;
                        out4 = temp24b_out4 / Vectorwise_MaxVal_r3;  
                        end
                    8'd4: begin
                        temp24b_out1 = (TMM_memory1[3] * Nfactor_reg);
                        temp24b_out2 = (TMM_memory2[3] * Nfactor_reg);
                        temp24b_out3 = (TMM_memory3[3] * Nfactor_reg);
                        temp24b_out4 = (TMM_memory4[3] * Nfactor_reg);
                        out1 = temp24b_out1 / Vectorwise_MaxVal_r4;
                        out2 = temp24b_out2 / Vectorwise_MaxVal_r4;
                        out3 = temp24b_out3 / Vectorwise_MaxVal_r4;
                        out4 = temp24b_out4 / Vectorwise_MaxVal_r4;  
                        end
                    default: begin
                        // No operation
                    end
                    endcase
                end else if (AN_Unit_work && !tiled_computing_sig_reg && VorM_MaxVal_sel_reg) begin // MaxAll normalization
                    case(readout_cycle_count) 
                    8'd0: begin
                        temp24b_out1 = (TMM_memory1[0] * Nfactor_reg);
                        temp24b_out2 = (TMM_memory2[0] * Nfactor_reg);
                        temp24b_out3 = (TMM_memory3[0] * Nfactor_reg);
                        temp24b_out4 = (TMM_memory4[0] * Nfactor_reg);
                        out1 = temp24b_out1 / Matrixwise_MaxVal;
                        out2 = temp24b_out2 / Matrixwise_MaxVal;
                        out3 = temp24b_out3 / Matrixwise_MaxVal;
                        out4 = temp24b_out4 / Matrixwise_MaxVal;      
                        end
                    8'd1: begin
                        temp24b_out1 = (TMM_memory1[0] * Nfactor_reg);
                        temp24b_out2 = (TMM_memory2[0] * Nfactor_reg);
                        temp24b_out3 = (TMM_memory3[0] * Nfactor_reg);
                        temp24b_out4 = (TMM_memory4[0] * Nfactor_reg);
                        out1 = temp24b_out1 / Matrixwise_MaxVal;
                        out2 = temp24b_out2 / Matrixwise_MaxVal;
                        out3 = temp24b_out3 / Matrixwise_MaxVal;
                        out4 = temp24b_out4 / Matrixwise_MaxVal;      
                        end
                    8'd2: begin
                        temp24b_out1 = (TMM_memory1[1] * Nfactor_reg);
                        temp24b_out2 = (TMM_memory2[1] * Nfactor_reg);
                        temp24b_out3 = (TMM_memory3[1] * Nfactor_reg);
                        temp24b_out4 = (TMM_memory4[1] * Nfactor_reg);
                        out1 = temp24b_out1 / Matrixwise_MaxVal;
                        out2 = temp24b_out2 / Matrixwise_MaxVal;
                        out3 = temp24b_out3 / Matrixwise_MaxVal;
                        out4 = temp24b_out4 / Matrixwise_MaxVal;
                        end
                    8'd3: begin
                        temp24b_out1 = (TMM_memory1[2] * Nfactor_reg);
                        temp24b_out2 = (TMM_memory2[2] * Nfactor_reg);
                        temp24b_out3 = (TMM_memory3[2] * Nfactor_reg);
                        temp24b_out4 = (TMM_memory4[2] * Nfactor_reg);
                        out1 = temp24b_out1 / Matrixwise_MaxVal;
                        out2 = temp24b_out2 / Matrixwise_MaxVal;
                        out3 = temp24b_out3 / Matrixwise_MaxVal;
                        out4 = temp24b_out4 / Matrixwise_MaxVal;
                        end
                    8'd4: begin
                        temp24b_out1 = (TMM_memory1[3] * Nfactor_reg);
                        temp24b_out2 = (TMM_memory2[3] * Nfactor_reg);
                        temp24b_out3 = (TMM_memory3[3] * Nfactor_reg);
                        temp24b_out4 = (TMM_memory4[3] * Nfactor_reg);
                        out1 = temp24b_out1 / Matrixwise_MaxVal;
                        out2 = temp24b_out2 / Matrixwise_MaxVal;
                        out3 = temp24b_out3 / Matrixwise_MaxVal;
                        out4 = temp24b_out4 / Matrixwise_MaxVal;
                        end
                    default: begin
                        // No operation
                    end  
                    endcase
                end
            end
endmodule


//------------------------------Controller related------------------------------//
module Controller(
    Controller_start_sig, tiled_computing_sig,
    L1_Host_Memory_Weight_rd, L1_Host_Memory_Activation_rd, L1_Host_Memory_Activation_wr, L1_Host_Memory_Weight_addr, L1_Host_Memory_Activation_rd_addr, L1_Host_Memory_Activation_wr_addr, // for L1_Host_Memory
    IR_out, IR_wr, IR_rd, // for IR_Mem
    IR_inc, IR_clr, // for IR_counter
    UB_addr, UB_rd, UB_wr, UB_counter_rst, UB_rd_to_Host, UB_wr_from_Host, // for Unified Buffer
    sds_counter_rst, sds_work, // for systolic data setup
    Weight_DDR_addr, Weight_rd, Weight_wr, // for Weight DDR3 memory
    Weight_interface_pushtime, Weight_interface_rst, Weight_interface_push, Weight_interface_pop, pop_complete, // for Weight interface
    Weight_FIFO_rst, Weight_FIFO_wr_en, Weight_FIFO_rd_en,
    Weight_FIFO_buf_empty, Weight_FIFO_buf_full, Weight_FIFO_fifo_counter, // for Weight FIFO
    Activation_FIFO_rst, Activation_FIFO_wr_en, Activation_FIFO_rd_en, 
    Activation_FIFO_buf_empty, Activation_FIFO_buf_full, Activation_FIFO_fifo_counter, // for Activation FIFO
    MMU_size, write_enable, read_enable, Accumulator_rst, accumulator_finish_storing, reset_accumulator_finish_storing, tiled_MM_storing_complete, // for Accumulator
    func_select, VorM_MaxVal_sel, Nfactor, AN_Unit_work, AN_rst, // for Activation_Normalizaion_Unit
    Acuumulator_sendto_AN_enable, AN_Unit_store_complete, // Enable signal to allow MaxVal be sent from Accumulator to Activation_Normalizaion_Unit
    MMU_rst, MMU_w_pass, MMU_weightload_complete, MMU_s_in1, MMU_s_in2, MMU_s_in3, MMU_s_in4, // MMU_weightload_complete is an 'input' to detect whether the weights are finishing loading into MMU
    MMU_r1_en, MMU_r2_en, MMU_r3_en, MMU_r4_en, MMU_c1_en, MMU_c2_en, MMU_c3_en, MMU_c4_en, 
    MMU_rowsignal1, MMU_rowsignal2, MMU_rowsignal3, MMU_rowsignal4, // for MMU
    Computation_finished_signal, clk, rst);
    
    parameter Instruction_size = 16;
    parameter HostMemory_addr_size = 6;
    parameter address_size = 4;
    parameter MMUsize = 8;
    parameter Data_size = 8;
    parameter S_initial = 0, S_fetch = 1; // fetch instructions for IR (in TPU)
    parameter S_decode = 2; // decode the instruction from IR
    parameter S_L1HostMem_to_WandA1 = 3, S_L1HostMem_to_WandA2 = 4;
    // Weight load //
    parameter S_Weight_DDR3_to_interface1 = 5, S_Weight_DDR3_to_interface2 = 6, S_Weight_wait_stack_for_one_more_cycle = 7;
    parameter S_Weight_interface_to_WFIFO_stage1 = 8, S_Weight_interface_to_WFIFO_stage2 = 9, S_Weight_wait_FIFO_for_one_more_cycle = 10;
    parameter S_Weight_WFIFO_to_MMU = 11, S_Weight_MMU_rowdetect_stage1 = 12, S_Weight_MMU_rowdetect_stage2 = 13, S_Weight_MMU_load_complete = 14;
    parameter S_UB_to_sds1 = 15, S_UB_to_sds2 = 16, S_UB_to_sds3 = 17, S_Activation_Wait_for_one_more_cycle = 18, S_Activation_AFIFO_to_MMU_and_computing = 19;
    parameter S_MMU_computing = 20, S_Wait_Accumlator_to_store_MaxVal1 = 21, S_Wait_Accumlator_to_store_MaxVal2 = 22; 
    parameter S_Sending_MaxVal_from_Accumlator_to_AN1 = 23, S_Sending_MaxVal_from_Accumlator_to_AN2 = 24, S_Wait_Accumulator_for_one_more_clock_cycle = 25;
    parameter S_ANUnit_start = 26, S_UB_store1 = 27, S_UB_store2 = 28, S_UB_store3 = 29;
    parameter S_Computing_Time_Compare = 30, S_extra_itr = 31;
    parameter S_UB_to_L1HostMem1 = 32, S_UB_to_L1HostMem2 = 33, S_UB_to_L1HostMem_wait_for_one_more_cycle = 34;
    parameter S_stay = 35;
    // opcode //
    parameter Read_L1_Host_Memory = 0; 
    parameter Read_Weight = 1; // weight_load (to MMU)
    parameter Computation = 2; // input from UB to A_FIFO to MMU then store in Accumulator (Called MatrixMultiply/Convolve in TPU paper)
    parameter Activate = 3; // values from accumulator through Activation-Normalization Unit and back to UB (Called Activate in TPU paper)
    parameter Write_L1_Host_Memory = 4; //-----------------------   future work   -----------------------//
    // probably need to have another sub-state to do loop computation? like 1000 iterations??
//    parameter All_value_load = 0, MMU_compute = 1; // Maybe need other opcode? We dont have interaction with 'HOST MEMORY', but maybe need to extend the Accumulator to also make it as a local register file.
    
    // for L1_Host_Memory
    output reg L1_Host_Memory_Weight_rd, L1_Host_Memory_Activation_rd, L1_Host_Memory_Activation_wr;
    output reg [HostMemory_addr_size-1:0] L1_Host_Memory_Weight_addr, L1_Host_Memory_Activation_rd_addr, L1_Host_Memory_Activation_wr_addr;
    // for IR_Mem
    input [Instruction_size-1:0]IR_out; 
    output reg IR_wr, IR_rd; 
    // for IR_counter
    output reg IR_inc, IR_clr;
    // for Unified Buffer
    output reg [address_size-1:0] UB_addr; // for 16 address locations
    output reg UB_rd, UB_wr, UB_counter_rst, UB_rd_to_Host, UB_wr_from_Host;
    // for systolic data setup
    output reg sds_counter_rst;
    output reg sds_work;
    // for Weight DDR3 memory
    output reg [address_size:0] Weight_DDR_addr;
    output reg Weight_rd, Weight_wr;
    // for Weight interface
    output reg [Data_size-1:0] Weight_interface_pushtime; // for stack inside Weight interface
    output reg Weight_interface_rst;
    output reg Weight_interface_push, Weight_interface_pop;
    input pop_complete;
    // for Weight FIFO
    output reg Weight_FIFO_rst, Weight_FIFO_wr_en, Weight_FIFO_rd_en;
    input Weight_FIFO_buf_empty, Weight_FIFO_buf_full;
    input [2*address_size-1:0] Weight_FIFO_fifo_counter;
    // for Activation FIFO
    output reg Activation_FIFO_rst, Activation_FIFO_wr_en, Activation_FIFO_rd_en; 
    input Activation_FIFO_buf_empty, Activation_FIFO_buf_full;
    input [2*address_size-1:0] Activation_FIFO_fifo_counter;
    // for Accumulator
    output reg [MMUsize-1:0] MMU_size;
    output reg write_enable, read_enable, Accumulator_rst; 
    input accumulator_finish_storing;
    output reg reset_accumulator_finish_storing;
    input tiled_MM_storing_complete;
    // for Activation_Normalizaion_Unit
    output reg [2:0] func_select; // for 4 different activation functions (fix in 00 for ReLU now and more functions are future work)
    output reg VorM_MaxVal_sel; // Vectorwise normalization or Matrixwise normalization
    output reg [Data_size-1:0] Nfactor; // User defined normalization factor
    output reg AN_Unit_work, AN_rst;
    output reg Acuumulator_sendto_AN_enable; // Enable signal to allow MaxVal be sent from Accumulator to Activation_Normalizaion_Unit
    input AN_Unit_store_complete;
    // for MMU
    output reg MMU_rst, MMU_w_pass;
    input MMU_weightload_complete;
    output reg [15:0] MMU_s_in1, MMU_s_in2, MMU_s_in3, MMU_s_in4; // fix at 0
    output reg MMU_r1_en, MMU_r2_en, MMU_r3_en, MMU_r4_en, MMU_c1_en, MMU_c2_en, MMU_c3_en, MMU_c4_en;
    output reg [Data_size-1:0] MMU_rowsignal1, MMU_rowsignal2, MMU_rowsignal3, MMU_rowsignal4;
    // general signal
    input Controller_start_sig; // Starting signal from Top Module to trigger the controller
    input tiled_computing_sig; // to check whether the TPU should do Tiled MM
    output reg Computation_finished_signal;
    input clk, rst;
    
    reg [5:0] state, next_state;
    wire [Instruction_size-1:0]IR_out;
    wire [3:0] opcode = IR_out[15:12];
    reg [11:0] itr;
    reg [2:0] funtion_select; // Activation function select
    reg [Data_size-1:0] wait_accumulator_cycles_counter; // For Accumulator to wait for couple more clock cycle to store the MaxVal
    reg Vector_or_Matrix_MaxVal_sel; // For normalization unit to check whether it should use Vectorwise MaxValue or Matrixwise MaxValue for division
    reg [Data_size-1:0] user_defined_factor; // for Normalization purpose: (factor * value) / max_val
    reg [Data_size-1:0] Weight_addr_count; // for Weight DDR3 addr
    reg [Data_size-1:0] Weight_loadingtime_count; // for Weight loading time = 16
    reg [Data_size-1:0] UB_addr_count;
    reg [Data_size-1:0] TiledMM_UB_addr_count;
    reg [Data_size-1:0] HM_Weight_addr_count; // for counting
    reg [Data_size-1:0] HM_Activation_addr_count; // for counting
    reg [Data_size-1:0] HM_Activation_addr_writeback_count; // for UB write back to L1 HostMem counting
    reg [Data_size-1:0] HM_Weight_addr; // actual address
    reg [Data_size-1:0] HM_Activation_addr; // actual address
    reg [Data_size-1:0] HM_Activation_writeback_addr; // actual address for for UB write back to L1 HostMem
    reg inner_controller_rst; // for Weight_addr_count and Activation_addr_count rst
    reg itr_cycle_check_reg, itr_cycle_check_next;// 0: first round or last round; 1: during the itration cycle
    reg [Data_size-1:0] wr_back_HostMem_time_reg;
    reg tiled_computing_sig_reg;

    always@(IR_out) begin
        if (IR_out[15:12] == 3) begin
            funtion_select = IR_out[11:9];
            Vector_or_Matrix_MaxVal_sel = IR_out[8];
            user_defined_factor = IR_out[7:0];     
        end
    end

    always @(posedge clk) begin
       if(Controller_start_sig) begin
         wait_accumulator_cycles_counter <= 8'b00000000;
       end else if (next_state == S_UB_store1) begin
         wait_accumulator_cycles_counter <= 8'b00000000;
       end else if (!tiled_computing_sig_reg) begin
           if ((next_state == S_Wait_Accumlator_to_store_MaxVal1 || next_state == S_Wait_Accumlator_to_store_MaxVal2) && wait_accumulator_cycles_counter < 5) begin
             wait_accumulator_cycles_counter <= wait_accumulator_cycles_counter + 1;
           end
       end else if (tiled_computing_sig_reg) begin
           if ((next_state == S_Wait_Accumlator_to_store_MaxVal1 || next_state == S_Wait_Accumlator_to_store_MaxVal2) && wait_accumulator_cycles_counter < 17) begin
             wait_accumulator_cycles_counter <= wait_accumulator_cycles_counter + 1;
           end
       end
    end 
        
    always @(posedge clk) begin
       if(Controller_start_sig) begin
           itr_cycle_check_reg <= 1'b0;
       end else begin
           itr_cycle_check_reg <= itr_cycle_check_next;
       end
    end 
    
    always @(posedge clk) begin
        if (Controller_start_sig) begin
            HM_Weight_addr_count <= 6'b000000;
            HM_Weight_addr <= 6'b000000;
        end else if (inner_controller_rst) begin
            HM_Weight_addr_count <= 6'b000000;
        end else if ((next_state == S_L1HostMem_to_WandA1 || next_state == S_L1HostMem_to_WandA2) && HM_Weight_addr_count < 17) begin
            HM_Weight_addr <= HM_Weight_addr + 6'b000001;
            HM_Weight_addr_count <= HM_Weight_addr_count + 6'b000001;
        end
    end

    always @(posedge clk) begin
        if (Controller_start_sig) begin
            HM_Activation_addr_count <= 6'b000000;
            HM_Activation_addr <= 6'b000000;
        end else if (inner_controller_rst) begin
            HM_Activation_addr_count <= 6'b000000;
        end else if ((next_state == S_L1HostMem_to_WandA1 || next_state == S_L1HostMem_to_WandA2) && HM_Activation_addr_count < 17) begin
            HM_Activation_addr <= HM_Activation_addr + 6'b000001;
            HM_Activation_addr_count <= HM_Activation_addr_count + 6'b000001;
        end
    end
    
    always @(posedge clk) begin
        if (Controller_start_sig) begin
            HM_Activation_addr_writeback_count <= 5'b00000;
            HM_Activation_writeback_addr <= 6'b000000;
        end else if (inner_controller_rst) begin
            HM_Activation_addr_writeback_count <= 6'b000000;
        end else if ((next_state == S_UB_to_L1HostMem1 || next_state == S_UB_to_L1HostMem2) && HM_Activation_addr_writeback_count < 17) begin
            HM_Activation_writeback_addr <= HM_Activation_writeback_addr + 6'b000001;
            HM_Activation_addr_writeback_count <= HM_Activation_addr_writeback_count + 6'b000001;
        end
    end
    
    // Sequential logic to manage Weight_addr_count for each clock cycle in S_Weight_load_loop
    always @(posedge clk) begin
        if (Controller_start_sig) begin
            Weight_addr_count <= 8'b00000000;
        end else if (next_state == S_Weight_wait_stack_for_one_more_cycle) begin
            Weight_addr_count <= 8'b00000000;   
        end else if ((next_state == S_Weight_DDR3_to_interface1 || next_state == S_Weight_DDR3_to_interface2) && Weight_addr_count < 15) begin
            Weight_addr_count <= Weight_addr_count + 8'b00000001;
        end
    end
    
    // Sequential logic to manage Weight_loadingtime_count for each clock cycle in S_Weight_load_loop
    always @(posedge clk) begin
        if (Controller_start_sig) begin
            Weight_loadingtime_count <= 8'b00000000;
        end else if (next_state == S_Weight_wait_stack_for_one_more_cycle) begin
            Weight_loadingtime_count <= 8'b00000000;
        end else if ((next_state == S_Weight_DDR3_to_interface1 || next_state == S_Weight_DDR3_to_interface2) && Weight_loadingtime_count < 16) begin
            Weight_loadingtime_count <= Weight_loadingtime_count + 8'b00000001;
        end
    end
    
    // Sequential logic to manage UB_addr_count for each clock cycle in S_UB_loop (rd and wr)
    always @(posedge clk) begin
        if (Controller_start_sig) begin
            UB_addr_count <= 8'b00000000;
        end else if (next_state == S_Activation_Wait_for_one_more_cycle || next_state == S_UB_to_sds1 || next_state == S_Computing_Time_Compare || next_state == S_UB_store1) begin
            UB_addr_count <= 8'b00000000;
        end else if ((next_state == S_UB_to_sds2 || next_state == S_UB_to_sds3 || next_state == S_UB_store2 || next_state == S_UB_store3) && UB_addr_count < 8) begin
            UB_addr_count <= UB_addr_count + 8'b00000001;
        end
    end
    
    always@(IR_out) begin // maybe for computation more than once, 2 times or even a loop
        if (IR_out[15:12] == 2) begin
            itr <= IR_out[11:0]; // if opcode = 2 (computation, if itr >= 0, then loop back to computation state again)
        end else begin
            itr <= itr;    
        end
    end
    
    always@(posedge clk or posedge Controller_start_sig)begin: State_transitions
//        if(rst == 1) state <= S_initial; else state <= next_state;
        if (Controller_start_sig) begin
            state <= S_initial;  // Force a restart when the start signal is asserted.
        end else begin
            state <= next_state;
        end
    end
    
    always @(posedge clk) begin
       if(Controller_start_sig) begin
         wr_back_HostMem_time_reg <= 8'b00000000;
       end else if (next_state == S_UB_to_L1HostMem_wait_for_one_more_cycle) begin
         wr_back_HostMem_time_reg <= wr_back_HostMem_time_reg + 8'b00000001;
       end
    end
    
    always@(*)begin
        tiled_computing_sig_reg = tiled_computing_sig;
    end
    
    always@(state or opcode or UB_addr or Weight_DDR_addr or Weight_interface_pushtime or MMU_size or accumulator_finish_storing or func_select or MMU_weightload_complete or pop_complete or itr or AN_Unit_store_complete)begin 
        IR_rd = 0; IR_inc = 0; IR_clr = 0; UB_addr = 4'b0000;
        UB_rd =0; UB_wr = 0; UB_counter_rst = 0; sds_counter_rst = 0;
        Weight_DDR_addr = 8'b0000000; Weight_rd = 0; Weight_wr = 0; Weight_interface_pushtime = 8'b00000000; Weight_interface_push = 0; Weight_interface_pop = 0;
        Weight_interface_rst = 0; Weight_FIFO_rst = 0; Weight_FIFO_wr_en = 0; Weight_FIFO_rd_en = 0;
        Activation_FIFO_rst = 0; Activation_FIFO_wr_en = 0; Activation_FIFO_rd_en = 0;
        MMU_size = 8'b00000000; write_enable = 0; read_enable = 0; Accumulator_rst = 0; reset_accumulator_finish_storing = 0;
        func_select = 3'b000; VorM_MaxVal_sel = 0; Nfactor = 8'b00000000; AN_Unit_work = 0; AN_rst = 0; Acuumulator_sendto_AN_enable = 0; MMU_rst = 0; MMU_w_pass = 0;
        MMU_s_in1 = 16'b0000000000000000; MMU_s_in2 = 16'b0000000000000000; MMU_s_in3 = 16'b0000000000000000; MMU_s_in4 = 16'b0000000000000000;
        MMU_r1_en = 0; MMU_r2_en = 0; MMU_r3_en = 0; MMU_r4_en = 0; MMU_c1_en = 0; MMU_c2_en = 0; MMU_c3_en = 0; MMU_c4_en = 0;
        MMU_rowsignal1 = 8'b00000000; MMU_rowsignal2 = 8'b00000000; MMU_rowsignal3 = 8'b00000000; MMU_rowsignal4 = 8'b00000000;
        itr_cycle_check_next = itr_cycle_check_reg;
        Computation_finished_signal = 0;
        next_state = state;
        
        case (state)
            S_initial    :begin
                         next_state = S_fetch;
                         IR_clr = 1;
                         // maybe dont need to reset
                         UB_counter_rst = 1; 
                         sds_counter_rst = 1;
                         Weight_interface_rst = 1;
                         Weight_FIFO_rst = 1;
                         Activation_FIFO_rst = 1;
                         Accumulator_rst = 1;
                         reset_accumulator_finish_storing = 1;
                         AN_rst = 1;
                         MMU_rst = 1;
                         $display("State: S_initial");
                         end
            S_fetch      :begin
                         next_state = S_decode;
                         IR_clr = 0;
//                         IR_inc = 1;
                         IR_rd = 1;
                         $display("State: S_fetch");
                         end
            S_decode     :begin
                            $display("opcode: %b", opcode);
                            case(opcode)
                            
                            // opcode = 0
                            Read_L1_Host_Memory: begin 
                            L1_Host_Memory_Weight_rd = 1;
                            L1_Host_Memory_Activation_rd = 1;
                            L1_Host_Memory_Weight_addr = HM_Weight_addr;
                            L1_Host_Memory_Activation_rd_addr = HM_Activation_addr;
//                            Weight_DDR_addr = HM_Weight_addr_count;
//                            Weight_wr = 1;
//                            UB_addr = HM_Activation_addr_count;
//                            UB_wr_from_Host = 1;
                            next_state = S_L1HostMem_to_WandA1; // W: Weight DDR3; A: Unified Buffer (Activation)
                            $display("State: Read_L1_Host_Memory"); 
                            end 
                            
                            // opcode = 1
                            Read_Weight: begin 
                            Weight_interface_pushtime = 8'b00011111; // prepare for the weight input from DDR3
                            // data read out from Weight DDR
                            Weight_rd = 1; 
                            Weight_interface_push = 1;                             
                            Weight_DDR_addr = Weight_addr_count;
                            next_state = S_Weight_DDR3_to_interface1; // Move to the loop state to begin loading weights 
                            $display("State: Read_Weight");
                            end
                            
                            // opcode = 2
                            Computation: begin
                   //----------Use 1st value stored in UB_mem[0] for example----------// 
                            // UB data1 from mem[0] to UB output_reg                          
                            UB_rd = 1;
                            UB_wr = 0;
                            UB_counter_rst = 1; // reset UB_counter i (in UB)
                   //----------Should not allow these two signal, or it will load 8'bx into sds_reg and AFIFO----------// 
//                            sds_work = 1;
//                            Activation_FIFO_rd_en = 1;
                            next_state = S_UB_to_sds1;
                            $display("State: Computation");
                            end
                            
                            //opcode = 3
                            Activate: begin
//                            read_enable = 1; // Accumulator read_enable = 1
                            func_select = funtion_select;
                            VorM_MaxVal_sel = Vector_or_Matrix_MaxVal_sel;
                            Nfactor = user_defined_factor;
                            UB_counter_rst = 1; // reset UB_counter i (in UB)
                            next_state = S_ANUnit_start;
                            $display("State: Activate");
                            end
                            
                            // opcode = 4
                            Write_L1_Host_Memory: begin 
//                            L1_Host_Memory_Activation_wr = 1;
//                            L1_Host_Memory_Activation_addr = HM_Activation_writeback_addr;
//                            UB_addr = HM_Activation_addr_writeback_count;
                            UB_rd_to_Host = 1;
                            next_state = S_UB_to_L1HostMem1;
                            $display("State: Write_L1_Host_Memory"); 
                            end 
                                                  
                            default:
                                begin next_state = S_stay;
                                $display("Invalid opcode");
                                end
                            endcase
                         end
                         
            S_L1HostMem_to_WandA1: begin
                                if (HM_Weight_addr_count <= 16) begin
                                    $display("State: Values_load_to_W and UB. . .");
                                    L1_Host_Memory_Weight_rd = 1;
                                    L1_Host_Memory_Activation_rd = 1;
                                    L1_Host_Memory_Weight_addr = HM_Weight_addr;
                                    L1_Host_Memory_Activation_rd_addr = HM_Activation_addr;
                                    Weight_DDR_addr = HM_Weight_addr_count - 8'b00000001;
                                    Weight_wr = 1;
                                    UB_addr = HM_Activation_addr_count - 8'b00000001;
                                    UB_wr_from_Host = 1;
                                    next_state = S_L1HostMem_to_WandA2;
                                end else begin
                                    // All values have been loaded from L1HostMem to WandA
                                    $display("State: Values_completely_load_to_W and UB. . .");
                                    L1_Host_Memory_Weight_rd = 0;
                                    L1_Host_Memory_Activation_rd = 0;
                                    Weight_wr = 0;
                                    UB_wr_from_Host = 0;
                                    HM_Weight_addr = HM_Weight_addr - 8'b00000001;
                                    HM_Activation_addr = HM_Activation_addr - 8'b00000001;
                                    HM_Weight_addr_count <= 8'b00000000;
                                    HM_Activation_addr_count <= 8'b00000000;
                                    next_state = S_fetch; 
                                    IR_inc = 1;
                                    end
                                end
            S_L1HostMem_to_WandA2: begin
                                if (HM_Weight_addr_count <= 16) begin
                                    $display("State: Values_load_to_W and UB. . .");
                                    L1_Host_Memory_Weight_rd = 1;
                                    L1_Host_Memory_Activation_rd = 1;
                                    L1_Host_Memory_Weight_addr = HM_Weight_addr;
                                    L1_Host_Memory_Activation_rd_addr = HM_Activation_addr;
                                    Weight_DDR_addr = HM_Weight_addr_count - 8'b00000001;
                                    Weight_wr = 1;
                                    UB_addr = HM_Activation_addr_count - 8'b00000001;
                                    UB_wr_from_Host = 1;
                                    next_state = S_L1HostMem_to_WandA1;
                                end else begin
                                    // All values have been loaded from L1HostMem to WandA
                                    $display("State: Values_completely_load_to_W and UB. . .");
                                    L1_Host_Memory_Weight_rd = 0;
                                    L1_Host_Memory_Activation_rd = 0;
                                    Weight_wr = 0;
                                    UB_wr_from_Host = 0;
                                    HM_Weight_addr = HM_Weight_addr - 8'b00000001;
                                    HM_Activation_addr = HM_Activation_addr - 8'b00000001;
                                    HM_Weight_addr_count <= 8'b00000000;
                                    HM_Activation_addr_count <= 8'b00000000;
                                    next_state = S_fetch; 
                                    IR_inc = 1;
                                    end
                                end
            S_Weight_DDR3_to_interface1: begin
                                if (Weight_loadingtime_count <= 15) begin
                                    $display("State: Weight_load_to_WInterface. . .");
                                    // data read out from Weight DDR
                                    Weight_rd = 1; 
                                    // Weight interface push
                                    Weight_interface_push = 1;                             
                                    Weight_DDR_addr = Weight_addr_count;                      
                                    next_state = S_Weight_DDR3_to_interface2; // Remain in the loop until count reaches 16
                                end else begin
                                    // All weights have been loaded into the FIFO
                                    $display("State: Weight_load_to_WInterface. . .");
                                    Weight_rd = 0;  
                                    Weight_interface_push = 0; 
                                    next_state = S_Weight_wait_stack_for_one_more_cycle; // Proceed to the next state
                                end
                            end
            S_Weight_DDR3_to_interface2: begin
                            if (Weight_loadingtime_count <= 15) begin
                                    $display("State: Weight_load_to_WInterface. . .");
                                    // data read out from Weight DDR
                                    Weight_rd = 1; 
                                    // Weight interface push
                                    Weight_interface_push = 1;                             
                                    Weight_DDR_addr = Weight_addr_count;                      
                                    next_state = S_Weight_DDR3_to_interface1; // Remain in the loop until count reaches 16
                                end
                                else begin
                                    // All weights have been loaded into the FIFO
                                    $display("State: Weight_load_to_WInterface. . .");
                                    Weight_rd = 0;  
                                    Weight_interface_push = 0; 
                                    next_state = S_Weight_wait_stack_for_one_more_cycle; // Proceed to the next state
                                end
                            end
            S_Weight_wait_stack_for_one_more_cycle: begin
                            $display("State: Weight completely loaded into WInterface ! ! !");
                            Weight_interface_pop = 1; // have to presend this pop signal one state earlier, or, all FIFOs[0] will load output = 0.
                            next_state = S_Weight_interface_to_WFIFO_stage1;
                            end 
            S_Weight_interface_to_WFIFO_stage1: begin
                            if(pop_complete != 1) begin
                            Weight_interface_pop = 1;
                            Weight_FIFO_wr_en = 1;
                            $display("State: Weight_load_to_WFIFO. . .");
                            next_state = S_Weight_interface_to_WFIFO_stage2;
                            end
                            else begin
                            next_state = S_Weight_wait_FIFO_for_one_more_cycle;
                            end
                            end
             S_Weight_interface_to_WFIFO_stage2: begin
                            if(pop_complete != 1) begin
                            Weight_interface_pop = 1;
                            Weight_FIFO_wr_en = 1;
                            $display("State: Weight_load_to_WFIFO. . .");
                            next_state = S_Weight_interface_to_WFIFO_stage1;
                            end
                            else begin
                            next_state = S_Weight_wait_FIFO_for_one_more_cycle;
                            end
                            end
            S_Weight_wait_FIFO_for_one_more_cycle: begin
                            $display("State: Weight completely loaded into WFIFO");
                            Weight_FIFO_wr_en = 0;
                            Weight_interface_pop = 0;
                            Weight_interface_rst = 1;
                            next_state = S_Weight_WFIFO_to_MMU;
                            end                 
            S_Weight_WFIFO_to_MMU: begin
                            Weight_interface_rst = 0;
                            $display("State: Weight_load_to_MMU");
                            Weight_FIFO_rd_en = 1;
                            MMU_w_pass = 1;
                            MMU_rowsignal1 = 8'b00000001; // should be 1 for correct counting
                            MMU_rowsignal2 = 8'b00000001;
                            MMU_rowsignal3 = 8'b00000010;
                            MMU_rowsignal4 = 8'b00000011;
                            next_state = S_Weight_MMU_rowdetect_stage1;
                            end   
            S_Weight_MMU_rowdetect_stage1: begin
                         $display("State: MMU row detect s1. . .");
                         Weight_FIFO_rd_en = 1;
                         MMU_w_pass = 1;
                         if (MMU_weightload_complete == 1) begin
                             next_state = S_Weight_MMU_load_complete; // Fetch next instruction when weights are fully loaded
                             Weight_FIFO_rd_en = 0;
                             MMU_w_pass = 0;
                         end else begin
                             next_state = S_Weight_MMU_rowdetect_stage2; // Continue weight loading
                         end
                         end
            S_Weight_MMU_rowdetect_stage2: begin
                         $display("State: MMU row detect s2. . .");
                         Weight_FIFO_rd_en = 1;
                         MMU_w_pass = 1;
                         if (MMU_weightload_complete == 1) begin
                             next_state = S_Weight_MMU_load_complete; // Fetch next instruction when weights are fully loaded
                             Weight_FIFO_rd_en = 0;
                             MMU_w_pass = 0;
                         end else begin
                             next_state = S_Weight_MMU_rowdetect_stage1; // Continue weight loading
                         end
                         end 
            S_Weight_MMU_load_complete: begin
                         $display("State: Weight complete loading into MMU");
                         next_state = S_fetch;
                         IR_inc = 1;
                         Weight_FIFO_rst = 1; // clear Weight FIFO in case of contain useless weight values
                         end             
            S_UB_to_sds1: begin
                         $display("State: Activation_load_to_AFIFO s1. . .");
                //----------Use 1st value stored in UB_mem[0] for example----------// 
                         // Other data be sent to output_reg's'                                     
                         UB_rd = 1;
                         UB_wr = 0;
                //----------Should allow sds_work = 1 for Systolic Data Setup----------//
                         // UB data1 from UB output_reg to sds output1(reg)
                         sds_work = 1;
                //----------However, should not allow Activation_FIFO_wr_en = 1 or it will load 8'dx into AFIFO----------//
//                         Activation_FIFO_wr_en = 1;
                         next_state = S_UB_to_sds2;               
                         end
            S_UB_to_sds2: begin
                         if (UB_addr_count <= 7) begin
                         $display("State: Activation_load_to_AFIFO s2. . .");
                //----------Use 1st value stored in UB_mem[0] for example----------//
                         // Other data be sent to output_reg's'
                         UB_rd = 1;
                         UB_wr = 0;
                         // Other data be sent to sds_output_reg's'
                         sds_work = 1;
                         // UB data1 from sds output1(reg) to AFIFO1[0]
                         Activation_FIFO_wr_en = 1;
                         next_state = S_UB_to_sds3; // need this extra state for signal detection
                         end else begin
                             next_state = S_Activation_Wait_for_one_more_cycle;
                         end                   
                         end
            S_UB_to_sds3: begin
                         if (UB_addr_count <= 7) begin
                         $display("State: Activation_load_to_AFIFO s3. . .");
                         UB_rd = 1;
                         UB_wr = 0;
                         sds_work = 1;
                         Activation_FIFO_wr_en = 1;
                         next_state = S_UB_to_sds2;
                         end else begin
                             next_state = S_Activation_Wait_for_one_more_cycle;
                         end                   
                         end
            S_Activation_Wait_for_one_more_cycle: begin
                         $display("State: Activation completely loaded into AFIFO");
                         UB_rd = 0;
                         UB_wr = 0;
                         sds_work = 0;
                         Activation_FIFO_wr_en = 0;
                         //----------testing 20250119----------//
                         sds_counter_rst = 1; // reset sds counter i
                         next_state = S_Activation_AFIFO_to_MMU_and_computing;
                   
//                   //----------------test purpose 1118 1:30 finished----------------//
//                         next_state = S_fetch;
//                         IR_inc = 1;
                         end
            S_Activation_AFIFO_to_MMU_and_computing: begin
                         $display("State: Activation start loading into MMU");
                         Activation_FIFO_rd_en = 1;
                         MMU_s_in1 = 16'b0000000000000000; 
                         MMU_s_in2 = 16'b0000000000000000; 
                         MMU_s_in3 = 16'b0000000000000000; 
                         MMU_s_in4 = 16'b0000000000000000;
                         MMU_r1_en = 1; MMU_r2_en = 1; MMU_r3_en = 1; MMU_r4_en = 1; 
                         MMU_c1_en = 1; MMU_c2_en = 1; MMU_c3_en = 1; MMU_c4_en = 1;
                         MMU_size = 8'b00000100;
                         write_enable = 1; // Accumulator write_enable = 1
                         sds_counter_rst = 0;
                         next_state = S_MMU_computing;
                         end  
            S_MMU_computing: begin
                         if (!tiled_computing_sig_reg && accumulator_finish_storing != 1) begin
                         $display("State: MMU Computing. . .");
                         Activation_FIFO_rd_en = 1;
                         MMU_s_in1 = 16'b0000000000000000; 
                         MMU_s_in2 = 16'b0000000000000000; 
                         MMU_s_in3 = 16'b0000000000000000; 
                         MMU_s_in4 = 16'b0000000000000000;
                         MMU_r1_en = 1; MMU_r2_en = 1; MMU_r3_en = 1; MMU_r4_en = 1; 
                         MMU_c1_en = 1; MMU_c2_en = 1; MMU_c3_en = 1; MMU_c4_en = 1;
                         MMU_size = 8'b00000100;
                         write_enable = 1; // Accumulator write_enable = 1
                         next_state = S_MMU_computing;
                         end
                         else if (tiled_computing_sig_reg && accumulator_finish_storing != 1 && tiled_MM_storing_complete != 1) begin // Accum Still storing
                         $display("State: Tiled MM not yet complete. . .");
                         Activation_FIFO_rd_en = 1;
                         MMU_s_in1 = 16'b0000000000000000; 
                         MMU_s_in2 = 16'b0000000000000000; 
                         MMU_s_in3 = 16'b0000000000000000; 
                         MMU_s_in4 = 16'b0000000000000000;
                         MMU_r1_en = 1; MMU_r2_en = 1; MMU_r3_en = 1; MMU_r4_en = 1; 
                         MMU_c1_en = 1; MMU_c2_en = 1; MMU_c3_en = 1; MMU_c4_en = 1;
                         MMU_size = 8'b00000100;
                         write_enable = 1; // Accumulator write_enable = 1
                         next_state = S_MMU_computing;
                         end
                         else if (tiled_computing_sig_reg && accumulator_finish_storing == 1 && tiled_MM_storing_complete != 1) begin // Accum Temp finish storing
                         $display("State: Tiled MM TEMP complete. . .");
                         reset_accumulator_finish_storing = 1;
                         next_state = S_fetch; // Need to Read Another Block of value
                         IR_inc = 1;
                         end
                         else if (tiled_computing_sig_reg && accumulator_finish_storing == 1 && tiled_MM_storing_complete == 1) begin // Accum Complete finish storing
                         $display("State: Tiled MM complete!!!");
                         write_enable = 1; // Accumulator write_enable = 1
                         next_state = S_Wait_Accumlator_to_store_MaxVal1;
                         end
                         else begin
//----------------Finish Computing and values are stored in Accumulator and waiting for Activation Function instruction----------------//
                         $display("State: Values finishing loading into Accumulator!!!");
                         next_state = S_Wait_Accumlator_to_store_MaxVal1;
                         end
                         end
            S_Wait_Accumlator_to_store_MaxVal1: begin
                         if (!tiled_computing_sig_reg && wait_accumulator_cycles_counter <= 4) begin
                         $display("State: Storing MaxVal1...");               
                         write_enable = 1;
                         next_state = S_Wait_Accumlator_to_store_MaxVal2;
                         end else if (tiled_computing_sig_reg && wait_accumulator_cycles_counter <= 16) begin
                         $display("State: Storing MaxVal1...");                       
                         write_enable = 1;
                         next_state = S_Wait_Accumlator_to_store_MaxVal2;
                         end
                         else begin
                         $display("State: Finished storing MaxVal and sending to AN_Unit");
                         next_state = S_Sending_MaxVal_from_Accumlator_to_AN1;
                         end                         
                         end
            S_Wait_Accumlator_to_store_MaxVal2: begin
                         if (!tiled_computing_sig_reg && wait_accumulator_cycles_counter <= 4) begin
                         $display("State: Storing MaxVal2...");               
                         write_enable = 1;
                         next_state = S_Wait_Accumlator_to_store_MaxVal1;
                         end else if (tiled_computing_sig_reg && wait_accumulator_cycles_counter <= 16) begin
                         $display("State: Storing MaxVal2...");                       
                         write_enable = 1;
                         next_state = S_Wait_Accumlator_to_store_MaxVal1;
                         end
                         else begin
                         $display("State: Finished storing MaxVal and sending to AN_Unit");
                         next_state = S_Sending_MaxVal_from_Accumlator_to_AN1;
                         end                         
                         end
            S_Sending_MaxVal_from_Accumlator_to_AN1: begin
                         if (AN_Unit_store_complete != 1) begin
                         $display("State: Values storing from Accumulator to AN_Unit1...");
                         Acuumulator_sendto_AN_enable = 1;
                         func_select = funtion_select;
                         VorM_MaxVal_sel = Vector_or_Matrix_MaxVal_sel;
                         next_state = S_Sending_MaxVal_from_Accumlator_to_AN2;
                         end
                         else if (AN_Unit_store_complete == 1) begin
                         $display("State: Values stored in AN_Unit!");
                         Acuumulator_sendto_AN_enable = 0;
                         Activation_FIFO_rd_en = 0;
                         Activation_FIFO_rst = 1;
                         Accumulator_rst = 1;
                         MMU_r1_en = 0; MMU_r2_en = 0; MMU_r3_en = 0; MMU_r4_en = 0; 
                         MMU_c1_en = 0; MMU_c2_en = 0; MMU_c3_en = 0; MMU_c4_en = 0;
                         write_enable = 0; // Accumulatpor write_enable = 0
                         next_state = S_Wait_Accumulator_for_one_more_clock_cycle;
                         end
                         end
            S_Sending_MaxVal_from_Accumlator_to_AN2: begin
                         if (AN_Unit_store_complete != 1) begin
                         $display("State: Values storing from Accumulator to AN_Unit2...");
                         Acuumulator_sendto_AN_enable = 1;
                         func_select = funtion_select;
                         VorM_MaxVal_sel = Vector_or_Matrix_MaxVal_sel;
                         next_state = S_Sending_MaxVal_from_Accumlator_to_AN1;
                         end
                         else if (AN_Unit_store_complete == 1) begin
                         $display("State: Values stored in AN_Unit!");
                         Acuumulator_sendto_AN_enable = 0;
                         Activation_FIFO_rd_en = 0;
                         Activation_FIFO_rst = 1;
                         Accumulator_rst = 1;
                         MMU_r1_en = 0; MMU_r2_en = 0; MMU_r3_en = 0; MMU_r4_en = 0; 
                         MMU_c1_en = 0; MMU_c2_en = 0; MMU_c3_en = 0; MMU_c4_en = 0;
                         write_enable = 0; // Accumulatpor write_enable = 0
                         next_state = S_Wait_Accumulator_for_one_more_clock_cycle;
                         end
                         end
            S_Wait_Accumulator_for_one_more_clock_cycle: begin
                         Activation_FIFO_rst = 0;
                         Accumulator_rst = 0;
                             if (itr_cycle_check_reg == 0) begin
                             next_state = S_fetch; // fetch for Activate (ReLU, Sigmoid, SoftMax...)
                             IR_inc = 1;
                             end
                             else begin
                             read_enable = 1; // Accumulator read_enable = 1
                             func_select = funtion_select;
                             VorM_MaxVal_sel = Vector_or_Matrix_MaxVal_sel;
                             Nfactor = user_defined_factor;
                             UB_counter_rst = 1; // reset UB_counter i (in UB)
                             next_state = S_ANUnit_start;   
                             end
                         end
            S_ANUnit_start: begin
                         $display("State: AN Unit start working!");
//                         read_enable = 1; // Accumulator read_enable = 1
                         func_select = funtion_select;
                         VorM_MaxVal_sel = Vector_or_Matrix_MaxVal_sel;
                         Nfactor = user_defined_factor;
                         AN_Unit_work = 1;
                         UB_counter_rst = 1; // reset UB_counter i (in UB)
                         next_state = S_UB_store1; 
                         end                        
            S_UB_store1: begin                   
                         $display("State: UB storing s1. . .");
                         if (UB_addr_count <= 4) begin
                         UB_rd = 0;
                         UB_wr = 1;
                         read_enable = 1; // Accumulator read_enable = 1
                         func_select = funtion_select;
                         VorM_MaxVal_sel = Vector_or_Matrix_MaxVal_sel;
                         Nfactor = user_defined_factor;
                         AN_Unit_work = 1;
                         next_state = S_UB_store2;   
                         end 
                         else begin
                         $display("State: Values finishing storing back to Unified Buffer");
                         UB_rd = 0;
                         UB_wr = 0;
                         read_enable = 0; // Accumulator read_enable = 0
                         AN_rst = 1;
                         next_state = S_Computing_Time_Compare; 
                         end
                         end
            S_UB_store2: begin
                         $display("State: UB storing s2. . .");
                         if (UB_addr_count <= 4) begin
                         UB_rd = 0;
                         UB_wr = 1;
                         read_enable = 1; // Accumulator read_enable = 1
                         func_select = funtion_select;
                         VorM_MaxVal_sel = Vector_or_Matrix_MaxVal_sel;
                         Nfactor = user_defined_factor;
                         AN_Unit_work = 1;
                         next_state = S_UB_store3;   
                         end
                         else begin
                         $display("State: Values finishing storing back to Unified Buffer");
                         UB_rd = 0;
                         UB_wr = 0;
                         read_enable = 0; // Accumulator read_enable = 0
                         AN_rst = 1;
                         next_state = S_Computing_Time_Compare; 
                         end
                         end
            S_UB_store3: begin
                         $display("State: UB storing s3. . .");
                         if (UB_addr_count <= 4) begin
                         UB_rd = 0;
                         UB_wr = 1;
                         read_enable = 1; // Accumulator read_enable = 1
                         func_select = funtion_select;
                         VorM_MaxVal_sel = Vector_or_Matrix_MaxVal_sel;
                         Nfactor = user_defined_factor;
                         AN_Unit_work = 1;
                         next_state = S_UB_store2;   
                         end
                         else begin
                         $display("State: Values finishing storing back to Unified Buffer");
                         UB_rd = 0;
                         UB_wr = 0;
                         read_enable = 0; // Accumulator read_enable = 0
                         AN_rst = 1;
                         next_state = S_Computing_Time_Compare; 
                         end
                         end
            S_Computing_Time_Compare: begin
                         $display("State: Checking iteration. . .");
                         if (itr > 0) begin
                         itr = itr - 1;
                         next_state = S_extra_itr; 
                         end
                         else begin
                         $display("State: Finish all the computation");
                         next_state = S_fetch; 
                         IR_inc = 1;
                         itr_cycle_check_next = 0;
                         end
                         end
            S_extra_itr  :begin
                         $display("State: Compute for the next itration!!!");
                         UB_rd = 1;
                         UB_wr = 0;
                         UB_counter_rst = 1; // reset UB_counter i (in UB)
                         itr_cycle_check_next = 1;
                         next_state = S_UB_to_sds1; 
                         end
            S_UB_to_L1HostMem1 :begin
                         if (HM_Activation_addr_writeback_count <= 16) begin
                         $display("State: Values_store_back_from_UB_to_L1 HostMem s1. . .");
                         L1_Host_Memory_Activation_wr = 1;
                         L1_Host_Memory_Activation_wr_addr = HM_Activation_writeback_addr - 8'b00000001; // without this then UB[0] will stored to L1HostMem[1]
                         UB_addr = HM_Activation_addr_writeback_count;
                         UB_rd_to_Host = 1;
                         next_state = S_UB_to_L1HostMem2;
                         end else begin
                         // All values have been stored back to L1HostMem
                         L1_Host_Memory_Activation_wr = 0;
                         L1_Host_Memory_Activation_wr_addr = HM_Activation_writeback_addr - 8'b00000001;
                         UB_addr = HM_Activation_addr_writeback_count;
                         UB_rd_to_Host = 0;
                         next_state = S_UB_to_L1HostMem_wait_for_one_more_cycle;
                         end
                         end
            S_UB_to_L1HostMem2 :begin
                         if (HM_Activation_addr_writeback_count <= 16) begin
                         $display("State: Values_store_back_from_UB_to_L1 HostMem s2. . .");
                         L1_Host_Memory_Activation_wr = 1;
                         L1_Host_Memory_Activation_wr_addr = HM_Activation_writeback_addr - 8'b00000001;
                         UB_addr = HM_Activation_addr_writeback_count;
                         UB_rd_to_Host = 1;
                         next_state = S_UB_to_L1HostMem1;
                         end else begin
                         // All values have been stored back to L1HostMem
                         L1_Host_Memory_Activation_wr = 0;
                         L1_Host_Memory_Activation_wr_addr = HM_Activation_writeback_addr - 8'b00000001;
                         UB_addr = HM_Activation_addr_writeback_count;
                         UB_rd_to_Host = 0;
                         next_state = S_UB_to_L1HostMem_wait_for_one_more_cycle;
                         end
                         end  
            S_UB_to_L1HostMem_wait_for_one_more_cycle :begin
                         $display("State: Values_completely_stored_back_to_L1 Host Memory!!!");
                         L1_Host_Memory_Activation_wr = 0;
                         L1_Host_Memory_Activation_wr_addr = HM_Activation_writeback_addr;
                         HM_Activation_writeback_addr = HM_Activation_writeback_addr - 8'b00000001;
                         HM_Activation_addr_writeback_count <= 8'b00000000;
                         UB_rd_to_Host = 0;
                         if (wr_back_HostMem_time_reg < 4) begin
                         next_state = S_fetch; 
                         IR_inc = 1;
                         end else if (wr_back_HostMem_time_reg == 4) begin
                         $display("State: (Message from L1_Controller) TPU work completed!!!");
                         Computation_finished_signal = 1; // send Computation_finished_signal = 1 to the top module to inform that all computation and storing process were completed!!!
                         end
                         end      
            S_stay       :begin
                         // probably need to send the finished signal here???
                         Computation_finished_signal = 1; // send Computation_finished_signal = 1 to the top module to inform that all computation and storing process were completed!!!
                         IR_rd = 1;                 
                         $display("State: S_stay");
                         end
            default: begin next_state = S_initial;
            $display("State: default, resetting to S_initial");
            end
        endcase
    end
endmodule


module TPU4x4(Controller_start_sig, IR_in, IR_wr_addr, IR_wr, 
    Weight_TsdsU_wr, Activation_TsdsU_wr, Activation_L1HM_rd, 
    Weight_TsdsU1_in, Weight_TsdsU2_in, Weight_TsdsU3_in, Weight_TsdsU4_in, Weight_TsdsU5_in, Weight_TsdsU6_in, Weight_TsdsU7_in, Weight_TsdsU8_in,
    Weight_TsdsU9_in, Weight_TsdsU10_in, Weight_TsdsU11_in, Weight_TsdsU12_in, Weight_TsdsU13_in, Weight_TsdsU14_in, Weight_TsdsU15_in, Weight_TsdsU16_in,
    Activation_TsdsU1_in, Activation_TsdsU2_in, Activation_TsdsU3_in, Activation_TsdsU4_in, Activation_TsdsU5_in, Activation_TsdsU6_in, Activation_TsdsU7_in, Activation_TsdsU8_in, 
    Activation_TsdsU9_in, Activation_TsdsU10_in, Activation_TsdsU11_in, Activation_TsdsU12_in, Activation_TsdsU13_in, Activation_TsdsU14_in, Activation_TsdsU15_in, Activation_TsdsU16_in, 
    Activation_L1HM_out1, Activation_L1HM_out2, Activation_L1HM_out3, Activation_L1HM_out4, Activation_L1HM_out5, Activation_L1HM_out6, Activation_L1HM_out7, Activation_L1HM_out8, 
    Activation_L1HM_out9, Activation_L1HM_out10, Activation_L1HM_out11, Activation_L1HM_out12, Activation_L1HM_out13, Activation_L1HM_out14, Activation_L1HM_out15, Activation_L1HM_out16, 
    L1HW_counter_rst, tiled_computing_sig,
    Computation_finished_signal, clk, rst);
    
    parameter Instruction_size = 16;
    parameter L1HostMemory_addr_size = 6;
    parameter address_size = 4;
    parameter MMUsize = 8;
    parameter Data_size = 8;
    
    // for IR from L2 structure
    input [Instruction_size-1:0] IR_in;
    input [2*address_size-1:0] IR_wr_addr;
    input IR_wr;
    // for L1_Host_Memory (Weight & Activation) inputs from L2_Tiled_SDS_Unit
    input Weight_TsdsU_wr, Activation_TsdsU_wr, Activation_L1HM_rd;
    input [Data_size-1:0] Weight_TsdsU1_in, Weight_TsdsU2_in, Weight_TsdsU3_in, Weight_TsdsU4_in, Weight_TsdsU5_in, Weight_TsdsU6_in, Weight_TsdsU7_in, Weight_TsdsU8_in;
    input [Data_size-1:0] Weight_TsdsU9_in, Weight_TsdsU10_in, Weight_TsdsU11_in, Weight_TsdsU12_in, Weight_TsdsU13_in, Weight_TsdsU14_in, Weight_TsdsU15_in, Weight_TsdsU16_in;
    input [Data_size-1:0] Activation_TsdsU1_in, Activation_TsdsU2_in, Activation_TsdsU3_in, Activation_TsdsU4_in, Activation_TsdsU5_in, Activation_TsdsU6_in, Activation_TsdsU7_in, Activation_TsdsU8_in;
    input [Data_size-1:0] Activation_TsdsU9_in, Activation_TsdsU10_in, Activation_TsdsU11_in, Activation_TsdsU12_in, Activation_TsdsU13_in, Activation_TsdsU14_in, Activation_TsdsU15_in, Activation_TsdsU16_in;
    input L1HW_counter_rst, tiled_computing_sig;
    output wire [Data_size-1:0] Activation_L1HM_out1, Activation_L1HM_out2, Activation_L1HM_out3, Activation_L1HM_out4, Activation_L1HM_out5, Activation_L1HM_out6, Activation_L1HM_out7, Activation_L1HM_out8;
    output wire [Data_size-1:0] Activation_L1HM_out9, Activation_L1HM_out10, Activation_L1HM_out11, Activation_L1HM_out12, Activation_L1HM_out13, Activation_L1HM_out14, Activation_L1HM_out15, Activation_L1HM_out16;
    // for Controller
    input Controller_start_sig;
    output wire Computation_finished_signal; 
    input clk, rst;
    
    // for L1_Host_Memory to TPU4x4
    wire [Data_size-1:0] L1_Host_Memory_Weight_to_Weight_DDR3;
    wire [Data_size-1:0] L1_Host_Memory_Activation_to_Unified_Buffer, Unified_Buffer_to_L1_Host_Memory_Activation;
    wire L1_Host_Memory_Weight_rd, L1_Host_Memory_Activation_rd, L1_Host_Memory_Activation_wr;
    wire [L1HostMemory_addr_size-1:0] L1_Host_Memory_Weight_addr, L1_Host_Memory_Activation_rd_addr, L1_Host_Memory_Activation_wr_addr;
    // for IR
    wire [Instruction_size-1:0]IR_out; 
//    wire IR_wr, sent by Big_Controller not the controller in TPU4x4
    wire IR_rd; 
    // for IR_counter
    wire [2*address_size-1:0] IR_addr;
    wire IR_inc, IR_clr;
    // for Unified Buffer
    wire [address_size-1:0] UB_addr; // for 16 address locations
    wire UB_rd, UB_wr, UB_counter_rst, UB_rd_to_Host, UB_wr_from_Host;
    wire [Data_size-1:0] UB_dataout1, UB_dataout2, UB_dataout3, UB_dataout4, UB_dataout5, UB_dataout6, UB_dataout7, UB_dataout8;
    wire [Data_size-1:0] UB_dataout9, UB_dataout10, UB_dataout11, UB_dataout12, UB_dataout13, UB_dataout14, UB_dataout15, UB_dataout16;
    // for systolic data setup
    wire sds_counter_rst, sds_work;
    wire [Data_size-1:0] Activation_sds_to_AFIFO1, Activation_sds_to_AFIFO2, Activation_sds_to_AFIFO3, Activation_sds_to_AFIFO4;
    // for Weight DDR3 memory
    wire [address_size:0] Weight_DDR_addr;
    wire Weight_rd, Weight_wr;
    wire [Data_size-1:0] Weight_DDR3_to_Interface;
    // for Weight interface
    wire [Data_size-1:0] Weight_interface_pushtime; // for stack inside Weight interface
    wire Weight_interface_push, Weight_interface_pop;
    wire pop_complete;
    wire Weight_interface_rst;
    wire [Data_size-1:0] Weight_Interface_to_FIFO1, Weight_Interface_to_FIFO2, Weight_Interface_to_FIFO3, Weight_Interface_to_FIFO4;
    // for Weight FIFO
    wire Weight_FIFO_rst, Weight_FIFO_wr_en, Weight_FIFO_rd_en;
    wire Weight_FIFO_buf_empty, Weight_FIFO_buf_full;
    wire [2*address_size-1:0] Weight_FIFO_fifo_counter;
    wire [Data_size-1:0] Weight_FIFO_to_MMU1, Weight_FIFO_to_MMU2, Weight_FIFO_to_MMU3, Weight_FIFO_to_MMU4;
    // for Activation FIFO
    wire Activation_FIFO_rst, Activation_FIFO_wr_en, Activation_FIFO_rd_en; 
    wire Activation_FIFO_buf_empty, Activation_FIFO_buf_full;
    wire [2*address_size-1:0] Activation_FIFO_fifo_counter;
    wire [Data_size-1:0] Activation_FIFO_to_MMU1, Activation_FIFO_to_MMU2, Activation_FIFO_to_MMU3, Activation_FIFO_to_MMU4;
    // for Accumulator
    wire [MMUsize-1:0] MMU_size;
    wire write_enable, read_enable, Accumulator_rst; 
    wire accumulator_finish_storing, reset_accumulator_finish_storing, tiled_MM_storing_complete;
    wire [2*Data_size-1:0] Accumulator_to_AN_out1, Accumulator_to_AN_out2, Accumulator_to_AN_out3, Accumulator_to_AN_out4;
    wire [2*Data_size-1:0] Accumulator_to_AN_VecMaxVal1, Accumulator_to_AN_VecMaxVal2, Accumulator_to_AN_VecMaxVal3, Accumulator_to_AN_VecMaxVal4, Accumulator_to_AN_MatMaxVal;
    // for Activation_Normalizaion_Unit
    wire [2:0] func_select; // for 4 different activation functions (fix in 00 for ReLU now and more functions are future work)
    wire VorM_MaxVal_sel;
    wire [Data_size-1:0] Nfactor;
    wire Acuumulator_sendto_AN_enable, AN_Unit_store_complete;
    wire [Data_size-1:0] AN_to_UB1, AN_to_UB2, AN_to_UB3, AN_to_UB4;
    wire AN_Unit_work, AN_rst;
    // for MMU
    wire MMU_rst, MMU_w_pass;
    wire MMU_weightload_complete;
    wire [2*Data_size-1:0] MMU_s_in1, MMU_s_in2, MMU_s_in3, MMU_s_in4; // fix at 0
    wire MMU_r1_en, MMU_r2_en, MMU_r3_en, MMU_r4_en, MMU_c1_en, MMU_c2_en, MMU_c3_en, MMU_c4_en;
    wire [Data_size-1:0] MMU_rowsignal1, MMU_rowsignal2, MMU_rowsignal3, MMU_rowsignal4;
    wire [2*Data_size-1:0] MMU_to_Accumulator_out1, MMU_to_Accumulator_out2, MMU_to_Accumulator_out3, MMU_to_Accumulator_out4;
    
    //------------------------Host Memory related------------------------//
//     L1_Host_Memory_Weight HMW1(.R_data(L1_Host_Memory_Weight_to_Weight_DDR3), .W_data(Weight_L1HM_in), .addr(L1_Host_Memory_Weight_addr), .clk(clk), .rd(L1_Host_Memory_Weight_rd), .wr(Weight_L1HM_wr));
    L1_Host_Memory_Weight HMW1(.R_data(L1_Host_Memory_Weight_to_Weight_DDR3), .W_data(), .addr(L1_Host_Memory_Weight_addr), .clk(clk), .rd(L1_Host_Memory_Weight_rd), .wr(), 
    .W_data_from_TsdsU1(Weight_TsdsU1_in), .W_data_from_TsdsU2(Weight_TsdsU2_in), .W_data_from_TsdsU3(Weight_TsdsU3_in), .W_data_from_TsdsU4(Weight_TsdsU4_in), .W_data_from_TsdsU5(Weight_TsdsU5_in), .W_data_from_TsdsU6(Weight_TsdsU6_in), .W_data_from_TsdsU7(Weight_TsdsU7_in), .W_data_from_TsdsU8(Weight_TsdsU8_in), 
    .W_data_from_TsdsU9(Weight_TsdsU9_in), .W_data_from_TsdsU10(Weight_TsdsU10_in), .W_data_from_TsdsU11(Weight_TsdsU11_in), .W_data_from_TsdsU12(Weight_TsdsU12_in), .W_data_from_TsdsU13(Weight_TsdsU13_in), .W_data_from_TsdsU14(Weight_TsdsU14_in), .W_data_from_TsdsU15(Weight_TsdsU15_in), .W_data_from_TsdsU16(Weight_TsdsU16_in), 
    .W_wr_from_TsdsU(Weight_TsdsU_wr), .L1HW_counter_rst(L1HW_counter_rst));
    L1_Host_Memory_Activation HMA1(.tiled_computing_sig(tiled_computing_sig), .R_data(L1_Host_Memory_Activation_to_Unified_Buffer), .W_data(Unified_Buffer_to_L1_Host_Memory_Activation), .rd_addr(L1_Host_Memory_Activation_rd_addr), .wr_addr(L1_Host_Memory_Activation_wr_addr), .clk(clk), .rd(L1_Host_Memory_Activation_rd), .wr(L1_Host_Memory_Activation_wr),
    .A_data_from_TsdsU1(Activation_TsdsU1_in), .A_data_from_TsdsU2(Activation_TsdsU2_in), .A_data_from_TsdsU3(Activation_TsdsU3_in), .A_data_from_TsdsU4(Activation_TsdsU4_in), .A_data_from_TsdsU5(Activation_TsdsU5_in), .A_data_from_TsdsU6(Activation_TsdsU6_in), .A_data_from_TsdsU7(Activation_TsdsU7_in), .A_data_from_TsdsU8(Activation_TsdsU8_in), 
    .A_data_from_TsdsU9(Activation_TsdsU9_in), .A_data_from_TsdsU10(Activation_TsdsU10_in), .A_data_from_TsdsU11(Activation_TsdsU11_in), .A_data_from_TsdsU12(Activation_TsdsU12_in), .A_data_from_TsdsU13(Activation_TsdsU13_in), .A_data_from_TsdsU14(Activation_TsdsU14_in), .A_data_from_TsdsU15(Activation_TsdsU15_in), .A_data_from_TsdsU16(Activation_TsdsU16_in),
    .A_wr_from_TsdsU(Activation_TsdsU_wr), .A_data_backto_L2_Accumu1(Activation_L1HM_out1), .A_data_backto_L2_Accumu2(Activation_L1HM_out2), .A_data_backto_L2_Accumu3(Activation_L1HM_out3), .A_data_backto_L2_Accumu4(Activation_L1HM_out4), .A_data_backto_L2_Accumu5(Activation_L1HM_out5), .A_data_backto_L2_Accumu6(Activation_L1HM_out6), .A_data_backto_L2_Accumu7(Activation_L1HM_out7), .A_data_backto_L2_Accumu8(Activation_L1HM_out8), 
    .A_data_backto_L2_Accumu9(Activation_L1HM_out9), .A_data_backto_L2_Accumu10(Activation_L1HM_out10), .A_data_backto_L2_Accumu11(Activation_L1HM_out11), .A_data_backto_L2_Accumu12(Activation_L1HM_out12), .A_data_backto_L2_Accumu13(Activation_L1HM_out13), .A_data_backto_L2_Accumu14(Activation_L1HM_out14), .A_data_backto_L2_Accumu15(Activation_L1HM_out15), .A_data_backto_L2_Accumu16(Activation_L1HM_out16), 
    .A_rd_backto_L2HM(Activation_L1HM_rd), .L1HW_counter_rst(L1HW_counter_rst)
    );
    //------------------------------IR related------------------------------//
    IR_Mem IR_Mem1(.R_data(IR_out), .W_data(IR_in), .addr(IR_addr), .IR_wr_addr(IR_wr_addr), .clk(clk), .IR_rd(IR_rd), .IR_wr(IR_wr));
    IR_counter IR_counter1(.IR_addr(IR_addr), .IR_inc(IR_inc), .IR_clr(IR_clr), .clk(clk));
    //------------------------------Weight related------------------------------//
    Weight_DDR3 WDDR3_1(.R_data(Weight_DDR3_to_Interface), .W_data(L1_Host_Memory_Weight_to_Weight_DDR3), .addr(Weight_DDR_addr), .clk(clk), .rd(Weight_rd), .wr(Weight_wr));
    Weight_interface Winterface1(.clk(clk), .reset(Weight_interface_rst), .weight_in(Weight_DDR3_to_Interface), .push_time(Weight_interface_pushtime), .push(Weight_interface_push), .pop(Weight_interface_pop), .pop_complete(pop_complete), .out1(Weight_Interface_to_FIFO1), .out2(Weight_Interface_to_FIFO2), .out3(Weight_Interface_to_FIFO3), .out4(Weight_Interface_to_FIFO4));
    Weight_FIFO WFIFO1(.clk(clk), .rst(Weight_FIFO_rst), .buf_in(Weight_Interface_to_FIFO1), .buf_out(Weight_FIFO_to_MMU1), .wr_en(Weight_FIFO_wr_en), .rd_en(Weight_FIFO_rd_en), .buf_empty(), .buf_full(), .fifo_counter());
    Weight_FIFO WFIFO2(.clk(clk), .rst(Weight_FIFO_rst), .buf_in(Weight_Interface_to_FIFO2), .buf_out(Weight_FIFO_to_MMU2), .wr_en(Weight_FIFO_wr_en), .rd_en(Weight_FIFO_rd_en), .buf_empty(), .buf_full(), .fifo_counter());
    Weight_FIFO WFIFO3(.clk(clk), .rst(Weight_FIFO_rst), .buf_in(Weight_Interface_to_FIFO3), .buf_out(Weight_FIFO_to_MMU3), .wr_en(Weight_FIFO_wr_en), .rd_en(Weight_FIFO_rd_en), .buf_empty(), .buf_full(), .fifo_counter());
    Weight_FIFO WFIFO4(.clk(clk), .rst(Weight_FIFO_rst), .buf_in(Weight_Interface_to_FIFO4), .buf_out(Weight_FIFO_to_MMU4), .wr_en(Weight_FIFO_wr_en), .rd_en(Weight_FIFO_rd_en), .buf_empty(), .buf_full(), .fifo_counter());
    //------------------------------MMU related------------------------------//
    MMU4x4 MMU1(.a1(Activation_FIFO_to_MMU1), .a2(Activation_FIFO_to_MMU2), .a3(Activation_FIFO_to_MMU3), .a4(Activation_FIFO_to_MMU4), .w1(Weight_FIFO_to_MMU1), .w2(Weight_FIFO_to_MMU2), .w3(Weight_FIFO_to_MMU3), .w4(Weight_FIFO_to_MMU4),
    .s_in1(MMU_s_in1), .s_in2(MMU_s_in2), .s_in3(MMU_s_in3), .s_in4(MMU_s_in4), .o1(MMU_to_Accumulator_out1), .o2(MMU_to_Accumulator_out2), .o3(MMU_to_Accumulator_out3), .o4(MMU_to_Accumulator_out4), .rst(MMU_rst), .clk(clk),
    .w_pass(MMU_w_pass), .weightload_complete(MMU_weightload_complete), .r1_en(MMU_r1_en), .r2_en(MMU_r2_en), .r3_en(MMU_r3_en), .r4_en(MMU_r4_en), .c1_en(MMU_c1_en), .c2_en(MMU_c2_en), .c3_en(MMU_c3_en), .c4_en(MMU_c4_en),
    .rowsignal1(MMU_rowsignal1), .rowsignal2(MMU_rowsignal2), .rowsignal3(MMU_rowsignal3), .rowsignal4(MMU_rowsignal4));
    //------------------------------Other Computation related------------------------------//
    //------------------------------before MMU------------------------------//
    unified_buffer UB1(.addr(UB_addr), .clk(clk), .rd(UB_rd), .wr(UB_wr), .counter_rst(UB_counter_rst),
    .Host_rd(UB_rd_to_Host), .Host_wr(UB_wr_from_Host), .Host_datain(L1_Host_Memory_Activation_to_Unified_Buffer), .Host_dataout(Unified_Buffer_to_L1_Host_Memory_Activation), 
    .data_in1(AN_to_UB1), .data_in2(AN_to_UB2), .data_in3(AN_to_UB3), .data_in4(AN_to_UB4), 
    .data_out1(UB_dataout1), .data_out2(UB_dataout2), .data_out3(UB_dataout3), .data_out4(UB_dataout4), .data_out5(UB_dataout5), .data_out6(UB_dataout6), .data_out7(UB_dataout7), .data_out8(UB_dataout8), 
    .data_out9(UB_dataout9), .data_out10(UB_dataout10), .data_out11(UB_dataout11), .data_out12(UB_dataout12), .data_out13(UB_dataout13), .data_out14(UB_dataout14), .data_out15(UB_dataout15), .data_out16(UB_dataout16));
    sds4x4 sds1(.clk(clk), .counter_rst(sds_counter_rst), .sds_work(sds_work), .a0(UB_dataout1), .a1(UB_dataout2), .a2(UB_dataout3), .a3(UB_dataout4), .b0(UB_dataout5), .b1(UB_dataout6), .b2(UB_dataout7), .b3(UB_dataout8), 
    .c0(UB_dataout9), .c1(UB_dataout10), .c2(UB_dataout11), .c3(UB_dataout12), .d0(UB_dataout13), .d1(UB_dataout14), .d2(UB_dataout15), .d3(UB_dataout16), .output1(Activation_sds_to_AFIFO1), .output2(Activation_sds_to_AFIFO2), .output3(Activation_sds_to_AFIFO3), .output4(Activation_sds_to_AFIFO4));
    Activation_FIFO AFIFO1(.clk(clk), .rst(Activation_FIFO_rst), .buf_in(Activation_sds_to_AFIFO1), .buf_out(Activation_FIFO_to_MMU1), .wr_en(Activation_FIFO_wr_en), .rd_en(Activation_FIFO_rd_en), .buf_empty(), .buf_full(), .fifo_counter());
    Activation_FIFO AFIFO2(.clk(clk), .rst(Activation_FIFO_rst), .buf_in(Activation_sds_to_AFIFO2), .buf_out(Activation_FIFO_to_MMU2), .wr_en(Activation_FIFO_wr_en), .rd_en(Activation_FIFO_rd_en), .buf_empty(), .buf_full(), .fifo_counter());
    Activation_FIFO AFIFO3(.clk(clk), .rst(Activation_FIFO_rst), .buf_in(Activation_sds_to_AFIFO3), .buf_out(Activation_FIFO_to_MMU3), .wr_en(Activation_FIFO_wr_en), .rd_en(Activation_FIFO_rd_en), .buf_empty(), .buf_full(), .fifo_counter());
    Activation_FIFO AFIFO4(.clk(clk), .rst(Activation_FIFO_rst), .buf_in(Activation_sds_to_AFIFO4), .buf_out(Activation_FIFO_to_MMU4), .wr_en(Activation_FIFO_wr_en), .rd_en(Activation_FIFO_rd_en), .buf_empty(), .buf_full(), .fifo_counter());
    //------------------------------After MMU------------------------------//
    Accumulator4x4 Accumlator1(.MMU_size(MMU_size), .write_enable(write_enable), .read_enable(read_enable), .Acuumulator_sendto_AN_enable(Acuumulator_sendto_AN_enable),
    .Vecwise_out1(Accumulator_to_AN_VecMaxVal1), .Vecwise_out2(Accumulator_to_AN_VecMaxVal2), .Vecwise_out3(Accumulator_to_AN_VecMaxVal3), .Vecwise_out4(Accumulator_to_AN_VecMaxVal4), .Matwise_out(Accumulator_to_AN_MatMaxVal),
    .in1(MMU_to_Accumulator_out1), .in2(MMU_to_Accumulator_out2), .in3(MMU_to_Accumulator_out3), .in4(MMU_to_Accumulator_out4), 
    .out1(Accumulator_to_AN_out1), .out2(Accumulator_to_AN_out2), .out3(Accumulator_to_AN_out3), .out4(Accumulator_to_AN_out4), 
    .accumulator_finish_storing(accumulator_finish_storing), .reset_accumulator_finish_storing(reset_accumulator_finish_storing),
    .tiled_computing_sig(tiled_computing_sig), .tiled_MM_storing_complete(tiled_MM_storing_complete), 
    .clk(clk), .rst(Accumulator_rst)
    );
    Activation_Normalization_Unit4x4 AN1(.tiled_computing_sig(tiled_computing_sig), .AN_Unit_store_complete(AN_Unit_store_complete), .func_select(func_select), .VorM_MaxVal_sel(VorM_MaxVal_sel), .Nfactor_in(Nfactor), .Acuumulator_sendto_AN_enable(Acuumulator_sendto_AN_enable),
    .in1(Accumulator_to_AN_out1), .in2(Accumulator_to_AN_out2), .in3(Accumulator_to_AN_out3), .in4(Accumulator_to_AN_out4), 
    .Vecwise_in1(Accumulator_to_AN_VecMaxVal1), .Vecwise_in2(Accumulator_to_AN_VecMaxVal2), .Vecwise_in3(Accumulator_to_AN_VecMaxVal3), .Vecwise_in4(Accumulator_to_AN_VecMaxVal4), .Matwise_in(Accumulator_to_AN_MatMaxVal),
    .out1(AN_to_UB1), .out2(AN_to_UB2), .out3(AN_to_UB3), .out4(AN_to_UB4),
    .AN_Unit_work(AN_Unit_work), .rst(AN_rst), .clk(clk)
    );
    //------------------------------Controller related------------------------------//
    Controller controller1(
    .Controller_start_sig(Controller_start_sig), .tiled_computing_sig(tiled_computing_sig),
    .L1_Host_Memory_Weight_rd(L1_Host_Memory_Weight_rd), .L1_Host_Memory_Activation_rd(L1_Host_Memory_Activation_rd), .L1_Host_Memory_Activation_wr(L1_Host_Memory_Activation_wr), .L1_Host_Memory_Weight_addr(L1_Host_Memory_Weight_addr), .L1_Host_Memory_Activation_rd_addr(L1_Host_Memory_Activation_rd_addr), .L1_Host_Memory_Activation_wr_addr(L1_Host_Memory_Activation_wr_addr), // for L1_Host_Memory
    .IR_out(IR_out), .IR_wr(), .IR_rd(IR_rd), // for IR_Mem
    .IR_inc(IR_inc), .IR_clr(IR_clr), // for IR_counter
    .UB_addr(UB_addr), .UB_rd(UB_rd), .UB_wr(UB_wr), .UB_counter_rst(UB_counter_rst), .UB_rd_to_Host(UB_rd_to_Host), .UB_wr_from_Host(UB_wr_from_Host), // for Unified Buffer
    .sds_counter_rst(sds_counter_rst), .sds_work(sds_work), // for systolic data setup
    .Weight_DDR_addr(Weight_DDR_addr), .Weight_rd(Weight_rd), .Weight_wr(Weight_wr), // for Weight DDR3 memory
    .Weight_interface_pushtime(Weight_interface_pushtime), .Weight_interface_rst(Weight_interface_rst), .Weight_interface_push(Weight_interface_push), .Weight_interface_pop(Weight_interface_pop), // for Weight interface
    .pop_complete(pop_complete), .Weight_FIFO_rst(Weight_FIFO_rst), .Weight_FIFO_wr_en(Weight_FIFO_wr_en), .Weight_FIFO_rd_en(Weight_FIFO_rd_en),
    .Weight_FIFO_buf_empty(), .Weight_FIFO_buf_full(), .Weight_FIFO_fifo_counter(), // for Weight FIFO
    .Activation_FIFO_rst(Activation_FIFO_rst), .Activation_FIFO_wr_en(Activation_FIFO_wr_en), .Activation_FIFO_rd_en(Activation_FIFO_rd_en), 
    .Activation_FIFO_buf_empty(), .Activation_FIFO_buf_full(), .Activation_FIFO_fifo_counter(), // for Activation FIFO
    .MMU_size(MMU_size), .write_enable(write_enable), .read_enable(read_enable), .Accumulator_rst(Accumulator_rst), .accumulator_finish_storing(accumulator_finish_storing), .reset_accumulator_finish_storing(reset_accumulator_finish_storing), .tiled_MM_storing_complete(tiled_MM_storing_complete), // for Accumulator
    .func_select(func_select), .VorM_MaxVal_sel(VorM_MaxVal_sel), .Nfactor(Nfactor), .AN_Unit_work(AN_Unit_work), .AN_rst(AN_rst),// for Activation_Normalizaion_Unit
    .Acuumulator_sendto_AN_enable(Acuumulator_sendto_AN_enable), .AN_Unit_store_complete(AN_Unit_store_complete), // Enable signal to allow MaxVal be sent from Accumulator to Activation_Normalizaion_Unit
    .MMU_rst(MMU_rst), .MMU_w_pass(MMU_w_pass), .MMU_weightload_complete(MMU_weightload_complete), .MMU_s_in1(MMU_s_in1), .MMU_s_in2(MMU_s_in2), .MMU_s_in3(MMU_s_in3), .MMU_s_in4(MMU_s_in4), // MMU_weightload_complete is an 'input' to detect whether the weights are finishing loading into MMU
    .MMU_r1_en(MMU_r1_en), .MMU_r2_en(MMU_r2_en), .MMU_r3_en(MMU_r3_en), .MMU_r4_en(MMU_r4_en), .MMU_c1_en(MMU_c1_en), .MMU_c2_en(MMU_c2_en), .MMU_c3_en(MMU_c3_en), .MMU_c4_en(MMU_c4_en), 
    .MMU_rowsignal1(MMU_rowsignal1), .MMU_rowsignal2(MMU_rowsignal2), .MMU_rowsignal3(MMU_rowsignal3), .MMU_rowsignal4(MMU_rowsignal4), // for MMU
    .Computation_finished_signal(Computation_finished_signal), .clk(clk), .rst(rst));
endmodule


//----------------------------- L2 Controller -----------------------------//
module L2_Controller(
    L2HM_Weight_rd, L2HM_Weight_counter_rst, // for L2 Host Memory Weight
    L2HM_Activation_rd, L2HM_Activation_wr, L2HM_Activation_rd_counter_rst, L2HM_Activation_wr_counter_rst, // for L2 Host Memory Activation
    matrix_compute_size, tiled_computing_sig, zerofill_sig, // for both W&A TSDSU, tiled_computing_sig also for L2 Accumulator 
    TSDSUW_rd, TSDSUW_wr, TSDSUW_rst, // for TSDSUW
    TSDSUA_rd, TSDSUA_wr, TSDSUA_rst, // for TSDSUA
    L2HM_ISA_addr, L2HM_ISA_rd, L2HM_ISA_wr, L2HM_ISA_finished_sig, // for L2 Host Memory ISA
    L2IR_out, L2IR_rd, L2IR_wr, // for L2 IR Memory (stored ISA for L2_Controller)
    L2IR_inc, L2IR_clr, // for L2 IR counter
//    L2_Accumulator_rd, L2_Accumulator_wr, L2_Accumulator_finish_storing, L2_Accumulator_finish_sending, L2_Accumulator_rst, // for L2 Accumulator
    L1_Controller_start_sig, L1IR_addr, L1IR_wr, TPU_Weight_TsdsU_wr, TPU_Activation_TsdsU_wr, TPU_Activation_L1HM_rd, TPU_L1HW_counter_rst, // for TPU4x4
    TPU_Computation_finished_signal, // for TPU4x4
    clk, rst
    );
    
    parameter Instruction_size = 16;
    parameter address_size = 8;
    parameter MMU_Compute_size = 6;
    parameter Data_size = 8;
    
    parameter S_initial = 0, S_fetch = 1; // fetch instructions for IR (L2)
    parameter S_decode = 2; // decode the instruction from L2_IR
    parameter S_ISA_L2HM_to_L1HM1 = 3, S_ISA_L2HM_to_L1HM2 = 4;
    parameter S_WandA_L2HostMem_to_TSDSU1 = 5, S_WandA_L2HostMem_to_TSDSU2 = 6, S_Wait_TSDSU_loading_for_one_more_cycle = 7;
    parameter S_WandA_TSDSU_to_L1HostMem1 = 8, S_WandA_TSDSU_to_L1HostMem2 = 9, S_Wait_L1HostMem_loading_for_one_more_cycle = 10;
    parameter S_TPU_working1 = 11, S_TPU_working2 = 12;
    parameter S_Activation_back_to_L2HostMem1 = 13, S_Activation_back_to_L2HostMem2 = 14, S_Wait_L2HostMem_storing_for_one_more_cycle = 15;
    parameter S_stay = 16;
    // opcode //
    parameter Load_ISA = 0; 
    parameter Read_L2_Host_Memory = 1; // Read L2 Host Mem throught Tiled SDS Unit to L1 Host Mem
    parameter TPU_work = 2; // Allow the TPU4x4 Unit to do the Matrix Multiplication
    parameter Write_L2_Host_Memory = 3; // Write from L1 Host Mem throught L2 Accumulator to L2 Host Mem
 
    output reg L2HM_Weight_rd, L2HM_Weight_counter_rst; // for L2 Host Memory Weight
    output reg L2HM_Activation_rd, L2HM_Activation_wr, L2HM_Activation_rd_counter_rst, L2HM_Activation_wr_counter_rst; // for L2 Host Memory Activation
    output reg [MMU_Compute_size-1:0] matrix_compute_size; // for both W&A TSDSU, tiled_computing_sig also for L2 Accumulator 
    output reg tiled_computing_sig, zerofill_sig;
    output reg TSDSUW_rd, TSDSUW_wr, TSDSUW_rst; // for TSDSUW
    output reg TSDSUA_rd, TSDSUA_wr, TSDSUA_rst; // for TSDSUA
    output reg [address_size-1:0] L2HM_ISA_addr; // for L2 Host Memory ISA
    output reg L2HM_ISA_rd, L2HM_ISA_wr;
    input L2HM_ISA_finished_sig;
    input [Instruction_size-1:0] L2IR_out; // for L2 IR Memory (stored ISA for L2_Controller)
    output reg L2IR_rd, L2IR_wr;
    output reg L2IR_inc, L2IR_clr; // for L2 IR counter
//    output reg L2_Accumulator_rd, L2_Accumulator_wr, L2_Accumulator_rst; // for L2 Accumulator
//    input L2_Accumulator_finish_storing, L2_Accumulator_finish_sending; 
    output reg L1_Controller_start_sig, L1IR_wr, TPU_Weight_TsdsU_wr, TPU_Activation_TsdsU_wr, TPU_Activation_L1HM_rd, TPU_L1HW_counter_rst; // for TPU4x4
    output reg [address_size-1:0] L1IR_addr; // for L1 IR Mem
    input TPU_Computation_finished_signal;
    input clk, rst;
    
    reg  [4:0] state, next_state;
    wire [Instruction_size-1:0] L2IR_out;
    wire [3:0] opcode = L2IR_out[15:12];
    reg  [address_size-1:0] L2HM_ISA_addr_count;
    reg  [address_size-1:0] L1IR_addr_count;
    reg  [address_size-1:0] L2_to_TSDSU_rd_counter;
    reg  [address_size-1:0] TSDSU_to_L1_rd_counter;
    reg  tiled_computing_sig_reg;
    reg  [MMU_Compute_size-1:0] matrix_compute_size_reg;
    reg  [address_size-1:0] L1HM_to_L2HM_wr_counter;
    
    always@(posedge clk or posedge rst)begin: State_transitions
        if(rst == 1) state <= S_initial; else state <= next_state;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            L2HM_ISA_addr_count <= 8'b00000000;
        end else if (next_state == S_ISA_L2HM_to_L1HM1 || next_state == S_ISA_L2HM_to_L1HM2) begin
            L2HM_ISA_addr_count <= L2HM_ISA_addr_count + 8'b00000001;
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            L1IR_addr_count <= 8'b00000000;
        end else if (next_state == S_ISA_L2HM_to_L1HM1 || next_state == S_ISA_L2HM_to_L1HM2) begin
            L1IR_addr_count <= L1IR_addr_count + 8'b00000001;
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            L2_to_TSDSU_rd_counter <= 8'b00000000;
        end else if ((next_state == S_WandA_L2HostMem_to_TSDSU1 || next_state == S_WandA_L2HostMem_to_TSDSU2) && L2_to_TSDSU_rd_counter < 4) begin
            L2_to_TSDSU_rd_counter <= L2_to_TSDSU_rd_counter + 8'b00000001;
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            TSDSU_to_L1_rd_counter <= 8'b00000000;
        end else if ((next_state == S_WandA_TSDSU_to_L1HostMem1 || next_state == S_WandA_TSDSU_to_L1HostMem2) && TSDSU_to_L1_rd_counter < 4) begin
            TSDSU_to_L1_rd_counter <= TSDSU_to_L1_rd_counter + 8'b00000001;
        end
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            L1HM_to_L2HM_wr_counter <= 8'b00000000;
        end else if ((next_state == S_Activation_back_to_L2HostMem1 || next_state == S_Activation_back_to_L2HostMem2) && L1HM_to_L2HM_wr_counter < 4) begin
            L1HM_to_L2HM_wr_counter <= L1HM_to_L2HM_wr_counter + 8'b00000001;
        end
    end
    
    always@(L2IR_out) begin 
        if (L2IR_out[15:12] == 1) begin
            tiled_computing_sig_reg <= L2IR_out[6]; 
        end else begin
            tiled_computing_sig_reg <= tiled_computing_sig_reg;    
        end
    end
    
    always@(L2IR_out) begin
        if (L2IR_out[15:12] == 1) begin
            matrix_compute_size_reg = L2IR_out[5:0];     
        end
    end
    
    always@(state or opcode or L2HM_ISA_finished_sig or TPU_Computation_finished_signal)begin
        L2HM_Weight_rd = 0; L2HM_Weight_counter_rst = 0; L2HM_Activation_rd = 0; L2HM_Activation_wr = 0; L2HM_Activation_rd_counter_rst = 0; L2HM_Activation_wr_counter_rst = 0;
        matrix_compute_size = 6'b000000; tiled_computing_sig = 0; zerofill_sig = 0;
        TSDSUW_rd = 0; TSDSUW_wr = 0; TSDSUW_rst = 0; TSDSUA_rd = 0; TSDSUA_wr = 0; TSDSUA_rst = 0;
        L2HM_ISA_addr = 8'b00000000; L2HM_ISA_rd = 0; L2HM_ISA_wr = 0; L2IR_rd = 0; L2IR_wr = 0; L2IR_inc = 0; L2IR_clr = 0;
//        L2_Accumulator_rd = 0; L2_Accumulator_wr = 0; L2_Accumulator_rst = 0;
        L1_Controller_start_sig = 0; L1IR_addr = 8'b00000000; L1IR_wr = 0; TPU_Weight_TsdsU_wr = 0; TPU_Activation_TsdsU_wr = 0; TPU_Activation_L1HM_rd = 0; TPU_L1HW_counter_rst = 0;       
        next_state = state;
        
        case (state)
            S_initial    :begin
                         next_state = S_fetch;
                         L2IR_clr = 1;
                         L2HM_Weight_counter_rst = 1; 
                         L2HM_Activation_rd_counter_rst = 1;
                         L2HM_Activation_wr_counter_rst = 1;
                         TSDSUW_rst = 1;
                         TSDSUA_rst = 1;
//                         L2_Accumulator_rst = 1;
                         TPU_L1HW_counter_rst = 1;
                         $display("State: S_L2_initial");
                         end
            S_fetch      :begin
                         next_state = S_decode;
                         L2IR_clr = 0;
                         L2IR_rd = 1;
                         $display("State: S_L2_fetch");
                         end
            S_decode     :begin
                            $display("opcode: %b", opcode);
                            case(opcode)
                                // opcode = 0
                                Load_ISA: begin 
                                L2HM_ISA_rd = 1;
                                L2HM_ISA_addr = L2HM_ISA_addr_count;
                                next_state = S_ISA_L2HM_to_L1HM1;
                                $display("State: Load_ISA"); 
                                end 
                                
                                // opcode = 1
                                Read_L2_Host_Memory: begin 
                                L2HM_Weight_rd = 1;
                                L2HM_Activation_rd = 1;
                                zerofill_sig = 1;
                                tiled_computing_sig = tiled_computing_sig_reg;
                                matrix_compute_size = matrix_compute_size_reg;
                                next_state = S_WandA_L2HostMem_to_TSDSU1; 
                                $display("State: Read_L2_Host_Memory");
                                end
                                
                                // opcode = 2
                                TPU_work: begin
                                L1_Controller_start_sig = 1;
                                tiled_computing_sig = tiled_computing_sig_reg;
                                next_state = S_TPU_working1;
                                $display("State: TPU_work");
                                end
                                
                                //opcode = 3
                                Write_L2_Host_Memory: begin
                                TPU_Activation_L1HM_rd = 1;
                                next_state = S_Activation_back_to_L2HostMem1;
                                $display("State: Write_L2_Host_Memory");
                                end                                
                            
                             default:
                                begin next_state = S_stay;
                                $display("L2 Invalid opcode");
                                end
                            endcase
                         end
        S_ISA_L2HM_to_L1HM1: begin
                             if(!L2HM_ISA_finished_sig)begin
                                $display("State: ISA loading to L1 Host Mem1... ");
                                L2HM_ISA_rd = 1;
                                L2HM_ISA_addr = L2HM_ISA_addr_count;
                                L1IR_addr = L1IR_addr_count - 8'b00000001;
                                L1IR_wr = 1;
                                next_state = S_ISA_L2HM_to_L1HM2;
                             end else if(L2HM_ISA_finished_sig) begin
                                $display("State: ISA finished loading into L1 Host Mem!!!");
                                L2HM_ISA_rd = 0;
                                L1IR_wr = 0;
                                next_state = S_fetch; 
                                L2IR_inc = 1;
                             end
                             end
        S_ISA_L2HM_to_L1HM2: begin
                             if(!L2HM_ISA_finished_sig)begin
                                $display("State: ISA loading to L1 Host Mem2... ");
                                L2HM_ISA_rd = 1;
                                L2HM_ISA_addr = L2HM_ISA_addr_count;
                                L1IR_addr = L1IR_addr_count - 8'b00000001;
                                L1IR_wr = 1;
                                next_state = S_ISA_L2HM_to_L1HM1;
                             end else if(L2HM_ISA_finished_sig) begin
                                $display("State: ISA finished loading into L1 Host Mem!!!");
                                L2HM_ISA_rd = 0;
                                L1IR_wr = 0;
                                next_state = S_fetch; 
                                L2IR_inc = 1;
                             end
                             end 
        S_WandA_L2HostMem_to_TSDSU1: begin
                             if(L2_to_TSDSU_rd_counter <= 3)begin
                                $display("State: Weights and Activations loading to TSDSU 1... ");
                                zerofill_sig = 0;
                                L2HM_Weight_rd = 1;
                                L2HM_Activation_rd = 1;
                                tiled_computing_sig = tiled_computing_sig_reg;
                                matrix_compute_size = matrix_compute_size_reg;
                                TSDSUW_wr = 1;
                                TSDSUA_wr = 1;
                                next_state = S_WandA_L2HostMem_to_TSDSU2;
                             end else begin
                                $display("State: Weights and Activations loading to TSDSU 1... ");
                                L2HM_Weight_rd = 0;
                                L2HM_Activation_rd = 0;
                                tiled_computing_sig = tiled_computing_sig_reg;
                                matrix_compute_size = matrix_compute_size_reg;
                                TSDSUW_wr = 1;
                                TSDSUA_wr = 1;
                                next_state = S_Wait_TSDSU_loading_for_one_more_cycle; 
                             end
                             end
        S_WandA_L2HostMem_to_TSDSU2: begin
                             if(L2_to_TSDSU_rd_counter <= 3)begin
                                $display("State: Weights and Activations loading to TSDSU 2... ");
                                zerofill_sig = 0;
                                L2HM_Weight_rd = 1;
                                L2HM_Activation_rd = 1;
                                tiled_computing_sig = tiled_computing_sig_reg;
                                matrix_compute_size = matrix_compute_size_reg;
                                TSDSUW_wr = 1;
                                TSDSUA_wr = 1;
                                next_state = S_WandA_L2HostMem_to_TSDSU1;
                             end else begin
                                $display("State: Weights and Activations loading to TSDSU 2... ");
                                L2HM_Weight_rd = 0;
                                L2HM_Activation_rd = 0;
                                tiled_computing_sig = tiled_computing_sig_reg;
                                matrix_compute_size = matrix_compute_size_reg;
                                TSDSUW_wr = 1;
                                TSDSUA_wr = 1;
                                next_state = S_Wait_TSDSU_loading_for_one_more_cycle; 
                             end
                             end 
        S_Wait_TSDSU_loading_for_one_more_cycle: begin
                             $display("State: Weights and Activations finished loading into TSDSU!!!");
                             tiled_computing_sig = tiled_computing_sig_reg;
                             matrix_compute_size = matrix_compute_size_reg;
                             TSDSUW_wr = 0;
                             TSDSUA_wr = 0;
                             TSDSUW_rd = 1;
                             TSDSUA_rd = 1;
                             next_state = S_WandA_TSDSU_to_L1HostMem1;
                             end 
        S_WandA_TSDSU_to_L1HostMem1: begin
                             if(TSDSU_to_L1_rd_counter <= 3)begin
                             $display("State: Weights and Activations loading to L1 HostMem 1... ");
                             tiled_computing_sig = tiled_computing_sig_reg;
                             matrix_compute_size = matrix_compute_size_reg;
                             TSDSUW_rd = 1;
                             TSDSUA_rd = 1;
                             TPU_Weight_TsdsU_wr = 1;
                             TPU_Activation_TsdsU_wr = 1;
                             next_state = S_WandA_TSDSU_to_L1HostMem2;
                             end else begin
                             $display("State: Weights and Activations loading to L1 HostMem 1... ");
                             TSDSUW_rd = 0;
                             TSDSUA_rd = 0;
                             TPU_Weight_TsdsU_wr = 1;
                             TPU_Activation_TsdsU_wr = 1;
                             tiled_computing_sig = tiled_computing_sig_reg;
                             matrix_compute_size = matrix_compute_size_reg;
                             next_state = S_Wait_L1HostMem_loading_for_one_more_cycle; 
                             end
                             end                      
        S_WandA_TSDSU_to_L1HostMem2: begin
                             if(TSDSU_to_L1_rd_counter <= 3)begin
                             $display("State: Weights and Activations loading to L1 HostMem 2... ");
                             tiled_computing_sig = tiled_computing_sig_reg;
                             matrix_compute_size = matrix_compute_size_reg;
                             TSDSUW_rd = 1;
                             TSDSUA_rd = 1;
                             TPU_Weight_TsdsU_wr = 1;
                             TPU_Activation_TsdsU_wr = 1;
                             next_state = S_WandA_TSDSU_to_L1HostMem1;
                             end else begin
                             $display("State: Weights and Activations loading to L1 HostMem 2... ");
                             TSDSUW_rd = 0;
                             TSDSUA_rd = 0;
                             TPU_Weight_TsdsU_wr = 1;
                             TPU_Activation_TsdsU_wr = 1;
                             tiled_computing_sig = tiled_computing_sig_reg;
                             matrix_compute_size = matrix_compute_size_reg;
                             next_state = S_Wait_L1HostMem_loading_for_one_more_cycle; 
                             end
                             end  
        S_Wait_L1HostMem_loading_for_one_more_cycle: begin
                             $display("State: Weights and Activations finished loading into L1 HostMem!!!");
                             TPU_Weight_TsdsU_wr = 0;
                             TPU_Activation_TsdsU_wr = 0;
                             next_state = S_fetch; 
                             L2IR_inc = 1;
                             end                       
        S_TPU_working1:      begin
                             L1_Controller_start_sig = 0;
                             if (!TPU_Computation_finished_signal) begin
                             tiled_computing_sig = tiled_computing_sig_reg;
                             $display("State: TPU_working1...");
                             end else begin
                             $display("State: (Message from L2_Controller) TPU_finished computing!!!");
                             next_state = S_fetch; 
                             L2IR_inc = 1;
                             end
                             end
        S_TPU_working2:      begin
                             L1_Controller_start_sig = 0;
                             if (!TPU_Computation_finished_signal) begin
                             tiled_computing_sig = tiled_computing_sig_reg;
                             $display("State: TPU_working2...");
                             end else begin
                             $display("State: (Message from L2_Controller) TPU_finished computing!!!");
                             next_state = S_fetch; 
                             L2IR_inc = 1;
                             end
                             end
        S_Activation_back_to_L2HostMem1: begin
                             if (L1HM_to_L2HM_wr_counter <= 3) begin
                             $display("State: Activations loading to L2 HostMem 1... ");
                             TPU_Activation_L1HM_rd = 1;
                             L2HM_Activation_wr = 1;
                             next_state = S_Activation_back_to_L2HostMem2;
                             end else begin
                             TPU_Activation_L1HM_rd = 0;
                             L2HM_Activation_wr = 1;
                             next_state = S_Wait_L2HostMem_storing_for_one_more_cycle;
                             end
                             end
        S_Activation_back_to_L2HostMem2: begin
                             if (L1HM_to_L2HM_wr_counter <= 3) begin
                             $display("State: Activations loading to L2 HostMem 2... ");
                             TPU_Activation_L1HM_rd = 1;
                             L2HM_Activation_wr = 1;
                             next_state = S_Activation_back_to_L2HostMem1;
                             end else begin
                             TPU_Activation_L1HM_rd = 0;
                             L2HM_Activation_wr = 1;
                             next_state = S_Wait_L2HostMem_storing_for_one_more_cycle;
                             end
                             end
       S_Wait_L2HostMem_storing_for_one_more_cycle: begin
                             $display("State: Activations Completely loaded back to L2 HostMem!!! ");
                             L2HM_Activation_wr = 0;
                             next_state = S_fetch; 
                             L2IR_inc = 1;
                             end
                S_stay:      begin
                             L2IR_rd = 1;                 
                             $display("State: S_L2_stay");
                             end
            default: begin next_state = S_initial;
            $display("State: Default, resetting to S_L2_initial");
            end
        endcase
    end
    
endmodule

//--------------------------- TOP MODULE ---------------------------//
module TMMU4x4(
    L2HM_Weight_in, L2HM_Weight_addr, L2HM_Weight_wr, // from L3 Host Mem Weight
    L2HM_Activation_addr,
    L2HWISA_in, L2HWISA_wr, // from L3 Host Mem ISA
    L2IR_in, L2IR_wr, // from L3 structure
    clk, rst);
    
    parameter Instruction_size = 16;
    parameter address_size = 8;
    parameter MMU_Compute_size = 6;
    parameter Data_size = 8;
    
    input [Data_size-1:0] L2HM_Weight_in; // from probably L3 Memory
    input [address_size-1:0] L2HM_Weight_addr, L2HM_Activation_addr; // from probably L3 Controller
    input L2HM_Weight_wr; // from probably L3 Controller
    input [Instruction_size-1:0] L2HWISA_in; // from probably L3 Memory
    input L2HWISA_wr; // from probably L3 Controller
    input [Instruction_size-1:0] L2IR_in; // from L3 structure
    input L2IR_wr; // from probably L3 Controller
    input clk, rst;   
    
    // for L2 Host Mem Weight
    wire [Data_size-1:0] Weight_L2HM_to_TSDSUW1, Weight_L2HM_to_TSDSUW2, Weight_L2HM_to_TSDSUW3, Weight_L2HM_to_TSDSUW4, Weight_L2HM_to_TSDSUW5, Weight_L2HM_to_TSDSUW6, Weight_L2HM_to_TSDSUW7, Weight_L2HM_to_TSDSUW8;
    wire [Data_size-1:0] Weight_L2HM_to_TSDSUW9, Weight_L2HM_to_TSDSUW10, Weight_L2HM_to_TSDSUW11, Weight_L2HM_to_TSDSUW12, Weight_L2HM_to_TSDSUW13, Weight_L2HM_to_TSDSUW14, Weight_L2HM_to_TSDSUW15, Weight_L2HM_to_TSDSUW16;
    wire L2HM_Weight_rd, L2HM_Weight_rd_counter_rst;
    // for Tiled SDS Unit Weight
    wire [Data_size-1:0] Weight_TSDSUW_to_TPUL1HM1, Weight_TSDSUW_to_TPUL1HM2, Weight_TSDSUW_to_TPUL1HM3, Weight_TSDSUW_to_TPUL1HM4, Weight_TSDSUW_to_TPUL1HM5, Weight_TSDSUW_to_TPUL1HM6, Weight_TSDSUW_to_TPUL1HM7, Weight_TSDSUW_to_TPUL1HM8;
    wire [Data_size-1:0] Weight_TSDSUW_to_TPUL1HM9, Weight_TSDSUW_to_TPUL1HM10, Weight_TSDSUW_to_TPUL1HM11, Weight_TSDSUW_to_TPUL1HM12, Weight_TSDSUW_to_TPUL1HM13, Weight_TSDSUW_to_TPUL1HM14, Weight_TSDSUW_to_TPUL1HM15, Weight_TSDSUW_to_TPUL1HM16;
    wire TSDSUW_rd, TSDSUW_wr, TSDSUW_rst;
    // for L2 Host Mem Activation
    wire [Data_size-1:0] Activation_L2HM_to_TSDSUW1, Activation_L2HM_to_TSDSUW2, Activation_L2HM_to_TSDSUW3, Activation_L2HM_to_TSDSUW4, Activation_L2HM_to_TSDSUW5, Activation_L2HM_to_TSDSUW6, Activation_L2HM_to_TSDSUW7, Activation_L2HM_to_TSDSUW8;
    wire [Data_size-1:0] Activation_L2HM_to_TSDSUW9, Activation_L2HM_to_TSDSUW10, Activation_L2HM_to_TSDSUW11, Activation_L2HM_to_TSDSUW12, Activation_L2HM_to_TSDSUW13, Activation_L2HM_to_TSDSUW14, Activation_L2HM_to_TSDSUW15, Activation_L2HM_to_TSDSUW16;
    wire L2HM_Activation_rd, L2HM_Activation_wr, L2HM_Activation_rd_counter_rst, L2HM_Activation_wr_counter_rst;
    wire [Data_size-1:0] Activation_L1HM_to_L2HM1, Activation_L1HM_to_L2HM2, Activation_L1HM_to_L2HM3, Activation_L1HM_to_L2HM4, Activation_L1HM_to_L2HM5, Activation_L1HM_to_L2HM6, Activation_L1HM_to_L2HM7, Activation_L1HM_to_L2HM8;
    wire [Data_size-1:0] Activation_L1HM_to_L2HM9, Activation_L1HM_to_L2HM10, Activation_L1HM_to_L2HM11, Activation_L1HM_to_L2HM12, Activation_L1HM_to_L2HM13, Activation_L1HM_to_L2HM14, Activation_L1HM_to_L2HM15, Activation_L1HM_to_L2HM16;
    // for Tiled SDS Unit Activation
    wire [Data_size-1:0] Activation_TSDSUW_to_TPUL1HM1, Activation_TSDSUW_to_TPUL1HM2, Activation_TSDSUW_to_TPUL1HM3, Activation_TSDSUW_to_TPUL1HM4, Activation_TSDSUW_to_TPUL1HM5, Activation_TSDSUW_to_TPUL1HM6, Activation_TSDSUW_to_TPUL1HM7, Activation_TSDSUW_to_TPUL1HM8;
    wire [Data_size-1:0] Activation_TSDSUW_to_TPUL1HM9, Activation_TSDSUW_to_TPUL1HM10, Activation_TSDSUW_to_TPUL1HM11, Activation_TSDSUW_to_TPUL1HM12, Activation_TSDSUW_to_TPUL1HM13, Activation_TSDSUW_to_TPUL1HM14, Activation_TSDSUW_to_TPUL1HM15, Activation_TSDSUW_to_TPUL1HM16;
    wire TSDSUA_rd, TSDSUA_wr, TSDSUA_rst;
    // for tiled computation
    wire [MMU_Compute_size-1:0] matrix_compute_size;
    wire tiled_computing_sig, zerofill_sig;
    // for L2 Host Mem ISA
    wire [Instruction_size-1:0] L2HWISA_out;
    wire L2HWISA_rd;
    wire [address_size-1:0] L2HM_ISA_addr;
    wire L2HM_ISA_finished_sig;
    // for L2 IR Mem (send to L2 Controller)
    wire [Instruction_size-1:0] L2IR_out;
    wire L2IR_rd;
    wire [address_size-1:0] L2IR_addr;
    wire L2IR_inc, L2IR_clr;
    
//     // for L2 Accumulator
//    wire [Data_size-1:0] Activation_L1HM_to_Accu1, Activation_L1HM_to_Accu2, Activation_L1HM_to_Accu3, Activation_L1HM_to_Accu4, Activation_L1HM_to_Accu5, Activation_L1HM_to_Accu6, Activation_L1HM_to_Accu7, Activation_L1HM_to_Accu8;
//    wire [Data_size-1:0] Activation_L1HM_to_Accu9, Activation_L1HM_to_Accu10, Activation_L1HM_to_Accu11, Activation_L1HM_to_Accu12, Activation_L1HM_to_Accu13, Activation_L1HM_to_Accu14, Activation_L1HM_to_Accu15, Activation_L1HM_to_Accu16;
//    wire [Data_size-1:0] Activation_Accu_to_L2HM1, Activation_Accu_to_L2HM2, Activation_Accu_to_L2HM3, Activation_Accu_to_L2HM4, Activation_Accu_to_L2HM5, Activation_Accu_to_L2HM6, Activation_Accu_to_L2HM7, Activation_Accu_to_L2HM8;
//    wire [Data_size-1:0] Activation_Accu_to_L2HM9, Activation_Accu_to_L2HM10, Activation_Accu_to_L2HM11, Activation_Accu_to_L2HM12, Activation_Accu_to_L2HM13, Activation_Accu_to_L2HM14, Activation_Accu_to_L2HM15, Activation_Accu_to_L2HM16;
//    wire L2_Accumulator_rd, L2_Accumulator_wr, L2_Accumulator_finish_storing, L2_Accumulator_finish_sending, L2_Accumulator_rst;
    // for TPU4x4 Unit
    wire L1_Controller_start_sig, L1IR_wr, TPU_Weight_TsdsU_wr, TPU_Activation_TsdsU_wr, TPU_Activation_L1HM_rd, TPU_L1HW_counter_rst, TPU_Computation_finished_signal;
    wire [address_size-1:0] L1IR_addr;
    
    
    L2_Host_Memory_Weight L2HMW1(.R_data1(Weight_L2HM_to_TSDSUW1), .R_data2(Weight_L2HM_to_TSDSUW2), .R_data3(Weight_L2HM_to_TSDSUW3), .R_data4(Weight_L2HM_to_TSDSUW4), .R_data5(Weight_L2HM_to_TSDSUW5), .R_data6(Weight_L2HM_to_TSDSUW6), .R_data7(Weight_L2HM_to_TSDSUW7), .R_data8(Weight_L2HM_to_TSDSUW8),
    .R_data9(Weight_L2HM_to_TSDSUW9), .R_data10(Weight_L2HM_to_TSDSUW10), .R_data11(Weight_L2HM_to_TSDSUW11), .R_data12(Weight_L2HM_to_TSDSUW12), .R_data13(Weight_L2HM_to_TSDSUW13), .R_data14(Weight_L2HM_to_TSDSUW14), .R_data15(Weight_L2HM_to_TSDSUW15), .R_data16(Weight_L2HM_to_TSDSUW16), 
    .W_data(L2HM_Weight_in), .addr(L2HM_Weight_addr), .clk(clk), .rd(L2HM_Weight_rd), .wr(L2HM_Weight_wr),
    .L2HM_counter_rst(L2HM_Weight_rd_counter_rst));
    
    Tiled_SDS_Unit TSDSUW1( // for weight
    .R_data1(Weight_TSDSUW_to_TPUL1HM1), .R_data2(Weight_TSDSUW_to_TPUL1HM2), .R_data3(Weight_TSDSUW_to_TPUL1HM3), .R_data4(Weight_TSDSUW_to_TPUL1HM4), .R_data5(Weight_TSDSUW_to_TPUL1HM5), .R_data6(Weight_TSDSUW_to_TPUL1HM6), .R_data7(Weight_TSDSUW_to_TPUL1HM7), .R_data8(Weight_TSDSUW_to_TPUL1HM8),
    .R_data9(Weight_TSDSUW_to_TPUL1HM9), .R_data10(Weight_TSDSUW_to_TPUL1HM10), .R_data11(Weight_TSDSUW_to_TPUL1HM11), .R_data12(Weight_TSDSUW_to_TPUL1HM12), .R_data13(Weight_TSDSUW_to_TPUL1HM13), .R_data14(Weight_TSDSUW_to_TPUL1HM14), .R_data15(Weight_TSDSUW_to_TPUL1HM15), .R_data16(Weight_TSDSUW_to_TPUL1HM16),
    .W_data1(Weight_L2HM_to_TSDSUW1), .W_data2(Weight_L2HM_to_TSDSUW2), .W_data3(Weight_L2HM_to_TSDSUW3), .W_data4(Weight_L2HM_to_TSDSUW4), .W_data5(Weight_L2HM_to_TSDSUW5), .W_data6(Weight_L2HM_to_TSDSUW6), .W_data7(Weight_L2HM_to_TSDSUW7), .W_data8(Weight_L2HM_to_TSDSUW8), 
    .W_data9(Weight_L2HM_to_TSDSUW9), .W_data10(Weight_L2HM_to_TSDSUW10), .W_data11(Weight_L2HM_to_TSDSUW11), .W_data12(Weight_L2HM_to_TSDSUW12), .W_data13(Weight_L2HM_to_TSDSUW13), .W_data14(Weight_L2HM_to_TSDSUW14), .W_data15(Weight_L2HM_to_TSDSUW15), .W_data16(Weight_L2HM_to_TSDSUW16), 
    .rd(TSDSUW_rd), .wr(TSDSUW_wr), .tiled_computing_sig(tiled_computing_sig), .zerofill_sig(zerofill_sig), .matrix_compute_size(matrix_compute_size), .clk(clk), .rst(TSDSUW_rst)
    );
    
    L2_Host_Memory_Activation L2HMA1(.R_data1(Activation_L2HM_to_TSDSUW1), .R_data2(Activation_L2HM_to_TSDSUW2), .R_data3(Activation_L2HM_to_TSDSUW3), .R_data4(Activation_L2HM_to_TSDSUW4), .R_data5(Activation_L2HM_to_TSDSUW5), .R_data6(Activation_L2HM_to_TSDSUW6), .R_data7(Activation_L2HM_to_TSDSUW7), .R_data8(Activation_L2HM_to_TSDSUW8),
    .R_data9(Activation_L2HM_to_TSDSUW9), .R_data10(Activation_L2HM_to_TSDSUW10), .R_data11(Activation_L2HM_to_TSDSUW11), .R_data12(Activation_L2HM_to_TSDSUW12), .R_data13(Activation_L2HM_to_TSDSUW13), .R_data14(Activation_L2HM_to_TSDSUW14), .R_data15(Activation_L2HM_to_TSDSUW15), .R_data16(Activation_L2HM_to_TSDSUW16), 
    .W_data1(Activation_L1HM_to_L2HM1), .W_data2(Activation_L1HM_to_L2HM2), .W_data3(Activation_L1HM_to_L2HM3), .W_data4(Activation_L1HM_to_L2HM4), .W_data5(Activation_L1HM_to_L2HM5), .W_data6(Activation_L1HM_to_L2HM6), .W_data7(Activation_L1HM_to_L2HM7), .W_data8(Activation_L1HM_to_L2HM8), 
    .W_data9(Activation_L1HM_to_L2HM9), .W_data10(Activation_L1HM_to_L2HM10), .W_data11(Activation_L1HM_to_L2HM11), .W_data12(Activation_L1HM_to_L2HM12), .W_data13(Activation_L1HM_to_L2HM13), .W_data14(Activation_L1HM_to_L2HM14), .W_data15(Activation_L1HM_to_L2HM15), .W_data16(Activation_L1HM_to_L2HM16),  
    .addr(L2HM_Activation_addr), .clk(clk), .rd(L2HM_Activation_rd), .wr(L2HM_Activation_wr),   
    .L2HM_rd_counter_rst(L2HM_Activation_rd_counter_rst), .L2HM_wr_counter_rst(L2HM_Activation_wr_counter_rst));
    
    Tiled_SDS_Unit TSDSUA1( // for activation
    .R_data1(Activation_TSDSUW_to_TPUL1HM1), .R_data2(Activation_TSDSUW_to_TPUL1HM2), .R_data3(Activation_TSDSUW_to_TPUL1HM3), .R_data4(Activation_TSDSUW_to_TPUL1HM4), .R_data5(Activation_TSDSUW_to_TPUL1HM5), .R_data6(Activation_TSDSUW_to_TPUL1HM6), .R_data7(Activation_TSDSUW_to_TPUL1HM7), .R_data8(Activation_TSDSUW_to_TPUL1HM8),
    .R_data9(Activation_TSDSUW_to_TPUL1HM9), .R_data10(Activation_TSDSUW_to_TPUL1HM10), .R_data11(Activation_TSDSUW_to_TPUL1HM11), .R_data12(Activation_TSDSUW_to_TPUL1HM12), .R_data13(Activation_TSDSUW_to_TPUL1HM13), .R_data14(Activation_TSDSUW_to_TPUL1HM14), .R_data15(Activation_TSDSUW_to_TPUL1HM15), .R_data16(Activation_TSDSUW_to_TPUL1HM16),
    .W_data1(Activation_L2HM_to_TSDSUW1), .W_data2(Activation_L2HM_to_TSDSUW2), .W_data3(Activation_L2HM_to_TSDSUW3), .W_data4(Activation_L2HM_to_TSDSUW4), .W_data5(Activation_L2HM_to_TSDSUW5), .W_data6(Activation_L2HM_to_TSDSUW6), .W_data7(Activation_L2HM_to_TSDSUW7), .W_data8(Activation_L2HM_to_TSDSUW8), 
    .W_data9(Activation_L2HM_to_TSDSUW9), .W_data10(Activation_L2HM_to_TSDSUW10), .W_data11(Activation_L2HM_to_TSDSUW11), .W_data12(Activation_L2HM_to_TSDSUW12), .W_data13(Activation_L2HM_to_TSDSUW13), .W_data14(Activation_L2HM_to_TSDSUW14), .W_data15(Activation_L2HM_to_TSDSUW15), .W_data16(Activation_L2HM_to_TSDSUW16), 
    .rd(TSDSUA_rd), .wr(TSDSUA_wr), .tiled_computing_sig(tiled_computing_sig), .zerofill_sig(zerofill_sig), .matrix_compute_size(matrix_compute_size), .clk(clk), .rst(TSDSUA_rst)
    );
    
    L2_Host_Memory_InstructionSet L2HMISA1(.R_data(L2HWISA_out), .W_data(L2HWISA_in), .addr(L2HM_ISA_addr), .clk(clk), .IR_rd(L2HWISA_rd), .IR_wr(L2HWISA_wr), .finished_sig(L2HM_ISA_finished_sig));
    
    L2_IR_Mem L2IRMEM1(.R_data(L2IR_out), .W_data(L2IR_in), .addr(L2IR_addr), .clk(clk), .IR_rd(L2IR_rd), .IR_wr(L2IR_wr));
    
    L2_IR_counter L2IRC1(.IR_addr(L2IR_addr), .IR_inc(L2IR_inc), .IR_clr(L2IR_clr), .clk(clk));
    
//    L2_Accumulator L2Accumulator1(.Data_in1(Activation_L1HM_to_Accu1), .Data_in2(Activation_L1HM_to_Accu2), .Data_in3(Activation_L1HM_to_Accu3), .Data_in4(Activation_L1HM_to_Accu4), .Data_in5(Activation_L1HM_to_Accu5), .Data_in6(Activation_L1HM_to_Accu6), .Data_in7(Activation_L1HM_to_Accu7), .Data_in8(Activation_L1HM_to_Accu8), 
//    .Data_in9(Activation_L1HM_to_Accu9), .Data_in10(Activation_L1HM_to_Accu10), .Data_in11(Activation_L1HM_to_Accu11), .Data_in12(Activation_L1HM_to_Accu12), .Data_in13(Activation_L1HM_to_Accu13), .Data_in14(Activation_L1HM_to_Accu14), .Data_in15(Activation_L1HM_to_Accu15), .Data_in16(Activation_L1HM_to_Accu16), 
//    .Data_out1(Activation_Accu_to_L2HM1), .Data_out2(Activation_Accu_to_L2HM2), .Data_out3(Activation_Accu_to_L2HM3), .Data_out4(Activation_Accu_to_L2HM4), .Data_out5(Activation_Accu_to_L2HM5), .Data_out6(Activation_Accu_to_L2HM6), .Data_out7(Activation_Accu_to_L2HM7), .Data_out8(Activation_Accu_to_L2HM8), 
//    .Data_out9(Activation_Accu_to_L2HM9), .Data_out10(Activation_Accu_to_L2HM10), .Data_out11(Activation_Accu_to_L2HM11), .Data_out12(Activation_Accu_to_L2HM12), .Data_out13(Activation_Accu_to_L2HM13), .Data_out14(Activation_Accu_to_L2HM14), .Data_out15(Activation_Accu_to_L2HM15), .Data_out16(Activation_Accu_to_L2HM16), 
//    .tiled_computing_sig(tiled_computing_sig), .rd(L2_Accumulator_rd), .wr(L2_Accumulator_wr), .L2_Accumulator_finish_storing(L2_Accumulator_finish_storing), .L2_Accumulator_finish_sending(L2_Accumulator_finish_sending),
//    .clk(clk), .rst(L2_Accumulator_rst)
//    );
    
    TPU4x4 TPU1(.Controller_start_sig(L1_Controller_start_sig), .IR_in(L2HWISA_out), .IR_wr_addr(L1IR_addr), .IR_wr(L1IR_wr), 
    .Weight_TsdsU_wr(TPU_Weight_TsdsU_wr), .Activation_TsdsU_wr(TPU_Activation_TsdsU_wr), .Activation_L1HM_rd(TPU_Activation_L1HM_rd), 
    .Weight_TsdsU1_in(Weight_TSDSUW_to_TPUL1HM1), .Weight_TsdsU2_in(Weight_TSDSUW_to_TPUL1HM2), .Weight_TsdsU3_in(Weight_TSDSUW_to_TPUL1HM3), .Weight_TsdsU4_in(Weight_TSDSUW_to_TPUL1HM4), .Weight_TsdsU5_in(Weight_TSDSUW_to_TPUL1HM5), .Weight_TsdsU6_in(Weight_TSDSUW_to_TPUL1HM6), .Weight_TsdsU7_in(Weight_TSDSUW_to_TPUL1HM7), .Weight_TsdsU8_in(Weight_TSDSUW_to_TPUL1HM8),
    .Weight_TsdsU9_in(Weight_TSDSUW_to_TPUL1HM9), .Weight_TsdsU10_in(Weight_TSDSUW_to_TPUL1HM10), .Weight_TsdsU11_in(Weight_TSDSUW_to_TPUL1HM11), .Weight_TsdsU12_in(Weight_TSDSUW_to_TPUL1HM12), .Weight_TsdsU13_in(Weight_TSDSUW_to_TPUL1HM13), .Weight_TsdsU14_in(Weight_TSDSUW_to_TPUL1HM14), .Weight_TsdsU15_in(Weight_TSDSUW_to_TPUL1HM15), .Weight_TsdsU16_in(Weight_TSDSUW_to_TPUL1HM16),
    .Activation_TsdsU1_in(Activation_TSDSUW_to_TPUL1HM1), .Activation_TsdsU2_in(Activation_TSDSUW_to_TPUL1HM2), .Activation_TsdsU3_in(Activation_TSDSUW_to_TPUL1HM3), .Activation_TsdsU4_in(Activation_TSDSUW_to_TPUL1HM4), .Activation_TsdsU5_in(Activation_TSDSUW_to_TPUL1HM5), .Activation_TsdsU6_in(Activation_TSDSUW_to_TPUL1HM6), .Activation_TsdsU7_in(Activation_TSDSUW_to_TPUL1HM7), .Activation_TsdsU8_in(Activation_TSDSUW_to_TPUL1HM8), 
    .Activation_TsdsU9_in(Activation_TSDSUW_to_TPUL1HM9), .Activation_TsdsU10_in(Activation_TSDSUW_to_TPUL1HM10), .Activation_TsdsU11_in(Activation_TSDSUW_to_TPUL1HM11), .Activation_TsdsU12_in(Activation_TSDSUW_to_TPUL1HM12), .Activation_TsdsU13_in(Activation_TSDSUW_to_TPUL1HM13), .Activation_TsdsU14_in(Activation_TSDSUW_to_TPUL1HM14), .Activation_TsdsU15_in(Activation_TSDSUW_to_TPUL1HM15), .Activation_TsdsU16_in(Activation_TSDSUW_to_TPUL1HM16), 
    .Activation_L1HM_out1(Activation_L1HM_to_L2HM1), .Activation_L1HM_out2(Activation_L1HM_to_L2HM2), .Activation_L1HM_out3(Activation_L1HM_to_L2HM3), .Activation_L1HM_out4(Activation_L1HM_to_L2HM4), .Activation_L1HM_out5(Activation_L1HM_to_L2HM5), .Activation_L1HM_out6(Activation_L1HM_to_L2HM6), .Activation_L1HM_out7(Activation_L1HM_to_L2HM7), .Activation_L1HM_out8(Activation_L1HM_to_L2HM8), 
    .Activation_L1HM_out9(Activation_L1HM_to_L2HM9), .Activation_L1HM_out10(Activation_L1HM_to_L2HM10), .Activation_L1HM_out11(Activation_L1HM_to_L2HM11), .Activation_L1HM_out12(Activation_L1HM_to_L2HM12), .Activation_L1HM_out13(Activation_L1HM_to_L2HM13), .Activation_L1HM_out14(Activation_L1HM_to_L2HM14), .Activation_L1HM_out15(Activation_L1HM_to_L2HM15), .Activation_L1HM_out16(Activation_L1HM_to_L2HM16), 
    .L1HW_counter_rst(TPU_L1HW_counter_rst), .tiled_computing_sig(tiled_computing_sig),
    .Computation_finished_signal(TPU_Computation_finished_signal), .clk(clk), .rst(rst));
    
    L2_Controller L2Contorller1(
    .L2HM_Weight_rd(L2HM_Weight_rd), .L2HM_Weight_counter_rst(L2HM_Weight_rd_counter_rst), // for L2 Host Memory Weight
    .L2HM_Activation_rd(L2HM_Activation_rd), .L2HM_Activation_wr(L2HM_Activation_wr), .L2HM_Activation_rd_counter_rst(L2HM_Activation_rd_counter_rst), .L2HM_Activation_wr_counter_rst(L2HM_Activation_wr_counter_rst), // for L2 Host Memory Activation
    .matrix_compute_size(matrix_compute_size), .tiled_computing_sig(tiled_computing_sig), .zerofill_sig(zerofill_sig), // for both W&A TSDSU, tiled_computing_sig also for L2 Accumulator 
    .TSDSUW_rd(TSDSUW_rd), .TSDSUW_wr(TSDSUW_wr), .TSDSUW_rst(TSDSUW_rst), // for TSDSUW
    .TSDSUA_rd(TSDSUA_rd), .TSDSUA_wr(TSDSUA_wr), .TSDSUA_rst(TSDSUA_rst), // for TSDSUA
    .L2HM_ISA_addr(L2HM_ISA_addr), .L2HM_ISA_rd(L2HWISA_rd), .L2HM_ISA_wr(), .L2HM_ISA_finished_sig(L2HM_ISA_finished_sig), // for L2 Host Memory ISA
    .L2IR_out(L2IR_out), .L2IR_rd(L2IR_rd), .L2IR_wr(), // for L2 IR Memory (stored ISA for L2_Controller)
    .L2IR_inc(L2IR_inc), .L2IR_clr(L2IR_clr), // for L2 IR counter
//    .L2_Accumulator_rd(L2_Accumulator_rd), .L2_Accumulator_wr(L2_Accumulator_wr), .L2_Accumulator_finish_storing(L2_Accumulator_finish_storing), .L2_Accumulator_finish_sending(L2_Accumulator_finish_sending), .L2_Accumulator_rst(L2_Accumulator_rst), // for L2 Accumulator
    .L1_Controller_start_sig(L1_Controller_start_sig), .L1IR_addr(L1IR_addr), .L1IR_wr(L1IR_wr), .TPU_Weight_TsdsU_wr(TPU_Weight_TsdsU_wr), .TPU_Activation_TsdsU_wr(TPU_Activation_TsdsU_wr), .TPU_Activation_L1HM_rd(TPU_Activation_L1HM_rd), .TPU_L1HW_counter_rst(TPU_L1HW_counter_rst), // for TPU4x4
    .TPU_Computation_finished_signal(TPU_Computation_finished_signal), // for TPU4x4
    .clk(clk), .rst(rst)
    );
    
endmodule
