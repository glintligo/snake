module keycheck(
    input wire clk, rst_n,
    input wire key,
    output reg key_v
    );

    // 20ms parameter
//    localparam TIME_20MS = 1_000_000;
    localparam TIME_20MS = 1_000;       // just for test

    // variable
    reg [20:0] cnt;
    reg key_cnt;

    reg key_in_r0;
	
	always @ (posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			key_in_r0 <= 0;
		end
		else begin
			key_in_r0 <= key;
		end
	end
	
	wire edge_l, edge_h;
	assign edge_l = key_in_r0 & (~key); //下降沿检测
	assign edge_h = key & (~key_in_r0);//上升沿检测
	
	wire edge_en; //键值变化后，edge_en变为高
	assign edge_en = edge_l | edge_h;
	
	always @ (posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			cnt <= 0;
		end
		else if(edge_en) begin
			cnt <= 0;
		end
		else begin
			cnt <= cnt + 1;
		end
	
	end
	
	always @ (posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			key_v <= 1'b0;
		end
		else if(cnt == TIME_20MS - 1) begin
			key_v <= key;
		end
	end

    // // debounce time passed, refresh key state
    // always @(posedge clk or negedge rst_n) begin
    //     if(rst_n == 0)
    //         key_v <= 0;
    //     else if(cnt == TIME_20MS - 1)
    //         key_v <= key;
    // end

    // // while in debounce state, count, otherwise 0
    // always @(posedge clk or negedge rst_n) begin
    //     if(rst_n == 0)
    //         cnt <= 0;
    //     else if(key_cnt)
    //         cnt <= cnt + 1'b1;
    //     else
    //         cnt <= 0; 
    // end
     
    //  // 
    //  always @(posedge clk or negedge rst_n) begin
    //         if(rst_n == 0)
    //             key_cnt <= 0;
    //         else if(key_cnt == 0 && key != key_v)
    //             key_cnt <= 1;
    //         else if(cnt == TIME_20MS - 1)
    //             key_cnt <= 0;
    //  end
endmodule