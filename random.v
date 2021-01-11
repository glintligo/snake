module random(
    input clk,
    input rst_n,
   // input load,
   // input[8:0] seed,
    output reg[8:0] rand_num
    );
//-----------------------------------------------------------------------------------
always@(posedge clk or negedge rst_n)
    if(!rst_n)  rand_num <= 9'd132;
   // else if(load) rand_num <= seed;
   // else if(load) rand_num <= 9'd131;
    else 
        begin
            rand_num[0] <= rand_num[8];
            rand_num[1] <= rand_num[0];
            rand_num[2] <= rand_num[1];
            rand_num[3] <= rand_num[2];
            rand_num[4] <= rand_num[3]^rand_num[8];
            rand_num[5] <= rand_num[4]^rand_num[8];
            rand_num[6] <= rand_num[5]^rand_num[8];
            rand_num[7] <= rand_num[6];
            rand_num[8] <= rand_num[7];
        end
endmodule