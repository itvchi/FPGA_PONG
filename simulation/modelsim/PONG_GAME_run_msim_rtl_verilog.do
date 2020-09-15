transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/itvchi/Pulpit/PONG {/home/itvchi/Pulpit/PONG/layer0.v}
vlog -vlog01compat -work work +incdir+/home/itvchi/Pulpit/PONG {/home/itvchi/Pulpit/PONG/color_mixer.v}
vlog -vlog01compat -work work +incdir+/home/itvchi/Pulpit/PONG {/home/itvchi/Pulpit/PONG/data_enable.v}
vlog -vlog01compat -work work +incdir+/home/itvchi/Pulpit/PONG {/home/itvchi/Pulpit/PONG/ROM_2PORT.v}
vlog -vlog01compat -work work +incdir+/home/itvchi/Pulpit/PONG {/home/itvchi/Pulpit/PONG/layer1.v}
vlog -vlog01compat -work work +incdir+/home/itvchi/Pulpit/PONG {/home/itvchi/Pulpit/PONG/lcd_driver.v}
vlog -vlog01compat -work work +incdir+/home/itvchi/Pulpit/PONG {/home/itvchi/Pulpit/PONG/clk_div4.v}
vlog -vlog01compat -work work +incdir+/home/itvchi/Pulpit/PONG {/home/itvchi/Pulpit/PONG/PONG_GAME.v}
vlog -vlog01compat -work work +incdir+/home/itvchi/Pulpit/PONG {/home/itvchi/Pulpit/PONG/PLL.v}
vlog -vlog01compat -work work +incdir+/home/itvchi/Pulpit/PONG {/home/itvchi/Pulpit/PONG/RAM_2PORT.v}
vlog -vlog01compat -work work +incdir+/home/itvchi/Pulpit/PONG/db {/home/itvchi/Pulpit/PONG/db/PLL_altpll.v}

vlog -vlog01compat -work work +incdir+/home/itvchi/Pulpit/PONG {/home/itvchi/Pulpit/PONG/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all
