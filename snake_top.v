module snake_top(	
	input                       clk,
	input                       rst_n,
	input 							key_r,
   input 							key_l,
   input 							key_u,
   input 							key_d,
	//vga output        
    output          vga_hs,         //行同步信号
    output          vga_vs,         //场同步信号
    output  [15:0]  vga_rgb         //红绿蓝三原色输出 
	);
//    input clk,rst_n,centerbt,upbt,downbt,rightbt,leftbt;
//    output hsync,vsync;
//    output[3:0] vga_r,vga_g,vga_b;
	 
	 
//      wire[1:0] game_status;
////    wire snake,strike_itself,strike_wall;
////    wire[9:0] x_pos,y_pos;
//    wire[9:0] head_x, head_y;
//    wire[9:0] apple_x,apple_y;
//    wire apple,apple_refresh;
    
//    game_control G(clk,rst_n,centerbt,strike_itself,strike_wall,game_status);
//    
//    VGA V(game_status,clk,rst_n,snake,apple,upbt,downbt,rightbt,leftbt,x_pos,y_pos,vga_r,vga_g,vga_b,hsync,vsync);
//    
//    snake_control S(game_status,clk,upbt,downbt,rightbt,leftbt,x_pos,y_pos,apple_x,apple_y,apple_refresh,snake,head_x,head_y,strike_itself,strike_wall);
//    



wire[9:0]box_x;
wire[9:0]box_y;
//--------------------------------------------------------------------------------
//蛇身控制模块，蛇是红色的
wire drive;
wire snack_r;


wire            video_clk;
wire [15:0]  	 pixel_data_w;          //像素点数据
wire [ 10:0]  	 pixel_xpos_w;          //像素点横坐标
wire [ 10:0]     pixel_ypos_w;          //像素点纵坐标 

video_pll video_pll_m0(
	.inclk0       (clk),
	.c0           (video_clk),
);


vga_driver u_vga_driver(
    .vga_clk        (video_clk),    
    .sys_rst_n      (rst_n),    

    .vga_hs         (vga_hs),       
    .vga_vs         (vga_vs),       
    .vga_rgb        (vga_rgb),      
    
    .pixel_data     (pixel_data_w), 
    .pixel_xpos     (pixel_xpos_w), 
    .pixel_ypos     (pixel_ypos_w)
    ); 
    
vga_display u_vga_display(
    .vga_clk        (video_clk),
    .sys_rst_n      (rst_n),
    
    .pixel_xpos     (pixel_xpos_w),
    .pixel_ypos     (pixel_ypos_w),
    .pixel_data     (pixel_data_w),
	 .box_x          (box_x),
	 .box_y          (box_y),
	 .snack_r        (snack_r)
    );  


snack_control u1_snack_control(
	.clk(video_clk),
	.rst_n(rst_n),
	.key_r(key_r),
	.key_l(key_l),
	.key_u(key_u),
	.key_d(key_d),
	.box_x(box_x),
	.box_y(box_y),
	.x_pos(pixel_xpos_w),
	.y_pos(pixel_ypos_w),
	.drive(drive),
	.snack_r(snack_r)
	);
//--------------------------------------------------------------------------------
//box生成模块
random_box u1_random_box(
	.clk(video_clk),
	.rst_n(rst_n),
	.drive(drive),//生成驱动信号
	.box_x(box_x),//坐标信号
	.box_y(box_y)
  );
////-------------------------------------------------------------------------------- 

endmodule