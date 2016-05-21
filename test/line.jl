line([1, 2, 3, 4], [8,3,5,1], "Corr")

line([1, 2, 3, 4], [8,3,5,1], "Corr", vlinewidth=[1,2,1,3])

axis(
    line([1, 2, 3, 4], [3,6,2,4], "InvCorr"),
    line([1, 2, 3, 4], [8,3,5,1], "Corr")
)
