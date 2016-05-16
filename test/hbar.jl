hbar(["G1", "G2", "G3", "G4"], [8,3,5,1], "Corr")

a = axis(
    hbar(["G1", "G2", "G3", "G4"], [3,6,2,4]),
    hbar(["G1", "G2", "G3", "G4"], [8,3,5,1])
)
save("hbar.png", a)
