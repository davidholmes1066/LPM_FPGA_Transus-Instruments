if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.2} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "C:/Users/david/Documents/Github/LPM_FPGA_Transus-Instruments/LPM_design"
# synthesize IPs
# synthesize VMs
# synthesize top design
file delete -force -- LPM_design_LPM_design.vm LPM_design_LPM_design.ldc
if {[ catch {run_engine synpwrap -prj "LPM_design_LPM_design_synplify.tcl" -log "LPM_design_LPM_design.srf"} result options ]} {
    file delete -force -- LPM_design_LPM_design.vm LPM_design_LPM_design.ldc
    return -options $options $result
}
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o LPM_design_LPM_design_syn.udb LPM_design_LPM_design.vm] [list C:/Users/david/Documents/Github/LPM_FPGA_Transus-Instruments/LPM_design/LPM_design/LPM_design_LPM_design.ldc]

} out]} {
   runtime_log $out
   exit 1
}
