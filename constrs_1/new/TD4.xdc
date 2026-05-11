##set_property PACKAGE_PIN W5 [get_ports CLK]
##set_property IOSTANDARD LVCMOS33 [get_ports CLK]
##create_clock -period 10.0 [get_ports CLK]


##set_property PACKAGE_PIN U16 [get_ports {OUT[0]}]
##set_property PACKAGE_PIN E19 [get_ports {OUT[1]}]
##set_property PACKAGE_PIN U19 [get_ports {OUT[2]}]
##set_property PACKAGE_PIN V19 [get_ports {OUT[3]}]
##set_property IOSTANDARD LVCMOS33 [get_ports OUT]


##set_property PACKAGE_PIN U18 [get_ports reset]
##set_property IOSTANDARD LVCMOS33 [get_ports reset]

set_property PACKAGE_PIN W5 [get_ports CLOCK_50]
set_property IOSTANDARD LVCMOS33 [get_ports CLOCK_50]
create_clock -period 10.0 [get_ports CLOCK_50]

set_property PACKAGE_PIN U16 [get_ports {LEDR[0]}]
set_property PACKAGE_PIN E19 [get_ports {LEDR[1]}]
set_property PACKAGE_PIN U19 [get_ports {LEDR[2]}]
set_property PACKAGE_PIN V19 [get_ports {LEDR[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports LEDR]