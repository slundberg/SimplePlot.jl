bar(["G1", "G2", "G3", "G4"], [8,3,5,1], "Corr")

a = axis(
    bar(["G1", "G2", "G3", "G4"], [3,6,2,4], "InvCorr"),
    bar(["G1", "G2", "G3", "G4"], [8,3,5,1], "Corr")
)
save("bar.png", a)
