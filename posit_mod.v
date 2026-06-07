`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.01.2026 19:15:32
// Design Name: 
// Module Name: posit_mod
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
module LOD_N (
    in,out
);
parameter N=16;
parameter S=(N==64)?6:
          (N==32)?5:
          (N==16)?4:
          (N==8)?3:3;
input [N-1:0] in;
output [S-1:0] out;
wire vld;
generate
    if(N==64) begin
        LOD64 LOD64_1 (
            .in(in),
            .out(out),
            .vld(vld)
        );
    end else if (N==32) begin
        LOD32 LOD32_1 (
            .in(in),
            .out(out),
            .vld(vld)
        );
    end else if (N==16) begin
        LOD16 LOD16_1 (
            .in(in),
            .out(out),
            .vld(vld)
        );
    end else if (N==8) begin
        LOD8 LOD8_1 (
            .in(in),
            .out(out),
            .vld(vld)
        );
    end
endgenerate
endmodule
//leading one detector for N bits
//module LOD_N (in, out);

  //function [31:0] log2;
    //input reg [31:0] value;
    //begin
      //value = value-1;
      //for (log2=0; value>0; log2=log2+1)
	//value = value>>1;
    //end
  //endfunction

//parameter N = 16;
//parameter S = log2(N); 
//input [N-1:0] in;
//output [S-1:0] out;

//wire vld;
//LOD #(.N(N)) l1 (in, out, vld);
//endmodule


//module LOD (in, out, vld);

  //function [31:0] log2;
    //input reg [31:0] value;
    //begin
      //value = value-1;
      //for (log2=0; value>0; log2=log2+1)
//	value = value>>1;
  //  end
 // endfunction


//parameter N = 16;
//parameter S = log2(N);

  // input [N-1:0] in;
   //output [S-1:0] out;
  // output vld;

//  generate
  //  if (N == 2)
    //  begin
//	assign vld = |in;
	//assign out = ~in[1] & in[0];
      //end
   // else if (N & (N-1))
     // LOD #(1<<S) LOD1 ({1<<S {1'b0}} | in,out,vld);
   // else
     // begin
//	wire [S-2:0] out_l, out_h;
	//wire out_vl, out_vh;
	//LOD #(N>>1) l(in[(N>>1)-1:0],out_l,out_vl);
	//LOD #(N>>1) h(in[N-1:N>>1],out_h,out_vh);
	//assign vld = out_vl | out_vh;
	//assign out = out_vh ? {1'b0,out_h} : {out_vl,out_l};
      //end
  //endgenerate
//endmodule
//leading zero detector for N bits
//module LZD_N (in, out);

 

//parameter N = 16;
//parameter S =(N==64)?6:(N==32)?5:(N==16)?4:(N==8)?3:3; 
//input [N-1:0] in;
//output [S-1:0] out;

//wire vld;
//LZD #(.N(N)) l1 (in, out, vld);
//endmodule


//module LZD (in, out, vld);

 

//parameter N = 16;
//parameter S =(N==64)?6:(N==32)?5:(N==16)?4:(N==8)?3:3; 

   //input [N-1:0] in;
   //output [S-1:0] out;
   //output vld;

  //generate
    //if (N == 2)
     // begin
	//assign vld = ~&in;
//	assign out = in[1] & ~in[0];
     // end
    //else if (N & (N-1))
      //LZD #(1<<S) LZD1 ({1<<S {1'b0}} | in,out,vld);
    //else
      //begin
	//wire [S-2:0] out_l;
	//wire [S-2:0] out_h;
	//wire out_vl, out_vh;
	//LZD #(N>>1) l(in[(N>>1)-1:0],out_l,out_vl);
	//LZD #(N>>1) h(in[N-1:N>>1],out_h,out_vh);
	//assign vld = out_vl | out_vh;
	//assign out = out_vh ? {1'b0,out_h} : {out_vl,out_l};
    //  end
  //endgenerate
//endmodule

module LOD8 (
    in,out,vld
);
parameter N=8;
parameter S=3;
input [N-1:0] in;
output reg [S-1:0] out;
output vld;
assign vld = |in;
always @(*) begin
    casez (in)
        8'b1???????: out = 3'd0;
        8'b01??????: out = 3'd1;
        8'b001?????: out = 3'd2;
        8'b0001????: out = 3'd3;
        8'b00001???: out = 3'd4;
        8'b000001??: out = 3'd5;
        8'b0000001?: out = 3'd6;
        8'b00000001: out = 3'd7;
        default:     out = 3'd0; 
    endcase
end
endmodule
module LOD16 (
    in,out,vld
);
input [15:0] in;
output [3:0] out;
output vld;
wire [2:0] o_hi, o_lo;
    wire v_hi, v_lo;
LOD8 LOD8_1 (
    .in(in[15:8]),
    .out(o_hi),
    .vld(v_hi)
);
LOD8 LOD8_2(.in(in[7:0]), .out(o_lo), .vld(v_lo));
assign vld = v_hi | v_lo;
assign out = v_hi ? {1'b0, o_hi} : {1'b1, o_lo};

endmodule
module LOD32 (
    in,out,vld
);
input [31:0] in;
output [4:0] out;
output vld;
wire [3:0]o1,o2;
wire v_hi, v_lo;
LOD16 LOD16_1 (
    .in(in[31:16]),
    .out(o1),.vld(v_hi)
);
LOD16 LOD16_2(.in(in[15:0]), .out(o2), .vld(v_lo));
assign vld = v_hi | v_lo;
assign out = v_hi ? {1'b0, o1} : {1'b1, o2};

endmodule
module LOD64 (
    in,out,vld
);
input [63:0] in;
output [5:0] out;
output vld;
wire [4:0]o1,o2;
wire v_hi,v_lo;
LOD32 LOD32_1 (
    .in(in[63:32]),
    .out(o1), .vld(v_hi)
);
LOD32 LOD32_2(.in(in[31:0]), .out(o2), .vld(v_lo));
assign vld = v_hi | v_lo;
assign out = v_hi ? {1'b0, o1} : {1'b1, o2};

endmodule
//extracts fields from the input posit number
module data_extract (in, rc, regime, exp, mant);
parameter N=16;

parameter B =(N==64)?6:(N==32)?5:(N==16)?4:(N==8)?3:3; 
parameter E=2;
    input [N-1:0] in;
    output  rc;
    output wire [B-1:0] regime;
    output wire[E-1:0] exp;
    output wire [N-3-E:0] mant;
    wire[B-1:0] k1,k0;
   // integer i;
   wire s=in[N-1];
   wire [B-1:0] run_len;
   wire [N-1:0] xin;
    //LOD_N  xinst_k0(.in({in[N-2:0],1'b0}), .out(k0));
 assign rc = in[N-2] ^ (s & 1'b0);
 assign xin= rc? -in : in;
LOD_N xinst_k1(.in({xin[N-2:0],1'b0}), .out(k1));

assign regime = in[N-2] ? (k1-1) : k1;
assign run_len=in[N-2]?k1:k1;
    
   // always @(*) begin
     //   rc = in[N-2];
       // run_len = 1;
        //for (i = N-3; i >= 0; i = i - 1) begin
          //  if (in[i] == rc && run_len == (N-2 - i)) begin
            //    run_len = run_len + 1;
            //end
        //end
        
      
        //if (rc) regime = run_len - 1;
        //else    regime = run_len;
       assign {exp, mant} = in[N-3:0] << run_len;
        
       
    //end
endmodule

//Finite state machine for finding modulus of two posit mantissas
module mod_fsm (
   clk,
    rst,
    start,
    mant_a, 
    mant_b,
   exp_a,
    exp_b,
   mant_out,
    exp_out);
    parameter N=16;
//function [31:0] log2;
//input reg [31:0] value;
	//begin
	//value = value-1;
	//for (log2=0; value>0; log2=log2+1)
      //  	value = value>>1;
      	//end
//endfunction
parameter B =(N==64)?6:(N==32)?5:(N==16)?4:(N==8)?3:3; 
parameter E=2;
input clk,rst,start;
    input [N-1:0] mant_a, mant_b;
    input wire signed [B+E:0] exp_a,exp_b;
    output reg [N-1:0] mant_out;
    output reg signed [B+E:0] exp_out;

    parameter S_IDLE     = 3'd0;
    parameter S_START   = 3'd1;
    parameter S_LOOP = 3'd2;
    parameter S_NORM     = 3'd3;
    parameter S_DONE     = 3'd4;

    reg [2:0] state;
    reg [2*N-1:0] rem, div;
    reg [B+E:0] final_exp;
    reg  [B+E:0] loop_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            mant_out <= 0;
            exp_out <= 0;
            rem <= 0;
            div <= 0;
            loop_count <= 0;
            final_exp<=0;
        end else begin
            case (state)
                S_IDLE: begin
                 final_exp<=0;
                    if (start) state <= S_START;
                    else state<=S_IDLE;
                end

               
                S_START: begin
                    rem <= {{N{1'b0}}, mant_a};
                    div <= {{N{1'b0}}, mant_b};
                    if (exp_a < exp_b) begin
                        mant_out <= mant_a;
                        final_exp <= exp_a;
                        state <= S_DONE;
                    end else begin
                        loop_count <= exp_a - exp_b;
                        final_exp <= exp_b;
                        state <= S_LOOP;
                    end
                end
                S_LOOP: begin
                   
                    if (rem >= div) begin
                        rem = rem - div;
                    end
                    if (loop_count == 0) begin
                         state <= S_NORM;
                    end else begin
                    rem=rem<<1;
                        //rem <= (rem >= div) ? ((rem - div) << 1) : (rem << 1);
                        loop_count <= loop_count - 1;
                        state<=S_LOOP;
                    end
                end

                S_NORM: begin
                    if (rem == 0) begin
                        mant_out <= 0;
                        exp_out <= 0;
                        state <= S_DONE;
                    end 
                    else if (rem[N-2-E] == 0 && rem!=0) begin
                        rem <= rem << 1;
                        final_exp <= final_exp - 1;
                        state<=S_NORM;
                    end
                    else begin
                        
                        state <= S_DONE;
                    end
                end

             
                S_DONE: begin
                    mant_out <= rem[N-1:0];
                    exp_out <= final_exp;
                    state <= S_IDLE; 
                end
                default:state<=S_IDLE;
            endcase
        end
    end
endmodule

//module for performing posit mod operation
module posit_mod (
    a,
     b,
    clk,rst,start,
     out
);
 parameter N=16;
 
//function [31:0] log2;
//input reg [31:0] value;
	///begin
	//value = value-1;
	//for (log2=0; value>0; log2=log2+1)
        //	value = value>>1;
      	//end
//endfunction
parameter B =(N==64)?6:(N==32)?5:(N==16)?4:(N==8)?3:3; 
parameter E=2;
 input [N-1:0] a, b;
    input clk,rst,start;
    output reg [N-1:0] out;
   
    wire s1 = a[N-1];
    wire s2 = b[N-1];
    wire rc1, rc2;
    wire [B-1:0] regime1, regime2;
    wire [E-1:0] e1, e2;
    wire [N-3-E:0] mant1, mant2;
    
    
    wire [N-1:0] xin1 = s1 ? -a : a;
    wire [N-1:0] xin2 = s2 ? -b : b;
    
    data_extract DE1 (.in(xin1), .rc(rc1), .regime(regime1), .exp(e1), .mant(mant1));
    data_extract DE2 (.in(xin2), .rc(rc2), .regime(regime2), .exp(e2), .mant(mant2));

    wire signed [B+E:0] scale1 = (rc1) ? ({regime1, {E{1'b0}}} + e1) : (-{regime1, {E{1'b0}}} + e1);
    wire signed [B+E:0] scale2 = (rc2) ? ({regime2, {E{1'b0}}} + e2) : (-{regime2, {E{1'b0}}} + e2);

    wire [N-1:0] p = {{E+1{1'b0}}, 1'b1, mant1};
    wire [N-1:0] q = {{E+1{1'b0}}, 1'b1, mant2};
    
    wire [N-1:0] res_mant; 
    wire signed [B+E:0] res_exp;
    
    mod_fsm md1(
        .mant_a(p),
        .mant_b(q),
        .exp_a(scale1),
        .exp_b(scale2),
        .mant_out(res_mant),
        .exp_out(res_exp),
        .clk(clk),.rst(rst),.start(start)
    );
    // posit number construction from mantissa and exponent 
    reg [N/2:0] k, e;
   // reg [2:0] out_regime_bits;
    reg [E-1:0] out_exp_bits;
    reg [N-E-3:0] out_mant_bits;
    reg signed [2*N-1:0]  temp_out;
    always @(*) begin
        if (res_mant == 0) begin
            out = {N{1'b0}};
        end else begin
            if(res_exp >  0) begin
            k = res_exp>>E;
            e = res_exp[E-1:0];
            //out_regime_bits=k+1;
            out_exp_bits = e[E-1:0];
            out_mant_bits = res_mant[N-3-E:0];
            
            
            
                temp_out = {1'b1, 1'b0, out_exp_bits, out_mant_bits[N-E-3:0],{N{1'b0}}};
                temp_out=temp_out>>>k;
                if(s1==1)
            out = -{1'b0,temp_out[2*N-1:N+1]};
            else out = {1'b0,temp_out[2*N-1:N+1]};
            end
            else begin
                k = (-res_exp + (1<<E)-1) >> E; 
                 e = res_exp[E-1:0];
                 out_exp_bits = e[E-1:0];
            out_mant_bits = res_mant[N-3-E:0];
                temp_out = {1'b1, out_exp_bits, out_mant_bits, {N+1{1'b0}}};
                temp_out = temp_out >> k; 
                if(s1==1)
                out = -{1'b0, temp_out[2*N-1:N+1]};
                else out = {1'b0,temp_out[2*N-1:N+1]};
            end
        end
    end

endmodule

