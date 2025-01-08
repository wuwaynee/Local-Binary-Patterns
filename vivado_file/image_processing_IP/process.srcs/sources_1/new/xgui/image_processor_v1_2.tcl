# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "DATA_LENGTH"
  ipgui::add_param $IPINST -name "DATA_WIDTH"
  ipgui::add_param $IPINST -name "ADDR_WIDTH"

}

proc update_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to update ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to validate ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.DATA_LENGTH { PARAM_VALUE.DATA_LENGTH } {
	# Procedure called to update DATA_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_LENGTH { PARAM_VALUE.DATA_LENGTH } {
	# Procedure called to validate DATA_LENGTH
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.image_process { PARAM_VALUE.image_process } {
	# Procedure called to update image_process when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.image_process { PARAM_VALUE.image_process } {
	# Procedure called to validate image_process
	return true
}

proc update_PARAM_VALUE.input_data { PARAM_VALUE.input_data } {
	# Procedure called to update input_data when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.input_data { PARAM_VALUE.input_data } {
	# Procedure called to validate input_data
	return true
}

proc update_PARAM_VALUE.output_data { PARAM_VALUE.output_data } {
	# Procedure called to update output_data when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.output_data { PARAM_VALUE.output_data } {
	# Procedure called to validate output_data
	return true
}


proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.ADDR_WIDTH { MODELPARAM_VALUE.ADDR_WIDTH PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_WIDTH}] ${MODELPARAM_VALUE.ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.DATA_LENGTH { MODELPARAM_VALUE.DATA_LENGTH PARAM_VALUE.DATA_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_LENGTH}] ${MODELPARAM_VALUE.DATA_LENGTH}
}

proc update_MODELPARAM_VALUE.input_data { MODELPARAM_VALUE.input_data PARAM_VALUE.input_data } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.input_data}] ${MODELPARAM_VALUE.input_data}
}

proc update_MODELPARAM_VALUE.image_process { MODELPARAM_VALUE.image_process PARAM_VALUE.image_process } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.image_process}] ${MODELPARAM_VALUE.image_process}
}

proc update_MODELPARAM_VALUE.output_data { MODELPARAM_VALUE.output_data PARAM_VALUE.output_data } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.output_data}] ${MODELPARAM_VALUE.output_data}
}

