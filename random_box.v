module random_box(
    input clk,
    input rst_n,
    input drive,
    output wire[9:0]box_x,
    output wire[9:0]box_y
    );
    //---------------------------------------------------------------------------------
    //随机数生成模块
    wire [8:0]rand_num;
    random U1_random(
            .clk(clk),
            .rst_n(rst_n),
            // .seed(seed),
            //.load(load),
            .rand_num(rand_num)
            );
    //随机盒子创建
    wire [9:0]rand_x;
    wire [9:0]rand_y;
   // wire rand_drive;//随机小方块激励模块
    box_create U1_box_create(
                    .clk(clk),
                    .rst_n(rst_n),
                    .rand_num(rand_num),
                    .rand_drive(drive),
                    .rand_x(rand_x),
                    .rand_y(rand_y)
                    );
      assign box_x = (rand_x>>4)*18+12;
      assign box_y = (rand_x>>4)*18+12;
    
    

endmodule