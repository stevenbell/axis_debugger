
`timescale 1 ns / 1 ps

  module axis_debugger #
  (
    parameter integer  C_AXIS_BYTEWIDTH = 4,

    // Parameters of Axi Slave Bus Interface S_AXI_LITE
    parameter integer C_S_AXI_LITE_DATA_WIDTH  = 32,
    parameter integer C_S_AXI_LITE_ADDR_WIDTH  = 5
  )
  (
    // Input stream
    input wire  input_s_axis_tvalid,
    input wire [(C_AXIS_BYTEWIDTH*8)-1: 0] input_s_axis_tdata,
    input wire [C_AXIS_BYTEWIDTH-1: 0] input_s_axis_tstrb,
    input wire  input_s_axis_tlast,
    output wire  input_s_axis_tready,
  
    // Output stream
    output wire  output_m_axis_tvalid,
    output wire [(C_AXIS_BYTEWIDTH*8)-1: 0] output_m_axis_tdata,
    output wire [C_AXIS_BYTEWIDTH-1: 0] output_m_axis_tstrb,
    output wire  output_m_axis_tlast,
    input wire  output_m_axis_tready,

    // AXI-lite control interface
    input wire  s_axi_lite_aclk,
    input wire  s_axi_lite_aresetn,
    input wire [C_S_AXI_LITE_ADDR_WIDTH-1 : 0] s_axi_lite_awaddr,
    input wire [2 : 0] s_axi_lite_awprot,
    input wire  s_axi_lite_awvalid,
    output wire  s_axi_lite_awready,
    input wire [C_S_AXI_LITE_DATA_WIDTH-1 : 0] s_axi_lite_wdata,
    input wire [(C_S_AXI_LITE_DATA_WIDTH/8)-1 : 0] s_axi_lite_wstrb,
    input wire  s_axi_lite_wvalid,
    output wire  s_axi_lite_wready,
    output wire [1 : 0] s_axi_lite_bresp,
    output wire  s_axi_lite_bvalid,
    input wire  s_axi_lite_bready,
    input wire [C_S_AXI_LITE_ADDR_WIDTH-1 : 0] s_axi_lite_araddr,
    input wire [2 : 0] s_axi_lite_arprot,
    input wire  s_axi_lite_arvalid,
    output wire  s_axi_lite_arready,
    output wire [C_S_AXI_LITE_DATA_WIDTH-1 : 0] s_axi_lite_rdata,
    output wire [1 : 0] s_axi_lite_rresp,
    output wire  s_axi_lite_rvalid,
    input wire  s_axi_lite_rready
  );

  wire[31:0] byte_count;
  wire[31:0] tlast_count;

  streamcounter # (
    .C_AXIS_BYTEWIDTH(C_AXIS_BYTEWIDTH)
  ) streamcounter_inst (
    .clk(s_axi_lite_aclk),
    .resetn(s_axi_lite_aresetn),
  
    // Input stream
    .input_s_axis_tvalid(input_s_axis_tvalid),
    .input_s_axis_tdata(input_s_axis_tdata),
    .input_s_axis_tstrb(input_s_axis_tstrb),
    .input_s_axis_tlast(input_s_axis_tlast),
    .input_s_axis_tready(input_s_axis_tready),
  
    // Output stream
    .output_m_axis_tvalid(output_m_axis_tvalid),
    .output_m_axis_tdata(output_m_axis_tdata),
    .output_m_axis_tstrb(output_m_axis_tstrb),
    .output_m_axis_tlast(output_m_axis_tlast),
    .output_m_axis_tready(output_m_axis_tready),
  
    // Report registers
    .byte_count(byte_count),
    .tlast_count(tlast_count)
  );


  // Instantiate control interface
  axis_debugger_controlregs # ( 
    .C_S_AXI_DATA_WIDTH(C_S_AXI_LITE_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_LITE_ADDR_WIDTH)
  ) axis_debugger_controlregs_inst (
    .S_AXI_ACLK(s_axi_lite_aclk),
    .S_AXI_ARESETN(s_axi_lite_aresetn),
    .S_AXI_AWADDR(s_axi_lite_awaddr),
    .S_AXI_AWPROT(s_axi_lite_awprot),
    .S_AXI_AWVALID(s_axi_lite_awvalid),
    .S_AXI_AWREADY(s_axi_lite_awready),
    .S_AXI_WDATA(s_axi_lite_wdata),
    .S_AXI_WSTRB(s_axi_lite_wstrb),
    .S_AXI_WVALID(s_axi_lite_wvalid),
    .S_AXI_WREADY(s_axi_lite_wready),
    .S_AXI_BRESP(s_axi_lite_bresp),
    .S_AXI_BVALID(s_axi_lite_bvalid),
    .S_AXI_BREADY(s_axi_lite_bready),
    .S_AXI_ARADDR(s_axi_lite_araddr),
    .S_AXI_ARPROT(s_axi_lite_arprot),
    .S_AXI_ARVALID(s_axi_lite_arvalid),
    .S_AXI_ARREADY(s_axi_lite_arready),
    .S_AXI_RDATA(s_axi_lite_rdata),
    .S_AXI_RRESP(s_axi_lite_rresp),
    .S_AXI_RVALID(s_axi_lite_rvalid),
    .S_AXI_RREADY(s_axi_lite_rready),
    .byte_count(byte_count),
    .tlast_count(tlast_count)
  );

  endmodule
