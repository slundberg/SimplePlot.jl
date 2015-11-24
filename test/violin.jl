

# only test this if the system's matplotlib version supports it
fig,ax = PyPlot.subplots(figsize=(5, 4))
if haskey(ax, :violinplot)
    plot(
        violin(["G1", "G2", "G3", "G4"], [rand(10) for i in 1:4], "InvCorr"),
        violin(["G1", "G2", "G3", "G4"], [rand(10) for i in 1:4], "Corr")
    )
else
    warn("Skipping violin() test because the installed version of matplotlib does not support it...")
end
