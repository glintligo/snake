
module snack_control(
    input clk,
    input rst_n,
    input key_r,
    input key_l,
    input key_u,
    input key_d,
    input [9:0]box_x,
    input [9:0]box_y,
    input [9:0]x_pos,
    input [9:0]y_pos,
    output reg drive,
    output  snack_r,
    output reg fin//游戏结束标志位
    );
    //------------------------------------------------------------------------------
    //蛇头移动方向控制
    wire key_r1;
    wire key_l1;
    wire key_u1;
    wire key_d1;
    reg[1:0]dir;//蛇头方向寄存器
    parameter right = 2'd0;
    parameter left = 2'd1;
    parameter up = 2'd2;
    parameter down = 2'd3;
    keycheck r_keycheck(
                    .clk(clk),
                    .rst_n(rst_n),
                    .key(key_r),
                    .key_v(key_r1)
                    );
    keycheck l_keycheck(
                    .clk(clk),
                    .rst_n(rst_n),
                    .key(key_l),
                    .key_v(key_l1)
                    );
    keycheck u_keycheck(
                   .clk(clk),
                   .rst_n(rst_n),
                   .key(key_u),
                   .key_v(key_u1)
                   );
    keycheck d_keycheck(
                   .clk(clk),
                   .rst_n(rst_n),
                   .key(key_d),
                   .key_v(key_d1)
                   );
     always@(posedge clk or negedge rst_n)
        if(!rst_n)  dir <= right;
        else if(!key_r1 && dir != left)  dir <= right;
        else if(!key_l1 && dir != right) dir <= left;
        else if(!key_u1 && dir != down)  dir <= up;
        else if(!key_d1 && dir != up)    dir <= down;
    //------------------------------------------------------------------------------
    //蛇体寄存器，蛇体坐标和当前移动方向

    reg[9:0]snack_x[11:0];
    reg[9:0]snack_y[11:0];
    reg [18:0]cnt_m; //最大值312500;
    parameter update_time = 19'd312500;
    //更新计数器
    always@(posedge clk or negedge rst_n)
        if(!rst_n)  cnt_m <= 19'd0;
        else if(fin)    cnt_m <= 19'd0;
        else if(cnt_m == update_time)    cnt_m <= 19'd0;
        else    cnt_m <= cnt_m + 19'd1;
    //蛇头
    always@(posedge clk or negedge rst_n)
        if(!rst_n)  
            begin
                snack_x[0]  <= 10'd400;
                snack_y[0]  <= 10'd300;
            end
        else if(cnt_m == update_time)
            case(dir)
            right : begin  
                        if(snack_x[0] == 10'd799)   snack_x[0]  <= 10'd0;
                        else    snack_x[0] <= snack_x[0] + 10'd1;
                     end
            left : begin
                        if(snack_x[0] == 10'd0) snack_x[0]  <=  10'd799;
                        else    snack_x[0]  <=  snack_x[0]  -   10'd1;
                    end
            up  :   begin
                        if(snack_y[0] == 10'd0)   snack_y[0] <= 10'd599;
                        else snack_y[0] <= snack_y[0] - 10'd1;
                    end
            down :  begin
                        if(snack_y[0] == 10'd599) snack_y[0] <= 10'd0;
                        else snack_y[0] <= snack_y[0] + 10'd1;
                    end
            endcase
    //蛇身
    always@(posedge clk or negedge rst_n)
        if(!rst_n) 
            begin
                snack_x[1] <= 10'd0;
                snack_y[1] <= 10'd0;
                snack_x[2] <= 10'd0;
                snack_y[2] <= 10'd0;
                snack_x[3] <= 10'd0;
                snack_y[3] <= 10'd0;
                snack_x[4] <= 10'd0;
                snack_y[4] <= 10'd0;
                snack_x[5] <= 10'd0;
                snack_y[5] <= 10'd0;
                snack_x[6] <= 10'd0;
                snack_y[6] <= 10'd0;
                snack_x[7] <= 10'd0;
                snack_y[7] <= 10'd0;
                snack_x[8] <= 10'd0;
                snack_y[8] <= 10'd0;
                snack_x[9] <= 10'd0;
                snack_y[9] <= 10'd0;
                snack_x[10] <= 10'd0;
                snack_y[10] <= 10'd0;
                snack_x[11] <= 10'd0;
                snack_y[11] <= 10'd0;
            end
        else if(cnt_m == update_time)
            begin
                snack_x[1] <= snack_x[0];
                snack_y[1] <= snack_y[0];
                snack_x[2] <= snack_x[1];
                snack_y[2] <= snack_y[1];
                snack_x[3] <= snack_x[2];
                snack_y[3] <= snack_y[2];
                snack_x[4] <= snack_x[3];
                snack_y[4] <= snack_y[3];
                snack_x[5] <= snack_x[4];
                snack_y[5] <= snack_y[4];
                snack_x[6] <= snack_x[5];
                snack_y[6] <= snack_y[5];
                snack_x[7] <= snack_x[6];
                snack_y[7] <= snack_y[6];
                snack_x[8] <= snack_x[7];
                snack_y[8] <= snack_y[7];
                snack_x[9] <= snack_x[8];
                snack_y[9] <= snack_y[8];
                snack_x[10] <= snack_x[9];
                snack_y[10] <= snack_y[9];
                snack_x[11] <= snack_x[10];
                snack_y[11] <= snack_y[10];
            end
    //------------------------------------------------------------------------------
    //长度检测模块
    reg[3:0] length;
    always@(posedge clk or negedge rst_n)
        if(!rst_n) begin length <= 4'd1;drive <= 1'd0; end
        else if(drive)  drive <= 1'd0;
        else if(snack_x[0] == box_x && snack_y[0] == box_y) 
            begin
                drive <= 1'd1;
                if(length < 4'd12)  length <= length + 4'd1;
                else length <= length;
            end
    //-------------------------------------------------------------------------------
    //死亡检测模块
    //reg fin;
    always@(posedge clk or negedge rst_n)
        if(!rst_n)  fin <= 1'b0;
        else  if(snack_x[0] == snack_x[1] && snack_y[0] == snack_y[1])    fin <= 1'b1;
        else  if(snack_x[0] == snack_x[2] && snack_y[0] == snack_y[2])    fin <= 1'b1;
        else  if(snack_x[0] == snack_x[3] && snack_y[0] == snack_y[3])    fin <= 1'b1;
        else  if(snack_x[0] == snack_x[4] && snack_y[0] == snack_y[4])    fin <= 1'b1;
        else  if(snack_x[0] == snack_x[5] && snack_y[0] == snack_y[5])    fin <= 1'b1;
        else  if(snack_x[0] == snack_x[6] && snack_y[0] == snack_y[6])    fin <= 1'b1;
        else  if(snack_x[0] == snack_x[7] && snack_y[0] == snack_y[7])    fin <= 1'b1;
        else  if(snack_x[0] == snack_x[8] && snack_y[0] == snack_y[8])    fin <= 1'b1;
        else  if(snack_x[0] == snack_x[9] && snack_y[0] == snack_y[9])    fin <= 1'b1;
        else  if(snack_x[0] == snack_x[10] && snack_y[0] == snack_y[10])    fin <= 1'b1;
        else  if(snack_x[0] == snack_x[11] && snack_y[0] == snack_y[11])    fin <= 1'b1;
    //-------------------------------------------------------------------------------
    //蛇体渲染模块
	
        assign snack_r = (x_pos == snack_x[0] && y_pos == snack_y[0])||
                            (x_pos == snack_x[1] && y_pos == snack_y[1]&&length > 4'd1)||
                            (x_pos == snack_x[2] && y_pos == snack_y[2]&&length > 4'd2)||
                            (x_pos == snack_x[3] && y_pos == snack_y[3]&&length > 4'd3)||
                            (x_pos == snack_x[4] && y_pos == snack_y[4]&&length > 4'd4)||
                            (x_pos == snack_x[5] && y_pos == snack_y[5]&&length > 4'd5)||
                            (x_pos == snack_x[6] && y_pos == snack_y[6]&&length > 4'd6)||
                            (x_pos == snack_x[7] && y_pos == snack_y[7]&&length > 4'd7)||
                            (x_pos == snack_x[8] && y_pos == snack_y[8]&&length > 4'd8)||
                            (x_pos == snack_x[9] && y_pos == snack_y[9]&&length > 4'd9)||
                            (x_pos == snack_x[10] && y_pos == snack_y[10]&&length > 4'd10)||
                            (x_pos == snack_x[11] && y_pos == snack_y[11]&&length > 4'd11);
     /*
     assign snack_r = ((x_pos >= snack_x[0]-10'd3 && x_pos <= snack_x[0]+10'd3)&&(y_pos >= snack_y[0]-10'd3 && y_pos <= snack_y[0]+10'd3))||
                ((x_pos >= snack_x[1]-10'd3 && x_pos <= snack_x[1]+10'd3)&&(y_pos >= snack_y[1]-10'd3 && y_pos <= snack_y[1]+10'd3)&&length > 4'd1)||
                ((x_pos >= snack_x[2]-10'd3 && x_pos <= snack_x[2]+10'd3)&&(y_pos >= snack_y[2]-10'd3 && y_pos <= snack_y[2]+10'd3)&&length > 4'd2)||
                ((x_pos >= snack_x[3]-10'd3 && x_pos <= snack_x[3]+10'd3)&&(y_pos >= snack_y[3]-10'd3 && y_pos <= snack_y[3]+10'd3)&&length > 4'd3)||
                ((x_pos >= snack_x[4]-10'd3 && x_pos <= snack_x[4]+10'd3)&&(y_pos >= snack_y[4]-10'd3 && y_pos <= snack_y[4]+10'd3)&&length > 4'd4)||
                ((x_pos >= snack_x[5]-10'd3 && x_pos <= snack_x[5]+10'd3)&&(y_pos >= snack_y[5]-10'd3 && y_pos <= snack_y[5]+10'd3)&&length > 4'd5)||
                ((x_pos >= snack_x[6]-10'd3 && x_pos <= snack_x[6]+10'd3)&&(y_pos >= snack_y[6]-10'd3 && y_pos <= snack_y[6]+10'd3)&&length > 4'd6)||
                ((x_pos >= snack_x[7]-10'd3 && x_pos <= snack_x[7]+10'd3)&&(y_pos >= snack_y[7]-10'd3 && y_pos <= snack_y[7]+10'd3)&&length > 4'd7)||
                ((x_pos >= snack_x[8]-10'd3 && x_pos <= snack_x[8]+10'd3)&&(y_pos >= snack_y[8]-10'd3 && y_pos <= snack_y[8]+10'd3)&&length > 4'd8)||
                ((x_pos >= snack_x[9]-10'd3 && x_pos <= snack_x[9]+10'd3)&&(y_pos >= snack_y[9]-10'd3 && y_pos <= snack_y[9]+10'd3)&&length > 4'd9)||
                ((x_pos >= snack_x[10]-10'd3 && x_pos <= snack_x[10]+10'd3)&&(y_pos >= snack_y[10]-10'd3 && y_pos <= snack_y[10]+10'd3)&&length > 4'd10)||
                ((x_pos >= snack_x[11]-10'd3 && x_pos <= snack_x[11]+10'd3)&&(y_pos >= snack_y[11]-10'd3 && y_pos <= snack_y[11]+10'd3)&&length > 4'd11);
                */
endmodule