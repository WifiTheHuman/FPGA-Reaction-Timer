# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param chipscope.maxJobs 2
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a100tcsg324-3

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/yma82/VHDL373project/Imdoingmybest/rxnmongroup15/Countdown/Countdown.cache/wt [current_project]
set_property parent.project_path C:/Users/yma82/VHDL373project/Imdoingmybest/rxnmongroup15/Countdown/Countdown.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/yma82/VHDL373project/Thiswillwork/rxnmongroup15/Countdown/Countdown.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  {C:/Users/yma82/VHDL373project/Imdoingmybest/rxnmongroup15/ReactionTimerProject/ReactionTimerProject.srcs/sources_1/imports/VHDL Code/BCD_to_7SEG.vhd}
  {C:/Users/yma82/VHDL373project/Imdoingmybest/rxnmongroup15/VHDL Code/Blairs_clock_divider.vhd}
  C:/Users/yma82/VHDL373project/Imdoingmybest/rxnmongroup15/ReactionTimerProject/ReactionTimerProject.srcs/sources_1/new/display_div.vhd
  {C:/Users/yma82/VHDL373project/Imdoingmybest/rxnmongroup15/ReactionTimerProject/ReactionTimerProject.srcs/sources_1/imports/VHDL Code/four_bit_counter_with_clear.vhd}
  {C:/Users/yma82/VHDL373project/thismightwork/rxnmongroup15/VHDL Code/prompt_divider.vhd}
  C:/Users/yma82/VHDL373project/Imdoingmybest/rxnmongroup15/Countdown/Countdown.srcs/sources_1/new/Top_Level.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc {{C:/Users/yma82/VHDL373project/Imdoingmybest/rxnmongroup15/ReactionTimerProject/ReactionTimerProject.srcs/constrs_1/imports/VHDL Code/Nexys4DDR_Master.xdc}}
set_property used_in_implementation false [get_files {{C:/Users/yma82/VHDL373project/Imdoingmybest/rxnmongroup15/ReactionTimerProject/ReactionTimerProject.srcs/constrs_1/imports/VHDL Code/Nexys4DDR_Master.xdc}}]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top Top_Level -part xc7a100tcsg324-3


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef Top_Level.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file Top_Level_utilization_synth.rpt -pb Top_Level_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
