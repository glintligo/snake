module vga_display(
    input             vga_clk,                  //VGA驱动时钟
    input             sys_rst_n,                //复位信号
    
    input      [ 10:0] pixel_xpos,               //像素点横坐标
    input      [ 10:0] pixel_ypos,               //像素点纵坐标    
    output reg [15:0] pixel_data,                //像素点数据
	 input [9:0]box_x,
    input [9:0]box_y,
	input  snack_r
    );    
    
parameter  H_DISP = 11'd800;                    //分辨率——行
parameter  V_DISP = 11'd600;                    //分辨率——列
localparam WHITE  = 16'b11111_111111_11111;     //RGB565 白色
localparam BLACK  = 16'b00000_000000_00000;     //RGB565 黑色
localparam RED    = 16'b11111_000000_00000;     //RGB565 红色
localparam GREEN  = 16'b00000_111111_00000;     //RGB565 绿色
localparam BLUE   = 16'b00000_000000_11111;     //RGB565 蓝色
    
//*****************************************************
//**                    main code
//*****************************************************
//给不同的区域绘制不同的颜色
localparam BLOCK_W = 10'd10;                    //方块宽度

always @(posedge vga_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) 
        pixel_data <= BLACK;
    else
        if ((pixel_xpos < 11'd12) || (pixel_xpos >= 11'd588) || (pixel_ypos < 11'd12) || (pixel_ypos >= 11'd588))
            pixel_data <= BLACK;               //绘制边框为蓝色
        else
        if((pixel_xpos >= box_x+10'd3) && (pixel_xpos <= box_x + 10'd15)
          && (pixel_ypos >= box_y+10'd3) && (pixel_ypos <= box_y + 10'd15))
            pixel_data <= BLUE;                //绘制方块为黑色
        else
        if (snack_r)
            pixel_data <= RED;
        else
            pixel_data <= WHITE;                //绘制背景为白色
end

endmodule 
