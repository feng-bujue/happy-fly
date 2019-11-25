module speed_setting
#(
    parameter BPS_SET      =   96 ,  //������
    parameter CLK_PERIORD  =   40   //ʱ������40ns(25MHz)
)
(
	input	clk,		//25MHz��ʱ��
	input	rst_n,		//�͵�ƽ��λ�ź�
	input	bps_start,	//���յ����ݺ󣬲�����ʱ�������ź���λ
	output	clk_bps		//clk_bps�ĸߵ�ƽΪ���ջ��߷�������λ���м������
);

`define BPS_PARA	(10_000_000/CLK_PERIORD/BPS_SET)	//10_000_000/`CLK_PERIORD/96;
`define BPS_PARA_2	(`BPS_PARA/2)						//BPS_PARA/2;	

reg	[12:0] cnt;		    //��Ƶ����
reg clk_bps_r;	        //������ʱ�ӼĴ���
reg	[2:0] uart_ctrl;	//uart������ѡ��Ĵ���

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cnt <= 13'd0;
	else if((cnt == `BPS_PARA) || !bps_start)
        cnt <= 13'd0;	    //�����ʼ�������
	else
        cnt <= cnt + 1'b1;  //������ʱ�Ӽ�������
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
        clk_bps_r <= 1'b0;
	else if(cnt == `BPS_PARA_2)
        clk_bps_r <= 1'b1;			//clk_bps_r�ߵ�ƽΪ��������λ���м������,ͬʱҲ��Ϊ�������ݵ����ݸı��
	else
        clk_bps_r <= 1'b0;
end

assign clk_bps = clk_bps_r;



endmodule

