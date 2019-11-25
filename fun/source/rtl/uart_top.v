// --------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------
// 
// Author: Anlogic
// 
// Description:
//
//   ʵ�ֹ��ܣ�
//   ����PC�˷��͵�UART���ݣ�ԭ���ݷ��ظ�PC�ˣ���loopback����
// 
// Web: www.anlogic.com
// --------------------------------------------------------------------

module uart_top
#(
    parameter BPS_SET      =   96 ,  //������9600
    parameter BPS_SET_2      =   1152 ,  //������1152
    parameter CLK_PERIORD  =   40   //ʱ������40ns(25MHz)
)
(
	input 	wire	ext_clk_25m,	//�ⲿ����25MHzʱ���ź�
	input 	wire	ext_rst_n,		//�ⲿ���븴λ�źţ��͵�ƽ��Ч
    input   wire    ext_rst,        //L��λ�ź�	
	input 	wire	uart_rx,		//UART���������ź�
	output 	wire	uart_tx,			//UART���������ź�
	input   wire    uart_rx_2, 
	           
	output  wire    led_r,
	output wire     led_g,
	output wire     led_b
);										 			

//-------------------------------------
wire clk_25m;	//PLL���25MHzʱ��
wire clk_50m;	//PLL���50MHzʱ��
wire clk_100m;	//PLL���100MHzʱ��
wire sys_rst_n;	//PLL�����locked�źţ���ΪFPGA�ڲ��ĸ�λ�źţ��͵�ƽ��λ���ߵ�ƽ��������

//-------------------------------------
wire bps_start1,bps_start2,bps_start3;	//���յ����ݺ󣬲�����ʱ�������ź���λ
wire clk_bps1,clk_bps2,clk_bps3;     //clk_bps_r�ߵ�ƽΪ��������λ���м������,ͬʱҲ��Ϊ�������ݵ����ݸı�� 
wire rx_data;         //�������ݼĴ���������ֱ����һ����������
wire rx_data_2;
wire rx_data_3; 
wire rx_int;                //���������ж��ź�,���յ������ڼ�ʼ��Ϊ�ߵ�ƽ
wire rx_int_2;                //2
//-------------------------------------
//PLL����
pll_test u_pll_test
(
	.refclk		    (ext_clk_25m	),
	.reset		    (~ext_rst_n		),
	.extlock	    (sys_rst_n		),
	.clk0_out	    (clk_25m		),
	.clk1_out	    (clk_50m		),
	.clk2_out	    (clk_100m		)
);

    //UART�����źŲ���������
speed_setting
#(
	.BPS_SET	    (BPS_SET	    ),
	.CLK_PERIORD	(CLK_PERIORD    )
)
speed_rx

(	
    .clk            (clk_25m        ),	//������ѡ��ģ��
    .rst_n          (sys_rst_n      ),
    .bps_start      (bps_start1     ),
    .clk_bps        (clk_bps1       )
);

	//UART�������ݴ���
my_uart_rx	my_uart_rx
(		
	.clk            (clk_25m        ),	//��������ģ��
	.rst_n          (sys_rst_n      ),
	.uart_rx        (uart_rx        ),
	.rx_data        (rx_data        ),
	.rx_int         (rx_int         ),
	.clk_bps        (clk_bps1       ),
	.bps_start      (bps_start1     ),
	.rx_data3      (rx_data_3)
);	


		
my_uart_rx_2	my_uart_rx_2
(		
	.clk            (clk_25m        ),	//��������ģ��
	.rst_n          (sys_rst_n      ),
	.uart_rx        (uart_rx_2        ),
	.rx_data        (rx_data_2        ),
	.rx_int         (rx_int_2         ),
	.clk_bps        (clk_bps3       ),
	.bps_start      (bps_start3     )
	
	
);		
		
		
		
		
		
		
		
//-------------------------------------

	//UART�����źŲ���������													
speed_setting
#(
	.BPS_SET	    (BPS_SET_2	    ),
	.CLK_PERIORD	(CLK_PERIORD	)
)
speed_tx
(	
	.clk            (clk_25m        ),	//������ѡ��ģ��
	.rst_n          (sys_rst_n      ),
	.bps_start      (bps_start2     ),
	.clk_bps        (clk_bps2       )
);
						
	//UART�������ݴ���
my_uart_tx	my_uart_tx
(		
	.clk            (clk_25m        ),	//��������ģ��
	.rst_n          (sys_rst_n      ),
	.rx_data        (rx_data_2        ),
	.rx_int         (rx_int_2         ),
	.uart_tx        (uart_tx        ),
	.clk_bps        (clk_bps2       ),
	.bps_start      (bps_start2     )
);

speed_setting_2
#(
	.BPS_SET	    (BPS_SET_2	    ),
	.CLK_PERIORD	(CLK_PERIORD	)
)
speed_rx_1
(	
	.clk            (clk_25m        ),	//������ѡ��ģ��
	.rst_n          (sys_rst_n      ),
	.bps_start      (bps_start3     ),
	.clk_bps        (clk_bps3       )
);



rgb_tx   rgb_tx 
(
      .clk             (clk_25m    ),
      .rst_n           (ext_rst    ),//��λ
      .rx_data_1       (rx_data    ),//����
      .rx_data_2       (rx_data_2  ),//��
      .rx_data_3       (rx_data_3  ),//ʯͷ
      .led_r           (led_r      ),
      .led_g           (led_g      ),
      .led_b           (led_b      ) 
   

);







endmodule

