
plot(
    violin(["G1", "G2", "G3", "G4"], [rand(10) for i in 1:4], "InvCorr"),
    violin(["G1", "G2", "G3", "G4"], [rand(10) for i in 1:4], "Corr")
)
