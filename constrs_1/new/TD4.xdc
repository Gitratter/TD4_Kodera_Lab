##clk
set_property IOSTANDARD LVCMOS33 [get_ports CLK]
set_property PACKAGE_PIN W5 [get_ports CLK]
create_clock -add -name sys_clk_pin -period 10.00 -waveform{0 5}[get_ports CLK]

##reset
set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property PACKAGE_PIN U18 [get_ports reset]

##IN
set_property PACKAGE_PIN V17 [get_ports {IN[0]}]
set_property PACKAGE_PIN V16 [get_ports {IN[1]}]
set_property PACKAGE_PIN W16 [get_ports {IN[2]}]
set_property PACKAGE_PIN W17 [get_ports {IN[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports IN[*]]

##OUT
set_property PACKAGE_PIN U16 [get_ports {OUT[0]}]
set_property PACKAGE_PIN E19 [get_ports {OUT[1]}]
set_property PACKAGE_PIN U19 [get_ports {OUT[2]}]
set_property PACKAGE_PIN V19 [get_ports {OUT[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports OUT[*]]

##clksel
set_property IOSTANDARD LVCMOS33 [get_ports clksel]
set_property PACKAGE_PIN W15 [get_ports clksel]
