Megafunctions
  Set Generate Netlist to CHECKED.

Disable Advanced Fitter
  Assignments => Settings => Compiler Settings => Advanced Settings (Fitter)
  Set "Advanced Physical Optimization" from ON to OFF.

Never do Final Placement Optimizations
  Assignments => Settings => Compiler Settings => Advanced Settings (Fitter)
  Set "Final Placement Optimizations" from Automatically to Never.

Never do Final Aggressive Routability Optimizations
  Assignments => Settings => Compiler Settings => Advanced Settings (Fitter)
  Set "Final Agreesive Routability Optimizations" from Automatically to Never.

Use Fast Fitter Effort
  Assignments => Settings => Compiler Settings => Advanced Settings (Fitter)
  Set "Fitter Effort" from Auto Fit to Fast Fit.

Enable Smart Compilation
  Assignments => Settings => Compilation Process Settings
  Set "Use smart compilation" to CHECKED.

Select Performance ad optimization mode
  Assignments => Settings => Compiler Settings Settings
  Set "Optimization mode" from Balanced to Performance (High effort -increase runtime).

Optimize Timing
  Assignments => Settings => Compiler Settings => Advanced Settings (Fitter)
  Set "Optimize Timing" from Normal Compilation to Off
  Set "Optimize Multi-Corner Timing" from On to Off


# Quartus, gitignore

# ignore Quartus II generated folders
db/
incremental_db/
simulation/
timing/
testbench/
*_sim/
incremental_db/
greybox_tmp/
output_files/